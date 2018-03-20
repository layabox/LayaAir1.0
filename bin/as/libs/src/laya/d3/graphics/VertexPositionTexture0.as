package laya.d3.graphics {
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	
	/**
	 * <code>VertexPositionNormalTexture</code> 类用于创建位置、纹理顶点结构。
	 */
	public class VertexPositionTexture0 implements IVertex {
		
		private static const _vertexDeclaration:VertexDeclaration = new VertexDeclaration( 20, [
		new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.POSITION0),
		new VertexElement(12, VertexElementFormat.Vector2, VertexElementUsage.TEXTURECOORDINATE0)]);
		
		public static function get vertexDeclaration():VertexDeclaration
		{
			return _vertexDeclaration;
		}
		
		private var _position:Vector3;
		private var _textureCoordinate0:Vector2;
		
		public function get position():Vector3 {
			return _position;
		}
		
		public function get textureCoordinate0():Vector2 {
			return _textureCoordinate0;
		}
		
		public function get vertexDeclaration():VertexDeclaration {
			return _vertexDeclaration;
		}
		
		public function VertexPositionTexture0(position:Vector3, textureCoordinate0:Vector2) {
			_position = position;
			_textureCoordinate0 = textureCoordinate0;
		}
	
	}

}