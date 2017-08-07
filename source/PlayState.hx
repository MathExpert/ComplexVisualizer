package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.scaleModes.*;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{	
	private var zeroLabel:FlxText;
	
	private var graph:Graph;

	override public function create():Void
	{
		super.create();
		
		bgColor = FlxColor.WHITE;
		FlxG.scaleMode = new FixedScaleMode();
		
		graph = new Graph();
		add(graph);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}