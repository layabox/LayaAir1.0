class CustomMesh {
    public sprite3D: Laya.Sprite3D;
    private curStateIndex: number = 0;
    private phasorSpriter3D: Laya.PhasorSpriter3D;
    private vertex1: Laya.Vector3;
    private vertex2: Laya.Vector3;
    private vertex3: Laya.Vector3;
    private color: Laya.Vector4;
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene: Laya.Scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        this.color = new Laya.Vector4(0, 1, 0, 1);
        this.vertex1 = new Laya.Vector3();
        this.vertex2 = new Laya.Vector3();
        this.vertex3 = new Laya.Vector3();

        var camera: Laya.Camera = scene.addChild(new Laya.Camera(0, 0.1, 100)) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 2, 5));
        camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);

        var directionLight: Laya.DirectionLight = scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;
        directionLight.color = new Laya.Vector3(0.6, 0.6, 0.6);
        directionLight.direction = new Laya.Vector3(1, -1, -1);

        this.sprite3D = scene.addChild(new Laya.Sprite3D()) as Laya.Sprite3D;

        //平面
        var plane: Laya.MeshSprite3D = this.sprite3D.addChild(new Laya.MeshSprite3D(new Laya.PlaneMesh(6, 6, 10, 10))) as Laya.MeshSprite3D;

        //正方体
        var box: Laya.MeshSprite3D = this.sprite3D.addChild(new Laya.MeshSprite3D(new Laya.BoxMesh(0.5, 0.5, 0.5))) as Laya.MeshSprite3D;
        box.transform.position = new Laya.Vector3(1.5, 0.25, 0.6);
        box.transform.rotate(new Laya.Vector3(0, 45, 0), false, false);

        //球体
        var sphere: Laya.MeshSprite3D = this.sprite3D.addChild(new Laya.MeshSprite3D(new Laya.SphereMesh(0.25))) as Laya.MeshSprite3D;
        sphere.transform.position = new Laya.Vector3(0.5, 0.25, 0.6);

        //圆柱体
        var cylinder: Laya.MeshSprite3D = this.sprite3D.addChild(new Laya.MeshSprite3D(new Laya.CylinderMesh(0.25, 1))) as Laya.MeshSprite3D;
        cylinder.transform.position = new Laya.Vector3(-0.5, 0.5, 0.6);

        //胶囊体
        var capsule: Laya.MeshSprite3D = this.sprite3D.addChild(new Laya.MeshSprite3D(new Laya.CapsuleMesh(0.25, 1))) as Laya.MeshSprite3D;
        capsule.transform.position = new Laya.Vector3(-1.5, 0.5, 0.6);

        this.phasorSpriter3D = new Laya.PhasorSpriter3D();
        Laya.timer.frameLoop(1, this, function (): void {

            this.sprite3D.active = !this.debugModel;
            if (this.debugModel) {
                this.phasorSpriter3D.begin(Laya.WebGLContext.LINES, camera);
                Tool.linearModel(this.sprite3D, this.phasorSpriter3D, this.color, this.vertex1, this.vertex2, this.vertex3);
                this.phasorSpriter3D.end();
            }
        });

        this.loadUI();
    }
    private loadUI(): void {

        Laya.loader.load(["res/threeDimen/ui/button.png"], Laya.Handler.create(this, function (): void {

            var changeActionButton: Laya.Button = Laya.stage.addChild(new Laya.Button("res/threeDimen/ui/button.png", "正常模式")) as Laya.Button;
            changeActionButton.size(160, 40);
            changeActionButton.labelBold = true;
            changeActionButton.labelSize = 30;
            changeActionButton.sizeGrid = "4,4,4,4";
            changeActionButton.scale(Laya.Browser.pixelRatio, Laya.Browser.pixelRatio);
            changeActionButton.pos(Laya.stage.width / 2 - changeActionButton.width * Laya.Browser.pixelRatio / 2, Laya.stage.height - 100 * Laya.Browser.pixelRatio);
            changeActionButton.on(Laya.Event.CLICK, this, function (): void {
                if (++this.curStateIndex % 2 == 1) {
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
new CustomMesh;