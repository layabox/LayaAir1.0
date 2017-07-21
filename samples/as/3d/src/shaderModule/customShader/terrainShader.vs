attribute vec4 a_Position;
attribute vec2 a_Texcoord0;
attribute vec2 a_Texcoord1;

uniform mat4 u_MvpMatrix;
uniform mat4 u_WorldMat;
uniform vec4 u_lightmapScaleOffset;

attribute vec3 a_Normal;

varying vec3 v_Normal;

varying vec3 v_PositionWorld;

varying vec2 v_Texcoord0;
varying vec2 v_Texcoord1;

void main()
{
  gl_Position = u_MvpMatrix * a_Position;
  
  v_Normal = a_Normal;
  v_Texcoord0 = a_Texcoord0;
  v_PositionWorld = (u_WorldMat*a_Position).xyz;
  
  #ifdef CUSTOM_LIGHTMAP
	//v_Texcoord1 = a_Texcoord0  * u_lightmapScaleOffset.xy + u_lightmapScaleOffset.zw;
	v_Texcoord1 = vec2(a_Texcoord0.x*u_lightmapScaleOffset.x+u_lightmapScaleOffset.z,(a_Texcoord0.y-1.0)*u_lightmapScaleOffset.y+u_lightmapScaleOffset.w);
  #endif
}