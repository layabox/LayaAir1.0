package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.utils.Browser;
	import laya.webgl.WebGL;

	public class Sprite_DrawPath
	{
		public function Sprite_DrawPath() 
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";
			
			drawPentagram();
		}

		private function drawPentagram():void
		{
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
			
			canvas.graphics.drawPoly(Laya.stage.width / 2, Laya.stage.height / 2, path, "#FF7F50");
		}
	}
}