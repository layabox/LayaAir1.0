package laya.d3.graphics {
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	
	/**
	 * <code>VertexPositionNormalColorTangent</code> 类用于创建粒子顶点结构。
	 */
	public class VertexParticleShuriken implements IVertex {
		
		private static const _vertexDeclaration:VertexDeclaration = new VertexDeclaration(160, [new VertexElement(0, VertexElementFormat.Vector4, VertexElementUsage.CORNERTEXTURECOORDINATE0), new VertexElement(16, VertexElementFormat.Vector3, VertexElementUsage.POSITION0), new VertexElement(28, VertexElementFormat.Vector3, VertexElementUsage.DIRECTION), new VertexElement(40, VertexElementFormat.Vector4, VertexElementUsage.STARTCOLOR0), new VertexElement(56, VertexElementFormat.Vector3, VertexElementUsage.STARTSIZE), new VertexElement(68, VertexElementFormat.Vector3, VertexElementUsage.STARTROTATION0), new VertexElement(80, VertexElementFormat.Vector3, VertexElementUsage.STARTROTATION1), new VertexElement(92, VertexElementFormat.Vector3, VertexElementUsage.STARTROTATION2), new VertexElement(104, VertexElementFormat.Single, VertexElementUsage.STARTLIFETIME), new VertexElement(108, VertexElementFormat.Single, VertexElementUsage.TIME0), new VertexElement(112, VertexElementFormat.Single, VertexElementUsage.STARTSPEED), new VertexElement(116, VertexElementFormat.Vector4, VertexElementUsage.RANDOM0), new VertexElement(132, VertexElementFormat.Vector4, VertexElementUsage.RANDOM1), new VertexElement(148, VertexElementFormat.Vector3, VertexElementUsage.SIMULATIONWORLDPOSTION)]);
		
		public static function get vertexDeclaration():VertexDeclaration {
			return _vertexDeclaration;
		}
		
		private var _cornerTextureCoordinate:Vector4;
		private var _position:Vector3;
		private var _velocity:Vector3;
		private var _startColor:Vector4;
		private var _startSize:Vector3;
		private var _startRotation0:Vector3;
		private var _startRotation1:Vector3;
		private var _startRotation2:Vector3;
		private var _startLifeTime:Number;
		private var _time:Number;
		private var _startSpeed:Number;
		private var _randoms0:Vector4;
		private var _randoms1:Vector4;
		private var _simulationWorldPostion:Vector3;
		
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
		
		public function get startSize():Vector3 {
			return _startSize;
		}
		
		public function get startRotation0():Vector3 {
			return _startRotation0;
		}
		
		public function get startRotation1():Vector3 {
			return _startRotation1;
		}
		
		public function get startRotation2():Vector3 {
			return _startRotation2;
		}
		
		public function get startLifeTime():Number {
			return _startLifeTime;
		}
		
		public function get time():Number {
			return _time;
		}
		
		public function get startSpeed():Number {
			return _startSpeed;
		}
		
		public function get random0():Vector4 {
			return _randoms0;
		}
		
		public function get random1():Vector4 {
			return _randoms1;
		}
		
		public function get simulationWorldPostion():Vector3 {
			return _simulationWorldPostion;
		}
		
		public function get vertexDeclaration():VertexDeclaration {
			return _vertexDeclaration;
		}
		
		public function VertexParticleShuriken(cornerTextureCoordinate:Vector4, position:Vector3, velocity:Vector3, startColor:Vector4, startSize:Vector3, startRotation0:Vector3, startRotation1:Vector3, startRotation2:Vector3, ageAddScale:Number, time:Number, startSpeed:Number, randoms0:Vector4, randoms1:Vector4, simulationWorldPostion:Vector3) {
			_cornerTextureCoordinate = cornerTextureCoordinate;
			_position = position;
			_velocity = velocity;
			_startColor = startColor;
			_startSize = startSize;
			_startRotation0 = startRotation0;
			_startRotation1 = startRotation1;
			_startRotation2 = startRotation2;
			_startLifeTime = ageAddScale;
			_time = time;
			_startSpeed = startSpeed;
			_randoms0 = random0;
			_randoms1 = random1;
			_simulationWorldPostion = simulationWorldPostion;
		}
	
	}

}