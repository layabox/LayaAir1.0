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

Laya.timer.frameLoop(1, this, checkHit);

var ray = new Laya.Ray(new Laya.Vector3(0, 0, 0), new Laya.Vector3(0, 0, 0));
var point = new Laya.Vector2();
var _outHitAllInfo = new Array();
function checkHit() {

    //从屏幕空间生成射线
    point.elements[0] = Laya.MouseManager.instance.mouseX;
    point.elements[1] = Laya.MouseManager.instance.mouseY;
    camera.viewportPointToRay(point, ray);

    //射线检测获取所有检测碰撞到的物体
    Laya.Physics.rayCastAll(ray, _outHitAllInfo, 30, 0);
}

(function loadUI() {

    var label = new Laya.Label();
    label.text = "点击选取的几何体";
    label.pos(Laya.Browser.clientWidth / 2.5, 100);
    label.fontSize = 50;
    label.color = "#40FF40";
    Laya.stage.addChild(label);

//鼠标事件
    Laya.stage.on(Laya.Event.MOUSE_UP, this, function () {
        var str = "";
        for (var i = 0; i < _outHitAllInfo.length; i++) {
            str += _outHitAllInfo[i].sprite3D.name + "  ";
        }
        if (_outHitAllInfo.length == 0) {
            str = "点击选取的几何体";
        }
        label.text = str;
    });
})();