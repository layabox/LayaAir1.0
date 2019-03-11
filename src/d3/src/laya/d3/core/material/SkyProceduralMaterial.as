package laya.d3.core.material {
	import laya.d3.math.Vector4;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderDefines;
	
	/**
	 * <code>SkyProceduralMaterial</code> 类用于实现SkyProceduralMaterial材质。
	 */
	public class SkyProceduralMaterial extends BaseMaterial {
		/** 太阳_无*/
		public static const SUN_NODE:int = 0;
		/** 太阳_高质量*/
		public static const SUN_HIGH_QUALITY:int = 1;
		/** 太阳_精简*/
		public static const SUN_SIMPLE:int = 2;
		
		/**@private */
		public static const SUNSIZE:int = Shader3D.propertyNameToID("u_SunSize");
		/**@private */
		public static const SUNSIZECONVERGENCE:int = Shader3D.propertyNameToID("u_SunSizeConvergence");
		/**@private */
		public static const ATMOSPHERETHICKNESS:int = Shader3D.propertyNameToID("u_AtmosphereThickness");
		/**@private */
		public static const SKYTINT:int = Shader3D.propertyNameToID("u_SkyTint");
		/**@private */
		public static const GROUNDTINT:int = Shader3D.propertyNameToID("u_GroundTint");
		/**@private */
		public static const EXPOSURE:int = Shader3D.propertyNameToID("u_Exposure");
		
		/**@private */
		public static var SHADERDEFINE_SUN_HIGH_QUALITY:int;
		/**@private */
		public static var SHADERDEFINE_SUN_SIMPLE:int;
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:SkyProceduralMaterial = new SkyProceduralMaterial();
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_SUN_HIGH_QUALITY = shaderDefines.registerDefine("SUN_HIGH_QUALITY");
			SHADERDEFINE_SUN_SIMPLE = shaderDefines.registerDefine("SUN_SIMPLE");
		}
		
		/**@private */
		private var _sunDisk:int;
		
		/**
		 * 获取太阳状态。
		 * @return  太阳状态。
		 */
		public function get sunDisk():int {
			return _sunDisk;
		}
		
		/**
		 * 设置太阳状态。
		 * @param value 太阳状态。
		 */
		public function set sunDisk(value:int):void {
			switch (value) {
			case SUN_HIGH_QUALITY: 
				_defineDatas.remove(SHADERDEFINE_SUN_SIMPLE);
				_defineDatas.add(SHADERDEFINE_SUN_HIGH_QUALITY);
				break;
			case SUN_SIMPLE: 
				_defineDatas.remove(SHADERDEFINE_SUN_HIGH_QUALITY);
				_defineDatas.add(SHADERDEFINE_SUN_SIMPLE);
				break;
			case SUN_NODE: 
				_defineDatas.remove(SHADERDEFINE_SUN_HIGH_QUALITY);
				_defineDatas.remove(SHADERDEFINE_SUN_SIMPLE);
				break;
			default: 
				throw "SkyBoxProceduralMaterial: unknown sun value.";
			}
			_sunDisk = value;
		}
		
		/**
		 * 获取太阳尺寸,范围是0到1。
		 * @return  太阳尺寸。
		 */
		public function get sunSize():Number {
			return _shaderValues.getNumber(SUNSIZE);
		}
		
		/**
		 * 设置太阳尺寸,范围是0到1。
		 * @param value 太阳尺寸。
		 */
		public function set sunSize(value:Number):void {
			value = Math.min(Math.max(0.0, value), 1.0);
			_shaderValues.setNumber(SUNSIZE, value);
		}
		
		/**
		 * 获取太阳尺寸收缩,范围是0到20。
		 * @return  太阳尺寸收缩。
		 */
		public function get sunSizeConvergence():Number {
			return _shaderValues.getNumber(SUNSIZECONVERGENCE);
		}
		
		/**
		 * 设置太阳尺寸收缩,范围是0到20。
		 * @param value 太阳尺寸收缩。
		 */
		public function set sunSizeConvergence(value:Number):void {
			value = Math.min(Math.max(0.0, value), 20.0);
			_shaderValues.setNumber(SUNSIZECONVERGENCE, value);
		}
		
		/**
		 * 获取大气厚度,范围是0到5。
		 * @return  大气厚度。
		 */
		public function get atmosphereThickness():Number {
			return _shaderValues.getNumber(ATMOSPHERETHICKNESS);
		}
		
		/**
		 * 设置大气厚度,范围是0到5。
		 * @param value 大气厚度。
		 */
		public function set atmosphereThickness(value:Number):void {
			value = Math.min(Math.max(0.0, value), 5.0);
			_shaderValues.setNumber(ATMOSPHERETHICKNESS, value);
		}
		
		/**
		 * 获取天空颜色。
		 * @return  天空颜色。
		 */
		public function get skyTint():Vector4 {
			return _shaderValues.getVector(SKYTINT) as Vector4;
		}
		
		/**
		 * 设置天空颜色。
		 * @param value 天空颜色。
		 */
		public function set skyTint(value:Vector4):void {
			_shaderValues.setVector(SKYTINT, value);
		}
		
		/**
		 * 获取地面颜色。
		 * @return  地面颜色。
		 */
		public function get groundTint():Vector4 {
			return _shaderValues.getVector(GROUNDTINT) as Vector4;
		}
		
		/**
		 * 设置地面颜色。
		 * @param value 地面颜色。
		 */
		public function set groundTint(value:Vector4):void {
			_shaderValues.setVector(GROUNDTINT, value);
		}
		
		/**
		 * 获取曝光强度,范围是0到8。
		 * @return 曝光强度。
		 */
		public function get exposure():Number {
			return _shaderValues.getNumber(EXPOSURE);
		}
		
		/**
		 * 设置曝光强度,范围是0到8。
		 * @param value 曝光强度。
		 */
		public function set exposure(value:Number):void {
			value = Math.min(Math.max(0.0, value), 8.0);
			_shaderValues.setNumber(EXPOSURE, value);
		}
		
		/**
		 * 创建一个 <code>SkyProceduralMaterial</code> 实例。
		 */
		public function SkyProceduralMaterial() {
			super();
			setShaderName("SkyBoxProcedural");
			sunDisk = SUN_HIGH_QUALITY;
			sunSize = 0.04;
			sunSizeConvergence = 5;
			atmosphereThickness = 1.0;
			skyTint = new Vector4(0.5, 0.5, 0.5, 1.0);
			groundTint = new Vector4(0.369, 0.349, 0.341, 1.0);
			exposure = 1.3;
		}
	
	}

}