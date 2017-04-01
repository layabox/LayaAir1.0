attribute vec4 a_CornerTextureCoordinate;
attribute vec4 a_PositionStartLifeTime;
attribute vec4 a_DirectionTime;
attribute vec4 a_StartColor;
attribute vec3 a_StartSize;
attribute vec3 a_StartRotation0;
attribute vec3 a_StartRotation1;
attribute vec3 a_StartRotation2;
attribute float a_StartSpeed;
#ifdef defined(COLOROVERLIFETIME)||defined(RANDOMCOLOROVERLIFETIME)||defined(SIZEOVERLIFETIMERANDOMCURVES)||definedSIZEOVERLIFETIMERANDOMCURVESSEPERATE||defined(ROTATIONOVERLIFETIMERANDOMCONSTANTS)||defined(ROTATIONOVERLIFETIMERANDOMCURVES)
  attribute vec4 a_Random0;
#endif
#ifdef TEXTURESHEETANIMATIONRANDOMCURVE||defined(VELOCITYOVERLIFETIMERANDOMCONSTANT)||defined(VELOCITYOVERLIFETIMERANDOMCURVE)
  attribute vec4 a_Random1;
#endif
attribute vec3 a_SimulationWorldPostion;

varying float v_Discard;
varying vec4 v_Color;
varying vec2 v_TextureCoordinate;

uniform float u_CurrentTime;
uniform vec3 u_Gravity;

uniform vec3 u_WorldPosition;
uniform mat4 u_WorldRotationMat;
uniform bool u_ThreeDStartRotation;
uniform int u_ScalingMode;
uniform vec3 u_PositionScale;
uniform vec3 u_SizeScale;
uniform mat4 u_View;
uniform mat4 u_Projection;

uniform vec3 u_CameraDirection;//TODO:只有几种广告牌模式需要用
uniform vec3 u_CameraUp;

uniform  float u_StretchedBillboardLengthScale;
uniform  float u_StretchedBillboardSpeedScale;
uniform int u_SimulationSpace;

#ifdef defined(VELOCITYOVERLIFETIMECONSTANT)||defined(VELOCITYOVERLIFETIMECURVE)||defined(VELOCITYOVERLIFETIMERANDOMCONSTANT)||defined(VELOCITYOVERLIFETIMERANDOMCURVE)
  uniform  int  u_VOLSpaceType;
#endif
#ifdef defined(VELOCITYOVERLIFETIMECONSTANT)||defined(VELOCITYOVERLIFETIMERANDOMCONSTANT)
  uniform  vec3 u_VOLVelocityConst;
#endif
#ifdef defined(VELOCITYOVERLIFETIMECURVE)||defined(VELOCITYOVERLIFETIMERANDOMCURVE)
  uniform  vec2 u_VOLVelocityGradientX[4];//x为key,y为速度
  uniform  vec2 u_VOLVelocityGradientY[4];//x为key,y为速度
  uniform  vec2 u_VOLVelocityGradientZ[4];//x为key,y为速度
#endif
#ifdef VELOCITYOVERLIFETIMERANDOMCONSTANT
  uniform  vec3 u_VOLVelocityConstMax;
#endif
#ifdef VELOCITYOVERLIFETIMERANDOMCURVE
  uniform  vec2 u_VOLVelocityGradientMaxX[4];//x为key,y为速度
  uniform  vec2 u_VOLVelocityGradientMaxY[4];//x为key,y为速度
  uniform  vec2 u_VOLVelocityGradientMaxZ[4];//x为key,y为速度
#endif

#ifdef COLOROVERLIFETIME
  uniform  vec4 u_ColorOverLifeGradientColors[4];//x为key,yzw为Color
  uniform  vec2 u_ColorOverLifeGradientAlphas[4];//x为key,y为Alpha
