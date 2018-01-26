attribute vec4 a_Position;
attribute vec4 a_Color;
attribute float a_Texcoord0X;
attribute float a_Texcoord0Y;

uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;

varying vec2 v_Texcoord0;
varying vec4 v_Color;

void main()
{
	gl_Position = u_PMatrix * u_VMatrix * a_Position;
	
	v_Texcoord0 = vec2(a_Texcoord0X, a_Texcoord0Y);
	
	v_Color = a_Color;
}
