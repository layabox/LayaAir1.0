package laya.filters {
	import laya.display.Sprite;
	import laya.maths.Rectangle;
	import laya.renders.RenderContext;
	import laya.system.System;
	import laya.utils.RunDriver;
	
	/**
	 * 模糊滤镜
	 */
	public class BlurFilter extends Filter {
		
		/**模糊滤镜的强度(值越大，越不清晰 */
		public var strength:Number;
		
		/**
		 * 模糊滤镜
		 * @param	strength	模糊滤镜的强度值
		 */
		public function BlurFilter(strength:Number = 4) {
			WebGLFilter.enable();
			super();
			this.strength = strength;
			_action = RunDriver.createFilterAction(BLUR);
			_action.data = this;
		}
		
		/**
		 * @private
		 * 当前滤镜对应的操作器
		 */
		override public function get action():IFilterAction {
			return _action;
		}
		
		/**
		 * @private
		 * 当前滤镜的类型
		 */
		override public function get type():int {
			return BLUR;
		}
	}
}