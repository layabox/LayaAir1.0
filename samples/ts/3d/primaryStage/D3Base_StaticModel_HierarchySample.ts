class StaticModel_HierarchySample {
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

        //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
        var staticMesh = scene.addChild(new Laya.Sprite3D()) as Laya.Sprite3D;
        staticMesh.once(Laya.Event.HIERARCHY_LOADED, this, (sprite) => {
            var meshSprite = sprite.getChildAt(0) as Laya.MeshSprite3D;
            var mesh = meshSprite.mesh;
            mesh.once(Laya.Event.LOADED, this, (mesh) => {
                for (var i = 0; i < meshSprite.materials.length; i++) {
                    var material = meshSprite.materials[i];
                    material.once(Laya.Event.LOADED, this, (mat) => {
                        mat.luminance = 3.5;
                    });
                }
            });
        });
        staticMesh.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh");
        staticMesh.transform.localScale = new Laya.Vector3(10, 10, 10);
    }
}
new StaticModel_HierarchySample();