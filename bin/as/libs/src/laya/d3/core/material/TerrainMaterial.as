package laya.d3.core.material {
	import laya.d3.core.render.RenderQueue;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.BaseTexture;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ShaderDefines;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TerrainMaterial extends BaseMaterial {
		/**渲染状态_不透明。*/
		public static const RENDERMODE_OPAQUE:int = 1;
		/**渲染状态_透明混合。*/
		public static const RENDERMODE_TRANSPARENT:int = 2;
		
		/**渲染状态_透明混合。*/
		public static const SPLATALPHATEXTURE:int = 0;
		public static const NORMALTEXTURE:int = 1;
		public static const DIFFUSETEXTURE1:int = 2;
		public static const DIFFUSETEXTURE2:int = 3;
		public static const DIFFUSETEXTURE3:int = 4;
		public static const DIFFUSETEXTURE4:int = 5;
		public static const DIFFUSESCALE1:int = 6;
		public static const DIFFUSESCALE2:int = 7;
		public static const DIFFUSESCALE3:int = 8;
		public static const DIFFUSESCALE4:int = 9;
		public static const MATERIALAMBIENT:int = 10;
		public static const MATERIALDIFFUSE:int = 11;
		public static const MATERIALSPECULAR:int = 12;
		
		/**地形细节宏定义。*/
		public static var SHADERDEFINE_DETAIL_NUM1:int;
		public static var SHADERDEFINE_DETAIL_NUM2:int;
		public static var SHADERDEFINE_DETAIL_NUM3:int;
		public static var SHADERDEFINE_DETAIL_NUM4:int;
		
		private var _diffuseScale1:Vector2;
		private var _diffuseScale2:Vector2;
		private var _diffuseScale3:Vector2;
		private var _diffuseScale4:Vector2;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:TerrainMaterial = new TerrainMaterial();
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_DETAIL_NUM1 = shaderDefines.registerDefine("DETAIL_NUM1");
			SHADERDEFINE_DETAIL_NUM2 = shaderDefines.registerDefine("DETAIL_NUM2");
			SHADERDEFINE_DETAIL_NUM4 = shaderDefines.registerDefine("DETAIL_NUM4");
			SHADERDEFINE_DETAIL_NUM3 = shaderDefines.registerDefine("DETAIL_NUM3");
		}
		
		/**
		 * 加载闪光材质。
		 * @param url 闪光材质地址。
		 */
		public static function load(url:String):TerrainMaterial {
			return Laya.loader.create(url, null, null, TerrainMaterial);
		}
		
		public function setDiffuseScale1(x:Number, y:Number):void {
			_diffuseScale1.x = x;
			_diffuseScale1.y = y;
			_setColor(DIFFUSESCALE1, _diffuseScale1);
		}
		
		public function setDiffuseScale2(x:Number, y:Number):void {
			_diffuseScale2.x = x;
			_diffuseScale2.y = y;
			_setColor(DIFFUSESCALE2, _diffuseScale2);
		}
		
		public function setDiffuseScale3(x:Number, y:Number):void {
			_diffuseScale3.x = x;
			_diffuseScale3.y = y;
			_setColor(DIFFUSESCALE3, _diffuseScale3);
		}
		
		public function setDiffuseScale4(x:Number, y:Number):void {
			_diffuseScale4.x = x;
			_diffuseScale4.y = y;
			_setColor(DIFFUSESCALE4, _diffuseScale4);
		}
		
		public function setDetailNum(value:int):void {
			switch (value) {
			case 1: 
				_addShaderDefine(TerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_removeShaderDefine(TerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_removeShaderDefine(TerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				_removeShaderDefine(TerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				break;
			case 2: 
				_addShaderDefine(TerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_removeShaderDefine(TerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_removeShaderDefine(TerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				_removeShaderDefine(TerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				break;
			case 3: 
				_addShaderDefine(TerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				_removeShaderDefine(TerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_removeShaderDefine(TerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_removeShaderDefine(TerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				break;
			case 4: 
				_addShaderDefine(TerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				_removeShaderDefine(TerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_removeShaderDefine(TerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_removeShaderDefine(TerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				break;
			}
		}
		
		public function get ambientColor():Vector3 {
			return _getColor(MATERIALAMBIENT);
		}
		
		public function set ambientColor(value:Vector3):void {
			_setColor(MATERIALAMBIENT, value);
		}
		
		public function get diffuseColor():Vector3 {
			return _getColor(MATERIALDIFFUSE);
		}
		
		public function set diffuseColor(value:Vector3):void {
			_setColor(MATERIALDIFFUSE, value);
		}
		
		public function get specularColor():Vector4 {
			return _getColor(MATERIALSPECULAR);
		}
		
		public function set specularColor(value:Vector4):void {
			_setColor(MATERIALSPECULAR, value);
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
				depthTest = DEPTHTEST_LESS;
				break;
			case RENDERMODE_TRANSPARENT: 
				renderQueue = RenderQueue.OPAQUE;
				depthWrite = false;
				cull = CULL_BACK;
				blend = BLEND_ENABLE_ALL;
				srcBlend = BLENDPARAM_SRC_ALPHA;
				dstBlend = BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				depthTest = DEPTHTEST_LEQUAL;
				break;
			default: 
				throw new Error("TerrainMaterial:renderMode value error.");
			}
			_conchMaterial && _conchMaterial.setRenderMode(value);//NATIVE
		}
		
		/**
		 * 获取第一层贴图。
		 * @return 第一层贴图。
		 */
		public function get diffuseTexture1():BaseTexture {
			return _getTexture(DIFFUSETEXTURE1);
		}
		
		/**
		 * 设置第一层贴图。
		 * @param value 第一层贴图。
		 */
		public function set diffuseTexture1(value:BaseTexture):void {
			_setTexture(DIFFUSETEXTURE1, value);
		}
		
		/**
		 * 获取第二层贴图。
		 * @return 第二层贴图。
		 */
		public function get diffuseTexture2():BaseTexture {
			return _getTexture(DIFFUSETEXTURE2);
		}
		
		/**
		 * 设置第二层贴图。
		 * @param value 第二层贴图。
		 */
		public function set diffuseTexture2(value:BaseTexture):void {
			_setTexture(DIFFUSETEXTURE2, value);
		}
		
		/**
		 * 获取第三层贴图。
		 * @return 第三层贴图。
		 */
		public function get diffuseTexture3():BaseTexture {
			return _getTexture(DIFFUSETEXTURE3);
		}
		
		/**
		 * 设置第三层贴图。
		 * @param value 第三层贴图。
		 */
		public function set diffuseTexture3(value:BaseTexture):void {
			_setTexture(DIFFUSETEXTURE3, value);
		}
		
		/**
		 * 获取第四层贴图。
		 * @return 第四层贴图。
		 */
		public function get diffuseTexture4():BaseTexture {
			return _getTexture(DIFFUSETEXTURE4);
		}
		
		/**
		 * 设置第四层贴图。
		 * @param value 第四层贴图。
		 */
		public function set diffuseTexture4(value:BaseTexture):void {
			_setTexture(DIFFUSETEXTURE4, value);
		}
		
		/**
		 * 获取splatAlpha贴图。
		 * @return splatAlpha贴图。
		 */
		public function get splatAlphaTexture():BaseTexture {
			return _getTexture(SPLATALPHATEXTURE);
		}
		
		/**
		 * 设置splatAlpha贴图。
		 * @param value splatAlpha贴图。
		 */
		public function set splatAlphaTexture(value:BaseTexture):void {
			_setTexture(SPLATALPHATEXTURE, value);
		}
		
		public function get normalTexture():BaseTexture {
			return _getTexture(NORMALTEXTURE);
		}
		
		public function set normalTexture(value:BaseTexture):void {
			_setTexture(NORMALTEXTURE, value);
		}
		
		public function disableLight():void {
			_addDisablePublicShaderDefine(ShaderCompile3D.SHADERDEFINE_POINTLIGHT | ShaderCompile3D.SHADERDEFINE_SPOTLIGHT | ShaderCompile3D.SHADERDEFINE_DIRECTIONLIGHT);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setShaderName(name:String):void {
			super.setShaderName(name);
		}
		
		public function TerrainMaterial() {
			super();
			setShaderName("Terrain");
			renderMode = RENDERMODE_OPAQUE;
			_diffuseScale1 = new Vector2();
			_diffuseScale2 = new Vector2();
			_diffuseScale3 = new Vector2();
			_diffuseScale4 = new Vector2();
			ambientColor = new Vector3(0.6, 0.6, 0.6);
			diffuseColor = new Vector3(1.0, 1.0, 1.0);
			specularColor = new Vector4(0.2, 0.2, 0.2, 32.0);
		}
	
	}

}