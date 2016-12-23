attribute vec4 a_CornerTextureCoordinate;
attribute vec3 a_Position;
attribute vec3 a_Direction;
attribute vec4 a_StartColor;
attribute vec3 a_StartSize;
attribute vec3 a_StartRotation0;
attribute vec3 a_StartRotation1;
attribute vec3 a_StartRotation2;
attribute float a_StartLifeTime;
attribute float a_Time;
attribute float a_StartSpeed;
#ifdef defined(VELOCITYOVERLIFETIME)||defined(COLOROVERLIFETIME)||defined(RANDOMCOLOROVERLIFETIME)||defined(SIZEOVERLIFETIME)||defined(ROTATIONOVERLIFETIME)
  attribute vec4 a_Random0;
#endif
#ifdef TEXTURESHEETANIMATION
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

#ifdef VELOCITYOVERLIFETIME
  uniform  int  u_VOLType;
  uniform  vec3 u_VOLVelocityConst;
  uniform  vec2 u_VOLVelocityGradientX[4];//x为key,y为速度
  uniform  vec2 u_VOLVelocityGradientY[4];//x为key,y为速度
  uniform  vec2 u_VOLVelocityGradientZ[4];//x为key,y为速度
  uniform  vec3 u_VOLVelocityConstMax;
  uniform  vec2 u_VOLVelocityGradientMaxX[4];//x为key,y为速度
  uniform  vec2 u_VOLVelocityGradientMaxY[4];//x为key,y为速度
  uniform  vec2 u_VOLVelocityGradientMaxZ[4];//x为key,y为速度
  uniform  int  u_VOLSpaceType;
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

#ifdef SIZEOVERLIFETIME
  uniform  int u_SOLType;
  uniform  bool u_SOLSeprarate;
  uniform  vec2 u_SOLSizeGradient[4];//x为key,y为尺寸
  uniform  vec2 u_SOLSizeGradientX[4];//x为key,y为尺寸
  uniform  vec2 u_SOLSizeGradientY[4];//x为key,y为尺寸
  uniform  vec2 u_SOLSizeGradientZ[4];//x为key,y为尺寸
  uniform  vec2 u_SOLSizeGradientMax[4];//x为key,y为尺寸
  uniform  vec2 u_SOLSizeGradientMaxX[4];//x为key,y为尺寸
  uniform  vec2 u_SOLSizeGradientMaxY[4];//x为key,y为尺寸
  uniform  vec2 u_SOLSizeGradientMaxZ[4];//x为key,y为尺寸
#endif


#ifdef ROTATIONOVERLIFETIME
  uniform  int u_ROLType;
  uniform  bool u_ROLSeprarate;
  uniform  float u_ROLAngularVelocityConst;
  uniform  vec3 u_ROLAngularVelocityConstSeprarate;
  uniform  vec2 u_ROLAngularVelocityGradient[4];//x为key,y为旋转
  uniform  vec2 u_ROLAngularVelocityGradientX[4];//x为key,y为旋转
  uniform  vec2 u_ROLAngularVelocityGradientY[4];//x为key,y为旋转
  uniform  vec2 u_ROLAngularVelocityGradientZ[4];//x为key,y为旋转
  uniform  float u_ROLAngularVelocityConstMax;
  uniform  vec3 u_ROLAngularVelocityConstMaxSeprarate;
  uniform  vec2 u_ROLAngularVelocityGradientMax[4];//x为key,y为旋转
  uniform  vec2 u_ROLAngularVelocityGradientMaxX[4];//x为key,y为旋转
  uniform  vec2 u_ROLAngularVelocityGradientMaxY[4];//x为key,y为旋转
  uniform  vec2 u_ROLAngularVelocityGradientMaxZ[4];//x为key,y为旋转
#endif

#ifdef TEXTURESHEETANIMATION
  uniform  int u_TSAType;
  uniform  float u_TSACycles;
  uniform  vec2 u_TSASubUVLength;
  uniform  vec2 u_TSAGradientUVs[4];//x为key,y为frame
  uniform  vec2 u_TSAMaxGradientUVs[4];//x为key,y为frame
#endif

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
//			totalPosition+=velocity*a_StartLifeTime*(normalizedAge-lastKey);//TODO:计算POSITION时可用优化，用已计算好速度
//			break;
//		}
//		else{
//			float velocity=(lastValue+gradientNumber.y)/2.0;
//			totalPosition+=velocity*a_StartLifeTime*(key-lastGradientNumber.x);
//		}
//	}
//	return totalPosition;
//}
#endif


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
			totalValue+=(lastValue+mix(lastValue,gradientNumber.y,age))/2.0*a_StartLifeTime*(normalizedAge-lastKey);
			break;
		}
		else{
			totalValue+=(lastValue+gradientNumber.y)/2.0*a_StartLifeTime*(key-lastGradientNumber.x);
		}
	}
	return totalValue;
}

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

