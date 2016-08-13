package laya.d3.core.render {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.Material;
	
	/**
	 * <code>RenderObject</code> 类用于实现渲染物体。
	 */
	public class RenderObject {
		/**所属队列。*/
		public var renderQneue:RenderQueue;
		/**类型0为默认，1为StaticBatch。*/
		public var type:int = 0;
		/**所属Sprite3D精灵。*/
		public var owner:Sprite3D;
		/**渲染元素。*/
		public var renderElement:IRenderable;
		/**渲染所用材质。*/
		public var material:Material;
		/**属性。*/
		public var tag:Object;
		/**排序ID。*/
		public var mainSortID:int;
		/**三角形个数。*/
		public var triangleCount:int;
		
		/**
		 * 创建一个 <code>RenderObject</code> 实例。
		 */
		public function RenderObject() {
		}
	
	}

}