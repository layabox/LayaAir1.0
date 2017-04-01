module laya {
    import Sprite = Laya.Sprite;
    import Stage = Laya.Stage;
    import Browser = Laya.Browser;
    import WebGL = Laya.WebGL;

    export class Sprite_DrawPath {
        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";

            this.drawPentagram();
        }

        private drawPentagram(): void {
            var canvas: Sprite = new Sprite();
            Laya.stage.addChild(canvas);

            var path: Array<number> = [];
            path.push(0, -130);
            path.push(33, -33);
            path.push(137, -30);
            path.push(55, 32);
            path.push(85, 130);
            path.push(0, 73);
            path.push(-85, 130);
            path.push(-55, 32);
            path.push(-137, -30);
            path.push(-33, -33);

            canvas.graphics.drawPoly(Laya.stage.width / 2, Laya.stage.height / 2, path, "#FF7F50");
        }
    }
}
new laya.Sprite_DrawPath();