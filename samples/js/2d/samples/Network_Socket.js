(function()
{
	var Event  = Laya.Event;
	var Socket = Laya.Socket;
	var Byte   = Laya.Byte;

	var socket;
	var output;

	(function()
	{
		Laya.init(550, 400);

		connect();
	})();

	function connect()
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

	function onSocketOpen()
	{
		console.log("Connected");

		// 发送字符串
		socket.send("demonstrate <sendString>");

		// 使用output.writeByte发送
		var message = "demonstrate <output.writeByte>";
		for (var i = 0; i < message.length; ++i)
		{
			output.writeByte(message.charCodeAt(i));
		}
		socket.flush();
	}

	function onSocketClose()
	{
		console.log("Socket closed");
	}

	function onMessageReveived(message)
	{
		console.log("Message from server:");
		if (typeof message == "string")
		{
			console.log(message);
		}
		else if (message instanceof ArrayBuffer)
		{
			console.log(new Byte(message).readUTFBytes());
		}
		socket.input.clear();
	}

	function onConnectError(e)
	{
		console.log("error");
	}
})();