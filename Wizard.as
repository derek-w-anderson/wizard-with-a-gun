package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	public class Wizard extends MovieClip
	{
		public var JUMP_HEIGHT:Number = 12;
		public var LOOP_STATES = new Array("runRightComplete", "runLeftComplete", "standRight", "standLeft");
		public var HORIZONTAL_SPEED = 20;
		public var VERTICAL_SPEED = 8;
		
		public var HEIGHT;
		public var HP:int;
		public var ammoLeft:int;
		public var maxAmmo:int;
		
		public var lowerBoundary:Number;
		public var upperBoundary:Number;
		
		public var arm:MovieClip;
		public var baseY:Number;
		public var direction:String;
		public var directionChanged:Boolean;
		public var dy:Number = 0;
		public var jumpPressed:Boolean;
		
		public function Wizard(lowerBoundary:Number, upperBoundary:Number) 
		{							
			this.lowerBoundary = lowerBoundary;
			this.upperBoundary = upperBoundary;
			HEIGHT = this.height;
			HP = 10;
			ammoLeft = maxAmmo = 999;
		
			arm = new Arm();
			arm.x = 41;
			arm.y = 52.5;
			arm.gotoAndStop("close");
			addChildAt(arm, 1);
			
			addEventListener(Event.ENTER_FRAME, move);
		}

		private function move(e:Event): void
		{
			setDirection();
			
			if (baseY == this.y && MovieClip(parent).jumpButton) {
				jumpPressed = true;
			}
			
			if (jumpPressed || this.y != baseY) {
				calculateJumpPosition();
			} else {
				var movedVertically:Boolean = moveVertical();
			}
			var movedHorizontally:Boolean = moveHorizontal();
			
			if (!(movedVertically || movedHorizontally)) {
				stand();
			} 
		}
		
		private function setDirection(): void 
		{
			if (stage.mouseX > this.x) {
				if (direction == "left") {
					directionChanged = true;
				} else {
					directionChanged = false;
				}
				direction = "right";
				
			} else { 
				if (direction == "right") {
					directionChanged = true;
				} else {
					directionChanged = false;
				}
				direction = "left";
			}
		}
		
		private function calculateJumpPosition(): void
		{
			if (jumpPressed) {
				dy = -JUMP_HEIGHT;			
				jumpPressed = false;
			} else if (this.y != baseY) {
				dy += MovieClip(parent).GRAVITY;
			} else {
				dy = 0;
			}
			this.y += dy;
		}
		
		private function moveVertical(): Boolean
		{	
			if (MovieClip(parent).upButton) {
				run();
				if (this.y + HEIGHT - 5 > upperBoundary) {
					this.y -= VERTICAL_SPEED;
					baseY = this.y;
				}
				return true;
				
			} else if (MovieClip(parent).downButton) {
				run();
				if (this.y + HEIGHT + 2 < lowerBoundary) {
					this.y += VERTICAL_SPEED;
					baseY = this.y;
				}
				return true;
				
			} else {
				return false;
			}
		}
		
		private function moveHorizontal(): Boolean
		{
			if (MovieClip(parent).rightButton) {
				run();
				if (!MovieClip(parent).haltMovement) {
					this.x += HORIZONTAL_SPEED;
				}
				return true;
				
			} else if (MovieClip(parent).leftButton) {
				run();
				this.x -= HORIZONTAL_SPEED;
				if (this.x < -50) {
					this.x = -50;
				}
				return true;
				
			} else {
				return false;
			}
		}
		
		private function stand(): void
		{
			if (direction == "left") {
				gotoAndStop("standLeft");
			} else {
				gotoAndStop("standRight");
				setChildIndex(arm, 1);
			}
		}
		
		private function run(): void
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
		
		public function fire(): void
		{
			ammoLeft -= 1;
			arm.fire();
		}
	}
}