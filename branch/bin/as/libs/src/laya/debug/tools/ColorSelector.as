package laya.debug.tools 
{
	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Rectangle;
	import laya.utils.Browser;
	
	import laya.debug.tools.ColorTool;
	
	/**
	 * 颜色选取类
	 * @author ww
	 */
	public class ColorSelector extends Sprite 
	{
		
		public function ColorSelector() 
		{
			container = this;
			createUI();
		}
		
		public static const COLOR_CHANGED:String = "ColorChanged";
		public static const COLOR_CLEARED:String="COLOR_CLEARED";
		
		private var sideColor:Sprite;
		private var mainColor:Sprite;
		private var demoColor:Sprite;
		private var posSp:Sprite;
		private var hPos:Sprite;
		
		
		
		private var container:Sprite;
		
		public static const RecWidth:int = 150;
		private function createUI():void
		{	
			sideColor = new Sprite();
			container.addChild(sideColor);
			posSp = new Sprite();
			posSp.pos(100, 100);
			posSp.graphics.drawCircle(0, 0, 5, null, "#ff0000");
			posSp.graphics.drawCircle(0, 0, 6, null, "#ffff00");
//			posSp.size(10, 10);
			posSp.autoSize=true;
//			posSp.setBounds(new Rectangle(-7,-7,14,14));
			posSp.cacheAsBitmap = true;
			sideColor.addChild(posSp);
			
			sideColor.pos(0, 0);
			sideColor.size(RecWidth, RecWidth);
			sideColor.on(Event.MOUSE_DOWN, this, sideColorClick);
//			sideColor.on(Event.MOUSE_UP, this, sideColorMouseUp);
			
			var i:int;
		    mainColor = new Sprite();
			var g:Graphics;
			g = mainColor.graphics;
		
			var h:Number;
			var s:Number;
			var b:Number;
			
			var rgb:Array;
			for (i = 0; i < RecWidth; i++)
			{
				rgb = ColorTool.hsb2rgb(i/RecWidth*360, 1, 1);
				g.drawLine(0, i, 20, i, ColorTool.getRGBStr(rgb));
			}

			mainColor.pos(RecWidth+10, 0);
			mainColor.size(20, i);
			mainColor.cacheAsBitmap = true;
			
			hPos = new Sprite();
			hPos.graphics.drawPie(0, 0, 10, -10, 10, "#ff0000");
			hPos.x = mainColor.x+22;
			container.addChild(hPos);
			container.addChild(mainColor);
			mainColor.on(Event.MOUSE_DOWN, this, mainColorClick);
			
			demoColor = new Sprite();
			demoColor.pos(sideColor.x, sideColor.y + sideColor.height + 10);
			demoColor.size(RecWidth, 20);
			container.addChild(demoColor);
			

			//setColor(9, 95, 99);
			setColorByRGBStr("#099599");
			posSp.on(Event.DRAG_MOVE,this,posDraging);
//			posSp.on(Event.DRAG_END,this,posDragEnd);
//			posSp.on(Event.MOUSE_DOWN,this,posMouseDown);
		}
		private function posMouseDown(e:Event):void
		{
			
			
		}
		public var isChanging:Boolean=false;
		private function posDraging():void
		{
			updatePosSpAndShowColor();
		}
		private function posDragEnd():void
		{
			isChanging=false;
			updatePosSpAndShowColor();
		}
		public function setColorByRGBStr(rgbStr:String):void
		{
			var rgb:Array;
			rgb = ColorTool.getRGBByRGBStr(rgbStr);
			setColor(rgb[0],rgb[1],rgb[2]);
		}
		public function setColor(red:Number, green:Number, blue:Number,notice:Boolean=true):void
		{
			var hsb:Array;
			hsb = ColorTool.rgb2hsb(red, green, blue);
			var tRGB:Array;
			tRGB = ColorTool.hsb2rgb( hsb[0], hsb[1], hsb[2]);
			setColorByHSB(hsb[0],hsb[1],hsb[2],notice);
		}
		public function setColorByHSB(h:Number, s:Number, b:Number,notice:Boolean=true):void
		{
			hPos.y = mainColor.y + h/360*RecWidth;
			
			posSp.x = s * RecWidth;
			posSp.y = (1 - b) * RecWidth;
			updateSideColor(h,notice);
		}
		private function sideColorClick(e:Event):void
		{
			
			isChanging=true;
			posSp.startDrag();
			updatePosSpAndShowColor();
			Laya.stage.off(Event.MOUSE_UP, this, sideColorMouseUp);
			Laya.stage.once(Event.MOUSE_UP, this, sideColorMouseUp);
		}
		private function sideColorMouseUp(e:Event):void
		{
			isChanging=false;
			updatePosSpAndShowColor();
		}
		private function updatePosSpAndShowColor():void
		{
			posSp.x = sideColor.mouseX;
			posSp.y = sideColor.mouseY;
			if(posSp.x<0) posSp.x=0;
			if(posSp.y<0) posSp.y=0;
			if(posSp.x>RecWidth) posSp.x=RecWidth;
			if(posSp.y>RecWidth) posSp.y=RecWidth;
			updateDemoColor();
		}
		public var tColor:Array;
		public var tH:Number;
		private function updateDemoColor(notice:Boolean=true):void
		{
			var h:Number;
			var s:Number;
			var b:Number;
			h = tH;
			s = posSp.x / RecWidth;
			b = 1 - posSp.y / RecWidth;
			tColor = ColorTool.hsb2rgb(h, s, b);
			var g:Graphics;
			g = demoColor.graphics;
			g.clear();
			g.drawRect(0, 0, demoColor.width, demoColor.height, ColorTool.getRGBStr(tColor));
			
			if(isChanging) return;
			if(notice)
			event(COLOR_CHANGED,this);
		}
		private function mainColorClick(e:Event):void
		{
			var yPos:Number;
			yPos = mainColor.mouseY;
			hPos.y = yPos+mainColor.y;
			var h:Number;
			h = yPos / RecWidth * 360;
			updateSideColor(h);
		}
		
		private function updateSideColor(h:Number,notice:Boolean=true):void
		{
			tH = h;
			var s:Number;
			var b:Number;
			var g:Graphics;
			g = sideColor.graphics;
			g.clear();
			sideColor.cacheAsBitmap = false;
			var rgb:Array;
			//for (b = 0; b <=RecWidth; b++)
			//{
				//for (s = 0; s <=RecWidth; s++)
				//{
					//rgb = ColorTool.hsb2rgb(h, s/RecWidth, 1-b/RecWidth);
				   //g.drawCircle(s, b, 1 ,ColorTool.getRGBStr(rgb));
				//}
			//}
			rgb=ColorTool.hsb2rgb(h, 1, 1);
			var gradient:*=Browser.context.createLinearGradient(0,0,80,0);
			gradient.addColorStop(0,"white");
			gradient.addColorStop(1,ColorTool.getRGBStr(rgb));			
			sideColor.graphics.drawRect(0, 0, 150, 150, gradient);
			sideColor.graphics.loadImage("comp/colorpicker_overlay.png", 0, 0);
			
			sideColor.size(RecWidth, RecWidth);
			sideColor.cacheAsBitmap = true;
			updateDemoColor(notice);
		}
	}

}