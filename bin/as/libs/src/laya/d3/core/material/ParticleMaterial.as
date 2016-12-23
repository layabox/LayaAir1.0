package laya.d3.core.material {
	import laya.d3.core.particle.Particle3D;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.resource.BaseTexture;
	import laya.d3.resource.tempelet.ParticleTemplet3D;
	import laya.d3.shader.ShaderDefines3D;
	import laya.particle.ParticleSetting;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ParticleMaterial extends BaseMaterial {
		public static const VIEWPORTSCALE:int = 0;//TODO:
		public static const CURRENTTIME:int = 1;
		public static const DURATION:int = 2;
		public static const GRAVITY:int = 3;
		public static const ENDVELOCITY:int = 4;
		public static const DIFFUSETEXTURE:int = 5;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:ParticleMaterial = new ParticleMaterial();
		
		/**
		 * 加载粒子材质。
		 * @param url 粒子材质地址。
		 */
		public static function load(url:String):ParticleMaterial {
			return Laya.loader.create(url, null, null, ParticleMaterial);
		}
		
		/**
		 * 获取漫反射贴图。
		 * @return 漫反射贴图。
		 */
		public function get diffuseTexture():BaseTexture {
			return _getTexture(DIFFUSETEXTURE);
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
			_setTexture(DIFFUSETEXTURE, value);
		}
		
		public function ParticleMaterial() {
			super();
			_addShaderDefine(ShaderDefines3D.PARTICLE3D);
			setShaderName("PARTICLE");
		}
		
		override public function _setMaterialShaderParams(state:RenderState, projectionView:Matrix4x4, worldMatrix:Matrix4x4, mesh:IRenderable, material:BaseMaterial):void {
			var particle:Particle3D = state.owner as Particle3D;
			var templet:ParticleTemplet3D = particle.templet;
			var setting:ParticleSetting = templet.settings;
			
			_setNumber(DURATION, setting.duration);
			_setBuffer(GRAVITY, setting.gravity);
			_setNumber(ENDVELOCITY, setting.endVelocity);
			
			//设置视口尺寸，被用于转换粒子尺寸到屏幕空间的尺寸
			var aspectRadio:Number = state.viewport.width / state.viewport.height;
			var viewportScale:Vector2 = new Vector2(0.5 / aspectRadio, -0.5);
			_setVector2(VIEWPORTSCALE, viewportScale);
			
			//设置粒子的时间参数，可通过此参数停止粒子动画
			_setNumber(CURRENTTIME, templet._currentTime);
		}
	
	}

}