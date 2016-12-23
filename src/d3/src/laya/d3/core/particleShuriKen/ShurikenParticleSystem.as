package laya.d3.core.particleShuriKen {
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.Transform3D;
	import laya.d3.core.particleShuriKen.module.ColorOverLifetime;
	import laya.d3.core.particleShuriKen.module.Emission;
	import laya.d3.core.particleShuriKen.module.FrameOverTime;
	import laya.d3.core.particleShuriKen.module.GradientDataNumber;
	import laya.d3.core.particleShuriKen.module.RotationOverLifetime;
	import laya.d3.core.particleShuriKen.module.SizeOverLifetime;
	import laya.d3.core.particleShuriKen.module.StartFrame;
	import laya.d3.core.particleShuriKen.module.TextureSheetAnimation;
	import laya.d3.core.particleShuriKen.module.VelocityOverLifetime;
	import laya.d3.core.particleShuriKen.module.shape.BaseShape;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexParticleShuriken;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.events.Event;
	import laya.maths.MathUtil;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>ShurikenParticleSystem</code> 类用于创建3D粒子数据模板。
	 */
	public class ShurikenParticleSystem implements IRenderable {
		/** @private */
		private var _owner:ShuriKenParticle3D;
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
		private var _emission:Emission;
		/**@private */
		private var _shape:BaseShape;
		/**@private */
		public var _startUpdateLoopCount:int;
		
		/**粒子运行的总时长，单位为秒。*/
		public var duration:Number;
		/**是否循环。*/
		public var looping:Boolean;
		/**是否预热。暂不支持*/
		public var prewarm:Boolean;
		/**开始延迟类型，0为常量模式,1为随机随机双常量模式，不能和prewarm一起使用。*/
		public var startDelayType:int;
		/**开始播放延迟，不能和prewarm一起使用。*/
		public var startDelay:Number;
		/**开始播放最小延迟，不能和prewarm一起使用。*/
		public var startDelayMin:Number;
		/**开始播放最大延迟，不能和prewarm一起使用。*/
		public var startDelayMax:Number;
		
		/**开始生命周期模式,0为固定时间，1为渐变时间，2为两个固定之间的随机插值,3为两个渐变时间的随机插值。*/
		public var startLifetimeType:int;
		/**开始生命周期，0模式,单位为秒。*/
		public var startLifetimeConstant:Number;
		/**开始渐变生命周期，1模式,单位为秒。*/
		public var startLifeTimeGradient:GradientDataNumber;
		/**最小开始生命周期，2模式,单位为秒。*/
		public var startLifetimeConstantMin:Number;
		/**最大开始生命周期，2模式,单位为秒。*/
		public var startLifetimeConstantMax:Number;
		/**开始渐变最小生命周期，3模式,单位为秒。*/
		public var startLifeTimeGradientMin:GradientDataNumber;
		/**开始渐变最大生命周期，3模式,单位为秒。*/
		public var startLifeTimeGradientMax:GradientDataNumber;
		
		/**开始速度模式，0为恒定速度，2为两个恒定速度的随机插值。缺少1、3模式*/
		public var startSpeedType:int;
		/**开始速度,0模式。*/
		public var startSpeedConstant:Number;
		/**最小开始速度,1模式。*/
		public var startSpeedConstantMin:Number;
		/**最大开始速度,1模式。*/
		public var startSpeedConstantMax:Number;
		
		/**3D开始尺寸，暂不支持*/
		public var threeDStartSize:Boolean;
		/**开始尺寸模式,0为恒定尺寸，2为两个恒定尺寸的随机插值。缺少1、3模式和对应的二种3D模式*/
		public var startSizeType:int;
		/**开始尺寸，0模式。*/
		public var startSizeConstant:Number;
		/**开始三维尺寸，0模式。*/
		public var startSizeConstantSeparate:Vector3;
		/**最小开始尺寸，2模式。*/
		public var startSizeConstantMin:Number;
		/**最大开始尺寸，2模式。*/
		public var startSizeConstantMax:Number;
		/**最小三维开始尺寸，2模式。*/
		public var startSizeConstantMinSeparate:Vector3;
		/**最大三维开始尺寸，2模式。*/
		public var startSizeConstantMaxSeparate:Vector3;
		
		/**3D开始旋转，暂不支持*/
		public var threeDStartRotation:Boolean;
		/**开始旋转模式,0为恒定尺寸，2为两个恒定旋转的随机插值,缺少2种模式,和对应的四种3D模式。*/
		public var startRotationType:int;
		/**开始旋转，0模式。*/
		public var startRotationConstant:Number;
		/**开始三维旋转，0模式。*/
		public var startRotationConstantSeparate:Vector3;
		/**最小开始旋转，1模式。*/
		public var startRotationConstantMin:Number;
		/**最大开始旋转，1模式。*/
		public var startRotationConstantMax:Number;
		/**最小开始三维旋转，1模式。*/
		public var startRotationConstantMinSeparate:Vector3;
		/**最大开始三维旋转，1模式。*/
		public var startRotationConstantMaxSeparate:Vector3;
		
		/**随机旋转方向，范围为0.0到1.0*/
		public var randomizeRotationDirection:Number;
		
		/**开始颜色模式，0为恒定颜色，2为两个恒定颜色的随机插值,缺少2种模式。*/
		public var startColorType:int;
		/**开始颜色，0模式。*/
		public var startColorConstant:Vector4;
		/**最小开始颜色，1模式。*/
		public var startColorConstantMin:Vector4;
		/**最大开始颜色，1模式。*/
		public var startColorConstantMax:Vector4;
		
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
		
		/**生命周期速度。*/
		public var velocityOverLifetime:VelocityOverLifetime;
		/**生命周期颜色。*/
		public var colorOverLifetime:ColorOverLifetime;
		/**生命周期尺寸。*/
		public var sizeOverLifetime:SizeOverLifetime;
		/**生命周期旋转。*/
		public var rotationOverLifetime:RotationOverLifetime;
		/**纹理序列帧动画。*/
		public var textureSheetAnimation:TextureSheetAnimation;
		/**是否为性能模式,性能模式下会延迟粒子释放。*/
		public var isPerformanceMode:Boolean;
		
		/**当前粒子时间。*/
		public function get currentTime():Number {
			return _currentTime;
		}
		
		/**获取最大粒子数。*/
		public function get maxParticles():int {
			return _maxParticles - 1;
		}
		
		/**设置最大粒子数,注意:谨慎修改此属性，有性能损耗。*/
		public function set maxParticles(value:int):void {//TODO:是否要重置其它参数
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
		public function get emission():Emission {
			return _emission;
		}
		
		/**
		 * 设置发射器。
		 */
		public function set emission(value:Emission):void {
			_emission = value;
			value._particleSystem = this;
			value._shape = _shape;
		}
		
		/**
		 * 粒子存活个数。
		 */
		public function get aliveParticleCount():int {
			if (_firstNewElement >= _firstRetiredElement)
				 return _firstNewElement - _firstRetiredElement;
			else
				return _maxParticles - _firstRetiredElement + _firstNewElement;
		}
		
		/**
		 * 获取形状。
		 */
		public function get shape():BaseShape {
			return _shape;
		}
		
		/**
		 * 设置形状。
		 */
		public function set shape(value:BaseShape):void {
			_shape = value;
			_emission._shape = value;
		}
		
		/**
		 * 是否存活。
		 */
		public function get isAlive():Boolean {
			if (_emission.isPlaying || aliveParticleCount > 0)//TODO:暂时忽略retired
				return true;
			
			return false;
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
		
		public function ShurikenParticleSystem(owner:ShuriKenParticle3D) {
			_owner = owner;
			_currentTime = 0;
			_floatCountPerVertex = 40;//0~3为CornerTextureCoordinate,4~6为Position,7~9Direction,10到13为StartColor,14到16为StartSize,17到19为3DStartRotationForward(或17为2DStartRotation),20到22为3DStartRotationRight,23到25为3DStartRotationUp，26为StartLifeTime,27为Time,28为startSpeed,29到32为random0,33到36为random1,37到39为世界空间模拟器模式位置(附加数据)
			
			_maxParticles = 1000;
			duration = 5.0;
			looping = true;
			prewarm = false;
			startDelayType = 0;
			startDelay = 0.0;
			startDelayMin = 0.0;
			startDelayMax = 0.0;
			startLifetimeType = 0;
			startLifetimeConstant = 5.0;
			startLifeTimeGradient = new GradientDataNumber();
			startLifetimeConstantMin = 0.0;
			startLifetimeConstantMax = 5.0;
			startLifeTimeGradientMin = new GradientDataNumber();
			startLifeTimeGradientMax = new GradientDataNumber();
			
			startSpeedType = 0;
			startSpeedConstant = 5.0;
			startSpeedConstantMin = 0.0;
			startSpeedConstantMax = 5.0;
			threeDStartSize = false;
			startSizeType = 0;
			startSizeConstant = 1;
			startSizeConstantSeparate = new Vector3(1, 1, 1);
			startSizeConstantMin = 0;
			startSizeConstantMax = 1;
			startSizeConstantMinSeparate = new Vector3(0, 0, 0);
			startSizeConstantMaxSeparate = new Vector3(1, 1, 1);
			
			threeDStartRotation = false;
			startRotationType = 0;
			startRotationConstant = 0;
			startRotationConstantSeparate = new Vector3(0, 0, 0);
			startRotationConstantMin = 0.0;
			startRotationConstantMax = 0.0;
			startRotationConstantMinSeparate = new Vector3(0, 0, 0);
			startRotationConstantMaxSeparate = new Vector3(0, 0, 0);
			
			randomizeRotationDirection = 0.0;
			startColorType = 0;
			startColorConstant = new Vector4(1, 1, 1, 1);
			startColorConstantMin = new Vector4(1, 1, 1, 1);
			startColorConstantMax = new Vector4(1, 1, 1, 1);
			gravity = new Vector3(0, -9.81, 0);
			gravityModifier = 0.0;
			simulationSpace = 1;
			scaleMode = 0;
			playOnAwake = true;
			//autoRandomSeed = true;
			isPerformanceMode = true;
			
			_owner.on(Event.ENABLED_CHANGED, this, _onOwnerEnableChanged);
			_owner.on(Event.DISPLAY, this, _onDisplayInStage);
			_owner.on(Event.UNDISPLAY, this, _onUnDisplayInStage);
		}
		
		/**
		 * @private
		 */
		private function _updateEmission():void {
			var elapsedTime:Number = 0;
			(_startUpdateLoopCount !== Stat.loopCount) && (elapsedTime =Laya.timer.delta / 1000.0, _currentTime += elapsedTime);
			
			_retireActiveParticles();
			_freeRetiredParticles();
			
			_emission.update(elapsedTime);//TODO:更新完退休和激活粒子最后播放
			
			if (_firstActiveElement === _firstFreeElement)
				_currentTime = 0;
			if (_firstRetiredElement === _firstActiveElement)
				_drawCounter = 0;
			
			
		}
		
		/**
		 * @private
		 */
		private function _addUpdateEmissionToTimer():void {
			Laya.timer.frameLoop(1, this, _updateEmission);
		}
		
		/**
		 * @private
		 */
		private function _removeUpdateEmissionToTimer():void {
			Laya.timer.clear(this, _updateEmission);
		}
		
		/**
		 * @private
		 */
		private function _onOwnerEnableChanged(enable:Boolean):void {
			if (_owner.displayedInStage) {
				if (enable)
					_addUpdateEmissionToTimer();
				else
					_removeUpdateEmissionToTimer();
			}
		}
		
		/**
		 * @private
		 */
		private function _onDisplayInStage():void {
			(_owner.enable) && (_addUpdateEmissionToTimer());
		}
		
		/**
		 * @private
		 */
		private function _onUnDisplayInStage():void {
			(_owner.enable) && (_removeUpdateEmissionToTimer());
		}
		
		/**
		 * @private
		 */
		private function _retireActiveParticles():void {
			const epsilon:Number = 0.0001;
			while (_firstActiveElement != _firstNewElement) {
				var index:int = _firstActiveElement * _floatCountPerVertex * 4;
				var timeIndex:int = index + 27;//27为Time
				
				var particleAge:Number = _currentTime - _vertices[timeIndex];
				if (particleAge + epsilon < _vertices[index + 26]/*_maxLifeTime*/)//26为真实lifeTime,TODO:shader内精度误差
					break;
				
				_vertices[timeIndex] = _drawCounter;
				_firstActiveElement++;
				if (_firstActiveElement >= _maxParticles)
					_firstActiveElement = 0;
			}
		}
		
		/**
		 * @private
		 */
		private function _freeRetiredParticles():void {
			while (_firstRetiredElement != _firstActiveElement) {
				var age:int = _drawCounter - _vertices[_firstRetiredElement * _floatCountPerVertex * 4 + 27];//27为Time
				
				if (isPerformanceMode)
					if (age < 3)//GPU从不滞后于CPU两帧，出于显卡驱动BUG等安全因素考虑滞后三帧
						break;
				
				_firstRetiredElement++;
				if (_firstRetiredElement >= _maxParticles)
					_firstRetiredElement = 0;
			}
		}
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		private function _initPartVertexDatas():void {
			_vertexBuffer = VertexBuffer3D.create(VertexParticleShuriken.vertexDeclaration, _maxParticles * 4, WebGLContext.DYNAMIC_DRAW);
			_vertices = new Float32Array(_maxParticles * _floatCountPerVertex * 4);
			
			var enableSheetAnimation:Boolean = textureSheetAnimation && textureSheetAnimation.enbale;
			if (enableSheetAnimation) {
				var title:Vector2 = textureSheetAnimation.tiles;
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
		
		/**
		 * @private
		 */
		private function _initIndexDatas():void {
			_indexBuffer = IndexBuffer3D.create(IndexBuffer3D.INDEXTYPE_USHORT, _maxParticles * 6, WebGLContext.STATIC_DRAW);
			var indexes:Uint16Array = new Uint16Array(_maxParticles * 6);
			for (var i:int = 0; i < _maxParticles; i++) {
				var indexOffset:int = i * 6;
				var vertexOffset:int = i * 4;
				indexes[indexOffset + 0] = (vertexOffset + 0);
				indexes[indexOffset + 1] = (vertexOffset + 2);
				indexes[indexOffset + 2] = (vertexOffset + 1);
				
				indexes[indexOffset + 3] = (vertexOffset + 0);
				indexes[indexOffset + 4] = (vertexOffset + 3);
				indexes[indexOffset + 5] = (vertexOffset + 2);
			}
			_indexBuffer.setData(indexes);
		}
		
		/**
		 * @private
		 */
		public function _destroy():void {
			_vertexBuffer.dispose();
			_indexBuffer.dispose();
			_emission._destroy();
			_owner = null;
			_vertices = null;
			_vertexBuffer = null;
			_indexBuffer = null;
			_emission = null;
			_shape = null;
			startLifeTimeGradient = null;
			startLifeTimeGradientMin = null;
			startLifeTimeGradientMax = null;
			startSizeConstantSeparate = null;
			startSizeConstantMinSeparate = null;
			startSizeConstantMaxSeparate = null;
			startRotationConstantSeparate = null;
			startRotationConstantMinSeparate = null;
			startRotationConstantMaxSeparate = null;
			startColorConstant = null;
			startColorConstantMin = null;
			startColorConstantMax = null;
			gravity = null;
			velocityOverLifetime = null;
			colorOverLifetime = null;
			sizeOverLifetime = null;
			rotationOverLifetime = null;
			textureSheetAnimation = null;
		}
		
		public function addParticle(position:Vector3, direction:Vector3):Boolean {
			Vector3.normalize(direction, direction);
			var positionE:Float32Array = position.elements;
			var directionE:Float32Array = direction.elements;
			
			var nextFreeParticle:int = _firstFreeElement + 1;
			
			if (nextFreeParticle >= _maxParticles)
				nextFreeParticle = 0;
			
			if (nextFreeParticle === _firstRetiredElement)
				return false;
			
			var particleData:ShurikenParticleData = ShurikenParticleData.create(this, _owner.particleRender, positionE, directionE, _currentTime, _owner.transform);
			
			var startIndex:int = _firstFreeElement * _floatCountPerVertex * 4;
			
			var randomX0:Number = Math.random(), randomY0:Number = Math.random(), randomZ0:Number = Math.random(), randomW0:Number = Math.random();
			var randomX1:Number = Math.random(), randomY1:Number = Math.random(), randomZ1:Number = Math.random(), randomW1:Number = Math.random();
			
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
					_vertices[vertexStart + offset + j] = particleData.startRotation0[j];
				
				for (j = 0, offset = 20; j < 3; j++)
					_vertices[vertexStart + offset + j] = particleData.startRotation1[j];
				
				for (j = 0, offset = 23; j < 3; j++)
					_vertices[vertexStart + offset + j] = particleData.startRotation2[j];
				
				_vertices[vertexStart + 26] = particleData.startLifeTime;
				
				_vertices[vertexStart + 27] = particleData.time;
				
				_vertices[vertexStart + 28] = particleData.startSpeed;
				
				_vertices[vertexStart + 29] = randomX0;
				_vertices[vertexStart + 30] = randomY0;
				_vertices[vertexStart + 31] = randomZ0;
				_vertices[vertexStart + 32] = randomW0;
				_vertices[vertexStart + 33] = randomX1;
				_vertices[vertexStart + 34] = randomY1;
				_vertices[vertexStart + 35] = randomZ1;
				_vertices[vertexStart + 36] = randomW1;
				
				for (j = 0, offset = 37; j < 3; j++)
					_vertices[vertexStart + offset + j] = particleData.simulationWorldPostion[j];
			}
			
			_firstFreeElement = nextFreeParticle;
			return true;
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
		public function _renderRuntime(conchGraphics3D:*, renderElement:RenderElement, state:RenderState):void//NATIVE
		{
			
		}
	}
}