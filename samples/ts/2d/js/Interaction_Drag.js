var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Event = Laya.Event;
    var Rectangle = Laya.Rectangle;
    var Browser = Laya.Browser;
    var Handler = Laya.Handler;
    var WebGL = Laya.WebGL;
    var Interaction_Drag = (function () {
        function Interaction_Drag() {
            this.ApePath = "../../res/apes/monkey2.png";
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            Laya.loader.load(this.ApePath, Handler.create(this, this.setup));
        }
        Interaction_Drag.prototype.setup = function () {
            this.createApe();
            this.showDragRegion();
        };
        Interaction_Drag.prototype.createApe = function () {
            this.ape = new Sprite();
            this.ape.loadImage(this.ApePath);
            Laya.stage.addChild(this.ape);
            var texture = Laya.loader.getRes(this.ApePath);
            this.ape.pivot(texture.width / 2, texture.height / 2);
            this.ape.x = Laya.stage.width / 2;
            this.ape.y = Laya.stage.height / 2;
            this.ape.on(Event.MOUSE_DOWN, this, this.onStartDrag);
        };
        Interaction_Drag.prototype.showDragRegion = function () {
            //拖动限制区域
            var dragWidthLimit = 350;
            var dragHeightLimit = 200;
            this.dragRegion = new Rectangle(Laya.stage.width - dragWidthLimit >> 1, Laya.stage.height - dragHeightLimit >> 1, dragWidthLimit, dragHeightLimit);
            //画出拖动限制区域
            Laya.stage.graphics.drawRect(this.dragRegion.x, this.dragRegion.y, this.dragRegion.width, this.dragRegion.height, null, "#FFFFFF", 2);
        };
        Interaction_Drag.prototype.onStartDrag = function (e) {
            //鼠标按下开始拖拽(设置了拖动区域和超界弹回的滑动效果)
            this.ape.startDrag(this.dragRegion, true, 100);
        };
        return Interaction_Drag;
    }());
    laya.Interaction_Drag = Interaction_Drag;
})(laya || (laya = {}));
new laya.Interaction_Drag();
