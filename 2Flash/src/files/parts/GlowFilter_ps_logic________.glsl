
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