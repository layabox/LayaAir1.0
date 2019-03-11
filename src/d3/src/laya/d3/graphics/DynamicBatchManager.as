package laya.d3.graphics {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Matrix4x4;
	
	/**
	 * @private
	 * <code>DynamicBatchManager</code> 类用于管理动态批处理。
	 */
	public class DynamicBatchManager {
		/** @private [只读]*/
		public static var _managers:Vector.<DynamicBatchManager> = new Vector.<DynamicBatchManager>();
		
		/**
		 * @private
		 */
		public static function _registerManager(manager:DynamicBatchManager):void {
			_managers.push(manager);
		}
		
		/** @private */
		protected var _batchRenderElementPool:Vector.<RenderElement>;
		/** @private */
		protected var _batchRenderElementPoolIndex:int;
		
		/**
		 * 创建一个 <code>DynamicBatchManager</code> 实例。
		 */
		public function DynamicBatchManager() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_batchRenderElementPool = new Vector.<RenderElement>();
		}
		
		/**
		 * @private
		 */
		public function _clear():void {
			_batchRenderElementPoolIndex = 0;
		}
		
		/**
		 * @private
		 */
		public function _getBatchRenderElementFromPool():RenderElement {
			throw "StaticBatch:must override this function.";
		}
		
		/**
		 * @private
		 */
		public function dispose():void {
		}
	
	}

}