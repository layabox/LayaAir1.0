package laya.d3.shader {
	import laya.d3.core.BaseCamera;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.glitter.Glitter;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.BlinnPhongMaterial;
	import laya.d3.core.material.ExtendTerrainMaterial;
	import laya.d3.core.material.GlitterMaterial;
	import laya.d3.core.material.PBRMaterial;
	import laya.d3.core.material.PBRSpecularMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.material.TerrainMaterial;
	import laya.d3.core.material.PBRStandardMaterial;
	import laya.d3.core.material.WaterMaterial;
	import laya.d3.core.particleShuriKen.ShuriKenParticle3D;
	import laya.d3.core.particleShuriKen.ShurikenParticleMaterial;
	import laya.d3.core.scene.Scene;
	import laya.d3.core.trail.TrailMaterial;
	import laya.d3.core.trail.TrailSprite3D;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.resource.models.Sky;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	
	/**
	 * @private
	 * <code>ShaderInit</code> 类用于初始化内置Shader。
	 */
	public class ShaderInit3D {
		/**
		 * 创建一个 <code>ShaderInit</code> 实例。
		 */
		public function ShaderInit3D() {
		}
		
		/**
		 * @private
		 */
		public static function __init__():void {
			ShaderCompile3D._globalRegDefine("HIGHPRECISION", ShaderCompile3D.SHADERDEFINE_HIGHPRECISION);
			ShaderCompile3D._globalRegDefine("FOG", ShaderCompile3D.SHADERDEFINE_FOG);
			ShaderCompile3D._globalRegDefine("DIRECTIONLIGHT", ShaderCompile3D.SHADERDEFINE_DIRECTIONLIGHT);
			ShaderCompile3D._globalRegDefine("POINTLIGHT", ShaderCompile3D.SHADERDEFINE_POINTLIGHT);
			ShaderCompile3D._globalRegDefine("SPOTLIGHT", ShaderCompile3D.SHADERDEFINE_SPOTLIGHT);
			ShaderCompile3D._globalRegDefine("UV", ShaderCompile3D.SHADERDEFINE_UV0);
			ShaderCompile3D._globalRegDefine("COLOR", ShaderCompile3D.SHADERDEFINE_COLOR);
			ShaderCompile3D._globalRegDefine("UV1", ShaderCompile3D.SHADERDEFINE_UV1);
			//TODO:
			ShaderCompile3D._globalRegDefine("CASTSHADOW", ParallelSplitShadowMap.SHADERDEFINE_CAST_SHADOW);
			ShaderCompile3D._globalRegDefine("SHADOWMAP_PSSM1", ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PSSM1);
			ShaderCompile3D._globalRegDefine("SHADOWMAP_PSSM2", ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PSSM2);
			ShaderCompile3D._globalRegDefine("SHADOWMAP_PSSM3", ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PSSM3);
			ShaderCompile3D._globalRegDefine("SHADOWMAP_PCF_NO", ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PCF_NO);
			ShaderCompile3D._globalRegDefine("SHADOWMAP_PCF1", ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PCF1);
			ShaderCompile3D._globalRegDefine("SHADOWMAP_PCF2", ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PCF2);
			ShaderCompile3D._globalRegDefine("SHADOWMAP_PCF3", ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PCF3);
			ShaderCompile3D._globalRegDefine("DEPTHFOG", ShaderCompile3D.SAHDERDEFINE_DEPTHFOG);
			
			Shader3D.addInclude("LightHelper.glsl", __INCLUDESTR__("files/LightHelper.glsl"));//兼容性
			Shader3D.addInclude("Lighting.glsl", __INCLUDESTR__("files/Lighting.glsl"));
			Shader3D.addInclude("ShadowHelper.glsl", __INCLUDESTR__("files/ShadowHelper.glsl"));
			Shader3D.addInclude("WaveFunction.glsl", __INCLUDESTR__("files/WaveFunction.glsl"));
			Shader3D.addInclude("BRDF.glsl", __INCLUDESTR__("files/PBRLibs/BRDF.glsl"));
			Shader3D.addInclude("PBRUtils.glsl", __INCLUDESTR__("files/PBRLibs/PBRUtils.glsl"));
			Shader3D.addInclude("PBRStandardLighting.glsl", __INCLUDESTR__("files/PBRLibs/PBRStandardLighting.glsl"));
			Shader3D.addInclude("PBRSpecularLighting.glsl", __INCLUDESTR__("files/PBRLibs/PBRSpecularLighting.glsl"));
			
			var vs:String, ps:String;
			var attributeMap:Object = {
				'a_Position': VertexElementUsage.POSITION0, 
				'a_Color': VertexElementUsage.COLOR0, 
				'a_Normal': VertexElementUsage.NORMAL0, 
				'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0, 
				'a_Texcoord1': VertexElementUsage.TEXTURECOORDINATE1, 
				'a_BoneWeights': VertexElementUsage.BLENDWEIGHT0, 
				'a_BoneIndices': VertexElementUsage.BLENDINDICES0, 
				'a_Tangent0': VertexElementUsage.TANGENT0};
			var uniformMap:Object = {
				'u_Bones': [SkinnedMeshSprite3D.BONES, Shader3D.PERIOD_RENDERELEMENT], 
				'u_DiffuseTexture': [BlinnPhongMaterial.ALBEDOTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_SpecularTexture': [BlinnPhongMaterial.SPECULARTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_NormalTexture': [BlinnPhongMaterial.NORMALTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_ReflectTexture': [BlinnPhongMaterial.REFLECTTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_AlphaTestValue': [BaseMaterial.ALPHATESTVALUE, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseColor': [BlinnPhongMaterial.ALBEDOCOLOR, Shader3D.PERIOD_MATERIAL], 
				'u_MaterialSpecular': [BlinnPhongMaterial.MATERIALSPECULAR, Shader3D.PERIOD_MATERIAL], 
				'u_Shininess': [BlinnPhongMaterial.SHININESS, Shader3D.PERIOD_MATERIAL], 
				'u_MaterialReflect': [BlinnPhongMaterial.MATERIALREFLECT, Shader3D.PERIOD_MATERIAL], 
				'u_TilingOffset': [BlinnPhongMaterial.TILINGOFFSET, Shader3D.PERIOD_MATERIAL],
				'u_WorldMat': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_LightmapScaleOffset': [RenderableSprite3D.LIGHTMAPSCALEOFFSET, Shader3D.PERIOD_SPRITE], 
				'u_LightMap': [RenderableSprite3D.LIGHTMAP, Shader3D.PERIOD_SPRITE],
				'u_CameraPos': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 
				'u_FogStart': [Scene.FOGSTART, Shader3D.PERIOD_SCENE], 
				'u_FogRange': [Scene.FOGRANGE, Shader3D.PERIOD_SCENE], 
				'u_FogColor': [Scene.FOGCOLOR, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Color': [Scene.LIGHTDIRCOLOR, Shader3D.PERIOD_SCENE],
				'u_DirectionLight.Direction': [Scene.LIGHTDIRECTION, Shader3D.PERIOD_SCENE],  
				'u_PointLight.Position': [Scene.POINTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Range': [Scene.POINTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Color': [Scene.POINTLIGHTCOLOR, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Position': [Scene.SPOTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Direction': [Scene.SPOTLIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Range': [Scene.SPOTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Spot': [Scene.SPOTLIGHTSPOT, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Color': [Scene.SPOTLIGHTCOLOR, Shader3D.PERIOD_SCENE], 
				'u_AmbientColor': [Scene.AMBIENTCOLOR, Shader3D.PERIOD_SCENE],
				'u_shadowMap1': [Scene.SHADOWMAPTEXTURE1, Shader3D.PERIOD_SCENE], 
				'u_shadowMap2': [Scene.SHADOWMAPTEXTURE2, Shader3D.PERIOD_SCENE], 
				'u_shadowMap3': [Scene.SHADOWMAPTEXTURE3, Shader3D.PERIOD_SCENE], 
				'u_shadowPSSMDistance': [Scene.SHADOWDISTANCE, Shader3D.PERIOD_SCENE], 
				'u_lightShadowVP': [Scene.SHADOWLIGHTVIEWPROJECT, Shader3D.PERIOD_SCENE], 
				'u_shadowPCFoffset': [Scene.SHADOWMAPPCFOFFSET, Shader3D.PERIOD_SCENE]};
			
			var BLINNPHONG:int = Shader3D.nameKey.add("BLINNPHONG");
			vs = __INCLUDESTR__("files/Mesh-BlinnPhong.vs");
			ps = __INCLUDESTR__("files/Mesh-BlinnPhong.ps");
			var shaderCompile:ShaderCompile3D = ShaderCompile3D.add(BLINNPHONG, vs, ps, attributeMap, uniformMap);
			BlinnPhongMaterial.SHADERDEFINE_DIFFUSEMAP = shaderCompile.registerMaterialDefine("DIFFUSEMAP");
			BlinnPhongMaterial.SHADERDEFINE_NORMALMAP = shaderCompile.registerMaterialDefine("NORMALMAP");
			BlinnPhongMaterial.SHADERDEFINE_SPECULARMAP = shaderCompile.registerMaterialDefine("SPECULARMAP");
			BlinnPhongMaterial.SHADERDEFINE_REFLECTMAP = shaderCompile.registerMaterialDefine("REFLECTMAP");
			BlinnPhongMaterial.SHADERDEFINE_TILINGOFFSET = shaderCompile.registerMaterialDefine("TILINGOFFSET");
			BlinnPhongMaterial.SHADERDEFINE_ADDTIVEFOG = shaderCompile.registerMaterialDefine("ADDTIVEFOG");
			
			attributeMap = {
				'a_Position': VertexElementUsage.POSITION0, 
				'a_Color': VertexElementUsage.COLOR0, 
				'a_Normal': VertexElementUsage.NORMAL0, 
				'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0, 
				'a_Texcoord1': VertexElementUsage.TEXTURECOORDINATE1, 
				'a_TexcoordNext0': VertexElementUsage.NEXTTEXTURECOORDINATE0, 
				'a_BoneWeights': VertexElementUsage.BLENDWEIGHT0, 
				'a_BoneIndices': VertexElementUsage.BLENDINDICES0, 
				'a_Tangent0': VertexElementUsage.TANGENT0};
			uniformMap = {
				'u_Bones': [SkinnedMeshSprite3D.BONES, Shader3D.PERIOD_RENDERELEMENT], 
				'u_DiffuseTexture': [StandardMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_SpecularTexture': [StandardMaterial.SPECULARTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_NormalTexture': [StandardMaterial.NORMALTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_AmbientTexture': [StandardMaterial.AMBIENTTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_ReflectTexture': [StandardMaterial.REFLECTTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_AlphaTestValue': [BaseMaterial.ALPHATESTVALUE, Shader3D.PERIOD_MATERIAL], 
				'u_Albedo': [StandardMaterial.ALBEDO, Shader3D.PERIOD_MATERIAL], 
				'u_UVMatrix': [StandardMaterial.UVMATRIX, Shader3D.PERIOD_MATERIAL], 
				'u_UVAge': [StandardMaterial.UVAGE, Shader3D.PERIOD_MATERIAL], 
				'u_UVAniAge': [StandardMaterial.UVANIAGE, Shader3D.PERIOD_MATERIAL], 
				'u_MaterialDiffuse': [StandardMaterial.MATERIALDIFFUSE, Shader3D.PERIOD_MATERIAL], 
				'u_MaterialAmbient': [StandardMaterial.MATERIALAMBIENT, Shader3D.PERIOD_MATERIAL], 
				'u_MaterialSpecular': [StandardMaterial.MATERIALSPECULAR, Shader3D.PERIOD_MATERIAL], 
				'u_MaterialReflect': [StandardMaterial.MATERIALREFLECT, Shader3D.PERIOD_MATERIAL], 
				'u_TilingOffset': [StandardMaterial.TILINGOFFSET, Shader3D.PERIOD_MATERIAL],
				'u_WorldMat': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_LightmapScaleOffset': [RenderableSprite3D.LIGHTMAPSCALEOFFSET, Shader3D.PERIOD_SPRITE], 
				'u_LightMap': [RenderableSprite3D.LIGHTMAP, Shader3D.PERIOD_SPRITE],
				'u_CameraPos': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 
				'u_FogStart': [Scene.FOGSTART, Shader3D.PERIOD_SCENE], 
				'u_FogRange': [Scene.FOGRANGE, Shader3D.PERIOD_SCENE], 
				'u_FogColor': [Scene.FOGCOLOR, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Direction': [Scene.LIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Diffuse': [Scene.LIGHTDIRCOLOR, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Position': [Scene.POINTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Range': [Scene.POINTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Attenuation': [Scene.POINTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Diffuse': [Scene.POINTLIGHTCOLOR, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Position': [Scene.SPOTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Direction': [Scene.SPOTLIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Range': [Scene.SPOTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Spot': [Scene.SPOTLIGHTSPOT, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Attenuation': [Scene.SPOTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Diffuse': [Scene.SPOTLIGHTCOLOR, Shader3D.PERIOD_SCENE], 
				'u_AmbientColor': [Scene.AMBIENTCOLOR, Shader3D.PERIOD_SCENE],
				'u_shadowMap1': [Scene.SHADOWMAPTEXTURE1, Shader3D.PERIOD_SCENE], 
				'u_shadowMap2': [Scene.SHADOWMAPTEXTURE2, Shader3D.PERIOD_SCENE], 
				'u_shadowMap3': [Scene.SHADOWMAPTEXTURE3, Shader3D.PERIOD_SCENE], 
				'u_shadowPSSMDistance': [Scene.SHADOWDISTANCE, Shader3D.PERIOD_SCENE], 
				'u_lightShadowVP': [Scene.SHADOWLIGHTVIEWPROJECT, Shader3D.PERIOD_SCENE], 
				'u_shadowPCFoffset': [Scene.SHADOWMAPPCFOFFSET, Shader3D.PERIOD_SCENE]};
			
			var SIMPLE:int = Shader3D.nameKey.add("SIMPLE");
			vs = __INCLUDESTR__("files/PixelSimpleTextureSkinnedMesh.vs");
			ps = __INCLUDESTR__("files/PixelSimpleTextureSkinnedMesh.ps");
			shaderCompile = ShaderCompile3D.add(SIMPLE, vs, ps, attributeMap, uniformMap);
			StandardMaterial.SHADERDEFINE_DIFFUSEMAP = shaderCompile.registerMaterialDefine("DIFFUSEMAP");
			StandardMaterial.SHADERDEFINE_NORMALMAP = shaderCompile.registerMaterialDefine("NORMALMAP");
			StandardMaterial.SHADERDEFINE_SPECULARMAP = shaderCompile.registerMaterialDefine("SPECULARMAP");
			StandardMaterial.SHADERDEFINE_EMISSIVEMAP = shaderCompile.registerMaterialDefine("EMISSIVEMAP");
			StandardMaterial.SHADERDEFINE_AMBIENTMAP = shaderCompile.registerMaterialDefine("AMBIENTMAP");
			StandardMaterial.SHADERDEFINE_REFLECTMAP = shaderCompile.registerMaterialDefine("REFLECTMAP");
			StandardMaterial.SHADERDEFINE_UVTRANSFORM = shaderCompile.registerMaterialDefine("UVTRANSFORM");
			StandardMaterial.SHADERDEFINE_TILINGOFFSET = shaderCompile.registerMaterialDefine("TILINGOFFSET");
			StandardMaterial.SHADERDEFINE_ADDTIVEFOG = shaderCompile.registerMaterialDefine("ADDTIVEFOG");
			
			attributeMap = {
				'a_Position': VertexElementUsage.POSITION0, 
				'a_Color': VertexElementUsage.COLOR0};
			uniformMap = {
				'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE]};
			var LINE:int = Shader3D.nameKey.add("LINE");
			vs = __INCLUDESTR__("files/line.vs");
			ps = __INCLUDESTR__("files/line.ps");
			ShaderCompile3D.add(LINE, vs, ps, attributeMap, uniformMap);
			
			attributeMap = {
				'a_position': VertexElementUsage.POSITION0, 
				'a_normal': VertexElementUsage.NORMAL0, 
				'tangent': VertexElementUsage.TANGENT0, 
				'binormal': VertexElementUsage.BINORMAL0, 
				'uv': VertexElementUsage.TEXTURECOORDINATE0, 
				'a_BoneWeights': VertexElementUsage.BLENDWEIGHT0, 
				'a_BoneIndices': VertexElementUsage.BLENDINDICES0, 
				'a_Tangent0': VertexElementUsage.TANGENT0};
			uniformMap = {
				'u_Bones': [SkinnedMeshSprite3D.BONES, Shader3D.PERIOD_RENDERELEMENT], 
				'u_lodRect': [BaseCamera.SIMLODINFO, Shader3D.PERIOD_CAMERA], 
				'irrad_mat_red': [BaseCamera.DIFFUSEIRRADMATR, Shader3D.PERIOD_CAMERA], 
				'irrad_mat_green': [BaseCamera.DIFFUSEIRRADMATG, Shader3D.PERIOD_CAMERA], 
				'irrad_mat_blue': [BaseCamera.DIFFUSEIRRADMATB, Shader3D.PERIOD_CAMERA], 
				'u_hdrexposure': [BaseCamera.HDREXPOSURE, Shader3D.PERIOD_CAMERA], 
				'u_aoObjPos': [PBRMaterial.AOOBJPOS, Shader3D.PERIOD_MATERIAL], 
				'texBaseColor': [PBRMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 
				'texNormal': [PBRMaterial.NORMALTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'texPbrInfo': [PBRMaterial.PBRINFOTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'texPrefilterdEnv': [BaseCamera.ENVIRONMENTSPECULAR, Shader3D.PERIOD_CAMERA], 
				'texHSNoise': [PBRMaterial.HSNOISETEXTURE, Shader3D.PERIOD_MATERIAL], 
				'texPrefilterDiff': [BaseCamera.ENVIRONMENTDIFFUSE, Shader3D.PERIOD_CAMERA], 
				'u_AlphaTestValue': [BaseMaterial.ALPHATESTVALUE, Shader3D.PERIOD_MATERIAL], 
				'texBRDFLUT': [PBRMaterial.PBRLUTTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_UVAniAge': [PBRMaterial.UVANIAGE, Shader3D.PERIOD_MATERIAL], 
				'u_roughness': [PBRMaterial.MATERIALROUGHNESS, Shader3D.PERIOD_MATERIAL], 
				'u_metaless': [PBRMaterial.MATERIALMETALESS, Shader3D.PERIOD_MATERIAL], 
				'u_UVMatrix': [PBRMaterial.UVMATRIX, Shader3D.PERIOD_MATERIAL], 
				'u_UVAge': [PBRMaterial.UVAGE, Shader3D.PERIOD_MATERIAL], 
				'modelMatrix': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE], 
				'mvp': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 
				//'u_vpMatrix':[BaseCamera.VPMATRIX,Shader3D.PERIOD_CAMERA],
				'cameraPosition': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 
				'u_View': [BaseCamera.VIEWMATRIX, Shader3D.PERIOD_CAMERA], 
				'u_Project': [BaseCamera.PROJECTMATRIX, Shader3D.PERIOD_CAMERA], 
				'u_FogStart': [Scene.FOGSTART, Shader3D.PERIOD_SCENE], 
				'u_FogRange': [Scene.FOGRANGE, Shader3D.PERIOD_SCENE], 
				'u_FogColor': [Scene.FOGCOLOR, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Direction': [Scene.LIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Diffuse': [Scene.LIGHTDIRCOLOR, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Position': [Scene.POINTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Range': [Scene.POINTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Attenuation': [Scene.POINTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Diffuse': [Scene.POINTLIGHTCOLOR, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Position': [Scene.SPOTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Direction': [Scene.SPOTLIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Range': [Scene.SPOTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Spot': [Scene.SPOTLIGHTSPOT, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Attenuation': [Scene.SPOTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Diffuse': [Scene.SPOTLIGHTCOLOR, Shader3D.PERIOD_SCENE], 
				'u_shadowMap1': [Scene.SHADOWMAPTEXTURE1, Shader3D.PERIOD_SCENE], //TODO:SM
				'u_shadowMap2': [Scene.SHADOWMAPTEXTURE2, Shader3D.PERIOD_SCENE], //TODO:SM
				'u_shadowMap3': [Scene.SHADOWMAPTEXTURE3, Shader3D.PERIOD_SCENE], //TODO:SM
				'u_shadowPSSMDistance': [Scene.SHADOWDISTANCE, Shader3D.PERIOD_SCENE],//TODO:SM
				'u_lightShadowVP': [Scene.SHADOWLIGHTVIEWPROJECT, Shader3D.PERIOD_SCENE],//TODO:SM
				'u_shadowPCFoffset': [Scene.SHADOWMAPPCFOFFSET, Shader3D.PERIOD_SCENE]};
			var PBR:int = Shader3D.nameKey.add("PBR");
			vs = __INCLUDESTR__("files/PBR.vs");
			ps = __INCLUDESTR__("files/PBR.ps");
			shaderCompile = ShaderCompile3D.add(PBR, vs, ps, attributeMap, uniformMap);
			PBRMaterial.SHADERDEFINE_FIX_METALESS = shaderCompile.registerMaterialDefine("FIX_METALESS");
			PBRMaterial.SHADERDEFINE_FIX_ROUGHNESS = shaderCompile.registerMaterialDefine("FIX_ROUGHNESS");
			PBRMaterial.SHADERDEFINE_HAS_TANGENT = shaderCompile.registerMaterialDefine("HAS_TANGENT");
			PBRMaterial.SHADERDEFINE_HAS_PBRINFO = shaderCompile.registerMaterialDefine("HAS_PBRINFO");
			PBRMaterial.SHADERDEFINE_USE_GROUNDTRUTH = shaderCompile.registerMaterialDefine("USE_GROUNDTRUTH");
			PBRMaterial.SHADERDEFINE_TEST_CLIPZ = shaderCompile.registerMaterialDefine("CLIPZ");
			
			//PBRStandard
			attributeMap = {
				'a_Position': VertexElementUsage.POSITION0, 
				'a_Normal': VertexElementUsage.NORMAL0,
				'a_Tangent0': VertexElementUsage.TANGENT0,
				'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0,
				'a_BoneWeights': VertexElementUsage.BLENDWEIGHT0, 
				'a_BoneIndices': VertexElementUsage.BLENDINDICES0
			};
			uniformMap = {
				'u_Bones': [SkinnedMeshSprite3D.BONES, Shader3D.PERIOD_RENDERELEMENT], 
				'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_WorldMat': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE],
				'u_CameraPos': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 
				'u_AlphaTestValue': [BaseMaterial.ALPHATESTVALUE, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseColor': [PBRStandardMaterial.DIFFUSECOLOR, Shader3D.PERIOD_MATERIAL], 
				'u_EmissionColor': [PBRStandardMaterial.EMISSIONCOLOR, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseTexture': [PBRStandardMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL],
				'u_NormalTexture': [PBRStandardMaterial.NORMALTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_ParallaxTexture': [PBRStandardMaterial.PARALLAXTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_MetallicGlossTexture': [PBRStandardMaterial.METALLICGLOSSTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_OcclusionTexture': [PBRStandardMaterial.OCCLUSIONTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_EmissionTexture': [PBRStandardMaterial.EMISSIONTEXTURE, Shader3D.PERIOD_MATERIAL], 
				//'u_ReflectTexture': [UnityPBRMaterial.REFLECTTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_metallic': [PBRStandardMaterial.METALLIC, Shader3D.PERIOD_MATERIAL], 
				'u_smoothness': [PBRStandardMaterial.SMOOTHNESS, Shader3D.PERIOD_MATERIAL],
				'u_smoothnessScale': [PBRStandardMaterial.SMOOTHNESSSCALE, Shader3D.PERIOD_MATERIAL],
				'u_occlusionStrength': [PBRStandardMaterial.OCCLUSIONSTRENGTH, Shader3D.PERIOD_MATERIAL],
				'u_normalScale': [PBRStandardMaterial.NORMALSCALE, Shader3D.PERIOD_MATERIAL],
				'u_parallaxScale': [PBRStandardMaterial.PARALLAXSCALE, Shader3D.PERIOD_MATERIAL],
				'u_TilingOffset': [PBRStandardMaterial.TILINGOFFSET, Shader3D.PERIOD_MATERIAL],
				'u_DirectionLight.Direction': [Scene.LIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Color': [Scene.LIGHTDIRCOLOR, Shader3D.PERIOD_SCENE],
				'u_AmbientColor': [Scene.AMBIENTCOLOR, Shader3D.PERIOD_SCENE],
				'u_shadowMap1': [Scene.SHADOWMAPTEXTURE1, Shader3D.PERIOD_SCENE], 
				'u_shadowMap2': [Scene.SHADOWMAPTEXTURE2, Shader3D.PERIOD_SCENE], 
				'u_shadowMap3': [Scene.SHADOWMAPTEXTURE3, Shader3D.PERIOD_SCENE], 
				'u_shadowPSSMDistance': [Scene.SHADOWDISTANCE, Shader3D.PERIOD_SCENE], 
				'u_lightShadowVP': [Scene.SHADOWLIGHTVIEWPROJECT, Shader3D.PERIOD_SCENE], 
				'u_shadowPCFoffset': [Scene.SHADOWMAPPCFOFFSET, Shader3D.PERIOD_SCENE]
			};
			var PBRStandard:int = Shader3D.nameKey.add("PBRStandard");
			vs = __INCLUDESTR__("files/PBRStandard.vs");
			ps = __INCLUDESTR__("files/PBRStandard.ps");
			shaderCompile = ShaderCompile3D.add(PBRStandard, vs, ps, attributeMap, uniformMap);
			PBRStandardMaterial.SHADERDEFINE_DIFFUSETEXTURE = shaderCompile.registerMaterialDefine("DIFFUSETEXTURE");
			PBRStandardMaterial.SHADERDEFINE_METALLICGLOSSTEXTURE = shaderCompile.registerMaterialDefine("METALLICGLOSSTEXTURE");
			PBRStandardMaterial.SHADERDEFINE_SMOOTHNESSSOURCE_DIFFUSETEXTURE_ALPHA = shaderCompile.registerMaterialDefine("SMOOTHNESSSOURCE_DIFFUSETEXTURE_ALPHA");
			PBRStandardMaterial.SHADERDEFINE_NORMALTEXTURE = shaderCompile.registerMaterialDefine("NORMALTEXTURE");
			PBRStandardMaterial.SHADERDEFINE_PARALLAXTEXTURE = shaderCompile.registerMaterialDefine("PARALLAXTEXTURE");
			PBRStandardMaterial.SHADERDEFINE_OCCLUSIONTEXTURE = shaderCompile.registerMaterialDefine("OCCLUSIONTEXTURE");
			PBRStandardMaterial.SHADERDEFINE_EMISSION = shaderCompile.registerMaterialDefine("EMISSION");
			PBRStandardMaterial.SHADERDEFINE_EMISSIONTEXTURE = shaderCompile.registerMaterialDefine("EMISSIONTEXTURE");
			PBRStandardMaterial.SHADERDEFINE_TILINGOFFSET = shaderCompile.registerMaterialDefine("TILINGOFFSET");
			
			//PBRSpecular
			attributeMap = {
				'a_Position': VertexElementUsage.POSITION0, 
				'a_Normal': VertexElementUsage.NORMAL0,
				'a_Tangent0': VertexElementUsage.TANGENT0,
				'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0,
				'a_BoneWeights': VertexElementUsage.BLENDWEIGHT0, 
				'a_BoneIndices': VertexElementUsage.BLENDINDICES0
			};
			uniformMap = {
				'u_Bones': [SkinnedMeshSprite3D.BONES, Shader3D.PERIOD_RENDERELEMENT], 
				'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_WorldMat': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE],
				'u_CameraPos': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 
				'u_AlphaTestValue': [BaseMaterial.ALPHATESTVALUE, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseColor': [PBRSpecularMaterial.DIFFUSECOLOR, Shader3D.PERIOD_MATERIAL], 
				'u_SpecularColor': [PBRSpecularMaterial.SPECULARCOLOR, Shader3D.PERIOD_MATERIAL], 
				'u_EmissionColor': [PBRSpecularMaterial.EMISSIONCOLOR, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseTexture': [PBRSpecularMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL],
				'u_NormalTexture': [PBRSpecularMaterial.NORMALTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_ParallaxTexture': [PBRSpecularMaterial.PARALLAXTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_SpecularTexture': [PBRSpecularMaterial.SPECULARTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_OcclusionTexture': [PBRSpecularMaterial.OCCLUSIONTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_EmissionTexture': [PBRSpecularMaterial.EMISSIONTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_smoothness': [PBRSpecularMaterial.SMOOTHNESS, Shader3D.PERIOD_MATERIAL],
				'u_smoothnessScale': [PBRSpecularMaterial.SMOOTHNESSSCALE, Shader3D.PERIOD_MATERIAL],
				'u_occlusionStrength': [PBRSpecularMaterial.OCCLUSIONSTRENGTH, Shader3D.PERIOD_MATERIAL],
				'u_normalScale': [PBRSpecularMaterial.NORMALSCALE, Shader3D.PERIOD_MATERIAL],
				'u_parallaxScale': [PBRSpecularMaterial.PARALLAXSCALE, Shader3D.PERIOD_MATERIAL],
				'u_TilingOffset': [PBRSpecularMaterial.TILINGOFFSET, Shader3D.PERIOD_MATERIAL],
				'u_DirectionLight.Direction': [Scene.LIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Color': [Scene.LIGHTDIRCOLOR, Shader3D.PERIOD_SCENE],
				'u_AmbientColor': [Scene.AMBIENTCOLOR, Shader3D.PERIOD_SCENE],
				'u_shadowMap1': [Scene.SHADOWMAPTEXTURE1, Shader3D.PERIOD_SCENE], 
				'u_shadowMap2': [Scene.SHADOWMAPTEXTURE2, Shader3D.PERIOD_SCENE], 
				'u_shadowMap3': [Scene.SHADOWMAPTEXTURE3, Shader3D.PERIOD_SCENE], 
				'u_shadowPSSMDistance': [Scene.SHADOWDISTANCE, Shader3D.PERIOD_SCENE], 
				'u_lightShadowVP': [Scene.SHADOWLIGHTVIEWPROJECT, Shader3D.PERIOD_SCENE], 
				'u_shadowPCFoffset': [Scene.SHADOWMAPPCFOFFSET, Shader3D.PERIOD_SCENE]
			};
			var PBRSpecular:int = Shader3D.nameKey.add("PBRSpecular");
			vs = __INCLUDESTR__("files/PBRSpecular.vs");
			ps = __INCLUDESTR__("files/PBRSpecular.ps");
			shaderCompile = ShaderCompile3D.add(PBRSpecular, vs, ps, attributeMap, uniformMap);
			PBRSpecularMaterial.SHADERDEFINE_DIFFUSETEXTURE = shaderCompile.registerMaterialDefine("DIFFUSETEXTURE");
			PBRSpecularMaterial.SHADERDEFINE_SPECULARTEXTURE = shaderCompile.registerMaterialDefine("SPECULARTEXTURE");
			PBRSpecularMaterial.SHADERDEFINE_SMOOTHNESSSOURCE_DIFFUSETEXTURE_ALPHA = shaderCompile.registerMaterialDefine("SMOOTHNESSSOURCE_DIFFUSETEXTURE_ALPHA");
			PBRSpecularMaterial.SHADERDEFINE_NORMALTEXTURE = shaderCompile.registerMaterialDefine("NORMALTEXTURE");
			PBRSpecularMaterial.SHADERDEFINE_PARALLAXTEXTURE = shaderCompile.registerMaterialDefine("PARALLAXTEXTURE");
			PBRSpecularMaterial.SHADERDEFINE_OCCLUSIONTEXTURE = shaderCompile.registerMaterialDefine("OCCLUSIONTEXTURE");
			PBRSpecularMaterial.SHADERDEFINE_EMISSION = shaderCompile.registerMaterialDefine("EMISSION");
			PBRSpecularMaterial.SHADERDEFINE_EMISSIONTEXTURE = shaderCompile.registerMaterialDefine("EMISSIONTEXTURE");
			PBRSpecularMaterial.SHADERDEFINE_TILINGOFFSET = shaderCompile.registerMaterialDefine("TILINGOFFSET");
			
			//water
			attributeMap = {
				'a_position': VertexElementUsage.POSITION0, 
				'a_normal': VertexElementUsage.NORMAL0, 
				'uv': VertexElementUsage.TEXTURECOORDINATE0};
			uniformMap = {
				'irrad_mat_red': [BaseCamera.DIFFUSEIRRADMATR, Shader3D.PERIOD_CAMERA], 
				'irrad_mat_green': [BaseCamera.DIFFUSEIRRADMATG, Shader3D.PERIOD_CAMERA], 
				'irrad_mat_blue': [BaseCamera.DIFFUSEIRRADMATB, Shader3D.PERIOD_CAMERA], 
				'u_hdrexposure': [BaseCamera.HDREXPOSURE, Shader3D.PERIOD_CAMERA], 
				'texBaseColor': [WaterMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 
				'texNormal': [WaterMaterial.NORMALTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'texSky': [WaterMaterial.SKYTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'texUnderWater': [WaterMaterial.UNDERWATERTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'texPrefilterdEnv': [BaseCamera.ENVIRONMENTSPECULAR, Shader3D.PERIOD_CAMERA], 
				'texPrefilterDiff': [BaseCamera.ENVIRONMENTDIFFUSE, Shader3D.PERIOD_CAMERA], 
				'texWaterDisp': [WaterMaterial.VERTEXDISPTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'texWaveDetail': [WaterMaterial.DETAILTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'texDeepColor': [WaterMaterial.DEEPCOLORTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'texWaterInfo': [WaterMaterial.WATERINFO, Shader3D.PERIOD_MATERIAL], 
				'texFoam': [WaterMaterial.FOAMTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'GEOWAVE_UV_SCALE': [WaterMaterial.GEOWAVE_UV_SCALE, Shader3D.PERIOD_MATERIAL], 
				'modelMatrix': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE], 
				'mvp': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 
				//'u_vpMatrix':[BaseCamera.VPMATRIX,Shader3D.PERIOD_CAMERA],
				'cameraPosition': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 
				'u_curTm': [WaterMaterial.CURTM, Shader3D.PERIOD_MATERIAL],//这个要改成全局的
				'u_scrsize': [WaterMaterial.SCRSIZE, Shader3D.PERIOD_MATERIAL],//TODO 这个要全局的
				'u_WaveInfoD': [WaterMaterial.WAVEINFOD, Shader3D.PERIOD_MATERIAL], 
				'u_WaveInfo': [WaterMaterial.WAVEINFO, Shader3D.PERIOD_MATERIAL], 
				'u_WaveMainDir': [WaterMaterial.WAVEMAINDIR, Shader3D.PERIOD_MATERIAL],//转换矩阵
				'u_DeepScale': [WaterMaterial.WAVEINFODEEPSCALE, Shader3D.PERIOD_MATERIAL], 
				'u_SeaColor': [WaterMaterial.SEA_COLOR, Shader3D.PERIOD_MATERIAL], 
				'u_View': [BaseCamera.VIEWMATRIX, Shader3D.PERIOD_CAMERA], 
				'u_Project': [BaseCamera.PROJECTMATRIX, Shader3D.PERIOD_CAMERA], 
				'u_FogStart': [Scene.FOGSTART, Shader3D.PERIOD_SCENE], 
				'u_FogRange': [Scene.FOGRANGE, Shader3D.PERIOD_SCENE], 
				'u_FogColor': [Scene.FOGCOLOR, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Direction': [Scene.LIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Diffuse': [Scene.LIGHTDIRCOLOR, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Position': [Scene.POINTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Range': [Scene.POINTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Attenuation': [Scene.POINTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Diffuse': [Scene.POINTLIGHTCOLOR, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Position': [Scene.SPOTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Direction': [Scene.SPOTLIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Range': [Scene.SPOTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Spot': [Scene.SPOTLIGHTSPOT, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Attenuation': [Scene.SPOTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Diffuse': [Scene.SPOTLIGHTCOLOR, Shader3D.PERIOD_SCENE]};
			var Water:int = Shader3D.nameKey.add("Water");
			vs = __INCLUDESTR__("files/water.vs");
			ps = __INCLUDESTR__("files/water.ps");
			shaderCompile = ShaderCompile3D.add(Water, vs, ps, attributeMap, uniformMap);
			WaterMaterial.SHADERDEFINE_CUBE_ENV = shaderCompile.registerMaterialDefine("CUBE_ENV");
			WaterMaterial.SHADERDEFINE_HDR_ENV = shaderCompile.registerMaterialDefine("HDR_ENV");
			WaterMaterial.SHADERDEFINE_SHOW_NORMAL = shaderCompile.registerMaterialDefine("SHOW_NORMAL");
			WaterMaterial.SHADERDEFINE_USEVERTEXHEIGHT = shaderCompile.registerMaterialDefine("USE_VERTEX_DEEPINFO");
			WaterMaterial.SHADERDEFINE_USE_FOAM = shaderCompile.registerMaterialDefine("USE_FOAM");
			WaterMaterial.SHADERDEFINE_USE_REFRACT_TEX = shaderCompile.registerMaterialDefine("USE_REFR_TEX");
			
			attributeMap = {
				'a_CornerTextureCoordinate': VertexElementUsage.CORNERTEXTURECOORDINATE0, 
				'a_MeshPosition': VertexElementUsage.POSITION0,
				'a_MeshColor': VertexElementUsage.COLOR0, 
				'a_MeshTextureCoordinate': VertexElementUsage.TEXTURECOORDINATE0,
				'a_ShapePositionStartLifeTime': VertexElementUsage.SHAPEPOSITIONSTARTLIFETIME, 
				'a_DirectionTime': VertexElementUsage.DIRECTIONTIME, 
				'a_StartColor': VertexElementUsage.STARTCOLOR0, 
				'a_EndColor': VertexElementUsage.ENDCOLOR0, 
				'a_StartSize': VertexElementUsage.STARTSIZE, 
				'a_StartRotation0': VertexElementUsage.STARTROTATION, 
				'a_StartSpeed': VertexElementUsage.STARTSPEED, 
				'a_Random0': VertexElementUsage.RANDOM0, 
				'a_Random1': VertexElementUsage.RANDOM1, 
				'a_SimulationWorldPostion': VertexElementUsage.SIMULATIONWORLDPOSTION,
				'a_SimulationWorldRotation': VertexElementUsage.SIMULATIONWORLDROTATION};
			uniformMap = {
				'u_Tintcolor': [ShurikenParticleMaterial.TINTCOLOR, Shader3D.PERIOD_MATERIAL], 
				'u_TilingOffset': [ShurikenParticleMaterial.TILINGOFFSET, Shader3D.PERIOD_MATERIAL],
				'u_texture': [ShurikenParticleMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_WorldPosition': [ShuriKenParticle3D.WORLDPOSITION, Shader3D.PERIOD_SPRITE], 
				'u_WorldRotation': [ShuriKenParticle3D.WORLDROTATION, Shader3D.PERIOD_SPRITE], 
				'u_PositionScale': [ShuriKenParticle3D.POSITIONSCALE, Shader3D.PERIOD_SPRITE], 
				'u_SizeScale': [ShuriKenParticle3D.SIZESCALE, Shader3D.PERIOD_SPRITE], 
				'u_ScalingMode': [ShuriKenParticle3D.SCALINGMODE, Shader3D.PERIOD_SPRITE], 
				'u_Gravity': [ShuriKenParticle3D.GRAVITY, Shader3D.PERIOD_SPRITE], 
				'u_ThreeDStartRotation': [ShuriKenParticle3D.THREEDSTARTROTATION, Shader3D.PERIOD_SPRITE], 
				'u_StretchedBillboardLengthScale': [ShuriKenParticle3D.STRETCHEDBILLBOARDLENGTHSCALE, Shader3D.PERIOD_SPRITE], 
				'u_StretchedBillboardSpeedScale': [ShuriKenParticle3D.STRETCHEDBILLBOARDSPEEDSCALE, Shader3D.PERIOD_SPRITE], 
				'u_SimulationSpace': [ShuriKenParticle3D.SIMULATIONSPACE, Shader3D.PERIOD_SPRITE], 
				'u_CurrentTime': [ShuriKenParticle3D.CURRENTTIME, Shader3D.PERIOD_SPRITE], 
				'u_ColorOverLifeGradientAlphas': [ShuriKenParticle3D.COLOROVERLIFEGRADIENTALPHAS, Shader3D.PERIOD_SPRITE], 
				'u_ColorOverLifeGradientColors': [ShuriKenParticle3D.COLOROVERLIFEGRADIENTCOLORS, Shader3D.PERIOD_SPRITE], 
				'u_MaxColorOverLifeGradientAlphas': [ShuriKenParticle3D.MAXCOLOROVERLIFEGRADIENTALPHAS, Shader3D.PERIOD_SPRITE], 
				'u_MaxColorOverLifeGradientColors': [ShuriKenParticle3D.MAXCOLOROVERLIFEGRADIENTCOLORS, Shader3D.PERIOD_SPRITE], 
				'u_VOLVelocityConst': [ShuriKenParticle3D.VOLVELOCITYCONST, Shader3D.PERIOD_SPRITE],
				'u_VOLVelocityGradientX': [ShuriKenParticle3D.VOLVELOCITYGRADIENTX, Shader3D.PERIOD_SPRITE], 
				'u_VOLVelocityGradientY': [ShuriKenParticle3D.VOLVELOCITYGRADIENTY, Shader3D.PERIOD_SPRITE], 
				'u_VOLVelocityGradientZ': [ShuriKenParticle3D.VOLVELOCITYGRADIENTZ, Shader3D.PERIOD_SPRITE], 
				'u_VOLVelocityConstMax': [ShuriKenParticle3D.VOLVELOCITYCONSTMAX, Shader3D.PERIOD_SPRITE], 
				'u_VOLVelocityGradientMaxX': [ShuriKenParticle3D.VOLVELOCITYGRADIENTXMAX, Shader3D.PERIOD_SPRITE], 
				'u_VOLVelocityGradientMaxY': [ShuriKenParticle3D.VOLVELOCITYGRADIENTYMAX, Shader3D.PERIOD_SPRITE], 
				'u_VOLVelocityGradientMaxZ': [ShuriKenParticle3D.VOLVELOCITYGRADIENTZMAX, Shader3D.PERIOD_SPRITE], 
				'u_VOLSpaceType': [ShuriKenParticle3D.VOLSPACETYPE, Shader3D.PERIOD_SPRITE], 
				'u_SOLSizeGradient': [ShuriKenParticle3D.SOLSIZEGRADIENT, Shader3D.PERIOD_SPRITE], 
				'u_SOLSizeGradientX': [ShuriKenParticle3D.SOLSIZEGRADIENTX, Shader3D.PERIOD_SPRITE], 
				'u_SOLSizeGradientY': [ShuriKenParticle3D.SOLSIZEGRADIENTY, Shader3D.PERIOD_SPRITE], 
				'u_SOLSizeGradientZ': [ShuriKenParticle3D.SOLSizeGradientZ, Shader3D.PERIOD_SPRITE], 
				'u_SOLSizeGradientMax': [ShuriKenParticle3D.SOLSizeGradientMax, Shader3D.PERIOD_SPRITE], 
				'u_SOLSizeGradientMaxX': [ShuriKenParticle3D.SOLSIZEGRADIENTXMAX, Shader3D.PERIOD_SPRITE], 
				'u_SOLSizeGradientMaxY': [ShuriKenParticle3D.SOLSIZEGRADIENTYMAX, Shader3D.PERIOD_SPRITE], 
				'u_SOLSizeGradientMaxZ': [ShuriKenParticle3D.SOLSizeGradientZMAX, Shader3D.PERIOD_SPRITE], 
				'u_ROLAngularVelocityConst': [ShuriKenParticle3D.ROLANGULARVELOCITYCONST, Shader3D.PERIOD_SPRITE], 
				'u_ROLAngularVelocityConstSeprarate': [ShuriKenParticle3D.ROLANGULARVELOCITYCONSTSEPRARATE, Shader3D.PERIOD_SPRITE], 
				'u_ROLAngularVelocityGradient': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENT, Shader3D.PERIOD_SPRITE], 
				'u_ROLAngularVelocityGradientX': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTX, Shader3D.PERIOD_SPRITE], 
				'u_ROLAngularVelocityGradientY': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTY, Shader3D.PERIOD_SPRITE], 
				'u_ROLAngularVelocityGradientZ': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTZ, Shader3D.PERIOD_SPRITE], 
				'u_ROLAngularVelocityGradientW': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTW, Shader3D.PERIOD_SPRITE],
				'u_ROLAngularVelocityConstMax': [ShuriKenParticle3D.ROLANGULARVELOCITYCONSTMAX, Shader3D.PERIOD_SPRITE], 
				'u_ROLAngularVelocityConstMaxSeprarate': [ShuriKenParticle3D.ROLANGULARVELOCITYCONSTMAXSEPRARATE, Shader3D.PERIOD_SPRITE], 
				'u_ROLAngularVelocityGradientMax': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTMAX, Shader3D.PERIOD_SPRITE], 
				'u_ROLAngularVelocityGradientMaxX': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTXMAX, Shader3D.PERIOD_SPRITE], 
				'u_ROLAngularVelocityGradientMaxY': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTYMAX, Shader3D.PERIOD_SPRITE], 
				'u_ROLAngularVelocityGradientMaxZ': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTZMAX, Shader3D.PERIOD_SPRITE],
				'u_ROLAngularVelocityGradientMaxW': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTWMAX, Shader3D.PERIOD_SPRITE], 
				'u_TSACycles': [ShuriKenParticle3D.TEXTURESHEETANIMATIONCYCLES, Shader3D.PERIOD_SPRITE], 
				'u_TSASubUVLength': [ShuriKenParticle3D.TEXTURESHEETANIMATIONSUBUVLENGTH, Shader3D.PERIOD_SPRITE], 
				'u_TSAGradientUVs': [ShuriKenParticle3D.TEXTURESHEETANIMATIONGRADIENTUVS, Shader3D.PERIOD_SPRITE], 
				'u_TSAMaxGradientUVs': [ShuriKenParticle3D.TEXTURESHEETANIMATIONGRADIENTMAXUVS, Shader3D.PERIOD_SPRITE], 
				'u_CameraPosition': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 
				'u_CameraDirection': [BaseCamera.CAMERADIRECTION, Shader3D.PERIOD_CAMERA], 
				'u_CameraUp': [BaseCamera.CAMERAUP, Shader3D.PERIOD_CAMERA], 
				'u_View': [BaseCamera.VIEWMATRIX, Shader3D.PERIOD_CAMERA], 
				'u_Projection': [BaseCamera.PROJECTMATRIX, Shader3D.PERIOD_CAMERA],
				'u_FogStart': [Scene.FOGSTART, Shader3D.PERIOD_SCENE], 
				'u_FogRange': [Scene.FOGRANGE, Shader3D.PERIOD_SCENE], 
				'u_FogColor': [Scene.FOGCOLOR, Shader3D.PERIOD_SCENE]};
			var PARTICLESHURIKEN:int = Shader3D.nameKey.add("PARTICLESHURIKEN");
			vs = __INCLUDESTR__("files/ParticleShuriKen.vs");
			ps = __INCLUDESTR__("files/ParticleShuriKen.ps");
			shaderCompile = ShaderCompile3D.add(PARTICLESHURIKEN, vs, ps, attributeMap, uniformMap);
			
			ShurikenParticleMaterial.SHADERDEFINE_DIFFUSEMAP = shaderCompile.registerMaterialDefine("DIFFUSEMAP");
			ShurikenParticleMaterial.SHADERDEFINE_TINTCOLOR = shaderCompile.registerMaterialDefine("TINTCOLOR");
			ShurikenParticleMaterial.SHADERDEFINE_ADDTIVEFOG = shaderCompile.registerMaterialDefine("ADDTIVEFOG");
			ShurikenParticleMaterial.SHADERDEFINE_TILINGOFFSET = shaderCompile.registerMaterialDefine("TILINGOFFSET");
			ShuriKenParticle3D.SHADERDEFINE_RENDERMODE_BILLBOARD = shaderCompile.registerSpriteDefine("SPHERHBILLBOARD");
			ShuriKenParticle3D.SHADERDEFINE_RENDERMODE_STRETCHEDBILLBOARD = shaderCompile.registerSpriteDefine("STRETCHEDBILLBOARD");
			ShuriKenParticle3D.SHADERDEFINE_RENDERMODE_HORIZONTALBILLBOARD = shaderCompile.registerSpriteDefine("HORIZONTALBILLBOARD");
			ShuriKenParticle3D.SHADERDEFINE_RENDERMODE_VERTICALBILLBOARD = shaderCompile.registerSpriteDefine("VERTICALBILLBOARD");
			ShuriKenParticle3D.SHADERDEFINE_COLOROVERLIFETIME = shaderCompile.registerSpriteDefine("COLOROVERLIFETIME");
			ShuriKenParticle3D.SHADERDEFINE_RANDOMCOLOROVERLIFETIME = shaderCompile.registerSpriteDefine("RANDOMCOLOROVERLIFETIME");
			ShuriKenParticle3D.SHADERDEFINE_VELOCITYOVERLIFETIMECONSTANT = shaderCompile.registerSpriteDefine("VELOCITYOVERLIFETIMECONSTANT");
			ShuriKenParticle3D.SHADERDEFINE_VELOCITYOVERLIFETIMECURVE = shaderCompile.registerSpriteDefine("VELOCITYOVERLIFETIMECURVE");
			ShuriKenParticle3D.SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCONSTANT = shaderCompile.registerSpriteDefine("VELOCITYOVERLIFETIMERANDOMCONSTANT");
			ShuriKenParticle3D.SHADERDEFINE_VELOCITYOVERLIFETIMERANDOMCURVE = shaderCompile.registerSpriteDefine("VELOCITYOVERLIFETIMERANDOMCURVE");
			ShuriKenParticle3D.SHADERDEFINE_TEXTURESHEETANIMATIONCURVE = shaderCompile.registerSpriteDefine("TEXTURESHEETANIMATIONCURVE");
			ShuriKenParticle3D.SHADERDEFINE_TEXTURESHEETANIMATIONRANDOMCURVE = shaderCompile.registerSpriteDefine("TEXTURESHEETANIMATIONRANDOMCURVE");
			ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIME = shaderCompile.registerSpriteDefine("ROTATIONOVERLIFETIME");
			ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMESEPERATE = shaderCompile.registerSpriteDefine("ROTATIONOVERLIFETIMESEPERATE");
			ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMECONSTANT = shaderCompile.registerSpriteDefine("ROTATIONOVERLIFETIMECONSTANT");
			ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMECURVE = shaderCompile.registerSpriteDefine("ROTATIONOVERLIFETIMECURVE");
			ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCONSTANTS = shaderCompile.registerSpriteDefine("ROTATIONOVERLIFETIMERANDOMCONSTANTS");
			ShuriKenParticle3D.SHADERDEFINE_ROTATIONOVERLIFETIMERANDOMCURVES = shaderCompile.registerSpriteDefine("ROTATIONOVERLIFETIMERANDOMCURVES");
			ShuriKenParticle3D.SHADERDEFINE_SIZEOVERLIFETIMECURVE = shaderCompile.registerSpriteDefine("SIZEOVERLIFETIMECURVE");
			ShuriKenParticle3D.SHADERDEFINE_SIZEOVERLIFETIMECURVESEPERATE = shaderCompile.registerSpriteDefine("SIZEOVERLIFETIMECURVESEPERATE");
			ShuriKenParticle3D.SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVES = shaderCompile.registerSpriteDefine("SIZEOVERLIFETIMERANDOMCURVES");
			ShuriKenParticle3D.SHADERDEFINE_SIZEOVERLIFETIMERANDOMCURVESSEPERATE = shaderCompile.registerSpriteDefine("SIZEOVERLIFETIMERANDOMCURVESSEPERATE");
			ShuriKenParticle3D.SHADERDEFINE_RENDERMODE_MESH = shaderCompile.registerSpriteDefine("RENDERMODE_MESH");
			ShuriKenParticle3D.SHADERDEFINE_SHAPE = shaderCompile.registerSpriteDefine("SHAPE");
			
			
			attributeMap = {
				'a_Position': VertexElementUsage.POSITION0, 
				'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0, 
				'a_Time': VertexElementUsage.TIME0};
			uniformMap = {
				'u_Texture': [GlitterMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_Albedo': [GlitterMaterial.ALBEDO, Shader3D.PERIOD_MATERIAL], 
				'u_Color': [GlitterMaterial.UNICOLOR, Shader3D.PERIOD_MATERIAL], 
				'u_CurrentTime': [Glitter.CURRENTTIME, Shader3D.PERIOD_SPRITE], 
				'u_Duration': [Glitter.DURATION, Shader3D.PERIOD_SPRITE], 
				'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE]};
			var GLITTER:int = Shader3D.nameKey.add("GLITTER");
			vs = __INCLUDESTR__("files/Glitter.vs");
			ps = __INCLUDESTR__("files/Glitter.ps");
			shaderCompile = ShaderCompile3D.add(GLITTER, vs, ps, attributeMap, uniformMap);
			
			attributeMap = {
				'a_Position': VertexElementUsage.POSITION0};
			uniformMap = {
				'u_Intensity': [Sky.INTENSITY, Shader3D.PERIOD_MATERIAL], 
				'u_AlphaBlending': [Sky.ALPHABLENDING, Shader3D.PERIOD_MATERIAL], 
				'u_CubeTexture': [Sky.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_MvpMatrix': [BaseCamera.VPMATRIX_NO_TRANSLATE, Shader3D.PERIOD_CAMERA]};//TODO:优化
			var skyBox:int = Shader3D.nameKey.add("SkyBox");
			vs = __INCLUDESTR__("files/SkyBox.vs");
			ps = __INCLUDESTR__("files/SkyBox.ps");
			ShaderCompile3D.add(skyBox, vs, ps, attributeMap, uniformMap);
			
			attributeMap = {
				'a_Position': VertexElementUsage.POSITION0, 
				'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0};
			uniformMap = {
				'u_Intensity': [Sky.INTENSITY, Shader3D.PERIOD_MATERIAL], 
				'u_AlphaBlending': [Sky.ALPHABLENDING, Shader3D.PERIOD_MATERIAL], 
				'u_texture': [Sky.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_MvpMatrix': [BaseCamera.VPMATRIX_NO_TRANSLATE, Shader3D.PERIOD_CAMERA]};//TODO:优化
			var skyDome:int = Shader3D.nameKey.add("SkyDome");
			vs = __INCLUDESTR__("files/SkyDome.vs");
			ps = __INCLUDESTR__("files/SkyDome.ps");
			ShaderCompile3D.add(skyDome, vs, ps, attributeMap, uniformMap);
			
			//terrain的shader
			attributeMap = {
				'a_Position': VertexElementUsage.POSITION0, 
				'a_Normal': VertexElementUsage.NORMAL0, 
				'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0, 
				'a_Texcoord1': VertexElementUsage.TEXTURECOORDINATE1};
			uniformMap = {
				'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_WorldMat': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_LightmapScaleOffset': [RenderableSprite3D.LIGHTMAPSCALEOFFSET, Shader3D.PERIOD_SPRITE], 
				'u_LightMap': [RenderableSprite3D.LIGHTMAP, Shader3D.PERIOD_SPRITE], 
				'u_SplatAlphaTexture': [TerrainMaterial.SPLATALPHATEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_NormalTexture': [TerrainMaterial.NORMALTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseTexture1': [TerrainMaterial.DIFFUSETEXTURE1, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseTexture2': [TerrainMaterial.DIFFUSETEXTURE2, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseTexture3': [TerrainMaterial.DIFFUSETEXTURE3, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseTexture4': [TerrainMaterial.DIFFUSETEXTURE4, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseScale1': [TerrainMaterial.DIFFUSESCALE1, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseScale2': [TerrainMaterial.DIFFUSESCALE2, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseScale3': [TerrainMaterial.DIFFUSESCALE3, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseScale4': [TerrainMaterial.DIFFUSESCALE4, Shader3D.PERIOD_MATERIAL], 
				'u_MaterialDiffuse': [TerrainMaterial.MATERIALDIFFUSE, Shader3D.PERIOD_MATERIAL], 
				'u_MaterialAmbient': [TerrainMaterial.MATERIALAMBIENT, Shader3D.PERIOD_MATERIAL], 
				'u_MaterialSpecular': [TerrainMaterial.MATERIALSPECULAR, Shader3D.PERIOD_MATERIAL], 
				'u_CameraPos': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 
				'u_FogStart': [Scene.FOGSTART, Shader3D.PERIOD_SCENE], 
				'u_FogRange': [Scene.FOGRANGE, Shader3D.PERIOD_SCENE], 
				'u_FogColor': [Scene.FOGCOLOR, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Direction': [Scene.LIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Diffuse': [Scene.LIGHTDIRCOLOR, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Position': [Scene.POINTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Range': [Scene.POINTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Attenuation': [Scene.POINTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Diffuse': [Scene.POINTLIGHTCOLOR, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Position': [Scene.SPOTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Direction': [Scene.SPOTLIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Range': [Scene.SPOTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Spot': [Scene.SPOTLIGHTSPOT, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Attenuation': [Scene.SPOTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Diffuse': [Scene.SPOTLIGHTCOLOR, Shader3D.PERIOD_SCENE], 
				'u_AmbientColor': [Scene.AMBIENTCOLOR, Shader3D.PERIOD_SCENE],
				'u_shadowMap1': [Scene.SHADOWMAPTEXTURE1, Shader3D.PERIOD_SCENE], 
				'u_shadowMap2': [Scene.SHADOWMAPTEXTURE2, Shader3D.PERIOD_SCENE], 
				'u_shadowMap3': [Scene.SHADOWMAPTEXTURE3, Shader3D.PERIOD_SCENE], 
				'u_shadowPSSMDistance': [Scene.SHADOWDISTANCE, Shader3D.PERIOD_SCENE], 
				'u_lightShadowVP': [Scene.SHADOWLIGHTVIEWPROJECT, Shader3D.PERIOD_SCENE], 
				'u_shadowPCFoffset': [Scene.SHADOWMAPPCFOFFSET, Shader3D.PERIOD_SCENE]};
			
			var terrain:int = Shader3D.nameKey.add("Terrain");
			vs = __INCLUDESTR__("files/Terrain.vs");
			ps = __INCLUDESTR__("files/Terrain.ps");
			var terrainCompile3D:ShaderCompile3D = ShaderCompile3D.add(terrain, vs, ps, attributeMap, uniformMap);
			TerrainMaterial.SHADERDEFINE_DETAIL_NUM1 = terrainCompile3D.registerMaterialDefine("DETAIL_NUM1");
			TerrainMaterial.SHADERDEFINE_DETAIL_NUM2 = terrainCompile3D.registerMaterialDefine("DETAIL_NUM2");
			TerrainMaterial.SHADERDEFINE_DETAIL_NUM4 = terrainCompile3D.registerMaterialDefine("DETAIL_NUM4");
			TerrainMaterial.SHADERDEFINE_DETAIL_NUM3 = terrainCompile3D.registerMaterialDefine("DETAIL_NUM3");
			
			//extendTerrain的shader
			 attributeMap = {
				'a_Position': VertexElementUsage.POSITION0, 
				'a_Normal': VertexElementUsage.NORMAL0, 
				'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0
			};
             uniformMap = {
				'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_WorldMat': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_CameraPos': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 
				'u_LightmapScaleOffset': [RenderableSprite3D.LIGHTMAPSCALEOFFSET, Shader3D.PERIOD_SPRITE], 
				'u_LightMap': [RenderableSprite3D.LIGHTMAP, Shader3D.PERIOD_SPRITE], 
				'u_SplatAlphaTexture': [ExtendTerrainMaterial.SPLATALPHATEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseTexture1': [ExtendTerrainMaterial.DIFFUSETEXTURE1, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseTexture2': [ExtendTerrainMaterial.DIFFUSETEXTURE2, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseTexture3': [ExtendTerrainMaterial.DIFFUSETEXTURE3, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseTexture4': [ExtendTerrainMaterial.DIFFUSETEXTURE4, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseTexture5': [ExtendTerrainMaterial.DIFFUSETEXTURE5, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseScaleOffset1': [ExtendTerrainMaterial.DIFFUSESCALEOFFSET1, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseScaleOffset2': [ExtendTerrainMaterial.DIFFUSESCALEOFFSET2, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseScaleOffset3': [ExtendTerrainMaterial.DIFFUSESCALEOFFSET3, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseScaleOffset4': [ExtendTerrainMaterial.DIFFUSESCALEOFFSET4, Shader3D.PERIOD_MATERIAL], 
				'u_DiffuseScaleOffset5': [ExtendTerrainMaterial.DIFFUSESCALEOFFSET5, Shader3D.PERIOD_MATERIAL], 
				'u_MaterialAlbedo': [ExtendTerrainMaterial.MATERIALALBEDO, Shader3D.PERIOD_MATERIAL], 
				'u_MaterialDiffuse': [ExtendTerrainMaterial.MATERIALDIFFUSE, Shader3D.PERIOD_MATERIAL], 
				'u_MaterialAmbient': [ExtendTerrainMaterial.MATERIALAMBIENT, Shader3D.PERIOD_MATERIAL], 
				'u_MaterialSpecular': [ExtendTerrainMaterial.MATERIALSPECULAR, Shader3D.PERIOD_MATERIAL], 
				'u_FogStart': [Scene.FOGSTART, Shader3D.PERIOD_SCENE], 
				'u_FogRange': [Scene.FOGRANGE, Shader3D.PERIOD_SCENE], 
				'u_FogColor': [Scene.FOGCOLOR, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Direction': [Scene.LIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Diffuse': [Scene.LIGHTDIRCOLOR, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Position': [Scene.POINTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Range': [Scene.POINTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Attenuation': [Scene.POINTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Diffuse': [Scene.POINTLIGHTCOLOR, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Position': [Scene.SPOTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Direction': [Scene.SPOTLIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Range': [Scene.SPOTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Spot': [Scene.SPOTLIGHTSPOT, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Attenuation': [Scene.SPOTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Diffuse': [Scene.SPOTLIGHTCOLOR, Shader3D.PERIOD_SCENE], 
				'u_AmbientColor': [Scene.AMBIENTCOLOR, Shader3D.PERIOD_SCENE],
				'u_shadowMap1': [Scene.SHADOWMAPTEXTURE1, Shader3D.PERIOD_SCENE], 
				'u_shadowMap2': [Scene.SHADOWMAPTEXTURE2, Shader3D.PERIOD_SCENE], 
				'u_shadowMap3': [Scene.SHADOWMAPTEXTURE3, Shader3D.PERIOD_SCENE], 
				'u_shadowPSSMDistance': [Scene.SHADOWDISTANCE, Shader3D.PERIOD_SCENE], 
				'u_lightShadowVP': [Scene.SHADOWLIGHTVIEWPROJECT, Shader3D.PERIOD_SCENE], 
				'u_shadowPCFoffset': [Scene.SHADOWMAPPCFOFFSET, Shader3D.PERIOD_SCENE]
			};
            var extendTerrainShader:int = Shader3D.nameKey.add("ExtendTerrain");
            vs = __INCLUDESTR__("files/extendTerrain.vs");
            ps = __INCLUDESTR__("files/extendTerrain.ps");
			
            var extendTerrainCompile3D:ShaderCompile3D = ShaderCompile3D.add(extendTerrainShader, vs, ps, attributeMap, uniformMap);
			extendTerrainCompile3D.addSpriteDefines(RenderableSprite3D.shaderDefines);
			extendTerrainCompile3D.addSpriteDefines(ExtendTerrainMaterial.shaderDefines);
			
			//Trail
			attributeMap = {
				'a_Position'    : VertexElementUsage.POSITION0,
				'a_OffsetVector': VertexElementUsage.OFFSETVECTOR,
				//'a_Color'       : VertexElementUsage.COLOR0,
				'a_Texcoord0X'  : VertexElementUsage.TEXTURECOORDINATE0X,
				'a_Texcoord0Y'  : VertexElementUsage.TEXTURECOORDINATE0Y,
				'a_BirthTime'   : VertexElementUsage.TIME0
			};
			uniformMap = {
				'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_VMatrix': [BaseCamera.VIEWMATRIX, Shader3D.PERIOD_CAMERA],
				'u_PMatrix': [BaseCamera.PROJECTMATRIX, Shader3D.PERIOD_CAMERA],
				'u_TilingOffset': [TrailMaterial.TILINGOFFSET, Shader3D.PERIOD_MATERIAL],
				'u_MainTexture': [TrailMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_MainColor': [TrailMaterial.TINTCOLOR, Shader3D.PERIOD_MATERIAL],
				'u_CurTime' : [TrailSprite3D.CURTIME, Shader3D.PERIOD_SPRITE],
				'u_LifeTime' : [TrailSprite3D.LIFETIME, Shader3D.PERIOD_SPRITE],
				'u_WidthCurve' : [TrailSprite3D.WIDTHCURVE, Shader3D.PERIOD_SPRITE],
				'u_WidthCurveKeyLength' : [TrailSprite3D.WIDTHCURVEKEYLENGTH, Shader3D.PERIOD_SPRITE],
				'u_GradientColorkey' : [TrailSprite3D.GRADIENTCOLORKEY, Shader3D.PERIOD_SPRITE],
				'u_GradientAlphakey' : [TrailSprite3D.GRADIENTALPHAKEY, Shader3D.PERIOD_SPRITE]
			};
			
			var trailShader:int = Shader3D.nameKey.add("Trail");
            vs = __INCLUDESTR__("files/Trail.vs");
            ps = __INCLUDESTR__("files/Trail.ps");
            var trailCompile3D:ShaderCompile3D = ShaderCompile3D.add(trailShader, vs, ps, attributeMap, uniformMap);
			TrailMaterial.SHADERDEFINE_DIFFUSETEXTURE = trailCompile3D.registerMaterialDefine("DIFFUSETEXTURE");
			TrailMaterial.SHADERDEFINE_TILINGOFFSET = trailCompile3D.registerSpriteDefine("TILINGOFFSET");
			TrailSprite3D.SHADERDEFINE_GRADIENTMODE_BLEND = trailCompile3D.registerSpriteDefine("GRADIENTMODE_BLEND");
			//trailCompile3D.addSpriteDefines(RenderableSprite3D.shaderDefines);
			//trailCompile3D.addSpriteDefines(TrailMaterial.shaderDefines);
		}
	
	}

}