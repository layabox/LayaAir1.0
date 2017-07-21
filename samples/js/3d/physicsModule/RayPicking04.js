Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var scene = Laya.stage.addChild(new Laya.Scene());

//初始化照相机
var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
camera.transform.translate(new Laya.Vector3(0, 1, 3));
camera.clearColor = null;

//添加精灵到场景
var sprite3d1 = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/NvWu/NvWu-shenminvwu.lm")));
var sprite3d2 = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/CunMinNan/CunMinNan-cunminnan.lm")));
var sprite3d3 = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/XiaoFeiLong/XiaoFeiLong-xiaofeilong.lm")));
var sprite3d4 = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/PangZi/PangZi-doubipangzi.lm")));

sprite3d1.transform.position = new Laya.Vector3(-0.6, 0, -0.2);
sprite3d2.transform.position = new Laya.Vector3(0.1, 0, 0);
sprite3d3.transform.position = new Laya.Vector3(-2.3, 0, 0);
sprite3d4.transform.position = new Laya.Vector3(1.8, 0, 0);

sprite3d1.name = "女巫 : 爱上一只村民 , 可惜家里没有 … … (MeshCollider)";
sprite3d2.name = "村民 : 谁说癞蛤蟆吃不到天鹅肉，哼 ~  (MeshCollider)";
sprite3d3.name = "小飞龙 : 别摸我，烦着呢 ！ (SphereCollider)";
sprite3d4.name = "死胖子 : 不吃饱哪有力气减肥？ (BoxCollider)";
var str5 = "旁白 : 秀恩爱，死得快！ (MeshCollider)";

//指定精灵的层
sprite3d1.layer = Laya.Layer.getLayerByNumber(10);
sprite3d2.layer = Laya.Layer.getLayerByNumber(10);
sprite3d3.layer = Laya.Layer.getLayerByNumber(13);
sprite3d4.layer = Laya.Layer.getLayerByNumber(13);

/**
 * 给精灵添加碰撞器组件
 * BoxCollider    : 盒型碰撞器
 * SphereCollider : 球型碰撞器
 * MeshCollider   : 网格碰撞器
 */
sprite3d1.addComponent(Laya.MeshCollider);
sprite3d2.addComponent(Laya.MeshCollider);
sprite3d3.addComponent(Laya.SphereCollider);
sprite3d4.addComponent(Laya.BoxCollider);

//用球模拟精灵的球体碰撞器
var sphereMesh = new Laya.SphereMesh(1, 32, 32);
sphereSprite3d = scene.addChild(new Laya.MeshSprite3D(sphereMesh));
sprite3d3.meshFilter.sharedMesh.once(Laya.Event.LOADED, this, function () {
    var mat = new Laya.StandardMaterial();
    mat.albedo = new Laya.Vector4(1, 1, 1, 0.5);
    mat.renderMode = 5;
    sphereSprite3d.meshRender.material = mat;
});


Laya.timer.frameLoop(1, this, checkHit);

var ray = new Laya.Ray(new Laya.Vector3(0, 0, 0), new Laya.Vector3(0, 0, 0));
var point = new Laya.Vector2();

var _corners = new Array();
_corners[0] = new Laya.Vector3();
_corners[1] = new Laya.Vector3();
_corners[2] = new Laya.Vector3();
_corners[3] = new Laya.Vector3();
_corners[4] = new Laya.Vector3();
_corners[5] = new Laya.Vector3();
_corners[6] = new Laya.Vector3();
_corners[7] = new Laya.Vector3();

var _outHitInfo = new Laya.RaycastHit();
var _outHitAllInfo = new Array();
var _posiV3 = new Laya.Vector3();
var _scaleV3 = new Laya.Vector3();
var _rotaV3 = new Laya.Vector3(0, 1, 0);
var _scale = 1;
var _scaleIndex = -1;
var _color = new Laya.Vector4(1, 0, 0, 1);
var _linePos = new Laya.Vector3(0, 1, 0);

var phasorSpriter3D = new Laya.PhasorSpriter3D();

