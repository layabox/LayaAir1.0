class MousePickingScene extends Laya.Scene {

    private curLabel:Laya.Label;
    private ray:Laya.Ray = new Laya.Ray(new Laya.Vector3(0, 0, 0), new Laya.Vector3(0, 0, 0));
    private point:Laya.Vector2 = new Laya.Vector2();
    private camera:Laya.Camera;

    private sprite3d1:Laya.MeshSprite3D;
    private sprite3d2:Laya.MeshSprite3D;
    private sprite3d3:Laya.MeshSprite3D;
    private sprite3d4:Laya.MeshSprite3D;

    private _outHitInfo:Laya.RaycastHit = new Laya.RaycastHit();
    private _outHitAllInfo:Array<Laya.RaycastHit> = new Array<Laya.RaycastHit>();
    private _posiV3:Laya.Vector3 = new Laya.Vector3();
    private _scaleV3:Laya.Vector3 = new Laya.Vector3();
    private _rotaV3:Laya.Vector3 = new Laya.Vector3(0, 1, 0);

    private phasorSpriter3D:Laya.PhasorSpriter3D = new Laya.PhasorSpriter3D();

    private sphereSprite3d:Laya.MeshSprite3D;
    private sphereMesh:Laya.SphereMesh;
    private obb:Laya.OrientedBoundBox;
    private sphere:Laya.BoundSphere;
    private _corners:Array<Laya.Vector3> = new Array<Laya.Vector3>();
    private _scale:number = 1;
    private _scaleIndex:number = -1;

    private str1:string = "女巫 : 爱上一只村民 , 可惜家里没有 … … (MeshCollider)";
    private str2:string = "村民 : 谁说癞蛤蟆吃不到天鹅肉，哼 ~  (MeshCollider)";
    private str3:string = "小飞龙 : 别摸我，烦着呢 ！ (SphereCollider)";
    private str4:string = "死胖子 : 不吃饱哪有力气减肥？ (BoxCollider)";
    private str5:string = "旁白 : 秀恩爱，死得快！ (MeshCollider)";

    constructor(label:Laya.Label) {

        super();

        this.curLabel = label;

        this._corners[0] = new Laya.Vector3();
        this._corners[1] = new Laya.Vector3();
        this._corners[2] = new Laya.Vector3();
        this._corners[3] = new Laya.Vector3();
        this._corners[4] = new Laya.Vector3();
        this._corners[5] = new Laya.Vector3();
        this._corners[6] = new Laya.Vector3();
        this._corners[7] = new Laya.Vector3();

        //初始化照相机
        this.camera = this.addChild(new Laya.Camera(0, 0.1, 100)) as Laya.Camera;
        this.camera.transform.translate(new Laya.Vector3(0, 1, 3));
        //camera.addComponent(CameraMoveScript);
        this.camera.clearColor = null;

        //添加精灵到场景
        this.sprite3d1 = this.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/NvWu/NvWu-shenminvwu.lm"))) as Laya.MeshSprite3D;
        this.sprite3d2 = this.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/CunMinNan/CunMinNan-cunminnan.lm"))) as Laya.MeshSprite3D;
        this.sprite3d3 = this.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/XiaoFeiLong/XiaoFeiLong-xiaofeilong.lm"))) as Laya.MeshSprite3D;
        this.sprite3d4 = this.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/PangZi/PangZi-doubipangzi.lm"))) as Laya.MeshSprite3D;

        this.sprite3d1.transform.position = new Laya.Vector3(-0.6, 0, -0.2);
        this.sprite3d2.transform.position = new Laya.Vector3(0.1, 0, 0);
        this.sprite3d3.transform.position = new Laya.Vector3(-2.3, 0, 0);
        this.sprite3d4.transform.position = new Laya.Vector3(1.8, 0, 0);

        this.sprite3d1.name = this.str1;
        this.sprite3d2.name = this.str2;
        this.sprite3d3.name = this.str3;
        this.sprite3d4.name = this.str4;

        //指定精灵的层
        this.sprite3d1.layer = Laya.Layer.getLayerByNumber(10);
        this.sprite3d2.layer = Laya.Layer.getLayerByNumber(10);
        this.sprite3d3.layer = Laya.Layer.getLayerByNumber(13);
        this.sprite3d4.layer = Laya.Layer.getLayerByNumber(13);

        /**
         * 给精灵添加碰撞器组件
         * BoxCollider    : 盒型碰撞器
         * SphereCollider : 球型碰撞器
         * MeshCollider   : 网格碰撞器
         */
        this.sprite3d1.addComponent(Laya.MeshCollider);
        this.sprite3d2.addComponent(Laya.MeshCollider);
        this.sprite3d3.addComponent(Laya.SphereCollider);
        this.sprite3d4.addComponent(Laya.BoxCollider);

        //用球模拟精灵的球体碰撞器
        this.sphereMesh = new Laya.SphereMesh(1, 32, 32);
        this.sphereSprite3d = this.addChild(new Laya.MeshSprite3D(this.sphereMesh)) as Laya.MeshSprite3D;
        this.sprite3d3.meshFilter.sharedMesh.once(Laya.Event.LOADED, this, function():void{
            var mat:Laya.StandardMaterial = new Laya.StandardMaterial();
            mat.albedo = new Laya.Vector4(1, 1, 1, 0.5);
            mat.renderMode = 5;
            this.sphereSprite3d.meshRender.material = mat;
        });
    }

    public lateRender(state: Laya.RenderState): void {

        super.lateRender(state);

        //从屏幕空间生成射线
        this.point.elements[0] = Laya.stage.mouseX;
        this.point.elements[1] = Laya.stage.mouseY;
        this.camera.viewportPointToRay(this.point, this.ray);

        //变化小飞龙的缩放和位置，并更新其模拟碰撞器
        if(this._scale >= 1)
            this._scaleIndex = -1;
        else if (this._scale <= 0.5){
            this._scaleIndex = 1;
        }
        this._scale += this._scaleIndex * 0.005;

        var scaleV3E:Float32Array = this._scaleV3.elements;
        scaleV3E[0] = scaleV3E[1] = scaleV3E[2] = this._scale;
        this.sprite3d3.transform.localScale = this._scaleV3;

        var posiV3E:Float32Array = this._posiV3.elements;
        posiV3E[0] = -2.3;
        posiV3E[1] = this._scale - 0.5;
        posiV3E[2] = 0;
        this.sprite3d3.transform.position = this._posiV3;

        this.sphere = (this.sprite3d3.getComponentByIndex(0) as Laya.SphereCollider).boundSphere;
        this.sphereMesh.radius = this.sphere.radius;
        this.sphereSprite3d.transform.position = this.sphere.center;

        //旋转胖子，并得到obb包围盒顶点
        this.sprite3d4.transform.rotate(this._rotaV3, true, false);
        this.obb = (this.sprite3d4.getComponentByIndex(0) as Laya.BoxCollider).boundBox;
        this.obb.getCorners(this._corners);

        var str:string = "";

        //射线检测,射线相交的<所有物体>,最大检测距离30米,只检测第10层
        Laya.Physics.rayCastAll(this.ray, this._outHitAllInfo, 30, 10);
        for (var i = 0; i < this._outHitAllInfo.length; i++)
        {
            str += this._outHitAllInfo[i].sprite3D.name + " ";
            if (this._outHitAllInfo.length !== 1)
                str = this.str5;
        }

        //射线检测,射线相交的<最近物体>,最大检测距离30米,只检测第13层
        Laya.Physics.rayCast(this.ray, this._outHitInfo, 30, 13);
        if (this._outHitInfo.distance !== -1){
            str = this._outHitInfo.sprite3D.name;
        }

        this.curLabel.text = str;

        this.phasorSpriter3D.begin(Laya.WebGLContext.LINES, state);

        //绘出射线
        this.phasorSpriter3D.line(this.ray.origin.x, this.ray.origin.y, this.ray.origin.z, 1.0, 0.0, 0.0, 1.0, 0, -1, 0, 1.0, 0.0, 0.0, 1.0);

        //绘出MeshCollider检测出物体的3角面
        for (var i = 0; i < this._outHitAllInfo.length; i++){

            var trianglePositions = this._outHitAllInfo[i].trianglePositions;
            var vertex1:Laya.Vector3 = trianglePositions[0];
            var vertex2:Laya.Vector3 = trianglePositions[1];
            var vertex3:Laya.Vector3 = trianglePositions[2];
            var v1X:number = vertex1.x, v1Y:number = vertex1.y, v1Z:number = vertex1.z;
            var v2X:number = vertex2.x, v2Y:number = vertex2.y, v2Z:number = vertex2.z;
            var v3X:number = vertex3.x, v3Y:number = vertex3.y, v3Z:number = vertex3.z;

            this.phasorSpriter3D.line(v1X, v1Y, v1Z, 1.0, 0.0, 0.0, 1.0, v2X, v2Y, v2Z, 1.0, 0.0, 0.0, 1.0);
            this.phasorSpriter3D.line(v2X, v2Y, v2Z, 1.0, 0.0, 0.0, 1.0, v3X, v3Y, v3Z, 1.0, 0.0, 0.0, 1.0);
            this.phasorSpriter3D.line(v3X, v3Y, v3Z, 1.0, 0.0, 0.0, 1.0, v1X, v1Y, v1Z, 1.0, 0.0, 0.0, 1.0);
        }

        //绘出BoxCollider的OBB型包围盒
        this.phasorSpriter3D.line(this._corners[0].x, this._corners[0].y, this._corners[0].z, 1.0, 0.0, 0.0, 1.0, this._corners[1].x,this. _corners[1].y, this._corners[1].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[1].x, this._corners[1].y, this._corners[1].z, 1.0, 0.0, 0.0, 1.0, this._corners[2].x, this._corners[2].y, this._corners[2].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[2].x, this._corners[2].y, this._corners[2].z, 1.0, 0.0, 0.0, 1.0, this._corners[3].x, this._corners[3].y, this._corners[3].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[3].x, this._corners[3].y, this._corners[3].z, 1.0, 0.0, 0.0, 1.0, this._corners[0].x, this._corners[0].y, this._corners[0].z, 1.0, 0.0, 0.0, 1.0);

        this.phasorSpriter3D.line(this._corners[4].x, this._corners[4].y, this._corners[4].z, 1.0, 0.0, 0.0, 1.0, this._corners[5].x, this._corners[5].y, this._corners[5].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[5].x, this._corners[5].y, this._corners[5].z, 1.0, 0.0, 0.0, 1.0, this._corners[6].x, this._corners[6].y, this._corners[6].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[6].x, this._corners[6].y, this._corners[6].z, 1.0, 0.0, 0.0, 1.0, this._corners[7].x, this._corners[7].y, this._corners[7].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[7].x, this._corners[7].y, this._corners[7].z, 1.0, 0.0, 0.0, 1.0, this._corners[4].x, this._corners[4].y, this._corners[4].z, 1.0, 0.0, 0.0, 1.0);

        this.phasorSpriter3D.line(this._corners[0].x, this._corners[0].y, this._corners[0].z, 1.0, 0.0, 0.0, 1.0, this._corners[4].x, this._corners[4].y, this._corners[4].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[1].x, this._corners[1].y, this._corners[1].z, 1.0, 0.0, 0.0, 1.0, this._corners[5].x, this._corners[5].y, this._corners[5].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[2].x, this._corners[2].y, this._corners[2].z, 1.0, 0.0, 0.0, 1.0, this._corners[6].x, this._corners[6].y, this._corners[6].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[3].x, this._corners[3].y, this._corners[3].z, 1.0, 0.0, 0.0, 1.0, this._corners[7].x, this._corners[7].y, this._corners[7].z, 1.0, 0.0, 0.0, 1.0);

        this.phasorSpriter3D.line(this._corners[0].x, this._corners[0].y, this._corners[0].z, 1.0, 0.0, 0.0, 1.0, this._corners[1].x, this._corners[1].y, this._corners[1].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[1].x, this._corners[1].y, this._corners[1].z, 1.0, 0.0, 0.0, 1.0, this._corners[2].x, this._corners[2].y, this._corners[2].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[2].x, this._corners[2].y, this._corners[2].z, 1.0, 0.0, 0.0, 1.0, this._corners[3].x, this._corners[3].y, this._corners[3].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[3].x, this._corners[3].y, this._corners[3].z, 1.0, 0.0, 0.0, 1.0, this._corners[0].x, this._corners[0].y, this._corners[0].z, 1.0, 0.0, 0.0, 1.0);

        this.phasorSpriter3D.line(this._corners[4].x, this._corners[4].y, this._corners[4].z, 1.0, 0.0, 0.0, 1.0, this._corners[5].x, this._corners[5].y, this._corners[5].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[5].x, this._corners[5].y, this._corners[5].z, 1.0, 0.0, 0.0, 1.0, this._corners[6].x, this._corners[6].y, this._corners[6].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[6].x, this._corners[6].y, this._corners[6].z, 1.0, 0.0, 0.0, 1.0, this._corners[7].x, this._corners[7].y, this._corners[7].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[7].x, this._corners[7].y, this._corners[7].z, 1.0, 0.0, 0.0, 1.0, this._corners[4].x, this._corners[4].y, this._corners[4].z, 1.0, 0.0, 0.0, 1.0);

        this.phasorSpriter3D.line(this._corners[0].x, this._corners[0].y, this._corners[0].z, 1.0, 0.0, 0.0, 1.0, this._corners[4].x, this._corners[4].y, this._corners[4].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[1].x, this._corners[1].y, this._corners[1].z, 1.0, 0.0, 0.0, 1.0, this._corners[5].x, this._corners[5].y, this._corners[5].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[2].x, this._corners[2].y, this._corners[2].z, 1.0, 0.0, 0.0, 1.0, this._corners[6].x, this._corners[6].y, this._corners[6].z, 1.0, 0.0, 0.0, 1.0);
        this.phasorSpriter3D.line(this._corners[3].x, this._corners[3].y, this._corners[3].z, 1.0, 0.0, 0.0, 1.0, this._corners[7].x, this._corners[7].y, this._corners[7].z, 1.0, 0.0, 0.0, 1.0);

        this.phasorSpriter3D.end();
    }
}

class MousePickingSample {

    private label:Laya.Label;

    constructor() {
        Laya3D.init(0, 0,true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        this.label = new Laya.Label();
        this.label.text = "是否发生碰撞";
        this.label.pos(300, 100);
        this.label.fontSize = 60;
        this.label.color = "#40FF40";

        Laya.stage.addChild(new MousePickingScene(this.label));

        Laya.stage.addChild(this.label);
    }
}
new MousePickingSample();