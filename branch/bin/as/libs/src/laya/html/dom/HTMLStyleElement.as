package laya.html.dom 
{
	import laya.display.css.CSSStyle;
	/**
	 * @private
	 */
	public class HTMLStyleElement extends HTMLElement 
	{
		public function HTMLStyleElement() 
		{
			super();
			visible = false;
		}
		
		/**
		 * 解析样式
		 */
		override public function set text(value:String):void
		{
			CSSStyle.parseCSS(value,null);			
		}
	}

}