package laya.d3.graphics {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Matrix4x4;
	import laya.resource.IDispose;
	
	/**
	 * <code>StaticBatch</code> 类用于静态合并的父类,该类为抽象类。
	 */
	public class StaticBatch implements IRenderable, IDispose {
		/** @private */
		public static const maxBatchVertexCount:int = 65535;
		
		/**
		 * 兼容性接口,请使用StaticBatchManager.combine()代替。
		 */
		public static function combine(staticBatchRoot:Sprite3D):void {
			trace("StaticBatch: discard property,please use StaticBatchManager.combine() function instead.");
			StaticBatchManager.combine(staticBatchRoot);
		}
		
		/** @private */
		protected var _combineRenderElementPoolIndex:int;
		/** @private */
		protected var _combineRenderElementPool:Vector.<RenderElement>;
		/** @private */
		public var _initBatchRenderElements:Vector.<RenderElement>;
		/** @private */
		public var _batchRenderElements:Vector.<RenderElement>;
		
		/** @private */
		public var _material:BaseMaterial;
		/** @private */
		public var _rootOwner:Sprite3D;
		/** @private */
		public var _key:String;
		/** @private */
		public var _manager:StaticBatchManager;
		
		//..................临时.................................
		public function get _vertexBufferCount():int {
			return 1;
		}
		
		public function get triangleCount():int {
			return 0;
		}
		
		//..................临时.................................
		
		/**
		 * 创建一个 <code>StaticBatch</code> 实例。
		 */
		public function StaticBatch(key:String, manager:StaticBatchManager, rootOwner:Sprite3D) {
			_key = key;
			_manager = manager;
			_combineRenderElementPoolIndex = 0;
			_combineRenderElementPool = new Vector.<RenderElement>();
			
			_initBatchRenderElements = new Vector.<RenderElement>();
			_batchRenderElements = new Vector.<RenderElement>();
			_rootOwner = rootOwner;
		}
		
		/**
		 * @private
		 */
		private function _binarySearch(renderElement:RenderElement):int {
			var start:int = 0;
			var end:int = _batchRenderElements.length - 1;
			var mid:int;
			while (start <= end) {
				mid = Math.floor((start + end) / 2);
				if (_compareBatchRenderElement(_batchRenderElements[mid], renderElement))
					end = mid - 1;
				else
					start = mid + 1;
			}
			return start;
		}
		
		/**
		 * @private
		 */
		protected function _compareBatchRenderElement(a:RenderElement, b:RenderElement):Boolean {
			throw new Error("StaticBatch:must override this function.");
		}
		
		
		/**
		 * @private
		 */
		protected function _getVertexDecLightMap(vertexDeclaration:VertexDeclaration):VertexDeclaration {
			if (vertexDeclaration === VertexPositionNormalTextureSkinSTangent.vertexDeclaration) {
				return VertexPositionNormalTexture0Texture1SkinSTangent.vertexDeclaration;
			} else if (vertexDeclaration === VertexPositionNormalTextureSkin.vertexDeclaration) {
				return VertexPositionNormalTexture0Texture1Skin.vertexDeclaration;
			} else if (vertexDeclaration === VertexPositionNormalColorTextureSTangent.vertexDeclaration) {
				return VertexPositionNormalColorTexture0Texture1STangent.vertexDeclaration;
			} else if (vertexDeclaration === VertexPositionNTBTexture.vertexDeclaration) {
				return null;//TODO:老郭补
			} else if (vertexDeclaration === VertexPositionNormalColorTexture.vertexDeclaration) {
				return VertexPositionNormalColorTexture0Texture1.vertexDeclaration;
			} else if (vertexDeclaration === VertexPositionNormalTextureSTangent.vertexDeclaration) {
				return VertexPositionNormalTexture0Texture1STangent.vertexDeclaration;
			} else if (vertexDeclaration === VertexPositionNormalTexture.vertexDeclaration) {
				return VertexPositionNormalTexture0Texture1.vertexDeclaration;
			}
			if (vertexDeclaration === VertexPositionNormalTextureSkinTangent.vertexDeclaration) {//TODO:兼容性
				return VertexPositionNormalTexture0Texture1SkinTangent.vertexDeclaration;
			} else if (vertexDeclaration === VertexPositionNormalTextureSkin.vertexDeclaration) {
				return VertexPositionNormalTexture0Texture1Skin.vertexDeclaration;
			} else if (vertexDeclaration === VertexPositionNormalColorTextureTangent.vertexDeclaration) {
				return VertexPositionNormalColorTexture0Texture1Tangent.vertexDeclaration;
			} else if (vertexDeclaration === VertexPositionNTBTexture.vertexDeclaration) {
				return null;//TODO:老郭补
			} else if (vertexDeclaration === VertexPositionNormalColorTexture.vertexDeclaration) {
				return VertexPositionNormalColorTexture0Texture1.vertexDeclaration;
			} else if (vertexDeclaration === VertexPositionNormalTextureTangent.vertexDeclaration) {
				return VertexPositionNormalTexture0Texture1Tangent.vertexDeclaration;
			} else if (vertexDeclaration === VertexPositionNormalTexture.vertexDeclaration) {
				return VertexPositionNormalTexture0Texture1.vertexDeclaration;
			} else {
				return vertexDeclaration;
			}
		}
		
		/**
		 * @private
		 */
		protected function _getCombineRenderElementFromPool():RenderElement {
			throw new Error("StaticBatch:must override this function.");
		}
		
		/**
		 * @private
		 */
		public function _addBatchRenderElement(renderElement:RenderElement):void {
			_batchRenderElements.splice(_binarySearch(renderElement), 0, renderElement);
		}
		
		/**
		 * @private
		 */
		public function _updateToRenderQueue(scene:Scene, projectionView:Matrix4x4):void {
			_combineRenderElementPoolIndex = 0;//归零对象池
			_getRenderElement(scene.getRenderQueue(_material.renderQueue)._renderElements, scene, projectionView);
		}
		
		/**
		 * @private
		 */
		protected function _getRenderElement(mergeElements:Array, scene:Scene, projectionView:Matrix4x4):void {
			throw new Error("StaticBatch:must override this function.");
		}
		
		/**
		 * @private
		 */
		public function _finishInit():void {
			throw new Error("StaticBatch:must override this function.");
		}
		
		/**
		 * @private
		 */
		public function _clearRenderElements():void {
			_batchRenderElements.length = 0;
		}
		
		/**
		 * @private
		 */
		public function dispose():void {
		
		}
		
		//..................临时.................................
		public function _getVertexBuffer(index:int = 0):VertexBuffer3D {
			return null;
		}
		
		public function _getIndexBuffer():IndexBuffer3D {
			return null;
		}
		
		public function _beforeRender(state:RenderState):Boolean {
			return true;
		}
		
		public function _render(state:RenderState):void {
		}
		
		/**
		 * @private
		 */
		public function _getVertexBuffers():Vector.<VertexBuffer3D>{
			return null;
		}
		
		/**NATIVE*/
		public function _renderRuntime(conchGraphics3D:*, renderElement:RenderElement, state:RenderState):void {
		
		}
		//..................临时.................................
	
	}

}