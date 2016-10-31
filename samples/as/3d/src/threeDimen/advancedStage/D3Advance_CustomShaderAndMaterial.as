package threeDimen.advancedStage {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.math.Vector3;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.models.Mesh;
	import laya.display.Stage;
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer2D;
	import threeDimen.advancedStage.custom.CustomMaterial;
	
	/**
	 * ...
	 * @author ...
	 */
	public class D3Advance_CustomShaderAndMaterial {
		
		public function D3Advance_CustomShaderAndMaterial() {
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			initShader();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:BaseCamera = new Camera(0, 0.1, 100);
			(scene.addChild(camera)) as Camera;
			camera.transform.translate(new Vector3(0, 0.8, 1.5));
			camera.transform.rotate(new Vector3(-30, 0, 0), true, false);
			
			var mesh:Mesh = Mesh.load("../../../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm");
			var meshSprite3D:MeshSprite3D = scene.addChild(new MeshSprite3D(mesh)) as MeshSprite3D;
			meshSprite3D.transform.localPosition = new Vector3(-0.3, 0.0, 0.0);
			meshSprite3D.transform.localScale = new Vector3(0.5, 0.5, 0.5);
			
			Laya.loader.load("../../../../res/threeDimen/staticModel/sphere/gridWhiteBlack.jpg", Handler.create(null,function(texture:Texture2D):void{
				var customMaterial:CustomMaterial = new CustomMaterial();
				customMaterial.diffuseTexture = texture;
			    meshSprite3D.meshRender.sharedMaterial = customMaterial;
			}), null, Loader.TEXTURE2D);
		}
		
		private function initShader():void {
			var vs:String, ps:String;
			var shaderNameMap:* = {
				'a_Position': VertexElementUsage.POSITION0, 
				'a_Normal':VertexElementUsage.NORMAL0,
				'a_Texcoord': VertexElementUsage.TEXTURECOORDINATE0, 
				'u_MvpMatrix': Buffer2D.MVPMATRIX, 
				'u_texture': Buffer2D.DIFFUSETEXTURE,
				'u_WorldMat':Buffer2D.MATRIX1
			};
			var customShader:int = Shader.nameKey.add("CustomShader");
			vs = __INCLUDESTR__("shader/customShader.vs");
			ps = __INCLUDESTR__("shader/customShader.ps");
			Shader.preCompile(customShader, vs, ps, shaderNameMap);
		}
	
	}

}