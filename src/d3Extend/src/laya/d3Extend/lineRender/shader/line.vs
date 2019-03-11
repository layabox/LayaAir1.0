attribute vec4 a_Position;
attribute vec2 a_Texcoord0;
attribute vec4 a_Color;

uniform mat4 u_MvpMatrix;
uniform mat4 u_WorldMat;

varying vec2 v_Texcoord0;
varying vec4 v_Color;

void main()
{
	v_Texcoord0 = a_Texcoord0;
	v_Color = a_Color;
	
	gl_Position = u_MvpMatrix * a_Position;
	
}