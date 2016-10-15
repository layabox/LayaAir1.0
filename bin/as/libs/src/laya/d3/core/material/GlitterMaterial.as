package laya.d3.core.material {
	import laya.d3.core.glitter.Glitter;
	import laya.d3.core.glitter.GlitterSetting;
	import laya.d3.core.particle.Particle3D;
	import laya.d3.core.render.IRenderable;
	import laya.d3.math.Matrix4x4;
	import laya.d3.core.render.RenderState;
	import laya.d3.resource.BaseTexture;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.tempelet.GlitterTemplet;
	import laya.d3.shader.ShaderDefines3D;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.utils.Buffer2D;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GlitterMaterial extends BaseMaterial {
		/** @private */
		private static const _diffuseTextureIndex:int = 0;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:GlitterMaterial = new GlitterMaterial();
		
		/**
		 * 获取漫反射贴图。
		 * @return 漫反射贴图。
		 */
		public function get diffuseTexture():BaseTexture {
			return _getTexture(_diffuseTextureIndex);
		}
		
		/**
		 * 设置漫反射贴图。
		 * @param value 漫反射贴图。
		 */
		public function set diffuseTexture(value:BaseTexture):void {
			if (value) {
				_addShaderDefine(ShaderDefines3D.DIFFUSEMAP);
			} else {
				_removeShaderDefine(ShaderDefines3D.DIFFUSEMAP);
			}
			_setTexture(value, _diffuseTextureIndex, Buffer2D.DIFFUSETEXTURE);
		}
		
		public function GlitterMaterial() {
			super();
		}
		
		override public function _setLoopShaderParams(state:RenderState, projectionView:Matrix4x4, worldMatrix:Matrix4x4, mesh:IRenderable, material:BaseMaterial):void {
			var glitter:Glitter = state.owner as Glitter;
			var templet:GlitterTemplet = glitter.templet;
			var setting:GlitterSetting = templet.setting;
			
			state.shaderValue.pushValue(Buffer2D.UNICOLOR, setting.color.elements);
			state.shaderValue.pushValue(Buffer2D.MVPMATRIX, state.projectionViewMatrix.elements);
			state.shaderValue.pushValue(Buffer2D.DURATION, setting.lifeTime);
			state.shaderValue.pushValue(Buffer2D.ALBEDO, templet._albedo.elements);
			state.shaderValue.pushValue(Buffer2D.CURRENTTIME, templet._currentTime);//设置粒子的时间参数，可通过此参数停止粒子动画
		}
	
	}

}