package laya.d3.shader 
{
	import laya.d3.graphics.VertexElementUsage;
	import laya.particle.shader.ParticleShader;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer;
	
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
				'u_WorldMat':Buffer.MATRIX1,
				'u_CameraPos':Buffer.CAMERAPOS,
			    'u_DiffuseTexture':Buffer.DIFFUSETEXTURE,
				'u_SpecularTexture':Buffer.SPECULARTEXTURE,
				'u_NormalTexture':Buffer.NORMALTEXTURE,
				'u_AmbientTexture':Buffer.AMBIENTTEXTURE,
				'u_ReflectTexture':Buffer.REFLECTTEXTURE,
				'u_MvpMatrix':Buffer.MVPMATRIX,
				'u_Bones':Buffer.MATRIXARRAY0,
				'u_FogStart':Buffer.FOGSTART,
                'u_FogRange':Buffer.FOGRANGE,
                'u_FogColor':Buffer.FOGCOLOR,
				'u_Luminance':Buffer.LUMINANCE,
				'u_AlphaTestValue':Buffer.ALPHATESTVALUE,
				'u_UVMatrix':Buffer.MATRIX2,
				'u_UVAge':Buffer.FLOAT0,
				'u_UVAniAge':Buffer.UVAGEX,
				'u_DirectionLight.Direction':Buffer.LIGHTDIRECTION,
				'u_DirectionLight.Diffuse':Buffer.LIGHTDIRDIFFUSE,
				'u_DirectionLight.Ambient':Buffer.LIGHTDIRAMBIENT,
				'u_DirectionLight.Specular':Buffer.LIGHTDIRSPECULAR,
				'u_PointLight.Position':Buffer.POINTLIGHTPOS,
				'u_PointLight.Range':Buffer.POINTLIGHTRANGE,
				'u_PointLight.Attenuation':Buffer.POINTLIGHTATTENUATION,
				'u_PointLight.Diffuse':Buffer.POINTLIGHTDIFFUSE,
				'u_PointLight.Ambient':Buffer.POINTLIGHTAMBIENT,
				'u_PointLight.Specular':Buffer.POINTLIGHTSPECULAR,
				'u_MaterialDiffuse':Buffer.MATERIALDIFFUSE,
				'u_MaterialAmbient':Buffer.MATERIALAMBIENT,
				'u_MaterialSpecular':Buffer.MATERIALSPECULAR,
				'u_MaterialReflect':Buffer.MATERIALREFLECT,
				'u_SpotLight.Position':Buffer.SPOTLIGHTPOS,
				'u_SpotLight.Direction':Buffer.SPOTLIGHTDIRECTION,
				'u_SpotLight.Range':Buffer.SPOTLIGHTRANGE,
				'u_SpotLight.Spot':Buffer.SPOTLIGHTSPOT,
				'u_SpotLight.Attenuation':Buffer.SPOTLIGHTATTENUATION,
				'u_SpotLight.Diffuse':Buffer.SPOTLIGHTDIFFUSE,
				'u_SpotLight.Ambient':Buffer.SPOTLIGHTAMBIENT,
				'u_SpotLight.Specular':Buffer.SPOTLIGHTSPECULAR
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
				'u_FogStart':Buffer.FOGSTART,
                'u_FogRange':Buffer.FOGRANGE,
                'u_FogColor':Buffer.FOGCOLOR,
				'u_WorldMat':Buffer.MATRIX1,
				'u_CameraPos':Buffer.CAMERAPOS,
				'u_BlendTexture':Buffer.DIFFUSETEXTURE,
				'u_LayerTexture0':Buffer.NORMALTEXTURE,
				'u_LayerTexture1':Buffer.SPECULARTEXTURE,
				'u_LayerTexture2':Buffer.EMISSIVETEXTURE,
				'u_LayerTexture3':Buffer.AMBIENTTEXTURE,
				'u_MvpMatrix':Buffer.MVPMATRIX,
				'u_Luminance':Buffer.LUMINANCE, 
				'u_Ambient':Buffer.MATERIALAMBIENT,
				'u_UVMatrix':Buffer.MATRIX2
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
				
				'u_WorldMat':Buffer.MVPMATRIX,
				'u_View':Buffer.MATRIX1,
				'u_Projection':Buffer.MATRIX2,
				'u_ViewportScale':Buffer.VIEWPORTSCALE,
				'u_CurrentTime':Buffer.CURRENTTIME, 
				'u_Duration':Buffer.DURATION,
				'u_Gravity':Buffer.GRAVITY,
				'u_EndVelocity':Buffer.ENDVELOCITY,
				'u_texture':Buffer.DIFFUSETEXTURE
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
				
				'u_WorldMat':Buffer.MVPMATRIX,
				'u_View':Buffer.MATRIX1,
				'u_Projection':Buffer.MATRIX2,
				'u_ViewportScale':Buffer.VIEWPORTSCALE,
				'u_CurrentTime':Buffer.CURRENTTIME, 
				'u_Duration':Buffer.DURATION,
				'u_Gravity':Buffer.GRAVITY,
				'u_EndVelocity':Buffer.ENDVELOCITY,
				'u_texture':Buffer.DIFFUSETEXTURE
			};
			
			Shader.preCompile(U3DPARTICLE, ShaderDefines3D.VERTEXSHADERING ,ParticleShader.vs, ParticleShader.ps, shaderNameMap);
			Shader.preCompile(U3DPARTICLE, ShaderDefines3D.PIXELSHADERING, ParticleShader.vs, ParticleShader.ps, shaderNameMap);
			
			shaderNameMap =
			{
				'a_Position':VertexElementUsage.POSITION0,
				'a_Texcoord0':VertexElementUsage.TEXTURECOORDINATE0,
				'a_Time':Buffer.TIME, 
			    'u_Texture':Buffer.DIFFUSETEXTURE,
				'u_MvpMatrix':Buffer.MVPMATRIX,
				'u_Luminance':Buffer.LUMINANCE,
				'u_CurrentTime':Buffer.CURRENTTIME,
                'u_Color':Buffer.UNICOLOR ,
				'u_Duration':Buffer.DURATION
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
			    'u_DiffuseTexture':Buffer.DIFFUSETEXTURE,
				'u_SpecularTexture':Buffer.SPECULARTEXTURE,
				'u_MvpMatrix':Buffer.MVPMATRIX,
				'u_FogStart':Buffer.FOGSTART,
                'u_FogRange':Buffer.FOGRANGE,
                'u_FogColor':Buffer.FOGCOLOR,
				'u_Luminance':Buffer.LUMINANCE,
				'u_UVAge':Buffer.FLOAT0,
				'u_UVAniAge':Buffer.UVAGEX
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