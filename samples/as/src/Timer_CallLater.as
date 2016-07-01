package
{
	import laya.display.Stage;
	import laya.display.Text;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	
	public class Timer_CallLater
	{
		public function Timer_CallLater()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";
			
			demonstrate();
		}

		private function demonstrate():void
		{
			for (var i:int = 0; i < 10; i++)
			{
				Laya.timer.callLater(this, onCallLater);
			}
		}
		
		private function onCallLater(e:*=null):void
		{
			trace("onCallLater triggered");
			
			var text:Text = new Text();
			text.font = "SimHei";
			text.fontSize = 30;
			text.color = "#FFFFFF";
			text.text = "打开控制台可见该函数仅触发了一次";
			text.size(Laya.stage.width, Laya.stage.height);
			text.wordWrap = true;
			text.valign = "middle";
			text.align = "center";
			Laya.stage.addChild(text);
		}
	}
}