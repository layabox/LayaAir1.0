package materialModule {
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
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.math.Viewport;
	import laya.d3.resource.DataTexture2D;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SkyDome;
	import laya.d3.resource.models.SphereMesh;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.shader.ShaderCompile3D;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.renders.Render;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import common.CameraMoveScript;
	
	public class PBRMaterialDemo {
		
		public var scene:Scene;
		public function PBRMaterialDemo() {
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			scene = Laya.stage.addChild(new Scene()) as Scene;
			
			//var env:String = 'inthegarden';
			var env:String = 'sp_default';
			//var env = 'AtticRoom';
			//var env = 'overcloud';
			var envinfo:String = '../../../../res/threeDimen/env/' + env + '/envinfo.json';
			Laya.loader.load(envinfo, Handler.create(this, onEnvDescLoaded,[envinfo,'../../../../res/threeDimen/env/' + env + '/']));
			
		}
		
		public function onEnvDescLoaded(envinfo:String, envpath:String) {
			var envinfoobj = Laya.loader.getRes(envinfo);
			
			var camera:Camera = new Camera(0, 0.1, 1000);
			if( envinfoobj.ev!=undefined)
				camera._shaderValues.setValue(BaseCamera.HDREXPOSURE, Math.pow(2, envinfoobj.ev));
			else
				camera._shaderValues.setValue(BaseCamera.HDREXPOSURE, Math.pow(2, 0.0));			
				
			scene.addChild(camera);
			camera.transform.translate(new Vector3(0, 0, 1.0));
			camera.addComponent(CameraMoveScript);
			camera.clearFlag = BaseCamera.CLEARFLAG_SKY;
			
			var skyDome:SkyDome = new SkyDome();
			camera.sky = skyDome;
			skyDome.texture = Texture2D.load( envpath+envinfoobj.skytex);
			skyDome.environmentSpecular = DataTexture2D.load(envpath + envinfoobj.prefiltedEnv);
			var irrdMat:Float32Array = new Float32Array( envinfoobj.IrradianceMat);
			
			skyDome.envDiffuseSHRed =  irrdMat.slice(0, 16) as Float32Array;
			skyDome.envDiffuseSHGreen = irrdMat.slice(16, 32) as Float32Array;
			skyDome.envDiffuseSHBlue = irrdMat.slice(32, 48 ) as Float32Array;
			
			addTestSphere();
		}
		
		public function addTestSphere():void {
			var w:Number = 2;
			var h:Number = 1;
			var rnum:int = 10;
			var mnum:int = 4;
			for ( var y:int = mnum; y >=0; y--) {
				for ( var x:int = 0; x < rnum; x++) {
					var mtl:PBRMaterial = new PBRMaterial();
					mtl.use_groundtruth = false;
					mtl.diffuseTexture = Texture2D.load('../../../../res/threeDimen/pbr/c1.png');
					mtl.normalTexture = Texture2D.load('../../../../res/threeDimen/pbr/n1.png');
					mtl.roughness = x / rnum;
					mtl.metaless =  y / mnum;
					var sphere:MeshSprite3D = scene.addChild( new MeshSprite3D(new SphereMesh(0.1, 32, 32))) as MeshSprite3D;
					sphere.meshRender.sharedMaterial = mtl;
					sphere.transform.localPosition = new Vector3((x-rnum/2)*(w/rnum), (y-mnum/2)*(h/mnum), -2);
				}	
			}
			for ( x = 0; x < rnum; x++) {
				mtl = new PBRMaterial();
				mtl.use_groundtruth = false;
				mtl.diffuseTexture = Texture2D.load('../../../../res/threeDimen/pbr/gold.png');
				mtl.normalTexture = Texture2D.load('../../../../res/threeDimen/pbr/n1.png');
				mtl.roughness = x / rnum;
				mtl.metaless =  1.0;
				sphere = scene.addChild( new MeshSprite3D(new SphereMesh(0.1, 32, 32))) as MeshSprite3D;
				sphere.meshRender.sharedMaterial = mtl;
				sphere.transform.localPosition = new Vector3((x-rnum/2)*(w/rnum), 0.75, -2);
			}	
			for ( x = 0; x < rnum; x++) {
				mtl = new PBRMaterial();
				mtl.diffuseTexture = Texture2D.load('../../../../res/threeDimen/pbr/copper.png');
				mtl.normalTexture = Texture2D.load('../../../../res/threeDimen/pbr/n1.png');
				mtl.roughness = x / rnum;
				mtl.metaless =  1.0;
				sphere = scene.addChild( new MeshSprite3D(new SphereMesh(0.1, 32, 32))) as MeshSprite3D;
				sphere.meshRender.sharedMaterial = mtl;
				sphere.transform.localPosition = new Vector3((x-rnum/2)*(w/rnum), 1.0, -2);
			}	
			for ( x = 0; x < rnum; x++) {
				mtl = new PBRMaterial();
				mtl.diffuseTexture = Texture2D.load('../../../../res/threeDimen/pbr/c2.png');
				mtl.normalTexture = Texture2D.load('../../../../res/threeDimen/pbr/n1.png');
				mtl.roughness = x / rnum;
				mtl.metaless =  0.0;
				var sphere1:MeshSprite3D = scene.addChild( new MeshSprite3D(new SphereMesh(0.1, 32, 32))) as MeshSprite3D;
				sphere1.meshRender.sharedMaterial = mtl;
				sphere1.transform.localPosition = new Vector3((x-rnum/2)*(w/rnum), -0.75, -2);
			}	
		}
	}
}