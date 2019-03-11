package laya.net {
	import laya.events.Event;
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.RunDriver;
	
	/**
	 * @private
	 */
	public class TTFLoader {
		private static const _testString:String = "LayaTTFFont";
		public var fontName:String;
		public var complete:Handler;
		public var err:Handler;
		private var _fontTxt:String;
		private var _url:String;
		private var _div:*;
		private var _txtWidth:Number;
		private var _http:HttpRequest;
		
		//TODO:coverage
		public function load(fontPath:String):void {
			_url = fontPath;
			var tArr:Array = fontPath.split(".ttf")[0].split("/");
			fontName = tArr[tArr.length - 1];
			if (Render.isConchApp)
			{
				_loadConch();
			}else
			if (Browser.window.FontFace) {
				this._loadWithFontFace()
			}
			else {
				this._loadWithCSS();
			}
		}
		
		//TODO:coverage
		private function _loadConch():void
		{
			_http = new HttpRequest();
			_http.on(Event.ERROR, this, _onErr);
			_http.on(Event.COMPLETE, this, _onHttpLoaded);
			_http.send(_url, null, "get", Loader.BUFFER);
		}
		
		//TODO:coverage
		private function _onHttpLoaded(data:* = null):void
		{
			Browser.window["conchTextCanvas"].setFontFaceFromBuffer(fontName, data);
			_clearHttp();
			_complete();
		}
		
		//TODO:coverage
		private function _clearHttp():void
		{
			if (_http)
			{
				_http.off(Event.ERROR, this, _onErr);
				_http.off(Event.COMPLETE, this, _onHttpLoaded);
				_http = null;
			}
		}
		
		//TODO:coverage
		private function _onErr():void
		{
			_clearHttp();
			if (err)
			{
				err.runWith("fail:" + _url);
				err = null;
			}
		}
		
		//TODO:coverage
		private function _complete():void {
			Laya.systemTimer.clear(this, _complete);
			Laya.systemTimer.clear(this, _checkComplete);
			if (_div && _div.parentNode) {
				
				_div.parentNode.removeChild(_div);
				_div = null;
			}
			if (complete) {
				complete.runWith(this);
				complete = null;
			}
		}
		
		//TODO:coverage
		private function _checkComplete():void {
			if (RunDriver.measureText(_testString, _fontTxt).width != _txtWidth) {
				_complete();
			}
		}
		
		//TODO:coverage
		private function _loadWithFontFace():void {
				
			var fontFace:* = new Browser.window.FontFace(fontName, "url('" + _url + "')");
			Browser.window.document.fonts.add(fontFace);
			var self:TTFLoader = this;
			fontFace.loaded.then((function():void {
					self._complete()
				}));
			//_createDiv();
			fontFace.load();
		
		}
		
		//TODO:coverage
		private function _createDiv():void {
			_div = Browser.createElement("div");
			_div.innerHTML = "laya";
			var _style:* = _div.style;
			_style.fontFamily = fontName;
			_style.position = "absolute";
			_style.left = "-100px";
			_style.top = "-100px";
			Browser.document.body.appendChild(_div);
		}
		
		//TODO:coverage
		private function _loadWithCSS():void {
			
			var fontStyle:* = Browser.createElement("style");
			fontStyle.type = "text/css";
			Browser.document.body.appendChild(fontStyle);
			fontStyle.textContent = "@font-face { font-family:'" + fontName + "'; src:url('" + _url + "');}";	
			_fontTxt = "40px " + fontName;
			_txtWidth = RunDriver.measureText(_testString, _fontTxt).width;
			
			var self:TTFLoader = this;
			fontStyle.onload = function():void {
				Laya.systemTimer.once(10000, self, _complete);
			};
			Laya.systemTimer.loop(20, this, _checkComplete);
			
			_createDiv();
		
		}
	
	}

}