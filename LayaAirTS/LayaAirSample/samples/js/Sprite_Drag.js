/// <reference path="../../libs/LayaAir.d.ts" />
var sprites;
(function (sprites) {
    var Sprite = laya.display.Sprite;
    var Event = laya.events.Event;
    var Rectangle = laya.maths.Rectangle;
    var SpriteDrag = (function () {
        function SpriteDrag() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            this.ape = new Sprite();
            this.ape.loadImage("res/apes/monkey2.png");
            Laya.stage.addChild(this.ape);
            this.ape.x = 275;
            this.ape.y = 200;
            this.ape.pivot(55, 72);
            //拖动限制区域
            this.dragRect = new Rectangle(100, 100, 350, 200);
            //画出拖动限制区域
            Laya.stage.graphics.drawRect(this.dragRect.x, this.dragRect.y, this.dragRect.width, this.dragRect.height, null, "#FFFFFF", 5);
            this.ape.on(Event.MOUSE_DOWN, this, this.onStartDrag);
        }
        SpriteDrag.prototype.onStartDrag = function (e) {
            //鼠标按下开始拖拽(设置了拖动区域和超界弹回的滑动效果)
            this.ape.startDrag(this.dragRect, true, 100);
        };
        return SpriteDrag;
    }());
    sprites.SpriteDrag = SpriteDrag;
})(sprites || (sprites = {}));
new sprites.SpriteDrag();
