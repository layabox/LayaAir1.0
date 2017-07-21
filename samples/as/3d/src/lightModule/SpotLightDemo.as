package lightModule {
	import laya.d3.component.Animator;
    import laya.d3.core.Camera;
    import laya.d3.core.MeshSprite3D;
    import laya.d3.core.Sprite3D;
    import laya.d3.core.light.SpotLight;
    import laya.d3.core.scene.Scene;
    import laya.d3.math.Quaternion;
    import laya.d3.math.Vector3;
    import laya.d3.resource.models.Mesh;
    import laya.display.Stage;
    import laya.events.Event;
    import laya.utils.Stat;
    import common.CameraMoveScript;
    
    /**
     * ...
     * @author ...
     */
    public class SpotLightDemo {
		
        private var _quaternion:Quaternion = new Quaternion();
        private var _position:Vector3 = new Vector3();
        
        public function SpotLightDemo() {
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Stage.SCALE_FULL;
            Laya.stage.screenMode = Stage.SCREEN_NONE;
            Stat.show();
            
            var scene:Scene = Laya.stage.addChild(new Scene());
            
            var camera:Camera = (scene.addChild(new Camera(0, 0.1, 1000))) as Camera;
            camera.transform.translate(new Vector3(0, 0.7, 1.3));
            camera.transform.rotate(new Vector3(-15, 0, 0), true, false);
            camera.addComponent(CameraMoveScript);
            
			//聚光灯
            var spotLight:SpotLight = scene.addChild(new SpotLight()) as SpotLight;
            spotLight.ambientColor = new Vector3(0.0, 0.0, 0.0);
			spotLight.specularColor = new Vector3(1.0, 0.0, 1.0);
			spotLight.diffuseColor = new Vector3(1, 1, 0);
			spotLight.transform.position = new Vector3(0.0, 1.2, 0.0);
			spotLight.direction = new Vector3(0.15, -1.0, 0.0);
			spotLight.attenuation = new Vector3(0.0, 0.0, 0.8);
			spotLight.range = 6.0;
			spotLight.spot = 32;
            
            var grid:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/staticModel/grid/plane.lh")) as Sprite3D;
            
            var layaMonkey:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Sprite3D;
			layaMonkey.once(Event.HIERARCHY_LOADED, this, function():void{
				var aniSprite3d:Sprite3D = layaMonkey.getChildAt(0);
				var animator:Animator = aniSprite3d.getComponentByType(Animator) as Animator;
				animator.play(null, 1.0, 115, 150);
			});
            
            Laya.timer.frameLoop(1, null, function():void {
                Quaternion.createFromYawPitchRoll(0.025, 0, 0, _quaternion);
                Vector3.transformQuat(spotLight.transform.position, _quaternion, _position);
                spotLight.transform.position = _position;
                var _direction:Vector3 = spotLight.direction;
                Vector3.transformQuat(_direction, _quaternion, _direction);
                spotLight.direction = _direction;
            });
        }
    }
}