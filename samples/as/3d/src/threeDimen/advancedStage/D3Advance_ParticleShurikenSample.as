package threeDimen.advancedStage {
	import laya.d3.core.Camera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.particle.Particle3D;
	import laya.d3.core.particleShuriKen.ShuriKenParticle3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.utils.Utils3D;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import threeDimen.common.CameraMoveScript;
	
	/** @private */
	public class D3Advance_ParticleShurikenSample {
		private var currentState:int = 0;
		private var totalX:Number = 0;
		
		public function D3Advance_ParticleShurikenSample() {
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			var camera:Camera = (scene.addChild(new Camera(0, 0.3, 1000))) as Camera;
			camera.fieldOfView = 60;
			camera.transform.translate(new Vector3(0, 0, -100));
			camera.transform.rotate(new Vector3(0 / 180 * Math.PI, 180 / 180 * Math.PI, 0 / 180 * Math.PI));
			camera.clearColor = null;
			camera.addComponent(CameraMoveScript);
			
			var grid:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			grid.loadHierarchy("../../../../res/threeDimen/staticModel/grid/plane.lh");
			grid.transform.localScale = new Vector3(100, 100, 100);
			
			var particleRoot:Sprite3D = Sprite3D.load("../../../../res/threeDimen/particle/particleSystem0.lh");
			//var particleRoot:Sprite3D = Sprite3D.load("part01.lh");
			scene.addChild(particleRoot) as Sprite3D;
			var particle:ShuriKenParticle3D;
			particleRoot.once(Event.HIERARCHY_LOADED, null, function():void {
				particle = scene.getChildAt(2).getChildAt(0) as ShuriKenParticle3D;
				particle.transform.rotate(new Vector3(0 / 180 * Math.PI, 0 / 180 * Math.PI, 0 / 180 * Math.PI));
				particle.transform.localPosition = new Vector3(0, 0, 0);
			
				//particle.transform.localScale = new Vector3(1, 10, 1);
			});
		
			//Laya.timer.frameLoop(1, null, function():void{
			//totalX += 0.9;
			//particle.transform.localPosition = new Vector3(totalX+10,10,-10);
			//});
		/*
		   var settingPath:String = "../../../../res/threeDimen/particle/particleSystem0.lp";
		   Laya.loader.load(settingPath, Handler.create(null, function(setting:Object):void {
		   var particle:ShuriKenParticle3D = new ShuriKenParticle3D();
		   var preBasePath:String = URL.basePath;
		   URL.basePath = URL.getPath(URL.formatURL(settingPath));
		   Utils3D._loadParticle(setting, particle);
		   URL.basePath = preBasePath;
		   scene.addChild(particle);
		   }), null, Loader.JSON);
		 */
		}
	
	}

}