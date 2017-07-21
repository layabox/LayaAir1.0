Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
camera.transform.translate(new Laya.Vector3(0, 2, 5));
camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);

var directionLight = scene.addChild(new Laya.DirectionLight());
directionLight.ambientColor = new Laya.Vector3(0.6, 0.6, 0.6);
directionLight.specularColor = new Laya.Vector3(0.6, 0.6, 0.6);
directionLight.diffuseColor = new Laya.Vector3(0.6, 0.6, 0.6);
directionLight.direction = new Laya.Vector3(1, -1, -1);

var sprite3D = scene.addChild(new Laya.Sprite3D());

//平面
var plane = sprite3D.addChild(new Laya.MeshSprite3D(new Laya.PlaneMesh(6, 6, 10, 10)));

//正方体
var box = sprite3D.addChild(new Laya.MeshSprite3D(new Laya.BoxMesh(0.5, 0.5, 0.5)));
box.transform.position = new Laya.Vector3(1.5, 0.25, 0.6);
box.transform.rotate(new Laya.Vector3(0, 45, 0), false, false);

//球体
var sphere = sprite3D.addChild(new Laya.MeshSprite3D(new Laya.SphereMesh(0.25)));
sphere.transform.position = new Laya.Vector3(0.5, 0.25, 0.6);

//圆柱体
var cylinder = sprite3D.addChild(new Laya.MeshSprite3D(new Laya.CylinderMesh(0.25, 1)));
cylinder.transform.position = new Laya.Vector3(-0.5, 0.5, 0.6);

//胶囊体
var capsule = sprite3D.addChild(new Laya.MeshSprite3D(new Laya.CapsuleMesh(0.25, 1)));
capsule.transform.position = new Laya.Vector3(-1.5, 0.5, 0.6);

var debugModel = false;
var phasorSpriter3D = new Laya.PhasorSpriter3D();
var vertex1 = new Laya.Vector3();
var vertex2 = new Laya.Vector3();
var vertex3 = new Laya.Vector3();
var color = new Laya.Vector4(0, 1, 0, 1);

Laya.timer.frameLoop(1, this, function () {

    sprite3D.active = !debugModel;
    if (debugModel) {
        phasorSpriter3D.begin(Laya.WebGLContext.LINES, camera);
        Tool.linearModel(sprite3D, phasorSpriter3D, color, vertex1, vertex2, vertex3);
        phasorSpriter3D.end();
    }
});

(function loadUI(){

    var curStateIndex = 0;
    Laya.loader.load(["../../res/threeDimen/ui/button.png"], Laya.Handler.create(null, function () {

        var changeActionButton = Laya.stage.addChild(new Laya.Button("../../res/threeDimen/ui/button.png", "正常模式"));
        changeActionButton.size(160, 40);
        changeActionButton.labelBold = true;
        changeActionButton.labelSize = 30;
        changeActionButton.sizeGrid = "4,4,4,4";
        changeActionButton.scale(Laya.Browser.pixelRatio, Laya.Browser.pixelRatio);
        changeActionButton.pos(Laya.stage.width / 2 - changeActionButton.width *  Laya.Browser.pixelRatio / 2, Laya.stage.height - 100 *  Laya.Browser.pixelRatio);
        changeActionButton.on(Laya.Event.CLICK, this, function () {
            if (++curStateIndex % 2 == 1) {
                debugModel = true;
                changeActionButton.label = "网格模式";
            }
            else {
                debugModel = false;
                changeActionButton.label = "正常模式";
            }
        });
    }));
})();