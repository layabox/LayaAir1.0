package laya.d3.graphics {
	import laya.d3.core.BufferState;
	import laya.d3.core.MeshRenderer;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.render.BatchMark;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.SubMeshRenderElement;
	import laya.d3.core.scene.Scene3D;
	
	/**
	 * @private
	 * <code>MeshSprite3DDynamicBatchManager</code> 类用于网格精灵动态批处理管理。
	 */
	public class MeshRenderDynamicBatchManager extends DynamicBatchManager {
		/** @private */
		public static var instance:MeshRenderDynamicBatchManager = new MeshRenderDynamicBatchManager();
		
		/**@private */
		private var _instanceBatchOpaqueMarks:Vector.<Vector.<Vector.<Vector.<BatchMark>>>> = new Vector.<Vector.<Vector.<Vector.<BatchMark>>>>();
		/**@private */
		private var _vertexBatchOpaqueMarks:Vector.<Vector.<Vector.<Vector.<BatchMark>>>> = new Vector.<Vector.<Vector.<Vector.<BatchMark>>>>();
		
		/**@private */
		private var _cacheBufferStates:Vector.<BufferState> = new Vector.<BufferState>();
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
		public function getInstanceBatchOpaquaMark(lightMapIndex:int, receiveShadow:Boolean, materialID:int, subMeshID:int):BatchMark {
			var instanceLightMapMarks:Vector.<Vector.<Vector.<BatchMark>>> = (_instanceBatchOpaqueMarks[lightMapIndex]) || (_instanceBatchOpaqueMarks[lightMapIndex] = new Vector.<Vector.<Vector.<BatchMark>>>());
			var instanceReceiveShadowMarks:Vector.<Vector.<BatchMark>> = (instanceLightMapMarks[receiveShadow ? 0 : 1]) || (instanceLightMapMarks[receiveShadow ? 0 : 1] = new Vector.<Vector.<BatchMark>>());
			var instanceMaterialMarks:Vector.<BatchMark> = (instanceReceiveShadowMarks[materialID]) || (instanceReceiveShadowMarks[materialID] = new Vector.<BatchMark>());
			return instanceMaterialMarks[subMeshID] || (instanceMaterialMarks[subMeshID] = new BatchMark());
		}
		
		/**
		 * @private
		 */
		public function getVertexBatchOpaquaMark(lightMapIndex:int, receiveShadow:Boolean, materialID:int, verDecID:int):BatchMark {
			var dynLightMapMarks:Vector.<Vector.<Vector.<BatchMark>>> = (_vertexBatchOpaqueMarks[lightMapIndex]) || (_vertexBatchOpaqueMarks[lightMapIndex] = new Vector.<Vector.<Vector.<BatchMark>>>());
			var dynReceiveShadowMarks:Vector.<Vector.<BatchMark>> = (dynLightMapMarks[receiveShadow ? 0 : 1]) || (dynLightMapMarks[receiveShadow ? 0 : 1] = new Vector.<Vector.<BatchMark>>());
			var dynMaterialMarks:Vector.<BatchMark> = (dynReceiveShadowMarks[materialID]) || (dynReceiveShadowMarks[materialID] = new Vector.<BatchMark>());
			return dynMaterialMarks[verDecID] || (dynMaterialMarks[verDecID] = new BatchMark());
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
		 * @inheritDoc
		 */
		override public function _getBatchRenderElementFromPool():RenderElement {
			var renderElement:SubMeshRenderElement = _batchRenderElementPool[_batchRenderElementPoolIndex++] as SubMeshRenderElement;
			if (!renderElement) {
				renderElement = new SubMeshRenderElement();
				_batchRenderElementPool[_batchRenderElementPoolIndex - 1] = renderElement;
				renderElement.vertexBatchElementList = new Vector.<SubMeshRenderElement>();
				renderElement.instanceBatchElementList = new Vector.<SubMeshRenderElement>();
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