class PBRDemo {
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene: Laya.Scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/PBRScene/Demo.ls")) as Laya.Scene;

        scene.once(Laya.Event.HIERARCHY_LOADED, this,function():void {
            var camera: Laya.Camera = scene.getChildByName("Camera") as Laya.Camera;
            camera.addComponent(CameraMoveScript);
        });
    }
}
new PBRDemo();