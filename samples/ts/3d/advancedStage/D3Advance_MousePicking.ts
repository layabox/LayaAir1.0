class MousePickingSample {
    constructor() {
        Laya3D.init(0, 0,true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        Laya.stage.addChild(new MousePickingScene());
    }
}
new MousePickingSample();