#endif
#ifdef RANDOMCOLOROVERLIFETIME
  uniform  vec4 u_ColorOverLifeGradientColors[4];//x为key,yzw为Color
  uniform  vec2 u_ColorOverLifeGradientAlphas[4];//x为key,y为Alpha
  uniform  vec4 u_MaxColorOverLifeGradientColors[4];//x为key,yzw为Color
  uniform  vec2 u_MaxColorOverLifeGradientAlphas[4];//x为key,y为Alpha
#endif


#ifdef defined(SIZEOVERLIFETIMECURVE)||defined(SIZEOVERLIFETIMERANDOMCURVES)
  uniform  vec2 u_SOLSizeGradient[4];//x为key,y为尺寸
#endif
#ifdef SIZEOVERLIFETIMERANDOMCURVES
  uniform  vec2 u_SOLSizeGradientMax[4];//x为key,y为尺寸
#endif
#ifdef defined(SIZEOVERLIFETIMECURVESEPERATE)||defined(SIZEOVERLIFETIMERANDOMCURVESSEPERATE)
  uniform  vec2 u_SOLSizeGradientX[4];//x为key,y为尺寸
  uniform  vec2 u_SOLSizeGradientY[4];//x为key,y为尺寸
  uniform  vec2 u_SOLSizeGradientZ[4];//x为key,y为尺寸
#endif
#ifdef SIZEOVERLIFETIMERANDOMCURVESSEPERATE
  uniform  vec2 u_SOLSizeGradientMaxX[4];//x为key,y为尺寸
  uniform  vec2 u_SOLSizeGradientMaxY[4];//x为key,y为尺寸
  uniform  vec2 u_SOLSizeGradientMaxZ[4];//x为key,y为尺寸
#endif


#ifdef ROTATIONOVERLIFETIME
  #ifdef defined(ROTATIONOVERLIFETIMECONSTANT)||defined(ROTATIONOVERLIFETIMERANDOMCONSTANTS)
    uniform  float u_ROLAngularVelocityConst;
  #endif
  #ifdef ROTATIONOVERLIFETIMERANDOMCONSTANTS
    uniform  float u_ROLAngularVelocityConstMax;
  #endif
  #ifdef defined(ROTATIONOVERLIFETIMECURVE)||defined(ROTATIONOVERLIFETIMERANDOMCURVES)
    uniform  vec2 u_ROLAngularVelocityGradient[4];//x为key,y为旋转
  #endif
  #ifdef ROTATIONOVERLIFETIMERANDOMCURVES
    uniform  vec2 u_ROLAngularVelocityGradientMax[4];//x为key,y为旋转
  #endif
#endif
#ifdef ROTATIONOVERLIFETIMESEPERATE
  #ifdef defined(ROTATIONOVERLIFETIMECONSTANT)||defined(ROTATIONOVERLIFETIMERANDOMCONSTANTS)
    uniform  vec3 u_ROLAngularVelocityConstSeprarate;
  #endif
  #ifdef ROTATIONOVERLIFETIMERANDOMCONSTANTS
    uniform  vec3 u_ROLAngularVelocityConstMaxSeprarate;
  #endif
  #ifdef defined(ROTATIONOVERLIFETIMECURVE)||defined(ROTATIONOVERLIFETIMERANDOMCURVES)
    uniform  vec2 u_ROLAngularVelocityGradientX[4];//x为key,y为旋转
    uniform  vec2 u_ROLAngularVelocityGradientY[4];//x为key,y为旋转
    uniform  vec2 u_ROLAngularVelocityGradientZ[4];//x为key,y为旋转
  #endif
  #ifdef ROTATIONOVERLIFETIMERANDOMCURVES
    uniform  vec2 u_ROLAngularVelocityGradientMaxX[4];//x为key,y为旋转
    uniform  vec2 u_ROLAngularVelocityGradientMaxY[4];//x为key,y为旋转
    uniform  vec2 u_ROLAngularVelocityGradientMaxZ[4];//x为key,y为旋转
  #endif
