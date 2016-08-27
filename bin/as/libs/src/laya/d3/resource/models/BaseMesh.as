package laya.d3.resource.models {
	import laya.d3.core.material.Material;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Vector3;
	import laya.resource.Resource;
	
	/**
	 * <code>BaseMesh</code> 类用于创建网格,抽象类,不允许实例。
	 */
	public class BaseMesh extends Resource {
		/** @private */
		protected var _loaded:Boolean;
		/** @private */
		protected var _subMeshCount:int;
		/** @private */
		public var _boundingBox:BoundBox;
		/** @private */
		public var _boundingSphere:BoundSphere;
		
		
		/**
		 * 获取是否已载入。
		 * @return  是否已载入。
		 */
		public function get loaded():Boolean {
			return _loaded;
		}
		
		/**
		 * 获取SubMesh的个数。
		 * @return SubMesh的个数。
		 */
		public function get subMeshCount():int {
			return _subMeshCount;
		}
		
		/**
		 * 获取网格顶点,请重载此方法。
		 * @return 网格顶点。
		 */
		public function get positions():Vector.<Vector3> {
			throw new Error("未Override,请重载该属性！");
		}
		
		/**
		 * 创建一个 <code>BaseMesh</code> 实例。
		 */
		public function BaseMesh() {
			_loaded = false;
			_boundingBox = new BoundBox(new Vector3(), new Vector3());
			_boundingSphere = new BoundSphere(new Vector3(), 0);
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
		
		/** @private 待开放。*/
		public function Render():void {
			throw new Error("未Override,请重载该方法！");
		}
		
		/** @private 待开放。*/
		public function RenderSubMesh(subMeshIndex:int):void {
			throw new Error("未Override,请重载该方法！");
		}
	}
}