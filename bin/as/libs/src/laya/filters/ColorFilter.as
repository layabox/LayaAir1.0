package laya.filters {
	
	import laya.display.Sprite;
	import laya.utils.RunDriver;
	
	/**
	 * <p><code>ColorFilter</code> 是颜色滤镜。使用 ColorFilter 类可以将 4 x 5 矩阵转换应用于输入图像上的每个像素的 RGBA 颜色和 Alpha 值，以生成具有一组新的 RGBA 颜色和 Alpha 值的结果。该类允许饱和度更改、色相旋转、亮度转 Alpha 以及各种其他效果。您可以将滤镜应用于任何显示对象（即，从 Sprite 类继承的对象）。</p>
	 * <p>注意：对于 RGBA 值，最高有效字节代表红色通道值，其后的有效字节分别代表绿色、蓝色和 Alpha 通道值。</p>
	 */
	public class ColorFilter extends Filter implements IFilter {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/** @private */
		public var _mat:Float32Array;
		/** @private */
		public var _alpha:Float32Array;
		
		/**
		 * 创建一个 <code>ColorFilter</code> 实例。
		 * @param mat	（可选）由 20 个项目（排列成 4 x 5 矩阵）组成的数组，用于颜色转换。
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
				if (i % 5 != 4) {
					_mat[j++] = mat[i];
				} else {
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
		
		/**
		 * @private 通知微端
		 */
		public override function callNative(sp:Sprite):void {
			var t:ColorFilter = sp._$P.cf = this;
			sp.conchModel && sp.conchModel.setFilterMatrix && sp.conchModel.setFilterMatrix(_mat, _alpha);
		}
	}
}