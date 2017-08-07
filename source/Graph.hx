package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxG;

enum Axis
{
	X;
	Y;
}

class Graph extends FlxSpriteGroup
{
	private var canvas:GraphCanvas;
	private var numberLabels:NumberLabels;
	
	public function new()
	{	
		super();
		
		numberLabels = new NumberLabels();
		canvas = new GraphCanvas(FlxG.width, FlxG.height, numberLabels, new ComplexFunctions());
		
		add(canvas);
		add(numberLabels);
	}	
}