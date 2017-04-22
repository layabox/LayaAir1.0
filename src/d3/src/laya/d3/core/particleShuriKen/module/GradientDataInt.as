package laya.d3.core.particleShuriKen.module {
	import laya.d3.core.IClone;
	
	/**
	 * <code>GradientDataInt</code> 类用于创建整形渐变。
	 */
	public class GradientDataInt implements IClone {
		/**@private */
		private var _currentLength:int;
		/**@private 开发者禁止修改。*/
		public var _elements:Float32Array;//TODO:是否用int
		
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
				if ((_currentLength === 6) && ((key !== 1))) {
					key = 1;
					console.log("Warning:the forth key is  be force set to 1.");
				}
				
				_elements[_currentLength++] = key;
				_elements[_currentLength++] = value;
			} else {
				console.log("Warning:data count must lessEqual than 4");
			}
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destGradientDataInt:GradientDataInt = destObject as GradientDataInt;
			destGradientDataInt._currentLength = _currentLength;
			var destElements:Float32Array = destGradientDataInt._elements;
			destElements.length = _elements.length;
			for (var i:int = 0, n:int = _elements.length; i < n; i++) {
				destElements[i] = _elements[i];
			}
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destGradientDataInt:GradientDataInt = __JS__("new this.constructor()");
			cloneTo(destGradientDataInt);
			return destGradientDataInt;
		}
	
	}

}