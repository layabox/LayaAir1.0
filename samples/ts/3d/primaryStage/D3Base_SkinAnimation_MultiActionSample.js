var SkinAnimation_MultiActionSample = (function () {
    function SkinAnimation_MultiActionSample() {
        this.currentState = 0;
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        this.loadUI();
        var scene = Laya.stage.addChild(new Laya.Scene());
        var camera = (scene.addChild(new Laya.Camera(0, 0.1, 100)));
        camera.transform.translate(new Laya.Vector3(0, 2.2, 3.0));
        camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        camera.clearColor = null;
        var directionLight = scene.addChild(new Laya.DirectionLight());
        directionLight.direction = new Laya.Vector3(0, -0.8, -1);
        directionLight.ambientColor = new Laya.Vector3(0.7, 0.6, 0.6);
        directionLight.specularColor = new Laya.Vector3(2.0, 2.0, 1.6);
        directionLight.diffuseColor = new Laya.Vector3(1, 1, 1);
        scene.shadingMode = Laya.BaseScene.PIXEL_SHADING;
        var rootSkinMesh = scene.addChild(new Laya.Sprite3D());
        var skinMesh0 = rootSkinMesh.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT0.lm")));
        var skinMesh1 = rootSkinMesh.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT1.lm")));
        var skinMesh2 = rootSkinMesh.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT2.lm")));
        var skinMesh3 = rootSkinMesh.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT3.lm")));
        this.skinAni0 = skinMesh0.addComponent(Laya.SkinAnimations);
        this.skinAni0.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
        this.skinAni0.player.play(0, 0.6);
        this.skinAni1 = skinMesh1.addComponent(Laya.SkinAnimations);
        this.skinAni1.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
        this.skinAni1.player.play(0, 0.6);
        this.skinAni2 = skinMesh2.addComponent(Laya.SkinAnimations);
        this.skinAni2.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
        this.skinAni2.player.play(0, 0.6);
        this.skinAni3 = skinMesh3.addComponent(Laya.SkinAnimations);
        this.skinAni3.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
        this.skinAni3.player.play(0, 0.6);
    }
    SkinAnimation_MultiActionSample.prototype.loadUI = function () {
        var _this = this;
        Laya.loader.load(["../../res/threeDimen/ui/button.png"], Laya.Handler.create(null, function () {
            var btn = new Laya.Button();
            btn.skin = "../../res/threeDimen/ui/button.png";
            btn.label = "切换动作";
            btn.labelBold = true;
            btn.labelSize = 20;
            btn.sizeGrid = "4,4,4,4";
            btn.size(120, 30);
            btn.scale(Laya.Browser.pixelRatio, Laya.Browser.pixelRatio);
            btn.pos(Laya.stage.width / 2 - btn.width * Laya.Browser.pixelRatio / 2, Laya.stage.height - 50 * Laya.Browser.pixelRatio);
            btn.strokeColors = "#ff0000,#ffff00,#00ffff";
            btn.on(Laya.Event.CLICK, _this, _this.onclick);
            Laya.stage.addChild(btn);
            Laya.stage.on(Laya.Event.RESIZE, null, function () {
                btn.pos(Laya.stage.width / 2 - btn.width * Laya.Browser.pixelRatio / 2, Laya.stage.height - 50 * Laya.Browser.pixelRatio);
            });
        }));
    };
    SkinAnimation_MultiActionSample.prototype.onclick = function () {
        switch (this.currentState) {
            case 0:
                this.skinAni0.url = "../../res/threeDimen/skinModel/nvXia/yequanaidanv.ani";
                this.skinAni0.player.play();
                this.skinAni1.url = "../../res/threeDimen/skinModel/nvXia/yequanaidanv.ani";
                this.skinAni1.player.play();
                this.skinAni2.url = "../../res/threeDimen/skinModel/nvXia/yequanaidanv.ani";
                this.skinAni2.player.play();
                this.skinAni3.url = "../../res/threeDimen/skinModel/nvXia/yequanaidanv.ani";
                this.skinAni3.player.play();
                break;
            case 1:
                this.skinAni0.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
                this.skinAni0.player.play(0, 0.6);
                this.skinAni1.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
                this.skinAni1.player.play(0, 0.6);
                this.skinAni2.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
                this.skinAni2.player.play(0, 0.6);
                this.skinAni3.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
                this.skinAni3.player.play(0, 0.6);
                break;
        }
        this.currentState++;
        (this.currentState > 1) && (this.currentState = 0);
    };
    return SkinAnimation_MultiActionSample;
}());
new SkinAnimation_MultiActionSample();
