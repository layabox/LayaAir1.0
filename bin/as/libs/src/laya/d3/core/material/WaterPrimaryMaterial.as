package laya.d3.core.material {
	import laya.d3.math.Vector4;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderDefines;
	import laya.webgl.resource.BaseTexture;
	
	/**
	 * ...
	 * @author
	 */
	public class WaterPrimaryMaterial extends BaseMaterial{
		
		public static const HORIZONCOLOR:int = Shader3D.propertyNameToID("u_HorizonColor");
		public static const MAINTEXTURE:int = Shader3D.propertyNameToID("u_MainTexture");
		public static const NORMALTEXTURE:int = Shader3D.propertyNameToID("u_NormalTexture");
		public static const WAVESCALE:int = Shader3D.propertyNameToID("u_WaveScale");
		public static const WAVESPEED:int = Shader3D.propertyNameToID("u_WaveSpeed");
		
		public static var SHADERDEFINE_MAINTEXTURE:int;
		public static var SHADERDEFINE_NORMALTEXTURE:int;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:WaterPrimaryMaterial = new WaterPrimaryMaterial();
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_MAINTEXTURE = shaderDefines.registerDefine("MAINTEXTURE");
			SHADERDEFINE_NORMALTEXTURE = shaderDefines.registerDefine("NORMALTEXTURE");
		}
		
		/**
		 * 获取地平线颜色。
		 * @return 地平线颜色。
		 */
		public function get horizonColor():Vector4 {
			return _shaderValues.getVector(HORIZONCOLOR) as Vector4;
		}
		
		/**
		 * 设置地平线颜色。
		 * @param value 地平线颜色。
		 */
		public function set horizonColor(value:Vector4):void {
			_shaderValues.setVector(HORIZONCOLOR, value);
		}
		
		/**
		 * 获取主贴图。
		 * @return 主贴图。
		 */
		public function get mainTexture():BaseTexture {
			return _shaderValues.getTexture(MAINTEXTURE);
		}
		
		/**
		 * 设置主贴图。
		 * @param value 主贴图。
		 */
		public function set mainTexture(value:BaseTexture):void {
			if (value)
				_defineDatas.add(WaterPrimaryMaterial.SHADERDEFINE_MAINTEXTURE);
			else
				_defineDatas.remove(WaterPrimaryMaterial.SHADERDEFINE_MAINTEXTURE);
			_shaderValues.setTexture(MAINTEXTURE, value);
		}
		
		/**
		 * 获取法线贴图。
		 * @return 法线贴图。
		 */
		public function get normalTexture():BaseTexture {
			return _shaderValues.getTexture(NORMALTEXTURE);
		}
		
		/**
		 * 设置法线贴图。
		 * @param value 法线贴图。
		 */
		public function set normalTexture(value:BaseTexture):void {
			if (value)
				_defineDatas.add(WaterPrimaryMaterial.SHADERDEFINE_NORMALTEXTURE);
			else
				_defineDatas.remove(WaterPrimaryMaterial.SHADERDEFINE_NORMALTEXTURE);
			_shaderValues.setTexture(NORMALTEXTURE, value);
		}
		
		/**
		 * 获取波动缩放系数。
		 * @return 波动缩放系数。
		 */
		public function get waveScale():Number {
			return _shaderValues.getNumber(WAVESCALE);
		}
		
		/**
		 * 设置波动缩放系数。
		 * @param value 波动缩放系数。
		 */
		public function set waveScale(value:Number):void {
			_shaderValues.setNumber(WAVESCALE, value);
		}
		
		/**
		 * 获取波动速率。
		 * @return 波动速率。
		 */
		public function get waveSpeed():Vector4 {
			return _shaderValues.getVector(WAVESPEED) as Vector4;
		}
		
		/**
		 * 设置波动速率。
		 * @param value 波动速率。
		 */
		public function set waveSpeed(value:Vector4):void {
			_shaderValues.setVector(WAVESPEED, value);
		}
		
		
		public function WaterPrimaryMaterial() {
			super();
			setShaderName("WaterPrimary");
			_shaderValues.setVector(HORIZONCOLOR, new Vector4(0.172 , 0.463 , 0.435 , 0));
			_shaderValues.setNumber(WAVESCALE, 0.15);
			_shaderValues.setVector(WAVESPEED, new Vector4(19, 9, -16, -7));
		}
	}

}