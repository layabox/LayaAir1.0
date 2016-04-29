package laya.html.dom 
{
	import laya.display.css.CSSStyle;
	import laya.display.Sprite;
	import laya.html.utils.HTMLParse;
	import laya.display.ILayout;
	import laya.html.utils.Layout;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.utils.Browser;
	/**
	 * ...
	 * @author laya
	 */
	public class HTMLDivElement extends HTMLElement 
	{
		
		public var contextHeight:Number;
		public var contextWidth:Number;
		
		public function HTMLDivElement() 
		{
			super();
			style.block = true;
			style.lineElement = true;
			HTMLStyleElement;
		}
		
		public function set innerHTML(text:String):void
		{
			this.removeChildren();
			appendHTML(text);
		}
		
		public function appendHTML(text:String):void
		{
			HTMLParse.parse(this, text, URI);			
			layout();
		}
		
		/**@private */
		override public function _addChildsToLayout(out:Vector.<ILayout>):Boolean {
			var words:Vector.<Object> = _getWords();
			if (words == null && _childs.length == 0) return false;
			words && words.forEach(function(o:*):void {
				out.push(o);
			});
			var tFirstKey:Boolean = true;
			_childs.forEach(function(o:Sprite):void {
				if (tFirstKey)
				{
					tFirstKey = false;
				}else {
					out.push(null);
				}
				//o._style._enableLayout() && o._addToLayout(out);
				o._addToLayout(out)
			});
			return true;
		}
		
		override public function _addToLayout(out:Vector.<ILayout>):void
		{
			layout();
			//!_style.absolute && out.push(this);
		}
		
		public function layout():void
		{
			style._type |= CSSStyle.ADDLAYOUTED;
			var tArray:Array = Layout.layout(this);
			if (tArray)
			{
				this.contextWidth = tArray[0];
				this.contextHeight = tArray[1];
			}
		}
		
		override public function get height():Number {
			if (_height) return _height;
			return contextHeight;
		}
		
		override public function get width():Number {
			if (_width) return _width;
			return contextWidth;
		}
		
	}

}