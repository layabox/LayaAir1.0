attribute vec4 a_Position;
attribute vec2 a_Texcoord;

uniform mat4 u_MvpMatrix;
uniform mat4 u_WorldMat;

varying vec2 v_Texcoord;

attribute vec3 a_Normal;
varying vec3 v_Normal;

void main()
{
  gl_Position = u_MvpMatrix * a_Position;
  v_Texcoord=a_Texcoord;
  
 mat3 worldMat=mat3(u_WorldMat);
 v_Normal=worldMat*a_Normal;
}