package
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	public class TryAgainButton extends SimpleButton
	{		
		public function TryAgainButton() 
		{
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent): void
		{
			removeEventListener(MouseEvent.CLICK, onClick);
			MovieClip(parent.parent).resetLevel();
		}
	}
}