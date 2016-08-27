package laya.d3.core {
	import laya.d3.math.BoundBox;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FrustumCullingObject {
		public var _boundingSphere:BoundBox;
		public var _component:MeshRender;//待定,应为通用。
		public var _mesh:BaseMesh;
		public var _layerMask:int;
		public var _ownerEnable:Boolean;
		
		public function FrustumCullingObject() {
		
		}
	
	}

}