package laya.d3.core.render {
	import laya.d3.core.GeometryElement;
	import laya.d3.core.Transform3D;
	import laya.d3.core.material.BaseMaterial;
	
	/**
	 * @private
	 * <code>RenderElement</code> 类用于实现渲染元素。
	 */
	public class RenderElement {
		/** @private */
		public var _transform:Transform3D;
		/** @private */
		public var _geometry:GeometryElement;
		
		/** @private */
		public var material:BaseMaterial;
		/** @private */
		public var render:BaseRender;
		/** @private */
		public var staticBatch:GeometryElement;
		
		/**
		 * 创建一个 <code>RenderElement</code> 实例。
		 */
		public function RenderElement() {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
		
		/**
		 * @private
		 */
		public function setTransform(transform:Transform3D):void {
			_transform = transform;
		}
		
		/**
		 * @private
		 */
		public function setGeometry(geometry:GeometryElement):void {
			_geometry = geometry;
		}
		
		/**
		 * @private
		 */
		public function addToOpaqueRenderQueue(context:RenderContext3D, queue:RenderQueue):void {
			queue.elements.push(this);
		}
		
		/**
		 * @private
		 */
		public function addToTransparentRenderQueue(context:RenderContext3D, queue:RenderQueue):void {
			queue.elements.push(this);
			queue.lastTransparentBatched = false;
			queue.lastTransparentRenderElement = this;
		}
		
		/**
		 * @private
		 */
		public function destroy():void {
			_transform = null;
			_geometry = null;
			material = null;
			render = null;
		}
	}
}