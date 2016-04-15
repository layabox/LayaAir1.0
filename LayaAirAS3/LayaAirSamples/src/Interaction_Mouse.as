package 
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.utils.Handler;
	import laya.events.Event;
	
	public class Interaction_Mouse 
	{
		private var txt:Text;
		
		public function Interaction_Mouse() 
		{
			Laya.init(550, 400);
			Laya.stage.bgColor = "#ffeecc";
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			var rect:Sprite = new Sprite();
			rect.graphics.drawRect( 0, 0, 100, 100, "#00eeff");
			rect.pos(250, 170);
			rect.size(100,100);
			Laya.stage.addChild(rect);
			
			//增加鼠标事件
			rect.on(Event.MOUSE_DOWN, this, mouseHandler);
			rect.on(Event.MOUSE_UP, this, mouseHandler);
			rect.on(Event.CLICK, this, mouseHandler);
			rect.on(Event.RIGHT_MOUSE_DOWN, this, mouseHandler);
			rect.on(Event.RIGHT_MOUSE_UP, this, mouseHandler);
			rect.on(Event.RIGHT_CLICK, this, mouseHandler);
			rect.on(Event.MOUSE_MOVE, this, mouseHandler);
			rect.on(Event.MOUSE_OVER, this, mouseHandler);
			rect.on(Event.MOUSE_OUT, this, mouseHandler);
			rect.on(Event.DOUBLE_CLICK, this, mouseHandler);
			rect.on(Event.MOUSE_WHEEL, this, mouseHandler);
			
			//添加提示文本
			createTxt();
		}
		
		/**
		 * 鼠标响应事件处理
		 */	
		private function mouseHandler(e:Event):void
		{
			switch(e.type)
			{
				case Event.MOUSE_DOWN:
					appendText("\n————————\n左键按下");
					break;
				case Event.MOUSE_UP:
					appendText("\n左键抬起");
					break;
				case Event.CLICK:
					appendText("\n左键点击\n————————");
					break;
				case Event.RIGHT_MOUSE_DOWN:
					appendText("\n————————\n右键按下");
					break;
				case Event.RIGHT_MOUSE_UP:
					appendText("\n右键抬起");
					break;
				case Event.RIGHT_CLICK:
					appendText("\n右键单击\n————————");
					break;
				case Event.MOUSE_MOVE:
					// 如果上一个操作是移动，提示信息仅加入.字符
					if (/鼠标移动\.*$/.test(txt.text))
						appendText(".");
					else
						appendText("\n鼠标移动");
					break;
				case Event.MOUSE_OVER:
					appendText("\n鼠标经过目标");
					break;
				case Event.MOUSE_OUT:
					appendText("\n鼠标移出目标");
					break;
				case Event.DOUBLE_CLICK:
					appendText("\n鼠标左键双击\n————————");
					break;
				case Event.MOUSE_WHEEL:
					appendText("\n鼠标滚轮滚动");
					break;
			}
		}
		
		private function appendText(value:String):void
		{
			txt.text += value;
			txt.scrollY = txt.maxScrollY;
		}
		
		/**添加提示文本*/
		private function createTxt():void
		{
			txt = new Text();
			
			txt.text = "请把鼠标移到到矩形方块,左右键操作触发相应事件\n";
			txt.size(550, 300);
			txt.pos(10, 50);
			txt.fontSize = 20;
			txt.wordWrap = true;
			txt.color = "#000000";
			
			Laya.stage.addChild(txt);
		}
	}

}