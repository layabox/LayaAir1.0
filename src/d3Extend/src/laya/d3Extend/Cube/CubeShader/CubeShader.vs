#include "Lighting.glsl";

attribute vec4 a_Position;
uniform mat4 u_MvpMatrix;

#if defined(DIFFUSEMAP)||((defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT))&&(defined(SPECULARMAP)||defined(NORMALMAP)))||(defined(LIGHTMAP)&&defined(UV))
	attribute vec2 a_Texcoord0;
	varying vec2 v_Texcoord0;
#endif

#if defined(LIGHTMAP)&&defined(UV1)
	attribute vec2 a_Texcoord1;
#endif

#ifdef LIGHTMAP
	uniform vec4 u_LightmapScaleOffset;
	varying vec2 v_LightMapUV;
#endif

#ifdef COLOR
	attribute vec4 a_Color;
	varying vec4 v_Color;
#endif

#ifdef BONE
	const int c_MaxBoneCount = 24;
	attribute vec4 a_BoneIndices;
	attribute vec4 a_BoneWeights;
	uniform mat4 u_Bones[c_MaxBoneCount];
#endif

attribute vec3 a_Normal;
#if defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT)||defined(REFLECTMAP)
	
	varying vec3 v_Normal; 
	uniform vec3 u_CameraPos;
	varying vec3 v_ViewDir; 
#endif

#if (defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT))&&defined(NORMALMAP)
	attribute vec4 a_Tangent0;
	varying vec3 v_Tangent;
	varying vec3 v_Binormal;
#endif

#if defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT)||defined(REFLECTMAP)||defined(RECEIVESHADOW)
	uniform mat4 u_WorldMat;
	varying vec3 v_PositionWorld;
#endif

varying float v_posViewZ;
#ifdef RECEIVESHADOW
  #ifdef SHADOWMAP_PSSM1 
  varying vec4 v_lightMVPPos;
  uniform mat4 u_lightShadowVP[4];
  #endif
#endif

#ifdef TILINGOFFSET
	uniform vec4 u_TilingOffset;
#endif

#ifdef SPECULARMAP 
	uniform sampler2D u_SpecularTexture;//TODO:使用高光贴图代替颜色贴图,并临时删除了原有高光贴图逻辑
#endif

void main_castShadow()
{
	#ifdef BONE
		mat4 skinTransform = u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;
		skinTransform += u_Bones[int(a_BoneIndices.y)] * a_BoneWeights.y;
		skinTransform += u_Bones[int(a_BoneIndices.z)] * a_BoneWeights.z;
		skinTransform += u_Bones[int(a_BoneIndices.w)] * a_BoneWeights.w;
		vec4 position=skinTransform*a_Position;
		gl_Position = u_MvpMatrix * position;
	#else
		gl_Position = u_MvpMatrix * a_Position;
	#endif
	 
	//TODO没考虑UV动画呢
	#if defined(DIFFUSEMAP)&&defined(ALPHATEST)
		v_Texcoord0=a_Texcoord0;
	#endif
		v_posViewZ = gl_Position.z;
}

mat3 inverse(mat3 m) {
  float a00 = m[0][0], a01 = m[0][1], a02 = m[0][2];
  float a10 = m[1][0], a11 = m[1][1], a12 = m[1][2];
  float a20 = m[2][0], a21 = m[2][1], a22 = m[2][2];

  float b01 = a22 * a11 - a12 * a21;
  float b11 = -a22 * a10 + a12 * a20;
  float b21 = a21 * a10 - a11 * a20;

  float det = a00 * b01 + a01 * b11 + a02 * b21;

  return mat3(b01, (-a22 * a01 + a02 * a21), (a12 * a01 - a02 * a11),
              b11, (a22 * a00 - a02 * a20), (-a12 * a00 + a02 * a10),
              b21, (-a21 * a00 + a01 * a20), (a11 * a00 - a01 * a10)) / det;
}

