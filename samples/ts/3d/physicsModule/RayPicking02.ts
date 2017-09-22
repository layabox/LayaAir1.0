class RayPicking02 {
    private ray: Laya.Ray = new Laya.Ray(new Laya.Vector3(0, 0, 0), new Laya.Vector3(0, 0, 0));
    private point: Laya.Vector2 = new Laya.Vector2();
    private _outHitInfo: Laya.RaycastHit = new Laya.RaycastHit();
    private _position: Laya.Vector3 = new Laya.Vector3(0, 0, 0);
    private _offset: Laya.Vector3 = new Laya.Vector3(0, 0.25, 0);

    private scene: Laya.Scene;
    private camera: Laya.Camera;
    private label: Laya.Label;
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        this.scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        //初始化照相机
        this.camera = this.scene.addChild(new Laya.Camera(0, 0.1, 100)) as Laya.Camera;
        this.camera.transform.translate(new Laya.Vector3(0, 2, 5));
        this.camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
        this.camera.clearColor = null;

        //方向光
        var directionLight: Laya.DirectionLight = this.scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;
        directionLight.color = new Laya.Vector3(0.6, 0.6, 0.6);
        directionLight.direction = new Laya.Vector3(1, -1, -1);

        //平面
        var plane: Laya.MeshSprite3D = this.scene.addChild(new Laya.MeshSprite3D(new Laya.PlaneMesh(6, 6, 10, 10))) as Laya.MeshSprite3D;
        var planeMat: Laya.StandardMaterial = new Laya.StandardMaterial();
        planeMat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
        planeMat.albedo = new Laya.Vector4(0.9, 0.9, 0.9, 1);
        plane.meshRender.material = planeMat;
        plane.addComponent(Laya.MeshCollider);

        Laya.timer.frameLoop(1, this, this.checkHit);

        this.loadUI();
    }

    private checkHit(): void {

        //从屏幕空间生成射线
        this.point.elements[0] = Laya.MouseManager.instance.mouseX;
        this.point.elements[1] = Laya.MouseManager.instance.mouseY;
        this.camera.viewportPointToRay(this.point, this.ray);

        Laya.Physics.rayCast(this.ray, this._outHitInfo, 30, 0);
    }
    private loadUI(): void {

        this.label = new Laya.Label();
        this.label.text = "点击放置";
        this.label.pos(Laya.Browser.clientWidth / 2.5, 100);
        this.label.fontSize = 50;
        this.label.color = "#40FF40";
        Laya.stage.addChild(this.label);

        //鼠标事件
        Laya.stage.on(Laya.Event.MOUSE_UP, this, function (): void {

            if (this._outHitInfo.distance !== -1) {
                var sphere: Laya.MeshSprite3D = this.scene.addChild(new Laya.MeshSprite3D(new Laya.SphereMesh(0.25, 16, 16))) as Laya.MeshSprite3D;
                var mat: Laya.StandardMaterial = new Laya.StandardMaterial();
                mat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
                mat.albedo = new Laya.Vector4(Math.random(), Math.random(), Math.random(), 1);
                sphere.meshRender.material = mat;
                Laya.Vector3.add(this._outHitInfo.position, this._offset, this._position);
                sphere.transform.position = this._position;
                sphere.transform.rotate(new Laya.Vector3(0, 90, 0), false, false);
            }
        });
    }
}
new RayPicking02