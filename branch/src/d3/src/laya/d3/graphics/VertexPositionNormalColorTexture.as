package laya.d3.graphics {
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	
	/**
	 * <code>VertexPositionNormalColorTexture</code> 类用于创建位置、法线、颜色、纹理顶点结构。
	 */
	public class VertexPositionNormalColorTexture implements IVertex {
		
		private static const _vertexDeclaration:VertexDeclaration = new VertexDeclaration( 48, [
		new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.POSITION0),
		new VertexElement(12, VertexElementFormat.Vector3, VertexElementUsage.NORMAL0),
		new VertexElement(24, VertexElementFormat.Vector4, VertexElementUsage.COLOR0),
		new VertexElement(40, VertexElementFormat.Vector2, VertexElementUsage.TEXTURECOORDINATE0)]);
		
		public static function get vertexDeclaration():VertexDeclaration
		{
			return _vertexDeclaration;
		}
		
		private var _position:Vector3;
		private var _normal:Vector3;
		private var _color:Vector4;
		private var _textureCoordinate:Vector2;
		
		public function get position():Vector3 {
			return _position;
		}
		
		public function get normal():Vector3 {
			return _normal;
		}
		
		public function get color():Vector4 {
			return _color;
		}
		
		public function get textureCoordinate():Vector2 {
			return _textureCoordinate;
		}
		
		public function get vertexDeclaration():VertexDeclaration {
			return _vertexDeclaration;
		}
		
		public function VertexPositionNormalColorTexture(position:Vector3, normal:Vector3, color:Vector4, textureCoordinate:Vector2) {
			_position = position;
			_normal = normal;
			_color = color;
			_textureCoordinate = textureCoordinate;
		}
	
	}

}