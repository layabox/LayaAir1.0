/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Stage = laya.display.Stage;
    var Text = laya.display.Text;
    var Event = laya.events.Event;
    var Browser = laya.utils.Browser;
    var WebGL = laya.webgl.WebGL;
    var Interaction_Keyboard = (function () {
        function Interaction_Keyboard() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.setup();
        }
        Interaction_Keyboard.prototype.setup = function () {
            this.listenKeyboard();
            this.createLogger();
            Laya.timer.frameLoop(1, this, this.keyboardInspector);
        };
        Interaction_Keyboard.prototype.listenKeyboard = function () {
            this.keyDownList = [];
            //添加键盘按下事件,一直按着某按键则会不断触发
            Laya.stage.on(Event.KEY_DOWN, this, this.onKeyDown);
            //添加键盘抬起事件
            Laya.stage.on(Event.KEY_UP, this, this.onKeyUp);
        };
        /**键盘按下处理*/
        Interaction_Keyboard.prototype.onKeyDown = function (e) {
            var keyCode = e["keyCode"];
            this.keyDownList[keyCode] = true;
        };
        /**键盘抬起处理*/
        Interaction_Keyboard.prototype.onKeyUp = function (e) {
            delete this.keyDownList[e["keyCode"]];
        };
        Interaction_Keyboard.prototype.keyboardInspector = function () {
            var numKeyDown = this.keyDownList.length;
            var newText = '[ ';
            for (var i = 0; i < numKeyDown; i++) {
                if (this.keyDownList[i]) {
                    newText += i + " ";
                }
            }
            newText += ']';
            this.logger.changeText(newText);
        };
        /**添加提示文本*/
        Interaction_Keyboard.prototype.createLogger = function () {
            this.logger = new Text();
            this.logger.size(Laya.stage.width, Laya.stage.height);
            this.logger.fontSize = 30;
            this.logger.font = "SimHei";
            this.logger.wordWrap = true;
            this.logger.color = "#FFFFFF";
            this.logger.align = 'center';
            this.logger.valign = 'middle';
            Laya.stage.addChild(this.logger);
        };
        return Interaction_Keyboard;
    }());
    laya.Interaction_Keyboard = Interaction_Keyboard;
})(laya || (laya = {}));
new laya.Interaction_Keyboard();
