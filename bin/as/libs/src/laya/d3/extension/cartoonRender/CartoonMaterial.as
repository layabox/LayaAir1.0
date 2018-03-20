package laya.d3.extension.cartoonRender {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.TransformUV;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.scene.Scene;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.math.Vector4;
	import laya.d3.resource.BaseTexture;
	import laya.d3.resource.DataTexture2D;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ShaderDefines;
	import laya.utils.Browser;
	import laya.webgl.WebGLContext;
	
	public class CartoonMaterial extends BaseMaterial {
		
		public static const ALBEDOTEXTURE:int = 1;
		public static const SPECULARTEXTURE:int = 2;
		public static const TILINGOFFSET:int = 4;
		public static const SHADOWCOLOR:int = 5;
		public static const SHADOWRANGE:int = 6;
		public static const SHADOWINTENSITY:int = 7;
		public static const SPECULARRANGE:int = 8;
		public static const SPECULARINTENSITY:int = 9;
		
		public static var SHADERDEFINE_ALBEDOTEXTURE:int;
		public static var SHADERDEFINE_SPECULARTEXTURE:int;
		public static var SHADERDEFINE_TILINGOFFSET:int;
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_ALBEDOTEXTURE = shaderDefines.registerDefine("DIFFUSETEXTURE");
			SHADERDEFINE_SPECULARTEXTURE = shaderDefines.registerDefine("SPECULARTEXTURE");
		}
		
		/**
		 * 获取漫反射贴图。
		 * @return 漫反射贴图。
		 */
		public function get albedoTexture():BaseTexture {
			return _getTexture(ALBEDOTEXTURE);
		}
		
		/**
		 * 设置漫反射贴图。
		 * @param value 漫反射贴图。
		 */
		public function set albedoTexture(value:BaseTexture):void {
			if (value)
				_addShaderDefine(CartoonMaterial.SHADERDEFINE_ALBEDOTEXTURE);
			else
				_removeShaderDefine(CartoonMaterial.SHADERDEFINE_ALBEDOTEXTURE);
			_setTexture(ALBEDOTEXTURE, value);
		}
		
		/**
		 * 获取高光贴图。
		 * @return 高光贴图。
		 */
		public function get specularTexture():BaseTexture {
			return _getTexture(SPECULARTEXTURE);
		}
		
		/**
		 * 设置高光贴图。
		 * @param value 高光贴图。
		 */
		public function set specularTexture(value:BaseTexture):void {
			if (value)
				_addShaderDefine(CartoonMaterial.SHADERDEFINE_SPECULARTEXTURE);
			else
				_removeShaderDefine(CartoonMaterial.SHADERDEFINE_SPECULARTEXTURE);
			_setTexture(SPECULARTEXTURE, value);
		}
		
		/**
		 * 获取阴影颜色。
		 * @return 阴影颜色。
		 */
		public function get shadowColor():Vector4 {
			return _getColor(SHADOWCOLOR);
		}
		
		/**
		 * 设置阴影颜色。
		 * @param value 阴影颜色。
		 */
		public function set shadowColor(value:Vector4):void {
			_setColor(SHADOWCOLOR, value);
		}
		
		/**
		 * 获取阴影范围。
		 * @return 阴影范围,范围为0到1。
		 */
		public function get shadowRange():Number {
			return _getNumber(SHADOWRANGE);
		}
		
		/**
		 * 设置阴影范围。
		 * @param value 阴影范围,范围为0到1。
		 */
		public function set shadowRange(value:Number):void {
			value = Math.max(0.0, Math.min(1.0, value));
			_setNumber(SHADOWRANGE, value);
		}
		
		/**
		 * 获取阴影强度。
		 * @return 阴影强度,范围为0到1。
		 */
		public function get shadowIntensity():Number {
			return _getNumber(SHADOWINTENSITY);
		}
		
		/**
		 * 设置阴影强度。
		 * @param value 阴影强度,范围为0到1。
		 */
		public function set shadowIntensity(value:Number):void {
			value = Math.max(0.0, Math.min(1.0, value));
			_setNumber(SHADOWINTENSITY, value);
		}
		
		/**
		 * 获取高光范围。
		 * @return 高光范围,范围为0.9到1。
		 */
		public function get specularRange():Number {
			return _getNumber(SPECULARRANGE);
		}
		
		/**
		 * 设置高光范围。
		 * @param value 高光范围,范围为0.9到1。
		 */
		public function set specularRange(value:Number):void {
			value = Math.max(0.9, Math.min(1.0, value));
			_setNumber(SPECULARRANGE, value);
		}
		
		/**
		 * 获取高光强度。
		 * @return 高光强度,范围为0到1。
		 */
		public function get specularIntensity():Number {
			return _getNumber(SPECULARINTENSITY);
		}
		
		/**
		 * 设置高光强度。
		 * @param value 高光范围,范围为0到1。
		 */
		public function set specularIntensity(value:Number):void {
			value = Math.max(0.0, Math.min(1.0, value));
			_setNumber(SPECULARINTENSITY, value);
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
					_addShaderDefine(CartoonMaterial.SHADERDEFINE_TILINGOFFSET);
				else
					_removeShaderDefine(CartoonMaterial.SHADERDEFINE_TILINGOFFSET);
			} else {
				_removeShaderDefine(CartoonMaterial.SHADERDEFINE_TILINGOFFSET);
			}
			_setColor(TILINGOFFSET, value);
		}
		
		public static function initShader():void {
            
            var attributeMap:Object = {
				'a_Position': VertexElementUsage.POSITION0, 
				'a_Normal': VertexElementUsage.NORMAL0, 
				'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0
			};
            var uniformMap:Object = {
				'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_WorldMat': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_CameraPos': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 
				'u_AlbedoTexture': [CartoonMaterial.ALBEDOTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_SpecularTexture': [CartoonMaterial.SPECULARTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_ShadowColor': [CartoonMaterial.SHADOWCOLOR, Shader3D.PERIOD_MATERIAL], 
				'u_ShadowRange': [CartoonMaterial.SHADOWRANGE, Shader3D.PERIOD_MATERIAL], 
				'u_ShadowIntensity': [CartoonMaterial.SHADOWINTENSITY, Shader3D.PERIOD_MATERIAL], 
				'u_SpecularRange': [CartoonMaterial.SPECULARRANGE, Shader3D.PERIOD_MATERIAL], 
				'u_SpecularIntensity': [CartoonMaterial.SPECULARINTENSITY, Shader3D.PERIOD_MATERIAL], 
				'u_DirectionLight.Direction': [Scene.LIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Color': [Scene.LIGHTDIRCOLOR, Shader3D.PERIOD_SCENE]
			};
			
            var cartoonShader:int = Shader3D.nameKey.add("CartoonShader");
            var vs:String = __INCLUDESTR__("shader/cartoon.vs");
            var ps:String = __INCLUDESTR__("shader/cartoon.ps");
			
            var cartoonShaderCompile3D:ShaderCompile3D = ShaderCompile3D.add(cartoonShader, vs, ps, attributeMap, uniformMap);
            
            CartoonMaterial.SHADERDEFINE_ALBEDOTEXTURE = cartoonShaderCompile3D.registerMaterialDefine("ALBEDOTEXTURE");
            CartoonMaterial.SHADERDEFINE_SPECULARTEXTURE = cartoonShaderCompile3D.registerMaterialDefine("SPECULARTEXTURE");
            CartoonMaterial.SHADERDEFINE_TILINGOFFSET = cartoonShaderCompile3D.registerMaterialDefine("TILINGOFFSET");
        }
		
		public function CartoonMaterial() {
			setShaderName("CartoonShader");
			_setColor(SHADOWCOLOR, new Vector4(0.6663285, 0.6544118, 1, 1));
			_setNumber(SHADOWRANGE, 0);
			_setNumber(SHADOWINTENSITY, 0.7956449);
			_setNumber(SPECULARRANGE, 0.9820514);
			_setNumber(SPECULARINTENSITY, 1);
		}
	}
}