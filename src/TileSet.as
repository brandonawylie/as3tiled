package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import mx.core.FlexSprite;
	import org.flixel.*;
	/**
	 * ...
	 * @author ...
	 */
	public class TileSet 
	{
		private var spacing:int, margin:int;
		private var imgLoader:Loader;
		private var imgWidth:int, imgHeight:int, tileWidth:int, tileHeight:int;
		private var bitmap:Bitmap;
		private var firstGid:int;
		private var lastGid:int;
		private var widthInTiles:int;
		private var heightInTiles:int;
		private var tiles:Object;
		
		public function TileSet(img:Bitmap, imgWidth:int, imgHeight:int, firstGid:int, tileWidth:int, tileHeight:int, spacing:int, margin:int) 
		{
			this.spacing = spacing;
			this.margin = margin;
			
			this.imgWidth = imgWidth;
			this.imgHeight = imgHeight;
			this.tileWidth = tileWidth;
			this.tileHeight = tileHeight;
			
			this.firstGid = firstGid;
			widthInTiles = (imgWidth-2*margin+spacing) / (tileWidth+spacing);
			heightInTiles = (imgHeight-2*margin+spacing) / (tileHeight+spacing);
			lastGid = firstGid + widthInTiles * heightInTiles;
			
			tiles = { };
			bitmap = img;
			FlxG.log(bitmap.toString());
		}
		
		public function getTile(gid:int):FlxSprite
		{
			if (gid == 0) {
				trace('hello');
			}
			if (gid < firstGid || gid >= lastGid)
			{
				return null;
			}
			//if (!tiles.gid)
			//{
				var s:FlxSprite = new FlxSprite();
				tiles.gid = s;
				var b:BitmapData = new BitmapData(tileWidth, tileHeight);
				var col:int = (gid - firstGid) % widthInTiles;
				var row:int = (gid - firstGid) / widthInTiles;
				var srcX:int = col * (tileWidth + spacing) + margin;
				var srcY:int = row * (tileHeight + spacing) + margin;
				b.copyPixels(bitmap.bitmapData, new Rectangle(srcX, srcY, tileWidth, tileHeight), new Point(0, 0));
				s.pixels = b;
				tiles.gid = s;
				return s;
			//}
			//return tiles.gid;
		}
	}

}