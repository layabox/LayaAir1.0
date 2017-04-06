package laya.d3.core.particleShuriKen.module {
	import laya.d3.core.IClone;
	import laya.d3.math.Vector4;
	
	/**
	 * <code>GradientColor</code> 类用于创建渐变颜色。
	 */
	public class GradientColor implements IClone {
		/**
		 * 通过固定颜色创建一个 <code>GradientColor</code> 实例。
		 * @param constant 固定颜色。
		 */
		public static function createByConstant(constant:Vector4):GradientColor {
			var gradientColor:GradientColor = new GradientColor();
			gradientColor._type = 0;
			gradientColor._constant = constant;
			return gradientColor;
		}
		
		/**
		 * 通过渐变颜色创建一个 <code>GradientColor</code> 实例。
		 * @param gradient 渐变色。
		 */
		public static function createByGradient(gradient:GradientDataColor):GradientColor {
			var gradientColor:GradientColor = new GradientColor();
			gradientColor._type = 1;
			gradientColor._gradient = gradient;
			return gradientColor;
		}
		
		/**
		 * 通过随机双固定颜色创建一个 <code>GradientColor</code> 实例。
		 * @param minConstant 最小固定颜色。
		 * @param maxConstant 最大固定颜色。
		 */
		public static function createByRandomTwoConstant(minConstant:Vector4, maxConstant:Vector4):GradientColor {
			var gradientColor:GradientColor = new GradientColor();
			gradientColor._type = 2;
			gradientColor._constantMin = minConstant;
			gradientColor._constantMax = maxConstant;
			return gradientColor;
		}
		
		/**
		 * 通过随机双渐变颜色创建一个 <code>GradientColor</code> 实例。
		 * @param minGradient 最小渐变颜色。
		 * @param maxGradient 最大渐变颜色。
		 */
		public static function createByRandomTwoGradient(minGradient:GradientDataColor, maxGradient:GradientDataColor):GradientColor {
			var gradientColor:GradientColor = new GradientColor();
			gradientColor._type = 3;
			gradientColor._gradientMin = minGradient;
			gradientColor._gradientMax = maxGradient;
			return gradientColor;
		}
		
		/**@private */
		private var _type:int;
		
		/**@private */
		private var _constant:Vector4;
		/**@private */
		private var _constantMin:Vector4;
		/**@private */
		private var _constantMax:Vector4;
		/**@private */
		private var _gradient:GradientDataColor;
		/**@private */
		private var _gradientMin:GradientDataColor;
		/**@private */
		private var _gradientMax:GradientDataColor;
		
		/**
		 *生命周期颜色类型,0为固定颜色模式,1渐变模式,2为随机双固定颜色模式,3随机双渐变模式。
		 */
		public function get type():int {
			return _type;
		}
		
		/**
		 * 固定颜色。
		 */
		public function get constant():Vector4 {
			return _constant;
		}
		
		/**
		 * 最小固定颜色。
		 */
		public function get constantMin():Vector4 {
			return _constantMin;
		}
		
		/**
		 * 最大固定颜色。
		 */
		public function get constantMax():Vector4 {
			return _constantMax;
		}
		
		/**
		 * 渐变颜色。
		 */
		public function get gradient():GradientDataColor {
			return _gradient;
		}
		
		/**
		 * 最小渐变颜色。
		 */
		public function get gradientMin():GradientDataColor {
			return _gradientMin;
		}
		
		/**
		 * 最大渐变颜色。
		 */
		public function get gradientMax():GradientDataColor {
			return _gradientMax;
		}
		
		/**
		 * 创建一个 <code>GradientColor,不允许new，请使用静态创建函数。</code> 实例。
		 */
		public function GradientColor() {
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destGradientColor:GradientColor = destObject as GradientColor;
			destGradientColor._type = _type;
			_constant.cloneTo(destGradientColor._constant);
			_constantMin.cloneTo(destGradientColor._constantMin);
			_constantMax.cloneTo(destGradientColor._constantMax);
			_gradient.cloneTo(destGradientColor._gradient);
			_gradientMin.cloneTo(destGradientColor._gradientMin);
			_gradientMax.cloneTo(destGradientColor._gradientMax);
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destGradientColor:GradientColor = __JS__("new this.constructor()");
			cloneTo(destGradientColor);
			return destGradientColor;
		}
	
	}

}