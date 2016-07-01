attribute vec4 a_Position;
uniform mat4 u_MvpMatrix;

#ifdef DIFFUSEMAP
attribute vec2 a_Texcoord0;
attribute vec2 a_Texcoord1;
varying vec2 v_Texcoord0;
varying vec2 v_Texcoord1;
#ifdef MIXUV
attribute vec2 a_TexcoordNext0;
attribute vec2 a_TexcoordNext1;
uniform float  u_UVAge;
#endif
#endif

#ifdef COLOR
attribute vec4 a_Color;
varying vec4 v_Color;
#endif


void main()
{
 gl_Position = u_MvpMatrix * a_Position;
 
 
 #ifdef DIFFUSEMAP
  #ifdef MIXUV
  v_Texcoord0=mix(a_Texcoord0,a_TexcoordNext0,u_UVAge);
   v_Texcoord1=mix(a_Texcoord1,a_TexcoordNext1,u_UVAge);
  #else
  v_Texcoord0=a_Texcoord0;
  v_Texcoord1=a_Texcoord1;
  #endif
 #endif
  
 #ifdef COLOR
 v_Color=a_Color;
 #endif
}