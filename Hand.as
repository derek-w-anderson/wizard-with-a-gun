package
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Hand extends MovieClip
	{	
		public function get absX(): Number
		{
			return this.localToGlobal(new Point(0, 0)).x;
		}
		
		public function get absY(): Number
		{
			return this.localToGlobal(new Point(0, 0)).y;
		}
		
		public function Hand() {}
	}
}