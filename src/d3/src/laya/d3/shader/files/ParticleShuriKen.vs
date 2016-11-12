attribute vec4 a_CornerTextureCoordinate;
attribute vec3 a_Position;
attribute vec3 a_Direction;
attribute vec4 a_StartColor;
attribute vec3 a_StartSize;
attribute vec3 a_StartRotation;
attribute float a_StartLifeTime;
attribute float a_Time;
attribute float a_StartSpeed;
#ifdef RANDOMCOLOROVERLIFETIME||RANDOMSIZEOVERLIFETIME||RANDOMSIZEOVERLIFETIMESEPARATE||ROTATIONOVERLIFETIME
  attribute vec4 a_Random;
#endif

varying float v_Discard;
varying vec4 v_Color;
varying vec2 v_TextureCoordinate;

uniform float u_CurrentTime;
uniform vec3 u_Gravity;

uniform mat4 u_WorldMat;//是否可以只包含位置
uniform vec3 u_Scale;
uniform mat4 u_View;
uniform mat4 u_Projection;

uniform vec3 u_CameraDirection;//TODO:只有几种广告牌模式需要用
uniform vec3 u_CameraUp;

uniform  float u_StretchedBillboardLengthScale;
uniform  float u_StretchedBillboardSpeedScale;

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

//SizeOverLifetime
#ifdef SIZEOVERLIFETIME||RANDOMSIZEOVERLIFETIME
  uniform  vec2 u_SizeOverLifeGradientSizes[4];//x为key,y为尺寸
#endif

#ifdef SIZEOVERLIFETIMESEPARATE||RANDOMSIZEOVERLIFETIMESEPARATE
  uniform  vec2 u_SizeOverLifeGradientSizesX[4];//x为key,y为尺寸
  uniform  vec2 u_SizeOverLifeGradientSizesY[4];//x为key,y为尺寸
  uniform  vec2 u_SizeOverLifeGradientSizesZ[4];//x为key,y为尺寸
#endif

#ifdef RANDOMSIZEOVERLIFETIME
  uniform  vec2 u_MaxSizeOverLifeGradientSizes[4];//x为key,y为尺寸
#endif

#ifdef RANDOMSIZEOVERLIFETIMESEPARATE
  uniform  vec2 u_MaxSizeOverLifeGradientSizesX[4];//x为key,y为尺寸
  uniform  vec2 u_MaxSizeOverLifeGradientSizesY[4];//x为key,y为尺寸
  uniform  vec2 u_MaxSizeOverLifeGradientSizesZ[4];//x为key,y为尺寸
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


