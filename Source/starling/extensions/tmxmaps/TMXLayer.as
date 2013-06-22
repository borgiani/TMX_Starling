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
	import starling.display.Sprite;
	
	/**
	 * @author Felipe Borgiani
	 * Based on the original TMXTileSheet by Shaun Mitchell
	 */
	public class TMXLayer extends Sprite
	{
		private var _layerData:Array = new Array();
		private var _layerSprite:Sprite = new Sprite;
		
		public function TMXLayer(data:Array):void
		{
			_layerData = data;
		}
		
		public function getHolder():Sprite
		{
			return _layerSprite;
		}
		
		public function drawLayer():void
		{
			addChild(_layerSprite);
		}
		
		public function get layerData():Array
		{
			return _layerData;
		}
		
		public function get layerSprite():Sprite
		{
			return _layerSprite;
		}
	}
}
