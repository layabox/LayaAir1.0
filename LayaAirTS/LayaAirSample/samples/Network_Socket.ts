/// <reference path="../../libs/LayaAir.d.ts" />
module laya
{
	import Text = laya.display.Text;
	import Event = laya.events.Event;
	import Socket = laya.net.Socket;
	import Byte = laya.utils.Byte;
	
	export class NetWork_Socket
	{
		private socket:Socket;
		private output:Byte;
		private console:Text;
		
		constructor()
		{
			Laya.init(550, 400);
			
			this.showConsole();
			
			this.socket = new Socket();
			//this.socket.connect("echo.websocket.org", 80);
			this.socket.connectByUrl("ws://echo.websocket.org:80");
			this.console.text += "Connecting...\n";
			
			this.output = this.socket.output;
			
			this.socket.on(Event.OPEN, this, this.onSocketOpen);
			this.socket.on(Event.CLOSE, this, this.onSocketClose);
			this.socket.on(Event.MESSAGE, this, this.onMessageReveived);
			this.socket.on(Event.ERROR, this, this.onConnectError);
		}
		
		private onSocketOpen():void 
		{
			this.console.text += "Connected\n";

			// 发送字符串
			this.socket.send("demonstrate <sendString>");

			// 使用output.writeByte发送
			var message: String = "demonstrate <output.writeByte>\n";
			for (var i: number = 0; i < message.length; ++i) {
				this.output.writeByte(message.charCodeAt(i));
			}
			this.socket.flush();
		}
		
		private onSocketClose():void
		{
			this.console.text += "Socket closed\n";
		}
		
		private onMessageReveived(message:any):void
		{
			this.console.text += "Message from server: ";
			if (typeof message == "string")
			{
				this.console.text += message;
			}
			else if (message instanceof ArrayBuffer)
			{
				this.console.text += new Byte(message).readUTFBytes();
			}
			this.console.text += '\n';
		}
		
		private onConnectError(e:Event):void
		{
			this.console.text += 'Error Occured.\n';
		}
		
		private showConsole():void
		{
			this.console = new Text();
			this.console.pos(100, 100);
			this.console.color = "#FFFFFF";
			Laya.stage.addChild(this.console);
		}
	}
}
new laya.NetWork_Socket();