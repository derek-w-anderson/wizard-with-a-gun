package
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	public class PlayButton extends SimpleButton
	{		
		public function PlayButton() 
		{
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent): void
		{
			removeEventListener(MouseEvent.CLICK, onClick);
			var parentMC = MovieClip(parent.parent);
			parentMC.removeChild(parent);
			parentMC.startGame();
		}
	}
}