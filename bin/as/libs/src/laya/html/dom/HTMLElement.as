package laya.html.dom
{
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.display.css.CSSStyle;
	import laya.display.Text;
	import laya.events.Event;
	import laya.html.utils.Layout;
	import laya.net.URL;
	import laya.renders.Render;
	import laya.renders.RenderSprite;
	import laya.utils.HTMLChar;
	import laya.utils.Utils;
	
	/**
	 * @private
	 */
	public class HTMLElement extends Sprite
	{
		private static var _EMPTYTEXT:Object = /*[STATIC SAFE]*/ {text: null, words: null};
		
		private var _text:Object = _EMPTYTEXT;
		
		public var URI:URL;
		
		private var _href:String = null;
		
		public function HTMLElement()
		{
			//_childRenderMax = true;
			setStyle(new CSSStyle(this));
			//设置CSS默认属性
			this._getCSSStyle().valign = "middle";
			mouseEnabled = true;
		}
		/**
		 * @private
		 */
		public function layaoutCallNative():void
		{
			var n:int = 0;
			if (_childs &&(n= _childs.length) > 0)
			{
				for (var i:int = 0; i < n; i++ )
				{
					_childs[i].layaoutCallNative && _childs[i].layaoutCallNative();
				}
			}
			var word:Vector.<HTMLChar> = _getWords();
			word ? HTMLElement.fillWords(this,word,0,0,this.style.font,this.style.color,this.style.underLine) : this.graphics.clear();
			
		}
		
		public function set id(value:String):void
		{
			HTMLDocument.document.setElementById(value, this);
		}
		
		public function set text(value:String):void
		{
			if (_text == _EMPTYTEXT)
			{
				_text = {text: value, words: null};
			}
			else
			{
				_text.text = value;
				_text.words && (_text.words.length = 0);
			}
			Render.isConchApp && this.layaoutCallNative();
			_renderType |= RenderSprite.CHILDS;
			repaint();
			updateHref();
		}
		
		public function get text():String
		{
			return _text.text;
		}
		
		public function set innerTEXT(value:String):void
		{
			text = value;
		}
		
		public function get innerTEXT():String
		{
			return _text.text;
		}
				
		override public function set parent(value:Node):void
		{
			if (value is HTMLElement)
			{
				var p:HTMLElement = value as HTMLElement;
				URI || (URI = p.URI);
				style.inherit(p.style);
			}
			
			super.parent = value;
		}
		
		public function appendChild(c:HTMLElement):HTMLElement
		{
			return addChild(c) as HTMLElement;
		}
		
		public function get style():CSSStyle
		{
			return _style as CSSStyle;
		}

		/**
		 * rtl模式的getWords函數 
		 */		
		public function _getWords2():Vector.<HTMLChar>
		{
			var txt:String = _text.text;
			if (!txt || txt.length === 0)
				return null;
			var i:int = 0, n:int;
			var realWords:Array;
			var drawWords:Array;
			if (!_text.drawWords)
			{
				realWords = txt.split(" ");
				n = realWords.length-1;
				
				drawWords = [];
				for (i = 0; i < n; i++)
				{
					drawWords.push(realWords[i]," ")
				}
				if(n>=0)
				drawWords.push(realWords[n]);
				_text.drawWords = drawWords;
			}else
			{
				drawWords = _text.drawWords;
			}
				
			var words:Vector.<HTMLChar> = _text.words;
			if (words && words.length === drawWords.length)
				return words as Vector.<HTMLChar>;
			words === null && (_text.words = words = new Vector.<HTMLChar>());
			words.length = drawWords.length;
			
			var size:Object;
			var style:CSSStyle = this.style;
			var fontStr:String = style.font;

			for (i= 0, n = drawWords.length; i < n; i++)
			{
				size = Utils.measureText(drawWords[i], fontStr);
				
				var tHTMLChar:HTMLChar = words[i] = new HTMLChar(drawWords[i], size.width, size.height || style.fontSize, style);
				if (tHTMLChar.char.length > 1)
				{
					tHTMLChar.charNum = tHTMLChar.char as Number;
				}
				if (href)
				{
					var tSprite:Sprite = new Sprite();
					addChild(tSprite);
					tHTMLChar.setSprite(tSprite);
				}
			}
			return words;
		}
		
		override public function _getWords():Vector.<HTMLChar>
		{
			if (!Text.CharacterCache) return _getWords2();
			var txt:String = _text.text;
			if (!txt || txt.length === 0)
				return null;
			
			var words:Vector.<HTMLChar> = _text.words;
			if (words && words.length === txt.length)
				return words as Vector.<HTMLChar>;
			words === null && (_text.words = words = new Vector.<HTMLChar>());
			words.length = txt.length;
			
			var size:Object;
			var style:CSSStyle = this.style;
			var fontStr:String = style.font;
			
			var startX:int = 0;
			for (var i:int = 0, n:int = txt.length; i < n; i++)
			{
				size = Utils.measureText(txt.charAt(i), fontStr);
				var tHTMLChar:HTMLChar = words[i] = new HTMLChar(txt.charAt(i), size.width, size.height||style.fontSize, style);
				if (href)
				{
					var tSprite:Sprite = new Sprite();
					addChild(tSprite);
					tHTMLChar.setSprite(tSprite);
				}
			}
			return words;
		}
		
		public function showLinkSprite():void
		{
			var words:Vector.<HTMLChar> = _text.words;
			if (words)
			{
				var tLinkSpriteList:Vector.<Sprite> = new Vector.<Sprite>();
				var tSprite:Sprite;
				var tHtmlChar:HTMLChar;
				for (var i:int = 0; i < words.length; i++)
				{
					tHtmlChar = words[i];
					tSprite = new Sprite();
					tSprite.graphics.drawRect(0, 0, tHtmlChar.width, tHtmlChar.height,"#ff0000");
					tSprite.width = tHtmlChar.width;
					tSprite.height = tHtmlChar.height;
					addChild(tSprite);
					tLinkSpriteList.push(tSprite);
				}
			}
		}
		
		public override function _layoutLater():void
		{
			var style:CSSStyle = this.style;
			
			if ( (style._type & CSSStyle.ADDLAYOUTED)) return;
			
			if ( style.widthed(this) && (_childs.length>0 || _getWords()!=null) && style.block )
			{
				Layout.later(this);
				style._type |= CSSStyle.ADDLAYOUTED;
			}
			else
			{
				parent && (parent as Sprite)._layoutLater();
			}
		}
		
		public function set onClick(value:String):void
		{
			var fn:Function;
			__JS__('eval("fn=function(event){" + value+";}")');
			on(Event.CLICK, this, fn);
		}
		
		override public function _setAttributes(name:String, value:String):void
		{
			switch (name)
			{
				case 'style': 
					style.cssText(value);
					return;
				case 'class': 
					className = value;
					return;
			}
			super._setAttributes(name, value);
		}
		
		public function set href(url:String):void
		{
			_href = url;
			if (url != null)
			{
				_getCSSStyle().underLine = 1;
				updateHref();
			}
		}
		
		private function updateHref():void
		{
			if (_href != null)
			{
				var words:Vector.<HTMLChar> = _getWords() as Vector.<HTMLChar>;
				if (words)
				{
					var tHTMLChar:HTMLChar;
					var tSprite:Sprite;
					for (var i:int = 0; i < words.length; i++)
					{
						tHTMLChar = words[i];
						tSprite = tHTMLChar.getSprite();
						if (tSprite)
						{
							//tSprite.graphics.drawRect(0, 0, tHTMLChar.width, tHTMLChar.height, null, '#ff0000');
							//var tHeight:Number = tHTMLChar.height - 1;
							//var dX:Number = tHTMLChar.style.letterSpacing*0.5;
							//if (!dX) dX = 0;
							//tSprite.graphics.drawLine(0-dX, tHeight, tHTMLChar.width+dX, tHeight, tHTMLChar._getCSSStyle().color);
							tSprite.size(tHTMLChar.width, tHTMLChar.height);
							tSprite.on(Event.CLICK, this, onLinkHandler);
						}
					}
				}
			}
		}
		
		private function onLinkHandler(e:Event):void
		{
			switch(e.type)
			{
				case Event.CLICK:					
					var target:Sprite = this;
					while (target){
						target.event(Event.LINK, [href]);
						target = target.parent as Sprite;
					}
					break;
			}
		}
		
		public function get href():String
		{
			return _href;
		}
		
		public function formatURL(url:String):String
		{
			if (!URI) return url;
			return URL.formatURL(url, URI ? URI.path : null);
		}
		
		public function set color(value:String):void
		{
			style.color = value;
		}
		
		public function set className(value:String):void
		{
			style.attrs(HTMLDocument.document.styleSheets['.' + value]);
		}
		
		/*** @private */
		public static function fillWords(ele:HTMLElement, words:Vector.<HTMLChar>, x:Number, y:Number, font:String, color:String,underLine:int):void {
			ele.graphics.clear();
			for (var i:int = 0, n:int = words.length; i < n; i++) {
				var a:* = words[i];
				ele.graphics.fillText(a.char, a.x + x, a.y + y, font, color, 'left',underLine);
			}
		}
	}

}