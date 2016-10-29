var laya;
(function (laya) {
    var Sprite = Laya.Sprite;
    var Stage = Laya.Stage;
    var Text = Laya.Text;
    var Stat = Laya.Stat;
    var WebGL = Laya.WebGL;
    var Sprite_Cache = (function () {
        function Sprite_Cache() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(800, 600, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            Stat.show();
            this.setup();
        }
        Sprite_Cache.prototype.setup = function () {
            var textBox = new Sprite();
            // 随机摆放文本
            var text;
            for (var i = 0; i < 1000; i++) {
                text = new Text();
                text.fontSize = 20;
                text.text = (Math.random() * 100).toFixed(0);
                text.rotation = Math.random() * 360;
                text.color = "#CCCCCC";
                text.x = Math.random() * Laya.stage.width;
                text.y = Math.random() * Laya.stage.height;
                textBox.addChild(text);
            }
            //缓存为静态图像
            textBox.cacheAsBitmap = true;
            Laya.stage.addChild(textBox);
        };
        return Sprite_Cache;
    }());
    laya.Sprite_Cache = Sprite_Cache;
})(laya || (laya = {}));
new laya.Sprite_Cache();
