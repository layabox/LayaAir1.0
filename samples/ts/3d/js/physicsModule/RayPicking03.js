var RayPicking03 = (function () {
    function RayPicking03() {
        this.point = new Laya.Vector2();
        this._offsetVector3 = new Laya.Vector3(0, 0.25, 0);
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(new Laya.Scene());
        this.point = new Laya.Vector2();
        this.ray = new Laya.Ray(new Laya.Vector3(0, 0, 0), new Laya.Vector3(0, 0, 0));
        this._outHitInfo = new Laya.RaycastHit();
        this._position = new Laya.Vector3(0, 0.25, 0);
        this._upVector3 = new Laya.Vector3(0, 1, 0);
        this._quaternion = new Laya.Quaternion();
        this._vector3 = new Laya.Vector3();
        this._offsetVector3 = new Laya.Vector3(0, 0.25, 0);
        //初始化照相机
        this.camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
        this.camera.transform.translate(new Laya.Vector3(0, 2, 5));
        this.camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
        this.camera.clearColor = null;
        //方向光
        var directionLight = scene.addChild(new Laya.DirectionLight());
        directionLight.color = new Laya.Vector3(0.6, 0.6, 0.6);
        directionLight.direction = new Laya.Vector3(1, -1, -1);
        var plane = scene.addChild(new Laya.MeshSprite3D(new Laya.PlaneMesh(6, 6, 10, 10)));
        var planeMat = new Laya.StandardMaterial();
        planeMat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
        planeMat.albedo = new Laya.Vector4(0.9, 0.9, 0.9, 1);
        plane.meshRender.material = planeMat;
        plane.addComponent(Laya.MeshCollider);
        this.box = scene.addChild(new Laya.MeshSprite3D(new Laya.BoxMesh(0.5, 0.5, 0.5)));
        var mat = new Laya.StandardMaterial();
        mat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
        this.box.meshRender.material = mat;
        this.box.transform.position = this._position;
        Laya.timer.frameLoop(1, this, this.checkHit);
        this.loadUI();
    }
    RayPicking03.prototype.checkHit = function () {
        this.box.transform.position = this._position;
        this.box.transform.rotation = this._quaternion;
        //从屏幕空间生成射线
        this.point.elements[0] = Laya.MouseManager.instance.mouseX;
        this.point.elements[1] = Laya.MouseManager.instance.mouseY;
        this.camera.viewportPointToRay(this.point, this.ray);
        Laya.Physics.rayCast(this.ray, this._outHitInfo, 30, 0);
    };
    RayPicking03.prototype.loadUI = function () {
        this.label = new Laya.Label();
        this.label.text = "点击移动";
        this.label.pos(Laya.Browser.clientWidth / 2.5, 100);
        this.label.fontSize = 50;
        this.label.color = "#40FF40";
        Laya.stage.addChild(this.label);
        //鼠标事件
        Laya.stage.on(Laya.Event.MOUSE_UP, this, function () {
            if (this._outHitInfo.distance !== -1) {
                Laya.Vector3.add(this._outHitInfo.position, this._offsetVector3, this._vector3);
                Laya.Tween.to(this._position, { x: this._vector3.x, y: this._vector3.y, z: this._vector3.z }, 500 /**,Ease.circIn*/);
                Laya.Quaternion.lookAt(this.box.transform.position, this._vector3, this._upVector3, this._quaternion);
            }
        });
    };
    return RayPicking03;
}());
new RayPicking03;
