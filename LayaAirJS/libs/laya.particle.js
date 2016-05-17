
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Shader=laya.webgl.shader.Shader,Handler=laya.utils.Handler,Render=laya.renders.Render,RenderSprite=laya.renders.RenderSprite;
	var IndexBuffer=laya.webgl.utils.IndexBuffer,Sprite=laya.display.Sprite,RenderContext=laya.renders.RenderContext;
	var MathUtil=laya.maths.MathUtil,Stat=laya.utils.Stat,Event=laya.events.Event,Loader=laya.net.Loader,Texture=laya.resource.Texture;
	var Matrix=laya.maths.Matrix,Timer=laya.utils.Timer,BlendMode=laya.webgl.canvas.BlendMode,WebGL=laya.webgl.WebGL;
	var WebGLContext=laya.webgl.WebGLContext,Utils=laya.utils.Utils,Stage=laya.display.Stage,VertexBuffer=laya.webgl.utils.VertexBuffer;
	var Browser=laya.utils.Browser,Value2D=laya.webgl.shader.d2.value.Value2D;
	/**
	*<code>EmitterBase</code> 类是粒子发射器类
	*/
	//class laya.particle.emitter.EmitterBase
	var EmitterBase=(function(){
		function EmitterBase(){
			this._frameTime=0;
			this._emissionRate=60;
			this._emissionTime=0;
			this.minEmissionTime=1/60;
			this._particleTemplate=null;
		}

		__class(EmitterBase,'laya.particle.emitter.EmitterBase');
		var __proto=EmitterBase.prototype;
		/**
		*开始发射粒子
		*@param duration 发射持续的时间
		*/
		__proto.start=function(duration){
			(duration===void 0)&& (duration=Number.MAX_VALUE);
			if (this._emissionRate !=0)
				this._emissionTime=duration;
		}

		/**
		*停止发射粒子
		*@param clearParticles 是否清理当前的粒子
		*/
		__proto.stop=function(){
			this._emissionTime=0;
		}

		/**
		*清理当前的活跃粒子
		*@param clearTexture 是否清理贴图数据,若清除贴图数据将无法再播放
		*/
		__proto.clear=function(){
			this._emissionTime=0;
		}

		/**
		*发射一个粒子
		*
		*/
		__proto.emit=function(){}
		/**
		*时钟前进
		*@param passedTime 前进时间
		*
		*/
		__proto.advanceTime=function(passedTime){
			(passedTime===void 0)&& (passedTime=1);
			this._emissionTime-=passedTime;
			if(this._emissionTime<0)return;
			this._frameTime+=passedTime;
			if (this._frameTime < this.minEmissionTime)return;
			while(this._frameTime>this.minEmissionTime){
				this._frameTime-=this.minEmissionTime;
				this.emit();
			}
		}

		/**
		*设置粒子粒子模板
		*@param particleTemplate 粒子模板
		*
		*/
		__getset(0,__proto,'particleTemplate',null,function(particleTemplate){
			this._particleTemplate=particleTemplate;
		});

		/**
		*设置粒子发射速率
		*@param emissionRate 粒子发射速率 (个/秒)
		*/
		/**
		*获取粒子发射速率
		*@return 发射速率 粒子发射速率 (个/秒)
		*/
		__getset(0,__proto,'emissionRate',function(){
			return this._emissionRate;
			},function(_emissionRate){
			if(_emissionRate<=0)return;
			this._emissionRate=_emissionRate;
			(_emissionRate>0)&&(this.minEmissionTime=1/_emissionRate);
		});

		return EmitterBase;
	})()


	/**
	*@private
	*/
	//class laya.particle.ParticleData
	var ParticleData=(function(){
		function ParticleData(){
			this.position=null;
			this.velocity=null;
			this.color=null;
			this.sizeRotation=null;
			this.radiusRadian=null;
			this.durationAddScale=NaN;
			this.time=NaN;
		}

		__class(ParticleData,'laya.particle.ParticleData');
		ParticleData.Create=function(settings,position,velocity,time){
			var particleData=new ParticleData();
			particleData.position=position;
			MathUtil.scaleVector3(velocity,settings.emitterVelocitySensitivity,ParticleData._tempVelocity);
			var horizontalVelocity=MathUtil.lerp(settings.minHorizontalVelocity,settings.maxHorizontalVelocity,Math.random());
			var horizontalAngle=Math.random()*Math.PI *2;
			ParticleData._tempVelocity[0]+=horizontalVelocity *Math.cos(horizontalAngle);
			ParticleData._tempVelocity[2]+=horizontalVelocity *Math.sin(horizontalAngle);
			ParticleData._tempVelocity[1]+=MathUtil.lerp(settings.minVerticalVelocity,settings.maxVerticalVelocity,Math.random());
			particleData.velocity=ParticleData._tempVelocity;
			particleData.color=ParticleData._tempColor;
			var i=0;
			if (settings.colorComponentInter){
				for (i=0;i < 4;i++)
				particleData.color[i]=MathUtil.lerp(settings.minColor[i],settings.maxColor[i],Math.random());
				}else {
				MathUtil.lerpVector4(settings.minColor,settings.maxColor,Math.random(),particleData.color);
			}
			particleData.sizeRotation=ParticleData._tempSizeRotation;
			var sizeRandom=Math.random();
			particleData.sizeRotation[0]=MathUtil.lerp(settings.minStartSize,settings.maxStartSize,sizeRandom);
			particleData.sizeRotation[1]=MathUtil.lerp(settings.minEndSize,settings.maxEndSize,sizeRandom);
			particleData.sizeRotation[2]=MathUtil.lerp(settings.minRotateSpeed,settings.maxRotateSpeed,Math.random());
			particleData.radiusRadian=ParticleData._tempRadiusRadian;
			var radiusRandom=Math.random();
			particleData.radiusRadian[0]=MathUtil.lerp(settings.minStartRadius,settings.maxStartRadius,radiusRandom);
			particleData.radiusRadian[1]=MathUtil.lerp(settings.minEndRadius,settings.maxEndRadius,radiusRandom);
			particleData.radiusRadian[2]=MathUtil.lerp(settings.minHorizontalEndRadian,settings.maxHorizontalEndRadian,Math.random());
			particleData.radiusRadian[3]=MathUtil.lerp(settings.minVerticalEndRadian,settings.maxVerticalEndRadian,Math.random());
			particleData.durationAddScale=settings.ageAddScale *Math.random();
			particleData.time=time;
			return particleData;
		}

		__static(ParticleData,
		['_tempVelocity',function(){return this._tempVelocity=new Float32Array(3);},'_tempColor',function(){return this._tempColor=new Float32Array(4);},'_tempSizeRotation',function(){return this._tempSizeRotation=new Float32Array(3);},'_tempRadiusRadian',function(){return this._tempRadiusRadian=new Float32Array(4);}
		]);
		return ParticleData;
	})()


	/**
	*@private
	*/
	//class laya.particle.ParticleEmitter
	var ParticleEmitter=(function(){
		function ParticleEmitter(templet,particlesPerSecond,initialPosition){
			this._templet=null;
			this._timeBetweenParticles=NaN;
			this._previousPosition=null;
			this._timeLeftOver=0;
			this._tempVelocity=new Float32Array([0,0,0]);
			this._tempPosition=new Float32Array([0,0,0]);
			this._templet=templet;
			this._timeBetweenParticles=1.0 / particlesPerSecond;
			this._previousPosition=initialPosition;
		}

		__class(ParticleEmitter,'laya.particle.ParticleEmitter');
		var __proto=ParticleEmitter.prototype;
		__proto.update=function(elapsedTime,newPosition){
			elapsedTime=elapsedTime / 1000;
			if (elapsedTime > 0){
				MathUtil.subtractVector3(newPosition,this._previousPosition,this._tempVelocity);
				MathUtil.scaleVector3(this._tempVelocity,1 / elapsedTime,this._tempVelocity);
				var timeToSpend=this._timeLeftOver+elapsedTime;
				var currentTime=-this._timeLeftOver;
				while (timeToSpend > this._timeBetweenParticles){
					currentTime+=this._timeBetweenParticles;
					timeToSpend-=this._timeBetweenParticles;
					MathUtil.lerpVector3(this._previousPosition,newPosition,currentTime / elapsedTime,this._tempPosition);
					this._templet.addParticleArray(this._tempPosition,this._tempVelocity);
				}
				this._timeLeftOver=timeToSpend;
			}
			this._previousPosition[0]=newPosition[0];
			this._previousPosition[1]=newPosition[1];
			this._previousPosition[2]=newPosition[2];
		}

		return ParticleEmitter;
	})()


	/**
	*<code>ParticleSettings</code> 类是粒子配置数据类
	*/
	//class laya.particle.ParticleSettings
	var ParticleSettings=(function(){
		function ParticleSettings(){
			this.textureName=null;
			this.textureCount=1;
			this.maxPartices=100;
			this.duration=1;
			this.ageAddScale=0;
			this.minHorizontalVelocity=0;
			this.maxHorizontalVelocity=0;
			this.minVerticalVelocity=0;
			this.maxVerticalVelocity=0;
			this.endVelocity=1;
			this.colorComponentInter=false;
			this.minRotateSpeed=0;
			this.maxRotateSpeed=0;
			this.minStartSize=100;
			this.maxStartSize=100;
			this.minEndSize=100;
			this.maxEndSize=100;
			this.emitterVelocitySensitivity=1;
			this.minStartRadius=0;
			this.maxStartRadius=0;
			this.minEndRadius=0;
			this.maxEndRadius=0;
			this.minHorizontalEndRadian=0;
			this.maxHorizontalEndRadian=0;
			this.minVerticalEndRadian=0;
			this.maxVerticalEndRadian=0;
			this.blendState=0;
			this.emitterType="null";
			this.emissionRate=0;
			this.sphereEmitterRadius=1;
			this.sphereEmitterVelocity=0;
			this.sphereEmitterVelocityAddVariance=0;
			this.ringEmitterRadius=30;
			this.ringEmitterVelocity=0;
			this.ringEmitterVelocityAddVariance=0;
			this.ringEmitterUp=2;
			this.gravity=new Float32Array([0,0,0]);
			this.minColor=new Float32Array([1,1,1,1]);
			this.maxColor=new Float32Array([1,1,1,1]);
			this.pointEmitterPosition=new Float32Array([0,0,0]);
			this.pointEmitterPositionVariance=new Float32Array([0,0,0]);
			this.pointEmitterVelocity=new Float32Array([0,0,0]);
			this.pointEmitterVelocityAddVariance=new Float32Array([0,0,0]);
			this.boxEmitterCenterPosition=new Float32Array([0,0,0]);
			this.boxEmitterSize=new Float32Array([0,0,0]);
			this.boxEmitterVelocity=new Float32Array([0,0,0]);
			this.boxEmitterVelocityAddVariance=new Float32Array([0,0,0]);
			this.sphereEmitterCenterPosition=new Float32Array([0,0,0]);
			this.ringEmitterCenterPosition=new Float32Array([0,0,0]);
			this.positionVariance=new Float32Array([0,0,0]);
		}

		__class(ParticleSettings,'laya.particle.ParticleSettings');
		return ParticleSettings;
	})()


	/**
	*
	*<code>ParticleTemplateBase</code> 类是粒子模板基类
	*
	*/
	//class laya.particle.ParticleTemplateBase
	var ParticleTemplateBase=(function(){
		function ParticleTemplateBase(){
			this.settings=null;
			this.texture=null;
		}

		__class(ParticleTemplateBase,'laya.particle.ParticleTemplateBase');
		var __proto=ParticleTemplateBase.prototype;
		/**
		*添加一个粒子
		*@param position 粒子位置
		*@param velocity 粒子速度
		*
		*/
		__proto.addParticleArray=function(position,velocity){}
		return ParticleTemplateBase;
	})()


	/**
	*@private
	*/
	//class laya.particle.particleUtils.CanvasShader
	var CanvasShader=(function(){
		function CanvasShader(){
			this.u_EndVelocity=NaN;
			this.u_Gravity=null;
			this.u_Duration=NaN;
			this.a_RadiusRadian=null;
			this.a_Position=null;
			this.a_SizeRotation=null;
			this.a_Color=null;
			this.a_Velocity=null;
			this.gl_Position=null;
			this.v_Color=null;
			this.a_AgeAddScale=NaN;
			this.oSize=NaN;
			this._color=new Float32Array(4);
			this._position=new Float32Array(3);
		}

		__class(CanvasShader,'laya.particle.particleUtils.CanvasShader');
		var __proto=CanvasShader.prototype;
		__proto.getLen=function(position){
			return Math.sqrt(position[0] *position[0]+position[1] *position[1]+position[2] *position[2]);
		}

		__proto.ComputeParticlePosition=function(position,velocity,age,normalizedAge){
			this._position[0]=position[0];
			this._position[1]=position[1];
			this._position[2]=position[2];
			var startVelocity=this.getLen(velocity);
			var endVelocity=startVelocity *this.u_EndVelocity;
			var velocityIntegral=startVelocity *normalizedAge+(endVelocity-startVelocity)*normalizedAge *normalizedAge / 2.0;
			var lenVelocity=NaN;
			lenVelocity=this.getLen(velocity);
			var i=0,len=0;
			len=3;
			for (i=0;i < len;i++){
				this._position[i]+=this._position[i]+(velocity[i] / lenVelocity)*velocityIntegral *this.u_Duration;
				this._position[i]+=this.u_Gravity[i] *age *normalizedAge;
			};
			var radius=MathUtil.lerp(this.a_RadiusRadian[0],this.a_RadiusRadian[1],normalizedAge);
			var radianHorizontal=this.a_RadiusRadian[2] *normalizedAge;
			var radianVertical=this.a_RadiusRadian[3] *normalizedAge;
			var r=Math.cos(radianVertical)*radius;
			this._position[1]+=Math.sin(radianVertical)*radius;
			this._position[0]+=Math.cos(radianHorizontal)*r;
			this._position[2]+=Math.sin(radianHorizontal)*r;
			return new Float32Array([this._position[0],this._position[1],0.0,1.0]);
		}

		__proto.ComputeParticleSize=function(startSize,endSize,normalizedAge){
			var size=MathUtil.lerp(startSize,endSize,normalizedAge);
			return size;
		}

		__proto.ComputeParticleRotation=function(rot,age){
			return rot *age;
		}

		__proto.ComputeParticleColor=function(projectedPosition,color,normalizedAge){
			var rst=this._color;
			rst[0]=color[0];
			rst[1]=color[1];
			rst[2]=color[2];
			rst[3]=color[3]*normalizedAge *(1.0-normalizedAge)*(1.0-normalizedAge)*6.7;
			return rst;
		}

		__proto.clamp=function(value,min,max){
			if(value<min)return min;
			if(value>max)return max;
			return value;
		}

		__proto.getData=function(age){
			age *=1.0+this.a_AgeAddScale;
			var normalizedAge=this.clamp(age / this.u_Duration,0.0,1.0);
			this.gl_Position=this.ComputeParticlePosition(this.a_Position,this.a_Velocity,age,normalizedAge);
			var pSize=this.ComputeParticleSize(this.a_SizeRotation[0],this.a_SizeRotation[1],normalizedAge);
			var rotation=this.ComputeParticleRotation(this.a_SizeRotation[2],age);
			this.v_Color=this.ComputeParticleColor(this.gl_Position,this.a_Color,normalizedAge);
			var matric=new Matrix();
			var scale=NaN;
			scale=pSize/this.oSize*2;
			matric.scale(scale,scale);
			matric.rotate(rotation);
			matric.setTranslate(this.gl_Position[0],-this.gl_Position[1]);
			var alpha=NaN;
			alpha=this.v_Color[3];
			return [this.v_Color,alpha,matric,this.v_Color[0]*alpha,this.v_Color[1]*alpha,this.v_Color[2]*alpha];
		}

		return CanvasShader;
	})()


	/**
	*
	*@private
	*
	*@created 2015-8-25 下午3:41:07
	*/
	//class laya.particle.particleUtils.CMDParticle
	var CMDParticle=(function(){
		function CMDParticle(){
			this.maxIndex=0;
			this.cmds=null;
			this.id=0;
		}

		__class(CMDParticle,'laya.particle.particleUtils.CMDParticle');
		var __proto=CMDParticle.prototype;
		__proto.setCmds=function(cmds){
			this.cmds=cmds;
			this.maxIndex=cmds.length-1;
		}

		return CMDParticle;
	})()


	/**
	*
	*@private
	*
	*@created 2015-8-26 下午7:22:26
	*/
	//class laya.particle.particleUtils.PicTool
	var PicTool=(function(){
		function PicTool(){}
		__class(PicTool,'laya.particle.particleUtils.PicTool');
		PicTool.getCanvasPic=function(img,color){
			img=img.bitmap;
			var canvas=Browser.createElement("canvas");
			var ctx=canvas.getContext('2d');
			canvas.height=img.height;
			canvas.width=img.width;
			ctx.drawImage(img.source,0,0);
			var imgdata=ctx.getImageData(0,0,canvas.width,canvas.height);
			var data=imgdata.data;
			var red=(color >> 16 & 0xFF);
			var green=(color >> 8 & 0xFF);
			var blue=(color & 0xFF);
			for(var i=0,n=data.length;i<n;i+=4){
				if(data[i+3]==0)continue ;
				data[i]=red;
				data[i+1]=green;
				data[i+2]=blue;
			}
			ctx.putImageData(imgdata,0,0);
			canvas.source=canvas;
			return canvas;
		}

		PicTool.getRGBPic=function(img){
			var rst;
			rst=[new Texture(PicTool.getCanvasPic(img,0xFF0000)),new Texture(PicTool.getCanvasPic(img,0x00FF00)),new Texture(PicTool.getCanvasPic(img,0x0000FF))];
			return rst;
		}

		return PicTool;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.particle.TestParticle
	var TestParticle=(function(){
		function TestParticle(){
			WebGL.enable();
			Laya.init(200,200);
		}

		__class(TestParticle,'laya.particle.TestParticle');
		return TestParticle;
	})()


	/**
	*
	*@private
	*
	*@created 2015-12-21 下午4:37:29
	*/
	//class laya.particle.emitter.Emitter2D extends laya.particle.emitter.EmitterBase
	var Emitter2D=(function(_super){
		function Emitter2D(_template){
			this.settiong=null;
			this._posRange=null;
			this._canvasTemplate=null;
			this._emitFun=null;
			Emitter2D.__super.call(this);
			this._particleTemplate=_template;
			this.settiong=_template.settings;
			this._posRange=this.settiong.positionVariance;
			if((_template instanceof laya.particle.ParticleTemplate2D )){
				this._emitFun=this.webGLEmit;
			}else
			if((_template instanceof laya.particle.ParticleTemplateCanvas )){
				this._canvasTemplate=_template;
				this._emitFun=this.canvasEmit;
			}
		}

		__class(Emitter2D,'laya.particle.emitter.Emitter2D',_super);
		var __proto=Emitter2D.prototype;
		__proto.emit=function(){
			_super.prototype.emit.call(this);
			if(this._emitFun!=null)
				this._emitFun();
		}

		__proto.getRandom=function(value){
			return (Math.random()*2-1)*value;
		}

		__proto.webGLEmit=function(){
			var pos=new Float32Array(3);
			pos[0]=this.getRandom(this._posRange[0]);
			pos[1]=this.getRandom(this._posRange[1]);
			pos[2]=this.getRandom(this._posRange[2]);
			var v=new Float32Array(3);
			v[0]=0;
			v[1]=0;
			v[2]=0;
			this._particleTemplate.addParticleArray(pos,v);
		}

		__proto.canvasEmit=function(){
			var pos=new Float32Array(3);
			pos[0]=this.getRandom(this._posRange[0]);
			pos[1]=this.getRandom(this._posRange[1]);
			pos[2]=this.getRandom(this._posRange[2]);
			var v=new Float32Array(3);
			v[0]=0;
			v[1]=0;
			v[2]=0;
			this._particleTemplate.addParticleArray(pos,v);
		}

		return Emitter2D;
	})(EmitterBase)


	/**
	*@private
	*/
	//class laya.particle.ParticleTemplateWebGL extends laya.particle.ParticleTemplateBase
	var ParticleTemplateWebGL=(function(_super){
		function ParticleTemplateWebGL(parSetting){
			this._vertices=null;
			this._vertexBuffer=null;
			this._indexBuffer=null;
			this._floatCountPerVertex=23;
			this._firstActiveElement=0;
			this._firstNewElement=0;
			this._firstFreeElement=0;
			this._firstRetiredElement=0;
			this._currentTime=0;
			this._drawCounter=0;
			ParticleTemplateWebGL.__super.call(this);
			this.settings=parSetting;
		}

		__class(ParticleTemplateWebGL,'laya.particle.ParticleTemplateWebGL',_super);
		var __proto=ParticleTemplateWebGL.prototype;
		__proto.initialize=function(){
			this._vertices=new Float32Array(this.settings.maxPartices *this._floatCountPerVertex *4);
			var particleOffset=0;
			for (var i=0;i < this.settings.maxPartices;i++){
				var random=Math.random();
				var cornerYSegement=this.settings.textureCount ? 1.0 / this.settings.textureCount :1.0;
				var cornerY=NaN;
				for (cornerY=0;cornerY < this.settings.textureCount;cornerY+=cornerYSegement){
					if (random < cornerY+cornerYSegement)
						break ;
				}
				particleOffset=i *this._floatCountPerVertex *4;
				this._vertices[particleOffset+this._floatCountPerVertex *0+0]=-1;
				this._vertices[particleOffset+this._floatCountPerVertex *0+1]=-1;
				this._vertices[particleOffset+this._floatCountPerVertex *0+2]=0;
				this._vertices[particleOffset+this._floatCountPerVertex *0+3]=cornerY;
				this._vertices[particleOffset+this._floatCountPerVertex *1+0]=1;
				this._vertices[particleOffset+this._floatCountPerVertex *1+1]=-1;
				this._vertices[particleOffset+this._floatCountPerVertex *1+2]=1;
				this._vertices[particleOffset+this._floatCountPerVertex *1+3]=cornerY;
				this._vertices[particleOffset+this._floatCountPerVertex *2+0]=1;
				this._vertices[particleOffset+this._floatCountPerVertex *2+1]=1;
				this._vertices[particleOffset+this._floatCountPerVertex *2+2]=1;
				this._vertices[particleOffset+this._floatCountPerVertex *2+3]=cornerY+cornerYSegement;
				this._vertices[particleOffset+this._floatCountPerVertex *3+0]=-1;
				this._vertices[particleOffset+this._floatCountPerVertex *3+1]=1;
				this._vertices[particleOffset+this._floatCountPerVertex *3+2]=0;
				this._vertices[particleOffset+this._floatCountPerVertex *3+3]=cornerY+cornerYSegement;
			}
		}

		__proto.loadContent=function(){
			this._vertexBuffer=VertexBuffer.create(/*laya.webgl.WebGLContext.DYNAMIC_DRAW*/0x88E8);
			var indexes=new Uint16Array(this.settings.maxPartices *6);
			for (var i=0;i < this.settings.maxPartices;i++){
				indexes[i *6+0]=(i *4+0);
				indexes[i *6+1]=(i *4+1);
				indexes[i *6+2]=(i *4+2);
				indexes[i *6+3]=(i *4+0);
				indexes[i *6+4]=(i *4+2);
				indexes[i *6+5]=(i *4+3);
			}
			this._indexBuffer=IndexBuffer.create();
			this._indexBuffer.clear();
			this._indexBuffer.append(indexes);
			this._indexBuffer.upload();
		}

		__proto.update=function(elapsedTime){
			this._currentTime+=elapsedTime / 1000;
			this.retireActiveParticles();
			this.freeRetiredParticles();
			if (this._firstActiveElement==this._firstFreeElement)
				this._currentTime=0;
			if (this._firstRetiredElement==this._firstActiveElement)
				this._drawCounter=0;
		}

		__proto.retireActiveParticles=function(){
			var particleDuration=this.settings.duration;
			while (this._firstActiveElement !=this._firstNewElement){
				var index=this._firstActiveElement *this._floatCountPerVertex *4+22;
				var particleAge=this._currentTime-this._vertices[index];
				if (particleAge < particleDuration)
					break ;
				this._vertices[index]=this._drawCounter;
				this._firstActiveElement++;
				if (this._firstActiveElement >=this.settings.maxPartices)
					this._firstActiveElement=0;
			}
		}

		__proto.freeRetiredParticles=function(){
			while (this._firstRetiredElement !=this._firstActiveElement){
				var age=this._drawCounter-this._vertices[this._firstRetiredElement *this._floatCountPerVertex *4+22];
				if (age < 3)
					break ;
				this._firstRetiredElement++;
				if (this._firstRetiredElement >=this.settings.maxPartices)
					this._firstRetiredElement=0;
			}
		}

		__proto.addNewParticlesToVertexBuffer=function(){
			this._vertexBuffer.clear();
			this._vertexBuffer.append(this._vertices);
			var start=0;
			if (this._firstNewElement < this._firstFreeElement){
				start=this._firstNewElement *4 *this._floatCountPerVertex *4;
				this._vertexBuffer.subUpload(start,start,start+(this._firstFreeElement-this._firstNewElement)*4 *this._floatCountPerVertex *4);
				}else {
				start=this._firstNewElement *4 *this._floatCountPerVertex *4;
				this._vertexBuffer.subUpload(start,start,start+(this.settings.maxPartices-this._firstNewElement)*4 *this._floatCountPerVertex *4);
				if (this._firstFreeElement > 0){
					this._vertexBuffer.setNeedUpload();
					this._vertexBuffer.subUpload(0,0,this._firstFreeElement *4 *this._floatCountPerVertex *4);
				}
			}
			this._firstNewElement=this._firstFreeElement;
		}

		__proto.addParticleArray=function(position,velocity){
			var nextFreeParticle=this._firstFreeElement+1;
			if (nextFreeParticle >=this.settings.maxPartices)
				nextFreeParticle=0;
			if (nextFreeParticle===this._firstRetiredElement)
				return;
			var particleData=ParticleData.Create(this.settings,position,velocity,this._currentTime);
			var startIndex=this._firstFreeElement *this._floatCountPerVertex *4;
			for (var i=0;i < 4;i++){
				var j=0,offset=0;
				for (j=0,offset=4;j < 3;j++)
				this._vertices[startIndex+i *this._floatCountPerVertex+offset+j]=particleData.position[j];
				for (j=0,offset=7;j < 3;j++)
				this._vertices[startIndex+i *this._floatCountPerVertex+offset+j]=particleData.velocity[j];
				for (j=0,offset=10;j < 4;j++)
				this._vertices[startIndex+i *this._floatCountPerVertex+offset+j]=particleData.color[j];
				for (j=0,offset=14;j < 3;j++)
				this._vertices[startIndex+i *this._floatCountPerVertex+offset+j]=particleData.sizeRotation[j];
				for (j=0,offset=17;j < 4;j++)
				this._vertices[startIndex+i *this._floatCountPerVertex+offset+j]=particleData.radiusRadian[j];
				this._vertices[startIndex+i *this._floatCountPerVertex+21]=particleData.durationAddScale;
				this._vertices[startIndex+i *this._floatCountPerVertex+22]=particleData.time;
			}
			this._firstFreeElement=nextFreeParticle;
		}

		return ParticleTemplateWebGL;
	})(ParticleTemplateBase)


	/**
	*@private
	*/
	//class laya.particle.ParticleTemplateCanvas extends laya.particle.ParticleTemplateBase
	var ParticleTemplateCanvas=(function(_super){
		function ParticleTemplateCanvas(parSetting){
			this._ready=false;
			this.textureList=[];
			this.particleList=[];
			this.pX=0;
			this.pY=0;
			this.activeParticles=[];
			this.deadParticles=[];
			this.iList=[];
			this._maxNumParticles=0;
			this.textureWidth=NaN;
			this.dTextureWidth=NaN;
			this.colorChange=true;
			this.step=1/60;
			this.canvasShader=new CanvasShader();
			ParticleTemplateCanvas.__super.call(this);
			this.settings=parSetting;
			this._maxNumParticles=parSetting.maxPartices;
			this.texture=new Texture();
			this.texture.on(/*laya.events.Event.LOADED*/"loaded",this,this._textureLoaded);
			this.texture.load(parSetting.textureName);
		}

		__class(ParticleTemplateCanvas,'laya.particle.ParticleTemplateCanvas',_super);
		var __proto=ParticleTemplateCanvas.prototype;
		__proto._textureLoaded=function(e){
			this.setTexture(this.texture);
			this._ready=true;
		}

		__proto.clear=function(clearTexture){
			(clearTexture===void 0)&& (clearTexture=true);
			this.deadParticles.length=0;
			this.activeParticles.length=0;
			this.textureList.length=0;
		}

		/**
		*设置纹理
		*@param texture
		*
		*/
		__proto.setTexture=function(texture){
			this.texture=texture;
			this.textureWidth=texture.width;
			this.dTextureWidth=1/this.textureWidth;
			this.pX=-texture.width*0.5;
			this.pY=-texture.height*0.5;
			this.textureList=ParticleTemplateCanvas.changeTexture(texture,this.textureList);
			this.particleList.length=0;
			this.deadParticles.length=0;
			this.activeParticles.length=0;
		}

		/**
		*创建一个粒子数据
		*@return
		*
		*/
		__proto._createAParticleData=function(position,velocity){
			this.canvasShader.u_EndVelocity=this.settings.endVelocity;
			this.canvasShader.u_Gravity=this.settings.gravity;
			this.canvasShader.u_Duration=this.settings.duration;
			var particle;
			particle=ParticleData.Create(this.settings,position,velocity,0);
			this.canvasShader.a_RadiusRadian=particle.radiusRadian;
			this.canvasShader.a_Position=particle.position;
			this.canvasShader.a_SizeRotation=particle.sizeRotation;
			this.canvasShader.a_Color=particle.color;
			this.canvasShader.a_Velocity=particle.velocity;
			this.canvasShader.a_AgeAddScale=particle.durationAddScale;
			this.canvasShader.oSize=this.textureWidth;
			var rst=new CMDParticle();
			var i=0,len=this.settings.duration/(1+particle.durationAddScale);
			var params=[];
			var mStep=NaN;
			for(i=0;i<len;i+=this.step){
				params.push(this.canvasShader.getData(i));
			}
			rst.id=this.particleList.length;
			this.particleList.push(rst);
			rst.setCmds(params);
			return rst;
		}

		__proto.addParticleArray=function(position,velocity){
			if(!this._ready)return;
			var tParticle;
			if(this.particleList.length<this._maxNumParticles){
				tParticle=this._createAParticleData(position,velocity);
				this.iList[tParticle.id]=0;
				this.activeParticles.push(tParticle);
				}else{
				if(this.deadParticles.length>0){
					tParticle=this.deadParticles.pop();
					this.iList[tParticle.id]=0;
					this.activeParticles.push(tParticle);
				}
			}
		}

		__proto.advanceTime=function(passedTime){
			(passedTime===void 0)&& (passedTime=1);
			if(!this._ready)return;
			var particleList=this.activeParticles;
			var pool=this.deadParticles;
			var i=0,len=particleList.length;
			var tcmd;
			var tI=0;
			var iList=this.iList;
			for(i=len-1;i>-1;i--){
				tcmd=particleList[i];
				tI=iList[tcmd.id];
				if(tI>=tcmd.maxIndex){
					tI=0;
					particleList.splice(i,1);
					pool.push(tcmd);
					}else{
					tI+=1;
				}
				iList[tcmd.id]=tI;
			}
		}

		__proto.render=function(context,x,y){
			if(!this._ready)return;
			if(this.activeParticles.length<1)return;
			if(this.textureList.length<2)return;
			this.canvasRender(context,x,y);
		}

		__proto.noColorRender=function(context,x,y){
			var particleList=this.activeParticles;
			var i=0,len=particleList.length;
			var tcmd;
			var tParam;
			var tAlpha=NaN;
			var px=this.pX,py=this.pY;
			var pw=-px*2,ph=-py*2;
			var tI=0;
			var textureList=this.textureList;
			var iList=this.iList;
			var preAlpha=NaN;
			context.translate(x,y);
			preAlpha=context.ctx.globalAlpha;
			for(i=0;i<len;i++){
				tcmd=particleList[i];
				tI=iList[tcmd.id];
				tParam=tcmd.cmds[tI];
				if ((tAlpha=tParam[1])<=0.01)continue ;
				context.setAlpha(preAlpha*tAlpha);
				context.drawTextureWithTransform(this.texture,px,py,pw,ph,tParam[2]);
			}
			context.setAlpha(preAlpha);
			context.translate(-x,-y);
		}

		__proto.canvasRender=function(context,x,y){
			var particleList=this.activeParticles;
			var i=0,len=particleList.length;
			var tcmd;
			var tParam;
			var tAlpha=NaN;
			var px=this.pX,py=this.pY;
			var pw=-px*2,ph=-py*2;
			var tI=0;
			var textureList=this.textureList;
			var iList=this.iList;
			var preAlpha=NaN;
			var preB;
			context.translate(x,y);
			preAlpha=context.ctx.globalAlpha;
			preB=context.ctx.globalCompositeOperation;
			context.blendMode("lighter");
			for(i=0;i<len;i++){
				tcmd=particleList[i];
				tI=iList[tcmd.id];
				tParam=tcmd.cmds[tI];
				if ((tAlpha=tParam[1])<=0.01)continue ;
				context.save();
				context.transformByMatrix(tParam[2]);
				if(tParam[3]>0.01){
					context.setAlpha(preAlpha*tParam[3]);
					context.drawTexture(textureList[0],px,py,pw,ph);
				}
				if(tParam[4]>0.01){
					context.setAlpha(preAlpha*tParam[4]);
					context.drawTexture(textureList[1],px,py,pw,ph);
				}
				if(tParam[5]>0.01){
					context.setAlpha(preAlpha*tParam[5]);
					context.drawTexture(textureList[2],px,py,pw,ph);
				}
				context.restore();
			}
			context.setAlpha(preAlpha);
			context.translate(-x,-y);
			context.blendMode(preB);
		}

		ParticleTemplateCanvas.changeTexture=function(texture,rst){
			if(!rst)rst=[];
			rst.length=0;
			Utils.copyArray(rst,PicTool.getRGBPic(texture));
			return rst;
		}

		return ParticleTemplateCanvas;
	})(ParticleTemplateBase)


	/**
	*@private
	*/
	//class laya.particle.ParticleTemplate2D extends laya.particle.ParticleTemplateWebGL
	var ParticleTemplate2D=(function(_super){
		function ParticleTemplate2D(parSetting){
			this.x=0;
			this.y=0;
			this.blendType=1;
			this._startTime=0;
			this.sv=new ParticleShaderValue();
			ParticleTemplate2D.__super.call(this,parSetting);
			var _this=this;
			Laya.loader.load(this.settings.textureName,Handler.create(null,function(texture){
				(texture.bitmap).enableMerageInAtlas=false;
				_this.texture=texture;
			}));
			this.sv.u_Duration=this.settings.duration;
			this.sv.u_Gravity=this.settings.gravity;
			this.sv.u_EndVelocity=this.settings.endVelocity;
			this.initialize();
			this.loadContent();
		}

		__class(ParticleTemplate2D,'laya.particle.ParticleTemplate2D',_super);
		var __proto=ParticleTemplate2D.prototype;
		Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
		__proto.getRenderType=function(){return-111}
		__proto.releaseRender=function(){}
		__proto.addParticleArray=function(position,velocity){
			position[0]+=this.x;
			position[1]+=this.y;
			_super.prototype.addParticleArray.call(this,position,velocity);
		}

		__proto.renderSubmit=function(){
			if (this.texture&&this.texture.loaded){
				this.update(Timer.DELTA);
				this.sv.u_CurrentTime=this._currentTime;
				if (this._firstNewElement !=this._firstFreeElement){
					this.addNewParticlesToVertexBuffer();
				}
				this.blend();
				if (this._firstActiveElement !=this._firstFreeElement){
					var gl=WebGL.mainContext;
					this._vertexBuffer.bind(this._indexBuffer);
					this.sv.u_texture=this.texture.source;
					this.sv.upload();
					if (this._firstActiveElement < this._firstFreeElement){
						WebGL.mainContext.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,(this._firstFreeElement-this._firstActiveElement)*6,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,this._firstActiveElement *6 *2);
					}
					else{
						WebGL.mainContext.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,(this.settings.maxPartices-this._firstActiveElement)*6,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,this._firstActiveElement *6 *2);
						if (this._firstFreeElement > 0)
							WebGL.mainContext.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,this._firstFreeElement *6,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,0);
					}
					Stat.drawCall++;
				}
				this._drawCounter++;
			}
			return 1;
		}

		__proto.blend=function(){
			if (ParticleTemplate2D.activeBlendType!==this.blendType){
				var gl=WebGL.mainContext;
				gl.enable(/*laya.webgl.WebGLContext.BLEND*/0x0BE2);
				BlendMode.fns[this.blendType](gl);
				ParticleTemplate2D.activeBlendType=this.blendType;
			}
		}

		ParticleTemplate2D.activeBlendType=-1;
		return ParticleTemplate2D;
	})(ParticleTemplateWebGL)


	/**
	*@private
	*/
	//class laya.particle.shader.value.ParticleShaderValue extends laya.webgl.shader.d2.value.Value2D
	var ParticleShaderValue=(function(_super){
		function ParticleShaderValue(){
			this.a_CornerTextureCoordinate=[4,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,92,0];
			this.a_Position=[3,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,92,16];
			this.a_Velocity=[3,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,92,28];
			this.a_Color=[4,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,92,40];
			this.a_SizeRotation=[3,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,92,56];
			this.a_RadiusRadian=[4,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,92,68];
			this.a_AgeAddScale=[1,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,92,84];
			this.a_Time=[1,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,92,88];
			this.u_CurrentTime=NaN;
			this.u_Duration=NaN;
			this.u_Gravity=null;
			this.u_EndVelocity=NaN;
			this.u_texture=null;
			ParticleShaderValue.__super.call(this,0,0);
		}

		__class(ParticleShaderValue,'laya.particle.shader.value.ParticleShaderValue',_super);
		var __proto=ParticleShaderValue.prototype;
		__proto.upload=function(){
			this.refresh();
			ParticleShaderValue.pShader.upload(this);
		}

		__static(ParticleShaderValue,
		['pShader',function(){return this.pShader=new ParticleShader();}
		]);
		return ParticleShaderValue;
	})(Value2D)


	/**
	*<code>Particle2D</code> 类是2D粒子播放类
	*
	*/
	//class laya.particle.Particle2D extends laya.display.Sprite
	var Particle2D=(function(_super){
		function Particle2D(setting){
			this._particleTemplate=null;
			this._canvasTemplate=null;
			this._emitter=null;
			Particle2D.__super.call(this);
			if (Render.isWebGL){
				this._particleTemplate=new ParticleTemplate2D(setting);
				this.graphics._saveToCmd(Render.context._drawParticle,[this._particleTemplate]);
				}else{
				this._particleTemplate=this._canvasTemplate=new ParticleTemplateCanvas(setting);
				this._renderType |=/*laya.renders.RenderSprite.CUSTOM*/0x200;
			}
			this._emitter=new Emitter2D(this._particleTemplate);
		}

		__class(Particle2D,'laya.particle.Particle2D',_super);
		var __proto=Particle2D.prototype;
		/**
		*播放
		*
		*/
		__proto.play=function(){
			Laya.timer.frameLoop(1,this,this._loop);
		}

		/**
		*停止
		*
		*/
		__proto.stop=function(){
			Laya.timer.clear(this,this._loop);
		}

		/**@private */
		__proto._loop=function(){
			this.advanceTime(1/60);
		}

		/**
		*时钟前进
		*@param passedTime 时钟前进时间
		*
		*/
		__proto.advanceTime=function(passedTime){
			(passedTime===void 0)&& (passedTime=1);
			if(this._canvasTemplate){
				this._canvasTemplate.advanceTime(passedTime);
			}
			if (this._emitter){
				this._emitter.advanceTime(passedTime);
			}
		}

		/**@private */
		__proto.customRender=function(context,x,y){
			if (this._canvasTemplate){
				this._canvasTemplate.render(context,x,y);
			}
		}

		/**
		*获取粒子发射器
		*@return
		*
		*/
		__getset(0,__proto,'emitter',function(){
			return this._emitter;
		});

		return Particle2D;
	})(Sprite)


	/**
	*
	*<code>ParticlePlayer</code> 类是粒子播放容器类
	*主要用于播放UI编辑器中拖放到UI上的粒子
	*
	*/
	//class laya.particle.ParticlePlayer extends laya.display.Sprite
	var ParticlePlayer=(function(_super){
		function ParticlePlayer(){
			this._particle=null;
			ParticlePlayer.__super.call(this);
		}

		__class(ParticlePlayer,'laya.particle.ParticlePlayer',_super);
		var __proto=ParticlePlayer.prototype;
		/**
		*加载粒子文件
		*@param url 粒子文件地址
		*
		*/
		__proto.loadParticle=function(url){
			Laya.loader.load(url,Handler.create(this,this.setParticleSetting),null,/*laya.net.Loader.JSOn*/"json");
		}

		/**
		*设置粒子配置数据
		*@param settings 粒子配置数据
		*
		*/
		__proto.setParticleSetting=function(settings){
			if (this._particle){
				this._particle.stop();
				this._particle.removeSelf();
			}
			this._particle=new Particle2D(settings);
			this._particle.emitter.start();
			this._particle.play();
			this.addChild(this._particle);
		}

		/**
		*设置 粒子文件地址
		*@param path 粒子文件地址
		*
		*/
		__getset(0,__proto,'url',null,function(url){
			this.loadParticle(url);
		});

		return ParticlePlayer;
	})(Sprite)


	/**
	*@private
	*/
	//class laya.particle.shader.ParticleShader extends laya.webgl.shader.Shader
	var ParticleShader=(function(_super){
		function ParticleShader(){
			ParticleShader.__super.call(this,ParticleShader.vs,ParticleShader.ps,"ParticleShader");
		}

		__class(ParticleShader,'laya.particle.shader.ParticleShader',_super);
		__static(ParticleShader,
		['vs',function(){return this.vs="attribute vec4 a_CornerTextureCoordinate;\nattribute vec3 a_Position;\nattribute vec3 a_Velocity;\nattribute vec4 a_Color;\nattribute vec3 a_SizeRotation;\nattribute vec4 a_RadiusRadian;\nattribute float a_AgeAddScale;\nattribute float a_Time;\n\nvarying vec4 v_Color;\nvarying vec2 v_TextureCoordinate;\n\nuniform  float u_CurrentTime;\nuniform float u_Duration;\nuniform float u_EndVelocity;\nuniform vec3 u_Gravity;\n\n#ifdef PARTICLE3D\n uniform mat4 u_WorldMat;\n uniform mat4 u_View;\n uniform mat4 u_Projection;\n uniform vec2 u_ViewportScale;\n#else\n uniform vec2 size;\n uniform mat4 mmat;\n#endif\n\nvec4 ComputeParticlePosition(in vec3 position, in vec3 velocity,in float age,in float normalizedAge)\n{\n\n   float startVelocity = length(velocity);//起始标量速度\n   float endVelocity = startVelocity * u_EndVelocity;//结束标量速度\n\n   float velocityIntegral = startVelocity * normalizedAge +(endVelocity - startVelocity) * normalizedAge *normalizedAge/2.0;//计算当前速度的标量（单位空间），vt=v0*t+(1/2)*a*(t^2)\n   \n   vec3 addPosition = normalize(velocity) * velocityIntegral * u_Duration;//计算受自身速度影响的位置，转换标量到矢量    \n   addPosition += u_Gravity * age * normalizedAge;//计算受重力影响的位置\n   \n   float radius=mix(a_RadiusRadian.x, a_RadiusRadian.y, normalizedAge); //计算粒子受半径和角度影响（无需计算角度和半径时，可用宏定义优化屏蔽此计算）\n   float radianHorizontal =a_RadiusRadian.z*normalizedAge;\n   float radianVertical =a_RadiusRadian.w*normalizedAge;\n   \n   float r =cos(radianVertical)* radius;\n   addPosition.y += sin(radianVertical) * radius;\n	\n   addPosition.x += cos(radianHorizontal) *r;\n   addPosition.z += sin(radianHorizontal) *r;\n  \n   #ifdef PARTICLE3D\n   position+=addPosition;\n    return  u_Projection*u_View*u_WorldMat*(vec4(position, 1.0));\n   #else\n   addPosition.y=-addPosition.y;//2D粒子位置更新需要取负，2D粒子坐标系Y轴正向朝上\n   position+=addPosition;\n    return vec4(position.xy,0.0,1.0);\n   #endif\n}\n\nfloat ComputeParticleSize(in float startSize,in float endSize, in float normalizedAge)\n{    \n    float size = mix(startSize, endSize, normalizedAge);\n    \n	#ifdef PARTICLE3D\n    //Project the size into screen coordinates.\n     return size * u_Projection[1][1];\n	#else\n	 return size;\n	#endif\n}\n\nmat2 ComputeParticleRotation(in float rot,in float age)\n{    \n    float rotation =rot * age;\n    //计算2x2旋转矩阵.\n    float c = cos(rotation);\n    float s = sin(rotation);\n    return mat2(c, -s, s, c);\n}\n\nvec4 ComputeParticleColor(in vec4 color,in float normalizedAge)\n{\n    //硬编码设置，使粒子淡入很快，淡出很慢,6.7的缩放因子把置归一在0到1之间，可以谷歌x*(1-x)*(1-x)*6.7的制图表\n    color.a *= normalizedAge * (1.0-normalizedAge) * (1.0-normalizedAge) * 6.7;\n   \n    return color;\n}\n\nvoid main()\n{\n   float age = u_CurrentTime - a_Time;\n   age *= 1.0 + a_AgeAddScale;\n   float normalizedAge = clamp(age / u_Duration,0.0,1.0);\n   gl_Position = ComputeParticlePosition(a_Position, a_Velocity, age, normalizedAge);//计算粒子位置\n   float pSize = ComputeParticleSize(a_SizeRotation.x,a_SizeRotation.y, normalizedAge);\n   mat2 rotation = ComputeParticleRotation(a_SizeRotation.z, age);\n	\n   #ifdef PARTICLE3D\n	gl_Position.xy += (rotation*a_CornerTextureCoordinate.xy) * pSize * u_ViewportScale;\n   #else\n	gl_Position.xy += (rotation*a_CornerTextureCoordinate.xy) * pSize;\n    gl_Position=vec4((gl_Position.x/size.x-0.5)*2.0,(0.5-gl_Position.y/size.y)*2.0,0.0,1.0);\n   #endif\n   \n   v_Color = ComputeParticleColor(a_Color, normalizedAge);\n   v_TextureCoordinate =a_CornerTextureCoordinate.zw;\n}\n\n"/*__INCLUDESTR__e:/trank/libs/layaair/particle/src/laya/particle/shader/files/particle.vs*/;},'ps',function(){return this.ps="precision highp float;\nvarying vec4 v_Color;\nvarying vec2 v_TextureCoordinate;\nuniform sampler2D u_texture;\n\nvoid main()\n{	\n	gl_FragColor=texture2D(u_texture,v_TextureCoordinate)*v_Color;\n}"/*__INCLUDESTR__e:/trank/libs/layaair/particle/src/laya/particle/shader/files/particle.ps*/;}
		]);
		return ParticleShader;
	})(Shader)



})(window,document,Laya);
