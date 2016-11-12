package laya.d3.core.material {
	import laya.d3.core.particle.Particle3D;
	import laya.d3.core.render.IRenderable;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.math.Matrix4x4;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector2;
	import laya.d3.resource.BaseTexture;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.tempelet.ParticleTemplet3D;
	import laya.d3.shader.ShaderDefines3D;
	import laya.net.Loader;
	import laya.particle.ParticleSetting;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer2D;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ParticleMaterial extends BaseMaterial {
		public static const WORLDMATRIX:String = "MVPMATRIX";
		public static const VIEWMATRIX:String = "MATRIX1";
		public static const PROJECTIONMATRIX:String = "MATRIX2";
		public static const VIEWPORTSCALE:String = "VIEWPORTSCALE";
		public static const CURRENTTIME:String = "CURRENTTIME";
		public static const DURATION:String = "DURATION";
		public static const GRAVITY:String = "GRAVITY";
		public static const ENDVELOCITY:String = "ENDVELOCITY";
		public static const DIFFUSETEXTURE:String = "DIFFUSETEXTURE";
		
		/** @private */
		private static const _diffuseTextureIndex:int = 0;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:ParticleMaterial = new ParticleMaterial();
		
		
		/**
		 * 加载粒子材质。
		 * @param url 粒子材质地址。
		 */
		public static function load(url:String):ParticleMaterial {
			return Laya.loader.create(url,null, null, ParticleMaterial);
		}
		
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
			_setTexture(value, _diffuseTextureIndex, DIFFUSETEXTURE);
		}
		
		public function ParticleMaterial() {
			super();
			_addShaderDefine(ShaderDefines3D.PARTICLE3D);
			setShaderName("PARTICLE");
		}
		
		override public function _setLoopShaderParams(state:RenderState, projectionView:Matrix4x4, worldMatrix:Matrix4x4, mesh:IRenderable, material:BaseMaterial):void {
			var particle:Particle3D = state.owner as Particle3D;
			var templet:ParticleTemplet3D = particle.templet;
			var setting:ParticleSetting = templet.settings;
			
			state.shaderValue.pushValue(DURATION, setting.duration);
			state.shaderValue.pushValue(GRAVITY, setting.gravity);
			state.shaderValue.pushValue(ENDVELOCITY, setting.endVelocity);
			
			state.shaderValue.pushValue(WORLDMATRIX, worldMatrix.elements);
			state.shaderValue.pushValue(VIEWMATRIX, state.viewMatrix.elements);
			state.shaderValue.pushValue(PROJECTIONMATRIX, state.projectionMatrix.elements);
			
			//设置视口尺寸，被用于转换粒子尺寸到屏幕空间的尺寸
			var aspectRadio:Number = state.viewport.width / state.viewport.height;
			var viewportScale:Vector2 = new Vector2(0.5 / aspectRadio, -0.5);
			state.shaderValue.pushValue(VIEWPORTSCALE, viewportScale.elements);
			
			//设置粒子的时间参数，可通过此参数停止粒子动画
			state.shaderValue.pushValue(CURRENTTIME, templet._currentTime);
		}
	
	}

}