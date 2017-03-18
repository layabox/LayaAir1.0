package laya.d3.core.scene {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.VRCamera;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.resource.RenderTexture;
	import laya.d3.shader.ShaderCompile3D;
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
		
		protected override function _renderCamera(gl:WebGLContext, state:RenderState, baseCamera:BaseCamera):void {
			var vrCamera:VRCamera = baseCamera as VRCamera; 
			state.camera = vrCamera;
			vrCamera._prepareCameraToRender();
			//_prepareRenderToRenderState(cameraVR, state);
			state.scene.addShaderDefine(ShaderCompile3D.SHADERDEFINE_VR);
			
			beforeRender(state);//渲染之前
			var leftViewMatrix:Matrix4x4 = vrCamera.leftViewMatrix;
			var leftProjectMatrix:Matrix4x4;
			state._viewMatrix = leftViewMatrix;
			var renderTarget:RenderTexture = vrCamera.renderTarget;
			if (renderTarget) {
				renderTarget.start();
				Matrix4x4.multiply(_invertYScaleMatrix, vrCamera.leftProjectionMatrix, _invertYProjectionMatrix);
				Matrix4x4.multiply(_invertYScaleMatrix, vrCamera.leftProjectionViewMatrix, _invertYProjectionViewMatrix);
				leftProjectMatrix=state._projectionMatrix = _invertYProjectionMatrix;
				state._projectionViewMatrix = _invertYProjectionViewMatrix;
			} else {
				leftProjectMatrix=state._projectionMatrix = vrCamera.leftProjectionMatrix;
				state._projectionViewMatrix = vrCamera.leftProjectionViewMatrix;
			}
			
			vrCamera._prepareCameraViewProject(leftViewMatrix, leftProjectMatrix);
			state._boundFrustum = vrCamera.leftBoundFrustum;
			state._viewport = vrCamera.leftViewport;
			_preRenderScene(gl, state);
			_clear(gl, state);
			_renderScene(gl, state);
			
			var rightViewMatrix:Matrix4x4 = vrCamera.rightViewMatrix;
			var rightProjectMatrix:Matrix4x4;
			state._viewMatrix = rightViewMatrix;
			if (renderTarget) {
				renderTarget.start();
				Matrix4x4.multiply(_invertYScaleMatrix, vrCamera.rightProjectionMatrix, _invertYProjectionMatrix);
				Matrix4x4.multiply(_invertYScaleMatrix, vrCamera.rightProjectionViewMatrix, _invertYProjectionViewMatrix);
				state._projectionMatrix = _invertYProjectionMatrix;
				rightProjectMatrix=state._projectionViewMatrix = _invertYProjectionViewMatrix;
			} else {
				state._projectionMatrix = vrCamera.rightProjectionMatrix;
				rightProjectMatrix=state._projectionViewMatrix = vrCamera.rightProjectionViewMatrix;
			}
			
			vrCamera._prepareCameraViewProject(rightViewMatrix, rightProjectMatrix);
			state._boundFrustum = vrCamera.rightBoundFrustum;
			state._viewport = vrCamera.rightViewport;
			_preRenderScene(gl, state);
			_clear(gl, state);
			_renderScene(gl, state);
			lateRender(state);//渲染之后
			
			(renderTarget) && (renderTarget.end());
		}
	}
}