var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Text = Laya.Text;
    var Shake = Laya.Shake;
    var Browser = Laya.Browser;
    var Event = Laya.Event;
    var InputDevice_Shake = (function () {
        function InputDevice_Shake() {
            this.picW = 484;
            this.picH = 484;
            this.shakeCount = 0;
            Laya.init(this.picW, Browser.height * this.picW / Browser.width);
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            this.showShakePic();
            this.showConsoleText();
            this.startShake();
        }
        InputDevice_Shake.prototype.showShakePic = function () {
            var shakePic = new Sprite();
            shakePic.loadImage("../../res/inputDevice/shake.png");
            Laya.stage.addChild(shakePic);
        };
        InputDevice_Shake.prototype.showConsoleText = function () {
            this.console = new Text();
            Laya.stage.addChild(this.console);
            this.console.y = this.picH + 10;
            this.console.width = Laya.stage.width;
            this.console.height = Laya.stage.height - this.console.y;
            this.console.color = "#FFFFFF";
            this.console.fontSize = 50;
            this.console.align = "center";
            this.console.valign = 'middle';
            this.console.leading = 10;
        };
        InputDevice_Shake.prototype.startShake = function () {
            Shake.instance.start(5, 500);
            Shake.instance.on(Event.CHANGE, this, this.callback);
            this.console.text = '开始接收设备摇动\n';
        };
        InputDevice_Shake.prototype.callback = function () {
            this.shakeCount++;
            this.console.text += "设备摇晃了" + this.shakeCount + "次\n";
            if (this.shakeCount >= 3) {
                Shake.instance.stop();
                this.console.text += "停止接收设备摇动";
            }
        };
        return InputDevice_Shake;
    }());
    laya.InputDevice_Shake = InputDevice_Shake;
})(laya || (laya = {}));
new laya.InputDevice_Shake();
