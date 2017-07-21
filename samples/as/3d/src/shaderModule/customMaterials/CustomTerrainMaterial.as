package shaderModule.customMaterials 
{
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.BaseTexture;
	/**
	 * ...
	 * @author 
	 */
	public class CustomTerrainMaterial extends BaseMaterial 
	{
		
		public static var SPLATALPHATEXTURE:int = 0;
		public static var NORMALTEXTURE:int = 1;
		public static var LIGHTMAPTEXTURE:int = 2;
		public static var DIFFUSETEXTURE1:int = 3;
		public static var DIFFUSETEXTURE2:int = 4;
		public static var DIFFUSETEXTURE3:int = 5;
		public static var DIFFUSETEXTURE4:int = 6;
		public static var DIFFUSETEXTURE5:int = 7;
		public static var DIFFUSESCALE1:int = 8;
		public static var DIFFUSESCALE2:int = 9;
		public static var DIFFUSESCALE3:int = 10;
		public static var DIFFUSESCALE4:int = 11;
		public static var DIFFUSESCALE5:int = 12;
		public static var MATERIALAMBIENT:int = 13;
		public static var MATERIALDIFFUSE:int = 14;
		public static var MATERIALSPECULAR:int = 15;
		public static var LIGHTMAPSCALEOFFSET:int = 16;
		
		/**自定义地形材质细节宏定义。*/
		public static var SHADERDEFINE_DETAIL_NUM1:int;
		public static var SHADERDEFINE_DETAIL_NUM2:int;
		public static var SHADERDEFINE_DETAIL_NUM3:int;
		public static var SHADERDEFINE_DETAIL_NUM4:int;
		public static var SHADERDEFINE_DETAIL_NUM5:int;
		public static var SHADERDEFINE_LIGHTMAP:int;
		
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
		
		/**
		 * 获取normal贴图。
		 * @return normal贴图。
		 */
		public function get normalTexture():BaseTexture {
			return _getTexture(NORMALTEXTURE);
		}
		
		/**
		 * 设置normal贴图。
		 * @param value normal贴图。
		 */
		public function set normalTexture(value:BaseTexture):void {
			_setTexture(NORMALTEXTURE, value);
		}
		
		/**
		 * 获取lightMap贴图。
		 * @return lightMap贴图。
		 */
		public function get lightMapTexture():BaseTexture {
			return _getTexture(LIGHTMAPTEXTURE);
		}
		
		/**
		 * 设置lightMap贴图。
		 * @param value lightMap贴图。
		 */
		public function set lightMapTexture(value:BaseTexture):void {
			_setTexture(LIGHTMAPTEXTURE, value);
			_addShaderDefine(CustomTerrainMaterial.SHADERDEFINE_LIGHTMAP);
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
			_setDetailNum(1);
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
			_setDetailNum(2);
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
			_setDetailNum(3);
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
			_setDetailNum(4);
		}
		
		/**
		 * 获取第五层贴图。
		 * @return 第五层贴图。
		 */
		public function get diffuseTexture5():BaseTexture {
			return _getTexture(DIFFUSETEXTURE5);
		}
		
		/**
		 * 设置第五层贴图。
		 * @param value 第五层贴图。
		 */
		public function set diffuseTexture5(value:BaseTexture):void {
			_setTexture(DIFFUSETEXTURE5, value);
			_setDetailNum(5);
		}
		
		public function setDiffuseScale1(scale1:Vector2):void {
			_setVector2(DIFFUSESCALE1, scale1);
		}
		
		public function setDiffuseScale2(scale2:Vector2):void {
			_setVector2(DIFFUSESCALE2, scale2);
		}
		
		public function setDiffuseScale3(scale3:Vector2):void {
			_setVector2(DIFFUSESCALE3, scale3);
		}
		
		public function setDiffuseScale4(scale4:Vector2):void {
			_setVector2(DIFFUSESCALE4, scale4);
		}
		
		public function setDiffuseScale5(scale5:Vector2):void {
			_setVector2(DIFFUSESCALE5, scale5);
		}
		
		public function setLightmapScaleOffset(scaleOffset:Vector4):void {
			_setColor(LIGHTMAPSCALEOFFSET, scaleOffset);
		}
		
		private function _setDetailNum(value:int):void {
			switch (value) {
			case 1: 
				_addShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
				break;
			case 2: 
				_addShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
				break;
			case 3: 
				_addShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
				break;
			case 4: 
				_addShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
				break;
			case 5: 
				_addShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM5);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM1);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM2);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM3);
				_removeShaderDefine(CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM4);
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
		
		
		public function CustomTerrainMaterial() {
			super();
			setShaderName("CustomTerrainShader");
		}
		
	}

}