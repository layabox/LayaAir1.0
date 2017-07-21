package particleModule 
{
	import common.CameraMoveScript;
	import laya.d3.core.Camera;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.display.Stage;
	import laya.utils.Stat;
	/**
	 * ...
	 * @author ...
	 */
	public class Particle_Scene 
	{
		
		public function Particle_Scene() 
		{
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(Scene.load("../../../../res/threeDimen/scene/particle/Example_01.ls")) as Scene;
			
			var camera:Camera = scene.addChild(new Camera(0, 0.1, 100)) as Camera;
			camera.transform.translate(new Vector3(0, 1, 0));
			camera.addComponent(CameraMoveScript);
			
		}
		
	}

}