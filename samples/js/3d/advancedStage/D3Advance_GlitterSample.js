var Vector3 = Laya.Vector3;

var glitter;
var sampler = new GlitterStripSampler();
var scene;

//是否抗锯齿
//Config.isAntialias = true;
Laya3D.init(0, 0);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

scene = Laya.stage.addChild(new Laya.Scene());

scene.currentCamera = scene.addChild(new Laya.Camera(0, 1, 1000));
scene.currentCamera.transform.translate(new Vector3(0, 5, 10));
scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);


var setting = new Laya.GlitterSettings();
setting.texturePath = "../../res/threeDimen/layabox.png";
setting.lifeTime = 0.5;
setting.minSegmentDistance = 0.1;//最小距离，小于抛弃
setting.minInterpDistance = 0.6;//最大插值距离，超过则插值
setting.maxSlerpCount = 128;
setting.color = new Laya.Vector4(0.8, 0.6, 0.3, 0.8);
setting.maxSegments = 1000;

glitter = scene.addChild(new Laya.Glitter(setting));

Laya.timer.frameLoop(1, null, loop);

function loop() {
   	var projectViewMat = scene.currentCamera.projectionViewMatrix;
				sampler.getSampleP4();
				glitter.templet.addVertexPosition(sampler.pos1, sampler.pos2);
}
