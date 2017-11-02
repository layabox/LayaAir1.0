package laya.html.utils {
	import laya.display.ILayout;
	import laya.display.Sprite;
	import laya.display.css.CSSStyle;
	import laya.display.Text;
	import laya.html.dom.HTMLBrElement;
	import laya.html.dom.HTMLElement;
	import laya.renders.Render;
	import laya.utils.HTMLChar;
	
	/**
	 * @private
	 * HTML的布局类
	 * 对HTML的显示对象进行排版
	 */
	public class Layout {
		
		private static var _will:Vector.<Sprite>;
		private static var DIV_ELEMENT_PADDING:int = 0;
		
		public static function later(element:Sprite):void {
			if (_will == null) {
				_will = new Vector.<Sprite>();
				Laya.stage.frameLoop(1, null, function():void {
					if (_will.length < 1)
						return;
					for (var i:int = 0; i < _will.length; i++) {
						Layout.layout(_will[i]);
					}
					_will.length = 0;
				});
			}
			_will.push(element);
		}
		
		public static function layout(element:Sprite):Array {
			if (!element || !element._style) return null;
			if ((element._style._type & CSSStyle.ADDLAYOUTED) === 0)
				return null;
			
			element.getStyle()._type &= ~CSSStyle.ADDLAYOUTED;
			/*
			   if (element._childs.length > 0)
			   return _multiLineLayout(element);
			   if (element is HTMLElement)
			   {
			   var htmlElement:HTMLElement = element as HTMLElement;
			   var style:CSSStyle = htmlElement.style;
			   var txt:String = htmlElement.text;
			   if (txt.length < 1)
			   return [0, 0];
			   if (!style.wordWrap)
			   return _singleLineTextLayout(htmlElement, -1, -1);
			   if (style.letterSpacing || txt.indexOf('\n') >= 0)
			   return _multiLineLayout(htmlElement);
			   var sz:Object = Utils.measureText(txt, style.font);
			   if (sz.width > element.width)
			   return _multiLineLayout(htmlElement);
			   return _singleLineTextLayout(htmlElement, sz.width, sz.height);
			   }*/
			var arr:Array = _multiLineLayout(element);
			if (Render.isConchApp&&element["layaoutCallNative"])
			{
				(element as HTMLElement).layaoutCallNative();
			}
			return arr;
		}
		
		/*
		   //针对单行文字，还可以优化
		   public static function _singleLineTextLayout(element:HTMLElement, txtWidth:int, txtHeight:int):Array
		   {
		   var style:CSSStyle = element._getCSSStyle();
		
		   if (txtWidth < 0)
		   {
		   var txt:String = element.text;
		   var sz:Object = Utils.measureText(txt, style.font);
		   txtWidth = sz.width;
		   txtHeight = sz.height;
		   }
		
		   if (style.italic)
		   txtWidth += txtHeight / 3;
		
		   var elements:Vector.<HTMLChar> = element._getWords() as Vector.<HTMLChar>;
		   var x:int = 0;
		   var y:int = 0;
		
		   var letterSpacing:Number = style.letterSpacing;
		   var align:int = style._getAlign();
		   var lineHeight:Number = style.lineHeight;
		   var valign:int = style._getValign();
		
		   (lineHeight > 0) && valign === 0 && (valign = CSSStyle.VALIGN_MIDDLE);
		
		   (align === CSSStyle.ALIGN_CENTER) && (x = (element.width - txtWidth) / 2);
		   (align === CSSStyle.ALIGN_RIGHT) && (x = (element.width - txtWidth));
		
		   (valign === CSSStyle.VALIGN_MIDDLE) && (y = (element.height - txtHeight) / 2);
		   (valign === CSSStyle.VALIGN_BOTTOM) && (y = (element.height - txtHeight));
		
		   for (var i:int = 0, n:int = elements.length; i < n; i++)
		   {
		   var one:ILayout = elements[i];
		   one.x = x;
		   one.y = y;
		   x += one.width + letterSpacing;
		   }
		   return [txtWidth, txtHeight];
		   }
		 */
		
		public static function _multiLineLayout(element:Sprite):Array {
			if (Text.RightToLeft) return _multiLineLayout2(element);
			var elements:Vector.<ILayout> = new Vector.<ILayout>;
			element._addChildsToLayout(elements);
			var i:int, n:int = elements.length, j:int;
			var style:CSSStyle = element._getCSSStyle();
			var letterSpacing:Number = style.letterSpacing;
			var leading:Number = style.leading;
			var lineHeight:Number = style.lineHeight;
			var widthAuto:Boolean = style._widthAuto() || !style.wordWrap;
			var width:Number = widthAuto ? 999999 : element.width;
			var height:Number = element.height;
			var maxWidth:Number = 0;
			var exWidth:Number = style.italic ? style.fontSize / 3 : 0;
			var align:int = style._getAlign();
			var valign:int = style._getValign();
			var endAdjust:Boolean = valign !== 0 || align !== 0 || lineHeight != 0;
			
			var oneLayout:ILayout;
			var x:Number = 0;
			var y:Number = 0;
			var w:Number = 0;
			var h:Number = 0;
			var tBottom:Number = 0;
			var lines:Vector.<LayoutLine> = new Vector.<LayoutLine>;
			var curStyle:CSSStyle;
			var curPadding:Array;
			var curLine:LayoutLine = lines[0] = new LayoutLine();
			var newLine:Boolean, nextNewline:Boolean = false;
			var htmlWord:HTMLChar;
			var sprite:Sprite;
			
			curLine.h = 0;
			if (style.italic)
				width -= style.fontSize / 3;
			
			var tWordWidth:Number = 0;
			var tLineFirstKey:Boolean = true;
			function addLine():void {
				curLine.y = y;
				y += curLine.h + leading;
				if (curLine.h == 0) y += lineHeight;
				curLine.mWidth = tWordWidth;
				tWordWidth = 0;
				curLine = new LayoutLine();
				lines.push(curLine);
				curLine.h = 0;
				x = 0;
				tLineFirstKey = true;
				newLine = false;
			}
			//生成排版的行
			for (i = 0; i < n; i++) {
				oneLayout = elements[i];
				if (oneLayout == null) {
					if (!tLineFirstKey) {
						x += DIV_ELEMENT_PADDING;
					}
					curLine.wordStartIndex = curLine.elements.length;
					continue;
				}
				tLineFirstKey = false;
				if (oneLayout is HTMLBrElement) {
					addLine();
					curLine.y = y;
					//curLine.h = lineHeight;
					continue;
				} else if (oneLayout._isChar()) {
					htmlWord = oneLayout as HTMLChar;
					if (!htmlWord.isWord) //如果是完整单词
					{
						if (lines.length > 0 && (x + w) > width && curLine.wordStartIndex > 0) //如果完整单词超界，需要单词开始折到下一行
						{
							var tLineWord:int = 0;
							tLineWord = curLine.elements.length - curLine.wordStartIndex + 1;
							curLine.elements.length = curLine.wordStartIndex;
							i -= tLineWord;
							addLine();
							continue;
						}
						newLine = false;
						tWordWidth += htmlWord.width;
					} else {
						newLine = nextNewline || (htmlWord.char === '\n');
						curLine.wordStartIndex = curLine.elements.length;
					}
					
					w = htmlWord.width + letterSpacing;
					h = htmlWord.height;
					nextNewline = false;
					
					newLine = newLine || ((x + w) > width);
					newLine && addLine();
					curLine.minTextHeight = Math.min(curLine.minTextHeight, oneLayout.height);
				} else {
					curStyle = oneLayout._getCSSStyle();
					sprite = oneLayout as Sprite;
					curPadding = curStyle.padding;
					curStyle._getCssFloat() === 0 || (endAdjust = true);
					newLine = nextNewline || curStyle.lineElement;
					w = sprite.width * sprite._style._tf.scaleX + curPadding[1] + curPadding[3] + letterSpacing;
					h = sprite.height * sprite._style._tf.scaleY + curPadding[0] + curPadding[2];
					nextNewline = curStyle.lineElement;
					newLine = newLine || ((x + w) > width && curStyle.wordWrap);
					newLine && addLine();
				}
				
				curLine.elements.push(oneLayout);
				curLine.h = Math.max(curLine.h, h);//计算最大宽和高
				oneLayout.x = x;
				oneLayout.y = y;
				x += w;
				curLine.w = x - letterSpacing;
				curLine.y = y;
				maxWidth = Math.max(x + exWidth, maxWidth);
			}
			y = curLine.y + curLine.h;
			
			//如果行信息需要调整，包括有浮动，有居中等
			if (endAdjust) {
				//var dy:Number = 0;
				//valign === CSSStyle.VALIGN_MIDDLE && (dy = (height - y) / 2);
				//valign === CSSStyle.VALIGN_BOTTOM && (dy = (height - y));
				var tY:Number = 0;
				var tWidth:Number = width;
				if (widthAuto && element.width > 0)
				{
					//如果使用单行，这里一定要根据单行的实际宽（element.width）来排版
					tWidth = element.width;
				}
				for (i = 0, n = lines.length; i < n; i++) {
					lines[i].updatePos(0, tWidth, i, tY, align, valign, lineHeight);
					tY += Math.max(lineHeight, lines[i].h+leading);
				}
				y = tY;
			}
			widthAuto && (element.width = maxWidth);
			(y > element.height) && (element.height = y);
			
			return [maxWidth, y];
		}
	
		/**
		 * rtl模式的排版函数 
		 */		
		public static function _multiLineLayout2(element:Sprite):Array {
			var elements:Vector.<ILayout> = new Vector.<ILayout>;
			element._addChildsToLayout(elements);
			var i:int, n:int = elements.length, j:int;
			var style:CSSStyle = element._getCSSStyle();
			var letterSpacing:Number = style.letterSpacing;
			var leading:Number = style.leading;
			var lineHeight:Number = style.lineHeight;
			var widthAuto:Boolean = style._widthAuto() || !style.wordWrap;
			var width:Number = widthAuto ? 999999 : element.width;
			var height:Number = element.height;
			var maxWidth:Number = 0;
			var exWidth:Number = style.italic ? style.fontSize / 3 : 0;
			var align:int = 2-style._getAlign();//反转水平对齐方式
			var valign:int = style._getValign();
			var endAdjust:Boolean = valign !== 0 || align !== 0 || lineHeight != 0;
			
			var oneLayout:ILayout;
			var x:Number = 0;
			var y:Number = 0;
			var w:Number = 0;
			var h:Number = 0;
			var tBottom:Number = 0;
			var lines:Vector.<LayoutLine> = new Vector.<LayoutLine>;
			var curStyle:CSSStyle;
			var curPadding:Array;
			var curLine:LayoutLine = lines[0] = new LayoutLine();
			var newLine:Boolean, nextNewline:Boolean = false;
			var htmlWord:HTMLChar;
			var sprite:Sprite;
			
			curLine.h = 0;
			if (style.italic)
				width -= style.fontSize / 3;
			
			var tWordWidth:Number = 0;
			var tLineFirstKey:Boolean = true;
			function addLine():void {
				curLine.y = y;
				y += curLine.h + leading;
				if (curLine.h == 0) y += lineHeight;
				curLine.mWidth = tWordWidth;
				tWordWidth = 0;
				curLine = new LayoutLine();
				lines.push(curLine);
				curLine.h = 0;
				x = 0;
				tLineFirstKey = true;
				newLine = false;
			}
			//生成排版的行
			for (i = 0; i < n; i++) {
				oneLayout = elements[i];
				if (oneLayout == null) {
					if (!tLineFirstKey) {
						x += DIV_ELEMENT_PADDING;
					}
					curLine.wordStartIndex = curLine.elements.length;
					continue;
				}
				tLineFirstKey = false;
				if (oneLayout is HTMLBrElement) {
					addLine();
					curLine.y = y;
					//curLine.h = lineHeight;
					continue;
				} else if (oneLayout._isChar()) {
					htmlWord = oneLayout as HTMLChar;
					if (!htmlWord.isWord) //如果是完整单词
					{
						if (lines.length > 0 && (x + w) > width && curLine.wordStartIndex > 0) //如果完整单词超界，需要单词开始折到下一行
						{
							var tLineWord:int = 0;
							tLineWord = curLine.elements.length - curLine.wordStartIndex + 1;
							curLine.elements.length = curLine.wordStartIndex;
							i -= tLineWord;
							addLine();
							continue;
						}
						newLine = false;
						tWordWidth += htmlWord.width;
					} else {
						newLine = nextNewline || (htmlWord.char === '\n');
						curLine.wordStartIndex = curLine.elements.length;
					}
					
					w = htmlWord.width + letterSpacing;
					h = htmlWord.height;
					nextNewline = false;
					
					newLine = newLine || ((x + w) > width);
					newLine && addLine();
					curLine.minTextHeight = Math.min(curLine.minTextHeight, oneLayout.height);
				} else {
					curStyle = oneLayout._getCSSStyle();
					sprite = oneLayout as Sprite;
					curPadding = curStyle.padding;
					curStyle._getCssFloat() === 0 || (endAdjust = true);
					newLine = nextNewline || curStyle.lineElement;
					w = sprite.width * sprite._style._tf.scaleX + curPadding[1] + curPadding[3] + letterSpacing;
					h = sprite.height * sprite._style._tf.scaleY + curPadding[0] + curPadding[2];
					nextNewline = curStyle.lineElement;
					newLine = newLine || ((x + w) > width && curStyle.wordWrap);
					newLine && addLine();
				}
				
				curLine.elements.push(oneLayout);
				curLine.h = Math.max(curLine.h, h);//计算最大宽和高
				oneLayout.x = x;
				oneLayout.y = y;
				x += w;
				curLine.w = x - letterSpacing;
				curLine.y = y;
				maxWidth = Math.max(x + exWidth, maxWidth);
			}
			y = curLine.y + curLine.h;
			
			//如果行信息需要调整，包括有浮动，有居中等
			if (endAdjust) {
				//var dy:Number = 0;
				//valign === CSSStyle.VALIGN_MIDDLE && (dy = (height - y) / 2);
				//valign === CSSStyle.VALIGN_BOTTOM && (dy = (height - y));
				var tY:Number = 0;
				var tWidth:Number = width;
				//rtl模式固定使用行宽,所以不需要以下的处理
				//if (widthAuto && element.width > 0)
				//{
					//如果使用单行，这里一定要根据单行的实际宽（element.width）来排版
					//tWidth = element.width;
				//}
				for (i = 0, n = lines.length; i < n; i++) {
					lines[i].updatePos(0, tWidth, i, tY, align, valign, lineHeight);
					tY += Math.max(lineHeight, lines[i].h+leading);
				}
				y = tY;
			}
			widthAuto && (element.width = maxWidth);
			(y > element.height) && (element.height = y);
			
			//反转布局
			for (i = 0, n = lines.length; i < n; i++) {
					lines[i].revertOrder(width);
				}
			return [maxWidth, y];
		}
	}

}