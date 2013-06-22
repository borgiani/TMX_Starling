package starling.extensions.tmxmaps
{
	import starling.display.Sprite;
	/**
	 * @author shaun.mitchell
	 */
	public class TMXLayer extends Sprite
	{
		private var _layerData:Array = new Array();
		private var _layerHolder:Sprite = new Sprite;
		
		public function TMXLayer(data:Array):void
		{
			_layerData = data;
		}
		
		public function getData():Array
		{
			return _layerData;
		}
		
		public function getHolder():Sprite
		{
			return _layerHolder;
		}
		
		public function drawLayer():void
		{
			addChild(_layerHolder);
		}
	}
}
