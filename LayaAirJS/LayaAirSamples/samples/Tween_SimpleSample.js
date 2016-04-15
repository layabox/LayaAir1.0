Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
			
var terminalX = 200;

var characterA = createCharacter("res/cartoonCharacters/1.png");
characterA.pivot(46.5, 50);
characterA.y = 100;

var characterB = createCharacter("res/cartoonCharacters/2.png");
characterB.pivot(34, 50);
characterB.y = 250;

Laya.stage.graphics.drawLine(terminalX, 0, terminalX, Laya.stage.height, "#FFFFFF");

// characterA使用Tween.to缓动
laya.utils.Tween.to(characterA, { x : terminalX }, 1000);
// characterB使用Tween.from缓动
characterB.x = terminalX;
laya.utils.Tween.from(characterB, { x:0 }, 1000);

function createCharacter(skin)
{
	var character = new laya.display.Sprite();
	character.loadImage(skin);
	Laya.stage.addChild(character);

	return character;
}