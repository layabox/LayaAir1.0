package laya.d3.core.particleShuriKen.module {
	import laya.d3.core.IClone;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	
	/**
	 * <code>GradientRotation</code> 类用于创建渐变角速度。
	 */
	public class GradientAngularVelocity implements IClone {
		/**
		 * 通过固定角速度创建一个 <code>GradientAngularVelocity</code> 实例。
		 * @param	constant 固定角速度。
		 * @return 渐变角速度。
		 */
		public static function createByConstant(constant:Number):GradientAngularVelocity {
			var gradientAngularVelocity:GradientAngularVelocity = new GradientAngularVelocity();
			gradientAngularVelocity._type = 0;
			gradientAngularVelocity._separateAxes = false;
			gradientAngularVelocity._constant = constant;
			return gradientAngularVelocity;
		}
		
		/**
		 * 通过分轴固定角速度创建一个 <code>GradientAngularVelocity</code> 实例。
		 * @param	separateConstant 分轴固定角速度。
		 * @return 渐变角速度。
		 */
		public static function createByConstantSeparate(separateConstant:Vector4):GradientAngularVelocity {
			var gradientAngularVelocity:GradientAngularVelocity = new GradientAngularVelocity();
			gradientAngularVelocity._type = 0;
			gradientAngularVelocity._separateAxes = true;
			gradientAngularVelocity._constantSeparate = separateConstant;
			return gradientAngularVelocity;
		}
		
		/**
		 * 通过渐变角速度创建一个 <code>GradientAngularVelocity</code> 实例。
		 * @param	gradient 渐变角速度。
		 * @return 渐变角速度。
		 */
		public static function createByGradient(gradient:GradientDataNumber):GradientAngularVelocity {
			var gradientAngularVelocity:GradientAngularVelocity = new GradientAngularVelocity();
			gradientAngularVelocity._type = 1;
			gradientAngularVelocity._separateAxes = false;
			gradientAngularVelocity._gradient = gradient;
			return gradientAngularVelocity;
		}
		
		/**
		 * 通过分轴渐变角速度创建一个 <code>GradientAngularVelocity</code> 实例。
		 * @param	gradientX X轴渐变角速度。
		 * @param	gradientY Y轴渐变角速度。
		 * @param	gradientZ Z轴渐变角速度。
		 * @return  渐变角速度。
		 */
		public static function createByGradientSeparate(gradientX:GradientDataNumber, gradientY:GradientDataNumber, gradientZ:GradientDataNumber, gradientW:GradientDataNumber):GradientAngularVelocity {
			var gradientAngularVelocity:GradientAngularVelocity = new GradientAngularVelocity();
			gradientAngularVelocity._type = 1;
			gradientAngularVelocity._separateAxes = true;
			gradientAngularVelocity._gradientX = gradientX;
			gradientAngularVelocity._gradientY = gradientY;
			gradientAngularVelocity._gradientZ = gradientZ;
			gradientAngularVelocity._gradientW = gradientW;
			return gradientAngularVelocity;
		}
		
		/**
		 * 通过随机双固定角速度创建一个 <code>GradientAngularVelocity</code> 实例。
		 * @param	constantMin 最小固定角速度。
		 * @param	constantMax 最大固定角速度。
		 * @return 渐变角速度。
		 */
		public static function createByRandomTwoConstant(constantMin:Number, constantMax:Number):GradientAngularVelocity {
			var gradientAngularVelocity:GradientAngularVelocity = new GradientAngularVelocity();
			gradientAngularVelocity._type = 2;
			gradientAngularVelocity._separateAxes = false;
			gradientAngularVelocity._constantMin = constantMin;
			gradientAngularVelocity._constantMax = constantMax;
			return gradientAngularVelocity;
		}
		
		/**
		 * 通过随机分轴双固定角速度创建一个 <code>GradientAngularVelocity</code> 实例。
		 * @param	separateConstantMin  最小分轴固定角速度。
		 * @param	separateConstantMax  最大分轴固定角速度。
		 * @return  渐变角速度。
		 */
		public static function createByRandomTwoConstantSeparate(separateConstantMin:Vector3, separateConstantMax:Vector3):GradientAngularVelocity {
			var gradientAngularVelocity:GradientAngularVelocity = new GradientAngularVelocity();
			gradientAngularVelocity._type = 2;
			gradientAngularVelocity._separateAxes = true;
			gradientAngularVelocity._constantMinSeparate = separateConstantMin;
			gradientAngularVelocity._constantMaxSeparate = separateConstantMax;
			return gradientAngularVelocity;
		}
		
		/**
		 * 通过随机双渐变角速度创建一个 <code>GradientAngularVelocity</code> 实例。
		 * @param	gradientMin 最小渐变角速度。
		 * @param	gradientMax 最大渐变角速度。
		 * @return  渐变角速度。
		 */
		public static function createByRandomTwoGradient(gradientMin:GradientDataNumber, gradientMax:GradientDataNumber):GradientAngularVelocity {
			var gradientAngularVelocity:GradientAngularVelocity = new GradientAngularVelocity();
			gradientAngularVelocity._type = 3;
			gradientAngularVelocity._separateAxes = false;
			gradientAngularVelocity._gradientMin = gradientMin;
			gradientAngularVelocity._gradientMax = gradientMax;
			return gradientAngularVelocity;
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
		public static function createByRandomTwoGradientSeparate(gradientXMin:GradientDataNumber, gradientXMax:GradientDataNumber, gradientYMin:GradientDataNumber, gradientYMax:GradientDataNumber, gradientZMin:GradientDataNumber, gradientZMax:GradientDataNumber, gradientWMin:GradientDataNumber, gradientWMax:GradientDataNumber):GradientAngularVelocity {
			var gradientAngularVelocity:GradientAngularVelocity = new GradientAngularVelocity();
			gradientAngularVelocity._type = 3;
			gradientAngularVelocity._separateAxes = true;
			gradientAngularVelocity._gradientXMin = gradientXMin;
			gradientAngularVelocity._gradientXMax = gradientXMax;
			gradientAngularVelocity._gradientYMin = gradientYMin;
			gradientAngularVelocity._gradientYMax = gradientYMax;
			gradientAngularVelocity._gradientZMin = gradientZMin;
			gradientAngularVelocity._gradientZMax = gradientZMax;
			gradientAngularVelocity._gradientWMin = gradientWMin;
			gradientAngularVelocity._gradientWMax = gradientWMax;
			return gradientAngularVelocity;
		}
		
		/**@private */
		private var _type:int;
		/**@private */
		private var _separateAxes:Boolean;
		
		/**@private */
		private var _constant:Number;
		/**@private */
		private var _constantSeparate:Vector4;
		
		/**@private */
		private var _gradient:GradientDataNumber;
		/**@private */
		private var _gradientX:GradientDataNumber;
		/**@private */
		private var _gradientY:GradientDataNumber;
		/**@private */
		private var _gradientZ:GradientDataNumber;
		/**@private */
		private var _gradientW:GradientDataNumber;
		
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
		/**@private */
		private var _gradientWMin:GradientDataNumber;
		/**@private */
		private var _gradientWMax:GradientDataNumber;
		
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
		public function get constantSeparate():Vector4 {
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
		 *渐变角速度Z。
		 */
		public function get gradientW():GradientDataNumber {
			return _gradientW;
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
		 * 最小渐变角速度Z。
		 */
		public function get gradientWMin():GradientDataNumber {
			return _gradientWMin;
		}
		
		/**
		 * 最大渐变角速度Z。
		 */
		public function get gradientWMax():GradientDataNumber {
			return _gradientWMax;
		}
		
		/**
		 * 创建一个 <code>GradientAngularVelocity,不允许new，请使用静态创建函数。</code> 实例。
		 */
		public function GradientAngularVelocity() {
		
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destGradientAngularVelocity:GradientAngularVelocity = destObject as GradientAngularVelocity;
			destGradientAngularVelocity._type = _type;
			destGradientAngularVelocity._separateAxes = _separateAxes;
			destGradientAngularVelocity._constant = _constant;
			_constantSeparate.cloneTo(destGradientAngularVelocity._constantSeparate);
			_gradient.cloneTo(destGradientAngularVelocity._gradient);
			_gradientX.cloneTo(destGradientAngularVelocity._gradientX);
			_gradientY.cloneTo(destGradientAngularVelocity._gradientY);
			_gradientZ.cloneTo(destGradientAngularVelocity._gradientZ);
			destGradientAngularVelocity._constantMin = _constantMin;
			destGradientAngularVelocity._constantMax = _constantMax;
			_constantMinSeparate.cloneTo(destGradientAngularVelocity._constantMinSeparate);
			_constantMaxSeparate.cloneTo(destGradientAngularVelocity._constantMaxSeparate);
			_gradientMin.cloneTo(destGradientAngularVelocity._gradientMin);
			_gradientMax.cloneTo(destGradientAngularVelocity._gradientMax);
			_gradientXMin.cloneTo(destGradientAngularVelocity._gradientXMin);
			_gradientXMax.cloneTo(destGradientAngularVelocity._gradientXMax);
			_gradientYMin.cloneTo(destGradientAngularVelocity._gradientYMin);
			_gradientYMax.cloneTo(destGradientAngularVelocity._gradientYMax);
			_gradientZMin.cloneTo(destGradientAngularVelocity._gradientZMin);
			_gradientZMax.cloneTo(destGradientAngularVelocity._gradientZMax);
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destGradientAngularVelocity:GradientAngularVelocity = __JS__("new this.constructor()");
			cloneTo(destGradientAngularVelocity);
			return destGradientAngularVelocity;
		}
	
	}

}