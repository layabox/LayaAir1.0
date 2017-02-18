Laya3D.init(0, 0,true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var offset0 = new Laya.Vector3(0.01, 0, 0);
var offset1 = new Laya.Vector3(-0.01, 0, 0);
var totalOffset = 0;
var b = true;
var outPos = new Laya.Vector3();
var projectViewMat = new Laya.Matrix4x4();

var scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
camera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);

var mesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm")));
mesh.transform.localScale = new Laya.Vector3(0.5, 0.5, 0.5);


var monkey = new Laya.Image("../../res/apes/monkey2.png");
Laya.stage.addChild(monkey);

Laya.timer.frameLoop(1, null, function () {

    if (Math.abs(totalOffset) > 0.5)
        b = !b;

    if (b) {
        totalOffset += offset0.x;
        mesh.transform.translate(offset0);
    }
    else {
        totalOffset += offset1.x;
        mesh.transform.translate(offset1);
    }

    Laya.Matrix4x4.multiply(camera.projectionMatrix, camera.viewMatrix, projectViewMat);
    camera.viewport.project(mesh.transform.position, projectViewMat, outPos);
    monkey.pos(outPos.x, outPos.y);
});


