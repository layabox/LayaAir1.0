package laya.d3.graphics {
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	
	/**
	 * <code>VertexPositionTerrain</code> 类用于创建位置、法线、纹理1、纹理2顶点结构。
	 */
	public class VertexPositionTerrain implements IVertex {
		
		private static const _vertexDeclaration:VertexDeclaration = new VertexDeclaration( 40, [
			new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.POSITION0),
			new VertexElement(12, VertexElementFormat.Vector3, VertexElementUsage.NORMAL0),
			new VertexElement(24, VertexElementFormat.Vector2, VertexElementUsage.TEXTURECOORDINATE0),
			new VertexElement(32, VertexElementFormat.Vector2, VertexElementUsage.TEXTURECOORDINATE1)]);
		
		public static function get vertexDeclaration():VertexDeclaration
		{
			return _vertexDeclaration;
		}
		
		private var _position:Vector3;
		private var _normal:Vector3;
		private var _textureCoord0:Vector2;
		private var _textureCoord1:Vector2;
		
		public function get position():Vector3 {
			return _position;
		}
		
		public function get normal():Vector3 {
			return _normal;
		}
		
		public function get textureCoord0():Vector2 {
			return _textureCoord0;
		}
		
		public function get textureCoord1():Vector2 {
			return _textureCoord1;
		}
		
		public function get vertexDeclaration():VertexDeclaration {
			return _vertexDeclaration;
		}
		
		public function VertexPositionTerrain(position:Vector3, normal:Vector3, textureCoord0:Vector2, textureCoord1:Vector2) {
			_position = position;
			_normal = normal;
			_textureCoord0 = textureCoord0;
			_textureCoord1 = textureCoord1;
		}
	
	}

}