package;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Jared Okun
 */
class Tile extends FlxSprite 
{
	var _occupiedEntity:Entity;
	public function new(tilePath:String) 
	{
		super();
		loadGraphic("assets/images/gridTile.png");
	}
	
	public function setOccupiedEntity(entity:Entity):Void
	{
		_occupiedEntity = entity;
	}
	
}