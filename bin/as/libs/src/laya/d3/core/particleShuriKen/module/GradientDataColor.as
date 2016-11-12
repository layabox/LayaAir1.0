package laya.d3.core.particleShuriKen.module {
	import laya.d3.math.Vector3;
	
	/**
	 * <code>GradientDataColor</code> 类用于创建颜色渐变。
	 */
	public class GradientDataColor {
		/**@private */
		private var _alphaCurrentLength:int;
		/**@private */
		private var _rgbCurrentLength:int;
		/**@private 开发者禁止修改。*/
		public var _alphaElements:Float32Array;
		/**@private 开发者禁止修改。*/
		public var _rgbElements:Float32Array;
		
		/**渐变Alpha数量。*/
		public function get alphaGradientCount():int {
			return _alphaCurrentLength / 2;
		}
		
		/**渐变RGB数量。*/
		public function get rgbGradientCount():int {
			return _rgbCurrentLength / 4;
		}
		
		/**
		 * 创建一个 <code>GradientDataColor</code> 实例。
		 */
		public function GradientDataColor() {
			_alphaElements = new Float32Array(8);
			_rgbElements = new Float32Array(16);
		}
		
		/**
		 * 增加Alpha渐变。
		 * @param	key 生命周期，范围为0到1。
		 * @param	value rgb值。
		 */
		public function addAlpha(key:Number, value:int):void {
			if (_alphaCurrentLength < 8) {
				_alphaElements[_alphaCurrentLength++] = key;
				_alphaElements[_alphaCurrentLength++] = value;
			} else {
				throw new Error("GradientDataColor:Alpha count must less than 4.");
			}
		}
		
		/**
		 * 增加RGB渐变。
		 * @param	key 生命周期，范围为0到1。
		 * @param	value RGB值。
		 */
		public function addRGB(key:Number, value:Vector3):void {
			if (_rgbCurrentLength < 16) {
				_rgbElements[_rgbCurrentLength++] = key;
				_rgbElements[_rgbCurrentLength++] = value.x;
				_rgbElements[_rgbCurrentLength++] = value.y;
				_rgbElements[_rgbCurrentLength++] = value.z;
			} else {
				throw new Error("GradientDataColor:RGB count must less than 4.");
			}
		}
	
	}

}