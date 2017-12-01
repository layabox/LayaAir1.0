package laya.d3.graphics {
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	
	/**
	 * <code>VertexShurikenParticle</code> 类用于创建粒子顶点结构。
	 */
	public class VertexShurikenParticleMesh implements IVertex {
		/**@private */
		private static const _vertexDeclaration:VertexDeclaration = new VertexDeclaration(172, [
		new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.POSITION0),
		new VertexElement(12, VertexElementFormat.Vector4, VertexElementUsage.COLOR0),
		new VertexElement(28, VertexElementFormat.Vector2, VertexElementUsage.TEXTURECOORDINATE0),
		new VertexElement(36, VertexElementFormat.Vector4, VertexElementUsage.SHAPEPOSITIONSTARTLIFETIME), 
		new VertexElement(52, VertexElementFormat.Vector4, VertexElementUsage.DIRECTIONTIME), 
		new VertexElement(68, VertexElementFormat.Vector4, VertexElementUsage.STARTCOLOR0), 
		new VertexElement(84, VertexElementFormat.Vector3, VertexElementUsage.STARTSIZE), 
		new VertexElement(96, VertexElementFormat.Vector3, VertexElementUsage.STARTROTATION), 
		new VertexElement(108, VertexElementFormat.Single, VertexElementUsage.STARTSPEED), 
		new VertexElement(112, VertexElementFormat.Vector4, VertexElementUsage.RANDOM0), 
		new VertexElement(128, VertexElementFormat.Vector4, VertexElementUsage.RANDOM1), 
		new VertexElement(144, VertexElementFormat.Vector3, VertexElementUsage.SIMULATIONWORLDPOSTION),//TODO:local模式下可省去内存
		new VertexElement(156,VertexElementFormat.Vector4, VertexElementUsage.SIMULATIONWORLDROTATION)]);
		
		public static function get vertexDeclaration():VertexDeclaration {
			return _vertexDeclaration;
		}
		
		/**@private */
		private var _cornerTextureCoordinate:Vector4;
		/**@private */
		private var _positionStartLifeTime:Vector4;
		/**@private */
		private var _velocity:Vector3;
		/**@private */
		private var _startColor:Vector4;
		/**@private */
		private var _startSize:Vector3;
		/**@private */
		private var _startRotation0:Vector3;
		/**@private */
		private var _startRotation1:Vector3;
		/**@private */
		private var _startRotation2:Vector3;
		/**@private */
		private var _startLifeTime:Number;
		/**@private */
		private var _time:Number;
		/**@private */
		private var _startSpeed:Number;
		/**@private */
		private var _randoms0:Vector4;
		/**@private */
		private var _randoms1:Vector4;
		/**@private */
		private var _simulationWorldPostion:Vector3;
		
		public function get cornerTextureCoordinate():Vector4 {
			return _cornerTextureCoordinate;
		}
		
		public function get position():Vector4 {
			return _positionStartLifeTime;
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
		
		public function VertexShurikenParticleMesh(cornerTextureCoordinate:Vector4, positionStartLifeTime:Vector4, velocity:Vector3, startColor:Vector4, startSize:Vector3, startRotation0:Vector3, startRotation1:Vector3, startRotation2:Vector3, ageAddScale:Number, time:Number, startSpeed:Number, randoms0:Vector4, randoms1:Vector4, simulationWorldPostion:Vector3) {
			_cornerTextureCoordinate = cornerTextureCoordinate;
			_positionStartLifeTime = positionStartLifeTime;
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