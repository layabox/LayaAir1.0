package laya.d3.core.particleShuriKen.module {
	import laya.d3.math.Vector3;
	
	/**
	 * <code>GradientSize</code> 类用于创建渐变尺寸。
	 */
	public class GradientSize {
		/**
		 * 通过渐变尺寸创建一个 <code>GradientSize</code> 实例。
		 * @param	gradient 渐变尺寸。
		 * @return  渐变尺寸。
		 */
		public static function createByGradientSize(gradient:GradientDataNumber):GradientSize {
			var sizeOverLifetime:GradientSize = new GradientSize();
			sizeOverLifetime._type = 0;
			sizeOverLifetime._separateAxes = false;
			sizeOverLifetime._gradientSize = gradient;
			return sizeOverLifetime;
		}
		
		/**
		 * 通过分轴渐变尺寸创建一个 <code>GradientSize</code> 实例。
		 * @param	gradientX 渐变尺寸X。
		 * @param	gradientY 渐变尺寸Y。
		 * @param	gradientZ 渐变尺寸Z。
		 * @return  渐变尺寸。
		 */
		public static function createByGradientSizeSeparate(gradientX:GradientDataNumber, gradientY:GradientDataNumber, gradientZ:GradientDataNumber):GradientSize {
			var sizeOverLifetime:GradientSize = new GradientSize();
			sizeOverLifetime._type = 0;
			sizeOverLifetime._separateAxes = true;
			sizeOverLifetime._gradientSizeX = gradientX;
			sizeOverLifetime._gradientSizeY = gradientY;
			sizeOverLifetime._gradientSizeZ = gradientZ;
			return sizeOverLifetime;
		}
		
		/**
		 * 通过随机双固定尺寸创建一个 <code>GradientSize</code> 实例。
		 * @param	constantMin 最小固定尺寸。
		 * @param	constantMax 最大固定尺寸。
		 * @return 渐变尺寸。
		 */
		public static function createByRandomTwoConstant(constantMin:Number, constantMax:Number):GradientSize {
			var sizeOverLifetime:GradientSize = new GradientSize();
			sizeOverLifetime._type = 1;
			sizeOverLifetime._separateAxes = false;
			sizeOverLifetime._constantMin = constantMin;
			sizeOverLifetime._constantMax = constantMax;
			return sizeOverLifetime;
		}
		
		/**
		 * 通过分轴随机双固定尺寸创建一个 <code>GradientSize</code> 实例。
		 * @param	constantMinSeparate 分轴最小固定尺寸.
		 * @param	constantMaxSeparate 分轴最大固定尺寸。
		 * @return   渐变尺寸。
		 */
		public static function createByRandomTwoConstantSeparate(constantMinSeparate:Vector3, constantMaxSeparate:Vector3):GradientSize {
			var sizeOverLifetime:GradientSize = new GradientSize();
			sizeOverLifetime._type = 1;
			sizeOverLifetime._separateAxes = true;
			sizeOverLifetime._constantMinSeparate = constantMinSeparate;
			sizeOverLifetime._constantMaxSeparate = constantMaxSeparate;
			return sizeOverLifetime;
		}
		
		/**
		 * 通过随机双渐变尺寸创建一个 <code>GradientSize</code> 实例。
		 * @param	gradientMin 最小渐变尺寸。
		 * @param	gradientMax 最大渐变尺寸。
		 * @return 渐变尺寸。
		 */
		public static function createByRandomTwoGradientSize(gradientMin:GradientDataNumber, gradientMax:GradientDataNumber):GradientSize {
			var sizeOverLifetime:GradientSize = new GradientSize();
			sizeOverLifetime._type = 2;
			sizeOverLifetime._separateAxes = false;
			sizeOverLifetime._gradientSizeMin = gradientMin;
			sizeOverLifetime._gradientSizeMax = gradientMax;
			return sizeOverLifetime;
		}
		
		/**
		 * 通过分轴随机双渐变尺寸创建一个 <code>GradientSize</code> 实例。
		 * @param	gradientXMin X轴最小渐变尺寸。
		 * @param	gradientXMax X轴最大渐变尺寸。
		 * @param	gradientYMin Y轴最小渐变尺寸。
		 * @param	gradientYMax Y轴最大渐变尺寸。
		 * @param	gradientZMin Z轴最小渐变尺寸。
		 * @param	gradientZMax Z轴最大渐变尺寸。
		 * @return  渐变尺寸。
		 */
		public static function createByRandomTwoGradientSizeSeparate(gradientXMin:GradientDataNumber, gradientXMax:GradientDataNumber, gradientYMin:GradientDataNumber, gradientYMax:GradientDataNumber, gradientZMin:GradientDataNumber, gradientZMax:GradientDataNumber):GradientSize {
			var sizeOverLifetime:GradientSize = new GradientSize();
			sizeOverLifetime._type = 2;
			sizeOverLifetime._separateAxes = true;
			sizeOverLifetime._gradientSizeXMin = gradientXMin;
			sizeOverLifetime._gradientSizeXMax = gradientXMax;
			sizeOverLifetime._gradientSizeYMin = gradientYMin;
			sizeOverLifetime._gradientSizeYMax = gradientYMax;
			sizeOverLifetime._gradientSizeZMin = gradientZMin;
			sizeOverLifetime._gradientSizeZMax = gradientZMax;
			return sizeOverLifetime;
		}
		
		/**@private */
		private var _type:int;
		/**@private */
		private var _separateAxes:Boolean;
		
		/**@private */
		private var _gradientSize:GradientDataNumber;
		/**@private */
		private var _gradientSizeX:GradientDataNumber;
		/**@private */
		private var _gradientSizeY:GradientDataNumber;
		/**@private */
		private var _gradientSizeZ:GradientDataNumber;
		
		/**@private */
		private var _constantMin:Number;
		/**@private */
		private var _constantMax:Number;
		/**@private */
		private var _constantMinSeparate:Vector3;
		/**@private */
		private var _constantMaxSeparate:Vector3;
		
		/**@private */
		private var _gradientSizeMin:GradientDataNumber;
		/**@private */
		private var _gradientSizeMax:GradientDataNumber;
		/**@private */
		private var _gradientSizeXMin:GradientDataNumber;
		/**@private */
		private var _gradientSizeXMax:GradientDataNumber;
		/**@private */
		private var _gradientSizeYMin:GradientDataNumber;
		/**@private */
		private var _gradientSizeYMax:GradientDataNumber;
		/**@private */
		private var _gradientSizeZMin:GradientDataNumber;
		/**@private */
		private var _gradientSizeZMax:GradientDataNumber;
		
		/**
		 *生命周期尺寸类型，0曲线模式，1随机双常量模式，2随机双曲线模式。
		 */
		public function get type():int {
			return _type;
		}
		
		/**
		 *是否分轴。
		 */
		public function get separateAxes():Boolean {
			return _separateAxes;
		}
		
		/**
		 * 渐变尺寸。
		 */
		public function get gradientSize():GradientDataNumber {
			return _gradientSize;
		}
		
		/**
		 * 渐变尺寸X。
		 */
		public function get gradientSizeX():GradientDataNumber {
			return _gradientSizeX;
		}
		
		/**
		 * 渐变尺寸Y。
		 */
		public function get gradientSizeY():GradientDataNumber {
			return _gradientSizeY;
		}
		
		/**
		 *渐变尺寸Z。
		 */
		public function get gradientSizeZ():GradientDataNumber {
			return _gradientSizeZ;
		}
		
		/**
		 *最小随机双固定尺寸。
		 */
		public function get constantMin():Number {
			return _constantMin;
		}
		
		/**
		 * 最大随机双固定尺寸。
		 */
		public function get constantMax():Number {
			return _constantMax;
		}
		
		/**
		 * 最小分轴随机双固定尺寸。
		 */
		public function get constantMinSeparate():Vector3 {
			return _constantMinSeparate;
		}
		
		/**
		 *  最小分轴随机双固定尺寸。
		 */
		public function get constantMaxSeparate():Vector3 {
			return _constantMaxSeparate;
		}
		
		/**
		 *渐变最小尺寸。
		 */
		public function get gradientSizeMin():GradientDataNumber {
			return _gradientSizeMin;
		}
		
		/**
		 * 渐变最大尺寸。
		 */
		public function get gradientSizeMax():GradientDataNumber {
			return _gradientSizeMax;
		}
		
		/**
		 * 渐变最小尺寸X。
		 */
		public function get gradientSizeXMin():GradientDataNumber {
			return _gradientSizeXMin;
		}
		
		/**
		 * 渐变最大尺寸X。
		 */
		public function get gradientSizeXMax():GradientDataNumber {
			return _gradientSizeXMax;
		}
		
		/**
		 * 渐变最小尺寸Y。
		 */
		public function get gradientSizeYMin():GradientDataNumber {
			return _gradientSizeYMin;
		}
		
		/**
		 *渐变最大尺寸Y。
		 */
		public function get gradientSizeYMax():GradientDataNumber {
			return _gradientSizeYMax;
		}
		
		/**
		 * 渐变最小尺寸Z。
		 */
		public function get gradientSizeZMin():GradientDataNumber {
			return _gradientSizeZMin;
		}
		
		/**
		 * 渐变最大尺寸Z。
		 */
		public function get gradientSizeZMax():GradientDataNumber {
			return _gradientSizeZMax;
		}
		
		/**
		 * 创建一个 <code>GradientSize,不允许new，请使用静态创建函数。</code> 实例。
		 */
		public function GradientSize() {
		
		}
	
	}

}