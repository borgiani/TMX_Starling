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
		private var _properties:Dictionary;
		private var _objects:Vector.<TMXObject>;
		
		public function TMXObjectGroup() 
		{
			
		}
		
		public function get properties():Dictionary 
		{
			return _properties;
		}
		
		public function get objects():Vector.<TMXObject> 
		{
			return _objects;
		}
		
	}

}