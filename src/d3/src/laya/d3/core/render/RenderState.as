package laya.d3.core.render {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.graphics.StaticBatch;
	import laya.d3.math.BoundFrustum;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Viewport;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>RenderState</code> 类用于实现渲染状态。
	 */
	public class RenderState {
		/** shader宏定义值 */
		public var _shaderDefineValue:int;
		/** @private */
		public var _staticBatch:StaticBatch;
		/** @private */
		public var _batchIndexStart:int;
		/** @private */
		public var _batchIndexEnd:int;
		
		/**渲染区宽度。*/
		public static var clientWidth:int;
		/**渲染区高度。*/
		public static var clientHeight:int;
		/**距上一帧间隔时间。*/
		public var elapsedTime:Number;
		/**循环次数。*/
		public var loopCount:int;
		/**WebGL上下文。*/
		public var context:WebGLContext;
		/**当前场景。*/
		public var scene:BaseScene;
		/**当前渲染3D精灵。*/
		public var owner:Sprite3D;
		/**当前渲染物体。*/
		public var renderElement:RenderElement;
		/**当前摄像机。*/
		public var camera:BaseCamera;
		/**当前视图矩阵。*/
		public var viewMatrix:Matrix4x4;
		/**当前投影矩阵。*/
		public var projectionMatrix:Matrix4x4;
		/**当前投影视图矩阵。*/
		public var projectionViewMatrix:Matrix4x4;
		
		public var cameraBoundingFrustum:BoundFrustum;
		/**当前视口。*/
		public var viewport:Viewport;
		
		/**
		 * 创建一个 <code>RenderState</code> 实例。
		 */
		public function RenderState() {
			_reset();
		}
		
		/**
		 * @private
		 */
		public function _reset():void {
			_shaderDefineValue = 0;
		}
		
		/**
		 * 增加shader宏定义。
		 * @param	define shader宏定义。
		 */
		public function addShaderDefine(define:int):void {
			_shaderDefineValue |= define;
		}
	
	}

}