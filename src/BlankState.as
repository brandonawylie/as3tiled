package 
{
	
	import TiledMap;
	
	import org.flixel.*;

	/**
	 * ...
	 * @author ...
	 */
	public class BlankState extends FlxState
	{
		
		public function BlankState() 
		{
			FlxG.mouse.show();
		}
		
		
		override public function create():void
		{
			super.create();
			
			new TiledMap("dev.tmx");
			
		} // end function create
	}
	
}