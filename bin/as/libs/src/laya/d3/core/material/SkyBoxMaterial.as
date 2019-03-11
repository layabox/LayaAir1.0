package laya.d3.core.material {
	import laya.d3.math.Vector4;
	import laya.d3.resource.TextureCube;
	import laya.d3.shader.Shader3D;
	
	/**
	 * <code>SkyBoxMaterial</code> 类用于实现SkyBoxMaterial材质。
	 */
	public class SkyBoxMaterial extends BaseMaterial {
		public static const TINTCOLOR:int = Shader3D.propertyNameToID("u_TintColor");
		public static const EXPOSURE:int = Shader3D.propertyNameToID("u_Exposure");
		public static const ROTATION:int = Shader3D.propertyNameToID("u_Rotation");
		public static const TEXTURECUBE:int = Shader3D.propertyNameToID("u_CubeTexture");
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:SkyBoxMaterial = new SkyBoxMaterial();
		
		/**
		 * 获取颜色。
		 * @return  颜色。
		 */
		public function get tintColor():Vector4 {
			return _shaderValues.getVector(TINTCOLOR) as Vector4;
		}
		
		/**
		 * 设置颜色。
		 * @param value 颜色。
		 */
		public function set tintColor(value:Vector4):void {
			_shaderValues.setVector(TINTCOLOR, value);
		}
		
		/**
		 * 获取曝光强度。
		 * @return 曝光强度。
		 */
		public function get exposure():Number {
			return _shaderValues.getNumber(EXPOSURE);
		}
		
		/**
		 * 设置曝光强度。
		 * @param value 曝光强度。
		 */
		public function set exposure(value:Number):void {
			_shaderValues.setNumber(EXPOSURE, value);
		}
		
		/**
		 * 获取曝光强度。
		 * @return 曝光强度。
		 */
		public function get rotation():Number {
			return _shaderValues.getNumber(ROTATION);
		}
		
		/**
		 * 设置曝光强度。
		 * @param value 曝光强度。
		 */
		public function set rotation(value:Number):void {
			_shaderValues.setNumber(ROTATION, value);
		}
		
		/**
		 * 获取天空盒纹理。
		 */
		public function get textureCube():TextureCube {
			return _shaderValues.getTexture(TEXTURECUBE) as TextureCube;
		}
		
		/**
		 * 设置天空盒纹理。
		 */
		public function set textureCube(value:TextureCube):void {
			return _shaderValues.setTexture(TEXTURECUBE, value);
		}
		
		/**
		 * 创建一个 <code>SkyBoxMaterial</code> 实例。
		 */
		public function SkyBoxMaterial() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			setShaderName("SkyBox");
		}
	
	}

}