package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class WeaponPanel extends MovieClip
	{	
		public function WeaponPanel(): void
		{		
			this.addEventListener(Event.ENTER_FRAME, setAmmo); 
		}
		
		private function setAmmo(e:Event): void
		{
			var ammoLeft = String(MovieClip(parent).wizard.ammoLeft);
			var maxAmmo = String(MovieClip(parent).wizard.maxAmmo);
			this.ammo.text = ammoLeft + "/" + maxAmmo;
		}
	}
}