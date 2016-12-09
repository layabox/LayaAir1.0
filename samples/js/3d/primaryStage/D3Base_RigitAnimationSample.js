Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var Vector3 = Laya.Vector3;
var Sprite3D = Laya.Sprite3D;
var scene = Laya.stage.addChild(new Laya.Scene());
var camera = (scene.addChild(new  Laya.Camera(0, 0.1, 1000)));
camera.transform.translate(new Vector3(0, 16.8, 26.0));
camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
camera.clearColor = null;

var effectSprite = scene.addChild(Sprite3D.load("../../res/threeDimen/staticModel/effect/WuShen/WuShen.lh"));
effectSprite.once(Laya.Event.HIERARCHY_LOADED, this, function(sprite3D) {
    setMeshParams(effectSprite, Laya.BaseMaterial.RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE);
    var rootAnimations = sprite3D.addComponent(Laya.RigidAnimations);
    rootAnimations.url = "../../res/threeDimen/staticModel/effect/WuShen/WuShen.lani";
    rootAnimations.player.play(0);
});

function setMeshParams(spirit3D, renderMode) {
    if (spirit3D instanceof Laya.MeshSprite3D) {
        var meshSprite = spirit3D;
        for (var i = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
            var material = meshSprite.meshRender.sharedMaterials[i];
            material.renderMode = renderMode;
        }
    }
    for (var i = 0; i < spirit3D._childs.length; i++)
        setMeshParams(spirit3D._childs[i], renderMode);
}