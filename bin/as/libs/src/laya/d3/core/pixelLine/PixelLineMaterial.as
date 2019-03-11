package laya.d3.core.pixelLine {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.math.Vector4;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderDefines;
	
	/**
	 * ...
	 * @author
	 */
	public class PixelLineMaterial extends BaseMaterial {
		
		public static const COLOR:int = Shader3D.propertyNameToID("u_Color");
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:PixelLineMaterial = new PixelLineMaterial();
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
		}
		
		/**
		 * 获取颜色。
		 * @return 颜色。
		 */
		public function get color():Vector4 {
			return _shaderValues.getVector(COLOR) as Vector4;
		}
		
		/**
		 * 设置颜色。
		 * @param value 颜色。
		 */
		public function set color(value:Vector4):void {
			_shaderValues.setVector(COLOR, value);
		}
		
		public function PixelLineMaterial() {
			super();
			setShaderName("LineShader");
			_shaderValues.setVector(COLOR, new Vector4(1.0, 1.0, 1.0, 1.0));
		}
	}
}