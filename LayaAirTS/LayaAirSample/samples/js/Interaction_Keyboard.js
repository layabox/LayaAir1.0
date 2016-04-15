/// <reference path="../../libs/LayaAir.d.ts" />
var mouses;
(function (mouses) {
    var KeyBoardInteraction = (function () {
        function KeyBoardInteraction() {
            Laya.init(550, 400);
            Laya.stage.bgColor = "#ffeecc";
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            this.keyDownList = [];
            //添加键盘按下事件,一直按着某按键则会不断触发
            Laya.stage.on(laya.events.Event.KEY_DOWN, this, this.onKeyDown);
            //添加键盘抬起事件
            Laya.stage.on(laya.events.Event.KEY_UP, this, this.onKeyUp);
            Laya.timer.frameLoop(1, this, this.keyboardInspector);
            //添加提示文本
            this.createTxt();
        }
        /**键盘按下处理*/
        KeyBoardInteraction.prototype.onKeyDown = function (e) {
            this.keyDownList[e["keyCode"]] = true;
        };
        /**键盘抬起处理*/
        KeyBoardInteraction.prototype.onKeyUp = function (e) {
            delete this.keyDownList[e["keyCode"]];
        };
        KeyBoardInteraction.prototype.keyboardInspector = function () {
            var numKeyDown = this.keyDownList.length;
            this.txt.text = "按下了下列键\n";
            for (var i = 0; i < numKeyDown; i++) {
                if (this.keyDownList[i]) {
                    this.txt.text += i + " ";
                }
            }
        };
        /**添加提示文本*/
        KeyBoardInteraction.prototype.createTxt = function () {
            this.txt = new laya.display.Text();
            this.txt.size(550, 300);
            this.txt.fontSize = 20;
            this.txt.font = "SimHei";
            this.txt.wordWrap = true;
            this.txt.color = "#000000";
            this.txt.align = 'center';
            this.txt.pos(0, 150);
            Laya.stage.addChild(this.txt);
        };
        return KeyBoardInteraction;
    }());
    mouses.KeyBoardInteraction = KeyBoardInteraction;
})(mouses || (mouses = {}));
new mouses.KeyBoardInteraction();
