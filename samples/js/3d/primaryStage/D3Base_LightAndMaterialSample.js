Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var Browser = Laya.Browser;
var Vector3 = Laya.Vector3;
var tempVector3 = new Vector3();
var tempQuaternion = new Laya.Quaternion();
var currentShadingMode = Laya.BaseScene.PIXEL_SHADING;
var currentLightState = 0;
var buttonLight;
var shadingLight;


var scene = Laya.stage.addChild(new Laya.Scene());

var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
camera.transform.translate(new Vector3(0, 0.8, 1.2));
camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
camera.clearColor = null;

var directionLight = scene.addChild(new Laya.DirectionLight());
directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
directionLight.specularColor = new Vector3(1.0, 1.0, 0.9);
directionLight.diffuseColor = new Vector3(1, 1, 1);
directionLight.direction = new Vector3(0, -1.0, -1.0);
var currentLight = directionLight;

var pointLight = new Laya.PointLight();
pointLight.ambientColor = new Vector3(0.8, 0.5, 0.5);
pointLight.specularColor = new Vector3(1.0, 1.0, 0.9);
pointLight.diffuseColor = new Vector3(1, 1, 1);
pointLight.transform.position = new Vector3(0.4, 0.4, 0.0);
pointLight.attenuation = new Vector3(0.0, 0.0, 3.0);
pointLight.range = 3.0;

var spotLight = new Laya.SpotLight();
spotLight.ambientColor = new Vector3(1.0, 1.0, 0.8);
spotLight.specularColor = new Vector3(1.0, 1.0, 0.8);
spotLight.diffuseColor = new Vector3(1, 1, 1);
spotLight.transform.position = new Vector3(0.0, 1.2, 0.0);
spotLight.direction = new Vector3(-0.2, -1.0, 0.0);
spotLight.attenuation = new Vector3(0.0, 0.0, 0.8);
spotLight.range = 3.0;
spotLight.spot = 32;

scene.shadingMode = currentShadingMode;

var grid = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/grid/plane.lh"));
//可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
grid.once(Laya.Event.HIERARCHY_LOADED, null, function (sprite) {
    var meshSprite = sprite.getChildAt(0);
    var mesh = meshSprite.meshFilter.sharedMesh;
    mesh.once(Laya.Event.LOADED, null, function (templet) {
        for (var i = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
            var material = meshSprite.meshRender.sharedMaterials[i];
            material.once(Laya.Event.LOADED, null, function () {
                material.diffuseColor = new Vector3(0.7, 0.7, 0.7);
                material.specularColor = new Laya.Vector4(0.2, 0.2, 0.2, 32);
            })
        }
    });
});

var sphere = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/sphere/sphere.lh"));
sphere.transform.localScale = new Vector3(0.2, 0.2, 0.2);
sphere.transform.localPosition = new Vector3(0.0, 0.0, 0.2);

var skinMesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/dude/dude-him.lm")));

Laya.stage.timer.frameLoop(1, null, function () {
    switch (currentLightState) {
        case 0:
            Laya.Quaternion.createFromYawPitchRoll(0.03, 0, 0, tempQuaternion);
            Vector3.transformQuat(directionLight.direction, tempQuaternion, directionLight.direction);
            break;
        case 1:
            Laya.Quaternion.createFromYawPitchRoll(0.03, 0, 0, tempQuaternion);
            Vector3.transformQuat(pointLight.transform.position, tempQuaternion, tempVector3);
            pointLight.transform.position = tempVector3;
            break;
        case 2:
            Laya.Quaternion.createFromYawPitchRoll(0.03, 0, 0, tempQuaternion);
            Vector3.transformQuat(spotLight.transform.position, tempQuaternion, tempVector3);
            spotLight.transform.position = tempVector3;
            Vector3.transformQuat(spotLight.direction, tempQuaternion, spotLight.direction);
            break;
    }
});




(function loadUI() {
    Laya.loader.load(["../../res/threeDimen/ui/button.png"], Laya.Handler.create(null, function () {
        buttonLight = new Laya.Button();
        buttonLight.skin = "../../res/threeDimen/ui/button.png";
        buttonLight.label = "平行光";
        buttonLight.labelBold = true;
        buttonLight.labelSize = 20;
        buttonLight.sizeGrid = "4,4,4,4";
        buttonLight.size(120, 30);
        buttonLight.scale(Browser.pixelRatio, Browser.pixelRatio);
        buttonLight.pos(Laya.stage.width / 2 - buttonLight.width * Browser.pixelRatio / 2, Laya.stage.height - 100 * Browser.pixelRatio);
        buttonLight.on(Laya.Event.CLICK, this, onclickButtonLight);
        Laya.stage.addChild(buttonLight);

        shadingLight = new Laya.Button();
        shadingLight.skin = "../../res/threeDimen/ui/button.png";
        shadingLight.label = "像素着色";
        shadingLight.labelBold = true;
        shadingLight.labelSize = 20;
        shadingLight.sizeGrid = "4,4,4,4";
        shadingLight.size(120, 30);
        shadingLight.scale(Browser.pixelRatio, Browser.pixelRatio);
        shadingLight.pos(Laya.stage.width / 2 - shadingLight.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
        shadingLight.on(Laya.Event.CLICK, this, onclickButtonShading);
        Laya.stage.addChild(shadingLight);

        Laya.stage.on(Laya.Event.RESIZE, null, function () {
            buttonLight.pos(Laya.stage.width / 2 - buttonLight.width * Browser.pixelRatio / 2, Laya.stage.height - 100 * Browser.pixelRatio);
            shadingLight.pos(Laya.stage.width / 2 - shadingLight.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
        });

    }));
})();

function onclickButtonShading() {
    currentShadingMode++;
    (currentShadingMode > Laya.BaseScene.PIXEL_SHADING) && (currentShadingMode = Laya.BaseScene.VERTEX_SHADING);
    if (currentShadingMode == Laya.BaseScene.VERTEX_SHADING) {
        shadingLight.label = "顶点着色";
    } else {
        shadingLight.label = "像素着色";
    }
    scene.shadingMode = currentShadingMode;
}

function onclickButtonLight() {
    currentLightState++;
    (currentLightState > 2) && (currentLightState = 0);
    currentLight.removeSelf();
    switch (currentLightState) {
        case 0:
            buttonLight.label = "平行光";
            currentLight = directionLight;
            scene.addChild(directionLight);
            break;
        case 1:
            buttonLight.label = "点光源";
            currentLight = pointLight;
            scene.addChild(pointLight);
            break;
        case 2:
            buttonLight.label = "聚光灯";
            currentLight = spotLight;
            scene.addChild(spotLight);
            break;
    }

}