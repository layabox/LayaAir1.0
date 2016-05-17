package
{
	import laya.html.dom.HTMLDivElement;
	import laya.html.dom.HTMLIframeElement;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	public class Text_HTML
	{
		

		public function Text_HTML()
		{
			Laya.init(550, 400, WebGL);
			
			createParagraph();	// 代码创建
			showExternalHTML(); // 使用外部定义的html
		}

		private function createParagraph():void
		{
			var p:HTMLDivElement = new HTMLDivElement();
			Laya.stage.addChild(p);

			p.style.font = "Impact";
			p.style.fontSize = 30;

			var html:String = "<span color='#e3d26a'>使用</span>";
			html += "<span style='color:#FFFFFF;font-weight:bold'>HTMLDivElement</span>";
			html += "<span color='#6ad2e3'>创建的</span><br/>";
			html += "<span color='#d26ae3'>HTML文本</span>";
			
			p.innerHTML = html;
		}

		private function showExternalHTML():void
		{
			var p:HTMLIframeElement = new HTMLIframeElement();
			Laya.stage.addChild(p);
			p.href = "res/html/test.html";
			p.y = 100;
		}
	}
}