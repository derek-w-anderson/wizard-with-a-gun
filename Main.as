package
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	
	public class Main extends MovieClip
	{
		public var leftArrow:Boolean = false;
		public var rightArrow:Boolean = false;
		public var wizard:MovieClip;
		
		public function Main() 
		{						
			wizard = new Wizard();
			wizard.x = (stage.stageWidth / 2) - (wizard.width / 2);
			wizard.y = 400;
			addChild(wizard);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onDownKey);
			stage.addEventListener(KeyboardEvent.KEY_UP, onUpKey);
		}
		
		private function onDownKey(e:KeyboardEvent): void 
		{
			if (e.keyCode == Keyboard.LEFT)
				leftArrow = true;
			else if (e.keyCode == Keyboard.RIGHT)
				rightArrow = true;
		}
		
		private function onUpKey(e:KeyboardEvent): void
		{
			if (e.keyCode == Keyboard.LEFT)
				leftArrow = false;
			else if (e.keyCode == Keyboard.RIGHT)
				rightArrow = false;
		}
	}
}