void main_normal()
{
	#ifdef BONE
		mat4 skinTransform = u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;
		skinTransform += u_Bones[int(a_BoneIndices.y)] * a_BoneWeights.y;
		skinTransform += u_Bones[int(a_BoneIndices.z)] * a_BoneWeights.z;
		skinTransform += u_Bones[int(a_BoneIndices.w)] * a_BoneWeights.w;
		vec4 position=skinTransform*a_Position;
		gl_Position = u_MvpMatrix * position;
	#else
		gl_Position = u_MvpMatrix * a_Position;
	#endif

	#if defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT)||defined(REFLECTMAP)
		mat3 worldInvMat;
		#ifdef BONE
			worldInvMat=inverse(mat3(u_WorldMat*skinTransform));
		#else
			worldInvMat=inverse(mat3(u_WorldMat));
		#endif  
		v_Normal=a_Normal*worldInvMat;
		#if (defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT))&&defined(NORMALMAP)
			v_Tangent=a_Tangent0.xyz*worldInvMat;
			v_Binormal=cross(v_Normal,v_Tangent)*a_Tangent0.w;
		#endif
	#endif

	#if defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT)||defined(REFLECTMAP)||defined(RECEIVESHADOW)
		#ifdef BONE
			v_PositionWorld=(u_WorldMat*position).xyz;
		#else
			v_PositionWorld=(u_WorldMat*a_Position).xyz;
		#endif
	#endif
	
	#if defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT)||defined(REFLECTMAP)
		v_ViewDir=u_CameraPos-v_PositionWorld;
	#endif

	#if defined(DIFFUSEMAP)||((defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT))&&(defined(SPECULARMAP)||defined(NORMALMAP)))
		#ifdef MODENABLEVERTEXCOLOR
			//miner
			float angle=0.0;
			if(a_Normal.x==1.0&&a_Normal.y==0.0&&a_Normal.z==0.0)
			{
				angle=3.1415926/2.0;
			}
			else if(a_Normal.x==0.0&&a_Normal.y==0.0&&a_Normal.z==-1.0)
			{
				angle=3.1415926;
			}
			else if(a_Normal.x==0.0&&a_Normal.y==1.0&&a_Normal.z==0.0)
			{
				angle=-3.1415926/2.0;
			}
			else if(a_Normal.x==0.0&&a_Normal.y==-1.0&&a_Normal.z==0.0)
			{
				angle=3.1415926;
			}

			v_Texcoord0=a_Texcoord0-vec2(0.5);
			float c = cos(angle);
			float s = sin(angle);
			mat2 rotation= mat2(c, -s, s, c);
			v_Texcoord0=rotation*v_Texcoord0;
			v_Texcoord0=v_Texcoord0+vec2(0.5);
			
			float offsetU = 1.0/16.0;
			float count = floor(a_Color.a-0.9);
			v_Texcoord0 =vec2(count*offsetU+v_Texcoord0.x/16.0,v_Texcoord0.y);
		#elif defined(SOLIDCOLORTEXTURE)
			float offsetU = 1.0/16.0;
			float count = floor(a_Color.a-0.9);
			v_Texcoord0 =vec2(count*offsetU+0.5/16.0,0.5);
		#else
			v_Texcoord0 = a_Texcoord0;
		#endif
		
		#ifdef TILINGOFFSET
			v_Texcoord0=TransformUV(v_Texcoord0,u_TilingOffset);
		#endif
	#endif

	#ifdef LIGHTMAP
		#ifdef SCALEOFFSETLIGHTINGMAPUV
			#ifdef UV1
				v_LightMapUV=vec2(a_Texcoord1.x,1.0-a_Texcoord1.y)*u_LightmapScaleOffset.xy+u_LightmapScaleOffset.zw;
			#else
				v_LightMapUV=vec2(a_Texcoord0.x,1.0-a_Texcoord0.y)*u_LightmapScaleOffset.xy+u_LightmapScaleOffset.zw;
			#endif 
			v_LightMapUV.y=1.0-v_LightMapUV.y;
		#else
			#ifdef UV1
				v_LightMapUV=a_Texcoord1;
			#else
				v_LightMapUV=a_Texcoord0;
			#endif 
		#endif 
	#endif
	
	#if defined(MODENABLEVERTEXCOLOR)||defined(SOLIDCOLORTEXTURE)
		#if defined(COLOR)&&defined(ENABLEVERTEXCOLOR)
			#ifdef SPECULARMAP 	
				vec3 lcolor = texture2D(SpecularTexture, v_Texcoord0)
				float factor = lcolor.x/a_Color.x;
				v_Color=vec4(factor,factor,factor,1.0);
			#else
				if(a_Color.a>0.5)
				{
					v_Color = vec4(1.0,1.0,1.0,1.0);
				}
				else
				{
					v_Color = a_Color;
				}
			#endif
		#endif
	#endif

	//#if defined(COLOR)&&(defined(MODENABLEVERTEXCOLOR)||defined(SOLIDCOLORTEXTURE))
		//v_Color=a_Color;
	//#endif
	
	#ifdef RECEIVESHADOW
		v_posViewZ = gl_Position.w;
		#ifdef SHADOWMAP_PSSM1 
			v_lightMVPPos = u_lightShadowVP[0] * vec4(v_PositionWorld,1.0);
		#endif
	#endif
}

void main()
{
	#ifdef CASTSHADOW
		main_castShadow();
	#else
		main_normal();
	#endif
	
	
}