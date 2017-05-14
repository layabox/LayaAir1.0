package laya.d3.core.particleShuriKen.module {
	import laya.d3.core.IClone;
	import laya.d3.math.Vector2;
	
	/**
	 * <code>GradientDataVector2</code> 类用于创建二维向量渐变。
	 */
	public class GradientDataVector2 implements IClone {
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
				
				if ((_currentLength === 6) && ((key !== 1))) {
					key = 1;
					console.log("GradientDataVector2 warning:the forth key is  be force set to 1.");
				}
				
				_elements[_currentLength++] = key;
				_elements[_currentLength++] = value.x;
				_elements[_currentLength++] = value.y;
			} else {
				console.log("GradientDataVector2 warning:data count must lessEqual than 4");
			}
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destGradientDataVector2:GradientDataVector2 = destObject as GradientDataVector2;
			destGradientDataVector2._currentLength = _currentLength;
			var destElements:Float32Array = destGradientDataVector2._elements;
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
			var destGradientDataVector2:GradientDataVector2 = __JS__("new this.constructor()");
			cloneTo(destGradientDataVector2);
			return destGradientDataVector2;
		}
	
	}

}