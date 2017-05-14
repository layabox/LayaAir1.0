package 
{
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	public class Network_ProtocolBuffer 
	{
		private var ProtoBuf:* = Browser.window.protobuf;
		
		public function Network_ProtocolBuffer() 
		{
			Laya.init(550, 400);
			
			ProtoBuf.load("../../../../res/protobuf/awesome.proto", onAssetsLoaded);
		}
		
		private function onAssetsLoaded(err:*, root:*):void
		{
			if (err)
				throw err;

			// Obtain a message type
			var AwesomeMessage:* = root.lookup("awesomepackage.AwesomeMessage");

			// Create a new message
			var message:* = AwesomeMessage.create(
			{
				awesomeField: "AwesomeString"
			});

			// Verify the message if necessary (i.e. when possibly incomplete or invalid)
			var errMsg:* = AwesomeMessage.verify(message);
			if (errMsg)
				throw Error(errMsg);

			// Encode a message to an Uint8Array (browser) or Buffer (node)
			var buffer:* = AwesomeMessage.encode(message).finish();
			// ... do something with buffer

			// Or, encode a plain object
			var buffer:* = AwesomeMessage.encode(
			{
				awesomeField: "AwesomeString"
			}).finish();
			// ... do something with buffer

			// Decode an Uint8Array (browser) or Buffer (node) to a message
			var message:* = AwesomeMessage.decode(buffer);
			// ... do something with message

			// If your application uses length-delimited buffers, there is also encodeDelimited and decodeDelimited.
		}
	}
}