vec3 ComputeParticlePosition(in vec3 position, in vec3 velocity,in float age,in float normalizedAge)
{
   float startVelocity = length(velocity);//起始标量速度
   //float endVelocity = startVelocity; //* u_EndVelocity;//结束标量速度

   float velocityIntegral = startVelocity * normalizedAge;// +(endVelocity - startVelocity) * normalizedAge *normalizedAge/2.0;//计算当前速度的标量（单位空间），vt=v0*t+(1/2)*a*(t^2)
   
   vec3 addPosition = normalize(velocity) * velocityIntegral * a_StartLifeTime;//计算受自身速度影响的位置，转换标量到矢量    
   addPosition += u_Gravity * age * normalizedAge;//计算受重力影响的位置
  
   position+=addPosition;
   return  position;
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

float getSizeFromGradient(in vec2 gradientSizes[4],in float normalizedAge)
{
	float overTimeSize;
	for(int i=1;i<4;i++)
	{
		vec2 gradientSize=gradientSizes[i];
		float key=gradientSize.x;
		if(key>=normalizedAge)
		{
			vec2 lastGradientSize=gradientSizes[i-1];
			float lastKey=lastGradientSize.x;
			float age=(normalizedAge-lastKey)/(key-lastKey);
			overTimeSize=mix(lastGradientSize.y,gradientSize.y,age);
			break;
		}
	}
	return overTimeSize;
}

float getRotationFromGradient(in vec2 gradientRotations[4],in float age,in float normalizedAge)
{
	float rotation=0.0;
	float angularVelocity;
	for(int i=1;i<4;i++)
	{
		vec2 angularVelocity=gradientRotations[i];
		float key=angularVelocity.x;
		vec2 lastAngularVelocity=gradientRotations[i-1];
		float lastValue=lastAngularVelocity.y;
		
		if(key>=normalizedAge){
			float lastKey=lastAngularVelocity.x;
			float age=(normalizedAge-lastKey)/(key-lastKey);
			rotation+=(lastValue+mix(lastValue,angularVelocity.y,age))/2.0*a_StartLifeTime*(normalizedAge-lastKey);
			break;
		}
		else{
			rotation+=(lastValue+angularVelocity.y)/2.0*a_StartLifeTime*(key-lastAngularVelocity.x);
		}
	}
	return rotation;
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

vec4 ComputeParticleColor(in vec4 color,in float normalizedAge)
{
	#ifdef COLOROVERLIFETIME
	  color*=getColorFromGradient(u_ColorOverLifeGradientAlphas,u_ColorOverLifeGradientColors,normalizedAge);
	#endif
	
	#ifdef RANDOMCOLOROVERLIFETIME
	  color*=mix(getColorFromGradient(u_ColorOverLifeGradientAlphas,u_ColorOverLifeGradientColors,normalizedAge),getColorFromGradient(u_MaxColorOverLifeGradientAlphas,u_MaxColorOverLifeGradientColors,normalizedAge),a_Random.x);
	#endif

    return color;
}

vec2 computeParticleSize(in vec2 size,in float normalizedAge)
{
	#ifdef SIZEOVERLIFETIME
	  size*=getSizeFromGradient(u_SizeOverLifeGradientSizes,normalizedAge);
	#endif
	
	#ifdef SIZEOVERLIFETIMESEPARATE
	  size*=vec2(getSizeFromGradient(u_SizeOverLifeGradientSizesX,normalizedAge),getSizeFromGradient(u_SizeOverLifeGradientSizesY,normalizedAge));
	#endif
	
	#ifdef RANDOMSIZEOVERLIFETIME
	  size*=mix(getSizeFromGradient(u_SizeOverLifeGradientSizes,normalizedAge),getSizeFromGradient(u_MaxSizeOverLifeGradientSizes,normalizedAge),a_Random.y);
	#endif
	
	#ifdef RANDOMSIZEOVERLIFETIMESEPARATE
	  size*=vec2(mix(getSizeFromGradient(u_SizeOverLifeGradientSizesX,normalizedAge),getSizeFromGradient(u_MaxSizeOverLifeGradientSizesX,normalizedAge),a_Random.y)
	  ,mix(getSizeFromGradient(u_SizeOverLifeGradientSizesY,normalizedAge),getSizeFromGradient(u_MaxSizeOverLifeGradientSizesY,normalizedAge),a_Random.y));
	#endif
	
	return size;
}

mat2 computeParticleRotation(in vec3 rotation,in float age,in float normalizedAge)//TODO:不分轴是否无需计算XY，Billboard模式下好像是,待确认。拉伸模式旋转无效。
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
			  rotation+=vec3(getRotationFromGradient(u_ROLAngularVelocityGradientX,age,normalizedAge),getRotationFromGradient(u_ROLAngularVelocityGradientY,age,normalizedAge),getRotationFromGradient(u_ROLAngularVelocityGradientZ,age,normalizedAge));
			}
			else{
			  rotation+=getRotationFromGradient(u_ROLAngularVelocityGradient,age,normalizedAge);
			}
		}
	    else if(u_ROLType==2){
		    if(u_ROLSeprarate){
			  vec3 ageRot=mix(u_ROLAngularVelocityConstSeprarate,u_ROLAngularVelocityConstMaxSeprarate,a_Random.z)*age;
	          rotation+=ageRot;
	        }
			else{
			  float ageRot=mix(u_ROLAngularVelocityConst,u_ROLAngularVelocityConstMax,a_Random.z)*age;
	          rotation+=ageRot;
			}
	    }
	    else if(u_ROLType==3){
		    if(u_ROLSeprarate){
			   rotation+=vec3(mix(getRotationFromGradient(u_ROLAngularVelocityGradientX,age,normalizedAge),getRotationFromGradient(u_ROLAngularVelocityGradientMaxX,age,normalizedAge),a_Random.z)
	          ,mix(getRotationFromGradient(u_ROLAngularVelocityGradientY,age,normalizedAge),getRotationFromGradient(u_ROLAngularVelocityGradientMaxY,age,normalizedAge),a_Random.z)
	          ,mix(getRotationFromGradient(u_ROLAngularVelocityGradientZ,age,normalizedAge),getRotationFromGradient(u_ROLAngularVelocityGradientMaxZ,age,normalizedAge),a_Random.z));
			}
			else{
			  rotation+=mix(getRotationFromGradient(u_ROLAngularVelocityGradient,age,normalizedAge),getRotationFromGradient(u_ROLAngularVelocityGradientMax,age,normalizedAge),a_Random.z);
			}
		}
	#endif
	float rot=rotation.z;
    float c = cos(rot);
    float s = sin(rot);
    return mat2(c, -s, s, c);
}

