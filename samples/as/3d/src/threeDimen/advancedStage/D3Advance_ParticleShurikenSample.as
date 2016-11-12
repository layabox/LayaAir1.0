package threeDimen.advancedStage {
	import laya.d3.core.Camera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.particle.Particle3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.utils.Utils3D;
	import laya.display.Stage;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import threeDimen.common.CameraMoveScript;
	
	/** @private */
	public class D3Advance_ParticleShurikenSample {
		private var currentState:int = 0;
		
		public function D3Advance_ParticleShurikenSample() {
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			var camera:Camera = (scene.addChild(new Camera(0, 0.3, 1000))) as Camera;
			camera.transform.translate(new Vector3(0, 0, 100));
			//camera.transform.rotate(new Vector3(0, 0, 0), false, false);
			camera.clearColor = null;
			camera.addComponent(CameraMoveScript);
			
			var grid:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/staticModel/grid/plane.lh")) as Sprite3D;
			grid.transform.localScale = new Vector3(100, 100, 100);
			
			var settingPath:String = "../../../../res/threeDimen/particle/shurikenParticle0.json";
			Laya.loader.load(settingPath, Handler.create(null, function(setting:Object):void {
				var preBasePath:String = URL.basePath;
				URL.basePath = URL.getPath(URL.formatURL(settingPath));
				var particle:Particle3D = Utils3D.loadParticle(setting);
				URL.basePath = preBasePath;
				
				scene.addChild(particle);
				//particle.transform.localScale = new Vector3(10, 10, 10);
			}), null, Loader.JSON);
		}
	
	}

}