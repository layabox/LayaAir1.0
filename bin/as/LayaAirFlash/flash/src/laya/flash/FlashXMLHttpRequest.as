package laya.flash {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	/**
	 * ...
	 * @author laya
	 */
	public class FlashXMLHttpRequest {
		private var _request:URLRequest;
		private var _http:URLLoader;
		private var _status:Number;
		private var _proData:Object;
		public var onerror:Function = null;
		public var onabort:Function = null;
		public var onprogress:Function = null;
		public var onload:Function = null;
		
		public function FlashXMLHttpRequest() {
			_request = new URLRequest();
			
			_http = new URLLoader();
			_http.addEventListener(Event.COMPLETE, onComplete);
			_http.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_http.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			_http.addEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		
		public function send(data:* = null):void {
			this._status = -1;
			
			_request.data = data;
			_http.load(_request);
		}
		
		private function onComplete(e:Event):void {
			this._status = 200;
			if (onload != null) onload(e);
		}
		
		private function onError(e:ErrorEvent):void {
			if (onerror != null) onerror(e);
			trace( e );
		}
		
		private function onProgress(e:ProgressEvent):void {
			_proData || (_proData = {});
			_proData.loaded = e.bytesLoaded;
			_proData.total = e.bytesTotal;
			if (onprogress!=null) onprogress(_proData);
		}
		
		public function get status():Number {
			return _status;
		}
		
		public function get statusText():String {
			return "";
		}
		
		public function get responseText():String {
			return _http.data;
		}
		
		public function get response():* {
			return _http.data;
		}
		
		public function get responseURL():* {
			return _request.url;
		}
		
		public function get responseType():String {
			return _request.contentType;
		}
		
		public function set responseType(value:String):void {
			//_request.contentType = value;
			_http.dataFormat = value == "arraybuffer"?URLLoaderDataFormat.BINARY:URLLoaderDataFormat.TEXT;
		}
		
		public function open(method:String, url:String, async:Boolean):void {
			_request.method = method;
			_request.url = url;
		}
		
		public function setRequestHeader(name:String, value:String):void {
			var arr:Array = _request.requestHeaders || [];
			arr.push(new URLRequestHeader(name, value));
			_request.requestHeaders = arr;
		}
	}
}