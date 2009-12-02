package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class ChippyLaser extends MovieClip
	{
		public var speed = 50;
		
		public function ChippyLaser(angle:Number): void
		{
			rotation = angle;
			
			this.addEventListener(Event.ENTER_FRAME, move); 
		}
		
		private function move(e:Event): void
		{
			x += Math.cos(rotation * (Math.PI / 180)) * speed;
			y += Math.sin(rotation * (Math.PI / 180)) * speed;
			
			if (x < 0 || x > stage.stageWidth || y < 0 || y > stage.stageHeight) {
				remove();
			} else {
				var wizard = MovieClip(parent).wizard;
				try {
					if (HitDetect.isColliding(this, wizard, parent, true)) {
						wizard.HP -= 2;
						remove();
					}
				} catch (error) {}
			}
		}
		
		public function remove(): void
		{
			try {
				this.removeEventListener(Event.ENTER_FRAME, move);
				parent.removeChild(this);
			} catch (error) {}
		}
	}
}