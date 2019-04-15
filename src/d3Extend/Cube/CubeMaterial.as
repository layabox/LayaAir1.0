package laya.d3Extend.Cube {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.RenderState;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.math.Vector4;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderData;
	import laya.d3.shader.ShaderDefines;
	import laya.d3.shader.SubShader;
	import laya.webgl.resource.BaseTexture;
	
	/**
	 * <code>CubeMaterial</code> 类用于实现Blinn-Phong材质。
	 */
	public class CubeMaterial extends BaseMaterial {
		/**高光强度数据源_漫反射贴图的Alpha通道。*/
		public static var SPECULARSOURCE_DIFFUSEMAPALPHA:int;
		/**高光强度数据源_高光贴图的RGB通道。*/
		public static var SPECULARSOURCE_SPECULARMAP:int;
		
		/**渲染状态_不透明。*/
		public static const RENDERMODE_OPAQUE:int = 0;
		/**渲染状态_阿尔法测试。*/
		public static const RENDERMODE_CUTOUT:int = 1;
		/**渲染状态_透明混合。*/
		public static const RENDERMODE_TRANSPARENT:int = 2;
		
		public static var SHADERDEFINE_DIFFUSEMAP:int;
		public static var SHADERDEFINE_NORMALMAP:int;
		public static var SHADERDEFINE_SPECULARMAP:int;
		public static var SHADERDEFINE_TILINGOFFSET:int;
		public static var SHADERDEFINE_ENABLEVERTEXCOLOR:int;
		public static var SHADERDEFINE_MODENABLEVERTEXCOLOR:int;
		public static var SHADERDEFINE_SOLIDCOLORTEXTURE:int;
		
		
		public static const ALBEDOTEXTURE:int = Shader3D.propertyNameToID("u_DiffuseTexture");
		public static const NORMALTEXTURE:int = Shader3D.propertyNameToID("u_NormalTexture");
		public static const SPECULARTEXTURE:int = Shader3D.propertyNameToID("u_SpecularTexture");
		public static const ALBEDOCOLOR:int = Shader3D.propertyNameToID("u_DiffuseColor");
		public static const MATERIALSPECULAR:int = Shader3D.propertyNameToID("u_MaterialSpecular");
		public static const SHININESS:int = Shader3D.propertyNameToID("u_Shininess");
		public static const TILINGOFFSET:int = Shader3D.propertyNameToID("u_TilingOffset");
		
		/** 默认材质，禁止修改*/
		public static const defaultMaterial:CubeMaterial = new CubeMaterial();
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(BaseMaterial.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_DIFFUSEMAP = shaderDefines.registerDefine("DIFFUSEMAP");
			SHADERDEFINE_NORMALMAP = shaderDefines.registerDefine("NORMALMAP");
			SHADERDEFINE_SPECULARMAP = shaderDefines.registerDefine("SPECULARMAP");
			SHADERDEFINE_TILINGOFFSET = shaderDefines.registerDefine("TILINGOFFSET");
			SHADERDEFINE_ENABLEVERTEXCOLOR = shaderDefines.registerDefine("ENABLEVERTEXCOLOR");
			SHADERDEFINE_MODENABLEVERTEXCOLOR = shaderDefines.registerDefine("MODENABLEVERTEXCOLOR");
			SHADERDEFINE_SOLIDCOLORTEXTURE = shaderDefines.registerDefine("SOLIDCOLORTEXTURE");
			
			var vs:String, ps:String;
			var attributeMap:Object = {
				'a_Position': VertexMesh.MESH_POSITION0, 
				'a_Color': VertexMesh.MESH_COLOR0, 
				'a_Normal': VertexMesh.MESH_NORMAL0, 
				'a_Texcoord0': VertexMesh.MESH_TEXTURECOORDINATE0, 
				'a_Texcoord1': VertexMesh.MESH_TEXTURECOORDINATE1, 
				'a_BoneWeights': VertexMesh.MESH_BLENDWEIGHT0, 
				'a_BoneIndices': VertexMesh.MESH_BLENDINDICES0, 
				'a_Tangent0': VertexMesh.MESH_TANGENT0};
			var uniformMap:Object = {
				'u_Bones': Shader3D.PERIOD_CUSTOM, 
				'u_DiffuseTexture':  Shader3D.PERIOD_MATERIAL, 
				'u_SpecularTexture': Shader3D.PERIOD_MATERIAL, 
				'u_NormalTexture':  Shader3D.PERIOD_MATERIAL, 
				'u_AlphaTestValue':  Shader3D.PERIOD_MATERIAL, 
				'u_DiffuseColor':Shader3D.PERIOD_MATERIAL, 
				'u_MaterialSpecular':  Shader3D.PERIOD_MATERIAL, 
				'u_Shininess':  Shader3D.PERIOD_MATERIAL, 
				'u_TilingOffset':  Shader3D.PERIOD_MATERIAL,
				
				'u_WorldMat': Shader3D.PERIOD_SPRITE, 
				'u_MvpMatrix': Shader3D.PERIOD_SPRITE, 
				'u_LightmapScaleOffset':  Shader3D.PERIOD_SPRITE, 
				'u_LightMap': Shader3D.PERIOD_SPRITE,
				
				'u_CameraPos':  Shader3D.PERIOD_CAMERA, 
				
				'u_ReflectTexture':  Shader3D.PERIOD_SCENE, 
				'u_ReflectIntensity': Shader3D.PERIOD_SCENE, 
				'u_FogStart': Shader3D.PERIOD_SCENE, 
				'u_FogRange': Shader3D.PERIOD_SCENE, 
				'u_FogColor':Shader3D.PERIOD_SCENE, 
				'u_DirectionLight.Color':Shader3D.PERIOD_SCENE,
				'u_DirectionLight.Direction': Shader3D.PERIOD_SCENE,  
				'u_PointLight.Position':  Shader3D.PERIOD_SCENE, 
				'u_PointLight.Range':  Shader3D.PERIOD_SCENE, 
				'u_PointLight.Color': Shader3D.PERIOD_SCENE, 
				'u_SpotLight.Position':  Shader3D.PERIOD_SCENE, 
				'u_SpotLight.Direction': Shader3D.PERIOD_SCENE, 
				'u_SpotLight.Range':  Shader3D.PERIOD_SCENE, 
				'u_SpotLight.Spot':  Shader3D.PERIOD_SCENE, 
				'u_SpotLight.Color':  Shader3D.PERIOD_SCENE, 
				'u_AmbientColor':  Shader3D.PERIOD_SCENE,
				'u_shadowMap1':  Shader3D.PERIOD_SCENE, 
				'u_shadowMap2':  Shader3D.PERIOD_SCENE, 
				'u_shadowMap3':  Shader3D.PERIOD_SCENE, 
				'u_shadowPSSMDistance':  Shader3D.PERIOD_SCENE, 
				'u_lightShadowVP':  Shader3D.PERIOD_SCENE, 
				'u_shadowPCFoffset':  Shader3D.PERIOD_SCENE};
			
			vs = __INCLUDESTR__("CubeShader/CubeShader.vs");
			ps = __INCLUDESTR__("CubeShader/CubeShader.ps");
			var shader:Shader3D = Shader3D.add("CUBESHADER");
			var subShader:SubShader = new SubShader(attributeMap, uniformMap, SkinnedMeshSprite3D.shaderDefines, CubeMaterial.shaderDefines);
			shader.addSubShader(subShader);
			subShader.addShaderPass(vs,ps);
		}
		
		/**@private */
		private var _albedoColor:Vector4;
		/**@private */
		private var _albedoIntensity:Number;
		/**@private */
		private var _enableLighting:Boolean;
		/**@private */
		private var _enableVertexColor:Boolean = false;
		
		/**
		 * @private
		 */
		public function get _ColorR():Number {
			return _albedoColor.elements[0];
		}
		
		/**
		 * @private
		 */
		public function set _ColorR(value:Number):void {
			_albedoColor.elements[0] = value;
			albedoColor = _albedoColor;
		}
		
		/**
		 * @private
		 */
		public function get _ColorG():Number {
			return _albedoColor.elements[1];
		}
		
		/**
		 * @private
		 */
		public function set _ColorG(value:Number):void {
			_albedoColor.elements[1] = value;
			albedoColor = _albedoColor;
		}
		
		/**
		 * @private
		 */
		public function get _ColorB():Number {
			return _albedoColor.elements[2];
		}
		
		/**
		 * @private
		 */
		public function set _ColorB(value:Number):void {
			_albedoColor.elements[2] = value;
			albedoColor = _albedoColor;
		}
		
		/**@private */
		public function get _ColorA():Number {
			return _albedoColor.elements[3];
		}
		
		/**
		 * @private
		 */
		public function set _ColorA(value:Number):void {
			_albedoColor.elements[3] = value;
			albedoColor = _albedoColor;
		}
		
		/**
		 * @private
		 */
		public function get _SpecColorR():Number {
			return _shaderValues.getVector(MATERIALSPECULAR).elements[0];
		}
		
		/**
		 * @private
		 */
		public function set _SpecColorR(value:Number):void {
			_shaderValues.getVector(MATERIALSPECULAR).elements[0] = value;
		}
		
		/**
		 * @private
		 */
		public function get _SpecColorG():Number {
			return _shaderValues.getVector(MATERIALSPECULAR).elements[1];
		}
		
		/**
		 * @private
		 */
		public function set _SpecColorG(value:Number):void {
			_shaderValues.getVector(MATERIALSPECULAR).elements[1] = value;
		}
		
		/**
		 * @private
		 */
		public function get _SpecColorB():Number {
			return _shaderValues.getVector(MATERIALSPECULAR).elements[2];
		}
		
		/**
		 * @private
		 */
		public function set _SpecColorB(value:Number):void {
			_shaderValues.getVector(MATERIALSPECULAR).elements[2] = value;
		}
		
		/**
		 * @private
		 */
		public function get _SpecColorA():Number {
			return _shaderValues.getVector(MATERIALSPECULAR).elements[3];
		}
		
		/**
		 * @private
		 */
		public function set _SpecColorA(value:Number):void {
			_shaderValues.getVector(MATERIALSPECULAR).elements[3] = value;
		}
		
		/**
		 * @private
		 */
		public function get _AlbedoIntensity():Number {
			return _albedoIntensity;
		}
		
		/**
		 * @private
		 */
		public function set _AlbedoIntensity(value:Number):void {
			if (_albedoIntensity !== value) {
				var finalAlbedo:Vector4 = _shaderValues.getVector(ALBEDOCOLOR) as Vector4;
				Vector4.scale(_albedoColor, value, finalAlbedo);
				_albedoIntensity = value;
				_shaderValues.setVector(ALBEDOCOLOR, finalAlbedo);//修改值后必须调用此接口,否则NATIVE不生效
			}
		}
		
		/**
		 * @private
		 */
		public function get _Shininess():Number {
			return _shaderValues.getNumber(SHININESS);
		}
		
		/**
		 * @private
		 */
		public function set _Shininess(value:Number):void {
			value = Math.max(0.0, Math.min(1.0, value));
			_shaderValues.setNumber(SHININESS, value);
		}
		
		/**
		 * @private
		 */
		public function get _MainTex_STX():Number {
			return _shaderValues.getVector(TILINGOFFSET).elements[0];
		}
		
		/**
		 * @private
		 */
		public function set _MainTex_STX(x:Number):void {
			var tilOff:Vector4 = _shaderValues.getVector(TILINGOFFSET) as Vector4;
			tilOff.elements[0] = x;
			tilingOffset = tilOff;
		}
		
		/**
		 * @private
		 */
		public function get _MainTex_STY():Number {
			return _shaderValues.getVector(TILINGOFFSET).elements[1];
		}
		
		/**
		 * @private
		 */
		public function set _MainTex_STY(y:Number):void {
			var tilOff:Vector4 = _shaderValues.getVector(TILINGOFFSET) as Vector4;
			tilOff.elements[1] = y;
			tilingOffset = tilOff;
		}
		
		/**
		 * @private
		 */
		public function get _MainTex_STZ():Number {
			return _shaderValues.getVector(TILINGOFFSET).elements[2];
		}
		
		/**
		 * @private
		 */
		public function set _MainTex_STZ(z:Number):void {
			var tilOff:Vector4 = _shaderValues.getVector(TILINGOFFSET) as Vector4;
			tilOff.elements[2] = z;
			tilingOffset = tilOff;
		}
		
		/**
		 * @private
		 */
		public function get _MainTex_STW():Number {
			return _shaderValues.getVector(TILINGOFFSET).elements[3];
		}
		
		/**
		 * @private
		 */
		public function set _MainTex_STW(w:Number):void {
			var tilOff:Vector4 = _shaderValues.getVector(TILINGOFFSET) as Vector4;
			tilOff.elements[3] = w;
			tilingOffset = tilOff;
		}
		
		/**
		 * @private
		 */
		public function get _Cutoff():Number {
			return alphaTestValue;
		}
		
		/**
		 * @private
		 */
		public function set _Cutoff(value:Number):void {
			alphaTestValue = value;
		}
		
		/**
		 * 设置渲染模式。
		 * @return 渲染模式。
		 */
		public function set renderMode(value:int):void {
			var renderState:RenderState = getRenderState();
			switch (value) {
			case RENDERMODE_OPAQUE: 
				alphaTest = false;
				renderQueue = BaseMaterial.RENDERQUEUE_OPAQUE;
				renderState.depthWrite = true;
				renderState.cull = RenderState.CULL_BACK;
				renderState.blend = RenderState.BLEND_DISABLE;
				renderState.depthTest = RenderState.DEPTHTEST_LESS;
				break;
			case RENDERMODE_CUTOUT: 
				renderQueue = BaseMaterial.RENDERQUEUE_ALPHATEST;
				alphaTest = true;
				renderState.depthWrite = true;
				renderState.cull = RenderState.CULL_BACK;
				renderState.blend = RenderState.BLEND_DISABLE;
				renderState.depthTest = RenderState.DEPTHTEST_LESS;
				break;
			case RENDERMODE_TRANSPARENT: 
				renderQueue = BaseMaterial.RENDERQUEUE_TRANSPARENT;
				alphaTest = false;
				renderState.depthWrite = false;
				renderState.cull = RenderState.CULL_BACK;
				renderState.blend = RenderState.BLEND_ENABLE_ALL;
				renderState.srcBlend = RenderState.BLENDPARAM_SRC_ALPHA;
				renderState.dstBlend = RenderState.BLENDPARAM_ONE_MINUS_SRC_ALPHA;
				renderState.depthTest = RenderState.DEPTHTEST_LESS;
				break;
			default: 
				throw new Error("Material:renderMode value error.");
			}
		}
		
		/**
		 * 获取是否支持顶点色。
		 * @return  是否支持顶点色。
		 */
		public function get enableVertexColor():Boolean {
			return _enableVertexColor;
		}
		
		/**
		 * 设置是否支持顶点色。
		 * @param value  是否支持顶点色。
		 */
		public function set enableVertexColor(value:Boolean):void {
			_enableVertexColor = value;
			if (value)
				_defineDatas.add(CubeMaterial.SHADERDEFINE_ENABLEVERTEXCOLOR);
			else
				_defineDatas.remove(CubeMaterial.SHADERDEFINE_ENABLEVERTEXCOLOR);
		}
		
		public function set modEnableVertexColor(value:Boolean):void {
			if (value)
				_defineDatas.add(CubeMaterial.SHADERDEFINE_MODENABLEVERTEXCOLOR);
			else
				_defineDatas.remove(CubeMaterial.SHADERDEFINE_MODENABLEVERTEXCOLOR);
		}
		
		public function set solidColorTexture(value:Boolean):void {
			if (value)
				_defineDatas.add(CubeMaterial.SHADERDEFINE_SOLIDCOLORTEXTURE);
			else
				_defineDatas.remove(CubeMaterial.SHADERDEFINE_SOLIDCOLORTEXTURE);
		}
	
		
		/**
		 * 获取纹理平铺和偏移X分量。
		 * @return 纹理平铺和偏移X分量。
		 */
		public function get tilingOffsetX():Number {
			return _MainTex_STX;
		}
		
		/**
		 * 获取纹理平铺和偏移X分量。
		 * @param x 纹理平铺和偏移X分量。
		 */
		public function set tilingOffsetX(x:Number):void {
			_MainTex_STX = x;
		}
		
		/**
		 * 获取纹理平铺和偏移Y分量。
		 * @return 纹理平铺和偏移Y分量。
		 */
		public function get tilingOffsetY():Number {
			return _MainTex_STY;
		}
		
		/**
		 * 获取纹理平铺和偏移Y分量。
		 * @param y 纹理平铺和偏移Y分量。
		 */
		public function set tilingOffsetY(y:Number):void {
			_MainTex_STY = y;
		}
		
		/**
		 * 获取纹理平铺和偏移Z分量。
		 * @return 纹理平铺和偏移Z分量。
		 */
		public function get tilingOffsetZ():Number {
			return _MainTex_STZ;
		}
		
		/**
		 * 获取纹理平铺和偏移Z分量。
		 * @param z 纹理平铺和偏移Z分量。
		 */
		public function set tilingOffsetZ(z:Number):void {
			_MainTex_STZ = z;
		}
		
		/**
		 * 获取纹理平铺和偏移W分量。
		 * @return 纹理平铺和偏移W分量。
		 */
		public function get tilingOffsetW():Number {
			return _MainTex_STW;
		}
		
		/**
		 * 获取纹理平铺和偏移W分量。
		 * @param w 纹理平铺和偏移W分量。
		 */
		public function set tilingOffsetW(w:Number):void {
			_MainTex_STW = w;
		}
		
		/**
		 * 获取纹理平铺和偏移。
		 * @return 纹理平铺和偏移。
		 */
		public function get tilingOffset():Vector4 {
			return _shaderValues.getVector(TILINGOFFSET) as Vector4;
		}
		
		/**
		 * 获取纹理平铺和偏移。
		 * @param value 纹理平铺和偏移。
		 */
		public function set tilingOffset(value:Vector4):void {
			if (value) {
				var valueE:Float32Array = value.elements;
				if (valueE[0] != 1 || valueE[1] != 1 || valueE[2] != 0 || valueE[3] != 0)
					_defineDatas.add(CubeMaterial.SHADERDEFINE_TILINGOFFSET);
				else
					_defineDatas.remove(CubeMaterial.SHADERDEFINE_TILINGOFFSET);
			} else {
				_defineDatas.remove(CubeMaterial.SHADERDEFINE_TILINGOFFSET);
			}
			_shaderValues.setVector(TILINGOFFSET, value);
		}
		
		/**
		 * 获取反照率颜色R分量。
		 * @return 反照率颜色R分量。
		 */
		public function get albedoColorR():Number {
			return _ColorR;
		}
		
		/**
		 * 设置反照率颜色R分量。
		 * @param value 反照率颜色R分量。
		 */
		public function set albedoColorR(value:Number):void {
			_ColorR = value;
		}
		
		/**
		 * 获取反照率颜色G分量。
		 * @return 反照率颜色G分量。
		 */
		public function get albedoColorG():Number {
			return _ColorG;
		}
		
		/**
		 * 设置反照率颜色G分量。
		 * @param value 反照率颜色G分量。
		 */
		public function set albedoColorG(value:Number):void {
			_ColorG = value;
		}
		
		/**
		 * 获取反照率颜色B分量。
		 * @return 反照率颜色B分量。
		 */
		public function get albedoColorB():Number {
			return _ColorB;
		}
		
		/**
		 * 设置反照率颜色B分量。
		 * @param value 反照率颜色B分量。
		 */
		public function set albedoColorB(value:Number):void {
			_ColorB = value;
		}
		
		/**
		 * 获取反照率颜色Z分量。
		 * @return 反照率颜色Z分量。
		 */
		public function get albedoColorA():Number {
			return _ColorA;
		}
		
		/**
		 * 设置反照率颜色alpha分量。
		 * @param value 反照率颜色alpha分量。
		 */
		public function set albedoColorA(value:Number):void {
			_ColorA = value;
		}
		
		/**
		 * 获取反照率颜色。
		 * @return 反照率颜色。
		 */
		public function get albedoColor():Vector4 {
			return _albedoColor;
		}
		
		/**
		 * 设置反照率颜色。
		 * @param value 反照率颜色。
		 */
		public function set albedoColor(value:Vector4):void {
			var finalAlbedo:Vector4 = _shaderValues.getVector(ALBEDOCOLOR) as Vector4;
			Vector4.scale(value, _albedoIntensity, finalAlbedo);
			_albedoColor = value;
			_shaderValues.setVector(ALBEDOCOLOR, finalAlbedo);//修改值后必须调用此接口,否则NATIVE不生效
		}
		
		/**
		 * 获取反照率强度。
		 * @return 反照率强度。
		 */
		public function get albedoIntensity():Number {
			return _albedoIntensity;
		}
		
		/**
		 * 设置反照率强度。
		 * @param value 反照率强度。
		 */
		public function set albedoIntensity(value:Number):void {
			_AlbedoIntensity = value;
		}
		
		/**
		 * 获取高光颜色R轴分量。
		 * @return 高光颜色R轴分量。
		 */
		public function get specularColorR():Number {
			return _SpecColorR;
		}
		
		/**
		 * 设置高光颜色R分量。
		 * @param value 高光颜色R分量。
		 */
		public function set specularColorR(value:Number):void {
			_SpecColorR = value;
		}
		
		/**
		 * 获取高光颜色G分量。
		 * @return 高光颜色G分量。
		 */
		public function get specularColorG():Number {
			return _SpecColorG;
		}
		
		/**
		 * 设置高光颜色G分量。
		 * @param value 高光颜色G分量。
		 */
		public function set specularColorG(value:Number):void {
			_SpecColorG = value;
		}
		
		/**
		 * 获取高光颜色B分量。
		 * @return 高光颜色B分量。
		 */
		public function get specularColorB():Number {
			return _SpecColorB;
		}
		
		/**
		 * 设置高光颜色B分量。
		 * @param value 高光颜色B分量。
		 */
		public function set specularColorB(value:Number):void {
			_SpecColorB = value;
		}
		
		/**
		 * 获取高光颜色A分量。
		 * @return 高光颜色A分量。
		 */
		public function get specularColorA():Number {
			return _SpecColorA;
		}
		
		/**
		 * 设置高光颜色A分量。
		 * @param value 高光颜色A分量。
		 */
		public function set specularColorA(value:Number):void {
			_SpecColorA = value;
		}
		
		/**
		 * 获取高光颜色。
		 * @return 高光颜色。
		 */
		public function get specularColor():Vector4 {
			return _shaderValues.getVector(MATERIALSPECULAR) as Vector4;
		}
		
		/**
		 * 设置高光颜色。
		 * @param value 高光颜色。
		 */
		public function set specularColor(value:Vector4):void {
			_shaderValues.setVector(MATERIALSPECULAR, value);
		}
		
		/**
		 * 获取高光强度,范围为0到1。
		 * @return 高光强度。
		 */
		public function get shininess():Number {
			return _Shininess;
		}
		
		/**
		 * 设置高光强度,范围为0到1。
		 * @param value 高光强度。
		 */
		public function set shininess(value:Number):void {
			_Shininess = value;
		}
		
		/**
		 * 获取反照率贴图。
		 * @return 反照率贴图。
		 */
		public function get albedoTexture():BaseTexture {
			return _shaderValues.getTexture(ALBEDOTEXTURE);
		}
		
		/**
		 * 设置反照率贴图。
		 * @param value 反照率贴图。
		 */
		public function set albedoTexture(value:BaseTexture):void {
			if (value)
				_defineDatas.add(CubeMaterial.SHADERDEFINE_DIFFUSEMAP);
			else
				_defineDatas.remove(CubeMaterial.SHADERDEFINE_DIFFUSEMAP);
			_shaderValues.setTexture(ALBEDOTEXTURE, value);
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
				_defineDatas.add(CubeMaterial.SHADERDEFINE_NORMALMAP);
			else
				_defineDatas.remove(CubeMaterial.SHADERDEFINE_NORMALMAP);
			_shaderValues.setTexture(NORMALTEXTURE, value);
		}
		
		/**
		 * 获取高光贴图。
		 * @return 高光贴图。
		 */
		public function get specularTexture():BaseTexture {
			return _shaderValues.getTexture(SPECULARTEXTURE);
		}
		
		/**
		 * 设置高光贴图，高光强度则从该贴图RGB值中获取,如果该值为空则从漫反射贴图的Alpha通道获取。
		 * @param value  高光贴图。
		 */
		public function set specularTexture(value:BaseTexture):void {
			if (value)
				_defineDatas.add(CubeMaterial.SHADERDEFINE_SPECULARMAP);
			else
				_defineDatas.remove(CubeMaterial.SHADERDEFINE_SPECULARMAP);
			
			_shaderValues.setTexture(SPECULARTEXTURE, value);
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
		 * 禁用雾化。
		 */
		public function disableFog():void {
			_disablePublicDefineDatas.add(Scene3D.SHADERDEFINE_FOG);
		}
		
		/**
		 * 创建一个 <code>CubeMaterial</code> 实例。
		 */
		public function CubeMaterial() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super(12);
			setShaderName("CUBESHADER");
			_albedoIntensity = 1.0;
			_albedoColor = new Vector4(1.0, 1.0, 1.0, 1.0);
			var sv:ShaderData = _shaderValues;
			sv.setVector(ALBEDOCOLOR, new Vector4(1.0, 1.0, 1.0, 1.0));
			sv.setVector(MATERIALSPECULAR, new Vector4(1.0, 1.0, 1.0, 1.0));
			sv.setNumber(SHININESS, 0.078125);
			sv.setNumber(ALPHATESTVALUE, 0.5);
			sv.setVector(TILINGOFFSET, new Vector4(1.0, 1.0, 0.0, 0.0));
			_enableLighting = true;
			renderMode = RENDERMODE_OPAQUE;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var destMaterial:CubeMaterial = destObject as CubeMaterial;
			destMaterial._enableLighting = _enableLighting;
			destMaterial._albedoIntensity = _albedoIntensity;
			_albedoColor.cloneTo(destMaterial._albedoColor);
		}
	}

}