package laya.d3.graphics {
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderElement;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RenderCullingObject {
		public var _render:BaseRender;
		public var _renderElements:Vector.<RenderElement>;
		public var _layerMask:int;
		public var _ownerEnable:Boolean;
		public var _enable:Boolean;
		
		public function get _boundingSphere():BoundSphere {
			return _render.boundingSphere;
		}
		
		public function RenderCullingObject() {
			_renderElements = new Vector.<RenderElement>();
		}
	
	}

}