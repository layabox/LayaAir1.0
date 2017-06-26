var laya;
(function (laya) {
    var Browser = Laya.Browser;
    var Network_ProtocolBuffer = (function () {
        function Network_ProtocolBuffer() {
            this.ProtoBuf = Browser.window.protobuf;
            Laya.init(550, 400);
            this.ProtoBuf.load("../../res/protobuf/user.proto", this.onAssetsLoaded);
        }
        Network_ProtocolBuffer.prototype.onAssetsLoaded = function (err, root) {
            if (err)
                throw err;
            // Obtain a message type
            var AwesomeMessage = root.lookup("awesomepackage.AwesomeMessage");
            // Create a new message
            var message = AwesomeMessage.create({
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
            var buffer = AwesomeMessage.encode({
                awesomeField: "AwesomeString"
            }).finish();
            // ... do something with buffer
            // Decode an Uint8Array (browser) or Buffer (node) to a message
            var message = AwesomeMessage.decode(buffer);
            // ... do something with message
            // If your application uses length-delimited buffers, there is also encodeDelimited and decodeDelimited.
        };
        return Network_ProtocolBuffer;
    }());
    laya.Network_ProtocolBuffer = Network_ProtocolBuffer;
})(laya || (laya = {}));
new laya.Network_ProtocolBuffer();
