
uniform vec4 u_WaveInfo;	//x:Q,y:A,z:L,w:S
//const float u_waveQ = .2;
//float u_waveA = 1.2;
//const vec2 D = vec2(.707,.707);
const vec2 u_waveD = vec2(0.,1.);
//float u_waveL = .5; 
//float u_waveS = .6;
float u_waveDegOff[4];

/**
* 计算一个波形
* @param tm {float} 毫秒
*/
void calcGerstnerWave(float curtm, vec3 pos, float deep, vec2 uv, out vec3 opos, out vec3 B, out vec3 T, out vec3 N){
	u_waveDegOff[0]=PI/6.;
	u_waveDegOff[1]=-PI/6.;
	u_waveDegOff[2]=PI/4.;
	u_waveDegOff[3]=-PI/4.;
	float Q = u_WaveInfo.x;
	float A = u_WaveInfo.y;
	float L = u_WaveInfo.z;
	float S = u_WaveInfo.w;
	vec2 D = u_waveD;
	opos = pos;
	vec3 wpos=vec3(0.);
	vec3 wnorm = vec3(0.);
	N=vec3(0.,0.,0.);
	float tm = curtm/1000.;
	vec2 uvpos = uv*100.;
	vec2 cD = D;
	float deepAtt = max(0.1,min(deep,1.0));
	//A*=deepAtt; TODO
	for( int i=0; i<1; i++){
		
		float dop = dot(cD,uvpos);
		float omega = 0.80071*sqrt(L);
		float phi = S*2.0*PI/L;
		float c = cos(dop*omega + tm*phi);
		float s = sin(dop*omega + tm*phi);
		
		wpos += vec3(Q*A*cD.x*c,
					Q*A*cD.y*c,
					A*s);
		wnorm += vec3(-cD.x*A*omega*c,
					  -cD.y*A*omega*c,
					  1.-Q*A*omega*s);
		L/=1.2;
		S/=1.2;
		A/=1.2;
		float angoff = u_waveDegOff[i];
		mat2 matr = mat2(cos(angoff),-sin(angoff),sin(angoff),cos(angoff));
		cD = matr*D;
	}
	opos += vec3(wpos.x,wpos.z,wpos.y);
	N += vec3(wnorm.x, wnorm.z, wnorm.y);
}


void calcWave(float curtm, vec2 uv, out vec3 B, out vec3 T, out vec3 N){
	u_waveDegOff[0]=PI/6.;
	u_waveDegOff[1]=-PI/6.;
	u_waveDegOff[2]=PI/4.;
	u_waveDegOff[3]=-PI/4.;
	float Q = u_WaveInfo.x;
	float A = u_WaveInfo.y;
	float L = u_WaveInfo.z;
	float S = u_WaveInfo.w;
	vec2 D = u_waveD;

	vec3 wpos=vec3(0.);
	vec3 wnorm = vec3(0.);
	N=vec3(0.,0.,0.);
	float tm = curtm/1000.;
	vec2 uvpos = uv*10.;
	vec2 cD = D;
	for( int i=0; i<4; i++){
		
		float dop = dot(cD,uvpos);
		float omega = 0.80071*sqrt(L);
		float phi = S*2.0*PI/L;
		float c = cos(dop*omega + tm*phi);
		float s = sin(dop*omega + tm*phi);
		
		wpos += vec3(Q*A*cD.x*c,
					Q*A*cD.y*c,
					A*s);
		wnorm += vec3(-cD.x*A*omega*c,
					  -cD.y*A*omega*c,
					  1.-Q*A*omega*s);
		L/=1.2;
		S/=1.2;
		A/=1.2;
		float angoff = u_waveDegOff[i];
		mat2 matr = mat2(cos(angoff),-sin(angoff),sin(angoff),cos(angoff));
		cD = matr*D;
	}
	N += vec3(wnorm.x, wnorm.z, wnorm.y);
}
