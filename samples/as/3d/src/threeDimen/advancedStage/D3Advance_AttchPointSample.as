package threeDimen.advancedStage {
	import laya.ani.AnimationTemplet;
	import laya.d3.component.AttachPoint;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.light.PointLight;
	import laya.d3.core.particle.Particle3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.particle.ParticleSetting;
	import laya.utils.Stat;
	
	/** @private */
	public class D3Advance_AttchPointSample {
		private var skinMesh:MeshSprite3D;
		private var skinAni:SkinAnimations;
		private var fire:Particle3D;
		private var attacthPoint:AttachPoint;
		private var rotation:Vector3 = new Vector3(0, 3.14, 0);
		
		public function D3Advance_AttchPointSample() {
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 0.8, 1.0));
			camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			camera.clearColor = null;
			
			var pointLight:PointLight = scene.addChild(new PointLight()) as PointLight;
			pointLight.transform.position = new Vector3(0, 0.6, 0.3);
			pointLight.range = 1.0;
			pointLight.attenuation = new Vector3(0.6, 0.6, 0.6);
			pointLight.ambientColor = new Vector3(0.2, 0.2, 0.0);
			pointLight.specularColor = new Vector3(2.0, 2.0, 2.0);
			pointLight.diffuseColor = new Vector3(1, 1, 1);
			
			skinMesh = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/dude/dude-him.lm"))) as MeshSprite3D;
			skinMesh.transform.localRotationEuler = rotation;
			skinAni = skinMesh.addComponent(SkinAnimations) as SkinAnimations;
			skinAni.templet = AnimationTemplet.load("../../../../res/threeDimen/skinModel/dude/dude-Take 001.lsani");
			skinAni.player.play();
			
			attacthPoint = skinMesh.addComponent(AttachPoint) as AttachPoint;
			attacthPoint.attachBones.push("L_Middle1");
			attacthPoint.attachBones.push("R_Middle1");
			var setting:ParticleSetting = new ParticleSetting();
			setting.textureName = "../../../../res/threeDimen/particle/fire.png";
			setting.maxPartices = 200;
			setting.duration = 0.3;
			setting.ageAddScale = 1;
			setting.minHorizontalVelocity = 0;
			setting.maxHorizontalVelocity = 0;
			setting.minVerticalVelocity = 0;
			setting.maxVerticalVelocity = 0.1;
			setting.gravity = new Float32Array([0, 0.05, 0]);
			setting.minStartColor = new Float32Array([1.0, 1.0, 1.0, 0.039215]);
			setting.maxStartColor = new Float32Array([1.0, 1.0, 1.0, 0.256862]);
			setting.minStartSize = 0.02;
			setting.maxStartSize = 0.05;
			setting.minEndSize = 0.05;
			setting.maxEndSize = 0.2;
			setting.blendState = 1;
			fire = new Particle3D(setting);
			scene.addChild(fire);
			
			attacthPoint.on(Event.COMPLETE, this, function():void{
				var matrix0:Matrix4x4 = attacthPoint.matrixs[0];
				var e:Float32Array;
				var i:int;
				if (matrix0) {
					e = matrix0.elements;
					for (i = 0; i < 10; i++) {
						fire.addParticle(new Vector3(e[12], e[13], e[14]), new Vector3(0, 0, 0));//矩阵的12、13、14分别为Position的X、Y、Z
					}
				}
				
				var matrix1:Matrix4x4 = attacthPoint.matrixs[1];
				if (matrix1) {
					e = matrix1.elements;
					for (i = 0; i < 10; i++) {
						fire.addParticle(new Vector3(e[12], e[13], e[14]), new Vector3(0, 0, 0));//矩阵的12、13、14分别为Position的X、Y、Z
					}
				}
			});
		}
	}
}