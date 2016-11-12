var PanoramaVRSample;
(function (PanoramaVRSample_1) {
    /** @private */
    var PanoramaVRSample = (function () {
        function PanoramaVRSample() {
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_HORIZONTAL;
            Laya.Stat.show();
            var scene = Laya.stage.addChild(new Laya.VRScene());
            var camera = new Laya.VRCamera(0.03, 0, 0, 0.1, 100);
            camera = (scene.addChild(camera));
            camera.addComponent(VRCameraMoveScript);
            this.loadScene(scene, camera);
        }
        PanoramaVRSample.prototype.loadScene = function (scene, camera) {
            var mesh = scene.addChild(new Laya.MeshSprite3D(new Laya.SphereMesh(1, 20, 20)));
            var material = new Laya.StandardMaterial();
            material.renderMode = Laya.BaseMaterial.RENDERMODE_OPAQUEDOUBLEFACE;
            mesh.meshRender.sharedMaterial = material;
            Laya.loader.load("../../res/threeDimen/panorama/panorama.jpg", Laya.Handler.create(null, function (texture) {
                texture.bitmap.mipmap = true;
                texture.bitmap.enableMerageInAtlas = false;
                material.diffuseTexture = texture;
            }));
        };
        return PanoramaVRSample;
    }());
    PanoramaVRSample_1.PanoramaVRSample = PanoramaVRSample;
})(PanoramaVRSample || (PanoramaVRSample = {}));
new PanoramaVRSample.PanoramaVRSample();
