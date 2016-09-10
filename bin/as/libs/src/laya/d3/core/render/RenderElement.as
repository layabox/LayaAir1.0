package laya.d3.core.render {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.Material;
	import laya.d3.graphics.StaticBatch;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.math.Matrix4x4;
	import laya.d3.utils.Utils3D;
	
	/**
	 * <code>RenderObject</code> 类用于实现渲染物体。
	 */
	public class RenderElement {
		/** @private */
		private var _needComputeBakedVertex:Boolean;
		/** @private */
		private var _bakedVertexes:Float32Array;
		
		/**渲染元素。*/
		private var _renderObj:IRenderable;
		
		/**所属队列。*/
		public var ownerRenderQneue:RenderQueue;
		
		
		
		public var staticBatch:StaticBatch;
		public var staticBatchIndexStart:int;
		public var staticBatchIndexEnd:int;
		/**是否为静态批处理的一部分。*/
		public var isInStaticBatch:Boolean;
		///**是否需要渲染。*/
		//public var needRender:Boolean;
		
		
		
		
		
		/**类型0为默认，1为StaticBatch。*/
		public var type:int = 0;
		/**所属Sprite3D精灵。*/
		public var sprite3D:Sprite3D;
		
		/**渲染所用材质。*/
		public var material:Material;
		/**排序ID。*/
		public var mainSortID:int;
		/**三角形个数。*/
		public var triangleCount:int;
		
		public function set element(value:IRenderable):void {
			if (_renderObj !== value) {
				_renderObj = value;
				_needComputeBakedVertex = true;
			}
		}
		
		public function get element():IRenderable {
			return _renderObj;
		}
		
		
		private static var idCount:int = 0;
		
		public var id:int;
		
		/**
		 * 创建一个 <code>RenderObject</code> 实例。
		 */
		public function RenderElement() {
			id = idCount++;
			_needComputeBakedVertex = false;
			//trace("RenderElement");
		}
		
		/**
		 * @private
		 */
		public function getBakedVertexs(index:int):Float32Array {
			if (_needComputeBakedVertex) {
				const byteSizeInFloat:int = 4;
				var vb:VertexBuffer3D = _renderObj.getVertexBuffer(index);
				_bakedVertexes = vb.getData().slice() as Float32Array;//在红米2S微信中发现不支持slice();
				
				var vertexDeclaration:VertexDeclaration = vb.vertexDeclaration;
				var positionOffset:int = vertexDeclaration.shaderAttribute[VertexElementUsage.POSITION0][4] / byteSizeInFloat;
				var normalOffset:int = vertexDeclaration.shaderAttribute[VertexElementUsage.NORMAL0][4] / byteSizeInFloat;
				var transform:Matrix4x4 = sprite3D.transform.worldMatrix;
				for (var i:int = 0; i < _bakedVertexes.length; i += vertexDeclaration.vertexStride / byteSizeInFloat) {
					var posOffset:int = i + positionOffset;
					var norOffset:int = i + normalOffset;
					
					Utils3D.transformVector3ArrayToVector3ArrayCoordinate(_bakedVertexes, posOffset, transform, _bakedVertexes, posOffset);
					Utils3D.transformVector3ArrayToVector3ArrayCoordinate(_bakedVertexes, normalOffset, transform, _bakedVertexes, normalOffset);
				}
				_needComputeBakedVertex = false;
			}
			return _bakedVertexes;
		}
		
		/**
		 * @private
		 */
		public function getBakedIndices():* {
			return _renderObj.getIndexBuffer().getData();
		}
	
	}
}