#ifdef VELOCITYOVERLIFETIME
vec3 computeParticleLifeVelocity(in float normalizedAge)
{
  vec3 outLifeVelocity;
  if(u_VOLType==0)
	 outLifeVelocity=u_VOLVelocityConst; 
  else if(u_VOLType==1)
     outLifeVelocity= vec3(getCurValueFromGradientFloat(u_VOLVelocityGradientX,normalizedAge),getCurValueFromGradientFloat(u_VOLVelocityGradientY,normalizedAge),getCurValueFromGradientFloat(u_VOLVelocityGradientZ,normalizedAge));
  else if(u_VOLType==2)
	 outLifeVelocity=mix(u_VOLVelocityConst,u_VOLVelocityConstMax,a_Random0.x); 
  else if(u_VOLType==3)
     outLifeVelocity=vec3(mix(getCurValueFromGradientFloat(u_VOLVelocityGradientX,normalizedAge),getCurValueFromGradientFloat(u_VOLVelocityGradientMaxX,normalizedAge),a_Random0.x),
	                 mix(getCurValueFromGradientFloat(u_VOLVelocityGradientY,normalizedAge),getCurValueFromGradientFloat(u_VOLVelocityGradientMaxY,normalizedAge),a_Random0.x),
					 mix(getCurValueFromGradientFloat(u_VOLVelocityGradientZ,normalizedAge),getCurValueFromGradientFloat(u_VOLVelocityGradientMaxZ,normalizedAge),a_Random0.x));
					
  return outLifeVelocity;
} 
#endif

vec3 computeParticlePosition(in vec3 startVelocity, in vec3 lifeVelocity,in float age,in float normalizedAge)
{
   vec3 startPosition;
   vec3 lifePosition;
   #ifdef VELOCITYOVERLIFETIME
	 if(u_VOLType==0){
		  startPosition=startVelocity*age;
		  lifePosition=lifeVelocity*age;
	 }
	 else if(u_VOLType==1){
		  startPosition=startVelocity*age;
		  lifePosition=vec3(getTotalValueFromGradientFloat(u_VOLVelocityGradientX,normalizedAge),getTotalValueFromGradientFloat(u_VOLVelocityGradientY,normalizedAge),getTotalValueFromGradientFloat(u_VOLVelocityGradientZ,normalizedAge));
	 }
	 else if(u_VOLType==2){
		  startPosition=startVelocity*age;
		  lifePosition=lifeVelocity*age;
	 }
	 else if(u_VOLType==3){
		  startPosition=startVelocity*age;
		  lifePosition=vec3(mix(getTotalValueFromGradientFloat(u_VOLVelocityGradientX,normalizedAge),getTotalValueFromGradientFloat(u_VOLVelocityGradientMaxX,normalizedAge),a_Random0.x)
	      ,mix(getTotalValueFromGradientFloat(u_VOLVelocityGradientY,normalizedAge),getTotalValueFromGradientFloat(u_VOLVelocityGradientMaxY,normalizedAge),a_Random0.x)
	      ,mix(getTotalValueFromGradientFloat(u_VOLVelocityGradientZ,normalizedAge),getTotalValueFromGradientFloat(u_VOLVelocityGradientMaxZ,normalizedAge),a_Random0.x));
	 }
	
	vec3 finalPosition;
	if(u_VOLSpaceType==0){
	  if(u_ScalingMode!=2)
	   finalPosition =mat3(u_WorldRotationMat)*(u_PositionScale*(a_Position+startPosition+lifePosition));
	  else
	   finalPosition =mat3(u_WorldRotationMat)*(u_PositionScale*a_Position+startPosition+lifePosition);
	}
	else{
	  if(u_ScalingMode!=2)
	    finalPosition = mat3(u_WorldRotationMat)*(u_PositionScale*(a_Position+startPosition))+lifePosition;
	  else
	    finalPosition = mat3(u_WorldRotationMat)*(u_PositionScale*a_Position+startPosition)+lifePosition;
	}
  #else
	 startPosition=startVelocity*age;
	 vec3 finalPosition;
	 if(u_ScalingMode!=2)
	   finalPosition = mat3(u_WorldRotationMat)*(u_PositionScale*(a_Position+startPosition));
	 else
	   finalPosition = mat3(u_WorldRotationMat)*(u_PositionScale*a_Position+startPosition);
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
	#ifdef SIZEOVERLIFETIME
	 if(u_SOLType==0){
		if(u_SOLSeprarate){
		    size*=vec2(getCurValueFromGradientFloat(u_SOLSizeGradientX,normalizedAge),getCurValueFromGradientFloat(u_SOLSizeGradientY,normalizedAge));
		}
		else{
		    size*=getCurValueFromGradientFloat(u_SOLSizeGradient,normalizedAge);
		}
	 }
	 else if(u_SOLType==2){
		if(u_SOLSeprarate){
			size*=vec2(mix(getCurValueFromGradientFloat(u_SOLSizeGradientX,normalizedAge),getCurValueFromGradientFloat(u_SOLSizeGradientMaxX,normalizedAge),a_Random0.z)
	        ,mix(getCurValueFromGradientFloat(u_SOLSizeGradientY,normalizedAge),getCurValueFromGradientFloat(u_SOLSizeGradientMaxY,normalizedAge),a_Random0.z));
		}
		else{
			size*=mix(getCurValueFromGradientFloat(u_SOLSizeGradient,normalizedAge),getCurValueFromGradientFloat(u_SOLSizeGradientMax,normalizedAge),a_Random0.z); 
		}
	 }
	#endif
	return size;
}

