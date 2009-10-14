package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Arm extends MovieClip
	{
		public var angle:Number = 0;
		
		public function Arm()
		{
			addEventListener(Event.ENTER_FRAME, move);
		}
		
		private function move(e:Event): void
		{
			var absX = this.parent.localToGlobal(new Point(this.x, 0)).x;
			var absY = this.parent.localToGlobal(new Point(0, this.y)).y;

			var a = stage.mouseY - absY;
			var b = stage.mouseX - absX;
			
			var radians = Math.atan2(a,b);
			angle = radians/(Math.PI/180);		
			rotation = angle;
		}
	}
}