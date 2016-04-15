/// <reference path="../../libs/LayaAir.d.ts" />
var mouses;
(function (mouses) {
    var CustomEventExample = (function () {
        function CustomEventExample() {
            Laya.init(550, 400);
            Laya.stage.bgColor = "#ffeecc";
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            this.sp = new laya.display.Sprite();
            //给sp增加一个自定义的事件侦听
            this.sp.on(mouses.CustomEventExample.MY_EVENT, this, this.onCustomTest);
            //添加信息文本
            this.createTxt();
            //添加一个触发方块
            this.createRect();
        }
        /**自定义事件侦听的回调方法*/
        CustomEventExample.prototype.onCustomTest = function (param1, param2) {
            this.txt.text = "sp收到自定义事件携带参数为：\n 参数1:" + param1 + "\n 参数2:" + param2;
        };
        /**添加文本*/
        CustomEventExample.prototype.createTxt = function () {
            this.txt = new laya.display.Text();
            this.txt.text = "点击蓝色方块触发自定义事件";
            this.txt.fontSize = 20;
            this.txt.color = "#000000";
            Laya.stage.addChild(this.txt);
        };
        /**添加一个显示对象*/
        CustomEventExample.prototype.createRect = function () {
            var rect = new laya.display.Sprite();
            rect.graphics.drawRect(0, 0, 100, 100, "#00eeff");
            rect.pos(225, 150);
            rect.size(100, 100);
            rect.on(laya.events.Event.MOUSE_DOWN, this, this.onDown);
            Laya.stage.addChild(rect);
        };
        /**按下处理*/
        CustomEventExample.prototype.onDown = function (e) {
            //发送自定义事件
            this.sp.event(mouses.CustomEventExample.MY_EVENT, ["我是自定义事件！", "my customize event."]);
        };
        CustomEventExample.MY_EVENT = "myEvent";
        return CustomEventExample;
    }());
    mouses.CustomEventExample = CustomEventExample;
})(mouses || (mouses = {}));
new mouses.CustomEventExample();
