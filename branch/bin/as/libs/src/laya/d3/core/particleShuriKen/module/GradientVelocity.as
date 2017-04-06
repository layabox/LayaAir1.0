package laya.d3.core.particleShuriKen.module {
	import laya.d3.core.IClone;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>GradientVelocity</code> 类用于创建渐变速度。
	 */
	public class GradientVelocity implements IClone {
		/**
		 * 通过固定速度创建一个 <code>GradientVelocity</code> 实例。
		 * @param	constant 固定速度。
		 * @return 渐变速度。
		 */
		public static function createByConstant(constant:Vector3):GradientVelocity {
			var gradientVelocity:GradientVelocity = new GradientVelocity();
			gradientVelocity._type = 0;
			gradientVelocity._constant = constant;
			return gradientVelocity;
		}
		
		/**
		 * 通过渐变速度创建一个 <code>GradientVelocity</code> 实例。
		 * @param	gradientX 渐变速度X。
		 * @param	gradientY 渐变速度Y。
		 * @param	gradientZ 渐变速度Z。
		 * @return  渐变速度。
		 */
		public static function createByGradient(gradientX:GradientDataNumber, gradientY:GradientDataNumber, gradientZ:GradientDataNumber):GradientVelocity {
			var gradientVelocity:GradientVelocity = new GradientVelocity();
			gradientVelocity._type = 1;
			gradientVelocity._gradientX = gradientX;
			gradientVelocity._gradientY = gradientY;
			gradientVelocity._gradientZ = gradientZ;
			return gradientVelocity;
		}
		
		/**
		 * 通过随机双固定速度创建一个 <code>GradientVelocity</code> 实例。
		 * @param	constantMin 最小固定角速度。
		 * @param	constantMax 最大固定角速度。
		 * @return 渐变速度。
		 */
		public static function createByRandomTwoConstant(constantMin:Vector3, constantMax:Vector3):GradientVelocity {
			var gradientVelocity:GradientVelocity = new GradientVelocity();
			gradientVelocity._type = 2;
			gradientVelocity._constantMin = constantMin;
			gradientVelocity._constantMax = constantMax;
			return gradientVelocity;
		}
		
		/**
		 * 通过随机双渐变速度创建一个 <code>GradientVelocity</code> 实例。
		 * @param	gradientXMin X轴最小渐变速度。
		 * @param	gradientXMax X轴最大渐变速度。
		 * @param	gradientYMin Y轴最小渐变速度。
		 * @param	gradientYMax Y轴最大渐变速度。
		 * @param	gradientZMin Z轴最小渐变速度。
		 * @param	gradientZMax Z轴最大渐变速度。
		 * @return  渐变速度。
		 */
		public static function createByRandomTwoGradient(gradientXMin:GradientDataNumber, gradientXMax:GradientDataNumber, gradientYMin:GradientDataNumber, gradientYMax:GradientDataNumber, gradientZMin:GradientDataNumber, gradientZMax:GradientDataNumber):GradientVelocity {
			var gradientVelocity:GradientVelocity = new GradientVelocity();
			gradientVelocity._type = 3;
			gradientVelocity._gradientXMin = gradientXMin;
			gradientVelocity._gradientXMax = gradientXMax;
			gradientVelocity._gradientYMin = gradientYMin;
			gradientVelocity._gradientYMax = gradientYMax;
			gradientVelocity._gradientZMin = gradientZMin;
			gradientVelocity._gradientZMax = gradientZMax;
			return gradientVelocity;
		}
		
		/**@private */
		private var _type:int;
		/**@private */
		private var _constant:Vector3;
		
		/**@private */
		private var _gradientX:GradientDataNumber;
		/**@private */
		private var _gradientY:GradientDataNumber;
		/**@private */
		private var _gradientZ:GradientDataNumber;
		
		/**@private */
		private var _constantMin:Vector3;
		/**@private */
		private var _constantMax:Vector3;
		
		/**@private */
		private var _gradientXMin:GradientDataNumber;
		/**@private */
		private var _gradientXMax:GradientDataNumber;
		/**@private */
		private var _gradientYMin:GradientDataNumber;
		/**@private */
		private var _gradientYMax:GradientDataNumber;
		/**@private */
		private var _gradientZMin:GradientDataNumber;
		/**@private */
		private var _gradientZMax:GradientDataNumber;
		
		/**
		 *生命周期速度类型，0常量模式，1曲线模式，2随机双常量模式，3随机双曲线模式。
		 */
		public function get type():int {
			return _type;
		}
		
		/**固定速度。*/
		public function get constant():Vector3 {
			return _constant;
		}
		
		/**
		 * 渐变速度X。
		 */
		public function get gradientX():GradientDataNumber {
			return _gradientX;
		}
		
		/**
		 * 渐变速度Y。
		 */
		public function get gradientY():GradientDataNumber {
			return _gradientY;
		}
		
		/**
		 *渐变速度Z。
		 */
		public function get gradientZ():GradientDataNumber {
			return _gradientZ;
		}
		
		/**最小固定速度。*/
		public function get constantMin():Vector3 {
			return _constantMin;
		}
		
		/**最大固定速度。*/
		public function get constantMax():Vector3 {
			return _constantMax;
		}
		
		/**
		 * 渐变最小速度X。
		 */
		public function get gradientXMin():GradientDataNumber {
			return _gradientXMin;
		}
		
		/**
		 * 渐变最大速度X。
		 */
		public function get gradientXMax():GradientDataNumber {
			return _gradientXMax;
		}
		
		/**
		 * 渐变最小速度Y。
		 */
		public function get gradientYMin():GradientDataNumber {
			return _gradientYMin;
		}
		
		/**
		 *渐变最大速度Y。
		 */
		public function get gradientYMax():GradientDataNumber {
			return _gradientYMax;
		}
		
		/**
		 * 渐变最小速度Z。
		 */
		public function get gradientZMin():GradientDataNumber {
			return _gradientZMin;
		}
		
		/**
		 * 渐变最大速度Z。
		 */
		public function get gradientZMax():GradientDataNumber {
			return _gradientZMax;
		}
		
		/**
		 * 创建一个 <code>GradientVelocity,不允许new，请使用静态创建函数。</code> 实例。
		 */
		public function GradientVelocity() {
		
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destGradientVelocity:GradientVelocity = destObject as GradientVelocity;
			destGradientVelocity._type = _type;
			_constant.cloneTo(destGradientVelocity._constant);
			_gradientX.cloneTo(destGradientVelocity._gradientX);
			_gradientY.cloneTo(destGradientVelocity._gradientY);
			_gradientZ.cloneTo(destGradientVelocity._gradientZ);
			_constantMin.cloneTo(destGradientVelocity._constantMin);
			_constantMax.cloneTo(destGradientVelocity._constantMax);
			_gradientXMin.cloneTo(destGradientVelocity._gradientXMin);
			_gradientXMax.cloneTo(destGradientVelocity._gradientXMax);
			_gradientYMin.cloneTo(destGradientVelocity._gradientYMin);
			_gradientYMax.cloneTo(destGradientVelocity._gradientYMax);
			_gradientZMin.cloneTo(destGradientVelocity._gradientZMin);
			_gradientZMax.cloneTo(destGradientVelocity._gradientZMax);
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destGradientVelocity:GradientVelocity = __JS__("new this.constructor()");
			cloneTo(destGradientVelocity);
			return destGradientVelocity;
		}
	
	}

}