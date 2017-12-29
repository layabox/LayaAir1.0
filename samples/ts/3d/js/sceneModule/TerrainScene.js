var TerrainScene = /** @class */ (function () {
    function TerrainScene() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/TerrainScene/XunLongShi.ls"));
        scene.once(Laya.Event.HIERARCHY_LOADED, this, function () {
            var camera = scene.getChildByName("Scenes").getChildByName("Main Camera");
            camera.addComponent(CameraMoveScript);
            var skyBox = new Laya.SkyBox();
            skyBox.textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyBox3/skyCube.ltc");
            camera.sky = skyBox;
            var meshSprite3D = scene.getChildByName('Scenes').getChildByName('HeightMap');
            meshSprite3D.active = false;
            var meshSprite3D1 = scene.getChildByName('Scenes').getChildByName('Area');
            meshSprite3D1.active = false;
        });
    }
    return TerrainScene;
}());
new TerrainScene;
