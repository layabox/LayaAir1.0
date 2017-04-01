module laya {
    import Stage = Laya.Stage;
    import Text = Laya.Text;
    import Event = Laya.Event;
    import Browser = Laya.Browser;
    import WebGL = Laya.WebGL;

    export class Interaction_Keyboard {
        private logger: Text;
        private keyDownList: Array<boolean>;

        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";


            this.setup();
        }

        private setup(): void {
            this.listenKeyboard();
            this.createLogger();

            Laya.timer.frameLoop(1, this, this.keyboardInspector);
        }

        private listenKeyboard(): void {
            this.keyDownList = [];

            //添加键盘按下事件,一直按着某按键则会不断触发
            Laya.stage.on(Event.KEY_DOWN, this, this.onKeyDown);
            //添加键盘抬起事件
            Laya.stage.on(Event.KEY_UP, this, this.onKeyUp);
        }

        /**键盘按下处理*/
        private onKeyDown(e: Event): void {
            var keyCode: number = e["keyCode"];
            this.keyDownList[keyCode] = true;
        }

        /**键盘抬起处理*/
        private onKeyUp(e: Event): void {
            delete this.keyDownList[e["keyCode"]];
        }

        private keyboardInspector(): void {
            var numKeyDown: number = this.keyDownList.length;

            var newText: string = '[ ';
            for (var i: number = 0; i < numKeyDown; i++) {
                if (this.keyDownList[i]) {
                    newText += i + " ";
                }
            }
            newText += ']';

            this.logger.changeText(newText);
        }

        /**添加提示文本*/
        private createLogger(): void {
            this.logger = new Text();

            this.logger.size(Laya.stage.width, Laya.stage.height);
            this.logger.fontSize = 30;
            this.logger.font = "SimHei";
            this.logger.wordWrap = true;
            this.logger.color = "#FFFFFF";
            this.logger.align = 'center';
            this.logger.valign = 'middle';

            Laya.stage.addChild(this.logger);
        }
    }
}
new laya.Interaction_Keyboard();