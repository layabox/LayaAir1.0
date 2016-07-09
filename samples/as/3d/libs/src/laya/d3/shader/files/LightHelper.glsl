
struct DirectionLight
{
 vec3 Direction;
 vec3 Diffuse;
 vec3 Ambient;
 vec3 Specular;
};

struct PointLight
{
 vec3 Diffuse;
 vec3 Ambient;
 vec3 Specular;
 vec3 Attenuation;
 vec3 Position;
 float Range;
};

struct SpotLight
{
 vec3 Diffuse;
 vec3 Ambient;
 vec3 Specular;
 vec3 Attenuation;
 vec3 Position;
 vec3 Direction;
 float Spot;
 float Range;
};


void  computeDirectionLight(in vec3 matDif,in vec3 matAmb,in vec4 matSpe,in DirectionLight dirLight,in vec3 normal,in vec3 toEye,out vec3 dif,out vec3 amb,out vec3 spec)
{
	dif=vec3(0.0);//不初始化在IOS中闪烁，PC中不会闪烁
	amb=vec3(0.0);
	spec=vec3(0.0);
	vec3 lightVec=-normalize(dirLight.Direction);
	
	amb=matAmb*dirLight.Ambient;
	
	float  diffuseFactor=dot(lightVec, normal);
	
	if(diffuseFactor>0.0)
	{
	   vec3 v = reflect(-lightVec, normal);
	   float specFactor = pow(max(dot(v, toEye), 0.0), matSpe.w);
	   
	   dif = diffuseFactor * matDif * dirLight.Diffuse;
	   spec = specFactor * matSpe.rgb * dirLight.Specular;
	}
	
}

void computePointLight(in vec3 matDif,in vec3 matAmb,in vec4 matSpe,in PointLight poiLight, in vec3 pos,in vec3 normal,in vec3 toEye,out vec3 dif,out vec3 amb,out vec3 spec)
{
	dif=vec3(0.0);
	amb=vec3(0.0);
	spec=vec3(0.0);
	vec3 lightVec = poiLight.Position - pos;
		
	float d = length(lightVec);
	
	if( d > poiLight.Range )
		return;
		
	lightVec /= d; 
	
	amb = matAmb * poiLight.Ambient;	

	float diffuseFactor = dot(lightVec, normal);

	if( diffuseFactor > 0.0 )
	{
		vec3 v= reflect(-lightVec, normal);
		float specFactor = pow(max(dot(v, toEye), 0.0), matSpe.w);
					
		dif = diffuseFactor * matDif * poiLight.Diffuse;
		spec = specFactor * matSpe.rgb * poiLight.Specular;
	}

	float attenuate = 1.0 / dot(poiLight.Attenuation, vec3(1.0, d, d*d));

	dif *= attenuate;
	spec*= attenuate;
}

void ComputeSpotLight(in vec3 matDif,in vec3 matAmb,in vec4 matSpe,in SpotLight spoLight,in vec3 pos, in vec3 normal,in vec3 toEye,out vec3 dif,out vec3 amb,out vec3 spec)
{
	amb = vec3(0.0);
	dif =vec3(0.0);
	spec= vec3(0.0);
	vec3 lightVec = spoLight.Position - pos;
		
	float d = length(lightVec);
	
	if( d > spoLight.Range)
		return;
		
	lightVec /= d; 
	
	amb = matAmb * spoLight.Ambient;	

	float diffuseFactor = dot(lightVec, normal);

	if(diffuseFactor > 0.0)
	{
		vec3 v= reflect(-lightVec, normal);
		float specFactor = pow(max(dot(v, toEye), 0.0), matSpe.w);
					
		dif = diffuseFactor * matDif * spoLight.Diffuse;
		spec = specFactor * matSpe.rgb * spoLight.Specular;
	}
	
	float spot = pow(max(dot(-lightVec, normalize(spoLight.Direction)), 0.0), spoLight.Spot);

	float attenuate = spot/dot(spoLight.Attenuation, vec3(1.0, d, d*d));

	amb *= spot;
	dif *= attenuate;
	spec*= attenuate;
}

vec3 NormalSampleToWorldSpace(vec3 normalMapSample, vec3 unitNormal, vec3 tangent)
{
	vec3 normalT = 2.0*normalMapSample - 1.0;

	// Build orthonormal basis.
	vec3 N = normalize(unitNormal);
	vec3 T = normalize( tangent- dot(tangent, N)*N);
	vec3 B = cross(T, N);

	mat3 TBN = mat3(T, B, N);

	// Transform from tangent space to world space.
	vec3 bumpedNormal = TBN*normalT;

	return bumpedNormal;
}
