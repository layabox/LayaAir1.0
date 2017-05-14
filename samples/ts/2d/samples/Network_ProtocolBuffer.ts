module laya
{
	import Loader = Laya.Loader;
	import Browser = Laya.Browser;
	import Handler = Laya.Handler;
	
	export class Network_ProtocolBuffer 
	{
		private ProtoBuf:any = Browser.window.protobuf;
		
		constructor()
		{
			Laya.init(550, 400);
			
			this.ProtoBuf.load("../../res/protobuf/user.proto", this.onAssetsLoaded);
		}
		
		private onAssetsLoaded(err:any, root:any):void
		{
			if (err)
				throw err;

			// Obtain a message type
			var AwesomeMessage:any = root.lookup("awesomepackage.AwesomeMessage");

			// Create a new message
			var message:any = AwesomeMessage.create(
			{
				awesomeField: "AwesomeString"
			});

			// Verify the message if necessary (i.e. when possibly incomplete or invalid)
			var errMsg:any = AwesomeMessage.verify(message);
			if (errMsg)
				throw Error(errMsg);

			// Encode a message to an Uint8Array (browser) or Buffer (node)
			var buffer:any = AwesomeMessage.encode(message).finish();
			// ... do something with buffer

			// Or, encode a plain object
			var buffer:any = AwesomeMessage.encode(
			{
				awesomeField: "AwesomeString"
			}).finish();
			// ... do something with buffer

			// Decode an Uint8Array (browser) or Buffer (node) to a message
			var message:any = AwesomeMessage.decode(buffer);
			// ... do something with message

			// If your application uses length-delimited buffers, there is also encodeDelimited and decodeDelimited.
		}
	}
}
new laya.Network_ProtocolBuffer();