#include?DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT "LightHelper.glsl";

attribute vec4 a_Position;
uniform mat4 u_MvpMatrix;

#include?VR "VRHelper.glsl";



#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&COLOR&&SPECULARMAP)
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

#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP
attribute vec3 a_Normal;
#endif

#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP
uniform mat4 u_WorldMat;
uniform vec3 u_CameraPos;
#endif

#ifdef DIRECTIONLIGHT
uniform DirectionLight u_DirectionLight;
#endif

#ifdef POINTLIGHT
uniform PointLight u_PointLight;
#endif

#ifdef SPOTLIGHT
uniform SpotLight u_SpotLight;
#endif

#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT
uniform vec3 u_MaterialDiffuse;
uniform vec4 u_MaterialSpecular;

varying vec3 v_Diffuse;
varying vec3 v_Ambient;
varying vec3 v_Specular;
#endif

#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||AMBIENTMAP
uniform vec3 u_MaterialAmbient;
#endif

#ifdef FOG
varying float v_ToEyeLength;
#endif

#ifdef REFLECTMAP
varying vec3 v_ToEye;
varying vec3 v_Normal;
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
  vec3 normal=normalize( mat3(u_WorldMat*skinTransform)*a_Normal);
  #else
  vec3 normal=normalize( mat3(u_WorldMat)*a_Normal);
  #endif
 
  #ifdef REFLECTMAP
  v_Normal=normal;
  #endif
#endif
 

#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT
  v_Diffuse=vec3(0.0);
  v_Ambient=vec3(0.0);
  v_Specular=vec3(0.0);
  vec3 dif, amb, spe;
#endif


#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP
  #ifdef BONE
  vec3 positionWorld=(u_WorldMat*position).xyz;
  #else
  vec3 positionWorld=(u_WorldMat*a_Position).xyz;
  #endif
#endif

#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP
vec3 toEye;
  #ifdef FOG
  toEye=u_CameraPos-positionWorld;
  v_ToEyeLength=length(toEye);
  toEye/=v_ToEyeLength;
  #else
  toEye=normalize(u_CameraPos-positionWorld);
  #endif
 
  #ifdef REFLECTMAP
  v_ToEye=toEye;
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
  v_Texcoord0=mix(a_Texcoord0,a_TexcoordNext0,u_UVAge);
  #else
  v_Texcoord0=a_Texcoord0;
  #endif
  #ifdef UVTRANSFORM
  v_Texcoord0=(u_UVMatrix*vec4(v_Texcoord0,0.0,1.0)).xy;
  #endif
#endif

#ifdef AMBIENTMAP
v_Texcoord1=a_Texcoord1;
#endif
  
#ifdef COLOR
v_Color=a_Color;
#endif
}