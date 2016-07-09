package threeDimen.advancedStage {
	import laya.d3.Laya3D;
	import laya.d3.component.AttachPoint;
	import laya.d3.component.Component3D;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.camera.Camera;
	import laya.d3.core.fileModel.Mesh;
	import laya.d3.core.light.PointLight;
	import laya.d3.core.particle.Particle3D;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.particle.ParticleSettings;
	import laya.utils.Stat;
	
	/** @private */
	public class AttchPointSample {
		private var skinMesh:Mesh;
		private var skinAni:SkinAnimations;
		private var fire:Particle3D;
		private var attacthPoint:AttachPoint;
		private var rotation:Vector3 = new Vector3(0, 3.14, 0);
		
		public function AttchPointSample() {
			
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			scene.currentCamera = (scene.addChild(new Camera(new Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100))) as Camera;
			scene.currentCamera.transform.translate(new Vector3(0, 0.8, 1.0));
			scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			scene.currentCamera.clearColor = null;
			Laya.stage.on(Event.RESIZE, null, function():void {
				(scene.currentCamera as Camera).viewport = new Viewport(0, 0, Laya.stage.width, Laya.stage.height);
			});
			
			var pointLight:PointLight = scene.addChild(new PointLight()) as PointLight;
			pointLight.transform.position = new Vector3(0, 0.6, 0.3);
			pointLight.range = 1.0;
			pointLight.attenuation = new Vector3(0.6, 0.6, 0.6);
			pointLight.ambientColor = new Vector3(0.2, 0.2, 0.0);
			pointLight.specularColor = new Vector3(2.0, 2.0, 2.0);
			pointLight.diffuseColor = new Vector3(1, 1, 1);
			scene.shadingMode = BaseScene.PIXEL_SHADING;
			
			skinMesh = scene.addChild(new Mesh()) as Mesh;
			skinMesh.load("threeDimen/skinModel/dude/dude-him.lm");
			skinMesh.transform.localRotationEuler = rotation;
			skinAni = skinMesh.addComponent(SkinAnimations)  as SkinAnimations;
			skinAni.url = "threeDimen/skinModel/dude/dude.ani";
			skinAni.play();
			
			attacthPoint = skinMesh.addComponent(AttachPoint) as AttachPoint;
			attacthPoint.attachBone = "L_Middle1";
			var settings:ParticleSettings = new ParticleSettings();
			settings.textureName = "threeDimen/particle/fire.png";
			settings.maxPartices = 200;
			settings.duration = 0.3;
			settings.ageAddScale = 1;
			settings.minHorizontalVelocity = 0;
			settings.maxHorizontalVelocity = 0;
			settings.minVerticalVelocity = 0;
			settings.maxVerticalVelocity = 0.1;
			settings.gravity = new Float32Array([0, 0.05, 0]);
			settings.minStartColor = new Float32Array([1.0, 1.0, 1.0, 0.039215]);
			settings.maxStartColor = new Float32Array([1.0, 1.0, 1.0, 0.256862]);
			settings.minStartSize = 0.02;
			settings.maxStartSize = 0.05;
			settings.minEndSize = 0.05;
			settings.maxEndSize = 0.2;
			settings.blendState = 1;
			fire = new Particle3D(settings);
			scene.addChild(fire);
			fire.transform.localRotationEuler = rotation;//同步人物旋转
			
			Laya.timer.frameLoop(1, this, loop);
		}
		
		private function loop():void {
			if (attacthPoint.matrix) {
				var e:Float32Array = attacthPoint.matrix.elements;
				for (var i:int = 0; i < 10; i++) {
					fire.addParticle(new Vector3(e[12], e[13], e[14]), new Vector3(0, 0, 0));//矩阵的12、13、14分别为Position的X、Y、Z
				}
			}
		}
	}
}