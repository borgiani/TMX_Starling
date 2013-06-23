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
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Felipe Borgiani
	 */
	public class TMXTile 
	{
		private var _parentSheet:TMXTileSheet;
		private var _tileID:uint;
		private var _properties:Dictionary;
		
		public function TMXTile(parentSheet:TMXTileSheet, tileID:uint)
		{
			this._properties = new Dictionary();
			this._parentSheet = parentSheet;
			this._tileID = tileID;
		}
		
		public function get parentSheet():TMXTileSheet 
		{
			return _parentSheet;
		}
		
		public function get tileID():uint 
		{
			return _tileID;
		}

		public function get properties():Dictionary 
		{
			return _properties;
		}		
		
		public function get texture():Texture 
		{
			return _parentSheet.textureAtlas.getTexture(String(_tileID));
		}
	}

}