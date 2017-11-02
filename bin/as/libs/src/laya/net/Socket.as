package laya.net {
	
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.utils.Browser;
	import laya.utils.Byte;
	
	/**
	 * 连接建立成功后调度。
	 * @eventType Event.OPEN
	 * */
	[Event(name = "open", type = "laya.events.Event")]
	/**
	 * 接收到数据后调度。
	 * @eventType Event.MESSAGE
	 * */
	[Event(name = "message", type = "laya.events.Event")]
	/**
	 * 连接被关闭后调度。
	 * @eventType Event.CLOSE
	 * */
	[Event(name = "close", type = "laya.events.Event")]
	/**
	 * 出现异常后调度。
	 * @eventType Event.ERROR
	 * */
	[Event(name = "error", type = "laya.events.Event")]
	
	/**
	 * <p> <code>Socket</code> 封装了 HTML5 WebSocket ，允许服务器端与客户端进行全双工（full-duplex）的实时通信，并且允许跨域通信。在建立连接后，服务器和 Browser/Client Agent 都能主动的向对方发送或接收文本和二进制数据。</p>
	 * <p>要使用 <code>Socket</code> 类的方法，请先使用构造函数 <code>new Socket</code> 创建一个 <code>Socket</code> 对象。 <code>Socket</code> 以异步方式传输和接收数据。</p>
	 */
	public class Socket extends EventDispatcher {
		/**
		 * <p>主机字节序，是 CPU 存放数据的两种不同顺序，包括小端字节序和大端字节序。</p>
		 * <p> LITTLE_ENDIAN ：小端字节序，地址低位存储值的低位，地址高位存储值的高位。</p>
		 * <p> BIG_ENDIAN ：大端字节序，地址低位存储值的高位，地址高位存储值的低位。有时也称之为网络字节序。</p>
		 */
		public static const LITTLE_ENDIAN:String = "littleEndian";
		/**
		 * <p>主机字节序，是 CPU 存放数据的两种不同顺序，包括小端字节序和大端字节序。</p>
		 * <p> BIG_ENDIAN ：大端字节序，地址低位存储值的高位，地址高位存储值的低位。有时也称之为网络字节序。</p>
		 * <p> LITTLE_ENDIAN ：小端字节序，地址低位存储值的低位，地址高位存储值的高位。</p>
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
		 * @private
		 * 表示建立连接时需等待的毫秒数。
		 */
		public var timeout:int;
		/**
		 * @private
		 * 在写入或读取对象时，控制所使用的 AMF 的版本。
		 */
		public var objectEncoding:int;
		/**
		 * 不再缓存服务端发来的数据。
		 */
		public var disableInput:Boolean = false;
		/**
		 * 用来发送和接收数据的 <code>Byte</code> 类。
		 */
		private var _byteClass:Class;
		/**
		 * <p>子协议名称。子协议名称字符串，或由多个子协议名称字符串构成的数组。必须在调用 connect 或者 connectByUrl 之前进行赋值，否则无效。</p>
		 * <p>指定后，只有当服务器选择了其中的某个子协议，连接才能建立成功，否则建立失败，派发 Event.ERROR 事件。</p>
		 * @see https://html.spec.whatwg.org/multipage/comms.html#dom-websocket
		 */
		public var protocols:* = [];
		
		/**
		 * 缓存的服务端发来的数据。
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
		 * <p>主机字节序，是 CPU 存放数据的两种不同顺序，包括小端字节序和大端字节序。</p>
		 * <p> LITTLE_ENDIAN ：小端字节序，地址低位存储值的低位，地址高位存储值的高位。</p>
		 * <p> BIG_ENDIAN ：大端字节序，地址低位存储值的高位，地址高位存储值的低位。</p>
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
		 * <p>创建新的 Socket 对象。默认字节序为 Socket.BIG_ENDIAN 。若未指定参数，将创建一个最初处于断开状态的套接字。若指定了有效参数，则尝试连接到指定的主机和端口。</p>
		 * <p><b>注意：</b>强烈建议使用<b>不带参数</b>的构造函数形式，并添加任意事件侦听器和设置 protocols 等属性，然后使用 host 和 port 参数调用 connect 方法。此顺序将确保所有事件侦听器和其他相关流程工作正常。</p>
		 * @param host		服务器地址。
		 * @param port		服务器端口。
		 * @param byteClass	用于接收和发送数据的 Byte 类。如果为 null ，则使用 Byte 类，也可传入 Byte 类的子类。
		 * @see laya.utils.Byte
		 */
		public function Socket(host:String = null, port:int = 0, byteClass:Class = null) {
			super();
			_byteClass = byteClass ? byteClass : Byte;
			endian = BIG_ENDIAN;
			timeout = 20000;
			_addInputPosition = 0;
			if (host && port > 0 && port < 65535)
				connect(host, port);
		}
		
		/**
		 * <p>连接到指定的主机和端口。</p>
		 * <p>连接成功派发 Event.OPEN 事件；连接失败派发 Event.ERROR 事件；连接被关闭派发 Event.CLOSE 事件；接收到数据派发 Event.MESSAGE 事件； 除了 Event.MESSAGE 事件参数为数据内容，其他事件参数都是原生的 HTML DOM Event 对象。</p>
		 * @param host	服务器地址。
		 * @param port	服务器端口。
		 */
		public function connect(host:String, port:int):void {
			var url:String = "ws://" + host + ":" + port;
			if (Browser.window.location.protocol == "https:") {
				url = "wss://" + host + ":" + port;
			} else {
				url = "ws://" + host + ":" + port;
			}
			connectByUrl(url);
		}
		
		/**
		 * <p>连接到指定的服务端 WebSocket URL。 URL 类似 ws://yourdomain:port。</p>
		 * <p>连接成功派发 Event.OPEN 事件；连接失败派发 Event.ERROR 事件；连接被关闭派发 Event.CLOSE 事件；接收到数据派发 Event.MESSAGE 事件； 除了 Event.MESSAGE 事件参数为数据内容，其他事件参数都是原生的 HTML DOM Event 对象。</p>
		 * @param url	要连接的服务端 WebSocket URL。 URL 类似 ws://yourdomain:port。
		 */
		public function connectByUrl(url:String):void {
			if (_socket != null)
				close();
			
			_socket && cleanSocket();
			
			if (!protocols || protocols.length == 0) {
				_socket = new Browser.window.WebSocket(url);
			} else {
				_socket = new Browser.window.WebSocket(url, protocols);
			}
			
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
		
		/**
		 * 清理socket。
		 */
		public function cleanSocket():void {
			try {
				_socket.close();
			} catch (e:*) {
			}
			_connected = false;
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
				try {
					_socket.close();
				} catch (e:*) {
				}
			}
		}
		
		/**
		 * @private
		 * 连接建立成功 。
		 */
		protected function _onOpen(e:*):void {
			_connected = true;
			event(Event.OPEN, e);
		}
		
		/**
		 * @private
		 * 接收到数据处理方法。
		 * @param msg 数据。
		 */
		protected function _onMessage(msg:*):void {
			if (!msg || !msg.data) return;
			var data:* = msg.data;
			if (disableInput && data) {
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
			_connected = false;
			event(Event.CLOSE, e)
		}
		
		/**
		 * @private
		 * 出现异常处理方法。
		 */
		protected function _onError(e:*):void {
			event(Event.ERROR, e)
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
				var evt:*;
				try {
					this._socket && this._socket.send(this._output.__getBuffer().slice(0, this._output.length));
				} catch (e:*) {
					evt = e;
				}
				_output.endian = endian;
				_output.clear();
				if (evt) event(Event.ERROR, evt);
			}
		}
	}
}
