
struct DirectionLight
{
	vec3 Color;
	vec3 Direction;
};

struct PointLight
{
	vec3 Color;
	vec3 Position;
	float Range;
};

struct SpotLight
{
	vec3 Color;
	vec3 Position;
	vec3 Direction;
	float Spot;
	float Range;
};

// U3D中使用衰减纹理,此函数模拟并非正确
//float U3DAttenuation(in vec3 L,in float invLightRadius)
//{
//	float fRatio = clamp(length(L) * invLightRadius,0.0,1.0);
//	fRatio *= fRatio;
//	return 1.0 / (1.0 + 25.0 * fRatio)* clamp(4.0*(1.0 - fRatio),0.0,1.0); //fade to black as if 4 pixel texture
//} 

// Same as Just Cause 2 and Crysis 2 (you can read GPU Pro 1 book for more information)
float BasicAttenuation(in vec3 L,in float invLightRadius)
{
	vec3 distance = L * invLightRadius;
	float attenuation = clamp(1.0 - dot(distance, distance),0.0,1.0); // Equals float attenuation = saturate(1.0f - dot(L, L) / (lightRadius *  lightRadius)); 	
	return attenuation * attenuation;
} 

// Inspired on http://fools.slindev.com/viewtopic.php?f=11&t=21&view=unread#unread	
float NaturalAttenuation(in vec3 L,in float invLightRadius)
{
	float attenuationFactor = 30.0;
	vec3 distance = L * invLightRadius;
	float attenuation = dot(distance, distance); // Equals float attenuation = dot(L, L) / (lightRadius *  lightRadius);
	attenuation = 1.0 / (attenuation * attenuationFactor + 1.0);
	// Second we move down the function therewith it reaches zero at abscissa 1:
	attenuationFactor = 1.0 / (attenuationFactor + 1.0); //attenuationFactor contains now the value we have to subtract
	attenuation = max(attenuation - attenuationFactor, 0.0); // The max fixes a bug.
	// Finally we expand the equation along the y-axis so that it starts with a function value of 1 again.
	attenuation /= 1.0 - attenuationFactor;
	return attenuation;
} 

void LayaAirBlinnPhongLight (in vec3 specColor,in float specColorIntensity,in vec3 normal,in vec3 gloss, in vec3 viewDir,in vec3 lightColor, in vec3 lightVec,out vec3 diffuseColor,out vec3 specularColor)
{
    mediump vec3 h = normalize(viewDir-lightVec);
    lowp float ln = max (0.0, dot (-lightVec,normal));
    float nh = max (0.0, dot (h,normal));
	diffuseColor=lightColor * ln;
	specularColor=lightColor *specColor*pow (nh, specColorIntensity*128.0) * gloss;
}

void LayaAirBlinnPhongDiectionLight (in vec3 specColor,in float specColorIntensity,in vec3 normal,in vec3 gloss, in vec3 viewDir, in DirectionLight light,out vec3 diffuseColor,out vec3 specularColor)
{
	vec3 lightVec=normalize(light.Direction);
	LayaAirBlinnPhongLight(specColor,specColorIntensity,normal,gloss,viewDir,light.Color,lightVec,diffuseColor,specularColor);
}

void LayaAirBlinnPhongPointLight (in vec3 pos,in vec3 specColor,in float specColorIntensity,in vec3 normal,in vec3 gloss, in vec3 viewDir, in PointLight light,out vec3 diffuseColor,out vec3 specularColor)
{
	vec3 lightVec =  pos-light.Position;
	//if( length(lightVec) > light.Range )
	//	return;
	LayaAirBlinnPhongLight(specColor,specColorIntensity,normal,gloss,viewDir,light.Color,lightVec/length(lightVec),diffuseColor,specularColor);
	float attenuate = BasicAttenuation(lightVec, 1.0/light.Range);
	diffuseColor *= attenuate;
	specularColor*= attenuate;
}

void LayaAirBlinnPhongSpotLight (in vec3 pos,in vec3 specColor,in float specColorIntensity,in vec3 normal,in vec3 gloss, in vec3 viewDir, in SpotLight light,out vec3 diffuseColor,out vec3 specularColor)
{
	vec3 lightVec =  pos-light.Position;
	//if( length(lightVec) > light.Range )
	//	return;
	vec3 normalLightVec=lightVec/length(lightVec);
	LayaAirBlinnPhongLight(specColor,specColorIntensity,normal,gloss,viewDir,light.Color,normalLightVec,diffuseColor,specularColor);
	float spot = pow(max(dot(normalLightVec, normalize(light.Direction)), 0.0), light.Spot);
	float attenuate = spot*BasicAttenuation(lightVec, 1.0/light.Range);
	diffuseColor *= attenuate;
	specularColor*= attenuate;
}

vec3 NormalSampleToWorldSpace(vec3 normalMapSample, vec3 unitNormal, vec3 tangent,vec3 binormal)
{
	vec3 normalT =vec3(2.0*normalMapSample.x - 1.0,1.0-2.0*normalMapSample.y,2.0*normalMapSample.z - 1.0);
	
	// Build orthonormal basis.
	vec3 N = normalize(unitNormal);
	vec3 T = normalize(tangent);
	vec3 B = normalize(binormal);
	mat3 TBN = mat3(T, B, N);
	
	// Transform from tangent space to world space.
	vec3 bumpedNormal = TBN*normalT;

	return bumpedNormal;
}


