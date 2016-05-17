package laya.html.dom{
	import laya.display.css.CSSStyle;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.events.Event;

	/**
	 * @private
	 */
	public class HTMLLinkElement extends HTMLElement 
	{
		public var type:String;
		
		public static var _cuttingStyle:RegExp=/*[STATIC SAFE]*/new RegExp("((@keyframes[\\s\\t]+|)(.+))[\\t\\n\\r\\\s]*{","g");		
		
		public function HTMLLinkElement() 
		{
			super();
			visible = false;
		}
		
		public function _onload(data:String):void
		{
			switch(type)
			{
				case 'text/css':
					CSSStyle.parseCSS(data,URI);
					break;
			}
		}
		
		override public function set href(url:String):void
		{
			url = formatURL(url);
			URI = new URL(url);
			var l:Loader = new Loader();
			l.once(Event.COMPLETE, null, function(data:String):void {
				_onload(data);
			});
			l.load(url, Loader.TEXT);
		}
	}

}