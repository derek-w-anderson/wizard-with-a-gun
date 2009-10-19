package
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	
	public class Main extends MovieClip
	{
		public const GRAVITY = 2; 
		
		public var leftButton:Boolean = false;
		public var rightButton:Boolean = false;
		public var upButton:Boolean = false;
		public var downButton:Boolean = false;
		public var jumpButton:Boolean = false;
		
		public var ground:MovieClip;
		public var wizard:MovieClip;
		
		public function Main() 
		{						
			ground = new Ground();
			ground.x = 0;
			ground.y = stage.stageHeight - 50;
			addChildAt(ground, 0);
		
			wizard = new Wizard(stage.stageHeight, ground.y);
			wizard.x = (stage.stageWidth / 2) - (wizard.width / 2);
			wizard.y = wizard.baseY = ground.y - wizard.height + 15;
			addChild(wizard);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onDownKey);
			stage.addEventListener(KeyboardEvent.KEY_UP, onUpKey);
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