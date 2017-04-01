#include?VR "VRHelper.glsl";
attribute vec4 a_Position;
uniform mat4 u_MvpMatrix;



#if defined(DIFFUSEMAP)||((defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT))&&(defined(COLOR)&&defined(SPECULARMAP)||defined(NORMALMAP)))
attribute vec2 a_Texcoord0;
varying vec2 v_Texcoord0;
  #ifdef MIXUV
  attribute vec2 a_TexcoordNext0;
  uniform float  u_UVAge;
  #endif
  #ifdef UVTRANSFORM 
  uniform mat4 u_UVMatrix;
  #endif
#endif

#ifdef AMBIENTMAP
attribute vec2 a_Texcoord1;
uniform vec4 u_LightmapScaleOffset;
varying vec2 v_Texcoord1;
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

#if defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT)||defined(FOG)||defined(REFLECTMAP)
uniform mat4 u_WorldMat;
varying vec3 v_PositionWorld;
#endif


void main()
{
 #ifdef BONE
 mat4 skinTransform=mat4(0.0);
 skinTransform += u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;
 skinTransform += u_Bones[int(a_BoneIndices.y)] * a_BoneWeights.y;
 skinTransform += u_Bones[int(a_BoneIndices.z)] * a_BoneWeights.z;
 skinTransform += u_Bones[int(a_BoneIndices.w)] * a_BoneWeights.w;
 vec4 position=skinTransform*a_Position;
   #ifdef VR
   gl_Position = DistortFishEye(u_MvpMatrix * position);
   #else
   gl_Position = u_MvpMatrix * position;
   #endif
 #else
   #ifdef VR
   gl_Position = DistortFishEye(u_MvpMatrix * a_Position);
   #else
   gl_Position = u_MvpMatrix * a_Position;
   #endif
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
 
 #if defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT)||defined(FOG)
   #ifdef BONE
   v_PositionWorld=(u_WorldMat*position).xyz;
   #else
   v_PositionWorld=(u_WorldMat*a_Position).xyz;
   #endif
 #endif
 
#if defined(DIFFUSEMAP)||((defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT))&&(defined(COLOR)&&defined(SPECULARMAP)||defined(NORMALMAP)))
  #ifdef MIXUV
  v_Texcoord0=mix(a_Texcoord0,a_TexcoordNext0,u_UVAge);
  #else
  v_Texcoord0=a_Texcoord0;
  #endif
  #ifdef UVTRANSFORM
  v_Texcoord0=(u_UVMatrix*vec4(v_Texcoord0,0.0,1.0)).xy;
  #endif
#endif

#ifdef AMBIENTMAP
  #ifdef SCALEOFFSETLIGHTINGMAPUV
  v_Texcoord1=vec2(a_Texcoord1.x*u_LightmapScaleOffset.x+u_LightmapScaleOffset.z,1.0+a_Texcoord1.y*u_LightmapScaleOffset.y+u_LightmapScaleOffset.w);
  #else
  v_Texcoord1=a_Texcoord1;
  #endif 
#endif

  
#ifdef COLOR
v_Color=a_Color;
#endif
}