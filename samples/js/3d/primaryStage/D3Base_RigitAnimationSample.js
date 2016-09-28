Laya3D.init(0, 0, true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var Vector3 = Laya.Vector3;
var Sprite3D = Laya.Sprite3D;
var scene = Laya.stage.addChild(new Laya.Scene());
scene.currentCamera = (scene.addChild(new  Laya.Camera(0, 0.1, 1000)));
scene.currentCamera.transform.translate(new Vector3(0, 16.8, 26.0));
scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
scene.currentCamera.clearColor = null;

var effectSprite = scene.addChild(new Sprite3D());
effectSprite.once(Laya.Event.HIERARCHY_LOADED, this, function(sender, sprite3D) {
    //setMeshParams(effectSprite, Laya.Material.RENDERMODE_ADDTIVEDOUBLEFACE);
    var rootAnimations = sprite3D.addComponent(Laya.RigidAnimations);
    rootAnimations.url = "../../res/threeDimen/staticModel/effect/WuShen/WuShen.lani";
    rootAnimations.player.play(0);
});
effectSprite.loadHierarchy("../../res/threeDimen/staticModel/effect/WuShen/WuShen.lh");

function setMeshParams(spirit3D, renderMode) {
    if (spirit3D instanceof Laya.MeshSprite3D) {
        var meshSprite = spirit3D;
        var mesh = meshSprite.meshFilter.sharedMesh;
        if (mesh) {
            //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
            mesh.once(Event.LOADED, this, function(mesh) {
                for (var i = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
                    var material = meshSprite.meshRender.sharedMaterials[i];
                    material.once(Event.LOADED, null, function(mat) {
                        mat.renderMode = renderMode;
                    });
                }
            });
        }
    }
    for (var i = 0; i < spirit3D._childs.length; i++)
        setMeshParams(spirit3D._childs[i], renderMode);
}