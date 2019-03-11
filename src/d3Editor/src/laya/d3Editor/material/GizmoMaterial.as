package laya.d3Editor.material {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.math.Vector4;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.SubShader;
	
	/**
	 * <code>GizmoMaterial</code> 类用于材质。
	 */
	public class GizmoMaterial extends BaseMaterial {
		
		public static const COLOR:int = Shader3D.propertyNameToID("u_Color");
		
		/**
		 * 获取颜色。
		 * @return 颜色。
		 */
		public function get color():Vector4 {
			return _shaderValues.getVector(COLOR) as Vector4;
		}
		
		/**
		 * 设置颜色。
		 * @param value 颜色。
		 */
		public function set color(value:Vector4):void {
			_shaderValues.setVector(COLOR, value);
		}
		
		public static function initShader():void {
			
			var attributeMap:Object = {
				'a_Position': VertexMesh.MESH_POSITION0, 
				'a_Normal': VertexMesh.MESH_NORMAL0
			};
			var uniformMap:Object = {
				'u_MvpMatrix': Shader3D.PERIOD_SPRITE, 
				'u_WorldMat': Shader3D.PERIOD_SPRITE, 
				'u_CameraPos':Shader3D.PERIOD_CAMERA, 
				'u_Color': Shader3D.PERIOD_MATERIAL
			};
			var vs:String = __INCLUDESTR__("shader/Gizmo.vs");
			var ps:String = __INCLUDESTR__("shader/Gizmo.ps");
			var gizmoShader:Shader3D = Shader3D.add("Gizmo");
			var subShader:SubShader = new SubShader(attributeMap, uniformMap);
			gizmoShader.addSubShader(subShader);
			subShader.addShaderPass(vs,ps);
		}
		
		public function GizmoMaterial() {
			super();
			setShaderName("Gizmo");
			_shaderValues.setVector(COLOR, new Vector4(1.0, 1.0, 1.0, 1.0));
		}
		
	}

}