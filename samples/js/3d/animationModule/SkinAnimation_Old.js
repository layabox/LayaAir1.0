Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera(0, 0.1, 1000));
camera.transform.translate(new Laya.Vector3(0, 1.5, 3));
camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);

var directionLight = scene.addChild(new Laya.DirectionLight());
directionLight.direction = new Laya.Vector3(0, -0.8, -1);
directionLight.ambientColor = new Laya.Vector3(0.7, 0.6, 0.6);
directionLight.specularColor = new Laya.Vector3(0.4, 0.4, 0.3);
directionLight.diffuseColor = new Laya.Vector3(1, 1, 1);

var plane = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/Zombie/old/Plane.lh"));

var zombie = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/Zombie/old/Zombie.lh"));
zombie.once(Laya.Event.HIERARCHY_LOADED, this, function () {
    zombie.transform.rotation = new Laya.Quaternion(-0.7071068, 0, 0, -0.7071068);
    zombie.transform.position = new Laya.Vector3(0.3, 0, 0);
    addSkinComponent(zombie);
    loadUI();
});

var skinAniUrl = [
    "../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@walk-walk.lsani",
    "../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@attack-attack.lsani",
    "../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@left_fall-left_fall.lsani",
    "../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@right_fall-right_fall.lsani",
    "../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@back_fall-back_fall.lsani"
];

//遍历节点,添加SkinAnimation动画组件
function addSkinComponent(spirit3D) {

    if (spirit3D instanceof Laya.MeshSprite3D) {
        var meshSprite3D = spirit3D;
        var skinAni = meshSprite3D.addComponent(Laya.SkinAnimations);
        skinAni.templet = Laya.AnimationTemplet.load(skinAniUrl[0]);
        skinAni.player.play();
    }
    for (var i = 0, n = spirit3D._childs.length; i < n; i++)
        addSkinComponent(spirit3D._childs[i]);
}

//遍历节点,播放动画
function playSkinAnimation(spirit3D, index) {

    if (spirit3D instanceof Laya.MeshSprite3D) {
        var meshSprite3D = spirit3D;
        var skinAni = meshSprite3D.getComponentByType(Laya.SkinAnimations);
        skinAni.templet = Laya.AnimationTemplet.load(skinAniUrl[index]);
        skinAni.player.play();
    }
    for (var i = 0, n = spirit3D._childs.length; i < n; i++)
        playSkinAnimation(spirit3D._childs[i], index);
}

function loadUI() {

    var curStateIndex = 0;

    Laya.loader.load(["../../res/threeDimen/ui/button.png"], Laya.Handler.create(null, function () {

        changeActionButton = Laya.stage.addChild(new Laya.Button("../../res/threeDimen/ui/button.png", "切换动作"));
        changeActionButton.size(160, 40);
        changeActionButton.labelBold = true;
        changeActionButton.labelSize = 30;
        changeActionButton.sizeGrid = "4,4,4,4";
        changeActionButton.scale(Laya.Browser.pixelRatio, Laya.Browser.pixelRatio);
        changeActionButton.pos(Laya.stage.width / 2 - changeActionButton.width * Laya.Browser.pixelRatio / 2, Laya.stage.height - 100 * Laya.Browser.pixelRatio);
        changeActionButton.on(Laya.Event.CLICK, this, function () {
            playSkinAnimation(zombie, ++curStateIndex % skinAniUrl.length);
        });
    }));
}