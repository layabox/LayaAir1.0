package laya.maths {
	
	/**
	 * @private
	 */
	public class Arith {
		public static function formatR(r:Number):Number {
			if (r > Math.PI) r -= Math.PI * 2;
			if (r < -Math.PI) r += Math.PI * 2;
			return r;
		}
		
		public static function isPOT(w:uint, h:uint):Boolean {
			return (w > 0 && (w & (w - 1)) === 0 && h > 0 && (h & (h - 1)) === 0);
		}
		
		public static function setMatToArray(mat:Matrix, array:*):void {
			mat.a, mat.b, 0, 0, mat.c, mat.d, 0, 0, 0, 0, 1, 0, mat.tx + 20, mat.ty + 20, 0, 1
			
			array[0] = mat.a;
			array[1] = mat.b;
			array[4] = mat.c;
			array[5] = mat.d;
			array[12] = mat.tx;
			array[13] = mat.ty;
		}
	}
}