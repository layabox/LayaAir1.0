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
			path.push(0, -130);
			path.push(33, -33 );
			path.push(137, -30);
			path.push(55, 32);
			path.push(85, 130);
			path.push(0, 73);
			path.push(-85, 130);
			path.push(-55, 32);
			path.push(-137, -30);
			path.push(-33, -33 );
			
			canvas.graphics.drawPoly(275, 200, path, "#00ffff");
		}
	}
}