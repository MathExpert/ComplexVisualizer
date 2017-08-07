package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;

class NumberLabels extends FlxSpriteGroup
{
	public var labelsX:Array<FlxText>;
	public var labelsY:Array<FlxText>;
	
	public function showsLabels(startX:Int, yPos:Int, startY:Int, xPos:Int, pixStep:Int, startTextX:Float, startTextY:Float, step:Float)
	{
		var nextSpot:Int = startX;
		var nextText:Float = startTextX;
		if (startTextY < 0) {
		for (label in labelsX)
		{
			if (nextSpot <= FlxG.width)
			{
				label.x = nextSpot;
				label.y = yPos;
				label.text = Std.string(nextText);
				label.visible = true;
			}
			else
			{
				label.visible = false;
			}
			
			nextSpot += pixStep;
			nextText += step;
		}}
		
		nextSpot = startY;
		nextText = startTextY;
		if (startTextX <= 0) {
		for (label in labelsY)
		{
			if (nextSpot <= FlxG.height)
			{
				label.x = nextSpot;
				label.y = xPos;
				label.text = Std.string(nextText);
				label.visible = true;
			}
			else
			{
				label.visible = false;
			}
			
			nextSpot += pixStep;
			nextText += step;
		}}
	}
	
	public function showLabels(xMarks:Array<Float>, yMarks:Array<Float>, xMarksNum:Int, yMarksNum:Int, firstBigStepX:Int, firstBigStepY:Int, xAxisPos:Float, yAxisPos:Float, stepBase:Int, stepPow:Int)
	{
		var i:Int = 0;
	
		FlxG.watch.addQuick("xAxisPos", xAxisPos);
		FlxG.watch.addQuick("labelsX.length", labelsX.length);
		FlxG.watch.addQuick("xMarks.length", xMarks.length);
		FlxG.watch.addQuick("labelsY.length", labelsY.length);
		FlxG.watch.addQuick("yMarks.length", yMarks.length);
		
		var xAxisTextPos = xAxisPos >= 0 ? xAxisPos : 0;
		var yAxisTextPos = yAxisPos >= 0 ? yAxisPos : 0;
		
		while (i < xMarksNum)
		{
			labelsX[i].visible = true;
			labelsX[i].x = xMarks[i];
			labelsX[i].y = xAxisTextPos;
			labelsX[i].text = makeLabelText(firstBigStepX++, stepBase, stepPow);
			++i;
		}
		
		while (i < xMarks.length)
		{
			labelsX[i].visible = false;
			++i;
		}
		
		i = 0;
		while (i < yMarksNum)
		{
			labelsY[i].visible = true;
			labelsY[i].x = yAxisTextPos;
			labelsY[i].y = yMarks[i];
			labelsY[i].text = makeLabelText(firstBigStepY++, stepBase, stepPow);
			++i;
		}
		
		while (i < yMarks.length)
		{
			labelsY[i].visible = false;
			++i;
		}
	}
	
	public function create(maxLabelsX:Int, maxLabelsY:Int)
	{
		labelsX = new Array<FlxText>();
		labelsY = new Array<FlxText>();
		
		var i:Int = 0;
		while (i < maxLabelsX)
		{
			labelsX[i] = new FlxText();
			labelsX[i].color = FlxColor.BLACK;
			labelsX[i].size = 14;
			labelsX[i].font = "Arial";
			add(labelsX[i]);
			++i;
		}
		
		i = 0;
		while (i < maxLabelsY)
		{
			labelsY[i] = new FlxText();
			labelsY[i].color = FlxColor.BLACK;
			labelsY[i].size = 14;
			labelsY[i].font = "Arial";
			add(labelsY[i]);
			++i;
		}
		
		for (txt in labelsX)
		{
			txt.visible = false;
		}
		
		for (txt in labelsY)
		{
			txt.visible = false;
		}
		
		visible = true;
	}
	
	// TODO: more advanced logic here, for example can return "100", "200", "500", 
	// and then at some point "1*10^6", "2*10^6", "5*10^6" etc
	private function makeLabelText(mult:Int, base:Int, pow:Int):String
	{
		return Std.string(mult * (base * Math.pow(10, pow)));
	}

	public function new() 
	{
		super();
		visible = false;
	}
}