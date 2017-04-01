(function()
{
	var Loader = Laya.Loader;
	var Browser = Laya.Browser;
	var Handler = Laya.Handler;

	var ProtoBuf = Browser.window.protobuf;

	Laya.init(550, 400);

	ProtoBuf.load("../../res/protobuf/awesome.proto", onAssetsLoaded);

	function onAssetsLoaded(err, root)
	{
		if (err)
			throw err;

		// Obtain a message type
		var AwesomeMessage = root.lookup("awesomepackage.AwesomeMessage");

		// Create a new message
		var message = AwesomeMessage.create(
		{
			awesomeField: "AwesomeString"
		});

		// Verify the message if necessary (i.e. when possibly incomplete or invalid)
		var errMsg = AwesomeMessage.verify(message);
		if (errMsg)
			throw Error(errMsg);

		// Encode a message to an Uint8Array (browser) or Buffer (node)
		var buffer = AwesomeMessage.encode(message).finish();
		// ... do something with buffer

		// Or, encode a plain object
		var buffer = AwesomeMessage.encode(
		{
			awesomeField: "AwesomeString"
		}).finish();
		// ... do something with buffer

		// Decode an Uint8Array (browser) or Buffer (node) to a message
		var message = AwesomeMessage.decode(buffer);
		// ... do something with message

		// If your application uses length-delimited buffers, there is also encodeDelimited and decodeDelimited.
	}
})();