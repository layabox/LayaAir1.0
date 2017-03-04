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
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
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
			scene.addChild(camera);
			camera.transform.translate(new Vector3(0, 1.7, 1.0));
			camera.transform.rotate(new Vector3( -30, 0, 0), true, false);
			camera.addComponent(CameraMoveScript);
			camera.clearFlag = BaseCamera.CLEARFLAG_SKY;
			
			var skyDome:SkyDome = new SkyDome();
			camera.sky = skyDome;
			skyDome.texture = Texture2D.load("./threeDimen/env/" + env + "/env.png");
			skyDome.environmentDiffuse = Texture2D.load('./threeDimen/env/' + env + '/envdiff.png');
			skyDome.environmentSpecular = DataTexture2D.load('./threeDimen/env/'+env+'/env.mipmaps');
			
			var mtl1:PBRMaterial = new PBRMaterial();
			mtl1.diffuseTexture = Texture2D.load('./threeDimen/pbr/basecolor.png');
			mtl1.normalTexture = Texture2D.load('./threeDimen/pbr/normal.png');
			mtl1.pbrInfoTexture = Texture2D.load('./threeDimen/pbr/orm.png');
			var sphere1:MeshSprite3D = scene.addChild( new MeshSprite3D(new SphereMesh(0.1, 32, 32))) as MeshSprite3D;
			sphere1.meshRender.sharedMaterial = mtl1;
			sphere1.transform.localPosition = new Vector3(0, 0, 0);
			sphere1.transform.localScale = new Vector3(1, 1, 1);
			var mtl2:PBRMaterial = new PBRMaterial();
			var land:MeshSprite3D = scene.addChild( new MeshSprite3D(Mesh.load('./threeDimen/models/tai/tai.lm'))) as MeshSprite3D;
			land.meshRender.sharedMaterial = mtl2;
			mtl2.diffuseTexture = Texture2D.load('./threeDimen/env/'+env+'/ny.png');
			mtl2.normalTexture = Texture2D.load('./threeDimen/pbr/normal.png');
			mtl2.pbrInfoTexture = Texture2D.load('./threeDimen/pbr/mirror.png');
			
			land.transform.localPosition = new Vector3(0, -0.1, 0);
			land.transform.localRotationEuler = new Vector3( -3.14 / 2, 0, 0);
			
			//var skinMesh:MeshSprite3D = scene.addChild(new MeshSprite3D(Mesh.load("./threeDimen/models/1/1-MF000.lm"))) as MeshSprite3D;
			//skinMesh.transform.localRotationEuler = new Vector3(0, 3.14, 0);
			var girl:Sprite3D = scene.addChild(Sprite3D.load("./threeDimen/models/1/1.lh")) as Sprite3D;
			
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