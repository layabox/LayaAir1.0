var SkinAnimation_3DoverWeb = (function () {
    function SkinAnimation_3DoverWeb() {
        var div = document.createElement("div");
        div.innerHTML = "<h1 style='color: red;'>此内容来源于HTML网页 - h1标签</h1>";
        document.body.appendChild(div);
        Laya3D.init(0, 0, true, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.stage.bgColor = "none";
        var scene = Laya.stage.addChild(new Laya.Scene());
        var camera = (scene.addChild(new Laya.Camera(0, 0.1, 100)));
        camera.transform.translate(new Laya.Vector3(0, 0.8, 1.0));
        camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        camera.clearColor = new Laya.Vector4(0.0, 0.0, 0.0, 0.0);
        var directionLight = scene.addChild(new Laya.DirectionLight());
        directionLight.direction = new Laya.Vector3(0, -0.8, -1);
        directionLight.ambientColor = new Laya.Vector3(0.7, 0.6, 0.6);
        directionLight.specularColor = new Laya.Vector3(2.0, 2.0, 1.6);
        directionLight.diffuseColor = new Laya.Vector3(1, 1, 1);
        this.skinMesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/dude/dude-him.lm")));
        this.skinMesh.transform.localRotationEuler = new Laya.Vector3(0, 3.14, 0);
        this.skinAni = this.skinMesh.addComponent(Laya.SkinAnimations);
        this.skinAni.templet = Laya.AnimationTemplet.load("../../res/threeDimen/skinModel/dude/dude.ani");
        this.skinAni.player.play();
    }
    return SkinAnimation_3DoverWeb;
}());
new SkinAnimation_3DoverWeb();
