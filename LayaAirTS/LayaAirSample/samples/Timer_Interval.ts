/// <reference path="../../libs/LayaAir.d.ts" />
module timer {
    import Text=laya.display.Text;

    export class LoopExecution {
        private  rotateTimeBasedText:Text;
        private  rotateFrameRateBasedText:Text;

        constructor() {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

            this.rotateTimeBasedText = this.createText("基于时间旋转", 120, 170);

            this.rotateFrameRateBasedText = this.createText("基于帧频旋转", 350, 170);

            Laya.timer.loop(200, this, this.animateTimeBased);
            Laya.timer.frameLoop(2, this, this.animateFrameRateBased);
        }

        private  createText(text:string, x:number, y:number):Text {
            var t:Text = new Text();
            t.text = text;
            t.fontSize = 30;
            t.color = "white";
            t.bold = true;
            t.pivot(t.width / 2, t.height / 2);
            t.pos(x, y);
            Laya.stage.addChild(t);

            return t;
        }

        private  animateTimeBased():void {
            this.rotateTimeBasedText.rotation += 1;
        }

        private  animateFrameRateBased():void {
            this.rotateFrameRateBasedText.rotation += 1;
        }
    }
}
new timer.LoopExecution();
