package laya.d3.core.trail {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.math.Vector4;
	import laya.d3.resource.BaseTexture;
	import laya.d3.shader.ShaderDefines;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TrailMaterial extends BaseMaterial {
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:TrailMaterial = new TrailMaterial();
		
		public static var SHADERDEFINE_DIFFUSETEXTURE:int;
		public static var SHADERDEFINE_TILINGOFFSET:int;
		
		public static const DIFFUSETEXTURE:int = 1;
		public static const TINTCOLOR:int = 2;
		public static const TILINGOFFSET:int = 3;
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_DIFFUSETEXTURE = shaderDefines.registerDefine("DIFFUSETEXTURE");
			SHADERDEFINE_TILINGOFFSET = shaderDefines.registerDefine("TILINGOFFSET");
		}
		
		/**
		 * 加载标准材质。
		 * @param url 标准材质地址。
		 */
		public static function load(url:String):TrailMaterial {
			return Laya.loader.create(url, null, null, TrailMaterial);
		}
		
		/**
		 * 获取颜色。
		 * @return 颜色。
		 */
		public function get tintColor():Vector4 {
			return _getColor(TINTCOLOR);
		}
		
		/**
		 * 设置颜色。
		 * @param value 颜色。
		 */
		public function set tintColor(value:Vector4):void {
			_setColor(TINTCOLOR, value);
		}
		
		/**
		 * 获取贴图。
		 * @return 贴图。
		 */
		public function get diffuseTexture():BaseTexture {
			return _getTexture(DIFFUSETEXTURE);
		}
	
		/**
		 * 设置贴图。
		 * @param value 贴图。
		 */
		public function set diffuseTexture(value:BaseTexture):void {
			if (value)
				_addShaderDefine(TrailMaterial.SHADERDEFINE_DIFFUSETEXTURE);
			else
				_removeShaderDefine(TrailMaterial.SHADERDEFINE_DIFFUSETEXTURE);
			_setTexture(DIFFUSETEXTURE, value);
		}
		
		/**
		 * 获取纹理平铺和偏移。
		 * @return 纹理平铺和偏移。
		 */
		public function get tilingOffset():Vector4 {
			return _getColor(TILINGOFFSET);
		}
		
		/**
		 * 设置纹理平铺和偏移。
		 * @param value 纹理平铺和偏移。
		 */
		public function set tilingOffset(value:Vector4):void {
			if (value) {
				var valueE:Float32Array = value.elements;
				if (valueE[0] != 1 || valueE[1] != 1 || valueE[2] != 0 || valueE[3] != 0)
					_addShaderDefine(TrailMaterial.SHADERDEFINE_TILINGOFFSET);
				else
					_removeShaderDefine(TrailMaterial.SHADERDEFINE_TILINGOFFSET);
			} else {
				_removeShaderDefine(TrailMaterial.SHADERDEFINE_TILINGOFFSET);
			}
			_setColor(TILINGOFFSET, value);
		}
		
		public function TrailMaterial() {
			super();
			setShaderName("Trail");
			_setColor(TINTCOLOR, new Vector4(1.0, 1.0, 1.0, 1.0));
		}
	}
}