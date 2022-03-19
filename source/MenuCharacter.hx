package;

import flixel.FlxSprite;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end
import haxe.Json;

typedef MenuCharacterFile = {
	var image:String;
	var scale:Float;
	var position:Array<Float>;
	var idle_anim:String;
	var confirm_anim:String;
	var flipX:Bool;
}

class MenuCharacter extends FlxSprite
{
	public var character:String;
	public var hasConfirmAnimation:Bool = false;
	private static var DEFAULT_CHARACTER:String = 'bf';

	public function new(x:Float, character:String = 'bf')
	{
		super(x);

		changeCharacter(character);
	}

	public function changeCharacter(?character:String = 'bf') {
		if (character == null) character = '';
		if (character == this.character) return;

		this.character = character;
		antialiasing = ClientPrefs.globalAntialiasing;
		visible = true;

		var dontPlayAnim:Bool = false;
		scale.set(1, 1);
		updateHitbox();

		hasConfirmAnimation = false;
		switch(character) {
			case '':
				visible = false;
				dontPlayAnim = true;
			default:
				var charFile:MenuCharacterFile = null;
				var characterPath:String = 'images/menucharacters/$character.json';
				var rawJson = null;

				#if MODS_ALLOWED
				var path:String = Paths.modFolders(characterPath);
				if (!FileSystem.exists(path)) {
					path = Paths.getPreloadPath(characterPath);
				}

				if (!FileSystem.exists(path)) {
					path = Paths.getPreloadPath('images/menucharacters/$DEFAULT_CHARACTER.json');
				}
				rawJson = File.getContent(path);

				#else
				var path:String = Paths.getPreloadPath(characterPath);
				if (!Assets.exists(path)) {
					path = Paths.getPreloadPath('images/menucharacters/$DEFAULT_CHARACTER.json');
				}
				rawJson = Assets.getText(path);
				#end
				
				charFile = cast Json.parse(rawJson);

				var imagePath = 'menucharacters/${charFile.image}';
				if (Paths.fileExists('images/$imagePath/Animation.json', TEXT)) {
					frames = AtlasFrameMaker.construct(imagePath);
				} else {
					frames = Paths.getSparrowAtlas(imagePath);
				}
				animation.addByPrefix('idle', charFile.idle_anim, 24);
				
				var confirmAnim:String = charFile.confirm_anim;
				if(confirmAnim != null && confirmAnim != charFile.idle_anim)
				{
					animation.addByPrefix('confirm', confirmAnim, 24, false);
					if (animation.getByName('confirm') != null) //check for invalid animation
						hasConfirmAnimation = true;
				}

				flipX = (charFile.flipX == true);

				if (charFile.scale != 1) {
					scale.set(charFile.scale, charFile.scale);
					updateHitbox();
				}
				offset.set(charFile.position[0], charFile.position[1]);
				animation.play('idle');
		}
	}
}
