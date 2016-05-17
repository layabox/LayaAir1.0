package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.events.Event;
	
	public class Interaction_Keyboard
	{
		private var txt:Text;
		private var keyDownList:Array;
		
		public function Interaction_Keyboard()
		{
			Laya.init(550, 400);
			Laya.stage.bgColor = "#ffeecc";
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			keyDownList = [];
			
			//添加键盘按下事件,一直按着某按键则会不断触发
			Laya.stage.on(Event.KEY_DOWN, this, onKeyDown);
			//添加键盘抬起事件
			Laya.stage.on(Event.KEY_UP, this, onKeyUp);
			
			Laya.timer.frameLoop(1, this, keyboardInspector);
			
			//添加提示文本
			createTxt();
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
			
			txt.text = "按下了下列键\n";
			for (var i:int = 0; i < numKeyDown; i++)
			{
				if (keyDownList[i])
				{
					txt.text += i + " ";
				}
			}
		}
		
		/**添加提示文本*/
		private function createTxt():void
		{
			txt = new Text();
			
			txt.size(550, 300);
			txt.fontSize = 20;
			txt.font = "SimHei";
			txt.wordWrap = true;
			txt.color = "#000000";
			txt.align = 'center';
			txt.pos(0, 150);
			
			Laya.stage.addChild(txt);
		}
	}
}