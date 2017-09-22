var RayPicking01 = (function () {
    function RayPicking01() {
        this.ray = new Laya.Ray(new Laya.Vector3(0, 0, 0), new Laya.Vector3(0, 0, 0));
        this.point = new Laya.Vector2();
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(new Laya.Scene());
        this._outHitAllInfo = new Array();
        //初始化照相机
        this.camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
        this.camera.transform.translate(new Laya.Vector3(0, 2, 5));
        this.camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
        this.camera.clearColor = null;
        //方向光
        var directionLight = scene.addChild(new Laya.DirectionLight());
        directionLight.color = new Laya.Vector3(0.6, 0.6, 0.6);
        directionLight.direction = new Laya.Vector3(1, -1, -1);
        //平面
        var plane = scene.addChild(new Laya.MeshSprite3D(new Laya.PlaneMesh(6, 6, 10, 10)));
        var planeMat = new Laya.StandardMaterial();
        planeMat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
        planeMat.albedo = new Laya.Vector4(0.9, 0.9, 0.9, 1);
        plane.meshRender.material = planeMat;
        plane.addComponent(Laya.BoxCollider);
        plane.name = "平面";
        //正方体
        var box = scene.addChild(new Laya.MeshSprite3D(new Laya.BoxMesh(0.5, 0.5, 0.5)));
        var boxMat = new Laya.StandardMaterial();
        boxMat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
        box.meshRender.material = boxMat;
        box.transform.position = new Laya.Vector3(1.5, 0.25, 0.5);
        box.transform.rotate(new Laya.Vector3(0, 30, 0), false, false);
        box.addComponent(Laya.BoxCollider);
        box.name = "正方体";
        //球体
        var sphere = scene.addChild(new Laya.MeshSprite3D(new Laya.SphereMesh(0.25)));
        var sphereMat = new Laya.StandardMaterial();
        sphereMat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
        sphere.meshRender.material = sphereMat;
        sphere.transform.position = new Laya.Vector3(0.5, 0.25, 0.5);
        sphere.transform.rotate(new Laya.Vector3(0, 90, 0), false, false);
        sphere.addComponent(Laya.SphereCollider);
        sphere.name = "球体";
        //圆柱体
        var cylinder = scene.addChild(new Laya.MeshSprite3D(new Laya.CylinderMesh(0.25, 1)));
        var cylinderMat = new Laya.StandardMaterial();
        cylinderMat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
        cylinder.meshRender.material = cylinderMat;
        cylinder.transform.position = new Laya.Vector3(-0.5, 0.5, 0.5);
        cylinder.transform.rotate(new Laya.Vector3(0, -45, 0), false, false);
        cylinder.addComponent(Laya.MeshCollider);
        cylinder.name = "圆柱体";
        //胶囊体
        var capsule = scene.addChild(new Laya.MeshSprite3D(new Laya.CapsuleMesh(0.25, 1)));
        var capsuleMat = new Laya.StandardMaterial();
        capsuleMat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
        capsule.meshRender.material = capsuleMat;
        capsule.transform.position = new Laya.Vector3(-1.5, 0.5, 0.5);
        capsule.transform.rotate(new Laya.Vector3(0, -45, 0), false, false);
        capsule.addComponent(Laya.MeshCollider);
        capsule.name = "胶囊体";
        Laya.timer.frameLoop(1, this, this.checkHit);
        this.loadUI();
    }
    RayPicking01.prototype.checkHit = function () {
        //从屏幕空间生成射线
        this.point.elements[0] = Laya.MouseManager.instance.mouseX;
        this.point.elements[1] = Laya.MouseManager.instance.mouseY;
        this.camera.viewportPointToRay(this.point, this.ray);
        //射线检测获取所有检测碰撞到的物体
        Laya.Physics.rayCastAll(this.ray, this._outHitAllInfo, 30, 0);
    };
    RayPicking01.prototype.loadUI = function () {
        this.label = new Laya.Label();
        this.label.text = "点击选取的几何体";
        this.label.pos(Laya.Browser.clientWidth / 2.5, 100);
        this.label.fontSize = 50;
        this.label.color = "#40FF40";
        Laya.stage.addChild(this.label);
        //鼠标事件
        Laya.stage.on(Laya.Event.MOUSE_UP, this, function () {
            var str = "";
            for (var i = 0; i < this._outHitAllInfo.length; i++) {
                str += this._outHitAllInfo[i].sprite3D.name + "  ";
            }
            if (this._outHitAllInfo.length == 0) {
                str = "点击选取的几何体";
            }
            this.label.text = str;
        });
    };
    return RayPicking01;
}());
new RayPicking01;
