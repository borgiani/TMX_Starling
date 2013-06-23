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
	import starling.display.Sprite;
	
	/**
	 * @author Felipe Borgiani
	 * Based on the original TMXTileSheet by Shaun Mitchell
	 */
	public class TMXLayer
	{
		private var _name:String;		
		private var _layerData:Array = new Array(); // Layer Data is just an array of tile GIDs
		private var _layerSprite:Sprite;
		private var _properties:Dictionary = new Dictionary();
		
		public function TMXLayer(name:String):void
		{
			_name = name;
			_layerSprite = new Sprite();
		}
		
		public function get layerData():Array
		{
			return _layerData;
		}
		
		public function get layerSprite():Sprite
		{
			return _layerSprite;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get properties():Dictionary 
		{
			return _properties;
		}
		
		public function set layerData(value:Array):void 
		{
			_layerData = value;
		}
	}
}
