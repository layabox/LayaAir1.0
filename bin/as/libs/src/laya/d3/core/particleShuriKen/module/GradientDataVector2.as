package laya.d3.core.particleShuriKen.module {
	import laya.d3.math.Vector2;
	
	/**
	 * <code>GradientDataVector2</code> 类用于创建二维向量渐变。
	 */
	public class GradientDataVector2 {
		/**@private */
		private var _currentLength:int;
		/**@private 开发者禁止修改。*/
		public var _elements:Float32Array;
		
		/**二维向量渐变数量。*/
		public function get gradientCount():int {
			return _currentLength / 3;
		}
		
		/**
		 * 创建一个 <code>GradientDataVector2</code> 实例。
		 */
		public function GradientDataVector2() {
			_elements = new Float32Array(12);
		}
		
		/**
		 * 增加二维向量渐变。
		 * @param	key 生命周期，范围为0到1。
		 * @param	value 二维向量值。
		 */
		public function add(key:Number, value:Vector2):void {
			if (_currentLength < 8) {
				_elements[_currentLength++] = key;
				_elements[_currentLength++] = value.x;
				_elements[_currentLength++] = value.y;
			} else {
				throw new Error("GradientDataVector2:  Count must less than 4.");
			}
		}
	
	}

}