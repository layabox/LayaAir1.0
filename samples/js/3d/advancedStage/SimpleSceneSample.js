var Vector2 = Laya.Vector2;
var Vector3 = Laya.Vector3;
var Sprite3D = Laya.Sprite3D;


Laya.Laya3D.init(0, 0);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var scene = Laya.stage.addChild(new Laya.Scene());

scene.currentCamera = scene.addChild(new Laya.Camera(new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100));
scene.currentCamera.transform.translate(new Vector3(0.3, 0.3, 0.6));
scene.currentCamera.transform.rotate(new Vector3(-12, 0, 0), true, false);
Laya.stage.on(Laya.Event.RESIZE, null, function () {
				scene.currentCamera.viewport = new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height);
});

scene.currentCamera.addComponent(CameraMoveScript);

loadScene(scene);


function loadScene(scene) {
    var root = scene.addChild(new Sprite3D());
    root.transform.localScale = new Vector3(10, 10, 10);

    var skySprite3d0 = scene.addChild(new Sprite3D());
    skySprite3d0.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT006M.v3f.lh");
    skySprite3d0.on(Laya.Event.HIERARCHY_LOADED, null, function (sprite) {
        setMeshParams(skySprite3d0, false, false, 3.5, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
    });

    var skySprite3d1 = scene.addChild(new Sprite3D());
    skySprite3d1.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT007M.v3f.lh");
    skySprite3d1.on(Laya.Event.HIERARCHY_LOADED, null, function (sprite) {
        setMeshParams(skySprite3d1, false, true, 1.0, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
    });

    var singleFaceTransparent = root.addChild(new Sprite3D());
    singleFaceTransparent.on(Laya.Event.HIERARCHY_LOADED, null, function (sprite) {
        setMeshParams(singleFaceTransparent, false, true, 3.5, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
    });
    singleFaceTransparent.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT004M.v3f.lh");
    singleFaceTransparent.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT003M000.v3f.lh");

    var meshSprite3d = root.addChild(new Sprite3D());
    meshSprite3d.on(Laya.Event.HIERARCHY_LOADED, null, function (sprite) {
        setMeshParams(meshSprite3d, false, false, 3.5, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
    });

    meshSprite3d.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh");
    meshSprite3d.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT002M000.v3f.lh");
    meshSprite3d.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT008M.v3f.lh");
    meshSprite3d.loadHierarchy("threeDimen/staticModel/simpleScene/B00MP003M.v3f.lh");

    var doubleFaceTransparent = root.addChild(new Sprite3D());
    doubleFaceTransparent.on(Laya.Event.HIERARCHY_LOADED, null, function (sprite) {
        setMeshParams(doubleFaceTransparent, true, true, 3.5, new Vector3(0.6, 0.6, 0.6), new Vector2(1.0, 1.0));
    });
    doubleFaceTransparent.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT005M.v3f.lh");

    var terrainSpirit0 = root.addChild(new Sprite3D());
    terrainSpirit0.on(Laya.Event.HIERARCHY_LOADED, null, function (sprite) {
        setMeshParams(terrainSpirit0, false, false, 3.5, new Vector3(0.6823, 0.6549, 0.6352), new Vector2(25.0, 25.0), "TERRAIN");
    });
    terrainSpirit0.loadHierarchy("threeDimen/staticModel/simpleScene/B00MP001M.v3f.lh");

    var terrainSpirit1 = root.addChild(new Sprite3D());
    terrainSpirit1.on(Laya.Event.HIERARCHY_LOADED, null, function (sprite) {
        setMeshParams(terrainSpirit1, false, false, 3.5, new Vector3(0.6823, 0.6549, 0.6352), new Vector2(19.0, 19.0), "TERRAIN");
    });
    terrainSpirit1.loadHierarchy("threeDimen/staticModel/simpleScene/B00MP002M.v3f.lh");
}

function setMeshParams(spirit3D, doubleFace, alpha, luminance, ambientColor, uvScale, shaderName, transparentMode) {
    (shaderName === void 0) && (shaderName = undefined);
    (transparentMode === void 0) && (transparentMode = 0.0);

    if ((spirit3D instanceof laya.d3.core.fileModel.Mesh)) {
        var tempet =spirit3D.templet;
        if (tempet != null) {
            tempet.on(Laya.Event.LOADED, this, function (tempet) {
                (shaderName) && tempet.setShaderByName(shaderName);
                for (var i = 0; i < tempet.materials.length; i++) {
                    var transformUV = new Laya.TransformUV();
                    transformUV.tiling = uvScale;
                    tempet.materials[i].transformUV = transformUV;
                    tempet.materials[i].ambientColor = ambientColor;
                    tempet.materials[i].luminance = luminance;
                    doubleFace && (tempet.materials[i].cullFace = false);
                    alpha && (tempet.materials[i].transparent = true);
                    tempet.materials[i].transparentMode = transparentMode;
                }
            });
        }
    }
    for (var i = 0; i < spirit3D._childs.length; i++)
        setMeshParams(spirit3D._childs[i], doubleFace, alpha, luminance, ambientColor, uvScale, shaderName);
}