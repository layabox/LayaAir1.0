Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var scene = Laya.stage.addChild(new Laya.Scene());

//初始化照相机
var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
camera.transform.translate(new Laya.Vector3(0, 2, 5));
camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
camera.clearColor = null;

//方向光
var directionLight = scene.addChild(new Laya.DirectionLight());
directionLight.ambientColor = new Laya.Vector3(0.6, 0.6, 0.6);
directionLight.specularColor = new Laya.Vector3(0.6, 0.6, 0.6);
directionLight.diffuseColor = new Laya.Vector3(0.6, 0.6, 0.6);
directionLight.direction = new Laya.Vector3(1, -1, -1);

//平面
var plane = scene.addChild(new Laya.MeshSprite3D(new Laya.PlaneMesh(6, 6, 10, 10)));
var planeMat = new Laya.StandardMaterial();
planeMat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
planeMat.albedo = new Laya.Vector4(0.9, 0.9, 0.9, 1);
plane.meshRender.material = planeMat;
plane.addComponent(Laya.MeshCollider);

Laya.timer.frameLoop(1, this, checkHit);

var ray = new Laya.Ray(new Laya.Vector3(0, 0, 0), new Laya.Vector3(0, 0, 0));
var point = new Laya.Vector2();
var _outHitInfo = new Laya.RaycastHit();
function checkHit() {

    //从屏幕空间生成射线
    point.elements[0] = Laya.MouseManager.instance.mouseX;
    point.elements[1] = Laya.MouseManager.instance.mouseY;
    camera.viewportPointToRay(point, ray);

    //射线检测获取所有检测碰撞到的物体
    Laya.Physics.rayCast(ray, _outHitInfo, 30, 0);
}

(function loadUI() {

    var label = new Laya.Label();
    label.text = "点击放置";
    label.pos(Laya.Browser.clientWidth / 2.5, 100);
    label.fontSize = 50;
    label.color = "#40FF40";
    Laya.stage.addChild(label);

    var _position = new Laya.Vector3(0, 0, 0);
    var _offset = new Laya.Vector3(0, 0.25, 0);

    //鼠标事件
    Laya.stage.on(Laya.Event.MOUSE_UP, this, function () {
        if (_outHitInfo.distance !== -1) {
            var sphere = scene.addChild(new Laya.MeshSprite3D(new Laya.SphereMesh(0.25, 16, 16)));
            var mat = new Laya.StandardMaterial();
            mat.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/texture/layabox.png");
            mat.albedo = new Laya.Vector4(Math.random(), Math.random(), Math.random(), 1);
            sphere.meshRender.material = mat;
            Laya.Vector3.add(_outHitInfo.position, _offset, _position);
            sphere.transform.position = _position;
            sphere.transform.rotate(new Laya.Vector3(0, 90, 0), false, false);
        }
    });
})();