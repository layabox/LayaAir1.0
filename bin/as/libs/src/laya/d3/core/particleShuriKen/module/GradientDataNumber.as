package laya.d3.core.particleShuriKen.module {
	import laya.d3.core.IClone;
	
	/**
	 * <code>GradientDataNumber</code> 类用于创建浮点渐变。
	 */
	public class GradientDataNumber implements IClone {
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
				
				if ((_currentLength === 6) && ((key !== 1))) {
					key = 1;
					console.log("GradientDataNumber warning:the forth key is  be force set to 1.");
				}
				
				_elements[_currentLength++] = key;
				_elements[_currentLength++] = value;
			} else {
				console.log("GradientDataNumber warning:data count must lessEqual than 4");
			}
		}
		
		/**
		 * 通过索引获取键。
		 * @param	index 索引。
		 * @return	value 键。
		 */
		public function getKeyByIndex(index:int):Number {
			return _elements[index * 2];
		}
		
		/**
		 * 通过索引获取值。
		 * @param	index 索引。
		 * @return	value 值。
		 */
		public function getValueByIndex(index:int):Number {
			return _elements[index * 2 + 1];
		}
		
		/**
		 * 获取平均值。
		 */
		public function getAverageValue():Number {
			var total:Number = 0;
			for (var i:int = 0, n:int = _currentLength - 2; i < n; i += 2) {
				var subValue:Number = _elements[i + 1];
				subValue += _elements[i + 3];
				subValue = subValue * (_elements[i + 2] - _elements[i]);
			}
			return total / 2;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destGradientDataNumber:GradientDataNumber = destObject as GradientDataNumber;
			destGradientDataNumber._currentLength = _currentLength;
			var destElements:Float32Array = destGradientDataNumber._elements;
			destElements.length = _elements.length;
			for (var i:int = 0, n:int = _elements.length; i < n; i++)
				destElements[i] = _elements[i];
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destGradientDataNumber:GradientDataNumber = __JS__("new this.constructor()");
			cloneTo(destGradientDataNumber);
			return destGradientDataNumber;
		}
	
	}

}