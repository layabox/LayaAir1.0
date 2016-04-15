const int c_FilterTime = 9;
const float c_Gene = (1.0/(1.0 + 2.0*(0.93 + 0.8 + 0.7 + 0.6 + 0.5 + 0.4 + 0.3 + 0.2 + 0.1)));
vec4 vec4Color = gl_FragColor*c_Gene;
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

float u_TexSpaceU=1.0/u_texW;
float u_TexSpaceV=1.0/u_texH;
vec2 vec2FilterDir;
if(u_blurX)
	vec2FilterDir = vec2(u_offset*u_TexSpaceU/9.0, 0.0);
else
	vec2FilterDir = vec2(0.0,u_offset*u_TexSpaceV/9.0);
vec2 vec2Step = vec2FilterDir;

for(int i = 0;i< c_FilterTime; ++i){
	vec4Color += texture2D(texture, v_texcoord + vec2Step)*aryAttenuation[i]*c_Gene;
	vec4Color += texture2D(texture, v_texcoord - vec2Step)*aryAttenuation[i]*c_Gene;
	vec2Step += vec2FilterDir;
}

gl_FragColor = vec4Color.a*u_color*u_strength;