#endif

#ifdef defined(TEXTURESHEETANIMATIONCURVE)||defined(TEXTURESHEETANIMATIONRANDOMCURVE)
  uniform  float u_TSACycles;
  uniform  vec2 u_TSASubUVLength;
  uniform  vec2 u_TSAGradientUVs[4];//x为key,y为frame
#endif
#ifdef TEXTURESHEETANIMATIONRANDOMCURVE
  uniform  vec2 u_TSAMaxGradientUVs[4];//x为key,y为frame
#endif

 
#ifdef defined(VELOCITYOVERLIFETIMECURVE)||defined(VELOCITYOVERLIFETIMERANDOMCURVE)||defined(SIZEOVERLIFETIMECURVE)||defined(SIZEOVERLIFETIMECURVESEPERATE)||defined(SIZEOVERLIFETIMERANDOMCURVES)||defined(SIZEOVERLIFETIMERANDOMCURVESSEPERATE)
float getCurValueFromGradientFloat(in vec2 gradientNumbers[4],in float normalizedAge)
{
	float curValue;
	for(int i=1;i<4;i++)
	{
		vec2 gradientNumber=gradientNumbers[i];
		float key=gradientNumber.x;
		if(key>=normalizedAge)
		{
			vec2 lastGradientNumber=gradientNumbers[i-1];
			float lastKey=lastGradientNumber.x;
			float age=(normalizedAge-lastKey)/(key-lastKey);
			curValue=mix(lastGradientNumber.y,gradientNumber.y,age);
			break;
		}
	}
	return curValue;
}
#endif

#ifdef VELOCITYOVERLIFETIME
//float getTotalPositionFromGradientFloat(in vec2 gradientNumbers[4],in float normalizedAge)
//{
//	float totalPosition=0.0;
//	for(int i=1;i<4;i++)
//	{
//		vec2 gradientNumber=gradientNumbers[i];
//		float key=gradientNumber.x;
//		vec2 lastGradientNumber=gradientNumbers[i-1];
//		float lastValue=lastGradientNumber.y;
//		
//		if(key>=normalizedAge){
//			float lastKey=lastGradientNumber.x;
//			float age=(normalizedAge-lastKey)/(key-lastKey);
//			
//			float velocity=(lastValue+mix(lastValue,gradientNumber.y,age))/2.0;
//			totalPosition+=velocity*a_PositionStartLifeTime.w*(normalizedAge-lastKey);//TODO:计算POSITION时可用优化，用已计算好速度
//			break;
//		}
//		else{
//			float velocity=(lastValue+gradientNumber.y)/2.0;
//			totalPosition+=velocity*a_PositionStartLifeTime.w*(key-lastGradientNumber.x);
//		}
//	}
//	return totalPosition;
//}
#endif

#ifdef defined(VELOCITYOVERLIFETIMECURVE)||defined(VELOCITYOVERLIFETIMERANDOMCURVE)||defined(ROTATIONOVERLIFETIMECURVE)||defined(ROTATIONOVERLIFETIMERANDOMCURVES)
float getTotalValueFromGradientFloat(in vec2 gradientNumbers[4],in float normalizedAge)
{
	float totalValue=0.0;
	for(int i=1;i<4;i++)
	{
		vec2 gradientNumber=gradientNumbers[i];
		float key=gradientNumber.x;
		vec2 lastGradientNumber=gradientNumbers[i-1];
		float lastValue=lastGradientNumber.y;
		
		if(key>=normalizedAge){
			float lastKey=lastGradientNumber.x;
			float age=(normalizedAge-lastKey)/(key-lastKey);
			totalValue+=(lastValue+mix(lastValue,gradientNumber.y,age))/2.0*a_PositionStartLifeTime.w*(normalizedAge-lastKey);
			break;
		}
		else{
			totalValue+=(lastValue+gradientNumber.y)/2.0*a_PositionStartLifeTime.w*(key-lastGradientNumber.x);
		}
	}
	return totalValue;
}
#endif

