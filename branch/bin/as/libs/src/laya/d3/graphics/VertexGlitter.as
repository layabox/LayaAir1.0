package laya.d3.graphics {
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	
	/**
	 * <code>VertexPositionNormalColorTangent</code> 类用于创建粒子顶点结构。
	 */
	public class VertexGlitter implements IVertex {
		
		private static const _vertexDeclaration:VertexDeclaration = new VertexDeclaration(24, 
		[new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.POSITION0), 
		new VertexElement(12, VertexElementFormat.Vector2, VertexElementUsage.TEXTURECOORDINATE0), 
		new VertexElement(20, VertexElementFormat.Single, VertexElementUsage.TIME0)]);
		
		public static function get vertexDeclaration():VertexDeclaration {
			return _vertexDeclaration;
		}
		
		private var _position:Vector3;
		private var _textureCoordinate0:Vector2;
		private var _time:Number;
	
		
		public function get position():Vector3 {
			return _position;
		}
		
		public function get textureCoordinate():Vector2 {
			return _textureCoordinate0;
		}
		
		public function get time():Number {
			return _time;
		}
		
		public function get vertexDeclaration():VertexDeclaration {
			return _vertexDeclaration;
		}

		
		public function VertexGlitter(position:Vector3, textureCoordinate:Vector2, time:Number) {
			_position = position;
			_textureCoordinate0 = textureCoordinate;
			_time = time;
		}
	
	}

}