package 
{

	import Levels;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.flixel.*;
	

	/**
	 * ...
	 * @author ...
	 */
	public class TiledMap extends FlxSprite
	{
		private var xml:XML;
		private var tilesets:Array;
		private var loadedCallBack:Function;
		private var level:String;
		
		private var objectLayers:Object;
		
		public function TiledMap(path:String)
		{
			super(0, 0);
			objectLayers = new Object();
			this.level = path;
			FlxG.log("The level is:"+ level);
			//get xml
	
			xml = Levels.getTMX(path);
			
			//get tilesets
			if (xml) {
				tilesets = new Array();
				for each(var tileset:XML in xml.tileset) {
					tilesets.push(new TileSet(Levels.getImg(tileset.image.@source), parseInt(tileset.image.@width), parseInt(tileset.image.@height), parseInt(tileset.@firstgid), parseInt(tileset.@tilewidth), parseInt(tileset.@tileheight), parseInt(tileset.@spacing), parseInt(tileset.@margin)));
				}
			}
			
			//load level
			loadLevel(xml);
		}
		
		/*
		 * Loading a level --
		 * object layers are important -- their names will be the way to refer to them here
		 * bblocks group is breakable blocks
		 * iblocks group is indestructible blocks etc
		 * you can always add your own, just document it
		 */
		private function loadLevel(xml:XML) {
			// Move onto loading the actual map data
			var mapWidthInTiles:int = parseInt(xml.@width);
			var mapHeightInTiles:int = parseInt(xml.@height);
			var mapTileWidth:int = parseInt(xml.@tilewidth);
			var mapTileHeight:int = parseInt(xml.@tileheight);
			
			FlxG.worldBounds = new FlxRect(0, 0, mapWidthInTiles * mapTileWidth, mapHeightInTiles * mapTileHeight);
			var m:BitmapData = new BitmapData(mapWidthInTiles * mapTileWidth, mapHeightInTiles * mapTileHeight);
			//this.makeGraphic(mapWidthInTiles * mapTileWidth, mapHeightInTiles * mapTileHeight);
			for each(var layer:XML in xml.layer) {
				var layerWidthInTiles:int = parseInt(layer.@width);
				var layerHeightInTiles:int = parseInt(layer.@height);
				var i:int = 0;
				for each(var tile:XML in layer.data.tile) {
					var x:int = (i % layerWidthInTiles) * mapTileWidth;
					var y:int = Math.floor(i / layerWidthInTiles) * mapTileHeight;
					var gid:int = parseInt(tile.@gid);
					//if(gid != 0) {
						//this.stamp(getGid(gid), x, y);
					var s:FlxSprite = getGid(gid);
					var srcRect:Rectangle = new Rectangle(0, 0, mapTileWidth, mapTileHeight);
					var destPoint:Point = new Point(x, y);
					m.copyPixels(s.pixels, srcRect, destPoint,null,null,true);
					//}
					i++;
				}
			}
			this.pixels = m;
			
			
			//trace("hello, world");
			var  objectiveDoors:FlxGroup = new FlxGroup();
			for each(var objGroup:XML in xml.objectgroup) {
				var groupName:String = objGroup.@name;
				
				//create switch and door groups for the switch&door layer
				if (groupName == "switch&door") {
					var doors:FlxGroup = new FlxGroup();
					var switches:FlxGroup = new FlxGroup();
				}
				
				objectLayers[groupName] = new Array();
				objectLayers[groupName]["prop"] = new Object();
				objectLayers[groupName]["attr"] = new Object();
				

				// iterate through attributes, store them
				for each (var attr : XML in objGroup.attributes()) {
					objectLayers[groupName]["attr"][attr.name().toString()] = attr.valueOf().toString();
				}
				
				//iterate through props, store them
				if (objGroup.properties) {
					for each (var prop: XML in objGroup.properties.property) {
						objectLayers[groupName]["prop"][prop.attribute("name")] = prop.attribute("value");
					}
				}
				
				for each(var obj:XML in objGroup.object) {
					//trace("obj attributes: " + obj.attribute("*"));
					var member = new Object();
					member["prop"] = new Object();
					member["attr"] = new Object();
					
					// iterate through attributes, store them
					for each (var attr : XML in obj.attributes()) {
						member["attr"][attr.name().toString()] = attr.valueOf().toString();
					}
					
					//iterate through props, store them
					if (obj.properties) {
						for each (var prop: XML in obj.properties.property) {
							member["prop"][prop.attribute("name")] = prop.attribute("value");
						}
					}
				}
				trace (JSON.stringify(objectLayers));
			}
		
		}
		
		private function getProperty(obj:XML, name:String) {
			for each (var prop:XML in obj.properties.property) {
				if (prop.@name == name)
					return prop.@value;
			}
		}
		
		private function getGid(gid:int) {
			if (gid == 0) {
				var sprite:FlxSprite = new FlxSprite();
				sprite.makeGraphic(16, 16, 0x00000000);
				return sprite;
			}
			for (var i = 0; i < tilesets.length; i++) {
				var s:FlxSprite = tilesets[i].getTile(gid);
				if (s) {
					return s;
				}
			}
			var sprite:FlxSprite = new FlxSprite();
			sprite.makeGraphic(16, 16, 0x00000000);
			return sprite;
		}
		
		private function getFacing(obj:XML):uint {
			var facing:String = getProperty(obj, "facing");
			if (facing == "up") {
				return FlxObject.UP;
			} else if (facing == "down") {
				return FlxObject.DOWN;
			} else if (facing == "left") {
				return FlxObject.LEFT;
			} else if (facing == "right") {
				return FlxObject.RIGHT;
			}
			return FlxObject.DOWN;
		}
		
		private function getPower(obj:XML):uint {
			var p:String = getProperty(obj, "power");
			if (p == null) {
				return 100;
			}
			return parseInt(p);
		}
		
		private function getDelay(obj:XML):uint {
			var p:String = getProperty(obj, "delay");
			if (p == null) {
				return 0;
			}
			return parseFloat(p);
		}
	}

}