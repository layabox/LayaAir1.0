package lightModule {
	import laya.d3.component.Animator;
    import laya.d3.core.Camera;
    import laya.d3.core.MeshSprite3D;
    import laya.d3.core.Sprite3D;
    import laya.d3.core.light.PointLight;
    import laya.d3.core.scene.Scene;
    import laya.d3.math.Quaternion;
    import laya.d3.math.Vector3;
    import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SphereMesh;
    import laya.display.Stage;
    import laya.events.Event;
    import laya.utils.Stat;
    import common.CameraMoveScript;
    
    /**
     * ...
     * @author ...
     */
    public class PointLightDemo {
		
        private var _temp_position:Vector3 = new Vector3();
        private var _temp_quaternion:Quaternion = new Quaternion();
        
        public function PointLightDemo() {
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Stage.SCALE_FULL;
            Laya.stage.screenMode = Stage.SCREEN_NONE;
            Stat.show();
            
            var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
            
            var camera:Camera = (scene.addChild(new Camera(0, 0.1, 1000))) as Camera;
            camera.transform.translate(new Vector3(0, 0.7, 1.3));
            camera.transform.rotate(new Vector3(-15, 0, 0), true, false);
            camera.addComponent(CameraMoveScript);
            
			//点光
            var pointLight:PointLight = scene.addChild(new PointLight()) as PointLight;
			pointLight.color = new Vector3(0.1189446, 0.5907708, 0.7352941);
			pointLight.transform.position = new Vector3(0.4, 0.4, 0.0);
			pointLight.attenuation = new Vector3(0.0, 0.0, 3.0);
			pointLight.range = 3.0;
			
            var grid:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/staticModel/grid/plane.lh")) as Sprite3D;
            
            var layaMonkey:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Sprite3D;
			layaMonkey.once(Event.HIERARCHY_LOADED, this, function():void{
				var aniSprite3d:Sprite3D = layaMonkey.getChildAt(0) as Sprite3D; 
				var animator:Animator = aniSprite3d.getComponentByType(Animator) as Animator;
				animator.play(null, 1.0, 75, 110);
			});
			
            Laya.timer.frameLoop(1, null, function():void {
			
				Quaternion.createFromYawPitchRoll(0.025, 0, 0, _temp_quaternion);
				Vector3.transformQuat(pointLight.transform.position, _temp_quaternion, _temp_position);
				pointLight.transform.position = _temp_position;
            });
        }
    }
}