#include?DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT "LightHelper.glsl";

attribute vec4 a_Position;
uniform mat4 u_MvpMatrix;

#include?VR "VRHelper.glsl";



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


#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT
attribute vec3 a_Normal;
uniform DirectionLight u_DirectionLight;
uniform PointLight u_PointLight;
uniform SpotLight u_SpotLight;

uniform vec3 u_MaterialDiffuse;
uniform vec3 u_MaterialAmbient;
uniform vec4 u_MaterialSpecular;

varying vec3 v_Diffuse;
varying vec3 v_Ambient;
varying vec3 v_Specular;
#endif

#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG
uniform mat4 u_WorldMat;
uniform vec3 u_CameraPos;
#endif

#ifdef FOG
varying float u_ToEyeLength;
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
 
 
#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT
 #ifdef BONE
 vec3 normal=normalize( mat3(u_WorldMat*skinTransform)*a_Normal);
 #else
 vec3 normal=normalize( mat3(u_WorldMat)*a_Normal);
 #endif
v_Diffuse=vec3(0.0);
v_Ambient=vec3(0.0);
v_Specular=vec3(0.0);
vec3 dif, amb, spe;
#endif

#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG
 #ifdef BONE
 vec3 positionWorld=(u_WorldMat*position).xyz;
 #else
 vec3 positionWorld=(u_WorldMat*a_Position).xyz;
 #endif
#endif

#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG
vec3 toEye;
 #ifdef FOG
 toEye=u_CameraPos-positionWorld;
 u_ToEyeLength=length(toEye);
 toEye/=u_ToEyeLength;
 #else
 toEye=normalize(u_CameraPos-positionWorld);
 #endif
#endif
 
#ifdef DIRECTIONLIGHT
computeDirectionLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_DirectionLight,normal,toEye, dif, amb, spe);
v_Diffuse+=dif;
v_Ambient+=amb;
v_Specular+=spe;
#endif
 
#ifdef POINTLIGHT
computePointLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_PointLight,positionWorld,normal,toEye, dif, amb, spe);
v_Diffuse+=dif;
v_Ambient+=amb;
v_Specular+=spe;
#endif

#ifdef SPOTLIGHT
ComputeSpotLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_SpotLight,positionWorld,normal,toEye, dif, amb, spe);
v_Diffuse+=dif;
v_Ambient+=amb;
v_Specular+=spe;
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