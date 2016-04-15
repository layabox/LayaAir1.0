Laya.init(550, 400);
Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

var demoString = "LayaBox";

for (var i = 0, len = demoString.length; i < len; ++i)
{
	var letterText = createLetter(demoString.charAt(i));
	letterText.x = 400 / len * i + 50;
	
	laya.utils.Tween.to(letterText, { y : 200 }, 1000, laya.utils.Ease.elasticOut, null, i * 1000);
}

function createLetter(char)
{
	var letter = new laya.display.Text();
	letter.text = char;
	letter.color = "#FFFFFF";
	letter.font = "Impact";
	letter.fontSize = 110;
	Laya.stage.addChild(letter);
	
	return letter;
}