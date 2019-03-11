#include "Lighting.glsl";

attribute vec4 a_Position;
attribute vec4 a_Color;
attribute vec2 a_Texcoord0;

uniform mat4 u_MvpMatrix;

varying vec4 v_Color;
varying vec2 v_Texcoord0;

#ifdef TILINGOFFSET
	uniform vec4 u_TilingOffset;
#endif

#ifdef BONE
	const int c_MaxBoneCount = 24;
	attribute vec4 a_BoneIndices;
	attribute vec4 a_BoneWeights;
	uniform mat4 u_Bones[c_MaxBoneCount];
#endif

void main()
{
	#ifdef BONE
		mat4 skinTransform = mat4(0.0);
		skinTransform += u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;
		skinTransform += u_Bones[int(a_BoneIndices.y)] * a_BoneWeights.y;
		skinTransform += u_Bones[int(a_BoneIndices.z)] * a_BoneWeights.z;
		skinTransform += u_Bones[int(a_BoneIndices.w)] * a_BoneWeights.w;
		vec4 position = skinTransform * a_Position;
		gl_Position = u_MvpMatrix * position;
	#else
		gl_Position = u_MvpMatrix * a_Position;
	#endif
	
	v_Texcoord0 = a_Texcoord0;
	#ifdef TILINGOFFSET
		v_Texcoord0=TransformUV(v_Texcoord0,u_TilingOffset);
	#endif
		
	v_Color = a_Color;
}