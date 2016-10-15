package
{
	import laya.events.Event;
	import laya.net.Socket;
	import laya.utils.Byte;
	
	public class Network_Socket
	{
		private var socket:Socket;
		private var output:Byte;
		
		public function Network_Socket()
		{
			Laya.init(550, 400);
			
			connect();
		}

		private function connect():void
		{
			socket = new Socket();
			//socket.connect("echo.websocket.org", 80);
			socket.connectByUrl("ws://echo.websocket.org:80");
			
			output = socket.output;
			
			socket.on(Event.OPEN, this, onSocketOpen);
			socket.on(Event.CLOSE, this, onSocketClose);
			socket.on(Event.MESSAGE, this, onMessageReveived);
			socket.on(Event.ERROR, this, onConnectError);
		}
		
		private function onSocketOpen(e:*=null):void
		{
			trace("Connected");
			
			// 发送字符串
			socket.send("demonstrate <sendString>");
			
			// 使用output.writeByte发送
			var message:String = "demonstrate <output.writeByte>";
			for (var i:int = 0; i < message.length; ++i)
			{
				output.writeByte(message.charCodeAt(i));
			}
			socket.flush();
		}
		
		private function onSocketClose(e:*=null):void
		{
			trace("Socket closed");
		}
		
		private function onMessageReveived(message:*=null):void
		{
			trace("Message from server:");
			if (message is String)
			{
				trace(message);
			}
			else if (message is ArrayBuffer)
			{
				trace(new Byte(message).readUTFBytes());
			}
			socket.input.clear();
		}

		private function onConnectError(e:Event=null):void
		{
			trace("error");
		}
	}
}