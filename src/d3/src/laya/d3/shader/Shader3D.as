package laya.d3.shader 
{
	import laya.d3.graphics.VertexElementUsage;
	import laya.particle.shader.ParticleShader;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer2D;
	
	/**
	 * @private
	 * <code>Shader3D</code> 类用于创建3Dshader相关。
	 */
	public class Shader3D
	{		
		public static var SIMPLE:int;
		public static var TERRAIN:int;
		public static var PARTICLE:int;
		public static var U3DPARTICLE:int;
		public static var GLITTER:int;
		public static var SIMPLE_EFFECT:int;
		
		public static function __init__():void
		{
			SIMPLE = Shader.nameKey.add("SIMPLE");
			TERRAIN = Shader.nameKey.add("TERRAIN");
			PARTICLE = Shader.nameKey.add("PARTICLE");
			U3DPARTICLE = Shader.nameKey.add("U3DPARTICLE");
			GLITTER = Shader.nameKey.add("GLITTER");
			SIMPLE_EFFECT = Shader.nameKey.add("SIMPLE_EFFECT");
			
			Shader.addInclude("LightHelper.glsl", __INCLUDESTR__("files/LightHelper.glsl"));
			Shader.addInclude("VRHelper.glsl", __INCLUDESTR__("files/VRHelper.glsl"));
			var vs:String, ps:String;
			var shaderNameMap:*=
			{
				'a_Position':VertexElementUsage.POSITION0,
				'a_Color':VertexElementUsage.COLOR0,
				'a_Normal':VertexElementUsage.NORMAL0,
				'a_Texcoord0':VertexElementUsage.TEXTURECOORDINATE0, 
				'a_Texcoord1':VertexElementUsage.TEXTURECOORDINATE1,
				'a_TexcoordNext0':VertexElementUsage.NEXTTEXTURECOORDINATE0, 
				'a_BoneWeights':VertexElementUsage.BLENDWEIGHT0,
				'a_BoneIndices':VertexElementUsage.BLENDINDICES0,
				'a_Tangent0':VertexElementUsage.TANGENT0,
				'u_WorldMat':Buffer2D.MATRIX1,
				'u_CameraPos':Buffer2D.CAMERAPOS,
			    'u_DiffuseTexture':Buffer2D.DIFFUSETEXTURE,
				'u_SpecularTexture':Buffer2D.SPECULARTEXTURE,
				'u_NormalTexture':Buffer2D.NORMALTEXTURE,
				'u_AmbientTexture':Buffer2D.AMBIENTTEXTURE,
				'u_ReflectTexture':Buffer2D.REFLECTTEXTURE,
				'u_MvpMatrix':Buffer2D.MVPMATRIX,
				'u_Bones':Buffer2D.MATRIXARRAY0,
				'u_FogStart':Buffer2D.FOGSTART,
                'u_FogRange':Buffer2D.FOGRANGE,
                'u_FogColor':Buffer2D.FOGCOLOR,
				'u_Albedo':Buffer2D.ALBEDO,
				'u_AlphaTestValue':Buffer2D.ALPHATESTVALUE,
				'u_UVMatrix':Buffer2D.MATRIX2,
				'u_UVAge':Buffer2D.FLOAT0,
				'u_UVAniAge':Buffer2D.UVAGEX,
				'u_DirectionLight.Direction':Buffer2D.LIGHTDIRECTION,
				'u_DirectionLight.Diffuse':Buffer2D.LIGHTDIRDIFFUSE,
				'u_DirectionLight.Ambient':Buffer2D.LIGHTDIRAMBIENT,
				'u_DirectionLight.Specular':Buffer2D.LIGHTDIRSPECULAR,
				'u_PointLight.Position':Buffer2D.POINTLIGHTPOS,
				'u_PointLight.Range':Buffer2D.POINTLIGHTRANGE,
				'u_PointLight.Attenuation':Buffer2D.POINTLIGHTATTENUATION,
				'u_PointLight.Diffuse':Buffer2D.POINTLIGHTDIFFUSE,
				'u_PointLight.Ambient':Buffer2D.POINTLIGHTAMBIENT,
				'u_PointLight.Specular':Buffer2D.POINTLIGHTSPECULAR,
				'u_MaterialDiffuse':Buffer2D.MATERIALDIFFUSE,
				'u_MaterialAmbient':Buffer2D.MATERIALAMBIENT,
				'u_MaterialSpecular':Buffer2D.MATERIALSPECULAR,
				'u_MaterialReflect':Buffer2D.MATERIALREFLECT,
				'u_SpotLight.Position':Buffer2D.SPOTLIGHTPOS,
				'u_SpotLight.Direction':Buffer2D.SPOTLIGHTDIRECTION,
				'u_SpotLight.Range':Buffer2D.SPOTLIGHTRANGE,
				'u_SpotLight.Spot':Buffer2D.SPOTLIGHTSPOT,
				'u_SpotLight.Attenuation':Buffer2D.SPOTLIGHTATTENUATION,
				'u_SpotLight.Diffuse':Buffer2D.SPOTLIGHTDIFFUSE,
				'u_SpotLight.Ambient':Buffer2D.SPOTLIGHTAMBIENT,
				'u_SpotLight.Specular':Buffer2D.SPOTLIGHTSPECULAR
			};
			vs = __INCLUDESTR__("files/VertexSimpleTextureSkinnedMesh.vs");
			ps = __INCLUDESTR__("files/VertexSimpleTextureSkinnedMesh.ps");
			Shader.preCompile(SIMPLE,ShaderDefines3D.VERTEXSHADERING , vs, ps, shaderNameMap);
			vs = __INCLUDESTR__("files/PixelSimpleTextureSkinnedMesh.vs");
			ps = __INCLUDESTR__("files/PixelSimpleTextureSkinnedMesh.ps");
			Shader.preCompile(SIMPLE, ShaderDefines3D.PIXELSHADERING, vs, ps, shaderNameMap);
			
			shaderNameMap =
			{
				'a_Position':VertexElementUsage.POSITION0,
				'a_Texcoord':VertexElementUsage.TEXTURECOORDINATE0, 
				'u_FogStart':Buffer2D.FOGSTART,
                'u_FogRange':Buffer2D.FOGRANGE,
                'u_FogColor':Buffer2D.FOGCOLOR,
				'u_WorldMat':Buffer2D.MATRIX1,
				'u_CameraPos':Buffer2D.CAMERAPOS,
				'u_BlendTexture':Buffer2D.DIFFUSETEXTURE,
				'u_LayerTexture0':Buffer2D.NORMALTEXTURE,
				'u_LayerTexture1':Buffer2D.SPECULARTEXTURE,
				'u_LayerTexture2':Buffer2D.EMISSIVETEXTURE,
				'u_LayerTexture3':Buffer2D.AMBIENTTEXTURE,
				'u_MvpMatrix':Buffer2D.MVPMATRIX,
				'u_Albedo':Buffer2D.ALBEDO, 
				'u_Ambient':Buffer2D.MATERIALAMBIENT,
				'u_UVMatrix':Buffer2D.MATRIX2
			};
			vs = __INCLUDESTR__("files/modelTerrain.vs");
			ps = __INCLUDESTR__("files/modelTerrain.ps");
			Shader.preCompile(TERRAIN, ShaderDefines3D.VERTEXSHADERING , vs, ps, shaderNameMap);
			Shader.preCompile(TERRAIN, ShaderDefines3D.PIXELSHADERING, vs, ps, shaderNameMap);
			
			shaderNameMap =
			{
				'a_CornerTextureCoordinate':VertexElementUsage.CORNERTEXTURECOORDINATE0,
				'a_Position':VertexElementUsage.POSITION0,
				'a_Velocity':VertexElementUsage.VELOCITY0,
				'a_StartColor':VertexElementUsage.STARTCOLOR0,
				'a_EndColor':VertexElementUsage.ENDCOLOR0,
				'a_SizeRotation':VertexElementUsage.SIZEROTATION0,
				'a_Radius':VertexElementUsage.RADIUS0,
				'a_Radian':VertexElementUsage.RADIAN0,
				'a_AgeAddScale':VertexElementUsage.AGEADDSCALE0,
				'a_Time':VertexElementUsage.TIME0,
				
				'u_WorldMat':Buffer2D.MVPMATRIX,
				'u_View':Buffer2D.MATRIX1,
				'u_Projection':Buffer2D.MATRIX2,
				'u_ViewportScale':Buffer2D.VIEWPORTSCALE,
				'u_CurrentTime':Buffer2D.CURRENTTIME, 
				'u_Duration':Buffer2D.DURATION,
				'u_Gravity':Buffer2D.GRAVITY,
				'u_EndVelocity':Buffer2D.ENDVELOCITY,
				'u_texture':Buffer2D.DIFFUSETEXTURE
			};
			
			Shader.preCompile(PARTICLE, ShaderDefines3D.VERTEXSHADERING ,ParticleShader.vs, ParticleShader.ps, shaderNameMap);
			Shader.preCompile(PARTICLE, ShaderDefines3D.PIXELSHADERING, ParticleShader.vs, ParticleShader.ps, shaderNameMap);			
			
			shaderNameMap =
			{
				'a_CornerTextureCoordinate':VertexElementUsage.CORNERTEXTURECOORDINATE0,
				'a_Position':VertexElementUsage.POSITION0,
				'a_Velocity':VertexElementUsage.VELOCITY0,
				'a_StartColor':VertexElementUsage.STARTCOLOR0,
				'a_EndColor':VertexElementUsage.ENDCOLOR0,
				'a_SizeRotation':VertexElementUsage.SIZEROTATION0,
				'a_Radius':VertexElementUsage.RADIUS0,
				'a_Radian':VertexElementUsage.RADIAN0,
				'a_AgeAddScale':VertexElementUsage.AGEADDSCALE0,
				'a_Time':VertexElementUsage.TIME0,
				
				'u_WorldMat':Buffer2D.MVPMATRIX,
				'u_View':Buffer2D.MATRIX1,
				'u_Projection':Buffer2D.MATRIX2,
				'u_ViewportScale':Buffer2D.VIEWPORTSCALE,
				'u_CurrentTime':Buffer2D.CURRENTTIME, 
				'u_Duration':Buffer2D.DURATION,
				'u_Gravity':Buffer2D.GRAVITY,
				'u_EndVelocity':Buffer2D.ENDVELOCITY,
				'u_texture':Buffer2D.DIFFUSETEXTURE
			};
			
			Shader.preCompile(U3DPARTICLE, ShaderDefines3D.VERTEXSHADERING ,ParticleShader.vs, ParticleShader.ps, shaderNameMap);
			Shader.preCompile(U3DPARTICLE, ShaderDefines3D.PIXELSHADERING, ParticleShader.vs, ParticleShader.ps, shaderNameMap);
			
			shaderNameMap =
			{
				'a_Position':VertexElementUsage.POSITION0,
				'a_Texcoord0':VertexElementUsage.TEXTURECOORDINATE0,
				'a_Time':Buffer2D.TIME, 
			    'u_Texture':Buffer2D.DIFFUSETEXTURE,
				'u_MvpMatrix':Buffer2D.MVPMATRIX,
				'u_Albedo':Buffer2D.ALBEDO,
				'u_CurrentTime':Buffer2D.CURRENTTIME,
                'u_Color':Buffer2D.UNICOLOR ,
				'u_Duration':Buffer2D.DURATION
			};
			vs = __INCLUDESTR__("files/Glitter.vs");
			ps = __INCLUDESTR__("files/Glitter.ps");
			Shader.preCompile(GLITTER, ShaderDefines3D.VERTEXSHADERING ,vs, ps, shaderNameMap);
			Shader.preCompile(GLITTER, ShaderDefines3D.PIXELSHADERING, vs, ps, shaderNameMap);	
			
			
			 shaderNameMap=
			{
				'a_Position':VertexElementUsage.POSITION0,
				'a_Color':VertexElementUsage.COLOR0,
				'a_Texcoord0':VertexElementUsage.TEXTURECOORDINATE0, 
				'a_TexcoordNext0':VertexElementUsage.NEXTTEXTURECOORDINATE0, 
				'a_Texcoord1':VertexElementUsage.TEXTURECOORDINATE1, 
				'a_TexcoordNext1':VertexElementUsage.NEXTTEXTURECOORDINATE1, 
			    'u_DiffuseTexture':Buffer2D.DIFFUSETEXTURE,
				'u_SpecularTexture':Buffer2D.SPECULARTEXTURE,
				'u_MvpMatrix':Buffer2D.MVPMATRIX,
				'u_FogStart':Buffer2D.FOGSTART,
                'u_FogRange':Buffer2D.FOGRANGE,
                'u_FogColor':Buffer2D.FOGCOLOR,
				'u_Albedo':Buffer2D.ALBEDO,
				'u_UVAge':Buffer2D.FLOAT0,
				'u_UVAniAge':Buffer2D.UVAGEX
			};
			vs = __INCLUDESTR__("files/SimpleEffect.vs");
			ps = __INCLUDESTR__("files/SimpleEffect.ps");
			Shader.preCompile(SIMPLE_EFFECT,ShaderDefines3D.VERTEXSHADERING , vs, ps, shaderNameMap);
			vs = __INCLUDESTR__("files/SimpleEffect.vs");
			ps = __INCLUDESTR__("files/SimpleEffect.ps");
			Shader.preCompile(SIMPLE_EFFECT, ShaderDefines3D.PIXELSHADERING, vs, ps, shaderNameMap);
		}
	}
}