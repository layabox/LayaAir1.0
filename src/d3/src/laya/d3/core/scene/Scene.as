package laya.d3.core.scene {
	import laya.d3.core.Camera;
	import laya.d3.core.render.RenderState;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>Scene</code> 类用于实现普通场景。
	 */
	public class Scene extends BaseScene {
		
		/**
		 * 创建一个 <code>Scene</code> 实例。
		 */
		public function Scene() {
			super();
		}
		
		/**
		 * @private
		 */
		override public function renderSubmit():int {
			var gl:WebGLContext = WebGL.mainContext;
			var state:RenderState = _renderState;
			_set3DRenderConfig(gl);//设置3D配置
			(currentCamera.clearColor) && (_clearColor(gl));//清空场景
			_prepareScene(gl, state);
			beforeUpate(state);//更新之前
			_updateScene(state);
			lateUpate(state);//更新之前
			
			beforeRender(state);//渲染之前
			_preRenderScene(gl, state);
			var camera:Camera = currentCamera as Camera;
			state.viewMatrix = camera.viewMatrix;
			state.projectionMatrix = camera.projectionMatrix;
			state.projectionViewMatrix = camera.projectionViewMatrix;
			state.viewport = camera.viewport;
			_renderScene(gl, state);
			lateRender(state);//渲染之后
			_set2DRenderConfig(gl);//设置2D配置
			return 1;
		}
	}
}