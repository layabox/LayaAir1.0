package laya.d3.core.particleShuriKen {
	import laya.d3.core.GeometryFilter;
	import laya.d3.core.IClone;
	import laya.d3.core.Transform3D;
	import laya.d3.core.particleShuriKen.module.Burst;
	import laya.d3.core.particleShuriKen.module.ColorOverLifetime;
	import laya.d3.core.particleShuriKen.module.Emission;
	import laya.d3.core.particleShuriKen.module.FrameOverTime;
	import laya.d3.core.particleShuriKen.module.GradientAngularVelocity;
	import laya.d3.core.particleShuriKen.module.GradientColor;
	import laya.d3.core.particleShuriKen.module.GradientDataColor;
	import laya.d3.core.particleShuriKen.module.GradientDataNumber;
	import laya.d3.core.particleShuriKen.module.GradientSize;
	import laya.d3.core.particleShuriKen.module.GradientVelocity;
	import laya.d3.core.particleShuriKen.module.RotationOverLifetime;
	import laya.d3.core.particleShuriKen.module.SizeOverLifetime;
	import laya.d3.core.particleShuriKen.module.TextureSheetAnimation;
	import laya.d3.core.particleShuriKen.module.VelocityOverLifetime;
	import laya.d3.core.particleShuriKen.module.shape.BaseShape;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.graphics.VertexShurikenParticleBillboard;
	import laya.d3.graphics.VertexShurikenParticleMesh;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Rand;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.Mesh;
	import laya.events.Event;
	import laya.maths.MathUtil;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**开始播放时调度。
	 * @eventType Event.PLAYED
	 * */
	[Event(name = "played", type = "laya.events.Event")]
	/**暂停时调度。
	 * @eventType Event.PAUSED
	 * */
	[Event(name = "paused", type = "laya.events.Event")]
	/**完成一次循环时调度。
	 * @eventType Event.COMPLETE
	 * */
	[Event(name = "complete", type = "laya.events.Event")]
	/**停止时调度。
	 * @eventType Event.STOPPED
	 * */
	[Event(name = "stopped", type = "laya.events.Event")]
	
	/**
	 * <code>ShurikenParticleSystem</code> 类用于创建3D粒子数据模板。
	 */
	public class ShurikenParticleSystem extends GeometryFilter implements IRenderable, IClone {
		/** @private 0:Burst,1:预留,2:StartDelay,3:StartColor,4:StartSize,5:StartRotation,6:randomizeRotationDirection,7:StartLifetime,8:StartSpeed,9:VelocityOverLifetime,10:ColorOverLifetime,11:SizeOverLifetime,12:RotationOverLifetime,13-15:TextureSheetAnimation,16-17:Shape*/
		public static const _RANDOMOFFSET:Uint32Array = new Uint32Array([0x23571a3e, 0xc34f56fe, 0x13371337, 0x12460f3b, 0x6aed452e, 0xdec4aea1, 0x96aa4de3, 0x8d2c8431, 0xf3857f6f, 0xe0fbd834, 0x13740583, 0x591bc05c, 0x40eb95e4, 0xbc524e5f, 0xaf502044, 0xa614b381, 0x1034e524, 0xfc524e5f]);
		
		/** @private */
		private static const halfKSqrtOf2:Number = 1.42 * 0.5;
		
		/** @private */
		public static const _maxElapsedTime:Number = 1.0 / 3.0;
		
		/**@private */
		private static var _tempVector30:Vector3 = new Vector3();
		/**@private */
		private static var _tempVector31:Vector3 = new Vector3();
		/**@private */
		private static var _tempVector32:Vector3 = new Vector3();
		/**@private */
		private static var _tempVector33:Vector3 = new Vector3();
		/**@private */
		private static var _tempVector34:Vector3 = new Vector3();
		/**@private */
		private static var _tempVector35:Vector3 = new Vector3();
		/**@private */
		private static var _tempVector36:Vector3 = new Vector3();
		/**@private */
		private static var _tempVector37:Vector3 = new Vector3();
		/**@private */
		private static var _tempVector38:Vector3 = new Vector3();
		/**@private */
		private static var _tempVector39:Vector3 = new Vector3();
		/** @private */
		private static var _tempPosition:Vector3 = new Vector3();
		/** @private */
		private static var _tempDirection:Vector3 = new Vector3();
		
		/** @private */
		private var _tempRotationMatrix:Matrix4x4 = new Matrix4x4();
		
		/** @private */
		public var _boundingSphere:BoundSphere;
		/** @private */
		public var _boundingBox:BoundBox;
		/** @private */
		public var _boundingBoxCorners:Vector.<Vector3>;
		
		/** @private */
		private var _owner:ShuriKenParticle3D;
		/** @private */
		private var _ownerRender:ShurikenParticleRender;
		/**@private */
		private var _vertices:Float32Array;
		/**@private */
		private var _floatCountPerVertex:uint;
		/**@private */
		private var _startLifeTimeIndex:uint;
		/**@private */
		private var _timeIndex:uint;
		/**@private */
		private var _simulateUpdate:Boolean;
		
		
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
		private var _vertexBuffer:VertexBuffer3D;
		/**@private */
		private var _indexBuffer:IndexBuffer3D;
		/**@private */
		private var _bufferMaxParticles:int;
		/**@private */
		private var _emission:Emission;
		/**@private */
		private var _shape:BaseShape;
		
		/**@private */
		private var _isEmitting:Boolean;
		/**@private */
		private var _isPlaying:Boolean;
		/**@private */
		private var _isPaused:Boolean;
		/**@private */
		private var _playStartDelay:Number;
		/**@private 发射的累计时间。*/
		private var _frameRateTime:Number;
		/**@private 一次循环内的累计时间。*/
		private var _emissionTime:Number;
		/**@private */
		private var _totalDelayTime:Number;
		/**@private */
		private var _burstsIndex:int;
		///**@private 发射粒子最小时间间隔。*/
		//private var _minEmissionTime:Number;
		/**@private */
		private var _velocityOverLifetime:VelocityOverLifetime;
		/**@private */
		private var _colorOverLifetime:ColorOverLifetime;
		/**@private */
		private var _sizeOverLifetime:SizeOverLifetime;
		/**@private */
		private var _rotationOverLifetime:RotationOverLifetime;
		/**@private */
		private var _textureSheetAnimation:TextureSheetAnimation;
		/**@private */
		private var _startLifetimeType:int;
		/**@private */
		private var _startLifetimeConstant:Number;
		/**@private */
		private var _startLifeTimeGradient:GradientDataNumber;
		/**@private */
		private var _startLifetimeConstantMin:Number;
		/**@private */
		private var _startLifetimeConstantMax:Number;
		/**@private */
		private var _startLifeTimeGradientMin:GradientDataNumber;
		/**@private */
		private var _startLifeTimeGradientMax:GradientDataNumber;
		/**@private */
		private var _maxStartLifetime:Number;
		
		/** @private */
		private var _uvLength:Vector2 = new Vector2();//TODO:
		/** @private */
		private var _vertexStride:int;
		/** @private */
		private var _indexStride:int;
		
		/**@private */
		public var _currentTime:Number;
		/**@private */
		public var _startUpdateLoopCount:int;
		/**@private */
		public var _rand:Rand;
		/**@private */
		public var _randomSeeds:Uint32Array;
		
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
		
		/**开始速度模式，0为恒定速度，2为两个恒定速度的随机插值。缺少1、3模式*/
		public var startSpeedType:int;
		/**开始速度,0模式。*/
		public var startSpeedConstant:Number;
		/**最小开始速度,1模式。*/
		public var startSpeedConstantMin:Number;
		/**最大开始速度,1模式。*/
		public var startSpeedConstantMax:Number;
		
		/**开始尺寸是否为3D模式。*/
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
		
		/**重力敏感度。*/
		public var gravityModifier:Number;
		/**模拟器空间,0为World,1为Local。暂不支持Custom。*/
		public var simulationSpace:int;
		/**缩放模式，0为Hiercachy,1为Local,2为World。暂不支持1,2*/
		public var scaleMode:int;
		/**激活时是否自动播放。*/
		public var playOnAwake:Boolean;
		
		/**随机种子,注:play()前设置有效。*/
		public var randomSeed:Uint32Array;
		/**是否使用随机种子。 */
		public var autoRandomSeed:Boolean;
		
		/**是否为性能模式,性能模式下会延迟粒子释放。*/
		public var isPerformanceMode:Boolean;
		
		/**获取最大粒子数。*/
		public function get maxParticles():int {
			return _bufferMaxParticles - 1;
		}
		
		/**设置最大粒子数,注意:谨慎修改此属性，有性能损耗。*/
		public function set maxParticles(value:int):void {//TODO:是否要重置其它参数
			var newMaxParticles:int = value + 1;
			if (newMaxParticles !== _bufferMaxParticles) {
				_bufferMaxParticles = newMaxParticles;
				_initBufferDatas();
			}
		}
		
		/**
		 * 获取发射器。
		 */
		public function get emission():Emission {
			return _emission;
		}
		
		
		/**
		 * 粒子存活个数。
		 */
		public function get aliveParticleCount():int {
			if (_firstNewElement >= _firstRetiredElement)
				return _firstNewElement - _firstRetiredElement;
			else
				return _bufferMaxParticles - _firstRetiredElement + _firstNewElement;
		}
		
		/**
		 * 获取一次循环内的累计时间。
		 * @return 一次循环内的累计时间。
		 */
		public function get emissionTime():int {
			return _emissionTime > duration ? duration : _emissionTime;
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
			if (_shape !== value) {
				if (value&&value.enable)
					_ownerRender._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_SHAPE);
				else
					_ownerRender._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_SHAPE);
				
				_shape = value;
			}
		}
		
		/**
		 * 是否存活。
		 */
		public function get isAlive():Boolean {
			if (_isPlaying || aliveParticleCount > 0)//TODO:暂时忽略retired
				return true;
			
			return false;
		}
		
		/**
		 * 是否正在发射。
		 */
		public function get isEmitting():Boolean {
			return _isEmitting;
		}
		
		/**
		 * 是否正在播放。
		 */
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		/**
		 * 是否已暂停。
		 */
		public function get isPaused():Boolean {
			return _isPaused;
		}
		
		/**
		 * 获取开始生命周期模式,0为固定时间，1为渐变时间，2为两个固定之间的随机插值,3为两个渐变时间的随机插值。
		 */
		public function get startLifetimeType():int{
			return _startLifetimeType;
		}
		
		/**
		 * 设置开始生命周期模式,0为固定时间，1为渐变时间，2为两个固定之间的随机插值,3为两个渐变时间的随机插值。
		 */
		public function set startLifetimeType(value:int):void{
			//if (value !== _startLifetimeType){
			var i:int,n:int;
			switch (startLifetimeType) {
			case 0: 
				_maxStartLifetime = startLifetimeConstant;
				break;
			case 1: 
				_maxStartLifetime = -Number.MAX_VALUE;
				var startLifeTimeGradient:GradientDataNumber = startLifeTimeGradient;
				for (i = 0, n = startLifeTimeGradient.gradientCount; i < n; i++)
					_maxStartLifetime = Math.max(_maxStartLifetime, startLifeTimeGradient.getValueByIndex(i));
				break;
			case 2: 
				_maxStartLifetime = Math.max(startLifetimeConstantMin, startLifetimeConstantMax);
				break;
			case 3: 
				_maxStartLifetime = -Number.MAX_VALUE;
				var startLifeTimeGradientMin:GradientDataNumber = startLifeTimeGradientMin;
				for (i = 0, n = startLifeTimeGradientMin.gradientCount; i < n; i++)
					_maxStartLifetime = Math.max(_maxStartLifetime, startLifeTimeGradientMin.getValueByIndex(i));
				var startLifeTimeGradientMax:GradientDataNumber = startLifeTimeGradientMax;
				for (i = 0, n = startLifeTimeGradientMax.gradientCount; i < n; i++)
					_maxStartLifetime = Math.max(_maxStartLifetime, startLifeTimeGradientMax.getValueByIndex(i));
				break;
			}
			_startLifetimeType = value;
			//}
		}
		
		/**
		 * 获取开始生命周期，0模式,单位为秒。
		 */
		public function get startLifetimeConstant():Number{
			return _startLifetimeConstant;
		}
		
		/**
		 * 设置开始生命周期，0模式,单位为秒。
		 */
		public function set startLifetimeConstant(value:Number):void{
				if(_startLifetimeType===0)
					_maxStartLifetime = value;
				_startLifetimeConstant = value;
		}
		
		/**
		 * 获取开始渐变生命周期，1模式,单位为秒。
		 */
		public function get startLifeTimeGradient():GradientDataNumber{
			return _startLifeTimeGradient;
		}
		
		/**
		 * 设置开始渐变生命周期，1模式,单位为秒。
		 */
		public function set startLifeTimeGradient(value:GradientDataNumber):void{//无法使用if (_startLifeTimeGradient !== value)过滤，同一个GradientDataNumber可能修改了值,因此所有startLifeTime属性都统一处理
			if (_startLifetimeType === 1){
				_maxStartLifetime = -Number.MAX_VALUE;
				for (var i:int = 0, n:int = value.gradientCount; i < n; i++)
					_maxStartLifetime = Math.max(_maxStartLifetime, value.getValueByIndex(i));
				}
			_startLifeTimeGradient = value;
		}
		
		/**
		 * 获取最小开始生命周期，2模式,单位为秒。
		 */
		public function get startLifetimeConstantMin():Number{
			return _startLifetimeConstantMin;
		}
		
		/**
		 * 设置最小开始生命周期，2模式,单位为秒。
		 */
		public function set startLifetimeConstantMin(value:Number):void{
			if (_startLifetimeType === 2)
				_maxStartLifetime = Math.max(value, _startLifetimeConstantMax);
			_startLifetimeConstantMin = value;
		}
		
		
		/**
		 * 获取最大开始生命周期，2模式,单位为秒。
		 */
		public function get startLifetimeConstantMax():Number{
			return _startLifetimeConstantMax;
		}
		
		/**
		 * 设置最大开始生命周期，2模式,单位为秒。
		 */
		public function set startLifetimeConstantMax(value:Number):void{
			if (_startLifetimeType === 2)
				_maxStartLifetime = Math.max(_startLifetimeConstantMin, value);
			_startLifetimeConstantMax = value;
		}
		
		
		
		/**
		 * 获取开始渐变最小生命周期，3模式,单位为秒。
		 */
		public function get startLifeTimeGradientMin():GradientDataNumber{
			return _startLifeTimeGradientMin;
		}
		
		/**
		 * 设置开始渐变最小生命周期，3模式,单位为秒。
		 */
		public function set startLifeTimeGradientMin(value:GradientDataNumber):void{
			if (_startLifetimeType === 3){
				var i:int, n:int;
				_maxStartLifetime = -Number.MAX_VALUE;
				for (i = 0, n = value.gradientCount; i < n; i++)
					_maxStartLifetime = Math.max(_maxStartLifetime, value.getValueByIndex(i));
				for (i = 0, n = _startLifeTimeGradientMax.gradientCount; i < n; i++)
					_maxStartLifetime = Math.max(_maxStartLifetime, _startLifeTimeGradientMax.getValueByIndex(i));
				}
				_startLifeTimeGradientMin = value;
		}
		
		/**
		 * 获取开始渐变最大生命周期，3模式,单位为秒。
		 */
		public function get startLifeTimeGradientMax():GradientDataNumber{
			return _startLifeTimeGradientMax;
		}
		
		/**
		 * 设置开始渐变最大生命周期，3模式,单位为秒。
		 */
		public function set startLifeTimeGradientMax(value:GradientDataNumber):void{
			if (_startLifetimeType === 3){
				var i:int, n:int;
				_maxStartLifetime = -Number.MAX_VALUE;
				for (i = 0, n = _startLifeTimeGradientMin.gradientCount; i < n; i++)
					_maxStartLifetime = Math.max(_maxStartLifetime, _startLifeTimeGradientMin.getValueByIndex(i));
				for (i = 0, n = value.gradientCount; i < n; i++)
					_maxStartLifetime = Math.max(_maxStartLifetime, value.getValueByIndex(i));
				}
			_startLifeTimeGradientMax = value;
		}
		
		/**
		 * 获取生命周期速度,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
		 * @return 生命周期速度.
		 */
		public function get velocityOverLifetime():VelocityOverLifetime {
			return _velocityOverLifetime;
		}
		
		/**
		 * 设置生命周期速度,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
		 * @param value 生命周期速度.
		 */
		public function set velocityOverLifetime(value:VelocityOverLifetime):void {
			var render:BaseRender = _ownerRender;
			if (value) {
				var velocity:GradientVelocity = value.velocity;
				var velocityType:int = velocity.type;
				if (value.enbale) {
					switch (velocityType) {
					case 0: 
						render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_VELOCITYOVERLIFETIMECONSTANT);
						break;
					case 1: 
						render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_VELOCITYOVERLIFETIMECURVE);
						break;
					case 2: 
						render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCONSTANT);
						break;
					case 3: 
						render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCURVE);
						break;
					}
					
				} else {
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_VELOCITYOVERLIFETIMECONSTANT);
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_VELOCITYOVERLIFETIMECURVE);
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCONSTANT);
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCURVE);
				}
				
				switch (velocityType) {
				case 0: 
					render._setShaderValueColor(ShuriKenParticle3D.VOLVELOCITYCONST, velocity.constant);
					break;
				case 1: 
					render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTX, velocity.gradientX._elements);
					render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTY, velocity.gradientY._elements);
					render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTZ, velocity.gradientZ._elements);
					break;
				case 2: 
					render._setShaderValueColor(ShuriKenParticle3D.VOLVELOCITYCONST, velocity.constantMin);
					render._setShaderValueColor(ShuriKenParticle3D.VOLVELOCITYCONSTMAX, velocity.constantMax);
					break;
				case 3: 
					render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTX, velocity.gradientXMin._elements);
					render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTXMAX, velocity.gradientXMax._elements);
					render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTY, velocity.gradientYMin._elements);
					render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTYMAX, velocity.gradientYMax._elements);
					render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTZ, velocity.gradientZMin._elements);
					render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTZMAX, velocity.gradientZMax._elements);
					break;
				}
				render._setShaderValueInt(ShuriKenParticle3D.VOLSPACETYPE, value.space);
			} else {
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_VELOCITYOVERLIFETIMECONSTANT);
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_VELOCITYOVERLIFETIMECURVE);
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCONSTANT);
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCURVE);
				
				render._setShaderValueColor(ShuriKenParticle3D.VOLVELOCITYCONST, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTX, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTY, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTZ, null);
				render._setShaderValueColor(ShuriKenParticle3D.VOLVELOCITYCONST, null);
				render._setShaderValueColor(ShuriKenParticle3D.VOLVELOCITYCONSTMAX, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTX, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTXMAX, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTY, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTYMAX, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTZ, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTZMAX, null);
				render._setShaderValueInt(ShuriKenParticle3D.VOLSPACETYPE, undefined);
			}
			_velocityOverLifetime = value;
		}
		
		/**
		 * 获取生命周期颜色,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
		 * @return 生命周期颜色
		 */
		public function get colorOverLifetime():ColorOverLifetime {
			return _colorOverLifetime;
		}
		
		/**
		 * 设置生命周期颜色,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
		 * @param value 生命周期颜色
		 */
		public function set colorOverLifetime(value:ColorOverLifetime):void {
			var render:BaseRender = _ownerRender;
			if (value) {
				var color:GradientColor = value.color;
				if (value.enbale) {
					switch (color.type) {
					case 1: 
						render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_COLOROVERLIFETIME);
						break;
					case 3: 
						render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_RANDOMCOLOROVERLIFETIME);
						break;
					}
				} else {
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_COLOROVERLIFETIME);
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_RANDOMCOLOROVERLIFETIME);
				}
				
				switch (color.type) {
				case 1: 
					var gradientColor:GradientDataColor = color.gradient;
					render._setShaderValueBuffer(ShuriKenParticle3D.COLOROVERLIFEGRADIENTALPHAS, gradientColor._alphaElements);
					render._setShaderValueBuffer(ShuriKenParticle3D.COLOROVERLIFEGRADIENTCOLORS, gradientColor._rgbElements);
					break;
				case 3: 
					var minGradientColor:GradientDataColor = color.gradientMin;
					var maxGradientColor:GradientDataColor = color.gradientMax;
					render._setShaderValueBuffer(ShuriKenParticle3D.COLOROVERLIFEGRADIENTALPHAS, minGradientColor._alphaElements);
					render._setShaderValueBuffer(ShuriKenParticle3D.COLOROVERLIFEGRADIENTCOLORS, minGradientColor._rgbElements);
					render._setShaderValueBuffer(ShuriKenParticle3D.MAXCOLOROVERLIFEGRADIENTALPHAS, maxGradientColor._alphaElements);
					render._setShaderValueBuffer(ShuriKenParticle3D.MAXCOLOROVERLIFEGRADIENTCOLORS, maxGradientColor._rgbElements);
					break;
				}
			} else {
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_COLOROVERLIFETIME);
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_RANDOMCOLOROVERLIFETIME);
				
				render._setShaderValueBuffer(ShuriKenParticle3D.COLOROVERLIFEGRADIENTALPHAS, gradientColor._alphaElements);
				render._setShaderValueBuffer(ShuriKenParticle3D.COLOROVERLIFEGRADIENTCOLORS, gradientColor._rgbElements);
				render._setShaderValueBuffer(ShuriKenParticle3D.COLOROVERLIFEGRADIENTALPHAS, minGradientColor._alphaElements);
				render._setShaderValueBuffer(ShuriKenParticle3D.COLOROVERLIFEGRADIENTCOLORS, minGradientColor._rgbElements);
				render._setShaderValueBuffer(ShuriKenParticle3D.MAXCOLOROVERLIFEGRADIENTALPHAS, maxGradientColor._alphaElements);
				render._setShaderValueBuffer(ShuriKenParticle3D.MAXCOLOROVERLIFEGRADIENTCOLORS, maxGradientColor._rgbElements);
			}
			_colorOverLifetime = value;
		}
		
		/**
		 * 获取生命周期尺寸,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
		 * @return 生命周期尺寸
		 */
		public function get sizeOverLifetime():SizeOverLifetime {
			return _sizeOverLifetime;
		}
		
		/**
		 * 设置生命周期尺寸,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
		 * @param value 生命周期尺寸
		 */
		public function set sizeOverLifetime(value:SizeOverLifetime):void {
			var render:BaseRender = _ownerRender;
			if (value) {
				var size:GradientSize = value.size;
				var sizeSeparate:Boolean = size.separateAxes;
				var sizeType:int = size.type;
				if (value.enbale) {
					switch (sizeType) {
					case 0: 
						if (sizeSeparate)
							render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_SIZEOVERLIFETIMECURVESEPERATE);
						else
							render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_SIZEOVERLIFETIMECURVE);
						break;
					case 2: 
						if (sizeSeparate)
							render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVESSEPERATE);
						else
							render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVES);
						break;
					}
					
				} else {
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_SIZEOVERLIFETIMECURVE);
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_SIZEOVERLIFETIMECURVESEPERATE);
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVES);
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVESSEPERATE);
				}
				
				switch (sizeType) {
				case 0: 
					if (sizeSeparate) {
						render._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTX, size.gradientX._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTY, size.gradientY._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.SOLSizeGradientZ, size.gradientZ._elements);
					} else {
						render._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENT, size.gradient._elements);
					}
					break;
				case 2: 
					if (sizeSeparate) {
						render._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTX, size.gradientXMin._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTXMAX, size.gradientXMax._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTY, size.gradientYMin._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTYMAX, size.gradientYMax._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.SOLSizeGradientZ, size.gradientZMin._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.SOLSizeGradientZMAX, size.gradientZMax._elements);
					} else {
						render._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENT, size.gradientMin._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.SOLSizeGradientMax, size.gradientMax._elements);
					}
					break;
				}
			} else {
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_SIZEOVERLIFETIMECURVE);
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_SIZEOVERLIFETIMECURVESEPERATE);
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVES);
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVESSEPERATE);
				
				render._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTX, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTXMAX, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTY, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTYMAX, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.SOLSizeGradientZ, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.SOLSizeGradientZMAX, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENT, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.SOLSizeGradientMax, null);
			}
			_sizeOverLifetime = value;
		}
		
		/**
		 * 获取生命周期旋转,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
		 * @return 生命周期旋转。
		 */
		public function get rotationOverLifetime():RotationOverLifetime {
			return _rotationOverLifetime;
		}
		
		/**
		 * 设置生命周期旋转,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
		 * @param value 生命周期旋转。
		 */
		public function set rotationOverLifetime(value:RotationOverLifetime):void {
			var render:BaseRender = _ownerRender;
			if (value) {
				var rotation:GradientAngularVelocity = value.angularVelocity;
				
				if (!rotation)//TODO:兼容代码，RotationOverLifetime未支持全可能为空
					return
				
				var rotationSeparate:Boolean = rotation.separateAxes;
				var rotationType:int = rotation.type;
				if (value.enbale) {
					if (rotationSeparate)
						render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMESEPERATE);
					else
						render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIME);
					switch (rotationType) {
					case 0: 
						render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMECONSTANT);
						break;
					case 1: 
						render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMECURVE);
						break;
					case 2: 
						render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCONSTANTS);
						break;
					case 3: 
						render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCURVES);
						break;
					}
				} else {
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIME);
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMESEPERATE);
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMECONSTANT);
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMECURVE);
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCONSTANTS);
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCURVES);
				}
				
				switch (rotationType) {
				case 0: 
					if (rotationSeparate) {
						render._setShaderValueColor(ShuriKenParticle3D.ROLANGULARVELOCITYCONSTSEPRARATE, rotation.constantSeparate);
					} else {
						render._setShaderValueNumber(ShuriKenParticle3D.ROLANGULARVELOCITYCONST, rotation.constant);
					}
					break;
				case 1: 
					if (rotationSeparate) {
						render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTX, rotation.gradientX._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTY, rotation.gradientY._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTZ, rotation.gradientZ._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTW, rotation.gradientW._elements);
					} else {
						render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENT, rotation.gradient._elements);
					}
					break;
				case 2: 
					if (rotationSeparate) {
						render._setShaderValueColor(ShuriKenParticle3D.ROLANGULARVELOCITYCONSTSEPRARATE, rotation.constantMinSeparate);
						render._setShaderValueColor(ShuriKenParticle3D.ROLANGULARVELOCITYCONSTMAXSEPRARATE, rotation.constantMaxSeparate);
					} else {
						render._setShaderValueNumber(ShuriKenParticle3D.ROLANGULARVELOCITYCONST, rotation.constantMin);
						render._setShaderValueNumber(ShuriKenParticle3D.ROLANGULARVELOCITYCONSTMAX, rotation.constantMax);
					}
					break;
				case 3: 
					if (rotationSeparate) {
						render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTX, rotation.gradientXMin._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTXMAX, rotation.gradientXMax._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTY, rotation.gradientYMin._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTYMAX, rotation.gradientYMax._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTZ, rotation.gradientZMin._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTZMAX, rotation.gradientZMax._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTW, rotation.gradientWMin._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTWMAX, rotation.gradientWMax._elements);
					} else {
						render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENT, rotation.gradientMin._elements);
						render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTMAX, rotation.gradientMax._elements);
					}
					break;
				}
			} else {
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIME);
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMESEPERATE);
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMECONSTANT);
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMECURVE);
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCONSTANTS);
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCURVES);
				
				render._setShaderValueColor(ShuriKenParticle3D.ROLANGULARVELOCITYCONSTSEPRARATE, null);
				render._setShaderValueColor(ShuriKenParticle3D.ROLANGULARVELOCITYCONSTMAXSEPRARATE, null);
				render._setShaderValueNumber(ShuriKenParticle3D.ROLANGULARVELOCITYCONST, undefined);
				render._setShaderValueNumber(ShuriKenParticle3D.ROLANGULARVELOCITYCONSTMAX, undefined);
				
				render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTX, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTXMAX, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTY, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTYMAX, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTZ, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTZMAX, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTW, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTWMAX, null);
				
				render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENT, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTMAX, null);
			}
			_rotationOverLifetime = value;
		}
		
		/**
		 * 获取生命周期纹理动画,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
		 * @return 生命周期纹理动画。
		 */
		public function get textureSheetAnimation():TextureSheetAnimation {
			return _textureSheetAnimation;
		}
		
		/**
		 * 设置生命周期纹理动画,注意:如修改该值的某些属性,需重新赋值此属性才可生效。
		 * @param value 生命周期纹理动画。
		 */
		public function set textureSheetAnimation(value:TextureSheetAnimation):void {
			var render:BaseRender = _ownerRender;
			if (value) {
				var frameOverTime:FrameOverTime = value.frame;
				var textureAniType:int = frameOverTime.type;
				if (value.enable) {
					switch (textureAniType) {
					case 1: 
						render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_TEXTURESHEETANIMATIONCURVE);
						break;
					case 3:
						render._addShaderDefine(ShuriKenParticle3D.SHADERDEFINE_TEXTURESHEETANIMATIONRANDOMCURVE);
						break;
						
					}
				} else {
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_TEXTURESHEETANIMATIONCURVE);
					render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_TEXTURESHEETANIMATIONRANDOMCURVE);
				}
				
				if (textureAniType === 1 || textureAniType === 3) {
					render._setShaderValueInt(ShuriKenParticle3D.TEXTURESHEETANIMATIONCYCLES, value.cycles);
					var title:Vector2 = value.tiles;
					var _uvLengthE:Float32Array = _uvLength.elements;
					_uvLengthE[0] = 1.0 / title.x;
					_uvLengthE[1] = 1.0 / title.y;
					render._setShaderValueVector2(ShuriKenParticle3D.TEXTURESHEETANIMATIONSUBUVLENGTH, _uvLength);
				}
				switch (textureAniType) {
				case 1: 
					render._setShaderValueBuffer(ShuriKenParticle3D.TEXTURESHEETANIMATIONGRADIENTUVS, frameOverTime.frameOverTimeData._elements);
					break;
				case 3: 
					render._setShaderValueBuffer(ShuriKenParticle3D.TEXTURESHEETANIMATIONGRADIENTUVS, frameOverTime.frameOverTimeDataMin._elements);
					render._setShaderValueBuffer(ShuriKenParticle3D.TEXTURESHEETANIMATIONGRADIENTMAXUVS, frameOverTime.frameOverTimeDataMax._elements);
					break;
				}
				
			} else {
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_TEXTURESHEETANIMATIONCURVE);
				render._removeShaderDefine(ShuriKenParticle3D.SHADERDEFINE_TEXTURESHEETANIMATIONRANDOMCURVE);
				
				render._setShaderValueInt(ShuriKenParticle3D.TEXTURESHEETANIMATIONCYCLES, undefined);
				render._setShaderValueVector2(ShuriKenParticle3D.TEXTURESHEETANIMATIONSUBUVLENGTH, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.TEXTURESHEETANIMATIONGRADIENTUVS, null);
				render._setShaderValueBuffer(ShuriKenParticle3D.TEXTURESHEETANIMATIONGRADIENTMAXUVS, null);
			}
			_textureSheetAnimation = value;
		}
		
		public function get _vertexBufferCount():int {
			return 1;
		}
		
		public function get triangleCount():int {
			return _indexBuffer?_indexBuffer.indexCount / 3:0;
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
		
		/**
		 * @inheritDoc
		 */
		override public function get _originalBoundingSphere():BoundSphere {
			return _boundingSphere;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get _originalBoundingBox():BoundBox {
			return _boundingBox;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get _originalBoundingBoxCorners():Vector.<Vector3> {
			return _boundingBoxCorners;
		}
		
		public function ShurikenParticleSystem(owner:ShuriKenParticle3D) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_firstActiveElement=0;
			_firstNewElement=0;
			_firstFreeElement=0;
			_firstRetiredElement = 0;
			
			_owner = owner;
			_ownerRender = owner.particleRender;
			_boundingBoxCorners = new Vector.<Vector3>(8);
			_boundingSphere = new BoundSphere(new Vector3(), Number.MAX_VALUE);//TODO:
			_boundingBox = new BoundBox(new Vector3(-Number.MAX_VALUE,-Number.MAX_VALUE,-Number.MAX_VALUE), new Vector3(Number.MAX_VALUE,Number.MAX_VALUE,Number.MAX_VALUE));//TODO:
			_currentTime = 0;
			
			_isEmitting = false;
			_isPlaying = false;
			_isPaused = false;
			_burstsIndex = 0;
			_frameRateTime = 0;
			_emissionTime = 0;
			_totalDelayTime = 0;
			_simulateUpdate = false;
			
			_bufferMaxParticles = 1;
			duration = 5.0;
			looping = true;
			prewarm = false;
			startDelayType = 0;
			startDelay = 0.0;
			startDelayMin = 0.0;
			startDelayMax = 0.0;
			
			_startLifetimeType = 0;
			_startLifetimeConstant = 5.0;
			_startLifeTimeGradient = new GradientDataNumber();
			_startLifetimeConstantMin = 0.0;
			_startLifetimeConstantMax = 5.0;
			_startLifeTimeGradientMin = new GradientDataNumber();
			_startLifeTimeGradientMax = new GradientDataNumber();
			_maxStartLifetime = 5.0;//_startLifetimeType默认为0，_startLifetimeConstant为5.0,因此该值为5.0
			
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
			
			gravityModifier = 0.0;
			simulationSpace = 1;
			scaleMode = 0;
			playOnAwake = true;
			_rand = new Rand(0);
			autoRandomSeed = true;
			randomSeed = new Uint32Array(1);
			_randomSeeds = new Uint32Array(_RANDOMOFFSET.length);
			isPerformanceMode = true;
			
			_emission = new Emission();
			_emission.enbale = true;
			
			_owner.on(Event.ACTIVE_IN_HIERARCHY_CHANGED, this, _onOwnerActiveHierarchyChanged);
		}
		
		/**
		 * @private
		 */
		public function _generateBoundingSphere():void {//TODO：应在本类内部处理。
			var centerE:Float32Array = _boundingSphere.center.elements;
			centerE[0] = 0;
			centerE[1] = 0;
			centerE[2] = 0;
			_boundingSphere.radius = Number.MAX_VALUE;
		}
		
		/**
		 * @private
		 */
		public function _generateBoundingBox():void {//TODO：应在本类内部处理。			
			var particle:ShuriKenParticle3D = _owner as ShuriKenParticle3D;
			var particleRender:ShurikenParticleRender = particle.particleRender;
			var boundMin:Vector3 = _boundingBox.min;
			var boundMax:Vector3 = _boundingBox.max;
			var i:int, n:int;
			
			//MaxLifeTime
			var maxStartLifeTime:Number;
			switch (startLifetimeType) {
			case 0: 
				maxStartLifeTime = startLifetimeConstant;
				break;
			case 1: 
				maxStartLifeTime = -Number.MAX_VALUE;
				var startLifeTimeGradient:GradientDataNumber = startLifeTimeGradient;
				for (i = 0, n = startLifeTimeGradient.gradientCount; i < n; i++)
					maxStartLifeTime = Math.max(maxStartLifeTime, startLifeTimeGradient.getValueByIndex(i));
				break;
			case 2: 
				maxStartLifeTime = Math.max(startLifetimeConstantMin, startLifetimeConstantMax);
				break;
			case 3: 
				maxStartLifeTime = -Number.MAX_VALUE;
				var startLifeTimeGradientMin:GradientDataNumber = startLifeTimeGradientMin;
				for (i = 0, n = startLifeTimeGradientMin.gradientCount; i < n; i++)
					maxStartLifeTime = Math.max(maxStartLifeTime, startLifeTimeGradientMin.getValueByIndex(i));
				var startLifeTimeGradientMax:GradientDataNumber = startLifeTimeGradientMax;
				for (i = 0, n = startLifeTimeGradientMax.gradientCount; i < n; i++)
					maxStartLifeTime = Math.max(maxStartLifeTime, startLifeTimeGradientMax.getValueByIndex(i));
				break;
			}
			
			//MinMaxSpeed
			var minStartSpeed:Number, maxStartSpeed:Number;
			switch (startSpeedType) {
			case 0: 
				minStartSpeed = maxStartSpeed = startSpeedConstant;
				break;
			case 1: //TODO:
				break;
			case 2: 
				minStartSpeed = startLifetimeConstantMin;
				maxStartSpeed = startLifetimeConstantMax;
				break;
			case 3: //TODO:
				break;
			}
			
			//MinMaxPosition、MinMaxDiection
			var minPosition:Vector3, maxPosition:Vector3, minDirection:Vector3, maxDirection:Vector3;
			if (_shape && _shape.enable) {
				//TODO:
			} else {
				minPosition = maxPosition = Vector3.ZERO;
				minDirection = Vector3.ZERO;
				maxDirection = Vector3.UnitZ;
			}
			
			var startMinVelocity:Vector3 = new Vector3(minDirection.x * minStartSpeed, minDirection.y * minStartSpeed, minDirection.z * minStartSpeed);
			var startMaxVelocity:Vector3 = new Vector3(maxDirection.x * maxStartSpeed, maxDirection.y * maxStartSpeed, maxDirection.z * maxStartSpeed);
			
			if (_velocityOverLifetime && _velocityOverLifetime.enbale) {
				var lifeMinVelocity:Vector3;
				var lifeMaxVelocity:Vector3;
				var velocity:GradientVelocity = _velocityOverLifetime.velocity;
				switch (velocity.type) {
				case 0: 
					lifeMinVelocity = lifeMaxVelocity = velocity.constant;
					break;
				case 1: 
					lifeMinVelocity = lifeMaxVelocity = new Vector3(velocity.gradientX.getAverageValue(), velocity.gradientY.getAverageValue(), velocity.gradientZ.getAverageValue());
					break;
				case 2: 
					lifeMinVelocity = velocity.constantMin;//TODO:Min
					lifeMaxVelocity = velocity.constantMax;
					break;
				case 3: 
					lifeMinVelocity = new Vector3(velocity.gradientXMin.getAverageValue(), velocity.gradientYMin.getAverageValue(), velocity.gradientZMin.getAverageValue());
					lifeMaxVelocity = new Vector3(velocity.gradientXMax.getAverageValue(), velocity.gradientYMax.getAverageValue(), velocity.gradientZMax.getAverageValue());
					break;
				}
			}
			
			var positionScale:Vector3, velocityScale:Vector3;
			var transform:Transform3D = _owner.transform;
			var worldPosition:Vector3 = transform.position;
			var sizeScale:Vector3 = _tempVector39;
			var sizeScaleE:Float32Array = sizeScale.elements;
			var renderMode:int = particleRender.renderMode;
			
			switch (scaleMode) {
			case 0: 
				var scale:Vector3 = transform.scale;
				positionScale = scale;
				sizeScaleE[0] = scale.x;
				sizeScaleE[1] = scale.z;
				sizeScaleE[2] = scale.y;
				(renderMode === 1) && (velocityScale = scale);
				break;
			case 1: 
				var localScale:Vector3 = transform.localScale;
				positionScale = localScale;
				sizeScaleE[0] = localScale.x;
				sizeScaleE[1] = localScale.z;
				sizeScaleE[2] = localScale.y;
				(renderMode === 1) && (velocityScale = localScale);
				break;
			case 2: 
				positionScale = transform.scale;
				sizeScaleE[0] = sizeScaleE[1] = sizeScaleE[2] = 1;
				(renderMode === 1) && (velocityScale = Vector3.ONE);
				break;
			}
			
			var minStratPosition:Vector3, maxStratPosition:Vector3;
			if (_velocityOverLifetime && _velocityOverLifetime.enbale) {
				//var minLifePosition:Vector3, maxLifePosition:Vector3;
				//switch (_velocityOverLifetime.velocity.type) {
				//case 0: 
				//minStratPosition = new Vector3(startMinVelocity.x * maxStartLifeTime, startMinVelocity.y * maxStartLifeTime, startMinVelocity.z * maxStartLifeTime);
				//maxStratPosition = new Vector3(startMaxVelocity.x * maxStartLifeTime, startMaxVelocity.y * maxStartLifeTime, startMaxVelocity.z * maxStartLifeTime);
				//minLifePosition = new Vector3(lifeMinVelocity.x * maxStartLifeTime, lifeMinVelocity.y * maxStartLifeTime, lifeMinVelocity.z * maxStartLifeTime);
				//maxLifePosition = new Vector3(lifeMaxVelocity.x * maxStartLifeTime, lifeMaxVelocity.y * maxStartLifeTime, lifeMaxVelocity.z * maxStartLifeTime);
				//break;
				//}
				////TODO:
			} else {
				minStratPosition = new Vector3(startMinVelocity.x * maxStartLifeTime, startMinVelocity.y * maxStartLifeTime, startMinVelocity.z * maxStartLifeTime);
				maxStratPosition = new Vector3(startMaxVelocity.x * maxStartLifeTime, startMaxVelocity.y * maxStartLifeTime, startMaxVelocity.z * maxStartLifeTime);
				
				if (scaleMode != 2) {
					Vector3.add(minPosition, minStratPosition, boundMin);
					Vector3.multiply(positionScale, boundMin, boundMin);
					//Vector3.transformQuat(boundMin, worldRotation, boundMin);
					
					Vector3.add(maxPosition, maxStratPosition, boundMax);
					Vector3.multiply(positionScale, boundMax, boundMax);
					//Vector3.transformQuat(boundMax, worldRotation, boundMax);
				} else {
					Vector3.multiply(positionScale, minPosition, boundMin);
					Vector3.add(boundMin, minStratPosition, boundMin);
					//Vector3.transformQuat(boundMin, worldRotation, boundMin);
					
					Vector3.multiply(positionScale, maxPosition, boundMax);
					Vector3.add(boundMax, maxStratPosition, boundMax);
					//Vector3.transformQuat(boundMax, worldRotation, boundMax);
				}
			}
			
			switch (simulationSpace) {
			case 0: 
				//TODO:不能用次方法计算
				break;
			case 1: 
				Vector3.add(boundMin, worldPosition, boundMin);
				Vector3.add(boundMax, worldPosition, boundMax);
				break;
			}
			//TODO:重力
			
			// 通过粒子最大尺寸扩充包围盒，最大尺寸为粒子对角线。TODO:HORIZONTALBILLBOARD和VERTICALBILLBOARD缩小cos45
			var maxSize:Number, maxSizeY:Number;
			switch (startSizeType) {
			case 0: 
				if (threeDStartSize) {
					var startSizeConstantSeparate:Vector3 = startSizeConstantSeparate;
					maxSize = Math.max(startSizeConstantSeparate.x, startSizeConstantSeparate.y);//TODO:是否非Mesh模型下不用考虑Z
					if (renderMode === 1)
						maxSizeY = startSizeConstantSeparate.y;
				} else {
					maxSize = startSizeConstant;
					if (renderMode === 1)
						maxSizeY = startSizeConstant;
				}
				break;
			case 1://TODO:
				break;
			case 2: 
				if (threeDStartSize) {
					var startSizeConstantMaxSeparate:Vector3 = startSizeConstantMaxSeparate;
					maxSize = Math.max(startSizeConstantMaxSeparate.x, startSizeConstantMaxSeparate.y);
					if (renderMode === 1)
						maxSizeY = startSizeConstantMaxSeparate.y;
				} else {
					maxSize = startSizeConstantMax;//TODO:是否非Mesh模型下不用考虑Z
					if (renderMode === 1)
						maxSizeY = startSizeConstantMax;
				}
				break;
			case 3://TODO:
				break;
			}
			
			if (_sizeOverLifetime && _sizeOverLifetime.enbale) {
				var size:GradientSize = _sizeOverLifetime.size;
				maxSize *= _sizeOverLifetime.size.getMaxSizeInGradient();
			}
			
			var threeDMaxSize:Vector3 = _tempVector30;
			var threeDMaxSizeE:Float32Array = threeDMaxSize.elements;
			
			var rotSize:Number, nonRotSize:Number;
			switch (renderMode) {
			case 0: 
				rotSize = maxSize * halfKSqrtOf2;
				Vector3.scale(sizeScale, maxSize, threeDMaxSize);
				Vector3.subtract(boundMin, threeDMaxSize, boundMin);
				Vector3.add(boundMax, threeDMaxSize, boundMax);
				break;
			case 1: 
				var maxStretchPosition:Vector3 = _tempVector31;
				var maxStretchVelocity:Vector3 = _tempVector32;
				var minStretchVelocity:Vector3 = _tempVector33;
				var minStretchPosition:Vector3 = _tempVector34;
				
				if (_velocityOverLifetime && _velocityOverLifetime.enbale) {
					//TODO:
				} else {
					Vector3.multiply(velocityScale, startMaxVelocity, maxStretchVelocity);
					Vector3.multiply(velocityScale, startMinVelocity, minStretchVelocity);
				}
				var sizeStretch:Number = maxSizeY * particleRender.stretchedBillboardLengthScale;
				var maxStretchLength:Number = Vector3.scalarLength(maxStretchVelocity) * particleRender.stretchedBillboardSpeedScale + sizeStretch;
				var minStretchLength:Number = Vector3.scalarLength(minStretchVelocity) * particleRender.stretchedBillboardSpeedScale + sizeStretch;
				var norMaxStretchVelocity:Vector3 = _tempVector35;
				var norMinStretchVelocity:Vector3 = _tempVector36;
				Vector3.normalize(maxStretchVelocity, norMaxStretchVelocity);
				Vector3.scale(norMaxStretchVelocity, maxStretchLength, minStretchPosition);
				Vector3.subtract(maxStratPosition, minStretchPosition, minStretchPosition);
				Vector3.normalize(minStretchVelocity, norMinStretchVelocity);
				Vector3.scale(norMinStretchVelocity, minStretchLength, maxStretchPosition);
				Vector3.add(minStratPosition, maxStretchPosition, maxStretchPosition);
				
				rotSize = maxSize * halfKSqrtOf2;
				Vector3.scale(sizeScale, rotSize, threeDMaxSize);
				
				var halfNorMaxStretchVelocity:Vector3 = _tempVector37;
				var halfNorMinStretchVelocity:Vector3 = _tempVector38;
				Vector3.scale(norMaxStretchVelocity, 0.5, halfNorMaxStretchVelocity);
				Vector3.scale(norMinStretchVelocity, 0.5, halfNorMinStretchVelocity);
				Vector3.multiply(halfNorMaxStretchVelocity, sizeScale, halfNorMaxStretchVelocity);
				Vector3.multiply(halfNorMinStretchVelocity, sizeScale, halfNorMinStretchVelocity);
				
				Vector3.add(boundMin, halfNorMinStretchVelocity, boundMin);
				Vector3.min(boundMin, minStretchPosition, boundMin);
				Vector3.subtract(boundMin, threeDMaxSize, boundMin);
				
				Vector3.subtract(boundMax, halfNorMaxStretchVelocity, boundMax);
				Vector3.max(boundMax, maxStretchPosition, boundMax);
				Vector3.add(boundMax, threeDMaxSize, boundMax);
				break;
			case 2: 
				maxSize *= Math.cos(0.78539816339744830961566084581988);
				nonRotSize = maxSize * 0.5;
				threeDMaxSizeE[0] = sizeScale.x * nonRotSize;
				threeDMaxSizeE[1] = sizeScale.z * nonRotSize;
				Vector3.subtract(boundMin, threeDMaxSize, boundMin);
				Vector3.add(boundMax, threeDMaxSize, boundMax);
				break;
			case 3: 
				maxSize *= Math.cos(0.78539816339744830961566084581988);
				nonRotSize = maxSize * 0.5;
				Vector3.scale(sizeScale, nonRotSize, threeDMaxSize);
				Vector3.subtract(boundMin, threeDMaxSize, boundMin);
				Vector3.add(boundMax, threeDMaxSize, boundMax);
				break;
			}
			
			//TODO:min
			//TODO:max
			_boundingBox.getCorners(_boundingBoxCorners);
		}
		
		/**
		 * @private
		 */
		private function _updateEmission():void {
			if (!Laya.stage.isVisibility||!isAlive)
				return;
			if (_simulateUpdate){
				_simulateUpdate = false;
			}
			else{
				var elapsedTime:Number = (_startUpdateLoopCount !== Stat.loopCount && !_isPaused)?Laya.timer.delta / 1000.0:0;
				elapsedTime = Math.min(_maxElapsedTime, elapsedTime);
				_updateParticles(elapsedTime);
			}
		}
		
		/**
		 * @private
		 */
		private function _updateParticles(elapsedTime:Number):void {
			if (_ownerRender.renderMode === 4 && !_ownerRender.mesh)//renderMode=4且mesh为空时不更新
				return;
			
			_currentTime += elapsedTime; 
			_retireActiveParticles();
			_freeRetiredParticles();
			
			//if (_firstActiveElement === _firstFreeElement){
				//_frameRateTime = 0//TODO:是否一起置零
				//_currentTime = 0;
			//}
			//if (_firstRetiredElement === _firstActiveElement)
				//_drawCounter = 0;
			
			_totalDelayTime+= elapsedTime;
			if (_totalDelayTime < _playStartDelay){
				return;
			}
			
			
			if (_emission.enbale&&_isEmitting &&!_isPaused)
				_advanceTime(elapsedTime, _currentTime);
		}
		
		/**
		 * @private
		 */
		private function _updateParticlesSimulationRestart(time:Number):void {
			_firstActiveElement=0;
			_firstNewElement=0;
			_firstFreeElement=0;
			_firstRetiredElement = 0;
			
			_burstsIndex = 0;
			_frameRateTime = time;//TOD0:零还是time待 验证
			_emissionTime = 0;
			_totalDelayTime = 0;
			_currentTime = time;
			
			
			var delayTime:Number =time;
			if (delayTime < _playStartDelay){
				_totalDelayTime = delayTime;
				return;
			}
			
			if (_emission.enbale)
				_advanceTime(time, time);//TODO:如果time，time均为零brust无效
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
		private function _onOwnerActiveHierarchyChanged(active:Boolean):void {
			if (_owner.displayedInStage) {
				if (active)
					_addUpdateEmissionToTimer();
				else
					_removeUpdateEmissionToTimer();
			}
		}
		
		
		/**
		 * @private
		 */
		private function _retireActiveParticles():void {
			const epsilon:Number = 0.0001;
			while (_firstActiveElement != _firstNewElement) {
				var index:int = _firstActiveElement * _floatCountPerVertex * _vertexStride;
				var timeIndex:int = index + _timeIndex;//11为Time
				
				var particleAge:Number = _currentTime - _vertices[timeIndex];
				if (particleAge + epsilon < _vertices[index + _startLifeTimeIndex]/*_maxLifeTime*/)//7为真实lifeTime,particleAge>0为生命周期为负时
					break;
				
				_vertices[timeIndex] = _drawCounter;
				_firstActiveElement++;
				if (_firstActiveElement >= _bufferMaxParticles)
					_firstActiveElement = 0;
			}
		}
		
		/**
		 * @private
		 */
		private function _freeRetiredParticles():void {
			while (_firstRetiredElement != _firstActiveElement) {
				var age:int = _drawCounter - _vertices[_firstRetiredElement * _floatCountPerVertex * _vertexStride + _timeIndex];//11为Time
				
				if (isPerformanceMode)
					if (age < 3)//GPU从不滞后于CPU两帧，出于显卡驱动BUG等安全因素考虑滞后三帧
						break;
				
				_firstRetiredElement++;
				if (_firstRetiredElement >= _bufferMaxParticles)
					_firstRetiredElement = 0;
			}
		}
		
		/**
		 * @private
		 */
		private function _burst(fromTime:Number, toTime:Number):int {
			var totalEmitCount:int = 0;
			var bursts:Vector.<Burst> = _emission._bursts;
			for (var n:int = bursts.length; _burstsIndex < n; _burstsIndex++) {//TODO:_burstsIndex问题
				var burst:Burst = bursts[_burstsIndex];
				var burstTime:Number = burst.time;
				if ( fromTime<=burstTime && burstTime < toTime) {
					var emitCount:int;
					if (autoRandomSeed) {
						emitCount = MathUtil.lerp(burst.minCount, burst.maxCount, Math.random());
					} else {
						_rand.seed = _randomSeeds[0];
						emitCount = MathUtil.lerp(burst.minCount, burst.maxCount, _rand.getFloat());
						_randomSeeds[0] = _rand.seed;
					}
					totalEmitCount += emitCount;
				} else {
					break;
				}
			}
			return totalEmitCount;
		}
		
		/**
		 * @private
		 */
		private function _advanceTime(elapsedTime:Number, emitTime:Number):void {
			var i:int;
			var lastEmissionTime:Number = _emissionTime;
			_emissionTime += elapsedTime;
			var totalEmitCount:int = 0;
			if (_emissionTime > duration) {
				if (looping) {//TODO:有while
					totalEmitCount += _burst(lastEmissionTime, _emissionTime);//使用_emissionTime代替duration，否则无法触发time等于duration的burst //爆裂剩余未触发的//TODO:是否可以用_playbackTime代替计算，不必结束再爆裂一次。//TODO:待确认是否累计爆裂
					_emissionTime -= duration;
					this.event(Event.COMPLETE);
					_burstsIndex = 0;
					totalEmitCount += _burst(0, _emissionTime);
				} else {
					totalEmitCount = Math.min(maxParticles - aliveParticleCount, totalEmitCount);
					for (i = 0; i < totalEmitCount; i++)
						emit(emitTime);
					
					_isPlaying = false;
					stop();
					return;
				}
			} else {
				totalEmitCount += _burst(lastEmissionTime, _emissionTime);
			}
			
			totalEmitCount = Math.min(maxParticles - aliveParticleCount, totalEmitCount);
			for (i = 0; i < totalEmitCount; i++)
				emit(emitTime);
			
			
			var emissionRate:Number = emission.emissionRate;
			if (emissionRate>0){
				var minEmissionTime:Number = 1/emissionRate;
				_frameRateTime += minEmissionTime;
				_frameRateTime = _currentTime-(_currentTime-_frameRateTime) % _maxStartLifetime;//大于最大声明周期的粒子一定会死亡，所以直接略过,TODO:是否更换机制
				while (_frameRateTime <= emitTime) {
					if (emit(_frameRateTime))
						_frameRateTime += minEmissionTime;
					else
						break;
				}
				_frameRateTime = Math.floor(emitTime / minEmissionTime) * minEmissionTime;
			}
		}
		
		/**
		 * @private
		 */
		public function _initBufferDatas():void {
			if (_vertexBuffer) {//修改了maxCount以及renderMode以及Mesh等需要清空
				_vertexBuffer.destroy();
				_indexBuffer.destroy();
			}
			var render:ShurikenParticleRender = _ownerRender;
			var renderMode:int = render.renderMode;
			if (renderMode !== -1 && maxParticles > 0) {
				var indices:Uint16Array, i:int, j:int, m:int, indexOffset:int, perPartOffset:int,vertexDeclaration:VertexDeclaration;;
				var mesh:Mesh = render.mesh;
				if (renderMode === 4) {
					if(mesh){
						var vertexBufferCount:int = mesh._vertexBuffers.length;
						if (vertexBufferCount > 1) {
							throw new Error("ShurikenParticleSystem: submesh Count mesh be One or all subMeshes have the same vertexDeclaration.");
						} else {
							vertexDeclaration = VertexShurikenParticleMesh.vertexDeclaration;
							_floatCountPerVertex = vertexDeclaration.vertexStride/4;
							_startLifeTimeIndex = 12;
							_timeIndex = 16;
							_vertexStride = mesh._vertexBuffers[0].vertexCount;
							var totalVertexCount:int = _bufferMaxParticles * _vertexStride;
							var vbCount:int = Math.floor(totalVertexCount / 65535) + 1;
							var lastVBVertexCount:int = totalVertexCount % 65535;
							if (vbCount > 1) {//TODO:随后支持
								throw new Error("ShurikenParticleSystem:the maxParticleCount multiply mesh vertexCount is large than 65535.");
							}
							_vertexBuffer = VertexBuffer3D.create(vertexDeclaration, lastVBVertexCount, WebGLContext.DYNAMIC_DRAW);
							_vertices = new Float32Array(_floatCountPerVertex * lastVBVertexCount);
							
							_indexStride = mesh._indexBuffer.indexCount;
							var indexDatas:Uint16Array = mesh._indexBuffer.getData();
							var indexCount:int = _bufferMaxParticles * _indexStride;
							_indexBuffer = IndexBuffer3D.create(IndexBuffer3D.INDEXTYPE_USHORT, indexCount, WebGLContext.STATIC_DRAW);
							indices = new Uint16Array(indexCount);
							
							indexOffset = 0;
							for (i = 0; i < _bufferMaxParticles; i++) {
								var indexValueOffset:int = i * _vertexStride;
								for (j = 0, m = indexDatas.length; j < m; j++)
									indices[indexOffset++] = indexValueOffset + indexDatas[j];
							}
							_indexBuffer.setData(indices);
						}
					}
				} else {
					vertexDeclaration = VertexShurikenParticleBillboard.vertexDeclaration;
					_floatCountPerVertex = vertexDeclaration.vertexStride/4;
					_startLifeTimeIndex = 7;
					_timeIndex = 11;
					_vertexStride = 4;						
					_vertexBuffer = VertexBuffer3D.create(vertexDeclaration, _bufferMaxParticles * _vertexStride, WebGLContext.DYNAMIC_DRAW);
					_vertices = new Float32Array(_floatCountPerVertex * _bufferMaxParticles * _vertexStride);
					
					for (i = 0; i < _bufferMaxParticles; i++) {
						perPartOffset = i * _floatCountPerVertex * _vertexStride;
						_vertices[perPartOffset] = -0.5;
						_vertices[perPartOffset + 1] = -0.5;
						_vertices[perPartOffset + 2] = 0;
						_vertices[perPartOffset + 3] = 1;
						
						perPartOffset += _floatCountPerVertex;
						_vertices[perPartOffset] = 0.5;
						_vertices[perPartOffset + 1] = -0.5;
						_vertices[perPartOffset + 2] = 1;
						_vertices[perPartOffset + 3] = 1;
						
						perPartOffset += _floatCountPerVertex
						_vertices[perPartOffset] = 0.5;
						_vertices[perPartOffset + 1] = 0.5;
						_vertices[perPartOffset + 2] = 1;
						_vertices[perPartOffset + 3] = 0;
						
						perPartOffset += _floatCountPerVertex
						_vertices[perPartOffset] = -0.5;
						_vertices[perPartOffset + 1] = 0.5;
						_vertices[perPartOffset + 2] = 0;
						_vertices[perPartOffset + 3] = 0;
					}
					
					_indexStride = 6;
					_indexBuffer = IndexBuffer3D.create(IndexBuffer3D.INDEXTYPE_USHORT, _bufferMaxParticles * 6, WebGLContext.STATIC_DRAW);
					indices = new Uint16Array(_bufferMaxParticles * 6);
					for (i = 0; i < _bufferMaxParticles; i++) {
						indexOffset = i * 6;
						var firstVertex:int = i * _vertexStride, secondVertex:int = firstVertex + 2;
						indices[indexOffset++] = firstVertex;
						indices[indexOffset++] = secondVertex;
						indices[indexOffset++] = firstVertex + 1;
						indices[indexOffset++] = firstVertex;
						indices[indexOffset++] = firstVertex + 3;
						indices[indexOffset++] = secondVertex;
					}
					_indexBuffer.setData(indices);
				}
			}
		}
		
		/**
		 * @private
		 */
		override public function _destroy():void {
			super._destroy();
			( _owner.activeInHierarchy) && (_removeUpdateEmissionToTimer());
			_vertexBuffer.destroy();
			_indexBuffer.destroy();
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
			_velocityOverLifetime = null;
			_colorOverLifetime = null;
			_sizeOverLifetime = null;
			_rotationOverLifetime = null;
			_textureSheetAnimation = null;
		}
		
		/**
		 * 发射一个粒子。
		 */
		public function emit(time:Number):Boolean {
			var position:Vector3 = _tempPosition;
			var direction:Vector3 = _tempDirection;
			if (_shape&&_shape.enable) {
				if (autoRandomSeed)
					_shape.generatePositionAndDirection(position, direction);
				else
					_shape.generatePositionAndDirection(position, direction, _rand, _randomSeeds);
			} else {
				var positionE:Float32Array = position.elements;
				var directionE:Float32Array = direction.elements;
				positionE[0] = positionE[1] = positionE[2] = 0;
				directionE[0] = directionE[1] = 0;
				directionE[2] = 1;
			}
			
			return addParticle(position, direction,time);//TODO:提前判断优化
		}
		
		public function addParticle(position:Vector3, direction:Vector3,time:Number):Boolean {//TODO:还需优化
			Vector3.normalize(direction, direction);
			var nextFreeParticle:int = _firstFreeElement + 1;
			if (nextFreeParticle >= _bufferMaxParticles)
				nextFreeParticle = 0;
			
			if (nextFreeParticle === _firstRetiredElement)
				return false;
			
			ShurikenParticleData.create(this, _ownerRender, _owner.transform);
			
			var particleAge:Number = _currentTime - time;
			if (particleAge >= ShurikenParticleData.startLifeTime)//如果时间已大于声明周期，则直接跳过,TODO:提前优化
				return true;
			
			
			var randomVelocityX:Number, randomVelocityY:Number, randomVelocityZ:Number, randomColor:Number, randomSize:Number, randomRotation:Number, randomTextureAnimation:Number;
			var needRandomVelocity:Boolean = _velocityOverLifetime && _velocityOverLifetime.enbale;
			if (needRandomVelocity) {
				var velocityType:int = _velocityOverLifetime.velocity.type;
				if (velocityType === 2 || velocityType === 3) {
					if (autoRandomSeed) {
						randomVelocityX = Math.random();
						randomVelocityY = Math.random();
						randomVelocityZ = Math.random();
					} else {
						_rand.seed = _randomSeeds[9];
						randomVelocityX = _rand.getFloat();
						randomVelocityY = _rand.getFloat();
						randomVelocityZ = _rand.getFloat();
						_randomSeeds[9] = _rand.seed;
					}
				} else {
					needRandomVelocity = false;
				}
			} else {
				needRandomVelocity = false;
			}
			var needRandomColor:Boolean = _colorOverLifetime && _colorOverLifetime.enbale;
			if (needRandomColor) {
				var colorType:int = _colorOverLifetime.color.type;
				if (colorType === 3) {
					if (autoRandomSeed) {
						randomColor = Math.random();
					} else {
						_rand.seed = _randomSeeds[10];
						randomColor = _rand.getFloat();
						_randomSeeds[10] = _rand.seed;
					}
				} else {
					needRandomColor = false;
				}
			} else {
				needRandomColor = false;
			}
			var needRandomSize:Boolean = _sizeOverLifetime && _sizeOverLifetime.enbale;
			if (needRandomSize) {
				var sizeType:int = _sizeOverLifetime.size.type;
				if (sizeType === 3) {
					if (autoRandomSeed) {
						randomSize = Math.random();
					} else {
						_rand.seed = _randomSeeds[11];
						randomSize = _rand.getFloat();
						_randomSeeds[11] = _rand.seed;
					}
				} else {
					needRandomSize = false;
				}
			} else {
				needRandomSize = false;
			}
			var needRandomRotation:Boolean = _rotationOverLifetime && _rotationOverLifetime.enbale;
			if (needRandomRotation) {
				var rotationType:int = _rotationOverLifetime.angularVelocity.type;
				if (rotationType === 2 || rotationType === 3) {
					if (autoRandomSeed) {
						randomRotation = Math.random();
					} else {
						_rand.seed = _randomSeeds[12];
						randomRotation = _rand.getFloat();
						_randomSeeds[12] = _rand.seed;
					}
				} else {
					needRandomRotation = false;
				}
			} else {
				needRandomRotation = false;
			}
			var needRandomTextureAnimation:Boolean = _textureSheetAnimation && _textureSheetAnimation.enable;
			if (needRandomTextureAnimation) {
				var textureAnimationType:int = _textureSheetAnimation.frame.type;
				if (textureAnimationType === 3) {
					if (autoRandomSeed) {
						randomTextureAnimation = Math.random();
					} else {
						_rand.seed = _randomSeeds[15];
						randomTextureAnimation = _rand.getFloat();
						_randomSeeds[15] = _rand.seed;
					}
				} else {
					needRandomTextureAnimation = false;
				}
			} else {
				needRandomTextureAnimation = false;
			}
			
			var startIndex:int = _firstFreeElement * _floatCountPerVertex * _vertexStride;
			var subU:Number = ShurikenParticleData.startUVInfo[0];
			var subV:Number = ShurikenParticleData.startUVInfo[1];
			var startU:Number = ShurikenParticleData.startUVInfo[2];
			var startV:Number = ShurikenParticleData.startUVInfo[3];
			var positionE:Float32Array = position.elements;
			var directionE:Float32Array = direction.elements;
			
			var meshVertices:Float32Array, meshVertexStride:int, meshPosOffset:int,meshCorOffset:int, meshUVOffset:int, meshVertexIndex:int;
			var render:ShurikenParticleRender = _ownerRender;
			if (render.renderMode === 4) {
				var meshVB:VertexBuffer3D = render.mesh._vertexBuffers[0];
				meshVertices = meshVB.getData();
				var meshVertexDeclaration:VertexDeclaration = meshVB.vertexDeclaration;
				meshPosOffset = meshVertexDeclaration.getVertexElementByUsage(VertexElementUsage.POSITION0).offset / 4;
				var colorElement:VertexElement = meshVertexDeclaration.getVertexElementByUsage(VertexElementUsage.COLOR0);
				meshCorOffset = colorElement?colorElement.offset / 4: -1;
				var uvElement:VertexElement = meshVertexDeclaration.getVertexElementByUsage(VertexElementUsage.TEXTURECOORDINATE0);
				meshUVOffset = uvElement?uvElement.offset / 4:-1;
				meshVertexStride = meshVertexDeclaration.vertexStride / 4;
				meshVertexIndex = 0;
			} else {
				_vertices[startIndex + 2] = startU;
				_vertices[startIndex + 3] = startV + subV;
				var secondOffset:int = startIndex + _floatCountPerVertex;
				_vertices[secondOffset + 2] = startU + subU;
				_vertices[secondOffset + 3] = startV + subV;
				var thirdOffset:int = secondOffset + _floatCountPerVertex;
				_vertices[thirdOffset + 2] = startU + subU;
				_vertices[thirdOffset + 3] = startV;
				var fourthOffset:int = thirdOffset + _floatCountPerVertex;
				_vertices[fourthOffset + 2] = startU;
				_vertices[fourthOffset + 3] = startV;
			}
			
			for (var i:int = startIndex, n:int = startIndex + _floatCountPerVertex * _vertexStride; i < n; i += _floatCountPerVertex) {
				var offset:int;
				if (render.renderMode === 4) {
					offset = i;
					var vertexOffset:int = meshVertexStride * (meshVertexIndex++);
					var meshOffset:int = vertexOffset + meshPosOffset;
					_vertices[offset++] = meshVertices[meshOffset++];
					_vertices[offset++] = meshVertices[meshOffset++];
					_vertices[offset++] = meshVertices[meshOffset];
					if (meshCorOffset ===-1){
						_vertices[offset++] = 1.0;
						_vertices[offset++] = 1.0;
						_vertices[offset++] = 1.0;
						_vertices[offset++] = 1.0;
					}
					else{
						meshOffset = vertexOffset + meshCorOffset;
						_vertices[offset++] = meshVertices[meshOffset++];
						_vertices[offset++] = meshVertices[meshOffset++];
						_vertices[offset++] = meshVertices[meshOffset++];
						_vertices[offset++] = meshVertices[meshOffset];
					}
					if (meshUVOffset ===-1){
						_vertices[offset++] = 0.0;
						_vertices[offset++] = 0.0;
					}
					else{
						meshOffset = vertexOffset + meshUVOffset;
						_vertices[offset++] = startU + meshVertices[meshOffset++] * subU;
						_vertices[offset++] = startV + meshVertices[meshOffset] * subV;
					}
				} else {
					offset = i + 4;
				}
				
				_vertices[offset++] = positionE[0];
				_vertices[offset++] = positionE[1];
				_vertices[offset++] = positionE[2];
				
				_vertices[offset++] = ShurikenParticleData.startLifeTime;
				
				_vertices[offset++] = directionE[0];
				_vertices[offset++] = directionE[1];
				_vertices[offset++] = directionE[2];
				_vertices[offset++] = time;
				
				_vertices[offset++] = ShurikenParticleData.startColor[0];
				_vertices[offset++] = ShurikenParticleData.startColor[1];
				_vertices[offset++] = ShurikenParticleData.startColor[2];
				_vertices[offset++] = ShurikenParticleData.startColor[3];
				
				_vertices[offset++] = ShurikenParticleData.startSize[0];
				_vertices[offset++] = ShurikenParticleData.startSize[1];
				_vertices[offset++] = ShurikenParticleData.startSize[2];
				
				_vertices[offset++] = ShurikenParticleData.startRotation[0];
				_vertices[offset++] = ShurikenParticleData.startRotation[1];
				_vertices[offset++] = ShurikenParticleData.startRotation[2];
				
				_vertices[offset++] = ShurikenParticleData.startSpeed;
				
				// (_vertices[offset] = XX);TODO:29预留
				needRandomColor && (_vertices[offset + 1] = randomColor);
				needRandomSize && (_vertices[offset + 2] = randomSize);
				needRandomRotation && (_vertices[offset + 3] = randomRotation);
				needRandomTextureAnimation && (_vertices[offset + 4] = randomTextureAnimation);
				if (needRandomVelocity) {
					_vertices[offset + 5] = randomVelocityX;
					_vertices[offset + 6] = randomVelocityY;
					_vertices[offset + 7] = randomVelocityZ;
				}
				
				switch(simulationSpace){
				case 0:
					offset +=8;
					_vertices[offset++] = ShurikenParticleData.simulationWorldPostion[0];
					_vertices[offset++] = ShurikenParticleData.simulationWorldPostion[1];
					_vertices[offset++] = ShurikenParticleData.simulationWorldPostion[2];
					_vertices[offset++] = ShurikenParticleData.simulationWorldRotation[0];
					_vertices[offset++] = ShurikenParticleData.simulationWorldRotation[1];
					_vertices[offset++] = ShurikenParticleData.simulationWorldRotation[2];
					_vertices[offset++] = ShurikenParticleData.simulationWorldRotation[3];
				break;
				case 1:
					break;
				default:
					throw new Error("ShurikenParticleMaterial: SimulationSpace value is invalid.");
				}
			}
			
			_firstFreeElement = nextFreeParticle;
			return true;
		}
		
		public function addNewParticlesToVertexBuffer():void {
			var start:int;
			if (_firstNewElement < _firstFreeElement) {
				start = _firstNewElement * _vertexStride * _floatCountPerVertex;
				_vertexBuffer.setData(_vertices, start, start, (_firstFreeElement - _firstNewElement) * _vertexStride * _floatCountPerVertex);
				
			} else {
				start = _firstNewElement * _vertexStride * _floatCountPerVertex;
				_vertexBuffer.setData(_vertices, start, start, (_bufferMaxParticles - _firstNewElement) * _vertexStride * _floatCountPerVertex);
				
				if (_firstFreeElement > 0) {
					_vertexBuffer.setData(_vertices, 0, 0, _firstFreeElement * _vertexStride * _floatCountPerVertex);
					
				}
			}
			_firstNewElement = _firstFreeElement;
		}
		
		public function _beforeRender(state:RenderState):Boolean {
			//设备丢失时, setData  here,WebGL不会丢失。
			if (_firstNewElement != _firstFreeElement) 
				addNewParticlesToVertexBuffer();
			
			_drawCounter++;
			if (_firstActiveElement != _firstFreeElement) {
				_vertexBuffer._bind();
				_indexBuffer._bind();
				return true;
			}
			return false;
		}
		
		/**
		 * @private
		 */
		public function _render(state:RenderState):void {
			var indexCount:int;
			var gl:WebGLContext = WebGL.mainContext;
			if (_firstActiveElement < _firstFreeElement) {
				indexCount = (_firstFreeElement - _firstActiveElement) * _indexStride;
				gl.drawElements(WebGLContext.TRIANGLES, indexCount, WebGLContext.UNSIGNED_SHORT, 2 * _firstActiveElement * _indexStride);
				Stat.trianglesFaces += indexCount / 3;
				Stat.drawCall++;
			} else {
				indexCount = (_bufferMaxParticles - _firstActiveElement) * _indexStride;
				gl.drawElements(WebGLContext.TRIANGLES, indexCount, WebGLContext.UNSIGNED_SHORT, 2 * _firstActiveElement * _indexStride);
				Stat.trianglesFaces += indexCount / 3;
				Stat.drawCall++;
				if (_firstFreeElement > 0) {
					indexCount = _firstFreeElement * _indexStride;
					gl.drawElements(WebGLContext.TRIANGLES, indexCount, WebGLContext.UNSIGNED_SHORT, 0);
					Stat.trianglesFaces += indexCount / 3;
					Stat.drawCall++;
				}
			}
		}
		
		/**
		 * 开始发射粒子。
		 */
		public function play():void {
			_burstsIndex = 0;
			_isEmitting = true;
			_isPlaying = true;
			_isPaused = false;
			_emissionTime = 0;
			_totalDelayTime = 0;
			
			if (!autoRandomSeed) {
				for (var i:int = 0, n:int = _randomSeeds.length; i < n; i++)
					_randomSeeds[i] = randomSeed[0] + _RANDOMOFFSET[i];
			}
			
			switch (startDelayType) {
			case 0: 
				_playStartDelay = startDelay;
				break;
			case 1: 
				if (autoRandomSeed) {
					_playStartDelay = MathUtil.lerp(startDelayMin, startDelayMax, Math.random());
				} else {
					_rand.seed = _randomSeeds[2];
					_playStartDelay = MathUtil.lerp(startDelayMin, startDelayMax, _rand.getFloat());
					_randomSeeds[2] = _rand.seed;
				}
				break;
			default: 
				throw new Error("Utils3D: startDelayType is invalid.");
			}
			
			_frameRateTime = _currentTime+_playStartDelay;//同步频率模式发射时间,更新函数中小于延迟时间不会更新此时间。
			
			_startUpdateLoopCount = Stat.loopCount;
			this.event(Event.PLAYED);
		}
		
		/**
		 * 暂停发射粒子。
		 */
		public function pause():void {
			_isPaused = true;
			this.event(Event.PAUSED);
		}
		
		/**
		 * 通过指定时间增加粒子播放进度，并暂停播放。
		 * @param time 进度时间.如果restart为true,粒子播放时间会归零后再更新进度。
		 * @param restart 是否重置播放状态。
		 */
		public function simulate(time:Number, restart:Boolean = true):void{
			_simulateUpdate = true;
			
			if (restart){
				_updateParticlesSimulationRestart(time);
			}
			else{
				_isPaused = false;//如果当前状态为暂停则无法发射粒子
				_updateParticles(time);
			}
			
			pause();
		}
		
		/**
		 * 停止发射粒子。
		 */
		public function stop():void {
			_burstsIndex = 0;
			_isEmitting = false;
			_emissionTime = 0;
			this.event(Event.STOPPED);
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var dest:ShurikenParticleSystem = destObject as ShurikenParticleSystem;
			
			dest.duration = duration;
			dest.looping = looping;
			dest.prewarm = prewarm;
			dest.startDelayType = startDelayType;
			dest.startDelay = startDelay;
			dest.startDelayMin = startDelayMin;
			dest.startDelayMax = startDelayMax;
			
			dest._maxStartLifetime = _maxStartLifetime;
			dest.startLifetimeType = startLifetimeType;
			dest.startLifetimeConstant = startLifetimeConstant;
			startLifeTimeGradient.cloneTo(dest.startLifeTimeGradient);
			dest.startLifetimeConstantMin = startLifetimeConstantMin;
			dest.startLifetimeConstantMax = startLifetimeConstantMax;
			startLifeTimeGradientMin.cloneTo(dest.startLifeTimeGradientMin);
			startLifeTimeGradientMax.cloneTo(dest.startLifeTimeGradientMax);
			
			dest.startSpeedType = startSpeedType;
			dest.startSpeedConstant = startSpeedConstant;
			dest.startSpeedConstantMin = startSpeedConstantMin;
			dest.startSpeedConstantMax = startSpeedConstantMax;
			
			dest.threeDStartSize = threeDStartSize;
			dest.startSizeType = startSizeType;
			dest.startSizeConstant = startSizeConstant;
			startSizeConstantSeparate.cloneTo(dest.startSizeConstantSeparate);
			dest.startSizeConstantMin = startSizeConstantMin;
			dest.startSizeConstantMax = startSizeConstantMax;
			startSizeConstantMinSeparate.cloneTo(dest.startSizeConstantMinSeparate);
			startSizeConstantMaxSeparate.cloneTo(dest.startSizeConstantMaxSeparate);
			
			dest.threeDStartRotation = threeDStartRotation;
			dest.startRotationType = startRotationType;
			dest.startRotationConstant = startRotationConstant;
			startRotationConstantSeparate.cloneTo(dest.startRotationConstantSeparate);
			dest.startRotationConstantMin = startRotationConstantMin;
			dest.startRotationConstantMax = startRotationConstantMax;
			startRotationConstantMinSeparate.cloneTo(dest.startRotationConstantMinSeparate);
			startRotationConstantMaxSeparate.cloneTo(dest.startRotationConstantMaxSeparate);
			
			dest.randomizeRotationDirection = randomizeRotationDirection;
			
			dest.startColorType = startColorType;
			startColorConstant.cloneTo(dest.startColorConstant);
			startColorConstantMin.cloneTo(dest.startColorConstantMin);
			startColorConstantMax.cloneTo(dest.startColorConstantMax);
			
			dest.gravityModifier = gravityModifier;
			dest.simulationSpace = simulationSpace;
			dest.scaleMode = scaleMode;
			dest.playOnAwake = playOnAwake;
			//dest.autoRandomSeed = autoRandomSeed;
			
			dest.maxParticles = maxParticles;
			
			//TODO:可做更优判断
			(_emission) && (dest._emission = _emission.clone());
			(shape) && (dest.shape = shape.clone());
			(velocityOverLifetime) && (dest.velocityOverLifetime = velocityOverLifetime.clone());
			(colorOverLifetime) && (dest.colorOverLifetime = colorOverLifetime.clone());
			(sizeOverLifetime) && (dest.sizeOverLifetime = sizeOverLifetime.clone());
			(rotationOverLifetime) && (dest.rotationOverLifetime = rotationOverLifetime.clone());
			(textureSheetAnimation) && (dest.textureSheetAnimation = textureSheetAnimation.clone());
			//
			
			dest.isPerformanceMode = isPerformanceMode;
			
			dest._isEmitting = _isEmitting;
			dest._isPlaying = _isPlaying;
			dest._isPaused = _isPaused;
			dest._playStartDelay = _playStartDelay;
			dest._frameRateTime = _frameRateTime;
			dest._emissionTime = _emissionTime;
			dest._totalDelayTime = _totalDelayTime;
			dest._burstsIndex = _burstsIndex;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var dest:ShurikenParticleSystem = __JS__("new this.constructor()");
			cloneTo(dest);
			return dest;
		}
		
		/**
		 * @private
		 */
		public function _getVertexBuffers():Vector.<VertexBuffer3D>{
			return null;
		}
		
		public function _renderRuntime(conchGraphics3D:*, renderElement:RenderElement, state:RenderState):void//NATIVE
		{
		
		}
	}
}
