attribute vec4 a_Position;
attribute vec3 a_Normal;
attribute vec4 a_Tangent0;
attribute vec2 a_Texcoord0;

uniform mat4 u_MvpMatrix;
uniform mat4 u_WorldMat;
uniform vec3 u_CameraPos;

varying vec2 v_Texcoord0;
varying vec3 v_Normal;
varying vec3 v_Tangent;
varying vec3 v_Binormal;
varying vec3 v_ViewDir;
varying vec3 v_PositionWorld;

#ifdef TILINGOFFSET
	uniform vec4 u_TilingOffset;
#endif

varying float v_posViewZ;
#ifdef RECEIVESHADOW
  #ifdef SHADOWMAP_PSSM1 
	  varying vec4 v_lightMVPPos;
	  uniform mat4 u_lightShadowVP[4];
  #endif
#endif

#ifdef BONE
	const int c_MaxBoneCount = 24;
	attribute vec4 a_BoneIndices;
	attribute vec4 a_BoneWeights;
	uniform mat4 u_Bones[c_MaxBoneCount];
#endif

void main_castShadow()
{
	#ifdef BONE
		mat4 skinTransform=mat4(0.0);
		skinTransform += u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;
		skinTransform += u_Bones[int(a_BoneIndices.y)] * a_BoneWeights.y;
		skinTransform += u_Bones[int(a_BoneIndices.z)] * a_BoneWeights.z;
		skinTransform += u_Bones[int(a_BoneIndices.w)] * a_BoneWeights.w;
		vec4 position = skinTransform * a_Position;
		gl_Position = u_MvpMatrix * position;
	#else
		gl_Position = u_MvpMatrix * a_Position;
	#endif
	 
	//TODO没考虑UV动画呢
	#if defined(DIFFUSEMAP)&&defined(ALPHATEST)
		v_Texcoord0 = a_Texcoord0;
	#endif
		v_posViewZ = gl_Position.z;
}

void main_normal()
{
	mat3 worldMat;
	#ifdef BONE
		mat4 skinTransform = mat4(0.0);
		skinTransform += u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;
		skinTransform += u_Bones[int(a_BoneIndices.y)] * a_BoneWeights.y;
		skinTransform += u_Bones[int(a_BoneIndices.z)] * a_BoneWeights.z;
		skinTransform += u_Bones[int(a_BoneIndices.w)] * a_BoneWeights.w;
		vec4 position = skinTransform * a_Position;
		gl_Position = u_MvpMatrix * position;
		worldMat=mat3(u_WorldMat*skinTransform);
		v_PositionWorld = (u_WorldMat * position).xyz;
	#else
		gl_Position = u_MvpMatrix * a_Position;
		worldMat = mat3(u_WorldMat);
		v_PositionWorld = (u_WorldMat * a_Position).xyz;
	#endif
	
	v_Normal = worldMat * a_Normal;
	v_Tangent = worldMat * a_Tangent0.xyz;
	v_Binormal = cross(v_Normal, v_Tangent) * a_Tangent0.w;
  
	v_Texcoord0 = a_Texcoord0;
	#ifdef TILINGOFFSET
		v_Texcoord0=(vec2(v_Texcoord0.x,v_Texcoord0.y-1.0)*u_TilingOffset.xy)+u_TilingOffset.zw;
	#endif
		v_Texcoord0=vec2(v_Texcoord0.x,1.0 + v_Texcoord0.y);
  
	v_ViewDir = u_CameraPos - v_PositionWorld;
  
	#ifdef RECEIVESHADOW
		v_posViewZ = gl_Position.w;
		#ifdef SHADOWMAP_PSSM1 
			v_lightMVPPos = u_lightShadowVP[0] * vec4(v_PositionWorld,1.0);
		#endif
	#endif
}

void main()
{
	#ifdef CASTSHADOW
		main_castShadow();
	#else
		main_normal();
	#endif
}