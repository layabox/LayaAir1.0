/// <reference path="../../libs/LayaAir.d.ts" />
module mouses {
    export class MouseInteraction {
        private txt:laya.display.Text;

        constructor() {
            Laya.init(550, 400);
            Laya.stage.bgColor = "#ffeecc";
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

            var rect:laya.display.Sprite = new laya.display.Sprite();
            rect.graphics.drawRect(0, 0, 100, 100, "#00eeff");
            rect.pos(250, 170);
            rect.size(100, 100);
            Laya.stage.addChild(rect);

            //增加鼠标事件
            rect.on(laya.events.Event.MOUSE_DOWN, this, this.mouseHandler);
            rect.on(laya.events.Event.MOUSE_UP, this, this.mouseHandler);
            rect.on(laya.events.Event.CLICK, this, this.mouseHandler);
            rect.on(laya.events.Event.RIGHT_MOUSE_DOWN, this, this.mouseHandler);
            rect.on(laya.events.Event.RIGHT_MOUSE_UP, this, this.mouseHandler);
            rect.on(laya.events.Event.RIGHT_CLICK, this, this.mouseHandler);
            rect.on(laya.events.Event.MOUSE_MOVE, this, this.mouseHandler);
            rect.on(laya.events.Event.MOUSE_OVER, this, this.mouseHandler);
            rect.on(laya.events.Event.MOUSE_OUT, this, this.mouseHandler);
            rect.on(laya.events.Event.DOUBLE_CLICK, this, this.mouseHandler);
            rect.on(laya.events.Event.MOUSE_WHEEL, this, this.mouseHandler);

            //添加提示文本
            this.createTxt();
        }

        /**
         * 鼠标响应事件处理
         */
        private mouseHandler(e:laya.events.Event):void {
            switch (e.type) {
                case laya.events.Event.MOUSE_DOWN:
                    this.appendText("\n————————\n左键按下");
                    break;
                case laya.events.Event.MOUSE_UP:
                    this.appendText("\n左键抬起");
                    break;
                case laya.events.Event.CLICK:
                    this.appendText("\n左键点击\n————————");
                    break;
                case laya.events.Event.RIGHT_MOUSE_DOWN:
                    this.appendText("\n————————\n右键按下");
                    break;
                case laya.events.Event.RIGHT_MOUSE_UP:
                    this.appendText("\n右键抬起");
                    break;
                case laya.events.Event.RIGHT_CLICK:
                    this.appendText("\n右键单击\n————————");
                    break;
                case laya.events.Event.MOUSE_MOVE:
                    // 如果上一个操作是移动，提示信息仅加入.字符
                    if (/鼠标移动\.*$/.test(this.txt.text))
                        this.appendText(".");
                    else
                        this.appendText("\n鼠标移动");
                    break;
                case laya.events.Event.MOUSE_OVER:
                    this.appendText("\n鼠标经过目标");
                    break;
                case laya.events.Event.MOUSE_OUT:
                    this.appendText("\n鼠标移出目标");
                    break;
                case laya.events.Event.DOUBLE_CLICK:
                    this.appendText("\n鼠标左键双击\n————————");
                    break;
                case laya.events.Event.MOUSE_WHEEL:
                    this.appendText("\n鼠标滚轮滚动");
                    break;
            }
        }

        private appendText(value:String):void {
            this.txt.text += value;
            this.txt.scrollY = this.txt.maxScrollY;
        }

        /**添加提示文本*/
        private createTxt():void {
            this.txt = new laya.display.Text();

            this.txt.overflow = 'scroll';
            this.txt.text = "请把鼠标移到到矩形方块,左右键操作触发相应事件\n";
            this.txt.size(550, 300);
            this.txt.pos(10, 50);
            this.txt.fontSize = 20;
            this.txt.wordWrap = true;
            this.txt.color = "#000000";

            Laya.stage.addChild(this.txt);
        }
    }

}
new mouses.MouseInteraction();