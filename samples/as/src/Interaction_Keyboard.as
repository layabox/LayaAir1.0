package
{
	import laya.display.Stage;
	import laya.display.Text;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	
	public class Interaction_Keyboard
	{
		private var logger:Text;
		private var keyDownList:Array;
		
		public function Interaction_Keyboard()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			
			setup();
		}

		private function setup():void
		{
			listenKeyboard();
			createLogger();

			Laya.timer.frameLoop(1, this, keyboardInspector);
		}

		private function listenKeyboard():void
		{
			keyDownList = [];
			
			//添加键盘按下事件,一直按着某按键则会不断触发
			Laya.stage.on(Event.KEY_DOWN, this, onKeyDown);
			//添加键盘抬起事件
			Laya.stage.on(Event.KEY_UP, this, onKeyUp);
		}
		
		/**键盘按下处理*/
		private function onKeyDown(e:Event):void
		{
			keyDownList[e["keyCode"]] = true;
		}
		
		/**键盘抬起处理*/
		private function onKeyUp(e:Event):void
		{
			delete keyDownList[e["keyCode"]];
		}
		
		private function keyboardInspector():void
		{
			var numKeyDown:int = keyDownList.length;
			
			var newText:String = '[ ';
			for (var i:int = 0; i < numKeyDown; i++)
			{
				if (keyDownList[i])
				{
					newText += i + " ";
				}
			}
			newText += ']';

			logger.changeText(newText);
		}
		
		/**添加提示文本*/
		private function createLogger():void
		{
			logger = new Text();
			
			logger.size(Laya.stage.width, Laya.stage.height);
			logger.fontSize = 30;
			logger.font = "SimHei";
			logger.wordWrap = true;
			logger.color = "#FFFFFF";
			logger.align = 'center';
			logger.valign = 'middle';
			
			Laya.stage.addChild(logger);
		}
	}
}