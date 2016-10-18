attribute vec4 a_Position;
attribute vec2 a_Texcoord;

uniform mat4 u_MvpMatrix;

varying vec2 v_Texcoord;


void main()
{
  gl_Position = u_MvpMatrix * a_Position;
  v_Texcoord=a_Texcoord;
}