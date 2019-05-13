package laya.d3.core.material {
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderDefines;
	import laya.webgl.resource.BaseTexture;
	
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
		
		public static const CULL:int = Shader3D.propertyNameToID("s_Cull");
		public static const BLEND:int = Shader3D.propertyNameToID("s_Blend");
		public static const BLEND_SRC:int = Shader3D.propertyNameToID("s_BlendSrc");
		public static const BLEND_DST:int = Shader3D.propertyNameToID("s_BlendDst");
		public static const DEPTH_TEST:int = Shader3D.propertyNameToID("s_DepthTest");
		public static const DEPTH_WRITE:int = Shader3D.propertyNameToID("s_DepthWrite");
		
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
		
		public function setDiffuseScale1(x:Number, y:Number):void {
			_diffuseScale1.x = x;
			_diffuseScale1.y = y;
			_shaderValues.setVector2(DIFFUSESCALE1, _diffuseScale1);
		}
		
		public function setDiffuseScale2(x:Number, y:Number):void {
			_diffuseScale2.x = x;
			_diffuseScale2.y = y;
			_shaderValues.setVector2(DIFFUSESCALE2, _diffuseScale2);
		}
		
		public function setDiffuseScale3(x:Number, y:Number):void {
			_diffuseScale3.x = x;
			_diffuseScale3.y = y;
			_shaderValues.setVector2(DIFFUSESCALE3, _diffuseScale3);
		}
		
		public function setDiffuseScale4(x:Number, y:Number):void {
			_diffuseScale4.x = x;
			_diffuseScale4.y = y;
			_shaderValues.setVector2(DIFFUSESCALE4, _diffuseScale4);
		}
		
		public function setDetailNum(value:int):void {
			switch (value) {
			case 1: 
				_defineDatas.add(TerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_defineDatas.remove(TerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_defineDatas.remove(TerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				_defineDatas.remove(TerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				break;
			case 2: 
				_defineDatas.add(TerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_defineDatas.remove(TerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_defineDatas.remove(TerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				_defineDatas.remove(TerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				break;
			case 3: 
				_defineDatas.add(TerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				_defineDatas.remove(TerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_defineDatas.remove(TerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_defineDatas.remove(TerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				break;
			case 4: 
				_defineDatas.add(TerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				_defineDatas.remove(TerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_defineDatas.remove(TerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_defineDatas.remove(TerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				break;
			}
		}
		
		public function get ambientColor():Vector3 {
			return _shaderValues.getVector(MATERIALAMBIENT) as Vector3;
		}
		
		public function set ambientColor(value:Vector3):void {
			_shaderValues.setVector3(MATERIALAMBIENT, value);
		}
		
		public function get diffuseColor():Vector3 {
			return _shaderValues.getVector(MATERIALDIFFUSE) as Vector3;
		}
		
		public function set diffuseColor(value:Vector3):void {
			_shaderValues.setVector3(MATERIALDIFFUSE, value);
		}
		
		public function get specularColor():Vector4 {
			return _shaderValues.getVector(MATERIALSPECULAR) as Vector4;
		}
		
		public function set specularColor(value:Vector4):void {
			_shaderValues.setVector(MATERIALSPECULAR, value);
		}
		
		/**
		 * 设置渲染模式。
		 * @return 渲染模式。
		 */
		public function set renderMode(value:int):void {
			switch (value) {
			case RENDERMODE_OPAQUE: 
				renderQueue = BaseMaterial.RENDERQUEUE_OPAQUE;
				depthWrite = true;
				cull = RenderState.CULL_BACK;
				blend = RenderState.BLEND_DISABLE;
				depthTest = RenderState.DEPTHTEST_LESS;
				break;
			case RENDERMODE_TRANSPARENT: 
				renderQueue = BaseMaterial.RENDERQUEUE_OPAQUE;
				depthWrite = false;
				cull = RenderState.CULL_BACK;
				blend = RenderState.BLEND_ENABLE_ALL;
				blendSrc = RenderState.BLENDPARAM_SRC_ALPHA;
				blendDst = RenderState.BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				depthTest = RenderState.DEPTHTEST_LEQUAL;
				break;
			default: 
				throw new Error("TerrainMaterial:renderMode value error.");
			}
		}
		
		/**
		 * 获取第一层贴图。
		 * @return 第一层贴图。
		 */
		public function get diffuseTexture1():BaseTexture {
			return _shaderValues.getTexture(DIFFUSETEXTURE1);
		}
		
		/**
		 * 设置第一层贴图。
		 * @param value 第一层贴图。
		 */
		public function set diffuseTexture1(value:BaseTexture):void {
			_shaderValues.setTexture(DIFFUSETEXTURE1, value);
		}
		
		/**
		 * 获取第二层贴图。
		 * @return 第二层贴图。
		 */
		public function get diffuseTexture2():BaseTexture {
			return _shaderValues.getTexture(DIFFUSETEXTURE2);
		}
		
		/**
		 * 设置第二层贴图。
		 * @param value 第二层贴图。
		 */
		public function set diffuseTexture2(value:BaseTexture):void {
			_shaderValues.setTexture(DIFFUSETEXTURE2, value);
		}
		
		/**
		 * 获取第三层贴图。
		 * @return 第三层贴图。
		 */
		public function get diffuseTexture3():BaseTexture {
			return _shaderValues.getTexture(DIFFUSETEXTURE3);
		}
		
		/**
		 * 设置第三层贴图。
		 * @param value 第三层贴图。
		 */
		public function set diffuseTexture3(value:BaseTexture):void {
			_shaderValues.setTexture(DIFFUSETEXTURE3, value);
		}
		
		/**
		 * 获取第四层贴图。
		 * @return 第四层贴图。
		 */
		public function get diffuseTexture4():BaseTexture {
			return _shaderValues.getTexture(DIFFUSETEXTURE4);
		}
		
		/**
		 * 设置第四层贴图。
		 * @param value 第四层贴图。
		 */
		public function set diffuseTexture4(value:BaseTexture):void {
			_shaderValues.setTexture(DIFFUSETEXTURE4, value);
		}
		
		/**
		 * 获取splatAlpha贴图。
		 * @return splatAlpha贴图。
		 */
		public function get splatAlphaTexture():BaseTexture {
			return _shaderValues.getTexture(SPLATALPHATEXTURE);
		}
		
		/**
		 * 设置splatAlpha贴图。
		 * @param value splatAlpha贴图。
		 */
		public function set splatAlphaTexture(value:BaseTexture):void {
			_shaderValues.setTexture(SPLATALPHATEXTURE, value);
		}
		
		public function get normalTexture():BaseTexture {
			return _shaderValues.getTexture(NORMALTEXTURE);
		}
		
		public function set normalTexture(value:BaseTexture):void {
			_shaderValues.setTexture(NORMALTEXTURE, value);
		}
		
		public function disableLight():void {
			_disablePublicDefineDatas.add(Scene3D.SHADERDEFINE_POINTLIGHT | Scene3D.SHADERDEFINE_SPOTLIGHT | Scene3D.SHADERDEFINE_DIRECTIONLIGHT);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setShaderName(name:String):void {
			super.setShaderName(name);
		}
		
		/**
		 * 设置是否写入深度。
		 * @param value 是否写入深度。
		 */
		public function set depthWrite(value:Boolean):void {
			_shaderValues.setBool(DEPTH_WRITE, value);
		}
		
		/**
		 * 获取是否写入深度。
		 * @return 是否写入深度。
		 */
		public function get depthWrite():Boolean {
			return _shaderValues.getBool(DEPTH_WRITE);
		}
		
		/**
		 * 设置剔除方式。
		 * @param value 剔除方式。
		 */
		public function set cull(value:int):void {
			_shaderValues.setInt(CULL, value);
		}
		
		/**
		 * 获取剔除方式。
		 * @return 剔除方式。
		 */
		public function get cull():int {
			return _shaderValues.getInt(CULL);
		}
		
		/**
		 * 设置混合方式。
		 * @param value 混合方式。
		 */
		public function set blend(value:int):void {
			_shaderValues.setInt(BLEND, value);
		}
		
		/**
		 * 获取混合方式。
		 * @return 混合方式。
		 */
		public function get blend():int {
			return _shaderValues.getInt(BLEND);
		}
		
		/**
		 * 设置混合源。
		 * @param value 混合源
		 */
		public function set blendSrc(value:int):void {
			_shaderValues.setInt(BLEND_SRC, value);
		}
		
		/**
		 * 获取混合源。
		 * @return 混合源。
		 */
		public function get blendSrc():int {
			return _shaderValues.getInt(BLEND_SRC);
		}
		
		/**
		 * 设置混合目标。
		 * @param value 混合目标
		 */
		public function set blendDst(value:int):void {
			_shaderValues.setInt(BLEND_DST, value);
		}
		
		/**
		 * 获取混合目标。
		 * @return 混合目标。
		 */
		public function get blendDst():int {
			return _shaderValues.getInt(BLEND_DST);
		}
		
		/**
		 * 设置深度测试方式。
		 * @param value 深度测试方式
		 */
		public function set depthTest(value:int):void {
			_shaderValues.setInt(DEPTH_TEST, value);
		}
		
		/**
		 * 获取深度测试方式。
		 * @return 深度测试方式。
		 */
		public function get depthTest():int {
			return _shaderValues.getInt(DEPTH_TEST);
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