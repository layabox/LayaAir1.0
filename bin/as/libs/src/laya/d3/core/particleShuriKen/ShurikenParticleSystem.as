package laya.d3.core.particleShuriKen {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.particleShuriKen.ShuriKenParticle3D;
	import laya.d3.core.particleShuriKen.emitter.ParticleBaseEmitter;
	import laya.d3.core.particleShuriKen.module.ColorOverLifetime;
	import laya.d3.core.particleShuriKen.module.FrameOverTime;
	import laya.d3.core.particleShuriKen.module.RotationOverLifetime;
	import laya.d3.core.particleShuriKen.module.SizeOverLifetime;
	import laya.d3.core.particleShuriKen.module.StartFrame;
	import laya.d3.core.particleShuriKen.module.TextureSheetAnimation;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexParticleShuriken;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.shader.ShaderDefines3D;
	import laya.maths.MathUtil;
	import laya.particle.ParticleEmitter;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.ValusArray;
	
	/**
	 * <code>ShurikenParticleSystem</code> 类用于创建3D粒子数据模板。
	 */
	public class ShurikenParticleSystem implements IRenderable {
		/**@private */
		private var _vertices:Float32Array;
		/**@private */
		private var _floatCountPerVertex:uint;
		/**@private */
		private var _firstActiveElement:int;
		/**@private */
		private var _firstNewElement:int;
		/**@private */
		private var _firstFreeElement:int;
		/**@private */
		private var _firstRetiredElement:int;
		/**@private */
		private var _drawCounter:int;
		/**@private */
		private var _currentTime:Number;
		/**@private */
		private var _vertexBuffer:VertexBuffer3D;
		/**@private */
		private var _indexBuffer:IndexBuffer3D;
		
		/**@private */
		private var _maxParticles:int;
		/**@private */
		private var _particleShapeEmitter:ParticleBaseEmitter;
		
		/**粒子运行的总时长，单位为秒。*/
		public var duration:Number;
		/**是否循环。*/
		public var looping:Boolean;
		/**是否预热。暂不支持*/
		public var prewarm:Boolean;
		/**开始延迟，不能和prewarm一起使用。缺少1种模式,暂不支持*/
		public var startDelay:Number;
		
		/**开始生命周期模式,0为恒定时间，2为两个恒定之间的随机插值。缺少1、3模式*/
		public var startLifeTimeType:int;
		/**开始生命周期，0模式,单位为秒。*/
		public var constantStartLifeTime:Number;
		/**最小开始生命周期，1模式,单位为秒。*/
		public var constantMinStartLifeTime:Number;
		/**最大开始生命周期，1模式,单位为秒。*/
		public var constantMaxStartLifeTime:Number;
		
		/**开始速度模式，0为恒定速度，2为两个恒定速度的随机插值。缺少1、3模式*/
		public var startSpeedType:int;
		/**开始速度,0模式。*/
		public var constantStartSpeed:Number;
		/**最小开始速度,1模式。*/
		public var constantMinStartSpeed:Number;
		/**最大开始速度,1模式。*/
		public var constantMaxStartSpeed:Number;
		
		/**3D开始尺寸，暂不支持*/
		public var threeDStartSize:Boolean;
		/**开始尺寸模式,0为恒定尺寸，2为两个恒定尺寸的随机插值。缺少1、3模式和对应的四种3D模式*/
		public var startSizeType:int;
		/**开始尺寸，0模式。*/
		public var constantStartSize:Number;
		/**最小开始尺寸，1模式。*/
		public var constantMinStartSize:Number;
		/**最大开始尺寸，1模式。*/
		public var constantMaxStartSize:Number;
		
		/**3D开始旋转，暂不支持*/
		public var threeDStartRotation:Boolean;
		/**开始旋转模式,0为恒定尺寸，2为两个恒定旋转的随机插值,缺少2种模式,和对应的四种3D模式。*/
		public var startRotationType:int;
		/**开始旋转，0模式。*/
		public var constantStartRotation:Number;
		/**最小开始旋转，1模式。*/
		public var constantMinStartRotation:Number;
		/**最大开始旋转，1模式。*/
		public var constantMaxStartRotation:Number;
		
		/**随机旋转方向，范围为0.0到1.0*/
		public var randomizeRotationDirection:Number;
		
		/**开始颜色模式，0为恒定颜色，2为两个恒定颜色的随机插值,缺少2种模式。*/
		public var startColorType:int;
		/**开始颜色，0模式。*/
		public var constantStartColor:Vector4;
		/**最小开始颜色，1模式。*/
		public var constantMinStartColor:Vector4;
		/**最大开始颜色，1模式。*/
		public var constantMaxStartColor:Vector4;
		
		/**重力。*/
		public var gravity:Vector3;//TODO:应使用全局,待验证算法是否正确
		/**重力敏感度。*/
		public var gravityModifier:Number;
		/**模拟器空间,0为Local,1为World。暂不支持*/
		public var simulationSpace:int;
		/**缩放模式，0为Hiercachy,1为Local,2为World。暂不支持1,2*/
		public var scaleMode:int;
		/**是否自动开始。*/
		public var playOnAwake:Boolean;
		/**是否自动随机种子*/
		//public var autoRandomSeed:int;
		
		/**生命周期颜色。*/
		public var colorOverLifetime:ColorOverLifetime;
		/**生命周期尺寸。*/
		public var sizeOverLifetime:SizeOverLifetime;
		/**生命周期旋转。*/
		public var rotationOverLifetime:RotationOverLifetime;
		/**纹理序列帧动画。*/
		public var textureSheetAnimation:TextureSheetAnimation;
		
		/**当前粒子时间。*/
		public function get currentTime():Number {
			return _currentTime;
		}
		
		/**获取最大粒子数。*/
		public function get maxPartices():int {
			return _maxParticles - 1;
		}
		
		/**设置最大粒子数,注意:谨慎修改此属性，有性能损耗。*/
		public function set maxPartices(value:int):void {
			var newMaxParticles:int = value + 1;
			if (newMaxParticles !== _maxParticles) {
				_maxParticles = newMaxParticles;
				if (_vertexBuffer) {
					_vertexBuffer.dispose();
					_indexBuffer.dispose();
				}
				_initPartVertexDatas();
				_initIndexDatas();
			}
		}
		
		/**
		 * 获取发射器。
		 */
		public function get particleShapeEmitter():ParticleBaseEmitter {
			return _particleShapeEmitter;
		}
		
		/**
		 * 设置发射器。
		 */
		public function set particleShapeEmitter(value:ParticleBaseEmitter):void {
			if (_particleShapeEmitter)
				_particleShapeEmitter._particleSystem = null;
			
			_particleShapeEmitter = value;
			value._particleSystem = this;
		}
		
		public function get indexOfHost():int {
			return 0;
		}
		
		public function get _vertexBufferCount():int {
			return 1;
		}
		
		public function get triangleCount():int {
			return _indexBuffer.indexCount / 3;
		}
		
		public function _getVertexBuffer(index:int = 0):VertexBuffer3D {
			if (index === 0)
				return _vertexBuffer;
			else
				return null;
		}
		
		public function _getIndexBuffer():IndexBuffer3D {
			return _indexBuffer;
		}
		
		public function ShurikenParticleSystem() {
			_currentTime = 0;
			_floatCountPerVertex = 27;//0~3为CornerTextureCoordinate,4~6为Position,7~9Direction,10到13为StartColor,14到16位StartSize,17到19位StartRptation，20为StartLifeTime,21为Time,22为startSpeed,23到26为random
			
			_maxParticles = 1000;
			duration = 5.0;
			looping = true;
			prewarm = false;
			startDelay = 0.0;
			startLifeTimeType = 0;
			constantStartLifeTime = 5.0;
			constantMinStartLifeTime = 0.0;
			constantMaxStartLifeTime = 5.0;
			startSpeedType = 0;
			constantStartSpeed = 5.0;
			constantMinStartSpeed = 0.0;
			constantMaxStartSpeed = 5.0;
			threeDStartSize = false;
			startSizeType = 0;
			constantStartSize = 1;
			constantMinStartSize = 0;
			constantMaxStartSize = 1;
			threeDStartRotation = false;
			startRotationType = 0;
			constantStartRotation = 0;
			constantMinStartRotation = 0;
			constantMaxStartRotation = 0;
			randomizeRotationDirection = 0;
			startColorType = 0;
			constantStartColor = new Vector4(1, 1, 1, 1);
			constantMinStartColor = new Vector4(1, 1, 1, 1);
			constantMaxStartColor = new Vector4(1, 1, 1, 1);
			gravity = new Vector3(0, -9.81, 0);
			gravityModifier = 0;
			simulationSpace = 0;
			scaleMode = 0;
			playOnAwake = true;
			//autoRandomSeed = true;
		}
		
		private function retireActiveParticles():void {
			var maxLifeTime:Number;
			switch (startLifeTimeType) {//TODO:待考虑1、3生命周期情况
			case 0: 
				maxLifeTime = constantStartLifeTime;
				break;
			case 2: 
				maxLifeTime = constantMaxStartLifeTime;
				break;
			}
			
			while (_firstActiveElement != _firstNewElement) {
				var index:int = _firstActiveElement * _floatCountPerVertex * 4;
				var timeIndex:int = index + 21;//21为Time
				var particleAge:Number = _currentTime - _vertices[timeIndex];
				if (particleAge < maxLifeTime)
					break;
				
				_vertices[timeIndex] = _drawCounter;
				
				_firstActiveElement++;
				if (_firstActiveElement >= _maxParticles)
					_firstActiveElement = 0;
			}
		}
		
		private function freeRetiredParticles():void {
			while (_firstRetiredElement != _firstActiveElement) {
				var age:int = _drawCounter - _vertices[_firstRetiredElement * _floatCountPerVertex * 4 + 21];//21为Time
				if (age < 3)//GPU从不滞后于CPU两帧，出于显卡驱动BUG等安全因素考虑滞后三帧
					break;
				
				_firstRetiredElement++;
				if (_firstRetiredElement >= _maxParticles)
					_firstRetiredElement = 0;
			}
		}
		
		private function _setPartVertexDatas(subU:Number, subV:Number, startU:Number, startV:Number):void {
			for (var i:int = 0; i < _maxParticles; i++) {
				var particleOffset:int = i * _floatCountPerVertex * 4;
				_vertices[particleOffset + _floatCountPerVertex * 0 + 0] = -0.5;
				_vertices[particleOffset + _floatCountPerVertex * 0 + 1] = -0.5;
				
				_vertices[particleOffset + _floatCountPerVertex * 1 + 0] = 0.5;
				_vertices[particleOffset + _floatCountPerVertex * 1 + 1] = -0.5;
				
				_vertices[particleOffset + _floatCountPerVertex * 2 + 0] = 0.5;
				_vertices[particleOffset + _floatCountPerVertex * 2 + 1] = 0.5;
				
				_vertices[particleOffset + _floatCountPerVertex * 3 + 0] = -0.5;
				_vertices[particleOffset + _floatCountPerVertex * 3 + 1] = 0.5;
			}
		}
		
		private function _initPartVertexDatas():void {
			_vertexBuffer = VertexBuffer3D.create(VertexParticleShuriken.vertexDeclaration, _maxParticles * 4, WebGLContext.DYNAMIC_DRAW);
			_vertices = new Float32Array(_maxParticles * _floatCountPerVertex * 4);
			
			var enableSheetAnimation:Boolean = textureSheetAnimation && textureSheetAnimation.enbale;
			if (enableSheetAnimation) {
				var title:Vector2 = textureSheetAnimation.title;
				var titleX:int = title.x, titleY:int = title.y;
				var subU:Number = 1.0 / titleX, subV:Number = 1.0 / titleY;
				
				var totalFrameCount:int;
				var startRow:int;
				var randomRow:Boolean = textureSheetAnimation.randomRow;
				switch (textureSheetAnimation.type) {
				case 0://Whole Sheet
					totalFrameCount = titleX * titleY;
					break;
				case 1://Singal Row
					totalFrameCount = titleX;
					if (randomRow)
						startRow = Math.round(Math.random() * titleY);
					else
						startRow = 0;
					break;
				}
				
				var startFrameCount:int;
				var startFrame:StartFrame = textureSheetAnimation.startFrame;
				switch (startFrame.type) {
				case 0://常量模式
					startFrameCount = startFrame.constant;
					break;
				case 1://随机双常量模式
					startFrameCount = Math.round(MathUtil.lerp(startFrame.constantMin, startFrame.constantMax, Math.random()));
					break;
				}
				
				var frame:FrameOverTime = textureSheetAnimation.frame;
				switch (frame.type) {
				case 0: 
					startFrameCount += frame.constant;
					break;
				case 2: 
					startFrameCount += Math.round(MathUtil.lerp(frame.constantMin, frame.constantMax, Math.random()));
					break;
				}
				
				if (!randomRow)
					startRow = Math.floor(startFrameCount / titleX);
				
				var startCol:int = startFrameCount % titleX;
				_setPartVertexDatas(subU, subV, startCol * subU, startRow * subV);
			} else {
				_setPartVertexDatas(1.0, 1.0, 0.0, 0.0);
			}
		}
		
		private function _initIndexDatas():void {
			_indexBuffer = IndexBuffer3D.create(IndexBuffer3D.INDEXTYPE_USHORT, _maxParticles * 6, WebGLContext.STATIC_DRAW);
			var indexes:Uint16Array = new Uint16Array(_maxParticles * 6);
			for (var i:int = 0; i < _maxParticles; i++) {
				indexes[i * 6 + 0] = (i * 4 + 0);
				indexes[i * 6 + 1] = (i * 4 + 2);
				indexes[i * 6 + 2] = (i * 4 + 1);
				
				indexes[i * 6 + 3] = (i * 4 + 0);
				indexes[i * 6 + 4] = (i * 4 + 3);
				indexes[i * 6 + 5] = (i * 4 + 2);
			}
			_indexBuffer.setData(indexes);
		}
		
		public function update(state:RenderState):void {
			var elapsedTime:Number = state.elapsedTime / 1000.0;
			_currentTime += elapsedTime;//TODO:
			
			var scale:Vector3;
			if (scaleMode == 2)//Shape模式
				scale = state.owner.transform.scale;
			else
				scale = Vector3.ONE;
			
			_particleShapeEmitter.update(elapsedTime, scale);
			
			retireActiveParticles();
			freeRetiredParticles();
			
			if (_firstActiveElement == _firstFreeElement)
				_currentTime = 0;
			
			if (_firstRetiredElement == _firstActiveElement)
				_drawCounter = 0;
		}
		
		public function addParticle(position:Vector3, direction:Vector3):void {
			Vector3.normalize(direction, direction);
			
			var positionE:Float32Array = position.elements;
			var directionE:Float32Array = direction.elements;
			
			var nextFreeParticle:int = _firstFreeElement + 1;
			
			if (nextFreeParticle >= _maxParticles)
				nextFreeParticle = 0;
			
			if (nextFreeParticle === _firstRetiredElement)
				return;
			
			var particleData:ShurikenParticleData = ShurikenParticleData.Create(this, positionE, directionE, _currentTime);
			
			var startIndex:int = _firstFreeElement * _floatCountPerVertex * 4;
			
			var randomX:Number = Math.random();//X为RandomColorOverLife
			var randomY:Number = Math.random();//Y为RandomSizeOverLifetime
			var randomZ:Number = Math.random();//Z为ROTATIONOVERLIFETIME相关参数使用
			var randomW:Number = Math.random();
			
			var subU:Number = particleData.startUVInfo[0];
			var subV:Number = particleData.startUVInfo[1];
			var startU:Number = particleData.startUVInfo[2];
			var startV:Number = particleData.startUVInfo[3];
			_vertices[startIndex + 2] = startU;
			_vertices[startIndex + 3] = startV + subV;
			_vertices[startIndex + _floatCountPerVertex + 2] = startU + subU;
			_vertices[startIndex + _floatCountPerVertex + 3] = startV + subV;
			_vertices[startIndex + _floatCountPerVertex * 2 + 2] = startU + subU;
			_vertices[startIndex + _floatCountPerVertex * 2 + 3] = startV;
			_vertices[startIndex + _floatCountPerVertex * 3 + 2] = startU;
			_vertices[startIndex + _floatCountPerVertex * 3 + 3] = startV;
			
			for (var i:int = 0; i < 4; i++) {
				var vertexStart:int = startIndex + i * _floatCountPerVertex;
				var j:int, offset:int;
				for (j = 0, offset = 4; j < 3; j++)
					_vertices[vertexStart + offset + j] = particleData.position[j];
				
				for (j = 0, offset = 7; j < 3; j++)
					_vertices[vertexStart + offset + j] = particleData.direction[j];
				
				for (j = 0, offset = 10; j < 4; j++)
					_vertices[vertexStart + offset + j] = particleData.startColor[j];
				
				for (j = 0, offset = 14; j < 3; j++)
					_vertices[vertexStart + offset + j] = particleData.startSize[j];
				
				for (j = 0, offset = 17; j < 3; j++)
					_vertices[vertexStart + offset + j] = particleData.startRotation[j];
				
				_vertices[vertexStart + 20] = particleData.startLifeTime;
				//trace(Stat.loopCount,"add",_currentTime,particleData.time,particleData.startLifeTime);
				
				_vertices[vertexStart + 21] = particleData.time;
				
				_vertices[vertexStart + 22] = particleData.startSpeed;
				
				_vertices[vertexStart + 23] = randomX;
				_vertices[vertexStart + 24] = randomY;
				_vertices[vertexStart + 25] = randomZ;
				_vertices[vertexStart + 26] = randomW;
			}
			
			_firstFreeElement = nextFreeParticle;
		}
		
		public function addNewParticlesToVertexBuffer():void {
			var start:int;
			if (_firstNewElement < _firstFreeElement) {
				start = _firstNewElement * 4 * _floatCountPerVertex;
				_vertexBuffer.setData(_vertices, start, start, (_firstFreeElement - _firstNewElement) * 4 * _floatCountPerVertex);
				
			} else {
				start = _firstNewElement * 4 * _floatCountPerVertex;
				_vertexBuffer.setData(_vertices, start, start, (_maxParticles - _firstNewElement) * 4 * _floatCountPerVertex);
				
				if (_firstFreeElement > 0) {
					_vertexBuffer.setData(_vertices, 0, 0, _firstFreeElement * 4 * _floatCountPerVertex);
				}
			}
			_firstNewElement = _firstFreeElement;
		}
		
		public function _beforeRender(state:RenderState):Boolean {
			//设备丢失时, setData  here,WebGL不会丢失。
			if (_firstNewElement != _firstFreeElement) {
				addNewParticlesToVertexBuffer();
			}
			
			_drawCounter++;
			if (_firstActiveElement != _firstFreeElement) {
				_vertexBuffer._bind();
				_indexBuffer._bind();
				return true;
			}
			return false;
		}
		
		public function _render(state:RenderState):void {
			var drawVertexCount:int;
			var glContext:WebGLContext = WebGL.mainContext;
			if (_firstActiveElement < _firstFreeElement) {
				drawVertexCount = (_firstFreeElement - _firstActiveElement) * 6;
				glContext.drawElements(WebGLContext.TRIANGLES, drawVertexCount, WebGLContext.UNSIGNED_SHORT, _firstActiveElement * 6 * 2);//2为ushort字节数
				Stat.trianglesFaces += drawVertexCount / 3;
				Stat.drawCall++;
			} else {
				drawVertexCount = (_maxParticles - _firstActiveElement) * 6;
				glContext.drawElements(WebGLContext.TRIANGLES, drawVertexCount, WebGLContext.UNSIGNED_SHORT, _firstActiveElement * 6 * 2);//2为ushort字节数
				Stat.trianglesFaces += drawVertexCount / 3;
				Stat.drawCall++;
				if (_firstFreeElement > 0) {
					drawVertexCount = _firstFreeElement * 6;
					glContext.drawElements(WebGLContext.TRIANGLES, drawVertexCount, WebGLContext.UNSIGNED_SHORT, 0);
					Stat.trianglesFaces += drawVertexCount / 3;
					Stat.drawCall++;
				}
			}
		}
	}
}