vec2 computeParticleUV(in vec2 uv,in float normalizedAge)
{ 
	#ifdef TEXTURESHEETANIMATION
	  if(u_TSAType==1){
		float cycleNormalizedAge=normalizedAge*u_TSACycles;
		float frame=getFrameFromGradient(u_TSAGradientUVs,normalizedAge*(cycleNormalizedAge-floor(cycleNormalizedAge)));
		float totalULength=frame*u_TSASubUVLength.x;
		float floorTotalULength=floor(totalULength);
	    uv.x=uv.x+totalULength-floorTotalULength;
		uv.y=uv.y+floorTotalULength*u_TSASubUVLength.y;
	  }
	  else if(u_TSAType==3){
		float cycleNormalizedAge=normalizedAge*u_TSACycles;
		float uvNormalizedAge=cycleNormalizedAge-floor(cycleNormalizedAge);
	    float frame=floor(mix(getFrameFromGradient(u_TSAGradientUVs,uvNormalizedAge),getFrameFromGradient(u_TSAMaxGradientUVs,uvNormalizedAge),a_Random.w));
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
   if(normalizedAge<1.0)
   {
      vec3 center = ComputeParticlePosition(a_Position, a_Direction*a_StartSpeed, age, normalizedAge);//计算粒子位置
   
      vec4 centerV4= u_WorldMat*vec4(center,1.0);//应该只包含位置和旋转 
      center=centerV4.xyz/centerV4.w;

      mat2 rotation = computeParticleRotation(a_StartRotation, age,normalizedAge);
      vec2 corner=a_CornerTextureCoordinate.xy;//Billboard模式z轴无效
   
      #ifdef SPHERHBILLBOARD
        vec3 cameraUpVector =normalize(u_CameraUp);//TODO:是否外面归一化
        vec3 sideVector = normalize(cross(u_CameraDirection,cameraUpVector));
        vec3 upVector = normalize(cross(sideVector,u_CameraDirection));
	    corner=rotation*corner;
	    corner*=computeParticleSize(a_StartSize.xy,normalizedAge);
        center += u_Scale.xzy*(corner.x*sideVector+corner.y*upVector);
      #endif
   
      #ifdef STRETCHEDBILLBOARD
        //STRETCHEDBILLBOARD模式不需要corner=rotation*corner,旋转失效
        vec3 cameraUpVector =normalize(center);
        vec3 sideVector = normalize(cross(u_CameraDirection,cameraUpVector));
	    vec2 size=computeParticleSize(a_StartSize.xy,normalizedAge);
	    const mat2 rotaionZHalfPI=mat2(0.0, -1.0, 1.0, 0.0);
	    corner=rotaionZHalfPI*corner;
	    corner.y=corner.y-abs(corner.y);
	    float speed=length(u_Scale*a_Direction)*a_StartSpeed;//TODO:
	    center +=u_Scale.xzy*size.x*corner.x*sideVector+((cameraUpVector*speed)*u_StretchedBillboardSpeedScale+cameraUpVector*size.y*u_StretchedBillboardLengthScale)*corner.y;
      #endif
   
      #ifdef HORIZONTALBILLBOARD
        const vec3 cameraUpVector =vec3(0.0,0.0,-1.0);
	    const vec3 sideVector = vec3(1.0,0.0,0.0);
        vec3 upVector=cameraUpVector;
	    corner=rotation*corner;
	    corner*=computeParticleSize(a_StartSize.xy,normalizedAge);
        center +=u_Scale.xzy*(corner.x*sideVector+ corner.y*upVector);
      #endif
   
      #ifdef VERTICALBILLBOARD
        const vec3 cameraUpVector =vec3(0.0,1.0,0.0);
        vec3 sideVector = normalize(cross(u_CameraDirection,cameraUpVector));
        vec3 upVector=cameraUpVector;
	    corner=rotation*corner;
	    corner*=computeParticleSize(a_StartSize.xy,normalizedAge);
        center +=u_Scale.xzy*(corner.x*sideVector+ corner.y*upVector);
      #endif
   
      gl_Position=u_Projection*u_View*vec4(center,1.0);
      v_Color = ComputeParticleColor(a_StartColor, normalizedAge);
      v_TextureCoordinate =computeParticleUV(a_CornerTextureCoordinate.zw, normalizedAge);
      v_Discard=0.0;
   }
   else
   {
      v_Discard=1.0;
   }
}

