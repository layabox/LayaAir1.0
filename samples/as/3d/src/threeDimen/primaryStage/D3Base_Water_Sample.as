package threeDimen.primaryStage {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.PBRMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.material.WaterMaterial;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.math.Viewport;
	import laya.d3.resource.DataTexture2D;
	import laya.d3.resource.models.BoxMesh;
	import laya.d3.resource.models.CylinderMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.QuadMesh;
	import laya.d3.resource.models.SkyBox;
	import laya.d3.resource.models.SkyDome;
	import laya.d3.resource.models.SphereMesh;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.water.WaterSprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.renders.Render;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import threeDimen.common.CameraMoveScript;
	
	public class D3Base_Water_Sample {
		public var scene:Scene;
		public var water:WaterSprite;
		public function D3Base_Water_Sample() {
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
			
			scene = Laya.stage.addChild(new Scene()) as Scene;
			
			//scene.initOctree(512, 512, 512, 5 );
			/*
			var sPath = "http://10.10.20.200:7788/teapot/teapot-Teapot001.lm";
			var pMesh = Mesh.load(sPath);
			var pMeshSprite:MeshSprite3D = new MeshSprite3D(pMesh);
			*/
			
			
			var env:String = 'inthegarden';
			//var env = 'AtticRoom';
			//var env = 'overcloud';
			
			var camera:Camera = new Camera(0, 0.1, 1000);
			camera._shaderValues.setValue(BaseCamera.HDREXPOSURE, 2.0);
			scene.addChild(camera);
			//camera.transform.translate(new Vector3(0, 1.7, 1.0));
			camera.transform.translate(new Vector3(0, 4, 6.0));
			camera.transform.rotate(new Vector3( -30, 0, 0), true, false);
			camera.addComponent(CameraMoveScript);
			camera.clearFlag = BaseCamera.CLEARFLAG_SKY;
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
			/*
			{
				var mtl:WaterMaterial = new WaterMaterial();
				mtl.diffuseTexture = Texture2D.load('./threeDimen/pbr/copper.png');
				mtl.normalTexture = Texture2D.load('./threeDimen/pbr/n1.png');
				mtl.underWaterTexture = Texture2D.load("./threeDimen/env/" + env + "/env.png");
				//mtl.underWaterTexture.repeat = true;
				var sphere:MeshSprite3D = scene.addChild( new MeshSprite3D(new SphereMesh(0.1, 32, 32))) as MeshSprite3D;
				sphere.meshRender.sharedMaterial = mtl;
				//sphere.transform.localPosition = new Vector3((x-rnum/2)*(w/rnum), 1.0, -2);
			}
			*/
			/*
			var cylinder:MeshSprite3D = scene.addChild(new MeshSprite3D(Mesh.load("./threeDimen/models/shape/cylinder1x100.lm"))) as MeshSprite3D;
			cylinder.transform.rotation = new Quaternion( -0.7071068, -0, 0, 0.7071068);
			cylinder.transform.localPosition = new Vector3(0, -10, 0);
			*/
			/*
			var dude:MeshSprite3D = scene.addChild( new MeshSprite3D( Mesh.load('./threeDimen/models/dude/dude-him.lm.lm'))) as MeshSprite3D;
			dude.transform.localPosition = new Vector3( -50, 0, 0);
			dude.transform.localScale = new Vector3(2, 2, 2);
			//dude.transform.localRotationEuler = new Vector3(0, 3.14, 0);
			*/
			
			
			var m1:MeshSprite3D = scene.addChild(new MeshSprite3D(Mesh.load("./threeDimen/models/haitan/haitan-Plane001.lm"))) as MeshSprite3D;
			m1.transform.rotation = new Quaternion( -0.7071068, -0, 0, 0.7071068);
			var mtl2:StandardMaterial= new StandardMaterial();
			mtl2.diffuseTexture = Texture2D.load('./threeDimen/water/sand.jpg');
			m1.meshRender.sharedMaterial = mtl2;
			{
				var m2:MeshSprite3D = new MeshSprite3D(Mesh.load("./threeDimen/models/haitan/haitan_s-Plane001.lm"));
				m2.transform.rotation = new Quaternion( -0.7071068, -0, 0, 0.7071068);
				var mtl3:StandardMaterial= new StandardMaterial();
				mtl3.diffuseTexture = Texture2D.load('./threeDimen/water/sand.jpg');
				m2.meshRender.sharedMaterial = mtl3;
				
				water = scene.addChild(new WaterSprite()) as WaterSprite;
				water.src = './threeDimen/water/sea1.json';
				water._scene = scene;
				water.addRefractObj(m2);
				water.transform.localPosition = new Vector3(0, .01, 0);
			}

			
			Laya.stage.on(Event.KEY_UP, this, onKeyUp);
		}
		
		/**键盘抬起处理*/
		private function onKeyUp(e:*=null):void
		{
			if (e.keyCode == 192){//~
				water.stop();
			}
			else if(e.keyCode==49){//1
				var gl:WebGLContext = WebGL.mainContext;
				var canRead:Boolean = (gl.checkFramebufferStatus(WebGLContext.FRAMEBUFFER) === WebGLContext.FRAMEBUFFER_COMPLETE);
				
				var w:int = Laya.stage.width;
				var h:int = Laya.stage.height;
				var pixels:Uint8Array = new Uint8Array(w * h * 4);
				gl.readPixels(0,0,w,h, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, pixels);
				debugger;
			}			
		}
	}
}