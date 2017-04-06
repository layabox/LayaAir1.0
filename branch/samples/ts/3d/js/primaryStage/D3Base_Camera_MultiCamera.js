var Camera_MultiCamera = (function () {
    function Camera_MultiCamera() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(new Laya.Scene());
        var camera1 = new Laya.Camera(0, 0.1, 100);
        scene.addChild(camera1);
        camera1.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
        camera1.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        camera1.normalizedViewport = new Laya.Viewport(0, 0, 0.5, 1.0);
        var camera2 = new Laya.Camera(0, 0.1, 100);
        scene.addChild(camera2);
        camera2.clearColor = new Laya.Vector4(1.0, 1.0, 1.0, 1.0);
        camera2.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
        camera2.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        camera2.normalizedViewport = new Laya.Viewport(0.5, 0.5, 0.5, 0.5);
        var mesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm")));
        mesh.transform.localPosition = new Laya.Vector3(-0.3, 0.0, 0.0);
        mesh.transform.localScale = new Laya.Vector3(0.5, 0.5, 0.5);
    }
    return Camera_MultiCamera;
}());
new Camera_MultiCamera();
