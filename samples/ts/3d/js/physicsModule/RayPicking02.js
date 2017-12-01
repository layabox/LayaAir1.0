var RayPicking02 = /** @class */ (function () {
    function RayPicking02() {
        this.ray = new Laya.Ray(new Laya.Vector3(0, 0, 0), new Laya.Vector3(0, 0, 0));
        this.point = new Laya.Vector2();
        this._outHitInfo = new Laya.RaycastHit();
        this._position = new Laya.Vector3(0, 0, 0);
        this._offset = new Laya.Vector3(0, 0.25, 0);
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        this.scene = Laya.stage.addChild(new Laya.Scene());
        //初始化照相机
        this.camera = this.scene.addChild(new Laya.Camera(0, 0.1, 100));
        this.camera.transform.translate(new Laya.Vector3(0, 2, 5));
        this.camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
        this.camera.clearColor = null;
        //方向光
        var directionLight = this.scene.addChild(new Laya.DirectionLight());
        directionLight.color = new Laya.Vector3(0.6, 0.6, 0.6);
        directionLight.direction = new Laya.Vector3(1, -1, -1);
        //平面
        var plane = this.scene.addChild(new Laya.MeshSprite3D(new Laya.PlaneMesh(6, 6, 10, 10)));
        var planeMat = new Laya.StandardMaterial();
        planeMat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
        planeMat.albedo = new Laya.Vector4(0.9, 0.9, 0.9, 1);
        plane.meshRender.material = planeMat;
        var meshCollider = plane.addComponent(Laya.MeshCollider);
        meshCollider.mesh = plane.meshFilter.sharedMesh;
        Laya.timer.frameLoop(1, this, this.checkHit);
        this.loadUI();
    }
    RayPicking02.prototype.checkHit = function () {
        //从屏幕空间生成射线
        this.point.elements[0] = Laya.MouseManager.instance.mouseX;
        this.point.elements[1] = Laya.MouseManager.instance.mouseY;
        this.camera.viewportPointToRay(this.point, this.ray);
        Laya.Physics.rayCast(this.ray, this._outHitInfo, 30, 0);
    };
    RayPicking02.prototype.loadUI = function () {
        this.label = new Laya.Label();
        this.label.text = "点击放置";
        this.label.pos(Laya.Browser.clientWidth / 2.5, 100);
        this.label.fontSize = 50;
        this.label.color = "#40FF40";
        Laya.stage.addChild(this.label);
        //鼠标事件
        Laya.stage.on(Laya.Event.MOUSE_UP, this, function () {
            if (this._outHitInfo.distance !== -1) {
                var sphere = this.scene.addChild(new Laya.MeshSprite3D(new Laya.SphereMesh(0.25, 16, 16)));
                var mat = new Laya.StandardMaterial();
                mat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
                mat.albedo = new Laya.Vector4(Math.random(), Math.random(), Math.random(), 1);
                sphere.meshRender.material = mat;
                Laya.Vector3.add(this._outHitInfo.position, this._offset, this._position);
                sphere.transform.position = this._position;
                sphere.transform.rotate(new Laya.Vector3(0, 90, 0), false, false);
            }
        });
    };
    return RayPicking02;
}());
new RayPicking02;
