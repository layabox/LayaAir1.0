package laya.net {
	
	import laya.events.Event;
	import laya.events.EventDispatcher;
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
	 *
	 * @author laiyuanyuan
	 *
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
		private var _host:String;
		/**@private */
		private var _port:int;
		/**@private */
		private var _addInputPosition:int;
		/**@private */
		private var _input:Byte;
		/**@private */
		private var _output:Byte;
		/**@private */
		private var _bytes:Byte;
		/**
		 * 表示建立连接时需等待的毫秒数。
		 */
		public var timeout:int;
		/**
		 * 在写入或读取对象时，控制所使用的 AMF 的版本。
		 */
		public var objectEncoding:int;
		
		/**
		 * 用来发送接收数据的Byte类
		 */
		private var _byteClass:Class;
		
		/**
		 * 表示服务端发来的数据。
		 * @return
		 *
		 */
		public function get input():Byte {
			return _input;
		}
		
		/**
		 * 表示需要发送至服务端的缓冲区中的数据。
		 * @return
		 *
		 */
		public function get output():Byte {
			return _output;
		}
		
		/**
		 * 表示此 Socket 对象目前是否已连接。
		 * @return
		 *
		 */
		public function get connected():Boolean {
			return _connected;
		}
		
		/**
		 * 表示数据的字节顺序。
		 * @return
		 *
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
			if (port > 0 && port < 65535)
				connect(host, port);
		}
		
		/**
		 * 连接到指定的主机和端口。
		 * @param host
		 * @param port
		 *
		 */
		public function connect(host:String, port:int):void {
			if (_socket != null)
				close();
			
			//			if( port < 0 || port > 65535 )
			//				throw new Error("Invalid socket port number specified."+port);
			
			var url:String = "ws://" + host + ":" + port;
			
			_host = host;
			_port = port;
			
			_socket && cleanSocket();
			_socket = __JS__("new WebSocket(url)");
			_socket.binaryType = "arraybuffer";
			
			_output = new _byteClass();
			_output.endian = endian;
			_input = new _byteClass();
			_input.endian = endian;
			
			_socket.onopen = function(... args):void {
				onOpenHandler(args);
			};
			_socket.onmessage = function(msg:*):void {
				onMessageHandler(msg);
			};
			_socket.onclose = function(... args):void {
				onCloseHandler(args);
			};
			_socket.onerror = function(... args):void {
				onErrorHandler(args);
			};
			
			_socket.binaryType = "arraybuffer";
		}
		
		private function cleanSocket():void {
			try {
				_socket.close();
			} catch (e:*) {
			}
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
				cleanSocket();
			}
		/*else{
		   throw"Operation attempted on invalid socket.";
		   }*/
		}
		
		/**
		 * 连接建立成功 。
		 * @param args
		 */
		protected function onOpenHandler(... args):void {
			//trace("connected");
			_connected = true;
			event(Event.OPEN);
		}
		
		/**
		 * 接收到数据处理方法。
		 * @param msg 数据
		 */
		protected function onMessageHandler(msg:*):void {
			//trace("msg:" + msg.data.length+"\n"+msg.data);
			if (_input.length > 0 && _input.bytesAvailable < 1) {
				_input.clear();
				_addInputPosition = 0;
			}
			var pre:int = _input.pos;
			!_addInputPosition && (_addInputPosition = 0);
			_input.pos = _addInputPosition;
			if (!msg || !msg.data) return;
			var data:* = msg.data;
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
		 * 连接被关闭处理方法。
		 * @param args
		 */
		protected function onCloseHandler(... args):void {
			//trace("onclose");
			//这里不能主动派发close事件，因为flash这边仅在服务器关闭连接时调度 close 事件；在调用 close() 方法时不调度该事件  shaoxin.ji add
			event(Event.CLOSE)
		}
		
		/**
		 * 出现异常处理方法。
		 * @param args
		 */
		protected function onErrorHandler(... args):void {
			//trace("ERROR");
			event(Event.ERROR)
		}
		
		/**
		 * 发送字符串数据到服务器，测试用函数。
		 * @param	_str
		 */
		public function sendString(_str:String):void {
			this._socket.send(_str);
		}
		
		/**
		 * 发送缓冲区中的数据到服务器。
		 */
		public function flush():void {
			//			if( _socket == null )
			//				throw "Operation attempted on invalid socket.";
			if (_output && _output.length > 0) {
				try {
					this._socket && this._socket.send(this._output.__getBuffer());
					_output.endian = endian;
					_output.clear();
				} catch (e:Event) {
					//					throw "Operation attempted on invalid socket.";
				}
			}
		}
	}
}