vec3 computeParticleRotation(in vec3 rotation,in float age,in float normalizedAge)//TODO:不分轴是否无需计算XY，Billboard模式下好像是,待确认。
{ 
	#ifdef ROTATIONOVERLIFETIME
	   if(u_ROLType==0){
		  if(u_ROLSeprarate){
			  vec3 ageRot=u_ROLAngularVelocityConstSeprarate*age;
	          rotation+=ageRot;
			}
			else{
			  float ageRot=u_ROLAngularVelocityConst*age;
	          rotation+=ageRot;
			}
		}
	    else if(u_ROLType==1){
		    if(u_ROLSeprarate){
			  rotation+=vec3(getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientX,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientY,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientZ,normalizedAge));
			}
			else{
			  rotation+=getTotalValueFromGradientFloat(u_ROLAngularVelocityGradient,normalizedAge);
			}
		}
	    else if(u_ROLType==2){
		    if(u_ROLSeprarate){
			  vec3 ageRot=mix(u_ROLAngularVelocityConstSeprarate,u_ROLAngularVelocityConstMaxSeprarate,a_Random0.w)*age;
	          rotation+=ageRot;
	        }
			else{
			  float ageRot=mix(u_ROLAngularVelocityConst,u_ROLAngularVelocityConstMax,a_Random0.w)*age;
	          rotation+=ageRot;
			}
	    }
	    else if(u_ROLType==3){
		    if(u_ROLSeprarate){
			   rotation+=vec3(mix(getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientX,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientMaxX,normalizedAge),a_Random0.w)
	          ,mix(getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientY,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientMaxY,normalizedAge),a_Random0.w)
	          ,mix(getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientZ,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientMaxZ,normalizedAge),a_Random0.w));
			}
			else{
			  rotation+=mix(getTotalValueFromGradientFloat(u_ROLAngularVelocityGradient,normalizedAge),getTotalValueFromGradientFloat(u_ROLAngularVelocityGradientMax,normalizedAge),a_Random0.w);
			}
		}
	#endif
	return rotation;
}

vec2 computeParticleUV(in vec2 uv,in float normalizedAge)
{ 
	#ifdef TEXTURESHEETANIMATION
	  if(u_TSAType==1){
		float cycleNormalizedAge=normalizedAge*u_TSACycles;
		float frame=getFrameFromGradient(u_TSAGradientUVs,cycleNormalizedAge-floor(cycleNormalizedAge));
		float totalULength=frame*u_TSASubUVLength.x;
		float floorTotalULength=floor(totalULength);
	    uv.x=uv.x+totalULength-floorTotalULength;
		uv.y=uv.y+floorTotalULength*u_TSASubUVLength.y;
	  }
	  else if(u_TSAType==3){
		float cycleNormalizedAge=normalizedAge*u_TSACycles;
		float uvNormalizedAge=cycleNormalizedAge-floor(cycleNormalizedAge);
	    float frame=floor(mix(getFrameFromGradient(u_TSAGradientUVs,uvNormalizedAge),getFrameFromGradient(u_TSAMaxGradientUVs,uvNormalizedAge),a_Random1.x));
		float totalULength=frame*u_TSASubUVLength.x;
		float floorTotalULength=floor(totalULength);
	    uv.x=uv.x+totalULength-floorTotalULength;
		uv.y=uv.y+floorTotalULength*u_TSASubUVLength.y;
	  }
    #endif
	return uv;
}

void main()
{
   float age = u_CurrentTime - a_Time;
   float normalizedAge = age/a_StartLifeTime;
   vec3 lifeVelocity;
   if(normalizedAge<1.0){ 
	  vec3 startVelocity=a_Direction*a_StartSpeed;
   #ifdef VELOCITYOVERLIFETIME
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
	#ifdef VELOCITYOVERLIFETIME
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

