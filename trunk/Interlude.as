package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Interlude extends MovieClip
	{	
		public function Interlude()
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
				
				if (parentMC.level == 4) {
					parentMC.stopMusic();
					parentMC.showTitleScreen();
				} else {
					parentMC.beginLevel();
				}
			}
		}
	}
}