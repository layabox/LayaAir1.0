package laya.d3.graphics {
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	
	/**
	 * <code>VertexPositionNormalColorTangent</code> 类用于创建粒子顶点结构。
	 */
	public class VertexParticle implements IVertex {
		
		private static const _vertexDeclaration:VertexDeclaration = new VertexDeclaration(116, 
		[new VertexElement(0, VertexElementFormat.Vector4, VertexElementUsage.CORNERTEXTURECOORDINATE0), 
		new VertexElement(16, VertexElementFormat.Vector3, VertexElementUsage.POSITION0), 
		new VertexElement(28, VertexElementFormat.Vector3, VertexElementUsage.VELOCITY0), 
		new VertexElement(40, VertexElementFormat.Vector4, VertexElementUsage.STARTCOLOR0), 
		new VertexElement(56, VertexElementFormat.Vector4, VertexElementUsage.ENDCOLOR0), 
		new VertexElement(72, VertexElementFormat.Vector3, VertexElementUsage.SIZEROTATION0), 
		new VertexElement(84, VertexElementFormat.Vector2, VertexElementUsage.RADIUS0), 
		new VertexElement(92, VertexElementFormat.Vector4, VertexElementUsage.RADIAN0), 
		new VertexElement(108, VertexElementFormat.Single, VertexElementUsage.STARTLIFETIME), //TODO待确认。。
		new VertexElement(112, VertexElementFormat.Single, VertexElementUsage.TIME0)]);
		
		public static function get vertexDeclaration():VertexDeclaration {
			return _vertexDeclaration;
		}
		
		private var _cornerTextureCoordinate:Vector4;
		private var _position:Vector3;
		private var _velocity:Vector3;
		private var _startColor:Vector4;
		private var _endColor:Vector4;
		private var _sizeRotation:Vector3;
		private var _radius:Vector2;
		private var _radian:Vector4;
		private var _ageAddScale:Number;
		private var _time:Number;
		
		public function get cornerTextureCoordinate():Vector4 {
			return _cornerTextureCoordinate;
		}
		
		public function get position():Vector3 {
			return _position;
		}
		
		public function get velocity():Vector3 {
			return _velocity;
		}
		
		public function get startColor():Vector4 {
			return _startColor;
		}
		
		public function get endColor():Vector4 {
			return _endColor;
		}
		
		public function get sizeRotation():Vector3 {
			return _sizeRotation;
		}
		
		public function get radius():Vector2 {
			return _radius;
		}
		
		public function get radian():Vector4 {
			return _radian;
		}
		
		public function get ageAddScale():Number {
			return _ageAddScale;
		}
		
		public function get time():Number {
			return _time;
		}
		
		public function get vertexDeclaration():VertexDeclaration {
			return _vertexDeclaration;
		}
		
		public function VertexParticle(cornerTextureCoordinate:Vector4, position:Vector3, velocity:Vector3, startColor:Vector4, endColor:Vector4, sizeRotation:Vector3, radius:Vector2, radian:Vector4, ageAddScale:Number, time:Number) {
			_cornerTextureCoordinate = cornerTextureCoordinate;
			_position = position;
			_velocity = velocity;
			_startColor = startColor;
			_endColor = endColor;
			_sizeRotation = sizeRotation;
			_radius = radius;
			_radian = radian;
			_ageAddScale = ageAddScale;
			_time = time;
		}
	
	}

}