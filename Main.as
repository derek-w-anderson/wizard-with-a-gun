package
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	
	public class Main extends MovieClip
	{
		public const GRAVITY = 2; 
		
		public var leftArrow:Boolean = false;
		public var rightArrow:Boolean = false;
		public var upArrow:Boolean = false;
		
		public var ground:MovieClip;
		public var wizard:MovieClip;
		
		public function Main() 
		{						
			ground = new Ground();
			ground.x = 0;
			ground.y = stage.stageHeight - 50;
			addChildAt(ground, 0);
		
			wizard = new Wizard();
			wizard.x = (stage.stageWidth / 2) - (wizard.width / 2);
			wizard.y = wizard.baseY = ground.y - wizard.height + 5;
			addChild(wizard);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onDownKey);
			stage.addEventListener(KeyboardEvent.KEY_UP, onUpKey);
		}
		
		private function onDownKey(e:KeyboardEvent): void 
		{
			if (e.keyCode == Keyboard.LEFT) leftArrow = true;
			else if (e.keyCode == Keyboard.RIGHT) rightArrow = true;
			else if (e.keyCode == Keyboard.UP) upArrow = true;
		}
		
		private function onUpKey(e:KeyboardEvent): void
		{
			if (e.keyCode == Keyboard.LEFT) leftArrow = false;
			else if (e.keyCode == Keyboard.RIGHT) rightArrow = false;
			else if (e.keyCode == Keyboard.UP) upArrow = false;
		}
	}
}