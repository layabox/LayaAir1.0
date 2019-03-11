package laya.d3.resource.models {
	import laya.d3.core.BufferState;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	
	/**
	 * <code>SkyMesh</code> 类用于实现天空网格。
	 */
	public class SkyMesh {
		
		/**@private */
		protected var _vertexBuffer:VertexBuffer3D;
		/**@private */
		protected var _indexBuffer:IndexBuffer3D;
		
		/**@private */
		public var _bufferState:BufferState;
		
		/**
		 * 创建一个新的 <code>SkyMesh</code> 实例。
		 */
		public function SkyMesh() {
		
		}
		
		/**
		 * @private
		 */
		public function _render(state:RenderContext3D):void {
		
		}
	
	}

}