attribute vec4 a_Position;
attribute vec4 a_Color;

uniform mat4 u_MvpMatrix;

varying vec4 v_Color;

varying float depthValue;

void main()
{
	gl_Position = u_MvpMatrix * a_Position;
	
	vec4 position = u_MvpMatrix * vec4(0.0,0.0,0.0,1.0);
	
	depthValue = (position.z / position.w) / 2.0 + 0.5;
	
	v_Color = a_Color;
}