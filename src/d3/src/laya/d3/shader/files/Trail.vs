#include "Lighting.glsl";

attribute vec3 a_Position;
attribute vec3 a_OffsetVector;
attribute vec4 a_Color;
attribute float a_Texcoord0X;
attribute float a_Texcoord0Y;
attribute float a_BirthTime;

uniform mat4 u_View;
uniform mat4 u_Projection;

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
	float width;
	if(normalizeTime == 0.0){
		width=u_WidthCurve[0].w;
	}
	else if(normalizeTime >= 1.0){
		width=u_WidthCurve[u_WidthCurveKeyLength - 1].w;
	}
	else{
		for(int i = 0; i < 10; i ++ )
		{
			if(normalizeTime == u_WidthCurve[i].x){
				width=u_WidthCurve[i].w;
				break;
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
				width=hermiteInterpolate(t, outTangent, inTangent, duration, value1, value2);
				break;
			}
		}
	}
	return width;
}	

vec4 getColorFromGradientByBlend(in vec4 gradientColors[10], in vec2 gradientAlphas[10], in float normalizeTime)
{
	vec4 color;
	for(int i = 1; i < 10; i++)
	{
		vec4 gradientColor = gradientColors[i];
		float colorKey = gradientColor.x;
		if(colorKey >= normalizeTime)
		{
			vec4 lastGradientColor = gradientColors[i-1];
			float lastColorKey = lastGradientColor.x;
			float age = (normalizeTime - lastColorKey) / (colorKey - lastColorKey);
			color.rgb = mix(gradientColors[i-1].yzw, gradientColor.yzw, age);
			break;
		}
	}
	for(int i = 1; i < 10; i++)
	{
		vec2 gradientAlpha = gradientAlphas[i];
		float alphaKey = gradientAlpha.x;
		if(alphaKey >= normalizeTime)
		{
			vec2 lastGradientAlpha = gradientAlphas[i-1];
			float lastAlphaKey = lastGradientAlpha.x;
			float age = (normalizeTime - lastAlphaKey) / (alphaKey - lastAlphaKey);
			color.a = mix(lastGradientAlpha.y, gradientAlpha.y, age);
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
	
	#ifdef TILINGOFFSET
		v_Texcoord0 = vec2(a_Texcoord0X, 1.0 - a_Texcoord0Y) * u_TilingOffset.xy + u_TilingOffset.zw;
	#else
		v_Texcoord0 = vec2(a_Texcoord0X, a_Texcoord0Y);
	#endif
	
	#ifdef GRADIENTMODE_BLEND
		v_Color = getColorFromGradientByBlend(u_GradientColorkey, u_GradientAlphakey, normalizeTime);
	#else
		v_Color = getColorFromGradientByFixed(u_GradientColorkey, u_GradientAlphakey, normalizeTime);
	#endif
	
	gl_Position = u_Projection * u_View * vec4(a_Position + a_OffsetVector * getCurWidth(normalizeTime),1.0);
	gl_Position=remapGLPositionZ(gl_Position);
}
