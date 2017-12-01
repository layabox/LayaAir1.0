package laya.d3.core.material {
	import laya.d3.core.render.RenderQueue;
	import laya.d3.math.Vector4;
	import laya.d3.resource.BaseTexture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GlitterMaterial extends BaseMaterial {
		/**渲染状态_不透明。*/
		public static const RENDERMODE_OPAQUE:int = 1;
		/**渲染状态_不透明_双面。*/
		public static const RENDERMODE_OPAQUEDOUBLEFACE:int = 2;
		///**渲染状态_透明测试。*/
		//public static const RENDERMODE_CUTOUT:int = 3;
		///**渲染状态_透明测试_双面。*/
		//public static const RENDERMODE_CUTOUTDOUBLEFACE:int = 4;
		/**渲染状态_透明混合。*/
		public static const RENDERMODE_TRANSPARENT:int = 13;
		/**渲染状态_透明混合_双面。*/
		public static const RENDERMODE_TRANSPARENTDOUBLEFACE:int = 14;
		/**渲染状态_加色法混合。*/
		public static const RENDERMODE_ADDTIVE:int = 15;
		/**渲染状态_加色法混合_双面。*/
		public static const RENDERMODE_ADDTIVEDOUBLEFACE:int = 16;
		/**渲染状态_只读深度_透明混合。*/
		public static const RENDERMODE_DEPTHREAD_TRANSPARENT:int = 5;
		/**渲染状态_只读深度_透明混合_双面。*/
		public static const RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE:int = 6;
		/**渲染状态_只读深度_加色法混合。*/
		public static const RENDERMODE_DEPTHREAD_ADDTIVE:int = 7;
		/**渲染状态_只读深度_加色法混合_双面。*/
		public static const RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE:int = 8;
		/**渲染状态_无深度_透明混合。*/
		public static const RENDERMODE_NONDEPTH_TRANSPARENT:int = 9;
		/**渲染状态_无深度_透明混合_双面。*/
		public static const RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE:int = 10;
		/**渲染状态_无深度_加色法混合。*/
		public static const RENDERMODE_NONDEPTH_ADDTIVE:int = 11;
		/**渲染状态_无深度_加色法混合_双面。*/
		public static const RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE:int = 12;
		
		public static const DIFFUSETEXTURE:int = 1;
		public static const ALBEDO:int = 2;
		public static const UNICOLOR:int = 3;
		
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
		 * 设置渲染模式。
		 * @return 渲染模式。
		 */
		public function set renderMode(value:int):void {
			switch (value) {
			case RENDERMODE_OPAQUE: 
				renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_DISABLE;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				break;
			case RENDERMODE_OPAQUEDOUBLEFACE: 
				renderQueue = RenderQueue.OPAQUE;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_DISABLE;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				break;
			//case RENDERMODE_CUTOUT: 
			//depthWrite = true;
			//cull = CULL_BACK;
			//blend = BLEND_DISABLE;
			//_renderQueue = RenderQueue.OPAQUE;
			////_addShaderDefine(ShaderDefines3D.ALPHATEST);
			//event(Event.RENDERQUEUE_CHANGED, this);
			//break;
			//case RENDERMODE_CUTOUTDOUBLEFACE: 
			//_renderQueue = RenderQueue.OPAQUE;
			//depthWrite = true;
			//cull = CULL_NONE;
			//blend = BLEND_DISABLE;
			////_addShaderDefine(ShaderDefines3D.ALPHATEST);
			//event(Event.RENDERQUEUE_CHANGED, this);
			//break;
			case RENDERMODE_TRANSPARENT: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);;
				break;
			case RENDERMODE_TRANSPARENTDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				break;
			case RENDERMODE_ADDTIVE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				break;
			case RENDERMODE_ADDTIVEDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = true;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				break;
			case RENDERMODE_DEPTHREAD_TRANSPARENT: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				break;
			case RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				break;
			case RENDERMODE_DEPTHREAD_ADDTIVE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				break;
			case RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthWrite = false;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				break;
			case RENDERMODE_NONDEPTH_TRANSPARENT: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthTest = DEPTHTEST_LESS;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				break;
			case RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthTest = DEPTHTEST_LESS;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				break;
			case RENDERMODE_NONDEPTH_ADDTIVE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthTest = DEPTHTEST_LESS;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				break;
			case RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE: 
				renderQueue = RenderQueue.TRANSPARENT;
				depthTest = DEPTHTEST_LESS;
				cull = CULL_NONE;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE;
				//_removeShaderDefine(ShaderDefines3D.ALPHATEST);
				break;
			default: 
				throw new Error("Material:renderMode value error.");
			}
			
			_conchMaterial && _conchMaterial.setRenderMode(value);//NATIVE
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
			_setTexture(DIFFUSETEXTURE, value);
		}
		
		/**
		 * 获取颜色。
		 * @return 漫反射颜色。
		 */
		public function get color():Vector4 {
			return _getColor(UNICOLOR);
		}
		
		/**
		 * 设置颜色。
		 * @param value 颜色。
		 */
		public function set color(value:Vector4):void {
			_setColor(UNICOLOR, value);
		}
		
		/**
		 * 获取反射率。
		 * @return 反射率。
		 */
		public function get albedo():Vector4 {
			return _getColor(ALBEDO);
		}
		
		/**
		 * 设置反射率。
		 * @param value 反射率。
		 */
		public function set albedo(value:Vector4):void {
			_setColor(ALBEDO, value);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setShaderName(name:String):void {
			super.setShaderName(name);
		}
		
		public function GlitterMaterial() {
			super();
			setShaderName("GLITTER");
			renderMode = RENDERMODE_OPAQUE;
			_setColor(UNICOLOR, new Vector4(1.0, 1.0, 1.0, 1.0));
			_setColor(ALBEDO, new Vector4(1.0, 1.0, 1.0, 1.0));
		}
	
	}

}