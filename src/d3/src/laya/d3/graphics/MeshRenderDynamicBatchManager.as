package laya.d3.graphics {
	import laya.d3.core.BufferState;
	import laya.d3.core.MeshRenderer;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.SubMeshRenderElement;
	
	/**
	 * @private
	 * <code>MeshSprite3DDynamicBatchManager</code> 类用于网格精灵动态批处理管理。
	 */
	public class MeshRenderDynamicBatchManager extends DynamicBatchManager {
		/** @private */
		public static var instance:MeshRenderDynamicBatchManager = new MeshRenderDynamicBatchManager();
		
		/**@private */
		private var _cacheBatchRender:Vector.<Vector.<MeshRenderer>> = new Vector.<Vector.<MeshRenderer>>();
		/**@private */
		private var _cacheBufferStates:Vector.<BufferState> = new Vector.<BufferState>();
		/**@private */
		public var _opaqueBatchMarks:Vector.<Vector.<Vector.<Vector.<Array>>>> = new Vector.<Vector.<Vector.<Vector.<Array>>>>();
		/**@private [只读]*/
		public var _updateCountMark:int;
		
		/**
		 * 创建一个 <code>MeshSprite3DDynamicBatchManager</code> 实例。
		 */
		public function MeshRenderDynamicBatchManager() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			SubMeshDynamicBatch.instance = new SubMeshDynamicBatch();
			_updateCountMark = 0;
		}
		
		/**
		 * @private
		 */
		public function _getBufferState(vertexDeclaration:VertexDeclaration):BufferState {
			var bufferState:BufferState = _cacheBufferStates[vertexDeclaration.id];
			if (!bufferState) {
				var instance:SubMeshDynamicBatch = SubMeshDynamicBatch.instance;
				bufferState = new BufferState();
				bufferState.bind();
				var vertexBuffer:VertexBuffer3D = instance._vertexBuffer;
				vertexBuffer.vertexDeclaration = vertexDeclaration;
				bufferState.applyVertexBuffer(vertexBuffer);
				bufferState.applyIndexBuffer(instance._indexBuffer);
				bufferState.unBind();
				_cacheBufferStates[vertexDeclaration.id] = bufferState;
			}
			return bufferState;
		}
		
		/**
		 * @private
		 */
		public function _getBatchRender(lightMapIndex:int, receiveShadow:Boolean):MeshRenderer {
			var lightRenders:Vector.<MeshRenderer> = _cacheBatchRender[lightMapIndex];
			(lightRenders) || (lightRenders = _cacheBatchRender[lightMapIndex] = new Vector.<MeshRenderer>(2));
			var render:MeshRenderer = lightRenders[receiveShadow ? 1 : 0];
			if (!render) {
				render = new MeshRenderer(null);
				render.lightmapIndex = lightMapIndex;
				render.receiveShadow = receiveShadow;
				lightRenders[receiveShadow ? 1 : 0] = render;
			}
			return render;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _getBatchRenderElementFromPool():RenderElement {
			var renderElement:SubMeshRenderElement = _batchRenderElementPool[_batchRenderElementPoolIndex++] as SubMeshRenderElement;
			if (!renderElement) {
				renderElement = new SubMeshRenderElement();
				_batchRenderElementPool[_batchRenderElementPoolIndex - 1] = renderElement;
				renderElement.dynamicBatchElementList = new Vector.<SubMeshRenderElement>();
			}
			return renderElement;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _clear():void {
			super._clear();
			_updateCountMark++;
		}
	
	}

}