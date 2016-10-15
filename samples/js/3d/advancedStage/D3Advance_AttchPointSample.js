Laya3D.init(0, 0,true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var Vector3 = Laya.Vector3;
var scene = Laya.stage.addChild(new Laya.Scene());
var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
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
scene.shadingMode = Laya.BaseScene.PIXEL_SHADING;

var skinMesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/dude/dude-him.lm")));
skinMesh.transform.localRotationEuler = new Vector3(0, 3.14, 0);

var skinAni = skinMesh.addComponent(Laya.SkinAnimations);
skinAni.url = "../../res/threeDimen/skinModel/dude/dude.ani";
skinAni.player.play();

var attacthPoint = skinMesh.addComponent(Laya.AttachPoint);
attacthPoint.attachBones.push("L_Middle1");
attacthPoint.attachBones.push("R_Middle1");

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

var fire = new Laya.Particle3D(settings);
scene.addChild(fire);

Laya.timer.frameLoop(1, this, loop);

function loop() {

    for(var j = 0; j < attacthPoint.attachBones.length; j++){
        if (attacthPoint.matrixs[j]) {
            var e = attacthPoint.matrixs[j].elements;
            for (var i = 0; i < 10; i++) {
                fire.addParticle(new Vector3(e[12], e[13], e[14]), new Vector3(0, 0, 0));//矩阵的12、13、14分别为Position的X、Y、Z
            }
        }
    }

}