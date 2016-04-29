/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var HTMLDivElement = laya.html.dom.HTMLDivElement;
    var HTMLIframeElement = laya.html.dom.HTMLIframeElement;
    var WebGL = laya.webgl.WebGL;
    var Text_HTML = (function () {
        function Text_HTML() {
            Laya.init(550, 400, WebGL);
            this.createParagraph(); // 代码创建
            this.showExternalHTML(); // 使用外部定义的html
        }
        Text_HTML.prototype.createParagraph = function () {
            var p = new HTMLDivElement();
            Laya.stage.addChild(p);
            p.style.font = "Impact";
            p.style.fontSize = 30;
            var html = "<span color='#e3d26a'>使用</span>";
            html += "<span style='color:#FFFFFF;font-weight:bold'>HTMLDivElement</span>";
            html += "<span color='#6ad2e3'>创建的</span><br/>";
            html += "<span color='#d26ae3'>HTML文本</span>";
            p.innerHTML = html;
        };
        Text_HTML.prototype.showExternalHTML = function () {
            var p = new HTMLIframeElement();
            Laya.stage.addChild(p);
            p.href = "res/html/test.html";
            p.y = 100;
        };
        return Text_HTML;
    }());
    laya.Text_HTML = Text_HTML;
})(laya || (laya = {}));
new laya.Text_HTML();
