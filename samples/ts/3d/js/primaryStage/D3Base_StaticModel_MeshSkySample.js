var StaticModel_MeshSkySample = (function () {
    function StaticModel_MeshSkySample() {
        //是否抗锯齿
        //Config.isAntialias = true;
        Laya3D.init(0, 0);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(new Laya.Scene());
        this.camera = new Laya.Camera(0, 0.1, 100);
        scene.currentCamera = (scene.addChild(this.camera));
        scene.currentCamera.transform.translate(new Laya.Vector3(0.3, 0.3, 0.6));
        scene.currentCamera.transform.rotate(new Laya.Vector3(-12, 0, 0), true, false);
        scene.currentCamera.addComponent(CameraMoveScript);
        this.skySprite3D = scene.addChild(new Laya.Sprite3D());
        var skySampleScript = this.skySprite3D.addComponent(SkySampleScript);
        skySampleScript.skySprite = this.skySprite3D;
        skySampleScript.cameraSprite = this.camera;
        //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
        this.skySprite3D.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT006M.v3f.lh");
        this.skySprite3D.once(Laya.Event.HIERARCHY_LOADED, null, function (sprite) {
            var meshSprite = sprite.getChildAt(0);
            var mesh = meshSprite.mesh;
            mesh.once(Laya.Event.LOADED, null, function (templet) {
                for (var i = 0; i < meshSprite.shadredMaterials.length; i++) {
                    var material = meshSprite.shadredMaterials[i];
                    material.once(Laya.Event.LOADED, null, function (mat) {
                        mat.isSky = true;
                        mat.luminance = 3.5;
                    });
                }
            });
        });
    }
    return StaticModel_MeshSkySample;
}());
new StaticModel_MeshSkySample();
