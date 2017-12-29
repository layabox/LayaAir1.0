Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/PBRScene/Demo.ls"));

scene.once(Laya.Event.HIERARCHY_LOADED, this, function () {
    var camera = scene.getChildByName("Camera");
    camera.addComponent(CameraMoveScript);
});