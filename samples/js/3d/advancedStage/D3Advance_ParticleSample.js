var Vector3 = Laya.Vector3;
var ParticleSettings = Laya.ParticleSettings;
var Particle3D = Laya.Particle3D;
var Browser = Laya.Browser;
var Sprite3D = Laya.Sprite3D;

var pos = new Vector3();
var Vel = new Vector3();
var lastTime = Laya.Browser.now();

var currentState = 0;
var simple;
var smoke;
var fire;
var projectileTrail;
var explosionSmoke;
var explosion;

var timeToNextProjectile = 0;
var projectiles = [];

//是否抗锯齿
//Config.isAntialias = true;
Laya3D.init(0, 0);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

loadUI();

var scene = Laya.stage.addChild(new Laya.Scene());

scene.currentCamera = (scene.addChild(new Laya.Camera( 0, 0.1, 100)));
scene.currentCamera.transform.translate(new Vector3(0, 1, 2.6));
scene.currentCamera.transform.rotate(new Vector3(-20, 0, 0), false, false);
scene.currentCamera.clearColor = null;

scene.currentCamera.addComponent(CameraMoveScript);

var grid = scene.addChild(new Sprite3D());
grid.loadHierarchy("../../res/threeDimen/staticModel/grid/plane.lh");

var settings = new ParticleSettings();
settings.textureName = "../../res/threeDimen/particle/texture.png";
settings.maxPartices = 3600;
settings.duration = 6.0;
settings.ageAddScale = 1.0;
settings.minHorizontalVelocity = 0.00001;
settings.maxHorizontalVelocity = 0.00001;
settings.minVerticalVelocity = 0.00001;
settings.maxVerticalVelocity = 0.00001;
settings.gravity = new Float32Array([0, 0.01, 0]);
settings.endVelocity = 1.0;
settings.minRotateSpeed = -2;
settings.maxRotateSpeed = 2;
settings.minStartSize = 0.04;
settings.maxStartSize = 0.06;
settings.minEndSize = 0.12;
settings.maxEndSize = 0.26;
settings.blendState = 1;

settings.colorComponentInter = true;
settings.minStartColor = new Float32Array([0.1, 0.3, 0.6, 0.6]);
settings.maxStartColor = new Float32Array([1.0, 0.5, 1.0, 1.0]);
settings.minEndColor = new Float32Array([0.1, 0.3, 0.6, 0.6]);
settings.maxEndColor = new Float32Array([1.0, 0.5, 1.0, 1.0]);
settings.minStartRadius = 0.5;
settings.maxStartRadius = 0.5;
settings.minEndRadius = 0.5;
settings.maxEndRadius = 0.5;
settings.minHorizontalEndRadian = -3.14 * 2;
settings.maxHorizontalEndRadian = 3.14 * 2;
settings.minVerticalEndRadian = -3.14 * 2;
settings.maxVerticalEndRadian = 3.14 * 2;

simple = new Particle3D(settings);
simple.transform.localPosition = new Vector3(0, 0.5, 0);
scene.addChild(simple);

settings = new ParticleSettings();
settings.textureName = "../../res/threeDimen/particle/smoke.png";
settings.maxPartices = 600;
settings.duration = 10;
settings.minHorizontalVelocity = 0;
settings.maxHorizontalVelocity = 0.15;
settings.minVerticalVelocity = 0.1;
settings.maxVerticalVelocity = 0.2;
settings.gravity = new Float32Array([-0.20, -0.05, 0]);
settings.endVelocity = 0.75;
settings.minRotateSpeed = -1;
settings.maxRotateSpeed = 1;
settings.minStartSize = 0.04;
settings.maxStartSize = 0.07;
settings.minEndSize = 0.35;
settings.maxEndSize = 1.4;
smoke = new Particle3D(settings);
scene.addChild(smoke);

