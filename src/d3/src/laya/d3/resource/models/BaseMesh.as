package laya.d3.resource.models {
	import laya.d3.core.render.IRenderable;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Vector3;
	import laya.resource.Resource;
	
	/**
	 * <code>BaseMesh</code> 类用于创建网格,抽象类,不允许实例。
	 */
	public class BaseMesh extends Resource {
		/** @private */
		protected var _subMeshCount:int;
		/** @private */
		protected var _boundingBox:BoundBox;
		/** @private */
		protected var _boundingSphere:BoundSphere;
		/** @private */
		protected var _boundingBoxCorners:Vector.<Vector3>;
		/** @private 只读,不允许修改。*/
		public var _positions:Vector.<Vector3>;
		
		/**
		 * 获取SubMesh的个数。
		 * @return SubMesh的个数。
		 */
		public function get subMeshCount():int {
			return _subMeshCount;
		}
		
		/**
		 * 获取AABB包围盒,禁止修改其数据。
		 * @return AABB包围盒。
		 */
		public function get boundingBox():BoundBox {
			return _boundingBox;
		}
		
		/**
		 * 获取包围球,禁止修改其数据。
		 * @return 包围球。
		 */
		public function get boundingSphere():BoundSphere {
			return _boundingSphere;
		}
		
		/**
		 * 获取包围球顶点,禁止修改其数据。
		 * @return 包围球。
		 */
		public function get boundingBoxCorners():Vector.<Vector3> {
			return _boundingBoxCorners;
		}
		
		/**
		 * 创建一个 <code>BaseMesh</code> 实例。
		 */
		public function BaseMesh() {
			_boundingBoxCorners = new Vector.<Vector3>(8);
		}
		
		/**
		 * 获取网格顶点,请重载此方法。
		 * @return 网格顶点。
		 */
		public function _getPositions():Vector.<Vector3> {
			throw new Error("未Override,请重载该属性！");
		}
		
		/**
		 * @private
		 */
		protected function _generateBoundingObject():void {
			_boundingSphere = new BoundSphere(new Vector3(), 0);
			BoundSphere.createfromPoints(_positions, _boundingSphere);
			_boundingBox = new BoundBox(new Vector3(), new Vector3());
			BoundBox.createfromPoints(_positions, _boundingBox);
			_boundingBox.getCorners(_boundingBoxCorners);
		}
		
		/**
		 * 获取渲染单元数量,请重载此方法。
		 * @return 渲染单元数量。
		 */
		public function getRenderElementsCount():int {
			throw new Error("未Override,请重载该属性！");
		}
		
		/**
		 * 获取渲染单元,请重载此方法。
		 * @param	index 索引。
		 * @return 渲染单元。
		 */
		public function getRenderElement(index:int):IRenderable {
			throw new Error("未Override,请重载该属性！");
		}
	
		///** @private 待开放。*/
		//public function Render():void {
		//throw new Error("未Override,请重载该方法！");
		//}
		//
		///** @private 待开放。*/
		//public function RenderSubMesh(subMeshIndex:int):void {
		//throw new Error("未Override,请重载该方法！");
		//}
	}
}