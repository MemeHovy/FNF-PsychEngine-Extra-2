package;

import flixel.util.FlxDestroyUtil;
import flixel.FlxG;
import flixel.FlxSprite;

class GitarooPause extends MusicBeatState
{
	var replayButton:FlxSprite;
	var cancelButton:FlxSprite;

	var replaySelect:Bool = false;

	public function new():Void
	{
		super();
	}

	override function create()
	{
		super.create();
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('pauseAlt/pauseBG'));
		add(bg);

		var bf:FlxSprite = new FlxSprite(0, 30);
		bf.frames = Paths.getSparrowAtlas('pauseAlt/bfLol');
		bf.animation.addByPrefix('lol', "funnyThing", 13);
		bf.animation.play('lol');
		add(bf);
		bf.screenCenter(X);

		replayButton = new FlxSprite(FlxG.width * 0.28, FlxG.height * 0.7);
		replayButton.frames = Paths.getSparrowAtlas('pauseAlt/pauseUI');
		replayButton.animation.addByPrefix('selected', 'bluereplay', 0, false);
		replayButton.animation.appendByPrefix('selected', 'yellowreplay');
		replayButton.animation.play('selected');
		add(replayButton);

		cancelButton = new FlxSprite(FlxG.width * 0.58, replayButton.y);
		cancelButton.frames = Paths.getSparrowAtlas('pauseAlt/pauseUI');
		cancelButton.animation.addByPrefix('selected', 'bluecancel', 0, false);
		cancelButton.animation.appendByPrefix('selected', 'cancelyellow');
		cancelButton.animation.play('selected');
		add(cancelButton);

		changeThing();
	}

	override function update(elapsed:Float)
	{
		if (controls.UI_LEFT_P || controls.UI_RIGHT_P || FlxG.mouse.wheel != 0)
			changeThing();

		if (controls.ACCEPT || FlxG.mouse.justPressed)
		{
			if (replaySelect)
			{
				MusicBeatState.switchState(new PlayState());
			}
			else
			{
				PlayState.changedDifficulty = false;
				PlayState.seenCutscene = false;
				PlayState.deathCounter = 0;
				PlayState.chartingMode = false;
				MusicBeatState.switchState(new MainMenuState());
				CoolUtil.playMenuMusic();
			}
		}

		super.update(elapsed);
	}

	function changeThing():Void
	{
		replaySelect = !replaySelect;

		if (replaySelect)
		{
			cancelButton.animation.curAnim.curFrame = 0;
			replayButton.animation.curAnim.curFrame = 1;
		}
		else
		{
			cancelButton.animation.curAnim.curFrame = 1;
			replayButton.animation.curAnim.curFrame = 0;
		}
	}

	override public function destroy() {
		replayButton = FlxDestroyUtil.destroy(replayButton);
		cancelButton = FlxDestroyUtil.destroy(cancelButton);
		super.destroy();
	}
}
