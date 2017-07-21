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
            
            var camera:Camera = scene.addChild(new Camera(0, 0.1, 1000)) as Camera;
            camera.transform.rotate(new Vector3(-38, 180, 0), false, false);
            camera.transform.translate(new Vector3(-5, 20, -30), false);
            camera.clearFlag = BaseCamera.CLEARFLAG_SKY;
            camera.addComponent(CameraMoveScript);
            
            var skyBox:SkyBox = new SkyBox();
            skyBox.textureCube = TextureCube.load("../../../../res/threeDimen/skyBox/skyBox3/skyCube.ltc");
            camera.sky = skyBox;
			
			scene.once(Event.HIERARCHY_LOADED, this, function():void{
				setMaterials(scene.getChildAt(1), new Vector4(1.3, 1.3, 1.3, 1), new Vector3(0.3, 0.3, 0.3));
			});
        }
        
        private function setMaterials(spirit3D:Sprite3D, albedo:Vector4, ambientColor:Vector3):void {
            if (spirit3D is MeshSprite3D) {
                var meshSprite:MeshSprite3D = spirit3D as MeshSprite3D;
                for (var i:int = 0; i <  meshSprite.meshRender.sharedMaterials.length; i++) {
                    var mat:StandardMaterial = meshSprite.meshRender.sharedMaterials[i] as StandardMaterial;
                    mat.ambientColor = ambientColor;
                    mat.albedo = albedo;
                }
            }
            for (var i:int = 0; i < spirit3D._childs.length; i++)
                setMaterials(spirit3D._childs[i], albedo, ambientColor);
        }
    }
	
}