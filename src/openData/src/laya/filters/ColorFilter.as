package laya.filters {
	
	import laya.utils.RunDriver;
	
	/**
	 * <p><code>ColorFilter</code> 是颜色滤镜。使用 ColorFilter 类可以将 4 x 5 矩阵转换应用于输入图像上的每个像素的 RGBA 颜色和 Alpha 值，以生成具有一组新的 RGBA 颜色和 Alpha 值的结果。该类允许饱和度更改、色相旋转、亮度转 Alpha 以及各种其他效果。您可以将滤镜应用于任何显示对象（即，从 Sprite 类继承的对象）。</p>
	 * <p>注意：对于 RGBA 值，最高有效字节代表红色通道值，其后的有效字节分别代表绿色、蓝色和 Alpha 通道值。</p>
	 */
	public class ColorFilter extends Filter implements IFilter {
		
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/**对比度列表*/
		private static const DELTA_INDEX:Array = [0, 0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1, 0.11, 0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24, 0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42, 0.44, 0.46, 0.48, 0.5, 0.53, 0.56, 0.59, 0.62, 0.65, 0.68, 0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98, 1.0, 1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54, 1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0, 2.12, 2.25, 2.37, 2.50, 2.62, 2.75, 2.87, 3.0, 3.2, 3.4, 3.6, 3.8, 4.0, 4.3, 4.7, 4.9, 5.0, 5.5, 6.0, 6.5, 6.8, 7.0, 7.3, 7.5, 7.8, 8.0, 8.4, 8.7, 9.0, 9.4, 9.6, 9.8, 10.0];
		/**灰色矩阵*/
		private static const GRAY_MATRIX:Array = [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0];
		/**单位矩阵,表示什么效果都没有*/
		private static const IDENTITY_MATRIX:Array = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
		/**标准矩阵长度*/
		private static const LENGTH:Number = 25;
		
		/** @private */
		public var _mat:Float32Array;
		/** @private */
		public var _alpha:Float32Array;
		/**当前使用的矩阵*/
		private var _matrix:Array;
		
		/**
		 * 创建一个 <code>ColorFilter</code> 实例。
		 * @param mat	（可选）由 20 个项目（排列成 4 x 5 矩阵）组成的数组，用于颜色转换。
		 */
		public function ColorFilter(mat:Array = null) {
			if (!mat) mat = _copyMatrix(IDENTITY_MATRIX);
			_mat = new Float32Array(16);
			_alpha = new Float32Array(4);
			setByMatrix(mat);
			_action = new ColorFilterAction();
			_action.data = this;
		}
		
		/**
		 * 设置为灰色滤镜
		 */
		public function gray():ColorFilter {
			return setByMatrix(GRAY_MATRIX);
		}
		
		/**
		 * 设置为变色滤镜
		 * @param red 红色增量,范围:0~255
		 * @param green 绿色增量,范围:0~255
		 * @param blue 蓝色增量,范围:0~255
		 * @param alpha alpha,范围:0~1
		 */
		public function color(red:Number = 0, green:Number = 0, blue:Number = 0, alpha:Number = 1):ColorFilter {
			return setByMatrix([1, 0, 0, 0, red, 0, 1, 0, 0, green, 0, 0, 1, 0, blue, 0, 0, 0, 1, alpha]);
		}
		
		/**
		 * 设置矩阵数据
		 * @param matrix 由 20 个项目（排列成 4 x 5 矩阵）组成的数组
		 * @return this
		 */
		public function setByMatrix(matrix:Array):ColorFilter {
			if (_matrix != matrix) _copyMatrix(matrix);
			var j:int = 0;
			var z:int = 0;
			for (var i:int = 0; i < 20; i++) {
				if (i % 5 != 4) {
					_mat[j++] = matrix[i];
				} else {
					_alpha[z++] = matrix[i];
				}
			}
			return this;
		}
		
		/**@private */
		override public function get type():int {
			return COLOR;
		}
		
		/**
		 * 调整颜色，包括亮度，对比度，饱和度和色调
		 * @param brightness 亮度,范围:-100~100
		 * @param contrast 对比度,范围:-100~100
		 * @param saturation 饱和度,范围:-100~100
		 * @param hue 色调,范围:-180~180
		 * @return this
		 */
		public function adjustColor(brightness:Number, contrast:Number, saturation:Number, hue:Number):ColorFilter {
			adjustHue(hue);
			adjustContrast(contrast);
			adjustBrightness(brightness);
			adjustSaturation(saturation);
			return this;
		}
		
		/**
		 * 调整亮度
		 * @param brightness 亮度,范围:-100~100
		 * @return this
		 */
		public function adjustBrightness(brightness:Number):ColorFilter {
			brightness = _clampValue(brightness, 100);
			if (brightness == 0 || isNaN(brightness)) return this;
			return _multiplyMatrix([1, 0, 0, 0, brightness, 0, 1, 0, 0, brightness, 0, 0, 1, 0, brightness, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
		}
		
		/**
		 * 调整对比度
		 * @param contrast 对比度,范围:-100~100
		 * @return this
		 */
		public function adjustContrast(contrast:Number):ColorFilter {
			contrast = _clampValue(contrast, 100);
			if (contrast == 0 || isNaN(contrast)) return this;
			var x:Number;
			if (contrast < 0) {
				x = 127 + contrast / 100 * 127
			} else {
				x = contrast % 1;
				if (x == 0) {
					x = DELTA_INDEX[contrast];
				} else {
					x = DELTA_INDEX[(contrast << 0)] * (1 - x) + DELTA_INDEX[(contrast << 0) + 1] * x;
				}
				x = x * 127 + 127;
			}
			var x1:Number = x / 127;
			var x2:Number = (127 - x) * 0.5;
			return _multiplyMatrix([x1, 0, 0, 0, x2, 0, x1, 0, 0, x2, 0, 0, x1, 0, x2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
		}
		
		/**
		 * 调整饱和度
		 * @param saturation 饱和度,范围:-100~100
		 * @return this
		 */
		public function adjustSaturation(saturation:Number):ColorFilter {
			saturation = _clampValue(saturation, 100);
			if (saturation == 0 || isNaN(saturation)) return this;
			var x:Number = 1 + ((saturation > 0) ? 3 * saturation / 100 : saturation / 100);
			var dx:Number = 1 - x;
			var r:Number = 0.3086 * dx;
			var g:Number = 0.6094 * dx;
			var b:Number = 0.0820 * dx;
			
			return _multiplyMatrix([r + x, g, b, 0, 0, r, g + x, b, 0, 0, r, g, b + x, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
		}
		
		/**
		 * 调整色调
		 * @param hue 色调,范围:-180~180
		 * @return this
		 */
		public function adjustHue(hue:Number):ColorFilter {
			hue = _clampValue(hue, 180) / 180 * Math.PI;
			if (hue == 0 || isNaN(hue)) return this;
			var cos:Number = Math.cos(hue);
			var sin:Number = Math.sin(hue);
			var r:Number = 0.213;
			var g:Number = 0.715;
			var b:Number = 0.072;
			return _multiplyMatrix([r + cos * (1 - r) + sin * (-r), g + cos * (-g) + sin * (-g), b + cos * (-b) + sin * (1 - b), 0, 0, r + cos * (-r) + sin * (0.143), g + cos * (1 - g) + sin * (0.140), b + cos * (-b) + sin * (-0.283), 0, 0, r + cos * (-r) + sin * (-(1 - r)), g + cos * (-g) + sin * (g), b + cos * (1 - b) + sin * (b), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1]);
		}
		
		/**
		 * 重置成单位矩阵，去除滤镜效果
		 */
		public function reset():ColorFilter {
			return setByMatrix(_copyMatrix(IDENTITY_MATRIX));
		}
		
		/**
		 * 矩阵乘法
		 * @param matrix
		 * @return this
		 */
		private function _multiplyMatrix(matrix:Array):ColorFilter {
			var col:Array = [];
			_matrix = _fixMatrix(_matrix);
			for (var i:int = 0; i < 5; i++) {
				for (var j:int = 0; j < 5; j++) {
					col[j] = _matrix[j + i * 5];
				}
				for (j = 0; j < 5; j++) {
					var val:int = 0;
					for (var k:int = 0; k < 5; k++) {
						val += matrix[j + k * 5] * col[k];
					}
					_matrix[j + i * 5] = val;
				}
			}
			return setByMatrix(_matrix);
		}
		
		/**
		 * 规范值的范围
		 * @param val 当前值
		 * @param limit 值的范围-limit~limit
		 */
		private function _clampValue(val:Number, limit:Number):Number {
			return Math.min(limit, Math.max(-limit, val));
		}
		
		/**
		 * 规范矩阵,将矩阵调整到正确的大小
		 * @param matrix 需要调整的矩阵
		 */
		private function _fixMatrix(matrix:Array = null):Array {
			if (matrix == null) return IDENTITY_MATRIX;
			if (matrix.length < LENGTH) matrix = matrix.slice(0, matrix.length).concat(IDENTITY_MATRIX.slice(matrix.length, LENGTH));
			else if (matrix.length > LENGTH) matrix = matrix.slice(0, LENGTH);
			return matrix;
		}
		
		/**
		 * 复制矩阵
		 */
		private function _copyMatrix(matrix:Array):Array {
			var len:int = LENGTH;
			if (!_matrix) _matrix = [];
			for (var i:int = 0; i < len; i++) {
				_matrix[i] = matrix[i];
			}
			return _matrix;
		}
	}
}