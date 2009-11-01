package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class LifeBar extends MovieClip
	{	
		public function LifeBar(): void
		{		
			this.addEventListener(Event.ENTER_FRAME, setBar); 
		}
		
		private function setBar(e:Event): void
		{
			var position:int;
			if (MovieClip(parent).wizard.HP >= 10) {
				position = 0;
			} else if (MovieClip(parent).wizard.HP <= 0) {
				position = 11;
			} else {
				position = 11 - MovieClip(parent).wizard.HP;
			}
			this.gotoAndStop(position);
		}
	}
}