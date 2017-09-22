class Sprite3DClone {
    private scene: Laya.Scene;
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

        this.scene = new Laya.Scene();
        Laya.stage.addChild(this.scene);

        var camera: Laya.Camera = this.scene.addChild(new Laya.Camera(0, 0.1, 100)) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 0.5, 1));
        camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);


        Laya.loader.create("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh", Laya.Handler.create(this, this.onComplete));
    }
    private onComplete(): void {

        var layaMonkey: Laya.Sprite3D = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Laya.Sprite3D;

        //克隆sprite3d
        var layaMonkey_clone1: Laya.Sprite3D = Laya.Sprite3D.instantiate(layaMonkey, this.scene, false, new Laya.Vector3(0.6, 0, 0));
        //克隆sprite3d
        var layaMonkey_clone2: Laya.Sprite3D = this.scene.addChild(Laya.Sprite3D.instantiate(layaMonkey, null, false, new Laya.Vector3(-0.6, 0, 0))) as Laya.Sprite3D;
    }
}
new Sprite3DClone;