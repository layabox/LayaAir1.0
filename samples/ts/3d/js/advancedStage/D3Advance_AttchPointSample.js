var AttchPointSample;
(function (AttchPointSample_1) {
    var Vector3 = Laya.Vector3;
    var AttchPointSample = (function () {
        function AttchPointSample() {
            this.rotation = new Vector3(0, 3.14, 0);
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();
            var scene = Laya.stage.addChild(new Laya.Scene());
            var camera = (scene.addChild(new Laya.Camera(0, 0.1, 100)));
            camera.transform.translate(new Vector3(0, 0.8, 1.0));
            camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
            camera.clearColor = null;
            var pointLight = scene.addChild(new Laya.PointLight());
            pointLight.transform.position = new Vector3(0, 0.6, 0.3);
            pointLight.range = 1.0;
            pointLight.attenuation = new Vector3(0.6, 0.6, 0.6);
            pointLight.ambientColor = new Vector3(0.2, 0.2, 0.0);
            pointLight.specularColor = new Vector3(2.0, 2.0, 2.0);
            pointLight.diffuseColor = new Vector3(1, 1, 1);
            this.skinMesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/dude/dude-him.lm")));
            this.skinMesh.transform.localRotationEuler = this.rotation;
            this.skinAni = this.skinMesh.addComponent(Laya.SkinAnimations);
            this.skinAni.templet = Laya.AnimationTemplet.load("../../res/threeDimen/skinModel/dude/dude-Take 001.lsani");
            this.skinAni.player.play();
            this.attacthPoint = this.skinMesh.addComponent(Laya.AttachPoint);
            this.attacthPoint.attachBones.push("L_Middle1");
            this.attacthPoint.attachBones.push("R_Middle1");
            var settings = new Laya.ParticleSetting();
            settings.textureName = "../../res/threeDimen/particle/fire.png";
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
            this.attacthPoint.on(Laya.Event.COMPLETE, this, function () {
                for (var j = 0; j < this.attacthPoint.attachBones.length; j++) {
                    if (this.attacthPoint.matrixs[j]) {
                        var e = this.attacthPoint.matrixs[j].elements;
                        for (var i = 0; i < 10; i++) {
                            this.fire.addParticle(new Vector3(e[12], e[13], e[14]), new Vector3(0, 0, 0)); //矩阵的12、13、14分别为Position的X、Y、Z
                        }
                    }
                }
            });
        }
        return AttchPointSample;
    }());
    AttchPointSample_1.AttchPointSample = AttchPointSample;
})(AttchPointSample || (AttchPointSample = {}));
new AttchPointSample.AttchPointSample();
