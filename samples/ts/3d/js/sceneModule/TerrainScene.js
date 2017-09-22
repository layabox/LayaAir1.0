var TerrainScene = (function () {
    function TerrainScene() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/TerrainScene/XunLongShi.ls"));
        var camera = scene.addChild(new Laya.Camera(0, 0.1, 1000));
        camera.transform.rotate(new Laya.Vector3(-38, 180, 0), false, false);
        camera.transform.translate(new Laya.Vector3(-5, 20, -30), false);
        camera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;
        camera.addComponent(CameraMoveScript);
        var skyBox = new Laya.SkyBox();
        skyBox.textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyBox3/skyCube.ltc");
        camera.sky = skyBox;
        scene.once(Laya.Event.HIERARCHY_LOADED, this, function () {
            this.setMaterials(scene.getChildAt(1), new Laya.Vector4(1.3, 1.3, 1.3, 1), new Laya.Vector3(0.3, 0.3, 0.3));
        });
    }
    TerrainScene.prototype.setMaterials = function (spirit3D, albedo, ambientColor) {
        if (spirit3D instanceof Laya.MeshSprite3D) {
            var meshSprite = spirit3D;
            for (var i = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
                var mat = meshSprite.meshRender.sharedMaterials[i];
                mat.ambientColor = ambientColor;
                mat.albedo = albedo;
            }
        }
        for (var i = 0; i < spirit3D._childs.length; i++)
            this.setMaterials(spirit3D._childs[i], albedo, ambientColor);
    };
    return TerrainScene;
}());
new TerrainScene;