settings = new ParticleSettings();
settings.textureName = "../../res/threeDimen/particle/fire.png";
settings.maxPartices = 1200;
settings.duration = 2;
settings.ageAddScale = 1;
settings.minHorizontalVelocity = 0;
settings.maxHorizontalVelocity = 0.15;
settings.minVerticalVelocity = -0.1;
settings.maxVerticalVelocity = 0.1;
settings.gravity = new Float32Array([0, 0.15, 0]);
settings.minStartColor = new Float32Array([1.0, 1.0, 1.0, 0.29215]);
settings.maxStartColor = new Float32Array([1.0, 1.0, 1.0, 0.56]);
settings.minEndColor = new Float32Array([1.0, 1.0, 1.0, 0.29215]);
settings.maxEndColor = new Float32Array([1.0, 1.0, 1.0, 0.56]);
settings.minStartSize = 0.05;
settings.maxStartSize = 0.1;
settings.minEndSize = 0.1;
settings.maxEndSize = 0.4;
settings.blendState = 1;
fire = new Particle3D(settings);
scene.addChild(fire);

//...............................
settings = new ParticleSettings();
settings.textureName = "../../res/threeDimen/particle/smoke.png";
settings.maxPartices = 1000;
settings.duration = 3;
settings.ageAddScale = 1.5;
settings.emitterVelocitySensitivity = 0.1;
settings.minHorizontalVelocity = 0;
settings.maxHorizontalVelocity = 0.01;
settings.minVerticalVelocity = -0.01;
settings.maxVerticalVelocity = 0.01;
settings.minStartColor = new Float32Array([64 / 255, 96 / 255, 128 / 255, 1.0]);
settings.maxStartColor = new Float32Array([1.0, 1.0, 1.0, 128 / 255]);
settings.minEndColor = new Float32Array([64 / 255, 96 / 255, 128 / 255, 1.0]);
settings.maxEndColor = new Float32Array([1.0, 1.0, 1.0, 128 / 255]);
settings.minRotateSpeed = -4;
settings.maxRotateSpeed = 4;
settings.minStartSize = 0.01;
settings.maxStartSize = 0.03;
settings.minEndSize = 0.04;
settings.maxEndSize = 0.11;
settings.blendState = 0;
projectileTrail = new Particle3D(settings);
scene.addChild(projectileTrail);

settings = new ParticleSettings();
settings.textureName = "../../res/threeDimen/particle/explosion.png";
settings.maxPartices = 100;
settings.duration = 2;
settings.ageAddScale = 1;
settings.minHorizontalVelocity = 0.2;
settings.maxHorizontalVelocity = 0.3;
settings.minVerticalVelocity = -0.2;
settings.maxVerticalVelocity = 0.2;
settings.endVelocity = 0;
settings.minStartColor = new Float32Array([169 / 255, 169 / 255, 169 / 255, 1.0]);
settings.maxStartColor = new Float32Array([128 / 255, 128 / 255, 128 / 255, 1.0]);
settings.minEndColor = new Float32Array([169 / 255, 169 / 255, 169 / 255, 1.0]);
settings.maxEndColor = new Float32Array([128 / 255, 128 / 255, 128 / 255, 1.0]);
settings.minRotateSpeed = -1;
settings.maxRotateSpeed = 1;
settings.minStartSize = 0.07;
settings.maxStartSize = 0.07;
settings.minEndSize = 0.7;
settings.maxEndSize = 1.4;
settings.blendState = 1;
explosion = new Particle3D(settings);
scene.addChild(explosion);

