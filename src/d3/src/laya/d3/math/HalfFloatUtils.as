package laya.d3.math {
	
	/**
	 * <code>HalfFloatUtils</code> 类用于创建HalfFloat工具。
	 */
	public class HalfFloatUtils {
		/**@private */
		private static const _buffer:ArrayBuffer = new ArrayBuffer(4);
		/**@private */
		private static const _floatView:Float32Array = new Float32Array(_buffer);
		/**@private */
		private static const _uint32View:Uint32Array = new Uint32Array(_buffer);
		
		/**@private */
		private static const _baseTable:Uint32Array = new Uint32Array(512);
		/**@private */
		private static const _shiftTable:Uint32Array = new Uint32Array(512);
		
		/**@private */
		private static const _mantissaTable:Uint32Array = new Uint32Array(2048);
		/**@private */
		private static const _exponentTable:Uint32Array = new Uint32Array(64);
		/**@private */
		private static const _offsetTable:Uint32Array = new Uint32Array(64);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			for (var i:int = 0; i < 256; ++i) {
				var e:int = i - 127;
				// very small number (0, -0)
				if (e < -27) {
					_baseTable[i | 0x000] = 0x0000;
					_baseTable[i | 0x100] = 0x8000;
					_shiftTable[i | 0x000] = 24;
					_shiftTable[i | 0x100] = 24;
					
						// small number (denorm)
				} else if (e < -14) {
					_baseTable[i | 0x000] = 0x0400 >> (-e - 14);
					_baseTable[i | 0x100] = (0x0400 >> (-e - 14)) | 0x8000;
					_shiftTable[i | 0x000] = -e - 1;
					_shiftTable[i | 0x100] = -e - 1;
					
						// normal number
				} else if (e <= 15) {
					_baseTable[i | 0x000] = (e + 15) << 10;
					_baseTable[i | 0x100] = ((e + 15) << 10) | 0x8000;
					_shiftTable[i | 0x000] = 13;
					_shiftTable[i | 0x100] = 13;
					
						// large number (Infinity, -Infinity)
				} else if (e < 128) {
					_baseTable[i | 0x000] = 0x7c00;
					_baseTable[i | 0x100] = 0xfc00;
					_shiftTable[i | 0x000] = 24;
					_shiftTable[i | 0x100] = 24;
					
						// stay (NaN, Infinity, -Infinity)
				} else {
					_baseTable[i | 0x000] = 0x7c00;
					_baseTable[i | 0x100] = 0xfc00;
					_shiftTable[i | 0x000] = 13;
					_shiftTable[i | 0x100] = 13;
				}
			}
			
			_mantissaTable[0] = 0;
			for (i = 1; i < 1024; ++i) {
				var m:int = i << 13;    // zero pad mantissa bits
				e = 0;          // zero exponent
				
				// normalized
				while ((m & 0x00800000) === 0) {
					e -= 0x00800000;    // decrement exponent
					m <<= 1;
				}
				
				m &= ~0x00800000;   // clear leading 1 bit
				e += 0x38800000;    // adjust bias
				
				_mantissaTable[i] = m | e;
			}
			for (i = 1024; i < 2048; ++i) {
				_mantissaTable[i] = 0x38000000 + ((i - 1024) << 13);
			}
			
			_exponentTable[0] = 0;
			for (i = 1; i < 31; ++i) {
				_exponentTable[i] = i << 23;
			}
			_exponentTable[31] = 0x47800000;
			_exponentTable[32] = 0x80000000;
			for (i = 33; i < 63; ++i) {
				_exponentTable[i] = 0x80000000 + ((i - 32) << 23);
			}
			_exponentTable[63] = 0xc7800000;
			
			_offsetTable[0] = 0;
			for (i = 1; i < 64; ++i) {
				if (i === 32) {
					_offsetTable[i] = 0;
				} else {
					_offsetTable[i] = 1024;
				}
			}
		}
		
		/**
		 * round a number to a half float number bits.
		 * @param {number} num
		 */
		public static function roundToFloat16Bits(num:Number):int {
			_floatView[0] = num;
			var f:Number = _uint32View[0];
			var e:Number = (f >> 23) & 0x1ff;
			return _baseTable[e] + ((f & 0x007fffff) >> _shiftTable[e]);
		}
		
		/**
		 * convert a half float number bits to a number.
		 * @param {number} float16bits - half float number bits
		 */
		public static function convertToNumber(float16bits:int):Number {
			var m:int = float16bits >> 10;
			_uint32View[0] = _mantissaTable[_offsetTable[m] + (float16bits & 0x3ff)] + _exponentTable[m];
			return _floatView[0];
		}
	
	}

}