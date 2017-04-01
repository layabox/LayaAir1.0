Laya3D.init(0, 0,true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var Vector3 = Laya.Vector3;
var Vector4 = Laya.Vector4;
var scene = Laya.stage.addChild(new Laya.Scene());
var camera = scene.addChild(new Laya.Camera(0, 1, 1000));
camera.transform.translate(new Vector3(0, 5, 10));
camera.transform.rotate(new Vector3(-30, 0, 0), true, false);

var glitter = scene.addChild(new Laya.Glitter());
var glitterTemplet = glitter.templet;
glitter.glitterRender.sharedMaterial.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/layabox.png");
glitterTemplet.lifeTime = 0.5;
glitterTemplet.minSegmentDistance = 0.1;//最小距离，小于抛弃
glitterTemplet.minInterpDistance = 0.6;//最大插值距离，超过则插值
glitterTemplet.maxSlerpCount = 128;
glitterTemplet.color = new Vector4(0.8, 0.6, 0.3, 0.8);
glitterTemplet.maxSegments = 600;

Laya.timer.frameLoop(1, null, loop);
var sampler = new GlitterStripSampler();
function loop() {
   	var projectViewMat = camera.projectionViewMatrix;
	sampler.getSampleP4();
	glitter.templet.addVertexPosition(sampler.pos1, sampler.pos2);
}
