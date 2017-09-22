class OrthographicCamera {
    private translate: Laya.Vector3 = new Laya.Vector3(500, 500, 0);
    private rotation: Laya.Vector3 = new Laya.Vector3(0, 0.01, 0);
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var dialog: Laya.Image = Laya.stage.addChild(new Laya.Image("../../res/threeDimen/texture/earth.png")) as Laya.Image;

        var scene: Laya.Scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        var camera: Laya.Camera = scene.addChild(new Laya.Camera(0, 0.1, 1000)) as Laya.Camera;
        camera.transform.rotate(new Laya.Vector3(-30, 0, 0), false, false);
        camera.transform.translate(new Laya.Vector3(0, 0.5, 500));
        camera.orthographicProjection = true;

        var directionLight: Laya.DirectionLight = scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;

        var layaMonkey: Laya.Sprite3D = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Laya.Sprite3D;
        layaMonkey.once(Laya.Event.HIERARCHY_LOADED, this, function (): void {

            layaMonkey.transform.localScale = new Laya.Vector3(300, 300, 300);
            Laya.Utils3D.convert3DCoordTo2DScreenCoord(this.translate, this.translate);
            layaMonkey.transform.position = this.translate;
            Laya.timer.frameLoop(1, this, function (): void {
                layaMonkey.transform.rotate(this.rotation);
            });

        });

        Laya.stage.on(Laya.Event.RESIZE, this, function (): void {
            camera.orthographicVerticalSize = Laya.RenderState.clientHeight;
        });
    }
}
new OrthographicCamera;