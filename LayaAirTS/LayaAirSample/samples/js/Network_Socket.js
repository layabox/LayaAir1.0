/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Text = laya.display.Text;
    var Event = laya.events.Event;
    var Socket = laya.net.Socket;
    var Byte = laya.utils.Byte;
    var NetWork_Socket = (function () {
        function NetWork_Socket() {
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
        NetWork_Socket.prototype.onSocketOpen = function () {
            this.console.text += "Connected\n";
            // 发送字符串
            this.socket.send("demonstrate <sendString>");
            this.socket.flush();
            // 使用output.writeByte发送
            var message = "demonstrate <output.writeByte>\n";
            for (var i = 0; i < message.length; ++i) {
                this.output.writeByte(message.charCodeAt(i));
            }
            this.socket.flush();
        };
        NetWork_Socket.prototype.onSocketClose = function () {
            this.console.text += "Socket closed\n";
        };
        NetWork_Socket.prototype.onMessageReveived = function (message) {
            this.console.text += "Message from server: ";
            if (typeof message == "string") {
                this.console.text += message;
            }
            else if (message instanceof ArrayBuffer) {
                this.console.text += new Byte(message).readUTFBytes();
            }
            this.console.text += '\n';
        };
        NetWork_Socket.prototype.onConnectError = function (e) {
            this.console.text += 'Error Occured.\n';
        };
        NetWork_Socket.prototype.showConsole = function () {
            this.console = new Text();
            this.console.pos(100, 100);
            this.console.color = "#FFFFFF";
            Laya.stage.addChild(this.console);
        };
        return NetWork_Socket;
    }());
    laya.NetWork_Socket = NetWork_Socket;
})(laya || (laya = {}));
new laya.NetWork_Socket();
