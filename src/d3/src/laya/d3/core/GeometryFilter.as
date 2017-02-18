package laya.d3.core {
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.events.EventDispatcher;
	
	/**
	 * <code>GeometryFilter</code> 类用于创建集合体过滤器,抽象类不允许实例。
	 */
	public class GeometryFilter extends EventDispatcher {
		
		/** @private */
		public function get _isAsyncLoaded():Boolean {
			return true;
		}
		
		/**
		 * @private
		 */
		public function get _originalBoundingSphere():BoundSphere {
			throw new Error("BaseRender: must override it.");
		}
		
		/**
		 * @private
		 */
		public function get _originalBoundingBox():BoundBox {
			throw new Error("BaseRender: must override it.");
		}
		
		/**
		 * 创建一个 <code>GeometryFilter</code> 实例。
		 */
		public function GeometryFilter() {
		}
		
		/**
		 * @private
		 */
		public function _destroy():void {
			offAll();
		}
	
	}

}