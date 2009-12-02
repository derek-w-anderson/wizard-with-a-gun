package
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class EndScreen extends MovieClip
	{		
		public function EndScreen(killCount:int, accuracy:Number) 
		{
			this.killCount.text = "Kills: " + String(killCount) + "\nAccuracy: " + String(accuracy) + "%";
		}
	}
}