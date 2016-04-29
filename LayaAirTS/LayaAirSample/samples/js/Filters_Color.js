/// <reference path="../../libs/LayaAir.d.ts" />
var LayaTsDemo = (function () {
    function LayaTsDemo() {
        Laya.init(550, 400);
        Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
        //由 20 个项目（排列成 4 x 5 矩阵）组成的数组，红色
        var redMat = [1, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            1, 0, 0, 0, 0]; //A
        //由 20 个项目（排列成 4 x 5 矩阵）组成的数组，灰图
        var grayscaleMat = [0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0];
        //创建一个颜色滤镜对象,红色
        var redFilter = new laya.filters.ColorFilter(redMat);
        //创建一个颜色滤镜对象，灰图
        var grayscaleFilter = new laya.filters.ColorFilter(grayscaleMat);
        // 猩猩原图
        var originalApe = this.createApe();
        originalApe.pos(50, 100);
        // 赤化猩猩
        var redApe = this.createApe();
        redApe.filters = [redFilter];
        redApe.pos(220, 100);
        // 灰度猩猩
        var grayApe = this.createApe();
        grayApe.filters = [grayscaleFilter];
        grayApe.pos(380, 100);
    }
    LayaTsDemo.prototype.createApe = function () {
        var ape = new laya.display.Sprite();
        ape.loadImage("res/apes/monkey2.png");
        Laya.stage.addChild(ape);
        return ape;
    };
    return LayaTsDemo;
}());
new LayaTsDemo();
