attribute vec3 a_Position;
attribute vec3 a_OffsetVector;
attribute vec4 a_Color;
attribute float a_Texcoord0X;
attribute float a_Texcoord0Y;
attribute float a_BirthTime;

uniform mat4 u_VMatrix;
uniform mat4 u_PMatrix;

uniform vec4 u_TilingOffset;

uniform float u_CurTime;
uniform float u_LifeTime;
uniform vec4 u_WidthCurve[10];
uniform int u_WidthCurveKeyLength;

uniform vec4 u_GradientColorkey[10];
uniform vec2 u_GradientAlphakey[10];

varying vec2 v_Texcoord0;
varying vec4 v_Color;

float hermiteInterpolate(float t, float outTangent, float inTangent, float duration, float value1, float value2)
{
	float t2 = t * t;
	float t3 = t2 * t;
	float a = 2.0 * t3 - 3.0 * t2 + 1.0;
	float b = t3 - 2.0 * t2 + t;
	float c = t3 - t2;
	float d = -2.0 * t3 + 3.0 * t2;
	return a * value1 + b * outTangent * duration + c * inTangent * duration + d * value2;
}

float getCurWidth(in float normalizeTime)
{
	if(normalizeTime == 0.0){
		return u_WidthCurve[0].w;
	}
	else if(normalizeTime >= 1.0){
		return u_WidthCurve[u_WidthCurveKeyLength - 1].w;
	}
	else{
		for(int i = 0; i < 10; i ++ )
		{
			if(normalizeTime == u_WidthCurve[i].x)
			{
				return u_WidthCurve[i].w;
			}
			
			vec4 lastFrame = u_WidthCurve[i];
			vec4 nextFrame = u_WidthCurve[i + 1];
			if(normalizeTime > lastFrame.x && normalizeTime < nextFrame.x)
			{
				float duration = nextFrame.x - lastFrame.x;
				float t = (normalizeTime - lastFrame.x) / duration;
				float outTangent = lastFrame.z;
				float inTangent = nextFrame.y;
				float value1 = lastFrame.w;
				float value2 = nextFrame.w;
				return hermiteInterpolate(t, outTangent, inTangent, duration, value1, value2);
			}
		}	
	}
}	

vec4 getColorFromGradientByBlend(in vec4 gradientColors[10], in vec2 gradientAlphas[10], in float normalizeTime)
{
	vec4 color;
	for(int i = 1; i < 10; i++)
	{
		vec4 gradientColor = gradientColors[i];
		float colorKey = gradientColor.w;
		if(colorKey >= normalizeTime)
		{
			vec4 lastGradientColor = gradientColors[i-1];
			float lastColorKey = lastGradientColor.w;
			float age = (normalizeTime - lastColorKey) / (colorKey - lastColorKey);
			color.rgb = mix(gradientColors[i-1].xyz, gradientColor.xyz, age);
			break;
		}
	}
	for(int i = 1; i < 10; i++)
	{
		vec2 gradientAlpha = gradientAlphas[i];
		float alphaKey = gradientAlpha.y;
		if(alphaKey >= normalizeTime)
		{
			vec2 lastGradientAlpha = gradientAlphas[i-1];
			float lastAlphaKey = lastGradientAlpha.y;
			float age = (normalizeTime - lastAlphaKey) / (alphaKey - lastAlphaKey);
			color.a = mix(lastGradientAlpha.x, gradientAlpha.x, age);
			break;
		}
	}
	return color;
}

vec4 getColorFromGradientByFixed(in vec4 gradientColors[10], in vec2 gradientAlphas[10], in float normalizeTime)
{
	vec4 color;
	for(int i = 1; i < 10; i++)
	{
		vec4 gradientColor = gradientColors[i];
		if(gradientColor.w >= normalizeTime)
		{
			color.rgb = gradientColor.xyz;
			break;
		}
	}
	for(int i = 1; i < 10; i++)
	{
		vec2 gradientAlpha = gradientAlphas[i];
		if(gradientAlpha.y >= normalizeTime)
		{
			color.a = gradientAlpha.x;
			break;
		}
	}
	return color;
}

void main()
{
	float normalizeTime = (u_CurTime - a_BirthTime) / u_LifeTime;
	
	gl_Position = u_PMatrix * u_VMatrix * vec4(a_Position + a_OffsetVector * getCurWidth(normalizeTime),1.0);
	
	v_Texcoord0 = vec2(a_Texcoord0X, a_Texcoord0Y);
	
	#ifdef TILINGOFFSET
		v_Texcoord0 = (vec2(v_Texcoord0.x, v_Texcoord0.y) * u_TilingOffset.xy) + u_TilingOffset.zw;
	#endif
		v_Texcoord0 = vec2(v_Texcoord0.x, v_Texcoord0.y);
		
	v_Texcoord0 = (vec2(v_Texcoord0.x, v_Texcoord0.y) * u_TilingOffset.xy) + u_TilingOffset.zw;
	
	#ifdef GRADIENTMODE_BLEND
		v_Color = getColorFromGradientByBlend(u_GradientColorkey, u_GradientAlphakey, normalizeTime);
	#else
		v_Color = getColorFromGradientByFixed(u_GradientColorkey, u_GradientAlphakey, normalizeTime);
	#endif
}



