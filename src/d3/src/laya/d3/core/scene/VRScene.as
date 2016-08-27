package laya.d3.core.scene {
	import laya.d3.core.VRCamera;
	import laya.d3.core.render.RenderState;
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
		
		/**
		 * @private
		 */
		override public final function renderSubmit():int {
			var gl:WebGLContext = WebGL.mainContext;
			var state:RenderState = _renderState;
			_set3DRenderConfig(gl);//设置3D配置
			(currentCamera.clearColor) && (_clearColor(gl));//清空场景
			_prepareScene(gl, state);
			state.shaderDefs.add(ShaderDefines3D.VR);
			beforeUpate(state);//更新之前
			_updateScene(state);
			lateUpate(state);//更新之前
			
			beforeRender(state);//渲染之前
			_preRenderScene(gl, state);
			
			
			var cameraVR:VRCamera = currentCamera as VRCamera;
			state.viewMatrix = cameraVR.leftViewMatrix;
			state.projectionMatrix = cameraVR.leftProjectionMatrix;
			state.projectionViewMatrix = cameraVR.leftProjectionViewMatrix;
			state.viewport = cameraVR.leftViewport;
			_renderScene(gl, state);
			
			state.viewMatrix = cameraVR.rightViewMatrix;
			state.projectionMatrix = cameraVR.rightProjectionMatrix;
			state.projectionViewMatrix = cameraVR.rightProjectionViewMatrix;
			state.viewport = cameraVR.rightViewport;
			//var preTransformID:int = cameraVR.transform._worldTransformModifyID;
		    //cameraVR.transform._worldTransformModifyID = cameraVR.transform._worldTransformModifyID * 2;//临时
			_renderScene(gl, state);
			//cameraVR.transform._worldTransformModifyID = preTransformID;
			
			lateRender(state);//渲染之后
			
			_set2DRenderConfig(gl);//设置2D配置
			return 1;
		}
	}
}