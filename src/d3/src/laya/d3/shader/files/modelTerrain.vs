#include?VR "VRHelper.glsl";
attribute vec4 a_Position;
uniform mat4 u_MvpMatrix;
uniform mat4 u_UVMatrix;

#ifdef DIFFUSEMAP&&NORMALMAP&&SPECULARMAP&&EMISSIVEMAP&&AMBIENTMAP
attribute vec2 a_Texcoord;
varying vec2 v_Texcoord;
varying vec2 v_TiledTexcoord;
#endif

#ifdef FOG
uniform mat4 u_WorldMat;
varying vec3 v_PositionWorld;
#endif


void main()
{
 #ifdef VR
 gl_Position = DistortFishEye(u_MvpMatrix * a_Position);
 #else
 gl_Position = u_MvpMatrix * a_Position;
 #endif
 
 #ifdef FOG
 v_PositionWorld=(u_WorldMat*a_Position).xyz;
 #endif
 
 #ifdef DIFFUSEMAP&&NORMALMAP&&SPECULARMAP&&EMISSIVEMAP&&AMBIENTMAP
 v_Texcoord=a_Texcoord;
 v_TiledTexcoord=(u_UVMatrix*vec4(a_Texcoord,0.0,1.0)).xy;
 #endif
}