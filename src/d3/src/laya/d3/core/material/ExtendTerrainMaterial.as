package laya.d3.core.material {
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderData;
	import laya.d3.shader.ShaderDefines;
	import laya.webgl.resource.BaseTexture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ExtendTerrainMaterial extends BaseMaterial {
		/**渲染状态_不透明。*/
		public static const RENDERMODE_OPAQUE:int = 1;
		/**渲染状态_透明混合。*/
		public static const RENDERMODE_TRANSPARENT:int = 2;
		
		/**渲染状态_透明混合。*/
		public static const SPLATALPHATEXTURE:int =Shader3D.propertyNameToID("u_SplatAlphaTexture");
		
		public static const DIFFUSETEXTURE1:int =Shader3D.propertyNameToID("u_DiffuseTexture1");
		public static const DIFFUSETEXTURE2:int = Shader3D.propertyNameToID("u_DiffuseTexture2");
		public static const DIFFUSETEXTURE3:int = Shader3D.propertyNameToID("u_DiffuseTexture3");
		public static const DIFFUSETEXTURE4:int = Shader3D.propertyNameToID("u_DiffuseTexture4");
		public static const DIFFUSETEXTURE5:int = Shader3D.propertyNameToID("u_DiffuseTexture5");
		
		public static const DIFFUSESCALEOFFSET1:int = Shader3D.propertyNameToID("u_DiffuseScaleOffset1");
		public static const DIFFUSESCALEOFFSET2:int = Shader3D.propertyNameToID("u_DiffuseScaleOffset2");
		public static const DIFFUSESCALEOFFSET3:int = Shader3D.propertyNameToID("u_DiffuseScaleOffset3");
		public static const DIFFUSESCALEOFFSET4:int = Shader3D.propertyNameToID("u_DiffuseScaleOffset4");
		public static const DIFFUSESCALEOFFSET5:int = Shader3D.propertyNameToID("u_DiffuseScaleOffset5");
		
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
		public static var SHADERDEFINE_DETAIL_NUM5:int;
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_DETAIL_NUM1 = shaderDefines.registerDefine("ExtendTerrain_DETAIL_NUM1");
			SHADERDEFINE_DETAIL_NUM2 = shaderDefines.registerDefine("ExtendTerrain_DETAIL_NUM2");
			SHADERDEFINE_DETAIL_NUM3 = shaderDefines.registerDefine("ExtendTerrain_DETAIL_NUM3");
			SHADERDEFINE_DETAIL_NUM4 = shaderDefines.registerDefine("ExtendTerrain_DETAIL_NUM4");
			SHADERDEFINE_DETAIL_NUM5 = shaderDefines.registerDefine("ExtendTerrain_DETAIL_NUM5");
		}
		
		/**@private */
		private var _enableLighting:Boolean = true;
		
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
		
		/**
		 * 设置第一层贴图。
		 * @param value 第一层贴图。
		 */
		public function set diffuseTexture1(value:BaseTexture):void {
			_shaderValues.setTexture(DIFFUSETEXTURE1, value);
			_setDetailNum(1);
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
			_setDetailNum(2);
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
			_setDetailNum(3);
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
			_setDetailNum(4);
		}
		
		/**
		 * 获取第五层贴图。
		 * @return 第五层贴图。
		 */
		public function get diffuseTexture5():BaseTexture {
			return _shaderValues.getTexture(DIFFUSETEXTURE5);
		}
		
		/**
		 * 设置第五层贴图。
		 * @param value 第五层贴图。
		 */
		public function set diffuseTexture5(value:BaseTexture):void {
			_shaderValues.setTexture(DIFFUSETEXTURE5, value);
			_setDetailNum(5);
		}
		
		private function _setDetailNum(value:int):void {
			switch (value) {
			case 1: 
				_defineDatas.add(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
				break;
			case 2: 
				_defineDatas.add(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
				break;
			case 3: 
				_defineDatas.add(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
				break;
			case 4: 
				_defineDatas.add(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
				break;
			case 5: 
				_defineDatas.add(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				_defineDatas.remove(ExtendTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				break;
			}
		}
		
		public function set diffuseScaleOffset1(scaleOffset1:Vector4):void {
			_shaderValues.setVector(DIFFUSESCALEOFFSET1, scaleOffset1);
		}
		
		public function set diffuseScaleOffset2(scaleOffset2:Vector4):void {
			_shaderValues.setVector(DIFFUSESCALEOFFSET2, scaleOffset2);
		}
		
		public function set diffuseScaleOffset3(scaleOffset3:Vector4):void {
			_shaderValues.setVector(DIFFUSESCALEOFFSET3, scaleOffset3);
		}
		
		public function set diffuseScaleOffset4(scaleOffset4:Vector4):void {
			_shaderValues.setVector(DIFFUSESCALEOFFSET4, scaleOffset4);
		}
		
		public function set diffuseScaleOffset5(scaleOffset5:Vector4):void {
			_shaderValues.setVector(DIFFUSESCALEOFFSET5, scaleOffset5);
		}
		
		/**
		 * 获取是否启用光照。
		 * @return 是否启用光照。
		 */
		public function get enableLighting():Boolean {
			return _enableLighting;
		}
		
		/**
		 * 设置是否启用光照。
		 * @param value 是否启用光照。
		 */
		public function set enableLighting(value:Boolean):void {
			if (_enableLighting !== value) {
				if (value)
					_disablePublicDefineDatas.remove(Scene3D.SHADERDEFINE_POINTLIGHT | Scene3D.SHADERDEFINE_SPOTLIGHT | Scene3D.SHADERDEFINE_DIRECTIONLIGHT);
				else
					_disablePublicDefineDatas.add(Scene3D.SHADERDEFINE_POINTLIGHT | Scene3D.SHADERDEFINE_SPOTLIGHT | Scene3D.SHADERDEFINE_DIRECTIONLIGHT);
				_enableLighting = value;
			}
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
				throw new Error("ExtendTerrainMaterial:renderMode value error.");
			}
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
		
		public function ExtendTerrainMaterial() {
			super();
			setShaderName("ExtendTerrain");
			renderMode = RENDERMODE_OPAQUE;
		}
	
	}

}