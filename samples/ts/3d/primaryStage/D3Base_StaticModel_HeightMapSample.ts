class StaticModel_HeightMapSample {
    private skinMesh: Laya.MeshSprite3D;
    private skinAni: Laya.SkinAnimations;

    constructor() {
        //是否抗锯齿
        //Config.isAntialias = true;
        Laya3D.init(0, 0);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        scene.currentCamera = (scene.addChild(new Laya.Camera(0, 0.1, 100))) as Laya.Camera;
        scene.currentCamera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
        scene.currentCamera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);

        var mesh = Laya.Mesh.load("../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm");
        var meshSprite = scene.addChild(new Laya.MeshSprite3D(mesh)) as Laya.MeshSprite3D;

        mesh.once(Laya.Event.LOADED, null, function (): void {
            var cellSize = new Laya.Vector2();
            var heightMap = Laya.HeightMap.creatFromMesh(meshSprite, 512, 512, cellSize);
        });

    }
}
new StaticModel_HeightMapSample();