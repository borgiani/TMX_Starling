package com.felipeborgiani.tmxexamples 
{
	import flash.display.Bitmap;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.tmxmaps.TMXTileMap;
	
	/**
	 * ...
	 * @author Felipe Borgiani
	 */
	public class DisplayMap extends Sprite 
	{
		[Embed(source="../../../../assets/example.tmx", mimeType="application/octet-stream")]
		private static var exampleTMX:Class;
		
		[Embed(source = "../../../../assets/tmw_desert_spacing.png")]
		private static var exampleTileSet:Class;
		
		private var mapTMX:TMXTileMap;
		
		public function DisplayMap()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var mapXML:XML = XML(new exampleTMX());
			var tilesets:Vector.<Bitmap> = new Vector.<Bitmap>();
			tilesets.push(Bitmap(new exampleTileSet()));
			
			mapTMX = new TMXTileMap();
			mapTMX.addEventListener(Event.COMPLETE, loadComplete);
			mapTMX.loadFromEmbed(mapXML, tilesets);
		}
		
		private function loadComplete(e:Event):void 
		{
			for (var i:int = 0; i < mapTMX.layers.length; i++) 
			{
				addChild(mapTMX.layers[i].layerHolder);
			}
		}		
	}

}