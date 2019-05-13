#include "Lighting.glsl";

attribute vec4 a_Position;
#ifdef BONE
	attribute vec4 a_BoneIndices;
	attribute vec4 a_BoneWeights;
#endif

uniform mat4 u_MvpMatrix;
#ifdef BONE
	const int c_MaxBoneCount = 24;
	uniform mat4 u_Bones[c_MaxBoneCount];
#endif

void main() {
	#ifdef BONE
		mat4 skinTransform = u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;
		skinTransform += u_Bones[int(a_BoneIndices.y)] * a_BoneWeights.y;
		skinTransform += u_Bones[int(a_BoneIndices.z)] * a_BoneWeights.z;
		skinTransform += u_Bones[int(a_BoneIndices.w)] * a_BoneWeights.w;
		vec4 position=skinTransform*a_Position;
		gl_Position = u_MvpMatrix * position;
	#else
		gl_Position = u_MvpMatrix * a_Position;
	#endif
	gl_Position=remapGLPositionZ(gl_Position);
}