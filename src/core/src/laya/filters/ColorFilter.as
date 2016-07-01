package laya.filters {
	
	import laya.utils.RunDriver;
	
	/**
	 * <p><code>ColorFilter</code> 是颜色滤镜。</p>
	 */
	public class ColorFilter extends Filter implements IFilter {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**默认颜色滤镜。*/
		public static var DEFAULT:ColorFilter = new ColorFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
		/**灰色滤镜。*/
		public static var GRAY:ColorFilter = new ColorFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
		/** @private */
		public var _mat:Float32Array;
		/** @private */
		public var _alpha:Float32Array;
		
		/**
		 * 创建一个 <code>ColorFilter</code> 实例。
		 * @param	mat 4 x 5 矩阵。
		 */
		public function ColorFilter(mat:Array = null) {
			if (!mat) {
				mat = [0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];
			}
			_mat = new Float32Array(16);
			_alpha = new Float32Array(4);
			var j:int = 0;
			var z:int = 0;
			for (var i:int = 0; i < 20; i++) {
				if (i % 5 != 4)
				{
					_mat[j++] = mat[i];
				}else {
					_alpha[z++] = mat[i];
				}
			}
			_action = RunDriver.createFilterAction(COLOR);
			_action.data = this;
		}
		/** @private */
		public function getRGBG():Array
		{
			var mat:Float32Array = _mat;
			var tRed:Number = mat[0] + mat[1] + mat[2] + mat[3] + _alpha[0] * 0.25;
			var tGreed:Number = mat[4] + mat[5] + mat[6] + mat[7] + _alpha[1] * 0.25;
			var tBlue:Number = mat[8] + mat[9] + mat[10] + mat[11] + _alpha[2] * 0.25;
			var tAlph:Number = mat[12] + mat[13] + mat[14] + mat[15] + _alpha[3] * 0.25;
			var tSrcMin:Number = Math.min(tRed, tGreed, tBlue);
			var tSrcMax:Number = Math.max(tRed, tGreed, tBlue);
			var tSrcLen:Number = tSrcMax - tSrcMin;
			var tSrcCen:Number = tSrcLen / 2 + tSrcMin;
			
			var tResultRed:int = tRed * tRed / tSrcCen * 0.55;
			var tResultGreed:int = tGreed * tGreed / tSrcCen * 0.55;
			var tResultBlue:int = tBlue * tBlue / tSrcCen * 0.55;
			var tGray:Number = 1.0 - (tSrcLen / 1.05);
			return [tResultRed, tResultGreed, tResultBlue, tGray];
		}
		
		/**@private */
		override public function get type():int {
			return COLOR;
		}
		
		/**@private */
		override public function get action():IFilterAction {
			return _action;
		}
	}
}