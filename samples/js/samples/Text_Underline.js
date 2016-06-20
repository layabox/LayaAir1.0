(function()
{

	var Stage = Laya.Stage;
	var Text = Laya.Text;
	var WebGL = Laya.WebGL;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(600, 400, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
		Laya.stage.bgColor = "#232628";

		createTexts();
	})();

	function createTexts()
	{
		createText('left', 1, null, 100, 10);
		createText('center', 2, "#00BFFF", 155, 150);
		createText('right', 3, "#FF7F50", 210, 290);
	}

	function createText(align, underlineWidth, underlineColor, x, y)
	{
		var txt = new Text();
		txt.text = "Layabox\n是HTML5引擎技术提供商\n与优秀的游戏发行商\n面向AS/JS/TS开发者提供HTML5开发技术方案";

		txt.size(300, 50);
		txt.fontSize = 20;
		txt.color = "#ffffff";
		txt.align = align;

		// 设置下划线
		txt.underline = true;
		txt.underlineColor = underlineColor;

		txt.pos(x, y);

		Laya.stage.addChild(txt);

		return txt;
	}
})();