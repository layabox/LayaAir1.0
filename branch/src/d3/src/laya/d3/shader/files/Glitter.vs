attribute vec4 a_Position;
attribute vec2 a_Texcoord0;
attribute float a_Time;

uniform mat4 u_MvpMatrix;
uniform  float u_CurrentTime;
uniform  vec4 u_Color;
uniform float u_Duration;

varying vec2 v_Texcoord;
varying vec4 v_Color;


void main()
{
  gl_Position = u_MvpMatrix * a_Position;
  
  float age = u_CurrentTime-a_Time;
  float normalizedAge = clamp(age / u_Duration,0.0,1.0);
   
  v_Texcoord=a_Texcoord0;
  
  v_Color=u_Color;
  v_Color.a*=1.0-normalizedAge;
}
