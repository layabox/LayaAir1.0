#include "PBRUtils.glsl"
#include "BRDF.glsl"

vec4 PBRStandardLight(in vec3 diffuseColor, in float metallic, in float smoothness, in vec3 normal, in vec3 viewDir, in vec3 lightDir, in vec3 lightColor, in vec3 gi)
{
	float oneMinusReflectivity;
	vec3 specularColor;
	diffuseColor = DiffuseAndSpecularFromMetallic (diffuseColor, metallic, specularColor, oneMinusReflectivity);
	
	vec4 color = LayaAirBRDF(diffuseColor, specularColor, oneMinusReflectivity, smoothness, normal, viewDir, lightDir, lightColor, gi);
	return color;
}

vec4 PBRStandardDiectionLight (in vec3 diffuseColor, in float metallic, in float smoothness, in vec3 normal, in vec3 viewDir, in DirectionLight light, in vec3 gi)
{
	vec3 lightVec = normalize(light.Direction);
	return PBRStandardLight(diffuseColor, metallic, smoothness, normal, viewDir, lightVec, light.Color, gi);
}

vec2 MetallicGloss(in float diffuseTextureAlpha, in vec2 uv0)
{
	vec2 mg;
	
	#ifdef METALLICGLOSSTEXTURE
		vec4 metallicGlossTextureColor = texture2D(u_MetallicGlossTexture, uv0);
		#ifdef SMOOTHNESSSOURCE_DIFFUSETEXTURE_ALPHA
			mg.r = metallicGlossTextureColor.r;
			mg.g = diffuseTextureAlpha;
		#else
		    mg = metallicGlossTextureColor.ra;
		#endif
		mg.g *= u_smoothnessScale;
	#else
		mg.r = u_metallic;
		#ifdef SMOOTHNESSSOURCE_DIFFUSETEXTURE_ALPHA
			mg.g = diffuseTextureAlpha * u_smoothnessScale;
		#else
			mg.g = u_smoothness;
		#endif
	#endif
	
	return mg;
}

