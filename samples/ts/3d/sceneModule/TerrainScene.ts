class TerrainScene {
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene: Laya.Scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/TerrainScene/XunLongShi.ls")) as Laya.Scene;


        scene.once(Laya.Event.HIERARCHY_LOADED, this, function (): void {

            var camera:Camera = scene.getChildByName("Scenes").getChildByName("Main Camera") as Laya.Camera;
            camera.addComponent(CameraMoveScript);
                
            var skyBox:SkyBox = new Laya.SkyBox();
            skyBox.textureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyBox3/skyCube.ltc");
            camera.sky = skyBox;
                
            var meshSprite3D:Laya.MeshSprite3D = scene.getChildByName('Scenes').getChildByName('HeightMap') as Laya.MeshSprite3D;
            meshSprite3D.active = false;
                
            var meshSprite3D1:Laya.MeshSprite3D = scene.getChildByName('Scenes').getChildByName('Area') as Laya.MeshSprite3D;
            meshSprite3D1.active = false;
        });
    }
}
new TerrainScene;