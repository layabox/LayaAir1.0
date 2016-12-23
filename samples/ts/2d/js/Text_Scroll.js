var laya;
(function (laya) {
    var Stage = Laya.Stage;
    var Text = Laya.Text;
    var Event = Laya.Event;
    var Browser = Laya.Browser;
    var WebGL = Laya.WebGL;
    var Text_Scroll = (function () {
        function Text_Scroll() {
            this.prevX = 0;
            this.prevY = 0;
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            this.createText();
        }
        Text_Scroll.prototype.createText = function () {
            this.txt = new Text();
            this.txt.overflow = Text.SCROLL;
            this.txt.text =
                "Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
                    "Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
                    "Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
                    "Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
                    "Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
                    "Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！";
            this.txt.size(200, 100);
            this.txt.x = Laya.stage.width - this.txt.width >> 1;
            this.txt.y = Laya.stage.height - this.txt.height >> 1;
            this.txt.borderColor = "#FFFF00";
            this.txt.fontSize = 20;
            this.txt.color = "#ffffff";
            Laya.stage.addChild(this.txt);
            this.txt.on(Event.MOUSE_DOWN, this, this.startScrollText);
        };
        /* 开始滚动文本 */
        Text_Scroll.prototype.startScrollText = function (e) {
            this.prevX = this.txt.mouseX;
            this.prevY = this.txt.mouseY;
            Laya.stage.on(Event.MOUSE_MOVE, this, this.scrollText);
            Laya.stage.on(Event.MOUSE_UP, this, this.finishScrollText);
        };
        /* 停止滚动文本 */
        Text_Scroll.prototype.finishScrollText = function (e) {
            Laya.stage.off(Event.MOUSE_MOVE, this, this.scrollText);
            Laya.stage.off(Event.MOUSE_UP, this, this.finishScrollText);
        };
        /* 鼠标滚动文本 */
        Text_Scroll.prototype.scrollText = function (e) {
            var nowX = this.txt.mouseX;
            var nowY = this.txt.mouseY;
            this.txt.scrollX += this.prevX - nowX;
            this.txt.scrollY += this.prevY - nowY;
            this.prevX = nowX;
            this.prevY = nowY;
        };
        return Text_Scroll;
    }());
    laya.Text_Scroll = Text_Scroll;
})(laya || (laya = {}));
new laya.Text_Scroll();
