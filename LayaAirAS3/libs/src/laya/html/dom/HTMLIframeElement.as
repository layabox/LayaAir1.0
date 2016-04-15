package laya.html.dom
{
	import laya.net.Loader;
	import laya.net.URL;
	import laya.events.Event;

	/**
	 * ...
	 * @author laya
	 */
	public class HTMLIframeElement extends HTMLDivElement 
	{
		public function HTMLIframeElement() 
		{
			super();
			this._getCSSStyle().valign = "middle";
		}
		
		override public function set href(url:String):void
		{
			url = formatURL(url);
			var l:Loader = new Loader();
			l.once(Event.COMPLETE, null, function(data:String):void {
				var pre:URL = URI;
				URI = new URL(url);
				innerHTML = data;
				!pre || (URI = pre);
			});
			l.load(url, Loader.TEXT);
		}
		
	}

}