class OrthographicCamera {
    private pos: Laya.Vector3 = new Laya.Vector3(310, 500, 0);
    private _translate: Laya.Vector3 = new Laya.Vector3(0, 0, 0);
    constructor() {
        Laya3D.init(1024, 768, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FIXED_HEIGHT;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var dialog: Laya.Image = Laya.stage.addChild(new Laya.Image("../../res/cartoon2/background.jpg")) as Laya.Image;

        var scene: Laya.Scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        var camera: Laya.Camera = scene.addChild(new Laya.Camera(0, 0.1, 1000)) as Laya.Camera;
        camera.transform.rotate(new Laya.Vector3(-45, 0, 0), false, false);
        camera.transform.translate(new Laya.Vector3(0, 0.5, 500));
        camera.orthographic = true;
        //正交投影垂直矩阵尺寸
        camera.orthographicVerticalSize = 10;

        var directionLight: Laya.DirectionLight = scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;

        var layaMonkey: Laya.Sprite3D = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Laya.Sprite3D;
        layaMonkey.once(Laya.Event.HIERARCHY_LOADED, this, function (): void {

            layaMonkey.transform.localScale = new Laya.Vector3(3, 3, 3);
            //转换2D屏幕坐标系统到3D正交投影下的坐标系统
            camera.convertScreenCoordToOrthographicCoord(this.pos, this._translate);
            layaMonkey.transform.position = this._translate;
                
            Laya.stage.on(Laya.Event.RESIZE, null, function():void {
                camera.convertScreenCoordToOrthographicCoord(this.pos, this._translate);
                layaMonkey.transform.position = this._translate;
            });

        });
    }
}
new OrthographicCamera;