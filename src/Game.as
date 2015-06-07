package
{
	import org.flixel.*;
	import org.flixel.FlxState;
	
	//Allows you to refer to flixel objects in your code
	[SWF(width = "640", height = "480", backgroundColor = "#000000")] //Set the size and color of the Flash file
	
	public class Game extends FlxGame
	{
		
		public function Game()
		{
			
			super(320, 240, BlankState, 2); //Create a new FlxGame object at 320x240 with 2x pixels, then load PlayState
		}

	}
}