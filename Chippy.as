package
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.Timer;

	public class Chippy extends MovieClip
	{
		private var LOOP_STATES = new Array("moveComplete");
		
		private var lowerBoundary:Number;
		private var upperBoundary:Number;
		private var ready:Boolean;
		private var timer:Timer;
		private var dx:int = 10;
		private var dy:int = 5;
		
		public const MAX_HP:int = 40;
		public var HP:int = 40;
		
		public function get absX(): Number
		{
			return this.localToGlobal(new Point(0, 0)).x;
		}
		
		public function get absY(): Number
		{
			return this.localToGlobal(new Point(0, 0)).y;
		}
		
		public function Chippy(lowerBoundary:Number, upperBoundary:Number): void
		{		
			this.lowerBoundary = lowerBoundary;
			this.upperBoundary = upperBoundary;
			ready = false;
			
			timer = new Timer(1000);
			timer.addEventListener("timer", fireLaser);
			timer.start();
			this.addEventListener(Event.ENTER_FRAME, move); 
		}
		
		public function fireLaser(e:TimerEvent): void
		{
			/* Calculate the angle from Chippy's head region to the wizard. */
			var distX = MovieClip(parent).wizard.x - this.absX;
			var distY = MovieClip(parent).wizard.y - this.absY;
			var radians = Math.atan2(distY, distX);
			var angle = radians/(Math.PI/180);		
			
			/* FIRE ZE LAY-ZUH!!! */
			var laser = new ChippyLaser(angle);
			laser.x = this.absX + 15;
			laser.y = this.absY + 50;
			parent.addChild(laser);
		}
		
		private function move(e:Event): void
		{
			run();
			
			/* Move into view of the player. */
			if (!ready) {
				this.x -= dx;
				if (this.x <= (stage.stageWidth - this.width + 25)) {
					ready = true;
				}
				
			/* Move up and down. */
			} else {
				this.y += dy;
				if ((this.y + this.height >= lowerBoundary) || (this.y + this.height <= upperBoundary + 20)) {
					dy = -dy;
				}
			}
		}
		
		private function run():void 
		{
			for (var i = 0; i < LOOP_STATES.length; i++) {
				if (currentLabel == LOOP_STATES[i]) {
					loopAnimation();
					break;
				}
			}
		}
		
		private function loopAnimation():void 
		{
			gotoAndPlay("move");
		}
		
		public function hit(): void
		{
			HP -= 1;
			MovieClip(parent).bossHUD.getChildAt(0).width = (HP/MAX_HP) * MovieClip(parent).maxLifebar;
		}
		
		public function remove(): void
		{
			timer.removeEventListener("timer", fireLaser);
			this.removeEventListener(Event.ENTER_FRAME, move);
			
			var parentMC = MovieClip(parent);
			parentMC.removeChild(this);
			try {
				parentMC.removeChild(parentMC.bossHUD);
			} catch (error) {}
		}
	}
}