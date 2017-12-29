struct DirectionLight
{
	vec3 Color;
	vec3 Direction;
};

vec3 UnpackScaleNormal(in vec2 uv0)
{
	#ifdef NORMALTEXTURE
		vec3 normalT;
		vec4 normalMapSample = texture2D(u_NormalTexture, uv0);
		normalT.x = 2.0 * normalMapSample.x - 1.0;
		normalT.y = 1.0 - 2.0 * normalMapSample.y;
		normalT.xy *= u_normalScale;
		normalT.z = sqrt(1.0 - clamp(dot(normalT.xy, normalT.xy), 0.0, 1.0));
		
		vec3 T = normalize(v_Tangent);
		vec3 B = normalize(v_Binormal);
		vec3 N = normalize(v_Normal);
		mat3 TBN = mat3(T, B, N);
		
		vec3 bumpedNormal = TBN * normalize(normalT);
		return bumpedNormal;
	#else
		return normalize(v_Normal);
	#endif
}

vec4 DielectricSpecularColor = vec4(0.220916301, 0.220916301, 0.220916301, 1.0 - 0.220916301);

float PI = 3.14159265359;

vec3 FresnelTerm (in vec3 F0, in float cosA)
{
	return F0 + (vec3(1.0) - F0) * pow(1.0 - cosA, 5.0);
}

float PerceptualRoughnessToRoughness(in float perceptualRoughness)
{
	return perceptualRoughness * perceptualRoughness;
}

float PerceptualRoughnessToSpecularPower(in float perceptualRoughness)
{
	float m = PerceptualRoughnessToRoughness(perceptualRoughness);
	float sq = max(0.0001, m * m);
	float n = (2.0 / sq) - 2.0;
	n = max(n, 0.0001);
	return n;
}

float RoughnessToPerceptualRoughness(in float roughness)
{
	return sqrt(roughness);
}

float SmoothnessToRoughness(in float smoothness)
{
	return (1.0 - smoothness) * (1.0 - smoothness);
}

float SmoothnessToPerceptualRoughness(in float smoothness)
{
	return (1.0 - smoothness);
}

vec3 SafeNormalize(in vec3 inVec)
{
	float dp3 = max(0.001,dot(inVec,inVec));
	return inVec * (1.0 / sqrt(dp3));
}

float DisneyDiffuse(in float NdotV, in float NdotL, in float LdotH, in float perceptualRoughness)
{
	float fd90 = 0.5 + 2.0 * LdotH * LdotH * perceptualRoughness;
	float lightScatter	= (1.0 + (fd90 - 1.0) * pow(1.0 - NdotL,5.0));
	float viewScatter	= (1.0 + (fd90 - 1.0) * pow(1.0 - NdotV,5.0));

	return lightScatter * viewScatter;
}

float SmithJointGGXVisibilityTerm (float NdotL, float NdotV, float roughness)
{
	float a = roughness;
	float lambdaV = NdotL * (NdotV * (1.0 - a) + a);
	float lambdaL = NdotV * (NdotL * (1.0 - a) + a);

	return 0.5 / (lambdaV + lambdaL + 0.00001);
}

float GGXTerm (float NdotH, float roughness)
{
	float a2 = roughness * roughness;
	float d = (NdotH * a2 - NdotH) * NdotH + 1.0;
	return 0.31830988618 * a2 / (d * d + 0.0000001);
}

vec4 LayaAirBRDF(in vec3 diffuseColor, in vec3 specularColor, in float oneMinusReflectivity, in float smoothness, in vec3 normal, in vec3 viewDir, in vec3 lightDir, in vec3 lightColor, in vec3 gi)
{
	float perceptualRoughness = SmoothnessToPerceptualRoughness(smoothness);
	vec3 halfDir = SafeNormalize(viewDir - lightDir);
	
	float nv = abs(dot(normal, viewDir));
	
	float nl = clamp(dot(normal,   -lightDir),  0.0, 1.0);
	float nh = clamp(dot(normal,     halfDir),  0.0, 1.0);
	float lv = clamp(dot(lightDir,   viewDir),  0.0, 1.0);
	float lh = clamp(dot(lightDir,  -halfDir),  0.0, 1.0);
	
	float diffuseTerm = DisneyDiffuse(nv, nl, lh, perceptualRoughness) * nl;
	
	float roughness = PerceptualRoughnessToRoughness(perceptualRoughness);
	
	//#if UNITY_BRDF_GGX
	float V = SmithJointGGXVisibilityTerm(nl, nv, roughness);
	float D = GGXTerm(nh, roughness);
	
	float specularTerm = V * D * PI;
	
	specularTerm = sqrt(max(0.0001, specularTerm));
	specularTerm = max(0.0, specularTerm * nl);
	
	vec4 color;
	color.rgb = diffuseColor * (gi + lightColor * diffuseTerm) + specularTerm * lightColor * FresnelTerm (specularColor, lh);
	
	color.a = 1.0;
	return color;
}

