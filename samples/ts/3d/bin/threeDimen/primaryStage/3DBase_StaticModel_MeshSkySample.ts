class StaticModel_MeshSkySample {

    constructor() {
        Laya.Laya3D.init(0, 0);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        scene.currentCamera = (scene.addChild(new Laya.Camera(new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100))) as Laya.Camera;
        scene.currentCamera.transform.translate(new Laya.Vector3(0.3, 0.3, 0.6));
        scene.currentCamera.transform.rotate(new Laya.Vector3(-12, 0, 0), true, false);
        Laya.stage.on(Laya.Event.RESIZE, null, () => {
            (scene.currentCamera as Laya.Camera).viewport = new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height);
        });


        scene.currentCamera.addComponent(CameraMoveScript);

        var skySprite3D = scene.addChild(new Laya.Sprite3D()) as Laya.Sprite3D;
        skySprite3D.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT006M.v3f.lh");
        skySprite3D.on(Laya.Event.HIERARCHY_LOADED, null, (sprite) => {
            var meshTemplet = (sprite.getChildAt(0) as Laya.Mesh).templet;
            meshTemplet.on(Laya.Event.LOADED, null, (templet) => {
                for (var i = 0; i < templet.materials.length; i++) {
                    var material = meshTemplet.materials[i];
                    material.luminance = 3.5;
                }
            });
        });
    }

}
new StaticModel_MeshSkySample();