package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.webgl.WebGL;

	public class Sprite_DrawShapes
	{
		private var sp:Sprite;

		public function Sprite_DrawShapes()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(740, 400, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			drawSomething();
		}

		private function drawSomething():void
		{
			sp = new Sprite();
			Laya.stage.addChild(sp);
			//画线
			sp.graphics.drawLine(10, 58, 146, 58, "#ff0000", 3);
			//画连续直线
			sp.graphics.drawLines(176, 58, [0, 0, 39, -50, 78, 0, 117, 50, 156, 0], "#ff0000", 5);
			//画曲线
			sp.graphics.drawCurves(352, 58, [0, 0, 19, -100, 39, 0, 58, 100, 78, 0, 97, -100, 117, 0, 136, 100, 156, 0], "#ff0000", 5);
			//画矩形
			sp.graphics.drawRect(10, 166, 166, 90, "#ffff00");
			//画多边形
			sp.graphics.drawPoly(264, 166, [0, 0, 60, 0, 78.48, 57, 30, 93.48, -18.48, 57], "#ffff00");
			//画三角形
			sp.graphics.drawPoly(400, 166, [0, 100, 50, 0, 100, 100], "#ffff00");
			//画圆
			sp.graphics.drawCircle(98, 332, 50, "#00ffff");
			//画扇形
			sp.graphics.drawPie(240, 290, 100, 10, 60, "#00ffff");
			//绘制圆角矩形，自定义路径
			sp.graphics.drawPath(400, 310, [["moveTo", 5, 0], ["lineTo", 105, 0], ["arcTo", 110, 0, 110, 5, 5], ["lineTo", 110, 55], ["arcTo", 110, 60, 105, 60, 5], ["lineTo", 5, 60], ["arcTo", 0, 60, 0, 55, 5], ["lineTo", 0, 5], ["arcTo", 0, 0, 5, 0, 5], ["closePath"]], {fillStyle: "#00ffff"});
		}
	}
}
