package 
{
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Brandon Wylie
	 */
	public class Levels 
	{
		/*
		 * To add a new level, add the embed code, any tileset img embeds, and then the cases in both switches; don't forget breaks!
		 */
		
		//embedded levels
		[Embed(source = "../assets/dev.tmx", mimeType = "application/octet-stream")] private static const dev:Class;
		
		//embedded img
		[Embed(source = "../assets/spritesheet.png")] private static const spritesheet:Class;
		private static var levelcache:Object = {};
		private static var imagecache:Object = {};
		
		public static function getImg(name:String):Bitmap {
			if (!(name in imagecache)) {
				switch(name) {
					case "spritesheet.png":
						imagecache[name] = new spritesheet();
						break;
				}
			}
			return imagecache[name];
		}
		
		public static function getTMX(name:String):XML {
			if (!(name in levelcache)) {
				switch(name) {
					case "dev.tmx":
						levelcache[name] = classToXML (dev);
						break;	
				}
			}
			return levelcache[name];
		}
		
		public static function classToXML(c:Class):XML {
			var ba:ByteArray = (new c()) as ByteArray;
			var s:String = ba.readUTFBytes(ba.length);
			return new XML(s);
		}
	}

}