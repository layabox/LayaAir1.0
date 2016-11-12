package laya.d3.core.particleShuriKen.module {
	
	/**
	 * <code>GradientDataInt</code> 类用于创建整形渐变。
	 */
	public class GradientDataInt {
		/**@private */
		private var _currentLength:int;
		/**@private 开发者禁止修改。*/
		public var _elements:Float32Array;
		
		/**整形渐变数量。*/
		public function get gradientCount():int {
			return _currentLength / 2;
		}
		
		/**
		 * 创建一个 <code>GradientDataInt</code> 实例。
		 */
		public function GradientDataInt() {
			_elements = new Float32Array(8);
		}
		
		/**
		 * 增加整形渐变。
		 * @param	key 生命周期，范围为0到1。
		 * @param	value 整形值。
		 */
		public function add(key:Number, value:int):void {
			if (_currentLength < 8) {
				_elements[_currentLength++] = key;
				_elements[_currentLength++] = value;
			} else {
				throw new Error("GradientDataInt:  Count must less than 4.");
			}
		}
	
	}

}