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
			
			var tmap:TiledMap = new TiledMap("dev.tmx");
			var obj = tmap.getObjectLayerProperties("Object Layer 1");
			trace(obj["layer prop"]);
			obj = tmap.getObjectLayerAttributes("Object Layer 1");
			trace(obj["name"]);
			this.add(tmap);
		} // end function create
	}
	
}