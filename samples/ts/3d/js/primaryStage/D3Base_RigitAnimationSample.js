var D3Base_RigitAnimationSample = (function () {
    function D3Base_RigitAnimationSample() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        this.scene = Laya.stage.addChild(new Laya.Scene());
        this.scene.currentCamera = (this.scene.addChild(new Laya.Camera(0, 0.1, 1000)));
        this.scene.currentCamera.transform.translate(new Laya.Vector3(0, 16.8, 26.0));
        this.scene.currentCamera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        this.scene.currentCamera.clearColor = null;
        this.effectSprite = this.scene.addChild(new Laya.Sprite3D());
        this.effectSprite.once(Laya.Event.HIERARCHY_LOADED, this, function (sender, sprite3D) {
            var rootAnimations = sprite3D.addComponent(Laya.RigidAnimations);
            rootAnimations.url = "../../res/threeDimen/staticModel/effect/WuShen/WuShen.lani";
            rootAnimations.play(0);
        });
        this.effectSprite.loadHierarchy("../../res/threeDimen/staticModel/effect/WuShen/WuShen.lh");
    }
    return D3Base_RigitAnimationSample;
}());
new D3Base_RigitAnimationSample();
