package 
{
	import laya.display.Input;
	import laya.display.Text;
	import laya.net.HttpRequest;
	import laya.net.Socket;
	import laya.net.URL;
	public class Net_Socket 
	{
		private var textArea:Text;
		private var messageInput:Input;
		private var sendBtn:Text;
		private var socket:Socket;
		
		public function Net_Socket() 
		{
			Laya.init(550, 400);
			initUI();
			
			var timestamp:int = new Date().getTime();
			var httpReq:HttpRequest = new HttpRequest();
			httpReq.send("http://hichat.herokuapp.com:80/socket.io/1/?" + timestamp, null, "get");
			httpReq.on("complete", this, onReqestComplete);
			
			textArea.text += "Connecting...\n";
		}
		
		private function initUI():void 
		{
			textArea = new Text();
			Laya.stage.addChild(textArea);
			textArea.size(Laya.stage.width, Laya.stage.height);
			textArea.color = "#FFFFFF";
			
			messageInput = new Input();
			Laya.stage.addChild(messageInput);
			messageInput.size(Laya.stage.width - 106, 20);
			messageInput.borderColor = "#FFFF00";
			messageInput.pos(3, Laya.stage.height - 23);
			messageInput.color = "#FFFFFF";
			
			sendBtn = new Text();
			Laya.stage.addChild(sendBtn);
			sendBtn.text = "Send";
			sendBtn.color = '#FFFFFF';
			sendBtn.fontSize = 20;
			sendBtn.pos(Laya.stage.width - 80, Laya.stage.height - 25);
			sendBtn.on("click", this, sendMessage);
		}
		
		private function onReqestComplete(response:String):void 
		{
			var data:String = response.split(":")[0];
			
			socket = new Socket();
			socket.connect("ws://hichat.herokuapp.com:80/socket.io/1/websocket/" + data);
			socket.on("open", this, onConnted);
			socket.on("message", this, onMessageReceive);
			socket.on("close", this, onClose);
			socket.on("error", this, onError);
		}
		
		private function onConnted():void 
		{
			textArea.text += "Connected.\n";
		}
		
		private function onMessageReceive(msg:String):void
		{
			textArea.text += ("receive:" + msg + "\n");
			trace(msg);
		}
		
		private function onClose():void
		{
			trace("close");
		}
		
		private function onError():void
		{
			trace("error",arguments);
		}
		
		private function sendMessage():void
		{
			var msg:String = messageInput.text;
			socket.sendString('2:::{"name":"postMsg","args":["' + msg + '","#000000"]}');
			textArea.text += msg + "\n";
		}
	}

}