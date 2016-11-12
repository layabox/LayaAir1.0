Laya3D.init(0, 0);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var scene = Laya.stage.addChild(new Laya.Scene());
var camera = (scene.addChild(new Laya.Camera(0, 0.3, 1000)));
camera.transform.translate(new Laya.Vector3(0, 0, 100));
camera.clearColor = null;
camera.addComponent(CameraMoveScript);

var grid = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/grid/plane.lh"));
grid.transform.localScale = new Laya.Vector3(100, 100, 100);

var settingPath = "../../res/threeDimen/particle/shurikenParticle0.json";
Laya.loader.load(settingPath, Laya.Handler.create(null, function(setting) {
    var preBasePath = Laya.URL.basePath;
	Laya.URL.basePath = Laya.URL.getPath(Laya.URL.formatURL(settingPath));
    var particle = Laya.Utils3D.loadParticle(setting);
    Laya.URL.basePath = preBasePath;

    scene.addChild(particle);
//particle.transform.localScale = new Vector3(10, 10, 10);
}), null, Laya.Loader.JSON);