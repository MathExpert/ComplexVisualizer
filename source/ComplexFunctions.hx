package;

import flixel.math.FlxPoint;

class ComplexFunctions
{
	public function func(a:Float, b:Float):FlxPoint
	{
		// Calculates sin(a + ib)
		var expB = Math.exp(b);
		var expNegB = 1 / expB;
		return FlxPoint.weak(0.5 * Math.sin(a) * (expNegB + expB), -0.5 * Math.cos(a) * (expNegB - expB));
	}
	
	public function new() 
	{
	}
}