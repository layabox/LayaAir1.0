package
{
	import laya.display.Text;
	import laya.events.Event;
	import laya.net.Socket;
	import laya.utils.Byte;
	
	public class NetWork_Socket
	{
		private var socket:Socket;
		private var output:Byte;
		private var console:Text;
		
		public function NetWork_Socket()
		{
			Laya.init(550, 400);
			
			showConsole();
			
			socket = new Socket();
			//socket.connect("echo.websocket.org", 80);
			socket.connectByUrl("ws://echo.websocket.org:80");
			console.text += "Connecting...\n";
			
			output = socket.output;
			
			socket.on(Event.OPEN, this, onSocketOpen);
			socket.on(Event.CLOSE, this, onSocketClose);
			socket.on(Event.MESSAGE, this, onMessageReveived);
			socket.on(Event.ERROR, this, onConnectError);
		}
		
		private function onSocketOpen():void
		{
			console.text += "Connected\n";
			
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
		
		private function onSocketClose():void
		{
			console.text += "Socket closed\n";
		}
		
		private function onMessageReveived(message:*):void
		{
			console.text += "Message from server: ";
			if (message is String)
			{
				console.text += message;
			}
			else if (message is ArrayBuffer)
			{
				console.text += new Byte(message).readUTFBytes();
			}
			console.text += '\n';
		}
		
		private function onConnectError(e:Event):void
		{
			console.text += 'Error Occured.\n';
		}
		
		private function showConsole():void
		{
			console = new Text();
			console.pos(100, 100);
			console.color = "#FFFFFF";
			Laya.stage.addChild(console);
		}
	}
}