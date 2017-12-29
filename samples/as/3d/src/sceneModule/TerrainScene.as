package sceneModule {
    import laya.d3.core.BaseCamera;
    import laya.d3.core.Camera;
    import laya.d3.core.MeshSprite3D;
    import laya.d3.core.Sprite3D;
	import laya.d3.core.material.StandardMaterial;
    import laya.d3.core.scene.Scene;
    import laya.d3.math.Vector2;
    import laya.d3.math.Vector3;
    import laya.d3.math.Vector4;
    import laya.d3.resource.TextureCube;
    import laya.d3.resource.models.SkyBox;
    import laya.display.Stage;
    import laya.events.Event;
    import laya.utils.Stat;
    import common.CameraMoveScript;
    
    public class TerrainScene {
        public function TerrainScene() {
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Stage.SCALE_FULL;
            Laya.stage.screenMode = Stage.SCREEN_NONE;
            Stat.show();
            
            var scene:Scene = Laya.stage.addChild(Scene.load("../../../../res/threeDimen/scene/TerrainScene/XunLongShi.ls")) as Scene;
            
			scene.once(Event.HIERARCHY_LOADED, this, function():void{
				
				var camera:Camera = scene.getChildByName("Scenes").getChildByName("Main Camera") as Camera;
				camera.addComponent(CameraMoveScript);
				
				var skyBox:SkyBox = new SkyBox();
				skyBox.textureCube = TextureCube.load("../../../../res/threeDimen/skyBox/skyBox3/skyCube.ltc");
				camera.sky = skyBox;
				
				var meshSprite3D:MeshSprite3D = scene.getChildByName('Scenes').getChildByName('HeightMap') as MeshSprite3D;
				meshSprite3D.active = false;
				
				var meshSprite3D1:MeshSprite3D = scene.getChildByName('Scenes').getChildByName('Area') as MeshSprite3D;
				meshSprite3D1.active = false;
			});
        }
    }
	
}