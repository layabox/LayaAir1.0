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
	import laya.d3.resource.models.SkyBox;
	import laya.d3.resource.models.SkyDome;
	import laya.d3.resource.models.SphereMesh;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.shader.ShaderCompile3D;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.renders.Render;
	import laya.utils.Stat;
	import threeDimen.common.CameraMoveScript;
	
	public class D3Base_Material_PBR_Sample {
		public var scene:Scene;
		public function addTestSphere():void {
			var w:Number = 2;
			var h:Number = 1;
			var rnum:int = 10;
			var mnum:int = 4;
			var crough:Number = 0.0;
			var cmetal:Number = 0.0;
			for ( var y:int = mnum; y >=0; y--) {
				for ( var x:int = 0; x < rnum; x++) {
					var mtl:PBRMaterial = new PBRMaterial();
					mtl.diffuseTexture = Texture2D.load('./threeDimen/pbr/c1.png');
					mtl.normalTexture = Texture2D.load('./threeDimen/pbr/n1.png');
					mtl.roughness = x / rnum;
					mtl.metaless =  y / mnum;
					var sphere:MeshSprite3D = scene.addChild( new MeshSprite3D(new SphereMesh(0.1, 32, 32))) as MeshSprite3D;
					sphere.meshRender.sharedMaterial = mtl;
					sphere.transform.localPosition = new Vector3((x-rnum/2)*(w/rnum), (y-mnum/2)*(h/mnum), -2);
				}	
			}
			for ( x = 0; x < rnum; x++) {
				mtl = new PBRMaterial();
				mtl.diffuseTexture = Texture2D.load('./threeDimen/pbr/gold.png');
				mtl.normalTexture = Texture2D.load('./threeDimen/pbr/n1.png');
				mtl.roughness = x / rnum;
				mtl.metaless =  1.0;
				sphere = scene.addChild( new MeshSprite3D(new SphereMesh(0.1, 32, 32))) as MeshSprite3D;
				sphere.meshRender.sharedMaterial = mtl;
				sphere.transform.localPosition = new Vector3((x-rnum/2)*(w/rnum), 0.75, -2);
			}	
			for ( x = 0; x < rnum; x++) {
				mtl = new PBRMaterial();
				mtl.diffuseTexture = Texture2D.load('./threeDimen/pbr/copper.png');
				mtl.normalTexture = Texture2D.load('./threeDimen/pbr/n1.png');
				mtl.roughness = x / rnum;
				mtl.metaless =  1.0;
				sphere = scene.addChild( new MeshSprite3D(new SphereMesh(0.1, 32, 32))) as MeshSprite3D;
				sphere.meshRender.sharedMaterial = mtl;
				sphere.transform.localPosition = new Vector3((x-rnum/2)*(w/rnum), 1.0, -2);
			}	
			for ( x = 0; x < rnum; x++) {
				mtl = new PBRMaterial();
				mtl.diffuseTexture = Texture2D.load('./threeDimen/pbr/c2.png');
				mtl.normalTexture = Texture2D.load('./threeDimen/pbr/n1.png');
				mtl.roughness = x / rnum;
				mtl.metaless =  0.0;
				var sphere1:MeshSprite3D = scene.addChild( new MeshSprite3D(new SphereMesh(0.1, 32, 32))) as MeshSprite3D;
				sphere1.meshRender.sharedMaterial = mtl;
				sphere1.transform.localPosition = new Vector3((x-rnum/2)*(w/rnum), -0.75, -2);
			}	
		}
		
		public function D3Base_Material_PBR_Sample() {
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
			camera.transform.translate(new Vector3(0, 0, 1.0));
			//camera.transform.rotate(new Vector3( -30, 0, 0), true, false);
			camera.addComponent(CameraMoveScript);
			camera.clearFlag = BaseCamera.CLEARFLAG_SKY;
			
			var skyDome:SkyDome = new SkyDome();
			camera.sky = skyDome;
			skyDome.texture = Texture2D.load("./threeDimen/env/" + env + "/env.png");
			skyDome.environmentDiffuse = Texture2D.load('./threeDimen/env/' + env + '/envdiff.png');
			skyDome.environmentSpecular = DataTexture2D.load('./threeDimen/env/' + env + '/env.mipmaps');
			var irrdMat:Float32Array = new Float32Array([
			-0.01679060608148575, 0, 0, 0, 0.02753576636314392, -0.03874252736568451, 0, 0, 0.044931963086128235, -0.003480631159618497, 0.05553313344717026, 0, 
			-0.009920341894030571, 0.04650728404521942, 0.2773687243461609, 0.4716099798679352, -0.01451695803552866, 0, 0, 0, 0.02571372501552105, -0.04179200157523155, 0, 
			0, 0.04489731416106224, -0.0057585760951042175, 0.05630895867943764, 0, -0.0040976423770189285, 0.047205690294504166, 0.2946115732192993, 0.5021762251853943, 
			-0.025863999500870705, 0, 0, 0, 0.038174986839294434, -0.04787023365497589, 0, 0, 0.04748328775167465, -0.0029800923075526953, 0.07373423129320145, 0, -0.018254831433296204, 
			0.053091954439878464, 0.41009750962257385, 0.4943433403968811]);
			
			skyDome.envDiffuseSHRed =  irrdMat.slice(0, 16) as Float32Array;
			skyDome.envDiffuseSHGreen = irrdMat.slice(16, 32) as Float32Array;
			skyDome.envDiffuseSHBlue = irrdMat.slice(32, 48 ) as Float32Array;
			
			addTestSphere();
			/*
			var mtl1:PBRMaterial = new PBRMaterial();
			mtl1.diffuseTexture = Texture2D.load('./threeDimen/pbr/basecolor.png');
			mtl1.normalTexture = Texture2D.load('./threeDimen/pbr/normal.png');
			mtl1.pbrInfoTexture = Texture2D.load('./threeDimen/pbr/orm.png');
			var sphere1:MeshSprite3D = scene.addChild( new MeshSprite3D(new SphereMesh(0.1, 32, 32))) as MeshSprite3D;
			//var cc:* = (sphere1.meshFilter.sharedMesh as Mesh).getSubMesh(0)._vertexBuffer.vertexDeclaration.getVertexElements();
			var cc:* = (sphere1.meshFilter.sharedMesh as SphereMesh)._vertexBuffer.vertexDeclaration.getVertexElements();
			sphere1.meshRender.sharedMaterial = mtl1;
			sphere1.transform.localPosition = new Vector3(0, 0, 0);
			sphere1.transform.localScale = new Vector3(1, 1, 1);
			*/
			/*
			var mtl2:PBRMaterial = new PBRMaterial();
			var land:MeshSprite3D = scene.addChild( new MeshSprite3D(Mesh.load('./threeDimen/models/tai/tai.lm'))) as MeshSprite3D;
			land.meshRender.sharedMaterial = mtl2;
			mtl2.has_tangent = true;
			mtl2.diffuseTexture = Texture2D.load('./threeDimen/env/'+env+'/ny.png');
			mtl2.normalTexture = Texture2D.load('./threeDimen/pbr/normal.png');
			mtl2.pbrInfoTexture = Texture2D.load('./threeDimen/pbr/mirror.png');
			land.transform.localPosition = new Vector3(0, -0.1, 0);
			land.transform.localRotationEuler = new Vector3( -3.14 / 2, 0, 0);
			//var skinMesh:MeshSprite3D = scene.addChild(new MeshSprite3D(Mesh.load("./threeDimen/models/1/1-MF000.lm"))) as MeshSprite3D;
			//skinMesh.transform.localRotationEuler = new Vector3(0, 3.14, 0);
			var girl:Sprite3D = scene.addChild(Sprite3D.load("./threeDimen/models/1/1.lh")) as Sprite3D;
			*/
			Laya.stage.on(Event.KEY_UP, this, onKeyUp);
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
	}
}