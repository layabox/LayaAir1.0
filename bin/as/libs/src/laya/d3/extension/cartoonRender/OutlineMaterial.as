package laya.d3.extension.cartoonRender {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.resource.BaseTexture;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ShaderDefines;
	
	/**
	 * ...
	 * @author ...
	 */
	public class OutlineMaterial extends BaseMaterial {
		
		public static const OUTLINETEXTURE:int = 1;
		public static const OUTLINEWIDTH:int = 2;
		public static const OUTLINELIGHTNESS:int = 3;
		
		public static var SHADERDEFINE_OUTLINETEXTURE:int;
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_OUTLINETEXTURE = shaderDefines.registerDefine("OUTLINETEXTURE");
		}
		
		/**
		 * 获取漫轮廓贴图。
		 * @return 轮廓贴图。
		 */
		public function get outlineTexture():BaseTexture {
			return _getTexture(OUTLINETEXTURE);
		}
		
		/**
		 * 设置轮廓贴图。
		 * @param value 轮廓贴图。
		 */
		public function set outlineTexture(value:BaseTexture):void {
			if (value)
				_addShaderDefine(OutlineMaterial.SHADERDEFINE_OUTLINETEXTURE);
			else
				_removeShaderDefine(OutlineMaterial.SHADERDEFINE_OUTLINETEXTURE);
			_setTexture(OUTLINETEXTURE, value);
		}
		
		/**
		 * 获取轮廓宽度。
		 * @return 轮廓宽度,范围为0到0.05。
		 */
		public function get outlineWidth():Number {
			return _getNumber(OUTLINEWIDTH);
		}
		
		/**
		 * 设置轮廓宽度。
		 * @param value 轮廓宽度,范围为0到0.05。
		 */
		public function set outlineWidth(value:Number):void {
			value = Math.max(0.0, Math.min(0.05, value));
			_setNumber(OUTLINEWIDTH, value);
		}
		
		/**
		 * 获取轮廓亮度。
		 * @return 轮廓亮度,范围为0到1。
		 */
		public function get outlineLightness():Number {
			return _getNumber(OUTLINELIGHTNESS);
		}
		
		/**
		 * 设置轮廓亮度。
		 * @param value 轮廓亮度,范围为0到1。
		 */
		public function set outlineLightness(value:Number):void {
			value = Math.max(0.0, Math.min(1.0, value));
			_setNumber(OUTLINELIGHTNESS, value);
		}
		
		public static function initShader():void {
			
			var attributeMap:Object = {
				'a_Position': VertexElementUsage.POSITION0, 
				'a_Normal': VertexElementUsage.NORMAL0, 
				'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0
			};
			var uniformMap:Object = {
				'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_OutlineTexture': [OutlineMaterial.OUTLINETEXTURE, Shader3D.PERIOD_MATERIAL],
				'u_OutlineWidth': [OutlineMaterial.OUTLINEWIDTH, Shader3D.PERIOD_MATERIAL], 
				'u_OutlineLightness': [OutlineMaterial.OUTLINELIGHTNESS, Shader3D.PERIOD_MATERIAL]
			};
			
			var outlineShader:int = Shader3D.nameKey.add("OutlineShader");
			var vs:String = __INCLUDESTR__("shader/outline.vs");
			var ps:String = __INCLUDESTR__("shader/outline.ps");
			
			var outlineShaderCompile3D:ShaderCompile3D = ShaderCompile3D.add(outlineShader, vs, ps, attributeMap, uniformMap);
			
			OutlineMaterial.SHADERDEFINE_OUTLINETEXTURE = outlineShaderCompile3D.registerMaterialDefine("OUTLINETEXTURE");
		}
		
		public function OutlineMaterial() {
			setShaderName("OutlineShader");
			_setNumber(OUTLINEWIDTH, 0.01581197);
			_setNumber(OUTLINELIGHTNESS, 1);
		}
	
	}

}