package laya.d3.core {
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Vector3;
	import laya.events.EventDispatcher;
	import laya.resource.IDestroy;
	
	/**
	 * <code>GeometryFilter</code> 类用于创建集合体过滤器,抽象类不允许实例。
	 */
	public class GeometryFilter extends EventDispatcher implements IDestroy {
		/**@private */
		private var _destroyed:Boolean;
		
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
		 * @private
		 */
		public function get _originalBoundingBoxCorners():Vector.<Vector3> {
			throw new Error("BaseRender: must override it.");
		}
		
		/**
		 * 获取是否已销毁。
		 * @return 是否已销毁。
		 */
		public function get destroyed():Boolean {
			return _destroyed;
		}
		
		/**
		 * 创建一个 <code>GeometryFilter</code> 实例。
		 */
		public function GeometryFilter() {
			_destroyed = false;
		}
		
		/**
		 * @private
		 */
		public function _destroy():void {
			offAll();
			_destroyed = true;
		}
	
	}

}