#include "PBRUtils.glsl"
#include "BRDF.glsl"

vec4 PBRSpecularLight(in vec3 diffuseColor, in vec3 specularColor, in float smoothness, in vec3 normal, in vec3 viewDir, in vec3 lightDir, in vec3 lightColor, in vec3 gi)
{
	float oneMinusReflectivity;
	diffuseColor = EnergyConservationBetweenDiffuseAndSpecular (diffuseColor, specularColor, oneMinusReflectivity);
	
	vec4 color = LayaAirBRDF(diffuseColor, specularColor, oneMinusReflectivity, smoothness, normal, viewDir, lightDir, lightColor, gi);
	return color;
}

vec4 PBRSpecularDiectionLight (in vec3 diffuseColor, in vec3 specularColor, in float smoothness, in vec3 normal, in vec3 viewDir, in DirectionLight light, in vec3 gi)
{
	vec3 lightVec = normalize(light.Direction);
	return PBRSpecularLight(diffuseColor, specularColor, smoothness, normal, viewDir, lightVec, light.Color, gi);
}

vec4 SpecularGloss(float diffuseTextureAlpha, in vec2 uv0)
{
    vec4 sg;
	
	#ifdef SPECULARTEXTURE
		vec4 specularTextureColor = texture2D(u_SpecularTexture, uv0);
		#ifdef SMOOTHNESSSOURCE_DIFFUSETEXTURE_ALPHA
			sg.rgb = specularTextureColor.rgb;
			sg.a = diffuseTextureAlpha;
		#else
			sg = specularTextureColor;
		#endif
		sg.a *= u_smoothnessScale;
	#else
		sg.rgb = u_SpecularColor.rgb;
		#ifdef SMOOTHNESSSOURCE_DIFFUSETEXTURE_ALPHA
			sg.a = diffuseTextureAlpha * u_smoothnessScale;
		#else
			sg.a = u_smoothness;
		#endif
	#endif
	
    return sg;
}

