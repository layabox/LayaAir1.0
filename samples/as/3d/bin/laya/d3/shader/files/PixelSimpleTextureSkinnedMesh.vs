#include?VR "VRHelper.glsl";
attribute vec4 a_Position;
uniform mat4 u_MvpMatrix;



#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&COLOR&&SPECULARMAP)
attribute vec2 a_Texcoord0;
varying vec2 v_Texcoord;

#ifdef MIXUV
attribute vec2 a_TexcoordNext0;
uniform float  u_UVAge;
#endif

#ifdef UVTRANSFORM
uniform mat4 u_UVMatrix;
#endif

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


#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP
attribute vec3 a_Normal;
varying vec3 v_Normal;
#endif

#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP
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
 

 #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP
  #ifdef BONE
  v_Normal=mat3(u_WorldMat*skinTransform)*a_Normal;
  #else
  v_Normal=mat3(u_WorldMat)*a_Normal;
  #endif
 #endif
 
 #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG
  #ifdef BONE
  v_PositionWorld=(u_WorldMat*position).xyz;
  #else
  v_PositionWorld=(u_WorldMat*a_Position).xyz;
  #endif
 #endif
 
#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&COLOR&&SPECULARMAP)
  #ifdef MIXUV
  v_Texcoord=mix(a_Texcoord0,a_TexcoordNext0,u_UVAge);
  #else
  v_Texcoord=a_Texcoord0;
  #endif
  #ifdef UVTRANSFORM
  v_Texcoord=(u_UVMatrix*vec4(v_Texcoord,0.0,1.0)).xy;
  #endif
#endif
  
#ifdef COLOR
v_Color=a_Color;
#endif
}