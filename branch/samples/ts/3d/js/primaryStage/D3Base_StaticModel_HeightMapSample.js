var StaticModel_HeightMapSample = (function () {
    function StaticModel_HeightMapSample() {
        //是否抗锯齿
        //Config.isAntialias = true;
        Laya3D.init(0, 0);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(new Laya.Scene());
        scene.currentCamera = (scene.addChild(new Laya.Camera(0, 0.1, 100)));
        scene.currentCamera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
        scene.currentCamera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        var mesh = Laya.Mesh.load("../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm");
        var meshSprite = scene.addChild(new Laya.MeshSprite3D(mesh));
        mesh.once(Laya.Event.LOADED, null, function () {
            var cellSize = new Laya.Vector2();
            var heightMap = Laya.HeightMap.creatFromMesh(meshSprite, 512, 512, cellSize);
        });
    }
    return StaticModel_HeightMapSample;
}());
new StaticModel_HeightMapSample();
