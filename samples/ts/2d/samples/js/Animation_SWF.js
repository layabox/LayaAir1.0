/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var MovieClip = laya.ani.swf.MovieClip;
    var Stage = laya.display.Stage;
    var Browser = laya.utils.Browser;
    var WebGL = laya.webgl.WebGL;
    var Animation_SWF = (function () {
        function Animation_SWF() {
            this.SWFPath = "res/swf/dragon.swf";
            this.MCWidth = 318;
            this.MCHeight = 406;
            // 不支持WebGL时自动切换至Canvas
            Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);
            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;
            Laya.stage.scaleMode = "showall";
            Laya.stage.bgColor = "#232628";
            this.createMovieClip();
        }
        Animation_SWF.prototype.createMovieClip = function () {
            var mc = new MovieClip();
            mc.load(this.SWFPath);
            mc.x = (Laya.stage.width - this.MCWidth) / 2;
            mc.y = (Laya.stage.height - this.MCHeight) / 2;
            Laya.stage.addChild(mc);
        };
        return Animation_SWF;
    }());
    laya.Animation_SWF = Animation_SWF;
})(laya || (laya = {}));
new laya.Animation_SWF();
