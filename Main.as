package
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.media.*;
	import flash.ui.Keyboard;
	
	public class Main extends MovieClip
	{
		public const GRAVITY = 2; 
		
		private var music:Sound = new Sound();
		private var musicChannel:SoundChannel;
		
		public var leftButton:Boolean = false;
		public var rightButton:Boolean = false;
		public var upButton:Boolean = false;
		public var downButton:Boolean = false;
		public var jumpButton:Boolean = false;
		
		public var bg:MovieClip;
		public var mg:MovieClip;
		public var fg1:MovieClip;
		public var fg2:MovieClip;
		public var fg3:MovieClip;
		
		public var wizard:MovieClip;
		public var haltMovement:Boolean = false;
		
		public function Main() 
		{						
			createBackground();
			createGround();						
			createWizard();
			createForeground();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onDownKey);
			stage.addEventListener(KeyboardEvent.KEY_UP, onUpKey);
			this.addEventListener(Event.ENTER_FRAME, scrollStage);
			
			//playMusic();
		}
		
		private function createBackground(): void
		{
			bg = new Background1;
			bg.x = 0;
			bg.y = 0; 
			addChildAt(bg, 0);
		}
		
		private function createGround(): void
		{
			mg = new Mainground1;
			mg.x = 0;
			mg.y = 0;
			addChild(mg);
		}
		
		private function createWizard(): void
		{
			wizard = new Wizard(stage.stageHeight, 325);
			wizard.x = 200;
			wizard.y = wizard.baseY = 325; // Don't forget to set baseY!
			addChild(wizard);
		}
		
		private function createForeground(): void
		{
			fg1 = new Foreground1;
			fg1.x = 0;
			fg1.y = 20;
			fg1.alpha = 0.5;
			addChild(fg1);
			
			fg2 = new Foreground1;
			fg2.x = fg2.width;
			fg2.y = 10;
			fg2.alpha = 0.5;
			addChild(fg2);
			
			fg3 = new Foreground1;
			fg3.x = fg3.width * 2;
			fg3.y = 10;
			fg3.alpha = 0.5;
			addChild(fg3);
		}
		
		private function scrollStage(e:Event): void
		{
			setWizardMovement();
			
			if (haltMovement && rightButton) {
				bg.x -= wizard.HORIZONTAL_SPEED / 2;
				mg.x -= wizard.HORIZONTAL_SPEED;
				fg1.x -= wizard.HORIZONTAL_SPEED * 3;
				fg2.x -= wizard.HORIZONTAL_SPEED * 3;
				fg3.x -= wizard.HORIZONTAL_SPEED * 3;
			}
		}
		
		private function setWizardMovement(): void
		{
			if (wizard.x >= stage.stageWidth - 300) {
				haltMovement = true;
			} else {
				haltMovement = false;
			}
		}
		
      public function playMusic(): void
      {
         musicChannel = music.play();
         musicChannel.addEventListener(Event.SOUND_COMPLETE, loopMusic);
      }

      private function loopMusic(e:Event): void
      {
         if (musicChannel != null) {
            musicChannel.removeEventListener(Event.SOUND_COMPLETE, loopMusic);
            playMusic();
         }
      }

      public function stopMusic(): void
      {
         if (musicChannel != null) {
            musicChannel.stop();
            musicChannel.removeEventListener(Event.SOUND_COMPLETE, loopMusic);
         }
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
	}
}