package laya.d3Extend.lineRender {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.shader.SubShader;
	import laya.d3.shader.ShaderDefines;
	
	/**
	 * ...
	 * @author
	 */
	public class LineMaterial extends BaseMaterial {
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:LineMaterial = new LineMaterial();
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
		}
		
		public static function initShader():void {
			
			var attributeMap:Object = {
				'a_Position': VertexMesh.MESH_POSITION0, 
				'a_Color': VertexMesh.MESH_COLOR0, 
				'a_Texcoord0': VertexMesh.MESH_TEXTURECOORDINATE0};
			var uniformMap:Object = {
				'u_MvpMatrix': [Sprite3D.MVPMATRIX, SubShader.PERIOD_SPRITE], 
				'u_WorldMat': [Sprite3D.WORLDMATRIX, SubShader.PERIOD_SPRITE]};
			
			var vs:String = __INCLUDESTR__("shader/line.vs");
			var ps:String = __INCLUDESTR__("shader/line.ps");
			
			var lineShaderCompile3D:SubShader = SubShader.add("LineShader", attributeMap, uniformMap);
			lineShaderCompile3D.addShaderPass(vs, ps);
		}
		
		public function LineMaterial() {
			setShaderName("LineShader");
			super(1);
		}
	
	}

}