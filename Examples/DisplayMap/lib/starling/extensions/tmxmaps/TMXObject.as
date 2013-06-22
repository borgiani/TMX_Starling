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
	import flash.geom.Point;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Felipe Borgiani
	 */
	public class TMXObject 
	{
		protected var _name:String;
		protected var _type:String;
		protected var _position:Point;
		protected var _width:uint;
		protected var _height:uint;
		protected var _rotation:Number;
		protected var _tileGID:uint;
		protected var _visible:Boolean;
		protected var _properties:Dictionary;
		
		/**
		 * Creates a new TMXObject
		 */
		public function TMXObject() 
		{
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function get position():Point 
		{
			return _position;
		}
		
		public function get width():uint 
		{
			return _width;
		}
		
		public function get height():uint 
		{
			return _height;
		}
		
		public function get rotation():Number 
		{
			return _rotation;
		}
		
		public function get tileGID():uint 
		{
			return _tileGID;
		}
		
		public function get visible():Boolean 
		{
			return _visible;
		}
		
		/**
		 * The object's properties. A property is a Dictionary of Strings.
		 */
		public function get properties():Dictionary 
		{
			return _properties;
		}
		
	}

}