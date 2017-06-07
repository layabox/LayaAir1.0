Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var Vector3 = Laya.Vector3;
var rotation = new Vector3(0, 0.01, 0);

var scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera( 0, 0.1, 100));
camera.transform.translate(new Vector3(0, 0.8, 1.6));
camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
camera.addComponent(Laya.CameraMoveScript);

var directionLight = scene.addChild(new Laya.DirectionLight());
directionLight.direction = new Vector3(0, -0.8, -1);
directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
directionLight.specularColor = new Vector3(1.0, 1.0, 0.8);
directionLight.diffuseColor = new Vector3(1, 1, 1);

var root = scene.addChild(new Laya.Sprite3D());
root.transform.localScale = new Vector3(0.002, 0.002, 0.002);

loadModel("../../res/threeDimen/staticModel/lizardCal/lizardCaclute-lizard_geo.lm", "../../res/threeDimen/staticModel/lizardCal/lizard_norm.png");
loadModel("../../res/threeDimen/staticModel/lizardCal/lizardCaclute-eye_geo.lm", "../../res/threeDimen/staticModel/lizardCal/lizardeye_norm.png");
loadModel("../../res/threeDimen/staticModel/lizardCal/lizardCaclute-rock_geo.lm", "../../res/threeDimen/staticModel/lizardCal/rock_norm.png");
Laya.timer.frameLoop(1, null, function () {
    root.transform.rotate(rotation, true);
});

function loadModel(meshPath, normalMapPath) {
    var normalTexture;
    var material;

    var mesh = Laya.Mesh.load(meshPath);
    var meshSprite = root.addChild(new Laya.MeshSprite3D(mesh));

    //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
    mesh.once(Laya.Event.LOADED, null, function () {
        material = meshSprite.meshRender.sharedMaterials[0];
        (material && normalTexture) && (material.normalTexture = normalTexture);
    });

    Laya.loader.load(normalMapPath, Laya.Handler.create(null, function (texture) {
        normalTexture = texture;
        (material && normalTexture) && (material.normalTexture = normalTexture);
    }));
}