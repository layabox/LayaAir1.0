/// <reference path="../../libs/LayaAir.d.ts" />
module texts {
    import Text = laya.display.Text;
    import Event = laya.events.Event;
    export class TextScroll {
        private txt: Text;
        private prevX: number = 0;
        private prevY: number = 0;

        constructor() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

            this.txt = new Text();
            this.txt.overflow = Text.SCROLL;

            this.txt.text =
                "Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
                "Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
                "Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
                "Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
                "Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
                "Layabox是性能最强的HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！";
            this.txt.pos(175, 150);
            this.txt.size(200, 100);

            this.txt.borderColor = "#FFFF00";

            this.txt.fontSize = 20;
            this.txt.color = "#ffffff";

            Laya.stage.addChild(this.txt);

            this.txt.on(Event.MOUSE_DOWN, this, this.startScrollText);
        }

        /* 开始滚动文本 */
        private startScrollText(e: Event): void {
            this.prevX = this.txt.mouseX;
            this.prevY = this.txt.mouseY;

            Laya.stage.on(Event.MOUSE_MOVE, this, this.scrollText);
            Laya.stage.on(Event.MOUSE_UP, this, this.finishScrollText);
        }

        /* 停止滚动文本 */
        private finishScrollText(e: Event): void {
            Laya.stage.off(Event.MOUSE_MOVE, this, this.scrollText);
            Laya.stage.off(Event.MOUSE_UP, this, this.finishScrollText);
        }

        /* 鼠标滚动文本 */
        private scrollText(e: Event): void {
            var nowX: number = this.txt.mouseX;
            var nowY: number = this.txt.mouseY;

            this.txt.scrollX += (this.prevX - nowX);
            this.txt.scrollY += (this.prevY - nowY);

            this.prevX = nowX;
            this.prevY = nowY;
        }
    }
}
new texts.TextScroll()