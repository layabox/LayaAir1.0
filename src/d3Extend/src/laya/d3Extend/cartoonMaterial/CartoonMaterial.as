package laya.d3Extend.cartoonMaterial {
	
	import laya.d3.core.BaseCamera;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.math.Vector4;
	import laya.d3.shader.SubShader;
	import laya.d3.shader.ShaderDefines;
	import laya.webgl.resource.BaseTexture;
	
	public class CartoonMaterial extends BaseMaterial {
		
		public static const ALBEDOTEXTURE:int = 1;
		public static const BLENDTEXTURE:int = 2;
		public static const OUTLINETEXTURE:int = 3;
		public static const TILINGOFFSET:int = 4;
		public static const SHADOWCOLOR:int = 5;
		public static const SHADOWRANGE:int = 6;
		public static const SHADOWINTENSITY:int = 7;
		public static const SPECULARRANGE:int = 8;
		public static const SPECULARINTENSITY:int = 9;
		public static const OUTLINEWIDTH:int = 10;
		public static const OUTLINELIGHTNESS:int = 11;
		
		public static var SHADERDEFINE_ALBEDOTEXTURE:int;
		public static var SHADERDEFINE_BLENDTEXTURE:int;
		public static var SHADERDEFINE_OUTLINETEXTURE:int;
		public static var SHADERDEFINE_TILINGOFFSET:int;
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_ALBEDOTEXTURE = shaderDefines.registerDefine("ALBEDOTEXTURE");
			SHADERDEFINE_BLENDTEXTURE = shaderDefines.registerDefine("BLENDTEXTURE");
			SHADERDEFINE_OUTLINETEXTURE = shaderDefines.registerDefine("OUTLINETEXTURE");
			SHADERDEFINE_TILINGOFFSET = shaderDefines.registerDefine("TILINGOFFSET");
		}
		
		public static function initShader():void {
			
			__init__();
			
			var attributeMap:Object = 
			{
				'a_Position': VertexMesh.MESH_POSITION0, 
				'a_Normal': VertexMesh.MESH_NORMAL0, 
				'a_Texcoord0': VertexMesh.MESH_TEXTURECOORDINATE0
			};
			var uniformMap:Object = 
			{
				'u_MvpMatrix': [Sprite3D.MVPMATRIX, SubShader.PERIOD_SPRITE], 
				'u_WorldMat': [Sprite3D.WORLDMATRIX, SubShader.PERIOD_SPRITE], 
				'u_CameraPos': [BaseCamera.CAMERAPOS, SubShader.PERIOD_CAMERA], 
				'u_AlbedoTexture': [CartoonMaterial.ALBEDOTEXTURE, SubShader.PERIOD_MATERIAL], 
				'u_BlendTexture': [CartoonMaterial.BLENDTEXTURE, SubShader.PERIOD_MATERIAL], 
				'u_OutlineTexture': [CartoonMaterial.OUTLINETEXTURE, SubShader.PERIOD_MATERIAL], 
				'u_ShadowColor': [CartoonMaterial.SHADOWCOLOR, SubShader.PERIOD_MATERIAL], 
				'u_ShadowRange': [CartoonMaterial.SHADOWRANGE, SubShader.PERIOD_MATERIAL], 
				'u_ShadowIntensity': [CartoonMaterial.SHADOWINTENSITY, SubShader.PERIOD_MATERIAL], 
				'u_SpecularRange': [CartoonMaterial.SPECULARRANGE, SubShader.PERIOD_MATERIAL], 
				'u_SpecularIntensity': [CartoonMaterial.SPECULARINTENSITY, SubShader.PERIOD_MATERIAL], 
				'u_OutlineWidth': [CartoonMaterial.OUTLINEWIDTH, SubShader.PERIOD_MATERIAL], 
				'u_OutlineLightness': [CartoonMaterial.OUTLINELIGHTNESS, SubShader.PERIOD_MATERIAL], 
				'u_DirectionLight.Direction': [Scene3D.LIGHTDIRECTION, SubShader.PERIOD_SCENE], 
				'u_DirectionLight.Color': [Scene3D.LIGHTDIRCOLOR, SubShader.PERIOD_SCENE]};
			
			var cartoonShader3D:SubShader = SubShader.add("CartoonShader", attributeMap, uniformMap, SkinnedMeshSprite3D.shaderDefines, CartoonMaterial.shaderDefines);
			
			var vs1:String = __INCLUDESTR__("shader/outline.vs");
			var ps1:String = __INCLUDESTR__("shader/outline.ps");
			cartoonShader3D.addShaderPass(vs1, ps1);
			
			var vs2:String = __INCLUDESTR__("shader/cartoon.vs");
			var ps2:String = __INCLUDESTR__("shader/cartoon.ps");
			cartoonShader3D.addShaderPass(vs2, ps2);
		}
		
		/**
		 * 获取漫反射贴图。
		 * @return 漫反射贴图。
		 */
		public function get albedoTexture():BaseTexture {
			return _shaderValues.getTexture(ALBEDOTEXTURE);
		}
		
		/**
		 * 设置漫反射贴图。
		 * @param value 漫反射贴图。
		 */
		public function set albedoTexture(value:BaseTexture):void {
			if (value)
				_defineDatas.add(CartoonMaterial.SHADERDEFINE_ALBEDOTEXTURE);
			else
				_defineDatas.remove(CartoonMaterial.SHADERDEFINE_ALBEDOTEXTURE);
			_shaderValues.setTexture(ALBEDOTEXTURE, value);
		}
		
		/**
		 * 获取混合贴图。
		 * @return 混合贴图。
		 */
		public function get blendTexture():BaseTexture {
			return _shaderValues.getTexture(BLENDTEXTURE);
		}
		
		/**
		 * 设置混合贴图。
		 * @param value 混合贴图。
		 */
		public function set blendTexture(value:BaseTexture):void {
			if (value)
				_defineDatas.add(CartoonMaterial.SHADERDEFINE_BLENDTEXTURE);
			else
				_defineDatas.remove(CartoonMaterial.SHADERDEFINE_BLENDTEXTURE);
			_shaderValues.setTexture(BLENDTEXTURE, value);
		}
		
		/**
		 * 获取漫轮廓贴图。
		 * @return 轮廓贴图。
		 */
		public function get outlineTexture():BaseTexture {
			return _shaderValues.getTexture(OUTLINETEXTURE);
		}
		
		/**
		 * 设置轮廓贴图。
		 * @param value 轮廓贴图。
		 */
		public function set outlineTexture(value:BaseTexture):void {
			if (value)
				_defineDatas.add(CartoonMaterial.SHADERDEFINE_OUTLINETEXTURE);
			else
				_defineDatas.remove(CartoonMaterial.SHADERDEFINE_OUTLINETEXTURE);
			_shaderValues.setTexture(OUTLINETEXTURE, value);
		}
		
		/**
		 * 获取阴影颜色。
		 * @return 阴影颜色。
		 */
		public function get shadowColor():Vector4 {
			return _shaderValues.getVector(SHADOWCOLOR) as Vector4;
		}
		
		/**
		 * 设置阴影颜色。
		 * @param value 阴影颜色。
		 */
		public function set shadowColor(value:Vector4):void {
			_shaderValues.setVector(SHADOWCOLOR, value);
		}
		
		/**
		 * 获取阴影范围。
		 * @return 阴影范围,范围为0到1。
		 */
		public function get shadowRange():Number {
			return _shaderValues.getNumber(SHADOWRANGE);
		}
		
		/**
		 * 设置阴影范围。
		 * @param value 阴影范围,范围为0到1。
		 */
		public function set shadowRange(value:Number):void {
			value = Math.max(0.0, Math.min(1.0, value));
			_shaderValues.setNumber(SHADOWRANGE, value);
		}
		
		/**
		 * 获取阴影强度。
		 * @return 阴影强度,范围为0到1。
		 */
		public function get shadowIntensity():Number {
			return _shaderValues.getNumber(SHADOWINTENSITY);
		}
		
		/**
		 * 设置阴影强度。
		 * @param value 阴影强度,范围为0到1。
		 */
		public function set shadowIntensity(value:Number):void {
			value = Math.max(0.0, Math.min(1.0, value));
			_shaderValues.setNumber(SHADOWINTENSITY, value);
		}
		
		/**
		 * 获取高光范围。
		 * @return 高光范围,范围为0.9到1。
		 */
		public function get specularRange():Number {
			return _shaderValues.getNumber(SPECULARRANGE);
		}
		
		/**
		 * 设置高光范围。
		 * @param value 高光范围,范围为0.9到1。
		 */
		public function set specularRange(value:Number):void {
			value = Math.max(0.9, Math.min(1.0, value));
			_shaderValues.setNumber(SPECULARRANGE, value);
		}
		
		/**
		 * 获取高光强度。
		 * @return 高光强度,范围为0到1。
		 */
		public function get specularIntensity():Number {
			return _shaderValues.getNumber(SPECULARINTENSITY);
		}
		
		/**
		 * 获取轮廓宽度。
		 * @return 轮廓宽度,范围为0到0.05。
		 */
		public function get outlineWidth():Number {
			return _shaderValues.getNumber(OUTLINEWIDTH);
		}
		
		/**
		 * 设置轮廓宽度。
		 * @param value 轮廓宽度,范围为0到0.05。
		 */
		public function set outlineWidth(value:Number):void {
			value = Math.max(0.0, Math.min(0.05, value));
			_shaderValues.setNumber(OUTLINEWIDTH, value);
		}
		
		/**
		 * 获取轮廓亮度。
		 * @return 轮廓亮度,范围为0到1。
		 */
		public function get outlineLightness():Number {
			return _shaderValues.getNumber(OUTLINELIGHTNESS);
		}
		
		/**
		 * 设置轮廓亮度。
		 * @param value 轮廓亮度,范围为0到1。
		 */
		public function set outlineLightness(value:Number):void {
			value = Math.max(0.0, Math.min(1.0, value));
			_shaderValues.setNumber(OUTLINELIGHTNESS, value);
		}
		
		/**
		 * 设置高光强度。
		 * @param value 高光范围,范围为0到1。
		 */
		public function set specularIntensity(value:Number):void {
			value = Math.max(0.0, Math.min(1.0, value));
			_shaderValues.setNumber(SPECULARINTENSITY, value);
		}
		
		/**
		 * 获取纹理平铺和偏移。
		 * @return 纹理平铺和偏移。
		 */
		public function get tilingOffset():Vector4 {
			return _shaderValues.getVector(TILINGOFFSET) as Vector4;
		}
		
		/**
		 * 设置纹理平铺和偏移。
		 * @param value 纹理平铺和偏移。
		 */
		public function set tilingOffset(value:Vector4):void {
			if (value) {
				var valueE:Float32Array = value.elements;
				if (valueE[0] != 1 || valueE[1] != 1 || valueE[2] != 0 || valueE[3] != 0)
					_defineDatas.add(CartoonMaterial.SHADERDEFINE_TILINGOFFSET);
				else
					_defineDatas.remove(CartoonMaterial.SHADERDEFINE_TILINGOFFSET);
			} else {
				_defineDatas.remove(CartoonMaterial.SHADERDEFINE_TILINGOFFSET);
			}
			_shaderValues.setVector(TILINGOFFSET, value);
		}
		
		public function CartoonMaterial() {
			super(12);
			setShaderName("CartoonShader");
			_shaderValues.setVector(SHADOWCOLOR, new Vector4(0.6663285, 0.6544118, 1, 1));
			_shaderValues.setNumber(SHADOWRANGE, 0);
			_shaderValues.setNumber(SHADOWINTENSITY, 0.7956449);
			_shaderValues.setNumber(SPECULARRANGE, 0.9820514);
			_shaderValues.setNumber(SPECULARINTENSITY, 1);
			_shaderValues.setNumber(OUTLINEWIDTH, 0.01581197);
			_shaderValues.setNumber(OUTLINELIGHTNESS, 1);
		}
	}
}