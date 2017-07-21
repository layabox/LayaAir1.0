Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera(0, 0.1, 1000));
camera.transform.translate(new Laya.Vector3(0, 1.5, 4));
camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);

var directionLight = scene.addChild(new Laya.DirectionLight());
directionLight.direction = new Laya.Vector3(0, -0.8, -1);
directionLight.ambientColor = new Laya.Vector3(0.7, 0.6, 0.6);
directionLight.specularColor = new Laya.Vector3(0.4, 0.4, 0.3);
directionLight.diffuseColor = new Laya.Vector3(1, 1, 1);

var plane = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/Zombie/new/Plane.lh"));

var zombie = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/Zombie/new/Zombie.lh"));
zombie.once(Laya.Event.HIERARCHY_LOADED, this, function () {
    //获取Animator动画组件
    zombieAnimator = zombie.getChildAt(0).getComponentByType(Laya.Animator);
    loadUI();
});

function loadUI() {
    var clipName = ["walk","attack","left_fall","right_fall","back_fall"];
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
            //根据名称播放动画
            zombieAnimator.play(clipName[++curStateIndex % clipName.length]);
        });
    }));
}