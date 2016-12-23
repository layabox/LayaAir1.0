package laya.d3.core.material {
	import laya.d3.core.glitter.Glitter;
	import laya.d3.core.particle.Particle3D;
	import laya.d3.core.render.IRenderable;
	import laya.d3.math.Matrix4x4;
	import laya.d3.core.render.RenderState;
	import laya.d3.resource.BaseTexture;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.tempelet.GlitterTemplet;
	import laya.d3.shader.ShaderDefines3D;
	import laya.net.Loader;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.utils.Buffer2D;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GlitterMaterial extends BaseMaterial {
		public static const DIFFUSETEXTURE:int = 0;
		public static const ALBEDO:int = 1;
		public static const CURRENTTIME:int = 2;
		public static const UNICOLOR:int = 3;
		public static const DURATION:int = 4;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:GlitterMaterial = new GlitterMaterial();
		
		/**
		 * 加载闪光材质。
		 * @param url 闪光材质地址。
		 */
		public static function load(url:String):GlitterMaterial {
			return Laya.loader.create(url, null, null, GlitterMaterial);
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
		
		override public function setShaderName(name:String):void {
			super.setShaderName(name);
		}
		
		public function GlitterMaterial() {
			super();
			setShaderName("GLITTER");
		}
		
		override public function _setMaterialShaderParams(state:RenderState, projectionView:Matrix4x4, worldMatrix:Matrix4x4, mesh:IRenderable, material:BaseMaterial):void {
			var glitter:Glitter = state.owner as Glitter;
			var templet:GlitterTemplet = glitter.templet;
			
			_setColor(UNICOLOR, templet.color);
			_setNumber(DURATION, templet.lifeTime);
			_setColor(ALBEDO, templet._albedo);
			_setNumber(CURRENTTIME, templet._currentTime);//设置粒子的时间参数，可通过此参数停止粒子动画
		}
	
	}

}