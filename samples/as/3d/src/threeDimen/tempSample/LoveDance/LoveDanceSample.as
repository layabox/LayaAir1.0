package threeDimen.tempSample.LoveDance {
	import laya.d3.Laya3D;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.TransformUV;
	import laya.d3.core.camera.Camera;
	import laya.d3.core.fileModel.Mesh;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.light.SpotLight;
	import laya.d3.core.material.Material;
	import laya.d3.core.particle.EmitterPoint;
	import laya.d3.core.particle.EmitterSphere;
	import laya.d3.core.particle.Particle3D;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.math.Viewport;
	import laya.d3.resource.tempelet.MeshTemplet;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.particle.ParticleSettings;
	import laya.particle.emitter.EmitterBase;
	import laya.ui.Button;
	import laya.utils.Browser;
	import laya.utils.ClassUtils;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import threeDimen.common.CameraMoveScript;
	
	/** @private */
	public class LoveDanceSample {
		private var pos:Vector3;
		private var Vel:Vector3;
		private var scene:Scene;
		private var light:SpotLight;
		private var enableLight:Boolean;
		private var btn:Button;
		private var lastTime:Number;
		
		private var emitterList:Vector.<EmitterBase> = new Vector.<EmitterBase>();
		
		public function LoveDanceSample() {
			enableLight = true;
			pos = new Vector3(0.0, 0.0, -10.8);
			Vel = new Vector3();
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
			Stat.show();
			
			loadUI();
			loadScene();
		}
		
		private function loadUI():void {
			var _this:LoveDanceSample = this;
			Laya.loader.load(["threeDimen/ui/button.png"], Handler.create(null, function():void {
				btn = new Button();
				btn.skin = "threeDimen/ui/button.png";
				btn.label = "关闭灯光";
				btn.labelBold = true;
				btn.labelSize = 20;
				btn.sizeGrid = "4,4,4,4";
				btn.size(120, 30);
				btn.scale(Browser.pixelRatio, Browser.pixelRatio);
				btn.pos(Laya.stage.width / 2 - btn.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
				btn.strokeColors = "#ff0000,#ffff00,#00ffff";
				btn.on(Event.CLICK, _this, onclick);
				Laya.stage.addChild(btn);
				
				Laya.stage.on(Event.RESIZE, null, function():void {
					btn.pos(Laya.stage.width / 2 - btn.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
				});
			}));
		}
		
		private function onclick():void {
			
			if (!enableLight) {
				btn.label = "关闭灯光";
				scene.addChild(light);
			} else {
				btn.label = "开启灯光";
				scene.removeChild(light);
			}
			enableLight = !enableLight;
		}
		
		private function loadScene():void {
			
			scene = Laya.stage.addChild(new Scene()) as Scene;
			scene.shadingMode = BaseScene.PIXEL_SHADING;
			
			scene.currentCamera = (scene.addChild(new Camera(new Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 1000))) as Camera;
			scene.currentCamera.transform.translate(new Vector3(0.0, 5, 6));
			scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			//scene.currentCamera.clearColor = null;
			Laya.stage.on(Event.RESIZE, null, function():void {
				(scene.currentCamera as Camera).viewport = new Viewport(0, 0, Laya.stage.width, Laya.stage.height);
			});
			
			scene.currentCamera.addComponent(CameraMoveScript);
			
			light = new SpotLight();
			light.ambientColor = new Vector3(1.0, 1.0, 1.0);
			light.specularColor = new Vector3(0.1, 0.1, 0.1);
			light.diffuseColor = new Vector3(0.6, 0.6, 0.5);
			light.transform.position = new Vector3(0.0, 12, 3);
			light.direction = new Vector3(0.0, -1.0, -1.0);
			light.attenuation = new Vector3(0.0, 0.0, 0.006);
			light.range = 30;
			light.spot = 3;
			scene.addChild(light);
			
			//****************************************加载地面*****************************************
			var grid:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			grid.loadHierarchy("threeDimen/staticModel/grid/plane.lh");
			grid.transform.localScale = new Vector3(10, 10, 10);
			//******************************************************************************************
			
			//********************************从U3D转换资源中加载场景*****************************************
			var root:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			root.transform.localScale = new Vector3(100, 100, 100);
			var meshSprite3d:Sprite3D = root.addChild(new Sprite3D()) as Sprite3D;
			meshSprite3d.on(Event.HIERARCHY_LOADED, null, function(sprite:Sprite3D):void {
				var boy1:Sprite3D = meshSprite3d.getChildAt(0).getChildByName("boy1") as Sprite3D;
				//setMeshParams(boy1, false, "Assets/L5/b_Cloth_70253/b_Cloth_70253.ani");
				setMeshParams(boy1, true, "Assets/L5/g_Cloth_70843/g_Cloth_70843.ani");
				//addStarParticleSystem(new Vector3(boy1.transform.position.x, 2.0, boy1.transform.position.z));
				addPaoPaoParticleSystem(new Vector3(boy1.transform.position.x, 2.0, boy1.transform.position.z));
				
				var boy2:Sprite3D = meshSprite3d.getChildAt(0).getChildByName("boy2") as Sprite3D;
				//setMeshParams(boy2, false, "Assets/L5/b_Cloth_70343/b_Cloth_70343.ani");
				setMeshParams(boy2, true, "Assets/L5/g_Cloth_70843/g_Cloth_70843.ani");
				//addStarParticleSystem(new Vector3(boy2.transform.position.x, 2.0, boy2.transform.position.z));
				addPaoPaoParticleSystem(new Vector3(boy2.transform.position.x, 2.0, boy2.transform.position.z));
				
				var girl2:Sprite3D = meshSprite3d.getChildAt(0).getChildByName("girl2") as Sprite3D;
				//setMeshParams(girl2, false, "Assets/L5/g_Cloth_70753/g_Cloth_70753.ani");
				setMeshParams(girl2, true, "Assets/L5/g_Cloth_70843/g_Cloth_70843.ani");
				addStarParticleSystem(new Vector3(girl2.transform.position.x, 2.0, girl2.transform.position.z));
				//addPaoPaoParticleSystem(new Vector3(girl2.transform.position.x, 2.0, girl2.transform.position.z));
				
				var girl1:Sprite3D = meshSprite3d.getChildAt(0).getChildByName("girl1") as Sprite3D;
				setMeshParams(girl1, true, "Assets/L5/g_Cloth_70843/g_Cloth_70843.ani");
				addStarParticleSystem(new Vector3(girl1.transform.position.x, 2.0, girl1.transform.position.z));
				addPaoPaoParticleSystem(new Vector3(girl1.transform.position.x, 2.0, girl1.transform.position.z));
				
				var boy1_1:Sprite3D = meshSprite3d.getChildAt(0).getChildByName("boy1 (1)") as Sprite3D;
				//setMeshParams(boy1_1, false, "Assets/L5/b_Cloth_70253/b_Cloth_70253.ani");
				setMeshParams(boy1_1, true, "Assets/L5/g_Cloth_70843/g_Cloth_70843.ani");
				//addStarParticleSystem(new Vector3(boy1_1.transform.position.x, 2.0, boy1_1.transform.position.z));
				addPaoPaoParticleSystem(new Vector3(boy1_1.transform.position.x, 2.0, boy1_1.transform.position.z));
				
				var boy2_1:Sprite3D = meshSprite3d.getChildAt(0).getChildByName("boy2 (1)") as Sprite3D;
				//setMeshParams(boy2_1, false, "Assets/L5/b_Cloth_70343/b_Cloth_70343.ani");
				setMeshParams(boy2_1, true, "Assets/L5/g_Cloth_70843/g_Cloth_70843.ani");
				//addStarParticleSystem(new Vector3(boy2_1.transform.position.x, 2.0, boy2_1.transform.position.z));
				addPaoPaoParticleSystem(new Vector3(boy2_1.transform.position.x, 2.0, boy2_1.transform.position.z));
				
				var girl2_2:Sprite3D = meshSprite3d.getChildAt(0).getChildByName("girl2 (2)") as Sprite3D;
				//setMeshParams(girl2_2, false, "Assets/L5/g_Cloth_70753/g_Cloth_70753.ani");
				setMeshParams(girl2_2, true, "Assets/L5/g_Cloth_70843/g_Cloth_70843.ani");
				addStarParticleSystem(new Vector3(girl2_2.transform.position.x, 2.0, girl2_2.transform.position.z));
				//addPaoPaoParticleSystem(new Vector3(girl2_2.transform.position.x, 2.0, girl2_2.transform.position.z));
				
				var girl2_1:Sprite3D = meshSprite3d.getChildAt(0).getChildByName("girl2 (1)") as Sprite3D;
				//setMeshParams(girl2_1, true, "Assets/L5/g_Cloth_70843/g_Cloth_70843.ani");
				setMeshParams(girl2_1, true, "Assets/L5/g_Cloth_70843/g_Cloth_70843.ani");
				addStarParticleSystem(new Vector3(girl2_1.transform.position.x, 2.0, girl2_1.transform.position.z));
			
				//addPaoPaoParticleSystem(new Vector3(girl2_1.transform.position.x, 2.0, girl2_1.transform.position.z));
			});
			meshSprite3d.loadHierarchy("game.lh");
			//******************************************************************************************
			Laya.timer.frameLoop(1, this, updateParticle);
		}
		
		public function addPaoPaoParticleSystem(position:Vector3):void {
			var paopaoSettings0:ParticleSettings = new ParticleSettings();
			paopaoSettings0.textureName = "Assets/L5/particle/g_Cloth_40519_effect0.png";
			paopaoSettings0.maxPartices = 32;
			paopaoSettings0.duration = 1.7;
			paopaoSettings0.ageAddScale = 0.2;
			paopaoSettings0.minHorizontalVelocity = 0;
			paopaoSettings0.maxHorizontalVelocity = 0;
			paopaoSettings0.minVerticalVelocity = 0.0;
			paopaoSettings0.maxVerticalVelocity = 0.4;
			paopaoSettings0.gravity = new Float32Array([0.0, 0.0, 0.0]);
			paopaoSettings0.endVelocity = 1.0;
			paopaoSettings0.minRotateSpeed = -1;
			paopaoSettings0.maxRotateSpeed = 1;
			paopaoSettings0.minStartSize = 0.2;
			paopaoSettings0.maxStartSize = 0.25;
			paopaoSettings0.minEndSize = 0.2;
			paopaoSettings0.maxEndSize = 0.5;
			paopaoSettings0.blendState = 1;
			paopaoSettings0.colorComponentInter = true;
			paopaoSettings0.minStartColor = new Float32Array([0.8, 0.1, 0.0, 1.0]);
			paopaoSettings0.maxStartColor = new Float32Array([1.0, 0.6, 0.4, 1.0]);
			paopaoSettings0.minEndColor = new Float32Array([0.8, 0.1, 0.0, 1.0]);
			paopaoSettings0.maxEndColor = new Float32Array([1.0, 0.6, 0.4, 1.0]);
			
			var star0:Particle3D = new Particle3D(paopaoSettings0);
			star0.transform.position = position;
			scene.addChild(star0);
			var pointEmitter0:EmitterSphere = new EmitterSphere(star0);
			pointEmitter0.emissionRate = 15;
			pointEmitter0.radius = 1;
			emitterList.push(pointEmitter0);
			pointEmitter0.start();
		}
		
		public function addStarParticleSystem(position:Vector3):void {
			var starSettings0:ParticleSettings = new ParticleSettings();
			starSettings0.textureName = "Assets/L5/particle/b_Cloth_40001_effect.png";
			starSettings0.maxPartices = 10;
			starSettings0.duration = 0.8;
			starSettings0.ageAddScale = 0.2;
			starSettings0.minHorizontalVelocity = 0;
			starSettings0.maxHorizontalVelocity = 0;
			starSettings0.minVerticalVelocity = 0.0;
			starSettings0.maxVerticalVelocity = 0.0001;
			starSettings0.gravity = new Float32Array([0.0, 0.0, 0.0]);
			starSettings0.endVelocity = 1.0;
			starSettings0.minRotateSpeed = -1;
			starSettings0.maxRotateSpeed = 1;
			starSettings0.minStartSize = 0.2;
			starSettings0.maxStartSize = 0.35;
			starSettings0.minEndSize = 0.4;
			starSettings0.maxEndSize = 0.7;
			starSettings0.blendState = 1;
			starSettings0.minStartColor = new Float32Array([1, 1, 1, 1]);
			starSettings0.maxStartColor = new Float32Array([1, 1, 1, 1]);
			starSettings0.maxEndColor;
			
			var star0:Particle3D = new Particle3D(starSettings0);
			star0.transform.position = position;
			scene.addChild(star0);
			var pointEmitter0:EmitterSphere = new EmitterSphere(star0);
			pointEmitter0.emissionRate = 10;
			pointEmitter0.radius = 1;
			emitterList.push(pointEmitter0);
			pointEmitter0.start();
		}
		
		private function updateParticle():void {
			var currentTime:Number = Browser.now();
			var interval:Number = currentTime - lastTime;
			lastTime = currentTime;
			
			if (interval) {
				for (var i:int = 0; i < emitterList.length; i++) {
					emitterList[i].advanceTime(interval / 1000);
				}
			}
		}
		
		private function setMeshParams(spirit3D:Sprite3D, doubleFace:Boolean, anmationPath:String):void {
			if (spirit3D is Mesh) {
				var mesh:Mesh = spirit3D as Mesh;
				var tempet:MeshTemplet = mesh.templet;
				if (tempet != null) {
					var skinAni0:SkinAnimations = mesh.addComponent(SkinAnimations) as SkinAnimations;
					skinAni0.url = anmationPath;
					skinAni0.play(0);
					
					tempet.on(Event.LOADED, this, function(tempet:MeshTemplet):void {
						for (var i:int = 0; i < tempet.materials.length; i++) {
							var meterial:Material = tempet.materials[i];
							doubleFace && (meterial.cullFace = false);
						}
					});
				}
			}
			for (var i:int = 0; i < spirit3D._childs.length; i++)
				setMeshParams(spirit3D._childs[i], doubleFace, anmationPath);
		}
	}
}