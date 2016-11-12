package laya.d3.core.particleShuriKen.module {
	import laya.d3.math.Vector3;
	
	/**
	 * <code>GradientRotation</code> 类用于创建渐变角速度。
	 */
	public class GradientAngularVelocity {
		/**
		 * 通过固定角速度创建一个 <code>GradientAngularVelocity</code> 实例。
		 * @param	constant 固定角速度。
		 * @return 渐变角速度。
		 */
		public static function createByConstant(constant:Number):GradientAngularVelocity {
			var rotationOverLifetime:GradientAngularVelocity = new GradientAngularVelocity();
			rotationOverLifetime._type = 0;
			rotationOverLifetime._separateAxes = false;
			rotationOverLifetime._constant = constant;
			return rotationOverLifetime;
		}
		
		/**
		 * 通过分轴固定角速度创建一个 <code>GradientAngularVelocity</code> 实例。
		 * @param	separateConstant 分轴固定角速度。
		 * @return 渐变角速度。
		 */
		public static function createByConstantSeparate(separateConstant:Vector3):GradientAngularVelocity {
			var rotationOverLifetime:GradientAngularVelocity = new GradientAngularVelocity();
			rotationOverLifetime._type = 0;
			rotationOverLifetime._separateAxes = true;
			rotationOverLifetime._constantSeparate = separateConstant;
			return rotationOverLifetime;
		}
		
		/**
		 * 通过渐变角速度创建一个 <code>GradientAngularVelocity</code> 实例。
		 * @param	gradient 渐变角速度。
		 * @return 渐变角速度。
		 */
		public static function createByGradientRotation(gradient:GradientDataNumber):GradientAngularVelocity {
			var rotationOverLifetime:GradientAngularVelocity = new GradientAngularVelocity();
			rotationOverLifetime._type = 1;
			rotationOverLifetime._separateAxes = false;
			rotationOverLifetime._gradient = gradient;
			return rotationOverLifetime;
		}
		
		/**
		 * 通过分轴渐变角速度创建一个 <code>GradientAngularVelocity</code> 实例。
		 * @param	gradientX X轴渐变角速度。
		 * @param	gradientY Y轴渐变角速度。
		 * @param	gradientZ Z轴渐变角速度。
		 * @return  渐变角速度。
		 */
		public static function createByGradientRotationSeparate(gradientX:GradientDataNumber, gradientY:GradientDataNumber, gradientZ:GradientDataNumber):GradientAngularVelocity {
			var rotationOverLifetime:GradientAngularVelocity = new GradientAngularVelocity();
			rotationOverLifetime._type = 1;
			rotationOverLifetime._separateAxes = true;
			rotationOverLifetime._gradientX = gradientX;
			rotationOverLifetime._gradientY = gradientY;
			rotationOverLifetime._gradientZ = gradientZ;
			return rotationOverLifetime;
		}
		
		/**
		 * 通过随机双固定角速度创建一个 <code>GradientAngularVelocity</code> 实例。
		 * @param	constantMin 最小固定角速度。
		 * @param	constantMax 最大固定角速度。
		 * @return 渐变角速度。
		 */
		public static function createByRandomTwoConstant(constantMin:Number, constantMax:Number):GradientAngularVelocity {
			var rotationOverLifetime:GradientAngularVelocity = new GradientAngularVelocity();
			rotationOverLifetime._type = 2;
			rotationOverLifetime._separateAxes = false;
			rotationOverLifetime._constantMin = constantMin;
			rotationOverLifetime._constantMax = constantMax;
			return rotationOverLifetime;
		}
		
		/**
		 * 通过随机分轴双固定角速度创建一个 <code>GradientAngularVelocity</code> 实例。
		 * @param	separateConstantMin  最小分轴固定角速度。
		 * @param	separateConstantMax  最大分轴固定角速度。
		 * @return  渐变角速度。
		 */
		public static function createByRandomTwoConstantSeparate(separateConstantMin:Vector3, separateConstantMax:Vector3):GradientAngularVelocity {
			var rotationOverLifetime:GradientAngularVelocity = new GradientAngularVelocity();
			rotationOverLifetime._type = 2;
			rotationOverLifetime._separateAxes = true;
			rotationOverLifetime._constantMinSeparate = separateConstantMin;
			rotationOverLifetime._constantMaxSeparate = separateConstantMax;
			return rotationOverLifetime;
		}
		
		/**
		 * 通过随机双渐变角速度创建一个 <code>GradientAngularVelocity</code> 实例。
		 * @param	gradientMin 最小渐变角速度。
		 * @param	gradientMax 最大渐变角速度。
		 * @return  渐变角速度。
		 */
		public static function createByRandomTwoGradientRotation(gradientMin:GradientDataNumber, gradientMax:GradientDataNumber):GradientAngularVelocity {
			var rotationOverLifetime:GradientAngularVelocity = new GradientAngularVelocity();
			rotationOverLifetime._type = 3;
			rotationOverLifetime._separateAxes = false;
			rotationOverLifetime._gradientMin = gradientMin;
			rotationOverLifetime._gradientMax = gradientMax;
			return rotationOverLifetime;
		}
		
		/**
		 * 通过分轴随机双渐变角速度创建一个 <code>GradientAngularVelocity</code> 实例。
		 * @param	gradientXMin  最小X轴渐变角速度。
		 * @param	gradientXMax  最大X轴渐变角速度。
		 * @param	gradientYMin  最小Y轴渐变角速度。
		 * @param	gradientYMax  最大Y轴渐变角速度。
		 * @param	gradientZMin  最小Z轴渐变角速度。
		 * @param	gradientZMax  最大Z轴渐变角速度。
		 * @return  渐变角速度。
		 */
		public static function createByRandomTwoGradientRotationSeparate(gradientXMin:GradientDataNumber, gradientXMax:GradientDataNumber, gradientYMin:GradientDataNumber, gradientYMax:GradientDataNumber, gradientZMin:GradientDataNumber, gradientZMax:GradientDataNumber):GradientAngularVelocity {
			var rotationOverLifetime:GradientAngularVelocity = new GradientAngularVelocity();
			rotationOverLifetime._type = 3;
			rotationOverLifetime._separateAxes = true;
			rotationOverLifetime._gradientXMin = gradientXMin;
			rotationOverLifetime._gradientXMax = gradientXMax;
			rotationOverLifetime._gradientYMin = gradientYMin;
			rotationOverLifetime._gradientYMax = gradientYMax;
			rotationOverLifetime._gradientZMin = gradientZMin;
			rotationOverLifetime._gradientZMax = gradientZMax;
			return rotationOverLifetime;
		}
		
		/**@private */
		private var _type:int;
		/**@private */
		private var _separateAxes:Boolean;
		
		/**@private */
		private var _constant:Number;
		/**@private */
		private var _constantSeparate:Vector3;
		
		/**@private */
		private var _gradient:GradientDataNumber;
		/**@private */
		private var _gradientX:GradientDataNumber;
		/**@private */
		private var _gradientY:GradientDataNumber;
		/**@private */
		private var _gradientZ:GradientDataNumber;
		
		/**@private */
		private var _constantMin:Number;
		/**@private */
		private var _constantMax:Number;
		/**@private */
		private var _constantMinSeparate:Vector3;
		/**@private */
		private var _constantMaxSeparate:Vector3;
		
		/**@private */
		private var _gradientMin:GradientDataNumber;
		/**@private */
		private var _gradientMax:GradientDataNumber;
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
		 *生命周期角速度类型,0常量模式，1曲线模式，2随机双常量模式，3随机双曲线模式。
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
		 * 固定角速度。
		 */
		public function get constant():Number {
			return _constant;
		}
		
		/**
		 * 分轴固定角速度。
		 */
		public function get constantSeparate():Vector3 {
			return _constantSeparate;
		}
		
		/**
		 * 渐变角速度。
		 */
		public function get gradient():GradientDataNumber {
			return _gradient;
		}
		
		/**
		 * 渐变角角速度X。
		 */
		public function get gradientX():GradientDataNumber {
			return _gradientX;
		}
		
		/**
		 * 渐变角速度Y。
		 */
		public function get gradientY():GradientDataNumber {
			return _gradientY;
		}
		
		/**
		 *渐变角速度Z。
		 */
		public function get gradientZ():GradientDataNumber {
			return _gradientZ;
		}
		
		/**
		 * 最小随机双固定角速度。
		 */
		public function get constantMin():Number {
			return _constantMin;
		}
		
		/**
		 * 最大随机双固定角速度。
		 */
		public function get constantMax():Number {
			return _constantMax;
		}
		
		/**
		 * 最小分轴随机双固定角速度。
		 */
		public function get constantMinSeparate():Vector3 {
			return _constantMinSeparate;
		}
		
		/**
		 * 最大分轴随机双固定角速度。
		 */
		public function get constantMaxSeparate():Vector3 {
			return _constantMaxSeparate;
		}
		
		/**
		 *最小渐变角速度。
		 */
		public function get gradientMin():GradientDataNumber {
			return _gradientMin;
		}
		
		/**
		 * 最大渐变角速度。
		 */
		public function get gradientMax():GradientDataNumber {
			return _gradientMax;
		}
		
		/**
		 * 最小渐变角速度X。
		 */
		public function get gradientXMin():GradientDataNumber {
			return _gradientXMin;
		}
		
		/**
		 * 最大渐变角速度X。
		 */
		public function get gradientXMax():GradientDataNumber {
			return _gradientXMax;
		}
		
		/**
		 * 最小渐变角速度Y。
		 */
		public function get gradientYMin():GradientDataNumber {
			return _gradientYMin;
		}
		
		/**
		 *最大渐变角速度Y。
		 */
		public function get gradientYMax():GradientDataNumber {
			return _gradientYMax;
		}
		
		/**
		 * 最小渐变角速度Z。
		 */
		public function get gradientZMin():GradientDataNumber {
			return _gradientZMin;
		}
		
		/**
		 * 最大渐变角速度Z。
		 */
		public function get gradientZMax():GradientDataNumber {
			return _gradientZMax;
		}
		
		/**
		 * 创建一个 <code>GradientAngularVelocity,不允许new，请使用静态创建函数。</code> 实例。
		 */
		public function GradientAngularVelocity() {
		
		}
	
	}

}