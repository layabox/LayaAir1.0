precision mediump float;
const int c_FilterTime = 9;
const float c_Gene = (1.0/(1.0 + 2.0*(0.93 + 0.8 + 0.7 + 0.6 + 0.5 + 0.4 + 0.3 + 0.2 + 0.1)));
uniform sampler2D texture;
const bool u_FiterMode=true;
const float u_GlowGene=1.5;
const vec4 u_GlowColor=vec4(1.0,0.0,0.0,0.5);
const float u_FilterOffset=2.0;
const float u_TexSpaceU=1.0/10.0;
const float u_TexSpaceV=1.0/10.0;
varying vec2 v_texcoord;
void main()
{
	float aryAttenuation[c_FilterTime];
	aryAttenuation[0] = 0.93;
	aryAttenuation[1] = 0.8;
	aryAttenuation[2] = 0.7;
	aryAttenuation[3] = 0.6;
	aryAttenuation[4] = 0.5;
	aryAttenuation[5] = 0.4;
	aryAttenuation[6] = 0.3;
	aryAttenuation[7] = 0.2;
	aryAttenuation[8] = 0.1;
	vec4 vec4Color = texture2D(texture, v_texcoord)*c_Gene;
	vec2 vec2FilterDir;
	if(u_FiterMode)
	  vec2FilterDir = vec2(u_FilterOffset*u_TexSpaceU/9.0, 0.0);
	else
		vec2FilterDir =  vec2(0.0, u_FilterOffset*u_TexSpaceV/9.0);
	vec2 vec2Step = vec2FilterDir;
	for(int i = 0;i< c_FilterTime; ++i){
		vec4Color += texture2D(texture, v_texcoord + vec2Step)*aryAttenuation[i]*c_Gene;
		vec4Color += texture2D(texture, v_texcoord - vec2Step)*aryAttenuation[i]*c_Gene;
		vec2Step += vec2FilterDir;
	}
	if(u_FiterMode)
		gl_FragColor = vec4Color.a*u_GlowColor*u_GlowGene;
	else
		gl_FragColor = vec4Color.a*u_GlowColor;
}