Laya.init(550, 400);
Laya.stage.scaleMode = Laya.Stage.SCALE_NOBORDER;

var rect = new Laya.Sprite();
rect.graphics.drawRect(-100, -100, 200, 200, "gray");
Laya.stage.addChild(rect);

rect.x = Laya.stage.width / 2;
rect.y = Laya.stage.height / 2;