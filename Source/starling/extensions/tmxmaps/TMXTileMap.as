/*
 * Copyright (C) 2013 Felipe Borgiani
 * Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
 * TMX Maps extension for Starling Framework
 * By: Felipe Borgiani : http://felipeborgiani.com
 * Based on: https://gist.github.com/shaunus84/3216598
 * 
 * Last update: 22/06/2013
 */
package starling.extensions.tmxmaps
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 * @author Felipe Borgiani
	 * Based on the original TMXTileSheet by Shaun Mitchell
	 */
	public class TMXTileMap extends Sprite
	{
		// The TMX file to load
		private var _fileName:String;
		private var _loader:URLLoader;
		private var _mapLoaded:Boolean;
		// XML of TMX file
		private var _TMX:XML;
		// Layers and tilesheet holders
		private var _layers:Vector.<TMXLayer>;
		private var _tilesheets:Vector.<TMXTileSheet>;
		// variables pertaining to map description
		private var _numLayers:uint;
		private var _numTilesets:uint;
		private var _tilelistCount:uint;
		private var _mapWidth:uint;
		private var _tileHeight:uint;
		private var _tileWidth:uint;
		// used to get the correct tile from various tilesheets
		private var _gidLookup:Vector.<uint>;
		private var _embedTilesets:Vector.<Bitmap>;

		public function TMXTileMap():void
		{
			_mapLoaded = false;
			_fileName = "";
			_loader = new URLLoader();
			_numLayers = 0;
			_numTilesets = 0;
			_tilelistCount = 0;
			_mapWidth = 0;
			_tileHeight = 0;
			_tileWidth = 0;

			_layers = new Vector.<TMXLayer>();
			_tilesheets = new Vector.<TMXTileSheet>();
			_gidLookup = new Vector.<uint>();
		}

		public function load(file:String):void
		{
			_fileName = file;
			
			trace(_fileName);

			_loader.addEventListener(flash.events.Event.COMPLETE, loadTilesets);
			_loader.load(new URLRequest(_fileName));
		}

		public function loadFromEmbed(tmx:XML, tilesets:Vector.<Bitmap>):void
		{
			_TMX = tmx;
			_embedTilesets = tilesets;

			loadEmbedTilesets();
		}

		// Getters ------------------------------------------
		public function get layers():Vector.<TMXLayer>
		{
			return _layers;
		}

		public function get tilesheets():Vector.<TMXTileSheet>
		{
			return _tilesheets;
		}

		public function get numLayers():uint
		{
			return _numLayers;
		}

		public function get numTilesets():uint
		{
			return _numTilesets;
		}

		public function get mapWidth():uint
		{
			return _mapWidth;
		}

		public function get tileHeight():uint
		{
			return _tileHeight;
		}

		public function get tileWidth():uint
		{
			return _tileWidth;
		}

		// End getters --------------------------------------
		// get the number of tilsets from the TMX XML
		private function getNumTilesets():uint
		{
			if (_mapLoaded)
			{
				var count:uint = 0;
				for (var i:int = 0; i < _TMX.children().length(); i++)
				{
					if (_TMX.tileset[i] != null)
					{
						count++;
					}
				}

				trace(count);
				return count;
			}

			return 0;
		}

		// get the number of layers from the TMX XML
		private function getNumLayers():uint
		{
			if (_mapLoaded)
			{
				var count:uint = 0;
				for (var i:int = 0; i < _TMX.children().length(); i++)
				{
					if (_TMX.layer[i] != null)
					{
						count++;
					}
				}

				trace(count);
				return count;
			}
			return 0;
		}

		private function loadTilesets(event:flash.events.Event):void
		{
			trace("loading tilesets from file");
			_mapLoaded = true;

			_TMX = new XML(_loader.data);

			if (_TMX)
			{
				_mapWidth = _TMX.@width;
				_tileHeight = _TMX.@tileheight;
				_tileWidth = _TMX.@tilewidth;

				trace("map width" + _mapWidth);

				_numLayers = getNumLayers();
				_numTilesets = getNumTilesets();
				// _TMX.properties.property[1].@value;

				var tileSheet:TMXTileSheet = new TMXTileSheet();
				tileSheet.loadTileSheet(_TMX.tileset[_tilelistCount].@name, _TMX.tileset[_tilelistCount].image.@source, _TMX.tileset[_tilelistCount].@tilewidth, _TMX.tileset[_tilelistCount].@tileheight, _TMX.tileset[_tilelistCount].@firstgid - 1);
				tileSheet.addEventListener(starling.events.Event.COMPLETE, loadRemainingTilesets);
				_tilesheets.push(tileSheet);
				_gidLookup.push(_TMX.tileset[_tilelistCount].@firstgid);
			}
		}

		private function loadEmbedTilesets():void
		{
			trace("loading embedded tilesets");
			_mapLoaded = true;

			if (_TMX)
			{
				_mapWidth = _TMX.@width;
				_tileHeight = _TMX.@tileheight;
				_tileWidth = _TMX.@tilewidth;

				trace("map width" + _mapWidth);

				_numLayers = getNumLayers();
				_numTilesets = getNumTilesets();
				trace(_numTilesets);
				// _TMX.properties.property[1].@value;

				for (var i:int = 0; i < _numTilesets; i++)
				{
					var tileSheet:TMXTileSheet = new TMXTileSheet();
					trace(_TMX.tileset[i].@name, _embedTilesets[i], _TMX.tileset[i].@tilewidth, _TMX.tileset[i].@tileheight, _TMX.tileset[i].@firstgid - 1, _TMX.tileset[i].@spacing, _TMX.tileset[i].@margin);
					tileSheet.loadEmbedTileSheet(_TMX.tileset[i].@name, _embedTilesets[i], _TMX.tileset[i].@tilewidth, _TMX.tileset[i].@tileheight, _TMX.tileset[i].@firstgid - 1, _TMX.tileset[i].@spacing, _TMX.tileset[i].@margin);
					_tilesheets.push(tileSheet);
					_gidLookup.push(_TMX.tileset[i].@firstgid);
				}
				
				loadMapData();
			}
		}

		private function loadRemainingTilesets(event:starling.events.Event):void
		{
			event.target.removeEventListener(starling.events.Event.COMPLETE, loadRemainingTilesets);

			_tilelistCount++;
			if (_tilelistCount >= _numTilesets)
			{
				trace("done loading tilelists");
				loadMapData();
			}
			else
			{
				trace(_TMX.tileset[_tilelistCount].@name);
				var tileSheet:TMXTileSheet = new TMXTileSheet();
				tileSheet.loadTileSheet(_TMX.tileset[_tilelistCount].@name, _TMX.tileset[_tilelistCount].image.@source, _TMX.tileset[_tilelistCount].@tilewidth, _TMX.tileset[_tilelistCount].@tileheight, _TMX.tileset[_tilelistCount].@firstgid - 1);
				tileSheet.addEventListener(starling.events.Event.COMPLETE, loadRemainingTilesets);
				_gidLookup.push(_TMX.tileset[_tilelistCount].@firstgid);
				_tilesheets.push(tileSheet);
			}
		}

		private function loadMapData():void
		{
			if (_mapLoaded)
			{
				for (var i:int = 0; i < _numLayers; i++)
				{
					trace("loading map data");
					var ba:ByteArray = Base64.decode(_TMX.layer[i].data);
					ba.uncompress();

					var data:Array = new Array();

					for (var j:int = 0; j < ba.length; j += 4)
					{
						// Get the grid ID

						var a:int = ba[j];
						var b:int = ba[j + 1];
						var c:int = ba[j + 2];
						var d:int = ba[j + 3];

						var gid:int = a | b << 8 | c << 16 | d << 24;
						data.push(gid);
					}

					var tmxLayer:TMXLayer = new TMXLayer(data);

					_layers.push(tmxLayer);
				}

				drawLayers();
			}
		}

		// draw the layers into a holder contained in a TMXLayer object
		private function drawLayers():void
		{
			trace("drawing layers");
			for (var i:int = 0; i < _numLayers; i++)
			{
				trace("drawing layers");
				var row:int = 0;
				var col:int = 0;
				for (var j:int = 0; j < _layers[i].layerData.length; j++)
				{
					if (col > (_mapWidth - 1) * _tileWidth)
					{
						col = 0;
						row += _tileHeight;
					}

					if (_layers[i].layerData[j] != 0)
					{
						var img:Image = new Image(_tilesheets[findTileSheet(_layers[i].layerData[j])].textureAtlas.getTexture(String(_layers[i].layerData[j])));
						img.x = col;
						img.y = row;
						_layers[i].layerSprite.addChild(img);
					}

					col += _tileWidth;
				}
				
				if (!_layers[i].layerSprite.isFlattened)
				{
					_layers[i].layerSprite.flatten();
				}
			}

			// notify that the load is complete
			dispatchEvent(new starling.events.Event(starling.events.Event.COMPLETE));
		}

		private function findTileSheet(id:uint):int
		{
			var value:int = 0;
			var theOne:int;
			for (var i:int = 0; i < _tilesheets.length; i++)
			{
				if (_tilesheets[i].textureAtlas.getTexture(String(id)) != null)
				{
					theOne = i;
				}
				else
				{
					value = i;
				}
			}
			return theOne;
		}
	}
}
