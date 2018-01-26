attribute vec4 a_Position;
uniform mat4 u_MvpMatrix;



#if defined(DIFFUSEMAP)||((defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT))&&(defined(COLOR)&&defined(SPECULARMAP)||defined(NORMALMAP)))||(defined(LIGHTMAP)&&defined(UV))
attribute vec2 a_Texcoord0;
varying vec2 v_Texcoord0;
  #ifdef UVTRANSFORM 
  uniform mat4 u_UVMatrix;
  #endif
#endif

#if defined(AMBIENTMAP)||(defined(LIGHTMAP)&&defined(UV1))
attribute vec2 a_Texcoord1;
#endif

#if defined(AMBIENTMAP)||defined(LIGHTMAP)
uniform vec4 u_LightmapScaleOffset;
varying vec2 v_LightMapUV;
#endif


#ifdef COLOR
attribute vec4 a_Color;
varying vec4 v_Color;
#endif

#ifdef BONE
attribute vec4 a_BoneIndices;
attribute vec4 a_BoneWeights;
const int c_MaxBoneCount = 24;
uniform mat4 u_Bones[c_MaxBoneCount];
#endif

#if defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT)||defined(REFLECTMAP)
attribute vec3 a_Normal;
varying vec3 v_Normal;
#endif

#if (defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT)||defined(REFLECTMAP))&&defined(NORMALMAP)
attribute vec3 a_Tangent0;
varying vec3 v_Tangent0;
#endif

#if defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT)||defined(FOG)||defined(DEPTHFOG)||defined(REFLECTMAP)||defined(RECEIVESHADOW)
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

void main_castShadow()
{
#ifdef BONE
	mat4 skinTransform=mat4(0.0);
	skinTransform += u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;
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

void main_normal()
{
#ifdef BONE
	mat4 skinTransform=mat4(0.0);
	skinTransform += u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;
	skinTransform += u_Bones[int(a_BoneIndices.y)] * a_BoneWeights.y;
	skinTransform += u_Bones[int(a_BoneIndices.z)] * a_BoneWeights.z;
	skinTransform += u_Bones[int(a_BoneIndices.w)] * a_BoneWeights.w;
	vec4 position=skinTransform*a_Position;
	gl_Position = u_MvpMatrix * position;
#else
	gl_Position = u_MvpMatrix * a_Position;
#endif

#if defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT)||defined(REFLECTMAP)
	mat3 worldMat;
	#ifdef BONE
		worldMat=mat3(u_WorldMat*skinTransform);
	#else
		worldMat=mat3(u_WorldMat);
	#endif  
	v_Normal=worldMat*a_Normal;
	#if (defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT))&&defined(NORMALMAP)
		v_Tangent0=worldMat*a_Tangent0;
	#endif
#endif

#if defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT)||defined(FOG)||defined(DEPTHFOG)||defined(REFLECTMAP)||defined(RECEIVESHADOW)
	#ifdef BONE
		v_PositionWorld=(u_WorldMat*position).xyz;
	#else
		v_PositionWorld=(u_WorldMat*a_Position).xyz;
	#endif
#endif

#if defined(DIFFUSEMAP)||((defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT))&&(defined(COLOR)&&defined(SPECULARMAP)||defined(NORMALMAP)))
	v_Texcoord0=a_Texcoord0;
	#ifdef TILINGOFFSET
		v_Texcoord0=(vec2(v_Texcoord0.x,v_Texcoord0.y-1.0)*u_TilingOffset.xy)+u_TilingOffset.zw;
		v_Texcoord0=vec2(v_Texcoord0.x,v_Texcoord0.y+1.0);
	#endif
	#ifdef UVTRANSFORM
		v_Texcoord0=(u_UVMatrix*vec4(v_Texcoord0,0.0,1.0)).xy;
	#endif
#endif

#if defined(AMBIENTMAP)||defined(LIGHTMAP)
	#ifdef SCALEOFFSETLIGHTINGMAPUV
		#ifdef UV1
			v_LightMapUV=vec2(a_Texcoord1.x*u_LightmapScaleOffset.x+u_LightmapScaleOffset.z,1.0+a_Texcoord1.y*u_LightmapScaleOffset.y+u_LightmapScaleOffset.w);
		#else
			v_LightMapUV=vec2(a_Texcoord0.x,a_Texcoord0.y-1.0)*u_LightmapScaleOffset.xy+u_LightmapScaleOffset.zw;
		#endif 
	#else
		#ifdef UV1
			v_LightMapUV=a_Texcoord1;
		#else
			v_LightMapUV=a_Texcoord0;
		#endif 
	#endif 
#endif

#ifdef COLOR
	v_Color=a_Color;
#endif

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