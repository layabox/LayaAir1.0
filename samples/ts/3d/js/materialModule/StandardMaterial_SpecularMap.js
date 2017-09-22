var StandardMaterial_SpecularMap = (function () {
    function StandardMaterial_SpecularMap() {
        this.rotation = new Laya.Vector3(0, 0.01, 0);
        this.specularMapUrl = ["../../res/threeDimen/skinModel/dude/Assets/dude/headS.png", "../../res/threeDimen/skinModel/dude/Assets/dude/jacketS.png", "../../res/threeDimen/skinModel/dude/Assets/dude/pantsS.png", "../../res/threeDimen/skinModel/dude/Assets/dude/upBodyS.png"];
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        this.scene = new Laya.Scene();
        Laya.stage.addChild(this.scene);
        var camera = (this.scene.addChild(new Laya.Camera(0, 0.1, 1000)));
        camera.transform.translate(new Laya.Vector3(0, 0.7, 1.3));
        camera.transform.rotate(new Laya.Vector3(-15, 0, 0), true, false);
        camera.addComponent(CameraMoveScript);
        var directionLight = this.scene.addChild(new Laya.DirectionLight());
        directionLight.direction = new Laya.Vector3(0, -0.8, -1);
        directionLight.color = new Laya.Vector3(1, 1, 1);
        var completeHandler = Laya.Handler.create(this, this.onComplete);
        Laya.loader.create("../../res/threeDimen/skinModel/dude/dude.lh", completeHandler);
    }
    StandardMaterial_SpecularMap.prototype.onComplete = function () {
        var dude1 = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/dude/dude.lh"));
        dude1.transform.position = new Laya.Vector3(-0.6, 0, 0);
        var dude2 = Laya.Sprite3D.instantiate(dude1, this.scene, false, new Laya.Vector3(0.6, 0, 0));
        var skinnedMeshSprite3d = dude2.getChildAt(0).getChildAt(0);
        for (var i = 0; i < skinnedMeshSprite3d.skinnedMeshRender.materials.length; i++) {
            var mat = skinnedMeshSprite3d.skinnedMeshRender.materials[i];
            //高光贴图
            mat.specularTexture = Laya.Texture2D.load(this.specularMapUrl[i]);
        }
        Laya.timer.frameLoop(1, this, function () {
            dude1.transform.rotate(this.rotation);
            dude2.transform.rotate(this.rotation);
        });
    };
    return StandardMaterial_SpecularMap;
}());
new StandardMaterial_SpecularMap;
