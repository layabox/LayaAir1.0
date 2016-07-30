module PanoramaVRSample {


    /** @private */
    export class PanoramaVRSample {

        constructor() {
            //是否抗锯齿
            //Config.isAntialias = true;
            Laya3D.init(0, 0);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_HORIZONTAL;
            Laya.Stat.show();

            var scene = Laya.stage.addChild(new Laya.VRScene()) as Laya.VRScene;

            var camera = new Laya.VRCamera(0.03, 0, 0, 0.1, 100);
            scene.currentCamera = (scene.addChild(camera)) as Laya.VRCamera;

            scene.currentCamera.addComponent(VRCameraMoveScript);
            this.loadScene(scene, camera);
        }

        private loadScene(scene: Laya.BaseScene, camera: Laya.VRCamera): void {

            var mesh = scene.addChild(new Laya.MeshSprite3D(new Laya.Sphere(1, 20, 20))) as Laya.MeshSprite3D;

            var material = new Laya.Material();
            material.cullFace = false;
            mesh.material = material;

            Laya.loader.load("../../res/threeDimen/panorama/panorama.jpg", Laya.Handler.create(null, function (texture: Laya.Texture): void {
                (texture.bitmap as Laya.WebGLImage).mipmap = true;
                material.diffuseTexture = texture;
            }));
        }
    }
}
new PanoramaVRSample.PanoramaVRSample();