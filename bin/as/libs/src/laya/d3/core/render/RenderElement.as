package laya.d3.core.render {
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.graphics.StaticBatch;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.shader.ValusArray;
	import laya.d3.utils.Utils3D;
	import laya.renders.Render;
	
	/**
	 * @private
	 * <code>RenderElement</code> 类用于实现渲染物体。
	 */
	public class RenderElement {
		/**唯一标识ID计数器*/
		private static var _uniqueIDCounter:int = 0;
		
		/**@private */
		private var _id:int;
		/** @private 类型0为默认，2为DynamicBatch。*/
		public var _type:int = 0;
		/** @private 排序ID。*/
		public var _mainSortID:int;
		/** @private */
		public var _render:BaseRender;
		/** @private 所属Sprite3D精灵。*/
		public var _sprite3D:RenderableSprite3D;
		/** @private 渲染所用材质。*/
		public var _material:BaseMaterial;
		/** @private 渲染元素。*/
		private var _renderObj:IRenderable;
		
		/** @private */
		public var _staticBatch:StaticBatch;
		
		//...............临时...........................
		public var _tempBatchIndexStart:int;//TODO:
		public var _tempBatchIndexEnd:int;//TODO:
		//...............临时...........................
		
		/** @private */
		public var _canDynamicBatch:Boolean;
		
		/**当前ShaderValue。*/
		public var _shaderValue:ValusArray;
		
		public var _onPreRenderFunction:Function;
		
		/** @private */
		public var _conchSubmesh:*;/**NATIVE*/
		
		/**
		 * 获取唯一标识ID,通常用于识别。
		 */
		public function get id():int {
			return _id;
		}
		
		public function set renderObj(value:IRenderable):void {
			if (_renderObj !== value) {
				_renderObj = value;
			}
		}
		
		public function get renderObj():IRenderable {
			return _renderObj;
		}
		
		/**
		 * 创建一个 <code>RenderElement</code> 实例。
		 */
		public function RenderElement() {
			_id = ++_uniqueIDCounter;
			_canDynamicBatch = true;
			_shaderValue = new ValusArray();
			if (Render.isConchNode) {//NATIVE
				_conchSubmesh = __JS__("new ConchSubmesh()");
			}
		}
		
		/**
		 * @private
		 */
		public function getDynamicBatchBakedVertexs(index:int):Float32Array {
			const byteSizeInFloat:int = 4;
			var vb:VertexBuffer3D = _renderObj._getVertexBuffer(index);
			var bakedVertexes:Float32Array = vb.getData().slice() as Float32Array;
			
			var vertexDeclaration:VertexDeclaration = vb.vertexDeclaration;
			var positionOffset:int = vertexDeclaration.getVertexElementByUsage(VertexElementUsage.POSITION0).offset / byteSizeInFloat;
			var normalOffset:int = vertexDeclaration.getVertexElementByUsage(VertexElementUsage.NORMAL0).offset / byteSizeInFloat;
			
			var transform:Transform3D = _sprite3D.transform;
			var worldMatrix:Matrix4x4 = transform.worldMatrix;
			var rotation:Quaternion = transform.rotation;
			var vertexFloatCount:int = vertexDeclaration.vertexStride / byteSizeInFloat;
			for (var i:int = 0, n:int = bakedVertexes.length; i < n; i += vertexFloatCount) {
				var posOffset:int = i + positionOffset;
				var norOffset:int = i + normalOffset;
				
				Utils3D.transformVector3ArrayToVector3ArrayCoordinate(bakedVertexes, posOffset, worldMatrix, bakedVertexes, posOffset);
				Utils3D.transformVector3ArrayByQuat(bakedVertexes, norOffset, rotation, bakedVertexes, norOffset);
			}
			return bakedVertexes;
		}
		
		/**
		 * @private
		 */
		public function getBakedIndices():* {
			return _renderObj._getIndexBuffer().getData();
		}
		
		/**
		 * @private
		 */
		public function _destroy():void {
			(_staticBatch) && (_staticBatch._manager._garbageCollection(this));
		}
	
	}
}