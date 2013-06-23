TMX Maps Support for Starling Framework
=======================================

Overview
--------

This extension is based on the one created by [Shaun Mitchell](http://wiki.starling-framework.org/extensions/tmx_loader), and allows a starling game to load and display a TMX Tilemap created using [Tiled](http://mapeditor.org)

The major contributions include:
  * Compatible with Starling v1.3
  * Target is Tiled 0.9.0
  * Ability to use tilesets with margins and spacing
  * Improved performance by using flattened sprites
  * more to come...

This extension is still under development. If you want to contribute, feel free to help out.

**Known issues:**
  * Can't load tilemaps that use a TSX tileset
  * No support for properties yet
  * No support for objects yet


Examples
--------
There is an example project included with the extension, but there are some examples below:

Loading your tilemap using embedded assets:
```actionscript
[Embed(source="exampleTileSet.png")]
private static var tilesetImage:Class;
 
[Embed(source="exampleMap.tmx", mimeType="application/octet-stream")]
private static var mapTMX:Class;

// (...)

var map:TMXTileMap = new TMXTileMap();
map.addEventListener(Event.COMPLETE, loadComplete);

var tilesets:Vector.<Bitmap> = new Vector.<Bitmap>();
tilesets.push(Bitmap(new tilesetImage()));
 
var mapXML:XML = XML(new mapTMX());
TMX.loadFromEmbed(mapXML, tilesets);
```

Here's an example for displaying your map:
```actionscript
private function loadComplete(e:Event):void 
{
    for (var i:int = 0; i < map.layers.length; i++) 
    {
        addChild(map.layers[i].layerSprite);
    }
}
```
