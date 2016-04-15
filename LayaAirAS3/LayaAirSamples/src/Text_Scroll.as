package 
{
	import laya.display.Stage;
	import laya.display.Text;
	import laya.events.Event;
	
	public class Scroll 
	{
		private var txt:Text;
		private var prevX:Number = 0;
		private var prevY:Number = 0;
		
		public function Scroll() 
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			txt = new Text();
			
			txt.text = 
				"Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
				"Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
				"Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
				"Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
				"Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
				"Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！";
			
			txt.pos(175, 150);
			txt.size(200, 100);
			
			txt.borderColor = "#FFFF00";
			
			txt.fontSize = 20;
			txt.color = "#ffffff";
			
			Laya.stage.addChild(txt);
			
			txt.on(Event.MOUSE_DOWN, this, startScrollText);
		}
		
		/* 开始滚动文本 */
		private function startScrollText(e:Event):void
		{
			prevX = txt.mouseX;
			prevY = txt.mouseY;
			
			Laya.stage.on(Event.MOUSE_MOVE, this, scrollText);
			Laya.stage.on(Event.MOUSE_UP, this, finishScrollText);
		}
		
		/* 停止滚动文本 */
		private function finishScrollText(e:Event):void
		{
			Laya.stage.off(Event.MOUSE_MOVE, this, scrollText);
			Laya.stage.off(Event.MOUSE_UP, this, finishScrollText);
		}
		
		/* 鼠标滚动文本 */
		private function scrollText(e:Event):void
		{
			var nowX:Number = txt.mouseX;
			var nowY:Number = txt.mouseY;
			
			txt.scrollX += prevX - nowX;
			txt.scrollY += prevY - nowY;
			
			prevX = nowX;
			prevY = nowY;
		}
	}
}