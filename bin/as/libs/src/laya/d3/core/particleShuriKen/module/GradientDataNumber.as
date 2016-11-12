package laya.d3.core.particleShuriKen.module {
	
	/**
	 * <code>GradientDataNumber</code> 类用于创建浮点渐变。
	 */
	public class GradientDataNumber {
		/**@private */
		private var _currentLength:int;
		/**@private 开发者禁止修改。*/
		public var _elements:Float32Array;
		
		/**渐变浮点数量。*/
		public function get gradientCount():int {
			return _currentLength / 2;
		}
		
		/**
		 * 创建一个 <code>GradientDataNumber</code> 实例。
		 */
		public function GradientDataNumber() {
			_elements = new Float32Array(8);
		}
		
		/**
		 * 增加浮点渐变。
		 * @param	key 生命周期，范围为0到1。
		 * @param	value 浮点值。
		 */
		public function add(key:Number, value:Number):void {
			if (_currentLength < 8) {
				_elements[_currentLength++] = key;
				_elements[_currentLength++] = value;
			} else {
				throw new Error("GradientDataNumber: Count must less than 4.");
			}
		}
	
	}

}