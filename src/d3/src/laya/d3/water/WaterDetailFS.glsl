precision highp float;
precision lowp int;

const float PI = 3.14159265358979323846264;
const float _2PI = 6.2831853071796;
varying vec2 vUv;
varying vec3 vWorldNorm;
varying vec3 vWorldTangent;
varying vec3 vWorldBinormal;

uniform float u_curTm;

#include "WaveFunction.glsl"

void main() {
	vec3 wave_N,wave_B,wave_T;
	calcWave(u_curTm, vUv,wave_B,wave_T,wave_N);
	gl_FragColor.rgb = normalize(wave_N)*0.5+vec3(0.5);// vec3(0.1,.4,0.1);
    gl_FragColor.a = 1.0;
}
