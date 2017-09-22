class MeshLoad {
    private debugModel: boolean;
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

        var scene = Laya.stage.addChild(new Laya.Scene());

        var camera: Laya.Camera = scene.addChild(new Laya.Camera(0, 0.1, 100)) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
        camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);

        var directionLight: Laya.DirectionLight = scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;
        directionLight.color = new Laya.Vector3(0.6, 0.6, 0.6);
        directionLight.direction = new Laya.Vector3(1, -1, -1);

        //加载网格
        var layaMonkey: Laya.MeshSprite3D = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/LayaMonkey/Assets/LayaMonkey/LayaMonkey-LayaMonkey.lm"))) as Laya.MeshSprite3D;
        layaMonkey.transform.localScale = new Laya.Vector3(0.3, 0.3, 0.3);
        layaMonkey.transform.rotation = new Laya.Quaternion(0.7071068, 0, 0, -0.7071067);

        var rotation = new Laya.Vector3(0, 0.01, 0);
        this.debugModel = false;
        var phasorSpriter3D = new Laya.PhasorSpriter3D();
        var vertex1 = new Laya.Vector3();
        var vertex2 = new Laya.Vector3();
        var vertex3 = new Laya.Vector3();
        var color = new Laya.Vector4(0, 1, 0, 1);

        Laya.timer.frameLoop(1, this, function () {

            layaMonkey.active = !this.debugModel;
            layaMonkey.transform.rotate(rotation, false);

            if (this.debugModel) {
                phasorSpriter3D.begin(Laya.WebGLContext.LINES, camera);
                Tool.linearModel(layaMonkey, phasorSpriter3D, color, vertex1, vertex2, vertex3);
                phasorSpriter3D.end();
            }
        });
        this.loadUI();
    }
    private loadUI(): void {
        var curStateIndex = 0;
        Laya.loader.load(["../../res/threeDimen/ui/button.png"], Laya.Handler.create(this, function () {
            var changeActionButton: Laya.Button = Laya.stage.addChild(new Laya.Button("../../res/threeDimen/ui/button.png", "正常模式")) as Laya.Button;
            changeActionButton.size(160, 40);
            changeActionButton.labelBold = true;
            changeActionButton.labelSize = 30;
            changeActionButton.sizeGrid = "4,4,4,4";
            changeActionButton.scale(Laya.Browser.pixelRatio, Laya.Browser.pixelRatio);
            changeActionButton.pos(Laya.stage.width / 2 - changeActionButton.width * Laya.Browser.pixelRatio / 2, Laya.stage.height - 100 * Laya.Browser.pixelRatio);
            changeActionButton.on(Laya.Event.CLICK, this, function () {
                if (++curStateIndex % 2 == 1) {
                    this.debugModel = true;
                    changeActionButton.label = "网格模式";
                }
                else {
                    this.debugModel = false;
                    changeActionButton.label = "正常模式";
                }
            });
        }));
    }
}
new MeshLoad;