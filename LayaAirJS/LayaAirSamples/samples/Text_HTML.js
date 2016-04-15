var HTMLDivElement = laya.html.dom.HTMLDivElement;
var HTMLIframeElement = laya.html.dom.HTMLIframeElement;
var Handler = laya.utils.Handler;
var WebGL = laya.webgl.WebGL;

Laya.init(550, 400, WebGL);

Laya.loader.load("res/html/test.html", Handler.create(this, onAssetLoaded));

function onAssetLoaded()
{
	createParagraph();
	showExternalHTML();
}

function createParagraph()
{
	var p = new HTMLDivElement();
	Laya.stage.addChild(p);

	p.style.font = "Impact";
	p.style.fontSize = 30;

	var html = "<span color='#e3d26a'>使用</span>";
	html += "<span style='color:#FFFFFF;font-weight:bold'>HTMLDivElement</span>";
	html  += "<span color='#6ad2e3'>创建的</span><br/>";
	html += "<span color='#d26ae3'>HTML文本</span>";

	p.innerHTML = html;
}

function showExternalHTML()
{
	var p = new HTMLIframeElement();
	Laya.stage.addChild(p);
	p.href = "res/html/test.html";
	p.y = 100;
}