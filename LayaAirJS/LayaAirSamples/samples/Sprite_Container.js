// 该容器用于装载4张猩猩图片
var apesCtn;

Laya.init(500, 500);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

// 每只猩猩距离中心点150像素
var layoutRadius = 150;
var radianUnit = Math.PI / 2;
	
apesCtn = new laya.display.Sprite();
Laya.stage.addChild(apesCtn);

// 添加4张猩猩图片
for (var i = 0; i < 4; i++ )
{
	var ape = new laya.display.Sprite();
	ape.loadImage("res/apes/monkey" + i + ".png");
	
	ape.pivot(55, 72);
	
	// 以圆周排列猩猩
	ape.pos(
		Math.cos(radianUnit * i) * layoutRadius, 
		Math.sin(radianUnit * i) * layoutRadius);
	
	apesCtn.addChild(ape);
}

// 将容器移动到舞台中央
apesCtn.pos(250, 250);

Laya.timer.frameLoop(1, this, animate);

function animate(e)
{
	apesCtn.rotation += 1;
}
