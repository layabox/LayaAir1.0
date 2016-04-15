///////////////////////////////////////////////////////////
//  ColorMatrixFilter.as
//  Macromedia ActionScript Implementation of the Class ColorMatrixFilter
//  Created on:      2015-9-18 上午10:52:10
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.filters {
	
	import laya.system.System;
	
	/**
	 * 颜色变化滤镜
	 * @author ww
	 * @version 1.0
	 *
	 * @created  2015-9-18 上午10:52:10
	 */
	public class ColorFilter extends Filter implements IFilter {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**
		 *  创建颜色滤镜
		 * @param matrix  由 20 个项（排列成 4 x 5 矩阵）组成的数组
		 */
		public static var DEFAULT:ColorFilter = new ColorFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
		public static var GRAY:ColorFilter = new ColorFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
		
		public var _elements:Float32Array;
		
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
		
		override public function get type():int {
			return COLOR;
		}
		
		override public function get action():IFilterAction {
			return _action;
		}
	}
}