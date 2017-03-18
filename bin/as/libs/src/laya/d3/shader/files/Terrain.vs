attribute vec4 a_Position;
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
}