#ifdef defined(COLOROVERLIFETIME)||defined(RANDOMCOLOROVERLIFETIME)
vec4 getColorFromGradient(in vec2 gradientAlphas[4],in vec4 gradientColors[4],in float normalizedAge)
{
	vec4 overTimeColor;
	for(int i=1;i<4;i++)
	{
		vec2 gradientAlpha=gradientAlphas[i];
		float alphaKey=gradientAlpha.x;
		if(alphaKey>=normalizedAge)
		{
			vec2 lastGradientAlpha=gradientAlphas[i-1];
			float lastAlphaKey=lastGradientAlpha.x;
			float age=(normalizedAge-lastAlphaKey)/(alphaKey-lastAlphaKey);
			overTimeColor.a=mix(lastGradientAlpha.y,gradientAlpha.y,age);
			break;
		}
	}
	
	for(int i=1;i<4;i++)
	{
		vec4 gradientColor=gradientColors[i];
		float colorKey=gradientColor.x;
		if(colorKey>=normalizedAge)
		{
			vec4 lastGradientColor=gradientColors[i-1];
			float lastColorKey=lastGradientColor.x;
			float age=(normalizedAge-lastColorKey)/(colorKey-lastColorKey);
			overTimeColor.rgb=mix(gradientColors[i-1].yzw,gradientColor.yzw,age);
			break;
		}
	}
	return overTimeColor;
}
#endif


#ifdef defined(TEXTURESHEETANIMATIONCURVE)||defined(TEXTURESHEETANIMATIONRANDOMCURVE)
float getFrameFromGradient(in vec2 gradientFrames[4],in float normalizedAge)
{
	float overTimeFrame;
	for(int i=1;i<4;i++)
	{
		vec2 gradientFrame=gradientFrames[i];
		float key=gradientFrame.x;
		if(key>=normalizedAge)
		{
			vec2 lastGradientFrame=gradientFrames[i-1];
			float lastKey=lastGradientFrame.x;
			float age=(normalizedAge-lastKey)/(key-lastKey);
			overTimeFrame=mix(lastGradientFrame.y,gradientFrame.y,age);
			break;
		}
	}
	return floor(overTimeFrame);
}
#endif

#ifdef defined(VELOCITYOVERLIFETIMECONSTANT)||defined(VELOCITYOVERLIFETIMECURVE)||defined(VELOCITYOVERLIFETIMERANDOMCONSTANT)||defined(VELOCITYOVERLIFETIMERANDOMCURVE)
vec3 computeParticleLifeVelocity(in float normalizedAge)
{
  vec3 outLifeVelocity;
  #ifdef VELOCITYOVERLIFETIMECONSTANT
	 outLifeVelocity=u_VOLVelocityConst; 
  #endif
  #ifdef VELOCITYOVERLIFETIMECURVE
     outLifeVelocity= vec3(getCurValueFromGradientFloat(u_VOLVelocityGradientX,normalizedAge),getCurValueFromGradientFloat(u_VOLVelocityGradientY,normalizedAge),getCurValueFromGradientFloat(u_VOLVelocityGradientZ,normalizedAge));
  #endif
  #ifdef VELOCITYOVERLIFETIMERANDOMCONSTANT
	 outLifeVelocity=mix(u_VOLVelocityConst,u_VOLVelocityConstMax,vec3(a_Random1.y,a_Random1.z,a_Random1.w)); 
  #endif
  #ifdef VELOCITYOVERLIFETIMERANDOMCURVE
     outLifeVelocity=vec3(mix(getCurValueFromGradientFloat(u_VOLVelocityGradientX,normalizedAge),getCurValueFromGradientFloat(u_VOLVelocityGradientMaxX,normalizedAge),a_Random1.y),
	                 mix(getCurValueFromGradientFloat(u_VOLVelocityGradientY,normalizedAge),getCurValueFromGradientFloat(u_VOLVelocityGradientMaxY,normalizedAge),a_Random1.z),
					 mix(getCurValueFromGradientFloat(u_VOLVelocityGradientZ,normalizedAge),getCurValueFromGradientFloat(u_VOLVelocityGradientMaxZ,normalizedAge),a_Random1.w));
  #endif
					
  return outLifeVelocity;
} 
#endif

