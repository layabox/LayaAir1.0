package laya.d3.resource.models {
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.math.Matrix4x4;
	import laya.d3.resource.models.Mesh;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.utils.Utils3D;
	import laya.resource.IDispose;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer2D;
	
	/**
	 * <code>SubMesh</code> 类用于创建子网格数据模板。
	 */
	public class SubMesh implements IRenderable, IDispose {
		/** @private */
		public var _indexBuffer:IndexBuffer3D;
		/** @private */
		public var _vertexBuffer:VertexBuffer3D;
		/** @private */
		public var _boneIndices:Uint8Array;
		/** @private */
		public var _bufferUsage:*;
		/** @private */
		public var _indexInMesh:int;
		
		/**
		 * @private
		 */
		public function get _vertexBufferCount():int {
			return 1;
		}
		
		/**
		 * @private
		 */
		public function get indexOfHost():int {
			return _indexInMesh;
		}
		
		/**
		 * @private
		 */
		public function get triangleCount():int {
			return _indexBuffer.indexCount / 3;
		}
		
		/**
		 * 创建一个 <code>SubMesh</code> 实例。
		 * @param	mesh  网格数据模板。
		 */
		public function SubMesh() {
			_bufferUsage = {};
		}
		
		/**
		 * @private
		 */
		public function _getVertexBuffer(index:int = 0):VertexBuffer3D {
			if (index === 0)
				return _vertexBuffer;
			else
				return null;
		}
		
		/**
		 * @private
		 */
		public function _getIndexBuffer():IndexBuffer3D {
			return _indexBuffer;
		}
		
		/**
		 * @private
		 */
		public function _beforeRender(state:RenderState):Boolean {
			_vertexBuffer._bind();
			_indexBuffer._bind();
			return true;
		}
		
		/**
		 * @private
		 * 渲染。
		 * @param	state 渲染状态。
		 */
		public function _render(state:RenderState):void {
			var indexCount:int = _indexBuffer.indexCount;
			state.context.drawElements(WebGLContext.TRIANGLES, indexCount, WebGLContext.UNSIGNED_SHORT, 0);
			Stat.drawCall++;
			Stat.trianglesFaces += indexCount / 3;
		}
		
		/**
		 * <p>彻底清理资源。</p>
		 * <p><b>注意：</b>会强制解锁清理。</p>
		 */
		public function dispose():void {
			_boneIndices = null;
			_indexBuffer.dispose();
			_vertexBuffer.dispose();
		}
	
	}
}