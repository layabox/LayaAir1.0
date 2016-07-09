class StaticModel_HierarchySample {
    private skinMesh: Laya.Mesh;
    private skinAni: Laya.SkinAnimations;

    constructor() {

        Laya.Laya3D.init(0, 0);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        scene.currentCamera = (scene.addChild(new Laya.Camera(new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100))) as Laya.Camera;
        scene.currentCamera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
        scene.currentCamera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        Laya.stage.on(Laya.Event.RESIZE, null, () => {
            (scene.currentCamera as Laya.Camera).viewport = new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height);
        });

        var staticMesh = scene.addChild(new Laya.Sprite3D()) as Laya.Sprite3D;
        staticMesh.on(Laya.Event.HIERARCHY_LOADED, null, (sprite) => {
            var templet = (sprite.getChildAt(0) as Laya.Mesh).templet;
            templet.on(Laya.Event.LOADED, null, (templet) => {
                for (var i = 0; i < templet.materials.length; i++) {
                    var material = templet.materials[i];
                    material.luminance = 3.5;
                }
            });
        });
        staticMesh.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh");
        staticMesh.transform.localScale = new Laya.Vector3(10, 10, 10);
    }
}
new StaticModel_HierarchySample();