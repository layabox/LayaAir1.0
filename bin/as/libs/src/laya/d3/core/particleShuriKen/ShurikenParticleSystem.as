package laya.d3.core.particleShuriKen {
	import laya.d3.core.GeometryFilter;
	import laya.d3.core.IClone;
	import laya.d3.core.particleShuriKen.module.Burst;
	import laya.d3.core.particleShuriKen.module.GradientAngularVelocity;
	import laya.d3.core.particleShuriKen.module.GradientColor;
	import laya.d3.core.particleShuriKen.module.GradientDataColor;
	import laya.d3.core.particleShuriKen.module.GradientSize;
	import laya.d3.core.particleShuriKen.module.GradientVelocity;
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
	import laya.d3.math.Vector2;
	import laya.d3.graphics.VertexParticleShuriken;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.events.Event;
	import laya.events.EventDispatcher;
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
		/** @private */
		private static var _tempPosition:Vector3 = new Vector3();
		/** @private */
		private static var _tempDirection:Vector3 = new Vector3();
		
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
		private var _bufferMaxParticles:int;
		/**@private */
		private var _emission:Emission;
		/**@private */
		private var _shape:BaseShape;
		
		/**@private */
		private var _isPlaying:Boolean;
		/**@private */
		private var _isPaused:Boolean;
		/**@private */
		private var _playStartDelay:Number;
		/**@private 发射的累计时间。*/
		private var _frameTime:Number;
		/**@private 一次循环内的累计时间。*/
		private var _emissionTime:Number;
		/**@private 播放的累计时间。*/
		private var _playbackTime:Number;
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
		
		/** @private */
		private var _uvLength:Vector2 = new Vector2();//TODO:
		
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
		/**模拟器空间,0为World,1为Local。暂不支持*/
		public var simulationSpace:int;
		/**缩放模式，0为Hiercachy,1为Local,2为World。暂不支持1,2*/
		public var scaleMode:int;
		/**是否自动开始。*/
		public var playOnAwake:Boolean;
		/**是否自动随机种子*/
		//public var autoRandomSeed:int;
		
		/**是否为性能模式,性能模式下会延迟粒子释放。*/
		public var isPerformanceMode:Boolean;
		
		/**当前粒子时间。*/
		public function get currentTime():Number {
			return _currentTime;
		}
		
		/**获取最大粒子数。*/
		public function get maxParticles():int {
			return _bufferMaxParticles - 1;
		}
		
		/**设置最大粒子数,注意:谨慎修改此属性，有性能损耗。*/
		public function set maxParticles(value:int):void {//TODO:是否要重置其它参数
			var newMaxParticles:int = value + 1;
			if (newMaxParticles !== _bufferMaxParticles) {
				_bufferMaxParticles = newMaxParticles;
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
			_shape = value;
			_emission._shape = value;
		}
		
		/**
		 * 是否存活。
		 */
		public function get isAlive():Boolean {
			if (_isPlaying || aliveParticleCount > 0)//TODO:暂时忽略retired
				return true;
			
			return false;
		}
		
		/**是否正在播放。*/
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		/**是否已暂停。*/
		public function get isPaused():Boolean {
			return _isPaused;
		}
		
		/**
		 * 获取播放的累计时间。
		 * @return 播放的累计时间。
		 */
		public function get playbackTime():Number {
			return _playbackTime;
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
			if (value) {
				var velocity:GradientVelocity = value.velocity;
				var velocityType:int = velocity.type;
				if (value.enbale) {
					switch (velocityType) {
					case 0: 
						_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_VELOCITYOVERLIFETIMECONSTANT);
						break;
					case 1: 
						_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_VELOCITYOVERLIFETIMECURVE);
						break;
					case 2: 
						_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCONSTANT);
						break;
					case 3: 
						_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCURVE);
						break;
					}
					
				} else {
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_VELOCITYOVERLIFETIMECONSTANT);
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_VELOCITYOVERLIFETIMECURVE);
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCONSTANT);
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCURVE);
				}
				
				switch (velocityType) {
				case 0: 
					_owner._setShaderValueColor(ShuriKenParticle3D.VOLVELOCITYCONST, velocity.constant);
					break;
				case 1: 
					_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTX, velocity.gradientX._elements);
					_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTY, velocity.gradientY._elements);
					_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTZ, velocity.gradientZ._elements);
					break;
				case 2: 
					_owner._setShaderValueColor(ShuriKenParticle3D.VOLVELOCITYCONST, velocity.constantMin);
					_owner._setShaderValueColor(ShuriKenParticle3D.VOLVELOCITYCONSTMAX, velocity.constantMax);
					break;
				case 3: 
					_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTX, velocity.gradientXMin._elements);
					_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTXMAX, velocity.gradientXMax._elements);
					_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTY, velocity.gradientYMin._elements);
					_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTYMAX, velocity.gradientYMax._elements);
					_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTZ, velocity.gradientZMin._elements);
					_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTZMAX, velocity.gradientZMax._elements);
					break;
				}
				_owner._setShaderValueInt(ShuriKenParticle3D.VOLSPACETYPE, value.space);
			} else {
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_VELOCITYOVERLIFETIMECONSTANT);
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_VELOCITYOVERLIFETIMECURVE);
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCONSTANT);
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCURVE);
				
				_owner._setShaderValueColor(ShuriKenParticle3D.VOLVELOCITYCONST, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTX, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTY, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTZ, null);
				_owner._setShaderValueColor(ShuriKenParticle3D.VOLVELOCITYCONST, null);
				_owner._setShaderValueColor(ShuriKenParticle3D.VOLVELOCITYCONSTMAX, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTX, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTXMAX, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTY, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTYMAX, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTZ, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.VOLVELOCITYGRADIENTZMAX, null);
				_owner._setShaderValueInt(ShuriKenParticle3D.VOLSPACETYPE, undefined);
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
			if (value) {
				var color:GradientColor = value.color;
				if (value.enbale) {
					switch (color.type) {
					case 1: 
						_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_COLOROVERLIFETIME);
						break;
					case 3: 
						_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_RANDOMCOLOROVERLIFETIME);
						break;
					}
				} else {
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_COLOROVERLIFETIME);
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_RANDOMCOLOROVERLIFETIME);
				}
				
				switch (color.type) {
				case 1: 
					var gradientColor:GradientDataColor = color.gradient;
					_owner._setShaderValueBuffer(ShuriKenParticle3D.COLOROVERLIFEGRADIENTALPHAS, gradientColor._alphaElements);
					_owner._setShaderValueBuffer(ShuriKenParticle3D.COLOROVERLIFEGRADIENTCOLORS, gradientColor._rgbElements);
					break;
				case 3: 
					var minGradientColor:GradientDataColor = color.gradientMin;
					var maxGradientColor:GradientDataColor = color.gradientMax;
					_owner._setShaderValueBuffer(ShuriKenParticle3D.COLOROVERLIFEGRADIENTALPHAS, minGradientColor._alphaElements);
					_owner._setShaderValueBuffer(ShuriKenParticle3D.COLOROVERLIFEGRADIENTCOLORS, minGradientColor._rgbElements);
					_owner._setShaderValueBuffer(ShuriKenParticle3D.MAXCOLOROVERLIFEGRADIENTALPHAS, maxGradientColor._alphaElements);
					_owner._setShaderValueBuffer(ShuriKenParticle3D.MAXCOLOROVERLIFEGRADIENTCOLORS, maxGradientColor._rgbElements);
					break;
				}
			} else {
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_COLOROVERLIFETIME);
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_RANDOMCOLOROVERLIFETIME);
				
				_owner._setShaderValueBuffer(ShuriKenParticle3D.COLOROVERLIFEGRADIENTALPHAS, gradientColor._alphaElements);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.COLOROVERLIFEGRADIENTCOLORS, gradientColor._rgbElements);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.COLOROVERLIFEGRADIENTALPHAS, minGradientColor._alphaElements);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.COLOROVERLIFEGRADIENTCOLORS, minGradientColor._rgbElements);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.MAXCOLOROVERLIFEGRADIENTALPHAS, maxGradientColor._alphaElements);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.MAXCOLOROVERLIFEGRADIENTCOLORS, maxGradientColor._rgbElements);
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
			if (value) {
				var size:GradientSize = value.size;
				var sizeSeparate:Boolean = size.separateAxes;
				var sizeType:int = size.type;
				if (value.enbale) {
					switch (sizeType) {
					case 0: 
						if (sizeSeparate)
							_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_SIZEOVERLIFETIMECURVESEPERATE);
						else
							_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_SIZEOVERLIFETIMECURVE);
						break;
					case 2: 
						if (sizeSeparate)
							_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVESSEPERATE);
						else
							_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVES);
						break;
					}
					
				} else {
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_SIZEOVERLIFETIMECURVE);
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_SIZEOVERLIFETIMECURVESEPERATE);
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVES);
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVESSEPERATE);
				}
				
				switch (sizeType) {
				case 0: 
					if (sizeSeparate) {
						_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTX, size.gradientX._elements);
						_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTY, size.gradientY._elements);
						_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSizeGradientZ, size.gradientZ._elements);
					} else {
						_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENT, size.gradient._elements);
					}
					break;
				case 2: 
					if (sizeSeparate) {
						_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTX, size.gradientXMin._elements);
						_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTXMAX, size.gradientXMax._elements);
						_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTY, size.gradientYMin._elements);
						_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTYMAX, size.gradientYMax._elements);
						_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSizeGradientZ, size.gradientZMin._elements);
						_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSizeGradientZMAX, size.gradientZMax._elements);
					} else {
						_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENT, size.gradientMin._elements);
						_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSizeGradientMax, size.gradientMax._elements);
					}
					break;
				}
			} else {
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_SIZEOVERLIFETIMECURVE);
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_SIZEOVERLIFETIMECURVESEPERATE);
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVES);
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVESSEPERATE);
				
				_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTX, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTXMAX, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTY, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENTYMAX, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSizeGradientZ, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSizeGradientZMAX, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSIZEGRADIENT, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.SOLSizeGradientMax, null);
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
			if (value) {
				var rotation:GradientAngularVelocity = value.angularVelocity;
				var rotationSeparate:Boolean = rotation.separateAxes;
				var rotationType:int = rotation.type;
				if (value.enbale) {
					if (rotationSeparate)
						_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIMESEPERATE);
					else
						_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIME);
					switch (rotationType) {
					case 0: 
						_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIMECONSTANT);
						break;
					case 1: 
						_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIMECURVE);
						break;
					case 2: 
						_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCONSTANTS);
						break;
					case 3: 
						_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCURVES);
						break;
					}
				} else {
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIME);
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIMESEPERATE);
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIMECONSTANT);
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIMECURVE);
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCONSTANTS);
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCURVES);
				}
				
				switch (rotationType) {
				case 0: 
					if (rotationSeparate) {
						_owner._setShaderValueColor(ShuriKenParticle3D.ROLANGULARVELOCITYCONSTSEPRARATE, rotation.constantSeparate);
					} else {
						_owner._setShaderValueNumber(ShuriKenParticle3D.ROLANGULARVELOCITYCONST, rotation.constant);
					}
					break;
				case 1: 
					if (rotationSeparate) {
						_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTX, rotation.gradientX._elements);
						_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTY, rotation.gradientY._elements);
						_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTZ, rotation.gradientZ._elements);
					} else {
						_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENT, rotation.gradient._elements);
					}
					break;
				case 2: 
					if (rotationSeparate) {
						_owner._setShaderValueColor(ShuriKenParticle3D.ROLANGULARVELOCITYCONSTSEPRARATE, rotation.constantMinSeparate);
						_owner._setShaderValueColor(ShuriKenParticle3D.ROLANGULARVELOCITYCONSTMAXSEPRARATE, rotation.constantMaxSeparate);
					} else {
						_owner._setShaderValueNumber(ShuriKenParticle3D.ROLANGULARVELOCITYCONST, rotation.constantMin);
						_owner._setShaderValueNumber(ShuriKenParticle3D.ROLANGULARVELOCITYCONSTMAX, rotation.constantMax);
					}
					break;
				case 3: 
					if (rotationSeparate) {
						_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTX, rotation.gradientXMin._elements);
						_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTXMAX, rotation.gradientXMax._elements);
						_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTY, rotation.gradientYMin._elements);
						_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTYMAX, rotation.gradientYMax._elements);
						_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTZ, rotation.gradientZMin._elements);
						_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTZMAX, rotation.gradientZMax._elements);
					} else {
						_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENT, rotation.gradientMin._elements);
						_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTMAX, rotation.gradientMax._elements);
					}
					break;
				}
			} else {
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIME);
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIMESEPERATE);
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIMECONSTANT);
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIMECURVE);
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCONSTANTS);
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCURVES);
				
				_owner._setShaderValueColor(ShuriKenParticle3D.ROLANGULARVELOCITYCONSTSEPRARATE, null);
				_owner._setShaderValueColor(ShuriKenParticle3D.ROLANGULARVELOCITYCONSTMAXSEPRARATE, null);
				_owner._setShaderValueNumber(ShuriKenParticle3D.ROLANGULARVELOCITYCONST, undefined);
				_owner._setShaderValueNumber(ShuriKenParticle3D.ROLANGULARVELOCITYCONSTMAX, undefined);
				
				_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTX, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTXMAX, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTY, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTYMAX, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTZ, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTZMAX, null);
				
				_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENT, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTMAX, null);
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
			if (value) {
				var frameOverTime:FrameOverTime = value.frame;
				var textureAniType:int = frameOverTime.type;
				if (value.enbale) {
					switch (textureAniType) {
					case 1: 
						_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_TEXTURESHEETANIMATIONCURVE);
						break;
						_owner._addShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_TEXTURESHEETANIMATIONRANDOMCURVE);
					case 3: 
						break;
						
					}
				} else {
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_TEXTURESHEETANIMATIONCURVE);
					_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_TEXTURESHEETANIMATIONRANDOMCURVE);
				}
				
				if (textureAniType === 1 || textureAniType === 3) {
					_owner._setShaderValueInt(ShuriKenParticle3D.TEXTURESHEETANIMATIONCYCLES, value.cycles);
					var title:Vector2 = value.tiles;
					var _uvLengthE:Float32Array = _uvLength.elements;
					_uvLengthE[0] = 1.0 / title.x;
					_uvLengthE[1] = 1.0 / title.y;
					_owner._setShaderValueVector2(ShuriKenParticle3D.TEXTURESHEETANIMATIONSUBUVLENGTH, _uvLength);
				}
				switch (textureAniType) {
				case 1: 
					_owner._setShaderValueBuffer(ShuriKenParticle3D.TEXTURESHEETANIMATIONGRADIENTUVS, frameOverTime.frameOverTimeData._elements);
					break;
				case 3: 
					_owner._setShaderValueBuffer(ShuriKenParticle3D.TEXTURESHEETANIMATIONGRADIENTUVS, frameOverTime.frameOverTimeDataMin._elements);
					_owner._setShaderValueBuffer(ShuriKenParticle3D.TEXTURESHEETANIMATIONGRADIENTMAXUVS, frameOverTime.frameOverTimeDataMax._elements);
					break;
				}
				
			} else {
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_TEXTURESHEETANIMATIONCURVE);
				_owner._removeShaderDefine(ShurikenParticleMaterial.SHADERDEFINE_TEXTURESHEETANIMATIONRANDOMCURVE);
				
				_owner._setShaderValueInt(ShuriKenParticle3D.TEXTURESHEETANIMATIONCYCLES, undefined);
				_owner._setShaderValueVector2(ShuriKenParticle3D.TEXTURESHEETANIMATIONSUBUVLENGTH, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.TEXTURESHEETANIMATIONGRADIENTUVS, null);
				_owner._setShaderValueBuffer(ShuriKenParticle3D.TEXTURESHEETANIMATIONGRADIENTMAXUVS, null);
			}
			_textureSheetAnimation = value;
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
			_floatCountPerVertex = 40;//(0~3为CornerTextureCoordinate),(4~6为Position,7为StartLifeTime),(8~10Direction,11为Time),12到15为StartColor,16到18为StartSize,19到21为3DStartRotationForward(或19为2DStartRotation),22到24为3DStartRotationRight,25到27为3DStartRotationUp,28为startSpeed,29到32为random0,33到36为random1,37到39为世界空间模拟器模式位置(附加数据)
			
			_isPlaying = false;
			_isPaused = false;
			_burstsIndex = 0;
			_frameTime = 0;
			_emissionTime = 0;
			_playbackTime = 0;
			
			_bufferMaxParticles = 1000;
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
			if (!Laya.stage.isVisibility)
				return;
			
			var elapsedTime:Number = 0;
			(_startUpdateLoopCount !== Stat.loopCount) && (elapsedTime = Laya.timer.delta / 1000.0, _currentTime += elapsedTime);
			
			_retireActiveParticles();
			_freeRetiredParticles();
			
			(_emission.enbale) && (_advanceTime(elapsedTime));//TODO:更新完退休和激活粒子最后播放
			
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
				var timeIndex:int = index + 11;//11为Time
				
				var particleAge:Number = _currentTime - _vertices[timeIndex];
				if (particleAge + epsilon < _vertices[index + 7]/*_maxLifeTime*/)//7为真实lifeTime
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
				var age:int = _drawCounter - _vertices[_firstRetiredElement * _floatCountPerVertex * 4 + 11];//11为Time
				
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
		private function _setPartVertexDatas(subU:Number, subV:Number, startU:Number, startV:Number):void {
			for (var i:int = 0; i < _bufferMaxParticles; i++) {
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
			_vertexBuffer = VertexBuffer3D.create(VertexParticleShuriken.vertexDeclaration, _bufferMaxParticles * 4, WebGLContext.DYNAMIC_DRAW);
			_vertices = new Float32Array(_bufferMaxParticles * _floatCountPerVertex * 4);
			
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
			_indexBuffer = IndexBuffer3D.create(IndexBuffer3D.INDEXTYPE_USHORT, _bufferMaxParticles * 6, WebGLContext.STATIC_DRAW);
			var indexes:Uint16Array = new Uint16Array(_bufferMaxParticles * 6);
			for (var i:int = 0; i < _bufferMaxParticles; i++) {
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
		private function _burst(fromTime:Number, toTime:Number):int {
			var totalEmitCount:int = 0;
			var bursts:Vector.<Burst> = _emission._bursts;
			for (var n:int = bursts.length; _burstsIndex < n; _burstsIndex++) {//TODO:_burstsIndex问题
				var burst:Burst = bursts[_burstsIndex];
				var burstTime:Number = burst.time;
				if (burstTime >= fromTime && burstTime <= toTime) {
					var emitCount:int = MathUtil.lerp(burst.minCount, burst.maxCount, Math.random());
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
		private function _advanceTime(elapsedTime:Number):void {
			if (!_isPlaying || _isPaused)
				return;
			_playbackTime += elapsedTime;
			if (_playbackTime < _playStartDelay)
				return;
			var i:int;
			var lastEmissionTime:Number = _emissionTime;
			_emissionTime += elapsedTime;
			var totalEmitCount:int = 0;
			if (_emissionTime > duration) {
				totalEmitCount += _burst(lastEmissionTime, duration);//爆裂剩余未触发的//TODO:是否可以用_playbackTime代替计算，不必结束再爆裂一次。//TODO:待确认是否累计爆裂
				if (looping) {//TODO:有while
					_emissionTime -= duration;
					this.event(Event.COMPLETE);
					_burstsIndex = 0;
					totalEmitCount += _burst(0, _emissionTime);
				} else {
					_isPlaying = false;
					
					totalEmitCount = Math.min(maxParticles - aliveParticleCount, totalEmitCount);
					for (i = 0; i < totalEmitCount; i++)
						emit();
					
					this.event(Event.STOPPED);
					return;
				}
			} else {
				totalEmitCount += _burst(lastEmissionTime, _emissionTime);
			}
			
			totalEmitCount = Math.min(maxParticles - aliveParticleCount, totalEmitCount);
			for (i = 0; i < totalEmitCount; i++)
				emit();
			
			_frameTime += elapsedTime;
			var minEmissionTime:Number = emission._minEmissionTime;
			if (_frameTime < minEmissionTime)
				return;
			while (_frameTime > minEmissionTime) {
				if (emit())//TODO:可像brust一样优化
					_frameTime -= minEmissionTime;
				else
					break;
			}
		}
		
		/**
		 * @private
		 */
		override public function _destroy():void {
			super._destroy();
			(_owner.displayedInStage && _owner.enable) && (_removeUpdateEmissionToTimer());
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
			_velocityOverLifetime = null;
			_colorOverLifetime = null;
			_sizeOverLifetime = null;
			_rotationOverLifetime = null;
			_textureSheetAnimation = null;
		}
		
		/**
		 * 发射一个粒子。
		 */
		public function emit():Boolean {
			var position:Vector3 = _tempPosition;
			var direction:Vector3 = _tempDirection;
			if (_shape.enable) {
				_shape.generatePositionAndDirection(position, direction);
			} else {
				var positionE:Float32Array = position.elements;
				var directionE:Float32Array = direction.elements;
				positionE[0] = positionE[1] = positionE[2] = 0;
				directionE[0] = directionE[1] = 0;
				directionE[2] = 1;
			}
			
			return addParticle(position, direction);//TODO:提前判断优化
		}
		
		public function addParticle(position:Vector3, direction:Vector3):Boolean {
			Vector3.normalize(direction, direction);
			var positionE:Float32Array = position.elements;
			var directionE:Float32Array = direction.elements;
			
			var nextFreeParticle:int = _firstFreeElement + 1;
			
			if (nextFreeParticle >= _bufferMaxParticles)
				nextFreeParticle = 0;
			
			if (nextFreeParticle === _firstRetiredElement)
				return false;
			
			var particleData:ShurikenParticleData = ShurikenParticleData.create(this, _owner.particleRender, positionE, directionE, _currentTime, _owner.transform);
			
			var startIndex:int = _firstFreeElement * _floatCountPerVertex * 4;
			
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
			
			var randomVelocity:Number, randomColor:Number, randomSize:Number, randomRotation:Number, randomTextureAnimation:Number;
			
			var needRandomVelocity:Boolean = _velocityOverLifetime && _velocityOverLifetime.enbale;
			if (needRandomVelocity) {
				var velocityType:int = _velocityOverLifetime.velocity.type;
				if (velocityType === 3)
					randomVelocity = Math.random();
				else
					needRandomVelocity = false;
			} else {
				needRandomVelocity = false;
			}
			var needRandomColor:Boolean = _colorOverLifetime && _colorOverLifetime.enbale;
			if (needRandomColor) {
				var colorType:int = _colorOverLifetime.color.type;
				if (colorType === 3)
					randomColor = Math.random();
				else
					needRandomColor = false;
			} else {
				needRandomColor = false;
			}
			var needRandomSize:Boolean = _sizeOverLifetime && _sizeOverLifetime.enbale;
			if (needRandomSize) {
				var sizeType:int = _sizeOverLifetime.size.type;
				if (sizeType === 3)
					randomSize = Math.random();
				else
					needRandomSize = false;
			} else {
				needRandomSize = false;
			}
			var needRandomRotation:Boolean = _rotationOverLifetime && _rotationOverLifetime.enbale;
			if (needRandomRotation) {
				var rotationType:int = _rotationOverLifetime.angularVelocity.type;
				if (rotationType === 2 || rotationType === 3)
					randomRotation = Math.random();
				else
					needRandomRotation = false;
			} else {
				needRandomRotation = false;
			}
			var needRandomTextureAnimation:Boolean = _textureSheetAnimation && _textureSheetAnimation.enbale;
			if (needRandomTextureAnimation) {
				var textureAnimationType:int = _textureSheetAnimation.frame.type;
				if (textureAnimationType === 3)
					randomTextureAnimation = Math.random();
				else
					needRandomTextureAnimation = false;
			} else {
				needRandomTextureAnimation = false;
			}
			
			for (var i:int = 0; i < 4; i++) {
				var vertexStart:int = startIndex + i * _floatCountPerVertex;
				var j:int, offset:int;
				for (j = 0, offset = 4; j < 3; j++)
					_vertices[vertexStart + offset + j] = particleData.position[j];
				_vertices[vertexStart + 7] = particleData.startLifeTime;
				
				for (j = 0, offset = 8; j < 3; j++)
					_vertices[vertexStart + offset + j] = particleData.direction[j];
				_vertices[vertexStart + 11] = particleData.time;
				
				for (j = 0, offset = 12; j < 4; j++)
					_vertices[vertexStart + offset + j] = particleData.startColor[j];
				
				for (j = 0, offset = 16; j < 3; j++)
					_vertices[vertexStart + offset + j] = particleData.startSize[j];
				
				for (j = 0, offset = 19; j < 3; j++)
					_vertices[vertexStart + offset + j] = particleData.startRotation0[j];
				
				for (j = 0, offset = 22; j < 3; j++)
					_vertices[vertexStart + offset + j] = particleData.startRotation1[j];
				
				for (j = 0, offset = 25; j < 3; j++)
					_vertices[vertexStart + offset + j] = particleData.startRotation2[j];
				
				_vertices[vertexStart + 28] = particleData.startSpeed;
				
				needRandomVelocity && (_vertices[vertexStart + 29] = randomVelocity);
				needRandomColor && (_vertices[vertexStart + 30] = randomColor);
				needRandomSize && (_vertices[vertexStart + 31] = randomSize);
				needRandomRotation && (_vertices[vertexStart + 32] = randomRotation);
				needRandomTextureAnimation && (_vertices[vertexStart + 33] = randomTextureAnimation);
				//_vertices[vertexStart + 34] = randomY1;
				//_vertices[vertexStart + 35] = randomZ1;
				//_vertices[vertexStart + 36] = randomW1;
				
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
				_vertexBuffer.setData(_vertices, start, start, (_bufferMaxParticles - _firstNewElement) * 4 * _floatCountPerVertex);
				
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
				drawVertexCount = (_bufferMaxParticles - _firstActiveElement) * 6;
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
		
		/**
		 * 开始发射粒子。
		 */
		public function play():void {
			_burstsIndex = 0;
			_isPlaying = true;
			_isPaused = false;
			_frameTime = 0;
			_emissionTime = 0;
			_playbackTime = 0;
			
			switch (startDelayType) {
			case 0: 
				_playStartDelay = startDelay;
				break;
			case 1: 
				_playStartDelay = MathUtil.lerp(startDelayMin, startDelayMax, Math.random());
				break;
			default: 
				throw new Error("Utils3D: startDelayType is invalid.");
			}
			
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
		 * 停止发射粒子。
		 */
		public function stop():void {
			_burstsIndex = 0;
			_frameTime = 0;
			
			_isPlaying = false;
			_isPaused = false;
			_emissionTime = 0;
			_playbackTime = 0;
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
			
			gravity.cloneTo(dest.gravity);
			dest.gravityModifier = gravityModifier;
			dest.simulationSpace = simulationSpace;
			dest.scaleMode = scaleMode;
			dest.playOnAwake = playOnAwake;
			//dest.autoRandomSeed = autoRandomSeed;
			
			dest.maxParticles = maxParticles;
			
			//TODO:可做更优判断
			(emission) && (dest.emission = emission.clone());
			(shape) && (dest.shape = shape.clone());
			(velocityOverLifetime) && (dest.velocityOverLifetime = velocityOverLifetime.clone());
			(colorOverLifetime) && (dest.colorOverLifetime = colorOverLifetime.clone());
			(sizeOverLifetime) && (dest.sizeOverLifetime = sizeOverLifetime.clone());
			(rotationOverLifetime) && (dest.rotationOverLifetime = rotationOverLifetime.clone());
			(textureSheetAnimation) && (dest.textureSheetAnimation = textureSheetAnimation.clone());
			//
			
			dest.isPerformanceMode = isPerformanceMode;
			
			dest._isPlaying = _isPlaying;
			dest._isPaused = _isPaused;
			dest._playStartDelay = _playStartDelay;
			dest._frameTime = _frameTime;
			dest._emissionTime = _emissionTime;
			dest._playbackTime = _playbackTime;
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
		
		public function _renderRuntime(conchGraphics3D:*, renderElement:RenderElement, state:RenderState):void//NATIVE
		{
		
		}
	}
}