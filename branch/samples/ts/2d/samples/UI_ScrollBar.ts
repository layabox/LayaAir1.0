module laya {
    import Stage = Laya.Stage;
    import HScrollBar = Laya.HScrollBar;
    import VScrollBar = Laya.VScrollBar;
    import Handler = Laya.Handler;
    import WebGL = Laya.WebGL;

    export class UI_ScrollBar {
        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(550, 400, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";

            var skins: Array<string> = [];
            skins.push("../../res/ui/hscroll.png", "../../res/ui/hscroll$bar.png", "../../res/ui/hscroll$down.png", "../../res/ui/hscroll$up.png");
            skins.push("../../res/ui/vscroll.png", "../../res/ui/vscroll$bar.png", "../../res/ui/vscroll$down.png", "../../res/ui/vscroll$up.png");
            Laya.loader.load(skins, Handler.create(this, this.onSkinLoadComplete));
        }

        private onSkinLoadComplete(): void {
            this.placeHScroller();
            this.placeVScroller();
        }

        private placeHScroller(): void {
            var hs: HScrollBar = new HScrollBar();
            hs.skin = "../../res/ui/hscroll.png";
            hs.width = 300;
            hs.pos(50, 170);

            hs.min = 0;
            hs.max = 100;

            hs.changeHandler = new Handler(this, this.onChange);
            Laya.stage.addChild(hs);
        }

        private placeVScroller(): void {
            var vs: VScrollBar = new VScrollBar();
            vs.skin = "../../res/ui/vscroll.png";
            vs.height = 300;
            vs.pos(400, 50);

            vs.min = 0;
            vs.max = 100;

            vs.changeHandler = new Handler(this, this.onChange);
            Laya.stage.addChild(vs);
        }

        private onChange(value: Number): void {
            console.log("滚动条的位置： value=" + value);
        }
    }
}
new laya.UI_ScrollBar();