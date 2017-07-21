Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;

var scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/Arena/Arena.ls"));

var camera = scene.addChild(new Laya.Camera(0, 0.1, 1000));
camera.transform.translate(new Laya.Vector3(0, 0.5, 1));
camera.transform.rotate(new Laya.Vector3(-10, 0, 0), true, false);
camera.addComponent(CameraMoveScript);

var renderTargetCamera = scene.addChild(new Laya.Camera(0, 0.1, 1000));
renderTargetCamera.transform.translate(new Laya.Vector3(0, 0.5, 1));
renderTargetCamera.transform.rotate(new Laya.Vector3(-10, 0, 0), true, false);
renderTargetCamera.renderTarget = new Laya.RenderTexture(2048, 2048);
renderTargetCamera.renderingOrder = -1;
renderTargetCamera.addComponent(CameraMoveScript);

var directionLight = scene.addChild(new Laya.DirectionLight());
directionLight.ambientColor = new Laya.Vector3(0.7, 0.6, 0.6);
directionLight.specularColor = new Laya.Vector3(1.0, 1.0, 1.0);
directionLight.diffuseColor = new Laya.Vector3(1, 1, 1);
directionLight.direction = new Laya.Vector3(0, -1.0, -1.0);

var layaMonkey = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh"));

var layaPlane = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/LayaPlane/LayaPlane.lh"));

Laya.loader.create([
    "../../res/threeDimen/scene/Arena/Arena.ls",
    "../../res/threeDimen/staticModel/LayaPlane/LayaPlane.lh"
], Laya.Handler.create(this, onComplete));

function onComplete() {

    setMaterials(scene.getChildByName("scene"));
    layaPlane.transform.localPosition = new Laya.Vector3(0, 0.5, -1);

    Laya.loader.load(["../../res/threeDimen/ui/button.png"], Laya.Handler.create(null, function () {
        var changeActionButton = Laya.stage.addChild(new Laya.Button("../../res/threeDimen/ui/button.png", "渲染目标"));
        changeActionButton.size(160, 40);
        changeActionButton.labelBold = true;
        changeActionButton.labelSize = 30;
        changeActionButton.sizeGrid = "4,4,4,4";
        changeActionButton.scale(Laya.Browser.pixelRatio, Laya.Browser.pixelRatio);
        changeActionButton.pos(Laya.stage.width / 2 - changeActionButton.width * Laya.Browser.pixelRatio / 2, Laya.stage.height - 100 * Laya.Browser.pixelRatio);
        changeActionButton.on(Laya.Event.CLICK, this, function () {
            layaPlane.getChildAt(0).meshRender.material.diffuseTexture = renderTargetCamera.renderTarget;
        });
    }));
}

function setMaterials(spirit3D) {
    if (spirit3D instanceof Laya.MeshSprite3D) {
        var meshSprite = spirit3D;
        for (var i = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
            var mat = meshSprite.meshRender.sharedMaterials[i];
            mat.disableLight();
        }
    }
    for (var i = 0; i < spirit3D._childs.length; i++)
        setMaterials(spirit3D._childs[i]);
}