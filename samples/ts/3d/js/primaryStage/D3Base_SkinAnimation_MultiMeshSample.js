var SkinAnimation_MultiMeshSample = (function () {
    function SkinAnimation_MultiMeshSample() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(new Laya.Scene());
        scene.currentCamera = (scene.addChild(new Laya.Camera(0, 0.1, 100)));
        scene.currentCamera.transform.translate(new Laya.Vector3(0, 1.8, 2.0));
        scene.currentCamera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        scene.currentCamera.clearColor = null;
        var directionLight = scene.addChild(new Laya.DirectionLight());
        directionLight.direction = new Laya.Vector3(0, -0.8, -1);
        directionLight.ambientColor = new Laya.Vector3(0.7, 0.6, 0.6);
        directionLight.specularColor = new Laya.Vector3(2.0, 2.0, 1.6);
        directionLight.diffuseColor = new Laya.Vector3(1, 1, 1);
        scene.shadingMode = Laya.BaseScene.PIXEL_SHADING;
        var rootSkinMesh = scene.addChild(new Laya.Sprite3D());
        var skinMesh0 = rootSkinMesh.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT0.lm")));
        var skinMesh1 = rootSkinMesh.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT1.lm")));
        var skinMesh2 = rootSkinMesh.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT2.lm")));
        var skinMesh3 = rootSkinMesh.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT3.lm")));
        var skinAni0 = skinMesh0.addComponent(Laya.SkinAnimations);
        skinAni0.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
        skinAni0.play(0, 0.6);
        var skinAni1 = skinMesh1.addComponent(Laya.SkinAnimations);
        skinAni1.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
        skinAni1.play(0, 0.6);
        var skinAni2 = skinMesh2.addComponent(Laya.SkinAnimations);
        skinAni2.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
        skinAni2.play(0, 0.6);
        var skinAni3 = skinMesh3.addComponent(Laya.SkinAnimations);
        skinAni3.url = "../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani";
        skinAni3.play(0, 0.6);
    }
    return SkinAnimation_MultiMeshSample;
}());
new SkinAnimation_MultiMeshSample();
