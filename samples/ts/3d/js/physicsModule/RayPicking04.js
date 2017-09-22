var RayPicking04 = (function () {
    function RayPicking04() {
        this._scale = 1;
        this._scaleIndex = -1;
        this.str1 = "女巫 : 爱上一只村民 , 可惜家里没有 … … (MeshCollider)";
        this.str2 = "村民 : 谁说癞蛤蟆吃不到天鹅肉，哼 ~  (MeshCollider)";
        this.str3 = "小飞龙 : 别摸我，烦着呢 ！ (SphereCollider)";
        this.str4 = "死胖子 : 不吃饱哪有力气减肥？ (BoxCollider)";
        this.str5 = "旁白 : 秀恩爱，死得快！ (MeshCollider)";
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(new Laya.Scene());
        this.ray = new Laya.Ray(new Laya.Vector3(0, 0, 0), new Laya.Vector3(0, 0, 0));
        this.point = new Laya.Vector2();
        this._outHitInfo = new Laya.RaycastHit();
        this._outHitAllInfo = new Array();
        this._posiV3 = new Laya.Vector3();
        this._scaleV3 = new Laya.Vector3();
        this._rotaV3 = new Laya.Vector3(0, 1, 0);
        this._corners = new Array();
        this._color = new Laya.Vector4(1, 0, 0, 1);
        this._linePos = new Laya.Vector3(0, -1, 1);
        //初始化照相机
        this.camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
        this.camera.transform.translate(new Laya.Vector3(0, 1, 3));
        this.camera.clearColor = null;
        //添加精灵到场景
        this.sprite3d1 = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/NvWu/NvWu-shenminvwu.lm")));
        this.sprite3d2 = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/CunMinNan/CunMinNan-cunminnan.lm")));
        this.sprite3d3 = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/XiaoFeiLong/XiaoFeiLong-xiaofeilong.lm")));
        this.sprite3d4 = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/PangZi/PangZi-doubipangzi.lm")));
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
        this.sphereSprite3d = scene.addChild(new Laya.MeshSprite3D(this.sphereMesh));
        this.sprite3d3.meshFilter.sharedMesh.once(Laya.Event.LOADED, this, function () {
            var mat = new Laya.StandardMaterial();
            mat.albedo = new Laya.Vector4(1, 1, 1, 0.5);
            mat.renderMode = 5;
            this.sphereSprite3d.meshRender.material = mat;
        });
        this._corners[0] = new Laya.Vector3();
        this._corners[1] = new Laya.Vector3();
        this._corners[2] = new Laya.Vector3();
        this._corners[3] = new Laya.Vector3();
        this._corners[4] = new Laya.Vector3();
        this._corners[5] = new Laya.Vector3();
        this._corners[6] = new Laya.Vector3();
        this._corners[7] = new Laya.Vector3();
        this.phasorSpriter3D = new Laya.PhasorSpriter3D();
        Laya.timer.frameLoop(1, this, this.checkHit);
        this.loadUI();
    }
    RayPicking04.prototype.checkHit = function () {
        //从屏幕空间生成射线
        this.point.elements[0] = Laya.stage.mouseX;
        this.point.elements[1] = Laya.stage.mouseY;
        this.camera.viewportPointToRay(this.point, this.ray);
        //变化小飞龙的缩放和位置，并更新其模拟碰撞器
        if (this._scale >= 1)
            this._scaleIndex = -1;
        else if (this._scale <= 0.5) {
            this._scaleIndex = 1;
        }
        this._scale += this._scaleIndex * 0.005;
        var scaleV3E = this._scaleV3.elements;
        scaleV3E[0] = scaleV3E[1] = scaleV3E[2] = this._scale;
        this.sprite3d3.transform.localScale = this._scaleV3;
        var posiV3E = this._posiV3.elements;
        posiV3E[0] = -2.3;
        posiV3E[1] = this._scale - 0.5;
        posiV3E[2] = 0;
        this.sprite3d3.transform.position = this._posiV3;
        var sphere = this.sprite3d3.getComponentByIndex(0).boundSphere;
        this.sphereMesh.radius = sphere.radius;
        this.sphereSprite3d.transform.position = sphere.center;
        //旋转胖子，并得到obb包围盒顶点
        this.sprite3d4.transform.rotate(this._rotaV3, true, false);
        var obb = this.sprite3d4.getComponentByIndex(0).boundBox;
        obb.getCorners(this._corners);
        var str = "";
        //射线检测,射线相交的<所有物体>,最大检测距离30米,只检测第10层
        Laya.Physics.rayCastAll(this.ray, this._outHitAllInfo, 30, 10);
        for (var i = 0; i < this._outHitAllInfo.length; i++) {
            str += this._outHitAllInfo[i].sprite3D.name + " ";
            if (this._outHitAllInfo.length !== 1)
                str = this.str5;
        }
        //射线检测,射线相交的<最近物体>,最大检测距离30米,只检测第13层
        Laya.Physics.rayCast(this.ray, this._outHitInfo, 30, 13);
        if (this._outHitInfo.distance !== -1) {
            str = this._outHitInfo.sprite3D.name;
        }
        this.label.text = str;
        this.phasorSpriter3D.begin(Laya.WebGLContext.LINES, this.camera);
        //绘出射线
        this.phasorSpriter3D.line(this.ray.origin, this._color, this._linePos, this._color);
        //绘出MeshCollider检测出物体的3角面
        for (var i = 0; i < this._outHitAllInfo.length; i++) {
            var trianglePositions = this._outHitAllInfo[i].trianglePositions;
            this.phasorSpriter3D.line(trianglePositions[0], this._color, trianglePositions[1], this._color);
            this.phasorSpriter3D.line(trianglePositions[1], this._color, trianglePositions[2], this._color);
            this.phasorSpriter3D.line(trianglePositions[2], this._color, trianglePositions[0], this._color);
        }
        //绘出BoxCollider的OBB型包围盒
        this.phasorSpriter3D.line(this._corners[0], this._color, this._corners[1], this._color);
        this.phasorSpriter3D.line(this._corners[1], this._color, this._corners[2], this._color);
        this.phasorSpriter3D.line(this._corners[2], this._color, this._corners[3], this._color);
        this.phasorSpriter3D.line(this._corners[3], this._color, this._corners[0], this._color);
        this.phasorSpriter3D.line(this._corners[4], this._color, this._corners[5], this._color);
        this.phasorSpriter3D.line(this._corners[5], this._color, this._corners[6], this._color);
        this.phasorSpriter3D.line(this._corners[6], this._color, this._corners[7], this._color);
        this.phasorSpriter3D.line(this._corners[7], this._color, this._corners[4], this._color);
        this.phasorSpriter3D.line(this._corners[0], this._color, this._corners[4], this._color);
        this.phasorSpriter3D.line(this._corners[1], this._color, this._corners[5], this._color);
        this.phasorSpriter3D.line(this._corners[2], this._color, this._corners[6], this._color);
        this.phasorSpriter3D.line(this._corners[3], this._color, this._corners[7], this._color);
        this.phasorSpriter3D.end();
    };
    RayPicking04.prototype.loadUI = function () {
        this.label = new Laya.Label();
        this.label.text = "是否发生碰撞";
        this.label.pos(300, 100);
        this.label.fontSize = 60;
        this.label.color = "#40FF40";
        Laya.stage.addChild(this.label);
    };
    return RayPicking04;
}());
new RayPicking04;
