attribute vec4 a_Position;
uniform mat4 u_MvpMatrix;
varying vec3 v_Texcoord;


void main()
{
  gl_Position = (u_MvpMatrix*a_Position).xyww;
  v_Texcoord=a_Position.xyz;
}
