package laya.d3.resource.tempelet {
	import laya.d3.core.material.Material;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.webgl.shader.Shader;
	
	/**
	 * <code>SubMesh</code> 类用于创建子网格数据模板。
	 */
	public class SubMeshTemplet {
		/** @private */
		protected var _ib:IndexBuffer3D;
		/** @private */
		protected var _materialIndex:int = -1;
		/** @private */
		public var _elementCount:int = 0;
		
		/** @private */
		protected var _vbOffet:int = 0;
		/** @private */
		protected var _vb:VertexBuffer3D;
		
		/** @private */
		public var _meshTemplet:MeshTemplet;
		/** @private */
		public var _boneIndex:Uint8Array;
		/** @private */
		public var _cacheBoneDatas:Vector.<Float32Array>;
		/** @private */
		public var _boneData:Float32Array;
		
		/** @private */
		public var _bufferUsage:* = {};
		/** @private */
		public var _finalBufferUsageDic:*;
		
		/**获取顶点索引，UV动画使用。*/
		public var verticesIndices:Uint32Array;
		
		/**
		 * 获取材质
		 * @return	材质ID。
		 */
		public function get material():int {
			return _materialIndex;
		}
		
		/**
		 * 设置材质
		 * @param	value  材质ID。
		 */
		public function set material(value:int):void {
			_materialIndex = value;
		}
		
		/**
		 * 创建一个 <code>SubMesh</code> 实例。
		 * @param	templet  网格数据模板。
		 */
		public function SubMeshTemplet(templet:MeshTemplet) {
			_meshTemplet = templet;
		}
		
		/**
		 * @private
		 */
		public function _mergeRendering(state:RenderState, shader:Shader, uploadBones:Boolean):void {
		}
		
		/**
		 * @private
		 */
		public function _setVBOffset(offset:int):void {
			_vbOffet = offset;
		}
		
		/**
		 * @private
		 */
		public function _setBoneDic(boneDic:Uint8Array):void {
			_boneIndex = boneDic;
			_meshTemplet.disableUseFullBone();
			_cacheBoneDatas = new Vector.<Float32Array>();
			_boneData = new Float32Array(_boneIndex.length * 16);
		}
		
		/**
		 * 获取材质。
		 * @param 材质队列。
		 * @return  材质。
		 */
		public function getMaterial(materials:Vector.<Material>):Material {
			return _materialIndex >= 0 ? materials[_materialIndex] : null;
		}
		
		/**
		 * 设置索引缓冲。
		 * @param value 索引缓冲。
		 * @param elementCount 索引的个数。
		 */
		public function setIB(value:IndexBuffer3D, elementCount:int):void {
			_ib = value;
			_elementCount = elementCount;
		}
		
		/**
		 * 获取索引缓冲。
		 * @return  索引缓冲。
		 */
		public function getIB():IndexBuffer3D {
			return _ib;
		}
		
		/**
		 * 设置顶点缓冲。
		 * @param vb 顶点缓冲。
		 */
		public function setVB(vb:VertexBuffer3D):void {
			_vb = vb;
		}
		
		/**
		 * 获取顶点缓冲。
		 * @return  顶点缓冲。
		 */
		public function getVB():VertexBuffer3D {
			return _vb;
		}
	
	}
}