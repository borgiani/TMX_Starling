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
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import starling.display.Image;
	import starling.extensions.tmxmaps.tools.Base64;

	/**
	 * @author Felipe Borgiani
	 * Based on the original TMXTileSheet by Shaun Mitchell
	 */
	public class TMXTileMap
	{
		// XML of TMX file
		private var _mapXML:XML;
		// Layers and tilesheet holders
		private var _layers:Vector.<TMXLayer>;
		private var _tilesheets:Vector.<TMXTileSheet>;
		private var _objectGroups:Vector.<TMXObjectGroup>;
		// variables pertaining to map description
		private var _numLayers:uint;
		private var _numTilesets:uint;
		private var _tilelistCount:uint;
		private var _mapWidth:uint;
		private var _tileHeight:uint;
		private var _tileWidth:uint;
		private var _backgroundColor:uint;
		private var _properties:Dictionary;
		// used to get the correct tile from various tilesheets
		private var _embedTilesets:Vector.<Bitmap>;		

		public function TMXTileMap():void
		{
			_numLayers = 0;
			_numTilesets = 0;
			_tilelistCount = 0;
			_mapWidth = 0;
			_tileHeight = 0;
			_tileWidth = 0;

			_properties = new Dictionary();
			_layers = new Vector.<TMXLayer>();
			_tilesheets = new Vector.<TMXTileSheet>();
			_objectGroups = new Vector.<TMXObjectGroup>();
		}
		
		/**
		 * Creates a new TileMap
		 * @param	tmx The XML from the .tmx file
		 * @param	tilesets A vector of bitmaps, containing all the tileset images used on the tmx map
		 * @return A tilemap loadded from the given tmx map and tilesets
		 */
		public static function createMap(tmx:XML, tilesets:Vector.<Bitmap>):TMXTileMap
		{
			var map:TMXTileMap = new TMXTileMap();
			
			map.load(tmx, tilesets);
			
			return map;
		}

		/**
		 * Loads the tilemap from a tmx file and a vector of tilesets
		 * @param	tmx The XML from the .tmx file
		 * @param	tilesets A vector of bitmaps, containing all the tileset images used on the tmx map
		 */
		public function load(tmx:XML, tilesets:Vector.<Bitmap>):void
		{
			_mapXML = tmx;
			_embedTilesets = tilesets;

			loadTilesets();
			loadObjectGroups(tmx);
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
		
		public function get objectGroups():Vector.<TMXObjectGroup> 
		{
			return _objectGroups;
		}
		
		public function get properties():Dictionary 
		{
			return _properties;
		}
		
		public function get backgroundColor():uint 
		{
			return _backgroundColor;
		}

		// End getters --------------------------------------
		// get the number of tilsets from the TMX XML
		private function getNumTilesets():uint
		{
			if (_mapXML)
			{
				return _mapXML.tileset.length();
			}

			return 0;
		}

		// get the number of layers from the TMX XML
		private function getNumLayers():uint
		{
			if (_mapXML)
			{
				return _mapXML.layer.length();
			}
			return 0;
		}
		
		private function loadObjectGroups(tmx:XML):void 
		{
			for (var i:int = 0; i < tmx.objectgroup.length(); i++)
			{
				var objGroup:TMXObjectGroup = new TMXObjectGroup();
				objGroup.name = tmx.objectgroup[i].@name;
				objGroup.width = tmx.objectgroup[i].@width;
				objGroup.height = tmx.objectgroup[i].@height;
				
				for (var j:int = 0; j < tmx.objectgroup[i].object.length(); j++)
				{
					var obj:TMXObject;
					if (tmx.objectgroup[i].object[j].ellipse != undefined)
					{
						// Object is an ellipse
						obj = new TMXObjectEllipse();
					}
					else if (tmx.objectgroup[i].object[j].polygon != undefined)
					{
						obj = new TMXObjectPolygon();
						
						var polyPointsString:String = tmx.objectgroup[i].object[j].polygon.@points;
						var polyPoints:Array = polyPointsString.split(" ");
						
						for each (var polyPoint:String in polyPoints) 
						{
							var xy:Array = polyPoint.split(",");
							var point:Point = new Point(Number(xy[0]), Number(xy[1]));
							(obj as TMXObjectPolygon).points.push(point);
						}
					}
					else if (tmx.objectgroup[i].object[j].polyline != undefined)
					{
						obj = new TMXObjectPolyline();
						
						var polylinePointsString:String = tmx.objectgroup[i].object[j].polyline.@points;
						var polylinePoints:Array = polylinePointsString.split(" ");
						
						for each (var polylinePoint:String in polylinePoints) 
						{
							var linexy:Array = polylinePoint.split(",");
							var linepoint:Point = new Point(Number(linexy[0]), Number(linexy[1]));
							(obj as TMXObjectPolyline).points.push(linepoint);
						}
					}
					else
					{
						obj = new TMXObject();
					}
					
					obj.name = tmx.objectgroup[i].object[j].@name;
					
					var x:int = tmx.objectgroup[i].object[j].@x;
					var y:int = tmx.objectgroup[i].object[j].@y;
					obj.position = new Point(x, y);
					
					obj.width = tmx.objectgroup[i].object[j].@width;
					obj.height = tmx.objectgroup[i].object[j].@height;					
					obj.type = tmx.objectgroup[i].object[j].@type;					
					obj.visible = tmx.objectgroup[i].object[j].@visible;
					
					for (var k:int = 0; k < tmx.objectgroup[i].object[j].properties.property.length(); k++)
					{
						var propName:String = tmx.objectgroup[i].object[j].properties.property[k].@name;
						var propValue:String = tmx.objectgroup[i].object[j].properties.property[k].@value;
						obj.properties[propName] = propValue;
					}
					
					objGroup.objects.push(obj);
				}
				
				objectGroups.push(objGroup);
			}
		}

		private function loadTilesets():void
		{
			if (_mapXML)
			{
				_mapWidth = _mapXML.@width;
				_tileHeight = _mapXML.@tileheight;
				_tileWidth = _mapXML.@tilewidth;
				
				var bgColor:String = _mapXML.@backgroundcolor;
				_backgroundColor = uint("0x" + bgColor.substring(1,bgColor.length));

				_numLayers = getNumLayers();				
				_numTilesets = getNumTilesets();
				trace(_numTilesets);
				
				for (var k:int = 0; k < _mapXML.properties.property.length(); k++) 
				{
					var mappname:String = _mapXML.properties.property[k].@name;
					var mappvalue:String = _mapXML.properties.property[k].@value;
					_properties[mappname] = mappvalue;
				}

				for (var i:int = 0; i < _numTilesets; i++)
				{
					var tileSheet:TMXTileSheet = new TMXTileSheet();
					//trace(_TMX.tileset[i].@name, _embedTilesets[i], _TMX.tileset[i].@tilewidth, _TMX.tileset[i].@tileheight, _TMX.tileset[i].@firstgid - 1, _TMX.tileset[i].@spacing, _TMX.tileset[i].@margin);
					tileSheet.loadTileSheet(_mapXML.tileset[i].@name, _embedTilesets[i], _mapXML.tileset[i].@tilewidth, _mapXML.tileset[i].@tileheight, _mapXML.tileset[i].@firstgid - 1, _mapXML.tileset[i].@spacing, _mapXML.tileset[i].@margin);
					
					for (var tcounter:int = 0; tcounter < _mapXML.tileset[i].tile.length(); tcounter++)
					{
						var tile:TMXTile = tileSheet.tileWithGID(int(_mapXML.tileset[i].tile[tcounter].@id));
						
						for (var l:int = 0; l < _mapXML.tileset[i].tile[tcounter].properties.property.length(); l++) 
						{
							var tilepname:String = _mapXML.tileset[i].tile[tcounter].properties.property[l].@name;
							var tilepvalue:String = _mapXML.tileset[i].tile[tcounter].properties.property[l].@value;
							
							tile.properties[tilepname] = tilepvalue;
						}
					}
					
					for (var j:int = 0; j < _mapXML.tileset[i].properties.property.length(); j++) 
					{
						var pname:String = _mapXML.tileset[i].properties.property[j].@name;
						var pvalue:String = _mapXML.tileset[i].properties.property[j].@value;
						tileSheet.properties[pname] = pvalue;
					}
					
					_tilesheets.push(tileSheet);
				}
				
				if (!loadLayers())
					trace("Error loading layers");
			}
		}

		private function loadLayers():Boolean
		{
			if (_mapXML)
			{
				for (var i:int = 0; i < _numLayers; i++)
				{
					var name:String = _mapXML.layer[i].@name;
					var tmxLayer:TMXLayer = new TMXLayer(name);
					
					for (var k:int = 0; k < _mapXML.layer[i].properties.property.length(); k++) 
					{
						var pname:String = _mapXML.layer[i].properties.property[k].@name;
						var pvalue:String = _mapXML.layer[i].properties.property[k].@value;
						tmxLayer.properties[pname] = pvalue;
					}
					
					var ba:ByteArray = Base64.decode(_mapXML.layer[i].data);
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
					
					tmxLayer.layerData = data;
					
					_layers.push(tmxLayer);
				}

				drawLayers();				
				return true;
			}
			else
			{
				return false;
			}
		}

		// draw the layers into a holder contained in a TMXLayer object
		private function drawLayers():void
		{
			//trace("drawing layers");
			for (var i:int = 0; i < _numLayers; i++)
			{
				//trace("drawing layers");
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
						var img:Image = new Image(findTileWithGID(_layers[i].layerData[j]).texture);
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

			// notify that the load is complete - will be implemented when async is working
			//dispatchEvent(new starling.events.Event(starling.events.Event.COMPLETE));
		}
		
		private function findTileWithGID(gid:uint):TMXTile
		{
			var targetSheet:int;
			
			for (var i:int = 0; i < _tilesheets.length; i++) 
			{
				if (gid > _tilesheets[i].firstID)
				{
					targetSheet = i;
				}
			}
			
			return _tilesheets[targetSheet].tileWithGID(gid);
		}
	}
}
