var laya;
(function (laya) {
    var Stage = Laya.Stage;
    var Image = Laya.Image;
    var Panel = Laya.Panel;
    var UI_Panel = (function () {
        function UI_Panel() {
            Laya.init(800, 600);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";
            this.setup();
        }
        UI_Panel.prototype.setup = function () {
            var panel = new Panel();
            panel.hScrollBarSkin = "../../res/ui/hscroll.png";
            panel.hScrollBar.hide = true;
            panel.size(600, 275);
            panel.x = (Laya.stage.width - panel.width) / 2;
            panel.y = (Laya.stage.height - panel.height) / 2;
            Laya.stage.addChild(panel);
            var img;
            for (var i = 0; i < 4; i++) {
                img = new Image("../../res/ui/dialog (1).png");
                img.x = i * 250;
                panel.addChild(img);
            }
        };
        return UI_Panel;
    }());
    laya.UI_Panel = UI_Panel;
})(laya || (laya = {}));
new laya.UI_Panel();
