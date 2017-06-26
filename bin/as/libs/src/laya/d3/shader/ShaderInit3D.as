package laya.d3.shader {
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.GlitterMaterial;
	import laya.d3.core.material.PBRMaterial;
	import laya.d3.core.material.ParticleMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.material.TerrainMaterial;
	import laya.d3.core.material.WaterMaterial;
	import laya.d3.core.particleShuriKen.ShuriKenParticle3D;
	import laya.d3.core.particleShuriKen.ShurikenParticleMaterial;
	import laya.d3.core.scene.Scene;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.resource.models.Sky;
	import laya.particle.shader.ParticleShader;
	
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
			Shader3D.addInclude("LightHelper.glsl", __INCLUDESTR__("files/LightHelper.glsl"));
			Shader3D.addInclude("VRHelper.glsl", __INCLUDESTR__("files/VRHelper.glsl"));
			Shader3D.addInclude("ShadowHelper.glsl", __INCLUDESTR__("files/ShadowHelper.glsl"));
			Shader3D.addInclude("WaveFunction.glsl", __INCLUDESTR__("files/WaveFunction.glsl"));
			
			var vs:String, ps:String;
			var attributeMap:Object = {
				'a_Position': VertexElementUsage.POSITION0, 
				'a_Color': VertexElementUsage.COLOR0, 
				'a_Normal': VertexElementUsage.NORMAL0, 
				'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0, 
				'a_Texcoord1': VertexElementUsage.TEXTURECOORDINATE1, 
				'a_TexcoordNext0': VertexElementUsage.NEXTTEXTURECOORDINATE0, 
				'a_BoneWeights': VertexElementUsage.BLENDWEIGHT0, 
				'a_BoneIndices': VertexElementUsage.BLENDINDICES0, 
				'a_Tangent0': VertexElementUsage.TANGENT0};
			var uniformMap:Object = {
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
				'u_DirectionLight.Diffuse': [Scene.LIGHTDIRDIFFUSE, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Ambient': [Scene.LIGHTDIRAMBIENT, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Specular': [Scene.LIGHTDIRSPECULAR, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Position': [Scene.POINTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Range': [Scene.POINTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Attenuation': [Scene.POINTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Diffuse': [Scene.POINTLIGHTDIFFUSE, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Ambient': [Scene.POINTLIGHTAMBIENT, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Specular': [Scene.POINTLIGHTSPECULAR, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Position': [Scene.SPOTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Direction': [Scene.SPOTLIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Range': [Scene.SPOTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Spot': [Scene.SPOTLIGHTSPOT, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Attenuation': [Scene.SPOTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Diffuse': [Scene.SPOTLIGHTDIFFUSE, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Ambient': [Scene.SPOTLIGHTAMBIENT, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Specular': [Scene.SPOTLIGHTSPECULAR, Shader3D.PERIOD_SCENE], 
				'u_shadowMap1': [Scene.SHADOWMAPTEXTURE1, Shader3D.PERIOD_SCENE], 
				'u_shadowMap2': [Scene.SHADOWMAPTEXTURE2, Shader3D.PERIOD_SCENE], 
				'u_shadowMap3': [Scene.SHADOWMAPTEXTURE3, Shader3D.PERIOD_SCENE], 
				'u_shadowPSSMDistance': [Scene.SHADOWDISTANCE, Shader3D.PERIOD_SCENE], 
				'u_lightShadowVP': [Scene.SHADOWLIGHTVIEWPROJECT, Shader3D.PERIOD_SCENE], 
				'u_shadowPCFoffset': [Scene.SHADOWMAPPCFOFFSET, Shader3D.PERIOD_SCENE]};
			
			var SIMPLE:int = Shader3D.nameKey.add("SIMPLE");
			vs = __INCLUDESTR__("files/PixelSimpleTextureSkinnedMesh.vs");
			ps = __INCLUDESTR__("files/PixelSimpleTextureSkinnedMesh.ps");
			var shaderCompile:ShaderCompile3D = ShaderCompile3D.add(SIMPLE, vs, ps, attributeMap, uniformMap);
			StandardMaterial.SHADERDEFINE_DIFFUSEMAP = shaderCompile.registerMaterialDefine("DIFFUSEMAP");
			StandardMaterial.SHADERDEFINE_NORMALMAP = shaderCompile.registerMaterialDefine("NORMALMAP");
			StandardMaterial.SHADERDEFINE_SPECULARMAP = shaderCompile.registerMaterialDefine("SPECULARMAP");
			StandardMaterial.SHADERDEFINE_EMISSIVEMAP = shaderCompile.registerMaterialDefine("EMISSIVEMAP");
			StandardMaterial.SHADERDEFINE_AMBIENTMAP = shaderCompile.registerMaterialDefine("AMBIENTMAP");
			StandardMaterial.SHADERDEFINE_REFLECTMAP = shaderCompile.registerMaterialDefine("REFLECTMAP");
			StandardMaterial.SHADERDEFINE_UVTRANSFORM = shaderCompile.registerMaterialDefine("UVTRANSFORM");
			StandardMaterial.SHADERDEFINE_TILINGOFFSET = shaderCompile.registerMaterialDefine("TILINGOFFSET");
			
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
				'u_DirectionLight.Diffuse': [Scene.LIGHTDIRDIFFUSE, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Ambient': [Scene.LIGHTDIRAMBIENT, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Specular': [Scene.LIGHTDIRSPECULAR, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Position': [Scene.POINTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Range': [Scene.POINTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Attenuation': [Scene.POINTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Diffuse': [Scene.POINTLIGHTDIFFUSE, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Ambient': [Scene.POINTLIGHTAMBIENT, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Specular': [Scene.POINTLIGHTSPECULAR, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Position': [Scene.SPOTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Direction': [Scene.SPOTLIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Range': [Scene.SPOTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Spot': [Scene.SPOTLIGHTSPOT, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Attenuation': [Scene.SPOTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Diffuse': [Scene.SPOTLIGHTDIFFUSE, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Ambient': [Scene.SPOTLIGHTAMBIENT, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Specular': [Scene.SPOTLIGHTSPECULAR, Shader3D.PERIOD_SCENE], 
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
				'u_DirectionLight.Diffuse': [Scene.LIGHTDIRDIFFUSE, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Ambient': [Scene.LIGHTDIRAMBIENT, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Specular': [Scene.LIGHTDIRSPECULAR, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Position': [Scene.POINTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Range': [Scene.POINTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Attenuation': [Scene.POINTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Diffuse': [Scene.POINTLIGHTDIFFUSE, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Ambient': [Scene.POINTLIGHTAMBIENT, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Specular': [Scene.POINTLIGHTSPECULAR, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Position': [Scene.SPOTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Direction': [Scene.SPOTLIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Range': [Scene.SPOTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Spot': [Scene.SPOTLIGHTSPOT, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Attenuation': [Scene.SPOTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Diffuse': [Scene.SPOTLIGHTDIFFUSE, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Ambient': [Scene.SPOTLIGHTAMBIENT, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Specular': [Scene.SPOTLIGHTSPECULAR, Shader3D.PERIOD_SCENE]};
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
				'a_Position': VertexElementUsage.POSITION0, 
				'a_Texcoord': VertexElementUsage.TEXTURECOORDINATE0};
			uniformMap = {
				'u_BlendTexture': [StandardMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_LayerTexture0': [StandardMaterial.NORMALTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_LayerTexture1': [StandardMaterial.SPECULARTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_LayerTexture2': [StandardMaterial.EMISSIVETEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_LayerTexture3': [StandardMaterial.AMBIENTTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_Albedo': [StandardMaterial.ALBEDO, Shader3D.PERIOD_MATERIAL], 
				'u_Ambient': [StandardMaterial.MATERIALAMBIENT, Shader3D.PERIOD_MATERIAL], 
				'u_UVMatrix': [StandardMaterial.UVMATRIX, Shader3D.PERIOD_MATERIAL], 
				'u_WorldMat': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_CameraPos': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 
				'u_FogStart': [Scene.FOGSTART, Shader3D.PERIOD_SCENE], 
				'u_FogRange': [Scene.FOGRANGE, Shader3D.PERIOD_SCENE], 
				'u_FogColor': [Scene.FOGCOLOR, Shader3D.PERIOD_SCENE]};
			var TERRAIN:int = Shader3D.nameKey.add("TERRAIN");
			vs = __INCLUDESTR__("files/modelTerrain.vs");
			ps = __INCLUDESTR__("files/modelTerrain.ps");
			shaderCompile = ShaderCompile3D.add(TERRAIN, vs, ps, attributeMap, uniformMap);
			StandardMaterial.SHADERDEFINE_DIFFUSEMAP = shaderCompile.registerMaterialDefine("DIFFUSEMAP");
			StandardMaterial.SHADERDEFINE_NORMALMAP = shaderCompile.registerMaterialDefine("NORMALMAP");
			StandardMaterial.SHADERDEFINE_SPECULARMAP = shaderCompile.registerMaterialDefine("SPECULARMAP");
			StandardMaterial.SHADERDEFINE_EMISSIVEMAP = shaderCompile.registerMaterialDefine("EMISSIVEMAP");
			StandardMaterial.SHADERDEFINE_AMBIENTMAP = shaderCompile.registerMaterialDefine("AMBIENTMAP");
			StandardMaterial.SHADERDEFINE_REFLECTMAP = shaderCompile.registerMaterialDefine("REFLECTMAP");
			StandardMaterial.SHADERDEFINE_UVTRANSFORM = shaderCompile.registerMaterialDefine("UVTRANSFORM");
			//shaderCompile.reg("MIXUV", StandardMaterial.MIXUV);
			
			attributeMap = {
				'a_CornerTextureCoordinate': VertexElementUsage.CORNERTEXTURECOORDINATE0, 
				'a_Position': VertexElementUsage.POSITION0, 
				'a_Velocity': VertexElementUsage.VELOCITY0, 
				'a_StartColor': VertexElementUsage.STARTCOLOR0, 
				'a_EndColor': VertexElementUsage.ENDCOLOR0, 
				'a_SizeRotation': VertexElementUsage.SIZEROTATION0, 
				'a_Radius': VertexElementUsage.RADIUS0, 
				'a_Radian': VertexElementUsage.RADIAN0, 
				'a_AgeAddScale': VertexElementUsage.STARTLIFETIME, 
				'a_Time': VertexElementUsage.TIME0};
			uniformMap = {
				'u_CurrentTime': [ParticleMaterial.CURRENTTIME, Shader3D.PERIOD_MATERIAL], 
				'u_Duration': [ParticleMaterial.DURATION, Shader3D.PERIOD_MATERIAL], 
				'u_Gravity': [ParticleMaterial.GRAVITY, Shader3D.PERIOD_MATERIAL], 
				'u_EndVelocity': [ParticleMaterial.ENDVELOCITY, Shader3D.PERIOD_MATERIAL], 
				'u_texture': [ParticleMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_WorldMat': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE], 
				'u_View': [BaseCamera.VIEWMATRIX, Shader3D.PERIOD_CAMERA], 
				'u_Projection': [BaseCamera.PROJECTMATRIX, Shader3D.PERIOD_CAMERA], 
				'u_ViewportScale': [ParticleMaterial.VIEWPORTSCALE, Shader3D.PERIOD_MATERIAL]};//TODO:
			var PARTICLE:int = Shader3D.nameKey.add("PARTICLE");
			shaderCompile = ShaderCompile3D.add(PARTICLE, ParticleShader.vs, ParticleShader.ps, attributeMap, uniformMap);
			ParticleMaterial.SHADERDEFINE_PARTICLE3D = shaderCompile.registerMaterialDefine("PARTICLE3D");
			
			attributeMap = {
				'a_CornerTextureCoordinate': VertexElementUsage.CORNERTEXTURECOORDINATE0, 
				'a_MeshPosition': VertexElementUsage.POSITION0,
				'a_MeshTextureCoordinate': VertexElementUsage.TEXTURECOORDINATE0,
				'a_PositionStartLifeTime': VertexElementUsage.POSITIONSTARTLIFETIME, 
				'a_DirectionTime': VertexElementUsage.DIRECTIONTIME, 
				'a_StartColor': VertexElementUsage.STARTCOLOR0, 
				'a_EndColor': VertexElementUsage.ENDCOLOR0, 
				'a_StartSize': VertexElementUsage.STARTSIZE, 
				'a_StartRotation0': VertexElementUsage.STARTROTATION, 
				'a_StartSpeed': VertexElementUsage.STARTSPEED, 
				'a_Random0': VertexElementUsage.RANDOM0, 
				'a_Random1': VertexElementUsage.RANDOM1, 
				'a_SimulationWorldPostion': VertexElementUsage.SIMULATIONWORLDPOSTION};
			uniformMap = {
				'u_Tintcolor': [ShurikenParticleMaterial.TINTCOLOR, Shader3D.PERIOD_MATERIAL], 
				'u_texture': [ShurikenParticleMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 
				'u_WorldPosition': [ShuriKenParticle3D.WORLDPOSITION, Shader3D.PERIOD_SPRITE], 
				'u_WorldRotationMat': [ShuriKenParticle3D.WORLDROTATIONMATRIX, Shader3D.PERIOD_SPRITE], 
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
				'u_CameraDirection': [BaseCamera.CAMERADIRECTION, Shader3D.PERIOD_CAMERA], 
				'u_CameraUp': [BaseCamera.CAMERAUP, Shader3D.PERIOD_CAMERA], 
				'u_View': [BaseCamera.VIEWMATRIX, Shader3D.PERIOD_CAMERA], 
				'u_Projection': [BaseCamera.PROJECTMATRIX, Shader3D.PERIOD_CAMERA]};
			var PARTICLESHURIKEN:int = Shader3D.nameKey.add("PARTICLESHURIKEN");
			vs = __INCLUDESTR__("files/ParticleShuriKen.vs");
			ps = __INCLUDESTR__("files/ParticleShuriKen.ps");
			shaderCompile = ShaderCompile3D.add(PARTICLESHURIKEN, vs, ps, attributeMap, uniformMap);
			ShurikenParticleMaterial.SHADERDEFINE_DIFFUSEMAP = shaderCompile.registerMaterialDefine("DIFFUSEMAP");
			ShurikenParticleMaterial.SHADERDEFINE_TINTCOLOR = shaderCompile.registerMaterialDefine("TINTCOLOR");
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
				'u_CurrentTime': [GlitterMaterial.CURRENTTIME, Shader3D.PERIOD_MATERIAL], 
				'u_Color': [GlitterMaterial.UNICOLOR, Shader3D.PERIOD_MATERIAL], 
				'u_Duration': [GlitterMaterial.DURATION, Shader3D.PERIOD_MATERIAL], 
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
				'u_DirectionLight.Diffuse': [Scene.LIGHTDIRDIFFUSE, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Ambient': [Scene.LIGHTDIRAMBIENT, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Specular': [Scene.LIGHTDIRSPECULAR, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Position': [Scene.POINTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Range': [Scene.POINTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Attenuation': [Scene.POINTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Diffuse': [Scene.POINTLIGHTDIFFUSE, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Ambient': [Scene.POINTLIGHTAMBIENT, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Specular': [Scene.POINTLIGHTSPECULAR, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Position': [Scene.SPOTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Direction': [Scene.SPOTLIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Range': [Scene.SPOTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Spot': [Scene.SPOTLIGHTSPOT, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Attenuation': [Scene.SPOTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Diffuse': [Scene.SPOTLIGHTDIFFUSE, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Ambient': [Scene.SPOTLIGHTAMBIENT, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Specular': [Scene.SPOTLIGHTSPECULAR, Shader3D.PERIOD_SCENE], 
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
		
		}
	
	}

}