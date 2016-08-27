var StaticModel_MeshSkySample = (function () {
    function StaticModel_MeshSkySample() {
        Laya3D.init(0, 0, true);
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
            var mesh = meshSprite.meshFilter.sharedMesh;
            mesh.once(Laya.Event.LOADED, null, function (templet) {
                for (var i = 0; i < meshSprite.meshRender.shadredMaterials.length; i++) {
                    var material = meshSprite.meshRender.shadredMaterials[i];
                    material.once(Laya.Event.LOADED, null, function (mat) {
                        mat.albedo = new Laya.Vector4(3.5, 3.5, 3.5, 1.0);
                        mat.renderMode = Laya.Material.RENDERMODE_SKY;
                    });
                }
            });
        });
    }
    return StaticModel_MeshSkySample;
}());
new StaticModel_MeshSkySample();
