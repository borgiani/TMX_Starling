package starling.extensions.tmxmaps
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;

	/**
	 * @author Felipe Borgiani
	 * Based on the original TMXTileSheet by Shaun Mitchell
	 */
	public class TMXTileSheet extends Sprite
	{
		// the name and file paths
		private var _name:String;
		private var _sheetFilename:String;
		// texture, atlas and loader
		private var _sheet:Bitmap;
		private var _textureAtlas:TextureAtlas;
		private var _imageLoader:Loader = new Loader();
		private var _startID:uint;
		private var _tileHeight:uint;
		private var _tileWidth:uint;
		private var _embedded:Boolean;
		private var _spacing:uint;
		private var _margin:uint;

		public function TMXTileSheet():void
		{
		}

		public function loadTileSheet(name:String, sheetFile:String, tileWidth:uint, tileHeight:uint, startID:uint):void
		{
			_embedded = false;
			_name = name;
			_sheetFilename = sheetFile;
			_startID = startID;

			_tileHeight = tileHeight;
			_tileWidth = tileWidth;

			trace("creating TMX tilesheet");

			_imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, loadSheet);
			_imageLoader.load(new URLRequest(_sheetFilename));
		}

		public function loadEmbedTileSheet(name:String, img:Bitmap, tileWidth:uint, tileHeight:uint, startID:uint, spacing:uint, margin:uint):void
		{
			trace("creating TMX tilesheet");
			_embedded = true;
			_name = name;
			_startID = startID;

			_sheet = img;

			_tileHeight = tileHeight;
			_tileWidth = tileWidth;
			
			_spacing = spacing;
			_margin = margin;

			loadAtlas();
		}

		/*
		Load the image file needed for this tilesheet
		 */
		private function loadSheet(event:flash.events.Event):void
		{
			var sprite:DisplayObject = _imageLoader.content;
			_sheet = Bitmap(sprite);

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

			var id:int = _startID;

			var xml:XML = <Atlas></Atlas>;

			xml.appendChild(<TextureAtlas imagePath={_sheetFilename}></TextureAtlas>);

			for (var i:int = 0; i < numRows; i++)
			{
				for (var j:int = 0; j < numCols; j++)
				{
					id++;
					xml.child("TextureAtlas").appendChild(<SubTexture name={id} x = {(_margin + (j * (_tileWidth + _spacing)))} y={(_margin + (i * (_tileHeight + _spacing))) } width={_tileWidth} height={_tileHeight}/>);
				}
			}

			var newxml:XML = XML(xml.TextureAtlas);

			trace(newxml);

			_textureAtlas = new TextureAtlas(Texture.fromBitmap(_sheet), newxml);
			trace("done with atlas, dispatching");
			dispatchEvent(new starling.events.Event(starling.events.Event.COMPLETE));
		}

		public function get sheet():Bitmap
		{
			return _sheet;
		}

		public function get textureAtlas():TextureAtlas
		{
			return _textureAtlas;
		}
	}
}
