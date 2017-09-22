const float c_IterationTime = 10.0;
float floatIterationTotalTime = c_IterationTime * c_IterationTime;
vec4 vec4Color = vec4(0.0,0.0,0.0,0.0);
vec2 vec2FilterDir = vec2(-(u_offsetX)/u_textW,-(u_offsetY)/u_textH);
vec2 vec2FilterOff = vec2(u_blurX/u_textW/c_IterationTime * 2.0,u_blurY/u_textH/c_IterationTime * 2.0);
float maxNum = u_blurX * u_blurY;
vec2 vec2Off = vec2(0.0,0.0);
float floatOff = c_IterationTime/2.0;
for(float i = 0.0;i<=c_IterationTime; ++i){
	for(float j = 0.0;j<=c_IterationTime; ++j){
		vec2Off = vec2(vec2FilterOff.x * (i - floatOff),vec2FilterOff.y * (j - floatOff));
		vec4Color += texture2D(texture, v_texcoord + vec2FilterDir + vec2Off)/floatIterationTotalTime;
	}
}
gl_FragColor = vec4(u_color.rgb,vec4Color.a * u_strength);
gl_FragColor.rgb *= gl_FragColor.a;