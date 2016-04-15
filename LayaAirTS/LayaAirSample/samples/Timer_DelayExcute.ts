/// <reference path="../../libs/LayaAir.d.ts" />
module timers
{
    export  class TimeDelayExecution
    {
        private  spBtn1:laya.display.Sprite;
        private  spBtn2:laya.display.Sprite;

        constructor()
        {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;

            this.spBtn1 = new laya.display.Sprite();
            this.spBtn1.size(200, 100);
            this.spBtn1.pos(27, 29);

            this.spBtn1.graphics.drawRect(0, 0, 200, 100, "#ff0000");
            this.spBtn1.graphics.fillText("点我3秒之后 alpha - 0.5", 5, 20, "", "#ffffff", "left");

            this.spBtn1.mouseEnabled = true;
            this.spBtn1.on(laya.events.Event.CLICK, this, this.onMinusAlpha1);
            Laya.stage.addChild(this.spBtn1);

            this.spBtn2 =  new laya.display.Sprite();
            this.spBtn2.size(200, 100);
            this.spBtn2.pos(250, 29);

            this.spBtn2.graphics.drawRect(0, 0, 200, 100, "#ff0000");
            this.spBtn2.graphics.fillText("点我60帧之后 alpha - 0.5", 5, 20, "", "#ffffff", "left");

            //接受鼠标事件
            this.spBtn2.mouseEnabled = true;
            this.spBtn2.on(laya.events.Event.CLICK, this, this.onMinusAlpha2);

            Laya.stage.addChild(this.spBtn2);
        }
        private  onMinusAlpha1(e:laya.events.Event):void
        {
            //移除鼠标单击事件
            this.spBtn1.off(laya.events.Event.CLICK, this, this.onMinusAlpha1);
            //定时执行一次(间隔时间)
            Laya.timer.once(3000, this, this.onComplete1);
        }

        private onMinusAlpha2(e:laya.events.Event):void
        {
            //移除鼠标单击事件
            this.spBtn2.off(laya.events.Event.CLICK, this, this.onMinusAlpha2);
            //定时执行一次(基于帧率)
            Laya.timer.frameOnce(60, this, this.onComplete2);
        }

        private onComplete1():void
        {
            //spBtn1的透明度减少0.5
            this.spBtn1.alpha -= 0.5;
        }

        private  onComplete2():void
        {
            //spBtn2的透明度减少0.5
            this.spBtn2.alpha -= 0.5;
        }
    }
}
new timers.TimeDelayExecution();