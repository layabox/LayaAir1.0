
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Animation=laya.display.Animation,Byte=laya.utils.Byte,Sprite=laya.display.Sprite,Event=laya.events.Event;
	var Loader=laya.net.Loader,Matrix=laya.maths.Matrix,URL=laya.net.URL,Graphics=laya.display.Graphics,Handler=laya.utils.Handler;
	var Arith=laya.maths.Arith,Texture=laya.resource.Texture;
	//class laya.ani.bone.Templet
	var Templet=(function(){
		function Templet(data,tex){
			this._vision="";
			//this._usePack=0;
			//this._uv=null;
			//this._bones=null;
			this._anims=[];
			//this._strArr=null;
			this._targetAnim=[];
			this._boneCount=0;
			//this._boneMatrix=null;
			this._textures=[];
			//this._textureWidth=NaN;
			//this._textureHeight=NaN;
			this.frameCount=0;
			this.frameRate=0;
			this.animNames={};
			this._graphicsArrs_=[];
			//this._texture=null;
			this._texture=tex;
			this._textureWidth=tex.width;
			this._textureHeight=tex.height;
			this._execute(data);
		}

		__class(Templet,'laya.ani.bone.Templet');
		var __proto=Templet.prototype;
		__proto._execute=function(data){
			var b=new Byte(data);
			this._vision=[b.getUint8(),b.getUint8(),b.getUint8(),b.getUint8()].join(",");
			this.frameRate=b.getUint8();
			this._usePack=b.getUint8();
			this._strArr=b.getString().split("\n");
			var len=b.getInt16();
			this._uv=b.getInt16Array(b.pos,len *8 *2);
			for (var i=0;i < len;++i){
				var u1=this._texture.uv[0],v1=this._texture.uv[1],u2=this._texture.uv[4],v2=this._texture.uv[5];
				var inAltasUVWidth=(u2-u1),inAltasUVHeight=(v2-v1);
				var uvStart=i *8,l=this._uv[uvStart],u=this._uv[uvStart+1],w=this._uv[uvStart+2],h=this._uv[uvStart+3];
				var oriU1=l / this._textureWidth,oriU2=(l+w)/ this._textureWidth,oriV1=u / this._textureHeight,oriV2=(u+h)/ this._textureHeight;
				var oriUV=[oriU1,oriV1,oriU2,oriV1,oriU2,oriV2,oriU1,oriV2];
				var tex=this._textures[i]=new Texture(this._texture.bitmap,[u1+oriUV[0] *inAltasUVWidth,v1+oriUV[1] *inAltasUVHeight,u2-(1-oriUV[2])*inAltasUVWidth,v1+oriUV[3] *inAltasUVHeight,u2-(1-oriUV[4])*inAltasUVWidth,v2-(1-oriUV[5])*inAltasUVHeight,u1+oriUV[6] *inAltasUVWidth,v2-(1-oriUV[7])*inAltasUVHeight]);
				tex.w=this._uv[uvStart+4];
				tex.h=this._uv[uvStart+5];
				tex.__w=w;
				tex.__h=h;
				tex._offsetX=this._uv[uvStart+6];
				tex._offsetY=this._uv[uvStart+7];
			}
			this._boneCount=len=b.getInt16()
			this._boneMatrix=b.getFloat32Array(b.pos,len *6 *4);
			this._bones=b.getInt16Array(b.pos,len *4 *2);
			len=b.getInt16();
			for (var k=0;k < len;k++){
				var arr=[];
				arr._index_=k;
				this._graphicsArrs_.push(arr);
				var nameIndex=b.getInt16();
				this.animNames[this._strArr[nameIndex]]=k;
				this.frameCount=b.getInt16();
				arr.length=arr._length=this.frameCount;
				var blockNum=b.getInt16();
				this._anims.push(b.getFloat32Array(b.pos,blockNum *Templet.SRC_ANIMLEN *4));
				var outPut=new Float32Array(this.frameCount *this._boneCount *Templet.ANIMLEN);
				this._targetAnim.push(outPut);
				this.interpolation(this._anims[k],outPut,blockNum);
			}
		}

		__proto.planish=function(i,_index_){
			var outAnim=this._targetAnim[_index_];
			var gr=new Graphics();
			var planishMat=[];
			var i_animlen=i *Templet.ANIMLEN;
			for (var j=0;j < this._boneCount;j++){
				var bStart=j *4;
				var mStart=j *6;
				var pIndex=this._bones[bStart];
				var mAStart=j *this.frameCount *Templet.ANIMLEN+i_animlen;
				var mM=this._getMat(this._boneMatrix,mStart);
				var mAM,tmp,outM=new Matrix();
				if (pIndex >-1){
					var mpAStart=pIndex *this.frameCount *Templet.ANIMLEN+i_animlen;
					var mpAM=planishMat[pIndex];
					var nodeType=this._bones[bStart+2];
					switch (nodeType){
						case 0:
							mAM=this._getMat(outAnim,mAStart);
							tmp=Matrix.TEMP;
							var tx=mAM.tx,ty=mAM.ty;
							mAM.setTranslate(0,0);
							Matrix.mul(mAM,mM,tmp);
							tmp.translate(tx,ty);
							Matrix.mul(tmp,mpAM,planishMat[j]=outM);
							mAM=null;
							break ;
						case 1:;
							var texIndex=outAnim[mAStart+7];
							if (texIndex==-1)
								continue ;
							var alpha=outAnim[mAStart+6];
							if (alpha < 0.001)continue ;
							texIndex=outAnim[mAStart+7];
							var tex=this._textures[texIndex];
							mM.tx-=tex._offsetX;
							mM.ty-=tex._offsetY;
							Matrix.mul(mM,mpAM,outM);
							if (alpha < 0.9999){
								gr.save();
								gr.alpha(alpha);
								gr.drawTexture(tex,-tex.w / 2,-tex.w / 2,tex.__w,tex.__h,outM);
								gr.restore();
							}
							else{
								gr.drawTexture(tex,-tex.w / 2,-tex.w / 2,tex.__w,tex.__h,outM);
							}
							break ;
						case 2:
							break ;
						default :
							break ;
						}
				}
				else{
					mAM=this._getMat(outAnim,mAStart);
					Matrix.mul(mAM,mM,planishMat[j]=outM);
				}
			}
			return gr;
		}

		__proto.interpolation=function(input,outPut,blockNum){
			var outFrameNum=0,i=0,j=0,k=0,start=0,duration=0,type=0,outStart=0,delta=NaN,next=0;
			for (i=0;i < blockNum;i++,start+=Templet.SRC_ANIMLEN){
				duration=input[start+6];
				type=input[start+7];
				if (duration > 1){
					next=start+Templet.SRC_ANIMLEN;
					for (j=0;j < duration;j++){
						outStart=outFrameNum++*Templet.ANIMLEN;
						if (type==-1){
							for (k=0;k < 6;k++){
								outPut[outStart+k]=input[start+k];
							}
							outPut[outStart+6]=input[start+8];
							outPut[outStart+7]=input[start+9];
						}
						else{
							for (k=0;k < 6;k++){
								delta=input[next+k]-input[start+k];
								if (k==1 || k==2)
									delta=Arith.formatR(delta);
								delta /=duration;
								outPut[outStart+k]=j *delta+input[start+k];
							}
							delta=(input[next+8]-input[start+8])/ duration;
							outPut[outStart+6]=j *delta+input[start+8];
							outPut[outStart+7]=input[start+9];
						}
					}
				}
				else{
					outStart=outFrameNum++*Templet.ANIMLEN;
					for (j=0;j < 6;j++)
					outPut[outStart+j]=input[start+j];
					outPut[outStart+6]=1;
					outPut[outStart+7]=input[start+9];
				}
			}
		}

		//贴图索引
		__proto._getMat=function(tran,start){
			var mat=new Matrix();
			var a=tran[start],b=tran[start+1],c=tran[start+2],d=tran[start+3],tx=tran[start+4],ty=tran[start+5];
			if (c !=0 || b !=0){
				var cos=Math.cos(b),sin=Math.sin(b);
				mat.setTo(a *cos,a *sin,d *-sin,d *cos,tx,ty);
			}
			else
			mat.setTo(a,b,c,d,tx,ty);
			return mat;
		}

		__getset(0,__proto,'textureWidth',function(){
			return this._textureWidth;
		});

		__getset(0,__proto,'textureHeight',function(){
			return this._textureHeight;
		});

		Templet.ANIMLEN=8;
		Templet.SRC_ANIMLEN=10;
		return Templet;
	})()


	/**
	*...
	*@author laya
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
		__proto.update=function(){
			if (!this._data)return;
			if (!this._playing)
				return;
			this._playIndex++;
			if (this._playIndex >=this.totalFrames)this._playIndex=0;
			this._parse(this._playIndex);
		}

		__proto.stop=function(){
			this._playing=false;
			Laya.timer.clear(this,this.update);
		}

		__proto.gotoStop=function(frame){
			this.stop();
			this._displayFrame(frame);
		}

		__proto.clear=function(){
			this._idOfSprite.length=0;
			this.removeChildren();
			this.graphics=null;
		}

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

		__proto._setData=function(data,start){
			this._data=data;
			this._start=start+3;
		}

		__proto.load=function(url){
			var _$this=this;
			url=URL.formatURL(url);
			this.basePath=url.replace(".swf","/image/");
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

		__getset(0,__proto,'currentFrame',function(){
			return this._playIndex;
		});

		__getset(0,__proto,'totalFrames',function(){
			return this._frameCount;
		});

		__getset(0,__proto,'skin',null,function(path){
			this.load(path);
		});

		MovieClip._ValueList=["x","y","width","height","scaleX","scaleY","rotation","alpha"];
		return MovieClip;
	})(Sprite)


	//class laya.ani.bone.Skeleton extends laya.display.Animation
	var Skeleton=(function(_super){
		function Skeleton(tmplete){
			this._tp_=null;
			Skeleton.__super.call(this);
			if (!tmplete)return;
			this._tp_=tmplete;
			this._count=tmplete.frameCount;
			this.interval=1000 / tmplete.frameRate;
			this.frames=this._tp_._graphicsArrs_[0];
		}

		__class(Skeleton,'laya.ani.bone.Skeleton',_super);
		var __proto=Skeleton.prototype;
		__proto.setTpl=function(tpl){
			this._tp_=tpl;
			this._count=tpl.frameCount;
			this.interval=1000 / tpl.frameRate;
			this.setAnim(0);
		}

		__proto.setAnim=function(index){
			this.frames=this._tp_._graphicsArrs_[index];
		}

		__proto.stAnimName=function(str){
			this.frames=this._tp_._graphicsArrs_[this._tp_.animNames[str]];
		}

		__proto.pause=function(frame){
			(frame===void 0)&& (frame=-1);
			frame >-1 && (this.index=frame);
			this.stop();
		}

		__getset(0,__proto,'frames',_super.prototype._$get_frames,function(value){
			this._frames=value;
			this.repaint();
		});

		__getset(0,__proto,'index',_super.prototype._$get_index,function(value){
			this._index=value;
			if ((this.graphics=this._frames[value])!=null){
				}else {
				this.graphics=this._frames[value]=this._tp_.planish(value,this._frames._index_);
			}
		});

		return Skeleton;
	})(Animation)


	/**
	*...
	*@author ww
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

		__proto.load=function(baseURL){
			this.dataUrl=baseURL;
			this.imgUrl=baseURL.replace(".sk",".png");
			Laya.loader.load([ {url:this.dataUrl,type:/*laya.net.Loader.BUFFER*/"arraybuffer" },{url:this.imgUrl,type:/*laya.net.Loader.IMAGE*/"image" }],Handler.create(this,this._resLoaded));
		}

		__proto._resLoaded=function(){
			this._tp_=new Templet(Loader.getRes(this.dataUrl),Loader.getRes(this.imgUrl));
			this.setTpl(this._tp_);
			this.play();
		}

		__getset(0,__proto,'skin',null,function(path){
			this.load(path);
		});

		return SkeletonPlayer;
	})(Skeleton)



})(window,document,Laya);
