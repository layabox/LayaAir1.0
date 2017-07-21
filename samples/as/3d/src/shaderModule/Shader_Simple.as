package shaderModule {
	import laya.d3.core.Camera;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.models.CapsuleMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SphereMesh;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderCompile3D;
	import laya.display.Stage;
	import laya.utils.Stat;
	import common.CameraMoveScript;
	import shaderModule.customMaterials.CustomMaterial;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Shader_Simple {
		
		private var rotation:Vector3 = new Vector3(0, 0.01, 0);
		public function Shader_Simple() {
			
			Laya3D.init(0, 0, true);
			Laya.stage.scaleMode = Stage.SCALE_FULL;
			Laya.stage.screenMode = Stage.SCREEN_NONE;
			Stat.show();
			
			initShader();
			
			var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
			
			var camera:Camera = (scene.addChild(new Camera(0, 0.1, 100))) as Camera;
			camera.transform.translate(new Vector3(0, 0.5, 1.5));
			camera.addComponent(CameraMoveScript);
			
			var layaMonkey:MeshSprite3D = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/LayaMonkey/Assets/LayaMonkey/LayaMonkey-LayaMonkey.lm"))) as MeshSprite3D;
			layaMonkey.transform.localScale = new Vector3(0.3, 0.3, 0.3);
            layaMonkey.transform.rotation = new Quaternion(0.7071068, 0, 0, -0.7071067);
			
			var customMaterial:CustomMaterial = new CustomMaterial();
			layaMonkey.meshRender.sharedMaterial = customMaterial;
			
			 Laya.timer.frameLoop(1, this, function():void {
                layaMonkey.transform.rotate(rotation, false);
            });
			
		}
		
		private function initShader():void {
			
			var attributeMap:Object = {
				'a_Position': VertexElementUsage.POSITION0, 
				'a_Normal': VertexElementUsage.NORMAL0};
			var uniformMap:Object = {
				'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_WorldMat': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE]};
			var customShader:int = Shader3D.nameKey.add("CustomShader");
			var vs:String = __INCLUDESTR__("customShader/simpleShader.vs");
			var ps:String = __INCLUDESTR__("customShader/simpleShader.ps");
			ShaderCompile3D.add(customShader, vs, ps, attributeMap, uniformMap);
		}
	
	}

}