package laya.d3.graphics {
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	
	/**
	 * <code>VertexPositionNormalColorTangent</code> 类用于创建位置、法线、颜色、切线顶点结构。
	 */
	public class VertexPositionNormalColorTangent implements IVertex {
		
		private static const _vertexDeclaration:VertexDeclaration = new VertexDeclaration( 52, [
		new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.POSITION0),
		new VertexElement(12, VertexElementFormat.Vector3, VertexElementUsage.NORMAL0),
		new VertexElement(24, VertexElementFormat.Vector4, VertexElementUsage.COLOR0),
		new VertexElement(40, VertexElementFormat.Vector3, VertexElementUsage.TANGENT0)]);
		
		public static function get vertexDeclaration():VertexDeclaration
		{
			return _vertexDeclaration;
		}
		
		private var _position:Vector3;
		private var _normal:Vector3;
		private var _color:Vector4;
		private var _tangent:Vector4;
		
		public function get position():Vector3 {
			return _position;
		}
		
		public function get normal():Vector3 {
			return _normal;
		}
		
		public function get color():Vector4 {
			return _color;
		}
		
		public function get tangent():Vector4 {
			return _tangent;
		}
		
		public function get vertexDeclaration():VertexDeclaration {
			return _vertexDeclaration;
		}
		
		public function VertexPositionNormalColorTangent(position:Vector3, normal:Vector3, color:Vector4, tangent:Vector4) {
			_position = position;
			_normal = normal;
			_color = color;
			_tangent = tangent;
		}
	
	}

}