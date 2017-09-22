Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera(0, 0.1, 1000));
camera.transform.translate(new Laya.Vector3(0, 0.7, 1.3));
camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);

var directionLight = scene.addChild(new Laya.DirectionLight());
directionLight.direction = new Laya.Vector3(0, -0.8, -1);
directionLight.color = new Laya.Vector3(0.7, 0.6, 0.6);

Laya.loader.create("../../res/threeDimen/skinModel/dude/dude.lh", Laya.Handler.create(this, onComplete));

function onComplete() {

    var dude1 = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/dude/dude.lh"));
    dude1.transform.position = new Laya.Vector3(-0.6, 0, 0);

    var dude2 = Laya.Sprite3D.instantiate(dude1, scene, false, new Laya.Vector3(0.6, 0, 0));
    var skinnedMeshSprite3d = dude2.getChildAt(0).getChildAt(0);

    var specularMapUrl = [
        "../../res/threeDimen/skinModel/dude/Assets/dude/headS.png",
        "../../res/threeDimen/skinModel/dude/Assets/dude/jacketS.png",
        "../../res/threeDimen/skinModel/dude/Assets/dude/pantsS.png",
        "../../res/threeDimen/skinModel/dude/Assets/dude/upBodyS.png"
    ];

    for (var i = 0; i < skinnedMeshSprite3d.skinnedMeshRender.materials.length; i++) {

        var mat = skinnedMeshSprite3d.skinnedMeshRender.materials[i];
        //高光贴图
        mat.specularTexture = Laya.Texture2D.load(specularMapUrl[i]);
    }

    var rotation = new Laya.Vector3(0, 0.01, 0);

    Laya.timer.frameLoop(1, null, function () {
        dude1.transform.rotate(rotation);
        dude2.transform.rotate(rotation);
    });
}