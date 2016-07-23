package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.inputDevice.Gyroscope;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	/**
	 * ...
	 * @author Survivor
	 */
	public class InputDevice_Gyroscope
	{
		private var compassImgPath:String = "../../../../res/inputDevice/kd.png";
		private var compassImg:Sprite;
		private var degreesText:Text;
		private var directionIndicator:Sprite;
		private var firstTime:Boolean = true;
		
		public function InputDevice_Gyroscope()
		{
			Laya.init(700, 1024);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.alignH = Stage.ALIGN_CENTER;
			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			
			Laya.loader.load(compassImgPath, Handler.create(this, init));
			
			Gyroscope.listen(new Handler(this, onOrientChange));
		}
		
		private function init():void
		{
			createCompass();
			createDirectionIndicator();
			drawUI();
			createDegreesText();
		}
		
		private function createCompass():void
		{
			compassImg = new Sprite();
			Laya.stage.addChild(compassImg);
			compassImg.loadImage(compassImgPath);
			
			compassImg.pivot(compassImg.width / 2, compassImg.height / 2);
			compassImg.pos(Laya.stage.width / 2, 400);
		}
		
		private function drawUI():void
		{
			var canvas:Sprite = new Sprite();
			Laya.stage.addChild(canvas);
			
			canvas.graphics.drawLine(compassImg.x, 50, compassImg.x, 182, "#FFFFFF", 3);
			
			canvas.graphics.drawLine(-140 + compassImg.x, compassImg.y, 140 + compassImg.x, compassImg.y, "#AAAAAA", 1);
			canvas.graphics.drawLine(compassImg.x, -140 + compassImg.y, compassImg.x, 140 + compassImg.y, "#AAAAAA", 1);
		}
		
		private function createDegreesText():void
		{
			degreesText = new Text();
			Laya.stage.addChild(degreesText);
			degreesText.align = "center";
			degreesText.size(Laya.stage.width, 100);
			degreesText.pos(0, compassImg.y + 400);
			degreesText.fontSize = 100;
			degreesText.color = "#FFFFFF";
		}
		
		private function createDirectionIndicator():void
		{
			directionIndicator = new Sprite();
			directionIndicator.alpha = 0.5;
			Laya.stage.addChild(directionIndicator);
			
			directionIndicator.graphics.drawCircle(0, 0, 70, "#343434");
			directionIndicator.graphics.drawLine(-40, 0, 40, 0, "#FFFFFF", 3);
			directionIndicator.graphics.drawLine(0, -40, 0, 40, "#FFFFFF", 3);
			
			directionIndicator.x = compassImg.x;
			directionIndicator.y = compassImg.y;
		}
		
		private function onOrientChange(absolute, alpha, beta, gamma):void
		{
			if (firstTime && !absolute)
			{
				firstTime = false;
				alert("在当前设备中无法获取地球坐标系，使用设备坐标系，你可以继续观赏，但是提供的方位并非正确方位。");
			}
			
			degreesText.text = 360 - Math.floor(alpha) + "°";
			compassImg.rotation = alpha;
			
			directionIndicator.x = -1 * Math.floor(gamma) / 90 * 70 + compassImg.x;
			directionIndicator.y = -1 * Math.floor(beta) / 90 * 70 + compassImg.y;
		}
	}
}