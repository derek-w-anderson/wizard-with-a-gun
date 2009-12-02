package
{
	import flash.display.*;
	import flash.events.Event;
	
	public class Wizard extends MovieClip
	{
		public var LOOP_STATES = new Array("runRightComplete", "runLeftComplete", "standRight", "standLeft");
		
		public var HEIGHT;
		public var HP:int;
		public var xSpeed = 18;
		public var ySpeed = 8;
		public var jumpHeight:Number = 12;
		public var ammoLeft:int;
		public var maxAmmo:int;
		
		public var lowerBoundary:Number;
		public var upperBoundary:Number;
		
		public var arm:MovieClip;
		public var direction:String;
		public var directionChanged:Boolean;
		
		public var jumpPressed:Boolean;
		public var dy:Number;
		public var baseY:Number;
		
		public function Wizard(lowerBoundary, upperBoundary) 
		{							
			this.lowerBoundary = lowerBoundary; 
			this.upperBoundary = upperBoundary; 
			
			HEIGHT = this.height;
			HP = 10;
			dy = 0;
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
			
			/* Handle jummping and/or vertical movement. */
			if (baseY == this.y && MovieClip(parent).jumpButton)
				jumpPressed = true;
			
			if (jumpPressed || this.y != baseY) 
				calculateJumpPosition();
			else 
				var movedVertically:Boolean = moveVertical();

			/* Handle horizontal movement. */
			var movedHorizontally:Boolean = moveHorizontal();
			
			if (!(movedVertically || movedHorizontally)) 
				stand();
			else if (movedVertically)
				setDepth();			
		}
		
		public function setDepth(): void
		{
			var zombies = MovieClip(parent).zombies; 
			var wPos = baseY + this.height;
			var back = null;
			var front = null;
			
			for (var i = 0; i < MovieClip(parent).MAX_ENEMIES; i++) {
				if (zombies[i] != null) {
					var zPos = zombies[i].y - 10 + zombies[i].height;
					
					/* Look for the closest enemy behind the wizard. */
					if (zPos < wPos) {
						if (back) {
							if (zPos > (back.y - 10 + back.height)) 
								back = zombies[i];
						} else  
							back = zombies[i];
						
					/* Look for the closest enemy in front of the wizard. */
					} else if (zPos > wPos) {
						if (front) {
							if (zPos < (front.y - 10 + front.height))
								front = zombies[i];
						} else 
							front = zombies[i];
					}
				}
			}
			if (back) 
				MovieClip(parent).setChildIndex(this, MovieClip(parent).getChildIndex(back) + 1);
			else if (front) 
				MovieClip(parent).setChildIndex(this, MovieClip(parent).getChildIndex(front));
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
				dy = -jumpHeight;			
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
					this.y -= ySpeed;
					baseY = this.y;
				}
				return true;
				
			} else if (MovieClip(parent).downButton) {
				run();
				if (this.y + HEIGHT + 2 < lowerBoundary) {
					this.y += ySpeed;
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
					this.x += xSpeed;
				}
				return true;
				
			} else if (MovieClip(parent).leftButton) {
				run();
				this.x -= xSpeed;
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
		
		public function remove(): void
		{
			removeEventListener(Event.ENTER_FRAME, move);
			arm.remove();
			parent.removeChild(this);
		}
	}
}