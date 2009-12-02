package
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.media.*;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	
	public class Main extends MovieClip
	{
		/* Game variables */
		public const GRAVITY = 2; 
		public var tutorialShown:Boolean;
		public var level:int;
		public var done:Boolean = false; // True if the player dies or finishes the level.
		public var levelCleared:Boolean = false; // Only true if the level is finished.
		public var endScreen:MovieClip;
		public var killCount:int;
		public var accuracy:Number;
		
		/* Sound variables */
		private var music:Sound;
		private var musicChannel:SoundChannel;
		private var song:String;
		
		/* Level graphics and variables */
		public var bg:MovieClip;
		public var mg:MovieClip;
		
		public const NUM_FOREGROUNDS = 4;
		public var fg1:MovieClip;
		public var fg2:MovieClip;
		public var fg3:MovieClip;	
		public var fg4:MovieClip;
		
		public var tutorial:MovieClip;
		public var cursor:MovieClip;
		public var lowerBoundary:Number;
		public var upperBoundary:Number;
		public var scrollAllowed:Boolean;
		public var endTimer:Timer;
		
		/* HUD graphics */
		public var lifeBar:MovieClip;
		public var weaponPanel:MovieClip;
	
		/* Wizard variables */
		public var wizard:MovieClip;
		public var haltMovement:Boolean = false;
		public var leftButton:Boolean = false;
		public var rightButton:Boolean = false;
		public var upButton:Boolean = false;
		public var downButton:Boolean = false;
		public var jumpButton:Boolean = false;
		
		/* Boss variables */
		public var boss:MovieClip;
		public var bossHUD:MovieClip;
		public var maxLifebar:Number;
		public var bossSpawned:Boolean;
		public var bossDead:Boolean;
	
		/* Enemy variables */
		public const ENEMY_DAMAGE = 0.5;
		public const ATTACK_RANGE = 20;
		public var Y_OFFSET = 15; // Because Robert didn't set the zombie's registration point to be (0,0)...
		public var MAX_ENEMIES = 5;
		public var zombies = new Array(MAX_ENEMIES);
		
		public function Main() 
		{						
			var intro = new Credits();
			addChild(intro); // Credits calls showTitleScreen() when done playing.
		}
		
		public function showTitleScreen(): void
		{
			Mouse.show();
			var titleScreen = new TitleScreen();
			addChild(titleScreen); // TitleScreen calls startGame() when Play is clicked.
		}
		
		public function startGame(): void
		{
			Mouse.hide();
			level = 1;
			playInterlude("Intro");
		}
		
		private function playInterlude(className:String): void
		{
			stage.frameRate = 12;
			playMusic("WWaGIntro");
			var Story:Class = getDefinitionByName(className) as Class;
			addChild(new Story() as Interlude); // Interlude calls beginLevel() when done playing.
		}
		
		public function beginLevel(): void
		{
			stage.frameRate = 16;
			stage.focus = null; // Makes key listeners work without an initial mouse click.
			scrollAllowed = true;
			killCount = 0;
			
			setupGraphics();
			stopMusic();
			if (level == 3)
				Y_OFFSET = 0; // Not necessary in level 3 since the enemies are ostriches (not zombies).
			
			if (level == 1 && !tutorialShown) {
				enterTutorial();
			} else { 
				createHUD();
				playMusic("WWaG" + String(level));
				stage.addEventListener(Event.ENTER_FRAME, enterGameLoop);
			}
		}
		
		private function setupGraphics(): void
		{
			createBackground();
			createGround();						
			createWizard();
			createForeground();
			createCursor();
		}
		
		private function createBackground(): void
		{
			var Background:Class = getDefinitionByName("Background" + String(level)) as Class;
			bg = new Background() as MovieClip;			
			bg.x = 0;
			bg.y = 0; 
			addChildAt(bg, 0);
		}
		
		private function createGround(): void
		{
			var Mainground:Class = getDefinitionByName("Mainground" + String(level)) as Class;
			mg = new Mainground() as MovieClip;	
			mg.x = 0;
			if (level == 1) {
				mg.y = 0;
				upperBoundary = 325;			
			} else if (level == 2) {
				mg.y = 0;
				upperBoundary = 365;
			} else {
				mg.y = 320.9;
				upperBoundary = 320.9;
			}
			lowerBoundary = stage.stageHeight;
			addChild(mg);
		}
		
		private function createWizard(): void
		{
			wizard = new Wizard(lowerBoundary, upperBoundary);
			wizard.x = (stage.stageWidth / 2) - 100; // Start the player a little left of center.
			wizard.y = wizard.baseY = 340; 
			addChild(wizard);
			
			stage.addEventListener(MouseEvent.CLICK, onDownMouse);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onDownKey);
			stage.addEventListener(KeyboardEvent.KEY_UP, onUpKey);
		}
		
		private function createForeground(): void
		{
			var Foreground:Class = getDefinitionByName("Foreground" + String(level)) as Class;
			for (var i = 1; i < NUM_FOREGROUNDS + 1; i++) {
				var fg:String = "fg" + String(i);
				this[fg] = new Foreground() as MovieClip;			
				this[fg].x = 0 + (this[fg].width * (i - 1));
				if (level == 1) {
					this[fg].y = 20;
					this[fg].alpha = 0.4;
				} else if (level == 2) {
					this[fg].y = 0;
					this[fg].alpha = 0.6;
				} else { 
					this[fg].y = 144;
					this[fg].alpha = 0.8;
				}
				addChild(this[fg]);
			}
		}
		
		private function createCursor(): void 
		{
			cursor = new Cursor();
			addChild(cursor);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, followMouse);
			function followMouse(e:MouseEvent): void {
				cursor.x = mouseX;
				cursor.y = mouseY;
			}
		}
		
		private function enterTutorial(): void
		{
			var tutorial = new Tutorial();
			addChild(tutorial);
			tutorial.addEventListener(MouseEvent.CLICK, onReadyToPlay);
			
			function onReadyToPlay(): void {
				tutorial.removeEventListener(MouseEvent.CLICK, onReadyToPlay);
				removeChild(tutorial);
				
				tutorialShown = true;
				createHUD();
				playMusic("WWaG" + String(level));
				stage.addEventListener(Event.ENTER_FRAME, enterGameLoop);
			}
		}
		
		private function createHUD(): void
		{
			lifeBar = new LifeBar();
			lifeBar.scaleX = lifeBar.scaleY = 0.35;
			lifeBar.x = 10;
			lifeBar.y = 10;
			addChild(lifeBar);
			
			weaponPanel = new WeaponPanel();
			weaponPanel.scaleX = weaponPanel.scaleY = 0.35;
			weaponPanel.x = stage.stageWidth - weaponPanel.width - 20;
			weaponPanel.y = 24;
			addChild(weaponPanel);
		}
		
		private function enterGameLoop(e:Event): void
		{
			try {
				if (wizard.HP <= 0 && !done) 
					showEndScreen();
			} catch (error) {}
			
			manageEnemies();
			
			if (!done) {
				resetObjectDepths();
				scrollStage();
				setWizardMovement();
			}
		}
		
		private function setWizardMovement(): void
		{
			if (wizard.x >= (stage.stageWidth - 350) && scrollAllowed) {
				haltMovement = true;
			} else {
				haltMovement = false;
				if ((level != 2 || bossDead) && wizard.x > stage.stageWidth) {
					levelCleared = true;
					showEndScreen();
				}
			}
		}
		
		private function scrollStage(): void
		{			
			if (haltMovement && rightButton) {
				if (mg.x > (stage.stageWidth - mg.width + 20)) {
					bg.x -= wizard.xSpeed / 2;
					mg.x -= wizard.xSpeed;
					
					for (var i = 1; i < NUM_FOREGROUNDS + 1; i++) 
						this["fg" + String(i)].x -= wizard.xSpeed * 3;
				
					/* Speed up enemies if the stage is scrolling. */
					for (i = 0; i < MAX_ENEMIES; i++) {
						if (zombies[i]) 
							zombies[i].CURRENT_xSpeed = zombies[i].xSpeed * 4;
					}
				} else {
					scrollAllowed = false;
					if (level == 2 && !bossSpawned) 
						spawnBoss();
				}
				
			/* Reset enemy speed if not scrolling. */
			} else {
				for (var j = 0; j < MAX_ENEMIES; j++) {
					if (zombies[j]) 
						zombies[j].CURRENT_xSpeed = zombies[j].xSpeed;
				}
			}
		}
		
		private function spawnBoss(): void
		{
			boss = new Chippy(lowerBoundary, upperBoundary);
			boss.scaleX = 2.75;
			boss.scaleY = 2.5;
			boss.x = stage.stageWidth + 25;
			boss.y = stage.stageHeight - boss.height - 50;
			addChild(boss);
			
			bossHUD = new ChippyHUD();
			bossHUD.scaleX = 0.6;
			bossHUD.scaleY = 0.2;
			bossHUD.x = (stage.stageWidth / 2) - (bossHUD.width / 2);
			bossHUD.y = stage.stageHeight - bossHUD.height - 20;
			addChild(bossHUD);
			
			maxLifebar = bossHUD.getChildAt(0).width;
			bossSpawned = true;
		}
		
		private function manageEnemies(): void
		{
			for (var i = 0; i < MAX_ENEMIES; i++) 
			{				
				/* Spawn an enemy if necessary. */
				if (zombies[i] == null) {
					if (scrollAllowed && !done) {
						var enemy;
						switch (level) {
						
						/* Level 1 features a mix of zombies and ostriches. */
						case 1: 
							if (Math.random() < 0.5) 
								enemy = spawnZombie();
							else
								enemy = spawnOstrich();
							break;
							
						/* Level 2 is zombie-exclusive (not including Chippy). */
						case 2:
							enemy = spawnZombie();
							break;
							
						/* Level 3 is nothing but ostriches. */
						case 3:
							enemy = spawnOstrich();
						}
						
						enemy.x = stage.stageWidth + enemy.width; // Make sure it spawns off-stage. 
						enemy.y = (Math.random() * (lowerBoundary - upperBoundary)) + upperBoundary - enemy.height + Y_OFFSET; 
						zombies[i] = enemy;
						addChild(enemy);
						setEnemyDepth(i);
					}
					
				/* Damage the wizard if an enemy is hitting him. */
				} else if (HitDetect.isColliding(wizard, zombies[i], this, true) && inAttackRange(i) && !done) {
					wizard.HP -= ENEMY_DAMAGE;
				
				/* Remove an enemy if it's off-stage. */
				} else if (zombies[i].x <= -zombies[i].width) {
					zombies[i].remove();
					delete zombies[i];
				}
			}
		}
		
		private function spawnZombie(): Zombie
		{
			var enemy = new Zombie();
			enemy.scaleX = 0.325;
			enemy.scaleY = 0.25;
			return enemy;
		}
		
		private function spawnOstrich(): Ostrich
		{
			var enemy = new Ostrich();
			enemy.scaleX = 0.5;
			enemy.scaleY = 0.5;
			enemy.xSpeed = 10;
			return enemy;
		}
		
		private function setEnemyDepth(j:int): void
		{
			var back = null;
			var front = null;
			
			for (var i = 0; i < MAX_ENEMIES; i++) {
				if (zombies[i] != null) {
					
					/* Look for the closest enemy behind the new one. */
					if (zombies[i].y < zombies[j].y) {
						if (back) {
							if (zombies[i].y > back.y)
								back = zombies[i];
						} else 
							back = zombies[i];
						
					/* Look for the closest enemy in front of the new one. */
					} else if (zombies[i].y > zombies[j].y) {
						if (front) {
							if (zombies[i].y < front.y)
								front = zombies[i];
						} else 
							front = zombies[i];
					}				
				}
			}
			if (back) 
				setChildIndex(zombies[j], getChildIndex(back) + 1);
			else if (front)
				setChildIndex(zombies[j], getChildIndex(front));
			else
				setChildIndex(zombies[j], numChildren - 1);
		}
		
		private function inAttackRange(i:int): Boolean 
		{
			return Math.abs((wizard.baseY + wizard.height) - (zombies[i].y - Y_OFFSET + zombies[i].height)) < ATTACK_RANGE;
		}
		
		private function resetObjectDepths(): void
		{		
			try {
				for (var i = 1; i < NUM_FOREGROUNDS + 1; i++) 
					setChildIndex(this["fg" + String(i)], numChildren - 1);
				if (bossHUD) 
					setChildIndex(bossHUD, numChildren - 1);
				setChildIndex(cursor, numChildren - 1);
			} catch (error) {}
		}
		
		private function showEndScreen(): void
		{
			done = true;
			removeEventListeners();
			
			/* The player beat the level! */
			if (wizard.HP > 0) {
				accuracy = Math.round((killCount/(wizard.maxAmmo - wizard.ammoLeft)) * 100);
				if (accuracy > 100)
					accuracy = 100;
				endScreen = new EndScreen(killCount, accuracy);
				wizard.remove();
				addChild(endScreen);
				
				/* Give them 5 seconds to look at their stats before moving on. */
				endTimer = new Timer(5000);
				endTimer.addEventListener(TimerEvent.TIMER, onTimerUp);
				function onTimerUp(e:TimerEvent): void {
					endTimer.removeEventListener(TimerEvent.TIMER, onTimerUp);
					stage.removeEventListener(Event.ENTER_FRAME, enterGameLoop);
					stopMusic();
					
					/* Clear everything off the stage and reset. */
					removeChild(endScreen);
					clearStage();
					resetLevel();
				}
				endTimer.start();
				
			/* The player died! */
			} else { 
				wizard.remove();
				addChild(new DeadScreen());
			}
		}
		
		public function resetLevel(): void 
		{
			done = false;
			clearStage();
			
			/* Reset movement variables. */
			leftButton = false;
			rightButton = false;
			upButton = false;
			downButton = false;
			jumpButton = false;
			haltMovement = false;
			bossSpawned = false;
			bossDead = false;
			
			if (levelCleared) {
				level++;
				levelCleared = false;
				if (level <= 3)
					playInterlude("Transition" + String(level - 1));
				else
					playInterlude("Ending");
			} else 
				beginLevel(); 
		}
		
		public function playMusic(songName:String): void
		{
			song = songName;
			var LevelMusic:Class = getDefinitionByName(song) as Class;
			music = new LevelMusic() as Sound;			
			musicChannel = music.play();
			musicChannel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
		}

		private function loopMusic(e:Event): void 
		{
			if (musicChannel != null) {
				musicChannel.removeEventListener(Event.SOUND_COMPLETE, loopMusic);
				playMusic(song);
			}
		}
		
		public function stopMusic(): void
		{
			if (musicChannel != null) {
				musicChannel.stop();
				musicChannel.removeEventListener(Event.SOUND_COMPLETE, loopMusic);
			}
		}
		
		private function onDownMouse(e:MouseEvent): void
		{
			if (!done)
				wizard.fire();
		}
		
		private function onDownKey(e:KeyboardEvent): void 
		{
			if (e.keyCode == Keyboard.LEFT) leftButton = true;
			else if (e.keyCode == Keyboard.RIGHT) rightButton = true;
			else if (e.keyCode == Keyboard.UP) upButton = true;
			else if (e.keyCode == Keyboard.DOWN) downButton = true;
			else if (e.keyCode == Keyboard.CONTROL) jumpButton = true;
		}
		
		private function onUpKey(e:KeyboardEvent): void
		{
			if (e.keyCode == Keyboard.LEFT) leftButton = false;
			else if (e.keyCode == Keyboard.RIGHT) rightButton = false;
			else if (e.keyCode == Keyboard.UP) upButton = false;
			else if (e.keyCode == Keyboard.DOWN) downButton = false;
			else if (e.keyCode == Keyboard.CONTROL) jumpButton = false;
		}
		
		private function removeEventListeners(): void
		{
			stage.removeEventListener(MouseEvent.CLICK, onDownMouse);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onDownKey);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onUpKey);
		}
		
		private function clearStage(): void
		{
			/* Remove the HUD. */
			try {
				lifeBar.remove();
				weaponPanel.remove();
			} catch (error) {}

			/* Remove any remaining zombies. */
			for (var i = 0; i < MAX_ENEMIES; i++) {				
				if (zombies[i]) {
					zombies[i].remove();
					delete zombies[i];
				}
			}
			
			/* Remove the boss. */
			if (bossSpawned && !bossDead) 
				boss.remove();
			
			/* Remove all remaining children on stage. */
			while (numChildren > 0) { 
				removeChildAt(0); 
				if (numChildren == 0) 
					break;
			}
		}
	}
}