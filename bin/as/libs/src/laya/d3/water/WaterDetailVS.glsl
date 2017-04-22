
attribute vec3 a_position;
attribute vec3 a_normal;
attribute vec2 uv;

varying vec2 vUv;
varying vec3 vWorldNorm;
varying vec3 vWorldTangent;
varying vec3 vWorldBinormal;


void main() {
	vec3 pos = a_position;
	if(pos.z!=0.)pos.y=pos.z;
	pos.z=0.5;
	gl_Position = vec4(pos,1.);
    vUv = uv;
	//vWorldNorm = normalize((modelMat*vec4(a_normal,0.0)).xyz);
	//vWorldTangent = normalize((modelMat*vec4(tangent,0.0)).xyz);
	//vWorldBinormal = normalize((modelMat*vec4(binormal,0.0)).xyz);
}
