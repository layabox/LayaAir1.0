package materialModule {
    import laya.d3.core.Camera;
    import laya.d3.core.MeshSprite3D;
    import laya.d3.core.SkinnedMeshSprite3D;
    import laya.d3.core.Sprite3D;
    import laya.d3.core.light.DirectionLight;
    import laya.d3.core.material.StandardMaterial;
    import laya.d3.core.scene.Scene;
    import laya.d3.math.Vector3;
    import laya.d3.resource.Texture2D;
    import laya.d3.resource.models.Mesh;
    import laya.display.Stage;
    import laya.events.Event;
    import laya.utils.Handler;
    import laya.utils.Stat;
    import common.CameraMoveScript;
    
    /**
     * ...
     * @author
     */
    public class StandardMaterial_SpecularMap {
        
        private var scene:Scene;
        private var rotation:Vector3 = new Vector3(0, 0.01, 0);
        private var specularMapUrl:Array = ["../../../../res/threeDimen/skinModel/dude/Assets/dude/headS.png", "../../../../res/threeDimen/skinModel/dude/Assets/dude/jacketS.png", "../../../../res/threeDimen/skinModel/dude/Assets/dude/pantsS.png", "../../../../res/threeDimen/skinModel/dude/Assets/dude/upBodyS.png"];
        
        public function StandardMaterial_SpecularMap() {
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Stage.SCALE_FULL;
            Laya.stage.screenMode = Stage.SCREEN_NONE;
            Stat.show();
            
            scene = Laya.stage.addChild(new Scene()) as Scene;
            
            var camera:Camera = (scene.addChild(new Camera(0, 0.1, 1000))) as Camera;
            camera.transform.translate(new Vector3(0, 0.7, 1.3));
            camera.transform.rotate(new Vector3(-15, 0, 0), true, false);
            camera.addComponent(CameraMoveScript);
            
            var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
            directionLight.direction = new Vector3(0, -0.8, -1);
            directionLight.color = new Vector3(1, 1, 1);
            
            var completeHandler:Handler = Handler.create(this, onComplete);
            
            Laya.loader.create("../../../../res/threeDimen/skinModel/dude/dude.lh", completeHandler);
        }
        
        public function onComplete():void {
            
            var dude1:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/dude/dude.lh")) as Sprite3D;
            dude1.transform.position = new Vector3(-0.6, 0, 0);
            
            var dude2:Sprite3D = Sprite3D.instantiate(dude1, scene, false, new Vector3(0.6, 0, 0));
            var skinnedMeshSprite3d:SkinnedMeshSprite3D = dude2.getChildAt(0).getChildAt(0) as SkinnedMeshSprite3D;
            
            for (var i:int = 0; i < skinnedMeshSprite3d.skinnedMeshRender.materials.length; i++) {
                
                var mat:StandardMaterial = skinnedMeshSprite3d.skinnedMeshRender.materials[i] as StandardMaterial;
				//高光贴图
                mat.specularTexture = Texture2D.load(specularMapUrl[i]);
            }
            
            Laya.timer.frameLoop(1, null, function():void {
                dude1.transform.rotate(rotation);
                dude2.transform.rotate(rotation);
            });
        }
    }
}