package laya.d3.core.render {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.scene.Scene;
	import laya.d3.graphics.StaticBatch;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Viewport;
	import laya.d3.shader.Shader3D;
	
	/**
	 * <code>RenderState</code> 类用于实现渲染状态。
	 */
	public class RenderState {
		/**渲染区宽度。*/
		public static var clientWidth:int;
		/**渲染区高度。*/
		public static var clientHeight:int;
		
		/** @private */
		public var _staticBatch:StaticBatch;
		/** @private */
		public var _batchIndexStart:int;
		/** @private */
		public var _batchIndexEnd:int;
		
		/** @private */
		public var _viewMatrix:Matrix4x4;
		/** @private */
		public var _projectionMatrix:Matrix4x4;
		/** @private */
		public var _projectionViewMatrix:Matrix4x4;
		/** @private */
		public var _viewport:Viewport;
		/** @private */
		public var _shader:Shader3D;
		
		
		/**距上一帧间隔时间。*/
		public var elapsedTime:Number;
		/**当前场景。*/
		public var scene:Scene;
		/**当前渲染3D精灵。*/
		public var owner:Sprite3D;
		/**当前渲染物体。*/
		public var renderElement:RenderElement;
		/**当前摄像机。*/
		public var camera:BaseCamera;
	
		
		/**
		 * 创建一个 <code>RenderState</code> 实例。
		 */
		public function RenderState() {
		}
	
	}

}