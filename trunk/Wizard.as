﻿package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	public class Wizard extends MovieClip
	{
		public var SPEED = 20;
		public var arm;
		public var direction;
		
		public function Wizard() 
		{							
			arm = new Arm();
			arm.x = 41;
			arm.y = 52.5;
			arm.gotoAndStop("close");
			addChildAt(arm, 1);
			
			gotoAndStop("standRight");
			addEventListener(Event.ENTER_FRAME, move);
		}

		private function move(e:Event): void
		{								
			if (stage.mouseX > this.x) 
				direction = "right";
			else 
				direction = "left";
			
			if (MovieClip(parent).rightArrow) {
				loopRunAnimation();
				this.x += SPEED;
			
			} else if (MovieClip(parent).leftArrow) {
				loopRunAnimation();
				this.x -= SPEED;
			
			} else {
				if (direction == "left") 
					gotoAndStop("standLeft");
				else {
					gotoAndStop("standRight");
					setChildIndex(arm, 1);
				}
			}
		}
		
		private function loopRunAnimation(): void
		{
			var lab = currentLabel;
			if (lab == "runRightComplete" || lab == "runLeftComplete" || lab == "standRight" || lab == "standLeft") {
				if (direction == "right") {
					gotoAndPlay("runRight");
					setChildIndex(arm, 1);
				} else {
					gotoAndPlay("runLeft");
				}
			}
		}
	}
}