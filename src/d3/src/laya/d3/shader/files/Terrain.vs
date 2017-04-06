attribute vec4 a_Position;

#if defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT)
	attribute vec3 a_Normal;
	varying vec3 v_Normal;
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


attribute vec2 a_Texcoord0;
attribute vec2 a_Texcoord1;
varying vec2 v_Texcoord0;
varying vec2 v_Texcoord1;
uniform mat4 u_MvpMatrix;

void main()
{
	gl_Position = u_MvpMatrix * a_Position;
	v_Texcoord0=a_Texcoord0;
	v_Texcoord1=a_Texcoord1;
	
#if defined(DIRECTIONLIGHT)||defined(POINTLIGHT)||defined(SPOTLIGHT)
	v_PositionWorld=(u_WorldMat*a_Position).xyz;
	v_Normal=a_Normal;
#endif
	
#ifdef RECEIVESHADOW
	v_posViewZ = gl_Position.w;
	#ifdef SHADOWMAP_PSSM1 
		v_lightMVPPos = u_lightShadowVP[0] * vec4(v_PositionWorld,1.0);
	#endif
#endif

}