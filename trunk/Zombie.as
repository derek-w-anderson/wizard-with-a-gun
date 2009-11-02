package
{
	import flash.display.*;
	import flash.events.Event;
	
	public class Zombie extends MovieClip
	{
		public var LOOP_STATES = new Array("runLeftComplete");
		
		public const HORIZONTAL_SPEED = 5;
		public var CURRENT_HORIZONTAL_SPEED = 5;
		public var HEIGHT;
		public var HP:int;
		
		public function Zombie() 
		{							
			HEIGHT = this.height;
			HP = 1;
			
			addEventListener(Event.ENTER_FRAME, move);
		}

		private function move(e:Event): void
		{
			run();
			this.x -= CURRENT_HORIZONTAL_SPEED;
		}
		
		private function run(): void
		{
			for (var i = 0; i < LOOP_STATES.length; i++) {
				if (currentLabel == LOOP_STATES[i]) {
					loopRunAnimation();
					break;
				}
			}
		}
		
		private function loopRunAnimation(): void
		{
			gotoAndPlay("runLeft");
		}
		
		public function hit(): void
		{
			HP -= 1;
		}
		
		public function remove(): void
		{
			this.removeEventListener(Event.ENTER_FRAME, move);
			parent.removeChild(this);
		}
	}
}