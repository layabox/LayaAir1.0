#include "Lighting.glsl";

attribute vec4 a_Position;
attribute vec3 a_Normal;

uniform vec3 u_CameraPos;
uniform mat4 u_MvpMatrix;
uniform mat4 u_WorldMat;

varying vec3 v_PositionWorld;
varying vec3 v_ViewDir;
varying vec3 v_Normal;

void main()
{
	gl_Position = u_MvpMatrix * a_Position;
	
	v_PositionWorld = (u_WorldMat * a_Position).xyz;
	
	v_ViewDir = u_CameraPos - v_PositionWorld;
	v_Normal =  a_Normal * inverse(mat3(u_WorldMat));
	gl_Position=remapGLPositionZ(gl_Position);
}