var SkinAnimation_MultiMeshSample = (function () {
    function SkinAnimation_MultiMeshSample() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(new Laya.Scene());
        var camera = (scene.addChild(new Laya.Camera(0, 0.1, 100)));
        camera.transform.translate(new Laya.Vector3(0, 1.8, 2.0));
        camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        camera.clearColor = null;
        var directionLight = scene.addChild(new Laya.DirectionLight());
        directionLight.direction = new Laya.Vector3(0, -0.8, -1);
        directionLight.ambientColor = new Laya.Vector3(0.7, 0.6, 0.6);
        directionLight.specularColor = new Laya.Vector3(2.0, 2.0, 1.6);
        directionLight.diffuseColor = new Laya.Vector3(1, 1, 1);
        var rootSkinMesh = scene.addChild(new Laya.Sprite3D());
        var skinMesh0 = rootSkinMesh.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT0.lm")));
        var skinMesh1 = rootSkinMesh.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT1.lm")));
        var skinMesh2 = rootSkinMesh.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT2.lm")));
        var skinMesh3 = rootSkinMesh.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/nvXia/A02P1V1F001AX01@yequangongjinv-DEFAULT3.lm")));
        this.skinAni0 = skinMesh0.addComponent(Laya.SkinAnimations);
        this.skinAni0.templet = Laya.AnimationTemplet.load("../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani");
        this.skinAni0.player.play(0, 0.6);
        this.skinAni1 = skinMesh1.addComponent(Laya.SkinAnimations);
        this.skinAni1.templet = Laya.AnimationTemplet.load("../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani");
        this.skinAni1.player.play(0, 0.6);
        this.skinAni2 = skinMesh2.addComponent(Laya.SkinAnimations);
        this.skinAni2.templet = Laya.AnimationTemplet.load("../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani");
        this.skinAni2.player.play(0, 0.6);
        this.skinAni3 = skinMesh3.addComponent(Laya.SkinAnimations);
        this.skinAni3.templet = Laya.AnimationTemplet.load("../../res/threeDimen/skinModel/nvXia/yequangongjinv.ani");
        this.skinAni3.player.play(0, 0.6);
    }
    return SkinAnimation_MultiMeshSample;
}());
new SkinAnimation_MultiMeshSample();
