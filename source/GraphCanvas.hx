package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class GraphCanvas extends FlxSprite
{
	private var numberLabels:NumberLabels;
	private var funcs:Dynamic;
	
	private var gridStep:Float = 1;
	private var pixPerStep = 150;

	private var viewport:FlxRect = new FlxRect();
	
	private var initWidth:Float;
	private var screenRatio:Float;
	
	private var wheelDist:Int = 0;
	private static inline var hopsPerSwitch = 12;
	
	private var stepPow:Int = 0;
	private var stepBase:Int = 1;
	
	private var centerPos:FlxPoint = new FlxPoint();
	private var xAxisPos:Float;
	private var yAxisPos:Float;
	
	private var mouseJustX:Float;
	private var mouseJustY:Float;
	
	private var lineStyleMain:LineStyle = { color:  FlxColor.fromRGB(50, 50, 50), thickness: 2 };
	private var lineStyleBigStep:LineStyle = { color: FlxColor.fromRGB(220, 220, 220), thickness: 1 };
	private var lineStyleSmallStep:LineStyle = { color: FlxColor.fromRGB(200, 200, 200), thickness: 1 };
	
	private var xMarks:Array<Float>;
	private var yMarks:Array<Float>;
	private var xMarksNum:Int;
	private var yMarksNum:Int;
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		fill(FlxColor.TRANSPARENT);
		calcValues();
		calcBigSteps();
		drawBigSteps();
		drawMainAxes();
		
		processInput();
	}

	private function calcValues()
	{
		centerPos.x = height * viewport.bottom / viewport.height;
		centerPos.y = width * -viewport.left / viewport.width;
		xAxisPos = height * viewport.bottom / viewport.height;
		yAxisPos = width * -viewport.left / viewport.width;
	}
	
	private function initViewport()
	{
		initWidth = gridStep * width / pixPerStep;
		viewport.width = initWidth;
		viewport.x = -viewport.width * 0.5;
		viewport.height = initWidth * screenRatio;
		viewport.y = -viewport.height * 0.5;
	}
	
	private function drawMainAxes()
	{
		drawLine(0.0, xAxisPos, width, xAxisPos, lineStyleMain);
		drawLine(yAxisPos, 0.0, yAxisPos, height, lineStyleMain); 
	}
	
	private function drawBigSteps()
	{
		for (pos in xMarks)
		{
			drawLine(pos, 0.0, pos, height, lineStyleBigStep);
		}
		
		for (pos in yMarks)
		{
			drawLine(0.0, pos, width, pos, lineStyleBigStep);
		}
	}
	
	private function calcBigSteps()
	{
		var i:Int = 0;
		while (i < xMarks.length)
		{
			xMarks[i++] = 0;
		}
		
		i = 0;
		while (i < xMarks.length)
		{
			yMarks[i++] = 0;
		}
		
		
		var firstBigStepX:Int = Math.ceil(viewport.left / gridStep);
		var lastBigStepX:Int = Math.floor(viewport.right / gridStep);
		xMarksNum = lastBigStepX - firstBigStepX + 1;
		
		i = 0;
		var coord = firstBigStepX * gridStep;
		while (i < xMarksNum)
		{
			var yAxis = toScreenCoordsX(coord);
			//drawLine(yAxis, 0.0, yAxis, height, lineStyleBigStep);
			coord += gridStep;
			xMarks[i] = yAxis;
			++i;
		}

		var firstBigStepY:Int = Math.ceil(viewport.top / gridStep);
		var lastBigStepY:Int = Math.floor(viewport.bottom / gridStep);
		yMarksNum = lastBigStepY - firstBigStepY + 1;
		FlxG.watch.addQuick("firstBigStepY", firstBigStepY);
		FlxG.watch.addQuick("lastBigStepY", lastBigStepY);
		FlxG.watch.addQuick("yMarksNum", yMarksNum);
		
		i = 0;
		coord = firstBigStepY * gridStep;
		while (i < yMarksNum)
		{
			var xAxis = toScreenCoordsY(coord);
			//drawLine(0.0, height - xAxis, width, height - xAxis, lineStyleBigStep);
			coord += gridStep;
			yMarks[i] = height - xAxis;
			++i;
		}
		
		//numberLabels.showLabels(toScreenCoordsX(firstBigStepX * gridStep), height * viewport.bottom / viewport.height, toScreenCoordsY(firstBigStepY * gridStep), width * -viewport.left / viewport.width, pixPerStep, 
		numberLabels.showLabels(xMarks, yMarks,
								xMarksNum, yMarksNum,
								firstBigStepX, firstBigStepY,
								0 <= xAxisPos || xAxisPos <= height ? xAxisPos : -1, 0 <= yAxisPos || yAxisPos <= width ? yAxisPos : -1,
								stepBase, stepPow); 
	}
	
	private function processInput()
	{
		if (funcs != null && FlxG.mouse.pressedRight && !FlxG.mouse.pressed)
		{
			var pnt:FlxPoint = funcs.func(FlxG.mouse.x * viewport.width / width + viewport.left,
										  FlxG.mouse.y * viewport.height / height + viewport.top);
			drawCircle(toScreenCoordsX(pnt.x), toScreenCoordsY(pnt.y), 3.0, FlxColor.RED);
		}
		
		if (FlxG.mouse.justPressed)
		{
			mouseJustX = FlxG.mouse.x;
			mouseJustY = FlxG.mouse.y;
		}
		
		if (FlxG.mouse.pressed)
		{
			var mouseShiftX = gridStep * (FlxG.mouse.x - mouseJustX) / pixPerStep;
			var mouseShiftY = gridStep * (FlxG.mouse.y - mouseJustY) / pixPerStep;
			viewport.x -= mouseShiftX;
			viewport.y += mouseShiftY;
			mouseJustX = FlxG.mouse.x;
			mouseJustY = FlxG.mouse.y;
		}

		wheelDist -= FlxG.mouse.wheel;

		if (FlxG.mouse.wheel != 0)
		{
			var switches = Math.floor(wheelDist / hopsPerSwitch);
			var mode = mod(switches, 3);
			stepPow = Math.floor(switches / 3);
			stepBase = mode * mode + 1;
			var step = stepBase * Math.pow(10, stepPow);
			var delta = (2 * mode + 1) * Math.pow(10, stepPow) * initWidth * (1/hopsPerSwitch);
			
			var hopsInSection = mod(wheelDist, hopsPerSwitch);
			
			//FlxG.watch.addQuick("wheelDist", wheelDist);
			//FlxG.watch.addQuick("switches", switches);
			//FlxG.watch.addQuick("mode", mode);
			//FlxG.watch.addQuick("power", stepPow);
			//FlxG.watch.addQuick("stepBase", stepBase);
			//FlxG.watch.addQuick("step", step);
			//FlxG.watch.addQuick("hopsInSection", hopsInSection);
			//FlxG.watch.addQuick("delta", delta);
			
			var newWidth = step * initWidth + hopsInSection * delta;
			var newHeight = newWidth * screenRatio;
			viewport.x = viewport.x - (FlxG.mouse.x / width) * (newWidth - viewport.width);
			viewport.y = viewport.y - (1 - FlxG.mouse.y / height) * (newHeight - viewport.height);
			viewport.width = newWidth;
			viewport.height = newHeight;
			
			pixPerStep = Std.int(width * step / viewport.width);
			gridStep = step;
			FlxG.watch.addQuick("pixPerStep", pixPerStep);
		}
	}
	
	private inline function mod(p:Int, q:Int):Int
	{
		var r:Int = p % q;
		return r >= 0 ? r : r + q;
	}
	
	private function toScreenCoordsX(num:Float) : Float
	{
		return width * (num - viewport.left) / viewport.width;
	}
	
	private function toScreenCoordsY(num:Float) : Float
	{
		return height * (num - viewport.top) / viewport.height;
	}
	
	//public function new(?x:Float = 0, ?y:Float = 0, ?numberLabels:NumberLabels = null)
	public function new(w:Int=0, h:Int=0, ?numberLabels:NumberLabels = null, ?funcs:Dynamic = null)
	{
		super(x, y);
		
		makeGraphic(w, h, FlxColor.TRANSPARENT);
		this.screenRatio = h / w;
		this.numberLabels = numberLabels;
		this.funcs = funcs;
		
		initViewport();
		
		var maxLabelsX:Int = Math.floor(w / 30);
		var maxLabelsY:Int = Math.floor(h / 30);
		
		xMarks = new Array<Float>();
		yMarks = new Array<Float>();
		
		numberLabels.create(maxLabelsX, maxLabelsY);
		
		//FlxG.watch.add(viewport, "width");
		//FlxG.watch.add(viewport, "height");
		//FlxG.watch.add(this, "wheelDist", "wheelDist");
		//FlxG.watch.add(this, "gridStep", "gridStep");
		//FlxG.watch.add(this, "pixPerStep", "pixPerStep");
	}
}