package laya.d3.graphics {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.BoundSphere;
	import laya.renders.Render;
	import laya.runtime.IConchRenderObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RenderObject {
		/** @private */
		public var _owner:Sprite3D;
		
		/** @private */
		public var _render:BaseRender;
		/** @private */
		public var _renderElements:Vector.<RenderElement>;
		/** @private */
		public var _layerMask:int;
		/** @private */
		public var _ownerEnable:Boolean;
		/** @private */
		public var _enable:Boolean;
		
		/** @private */
		public var _conchRenderObject:IConchRenderObject;//NATIVE
		
		public function get _boundingSphere():BoundSphere {
			return _render.boundingSphere;
		}
		
		public function RenderObject(owner:Sprite3D) {
			_owner = owner;
			_renderElements = new Vector.<RenderElement>();
			if (Render.isConchNode) {//NATIVE
				_conchRenderObject = __JS__("new ConchRenderObject()");
			}
		}
		
		/**
		 * @private
		 */
		public function _renderRuntime(state:RenderState):void {/**NATIVE*/
			var renderElements:Vector.<RenderElement> = _renderElements;
			for (var i:int = 0, n:int = renderElements.length; i < n; i++) {
				renderElements[i].renderObj._renderRuntime(_conchRenderObject, renderElements[i], state);
			}
		}
	
	}

}