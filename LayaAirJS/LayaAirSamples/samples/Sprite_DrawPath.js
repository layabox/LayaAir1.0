Laya.init(550, 400);

var canvas = new laya.display.Sprite();
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
Laya.stage.addChild(canvas);

var path = [];
path.push(["moveTo", 0, -130]);
path.push(["lineTo", 33, -33 ]);
path.push(["lineTo", 137, -30]);
path.push(["lineTo", 55, 32]);
path.push(["lineTo", 85, 130]);
path.push(["lineTo", 0, 73]);
path.push(["lineTo", -85, 130]);
path.push(["lineTo", -55, 32]);
path.push(["lineTo", -137, -30]);
path.push(["lineTo", -33, -33 ]);
path.push(["lineTo", 0, -130]);
path.push(["closePath"]);

canvas.graphics.drawPath(275, 200, path, {fillStyle: "#00ffff"});
