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
	/**
	 * ...
	 * @author Felipe Borgiani
	 */
	public class TMXObjectPolygon extends TMXObject
	{
		private var _points:Vector.<Point>;
		
		public function TMXObjectPolygon() 
		{
			_points = new Vector.<Point>();
		}
		
		public function get points():Vector.<Point> 
		{
			return _points;
		}
		
	}

}