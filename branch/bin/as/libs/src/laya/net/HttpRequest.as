package laya.net {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.utils.Browser;
	import laya.utils.Utils;
	
	/**
	 * 请求进度改变时调度。
	 * @eventType Event.PROGRESS
	 * */
	[Event(name = "progress", type = "laya.events.Event")]
	/**
	 * 请求结束后调度。
	 * @eventType Event.COMPLETE
	 * */
	[Event(name = "complete", type = "laya.events.Event")]
	/**
	 * 请求出错时调度。
	 * @eventType Event.ERROR
	 * */
	[Event(name = "error", type = "laya.events.Event")]
	
	/**
	 * <code>HttpRequest</code> 通过 HTTP 协议传送或接收 XML 及其他数据。
	 */
	public class HttpRequest extends EventDispatcher {
		/**@private */
		protected var _http:* = new Browser.window.XMLHttpRequest();
		/**@private */
		protected var _responseType:String;
		/**@private */
		protected var _data:*;
		
		/**
		 * 发送请求。
		 * @param	url 请求的地址。
		 * @param	data 发送的数据，可选。
		 * @param	method 发送数据方式，值为“get”或“post”，默认为 “get”方式。
		 * @param	responseType 返回消息类型，可设置为"text"，"json"，"xml","arraybuffer"。
		 * @param	headers 头信息，key value数组，比如["Content-Type", "application/json"]。
		 */
		public function send(url:String, data:* = null, method:String = "get", responseType:String = "text", headers:Array = null):void {
			_responseType = responseType;
			_data = null;
			var _this:HttpRequest = this;
			var http:* = this._http;
			http.open(method, url, true);
			if (headers) {
				for (var i:int = 0; i < headers.length; i++) {
					http.setRequestHeader(headers[i++], headers[i]);
				}
			} else {
				if (!data || data is String) http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
				else http.setRequestHeader("Content-Type", "application/json");
			}
			http.responseType = responseType !== "arraybuffer" ? "text" : "arraybuffer";
			http.onerror = function(e:*):void {
				_this._onError(e);
			}
			http.onabort = function(e:*):void {
				_this._onAbort(e);
			}
			http.onprogress = function(e:*):void {
				_this._onProgress(e);
			}
			http.onload = function(e:*):void {
				_this._onLoad(e);
			}
			http.send(data);
		}
		
		/**
		 * @private
		 * 请求进度的侦听处理函数。
		 * @param	e 事件对象。
		 */
		protected function _onProgress(e:*):void {
			if (e && e.lengthComputable) event(Event.PROGRESS, e.loaded / e.total);
		}
		
		/**
		 * @private
		 * 请求中断的侦听处理函数。
		 * @param	e 事件对象。
		 */
		protected function _onAbort(e:*):void {
			error("Request was aborted by user");
		}
		
		/**
		 * @private
		 * 请求出错侦的听处理函数。
		 * @param	e 事件对象。
		 */
		protected function _onError(e:*):void {
			error("Request failed Status:" + this._http.status + " text:" + this._http.statusText);
		}
		
		/**
		 * @private
		 * 请求消息返回的侦听处理函数。
		 * @param	e 事件对象。
		 */
		protected function _onLoad(e:*):void {
			var http:* = this._http;
			var status:Number = http.status !== undefined ? http.status : 200;
			
			if (status === 200 || status === 204 || status === 0) {
				complete();
			} else {
				error("[" + http.status + "]" + http.statusText + ":" + http.responseURL);
			}
		}
		
		/**
		 * @private
		 * 请求错误的处理函数。
		 * @param	message 错误信息。
		 */
		protected function error(message:String):void {
			clear();
			event(Event.ERROR, message);
		}
		
		/**
		 * @private
		 * 请求成功完成的处理函数。
		 */
		protected function complete():void {
			clear();
			var flag:Boolean = true;
			try {
				if (_responseType === "json") {
					this._data = JSON.parse(_http.responseText);
				} else if (_responseType === "xml") {
					this._data = Utils.parseXMLFromString(_http.responseText);
				} else {
					this._data = _http.response || _http.responseText;
				}
			} catch (e:*) {
				flag = false;
				error(e.message);
			}
			flag && event(Event.COMPLETE, this._data is Array ? [this._data] : this._data);
		}
		
		/**
		 * @private
		 * 清除当前请求。
		 */
		protected function clear():void {
			var http:* = this._http;
			http.onerror = http.onabort = http.onprogress = http.onload = null;
		}
		
		/** 请求的地址。*/
		public function get url():String {
			return _http.responseURL;
		}
		
		/** 返回的数据。*/
		public function get data():* {
			return _data;
		}
		
		/**原生XMLHttpRequest引用*/
		public function get http():* {
			return _http;
		}
	}
}