var laya;
(function (laya) {
    var Stage = Laya.Stage;
    var Text = Laya.Text;
    var Browser = Laya.Browser;
    var WebGL = Laya.WebGL;
    var Text_WordWrap = (function () {
        function Text_WordWrap() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            this.createText();
        }
        Text_WordWrap.prototype.createText = function () {
            var txt = new Text();
            txt.text = "Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！";
            txt.width = 300;
            txt.fontSize = 40;
            txt.color = "#ffffff";
            //设置文本为多行文本
            txt.wordWrap = true;
            txt.x = Laya.stage.width - txt.textWidth >> 1;
            txt.y = Laya.stage.height - txt.textHeight >> 1;
            Laya.stage.addChild(txt);
        };
        return Text_WordWrap;
    }());
    laya.Text_WordWrap = Text_WordWrap;
})(laya || (laya = {}));
new laya.Text_WordWrap();
