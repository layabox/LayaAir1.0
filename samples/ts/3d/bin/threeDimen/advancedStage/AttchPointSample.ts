module AttchPointSample {
    import Vector3 = Laya.Vector3;

    export class AttchPointSample {
        private skinMesh: Laya.Mesh;
        private skinAni: Laya.SkinAnimations;
        private fire: Laya.Particle3D;
        private attacthPoint: Laya.AttachPoint;
        private rotation: Vector3 = new Vector3(0, 3.14, 0);

        constructor() {

            Laya.Laya3D.init(0, 0);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();

            var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

            scene.currentCamera = (scene.addChild(new Laya.Camera(new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100))) as Laya.Camera;
            scene.currentCamera.transform.translate(new Vector3(0, 0.8, 1.0));
            scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
            scene.currentCamera.clearColor = null;
            Laya.stage.on(Laya.Event.RESIZE, null, () => {
                (scene.currentCamera as Laya.Camera).viewport = new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height);
            });

            var pointLight = scene.addChild(new Laya.PointLight()) as Laya.PointLight;
            pointLight.transform.position = new Vector3(0, 0.6, 0.3);
            pointLight.range = 1.0;
            pointLight.attenuation = new Vector3(0.6, 0.6, 0.6);
            pointLight.ambientColor = new Vector3(0.2, 0.2, 0.0);
            pointLight.specularColor = new Vector3(2.0, 2.0, 2.0);
            pointLight.diffuseColor = new Vector3(1, 1, 1);
            scene.shadingMode = Laya.BaseScene.PIXEL_SHADING;

            this.skinMesh = scene.addChild(new Laya.Mesh()) as Laya.Mesh;
            this.skinMesh.load("threeDimen/skinModel/dude/dude-him.lm");
            this.skinMesh.transform.localRotationEuler = this.rotation;
            this.skinAni = this.skinMesh.addComponent(Laya.SkinAnimations) as Laya.SkinAnimations;
            this.skinAni.url = "threeDimen/skinModel/dude/dude.ani";
            this.skinAni.play();

            this.attacthPoint = this.skinMesh.addComponent(Laya.AttachPoint) as Laya.AttachPoint;
            this.attacthPoint.attachBone = "L_Middle1";
            var settings: Laya.ParticleSettings = new Laya.ParticleSettings();
            settings.textureName = "threeDimen/particle/fire.png";
            settings.maxPartices = 200;
            settings.duration = 0.3;
            settings.ageAddScale = 1;
            settings.minHorizontalVelocity = 0;
            settings.maxHorizontalVelocity = 0;
            settings.minVerticalVelocity = 0;
            settings.maxVerticalVelocity = 0.1;
            settings.gravity = new Float32Array([0, 0.05, 0]);
            settings.minStartColor = new Float32Array([1.0, 1.0, 1.0, 0.039215]);
            settings.maxStartColor = new Float32Array([1.0, 1.0, 1.0, 0.256862]);
            settings.minStartSize = 0.02;
            settings.maxStartSize = 0.05;
            settings.minEndSize = 0.05;
            settings.maxEndSize = 0.2;
            settings.blendState = 1;
            this.fire = new Laya.Particle3D(settings);
            scene.addChild(this.fire);
            this.fire.transform.localRotationEuler = this.rotation;//同步人物旋转

            Laya.timer.frameLoop(1, this, this.loop);
        }

        private loop(): void {
            if (this.attacthPoint.matrix) {
                var e: Float32Array = this.attacthPoint.matrix.elements;
                for (var i = 0; i < 10; i++) {
                    this.fire.addParticle(new Vector3(e[12], e[13], e[14]), new Vector3(0, 0, 0));//矩阵的12、13、14分别为Position的X、Y、Z
                }
            }
        }
    }
}
new AttchPointSample.AttchPointSample();