vec3 computeParticlePosition(in vec3 startVelocity, in vec3 lifeVelocity,in float age,in float normalizedAge)
{
   vec3 startPosition;
   vec3 lifePosition;
   #ifdef defined(VELOCITYOVERLIFETIMECONSTANT)||defined(VELOCITYOVERLIFETIMECURVE)||defined(VELOCITYOVERLIFETIMERANDOMCONSTANT)||defined(VELOCITYOVERLIFETIMERANDOMCURVE)
	#ifdef VELOCITYOVERLIFETIMECONSTANT
		  startPosition=startVelocity*age;
		  lifePosition=lifeVelocity*age;
	#endif
	#ifdef VELOCITYOVERLIFETIMECURVE
		  startPosition=startVelocity*age;
		  lifePosition=vec3(getTotalValueFromGradientFloat(u_VOLVelocityGradientX,normalizedAge),getTotalValueFromGradientFloat(u_VOLVelocityGradientY,normalizedAge),getTotalValueFromGradientFloat(u_VOLVelocityGradientZ,normalizedAge));
	#endif
	#ifdef VELOCITYOVERLIFETIMERANDOMCONSTANT
		  startPosition=startVelocity*age;
		  lifePosition=lifeVelocity*age;
	#endif
	#ifdef VELOCITYOVERLIFETIMERANDOMCURVE
		  startPosition=startVelocity*age;
		  lifePosition=vec3(mix(getTotalValueFromGradientFloat(u_VOLVelocityGradientX,normalizedAge),getTotalValueFromGradientFloat(u_VOLVelocityGradientMaxX,normalizedAge),a_Random1.y)
	      ,mix(getTotalValueFromGradientFloat(u_VOLVelocityGradientY,normalizedAge),getTotalValueFromGradientFloat(u_VOLVelocityGradientMaxY,normalizedAge),a_Random1.z)
	      ,mix(getTotalValueFromGradientFloat(u_VOLVelocityGradientZ,normalizedAge),getTotalValueFromGradientFloat(u_VOLVelocityGradientMaxZ,normalizedAge),a_Random1.w));
	#endif
	
	vec3 finalPosition;
	if(u_VOLSpaceType==0){
	  if(u_ScalingMode!=2)
	   finalPosition =mat3(u_WorldRotationMat)*(u_PositionScale*(a_PositionStartLifeTime.xyz+startPosition+lifePosition));
	  else
	   finalPosition =mat3(u_WorldRotationMat)*(u_PositionScale*a_PositionStartLifeTime.xyz+startPosition+lifePosition);
	}
	else{
	  if(u_ScalingMode!=2)
	    finalPosition = mat3(u_WorldRotationMat)*(u_PositionScale*(a_PositionStartLifeTime.xyz+startPosition))+lifePosition;
	  else
	    finalPosition = mat3(u_WorldRotationMat)*(u_PositionScale*a_PositionStartLifeTime.xyz+startPosition)+lifePosition;
	}
  #else
	 startPosition=startVelocity*age;
	 vec3 finalPosition;
	 if(u_ScalingMode!=2)
	   finalPosition = mat3(u_WorldRotationMat)*(u_PositionScale*(a_PositionStartLifeTime.xyz+startPosition));
	 else
	   finalPosition = mat3(u_WorldRotationMat)*(u_PositionScale*a_PositionStartLifeTime.xyz+startPosition);
  #endif
  
  if(u_SimulationSpace==0)
    finalPosition=finalPosition+a_SimulationWorldPostion;
  else if(u_SimulationSpace==1) 
    finalPosition=finalPosition+u_WorldPosition;
  
  finalPosition+=u_Gravity*age*normalizedAge;//计算受重力影响的位置//TODO:移除
 
  return  finalPosition;
}


