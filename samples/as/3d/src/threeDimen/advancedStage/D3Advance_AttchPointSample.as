package threeDimen.advancedStage {
	import laya.d3.component.AttachPoint;
	import laya.d3.component.Component3D;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.light.PointLight;
	import laya.d3.core.particle.Particle3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector3;
	import laya.d3.math.Viewport;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.particle.ParticleSettings;
	import laya.utils.Stat;
	
	/** @private */
	public class D3Advance_AttchPointSample {
		private var skinMesh:MeshSprite3D;
		private var skinAni:SkinAnimations;
		private var fire:Particle3D;
		private var attacthPoint:AttachPoint;
		private var rotation:Vector3 = new Vector3(0, 3.14, 0);
		
		public function D3Advance_AttchPointSample() {
			
			//是否抗锯齿
			//Config.isAntialias = true;
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			scene.currentCamera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			scene.currentCamera.transform.translate(new Vector3(0, 0.8, 1.0));
			scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			scene.currentCamera.clearColor = null;
			
			var pointLight:PointLight = scene.addChild(new PointLight()) as PointLight;
			pointLight.transform.position = new Vector3(0, 0.6, 0.3);
			pointLight.range = 1.0;
			pointLight.attenuation = new Vector3(0.6, 0.6, 0.6);
			pointLight.ambientColor = new Vector3(0.2, 0.2, 0.0);
			pointLight.specularColor = new Vector3(2.0, 2.0, 2.0);
			pointLight.diffuseColor = new Vector3(1, 1, 1);
			scene.shadingMode = BaseScene.PIXEL_SHADING;
			
			skinMesh = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/dude/dude-him.lm"))) as MeshSprite3D;
			skinMesh.transform.localRotationEuler = rotation;
			skinAni = skinMesh.addComponent(SkinAnimations)  as SkinAnimations;
			skinAni.url = "../../../../res/threeDimen/skinModel/dude/dude.ani";
			skinAni.play();
			
			attacthPoint = skinMesh.addComponent(AttachPoint) as AttachPoint;
			attacthPoint.attachBone = "L_Middle1";
			var settings:ParticleSettings = new ParticleSettings();
			settings.textureName = "../../../../res/threeDimen/particle/fire.png";
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