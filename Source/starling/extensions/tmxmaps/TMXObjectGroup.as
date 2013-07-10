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
	
	/**
	 * ...
	 * @author Felipe Borgiani
	 */
	public class TMXObjectGroup 
	{
		private var _name:String;
		private var _width:int;
		private var _height:int;
		private var _properties:Dictionary;
		private var _objects:Vector.<TMXObject>;
		
		public function TMXObjectGroup() 
		{
			_objects = new Vector.<TMXObject>();
		}
		
		public function get properties():Dictionary 
		{
			return _properties;
		}
		
		public function get objects():Vector.<TMXObject> 
		{
			return _objects;
		}
		
		public function get width():int 
		{
			return _width;
		}
		
		public function get height():int 
		{
			return _height;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function set width(value:int):void 
		{
			_width = value;
		}
		
		public function set height(value:int):void 
		{
			_height = value;
		}
		
	}

}