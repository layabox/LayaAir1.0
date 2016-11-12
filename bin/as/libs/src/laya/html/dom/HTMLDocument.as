package laya.html.dom 
{
	import laya.display.css.CSSStyle;
	
	/**
	 * @private
	 */
	public class HTMLDocument extends HTMLElement 
	{
		public static var document:HTMLDocument = new HTMLDocument();
		
		public var all:Vector.<HTMLElement> = new Vector.<HTMLElement>;
		
		public var styleSheets:Object=CSSStyle.styleSheets;
		
		public function HTMLDocument() 
		{
			super();
		}
		
		public function getElementById(id:String):HTMLElement
		{
			return all[id];
		}
		
		public function setElementById(id:String, e:HTMLElement):void
		{
			all[id] = e;
		}
		
	}

}