
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Byte=laya.utils.Byte,Sprite=laya.display.Sprite,Event=laya.events.Event,Loader=laya.net.Loader;
	var Matrix=laya.maths.Matrix,URL=laya.net.URL,Stat=laya.utils.Stat,EventDispatcher=laya.events.EventDispatcher;
	var Graphics=laya.display.Graphics,Handler=laya.utils.Handler,Texture=laya.resource.Texture,Browser=laya.utils.Browser;
	var Point=laya.maths.Point,MathUtil=laya.maths.MathUtil;
	/**
	*@private
	*/
	//class laya.ani.AnimationState
	var AnimationState=(function(){
		function AnimationState(){}
		__class(AnimationState,'laya.ani.AnimationState');
		AnimationState.stopped=0;
		AnimationState.paused=1;
		AnimationState.playing=2;
		return AnimationState;
	})()


	/**
	*@private
	*/
	//class laya.ani.bone.BoneSlot
	var BoneSlot=(function(){
		function BoneSlot(){
			this.textureArray=[];
			this.displayDataArray=[];
			this.currTexture=null;
			this.currDisplayData=null;
			this._parentMatrix=null;
		}

		__class(BoneSlot,'laya.ani.bone.BoneSlot');
		var __proto=BoneSlot.prototype;
		/**
		*加入皮肤
		*@param texture
		*@param displayData
		*/
		__proto.addSprite=function(texture,displayData){
			this.textureArray.push(texture);
			this.displayDataArray.push(displayData);
			displayData.name
			this.showSpriteByIndex(0);
		}

		/**
		*显示哪个皮肤
		*@param index
		*/
		__proto.showSpriteByIndex=function(index){
			if (index >-1 && index < this.textureArray.length){
				this.currTexture=this.textureArray[index];
				}else {
				this.currTexture=null;
			}
			if (index >-1 && index < this.displayDataArray.length){
				this.currDisplayData=this.displayDataArray[index];
				}else {
				this.currDisplayData=null;
			}
		}

		/**
		*替换皮肤
		*@param _texture
		*/
		__proto.replaceSkin=function(_texture){
			this.currTexture=_texture;
		}

		/**
		*保存父矩阵的索引
		*@param parentMatrix
		*/
		__proto.setParentMatrix=function(parentMatrix){
			this._parentMatrix=parentMatrix;
		}

		/**
		*把纹理画到Graphics上
		*@param graphics
		*/
		__proto.draw=function(graphics){
			if (this.currTexture==null || this.currDisplayData==null)return;
			var tTexture=this.currTexture;
			if (graphics){
				var tCurrentMatrix=this.getDisplayMatrix();
				if (tCurrentMatrix){
					Matrix.mul(tCurrentMatrix,this._parentMatrix,Matrix.TEMP);
					var tResultMatrix=new Matrix();
					Matrix.TEMP.copy(tResultMatrix);
					graphics.drawTexture(tTexture,-tTexture.sourceWidth / 2,-tTexture.sourceHeight / 2,tTexture.sourceWidth,tTexture.sourceHeight,tResultMatrix);
				}
			}
		}

		/**
		*画骨骼的起始点，方便调试
		*@param graphics
		*/
		__proto.drawBonePoint=function(graphics){
			if (graphics && this._parentMatrix){
				graphics.drawCircle(this._parentMatrix.tx,this._parentMatrix.ty,5,"#ff0000");
			}
		}

		/**
		*得到显示对象的矩阵
		*@return
		*/
		__proto.getDisplayMatrix=function(){
			if (this.currDisplayData){
				return this.currDisplayData.transform.getMatrix();
			}
			return null;
		}

		return BoneSlot;
	})()


	/**
	*@private
	*/
	//class laya.ani.bone.SkinData
	var SkinData=(function(){
		function SkinData(){
			this.name=null;
			this.slotArr=[];
		}

		__class(SkinData,'laya.ani.bone.SkinData');
		var __proto=SkinData.prototype;
		__proto.initData=function(data){
			this.name=data.name;
			var tMySlotData;
			var tSlotData;
			var tSlotDataArr=data.slot;
			for (var i=0;i < tSlotDataArr.length;i++){
				tSlotData=tSlotDataArr[i];
				tMySlotData=new SlotData();
				tMySlotData.initData(tSlotData);
				this.slotArr.push(tMySlotData);
			}
		}

		return SkinData;
	})()


	/**
	*@private
	*/
	//class laya.ani.bone.SkinSlotDisplayData
	var SkinSlotDisplayData=(function(){
		function SkinSlotDisplayData(){
			this.name=null;
			this.type=null;
			this.transform=null;
			this.pivot=null;
			this.uvs=null;
			this.triangles=null;
			this.weights=null;
			this.vertices=null;
			this.slotPos=null;
			this.bonePose=null;
			this.edges=null;
			this.userEdges=null;
		}

		__class(SkinSlotDisplayData,'laya.ani.bone.SkinSlotDisplayData');
		var __proto=SkinSlotDisplayData.prototype;
		__proto.initData=function(data){
			this.name=data.name;
			this.type=data.type;
			this.transform=new Transform();
			this.transform.initData(data.transform);
		}

		return SkinSlotDisplayData;
	})()


	/**
	*@private
	*/
	//class laya.ani.bone.SlotData
	var SlotData=(function(){
		function SlotData(){
			this.name=null;
			this.displayArr=[];
		}

		__class(SlotData,'laya.ani.bone.SlotData');
		var __proto=SlotData.prototype;
		__proto.initData=function(data){
			this.name=data.name;
			var tMyDisplayData;
			var tDisplayData;
			var tDisplayDataArr=data.display;
			for (var h=0;h < tDisplayDataArr.length;h++){
				tDisplayData=tDisplayDataArr[h];
				tMyDisplayData=new SkinSlotDisplayData();
				tMyDisplayData.initData(tDisplayData);
				this.displayArr.push(tMyDisplayData);
			}
		}

		return SlotData;
	})()


	/**
	*@private
	*/
	//class laya.ani.bone.Transform
	var Transform=(function(){
		function Transform(){
			this.skX=0;
			this.skY=0;
			this.scX=1;
			this.scY=1;
			this.x=0;
			this.y=0;
			this.mMatrix=null;
		}

		__class(Transform,'laya.ani.bone.Transform');
		var __proto=Transform.prototype;
		__proto.initData=function(data){
			if (data.x !=undefined){
				this.x=data.x;
			}
			if (data.y !=undefined){
				this.y=data.y;
			}
			if (data.skX !=undefined){
				this.skX=data.skX;
			}
			if (data.skY !=undefined){
				this.skY=data.skY;
			}
			if (data.scX !=undefined){
				this.scX=data.scX;
			}
			if (data.scY !=undefined){
				this.scY=data.scY;
			}
		}

		__proto.getMatrix=function(){
			var tMatrix;
			if (this.mMatrix){
				tMatrix=this.mMatrix;
				}else {
				tMatrix=this.mMatrix=new Matrix();
			}
			tMatrix.a=Math.cos(this.skY);
			tMatrix
			if (this.skX !=0 || this.skY !=0){
				var tAngle=this.skX *Math.PI / 180;
				var cos=Math.cos(tAngle),sin=Math.sin(tAngle);
				tMatrix.setTo(this.scX *cos,this.scX *sin,this.scY *-sin,this.scY *cos,this.x,this.y);
				}else {
				tMatrix.setTo(this.scX,this.skX,this.skY,this.scY,this.x,this.y);
			}
			return tMatrix;
		}

		return Transform;
	})()


	/**
	*@private
	*/
	//class laya.ani.AnimationPlayer extends laya.events.EventDispatcher
	var AnimationPlayer=(function(_super){
		function AnimationPlayer(cacheFrameRate){
			this._templet=null;
			this._currentTime=NaN;
			this._currentFrameTime=NaN;
			this._duration=NaN;
			this._stopWhenCircleFinish=false;
			this._elapsedPlaybackTime=NaN;
			this._startPlayLoopCount=NaN;
			this._currentAnimationClipIndex=0;
			this._currentKeyframeIndex=0;
			this._paused=false;
			this._cacheFrameRate=0;
			this._cacheFrameRateInterval=NaN;
			this.playbackRate=1.0;
			this.isCache=true;
			this.returnToZeroStopped=true;
			AnimationPlayer.__super.call(this);
			(cacheFrameRate===void 0)&& (cacheFrameRate=60);
			this._currentAnimationClipIndex=-1;
			this._currentKeyframeIndex=-1;
			this._currentTime=0.0;
			this._duration=Number.MAX_VALUE;
			this._stopWhenCircleFinish=false;
			this._elapsedPlaybackTime=0;
			this._startPlayLoopCount=-1;
			this._cacheFrameRate=cacheFrameRate;
			this._cacheFrameRateInterval=1000 / this._cacheFrameRate;
		}

		__class(AnimationPlayer,'laya.ani.AnimationPlayer',_super);
		var __proto=AnimationPlayer.prototype;
		/**
		*播放动画
		*@param name 动画名字
		*@param playbackRate 播放速率
		*@param duration 播放时长（Number.MAX_VALUE为循环播放，0为1次）
		*/
		__proto.play=function(index,playbackRate,duration){
			(index===void 0)&& (index=0);
			(playbackRate===void 0)&& (playbackRate=1.0);
			(duration===void 0)&& (duration=Number.MAX_VALUE);
			this._currentTime=0;
			this._elapsedPlaybackTime=0;
			this.playbackRate=playbackRate;
			this._duration=duration;
			this._paused=false;
			this._currentAnimationClipIndex=index;
			this._currentKeyframeIndex=0;
			this._startPlayLoopCount=Stat.loopCount;
			this.event(/*laya.events.Event.PLAYED*/"played");
		}

		/**
		*停止播放当前动画
		*@param immediate 是否立即停止
		*/
		__proto.stop=function(immediate){
			(immediate===void 0)&& (immediate=true);
			if (immediate){
				this._currentAnimationClipIndex=this._currentKeyframeIndex=-1;
				this.event(/*laya.events.Event.STOPPED*/"stopped");
				}else {
				this._stopWhenCircleFinish=true;
			}
		}

		/**更新动画播放器 */
		__proto.update=function(elapsedTime){
			if (this._currentAnimationClipIndex===-1 || this._paused || !this._templet || !this._templet.loaded)
				return;
			var time=0;
			(this._startPlayLoopCount!==Stat.loopCount)&& (time=elapsedTime *this.playbackRate,this._elapsedPlaybackTime+=time);
			var currentAniClipDuration=this._templet.getAniDuration(this._currentAnimationClipIndex);
			if ((this._duration!==0 && this._elapsedPlaybackTime >=this._duration)|| (this._duration===0 && this._elapsedPlaybackTime >=currentAniClipDuration)){
				this._currentAnimationClipIndex=this._currentKeyframeIndex=-1;
				this.event(/*laya.events.Event.STOPPED*/"stopped");
				return;
			}
			time+=this._currentTime;
			while (time >=currentAniClipDuration){
				if (this._stopWhenCircleFinish){
					this._currentAnimationClipIndex=this._currentKeyframeIndex=-1;
					this._stopWhenCircleFinish=false;
					this.event(/*laya.events.Event.STOPPED*/"stopped");
					return;
				}
				time-=currentAniClipDuration;
			}
			this.currentTime=time;
		}

		/**
		*获取当前动画索引
		*@return value 当前动画索引
		*/
		__getset(0,__proto,'currentAnimationClipIndex',function(){
			return this._currentAnimationClipIndex;
		});

		/**
		*设置动画数据模板
		*@param value 动画数据模板
		*/
		/**
		*获取动画数据模板
		*@param value 动画数据模板
		*/
		__getset(0,__proto,'templet',function(){
			return this._templet;
			},function(value){
			if (!this.State===/*laya.ani.AnimationState.stopped*/0)
				this.stop(true);
			this._templet=value;
		});

		/**
		*获取当前帧数
		*@return value 当前帧数
		*/
		__getset(0,__proto,'currentKeyframeIndex',function(){
			return this._currentKeyframeIndex;
		});

		/**
		*获取缓存帧率*
		*@return value 缓存帧率
		*/
		__getset(0,__proto,'cacheFrameRate',function(){
			return this._cacheFrameRate;
		});

		/**
		*获取当前帧时间，不包括重播时间
		*@return value 当前时间
		*/
		__getset(0,__proto,'currentFrameTime',function(){
			return this._currentFrameTime;
		});

		/**
		*设置当前播放位置
		*@param value 当前时间
		*/
		/**
		*获取当前精确时间，不包括重播时间
		*@return value 当前时间
		*/
		__getset(0,__proto,'currentTime',function(){
			return this._currentTime;
			},function(value){
			this._currentTime=value;
			this._currentKeyframeIndex=Math.floor((this._currentTime % (this._templet.getAniDuration(this._currentAnimationClipIndex)))/ this._cacheFrameRateInterval);
			this._currentFrameTime=this._currentKeyframeIndex *this._cacheFrameRateInterval;
		});

		/**
		*获取当前播放状态
		*@return 当前播放状态
		*/
		__getset(0,__proto,'State',function(){
			if (this._currentAnimationClipIndex===-1)
				return /*laya.ani.AnimationState.stopped*/0;
			if (this._paused)
				return /*laya.ani.AnimationState.paused*/1;
			return /*laya.ani.AnimationState.playing*/2;
		});

		/**
		*设置是否暂停
		*@param value 是否暂停
		*/
		/**
		*获取当前是否暂停
		*@return 是否暂停
		*/
		__getset(0,__proto,'paused',function(){
			return this._paused;
			},function(value){
			this._paused=value;
			value && this.event(/*laya.events.Event.PAUSED*/"paused");
		});

		return AnimationPlayer;
	})(EventDispatcher)


	/**
	*@private
	*/
	//class laya.ani.KeyframesAniTemplet extends laya.events.EventDispatcher
	var KeyframesAniTemplet=(function(_super){
		function KeyframesAniTemplet(){
			this._aniMap={};
			//this._publicExtData=null;
			//this._useParent=false;
			//this.unfixedCurrentFrameIndexes=null;
			//this.unfixedCurrentTimes=null;
			//this.unfixedKeyframes=null;
			this.unfixedLastAniIndex=-1;
			this._loaded=false;
			this._animationDatasCache=[];
			KeyframesAniTemplet.__super.call(this);
			this._anis=new Array;
		}

		__class(KeyframesAniTemplet,'laya.ani.KeyframesAniTemplet',_super);
		var __proto=KeyframesAniTemplet.prototype;
		__proto.parse=function(data,playbackRate){
			var i=0,j=0,k=0,n=0,l=0;
			var read=new Byte(data);
			var head=read.readUTFString();
			var aniClassName=read.readUTFString();
			var strList=read.readUTFString().split("\n");
			var aniCount=read.getUint8();
			var publicDataPos=read.getUint32();
			var publicExtDataPos=read.getUint32();
			var publicData;
			if (publicDataPos > 0)
				publicData=data.slice(publicDataPos,publicExtDataPos);
			var publicRead=new Byte(publicData);
			if (publicExtDataPos > 0)
				this._publicExtData=data.slice(publicExtDataPos,data.byteLength);
			this._useParent=!!read.getUint8();
			this._anis.length=aniCount;
			for (i=0;i < aniCount;i++){
				var ani=this._anis[i]=
				{};
				ani.nodes=new Array;
				var name=ani.name=strList[read.getUint8()];
				this._aniMap[name]=i;
				ani.bone3DMap={};
				ani.playTime=read.getFloat32();
				var boneCount=ani.nodes.length=read.getUint8();
				ani.totalKeyframesLength=0;
				for (j=0;j < boneCount;j++){
					var node=ani.nodes[j]=
					{};
					node.childs=[];
					var nameIndex=read.getInt16();
					if (nameIndex >=0){
						node.name=strList[nameIndex];
						ani.bone3DMap[node.name]=j;
					}
					node.keyFrame=new Array;
					node.parentIndex=read.getInt16();
					node.parent=ani.nodes[node.parentIndex];
					var isLerp=!!read.getUint8();
					var keyframeParamsOffset=read.getUint32();
					publicRead.pos=keyframeParamsOffset;
					var keyframeDataCount=node.keyframeWidth=publicRead.getUint16();
					ani.totalKeyframesLength+=keyframeDataCount;
					if (isLerp){
						node.interpolationMethod=[];
						node.interpolationMethod.length=keyframeDataCount;
						for (k=0;k < keyframeDataCount;k++)
						node.interpolationMethod[k]=KeyframesAniTemplet.interpolation[publicRead.getUint8()];
					}
					if (node.parent !=null)
						node.parent.childs.push(node);
					var privateDataLen=read.getUint16();
					if (privateDataLen > 0){
						node.extenData=data.slice(read.pos,read.pos+privateDataLen);
						read.pos+=privateDataLen;
					};
					var keyframeCount=read.getUint16();
					node.keyFrame.length=keyframeCount;
					var startTime=0;
					for (k=0,n=keyframeCount;k < n;k++){
						var keyFrame=node.keyFrame[k]=
						{};
						keyFrame.duration=read.getFloat32();
						keyFrame.startTime=startTime;
						keyFrame.data=new Float32Array(keyframeDataCount);
						keyFrame.dData=new Float32Array(keyframeDataCount);
						keyFrame.nextData=new Float32Array(keyframeDataCount);
						for (l=0;l < keyframeDataCount;l++){
							keyFrame.data[l]=read.getFloat32();
							if (keyFrame.data[l] >-0.00000001 && keyFrame.data[l] < 0.00000001)keyFrame.data[l]=0;
						}
						startTime+=keyFrame.duration;
					}
					node.playTime=startTime;
					this._calculateKeyFrame(node,keyframeCount,keyframeDataCount);
					this._calculateKeyFrameIndex(node,playbackRate);
				}
			}
			this._loaded=true;
			this.event(/*laya.events.Event.LOADED*/"loaded",this);
		}

		__proto._calculateKeyFrame=function(node,keyframeCount,keyframeDataCount){
			var keyFrames=node.keyFrame;
			keyFrames[keyframeCount]=keyFrames[0];
			for (var i=0;i < keyframeCount;i++){
				var keyFrame=keyFrames[i];
				for (var j=0;j < keyframeDataCount;j++){
					keyFrame.dData[j]=(keyFrame.duration===0)? 0 :(keyFrames[i+1].data[j]-keyFrame.data[j])/ keyFrame.duration;
					keyFrame.nextData[j]=keyFrames[i+1].data[j];
				}
			}
			keyFrames.length--;
		}

		__proto._calculateKeyFrameIndex=function(node,playbackRate){
			var frameInterval=1000 / playbackRate;
			node.frameCount=Math.floor(node.playTime / frameInterval);
			node.fullFrame=new Uint16Array(node.frameCount+1);
			for (var i=0,n=node.keyFrame.length;i < n;i++){
				var keyFrame=node.keyFrame[i];
				var tm=keyFrame.startTime;
				var endTm=tm+keyFrame.duration+frameInterval;
				do {
					node.fullFrame[Math.floor(tm / frameInterval+0.5)]=i;
					tm+=frameInterval;
				}while (tm <=endTm);
			}
		}

		__proto.getAnimationCount=function(){
			return this._anis.length;
		}

		__proto.getAnimation=function(aniIndex){
			return this._anis[aniIndex];
		}

		__proto.getAniDuration=function(aniIndex){
			return this._anis[aniIndex].playTime;
		}

		__proto.getNodes=function(aniIndex){
			return this._anis[aniIndex].nodes;
		}

		__proto.getNodeIndexWithName=function(aniIndex,name){
			return this._anis[aniIndex].bone3DMap[name];
		}

		__proto.getNodeCount=function(aniIndex){
			return this._anis[aniIndex].nodes.length;
		}

		__proto.getTotalkeyframesLength=function(aniIndex){
			return this._anis[aniIndex].totalKeyframesLength;
		}

		__proto.getPublicExtData=function(){
			return this._publicExtData;
		}

		__proto.getAnimationDataWithCache=function(cacheDatas,aniIndex,frameIndex){
			var cache=cacheDatas[aniIndex];
			return cache ? cache[frameIndex] :null;
		}

		__proto.setAnimationDataWithCache=function(cacheDatas,aniIndex,frameIndex,data){
			var cache=cacheDatas[aniIndex];
			cache || (cache=cacheDatas[aniIndex]=[],cache.length=30);
			cache[frameIndex] || (cache[frameIndex]=new Float32Array(data.length));
			cache[frameIndex].set(data,0);
		}

		__proto.getOriginalData=function(aniIndex,originalData,frameIndex,playCurTime){
			var oneAni=this._anis[aniIndex];
			var nodes=oneAni.nodes;
			var j=0;
			for (var i=0,n=nodes.length,outOfs=0;i < n;i++){
				var node=nodes[i];
				var key;
				key=node.keyFrame[node.fullFrame[frameIndex]];
				node.dataOffset=outOfs;
				var dt=playCurTime-key.startTime;
				for (j=0;j < node.keyframeWidth;){
					j+=node.interpolationMethod[j](node,j,originalData,outOfs+j,key.data,dt,key.dData,key.duration,key.nextData);
				}
				outOfs+=node.keyframeWidth;
			}
		}

		__proto.getNodesCurrentFrameIndex=function(aniIndex,playCurTime){
			var ani=this._anis[aniIndex];
			var nodes=ani.nodes;
			if (aniIndex!==this.unfixedLastAniIndex){
				this.unfixedCurrentFrameIndexes=new Uint32Array(nodes.length);
				this.unfixedCurrentTimes=new Float32Array(nodes.length);
				this.unfixedLastAniIndex=aniIndex;
			}
			for (var i=0,n=nodes.length,outOfs=0;i < n;i++){
				var node=nodes[i];
				if (playCurTime < this.unfixedCurrentTimes[i])
					this.unfixedCurrentFrameIndexes[i]=0;
				this.unfixedCurrentTimes[i]=playCurTime;
				while ((this.unfixedCurrentFrameIndexes[i] < node.keyFrame.length)){
					if (node.keyFrame[this.unfixedCurrentFrameIndexes[i]].startTime > this.unfixedCurrentTimes[i])
						break ;
					this.unfixedCurrentFrameIndexes[i]++;
				}
				this.unfixedCurrentFrameIndexes[i]--;
			}
			return this.unfixedCurrentFrameIndexes;
		}

		__proto.getOriginalDataUnfixedRate=function(aniIndex,originalData,playCurTime){
			var oneAni=this._anis[aniIndex];
			var nodes=oneAni.nodes;
			if (aniIndex!==this.unfixedLastAniIndex){
				this.unfixedCurrentFrameIndexes=new Uint32Array(nodes.length);
				this.unfixedCurrentTimes=new Float32Array(nodes.length);
				this.unfixedKeyframes=__newvec(nodes.length);
				this.unfixedLastAniIndex=aniIndex;
			};
			var j=0;
			for (var i=0,n=nodes.length,outOfs=0;i < n;i++){
				var node=nodes[i];
				if (playCurTime < this.unfixedCurrentTimes[i])
					this.unfixedCurrentFrameIndexes[i]=0;
				this.unfixedCurrentTimes[i]=playCurTime;
				while (this.unfixedCurrentFrameIndexes[i] < node.keyFrame.length){
					if (node.keyFrame[this.unfixedCurrentFrameIndexes[i]].startTime > this.unfixedCurrentTimes[i])
						break ;
					this.unfixedKeyframes[i]=node.keyFrame[this.unfixedCurrentFrameIndexes[i]];
					this.unfixedCurrentFrameIndexes[i]++;
				};
				var key=this.unfixedKeyframes[i];
				node.dataOffset=outOfs;
				var dt=playCurTime-key.startTime;
				for (j=0;j < node.keyframeWidth;){
					j+=node.interpolationMethod[j](node,j,originalData,outOfs+j,key.data,dt,key.dData,key.duration,key.nextData);
				}
				outOfs+=node.keyframeWidth;
			}
		}

		__getset(0,__proto,'loaded',function(){
			return this._loaded;
		});

		KeyframesAniTemplet._LinearInterpolation_0=function(bone,index,out,outOfs,data,dt,dData,duration,nextData){
			out[outOfs]=data[index]+dt *dData[index];
			return 1;
		}

		KeyframesAniTemplet._QuaternionInterpolation_1=function(bone,index,out,outOfs,data,dt,dData,duration,nextData){
			MathUtil.slerpQuaternionArray(data,index,nextData,index,dt / duration,out,outOfs);
			return 4;
		}

		KeyframesAniTemplet._AngleInterpolation_2=function(bone,index,out,outOfs,data,dt,dData,duration,nextData){
			return 0;
		}

		KeyframesAniTemplet._RadiansInterpolation_3=function(bone,index,out,outOfs,data,dt,dData,duration,nextData){
			return 0;
		}

		KeyframesAniTemplet._Matrix4x4Interpolation_4=function(bone,index,out,outOfs,data,dt,dData,duration,nextData){
			for (var i=0;i < 16;i++,index++)
			out[outOfs+i]=data[index]+dt *dData[index];
			return 16;
		}

		KeyframesAniTemplet.interpolation=[KeyframesAniTemplet._LinearInterpolation_0,KeyframesAniTemplet._QuaternionInterpolation_1,KeyframesAniTemplet._AngleInterpolation_2,KeyframesAniTemplet._RadiansInterpolation_3,KeyframesAniTemplet._Matrix4x4Interpolation_4];
		return KeyframesAniTemplet;
	})(EventDispatcher)


	/**
	*动画模板类
	*/
	//class laya.ani.bone.Templet extends laya.ani.KeyframesAniTemplet
	var Templet=(function(_super){
		function Templet(skeletonData,texture,playbackRate){
			this._mainTexture=null;
			this._textureJson=null;
			this._graphicsCache=[];
			this.srcBoneMatrixArr=[];
			this.boneSlotDic={};
			this.boneSlotArray=[];
			this.skinDataArray=[];
			this.subTextureDic={};
			this._rate=60;
			Templet.__super.call(this);
			(playbackRate===void 0)&& (playbackRate=60);
			if (skeletonData && texture){
				this.parseData(texture,skeletonData,playbackRate);
			}
		}

		__class(Templet,'laya.ani.bone.Templet',_super);
		var __proto=Templet.prototype;
		/**
		*解析骨骼动画数据
		*@param skeletonData 骨骼动画信息及纹理分块信息
		*@param texture 骨骼动画用到的纹理
		*@param playbackRate 缓冲的帧率数据（会根据帧率去分帧）
		*/
		__proto.parseData=function(texture,skeletonData,playbackRate){
			(playbackRate===void 0)&& (playbackRate=60);
			this._mainTexture=texture;
			this._rate=playbackRate;
			this.parse(skeletonData,playbackRate);
		}

		/**
		*创建动画
		*@return
		*/
		__proto.buildArmature=function(){
			return new Skeleton(this);
		}

		/**
		*解析动画
		*@param data
		*@param playbackRate
		*/
		__proto.parse=function(data,playbackRate){
			_super.prototype.parse.call(this,data,playbackRate);
			this._parsePublicExtData();
			this.event(/*laya.events.Event.COMPLETE*/"complete",this);
		}

		/**
		*解析自定义数据
		*/
		__proto._parsePublicExtData=function(){
			var i=0,j=0,k=0,n=0;
			for (i=0,n=this.getAnimationCount();i < n;i++){
				this._graphicsCache.push([]);
			};
			var tByte=new Byte(this.getPublicExtData());
			var tX=0,tY=0,tWidth=0,tHeight=0;
			var tFrameX=0,tFrameY=0,tFrameWidth=0,tFrameHeight=0;
			var tTextureLen=tByte.getUint8();
			var tTextureName=tByte.readUTFString();
			var tTextureNameArr=tTextureName.split("\n");
			for (i=0;i < tTextureLen;i++){
				tTextureName=tTextureNameArr[i];
				tX=tByte.getFloat32();
				tY=tByte.getFloat32();
				tWidth=tByte.getFloat32();
				tHeight=tByte.getFloat32();
				tFrameX=tByte.getFloat32();
				tFrameY=tByte.getFloat32();
				tFrameWidth=tByte.getFloat32();
				tFrameHeight=tByte.getFloat32();
				this.subTextureDic[tTextureName]=Texture.create(this._mainTexture,tX,tY,tWidth,tHeight,-tFrameX,-tFrameY,tFrameWidth,tFrameHeight);
			};
			var tMatrixDataLen=tByte.getUint16();
			var tLen=tByte.getUint16();
			var parentIndex=0;
			var bones=this.getNodes(0);
			var boneLength=bones.length;
			var tMatrixArray=this.srcBoneMatrixArr;
			for (i=0;i < boneLength;i++){
				var tResultTransform=new Transform();
				tResultTransform.scX=tByte.getFloat32();
				tResultTransform.skX=tByte.getFloat32();
				tResultTransform.skY=tByte.getFloat32();
				tResultTransform.scY=tByte.getFloat32();
				tResultTransform.x=tByte.getFloat32();
				tResultTransform.y=tByte.getFloat32();
				tMatrixArray.push(tResultTransform);
			};
			var tBoneSlotLen=tByte.getInt16();
			for (i=0;i < tBoneSlotLen;i++){
				var tDBBoneSlot=new BoneSlot();
				var tName=tByte.readUTFString();
				var tParent=tByte.readUTFString();
				var tDisplayIndex=tByte.getInt16();
				this.boneSlotDic[tParent]=tDBBoneSlot;
				this.boneSlotArray.push(tDBBoneSlot);
			};
			var tNameString=tByte.readUTFString();
			var tNameArray=tNameString.split("\n");
			var tNameStartIndex=0;
			var tSkinDataLen=tByte.getUint8();
			for (i=0;i < tSkinDataLen;i++){
				var tSkinData=new SkinData();
				tSkinData.name=tNameArray[tNameStartIndex++];
				var tSlotDataLen=tByte.getUint8();
				for (j=0;j < tSlotDataLen;j++){
					var tSlotData=new SlotData();
					tSlotData.name=tNameArray[tNameStartIndex++];
					var tDisplayDataLen=tByte.getUint8();
					for (k=0;k < tDisplayDataLen;k++){
						var tDisplayData=new SkinSlotDisplayData();
						tDisplayData.name=tNameArray[tNameStartIndex++];
						tDisplayData.transform=new Transform();
						tDisplayData.transform.scX=tByte.getFloat32();
						tDisplayData.transform.skX=tByte.getFloat32();
						tDisplayData.transform.skY=tByte.getFloat32();
						tDisplayData.transform.scY=tByte.getFloat32();
						tDisplayData.transform.x=tByte.getFloat32();
						tDisplayData.transform.y=tByte.getFloat32();
						tSlotData.displayArr.push(tDisplayData);
					}
					tSkinData.slotArr.push(tSlotData);
				}
				this.skinDataArray.push(tSkinData);
			}
		}

		/**
		*得到缓冲数据
		*@param aniIndex
		*@param frameIndex
		*@return
		*/
		__proto.getGrahicsDataWithCache=function(aniIndex,frameIndex){
			return this._graphicsCache[aniIndex][frameIndex];
		}

		/**
		*保存缓冲grahpics
		*@param aniIndex
		*@param frameIndex
		*@param graphics
		*/
		__proto.setGrahicsDataWithCache=function(aniIndex,frameIndex,graphics){
			console.log("aniIndex:"+aniIndex.toString()+" frameIndex:"+frameIndex.toString());
			this._graphicsCache[aniIndex][frameIndex]=graphics;
		}

		/**
		*预留
		*/
		__proto.destory=function(){}
		/**
		*通过索引得动画名称
		*@param index
		*@return
		*/
		__proto.getAniNameByIndex=function(index){
			var tAni=this.getAnimation(index);
			if (tAni)return tAni.name;
			return null;
		}

		__getset(0,__proto,'rate',function(){
			return this._rate;
		});

		__getset(0,__proto,'textureWidth',function(){
			if (this._mainTexture){
				return this._mainTexture.sourceWidth;
			}
			return 0;
		});

		__getset(0,__proto,'textureHeight',function(){
			if (this._mainTexture){
				return this._mainTexture.sourceHeight;
			}
			return 0;
		});

		return Templet;
	})(KeyframesAniTemplet)


	/**
	*骨骼动画由KeyframesAniTemplet(LayaFactory),AnimationPlayer,Armature三部分组成
	*/
	//class laya.ani.bone.Skeleton extends laya.display.Sprite
	var Skeleton=(function(_super){
		function Skeleton(templet){
			this._templet=null;
			this._player=null;
			this._curOriginalData=null;
			this._boneMatrixArray=[];
			this._lastTime=0;
			this._currAniName=null;
			this._currAniIndex=-1;
			this._pause=false;
			this._aniClipIndex=-1;
			this._clipIndex=-1;
			Skeleton.__super.call(this);
			this._tempTransform=new Transform();
			if(templet)
				this.init(templet,templet.rate);
		}

		__class(Skeleton,'laya.ani.bone.Skeleton',_super);
		var __proto=Skeleton.prototype;
		/**
		*初始化动画
		*@param templet
		*/
		__proto.init=function(templet,rate){
			this._templet=templet;
			this._player=new AnimationPlayer(rate);
			this._player.templet=templet;
			this._player.play();
			this.parseSrcBoneMatrix();
			this._lastTime=Browser.now();
			Laya.stage.frameLoop(1,this,this.update,null,true);
		}

		/**
		*创建骨骼的矩阵，保证每次计算的最终结果
		*/
		__proto.parseSrcBoneMatrix=function(){
			var tBoneLen=this._templet.getNodeCount(0);
			for (var i=0;i < tBoneLen;i++){
				this._boneMatrixArray.push(new Matrix());
			}
			this.showSkinByIndex(0);
		}

		/**
		*更新动画
		*/
		__proto.update=function(){
			if (this._pause)return;
			var tCurrTime=Laya.stage.now;
			this._player.update(tCurrTime-this._lastTime);
			this._lastTime=tCurrTime;
			this._aniClipIndex=this._player.currentAnimationClipIndex;
			this._clipIndex=this._player.currentKeyframeIndex;
			if (this._aniClipIndex==-1)return;
			var tGraphics=this._templet.getGrahicsDataWithCache(this._aniClipIndex,this._clipIndex);
			if (tGraphics){
				this.graphics=tGraphics;
				return;
			}
			this.createGraphics();
		}

		/**
		*创建grahics图像
		*/
		__proto.createGraphics=function(){
			var bones=this._templet.getNodes(this._aniClipIndex);
			var boneCount=bones.length;
			this._curOriginalData || (this._curOriginalData=new Float32Array(this._templet.getTotalkeyframesLength(0)));
			this._templet.getOriginalData(this._aniClipIndex,this._curOriginalData,this._clipIndex,this._player.currentFrameTime);
			var tParentMatrix;
			var tResultMatrix;
			var tStartIndex=0;
			var i=0,j=0,k=0,n=0;
			var tDBBoneSlot;
			var tTempMatrix;
			var tParentTransform;
			for (i=0;i < boneCount;i++){
				tResultMatrix=this._boneMatrixArray[i];
				tStartIndex=i *6;
				tParentTransform=this._templet.srcBoneMatrixArr[i];
				this._tempTransform.scX=tParentTransform.scX *this._curOriginalData[tStartIndex];
				this._tempTransform.skX=tParentTransform.skX+this._curOriginalData[tStartIndex+1];
				this._tempTransform.skY=tParentTransform.skY+this._curOriginalData[tStartIndex+2];
				this._tempTransform.scY=tParentTransform.scY *this._curOriginalData[tStartIndex+3];
				this._tempTransform.x=tParentTransform.x+this._curOriginalData[tStartIndex+4];
				this._tempTransform.y=tParentTransform.y+this._curOriginalData[tStartIndex+5];
				tTempMatrix=this._tempTransform.getMatrix();
				var tBone=bones[i];
				if (tBone.parentIndex !=-1){
					tParentMatrix=this._boneMatrixArray[tBone.parentIndex];
					Matrix.mul(tTempMatrix,tParentMatrix,tResultMatrix);
					}else {
					tTempMatrix.copy(tResultMatrix);
				}
				tDBBoneSlot=this._templet.boneSlotDic[tBone.name];
				if (tDBBoneSlot){
					tDBBoneSlot.setParentMatrix(tResultMatrix);
				}
			};
			var tGraphics;
			this.graphics=tGraphics=new Graphics();
			for (i=0,n=this._templet.boneSlotArray.length;i < n;i++){
				tDBBoneSlot=this._templet.boneSlotArray[i];
				tDBBoneSlot.draw(tGraphics);
			}
			this._templet.setGrahicsDataWithCache(this._aniClipIndex,this._clipIndex,tGraphics);
		}

		/**
		*得到当前动画的数量
		*@return
		*/
		__proto.getAnimNum=function(){
			return this._templet.getAnimationCount();
		}

		/**
		*得到指定动画的名字
		*@param index
		*/
		__proto.getAniNameByIndex=function(index){
			return this._templet.getAniNameByIndex(index);
		}

		__proto.getSlotByName=function(name){
			return null;
		}

		/**
		*
		*@param skinIndex
		*/
		__proto.showSkinByIndex=function(skinIndex){
			if (skinIndex < this._templet.skinDataArray.length){
				var tDBSkinData;
				var tDBSlotData;
				var tDBDisplayData;
				tDBSkinData=this._templet.skinDataArray[skinIndex];
				for (var i=0,n=tDBSkinData.slotArr.length;i < n;i++){
					tDBSlotData=tDBSkinData.slotArr[i];
					var tDBBoneSlot=this._templet.boneSlotDic[tDBSlotData.name];
					for (var j=0;j < tDBSlotData.displayArr.length;j++){
						tDBDisplayData=tDBSlotData.displayArr[j];
						var tTexture=this._templet.subTextureDic[tDBDisplayData.name];
						tDBBoneSlot.addSprite(tTexture,tDBDisplayData);
					}
				}
			}
		}

		/**
		*根据动画，播放指定的动画
		*@param name
		*@param duration 播放时长（Number.MAX_VALUE为循环播放，0为1次）
		*/
		__proto.gotoAndPlay=function(name,duration){
			(duration===void 0)&& (duration=Number.MAX_VALUE);
			for (var i=0,n=this._templet.getAnimationCount();i < n;i++){
				var animation=this._templet.getAnimation(i);
				if (animation && name==animation.name){
					this.gotoAndPlayByIndex(i,duration);
					return;
				}
			}
		}

		/**
		*通过动画索引，播放指定的动画
		*@param index
		*@param duration 播放时长（Number.MAX_VALUE为循环播放，0为1次）
		*/
		__proto.gotoAndPlayByIndex=function(index,duration){
			(duration===void 0)&& (duration=Number.MAX_VALUE);
			if (index >-1 && index < this.getAnimNum()){
				if (this._currAniIndex !=index){
					this._currAniIndex=index;
					this._player.play(index,1,duration);
				}
			}
		}

		/**
		*播放动画
		*/
		__proto.play=function(){
			if (this._currAniIndex==-1 && this.getAnimNum()> 0){
				this._currAniIndex=0;
				this.gotoAndPlayByIndex(this._currAniIndex);
			}
			this._pause=false;
		}

		/**
		*停止动画
		*/
		__proto.stop=function(){
			this._pause=true;
		}

		/**
		*销毁当前动画
		*/
		__proto.destory=function(){
			this._templet=null;
			this._player=null;
			this._curOriginalData=null;
			this._boneMatrixArray.length=0;
			this._lastTime=0;
			Laya.timer.clear(this,this.update);
		}

		__proto.stAnimName=function(name){
			this.gotoAndPlay(name);
			this.stop();
		}

		return Skeleton;
	})(Sprite)


	/**
	*<p> <code>MovieClip</code> 用于播放经过工具处理后的 swf 动画。</p>
	*/
	//class laya.ani.swf.MovieClip extends laya.display.Sprite
	var MovieClip=(function(_super){
		function MovieClip(){
			this.interval=30;
			this._start=0;
			this._Pos=0;
			this._data=null;
			this._curIndex=0;
			this._playIndex=0;
			this._playing=false;
			this._ended=true;
			this._frameCount=0;
			this._ids=null;
			this._idOfSprite=null;
			this.basePath=null;
			MovieClip.__super.call(this);
			this._ids={};
			this._idOfSprite=[];
			this._reset();
			this._playing=false;
		}

		__class(MovieClip,'laya.ani.swf.MovieClip',_super);
		var __proto=MovieClip.prototype;
		/**
		*动画的帧更新处理函数。
		*/
		__proto.update=function(){
			if (!this._data)return;
			if (!this._playing)
				return;
			this._playIndex++;
			if (this._playIndex >=this.totalFrames)this._playIndex=0;
			this._parse(this._playIndex);
		}

		/**
		*停止播放动画。
		*/
		__proto.stop=function(){
			this._playing=false;
			Laya.timer.clear(this,this.update);
		}

		/**
		*将动画立即停止在指定帧。
		*@param frame 帧索引。
		*/
		__proto.gotoStop=function(frame){
			this.stop();
			this._displayFrame(frame);
		}

		/**
		*清理。
		*/
		__proto.clear=function(){
			this._idOfSprite.length=0;
			this.removeChildren();
			this.graphics=null;
		}

		/**
		*播放动画。
		*@param frameIndex 帧索引。
		*/
		__proto.play=function(frameIndex){
			(frameIndex===void 0)&& (frameIndex=-1);
			this._displayFrame(frameIndex);
			this._playing=true;
			Laya.timer.loop(this.interval,this,this.update,null,true);
		}

		__proto._displayFrame=function(frameIndex){
			(frameIndex===void 0)&& (frameIndex=-1);
			if (frameIndex !=-1){
				if (this._curIndex > frameIndex)
					this._reset();
				this._parse(frameIndex);
			}
		}

		__proto._reset=function(rm){
			(rm===void 0)&& (rm=true);
			if (rm && this._curIndex !=1)
				this.removeChildren();
			this._curIndex=-1;
			this._Pos=this._start;
		}

		__proto._parse=function(frameIndex){
			var curChild=this;
			var mc,sp,key=0,type=0,tPos=0,ttype=0,ifAdd=false;
			var _idOfSprite=this._idOfSprite,_data=this._data,eStr;
			if (this._ended)
				this._reset();
			_data.pos=this._Pos;
			this._ended=false;
			this._playIndex=frameIndex;
			if (this._curIndex >=frameIndex)this._curIndex=-1;
			while ((this._curIndex <=frameIndex)&& (!this._ended)){
				type=_data.getUint16();
				switch (type){
					case 12:
						key=_data.getUint16();
						tPos=this._ids[_data.getUint16()];
						this._Pos=_data.pos;
						_data.pos=tPos;
						if ((ttype=_data.getUint8())==0){
							var pid=_data.getUint16();
							sp=_idOfSprite[key]
							if (!sp){
								sp=_idOfSprite[key]=new Sprite();
								var spp=new Sprite();
								spp.loadImage(this.basePath+pid+".png");
								sp.addChild(spp);
								spp.size(_data.getFloat32(),_data.getFloat32());
								var mat=_data._getMatrix();
								spp.transform=mat;
							}
							}else if (ttype==1){
							mc=_idOfSprite[key]
							if (!mc){
								_idOfSprite[key]=mc=new MovieClip();
								mc.interval=this.interval;
								mc._ids=this._ids;
								mc._setData(_data,tPos);
								mc.basePath=this.basePath;
								mc.play(0);
							}
						}
						_data.pos=this._Pos;
						break ;
					case 3:
						(this.addChild(_idOfSprite[ _data.getUint16()])).zOrder=_data.getUint16();
						ifAdd=true;
						break ;
					case 4:
						_idOfSprite[ _data.getUint16()].removeSelf();
						break ;
					case 5:
						_idOfSprite[_data.getUint16()][MovieClip._ValueList[_data.getUint16()]]=(_data.getFloat32());
						break ;
					case 6:
						_idOfSprite[_data.getUint16()].visible=(_data.getUint8()> 0);
						break ;
					case 7:
						sp=_idOfSprite[ _data.getUint16()];
						var mt=new Matrix(_data.getFloat32(),_data.getFloat32(),_data.getFloat32(),_data.getFloat32(),_data.getFloat32(),_data.getFloat32());
						sp.transform=mt;
						break ;
					case 8:
						_idOfSprite[_data.getUint16()].setPos(_data.getFloat32(),_data.getFloat32());
						break ;
					case 9:
						_idOfSprite[_data.getUint16()].setSize(_data.getFloat32(),_data.getFloat32());
						break ;
					case 10:
						_idOfSprite[ _data.getUint16()].alpha=_data.getFloat32();
						break ;
					case 11:
						_idOfSprite[_data.getUint16()].setScale(_data.getFloat32(),_data.getFloat32());
						break ;
					case 98:
						eStr=_data.getString();
						this.event(eStr);
						if (eStr=="stop")
							this.stop();
						break ;
					case 99:
						this._curIndex=_data.getUint16();
						ifAdd && this.updateOrder();
						this._playing && this.event(/*laya.events.Event.ENTER_FRAME*/"enterframe");
						break ;
					case 100:
						this._frameCount=this._curIndex+1;
						this._ended=true;
						this.event(/*laya.events.Event.END*/"end");
						this._reset(false);
						break ;
					}
			}
			this._Pos=_data.pos;
		}

		/**@private */
		__proto._setData=function(data,start){
			this._data=data;
			this._start=start+3;
		}

		/**
		*加载资源。
		*@param url swf 资源地址。
		*/
		__proto.load=function(url){
			var _$this=this;
			url=URL.formatURL(url);
			this.basePath=url.split(".swf")[0]+"/image/";
			var data=Loader.getRes(url);
			if (data){
				this._initData(data);
				}else {
				var l=new Loader();
				l.once(/*laya.events.Event.COMPLETE*/"complete",null,function(data){
					_$this._initData(data);
				});
				l.once(/*laya.events.Event.ERROR*/"error",null,function(err){
				});
				l.load(url,/*laya.net.Loader.BUFFER*/"arraybuffer");
			}
		}

		__proto._initData=function(data){
			this._data=new Byte(data);
			var i=0,len=this._data.getUint16();
			for (i=0;i < len;i++)
			this._ids[this._data.getInt16()]=this._data.getInt32();
			this.interval=1000 / this._data.getUint16();
			this._setData(this._data,this._ids[32767]);
			this._reset();
			this._ended=false;
			while (!this._ended)this._parse(++this._playIndex);
			this.play(0);
			this.event(/*laya.events.Event.LOADED*/"loaded");
		}

		/**
		*当前动画帧索引。
		*/
		__getset(0,__proto,'currentFrame',function(){
			return this._playIndex;
		});

		/**
		*帧总数。
		*/
		__getset(0,__proto,'totalFrames',function(){
			return this._frameCount;
		});

		/**
		*资源地址。
		*/
		__getset(0,__proto,'url',null,function(path){
			this.load(path);
		});

		MovieClip._ValueList=["x","y","width","height","scaleX","scaleY","rotation","alpha"];
		return MovieClip;
	})(Sprite)


	/**
	*<p> <code>SkeletonPlayer</code> 用于播放经过工具处理后的骨骼动画。</p>
	*/
	//class laya.ani.bone.SkeletonPlayer extends laya.ani.bone.Skeleton
	var SkeletonPlayer=(function(_super){
		function SkeletonPlayer(tmplete){
			this.completeHandler=null;
			this.dataUrl=null;
			this.imgUrl=null;
			SkeletonPlayer.__super.call(this,tmplete);
			this.on(/*laya.events.Event.COMPLETE*/"complete",this,this._complete);
		}

		__class(SkeletonPlayer,'laya.ani.bone.SkeletonPlayer',_super);
		var __proto=SkeletonPlayer.prototype;
		__proto._complete=function(){
			if (this.completeHandler){
				var tHd;
				tHd=this.completeHandler;
				this.completeHandler=null;
				tHd.run();
			}
		}

		/**
		*加载资源。
		*@param baseURL 资源地址。
		*/
		__proto.load=function(baseURL){
			this.dataUrl=baseURL;
			this.imgUrl=baseURL.replace(".sk",".png");
			Laya.loader.load([{url:this.dataUrl,type:/*laya.net.Loader.BUFFER*/"arraybuffer"},{url:this.imgUrl,type:/*laya.net.Loader.IMAGE*/"image"}],Handler.create(this,this._resLoaded));
		}

		__proto._resLoaded=function(){
			var _templet
			_templet=new Templet(Loader.getRes(this.dataUrl),Loader.getRes(this.imgUrl));
			this.init(_templet,_templet.rate);
		}

		/**
		*资源地址。
		*/
		__getset(0,__proto,'url',null,function(path){
			this.load(path);
		});

		return SkeletonPlayer;
	})(Skeleton)



})(window,document,Laya);
