class RayPicking01 {
    private ray: Laya.Ray = new Laya.Ray(new Laya.Vector3(0, 0, 0), new Laya.Vector3(0, 0, 0));
    private point: Laya.Vector2 = new Laya.Vector2();
    private _outHitAllInfo: Array<Laya.RaycastHit>;

    private camera: Laya.Camera;
    private label: Laya.Label;
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene: Laya.Scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        this._outHitAllInfo = new Array<Laya.RaycastHit>();

        //初始化照相机
        this.camera = scene.addChild(new Laya.Camera(0, 0.1, 100)) as Laya.Camera;
        this.camera.transform.translate(new Laya.Vector3(0, 2, 5));
        this.camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
        this.camera.clearColor = null;

        //方向光
        var directionLight: Laya.DirectionLight = scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;
        directionLight.color = new Laya.Vector3(0.6, 0.6, 0.6);
        directionLight.direction = new Laya.Vector3(1, -1, -1);

        //平面
        var plane: Laya.MeshSprite3D = scene.addChild(new Laya.MeshSprite3D(new Laya.PlaneMesh(6, 6, 10, 10))) as Laya.MeshSprite3D;
        var planeMat: Laya.StandardMaterial = new Laya.StandardMaterial();
        planeMat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
        planeMat.albedo = new Laya.Vector4(0.9, 0.9, 0.9, 1);
        plane.meshRender.material = planeMat;
        var boxCollider = plane.addComponent(Laya.BoxCollider) as Laya.BoxCollider;
        boxCollider.setFromBoundBox(plane.meshFilter.sharedMesh.boundingBox);
        plane.name = "平面";

        //正方体
        var box: Laya.MeshSprite3D = scene.addChild(new Laya.MeshSprite3D(new Laya.BoxMesh(0.5, 0.5, 0.5))) as Laya.MeshSprite3D;
        var boxMat: Laya.StandardMaterial = new Laya.StandardMaterial();
        boxMat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
        box.meshRender.material = boxMat;
        box.transform.position = new Laya.Vector3(1.5, 0.25, 0.5);
        box.transform.rotate(new Laya.Vector3(0, 30, 0), false, false);
        var boxCollider1:BoxCollider = box.addComponent(Laya.BoxCollider) as Laya.BoxCollider;
        boxCollider1.setFromBoundBox(box.meshFilter.sharedMesh.boundingBox);
        box.name = "正方体";

        //球体
        var sphere: Laya.MeshSprite3D = scene.addChild(new Laya.MeshSprite3D(new Laya.SphereMesh(0.25))) as Laya.MeshSprite3D;
        var sphereMat: Laya.StandardMaterial = new Laya.StandardMaterial();
        sphereMat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
        sphere.meshRender.material = sphereMat;
        sphere.transform.position = new Laya.Vector3(0.5, 0.25, 0.5);
        sphere.transform.rotate(new Laya.Vector3(0, 90, 0), false, false);
        var sphereCollider = sphere.addComponent(Laya.SphereCollider) as Laya.SphereCollider;
        sphereCollider.center = sphere.meshFilter.sharedMesh.boundingSphere.center.clone();
        sphereCollider.radius = sphere.meshFilter.sharedMesh.boundingSphere.radius;
        sphere.name = "球体";

        //圆柱体
        var cylinder: Laya.MeshSprite3D = scene.addChild(new Laya.MeshSprite3D(new Laya.CylinderMesh(0.25, 1))) as Laya.MeshSprite3D;
        var cylinderMat: Laya.StandardMaterial = new Laya.StandardMaterial();
        cylinderMat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
        cylinder.meshRender.material = cylinderMat;
        cylinder.transform.position = new Laya.Vector3(-0.5, 0.5, 0.5);
        cylinder.transform.rotate(new Laya.Vector3(0, -45, 0), false, false);
        var cylinderMeshCollider = cylinder.addComponent(Laya.MeshCollider) as Laya.MeshCollider;
        cylinderMeshCollider.mesh = cylinder.meshFilter.sharedMesh;
        cylinder.name = "圆柱体";

        //胶囊体
        var capsule: Laya.MeshSprite3D = scene.addChild(new Laya.MeshSprite3D(new Laya.CapsuleMesh(0.25, 1))) as Laya.MeshSprite3D;
        var capsuleMat: Laya.StandardMaterial = new Laya.StandardMaterial();
        capsuleMat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
        capsule.meshRender.material = capsuleMat;
        capsule.transform.position = new Laya.Vector3(-1.5, 0.5, 0.5);
        capsule.transform.rotate(new Laya.Vector3(0, -45, 0), false, false);
        var capsuleMeshCollider = capsule.addComponent(Laya.MeshCollider) as Laya.MeshCollider;
        capsuleMeshCollider.mesh = capsule.meshFilter.sharedMesh;
        capsule.name = "胶囊体";

        Laya.timer.frameLoop(1, this, this.checkHit);

        this.loadUI();
    }
    private checkHit(): void {
        //从屏幕空间生成射线
        this.point.elements[0] = Laya.MouseManager.instance.mouseX;
        this.point.elements[1] = Laya.MouseManager.instance.mouseY;
        this.camera.viewportPointToRay(this.point, this.ray);

        //射线检测获取所有检测碰撞到的物体
        Laya.Physics.rayCastAll(this.ray, this._outHitAllInfo, 30, 0);
    }

    private loadUI(): void {

        this.label = new Laya.Label();
        this.label.text = "点击选取的几何体";
        this.label.pos(Laya.Browser.clientWidth / 2.5, 100);
        this.label.fontSize = 50;
        this.label.color = "#40FF40";
        Laya.stage.addChild(this.label);

        //鼠标事件
        Laya.stage.on(Laya.Event.MOUSE_UP, this, function (): void {
            var str: String = "";
            for (var i: number = 0; i < this._outHitAllInfo.length; i++) {
                str += this._outHitAllInfo[i].sprite3D.name + "  ";
            }
            if (this._outHitAllInfo.length == 0) {
                str = "点击选取的几何体";
            }
            this.label.text = str;
        });
    }
}
new RayPicking01;