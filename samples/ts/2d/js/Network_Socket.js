var laya;
(function (laya) {
    var Event = Laya.Event;
    var Socket = Laya.Socket;
    var Byte = Laya.Byte;
    var NetWork_Socket = (function () {
        function NetWork_Socket() {
            Laya.init(550, 400);
            this.connect();
        }
        NetWork_Socket.prototype.connect = function () {
            this.socket = new Socket();
            //this.socket.connect("echo.websocket.org", 80);
            this.socket.connectByUrl("ws://echo.websocket.org:80");
            this.output = this.socket.output;
            this.socket.on(Event.OPEN, this, this.onSocketOpen);
            this.socket.on(Event.CLOSE, this, this.onSocketClose);
            this.socket.on(Event.MESSAGE, this, this.onMessageReveived);
            this.socket.on(Event.ERROR, this, this.onConnectError);
        };
        NetWork_Socket.prototype.onSocketOpen = function () {
            console.log("Connected");
            // 发送字符串
            this.socket.send("demonstrate <sendString>");
            // 使用output.writeByte发送
            var message = "demonstrate <output.writeByte>";
            for (var i = 0; i < message.length; ++i) {
                this.output.writeByte(message.charCodeAt(i));
            }
            this.socket.flush();
        };
        NetWork_Socket.prototype.onSocketClose = function () {
            console.log("Socket closed");
        };
        NetWork_Socket.prototype.onMessageReveived = function (message) {
            console.log("Message from server:");
            if (typeof message == "string") {
                console.log(message);
            }
            else if (message instanceof ArrayBuffer) {
                console.log(new Byte(message).readUTFBytes());
            }
            this.socket.input.clear();
        };
        NetWork_Socket.prototype.onConnectError = function (e) {
            console.log("error");
        };
        return NetWork_Socket;
    }());
    laya.NetWork_Socket = NetWork_Socket;
})(laya || (laya = {}));
new laya.NetWork_Socket();
