
uniform mat4 modelMatrix;
//uniform mat4 modelViewMatrix;
//uniform mat4 projectionMatrix;
uniform mat4 mvp;
//uniform mat4 viewMatrix;
uniform vec3 cameraPosition;

attribute vec3 position;
attribute vec3 normal;
attribute vec3 tangent;
attribute vec3 binormal;
attribute vec2 uv;

varying vec2 vUv;
varying vec3 vWorldNorm;
varying vec4 vViewPos;
varying vec4 vWorldPos;
varying vec3 vLightDir;
varying vec3 vViewDir;
varying vec3 vWorldTangent;
varying vec3 vWorldBinormal;

void main() {
    vUv = uv;
    vWorldPos = modelMatrix*vec4(position, 1.0);
    vWorldNorm =  (modelMatrix*vec4(normal,0.0)).xyz;
	vWorldTangent = (modelMatrix*vec4(tangent,0.0)).xyz;
	vWorldBinormal = (modelMatrix*vec4(binormal,0.0)).xyz;
    vViewDir = normalize(vWorldPos.xyz-cameraPosition);
    gl_Position = mvp*vec4(position, 1.0);
}
