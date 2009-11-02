package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Projectile extends MovieClip
	{
		public var speed = 30;
		
		public function Projectile(angle:Number): void
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
				var zombies = MovieClip(parent).zombies;
				for (var i = 0; i < zombies.length; i++) {
					try {
						if (HitDetect.isColliding(this, zombies[i], parent, true)) {
							zombies[i].hit();
							if (zombies[i].HP <= 0) {
								parent.removeChild(zombies[i]);
								delete zombies[i]
								remove();
							}
						}
					} catch (error) {}
				}
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