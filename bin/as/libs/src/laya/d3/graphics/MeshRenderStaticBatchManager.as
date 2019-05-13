package laya.d3.graphics {
	import laya.d3.core.GeometryElement;
	import laya.d3.core.MeshRenderer;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.BatchMark;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.SubMeshRenderElement;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.resource.models.Mesh;
	
	/**
	 * @private
	 * <code>MeshSprite3DStaticBatchManager</code> 类用于网格精灵静态批处理管理。
	 */
	public class MeshRenderStaticBatchManager extends StaticBatchManager {
		/** @private */
		public static var _verDec:VertexDeclaration = VertexMesh.getVertexDeclaration("POSITION,NORMAL,COLOR,UV,UV1,TANGENT");
		/** @private */
		public static var instance:MeshRenderStaticBatchManager = new MeshRenderStaticBatchManager();
		
		/**@private */
		public var _opaqueBatchMarks:Vector.<Vector.<Vector.<Vector.<BatchMark>>>> = new Vector.<Vector.<Vector.<Vector.<BatchMark>>>>();
		/**@private [只读]*/
		public var _updateCountMark:int;
		
		/**
		 * 创建一个 <code>MeshSprite3DStaticBatchManager</code> 实例。
		 */
		public function MeshRenderStaticBatchManager() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			_updateCountMark = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _compare(left:RenderableSprite3D, right:RenderableSprite3D):int {
			//按照合并条件排序，增加初始状态合并几率
			var lRender:BaseRender = left._render, rRender:BaseRender = right._render;
			var leftGeo:Mesh = (left as MeshSprite3D).meshFilter.sharedMesh as Mesh, rightGeo:Mesh = (right as MeshSprite3D).meshFilter.sharedMesh as Mesh;
			var lightOffset:int = lRender.lightmapIndex - rRender.lightmapIndex;
			if (lightOffset === 0) {
				var receiveShadowOffset:int = (lRender.receiveShadow ? 1 : 0) - (rRender.receiveShadow ? 1 : 0);
				if (receiveShadowOffset === 0) {
					var materialOffset:int = lRender.sharedMaterial.id - rRender.sharedMaterial.id;//多维子材质以第一个材质排序
					if (materialOffset === 0) {
						var verDec:int = leftGeo._vertexBuffers[0].vertexDeclaration.id - rightGeo._vertexBuffers[0].vertexDeclaration.id;//TODO:以第一个Buffer为主,后期是否修改VB机制
						if (verDec === 0) {
							return rightGeo._indexBuffer.indexCount - leftGeo._indexBuffer.indexCount;//根据三角面排序
						} else {
							return verDec;
						}
					} else {
						return materialOffset;
					}
				} else {
					return receiveShadowOffset;
				}
			} else {
				return lightOffset;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _getBatchRenderElementFromPool():RenderElement {
			var renderElement:SubMeshRenderElement = _batchRenderElementPool[_batchRenderElementPoolIndex++];
			if (!renderElement) {
				renderElement = new SubMeshRenderElement();
				_batchRenderElementPool[_batchRenderElementPoolIndex - 1] = renderElement;
				renderElement.staticBatchElementList = new Vector.<SubMeshRenderElement>();
			}
			return renderElement;
		}
		
		/**
		 * @private
		 */
		private function _getStaticBatch(rootOwner:Sprite3D, number:int):SubMeshStaticBatch {
			var key:int = rootOwner ? rootOwner.id : 0;
			var batchOwner:Object = _staticBatches[key];
			(batchOwner) || (batchOwner = _staticBatches[key] = []);
			return (batchOwner[number]) || (batchOwner[number] = new SubMeshStaticBatch(rootOwner, number, _verDec));
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _initStaticBatchs(rootOwner:Sprite3D):void {
			_quickSort(_initBatchSprites, 0, _initBatchSprites.length - 1);
			var lastCanMerage:Boolean = false;
			var curStaticBatch:SubMeshStaticBatch;
			var batchNumber:int = 0;
			for (var i:int = 0, n:int = _initBatchSprites.length; i < n; i++) {
				var sprite:RenderableSprite3D = _initBatchSprites[i];
				if (lastCanMerage) {
					if (curStaticBatch.addTest(sprite)) {
						curStaticBatch.add(sprite);
					} else {
						lastCanMerage = false;
						batchNumber++;//修改编号，区分批处理
					}
				} else {
					var lastIndex:int = n - 1;
					if (i !== lastIndex) {
						curStaticBatch = _getStaticBatch(rootOwner, batchNumber);
						curStaticBatch.add(sprite);
						lastCanMerage = true;
					}
				}
			}
			
			for (var key:String in _staticBatches) {
				var batches:Array = _staticBatches[key];
				for (i = 0, n = batches.length; i < n; i++)
					batches[i].finishInit();
			}
			_initBatchSprites.length = 0;
		}
		
		/**
		 * @private
		 */
		public function _destroyRenderSprite(sprite:RenderableSprite3D):void {
			var staticBatch:SubMeshStaticBatch = sprite._render._staticBatch as SubMeshStaticBatch;
			staticBatch.remove(sprite);
			
			if (staticBatch._batchElements.length === 0) {
				var owner:Sprite3D = staticBatch.batchOwner;
				var ownerID:int = owner ? owner.id : 0;
				var batches:Array = _staticBatches[ownerID];
				batches[staticBatch.number] = null;
				staticBatch.dispose();
				var empty:Boolean = true;
				for (var i:int = 0; i < batches.length; i++ ){
					if (batches[i])
						empty = false;
				}
				
				if (empty){
					delete _staticBatches[ownerID];
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _clear():void {
			super._clear();
			_updateCountMark++;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _garbageCollection():void {
			for (var key:String in _staticBatches) {
				var batches:Array = _staticBatches[key];
				for (var i:int = 0, n:int = batches.length; i < n; i++) {
					var staticBatch:SubMeshStaticBatch = batches[i];
					if (staticBatch._batchElements.length === 0) {
						staticBatch.dispose();
						batches.splice(i, 1);
						i--, n--;
						if (n === 0)
							delete _staticBatches[key];
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		public function getBatchOpaquaMark(lightMapIndex:int, receiveShadow:Boolean, materialID:int, staticBatchID:int):BatchMark {
			var staLightMapMarks:Vector.<Vector.<Vector.<BatchMark>>> = (_opaqueBatchMarks[lightMapIndex]) || (_opaqueBatchMarks[lightMapIndex] = new Vector.<Vector.<Vector.<BatchMark>>>());
			var staReceiveShadowMarks:Vector.<Vector.<BatchMark>> = (staLightMapMarks[receiveShadow]) || (staLightMapMarks[receiveShadow] = new Vector.<Vector.<BatchMark>>());
			var staMaterialMarks:Vector.<BatchMark> = (staReceiveShadowMarks[materialID]) || (staReceiveShadowMarks[materialID] = new Vector.<BatchMark>());
			return (staMaterialMarks[staticBatchID]) || (staMaterialMarks[staticBatchID] = new BatchMark);
		}
	}
}