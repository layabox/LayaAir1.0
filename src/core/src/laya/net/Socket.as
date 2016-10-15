package laya.net {
	
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.utils.Browser;
	import laya.utils.Byte;
	
	/**连接建立成功后调度。
	 * @eventType Event.OPEN
	 * */
	[Event(name = "open", type = "laya.events.Event")]
	/**接收到数据后调度。
	 * @eventType Event.MESSAGE
	 * */
	[Event(name = "message", type = "laya.events.Event")]
	/**连接被关闭后调度。
	 * @eventType Event.CLOSE
	 * */
	[Event(name = "close", type = "laya.events.Event")]
	/**出现异常后调度。
	 * @eventType Event.ERROR
	 * */
	[Event(name = "error", type = "laya.events.Event")]
	
	/**
	 * <code>Socket</code> 是一种双向通信协议，在建立连接后，服务器和 Browser/Client Agent 都能主动的向对方发送或接收数据。
	 */
	public class Socket extends EventDispatcher {
		/**
		 * 表示多字节数字的最低有效字节位于字节序列的最前面。
		 */
		public static const LITTLE_ENDIAN:String = "littleEndian";
		/**
		 * 表示多字节数字的最高有效字节位于字节序列的最前面。
		 */
		public static const BIG_ENDIAN:String = "bigEndian";
		/**@private */
		public var _endian:String;
		/**@private */
		private var _stamp:Number;
		/**@private */
		protected var _socket:*;
		/**@private */
		private var _connected:Boolean;
		/**@private */
		private var _addInputPosition:int;
		/**@private */
		private var _input:*;
		/**@private */
		private var _output:*;
		/**
		 * 表示建立连接时需等待的毫秒数。
		 */
		public var timeout:int;
		/**
		 * 在写入或读取对象时，控制所使用的 AMF 的版本。
		 */
		public var objectEncoding:int;
		/**
		 * 不使用socket提供的 input封装
		 */
		public var disableInput:Boolean=false;
		/**
		 * 用来发送接收数据的Byte类
		 */
		private var _byteClass:Class;
		
		/**
		 * 表示服务端发来的数据。
		 */
		public function get input():* {
			return _input;
		}
		
		/**
		 * 表示需要发送至服务端的缓冲区中的数据。
		 */
		public function get output():* {
			return _output;
		}
		
		/**
		 * 表示此 Socket 对象目前是否已连接。
		 */
		public function get connected():Boolean {
			return _connected;
		}
		
		/**
		 * 表示数据的字节顺序。
		 */
		public function get endian():String {
			return _endian;
		}
		
		public function set endian(value:String):void {
			_endian = value;
			if (_input != null) _input.endian = value;
			if (_output != null) _output.endian = value;
		}
		
		/**
		 * <p>创建一个新的 <code>Socket</code> 实例。</p>
		 * 创建 websocket ,如果host port有效直接连接。		 *
		 * @param host 服务器地址。
		 * @param port 服务器端口。
		 * @param byteClass 用来接收和发送数据的Byte类，默认使用Byte类，也可传入Byte类的子类。
		 *
		 */
		public function Socket(host:String = null, port:int = 0, byteClass:Class = null) {
			super();
			_byteClass = byteClass;
			_byteClass = _byteClass ? _byteClass : Byte;
			endian = BIG_ENDIAN;
			timeout = 20000;
			_addInputPosition = 0;
			if (host&&port > 0 && port < 65535)
				connect(host, port);
		}
		
		/**
		 * 连接到指定的主机和端口。
		 * @param host 服务器地址。
		 * @param port 服务器端口。
		 */
		public function connect(host:String, port:int):void {		
			var url:String = "ws://" + host + ":" + port;
			connectByUrl(url);		
		}
		/**
		 * 连接到指定的url
		 * @param url 连接目标
		 */
		public function connectByUrl(url:String):void {
			if (_socket != null)
				close();	
			
			_socket && _cleanSocket();
			_socket = new Browser.window.WebSocket( url );
			_socket.binaryType = "arraybuffer";
			
			_output = new _byteClass();
			_output.endian = endian;
			_input = new _byteClass();
			_input.endian = endian;
			_addInputPosition = 0;
			
			_socket.onopen = function(e:*):void {
				_onOpen(e);
			};
			_socket.onmessage = function(msg:*):void {
				_onMessage(msg);
			};
			_socket.onclose = function(e:*):void {
				_onClose(e);
			};
			_socket.onerror = function(e:*):void {
				_onError(e);
			};	
			
		}
		private function _cleanSocket():void {
			try {
				_socket.close();
			} catch (e:*) {
			}
			_connected=false;
			_socket.onopen = null;
			_socket.onmessage = null;
			_socket.onclose = null;
			_socket.onerror = null;
			_socket = null;
		}
		
		/**
		 * 关闭连接。
		 */
		public function close():void {
			if (_socket != null) {
				_cleanSocket();
			}
		}
		
		/**
		 * @private
		 * 连接建立成功 。
		 */
		protected function _onOpen(e:*):void {
			_connected = true;
			event(Event.OPEN,e);
		}
		
		/**
		 * @private
		 * 接收到数据处理方法。
		 * @param msg 数据。
		 */
		protected function _onMessage(msg:*):void {
			if (!msg || !msg.data) return;
			var data:* = msg.data;
			if(disableInput&&data)
			{
				event(Event.MESSAGE, data);
				return;
			}
			if (_input.length > 0 && _input.bytesAvailable < 1) {
				_input.clear();
				_addInputPosition = 0;
			}
			var pre:int = _input.pos;
			!_addInputPosition && (_addInputPosition = 0);
			_input.pos = _addInputPosition;
			
			if (data) {
				if (data is String) {
					_input.writeUTFBytes(data);
				} else {
					_input.writeArrayBuffer(data);
				}
				_addInputPosition = _input.pos;
				_input.pos = pre;
			}
			event(Event.MESSAGE, data);
		}
		
		/**
		 * @private
		 * 连接被关闭处理方法。
		 */
		protected function _onClose(e:*):void {
			_connected=false;
			event(Event.CLOSE,e)
		}
		
		/**
		 * @private
		 * 出现异常处理方法。
		 */
		protected function _onError(e:*):void {
			event(Event.ERROR,e)
		}
		
		/**
		 * 发送数据到服务器。
		 * @param	data 需要发送的数据，可以是String或者ArrayBuffer。
		 */
		public function send(data:*):void {
			this._socket.send(data);
		}
		
		/**
		 * 发送缓冲区中的数据到服务器。
		 */
		public function flush():void {
			if (_output && _output.length > 0) {
				try {
					this._socket && this._socket.send(this._output.__getBuffer().slice(0, this._output.length));
					_output.endian = endian;
					_output.clear();
				} catch (e:*) {
                     event(Event.ERROR,e);
				}
			}
		}
	}
}