vec4 computeParticleColor(in vec4 color,in float normalizedAge)
{
	#ifdef COLOROVERLIFETIME
	  color*=getColorFromGradient(u_ColorOverLifeGradientAlphas,u_ColorOverLifeGradientColors,normalizedAge);
	#endif
	
	#ifdef RANDOMCOLOROVERLIFETIME
	  color*=mix(getColorFromGradient(u_ColorOverLifeGradientAlphas,u_ColorOverLifeGradientColors,normalizedAge),getColorFromGradient(u_MaxColorOverLifeGradientAlphas,u_MaxColorOverLifeGradientColors,normalizedAge),a_Random0.y);
	#endif

    return color;
}

vec2 computeParticleSize(in vec2 size,in float normalizedAge)
{
	#ifdef SIZEOVERLIFETIMECURVE
		size*=getCurValueFromGradientFloat(u_SOLSizeGradient,normalizedAge);
	#endif
	#ifdef SIZEOVERLIFETIMERANDOMCURVES
	    size*=mix(getCurValueFromGradientFloat(u_SOLSizeGradient,normalizedAge),getCurValueFromGradientFloat(u_SOLSizeGradientMax,normalizedAge),a_Random0.z); 
	#endif
	#ifdef SIZEOVERLIFETIMECURVESEPERATE
		size*=vec2(getCurValueFromGradientFloat(u_SOLSizeGradientX,normalizedAge),getCurValueFromGradientFloat(u_SOLSizeGradientY,normalizedAge));
	#endif
	#ifdef SIZEOVERLIFETIMERANDOMCURVESSEPERATE
	    size*=vec2(mix(getCurValueFromGradientFloat(u_SOLSizeGradientX,normalizedAge),getCurValueFromGradientFloat(u_SOLSizeGradientMaxX,normalizedAge),a_Random0.z)
	    ,mix(getCurValueFromGradientFloat(u_SOLSizeGradientY,normalizedAge),getCurValueFromGradientFloat(u_SOLSizeGradientMaxY,normalizedAge),a_Random0.z));
	#endif
	return size;
}

vec3 computeParticleRotation(in vec3 rotation,in float age,in float normalizedAge)//TODO:不分轴是否无需计算XY，Billboard模式下好像是,待确认。
{ 
	#ifdef ROTATIONOVERLIFETIME
	#ifdef ROTATIONOVERLIFETIMECONSTANT
			float ageRot=u_ROLAngularVelocityConst*age;
	        rotation+=ageRot;
		#endif
		#ifdef ROTATIONOVERLIFETIMECURVE
			rotation+=getTotalValueFromGradientFloat(u_ROLAngularVelocityGradient,normalizedAge);
		#endif
		#ifdef ROTATIONOVERLIFETIMERANDOMCONSTANTS
			float ageRot=mix(u_ROLAngularVelocityConst,u_ROLAngularVelocityConstMax,a_Random0.w)*age;
	        rotation+=ageRot;
	    #endif
		#ifdef ROTATIONOVERLIFETIMERANDOMCURVES
			rotation+=mix(getTotalValueFromGradientFloat(u_ROLAngularVelocityGradient,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientMax,normalizedAge),a_Random0.w);
		#endif
	#endif
	#ifdef ROTATIONOVERLIFETIMESEPERATE
	#ifdef ROTATIONOVERLIFETIMECONSTANT
			vec3 ageRot=u_ROLAngularVelocityConstSeprarate*age;
	        rotation+=ageRot;
		#endif
		#ifdef ROTATIONOVERLIFETIMECURVE
			rotation+=vec3(getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientX,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientY,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientZ,normalizedAge));
		#endif
		#ifdef ROTATIONOVERLIFETIMERANDOMCONSTANTS
			vec3 ageRot=mix(u_ROLAngularVelocityConstSeprarate,u_ROLAngularVelocityConstMaxSeprarate,a_Random0.w)*age;
	        rotation+=ageRot;
	    #endif
		#ifdef ROTATIONOVERLIFETIMERANDOMCURVES
			rotation+=vec3(mix(getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientX,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientMaxX,normalizedAge),a_Random0.w)
	        ,mix(getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientY,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientMaxY,normalizedAge),a_Random0.w)
	        ,mix(getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientZ,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientMaxZ,normalizedAge),a_Random0.w));
		#endif
	#endif
	return rotation;
}

