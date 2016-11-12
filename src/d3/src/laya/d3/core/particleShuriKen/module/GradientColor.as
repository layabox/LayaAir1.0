package laya.d3.core.particleShuriKen.module {
	import laya.d3.math.Vector4;
	
	/**
	 * <code>GradientColor</code> 类用于创建渐变颜色。
	 */
	public class GradientColor {
		/**
		 * 通过固定颜色创建一个 <code>GradientColor</code> 实例。
		 * @param constant 固定颜色。
		 */
		public static function createByConstantColor(constant:Vector4):GradientColor {
			var gradientColor:GradientColor = new GradientColor();
			gradientColor._type = 0;
			gradientColor._constantColor = constant;
			return gradientColor;
		}
		
		/**
		 * 通过渐变颜色创建一个 <code>GradientColor</code> 实例。
		 * @param gradient 渐变色。
		 */
		public static function createByGradientColor(gradient:GradientDataColor):GradientColor {
			var gradientColor:GradientColor = new GradientColor();
			gradientColor._type = 1;
			gradientColor._gradientColor = gradient;
			return gradientColor;
		}
		
		/**
		 * 通过随机双固定颜色创建一个 <code>GradientColor</code> 实例。
		 * @param minConstant 最小固定颜色。
		 * @param maxConstant 最大固定颜色。
		 */
		public static function createByRandomTwoConstantColor(minConstant:Vector4, maxConstant:Vector4):GradientColor {
			var gradientColor:GradientColor = new GradientColor();
			gradientColor._type = 2;
			gradientColor._minConstantColor = minConstant;
			gradientColor._maxConstantColor = maxConstant;
			return gradientColor;
		}
		
		/**
		 * 通过随机双渐变颜色创建一个 <code>GradientColor</code> 实例。
		 * @param minGradient 最小渐变颜色。
		 * @param maxGradient 最大渐变颜色。
		 */
		public static function createByRandomTwoGradientColor(minGradient:GradientDataColor, maxGradient:GradientDataColor):GradientColor {
			var gradientColor:GradientColor = new GradientColor();
			gradientColor._type = 3;
			gradientColor._minGradientColor = minGradient;
			gradientColor._maxGradientColor = maxGradient;
			return gradientColor;
		}
		
		/**@private */
		private var _type:int;
		
		/**@private */
		private var _constantColor:Vector4;
		/**@private */
		private var _minConstantColor:Vector4;
		/**@private */
		private var _maxConstantColor:Vector4;
		/**@private */
		private var _gradientColor:GradientDataColor;
		/**@private */
		private var _minGradientColor:GradientDataColor;
		/**@private */
		private var _maxGradientColor:GradientDataColor;
		
		/**
		 *生命周期颜色类型,0为固定颜色模式,1渐变模式,2为随机双固定颜色模式,3随机双渐变模式。
		 */
		public function get type():int {
			return _type;
		}
		
		/**
		 * 固定颜色。
		 */
		public function get constantColor():Vector4 {
			return _constantColor;
		}
		
		/**
		 * 最小固定颜色。
		 */
		public function get minConstantColor():Vector4 {
			return _minConstantColor;
		}
		
		/**
		 * 最大固定颜色。
		 */
		public function get maxConstantColor():Vector4 {
			return _maxConstantColor;
		}
		
		/**
		 * 渐变颜色。
		 */
		public function get gradientColor():GradientDataColor {
			return _gradientColor;
		}
		
		/**
		 * 最小渐变颜色。
		 */
		public function get minGradientColor():GradientDataColor {
			return _minGradientColor;
		}
		
		/**
		 * 最大渐变颜色。
		 */
		public function get maxGradientColor():GradientDataColor {
			return _maxGradientColor;
		}
		
		/**
		 * 创建一个 <code>GradientColor,不允许new，请使用静态创建函数。</code> 实例。
		 */
		public function GradientColor() {
		}
	
	}

}