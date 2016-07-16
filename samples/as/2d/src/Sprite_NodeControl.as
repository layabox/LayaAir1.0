package 
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.webgl.WebGL;

	public class Sprite_NodeControl 
	{
		private var ape1:Sprite;
		private var ape2:Sprite;
		
		public function Sprite_NodeControl() 
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			createApes();
		}

		private function createApes():void
		{
			//显示两只猩猩
			ape1 = new Sprite();
			ape2 = new Sprite();
			ape1.loadImage("../../../../res/apes/monkey2.png");
			ape2.loadImage("../../../../res/apes/monkey2.png");
			
			ape1.pivot(55, 72);
			ape2.pivot(55, 72);
			
			ape1.pos(Laya.stage.width / 2, Laya.stage.height / 2);
			ape2.pos(200, 0);
			
			//一只猩猩在舞台上，另一只被添加成第一只猩猩的子级
			Laya.stage.addChild(ape1);
			ape1.addChild(ape2);
			
			Laya.timer.frameLoop(1, this, animate);
		}
		
		private function animate(e:Event=null):void 
		{
			ape1.rotation += 2;
			ape2.rotation -= 4;
		}
		
	}
	
}