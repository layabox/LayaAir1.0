package laya.d3.core.render {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.Transform3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.graphics.RenderObject;
	import laya.d3.graphics.StaticBatch;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	import laya.d3.shader.ValusArray;
	import laya.d3.utils.Utils3D;
	import laya.renders.Render;
	import laya.webgl.shader.ShaderValue;
	
	/**
	 * @private
	 * <code>RenderElement</code> 类用于实现渲染物体。
	 */
	public class RenderElement {
		public static const BONES:int = 0;
		
		/** @private */
		private static var _tempVector30:Vector3 = new Vector3();
		/** @private */
		private static var _tempVector31:Vector3 = new Vector3();
		/** @private */
		private static var _tempQuaternion0:Quaternion = new Quaternion();
		/** @private */
		private static var _tempMatrix4x40:Matrix4x4 = new Matrix4x4();
		/** @private */
		private static var _tempMatrix4x41:Matrix4x4 = new Matrix4x4();
		
		/** @private 类型0为默认，1为StaticBatch。*/
		public var _type:int = 0;
		/** @private 排序ID。*/
		public var _mainSortID:int;
		/** @private */
		public var _renderObject:RenderObject;
		/** @private 所属Sprite3D精灵。*/
		public var _sprite3D:Sprite3D;
		/** @private 渲染所用材质。*/
		public var _material:BaseMaterial;
		/** @private 渲染元素。*/
		private var _renderObj:IRenderable;
				
		/** @private */
		public var _staticBatch:StaticBatch;
		/** @private */
		public var _batchIndexStart:int;
		/** @private */
		public var _batchIndexEnd:int;
		/** @private */
		public var _canDynamicBatch:Boolean;
		
		/**当前ShaderValue。*/
		public var _shaderValue:ValusArray;
		
		/** @private */
		public var _conchSubmesh:*;/**NATIVE*/
		
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
			_canDynamicBatch = true;
			_shaderValue = new ValusArray();
			if (Render.isConchNode) {//NATIVE
				_conchSubmesh = __JS__("new ConchSubmesh()");
			}
		}
		
		/**
		 * @private
		 */
		public function getStaticBatchBakedVertexs(index:int):Float32Array {
			const byteSizeInFloat:int = 4;
			var vb:VertexBuffer3D = _renderObj._getVertexBuffer(index);
			var bakedVertexes:Float32Array = vb.getData().slice() as Float32Array;
			
			var vertexDeclaration:VertexDeclaration = vb.vertexDeclaration;
			var positionOffset:int = vertexDeclaration.getVertexElementByUsage(VertexElementUsage.POSITION0).offset / byteSizeInFloat;
			var normalOffset:int = vertexDeclaration.getVertexElementByUsage(VertexElementUsage.NORMAL0).offset / byteSizeInFloat;
			
			var rootTransform:Matrix4x4 = _staticBatch._rootSprite.transform.worldMatrix;
			var transform:Matrix4x4 = _sprite3D.transform.worldMatrix;
			var rootInvertMat:Matrix4x4 = _tempMatrix4x40;
			var result:Matrix4x4 = _tempMatrix4x41;
			rootTransform.invert(rootInvertMat);
			Matrix4x4.multiply(rootInvertMat, transform, result);
			
			var rotation:Quaternion = _tempQuaternion0;
			result.decompose(_tempVector30, rotation, _tempVector31);//可不计算position和scale
			
			var vertexFloatCount:int = vertexDeclaration.vertexStride / byteSizeInFloat;
			for (var i:int = 0, n:int = bakedVertexes.length; i < n; i += vertexFloatCount) {
				var posOffset:int = i + positionOffset;
				var norOffset:int = i + normalOffset;
				
				Utils3D.transformVector3ArrayToVector3ArrayCoordinate(bakedVertexes, posOffset, result, bakedVertexes, posOffset);
				Utils3D.transformVector3ArrayByQuat(bakedVertexes, normalOffset, rotation, bakedVertexes, normalOffset);
			}
			return bakedVertexes;
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
				Utils3D.transformVector3ArrayByQuat(bakedVertexes, normalOffset, rotation, bakedVertexes, normalOffset);
			}
			return bakedVertexes;
		}
		
		/**
		 * @private
		 */
		public function getBakedIndices():* {
			return _renderObj._getIndexBuffer().getData();
		}
	
	}
}