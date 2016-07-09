
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Browser=laya.utils.Browser,Byte=laya.utils.Byte,Event=laya.events.Event,EventDispatcher=laya.events.EventDispatcher;
	var Graphics=laya.display.Graphics,Handler=laya.utils.Handler,Loader=laya.net.Loader,MathUtil=laya.maths.MathUtil;
	var Matrix=laya.maths.Matrix,Sprite=laya.display.Sprite,Stat=laya.utils.Stat,Texture=laya.resource.Texture;
	var URL=laya.net.URL;
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
			this.name=null;
			this.parent=null;
			this.srcDisplayIndex=-1;
			this.type="src";
			this.templet=null;
			this.currSlotData=null;
			this.currTexture=null;
			this.currDisplayData=null;
			this.displayIndex=-1;
			this._diyTexture=null;
			this._parentMatrix=null;
			this._resultMatrix=null;
		}

		__class(BoneSlot,'laya.ani.bone.BoneSlot');
		var __proto=BoneSlot.prototype;
		/**
		*设置要显示的插槽数据
		*@param slotData
		*@param disIndex
		*/
		__proto.showSlotData=function(slotData){
			this.currSlotData=slotData;
			this.displayIndex=this.srcDisplayIndex;
			this.currDisplayData=null;
			this.currTexture=null;
		}

		/**
		*指定显示对象
		*@param index
		*/
		__proto.showDisplayByIndex=function(index){
			if (this.currSlotData && index >-1 && index < this.currSlotData.displayArr.length){
				this.displayIndex=index;
				this.currDisplayData=this.currSlotData.displayArr[index];
				if (this.currDisplayData){
					this.currTexture=this.templet.getTexture(this.currDisplayData.name);
				}
				}else {
				this.displayIndex=-1;
				this.currDisplayData=null;
				this.currTexture=null;
			}
		}

		/**
		*替换皮肤
		*@param _texture
		*/
		__proto.replaceSkin=function(_texture){
			this._diyTexture=_texture;
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
		*@param noUseSave
		*/
		__proto.draw=function(graphics,noUseSave){
			(noUseSave===void 0)&& (noUseSave=false);
			if ((this._diyTexture==null && this.currTexture==null)|| this.currDisplayData==null)return;
			var tTexture=this.currTexture;
			if (this._diyTexture)tTexture=this._diyTexture;
			if (graphics){
				var tCurrentMatrix=this.getDisplayMatrix();
				if (this._parentMatrix){
					if (tCurrentMatrix){
						Matrix.mul(tCurrentMatrix,this._parentMatrix,Matrix.TEMP);
						var tResultMatrix;
						if (noUseSave){
							if(this._resultMatrix==null)this._resultMatrix=new Matrix();
							tResultMatrix=this._resultMatrix;
							}else {
							tResultMatrix=new Matrix();
						}
						Matrix.TEMP.copyTo(tResultMatrix);
						graphics.drawTexture(tTexture,-tTexture.sourceWidth / 2,-tTexture.sourceHeight / 2,tTexture.sourceWidth,tTexture.sourceHeight,tResultMatrix);
					}
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

		/**
		*得到插糟的矩阵
		*@return
		*/
		__proto.getMatrix=function(){
			return this._resultMatrix;
		}

		/**
		*用原始数据拷贝出一个
		*@return
		*/
		__proto.copy=function(){
			var tBoneSlot=new BoneSlot();
			tBoneSlot.type="copy";
			tBoneSlot.name=this.name;
			tBoneSlot.srcDisplayIndex=this.srcDisplayIndex;
			tBoneSlot.parent=this.parent;
			tBoneSlot.displayIndex=this.displayIndex;
			tBoneSlot.templet=this.templet;
			tBoneSlot.currSlotData=this.currSlotData;
			tBoneSlot.currTexture=this.currTexture;
			tBoneSlot.currDisplayData=this.currDisplayData;
			return tBoneSlot;
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
			(duration===void 0)&& (duration=1.7976931348623157e+308);
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
		*获取缓存帧率间隔时间
		*@return 缓存帧率间隔时间
		*/
		__getset(0,__proto,'cacheFrameRateInterval',function(){
			return this._cacheFrameRateInterval;
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
				var name=ani.name=strList[read.getUint16()];
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
					node.parentIndex==-1 ? node.parent=null :node.parent=ani.nodes[node.parentIndex];
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
					node.playTime=ani.playTime;
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
			var lastFrameIndex=-1;
			for (var i=0,n=node.keyFrame.length;i < n;i++){
				var keyFrame=node.keyFrame[i];
				var tm=keyFrame.startTime;
				var endTm=tm+keyFrame.duration+frameInterval;
				do {
					var frameIndex=Math.floor(tm / frameInterval+0.5);
					for (var k=lastFrameIndex+1;k < frameIndex;k++)
					node.fullFrame[k]=i;
					lastFrameIndex=frameIndex;
					node.fullFrame[frameIndex]=i;
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

		KeyframesAniTemplet._NoInterpolation_5=function(bone,index,out,outOfs,data,dt,dData,duration,nextData){
			out[outOfs]=data[index];
			return 1;
		}

		KeyframesAniTemplet._uniqueIDCounter=1;
		KeyframesAniTemplet.interpolation=[KeyframesAniTemplet._LinearInterpolation_0,KeyframesAniTemplet._QuaternionInterpolation_1,KeyframesAniTemplet._AngleInterpolation_2,KeyframesAniTemplet._RadiansInterpolation_3,KeyframesAniTemplet._Matrix4x4Interpolation_4,KeyframesAniTemplet._NoInterpolation_5];
		KeyframesAniTemplet.LAYA_ANIMATION_VISION="LAYAANIMATION:1.0.0";
		return KeyframesAniTemplet;
	})(EventDispatcher)


	/**
	*动画模板类
	*/
	//class laya.ani.bone.Templet extends laya.ani.KeyframesAniTemplet
	var Templet=(function(_super){
		function Templet(){
			this._mainTexture=null;
			this._textureJson=null;
			this._graphicsCache=[];
			this.srcBoneMatrixArr=[];
			this.boneSlotDic={};
			this.bindBoneBoneSlotDic={};
			this.boneSlotArray=[];
			this.skinDataArray=[];
			this.skinDic={};
			this.subTextureDic={};
			this.isParseFail=false;
			this.url=null;
			this._rate=60;
			Templet.__super.call(this);
		}

		__class(Templet,'laya.ani.bone.Templet',_super);
		var __proto=Templet.prototype;
		/**
		*解析骨骼动画数据
		*@param texture 骨骼动画用到的纹理
		*@param skeletonData 骨骼动画信息及纹理分块信息
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
		*0,使用模板缓冲的数据，模板缓冲的数据，不允许修改 （内存开销小，计算开销小，不支持换装）
		*1,使用动画自己的缓冲区，每个动画都会有自己的缓冲区，相当耗费内存 （内存开销大，计算开销小，支持换装）
		*2,使用动态方式，去实时去画 （内存开销小，计算开销大，支持换装,不建议使用）
		*@param aniMode 0 动画模式，0:不支持换装,1,2支持换装
		*@return
		*/
		__proto.buildArmature=function(aniMode){
			(aniMode===void 0)&& (aniMode=0);
			return new Skeleton(this,aniMode);
		}

		/**
		*@private
		*解析动画
		*@param data 解析的二进制数据
		*@param playbackRate 帧率
		*/
		__proto.parse=function(data,playbackRate){
			_super.prototype.parse.call(this,data,playbackRate);
			if (this._loaded){
				this._parsePublicExtData();
				this.event(/*laya.events.Event.COMPLETE*/"complete",this);
				}else {
				this.event(/*laya.events.Event.ERROR*/"error",this);
				this.isParseFail=true;
			}
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
			var tTempleData=0;
			var tTextureLen=tByte.getUint8();
			var tTextureName=tByte.readUTFString();
			var tTextureNameArr=tTextureName.split("\n");
			for (i=0;i < tTextureLen;i++){
				tTextureName=tTextureNameArr[i];
				tX=tByte.getFloat32();
				tY=tByte.getFloat32();
				tWidth=tByte.getFloat32();
				tHeight=tByte.getFloat32();
				tTempleData=tByte.getFloat32();
				tFrameX=isNaN(tTempleData)? 0 :tTempleData;
				tTempleData=tByte.getFloat32();
				tFrameY=isNaN(tTempleData)? 0 :tTempleData;
				tTempleData=tByte.getFloat32();
				tFrameWidth=isNaN(tTempleData)? tWidth :tTempleData;
				tTempleData=tByte.getFloat32();
				tFrameHeight=isNaN(tTempleData)? tHeight :tTempleData;
				this.subTextureDic[tTextureName]=Texture.create(this._mainTexture,tX,tY,tWidth,tHeight,-tFrameX,-tFrameY,tFrameWidth,tFrameHeight);
			};
			var tMatrixDataLen=tByte.getUint16();
			var tLen=tByte.getUint16();
			var parentIndex=0;
			var boneLength=Math.floor(tLen / tMatrixDataLen);
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
			var tDBBoneSlot;
			var tDBBoneSlotArr;
			for (i=0;i < tBoneSlotLen;i++){
				tDBBoneSlot=new BoneSlot();
				tDBBoneSlot.name=tByte.readUTFString();
				tDBBoneSlot.parent=tByte.readUTFString();
				tDBBoneSlot.srcDisplayIndex=tDBBoneSlot.displayIndex=tByte.getInt16();
				tDBBoneSlot.templet=this;
				this.boneSlotDic[tDBBoneSlot.name]=tDBBoneSlot;
				tDBBoneSlotArr=this.bindBoneBoneSlotDic[tDBBoneSlot.parent];
				if (tDBBoneSlotArr==null){
					this.bindBoneBoneSlotDic[tDBBoneSlot.parent]=tDBBoneSlotArr=[];
				}
				tDBBoneSlotArr.push(tDBBoneSlot);
				this.boneSlotArray.push(tDBBoneSlot);
			}
			for (i=0;i < this.boneSlotArray.length;i++){
				tDBBoneSlot=this.boneSlotArray[i];
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
					tDBBoneSlot=this.boneSlotDic[tSlotData.name];
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
				this.skinDic[tSkinData.name]=tSkinData;
				this.skinDataArray.push(tSkinData);
			}
			this.showSkinByIndex(this.boneSlotDic,0);
		}

		/**
		*得到指定的纹理
		*@param name 纹理的名字
		*@return
		*/
		__proto.getTexture=function(name){
			return this.subTextureDic[name];
		}

		/**
		*@private
		*显示指定的皮肤
		*@param boneSlotDic 插糟字典的引用
		*@param skinIndex 皮肤的索引
		*/
		__proto.showSkinByIndex=function(boneSlotDic,skinIndex){
			if (skinIndex < 0 && skinIndex >=this.skinDataArray.length)return;
			var i=0,n=0;
			var tBoneSlot;
			var tSlotData;
			var tSkinData=this.skinDataArray[skinIndex];
			if (tSkinData){
				for (i=0,n=tSkinData.slotArr.length;i < n;i++){
					tSlotData=tSkinData.slotArr[i];
					if (tSlotData){
						tBoneSlot=boneSlotDic[tSlotData.name];
						if (tBoneSlot){
							tBoneSlot.showSlotData(tSlotData);
							tBoneSlot.showDisplayByIndex(tBoneSlot.displayIndex);
						}
					}
				}
			}
		}

		/**
		*@private
		*显示指定的皮肤
		*@param boneSlotDic 插糟字典的引用
		*@param skinName 皮肤的名字
		*/
		__proto.showSkinByName=function(boneSlotDic,skinName){
			var i=0,n=0;
			var tBoneSlot;
			var tSlotData;
			var tSkinData=this.skinDic[skinName];
			if (tSkinData){
				for (i=0,n=tSkinData.slotArr.length;i < n;i++){
					tSlotData=tSkinData.slotArr[i];
					if (tSlotData){
						tBoneSlot=boneSlotDic[tSlotData.name];
						if (tBoneSlot){
							tBoneSlot.showSlotData(tSlotData);
							tBoneSlot.showDisplayByIndex(tBoneSlot.displayIndex);
						}
					}
				}
			}
		}

		/**
		*@private
		*得到缓冲数据
		*@param aniIndex 动画索引
		*@param frameIndex 帧索引
		*@return
		*/
		__proto.getGrahicsDataWithCache=function(aniIndex,frameIndex){
			return this._graphicsCache[aniIndex][frameIndex];
		}

		/**
		*@private
		*保存缓冲grahpics
		*@param aniIndex 动画索引
		*@param frameIndex 帧索引
		*@param graphics 要保存的数据
		*/
		__proto.setGrahicsDataWithCache=function(aniIndex,frameIndex,graphics){
			this._graphicsCache[aniIndex][frameIndex]=graphics;
		}

		/**
		*预留
		*/
		__proto.destory=function(){
			if (this.url){
				delete Templet.TEMPLET_DICTIONARY[this.url];
			}
		}

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

		Templet.TEMPLET_DICTIONARY=null
		return Templet;
	})(KeyframesAniTemplet)


	/**
	*骨骼动画由Templet,AnimationPlayer,Skeleton三部分组成
	*/
	//class laya.ani.bone.Skeleton extends laya.display.Sprite
	var Skeleton=(function(_super){
		function Skeleton(templet,aniMode){
			this._templet=null;
			this._player=null;
			this._curOriginalData=null;
			this._boneMatrixArray=[];
			this._lastTime=0;
			this._currAniName=null;
			this._currAniIndex=-1;
			this._pause=true;
			this._aniClipIndex=-1;
			this._clipIndex=-1;
			this._aniMode=0;
			this._graphicsCache=null;
			this._boneSlotDic=null;
			this._bindBoneBoneSlotDic=null;
			this._boneSlotArray=null;
			this._index=-1;
			this._total=-1;
			this._indexControl=false;
			this._aniPath=null;
			this._texturePath=null;
			this._complete=null;
			this._loadAniMode=0;
			Skeleton.__super.call(this);
			this._tempTransform=new Transform();
			(aniMode===void 0)&& (aniMode=0);
			if (templet)this.init(templet,aniMode);
		}

		__class(Skeleton,'laya.ani.bone.Skeleton',_super);
		var __proto=Skeleton.prototype;
		/**
		*初始化动画
		*0,使用模板缓冲的数据，模板缓冲的数据，不允许修改 （内存开销小，计算开销小，不支持换装）
		*1,使用动画自己的缓冲区，每个动画都会有自己的缓冲区，相当耗费内存 （内存开销大，计算开销小，支持换装）
		*2,使用动态方式，去实时去画 （内存开销小，计算开销大，支持换装,不建议使用）
		*@param templet 模板
		*@param aniMode 动画模式，0:不支持换装,1,2支持换装
		*/
		__proto.init=function(templet,aniMode){
			(aniMode===void 0)&& (aniMode=0);
			if (aniMode==1){
				this._graphicsCache=[];
				for (var i=0,n=templet.getAnimationCount();i < n;i++){
					this._graphicsCache.push([]);
				}
			}
			this._aniMode=aniMode;
			this._templet=templet;
			this._player=new AnimationPlayer(templet.rate);
			this._player.templet=templet;
			this._player.play();
			this._parseSrcBoneMatrix();
			this._player.on(/*laya.events.Event.PLAYED*/"played",this,this._onPlay);
			this._player.on(/*laya.events.Event.STOPPED*/"stopped",this,this._onStop);
			this._player.on(/*laya.events.Event.PAUSED*/"paused",this,this._onPause);
		}

		/**
		*通过加载直接创建动画
		*@param path 要加载的动画文件路径
		*@param complete 加载完成的回调函数
		*@param aniMode 0,使用模板缓冲的数据，模板缓冲的数据，不允许修改（内存开销小，计算开销小，不支持换装） 1,使用动画自己的缓冲区，每个动画都会有自己的缓冲区，相当耗费内存 （内存开销大，计算开销小，支持换装）2,使用动态方式，去实时去画（内存开销小，计算开销大，支持换装,不建议使用）
		*/
		__proto.load=function(path,complete,aniMode){
			(aniMode===void 0)&& (aniMode=0);
			this._aniPath=path;
			this._complete=complete;
			this._loadAniMode=aniMode;
			this._texturePath=path.replace(".sk",".png").replace(".bin",".png");
			Laya.loader.load([{url:path,type:/*laya.net.Loader.BUFFER*/"arraybuffer"},{url:this._texturePath,type:/*laya.net.Loader.IMAGE*/"image"}],Handler.create(this,this._onLoaded));
		}

		/**
		*加载完成
		*/
		__proto._onLoaded=function(){
			var tTexture=Loader.getRes(this._texturePath);
			var arraybuffer=Loader.getRes(this._aniPath);
			if (tTexture==null || arraybuffer==null)return;
			if (Templet.TEMPLET_DICTIONARY==null){
				Templet.TEMPLET_DICTIONARY={};
			};
			var tFactory;
			tFactory=Templet.TEMPLET_DICTIONARY[this._aniPath];
			if (tFactory){
				tFactory.isParseFail ? this._parseFail():this._parseComplete();
				}else {
				tFactory=new Templet();
				tFactory.url=this._aniPath;
				Templet.TEMPLET_DICTIONARY[this._aniPath]=tFactory;
				tFactory.on(/*laya.events.Event.COMPLETE*/"complete",this,this._parseComplete);
				tFactory.on(/*laya.events.Event.ERROR*/"error",this,this._parseFail);
				tFactory.parseData(tTexture,arraybuffer,60);
			}
		}

		/**
		*解析完成
		*/
		__proto._parseComplete=function(){
			var tTemple=Templet.TEMPLET_DICTIONARY[this._aniPath];
			if (tTemple){
				this.init(tTemple,this._loadAniMode);
				this.play(0,true);
			}
			this._complete && this._complete.runWith(this);
		}

		/**
		*解析失败
		*/
		__proto._parseFail=function(){
			console.log("[Error]:"+this._aniPath+"解析失败");
		}

		/**
		*传递PLAY事件
		*/
		__proto._onPlay=function(){
			this.event(/*laya.events.Event.PLAYED*/"played");
		}

		/**
		*传递STOP事件
		*/
		__proto._onStop=function(){
			this.event(/*laya.events.Event.STOPPED*/"stopped");
		}

		/**
		*传递PAUSE事件
		*/
		__proto._onPause=function(){
			this.event(/*laya.events.Event.PAUSED*/"paused");
		}

		/**
		*创建骨骼的矩阵，保证每次计算的最终结果
		*/
		__proto._parseSrcBoneMatrix=function(){
			var i=0,n=0;
			n=this._templet.srcBoneMatrixArr.length;
			for (i=0;i < n;i++){
				this._boneMatrixArray.push(new Matrix());
			}
			if (this._aniMode==0){
				this._boneSlotDic=this._templet.boneSlotDic;
				this._bindBoneBoneSlotDic=this._templet.bindBoneBoneSlotDic;
				this._boneSlotArray=this._templet.boneSlotArray;
				}else {
				if (this._boneSlotDic==null)this._boneSlotDic={};
				if (this._bindBoneBoneSlotDic==null)this._bindBoneBoneSlotDic={};
				if (this._boneSlotArray==null)this._boneSlotArray=[];
				var tArr=this._templet.boneSlotArray;
				var tBS;
				var tBSArr;
				for (i=0,n=tArr.length;i < n;i++){
					tBS=tArr[i];
					tBSArr=this._bindBoneBoneSlotDic[tBS.parent];
					if (tBSArr==null){
						this._bindBoneBoneSlotDic[tBS.parent]=tBSArr=[];
					}
					this._boneSlotDic[tBS.name]=tBS=tBS.copy();
					tBSArr.push(tBS);
					this._boneSlotArray.push(tBS);
				}
			}
		}

		/**
		*更新动画
		*@param autoKey true为正常更新，false为index手动更新
		*/
		__proto._update=function(autoKey){
			(autoKey===void 0)&& (autoKey=true);
			if (this._pause)return;
			if (autoKey && this._indexControl){
				return;
			};
			var tCurrTime=Laya.timer.currTimer;
			if (autoKey){
				this._player.update(tCurrTime-this._lastTime);
			}
			this._lastTime=tCurrTime;
			this._aniClipIndex=this._player.currentAnimationClipIndex;
			this._clipIndex=this._player.currentKeyframeIndex;
			if (this._aniClipIndex==-1)return;
			var tGraphics;
			if (this._aniMode==0){
				tGraphics=this._templet.getGrahicsDataWithCache(this._aniClipIndex,this._clipIndex);
				if (tGraphics){
					this.graphics=tGraphics;
					return;
				}
				}else if (this._aniMode==1){
				tGraphics=this._getGrahicsDataWithCache(this._aniClipIndex,this._clipIndex);
				if (tGraphics){
					this.graphics=tGraphics;
					return;
				}
			}
			this._createGraphics();
		}

		/**
		*创建grahics图像
		*/
		__proto._createGraphics=function(){
			var bones=this._templet.getNodes(this._aniClipIndex);
			this._templet.getOriginalData(this._aniClipIndex,this._curOriginalData,this._clipIndex,this._player.currentFrameTime);
			var tParentMatrix;
			var tResultMatrix;
			var tStartIndex=0;
			var i=0,j=0,k=0,n=0;
			var tDBBoneSlot;
			var tDBBoneSlotArr;
			var tTempMatrix;
			var tParentTransform;
			var boneCount=this._templet.srcBoneMatrixArr.length;
			for (i=0;i < boneCount;i++){
				tResultMatrix=this._boneMatrixArray[i];
				tParentTransform=this._templet.srcBoneMatrixArr[i];
				this._tempTransform.scX=tParentTransform.scX *this._curOriginalData[tStartIndex++];
				this._tempTransform.skX=tParentTransform.skX+this._curOriginalData[tStartIndex++];
				this._tempTransform.skY=tParentTransform.skY+this._curOriginalData[tStartIndex++];
				this._tempTransform.scY=tParentTransform.scY *this._curOriginalData[tStartIndex++];
				this._tempTransform.x=tParentTransform.x+this._curOriginalData[tStartIndex++];
				this._tempTransform.y=tParentTransform.y+this._curOriginalData[tStartIndex++];
				tTempMatrix=this._tempTransform.getMatrix();
				var tBone=bones[i];
				if (tBone.parentIndex !=-1){
					tParentMatrix=this._boneMatrixArray[tBone.parentIndex];
					Matrix.mul(tTempMatrix,tParentMatrix,tResultMatrix);
					}else {
					tTempMatrix.copyTo(tResultMatrix);
				}
				tDBBoneSlotArr=this._bindBoneBoneSlotDic[tBone.name];
				if (tDBBoneSlotArr){
					for (j=0,n=tDBBoneSlotArr.length;j < n;j++){
						tDBBoneSlot=tDBBoneSlotArr[j];
						if (tDBBoneSlot){
							tDBBoneSlot.setParentMatrix(tResultMatrix);
						}
					}
				}
			};
			var tSlotDic={};
			var tSlotAlphaDic={};
			for (;i < bones.length;i++){
				var tBoneData=bones[i];
				tSlotDic[tBoneData.name]=this._curOriginalData[tStartIndex++];
				tSlotAlphaDic[tBoneData.name]=this._curOriginalData[tStartIndex++];
				this._curOriginalData[tStartIndex++];
				this._curOriginalData[tStartIndex++];
				this._curOriginalData[tStartIndex++];
				this._curOriginalData[tStartIndex++];
			};
			var tGraphics;
			if (this._aniMode==0 || this._aniMode==1){
				this.graphics=new Graphics();
				}else {
				this.graphics.clear();
			}
			tGraphics=this.graphics;
			var tSlotData2=NaN;
			var tSlotData3=NaN;
			for (i=0,n=this._boneSlotArray.length;i < n;i++){
				tDBBoneSlot=this._boneSlotArray[i];
				tSlotData2=tSlotDic[tDBBoneSlot.name];
				tSlotData3=tSlotAlphaDic[tDBBoneSlot.name];
				if (!isNaN(tSlotData3)){
					tGraphics.save();
					tGraphics.alpha(tSlotData3);
				}
				if (!isNaN(tSlotData2)){
					tDBBoneSlot.showDisplayByIndex(tSlotData2);
				}
				tDBBoneSlot.draw(tGraphics,this._aniMode==2);
				if (!isNaN(tSlotData3)){
					tGraphics.restore();
				}
			}
			if (this._aniMode==0){
				this._templet.setGrahicsDataWithCache(this._aniClipIndex,this._clipIndex,tGraphics);
				}else if (this._aniMode==1){
				this._setGrahicsDataWithCache(this._aniClipIndex,this._clipIndex,tGraphics);
			}
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
		*@param index 动画的索引
		*/
		__proto.getAniNameByIndex=function(index){
			return this._templet.getAniNameByIndex(index);
		}

		/**
		*通过名字得到插槽的引用
		*@param name 动画的名字
		*@return
		*/
		__proto.getSlotByName=function(name){
			return this._boneSlotDic[name];
		}

		/**
		*通过名字显示一套皮肤
		*@param name 皮肤的名字
		*/
		__proto.showSkinByName=function(name){
			this._templet.showSkinByName(this._boneSlotDic,name);
			this._clearCache();
		}

		/**
		*通过索引显示一套皮肤
		*@param skinIndex 皮肤索引
		*/
		__proto.showSkinByIndex=function(skinIndex){
			this._templet.showSkinByIndex(this._boneSlotDic,skinIndex);
			this._clearCache();
		}

		/**
		*设置某插槽的皮肤
		*@param slotName 插槽名称
		*@param index 插糟皮肤的索引
		*/
		__proto.showSlotSkinByIndex=function(slotName,index){
			if (this._aniMode==0)return;
			var tBoneSlot=this.getSlotByName(slotName);
			if (tBoneSlot){
				tBoneSlot.showDisplayByIndex(index);
			}
			this._clearCache();
		}

		/**
		*设置自定义皮肤
		*@param name 插糟的名字
		*@param texture 自定义的纹理
		*/
		__proto.setSlotSkin=function(slotName,texture){
			if (this._aniMode==0)return;
			var tBoneSlot=this.getSlotByName(slotName);
			if (tBoneSlot){
				tBoneSlot.replaceSkin(texture);
			}
			this._clearCache();
		}

		/**
		*换装的时候，需要清一下缓冲区
		*/
		__proto._clearCache=function(){
			if (this._aniMode==1){
				for (var i=0,n=this._graphicsCache.length;i < n;i++){
					this._graphicsCache[i].length=0;
				}
			}
		}

		/**
		*播放动画
		*@param nameOrIndex 动画名字或者索引
		*@param loop 是否循环播放
		*@param force false,如果要播的动画跟上一个相同就不生效,true,强制生效
		*/
		__proto.play=function(nameOrIndex,loop,force){
			(force===void 0)&& (force=true);
			this._indexControl=false;
			var index=-1;
			var duration=NaN;
			if (loop){
				duration=Number.MAX_VALUE;
				}else {
				duration=0;
			}
			if ((typeof nameOrIndex=='string')){
				for (var i=0,n=this._templet.getAnimationCount();i < n;i++){
					var animation=this._templet.getAnimation(i);
					if (animation && nameOrIndex==animation.name){
						index=i;
						break ;
					}
				}
				}else {
				index=nameOrIndex;
			}
			if (index >-1 && index < this.getAnimNum()){
				if (force || this._pause || this._currAniIndex !=index){
					this._currAniIndex=index;
					this._curOriginalData=new Float32Array(this._templet.getTotalkeyframesLength(index));
					this._player.play(index,1,duration);
					this._templet.showSkinByIndex(this._boneSlotDic,0);
					if (this._pause){
						this._pause=false;
						this._lastTime=Browser.now();
						Laya.stage.frameLoop(1,this,this._update,null,true);
					}
				}
			}
		}

		/**
		*停止动画
		*/
		__proto.stop=function(){
			if (!this._pause){
				this._pause=true;
				if (this._player){
					this._player.stop(true);
				}
				Laya.timer.clear(this,this._update);
			}
		}

		/**
		*设置动画播放速率
		*@param value 1为标准速率
		*/
		__proto.playbackRate=function(value){
			if (this._player){
				this._player.playbackRate=value;
			}
		}

		/**
		*暂停动画的播放
		*/
		__proto.paused=function(){
			if (!this._pause){
				this._pause=true;
				if (this._player){
					this._player.paused=true;
				}
				Laya.timer.clear(this,this._update);
			}
		}

		/**
		*恢复动画的播放
		*/
		__proto.resume=function(){
			this._indexControl=false;
			if (this._pause){
				this._pause=false;
				if (this._player){
					this._player.paused=false;
				}
				this._lastTime=Browser.now();
				Laya.stage.frameLoop(1,this,this._update,null,true);
			}
		}

		/**
		*@private
		*得到缓冲数据
		*@param aniIndex
		*@param frameIndex
		*@return
		*/
		__proto._getGrahicsDataWithCache=function(aniIndex,frameIndex){
			return this._graphicsCache[aniIndex][frameIndex];
		}

		/**
		*@private
		*保存缓冲grahpics
		*@param aniIndex
		*@param frameIndex
		*@param graphics
		*/
		__proto._setGrahicsDataWithCache=function(aniIndex,frameIndex,graphics){
			this._graphicsCache[aniIndex][frameIndex]=graphics;
		}

		/**
		*销毁当前动画
		*/
		__proto.destory=function(){
			this._templet=null;
			this._player.offAll();
			this._player=null;
			this._curOriginalData=null;
			this._boneMatrixArray.length=0;
			this._lastTime=0;
			Laya.timer.clear(this,this._update);
		}

		/**
		*@private
		*设置帧索引
		*/
		/**
		*@private
		*得到帧索引
		*/
		__getset(0,__proto,'index',function(){
			return this._index;
			},function(value){
			if (this.player){
				this._index=value;
				this._player.currentTime=this._index *1000 / this._player.cacheFrameRate;
				this._indexControl=true;
				this._update(false);
			}
		});

		/**
		*得到播放器的引用
		*/
		__getset(0,__proto,'player',function(){
			return this._player;
		});

		/**
		*设置动画路径
		*/
		/**
		*得到资源的URL
		*/
		__getset(0,__proto,'url',function(){
			return this._aniPath;
			},function(path){
			this.load(path);
		});

		/**
		*得到总帧数据
		*/
		__getset(0,__proto,'total',function(){
			if (this._templet && this._player){
				this._total=Math.floor(this._templet.getAniDuration(this._player.currentAnimationClipIndex)/ 1000 *60);
				}else {
				this._total=-1;
			}
			return this._total;
		});

		return Skeleton;
	})(Sprite)


	/**
	*<p> <code>MovieClip</code> 用于播放经过工具处理后的 swf 动画。</p>
	*/
	//class laya.ani.swf.MovieClip extends laya.display.Sprite
	var MovieClip=(function(_super){
		function MovieClip(parentMovieClip){
			this._start=0;
			this._Pos=0;
			this._data=null;
			this._curIndex=0;
			this._playIndex=0;
			this._playing=false;
			this._ended=true;
			this._count=0;
			this._ids=null;
			this._idOfSprite=null;
			this._parentMovieClip=null;
			this._movieClipList=null;
			this._labels=null;
			this.basePath=null;
			this.interval=30;
			this.loop=false;
			MovieClip.__super.call(this);
			this._ids={};
			this._idOfSprite=[];
			this._reset();
			this._playing=false;
			this._parentMovieClip=parentMovieClip;
			if (!parentMovieClip){
				this._movieClipList=[this];
				this.on(/*laya.events.Event.DISPLAY*/"display",this,this._$3__onDisplay);
				this.on(/*laya.events.Event.UNDISPLAY*/"undisplay",this,this._$3__onDisplay);
				}else {
				this._movieClipList=parentMovieClip._movieClipList;
				this._movieClipList.push(this);
			}
		}

		__class(MovieClip,'laya.ani.swf.MovieClip',_super);
		var __proto=MovieClip.prototype;
		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			this.clear();
			_super.prototype.destroy.call(this,destroyChild);
		}

		/**@private */
		__proto._$3__onDisplay=function(){
			if (this._displayedInStage)Laya.timer.loop(this.interval,this,this.updates,null,true);
			else Laya.timer.clear(this,this.updates);
		}

		/**@private 更新时间轴*/
		__proto.updates=function(){
			if (this._parentMovieClip)return;
			var i=0,len=0;
			len=this._movieClipList.length;
			for (i=0;i < len;i++){
				this._movieClipList[i]._update();
			}
		}

		/**
		*增加一个标签到index帧上，播放到此index后会派发label事件
		*@param label 标签名称
		*@param index 索引位置
		*/
		__proto.addLabel=function(label,index){
			if (!this._labels)this._labels={};
			this._labels[index]=label;
		}

		/**
		*删除某个标签
		*@param label 标签名字，如果label为空，则删除所有Label
		*/
		__proto.removeLabel=function(label){
			if (!label)this._labels=null;
			else if (!this._labels){
				for (var name in this._labels){
					if (this._labels[name]===label){
						delete this._labels[name];
						break ;
					}
				}
			}
		}

		/**
		*@private
		*动画的帧更新处理函数。
		*/
		__proto._update=function(){
			if (!this._data)return;
			if (!this._playing)return;
			this._playIndex++;
			if (this._playIndex >=this._count){
				if (!this.loop){
					this._playIndex--;
					this.stop();
					return;
				}
				this._playIndex=0;
			}
			this._parse(this._playIndex);
			if (this._labels && this._labels[this._playIndex])this.event(/*laya.events.Event.LABEL*/"label",this._labels[this._playIndex]);
		}

		/**
		*停止播放动画。
		*/
		__proto.stop=function(){
			this._playing=false;
		}

		/**
		*跳到某帧并停止播放动画。
		*@param frame 要跳到的帧
		*/
		__proto.gotoAndStop=function(index){
			this.index=index;
			this.stop();
		}

		/**
		*清理。
		*/
		__proto.clear=function(){
			this._idOfSprite.length=0;
			if (!this._parentMovieClip){
				Laya.timer.clear(this,this.updates);
				var i=0,len=0;
				len=this._movieClipList.length;
				for (i=0;i < len;i++){
					if (this._movieClipList[i] !=this)
						this._movieClipList[i].clear();
				}
				this._movieClipList.length=0;
			}
			this.removeChildren();
			this.graphics=null;
			this._parentMovieClip=null;
		}

		/**
		*播放动画。
		*@param index 帧索引。
		*/
		__proto.play=function(index,loop){
			(index===void 0)&& (index=0);
			(loop===void 0)&& (loop=true);
			this.loop=loop;
			if (this._data)
				this._displayFrame(index);
			this._playing=true;
		}

		/**@private */
		__proto._displayFrame=function(frameIndex){
			(frameIndex===void 0)&& (frameIndex=-1);
			if (frameIndex !=-1){
				if (this._curIndex > frameIndex)this._reset();
				this._parse(frameIndex);
			}
		}

		/**@private */
		__proto._reset=function(rm){
			(rm===void 0)&& (rm=true);
			if (rm && this._curIndex !=1)this.removeChildren();
			this._curIndex=-1;
			this._Pos=this._start;
		}

		/**@private */
		__proto._parse=function(frameIndex){
			var curChild=this;
			var mc,sp,key=0,type=0,tPos=0,ttype=0,ifAdd=false;
			var _idOfSprite=this._idOfSprite,_data=this._data,eStr;
			if (this._ended)this._reset();
			_data.pos=this._Pos;
			this._ended=false;
			this._playIndex=frameIndex;
			if (this._curIndex > frameIndex)this._curIndex=-1;
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
							sp.alpha=1;
							}else if (ttype==1){
							mc=_idOfSprite[key]
							if (!mc){
								_idOfSprite[key]=mc=new MovieClip(this);
								mc.interval=this.interval;
								mc._ids=this._ids;
								mc.basePath=this.basePath;
								mc._setData(_data,tPos);
								mc._initState();
								mc.play(0);
							}
							mc.alpha=1;
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
						var mt=sp.transform || Matrix.create();
						mt.setTo(_data.getFloat32(),_data.getFloat32(),_data.getFloat32(),_data.getFloat32(),_data.getFloat32(),_data.getFloat32());
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
						if (eStr=="stop")this.stop();
						break ;
					case 99:
						this._curIndex=_data.getUint16();
						ifAdd && this.updateZOrder();
						this._playing && this._curIndex > this._playIndex && this.event(/*laya.events.Event.FRAME*/"enterframe");
						break ;
					case 100:
						this._count=this._curIndex+1;
						this._ended=true;
						if (this._playing){
							this.event(/*laya.events.Event.FRAME*/"enterframe");
							this.event(/*laya.events.Event.END*/"end");
							this.event(/*laya.events.Event.COMPLETE*/"complete");
						}
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
			url=URL.formatURL(url);
			this.basePath=url.split(".swf")[0]+"/image/";
			this.stop();
			this.clear();
			this._movieClipList=[this];
			var data=Loader.getRes(url);
			if (data){
				this._initData(data);
				}else {
				Laya.loader.load(url,Handler.create(this,this._onLoaded),null,/*laya.net.Loader.BUFFER*/"arraybuffer");
			}
		}

		/**@private */
		__proto._onLoaded=function(data){
			this._initData(data);
		}

		/**@private */
		__proto._initState=function(){
			this._reset();
			this._ended=false;
			var preState=this._playing;
			this._playing=false;
			while (!this._ended)this._parse(++this._playIndex);
			this._playing=preState;
		}

		/**@private */
		__proto._initData=function(data){
			this._data=new Byte(data);
			var i=0,len=this._data.getUint16();
			for (i=0;i < len;i++)this._ids[this._data.getInt16()]=this._data.getInt32();
			this.interval=1000 / this._data.getUint16();
			this._setData(this._data,this._ids[32767]);
			this._initState();
			this.play(0);
			this.event(/*laya.events.Event.LOADED*/"loaded");
			if (!this._parentMovieClip)Laya.timer.loop(this.interval,this,this.updates,null,true);
		}

		/**当前播放索引。*/
		__getset(0,__proto,'index',function(){
			return this._playIndex;
			},function(value){
			this._playIndex=value;
			if (this._data)
				this._displayFrame(this._playIndex);
			if (this._labels && this._labels[value])this.event(/*laya.events.Event.LABEL*/"label",this._labels[value]);
		});

		/**
		*资源地址。
		*/
		__getset(0,__proto,'url',null,function(path){
			this.load(path);
		});

		/**
		*帧总数。
		*/
		__getset(0,__proto,'count',function(){
			return this._count;
		});

		MovieClip._ValueList=["x","y","width","height","scaleX","scaleY","rotation","alpha"];
		return MovieClip;
	})(Sprite)



})(window,document,Laya);
