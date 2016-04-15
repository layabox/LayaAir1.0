Laya.init(laya.utils.Browser.width, laya.utils.Browser.height);

Laya.stage.sizeMode = laya.display.Stage.SIZE_FULL_HEIGHT;

var rect = new laya.display.Sprite();
rect.graphics.drawRect(-100, -100, 200, 200, "gray");
Laya.stage.addChild(rect);

updateRectPos();
Laya.stage.on("resize", this, updateRectPos);

function updateRectPos()
{
	rect.x = laya.utils.Browser.clientWidth / 2;
	rect.y = laya.utils.Browser.clientHeight / 2;
}