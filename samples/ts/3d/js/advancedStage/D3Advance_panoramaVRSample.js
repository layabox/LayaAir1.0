var PanoramaVRSample;
(function (PanoramaVRSample_1) {
    /** @private */
    var PanoramaVRSample = (function () {
        function PanoramaVRSample() {
            //是否抗锯齿
            //Config.isAntialias = true;
            Laya3D.init(0, 0);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_HORIZONTAL;
            Laya.Stat.show();
            var scene = Laya.stage.addChild(new Laya.VRScene());
            var leftViewport = new Laya.Viewport(0, 0, Laya.RenderState.clientWidth / 2, Laya.RenderState.clientHeight);
            var rightViewport = new Laya.Viewport(Laya.RenderState.clientWidth / 2, 0, Laya.RenderState.clientWidth / 2, Laya.RenderState.clientHeight);
            var camera = new Laya.VRCamera(leftViewport, rightViewport, 0.03, Math.PI / 3.0, 0, 0, 0.1, 100);
            scene.currentCamera = (scene.addChild(camera));
            Laya.stage.on(Laya.Event.RESIZE, null, function () {
                var vrCamera = scene.currentCamera;
                vrCamera.leftViewport = new Laya.Viewport(0, 0, Laya.RenderState.clientWidth / 2, Laya.RenderState.clientHeight);
                vrCamera.rightViewport = new Laya.Viewport(Laya.RenderState.clientWidth / 2, 0, Laya.RenderState.clientWidth / 2, Laya.RenderState.clientHeight);
            });
            scene.currentCamera.addComponent(VRCameraMoveScript);
            this.loadScene(scene, camera);
        }
        PanoramaVRSample.prototype.loadScene = function (scene, camera) {
            var mesh = scene.addChild(new Laya.MeshSprite3D(new Laya.Sphere(1, 20, 20)));
            var material = new Laya.Material();
            material.cullFace = false;
            mesh.material = material;
            Laya.loader.load("../../res/threeDimen/panorama/panorama.jpg", Laya.Handler.create(null, function (texture) {
                texture.bitmap.mipmap = true;
                material.diffuseTexture = texture;
            }));
        };
        return PanoramaVRSample;
    }());
    PanoramaVRSample_1.PanoramaVRSample = PanoramaVRSample;
})(PanoramaVRSample || (PanoramaVRSample = {}));
new PanoramaVRSample.PanoramaVRSample();
