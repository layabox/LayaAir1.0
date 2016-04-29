Laya.init(550, 400);

var canvas = new Laya.Sprite();
Laya.stage.scaleMode = Laya.Stage.SCALE_SHOWALL;
Laya.stage.addChild(canvas);

var path = [];
path.push(0, -130);
path.push(33, -33 );
path.push(137, -30);
path.push(55, 32);
path.push(85, 130);
path.push(0, 73);
path.push(-85, 130);
path.push(-55, 32);
path.push(-137, -30);
path.push(-33, -33 );

canvas.graphics.drawPoly(275, 200, path, "#00ffff");
