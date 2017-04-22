package {
	import laya.ani.AnimationTemplet;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Layer;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.material.TerrainMaterial;
	import laya.d3.core.PhasorSpriter3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.PBRMaterial;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.GlitterMaterial;
	import laya.d3.core.material.ParticleMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.material.WaterMaterial;
	import laya.d3.core.particleShuriKen.ShuriKenParticle3D;
	import laya.d3.core.particleShuriKen.ShurikenParticleMaterial;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.scene.OctreeNode;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.resource.DataTexture2D;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.Sky;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	import laya.d3.terrain.TerrainHeightData;
	import laya.d3.terrain.TerrainRes;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.net.LoaderManager;
	import laya.net.URL;
	import laya.particle.shader.ParticleShader;
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.utils.Byte;
	import laya.utils.Handler;
	import laya.utils.RunDriver;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	
	/**
	 * <code>Laya3D</code> 类用于初始化3D设置。
	 */
	public class Laya3D {
		/**@private 层级文件资源标记。*/
		private static const SPRITE3DHIERARCHY:String = "SPRITE3DHIERARCHY";
		/**@private 网格的原始资源标记。*/
		private static const MESH:String = "MESH";
		/**@private 材质的原始资源标记。*/
		private static const MATERIAL:String = "MATERIAL";
		/**@private PBR材质资源标记。*/
		private static const PBRMATERIAL:String = "PBRMTL";
		/**@private TextureCube原始资源标记。*/
		private static const TEXTURECUBE:String = "TEXTURECUBE";
		
		/**@private */
		private static var _DATA:Object = {offset: 0, size: 0};
		/**@private */
		private static var _strings:Array = ['BLOCK', 'DATA', "STRINGS"];//字符串数组
		/**@private */
		private static var _readData:Byte;
		
		/**@private */
		private static const _innerTextureCubeLoaderManager:LoaderManager = new LoaderManager();
		/**@private */         
		private static const _innerMaterialLoaderManager:LoaderManager = new LoaderManager();
		/**@private */
		private static const _innerMeshLoaderManager:LoaderManager = new LoaderManager();
		/**@private */
		private static const _innerSprite3DHierarchyLoaderManager:LoaderManager = new LoaderManager();
		/**@private */
		public static var _debugPhasorSprite:PhasorSpriter3D;
		
		/**@private */
		public static var debugMode:Boolean = false;
		
		/**
		 * 创建一个 <code>Laya3D</code> 实例。
		 */
		public function Laya3D() {
		}
		
		/**
		 *@private
		 */
		private static function _changeWebGLSize(width:Number, height:Number):void {
			WebGL.onStageResize(width, height);
			RenderState.clientWidth = width;
			RenderState.clientHeight = height;
		}
		
		/**
		 *@private
		 */
		private static function _initShader():void {
			Shader3D.addInclude("LightHelper.glsl", __INCLUDESTR__("laya/d3/shader/files/LightHelper.glsl"));
			Shader3D.addInclude("VRHelper.glsl", __INCLUDESTR__("laya/d3/shader/files/VRHelper.glsl"));
			Shader3D.addInclude("ShadowHelper.glsl", __INCLUDESTR__("laya/d3/shader/files/ShadowHelper.glsl"));
			Shader3D.addInclude("WaveFunction.glsl", __INCLUDESTR__("laya/d3/shader/files/WaveFunction.glsl"));
			
			var vs:String, ps:String;
			var attributeMap:Object = {'a_Position': VertexElementUsage.POSITION0, 'a_Color': VertexElementUsage.COLOR0, 'a_Normal': VertexElementUsage.NORMAL0, 'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0, 'a_Texcoord1': VertexElementUsage.TEXTURECOORDINATE1, 'a_TexcoordNext0': VertexElementUsage.NEXTTEXTURECOORDINATE0, 'a_BoneWeights': VertexElementUsage.BLENDWEIGHT0, 'a_BoneIndices': VertexElementUsage.BLENDINDICES0, 'a_Tangent0': VertexElementUsage.TANGENT0};
			var uniformMap:Object = { 'u_Bones': [SkinAnimations.BONES, Shader3D.PERIOD_RENDERELEMENT], 
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
									'u_WorldMat': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE], 
									'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 
									'u_LightmapScaleOffset': [MeshSprite3D.LIGHTMAPSCALEOFFSET, Shader3D.PERIOD_SPRITE], 
									'u_CameraPos': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 
									'u_FogStart': [BaseScene.FOGSTART, Shader3D.PERIOD_SCENE], 
									'u_FogRange': [BaseScene.FOGRANGE, Shader3D.PERIOD_SCENE], 
									'u_FogColor': [BaseScene.FOGCOLOR, Shader3D.PERIOD_SCENE], 
									'u_DirectionLight.Direction': [BaseScene.LIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
									'u_DirectionLight.Diffuse': [BaseScene.LIGHTDIRDIFFUSE, Shader3D.PERIOD_SCENE], 
									'u_DirectionLight.Ambient': [BaseScene.LIGHTDIRAMBIENT, Shader3D.PERIOD_SCENE], 
									'u_DirectionLight.Specular': [BaseScene.LIGHTDIRSPECULAR, Shader3D.PERIOD_SCENE], 
									'u_PointLight.Position': [BaseScene.POINTLIGHTPOS, Shader3D.PERIOD_SCENE], 
									'u_PointLight.Range': [BaseScene.POINTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
									'u_PointLight.Attenuation': [BaseScene.POINTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
									'u_PointLight.Diffuse': [BaseScene.POINTLIGHTDIFFUSE, Shader3D.PERIOD_SCENE], 
									'u_PointLight.Ambient': [BaseScene.POINTLIGHTAMBIENT, Shader3D.PERIOD_SCENE], 
									'u_PointLight.Specular': [BaseScene.POINTLIGHTSPECULAR, Shader3D.PERIOD_SCENE], 
									'u_SpotLight.Position': [BaseScene.SPOTLIGHTPOS, Shader3D.PERIOD_SCENE], 
									'u_SpotLight.Direction': [BaseScene.SPOTLIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
									'u_SpotLight.Range': [BaseScene.SPOTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
									'u_SpotLight.Spot': [BaseScene.SPOTLIGHTSPOT, Shader3D.PERIOD_SCENE], 
									'u_SpotLight.Attenuation': [BaseScene.SPOTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
									'u_SpotLight.Diffuse': [BaseScene.SPOTLIGHTDIFFUSE, Shader3D.PERIOD_SCENE], 
									'u_SpotLight.Ambient': [BaseScene.SPOTLIGHTAMBIENT, Shader3D.PERIOD_SCENE], 
									'u_SpotLight.Specular': [BaseScene.SPOTLIGHTSPECULAR, Shader3D.PERIOD_SCENE], 
									'u_shadowMap1': [BaseScene.SHADOWMAPTEXTURE1, Shader3D.PERIOD_SCENE], 
									'u_shadowMap2': [BaseScene.SHADOWMAPTEXTURE2, Shader3D.PERIOD_SCENE], 
									'u_shadowMap3': [BaseScene.SHADOWMAPTEXTURE3, Shader3D.PERIOD_SCENE], 
									'u_shadowPSSMDistance': [BaseScene.SHADOWDISTANCE, Shader3D.PERIOD_SCENE], 
									'u_lightShadowVP': [BaseScene.SHADOWLIGHTVIEWPROJECT, Shader3D.PERIOD_SCENE], 
									'u_shadowPCFoffset': [BaseScene.SHADOWMAPPCFOFFSET, Shader3D.PERIOD_SCENE]};
			
			var SIMPLE:int = Shader3D.nameKey.add("SIMPLE");
			vs = __INCLUDESTR__("laya/d3/shader/files/PixelSimpleTextureSkinnedMesh.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/PixelSimpleTextureSkinnedMesh.ps");
			var shaderCompile:ShaderCompile3D = ShaderCompile3D.add(SIMPLE, vs, ps, attributeMap, uniformMap);
			StandardMaterial.SHADERDEFINE_DIFFUSEMAP = shaderCompile.registerMaterialDefine("DIFFUSEMAP");
			StandardMaterial.SHADERDEFINE_NORMALMAP = shaderCompile.registerMaterialDefine("NORMALMAP");
			StandardMaterial.SHADERDEFINE_SPECULARMAP = shaderCompile.registerMaterialDefine("SPECULARMAP");
			StandardMaterial.SHADERDEFINE_EMISSIVEMAP = shaderCompile.registerMaterialDefine("EMISSIVEMAP");
			StandardMaterial.SHADERDEFINE_AMBIENTMAP = shaderCompile.registerMaterialDefine("AMBIENTMAP");
			StandardMaterial.SHADERDEFINE_REFLECTMAP = shaderCompile.registerMaterialDefine("REFLECTMAP");
			StandardMaterial.SHADERDEFINE_UVTRANSFORM = shaderCompile.registerMaterialDefine("UVTRANSFORM");
			
			var SIMPLEVEXTEX:int = Shader3D.nameKey.add("SIMPLEVEXTEX");
			vs = __INCLUDESTR__("laya/d3/shader/files/VertexSimpleTextureSkinnedMesh.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/VertexSimpleTextureSkinnedMesh.ps");
			shaderCompile = ShaderCompile3D.add(SIMPLEVEXTEX, vs, ps, attributeMap, uniformMap);
			
			attributeMap = {'a_Position': VertexElementUsage.POSITION0, 'a_Color': VertexElementUsage.COLOR0};
			uniformMap = {'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE]};
			var LINE:int = Shader3D.nameKey.add("LINE");
			vs = __INCLUDESTR__("laya/d3/shader/files/line.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/line.ps");
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
				'u_Bones': [SkinAnimations.BONES, Shader3D.PERIOD_RENDERELEMENT], 
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
				'texHSNoise':[PBRMaterial.HSNOISETEXTURE, Shader3D.PERIOD_MATERIAL],
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
				'cameraPosition': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 'u_View': [BaseCamera.VIEWMATRIX, Shader3D.PERIOD_CAMERA], 'u_Project': [BaseCamera.PROJECTMATRIX, Shader3D.PERIOD_CAMERA], 'u_FogStart': [BaseScene.FOGSTART, Shader3D.PERIOD_SCENE], 'u_FogRange': [BaseScene.FOGRANGE, Shader3D.PERIOD_SCENE], 'u_FogColor': [BaseScene.FOGCOLOR, Shader3D.PERIOD_SCENE], 'u_DirectionLight.Direction': [BaseScene.LIGHTDIRECTION, Shader3D.PERIOD_SCENE], 'u_DirectionLight.Diffuse': [BaseScene.LIGHTDIRDIFFUSE, Shader3D.PERIOD_SCENE], 'u_DirectionLight.Ambient': [BaseScene.LIGHTDIRAMBIENT, Shader3D.PERIOD_SCENE], 'u_DirectionLight.Specular': [BaseScene.LIGHTDIRSPECULAR, Shader3D.PERIOD_SCENE], 'u_PointLight.Position': [BaseScene.POINTLIGHTPOS, Shader3D.PERIOD_SCENE], 'u_PointLight.Range': [BaseScene.POINTLIGHTRANGE, Shader3D.PERIOD_SCENE], 'u_PointLight.Attenuation': [BaseScene.POINTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 'u_PointLight.Diffuse': [BaseScene.POINTLIGHTDIFFUSE, Shader3D.PERIOD_SCENE], 'u_PointLight.Ambient': [BaseScene.POINTLIGHTAMBIENT, Shader3D.PERIOD_SCENE], 'u_PointLight.Specular': [BaseScene.POINTLIGHTSPECULAR, Shader3D.PERIOD_SCENE], 'u_SpotLight.Position': [BaseScene.SPOTLIGHTPOS, Shader3D.PERIOD_SCENE], 'u_SpotLight.Direction': [BaseScene.SPOTLIGHTDIRECTION, Shader3D.PERIOD_SCENE], 'u_SpotLight.Range': [BaseScene.SPOTLIGHTRANGE, Shader3D.PERIOD_SCENE], 'u_SpotLight.Spot': [BaseScene.SPOTLIGHTSPOT, Shader3D.PERIOD_SCENE], 'u_SpotLight.Attenuation': [BaseScene.SPOTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 'u_SpotLight.Diffuse': [BaseScene.SPOTLIGHTDIFFUSE, Shader3D.PERIOD_SCENE], 'u_SpotLight.Ambient': [BaseScene.SPOTLIGHTAMBIENT, Shader3D.PERIOD_SCENE], 'u_SpotLight.Specular': [BaseScene.SPOTLIGHTSPECULAR, Shader3D.PERIOD_SCENE], 'u_shadowMap1': [BaseScene.SHADOWMAPTEXTURE1, Shader3D.PERIOD_SCENE], //TODO:SM
				'u_shadowMap2': [BaseScene.SHADOWMAPTEXTURE2, Shader3D.PERIOD_SCENE], //TODO:SM
				'u_shadowMap3': [BaseScene.SHADOWMAPTEXTURE3, Shader3D.PERIOD_SCENE], //TODO:SM
				'u_shadowPSSMDistance': [BaseScene.SHADOWDISTANCE, Shader3D.PERIOD_SCENE],//TODO:SM
				'u_lightShadowVP': [BaseScene.SHADOWLIGHTVIEWPROJECT, Shader3D.PERIOD_SCENE],//TODO:SM
				'u_shadowPCFoffset': [BaseScene.SHADOWMAPPCFOFFSET, Shader3D.PERIOD_SCENE]};
			var PBR:int = Shader3D.nameKey.add("PBR");
			vs = __INCLUDESTR__("laya/d3/shader/files/PBR.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/PBR.ps");
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
				'uv': VertexElementUsage.TEXTURECOORDINATE0
			};
			uniformMap = {
				'irrad_mat_red': [BaseCamera.DIFFUSEIRRADMATR, Shader3D.PERIOD_CAMERA], 
				'irrad_mat_green': [BaseCamera.DIFFUSEIRRADMATG, Shader3D.PERIOD_CAMERA], 
				'irrad_mat_blue': [BaseCamera.DIFFUSEIRRADMATB, Shader3D.PERIOD_CAMERA], 
				'u_hdrexposure': [BaseCamera.HDREXPOSURE, Shader3D.PERIOD_CAMERA], 
				'texBaseColor': [WaterMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 
				'texNormal': [WaterMaterial.NORMALTEXTURE, Shader3D.PERIOD_MATERIAL], 
				'texSky':[WaterMaterial.SKYTEXTURE, Shader3D.PERIOD_MATERIAL],
				'texUnderWater':[WaterMaterial.UNDERWATERTEXTURE, Shader3D.PERIOD_MATERIAL],
				'texPrefilterdEnv': [BaseCamera.ENVIRONMENTSPECULAR, Shader3D.PERIOD_CAMERA], 
				'texPrefilterDiff': [BaseCamera.ENVIRONMENTDIFFUSE, Shader3D.PERIOD_CAMERA], 
				'texWaterDisp':[WaterMaterial.VERTEXDISPTEXTURE, Shader3D.PERIOD_MATERIAL],
				'texWaveDetail':[WaterMaterial.DETAILTEXTURE, Shader3D.PERIOD_MATERIAL],
				'texDeepColor':[WaterMaterial.DEEPCOLORTEXTURE, Shader3D.PERIOD_MATERIAL],
				'texWaterInfo':[WaterMaterial.WATERINFO, Shader3D.PERIOD_MATERIAL],
				'texFoam':[WaterMaterial.FOAMTEXTURE, Shader3D.PERIOD_MATERIAL],
				'GEOWAVE_UV_SCALE':[WaterMaterial.GEOWAVE_UV_SCALE,Shader3D.PERIOD_MATERIAL],
				'modelMatrix': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE], 
				'mvp': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 
				//'u_vpMatrix':[BaseCamera.VPMATRIX,Shader3D.PERIOD_CAMERA],
				'cameraPosition': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 
				'u_curTm':[WaterMaterial.CURTM, Shader3D.PERIOD_MATERIAL],//这个要改成全局的
				'u_scrsize':[WaterMaterial.SCRSIZE, Shader3D.PERIOD_MATERIAL],//TODO 这个要全局的
				'u_WaveInfoD':[WaterMaterial.WAVEINFOD, Shader3D.PERIOD_MATERIAL],
				'u_WaveInfo':[WaterMaterial.WAVEINFO, Shader3D.PERIOD_MATERIAL],
				'u_WaveMainDir':[WaterMaterial.WAVEMAINDIR, Shader3D.PERIOD_MATERIAL],//转换矩阵
				'u_SeaColor':[WaterMaterial.SEA_COLOR,Shader3D.PERIOD_MATERIAL],
				'u_View': [BaseCamera.VIEWMATRIX, Shader3D.PERIOD_CAMERA], 
				'u_Project': [BaseCamera.PROJECTMATRIX, Shader3D.PERIOD_CAMERA], 
				'u_FogStart': [BaseScene.FOGSTART, Shader3D.PERIOD_SCENE], 
				'u_FogRange': [BaseScene.FOGRANGE, Shader3D.PERIOD_SCENE], 
				'u_FogColor': [BaseScene.FOGCOLOR, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Direction': [BaseScene.LIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Diffuse': [BaseScene.LIGHTDIRDIFFUSE, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Ambient': [BaseScene.LIGHTDIRAMBIENT, Shader3D.PERIOD_SCENE], 
				'u_DirectionLight.Specular': [BaseScene.LIGHTDIRSPECULAR, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Position': [BaseScene.POINTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Range': [BaseScene.POINTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Attenuation': [BaseScene.POINTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Diffuse': [BaseScene.POINTLIGHTDIFFUSE, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Ambient': [BaseScene.POINTLIGHTAMBIENT, Shader3D.PERIOD_SCENE], 
				'u_PointLight.Specular': [BaseScene.POINTLIGHTSPECULAR, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Position': [BaseScene.SPOTLIGHTPOS, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Direction': [BaseScene.SPOTLIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Range': [BaseScene.SPOTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Spot': [BaseScene.SPOTLIGHTSPOT, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Attenuation': [BaseScene.SPOTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Diffuse': [BaseScene.SPOTLIGHTDIFFUSE, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Ambient': [BaseScene.SPOTLIGHTAMBIENT, Shader3D.PERIOD_SCENE], 
				'u_SpotLight.Specular': [BaseScene.SPOTLIGHTSPECULAR, Shader3D.PERIOD_SCENE]
			};
			var Water:int = Shader3D.nameKey.add("Water");
			vs = __INCLUDESTR__("laya/d3/shader/files/water.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/water.ps");
			shaderCompile = ShaderCompile3D.add(Water, vs, ps, attributeMap, uniformMap);
			WaterMaterial.SHADERDEFINE_CUBE_ENV = shaderCompile.registerMaterialDefine("CUBE_ENV");
			WaterMaterial.SHADERDEFINE_HDR_ENV = shaderCompile.registerMaterialDefine("HDR_ENV");
			WaterMaterial.SHADERDEFINE_SHOW_NORMAL = shaderCompile.registerMaterialDefine("SHOW_NORMAL");
			
			attributeMap = {'a_Position': VertexElementUsage.POSITION0, 'a_Texcoord': VertexElementUsage.TEXTURECOORDINATE0};
			uniformMap = {'u_BlendTexture': [StandardMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 'u_LayerTexture0': [StandardMaterial.NORMALTEXTURE, Shader3D.PERIOD_MATERIAL], 'u_LayerTexture1': [StandardMaterial.SPECULARTEXTURE, Shader3D.PERIOD_MATERIAL], 'u_LayerTexture2': [StandardMaterial.EMISSIVETEXTURE, Shader3D.PERIOD_MATERIAL], 'u_LayerTexture3': [StandardMaterial.AMBIENTTEXTURE, Shader3D.PERIOD_MATERIAL], 'u_Albedo': [StandardMaterial.ALBEDO, Shader3D.PERIOD_MATERIAL], 'u_Ambient': [StandardMaterial.MATERIALAMBIENT, Shader3D.PERIOD_MATERIAL], 'u_UVMatrix': [StandardMaterial.UVMATRIX, Shader3D.PERIOD_MATERIAL], 'u_WorldMat': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE], 'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 'u_CameraPos': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 'u_FogStart': [BaseScene.FOGSTART, Shader3D.PERIOD_SCENE], 'u_FogRange': [BaseScene.FOGRANGE, Shader3D.PERIOD_SCENE], 'u_FogColor': [BaseScene.FOGCOLOR, Shader3D.PERIOD_SCENE]};
			var TERRAIN:int = Shader3D.nameKey.add("TERRAIN");
			vs = __INCLUDESTR__("laya/d3/shader/files/modelTerrain.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/modelTerrain.ps");
			shaderCompile = ShaderCompile3D.add(TERRAIN, vs, ps, attributeMap, uniformMap);
			StandardMaterial.SHADERDEFINE_DIFFUSEMAP = shaderCompile.registerMaterialDefine("DIFFUSEMAP");
			StandardMaterial.SHADERDEFINE_NORMALMAP = shaderCompile.registerMaterialDefine("NORMALMAP");
			StandardMaterial.SHADERDEFINE_SPECULARMAP = shaderCompile.registerMaterialDefine("SPECULARMAP");
			StandardMaterial.SHADERDEFINE_EMISSIVEMAP = shaderCompile.registerMaterialDefine("EMISSIVEMAP");
			StandardMaterial.SHADERDEFINE_AMBIENTMAP = shaderCompile.registerMaterialDefine("AMBIENTMAP");
			StandardMaterial.SHADERDEFINE_REFLECTMAP = shaderCompile.registerMaterialDefine("REFLECTMAP");
			StandardMaterial.SHADERDEFINE_UVTRANSFORM = shaderCompile.registerMaterialDefine("UVTRANSFORM");
			//shaderCompile.reg("MIXUV", StandardMaterial.MIXUV);
			
			attributeMap = {'a_CornerTextureCoordinate': VertexElementUsage.CORNERTEXTURECOORDINATE0, 'a_Position': VertexElementUsage.POSITION0, 'a_Velocity': VertexElementUsage.VELOCITY0, 'a_StartColor': VertexElementUsage.STARTCOLOR0, 'a_EndColor': VertexElementUsage.ENDCOLOR0, 'a_SizeRotation': VertexElementUsage.SIZEROTATION0, 'a_Radius': VertexElementUsage.RADIUS0, 'a_Radian': VertexElementUsage.RADIAN0, 'a_AgeAddScale': VertexElementUsage.STARTLIFETIME, 'a_Time': VertexElementUsage.TIME0};
			uniformMap = {'u_CurrentTime': [ParticleMaterial.CURRENTTIME, Shader3D.PERIOD_MATERIAL], 'u_Duration': [ParticleMaterial.DURATION, Shader3D.PERIOD_MATERIAL], 'u_Gravity': [ParticleMaterial.GRAVITY, Shader3D.PERIOD_MATERIAL], 'u_EndVelocity': [ParticleMaterial.ENDVELOCITY, Shader3D.PERIOD_MATERIAL], 'u_texture': [ParticleMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 'u_WorldMat': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE], 'u_View': [BaseCamera.VIEWMATRIX, Shader3D.PERIOD_CAMERA], 'u_Projection': [BaseCamera.PROJECTMATRIX, Shader3D.PERIOD_CAMERA], 'u_ViewportScale': [ParticleMaterial.VIEWPORTSCALE, Shader3D.PERIOD_MATERIAL]};//TODO:
			var PARTICLE:int = Shader3D.nameKey.add("PARTICLE");
			shaderCompile = ShaderCompile3D.add(PARTICLE, ParticleShader.vs, ParticleShader.ps, attributeMap, uniformMap);
			ParticleMaterial.SHADERDEFINE_PARTICLE3D = shaderCompile.registerMaterialDefine("PARTICLE3D");
			
			attributeMap = {'a_CornerTextureCoordinate': VertexElementUsage.CORNERTEXTURECOORDINATE0, 'a_PositionStartLifeTime': VertexElementUsage.POSITIONSTARTLIFETIME, 'a_DirectionTime': VertexElementUsage.DIRECTIONTIME, 'a_StartColor': VertexElementUsage.STARTCOLOR0, 'a_EndColor': VertexElementUsage.ENDCOLOR0, 'a_StartSize': VertexElementUsage.STARTSIZE, 'a_StartRotation0': VertexElementUsage.STARTROTATION0, 'a_StartRotation1': VertexElementUsage.STARTROTATION1, 'a_StartRotation2': VertexElementUsage.STARTROTATION2, 'a_StartSpeed': VertexElementUsage.STARTSPEED, 'a_Random0': VertexElementUsage.RANDOM0, 'a_Random1': VertexElementUsage.RANDOM1, 'a_SimulationWorldPostion': VertexElementUsage.SIMULATIONWORLDPOSTION};
			uniformMap = {'u_SimulationSpace': [ShurikenParticleMaterial.SIMULATIONSPACE, Shader3D.PERIOD_MATERIAL], 'u_Tintcolor': [ShurikenParticleMaterial.TINTCOLOR, Shader3D.PERIOD_MATERIAL], 'u_ThreeDStartRotation': [ShurikenParticleMaterial.THREEDSTARTROTATION, Shader3D.PERIOD_MATERIAL], 'u_ScalingMode': [ShurikenParticleMaterial.SCALINGMODE, Shader3D.PERIOD_MATERIAL], 'u_CurrentTime': [ShurikenParticleMaterial.CURRENTTIME, Shader3D.PERIOD_MATERIAL], 'u_Gravity': [ShurikenParticleMaterial.GRAVITY, Shader3D.PERIOD_MATERIAL], 'u_texture': [ShurikenParticleMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 'u_StretchedBillboardLengthScale': [ShurikenParticleMaterial.STRETCHEDBILLBOARDLENGTHSCALE, Shader3D.PERIOD_MATERIAL], 'u_StretchedBillboardSpeedScale': [ShurikenParticleMaterial.STRETCHEDBILLBOARDSPEEDSCALE, Shader3D.PERIOD_MATERIAL], 'u_WorldPosition': [ShuriKenParticle3D.WORLDPOSITION, Shader3D.PERIOD_SPRITE], 'u_WorldRotationMat': [ShuriKenParticle3D.WORLDROTATIONMATRIX, Shader3D.PERIOD_SPRITE], 'u_PositionScale': [ShuriKenParticle3D.POSITIONSCALE, Shader3D.PERIOD_SPRITE], 'u_SizeScale': [ShuriKenParticle3D.SIZESCALE, Shader3D.PERIOD_SPRITE], 'u_ColorOverLifeGradientAlphas': [ShuriKenParticle3D.COLOROVERLIFEGRADIENTALPHAS, Shader3D.PERIOD_SPRITE], 'u_ColorOverLifeGradientColors': [ShuriKenParticle3D.COLOROVERLIFEGRADIENTCOLORS, Shader3D.PERIOD_SPRITE], 'u_MaxColorOverLifeGradientAlphas': [ShuriKenParticle3D.MAXCOLOROVERLIFEGRADIENTALPHAS, Shader3D.PERIOD_SPRITE], 'u_MaxColorOverLifeGradientColors': [ShuriKenParticle3D.MAXCOLOROVERLIFEGRADIENTCOLORS, Shader3D.PERIOD_SPRITE], 'u_VOLVelocityConst': [ShuriKenParticle3D.VOLVELOCITYCONST, Shader3D.PERIOD_SPRITE], 'u_VOLVelocityGradientX': [ShuriKenParticle3D.VOLVELOCITYGRADIENTX, Shader3D.PERIOD_SPRITE], 'u_VOLVelocityGradientY': [ShuriKenParticle3D.VOLVELOCITYGRADIENTY, Shader3D.PERIOD_SPRITE], 'u_VOLVelocityGradientZ': [ShuriKenParticle3D.VOLVELOCITYGRADIENTZ, Shader3D.PERIOD_SPRITE], 'u_VOLVelocityConstMax': [ShuriKenParticle3D.VOLVELOCITYCONSTMAX, Shader3D.PERIOD_SPRITE], 'u_VOLVelocityGradientMaxX': [ShuriKenParticle3D.VOLVELOCITYGRADIENTXMAX, Shader3D.PERIOD_SPRITE], 'u_VOLVelocityGradientMaxY': [ShuriKenParticle3D.VOLVELOCITYGRADIENTYMAX, Shader3D.PERIOD_SPRITE], 'u_VOLVelocityGradientMaxZ': [ShuriKenParticle3D.VOLVELOCITYGRADIENTZMAX, Shader3D.PERIOD_SPRITE], 'u_VOLSpaceType': [ShuriKenParticle3D.VOLSPACETYPE, Shader3D.PERIOD_SPRITE], 'u_SOLSizeGradient': [ShuriKenParticle3D.SOLSIZEGRADIENT, Shader3D.PERIOD_SPRITE], 'u_SOLSizeGradientX': [ShuriKenParticle3D.SOLSIZEGRADIENTX, Shader3D.PERIOD_SPRITE], 'u_SOLSizeGradientY': [ShuriKenParticle3D.SOLSIZEGRADIENTY, Shader3D.PERIOD_SPRITE], 'u_SOLSizeGradientZ': [ShuriKenParticle3D.SOLSizeGradientZ, Shader3D.PERIOD_SPRITE], 'u_SOLSizeGradientMax': [ShuriKenParticle3D.SOLSizeGradientMax, Shader3D.PERIOD_SPRITE], 'u_SOLSizeGradientMaxX': [ShuriKenParticle3D.SOLSIZEGRADIENTXMAX, Shader3D.PERIOD_SPRITE], 'u_SOLSizeGradientMaxY': [ShuriKenParticle3D.SOLSIZEGRADIENTYMAX, Shader3D.PERIOD_SPRITE], 'u_SOLSizeGradientMaxZ': [ShuriKenParticle3D.SOLSizeGradientZMAX, Shader3D.PERIOD_SPRITE], 'u_ROLAngularVelocityConst': [ShuriKenParticle3D.ROLANGULARVELOCITYCONST, Shader3D.PERIOD_SPRITE], 'u_ROLAngularVelocityConstSeprarate': [ShuriKenParticle3D.ROLANGULARVELOCITYCONSTSEPRARATE, Shader3D.PERIOD_SPRITE], 'u_ROLAngularVelocityGradient': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENT, Shader3D.PERIOD_SPRITE], 'u_ROLAngularVelocityGradientX': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTX, Shader3D.PERIOD_SPRITE], 'u_ROLAngularVelocityGradientY': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTY, Shader3D.PERIOD_SPRITE], 'u_ROLAngularVelocityGradientZ': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTZ, Shader3D.PERIOD_SPRITE], 'u_ROLAngularVelocityConstMax': [ShuriKenParticle3D.ROLANGULARVELOCITYCONSTMAX, Shader3D.PERIOD_SPRITE], 'u_ROLAngularVelocityConstMaxSeprarate': [ShuriKenParticle3D.ROLANGULARVELOCITYCONSTMAXSEPRARATE, Shader3D.PERIOD_SPRITE], 'u_ROLAngularVelocityGradientMax': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTMAX, Shader3D.PERIOD_SPRITE], 'u_ROLAngularVelocityGradientMaxX': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTXMAX, Shader3D.PERIOD_SPRITE], 'u_ROLAngularVelocityGradientMaxY': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTYMAX, Shader3D.PERIOD_SPRITE], 'u_ROLAngularVelocityGradientMaxZ': [ShuriKenParticle3D.ROLANGULARVELOCITYGRADIENTZMAX, Shader3D.PERIOD_SPRITE], 'u_TSACycles': [ShuriKenParticle3D.TEXTURESHEETANIMATIONCYCLES, Shader3D.PERIOD_SPRITE], 'u_TSASubUVLength': [ShuriKenParticle3D.TEXTURESHEETANIMATIONSUBUVLENGTH, Shader3D.PERIOD_SPRITE], 'u_TSAGradientUVs': [ShuriKenParticle3D.TEXTURESHEETANIMATIONGRADIENTUVS, Shader3D.PERIOD_SPRITE], 'u_TSAMaxGradientUVs': [ShuriKenParticle3D.TEXTURESHEETANIMATIONGRADIENTMAXUVS, Shader3D.PERIOD_SPRITE], 'u_CameraDirection': [BaseCamera.CAMERADIRECTION, Shader3D.PERIOD_CAMERA], 'u_CameraUp': [BaseCamera.CAMERAUP, Shader3D.PERIOD_CAMERA], 'u_View': [BaseCamera.VIEWMATRIX, Shader3D.PERIOD_CAMERA], 'u_Projection': [BaseCamera.PROJECTMATRIX, Shader3D.PERIOD_CAMERA]};
			var PARTICLESHURIKEN:int = Shader3D.nameKey.add("PARTICLESHURIKEN");
			vs = __INCLUDESTR__("laya/d3/shader/files/ParticleShuriKen.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/ParticleShuriKen.ps");
			shaderCompile = ShaderCompile3D.add(PARTICLESHURIKEN, vs, ps, attributeMap, uniformMap);
			ShurikenParticleMaterial.SHADERDEFINE_DIFFUSEMAP = shaderCompile.registerMaterialDefine("DIFFUSEMAP");
			
			ShuriKenParticle3D.SHADERDEFINE_SPHERHBILLBOARD = shaderCompile.registerSpriteDefine("SPHERHBILLBOARD");
			ShuriKenParticle3D.SHADERDEFINE_STRETCHEDBILLBOARD = shaderCompile.registerSpriteDefine("STRETCHEDBILLBOARD");
			ShuriKenParticle3D.SHADERDEFINE_HORIZONTALBILLBOARD = shaderCompile.registerSpriteDefine("HORIZONTALBILLBOARD");
			ShuriKenParticle3D.SHADERDEFINE_VERTICALBILLBOARD = shaderCompile.registerSpriteDefine("VERTICALBILLBOARD");
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
			
			attributeMap = {'a_Position': VertexElementUsage.POSITION0, 'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0, 'a_Time': VertexElementUsage.TIME0};
			uniformMap = {'u_Texture': [GlitterMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 'u_Albedo': [GlitterMaterial.ALBEDO, Shader3D.PERIOD_MATERIAL], 'u_CurrentTime': [GlitterMaterial.CURRENTTIME, Shader3D.PERIOD_MATERIAL], 'u_Color': [GlitterMaterial.UNICOLOR, Shader3D.PERIOD_MATERIAL], 'u_Duration': [GlitterMaterial.DURATION, Shader3D.PERIOD_MATERIAL], 'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE]};
			var GLITTER:int = Shader3D.nameKey.add("GLITTER");
			vs = __INCLUDESTR__("laya/d3/shader/files/Glitter.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/Glitter.ps");
			shaderCompile = ShaderCompile3D.add(GLITTER, vs, ps, attributeMap, uniformMap);
			
			attributeMap = {'a_Position': VertexElementUsage.POSITION0};
			uniformMap = {'u_Intensity': [Sky.INTENSITY, Shader3D.PERIOD_MATERIAL], 'u_AlphaBlending': [Sky.ALPHABLENDING, Shader3D.PERIOD_MATERIAL], 'u_CubeTexture': [Sky.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 'u_MvpMatrix': [BaseCamera.VPMATRIX_NO_TRANSLATE, Shader3D.PERIOD_CAMERA]};//TODO:优化
			var skyBox:int = Shader3D.nameKey.add("SkyBox");
			vs = __INCLUDESTR__("laya/d3/shader/files/SkyBox.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/SkyBox.ps");
			ShaderCompile3D.add(skyBox, vs, ps, attributeMap, uniformMap);
			
			attributeMap = {'a_Position': VertexElementUsage.POSITION0, 'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0};
			uniformMap = {'u_Intensity': [Sky.INTENSITY, Shader3D.PERIOD_MATERIAL], 'u_AlphaBlending': [Sky.ALPHABLENDING, Shader3D.PERIOD_MATERIAL], 'u_texture': [Sky.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 'u_MvpMatrix': [BaseCamera.VPMATRIX_NO_TRANSLATE, Shader3D.PERIOD_CAMERA]};//TODO:优化
			var skyDome:int = Shader3D.nameKey.add("SkyDome");
			vs = __INCLUDESTR__("laya/d3/shader/files/SkyDome.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/SkyDome.ps");
			ShaderCompile3D.add(skyDome, vs, ps, attributeMap, uniformMap);
			
			//terrain的shader
			attributeMap = { 'a_Position': VertexElementUsage.POSITION0, 
							'a_Normal': VertexElementUsage.NORMAL0, 
							'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0, 
							'a_Texcoord1': VertexElementUsage.TEXTURECOORDINATE1};
			uniformMap = { 	'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 
							'u_WorldMat': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE], 
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
							'u_FogStart': [BaseScene.FOGSTART, Shader3D.PERIOD_SCENE], 
							'u_FogRange': [BaseScene.FOGRANGE, Shader3D.PERIOD_SCENE], 
							'u_FogColor': [BaseScene.FOGCOLOR, Shader3D.PERIOD_SCENE],								
							'u_DirectionLight.Direction': [BaseScene.LIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
							'u_DirectionLight.Diffuse': [BaseScene.LIGHTDIRDIFFUSE, Shader3D.PERIOD_SCENE], 
							'u_DirectionLight.Ambient': [BaseScene.LIGHTDIRAMBIENT, Shader3D.PERIOD_SCENE], 
							'u_DirectionLight.Specular': [BaseScene.LIGHTDIRSPECULAR, Shader3D.PERIOD_SCENE], 
							'u_PointLight.Position': [BaseScene.POINTLIGHTPOS, Shader3D.PERIOD_SCENE], 
							'u_PointLight.Range': [BaseScene.POINTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
							'u_PointLight.Attenuation': [BaseScene.POINTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
							'u_PointLight.Diffuse': [BaseScene.POINTLIGHTDIFFUSE, Shader3D.PERIOD_SCENE], 
							'u_PointLight.Ambient': [BaseScene.POINTLIGHTAMBIENT, Shader3D.PERIOD_SCENE], 
							'u_PointLight.Specular': [BaseScene.POINTLIGHTSPECULAR, Shader3D.PERIOD_SCENE], 
							'u_SpotLight.Position': [BaseScene.SPOTLIGHTPOS, Shader3D.PERIOD_SCENE], 
							'u_SpotLight.Direction': [BaseScene.SPOTLIGHTDIRECTION, Shader3D.PERIOD_SCENE], 
							'u_SpotLight.Range': [BaseScene.SPOTLIGHTRANGE, Shader3D.PERIOD_SCENE], 
							'u_SpotLight.Spot': [BaseScene.SPOTLIGHTSPOT, Shader3D.PERIOD_SCENE], 
							'u_SpotLight.Attenuation': [BaseScene.SPOTLIGHTATTENUATION, Shader3D.PERIOD_SCENE], 
							'u_SpotLight.Diffuse': [BaseScene.SPOTLIGHTDIFFUSE, Shader3D.PERIOD_SCENE], 
							'u_SpotLight.Ambient': [BaseScene.SPOTLIGHTAMBIENT, Shader3D.PERIOD_SCENE], 
							'u_SpotLight.Specular': [BaseScene.SPOTLIGHTSPECULAR, Shader3D.PERIOD_SCENE], 
							'u_shadowMap1': [BaseScene.SHADOWMAPTEXTURE1, Shader3D.PERIOD_SCENE], 
							'u_shadowMap2': [BaseScene.SHADOWMAPTEXTURE2, Shader3D.PERIOD_SCENE], 
							'u_shadowMap3': [BaseScene.SHADOWMAPTEXTURE3, Shader3D.PERIOD_SCENE], 
							'u_shadowPSSMDistance': [BaseScene.SHADOWDISTANCE, Shader3D.PERIOD_SCENE], 
							'u_lightShadowVP': [BaseScene.SHADOWLIGHTVIEWPROJECT, Shader3D.PERIOD_SCENE], 
							'u_shadowPCFoffset': [BaseScene.SHADOWMAPPCFOFFSET, Shader3D.PERIOD_SCENE] };
							
			var terrain:int = Shader3D.nameKey.add("Terrain");
			vs = __INCLUDESTR__("laya/d3/shader/files/Terrain.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/Terrain.ps");
			var terrainCompile3D:ShaderCompile3D = ShaderCompile3D.add(terrain, vs, ps, attributeMap, uniformMap);
			TerrainMaterial.SHADERDEFINE_DETAIL_NUM1 = terrainCompile3D.registerMaterialDefine("DETAIL_NUM1");
			TerrainMaterial.SHADERDEFINE_DETAIL_NUM2 = terrainCompile3D.registerMaterialDefine("DETAIL_NUM2");
			TerrainMaterial.SHADERDEFINE_DETAIL_NUM4 = terrainCompile3D.registerMaterialDefine("DETAIL_NUM4");
			TerrainMaterial.SHADERDEFINE_DETAIL_NUM3 = terrainCompile3D.registerMaterialDefine("DETAIL_NUM3");
		}
		
		/**
		 *@private
		 */
		private static function _initResourceLoad():void {
			//ClassUtils.regClass("Sprite3D", Sprite3D);
			//ClassUtils.regClass("MeshSprite3D", MeshSprite3D);
			//ClassUtils.regClass("Material", BaseMaterial);
			
			var createMap:Object = LoaderManager.createMap;
			createMap["lh"] = [Sprite3D, Laya3D.SPRITE3DHIERARCHY];
			createMap["lm"] = [Mesh, Laya3D.MESH];
			createMap["lmat"] = [StandardMaterial, Laya3D.MATERIAL];
			createMap["lpbr"] = [PBRMaterial, Laya3D.MATERIAL];
			createMap["ltc"] = [TextureCube, Laya3D.TEXTURECUBE];
			createMap["jpg"] = [Texture2D, "nativeimage"];
			createMap["jpeg"] = [Texture2D, "nativeimage"];
			createMap["png"] = [Texture2D, "nativeimage"];
			createMap["lsani"] = [AnimationTemplet, Loader.BUFFER];
			createMap["lrani"] = [AnimationTemplet, Loader.BUFFER];
			createMap["raw"] = [DataTexture2D, Loader.BUFFER];
			createMap["mipmaps"] = [DataTexture2D, Loader.BUFFER];
			createMap["thdata"] = [TerrainHeightData, Loader.BUFFER];
			createMap["json"] = [TerrainRes, Loader.JSON];
			createMap["ani"] = [AnimationTemplet, Loader.BUFFER];//兼容接口
			createMap["lani"] = [AnimationTemplet, Loader.BUFFER];//兼容接口
			
			Loader.parserMap[Laya3D.SPRITE3DHIERARCHY] = _loadSprite3DHierarchy;
			Loader.parserMap[Laya3D.MESH] = _loadMesh;
			Loader.parserMap[Laya3D.MATERIAL] = _loadMaterial;
			Loader.parserMap[Laya3D.TEXTURECUBE] = _loadTextureCube;
		}
		
		/**
		 *@private
		 */
		private static function READ_BLOCK():Boolean {
			_readData.pos += 4;
			return true;
		}
		
		/**
		 *@private
		 */
		private static function READ_DATA():Boolean {
			_DATA.offset = _readData.getUint32();
			_DATA.size = _readData.getUint32();
			return true;
		}
		
		/**
		 *@private
		 */
		private static function READ_STRINGS():Array {
			var materialUrls:Array = [];
			var _STRINGS:Object = {offset: 0, size: 0};
			_STRINGS.offset = _readData.getUint16();
			_STRINGS.size = _readData.getUint16();
			var ofs:int = _readData.pos;
			_readData.pos = _STRINGS.offset + _DATA.offset;
			
			for (var i:int = 0; i < _STRINGS.size; i++) {
				var string:String = _readData.readUTFString();
				if (string.lastIndexOf(".lmat") !== -1 || string.lastIndexOf(".lpbr") !== -1)
					materialUrls.push(string);
			}
			return materialUrls;
		}
		
		/**
		 *@private
		 */
		private static function _getSprite3DHierarchyInnerUrls(hierarchyNode:Object, urls:Array, urlMap:Object, urlVersion:String, hierarchyBasePath:String):void {
			var path:String;
			var clas:Class;
			switch (hierarchyNode.type) {
			case "MeshSprite3D": 
				path = hierarchyNode.instanceParams.loadPath;
				clas = Mesh;
				break;
			case "ShuriKenParticle3D": 
				var materialPath:String = hierarchyNode.customProps.materialPath;
				if (materialPath) {
					path = materialPath;
					clas = ShurikenParticleMaterial;//TODO:应该自动序列化类型
				} else {
					path = hierarchyNode.customProps.texturePath;
					clas = Texture2D;
				}
				break;
			}
			
			if (path) {
				var formatSubUrl:String = URL.formatURL(path, hierarchyBasePath);
				(urlVersion) && (formatSubUrl = formatSubUrl + urlVersion);
				urls.push({url: formatSubUrl, clas: clas});
				urlMap[path] = formatSubUrl;
			}
			
			var children:Array = hierarchyNode.child;
			for (var i:int = 0, n:int = children.length; i < n; i++)
				_getSprite3DHierarchyInnerUrls(children[i], urls, urlMap, urlVersion, hierarchyBasePath);
		}
		
		/**
		 *@private
		 */
		private static function _loadSprite3DHierarchy(loader:Loader):void {
			var lmLoader:Loader = new Loader();
			lmLoader.on(Event.COMPLETE, null, _onSprite3DHierarchylhLoaded, [loader]);
			lmLoader.load(loader.url, Loader.TEXT, false, null, true);
		}
		
		/**
		 *@private
		 */
		private static function _onSprite3DHierarchylhLoaded(loader:Loader, lhData:String):void {
			var url:String = loader.url;
			var urlVersion:String = Utils3D.getURLVerion(url);
			var hierarchyBasePath:String = URL.getPath(URL.formatURL(url));
			var urls:Array = [];
			var urlMap:Object = {};
			var hierarchyData:Object = JSON.parse(lhData);
			
			_getSprite3DHierarchyInnerUrls(hierarchyData, urls, urlMap, urlVersion, hierarchyBasePath);
			var urlCount:int = urls.length;
			var totalProcessCount:int = urlCount + 1;
			var lhWeight:Number = 1 / totalProcessCount;
			_onProcessChange(loader, 0, lhWeight, 1.0);
			
			if (urlCount > 0) {
				var processHandler:Handler = Handler.create(null, _onProcessChange, [loader, lhWeight, urlCount / totalProcessCount], false);
				_innerSprite3DHierarchyLoaderManager.create(urls, Handler.create(null, _onSprite3DMeshsLoaded, [loader, processHandler, lhData, urlMap]), processHandler);
			} else {
				_onSprite3DMeshsLoaded(loader, null, lhData, null);
			}
		}
		
		/**
		 *@private
		 */
		private static function _onSprite3DMeshsLoaded(loader:Loader, processHandler:Handler, lhData:Object, urlMap:Object):void {
			loader.endLoad([lhData, urlMap]);
			(processHandler) && (processHandler.recover());
		}
		
		/**
		 *@private
		 */
		private static function _loadMesh(loader:Loader):void {
			var lmLoader:Loader = new Loader();
			lmLoader.on(Event.COMPLETE, null, _onMeshLmLoaded, [loader]);
			lmLoader.load(loader.url, Loader.BUFFER, false, null, true);
		}
		
		/**
		 *@private
		 */
		private static function _onMeshLmLoaded(loader:Loader, lmData:ArrayBuffer):void {
			var url:String = loader.url;
			var urlVersion:String = Utils3D.getURLVerion(url);
			var meshBasePath:String = URL.getPath(URL.formatURL(url));
			
			var urls:Array;
			var urlMap:Object = {};
			var formatSubUrl:String;
			
			var i:int, n:int, count:uint;
			_readData = new Byte(lmData);
			_readData.pos = 0;
			var version:String = _readData.readUTFString();
			switch (version) {
			case "LAYAMODEL:02": 
				var dataOffset:uint = _readData.getUint32();
				_readData.pos = _readData.pos + 4;//跳过数据信息区
				
				count = _readData.getUint16();//跳过内容段落信息区
				_readData.pos = _readData.pos + count * 8;
				
				var offset:uint = _readData.getUint32();//读取字符区
				count = _readData.getUint16();
				_readData.pos = dataOffset + offset;
				
				urls = [];
				for (i = 0; i < count; i++) {
					var string:String = _readData.readUTFString();
					if (string.lastIndexOf(".lmat") !== -1)
						urls.push(string);
				}
				break;
			default: 
				READ_BLOCK();
				for (i = 0; i < 2; i++) {
					var index:int = _readData.getUint16();
					var blockName:String = _strings[index];
					var fn:Function = Laya3D["READ_" + blockName];
					if (fn == null) throw new Error("model file err,no this function:" + index + " " + blockName);
					
					if (i === 1)
						urls = fn.call();
					else
						fn.call()
				}
				
			}
			
			for (i = 0, n = urls.length; i < n; i++) {
				var subUrl:String = urls[i];
				formatSubUrl = URL.formatURL(subUrl, meshBasePath);
				(urlVersion) && (formatSubUrl = formatSubUrl + urlVersion);
				urls[i] = formatSubUrl;
				urlMap[subUrl] = formatSubUrl;
			}
			
			var urlCount:int = 1;//TODO:以后可能为零
			var totalProcessCount:int = urlCount + 1;
			var lmatWeight:Number = 1 / totalProcessCount;
			_onProcessChange(loader, 0, lmatWeight, 1.0);
			var processHandler:Handler = Handler.create(null, _onProcessChange, [loader, lmatWeight, urlCount / totalProcessCount], false);
			_innerMeshLoaderManager.create(urls, Handler.create(null, _onMeshMateialLoaded, [loader, processHandler, lmData, urlMap]), processHandler/*, StandardMaterial*/);
		}
		
		/**
		 *@private
		 */
		private static function _onMeshMateialLoaded(loader:Loader, processHandler:Handler, lmData:Object, urlMap:Object):void {
			loader.endLoad([lmData, urlMap]);
			processHandler.recover();
		}
		
		/**
		 *@private
		 */
		private static function _getMaterialTexturePath(path:String, urlVersion:String, materialBath:String):String {
			var extenIndex:int = path.length - 4;
			if (path.indexOf(".dds") == extenIndex || path.indexOf(".tga") == extenIndex || path.indexOf(".exr") == extenIndex || path.indexOf(".DDS") == extenIndex || path.indexOf(".TGA") == extenIndex || path.indexOf(".EXR") == extenIndex)
				path = path.substr(0, extenIndex) + ".png";
			path = URL.formatURL(path, materialBath);
			(urlVersion) && (path = path + urlVersion);
			return path;
		}
		
		/**
		 *@private
		 */
		private static function _loadMaterial(loader:Loader):void {
			var lmatLoader:Loader = new Loader();
			lmatLoader.on(Event.COMPLETE, null, _onMaterilLmatLoaded, [loader]);
			lmatLoader.load(loader.url, Loader.JSON, false, null, true);
		}
		
		/**
		 *@private
		 */
		private static function _onMaterilLmatLoaded(loader:Loader, lmatData:Object):void {
			var url:String = loader.url;
			var urlVersion:String = Utils3D.getURLVerion(url);
			var materialBasePath:String = URL.getPath(URL.formatURL(url));
			var urls:Array = [];
			var urlMap:Object = {};
			var customProps:Object = lmatData.customProps;
			var formatSubUrl:String;
			var version:String = lmatData.version;
			if (version) {
				switch (version) {
				case "LAYAMATERIAL:01": 
					var textures:Array = lmatData.props.textures;
					for (var i:int = 0, n:int = textures.length; i < n; i++) {
						var path:String = textures[i].path;
						if (path) {
							formatSubUrl = _getMaterialTexturePath(path, urlVersion, materialBasePath);
							urls.push(formatSubUrl);
							urlMap[path] = formatSubUrl;
						}
					}
					break;
				default: 
					throw new Error("Laya3D:unkonwn version.");
				}
			} else {//兼容性代码
				var diffuseTexture:String = customProps.diffuseTexture.texture2D;
				if (diffuseTexture) {
					formatSubUrl = _getMaterialTexturePath(diffuseTexture, urlVersion, materialBasePath);
					urls.push(formatSubUrl);
					urlMap[diffuseTexture] = formatSubUrl;
				}
				
				if (customProps.normalTexture) {
					var normalTexture:String = customProps.normalTexture.texture2D;
					if (normalTexture) {
						formatSubUrl = _getMaterialTexturePath(normalTexture, urlVersion, materialBasePath);
						urls.push(formatSubUrl);
						urlMap[normalTexture] = formatSubUrl;
					}
				}
				
				if (customProps.specularTexture) {
					var specularTexture:String = customProps.specularTexture.texture2D;
					if (specularTexture) {
						formatSubUrl = _getMaterialTexturePath(specularTexture, urlVersion, materialBasePath);
						urls.push(formatSubUrl);
						urlMap[specularTexture] = formatSubUrl;
					}
				}
				
				if (customProps.emissiveTexture) {
					var emissiveTexture:String = customProps.emissiveTexture.texture2D;
					if (emissiveTexture) {
						formatSubUrl = _getMaterialTexturePath(emissiveTexture, urlVersion, materialBasePath);
						urls.push(formatSubUrl);
						urlMap[emissiveTexture] = formatSubUrl;
					}
				}
				
				if (customProps.ambientTexture) {
					var ambientTexture:String = customProps.ambientTexture.texture2D;
					if (ambientTexture) {
						formatSubUrl = _getMaterialTexturePath(ambientTexture, urlVersion, materialBasePath);
						urls.push(formatSubUrl);
						urlMap[ambientTexture] = formatSubUrl;
					}
				}
				
				if (customProps.reflectTexture) {
					var reflectTexture:String = customProps.reflectTexture.texture2D;
					if (reflectTexture) {
						formatSubUrl = _getMaterialTexturePath(reflectTexture, urlVersion, materialBasePath);
						urls.push(formatSubUrl);
						urlMap[reflectTexture] = formatSubUrl;
					}
				}
			}
			
			var urlCount:int = urls.length;
			var totalProcessCount:int = urlCount + 1;
			var lmatWeight:Number = 1 / totalProcessCount;
			_onProcessChange(loader, 0, lmatWeight, 1.0);
			if (urlCount > 0) {
				var processHandler:Handler = Handler.create(null, _onProcessChange, [loader, lmatWeight, urlCount / totalProcessCount], false);
				_innerMaterialLoaderManager.create(urls, Handler.create(null, _onMateialTexturesLoaded, [loader, processHandler, lmatData, urlMap]), processHandler, Texture2D);//TODO:还有可能是TextureCube
			} else {
				_onMateialTexturesLoaded(loader, null, lmatData, null);
			}
		
		}
		
		/**
		 *@private
		 */
		private static function _onMateialTexturesLoaded(loader:Loader, processHandler:Handler, lmatData:Object, urlMap:Object):void {
			loader.endLoad([lmatData, urlMap]);
			(processHandler) && (processHandler.recover());
		}
		
		/**
		 *@private
		 */
		private static function _loadTextureCube(loader:Loader):void {
			var ltcLoader:Loader = new Loader();
			ltcLoader.on(Event.COMPLETE, null, _onTextureCubeLtcLoaded, [loader]);
			ltcLoader.load(loader.url, Loader.JSON, false, null, true);
		}
		
		/**
		 *@private
		 */
		private static function _onTextureCubeLtcLoaded(loader:Loader, ltcData:Object):void {
			var ltcBasePath:String = URL.getPath(URL.formatURL(loader.url));
			var urls:Array = [URL.formatURL(ltcData.px, ltcBasePath), URL.formatURL(ltcData.nx, ltcBasePath), URL.formatURL(ltcData.py, ltcBasePath), URL.formatURL(ltcData.ny, ltcBasePath), URL.formatURL(ltcData.pz, ltcBasePath), URL.formatURL(ltcData.nz, ltcBasePath)];
			var ltcWeight:Number = 1.0 / 7.0;
			_onProcessChange(loader, 0, ltcWeight, 1.0);
			var processHandler:Handler = Handler.create(null, _onProcessChange, [loader, ltcWeight, 6 / 7], false);
			_innerTextureCubeLoaderManager.load(urls, Handler.create(null, _onTextureCubeImagesLoaded, [loader, urls, processHandler]), processHandler, "nativeimage");
		}
		
		/**
		 *@private
		 */
		private static function _onTextureCubeImagesLoaded(loader:Loader, urls:Array, processHandler:Handler):void {
			var images:Array = [];
			images.length = 6;
			for (var i:int = 0; i < 6; i++) {
				var url:String = urls[i];
				images[i] = Loader.getRes(url);
				Loader.clearRes(url);
			}
			loader.endLoad(images);
			processHandler.recover();
		}
		
		/**
		 *@private
		 */
		private static function _onProcessChange(loader:Loader, offset:Number, weight:Number, process:Number):void {
			process = offset + process * weight;
			(process < 1.0) && (loader.event(Event.PROGRESS, process));
		}
		
		/**
		 * 初始化Laya3D相关设置。
		 * @param	width  3D画布宽度。
		 * @param	height 3D画布高度。
		 */
		public static function init(width:Number, height:Number, antialias:Boolean = false, alpha:Boolean = false, premultipliedAlpha:Boolean = true, stencil:Boolean = true):void {
			Config.isAntialias = antialias;
			Config.isAlpha = alpha;
			Config.premultipliedAlpha = premultipliedAlpha;
			Config.isStencil = stencil;
			
			if (!Render.isConchNode && !WebGL.enable()) {
				alert("Laya3D init error,must support webGL!");
				return;
			}
			
			RunDriver.changeWebGLSize = _changeWebGLSize;
			Render.is3DMode = true;
			_innerTextureCubeLoaderManager.maxLoader = 1;
			_innerMaterialLoaderManager.maxLoader = 1;
			_innerMeshLoaderManager.maxLoader = 1;
			_innerSprite3DHierarchyLoaderManager.maxLoader = 1;
			Laya.init(width, height);
			Layer.__init__();
			ShaderCompile3D.__init__();
			_initShader();
			_initResourceLoad();
			
			if (Laya3D.debugMode || OctreeNode.debugMode)
				_debugPhasorSprite = new PhasorSpriter3D();
		}
	
	}
}