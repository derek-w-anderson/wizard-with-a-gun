package 
{
	import flash.display.*;
	import flash.events.Event;

	public class GroundEnemy extends MovieClip 
	{
		private var LOOP_STATES = new Array("runLeftComplete");

		public var xSpeed = 8;
		public var CURRENT_xSpeed;
		public var HEIGHT;
		public var HP:int;

		public function GroundEnemy() 
		{
			CURRENT_xSpeed = xSpeed;
			HEIGHT = this.height;
			HP = 1;

			addEventListener(Event.ENTER_FRAME, move);
		}

		private function move(e:Event):void 
		{
			run();
			this.x -= CURRENT_xSpeed;
		}
		
		private function run():void 
		{
			for (var i = 0; i < LOOP_STATES.length; i++) {
				if (currentLabel == LOOP_STATES[i]) {
					loopRunAnimation();
					break;
				}
			}
		}
		
		private function loopRunAnimation():void 
		{
			gotoAndPlay("runLeft");
		}
		
		public function hit():void 
		{
			HP -= 1;
		}
		
		public function remove():void 
		{
			this.removeEventListener(Event.ENTER_FRAME, move);
			parent.removeChild(this);
		}
	}
}