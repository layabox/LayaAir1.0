package laya.d3.resource.models {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.SkyBoxMaterial;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.shader.ShaderInstance;
	import laya.layagl.LayaGL;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>SkyRenderer</code> 类用于实现天空渲染器。
	 */
	public class SkyRenderer {
		/** @private */
		private var _material:BaseMaterial;
		/** @private */
		private var _mesh:SkyMesh = SkyBox.instance;
		
		/**
		 * 获取材质。
		 * @return 材质。
		 */
		public function get material():BaseMaterial {
			return _material;
		}
		
		/**
		 * 设置材质。
		 * @param 材质。
		 */
		public function set material(value:BaseMaterial):void {
			if (_material !== value) {
				(_material) && (_material._removeReference());
				(value) && (value._addReference());
				_material = value;
			}
		}
		
		/**
		 * 获取网格。
		 * @return 网格。
		 */
		public function get mesh():SkyMesh {
			return _mesh;
		}
		
		/**
		 * 设置网格。
		 * @param 网格。
		 */
		public function set mesh(value:SkyMesh):void {
			if (_mesh !== value) {
				//(_mesh) && (_mesh._removeReference());//TODO:SkyMesh换成Mesh
				//value._addReference();
				_mesh = value;
			}
		}
		
		/**
		 * 创建一个新的 <code>SkyRenderer</code> 实例。
		 */
		public function SkyRenderer() {
		}
		
		/**
		 * @private
		 * 是否可用。
		 */
		public function _isAvailable():Boolean {
			return _material && _mesh;
		}
		
		/**
		 * @private
		 */
		public function _render(state:RenderContext3D):void {
			if (_material && _mesh) {
				var gl:WebGLContext = LayaGL.instance;
				var scene:Scene3D = state.scene;
				var camera:BaseCamera = state.camera;
				
				WebGLContext.setCullFace(gl, false);
				WebGLContext.setDepthFunc(gl, WebGLContext.LEQUAL);
				WebGLContext.setDepthMask(gl, false);
				var shader:ShaderInstance = state.shader = _material._shader.getSubShaderAt(0)._passes[0].withCompile(0, 0, _material._defineDatas.value);//TODO:调整SubShader代码
				var switchShader:Boolean = shader.bind();//纹理需要切换shader时重新绑定 其他uniform不需要
				var switchShaderLoop:Boolean = (Stat.loopCount !== shader._uploadMark);
				
				var uploadScene:Boolean = (shader._uploadScene !== scene) || switchShaderLoop;
				if (uploadScene || switchShader) {
					shader.uploadUniforms(shader._sceneUniformParamsMap, scene._shaderValues, uploadScene);
					shader._uploadScene = scene;
				}
				
				var uploadCamera:Boolean = (shader._uploadCamera !== camera) || switchShaderLoop;
				if (uploadCamera || switchShader) {
					shader.uploadUniforms(shader._cameraUniformParamsMap, camera._shaderValues, uploadCamera);
					shader._uploadCamera = camera;
				}
				
				var uploadMaterial:Boolean = (shader._uploadMaterial !== _material) || switchShaderLoop;
				if (uploadMaterial || switchShader) {
					shader.uploadUniforms(shader._materialUniformParamsMap, _material._shaderValues, uploadMaterial);
					shader._uploadMaterial = _material;
				}
				
				_mesh._bufferState.bind();
				_mesh._render(state);
				WebGLContext.setDepthFunc(gl, WebGLContext.LESS);
				WebGLContext.setDepthMask(gl, true);
			}
		}
		
		/**
		 * @private
		 */
		public function destroy():void {
			if (_material) {
				_material._removeReference();
				_material = null;
			}
		
		}
	
	}

}