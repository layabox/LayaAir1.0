package 
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.webgl.WebGL;

	public class Sprite_RoateAndScale 
	{
		private var ape:Sprite;
		private var scaleDelta:Number = 0;
		
		public function Sprite_RoateAndScale() 
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			createApe();			
		}

		private function createApe():void
		{
			ape = new Sprite();
			
			ape.loadImage("../../../../res/apes/monkey2.png");
			Laya.stage.addChild(ape);
			ape.pivot(55, 72);
			ape.x = Laya.stage.width / 2;
			ape.y = Laya.stage.height / 2;
			
			Laya.timer.frameLoop(1, this, animate);
		}
		
		private function animate(e:Event=null):void
		{
			ape.rotation += 2;
			
			//心跳缩放
			scaleDelta += 0.02;
			var scaleValue:Number = Math.sin(scaleDelta);
			ape.scale(scaleValue, scaleValue);
		}
	}
}