package laya.d3.core {
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.layagl.LayaGL;
	import laya.resource.IDestroy;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	
	/**
	 * @private
	 * <code>GeometryElement</code> 类用于实现几何体元素,该类为抽象类。
	 */
	public class GeometryElement implements IDestroy {
		/**@private */
		protected static var _typeCounter:int = 0;
		
		/**@private */
		protected var _destroyed:Boolean;
		
		/**
		 * 获取是否销毁。
		 * @return 是否销毁。
		 */
		public function get destroyed():Boolean {
			return _destroyed;
		}
		
		/**
		 * 创建一个 <code>GeometryElement</code> 实例。
		 */
		public function GeometryElement() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_destroyed = false;
		}
		
		/**
		 * 获取几何体类型。
		 */
		public function _getType():int {
			throw "GeometryElement:must override it.";
		}
		
		/**
		 * @private
		 * @return  是否需要渲染。
		 */
		public function _prepareRender(state:RenderContext3D):Boolean {
			return true;
		}
		
		/**
		 * @private
		 */
		public function _render(state:RenderContext3D):void {
			throw "GeometryElement:must override it.";
		}
		
		/**
		 * 销毁。
		 */
		public function destroy():void {
			if (_destroyed)
				return;
			_destroyed = true;
		}
	}
}