settings = new ParticleSettings();
settings.textureName = "../../res/threeDimen/particle/smoke.png";
settings.maxPartices = 200;
settings.duration = 4;
settings.minHorizontalVelocity = 0;
settings.maxHorizontalVelocity = 0.5;
settings.minVerticalVelocity = -0.1;
settings.maxVerticalVelocity = 0.5;
settings.gravity = new Float32Array([0, -0.2, 0]);
settings.endVelocity = 0;
settings.minStartColor = new Float32Array([211 / 255, 211 / 255, 211 / 255, 1.0]);
settings.maxStartColor = new Float32Array([1.0, 1.0, 1.0, 1.0]);
settings.minEndColor = new Float32Array([211 / 255, 211 / 255, 211 / 255, 1.0]);
settings.maxEndColor = new Float32Array([1.0, 1.0, 1.0, 1.0]);
settings.minRotateSpeed = -2;
settings.maxRotateSpeed = 2;
settings.minStartSize = 0.07;
settings.maxStartSize = 0.07;
settings.minEndSize = 0.7;
settings.maxEndSize = 1.4;
settings.blendState = 0;
explosionSmoke = new Particle3D(settings);
scene.addChild(explosionSmoke);

Laya.timer.frameLoop(1, this, updateParticle);

function updateParticle() {
    var currentTime = Browser.now();
    var interval = currentTime - lastTime;
    lastTime = currentTime;

    switch (currentState) {
        case 0:
            updateSimple();
            break;
        case 1:
            updateSmoke();
            break;
        case 2:
            updateFire();
            break;
        case 3:
            updateExplosions(interval);
            updateProjectiles(interval);
            break;
    }
}
function updateSimple() {
    for (var i = 0; i < 3; i++) {
        Vector3.ZERO.cloneTo(pos);
        Vector3.ZERO.cloneTo(Vel);
        simple.templet.addParticle(pos, Vel);
    }

}

function updateSmoke() {
    Vector3.ZERO.cloneTo(pos);
    Vector3.ZERO.cloneTo(Vel);
    smoke.templet.addParticle(pos, Vel);

}

function updateFire() {
    for (var i = 0; i < 8; i++) {
        Vector3.ZERO.cloneTo(Vel);
        fire.templet.addParticle(randomPointOnCircle(), Vel);

    }
    Vector3.ZERO.cloneTo(Vel);
    smoke.templet.addParticle(randomPointOnCircle(), Vel);

}

function updateExplosions(interval) {
    timeToNextProjectile -= interval / 1000;
    if (timeToNextProjectile <= 0) {
        projectiles.push(new ProjectileParticle(explosion, explosionSmoke, projectileTrail));
        timeToNextProjectile += 1;
    }
}

function updateProjectiles(interval) {
    var i = 0;
    while (i < projectiles.length) {
        if (!projectiles[i].update(interval))
            projectiles.splice(i, 1);
        else
            i++;
    }
}
function randomPointOnCircle() {
    const radiusX = 0.3;
    const radiusY = 0.5;
    const height = 0.5;

    var angle = Math.random() * Math.PI * 2;

    var x = Math.cos(angle);
    var y = Math.sin(angle);
    var zeroPosE = pos.elements;
    zeroPosE[0] = x * radiusX;
    zeroPosE[1] = y * radiusY + height;
    zeroPosE[2] = 0;
    return pos;
}

function loadUI() {
    Laya.loader.load(["../../res/threeDimen/ui/button.png"], Laya.Handler.create(null, function () {
        var btn = new Laya.Button();
        btn.skin = "../../res/threeDimen/ui/button.png";
        btn.label = "切换";
        btn.labelBold = true;
        btn.labelSize = 20;
        btn.sizeGrid = "4,4,4,4";
        btn.size(120, 30);
        btn.scale(Browser.pixelRatio, Browser.pixelRatio);
        btn.pos(Laya.stage.width / 2 - btn.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
        btn.strokeColors = "#ff0000,#ffff00,#00ffff";
        btn.on(Laya.Event.CLICK, this, onclick);
        Laya.stage.addChild(btn);

        Laya.stage.on(Laya.Event.RESIZE, null, function () {
            btn.pos(Laya.stage.width / 2 - btn.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
        });
    }));
}

function onclick() {
    currentState++;
    (currentState > 3) && (currentState = 0);
}