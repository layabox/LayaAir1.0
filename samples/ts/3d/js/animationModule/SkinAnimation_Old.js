var SkinAnimation_Old = /** @class */ (function () {
    function SkinAnimation_Old() {
        this.curStateIndex = 0;
        this.skinAniUrl = [
            "../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@walk-walk.lsani",
            "../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@attack-attack.lsani",
            "../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@left_fall-left_fall.lsani",
            "../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@right_fall-right_fall.lsani",
            "../../res/threeDimen/skinModel/Zombie/old/Assets/Zombie/Model/z@back_fall-back_fall.lsani"
        ];
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(new Laya.Scene());
        var camera = (scene.addChild(new Laya.Camera(0, 0.01, 1000)));
        camera.transform.translate(new Laya.Vector3(0, 1.5, 3));
        camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
        var directionLight = scene.addChild(new Laya.DirectionLight());
        directionLight.direction = new Laya.Vector3(0, -0.8, -1);
        directionLight.color = new Laya.Vector3(1, 1, 1);
        var plane = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/Zombie/old/Plane.lh"));
        this.zombie = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/Zombie/old/Zombie.lh"));
        this.zombie.once(Laya.Event.HIERARCHY_LOADED, this, function () {
            this.zombie.transform.rotation = new Laya.Quaternion(-0.7071068, 0, 0, -0.7071068);
            this.zombie.transform.position = new Laya.Vector3(0.3, 0, 0);
            this.addSkinComponent(this.zombie);
            this.loadUI();
        });
    }
    //遍历节点,添加SkinAnimation动画组件
    SkinAnimation_Old.prototype.addSkinComponent = function (spirit3D) {
        if (spirit3D instanceof Laya.MeshSprite3D) {
            var meshSprite3D = spirit3D;
            var skinAni = meshSprite3D.addComponent(Laya.SkinAnimations);
            skinAni.templet = Laya.AnimationTemplet.load(this.skinAniUrl[0]);
            skinAni.player.play();
        }
        for (var i = 0, n = spirit3D._childs.length; i < n; i++)
            this.addSkinComponent(spirit3D._childs[i]);
    };
    //遍历节点,播放动画
    SkinAnimation_Old.prototype.playSkinAnimation = function (spirit3D, index) {
        if (spirit3D instanceof Laya.MeshSprite3D) {
            var meshSprite3D = spirit3D;
            var skinAni = meshSprite3D.getComponentByType(Laya.SkinAnimations);
            skinAni.templet = Laya.AnimationTemplet.load(this.skinAniUrl[index]);
            skinAni.player.play();
        }
        for (var i = 0, n = spirit3D._childs.length; i < n; i++)
            this.playSkinAnimation(spirit3D._childs[i], index);
    };
    SkinAnimation_Old.prototype.loadUI = function () {
        Laya.loader.load(["../../res/threeDimen/ui/button.png"], Laya.Handler.create(this, function () {
            this.changeActionButton = Laya.stage.addChild(new Laya.Button("../../res/threeDimen/ui/button.png", "切换动作"));
            this.changeActionButton.size(160, 40);
            this.changeActionButton.labelBold = true;
            this.changeActionButton.labelSize = 30;
            this.changeActionButton.sizeGrid = "4,4,4,4";
            this.changeActionButton.scale(Laya.Browser.pixelRatio, Laya.Browser.pixelRatio);
            this.changeActionButton.pos(Laya.stage.width / 2 - this.changeActionButton.width * Laya.Browser.pixelRatio / 2, Laya.stage.height - 100 * Laya.Browser.pixelRatio);
            this.changeActionButton.on(Laya.Event.CLICK, this, function () {
                this.playSkinAnimation(this.zombie, ++this.curStateIndex % this.skinAniUrl.length);
            });
        }));
    };
    return SkinAnimation_Old;
}());
new SkinAnimation_Old;
