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
	import flash.events.Event;
	import flash.utils.Dictionary;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;


	/**
	 * @author Felipe Borgiani
	 * Based on the original TMXTileSheet by Shaun Mitchell
	 */
	public class TMXTileSheet extends EventDispatcher
	{
		// the name and file paths
		private var _name:String;
		private var _sheetFilename:String;
		// texture, atlas and loader
		private var _sheet:Bitmap;
		private var _textureAtlas:TextureAtlas;
		private var _firstID:uint;
		private var _tileHeight:uint;
		private var _tileWidth:uint;
		//private var _embedded:Boolean;
		private var _spacing:uint;
		private var _margin:uint;
		// tiles
		private var _tiles:Vector.<TMXTile>;
		// properties
		private var _properties:Dictionary;

		public function TMXTileSheet():void
		{
			_tiles = new Vector.<TMXTile>();
			_properties = new Dictionary();
		}

		public function loadTileSheet(name:String, img:Bitmap, tileWidth:uint, tileHeight:uint, startID:uint, spacing:uint, margin:uint):void
		{
			trace("creating TMX tilesheet");
			_name = name;
			_firstID = startID;

			_sheet = img;

			_tileHeight = tileHeight;
			_tileWidth = tileWidth;
			
			_spacing = spacing;
			_margin = margin;

			loadAtlas();
		}

		/*
		dynamically create a texture atlas to look up tiles
		 */
		private function loadAtlas():void
		{
			trace("loading atlas");
			var numRows:uint = (_sheet.height - _margin) / (_tileHeight + _spacing);
			var numCols:uint = (_sheet.width - _margin) / (_tileWidth + _spacing);

			var id:int = _firstID;

			var xml:XML = <Atlas></Atlas>;

			xml.appendChild(<TextureAtlas imagePath={_sheetFilename}></TextureAtlas>);

			for (var i:int = 0; i < numRows; i++)
			{
				for (var j:int = 0; j < numCols; j++)
				{
					id++;
					xml.child("TextureAtlas").appendChild(<SubTexture name={id} x = {(_margin + (j * (_tileWidth + _spacing)))} y={(_margin + (i * (_tileHeight + _spacing))) } width={_tileWidth} height={_tileHeight}/>);
					
					_tiles.push(new TMXTile(this, id));
				}
			}

			var newxml:XML = XML(xml.TextureAtlas);

			//trace(newxml);

			_textureAtlas = new TextureAtlas(Texture.fromBitmap(_sheet), newxml);
			
			trace("done with atlas, dispatching");
			dispatchEvent(new starling.events.Event(starling.events.Event.COMPLETE));
		}
		
		public function tileWithGID(gid:uint):TMXTile
		{
			for (var i:int = 0; i < _tiles.length; i++) 
			{
				if (_tiles[i].tileID == gid)
					return _tiles[i];
			}
			
			return null;
		}

		public function get sheet():Bitmap
		{
			return _sheet;
		}

		public function get textureAtlas():TextureAtlas
		{
			return _textureAtlas;
		}
		
		public function get firstID():uint 
		{
			return _firstID;
		}
		
		public function get tiles():Vector.<TMXTile> 
		{
			return _tiles;
		}
		
		public function get properties():Dictionary 
		{
			return _properties;
		}
	}
}
