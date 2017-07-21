package particleModule 
{
	import laya.d3.core.Camera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.display.Stage;
	import laya.utils.Stat;
	/**
	 * ...
	 * @author ...
	 */
	public class Particle_EternalLight 
	{
		
		public function Particle_EternalLight() 
		{
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = scene.addChild(new Camera(0, 0.1, 100)) as Camera;
			camera.transform.translate(new Vector3(0, 2, 4));
			camera.transform.rotate(new Vector3( -15, 0, 0), true, false);
			
			var particleSprite3D:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/particle/ETF_Eternal_Light.lh")) as Sprite3D;
		}
		
	}

}