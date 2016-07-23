package threeDimen.primaryStage {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.component.animation.UVAnimations;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.PhasorSpriter3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.camera.BaseCamera;
	import laya.d3.core.camera.Camera;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.light.LightSprite;
	import laya.d3.core.light.PointLight;
	import laya.d3.core.light.SpotLight;
	import laya.d3.core.material.Material;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.math.Viewport;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.utils.Picker;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.ui.Button;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	
	public class D3Base_LightAndMaterialSample {
		private var currentShadingMode:int;
		private var currentLightState:int;
		private var currentLight:LightSprite;
		private var scene:Scene;
		
		private var buttonLight:Button;
		private var shadingLight:Button;
		private var skinMesh:MeshSprite3D;
		private var skinAni:SkinAnimations;
		private var directionLight:DirectionLight;
		private var pointLight:PointLight;
		private var spotLight:SpotLight;
		private var tempQuaternion:Quaternion;
		private var tempVector3:Vector3;
		
		public function D3Base_LightAndMaterialSample() {
			tempQuaternion = new Quaternion();
			tempVector3 = new Vector3();
			currentShadingMode = BaseScene.PIXEL_SHADING;
			currentLightState = 0;
			
			//是否抗锯齿
			//Config.isAntialias = true;
			Laya3D.init(0, 0);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			loadUI();
			
			scene = Laya.stage.addChild(new Scene()) as Scene;
			
			scene.currentCamera = (scene.addChild(new Camera(new Viewport(0, 0, RenderState.clientWidth, RenderState.clientHeight), Math.PI / 3, 0, 0.1, 100))) as Camera;
			scene.currentCamera.transform.translate(new Vector3(0, 0.8, 1.2));
			scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			scene.currentCamera.clearColor = null;
			var _this:D3Base_LightAndMaterialSample = this;
			Laya.stage.on(Event.RESIZE, null, function():void {
				(_this.scene.currentCamera as Camera).viewport = new Viewport(0, 0, RenderState.clientWidth, RenderState.clientHeight);
			});
			
			directionLight = scene.addChild(new DirectionLight()) as DirectionLight;
			directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
			directionLight.specularColor = new Vector3(1.0, 1.0, 0.9);
			directionLight.diffuseColor = new Vector3(1, 1, 1);
			directionLight.direction = new Vector3(0, -1.0, -1.0);
			currentLight = directionLight;
			
			pointLight = new PointLight();
			pointLight.ambientColor = new Vector3(0.8, 0.5, 0.5);
			pointLight.specularColor = new Vector3(1.0, 1.0, 0.9);
			pointLight.diffuseColor = new Vector3(1, 1, 1);
			pointLight.transform.position = new Vector3(0.4, 0.4, 0.0);
			pointLight.attenuation = new Vector3(0.0, 0.0, 3.0);
			pointLight.range = 3.0;
			
			spotLight = new SpotLight();
			spotLight.ambientColor = new Vector3(1.0, 1.0, 0.8);
			spotLight.specularColor = new Vector3(1.0, 1.0, 0.8);
			spotLight.diffuseColor = new Vector3(1, 1, 1);
			spotLight.transform.position = new Vector3(0.0, 1.2, 0.0);
			spotLight.direction = new Vector3(-0.2, -1.0, 0.0);
			spotLight.attenuation = new Vector3(0.0, 0.0, 0.8);
			spotLight.range = 3.0;
			spotLight.spot = 32;
			
			scene.shadingMode = currentShadingMode;
			
			var grid:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			
			 //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
			grid.on(Event.HIERARCHY_LOADED, null, function(sprite:Sprite3D):void {
				var meshSprite:MeshSprite3D = sprite.getChildAt(0) as MeshSprite3D;
				var mesh:BaseMesh = meshSprite.mesh;
				mesh.once(Event.LOADED, null, function(templet:BaseMesh):void {
					for (var i:int = 0; i < meshSprite.materials.length; i++) {
						var material:Material = meshSprite.materials[i];
						material.once(Event.LOADED, null, function():void {
							material.diffuseColor = new Vector3(0.7, 0.7, 0.7);
							material.specularColor = new Vector4(0.2, 0.2, 0.2, 32);
						});
					}
				});
			});
			grid.loadHierarchy("../../../../res/threeDimen/staticModel/grid/plane.lh");
			
			var sphere:Sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
			sphere.loadHierarchy("../../../../res/threeDimen/staticModel/sphere/sphere.lh");
			sphere.transform.localScale = new Vector3(0.2, 0.2, 0.2);
			sphere.transform.localPosition = new Vector3(0.0, 0.0, 0.2);
			
			skinMesh = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/dude/dude-him.lm"))) as MeshSprite3D;
			
			Laya.stage.timer.frameLoop(1, null, function():void {
				switch (_this.currentLightState) {
				case 0: 
					Quaternion.createFromYawPitchRoll(0.03, 0, 0, _this.tempQuaternion);
					Vector3.transformQuat(_this.directionLight.direction, _this.tempQuaternion, _this.directionLight.direction);
					break;
				case 1: 
					Quaternion.createFromYawPitchRoll(0.03, 0, 0, _this.tempQuaternion);
					Vector3.transformQuat(_this.pointLight.transform.position, _this.tempQuaternion, _this.tempVector3);
					_this.pointLight.transform.position = _this.tempVector3;
					break;
				case 2: 
					Quaternion.createFromYawPitchRoll(0.03, 0, 0, _this.tempQuaternion);
					Vector3.transformQuat(_this.spotLight.transform.position, _this.tempQuaternion, _this.tempVector3);
					_this.spotLight.transform.position = _this.tempVector3;
					Vector3.transformQuat(_this.spotLight.direction, _this.tempQuaternion, _this.spotLight.direction);
					break;
				}
			});
		}
		
		private function loadUI():void {
			var _this:D3Base_LightAndMaterialSample = this;
			Laya.loader.load(["../../../../res/threeDimen/ui/button.png"], Handler.create(null, function():void {
				_this.buttonLight = new Button();
				_this.buttonLight.skin = "../../../../res/threeDimen/ui/button.png";
				_this.buttonLight.label = "平行光";
				_this.buttonLight.labelBold = true;
				_this.buttonLight.labelSize = 20;
				_this.buttonLight.sizeGrid = "4,4,4,4";
				_this.buttonLight.size(120, 30);
				_this.buttonLight.scale(Browser.pixelRatio, Browser.pixelRatio);
				_this.buttonLight.pos(Laya.stage.width / 2 - _this.buttonLight.width * Browser.pixelRatio / 2, Laya.stage.height - 100 * Browser.pixelRatio);
				_this.buttonLight.on(Event.CLICK, _this, _this.onclickButtonLight);
				Laya.stage.addChild(_this.buttonLight);
				
				_this.shadingLight = new Button();
				_this.shadingLight.skin = "../../../../res/threeDimen/ui/button.png";
				_this.shadingLight.label = "像素着色";
				_this.shadingLight.labelBold = true;
				_this.shadingLight.labelSize = 20;
				_this.shadingLight.sizeGrid = "4,4,4,4";
				_this.shadingLight.size(120, 30);
				_this.shadingLight.scale(Browser.pixelRatio, Browser.pixelRatio);
				_this.shadingLight.pos(Laya.stage.width / 2 - _this.shadingLight.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
				_this.shadingLight.on(Event.CLICK, _this, _this.onclickButtonShading);
				Laya.stage.addChild(_this.shadingLight);
				
				Laya.stage.on(Event.RESIZE, null, function():void {
					_this.buttonLight.pos(Laya.stage.width / 2 - _this.buttonLight.width * Browser.pixelRatio / 2, Laya.stage.height - 100 * Browser.pixelRatio);
					_this.shadingLight.pos(Laya.stage.width / 2 - _this.shadingLight.width * Browser.pixelRatio / 2, Laya.stage.height - 50 * Browser.pixelRatio);
				});
			
			}));
		
		}
		
		private function onclickButtonShading():void {
			currentShadingMode++;
			(currentShadingMode > BaseScene.PIXEL_SHADING) && (currentShadingMode = BaseScene.VERTEX_SHADING);
			if (currentShadingMode == BaseScene.VERTEX_SHADING) {
				shadingLight.label = "顶点着色";
			} else {
				shadingLight.label = "像素着色";
			}
			scene.shadingMode = currentShadingMode;
		}
		
		private function onclickButtonLight():void {
			currentLightState++;
			(currentLightState > 2) && (currentLightState = 0);
			currentLight.removeSelf();
			switch (currentLightState) {
			case 0: 
				buttonLight.label = "平行光";
				currentLight = directionLight;
				scene.addChild(directionLight);
				break;
			case 1: 
				buttonLight.label = "点光源";
				currentLight = pointLight;
				scene.addChild(pointLight);
				break;
			case 2: 
				buttonLight.label = "聚光灯";
				currentLight = spotLight;
				scene.addChild(spotLight);
				break;
			}
		
		}
	}
}