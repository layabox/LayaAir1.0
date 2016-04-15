/// <reference path="../../libs/LayaAir.d.ts" />
module sprites {
    import Sprite = laya.display.Sprite;
    import Event = laya.events.Event;
    import Rectangle = laya.maths.Rectangle;
    import WebGL = laya.webgl.WebGL;

    export class SpriteDrag {
        private ape:Sprite;
        private dragRect:Rectangle;

        constructor() {
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
            Laya.stage.graphics.drawRect(
                this.dragRect.x, this.dragRect.y, this.dragRect.width, this.dragRect.height,
                null, "#FFFFFF", 5);

            this.ape.on(Event.MOUSE_DOWN, this, this.onStartDrag);
        }

        private onStartDrag(e:Event):void {
            //鼠标按下开始拖拽(设置了拖动区域和超界弹回的滑动效果)
            this.ape.startDrag(this.dragRect, true, 100);
        }
    }
}
new sprites.SpriteDrag()