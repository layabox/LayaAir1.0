package advancedModule {
    import laya.d3.component.Animator;
    import laya.d3.core.Camera;
    import laya.d3.core.MeshSprite3D;
	import laya.d3.core.SkinnedMeshRender;
	import laya.d3.core.SkinnedMeshSprite3D;
    import laya.d3.core.Sprite3D;
    import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.StandardMaterial;
    import laya.d3.core.scene.Scene;
    import laya.d3.math.Quaternion;
    import laya.d3.math.Vector3;
    import laya.d3.resource.models.Mesh;
    import laya.display.Stage;
    import laya.events.Event;
    import laya.utils.Handler;
    import laya.utils.Stat;
    import common.CameraMoveScript;
    
    /**
     * ...
     * @author ...
     */
    public class RealTimeShadow {
        
        private var _quaternion:Quaternion = new Quaternion();
        private var scene:Scene;
        
        public function RealTimeShadow() {
			
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Stage.SCALE_FULL;
            Laya.stage.screenMode = Stage.SCREEN_NONE;
            Stat.show();
            
            scene = Laya.stage.addChild(new Scene());
            
            var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
            camera.transform.translate(new Vector3(0, 0.7, 1.2));
            camera.transform.rotate(new Vector3(-15, 0, 0), true, false);
            
            var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
            directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
            directionLight.specularColor = new Vector3(1.0, 1.0, 1.0);
            directionLight.diffuseColor = new Vector3(1, 1, 1);
            directionLight.direction = new Vector3(0, -1.0, -1.0);
			
			//灯光开启阴影
            directionLight.shadow = true;
			//可见阴影距离
			directionLight.shadowDistance = 3;
			//生成阴影贴图尺寸
			directionLight.shadowResolution = 2048;
			//生成阴影贴图数量
			directionLight.shadowPSSMCount = 1;
			//模糊等级,越大越高,更耗性能
			directionLight.shadowPCFType = 3;
            
            Laya.loader.create([
				"../../../../res/threeDimen/staticModel/grid/plane.lh", 
				"../../../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh"
			], Handler.create(this, onComplete));
            
            Laya.timer.frameLoop(1, null, function():void {
                Quaternion.createFromYawPitchRoll(0.025, 0, 0, _quaternion);
                var _direction:Vector3 = directionLight.direction;
                Vector3.transformQuat(_direction, _quaternion, _direction);
                directionLight.direction = _direction;
            });
        }
        
        private function onComplete():void {
            
            var grid:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/staticModel/grid/plane.lh")) as Sprite3D;
			//地面接收阴影
			(grid.getChildAt(0) as MeshSprite3D).meshRender.receiveShadow = true;
			
			var staticLayaMonkey:MeshSprite3D = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/LayaMonkey/Assets/LayaMonkey/LayaMonkey-LayaMonkey.lm"))) as MeshSprite3D;
			staticLayaMonkey.meshRender.material = StandardMaterial.load("../../../../res/threeDimen/skinModel/LayaMonkey/Assets/LayaMonkey/Materials/T_Diffuse.lmat");
			staticLayaMonkey.transform.position = new Vector3(0, 0, -0.5);
            staticLayaMonkey.transform.localScale = new Vector3(0.3, 0.3, 0.3);
            staticLayaMonkey.transform.rotation = new Quaternion(0.7071068, 0, 0, -0.7071067);
			//产生阴影
			staticLayaMonkey.meshRender.castShadow = true;
            
            var layaMonkey:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Sprite3D;
			//产生阴影
			(layaMonkey.getChildAt(0).getChildAt(0) as SkinnedMeshSprite3D).skinnedMeshRender.castShadow = true;
			
			var mat:StandardMaterial = (layaMonkey.getChildAt(0).getChildAt(0) as SkinnedMeshSprite3D).skinnedMeshRender.material as StandardMaterial;
			
        }
    }
}