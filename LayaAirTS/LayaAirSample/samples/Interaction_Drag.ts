/// <reference path="../../libs/LayaAir.d.ts" />
class Drag {
    private  rect:laya.display.Sprite;
    constructor() {
        Laya.init(550, 400);
        Laya.stage.bgColor = "#ffeecc";
        Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

        this.rect = new laya.display.Sprite();
        this.rect.graphics.drawRect(0, 0, 100, 100, "#00eeff");
        this.rect.pos(200, 80);
        this.rect.size(100, 100);

        this.rect.on(laya.events.Event.MOUSE_DOWN, this, this.onMouseDown);

        Laya.stage.addChild(this.rect);
    }

    private  onMouseDown(e:Event):void {
        this.rect.startDrag();
    }
}

new Drag();