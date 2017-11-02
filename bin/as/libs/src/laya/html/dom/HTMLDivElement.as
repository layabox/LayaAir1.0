package laya.html.dom {
	import laya.display.css.CSSStyle;
	import laya.display.Sprite;
	import laya.html.utils.HTMLParse;
	import laya.display.ILayout;
	import laya.html.utils.Layout;
	import laya.maths.Rectangle;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.utils.Browser;
	import laya.utils.HTMLChar;
	
	/**
	 * DIV标签
	 */
	public class HTMLDivElement extends HTMLElement {
		/** 实际内容的高 */
		public var contextHeight:Number;
		/** 实际内容的宽 */
		public var contextWidth:Number;
		
		public function HTMLDivElement() {
			super();
			style.block = true;
			style.lineElement = true;
			style.width = 200;
			style.height = 200;
			HTMLStyleElement;
		}
		
		/**
		 * 设置标签内容
		 */
		public function set innerHTML(text:String):void {
			//if (!text) this.size(0, 0);
			this.destroyChildren();
			appendHTML(text);
		}
		override public function set width(value:Number):void 
		{
			var changed:Boolean;
			if (value === 0)
			{
				changed = value != _width;
			}else
			{
				changed = value != width;
			}	
			super.width = value;
			if(changed)
			layout();
		}
		/**
		 * 追加内容，解析并对显示对象排版
		 * @param	text
		 */
		public function appendHTML(text:String):void {
			HTMLParse.parse(this, text, URI);
			layout();
		}
		
		/**
		 * @private
		 * @param	out
		 * @return
		 */
		override public function _addChildsToLayout(out:Vector.<ILayout>):Boolean {
			var words:Vector.<HTMLChar> = _getWords();
			if (words == null && _childs.length == 0) return false;
			words && words.forEach(function(o:*):void {
				out.push(o);
			});
			var tFirstKey:Boolean = true;
			
			for (var i:int = 0, len:int = _childs.length; i < len; i++)
			{
				var o:Sprite = _childs[i];
				if (tFirstKey) {
					tFirstKey = false;
				} else {
					out.push(null);
				}
				//o._style._enableLayout() && o._addToLayout(out);
				o._addToLayout(out)
			}
			return true;
		}
		
		/**
		 * @private
		 * @param	out
		 */
		override public function _addToLayout(out:Vector.<ILayout>):void {
			layout();
			//!_style.absolute && out.push(this);
		}
		
		/**
		 * @private
		 * 对显示内容进行排版
		 */
		public function layout():void {
			if (!style) return;
			style._type |= CSSStyle.ADDLAYOUTED;
			var tArray:Array = Layout.layout(this);
			if (tArray) {
				if (!_$P.mHtmlBounds) _set$P("mHtmlBounds", new Rectangle());
				var tRectangle:Rectangle = _$P.mHtmlBounds;
				tRectangle.x = tRectangle.y = 0;
				tRectangle.width = this.contextWidth = tArray[0];
				tRectangle.height = this.contextHeight = tArray[1];
				setBounds(tRectangle);
			}
		}
		
		/**
		 * 获取对象的高
		 */
		override public function get height():Number {
			if (_height) return _height;
			return contextHeight;
		}
		
		/**
		 * 获取对象的宽
		 */
		override public function get width():Number {
			if (_width) return _width;
			return contextWidth;
		}
	
	}

}