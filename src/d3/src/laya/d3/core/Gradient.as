package laya.d3.core {
	import laya.d3.core.IClone;
	import laya.d3.math.Color;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>Gradient</code> 类用于创建颜色渐变。
	 */
	public class Gradient implements IClone {
		/**@private */
		private var _mode:int;
		/**@private */
		private var _maxColorRGBKeysCount:int;
		/**@private */
		private var _maxColorAlphaKeysCount:int;
		/**@private */
		private var _colorRGBKeysCount:int;
		/**@private */
		private var _colorAlphaKeysCount:int;
		
		/**@private */
		public var _alphaElements:Float32Array;
		/**@private */
		public var _rgbElements:Float32Array;
		
		/**
		 * 获取梯度模式。
		 * @return  梯度模式。
		 */
		public function get mode():int {
			return _mode;
		}
		
		/**
		 * 设置梯度模式。
		 * @param value 梯度模式。
		 */
		public function set mode(value:int):void {
			_mode = value;
		}
		
		/**
		 * 获取颜色RGB数量。
		 * @return 颜色RGB数量。
		 */
		public function get colorRGBKeysCount():int {
			return _colorRGBKeysCount / 4;
		}
		
		/**
		 * 获取颜色Alpha数量。
		 * @return 颜色Alpha数量。
		 */
		public function get colorAlphaKeysCount():int {
			return _colorAlphaKeysCount / 2;
		}
		
		/**
		 * 获取最大颜色RGB帧数量。
		 * @return 最大RGB帧数量。
		 */
		public function get maxColorRGBKeysCount():int {
			return _maxColorRGBKeysCount;
		}
		
		/**
		 * 获取最大颜色Alpha帧数量。
		 * @return 最大Alpha帧数量。
		 */
		public function get maxColorAlphaKeysCount():int {
			return _maxColorAlphaKeysCount;
		}
		
		/**
		 * 创建一个 <code>Gradient</code> 实例。
		 * @param maxColorRGBKeyCount 最大RGB帧个数。
		 * @param maxColorAlphaKeyCount 最大Alpha帧个数。
		 */
		public function Gradient(maxColorRGBKeyCount:int, maxColorAlphaKeyCount:int) {
			_maxColorRGBKeysCount = maxColorRGBKeyCount;
			_maxColorAlphaKeysCount = maxColorAlphaKeyCount;
			_rgbElements = new Float32Array(maxColorRGBKeyCount * 4);
			_alphaElements = new Float32Array(maxColorAlphaKeyCount * 2);
		}
		
		/**
		 * 增加颜色RGB帧。
		 * @param	key 生命周期，范围为0到1。
		 * @param	value RGB值。
		 */
		public function addColorRGB(key:Number, value:Color):void {
			if (_colorRGBKeysCount < _maxColorRGBKeysCount) {
				var offset:int = _colorRGBKeysCount * 4;
				_rgbElements[offset] = key;
				_rgbElements[offset + 1] = value.r;
				_rgbElements[offset + 2] = value.g;
				_rgbElements[offset + 3] = value.b;
				_colorRGBKeysCount++;
			} else {
				console.warn("Gradient:warning:data count must lessEqual than " + _maxColorRGBKeysCount);
			}
		}
		
		/**
		 * 增加颜色Alpha帧。
		 * @param	key 生命周期，范围为0到1。
		 * @param	value Alpha值。
		 */
		public function addColorAlpha(key:Number, value:int):void {
			if (_colorAlphaKeysCount < _maxColorAlphaKeysCount) {
				var offset:int = _colorAlphaKeysCount * 2;
				_alphaElements[offset] = key;
				_alphaElements[offset + 1] = value;
				_colorAlphaKeysCount++;
			} else {
				console.warn("Gradient:warning:data count must lessEqual than " + _maxColorAlphaKeysCount);
			}
		}
		
		/**
		 * 更新颜色RGB帧。
		 * @param   index 索引。
		 * @param	key 生命周期，范围为0到1。
		 * @param	value RGB值。
		 */
		public function updateColorRGB(index:int, key:Number, value:Color):void {//TODO:以key为键自动排序
			if (index < _colorRGBKeysCount) {
				var offset:int = index * 4;
				_rgbElements[offset] = key;
				_rgbElements[offset + 1] = value.r;
				_rgbElements[offset + 2] = value.g;
				_rgbElements[offset + 3] = value.b;
			} else {
				console.warn("Gradient:warning:index must lessEqual than colorRGBKeysCount:" + _colorRGBKeysCount);
			}
		}
		
		/**
		 * 更新颜色Alpha帧。
		 * @param   index 索引。
		 * @param	key 生命周期，范围为0到1。
		 * @param	value Alpha值。
		 */
		public function updateColorAlpha(index:int, key:Number, value:int):void {
			if (index < _colorAlphaKeysCount) {
				var offset:int = index * 2;
				_alphaElements[offset] = key;
				_alphaElements[offset + 1] = value;
			} else {
				console.warn("Gradient:warning:index must lessEqual than colorAlphaKeysCount:" + _colorAlphaKeysCount);
			}
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destGradientDataColor:Gradient = destObject as Gradient;
			var i:int, n:int;
			destGradientDataColor._colorAlphaKeysCount = _colorAlphaKeysCount;
			var destAlphaElements:Float32Array = destGradientDataColor._alphaElements;
			destAlphaElements.length = _alphaElements.length;
			for (i = 0, n = _alphaElements.length; i < n; i++)
				destAlphaElements[i] = _alphaElements[i];
			
			destGradientDataColor._colorRGBKeysCount = _colorRGBKeysCount;
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
			var destGradientDataColor:Gradient = new Gradient(_maxColorRGBKeysCount, _maxColorAlphaKeysCount);
			cloneTo(destGradientDataColor);
			return destGradientDataColor;
		}
	
	}

}