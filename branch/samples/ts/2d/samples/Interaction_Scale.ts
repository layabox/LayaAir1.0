module laya {
    import Sprite = Laya.Sprite;
    import Stage = Laya.Stage;
    import Event = Laya.Event;
    import Browser = Laya.Browser;
    import WebGL = Laya.WebGL;

    export class Interaction_Scale {
        //上次记录的两个触模点之间距离
        private lastDistance: number = 0;
        private sp: Sprite;

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
            this.createSprite();

            Laya.stage.on(Event.MOUSE_UP, this, this.onMouseUp);
            Laya.stage.on(Event.MOUSE_OUT, this, this.onMouseUp);
        }

        private createSprite(): void {
            this.sp = new Sprite();
            var w: number = 300, h: number = 300;
            this.sp.graphics.drawRect(0, 0, w, h, "#FF7F50");
            this.sp.size(w, h);
            this.sp.pivot(w / 2, h / 2);
            this.sp.pos(Laya.stage.width / 2, Laya.stage.height / 2);
            Laya.stage.addChild(this.sp);

            this.sp.on(Event.MOUSE_DOWN, this, this.onMouseDown);
        }

        private onMouseDown(e: Event): void {
            var touches: Array<any> = e.touches;

            if (touches && touches.length == 2) {
                this.lastDistance = this.getDistance(touches);

                Laya.stage.on(Event.MOUSE_MOVE, this, this.onMouseMove);
            }
        }

        private onMouseMove(e: Event): void {
            var distance: number = this.getDistance(e.touches);

            //判断当前距离与上次距离变化，确定是放大还是缩小
            const factor: number = 0.01;
            this.sp.scaleX += (distance - this.lastDistance) * factor;
            this.sp.scaleY += (distance - this.lastDistance) * factor;

            this.lastDistance = distance;
        }

        private onMouseUp(e: Event): void {
            Laya.stage.off(Event.MOUSE_MOVE, this, this.onMouseMove);
        }

        /**计算两个触摸点之间的距离*/
        private getDistance(points: Array<any>): number {
            var distance: number = 0;
			if (points && points.length == 2)
			{
				var dx: number = points[0].stageX - points[1].stageX;
				var dy: number = points[0].stageY - points[1].stageY;

				distance = Math.sqrt(dx * dx + dy * dy);
			}
            return distance;
        }
    }
}
new laya.Interaction_Scale();