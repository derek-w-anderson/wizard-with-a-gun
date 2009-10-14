package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Wizard extends MovieClip
	{
		public var SPEED = 20;
		public var direction;
		
		public function Wizard() 
		{						
			gotoAndStop("standRight");
			direction = "right";
			addEventListener(Event.ENTER_FRAME, move);
		}

		private function move(e:Event): void
		{						
			var left = MovieClip(parent).leftArrow;
			var right = MovieClip(parent).rightArrow;
			
			if (right) {
				direction = "right";
				loopRunAnimation();
				this.x += SPEED;
			
			} else if (left) {
				direction = "left";
				loopRunAnimation();
				this.x -= SPEED;
			
			} else {
				if (direction == "left") 
					gotoAndStop("standLeft");
				else 
					gotoAndStop("standRight");
			}
		}
		
		private function loopRunAnimation(): void
		{
			var cur = currentLabel;
			if (cur == "runRightComplete" || cur == "runLeftComplete" || cur == "standRight" || cur == "standLeft") {
				if (direction == "right") 
					gotoAndPlay("runRight");
				else
					gotoAndPlay("runLeft");
			}
		}
	}
}