float OneMinusReflectivityFromMetallic(in float metallic)
{
	float oneMinusDielectricSpec = DielectricSpecularColor.a;
	return oneMinusDielectricSpec - metallic * oneMinusDielectricSpec;
}

vec3 DiffuseAndSpecularFromMetallic(in vec3 diffuseColor, in float metallic, out vec3 specularColor, out float oneMinusReflectivity)
{
	specularColor = mix(DielectricSpecularColor.rgb, diffuseColor, metallic);
	oneMinusReflectivity = OneMinusReflectivityFromMetallic(metallic);
	return diffuseColor * oneMinusReflectivity;
}

vec4 LayaAirPBRLight(in vec3 diffuseColor, in vec3 normal, in float metallic, in float smoothness, in vec3 viewDir, in vec3 lightDir, in vec3 lightColor, in vec3 gi)
{
	float oneMinusReflectivity;
	vec3 specularColor;
	diffuseColor = DiffuseAndSpecularFromMetallic (diffuseColor, metallic, specularColor, oneMinusReflectivity);
	
	vec4 color = LayaAirBRDF(diffuseColor, specularColor, oneMinusReflectivity, smoothness, normal, viewDir, lightDir, lightColor, gi);
	return color;
}

vec4 LayaAirPBRDiectionLight (in vec3 diffuseColor, in vec3 normal, in float metallic, in float smoothness, in vec3 viewDir, in DirectionLight light, in vec3 gi)
{
	vec3 lightVec = normalize(light.Direction);
	return LayaAirPBRLight(diffuseColor, normal, metallic, smoothness, viewDir, lightVec, light.Color, gi);
}

vec2 MetallicGloss(in vec4 diffuseTextureColor, in vec2 uv0)
{
	vec2 mg;
	
	#ifdef METALLICGLOSSTEXTURE
		vec4 metallicGlossTextureColor = texture2D(u_MetallicGlossTexture, uv0);
		#ifdef SMOOTHNESSSOURCE_DIFFUSETEXTURE_ALPHA
			mg.r = metallicGlossTextureColor.r;
			mg.g = diffuseTextureColor.a;
		#else
		    mg = metallicGlossTextureColor.ra;
		#endif
		mg.g *= u_smoothnessScale;
	#else
		mg.r = u_metallic;
		#ifdef SMOOTHNESSSOURCE_DIFFUSETEXTURE_ALPHA
			mg.g = diffuseTextureColor.a * u_smoothnessScale;
		#else
			mg.g = u_smoothness;
		#endif
	#endif
	
	return mg;
}

vec4 Occlusion(in vec2 uv0){
	#ifdef OCCLUSIONTEXTURE
		vec4 occlusionTextureColor = texture2D(u_OcclusionTexture, uv0);
		float occ = occlusionTextureColor.g;
		float oneMinusT = 1.0 - u_occlusionStrength;
		float lerpOneTo = oneMinusT + occ * u_occlusionStrength;
		return occlusionTextureColor * lerpOneTo;
	#else
		return vec4(1.0);
	#endif
}

vec2 ParallaxOffset(in vec3 viewDir){
	#ifdef PARALLAXTEXTURE
		float h = texture2D(u_ParallaxTexture, v_Texcoord0).g;
		h = h * u_parallaxScale - u_parallaxScale / 2.0;
		vec3 v = viewDir;
		v.z += 0.42;
		vec2 offset = h * (v.xy / v.z);
		return v_Texcoord0 + offset;
	#else
		return v_Texcoord0;
	#endif
}

