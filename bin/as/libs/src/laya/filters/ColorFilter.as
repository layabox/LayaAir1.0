package laya.filters {
	
	import laya.display.Sprite;
	import laya.utils.RunDriver;
	
	/**
	 * <p><code>ColorFilter</code> 是颜色滤镜。</p>
	 */
	public class ColorFilter extends Filter implements IFilter {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**默认颜色滤镜。*/
		private static var _DEFAULT:ColorFilter;
		/**灰色滤镜。*/
		private static var _GRAY:ColorFilter;
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
		
		/**@private */
		override public function get type():int {
			return COLOR;
		}
		
		/**@private */
		override public function get action():IFilterAction {
			return _action;
		}
		
		static public function get DEFAULT():ColorFilter {
			if (!_DEFAULT) {
				_DEFAULT = new ColorFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
			}
			return _DEFAULT;
		}
		
		static public function get GRAY():ColorFilter {
			if (!_GRAY) {
				_GRAY = new ColorFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
			}
			return _GRAY;
		}
		
		/**
		 * @private 通知微端
		 */
		public override function callNative(sp:Sprite):void
		{
			var t:ColorFilter = sp._$P.cf = this;
			sp.model && sp.model.setFilterMatrix&&sp.model.setFilterMatrix(_mat, _alpha);
		}
	}
}