var CustomMesh = /** @class */ (function () {
    function CustomMesh() {
        this.curStateIndex = 0;
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(new Laya.Scene());
        this.color = new Laya.Vector4(0, 1, 0, 1);
        this.vertex1 = new Laya.Vector3();
        this.vertex2 = new Laya.Vector3();
        this.vertex3 = new Laya.Vector3();
        var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
        camera.transform.translate(new Laya.Vector3(0, 2, 5));
        camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
        var directionLight = scene.addChild(new Laya.DirectionLight());
        directionLight.color = new Laya.Vector3(0.6, 0.6, 0.6);
        directionLight.direction = new Laya.Vector3(1, -1, -1);
        this.sprite3D = scene.addChild(new Laya.Sprite3D());
        //平面
        var plane = this.sprite3D.addChild(new Laya.MeshSprite3D(new Laya.PlaneMesh(6, 6, 10, 10)));
        //正方体
        var box = this.sprite3D.addChild(new Laya.MeshSprite3D(new Laya.BoxMesh(0.5, 0.5, 0.5)));
        box.transform.position = new Laya.Vector3(1.5, 0.25, 0.6);
        box.transform.rotate(new Laya.Vector3(0, 45, 0), false, false);
        //球体
        var sphere = this.sprite3D.addChild(new Laya.MeshSprite3D(new Laya.SphereMesh(0.25)));
        sphere.transform.position = new Laya.Vector3(0.5, 0.25, 0.6);
        //圆柱体
        var cylinder = this.sprite3D.addChild(new Laya.MeshSprite3D(new Laya.CylinderMesh(0.25, 1)));
        cylinder.transform.position = new Laya.Vector3(-0.5, 0.5, 0.6);
        //胶囊体
        var capsule = this.sprite3D.addChild(new Laya.MeshSprite3D(new Laya.CapsuleMesh(0.25, 1)));
        capsule.transform.position = new Laya.Vector3(-1.5, 0.5, 0.6);
        this.phasorSpriter3D = new Laya.PhasorSpriter3D();
        Laya.timer.frameLoop(1, this, function () {
            this.sprite3D.active = !this.debugModel;
            if (this.debugModel) {
                this.phasorSpriter3D.begin(Laya.WebGLContext.LINES, camera);
                Tool.linearModel(this.sprite3D, this.phasorSpriter3D, this.color, this.vertex1, this.vertex2, this.vertex3);
                this.phasorSpriter3D.end();
            }
        });
        this.loadUI();
    }
    CustomMesh.prototype.loadUI = function () {
        Laya.loader.load(["../../res/threeDimen/ui/button.png"], Laya.Handler.create(this, function () {
            var changeActionButton = Laya.stage.addChild(new Laya.Button("../../res/threeDimen/ui/button.png", "正常模式"));
            changeActionButton.size(160, 40);
            changeActionButton.labelBold = true;
            changeActionButton.labelSize = 30;
            changeActionButton.sizeGrid = "4,4,4,4";
            changeActionButton.scale(Laya.Browser.pixelRatio, Laya.Browser.pixelRatio);
            changeActionButton.pos(Laya.stage.width / 2 - changeActionButton.width * Laya.Browser.pixelRatio / 2, Laya.stage.height - 100 * Laya.Browser.pixelRatio);
            changeActionButton.on(Laya.Event.CLICK, this, function () {
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
    };
    return CustomMesh;
}());
new CustomMesh;
