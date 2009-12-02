package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Arm extends MovieClip
	{
		public var hand:MovieClip;
		
		public var angle:Number = 0;
		public var distX:Number;
		public var distY:Number;
		
		public function get absX(): Number
		{
			return this.localToGlobal(new Point(0, 0)).x;
		}
		
		public function get absY(): Number
		{
			return this.localToGlobal(new Point(0, 0)).y;
		}
		
		public function Arm()
		{
			hand = new Hand();
			hand.x = 36;
			hand.y = 3;
			addChild(hand);
			
			addEventListener(Event.ENTER_FRAME, move);
		}
		
		private function move(e:Event): void
		{
			distX = stage.mouseX - this.absX;
			distY = stage.mouseY - this.absY;
			
			var radians = Math.atan2(distY, distX);
			angle = radians/(Math.PI/180);		
			rotation = angle;
		}
		
		public function fire(): void
		{		
			var bullet = new Projectile(angle);
			if (angle < -95 || angle > -45) {
				if (MovieClip(parent).direction == "right") {
					bullet.x = hand.absX + 5; 
					bullet.y = hand.absY - 10;
				} else {
					bullet.x = hand.absX - 5;
					bullet.y = hand.absY + 7;
				}
			} else {
				bullet.x = hand.absX; 
				bullet.y = hand.absY;
			}
			parent.parent.addChild(bullet);
		}
		
		public function remove(): void
		{
			try {
				removeEventListener(Event.ENTER_FRAME, move);
				parent.removeChild(this);
			} catch (error) {}
		}
	}
}