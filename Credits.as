package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Credits extends MovieClip
	{	
		public function Credits()
		{		
			play();
			addEventListener(Event.ENTER_FRAME, checkLabel);
		}
		
		private function checkLabel(e:Event): void
		{
			if (currentLabel == "end") {
				stop();
				removeEventListener(Event.ENTER_FRAME, checkLabel);
				
				var parentMC = MovieClip(parent);
				parentMC.removeChild(this);
				parentMC.showTitleScreen();
			}
		}
	}
}