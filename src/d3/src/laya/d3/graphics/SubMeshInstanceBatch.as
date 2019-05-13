package laya.d3.graphics {
	import laya.d3.core.GeometryElement;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.render.SubMeshRenderElement;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.resource.models.SubMesh;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	
	/**
	 * @private
	 */
	public class SubMeshInstanceBatch extends GeometryElement {
		/** @private */
		public static var instance:SubMeshInstanceBatch = new SubMeshInstanceBatch();
		
		/** @private */
		public const maxInstanceCount:int = 1024;
		
		/** @private */
		public var instanceWorldMatrixData:Float32Array = new Float32Array(maxInstanceCount * 16);
		/** @private */
		public var instanceMVPMatrixData:Float32Array = new Float32Array(maxInstanceCount * 16);
		/** @private */
		public var instanceWorldMatrixBuffer:VertexBuffer3D = new VertexBuffer3D(instanceWorldMatrixData.length * 4, WebGLContext.DYNAMIC_DRAW);
		/** @private */
		public var instanceMVPMatrixBuffer:VertexBuffer3D = new VertexBuffer3D(instanceMVPMatrixData.length * 4, WebGLContext.DYNAMIC_DRAW);
		
		/**
		 * 创建一个 <code>InstanceSubMesh</code> 实例。
		 */
		public function SubMeshInstanceBatch() {
			instanceWorldMatrixBuffer.vertexDeclaration = VertexMesh.instanceWorldMatrixDeclaration;
			instanceMVPMatrixBuffer.vertexDeclaration = VertexMesh.instanceMVPMatrixDeclaration;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _render(state:RenderContext3D):void {
			var element:SubMeshRenderElement = state.renderElement as SubMeshRenderElement;
			var subMesh:SubMesh = element.instanceSubMesh;
			var count:int = element.instanceBatchElementList.length;
			var indexCount:int = subMesh._indexCount;
			subMesh._mesh._instanceBufferState.bind();
			WebGLContext._angleInstancedArrays.drawElementsInstancedANGLE(WebGLContext.TRIANGLES, indexCount, WebGLContext.UNSIGNED_SHORT, subMesh._indexStart * 2, count);
			Stat.renderBatches++;
			Stat.savedRenderBatches += count - 1;
			Stat.trianglesFaces += indexCount * count / 3;
		}
	}
}