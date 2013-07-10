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
  * Support for properties
  * Support for Objects and Objectgroups
  * more to come...

This extension is still under development. If you want to contribute, feel free to help out.

**Known issues:**
  * Can't load tilemaps that use a TSX tileset


Examples
--------
There is an example project included with the extension. Here's one though:

Loading your tilemap using embedded assets and displaying it:
```actionscript
[Embed(source="../../../../assets/example.tmx", mimeType="application/octet-stream")]
private static var exampleTMX:Class;
 	
[Embed(source = "../../../../assets/tmw_desert_spacing.png")]
private static var exampleTileSet:Class;

// (...)

var mapXML:XML = XML(new exampleTMX());
var tilesets:Vector.<Bitmap> = new Vector.<Bitmap>();
tilesets.push(Bitmap(new exampleTileSet()));
			
var mapTMX:TMXTileMap = TMXTileMap.createMap(mapXML, tilesets);
			
for (var i:int = 0; i < mapTMX.layers.length; i++) 
{
    addChild(mapTMX.layers[i].layerSprite);
}
```
