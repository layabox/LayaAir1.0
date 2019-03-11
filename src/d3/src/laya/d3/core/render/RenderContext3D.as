package laya.d3.core.render {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Viewport;
	import laya.d3.shader.ShaderInstance;
	
	/**
	 * <code>RenderContext3D</code> 类用于实现渲染状态。
	 */
	public class RenderContext3D {
		/** @private */
		public static var _instance:RenderContext3D = new RenderContext3D();
		
		/**渲染区宽度。*/
		public static var clientWidth:int;
		/**渲染区高度。*/
		public static var clientHeight:int;
	
		/** @private */
		public var _batchIndexStart:int;
		/** @private */
		public var _batchIndexEnd:int;
		
		/** @private */
		public var viewMatrix:Matrix4x4;
		/** @private */
		public var projectionMatrix:Matrix4x4;
		/** @private */
		public var projectionViewMatrix:Matrix4x4;
		/** @private */
		public var viewport:Viewport;
		
		/** @private */
		public var scene:Scene3D;
		/** @private */
		public var camera:BaseCamera;
		/** @private */
		public var renderElement:RenderElement;
		/** @private */
		public var shader:ShaderInstance;
		
		/**
		 * 创建一个 <code>RenderContext3D</code> 实例。
		 */
		public function RenderContext3D() {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
	
	}

}