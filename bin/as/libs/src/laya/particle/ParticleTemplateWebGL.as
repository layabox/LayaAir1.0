package laya.particle {
	import laya.webgl.utils.Buffer;
	
	/**
	 *  @private
	 */
	public class ParticleTemplateWebGL extends ParticleTemplateBase {
		protected var _vertices:Float32Array;
		protected var _vertexBuffer:Buffer;
		protected var _indexBuffer:Buffer;
		protected var _floatCountPerVertex:uint = 29;//0~3为CornerTextureCoordinate,4~6为Position,7~9Velocity,10到13为StartColor,14到17为EndColor,18到20位SizeRotation，21到22位Radius,23到26位Radian，27为DurationAddScaleShaderValue,28为Time
		
		protected var _firstActiveElement:int;
		protected var _firstNewElement:int;
		protected var _firstFreeElement:int;
		protected var _firstRetiredElement:int;
		
		public var _currentTime:Number = 0;
		protected var _drawCounter:int;
		
		public function ParticleTemplateWebGL(parSetting:ParticleSetting) {
			settings = parSetting;
		}
		
		protected function initialize():void {
			_vertices = new Float32Array(settings.maxPartices * _floatCountPerVertex * 4);
			
			var particleOffset:int;
			for (var i:int = 0; i < settings.maxPartices; i++) {
				var random:Number = Math.random();
				var cornerYSegement:Number = settings.textureCount ? 1.0 / settings.textureCount : 1.0;
				var cornerY:Number;
				
				for (cornerY = 0; cornerY < settings.textureCount; cornerY += cornerYSegement) {
					if (random < cornerY + cornerYSegement)
						break;
				}
				particleOffset = i * _floatCountPerVertex * 4;
				_vertices[particleOffset + _floatCountPerVertex * 0 + 0] = -1;
				_vertices[particleOffset + _floatCountPerVertex * 0 + 1] = -1;
				_vertices[particleOffset + _floatCountPerVertex * 0 + 2] = 0;
				_vertices[particleOffset + _floatCountPerVertex * 0 + 3] = cornerY;
				
				_vertices[particleOffset + _floatCountPerVertex * 1 + 0] = 1;
				_vertices[particleOffset + _floatCountPerVertex * 1 + 1] = -1;
				_vertices[particleOffset + _floatCountPerVertex * 1 + 2] = 1;
				_vertices[particleOffset + _floatCountPerVertex * 1 + 3] = cornerY;
				
				_vertices[particleOffset + _floatCountPerVertex * 2 + 0] = 1;
				_vertices[particleOffset + _floatCountPerVertex * 2 + 1] = 1;
				_vertices[particleOffset + _floatCountPerVertex * 2 + 2] = 1;
				_vertices[particleOffset + _floatCountPerVertex * 2 + 3] = cornerY + cornerYSegement;
				
				_vertices[particleOffset + _floatCountPerVertex * 3 + 0] = -1;
				_vertices[particleOffset + _floatCountPerVertex * 3 + 1] = 1;
				_vertices[particleOffset + _floatCountPerVertex * 3 + 2] = 0;
				_vertices[particleOffset + _floatCountPerVertex * 3 + 3] = cornerY + cornerYSegement;
			}
		}
		
		protected function loadContent():void {
		}
		
		public function update(elapsedTime:int):void {
			_currentTime += elapsedTime / 1000;
			retireActiveParticles();
			freeRetiredParticles();
			
			if (_firstActiveElement == _firstFreeElement)
				_currentTime = 0;
			
			if (_firstRetiredElement == _firstActiveElement)
				_drawCounter = 0;
		}
		
		private function retireActiveParticles():void {
			const epsilon:Number = 0.0001;
			var particleDuration:Number = settings.duration;
			while (_firstActiveElement != _firstNewElement) {
				var offset:int = _firstActiveElement * _floatCountPerVertex * 4;
				var index:int = offset + 28;//28为Time
				var particleAge:Number = _currentTime - _vertices[index];
				particleAge *= (1.0 + _vertices[offset + 27]);//真实时间
				if (particleAge+epsilon < particleDuration)
					break;
				
				_vertices[index] = _drawCounter;
				
				_firstActiveElement++;
				
				if (_firstActiveElement >= settings.maxPartices)
					_firstActiveElement = 0;
			}
		}
		
		private function freeRetiredParticles():void {
			while (_firstRetiredElement != _firstActiveElement) {
				var age:int = _drawCounter - _vertices[_firstRetiredElement * _floatCountPerVertex * 4 + 28];//28为Time
				//GPU从不滞后于CPU两帧，出于显卡驱动BUG等安全因素考虑滞后三帧
				if (age < 3)
					break;
				
				_firstRetiredElement++;
				
				if (_firstRetiredElement >= settings.maxPartices)
					_firstRetiredElement = 0;
			}
		}
		
		public function addNewParticlesToVertexBuffer():void {
		}
		
		public override function addParticleArray(position:Float32Array, velocity:Float32Array):void//由于循环队列判断算法，当下一个freeParticle等于retiredParticle时不添加例子，意味循环队列中永远有一个空位。（由于此判断算法快速、简单，所以放弃了使循环队列饱和的复杂算法（需判断freeParticle在retiredParticle前、后两种情况并不同处理））
		{
			var nextFreeParticle:int = _firstFreeElement + 1;
			
			if (nextFreeParticle >= settings.maxPartices)
				nextFreeParticle = 0;
			
			if (nextFreeParticle === _firstRetiredElement)
				return;
			
			var particleData:ParticleData = ParticleData.Create(settings, position, velocity, _currentTime);
			
			var startIndex:int = _firstFreeElement * _floatCountPerVertex * 4;
			for (var i:int = 0; i < 4; i++) {
				var j:int, offset:int;
				for (j = 0, offset = 4; j < 3; j++)
					_vertices[startIndex + i * _floatCountPerVertex + offset + j] = particleData.position[j];
				
				for (j = 0, offset = 7; j < 3; j++)
					_vertices[startIndex + i * _floatCountPerVertex + offset + j] = particleData.velocity[j];
				
				for (j = 0, offset = 10; j < 4; j++)
					_vertices[startIndex + i * _floatCountPerVertex + offset + j] = particleData.startColor[j];
					
				for (j = 0, offset = 14; j < 4; j++)
					_vertices[startIndex + i * _floatCountPerVertex + offset + j] = particleData.endColor[j];
				
				for (j = 0, offset = 18; j < 3; j++)//StartSize,EndSize,Rotation
					_vertices[startIndex + i * _floatCountPerVertex + offset + j] = particleData.sizeRotation[j];
				
				for (j = 0, offset = 21; j < 2; j++)//StartRadius,EndRadius
					_vertices[startIndex + i * _floatCountPerVertex + offset + j] = particleData.radius[j];
				
				for (j = 0, offset = 23; j < 4; j++)//StartHorizontalRadian,StartVerticleRadian,EndHorizontalRadian,EndVerticleRadian
					_vertices[startIndex + i * _floatCountPerVertex + offset + j] = particleData.radian[j];
				
				_vertices[startIndex + i * _floatCountPerVertex + 27] = particleData.durationAddScale;
				
				_vertices[startIndex + i * _floatCountPerVertex + 28] = particleData.time;
			}
			
			_firstFreeElement = nextFreeParticle;
		}
	
	}
}