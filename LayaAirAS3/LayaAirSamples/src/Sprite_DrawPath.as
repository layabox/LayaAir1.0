package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	public class Sprite_DrawPath
	{
		public function Sprite_DrawPath() 
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			var canvas:Sprite = new Sprite();
			Laya.stage.addChild(canvas);
			
			var path:Array = [];
			path.push(["moveTo", 0, -130]);
			path.push(["lineTo", 33, -33 ]);
			path.push(["lineTo", 137, -30]);
			path.push(["lineTo", 55, 32]);
			path.push(["lineTo", 85, 130]);
			path.push(["lineTo", 0, 73]);
			path.push(["lineTo", -85, 130]);
			path.push(["lineTo", -55, 32]);
			path.push(["lineTo", -137, -30]);
			path.push(["lineTo", -33, -33 ]);
			path.push(["lineTo", 0, -130]);
			path.push(["closePath"]);
			
			canvas.graphics.drawPath(275, 200, path, {fillStyle: "#00ffff"});
		}
	}
}