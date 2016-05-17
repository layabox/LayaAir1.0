(function()
{
	var Text = Laya.Text;
	var Event = Laya.Event;
	var Socket = Laya.Socket;
	var Byte = Laya.Byte;

	var socket;
	var output;
	var console;

	Laya.init(550, 400);

	showConsole();

	socket = new Socket();
	// socket.connect("echo.websocket.org", 80);
	socket.connectByUrl("ws://echo.websocket.org:80");
	console.text += "Connecting...\n";

	output = socket.output;

	socket.on(Event.OPEN, this, onSocketOpen);
	socket.on(Event.CLOSE, this, onSocketClose);
	socket.on(Event.MESSAGE, this, onMessageReveived);
	socket.on(Event.ERROR, this, onConnectError);

	function onSocketOpen()
	{
		console.text += "Connected\n";
		
		// 发送字符串
		socket.send("demonstrate <sendString>");

		// 使用output.writeByte发送
		var message = "demonstrate <output.writeByte>\n";
		for (var i = 0; i < message.length; ++i)
		{
			output.writeByte(message.charCodeAt(i));
		}
		socket.flush();
	}

	function onSocketClose()
	{
		console.text += "Socket closed\n";
	}

	function onMessageReveived(message)
	{
		console.text += "Message from server: " + message + '\n';
	}

	function onConnectError(e)
	{
		console.text += 'Error Occured.\n';
	}

	function showConsole()
	{
		console = new Text();
		console.pos(100, 100);
		console.color = "#FFFFFF";
		Laya.stage.addChild(console);
	}
})();