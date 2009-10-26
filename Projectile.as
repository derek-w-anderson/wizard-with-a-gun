package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Projectile extends MovieClip
	{
		
		public function Projectile() 
		{						
			this.addEventListener(Event.ENTER_FRAME, move);
		}
		
		private function move(e:Event): void
		{

		}
	}
}