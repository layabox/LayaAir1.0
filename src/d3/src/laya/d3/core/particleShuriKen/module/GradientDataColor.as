package laya.d3.core.particleShuriKen.module {
	import laya.d3.core.IClone;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>GradientDataColor</code> 类用于创建颜色渐变。
	 */
	public class GradientDataColor implements IClone {
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
				if ((_alphaCurrentLength === 6) && ((key !== 1))) {
					key = 1;
					console.log("GradientDataColor warning:the forth key is  be force set to 1.");
				}
				
				_alphaElements[_alphaCurrentLength++] = key;
				_alphaElements[_alphaCurrentLength++] = value;
			} else {
				console.log("GradientDataColor warning:data count must lessEqual than 4");
			}
		}
		
		/**
		 * 增加RGB渐变。
		 * @param	key 生命周期，范围为0到1。
		 * @param	value RGB值。
		 */
		public function addRGB(key:Number, value:Vector3):void {
			if (_rgbCurrentLength < 16) {
				
				if ((_rgbCurrentLength === 12) && ((key !== 1))) {
					key = 1;
					console.log("GradientDataColor warning:the forth key is  be force set to 1.");
				}
				
				_rgbElements[_rgbCurrentLength++] = key;
				_rgbElements[_rgbCurrentLength++] = value.x;
				_rgbElements[_rgbCurrentLength++] = value.y;
				_rgbElements[_rgbCurrentLength++] = value.z;
			} else {
				console.log("GradientDataColor warning:data count must lessEqual than 4");
			}
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destGradientDataColor:GradientDataColor = destObject as GradientDataColor;
			var i:int, n:int;
			destGradientDataColor._alphaCurrentLength = _alphaCurrentLength;
			var destAlphaElements:Float32Array = destGradientDataColor._alphaElements;
			destAlphaElements.length = _alphaElements.length;
			for (i = 0, n = _alphaElements.length; i < n; i++)
				destAlphaElements[i] = _alphaElements[i];
			
			destGradientDataColor._rgbCurrentLength = _rgbCurrentLength;
			var destRGBElements:Float32Array = destGradientDataColor._rgbElements;
			destRGBElements.length = _rgbElements.length;
			for (i = 0, n = _rgbElements.length; i < n; i++)
				destRGBElements[i] = _rgbElements[i];
		
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destGradientDataColor:GradientDataColor = __JS__("new this.constructor()");
			cloneTo(destGradientDataColor);
			return destGradientDataColor;
		}
	
	}

}