vec2 computeParticleUV(in vec2 uv,in float normalizedAge)
{ 
	#ifdef TEXTURESHEETANIMATIONCURVE
		float cycleNormalizedAge=normalizedAge*u_TSACycles;
		float frame=getFrameFromGradient(u_TSAGradientUVs,cycleNormalizedAge-floor(cycleNormalizedAge));
		float totalULength=frame*u_TSASubUVLength.x;
		float floorTotalULength=floor(totalULength);
	    uv.x=uv.x+totalULength-floorTotalULength;
		uv.y=uv.y+floorTotalULength*u_TSASubUVLength.y;
    #endif
	#ifdef TEXTURESHEETANIMATIONRANDOMCURVE
		float cycleNormalizedAge=normalizedAge*u_TSACycles;
		float uvNormalizedAge=cycleNormalizedAge-floor(cycleNormalizedAge);
	    float frame=floor(mix(getFrameFromGradient(u_TSAGradientUVs,uvNormalizedAge),getFrameFromGradient(u_TSAMaxGradientUVs,uvNormalizedAge),a_Random1.x));
		float totalULength=frame*u_TSASubUVLength.x;
		float floorTotalULength=floor(totalULength);
	    uv.x=uv.x+totalULength-floorTotalULength;
		uv.y=uv.y+floorTotalULength*u_TSASubUVLength.y;
    #endif
	return uv;
}

