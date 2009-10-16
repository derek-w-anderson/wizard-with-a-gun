package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	public class Wizard extends MovieClip
	{
		public var SPEED = 20;
		public var JUMP_HEIGHT:Number = 12;
		public var LOOP_STATES = new Array("runRightComplete", "runLeftComplete", "standRight", "standLeft");
		
		public var arm:MovieClip;
		public var direction:String;
		public var directionChanged:Boolean;
		
		public var jumping:Boolean;
		public var baseY:Number;
		public var dy:Number = 0;
		
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
			if (baseY == this.y && MovieClip(parent).upArrow) {
				jumping = true;
			}
			moveVertically();
			moveHorizontally();
		}
		
		private function moveVertically(): void
		{		
			if (jumping) {
				jumping = false;
				dy = -JUMP_HEIGHT;
			} else if (baseY != this.y) {
				dy += MovieClip(parent).GRAVITY;
			} else {
				dy = 0;
			}
			this.y += dy;
		}
		
		private function moveHorizontally(): void
		{
			if (stage.mouseX > this.x) {
				if (direction == "left") directionChanged = true;
				else directionChanged = false;
				direction = "right";
			} else { 
				if (direction == "right") directionChanged = true;
				else directionChanged = false;
				direction = "left";
			}
			
			if (MovieClip(parent).rightArrow) {
				setAnimation();
				this.x += SPEED;
			
			} else if (MovieClip(parent).leftArrow) {
				setAnimation();
				this.x -= SPEED;
			
			} else {
				if (direction == "left") {
					gotoAndStop("standLeft");
				} else {
					gotoAndStop("standRight");
					setChildIndex(arm, 1);
				}
			}
		}
		
		private function setAnimation(): void
		{
			if (directionChanged) {
				loopRunAnimation();
			} else {
				for (var i = 0; i < LOOP_STATES.length; i++) {
					if (currentLabel == LOOP_STATES[i]) {
						loopRunAnimation();
						break;
					}
				}
			}
		}
		
		private function loopRunAnimation(): void
		{
			if (direction == "right") {
				gotoAndPlay("runRight");
				setChildIndex(arm, 1);
			} else {
				gotoAndPlay("runLeft");
			}
		}
	}
}