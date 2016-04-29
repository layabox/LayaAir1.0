package laya.filters {
	
	import laya.system.System;
	
	/**
	 * <p><code>ColorFilter</code> 是颜色滤镜。</p>
	 */
	public class ColorFilter extends Filter implements IFilter {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**
		 *  默认颜色滤镜。
		 */
		public static var DEFAULT:ColorFilter = new ColorFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
		/**
		 * 灰色滤镜。
		 */
		public static var GRAY:ColorFilter = new ColorFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
		/** @private */
		public var _elements:Float32Array;
		
		/**
		 * 创建一个 <code>ColorFilter</code> 实例。
		 * @param	mat 4 x 5 矩阵。
		 */
		public function ColorFilter(mat:Array = null) {
			if (!mat) {
				_elements = DEFAULT._elements;
				return;
			}
			_elements = new Float32Array(20);
			for (var i:int = 0; i < 20; i++) {
				_elements[i] = mat[i];
			}
			_action = System.createFilterAction(COLOR);
			_action.data = this;
		}
		
		/** @inheritDoc */
		override public function get type():int {
			return COLOR;
		}
		
		/** @inheritDoc */
		override public function get action():IFilterAction {
			return _action;
		}
	}
}