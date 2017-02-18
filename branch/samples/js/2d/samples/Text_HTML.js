(function()
{
	var Stage             = Laya.Stage;
	var HTMLDivElement    = Laya.HTMLDivElement;
	var HTMLIframeElement = Laya.HTMLIframeElement;
	var Browser           = Laya.Browser;
	var WebGL             = Laya.WebGL;

	(function()
	{
		// 不支持WebGL时自动切换至Canvas
		Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

		Laya.stage.alignV = Stage.ALIGN_MIDDLE;
		Laya.stage.alignH = Stage.ALIGN_CENTER;

		Laya.stage.scaleMode = "showall";
		Laya.stage.bgColor = "#232628";

		setup();
	})();

	function setup()
	{
		createParagraph(); // 代码创建
		showExternalHTML(); // 使用外部定义的html
	}

	function createParagraph()
	{
		var p = new HTMLDivElement();
		Laya.stage.addChild(p);

		p.style.font = "Impact";
		p.style.fontSize = 30;

		var html = "<span color='#e3d26a'>使用</span>";
		html += "<span style='color:#FFFFFF;font-weight:bold'>HTMLDivElement</span>";
		html += "<span color='#6ad2e3'>创建的</span><br/>";
		html += "<span color='#d26ae3'>HTML文本</span>";

		p.innerHTML = html;
	}

	function showExternalHTML()
	{
		var p = new HTMLIframeElement();
		Laya.stage.addChild(p);
		p.href = "../../res/html/test.html";
		p.y = 200;
	}
})();