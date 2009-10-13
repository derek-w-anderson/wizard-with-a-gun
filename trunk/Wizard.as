package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Wizard extends MovieClip
	{
		public function Wizard() 
		{						
			this.addEventListener(Event.ENTER_FRAME, move);
		}

		private function move(e:Event): void
		{				

		}
	}
}