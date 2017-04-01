package laya.d3.graphics {
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	
	/**
	 * <code>VertexPositionNormalColorTextureSkin</code> 类用于创建位置、法线、颜色、纹理、骨骼索引、骨骼权重顶点结构。
	 */
	public class VertexPositionNormalTextureSkin implements IVertex {
		
		private static const _vertexDeclaration:VertexDeclaration = new VertexDeclaration( 64, [
		new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.POSITION0),
		new VertexElement(12, VertexElementFormat.Vector3, VertexElementUsage.NORMAL0),
		new VertexElement(24, VertexElementFormat.Vector2, VertexElementUsage.TEXTURECOORDINATE0),
		new VertexElement(32, VertexElementFormat.Vector4, VertexElementUsage.BLENDWEIGHT0),
		new VertexElement(48, VertexElementFormat.Vector4, VertexElementUsage.BLENDINDICES0)]);
		
		public static function get vertexDeclaration():VertexDeclaration
		{
			return _vertexDeclaration;
		}
		
		private var _position:Vector3;
		private var _normal:Vector3;
		private var _textureCoordinate:Vector2;
		private var _blendIndex:Vector4;
		private var _blendWeight:Vector4;
		
		public function get position():Vector3 {
			return _position;
		}
		
		public function get normal():Vector3 {
			return _normal;
		}
		
		public function get textureCoordinate():Vector2 {
			return _textureCoordinate;
		}
		
		public function get blendIndex():Vector4 {
			return _blendIndex;
		}
		
		public function get blendWeight():Vector4 {
			return _blendWeight;
		}
		
		public function get vertexDeclaration():VertexDeclaration {
			return _vertexDeclaration;
		}
		
		public function VertexPositionNormalTextureSkin(position:Vector3, normal:Vector3, textureCoordinate:Vector2, blendIndex:Vector4, blendWeight:Vector4) {
			_position = position;
			_normal = normal;
			_textureCoordinate = textureCoordinate;
			_blendIndex = blendIndex;
			_blendWeight = blendWeight;
		}
	
	}

}