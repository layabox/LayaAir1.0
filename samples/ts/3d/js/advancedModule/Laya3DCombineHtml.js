var Laya3DCombineHtml = (function () {
    function Laya3DCombineHtml() {
        var div = Laya.Browser.window.document.createElement("div");
        div.innerHTML = "<h1 style='color: red;'>此内容来源于HTML网页, 可直接在html代码中书写 - h1标签</h1>";
        document.body.appendChild(div);
        //1.开启第四个参数
        Laya3D.init(0, 0, true, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        //2.设置舞台背景色为空
        Laya.stage.bgColor = null;
        var scene = Laya.stage.addChild(new Laya.Scene());
        var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
        camera.transform.translate(new Laya.Vector3(0, 0.5, 1));
        camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
        //3.清除照相机颜色
        camera.clearColor = null;
        var directionLight = scene.addChild(new Laya.DirectionLight());
        directionLight.direction = new Laya.Vector3(0, -0.8, -1);
        directionLight.color = new Laya.Vector3(0.7, 0.6, 0.6);
        var layaMonkey = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh"));
    }
    return Laya3DCombineHtml;
}());
new Laya3DCombineHtml;