function checkHit() {

    //从屏幕空间生成射线
    point.elements[0] = Laya.stage.mouseX;
    point.elements[1] = Laya.stage.mouseY;
    camera.viewportPointToRay(point, ray);

    //变化小飞龙的缩放和位置，并更新其模拟碰撞器
    if (_scale >= 1)
        _scaleIndex = -1;
    else if (_scale <= 0.5) {
        _scaleIndex = 1;
    }
    _scale += _scaleIndex * 0.005;

    var scaleV3E = _scaleV3.elements;
    scaleV3E[0] = scaleV3E[1] = scaleV3E[2] = _scale;
    sprite3d3.transform.localScale = _scaleV3;

    var posiV3E = _posiV3.elements;
    posiV3E[0] = -2.3;
    posiV3E[1] = _scale - 0.5;
    posiV3E[2] = 0;
    sprite3d3.transform.position = _posiV3;

    var sphere = sprite3d3.getComponentByIndex(0).boundSphere;
    sphereMesh.radius = sphere.radius;
    sphereSprite3d.transform.position = sphere.center;

    //旋转胖子，并得到obb包围盒顶点
    sprite3d4.transform.rotate(_rotaV3, true, false);
    var obb = sprite3d4.getComponentByIndex(0).boundBox;
    obb.getCorners(_corners);

    var str = "";

    //射线检测,射线相交的<所有物体>,最大检测距离30米,只检测第10层
    Laya.Physics.rayCastAll(ray, _outHitAllInfo, 30, 10);
    for (var i = 0; i < _outHitAllInfo.length; i++) {
        str += _outHitAllInfo[i].sprite3D.name + " ";
        if (_outHitAllInfo.length !== 1)
            str = str5;
    }

    //射线检测,射线相交的<最近物体>,最大检测距离30米,只检测第13层
    Laya.Physics.rayCast(ray, _outHitInfo, 30, 13);
    if (_outHitInfo.distance !== -1) {
        str = _outHitInfo.sprite3D.name;
    }

    label.text = str;

    phasorSpriter3D.begin(Laya.WebGLContext.LINES, camera);

    //绘出射线
    phasorSpriter3D.line(ray.origin, _color, _linePos, _color);

    //绘出MeshCollider检测出物体的3角面
    for (var i = 0; i < _outHitAllInfo.length; i++) {

        var trianglePositions = _outHitAllInfo[i].trianglePositions;
        phasorSpriter3D.line(trianglePositions[0], _color, trianglePositions[1], _color);
        phasorSpriter3D.line(trianglePositions[1], _color, trianglePositions[2], _color);
        phasorSpriter3D.line(trianglePositions[2], _color, trianglePositions[0], _color);

    }

    //绘出BoxCollider的OBB型包围盒
    phasorSpriter3D.line(_corners[0], _color, _corners[1], _color);
    phasorSpriter3D.line(_corners[1], _color, _corners[2], _color);
    phasorSpriter3D.line(_corners[2], _color, _corners[3], _color);
    phasorSpriter3D.line(_corners[3], _color, _corners[0], _color);

    phasorSpriter3D.line(_corners[4], _color, _corners[5], _color);
    phasorSpriter3D.line(_corners[5], _color, _corners[6], _color);
    phasorSpriter3D.line(_corners[6], _color, _corners[7], _color);
    phasorSpriter3D.line(_corners[7], _color, _corners[4], _color);

    phasorSpriter3D.line(_corners[0], _color, _corners[4], _color);
    phasorSpriter3D.line(_corners[1], _color, _corners[5], _color);
    phasorSpriter3D.line(_corners[2], _color, _corners[6], _color);
    phasorSpriter3D.line(_corners[3], _color, _corners[7], _color);

    phasorSpriter3D.end();
}

(function loadUI() {

    label = new Laya.Label();
    label.text = "是否发生碰撞";
    label.pos(300, 100);
    label.fontSize = 60;
    label.color = "#40FF40";

    Laya.stage.addChild(label);
})();