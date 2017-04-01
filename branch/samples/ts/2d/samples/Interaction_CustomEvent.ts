module laya {
    import Sprite = Laya.Sprite;
    import Stage = Laya.Stage;
    import Event = Laya.Event;
    import Browser = Laya.Browser;
    import Ease = Laya.Ease;
    import Tween = Laya.Tween;
    import WebGL = Laya.WebGL;

    export class Interaction_CustomEvent {
        public static ROTATE: string = "rotate";

        private sp: Sprite;

        constructor()
        {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";

            this.createSprite();
        }

        private createSprite(): void {
            this.sp = new Sprite();
            this.sp.graphics.drawRect(0, 0, 200, 200, "#D2691E");
            this.sp.pivot(100, 100);

            this.sp.x = Laya.stage.width / 2;
            this.sp.y = Laya.stage.height / 2;

            this.sp.size(200, 200);
            Laya.stage.addChild(this.sp);

            this.sp.on(Interaction_CustomEvent.ROTATE, this, this.onRotate);    // 侦听自定义的事件
            this.sp.on(Event.CLICK, this, this.onSpriteClick);
        }

        private onSpriteClick(e: Event): void {
            var randomAngle: number = Math.random() * 180;
            //发送自定义事件
            this.sp.event(Interaction_CustomEvent.ROTATE, [randomAngle]);
        }

        // 触发自定义的rotate事件
        private onRotate(newAngle: number): void {
            Tween.to(this.sp, { "rotation": newAngle }, 1000, Ease.elasticOut);
        }
    }
}
new laya.Interaction_CustomEvent();