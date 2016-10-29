package laya.d3.graphics {
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderElement;
	import laya.d3.math.BoundSphere;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RenderObject {
		public var _render:BaseRender;
		public var _renderElements:Vector.<RenderElement>;
		public var _layerMask:int;
		public var _ownerEnable:Boolean;
		public var _enable:Boolean;
		
		public function get _boundingSphere():BoundSphere {
			return _render.boundingSphere;
		}
		
		public function RenderObject() {
			_renderElements = new Vector.<RenderElement>();
		}
	
	}

}