package 
{
	import laya.display.Stage;
	import laya.display.Text;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	
	public class Text_Scroll 
	{
		private var txt:Text;
		private var prevX:Number = 0;
		private var prevY:Number = 0;
		
		public function Text_Scroll() 
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
			Stat.show();

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";

			createText();
		}

		private function createText():void
		{
			txt = new Text();
			txt.overflow = Text.SCROLL;
			txt.text = 
				"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
				"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
				"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
				"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
				"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
				"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！";
			
			txt.size(200, 100);
			txt.x = Laya.stage.width - txt.width >> 1;
			txt.y = Laya.stage.height - txt.height >> 1;
			
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