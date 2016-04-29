package laya.html.dom 
{
	import laya.display.css.CSSStyle;
	/**
	 * ...
	 * @author laya
	 */
	public class HTMLStyleElement extends HTMLElement 
	{
		public function HTMLStyleElement() 
		{
			super();
			visible = false;
		}
		
		override public function set text(value:String):void
		{
			CSSStyle.parseCSS(value,null);			
		}
	}

}