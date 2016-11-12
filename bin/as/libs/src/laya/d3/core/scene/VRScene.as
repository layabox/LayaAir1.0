package laya.d3.core.scene {
	import laya.d3.core.VRCamera;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.resource.RenderTexture;
	import laya.d3.shader.ShaderDefines3D;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>VRScene</code> 类用于实现VR场景。
	 */
	public class VRScene extends BaseScene {
		
		/**
		 * 创建一个 <code>VRScene</code> 实例。
		 */
		public function VRScene() {
			super();
		}
		
		private function renderCamera(gl:WebGLContext, state:RenderState, cameraVR:VRCamera):void {
			_prepareRenderToRenderState(cameraVR, state);
			state.shaderDefs.add(ShaderDefines3D.VR);
			
			beforeRender(state);//渲染之前
			var renderTarget:RenderTexture = cameraVR.renderTarget;
			if (renderTarget) {
				renderTarget.start();
				Matrix4x4.multiply(_invertYScaleMatrix, cameraVR.leftProjectionMatrix, _invertYProjectionMatrix);
				Matrix4x4.multiply(_invertYScaleMatrix, cameraVR.leftProjectionViewMatrix, _invertYProjectionViewMatrix);
				state.projectionMatrix = _invertYProjectionMatrix;
				state.projectionViewMatrix = _invertYProjectionViewMatrix;
			} else {
				state.projectionMatrix = cameraVR.leftProjectionMatrix;
				state.projectionViewMatrix = cameraVR.leftProjectionViewMatrix;
			}
			state.viewMatrix = cameraVR.leftViewMatrix;
			state.viewport = cameraVR.leftViewport;
			_preRenderScene(gl, state);
			_clear(gl, state);
			_renderScene(gl, state);
			
			if (renderTarget) {
				renderTarget.start();
				Matrix4x4.multiply(_invertYScaleMatrix, cameraVR.rightProjectionMatrix, _invertYProjectionMatrix);
				Matrix4x4.multiply(_invertYScaleMatrix, cameraVR.rightProjectionViewMatrix, _invertYProjectionViewMatrix);
				state.projectionMatrix = _invertYProjectionMatrix;
				state.projectionViewMatrix = _invertYProjectionViewMatrix;
			} else {
				state.projectionMatrix = cameraVR.rightProjectionMatrix;
				state.projectionViewMatrix = cameraVR.rightProjectionViewMatrix;
			}
			state.viewMatrix = cameraVR.rightViewMatrix;
			state.viewport = cameraVR.rightViewport;
			_preRenderScene(gl, state);
			_clear(gl, state);
			_renderScene(gl, state);
			lateRender(state);//渲染之后
			
			(renderTarget) && (renderTarget.end());
		}
		
		/**
		 * @private
		 */
		override public final function renderSubmit():int {
			var gl:WebGLContext = WebGL.mainContext;
			var state:RenderState = _renderState;
			_set3DRenderConfig(gl);//设置3D配置
			
			for (var i:int = 0, n:int = _cameraPool.length; i < n; i++) {
				var cameraVR:VRCamera = _cameraPool[i] as VRCamera;
				if (cameraVR.enable)
					renderCamera(gl, state, cameraVR);
				
			}
			_set2DRenderConfig(gl);//设置2D配置
			return 1;
		}
	}
}