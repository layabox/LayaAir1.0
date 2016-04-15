package laya.net {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.utils.Browser;
	
	/**请求进度事件*/
	[Event(name = "progress")]
	/**请求结束事件*/
	[Event(name = "complete")]
	/**请求出错事件*/
	[Event(name = "error")]
	
	/**
	 * HTTP请求
	 * @author yung
	 */
	public class HttpRequest extends EventDispatcher {
		
		private var _http:* = new Browser.window.XMLHttpRequest();
		private var _responseType:String;
		private var _data:*;
		
		/**
		 * 发送请求
		 * @param	url 请求的地址
		 * @param	data 发送的数据，可选
		 * @param	method 发送数据方式，值为"get"或"post"，默认为get方式
		 * @param	responseType 返回消息类型，可设置为"text"，"json"，"xml","arraybuffer"
		 * @param	headers 头信息，key value数组，比如["Content-Type", "application/json"]
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
				_this.onError(e);
			}
			http.onabort = function(e:*):void {
				_this.onAbort(e);
			}
			http.onprogress = function(e:*):void {
				_this.onProgress(e);
			}
			http.onload = function(e:*):void {
				_this.onLoad(e);
			}
			http.send(data);
		}
		
		protected function onProgress(e:*):void {
			if (e && e.lengthComputable) event(Event.PROGRESS, e.loaded / e.total);
		}
		
		protected function onAbort(e:*):void {
			error("Request was aborted by user");
		}
		
		protected function onError(e:*):void {
			error("Request failed Status:" + this._http.status + " text:" + this._http.statusText);
		}
		
		protected function onLoad(e:*):void {
			var http:* = this._http;
			var status:Number = http.status !== undefined ? http.status : 200;
			
			if (status === 200 || status === 204 || status === 0) {
				complete();
			} else {
				error("[" + http.status + "]" + http.statusText + ":" + http.responseURL);
			}
		}
		
		protected function error(message:String):void {
			clear();
			event(Event.ERROR, message);
		}
		
		protected function complete():void {
			clear();
			if (_responseType === "json") {
				//[IF-SCRIPT] this._data = JSON.parse(_http.responseText);
			} else if (_responseType === "xml") {
				var dom:* = new Browser.window.DOMParser();
				this._data = dom.parseFromString(_http.responseText, "text/xml");
			} else {
				this._data = _http.response || _http.responseText;
			}
			event(Event.COMPLETE, this._data is Array ? [this._data] : this._data);
		}
		
		protected function clear():void {
			var http:* = this._http;
			http.onerror = http.onabort = http.onprogress = http.onload = null;
		}
		
		/**请求的地址*/
		public function get url():String {
			return _http.responseURL;
		}
		
		/**返回的数据*/
		public function get data():* {
			return _data;
		}
	}
}