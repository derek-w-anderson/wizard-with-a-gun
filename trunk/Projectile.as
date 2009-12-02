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
				var hit:Boolean = false;
				
				/* Handle collision detection with the boss. */
				if (MovieClip(parent).level == 2 && MovieClip(parent).bossSpawned && !MovieClip(parent).bossDead) {
					var boss = MovieClip(parent).boss;
					if (HitDetect.isColliding(this, boss, parent, true)) {
						boss.hit();
						if (boss.HP <= 0) {
							MovieClip(parent).bossDead = true;
							boss.remove();
						}
						hit = true;
					}
				} 
				
				/* Handle collision detection with normal enemies. */
				var zombies = MovieClip(parent).zombies;
				for (var i = 0; i < zombies.length; i++) {
					try {
						if (HitDetect.isColliding(this, zombies[i], parent, true)) {
							zombies[i].hit();
							if (zombies[i].HP <= 0) {
								MovieClip(parent).killCount++;
								parent.removeChild(zombies[i]);
								delete zombies[i];
							}
							hit = true;
						}
					} catch (error) {}
				}
				
				if (hit)
					remove();
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