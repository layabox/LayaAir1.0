Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera(0, 0.1, 1000));
camera.transform.translate(new Laya.Vector3(0, 6, 10));
camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);

var glitter = scene.addChild(new Laya.Glitter());
var glitterTemplet = glitter.templet;
var glitterMaterial = glitter.glitterRender.sharedMaterial;
glitterMaterial.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/layabox.png");
glitterMaterial.albedo = new Laya.Vector4(1.3, 1.3, 1.3, 1);
glitterTemplet.lifeTime = 1.3;
glitterTemplet.minSegmentDistance = 0.1;
glitterTemplet.minInterpDistance = 0.6;
glitterTemplet.maxSlerpCount = 128;
glitterTemplet.maxSegments = 600;

var pos1 = new Laya.Vector3(0, 0, -0.5);
var pos2 = new Laya.Vector3(0, 0, 0.5);
var scaleDelta = 0;
var scaleValue = 0;
Laya.timer.frameLoop(1, this, loop);
function loop() {
    scaleValue = Math.sin(scaleDelta += 0.01);
    pos1.elements[0] = pos2.elements[0] = scaleValue * 13;
    pos1.elements[1] = Math.sin(scaleValue * 20) * 2;
    pos2.elements[1] = Math.sin(scaleValue * 20) * 2;
    glitter.addGlitterByPositions(pos1, pos2);
}