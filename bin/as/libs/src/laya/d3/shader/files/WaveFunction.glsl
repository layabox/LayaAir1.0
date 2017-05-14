
uniform vec2 u_WaveInfoD[20];
uniform vec4 u_WaveInfo[20];

uniform float TEXWAVE_UV_SCALE ;//= 20.0; //每texwidth像素代表的实际距离
/**
	这里的计算都是
*/

/**
* 计算一个波形
*  开始计算的时候都按照z向上，最后输出的时候，颠倒一下。
* @param tm {float} 毫秒
*/
void calcGerstnerWave(float curtm, vec3 pos, float deep, vec2 uvpos, out vec3 opos, out vec3 B, out vec3 T, out vec3 N, out float foamS){
	float tm = curtm/1000.;
	opos = pos;
	vec3 wpos=vec3(0.);		//累加的位置
	N=vec3(0.,0.,0.);	//输出的法线初始化一下
	T=vec3(0.,0.,0.);
	B=vec3(0.,0.,0.);
	vec2 cD ;//= D;
	//float deepAtt = max(0.,min(deep,1.0));
	//A*=deepAtt; //TODO
	
	for( int i=0; i<4; i++){
		cD = u_WaveInfoD[i];//vec2(wi.winfo[0],wi.winfo[1]);// wi.vDir;
		float Q = u_WaveInfo[i].x;//wi.QorK;
		float A = u_WaveInfo[i].y;//wi.A;
		float W = u_WaveInfo[i].z;//wi.omega;
		float P = u_WaveInfo[i].w;//wi.phi;
		float dop = dot(cD,uvpos);
		float c = cos(dop*W - tm*P);//TODO 优化
		float s = sin(dop*W - tm*P);
		float AWs = A*W*s;
		float AWc = A*W*c;
		float _QxyAWs = -Q*cD.x*cD.y*AWs;
		
		wpos += vec3(Q*A*cD.x*c,
					Q*A*cD.y*c,
					A*s);
		N += vec3(-cD.x*AWc,
				-cD.y*AWc,
				Q*AWs);//记得最后1-
		T += vec3(_QxyAWs,
				Q*cD.y*cD.y*AWs,//记得1-
				cD.y*AWc
			);
		B += vec3(Q*cD.x*cD.x*AWs,//记得1-
				_QxyAWs,
				cD.x*AWc
			);
		//float v1 = exp(-tan((dop*W - tm*P)/2.+1.07));//除2，+pi/2 这样正好能对齐
#ifdef USE_FOAM		
		float v1 = 0.5-sin((dop*W - tm*P)/1.+2.0)/2.;
		foamS += pow(v1,9.)/4.;
#endif
	}
	T.y=1.-T.y; B.x=1.-B.x;N.z=1.-N.z;
	opos += vec3(wpos.x,wpos.z*min(deep/10.,1.),wpos.y);
	//y和z交换一下。现在根据uv计算的位置，所以直接交换yz就行。其他情况下有问题么
	T.xyz=T.xzy;
	B.xyz=B.xzy;
	N.xyz=N.xzy;
}


void calcWave(float curtm, vec2 uv, out vec3 B, out vec3 T, out vec3 N){
	float tm = curtm/1000.;
	N=vec3(0.,0.,0.);	//输出的法线初始化一下
	vec2 uvpos = uv*TEXWAVE_UV_SCALE; //TODO 这个范围是什么 就是1？
	uvpos.y*=-1.;
	vec2 cD;// = D;
	const int NumWaves = 4;
	float scale = 1./float(NumWaves);
	for( int i=0; i<NumWaves; i++){
		cD = u_WaveInfoD[i];//vec2(wi.winfo[0],wi.winfo[1]);// wi.vDir;
		float k = 1.5;//u_WaveInfo[i].x;//wi.QorK; TODO  不知道为什么，这个取u_WaveInfo[i].x，在mi3w上就会闪。测试发现实际值也传过来了，就是1.5
		float A = u_WaveInfo[i].y;//wi.A;
		float W = u_WaveInfo[i].z;//wi.omega;
		float P = u_WaveInfo[i].w;//wi.phi;
		
		float dop = dot(cD,uvpos);
		float c = cos(dop*W - tm*P);//TODO 优化
		float s = sin(dop*W - tm*P);
		/*
		float AWs = A*W*s;
		float AWc = A*W*c;
		float _QxyAWs = -Q*cD.x*cD.y*AWs;
		
		N += vec3(-cD.x*AWc,
				-cD.y*AWc,
				Q*AWs);//记得最后1-
		*/
		float kWAc = scale*c;//k*W*A*c;  为了提高精度，这里只保留sin，cos部分，实际使用的时候再乘回来。
		//float kWAc = k*W*A*c;  
		N += vec3(
			-kWAc*cD.x*pow((s+1.)/2.,k-1.),
			-kWAc*cD.y*pow((s+1.)/2.,k-1.),
			1.
		);
	}
	//N.z=1.-N.z;
	//y和z交换一下。现在根据uv计算的位置，所以直接交换yz就行。其他情况下有问题么
	N.xyz=N.xzy;
}
