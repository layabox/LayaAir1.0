package threeDimen.advancedStage {
	import laya.ani.AnimationTemplet;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.PBRMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.math.Viewport;
	import laya.d3.resource.DataTexture2D;
	import laya.d3.resource.models.BoxMesh;
	import laya.d3.resource.models.CylinderMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SkyBox;
	import laya.d3.resource.models.SkyDome;
	import laya.d3.resource.models.SphereMesh;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.shader.ShaderCompile3D;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.renders.Render;
	import laya.ui.HSlider;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import threeDimen.common.CameraMoveScript;
	
	public class D3Advance_PBR_Demo{
		public var scene:Scene;
		public var camera:Camera;
		protected var orientation:Number;
		protected var q0:Quaternion = new Quaternion();
		protected var q1:Quaternion = new Quaternion(-Math.sqrt(0.5), 0, 0, Math.sqrt(0.5));// - PI/2 around the x-axis
		protected var q2:Quaternion = new Quaternion();
		protected var q3:Quaternion = new Quaternion();
		private static var brickNumX:int = 2;
		private static var brickNumY:int = 5;
		private static var MtlNum:int = 10;
		private var mtls:Vector.<PBRMaterial> = new Vector.<PBRMaterial>();
		private var skinanim:SkinAnimations = null;
		protected var bricks:Vector.<MeshSprite3D> = new Vector.<MeshSprite3D>();
		private var dude:MeshSprite3D;
		
		private var lfootpos:Vector3 = new Vector3(0, 0, 0);
		private var rfootpos:Vector3 = new Vector3(0, 0, 0);
		private var lfootboneid:int =-1;
		private var rfootboneid:int =-1;
		
		private var indsphere:MeshSprite3D;
		
		public function addBricks():void {
			//indsphere = scene.addChild( new MeshSprite3D(new SphereMesh(0.1, 32, 32)));
			var startx:Number = -0.5, startz:Number = -1.5;
			var cid:int = 0;
			for ( var i:int = 0; i < MtlNum; i++) {
				var pbrmtl:PBRMaterial = new PBRMaterial();
				pbrmtl.has_tangent = true;
				pbrmtl.testClipZ = true;
				pbrmtl.diffuseTexture = Texture2D.load('./threeDimen/models/test/' + i + '/brick1C.png');
				pbrmtl.normalTexture = Texture2D.load('./threeDimen/models/test/' + i + '/brick1N.png');
				mtls.push(pbrmtl);
			}
			
			for (var y:int = 0; y < brickNumY; y++) {
				for (var x:int = 0; x < brickNumX; x++) {
					var brick:MeshSprite3D = scene.addChild( new MeshSprite3D( Mesh.load('./threeDimen/models/test/1x1-Plane001.lm.lm'))) as MeshSprite3D;
					//brick.meshRender.receiveShadow = true;
					brick.meshRender.sharedMaterial = mtls[Math.floor(Math.random()*MtlNum)];
					brick.transform.localPosition = new Vector3( startx + x, 0, startz + y);
					bricks[y * brickNumX + x] = brick;
				}
			}
			
			for ( i = 0; i < MtlNum; i++){
				var s1:MeshSprite3D = scene.addChild( new MeshSprite3D( Mesh.load('./threeDimen/models/test/1sphere-Sphere001.lm.lm'))) as MeshSprite3D;
				s1.meshRender.sharedMaterial = mtls[i];
				s1.transform.localPosition = new Vector3( -1.2, 0, -1.5+i*0.4);
				s1.transform.localScale = new Vector3(0.2, 0.2, 0.2);
			}
		}
		
		public function moveBricks():void {
			var startx:Number =-1.5, startz:Number =-1.5;
			for (var y:int = 0; y < brickNumY; y++) {
				for (var x:int = 0; x < brickNumX; x++) {
					var brick:MeshSprite3D =  bricks[y * brickNumX + x] ;
					var cpos:Vector3 = brick.transform.localPosition;
					cpos.z -= 0.01;
					if (cpos.z < -2.5) { 
						cpos.z = 2.5;
						brick.meshRender.sharedMaterial = mtls[Math.floor(Math.random() * MtlNum)];
						//brick.meshRender.receiveShadow = true;
					}
					brick.transform.localPosition = cpos;
				}
			}
		}
		
		public function D3Advance_PBR_Demo() {
			if(true){
				Laya3D.init(0, 0, false);
				Laya.stage.scaleMode = Stage.SCALE_FULL;
			}else {
				//缩放来提高效率
				Laya3D.init(600, 800, false);
				Laya.stage.scaleMode = Stage.SCALE_EXACTFIT;			
			}
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			//加载引擎需要的资源
			Laya.loader.load([
				{url:"./UI/hslider.png", type:Loader.IMAGE },
				{url:"./UI/hslider$bar.png", type:Loader.IMAGE }
				//{url:"seashader.glsl", type:Loader.TEXT },
				], 
				Handler.create(this, onLoaded));			
		}
		
		public function  onLoaded():void {
			createScene();
			//addUI();
		}
		
		public function createScene():void {
			scene = Laya.stage.addChild(new Scene()) as Scene;
			
			//scene.initOctree(512, 512, 512, 5 );
			
			var env:String = 'inthegarden';
			//var env = 'AtticRoom';
			//var env = 'overcloud';
			
			camera = new Camera(0, 0.1, 1000);
			camera._shaderValues.setValue(BaseCamera.HDREXPOSURE, 2.0);
			scene.addChild(camera);
			camera.transform.translate(new Vector3(0, 1.3, 1.0));
			var phone:Boolean = Browser.onMobile || (typeof __JS__('window').orientation !== 'undefined');
			if(!phone){
				camera.transform.rotate(new Vector3( -20, 0, 0), true, false);
				camera.addComponent(CameraMoveScript);
			}
			camera.clearFlag = BaseCamera.CLEARFLAG_SKY;
			
			//陀螺仪控制
			phone && Browser.window.addEventListener('deviceorientation', function(e:*):void {
				orientation = (Browser.window.orientation || 0);
				if (Laya.stage.canvasRotation) {
					if (Laya.stage.screenMode == Stage.SCREEN_HORIZONTAL)
						orientation += 90
					else if (Laya.stage.screenMode == Stage.SCREEN_VERTICAL)
						orientation -= 90
				}
				
				Quaternion.createFromYawPitchRoll(e.alpha / 360 * Math.PI * 2, e.beta / 360 * Math.PI * 2, -e.gamma / 360 * Math.PI * 2, q0);
				Quaternion.multiply(q0, q1, q2);
				Quaternion.createFromAxisAngle(Vector3.UnitZ, -orientation / 360 * Math.PI * 2, q3);
				Quaternion.multiply(q2, q3, camera.transform.localRotation);
				camera.transform.localRotation = camera.transform.localRotation;
			}, false);			
			
			var skyDome:SkyDome = new SkyDome();
			camera.sky = skyDome;
			skyDome.texture = Texture2D.load("./threeDimen/env/" + env + "/env.png");
			skyDome.environmentDiffuse = Texture2D.load('./threeDimen/env/' + env + '/envdiff.png');
			skyDome.environmentSpecular = DataTexture2D.load('./threeDimen/env/' + env + '/env.mipmaps');
			
			var irrdMat:Float32Array = new Float32Array([
			//用ps转换后，预处理，归一化得到的
			-0.0167906042188406,0,0,0,-0.027535762637853622,-0.03874252736568451,0,0,-0.044931963086128235,-0.0034806353505700827,0.05553313344717026,0,-0.04650728031992912,-0.009920344687998295,0.2773687243461609,0.4716099798679352,-0.01451695617288351,0,0,0,-0.025713719427585602,-0.04179200530052185,0,0,-0.04489731416106224,-0.005758579820394516,0.05630895867943764,0,-0.04720568656921387,-0.004097646567970514,0.2946115732192993,0.5021762251853943,-0.025863995775580406,0,0,0,-0.038174983114004135,-0.04787023365497589,0,0,-0.04748328775167465,-0.002980096498504281,0.07373423129320145,0,-0.053091954439878464,-0.018254835158586502,0.41009750962257385,0.4943433403968811			
			//用原始hdr数据预处理得到的
			//-0.028827406466007233, 0, 0, 0, -0.06570632755756378, -0.11633579432964325, 0, 0, -0.19282592833042145, 0.019708774983882904, 0.14516320824623108, 0, -0.18957078456878662, 0.011033795773983002, 0.6294394135475159, 0.5495293736457825, -0.031492311507463455, 0, 0, 0, -0.07013177126646042, -0.12911850214004517, 0, 0, -0.20995591580867767, 0.020593563094735146, 0.16061082482337952, 0, -0.2073422521352768, 0.014094721525907516, 0.7013687491416931, 0.6086958646774292, -0.050287481397390366, 0, 0, 0, -0.09165656566619873, -0.16871726512908936, 0, 0, -0.26018017530441284, 0.022878587245941162, 0.21900475025177002, 0, -0.2597336769104004, 0.008448993787169456, 0.9498671293258667, 0.7647525072097778
			//直接处理原始hdr
			//-0.3722280263900757,0,0,0,-0.8257625102996826,-1.4720354080200195,0,0,-2.4406485557556152,0.24875669181346893,1.8442634344100952,0,-0.894662082195282,0.05216000974178314,2.9823594093322754,1.7302136421203613,-0.406978577375412,0,0,0,-0.8812533617019653,-1.6337478160858154,0,0,-2.6573734283447266,0.2598675787448883,2.04072642326355,0,-0.9785102009773254,0.06655791401863098,3.323030710220337,1.9165292978286743,-0.6475852131843567,0,0,0,-1.151831865310669,-2.1358094215393066,0,0,-3.2940452098846436,0.2880684435367584,2.7833945751190186,0,-1.2257784605026245,0.03995578736066818,4.4990434646606445,2.408372640609741
			]);
			
			skyDome.envDiffuseSHRed =  irrdMat.slice(0, 16) as Float32Array;
			skyDome.envDiffuseSHGreen = irrdMat.slice(16, 32) as Float32Array;
			skyDome.envDiffuseSHBlue = irrdMat.slice(32, 48 ) as Float32Array;
			
			//var skinMesh:MeshSprite3D = scene.addChild(new MeshSprite3D(Mesh.load("./threeDimen/models/1/1-MF000.lm"))) as MeshSprite3D;
			//skinMesh.transform.localRotationEuler = new Vector3(0, 3.14, 0);
			//var girl:Sprite3D = scene.addChild(Sprite3D.load("./threeDimen/models/1/1.lh")) as Sprite3D;
			//var dude:Sprite3D = scene.addChild(Sprite3D.load("./threeDimen/models/dude/dude.lh")) as Sprite3D;
			dude = scene.addChild( new MeshSprite3D( Mesh.load('./threeDimen/models/dude/dude-him.lm.lm'))) as MeshSprite3D;
			dude.transform.localPosition = new Vector3( 0, 0, 0);
			dude.transform.localScale = new Vector3(2, 2, 2);
			dude.transform.localRotationEuler = new Vector3(0, 3.14, 0);
			//dude.meshRender.castShadow = true;
			skinanim = dude.addComponent(SkinAnimations) as SkinAnimations;
			skinanim.templet = AnimationTemplet.load('./threeDimen/models/dude/dude.lsani');
			skinanim.templet.on(Event.LOADED, this, function():void { 
				lfootboneid = this.skinanim.templet.getNodeIndexWithName(0,'L_Ball');
				rfootboneid = this.skinanim.templet.getNodeIndexWithName(0,'R_Ball');
			} );
			skinanim.player.play();
			addBricks();
			/*
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
						directionLight.ambientColor = new Vector3(0.7, 0.6, 0.6);
						directionLight.specularColor = new Vector3(1.0, 1.0, 0.9);
						directionLight.diffuseColor = new Vector3(1, 1, 1);
						directionLight.direction = new Vector3(0.5292,-0.81758,0.2269);
						directionLight.shadow = true;//阴影开关
						
			*/
			Laya.stage.on(Event.KEY_UP, this, onKeyUp);
			Laya.timer.frameLoop(1, this, _update);
		}
		
		public function addUI():void {
			var hs:HSlider = new HSlider();	
			hs.skin = "./UI/hslider.png";
			hs.width = 300;
			hs.pos(50, 170);
			hs.min = 0;
			hs.max = 100;
			hs.value = 50;
			hs.tick = 1;
			hs.changeHandler = new Handler(this, onSldChange);
			Laya.stage.addChild(hs);			
		}
		private function onSldChange(value:Number):void {
			camera._shaderValues.setValue(BaseCamera.HDREXPOSURE, value/100);			
		}
		
		/**键盘抬起处理*/
		private function onKeyUp(e:*=null):void
		{
			if (e.keyCode == 192)//~
			{
				var pbrshaderc:ShaderCompile3D = ShaderCompile3D.get('PBR');
				pbrshaderc.sharders = [];
			}
		}
		private function onKeyDown(e:*= null):void {
				
		}
		
		public function _update(state:RenderState):void {
			/*
			if (lfootboneid >= 0 && rfootboneid >= 0) {
				var animdatas:Float32Array = skinanim.curBonesDatas;
				if (animdatas) {
					var bonemat:Matrix4x4 =  new Matrix4x4();
					var matrixE:Float32Array = bonemat.elements;
					var worldMatrix:Matrix4x4 = dude.transform.worldMatrix;
					
					var poses:Float32Array = new Float32Array(8);
					
					var idx:int = rfootboneid * 16;
					for (var j:int = 0; j < 16; j++)
						matrixE[j] = animdatas[idx + j];
					Matrix4x4.multiply(worldMatrix, bonemat, bonemat);
					poses[0] = bonemat.elements[12];
					poses[1] = bonemat.elements[13];
					poses[2] = bonemat.elements[14];
					poses[3] = 0.05;
					
					idx = lfootboneid * 16;
					for (j= 0; j < 16; j++)
						matrixE[j] = animdatas[idx + j];
					Matrix4x4.multiply(worldMatrix, bonemat, bonemat);
					poses[4] = bonemat.elements[12];
					poses[5] = bonemat.elements[13];
					poses[6] = bonemat.elements[14];
					poses[7] = 0.05;
					
					//indsphere.transform.localPosition = new Vector3(poses[4], poses[5], poses[6]);
					
					for (var y:int = 0; y < brickNumY; y++) {
						for (var x:int = 0; x < brickNumX; x++) {
							var brick:MeshSprite3D =  bricks[y * brickNumX + x] ;
								brick.meshRender.sharedMaterial._shaderValues.setValue(PBRMaterial.AOOBJPOS, poses);
						}
					}
				}
			}
			*/
			moveBricks();
			//console.log( skinanim.player.currentPlayTime);
		}
	}
}