void main()
{
   float age = u_CurrentTime - a_DirectionTime.w;
   float normalizedAge = age/a_PositionStartLifeTime.w;
   vec3 lifeVelocity;
   if(normalizedAge<1.0){ 
	  vec3 startVelocity=a_DirectionTime.xyz*a_StartSpeed;
   #ifdef defined(VELOCITYOVERLIFETIMECONSTANT)||defined(VELOCITYOVERLIFETIMECURVE)||defined(VELOCITYOVERLIFETIMERANDOMCONSTANT)||defined(VELOCITYOVERLIFETIMERANDOMCURVE)
	  lifeVelocity= computeParticleLifeVelocity(normalizedAge);//计算粒子生命周期速度
   #endif 
	  
   vec3 center=computeParticlePosition(startVelocity, lifeVelocity, age, normalizedAge);//计算粒子位置
   vec2 corner=a_CornerTextureCoordinate.xy;//Billboard模式z轴无效
   
   #ifdef SPHERHBILLBOARD
        vec3 cameraUpVector =normalize(u_CameraUp);//TODO:是否外面归一化
        vec3 sideVector = normalize(cross(u_CameraDirection,cameraUpVector));
        vec3 upVector = normalize(cross(sideVector,u_CameraDirection));
	    corner*=computeParticleSize(a_StartSize.xy,normalizedAge);
		if(u_ThreeDStartRotation){
		  center += u_SizeScale.xzy*(mat3(a_StartRotation0,a_StartRotation1,a_StartRotation2)*(corner.x*sideVector+corner.y*upVector));
		}
		else{
		  vec3 rotationAng = computeParticleRotation(a_StartRotation0, age,normalizedAge);
		  float rot=rotationAng.z;
          float c = cos(rot);
          float s = sin(rot);
          mat2 rotation= mat2(c, -s, s, c);
		  corner=rotation*corner;
		  center += u_SizeScale.xzy*(corner.x*sideVector+corner.y*upVector);
		}
       
   #endif
   
   #ifdef STRETCHEDBILLBOARD
	vec3 velocity;
	#ifdef defined(VELOCITYOVERLIFETIMECONSTANT)||defined(VELOCITYOVERLIFETIMECURVE)||defined(VELOCITYOVERLIFETIMERANDOMCONSTANT)||defined(VELOCITYOVERLIFETIMERANDOMCURVE)
	    if(u_VOLSpaceType==0)
		  velocity=mat3(u_WorldRotationMat)*(u_SizeScale*(startVelocity+lifeVelocity));
	    else
		  velocity=mat3(u_WorldRotationMat)*(u_SizeScale*startVelocity)+lifeVelocity;
    #else
	    velocity= mat3(u_WorldRotationMat)*(u_SizeScale*startVelocity);
    #endif   
        vec3 cameraUpVector =normalize(velocity);
        vec3 sideVector = normalize(cross(u_CameraDirection,cameraUpVector));
	    vec2 size=computeParticleSize(a_StartSize.xy,normalizedAge);
	    const mat2 rotaionZHalfPI=mat2(0.0, -1.0, 1.0, 0.0);
	    corner=rotaionZHalfPI*corner;
	    corner.y=corner.y-abs(corner.y);
	    float speed=length(velocity);//TODO:
	    center +=u_SizeScale.xzy*size.x*corner.x*sideVector+((cameraUpVector*speed)*u_StretchedBillboardSpeedScale+cameraUpVector*size.y*u_StretchedBillboardLengthScale)*corner.y;
   #endif
   
   #ifdef HORIZONTALBILLBOARD
        const vec3 cameraUpVector =vec3(0.0,0.0,-1.0);
	    const vec3 sideVector = vec3(1.0,0.0,0.0);
		corner*=computeParticleSize(a_StartSize.xy,normalizedAge);
		vec3 rotationAng = computeParticleRotation(a_StartRotation0, age,normalizedAge);
	    float rot=rotationAng.z;
        float c = cos(rot);
        float s = sin(rot);
        mat2 rotation= mat2(c, -s, s, c);
	    corner=rotation*corner*cos(0.78539816339744830961566084581988);//TODO:临时缩小cos45,不确定U3D原因
        center +=u_SizeScale.xzy*(corner.x*sideVector+ corner.y*cameraUpVector);
   #endif
   
   #ifdef VERTICALBILLBOARD
        const vec3 cameraUpVector =vec3(0.0,1.0,0.0);
        vec3 sideVector = normalize(cross(u_CameraDirection,cameraUpVector));
		corner*=computeParticleSize(a_StartSize.xy,normalizedAge);
		vec3 rotationAng = computeParticleRotation(a_StartRotation0, age,normalizedAge);
		float rot=rotationAng.z;
        float c = cos(rot);
        float s = sin(rot);
        mat2 rotation= mat2(c, -s, s, c);
	    corner=rotation*corner*cos(0.78539816339744830961566084581988);//TODO:临时缩小cos45,不确定U3D原因
        center +=u_SizeScale.xzy*(corner.x*sideVector+ corner.y*cameraUpVector);
   #endif
   
      gl_Position=u_Projection*u_View*vec4(center,1.0);
      v_Color = computeParticleColor(a_StartColor, normalizedAge);
      v_TextureCoordinate =computeParticleUV(a_CornerTextureCoordinate.zw, normalizedAge);
      v_Discard=0.0;
   }
   else
   {
      v_Discard=1.0;
   }
}

