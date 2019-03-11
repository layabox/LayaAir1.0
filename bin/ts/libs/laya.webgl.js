
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Bezier=laya.maths.Bezier,Bitmap=laya.resource.Bitmap,Browser=laya.utils.Browser,CacheStyle=laya.display.css.CacheStyle;
	var ColorFilter=laya.filters.ColorFilter,ColorUtils=laya.utils.ColorUtils,Config=Laya.Config,Context=laya.resource.Context;
	var DrawCanvasCmd=laya.display.cmd.DrawCanvasCmd,DrawImageCmd=laya.display.cmd.DrawImageCmd,Event=laya.events.Event;
	var FillTextCmd=laya.display.cmd.FillTextCmd,Filter=laya.filters.Filter,FontInfo=laya.utils.FontInfo,Graphics=laya.display.Graphics;
	var HTMLCanvas=laya.resource.HTMLCanvas,HTMLChar=laya.utils.HTMLChar,HTMLImage=laya.resource.HTMLImage,Handler=laya.utils.Handler;
	var Loader=laya.net.Loader,Matrix=laya.maths.Matrix,Node=laya.display.Node,Point=laya.maths.Point,Pool=laya.utils.Pool;
	var Rectangle=laya.maths.Rectangle,Render=laya.renders.Render,RenderSprite=laya.renders.RenderSprite,Resource=laya.resource.Resource;
	var RestoreCmd=laya.display.cmd.RestoreCmd,RotateCmd=laya.display.cmd.RotateCmd,RunDriver=laya.utils.RunDriver;
	var SaveCmd=laya.display.cmd.SaveCmd,ScaleCmd=laya.display.cmd.ScaleCmd,Sprite=laya.display.Sprite,SpriteConst=laya.display.SpriteConst;
	var SpriteStyle=laya.display.css.SpriteStyle,Stage=laya.display.Stage,Stat=laya.utils.Stat,StringKey=laya.utils.StringKey;
	var System=laya.system.System,Text=laya.display.Text,Texture=laya.resource.Texture,TransformCmd=laya.display.cmd.TransformCmd;
	var TranslateCmd=laya.display.cmd.TranslateCmd,VectorGraphManager=laya.utils.VectorGraphManager,WordText=laya.utils.WordText;
Laya.interface('laya.webgl.submit.ISubmit');
Laya.interface('laya.webgl.canvas.save.ISaveData');
//class laya.webgl.canvas.save.SaveBase
var SaveBase=(function(){
	function SaveBase(){
		//this._valueName=null;
		//this._value=null;
		//this._dataObj=null;
		//this._newSubmit=false;
	}

	__class(SaveBase,'laya.webgl.canvas.save.SaveBase');
	var __proto=SaveBase.prototype;
	Laya.imps(__proto,{"laya.webgl.canvas.save.ISaveData":true})
	__proto.isSaveMark=function(){return false;}
	__proto.restore=function(context){
		this._dataObj[this._valueName]=this._value;
		SaveBase.POOL[SaveBase.POOL._length++]=this;
		this._newSubmit && (context._curSubmit=Submit.RENDERBASE);
	}

	SaveBase._createArray=function(){
		var value=[];
		value._length=0;
		return value;
	}

	SaveBase._init=function(){
		var namemap=SaveBase._namemap={};
		namemap[0x1]="ALPHA";
		namemap[0x2]="fillStyle";
		namemap[0x8]="font";
		namemap[0x100]="lineWidth";
		namemap[0x200]="strokeStyle";
		namemap[0x2000]="_mergeID";
		namemap[0x400]=namemap[0x800]=namemap[0x1000]=[];
		namemap[0x4000]="textBaseline";
		namemap[0x8000]="textAlign";
		namemap[0x10000]="_nBlendType";
		namemap[0x100000]="shader";
		namemap[0x200000]="filters";
		namemap[0x800000]='_colorFiler';
		return namemap;
	}

	SaveBase.save=function(context,type,dataObj,newSubmit){
		if ((context._saveMark._saveuse & type)!==type){
			context._saveMark._saveuse |=type;
			var cache=SaveBase.POOL;
			var o=cache._length > 0 ? cache[--cache._length] :(new SaveBase());
			o._value=dataObj[o._valueName=SaveBase._namemap[type]];
			o._dataObj=dataObj;
			o._newSubmit=newSubmit;
			var _save=context._save;
			_save[_save._length++]=o;
		}
	}

	SaveBase.POOL=laya.webgl.canvas.save.SaveBase._createArray();
	SaveBase._namemap=SaveBase._init();
	return SaveBase;
})()


//class laya.webgl.shader.d2.value.Value2D
var Value2D=(function(){
	function Value2D(mainID,subID){
		this.size=[0,0];
		this.alpha=1.0;
		//这个目前只给setIBVB用。其他的都放到attribute的color中了
		//this.mmat=null;
		//worldmatrix，是4x4的，因为为了shader使用方便。 TODO 换成float32Array
		//this.u_MvpMatrix=null;
		//this.texture=null;
		this.ALPHA=1.0;
		//这个？
		//this.shader=null;
		//this.mainID=0;
		this.subID=0;
		//this.filters=null;
		//this.textureHost=null;
		//public var fillStyle:DrawStyle;//TODO 这个有什么用？
		//this.color=null;
		//public var strokeStyle:DrawStyle;
		//this.colorAdd=null;
		//this.u_mmat2=null;
		this.ref=1;
		//this._attribLocation=null;
		//[name,location,name,location...] 由继承类赋值。这个最终会传给对应的shader
		//this._inClassCache=null;
		this._cacheID=0;
		this.clipMatDir=[ /*laya.webgl.canvas.WebGLContext2D._MAXSIZE*/99999999,0,0,/*laya.webgl.canvas.WebGLContext2D._MAXSIZE*/99999999];
		this.clipMatPos=[0,0];
		this.defines=new ShaderDefines2D();
		this.mainID=mainID;
		this.subID=subID;
		this.textureHost=null;
		this.texture=null;
		this.color=null;
		this.colorAdd=null;
		this.u_mmat2=null;
		this._cacheID=mainID|subID;
		this._inClassCache=Value2D._cache[this._cacheID];
		if (mainID>0 && !this._inClassCache){
			this._inClassCache=Value2D._cache[this._cacheID]=[];
			this._inClassCache._length=0;
		}
		this.clear();
	}

	__class(Value2D,'laya.webgl.shader.d2.value.Value2D');
	var __proto=Value2D.prototype;
	__proto.setValue=function(value){}
	//public function refresh():ShaderValue
	__proto._ShaderWithCompile=function(){
		var ret=Shader.withCompile2D(0,this.mainID,this.defines.toNameDic(),this.mainID | this.defines._value,Shader2X.create,this._attribLocation);
		return ret;
	}

	__proto.upload=function(){
		var renderstate2d=RenderState2D;
		RenderState2D.worldMatrix4===RenderState2D.TEMPMAT4_ARRAY || this.defines.addInt(/*laya.webgl.shader.d2.ShaderDefines2D.WORLDMAT*/0x80);
		this.mmat=renderstate2d.worldMatrix4;
		if (RenderState2D.matWVP){
			this.defines.addInt(/*laya.webgl.shader.d2.ShaderDefines2D.MVP3D*/0x800);
			this.u_MvpMatrix=RenderState2D.matWVP.elements;
		};
		var sd=Shader.sharders[this.mainID | this.defines._value] || this._ShaderWithCompile();
		if (sd._shaderValueWidth!==renderstate2d.width || sd._shaderValueHeight!==renderstate2d.height){
			this.size[0]=renderstate2d.width;
			this.size[1]=renderstate2d.height;
			sd._shaderValueWidth=renderstate2d.width;
			sd._shaderValueHeight=renderstate2d.height;
			sd.upload(this,null);
		}
		else{
			sd.upload(this,sd._params2dQuick2 || sd._make2dQuick2());
		}
	}

	//TODO:coverage
	__proto.setFilters=function(value){
		this.filters=value;
		if (!value)
			return;
		var n=value.length,f;
		for (var i=0;i < n;i++){
			f=value[i];
			if (f){
				this.defines.add(f.type);
				f.action.setValue(this);
			}
		}
	}

	__proto.clear=function(){
		this.defines._value=this.subID+(WebGL.shaderHighPrecision? /*laya.webgl.shader.d2.ShaderDefines2D.SHADERDEFINE_FSHIGHPRECISION*/0x400:0);
	}

	__proto.release=function(){
		if ((--this.ref)< 1){
			this._inClassCache && (this._inClassCache[this._inClassCache._length++]=this);
			this.clear();
			this.filters=null;
			this.ref=1;
		}
	}

	Value2D._initone=function(type,classT){
		Value2D._typeClass[type]=classT;
		Value2D._cache[type]=[];
		Value2D._cache[type]._length=0;
	}

	Value2D.__init__=function(){
		Value2D._initone(/*laya.webgl.shader.d2.ShaderDefines2D.PRIMITIVE*/0x04,PrimitiveSV);
		Value2D._initone(/*laya.webgl.shader.d2.ShaderDefines2D.SKINMESH*/0x200,SkinSV);
		Value2D._initone(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,TextureSV);
		Value2D._initone(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01 | /*laya.webgl.shader.d2.ShaderDefines2D.FILTERGLOW*/0x08,TextureSV);
	}

	Value2D.create=function(mainType,subType){
		var types=Value2D._cache[mainType|subType];
		if (types._length)
			return types[--types._length];
		else
		return new Value2D._typeClass[mainType|subType](subType);
	}

	Value2D._cache=[];
	Value2D._typeClass=[];
	Value2D.TEMPMAT4_ARRAY=[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];
	return Value2D;
})()


//class laya.webgl.shader.d2.skinAnishader.SkinMeshBuffer
var SkinMeshBuffer=(function(){
	function SkinMeshBuffer(){
		this.ib=null;
		this.vb=null;
		var gl=WebGL.mainContext;
		this.ib=IndexBuffer2D.create(/*laya.webgl.WebGLContext.DYNAMIC_DRAW*/0x88E8);
		this.vb=VertexBuffer2D.create(8);
	}

	__class(SkinMeshBuffer,'laya.webgl.shader.d2.skinAnishader.SkinMeshBuffer');
	var __proto=SkinMeshBuffer.prototype;
	//TODO:coverage
	__proto.addSkinMesh=function(skinMesh){
		skinMesh.getData2(this.vb,this.ib,this.vb._byteLength / 32);
	}

	__proto.reset=function(){
		this.vb.clear();
		this.ib.clear();
	}

	SkinMeshBuffer.getInstance=function(){
		return SkinMeshBuffer.instance=SkinMeshBuffer.instance|| new SkinMeshBuffer();
	}

	SkinMeshBuffer.instance=null;
	return SkinMeshBuffer;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.ScaleCmdNative
var ScaleCmdNative=(function(){
	function ScaleCmdNative(){
		this._graphicsCmdEncoder=null;
		this._paramData=/*__JS__ */new ParamData(4 *4,true);
	}

	__class(ScaleCmdNative,'laya.layagl.cmdNative.ScaleCmdNative');
	var __proto=ScaleCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("ScaleCmd",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "Scale";
	});

	__getset(0,__proto,'scaleX',function(){
		return this._paramData._float32Data[0];
		},function(value){
		this._paramData._float32Data[0]=value;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'scaleY',function(){
		return this._paramData._float32Data[1];
		},function(value){
		this._paramData._float32Data[1]=value;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'pivotX',function(){
		return this._paramData._float32Data[2];
		},function(value){
		this._paramData._float32Data[2]=value;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'pivotY',function(){
		return this._paramData._float32Data[3];
		},function(value){
		this._paramData._float32Data[3]=value;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	ScaleCmdNative.create=function(scaleX,scaleY,pivotX,pivotY){
		var cmd=Pool.getItemByClass("ScaleCmd",ScaleCmdNative);
		var cbuf=cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;
		var f32=cmd._paramData._float32Data;
		f32[0]=scaleX;
		f32[1]=scaleY;
		f32[2]=pivotX;
		f32[3]=pivotY;
		var nDataID=cmd._paramData.getPtrID();
		LayaGL.syncBufferToRenderThread(cmd._paramData);
		cbuf.setGlobalValueEx(LayaNative2D.GLOBALVALUE_MATRIX32,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_SCALE_PIVOT*/12,nDataID,0);
		LayaGL.syncBufferToRenderThread(cbuf);
		return cmd;
	}

	ScaleCmdNative.ID="Scale";
	return ScaleCmdNative;
})()


//class laya.webgl.canvas.save.SaveClipRect
var SaveClipRect=(function(){
	function SaveClipRect(){
		this._clipInfoID=-1;
		this._globalClipMatrix=new Matrix();
		this._clipRect=new Rectangle();
	}

	__class(SaveClipRect,'laya.webgl.canvas.save.SaveClipRect');
	var __proto=SaveClipRect.prototype;
	Laya.imps(__proto,{"laya.webgl.canvas.save.ISaveData":true})
	__proto.isSaveMark=function(){return false;}
	__proto.restore=function(context){
		this._globalClipMatrix.copyTo(context._globalClipMatrix);
		this._clipRect.clone(context._clipRect);
		context._clipInfoID=this._clipInfoID;
		SaveClipRect.POOL[SaveClipRect.POOL._length++]=this;
	}

	SaveClipRect.save=function(context){
		if ((context._saveMark._saveuse & /*laya.webgl.canvas.save.SaveBase.TYPE_CLIPRECT*/0x20000)==/*laya.webgl.canvas.save.SaveBase.TYPE_CLIPRECT*/0x20000)return;
		context._saveMark._saveuse |=/*laya.webgl.canvas.save.SaveBase.TYPE_CLIPRECT*/0x20000;
		var cache=SaveClipRect.POOL;
		var o=cache._length > 0 ? cache[--cache._length] :(new SaveClipRect());
		context._globalClipMatrix.copyTo(o._globalClipMatrix);
		context._clipRect.clone(o._clipRect);
		o._clipInfoID=context._clipInfoID;
		var _save=context._save;
		_save[_save._length++]=o;
	}

	SaveClipRect.POOL=SaveBase._createArray();
	return SaveClipRect;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.TranslateCmdNative
var TranslateCmdNative=(function(){
	function TranslateCmdNative(){
		this._graphicsCmdEncoder=null;
		this._paramData=/*__JS__ */new ParamData(2 *4,true);
	}

	__class(TranslateCmdNative,'laya.layagl.cmdNative.TranslateCmdNative');
	var __proto=TranslateCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("TranslateCmd",this);
	}

	__getset(0,__proto,'ty',function(){
		return this._paramData._float32Data[1];
		},function(value){
		this._paramData._float32Data[1]=value;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'cmdID',function(){
		return "Translate";
	});

	__getset(0,__proto,'tx',function(){
		return this._paramData._float32Data[0];
		},function(value){
		this._paramData._float32Data[0]=value;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	TranslateCmdNative.create=function(tx,ty){
		var cmd=Pool.getItemByClass("TranslateCmd",TranslateCmdNative);
		var cbuf=cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;
		var f32=cmd._paramData._float32Data;
		f32[0]=tx;
		f32[1]=ty;
		var nDataID=cmd._paramData.getPtrID();
		LayaGL.syncBufferToRenderThread(cmd._paramData);
		cbuf.setGlobalValueEx(LayaNative2D.GLOBALVALUE_MATRIX32,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_TRANSLATE*/9,nDataID,0);
		LayaGL.syncBufferToRenderThread(cbuf);
		return cmd;
	}

	TranslateCmdNative.ID="Translate";
	return TranslateCmdNative;
})()


/**
*@private
*封装GL命令
*/
//class laya.layagl.LayaGL
var LayaGL=(function(){
	function LayaGL(){}
	__class(LayaGL,'laya.layagl.LayaGL');
	var __proto=LayaGL.prototype;
	//TODO:coverage
	__proto.createCommandEncoder=function(reserveSize,adjustSize,isSyncToRenderThread){
		(reserveSize===void 0)&& (reserveSize=128);
		(adjustSize===void 0)&& (adjustSize=64);
		(isSyncToRenderThread===void 0)&& (isSyncToRenderThread=false);
		return new CommandEncoder(this,reserveSize,adjustSize,isSyncToRenderThread);
	}

	__proto.beginCommandEncoding=function(commandEncoder){}
	__proto.endCommandEncoding=function(){}
	__proto.calcMatrixFromScaleSkewRotation=function(nArrayBufferID,matrixFlag,matrixResultID,x,y,pivotX,pivotY,scaleX,scaleY,skewX,skewY,rotate){}
	__proto.setGLTemplate=function(type,templateID){}
	__proto.setEndGLTemplate=function(type,templateID){}
	__proto.matrix4x4Multiply=function(m1,m2,out){}
	__proto.evaluateClipDatasRealTime=function(nodes,playCurTime,realTimeCurrentFrameIndexs,addtive){}
	LayaGL.getFrameCount=function(){
		return 0;
	}

	LayaGL.syncBufferToRenderThread=function(value,index){
		(index===void 0)&& (index=0);
	}

	LayaGL.createArrayBufferRef=function(arrayBuffer,type,syncRender){}
	LayaGL.createArrayBufferRefs=function(arrayBuffer,type,syncRender,refType){}
	LayaGL.EXECUTE_JS_THREAD_BUFFER=0;
	LayaGL.EXECUTE_RENDER_THREAD_BUFFER=1;
	LayaGL.EXECUTE_COPY_TO_RENDER=2;
	LayaGL.EXECUTE_COPY_TO_RENDER3D=3;
	LayaGL.VALUE_OPERATE_ADD=0;
	LayaGL.VALUE_OPERATE_SUB=1;
	LayaGL.VALUE_OPERATE_MUL=2;
	LayaGL.VALUE_OPERATE_DIV=3;
	LayaGL.VALUE_OPERATE_M2_MUL=4;
	LayaGL.VALUE_OPERATE_M3_MUL=5;
	LayaGL.VALUE_OPERATE_M4_MUL=6;
	LayaGL.VALUE_OPERATE_M32_MUL=7;
	LayaGL.VALUE_OPERATE_SET=8;
	LayaGL.VALUE_OPERATE_M32_TRANSLATE=9;
	LayaGL.VALUE_OPERATE_M32_SCALE=10;
	LayaGL.VALUE_OPERATE_M32_ROTATE=11;
	LayaGL.VALUE_OPERATE_M32_SCALE_PIVOT=12;
	LayaGL.VALUE_OPERATE_M32_ROTATE_PIVOT=13;
	LayaGL.VALUE_OPERATE_M32_TRANSFORM_PIVOT=14;
	LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL=15;
	LayaGL.ARRAY_BUFFER_TYPE_DATA=0;
	LayaGL.ARRAY_BUFFER_TYPE_CMD=1;
	LayaGL.ARRAY_BUFFER_REF_REFERENCE=0;
	LayaGL.ARRAY_BUFFER_REF_COPY=1;
	LayaGL.UPLOAD_SHADER_UNIFORM_TYPE_ID=0;
	LayaGL.UPLOAD_SHADER_UNIFORM_TYPE_DATA=1;
	LayaGL.instance=null;
	return LayaGL;
})()


// 注意长宽都不要超过256，一个是影响效率，一个是超出表达能力
//class laya.webgl.text.AtlasGrid
var AtlasGrid=(function(){
	function AtlasGrid(width,height,id){
		this.atlasID=0;
		this._width=0;
		this._height=0;
		this._texCount=0;
		this._rowInfo=null;
		// 当前行的最大长度
		this._cells=null;
		// 每个格子的信息。{type,w,h}相当于一个距离场. type=0 表示空闲的。不为0的情况下填充的是宽高（有什么用呢）
		this._used=0;
		(width===void 0)&& (width=0);
		(height===void 0)&& (height=0);
		(id===void 0)&& (id=0);
		this._cells=null;
		this._rowInfo=null;
		this.atlasID=id;
		this._init(width,height);
	}

	__class(AtlasGrid,'laya.webgl.text.AtlasGrid');
	var __proto=AtlasGrid.prototype;
	//------------------------------------------------------------------
	__proto.addRect=function(type,width,height,pt){
		if (!this._get(width,height,pt))
			return false;
		this._fill(pt.x,pt.y,width,height,type);
		this._texCount++;
		return true;
	}

	//------------------------------------------------------------------------------
	__proto._release=function(){
		this._cells=null;
		this._rowInfo=null;
	}

	//------------------------------------------------------------------------------
	__proto._init=function(width,height){
		this._width=width;
		this._height=height;
		this._release();
		if (this._width==0)return false;
		this._cells=new Uint8Array(this._width *this._height*3);
		this._rowInfo=new Uint8Array(this._height);
		this._used=0;
		this._clear();
		return true;
	}

	//------------------------------------------------------------------
	__proto._get=function(width,height,pt){
		if (width > this._width || height >this._height){
			return false;
		};
		var rx=-1;
		var ry=-1;
		var nWidth=this._width;
		var nHeight=this._height;
		var pCellBox=this._cells;
		for (var y=0;y < nHeight;y++){
			if (this._rowInfo[y] < width)continue ;
			for (var x=0;x < nWidth;){
				var tm=(y *nWidth+x)*3;
				if (pCellBox[tm] !=0 || pCellBox[tm+1] < width || pCellBox[tm+2] < height){
					x+=pCellBox[tm+1];
					continue ;
				}
				rx=x;
				ry=y;
				for (var xx=0;xx < width;xx++){
					if (pCellBox[3*xx+tm+2] < height){
						rx=-1;
						break ;
					}
				}
				if (rx < 0){
					x+=pCellBox[tm+1];
					continue ;
				}
				pt.x=rx;
				pt.y=ry;
				return true;
			}
		}
		return false;
	}

	//------------------------------------------------------------------
	__proto._fill=function(x,y,w,h,type){
		var nWidth=this._width;
		var nHeghit=this._height;
		this._check((x+w)<=nWidth && (y+h)<=nHeghit);
		for (var yy=y;yy < (h+y);++yy){
			this._check(this._rowInfo[yy] >=w);
			this._rowInfo[yy]-=w;
			for (var xx=0;xx < w;xx++){
				var tm=(x+yy *nWidth+xx)*3;
				this._check(this._cells[tm]==0);
				this._cells[tm]=type;
				this._cells[tm+1]=w;
				this._cells[tm+2]=h;
			}
		}
		if (x > 0){
			for (yy=0;yy < h;++yy){
				var s=0;
				for (xx=x-1;xx >=0;--xx,++s){
					if (this._cells[((y+yy)*nWidth+xx)*3] !=0)break ;
				}
				for (xx=s;xx > 0;--xx){
					this._cells[((y+yy)*nWidth+x-xx)*3+1]=xx;
					this._check(xx > 0);
				}
			}
		}
		if (y > 0){
			for (xx=x;xx < (x+w);++xx){
				s=0;
				for (yy=y-1;yy >=0;--yy,s++){
					if (this._cells[(xx+yy *nWidth)*3] !=0)break ;
				}
				for (yy=s;yy > 0;--yy){
					this._cells[(xx+(y-yy)*nWidth)*3+2]=yy;
					this._check(yy > 0);
				}
			}
		}
		this._used+=(w*h)/(this._width*this._height);
	}

	__proto._check=function(ret){
		if (ret==false){
			console.log("xtexMerger 错误啦");
		}
	}

	//------------------------------------------------------------------
	__proto._clear=function(){
		this._texCount=0;
		for (var y=0;y < this._height;y++){
			this._rowInfo[y]=this._width;
		}
		for (var i=0;i < this._height;i++){
			for (var j=0;j < this._width;j++){
				var tm=(i *this._width+j)*3;
				this._cells[tm]=0;
				this._cells[tm+1]=this._width-j;
				this._cells[tm+2]=this._width-i;
			}
		}
	}

	return AtlasGrid;
})()


/**
*Mesh2d只是保存数据。描述attribute用的。本身不具有渲染功能。
*/
//class laya.webgl.utils.Mesh2D
var Mesh2D=(function(){
	function Mesh2D(stride,vballoc,iballoc){
		this._stride=0;
		//顶点结构大小。每个mesh的顶点结构是固定的。
		this.vertNum=0;
		//当前的顶点的个数
		this.indexNum=0;
		//实际index 个数。例如一个三角形是3个。由于ib本身可能超过实际使用的数量，所以需要一个indexNum
		this._applied=false;
		//是否已经设置给webgl了
		this._vb=null;
		//vb和ib都可能需要在外部修改，所以public
		this._ib=null;
		this._vao=null;
		this._attribInfo=null;
		//保存起来的属性定义数组。
		this._quadNum=0;
		//public static var meshlist:Array=[];//活着的mesh对象列表。
		this.canReuse=false;
		this._stride=stride;
		this._vb=new VertexBuffer2D(stride,/*laya.webgl.WebGLContext.DYNAMIC_DRAW*/0x88E8);
		if (vballoc){
			this._vb._resizeBuffer(vballoc,false);
			}else{
			Config.webGL2D_MeshAllocMaxMem && this._vb._resizeBuffer(64 *1024 *stride,false);
		}
		this._ib=new IndexBuffer2D();
		if (iballoc){
			this._ib._resizeBuffer(iballoc,false);
		}
	}

	__class(Mesh2D,'laya.webgl.utils.Mesh2D');
	var __proto=Mesh2D.prototype;
	//TODO:coverage
	__proto.cloneWithNewVB=function(){
		var mesh=new Mesh2D(this._stride,0,0);
		mesh._ib=this._ib;
		mesh._quadNum=this._quadNum;
		mesh._attribInfo=this._attribInfo;
		return mesh;
	}

	//TODO:coverage
	__proto.cloneWithNewVBIB=function(){
		var mesh=new Mesh2D(this._stride,0,0);
		mesh._attribInfo=this._attribInfo;
		return mesh;
	}

	//TODO:coverage
	__proto.getVBW=function(){
		this._vb.setNeedUpload();
		return this._vb;
	}

	//TODO:coverage
	__proto.getVBR=function(){
		return this._vb;
	}

	//TODO:coverage
	__proto.getIBR=function(){
		return this._ib;
	}

	//TODO:coverage
	__proto.getIBW=function(){
		this._ib.setNeedUpload();
		return this._ib;
	}

	/**
	*直接创建一个固定的ib。按照固定四边形的索引。
	*@param var QuadNum
	*/
	__proto.createQuadIB=function(QuadNum){
		this._quadNum=QuadNum;
		this._ib._resizeBuffer(QuadNum *6 *2,false);
		this._ib.byteLength=this._ib.bufferLength;
		var bd=this._ib.getUint16Array();
		var idx=0;
		var curvert=0;
		for (var i=0;i < QuadNum;i++){
			bd[idx++]=curvert;
			bd[idx++]=curvert+2;
			bd[idx++]=curvert+1;
			bd[idx++]=curvert;
			bd[idx++]=curvert+3;
			bd[idx++]=curvert+2;
			curvert+=4;
		}
		this._ib.setNeedUpload();
	}

	/**
	*设置mesh的属性。每3个一组，对应的location分别是0,1,2...
	*含义是：type,size,offset
	*不允许多流。因此stride是固定的，offset只是在一个vertex之内。
	*@param attribs
	*/
	__proto.setAttributes=function(attribs){
		this._attribInfo=attribs;
		if (this._attribInfo.length % 3 !=0){
			throw 'Mesh2D setAttributes error!';
		}
	}

	/**
	*初始化VAO的配置，只需要执行一次。以后使用的时候直接bind就行
	*@param gl
	*/
	__proto.configVAO=function(gl){
		if (this._applied)
			return;
		this._applied=true;
		if (!this._vao){
			this._vao=new BufferState2D();
		}
		this._vao.bind();
		this._vb._bindForVAO();
		this._ib.setNeedUpload();
		this._ib._bind_uploadForVAO();
		var attribNum=this._attribInfo.length / 3;
		var idx=0;
		for (var i=0;i < attribNum;i++){
			var _size=this._attribInfo[idx+1];
			var _type=this._attribInfo[idx];
			var _off=this._attribInfo[idx+2];
			gl.enableVertexAttribArray(i);
			gl.vertexAttribPointer(i,_size,_type,false,this._stride,_off);
			idx+=3;
		}
		this._vao.unBind();
	}

	/**
	*应用这个mesh
	*@param gl
	*/
	__proto.useMesh=function(gl){
		this._applied || this.configVAO(gl);
		this._vao.bind();
		this._vb.bind();
		this._ib._bind_upload()|| this._ib.bind();
		this._vb._bind_upload()|| this._vb.bind();
	}

	//TODO:coverage
	__proto.getEleNum=function(){
		return this._ib.getBuffer().byteLength / 2;
	}

	/**
	*子类实现。用来把自己放到对应的回收池中，以便复用。
	*/
	__proto.releaseMesh=function(){}
	/**
	*释放资源。
	*/
	__proto.destroy=function(){}
	/**
	*清理vb数据
	*/
	__proto.clearVB=function(){
		this._vb.clear();
	}

	Mesh2D._gvaoid=0;
	return Mesh2D;
})()


//class laya.webgl.canvas.DrawStyle
var DrawStyle=(function(){
	function DrawStyle(value){
		this._color=null;
		this.setValue(value);
	}

	__class(DrawStyle,'laya.webgl.canvas.DrawStyle');
	var __proto=DrawStyle.prototype;
	__proto.setValue=function(value){
		if (value){
			this._color=((value instanceof laya.utils.ColorUtils ))?(value):ColorUtils.create(value);
		}
		else this._color=ColorUtils.create("#000000");
	}

	__proto.reset=function(){
		this._color=ColorUtils.create("#000000");
	}

	__proto.toInt=function(){
		return this._color.numColor;
	}

	__proto.equal=function(value){
		if ((typeof value=='string'))return this._color.strColor===value;
		if ((value instanceof laya.utils.ColorUtils ))return this._color.numColor===(value).numColor;
		return false;
	}

	__proto.toColorStr=function(){
		return this._color.strColor;
	}

	DrawStyle.create=function(value){
		if (value){
			var color=((value instanceof laya.utils.ColorUtils ))?(value):ColorUtils.create(value);
			return color._drawStyle || (color._drawStyle=new DrawStyle(value));
		}
		return DrawStyle.DEFAULT;
	}

	__static(DrawStyle,
	['DEFAULT',function(){return this.DEFAULT=new DrawStyle("#000000");}
	]);
	return DrawStyle;
})()


//class laya.webgl.text.TextRender
var TextRender=(function(){
	function TextRender(){
		/**
		*fontSizeInfo
		*记录每种字体的像素的大小。标准是32px的字体。由4个byte组成，分别表示[xdist,ydist,w,h]。
		*xdist,ydist 是像素起点到排版原点的距离，都是正的，表示实际数据往左和上偏多少，如果实际往右和下偏，则算作0，毕竟这个只是一个大概
		*例如 [Arial]=0x00002020,表示宽高都是32
		*/
		this.fontSizeInfo={};
		this.charRender=null;
		this.mapFont={};
		// 把font名称映射到数字
		this.fontID=0;
		this.mapColor=[];
		// 把color映射到数字
		this.colorID=0;
		this.fontScaleX=1.0;
		//临时缩放。
		this.fontScaleY=1.0;
		//private var charMaps:Object={};// 所有的都放到一起
		this._curStrPos=0;
		// 所有的独立贴图
		this.bmpData32=null;
		// 当前字体的测量信息。
		this.lastFont=null;
		this.fontSizeW=0;
		this.fontSizeH=0;
		this.fontSizeOffX=0;
		this.fontSizeOffY=0;
		this.renderPerChar=true;
		this.textureMem=0;
		// 当前贴图所占用的内存
		this.fontStr=null;
		this.textAtlases=[];
		this.isoTextures=[];
		this.tmpAtlasPos=new Point();
		var bugIOS=false;
		var miniadp=Laya['MiniAdpter'];
		if (miniadp && miniadp.systemInfo && miniadp.systemInfo.system){
			bugIOS=miniadp.systemInfo.system.toLowerCase()==='ios 10.1.1';
		}
		if (Browser.onMiniGame && !bugIOS)TextRender.isWan1Wan=true;
		if (Browser.onLimixiu)TextRender.isWan1Wan=true;
		this.charRender=Render.isConchApp ? (new CharRender_Native()):(new CharRender_Canvas(TextRender.atlasWidth,TextRender.atlasWidth,TextRender.scaleFontWithCtx,!TextRender.isWan1Wan,false));
		TextRender.textRenderInst=this;
		Laya['textRender']=this;
		TextRender.atlasWidth2=TextRender.atlasWidth *TextRender.atlasWidth;
	}

	__class(TextRender,'laya.webgl.text.TextRender');
	var __proto=TextRender.prototype;
	/**
	*设置当前字体，获得字体的大小信息。
	*@param font
	*/
	__proto.setFont=function(font){
		if (this.lastFont==font)return;
		this.lastFont=font;
		var fontsz=this.getFontSizeInfo(font._family);
		var offx=fontsz >> 24;
		var offy=(fontsz >> 16)& 0xff;
		var fw=(fontsz >> 8)& 0xff;
		var fh=fontsz & 0xff;
		var k=font._size / TextRender.standardFontSize;
		this.fontSizeOffX=Math.ceil(offx *k);
		this.fontSizeOffY=Math.ceil(offy *k);
		this.fontSizeW=Math.ceil(fw *k);
		this.fontSizeH=Math.ceil(fh *k);
		this.fontStr=font._font.replace('italic','');
	}

	/**
	*从string中取出一个完整的char，例如emoji的话要多个
	*会修改 _curStrPos
	*TODO 由于各种文字中的组合写法，这个需要能扩展，以便支持泰文等
	*@param str
	*@param start 开始位置
	*/
	__proto.getNextChar=function(str){
		var len=str.length;
		var start=this._curStrPos;
		if (start >=len)
			return null;
		var link=false;
		var i=start;
		var state=0;
		for (;i < len;i++){
			var c=str.charCodeAt(i);
			if ((c >>> 11)==0x1b){
				if (state==1)break ;
				state=1;
				i++;
			}
			else if (c===0xfe0e || c===0xfe0f){}
			else if (c==0x200d){
				state=2;
				}else {
				if (state==0)state=1;
				else if (state==1)break ;
				else if (state==2){}
			}
		}
		this._curStrPos=i;
		return str.substring(start,i);
	}

	__proto.filltext=function(ctx,data,x,y,fontStr,color,strokeColor,lineWidth,textAlign,underLine){
		(underLine===void 0)&& (underLine=0);
		if (data.length <=0)
			return;
		var font=FontInfo.Parse(fontStr);
		var nTextAlign=0;
		switch (textAlign){
			case 'center':
				nTextAlign=Context.ENUM_TEXTALIGN_CENTER;
				break ;
			case 'right':
				nTextAlign=Context.ENUM_TEXTALIGN_RIGHT;
				break ;
			}
		this._fast_filltext(ctx,data,null,x,y,font,color,strokeColor,lineWidth,nTextAlign,underLine);
	}

	__proto.fillWords=function(ctx,data,x,y,fontStr,color,strokeColor,lineWidth){
		if (!data)return;
		if (data.length <=0)return;
		var font=FontInfo.Parse(fontStr);
		this._fast_filltext(ctx,null,data,x,y,font,color,strokeColor,lineWidth,0,0);
	}

	__proto._fast_filltext=function(ctx,data,htmlchars,x,y,font,color,strokeColor,lineWidth,textAlign,underLine){
		(underLine===void 0)&& (underLine=0);
		if (data && data.length < 1)return;
		if (htmlchars && htmlchars.length < 1)return;
		if (lineWidth < 0)lineWidth=0;
		this.setFont(font);
		this.fontScaleX=this.fontScaleY=1.0;
		if (TextRender.scaleFontWithCtx){
			var sx=1;
			var sy=1;
			if (Render.isConchApp){
				sx=ctx._curMat.getScaleX();
				sy=ctx._curMat.getScaleY();
				}else{
				sx=ctx.getMatScaleX();
				sy=ctx.getMatScaleY();
			}
			if (sx < 1e-4 || sy < 1e-1)
				return;
			if (sx > 1)this.fontScaleX=sx;
			if (sy > 1)this.fontScaleY=sy;
		}
		font._italic && (ctx._italicDeg=13);
		var wt=data;
		var isWT=!htmlchars && ((data instanceof laya.utils.WordText ));
		var str=data;
		var isHtmlChar=!!htmlchars;
		var sameTexData=isWT ? wt.pageChars :[];
		var strWidth=0;
		if (isWT){
			str=wt._text;
			strWidth=wt.width;
			if (strWidth < 0){
				strWidth=wt.width=this.charRender.getWidth(this.fontStr,str);
			}
			}else {
			strWidth=str?this.charRender.getWidth(this.fontStr,str):0;
		}
		switch (textAlign){
			case Context.ENUM_TEXTALIGN_CENTER:
				x-=strWidth / 2;
				break ;
			case Context.ENUM_TEXTALIGN_RIGHT:
				x-=strWidth;
				break ;
			}
		if (wt && sameTexData){
			if (this.hasFreedText(sameTexData)){
				sameTexData=wt.pageChars=[];
			}
		};
		var ri=null;
		var oneTex=isWT || TextRender.forceWholeRender;
		var splitTex=this.renderPerChar=(!isWT)|| TextRender.forceSplitRender || isHtmlChar;
		if (!sameTexData || sameTexData.length < 1){
			if (splitTex){
				var stx=0;
				var sty=0;
				this._curStrPos=0;
				var curstr;
				while(true){
					if (isHtmlChar){
						var chc=htmlchars[this._curStrPos++];
						if(chc){
							curstr=chc.char;
							stx=chc.x;
							sty=chc.y;
							}else {
							curstr=null;
						}
						}else {
						curstr=this.getNextChar(str);
					}
					if (!curstr)
						break ;
					ri=this.getCharRenderInfo(curstr,font,color,strokeColor,lineWidth,false);
					if (!ri){
						break ;
					}
					if (ri.isSpace){
						}else {
						var add=sameTexData[ri.tex.id];
						if (!add){
							sameTexData[ri.tex.id]=add=[];
						}
						if (Render.isConchApp){
							add.push({ri:ri,x:stx,y:sty,w:ri.bmpWidth / this.fontScaleX,h:ri.bmpHeight / this.fontScaleY });
							}else{
							add.push({ri:ri,x:stx+1/this.fontScaleX,y:sty+1/this.fontScaleY,w:(ri.bmpWidth-2)/ this.fontScaleX,h:(ri.bmpHeight-2)/ this.fontScaleY });
						}
						stx+=ri.width;
					}
				}
				}else {
				var isotex=TextRender.noAtlas || strWidth*this.fontScaleX > TextRender.atlasWidth;
				ri=this.getCharRenderInfo(str,font,color,strokeColor,lineWidth,isotex);
				if (Render.isConchApp){
					sameTexData[0]=[{ri:ri,x:0,y:0,w:ri.bmpWidth / this.fontScaleX,h:ri.bmpHeight / this.fontScaleY }];
					}else{
					sameTexData[0]=[{ri:ri,x:1/this.fontScaleX,y:1/this.fontScaleY,w:(ri.bmpWidth-2)/ this.fontScaleX,h:(ri.bmpHeight-2)/ this.fontScaleY }];
				}
			}
		}
		this._drawResortedWords(ctx,x,y,sameTexData);
		ctx._italicDeg=0;
	}

	/**
	*画出重新按照贴图顺序分组的文字。
	*@param samePagesData
	*@param startx 保存的数据是相对位置，所以需要加上这个偏移。用相对位置更灵活一些。
	*@param y {int}因为这个只能画在一行上所以没有必要保存y。所以这里再把y传进来
	*/
	__proto._drawResortedWords=function(ctx,startx,starty,samePagesData){
		var isLastRender=ctx._charSubmitCache && ctx._charSubmitCache._enbale;
		for (var id in samePagesData){
			var pri=samePagesData[id];
			var pisz=pri.length;if (pisz <=0)continue ;
			for (var j=0;j < pisz;j++){
				var riSaved=pri[j];
				var ri=riSaved.ri;
				if (ri.isSpace)continue ;
				ri.touch();
				ctx.drawTexAlign=true;
				if (Render.isConchApp){
					ctx._drawTextureM(ri.tex.texture,startx+riSaved.x-ri.orix ,starty+riSaved.y-ri.oriy,riSaved.w,riSaved.h,null,1.0,ri.uv);
				}else
				ctx._inner_drawTexture(ri.tex.texture,(ri.tex.texture).bitmap.id,
				startx+riSaved.x-ri.orix ,starty+riSaved.y-ri.oriy,riSaved.w,riSaved.h,
				null,ri.uv,1.0,isLastRender);
				if ((ctx).touches){
					(ctx).touches.push(ri);
				}
			}
		}
	}

	/**
	*检查 txts数组中有没有被释放的资源
	*@param txts {{ri:CharRenderInfo,...}[][]}
	*@param startid
	*@return
	*/
	__proto.hasFreedText=function(txts){
		for (var i in txts){
			var pri=txts[i];
			for (var j=0,pisz=pri.length;j < pisz;j++){
				var riSaved=(pri [j]).ri;
				if (riSaved.deleted || riSaved.tex.__destroyed){
					return true;
				}
			}
		}
		return false;
	}

	__proto.getCharRenderInfo=function(str,font,color,strokeColor,lineWidth,isoTexture){
		(isoTexture===void 0)&& (isoTexture=false);
		var fid=this.mapFont[font._family];
		if (fid==undefined){
			this.mapFont[font._family]=fid=this.fontID++;
		};
		var key=str+'_'+fid+'_'+font._size+'_'+color;
		if (lineWidth > 0)
			key+='_'+strokeColor+lineWidth;
		if (font._bold)
			key+='P';
		if (this.fontScaleX !=1 || this.fontScaleY !=1){
			key+=(this.fontScaleX*20|0)+'_'+(this.fontScaleY*20|0);
		};
		var i=0;
		var sz=this.textAtlases.length;
		var ri=null;
		var atlas=null;
		if(!isoTexture){
			for (i=0;i < sz;i++){
				atlas=this.textAtlases[i];
				ri=atlas.charMaps[key]
				if (ri){
					ri.touch();
					return ri;
				}
			}
		}
		ri=new CharRenderInfo();
		this.charRender.scale(this.fontScaleX,this.fontScaleY);
		ri.char=str;
		ri.height=font._size;
		var margin=font._size / 3 |0;
		var imgdt=null;
		var w1=Math.ceil(this.charRender.getWidth(this.fontStr,str)*this.fontScaleX);
		if (w1 > this.charRender.canvasWidth){
			this.charRender.canvasWidth=Math.min(2048,w1+margin *2);
		}
		if (isoTexture){
			imgdt=this.charRender.getCharBmp(str,this.fontStr,lineWidth,color,strokeColor,ri,margin,margin,margin,margin,null);
			var tex=TextTexture.getTextTexture(imgdt.width,imgdt.height);
			tex.addChar(imgdt,0,0,ri.uv);
			ri.tex=tex;
			ri.orix=margin;
			ri.oriy=margin;
			tex.ri=ri;
			this.isoTextures.push(tex);
			}else {
			var len=str.length;
			if (len > 1){
			};
			var lineExt=lineWidth*1;
			var fw=Math.ceil((this.fontSizeW+lineExt*2)*this.fontScaleX);
			var fh=Math.ceil((this.fontSizeH+lineExt*2)*this.fontScaleY);
			TextRender.imgdtRect[0]=((margin-this.fontSizeOffX-lineExt)*this.fontScaleX)|0;
			TextRender.imgdtRect[1]=((margin-this.fontSizeOffY-lineExt)*this.fontScaleY)|0;
			if (this.renderPerChar||len==1){
				TextRender.imgdtRect[2]=Math.max(w1,fw);
				TextRender.imgdtRect[3]=Math.max(w1,fh);
				}else {
				TextRender.imgdtRect[2]=-1;
				TextRender.imgdtRect[3]=fh;
			}
			imgdt=this.charRender.getCharBmp(str,this.fontStr,lineWidth,color,strokeColor,ri,
			margin,margin,margin,margin,TextRender.imgdtRect);
			atlas=this.addBmpData(imgdt,ri);
			if (TextRender.isWan1Wan){
				ri.orix=margin;
				ri.oriy=margin;
				}else {
				ri.orix=(this.fontSizeOffX+lineExt);
				ri.oriy=(this.fontSizeOffY+lineExt);
			}
			atlas.charMaps[key]=ri;
		}
		return ri;
	}

	/**
	*添加数据到大图集
	*@param w
	*@param h
	*@return
	*/
	__proto.addBmpData=function(data,ri){
		var w=data.width;
		var h=data.height;
		var sz=this.textAtlases.length;
		var atlas=null;
		var find=false;
		for (var i=0;i < sz;i++){
			atlas=this.textAtlases[i];
			find=atlas.getAEmpty(w,h,this.tmpAtlasPos);
			if (find){
				break ;
			}
		}
		if (!find){
			atlas=new TextAtlas()
			this.textAtlases.push(atlas);
			find=atlas.getAEmpty(w,h,this.tmpAtlasPos);
			if (!find){
				throw 'err1';
			}
			this.cleanAtlases();
		}
		if(find){
			atlas.texture.addChar(data,this.tmpAtlasPos.x,this.tmpAtlasPos.y,ri.uv);
			ri.tex=/*__JS__ */atlas.texture;
		}
		return atlas;
	}

	__proto.GC=function(force){
		var i=0;
		var sz=this.textAtlases.length;
		var dt=0;
		var destroyDt=TextRender.destroyAtlasDt;
		var totalUsedRate=0;
		var totalUsedRateAtlas=0;
		var maxWasteRateID=-1;
		var maxWasteRate=0;
		var tex=null;
		var curatlas=null;
		for (;i < sz;i++){
			curatlas=this.textAtlases[i];
			tex=curatlas.texture;
			if (tex){
				totalUsedRate+=tex.curUsedCovRate;
				totalUsedRateAtlas+=tex.curUsedCovRateAtlas;
				var waste=curatlas.usedRate-tex.curUsedCovRateAtlas;
				if (maxWasteRate < waste){
					maxWasteRate=waste;
					maxWasteRateID=i;
				}
			}
			dt=Stat.loopCount-curatlas.texture.lastTouchTm;
			if (dt > destroyDt){
				TextRender.showLog && console.log('TextRender GC delete atlas '+tex?curatlas.texture.id:'unk');
				curatlas.destroy();
				this.textAtlases[i]=this.textAtlases[sz-1];
				sz--;
				i--;
			}
		}
		this.textAtlases.length=sz;
		sz=this.isoTextures.length;
		for (i=0;i < sz;i++){
			tex=this.isoTextures[i];
			dt=Stat.loopCount-tex.lastTouchTm;
			if (dt > TextRender.destroyUnusedTextureDt){
				tex.ri.deleted=true;
				tex.ri.tex=null;
				tex.destroy();
				this.isoTextures[i]=this.isoTextures[sz-1];
				sz--;
				i--;
			}
		};
		var needGC=this.textAtlases.length > 1 && this.textAtlases.length-totalUsedRateAtlas >=2;
		if (TextRender.atlasWidth *TextRender.atlasWidth *4 *this.textAtlases.length > TextRender.cleanMem || needGC || TextRender.simClean){
			TextRender.simClean=false;
			TextRender.showLog && console.log('清理使用率低的贴图。总使用率:',totalUsedRateAtlas,':',this.textAtlases.length,'最差贴图:'+maxWasteRateID);
			if(maxWasteRateID>=0){
				curatlas=this.textAtlases[maxWasteRateID];
				curatlas.destroy();
				this.textAtlases[maxWasteRateID]=this.textAtlases[this.textAtlases.length-1];
				this.textAtlases.length=this.textAtlases.length-1;
			}
		}
		TextTexture.clean();
	}

	/**
	*尝试清理大图集
	*/
	__proto.cleanAtlases=function(){}
	// TODO 根据覆盖率决定是否清理
	__proto.getCharBmp=function(c){}
	/**
	*检查当前线是否存在数据
	*@param data
	*@param l
	*@param sx
	*@param ex
	*@return
	*/
	__proto.checkBmpLine=function(data,l,sx,ex){
		if (this.bmpData32.buffer !=data.data.buffer){
			this.bmpData32=new Uint32Array(data.data.buffer);
		};
		var stpos=data.width *l+sx;
		for (var x=sx;x < ex;x++){
			if (this.bmpData32[stpos++] !=0)return true;
		}
		return false;
	}

	/**
	*根据bmp数据和当前的包围盒，更新包围盒
	*由于选择的文字是连续的，所以可以用二分法
	*@param data
	*@param curbbx [l,t,r,b]
	*@param onlyH 不检查左右
	*/
	__proto.updateBbx=function(data,curbbx,onlyH){
		(onlyH===void 0)&& (onlyH=false);
		var w=data.width;
		var h=data.height;
		var x=0;
		var sy=curbbx[1];
		var ey=0;
		var y=sy;
		if (this.checkBmpLine(data,sy,0,w)){
			while (true){
				y=(sy+ey)/ 2 | 0;
				if (y+1 >=sy){
					curbbx[1]=y;
					break ;
				}
				if(this.checkBmpLine(data,y,0,w)){
					sy=y;
					}else {
					ey=y;
				}
			}
		}
		if (curbbx[3] > h)curbbx[3]=h;
		else{
			y=sy=curbbx[3];
			ey=h;
			if (this.checkBmpLine(data,sy,0,w)){
				while(true){
					y=(sy+ey)/ 2 | 0;
					if (y-1 <=sy){
						curbbx[3]=y;
						break ;
					}
					if (this.checkBmpLine(data,y,0,w)){
						sy=y;
						}else {
						ey=y;
					}
				}
			}
		}
		if (onlyH)
			return;
		var minx=curbbx[0];
		var stpos=w*curbbx[1];
		for (y=curbbx[1];y < curbbx[3];y++){
			for (x=0;x < minx;x++){
				if (this.bmpData32[stpos+x] !=0){
					minx=x;
					break ;
				}
			}
			stpos+=w;
		}
		curbbx[0]=minx;
		var maxx=curbbx[2];
		stpos=w*curbbx[1];
		for (y=curbbx[1];y < curbbx[3];y++){
			for (x=maxx;x < w;x++){
				if (this.bmpData32[stpos+x] !=0){
					maxx=x;
					break ;
				}
			}
			stpos+=w;
		}
		curbbx[2]=maxx;
	}

	__proto.getFontSizeInfo=function(font){
		var finfo=this.fontSizeInfo[font];
		if (finfo !=undefined)
			return finfo;
		var fontstr='bold '+TextRender.standardFontSize+'px '+font;
		if (TextRender.isWan1Wan){
			this.fontSizeW=this.charRender.getWidth(fontstr,'国')*1.5;
			this.fontSizeH=TextRender.standardFontSize *1.5;
			var szinfo=this.fontSizeW << 8 | this.fontSizeH;
			this.fontSizeInfo[font]=szinfo;
			return szinfo;
		}
		TextRender.pixelBBX[0]=TextRender.standardFontSize / 2;
		TextRender.pixelBBX[1]=TextRender.standardFontSize / 2;
		TextRender.pixelBBX[2]=TextRender.standardFontSize;
		TextRender.pixelBBX[3]=TextRender.standardFontSize;
		var orix=16;
		var oriy=16;
		var marginr=16;
		var marginb=16;
		this.charRender.scale(1,1);
		TextRender.tmpRI.height=TextRender.standardFontSize;
		var bmpdt=this.charRender.getCharBmp('g',fontstr,0,'red',null,TextRender.tmpRI,orix,oriy,marginr,marginb);
		if (Render.isConchApp){
			bmpdt.data=new /*__JS__ */Uint8ClampedArray(bmpdt.data);
		}
		this.bmpData32=new Uint32Array(bmpdt.data.buffer);
		this.updateBbx(bmpdt,TextRender.pixelBBX,false);
		bmpdt=this.charRender.getCharBmp('国',fontstr,0,'red',null,TextRender.tmpRI,oriy,oriy,marginr,marginb);
		if (Render.isConchApp){
			bmpdt.data=new /*__JS__ */Uint8ClampedArray(bmpdt.data);
		}
		this.bmpData32=new Uint32Array(bmpdt.data.buffer);
		if (TextRender.pixelBBX[2] < orix+TextRender.tmpRI.width)
			TextRender.pixelBBX[2]=orix+TextRender.tmpRI.width;
		this.updateBbx(bmpdt,TextRender.pixelBBX,false);
		if (Render.isConchApp){
			orix=0;
			oriy=0;
		};
		var xoff=Math.max(orix-TextRender.pixelBBX[0],0);
		var yoff=Math.max(oriy-TextRender.pixelBBX[1],0);
		var bbxw=TextRender.pixelBBX[2]-TextRender.pixelBBX[0];
		var bbxh=TextRender.pixelBBX[3]-TextRender.pixelBBX[1];
		var sizeinfo=xoff<<24 |yoff<<16 | bbxw << 8 | bbxh;
		this.fontSizeInfo[font]=sizeinfo;
		return sizeinfo;
	}

	__proto.printDbgInfo=function(){
		console.log('图集个数:'+this.textAtlases.length+',每个图集大小:'+TextRender.atlasWidth+'x'+TextRender.atlasWidth,' 用canvas:',TextRender.isWan1Wan);
		console.log('图集占用空间:'+(TextRender.atlasWidth *TextRender.atlasWidth *4 / 1024 / 1024 *this.textAtlases.length)+'M');
		console.log('缓存用到的字体:');
		for (var f in this.mapFont){
			var fontsz=this.getFontSizeInfo(f);
			var offx=fontsz >> 24;
			var offy=(fontsz >> 16)& 0xff;
			var fw=(fontsz >> 8)& 0xff;
			var fh=fontsz & 0xff;
			console.log('    '+f,' off:',offx,offy,' size:',fw,fh);
		};
		var num=0;
		console.log('缓存数据:');
		var totalUsedRate=0;
		var totalUsedRateAtlas=0;
		this.textAtlases.forEach(function(a){
			var id=a.texture.id;
			var dt=Stat.loopCount-a.texture.lastTouchTm;
			var dtstr=dt > 0?(''+dt+'帧以前'):'当前帧';
			totalUsedRate+=a.texture.curUsedCovRate;
			totalUsedRateAtlas+=a.texture.curUsedCovRateAtlas;
			console.log('--图集(id:'+id+',当前使用率:'+(a.texture.curUsedCovRate*1000|0)+'‰','当前图集使用率:',(a.texture.curUsedCovRateAtlas*100|0)+'%','图集使用率:',(a.usedRate*100|0),'%, 使用于:'+dtstr+')--:');
			for (var k in a.charMaps){
				var ri=a.charMaps[k];
				console.log('     off:',ri.orix,ri.oriy,' bmp宽高:',ri.bmpWidth,ri.bmpHeight,'无效:',ri.deleted,'touchdt:',(Stat.loopCount-ri.touchTick),'位置:',ri.uv[0] *TextRender.atlasWidth | 0,ri.uv[1] *TextRender.atlasWidth | 0,
				'字符:',ri.char,'key:',k);
				num++;
			}
		});
		console.log('独立贴图文字('+this.isoTextures.length+'个):');
		this.isoTextures.forEach(function(tex){
			console.log('    size:',tex._texW,tex._texH,'touch间隔:',(Stat.loopCount-tex.lastTouchTm),'char:',tex.ri.char);
		});
		console.log('总缓存:',num,'总使用率:',totalUsedRate,'总当前图集使用率:',totalUsedRateAtlas);
	}

	// 在屏幕上显示某个大图集
	__proto.showAtlas=function(n,bgcolor,x,y,w,h){
		if (!this.textAtlases[n]){
			console.log('没有这个图集');
			return null;
		};
		var sp=new Sprite();
		var texttex=this.textAtlases[n].texture;
		var texture={
			width:TextRender.atlasWidth,
			height:TextRender.atlasWidth,
			sourceWidth:TextRender.atlasWidth,
			sourceHeight:TextRender.atlasWidth,
			offsetX:0,
			offsetY:0,
			getIsReady:function (){return true;},
			_addReference:function (){},
			_removeReference:function (){},
			_getSource:function (){return texttex._getSource();},
			bitmap:{id:texttex.id },
			_uv:Texture.DEF_UV
		};
		(sp).size=function (w,h){
			this.width=w;
			this.height=h;
			sp.graphics.clear();
			sp.graphics.drawRect(0,0,sp.width,sp.height,bgcolor);
			sp.graphics.drawTexture(texture,0,0,sp.width,sp.height);
			return this;
		}
		sp.graphics.drawRect(0,0,w,h,bgcolor);
		sp.graphics.drawTexture(texture,0,0,w,h);
		sp.pos(x,y);
		Laya.stage.addChild(sp);
		return sp;
	}

	/////// native ///////
	__proto.filltext_native=function(ctx,data,htmlchars,x,y,fontStr,color,strokeColor,lineWidth,textAlign,underLine){
		(underLine===void 0)&& (underLine=0);
		if (data && data.length <=0)return;
		if (htmlchars && htmlchars.length < 1)return;
		var font=FontInfo.Parse(fontStr);
		var nTextAlign=0;
		switch (textAlign){
			case 'center':
				nTextAlign=Context.ENUM_TEXTALIGN_CENTER;
				break ;
			case 'right':
				nTextAlign=Context.ENUM_TEXTALIGN_RIGHT;
				break ;
			}
		return this._fast_filltext(ctx,data,htmlchars,x,y,font,color,strokeColor,lineWidth,nTextAlign,underLine);
	}

	TextRender.useOldCharBook=false;
	TextRender.atlasWidth=2048;
	TextRender.noAtlas=false;
	TextRender.forceSplitRender=false;
	TextRender.forceWholeRender=false;
	TextRender.scaleFontWithCtx=true;
	TextRender.standardFontSize=32;
	TextRender.destroyAtlasDt=10;
	TextRender.checkCleanTextureDt=2000;
	TextRender.destroyUnusedTextureDt=3000;
	TextRender.cleanMem=100 *1024 *1024;
	TextRender.isWan1Wan=false;
	TextRender.showLog=false;
	TextRender.debugUV=false;
	TextRender.atlasWidth2=2048 *2048;
	TextRender.textRenderInst=null;
	TextRender.simClean=false;
	__static(TextRender,
	['tmpRI',function(){return this.tmpRI=new CharRenderInfo();},'pixelBBX',function(){return this.pixelBBX=[0,0,0,0];},'imgdtRect',function(){return this.imgdtRect=[0,0,0,0];}
	]);
	return TextRender;
})()


/**
*...
*@author ww
*/
//class laya.layagl.ConchGraphicsAdpt
var ConchGraphicsAdpt=(function(){
	function ConchGraphicsAdpt(){
		this._commandEncoder=null;
	}

	__class(ConchGraphicsAdpt,'laya.layagl.ConchGraphicsAdpt');
	var __proto=ConchGraphicsAdpt.prototype;
	//TODO:coverage
	__proto._createData=function(){
		this._commandEncoder=LayaGL.instance.createCommandEncoder(128,64,true);
	}

	//TODO:coverage
	__proto._clearData=function(){
		if (this._commandEncoder)this._commandEncoder.clearEncoding();
	}

	//TODO:coverage
	__proto._destroyData=function(){
		if (this._commandEncoder){
			this._commandEncoder.clearEncoding();
			this._commandEncoder=null;
		}
	}

	ConchGraphicsAdpt.__init__=function(){
		var spP=Graphics["prototype"];
		var mP=ConchGraphicsAdpt["prototype"];
		var funs=[
		"_createData",
		"_clearData",
		"_destroyData"];
		var i=0,len=0;
		len=funs.length;
		var tFunName;
		for (i=0;i < len;i++){
			tFunName=funs[i];
			spP[tFunName]=mP[tFunName];
		}
	}

	return ConchGraphicsAdpt;
})()


//class laya.webgl.utils.MatirxArray
var MatirxArray=(function(){
	function MatirxArray(){}
	__class(MatirxArray,'laya.webgl.utils.MatirxArray');
	MatirxArray.ArrayMul=function(a,b,o){
		if (!a){
			MatirxArray.copyArray(b,o);
			return;
		}
		if (!b){
			MatirxArray.copyArray(a,o);
			return;
		};
		var ai0=NaN,ai1=NaN,ai2=NaN,ai3=NaN;
		for (var i=0;i < 4;i++){
			ai0=a[i];
			ai1=a[i+4];
			ai2=a[i+8];
			ai3=a[i+12];
			o[i]=ai0 *b[0]+ai1 *b[1]+ai2 *b[2]+ai3 *b[3];
			o[i+4]=ai0 *b[4]+ai1 *b[5]+ai2 *b[6]+ai3 *b[7];
			o[i+8]=ai0 *b[8]+ai1 *b[9]+ai2 *b[10]+ai3 *b[11];
			o[i+12]=ai0 *b[12]+ai1 *b[13]+ai2 *b[14]+ai3 *b[15];
		}
	}

	MatirxArray.copyArray=function(f,t){
		if (!f)return;
		if (!t)return;
		for (var i=0;i < f.length;i++){
			t[i]=f[i];
		}
	}

	return MatirxArray;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.RotateCmdNative
var RotateCmdNative=(function(){
	function RotateCmdNative(){
		this._graphicsCmdEncoder=null;
		this._paramData=/*__JS__ */new ParamData(3 *4,true);
	}

	__class(RotateCmdNative,'laya.layagl.cmdNative.RotateCmdNative');
	var __proto=RotateCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("RotateCmd",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "Rotate";
	});

	__getset(0,__proto,'angle',function(){
		return this._paramData._float32Data[0];
		},function(value){
		this._paramData._float32Data[0]=value;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'pivotX',function(){
		return this._paramData._float32Data[1];
		},function(value){
		this._paramData._float32Data[1]=value;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'pivotY',function(){
		return this._paramData._float32Data[2];
		},function(value){
		this._paramData._float32Data[2]=value;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	RotateCmdNative.create=function(angle,pivotX,pivotY){
		var cmd=Pool.getItemByClass("RotateCmd",RotateCmdNative);
		var cbuf=cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;
		var f32=cmd._paramData._float32Data;
		f32[0]=angle;
		f32[1]=pivotX;
		f32[2]=pivotY;
		var nDataID=cmd._paramData.getPtrID();
		LayaGL.syncBufferToRenderThread(cmd._paramData);
		cbuf.setGlobalValueEx(LayaNative2D.GLOBALVALUE_MATRIX32,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_ROTATE_PIVOT*/13,nDataID,0);
		LayaGL.syncBufferToRenderThread(cbuf);
		return cmd;
	}

	RotateCmdNative.ID="Rotate";
	return RotateCmdNative;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.SaveCmdNative
var SaveCmdNative=(function(){
	function SaveCmdNative(){
		this._graphicsCmdEncoder=null;
	}

	__class(SaveCmdNative,'laya.layagl.cmdNative.SaveCmdNative');
	var __proto=SaveCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("SaveCmd",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "Save";
	});

	SaveCmdNative.create=function(){
		var cmd=Pool.getItemByClass("SaveCmd",SaveCmdNative);
		var cbuf=cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		cbuf.save();
		LayaGL.syncBufferToRenderThread(cbuf);
		return cmd;
	}

	SaveCmdNative.ID="Save";
	return SaveCmdNative;
})()


/**
*...
*@author ...
*/
//class laya.webgl.VertexArrayObject
var VertexArrayObject=(function(){
	function VertexArrayObject(){}
	__class(VertexArrayObject,'laya.webgl.VertexArrayObject');
	return VertexArrayObject;
})()


/*__JS__ */(function(){var glErrorShadow={};function error(msg){if(window.console&&window.console.error){window.console.error(msg)}}function log(msg){if(window.console&&window.console.log){window.console.log(msg)}}function synthesizeGLError(err,opt_msg){glErrorShadow[err]=true;if(opt_msg!==undefined){error(opt_msg)}}function wrapGLError(gl){var f=gl.getError;gl.getError=function(){var err;do{err=f.apply(gl);if(err!=gl.NO_ERROR){glErrorShadow[err]=true}}while(err!=gl.NO_ERROR);for(var err in glErrorShadow){if(glErrorShadow[err]){delete glErrorShadow[err];return parseInt(err)}}return gl.NO_ERROR}}var WebGLVertexArrayObjectOES=function WebGLVertexArrayObjectOES(ext){var gl=ext.gl;this.ext=ext;this.isAlive=true;this.hasBeenBound=false;this.elementArrayBuffer=null;this.attribs=new Array(ext.maxVertexAttribs);for(var n=0;n<this.attribs.length;n++){var attrib=new WebGLVertexArrayObjectOES.VertexAttrib(gl);this.attribs[n]=attrib}this.maxAttrib=0};WebGLVertexArrayObjectOES.VertexAttrib=function VertexAttrib(gl){this.enabled=false;this.buffer=null;this.size=4;this.type=gl.FLOAT;this.normalized=false;this.stride=16;this.offset=0;this.cached="";this.recache()};WebGLVertexArrayObjectOES.VertexAttrib.prototype.recache=function recache(){this.cached=[this.size,this.type,this.normalized,this.stride,this.offset].join(":")};var OESVertexArrayObject=function OESVertexArrayObject(gl){var self=this;this.gl=gl;wrapGLError(gl);var original=this.original={getParameter:gl.getParameter,enableVertexAttribArray:gl.enableVertexAttribArray,disableVertexAttribArray:gl.disableVertexAttribArray,bindBuffer:gl.bindBuffer,getVertexAttrib:gl.getVertexAttrib,vertexAttribPointer:gl.vertexAttribPointer};gl.getParameter=function getParameter(pname){if(pname==self.VERTEX_ARRAY_BINDING_OES){if(self.currentVertexArrayObject==self.defaultVertexArrayObject){return null}else{return self.currentVertexArrayObject}}return original.getParameter.apply(this,arguments)};gl.enableVertexAttribArray=function enableVertexAttribArray(index){var vao=self.currentVertexArrayObject;vao.maxAttrib=Math.max(vao.maxAttrib,index);var attrib=vao.attribs[index];attrib.enabled=true;return original.enableVertexAttribArray.apply(this,arguments)};gl.disableVertexAttribArray=function disableVertexAttribArray(index){var vao=self.currentVertexArrayObject;vao.maxAttrib=Math.max(vao.maxAttrib,index);var attrib=vao.attribs[index];attrib.enabled=false;return original.disableVertexAttribArray.apply(this,arguments)};gl.bindBuffer=function bindBuffer(target,buffer){switch(target){case gl.ARRAY_BUFFER:self.currentArrayBuffer=buffer;break;case gl.ELEMENT_ARRAY_BUFFER:self.currentVertexArrayObject.elementArrayBuffer=buffer;break}return original.bindBuffer.apply(this,arguments)};gl.getVertexAttrib=function getVertexAttrib(index,pname){var vao=self.currentVertexArrayObject;var attrib=vao.attribs[index];switch(pname){case gl.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING:return attrib.buffer;case gl.VERTEX_ATTRIB_ARRAY_ENABLED:return attrib.enabled;case gl.VERTEX_ATTRIB_ARRAY_SIZE:return attrib.size;case gl.VERTEX_ATTRIB_ARRAY_STRIDE:return attrib.stride;case gl.VERTEX_ATTRIB_ARRAY_TYPE:return attrib.type;case gl.VERTEX_ATTRIB_ARRAY_NORMALIZED:return attrib.normalized;default:return original.getVertexAttrib.apply(this,arguments)}};gl.vertexAttribPointer=function vertexAttribPointer(indx,size,type,normalized,stride,offset){var vao=self.currentVertexArrayObject;vao.maxAttrib=Math.max(vao.maxAttrib,indx);var attrib=vao.attribs[indx];attrib.buffer=self.currentArrayBuffer;attrib.size=size;attrib.type=type;attrib.normalized=normalized;attrib.stride=stride;attrib.offset=offset;attrib.recache();return original.vertexAttribPointer.apply(this,arguments)};if(gl.instrumentExtension){gl.instrumentExtension(this,"OES_vertex_array_object")}if(gl.canvas&&gl.canvas.addEventListener)gl.canvas.addEventListener("webglcontextrestored",function(){log("OESVertexArrayObject emulation library context restored");self.reset_()},true);this.reset_()};OESVertexArrayObject.prototype.VERTEX_ARRAY_BINDING_OES=34229;OESVertexArrayObject.prototype.reset_=function reset_(){var contextWasLost=this.vertexArrayObjects!==undefined;if(contextWasLost){for(var ii=0;ii<this.vertexArrayObjects.length;++ii){this.vertexArrayObjects.isAlive=false}}var gl=this.gl;this.maxVertexAttribs=gl.getParameter(gl.MAX_VERTEX_ATTRIBS);this.defaultVertexArrayObject=new WebGLVertexArrayObjectOES(this);this.currentVertexArrayObject=null;this.currentArrayBuffer=null;this.vertexArrayObjects=[this.defaultVertexArrayObject];this.bindVertexArrayOES(null)};OESVertexArrayObject.prototype.createVertexArrayOES=function createVertexArrayOES(){var arrayObject=new WebGLVertexArrayObjectOES(this);this.vertexArrayObjects.push(arrayObject);return arrayObject};OESVertexArrayObject.prototype.deleteVertexArrayOES=function deleteVertexArrayOES(arrayObject){arrayObject.isAlive=false;this.vertexArrayObjects.splice(this.vertexArrayObjects.indexOf(arrayObject),1);if(this.currentVertexArrayObject==arrayObject){this.bindVertexArrayOES(null)}};OESVertexArrayObject.prototype.isVertexArrayOES=function isVertexArrayOES(arrayObject){if(arrayObject&&arrayObject instanceof WebGLVertexArrayObjectOES){if(arrayObject.hasBeenBound&&arrayObject.ext==this){return true}}return false};OESVertexArrayObject.prototype.bindVertexArrayOES=function bindVertexArrayOES(arrayObject){var gl=this.gl;if(arrayObject&&!arrayObject.isAlive){synthesizeGLError(gl.INVALID_OPERATION,"bindVertexArrayOES: attempt to bind deleted arrayObject");return}var original=this.original;var oldVAO=this.currentVertexArrayObject;this.currentVertexArrayObject=arrayObject||this.defaultVertexArrayObject;this.currentVertexArrayObject.hasBeenBound=true;var newVAO=this.currentVertexArrayObject;if(oldVAO==newVAO){return}if(!oldVAO||newVAO.elementArrayBuffer!=oldVAO.elementArrayBuffer){original.bindBuffer.call(gl,gl.ELEMENT_ARRAY_BUFFER,newVAO.elementArrayBuffer)}var currentBinding=this.currentArrayBuffer;var maxAttrib=Math.max(oldVAO?oldVAO.maxAttrib:0,newVAO.maxAttrib);for(var n=0;n<=maxAttrib;n++){var attrib=newVAO.attribs[n];var oldAttrib=oldVAO?oldVAO.attribs[n]:null;if(!oldVAO||attrib.enabled!=oldAttrib.enabled){if(attrib.enabled){original.enableVertexAttribArray.call(gl,n)}else{original.disableVertexAttribArray.call(gl,n)}}if(attrib.enabled){var bufferChanged=false;if(!oldVAO||attrib.buffer!=oldAttrib.buffer){if(currentBinding!=attrib.buffer){original.bindBuffer.call(gl,gl.ARRAY_BUFFER,attrib.buffer);currentBinding=attrib.buffer}bufferChanged=true}if(bufferChanged||attrib.cached!=oldAttrib.cached){original.vertexAttribPointer.call(gl,n,attrib.size,attrib.type,attrib.normalized,attrib.stride,attrib.offset)}}}if(this.currentArrayBuffer!=currentBinding){original.bindBuffer.call(gl,gl.ARRAY_BUFFER,this.currentArrayBuffer)}};window._setupVertexArrayObject=function(gl){var original_getSupportedExtensions=gl.getSupportedExtensions;gl.getSupportedExtensions=function getSupportedExtensions(){var list=original_getSupportedExtensions.call(this)||[];if(list.indexOf("OES_vertex_array_object")<0){list.push("OES_vertex_array_object")}return list};var original_getExtension=gl.getExtension;gl.getExtension=function getExtension(name){var ext=original_getExtension.call(this,name);if(ext){return ext}if(name!=="OES_vertex_array_object"){return null}if(!this.__OESVertexArrayObject){console.log("Setup OES_vertex_array_object polyfill");this.__OESVertexArrayObject=new OESVertexArrayObject(this)}return this.__OESVertexArrayObject}};window._forceSetupVertexArrayObject=function(gl){var original_getSupportedExtensions=gl.getSupportedExtensions;gl.getSupportedExtensions=function getSupportedExtensions(){var list=original_getSupportedExtensions.call(this)||[];if(list.indexOf("OES_vertex_array_object")<0){list.push("OES_vertex_array_object")}return list};var original_getExtension=gl.getExtension;gl.getExtension=function getExtension(name){if(name==="OES_vertex_array_object"){if(!this.__OESVertexArrayObject){console.log("Setup OES_vertex_array_object polyfill");this.__OESVertexArrayObject=new OESVertexArrayObject(this)}return this.__OESVertexArrayObject}else{var ext=original_getExtension.call(this,name);if(ext){return ext}else{return null}}}}}());;
/**
*Javascript Arabic Reshaper by Louy Alakkad
*https://github.com/louy/Javascript-Arabic-Reshaper
*Based on (http://git.io/vsnAd)
*/
//class laya.webgl.text.ArabicReshaper
var ArabicReshaper=(function(){
	function ArabicReshaper(){}
	__class(ArabicReshaper,'laya.webgl.text.ArabicReshaper');
	var __proto=ArabicReshaper.prototype;
	//TODO:coverage
	__proto.characterMapContains=function(c){
		for (var i=0;i < ArabicReshaper.charsMap.length;++i){
			if (ArabicReshaper.charsMap[ i][0]===c){
				return true;
			}
		}
		return false;
	}

	//TODO:coverage
	__proto.getCharRep=function(c){
		for (var i=0;i < ArabicReshaper.charsMap.length;++i){
			if (ArabicReshaper.charsMap[ i][0]===c){
				return ArabicReshaper.charsMap[i];
			}
		}
		return false;
	}

	//TODO:coverage
	__proto.getCombCharRep=function(c1,c2){
		for (var i=0;i < ArabicReshaper.combCharsMap.length;++i){
			if (ArabicReshaper.combCharsMap[i][0][0]===c1 && ArabicReshaper.combCharsMap[i][0][1]===c2){
				return ArabicReshaper.combCharsMap[i];
			}
		}
		return false;
	}

	//TODO:coverage
	__proto.isTransparent=function(c){
		for (var i=0;i < ArabicReshaper.transChars.length;++i){
			if (ArabicReshaper.transChars[i]===c){
				return true;
			}
		}
		return false;
	}

	//TODO:coverage
	__proto.getOriginalCharsFromCode=function(code){
		var j=0;
		for (j=0;j < ArabicReshaper.charsMap.length;++j){
			if (ArabicReshaper.charsMap[j].indexOf(code)>-1){
				return String.fromCharCode(ArabicReshaper.charsMap[j][0]);
			}
		}
		for (j=0;j < ArabicReshaper.combCharsMap.length;++j){
			if (ArabicReshaper.combCharsMap[j].indexOf(code)>-1){
				return String.fromCharCode(ArabicReshaper.combCharsMap[j][0][0])+
				String.fromCharCode(ArabicReshaper.combCharsMap[j][0][1]);
			}
		}
		return String.fromCharCode(code);
	}

	//TODO:coverage
	__proto.convertArabic=function(normal){
		var crep,
		combcrep,
		shaped='';
		for (var i=0;i < normal.length;++i){
			var current=normal.charCodeAt(i);
			if (this.characterMapContains(current)){
				var prev=null,
				next=null,
				prevID=i-1,
				nextID=i+1;
				for (;prevID >=0;--prevID){
					if (!this.isTransparent(normal.charCodeAt(prevID))){
						break ;
					}
				}
				prev=(prevID >=0)? normal.charCodeAt(prevID):null;
				crep=prev ? this.getCharRep(prev):false;
				if (!crep || crep[2]==null && crep[3]==null){
					prev=null;
				}
				for (;nextID < normal.length;++nextID){
					if (!this.isTransparent(normal.charCodeAt(nextID))){
						break ;
					}
				}
				next=(nextID < normal.length)? normal.charCodeAt(nextID):null;
				crep=next ? this.getCharRep(next):false;
				if (!crep || crep[3]==null && crep[4]==null){
					next=null;
				}
				if (current===0x0644 && next !=null &&
					(next===0x0622 || next===0x0623 || next===0x0625 || next===0x0627)){
					combcrep=this.getCombCharRep(current,next);
					if (prev !=null){
						shaped+=String.fromCharCode(combcrep[4]);
						}else {
						shaped+=String.fromCharCode(combcrep[1]);
					}
					++i;
					continue ;
				}
				crep=this.getCharRep(current);
				if (prev !=null && next !=null && crep[3] !=null){
					shaped+=String.fromCharCode(crep[3]);
					continue ;
				}else
				if (prev !=null && crep[4] !=null){
					shaped+=String.fromCharCode(crep[4]);
					continue ;
				}else
				if (next !=null && crep[2] !=null){
					shaped+=String.fromCharCode(crep[2]);
					continue ;
					}else {
					shaped+=String.fromCharCode(crep[1]);
				}
				}else {
				shaped+=String.fromCharCode(current);
			}
		}
		return shaped;
	}

	//TODO:coverage
	__proto.convertArabicBack=function(apfb){
		var toReturn='',
		selectedChar=0;
		var i=0;
		theLoop:
		for (i=0;i < apfb.length;++i){
			selectedChar=apfb.charCodeAt(i);
			toReturn+=this.getOriginalCharsFromCode(selectedChar);
		}
		return toReturn;
	}

	__static(ArabicReshaper,
	['charsMap',function(){return this.charsMap=[
		[0x0621,0xFE80,null,null,null],
		[0x0622,0xFE81,null,null,0xFE82],
		[0x0623,0xFE83,null,null,0xFE84],
		[0x0624,0xFE85,null,null,0xFE86],
		[0x0625,0xFE87,null,null,0xFE88],
		[0x0626,0xFE89,0xFE8B,0xFE8C,0xFE8A],
		[0x0627,0xFE8D,null,null,0xFE8E],
		[0x0628,0xFE8F,0xFE91,0xFE92,0xFE90],
		[0x0629,0xFE93,null,null,0xFE94],
		[0x062A,0xFE95,0xFE97,0xFE98,0xFE96],
		[0x062B,0xFE99,0xFE9B,0xFE9C,0xFE9A],
		[0x062C,0xFE9D,0xFE9F,0xFEA0,0xFE9E],
		[0x062D,0xFEA1,0xFEA3,0xFEA4,0xFEA2],
		[0x062E,0xFEA5,0xFEA7,0xFEA8,0xFEA6],
		[0x062F,0xFEA9,null,null,0xFEAA],
		[0x0630,0xFEAB,null,null,0xFEAC],
		[0x0631,0xFEAD,null,null,0xFEAE],
		[0x0632,0xFEAF,null,null,0xFEB0],
		[0x0633,0xFEB1,0xFEB3,0xFEB4,0xFEB2],
		[0x0634,0xFEB5,0xFEB7,0xFEB8,0xFEB6],
		[0x0635,0xFEB9,0xFEBB,0xFEBC,0xFEBA],
		[0x0636,0xFEBD,0xFEBF,0xFEC0,0xFEBE],
		[0x0637,0xFEC1,0xFEC3,0xFEC4,0xFEC2],
		[0x0638,0xFEC5,0xFEC7,0xFEC8,0xFEC6],
		[0x0639,0xFEC9,0xFECB,0xFECC,0xFECA],
		[0x063A,0xFECD,0xFECF,0xFED0,0xFECE],
		[0x0640,0x0640,0x0640,0x0640,0x0640],
		[0x0641,0xFED1,0xFED3,0xFED4,0xFED2],
		[0x0642,0xFED5,0xFED7,0xFED8,0xFED6],
		[0x0643,0xFED9,0xFEDB,0xFEDC,0xFEDA],
		[0x0644,0xFEDD,0xFEDF,0xFEE0,0xFEDE],
		[0x0645,0xFEE1,0xFEE3,0xFEE4,0xFEE2],
		[0x0646,0xFEE5,0xFEE7,0xFEE8,0xFEE6],
		[0x0647,0xFEE9,0xFEEB,0xFEEC,0xFEEA],
		[0x0648,0xFEED,null,null,0xFEEE],
		[0x0649,0xFEEF,null,null,0xFEF0],
		[0x064A,0xFEF1,0xFEF3,0xFEF4,0xFEF2],
		[0x067E,0xFB56,0xFB58,0xFB59,0xFB57],
		[0x06CC,0xFBFC,0xFBFE,0xFBFF,0xFBFD],
		[0x0686,0xFB7A,0xFB7C,0xFB7D,0xFB7B],
		[0x06A9,0xFB8E,0xFB90,0xFB91,0xFB8F],
		[0x06AF,0xFB92,0xFB94,0xFB95,0xFB93],
		[0x0698,0xFB8A,null,null,0xFB8B],];},'combCharsMap',function(){return this.combCharsMap=[
		[[0x0644,0x0622],0xFEF5,null,null,0xFEF6],
		[[0x0644,0x0623],0xFEF7,null,null,0xFEF8],
		[[0x0644,0x0625],0xFEF9,null,null,0xFEFA],
		[[0x0644,0x0627],0xFEFB,null,null,0xFEFC],];},'transChars',function(){return this.transChars=[
		0x0610,
		0x0612,
		0x0613,
		0x0614,
		0x0615,
		0x064B,
		0x064C,
		0x064D,
		0x064E,
		0x064F,
		0x0650,
		0x0651,
		0x0652,
		0x0653,
		0x0654,
		0x0655,
		0x0656,
		0x0657,
		0x0658,
		0x0670,
		0x06D6,
		0x06D7,
		0x06D8,
		0x06D9,
		0x06DA,
		0x06DB,
		0x06DC,
		0x06DF,
		0x06E0,
		0x06E1,
		0x06E2,
		0x06E3,
		0x06E4,
		0x06E7,
		0x06E8,
		0x06EA,
		0x06EB,
		0x06EC,
		0x06ED,];}
	]);
	return ArabicReshaper;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.DrawTexturesCmdNative
var DrawTexturesCmdNative=(function(){
	function DrawTexturesCmdNative(){
		this._graphicsCmdEncoder=null;
		this._index=0;
		this._paramData=null;
		this._texture=null;
		this._pos=null;
		this._rectNum=0;
		this._vbSize=0;
		this.vbBuffer=null;
	}

	__class(DrawTexturesCmdNative,'laya.layagl.cmdNative.DrawTexturesCmdNative');
	var __proto=DrawTexturesCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._texture=null;
		this._pos=null;
		Pool.recover("DrawTexturesCmd",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "DrawTextures";
	});

	__getset(0,__proto,'texture',function(){
		return this._texture;
		},function(value){
		this._texture=value;
		var w=this._texture.bitmap.width;
		var h=this._texture.bitmap.height;
		var uv=this._texture.uv;
		var _vb=this.vbBuffer._float32Data;
		var _vb_i32b=this.vbBuffer._int32Data;
		var ix=0;
		for (var i=0;i < this._rectNum;i++){
			var x=this.pos[i *2];
			var y=this.pos[i *2+1];
			_vb[ix++]=x;
			_vb[ix++]=y;
			_vb[ix++]=uv[0];
			_vb[ix++]=uv[1];
			_vb_i32b[ix++]=0xffffffff;
			_vb_i32b[ix++]=0xffffffff;
			_vb[ix++]=x+w;
			_vb[ix++]=y;
			_vb[ix++]=uv[2];
			_vb[ix++]=uv[3];
			_vb_i32b[ix++]=0xffffffff;
			_vb_i32b[ix++]=0xffffffff;
			_vb[ix++]=x+w;
			_vb[ix++]=y+h;
			_vb[ix++]=uv[4];
			_vb[ix++]=uv[5];
			_vb_i32b[ix++]=0xffffffff;
			_vb_i32b[ix++]=0xffffffff;
			_vb[ix++]=x;
			_vb[ix++]=y+h;
			_vb[ix++]=uv[6];
			_vb[ix++]=uv[7];
			_vb_i32b[ix++]=0xffffffff;
			_vb_i32b[ix++]=0xffffffff;
		};
		var _i32b=this._paramData._int32Data;
		_i32b[DrawTexturesCmdNative._PARAM_TEXLOCATION_POS_]=/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0;
		_i32b[DrawTexturesCmdNative._PARAM_TEXTURE_POS_]=this._texture.bitmap._glTexture.id;
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'pos',function(){
		return this._pos;
		},function(value){
		this._pos=value;
		var nRectNum=this._pos.length / 2;
		var w=this._texture.bitmap.width;
		var h=this._texture.bitmap.height;
		var uv=this._texture.uv;
		if (!this.vbBuffer || this.vbBuffer.getByteLength()< nRectNum *24*4){
			this.vbBuffer=/*__JS__ */new ParamData(nRectNum*24*4,true);
		}
		this._vbSize=nRectNum *24 *4;
		this._rectNum=nRectNum;
		var _vb=this.vbBuffer._float32Data;
		var _vb_i32b=this.vbBuffer._int32Data;
		var ix=0;
		for (var i=0;i < nRectNum;i++){
			var x=this.pos[i *2];
			var y=this.pos[i *2+1];
			_vb[ix++]=x;_vb[ix++]=y;_vb[ix++]=uv[0];_vb[ix++]=uv[1];_vb_i32b[ix++]=0xffffffff;_vb_i32b[ix++]=0xffffffff;
			_vb[ix++]=x+w;_vb[ix++]=y;_vb[ix++]=uv[2];_vb[ix++]=uv[3];_vb_i32b[ix++]=0xffffffff;_vb_i32b[ix++]=0xffffffff;
			_vb[ix++]=x+w;_vb[ix++]=y+h;_vb[ix++]=uv[4];_vb[ix++]=uv[5];_vb_i32b[ix++]=0xffffffff;_vb_i32b[ix++]=0xffffffff;
			_vb[ix++]=x;_vb[ix++]=y+h;_vb[ix++]=uv[6];_vb[ix++]=uv[7];_vb_i32b[ix++]=0xffffffff;_vb_i32b[ix++]=0xffffffff;
		};
		var _fb=this._paramData._float32Data;
		var _i32b=this._paramData._int32Data;
		_i32b[DrawTexturesCmdNative._PARAM_RECT_NUM_POS_]=this._rectNum;
		_i32b[DrawTexturesCmdNative._PARAM_VB_POS_]=this.vbBuffer.getPtrID();
		_i32b[DrawTexturesCmdNative._PARAM_VB_SIZE_POS_]=this._vbSize;
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	DrawTexturesCmdNative.create=function(texture,pos){
		var cmd=Pool.getItemByClass("DrawTexturesCmd",DrawTexturesCmdNative);
		cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		if (!DrawTexturesCmdNative._DRAW_TEXTURES_CMD_ENCODER_){
			DrawTexturesCmdNative._DRAW_TEXTURES_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(124,32,true);
			DrawTexturesCmdNative._DRAW_TEXTURES_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawTexturesCmdNative._DRAW_TEXTURES_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);
			DrawTexturesCmdNative._DRAW_TEXTURES_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);
			DrawTexturesCmdNative._DRAW_TEXTURES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawTexturesCmdNative._DRAW_TEXTURES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawTexturesCmdNative._DRAW_TEXTURES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawTexturesCmdNative._DRAW_TEXTURES_CMD_ENCODER_.uniformTextureByParamData(DrawTexturesCmdNative._PARAM_UNIFORMLOCATION_POS_,DrawTexturesCmdNative._PARAM_TEXLOCATION_POS_*4,DrawTexturesCmdNative._PARAM_TEXTURE_POS_*4);
			DrawTexturesCmdNative._DRAW_TEXTURES_CMD_ENCODER_.setRectMeshExByParamData(DrawTexturesCmdNative._PARAM_RECT_NUM_POS_*4,DrawTexturesCmdNative._PARAM_VB_POS_ *4,DrawTexturesCmdNative._PARAM_VB_SIZE_POS_ *4,DrawTexturesCmdNative._PARAM_VB_OFFSET_POS_ *4);
			DrawTexturesCmdNative._DRAW_TEXTURES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawTexturesCmdNative._DRAW_TEXTURES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawTexturesCmdNative._DRAW_TEXTURES_CMD_ENCODER_);
		}
		if (!cmd._paramData){
			cmd._paramData=/*__JS__ */new ParamData(7*4,true);
			}{
			cmd._texture=texture;
			cmd._pos=pos;
			var w=texture.bitmap.width;
			var h=texture.bitmap.height;
			var uv=texture.uv;
			var nRectNum=pos.length / 2;
			if (!cmd.vbBuffer || cmd.vbBuffer.getByteLength()< nRectNum *24*4){
				cmd.vbBuffer=/*__JS__ */new ParamData(nRectNum*24*4,true);
			}
			cmd._vbSize=nRectNum *24 *4;
			cmd._rectNum=nRectNum;
			var _vb=cmd.vbBuffer._float32Data;
			var _vb_i32b=cmd.vbBuffer._int32Data;
			var ix=0;
			for (var i=0;i < nRectNum;i++){
				var x=pos[i *2];
				var y=pos[i *2+1];
				_vb[ix++]=x;_vb[ix++]=y;_vb[ix++]=uv[0];_vb[ix++]=uv[1];_vb_i32b[ix++]=0xffffffff;_vb_i32b[ix++]=0xffffffff;
				_vb[ix++]=x+w;_vb[ix++]=y;_vb[ix++]=uv[2];_vb[ix++]=uv[3];_vb_i32b[ix++]=0xffffffff;_vb_i32b[ix++]=0xffffffff;
				_vb[ix++]=x+w;_vb[ix++]=y+h;_vb[ix++]=uv[4];_vb[ix++]=uv[5];_vb_i32b[ix++]=0xffffffff;_vb_i32b[ix++]=0xffffffff;
				_vb[ix++]=x;_vb[ix++]=y+h;_vb[ix++]=uv[6];_vb[ix++]=uv[7];_vb_i32b[ix++]=0xffffffff;_vb_i32b[ix++]=0xffffffff;
			};
			var _fb=cmd._paramData._float32Data;
			var _i32b=cmd._paramData._int32Data;
			_i32b[DrawTexturesCmdNative._PARAM_UNIFORMLOCATION_POS_]=3;
			_i32b[DrawTexturesCmdNative._PARAM_TEXLOCATION_POS_]=/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0;
			_i32b[DrawTexturesCmdNative._PARAM_TEXTURE_POS_]=texture.bitmap._glTexture.id;
			_i32b[DrawTexturesCmdNative._PARAM_RECT_NUM_POS_]=cmd._rectNum;
			_i32b[DrawTexturesCmdNative._PARAM_VB_POS_]=cmd.vbBuffer.getPtrID();
			_i32b[DrawTexturesCmdNative._PARAM_VB_SIZE_POS_]=cmd._vbSize;
			_i32b[DrawTexturesCmdNative._PARAM_VB_OFFSET_POS_]=0;
			LayaGL.syncBufferToRenderThread(cmd.vbBuffer);
			LayaGL.syncBufferToRenderThread(cmd._paramData);
		}
		cmd._graphicsCmdEncoder.useCommandEncoder(DrawTexturesCmdNative._DRAW_TEXTURES_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		LayaGL.syncBufferToRenderThread(cmd._graphicsCmdEncoder);
		return cmd;
	}

	DrawTexturesCmdNative.ID="DrawTextures";
	DrawTexturesCmdNative._DRAW_TEXTURES_CMD_ENCODER_=null;
	DrawTexturesCmdNative._PARAM_UNIFORMLOCATION_POS_=0;
	DrawTexturesCmdNative._PARAM_TEXLOCATION_POS_=1;
	DrawTexturesCmdNative._PARAM_TEXTURE_POS_=2;
	DrawTexturesCmdNative._PARAM_RECT_NUM_POS_=3;
	DrawTexturesCmdNative._PARAM_VB_POS_=4;
	DrawTexturesCmdNative._PARAM_VB_SIZE_POS_=5;
	DrawTexturesCmdNative._PARAM_VB_OFFSET_POS_=6;
	return DrawTexturesCmdNative;
})()


//class laya.webgl.canvas.save.SaveMark
var SaveMark=(function(){
	function SaveMark(){
		this._saveuse=0;
		//this._preSaveMark=null;
		;
	}

	__class(SaveMark,'laya.webgl.canvas.save.SaveMark');
	var __proto=SaveMark.prototype;
	Laya.imps(__proto,{"laya.webgl.canvas.save.ISaveData":true})
	__proto.isSaveMark=function(){
		return true;
	}

	__proto.restore=function(context){
		context._saveMark=this._preSaveMark;
		SaveMark.POOL[SaveMark.POOL._length++]=this;
	}

	SaveMark.Create=function(context){
		var no=SaveMark.POOL;
		var o=no._length > 0 ? no[--no._length] :(new SaveMark());
		o._saveuse=0;
		o._preSaveMark=context._saveMark;
		context._saveMark=o;
		return o;
	}

	SaveMark.POOL=SaveBase._createArray();
	return SaveMark;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.DrawTrianglesCmdNative
var DrawTrianglesCmdNative=(function(){
	function DrawTrianglesCmdNative(){
		this._graphicsCmdEncoder=null;
		this._paramData=null;
		this._texture=null;
		this._x=NaN;
		this._y=NaN;
		this._vertices=null;
		this._uvs=null;
		this._indices=null;
		this._matrix=null;
		this._alpha=NaN;
		this._color=null;
		this._blendMode=null;
		this.vbBuffer=null;
		this._vbSize=NaN;
		this.ibBuffer=null;
		this._ibSize=NaN;
		this._verticesNum=NaN;
		this._ibNum=NaN;
		this._blend_src=0;
		this._blend_dest=0;
	}

	__class(DrawTrianglesCmdNative,'laya.layagl.cmdNative.DrawTrianglesCmdNative');
	var __proto=DrawTrianglesCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._texture=null;
		this._vertices=null;
		this._uvs=null;
		this._indices=null;
		this._matrix=null;
		Pool.recover("DrawTrianglesCmd",this);
	}

	__proto._setBlendMode=function(value){
		switch(value){
			case /*laya.webgl.canvas.BlendMode.NORMAL*/"normal":
				this._blend_src=/*laya.webgl.WebGLContext.ONE*/1;
				this._blend_dest=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
				break ;
			case /*laya.webgl.canvas.BlendMode.ADD*/"add":
				this._blend_src=/*laya.webgl.WebGLContext.ONE*/1;
				this._blend_dest=/*laya.webgl.WebGLContext.DST_ALPHA*/0x0304;
				break ;
			case /*laya.webgl.canvas.BlendMode.MULTIPLY*/"multiply":
				this._blend_src=/*laya.webgl.WebGLContext.DST_COLOR*/0x0306;
				this._blend_dest=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
				break ;
			case /*laya.webgl.canvas.BlendMode.SCREEN*/"screen":
				this._blend_src=/*laya.webgl.WebGLContext.ONE*/1;
				this._blend_dest=/*laya.webgl.WebGLContext.ONE*/1;
				break ;
			case /*laya.webgl.canvas.BlendMode.LIGHT*/"light":
				this._blend_src=/*laya.webgl.WebGLContext.ONE*/1;
				this._blend_dest=/*laya.webgl.WebGLContext.ONE*/1;
				break ;
			case /*laya.webgl.canvas.BlendMode.OVERLAY*/"overlay":
				this._blend_src=/*laya.webgl.WebGLContext.ONE*/1;
				this._blend_dest=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_COLOR*/0x0301;
				break ;
			case /*laya.webgl.canvas.BlendMode.DESTINATIONOUT*/"destination-out":
				this._blend_src=/*laya.webgl.WebGLContext.ZERO*/0;
				this._blend_dest=/*laya.webgl.WebGLContext.ZERO*/0;
				break ;
			case /*laya.webgl.canvas.BlendMode.MASK*/"mask":
				this._blend_src=/*laya.webgl.WebGLContext.ZERO*/0;
				this._blend_dest=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
				break ;
			default :
				alert("_setBlendMode Unknown type");
				break ;
			}
	}

	__proto._mixRGBandAlpha=function(color,alpha){
		var a=((color & 0xff000000)>>> 24);
		if (a !=0){
			a*=alpha;
			}else {
			a=alpha*255;
		}
		return (color & 0x00ffffff)| (a << 24);
	}

	__getset(0,__proto,'vertices',function(){
		return this._vertices;
		},function(value){
		this._vertices=value;
		var _vb=this.vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._verticesNum;i++){
			_vb[ix++]=this._x+value[i *2];_vb[ix++]=this._y+value[i *2+1];ix++;ix++;ix++;ix++;
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawTriangles";
	});

	__getset(0,__proto,'matrix',function(){
		return this._matrix;
		},function(value){
		this._matrix=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawTrianglesCmdNative._PARAM_MATRIX_POS_]=value.a;
		_fb[DrawTrianglesCmdNative._PARAM_MATRIX_POS_+1]=value.b;
		_fb[DrawTrianglesCmdNative._PARAM_MATRIX_POS_+2]=value.c;
		_fb[DrawTrianglesCmdNative._PARAM_MATRIX_POS_+3]=value.d;
		_fb[DrawTrianglesCmdNative._PARAM_MATRIX_POS_+4]=value.tx;
		_fb[DrawTrianglesCmdNative._PARAM_MATRIX_POS_+5]=value.ty;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'texture',function(){
		return this._texture;
		},function(value){
		if (!value||!value.url){
			return;
		}
		this._texture=value;
		var _i32b=this._paramData._int32Data;
		_i32b[DrawTrianglesCmdNative._PARAM_TEXTURE_POS_]=this._texture.bitmap._glTexture.id;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
		var _vb=this.vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._verticesNum;i++){
			ix++;_vb[ix++]=value+this.vertices[i *2+1];ix++;ix++;ix++;ix++;
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
		var _vb=this.vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._verticesNum;i++){
			_vb[ix++]=value+this.vertices[i *2];ix++;ix++;ix++;ix++;ix++;
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'alpha',function(){
		return this._alpha;
		},function(value){
		this._alpha=value;
	});

	__getset(0,__proto,'uvs',function(){
		return this._uvs;
		},function(value){
		this._uvs=value;
		var _vb=this.vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._verticesNum;i++){
			ix++;ix++;_vb[ix++]=value[i *2];_vb[ix++]=value[i *2+1];ix++;ix++;
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'indices',function(){
		return this._indices;
		},function(value){
		this._indices=value;
		var _ib=this.ibBuffer._int16Data;
		var idxpos=0;
		for (var ii=0;ii < this._ibNum;ii++){
			_ib[idxpos++]=value[ii];
		}
		LayaGL.syncBufferToRenderThread(this.ibBuffer);
	});

	__getset(0,__proto,'color',function(){
		return this._color;
		},function(value){
		this._color=value;
	});

	__getset(0,__proto,'blendMode',function(){
		return this._blendMode;
		},function(value){
		this._blendMode=value;
	});

	DrawTrianglesCmdNative.create=function(texture,x,y,vertices,uvs,indices,matrix,alpha,color,blendMode){
		var cmd=Pool.getItemByClass("DrawTrianglesCmd",DrawTrianglesCmdNative);
		cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		if (!DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_){
			DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(152,32,true);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_.save();
			DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_.blendFuncByParamData(DrawTrianglesCmdNative._PARAM_BLEND_SRC_POS_ *4,DrawTrianglesCmdNative._PARAM_BLEND_DEST_POS_ *4);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_.setGlobalValueByParamData(LayaNative2D.GLOBALVALUE_MATRIX32,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7,DrawTrianglesCmdNative._PARAM_MATRIX_POS_ *4);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_.uniformTextureByParamData(DrawTrianglesCmdNative._PARAM_UNIFORMLOCATION_POS_ *4,DrawTrianglesCmdNative._PARAM_TEXLOCATION_POS_ *4,DrawTrianglesCmdNative._PARAM_TEXTURE_POS_ *4);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_.setMeshExByParamData(DrawTrianglesCmdNative._PARAM_VB_POS_ *4,DrawTrianglesCmdNative._PARAM_VB_OFFSET_POS_*4,DrawTrianglesCmdNative._PARAM_VB_SIZE_POS_ *4,DrawTrianglesCmdNative._PARAM_IB_POS_ *4,DrawTrianglesCmdNative._PARAM_IB_OFFSET_POS_*4,DrawTrianglesCmdNative._PARAM_IB_SIZE_POS_ *4,DrawTrianglesCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_.restore();
			LayaGL.syncBufferToRenderThread(DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_);
		}
		if (!DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_){
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(152,32,true);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.save();
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.blendFuncByParamData(DrawTrianglesCmdNative._PARAM_BLEND_SRC_POS_ *4,DrawTrianglesCmdNative._PARAM_BLEND_DEST_POS_ *4);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.addShaderMacro(LayaNative2D.SHADER_MACRO_COLOR_FILTER);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.setGlobalValueByParamData(LayaNative2D.GLOBALVALUE_COLORFILTER_COLOR,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,DrawTrianglesCmdNative._PARAM_FILTER_COLOR_POS_ *4);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.setGlobalValueByParamData(LayaNative2D.GLOBALVALUE_COLORFILTER_ALPHA,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,DrawTrianglesCmdNative._PARAM_FILTER_ALPHA_POS_ *4);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.setGlobalValueByParamData(LayaNative2D.GLOBALVALUE_MATRIX32,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7,DrawTrianglesCmdNative._PARAM_MATRIX_POS_ *4);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.uniformTextureByParamData(DrawTrianglesCmdNative._PARAM_UNIFORMLOCATION_POS_ *4,DrawTrianglesCmdNative._PARAM_TEXLOCATION_POS_ *4,DrawTrianglesCmdNative._PARAM_TEXTURE_POS_ *4);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.setMeshExByParamData(DrawTrianglesCmdNative._PARAM_VB_POS_ *4,DrawTrianglesCmdNative._PARAM_VB_OFFSET_POS_*4,DrawTrianglesCmdNative._PARAM_VB_SIZE_POS_ *4,DrawTrianglesCmdNative._PARAM_IB_POS_ *4,DrawTrianglesCmdNative._PARAM_IB_OFFSET_POS_*4,DrawTrianglesCmdNative._PARAM_IB_SIZE_POS_ *4,DrawTrianglesCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.restore();
			LayaGL.syncBufferToRenderThread(DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_);
		}
		if (!cmd._paramData){
			cmd._paramData=/*__JS__ */new ParamData(38*4,true);
			}{
			cmd._texture=texture;
			cmd._x=x;
			cmd._y=y;
			cmd._vertices=vertices;
			cmd._uvs=uvs;
			cmd._indices=indices;
			if (matrix){
				cmd._matrix=matrix;
				}else {
				cmd._matrix=new Matrix();
			}
			cmd._alpha=alpha;
			cmd._color=color;
			cmd._blendMode=blendMode;
			var colorFilter=new ColorFilter();
			var rgba=ColorUtils.create(color);
			colorFilter.color(rgba.arrColor[0],rgba.arrColor[1],rgba.arrColor[2],rgba.arrColor[3]);
			cmd._verticesNum=cmd._vertices.length / 2;
			var verticesNumCopy=cmd._verticesNum;
			if (!cmd.vbBuffer || cmd.vbBuffer.getByteLength()< verticesNumCopy *24 *3){
				cmd.vbBuffer=/*__JS__ */new ParamData(verticesNumCopy*24*3,true);
			}
			cmd._vbSize=verticesNumCopy *24 *3;
			var _vb=cmd.vbBuffer._float32Data;
			var _vb_i32b=cmd.vbBuffer._int32Data;
			var nrgba=0xffffffff;
			if(alpha){
				nrgba=cmd._mixRGBandAlpha(nrgba,alpha);
			};
			var ix=0;
			for (var i=0;i < cmd._verticesNum;i++){
				_vb[ix++]=x/cmd._matrix.a+vertices[i *2];_vb[ix++]=y/cmd._matrix.d+vertices[i *2+1];_vb[ix++]=uvs[i *2];_vb[ix++]=uvs[i *2+1];_vb_i32b[ix++]=nrgba;_vb_i32b[ix++]=0xffffffff;
			}
			cmd._ibNum=indices.length;
			var ibNumCopy=cmd._ibNum;
			if (!cmd.ibBuffer || cmd.ibBuffer.getByteLength()< ibNumCopy *2){
				cmd.ibBuffer=/*__JS__ */new ParamData(ibNumCopy*2,true,true);
			}
			cmd._ibSize=ibNumCopy*2;
			var _ib=cmd.ibBuffer._int16Data;
			var idxpos=0;
			for (var ii=0;ii < cmd._ibNum;ii++){
				_ib[idxpos++]=indices[ii];
			}
		};
		var _fb=cmd._paramData._float32Data;
		var _i32b=cmd._paramData._int32Data;
		_i32b[DrawTrianglesCmdNative._PARAM_UNIFORMLOCATION_POS_]=3;
		_i32b[DrawTrianglesCmdNative._PARAM_TEXLOCATION_POS_]=/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0;
		_i32b[DrawTrianglesCmdNative._PARAM_TEXTURE_POS_]=texture.bitmap._glTexture.id;
		_i32b[DrawTrianglesCmdNative._PARAM_VB_POS_]=cmd.vbBuffer.getPtrID();
		_i32b[DrawTrianglesCmdNative._PARAM_VB_SIZE_POS_]=cmd._vbSize;
		_i32b[DrawTrianglesCmdNative._PARAM_IB_POS_]=cmd.ibBuffer.getPtrID();
		_i32b[DrawTrianglesCmdNative._PARAM_IB_SIZE_POS_]=cmd._ibSize;
		_i32b[DrawTrianglesCmdNative._PARAM_VB_OFFSET_POS_]=0;
		_i32b[DrawTrianglesCmdNative._PARAM_IB_OFFSET_POS_]=0;
		_i32b[DrawTrianglesCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_]=0;
		_fb[DrawTrianglesCmdNative._PARAM_MATRIX_POS_]=cmd._matrix.a;_fb[DrawTrianglesCmdNative._PARAM_MATRIX_POS_+1]=cmd._matrix.b;_fb[DrawTrianglesCmdNative._PARAM_MATRIX_POS_+2]=cmd._matrix.c;
		_fb[DrawTrianglesCmdNative._PARAM_MATRIX_POS_+3]=cmd._matrix.d;_fb[DrawTrianglesCmdNative._PARAM_MATRIX_POS_+4]=cmd._matrix.tx;_fb[DrawTrianglesCmdNative._PARAM_MATRIX_POS_+5]=cmd._matrix.ty;
		if (blendMode){
			cmd._setBlendMode(blendMode);
			_i32b[DrawTrianglesCmdNative._PARAM_BLEND_SRC_POS_]=cmd._blend_src;
			_i32b[DrawTrianglesCmdNative._PARAM_BLEND_DEST_POS_]=cmd._blend_dest;
			}else {
			_i32b[DrawTrianglesCmdNative._PARAM_BLEND_SRC_POS_]=-1;
			_i32b[DrawTrianglesCmdNative._PARAM_BLEND_DEST_POS_]=-1;
		}
		if (color){
			ix=DrawTrianglesCmdNative._PARAM_FILTER_COLOR_POS_;
			var mat=colorFilter._mat;
			_fb[ix++]=mat[0];_fb[ix++]=mat[1];_fb[ix++]=mat[2];_fb[ix++]=mat[3];
			_fb[ix++]=mat[4];_fb[ix++]=mat[5];_fb[ix++]=mat[6];_fb[ix++]=mat[7];
			_fb[ix++]=mat[8];_fb[ix++]=mat[9];_fb[ix++]=mat[10];_fb[ix++]=mat[11];
			_fb[ix++]=mat[12];_fb[ix++]=mat[13];_fb[ix++]=mat[14];_fb[ix++]=mat[15];
			ix=DrawTrianglesCmdNative._PARAM_FILTER_ALPHA_POS_;
			var _alpha=colorFilter._alpha;
			_fb[ix++]=_alpha[0] *255;_fb[ix++]=_alpha[1] *255;_fb[ix++]=_alpha[2] *255;_fb[ix++]=_alpha[3] *255;
		}
		LayaGL.syncBufferToRenderThread(cmd.vbBuffer);
		LayaGL.syncBufferToRenderThread(cmd.ibBuffer);
		LayaGL.syncBufferToRenderThread(cmd._paramData);
		if (color){
			cmd._graphicsCmdEncoder.useCommandEncoder(DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		}
		else{
			cmd._graphicsCmdEncoder.useCommandEncoder(DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		}
		LayaGL.syncBufferToRenderThread(cmd._graphicsCmdEncoder);
		return cmd;
	}

	DrawTrianglesCmdNative.ID="DrawTriangles";
	DrawTrianglesCmdNative._DRAW_TRIANGLES_CMD_ENCODER_=null;
	DrawTrianglesCmdNative._DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_=null;
	DrawTrianglesCmdNative._PARAM_UNIFORMLOCATION_POS_=0;
	DrawTrianglesCmdNative._PARAM_TEXLOCATION_POS_=1;
	DrawTrianglesCmdNative._PARAM_TEXTURE_POS_=2;
	DrawTrianglesCmdNative._PARAM_VB_POS_=3;
	DrawTrianglesCmdNative._PARAM_VB_SIZE_POS_=4;
	DrawTrianglesCmdNative._PARAM_IB_POS_=5;
	DrawTrianglesCmdNative._PARAM_IB_SIZE_POS_=6;
	DrawTrianglesCmdNative._PARAM_VB_OFFSET_POS_=7;
	DrawTrianglesCmdNative._PARAM_IB_OFFSET_POS_=8;
	DrawTrianglesCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_=9;
	DrawTrianglesCmdNative._PARAM_BLEND_SRC_POS_=10;
	DrawTrianglesCmdNative._PARAM_BLEND_DEST_POS_=11;
	DrawTrianglesCmdNative._PARAM_MATRIX_POS_=12;
	DrawTrianglesCmdNative._PARAM_FILTER_COLOR_POS_=18;
	DrawTrianglesCmdNative._PARAM_FILTER_ALPHA_POS_=34;
	return DrawTrianglesCmdNative;
})()


//class laya.webgl.shader.ShaderDefinesBase
var ShaderDefinesBase=(function(){
	function ShaderDefinesBase(name2int,int2name,int2nameMap){
		this._value=0;
		//this._name2int=null;
		//this._int2name=null;
		//this._int2nameMap=null;
		this._name2int=name2int;
		this._int2name=int2name;
		this._int2nameMap=int2nameMap;
	}

	__class(ShaderDefinesBase,'laya.webgl.shader.ShaderDefinesBase');
	var __proto=ShaderDefinesBase.prototype;
	//TODO:coverage
	__proto.add=function(value){
		if ((typeof value=='string'))value=this._name2int[value];
		this._value |=value;
		return this._value;
	}

	__proto.addInt=function(value){
		this._value |=value;
		return this._value;
	}

	//TODO:coverage
	__proto.remove=function(value){
		if ((typeof value=='string'))value=this._name2int[value];
		this._value &=(~value);
		return this._value;
	}

	//TODO:coverage
	__proto.isDefine=function(def){
		return (this._value & def)===def;
	}

	//TODO:coverage
	__proto.getValue=function(){
		return this._value;
	}

	__proto.setValue=function(value){
		this._value=value;
	}

	__proto.toNameDic=function(){
		var r=this._int2nameMap[this._value];
		return r ? r :ShaderDefinesBase._toText(this._value,this._int2name,this._int2nameMap);
	}

	ShaderDefinesBase._reg=function(name,value,_name2int,_int2name){
		_name2int[name]=value;
		_int2name[value]=name;
	}

	ShaderDefinesBase._toText=function(value,_int2name,_int2nameMap){
		var r=_int2nameMap[value];
		if (r)return r;
		var o={};
		var d=1;
		for (var i=0;i < 32;i++){
			d=1 << i;
			if (d > value)break ;
			if (value & d){
				var name=_int2name[d];
				name && (o[name]="");
			}
		}
		_int2nameMap[value]=o;
		return o;
	}

	ShaderDefinesBase._toInt=function(names,_name2int){
		var words=names.split('.');
		var num=0;
		for (var i=0,n=words.length;i < n;i++){
			var value=_name2int[words[i]];
			if (!value)throw new Error("Defines to int err:"+names+"/"+words[i]);
			num |=value;
		}
		return num;
	}

	return ShaderDefinesBase;
})()


//class laya.webgl.utils.ShaderNode
var ShaderNode=(function(){
	function ShaderNode(includefiles){
		this.childs=[];
		this.text="";
		this.parent=null;
		this.name=null;
		this.noCompile=false;
		this.includefiles=null;
		this.condition=null;
		this.conditionType=0;
		this.useFuns="";
		this.z=0;
		this.src=null;
		this.includefiles=includefiles;
	}

	__class(ShaderNode,'laya.webgl.utils.ShaderNode');
	var __proto=ShaderNode.prototype;
	__proto.setParent=function(parent){
		parent.childs.push(this);
		this.z=parent.z+1;
		this.parent=parent;
	}

	__proto.setCondition=function(condition,type){
		if (condition){
			this.conditionType=type;
			condition=condition.replace(/(\s*$)/g,"");
			this.condition=function (){
				return this[condition];
			}
			this.condition.__condition=condition;
		}
	}

	__proto.toscript=function(def,out){
		return this._toscript(def,out,++ShaderNode.__id);
	}

	__proto._toscript=function(def,out,id){
		if (this.childs.length < 1 && !this.text)return out;
		var outIndex=out.length;
		if (this.condition){
			var ifdef=!!this.condition.call(def);
			this.conditionType===/*laya.webgl.utils.ShaderCompile.IFDEF_ELSE*/2 && (ifdef=!ifdef);
			if (!ifdef)return out;
		}
		this.text && out.push(this.text);
		this.childs.length > 0 && this.childs.forEach(function(o,index,arr){
			o._toscript(def,out,id);
		});
		if (this.includefiles.length > 0 && this.useFuns.length > 0){
			var funsCode;
			for (var i=0,n=this.includefiles.length;i < n;i++){
				if (this.includefiles[i].curUseID==id){
					continue ;
				}
				funsCode=this.includefiles[i].file.getFunsScript(this.useFuns);
				if (funsCode.length > 0){
					this.includefiles[i].curUseID=id;
					out[0]=funsCode+out[0];
				}
			}
		}
		return out;
	}

	ShaderNode.__id=1;
	return ShaderNode;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.DrawPolyCmdNative
var DrawPolyCmdNative=(function(){
	function DrawPolyCmdNative(){
		this._graphicsCmdEncoder=null;
		this._graphicsCmdEncoder_lines=null;
		this._paramData=null;
		this._x=NaN;
		this._y=NaN;
		this._points=null;
		this._fillColor=null;
		this._lineColor=null;
		this._lineWidth=NaN;
		this._isConvexPolygon=false;
		this._vid=0;
		this._vertNum=0;
		this._line_vertNum=0;
		this.ibBuffer=null;
		this.vbBuffer=null;
		this.line_ibBuffer=null;
		this.line_vbBuffer=null;
		this._ibSize=0;
		this._vbSize=0;
		this._line_ibSize=0;
		this._line_vbSize=0;
		this._cmdCurrentPos=0;
		this._linePoints=[];
		this._line_vbArray=[];
		this._line_ibArray=[];
	}

	__class(DrawPolyCmdNative,'laya.layagl.cmdNative.DrawPolyCmdNative');
	var __proto=DrawPolyCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._points=null;
		this._fillColor=null;
		this._lineColor=null;
		this._linePoints.length=0;
		this._line_vbArray.length=0;
		this._line_ibArray.length=0;
		Pool.recover("DrawPolyCmd",this);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._lineColor;
		},function(value){
		this._graphicsCmdEncoder._idata[this._cmdCurrentPos+1]=DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_.getPtrID();
		LayaGL.syncBufferToRenderThread(this._graphicsCmdEncoder);
		this._lineColor=value;
		if (this._lineColor && this.line_vbBuffer){
			var c2=ColorUtils.create(this._lineColor);
			var nColor2=c2.numColor;
			var _line_vb_i32b=this.line_vbBuffer._int32Data;
			var ix=0;
			for (var i=0;i < this._line_vertNum;i++){
				ix++;ix++;_line_vb_i32b[ix++]=nColor2;
			}
			LayaGL.syncBufferToRenderThread(this.line_vbBuffer);
		}
	});

	__getset(0,__proto,'points',function(){
		return this._points;
		},function(value){
		this._points=value;{
			this._vertNum=value.length / 2;
			var vertNumCopy=this._vertNum;
			var cur=Earcut.earcut(value,null,2);
			if (cur.length > 0){
				if (!this.ibBuffer || this.ibBuffer.getByteLength()< cur.length*2){
					this.ibBuffer=/*__JS__ */new ParamData(cur.length*2,true,true);
				}
				this._ibSize=cur.length *2;
				var _ib=this.ibBuffer._int16Data;
				var idxpos=0;
				for (var ii=0;ii < cur.length;ii++){
					_ib[idxpos++]=cur[ii];
				}
			}
			if (!this.vbBuffer || this.vbBuffer.getByteLength()< this._vertNum *3 *4){
				this.vbBuffer=/*__JS__ */new ParamData(vertNumCopy*3 *4,true);
			}
			this._vbSize=this._vertNum *3 *4;
			var c1=ColorUtils.create(this._fillColor);
			var nColor=c1.numColor;
			var _vb=this.vbBuffer._float32Data;
			var _vb_i32b=this.vbBuffer._int32Data;
			var ix=0;
			for (var i=0;i < this._vertNum;i++){
				_vb[ix++]=this._points[i *2]+this._x;_vb[ix++]=this._points[i *2+1]+this._y;_vb_i32b[ix++]=nColor;
			}
		};
		var _i32b=this._paramData._int32Data;
		_i32b[DrawPolyCmdNative._PARAM_VB_POS_]=this.vbBuffer.getPtrID();
		_i32b[DrawPolyCmdNative._PARAM_IB_POS_]=this.ibBuffer.getPtrID();
		_i32b[DrawPolyCmdNative._PARAM_VB_SIZE_POS_]=this._vbSize;
		_i32b[DrawPolyCmdNative._PARAM_IB_SIZE_POS_]=this._ibSize;
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
		LayaGL.syncBufferToRenderThread(this.ibBuffer);
		LayaGL.syncBufferToRenderThread(this._paramData);
		if (this.lineColor){
			{
				var lineVertNumCopy=0;
				this._linePoints.length=0;
				this._line_ibArray.length=0;
				this._line_vbArray.length=0;
				for (i=0;i < value.length;i++){
					this._linePoints.push(value[i]);
				}
				this._linePoints.push(value[0]);
				this._linePoints.push(value[1]);
				BasePoly.createLine2(this._linePoints,this._line_ibArray,this._lineWidth,0,this._line_vbArray,false);
				this._line_vertNum=this._linePoints.length;
				lineVertNumCopy=this._line_vertNum;
				if (!this.line_ibBuffer || this.line_ibBuffer.getByteLength()< (this._line_vertNum-2)*3*2){
					this.line_ibBuffer=/*__JS__ */new ParamData((lineVertNumCopy-2)*3*2,true,true);
				}
				this._line_ibSize=(this._line_vertNum-2)*3 *2;
				var _line_ib=this.line_ibBuffer._int16Data;
				idxpos=0;
				for (ii=0;ii < (this._line_vertNum-2)*3;ii++){
					_line_ib[idxpos++]=this._line_ibArray[ii];
				}
				if (!this.line_vbBuffer || this.line_vbBuffer.getByteLength()< this._line_vertNum*3 *4){
					this.line_vbBuffer=/*__JS__ */new ParamData(lineVertNumCopy*3 *4,true);
				}
				this._line_vbSize=this._line_vertNum *3 *4;
				var c2=ColorUtils.create(this._lineColor);
				var nColor2=c2.numColor;
				var _line_vb=this.line_vbBuffer._float32Data;
				var _line_vb_i32b=this.line_vbBuffer._int32Data;
				ix=0;
				for (i=0;i < this._line_vertNum;i++){
					_line_vb[ix++]=this._line_vbArray[i *2]+this._x;
					_line_vb[ix++]=this._line_vbArray[i *2+1]+this._y;
					_line_vb_i32b[ix++]=nColor2;
				}
			}
			_i32b=this._paramData._int32Data;
			_i32b[DrawPolyCmdNative._PARAM_LINE_VB_POS_]=this.line_vbBuffer.getPtrID();
			_i32b[DrawPolyCmdNative._PARAM_LINE_IB_POS_]=this.line_ibBuffer.getPtrID();
			_i32b[DrawPolyCmdNative._PARAM_LINE_VB_SIZE_POS_]=this._line_vbSize;
			_i32b[DrawPolyCmdNative._PARAM_LINE_IB_SIZE_POS_]=this._line_ibSize;
			LayaGL.syncBufferToRenderThread(this.line_vbBuffer);
			LayaGL.syncBufferToRenderThread(this.line_ibBuffer);
		}
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawPoly";
	});

	__getset(0,__proto,'fillColor',function(){
		return this._fillColor;
		},function(value){
		this._fillColor=value;
		var c1=ColorUtils.create(this._fillColor);
		var nColor=c1.numColor;
		var _i32b=this.vbBuffer._int32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			ix++;ix++;_i32b[ix++]=nColor;
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
		var _vb=this.vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			_vb[ix++]=this._points[i *2]+this._x;ix++;ix++;
		}
		if (this._lineColor){
			var _line_vb=this.line_vbBuffer._float32Data;
			ix=0;
			for (i=0;i < this._line_vertNum;i++){
				_line_vb[ix++]=this._line_vbArray[i *2]+this._x;ix++;ix++;
			}
			LayaGL.syncBufferToRenderThread(this.line_vbBuffer);
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'isConvexPolygon',function(){
		return this._isConvexPolygon;
		},function(value){
		this._isConvexPolygon=value;
	});

	__getset(0,__proto,'vid',function(){
		return this._vid;
		},function(value){
		this._vid=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
		var _vb=this.vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			ix++;_vb[ix++]=this._points[i *2+1]+this._y;ix++;
		}
		if (this._lineColor){
			var _line_vb=this.line_vbBuffer._float32Data;
			ix=0;
			for (i=0;i < this._line_vertNum;i++){
				ix++;_line_vb[ix++]=this._line_vbArray[i *2+1]+this._y;ix++;
			}
			LayaGL.syncBufferToRenderThread(this.line_vbBuffer);
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		if (this.lineColor){
			this._graphicsCmdEncoder._idata[this._cmdCurrentPos+1]=DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_.getPtrID();
			LayaGL.syncBufferToRenderThread(this._graphicsCmdEncoder);
		}
		this._lineWidth=value;
		this._linePoints.length=0;
		this._line_ibArray.length=0;
		this._line_vbArray.length=0;
		for (var i=0;i < this._points.length;i++){
			this._linePoints.push(this._points[i]);
		}
		this._linePoints.push(this._points[0]);
		this._linePoints.push(this._points[1]);
		BasePoly.createLine2(this._linePoints,this._line_ibArray,this._lineWidth,0,this._line_vbArray,false);
		var _line_vb=this.line_vbBuffer._float32Data;
		var ix=0;
		for (i=0;i < this._line_vertNum;i++){
			_line_vb[ix++]=this._line_vbArray[i *2]+this._x;
			_line_vb[ix++]=this._line_vbArray[i *2+1]+this._y;
			ix++;
		}
		LayaGL.syncBufferToRenderThread(this.line_vbBuffer);
	});

	DrawPolyCmdNative.create=function(x,y,points,fillColor,lineColor,lineWidth,isConvexPolygon,vid){
		var cmd=Pool.getItemByClass("DrawPolyCmd",DrawPolyCmdNative);
		cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		if (!DrawPolyCmdNative._DRAW_POLY_CMD_ENCODER_){
			DrawPolyCmdNative._DRAW_POLY_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(168,32,true);
			DrawPolyCmdNative._DRAW_POLY_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawPolyCmdNative._DRAW_POLY_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);
			DrawPolyCmdNative._DRAW_POLY_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);
			DrawPolyCmdNative._DRAW_POLY_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawPolyCmdNative._DRAW_POLY_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawPolyCmdNative._DRAW_POLY_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawPolyCmdNative._DRAW_POLY_CMD_ENCODER_.setMeshExByParamData(DrawPolyCmdNative._PARAM_VB_POS_ *4,DrawPolyCmdNative._PARAM_VB_OFFSET_POS_ *4,DrawPolyCmdNative._PARAM_VB_SIZE_POS_ *4,DrawPolyCmdNative._PARAM_IB_POS_ *4,DrawPolyCmdNative._PARAM_IB_OFFSET_POS_ *4,DrawPolyCmdNative._PARAM_IB_SIZE_POS_ *4,DrawPolyCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawPolyCmdNative._DRAW_POLY_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawPolyCmdNative._DRAW_POLY_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawPolyCmdNative._DRAW_POLY_CMD_ENCODER_);
		}
		if (!DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_){
			DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(244,32,true);
			DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);
			DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);
			DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_.setMeshExByParamData(DrawPolyCmdNative._PARAM_VB_POS_ *4,DrawPolyCmdNative._PARAM_VB_OFFSET_POS_ *4,DrawPolyCmdNative._PARAM_VB_SIZE_POS_ *4,DrawPolyCmdNative._PARAM_IB_POS_ *4,DrawPolyCmdNative._PARAM_IB_OFFSET_POS_ *4,DrawPolyCmdNative._PARAM_IB_SIZE_POS_ *4,DrawPolyCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_.setMeshExByParamData(DrawPolyCmdNative._PARAM_LINE_VB_POS_ *4,DrawPolyCmdNative._PARAM_LINE_VB_OFFSET_POS_ *4,DrawPolyCmdNative._PARAM_LINE_VB_SIZE_POS_ *4,DrawPolyCmdNative._PARAM_LINE_IB_POS_ *4,DrawPolyCmdNative._PARAM_LINE_VB_OFFSET_POS_ *4,DrawPolyCmdNative._PARAM_LINE_IB_SIZE_POS_ *4,DrawPolyCmdNative._PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_);
		}
		if (!cmd._paramData){
			cmd._paramData=/*__JS__ */new ParamData(17 *4,true);
			}{
			cmd._x=x;
			cmd._y=y;
			cmd._points=points;
			cmd._fillColor=fillColor;
			cmd._lineColor=lineColor;
			cmd._lineWidth=lineWidth;
			cmd._isConvexPolygon=isConvexPolygon;
			cmd._vertNum=points.length / 2;
			var vertNumCopy=cmd._vertNum;
			var cur=Earcut.earcut(points,null,2);
			if (cur.length > 0){
				if (!cmd.ibBuffer || cmd.ibBuffer.getByteLength()< cur.length*2){
					cmd.ibBuffer=/*__JS__ */new ParamData(cur.length*2,true,true);
				}
				cmd._ibSize=cur.length *2;
				var _ib=cmd.ibBuffer._int16Data;
				var idxpos=0;
				for (var ii=0;ii < cur.length;ii++){
					_ib[idxpos++]=cur[ii];
				}
			};
			var c1=ColorUtils.create(fillColor);
			var nColor=c1.numColor;
			if (!cmd.vbBuffer || cmd.vbBuffer.getByteLength()< cmd._vertNum *3 *4){
				cmd.vbBuffer=/*__JS__ */new ParamData(vertNumCopy *3 *4,true);
			}
			cmd._vbSize=cmd._vertNum *3 *4;
			var _vb=cmd.vbBuffer._float32Data;
			var _vb_i32b=cmd.vbBuffer._int32Data;
			var ix=0;
			for (var i=0;i < cmd._vertNum;i++){
				_vb[ix++]=points[i *2]+x;_vb[ix++]=points[i *2+1]+y;_vb_i32b[ix++]=nColor;
			}
			for (i=0;i < points.length;i++){
				cmd._linePoints.push(points[i]);
			}
			cmd._linePoints.push(points[0]);
			cmd._linePoints.push(points[1]);
			if (lineColor){
				BasePoly.createLine2(cmd._linePoints,cmd._line_ibArray,lineWidth,0,cmd._line_vbArray,false);
				cmd._line_vertNum=cmd._linePoints.length;
				var lineVertNumCopy=cmd._line_vertNum;
				if (!cmd.line_ibBuffer || cmd.line_ibBuffer.getByteLength()< (cmd._line_vertNum-2)*3*2){
					cmd.line_ibBuffer=/*__JS__ */new ParamData((lineVertNumCopy-2)*3*2,true,true);
				}
				cmd._line_ibSize=(cmd._line_vertNum-2)*3 *2;
				var _line_ib=cmd.line_ibBuffer._int16Data;
				idxpos=0;
				for (ii=0;ii < (cmd._line_vertNum-2)*3;ii++){
					_line_ib[idxpos++]=cmd._line_ibArray[ii];
				}
				if (!cmd.line_vbBuffer || cmd.line_vbBuffer.getByteLength()< cmd._line_vertNum*3 *4){
					cmd.line_vbBuffer=/*__JS__ */new ParamData(lineVertNumCopy*3 *4,true);
				}
				cmd._line_vbSize=cmd._line_vertNum *3 *4;
				var c2=ColorUtils.create(lineColor);
				var nColor2=c2.numColor;
				var _line_vb=cmd.line_vbBuffer._float32Data;
				var _line_vb_i32b=cmd.line_vbBuffer._int32Data;
				ix=0;
				for (i=0;i < cmd._line_vertNum;i++){
					_line_vb[ix++]=cmd._line_vbArray[i *2]+x;_line_vb[ix++]=cmd._line_vbArray[i *2+1]+y;_line_vb_i32b[ix++]=nColor2;
				}
			}
			else{
				cmd._lineWidth=1;
				var temp_lineColor="#ffffff";
				BasePoly.createLine2(cmd._linePoints,cmd._line_ibArray,cmd._lineWidth,0,cmd._line_vbArray,false);
				cmd._line_vertNum=cmd._linePoints.length;
				lineVertNumCopy=cmd._line_vertNum;
				if (!cmd.line_ibBuffer || cmd.line_ibBuffer.getByteLength()< (cmd._line_vertNum-2)*3*2){
					cmd.line_ibBuffer=/*__JS__ */new ParamData((lineVertNumCopy-2)*3*2,true,true);
				}
				cmd._line_ibSize=(cmd._line_vertNum-2)*3 *2;
				_line_ib=cmd.line_ibBuffer._int16Data;
				idxpos=0;
				for (ii=0;ii < (cmd._line_vertNum-2)*3;ii++){
					_line_ib[idxpos++]=cmd._line_ibArray[ii];
				}
				if (!cmd.line_vbBuffer || cmd.line_vbBuffer.getByteLength()< cmd._line_vertNum*3 *4){
					cmd.line_vbBuffer=/*__JS__ */new ParamData(lineVertNumCopy*3 *4,true);
				}
				cmd._line_vbSize=cmd._line_vertNum *3 *4;
				c2=ColorUtils.create(temp_lineColor);
				nColor2=c2.numColor;
				_line_vb=cmd.line_vbBuffer._float32Data;
				_line_vb_i32b=cmd.line_vbBuffer._int32Data;
				ix=0;
				for (i=0;i < cmd._line_vertNum;i++){
					_line_vb[ix++]=cmd._line_vbArray[i *2]+x;_line_vb[ix++]=cmd._line_vbArray[i *2+1]+y;_line_vb_i32b[ix++]=nColor2;
				}
			}
		};
		var _fb=cmd._paramData._float32Data;
		var _i32b=cmd._paramData._int32Data;
		_i32b[0]=1;
		_i32b[1]=8 *4;
		if (cmd.ibBuffer==null){
			return null;
		}
		_i32b[DrawPolyCmdNative._PARAM_VB_POS_]=cmd.vbBuffer.getPtrID();
		_i32b[DrawPolyCmdNative._PARAM_IB_POS_]=cmd.ibBuffer.getPtrID();
		_i32b[DrawPolyCmdNative._PARAM_VB_SIZE_POS_]=cmd._vbSize;
		_i32b[DrawPolyCmdNative._PARAM_IB_SIZE_POS_]=cmd._ibSize;
		_i32b[DrawPolyCmdNative._PARAM_VB_OFFSET_POS_]=0;
		_i32b[DrawPolyCmdNative._PARAM_IB_OFFSET_POS_]=0;
		_i32b[DrawPolyCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_]=0;
		_fb[DrawPolyCmdNative._PARAM_ISCONVEXT_POS_]=isConvexPolygon;
		LayaGL.syncBufferToRenderThread(cmd.vbBuffer);
		LayaGL.syncBufferToRenderThread(cmd.ibBuffer);
		_i32b[DrawPolyCmdNative._PARAM_LINE_VB_POS_]=cmd.line_vbBuffer.getPtrID();
		_i32b[DrawPolyCmdNative._PARAM_LINE_IB_POS_]=cmd.line_ibBuffer.getPtrID();
		_i32b[DrawPolyCmdNative._PARAM_LINE_VB_SIZE_POS_]=cmd._line_vbSize;
		_i32b[DrawPolyCmdNative._PARAM_LINE_IB_SIZE_POS_]=cmd._line_ibSize;
		_i32b[DrawPolyCmdNative._PARAM_LINE_VB_OFFSET_POS_]=0;
		_i32b[DrawPolyCmdNative._PARAM_LINE_IB_OFFSET_POS_]=0;
		_i32b[DrawPolyCmdNative._PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_]=0;
		LayaGL.syncBufferToRenderThread(cmd.line_vbBuffer);
		LayaGL.syncBufferToRenderThread(cmd.line_ibBuffer);
		LayaGL.syncBufferToRenderThread(cmd._paramData);
		if (lineColor){
			cmd._cmdCurrentPos=cmd._graphicsCmdEncoder.useCommandEncoder(DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		}
		else{
			cmd._cmdCurrentPos=cmd._graphicsCmdEncoder.useCommandEncoder(DrawPolyCmdNative._DRAW_POLY_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		}
		LayaGL.syncBufferToRenderThread(cmd._graphicsCmdEncoder);
		return cmd;
	}

	DrawPolyCmdNative.ID="DrawPoly";
	DrawPolyCmdNative._DRAW_POLY_CMD_ENCODER_=null;
	DrawPolyCmdNative._DRAW_POLY_LINES_CMD_ENCODER_=null;
	DrawPolyCmdNative._PARAM_VB_POS_=2;
	DrawPolyCmdNative._PARAM_IB_POS_=3;
	DrawPolyCmdNative._PARAM_VB_SIZE_POS_=4;
	DrawPolyCmdNative._PARAM_IB_SIZE_POS_=5;
	DrawPolyCmdNative._PARAM_LINE_VB_POS_=6;
	DrawPolyCmdNative._PARAM_LINE_IB_POS_=7;
	DrawPolyCmdNative._PARAM_LINE_VB_SIZE_POS_=8;
	DrawPolyCmdNative._PARAM_LINE_IB_SIZE_POS_=9;
	DrawPolyCmdNative._PARAM_ISCONVEXT_POS_=10;
	DrawPolyCmdNative._PARAM_VB_OFFSET_POS_=11;
	DrawPolyCmdNative._PARAM_IB_OFFSET_POS_=12;
	DrawPolyCmdNative._PARAM_LINE_VB_OFFSET_POS_=13;
	DrawPolyCmdNative._PARAM_LINE_IB_OFFSET_POS_=14;
	DrawPolyCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_=15;
	DrawPolyCmdNative._PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_=16;
	return DrawPolyCmdNative;
})()


//class laya.webgl.shader.ShaderValue
var ShaderValue=(function(){
	function ShaderValue(){}
	__class(ShaderValue,'laya.webgl.shader.ShaderValue');
	return ShaderValue;
})()


//class laya.webgl.resource.ICharRender
var ICharRender=(function(){
	function ICharRender(){}
	__class(ICharRender,'laya.webgl.resource.ICharRender');
	var __proto=ICharRender.prototype;
	__proto.getWidth=function(font,str){return 0;}
	__proto.scale=function(sx,sy){}
	/**
	*TODO stroke
	*@param char
	*@param font
	*@param size 返回宽高
	*@return
	*/
	__proto.getCharBmp=function(char,font,lineWidth,colStr,strokeColStr,size,margin_left,margin_top,margin_right,margin_bottom,rect){
		return null;
	}

	__getset(0,__proto,'canvasWidth',function(){
		return 0;
		},function(w){
	});

	return ICharRender;
})()


/**
*@private
*普通命令执行器
*/
//class laya.layagl.LayaGLRunner
var LayaGLRunner=(function(){
	function LayaGLRunner(){}
	__class(LayaGLRunner,'laya.layagl.LayaGLRunner');
	LayaGLRunner.uploadShaderUniforms=function(layaGL,commandEncoder,shaderData,uploadUnTexture){
		var data=shaderData._data;
		var shaderUniform=commandEncoder.getArrayData();
		var shaderCall=0;
		for (var i=0,n=shaderUniform.length;i < n;i++){
			var one=shaderUniform[i];
			if (uploadUnTexture || one.textureID!==-1){
				var value=data[one.dataOffset];
				if (value !=null)
					shaderCall+=one.fun.call(one.caller,one,value);
			}
		}
		return shaderCall;
	}

	LayaGLRunner.uploadCustomUniform=function(layaGL,custom,index,data){
		var shaderCall=0;
		var one=custom[index];
		if (one && data !=null)
			shaderCall+=one.fun.call(one.caller,one,data);
		return shaderCall;
	}

	LayaGLRunner.uploadShaderUniformsForNative=function(layaGL,commandEncoder,shaderData){
		var nType=/*laya.layagl.LayaGL.UPLOAD_SHADER_UNIFORM_TYPE_ID*/0;
		if (shaderData._runtimeCopyValues.length >=0){
			nType=/*laya.layagl.LayaGL.UPLOAD_SHADER_UNIFORM_TYPE_DATA*/1;
		};
		var data=shaderData._data;
		return layaGL.uploadShaderUniforms(commandEncoder,data,nType);
	}

	return LayaGLRunner;
})()


/**
*管理若干张CharPageTexture
*里面的字体属于相同字体，相同大小
*清理方式：
*每隔一段时间检查一下是否能合并，一旦发现可以省出一整张贴图，就开始清理
*/
//class laya.webgl.resource.CharPages
var CharPages=(function(){
	function CharPages(fontFamily,bmpDataSize,marginSz){
		//private static var ctx:*=null;
		this.pages=[];
		// CharPageTexture
		this.fontFamily=null;
		this._slotW=0;
		//格子的大小
		this._gridW=0;
		//以格子为单位的宽
		this._gridNum=0;
		//public var _textureHeight:int=1024;//
		this._baseSize=0;
		//0~15=0， 16~31=1，...
		this._lastSz=0;
		this._spaceWidthMap=[];
		//空格宽度的缓存。CharRenderInfo类型。主要用了 width
		this._minScoreID=-1;
		//得分最小的page
		this._selectedSizeIdx=0;
		//限制到1~16内
		this.margin_left=0;
		//有的字体会超出边界，所以加一个外围保护
		this.margin_top=0;
		this.margin_bottom=0;
		this.margin_right=0;
		this.gcCnt=0;
		this._textureWidth=CharBook.textureWidth;
		this.fontFamily=fontFamily;
		this.margin_top=
		this.margin_left=
		this.margin_right=this.margin_bottom=marginSz;
		this._baseSize=Math.floor(bmpDataSize / CharBook.gridSize)*CharBook.gridSize;
		this._selectedSizeIdx=(bmpDataSize-this._baseSize)|0;
		this._slotW=Math.ceil(bmpDataSize / CharBook.gridSize)*CharBook.gridSize
		this._gridW=Math.floor(this._textureWidth / this._slotW);
		if (this._gridW <=0){
			console.error("文字太大,需要修改texture大小");
			debugger;
			this._gridW=1;
		}
		this._gridNum=this._gridW *this._gridW;
		console.log('gridInfo:slotW='+this._slotW+',gridw='+this._gridW+',gridNum='+this._gridNum+',textureW='+this._textureWidth);
	}

	__class(CharPages,'laya.webgl.resource.CharPages');
	var __proto=CharPages.prototype;
	__proto.getWidth=function(str){
		return CharPages.charRender.getWidth(CharBook._curFont,str);
	}

	/**
	*pages最多有16个元素，代表不同的大小的文字（偏离basesize）这个函数表示选择哪个大小
	*@param sz
	*@param extsz 扩展后的大小。
	*/
	__proto.selectSize=function(sz,extsz){
		this._selectedSizeIdx=(extsz-this._baseSize)|0;
	}

	/**
	*返回空格的宽度。通过底层获得，所以这里用了缓存。
	*@param touch
	*@return
	*/
	__proto.getSpaceChar=function(touch){
		if (this._spaceWidthMap[this._selectedSizeIdx]){
			return this._spaceWidthMap[this._selectedSizeIdx];
		};
		var ret=new CharRenderInfo();
		this._spaceWidthMap[this._selectedSizeIdx]=ret;
		ret.width=this.getWidth(' ');
		ret.isSpace=true;
		return ret;
	}

	/**
	*添加一个文字到texture
	*@param str
	*@param bold 是否加粗
	*@param touch 是否touch,如果保存起来以后再处理就设置为false
	*@param scalekey 可能有缩放
	*@return
	*/
	__proto.getChar=function(str,lineWidth,fontsize,color,strokeColor,bold,touch,scalekey){
		if (str===' ')
			return this.getSpaceChar(touch);
		var key=(lineWidth > 0?(str+'_'+lineWidth+strokeColor):str);
		var ret;
		key+=color;
		bold && (key+='B');
		scalekey && (key+=scalekey);
		for (var i=0,sz=this.pages.length;i < sz;i++){
			var cp=this.pages[i];
			var cpmap=cp.charMaps[this._selectedSizeIdx];
			if (cpmap){
				ret=cpmap.get(key);
				if (ret){
					touch && ret.touch();
					return ret;
				}
			}
		}
		ret=this._getASlot();
		if (!ret)
			return null;
		var charmaps=ret.tex.charMaps[this._selectedSizeIdx];
		(!charmaps)&& (charmaps=ret.tex.charMaps[this._selectedSizeIdx]=new Map());
		charmaps.set(key,ret);
		touch && ret.touch();
		ret.height=fontsize;
		var bmp=this.getCharBmp(str,CharBook._curFont,lineWidth,color,strokeColor,ret);
		var cy=Math.floor(ret.pos / this._gridW);
		var cx=ret.pos % this._gridW;
		var _curX=cx *this._slotW;
		var _curY=cy *this._slotW;
		var texW=this._textureWidth;
		var minx=_curX / texW;
		var miny=_curY / texW;
		var maxx=(_curX+bmp.width)/ texW;
		var maxy=(_curY+bmp.height)/ texW;
		var uv=ret.uv;
		uv[0]=minx;uv[1]=miny;
		uv[2]=maxx;uv[3]=miny;
		uv[4]=maxx;uv[5]=maxy;
		uv[6]=minx;uv[7]=maxy;
		ret.tex.addChar(bmp,_curX,_curY);
		return ret;
	}

	/**
	*从所有的page中找一个空格子
	*如果没有地方了，就创建一个新的charpageTexture
	*/
	__proto._getASlot=function(){
		var sz=this.pages.length;
		var cp;
		var ret;
		var pos=0;
		for (var i=0;i < sz;i++){
			cp=this.pages[i];
			ret=cp.findAGrid();
			if (ret){
				return ret;
			}
		}
		cp=CharBook.trash.getAPage(this._gridNum);
		this.pages.push(cp);
		ret=cp.findAGrid();
		if (!ret){
			console.error("_getASlot error!");
		}
		return ret;
	}

	//TODO:coverage
	__proto.getAllPageScore=function(){
		var i=0,sz=this.pages.length;
		var curTick=Stat.loopCount;
		var score=0;
		var minScore=10000;
		for (;i < sz;i++){
			var cp=this.pages[i];
			if (cp._scoreTick==curTick){
				score+=cp._score;
				}else {
				cp._score=0;
			}
			if (cp._score < minScore){
				minScore=cp._score;
				this._minScoreID=i;
			}
		}
		return score;
	}

	//TODO:coverage
	__proto.removeLRU=function(){
		var freed=this._gridNum *this.pages.length-this.getAllPageScore();
		if (freed>=this._gridNum){
			if (this._minScoreID >=0){
				var cp=this.pages[this._minScoreID];
				console.log('remove fontpage: delpageid='+this._minScoreID+', total='+this.pages.length+',gcCnt:'+(this.gcCnt+1));
				var used=cp._score;
				cp.printDebugInfo();
				CharBook.trash.discardPage(cp);
				this.pages[this._minScoreID]=this.pages[this.pages.length-1];
				this.pages.pop();
				var curloop=Stat.loopCount;
				var i=0,sz=this.pages.length;
				for(;i < sz && used > 0;i++){
					cp=this.pages[i];
					console.log('clean page '+i);
					var cleaned=cp.removeOld(curloop);
					used-=cleaned;
				}
			}
			this.gcCnt++;
			return true;
		}
		return false;
	}

	//TODO:coverage
	__proto.getCharBmp=function(char,font,lineWidth,colStr,strokeColStr,size){
		return CharPages.charRender.getCharBmp(char,font,lineWidth,colStr,strokeColStr,size,this.margin_left,this.margin_top,this.margin_right,this.margin_bottom);
	}

	// for debug
	__proto.printPagesInfo=function(){
		console.log('拥有页数: ',this.pages.length);
		console.log('基本大小:',this._baseSize);
		console.log('格子宽度:',this._slotW);
		console.log('每行格子数:',this._gridW);
		console.log('贴图大小:',this._textureWidth);
		console.log('    边界:',this.margin_left,this.margin_top);
		console.log('得分最少页:',this._minScoreID);
		console.log('  GC次数:',this.gcCnt);
		console.log(' -------页信息-------');
		this.pages.forEach(function(cp){
			cp.printDebugInfo(true);
		});
		console.log(' -----页信息结束-------');
	}

	CharPages.getBmpSize=function(fonstsize){
		return fonstsize *1.5;
	}

	CharPages.charRender=null;
	return CharPages;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.DrawPieCmdNative
var DrawPieCmdNative=(function(){
	function DrawPieCmdNative(){
		this._graphicsCmdEncoder=null;
		this._paramData=null;
		this._paramID=null;
		this._x=NaN;
		this._y=NaN;
		this._radius=NaN;
		this._startAngle=NaN;
		this._endAngle=NaN;
		this._fillColor=null;
		this._lineColor=null;
		this._lineWidth=NaN;
		this._vertNum=0;
		this._line_vertNum=0;
		this.ibBuffer=null;
		this.vbBuffer=null;
		this.line_ibBuffer=null;
		this.line_vbBuffer=null;
		this._ibSize=0;
		this._vbSize=0;
		this._line_ibSize=0;
		this._line_vbSize=0;
		this._cmdCurrentPos=0;
		this._points=[];
		this._linePoints=[];
		this._line_vbArray=[];
		this._line_ibArray=[];
	}

	__class(DrawPieCmdNative,'laya.layagl.cmdNative.DrawPieCmdNative');
	var __proto=DrawPieCmdNative.prototype;
	__proto._arc=function(cx,cy,r,startAngle,endAngle,counterclockwise,b){
		(counterclockwise===void 0)&& (counterclockwise=false);
		(b===void 0)&& (b=true);
		var newPoints=[];
		newPoints.push(0);
		newPoints.push(0);
		var a=0,da=0,hda=0,kappa=0;
		var dx=0,dy=0,x=0,y=0,tanx=0,tany=0;
		var px=0,py=0,ptanx=0,ptany=0;
		var i=0,ndivs=0,nvals=0;
		da=endAngle-startAngle;
		if (!counterclockwise){
			if (Math.abs(da)>=Math.PI *2){
				da=Math.PI *2;
			}
			else{
				while (da < 0.0){
					da+=Math.PI *2;
				}
			}
		}
		else{
			if (Math.abs(da)>=Math.PI *2){
				da=-Math.PI *2;
			}
			else{
				while (da > 0.0){
					da-=Math.PI *2;
				}
			}
		}
		if (r < 101){
			ndivs=Math.max(10,da *r / 5);
		}
		else if (r < 201){
			ndivs=Math.max(10,da *r / 20);
		}
		else{
			ndivs=Math.max(10,da *r / 40);
		}
		hda=(da / ndivs)/ 2.0;
		kappa=Math.abs(4 / 3 *(1-Math.cos(hda))/ Math.sin(hda));
		if (counterclockwise){
			kappa=-kappa;
		}
		nvals=0;
		var _x1=NaN,_y1=NaN;
		var lastOriX=0,lastOriY=0;
		for (i=0;i <=ndivs;i++){
			a=startAngle+da *(i / ndivs);
			dx=Math.cos(a);
			dy=Math.sin(a);
			x=cx+dx *r;
			y=cy+dy *r;
			if (x !=lastOriX || y !=lastOriY){
				newPoints.push(x);
				newPoints.push(y);
			}
			lastOriX=x;
			lastOriY=y;
		}
		dx=Math.cos(endAngle);
		dy=Math.sin(endAngle);
		x=cx+dx *r;
		y=cy+dy *r;
		if (x !=lastOriX || y !=lastOriY){
			newPoints.push(x);
			newPoints.push(y);
		}
		return newPoints;
	}

	__proto._setData=function(x,y,fillColor,points,lineColor,lineWidth){{
			this._vertNum=points.length / 2;
			var vertNumCopy=this._vertNum;
			var curvert=0;
			var faceNum=this._vertNum-2;
			if (!this.ibBuffer || this.ibBuffer.getByteLength()< faceNum *3 *2){
				this.ibBuffer=/*__JS__ */new ParamData(faceNum*3*2,true,true);
			}
			this._ibSize=faceNum *3 *2;
			var _ib=this.ibBuffer._int16Data;
			var idxpos=0;
			for (var fi=0;fi < faceNum;fi++){
				_ib[idxpos++]=curvert;
				_ib[idxpos++]=fi+1+curvert;
				_ib[idxpos++]=fi+2+curvert;
			}
			if (!this.vbBuffer || this.vbBuffer.getByteLength()< this._vertNum *3 *4){
				this.vbBuffer=/*__JS__ */new ParamData(vertNumCopy*3 *4,true);
			}
			this._vbSize=this._vertNum *3 *4;
			var c1=ColorUtils.create(fillColor);
			var nColor=c1.numColor;
			var _vb=this.vbBuffer._float32Data;
			var _vb_i32b=this.vbBuffer._int32Data;
			var ix=0;
			for (var i=0;i < this._vertNum;i++){
				_vb[ix++]=points[i *2]+x;_vb[ix++]=points[i *2+1]+y;_vb_i32b[ix++]=nColor;
			};
			var lineVertNumCopy=0;
			this._linePoints.length=0;
			this._line_ibArray.length=0;
			this._line_vbArray.length=0;
			for (i=0;i < points.length;i++){
				this._linePoints.push(points[i]);
			}
			this._linePoints.push(points[0]);
			this._linePoints.push(points[1]);
			if (lineColor){
				BasePoly.createLine2(this._linePoints,this._line_ibArray,lineWidth,0,this._line_vbArray,false);
				this._line_vertNum=this._linePoints.length;
				lineVertNumCopy=this._line_vertNum;
				if (!this.line_ibBuffer || this.line_ibBuffer.getByteLength()< (this._line_vertNum-2)*3*2){
					this.line_ibBuffer=/*__JS__ */new ParamData((lineVertNumCopy-2)*3*2,true,true);
				}
				this._line_ibSize=(this._line_vertNum-2)*3 *2;
				var _line_ib=this.line_ibBuffer._int16Data;
				idxpos=0;
				for (var ii=0;ii < (this._line_vertNum-2)*3;ii++){
					_line_ib[idxpos++]=this._line_ibArray[ii];
				}
				if (!this.line_vbBuffer || this.line_vbBuffer.getByteLength()< this._line_vertNum*3 *4){
					this.line_vbBuffer=/*__JS__ */new ParamData(lineVertNumCopy*3 *4,true);
				}
				this._line_vbSize=this._line_vertNum *3 *4;
				var c2=ColorUtils.create(lineColor);
				var nColor2=c2.numColor;
				var _line_vb=this.line_vbBuffer._float32Data;
				var _line_vb_i32b=this.line_vbBuffer._int32Data;
				ix=0;
				for (i=0;i < this._line_vertNum;i++){
					_line_vb[ix++]=this._line_vbArray[i *2]+this._x;
					_line_vb[ix++]=this._line_vbArray[i *2+1]+this._y;
					_line_vb_i32b[ix++]=nColor2;
				}
			}
			else{
				this._lineWidth=1;
				var temp_lineColor='#FFFFFF';
				BasePoly.createLine2(this._linePoints,this._line_ibArray,this._lineWidth,0,this._line_vbArray,false);
				this._line_vertNum=this._linePoints.length;
				lineVertNumCopy=this._line_vertNum;
				if (!this.line_ibBuffer || this.line_ibBuffer.getByteLength()< (this._line_vertNum-2)*3*2){
					this.line_ibBuffer=/*__JS__ */new ParamData((lineVertNumCopy-2)*3*2,true,true);
				}
				this._line_ibSize=(this._line_vertNum-2)*3 *2;
				_line_ib=this.line_ibBuffer._int16Data;
				idxpos=0;
				for (ii=0;ii < (this._line_vertNum-2)*3;ii++){
					_line_ib[idxpos++]=this._line_ibArray[ii];
				}
				if (!this.line_vbBuffer || this.line_vbBuffer.getByteLength()< this._line_vertNum*3 *4){
					this.line_vbBuffer=/*__JS__ */new ParamData(lineVertNumCopy*3 *4,true);
				}
				this._line_vbSize=this._line_vertNum *3 *4;
				c2=ColorUtils.create(temp_lineColor);
				nColor2=c2.numColor;
				_line_vb=this.line_vbBuffer._float32Data;
				_line_vb_i32b=this.line_vbBuffer._int32Data;
				ix=0;
				for (i=0;i < this._line_vertNum;i++){
					_line_vb[ix++]=this._line_vbArray[i *2]+this._x;
					_line_vb[ix++]=this._line_vbArray[i *2+1]+this._y;
					_line_vb_i32b[ix++]=nColor2;
				}
			}
		}
	}

	__proto._saveToParamData=function(){
		var _fb=this._paramData._float32Data;
		var _i32b=this._paramData._int32Data;
		_i32b[0]=1;
		_i32b[1]=8*4;
		_i32b[DrawPieCmdNative._PARAM_VB_POS_]=this.vbBuffer.getPtrID();
		_i32b[DrawPieCmdNative._PARAM_IB_POS_]=this.ibBuffer.getPtrID();
		_i32b[DrawPieCmdNative._PARAM_VB_SIZE_POS_]=this._vbSize;
		_i32b[DrawPieCmdNative._PARAM_IB_SIZE_POS_]=this._ibSize;
		_i32b[DrawPieCmdNative._PARAM_VB_OFFSET_POS_]=0;
		_i32b[DrawPieCmdNative._PARAM_IB_OFFSET_POS_]=0;
		_i32b[DrawPieCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_]=0;
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
		LayaGL.syncBufferToRenderThread(this.ibBuffer);
		_i32b[DrawPieCmdNative._PARAM_LINE_VB_POS_]=this.line_vbBuffer.getPtrID();
		_i32b[DrawPieCmdNative._PARAM_LINE_IB_POS_]=this.line_ibBuffer.getPtrID();
		_i32b[DrawPieCmdNative._PARAM_LINE_VB_SIZE_POS_]=this._line_vbSize;
		_i32b[DrawPieCmdNative._PARAM_LINE_IB_SIZE_POS_]=this._line_ibSize;
		_i32b[DrawPieCmdNative._PARAM_LINE_VB_OFFSET_POS_]=0;
		_i32b[DrawPieCmdNative._PARAM_LINE_IB_OFFSET_POS_]=0;
		_i32b[DrawPieCmdNative._PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_]=0;
		LayaGL.syncBufferToRenderThread(this.line_vbBuffer);
		LayaGL.syncBufferToRenderThread(this.line_ibBuffer);
	}

	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._fillColor=null;
		this._lineColor=null;
		this._points.length=0;
		this._linePoints.length=0;
		this._line_vbArray.length=0;
		this._line_ibArray.length=0;
		Pool.recover("DrawPieCmd",this);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._lineColor;
		},function(value){
		if (!this._lineColor&&this._lineWidth){
			this._graphicsCmdEncoder._idata[this._cmdCurrentPos+1]=DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_.getPtrID();
			LayaGL.syncBufferToRenderThread(this._graphicsCmdEncoder);
		}
		this._lineColor=value;
		this._linePoints.length=0;
		this._line_ibArray.length=0;
		this._line_vbArray.length=0;
		for (var i=0;i < this._points.length;i++){
			this._linePoints.push(this._points[i]);
		}
		this._linePoints.push(this._points[0]);
		this._linePoints.push(this._points[1]);
		BasePoly.createLine2(this._linePoints,this._line_ibArray,this._lineWidth,0,this._line_vbArray,false);
		this._line_vertNum=this._linePoints.length;
		var lineVertNumCopy=this._line_vertNum;
		if (!this.line_ibBuffer || this.line_ibBuffer.getByteLength()< (this._line_vertNum-2)*3*2){
			this.line_ibBuffer=/*__JS__ */new ParamData((lineVertNumCopy-2)*3*2,true,true);
		}
		this._line_ibSize=(this._line_vertNum-2)*3 *2;
		var _line_ib=this.line_ibBuffer._int16Data;
		var idxpos=0;
		for (var ii=0;ii < (this._line_vertNum-2)*3;ii++){
			_line_ib[idxpos++]=this._line_ibArray[ii];
		}
		if (!this.line_vbBuffer || this.line_vbBuffer.getByteLength()< this._line_vertNum*3 *4){
			this.line_vbBuffer=/*__JS__ */new ParamData(lineVertNumCopy*3 *4,true);
		}
		this._line_vbSize=this._line_vertNum *3 *4;
		var c2=ColorUtils.create(value);
		var nColor2=c2.numColor;
		var _line_vb=this.line_vbBuffer._float32Data;
		var _line_vb_i32b=this.line_vbBuffer._int32Data;
		var ix=0;
		for (i=0;i < this._line_vertNum;i++){
			_line_vb[ix++]=this._line_vbArray[i *2]+this._x;
			_line_vb[ix++]=this._line_vbArray[i *2+1]+this._y;
			_line_vb_i32b[ix++]=nColor2;
		}
		LayaGL.syncBufferToRenderThread(this.line_ibBuffer);
		LayaGL.syncBufferToRenderThread(this.line_vbBuffer);
	});

	__getset(0,__proto,'startAngle',function(){
		return this._startAngle*180/Math.PI;
		},function(value){
		this._startAngle=value *Math.PI / 180;
		this._points=this._arc(0,0,this._radius,value *Math.PI / 180 ,this._endAngle);
		this._setData(this._x,this._y,this._fillColor,this._points,this._lineColor,this._lineWidth);
		this._saveToParamData();
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawPie";
	});

	__getset(0,__proto,'fillColor',function(){
		return this._fillColor;
		},function(value){
		this._fillColor=value;
		var c1=ColorUtils.create(this._fillColor);
		var nColor=c1.numColor;
		var _i32b=this.vbBuffer._int32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			ix++;ix++;_i32b[ix++]=nColor;
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
		var _vb=this.vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			_vb[ix++]=this._points[i *2]+this._x;ix++;ix++;
		}
		if (this._lineColor){
			var _line_vb=this.line_vbBuffer._float32Data;
			ix=0;
			for (i=0;i < this._line_vertNum;i++){
				_line_vb[ix++]=this._line_vbArray[i *2]+this._x;ix++;ix++;
			}
			LayaGL.syncBufferToRenderThread(this.line_vbBuffer);
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
		var _vb=this.vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			ix++;_vb[ix++]=this._points[i *2+1]+this._y;ix++;
		}
		if (this._lineColor){
			var _line_vb=this.line_vbBuffer._float32Data;
			ix=0;
			for (i=0;i < this._line_vertNum;i++){
				ix++;_line_vb[ix++]=this._line_vbArray[i *2+1]+this._y;ix++;
			}
			LayaGL.syncBufferToRenderThread(this.line_vbBuffer);
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'radius',function(){
		return this._radius;
		},function(value){
		this._points=this._arc(0,0,value,this._startAngle,this._endAngle);
		this._setData(this._x,this._y,this._fillColor,this._points,this._lineColor,this._lineWidth);
		this._saveToParamData();
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'endAngle',function(){
		return this._endAngle*180/Math.PI;
		},function(value){
		this._endAngle=value *Math.PI / 180;
		this._points=this._arc(0,0,this._radius,this._startAngle,value*Math.PI / 180);
		this._setData(this._x,this._y,this._fillColor,this._points,this._lineColor,this._lineWidth);
		this._saveToParamData();
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		if (this.lineColor){
			this._graphicsCmdEncoder._idata[this._cmdCurrentPos+1]=DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_.getPtrID();
			LayaGL.syncBufferToRenderThread(this._graphicsCmdEncoder);
		}
		this._lineWidth=value;
		this._linePoints.length=0;
		this._line_ibArray.length=0;
		this._line_vbArray.length=0;
		for (var i=0;i < this._points.length;i++){
			this._linePoints.push(this._points[i]);
		}
		this._linePoints.push(this._points[0]);
		this._linePoints.push(this._points[1]);
		BasePoly.createLine2(this._linePoints,this._line_ibArray,value,0,this._line_vbArray,false);
		this._line_vertNum=this._linePoints.length;
		var lineVertNumCopy=this._line_vertNum;
		if (!this.line_ibBuffer || this.line_ibBuffer.getByteLength()< (this._line_vertNum-2)*3*2){
			this.line_ibBuffer=/*__JS__ */new ParamData((lineVertNumCopy-2)*3*2,true,true);
		}
		this._line_ibSize=(this._line_vertNum-2)*3 *2;
		var _line_ib=this.line_ibBuffer._int16Data;
		var idxpos=0;
		for (var ii=0;ii < (this._line_vertNum-2)*3;ii++){
			_line_ib[idxpos++]=this._line_ibArray[ii];
		}
		if (!this.line_vbBuffer || this.line_vbBuffer.getByteLength()< this._line_vertNum*3 *4){
			this.line_vbBuffer=/*__JS__ */new ParamData(lineVertNumCopy*3 *4,true);
		}
		this._line_vbSize=this._line_vertNum *3 *4;
		var c2=ColorUtils.create(this.lineColor);
		var nColor2=c2.numColor;
		var _line_vb=this.line_vbBuffer._float32Data;
		var _line_vb_i32b=this.line_vbBuffer._int32Data;
		var ix=0;
		for (i=0;i < this._line_vertNum;i++){
			_line_vb[ix++]=this._line_vbArray[i *2]+this._x;
			_line_vb[ix++]=this._line_vbArray[i *2+1]+this._y;
			_line_vb_i32b[ix++]=nColor2;
		}
		LayaGL.syncBufferToRenderThread(this.line_ibBuffer);
		LayaGL.syncBufferToRenderThread(this.line_vbBuffer);
	});

	DrawPieCmdNative.create=function(x,y,radius,startAngle,endAngle,fillColor,lineColor,lineWidth,vid){
		var cmd=Pool.getItemByClass("DrawPieCmd",DrawPieCmdNative);
		cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		if (!DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_){
			DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(244,32,true);
			DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);
			DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);
			DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_.setMeshExByParamData(DrawPieCmdNative._PARAM_VB_POS_ *4,DrawPieCmdNative._PARAM_VB_OFFSET_POS_*4,DrawPieCmdNative._PARAM_VB_SIZE_POS_ *4,DrawPieCmdNative._PARAM_IB_POS_ *4,DrawPieCmdNative._PARAM_IB_OFFSET_POS_*4,DrawPieCmdNative._PARAM_IB_SIZE_POS_ *4,DrawPieCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_.setMeshExByParamData(DrawPieCmdNative._PARAM_LINE_VB_POS_ *4,DrawPieCmdNative._PARAM_LINE_VB_OFFSET_POS_*4,DrawPieCmdNative._PARAM_LINE_VB_SIZE_POS_ *4,DrawPieCmdNative._PARAM_LINE_IB_POS_ *4,DrawPieCmdNative._PARAM_LINE_IB_OFFSET_POS_*4,DrawPieCmdNative._PARAM_LINE_IB_SIZE_POS_ *4,DrawPieCmdNative._PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_);
		}
		if (!DrawPieCmdNative._DRAW_PIE_CMD_ENCODER_){
			DrawPieCmdNative._DRAW_PIE_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(168,32,true);
			DrawPieCmdNative._DRAW_PIE_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawPieCmdNative._DRAW_PIE_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);
			DrawPieCmdNative._DRAW_PIE_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);
			DrawPieCmdNative._DRAW_PIE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawPieCmdNative._DRAW_PIE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawPieCmdNative._DRAW_PIE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawPieCmdNative._DRAW_PIE_CMD_ENCODER_.setMeshExByParamData(DrawPieCmdNative._PARAM_VB_POS_ *4,DrawPieCmdNative._PARAM_VB_OFFSET_POS_*4,DrawPieCmdNative._PARAM_VB_SIZE_POS_ *4,DrawPieCmdNative._PARAM_IB_POS_ *4,DrawPieCmdNative._PARAM_IB_OFFSET_POS_*4,DrawPieCmdNative._PARAM_IB_SIZE_POS_ *4,DrawPieCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawPieCmdNative._DRAW_PIE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawPieCmdNative._DRAW_PIE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawPieCmdNative._DRAW_PIE_CMD_ENCODER_);
		}
		if (!cmd._paramData){
			cmd._paramData=/*__JS__ */new ParamData(16 *4,true);
			}{
			cmd._x=x;
			cmd._y=y;
			cmd._radius=radius;
			cmd._startAngle=startAngle;
			cmd._endAngle=endAngle;
			cmd._fillColor=fillColor;
			cmd._lineColor=lineColor;
			cmd._lineWidth=lineWidth;
			cmd._points=cmd._arc(0,0,radius,startAngle,endAngle);
			cmd._setData(x,y,fillColor,cmd._points,lineColor,lineWidth);
		}
		cmd._saveToParamData();
		LayaGL.syncBufferToRenderThread(cmd._paramData);
		if (lineColor){
			cmd._cmdCurrentPos=cmd._graphicsCmdEncoder.useCommandEncoder(DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		}
		else{
			cmd._cmdCurrentPos=cmd._graphicsCmdEncoder.useCommandEncoder(DrawPieCmdNative._DRAW_PIE_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		}
		LayaGL.syncBufferToRenderThread(cmd._graphicsCmdEncoder);
		return cmd;
	}

	DrawPieCmdNative.ID="DrawPie";
	DrawPieCmdNative._DRAW_PIE_CMD_ENCODER_=null;
	DrawPieCmdNative._DRAW_PIE_LINES_CMD_ENCODER_=null;
	DrawPieCmdNative._PARAM_VB_POS_=2;
	DrawPieCmdNative._PARAM_IB_POS_=3;
	DrawPieCmdNative._PARAM_LINE_VB_POS_=4;
	DrawPieCmdNative._PARAM_LINE_IB_POS_=5;
	DrawPieCmdNative._PARAM_VB_SIZE_POS_=6;
	DrawPieCmdNative._PARAM_IB_SIZE_POS_=7;
	DrawPieCmdNative._PARAM_LINE_VB_SIZE_POS_=8;
	DrawPieCmdNative._PARAM_LINE_IB_SIZE_POS_=9;
	DrawPieCmdNative._PARAM_VB_OFFSET_POS_=10;
	DrawPieCmdNative._PARAM_IB_OFFSET_POS_=11;
	DrawPieCmdNative._PARAM_LINE_VB_OFFSET_POS_=12;
	DrawPieCmdNative._PARAM_LINE_IB_OFFSET_POS_=13;
	DrawPieCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_=14;
	DrawPieCmdNative._PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_=15;
	return DrawPieCmdNative;
})()


/**
*...
*@author ...
*/
//class laya.webgl.BufferStateBase
var BufferStateBase=(function(){
	function BufferStateBase(){
		/**@private [只读]*/
		this._nativeVertexArrayObject=null;
		/**@private [只读]*/
		this._bindedIndexBuffer=null;
		this._nativeVertexArrayObject=LayaGL.instance.createVertexArray();
	}

	__class(BufferStateBase,'laya.webgl.BufferStateBase');
	var __proto=BufferStateBase.prototype;
	/**
	*@private
	*/
	__proto.bind=function(){
		if (BufferStateBase._curBindedBufferState!==this){
			LayaGL.instance.bindVertexArray(this._nativeVertexArrayObject);
			BufferStateBase._curBindedBufferState=this;
		}
	}

	/**
	*@private
	*/
	__proto.unBind=function(){
		if (BufferStateBase._curBindedBufferState===this){
			LayaGL.instance.bindVertexArray(null);
			BufferStateBase._curBindedBufferState=null;
			}else {
			throw "BufferState: must call bind() function first.";
		}
	}

	/**
	*@private
	*/
	__proto.bindForNative=function(){
		LayaGL.instance.bindVertexArray(this._nativeVertexArrayObject);
		BufferStateBase._curBindedBufferState=this;
	}

	/**
	*@private
	*/
	__proto.unBindForNative=function(){
		LayaGL.instance.bindVertexArray(null);
		BufferStateBase._curBindedBufferState=null;
	}

	/**
	*@private
	*/
	__proto.destroy=function(){
		LayaGL.instance.deleteVertexArray(this._nativeVertexArrayObject);
	}

	BufferStateBase._curBindedBufferState=null;
	return BufferStateBase;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.DrawRectCmdNative
var DrawRectCmdNative=(function(){
	function DrawRectCmdNative(){
		this._graphicsCmdEncoder=null;
		this._index=0;
		this._paramData=null;
		this._x=NaN;
		this._y=NaN;
		this._width=NaN;
		this._height=NaN;
		this._fillColor=null;
		this._lineColor=null;
		this._lineWidth=NaN;
		this._line_vertNum=0;
		this._cmdCurrentPos=0;
		this._linePoints=[];
		this._line_ibArray=[];
		this._line_vbArray=[];
	}

	__class(DrawRectCmdNative,'laya.layagl.cmdNative.DrawRectCmdNative');
	var __proto=DrawRectCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._linePoints.length=0;
		this._line_ibArray.length=0;
		this._line_vbArray.length=0;
		this._graphicsCmdEncoder=null;
		Pool.recover("DrawRectCmd",this);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._lineColor;
		},function(value){
		this._graphicsCmdEncoder._idata[this._cmdCurrentPos+1]=DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.getPtrID();
		LayaGL.syncBufferToRenderThread(this._graphicsCmdEncoder);
		this._lineColor=value;
		var _i32b=this._paramData._int32Data;
		var c2=ColorUtils.create(value);
		var nLineColor=c2.numColor;
		var ix=DrawRectCmdNative._PARAM_LINE_VB_POS_;
		for (var i=0;i < this._line_vertNum;i++){
			ix++;ix++;_i32b[ix++]=nLineColor;
		}
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawRect";
	});

	__getset(0,__proto,'fillColor',function(){
		return this._fillColor;
		},function(value){
		this._fillColor=value;
		if (typeof value==='string'){
			var c1=ColorUtils.create(this._fillColor);
			var nFillColor=c1.numColor;
			var _i32b=this._paramData._int32Data;
			_i32b[DrawRectCmdNative._PARAM_VB_POS_+4]=nFillColor;
			_i32b[DrawRectCmdNative._PARAM_VB_POS_+10]=nFillColor;
			_i32b[DrawRectCmdNative._PARAM_VB_POS_+16]=nFillColor;
			_i32b[DrawRectCmdNative._PARAM_VB_POS_+22]=nFillColor;
		}
		else{
			_i32b=this._paramData._int32Data;
			_i32b[DrawRectCmdNative._PARAM_VB_POS_+4]=value;
			_i32b[DrawRectCmdNative._PARAM_VB_POS_+10]=value;
			_i32b[DrawRectCmdNative._PARAM_VB_POS_+16]=value;
			_i32b[DrawRectCmdNative._PARAM_VB_POS_+22]=value;
		}
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'width',function(){
		return this._width;
		},function(value){
		this._width=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawRectCmdNative._PARAM_VB_POS_+6]=this._x+this._width;
		_fb[DrawRectCmdNative._PARAM_VB_POS_+12]=this._x+this._width;
		if (this.lineColor){
			this._line_ibArray.length=0;
			this._line_vbArray.length=0;
			this._linePoints[2]=this._x+this._width;
			this._linePoints[4]=this._x+this._width;
			BasePoly.createLine2(this._linePoints,this._line_ibArray,this._lineWidth,0,this._line_vbArray,false);
			this._line_vertNum=this._linePoints.length;
			var ix=DrawRectCmdNative._PARAM_LINE_VB_POS_;
			for (var i=0;i < this._line_vertNum;i++){
				_fb[ix++]=this._line_vbArray[i *2];_fb[ix++]=this._line_vbArray[i *2+1];ix++;
			}
		}
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawRectCmdNative._PARAM_VB_POS_]=this._x;
		_fb[DrawRectCmdNative._PARAM_VB_POS_+6]=this._x+this._width;
		_fb[DrawRectCmdNative._PARAM_VB_POS_+12]=this._x+this._width;
		_fb[DrawRectCmdNative._PARAM_VB_POS_+18]=this._x;
		if (this.lineColor){
			this._line_ibArray.length=0;
			this._line_vbArray.length=0;
			this._linePoints[0]=this._x;this._linePoints[2]=this._x+this._width;
			this._linePoints[4]=this._x+this._width;this._linePoints[6]=this._x;this._linePoints[8]=this._x;
			BasePoly.createLine2(this._linePoints,this._line_ibArray,this._lineWidth,0,this._line_vbArray,false);
			var ix=DrawRectCmdNative._PARAM_LINE_VB_POS_;
			for (var i=0;i < this._line_vertNum;i++){
				_fb[ix++]=this._line_vbArray[i *2];_fb[ix++]=this._line_vbArray[i *2+1];ix++;
			}
		}
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawRectCmdNative._PARAM_VB_POS_+1]=this._y;
		_fb[DrawRectCmdNative._PARAM_VB_POS_+7]=this._y;
		_fb[DrawRectCmdNative._PARAM_VB_POS_+13]=this._y+this._height;
		_fb[DrawRectCmdNative._PARAM_VB_POS_+19]=this._y+this._height;
		if (this.lineColor){
			this._line_ibArray.length=0;
			this._line_vbArray.length=0;
			this._linePoints[1]=this._y;this._linePoints[3]=this._y;
			this._linePoints[5]=this._y+this._height;this._linePoints[7]=this._y+this._height;this._linePoints[9]=this._y-this._lineWidth / 2;
			BasePoly.createLine2(this._linePoints,this._line_ibArray,this._lineWidth,0,this._line_vbArray,false);
			var ix=DrawRectCmdNative._PARAM_LINE_VB_POS_;
			for (var i=0;i < this._line_vertNum;i++){
				_fb[ix++]=this._line_vbArray[i *2];_fb[ix++]=this._line_vbArray[i *2+1];ix++;
			}
		}
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'height',function(){
		return this._height;
		},function(value){
		this._height=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawRectCmdNative._PARAM_VB_POS_+13]=this._y+this._height;
		_fb[DrawRectCmdNative._PARAM_VB_POS_+19]=this._y+this._height;
		if (this.lineColor){
			this._line_ibArray.length=0;
			this._line_vbArray.length=0;
			this._linePoints[5]=this._y+this._height;
			this._linePoints[7]=this._y+this._height;
			BasePoly.createLine2(this._linePoints,this._line_ibArray,this._lineWidth,0,this._line_vbArray,false);
			var ix=DrawRectCmdNative._PARAM_LINE_VB_POS_;
			for (var i=0;i < this._line_vertNum;i++){
				_fb[ix++]=this._line_vbArray[i *2];_fb[ix++]=this._line_vbArray[i *2+1];ix++;
			}
		}
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		if (this.lineColor){
			this._graphicsCmdEncoder._idata[this._cmdCurrentPos+1]=DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.getPtrID();
			LayaGL.syncBufferToRenderThread(this._graphicsCmdEncoder);
		}
		this._lineWidth=value;
		this._line_ibArray.length=0;
		this._line_vbArray.length=0;
		this._linePoints[9]=this._y-this._lineWidth / 2;
		BasePoly.createLine2(this._linePoints,this._line_ibArray,this._lineWidth,0,this._line_vbArray,false);
		this._line_vertNum=this._linePoints.length;
		var _fb=this._paramData._float32Data;
		var ix=DrawRectCmdNative._PARAM_LINE_VB_POS_;
		for (var i=0;i < this._line_vertNum;i++){
			_fb[ix++]=this._line_vbArray[i *2];_fb[ix++]=this._line_vbArray[i *2+1];ix++;
		}
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	DrawRectCmdNative.create=function(x,y,width,height,fillColor,lineColor,lineWidth){
		var cmd=Pool.getItemByClass("DrawRectCmd",DrawRectCmdNative);
		cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		if (!DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_){
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(300,32,true);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.setRectMeshByParamData(DrawRectCmdNative._PARAM_RECT_NUM_POS_ *4,DrawRectCmdNative._PARAM_VB_POS_ *4,DrawRectCmdNative._PARAM_VB_SIZE_POS_ *4);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.setMeshByParamData(DrawRectCmdNative._PARAM_LINE_VB_POS_ *4,DrawRectCmdNative._PARAM_LINE_VB_OFFSET_POS_ *4,DrawRectCmdNative._PARAM_LINE_VB_SIZE_POS_ *4,DrawRectCmdNative._PARAM_LINE_IB_POS_ *4,DrawRectCmdNative._PARAM_LINE_IB_OFFSET_POS_ *4,DrawRectCmdNative._PARAM_LINE_IB_SIZE_POS_ *4,DrawRectCmdNative._PARAM_LINE_IBELEMENT_OFFSET_POS_ *4);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_);
		}
		if (!DrawRectCmdNative._DRAW_RECT_CMD_ENCODER_){
			DrawRectCmdNative._DRAW_RECT_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(152,32,true);
			DrawRectCmdNative._DRAW_RECT_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawRectCmdNative._DRAW_RECT_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);
			DrawRectCmdNative._DRAW_RECT_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);
			DrawRectCmdNative._DRAW_RECT_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawRectCmdNative._DRAW_RECT_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawRectCmdNative._DRAW_RECT_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawRectCmdNative._DRAW_RECT_CMD_ENCODER_.setRectMeshByParamData(DrawRectCmdNative._PARAM_RECT_NUM_POS_*4,DrawRectCmdNative._PARAM_VB_POS_ *4,DrawRectCmdNative._PARAM_VB_SIZE_POS_ *4);
			DrawRectCmdNative._DRAW_RECT_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawRectCmdNative._DRAW_RECT_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawRectCmdNative._DRAW_RECT_CMD_ENCODER_);
		}
		if (!cmd._paramData){
			cmd._paramData=/*__JS__ */new ParamData(73*4,true);
			}{
			cmd._x=x;
			cmd._y=y;
			cmd._width=width;
			cmd._height=height;
			cmd._fillColor=fillColor;
			cmd._lineColor=lineColor;
			cmd._lineWidth=lineWidth;
			var c1=ColorUtils.create(fillColor);
			var nFillColor=c1.numColor;
			var _fb=cmd._paramData._float32Data;
			var _i32b=cmd._paramData._int32Data;
			_i32b[DrawRectCmdNative._PARAM_RECT_NUM_POS_]=1;
			_i32b[DrawRectCmdNative._PARAM_VB_SIZE_POS_]=24 *4;
			var ix=DrawRectCmdNative._PARAM_VB_POS_;
			_fb[ix++]=x;_fb[ix++]=y;_fb[ix++]=0;_fb[ix++]=0;_i32b[ix++]=nFillColor;_fb[ix++]=0xffffffff;
			_fb[ix++]=x+width;_fb[ix++]=y;_fb[ix++]=0;_fb[ix++]=0;_i32b[ix++]=nFillColor;_fb[ix++]=0xffffffff;
			_fb[ix++]=x+width;_fb[ix++]=y+height;_fb[ix++]=0;_fb[ix++]=0;_i32b[ix++]=nFillColor;_fb[ix++]=0xffffffff;
			_fb[ix++]=x;_fb[ix++]=y+height;_fb[ix++]=0;_fb[ix++]=0;_i32b[ix++]=nFillColor;_fb[ix++]=0xffffffff;
			cmd._linePoints.push(x);cmd._linePoints.push(y);
			cmd._linePoints.push(x+width);cmd._linePoints.push(y);
			cmd._linePoints.push(x+width);cmd._linePoints.push(y+height);
			cmd._linePoints.push(x);cmd._linePoints.push(y+height);
			cmd._linePoints.push(x);cmd._linePoints.push(y-lineWidth/ 2)
			if (lineColor){
				BasePoly.createLine2(cmd._linePoints,cmd._line_ibArray,lineWidth,0,cmd._line_vbArray,false);
				cmd._line_vertNum=cmd._linePoints.length;
				_i32b[DrawRectCmdNative._PARAM_LINE_VB_SIZE_POS_]=30 *4;
				var c2=ColorUtils.create(lineColor);
				var nLineColor=c2.numColor;
				ix=DrawRectCmdNative._PARAM_LINE_VB_POS_;
				for (var i=0;i < cmd._line_vertNum;i++){
					_fb[ix++]=cmd._line_vbArray[i *2];_fb[ix++]=cmd._line_vbArray[i *2+1];_i32b[ix++]=nLineColor;
				}
				_i32b[DrawRectCmdNative._PARAM_LINE_IB_SIZE_POS_]=cmd._line_ibArray.length *2;
				var _i16b=cmd._paramData._int16Data;
				ix=DrawRectCmdNative._PARAM_LINE_IB_POS_*2;
				for (var ii=0;ii < cmd._line_ibArray.length;ii++){
					_i16b[ix++]=cmd._line_ibArray[ii];
				}
			}
			else{
				cmd._lineWidth=1;
				var temp_lineColor="#ffffff";
				BasePoly.createLine2(cmd._linePoints,cmd._line_ibArray,cmd._lineWidth,0,cmd._line_vbArray,false);
				cmd._line_vertNum=cmd._linePoints.length;
				_i32b[DrawRectCmdNative._PARAM_LINE_VB_SIZE_POS_]=30 *4;
				c2=ColorUtils.create(temp_lineColor);
				nLineColor=c2.numColor;
				ix=DrawRectCmdNative._PARAM_LINE_VB_POS_;
				for (i=0;i < cmd._line_vertNum;i++){
					_fb[ix++]=cmd._line_vbArray[i *2];_fb[ix++]=cmd._line_vbArray[i *2+1];_i32b[ix++]=nLineColor;
				}
				_i32b[DrawRectCmdNative._PARAM_LINE_IB_SIZE_POS_]=cmd._line_ibArray.length *2;
				_i16b=cmd._paramData._int16Data;
				ix=DrawRectCmdNative._PARAM_LINE_IB_POS_*2;
				for (ii=0;ii < cmd._line_ibArray.length;ii++){
					_i16b[ix++]=cmd._line_ibArray[ii];
				}
			}
			_i32b[DrawRectCmdNative._PARAM_LINE_VB_OFFSET_POS_]=0;
			_i32b[DrawRectCmdNative._PARAM_LINE_IB_OFFSET_POS_]=0;
			_i32b[DrawRectCmdNative._PARAM_LINE_IBELEMENT_OFFSET_POS_]=0;
			LayaGL.syncBufferToRenderThread(cmd._paramData);
		}
		if (lineColor){
			cmd._cmdCurrentPos=cmd._graphicsCmdEncoder.useCommandEncoder(DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		}
		else{
			cmd._cmdCurrentPos=cmd._graphicsCmdEncoder.useCommandEncoder(DrawRectCmdNative._DRAW_RECT_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		}
		LayaGL.syncBufferToRenderThread(cmd._graphicsCmdEncoder);
		return cmd;
	}

	DrawRectCmdNative.ID="DrawRect";
	DrawRectCmdNative._DRAW_RECT_CMD_ENCODER_=null;
	DrawRectCmdNative._DRAW_RECT_LINE_CMD_ENCODER_=null;
	DrawRectCmdNative._PARAM_RECT_NUM_POS_=0;
	DrawRectCmdNative._PARAM_VB_SIZE_POS_=1;
	DrawRectCmdNative._PARAM_VB_POS_=2;
	DrawRectCmdNative._PARAM_LINE_VB_SIZE_POS_=26;
	DrawRectCmdNative._PARAM_LINE_VB_POS_=27;
	DrawRectCmdNative._PARAM_LINE_IB_SIZE_POS_=57;
	DrawRectCmdNative._PARAM_LINE_IB_POS_=58;
	DrawRectCmdNative._PARAM_LINE_VB_OFFSET_POS_=70;
	DrawRectCmdNative._PARAM_LINE_IB_OFFSET_POS_=71;
	DrawRectCmdNative._PARAM_LINE_IBELEMENT_OFFSET_POS_=72;
	return DrawRectCmdNative;
})()


/**
*@private
*<code>ShaderCompile</code> 类用于实现Shader编译。
*/
//class laya.webgl.utils.ShaderCompile
var ShaderCompile=(function(){
	function ShaderCompile(vs,ps,nameMap,defs){
		//this._nameMap=null;
		//this._VS=null;
		//this._PS=null;
		var _$this=this;
		function _compile (script){
			var includefiles=[];
			var top=new ShaderNode(includefiles);
			_$this._compileToTree(top,script.split('\n'),0,includefiles,defs);
			return top;
		};
		var startTime=Browser.now();
		this._VS=_compile(vs);
		this._PS=_compile(ps);
		this._nameMap=nameMap;
		if ((Browser.now()-startTime)> 2)
			console.log("ShaderCompile use time:"+(Browser.now()-startTime)+"  size:"+vs.length+"/"+ps.length);
	}

	__class(ShaderCompile,'laya.webgl.utils.ShaderCompile');
	var __proto=ShaderCompile.prototype;
	/**
	*@private
	*/
	__proto._compileToTree=function(parent,lines,start,includefiles,defs){
		var node,preNode;
		var text,name,fname;
		var ofs=0,words,noUseNode;
		var i=0,n=0,j=0;
		for (i=start;i < lines.length;i++){
			text=lines[i];
			if (text.length < 1)continue ;
			ofs=text.indexOf("//");
			if (ofs===0)continue ;
			if (ofs >=0)text=text.substr(0,ofs);
			node=noUseNode || new ShaderNode(includefiles);
			noUseNode=null;
			node.text=text;
			node.noCompile=true;
			if ((ofs=text.indexOf("#"))>=0){
				name="#";
				for (j=ofs+1,n=text.length;j < n;j++){
					var c=text.charAt(j);
					if (c===' ' || c==='\t' || c==='?')break ;
					name+=c;
				}
				node.name=name;
				switch (name){
					case "#ifdef":
					case "#ifndef":
						node.src=text;
						node.noCompile=text.match(/[!&|()=<>]/)!=null;
						if (!node.noCompile){
							words=text.replace(/^\s*/,'').split(/\s+/);
							node.setCondition(words[1],name==="#ifdef" ? 1 :2);
							node.text="//"+node.text;
							}else {
							console.log("function():Boolean{return "+text.substr(ofs+node.name.length)+"}");
						}
						node.setParent(parent);
						parent=node;
						if (defs){
							words=text.substr(j).split(ShaderCompile._splitToWordExps3);
							for (j=0;j < words.length;j++){
								text=words[j];
								text.length && (defs[text]=true);
							}
						}
						continue ;
					case "#if":
						node.src=text;
						node.noCompile=true;
						node.setParent(parent);
						parent=node;
						if (defs){
							words=text.substr(j).split(ShaderCompile._splitToWordExps3);
							for (j=0;j < words.length;j++){
								text=words[j];
								text.length && text !="defined" && (defs[text]=true);
							}
						}
						continue ;
					case "#else":
						node.src=text;
						parent=parent.parent;
						preNode=parent.childs[parent.childs.length-1];
						node.noCompile=preNode.noCompile;
						if (!node.noCompile){
							node.condition=preNode.condition;
							node.conditionType=preNode.conditionType==1 ? 2 :1;
							node.text="//"+node.text+" "+preNode.text+" "+node.conditionType;
						}
						node.setParent(parent);
						parent=node;
						continue ;
					case "#endif":
						parent=parent.parent;
						preNode=parent.childs[parent.childs.length-1];
						node.noCompile=preNode.noCompile;
						if (!node.noCompile){
							node.text="//"+node.text;
						}
						node.setParent(parent);
						continue ;
					case "#include":
						words=ShaderCompile.splitToWords(text,null);
						var inlcudeFile=ShaderCompile.includes[words[1]];
						if (!inlcudeFile){
							throw "ShaderCompile error no this include file:"+words[1];
						}
						if ((ofs=words[0].indexOf("?"))< 0){
							node.setParent(parent);
							text=inlcudeFile.getWith(words[2]=='with' ? words[3] :null);
							this._compileToTree(node,text.split('\n'),0,includefiles,defs);
							node.text="";
							continue ;
						}
						node.setCondition(words[0].substr(ofs+1),1);
						node.text=inlcudeFile.getWith(words[2]=='with' ? words[3] :null);
						break ;
					case "#import":
						words=ShaderCompile.splitToWords(text,null);
						fname=words[1];
						includefiles.push({node:node,file:ShaderCompile.includes[fname],ofs:node.text.length});
						continue ;
					}
				}else {
				preNode=parent.childs[parent.childs.length-1];
				if (preNode && !preNode.name){
					includefiles.length > 0 && ShaderCompile.splitToWords(text,preNode);
					noUseNode=node;
					preNode.text+="\n"+text;
					continue ;
				}
				includefiles.length > 0 && ShaderCompile.splitToWords(text,node);
			}
			node.setParent(parent);
		}
	}

	__proto.createShader=function(define,shaderName,createShader,bindAttrib){
		var defMap={};
		var defineStr="";
		if (define){
			for (var i in define){
				defineStr+="#define "+i+"\n";
				defMap[i]=true;
			}
		};
		var vs=this._VS.toscript(defMap,[]);
		var ps=this._PS.toscript(defMap,[]);
		return (createShader || Shader.create)(defineStr+vs.join('\n'),defineStr+ps.join('\n'),shaderName,this._nameMap,bindAttrib);
	}

	ShaderCompile._parseOne=function(attributes,uniforms,words,i,word,b){
		var one={type:ShaderCompile.shaderParamsMap[words[i+1]],name:words[i+2],size:isNaN(parseInt(words[i+3]))? 1 :parseInt(words[i+3])};
		if (b){
			if (word=="attribute"){
				attributes.push(one);
				}else {
				uniforms.push(one);
			}
		}
		if (words[i+3]==':'){
			one.type=words[i+4];
			i+=2;
		}
		i+=2;
		return i;
	}

	ShaderCompile.addInclude=function(fileName,txt){
		if (!txt || txt.length===0)
			throw new Error("add shader include file err:"+fileName);
		if (ShaderCompile.includes[fileName])
			throw new Error("add shader include file err, has add:"+fileName);
		ShaderCompile.includes[fileName]=new InlcudeFile(txt);
	}

	ShaderCompile.preGetParams=function(vs,ps){
		var text=[vs,ps];
		var result={};
		var attributes=[];
		var uniforms=[];
		var definesInfo={};
		var definesName=[];
		result.attributes=attributes;
		result.uniforms=uniforms;
		result.defines=definesInfo;
		var i=0,n=0,one;
		for (var s=0;s < 2;s++){
			text[s]=text[s].replace(ShaderCompile._removeAnnotation,"");
			var words=text[s].match(ShaderCompile._reg);
			var tempelse;
			for (i=0,n=words.length;i < n;i++){
				var word=words[i];
				if (word !="attribute" && word !="uniform"){
					if (word=="#define"){
						word=words[++i];
						definesName[word]=1;
						continue ;
						}else if (word=="#ifdef"){
						tempelse=words[++i];
						var def=definesInfo[tempelse]=definesInfo[tempelse] || [];
						for (i++;i < n;i++){
							word=words[i];
							if (word !="attribute" && word !="uniform"){
								if (word=="#else"){
									for (i++;i < n;i++){
										word=words[i];
										if (word !="attribute" && word !="uniform"){
											if (word=="#endif"){
												break ;
											}
											continue ;
										}
										i=ShaderCompile._parseOne(attributes,uniforms,words,i,word,!definesName[tempelse]);
									}
								}
								continue ;
							}
							i=ShaderCompile._parseOne(attributes,uniforms,words,i,word,definesName[tempelse]);
						}
					}
					continue ;
				}
				i=ShaderCompile._parseOne(attributes,uniforms,words,i,word,true);
			}
		}
		return result;
	}

	ShaderCompile.splitToWords=function(str,block){
		var out=[];
		var c;
		var ofs=-1;
		var word;
		for (var i=0,n=str.length;i < n;i++){
			c=str.charAt(i);
			if (" \t=+-*/&%!<>()'\",;".indexOf(c)>=0){
				if (ofs >=0 && (i-ofs)> 1){
					word=str.substr(ofs,i-ofs);
					out.push(word);
				}
				if (c=='"' || c=="'"){
					var ofs2=str.indexOf(c,i+1);
					if (ofs2 < 0){
						throw "Sharder err:"+str;
					}
					out.push(str.substr(i+1,ofs2-i-1));
					i=ofs2;
					ofs=-1;
					continue ;
				}
				if (c=='(' && block && out.length > 0){
					word=out[out.length-1]+";";
					if ("vec4;main;".indexOf(word)< 0)
						block.useFuns+=word;
				}
				ofs=-1;
				continue ;
			}
			if (ofs < 0)ofs=i;
		}
		if (ofs < n && (n-ofs)> 1){
			word=str.substr(ofs,n-ofs);
			out.push(word);
		}
		return out;
	}

	ShaderCompile.IFDEF_NO=0;
	ShaderCompile.IFDEF_YES=1;
	ShaderCompile.IFDEF_ELSE=2;
	ShaderCompile.IFDEF_PARENT=3;
	ShaderCompile._removeAnnotation=new RegExp("(/\\*([^*]|[\\r\\\n]|(\\*+([^*/]|[\\r\\n])))*\\*+/)|(//.*)","g");
	ShaderCompile._reg=new RegExp("(\".*\")|('.*')|([#\\w\\*-\\.+/()=<>{}\\\\]+)|([,;:\\\\])","g");
	ShaderCompile._splitToWordExps=new RegExp("[(\".*\")]+|[('.*')]+|([ \\t=\\+\\-*/&%!<>!%\(\),;])","g");
	ShaderCompile.includes={};
	__static(ShaderCompile,
	['shaderParamsMap',function(){return this.shaderParamsMap={"float":/*laya.webgl.WebGLContext.FLOAT*/0x1406,"int":/*laya.webgl.WebGLContext.INT*/0x1404,"bool":/*laya.webgl.WebGLContext.BOOL*/0x8B56,"vec2":/*laya.webgl.WebGLContext.FLOAT_VEC2*/0x8B50,"vec3":/*laya.webgl.WebGLContext.FLOAT_VEC3*/0x8B51,"vec4":/*laya.webgl.WebGLContext.FLOAT_VEC4*/0x8B52,"ivec2":/*laya.webgl.WebGLContext.INT_VEC2*/0x8B53,"ivec3":/*laya.webgl.WebGLContext.INT_VEC3*/0x8B54,"ivec4":/*laya.webgl.WebGLContext.INT_VEC4*/0x8B55,"bvec2":/*laya.webgl.WebGLContext.BOOL_VEC2*/0x8B57,"bvec3":/*laya.webgl.WebGLContext.BOOL_VEC3*/0x8B58,"bvec4":/*laya.webgl.WebGLContext.BOOL_VEC4*/0x8B59,"mat2":/*laya.webgl.WebGLContext.FLOAT_MAT2*/0x8B5A,"mat3":/*laya.webgl.WebGLContext.FLOAT_MAT3*/0x8B5B,"mat4":/*laya.webgl.WebGLContext.FLOAT_MAT4*/0x8B5C,"sampler2D":/*laya.webgl.WebGLContext.SAMPLER_2D*/0x8B5E,"samplerCube":/*laya.webgl.WebGLContext.SAMPLER_CUBE*/0x8B60};},'_splitToWordExps3',function(){return this._splitToWordExps3=new RegExp("[ \\t=\\+\\-*/&%!<>!%\(\),;\\|]","g");}
	]);
	return ShaderCompile;
})()


//class laya.layagl.cmdNative.FillTextCmdNative
var FillTextCmdNative=(function(){
	function FillTextCmdNative(){
		this._graphicsCmdEncoder=null;
		this._index=0;
		this._text=null;
		this._x=NaN;
		this._y=NaN;
		this._font=null;
		this._color=null;
		this._textAlign=null;
		this._draw_texture_cmd_encoder_=LayaGL.instance.createCommandEncoder(64,32,true);
	}

	__class(FillTextCmdNative,'laya.layagl.cmdNative.FillTextCmdNative');
	var __proto=FillTextCmdNative.prototype;
	__proto.createFillText=function(cbuf,text,x,y,font,color,textAlign){
		var c1=ColorUtils.create(color);
		var nColor=c1.numColor;
		var ctx={};
		ctx._curMat=new Matrix();
		ctx._italicDeg=0;
		ctx._drawTextureUseColor=0xffffffff;
		ctx.fillStyle=color;
		ctx._fillColor=0xffffffff;
		ctx.setFillColor=function (color){
			ctx._fillColor=color;
		}
		ctx.getFillColor=function (){
			return ctx._fillColor;
		}
		ctx.mixRGBandAlpha=function (value){
			return value;
		}
		ctx._drawTextureM=function (tex,x,y,width,height,m,alpha,uv){
			cbuf.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			cbuf.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);
			cbuf.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);
			cbuf.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			cbuf.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			cbuf.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			cbuf.uniformTexture(3,/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0,tex.bitmap._glTexture);
			var buffer=new Float32Array([
			x,y,uv[0],uv[1],0,0,
			x+width,y,uv[2],uv[3],0,0,
			x+width,y+height,uv[4],uv[5],0,0,
			x,y+height,uv[6],uv[7],0,0]);
			var i32=new Int32Array(buffer.buffer);
			i32[4]=i32[10]=i32[16]=i32[22]=0xffffffff;
			i32[5]=i32[11]=i32[17]=i32[23]=0xffffffff;
			cbuf.setRectMesh(1,buffer,buffer.length);
			cbuf.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			cbuf.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(cbuf);
		}
		FillTextCmdNative.cbook.filltext_native(ctx,text,null,x,y,font,color,null,0,textAlign);
	}

	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._graphicsCmdEncoder=null;
		Pool.recover("FillTextCmd",this);
	}

	__getset(0,__proto,'text',function(){
		return this._text;
		},function(value){
		var cbuf=this._draw_texture_cmd_encoder_;
		cbuf.clearEncoding();
		this._text=value;
		this.createFillText(cbuf,this._text,this._x,this._y,this._font,this._color,this._textAlign);
		LayaGL.syncBufferToRenderThread(cbuf);
	});

	__getset(0,__proto,'cmdID',function(){
		return "FillText";
	});

	__getset(0,__proto,'font',function(){
		return this._font;
		},function(value){
		var cbuf=this._draw_texture_cmd_encoder_;
		cbuf.clearEncoding();
		this._font=value;
		this.createFillText(cbuf,this._text,this._x,this._y,this._font,this._color,this._textAlign);
		LayaGL.syncBufferToRenderThread(cbuf);
	});

	__getset(0,__proto,'color',function(){
		return this._color;
		},function(value){
		var cbuf=this._draw_texture_cmd_encoder_;
		cbuf.clearEncoding();
		this._color=value;
		this.createFillText(cbuf,this._text,this._x,this._y,this._font,this._color,this._textAlign);
		LayaGL.syncBufferToRenderThread(cbuf);
	});

	__getset(0,__proto,'textAlign',function(){
		return this._textAlign;
		},function(value){
		var cbuf=this._draw_texture_cmd_encoder_;
		cbuf.clearEncoding();
		this._textAlign=value;
		this.createFillText(cbuf,this._text,this._x,this._y,this._font,this._color,this._textAlign);
		LayaGL.syncBufferToRenderThread(cbuf);
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		var cbuf=this._draw_texture_cmd_encoder_;
		cbuf.clearEncoding();
		this._x=value;
		this.createFillText(cbuf,this._text,this._x,this._y,this._font,this._color,this._textAlign);
		LayaGL.syncBufferToRenderThread(cbuf);
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		var cbuf=this._draw_texture_cmd_encoder_;
		cbuf.clearEncoding();
		this._y=value;
		this.createFillText(cbuf,this._text,this._x,this._y,this._font,this._color,this._textAlign);
		LayaGL.syncBufferToRenderThread(cbuf);
	});

	FillTextCmdNative.create=function(text,x,y,font,color,textAlign){
		if (!FillTextCmdNative.cbook)new Error('Error:charbook not create!');
		var cmd=Pool.getItemByClass("FillTextCmd",FillTextCmdNative);
		var cbuf=cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		cmd._text=text;
		cmd._x=x;
		cmd._y=y;
		cmd._font=font;
		cmd._color=color;
		cmd._textAlign=textAlign;
		cmd._draw_texture_cmd_encoder_.clearEncoding();
		cmd.createFillText(cmd._draw_texture_cmd_encoder_,text,x,y,font,color,textAlign);
		LayaGL.syncBufferToRenderThread(cmd._draw_texture_cmd_encoder_);
		cbuf.useCommandEncoder(cmd._draw_texture_cmd_encoder_.getPtrID(),-1,-1);
		LayaGL.syncBufferToRenderThread(cbuf);
		return cmd;
	}

	FillTextCmdNative.ID="FillText";
	__static(FillTextCmdNative,
	['cbook',function(){return this.cbook=Laya['textRender'];}
	]);
	return FillTextCmdNative;
})()


//class laya.webgl.WebGLContext
var WebGLContext=(function(){
	function WebGLContext(){}
	__class(WebGLContext,'laya.webgl.WebGLContext');
	var __proto=WebGLContext.prototype;
	__proto.getContextAttributes=function(){return null;}
	__proto.isContextLost=function(){}
	__proto.getSupportedExtensions=function(){return null;}
	__proto.getExtension=function(name){return null;}
	__proto.activeTexture=function(texture){}
	__proto.attachShader=function(program,shader){}
	__proto.bindAttribLocation=function(program,index,name){}
	__proto.bindBuffer=function(target,buffer){}
	__proto.bindFramebuffer=function(target,framebuffer){}
	__proto.bindRenderbuffer=function(target,renderbuffer){}
	__proto.bindTexture=function(target,texture){}
	__proto.useTexture=function(value){}
	__proto.blendColor=function(red,green,blue,alpha){}
	__proto.blendEquation=function(mode){}
	__proto.blendEquationSeparate=function(modeRGB,modeAlpha){}
	__proto.blendFunc=function(sfactor,dfactor){}
	__proto.blendFuncSeparate=function(srcRGB,dstRGB,srcAlpha,dstAlpha){}
	__proto.bufferData=function(target,size,usage){}
	__proto.bufferSubData=function(target,offset,data){}
	__proto.checkFramebufferStatus=function(target){return null;}
	__proto.clear=function(mask){}
	__proto.clearColor=function(red,green,blue,alpha){}
	__proto.clearDepth=function(depth){}
	__proto.clearStencil=function(s){}
	__proto.colorMask=function(red,green,blue,alpha){}
	__proto.compileShader=function(shader){}
	__proto.copyTexImage2D=function(target,level,internalformat,x,y,width,height,border){}
	__proto.copyTexSubImage2D=function(target,level,xoffset,yoffset,x,y,width,height){}
	__proto.createBuffer=function(){}
	__proto.createFramebuffer=function(){}
	__proto.createProgram=function(){}
	__proto.createRenderbuffer=function(){}
	__proto.createShader=function(type){}
	__proto.createTexture=function(){return null}
	__proto.cullFace=function(mode){}
	__proto.deleteBuffer=function(buffer){}
	__proto.deleteFramebuffer=function(framebuffer){}
	__proto.deleteProgram=function(program){}
	__proto.deleteRenderbuffer=function(renderbuffer){}
	__proto.deleteShader=function(shader){}
	__proto.deleteTexture=function(texture){}
	__proto.depthFunc=function(func){}
	__proto.depthMask=function(flag){}
	__proto.depthRange=function(zNear,zFar){}
	__proto.detachShader=function(program,shader){}
	__proto.disable=function(cap){}
	__proto.disableVertexAttribArray=function(index){}
	__proto.drawArrays=function(mode,first,count){}
	__proto.drawElements=function(mode,count,type,offset){}
	__proto.enable=function(cap){}
	__proto.enableVertexAttribArray=function(index){}
	__proto.finish=function(){}
	__proto.flush=function(){}
	__proto.framebufferRenderbuffer=function(target,attachment,renderbuffertarget,renderbuffer){}
	__proto.framebufferTexture2D=function(target,attachment,textarget,texture,level){}
	__proto.frontFace=function(mode){return null;}
	__proto.generateMipmap=function(target){return null;}
	__proto.getActiveAttrib=function(program,index){return null;}
	__proto.getActiveUniform=function(program,index){return null;}
	__proto.getAttribLocation=function(program,name){return 0;}
	__proto.getParameter=function(pname){return null;}
	__proto.getBufferParameter=function(target,pname){return null;}
	__proto.getError=function(){return null;}
	__proto.getFramebufferAttachmentParameter=function(target,attachment,pname){}
	__proto.getProgramParameter=function(program,pname){return 0;}
	__proto.getProgramInfoLog=function(program){return null;}
	__proto.getRenderbufferParameter=function(target,pname){return null;}
	__proto.getShaderPrecisionFormat=function(__arg){
		var arg=arguments;return null;}
	__proto.getShaderParameter=function(shader,pname){}
	__proto.getShaderInfoLog=function(shader){return null;}
	__proto.getShaderSource=function(shader){return null;}
	__proto.getTexParameter=function(target,pname){}
	__proto.getUniform=function(program,location){}
	__proto.getUniformLocation=function(program,name){return null;}
	__proto.getVertexAttrib=function(index,pname){return null;}
	__proto.getVertexAttribOffset=function(index,pname){return null;}
	__proto.hint=function(target,mode){}
	__proto.isBuffer=function(buffer){}
	__proto.isEnabled=function(cap){}
	__proto.isFramebuffer=function(framebuffer){}
	__proto.isProgram=function(program){}
	__proto.isRenderbuffer=function(renderbuffer){}
	__proto.isShader=function(shader){}
	__proto.isTexture=function(texture){}
	__proto.lineWidth=function(width){}
	__proto.linkProgram=function(program){}
	__proto.pixelStorei=function(pname,param){}
	__proto.polygonOffset=function(factor,units){}
	__proto.readPixels=function(x,y,width,height,format,type,pixels){}
	__proto.renderbufferStorage=function(target,internalformat,width,height){}
	__proto.sampleCoverage=function(value,invert){}
	__proto.scissor=function(x,y,width,height){}
	__proto.shaderSource=function(shader,source){}
	__proto.stencilFunc=function(func,ref,mask){}
	__proto.stencilFuncSeparate=function(face,func,ref,mask){}
	__proto.stencilMask=function(mask){}
	__proto.stencilMaskSeparate=function(face,mask){}
	__proto.stencilOp=function(fail,zfail,zpass){}
	__proto.stencilOpSeparate=function(face,fail,zfail,zpass){}
	__proto.texImage2D=function(__args){}
	__proto.texParameterf=function(target,pname,param){}
	__proto.texParameteri=function(target,pname,param){}
	__proto.texSubImage2D=function(__args){}
	__proto.uniform1f=function(location,x){}
	__proto.uniform1fv=function(location,v){}
	__proto.uniform1i=function(location,x){}
	__proto.uniform1iv=function(location,v){}
	__proto.uniform2f=function(location,x,y){}
	__proto.uniform2fv=function(location,v){}
	__proto.uniform2i=function(location,x,y){}
	__proto.uniform2iv=function(location,v){}
	__proto.uniform3f=function(location,x,y,z){}
	__proto.uniform3fv=function(location,v){}
	__proto.uniform3i=function(location,x,y,z){}
	__proto.uniform3iv=function(location,v){}
	__proto.uniform4f=function(location,x,y,z,w){}
	__proto.uniform4fv=function(location,v){}
	__proto.uniform4i=function(location,x,y,z,w){}
	__proto.uniform4iv=function(location,v){}
	__proto.uniformMatrix2fv=function(location,transpose,value){}
	__proto.uniformMatrix3fv=function(location,transpose,value){}
	__proto.uniformMatrix4fv=function(location,transpose,value){}
	__proto.useProgram=function(program){}
	__proto.validateProgram=function(program){}
	__proto.vertexAttrib1f=function(indx,x){}
	__proto.vertexAttrib1fv=function(indx,values){}
	__proto.vertexAttrib2f=function(indx,x,y){}
	__proto.vertexAttrib2fv=function(indx,values){}
	__proto.vertexAttrib3f=function(indx,x,y,z){}
	__proto.vertexAttrib3fv=function(indx,values){}
	__proto.vertexAttrib4f=function(indx,x,y,z,w){}
	__proto.vertexAttrib4fv=function(indx,values){}
	__proto.vertexAttribPointer=function(indx,size,type,normalized,stride,offset){}
	__proto.viewport=function(x,y,width,height){}
	__proto.configureBackBuffer=function(width,height,antiAlias,enableDepthAndStencil,wantsBestResolution){
		(enableDepthAndStencil===void 0)&& (enableDepthAndStencil=true);
		(wantsBestResolution===void 0)&& (wantsBestResolution=false);
	}

	__proto.compressedTexImage2D=function(__args){}
	//TODO:coverage
	__proto.createVertexArray=function(){
		throw "not implemented";
	}

	//TODO:coverage
	__proto.bindVertexArray=function(vao){
		throw "not implemented";
	}

	//TODO:coverage
	__proto.deleteVertexArray=function(vao){
		throw "not implemented";
	}

	//TODO:coverage
	__proto.isVertexArray=function(vao){
		throw "not implemented";
	}

	WebGLContext.__init__=function(gl){
		WebGLContext.__init_native();
		laya.webgl.WebGLContext._checkExtensions(gl);
		if (!WebGL._isWebGL2){
			VertexArrayObject;
			if (window._setupVertexArrayObject){
				if (Browser.onMiniGame||Browser.onLimixiu)
					window._forceSetupVertexArrayObject(gl);
				else
				window._setupVertexArrayObject(gl);
			};
			var ext=((gl).rawgl || gl).getExtension("OES_vertex_array_object");
			if (ext){
				console.log("EXT:webgl support OES_vertex_array_object！");
				var glContext=gl;
				glContext.createVertexArray=function (){return ext.createVertexArrayOES();};
				glContext.bindVertexArray=function (vao){ext.bindVertexArrayOES(vao);};
				glContext.deleteVertexArray=function (vao){ext.deleteVertexArrayOES(vao);};
				glContext.isVertexArray=function (vao){ext.isVertexArrayOES(vao);};
			}
		}
	}

	WebGLContext._getExtension=function(gl,name){
		var prefixes=WebGLContext._extentionVendorPrefixes;
		for (var k in prefixes){
			var ext=gl.getExtension(prefixes[k]+name);
			if (ext)
				return ext;
		}
		return null;
	}

	WebGLContext._checkExtensions=function(gl){
		WebGLContext._extTextureFilterAnisotropic=WebGLContext._getExtension(gl,"EXT_texture_filter_anisotropic");
		WebGLContext._compressedTextureS3tc=WebGLContext._getExtension(gl,"WEBGL_compressed_texture_s3tc");
		WebGLContext._compressedTexturePvrtc=WebGLContext._getExtension(gl,"WEBGL_compressed_texture_pvrtc");
		WebGLContext._compressedTextureEtc1=WebGLContext._getExtension(gl,"WEBGL_compressed_texture_etc1");
		return null;
	}

	WebGLContext.__init_native=function(){
		if (!Render.isConchApp)return;
		var webGLContext=WebGLContext;
		webGLContext.useProgram=webGLContext.useProgramForNative;
		webGLContext.activeTexture=webGLContext.activeTextureForNative;
		webGLContext.bindTexture=webGLContext.bindTextureForNative;
		webGLContext.bindVertexArray=webGLContext.bindVertexArrayForNative;
		webGLContext.setDepthTest=webGLContext.setDepthTestForNative;
		webGLContext.setDepthMask=webGLContext.setDepthMaskForNative;
		webGLContext.setDepthFunc=webGLContext.setDepthFuncForNative;
		webGLContext.setBlend=webGLContext.setBlendForNative;
		webGLContext.setBlendFunc=webGLContext.setBlendFuncForNative;
		webGLContext.setCullFace=webGLContext.setCullFaceForNative;
		webGLContext.setFrontFace=webGLContext.setFrontFaceForNative;
		webGLContext._checkExtensions(Browser.window.LayaGLContext.instance);
	}

	WebGLContext.useProgram=function(gl,program){
		if (WebGLContext._useProgram===program)
			return false;
		gl.useProgram(program);
		WebGLContext._useProgram=program;
		return true;
	}

	WebGLContext.setDepthTest=function(gl,value){
		value!==WebGLContext._depthTest && (WebGLContext._depthTest=value,value?gl.enable(/*CLASS CONST:laya.webgl.WebGLContext.DEPTH_TEST*/0x0B71):gl.disable(/*CLASS CONST:laya.webgl.WebGLContext.DEPTH_TEST*/0x0B71));
	}

	WebGLContext.setDepthMask=function(gl,value){
		value!==WebGLContext._depthMask && (WebGLContext._depthMask=value,gl.depthMask(value));
	}

	WebGLContext.setDepthFunc=function(gl,value){
		value!==WebGLContext._depthFunc && (WebGLContext._depthFunc=value,gl.depthFunc(value));
	}

	WebGLContext.setBlend=function(gl,value){
		value!==WebGLContext._blend && (WebGLContext._blend=value,value?gl.enable(/*CLASS CONST:laya.webgl.WebGLContext.BLEND*/0x0BE2):gl.disable(/*CLASS CONST:laya.webgl.WebGLContext.BLEND*/0x0BE2));
	}

	WebGLContext.setBlendFunc=function(gl,sFactor,dFactor){
		(sFactor!==WebGLContext._sFactor||dFactor!==WebGLContext._dFactor)&& (WebGLContext._sFactor=sFactor,WebGLContext._dFactor=dFactor,gl.blendFunc(sFactor,dFactor));
	}

	WebGLContext.setCullFace=function(gl,value){
		value!==WebGLContext._cullFace && (WebGLContext._cullFace=value,value?gl.enable(/*CLASS CONST:laya.webgl.WebGLContext.CULL_FACE*/0x0B44):gl.disable(/*CLASS CONST:laya.webgl.WebGLContext.CULL_FACE*/0x0B44));
	}

	WebGLContext.setFrontFace=function(gl,value){
		value!==WebGLContext._frontFace && (WebGLContext._frontFace=value,gl.frontFace(value));
	}

	WebGLContext.activeTexture=function(gl,textureID){
		if (WebGLContext._activedTextureID!==textureID){
			gl.activeTexture(textureID);
			WebGLContext._activedTextureID=textureID;
		}
	}

	WebGLContext.bindTexture=function(gl,target,texture){
		if (WebGLContext._activeTextures[WebGLContext._activedTextureID-0x84C0]!==texture){
			gl.bindTexture(target,texture);
			WebGLContext._activeTextures[WebGLContext._activedTextureID-0x84C0]=texture;
		}
	}

	WebGLContext.useProgramForNative=function(gl,program){
		gl.useProgram(program);
		return true;
	}

	WebGLContext.setDepthTestForNative=function(gl,value){
		if (value)gl.enable(/*CLASS CONST:laya.webgl.WebGLContext.DEPTH_TEST*/0x0B71);
		else gl.disable(/*CLASS CONST:laya.webgl.WebGLContext.DEPTH_TEST*/0x0B71);
	}

	WebGLContext.setDepthMaskForNative=function(gl,value){
		gl.depthMask(value);
	}

	WebGLContext.setDepthFuncForNative=function(gl,value){
		gl.depthFunc(value);
	}

	WebGLContext.setBlendForNative=function(gl,value){
		if (value)gl.enable(/*CLASS CONST:laya.webgl.WebGLContext.BLEND*/0x0BE2);
		else gl.disable(/*CLASS CONST:laya.webgl.WebGLContext.BLEND*/0x0BE2);
	}

	WebGLContext.setBlendFuncForNative=function(gl,sFactor,dFactor){
		gl.blendFunc(sFactor,dFactor);
	}

	WebGLContext.setCullFaceForNative=function(gl,value){
		if (value)gl.enable(/*CLASS CONST:laya.webgl.WebGLContext.CULL_FACE*/0x0B44)
			else gl.disable(/*CLASS CONST:laya.webgl.WebGLContext.CULL_FACE*/0x0B44);
	}

	WebGLContext.setFrontFaceForNative=function(gl,value){
		gl.frontFace(value);
	}

	WebGLContext.activeTextureForNative=function(gl,textureID){
		gl.activeTexture(textureID);
	}

	WebGLContext.bindTextureForNative=function(gl,target,texture){
		gl.bindTexture(target,texture);
	}

	WebGLContext.bindVertexArrayForNative=function(gl,vertexArray){
		/*__JS__ */gl.bindVertexArray(vertexArray);
	}

	WebGLContext.DEPTH_BUFFER_BIT=0x00000100;
	WebGLContext.STENCIL_BUFFER_BIT=0x00000400;
	WebGLContext.COLOR_BUFFER_BIT=0x00004000;
	WebGLContext.POINTS=0x0000;
	WebGLContext.LINES=0x0001;
	WebGLContext.LINE_LOOP=0x0002;
	WebGLContext.LINE_STRIP=0x0003;
	WebGLContext.TRIANGLES=0x0004;
	WebGLContext.TRIANGLE_STRIP=0x0005;
	WebGLContext.TRIANGLE_FAN=0x0006;
	WebGLContext.ZERO=0;
	WebGLContext.ONE=1;
	WebGLContext.SRC_COLOR=0x0300;
	WebGLContext.ONE_MINUS_SRC_COLOR=0x0301;
	WebGLContext.SRC_ALPHA=0x0302;
	WebGLContext.ONE_MINUS_SRC_ALPHA=0x0303;
	WebGLContext.DST_ALPHA=0x0304;
	WebGLContext.ONE_MINUS_DST_ALPHA=0x0305;
	WebGLContext.DST_COLOR=0x0306;
	WebGLContext.ONE_MINUS_DST_COLOR=0x0307;
	WebGLContext.SRC_ALPHA_SATURATE=0x0308;
	WebGLContext.FUNC_ADD=0x8006;
	WebGLContext.BLEND_EQUATION=0x8009;
	WebGLContext.BLEND_EQUATION_RGB=0x8009;
	WebGLContext.BLEND_EQUATION_ALPHA=0x883D;
	WebGLContext.FUNC_SUBTRACT=0x800A;
	WebGLContext.FUNC_REVERSE_SUBTRACT=0x800B;
	WebGLContext.BLEND_DST_RGB=0x80C8;
	WebGLContext.BLEND_SRC_RGB=0x80C9;
	WebGLContext.BLEND_DST_ALPHA=0x80CA;
	WebGLContext.BLEND_SRC_ALPHA=0x80CB;
	WebGLContext.CONSTANT_COLOR=0x8001;
	WebGLContext.ONE_MINUS_CONSTANT_COLOR=0x8002;
	WebGLContext.CONSTANT_ALPHA=0x8003;
	WebGLContext.ONE_MINUS_CONSTANT_ALPHA=0x8004;
	WebGLContext.BLEND_COLOR=0x8005;
	WebGLContext.ARRAY_BUFFER=0x8892;
	WebGLContext.ELEMENT_ARRAY_BUFFER=0x8893;
	WebGLContext.ARRAY_BUFFER_BINDING=0x8894;
	WebGLContext.ELEMENT_ARRAY_BUFFER_BINDING=0x8895;
	WebGLContext.STREAM_DRAW=0x88E0;
	WebGLContext.STATIC_DRAW=0x88E4;
	WebGLContext.DYNAMIC_DRAW=0x88E8;
	WebGLContext.BUFFER_SIZE=0x8764;
	WebGLContext.BUFFER_USAGE=0x8765;
	WebGLContext.CURRENT_VERTEX_ATTRIB=0x8626;
	WebGLContext.FRONT=0x0404;
	WebGLContext.BACK=0x0405;
	WebGLContext.CULL_FACE=0x0B44;
	WebGLContext.FRONT_AND_BACK=0x0408;
	WebGLContext.BLEND=0x0BE2;
	WebGLContext.DITHER=0x0BD0;
	WebGLContext.STENCIL_TEST=0x0B90;
	WebGLContext.DEPTH_TEST=0x0B71;
	WebGLContext.SCISSOR_TEST=0x0C11;
	WebGLContext.POLYGON_OFFSET_FILL=0x8037;
	WebGLContext.SAMPLE_ALPHA_TO_COVERAGE=0x809E;
	WebGLContext.SAMPLE_COVERAGE=0x80A0;
	WebGLContext.NO_ERROR=0;
	WebGLContext.INVALID_ENUM=0x0500;
	WebGLContext.INVALID_VALUE=0x0501;
	WebGLContext.INVALID_OPERATION=0x0502;
	WebGLContext.OUT_OF_MEMORY=0x0505;
	WebGLContext.CW=0x0900;
	WebGLContext.CCW=0x0901;
	WebGLContext.LINE_WIDTH=0x0B21;
	WebGLContext.ALIASED_POINT_SIZE_RANGE=0x846D;
	WebGLContext.ALIASED_LINE_WIDTH_RANGE=0x846E;
	WebGLContext.CULL_FACE_MODE=0x0B45;
	WebGLContext.FRONT_FACE=0x0B46;
	WebGLContext.DEPTH_RANGE=0x0B70;
	WebGLContext.DEPTH_WRITEMASK=0x0B72;
	WebGLContext.DEPTH_CLEAR_VALUE=0x0B73;
	WebGLContext.DEPTH_FUNC=0x0B74;
	WebGLContext.STENCIL_CLEAR_VALUE=0x0B91;
	WebGLContext.STENCIL_FUNC=0x0B92;
	WebGLContext.STENCIL_FAIL=0x0B94;
	WebGLContext.STENCIL_PASS_DEPTH_FAIL=0x0B95;
	WebGLContext.STENCIL_PASS_DEPTH_PASS=0x0B96;
	WebGLContext.STENCIL_REF=0x0B97;
	WebGLContext.STENCIL_VALUE_MASK=0x0B93;
	WebGLContext.STENCIL_WRITEMASK=0x0B98;
	WebGLContext.STENCIL_BACK_FUNC=0x8800;
	WebGLContext.STENCIL_BACK_FAIL=0x8801;
	WebGLContext.STENCIL_BACK_PASS_DEPTH_FAIL=0x8802;
	WebGLContext.STENCIL_BACK_PASS_DEPTH_PASS=0x8803;
	WebGLContext.STENCIL_BACK_REF=0x8CA3;
	WebGLContext.STENCIL_BACK_VALUE_MASK=0x8CA4;
	WebGLContext.STENCIL_BACK_WRITEMASK=0x8CA5;
	WebGLContext.VIEWPORT=0x0BA2;
	WebGLContext.SCISSOR_BOX=0x0C10;
	WebGLContext.COLOR_CLEAR_VALUE=0x0C22;
	WebGLContext.COLOR_WRITEMASK=0x0C23;
	WebGLContext.UNPACK_ALIGNMENT=0x0CF5;
	WebGLContext.PACK_ALIGNMENT=0x0D05;
	WebGLContext.MAX_TEXTURE_SIZE=0x0D33;
	WebGLContext.MAX_VIEWPORT_DIMS=0x0D3A;
	WebGLContext.SUBPIXEL_BITS=0x0D50;
	WebGLContext.RED_BITS=0x0D52;
	WebGLContext.GREEN_BITS=0x0D53;
	WebGLContext.BLUE_BITS=0x0D54;
	WebGLContext.ALPHA_BITS=0x0D55;
	WebGLContext.DEPTH_BITS=0x0D56;
	WebGLContext.STENCIL_BITS=0x0D57;
	WebGLContext.POLYGON_OFFSET_UNITS=0x2A00;
	WebGLContext.POLYGON_OFFSET_FACTOR=0x8038;
	WebGLContext.TEXTURE_BINDING_2D=0x8069;
	WebGLContext.SAMPLE_BUFFERS=0x80A8;
	WebGLContext.SAMPLES=0x80A9;
	WebGLContext.SAMPLE_COVERAGE_VALUE=0x80AA;
	WebGLContext.SAMPLE_COVERAGE_INVERT=0x80AB;
	WebGLContext.NUM_COMPRESSED_TEXTURE_FORMATS=0x86A2;
	WebGLContext.COMPRESSED_TEXTURE_FORMATS=0x86A3;
	WebGLContext.DONT_CARE=0x1100;
	WebGLContext.FASTEST=0x1101;
	WebGLContext.NICEST=0x1102;
	WebGLContext.GENERATE_MIPMAP_HINT=0x8192;
	WebGLContext.BYTE=0x1400;
	WebGLContext.UNSIGNED_BYTE=0x1401;
	WebGLContext.SHORT=0x1402;
	WebGLContext.UNSIGNED_SHORT=0x1403;
	WebGLContext.INT=0x1404;
	WebGLContext.UNSIGNED_INT=0x1405;
	WebGLContext.FLOAT=0x1406;
	WebGLContext.DEPTH_COMPONENT=0x1902;
	WebGLContext.ALPHA=0x1906;
	WebGLContext.RGB=0x1907;
	WebGLContext.RGBA=0x1908;
	WebGLContext.LUMINANCE=0x1909;
	WebGLContext.LUMINANCE_ALPHA=0x190A;
	WebGLContext.UNSIGNED_SHORT_4_4_4_4=0x8033;
	WebGLContext.UNSIGNED_SHORT_5_5_5_1=0x8034;
	WebGLContext.UNSIGNED_SHORT_5_6_5=0x8363;
	WebGLContext.FRAGMENT_SHADER=0x8B30;
	WebGLContext.VERTEX_SHADER=0x8B31;
	WebGLContext.MAX_VERTEX_ATTRIBS=0x8869;
	WebGLContext.MAX_VERTEX_UNIFORM_VECTORS=0x8DFB;
	WebGLContext.MAX_VARYING_VECTORS=0x8DFC;
	WebGLContext.MAX_COMBINED_TEXTURE_IMAGE_UNITS=0x8B4D;
	WebGLContext.MAX_VERTEX_TEXTURE_IMAGE_UNITS=0x8B4C;
	WebGLContext.MAX_TEXTURE_IMAGE_UNITS=0x8872;
	WebGLContext.MAX_FRAGMENT_UNIFORM_VECTORS=0x8DFD;
	WebGLContext.SHADER_TYPE=0x8B4F;
	WebGLContext.DELETE_STATUS=0x8B80;
	WebGLContext.LINK_STATUS=0x8B82;
	WebGLContext.VALIDATE_STATUS=0x8B83;
	WebGLContext.ATTACHED_SHADERS=0x8B85;
	WebGLContext.ACTIVE_UNIFORMS=0x8B86;
	WebGLContext.ACTIVE_ATTRIBUTES=0x8B89;
	WebGLContext.SHADING_LANGUAGE_VERSION=0x8B8C;
	WebGLContext.CURRENT_PROGRAM=0x8B8D;
	WebGLContext.NEVER=0x0200;
	WebGLContext.LESS=0x0201;
	WebGLContext.EQUAL=0x0202;
	WebGLContext.LEQUAL=0x0203;
	WebGLContext.GREATER=0x0204;
	WebGLContext.NOTEQUAL=0x0205;
	WebGLContext.GEQUAL=0x0206;
	WebGLContext.ALWAYS=0x0207;
	WebGLContext.KEEP=0x1E00;
	WebGLContext.REPLACE=0x1E01;
	WebGLContext.INCR=0x1E02;
	WebGLContext.DECR=0x1E03;
	WebGLContext.INVERT=0x150A;
	WebGLContext.INCR_WRAP=0x8507;
	WebGLContext.DECR_WRAP=0x8508;
	WebGLContext.VENDOR=0x1F00;
	WebGLContext.RENDERER=0x1F01;
	WebGLContext.VERSION=0x1F02;
	WebGLContext.NEAREST=0x2600;
	WebGLContext.LINEAR=0x2601;
	WebGLContext.NEAREST_MIPMAP_NEAREST=0x2700;
	WebGLContext.LINEAR_MIPMAP_NEAREST=0x2701;
	WebGLContext.NEAREST_MIPMAP_LINEAR=0x2702;
	WebGLContext.LINEAR_MIPMAP_LINEAR=0x2703;
	WebGLContext.TEXTURE_MAG_FILTER=0x2800;
	WebGLContext.TEXTURE_MIN_FILTER=0x2801;
	WebGLContext.TEXTURE_WRAP_S=0x2802;
	WebGLContext.TEXTURE_WRAP_T=0x2803;
	WebGLContext.TEXTURE_2D=0x0DE1;
	WebGLContext.TEXTURE_3D=0x806f;
	WebGLContext.TEXTURE=0x1702;
	WebGLContext.TEXTURE_CUBE_MAP=0x8513;
	WebGLContext.TEXTURE_BINDING_CUBE_MAP=0x8514;
	WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_X=0x8515;
	WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_X=0x8516;
	WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_Y=0x8517;
	WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_Y=0x8518;
	WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_Z=0x8519;
	WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_Z=0x851A;
	WebGLContext.MAX_CUBE_MAP_TEXTURE_SIZE=0x851C;
	WebGLContext.TEXTURE0=0x84C0;
	WebGLContext.TEXTURE1=0x84C1;
	WebGLContext.TEXTURE2=0x84C2;
	WebGLContext.TEXTURE3=0x84C3;
	WebGLContext.TEXTURE4=0x84C4;
	WebGLContext.TEXTURE5=0x84C5;
	WebGLContext.TEXTURE6=0x84C6;
	WebGLContext.TEXTURE7=0x84C7;
	WebGLContext.TEXTURE8=0x84C8;
	WebGLContext.TEXTURE9=0x84C9;
	WebGLContext.TEXTURE10=0x84CA;
	WebGLContext.TEXTURE11=0x84CB;
	WebGLContext.TEXTURE12=0x84CC;
	WebGLContext.TEXTURE13=0x84CD;
	WebGLContext.TEXTURE14=0x84CE;
	WebGLContext.TEXTURE15=0x84CF;
	WebGLContext.TEXTURE16=0x84D0;
	WebGLContext.TEXTURE17=0x84D1;
	WebGLContext.TEXTURE18=0x84D2;
	WebGLContext.TEXTURE19=0x84D3;
	WebGLContext.TEXTURE20=0x84D4;
	WebGLContext.TEXTURE21=0x84D5;
	WebGLContext.TEXTURE22=0x84D6;
	WebGLContext.TEXTURE23=0x84D7;
	WebGLContext.TEXTURE24=0x84D8;
	WebGLContext.TEXTURE25=0x84D9;
	WebGLContext.TEXTURE26=0x84DA;
	WebGLContext.TEXTURE27=0x84DB;
	WebGLContext.TEXTURE28=0x84DC;
	WebGLContext.TEXTURE29=0x84DD;
	WebGLContext.TEXTURE30=0x84DE;
	WebGLContext.TEXTURE31=0x84DF;
	WebGLContext.ACTIVE_TEXTURE=0x84E0;
	WebGLContext.REPEAT=0x2901;
	WebGLContext.CLAMP_TO_EDGE=0x812F;
	WebGLContext.MIRRORED_REPEAT=0x8370;
	WebGLContext.FLOAT_VEC2=0x8B50;
	WebGLContext.FLOAT_VEC3=0x8B51;
	WebGLContext.FLOAT_VEC4=0x8B52;
	WebGLContext.INT_VEC2=0x8B53;
	WebGLContext.INT_VEC3=0x8B54;
	WebGLContext.INT_VEC4=0x8B55;
	WebGLContext.BOOL=0x8B56;
	WebGLContext.BOOL_VEC2=0x8B57;
	WebGLContext.BOOL_VEC3=0x8B58;
	WebGLContext.BOOL_VEC4=0x8B59;
	WebGLContext.FLOAT_MAT2=0x8B5A;
	WebGLContext.FLOAT_MAT3=0x8B5B;
	WebGLContext.FLOAT_MAT4=0x8B5C;
	WebGLContext.SAMPLER_2D=0x8B5E;
	WebGLContext.SAMPLER_CUBE=0x8B60;
	WebGLContext.VERTEX_ATTRIB_ARRAY_ENABLED=0x8622;
	WebGLContext.VERTEX_ATTRIB_ARRAY_SIZE=0x8623;
	WebGLContext.VERTEX_ATTRIB_ARRAY_STRIDE=0x8624;
	WebGLContext.VERTEX_ATTRIB_ARRAY_TYPE=0x8625;
	WebGLContext.VERTEX_ATTRIB_ARRAY_NORMALIZED=0x886A;
	WebGLContext.VERTEX_ATTRIB_ARRAY_POINTER=0x8645;
	WebGLContext.VERTEX_ATTRIB_ARRAY_BUFFER_BINDING=0x889F;
	WebGLContext.COMPILE_STATUS=0x8B81;
	WebGLContext.LOW_FLOAT=0x8DF0;
	WebGLContext.MEDIUM_FLOAT=0x8DF1;
	WebGLContext.HIGH_FLOAT=0x8DF2;
	WebGLContext.LOW_INT=0x8DF3;
	WebGLContext.MEDIUM_INT=0x8DF4;
	WebGLContext.HIGH_INT=0x8DF5;
	WebGLContext.FRAMEBUFFER=0x8D40;
	WebGLContext.RENDERBUFFER=0x8D41;
	WebGLContext.RGBA4=0x8056;
	WebGLContext.RGB5_A1=0x8057;
	WebGLContext.RGB565=0x8D62;
	WebGLContext.DEPTH_COMPONENT16=0x81A5;
	WebGLContext.STENCIL_INDEX=0x1901;
	WebGLContext.STENCIL_INDEX8=0x8D48;
	WebGLContext.DEPTH_STENCIL=0x84F9;
	WebGLContext.RENDERBUFFER_WIDTH=0x8D42;
	WebGLContext.RENDERBUFFER_HEIGHT=0x8D43;
	WebGLContext.RENDERBUFFER_INTERNAL_FORMAT=0x8D44;
	WebGLContext.RENDERBUFFER_RED_SIZE=0x8D50;
	WebGLContext.RENDERBUFFER_GREEN_SIZE=0x8D51;
	WebGLContext.RENDERBUFFER_BLUE_SIZE=0x8D52;
	WebGLContext.RENDERBUFFER_ALPHA_SIZE=0x8D53;
	WebGLContext.RENDERBUFFER_DEPTH_SIZE=0x8D54;
	WebGLContext.RENDERBUFFER_STENCIL_SIZE=0x8D55;
	WebGLContext.FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE=0x8CD0;
	WebGLContext.FRAMEBUFFER_ATTACHMENT_OBJECT_NAME=0x8CD1;
	WebGLContext.FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL=0x8CD2;
	WebGLContext.FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE=0x8CD3;
	WebGLContext.COLOR_ATTACHMENT0=0x8CE0;
	WebGLContext.DEPTH_ATTACHMENT=0x8D00;
	WebGLContext.STENCIL_ATTACHMENT=0x8D20;
	WebGLContext.DEPTH_STENCIL_ATTACHMENT=0x821A;
	WebGLContext.NONE=0;
	WebGLContext.FRAMEBUFFER_COMPLETE=0x8CD5;
	WebGLContext.FRAMEBUFFER_INCOMPLETE_ATTACHMENT=0x8CD6;
	WebGLContext.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT=0x8CD7;
	WebGLContext.FRAMEBUFFER_INCOMPLETE_DIMENSIONS=0x8CD9;
	WebGLContext.FRAMEBUFFER_UNSUPPORTED=0x8CDD;
	WebGLContext.FRAMEBUFFER_BINDING=0x8CA6;
	WebGLContext.RENDERBUFFER_BINDING=0x8CA7;
	WebGLContext.MAX_RENDERBUFFER_SIZE=0x84E8;
	WebGLContext.INVALID_FRAMEBUFFER_OPERATION=0x0506;
	WebGLContext.UNPACK_FLIP_Y_WEBGL=0x9240;
	WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL=0x9241;
	WebGLContext.CONTEXT_LOST_WEBGL=0x9242;
	WebGLContext.UNPACK_COLORSPACE_CONVERSION_WEBGL=0x9243;
	WebGLContext.BROWSER_DEFAULT_WEBGL=0x9244;
	WebGLContext._extTextureFilterAnisotropic=null;
	WebGLContext._compressedTextureS3tc=null;
	WebGLContext._compressedTexturePvrtc=null;
	WebGLContext._compressedTextureEtc1=null;
	WebGLContext._glTextureIDs=[ /*CLASS CONST:laya.webgl.WebGLContext.TEXTURE0*/0x84C0,/*CLASS CONST:laya.webgl.WebGLContext.TEXTURE1*/0x84C1,/*CLASS CONST:laya.webgl.WebGLContext.TEXTURE2*/0x84C2,/*CLASS CONST:laya.webgl.WebGLContext.TEXTURE3*/0x84C3,/*CLASS CONST:laya.webgl.WebGLContext.TEXTURE4*/0x84C4,/*CLASS CONST:laya.webgl.WebGLContext.TEXTURE5*/0x84C5,/*CLASS CONST:laya.webgl.WebGLContext.TEXTURE6*/0x84C6,/*CLASS CONST:laya.webgl.WebGLContext.TEXTURE7*/0x84C7];
	WebGLContext._useProgram=null;
	WebGLContext._depthTest=true;
	WebGLContext._depthMask=true;
	WebGLContext._blend=false;
	WebGLContext._cullFace=false;
	WebGLContext._activedTextureID=0x84C0;
	__static(WebGLContext,
	['_extentionVendorPrefixes',function(){return this._extentionVendorPrefixes=["","WEBKIT_","MOZ_"];},'_activeTextures',function(){return this._activeTextures=new Array(8);},'_depthFunc',function(){return this._depthFunc=/*CLASS CONST:laya.webgl.WebGLContext.LESS*/0x0201;},'_sFactor',function(){return this._sFactor=/*CLASS CONST:laya.webgl.WebGLContext.ONE*/1;},'_dFactor',function(){return this._dFactor=/*CLASS CONST:laya.webgl.WebGLContext.ZERO*/0;},'_frontFace',function(){return this._frontFace=/*CLASS CONST:laya.webgl.WebGLContext.CCW*/0x0901;}
	]);
	return WebGLContext;
})()


//class laya.layagl.cmdNative.ClipRectCmdNative
var ClipRectCmdNative=(function(){
	function ClipRectCmdNative(){
		this._graphicsCmdEncoder=null;
		this._paramData=/*__JS__ */new ParamData(4 *4,true);
	}

	__class(ClipRectCmdNative,'laya.layagl.cmdNative.ClipRectCmdNative');
	var __proto=ClipRectCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("ClipRectCmd",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "ClipRect";
	});

	__getset(0,__proto,'width',function(){
		return 0;
		},function(value){
	});

	__getset(0,__proto,'x',function(){
		return 0;
		},function(value){
	});

	__getset(0,__proto,'y',function(){
		return 0;
		},function(value){
	});

	__getset(0,__proto,'height',function(){
		return 0;
		},function(value){
	});

	ClipRectCmdNative.create=function(x,y,w,h){
		var cmd=Pool.getItemByClass("ClipRectCmd",ClipRectCmdNative);
		cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;
		var cbuf=cmd._graphicsCmdEncoder;
		var f32=cmd._paramData._float32Data;
		f32[0]=x;
		f32[1]=y;
		f32[2]=w;
		f32[3]=h;
		var nDataID=cmd._paramData.getPtrID();
		LayaGL.syncBufferToRenderThread(cmd._paramData);
		cbuf.setClipValueEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,LayaNative2D.GLOBALVALUE_MATRIX32,nDataID);
		LayaGL.syncBufferToRenderThread(cbuf);
		return cmd;
	}

	ClipRectCmdNative.ID="ClipRect";
	return ClipRectCmdNative;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.DrawCurvesCmdNative
var DrawCurvesCmdNative=(function(){
	function DrawCurvesCmdNative(){
		this._graphicsCmdEncoder=null;
		this._paramData=null;
		this._x=0;
		this._y=0;
		this._points=[];
		this._lineColor=null;
		this._lineWidth=NaN;
		this.lastOriX=0;
		this.lastOriY=0;
		this.tArray=[];
		this._vertNum=0;
		this.ibBuffer=null;
		this.vbBuffer=null;
		this._ibSize=0;
		this._vbSize=0;
		this._ibArray=[];
		this._vbArray=[];
	}

	__class(DrawCurvesCmdNative,'laya.layagl.cmdNative.DrawCurvesCmdNative');
	var __proto=DrawCurvesCmdNative.prototype;
	__proto._getPoints=function(points){
		var newPoints=[];
		this._points.push(points[0]);
		this._points.push(points[1]);
		var i=2,n=points.length;
		while (i < n){
			this._quadraticCurveTo(newPoints,points[i++],points[i++],points[i++],points[i++]);
		}
		return newPoints;
	}

	__proto._quadraticCurveTo=function(points,cpx,cpy,x,y){
		var tBezier=Bezier.I;
		if (this.tArray.length==0){
			this.lastOriX=this._points[0];
			this.lastOriY=this._points[1];
		}
		else{
			this.lastOriX=this.tArray[this.tArray.length-2];
			this.lastOriY=this.tArray[this.tArray.length-1];
		}
		this.tArray=tBezier.getBezierPoints([this.lastOriX,this.lastOriY,cpx,cpy,x,y],30,2);
		for (var i=2,n=this.tArray.length;i < n;i++){
			points.push(this.tArray[i]);
		}
	}

	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._lineColor=null;
		this._points.length=0;
		this.tArray.length=0;
		this._ibArray.length=0;
		this._vbArray.length=0;
		Pool.recover("DrawCurvesCmd",this);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._lineColor;
		},function(value){
		this._lineColor=value;
		var c1=ColorUtils.create(this._lineColor);
		var nColor=c1.numColor;
		var _i32b=this.vbBuffer._int32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			ix++;ix++;_i32b[ix++]=nColor;
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'points',function(){
		return this._points;
		},function(value){
		this._points.length=0;
		this.lastOriX=0;this.lastOriY=0;
		this._points=this._getPoints(value);
		this._ibArray.length=0;
		this._vbArray.length=0;
		BasePoly.createLine2(this._points,this._ibArray,this.lineWidth,0,this._vbArray,false);
		var c1=ColorUtils.create(this._lineColor);
		var nColor=c1.numColor;
		this._vertNum=this._points.length;
		var vertNumCopy=this._vertNum;
		if (!this.vbBuffer || this.vbBuffer.getByteLength()< this._vertNum*3*4){
			this.vbBuffer=/*__JS__ */new ParamData(vertNumCopy*3*4,true);
		}
		this._vbSize=this._vertNum *3 *4;
		var _vb=this.vbBuffer._float32Data;
		var _i32b=this.vbBuffer._int32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			_vb[ix++]=this._vbArray[i *2]+this.x;_vb[ix++]=this._vbArray[i *2+1]+this.y;_i32b[ix++]=nColor;
		}
		if (!this.ibBuffer || this.ibBuffer.getByteLength()< (this._vertNum-2)*3 *2){
			this.ibBuffer=/*__JS__ */new ParamData((vertNumCopy-2)*3 *2,true,true);
		}
		this._ibSize=(this._vertNum-2)*3 *2;
		var _ib=this.ibBuffer._int16Data;
		for (var ii=0;ii < (this._vertNum-2)*3;ii++){
			_ib[ii]=this._ibArray[ii];
		}
		_i32b=this._paramData._int32Data;
		_i32b[DrawCurvesCmdNative._PARAM_VB_SIZE_POS_]=this._vbSize;
		_i32b[DrawCurvesCmdNative._PARAM_IB_SIZE_POS_]=this._ibSize;
		LayaGL.syncBufferToRenderThread(this.ibBuffer);
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawCurves";
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
		var _vb=this.vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			_vb[ix++]=this._vbArray[i *2]+this._x;ix++;ix++;
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
		var _vb=this.vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			ix++;_vb[ix++]=this._vbArray[i *2+1]+this._y;ix++;
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		this._lineWidth=value;
		this._ibArray.length=0;
		this._vbArray.length=0;
		BasePoly.createLine2(this._points,this._ibArray,this._lineWidth,0,this._vbArray,false);
		var _vb=this.vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			_vb[ix++]=this._vbArray[i *2]+this.x;_vb[ix++]=this._vbArray[i *2+1]+this.y;ix++;
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	DrawCurvesCmdNative.create=function(x,y,points,lineColor,lineWidth){
		var cmd=Pool.getItemByClass("DrawCurvesCmd",DrawCurvesCmdNative);
		cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		if (!DrawCurvesCmdNative._DRAW_CURVES_CMD_ENCODER_){
			DrawCurvesCmdNative._DRAW_CURVES_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(152,32,true);
			DrawCurvesCmdNative._DRAW_CURVES_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);
			DrawCurvesCmdNative._DRAW_CURVES_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);
			DrawCurvesCmdNative._DRAW_CURVES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawCurvesCmdNative._DRAW_CURVES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawCurvesCmdNative._DRAW_CURVES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawCurvesCmdNative._DRAW_CURVES_CMD_ENCODER_.setMeshExByParamData(DrawCurvesCmdNative._PARAM_VB_POS_ *4,DrawCurvesCmdNative._PARAM_VB_OFFSET_POS_ *4,DrawCurvesCmdNative._PARAM_VB_SIZE_POS_ *4,DrawCurvesCmdNative._PARAM_IB_POS_ *4,DrawCurvesCmdNative._PARAM_IB_OFFSET_POS_ *4,DrawCurvesCmdNative._PARAM_IB_SIZE_POS_ *4,DrawCurvesCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawCurvesCmdNative._DRAW_CURVES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawCurvesCmdNative._DRAW_CURVES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawCurvesCmdNative._DRAW_CURVES_CMD_ENCODER_);
		}
		if (!cmd._paramData){
			cmd._paramData=/*__JS__ */new ParamData(8 *4,true);
			}{
			cmd._x=x;
			cmd._y=y;
			cmd._lineColor=lineColor;
			cmd._lineWidth=lineWidth;
			cmd._points=cmd._getPoints(points);
			BasePoly.createLine2(cmd._points,cmd._ibArray,lineWidth,0,cmd._vbArray,false);
			var c1=ColorUtils.create(lineColor);
			var nColor=c1.numColor;
			cmd._vertNum=cmd._points.length;
			var vertNumCopy=cmd._vertNum;
			if (!cmd.vbBuffer || cmd.vbBuffer.getByteLength()< cmd._vertNum*3*4){
				cmd.vbBuffer=/*__JS__ */new ParamData(vertNumCopy*3*4,true);
			}
			cmd._vbSize=cmd._vertNum *3 *4;
			var _vb=cmd.vbBuffer._float32Data;
			var _i32b=cmd.vbBuffer._int32Data;
			var ix=0;
			for (var i=0;i < cmd._vertNum;i++){
				_vb[ix++]=cmd._vbArray[i *2]+x;_vb[ix++]=cmd._vbArray[i *2+1]+y;_i32b[ix++]=nColor;
			}
			if (!cmd.ibBuffer || cmd.ibBuffer.getByteLength()< (cmd._vertNum-2)*3 *2){
				cmd.ibBuffer=/*__JS__ */new ParamData((vertNumCopy-2)*3 *2,true,true);
			}
			cmd._ibSize=(cmd._vertNum-2)*3 *2;
			var _ib=cmd.ibBuffer._int16Data;
			for (var ii=0;ii < (cmd._vertNum-2)*3;ii++){
				_ib[ii]=cmd._ibArray[ii];
			}
		};
		var _fb=cmd._paramData._float32Data;
		_i32b=cmd._paramData._int32Data;
		_i32b[0]=1;
		_i32b[DrawCurvesCmdNative._PARAM_VB_POS_]=cmd.vbBuffer.getPtrID();
		_i32b[DrawCurvesCmdNative._PARAM_IB_POS_]=cmd.ibBuffer.getPtrID();
		_i32b[DrawCurvesCmdNative._PARAM_VB_SIZE_POS_]=cmd._vbSize;
		_i32b[DrawCurvesCmdNative._PARAM_IB_SIZE_POS_]=cmd._ibSize;
		_i32b[DrawCurvesCmdNative._PARAM_VB_OFFSET_POS_]=0;
		_i32b[DrawCurvesCmdNative._PARAM_IB_OFFSET_POS_]=0;
		_i32b[DrawCurvesCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_]=0;
		LayaGL.syncBufferToRenderThread(cmd.vbBuffer);
		LayaGL.syncBufferToRenderThread(cmd.ibBuffer);
		LayaGL.syncBufferToRenderThread(cmd._paramData);
		cmd._graphicsCmdEncoder.useCommandEncoder(DrawCurvesCmdNative._DRAW_CURVES_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		LayaGL.syncBufferToRenderThread(cmd._graphicsCmdEncoder);
		return cmd;
	}

	DrawCurvesCmdNative.ID="DrawCurves";
	DrawCurvesCmdNative._DRAW_CURVES_CMD_ENCODER_=null;
	DrawCurvesCmdNative._PARAM_VB_POS_=1;
	DrawCurvesCmdNative._PARAM_IB_POS_=2;
	DrawCurvesCmdNative._PARAM_VB_SIZE_POS_=3;
	DrawCurvesCmdNative._PARAM_IB_SIZE_POS_=4;
	DrawCurvesCmdNative._PARAM_VB_OFFSET_POS_=5;
	DrawCurvesCmdNative._PARAM_IB_OFFSET_POS_=6;
	DrawCurvesCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_=7;
	return DrawCurvesCmdNative;
})()


/**
*TODO如果占用内存较大,这个结构有很多成员可以临时计算
*/
//class laya.webgl.resource.CharRenderInfo
var CharRenderInfo=(function(){
	function CharRenderInfo(){
		this.char='';
		// 调试用
		this.tex=null;
		//
		this.deleted=false;
		// [0,0,1,1];//uv
		this.pos=0;
		//数组下标
		this.width=0;
		//字体宽度。测量的宽度，用来排版。没有缩放
		this.height=0;
		//字体高度。没有缩放
		this.bmpWidth=0;
		//实际图片的宽度。可能与排版用的width不一致。包含缩放和margin
		this.bmpHeight=0;
		this.orix=0;
		// 原点位置，通常都是所在区域的左上角
		this.oriy=0;
		this.touchTick=0;
		//
		this.isSpace=false;
		this.uv=new Array(8);
	}

	__class(CharRenderInfo,'laya.webgl.resource.CharRenderInfo');
	var __proto=CharRenderInfo.prototype;
	//是否是空格，如果是空格，则只有width有效
	__proto.touch=function(){
		var curLoop=Stat.loopCount;
		if (this.touchTick !=curLoop){
			this.tex.touchRect(this,curLoop);
		}
		this.touchTick=curLoop;
	}

	return CharRenderInfo;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.DrawCanvasCmdNative
var DrawCanvasCmdNative=(function(){
	function DrawCanvasCmdNative(){
		this._graphicsCmdEncoder=null;
		this._index=0;
		this._paramData=null;
		this._texture=null;
		this._x=NaN;
		this._y=NaN;
		this._width=NaN;
		this._height=NaN;
	}

	__class(DrawCanvasCmdNative,'laya.layagl.cmdNative.DrawCanvasCmdNative');
	var __proto=DrawCanvasCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._graphicsCmdEncoder=null;
		Pool.recover("DrawCanvasCmd",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "DrawCanvas";
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+1]=this._y;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+7]=this._y;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+13]=this._y+this._height;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+19]=this._y+this._height;
		_fb[DrawCanvasCmdNative._PARAM_CLIP_SIZE+1]=value+/*laya.display.css.CacheStyle.CANVAS_EXTEND_EDGE*/16;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'texture',function(){
		return this._texture;
		},function(value){
		this._texture=value;
		this._paramData._int32Data[DrawCanvasCmdNative._PARAM_TEXTURE_POS_]=this._texture._getSource().id;
		var _fb=this._paramData._float32Data;
		var uv=RenderTexture2D.flipyuv;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+2]=uv[0];_fb[DrawCanvasCmdNative._PARAM_VB_POS_+3]=uv[1];
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+8]=uv[2];_fb[DrawCanvasCmdNative._PARAM_VB_POS_+9]=uv[3];
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+14]=uv[4];_fb[DrawCanvasCmdNative._PARAM_VB_POS_+15]=uv[5];
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+20]=uv[6];_fb[DrawCanvasCmdNative._PARAM_VB_POS_+21]=uv[7];
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'width',function(){
		return this._width;
		},function(value){
		this._width=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_]=this._x;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+6]=this._x+this._width;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+12]=this._x+this._width;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+18]=this._x;
		_fb[DrawCanvasCmdNative._PARAM_CLIP_SIZE+2]=value-/*laya.display.css.CacheStyle.CANVAS_EXTEND_EDGE*/16*2;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_]=this._x;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+6]=this._x+this._width;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+12]=this._x+this._width;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+18]=this._x;
		_fb[DrawCanvasCmdNative._PARAM_CLIP_SIZE]=value+/*laya.display.css.CacheStyle.CANVAS_EXTEND_EDGE*/16;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'height',function(){
		return this._height;
		},function(value){
		this._height=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+1]=this._y;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+7]=this._y;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+13]=this._y+this._height;
		_fb[DrawCanvasCmdNative._PARAM_VB_POS_+19]=this._y+this._height;
		_fb[DrawCanvasCmdNative._PARAM_CLIP_SIZE+3]=value-/*laya.display.css.CacheStyle.CANVAS_EXTEND_EDGE*/16*2;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	DrawCanvasCmdNative.create=function(texture,x,y,width,height){
		var cmd=Pool.getItemByClass("DrawCanvasCmd",DrawCanvasCmdNative);
		cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		DrawCanvasCmdNative.createCommandEncoder();
		if (!cmd._paramData){
			cmd._paramData=/*__JS__ */new ParamData(33*4,true);
		}
		cmd._texture=texture;
		cmd._x=x;
		cmd._y=y;
		cmd._width=width;
		cmd._height=height;
		DrawCanvasCmdNative.setParamData(cmd._paramData,texture,x,y,width,height);
		var id1=DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_.getPtrID();
		var id2=cmd._paramData.getPtrID();
		cmd._graphicsCmdEncoder.useCommandEncoder(id1,id2,-1);
		LayaGL.syncBufferToRenderThread(cmd._graphicsCmdEncoder);
		return cmd;
	}

	DrawCanvasCmdNative.createCommandEncoder=function(){
		if (!DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_){
			DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(172,32,true);
			DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);
			DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);
			DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_.uniformTextureByParamData(0,1*4,DrawCanvasCmdNative._PARAM_TEXTURE_POS_*4);
			DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_.setRectMeshByParamData(3*4,DrawCanvasCmdNative._PARAM_VB_POS_*4,4*4);
			DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_);
		}
	}

	DrawCanvasCmdNative.setParamData=function(_paramData,texture,x,y,width,height){
		var _fb=_paramData._float32Data;
		var _i32b=_paramData._int32Data;
		_i32b[0]=3;
		_i32b[1]=/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0;
		_i32b[DrawCanvasCmdNative._PARAM_TEXTURE_POS_]=texture._getSource().id;
		_i32b[3]=1;
		_i32b[4]=24 *4;
		var w=width !=0 ? width :texture.width;
		var h=height !=0 ? height :texture.height;
		var uv=RenderTexture2D.flipyuv;
		var ix=DrawCanvasCmdNative._PARAM_VB_POS_;
		_fb[ix++]=x;_fb[ix++]=y;_fb[ix++]=uv[0];_fb[ix++]=uv[1];_i32b[ix++]=0xffffffff;_i32b[ix++]=0xffffffff;
		_fb[ix++]=x+w;_fb[ix++]=y;_fb[ix++]=uv[2];_fb[ix++]=uv[3];_i32b[ix++]=0xffffffff;_i32b[ix++]=0xffffffff;
		_fb[ix++]=x+w;_fb[ix++]=y+h;_fb[ix++]=uv[4];_fb[ix++]=uv[5];_i32b[ix++]=0xffffffff;_i32b[ix++]=0xffffffff;
		_fb[ix++]=x;_fb[ix++]=y+h;_fb[ix++]=uv[6];_fb[ix++]=uv[7];_i32b[ix++]=0xffffffff;_i32b[ix++]=0xffffffff;
		_fb[DrawCanvasCmdNative._PARAM_CLIP_SIZE]=x+/*laya.display.css.CacheStyle.CANVAS_EXTEND_EDGE*/16;
		_fb[DrawCanvasCmdNative._PARAM_CLIP_SIZE+1]=y+/*laya.display.css.CacheStyle.CANVAS_EXTEND_EDGE*/16;
		_fb[DrawCanvasCmdNative._PARAM_CLIP_SIZE+2]=width-/*laya.display.css.CacheStyle.CANVAS_EXTEND_EDGE*/16*2;
		_fb[DrawCanvasCmdNative._PARAM_CLIP_SIZE+3]=height-/*laya.display.css.CacheStyle.CANVAS_EXTEND_EDGE*/16*2;
		LayaGL.syncBufferToRenderThread(_paramData);
	}

	DrawCanvasCmdNative.ID="DrawCanvas";
	DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_=null;
	DrawCanvasCmdNative._PARAM_TEXTURE_POS_=2;
	DrawCanvasCmdNative._PARAM_VB_POS_=5;
	DrawCanvasCmdNative._PARAM_CLIP_SIZE=29;
	return DrawCanvasCmdNative;
})()


//class laya.webgl.canvas.save.SaveTranslate
var SaveTranslate=(function(){
	function SaveTranslate(){
		this._mat=new Matrix();
	}

	__class(SaveTranslate,'laya.webgl.canvas.save.SaveTranslate');
	var __proto=SaveTranslate.prototype;
	Laya.imps(__proto,{"laya.webgl.canvas.save.ISaveData":true})
	__proto.isSaveMark=function(){return false;}
	__proto.restore=function(context){
		this._mat.copyTo(context._curMat);
		SaveTranslate.POOL[SaveTranslate.POOL._length++]=this;
	}

	SaveTranslate.save=function(context){
		var no=SaveTranslate.POOL;
		var o=no._length > 0 ? no[--no._length] :(new SaveTranslate());
		context._curMat.copyTo(o._mat);
		var _save=context._save;
		_save[_save._length++]=o;
	}

	SaveTranslate.POOL=SaveBase._createArray();
	return SaveTranslate;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.TransformCmdNative
var TransformCmdNative=(function(){
	function TransformCmdNative(){
		this._graphicsCmdEncoder=null;
		this._matrix=null;
		this._paramData=/*__JS__ */new ParamData(8*4,true);
	}

	__class(TransformCmdNative,'laya.layagl.cmdNative.TransformCmdNative');
	var __proto=TransformCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._matrix=null;
		Pool.recover("TransformCmd",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "Transform";
	});

	__getset(0,__proto,'matrix',function(){
		return this._matrix;
		},function(value){
		this._matrix=value;
		var _fb=this._paramData._float32Data;
		_fb[0]=this._matrix.a;_fb[1]=this._matrix.b;_fb[2]=this._matrix.c;
		_fb[3]=this._matrix.d;_fb[4]=this._matrix.tx;_fb[5]=this._matrix.ty;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'pivotX',function(){
		return this._paramData._float32Data[6];
		},function(value){
		this._paramData._float32Data[6]=value;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'pivotY',function(){
		return this._paramData._float32Data[7];
		},function(value){
		this._paramData._float32Data[7]=value;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	TransformCmdNative.create=function(matrix,pivotX,pivotY){
		var cmd=Pool.getItemByClass("TransformCmd",TransformCmdNative);
		var cbuf=cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;
		var f32=cmd._paramData._float32Data;
		f32[0]=matrix.a;f32[1]=matrix.b;f32[2]=matrix.c;
		f32[3]=matrix.d;f32[4]=matrix.tx;f32[5]=matrix.ty;
		f32[6]=pivotX;f32[7]=pivotY;
		cmd._matrix=matrix;
		var nDataID=cmd._paramData.getPtrID();
		LayaGL.syncBufferToRenderThread(cmd._paramData);
		cbuf.setGlobalValueEx(LayaNative2D.GLOBALVALUE_MATRIX32,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_TRANSFORM_PIVOT*/14,nDataID,0);
		LayaGL.syncBufferToRenderThread(cbuf);
		return cmd;
	}

	TransformCmdNative.ID="Transform";
	return TransformCmdNative;
})()


/**
*...
*@author ww
*/
//class laya.layagl.ConchCmdReplace
var ConchCmdReplace=(function(){
	function ConchCmdReplace(){}
	__class(ConchCmdReplace,'laya.layagl.ConchCmdReplace');
	ConchCmdReplace.__init__=function(){
		var cmdO=/*__JS__ */laya.display.cmd;
		var cmdONative=/*__JS__ */laya.layagl.cmdNative;
		var key;
		for (key in cmdO){
			if (cmdONative[key+"Native"]){
				cmdO[key].create=cmdONative[key+"Native"].create;
			}
		}
	}

	return ConchCmdReplace;
})()


//class laya.webgl.submit.SubmitTarget
var SubmitTarget=(function(){
	function SubmitTarget(){
		this._mesh=null;
		//代替 _vb,_ib
		this._startIdx=0;
		this._numEle=0;
		this.shaderValue=null;
		this.blendType=0;
		this._ref=1;
		//public var scope:SubmitCMDScope;
		this.srcRT=null;
		this._key=new SubmitKey();
	}

	__class(SubmitTarget,'laya.webgl.submit.SubmitTarget');
	var __proto=SubmitTarget.prototype;
	Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
	__proto.renderSubmit=function(){
		var gl=WebGL.mainContext;
		this._mesh.useMesh(gl);
		var target=this.srcRT;
		if (target){
			this.shaderValue.texture=target._getSource();
			this.shaderValue.upload();
			this.blend();
			Stat.renderBatch++;
			Stat.trianglesFaces+=this._numEle/3;
			WebGL.mainContext.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,this._numEle,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,this._startIdx);
		}
		return 1;
	}

	__proto.blend=function(){
		if (BlendMode.activeBlendFunction!==BlendMode.fns[this.blendType]){
			var gl=WebGL.mainContext;
			gl.enable(/*laya.webgl.WebGLContext.BLEND*/0x0BE2);
			BlendMode.fns[this.blendType](gl);
			BlendMode.activeBlendFunction=BlendMode.fns[this.blendType];
		}
	}

	//TODO:coverage
	__proto.getRenderType=function(){
		return 0;
	}

	__proto.releaseRender=function(){
		if ((--this._ref)< 1){
			var pool=SubmitTarget.POOL;
			pool[pool._length++]=this;
		}
	}

	//TODO:coverage
	__proto.reUse=function(context,pos){
		this._startIdx=pos;
		this._ref++;
		return pos;
	}

	SubmitTarget.create=function(context,mesh,sv,rt){
		var o=SubmitTarget.POOL._length?SubmitTarget.POOL[--SubmitTarget.POOL._length]:new SubmitTarget();
		o._mesh=mesh;
		o.srcRT=rt;
		o._startIdx=mesh.indexNum *CONST3D2D.BYTES_PIDX;
		o._ref=1;
		o._key.clear();
		o._numEle=0;
		o.blendType=context._nBlendType;
		o._key.blendShader=o.blendType;
		o.shaderValue=sv;
		o.shaderValue.setValue(context._shader2D);
		if (context._colorFiler){
			var ft=context._colorFiler;
			sv.defines.add(ft.type);
			(sv).colorMat=ft._mat;
			(sv).colorAlpha=ft._alpha;
		}
		return o;
	}

	SubmitTarget.POOL=(SubmitTarget.POOL=[],SubmitTarget.POOL._length=0,SubmitTarget.POOL);
	return SubmitTarget;
})()


//class laya.webgl.shapes.Earcut
var Earcut=(function(){
	function Earcut(){}
	__class(Earcut,'laya.webgl.shapes.Earcut');
	Earcut.earcut=function(data,holeIndices,dim){
		dim=dim || 2;
		var hasHoles=holeIndices && holeIndices.length,
		outerLen=hasHoles ? holeIndices[0] *dim :data.length,
		outerNode=Earcut.linkedList(data,0,outerLen,dim,true),
		triangles=[];
		if (!outerNode)return triangles;
		var minX,minY,maxX,maxY,x,y,invSize;
		if (hasHoles)outerNode=Earcut.eliminateHoles(data,holeIndices,outerNode,dim);
		if (data.length > 80 *dim){
			minX=maxX=data[0];
			minY=maxY=data[1];
			for (var i=dim;i < outerLen;i+=dim){
				x=data[i];
				y=data[i+1];
				if (x < minX)minX=x;
				if (y < minY)minY=y;
				if (x > maxX)maxX=x;
				if (y > maxY)maxY=y;
			}
			invSize=Math.max(maxX-minX,maxY-minY);
			invSize=invSize!==0 ? 1 / invSize :0;
		}
		Earcut.earcutLinked(outerNode,triangles,dim,minX,minY,invSize);
		return triangles;
	}

	Earcut.linkedList=function(data,start,end,dim,clockwise){
		var i,last;
		if (clockwise===(Earcut.signedArea(data,start,end,dim)> 0)){
			for (i=start;i < end;i+=dim)last=Earcut.insertNode(i,data[i],data[i+1],last);
			}else {
			for (i=end-dim;i >=start;i-=dim)last=Earcut.insertNode(i,data[i],data[i+1],last);
		}
		if (last && Earcut.equals(last,last.next)){
			Earcut.removeNode(last);
			last=last.next;
		}
		return last;
	}

	Earcut.filterPoints=function(start,end){
		if (!start)return start;
		if (!end)end=start;
		var p=start,
		again;
		do {
			again=false;
			if (!p.steiner && (Earcut.equals(p,p.next)|| Earcut.area(p.prev,p,p.next)===0)){
				Earcut.removeNode(p);
				p=end=p.prev;
				if (p===p.next)break ;
				again=true;
				}else {
				p=p.next;
			}
		}while (again || p!==end);
		return end;
	}

	Earcut.earcutLinked=function(ear,triangles,dim,minX,minY,invSize,pass){
		if (!ear)return;
		if (!pass && invSize)Earcut.indexCurve(ear,minX,minY,invSize);
		var stop=ear,
		prev,next;
		while (ear.prev!==ear.next){
			prev=ear.prev;
			next=ear.next;
			if (invSize ? Earcut.isEarHashed(ear,minX,minY,invSize):Earcut.isEar(ear)){
				triangles.push(prev.i / dim);
				triangles.push(ear.i / dim);
				triangles.push(next.i / dim);
				Earcut.removeNode(ear);
				ear=next.next;
				stop=next.next;
				continue ;
			}
			ear=next;
			if (ear===stop){
				if (!pass){
					Earcut.earcutLinked(Earcut.filterPoints(ear,null),triangles,dim,minX,minY,invSize,1);
					}else if (pass===1){
					ear=Earcut.cureLocalIntersections(ear,triangles,dim);
					Earcut.earcutLinked(ear,triangles,dim,minX,minY,invSize,2);
					}else if (pass===2){
					Earcut.splitEarcut(ear,triangles,dim,minX,minY,invSize);
				}
				break ;
			}
		}
	}

	Earcut.isEar=function(ear){
		var a=ear.prev,
		b=ear,
		c=ear.next;
		if (Earcut.area(a,b,c)>=0)return false;
		var p=ear.next.next;
		while (p!==ear.prev){
			if (Earcut.pointInTriangle(a.x,a.y,b.x,b.y,c.x,c.y,p.x,p.y)&&
				Earcut.area(p.prev,p,p.next)>=0)return false;
			p=p.next;
		}
		return true;
	}

	Earcut.isEarHashed=function(ear,minX,minY,invSize){
		var a=ear.prev,
		b=ear,
		c=ear.next;
		if (Earcut.area(a,b,c)>=0)return false;
		var minTX=a.x < b.x ? (a.x < c.x ? a.x :c.x):(b.x < c.x ? b.x :c.x),
		minTY=a.y < b.y ? (a.y < c.y ? a.y :c.y):(b.y < c.y ? b.y :c.y),
		maxTX=a.x > b.x ? (a.x > c.x ? a.x :c.x):(b.x > c.x ? b.x :c.x),
		maxTY=a.y > b.y ? (a.y > c.y ? a.y :c.y):(b.y > c.y ? b.y :c.y);
		var minZ=Earcut.zOrder(minTX,minTY,minX,minY,invSize),
		maxZ=Earcut.zOrder(maxTX,maxTY,minX,minY,invSize);
		var p=ear.nextZ;
		while (p && p.z <=maxZ){
			if (p!==ear.prev && p!==ear.next &&
				Earcut.pointInTriangle(a.x,a.y,b.x,b.y,c.x,c.y,p.x,p.y)&&
			Earcut.area(p.prev,p,p.next)>=0)return false;
			p=p.nextZ;
		}
		p=ear.prevZ;
		while (p && p.z >=minZ){
			if (p!==ear.prev && p!==ear.next &&
				Earcut.pointInTriangle(a.x,a.y,b.x,b.y,c.x,c.y,p.x,p.y)&&
			Earcut.area(p.prev,p,p.next)>=0)return false;
			p=p.prevZ;
		}
		return true;
	}

	Earcut.cureLocalIntersections=function(start,triangles,dim){
		var p=start;
		do {
			var a=p.prev,
			b=p.next.next;
			if (!Earcut.equals(a,b)&& Earcut.intersects(a,p,p.next,b)&& Earcut.locallyInside(a,b)&& Earcut.locallyInside(b,a)){
				triangles.push(a.i / dim);
				triangles.push(p.i / dim);
				triangles.push(b.i / dim);
				Earcut.removeNode(p);
				Earcut.removeNode(p.next);
				p=start=b;
			}
			p=p.next;
		}while (p!==start);
		return p;
	}

	Earcut.splitEarcut=function(start,triangles,dim,minX,minY,invSize){
		var a=start;
		do {
			var b=a.next.next;
			while (b!==a.prev){
				if (a.i!==b.i && Earcut.isValidDiagonal(a,b)){
					var c=Earcut.splitPolygon(a,b);
					a=Earcut.filterPoints(a,a.next);
					c=Earcut.filterPoints(c,c.next);
					Earcut.earcutLinked(a,triangles,dim,minX,minY,invSize);
					Earcut.earcutLinked(c,triangles,dim,minX,minY,invSize);
					return;
				}
				b=b.next;
			}
			a=a.next;
		}while (a!==start);
	}

	Earcut.eliminateHoles=function(data,holeIndices,outerNode,dim){
		var queue=[],
		i,len,start,end,list;
		for (i=0,len=holeIndices.length;i < len;i++){
			start=holeIndices[i] *dim;
			end=i < len-1 ? holeIndices[i+1] *dim :data.length;
			list=Earcut.linkedList(data,start,end,dim,false);
			if (list===list.next)list.steiner=true;
			queue.push(Earcut.getLeftmost(list));
		}
		queue.sort(Earcut.compareX);
		for (i=0;i < queue.length;i++){
			Earcut.eliminateHole(queue[i],outerNode);
			outerNode=Earcut.filterPoints(outerNode,outerNode.next);
		}
		return outerNode;
	}

	Earcut.compareX=function(a,b){
		return a.x-b.x;
	}

	Earcut.eliminateHole=function(hole,outerNode){
		outerNode=Earcut.findHoleBridge(hole,outerNode);
		if (outerNode){
			var b=Earcut.splitPolygon(outerNode,hole);
			Earcut.filterPoints(b,b.next);
		}
	}

	Earcut.findHoleBridge=function(hole,outerNode){
		var p=outerNode,
		hx=hole.x,
		hy=hole.y,
		qx=-Infinity,
		m;
		do {
			if (hy <=p.y && hy >=p.next.y && p.next.y!==p.y){
				var x=p.x+(hy-p.y)*(p.next.x-p.x)/ (p.next.y-p.y);
				if (x <=hx && x > qx){
					qx=x;
					if (x===hx){
						if (hy===p.y)return p;
						if (hy===p.next.y)return p.next;
					}
					m=p.x < p.next.x ? p :p.next;
				}
			}
			p=p.next;
		}while (p!==outerNode);
		if (!m)return null;
		if (hx===qx)return m.prev;
		var stop=m,
		mx=m.x,
		my=m.y,
		tanMin=Infinity,
		tan;
		p=m.next;
		while (p!==stop){
			if (hx >=p.x && p.x >=mx && hx!==p.x &&
				Earcut.pointInTriangle(hy < my ? hx :qx,hy,mx,my,hy < my ? qx :hx,hy,p.x,p.y)){
				tan=Math.abs(hy-p.y)/ (hx-p.x);
				if ((tan < tanMin || (tan===tanMin && p.x > m.x))&& Earcut.locallyInside(p,hole)){
					m=p;
					tanMin=tan;
				}
			}
			p=p.next;
		}
		return m;
	}

	Earcut.indexCurve=function(start,minX,minY,invSize){
		var p=start;
		do {
			if (p.z===null)p.z=Earcut.zOrder(p.x,p.y,minX,minY,invSize);
			p.prevZ=p.prev;
			p.nextZ=p.next;
			p=p.next;
		}while (p!==start);
		p.prevZ.nextZ=null;
		p.prevZ=null;
		Earcut.sortLinked(p);
	}

	Earcut.sortLinked=function(list){
		var i,p,q,e,tail,numMerges,pSize,qSize,
		inSize=1;
		do {
			p=list;
			list=null;
			tail=null;
			numMerges=0;
			while (p){
				numMerges++;
				q=p;
				pSize=0;
				for (i=0;i < inSize;i++){
					pSize++;
					q=q.nextZ;
					if (!q)break ;
				}
				qSize=inSize;
				while (pSize > 0 || (qSize > 0 && q)){
					if (pSize!==0 && (qSize===0 || !q || p.z <=q.z)){
						e=p;
						p=p.nextZ;
						pSize--;
						}else {
						e=q;
						q=q.nextZ;
						qSize--;
					}
					if (tail)tail.nextZ=e;
					else list=e;
					e.prevZ=tail;
					tail=e;
				}
				p=q;
			}
			tail.nextZ=null;
			inSize *=2;
		}while (numMerges > 1);
		return list;
	}

	Earcut.zOrder=function(x,y,minX,minY,invSize){
		x=32767 *(x-minX)*invSize;
		y=32767 *(y-minY)*invSize;
		x=(x | (x << 8))& 0x00FF00FF;
		x=(x | (x << 4))& 0x0F0F0F0F;
		x=(x | (x << 2))& 0x33333333;
		x=(x | (x << 1))& 0x55555555;
		y=(y | (y << 8))& 0x00FF00FF;
		y=(y | (y << 4))& 0x0F0F0F0F;
		y=(y | (y << 2))& 0x33333333;
		y=(y | (y << 1))& 0x55555555;
		return x | (y << 1);
	}

	Earcut.getLeftmost=function(start){
		var p=start,
		leftmost=start;
		do {
			if (p.x < leftmost.x)leftmost=p;
			p=p.next;
		}while (p!==start);
		return leftmost;
	}

	Earcut.pointInTriangle=function(ax,ay,bx,by,cx,cy,px,py){
		return (cx-px)*(ay-py)-(ax-px)*(cy-py)>=0 &&
		(ax-px)*(by-py)-(bx-px)*(ay-py)>=0 &&
		(bx-px)*(cy-py)-(cx-px)*(by-py)>=0;
	}

	Earcut.isValidDiagonal=function(a,b){
		return a.next.i!==b.i && a.prev.i!==b.i && !Earcut.intersectsPolygon(a,b)&&
		Earcut.locallyInside(a,b)&& Earcut.locallyInside(b,a)&& Earcut.middleInside(a,b);
	}

	Earcut.area=function(p,q,r){
		return (q.y-p.y)*(r.x-q.x)-(q.x-p.x)*(r.y-q.y);
	}

	Earcut.equals=function(p1,p2){
		return p1.x===p2.x && p1.y===p2.y;
	}

	Earcut.intersects=function(p1,q1,p2,q2){
		if ((Earcut.equals(p1,q1)&& Earcut.equals(p2,q2))||
			(Earcut.equals(p1,q2)&& Earcut.equals(p2,q1)))return true;
		return Earcut.area(p1,q1,p2)> 0!==Earcut.area(p1,q1,q2)> 0 &&
		Earcut.area(p2,q2,p1)> 0!==Earcut.area(p2,q2,q1)> 0;
	}

	Earcut.intersectsPolygon=function(a,b){
		var p=a;
		do {
			if (p.i!==a.i && p.next.i!==a.i && p.i!==b.i && p.next.i!==b.i &&
				Earcut.intersects(p,p.next,a,b))return true;
			p=p.next;
		}while (p!==a);
		return false;
	}

	Earcut.locallyInside=function(a,b){
		return Earcut.area(a.prev,a,a.next)< 0 ?
		Earcut.area(a,b,a.next)>=0 && Earcut.area(a,a.prev,b)>=0 :
		Earcut.area(a,b,a.prev)< 0 || Earcut.area(a,a.next,b)< 0;
	}

	Earcut.middleInside=function(a,b){
		var p=a,
		inside=false,
		px=(a.x+b.x)/ 2,
		py=(a.y+b.y)/ 2;
		do {
			if (((p.y > py)!==(p.next.y > py))&& p.next.y!==p.y &&
				(px < (p.next.x-p.x)*(py-p.y)/ (p.next.y-p.y)+p.x))
			inside=!inside;
			p=p.next;
		}while (p!==a);
		return inside;
	}

	Earcut.splitPolygon=function(a,b){
		var a2=new EarcutNode(a.i,a.x,a.y),
		b2=new EarcutNode(b.i,b.x,b.y),
		an=a.next,
		bp=b.prev;
		a.next=b;
		b.prev=a;
		a2.next=an;
		an.prev=a2;
		b2.next=a2;
		a2.prev=b2;
		bp.next=b2;
		b2.prev=bp;
		return b2;
	}

	Earcut.insertNode=function(i,x,y,last){
		var p=new EarcutNode(i,x,y);
		if (!last){
			p.prev=p;
			p.next=p;
			}else {
			p.next=last.next;
			p.prev=last;
			last.next.prev=p;
			last.next=p;
		}
		return p;
	}

	Earcut.removeNode=function(p){
		p.next.prev=p.prev;
		p.prev.next=p.next;
		if (p.prevZ)p.prevZ.nextZ=p.nextZ;
		if (p.nextZ)p.nextZ.prevZ=p.prevZ;
	}

	Earcut.signedArea=function(data,start,end,dim){
		var sum=0;
		for (var i=start,j=end-dim;i < end;i+=dim){
			sum+=(data[j]-data[i])*(data[i+1]+data[j+1]);
			j=i;
		}
		return sum;
	}

	return Earcut;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.AlphaCmdNative
var AlphaCmdNative=(function(){
	function AlphaCmdNative(){
		//this._graphicsCmdEncoder=null;
		//this._alpha=NaN;
		this._paramData=/*__JS__ */new ParamData(4,true);
	}

	__class(AlphaCmdNative,'laya.layagl.cmdNative.AlphaCmdNative');
	var __proto=AlphaCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("AlphaCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.alpha(this._alpha);
	}

	__getset(0,__proto,'cmdID',function(){
		return "Alpha";
	});

	__getset(0,__proto,'alpha',function(){
		return this._alpha;
		},function(value){
		value=value > 1 ? 1:value;
		value=value < 0 ? 0:value;
		this._alpha=value;
		var nColor=0x00ffffff;
		nColor=((value *255)<< 24)| nColor;
		this._paramData._int32Data[0]=nColor;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	AlphaCmdNative.create=function(alpha){
		var cmd=Pool.getItemByClass("AlphaCmd",AlphaCmdNative);
		var cbuf=cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;
		cmd.alpha=alpha;
		cbuf.setGlobalValueEx(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15,cmd._paramData.getPtrID(),0);
		LayaGL.syncBufferToRenderThread(cbuf);
		return cmd;
	}

	AlphaCmdNative.ID="Alpha";
	return AlphaCmdNative;
})()


//class laya.webgl.submit.Submit
var Submit=(function(){
	function Submit(renderType){
		this.clipInfoID=-1;
		//用来比较clipinfo
		//this._mesh=null;
		//代替 _vb,_ib
		//this._blendFn=null;
		//this._id=0;
		//protected var _isSelfVb:Boolean=false;
		//this._renderType=0;
		//this._parent=null;
		// 从VB中什么地方开始画，画到哪
		//this._startIdx=0;
		//indexbuffer 的偏移，单位是byte
		this._numEle=0;
		this._ref=1;
		//this.shaderValue=null;
		this._key=new SubmitKey();
		(renderType===void 0)&& (renderType=10000);
		this._renderType=renderType;
		this._id=++Submit.ID;
	}

	__class(Submit,'laya.webgl.submit.Submit');
	var __proto=Submit.prototype;
	Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
	//TODO:coverage
	__proto.getID=function(){
		return this._id;
	}

	__proto.releaseRender=function(){
		if (Submit.RENDERBASE==this)
			return;
		if((--this._ref)<1){
			Submit.POOL[Submit._poolSize++]=this;
			this.shaderValue.release();
			this.shaderValue=null;
			this._mesh=null;
			this._parent && (this._parent.releaseRender(),this._parent=null);
		}
	}

	//TODO:coverage
	__proto.getRenderType=function(){
		return this._renderType;
	}

	__proto.renderSubmit=function(){
		if (this._numEle===0 || !this._mesh || this._numEle==0)return 1;
		var _tex=this.shaderValue.textureHost;
		if (_tex){
			var source=_tex._getSource();
			if (!source)
				return 1;
			this.shaderValue.texture=source;
		};
		var gl=WebGL.mainContext;
		this._mesh.useMesh(gl);
		this.shaderValue.upload();
		if (BlendMode.activeBlendFunction!==this._blendFn){
			WebGLContext.setBlend(gl,true);
			this._blendFn(gl);
			BlendMode.activeBlendFunction=this._blendFn;
		}
		gl.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,this._numEle,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,this._startIdx);
		Stat.renderBatch++;
		Stat.trianglesFaces+=this._numEle / 3;
		return 1;
	}

	//TODO:coverage
	__proto._cloneInit=function(o,context,mesh,pos){;
		o._ref=1;
		o._mesh=mesh;
		o._id=this._id;
		o._key.copyFrom(this._key);
		o._parent=this;
		o._blendFn=this._blendFn;
		o._renderType=this._renderType;
		o._startIdx=pos *CONST3D2D.BYTES_PIDX;
		o._numEle=this._numEle;
		o.shaderValue=this.shaderValue;
		this.shaderValue.ref++;
		this._ref++;
	}

	//TODO:coverage
	__proto.clone=function(context,mesh,pos){;
		return null;
	}

	//TODO:coverage
	__proto.reUse=function(context,pos){;
		return 0;
	}

	//TODO:coverage
	__proto.toString=function(){
		return "ibindex:"+this._startIdx+" num:"+this._numEle+" key="+this._key;
	}

	Submit.__init__=function(){
		var s=Submit.RENDERBASE=new Submit(-1);
		s.shaderValue=new Value2D(0,0);
		s.shaderValue.ALPHA=1;
		s._ref=0xFFFFFFFF;
	}

	Submit.create=function(context,mesh,sv){;
		var o=Submit._poolSize ? Submit.POOL[--Submit._poolSize] :new Submit();
		o._ref=1;
		o._mesh=mesh;
		o._key.clear();
		o._startIdx=mesh.indexNum *CONST3D2D.BYTES_PIDX;
		o._numEle=0;
		var blendType=context._nBlendType;
		o._blendFn=context._targets ? BlendMode.targetFns[blendType] :BlendMode.fns[blendType];
		o.shaderValue=sv;
		o.shaderValue.setValue(context._shader2D);
		var filters=context._shader2D.filters;
		filters && o.shaderValue.setFilters(filters);
		return o;
	}

	Submit.createShape=function(ctx,mesh,numEle,sv){
		var o=Submit._poolSize ? Submit.POOL[--Submit._poolSize]:(new Submit());
		o._mesh=mesh;
		o._numEle=numEle;
		o._startIdx=mesh.indexNum *2;
		o._ref=1;
		o.shaderValue=sv;
		o.shaderValue.setValue(ctx._shader2D);
		var blendType=ctx._nBlendType;
		o._key.blendShader=blendType;
		o._blendFn=ctx._targets ? BlendMode.targetFns[blendType] :BlendMode.fns[blendType];
		return o;
	}

	Submit.TYPE_2D=10000;
	Submit.TYPE_CANVAS=10003;
	Submit.TYPE_CMDSETRT=10004;
	Submit.TYPE_CUSTOM=10005;
	Submit.TYPE_BLURRT=10006;
	Submit.TYPE_CMDDESTORYPRERT=10007;
	Submit.TYPE_DISABLESTENCIL=10008;
	Submit.TYPE_OTHERIBVB=10009;
	Submit.TYPE_PRIMITIVE=10010;
	Submit.TYPE_RT=10011;
	Submit.TYPE_BLUR_RT=10012;
	Submit.TYPE_TARGET=10013;
	Submit.TYPE_CHANGE_VALUE=10014;
	Submit.TYPE_SHAPE=10015;
	Submit.TYPE_TEXTURE=10016;
	Submit.TYPE_FILLTEXTURE=10017;
	Submit.KEY_ONCE=-1;
	Submit.KEY_FILLRECT=1;
	Submit.KEY_DRAWTEXTURE=2;
	Submit.KEY_VG=3;
	Submit.KEY_TRIANGLES=4;
	Submit.RENDERBASE=null;
	Submit.ID=1;
	Submit.preRender=null;
	Submit._poolSize=0;
	Submit.POOL=[];
	return Submit;
})()


//class laya.webgl.utils.CONST3D2D
var CONST3D2D=(function(){
	function CONST3D2D(){}
	__class(CONST3D2D,'laya.webgl.utils.CONST3D2D');
	CONST3D2D.BYTES_PE=4;
	CONST3D2D.BYTES_PIDX=2;
	CONST3D2D.defaultMatrix4=[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];
	CONST3D2D.defaultMinusYMatrix4=[1,0,0,0,0,-1,0,0,0,0,1,0,0,0,0,1];
	CONST3D2D.uniformMatrix3=[1,0,0,0,0,1,0,0,0,0,1,0];
	CONST3D2D._TMPARRAY=[];
	CONST3D2D._OFFSETX=0;
	CONST3D2D._OFFSETY=0;
	return CONST3D2D;
})()


/**
*@private
*/
//class laya.webgl.WebGL
var WebGL=(function(){
	function WebGL(){}
	__class(WebGL,'laya.webgl.WebGL');
	WebGL._uint8ArraySlice=function(){
		var _this=/*__JS__ */this;
		var sz=_this.length;
		var dec=new Uint8Array(_this.length);
		for (var i=0;i < sz;i++)dec[i]=_this[i];
		return dec;
	}

	WebGL._float32ArraySlice=function(){
		var _this=/*__JS__ */this;
		var sz=_this.length;
		var dec=new Float32Array(_this.length);
		for (var i=0;i < sz;i++)dec[i]=_this[i];
		return dec;
	}

	WebGL._uint16ArraySlice=function(__arg){
		var arg=arguments;
		var _this=/*__JS__ */this;
		var sz=0;
		var dec;
		var i=0;
		if (arg.length===0){
			sz=_this.length;
			dec=new Uint16Array(sz);
			for (i=0;i < sz;i++)
			dec[i]=_this[i];
			}else if (arg.length===2){
			var start=arg[0];
			var end=arg[1];
			if (end > start){
				sz=end-start;
				dec=new Uint16Array(sz);
				for (i=start;i < end;i++)
				dec[i-start]=_this[i];
				}else {
				dec=new Uint16Array(0);
			}
		}
		return dec;
	}

	WebGL._nativeRender_enable=function(){
		if (WebGL.isNativeRender_enable)
			return;
		WebGL.isNativeRender_enable=true;
		HTMLImage.create=function (width,height){
			var tex=new Texture2D(width,height,/*laya.webgl.resource.BaseTexture.FORMAT_R8G8B8A8*/1,false,false);
			tex.wrapModeU=/*laya.webgl.resource.BaseTexture.WARPMODE_CLAMP*/1;
			tex.wrapModeV=/*laya.webgl.resource.BaseTexture.WARPMODE_CLAMP*/1;
			return tex;
		}
		WebGLContext.__init_native();
		RenderState2D.width=Browser.window.innerWidth;
		RenderState2D.height=Browser.window.innerHeight;
		RunDriver.measureText=function (txt,font){
			window["conchTextCanvas"].font=font;
			return window["conchTextCanvas"].measureText(txt);
		}
		RunDriver.enableNative=function (){
			(LayaGLRunner).uploadShaderUniforms=LayaGLRunner.uploadShaderUniformsForNative;
			var stage=Stage;
			stage.prototype.repaint=stage.prototype.repaintForNative;
			stage.prototype.render=stage.prototype.renderToNative;
			var bufferStateBase=BufferStateBase;
			bufferStateBase.prototype.bind=BufferStateBase.prototype.bindForNative;
			bufferStateBase.prototype.unBind=BufferStateBase.prototype.unBindForNative;
			if (Render.isConchApp){
				/*__JS__ */CommandEncoder=window.GLCommandEncoder;
				/*__JS__ */LayaGL=window.LayaGLContext;
				var prototypeContext=/*__JS__ */window.CanvasRenderingContext.prototype;
				var protoLast=LayaGLRenderingContext.prototype;
				/*__JS__ */LayaGLRenderingContext=window.CanvasRenderingContext;
				prototypeContext.drawImage=protoLast.drawImage;
				prototypeContext.drawTexture=protoLast.drawTexture;
				prototypeContext.fillText=protoLast.fillText;
				prototypeContext.save=protoLast.save;
				prototypeContext.restore=protoLast.restore;
				prototypeContext.translate=protoLast.translate;
				prototypeContext.scale=protoLast.scale;
				prototypeContext.rotate=protoLast.rotate;
				prototypeContext.transform=protoLast.transform;
				prototypeContext.beginRT=protoLast.beginRT;
				prototypeContext.endRT=protoLast.endRT;
				prototypeContext.drawCanvas=protoLast.drawCanvas;
				prototypeContext.drawTarget=protoLast.drawTarget;
				prototypeContext._$get_asBitmap=protoLast._$get_asBitmap;
				prototypeContext._$set_asBitmap=protoLast._$set_asBitmap;
				prototypeContext.toBase64=protoLast.toBase64;
				prototypeContext.getImageData=protoLast.getImageData;
				/*__JS__ */__getset (0,prototypeContext,'asBitmap',prototypeContext._$get_asBitmap,prototypeContext._$set_asBitmap);
				ConchPropertyAdpt.rewriteProperties();
			}
			ConchSpriteAdpt.init();
			LayaNative2D.__init__();
		}
		RunDriver.clear=function (color){
			var c=ColorUtils.create(color).arrColor;
			var gl=LayaGL.instance;
			if (c)gl.clearColor(c[0],c[1],c[2],c[3]);
			gl.clear(/*laya.webgl.WebGLContext.COLOR_BUFFER_BIT*/0x00004000 | /*laya.webgl.WebGLContext.DEPTH_BUFFER_BIT*/0x00000100 | /*laya.webgl.WebGLContext.STENCIL_BUFFER_BIT*/0x00000400);
		}
		RunDriver.drawToCanvas=function (sprite,_renderType,canvasWidth,canvasHeight,offsetX,offsetY){
			var canvas=new HTMLCanvas(true);
			canvas.size(canvasWidth,canvasHeight);
			var context=canvas.getContext("2d");
			context.asBitmap=true;
			var canvasCmd=LayaGL.instance.createCommandEncoder(128,64,false);
			canvasCmd.beginEncoding();
			canvasCmd.clearEncoding();
			var layagl=LayaGL.instance;
			var lastContext=layagl.getCurrentContext();
			layagl.setCurrentContext(context);
			context.beginRT();
			layagl.save();
			var temp=ConchSpriteAdpt._tempFloatArrayMatrix;
			temp[0]=1;
			temp[1]=0;
			temp[2]=0;
			temp[3]=1;
			temp[4]=offsetX;
			temp[5]=offsetY;
			layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_MATRIX32,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,temp);
			(sprite).writeBlockToNative();
			layagl.restore();
			layagl.setCurrentContext(lastContext);
			layagl.commitContextToGPU(context);
			context.endRT();
			canvasCmd.endEncoding();
			layagl.useCommandEncoder(canvasCmd.getPtrID(),-1,0);
			return canvas;
		}
		HTMLCanvas.prototype.getTexture=function (){
			if (!this._texture){
				this._texture=this.context._targets;
				this._texture.uv=RenderTexture2D.flipyuv;
				this._texture.bitmap=this._texture;
			}
			return this._texture;
		}
	}

	WebGL._webglRender_enable=function(){
		if (Render.isWebGL)return;
		Render.isWebGL=true;
		RunDriver.initRender=function (canvas,w,h){
			function getWebGLContext (canvas){
				var gl;
				var names=["webgl2","webgl","experimental-webgl","webkit-3d","moz-webgl"];
				if (!Config.useWebGL2){
					names.shift();
				}
				for (var i=0;i < names.length;i++){
					try {
						gl=canvas.getContext(names[i],{stencil:Config.isStencil,alpha:Config.isAlpha,antialias:Config.isAntialias,premultipliedAlpha:Config.premultipliedAlpha,preserveDrawingBuffer:Config.preserveDrawingBuffer});
					}catch (e){}
					if (gl){
						(names[i]==='webgl2')&& (laya.webgl.WebGL._isWebGL2=true);
						new LayaGL();
						return gl;
					}
				}
				return null;
			};
			var gl=LayaGL.instance=laya.webgl.WebGL.mainContext=getWebGLContext(Render._mainCanvas.source);
			if (!gl)
				return false;
			canvas.size(w,h);
			WebGLContext.__init__(gl);
			WebGLContext2D.__init__();
			Submit.__init__();
			var ctx=new WebGLContext2D();
			Render._context=ctx;
			canvas._setContext(ctx);
			laya.webgl.WebGL.shaderHighPrecision=false;
			try {
				var precisionFormat=gl.getShaderPrecisionFormat(/*laya.webgl.WebGLContext.FRAGMENT_SHADER*/0x8B30,/*laya.webgl.WebGLContext.HIGH_FLOAT*/0x8DF2);
				precisionFormat.precision ? WebGL.shaderHighPrecision=true :WebGL.shaderHighPrecision=false;
			}catch (e){}
			LayaGL.instance=gl;
			System.__init__();
			ShaderDefines2D.__init__();
			Value2D.__init__();
			Shader2D.__init__();
			Buffer2D.__int__(gl);
			BlendMode._init_(gl);
			return true;
		}
		HTMLImage.create=function (width,height){
			var tex=new Texture2D(width,height,/*laya.webgl.resource.BaseTexture.FORMAT_R8G8B8A8*/1,false,false);
			tex.wrapModeU=/*laya.webgl.resource.BaseTexture.WARPMODE_CLAMP*/1;
			tex.wrapModeV=/*laya.webgl.resource.BaseTexture.WARPMODE_CLAMP*/1;
			return tex;
		}
		RunDriver.createRenderSprite=function (type,next){
			return new RenderSprite3D(type,next);
		}
		RunDriver.changeWebGLSize=function (width,height){
			laya.webgl.WebGL.onStageResize(width,height);
		}
		RunDriver.clear=function (color){
			WebGLContext2D.set2DRenderConfig();
			RenderState2D.worldScissorTest && laya.webgl.WebGL.mainContext.disable(/*laya.webgl.WebGLContext.SCISSOR_TEST*/0x0C11);
			var ctx=Render.context;
			var c=(ctx._submits._length==0 || Config.preserveDrawingBuffer)? ColorUtils.create(color).arrColor :Laya.stage._wgColor;
			if (c)ctx.clearBG(c[0],c[1],c[2],c[3]);
			RenderState2D.clear();
		}
		RunDriver.drawToCanvas=function (sprite,_renderType,canvasWidth,canvasHeight,offsetX,offsetY){
			offsetX-=sprite.x;
			offsetY-=sprite.y;
			offsetX |=0;
			offsetY |=0;
			canvasWidth |=0;
			canvasHeight |=0;
			var ctx=new WebGLContext2D();
			ctx.size(canvasWidth,canvasHeight);
			ctx.asBitmap=true;
			ctx._targets.start();
			RenderSprite.renders[_renderType]._fun(sprite,ctx,offsetX,offsetY);
			ctx.flush();
			ctx._targets.end();
			ctx._targets.restore();
			var dt=ctx._targets.getData(0,0,canvasWidth,canvasHeight);
			ctx.destroy();
			var imgdata=/*__JS__ */new ImageData(canvasWidth,canvasHeight);;
			var lineLen=canvasWidth *4;
			var temp=new Uint8Array(lineLen);
			var dst=imgdata.data;
			var y=canvasHeight-1;
			var off=y *lineLen;
			var srcoff=0;
			for (;y >=0;y--){
				dst.set(dt.subarray(srcoff,srcoff+lineLen),off);
				off-=lineLen;
				srcoff+=lineLen;
			};
			var canv=new HTMLCanvas(true);
			canv.size(canvasWidth,canvasHeight);
			var ctx2d=canv.getContext('2d');
			/*__JS__ */ctx2d.putImageData(imgdata,0,0);;
			return canv;
		}
		RunDriver.getTexturePixels=function (value,x,y,width,height){
			var st=0,dst=0,i=0;
			var tex2d=value.bitmap;
			var texw=tex2d.width;
			var texh=tex2d.height;
			if (x+width > texw)width-=(x+width)-texw;
			if (y+height > texh)height-=(y+height)-texh;
			if (width <=0 || height <=0)return null;
			var wstride=width *4;
			var pix=null;
			try {
				pix=tex2d.getPixels();
			}catch (e){}
			if (pix){
				if(x==0&&y==0&&width==texw&&height==texh)
					return pix;
				var ret=new Uint8Array(width *height *4);
				wstride=texw *4;
				st=x*4;
				dst=(y+height-1)*wstride+x*4;
				for (i=height-1;i >=0;i--){
					ret.set(dt.slice(dst,dst+width*4),st);
					st+=wstride;
					dst-=wstride;
				}
				return ret;
			};
			var ctx=new WebGLContext2D();
			ctx.size(width,height);
			ctx.asBitmap=true;
			var uv=null;
			if (x !=0 || y !=0 || width !=texw || height !=texh){
				uv=value.uv.concat();
				var stu=uv[0];
				var stv=uv[1];
				var uvw=uv[2]-stu;
				var uvh=uv[7]-stv;
				var uk=uvw / texw;
				var vk=uvh / texh;
				uv=[
				stu+x *uk,stv+y *vk,
				stu+(x+width)*uk,stv+y *vk,
				stu+(x+width)*uk,stv+(y+height)*vk,
				stu+x *uk,stv+(y+height)*vk,];
			}
			(ctx)._drawTextureM(value,0,0,width,height,null,1.0,uv);
			ctx._targets.start();
			ctx.flush();
			ctx._targets.end();
			ctx._targets.restore();
			var dt=ctx._targets.getData(0,0,width,height);
			ctx.destroy();
			ret=new Uint8Array(width *height *4);
			st=0;
			dst=(height-1)*wstride;
			for (i=height-1;i >=0;i--){
				ret.set(dt.slice(dst,dst+wstride),st);
				st+=wstride;
				dst-=wstride;
			}
			return ret;
		}
		Filter._filter=function (sprite,context,x,y){
			var webglctx=context;
			var next=this._next;
			if (next){
				var filters=sprite.filters,len=filters.length;
				if (len==1 && (filters[0].type==/*laya.filters.Filter.COLOR*/0x20)){
					context.save();
					context.setColorFilter(filters[0]);
					next._fun.call(next,sprite,context,x,y);
					context.restore();
					return;
				};
				var svCP=Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0);
				var b;
				var p=Point.TEMP;
				var tMatrix=webglctx._curMat;
				var mat=Matrix.create();
				tMatrix.copyTo(mat);
				var tPadding=0;
				var tHalfPadding=0;
				var tIsHaveGlowFilter=false;
				var source=null;
				var out=sprite._cacheStyle.filterCache || null;
				if (!out || sprite.getRepaint()!=0){
					tIsHaveGlowFilter=sprite._isHaveGlowFilter();
					if (tIsHaveGlowFilter){
						tPadding=50;
						tHalfPadding=25;
					}
					b=new Rectangle();
					b.copyFrom(sprite.getSelfBounds());
					b.x+=sprite.x;
					b.y+=sprite.y;
					b.x-=sprite.pivotX+4;
					b.y-=sprite.pivotY+4;
					var tSX=b.x;
					var tSY=b.y;
					b.width+=(tPadding+8);
					b.height+=(tPadding+8);
					p.x=b.x *mat.a+b.y *mat.c;
					p.y=b.y *mat.d+b.x *mat.b;
					b.x=p.x;
					b.y=p.y;
					p.x=b.width *mat.a+b.height *mat.c;
					p.y=b.height *mat.d+b.width *mat.b;
					b.width=p.x;
					b.height=p.y;
					if (b.width <=0 || b.height <=0){
						return;
					}
					out && WebGLRTMgr.releaseRT(out);
					source=WebGLRTMgr.getRT(b.width,b.height);
					var outRT=out=WebGLRTMgr.getRT(b.width,b.height);
					sprite._getCacheStyle().filterCache=out;
					webglctx.pushRT();
					webglctx.useRT(source);
					var tX=sprite.x-tSX+tHalfPadding;
					var tY=sprite.y-tSY+tHalfPadding;
					next._fun.call(next,sprite,context,tX,tY);
					webglctx.useRT(outRT);
					for (var i=0;i < len;i++){
						if (i !=0){
							webglctx.useRT(source);
							webglctx.drawTarget(outRT,0,0,b.width,b.height,Matrix.TEMP.identity(),svCP,null,BlendMode.TOINT.overlay);
							webglctx.useRT(outRT);
						};
						var fil=filters[i];
						switch (fil.type){
							case /*laya.filters.Filter.BLUR*/0x10:
								fil._glRender && fil._glRender.render(source,context,b.width,b.height,fil);
								break ;
							case /*laya.filters.Filter.GLOW*/0x08:
								fil._glRender && fil._glRender.render(source,context,b.width,b.height,fil);
								break ;
							case /*laya.filters.Filter.COLOR*/0x20:
								webglctx.setColorFilter(fil);
								webglctx.drawTarget(source,0,0,b.width,b.height,Matrix.EMPTY.identity(),Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0));
								webglctx.setColorFilter(null);
								break ;
							}
					}
					webglctx.popRT();
					}else {
					tIsHaveGlowFilter=sprite._cacheStyle.hasGlowFilter || false;
					if (tIsHaveGlowFilter){
						tPadding=50;
						tHalfPadding=25;
					}
					b=sprite.getBounds();
					if (b.width <=0 || b.height <=0){
						return;
					}
					b.width+=tPadding;
					b.height+=tPadding;
					p.x=b.x *mat.a+b.y *mat.c;
					p.y=b.y *mat.d+b.x *mat.b;
					b.x=p.x;
					b.y=p.y;
					p.x=b.width *mat.a+b.height *mat.c;
					p.y=b.height *mat.d+b.width *mat.b;
					b.width=p.x;
					b.height=p.y;
				}
				x=x-tHalfPadding-sprite.x;
				y=y-tHalfPadding-sprite.y;
				p.setTo(x,y);
				mat.transformPoint(p);
				x=p.x+b.x;
				y=p.y+b.y;
				webglctx._drawRenderTexture(out,x,y,b.width,b.height,Matrix.TEMP.identity(),1.0,RenderTexture2D.defuv);
				if(source){
					var submit=SubmitCMD.create([source],function(s){
						s.destroy();
					},this);
					source=null;
					context.addRenderObject(submit);
				}
				mat.destroy();
			}
		}
		HTMLCanvas.prototype.getTexture=function (){
			if (!this._texture){
				var bitmap=new Texture2D();
				bitmap.loadImageSource(this.source);
				this._texture=new Texture(bitmap);
			}
			return this._texture;
		}
		Float32Array.prototype.slice || (Float32Array.prototype.slice=WebGL._float32ArraySlice);
		Uint16Array.prototype.slice || (Uint16Array.prototype.slice=WebGL._uint16ArraySlice);
		Uint8Array.prototype.slice || (Uint8Array.prototype.slice=WebGL._uint8ArraySlice);
	}

	WebGL.enable=function(){
		Browser.__init__();
		if (!Browser._supportWebGL)
			return false;
		if (Render.isConchApp){
			WebGL._nativeRender_enable();
			}else {
			WebGL._webglRender_enable();
		}
		return true;
	}

	WebGL.onStageResize=function(width,height){
		if (WebGL.mainContext==null)return;
		WebGL.mainContext.viewport(0,0,width,height);
		RenderState2D.width=width;
		RenderState2D.height=height;
	}

	WebGL.mainContext=null;
	WebGL.shaderHighPrecision=false;
	WebGL._isWebGL2=false;
	WebGL.isNativeRender_enable=false;
	return WebGL;
})()


//class laya.webgl.canvas.BlendMode
var BlendMode=(function(){
	function BlendMode(){}
	__class(BlendMode,'laya.webgl.canvas.BlendMode');
	BlendMode._init_=function(gl){
		BlendMode.fns=[BlendMode.BlendNormal,BlendMode.BlendAdd,BlendMode.BlendMultiply,BlendMode.BlendScreen,BlendMode.BlendOverlay,BlendMode.BlendLight,BlendMode.BlendMask,BlendMode.BlendDestinationOut];
		BlendMode.targetFns=[BlendMode.BlendNormalTarget,BlendMode.BlendAddTarget,BlendMode.BlendMultiplyTarget,BlendMode.BlendScreenTarget,BlendMode.BlendOverlayTarget,BlendMode.BlendLightTarget,BlendMode.BlendMask,BlendMode.BlendDestinationOut];
	}

	BlendMode.BlendNormal=function(gl){
		WebGLContext.setBlendFunc(gl,/*laya.webgl.WebGLContext.ONE*/1,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303);
	}

	BlendMode.BlendAdd=function(gl){
		WebGLContext.setBlendFunc(gl,/*laya.webgl.WebGLContext.ONE*/1,/*laya.webgl.WebGLContext.DST_ALPHA*/0x0304);
	}

	BlendMode.BlendMultiply=function(gl){
		WebGLContext.setBlendFunc(gl,/*laya.webgl.WebGLContext.DST_COLOR*/0x0306,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303);
	}

	BlendMode.BlendScreen=function(gl){
		WebGLContext.setBlendFunc(gl,/*laya.webgl.WebGLContext.ONE*/1,/*laya.webgl.WebGLContext.ONE*/1);
	}

	BlendMode.BlendOverlay=function(gl){
		WebGLContext.setBlendFunc(gl,/*laya.webgl.WebGLContext.ONE*/1,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_COLOR*/0x0301);
	}

	BlendMode.BlendLight=function(gl){
		WebGLContext.setBlendFunc(gl,/*laya.webgl.WebGLContext.ONE*/1,/*laya.webgl.WebGLContext.ONE*/1);
	}

	BlendMode.BlendNormalTarget=function(gl){
		WebGLContext.setBlendFunc(gl,/*laya.webgl.WebGLContext.ONE*/1,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303);
	}

	BlendMode.BlendAddTarget=function(gl){
		WebGLContext.setBlendFunc(gl,/*laya.webgl.WebGLContext.ONE*/1,/*laya.webgl.WebGLContext.DST_ALPHA*/0x0304);
	}

	BlendMode.BlendMultiplyTarget=function(gl){
		WebGLContext.setBlendFunc(gl,/*laya.webgl.WebGLContext.DST_COLOR*/0x0306,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303);
	}

	BlendMode.BlendScreenTarget=function(gl){
		WebGLContext.setBlendFunc(gl,/*laya.webgl.WebGLContext.ONE*/1,/*laya.webgl.WebGLContext.ONE*/1);
	}

	BlendMode.BlendOverlayTarget=function(gl){
		WebGLContext.setBlendFunc(gl,/*laya.webgl.WebGLContext.ONE*/1,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_COLOR*/0x0301);
	}

	BlendMode.BlendLightTarget=function(gl){
		WebGLContext.setBlendFunc(gl,/*laya.webgl.WebGLContext.ONE*/1,/*laya.webgl.WebGLContext.ONE*/1);
	}

	BlendMode.BlendMask=function(gl){
		WebGLContext.setBlendFunc(gl,/*laya.webgl.WebGLContext.ZERO*/0,/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302);
	}

	BlendMode.BlendDestinationOut=function(gl){
		WebGLContext.setBlendFunc(gl,/*laya.webgl.WebGLContext.ZERO*/0,/*laya.webgl.WebGLContext.ZERO*/0);
	}

	BlendMode.activeBlendFunction=null;
	BlendMode.NAMES=["normal","add","multiply","screen","overlay","light","mask","destination-out"];
	BlendMode.TOINT={"normal":0,"add":1,"multiply":2,"screen":3 ,"overlay":4,"light":5,"mask":6,"destination-out":7,"lighter":1 };
	BlendMode.NORMAL="normal";
	BlendMode.ADD="add";
	BlendMode.MULTIPLY="multiply";
	BlendMode.SCREEN="screen";
	BlendMode.OVERLAY="overlay";
	BlendMode.LIGHT="light";
	BlendMode.MASK="mask";
	BlendMode.DESTINATIONOUT="destination-out";
	BlendMode.LIGHTER="lighter";
	BlendMode.fns=[];
	BlendMode.targetFns=[];
	return BlendMode;
})()


//class laya.webgl.canvas.Path
var Path=(function(){
	var renderPath;
	function Path(){
		//public var _rect:Rectangle;
		this._lastOriX=0;
		//moveto等的原始位置。没有经过内部矩阵变换的
		this._lastOriY=0;
		this.paths=[];
		//所有的路径。{@type renderPath[] }
		this._curPath=null;
	}

	__class(Path,'laya.webgl.canvas.Path');
	var __proto=Path.prototype;
	__proto.beginPath=function(convex){
		this.paths.length=1;
		this._curPath=this.paths[0]=new renderPath();
		this._curPath.convex=convex;
	}

	//_curPath.path=[];
	__proto.closePath=function(){
		this._curPath.loop=true;
	}

	__proto.newPath=function(){
		this._curPath=new renderPath();
		this.paths.push(this._curPath);
	}

	__proto.addPoint=function(pointX,pointY){
		this._curPath.path.push(pointX,pointY);
	}

	//直接添加一个完整的path
	__proto.push=function(points,convex){
		if (!this._curPath){
			this._curPath=new renderPath();
			this.paths.push(this._curPath);
			}else if (this._curPath.path.length > 0){
			this._curPath=new renderPath();
			this.paths.push(this._curPath);
		};
		var rp=this._curPath;
		rp.path=points.slice();
		rp.convex=convex;
	}

	__proto.reset=function(){
		this.paths.length=0;
	}

	Path.__init$=function(){
		//TODO 复用
		//class renderPath
		renderPath=(function(){
			function renderPath(){
				this.path=[];
				//[x,y,x,y,....]的数组
				this.loop=false;
				this.convex=false;
			}
			__class(renderPath,'');
			return renderPath;
		})()
	}

	return Path;
})()


//class laya.webgl.utils.Buffer
var Buffer=(function(){
	function Buffer(){
		//当前gl绑定的indexBuffer
		this._glBuffer=null;
		this._buffer=null;
		//可能为Float32Array、Uint16Array、Uint8Array、ArrayBuffer等。
		this._bufferType=0;
		this._bufferUsage=0;
		this._byteLength=0;
		this._glBuffer=LayaGL.instance.createBuffer()
	}

	__class(Buffer,'laya.webgl.utils.Buffer');
	var __proto=Buffer.prototype;
	/**
	*@private
	*绕过全局状态判断,例如VAO局部状态设置
	*/
	__proto._bindForVAO=function(){}
	//TODO:coverage
	__proto.bind=function(){
		return false;
	}

	/**
	*@private
	*/
	__proto.destroy=function(){
		if (this._glBuffer){
			LayaGL.instance.deleteBuffer(this._glBuffer);
			this._glBuffer=null;
		}
	}

	__getset(0,__proto,'bufferUsage',function(){
		return this._bufferUsage;
	});

	Buffer._bindedVertexBuffer=null;
	Buffer._bindedIndexBuffer=null;
	return Buffer;
})()


/**
*@private
*封装GL命令
*/
//class laya.layagl.LayaGLRenderingContext
var LayaGLRenderingContext=(function(){
	function LayaGLRenderingContext(){
		//TODO:coverage
		this._customCmds=null;
		//TODO:这个变量没有,下面有编译错误,临时整个
		this._targets=null;
		this._width=0;
		this._height=0;
		this._cmdEncoder=null;
	}

	__class(LayaGLRenderingContext,'laya.layagl.LayaGLRenderingContext');
	var __proto=LayaGLRenderingContext.prototype;
	//TODO:coverage
	__proto.drawTexture=function(texture,x,y,width,height){
		(x===void 0)&& (x=0);
		(y===void 0)&& (y=0);
		(width===void 0)&& (width=0);
		(height===void 0)&& (height=0);
		this.drawImage(texture,x,y,width,height);
	}

	//TODO:coverage
	__proto.drawImage=function(texture,x,y,width,height){
		(x===void 0)&& (x=0);
		(y===void 0)&& (y=0);
		(width===void 0)&& (width=0);
		(height===void 0)&& (height=0);
		this._customCmds.push(DrawImageCmd.create.call(this,texture,x,y,width,height));
	}

	//TODO:coverage
	__proto.fillText=function(text,x,y,font,color,textAlign){
		this._customCmds.push(FillTextCmd.create.call(this,text,x,y,font||Text.defaultFontStr(),color,textAlign));
	}

	//TODO:coverage
	__proto.save=function(){
		this._customCmds.push(SaveCmd.create.call(this));
	}

	//TODO:coverage
	__proto.restore=function(){
		this._customCmds.push(RestoreCmd.create.call(this));
	}

	//TODO:coverage
	__proto.translate=function(tx,ty){
		this._customCmds.push(TranslateCmd.create.call(this,tx,ty));
	}

	//TODO:coverage
	__proto.rotate=function(angle,pivotX,pivotY){
		(pivotX===void 0)&& (pivotX=0);
		(pivotY===void 0)&& (pivotY=0);
		this._customCmds.push(RotateCmd.create.call(this,angle,pivotX,pivotY));
	}

	//TODO:coverage
	__proto.scale=function(scaleX,scaleY,pivotX,pivotY){
		(pivotX===void 0)&& (pivotX=0);
		(pivotY===void 0)&& (pivotY=0);
		this._customCmds.push(ScaleCmd.create.call(this,scaleX,scaleY,pivotX,pivotY));
	}

	//TODO:coverage
	__proto.transform=function(matrix,pivotX,pivotY){
		(pivotX===void 0)&& (pivotX=0);
		(pivotY===void 0)&& (pivotY=0);
		this._customCmds.push(TransformCmd.create.call(this,matrix,pivotX,pivotY));
	}

	//TODO:coverage
	__proto.beginRT=function(){
		RenderTexture2D.pushRT();
		this._targets.start();
		this.clear();
	}

	__proto.clear=function(){}
	//TODO:coverage
	__proto.endRT=function(){
		RenderTexture2D.popRT();
	}

	//TODO:coverage
	__proto.drawCanvas=function(canvas,x,y){
		var target=canvas.context._targets;
		this._customCmds.push(DrawCanvasCmd.create.call(this,target,x,y,target.width,target.height));
	}

	//TODO:coverage
	__proto.drawTarget=function(commandEncoder,texture,x,y,width,height){
		var vbData=new ArrayBuffer(24 *4);
		var _i32b=new Int32Array(vbData);
		var _fb=new Float32Array(vbData);
		var w=width !=0 ? width :texture.width;
		var h=height !=0 ? height :texture.height;
		var uv=RenderTexture2D.flipyuv;
		var ix=0;
		_fb[ix++]=x;_fb[ix++]=y;_fb[ix++]=uv[0];_fb[ix++]=uv[1];_i32b[ix++]=0xffffffff;_i32b[ix++]=0xffffffff;
		_fb[ix++]=x+w;_fb[ix++]=y;_fb[ix++]=uv[2];_fb[ix++]=uv[3];_i32b[ix++]=0xffffffff;_i32b[ix++]=0xffffffff;
		_fb[ix++]=x+w;_fb[ix++]=y+h;_fb[ix++]=uv[4];_fb[ix++]=uv[5];_i32b[ix++]=0xffffffff;_i32b[ix++]=0xffffffff;
		_fb[ix++]=x;_fb[ix++]=y+h;_fb[ix++]=uv[6];_fb[ix++]=uv[7];_i32b[ix++]=0xffffffff;_i32b[ix++]=0xffffffff;
		commandEncoder.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);
		commandEncoder.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);
		commandEncoder.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
		commandEncoder.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
		commandEncoder.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
		commandEncoder.uniformTexture(0,/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0,texture._getSource());
		commandEncoder.setRectMesh(1,vbData);
		commandEncoder.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
		commandEncoder.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
	}

	__proto.getImageData=function(x,y,width,height,callBack){
		var w=this._targets.sourceWidth;
		var h=this._targets.sourceHeight;
		if (x < 0 || y < 0 || width < 0 || height < 0 || width > w || height > h){
			return;
		}
		if (!this._cmdEncoder){
			this._cmdEncoder=LayaGL.instance.createCommandEncoder(128,64,false);
		};
		var gl=LayaGL.instance;
		this._cmdEncoder.beginEncoding();
		this._cmdEncoder.clearEncoding();
		RenderTexture2D.pushRT();
		this._targets.start();
		gl.readPixelsAsync(x,y,width,height,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,function(data){
			/*__JS__ */callBack(data);
		});
		this.endRT();
		this._cmdEncoder.endEncoding();
		gl.useCommandEncoder(this._cmdEncoder.getPtrID(),-1,0);
	}

	__proto.toBase64=function(type,encoderOptions,callBack){
		var width=this._targets.sourceWidth;
		var height=this._targets.sourceHeight;
		this.getImageData(0,0,width,height,function(data){
			/*__JS__ */var base64=conchToBase64(type,encoderOptions,data,width,height);
			/*__JS__ */callBack(base64);
		});
	}

	__getset(0,__proto,'asBitmap',function(){
		return !this._targets;
		},function(value){
		if (value){
			this._targets || (this._targets=new RenderTexture2D(this._width,this._height,/*laya.webgl.resource.BaseTexture.FORMAT_R8G8B8A8*/1,-1));
			if (!this._width || !this._height)
				throw Error("asBitmap no size!");
		}
		else{
			this._targets=null;
		}
	});

	return LayaGLRenderingContext;
})()


/**
*填充文字命令
*/
//class laya.layagl.cmdNative.FillWordsCmdNative
var FillWordsCmdNative=(function(){
	function FillWordsCmdNative(){
		//this._graphicsCmdEncoder=null;
		//this.words=null;
		//this.x=NaN;
		//this.y=NaN;
		//this.font=null;
		//this.color=null;
		this._draw_texture_cmd_encoder_=LayaGL.instance.createCommandEncoder(64,32,true);
	}

	__class(FillWordsCmdNative,'laya.layagl.cmdNative.FillWordsCmdNative');
	var __proto=FillWordsCmdNative.prototype;
	__proto.createFillText=function(cbuf,data,x,y,font,color){
		var c1=ColorUtils.create(color);
		var nColor=c1.numColor;
		var ctx={};
		ctx._curMat=new Matrix();
		ctx._italicDeg=0;
		ctx._drawTextureUseColor=0xffffffff;
		ctx.fillStyle=color;
		ctx._fillColor=0xffffffff;
		ctx.setFillColor=function (color){
			ctx._fillColor=color;
		}
		ctx.getFillColor=function (){
			return ctx._fillColor;
		}
		ctx.mixRGBandAlpha=function (value){
			return value;
		}
		ctx._drawTextureM=function (tex,x,y,width,height,m,alpha,uv){
			cbuf.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			cbuf.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);
			cbuf.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);
			cbuf.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			cbuf.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			cbuf.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			cbuf.uniformTexture(3,/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0,tex.bitmap._glTexture);
			var buffer=new Float32Array([
			x,y,uv[0],uv[1],0,0,
			x+width,y,uv[2],uv[3],0,0,
			x+width,y+height,uv[4],uv[5],0,0,
			x,y+height,uv[6],uv[7],0,0]);
			var i32=new Int32Array(buffer.buffer);
			i32[4]=i32[10]=i32[16]=i32[22]=0xffffffff;
			i32[5]=i32[11]=i32[17]=i32[23]=0xffffffff;
			cbuf.setRectMesh(1,buffer,buffer.length);
			cbuf.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			cbuf.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(cbuf);
		}
		FillWordsCmdNative.cbook.filltext_native(ctx,null,data,x,y,font,color,null,0,null);
	}

	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._graphicsCmdEncoder=null;
		this.words=null;
		Pool.recover("FillWordsCmd",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "FillWords";
	});

	FillWordsCmdNative.create=function(words,x,y,font,color){
		if (!FillWordsCmdNative.cbook)new Error('Error:charbook not create!');
		var cmd=Pool.getItemByClass("FillWordsCmd",FillWordsCmdNative);
		var cbuf=cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		cmd.words=words;
		cmd.x=x;
		cmd.y=y;
		cmd.font=font;
		cmd.color=color;
		cmd._draw_texture_cmd_encoder_.clearEncoding();
		cmd.createFillText(cmd._draw_texture_cmd_encoder_,words,x,y,font,color);
		LayaGL.syncBufferToRenderThread(cmd._draw_texture_cmd_encoder_);
		cbuf.useCommandEncoder(cmd._draw_texture_cmd_encoder_.getPtrID(),-1,-1);
		LayaGL.syncBufferToRenderThread(cbuf);
		return cmd;
	}

	FillWordsCmdNative.ID="FillWords";
	__static(FillWordsCmdNative,
	['cbook',function(){return this.cbook=Laya['textRender'];}
	]);
	return FillWordsCmdNative;
})()


//class laya.webgl.canvas.save.SaveTransform
var SaveTransform=(function(){
	function SaveTransform(){
		//this._savematrix=null;
		this._matrix=new Matrix();
	}

	__class(SaveTransform,'laya.webgl.canvas.save.SaveTransform');
	var __proto=SaveTransform.prototype;
	Laya.imps(__proto,{"laya.webgl.canvas.save.ISaveData":true})
	__proto.isSaveMark=function(){return false;}
	__proto.restore=function(context){
		context._curMat=this._savematrix;
		SaveTransform.POOL[SaveTransform.POOL._length++]=this;
	}

	SaveTransform.save=function(context){
		var _saveMark=context._saveMark;
		if ((_saveMark._saveuse & /*laya.webgl.canvas.save.SaveBase.TYPE_TRANSFORM*/0x800)===/*laya.webgl.canvas.save.SaveBase.TYPE_TRANSFORM*/0x800)return;
		_saveMark._saveuse |=/*laya.webgl.canvas.save.SaveBase.TYPE_TRANSFORM*/0x800;
		var no=SaveTransform.POOL;
		var o=no._length > 0 ? no[--no._length] :(new SaveTransform());
		o._savematrix=context._curMat;
		context._curMat=context._curMat.copyTo(o._matrix);
		var _save=context._save;
		_save[_save._length++]=o;
	}

	SaveTransform.POOL=SaveBase._createArray();
	return SaveTransform;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.DrawPathCmdNative
var DrawPathCmdNative=(function(){
	function DrawPathCmdNative(){
		this._graphicsCmdEncoder=null;
		this._paramData=null;
		this._graphicsCmdEncoder_fill=null;
		this._paramData_fill=null;
		this._x=NaN;
		this._y=NaN;
		this._paths=null;
		this._brush=null;
		this._pen=null;
		this._vertNum=0;
		this._startOriX=0;
		this._startOriY=0;
		this._lastOriX=0;
		this._lastOriY=0;
		this.SEGNUM=32;
		this.lines_ibBuffer=null;
		this.lines_vbBuffer=null;
		this._lines_ibSize=0;
		this._lines_vbSize=0;
		this.fill_ibBuffer=null;
		this.fill_vbBuffer=null;
		this._fill_ibSize=0;
		this._fill_vbSize=0;
		this._cmdCurrentPos=0;
		this._points=[];
		this._lines_ibArray=[];
		this._lines_vbArray=[];
		this._fill_ibArray=[];
		this._fill_vbArray=[];
	}

	__class(DrawPathCmdNative,'laya.layagl.cmdNative.DrawPathCmdNative');
	var __proto=DrawPathCmdNative.prototype;
	__proto._arcTo=function(path){
		var x1=path[1];
		var y1=path[2];
		var x2=path[3];
		var y2=path[4];
		var r=path[5];
		var i=0;
		var x=0,y=0;
		var dx=this._lastOriX-x1;
		var dy=this._lastOriY-y1;
		var len1=Math.sqrt(dx*dx+dy*dy);
		if (len1 <=0.000001){
			return;
		};
		var ndx=dx / len1;
		var ndy=dy / len1;
		var dx2=x2-x1;
		var dy2=y2-y1;
		var len22=dx2*dx2+dy2*dy2;
		var len2=Math.sqrt(len22);
		if (len2 <=0.000001){
			return;
		};
		var ndx2=dx2 / len2;
		var ndy2=dy2 / len2;
		var odx=ndx+ndx2;
		var ody=ndy+ndy2;
		var olen=Math.sqrt(odx*odx+ody*ody);
		if (olen <=0.000001){
			return;
		};
		var nOdx=odx / olen;
		var nOdy=ody / olen;
		var alpha=Math.acos(nOdx*ndx+nOdy*ndy);
		var halfAng=Math.PI / 2-alpha;
		len1=r / Math.tan(halfAng);
		var ptx1=len1*ndx+x1;
		var pty1=len1*ndy+y1;
		var orilen=Math.sqrt(len1 *len1+r *r);
		var orix=x1+nOdx*orilen;
		var oriy=y1+nOdy*orilen;
		var ptx2=len1*ndx2+x1;
		var pty2=len1*ndy2+y1;
		var dir=ndx *ndy2-ndy *ndx2;
		var fChgAng=0;
		var sinx=0.0;
		var cosx=0.0;
		if (dir >=0){
			fChgAng=halfAng *2;
			var fda=fChgAng / this.SEGNUM;
			sinx=Math.sin(fda);
			cosx=Math.cos(fda);
		}
		else {
			fChgAng=-halfAng *2;
			fda=fChgAng / this.SEGNUM;
			sinx=Math.sin(fda);
			cosx=Math.cos(fda);
		};
		var lastx=this._lastOriX,lasty=this._lastOriY;
		var cvx=ptx1-orix;
		var cvy=pty1-oriy;
		var tx=0.0;
		var ty=0.0;
		for (i=0;i < this.SEGNUM;i++){
			var cx=cvx*cosx+cvy*sinx;
			var cy=-cvx*sinx+cvy*cosx;
			x=cx+orix;
			y=cy+oriy;
			if (Math.abs(lastx-x)>0.1 || Math.abs(lasty-y)>0.1){
				this._points.push(x);
				this._points.push(y);
			}
			cvx=cx;
			cvy=cy;
		}
	}

	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._paths=null;
		this._brush=null;
		this._pen=null;
		this._points.length=0;
		this._lines_ibArray.length=0;
		this._lines_vbArray.length=0;
		this._fill_ibArray.length=0;
		this._fill_vbArray.length=0;
		Pool.recover("DrawPathCmd",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "DrawPath";
	});

	__getset(0,__proto,'paths',function(){
		return this._paths;
		},function(value){
		this._paths=value;
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
		var _vb=this.lines_vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			_vb[ix++]=this._lines_vbArray[i *2]+value;ix++;ix++;
		}
		LayaGL.syncBufferToRenderThread(this.lines_vbBuffer);
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
		var _vb=this.lines_vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			ix++;_vb[ix++]=this._lines_vbArray[i *2+1]+value;ix++;
		}
		LayaGL.syncBufferToRenderThread(this.lines_vbBuffer);
	});

	__getset(0,__proto,'brush',function(){
		return this._brush;
		},function(value){
		if (!this._brush){
			this._graphicsCmdEncoder._idata[this._cmdCurrentPos+1]=DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_.getPtrID();
			LayaGL.syncBufferToRenderThread(this._graphicsCmdEncoder);
		}
		this._brush=value;
		var vertNumCopy=this._vertNum;
		var cur=Earcut.earcut(this._points,null,2);
		if (cur.length > 0){
			if (!this.fill_ibBuffer || this.fill_ibBuffer.getByteLength()< cur.length*2){
				this.fill_ibBuffer=/*__JS__ */new ParamData(cur.length*2,true,true);
			}
			this._fill_ibSize=cur.length *2;
			var _ib=this.fill_ibBuffer._int16Data;
			var idxpos=0;
			for (var ii=0;ii < cur.length;ii++){
				_ib[idxpos++]=cur[ii];
			}
		};
		var c1=ColorUtils.create(value.fillStyle);
		var nColor=c1.numColor;
		if (!this.fill_vbBuffer || this.fill_vbBuffer.getByteLength()< this._vertNum *3 *4){
			this.fill_vbBuffer=/*__JS__ */new ParamData(vertNumCopy*3 *4,true);
		}
		this._fill_vbSize=this._vertNum *3 *4;
		var _vb=this.fill_vbBuffer._float32Data;
		var _vb_i32b=this.fill_vbBuffer._int32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			_vb[ix++]=this._points[i *2]+this.x;_vb[ix++]=this._points[i *2+1]+this.y;_vb_i32b[ix++]=nColor;
		};
		var _i32b=this._paramData._int32Data;
		_i32b[DrawPathCmdNative._PARAM_FILL_VB_POS_]=this.fill_vbBuffer.getPtrID();
		_i32b[DrawPathCmdNative._PARAM_FILL_IB_POS_]=this.fill_ibBuffer.getPtrID();
		_i32b[DrawPathCmdNative._PARAM_FILL_VB_SIZE_POS_]=this._fill_vbSize;
		_i32b[DrawPathCmdNative._PARAM_FILL_IB_SIZE_POS_]=this._fill_ibSize;
		LayaGL.syncBufferToRenderThread(this.fill_vbBuffer);
		LayaGL.syncBufferToRenderThread(this.fill_ibBuffer);
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'pen',function(){
		return this._pen;
		},function(value){
		this._pen=value;
		this._lines_ibArray.length=0;
		this._lines_vbArray.length=0;
		BasePoly.createLine2(this._points,this._lines_ibArray,value.lineWidth,0,this._lines_vbArray,false);
		var c1=ColorUtils.create(value.strokeStyle);
		var nColor=c1.numColor;
		var vertNumCopy=this._vertNum;
		if (!this.lines_vbBuffer || this.lines_vbBuffer.getByteLength()< this._vertNum*3*4){
			this.lines_vbBuffer=/*__JS__ */new ParamData(vertNumCopy*3*4,true);
		}
		this._lines_vbSize=this._vertNum *3 *4;
		var _vb=this.lines_vbBuffer._float32Data;
		var _i32b=this.lines_vbBuffer._int32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			_vb[ix++]=this._lines_vbArray[i *2]+this.x;_vb[ix++]=this._lines_vbArray[i *2+1]+this.y;_i32b[ix++]=nColor;
		}
		if (!this.lines_ibBuffer || this.lines_ibBuffer.getByteLength()< (this._vertNum-2)*3 *2){
			this.lines_ibBuffer=/*__JS__ */new ParamData((vertNumCopy-2)*3 *2,true,true);
		}
		this._lines_ibSize=(this._vertNum-2)*3 *2;
		var _ib=this.lines_ibBuffer._int16Data;
		for (var ii=0;ii < (this._vertNum-2)*3;ii++){
			_ib[ii]=this._lines_ibArray[ii];
		}
		_i32b=this._paramData._int32Data;
		_i32b[DrawPathCmdNative._PARAM_LINES_VB_POS_]=this.lines_vbBuffer.getPtrID();
		_i32b[DrawPathCmdNative._PARAM_LINES_IB_POS_]=this.lines_ibBuffer.getPtrID();
		_i32b[DrawPathCmdNative._PARAM_LINES_VB_SIZE_POS_]=this._lines_vbSize;
		_i32b[DrawPathCmdNative._PARAM_LINES_IB_SIZE_POS_]=this._lines_ibSize;
		LayaGL.syncBufferToRenderThread(this.lines_vbBuffer);
		LayaGL.syncBufferToRenderThread(this.lines_ibBuffer);
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	DrawPathCmdNative.create=function(x,y,paths,brush,pen){
		var cmd=Pool.getItemByClass("DrawPathCmd",DrawPathCmdNative);
		cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		if (!DrawPathCmdNative._DRAW_LINES_CMD_ENCODER_){
			DrawPathCmdNative._DRAW_LINES_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(188,32,true);
			DrawPathCmdNative._DRAW_LINES_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawPathCmdNative._DRAW_LINES_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);
			DrawPathCmdNative._DRAW_LINES_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);
			DrawPathCmdNative._DRAW_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawPathCmdNative._DRAW_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawPathCmdNative._DRAW_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawPathCmdNative._DRAW_LINES_CMD_ENCODER_.setMeshExByParamData(DrawPathCmdNative._PARAM_LINES_VB_POS_ *4,DrawPathCmdNative._PARAM_LINE_VB_OFFSET_POS_*4,DrawPathCmdNative._PARAM_LINES_VB_SIZE_POS_ *4,DrawPathCmdNative._PARAM_LINES_IB_POS_ *4,DrawPathCmdNative._PARAM_LINE_IB_OFFSET_POS_*4,DrawPathCmdNative._PARAM_LINES_IB_SIZE_POS_ *4,DrawPathCmdNative._PARAM_FILL_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawPathCmdNative._DRAW_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawPathCmdNative._DRAW_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawPathCmdNative._DRAW_LINES_CMD_ENCODER_);
		}
		if (!DrawPathCmdNative._DRAW_FILL_CMD_ENCODER_){
			DrawPathCmdNative._DRAW_FILL_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(168,32,true);
			DrawPathCmdNative._DRAW_FILL_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawPathCmdNative._DRAW_FILL_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);
			DrawPathCmdNative._DRAW_FILL_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);
			DrawPathCmdNative._DRAW_FILL_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawPathCmdNative._DRAW_FILL_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawPathCmdNative._DRAW_FILL_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawPathCmdNative._DRAW_FILL_CMD_ENCODER_.setMeshExByParamData(DrawPathCmdNative._PARAM_FILL_VB_POS_ *4,DrawPathCmdNative._PARAM_FILL_VB_OFFSET_POS_*4,DrawPathCmdNative._PARAM_FILL_VB_SIZE_POS_ *4,DrawPathCmdNative._PARAM_FILL_IB_POS_ *4,DrawPathCmdNative._PARAM_FILL_IB_OFFSET_POS_*4,DrawPathCmdNative._PARAM_FILL_IB_SIZE_POS_ *4,DrawPathCmdNative._PARAM_FILL_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawPathCmdNative._DRAW_FILL_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawPathCmdNative._DRAW_FILL_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawPathCmdNative._DRAW_FILL_CMD_ENCODER_);
		}
		if (!DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_){
			DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(244,32,true);
			DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);
			DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);
			DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_.setMeshExByParamData(DrawPathCmdNative._PARAM_FILL_VB_POS_ *4,DrawPathCmdNative._PARAM_FILL_VB_OFFSET_POS_*4,DrawPathCmdNative._PARAM_FILL_VB_SIZE_POS_ *4,DrawPathCmdNative._PARAM_FILL_IB_POS_ *4,DrawPathCmdNative._PARAM_FILL_IB_OFFSET_POS_*4,DrawPathCmdNative._PARAM_FILL_IB_SIZE_POS_ *4,DrawPathCmdNative._PARAM_FILL_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_.setMeshExByParamData(DrawPathCmdNative._PARAM_LINES_VB_POS_ *4,DrawPathCmdNative._PARAM_LINE_VB_OFFSET_POS_*4,DrawPathCmdNative._PARAM_LINES_VB_SIZE_POS_ *4,DrawPathCmdNative._PARAM_LINES_IB_POS_ *4,DrawPathCmdNative._PARAM_LINE_IB_OFFSET_POS_*4,DrawPathCmdNative._PARAM_LINES_IB_SIZE_POS_ *4,DrawPathCmdNative._PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_);
		}
		if (!cmd._paramData){
			cmd._paramData=/*__JS__ */new ParamData(15 *4,true);
			}{
			cmd._x=x;
			cmd._y=y;
			cmd._paths=paths;
			cmd._brush=brush;
			cmd._pen=pen;
			for (var i=0,n=paths.length;i < n;i++){
				var path=paths[i];
				if (i==0){
					cmd._startOriX=path[1];
					cmd._startOriY=path[2];
				}
				switch(path[0]){
					case "moveTo":
						cmd._lastOriX=path[1];
						cmd._lastOriY=path[2];
						cmd._points.push(path[1]);
						cmd._points.push(path[2]);
						break ;
					case "lineTo":
						cmd._lastOriX=path[1];
						cmd._lastOriY=path[2];
						cmd._points.push(path[1]);
						cmd._points.push(path[2]);
						break ;
					case "arcTo":
						cmd._arcTo(path);
						break ;
					case "closePath":
						cmd._points.push(cmd._startOriX);
						cmd._points.push(cmd._startOriY);
						break ;
					}
			}
			cmd._vertNum=cmd._points.length;
			if(pen){
				BasePoly.createLine2(cmd._points,cmd._lines_ibArray,pen.lineWidth,0,cmd._lines_vbArray,false);
				var c1=ColorUtils.create(pen.strokeStyle);
				var nColor=c1.numColor;
				var vertNumCopy=cmd._vertNum;
				if (!cmd.lines_vbBuffer || cmd.lines_vbBuffer.getByteLength()< cmd._vertNum*3*4){
					cmd.lines_vbBuffer=/*__JS__ */new ParamData(vertNumCopy*3*4,true);
				}
				cmd._lines_vbSize=cmd._vertNum *3 *4;
				var _vb=cmd.lines_vbBuffer._float32Data;
				var _i32b=cmd.lines_vbBuffer._int32Data;
				var ix=0;
				for (i=0;i < cmd._vertNum;i++){
					_vb[ix++]=cmd._lines_vbArray[i *2]+x;_vb[ix++]=cmd._lines_vbArray[i *2+1]+y;_i32b[ix++]=nColor;
				}
				if (!cmd.lines_ibBuffer || cmd.lines_ibBuffer.getByteLength()< (cmd._vertNum-2)*3 *2){
					cmd.lines_ibBuffer=/*__JS__ */new ParamData((vertNumCopy-2)*3 *2,true,true);
				}
				cmd._lines_ibSize=(cmd._vertNum-2)*3 *2;
				var _ib=cmd.lines_ibBuffer._int16Data;
				for (var ii=0;ii < (cmd._vertNum-2)*3;ii++){
					_ib[ii]=cmd._lines_ibArray[ii];
				}
			}
			if (brush){
				vertNumCopy=cmd._vertNum;
				var cur=Earcut.earcut(cmd._points,null,2);
				if (cur.length > 0){
					if (!cmd.fill_ibBuffer || cmd.fill_ibBuffer.getByteLength()< cur.length*2){
						cmd.fill_ibBuffer=/*__JS__ */new ParamData(cur.length*2,true,true);
					}
					cmd._fill_ibSize=cur.length *2;
					_ib=cmd.fill_ibBuffer._int16Data;
					var idxpos=0;
					for (ii=0;ii < cur.length;ii++){
						_ib[idxpos++]=cur[ii];
					}
				}
				c1=ColorUtils.create(brush.fillStyle);
				nColor=c1.numColor;
				if (!cmd.fill_vbBuffer || cmd.fill_vbBuffer.getByteLength()< cmd._vertNum *3 *4){
					cmd.fill_vbBuffer=/*__JS__ */new ParamData(vertNumCopy*3 *4,true);
				}
				cmd._fill_vbSize=cmd._vertNum *3 *4;
				_vb=cmd.fill_vbBuffer._float32Data;
				var _vb_i32b=cmd.fill_vbBuffer._int32Data;
				_vb_i32b=cmd.fill_vbBuffer._int32Data;
				ix=0;
				for (i=0;i < cmd._vertNum;i++){
					_vb[ix++]=cmd._points[i *2]+x;_vb[ix++]=cmd._points[i *2+1]+y;_vb_i32b[ix++]=nColor;
				}
			}
		};
		var _fb=cmd._paramData._float32Data;
		_i32b=cmd._paramData._int32Data;
		_i32b[0]=1;
		if (pen){
			_i32b[DrawPathCmdNative._PARAM_LINES_VB_POS_]=cmd.lines_vbBuffer.getPtrID();
			_i32b[DrawPathCmdNative._PARAM_LINES_IB_POS_]=cmd.lines_ibBuffer.getPtrID();
			_i32b[DrawPathCmdNative._PARAM_LINES_VB_SIZE_POS_]=cmd._lines_vbSize;
			_i32b[DrawPathCmdNative._PARAM_LINES_IB_SIZE_POS_]=cmd._lines_ibSize;
			_i32b[DrawPathCmdNative._PARAM_LINE_VB_OFFSET_POS_]=0;
			_i32b[DrawPathCmdNative._PARAM_LINE_IB_OFFSET_POS_]=0;
			_i32b[DrawPathCmdNative._PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_]=0;
			LayaGL.syncBufferToRenderThread(cmd.lines_vbBuffer);
			LayaGL.syncBufferToRenderThread(cmd.lines_ibBuffer);
		}
		if (brush){
			_i32b[DrawPathCmdNative._PARAM_FILL_VB_POS_]=cmd.fill_vbBuffer.getPtrID();
			_i32b[DrawPathCmdNative._PARAM_FILL_IB_POS_]=cmd.fill_ibBuffer.getPtrID();
			_i32b[DrawPathCmdNative._PARAM_FILL_VB_SIZE_POS_]=cmd._fill_vbSize;
			_i32b[DrawPathCmdNative._PARAM_FILL_IB_SIZE_POS_]=cmd._fill_ibSize;
			_i32b[DrawPathCmdNative._PARAM_FILL_VB_OFFSET_POS_]=0;
			_i32b[DrawPathCmdNative._PARAM_FILL_IB_OFFSET_POS_]=0;
			_i32b[DrawPathCmdNative._PARAM_FILL_INDEX_ELEMENT_OFFSET_POS_]=0;
			LayaGL.syncBufferToRenderThread(cmd.fill_vbBuffer);
			LayaGL.syncBufferToRenderThread(cmd.fill_ibBuffer);
		}
		LayaGL.syncBufferToRenderThread(cmd._paramData);
		if (brush && pen){
			cmd._cmdCurrentPos=cmd._graphicsCmdEncoder.useCommandEncoder(DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		}
		else if (brush && !pen){
			cmd._cmdCurrentPos=cmd._graphicsCmdEncoder.useCommandEncoder(DrawPathCmdNative._DRAW_FILL_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		}
		else if (!brush && pen){
			cmd._cmdCurrentPos=cmd._graphicsCmdEncoder.useCommandEncoder(DrawPathCmdNative._DRAW_LINES_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		}
		LayaGL.syncBufferToRenderThread(cmd._graphicsCmdEncoder);
		return cmd;
	}

	DrawPathCmdNative.ID="DrawPath";
	DrawPathCmdNative._DRAW_LINES_CMD_ENCODER_=null;
	DrawPathCmdNative._DRAW_LINES_FILL_CMD_ENCODER_=null;
	DrawPathCmdNative._DRAW_FILL_CMD_ENCODER_=null;
	DrawPathCmdNative._PARAM_LINES_VB_POS_=1;
	DrawPathCmdNative._PARAM_LINES_IB_POS_=2;
	DrawPathCmdNative._PARAM_LINES_VB_SIZE_POS_=3;
	DrawPathCmdNative._PARAM_LINES_IB_SIZE_POS_=4;
	DrawPathCmdNative._PARAM_FILL_VB_POS_=5;
	DrawPathCmdNative._PARAM_FILL_IB_POS_=6;
	DrawPathCmdNative._PARAM_FILL_VB_SIZE_POS_=7;
	DrawPathCmdNative._PARAM_FILL_IB_SIZE_POS_=8;
	DrawPathCmdNative._PARAM_FILL_VB_OFFSET_POS_=9;
	DrawPathCmdNative._PARAM_FILL_IB_OFFSET_POS_=10;
	DrawPathCmdNative._PARAM_LINE_VB_OFFSET_POS_=11;
	DrawPathCmdNative._PARAM_LINE_IB_OFFSET_POS_=12;
	DrawPathCmdNative._PARAM_FILL_INDEX_ELEMENT_OFFSET_POS_=13;
	DrawPathCmdNative._PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_=14;
	return DrawPathCmdNative;
})()


//class laya.webgl.shader.d2.Shader2D
var Shader2D=(function(){
	function Shader2D(){
		this.ALPHA=1;
		//this.shader=null;
		//this.filters=null;
		this.shaderType=0;
		//this.colorAdd=null;
		this.defines=new ShaderDefines2D();
		this.fillStyle=DrawStyle.DEFAULT;
		this.strokeStyle=DrawStyle.DEFAULT;
	}

	__class(Shader2D,'laya.webgl.shader.d2.Shader2D');
	var __proto=Shader2D.prototype;
	__proto.destroy=function(){
		this.defines=null;
		this.filters=null;
	}

	Shader2D.__init__=function(){
		var vs,ps;
		vs="/*\n	texture和fillrect使用的。\n*/\nattribute vec4 posuv;\nattribute vec4 attribColor;\nattribute vec4 attribFlags;\n//attribute vec4 clipDir;\n//attribute vec2 clipRect;\nuniform vec4 clipMatDir;\nuniform vec2 clipMatPos;		// 这个是全局的，不用再应用矩阵了。\nvarying vec2 cliped;\nuniform vec2 size;\n\n#ifdef WORLDMAT\n	uniform mat4 mmat;\n#endif\nuniform mat4 u_MvpMatrix;\n\nvarying vec4 v_texcoordAlpha;\nvarying vec4 v_color;\nvarying float v_useTex;\n\nvoid main() {\n\n	vec4 pos = vec4(posuv.xy,0.,1.);\n#ifdef WORLDMAT\n	pos=mmat*pos;\n#endif\n	vec4 pos1  =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,0.,1.0);\n#ifdef MVP3D\n	gl_Position=u_MvpMatrix*pos1;\n#else\n	gl_Position=pos1;\n#endif\n	v_texcoordAlpha.xy = posuv.zw;\n	//v_texcoordAlpha.z = attribColor.a/255.0;\n	v_color = attribColor/255.0;\n	v_color.xyz*=v_color.w;//反正后面也要预乘\n	\n	v_useTex = attribFlags.r/255.0;\n	float clipw = length(clipMatDir.xy);\n	float cliph = length(clipMatDir.zw);\n	vec2 clippos = pos.xy - clipMatPos.xy;	//pos已经应用矩阵了，为了减的有意义，clip的位置也要缩放\n	if(clipw>20000. && cliph>20000.)\n		cliped = vec2(0.5,0.5);\n	else {\n		//转成0到1之间。/clipw/clipw 表示clippos与normalize之后的clip朝向点积之后，再除以clipw\n		cliped=vec2( dot(clippos,clipMatDir.xy)/clipw/clipw, dot(clippos,clipMatDir.zw)/cliph/cliph);\n	}\n\n}";
		ps="/*\n	texture和fillrect使用的。\n*/\n\nprecision mediump float;\n//precision highp float;\nvarying vec4 v_texcoordAlpha;\nvarying vec4 v_color;\nvarying float v_useTex;\nuniform sampler2D texture;\nvarying vec2 cliped;\n\n#ifdef BLUR_FILTER\nuniform vec4 strength_sig2_2sig2_gauss1;\nuniform vec2 blurInfo;\n\n#define PI 3.141593\n\nfloat getGaussian(float x, float y){\n    return strength_sig2_2sig2_gauss1.w*exp(-(x*x+y*y)/strength_sig2_2sig2_gauss1.z);\n}\n\nvec4 blur(){\n    const float blurw = 9.0;\n    vec4 vec4Color = vec4(0.0,0.0,0.0,0.0);\n    vec2 halfsz=vec2(blurw,blurw)/2.0/blurInfo;    \n    vec2 startpos=v_texcoordAlpha.xy-halfsz;\n    vec2 ctexcoord = startpos;\n    vec2 step = 1.0/blurInfo;  //每个像素      \n    \n    for(float y = 0.0;y<=blurw; ++y){\n        ctexcoord.x=startpos.x;\n        for(float x = 0.0;x<=blurw; ++x){\n            //TODO 纹理坐标的固定偏移应该在vs中处理\n            vec4Color += texture2D(texture, ctexcoord)*getGaussian(x-blurw/2.0,y-blurw/2.0);\n            ctexcoord.x+=step.x;\n        }\n        ctexcoord.y+=step.y;\n    }\n    return vec4Color;\n}\n#endif\n\n#ifdef COLOR_FILTER\nuniform vec4 colorAlpha;\nuniform mat4 colorMat;\n#endif\n\n#ifdef GLOW_FILTER\nuniform vec4 u_color;\nuniform vec4 u_blurInfo1;\nuniform vec4 u_blurInfo2;\n#endif\n\n#ifdef COLOR_ADD\nuniform vec4 colorAdd;\n#endif\n\n//FILLTEXTURE\nuniform vec4 u_TexRange;//startu,startv,urange, vrange\n\nvoid main() {\n	if(cliped.x<0.) discard;\n	if(cliped.x>1.) discard;\n	if(cliped.y<0.) discard;\n	if(cliped.y>1.) discard;\n	\n#ifdef FILLTEXTURE	\n   vec4 color= texture2D(texture, fract(v_texcoordAlpha.xy)*u_TexRange.zw + u_TexRange.xy);\n#else\n   vec4 color= texture2D(texture, v_texcoordAlpha.xy);\n#endif\n\n   if(v_useTex<=0.)color = vec4(1.,1.,1.,1.);\n   color.a*=v_color.w;\n   //color.rgb*=v_color.w;\n   color.rgb*=v_color.rgb;\n   gl_FragColor=color;\n   \n   #ifdef COLOR_ADD\n	gl_FragColor = vec4(colorAdd.rgb,colorAdd.a*gl_FragColor.a);\n	gl_FragColor.xyz *= colorAdd.a;\n   #endif\n   \n   #ifdef BLUR_FILTER\n	gl_FragColor =   blur();\n	gl_FragColor.w*=v_color.w;   \n   #endif\n   \n   #ifdef COLOR_FILTER\n	mat4 alphaMat =colorMat;\n\n	alphaMat[0][3] *= gl_FragColor.a;\n	alphaMat[1][3] *= gl_FragColor.a;\n	alphaMat[2][3] *= gl_FragColor.a;\n\n	gl_FragColor = gl_FragColor * alphaMat;\n	gl_FragColor += colorAlpha/255.0*gl_FragColor.a;\n   #endif\n   \n   #ifdef GLOW_FILTER\n	const float c_IterationTime = 10.0;\n	float floatIterationTotalTime = c_IterationTime * c_IterationTime;\n	vec4 vec4Color = vec4(0.0,0.0,0.0,0.0);\n	vec2 vec2FilterDir = vec2(-(u_blurInfo1.z)/u_blurInfo2.x,-(u_blurInfo1.w)/u_blurInfo2.y);\n	vec2 vec2FilterOff = vec2(u_blurInfo1.x/u_blurInfo2.x/c_IterationTime * 2.0,u_blurInfo1.y/u_blurInfo2.y/c_IterationTime * 2.0);\n	float maxNum = u_blurInfo1.x * u_blurInfo1.y;\n	vec2 vec2Off = vec2(0.0,0.0);\n	float floatOff = c_IterationTime/2.0;\n	for(float i = 0.0;i<=c_IterationTime; ++i){\n		for(float j = 0.0;j<=c_IterationTime; ++j){\n			vec2Off = vec2(vec2FilterOff.x * (i - floatOff),vec2FilterOff.y * (j - floatOff));\n			vec4Color += texture2D(texture, v_texcoordAlpha.xy + vec2FilterDir + vec2Off)/floatIterationTotalTime;\n		}\n	}\n	gl_FragColor = vec4(u_color.rgb,vec4Color.a * u_blurInfo2.z);\n	gl_FragColor.rgb *= gl_FragColor.a;   \n   #endif\n   \n}";
		Shader.preCompile2D(0,/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,vs,ps,null);
		vs="attribute vec4 position;\nattribute vec4 attribColor;\n//attribute vec4 clipDir;\n//attribute vec2 clipRect;\nuniform vec4 clipMatDir;\nuniform vec2 clipMatPos;\n#ifdef WORLDMAT\n	uniform mat4 mmat;\n#endif\nuniform mat4 u_mmat2;\n//uniform vec2 u_pos;\nuniform vec2 size;\nvarying vec4 color;\n//vec4 dirxy=vec4(0.9,0.1, -0.1,0.9);\n//vec4 clip=vec4(100.,30.,300.,600.);\nvarying vec2 cliped;\nvoid main(){\n	\n#ifdef WORLDMAT\n	vec4 pos=mmat*vec4(position.xy,0.,1.);\n	gl_Position =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);\n#else\n	gl_Position =vec4((position.x/size.x-0.5)*2.0,(0.5-position.y/size.y)*2.0,position.z,1.0);\n#endif	\n	float clipw = length(clipMatDir.xy);\n	float cliph = length(clipMatDir.zw);\n	vec2 clippos = position.xy - clipMatPos.xy;	//pos已经应用矩阵了，为了减的有意义，clip的位置也要缩放\n	if(clipw>20000. && cliph>20000.)\n		cliped = vec2(0.5,0.5);\n	else {\n		//clipdir是带缩放的方向，由于上面clippos是在缩放后的空间计算的，所以需要把方向先normalize一下\n		cliped=vec2( dot(clippos,clipMatDir.xy)/clipw/clipw, dot(clippos,clipMatDir.zw)/cliph/cliph);\n	}\n  //pos2d.x = dot(clippos,dirx);\n  color=attribColor/255.;\n}";
		ps="precision mediump float;\n//precision mediump float;\nvarying vec4 color;\n//uniform float alpha;\nvarying vec2 cliped;\nvoid main(){\n	//vec4 a=vec4(color.r, color.g, color.b, 1);\n	//a.a*=alpha;\n    gl_FragColor= color;// vec4(color.r, color.g, color.b, alpha);\n	gl_FragColor.rgb*=color.a;\n	if(cliped.x<0.) discard;\n	if(cliped.x>1.) discard;\n	if(cliped.y<0.) discard;\n	if(cliped.y>1.) discard;\n}";
		Shader.preCompile2D(0,/*laya.webgl.shader.d2.ShaderDefines2D.PRIMITIVE*/0x04,vs,ps,null);
		vs="/*\n	texture和fillrect使用的。\n*/\nattribute vec4 posuv;\nattribute vec4 attribColor;\nattribute vec4 attribFlags;\n//attribute vec4 clipDir;\n//attribute vec2 clipRect;\nuniform vec4 clipMatDir;\nuniform vec2 clipMatPos;		// 这个是全局的，不用再应用矩阵了。\nvarying vec2 cliped;\nuniform vec2 size;\n\n#ifdef WORLDMAT\n	uniform mat4 mmat;\n#endif\nuniform mat4 u_MvpMatrix;\n\nvarying vec4 v_texcoordAlpha;\nvarying vec4 v_color;\nvarying float v_useTex;\n\nvoid main() {\n\n	vec4 pos = vec4(posuv.xy,0.,1.);\n#ifdef WORLDMAT\n	pos=mmat*pos;\n#endif\n	vec4 pos1  =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,0.,1.0);\n#ifdef MVP3D\n	gl_Position=u_MvpMatrix*pos1;\n#else\n	gl_Position=pos1;\n#endif\n	v_texcoordAlpha.xy = posuv.zw;\n	//v_texcoordAlpha.z = attribColor.a/255.0;\n	v_color = attribColor/255.0;\n	v_color.xyz*=v_color.w;//反正后面也要预乘\n	\n	v_useTex = attribFlags.r/255.0;\n	float clipw = length(clipMatDir.xy);\n	float cliph = length(clipMatDir.zw);\n	vec2 clippos = pos.xy - clipMatPos.xy;	//pos已经应用矩阵了，为了减的有意义，clip的位置也要缩放\n	if(clipw>20000. && cliph>20000.)\n		cliped = vec2(0.5,0.5);\n	else {\n		//转成0到1之间。/clipw/clipw 表示clippos与normalize之后的clip朝向点积之后，再除以clipw\n		cliped=vec2( dot(clippos,clipMatDir.xy)/clipw/clipw, dot(clippos,clipMatDir.zw)/cliph/cliph);\n	}\n\n}";
		ps="#ifdef FSHIGHPRECISION\n	precision highp float;\n#else\n	precision mediump float;\n#endif\n\n//precision highp float;\nvarying vec2 v_texcoord;\nuniform sampler2D texture;\nuniform float alpha;\nuniform vec4 u_TexRange;\nuniform vec2 u_offset;\n\n#import?BLUR_FILTER  \"parts/BlurFilter_ps_uniform.glsl\";\n\n#import?COLOR_FILTER \"parts/ColorFilter.glsl\" with ColorFilter_ps_uniform;\n\n#import?GLOW_FILTER \"parts/GlowFilter_ps_uniform.glsl\";\n\n#import?COLOR_ADD \"parts/ColorAdd.glsl\" with ColorAdd_ps_uniform;\n\nvoid main() {\n   vec2 newTexCoord;\n   newTexCoord.x = mod(u_offset.x + v_texcoord.x,u_TexRange.y) + u_TexRange.x;\n   newTexCoord.y = mod(u_offset.y + v_texcoord.y,u_TexRange.w) + u_TexRange.z;\n   vec4 color= texture2D(texture, newTexCoord);\n   color.a*=alpha;\n   gl_FragColor=color;\n   \n   #import?COLOR_ADD \"parts/ColorAdd.glsl\" with ColorAdd_ps_logic;\n   \n   #import?BLUR_FILTER  \"parts/BlurFilter_ps_logic.glsl\";\n   \n   #import?COLOR_FILTER \"parts/ColorFilter.glsl\" with ColorFilter_ps_logic;\n   \n   #import?GLOW_FILTER \"parts/GlowFilter_ps_logic.glsl\";\n}";
		Shader.preCompile2D(0,/*laya.webgl.shader.d2.ShaderDefines2D.FILLTEXTURE*/0x100,vs,ps,null);
		vs="attribute vec2 position;\nattribute vec2 texcoord;\nattribute vec4 color;\nuniform vec2 size;\nuniform float offsetX;\nuniform float offsetY;\nuniform mat4 mmat;\nuniform mat4 u_mmat2;\nvarying vec2 v_texcoord;\nvarying vec4 v_color;\nvoid main() {\n  vec4 pos=mmat*u_mmat2*vec4(offsetX+position.x,offsetY+position.y,0,1 );\n  gl_Position = vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);\n  v_color = color;\n  v_color.rgb *= v_color.a;\n  v_texcoord = texcoord;  \n}";
		ps="precision mediump float;\nvarying vec2 v_texcoord;\nvarying vec4 v_color;\nuniform sampler2D texture;\nuniform float alpha;\nvoid main() {\n	vec4 t_color = texture2D(texture, v_texcoord);\n	gl_FragColor = t_color.rgba * v_color;\n	gl_FragColor *= alpha;\n}";
		Shader.preCompile2D(0,/*laya.webgl.shader.d2.ShaderDefines2D.SKINMESH*/0x200,vs,ps,null);
	}

	return Shader2D;
})()


/**
*@private
*CommandEncoder
*/
//class laya.layagl.CommandEncoder
var CommandEncoder=(function(){
	function CommandEncoder(layagl,reserveSize,adjustSize,isSyncToRenderThread){
		this._idata=[];
	}

	__class(CommandEncoder,'laya.layagl.CommandEncoder');
	var __proto=CommandEncoder.prototype;
	//TODO:coverage
	__proto.getArrayData=function(){
		return this._idata;
	}

	//TODO:coverage
	__proto.getPtrID=function(){
		return 0;
	}

	__proto.beginEncoding=function(){}
	__proto.endEncoding=function(){}
	//TODO:coverage
	__proto.clearEncoding=function(){
		this._idata.length=0;
	}

	//TODO:coverage
	__proto.getCount=function(){
		return this._idata.length;
	}

	//TODO:coverage
	__proto.add_ShaderValue=function(o){
		this._idata.push(o);
	}

	//TODO:coverage
	__proto.addShaderUniform=function(one){
		this.add_ShaderValue(one);
	}

	return CommandEncoder;
})()


//class laya.webgl.utils.InlcudeFile
var InlcudeFile=(function(){
	function InlcudeFile(txt){
		this.script=null;
		this.codes={};
		this.funs={};
		this.curUseID=-1;
		this.funnames="";
		this.script=txt;
		var begin=0,ofs=0,end=0;
		while (true){
			begin=txt.indexOf("#begin",begin);
			if (begin < 0)break ;
			end=begin+5;
			while (true){
				end=txt.indexOf("#end",end);
				if (end < 0)break ;
				if (txt.charAt(end+4)==='i')
					end+=5;
				else break ;
			}
			if (end < 0){
				throw "add include err,no #end:"+txt;
			}
			ofs=txt.indexOf('\n',begin);
			var words=ShaderCompile.splitToWords(txt.substr(begin,ofs-begin),null);
			if (words[1]=='code'){
				this.codes[words[2]]=txt.substr(ofs+1,end-ofs-1);
				}else if (words[1]=='function'){
				ofs=txt.indexOf("function",begin);
				ofs+="function".length;
				this.funs[words[3]]=txt.substr(ofs+1,end-ofs-1);
				this.funnames+=words[3]+";";
			}
			begin=end+1;
		}
	}

	__class(InlcudeFile,'laya.webgl.utils.InlcudeFile');
	var __proto=InlcudeFile.prototype;
	__proto.getWith=function(name){
		var r=name ? this.codes[name] :this.script;
		if (!r){
			throw "get with error:"+name;
		}
		return r;
	}

	__proto.getFunsScript=function(funsdef){
		var r="";
		for (var i in this.funs){
			if (funsdef.indexOf(i+";")>=0){
				r+=this.funs[i];
			}
		}
		return r;
	}

	return InlcudeFile;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.DrawLineCmdNative
var DrawLineCmdNative=(function(){
	function DrawLineCmdNative(){
		this._graphicsCmdEncoder=null;
		this._paramData=null;
		this._fromX=NaN;
		this._fromY=NaN;
		this._toX=NaN;
		this._toY=NaN;
		this._lineColor=null;
		this._lineWidth=NaN;
		this._vid=0;
	}

	__class(DrawLineCmdNative,'laya.layagl.cmdNative.DrawLineCmdNative');
	var __proto=DrawLineCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("DrawLineCmd",this);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._lineColor;
		},function(value){
		this._lineColor=value;
		var c1=ColorUtils.create(this.lineColor);
		var nColor=c1.numColor;
		var _i32b=this._paramData._int32Data;
		var ix=DrawLineCmdNative._PARAM_VB_POS_;
		ix++;ix++;_i32b[ix++]=nColor;
		ix++;ix++;_i32b[ix++]=nColor;
		ix++;ix++;_i32b[ix++]=nColor;
		ix++;ix++;_i32b[ix++]=nColor;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawLine";
	});

	__getset(0,__proto,'toY',function(){
		return this._toY;
		},function(value){
		this._toY=value;
		var points=[this._fromX,this._fromY,this._toX,this._toY];
		var vbArray=[];
		var ibArray=[];
		BasePoly.createLine2(points,ibArray,this._lineWidth,0,vbArray,false);
		var _fb=this._paramData._float32Data;
		var _i32b=this._paramData._int32Data;
		var _i16b=this._paramData._int16Data;
		var ix=DrawLineCmdNative._PARAM_VB_POS_;
		_fb[ix++]=vbArray[0];_fb[ix++]=vbArray[1];ix++;
		_fb[ix++]=vbArray[2];_fb[ix++]=vbArray[3];ix++;
		_fb[ix++]=vbArray[4];_fb[ix++]=vbArray[5];ix++;
		_fb[ix++]=vbArray[6];_fb[ix++]=vbArray[7];ix++;
		var ibx=DrawLineCmdNative._PARAM_IB_POS_*2;
		_i16b[ibx++]=ibArray[0];_i16b[ibx++]=ibArray[1];
		_i16b[ibx++]=ibArray[2];_i16b[ibx++]=ibArray[3];
		_i16b[ibx++]=ibArray[4];_i16b[ibx++]=ibArray[5];
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'fromX',function(){
		return this._fromX;
		},function(value){
		this._fromX=value;
		var points=[this._fromX,this._fromY,this._toX,this._toY];
		var vbArray=[];
		var ibArray=[];
		BasePoly.createLine2(points,ibArray,this._lineWidth,0,vbArray,false);
		var _fb=this._paramData._float32Data;
		var _i32b=this._paramData._int32Data;
		var _i16b=this._paramData._int16Data;
		var ix=DrawLineCmdNative._PARAM_VB_POS_;
		_fb[ix++]=vbArray[0];_fb[ix++]=vbArray[1];ix++;
		_fb[ix++]=vbArray[2];_fb[ix++]=vbArray[3];ix++;
		_fb[ix++]=vbArray[4];_fb[ix++]=vbArray[5];ix++;
		_fb[ix++]=vbArray[6];_fb[ix++]=vbArray[7];ix++;
		var ibx=DrawLineCmdNative._PARAM_IB_POS_*2;
		_i16b[ibx++]=ibArray[0];_i16b[ibx++]=ibArray[1];
		_i16b[ibx++]=ibArray[2];_i16b[ibx++]=ibArray[3];
		_i16b[ibx++]=ibArray[4];_i16b[ibx++]=ibArray[5];
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'vid',function(){
		return this._vid;
		},function(value){
		this._vid=value;
	});

	__getset(0,__proto,'toX',function(){
		return this._toX;
		},function(value){
		this._toX=value;
		var points=[this._fromX,this._fromY,this._toX,this._toY];
		var vbArray=[];
		var ibArray=[];
		BasePoly.createLine2(points,ibArray,this._lineWidth,0,vbArray,false);
		var _fb=this._paramData._float32Data;
		var _i32b=this._paramData._int32Data;
		var _i16b=this._paramData._int16Data;
		var ix=DrawLineCmdNative._PARAM_VB_POS_;
		_fb[ix++]=vbArray[0];_fb[ix++]=vbArray[1];ix++;
		_fb[ix++]=vbArray[2];_fb[ix++]=vbArray[3];ix++;
		_fb[ix++]=vbArray[4];_fb[ix++]=vbArray[5];ix++;
		_fb[ix++]=vbArray[6];_fb[ix++]=vbArray[7];ix++;
		var ibx=DrawLineCmdNative._PARAM_IB_POS_*2;
		_i16b[ibx++]=ibArray[0];_i16b[ibx++]=ibArray[1];
		_i16b[ibx++]=ibArray[2];_i16b[ibx++]=ibArray[3];
		_i16b[ibx++]=ibArray[4];_i16b[ibx++]=ibArray[5];
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'fromY',function(){
		return this._fromY;
		},function(value){
		this._fromY=value;
		var points=[this._fromX,this._fromY,this._toX,this._toY];
		var vbArray=[];
		var ibArray=[];
		BasePoly.createLine2(points,ibArray,this._lineWidth,0,vbArray,false);
		var _fb=this._paramData._float32Data;
		var _i32b=this._paramData._int32Data;
		var _i16b=this._paramData._int16Data;
		var ix=DrawLineCmdNative._PARAM_VB_POS_;
		_fb[ix++]=vbArray[0];_fb[ix++]=vbArray[1];ix++;
		_fb[ix++]=vbArray[2];_fb[ix++]=vbArray[3];ix++;
		_fb[ix++]=vbArray[4];_fb[ix++]=vbArray[5];ix++;
		_fb[ix++]=vbArray[6];_fb[ix++]=vbArray[7];ix++;
		var ibx=DrawLineCmdNative._PARAM_IB_POS_*2;
		_i16b[ibx++]=ibArray[0];_i16b[ibx++]=ibArray[1];
		_i16b[ibx++]=ibArray[2];_i16b[ibx++]=ibArray[3];
		_i16b[ibx++]=ibArray[4];_i16b[ibx++]=ibArray[5];
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		this._lineWidth=value;
		var points=[this._fromX,this._fromY,this._toX,this._toY];
		var vbArray=[];
		var ibArray=[];
		BasePoly.createLine2(points,ibArray,this.lineWidth,0,vbArray,false);
		var _fb=this._paramData._float32Data;
		var _i32b=this._paramData._int32Data;
		var _i16b=this._paramData._int16Data;
		var ix=DrawLineCmdNative._PARAM_VB_POS_;
		_fb[ix++]=vbArray[0];_fb[ix++]=vbArray[1];ix++;
		_fb[ix++]=vbArray[2];_fb[ix++]=vbArray[3];ix++;
		_fb[ix++]=vbArray[4];_fb[ix++]=vbArray[5];ix++;
		_fb[ix++]=vbArray[6];_fb[ix++]=vbArray[7];ix++;
		var ibx=DrawLineCmdNative._PARAM_IB_POS_*2;
		_i16b[ibx++]=ibArray[0];_i16b[ibx++]=ibArray[1];
		_i16b[ibx++]=ibArray[2];_i16b[ibx++]=ibArray[3];
		_i16b[ibx++]=ibArray[4];_i16b[ibx++]=ibArray[5];
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	DrawLineCmdNative.create=function(fromX,fromY,toX,toY,lineColor,lineWidth,vid){
		var cmd=Pool.getItemByClass("DrawLineCmd",DrawLineCmdNative);
		cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		if (!DrawLineCmdNative._DRAW_LINE_CMD_ENCODER_){
			DrawLineCmdNative._DRAW_LINE_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(152,32,true);
			DrawLineCmdNative._DRAW_LINE_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);
			DrawLineCmdNative._DRAW_LINE_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);
			DrawLineCmdNative._DRAW_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawLineCmdNative._DRAW_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawLineCmdNative._DRAW_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawLineCmdNative._DRAW_LINE_CMD_ENCODER_.setMeshByParamData(DrawLineCmdNative._PARAM_VB_POS_*4,DrawLineCmdNative._PARAM_VB_OFFSET_POS_*4,1*4,DrawLineCmdNative._PARAM_IB_POS_*4,DrawLineCmdNative._PARAM_IB_OFFSET_POS_*4,2*4,DrawLineCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_*4);
			DrawLineCmdNative._DRAW_LINE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawLineCmdNative._DRAW_LINE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawLineCmdNative._DRAW_LINE_CMD_ENCODER_);
		}
		if (!cmd._paramData){
			cmd._paramData=/*__JS__ */new ParamData(24 *4,true);
			}{
			cmd._fromX=fromX;
			cmd._fromY=fromY;
			cmd._toX=toX;
			cmd._toY=toY;
			cmd._lineColor=lineColor;
			cmd._lineWidth=lineWidth;
			cmd._vid=vid;
			var c1=ColorUtils.create(lineColor);
			var nColor=c1.numColor;
			var points=[fromX,fromY,toX,toY];
			var vbArray=[];
			var ibArray=[];
			BasePoly.createLine2(points,ibArray,lineWidth,0,vbArray,false);
			var _fb=cmd._paramData._float32Data;
			var _i32b=cmd._paramData._int32Data;
			var _i16b=cmd._paramData._int16Data;
			_i32b[0]=1;
			_i32b[1]=12 *4;
			_i32b[2]=6 *2;
			_i32b[DrawLineCmdNative._PARAM_VB_OFFSET_POS_]=0;
			_i32b[DrawLineCmdNative._PARAM_IB_OFFSET_POS_]=0;
			_i32b[DrawLineCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_]=0;
			var ix=DrawLineCmdNative._PARAM_VB_POS_;
			_fb[ix++]=vbArray[0];_fb[ix++]=vbArray[1];_i32b[ix++]=nColor;
			_fb[ix++]=vbArray[2];_fb[ix++]=vbArray[3];_i32b[ix++]=nColor;
			_fb[ix++]=vbArray[4];_fb[ix++]=vbArray[5];_i32b[ix++]=nColor;
			_fb[ix++]=vbArray[6];_fb[ix++]=vbArray[7];_i32b[ix++]=nColor;
			var ibx=DrawLineCmdNative._PARAM_IB_POS_*2;
			_i16b[ibx++]=ibArray[0];_i16b[ibx++]=ibArray[1];
			_i16b[ibx++]=ibArray[2];_i16b[ibx++]=ibArray[3];
			_i16b[ibx++]=ibArray[4];_i16b[ibx++]=ibArray[5];
			if (!lineColor){
				_fb[DrawLineCmdNative._PARAM_LINECOLOR_POS_]=0xff0000ff;
			}
			else{
				_fb[DrawLineCmdNative._PARAM_LINECOLOR_POS_]=lineColor;
			}
			_fb[DrawLineCmdNative._PARAM_LINEWIDTH_POS_]=lineWidth;
			_fb[DrawLineCmdNative._PARAM_VID_POS_]=vid;
			LayaGL.syncBufferToRenderThread(cmd._paramData);
		}
		cmd._graphicsCmdEncoder.useCommandEncoder(DrawLineCmdNative._DRAW_LINE_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		LayaGL.syncBufferToRenderThread(cmd._graphicsCmdEncoder);
		return cmd;
	}

	DrawLineCmdNative.ID="DrawLine";
	DrawLineCmdNative._DRAW_LINE_CMD_ENCODER_=null;
	DrawLineCmdNative._PARAM_VB_POS_=3;
	DrawLineCmdNative._PARAM_IB_POS_=15;
	DrawLineCmdNative._PARAM_LINECOLOR_POS_=18;
	DrawLineCmdNative._PARAM_LINEWIDTH_POS_=19;
	DrawLineCmdNative._PARAM_VID_POS_=20;
	DrawLineCmdNative._PARAM_VB_OFFSET_POS_=21;
	DrawLineCmdNative._PARAM_IB_OFFSET_POS_=22;
	DrawLineCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_=23;
	return DrawLineCmdNative;
})()


/**
*填充文字命令
*/
//class laya.layagl.cmdNative.FillBorderWordsCmdNative
var FillBorderWordsCmdNative=(function(){
	function FillBorderWordsCmdNative(){
		//this._graphicsCmdEncoder=null;
		//this.words=null;
		//this.x=NaN;
		//this.y=NaN;
		//this.font=null;
		//this.color=null;
		//this.strokeColor=null;
		//this.strokeWidth=0;
		this._draw_texture_cmd_encoder_=LayaGL.instance.createCommandEncoder(64,32,true);
	}

	__class(FillBorderWordsCmdNative,'laya.layagl.cmdNative.FillBorderWordsCmdNative');
	var __proto=FillBorderWordsCmdNative.prototype;
	__proto.createFillBorderText=function(cbuf,data,x,y,font,color,strokeColor,strokeWidth){
		var c1=ColorUtils.create(color);
		var nColor=c1.numColor;
		var ctx={};
		ctx._curMat=new Matrix();
		ctx._italicDeg=0;
		ctx._drawTextureUseColor=0xffffffff;
		ctx.fillStyle=color;
		ctx._fillColor=0xffffffff;
		ctx.setFillColor=function (color){
			ctx._fillColor=color;
		}
		ctx.getFillColor=function (){
			return ctx._fillColor;
		}
		ctx.mixRGBandAlpha=function (value){
			return value;
		}
		ctx._drawTextureM=function (tex,x,y,width,height,m,alpha,uv){
			cbuf.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			cbuf.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);
			cbuf.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);
			cbuf.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			cbuf.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			cbuf.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			cbuf.uniformTexture(3,/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0,tex.bitmap._glTexture);
			var buffer=new Float32Array([
			x,y,uv[0],uv[1],0,0,
			x+width,y,uv[2],uv[3],0,0,
			x+width,y+height,uv[4],uv[5],0,0,
			x,y+height,uv[6],uv[7],0,0]);
			var i32=new Int32Array(buffer.buffer);
			i32[4]=i32[10]=i32[16]=i32[22]=0xffffffff;
			i32[5]=i32[11]=i32[17]=i32[23]=0xffffffff;
			cbuf.setRectMesh(1,buffer,buffer.length);
			cbuf.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			cbuf.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(cbuf);
		}
		FillBorderWordsCmdNative.cbook.filltext_native(ctx,null,data,x,y,font,color,strokeColor,strokeWidth,null,0);
	}

	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._graphicsCmdEncoder=null;
		this.words=null;
		Pool.recover("FillBorderWordsCmd",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "FillBorderWords";
	});

	FillBorderWordsCmdNative.create=function(words,x,y,font,color,strokeColor,strokeWidth){
		if (!FillBorderWordsCmdNative.cbook)new Error('Error:charbook not create!');
		var cmd=Pool.getItemByClass("FillBorderWordsCmd",FillBorderWordsCmdNative);
		var cbuf=cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		cmd.words=words;
		cmd.x=x;
		cmd.y=y;
		cmd.font=font;
		cmd.color=color;
		cmd.strokeColor=strokeColor;
		cmd.strokeWidth=strokeWidth;
		cmd._draw_texture_cmd_encoder_.clearEncoding();
		cmd.createFillBorderText(cmd._draw_texture_cmd_encoder_,words,x,y,font,color,strokeColor,strokeWidth);
		LayaGL.syncBufferToRenderThread(cmd._draw_texture_cmd_encoder_);
		cbuf.useCommandEncoder(cmd._draw_texture_cmd_encoder_.getPtrID(),-1,-1);
		LayaGL.syncBufferToRenderThread(cbuf);
		return cmd;
	}

	FillBorderWordsCmdNative.ID="FillBorderWords";
	__static(FillBorderWordsCmdNative,
	['cbook',function(){return this.cbook=Laya['textRender'];}
	]);
	return FillBorderWordsCmdNative;
})()


/**
*对象 cacheas normal的时候，本质上只是想把submit缓存起来，以后直接执行
*为了避免各种各样的麻烦，这里采用复制响应部分的submit的方法。执行环境还是在原来的context中
*否则包括clipt等都非常难以处理
*/
//class laya.webgl.canvas.WebGLCacheAsNormalCanvas
var WebGLCacheAsNormalCanvas=(function(){
	function WebGLCacheAsNormalCanvas(ctx,sp){
		this.submitStartPos=0;
		// 对应的context的submit的开始的地方
		this.submitEndPos=0;
		this.context=null;
		this.touches=[];
		//记录的文字信息。cacheas normal的话，文字要能正确touch
		this.submits=[];
		// 从context中剪切的submit
		this.sprite=null;
		// submit需要关联稳定独立的mesh。所以这里要创建自己的mesh对象
		this._mesh=null;
		//用Mesh2D代替_vb,_ib. 当前使用的mesh
		this._pathMesh=null;
		//矢量专用mesh。
		this._triangleMesh=null;
		//drawTriangles专用mesh。由于ib不固定，所以不能与_mesh通用
		this.meshlist=[];
		// 原始context的原始值
		this._oldMesh=null;
		this._oldPathMesh=null;
		this._oldTriMesh=null;
		this._oldMeshList=null;
		//private var oldMatrix:Matrix=null;//本地画的时候完全不应用矩阵，所以需要先保存老的，以便恢复 这样会丢失缩放信息，导致文字模糊，所以不用这种方式了
		this.oldTx=0;
		this.oldTy=0;
		this.cachedClipInfo=new Matrix();
		this.invMat=new Matrix();
		this.context=ctx;
		this.sprite=sp;
		ctx._globalClipMatrix.copyTo(this.cachedClipInfo);
	}

	__class(WebGLCacheAsNormalCanvas,'laya.webgl.canvas.WebGLCacheAsNormalCanvas');
	var __proto=WebGLCacheAsNormalCanvas.prototype;
	__proto.startRec=function(){
		if (this.context._charSubmitCache._enbale){
			this.context._charSubmitCache.enable(false,this.context);
			this.context._charSubmitCache.enable(true,this.context);
		}
		this.touches.length=0;
		(this.context).touches=this.touches;
		this.context._globalClipMatrix.copyTo(this.cachedClipInfo);
		this.submits.length=0;
		this.submitStartPos=this.context._submits._length;
		for (var i=0,sz=this.meshlist.length;i < sz;i++){
			var curm=this.meshlist[i];
			curm.canReuse?(curm.releaseMesh()):(curm.destroy());
		}
		this.meshlist.length=0;
		this._mesh=MeshQuadTexture.getAMesh();
		this._pathMesh=MeshVG.getAMesh();
		this._triangleMesh=MeshTexture.getAMesh();
		this.meshlist.push(this._mesh);
		this.meshlist.push(this._pathMesh);
		this.meshlist.push(this._triangleMesh);
		this.context._curSubmit=Submit.RENDERBASE;
		this._oldMesh=this.context._mesh;
		this._oldPathMesh=this.context._pathMesh;
		this._oldTriMesh=this.context._triangleMesh;
		this._oldMeshList=this.context.meshlist;
		this.context._mesh=this._mesh;
		this.context._pathMesh=this._pathMesh;
		this.context._triangleMesh=this._triangleMesh;
		this.context.meshlist=this.meshlist;
		this.oldTx=this.context._curMat.tx;
		this.oldTy=this.context._curMat.ty;
		this.context._curMat.tx=0;
		this.context._curMat.ty=0;
		this.context._curMat.copyTo(this.invMat);
		this.invMat.invert();
	}

	//context._curMat=matI;
	__proto.endRec=function(){
		if (this.context._charSubmitCache._enbale){
			this.context._charSubmitCache.enable(false,this.context);
			this.context._charSubmitCache.enable(true,this.context);
		};
		var parsubmits=(this.context)._submits;
		this.submitEndPos=parsubmits._length;
		var num=this.submitEndPos-this.submitStartPos;
		for (var i=0;i < num;i++){
			this.submits.push(parsubmits[this.submitStartPos+i]);
		}
		parsubmits._length-=num;
		this.context._mesh=this._oldMesh;
		this.context._pathMesh=this._oldPathMesh;
		this.context._triangleMesh=this._oldTriMesh;
		this.context.meshlist=this._oldMeshList;
		this.context._curSubmit=Submit.RENDERBASE;
		this.context._curMat.tx=this.oldTx;
		this.context._curMat.ty=this.oldTy;
		(this.context).touches=null;
	}

	/**
	*当前缓存是否还有效。例如clip变了就失效了，因为clip太难自动处理
	*@return
	*/
	__proto.isCacheValid=function(){
		var curclip=this.context._globalClipMatrix;
		if (curclip.a !=this.cachedClipInfo.a || curclip.b !=this.cachedClipInfo.b || curclip.c !=this.cachedClipInfo.c
			|| curclip.d !=this.cachedClipInfo.d || curclip.tx !=this.cachedClipInfo.tx || curclip.ty !=this.cachedClipInfo.ty)
		return false;
		return true;
	}

	__proto.flushsubmit=function(){
		var curSubmit=Submit.RENDERBASE;
		this.submits.forEach(function(subm){
			if (subm==Submit.RENDERBASE)return;
			Submit.preRender=curSubmit;
			curSubmit=subm;
			subm.renderSubmit();
		});
	}

	__proto.releaseMem=function(){}
	__static(WebGLCacheAsNormalCanvas,
	['matI',function(){return this.matI=new Matrix();}
	]);
	return WebGLCacheAsNormalCanvas;
})()


//class laya.webgl.shapes.EarcutNode
var EarcutNode=(function(){
	function EarcutNode(i,x,y){
		this.i=null;
		this.x=null;
		this.y=null;
		this.prev=null;
		this.next=null;
		this.z=null;
		this.prevZ=null;
		this.nextZ=null;
		this.steiner=null;
		this.i=i;
		this.x=x;
		this.y=y;
		this.prev=null;
		this.next=null;
		this.z=null;
		this.prevZ=null;
		this.nextZ=null;
		this.steiner=false;
	}

	__class(EarcutNode,'laya.webgl.shapes.EarcutNode');
	return EarcutNode;
})()


//class laya.webgl.shapes.BasePoly
var BasePoly=(function(){
	function BasePoly(){}
	__class(BasePoly,'laya.webgl.shapes.BasePoly');
	BasePoly.createLine2=function(p,indices,lineWidth,indexBase,outVertex,loop){
		if (p.length < 4)return null;
		var points=BasePoly.tempData.length>(p.length+2)?BasePoly.tempData:new Array(p.length+2);
		points[0]=p[0];points[1]=p[1];
		var newlen=2;
		var i=0;
		var length=p.length;
		for (i=2;i < length;i+=2){
			if (Math.abs(p[i]-p[i-2])+Math.abs(p[i+1]-p[i-1])> 0.01){
				points[newlen++]=p[i];points[newlen++]=p[i+1];
			}
		}
		if (loop && Math.abs(p[0]-points[newlen-2])+Math.abs(p[1]-points[newlen-1])> 0.01){
			points[newlen++]=p[0];points[newlen++]=p[1];
		};
		var result=outVertex;
		length=newlen / 2;
		var w=lineWidth / 2;
		var px,py,p1x,p1y,p2x,p2y,p3x,p3y;
		var perpx,perpy,perp2x,perp2y,perp3x,perp3y;
		var a1,b1,c1,a2,b2,c2;
		var denom,pdist,dist;
		p1x=points[0];
		p1y=points[1];
		p2x=points[2];
		p2y=points[3];
		perpx=-(p1y-p2y);
		perpy=p1x-p2x;
		dist=Math.sqrt(perpx *perpx+perpy *perpy);
		perpx=perpx / dist *w;
		perpy=perpy / dist *w;
		var tpx=perpx,tpy=perpy;
		result.push(p1x-perpx ,p1y-perpy ,p1x+perpx ,p1y+perpy);
		for (i=1;i < length-1;i++){
			p1x=points[(i-1)*2];
			p1y=points[(i-1)*2+1];
			p2x=points[(i)*2];
			p2y=points[(i)*2+1];
			p3x=points[(i+1)*2];
			p3y=points[(i+1)*2+1];
			perpx=-(p1y-p2y);
			perpy=p1x-p2x;
			dist=Math.sqrt(perpx *perpx+perpy *perpy);
			perpx=perpx / dist *w;
			perpy=perpy / dist *w;
			perp2x=-(p2y-p3y);
			perp2y=p2x-p3x;
			dist=Math.sqrt(perp2x *perp2x+perp2y *perp2y);
			perp2x=perp2x / dist *w;
			perp2y=perp2y / dist *w;
			a1=(-perpy+p1y)-(-perpy+p2y);
			b1=(-perpx+p2x)-(-perpx+p1x);
			c1=(-perpx+p1x)*(-perpy+p2y)-(-perpx+p2x)*(-perpy+p1y);
			a2=(-perp2y+p3y)-(-perp2y+p2y);
			b2=(-perp2x+p2x)-(-perp2x+p3x);
			c2=(-perp2x+p3x)*(-perp2y+p2y)-(-perp2x+p2x)*(-perp2y+p3y);
			denom=a1 *b2-a2 *b1;
			if (Math.abs(denom)< 0.1){
				denom+=10.1;
				result.push(p2x-perpx ,p2y-perpy ,p2x+perpx ,p2y+perpy);
				continue ;
			}
			px=(b1 *c2-b2 *c1)/ denom;
			py=(a2 *c1-a1 *c2)/ denom;
			pdist=(px-p2x)*(px-p2x)+(py-p2y)+(py-p2y);
			result.push(px,py ,p2x-(px-p2x),p2y-(py-p2y));
		}
		p1x=points[newlen-4];
		p1y=points[newlen-3];
		p2x=points[newlen-2];
		p2y=points[newlen-1];
		perpx=-(p1y-p2y);
		perpy=p1x-p2x;
		dist=Math.sqrt(perpx *perpx+perpy *perpy);
		perpx=perpx / dist *w;
		perpy=perpy / dist *w;
		result.push(p2x-perpx ,p2y-perpy ,p2x+perpx ,p2y+perpy);
		for (i=1;i < length;i++){
			indices.push(indexBase+(i-1)*2,indexBase+(i-1)*2+1,indexBase+i *2+1,indexBase+i *2+1,indexBase+i *2,indexBase+(i-1)*2);
		}
		return result;
	}

	BasePoly.createLineTriangle=function(path,color,width,loop,outvb,vbstride,outib){
		var points=path.slice();
		var ptlen=points.length;
		var p1x=points[0],p1y=points[1];
		var p2x=points[2],p2y=points[2];
		var len=0;
		var rp=0;
		var dx=0,dy=0;
		var pointnum=ptlen / 2;
		if (pointnum <=1)return;
		if (pointnum==2){
			return;
		};
		var tmpData=new Array(pointnum *4);
		var realPtNum=0;
		var ci=0;
		for (var i=0;i < pointnum-1;i++){
			p1x=points[ci++],p1y=points[ci++];
			p2x=points[ci++],p2y=points[ci++];
			dx=p2x-p1x,dy=p2y-p1y;
			if(dx!=0 && dy!=0){
				len=Math.sqrt(dx *dx+dy *dy);
				if (len > 1e-3){
					rp=realPtNum *4;
					tmpData[rp]=p1x;
					tmpData[rp+1]=p1y;
					tmpData[rp+2]=dx / len;
					tmpData[rp+3]=dy / len;
					realPtNum++;
				}
			}
		}
		if (loop){
			p1x=points[ptlen-2],p1y=points[ptlen-1];
			p2x=points[0],p2y=points[1];
			dx=p2x-p1x,dy=p2y-p1y;
			if(dx!=0 && dy!=0){
				len=Math.sqrt(dx *dx+dy *dy);
				if (len > 1e-3){
					rp=realPtNum *4;
					tmpData[rp]=p1x;
					tmpData[rp+1]=p1y;
					tmpData[rp+2]=dx / len;
					tmpData[rp+3]=dy / len;
					realPtNum++;
				}
			}
			}else {
			rp=realPtNum *4;
			tmpData[rp]=p1x;
			tmpData[rp+1]=p1y;
			tmpData[rp+2]=dx / len;
			tmpData[rp+3]=dy / len;
			realPtNum++;
		}
		ci=0;
		for (i=0;i < pointnum;i++){
			p1x=points[ci],p1y=points[ci+1];
			p2x=points[ci+2],p2y=points[ci+3];
			var p3x=points[ci+4],p3y=points[ci+5];
		}
		if (loop){}
			}
	__static(BasePoly,
	['tempData',function(){return this.tempData=new Array(256);}
	]);
	return BasePoly;
})()


/**
*...
*@author laoxie
*/
//class laya.webgl.text.CharSubmitCache
var CharSubmitCache=(function(){
	function CharSubmitCache(){
		this._data=[];
		this._ndata=0;
		this._tex=null;
		this._imgId=0;
		this._clipid=-1;
		this._enbale=false;
		this._colorFiler=null;
		this._clipMatrix=new Matrix();
	}

	__class(CharSubmitCache,'laya.webgl.text.CharSubmitCache');
	var __proto=CharSubmitCache.prototype;
	__proto.clear=function(){
		this._tex=null;
		this._imgId=-1;
		this._ndata=0;
		this._enbale=false;
		this._colorFiler=null;
	}

	__proto.destroy=function(){
		this.clear();
		this._data.length=0;
		this._data=null;
	}

	__proto.add=function(ctx,tex,imgid,pos,uv,color){
		if (this._ndata > 0 && (this._tex !=tex || this._imgId !=imgid ||
			(this._clipid>=0 && this._clipid!=ctx._clipInfoID))){
			this.submit(ctx);
		}
		this._clipid=ctx._clipInfoID;
		ctx._globalClipMatrix.copyTo(this._clipMatrix);
		this._tex=tex;
		this._imgId=imgid;
		this._colorFiler=ctx._colorFiler;
		this._data[this._ndata]=pos;
		this._data[this._ndata+1]=uv;
		this._data[this._ndata+2]=color;
		this._ndata+=3;
	}

	__proto.getPos=function(){
		if (CharSubmitCache.__nPosPool==0)
			return new Array(8);
		return CharSubmitCache.__posPool[--CharSubmitCache.__nPosPool];
	}

	__proto.enable=function(value,ctx){
		if (value===this._enbale)
			return;
		this._enbale=value;
		this._enbale || this.submit(ctx);
	}

	__proto.submit=function(ctx){
		var n=this._ndata;
		if (!n)
			return;
		var _mesh=ctx._mesh;
		var colorFiler=ctx._colorFiler;
		ctx._colorFiler=this._colorFiler;
		var submit=SubmitTexture.create(ctx,_mesh ,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0));
		ctx._submits[ctx._submits._length++]=ctx._curSubmit=submit;
		submit.shaderValue.textureHost=this._tex;
		submit._key.other=this._imgId;
		ctx._colorFiler=colorFiler;
		ctx._copyClipInfo(submit,this._clipMatrix);
		submit.clipInfoID=this._clipid;
		for (var i=0;i < n;i+=3){
			_mesh.addQuad(this._data[i],this._data[i+1] ,this._data [i+2],true);
			CharSubmitCache.__posPool[CharSubmitCache.__nPosPool++]=this._data[i];
		}
		n /=3;
		submit._numEle+=n*6;
		_mesh.indexNum+=n*6;
		_mesh.vertNum+=n*4;
		ctx._drawCount+=n;
		this._ndata=0;
		if (Stat.loopCount % 100==0)
			this._data.length=0;
	}

	CharSubmitCache.__posPool=[];
	CharSubmitCache.__nPosPool=0;
	return CharSubmitCache;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.DrawTextureCmdNative
var DrawTextureCmdNative=(function(){
	function DrawTextureCmdNative(){
		this._graphicsCmdEncoder=null;
		this._index=0;
		this._paramData=null;
		this._texture=null;
		this._x=NaN;
		this._y=NaN;
		this._width=NaN;
		this._height=NaN;
		this._matrix=null;
		this._alpha=NaN;
		this._color=null;
		this._blendMode=null;
		this._cmdCurrentPos=0;
		this._blend_src=0;
		this._blend_dest=0;
	}

	__class(DrawTextureCmdNative,'laya.layagl.cmdNative.DrawTextureCmdNative');
	var __proto=DrawTextureCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._texture=null;
		Pool.recover("DrawTextureCmd",this);
	}

	__proto._setBlendMode=function(value){
		switch(value){
			case /*laya.webgl.canvas.BlendMode.NORMAL*/"normal":
				this._blend_src=/*laya.webgl.WebGLContext.ONE*/1;
				this._blend_dest=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
				break ;
			case /*laya.webgl.canvas.BlendMode.ADD*/"add":
				this._blend_src=/*laya.webgl.WebGLContext.ONE*/1;
				this._blend_dest=/*laya.webgl.WebGLContext.DST_ALPHA*/0x0304;
				break ;
			case /*laya.webgl.canvas.BlendMode.MULTIPLY*/"multiply":
				this._blend_src=/*laya.webgl.WebGLContext.DST_COLOR*/0x0306;
				this._blend_dest=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
				break ;
			case /*laya.webgl.canvas.BlendMode.SCREEN*/"screen":
				this._blend_src=/*laya.webgl.WebGLContext.ONE*/1;
				this._blend_dest=/*laya.webgl.WebGLContext.ONE*/1;
				break ;
			case /*laya.webgl.canvas.BlendMode.LIGHT*/"light":
				this._blend_src=/*laya.webgl.WebGLContext.ONE*/1;
				this._blend_dest=/*laya.webgl.WebGLContext.ONE*/1;
				break ;
			case /*laya.webgl.canvas.BlendMode.OVERLAY*/"overlay":
				this._blend_src=/*laya.webgl.WebGLContext.ONE*/1;
				this._blend_dest=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_COLOR*/0x0301;
				break ;
			case /*laya.webgl.canvas.BlendMode.DESTINATIONOUT*/"destination-out":
				this._blend_src=/*laya.webgl.WebGLContext.ZERO*/0;
				this._blend_dest=/*laya.webgl.WebGLContext.ZERO*/0;
				break ;
			case /*laya.webgl.canvas.BlendMode.MASK*/"mask":
				this._blend_src=/*laya.webgl.WebGLContext.ZERO*/0;
				this._blend_dest=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
				break ;
			default :
				alert("_setBlendMode Unknown type");
				break ;
			}
	}

	__proto._mixRGBandAlpha=function(color,alpha){
		var a=((color & 0xff000000)>>> 24);
		if (a !=0){
			a*=alpha;
			}else {
			a=alpha*255;
		}
		return (color & 0x00ffffff)| (a << 24);
	}

	__getset(0,__proto,'cmdID',function(){
		return "DrawTexture";
	});

	__getset(0,__proto,'matrix',function(){
		return this._matrix;
		},function(matrix){
		if (!this._matrix){
			this._graphicsCmdEncoder._idata[this._cmdCurrentPos+1]=DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_.getPtrID();
			LayaGL.syncBufferToRenderThread(this._graphicsCmdEncoder);
		}
		this._matrix=matrix;
		var _fb=this._paramData._float32Data;
		_fb[DrawTextureCmdNative._PARAM_MATRIX_POS_]=matrix.a;
		_fb[DrawTextureCmdNative._PARAM_MATRIX_POS_+1]=matrix.b;
		_fb[DrawTextureCmdNative._PARAM_MATRIX_POS_+2]=matrix.c;
		_fb[DrawTextureCmdNative._PARAM_MATRIX_POS_+3]=matrix.d;
		_fb[DrawTextureCmdNative._PARAM_MATRIX_POS_+4]=matrix.tx;
		_fb[DrawTextureCmdNative._PARAM_MATRIX_POS_+5]=matrix.ty;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+1]=this._y;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+7]=this._y;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+13]=this._y+this._height;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+19]=this._y+this._height;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'texture',function(){
		return this._texture;
		},function(value){
		if (!value||!value.url){
			return;
		}
		this._texture=value;
		this._paramData._int32Data[DrawTextureCmdNative._PARAM_TEXTURE_POS_]=this._texture.bitmap._glTexture.id;
		var _fb=this._paramData._float32Data;
		var uv=this.texture.uv;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+2]=uv[0];_fb[DrawTextureCmdNative._PARAM_VB_POS_+3]=uv[1];
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+8]=uv[2];_fb[DrawTextureCmdNative._PARAM_VB_POS_+9]=uv[3];
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+14]=uv[4];_fb[DrawTextureCmdNative._PARAM_VB_POS_+15]=uv[5];
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+20]=uv[6];_fb[DrawTextureCmdNative._PARAM_VB_POS_+21]=uv[7];
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'width',function(){
		return this._width;
		},function(value){
		this._width=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_]=this._x;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+6]=this._x+this._width;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+12]=this._x+this._width;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+18]=this._x;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_]=this._x;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+6]=this._x+this._width;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+12]=this._x+this._width;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+18]=this._x;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'height',function(){
		return this._height;
		},function(value){
		this._height=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+1]=this._y;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+7]=this._y;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+13]=this._y+this._height;
		_fb[DrawTextureCmdNative._PARAM_VB_POS_+19]=this._y+this._height;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'alpha',function(){
		return this._alpha;
		},function(value){
		this._alpha=value;
	});

	DrawTextureCmdNative.create=function(texture,x,y,width,height,matrix,alpha,color,blendMode){
		var cmd=Pool.getItemByClass("DrawTextureCmd",DrawTextureCmdNative);
		cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		if (!DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_){
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(188,32,true);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_.blendFuncByParamData(DrawTextureCmdNative._PARAM_BLEND_SRC_POS_ *4,DrawTextureCmdNative._PARAM_BLEND_DEST_POS_ *4);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_.uniformTextureByParamData(DrawTextureCmdNative._PARAM_UNIFORM_LOCATION_POS_ *4,DrawTextureCmdNative._PARAM_TEX_LOCATION_POS_ *4,DrawTextureCmdNative._PARAM_TEXTURE_POS_ *4);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_.setRectMeshByParamData(DrawTextureCmdNative._PARAM_RECT_NUM_POS_*4,DrawTextureCmdNative._PARAM_VB_POS_*4,DrawTextureCmdNative._PARAM_VB_SIZE_POS_*4);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_);
		}
		if (!DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_){
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_=LayaGL.instance.createCommandEncoder(224,32,true);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_.blendFuncByParamData(DrawTextureCmdNative._PARAM_BLEND_SRC_POS_ *4,DrawTextureCmdNative._PARAM_BLEND_DEST_POS_ *4);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_.save();
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_.setGlobalValueByParamData(LayaNative2D.GLOBALVALUE_MATRIX32,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7,DrawTextureCmdNative._PARAM_MATRIX_POS_ *4);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_.uniformTextureByParamData(DrawTextureCmdNative._PARAM_UNIFORM_LOCATION_POS_ *4,DrawTextureCmdNative._PARAM_TEX_LOCATION_POS_ *4,DrawTextureCmdNative._PARAM_TEXTURE_POS_ *4);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_.setRectMeshByParamData(DrawTextureCmdNative._PARAM_RECT_NUM_POS_*4,DrawTextureCmdNative._PARAM_VB_POS_*4,DrawTextureCmdNative._PARAM_VB_SIZE_POS_*4);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_.restore();
			LayaGL.syncBufferToRenderThread(DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_);
		}
		if (!cmd._paramData){
			cmd._paramData=/*__JS__ */new ParamData(37*4,true);
			}{
			cmd._texture=texture;
			cmd._x=x;
			cmd._y=y;
			cmd._width=width;
			cmd._height=height;
			cmd._matrix=matrix;
			cmd._alpha=alpha;
			cmd._color=color;
			cmd._blendMode=blendMode;
			var w=width !=0 ? width :texture.bitmap.width;
			var h=height !=0 ? height :texture.bitmap.height;
			var uv=texture.uv;
			var _fb=cmd._paramData._float32Data;
			var _i32b=cmd._paramData._int32Data;
			_i32b[DrawTextureCmdNative._PARAM_UNIFORM_LOCATION_POS_]=3;
			_i32b[DrawTextureCmdNative._PARAM_TEX_LOCATION_POS_]=/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0;
			_i32b[DrawTextureCmdNative._PARAM_TEXTURE_POS_]=texture.bitmap._glTexture.id;
			_i32b[DrawTextureCmdNative._PARAM_RECT_NUM_POS_]=1;
			_i32b[DrawTextureCmdNative._PARAM_VB_SIZE_POS_]=24 *4;
			if (blendMode){
				cmd._setBlendMode(blendMode);
				_i32b[DrawTextureCmdNative._PARAM_BLEND_SRC_POS_]=cmd._blend_src;
				_i32b[DrawTextureCmdNative._PARAM_BLEND_DEST_POS_]=cmd._blend_dest;
				}else {
				_i32b[DrawTextureCmdNative._PARAM_BLEND_SRC_POS_]=-1;
				_i32b[DrawTextureCmdNative._PARAM_BLEND_DEST_POS_]=-1;
			};
			var rgba=0xffffffff;
			if(alpha){
				rgba=cmd._mixRGBandAlpha(rgba,alpha);
			};
			var ix=DrawTextureCmdNative._PARAM_VB_POS_;
			_fb[ix++]=x;_fb[ix++]=y;_fb[ix++]=uv[0];_fb[ix++]=uv[1];_i32b[ix++]=rgba;_i32b[ix++]=0xffffffff;
			_fb[ix++]=x+w;_fb[ix++]=y;_fb[ix++]=uv[2];_fb[ix++]=uv[3];_i32b[ix++]=rgba;_i32b[ix++]=0xffffffff;
			_fb[ix++]=x+w;_fb[ix++]=y+h;_fb[ix++]=uv[4];_fb[ix++]=uv[5];_i32b[ix++]=rgba;_i32b[ix++]=0xffffffff;
			_fb[ix++]=x;_fb[ix++]=y+h;_fb[ix++]=uv[6];_fb[ix++]=uv[7];_i32b[ix++]=rgba;_i32b[ix++]=0xffffffff;
			if (matrix){
				_fb[DrawTextureCmdNative._PARAM_MATRIX_POS_]=matrix.a;_fb[DrawTextureCmdNative._PARAM_MATRIX_POS_+1]=matrix.b;_fb[DrawTextureCmdNative._PARAM_MATRIX_POS_+2]=matrix.c;
				_fb[DrawTextureCmdNative._PARAM_MATRIX_POS_+3]=matrix.d;_fb[DrawTextureCmdNative._PARAM_MATRIX_POS_+4]=matrix.tx;_fb[DrawTextureCmdNative._PARAM_MATRIX_POS_+5]=matrix.ty;
			}
			LayaGL.syncBufferToRenderThread(cmd._paramData);
		}
		if (matrix){
			cmd._cmdCurrentPos=cmd._graphicsCmdEncoder.useCommandEncoder(DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_.getPtrID(),cmd._paramData.getPtrID(),-1);
		}
		else{
			cmd._cmdCurrentPos=cmd._graphicsCmdEncoder.useCommandEncoder(DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		}
		LayaGL.syncBufferToRenderThread(cmd._graphicsCmdEncoder);
		return cmd;
	}

	DrawTextureCmdNative.ID="DrawTexture";
	DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_=null;
	DrawTextureCmdNative._DRAW_TEXTURE_CMD_ENCODER_MATRIX_=null;
	DrawTextureCmdNative._PARAM_UNIFORM_LOCATION_POS_=0;
	DrawTextureCmdNative._PARAM_TEX_LOCATION_POS_=1;
	DrawTextureCmdNative._PARAM_TEXTURE_POS_=2;
	DrawTextureCmdNative._PARAM_RECT_NUM_POS_=3;
	DrawTextureCmdNative._PARAM_VB_SIZE_POS_=4;
	DrawTextureCmdNative._PARAM_VB_POS_=5;
	DrawTextureCmdNative._PARAM_MATRIX_POS_=29;
	DrawTextureCmdNative._PARAM_BLEND_SRC_POS_=35;
	DrawTextureCmdNative._PARAM_BLEND_DEST_POS_=36;
	return DrawTextureCmdNative;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.RestoreCmdNative
var RestoreCmdNative=(function(){
	function RestoreCmdNative(){
		this._graphicsCmdEncoder=null;
	}

	__class(RestoreCmdNative,'laya.layagl.cmdNative.RestoreCmdNative');
	var __proto=RestoreCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("RestoreCmd",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "Restore";
	});

	RestoreCmdNative.create=function(){
		var cmd=Pool.getItemByClass("RestoreCmd",RestoreCmdNative);
		var cbuf=cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		cbuf.restore();
		LayaGL.syncBufferToRenderThread(cbuf);
		return cmd;
	}

	RestoreCmdNative.ID="Restore";
	return RestoreCmdNative;
})()


/**
*WebGLRTMgr 管理WebGLRenderTarget的创建和回收
*/
//class laya.webgl.resource.WebGLRTMgr
var WebGLRTMgr=(function(){
	function WebGLRTMgr(){}
	__class(WebGLRTMgr,'laya.webgl.resource.WebGLRTMgr');
	WebGLRTMgr.getRT=function(w,h){
		w=w | 0;
		h=h | 0;
		if (w >=10000){
			console.error('getRT error! w too big');
		};
		var key=h *10000+w;
		var sw=WebGLRTMgr.dict[key];
		var ret;
		if (sw){
			if (sw.length > 0){
				ret=sw.pop();
				ret._mgrKey=key;
				return ret;
			}
		}
		ret=new RenderTexture2D(w,h,/*laya.webgl.resource.BaseTexture.FORMAT_R8G8B8A8*/1,-1);
		ret._mgrKey=key;
		return ret;
	}

	WebGLRTMgr.releaseRT=function(rt){
		if (rt._mgrKey <=0)
			return;
		var sw=WebGLRTMgr.dict[rt._mgrKey];
		!sw && (sw=[],WebGLRTMgr.dict[rt._mgrKey]=sw);
		rt._mgrKey=0;
		sw.push(rt);
	}

	WebGLRTMgr.dict={};
	return WebGLRTMgr;
})()


//class laya.layagl.cmdNative.DrawParticleCmdNative
var DrawParticleCmdNative=(function(){
	function DrawParticleCmdNative(){
		this._graphicsCmdEncoder=null;
		this._paramData=null;
		this.vbBuffer=null;
		this._template=null;
		this._floatCountPerVertex=29;
		//0~2为Position,3~5Velocity,6~9为StartColor,10~13为EndColor,14~16位SizeRotation,17到18位Radius,19~22位Radian,23为DurationAddScaleShaderValue,24为Time,25~28为CornerTextureCoordinate
		this._firstNewElement=0;
		this._firstFreeElement=0;
		this._firstActiveElement=0;
		this._firstRetiredElement=0;
		this._maxParticleNum=0;
	}

	__class(DrawParticleCmdNative,'laya.layagl.cmdNative.DrawParticleCmdNative');
	var __proto=DrawParticleCmdNative.prototype;
	__proto.updateParticle=function(){
		if (this._template.texture){
			this._template.updateParticleForNative();
			var _sv=this._template.sv;
			var _i32b=this._paramData._int32Data;
			var _fb=this._paramData._float32Data;
			var i=0;
			var n=0;
			_fb[DrawParticleCmdNative._PARAM_CURRENTTIME_POS_]=_sv.u_CurrentTime;
			_fb[DrawParticleCmdNative._PARAM_DURATION_POS_]=_sv.u_Duration;
			_fb[DrawParticleCmdNative._PARAM_ENDVEL_POS_]=_sv.u_EndVelocity;
			_fb[DrawParticleCmdNative._PARAM_GRAVITY_POS_]=_sv.u_Gravity[0];
			_fb[DrawParticleCmdNative._PARAM_GRAVITY_POS_+1]=_sv.u_Gravity[1];
			_fb[DrawParticleCmdNative._PARAM_GRAVITY_POS_+2]=_sv.u_Gravity[2];
			_sv.size[0]=RenderState2D.width;
			_sv.size[1]=RenderState2D.height;
			_fb[DrawParticleCmdNative._PARAM_SIZE_POS_]=_sv.size[0];
			_fb[DrawParticleCmdNative._PARAM_SIZE_POS_+1]=_sv.size[1];
			_fb[DrawParticleCmdNative._PARAM_MAT_POS_]=1;_fb[DrawParticleCmdNative._PARAM_MAT_POS_+1]=0;_fb[DrawParticleCmdNative._PARAM_MAT_POS_+2]=0;_fb[DrawParticleCmdNative._PARAM_MAT_POS_+3]=0;
			_fb[DrawParticleCmdNative._PARAM_MAT_POS_+4]=0;_fb[DrawParticleCmdNative._PARAM_MAT_POS_+5]=1;_fb[DrawParticleCmdNative._PARAM_MAT_POS_+6]=0;_fb[DrawParticleCmdNative._PARAM_MAT_POS_+7]=0;
			_fb[DrawParticleCmdNative._PARAM_MAT_POS_+8]=0;_fb[DrawParticleCmdNative._PARAM_MAT_POS_+9]=0;_fb[DrawParticleCmdNative._PARAM_MAT_POS_+10]=1;_fb[DrawParticleCmdNative._PARAM_MAT_POS_+11]=0;
			_fb[DrawParticleCmdNative._PARAM_MAT_POS_+12]=0;_fb[DrawParticleCmdNative._PARAM_MAT_POS_+13]=0;_fb[DrawParticleCmdNative._PARAM_MAT_POS_+14]=0;_fb[DrawParticleCmdNative._PARAM_MAT_POS_+15]=1;
			_i32b[DrawParticleCmdNative._PARAM_TEXTURE_LOC_POS_]=/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0;
			_i32b[DrawParticleCmdNative._PARAM_TEXTURE_POS_]=this._template.texture.bitmap._glTexture.id;
			this.vbBuffer=this._template.getConchMesh();
			this._firstNewElement=this._template.getFirstNewElement();
			this._firstFreeElement=this._template.getFirstFreeElement();
			this._firstActiveElement=this._template.getFirstActiveElement();
			this._firstRetiredElement=this._template.getFirstRetiredElement();
			var vb1Size=0;
			var vb2Size=0;
			var vb1Offset=0;
			var vb2Offset=0;
			var rect1_num=0;
			var rect2_num=0;
			if (this._firstActiveElement !=this._firstFreeElement){
				if (this._firstActiveElement < this._firstFreeElement){
					_i32b[DrawParticleCmdNative._PARAM_REGDATA_POS_]=1;
					rect1_num=this._firstFreeElement-this._firstActiveElement;
					vb1Size=(this._firstFreeElement-this._firstActiveElement)*this._floatCountPerVertex *4 *4;
					vb1Offset=this._firstActiveElement *this._floatCountPerVertex *4 *4;
				}
				else{
					_i32b[DrawParticleCmdNative._PARAM_REGDATA_POS_]=0;{
						rect1_num=this._maxParticleNum-this._firstActiveElement;
						vb1Size=(this._maxParticleNum-this._firstActiveElement)*this._floatCountPerVertex *4 *4;
						vb1Offset=this._firstActiveElement *this._floatCountPerVertex *4 *4;
						}{
						if (this._firstFreeElement > 0){
							rect2_num=this._firstFreeElement;
							vb2Size=this._firstFreeElement *this._floatCountPerVertex *4 *4;
							vb2Offset=0;
							}else {
							_i32b[DrawParticleCmdNative._PARAM_REGDATA_POS_]=1;
						}
					}
				}
			}
			_i32b[DrawParticleCmdNative._PARAM_VB1_POS_]=this.vbBuffer.getPtrID();
			_i32b[DrawParticleCmdNative._PARAM_RECT1_NUM_POS_]=rect1_num;
			_i32b[DrawParticleCmdNative._PARAM_VB1_SIZE_POS_]=vb1Size;
			_i32b[DrawParticleCmdNative._PARAM_VB1_OFFSET_POS_]=vb1Offset;
			LayaGL.syncBufferToRenderThread(this.vbBuffer);
			if (vb2Size > 0){
				_i32b[DrawParticleCmdNative._PARAM_VB2_POS_]=this.vbBuffer.getPtrID();
				_i32b[DrawParticleCmdNative._PARAM_RECT2_NUM_POS_]=rect2_num;
				_i32b[DrawParticleCmdNative._PARAM_VB2_SIZE_POS_]=vb2Size;
				_i32b[DrawParticleCmdNative._PARAM_VB2_OFFSET_POS_]=vb2Offset;
			}
			LayaGL.syncBufferToRenderThread(this._paramData);
			this._template.addDrawCounter();
		}
	}

	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._template=null;
		Pool.recover("DrawParticleCmd",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "DrawParticleCmd";
	});

	DrawParticleCmdNative.create=function(_temp){
		var cmd=Pool.getItemByClass("DrawParticleCmd",DrawParticleCmdNative);
		cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		if (!DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_){
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(284,32,true);
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWPARTICLE);
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHPARTICLE);
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.uniformByParamData(0,DrawParticleCmdNative._PARAM_CURRENTTIME_POS_ *4);
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.uniformByParamData(1,DrawParticleCmdNative._PARAM_DURATION_POS_ *4);
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.uniformByParamData(2,DrawParticleCmdNative._PARAM_ENDVEL_POS_ *4);
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.uniformByParamData(3,DrawParticleCmdNative._PARAM_GRAVITY_POS_ *4);
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.uniformByParamData(4,DrawParticleCmdNative._PARAM_SIZE_POS_ *4);
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.uniformByParamData(5,DrawParticleCmdNative._PARAM_MAT_POS_ *4);
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.uniformTextureByParamData(DrawParticleCmdNative._PARAM_TEXTURE_UNIFORMLOC_POS_*4,DrawParticleCmdNative._PARAM_TEXTURE_LOC_POS_*4,DrawParticleCmdNative._PARAM_TEXTURE_POS_*4);
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.setRectMeshExByParamData(DrawParticleCmdNative._PARAM_RECT1_NUM_POS_*4,DrawParticleCmdNative._PARAM_VB1_POS_ *4,DrawParticleCmdNative._PARAM_VB1_SIZE_POS_ *4,DrawParticleCmdNative._PARAM_VB1_OFFSET_POS_ *4);
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,1,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.loadDataToRegByParamData(0,DrawParticleCmdNative._PARAM_REGDATA_POS_*4,4);
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.ifGreater0(0,2);
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.setRectMeshExByParamData(DrawParticleCmdNative._PARAM_RECT2_NUM_POS_*4,DrawParticleCmdNative._PARAM_VB2_POS_ *4,DrawParticleCmdNative._PARAM_VB2_SIZE_POS_ *4,DrawParticleCmdNative._PARAM_VB2_OFFSET_POS_ *4);
			DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,1,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			LayaGL.syncBufferToRenderThread(DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_);
		}
		if (!cmd._paramData){
			cmd._paramData=/*__JS__ */new ParamData(36*4,true);
			}{
			cmd._template=_temp;
			cmd._maxParticleNum=_temp.settings.maxPartices;
			var _i32b=cmd._paramData._int32Data;
			var _sv=_temp._sv;
			var _fb=cmd._paramData._float32Data;
			var i=0;
			_fb[DrawParticleCmdNative._PARAM_CURRENTTIME_POS_]=-1;
			_fb[DrawParticleCmdNative._PARAM_DURATION_POS_]=-1;
			_fb[DrawParticleCmdNative._PARAM_ENDVEL_POS_]=-1;
			_fb[DrawParticleCmdNative._PARAM_GRAVITY_POS_]=-1;
			_fb[DrawParticleCmdNative._PARAM_GRAVITY_POS_+1]=-1;
			_fb[DrawParticleCmdNative._PARAM_GRAVITY_POS_+2]=-1;
			_fb[DrawParticleCmdNative._PARAM_SIZE_POS_]=-1;
			_fb[DrawParticleCmdNative._PARAM_SIZE_POS_+1]=-1;
			for (i=0;i < 16;i++){
				_fb[DrawParticleCmdNative._PARAM_MAT_POS_+i]=-1;
			}
			_i32b[DrawParticleCmdNative._PARAM_TEXTURE_LOC_POS_]=-1;
			_i32b[DrawParticleCmdNative._PARAM_TEXTURE_POS_]=-1;
			_i32b[DrawParticleCmdNative._PARAM_TEXTURE_UNIFORMLOC_POS_]=6;
			_i32b[DrawParticleCmdNative._PARAM_REGDATA_POS_]=0;
			_i32b[DrawParticleCmdNative._PARAM_VB1_POS_]=-1;
			_i32b[DrawParticleCmdNative._PARAM_VB2_POS_]=-1;
			_i32b[DrawParticleCmdNative._PARAM_VB1_SIZE_POS_]=-1;
			_i32b[DrawParticleCmdNative._PARAM_VB2_SIZE_POS_]=-1;
			_i32b[DrawParticleCmdNative._PARAM_RECT1_NUM_POS_]=-1;
			_i32b[DrawParticleCmdNative._PARAM_RECT2_NUM_POS_]=-1;
			LayaGL.syncBufferToRenderThread(cmd._paramData);
		}
		cmd._graphicsCmdEncoder.useCommandEncoder(DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		LayaGL.syncBufferToRenderThread(cmd._graphicsCmdEncoder);
		return cmd;
	}

	DrawParticleCmdNative.ID="DrawParticleCmd";
	DrawParticleCmdNative._DRAW_PARTICLE_CMD_ENCODER_=null;
	DrawParticleCmdNative._PARAM_VB1_POS_=0;
	DrawParticleCmdNative._PARAM_VB2_POS_=1;
	DrawParticleCmdNative._PARAM_VB1_SIZE_POS_=2;
	DrawParticleCmdNative._PARAM_VB2_SIZE_POS_=3;
	DrawParticleCmdNative._PARAM_CURRENTTIME_POS_=4;
	DrawParticleCmdNative._PARAM_DURATION_POS_=5;
	DrawParticleCmdNative._PARAM_ENDVEL_POS_=6;
	DrawParticleCmdNative._PARAM_GRAVITY_POS_=7;
	DrawParticleCmdNative._PARAM_SIZE_POS_=10;
	DrawParticleCmdNative._PARAM_MAT_POS_=12;
	DrawParticleCmdNative._PARAM_TEXTURE_LOC_POS_=28;
	DrawParticleCmdNative._PARAM_TEXTURE_POS_=29;
	DrawParticleCmdNative._PARAM_REGDATA_POS_=30;
	DrawParticleCmdNative._PARAM_TEXTURE_UNIFORMLOC_POS_=31;
	DrawParticleCmdNative._PARAM_RECT1_NUM_POS_=32;
	DrawParticleCmdNative._PARAM_RECT2_NUM_POS_=33;
	DrawParticleCmdNative._PARAM_VB1_OFFSET_POS_=34;
	DrawParticleCmdNative._PARAM_VB2_OFFSET_POS_=35;
	return DrawParticleCmdNative;
})()


//class laya.webgl.utils.RenderState2D
var RenderState2D=(function(){
	function RenderState2D(){}
	__class(RenderState2D,'laya.webgl.utils.RenderState2D');
	RenderState2D.mat2MatArray=function(mat,matArray){
		var m=mat;
		var m4=matArray;
		m4[0]=m.a;
		m4[1]=m.b;
		m4[2]=RenderState2D.EMPTYMAT4_ARRAY[2];
		m4[3]=RenderState2D.EMPTYMAT4_ARRAY[3];
		m4[4]=m.c;
		m4[5]=m.d;
		m4[6]=RenderState2D.EMPTYMAT4_ARRAY[6];
		m4[7]=RenderState2D.EMPTYMAT4_ARRAY[7];
		m4[8]=RenderState2D.EMPTYMAT4_ARRAY[8];
		m4[9]=RenderState2D.EMPTYMAT4_ARRAY[9];
		m4[10]=RenderState2D.EMPTYMAT4_ARRAY[10];
		m4[11]=RenderState2D.EMPTYMAT4_ARRAY[11];
		m4[12]=m.tx;
		m4[13]=m.ty;
		m4[14]=RenderState2D.EMPTYMAT4_ARRAY[14];
		m4[15]=RenderState2D.EMPTYMAT4_ARRAY[15];
		return matArray;
	}

	RenderState2D.restoreTempArray=function(){
		RenderState2D.TEMPMAT4_ARRAY[0]=1;
		RenderState2D.TEMPMAT4_ARRAY[1]=0;
		RenderState2D.TEMPMAT4_ARRAY[4]=0;
		RenderState2D.TEMPMAT4_ARRAY[5]=1;
		RenderState2D.TEMPMAT4_ARRAY[12]=0;
		RenderState2D.TEMPMAT4_ARRAY[13]=0;
	}

	RenderState2D.clear=function(){
		RenderState2D.worldScissorTest=false;
		RenderState2D.worldAlpha=1;
	}

	RenderState2D._MAXSIZE=99999999;
	RenderState2D.EMPTYMAT4_ARRAY=[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];
	RenderState2D.TEMPMAT4_ARRAY=[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];
	RenderState2D.worldMatrix4=RenderState2D.TEMPMAT4_ARRAY;
	RenderState2D.matWVP=null;
	RenderState2D.worldAlpha=1.0;
	RenderState2D.worldScissorTest=false;
	RenderState2D.worldShaderDefines=null;
	RenderState2D.worldFilters=null;
	RenderState2D.width=0;
	RenderState2D.height=0;
	__static(RenderState2D,
	['worldMatrix',function(){return this.worldMatrix=new Matrix();}
	]);
	return RenderState2D;
})()


/**
*...
*@author ww
*/
//class laya.layagl.QuickTestTool
var QuickTestTool=(function(){
	function QuickTestTool(){
		this._renderType=0;
		this._repaint=0;
		this._x=NaN;
		this._y=NaN;
	}

	__class(QuickTestTool,'laya.layagl.QuickTestTool');
	var __proto=QuickTestTool.prototype;
	//TODO:coverage
	__proto.render=function(context,x,y){
		Stat.spriteCount++;
		QuickTestTool._addType(this._renderType);
		QuickTestTool.showRenderTypeInfo(this._renderType);
		RenderSprite.renders[this._renderType]._fun(this,context,x+this._x,y+this._y);
		this._repaint=0;
	}

	//TODO:coverage
	__proto._stageRender=function(context,x,y){
		QuickTestTool._countStart();
		QuickTestTool._PreStageRender.call(Laya.stage,context,x,y);
		QuickTestTool._countEnd();
	}

	QuickTestTool.getMCDName=function(type){
		return QuickTestTool._typeToNameDic[type];
	}

	QuickTestTool.showRenderTypeInfo=function(type,force){
		(force===void 0)&& (force=false);
		if (!force&&QuickTestTool.showedDic[type])
			return;
		QuickTestTool.showedDic[type]=true;
		if (!QuickTestTool._rendertypeToStrDic[type]){
			var arr=[];
			var tType=0;
			tType=1;
			while (tType <=type){
				if (tType & type){
					arr.push(QuickTestTool.getMCDName(tType & type));
				}
				tType=tType << 1;
			}
			QuickTestTool._rendertypeToStrDic[type]=arr.join(",");
		}
		console.log("cmd:",QuickTestTool._rendertypeToStrDic[type]);
	}

	QuickTestTool.__init__=function(){
		QuickTestTool._typeToNameDic[ /*laya.display.SpriteConst.ALPHA*/0x01]="ALPHA";
		QuickTestTool._typeToNameDic[ /*laya.display.SpriteConst.TRANSFORM*/0x02]="TRANSFORM";
		QuickTestTool._typeToNameDic[ /*laya.display.SpriteConst.TEXTURE*/0x100]="TEXTURE";
		QuickTestTool._typeToNameDic[ /*laya.display.SpriteConst.GRAPHICS*/0x200]="GRAPHICS";
		QuickTestTool._typeToNameDic[ /*laya.display.SpriteConst.ONECHILD*/0x1000]="ONECHILD";
		QuickTestTool._typeToNameDic[ /*laya.display.SpriteConst.CHILDS*/0x2000]="CHILDS";
		QuickTestTool._typeToNameDic[ /*laya.display.SpriteConst.TRANSFORM*/0x02 | /*laya.display.SpriteConst.ALPHA*/0x01]="TRANSFORM|ALPHA";
		QuickTestTool._typeToNameDic[ /*laya.display.SpriteConst.CANVAS*/0x08]="CANVAS";
		QuickTestTool._typeToNameDic[ /*laya.display.SpriteConst.BLEND*/0x04]="BLEND";
		QuickTestTool._typeToNameDic[ /*laya.display.SpriteConst.FILTERS*/0x10]="FILTERS";
		QuickTestTool._typeToNameDic[ /*laya.display.SpriteConst.MASK*/0x20]="MASK";
		QuickTestTool._typeToNameDic[ /*laya.display.SpriteConst.CLIP*/0x40]="CLIP";
		QuickTestTool._typeToNameDic[ /*laya.display.SpriteConst.LAYAGL3D*/0x400]="LAYAGL3D";
	}

	QuickTestTool._countStart=function(){
		var key;
		for (key in QuickTestTool._countDic){
			QuickTestTool._countDic[key]=0;
		}
	}

	QuickTestTool._countEnd=function(){
		QuickTestTool._i++;
		if (QuickTestTool._i > 60){
			QuickTestTool.showCountInfo();
			QuickTestTool._i=0;
		}
	}

	QuickTestTool._addType=function(type){
		if (!QuickTestTool._countDic[type]){
			QuickTestTool._countDic[type]=1;
			}else{
			QuickTestTool._countDic[type]+=1;
		}
	}

	QuickTestTool.showCountInfo=function(){
		console.log("===================");
		var key;
		for (key in QuickTestTool._countDic){
			console.log("count:"+QuickTestTool._countDic[key]);
			QuickTestTool.showRenderTypeInfo(key,true);
		}
	}

	QuickTestTool.enableQuickTest=function(){
		QuickTestTool.__init__();
		Sprite["prototype"]["render"]=QuickTestTool["prototype"]["render"];
		QuickTestTool._PreStageRender=Stage["prototype"]["render"];
		Stage["prototype"]["render"]=QuickTestTool["prototype"]["_stageRender"];
	}

	QuickTestTool.showedDic={};
	QuickTestTool._rendertypeToStrDic={};
	QuickTestTool._typeToNameDic={};
	QuickTestTool._PreStageRender=null;
	QuickTestTool._countDic={};
	QuickTestTool._i=0;
	return QuickTestTool;
})()


/**
*...
*@author xie
*/
//class laya.webgl.submit.SubmitKey
var SubmitKey=(function(){
	function SubmitKey(){
		this.blendShader=0;
		this.submitType=0;
		this.other=0;
		this.clear();
	}

	__class(SubmitKey,'laya.webgl.submit.SubmitKey');
	var __proto=SubmitKey.prototype;
	__proto.clear=function(){
		this.submitType=-1;
		this.blendShader=this.other=0;
	}

	//TODO:coverage
	__proto.copyFrom=function(src){
		this.other=src.other;
		this.blendShader=src.blendShader;
		this.submitType=src.submitType;
	}

	//alpha=src.alpha;
	__proto.copyFrom2=function(src,submitType,other){
		this.other=other;
		this.submitType=submitType;
	}

	//TODO:coverage
	__proto.equal3_2=function(next,submitType,other){
		return this.submitType===submitType && this.other===other && this.blendShader===next.blendShader;
	}

	//TODO:coverage
	__proto.equal4_2=function(next,submitType,other){
		return this.submitType===submitType && this.other===other && this.blendShader===next.blendShader;
	}

	//TODO:coverage
	__proto.equal_3=function(next){
		return this.submitType===next.submitType && this.blendShader===next.blendShader;
	}

	//TODO:coverage
	__proto.equal=function(next){
		return this.other===next.other && this.submitType===next.submitType && this.blendShader===next.blendShader;
	}

	return SubmitKey;
})()


//class laya.layagl.cmdNative.FillBorderTextCmdNative
var FillBorderTextCmdNative=(function(){
	function FillBorderTextCmdNative(){
		this._graphicsCmdEncoder=null;
		this._index=0;
		this._text=null;
		this._x=NaN;
		this._y=NaN;
		this._font=null;
		this._color=null;
		this._strokeColor=null;
		this._strokeWidth=0;
		this._textAlign=null;
		this._draw_texture_cmd_encoder_=LayaGL.instance.createCommandEncoder(64,32,true);
	}

	__class(FillBorderTextCmdNative,'laya.layagl.cmdNative.FillBorderTextCmdNative');
	var __proto=FillBorderTextCmdNative.prototype;
	__proto.createFillBorderText=function(cbuf,text,x,y,font,color,strokeColor,strokeWidth,textAlign){
		var c1=ColorUtils.create(color);
		var nColor=c1.numColor;
		var ctx={};
		ctx._curMat=new Matrix();
		ctx._italicDeg=0;
		ctx._drawTextureUseColor=0xffffffff;
		ctx.fillStyle=color;
		ctx._fillColor=0xffffffff;
		ctx.setFillColor=function (color){
			ctx._fillColor=color;
		}
		ctx.getFillColor=function (){
			return ctx._fillColor;
		}
		ctx.mixRGBandAlpha=function (value){
			return value;
		}
		ctx._drawTextureM=function (tex,x,y,width,height,m,alpha,uv){
			cbuf.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			cbuf.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);
			cbuf.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);
			cbuf.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			cbuf.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			cbuf.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			cbuf.uniformTexture(3,/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0,tex.bitmap._glTexture);
			var buffer=new Float32Array([
			x,y,uv[0],uv[1],0,0,
			x+width,y,uv[2],uv[3],0,0,
			x+width,y+height,uv[4],uv[5],0,0,
			x,y+height,uv[6],uv[7],0,0]);
			var i32=new Int32Array(buffer.buffer);
			i32[4]=i32[10]=i32[16]=i32[22]=0xffffffff;
			i32[5]=i32[11]=i32[17]=i32[23]=0xffffffff;
			cbuf.setRectMesh(1,buffer,buffer.length);
			cbuf.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			cbuf.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(cbuf);
		}
		FillBorderTextCmdNative.cbook.filltext_native(ctx,text,null,x,y,font,color,strokeColor,strokeWidth,textAlign);
	}

	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._graphicsCmdEncoder=null;
		Pool.recover("FillBorderTextCmd",this);
	}

	__getset(0,__proto,'text',function(){
		return this._text;
		},function(value){
		var cbuf=this._draw_texture_cmd_encoder_;
		cbuf.clearEncoding();
		this._text=value;
		this.createFillBorderText(cbuf,this._text,this._x,this._y,this._font,this._color,this._strokeColor,this._strokeWidth,this._textAlign);
		LayaGL.syncBufferToRenderThread(cbuf);
	});

	__getset(0,__proto,'cmdID',function(){
		return "FillBorderText";
	});

	__getset(0,__proto,'font',function(){
		return this._font;
		},function(value){
		var cbuf=this._draw_texture_cmd_encoder_;
		cbuf.clearEncoding();
		this._font=value;
		this.createFillBorderText(cbuf,this._text,this._x,this._y,this._font,this._color,this._strokeColor,this._strokeWidth,this._textAlign);
		LayaGL.syncBufferToRenderThread(cbuf);
	});

	__getset(0,__proto,'color',function(){
		return this._color;
		},function(value){
		var cbuf=this._draw_texture_cmd_encoder_;
		cbuf.clearEncoding();
		this._color=value;
		this.createFillBorderText(cbuf,this._text,this._x,this._y,this._font,this._color,this._strokeColor,this._strokeWidth,this._textAlign);
		LayaGL.syncBufferToRenderThread(cbuf);
	});

	__getset(0,__proto,'textAlign',function(){
		return this._textAlign;
		},function(value){
		var cbuf=this._draw_texture_cmd_encoder_;
		cbuf.clearEncoding();
		this._textAlign=value;
		this.createFillBorderText(cbuf,this._text,this._x,this._y,this._font,this._color,this._strokeColor,this._strokeWidth,this._textAlign);
		LayaGL.syncBufferToRenderThread(cbuf);
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		var cbuf=this._draw_texture_cmd_encoder_;
		cbuf.clearEncoding();
		this._x=value;
		this.createFillBorderText(cbuf,this._text,this._x,this._y,this._font,this._color,this._strokeColor,this._strokeWidth,this._textAlign);
		LayaGL.syncBufferToRenderThread(cbuf);
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		var cbuf=this._draw_texture_cmd_encoder_;
		cbuf.clearEncoding();
		this._y=value;
		this.createFillBorderText(cbuf,this._text,this._x,this._y,this._font,this._color,this._strokeColor,this._strokeWidth,this._textAlign);
		LayaGL.syncBufferToRenderThread(cbuf);
	});

	FillBorderTextCmdNative.create=function(text,x,y,font,color,strokeColor,strokeWidth,textAlign){
		if (!FillBorderTextCmdNative.cbook)new Error('Error:charbook not create!');
		var cmd=Pool.getItemByClass("FillBorderTextCmd",FillBorderTextCmdNative);
		var cbuf=cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		cmd._text=text;
		cmd._x=x;
		cmd._y=y;
		cmd._font=font;
		cmd._color=color;
		cmd._strokeColor=strokeColor;
		cmd._strokeWidth=strokeWidth;
		cmd._textAlign=textAlign;
		cmd._draw_texture_cmd_encoder_.clearEncoding();
		cmd.createFillBorderText(cmd._draw_texture_cmd_encoder_,text,x,y,font,color,strokeColor,strokeWidth,textAlign);
		LayaGL.syncBufferToRenderThread(cmd._draw_texture_cmd_encoder_);
		cbuf.useCommandEncoder(cmd._draw_texture_cmd_encoder_.getPtrID(),-1,-1);
		LayaGL.syncBufferToRenderThread(cbuf);
		return cmd;
	}

	FillBorderTextCmdNative.ID="FillBorderText";
	__static(FillBorderTextCmdNative,
	['cbook',function(){return this.cbook=Laya['textRender'];}
	]);
	return FillBorderTextCmdNative;
})()


//class laya.layagl.ConchPropertyAdpt
var ConchPropertyAdpt=(function(){
	function ConchPropertyAdpt(){}
	__class(ConchPropertyAdpt,'laya.layagl.ConchPropertyAdpt');
	ConchPropertyAdpt.rewriteProperties=function(){
		laya.layagl.ConchPropertyAdpt.rewriteNumProperty(Rectangle.prototype,"x");
		laya.layagl.ConchPropertyAdpt.rewriteNumProperty(Rectangle.prototype,"y");
		laya.layagl.ConchPropertyAdpt.rewriteNumProperty(Rectangle.prototype,"width");
		laya.layagl.ConchPropertyAdpt.rewriteNumProperty(Rectangle.prototype,"height");
		laya.layagl.ConchPropertyAdpt.rewriteFunc(Rectangle.prototype,"recover");
	}

	ConchPropertyAdpt.rewriteNumProperty=function(proto,p){
		Object["defineProperty"](proto,p,{
			"get":function (){
				return this["_"+p] || 0;
			},
			"set":function (v){
				this["_"+p]=v;
				if (this.onPropertyChanged){
					this.onPropertyChanged(this);
				}
			}
		});
	}

	ConchPropertyAdpt.rewriteFunc=function(proto,p){
		proto["__"+p]=proto[p];
		proto[p]=function (){
			proto["__"+p].call(this);
			if (this.onPropertyChanged)
				this.onPropertyChanged=null;
		}
	}

	return ConchPropertyAdpt;
})()


/**
*<p> <code>Matrix</code> 类表示一个转换矩阵，它确定如何将点从一个坐标空间映射到另一个坐标空间。</p>
*<p>您可以对一个显示对象执行不同的图形转换，方法是设置 Matrix 对象的属性，将该 Matrix 对象应用于 Transform 对象的 matrix 属性，然后应用该 Transform 对象作为显示对象的 transform 属性。这些转换函数包括平移（x 和 y 重新定位）、旋转、缩放和倾斜。</p>
*/
//class laya.layagl.MatrixConch
var MatrixConch=(function(){
	function MatrixConch(a,b,c,d,tx,ty,nums){
		/**@private */
		//this._nums=null;
		/**@private 是否有旋转缩放操作*/
		//this._bTransform=false;
		(a===void 0)&& (a=1);
		(b===void 0)&& (b=0);
		(c===void 0)&& (c=0);
		(d===void 0)&& (d=1);
		(tx===void 0)&& (tx=0);
		(ty===void 0)&& (ty=0);
		this._nums=nums=nums ? nums :new Float32Array(6);
		nums[0]=a;
		nums[1]=b;
		nums[2]=c;
		nums[3]=d;
		nums[4]=tx;
		nums[5]=ty;
		this._checkTransform();
	}

	__class(MatrixConch,'laya.layagl.MatrixConch');
	var __proto=MatrixConch.prototype;
	/**
	*将本矩阵设置为单位矩阵。
	*@return 返回矩阵对象本身
	*/
	__proto.identity=function(){
		var nums=this._nums;
		nums[0]=nums[3]=1;
		nums[1]=nums[4]=nums[5]=nums[2]=0;
		this._bTransform=false;
		return this;
	}

	/**@private */
	__proto._checkTransform=function(){
		var nums=this._nums;
		return this._bTransform=(nums[0]!==1 || nums[1]!==0 || nums[2]!==0 || nums[3]!==1);
	}

	/**
	*设置沿 x 、y 轴平移每个点的距离。
	*@param x 沿 x 轴平移每个点的距离。
	*@param y 沿 y 轴平移每个点的距离。
	*@return 返回矩阵对象本身
	*/
	__proto.setTranslate=function(x,y){
		this._nums[4]=x;
		this._nums[5]=y;
		return this;
	}

	/**
	*沿 x 和 y 轴平移矩阵，平移的变化量由 x 和 y 参数指定。
	*@param x 沿 x 轴向右移动的量（以像素为单位）。
	*@param y 沿 y 轴向下移动的量（以像素为单位）。
	*@return 返回矩阵对象本身
	*/
	__proto.translate=function(x,y){
		this._nums[4]+=x;
		this._nums[5]+=y;
		return this;
	}

	/**
	*对矩阵应用缩放转换。
	*@param x 用于沿 x 轴缩放对象的乘数。
	*@param y 用于沿 y 轴缩放对象的乘数。
	*@return 返回矩阵对象本身
	*/
	__proto.scale=function(x,y){
		var nums=this._nums;
		nums[0] *=x;
		nums[3] *=y;
		nums[2] *=x;
		nums[1] *=y;
		nums[4] *=x;
		nums[5] *=y;
		this._bTransform=true;
		return this;
	}

	/**
	*对 Matrix 对象应用旋转转换。
	*@param angle 以弧度为单位的旋转角度。
	*@return 返回矩阵对象本身
	*/
	__proto.rotate=function(angle){
		var nums=this._nums;
		var cos=Math.cos(angle);
		var sin=Math.sin(angle);
		var a1=nums[0];
		var c1=nums[2];
		var tx1=nums[4];
		nums[0]=a1 *cos-nums[1] *sin;
		nums[1]=a1 *sin+nums[1] *cos;
		nums[2]=c1 *cos-nums[3] *sin;
		nums[3]=c1 *sin+nums[3] *cos;
		nums[4]=tx1 *cos-nums[5] *sin;
		nums[5]=tx1 *sin+nums[5] *cos;
		this._bTransform=true;
		return this;
	}

	/**
	*对 Matrix 对象应用倾斜转换。
	*@param x 沿着 X 轴的 2D 倾斜弧度。
	*@param y 沿着 Y 轴的 2D 倾斜弧度。
	*@return 返回矩阵对象本身
	*/
	__proto.skew=function(x,y){
		var nums=this._nums;
		var tanX=Math.tan(x);
		var tanY=Math.tan(y);
		var a1=nums[0];
		var b1=nums[1];
		nums[0]+=tanY *nums[2];
		nums[1]+=tanY *nums[3];
		nums[2]+=tanX *a1;
		nums[3]+=tanX *b1;
		return this;
	}

	/**
	*对指定的点应用当前矩阵的逆转化并返回此点。
	*@param out 待转化的点 Point 对象。
	*@return 返回out
	*/
	__proto.invertTransformPoint=function(out){
		var nums=this._nums;
		var a1=nums[0];
		var b1=nums[1];
		var c1=nums[2];
		var d1=nums[3];
		var tx1=nums[4];
		var n=a1 *d1-b1 *c1;
		var a2=d1 / n;
		var b2=-b1 / n;
		var c2=-c1 / n;
		var d2=a1 / n;
		var tx2=(c1 *nums[5]-d1 *tx1)/ n;
		var ty2=-(a1 *nums[5]-b1 *tx1)/ n;
		return out.setTo(a2 *out.x+c2 *out.y+tx2,b2 *out.x+d2 *out.y+ty2);
	}

	/**
	*将 Matrix 对象表示的几何转换应用于指定点。
	*@param out 用来设定输出结果的点。
	*@return 返回out
	*/
	__proto.transformPoint=function(out){
		var nums=this._nums;
		return out.setTo(nums[0] *out.x+nums[2] *out.y+nums[4],nums[1] *out.x+nums[3] *out.y+nums[5]);
	}

	/**
	*将 Matrix 对象表示的几何转换应用于指定点，忽略tx、ty。
	*@param out 用来设定输出结果的点。
	*@return 返回out
	*/
	__proto.transformPointN=function(out){
		var nums=this._nums;
		return out.setTo(nums[0] *out.x+nums[2] *out.y ,nums[1] *out.x+nums[3] *out.y);
	}

	/**
	*获取 X 轴缩放值。
	*@return X 轴缩放值。
	*/
	__proto.getScaleX=function(){
		var nums=this._nums;
		return nums[1]===0 ? this.a :Math.sqrt(nums[0] *nums[0]+nums[1] *nums[1]);
	}

	/**
	*获取 Y 轴缩放值。
	*@return Y 轴缩放值。
	*/
	__proto.getScaleY=function(){
		var nums=this._nums;
		return nums[2]===0 ? nums[3] :Math.sqrt(nums[2] *nums[2]+nums[3] *nums[3]);
	}

	/**
	*执行原始矩阵的逆转换。
	*@return 返回矩阵对象本身
	*/
	__proto.invert=function(){
		var nums=this._nums;
		var a1=nums[0];
		var b1=nums[1];
		var c1=nums[2];
		var d1=nums[3];
		var tx1=nums[4];
		var n=a1 *d1-b1 *c1;
		nums[0]=d1 / n;
		nums[1]=-b1 / n;
		nums[2]=-c1 / n;
		nums[3]=a1 / n;
		nums[4]=(c1 *this.ty-d1 *tx1)/ n;
		nums[5]=-(a1 *this.ty-b1 *tx1)/ n;
		return this;
	}

	/**
	*将 Matrix 的成员设置为指定值。
	*@param a 缩放或旋转图像时影响像素沿 x 轴定位的值。
	*@param b 旋转或倾斜图像时影响像素沿 y 轴定位的值。
	*@param c 旋转或倾斜图像时影响像素沿 x 轴定位的值。
	*@param d 缩放或旋转图像时影响像素沿 y 轴定位的值。
	*@param tx 沿 x 轴平移每个点的距离。
	*@param ty 沿 y 轴平移每个点的距离。
	*@return 返回矩阵对象本身
	*/
	__proto.setTo=function(a,b,c,d,tx,ty){
		var nums=this._nums;
		nums[0]=a,nums[1]=b,nums[2]=c,nums[3]=d,nums[4]=tx,nums[5]=ty;
		return this;
	}

	/**
	*将指定矩阵与当前矩阵连接，从而将这两个矩阵的几何效果有效地结合在一起。
	*@param matrix 要连接到源矩阵的矩阵。
	*@return 当前矩阵。
	*/
	__proto.concat=function(matrix){
		var nums=this._nums;
		var aNums=matrix._nums;
		var a=nums[0];
		var c=nums[2];
		var tx=nums[4];
		nums[0]=a *aNums[0]+nums[1] *aNums[2];
		nums[1]=a *aNums[1]+nums[1] *aNums[3];
		nums[2]=c *aNums[0]+nums[3] *aNums[2];
		nums[3]=c *aNums[1]+nums[3] *aNums[3];
		nums[4]=tx *aNums[0]+nums[5] *aNums[2]+aNums[4];
		nums[5]=tx *aNums[1]+nums[5] *aNums[3]+aNums[5];
		return this;
	}

	/**
	*@private
	*对矩阵应用缩放转换。反向相乘
	*@param x 用于沿 x 轴缩放对象的乘数。
	*@param y 用于沿 y 轴缩放对象的乘数。
	*/
	__proto.scaleEx=function(x,y){
		var nums=this._nums;
		var ba=nums[0],bb=nums[1],bc=nums[2],bd=nums[3];
		if (bb!==0 || bc!==0){
			nums[0]=x *ba;
			nums[1]=x *bb;
			nums[2]=y *bc;
			nums[3]=y *bd;
			}else {
			nums[0]=x *ba;
			nums[1]=0 *bd;
			nums[2]=0 *ba;
			nums[3]=y *bd;
		}
		this._bTransform=true;
	}

	/**
	*@private
	*对 Matrix 对象应用旋转转换。反向相乘
	*@param angle 以弧度为单位的旋转角度。
	*/
	__proto.rotateEx=function(angle){
		var nums=this._nums;
		var cos=Math.cos(angle);
		var sin=Math.sin(angle);
		var ba=nums[0],bb=nums[1],bc=nums[2],bd=nums[3];
		if (bb!==0 || bc!==0){
			nums[0]=cos *ba+sin *bc;
			nums[1]=cos *bb+sin *bd;
			nums[2]=-sin *ba+cos *bc;
			nums[3]=-sin *bb+cos *bd;
			}else {
			nums[0]=cos *ba;
			nums[1]=sin *bd;
			nums[2]=-sin *ba;
			nums[3]=cos *bd;
		}
		this._bTransform=true;
	}

	/**
	*返回此 Matrix 对象的副本。
	*@return 与原始实例具有完全相同的属性的新 Matrix 实例。
	*/
	__proto.clone=function(){
		var nums=this._nums;
		var dec=MatrixConch.create();
		var dNums=dec._nums;
		dNums[0]=nums[0];
		dNums[1]=nums[1];
		dNums[2]=nums[2];
		dNums[3]=nums[3];
		dNums[4]=nums[4];
		dNums[5]=nums[5];
		dec._bTransform=this._bTransform;
		return dec;
	}

	/**
	*将当前 Matrix 对象中的所有矩阵数据复制到指定的 Matrix 对象中。
	*@param dec 要复制当前矩阵数据的 Matrix 对象。
	*@return 已复制当前矩阵数据的 Matrix 对象。
	*/
	__proto.copyTo=function(dec){
		var nums=this._nums;
		var dNums=dec._nums;
		dNums[0]=nums[0];
		dNums[1]=nums[1];
		dNums[2]=nums[2];
		dNums[3]=nums[3];
		dNums[4]=nums[4];
		dNums[5]=nums[5];
		dec._bTransform=this._bTransform;
		return dec;
	}

	/**
	*返回列出该 Matrix 对象属性的文本值。
	*@return 一个字符串，它包含 Matrix 对象的属性值：a、b、c、d、tx 和 ty。
	*/
	__proto.toString=function(){
		return this.a+","+this.b+","+this.c+","+this.d+","+this.tx+","+this.ty;
	}

	/**
	*销毁此对象。
	*/
	__proto.destroy=function(){
		this.recover();
	}

	/**
	*回收到对象池，方便复用
	*/
	__proto.recover=function(){
		MatrixConch._pool.push(this);
	}

	/**缩放或旋转图像时影响像素沿 x 轴定位的值。*/
	__getset(0,__proto,'a',function(){
		return this._nums[0];
		},function(value){
		this._nums[0]=value;
	});

	/**旋转或倾斜图像时影响像素沿 y 轴定位的值。*/
	__getset(0,__proto,'b',function(){
		return this._nums[1];
		},function(value){
		this._nums[1]=value;
	});

	/**旋转或倾斜图像时影响像素沿 x 轴定位的值。*/
	__getset(0,__proto,'c',function(){
		return this._nums[2];
		},function(value){
		this._nums[2]=value;
	});

	/**缩放或旋转图像时影响像素沿 y 轴定位的值。*/
	__getset(0,__proto,'d',function(){
		return this._nums[3];
		},function(value){
		this._nums[3]=value;
	});

	/**沿 x 轴平移每个点的距离。*/
	__getset(0,__proto,'tx',function(){
		return this._nums[4];
		},function(value){
		this._nums[4]=value;
	});

	/**沿 y 轴平移每个点的距离。*/
	__getset(0,__proto,'ty',function(){
		return this._nums[5];
		},function(value){
		this._nums[5]=value;
	});

	MatrixConch.mul=function(m1,m2,out){
		var m1Nums=m1._nums;
		var m2Nums=m2._nums;
		var oNums=out._nums;
		var aa=m1Nums[0],ab=m1Nums[1],ac=m1Nums[2],ad=m1Nums[3],atx=m1Nums[4],aty=m1Nums[5];
		var ba=m2Nums[0],bb=m2Nums[1],bc=m2Nums[2],bd=m2Nums[3],btx=m2Nums[4],bty=m2Nums[5];
		if (bb!==0 || bc!==0){
			oNums[0]=aa *ba+ab *bc;
			oNums[1]=aa *bb+ab *bd;
			oNums[2]=ac *ba+ad *bc;
			oNums[3]=ac *bb+ad *bd;
			oNums[4]=ba *atx+bc *aty+btx;
			oNums[5]=bb *atx+bd *aty+bty;
			}else {
			oNums[0]=aa *ba;
			oNums[1]=ab *bd;
			oNums[2]=ac *ba;
			oNums[3]=ad *bd;
			oNums[4]=ba *atx+btx;
			oNums[5]=bd *aty+bty;
		}
		return out;
	}

	MatrixConch.mul16=function(m1,m2,out){
		var m1Nums=m1._nums;
		var m2Nums=m2._nums;
		var aa=m1Nums[0],ab=m1Nums[1],ac=m1Nums[2],ad=m1Nums[3],atx=m1Nums[4],aty=m1Nums[5];
		var ba=m2Nums[0],bb=m2Nums[1],bc=m2Nums[2],bd=m2Nums[3],btx=m2Nums[4],bty=m2Nums[5];
		if (bb!==0 || bc!==0){
			out[0]=aa *ba+ab *bc;
			out[1]=aa *bb+ab *bd;
			out[4]=ac *ba+ad *bc;
			out[5]=ac *bb+ad *bd;
			out[12]=ba *atx+bc *aty+btx;
			out[13]=bb *atx+bd *aty+bty;
			}else {
			out[0]=aa *ba;
			out[1]=ab *bd;
			out[4]=ac *ba;
			out[5]=ad *bd;
			out[12]=ba *atx+btx;
			out[13]=bd *aty+bty;
		}
		return out;
	}

	MatrixConch.create=function(nums){
		var m;
		if (MatrixConch._pool.length){
			m=MatrixConch._pool.pop();
			nums && (m._nums=nums);
			m.identity();
			return m;
		}else return new MatrixConch(1,0,0,1,0,0,nums);
	}

	MatrixConch.A=0;
	MatrixConch.B=1;
	MatrixConch.C=2;
	MatrixConch.D=3;
	MatrixConch.TX=4;
	MatrixConch.TY=5;
	MatrixConch.EMPTY=new MatrixConch();
	MatrixConch.TEMP=new MatrixConch();
	MatrixConch._pool=[];
	return MatrixConch;
})()


/**
*由于drawTextureM需要一个Texture对象，又不想真的弄一个，所以，做个假的，只封装必须成员
*/
//class laya.webgl.resource.CharInternalTexture
var CharInternalTexture=(function(){
	function CharInternalTexture(par){
		this._par=null;
		this._loaded=true;
		//drawTextureM的条件
		this.bitmap={};
		this.bitmap.id=par.id;
		this._par=par;
	}

	__class(CharInternalTexture,'laya.webgl.resource.CharInternalTexture');
	var __proto=CharInternalTexture.prototype;
	__proto._getSource=function(){
		return this._par._source;
	}

	return CharInternalTexture;
})()


;
/**
*...
*@author James
*/
//class laya.layagl.LayaNative2D
var LayaNative2D=(function(){
	function LayaNative2D(){}
	__class(LayaNative2D,'laya.layagl.LayaNative2D');
	LayaNative2D._init_simple_texture_cmdEncoder_=function(){
		LayaNative2D._SIMPLE_TEXTURE_CMDENCODER_=LayaGL.instance.createCommandEncoder(172,32,true);
		LayaNative2D._SIMPLE_TEXTURE_CMDENCODER_.useProgramEx(laya.layagl.LayaNative2D.PROGRAMEX_DRAWTEXTURE);
		LayaNative2D._SIMPLE_TEXTURE_CMDENCODER_.useVDO(laya.layagl.LayaNative2D.VDO_MESHQUADTEXTURE);
		LayaNative2D._SIMPLE_TEXTURE_CMDENCODER_.uniformEx(laya.layagl.LayaNative2D.GLOBALVALUE_VIEWS,0);
		LayaNative2D._SIMPLE_TEXTURE_CMDENCODER_.uniformEx(laya.layagl.LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
		LayaNative2D._SIMPLE_TEXTURE_CMDENCODER_.uniformEx(laya.layagl.LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
		LayaNative2D._SIMPLE_TEXTURE_CMDENCODER_.uniformTextureByParamData(0,1 *4,2 *4);
		LayaNative2D._SIMPLE_TEXTURE_CMDENCODER_.blendFuncByGlobalValue(laya.layagl.LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,laya.layagl.LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
		LayaNative2D._SIMPLE_TEXTURE_CMDENCODER_.setRectMeshByParamData(3 *4,5 *4,4 *4);
		LayaNative2D._SIMPLE_TEXTURE_CMDENCODER_.modifyMesh(laya.layagl.LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
		LayaNative2D._SIMPLE_TEXTURE_CMDENCODER_.modifyMesh(laya.layagl.LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
		LayaGL.syncBufferToRenderThread(LayaNative2D._SIMPLE_TEXTURE_CMDENCODER_);
	}

	LayaNative2D._init_simple_rect_cmdEncoder_=function(){
		LayaNative2D._SIMPLE_RECT_CMDENCODER_=LayaGL.instance.createCommandEncoder(136,32,true);
		LayaNative2D._SIMPLE_RECT_CMDENCODER_.useProgramEx(laya.layagl.LayaNative2D.PROGRAMEX_DRAWTEXTURE);
		LayaNative2D._SIMPLE_RECT_CMDENCODER_.useVDO(laya.layagl.LayaNative2D.VDO_MESHQUADTEXTURE);
		LayaNative2D._SIMPLE_RECT_CMDENCODER_.uniformEx(laya.layagl.LayaNative2D.GLOBALVALUE_VIEWS,0);
		LayaNative2D._SIMPLE_RECT_CMDENCODER_.uniformEx(laya.layagl.LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
		LayaNative2D._SIMPLE_RECT_CMDENCODER_.uniformEx(laya.layagl.LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
		LayaNative2D._SIMPLE_RECT_CMDENCODER_.setRectMeshByParamData(0*4,2 *4,1 *4);
		LayaNative2D._SIMPLE_RECT_CMDENCODER_.modifyMesh(laya.layagl.LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
		LayaNative2D._SIMPLE_RECT_CMDENCODER_.modifyMesh(laya.layagl.LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
		LayaGL.syncBufferToRenderThread(LayaNative2D._SIMPLE_RECT_CMDENCODER_);
	}

	LayaNative2D._init_rect_border_cmdEncoder_=function(){
		LayaNative2D._RECT_BORDER_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(152,32,true);
		LayaNative2D._RECT_BORDER_CMD_ENCODER_.useProgramEx(laya.layagl.LayaNative2D.PROGRAMEX_DRAWVG);
		LayaNative2D._RECT_BORDER_CMD_ENCODER_.useVDO(laya.layagl.LayaNative2D.VDO_MESHVG);
		LayaNative2D._RECT_BORDER_CMD_ENCODER_.uniformEx(laya.layagl.LayaNative2D.GLOBALVALUE_VIEWS,0);
		LayaNative2D._RECT_BORDER_CMD_ENCODER_.uniformEx(laya.layagl.LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
		LayaNative2D._RECT_BORDER_CMD_ENCODER_.uniformEx(laya.layagl.LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
		LayaNative2D._RECT_BORDER_CMD_ENCODER_.setMeshByParamData(5 *4,0 *4,1 *4,35 *4,2 *4,3 *4,4 *4);
		LayaNative2D._RECT_BORDER_CMD_ENCODER_.modifyMesh(laya.layagl.LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
		LayaNative2D._RECT_BORDER_CMD_ENCODER_.modifyMesh(laya.layagl.LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
		LayaGL.syncBufferToRenderThread(LayaNative2D._RECT_BORDER_CMD_ENCODER_);
	}

	LayaNative2D.__init__=function(){
		if (Render.isConchApp){
			var layaGL=LayaGL.instance;
			LayaNative2D.GLOBALVALUE_MATRIX32=layaGL.addGlobalValueDefine(0,/*laya.webgl.WebGLContext.FLOAT*/0x1406,6,new Float32Array([1,0,0,1,0,0]));
			LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR=layaGL.addGlobalValueDefine(0,/*laya.webgl.WebGLContext.INT*/0x1404,1,new Uint32Array([0xFFFFFFFF]));
			LayaNative2D.GLOBALVALUE_ITALICDEG=layaGL.addGlobalValueDefine(0,/*laya.webgl.WebGLContext.FLOAT*/0x1406,1,new Float32Array([0]));
			LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR=layaGL.addGlobalValueDefine(0,/*laya.webgl.WebGLContext.FLOAT*/0x1406,4,new Float32Array([1e6,0,0,1e6]));
			LayaNative2D.GLOBALVALUE_CLIP_MAT_POS=layaGL.addGlobalValueDefine(0,/*laya.webgl.WebGLContext.FLOAT*/0x1406,2,new Float32Array([0,0]));
			LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC=layaGL.addGlobalValueDefine(0,/*laya.webgl.WebGLContext.INT*/0x1404,1,new Int32Array([ /*laya.webgl.WebGLContext.ONE*/1]));
			LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST=layaGL.addGlobalValueDefine(0,/*laya.webgl.WebGLContext.INT*/0x1404,1,new Int32Array([ /*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303]));
			LayaNative2D.GLOBALVALUE_COLORFILTER_COLOR=layaGL.addGlobalValueDefine(0,/*laya.webgl.WebGLContext.FLOAT*/0x1406,16,new Float32Array([1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1]));
			LayaNative2D.GLOBALVALUE_COLORFILTER_ALPHA=layaGL.addGlobalValueDefine(0,/*laya.webgl.WebGLContext.FLOAT*/0x1406,4,new Float32Array([0,0,0,1]));
			LayaNative2D.GLOBALVALUE_BLURFILTER_STRENGTH=layaGL.addGlobalValueDefine(0,/*laya.webgl.WebGLContext.FLOAT*/0x1406,4,new Float32Array([0,0,0,0]));
			LayaNative2D.GLOBALVALUE_BLURFILTER_BLURINFO=layaGL.addGlobalValueDefine(0,/*laya.webgl.WebGLContext.FLOAT*/0x1406,2,new Float32Array([0,0]));
			LayaNative2D.GLOBALVALUE_GLOWFILTER_COLOR=layaGL.addGlobalValueDefine(0,/*laya.webgl.WebGLContext.FLOAT*/0x1406,4,new Float32Array([0,0,0,0]));
			LayaNative2D.GLOBALVALUE_GLOWFILTER_BLURINFO1=layaGL.addGlobalValueDefine(0,/*laya.webgl.WebGLContext.FLOAT*/0x1406,4,new Float32Array([0,0,0,0]));
			LayaNative2D.GLOBALVALUE_GLOWFILTER_BLURINFO2=layaGL.addGlobalValueDefine(0,/*laya.webgl.WebGLContext.FLOAT*/0x1406,4,new Float32Array([0,0,0,0]));
			layaGL.endGlobalValueDefine();
			LayaNative2D.PROGRAMEX_DRAWTEXTURE=LayaGL.instance.createProgramEx("/*\n	texture和fillrect使用的。\n*/\nattribute vec4 posuv;\nattribute vec4 attribColor;\nattribute vec4 attribFlags;\n//attribute vec4 clipDir;\n//attribute vec2 clipRect;\nuniform vec4 clipMatDir;\nuniform vec2 clipMatPos;		// 这个是全局的，不用再应用矩阵了。\nvarying vec2 cliped;\nuniform vec2 size;\n\n#ifdef WORLDMAT\n	uniform mat4 mmat;\n#endif\nuniform mat4 u_MvpMatrix;\n\nvarying vec4 v_texcoordAlpha;\nvarying vec4 v_color;\nvarying float v_useTex;\n\nvoid main() {\n\n	vec4 pos = vec4(posuv.xy,0.,1.);\n#ifdef WORLDMAT\n	pos=mmat*pos;\n#endif\n	vec4 pos1  =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,0.,1.0);\n#ifdef MVP3D\n	gl_Position=u_MvpMatrix*pos1;\n#else\n	gl_Position=pos1;\n#endif\n	v_texcoordAlpha.xy = posuv.zw;\n	//v_texcoordAlpha.z = attribColor.a/255.0;\n	v_color = attribColor/255.0;\n	v_color.xyz*=v_color.w;//反正后面也要预乘\n	\n	v_useTex = attribFlags.r/255.0;\n	float clipw = length(clipMatDir.xy);\n	float cliph = length(clipMatDir.zw);\n	vec2 clippos = pos.xy - clipMatPos.xy;	//pos已经应用矩阵了，为了减的有意义，clip的位置也要缩放\n	if(clipw>20000. && cliph>20000.)\n		cliped = vec2(0.5,0.5);\n	else {\n		//转成0到1之间。/clipw/clipw 表示clippos与normalize之后的clip朝向点积之后，再除以clipw\n		cliped=vec2( dot(clippos,clipMatDir.xy)/clipw/clipw, dot(clippos,clipMatDir.zw)/cliph/cliph);\n	}\n\n}","/*\n	texture和fillrect使用的。\n*/\n\nprecision mediump float;\n//precision highp float;\nvarying vec4 v_texcoordAlpha;\nvarying vec4 v_color;\nvarying float v_useTex;\nuniform sampler2D texture;\nvarying vec2 cliped;\n\n#ifdef BLUR_FILTER\nuniform vec4 strength_sig2_2sig2_gauss1;\nuniform vec2 blurInfo;\n\n#define PI 3.141593\n\nfloat getGaussian(float x, float y){\n    return strength_sig2_2sig2_gauss1.w*exp(-(x*x+y*y)/strength_sig2_2sig2_gauss1.z);\n}\n\nvec4 blur(){\n    const float blurw = 9.0;\n    vec4 vec4Color = vec4(0.0,0.0,0.0,0.0);\n    vec2 halfsz=vec2(blurw,blurw)/2.0/blurInfo;    \n    vec2 startpos=v_texcoordAlpha.xy-halfsz;\n    vec2 ctexcoord = startpos;\n    vec2 step = 1.0/blurInfo;  //每个像素      \n    \n    for(float y = 0.0;y<=blurw; ++y){\n        ctexcoord.x=startpos.x;\n        for(float x = 0.0;x<=blurw; ++x){\n            //TODO 纹理坐标的固定偏移应该在vs中处理\n            vec4Color += texture2D(texture, ctexcoord)*getGaussian(x-blurw/2.0,y-blurw/2.0);\n            ctexcoord.x+=step.x;\n        }\n        ctexcoord.y+=step.y;\n    }\n    return vec4Color;\n}\n#endif\n\n#ifdef COLOR_FILTER\nuniform vec4 colorAlpha;\nuniform mat4 colorMat;\n#endif\n\n#ifdef GLOW_FILTER\nuniform vec4 u_color;\nuniform vec4 u_blurInfo1;\nuniform vec4 u_blurInfo2;\n#endif\n\n#ifdef COLOR_ADD\nuniform vec4 colorAdd;\n#endif\n\n//FILLTEXTURE\nuniform vec4 u_TexRange;//startu,startv,urange, vrange\n\nvoid main() {\n	if(cliped.x<0.) discard;\n	if(cliped.x>1.) discard;\n	if(cliped.y<0.) discard;\n	if(cliped.y>1.) discard;\n	\n#ifdef FILLTEXTURE	\n   vec4 color= texture2D(texture, fract(v_texcoordAlpha.xy)*u_TexRange.zw + u_TexRange.xy);\n#else\n   vec4 color= texture2D(texture, v_texcoordAlpha.xy);\n#endif\n\n   if(v_useTex<=0.)color = vec4(1.,1.,1.,1.);\n   color.a*=v_color.w;\n   //color.rgb*=v_color.w;\n   color.rgb*=v_color.rgb;\n   gl_FragColor=color;\n   \n   #ifdef COLOR_ADD\n	gl_FragColor = vec4(colorAdd.rgb,colorAdd.a*gl_FragColor.a);\n	gl_FragColor.xyz *= colorAdd.a;\n   #endif\n   \n   #ifdef BLUR_FILTER\n	gl_FragColor =   blur();\n	gl_FragColor.w*=v_color.w;   \n   #endif\n   \n   #ifdef COLOR_FILTER\n	mat4 alphaMat =colorMat;\n\n	alphaMat[0][3] *= gl_FragColor.a;\n	alphaMat[1][3] *= gl_FragColor.a;\n	alphaMat[2][3] *= gl_FragColor.a;\n\n	gl_FragColor = gl_FragColor * alphaMat;\n	gl_FragColor += colorAlpha/255.0*gl_FragColor.a;\n   #endif\n   \n   #ifdef GLOW_FILTER\n	const float c_IterationTime = 10.0;\n	float floatIterationTotalTime = c_IterationTime * c_IterationTime;\n	vec4 vec4Color = vec4(0.0,0.0,0.0,0.0);\n	vec2 vec2FilterDir = vec2(-(u_blurInfo1.z)/u_blurInfo2.x,-(u_blurInfo1.w)/u_blurInfo2.y);\n	vec2 vec2FilterOff = vec2(u_blurInfo1.x/u_blurInfo2.x/c_IterationTime * 2.0,u_blurInfo1.y/u_blurInfo2.y/c_IterationTime * 2.0);\n	float maxNum = u_blurInfo1.x * u_blurInfo1.y;\n	vec2 vec2Off = vec2(0.0,0.0);\n	float floatOff = c_IterationTime/2.0;\n	for(float i = 0.0;i<=c_IterationTime; ++i){\n		for(float j = 0.0;j<=c_IterationTime; ++j){\n			vec2Off = vec2(vec2FilterOff.x * (i - floatOff),vec2FilterOff.y * (j - floatOff));\n			vec4Color += texture2D(texture, v_texcoordAlpha.xy + vec2FilterDir + vec2Off)/floatIterationTotalTime;\n		}\n	}\n	gl_FragColor = vec4(u_color.rgb,vec4Color.a * u_blurInfo2.z);\n	gl_FragColor.rgb *= gl_FragColor.a;   \n   #endif\n   \n}","posuv,attribColor,attribFlags","size,clipMatDir,clipMatPos,texture,colorMat,colorAlpha,strength_sig2_2sig2_gauss1,blurInfo,u_color,u_blurInfo1,u_blurInfo2");
			LayaNative2D.PROGRAMEX_DRAWVG=LayaGL.instance.createProgramEx("attribute vec4 position;\nattribute vec4 attribColor;\n//attribute vec4 clipDir;\n//attribute vec2 clipRect;\nuniform vec4 clipMatDir;\nuniform vec2 clipMatPos;\n#ifdef WORLDMAT\n	uniform mat4 mmat;\n#endif\nuniform mat4 u_mmat2;\n//uniform vec2 u_pos;\nuniform vec2 size;\nvarying vec4 color;\n//vec4 dirxy=vec4(0.9,0.1, -0.1,0.9);\n//vec4 clip=vec4(100.,30.,300.,600.);\nvarying vec2 cliped;\nvoid main(){\n	\n#ifdef WORLDMAT\n	vec4 pos=mmat*vec4(position.xy,0.,1.);\n	gl_Position =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);\n#else\n	gl_Position =vec4((position.x/size.x-0.5)*2.0,(0.5-position.y/size.y)*2.0,position.z,1.0);\n#endif	\n	float clipw = length(clipMatDir.xy);\n	float cliph = length(clipMatDir.zw);\n	vec2 clippos = position.xy - clipMatPos.xy;	//pos已经应用矩阵了，为了减的有意义，clip的位置也要缩放\n	if(clipw>20000. && cliph>20000.)\n		cliped = vec2(0.5,0.5);\n	else {\n		//clipdir是带缩放的方向，由于上面clippos是在缩放后的空间计算的，所以需要把方向先normalize一下\n		cliped=vec2( dot(clippos,clipMatDir.xy)/clipw/clipw, dot(clippos,clipMatDir.zw)/cliph/cliph);\n	}\n  //pos2d.x = dot(clippos,dirx);\n  color=attribColor/255.;\n}","precision mediump float;\n//precision mediump float;\nvarying vec4 color;\n//uniform float alpha;\nvarying vec2 cliped;\nvoid main(){\n	//vec4 a=vec4(color.r, color.g, color.b, 1);\n	//a.a*=alpha;\n    gl_FragColor= color;// vec4(color.r, color.g, color.b, alpha);\n	gl_FragColor.rgb*=color.a;\n	if(cliped.x<0.) discard;\n	if(cliped.x>1.) discard;\n	if(cliped.y<0.) discard;\n	if(cliped.y>1.) discard;\n}","position,attribColor","size,clipMatDir,clipMatPos");
			LayaNative2D.PROGRAMEX_DRAWPARTICLE=LayaGL.instance.createProgramEx("attribute vec4 a_CornerTextureCoordinate;\nattribute vec3 a_Position;\nattribute vec3 a_Velocity;\nattribute vec4 a_StartColor;\nattribute vec4 a_EndColor;\nattribute vec3 a_SizeRotation;\nattribute vec2 a_Radius;\nattribute vec4 a_Radian;\nattribute float a_AgeAddScale;\nattribute float a_Time;\n\nvarying vec4 v_Color;\nvarying vec2 v_TextureCoordinate;\n\nuniform float u_CurrentTime;\nuniform float u_Duration;\nuniform float u_EndVelocity;\nuniform vec3 u_Gravity;\n\nuniform vec2 size;\nuniform mat4 u_mmat;\n\nvec4 ComputeParticlePosition(in vec3 position, in vec3 velocity,in float age,in float normalizedAge)\n{\n\n   float startVelocity = length(velocity);//起始标量速度\n   float endVelocity = startVelocity * u_EndVelocity;//结束标量速度\n\n   float velocityIntegral = startVelocity * normalizedAge +(endVelocity - startVelocity) * normalizedAge *normalizedAge/2.0;//计算当前速度的标量（单位空间），vt=v0*t+(1/2)*a*(t^2)\n   \n   vec3 addPosition = normalize(velocity) * velocityIntegral * u_Duration;//计算受自身速度影响的位置，转换标量到矢量    \n   addPosition += u_Gravity * age * normalizedAge;//计算受重力影响的位置\n   \n   float radius=mix(a_Radius.x, a_Radius.y, normalizedAge); //计算粒子受半径和角度影响（无需计算角度和半径时，可用宏定义优化屏蔽此计算）\n   float radianHorizontal =mix(a_Radian.x,a_Radian.z,normalizedAge);\n   float radianVertical =mix(a_Radian.y,a_Radian.w,normalizedAge);\n   \n   float r =cos(radianVertical)* radius;\n   addPosition.y += sin(radianVertical) * radius;\n	\n   addPosition.x += cos(radianHorizontal) *r;\n   addPosition.z += sin(radianHorizontal) *r;\n  \n   addPosition.y=-addPosition.y;//2D粒子位置更新需要取负，2D粒子坐标系Y轴正向朝上\n   position+=addPosition;\n   return  vec4(position,1.0);\n}\n\nfloat ComputeParticleSize(in float startSize,in float endSize, in float normalizedAge)\n{    \n    float size = mix(startSize, endSize, normalizedAge);\n    return size;\n}\n\nmat2 ComputeParticleRotation(in float rot,in float age)\n{    \n    float rotation =rot * age;\n    //计算2x2旋转矩阵.\n    float c = cos(rotation);\n    float s = sin(rotation);\n    return mat2(c, -s, s, c);\n}\n\nvec4 ComputeParticleColor(in vec4 startColor,in vec4 endColor,in float normalizedAge)\n{\n	vec4 color=mix(startColor,endColor,normalizedAge);\n    //硬编码设置，使粒子淡入很快，淡出很慢,6.7的缩放因子把置归一在0到1之间，可以谷歌x*(1-x)*(1-x)*6.7的制图表\n    color.a *= normalizedAge * (1.0-normalizedAge) * (1.0-normalizedAge) * 6.7;\n   \n    return color;\n}\n\nvoid main()\n{\n   float age = u_CurrentTime - a_Time;\n   age *= 1.0 + a_AgeAddScale;\n   float normalizedAge = clamp(age / u_Duration,0.0,1.0);\n   gl_Position = ComputeParticlePosition(a_Position, a_Velocity, age, normalizedAge);//计算粒子位置\n   float pSize = ComputeParticleSize(a_SizeRotation.x,a_SizeRotation.y, normalizedAge);\n   mat2 rotation = ComputeParticleRotation(a_SizeRotation.z, age);\n	\n    mat4 mat=u_mmat;\n    gl_Position=vec4((mat*gl_Position).xy,0.0,1.0);\n    gl_Position.xy += (rotation*a_CornerTextureCoordinate.xy) * pSize*vec2(mat[0][0],mat[1][1]);\n    gl_Position=vec4((gl_Position.x/size.x-0.5)*2.0,(0.5-gl_Position.y/size.y)*2.0,0.0,1.0);\n   \n   v_Color = ComputeParticleColor(a_StartColor,a_EndColor, normalizedAge);\n   v_TextureCoordinate =a_CornerTextureCoordinate.zw;\n}\n\n","#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nvarying vec4 v_Color;\nvarying vec2 v_TextureCoordinate;\nuniform sampler2D u_texture;\n\nvoid main()\n{	\n	gl_FragColor=texture2D(u_texture,v_TextureCoordinate)*v_Color;\n	gl_FragColor.xyz *= v_Color.w;\n}","a_CornerTextureCoordinate,a_Position,a_Velocity,a_StartColor,a_EndColor,a_SizeRotation,a_Radius,a_Radian,a_AgeAddScale,a_Time","u_CurrentTime,u_Duration,u_EndVelocity,u_Gravity,size,u_mmat,u_texture");
			LayaNative2D.VDO_MESHQUADTEXTURE=layaGL.createVDO(new Int32Array([ /*laya.webgl.WebGLContext.FLOAT*/0x1406,0,4,24,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,16,4,24,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,20,4,24]));
			LayaNative2D.VDO_MESHVG=layaGL.createVDO(new Int32Array([ /*laya.webgl.WebGLContext.FLOAT*/0x1406,0,2,12,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,8,4,12]));
			LayaNative2D.VDO_MESHPARTICLE=layaGL.createVDO(new Int32Array([ /*laya.webgl.WebGLContext.FLOAT*/0x1406,0,4,116,/*laya.webgl.WebGLContext.FLOAT*/0x1406,16,3,116,/*laya.webgl.WebGLContext.FLOAT*/0x1406,28,3,116,/*laya.webgl.WebGLContext.FLOAT*/0x1406,40,4,116,/*laya.webgl.WebGLContext.FLOAT*/0x1406,56,4,116,/*laya.webgl.WebGLContext.FLOAT*/0x1406,72,3,116,/*laya.webgl.WebGLContext.FLOAT*/0x1406,84,2,116,/*laya.webgl.WebGLContext.FLOAT*/0x1406,92,4,116,/*laya.webgl.WebGLContext.FLOAT*/0x1406,108,1,116,/*laya.webgl.WebGLContext.FLOAT*/0x1406,112,1,116]));
			LayaNative2D._init_simple_texture_cmdEncoder_();
			LayaNative2D._init_simple_rect_cmdEncoder_();
			LayaNative2D._init_rect_border_cmdEncoder_();
			LayaNative2D.SHADER_MACRO_COLOR_FILTER=LayaGL.instance.defineShaderMacro("#define COLOR_FILTER",[ {uname:4,id:LayaNative2D.GLOBALVALUE_COLORFILTER_COLOR },{uname:5,id:LayaNative2D.GLOBALVALUE_COLORFILTER_ALPHA }]);
			LayaNative2D.SHADER_MACRO_BLUR_FILTER=LayaGL.instance.defineShaderMacro("#define BLUR_FILTER",[ {uname:6,id:LayaNative2D.GLOBALVALUE_BLURFILTER_STRENGTH },{uname:7,id:LayaNative2D.GLOBALVALUE_BLURFILTER_BLURINFO }]);
			LayaNative2D.SHADER_MACRO_GLOW_FILTER=LayaGL.instance.defineShaderMacro("#define GLOW_FILTER",[ {uname:8,id:LayaNative2D.GLOBALVALUE_GLOWFILTER_COLOR },{uname:9,id:LayaNative2D.GLOBALVALUE_GLOWFILTER_BLURINFO1 },{uname:10,id:LayaNative2D.GLOBALVALUE_GLOWFILTER_BLURINFO2 }]);
			LayaGLTemplate.__init__();
			LayaGLTemplate.__init_END_();
			if(TextRender.useOldCharBook)new CharBook();
			else new TextRender();
			CharPages.charRender=new CharRender_Native();
		}
	}

	LayaNative2D._SIMPLE_TEXTURE_CMDENCODER_=null;
	LayaNative2D._SIMPLE_RECT_CMDENCODER_=null;
	LayaNative2D._RECT_BORDER_CMD_ENCODER_=null;
	LayaNative2D.PROGRAMEX_DRAWTEXTURE=0;
	LayaNative2D.PROGRAMEX_DRAWVG=0;
	LayaNative2D.PROGRAMEX_DRAWRECT=0;
	LayaNative2D.PROGRAMEX_DRAWPARTICLE=0;
	LayaNative2D.VDO_MESHQUADTEXTURE=0;
	LayaNative2D.VDO_MESHVG=0;
	LayaNative2D.VDO_MESHPARTICLE=0;
	LayaNative2D.GLOBALVALUE_VIEWS=0;
	LayaNative2D.GLOBALVALUE_MATRIX32=0;
	LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR=0;
	LayaNative2D.GLOBALVALUE_ITALICDEG=0;
	LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR=0;
	LayaNative2D.GLOBALVALUE_CLIP_MAT_POS=0;
	LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC=0;
	LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST=0;
	LayaNative2D.GLOBALVALUE_COLORFILTER_COLOR=0;
	LayaNative2D.GLOBALVALUE_COLORFILTER_ALPHA=0;
	LayaNative2D.GLOBALVALUE_BLURFILTER_STRENGTH=0;
	LayaNative2D.GLOBALVALUE_BLURFILTER_BLURINFO=0;
	LayaNative2D.SHADER_MACRO_COLOR_FILTER=0;
	LayaNative2D.SHADER_MACRO_BLUR_FILTER=0;
	LayaNative2D.SHADER_MACRO_GLOW_FILTER=0;
	LayaNative2D.GLOBALVALUE_GLOWFILTER_COLOR=0;
	LayaNative2D.GLOBALVALUE_GLOWFILTER_BLURINFO1=0;
	LayaNative2D.GLOBALVALUE_GLOWFILTER_BLURINFO2=0;
	return LayaNative2D;
})()


/**
*@private
*命令模板，用来优化合并命令执行
*/
//class laya.layagl.LayaGLTemplate
var LayaGLTemplate=(function(){
	function LayaGLTemplate(){
		this._commStr="";
		this._commandEncoder=null;
		this._id=0;
		this._commandEncoder=LayaGL.instance.createCommandEncoder(64,16,false);
	}

	__class(LayaGLTemplate,'laya.layagl.LayaGLTemplate');
	var __proto=LayaGLTemplate.prototype;
	//TODO:coverage
	__proto.addComd=function(funcName,argsArray){
		this._commStr+=funcName+"("+argsArray+");";
		this._commandEncoder[funcName].apply(this._commandEncoder,argsArray);
	}

	LayaGLTemplate.createByRenderType=function(renderType){
		var template=LayaGLTemplate.GLS[renderType]=new LayaGLTemplate();
		if (Render.isConchApp){
			LayaGL.instance.setGLTemplate(renderType,template._commandEncoder.getPtrID());
		};
		var n=/*laya.display.SpriteConst.ALPHA*/0x01;
		while (n <=/*laya.display.SpriteConst.CHILDS*/0x2000){
			var tempType=renderType & n;
			if (tempType && LayaGLTemplate.__FUN_PARAM__[n]){
				var objArr=LayaGLTemplate.__FUN_PARAM__[n];
				for (var i=0,sz=objArr.length;i < sz;i++){
					var obj=objArr[i];
					template.addComd(obj.func,obj.args);
				}
			}
			n <<=1;
		}
		template._id=renderType;
		console.log("template="+template._commStr);
		return template;
	}

	LayaGLTemplate.createByRenderTypeEnd=function(renderType){
		var template=LayaGLTemplate.GLSE[renderType]=new LayaGLTemplate();
		if (Render.isConchApp){
			LayaGL.instance.setEndGLTemplate(renderType,template._commandEncoder.getPtrID());
		};
		var n=/*laya.display.SpriteConst.CHILDS*/0x2000;
		while (n > /*laya.display.SpriteConst.ALPHA*/0x01){
			var tempType=renderType & n;
			if (tempType && LayaGLTemplate.__FUN_PARAM_END_[n]){
				var objArr=LayaGLTemplate.__FUN_PARAM_END_[n];
				for (var i=0,sz=objArr.length;i < sz;i++){
					var obj=objArr[i];
					template.addComd(obj.func,obj.args);
				}
			}
			n >>=1;
		}
		template._id=renderType;
		console.log("templateEnd="+template._commStr);
		return template;
	}

	LayaGLTemplate.__init__=function(){
		LayaGLTemplate.__FUN_PARAM__[ /*laya.display.SpriteConst.ALPHA*/0x01]=[{func:"setGlobalValueByParamData",args:[LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15,/*laya.display.SpriteConst.POSCOLOR*/22*4] }];
		LayaGLTemplate.__FUN_PARAM__[ /*laya.display.SpriteConst.TRANSFORM*/0x02]=[ {func:"calcLocalMatrix32",args:[ /*laya.display.SpriteConst.POSTRANSFORM_FLAG*/15*4,/*laya.display.SpriteConst.POSMATRIX*/16*4,/*laya.display.SpriteConst.POSX*/6*4,/*laya.display.SpriteConst.POSY*/7*4,/*laya.display.SpriteConst.POSPIVOTX*/8*4,/*laya.display.SpriteConst.POSPIVOTY*/9*4,/*laya.display.SpriteConst.POSSCALEX*/10*4,/*laya.display.SpriteConst.POSSCALEY*/11*4,/*laya.display.SpriteConst.POSSKEWX*/12*4,/*laya.display.SpriteConst.POSSKEWY*/13*4,/*laya.display.SpriteConst.POSROTATION*/14*4]},
		{func:"setGlobalValueByParamData",args:[LayaNative2D.GLOBALVALUE_MATRIX32,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7,/*laya.display.SpriteConst.POSMATRIX*/16 *4] }];
		LayaGLTemplate.__FUN_PARAM__[ /*laya.display.SpriteConst.BLEND*/0x04]=[ {func:"setGlobalValueByParamData",args:[LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,/*laya.display.SpriteConst.POSBLEND_SRC*/71 *4] },
		{func:"setGlobalValueByParamData",args:[LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,/*laya.display.SpriteConst.POSBLEND_DEST*/72 *4] }];
		LayaGLTemplate.__FUN_PARAM__[ /*laya.display.SpriteConst.TEXTURE*/0x100]=[{func:"useCommandEncoderByParamData",args:[ /*laya.display.SpriteConst.POSSIM_TEXTURE_ID*/24*4,/*laya.display.SpriteConst.POSSIM_TEXTURE_DATA*/25 *4,/*laya.layagl.LayaGL.EXECUTE_RENDER_THREAD_BUFFER*/1] }];
		LayaGLTemplate.__FUN_PARAM__[ /*laya.display.SpriteConst.GRAPHICS*/0x200]=[ {func:"callbackJSByParamData",args:[ /*laya.display.SpriteConst.POSCALLBACK_OBJ_ID*/54*4,/*laya.display.SpriteConst.POSGRAPHICS_CALLBACK_FUN_ID*/68 *4] },
		{func:"useCommandEncoderByParamData",args:[ /*laya.display.SpriteConst.POSGRAPICS*/23 *4,-1,/*laya.layagl.LayaGL.EXECUTE_RENDER_THREAD_BUFFER*/1] }];
		LayaGLTemplate.__FUN_PARAM__[ /*laya.display.SpriteConst.LAYAGL3D*/0x400]=[{func:"callbackJSByParamData",args:[ /*laya.display.SpriteConst.POSCALLBACK_OBJ_ID*/54*4,/*laya.display.SpriteConst.POSLAYA3D_FUN_ID*/62 *4] },
		{func:"useCommandEncoderByParamData",args:[ /*laya.display.SpriteConst.POSLAYAGL3D*/26 *4,-1,/*laya.layagl.LayaGL.EXECUTE_COPY_TO_RENDER3D*/3] }];
		LayaGLTemplate.__FUN_PARAM__[ /*laya.display.SpriteConst.CUSTOM*/0x800]=[{func:"callbackJSByParamData",args:[ /*laya.display.SpriteConst.POSCALLBACK_OBJ_ID*/54*4,/*laya.display.SpriteConst.POSCUSTOM_CALLBACK_FUN_ID*/55 *4] },
		{func:"useCommandEncoderByParamData",args:[ /*laya.display.SpriteConst.POSCUSTOM*/27 *4,-1,/*laya.layagl.LayaGL.EXECUTE_RENDER_THREAD_BUFFER*/1] }];
		LayaGLTemplate.__FUN_PARAM__[ /*laya.display.SpriteConst.CLIP*/0x40]=[ {func:"setClipByParamData",args:[LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,LayaNative2D.GLOBALVALUE_MATRIX32,/*laya.display.SpriteConst.POSCLIP*/28 *4] },
		{func:"setGlobalValueByParamData",args:[LayaNative2D.GLOBALVALUE_MATRIX32,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_TRANSLATE*/9,/*laya.display.SpriteConst.POSCLIP_NEG_POS*/32 *4] }];
		LayaGLTemplate.__FUN_PARAM__[ /*laya.display.SpriteConst.FILTERS*/0x10]=[ {func:"callbackJSByParamData",args:[ /*laya.display.SpriteConst.POSCALLBACK_OBJ_ID*/54 *4,/*laya.display.SpriteConst.POSFILTER_CALLBACK_FUN_ID*/65 *4] },
		{func:"useCommandEncoderByParamData",args:[ /*laya.display.SpriteConst.POSFILTER_BEGIN_CMD_ID*/64 *4,-1,/*laya.layagl.LayaGL.EXECUTE_JS_THREAD_BUFFER*/0] }];
		LayaGLTemplate.__FUN_PARAM__[ /*laya.display.SpriteConst.MASK*/0x20]=[ {func:"callbackJSByParamData",args:[ /*laya.display.SpriteConst.POSCALLBACK_OBJ_ID*/54 *4,/*laya.display.SpriteConst.POSMASK_CALLBACK_FUN_ID*/69 *4] },
		{func:"useCommandEncoderByParamData",args:[ /*laya.display.SpriteConst.POSMASK_CMD_ID*/70 *4,-1,/*laya.layagl.LayaGL.EXECUTE_JS_THREAD_BUFFER*/0] }];
		LayaGLTemplate.__FUN_PARAM__[ /*laya.display.SpriteConst.CANVAS*/0x08]=[ {func:"callbackJSByParamData",args:[ /*laya.display.SpriteConst.POSCALLBACK_OBJ_ID*/54 *4,/*laya.display.SpriteConst.POSCANVAS_CALLBACK_FUN_ID*/56 *4] },
		{func:"loadDataToRegByParamData",args:[0,/*laya.display.SpriteConst.POSCACHE_CANVAS_SKIP_PAINT_FLAG*/63 *4,4] },
		{func:"ifGreater0",args:[0,2147483647] },
		{func:"useCommandEncoderByParamData",args:[ /*laya.display.SpriteConst.POSCANVAS_BEGIN_CMD_ID*/58 *4,-1,/*laya.layagl.LayaGL.EXECUTE_JS_THREAD_BUFFER*/0] }];
		LayaGLTemplate.__FUN_PARAM__[ /*laya.display.SpriteConst.STYLE*/0x80]=[{func:"useCommandEncoderByParamData",args:[ /*laya.display.SpriteConst.POSSIM_RECT_FILL_CMD*/73 *4,/*laya.display.SpriteConst.POSSIM_RECT_FILL_DATA*/74 *4,/*laya.layagl.LayaGL.EXECUTE_RENDER_THREAD_BUFFER*/1] },
		{func:"useCommandEncoderByParamData",args:[ /*laya.display.SpriteConst.POSSIM_RECT_STROKE_CMD*/75 *4,/*laya.display.SpriteConst.POSSIM_RECT_STROKE_DATA*/76 *4,/*laya.layagl.LayaGL.EXECUTE_RENDER_THREAD_BUFFER*/1] }];
	}

	LayaGLTemplate.__init_END_=function(){
		LayaGLTemplate.__FUN_PARAM_END_[ /*laya.display.SpriteConst.FILTERS*/0x10]=[ {func:"loadDataToRegByParamData",args:[0,/*laya.display.SpriteConst.POSCACHE_CANVAS_SKIP_PAINT_FLAG*/63 *4,4] },
		{func:"ifGreater0",args:[0,2] },
		{func:"callbackJSByParamData",args:[ /*laya.display.SpriteConst.POSCALLBACK_OBJ_ID*/54 *4,/*laya.display.SpriteConst.POSFILTER_END_CALLBACK_FUN_ID*/67 *4] },
		{func:"useCommandEncoderByParamData",args:[ /*laya.display.SpriteConst.POSFILTER_END_CMD_ID*/66 *4,-1,/*laya.layagl.LayaGL.EXECUTE_RENDER_THREAD_BUFFER*/1] }];
		LayaGLTemplate.__FUN_PARAM_END_[ /*laya.display.SpriteConst.CANVAS*/0x08]=[ {func:"callbackJSByParamData",args:[ /*laya.display.SpriteConst.POSCALLBACK_OBJ_ID*/54 *4,/*laya.display.SpriteConst.POSCANVAS_CALLBACK_END_FUN_ID*/57 *4] },
		{func:"useCommandEncoderByParamData",args:[ /*laya.display.SpriteConst.POSCANVAS_END_CMD_ID*/59 *4,-1,/*laya.layagl.LayaGL.EXECUTE_JS_THREAD_BUFFER*/0] },
		{func:"useCommandEncoderByParamData",args:[ /*laya.display.SpriteConst.POSCANVAS_DRAW_TARGET_CMD_ID*/60*4,/*laya.display.SpriteConst.POSCANVAS_DRAW_TARGET_PARAM_ID*/61*4,/*laya.layagl.LayaGL.EXECUTE_RENDER_THREAD_BUFFER*/1] }];
	}

	LayaGLTemplate.GLS=[];
	LayaGLTemplate.GLSE=[];
	LayaGLTemplate.__FUN_PARAM__=[];
	LayaGLTemplate.__FUN_PARAM_END_=[];
	return LayaGLTemplate;
})()


/**
*key:font
*下面是各种大小的page
*每个大小的page可以有多个
*/
//class laya.webgl.resource.CharBook
var CharBook=(function(){
	var charPageTrash;
	function CharBook(){
		//private var fontPages:*={};//以font family为key。里面是一个以height为key的page列表
		this.fontPages=[];
		//用数组方式保存 CharPages,原来用Object不利于遍历
		this.fontPagesName=[];
		//当前选中的font
		this._curPage=null;
		//当前选中的page
		this.tempUV=[0,0,1,0,1,1,0,1];
		//用来去掉context的缩放的矩阵
		this.fontScaleX=1.0;
		//临时缩放。
		this.fontScaleY=1.0;
		this._curStrPos=0;
		this.tempMat=new Matrix();
		var bugIOS=false;
		var miniadp=Laya['MiniAdpter'];
		if (miniadp && miniadp.systemInfo && miniadp.systemInfo.system){
			bugIOS=miniadp.systemInfo.system.toLowerCase()==='ios 10.1.1';
		}
		if (Browser.onMiniGame && !bugIOS)CharBook.isWan1Wan=true;
		CharBook.charbookInst=this;
		Laya['textRender']=this;
		CharPages.charRender=Render.isConchApp ? (new CharRender_Native()):(new CharRender_Canvas(CharBook.textureWidth,CharBook.textureWidth,CharBook.scaleFontWithCtx,!CharBook.isWan1Wan,CharBook.debug));
	}

	__class(CharBook,'laya.webgl.resource.CharBook');
	var __proto=CharBook.prototype;
	/**
	*选择一个合适大小的page。 这里会考虑整体缩放。
	*@param fontFamily
	*@param fontsize 这个是原始大小，没有缩放的
	*@return
	*/
	__proto.selectFont=function(fontFamily,fontsize){
		var scale=Math.max(this.fontScaleX,this.fontScaleY);
		var scaledFontSz=fontsize *scale;
		var ret;
		if (fontFamily===CharBook._lastFont && scaledFontSz===CharBook._lastFontSz){
			ret=CharBook._lastCharPage;
			}else {
			var sz=CharPages.getBmpSize(fontsize)*scale;
			var szid=Math.floor(sz / CharBook.gridSize);
			var key=fontFamily+szid;
			var fid=this.fontPagesName.indexOf(key);
			if (fid < 0){
				var selFontPages=new CharPages(fontFamily,sz,Render.isConchApp ? 0 :Math.ceil((fontsize / 4.0)));
				this.fontPages.push(selFontPages);
				this.fontPagesName.push(key);
				ret=selFontPages;
				}else {
				ret=this.fontPages[fid];
			}
			ret.selectSize(fontsize,sz);
			CharBook._lastFont=fontFamily;
			CharBook._lastFontSz=scaledFontSz;
			CharBook._lastCharPage=ret;
		}
		return ret;
	}

	/**
	*从string中取出一个完整的char，例如emoji的话要多个
	*会修改 _curStrPos
	*TODO 由于各种文字中的组合写法，这个需要能扩展，以便支持泰文等
	*@param str
	*@param start 开始位置
	*/
	__proto.getNextChar=function(str){
		var len=str.length;
		var start=this._curStrPos;
		if (start >=len)
			return null;
		var link=false;
		var i=start;
		var state=0;
		for (;i < len;i++){
			var c=str.charCodeAt(i);
			if ((c >>> 11)==0x1b){
				if (state==1)break ;
				state=1;
				i++;
			}
			else if (c===0xfe0e || c===0xfe0f){}
			else if (c==0x200d){
				state=2;
				}else {
				if (state==0)state=1;
				else if (state==1)break ;
				else if (state==2){}
			}
		}
		this._curStrPos=i;
		return str.substring(start,i);
	}

	//TODO:coverage
	__proto.hasFreedText=function(txts,startid){
		if (txts && txts.length > 0){
			for (var i=startid,sz=txts.length;i < sz;i++){
				var pri=txts[i];
				if (!pri)continue ;
				for (var j=0,pisz=pri.length;j < pisz;j++){
					var riSaved=(pri [j]).ri;
					if (riSaved.deleted || riSaved.tex.__destroyed){
						return true;
					}
				}
			}
		}
		return false;
	}

	/**
	*参数都是直接的，不需要自己再从字符串解析
	*@param ctx
	*@param data
	*@param x
	*@param y
	*@param fontObj
	*@param color
	*@param strokeColor
	*@param lineWidth
	*@param textAlign
	*@param underLine
	*/
	__proto._fast_filltext=function(ctx,data,htmlchars,x,y,font,color,strokeColor,lineWidth,textAlign,underLine){
		(underLine===void 0)&& (underLine=0);
		if (data && data.length < 1)return;
		if (htmlchars && htmlchars.length < 1)return;
		CharBook._curFont=font._font;
		this.fontScaleX=this.fontScaleY=1.0;
		if (CharBook.scaleFontWithCtx){
			var sx=ctx.getMatScaleX();
			var sy=ctx.getMatScaleY();
			if (sx < 1e-4 || sy < 1e-1)
				return;
			if (sx > 1)this.fontScaleX=sx;
			if (sy > 1)this.fontScaleY=sy;
		}
		font._italic && (ctx._italicDeg=12);
		this._curPage=this.selectFont(font._family,font._size);
		var curx=x;
		var wt=data;
		var str=data;
		var strWidth=0;
		var isWT=!htmlchars && ((data instanceof laya.utils.WordText ));
		var isHtmlChar=!!htmlchars;
		var sameTexData=(CharBook.cacheRenderInfoInWordText && isWT)? wt.pageChars :[];
		if (isWT){
			str=wt._text;
			strWidth=wt.width;
			if (strWidth < 0){
				strWidth=wt.width=this._curPage.getWidth(str);
			}
			}else {
			strWidth=str?this._curPage.getWidth(str):0;
		}
		switch (textAlign){
			case Context.ENUM_TEXTALIGN_CENTER:
				curx=x-strWidth / 2;
				break ;
			case Context.ENUM_TEXTALIGN_RIGHT:
				curx=x-strWidth;
				break ;
			default :
				curx=x;
			}
		if (wt && wt.lastGCCnt !=this._curPage.gcCnt){
			wt.lastGCCnt=this._curPage.gcCnt;
			if (this.hasFreedText(sameTexData,wt.startID)){
				sameTexData=wt.pageChars=[];
			}
		};
		var startTexID=isWT ? wt.startID :0;
		var startTexIDStroke=isWT ? wt.startIDStroke :0;
		if (!sameTexData || sameTexData.length < 1){
			var scaleky=null;
			if (CharBook.scaleFontWithCtx){
				CharPages.charRender.scale(Math.max(this.fontScaleX,1.0),Math.max(this.fontScaleY,1.0));
				if (this.fontScaleX > 1.0 || this.fontScaleY > 1.0)
					scaleky=""+((this.fontScaleX *10)| 0)+((this.fontScaleY *10)| 0);
			}
			startTexID=-1;
			startTexIDStroke=-1;
			var stx=0;
			var sty=0;
			this._curStrPos=0;
			var curstr;
			if (isHtmlChar){
				var chc=htmlchars[this._curStrPos++];
				curstr=chc.char;
				stx=chc.x;
				sty=chc.y;
				}else {
				curstr=this.getNextChar(str);
			};
			var bold=font._bold;
			while (curstr){
				var ri;
				ri=this._curPage.getChar(curstr,lineWidth,font._size,color,strokeColor,bold,false,scaleky);
				if (!ri){
					break ;
				}
				ri.char=curstr;
				if (ri.isSpace){
					}else {
					var add=sameTexData[ri.tex.id];
					if (!add){
						sameTexData[ri.tex.id]=add=[];
						if (startTexID < 0 || startTexID > ri.tex.id)
							startTexID=ri.tex.id;
					}
					add.push({ri:ri,x:stx,y:sty,w:ri.bmpWidth / this.fontScaleX,h:ri.bmpHeight / this.fontScaleY});
				}
				if (isHtmlChar){
					chc=htmlchars[this._curStrPos++];
					if (chc){
						curstr=chc.char;
						stx=chc.x;
						sty=chc.y;
						}else {
						curstr=null;
					}
					}else {
					curstr=this.getNextChar(str);
					stx+=ri.width;
				}
			}
			if (isWT){
				wt.startID=startTexID;
				wt.startIDStroke=startTexIDStroke;
			}
		}
		this._drawResortedWords(ctx,curx,sameTexData,startTexID,y);
		ctx._italicDeg=0;
	}

	__proto.fillWords=function(ctx,data,x,y,fontStr,color,strokeColor,lineWidth){
		if (!data)return;
		if (data.length <=0)return;
		var nColor=ColorUtils.create(color).numColor;
		var nStrokeColor=strokeColor ? ColorUtils.create(strokeColor).numColor :0;
		CharBook._curFont=fontStr;
		var font=FontInfo.Parse(fontStr);
		this._fast_filltext(ctx,null,data,x,y,font,color,strokeColor,lineWidth,0,0);
	}

	/**
	*
	*TEST
	*emoji:'💗'
	*arabic:'سلام'
	*组合:'ă'
	*泰语:'ฏ๎๎๎๎๎๎๎๎๎๎๎๎๎๎๎'
	*天城文:'कि' *
	*/
	__proto.filltext=function(ctx,data,x,y,fontStr,color,strokeColor,lineWidth,textAlign,underLine){
		(underLine===void 0)&& (underLine=0);
		if (data.length <=0)
			return;
		var nColor=ColorUtils.create(color).numColor;
		var nStrokeColor=strokeColor ? ColorUtils.create(strokeColor).numColor :0;
		CharBook._curFont=fontStr;
		var font=FontInfo.Parse(fontStr);
		var nTextAlign=0;
		switch (textAlign){
			case 'center':
				nTextAlign=Context.ENUM_TEXTALIGN_CENTER;
				break ;
			case 'right':
				nTextAlign=Context.ENUM_TEXTALIGN_RIGHT;
				break ;
			}
		this._fast_filltext(ctx,data,null,x,y,font,color,strokeColor,lineWidth,nTextAlign,underLine);
	}

	//TODO:coverage
	__proto.filltext_native=function(ctx,data,htmlchars,x,y,fontStr,color,strokeColor,lineWidth,textAlign,underLine){
		(underLine===void 0)&& (underLine=0);
		if (data && data.length <=0)
			return;
		var nColor=ColorUtils.create(color).numColor;
		var nStrokeColor=strokeColor ? ColorUtils.create(strokeColor).numColor :0;
		CharBook._curFont=fontStr;
		this.fontScaleX=this.fontScaleY=1.0;
		if (CharBook.scaleFontWithCtx){
			var sx=ctx._curMat.getScaleX();
			var sy=ctx._curMat.getScaleY();
			if (sx < 1e-4 || sy < 1e-1)
				return;
			this.fontScaleX=sx;
			this.fontScaleY=sy;
			CharPages.charRender.scale(this.fontScaleX,this.fontScaleY);
		};
		var font=FontInfo.Parse(fontStr);
		var fontFamily=font._family;
		var bold=font._bold;
		if (font._italic){
			ctx._italicDeg=12;
		}
		this._curPage=this.selectFont(fontFamily,font._size *this.fontScaleX);
		var curx=x;
		var wt=data;
		var str=data;
		var strWidth=0;
		var isWT=!htmlchars && ((str instanceof laya.utils.WordText ));
		var isHtmlChar=!!htmlchars;
		var sameTexData=(CharBook.cacheRenderInfoInWordText && isWT)? wt.pageChars :[];
		if (isWT){
			str=wt.toString();
			strWidth=wt.width;
			if (strWidth < 0){
				strWidth=wt.width=this._curPage.getWidth(str);
			}
			}else {
			strWidth=this._curPage.getWidth(str);
		}
		switch (textAlign){
			case 'center':
				curx=x-strWidth / 2;
				break ;
			case 'right':
				curx=x-strWidth;
				break ;
			default :
				curx=x;
			}
		if (sameTexData){
			var needRebuild=false;
			for (var i=0,sz=sameTexData.length;i < sz;i++){
				var pri=sameTexData[i];
				if (!pri)continue ;
				for (var j=0,pisz=pri.length;j < pisz;j++){
					var riSaved=pri[j];
					if (riSaved.ri.tex.__destroyed){
						needRebuild=true;
						break ;
					}
				}
				if (needRebuild)break ;
			}
			if (needRebuild)
				sameTexData=wt.pageChars=[];
		}
		if (!sameTexData || sameTexData.length <=0){
			var scaleky=null;
			if (CharBook.scaleFontWithCtx){
				CharPages.charRender.scale(Math.max(this.fontScaleX,1.0),Math.max(this.fontScaleY,1.0));
				if (this.fontScaleX > 1.0 || this.fontScaleY > 1.0)
					scaleky=""+((this.fontScaleX *10)| 0)+((this.fontScaleY *10)| 0);
			};
			var stx=0;
			var sty=0;
			this._curStrPos=0;
			var curstr;
			if (isHtmlChar){
				var chc=htmlchars[this._curStrPos++];
				curstr=chc.char;
				stx=chc.x;
				sty=chc.y;
				}else {
				curstr=this.getNextChar(str);
			}
			bold=font._bold;
			while (curstr){
				var ri;
				ri=this._curPage.getChar(curstr,lineWidth,font._size,color,strokeColor,bold,false,scaleky);
				if (ri.isSpace){
					}else {
					var add=sameTexData[ri.tex.id];
					if (!add){
						sameTexData[ri.tex.id]=add=[];
					}
					add.push({ri:ri,x:stx,y:sty,color:color,nColor:nColor});
				}
				if (isHtmlChar){
					chc=htmlchars[this._curStrPos++];
					if (chc){
						curstr=chc.char;
						stx=chc.x;
						sty=chc.y;
						}else {
						curstr=null;
					}
					}else {
					stx+=ri.width;
					curstr=this.getNextChar(str);
				}
			}
		};
		var lastUseColor=ctx._drawTextureUseColor;
		this._drawResortedWords_native(ctx,curx,sameTexData,y);
		ctx._drawTextureUseColor=lastUseColor;
		ctx._italicDeg=0;
	}

	/**
	*画出重新按照贴图顺序分组的文字。
	*@param samePagesData
	*@param startx 保存的数据是相对位置，所以需要加上这个便宜，相对位置更灵活一些。
	*@param y {int}因为这个只能画在一行上所以没有必要保存y。所以这里再把y传进来
	*/
	__proto._drawResortedWords=function(ctx,startx,samePagesData,startID,y){
		var lastColor=ctx.getFillColor();
		ctx.setFillColor(ctx.mixRGBandAlpha(0xffffff));
		startx-=this._curPage.margin_left;
		y-=this._curPage.margin_top;
		var isLastRender=ctx._charSubmitCache._enbale;
		for (var i=startID,sz=samePagesData.length;i < sz;i++){
			var pri=samePagesData[i];
			if (!pri)continue ;
			var pisz=pri.length;
			if (pisz <=0)continue ;
			for (var j=0;j < pisz;j++){
				var riSaved=pri[j];
				var ri=riSaved.ri;
				if (ri.isSpace)continue ;
				ri.touch();
				ctx.drawTexAlign=true;
				ctx._inner_drawTexture(ri.tex.texture,(ri.tex.texture).bitmap.id,startx+riSaved.x ,y+riSaved.y ,riSaved.w,riSaved.h,null,ri.uv,1.0,isLastRender);
				if ((ctx).touches){
					(ctx).touches.push(ri);
				}
			}
		}
		ctx.setFillColor(lastColor);
	}

	//TODO:coverage
	__proto._drawResortedWords_native=function(ctx,startx,samePagesData,y){
		var lastcolor=0;
		for (var i=0,sz=samePagesData.length;i < sz;i++){
			var pri=samePagesData[i];
			if (!pri)continue ;
			for (var j=0,pisz=pri.length;j < pisz;j++){
				var riSaved=pri[j];
				var ri=riSaved.ri;
				if (ri.isSpace)continue ;
				ctx._drawTextureUseColor=false;
				if (lastcolor !=riSaved.nColor){
					ctx.fillStyle=riSaved.color;
					lastcolor=riSaved.nColor;
				}
				ri.touch();
				this._drawCharRenderInfo(ctx,riSaved.ri,startx+riSaved.x,riSaved.y+y);
			}
		}
	}

	//TODO:coverage
	__proto._drawCharRenderInfo=function(ctx,ri,x,y){
		ctx._drawTextureM(ri.tex.texture,x-this._curPage.margin_left,y-this._curPage.margin_top,ri.bmpWidth,ri.bmpHeight,null,1.0,ri.uv);
		if ((ctx).touches){
			(ctx).touches.push(ri);
		}
	}

	// for debug
	__proto.listPages=function(){
		var _$this=this;
		console.log('打印所有页的信息:');
		this.fontPages.forEach(function(cp,i){
			var name=_$this.fontPagesName[i];
			var minsz=parseInt(name.substr(cp.fontFamily.length))*CharBook.gridSize;
			console.log('===================================');
			console.log('名字:',_$this.fontPagesName[i],'大小范围:',minsz,minsz+CharBook.gridSize);
			cp.printPagesInfo();
		});
	}

	/**
	*垃圾回收
	*/
	__proto.GC=function(force){
		var i=0,sz=this.fontPages.length;
		this.fontPages.forEach(function(p){p.removeLRU();});
	}

	CharBook.textureWidth=512;
	CharBook.cacheRenderInfoInWordText=true;
	CharBook.scaleFontWithCtx=true;
	CharBook.gridSize=16;
	CharBook.debug=false;
	CharBook._curFont=null;
	CharBook.charbookInst=null;
	CharBook._fontMem=0;
	CharBook._lastFont=null;
	CharBook._lastFontSz=0;
	CharBook._lastCharPage=null;
	CharBook.isWan1Wan=false;
	__static(CharBook,
	['_uint32',function(){return this._uint32=new Uint32Array(1);},'trash',function(){return this.trash=new charPageTrash(CharBook.textureWidth);}
	]);
	CharBook.__init$=function(){
		/**
		*charPageTexture的缓存管理，反正所有的贴图大小都是一致的，完全可以重复利用。
		*/
		//class charPageTrash
		charPageTrash=(function(){
			function charPageTrash(w){
				this.poolLen=0;
				this.cleanTm=0;
				this.texW=0;
				this.pool=new Array(10);
				this.texW=w;
			}
			__class(charPageTrash,'');
			var __proto=charPageTrash.prototype;
			__proto.getAPage=function(gridnum){
				if (this.poolLen > 0){
					var ret=this.pool[--this.poolLen];
					ret.setGridNum(gridnum);
					if (this.poolLen > 0)
						this.clean();
					return ret;
				}
				return new CharPageTexture(this.texW,this.texW,gridnum);
			}
			__proto.discardPage=function(p){
				this.clean();
				if (!p)return;
				p.genID++;
				if (this.poolLen >=this.pool.length){
					this.pool=this.pool.concat(new Array(10));
				}
				p.reset();
				this.pool[this.poolLen++]=p;
			}
			/**
			*定期清理
			*为了简单，只有发生 getAPage 或者 discardPage的时候才检测是否需要清理
			*/
			__proto.clean=function(){
				var curtm=Laya.stage.getFrameTm();
				if (this.cleanTm===0)this.cleanTm=curtm;
				if (curtm-this.cleanTm > 30000){
					for (var i=0;i < this.poolLen;i++){
						var p=this.pool[i];
						if (curtm-p._discardTm > 20000){
							p.destroy();
							this.pool[i]=this.pool[this.poolLen-1];
							this.poolLen--;
							i--;
						}
					}
					this.cleanTm=curtm;
				}
			}
			return charPageTrash;
		})()
	}

	return CharBook;
})()


//class laya.webgl.submit.SubmitCMD
var SubmitCMD=(function(){
	function SubmitCMD(){
		this.fun=null;
		this._this=null;
		this.args=null;
		this._ref=1;
		this._key=new SubmitKey();
	}

	__class(SubmitCMD,'laya.webgl.submit.SubmitCMD');
	var __proto=SubmitCMD.prototype;
	Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
	__proto.renderSubmit=function(){
		this.fun.apply(this._this,this.args);
		return 1;
	}

	//TODO:coverage
	__proto.getRenderType=function(){
		return 0;
	}

	//TODO:coverage
	__proto.reUse=function(context,pos){
		this._ref++;
		return pos;
	}

	__proto.releaseRender=function(){
		if((--this._ref)<1){
			var pool=SubmitCMD.POOL;
			pool[pool._length++]=this;
		}
	}

	//TODO:coverage
	__proto.clone=function(context,mesh,pos){
		return null;
	}

	SubmitCMD.create=function(args,fun,thisobj){
		var o=SubmitCMD.POOL._length?SubmitCMD.POOL[--SubmitCMD.POOL._length]:new SubmitCMD();
		o.fun=fun;
		o.args=args;
		o._this=thisobj;
		o._ref=1;
		o._key.clear();
		return o;
	}

	SubmitCMD.POOL=(SubmitCMD.POOL=[],SubmitCMD.POOL._length=0,SubmitCMD.POOL);
	return SubmitCMD;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.DrawLinesCmdNative
var DrawLinesCmdNative=(function(){
	function DrawLinesCmdNative(){
		this._graphicsCmdEncoder=null;
		this._paramData=null;
		this._x=NaN;
		this._y=NaN;
		this._points=null;
		this._lineColor=null;
		this._lineWidth=NaN;
		this._vid=0;
		this._vertNum=0;
		this.ibBuffer=null;
		this.vbBuffer=null;
		this._ibSize=0;
		this._vbSize=0;
		this._ibArray=[];
		this._vbArray=[];
	}

	__class(DrawLinesCmdNative,'laya.layagl.cmdNative.DrawLinesCmdNative');
	var __proto=DrawLinesCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._points=null;
		this._lineColor=null;
		this._ibArray.length=0;
		this._vbArray.length=0;
		Pool.recover("DrawLinesCmd",this);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._lineColor;
		},function(value){
		this._lineColor=value;
		var c1=ColorUtils.create(this._lineColor);
		var nColor=c1.numColor;
		var _i32b=this.vbBuffer._int32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			ix++;ix++;_i32b[ix++]=nColor;
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'points',function(){
		return this._points;
		},function(value){
		this._points=value;
		this._ibArray.length=0;
		this._vbArray.length=0;
		BasePoly.createLine2(this._points,this._ibArray,this._lineWidth,0,this._vbArray,false);
		var c1=ColorUtils.create(this._lineColor);
		var nColor=c1.numColor;
		this._vertNum=this._points.length;
		var vertNumCopy=this._vertNum;
		if (!this.vbBuffer || this.vbBuffer.getByteLength()< this._vertNum*3*4){
			this.vbBuffer=/*__JS__ */new ParamData(vertNumCopy*3*4,true);
		}
		this._vbSize=this._vertNum *3 *4;
		var _vb=this.vbBuffer._float32Data;
		var _i32b=this.vbBuffer._int32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			_vb[ix++]=this._vbArray[i *2]+this.x;_vb[ix++]=this._vbArray[i *2+1]+this.y;_i32b[ix++]=nColor;
		}
		if (!this.ibBuffer || this.ibBuffer.getByteLength()< (this._vertNum-2)*3 *2){
			this.ibBuffer=/*__JS__ */new ParamData((vertNumCopy-2)*3 *2,true,true);
		}
		this._ibSize=(this._vertNum-2)*3 *2;
		var _ib=this.ibBuffer._int16Data;
		for (var ii=0;ii < (this._vertNum-2)*3;ii++){
			_ib[ii]=this._ibArray[ii];
		}
		_i32b=this._paramData._int32Data;
		_i32b[DrawLinesCmdNative._PARAM_VB_SIZE_POS_]=this._vbSize;
		_i32b[DrawLinesCmdNative._PARAM_IB_SIZE_POS_]=this._ibSize;
		LayaGL.syncBufferToRenderThread(this.ibBuffer);
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawLines";
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
		var _vb=this.vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			_vb[ix++]=this._vbArray[i *2]+this._x;ix++;ix++;
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'vid',function(){
		return this._vid;
		},function(value){
		this._vid=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
		var _vb=this.vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			ix++;_vb[ix++]=this._vbArray[i *2+1]+this._y;ix++;
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		this._lineWidth=value;
		this._ibArray.length=0;
		this._vbArray.length=0;
		BasePoly.createLine2(this._points,this._ibArray,this._lineWidth,0,this._vbArray,false);
		var _vb=this.vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			_vb[ix++]=this._vbArray[i *2]+this.x;_vb[ix++]=this._vbArray[i *2+1]+this.y;ix++;
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	DrawLinesCmdNative.create=function(x,y,points,lineColor,lineWidth,vid){
		var cmd=Pool.getItemByClass("DrawLinesCmd",DrawLinesCmdNative);
		cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		if (!DrawLinesCmdNative._DRAW_LINES_CMD_ENCODER_){
			DrawLinesCmdNative._DRAW_LINES_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(152,32,true);
			DrawLinesCmdNative._DRAW_LINES_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);
			DrawLinesCmdNative._DRAW_LINES_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);
			DrawLinesCmdNative._DRAW_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawLinesCmdNative._DRAW_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawLinesCmdNative._DRAW_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawLinesCmdNative._DRAW_LINES_CMD_ENCODER_.setMeshExByParamData(DrawLinesCmdNative._PARAM_VB_POS_ *4,DrawLinesCmdNative._PARAM_VB_OFFSET_POS_ *4,DrawLinesCmdNative._PARAM_VB_SIZE_POS_ *4,DrawLinesCmdNative._PARAM_IB_POS_ *4,DrawLinesCmdNative._PARAM_IB_OFFSET_POS_ *4,DrawLinesCmdNative._PARAM_IB_SIZE_POS_ *4,DrawLinesCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawLinesCmdNative._DRAW_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawLinesCmdNative._DRAW_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawLinesCmdNative._DRAW_LINES_CMD_ENCODER_);
		}
		if (!cmd._paramData){
			cmd._paramData=/*__JS__ */new ParamData(11 *4,true);
			}{
			cmd._x=x;
			cmd._y=y;
			cmd._points=points;
			cmd._lineColor=lineColor;
			cmd._lineWidth=lineWidth;
			cmd._vid=vid;
			BasePoly.createLine2(points,cmd._ibArray,lineWidth,0,cmd._vbArray,false);
			var c1=ColorUtils.create(lineColor);
			var nColor=c1.numColor;
			cmd._vertNum=points.length;
			var vertNumCopy=cmd._vertNum;
			if (!cmd.vbBuffer || cmd.vbBuffer.getByteLength()< cmd._vertNum*3*4){
				cmd.vbBuffer=/*__JS__ */new ParamData(vertNumCopy*3*4,true);
			}
			cmd._vbSize=cmd._vertNum *3 *4;
			var _vb=cmd.vbBuffer._float32Data;
			var _i32b=cmd.vbBuffer._int32Data;
			var ix=0;
			for (var i=0;i < cmd._vertNum;i++){
				_vb[ix++]=cmd._vbArray[i *2]+x;_vb[ix++]=cmd._vbArray[i *2+1]+y;_i32b[ix++]=nColor;
			}
			if (!cmd.ibBuffer || cmd.ibBuffer.getByteLength()< (cmd._vertNum-2)*3 *2){
				cmd.ibBuffer=/*__JS__ */new ParamData((vertNumCopy-2)*3 *2,true,true);
			}
			cmd._ibSize=(cmd._vertNum-2)*3 *2;
			var _ib=cmd.ibBuffer._int16Data;
			for (var ii=0;ii < (cmd._vertNum-2)*3;ii++){
				_ib[ii]=cmd._ibArray[ii];
			}
		};
		var _fb=cmd._paramData._float32Data;
		_i32b=cmd._paramData._int32Data;
		_i32b[0]=1;
		_i32b[DrawLinesCmdNative._PARAM_VB_POS_]=cmd.vbBuffer.getPtrID();
		_i32b[DrawLinesCmdNative._PARAM_IB_POS_]=cmd.ibBuffer.getPtrID();
		if (!lineColor){
			_fb[DrawLinesCmdNative._PARAM_LINECOLOR_POS_]=0xff0000ff;
		}
		else{
			_fb[DrawLinesCmdNative._PARAM_LINECOLOR_POS_]=lineColor;
		}
		_fb[DrawLinesCmdNative._PARAM_LINEWIDTH_POS_]=lineWidth;
		_fb[DrawLinesCmdNative._PARAM_VID_POS_]=vid;
		_i32b[DrawLinesCmdNative._PARAM_VB_SIZE_POS_]=cmd._vbSize;
		_i32b[DrawLinesCmdNative._PARAM_IB_SIZE_POS_]=cmd._ibSize;
		_i32b[DrawLinesCmdNative._PARAM_VB_OFFSET_POS_]=0;
		_i32b[DrawLinesCmdNative._PARAM_IB_OFFSET_POS_]=0;
		_i32b[DrawLinesCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_]=0;
		LayaGL.syncBufferToRenderThread(cmd.vbBuffer);
		LayaGL.syncBufferToRenderThread(cmd.ibBuffer);
		LayaGL.syncBufferToRenderThread(cmd._paramData);
		cmd._graphicsCmdEncoder.useCommandEncoder(DrawLinesCmdNative._DRAW_LINES_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		LayaGL.syncBufferToRenderThread(cmd._graphicsCmdEncoder);
		return cmd;
	}

	DrawLinesCmdNative.ID="DrawLines";
	DrawLinesCmdNative._DRAW_LINES_CMD_ENCODER_=null;
	DrawLinesCmdNative._PARAM_VB_POS_=1;
	DrawLinesCmdNative._PARAM_IB_POS_=2;
	DrawLinesCmdNative._PARAM_LINECOLOR_POS_=3;
	DrawLinesCmdNative._PARAM_LINEWIDTH_POS_=4;
	DrawLinesCmdNative._PARAM_VID_POS_=5;
	DrawLinesCmdNative._PARAM_VB_SIZE_POS_=6;
	DrawLinesCmdNative._PARAM_IB_SIZE_POS_=7;
	DrawLinesCmdNative._PARAM_VB_OFFSET_POS_=8;
	DrawLinesCmdNative._PARAM_IB_OFFSET_POS_=9;
	DrawLinesCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_=10;
	return DrawLinesCmdNative;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.DrawImageCmdNative
var DrawImageCmdNative=(function(){
	function DrawImageCmdNative(){
		this._graphicsCmdEncoder=null;
		this._index=0;
		this._paramData=null;
		this._texture=null;
		this._x=NaN;
		this._y=NaN;
		this._width=NaN;
		this._height=NaN;
	}

	__class(DrawImageCmdNative,'laya.layagl.cmdNative.DrawImageCmdNative');
	var __proto=DrawImageCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._texture._removeReference();
		this._texture=null;
		this._graphicsCmdEncoder=null;
		Pool.recover("DrawImageCmd",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "DrawImage";
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawImageCmdNative._PARAM_VB_POS_+1]=this._y;
		_fb[DrawImageCmdNative._PARAM_VB_POS_+7]=this._y;
		_fb[DrawImageCmdNative._PARAM_VB_POS_+13]=this._y+this._height;
		_fb[DrawImageCmdNative._PARAM_VB_POS_+19]=this._y+this._height;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'texture',function(){
		return this._texture;
		},function(value){
		this._texture=value;
		this._paramData._int32Data[DrawImageCmdNative._PARAM_TEXTURE_POS_]=this._texture.bitmap._glTexture.id;
		var _fb=this._paramData._float32Data;
		var uv=this._texture.uv;
		_fb[DrawImageCmdNative._PARAM_VB_POS_+2]=uv[0];_fb[DrawImageCmdNative._PARAM_VB_POS_+3]=uv[1];
		_fb[DrawImageCmdNative._PARAM_VB_POS_+8]=uv[2];_fb[DrawImageCmdNative._PARAM_VB_POS_+9]=uv[3];
		_fb[DrawImageCmdNative._PARAM_VB_POS_+14]=uv[4];_fb[DrawImageCmdNative._PARAM_VB_POS_+15]=uv[5];
		_fb[DrawImageCmdNative._PARAM_VB_POS_+20]=uv[6];_fb[DrawImageCmdNative._PARAM_VB_POS_+21]=uv[7];
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'width',function(){
		return this._width;
		},function(value){
		this._width=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawImageCmdNative._PARAM_VB_POS_]=this._x;
		_fb[DrawImageCmdNative._PARAM_VB_POS_+6]=this._x+this._width;
		_fb[DrawImageCmdNative._PARAM_VB_POS_+12]=this._x+this._width;
		_fb[DrawImageCmdNative._PARAM_VB_POS_+18]=this._x;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawImageCmdNative._PARAM_VB_POS_]=this._x;
		_fb[DrawImageCmdNative._PARAM_VB_POS_+6]=this._x+this._width;
		_fb[DrawImageCmdNative._PARAM_VB_POS_+12]=this._x+this._width;
		_fb[DrawImageCmdNative._PARAM_VB_POS_+18]=this._x;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'height',function(){
		return this._height;
		},function(value){
		this._height=value;
		var _fb=this._paramData._float32Data;
		_fb[DrawImageCmdNative._PARAM_VB_POS_+1]=this._y;
		_fb[DrawImageCmdNative._PARAM_VB_POS_+7]=this._y;
		_fb[DrawImageCmdNative._PARAM_VB_POS_+13]=this._y+this._height;
		_fb[DrawImageCmdNative._PARAM_VB_POS_+19]=this._y+this._height;
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	DrawImageCmdNative.create=function(texture,x,y,width,height){
		var cmd=Pool.getItemByClass("DrawImageCmd",DrawImageCmdNative);
		cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		if (!DrawImageCmdNative._DRAW_IMAGE_CMD_ENCODER_){
			DrawImageCmdNative._DRAW_IMAGE_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(172,32,true);
			DrawImageCmdNative._DRAW_IMAGE_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawImageCmdNative._DRAW_IMAGE_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);
			DrawImageCmdNative._DRAW_IMAGE_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);
			DrawImageCmdNative._DRAW_IMAGE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawImageCmdNative._DRAW_IMAGE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawImageCmdNative._DRAW_IMAGE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawImageCmdNative._DRAW_IMAGE_CMD_ENCODER_.uniformTextureByParamData(0,1 *4,DrawImageCmdNative._PARAM_TEXTURE_POS_ *4);
			DrawImageCmdNative._DRAW_IMAGE_CMD_ENCODER_.setRectMeshByParamData(3*4,DrawImageCmdNative._PARAM_VB_POS_*4,4*4);
			DrawImageCmdNative._DRAW_IMAGE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawImageCmdNative._DRAW_IMAGE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawImageCmdNative._DRAW_IMAGE_CMD_ENCODER_);
		}
		if (!cmd._paramData){
			cmd._paramData=/*__JS__ */new ParamData(29*4,true);
			}{
			cmd._texture=texture;
			texture._addReference();
			cmd._x=x;
			cmd._y=y;
			cmd._width=width;
			cmd._height=height;
			var _fb=cmd._paramData._float32Data;
			var _i32b=cmd._paramData._int32Data;
			_i32b[0]=3;
			_i32b[1]=/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0;
			_i32b[DrawImageCmdNative._PARAM_TEXTURE_POS_]=texture.getIsReady()? texture.bitmap._glTexture.id :0;
			_i32b[3]=1;
			_i32b[4]=24 *4;
			var w=width !=0 ? width :texture.bitmap.width;
			var h=height !=0 ? height :texture.bitmap.height;
			var uv=texture.uv;
			var ix=DrawImageCmdNative._PARAM_VB_POS_;
			_fb[ix++]=x;_fb[ix++]=y;_fb[ix++]=uv[0];_fb[ix++]=uv[1];_i32b[ix++]=0xffffffff;_i32b[ix++]=0xffffffff;
			_fb[ix++]=x+w;_fb[ix++]=y;_fb[ix++]=uv[2];_fb[ix++]=uv[3];_i32b[ix++]=0xffffffff;_i32b[ix++]=0xffffffff;
			_fb[ix++]=x+w;_fb[ix++]=y+h;_fb[ix++]=uv[4];_fb[ix++]=uv[5];_i32b[ix++]=0xffffffff;_i32b[ix++]=0xffffffff;
			_fb[ix++]=x;_fb[ix++]=y+h;_fb[ix++]=uv[6];_fb[ix++]=uv[7];_i32b[ix++]=0xffffffff;_i32b[ix++]=0xffffffff;
			LayaGL.syncBufferToRenderThread(cmd._paramData);
		}
		cmd._graphicsCmdEncoder.useCommandEncoder(DrawImageCmdNative._DRAW_IMAGE_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		LayaGL.syncBufferToRenderThread(cmd._graphicsCmdEncoder);
		return cmd;
	}

	DrawImageCmdNative.ID="DrawImage";
	DrawImageCmdNative._DRAW_IMAGE_CMD_ENCODER_=null;
	DrawImageCmdNative._PARAM_TEXTURE_POS_=2;
	DrawImageCmdNative._PARAM_VB_POS_=5;
	return DrawImageCmdNative;
})()


/**
*...
*@author ww
*/
//class laya.layagl.cmdNative.DrawCircleCmdNative
var DrawCircleCmdNative=(function(){
	function DrawCircleCmdNative(){
		this._graphicsCmdEncoder=null;
		this._paramData=null;
		this._paramID=null;
		this._x=NaN;
		this._y=NaN;
		this._radius=NaN;
		this._fillColor=null;
		this._lineColor=null;
		this._lineWidth=NaN;
		this._vertNum=0;
		this._line_vertNum=0;
		this.ibBuffer=null;
		this.vbBuffer=null;
		this.line_ibBuffer=null;
		this.line_vbBuffer=null;
		this._ibSize=0;
		this._vbSize=0;
		this._line_ibSize=0;
		this._line_vbSize=0;
		this._cmdCurrentPos=0;
		this._points=[];
		this._linePoints=[];
		this._line_vbArray=[];
		this._line_ibArray=[];
	}

	__class(DrawCircleCmdNative,'laya.layagl.cmdNative.DrawCircleCmdNative');
	var __proto=DrawCircleCmdNative.prototype;
	__proto._arc=function(cx,cy,r,counterclockwise,b){
		(counterclockwise===void 0)&& (counterclockwise=false);
		(b===void 0)&& (b=true);
		var newPoints=[];
		var startAngle=0;
		var endAngle=Math.PI *2;
		var a=0,da=0,hda=0,kappa=0;
		var dx=0,dy=0,x=0,y=0,tanx=0,tany=0;
		var px=0,py=0,ptanx=0,ptany=0;
		var i=0,ndivs=0,nvals=0;
		da=endAngle-startAngle;
		if (!counterclockwise){
			if (Math.abs(da)>=Math.PI *2){
				da=Math.PI *2;
			}
			else{
				while (da < 0.0){
					da+=Math.PI *2;
				}
			}
		}
		else{
			if (Math.abs(da)>=Math.PI *2){
				da=-Math.PI *2;
			}
			else{
				while (da > 0.0){
					da-=Math.PI *2;
				}
			}
		}
		if (r < 101){
			ndivs=Math.max(10,da *r / 5);
		}
		else if (r < 201){
			ndivs=Math.max(10,da *r / 20);
		}
		else{
			ndivs=Math.max(10,da *r / 40);
		}
		hda=(da / ndivs)/ 2.0;
		kappa=Math.abs(4 / 3 *(1-Math.cos(hda))/ Math.sin(hda));
		if (counterclockwise){
			kappa=-kappa;
		}
		nvals=0;
		var _x1=NaN,_y1=NaN;
		for (i=0;i <=ndivs;i++){
			a=startAngle+da *(i / ndivs);
			dx=Math.cos(a);
			dy=Math.sin(a);
			x=cx+dx *r;
			y=cy+dy *r;
			newPoints.push(x);
			newPoints.push(y);
		}
		return newPoints;
	}

	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._fillColor=null;
		this._lineColor=null;
		this._points.length=0;
		this._linePoints.length=0;
		this._line_vbArray.length=0;
		this._line_ibArray.length=0;
		Pool.recover("DrawCircleCmd",this);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._lineColor;
		},function(value){
		if (!this._lineColor&&this._lineWidth){
			this._graphicsCmdEncoder._idata[this._cmdCurrentPos+1]=DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_.getPtrID();
			LayaGL.syncBufferToRenderThread(this._graphicsCmdEncoder);
		}
		this._lineColor=value;
		this._linePoints.length=0;
		this._line_ibArray.length=0;
		this._line_vbArray.length=0;
		for (var i=0;i < this._points.length;i++){
			this._linePoints.push(this._points[i]);
		}
		this._linePoints.push(this._points[0]);
		this._linePoints.push(this._points[1]);
		BasePoly.createLine2(this._linePoints,this._line_ibArray,this._lineWidth,0,this._line_vbArray,false);
		this._line_vertNum=this._linePoints.length;
		var lineVertNumCopy=this._line_vertNum;
		if (!this.line_ibBuffer || this.line_ibBuffer.getByteLength()< (this._line_vertNum-2)*3*2){
			this.line_ibBuffer=/*__JS__ */new ParamData((lineVertNumCopy-2)*3*2,true,true);
		}
		this._line_ibSize=(this._line_vertNum-2)*3 *2;
		var _line_ib=this.line_ibBuffer._int16Data;
		var idxpos=0;
		for (var ii=0;ii < (this._line_vertNum-2)*3;ii++){
			_line_ib[idxpos++]=this._line_ibArray[ii];
		}
		if (!this.line_vbBuffer || this.line_vbBuffer.getByteLength()< this._line_vertNum*3 *4){
			this.line_vbBuffer=/*__JS__ */new ParamData(lineVertNumCopy*3 *4,true);
		}
		this._line_vbSize=this._line_vertNum *3 *4;
		var c2=ColorUtils.create(value);
		var nColor2=c2.numColor;
		var _line_vb=this.line_vbBuffer._float32Data;
		var _line_vb_i32b=this.line_vbBuffer._int32Data;
		var ix=0;
		for (i=0;i < this._line_vertNum;i++){
			_line_vb[ix++]=this._line_vbArray[i *2]+this.x;_line_vb[ix++]=this._line_vbArray[i *2+1]+this.y;_line_vb_i32b[ix++]=nColor2;
		};
		var _i32b=this._paramData._int32Data;;
		_i32b[DrawCircleCmdNative._PARAM_LINE_VB_POS_]=this.line_vbBuffer.getPtrID();
		_i32b[DrawCircleCmdNative._PARAM_LINE_IB_POS_]=this.line_ibBuffer.getPtrID();
		_i32b[DrawCircleCmdNative._PARAM_LINE_VB_SIZE_POS_]=this._line_vbSize;
		_i32b[DrawCircleCmdNative._PARAM_LINE_IB_SIZE_POS_]=this._line_ibSize;
		LayaGL.syncBufferToRenderThread(this.line_vbBuffer);
		LayaGL.syncBufferToRenderThread(this.line_ibBuffer);
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawCircle";
	});

	__getset(0,__proto,'fillColor',function(){
		return this._fillColor;
		},function(value){
		this._fillColor=value;
		var c1=ColorUtils.create(this._fillColor);
		var nColor=c1.numColor;
		var _i32b=this.vbBuffer._int32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			ix++;ix++;_i32b[ix++]=nColor;
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
		var _vb=this.vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			_vb[ix++]=this._points[i *2]+this._x;ix++;ix++;
		}
		if (this._lineColor){
			var _line_vb=this.line_vbBuffer._float32Data;
			ix=0;
			for (i=0;i < this._line_vertNum;i++){
				_line_vb[ix++]=this._line_vbArray[i *2]+this._x;ix++;ix++;
			}
			LayaGL.syncBufferToRenderThread(this.line_vbBuffer);
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
		var _vb=this.vbBuffer._float32Data;
		var ix=0;
		for (var i=0;i < this._vertNum;i++){
			ix++;_vb[ix++]=this._points[i *2+1]+this._y;ix++;
		}
		if (this._lineColor){
			var _line_vb=this.line_vbBuffer._float32Data;
			ix=0;
			for (i=0;i < this._line_vertNum;i++){
				ix++;_line_vb[ix++]=this._line_vbArray[i *2+1]+this._y;ix++;
			}
			LayaGL.syncBufferToRenderThread(this.line_vbBuffer);
		}
		LayaGL.syncBufferToRenderThread(this.vbBuffer);
	});

	__getset(0,__proto,'radius',function(){
		return this._radius;
		},function(value){
		this._points=this._arc(0,0,value);{
			this._vertNum=this._points.length / 2;
			var vertNumCopy=this._vertNum;
			var lineVertNumCopy=0;
			this._linePoints.length=0;
			this._line_ibArray.length=0;
			this._line_vbArray.length=0;
			var curvert=0;
			var faceNum=this._vertNum-2;
			if (!this.ibBuffer || this.ibBuffer.getByteLength()< faceNum *3 *2){
				this.ibBuffer=/*__JS__ */new ParamData(faceNum*3*2,true,true);
			}
			this._ibSize=faceNum *3 *2;
			var _ib=this.ibBuffer._int16Data;
			var idxpos=0;
			for (var fi=0;fi < faceNum;fi++){
				_ib[idxpos++]=curvert;
				_ib[idxpos++]=fi+1+curvert;
				_ib[idxpos++]=fi+2+curvert;
			}
			if (!this.vbBuffer || this.vbBuffer.getByteLength()< this._vertNum *3 *4){
				this.vbBuffer=/*__JS__ */new ParamData(vertNumCopy*3 *4,true);
			}
			this._vbSize=this._vertNum *3 *4;
			var c1=ColorUtils.create(this._fillColor);
			var nColor=c1.numColor;
			var _vb=this.vbBuffer._float32Data;
			var _vb_i32b=this.vbBuffer._int32Data;
			var ix=0;
			for (var i=0;i < this._vertNum;i++){
				_vb[ix++]=this._points[i *2]+this._x;_vb[ix++]=this._points[i *2+1]+this._y;_vb_i32b[ix++]=nColor;
			}
			if (this._lineColor){
				for (i=0;i < this._points.length;i++){
					this._linePoints.push(this._points[i]);
				}
				this._linePoints.push(this._points[0]);
				this._linePoints.push(this._points[1]);
				BasePoly.createLine2(this._linePoints,this._line_ibArray,this._lineWidth,0,this._line_vbArray,false);
				this._line_vertNum=this._linePoints.length;
				lineVertNumCopy=this._line_vertNum;
				if (!this.line_ibBuffer || this.line_ibBuffer.getByteLength()< (this._line_vertNum-2)*3*2){
					this.line_ibBuffer=/*__JS__ */new ParamData((lineVertNumCopy-2)*3*2,true,true);
				}
				this._line_ibSize=(this._line_vertNum-2)*3 *2;
				var _line_ib=this.line_ibBuffer._int16Data;
				idxpos=0;
				for (var ii=0;ii < (this._line_vertNum-2)*3;ii++){
					_line_ib[idxpos++]=this._line_ibArray[ii];
				}
				if (!this.line_vbBuffer || this.line_vbBuffer.getByteLength()< this._line_vertNum*3 *4){
					this.line_vbBuffer=/*__JS__ */new ParamData(lineVertNumCopy*3 *4,true);
				}
				this._line_vbSize=this._line_vertNum *3 *4;
				var c2=ColorUtils.create(this._lineColor);
				var nColor2=c2.numColor;
				var _line_vb=this.line_vbBuffer._float32Data;
				var _line_vb_i32b=this.line_vbBuffer._int32Data;
				ix=0;
				for (i=0;i < this._line_vertNum;i++){
					_line_vb[ix++]=this._line_vbArray[i *2]+this._x;
					_line_vb[ix++]=this._line_vbArray[i *2+1]+this._y;
					_line_vb_i32b[ix++]=nColor2;
				}
			};
			var _i32b=this._paramData._int32Data;
			_i32b[DrawCircleCmdNative._PARAM_VB_POS_]=this.vbBuffer.getPtrID();
			_i32b[DrawCircleCmdNative._PARAM_IB_POS_]=this.ibBuffer.getPtrID();
			_i32b[DrawCircleCmdNative._PARAM_VB_SIZE_POS_]=this._vbSize;
			_i32b[DrawCircleCmdNative._PARAM_IB_SIZE_POS_]=this._ibSize;
			LayaGL.syncBufferToRenderThread(this.vbBuffer);
			LayaGL.syncBufferToRenderThread(this.ibBuffer);
			if (this._lineColor){
				_i32b[DrawCircleCmdNative._PARAM_LINE_VB_POS_]=this.line_vbBuffer.getPtrID();
				_i32b[DrawCircleCmdNative._PARAM_LINE_IB_POS_]=this.line_ibBuffer.getPtrID();
				_i32b[DrawCircleCmdNative._PARAM_LINE_VB_SIZE_POS_]=this._line_vbSize;
				_i32b[DrawCircleCmdNative._PARAM_LINE_IB_SIZE_POS_]=this._line_ibSize;
				LayaGL.syncBufferToRenderThread(this.line_vbBuffer);
				LayaGL.syncBufferToRenderThread(this.line_ibBuffer);
			}
			LayaGL.syncBufferToRenderThread(this._paramData);
		}
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		if (!this._lineWidth&&this._lineColor){
			this._graphicsCmdEncoder._idata[this._cmdCurrentPos+1]=DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_.getPtrID();
			LayaGL.syncBufferToRenderThread(this._graphicsCmdEncoder);
		}
		this._lineWidth=value;
		this._linePoints.length=0;
		this._line_ibArray.length=0;
		this._line_vbArray.length=0;
		for (var i=0;i < this._points.length;i++){
			this._linePoints.push(this._points[i]);
		}
		this._linePoints.push(this._points[0]);
		this._linePoints.push(this._points[1]);
		BasePoly.createLine2(this._linePoints,this._line_ibArray,value,0,this._line_vbArray,false);
		this._line_vertNum=this._linePoints.length;
		var lineVertNumCopy=this._line_vertNum;
		if (!this.line_ibBuffer || this.line_ibBuffer.getByteLength()< (this._line_vertNum-2)*3*2){
			this.line_ibBuffer=/*__JS__ */new ParamData((lineVertNumCopy-2)*3*2,true,true);
		}
		this._line_ibSize=(this._line_vertNum-2)*3 *2;
		var _line_ib=this.line_ibBuffer._int16Data;
		var idxpos=0;
		for (var ii=0;ii < (this._line_vertNum-2)*3;ii++){
			_line_ib[idxpos++]=this._line_ibArray[ii];
		}
		if (!this.line_vbBuffer || this.line_vbBuffer.getByteLength()< this._line_vertNum*3 *4){
			this.line_vbBuffer=/*__JS__ */new ParamData(lineVertNumCopy*3 *4,true);
		}
		this._line_vbSize=this._line_vertNum *3 *4;
		var c2=ColorUtils.create(this._lineColor);
		var nColor2=c2.numColor;
		var _line_vb=this.line_vbBuffer._float32Data;
		var _line_vb_i32b=this.line_vbBuffer._int32Data;
		var ix=0;
		for (i=0;i < this._line_vertNum;i++){
			_line_vb[ix++]=this._line_vbArray[i *2]+this.x;_line_vb[ix++]=this._line_vbArray[i *2+1]+this.y;_line_vb_i32b[ix++]=nColor2;
		};
		var _i32b=this._paramData._int32Data;;
		_i32b[DrawCircleCmdNative._PARAM_LINE_VB_POS_]=this.line_vbBuffer.getPtrID();
		_i32b[DrawCircleCmdNative._PARAM_LINE_IB_POS_]=this.line_ibBuffer.getPtrID();
		_i32b[DrawCircleCmdNative._PARAM_LINE_VB_SIZE_POS_]=this._line_vbSize;
		_i32b[DrawCircleCmdNative._PARAM_LINE_IB_SIZE_POS_]=this._line_ibSize;
		LayaGL.syncBufferToRenderThread(this.line_vbBuffer);
		LayaGL.syncBufferToRenderThread(this.line_ibBuffer);
		LayaGL.syncBufferToRenderThread(this._paramData);
	});

	DrawCircleCmdNative.create=function(x,y,radius,fillColor,lineColor,lineWidth,vid){
		var cmd=Pool.getItemByClass("DrawCircleCmd",DrawCircleCmdNative);
		cmd._graphicsCmdEncoder=/*__JS__ */this._commandEncoder;;
		if (!DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_){
			DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(244,32,true);
			DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);
			DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);
			DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_.setMeshExByParamData(DrawCircleCmdNative._PARAM_VB_POS_ *4,DrawCircleCmdNative._PARAM_VB_OFFSET_POS_ *4,DrawCircleCmdNative._PARAM_VB_SIZE_POS_ *4,DrawCircleCmdNative._PARAM_IB_POS_ *4,DrawCircleCmdNative._PARAM_IB_OFFSET_POS_ *4,DrawCircleCmdNative._PARAM_IB_SIZE_POS_ *4,DrawCircleCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_.setMeshExByParamData(DrawCircleCmdNative._PARAM_LINE_VB_POS_ *4,DrawCircleCmdNative._PARAM_LINE_VB_OFFSET_POS_ *4,DrawCircleCmdNative._PARAM_LINE_VB_SIZE_POS_ *4,DrawCircleCmdNative._PARAM_LINE_IB_POS_ *4,DrawCircleCmdNative._PARAM_LINE_IB_OFFSET_POS_ *4,DrawCircleCmdNative._PARAM_LINE_IB_SIZE_POS_ *4,DrawCircleCmdNative._PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_);
		}
		if (!DrawCircleCmdNative._DRAW_CIRCLE_CMD_ENCODER_){
			DrawCircleCmdNative._DRAW_CIRCLE_CMD_ENCODER_=LayaGL.instance.createCommandEncoder(168,32,true);
			DrawCircleCmdNative._DRAW_CIRCLE_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			DrawCircleCmdNative._DRAW_CIRCLE_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);
			DrawCircleCmdNative._DRAW_CIRCLE_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);
			DrawCircleCmdNative._DRAW_CIRCLE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS,0);
			DrawCircleCmdNative._DRAW_CIRCLE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR,1);
			DrawCircleCmdNative._DRAW_CIRCLE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS,2);
			DrawCircleCmdNative._DRAW_CIRCLE_CMD_ENCODER_.setMeshExByParamData(DrawCircleCmdNative._PARAM_VB_POS_ *4,DrawCircleCmdNative._PARAM_VB_OFFSET_POS_ *4,DrawCircleCmdNative._PARAM_VB_SIZE_POS_ *4,DrawCircleCmdNative._PARAM_IB_POS_ *4,DrawCircleCmdNative._PARAM_IB_OFFSET_POS_ *4,DrawCircleCmdNative._PARAM_IB_SIZE_POS_ *4,DrawCircleCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_ *4);
			DrawCircleCmdNative._DRAW_CIRCLE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32,0,/*laya.layagl.LayaGL.VALUE_OPERATE_M32_MUL*/7);
			DrawCircleCmdNative._DRAW_CIRCLE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,1,/*laya.layagl.LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL*/15);
			LayaGL.syncBufferToRenderThread(DrawCircleCmdNative._DRAW_CIRCLE_CMD_ENCODER_);
		}
		if (!cmd._paramData){
			cmd._paramData=/*__JS__ */new ParamData(18 *4,true);
			}{
			cmd._x=x;
			cmd._y=y;
			cmd._radius=radius;
			cmd._fillColor=fillColor;
			cmd._lineColor=lineColor;
			cmd._lineWidth=lineWidth;
			cmd._points=cmd._arc(0,0,radius);
			cmd._vertNum=cmd._points.length / 2;
			var vertNumCopy=cmd._vertNum;
			var curvert=0;
			var faceNum=cmd._vertNum-2;
			if (!cmd.ibBuffer || cmd.ibBuffer.getByteLength()< faceNum *3 *2){
				cmd.ibBuffer=/*__JS__ */new ParamData(faceNum*3*2,true,true);
			}
			cmd._ibSize=faceNum *3 *2;
			var _ib=cmd.ibBuffer._int16Data;
			var idxpos=0;
			for (var fi=0;fi < faceNum;fi++){
				_ib[idxpos++]=curvert;
				_ib[idxpos++]=fi+1+curvert;
				_ib[idxpos++]=fi+2+curvert;
			};
			var c1=ColorUtils.create(fillColor);
			var nColor=c1.numColor;
			if (!cmd.vbBuffer || cmd.vbBuffer.getByteLength()< cmd._vertNum *3 *4){
				cmd.vbBuffer=/*__JS__ */new ParamData(vertNumCopy*3 *4,true);
			}
			cmd._vbSize=cmd._vertNum *3 *4;
			var _vb=cmd.vbBuffer._float32Data;
			var _vb_i32b=cmd.vbBuffer._int32Data;
			var ix=0;
			for (var i=0;i < cmd._vertNum;i++){
				_vb[ix++]=cmd._points[i *2]+x;_vb[ix++]=cmd._points[i *2+1]+y;_vb_i32b[ix++]=nColor;
			};
			var lineVertNumCopy=0;
			for (i=0;i < cmd._points.length;i++){
				cmd._linePoints.push(cmd._points[i]);
			}
			cmd._linePoints.push(cmd._points[0]);
			cmd._linePoints.push(cmd._points[1]);
			if (lineColor){
				BasePoly.createLine2(cmd._linePoints,cmd._line_ibArray,lineWidth,0,cmd._line_vbArray,false);
				cmd._line_vertNum=cmd._linePoints.length;
				lineVertNumCopy=cmd._line_vertNum;
				if (!cmd.line_ibBuffer || cmd.line_ibBuffer.getByteLength()< (cmd._line_vertNum-2)*3*2){
					cmd.line_ibBuffer=/*__JS__ */new ParamData((lineVertNumCopy-2)*3*2,true,true);
				}
				cmd._line_ibSize=(cmd._line_vertNum-2)*3 *2;
				var _line_ib=cmd.line_ibBuffer._int16Data;
				idxpos=0;
				for (var ii=0;ii < (cmd._line_vertNum-2)*3;ii++){
					_line_ib[idxpos++]=cmd._line_ibArray[ii];
				}
				if (!cmd.line_vbBuffer || cmd.line_vbBuffer.getByteLength()< cmd._line_vertNum*3 *4){
					cmd.line_vbBuffer=/*__JS__ */new ParamData(lineVertNumCopy*3 *4,true);
				}
				cmd._line_vbSize=cmd._line_vertNum *3 *4;
				var c2=ColorUtils.create(lineColor);
				var nColor2=c2.numColor;
				var _line_vb=cmd.line_vbBuffer._float32Data;
				var _line_vb_i32b=cmd.line_vbBuffer._int32Data;
				ix=0;
				for (i=0;i < cmd._line_vertNum;i++){
					_line_vb[ix++]=cmd._line_vbArray[i *2]+x;_line_vb[ix++]=cmd._line_vbArray[i *2+1]+y;_line_vb_i32b[ix++]=nColor2;
				}
			}
			else{
				cmd._lineWidth=1;
				var temp_lineColor='#FFFFFF';
				BasePoly.createLine2(cmd._linePoints,cmd._line_ibArray,cmd._lineWidth,0,cmd._line_vbArray,false);
				cmd._line_vertNum=cmd._linePoints.length;
				lineVertNumCopy=cmd._line_vertNum;
				if (!cmd.line_ibBuffer || cmd.line_ibBuffer.getByteLength()< (cmd._line_vertNum-2)*3*2){
					cmd.line_ibBuffer=/*__JS__ */new ParamData((lineVertNumCopy-2)*3*2,true,true);
				}
				cmd._line_ibSize=(cmd._line_vertNum-2)*3 *2;
				_line_ib=cmd.line_ibBuffer._int16Data;
				idxpos=0;
				for (ii=0;ii < (cmd._line_vertNum-2)*3;ii++){
					_line_ib[idxpos++]=cmd._line_ibArray[ii];
				}
				if (!cmd.line_vbBuffer || cmd.line_vbBuffer.getByteLength()< cmd._line_vertNum*3 *4){
					cmd.line_vbBuffer=/*__JS__ */new ParamData(lineVertNumCopy*3 *4,true);
				}
				cmd._line_vbSize=cmd._line_vertNum *3 *4;
				c2=ColorUtils.create(temp_lineColor);
				nColor2=c2.numColor;
				_line_vb=cmd.line_vbBuffer._float32Data;
				_line_vb_i32b=cmd.line_vbBuffer._int32Data;
				ix=0;
				for (i=0;i < cmd._line_vertNum;i++){
					_line_vb[ix++]=cmd._line_vbArray[i *2]+x;_line_vb[ix++]=cmd._line_vbArray[i *2+1]+y;_line_vb_i32b[ix++]=nColor2;
				}
			}
		};
		var _fb=cmd._paramData._float32Data;
		var _i32b=cmd._paramData._int32Data;
		_i32b[0]=1;
		_i32b[1]=8*4;
		_i32b[DrawCircleCmdNative._PARAM_VB_POS_]=cmd.vbBuffer.getPtrID();
		_i32b[DrawCircleCmdNative._PARAM_IB_POS_]=cmd.ibBuffer.getPtrID();
		_i32b[DrawCircleCmdNative._PARAM_VB_SIZE_POS_]=cmd._vbSize;
		_i32b[DrawCircleCmdNative._PARAM_IB_SIZE_POS_]=cmd._ibSize;
		_i32b[DrawCircleCmdNative._PARAM_VB_OFFSET_POS_]=0;
		_i32b[DrawCircleCmdNative._PARAM_IB_OFFSET_POS_]=0;
		_i32b[DrawCircleCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_]=0;
		LayaGL.syncBufferToRenderThread(cmd.vbBuffer);
		LayaGL.syncBufferToRenderThread(cmd.ibBuffer);
		_i32b[DrawCircleCmdNative._PARAM_LINE_VB_POS_]=cmd.line_vbBuffer.getPtrID();
		_i32b[DrawCircleCmdNative._PARAM_LINE_IB_POS_]=cmd.line_ibBuffer.getPtrID();
		_fb[DrawCircleCmdNative._PARAM_LINECOLOR_POS_]=lineColor;
		_fb[DrawCircleCmdNative._PARAM_LINEWIDTH_POS_]=lineWidth;
		_i32b[DrawCircleCmdNative._PARAM_LINE_VB_SIZE_POS_]=cmd._line_vbSize;
		_i32b[DrawCircleCmdNative._PARAM_LINE_IB_SIZE_POS_]=cmd._line_ibSize;
		_i32b[DrawCircleCmdNative._PARAM_LINE_VB_OFFSET_POS_]=0;
		_i32b[DrawCircleCmdNative._PARAM_LINE_IB_OFFSET_POS_]=0;
		_i32b[DrawCircleCmdNative._PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_]=0;
		LayaGL.syncBufferToRenderThread(cmd.line_vbBuffer);
		LayaGL.syncBufferToRenderThread(cmd.line_ibBuffer);
		LayaGL.syncBufferToRenderThread(cmd._paramData);
		if (lineColor){
			cmd._cmdCurrentPos=cmd._graphicsCmdEncoder.useCommandEncoder(DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		}
		else{
			cmd._cmdCurrentPos=cmd._graphicsCmdEncoder.useCommandEncoder(DrawCircleCmdNative._DRAW_CIRCLE_CMD_ENCODER_.getPtrID(),cmd._paramData.getPtrID(),-1);
		}
		LayaGL.syncBufferToRenderThread(cmd._graphicsCmdEncoder);
		return cmd;
	}

	DrawCircleCmdNative.ID="DrawCircle";
	DrawCircleCmdNative._DRAW_CIRCLE_CMD_ENCODER_=null;
	DrawCircleCmdNative._DRAW_CIRCLE_LINES_CMD_ENCODER_=null;
	DrawCircleCmdNative._PARAM_VB_POS_=2;
	DrawCircleCmdNative._PARAM_IB_POS_=3;
	DrawCircleCmdNative._PARAM_LINE_VB_POS_=4;
	DrawCircleCmdNative._PARAM_LINE_IB_POS_=5;
	DrawCircleCmdNative._PARAM_LINECOLOR_POS_=6;
	DrawCircleCmdNative._PARAM_LINEWIDTH_POS_=7;
	DrawCircleCmdNative._PARAM_VB_SIZE_POS_=8;
	DrawCircleCmdNative._PARAM_IB_SIZE_POS_=9;
	DrawCircleCmdNative._PARAM_LINE_VB_SIZE_POS_=10;
	DrawCircleCmdNative._PARAM_LINE_IB_SIZE_POS_=11;
	DrawCircleCmdNative._PARAM_VB_OFFSET_POS_=12;
	DrawCircleCmdNative._PARAM_IB_OFFSET_POS_=13;
	DrawCircleCmdNative._PARAM_LINE_VB_OFFSET_POS_=14;
	DrawCircleCmdNative._PARAM_LINE_IB_OFFSET_POS_=15;
	DrawCircleCmdNative._PARAM_INDEX_ELEMENT_OFFSET_POS_=16;
	DrawCircleCmdNative._PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_=17;
	return DrawCircleCmdNative;
})()


/**
*文字贴图的大图集。
*/
//class laya.webgl.text.TextAtlas
var TextAtlas=(function(){
	function TextAtlas(){
		this.texWidth=1024;
		this.texHeight=1024;
		this.atlasgrid=null;
		this.protectDist=1;
		this.texture=null;
		this.charMaps={};
		this.texHeight=this.texWidth=TextRender.atlasWidth;
		this.texture=TextTexture.getTextTexture(this.texWidth,this.texHeight);
		if (this.texWidth / TextAtlas.atlasGridW > 256){
			TextAtlas.atlasGridW=Math.ceil(this.texWidth / 256);
		}
		this.atlasgrid=new AtlasGrid(this.texWidth / TextAtlas.atlasGridW,this.texHeight / TextAtlas.atlasGridW,this.texture.id);
	}

	__class(TextAtlas,'laya.webgl.text.TextAtlas');
	var __proto=TextAtlas.prototype;
	__proto.setProtecteDist=function(d){
		this.protectDist=d;
	}

	/**
	*如果返回null，则表示无法加入了
	*分配的时候优先选择最接近自己高度的节点
	*@param w
	*@param h
	*@return
	*/
	__proto.getAEmpty=function(w,h,pt){
		var find=this.atlasgrid.addRect(1,Math.ceil(w / TextAtlas.atlasGridW),Math.ceil(h / TextAtlas.atlasGridW),pt);
		if (find){
			pt.x *=TextAtlas.atlasGridW;
			pt.y *=TextAtlas.atlasGridW;
		}
		return find;
	}

	/*
	public function pushData(data:ImageData,node:TextAtlasNode):void {
		texture.addChar(data,node.x,node.y);
	}

	*/
	__proto.destroy=function(){
		for (var k in this.charMaps){
			var ri=this.charMaps[k];
			ri.deleted=true;
		}
		this.texture.discard();
	}

	__proto.printDebugInfo=function(){}
	/**
	*大图集格子单元的占用率，老的也算上了。只是表示这个大图集还能插入多少东西。
	*/
	__getset(0,__proto,'usedRate',function(){
		return this.atlasgrid._used;
	});

	TextAtlas.atlasGridW=16;
	return TextAtlas;
})()


//class laya.webgl.utils.RenderSprite3D extends laya.renders.RenderSprite
var RenderSprite3D=(function(_super){
	function RenderSprite3D(type,next){
		RenderSprite3D.__super.call(this,type,next);
	}

	__class(RenderSprite3D,'laya.webgl.utils.RenderSprite3D',_super);
	var __proto=RenderSprite3D.prototype;
	__proto.onCreate=function(type){
		switch (type){
			case /*laya.display.SpriteConst.BLEND*/0x04:
				this._fun=this._blend;
				return;
			}
	}

	/**
	*mask的渲染。 sprite有mask属性的情况下，来渲染这个sprite
	*@param sprite
	*@param context
	*@param x
	*@param y
	*/
	__proto._mask=function(sprite,context,x,y){
		var next=this._next;
		var mask=sprite.mask;
		var submitCMD;
		var ctx=context;
		if (mask){
			ctx.save();
			var preBlendMode=ctx.globalCompositeOperation;
			var tRect=new Rectangle();
			tRect.copyFrom(mask.getBounds());
			tRect.width=Math.round(tRect.width);
			tRect.height=Math.round(tRect.height);
			tRect.x=Math.round(tRect.x);
			tRect.y=Math.round(tRect.y);
			if (tRect.width > 0 && tRect.height > 0){
				var w=tRect.width;
				var h=tRect.height;
				var tmpRT=WebGLRTMgr.getRT(w,h);
				ctx.breakNextMerge();
				ctx.pushRT();
				ctx.addRenderObject(SubmitCMD.create([ctx,tmpRT,w,h],laya.webgl.utils.RenderSprite3D.tmpTarget,this));
				mask.render(ctx,-tRect.x,-tRect.y);
				ctx.breakNextMerge();
				ctx.popRT();
				ctx.save();
				ctx.clipRect(x+tRect.x-sprite.getStyle().pivotX,y+tRect.y-sprite.getStyle().pivotY,w,h);
				next._fun.call(next,sprite,ctx,x,y);
				ctx.restore();
				preBlendMode=ctx.globalCompositeOperation;
				ctx.addRenderObject(SubmitCMD.create(["mask"],laya.webgl.utils.RenderSprite3D.setBlendMode,this));
				var shaderValue=Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0);
				var uv=Texture.INV_UV;
				ctx.drawTarget(tmpRT,x+tRect.x-sprite.getStyle().pivotX ,y+tRect.y-sprite.getStyle().pivotY,w,h,Matrix.TEMP.identity(),shaderValue,uv,6);
				ctx.addRenderObject(SubmitCMD.create([tmpRT],laya.webgl.utils.RenderSprite3D.recycleTarget,this));
				ctx.addRenderObject(SubmitCMD.create([preBlendMode],laya.webgl.utils.RenderSprite3D.setBlendMode,this));
			}
			ctx.restore();
			}else {
			next._fun.call(next,sprite,context,x,y);
		}
	}

	__proto._blend=function(sprite,context,x,y){
		var style=sprite._style;
		var next=this._next;
		if (style.blendMode){
			context.save();
			context.globalCompositeOperation=style.blendMode;
			next._fun.call(next,sprite,context,x,y);
			context.restore();
			}else {
			next._fun.call(next,sprite,context,x,y);
		}
	}

	RenderSprite3D.tmpTarget=function(ctx,rt,w,h){
		rt.start();
		rt.clear(0,0,0,0);
	}

	RenderSprite3D.recycleTarget=function(rt){
		WebGLRTMgr.releaseRT(rt);
	}

	RenderSprite3D.setBlendMode=function(blendMode){
		var gl=WebGL.mainContext;
		BlendMode.targetFns[BlendMode.TOINT[blendMode]](gl);
	}

	__static(RenderSprite3D,
	['tempUV',function(){return this.tempUV=new Array(8);}
	]);
	return RenderSprite3D;
})(RenderSprite)


//class laya.webgl.canvas.WebGLContext2D extends laya.resource.Context
var WebGLContext2D=(function(_super){
	var ContextParams;
	function WebGLContext2D(){
		this._drawTriUseAbsMatrix=false;
		//还原2D视口
		this._id=++WebGLContext2D._COUNT;
		//this._other=null;
		//this._renderNextSubmitIndex=0;
		this._path=null;
		//this._primitiveValue2D=null;
		this._drawCount=1;
		this._maxNumEle=0;
		this._renderCount=0;
		this._isConvexCmd=true;
		//arc等是convex的，moveTo,linTo就不是了
		this._submits=null;
		this._curSubmit=null;
		//当前将要使用的设置。用来跟上一次的_curSubmit比较
		//this._mesh=null;
		//用Mesh2D代替_vb,_ib. 当前使用的mesh
		//this._pathMesh=null;
		//矢量专用mesh。
		//this._triangleMesh=null;
		//drawTriangles专用mesh。由于ib不固定，所以不能与_mesh通用
		this.meshlist=[];
		//用矩阵描述的clip信息。最终的点投影到这个矩阵上，在0~1之间就可见。
		this._clipInfoID=0;
		//生成clipid的，原来是 _clipInfoID=++_clipInfoID 这样会有问题，导致兄弟clip的id都相同
		//this._curMat=null;
		//计算矩阵缩放的缓存
		this._lastMatScaleX=1.0;
		this._lastMatScaleY=1.0;
		this._lastMat_a=1.0;
		this._lastMat_b=0.0;
		this._lastMat_c=0.0;
		this._lastMat_d=1.0;
		this._nBlendType=0;
		//this._save=null;
		//this._targets=null;
		//this._charSubmitCache=null;
		this._saveMark=null;
		/**
		*所cacheAs精灵
		*对于cacheas bitmap的情况，如果图片还没准备好，需要有机会重画，所以要保存sprite。例如在图片
		*加载完成后，调用repaint
		*/
		//this.sprite=null;
		//文字颜色。使用顶点色
		this._drawTextureUseColor=false;
		this._italicDeg=0;
		//文字的倾斜角度
		this._lastTex=null;
		//上次使用的texture。主要是给fillrect用，假装自己也是一个drawtexture
		this._fillColor=0;
		this._flushCnt=0;
		//给fillrect用
		//this._colorFiler=null;
		this.drawTexAlign=false;
		/*******************************************start矢量绘制***************************************************/
		this.mId=-1;
		this.mHaveKey=false;
		this.mHaveLineKey=false;
		WebGLContext2D.__super.call(this);
		this._width=99999999;
		this._height=99999999;
		this._submitKey=new SubmitKey();
		this._transedPoints=new Array(8);
		this._temp4Points=new Array(8);
		this._clipRect=WebGLContext2D.MAXCLIPRECT;
		this._globalClipMatrix=new Matrix(/*CLASS CONST:laya.webgl.canvas.WebGLContext2D._MAXSIZE*/99999999,0,0,/*CLASS CONST:laya.webgl.canvas.WebGLContext2D._MAXSIZE*/99999999,0,0);
		this._shader2D=new Shader2D();
		this.mOutPoint
		WebGLContext2D._contextcount++;
		if (!WebGLContext2D.defTexture){
			var defTex2d=new Texture2D(2,2);
			defTex2d.setPixels(new Uint8Array(16));
			WebGLContext2D.defTexture=new Texture(defTex2d);
		}
		this._lastTex=WebGLContext2D.defTexture;
		this.clear();
	}

	__class(WebGLContext2D,'laya.webgl.canvas.WebGLContext2D',_super);
	var __proto=WebGLContext2D.prototype;
	__proto.clearBG=function(r,g,b,a){
		var gl=WebGL.mainContext;
		gl.clearColor(r,g,b,a);
		gl.clear(/*laya.webgl.WebGLContext.COLOR_BUFFER_BIT*/0x00004000);
	}

	//TODO:coverage
	__proto._getSubmits=function(){
		return this._submits;
	}

	__proto._releaseMem=function(){
		if (!this._submits)
			return;
		this._curMat.destroy();
		this._curMat=null;
		this._shader2D.destroy();
		this._shader2D=null;
		this._charSubmitCache.clear();
		for (var i=0,n=this._submits._length;i < n;i++){
			this._submits[i].releaseRender();
		}
		this._submits.length=0;
		this._submits._length=0;
		this._submits=null;
		this._curSubmit=null;
		this._path=null;
		this._save=null;
		var sz=0;
		for (i=0,sz=this.meshlist.length;i < sz;i++){
			var curm=this.meshlist[i];
			curm.destroy();
		}
		this.meshlist.length=0;
		this.sprite=null;
		this._targets && (this._targets.destroy());
		this._targets=null;
	}

	//TODO:coverage
	__proto.destroy=function(){
		--WebGLContext2D._contextcount;
		this.sprite=null;
		this._releaseMem();
		this._charSubmitCache.destroy();
		this._targets && this._targets.destroy();
		this._targets=null;
		this._mesh.destroy();
	}

	__proto.clear=function(){
		if (!this._submits){
			this._other=ContextParams.DEFAULT;
			this._curMat=Matrix.create();
			this._charSubmitCache=new CharSubmitCache();
			this._mesh=MeshQuadTexture.getAMesh();
			this.meshlist.push(this._mesh);
			this._pathMesh=MeshVG.getAMesh();
			this.meshlist.push(this._pathMesh);
			this._triangleMesh=MeshTexture.getAMesh();
			this.meshlist.push(this._triangleMesh);
			this._submits=[];
			this._save=[SaveMark.Create(this)];
			this._save.length=10;
			this._shader2D=new Shader2D();
		}
		this._submitKey.clear();
		this._mesh.clearVB();
		this._renderCount++;
		this._drawCount=1;
		this._other=ContextParams.DEFAULT;
		this._other.lineWidth=this._shader2D.ALPHA=1.0;
		this._nBlendType=0;
		this._clipRect=WebGLContext2D.MAXCLIPRECT;
		this._curSubmit=Submit.RENDERBASE;
		Submit.RENDERBASE._ref=0xFFFFFF;
		Submit.RENDERBASE._numEle=0;
		this._shader2D.fillStyle=this._shader2D.strokeStyle=DrawStyle.DEFAULT;
		for (var i=0,n=this._submits._length;i < n;i++)
		this._submits[i].releaseRender();
		this._submits._length=0;
		this._curMat.identity();
		this._other.clear();
		this._saveMark=this._save[0];
		this._save._length=1;
	}

	/**
	*设置ctx的size，这个不允许直接设置，必须是canvas调过来的。所以这个函数里也不用考虑canvas相关的东西
	*@param w
	*@param h
	*/
	__proto.size=function(w,h){
		if (this._width !=w || this._height !=h){
			this._width=w;
			this._height=h;
			if (this._targets){
				this._targets.destroy();
				this._targets=new RenderTexture2D(w,h,/*laya.webgl.resource.BaseTexture.FORMAT_R8G8B8A8*/1,-1);
			}
			if (Render._context==this){
				WebGL.mainContext.viewport(0,0,w,h);
				RenderState2D.width=w;
				RenderState2D.height=h;
			}
		}
		if (w===0 && h===0)this._releaseMem();
	}

	/**
	*获得当前矩阵的缩放值
	*避免每次都计算getScaleX
	*@return
	*/
	__proto.getMatScaleX=function(){
		if (this._lastMat_a==this._curMat.a && this._lastMat_b==this._curMat.b)
			return this._lastMatScaleX;
		this._lastMatScaleX=this._curMat.getScaleX();
		this._lastMat_a=this._curMat.a;
		this._lastMat_b=this._curMat.b;
		return this._lastMatScaleX;
	}

	__proto.getMatScaleY=function(){
		if (this._lastMat_c==this._curMat.c && this._lastMat_d==this._curMat.d)
			return this._lastMatScaleY;
		this._lastMatScaleY=this._curMat.getScaleY();
		this._lastMat_c=this._curMat.c;
		this._lastMat_d=this._curMat.d;
		return this._lastMatScaleY;
	}

	//TODO
	__proto.setFillColor=function(color){
		this._fillColor=color;
	}

	__proto.getFillColor=function(){
		return this._fillColor;
	}

	__proto.translate=function(x,y){
		if (x!==0 || y!==0){
			SaveTranslate.save(this);
			if (this._curMat._bTransform){
				SaveTransform.save(this);
				this._curMat.tx+=(x *this._curMat.a+y *this._curMat.c);
				this._curMat.ty+=(x *this._curMat.b+y *this._curMat.d);
				}else {
				this._curMat.tx=x;
				this._curMat.ty=y;
			}
		}
	}

	__proto.save=function(){
		this._save[this._save._length++]=SaveMark.Create(this);
	}

	__proto.restore=function(){
		var sz=this._save._length;
		var lastBlend=this._nBlendType;
		if (sz < 1)
			return;
		for (var i=sz-1;i >=0;i--){
			var o=this._save[i];
			o.restore(this);
			if (o.isSaveMark()){
				this._save._length=i;
				return;
			}
		}
		if (lastBlend !=this._nBlendType){
			this._curSubmit=Submit.RENDERBASE;
		}
	}

	//TODO:coverage
	__proto.fillText=function(txt,x,y,fontStr,color,align){
		this._fillText(txt,null,x,y,fontStr,color,null,0,null);
	}

	/**
	*
	*@param txt
	*@param words HTMLChar 数组，是已经在外面排好版的一个数组
	*@param x
	*@param y
	*@param fontStr
	*@param color
	*@param strokeColor
	*@param lineWidth
	*@param textAlign
	*@param underLine
	*/
	__proto._fillText=function(txt,words,x,y,fontStr,color,strokeColor,lineWidth,textAlign,underLine){
		(underLine===void 0)&& (underLine=0);
		if (txt)
			WebGLContext2D._textRender.filltext(this,txt,x,y,fontStr,color,strokeColor,lineWidth,textAlign,underLine);
		else if(words)
		WebGLContext2D._textRender.fillWords(this,words,x,y,fontStr,color,strokeColor,lineWidth);
	}

	__proto._fast_filltext=function(data,x,y,fontObj,color,strokeColor,lineWidth,textAlign,underLine){
		(underLine===void 0)&& (underLine=0);
		WebGLContext2D._textRender._fast_filltext(this,data,null,x,y,fontObj,color,strokeColor,lineWidth,textAlign,underLine);
	}

	//TODO:coverage
	__proto.fillWords=function(words,x,y,fontStr,color){
		this._fillText(null,words,x,y,fontStr,color,null,-1,null,0);
	}

	//TODO:coverage
	__proto.fillBorderWords=function(words,x,y,font,color,borderColor,lineWidth){
		this._fillBorderText(null,words,x,y,font,color,borderColor,lineWidth,null);
	}

	__proto.drawText=function(text,x,y,font,color,textAlign){
		this._fillText(text,null,x,y,font,ColorUtils.create(color).strColor,null,-1,textAlign);
	}

	/**
	*只画边框
	*@param text
	*@param x
	*@param y
	*@param font
	*@param color
	*@param lineWidth
	*@param textAlign
	*/
	__proto.strokeWord=function(text,x,y,font,color,lineWidth,textAlign){;
		this._fillText(text,null,x,y,font,null,ColorUtils.create(color).strColor,lineWidth || 1,textAlign);
	}

	/**
	*即画文字又画边框
	*@param txt
	*@param x
	*@param y
	*@param fontStr
	*@param fillColor
	*@param borderColor
	*@param lineWidth
	*@param textAlign
	*/
	__proto.fillBorderText=function(txt,x,y,fontStr,fillColor,borderColor,lineWidth,textAlign){
		this._fillBorderText(txt,null,x,y,fontStr,ColorUtils.create(fillColor).strColor,ColorUtils.create(borderColor).strColor,lineWidth,textAlign);
	}

	__proto._fillBorderText=function(txt,words,x,y,fontStr,fillColor,borderColor,lineWidth,textAlign){
		this._fillText(txt,words,x,y,fontStr,fillColor,borderColor,lineWidth || 1,textAlign);
	}

	__proto._fillRect=function(x,y,width,height,rgba){
		var submit=this._curSubmit;
		var sameKey=submit && (submit._key.submitType===/*laya.webgl.submit.Submit.KEY_DRAWTEXTURE*/2 && submit._key.blendShader===this._nBlendType);
		if (this._mesh.vertNum+4 > 65535){
			this._mesh=MeshQuadTexture.getAMesh();
			this.meshlist.push(this._mesh);
			sameKey=false;
		}
		sameKey && (sameKey=sameKey&& this.isSameClipInfo(submit));
		this.transformQuad(x,y,width,height,0,this._curMat,this._transedPoints);
		if(!this.clipedOff(this._transedPoints)){
			this._mesh.addQuad(this._transedPoints,Texture.NO_UV,rgba,false);
			if (!sameKey){
				submit=this._curSubmit=SubmitTexture.create(this,this._mesh,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0));
				this._submits[this._submits._length++]=submit;
				this._copyClipInfo(submit,this._globalClipMatrix);
				submit.shaderValue.textureHost=this._lastTex;
				submit._key.other=(this._lastTex && this._lastTex.bitmap)?this._lastTex.bitmap.id:-1
				submit._renderType=/*laya.webgl.submit.Submit.TYPE_TEXTURE*/10016;
			}
			this._curSubmit._numEle+=6;
			this._mesh.indexNum+=6;
			this._mesh.vertNum+=4;
		}
	}

	__proto.fillRect=function(x,y,width,height,fillStyle){
		var drawstyle=fillStyle? DrawStyle.create(fillStyle):this._shader2D.fillStyle;
		var rgba=this.mixRGBandAlpha(drawstyle.toInt());
		this._fillRect(x,y,width,height,rgba);
	}

	//TODO:coverage
	__proto.fillTexture=function(texture,x,y,width,height,type,offset,other){
		if (!texture._getSource()){
			this.sprite && Laya.systemTimer.callLater(this,this._repaintSprite);
			return;
		};
		var submit=this._curSubmit;
		var sameKey=false;
		if (this._mesh.vertNum+4 > 65535){
			this._mesh=MeshQuadTexture.getAMesh();
			this.meshlist.push(this._mesh);
			sameKey=false;
		};
		var tex2d=texture.bitmap;
		var repeatx=true;
		var repeaty=true;
		switch(type){
			case "repeat":break ;
			case "repeat-x":repeaty=false;break ;
			case "repeat-y":repeatx=false;break ;
			case "no-repeat":repeatx=repeaty=false;break ;
			default :break ;
			};
		var uv=this._temp4Points;
		var stu=0;
		var stv=0;
		var stx=0,sty=0,edx=0,edy=0;
		if (offset.x < 0){
			stx=x;
			stu=(-offset.x %texture.width)/ texture.width;
			}else {
			stx=x+offset.x;
		}
		if (offset.y < 0){
			sty=y;
			stv=(-offset.y %texture.height)/ texture.height;
			}else {
			sty=y+offset.y;
		}
		edx=x+width;
		edy=y+height;
		(!repeatx)&& (edx=Math.min(edx,x+offset.x+texture.width));
		(!repeaty)&& (edy=Math.min(edy,y+offset.y+texture.height));
		if (edx < x || edy < y)
			return;
		if (stx > edx || sty > edy)
			return;
		var edu=(edx-x-offset.x)/texture.width;
		var edv=(edy-y-offset.y)/ texture.height;
		this.transformQuad(stx,sty,edx-stx,edy-sty,0,this._curMat,this._transedPoints);
		uv[0]=stu;uv[1]=stv;uv[2]=edu;uv[3]=stv;uv[4]=edu;uv[5]=edv;uv[6]=stu;uv[7]=edv;
		if (!this.clipedOff(this._transedPoints)){
			var rgba=this._mixRGBandAlpha(0xffffffff,this._shader2D.ALPHA);
			this._mesh.addQuad(this._transedPoints,uv,rgba,true);
			var sv=Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0);
			sv.defines.add(/*laya.webgl.shader.d2.ShaderDefines2D.FILLTEXTURE*/0x100);
			(sv).u_TexRange=texture.uvrect;
			submit=this._curSubmit=SubmitTexture.create(this,this._mesh,sv);
			this._submits[this._submits._length++]=submit;
			this._copyClipInfo(submit,this._globalClipMatrix);
			submit.shaderValue.textureHost=texture;
			submit._renderType=/*laya.webgl.submit.Submit.TYPE_TEXTURE*/10016;
			this._curSubmit._numEle+=6;
			this._mesh.indexNum+=6;
			this._mesh.vertNum+=4;
		}
		this.breakNextMerge();
	}

	/**
	*反正只支持一种filter，就不要叫setFilter了，直接叫setColorFilter
	*@param value
	*/
	__proto.setColorFilter=function(filter){
		SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_COLORFILTER*/0x800000,this,true);
		this._colorFiler=filter;
		this._curSubmit=Submit.RENDERBASE;
	}

	//_reCalculateBlendShader();
	__proto.drawTexture=function(tex,x,y,width,height){
		this._drawTextureM(tex,x,y,width,height,null,1,null);
	}

	__proto.drawTextures=function(tex,pos,tx,ty){
		if (!tex._getSource()){
			this.sprite && Laya.systemTimer.callLater(this,this._repaintSprite);
			return;
		};
		var n=pos.length / 2;
		var ipos=0;
		for (var i=0;i < n;i++){
			this._inner_drawTexture(tex,tex.bitmap.id,pos[ipos++]+tx,pos[ipos++]+ty,0,0,null,null,1.0,false);
		}
	}

	//TODO:coverage
	__proto._drawTextureAddSubmit=function(imgid,tex){
		var submit=null;
		submit=SubmitTexture.create(this,this._mesh,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0));
		this._submits[this._submits._length++]=submit;
		submit.shaderValue.textureHost=tex;
		submit._key.other=imgid;
		submit._renderType=/*laya.webgl.submit.Submit.TYPE_TEXTURE*/10016;
		this._curSubmit=submit;
	}

	//shader.ALPHA=alphaBack;
	__proto._drawTextureM=function(tex,x,y,width,height,m,alpha,uv){
		if (!tex._getSource()){
			if (this.sprite){
				Laya.systemTimer.callLater(this,this._repaintSprite);
			}
			return false;
		}
		return this._inner_drawTexture(tex,tex.bitmap.id,x,y,width,height,m,uv,alpha,false);
	}

	__proto._drawRenderTexture=function(tex,x,y,width,height,m,alpha,uv){
		return this._inner_drawTexture(tex,-1,x,y,width,height,m,uv,1.0,false);
	}

	//TODO:coverage
	__proto.submitDebugger=function(){
		this._submits[this._submits._length++]=SubmitCMD.create([],function(){debugger;},this);
	}

	/*
	private function copyClipInfo(submit:Submit,clipInfo:Array):void {
		var cd:Array=submit.shaderValue.clipDir;
		cd[0]=clipInfo[2];cd[1]=clipInfo[3];cd[2]=clipInfo[4];cd[3]=clipInfo[5];
		var cp:Array=submit.shaderValue.clipRect;
		cp[0]=clipInfo[0];cp[1]=clipInfo[1];
		submit.clipInfoID=this._clipInfoID;
	}

	*/
	__proto._copyClipInfo=function(submit,clipInfo){
		var cm=submit.shaderValue.clipMatDir;
		cm[0]=clipInfo.a;cm[1]=clipInfo.b;cm[2]=clipInfo.c;cm[3]=clipInfo.d;
		var cmp=submit.shaderValue.clipMatPos;
		cmp[0]=clipInfo.tx;cmp[1]=clipInfo.ty;
		submit.clipInfoID=this._clipInfoID;
	}

	__proto.isSameClipInfo=function(submit){
		return (submit.clipInfoID===this._clipInfoID);
	}

	/**
	*这个还是会检查是否合并
	*@param tex
	*@param minVertNum
	*/
	__proto._useNewTex2DSubmit=function(tex,minVertNum){
		if (this._mesh.vertNum+minVertNum > 65535){
			this._mesh=MeshQuadTexture.getAMesh();
			this.meshlist.push(this._mesh);
		};
		var submit=SubmitTexture.create(this,this._mesh,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0));
		this._submits[this._submits._length++]=this._curSubmit=submit;
		submit.shaderValue.textureHost=tex;
		this._copyClipInfo(submit,this._globalClipMatrix);
	}

	/**
	*使用上面的设置（texture，submit，alpha，clip），画一个rect
	*/
	__proto._drawTexRect=function(x,y,w,h,uv){
		this.transformQuad(x,y,w,h,this._italicDeg,this._curMat,this._transedPoints);
		var ops=this._transedPoints;
		ops[0]=(ops[0]+0.5)| 0;
		ops[1]=(ops[1]+0.5)| 0;
		ops[2]=(ops[2]+0.5)| 0;
		ops[3]=(ops[3]+0.5)| 0;
		ops[4]=(ops[4]+0.5)| 0;
		ops[5]=(ops[5]+0.5)| 0;
		ops[6]=(ops[6]+0.5)| 0;
		ops[7]=(ops[7]+0.5)| 0;
		if (!this.clipedOff(this._transedPoints)){
			this._mesh.addQuad(this._transedPoints,uv ,this._fillColor,true);
			this._curSubmit._numEle+=6;
			this._mesh.indexNum+=6;
			this._mesh.vertNum+=4;
		}
	}

	__proto.drawCallOptimize=function(enbale){
		this._charSubmitCache.enable(enbale,this);
		return enbale;
	}

	/**
	*
	*@param tex {Texture | RenderTexture }
	*@param imgid 图片id用来比较合并的
	*@param x
	*@param y
	*@param width
	*@param height
	*@param m
	*@param alpha
	*@param uv
	*@return
	*/
	__proto._inner_drawTexture=function(tex,imgid,x,y,width,height,m,uv,alpha,lastRender){
		var preKey=this._curSubmit._key;
		uv=uv || /*__JS__ */tex._uv
		if (preKey.submitType===/*laya.webgl.submit.Submit.KEY_TRIANGLES*/4 && preKey.other===imgid){
			var tv=WebGLContext2D._drawTexToDrawTri_Vert;
			tv[0]=x;tv[1]=y;tv[2]=x+width,tv[3]=y,tv[4]=x+width,tv[5]=y+height,tv[6]=x,tv[7]=y+height;
			this._drawTriUseAbsMatrix=true;
			this.drawTriangles(tex,0,0,tv,(uv ),WebGLContext2D._drawTexToDrawTri_Index,m,alpha,null,'normal');
			this._drawTriUseAbsMatrix=false;
			return true;
		};
		var ops=lastRender?this._charSubmitCache.getPos():this._transedPoints;
		this.transformQuad(x,y,width || tex.width,height || tex.height,this._italicDeg,m || this._curMat,ops);
		if (this.drawTexAlign){
			ops[0]=(ops[0]+0.5)| 0;
			ops[1]=(ops[1]+0.5)| 0;
			ops[2]=(ops[2]+0.5)| 0;
			ops[3]=(ops[3]+0.5)| 0;
			ops[4]=(ops[4]+0.5)| 0;
			ops[5]=(ops[5]+0.5)| 0;
			ops[6]=(ops[6]+0.5)| 0;
			ops[7]=(ops[7]+0.5)| 0;
			this.drawTexAlign=false;
		};
		var rgba=this._mixRGBandAlpha(0xffffffff,this._shader2D.ALPHA *alpha);
		if (lastRender){
			this._charSubmitCache.add(this,tex,imgid,ops,uv ,rgba);
			return true;
		}
		this._drawCount++;
		var sameKey=imgid >=0 && preKey.submitType===/*laya.webgl.submit.Submit.KEY_DRAWTEXTURE*/2 && preKey.other===imgid;
		sameKey && (sameKey=sameKey&& this.isSameClipInfo(this._curSubmit));
		this._lastTex=tex;
		if (this._mesh.vertNum+4 > 65535){
			this._mesh=MeshQuadTexture.getAMesh();
			this.meshlist.push(this._mesh);
			sameKey=false;
		}
		if (!this.clipedOff(this._transedPoints)){
			this._mesh.addQuad(ops,uv ,rgba,true);
			if (!sameKey){
				var submit=SubmitTexture.create(this,this._mesh,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0));
				this._submits[this._submits._length++]=this._curSubmit=submit;
				submit.shaderValue.textureHost=tex;
				submit._key.other=imgid;
				this._copyClipInfo(submit,this._globalClipMatrix);
			}
			this._curSubmit._numEle+=6;
			this._mesh.indexNum+=6;
			this._mesh.vertNum+=4;
			return true;
		}
		return false;
	}

	/**
	*转换4个顶点。为了效率这个不做任何检查。需要调用者的配合。
	*@param a 输入。8个元素表示4个点
	*@param out 输出
	*/
	__proto.transform4Points=function(a,m,out){
		var tx=m.tx;
		var ty=m.ty;
		if (m._bTransform){
			out[0]=a[0] *m.a+a[1] *m.c+tx;out[1]=a[0] *m.b+a[1] *m.d+ty;
			out[2]=a[2] *m.a+a[3] *m.c+tx;out[3]=a[2] *m.b+a[3] *m.d+ty;
			out[4]=a[4] *m.a+a[5] *m.c+tx;out[5]=a[4] *m.b+a[5] *m.d+ty;
			out[6]=a[6] *m.a+a[7] *m.c+tx;out[7]=a[6] *m.b+a[7] *m.d+ty;
			}else {
			out[0]=a[0]+tx;out[1]=a[1]+ty;
			out[2]=a[2]+tx;out[3]=a[3]+ty;
			out[4]=a[4]+tx;out[5]=a[5]+ty;
			out[6]=a[6]+tx;out[7]=a[7]+ty;
		}
	}

	/**
	*pt所描述的多边形完全在clip外边，整个被裁掉了
	*@param pt
	*@return
	*/
	__proto.clipedOff=function(pt){
		if (this._clipRect.width <=0 || this._clipRect.height <=0)
			return true;
		return false;
	}

	/**
	*应用当前矩阵。把转换后的位置放到输出数组中。
	*@param x
	*@param y
	*@param w
	*@param h
	*@param italicDeg 倾斜角度，单位是度。0度无，目前是下面不动。以后要做成可调的
	*/
	__proto.transformQuad=function(x,y,w,h,italicDeg,m,out){
		var xoff=0;
		if (italicDeg !=0){
			xoff=Math.tan(italicDeg *Math.PI / 180)*h;
		};
		var maxx=x+w;var maxy=y+h;
		this._temp4Points[0]=x+xoff;this._temp4Points[1]=y;
		this._temp4Points[2]=maxx+xoff;this._temp4Points[3]=y;
		this._temp4Points[4]=maxx;this._temp4Points[5]=maxy;
		this._temp4Points[6]=x;this._temp4Points[7]=maxy;
		this.transform4Points(this._temp4Points,m,out);
	}

	__proto.pushRT=function(){
		this.addRenderObject(SubmitCMD.create(null,RenderTexture2D.pushRT,this));
	}

	__proto.popRT=function(){
		this.addRenderObject(SubmitCMD.create(null,RenderTexture2D.popRT,this));
		this.breakNextMerge();
	}

	//TODO:coverage
	__proto.useRT=function(rt){
		function _use (rt){
			if (!rt){
				throw 'error useRT'
				}else{
				rt.start();
				rt.clear(0,0,0,0);
			}
		}
		this.addRenderObject(SubmitCMD.create([rt],_use,this));
		this.breakNextMerge();
	}

	//TODO:coverage
	__proto.RTRestore=function(rt){
		function _restore (rt){
			rt.restore();
		}
		this.addRenderObject(SubmitCMD.create([rt],_restore,this));
		this.breakNextMerge();
	}

	/**
	*强制拒绝submit合并
	*例如切换rt的时候
	*/
	__proto.breakNextMerge=function(){
		this._curSubmit=Submit.RENDERBASE;
	}

	//TODO:coverage
	__proto._repaintSprite=function(){
		this.sprite && this.sprite.repaint();
	}

	/**
	*
	*@param tex
	*@param x
	*@param y
	*@param width
	*@param height
	*@param transform 图片本身希望的矩阵
	*@param tx 节点的位置
	*@param ty
	*@param alpha
	*/
	__proto.drawTextureWithTransform=function(tex,x,y,width,height,transform,tx,ty,alpha,blendMode,colorfilter){
		var oldcomp=null;
		if (blendMode){
			oldcomp=this.globalCompositeOperation;
			this.globalCompositeOperation=blendMode;
		};
		var oldColorFilter=this._colorFiler;
		if (colorfilter){
			this.setColorFilter(colorfilter);
		}
		if (!transform){
			this._drawTextureM(tex,x+tx,y+ty,width,height,null,alpha,null);
			if (blendMode){
				this.globalCompositeOperation=oldcomp;
			}
			if (colorfilter){
				this.setColorFilter(oldColorFilter);
			}
			return;
		};
		var curMat=this._curMat;
		WebGLContext2D._tmpMatrix.a=transform.a;WebGLContext2D._tmpMatrix.b=transform.b;WebGLContext2D._tmpMatrix.c=transform.c;WebGLContext2D._tmpMatrix.d=transform.d;WebGLContext2D._tmpMatrix.tx=transform.tx+tx;WebGLContext2D._tmpMatrix.ty=transform.ty+ty;
		WebGLContext2D._tmpMatrix._bTransform=transform._bTransform;
		if (transform && curMat._bTransform){
			Matrix.mul(WebGLContext2D._tmpMatrix,curMat,WebGLContext2D._tmpMatrix);
			transform=WebGLContext2D._tmpMatrix;
			transform._bTransform=true;
			}else {
			transform=WebGLContext2D._tmpMatrix;
		}
		this._drawTextureM(tex,x,y,width,height,transform,alpha,null);
		if (blendMode){
			this.globalCompositeOperation=oldcomp;
		}
		if (colorfilter){
			this.setColorFilter(oldColorFilter);
		}
	}

	/**
	**把ctx中的submits提交。结果渲染到target上
	*@param ctx
	*@param target
	*/
	__proto._flushToTarget=function(context,target){
		RenderState2D.worldScissorTest=false;
		WebGL.mainContext.disable(/*laya.webgl.WebGLContext.SCISSOR_TEST*/0x0C11);
		var preAlpha=RenderState2D.worldAlpha;
		var preMatrix4=RenderState2D.worldMatrix4;
		var preMatrix=RenderState2D.worldMatrix;
		var preShaderDefines=RenderState2D.worldShaderDefines;
		RenderState2D.worldMatrix=Matrix.EMPTY;
		RenderState2D.restoreTempArray();
		RenderState2D.worldMatrix4=RenderState2D.TEMPMAT4_ARRAY;
		RenderState2D.worldAlpha=1;
		BaseShader.activeShader=null;
		target.start();
		if(context._submits._length>0)
			target.clear(0,0,0,0);
		context._curSubmit=Submit.RENDERBASE;
		context.flush();
		context.clear();
		target.restore();
		context._curSubmit=Submit.RENDERBASE;
		BaseShader.activeShader=null;
		RenderState2D.worldAlpha=preAlpha;
		RenderState2D.worldMatrix4=preMatrix4;
		RenderState2D.worldMatrix=preMatrix;
	}

	//RenderState2D.worldShaderDefines=preShaderDefines;
	__proto.drawCanvas=function(canvas,x,y,width,height){
		var src=canvas.context;
		var submit;
		if (src._targets){
			if (src._submits._length > 0){
				submit=SubmitCMD.create([src,src._targets],this._flushToTarget,this);
				this._submits[this._submits._length++]=submit;
			}
			this._drawRenderTexture(src._targets,x,y,width,height,null,1.0,RenderTexture2D.flipyuv);
			this._curSubmit=Submit.RENDERBASE;
			}else {
			var canv=canvas;
			if (canv.touches){
				(canv.touches).forEach(function(v){v.touch();});
			}
			submit=SubmitCanvas.create(canvas,this._shader2D.ALPHA,this._shader2D.filters);
			this._submits[this._submits._length++]=submit;
			(submit)._key.clear();
			var mat=(submit)._matrix;
			this._curMat.copyTo(mat);
			var tx=mat.tx,ty=mat.ty;
			mat.tx=mat.ty=0;
			mat.transformPoint(Point.TEMP.setTo(x,y));
			mat.translate(Point.TEMP.x+tx,Point.TEMP.y+ty);
			Matrix.mul(canv.invMat,mat,mat);
			this._curSubmit=Submit.RENDERBASE;
		}
	}

	__proto.drawTarget=function(rt,x,y,width,height,m,shaderValue,uv,blend){
		(blend===void 0)&& (blend=-1);
		this._drawCount++;
		var rgba=this.mixRGBandAlpha(this._drawTextureUseColor?(this.fillStyle?this.fillStyle.toInt():0):0xffffffff);
		if (this._mesh.vertNum+4 > 65535){
			this._mesh=MeshQuadTexture.getAMesh();
			this.meshlist.push(this._mesh);
		}
		this.transformQuad(x,y,width,height,0,m || this._curMat,this._transedPoints);
		if(!this.clipedOff(this._transedPoints)){
			this._mesh.addQuad(this._transedPoints,uv || Texture.DEF_UV,0xffffffff,true);
			var submit=this._curSubmit=SubmitTarget.create(this,this._mesh,shaderValue,rt);
			submit.blendType=(blend==-1)?this._nBlendType:blend;
			this._copyClipInfo(submit,this._globalClipMatrix);
			submit._numEle=6;
			this._mesh.indexNum+=6;
			this._mesh.vertNum+=4;
			this._maxNumEle=Math.max(this._maxNumEle,submit._numEle);
			this._submits[this._submits._length++]=submit;
			this._curSubmit=Submit.RENDERBASE
			return true;
		}
		this._curSubmit=Submit.RENDERBASE
		return false;
	}

	__proto.drawTriangles=function(tex,x,y,vertices,uvs,indices,matrix,alpha,color,blendMode){
		if (!tex._getSource()){
			if (this.sprite){
				Laya.systemTimer.callLater(this,this._repaintSprite);
			}
			return;
		}
		this._drawCount++;
		var oldColorFilter=null;
		var needRestorFilter=false;
		if (color){
			oldColorFilter=this._colorFiler;
			this._colorFiler=color;
			this._curSubmit=Submit.RENDERBASE;
			needRestorFilter=oldColorFilter!=color;
		};
		var webGLImg=tex.bitmap;
		var preKey=this._curSubmit._key;
		var sameKey=preKey.submitType===/*laya.webgl.submit.Submit.KEY_TRIANGLES*/4 && preKey.other===webGLImg.id && preKey.blendShader==this._nBlendType;
		var rgba=this._mixRGBandAlpha(0xffffffff,this._shader2D.ALPHA *alpha);
		var vertNum=vertices.length / 2;
		var eleNum=indices.length;
		if (this._triangleMesh.vertNum+vertNum > 65535){
			this._triangleMesh=MeshTexture.getAMesh();
			this.meshlist.push(this._triangleMesh);
			sameKey=false;
		}
		if (!sameKey){
			var submit=this._curSubmit=SubmitTexture.create(this,this._triangleMesh,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0));
			submit.shaderValue.textureHost=tex;
			submit._renderType=/*laya.webgl.submit.Submit.TYPE_TEXTURE*/10016;
			submit._key.submitType=/*laya.webgl.submit.Submit.KEY_TRIANGLES*/4;
			submit._key.other=webGLImg.id;
			this._copyClipInfo(submit,this._globalClipMatrix);
			this._submits[this._submits._length++]=submit;
		}
		if (!matrix){
			WebGLContext2D._tmpMatrix.a=1;WebGLContext2D._tmpMatrix.b=0;WebGLContext2D._tmpMatrix.c=0;WebGLContext2D._tmpMatrix.d=1;WebGLContext2D._tmpMatrix.tx=x;WebGLContext2D._tmpMatrix.ty=y;
			}else {
			WebGLContext2D._tmpMatrix.a=matrix.a;WebGLContext2D._tmpMatrix.b=matrix.b;WebGLContext2D._tmpMatrix.c=matrix.c;WebGLContext2D._tmpMatrix.d=matrix.d;WebGLContext2D._tmpMatrix.tx=matrix.tx+x;WebGLContext2D._tmpMatrix.ty=matrix.ty+y;
		}
		if(!this._drawTriUseAbsMatrix){
			Matrix.mul(WebGLContext2D._tmpMatrix,this._curMat,WebGLContext2D._tmpMatrix);
		}
		this._triangleMesh.addData(vertices,uvs,indices,WebGLContext2D._tmpMatrix,rgba,this);
		this._curSubmit._numEle+=eleNum;
		this._maxNumEle=Math.max(this._maxNumEle,this._curSubmit._numEle);
		if (needRestorFilter){
			this._colorFiler=oldColorFilter;
			this._curSubmit=Submit.RENDERBASE;
		}
	}

	//return true;
	__proto.transform=function(a,b,c,d,tx,ty){
		SaveTransform.save(this);
		Matrix.mul(Matrix.TEMP.setTo(a,b,c,d,tx,ty),this._curMat,this._curMat);
		this._curMat._checkTransform();
	}

	//TODO:coverage
	__proto._transformByMatrix=function(matrix,tx,ty){
		matrix.setTranslate(tx,ty);
		Matrix.mul(matrix,this._curMat,this._curMat);
		matrix.setTranslate(0,0);
		this._curMat._bTransform=true;
	}

	//TODO:coverage
	__proto.setTransformByMatrix=function(value){
		value.copyTo(this._curMat);
	}

	__proto.rotate=function(angle){
		SaveTransform.save(this);
		this._curMat.rotateEx(angle);
	}

	__proto.scale=function(scaleX,scaleY){
		SaveTransform.save(this);
		this._curMat.scaleEx(scaleX,scaleY);
	}

	__proto.clipRect=function(x,y,width,height){
		SaveClipRect.save(this);
		if (this._clipRect==WebGLContext2D.MAXCLIPRECT){
			this._clipRect=new Rectangle(x,y,width,height);
			}else {
			this._clipRect.width=width;
			this._clipRect.height=height;
			this._clipRect.x=x;
			this._clipRect.y=y;
		}
		WebGLContext2D._clipID_Gen++;
		WebGLContext2D._clipID_Gen %=10000;
		this._clipInfoID=WebGLContext2D._clipID_Gen;
		var cm=this._globalClipMatrix;
		var minx=cm.tx;
		var miny=cm.ty;
		var maxx=minx+cm.a;
		var maxy=miny+cm.d;
		if (this._clipRect.width >=/*CLASS CONST:laya.webgl.canvas.WebGLContext2D._MAXSIZE*/99999999){
			cm.a=cm.d=/*CLASS CONST:laya.webgl.canvas.WebGLContext2D._MAXSIZE*/99999999;
			cm.b=cm.c=cm.tx=cm.ty=0;
			}else {
			if (this._curMat._bTransform){
				cm.tx=this._clipRect.x *this._curMat.a+this._clipRect.y *this._curMat.c+this._curMat.tx;
				cm.ty=this._clipRect.x *this._curMat.b+this._clipRect.y *this._curMat.d+this._curMat.ty;
				cm.a=this._clipRect.width *this._curMat.a;
				cm.b=this._clipRect.width *this._curMat.b;
				cm.c=this._clipRect.height *this._curMat.c;
				cm.d=this._clipRect.height *this._curMat.d;
				}else {
				cm.tx=this._clipRect.x+this._curMat.tx;
				cm.ty=this._clipRect.y+this._curMat.ty;
				cm.a=this._clipRect.width;
				cm.b=cm.c=0;
				cm.d=this._clipRect.height;
			}
		}
		if (cm.a > 0 && cm.d > 0){
			var cmaxx=cm.tx+cm.a;
			var cmaxy=cm.ty+cm.d;
			if (cmaxx <=minx ||cmaxy<=miny || cm.tx>=maxx || cm.ty>=maxy){
				cm.a=-0.1;cm.d=-0.1;
				}else{
				if (cm.tx < minx){
					cm.a-=(minx-cm.tx);
					cm.tx=minx;
				}
				if (cmaxx > maxx){
					cm.a-=(cmaxx-maxx);
				}
				if (cm.ty < miny){
					cm.d-=(miny-cm.ty);
					cm.ty=miny;
				}
				if (cmaxy > maxy){
					cm.d-=(cmaxy-maxy);
				}
				if (cm.a <=0)cm.a=-0.1;
				if (cm.d <=0)cm.d=-0.1;
			}
		}
	}

	//TODO:coverage
	__proto.drawMesh=function(x,y,ib,vb,numElement,mat,shader,shaderValues,startIndex){
		(startIndex===void 0)&& (startIndex=0);
		;
	}

	__proto.addRenderObject=function(o){
		this._submits[this._submits._length++]=o;
	}

	/**
	*
	*@param start
	*@param end
	*/
	__proto.submitElement=function(start,end){
		var mainCtx=Render._context===this;
		var renderList=this._submits;
		var ret=(renderList)._length;
		end < 0 && (end=(renderList)._length);
		var submit=Submit.RENDERBASE;
		while (start < end){
			this._renderNextSubmitIndex=start+1;
			if (renderList[start]===Submit.RENDERBASE){
				start++;
				continue ;
			}
			Submit.preRender=submit;
			submit=renderList[start];
			start+=submit.renderSubmit();
		}
		return ret;
	}

	__proto.flush=function(){
		var ret=this.submitElement(0,this._submits._length);
		this._path && this._path.reset();
		SkinMeshBuffer.instance && SkinMeshBuffer.getInstance().reset();
		this._curSubmit=Submit.RENDERBASE;
		for (var i=0,sz=this.meshlist.length;i < sz;i++){
			var curm=this.meshlist[i];
			curm.canReuse?(curm.releaseMesh()):(curm.destroy());
		}
		this.meshlist.length=0;
		this._mesh=MeshQuadTexture.getAMesh();
		this._pathMesh=MeshVG.getAMesh();
		this._triangleMesh=MeshTexture.getAMesh();
		this.meshlist.push(this._mesh,this._pathMesh,this._triangleMesh);
		this._flushCnt++;
		if (this._flushCnt % 60==0 && Render._context==this){
			var texRender=Laya['textRender'];
			if(texRender)
				texRender.GC(false);
		}
		return ret;
	}

	__proto.setPathId=function(id){
		this.mId=id;
		if (this.mId !=-1){
			this.mHaveKey=false;
			var tVGM=VectorGraphManager.getInstance();
			if (tVGM.shapeDic[this.mId]){
				this.mHaveKey=true;
			}
			this.mHaveLineKey=false;
			if (tVGM.shapeLineDic[this.mId]){
				this.mHaveLineKey=true;
			}
		}
	}

	__proto.beginPath=function(convex){
		(convex===void 0)&& (convex=false);
		var tPath=this._getPath();
		tPath.beginPath(convex);
	}

	__proto.closePath=function(){
		this._path.closePath();
	}

	/**
	*添加一个path。
	*@param points [x,y,x,y....] 这个会被保存下来，所以调用者需要注意复制。
	*@param close 是否闭合
	*@param convex 是否是凸多边形。convex的优先级是这个最大。fill的时候的次之。其实fill的时候不应该指定convex，因为可以多个path
	*@param dx 需要添加的平移。这个需要在应用矩阵之前应用。
	*@param dy
	*/
	__proto.addPath=function(points,close,convex,dx,dy){
		var ci=0;
		for (var i=0,sz=points.length / 2;i < sz;i++){
			var x1=points[ci]+dx,y1=points[ci+1]+dy;
			points[ci]=x1;
			points[ci+1]=y1;
			ci+=2;
		}
		this._getPath().push(points,convex);
	}

	__proto.fill=function(){
		var m=this._curMat;
		var tPath=this._getPath();
		var submit=this._curSubmit;
		var sameKey=(submit._key.submitType===/*laya.webgl.submit.Submit.KEY_VG*/3 && submit._key.blendShader===this._nBlendType);
		sameKey && (sameKey=sameKey&&this.isSameClipInfo(submit));
		if (!sameKey){
			this._curSubmit=this.addVGSubmit(this._pathMesh);
		};
		var rgba=this.mixRGBandAlpha(this.fillStyle.toInt());
		var curEleNum=0;
		var idx;
		for (var i=0,sz=tPath.paths.length;i < sz;i++){
			var p=tPath.paths[i];
			var vertNum=p.path.length / 2;
			if (vertNum < 3 ||(vertNum==3 && !p.convex))
				continue ;
			var cpath=p.path.concat();
			var pi=0;
			var xp=0,yp=0;
			var _x=NaN,_y=NaN;
			if (m._bTransform){
				for (pi=0;pi < vertNum;pi++){
					xp=pi << 1;
					yp=xp+1;
					_x=cpath[xp];
					_y=cpath[yp];
					cpath[xp]=m.a *_x+m.c *_y+m.tx;
					cpath[yp]=m.b *_x+m.d *_y+m.ty;
				}
				}else {
				for (pi=0;pi < vertNum;pi++){
					xp=pi << 1;
					yp=xp+1;
					_x=cpath[xp];
					_y=cpath[yp];
					cpath[xp]=_x+m.tx;
					cpath[yp]=_y+m.ty;
				}
			}
			if (this._pathMesh.vertNum+vertNum > 65535){
				this._curSubmit._numEle+=curEleNum;
				curEleNum=0;
				this._pathMesh=MeshVG.getAMesh();
				this._curSubmit=this.addVGSubmit(this._pathMesh);
			};
			var curvert=this._pathMesh.vertNum;
			if (p.convex){
				var faceNum=vertNum-2;
				idx=new Array(faceNum *3);
				var idxpos=0;
				for (var fi=0;fi < faceNum;fi++){
					idx[idxpos++]=curvert;
					idx[idxpos++]=fi+1+curvert;
					idx[idxpos++]=fi+2+curvert;
				}
			}
			else {
				idx=Earcut.earcut(cpath,null,2);
				if (curvert > 0){
					for (var ii=0;ii < idx.length;ii++){
						idx[ii]+=curvert;
					}
				}
			}
			this._pathMesh.addVertAndIBToMesh(this,cpath,rgba,idx);
			curEleNum+=idx.length;
		}
		this._curSubmit._numEle+=curEleNum;
	}

	__proto.addVGSubmit=function(mesh){
		var submit=Submit.createShape(this,mesh,0,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.PRIMITIVE*/0x04,0));
		submit._key.submitType=/*laya.webgl.submit.Submit.KEY_VG*/3;
		this._submits[this._submits._length++]=submit;
		this._copyClipInfo(submit,this._globalClipMatrix);
		return submit;
	}

	__proto.stroke=function(){
		if (this.lineWidth > 0){
			var rgba=this.mixRGBandAlpha(this.strokeStyle._color.numColor);
			var tPath=this._getPath();
			var submit=this._curSubmit;
			var sameKey=(submit._key.submitType===/*laya.webgl.submit.Submit.KEY_VG*/3 && submit._key.blendShader===this._nBlendType);
			sameKey && (sameKey=sameKey&& this.isSameClipInfo(submit));
			if (!sameKey){
				this._curSubmit=this.addVGSubmit(this._pathMesh);
			};
			var curEleNum=0;
			for (var i=0,sz=tPath.paths.length;i < sz;i++){
				var p=tPath.paths[i];
				if (p.path.length <=0)
					continue ;
				var idx=[];
				var vertex=[];
				var maxVertexNum=p.path.length *2;
				if (maxVertexNum < 2)
					continue ;
				if (this._pathMesh.vertNum+maxVertexNum > 65535){
					this._curSubmit._numEle+=curEleNum;
					curEleNum=0;
					this._pathMesh=MeshVG.getAMesh();
					this.meshlist.push(this._pathMesh);
					this._curSubmit=this.addVGSubmit(this._pathMesh);
				}
				BasePoly.createLine2(p.path,idx,this.lineWidth,this._pathMesh.vertNum,vertex,p.loop);
				var ptnum=vertex.length / 2;
				var m=this._curMat;
				var pi=0;
				var xp=0,yp=0;
				var _x=NaN,_y=NaN;
				if (m._bTransform){
					for (pi=0;pi < ptnum;pi++){
						xp=pi << 1;
						yp=xp+1;
						_x=vertex[xp];
						_y=vertex[yp];
						vertex[xp]=m.a *_x+m.c *_y+m.tx;
						vertex[yp]=m.b *_x+m.d *_y+m.ty;
					}
					}else {
					for (pi=0;pi < ptnum;pi++){
						xp=pi << 1;
						yp=xp+1;
						_x=vertex[xp];
						_y=vertex[yp];
						vertex[xp]=_x+m.tx;
						vertex[yp]=_y+m.ty;
					}
				}
				this._pathMesh.addVertAndIBToMesh(this,vertex,rgba,idx);
				curEleNum+=idx.length;
			}
			this._curSubmit._numEle+=curEleNum;
		}
	}

	__proto.moveTo=function(x,y){
		var tPath=this._getPath();
		tPath.newPath();
		tPath._lastOriX=x;
		tPath._lastOriY=y;
		tPath.addPoint(x,y);
	}

	/**
	*
	*@param x
	*@param y
	*@param b 是否应用矩阵
	*/
	__proto.lineTo=function(x,y){
		var tPath=this._getPath();
		if (Math.abs(x-tPath._lastOriX)<1e-3 && Math.abs(y-tPath._lastOriY)<1e-3)
			return;
		tPath._lastOriX=x;
		tPath._lastOriY=y;
		tPath.addPoint(x,y);
	}

	/*
	override public function drawCurves(x:Number,y:Number,points:Array,lineColor:*,lineWidth:Number=1):void {
		//setPathId(-1);
		beginPath();
		strokeStyle=lineColor;
		this.lineWidth=lineWidth;
		var points:Array=points;
		//movePath(x,y);TODO 这个被去掉了
		moveTo(points[0],points[1]);
		var i:int=2,n:int=points.length;
		while (i < n){
			quadraticCurveTo(points[i++],points[i++],points[i++],points[i++]);
		}
		stroke();
	}

	*/
	__proto.arcTo=function(x1,y1,x2,y2,r){
		var i=0;
		var x=0,y=0;
		var dx=this._path._lastOriX-x1;
		var dy=this._path._lastOriY-y1;
		var len1=Math.sqrt(dx*dx+dy*dy);
		if (len1 <=0.000001){
			return;
		};
		var ndx=dx / len1;
		var ndy=dy / len1;
		var dx2=x2-x1;
		var dy2=y2-y1;
		var len22=dx2*dx2+dy2*dy2;
		var len2=Math.sqrt(len22);
		if (len2 <=0.000001){
			return;
		};
		var ndx2=dx2 / len2;
		var ndy2=dy2 / len2;
		var odx=ndx+ndx2;
		var ody=ndy+ndy2;
		var olen=Math.sqrt(odx*odx+ody*ody);
		if (olen <=0.000001){
			return;
		};
		var nOdx=odx / olen;
		var nOdy=ody / olen;
		var alpha=Math.acos(nOdx*ndx+nOdy*ndy);
		var halfAng=Math.PI / 2-alpha;
		len1=r / Math.tan(halfAng);
		var ptx1=len1*ndx+x1;
		var pty1=len1*ndy+y1;
		var orilen=Math.sqrt(len1 *len1+r *r);
		var orix=x1+nOdx*orilen;
		var oriy=y1+nOdy*orilen;
		var ptx2=len1*ndx2+x1;
		var pty2=len1*ndy2+y1;
		var dir=ndx *ndy2-ndy *ndx2;
		var fChgAng=0;
		var sinx=0.0;
		var cosx=0.0;
		if (dir >=0){
			fChgAng=halfAng *2;
			var fda=fChgAng / WebGLContext2D.SEGNUM;
			sinx=Math.sin(fda);
			cosx=Math.cos(fda);
		}
		else {
			fChgAng=-halfAng *2;
			fda=fChgAng / WebGLContext2D.SEGNUM;
			sinx=Math.sin(fda);
			cosx=Math.cos(fda);
		};
		var lastx=this._path._lastOriX,lasty=this._path._lastOriY;
		var _x1=ptx1 ,_y1=pty1;
		if (Math.abs(_x1-this._path._lastOriX)>0.1 || Math.abs(_y1-this._path._lastOriY)>0.1){
			x=_x1;
			y=_y1;
			lastx=_x1;
			lasty=_y1;
			this._path.addPoint(x,y);
		};
		var cvx=ptx1-orix;
		var cvy=pty1-oriy;
		var tx=0.0;
		var ty=0.0;
		for (i=0;i < WebGLContext2D.SEGNUM;i++){
			var cx=cvx*cosx+cvy*sinx;
			var cy=-cvx*sinx+cvy*cosx;
			x=cx+orix;
			y=cy+oriy;
			if (Math.abs(lastx-x)>0.1 || Math.abs(lasty-y)>0.1){
				this._path.addPoint(x,y);
				lastx=x;
				lasty=y;
			}
			cvx=cx;
			cvy=cy;
		}
	}

	__proto.arc=function(cx,cy,r,startAngle,endAngle,counterclockwise,b){
		(counterclockwise===void 0)&& (counterclockwise=false);
		(b===void 0)&& (b=true);
		var a=0,da=0,hda=0,kappa=0;
		var dx=0,dy=0,x=0,y=0,tanx=0,tany=0;
		var px=0,py=0,ptanx=0,ptany=0;
		var i=0,ndivs=0,nvals=0;
		da=endAngle-startAngle;
		if (!counterclockwise){
			if (Math.abs(da)>=Math.PI *2){
				da=Math.PI *2;
				}else {
				while (da < 0.0){
					da+=Math.PI *2;
				}
			}
			}else {
			if (Math.abs(da)>=Math.PI *2){
				da=-Math.PI *2;
				}else {
				while (da > 0.0){
					da-=Math.PI *2;
				}
			}
		};
		var sx=this.getMatScaleX();
		var sy=this.getMatScaleY();
		var sr=r *(sx > sy?sx:sy);
		var cl=2 *Math.PI *sr;
		ndivs=(Math.max(cl / 10,10))|0;
		hda=(da / ndivs)/ 2.0;
		kappa=Math.abs(4 / 3 *(1-Math.cos(hda))/ Math.sin(hda));
		if (counterclockwise)
			kappa=-kappa;
		nvals=0;
		var tPath=this._getPath();
		var _x1=NaN,_y1=NaN;
		for (i=0;i <=ndivs;i++){
			a=startAngle+da *(i / ndivs);
			dx=Math.cos(a);
			dy=Math.sin(a);
			x=cx+dx *r;
			y=cy+dy *r;
			if (x !=this._path._lastOriX || y !=this._path._lastOriY){
				tPath.addPoint(x,y);
			}
		}
		dx=Math.cos(endAngle);
		dy=Math.sin(endAngle);
		x=cx+dx *r;
		y=cy+dy *r;
		if (x !=this._path._lastOriX|| y !=this._path._lastOriY){
			tPath.addPoint(x,y);
		}
	}

	__proto.quadraticCurveTo=function(cpx,cpy,x,y){
		var tBezier=Bezier.I;
		var tResultArray=[];
		var tArray=tBezier.getBezierPoints([this._path._lastOriX,this._path._lastOriY,cpx,cpy,x,y],30,2);
		for (var i=0,n=tArray.length / 2;i < n;i++){
			this.lineTo(tArray[i *2],tArray[i *2+1]);
		}
		this.lineTo(x,y);
	}

	//TODO:coverage
	__proto.rect=function(x,y,width,height){
		this._other=this._other.make();
		this._other.path || (this._other.path=new Path());
		this._other.path.rect(x,y,width,height);
	}

	/**
	*把颜色跟当前设置的alpha混合
	*@return
	*/
	__proto.mixRGBandAlpha=function(color){
		return this._mixRGBandAlpha(color,this._shader2D.ALPHA);
	}

	__proto._mixRGBandAlpha=function(color,alpha){
		var a=((color & 0xff000000)>>> 24);
		if (a !=0){
			a*=alpha;
			}else {
			a=alpha*255;
		}
		return (color & 0x00ffffff)| (a << 24);
	}

	__proto.strokeRect=function(x,y,width,height,parameterLineWidth){
		var tW=parameterLineWidth *0.5;
		if (this.lineWidth > 0){
			var rgba=this.mixRGBandAlpha(this.strokeStyle._color.numColor);
			var hw=this.lineWidth / 2;
			this._fillRect(x-hw,y-hw,width+this.lineWidth,this.lineWidth,rgba);
			this._fillRect(x-hw,y-hw+height,width+this.lineWidth,this.lineWidth,rgba);
			this._fillRect(x-hw,y+hw,this.lineWidth,height-this.lineWidth,rgba);
			this._fillRect(x-hw+width,y+hw,this.lineWidth,height-this.lineWidth,rgba);
		}
	}

	//右
	__proto.clip=function(){}
	//TODO:coverage
	__proto.drawParticle=function(x,y,pt){
		pt.x=x;
		pt.y=y;
		this._submits[this._submits._length++]=pt;
	}

	__proto._getPath=function(){
		return this._path || (this._path=new Path());
	}

	/*,_shader2D.ALPHA=1*/
	__getset(0,__proto,'globalCompositeOperation',function(){
		return BlendMode.NAMES[this._nBlendType];
		},function(value){
		var n=BlendMode.TOINT[value];
		n==null || (this._nBlendType===n)|| (SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_GLOBALCOMPOSITEOPERATION*/0x10000,this,true),this._curSubmit=Submit.RENDERBASE,this._nBlendType=n);
	});

	__getset(0,__proto,'strokeStyle',function(){
		return this._shader2D.strokeStyle;
		},function(value){
		this._shader2D.strokeStyle.equal(value)|| (SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_STROKESTYLE*/0x200,this._shader2D,false),this._shader2D.strokeStyle=DrawStyle.create(value),this._submitKey.other=-this._shader2D.strokeStyle.toInt());
	});

	__getset(0,__proto,'globalAlpha',function(){
		return this._shader2D.ALPHA;
		},function(value){
		value=Math.floor(value *1000)/ 1000;
		if (value !=this._shader2D.ALPHA){
			SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_ALPHA*/0x1,this._shader2D,false);
			this._shader2D.ALPHA=value;
		}
	});

	/**
	*当前canvas请求保存渲染结果。
	*实现：
	*如果value==true，就要给_target赋值
	*@param value {Boolean}
	*/
	__getset(0,__proto,'asBitmap',null,function(value){
		if (value){
			this._targets || (this._targets=new RenderTexture2D(this._width,this._height,/*laya.webgl.resource.BaseTexture.FORMAT_R8G8B8A8*/1,-1));
			if (!this._width || !this._height)
				throw Error("asBitmap no size!");
			}else {
			this._targets && this._targets.destroy();
			this._targets=null;
		}
	});

	__getset(0,__proto,'fillStyle',function(){
		return this._shader2D.fillStyle;
		},function(value){
		if (!this._shader2D.fillStyle.equal(value)){
			SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_FILESTYLE*/0x2,this._shader2D,false);
			this._shader2D.fillStyle=DrawStyle.create(value);
			this._submitKey.other=-this._shader2D.fillStyle.toInt();
		}
	});

	__getset(0,__proto,'textAlign',function(){
		return this._other.textAlign;
		},function(value){
		(this._other.textAlign===value)|| (this._other=this._other.make(),SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_TEXTALIGN*/0x8000,this._other,false),this._other.textAlign=value);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._other.lineWidth;
		},function(value){
		(this._other.lineWidth===value)|| (this._other=this._other.make(),SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_LINEWIDTH*/0x100,this._other,false),this._other.lineWidth=value);
	});

	__getset(0,__proto,'textBaseline',function(){
		return this._other.textBaseline;
		},function(value){
		(this._other.textBaseline===value)|| (this._other=this._other.make(),SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_TEXTBASELINE*/0x4000,this._other,false),this._other.textBaseline=value);
	});

	__getset(0,__proto,'font',null,function(str){
		this._other=this._other.make();
		SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_FONT*/0x8,this._other,false);
	});

	//注意这个是对外接口
	__getset(0,__proto,'canvas',function(){
		return this._canvas;
	});

	WebGLContext2D.__init__=function(){
		ContextParams.DEFAULT=new ContextParams();
		WebGLCacheAsNormalCanvas;
	}

	WebGLContext2D.set2DRenderConfig=function(){
		var gl=LayaGL.instance;
		WebGLContext.setBlend(gl,true);
		WebGLContext.setBlendFunc(gl,/*laya.webgl.WebGLContext.ONE*/1,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303);
		WebGLContext.setDepthTest(gl,false);
		WebGLContext.setCullFace(gl,false);
		WebGLContext.setDepthMask(gl,true);
		WebGLContext.setFrontFace(gl,/*laya.webgl.WebGLContext.CCW*/0x0901);
		gl.viewport(0,0,RenderState2D.width,RenderState2D.height);
	}

	WebGLContext2D._tempPoint=new Point();
	WebGLContext2D._SUBMITVBSIZE=32000;
	WebGLContext2D._MAXSIZE=99999999;
	WebGLContext2D._MAXVERTNUM=65535;
	WebGLContext2D.MAXCLIPRECT=new Rectangle(0,0,99999999,99999999);
	WebGLContext2D._COUNT=0;
	WebGLContext2D._tmpMatrix=new Matrix();
	WebGLContext2D.SEGNUM=32;
	WebGLContext2D._contextcount=0;
	WebGLContext2D._clipID_Gen=0;
	WebGLContext2D.defTexture=null;
	__static(WebGLContext2D,
	['_drawStyleTemp',function(){return this._drawStyleTemp=new DrawStyle(null);},'_keyMap',function(){return this._keyMap=new StringKey();},'_drawTexToDrawTri_Vert',function(){return this._drawTexToDrawTri_Vert=new Float32Array(8);},'_drawTexToDrawTri_Index',function(){return this._drawTexToDrawTri_Index=new Uint16Array([0,1,2,0,2,3]);},'_textRender',function(){return this._textRender=TextRender.useOldCharBook?new CharBook():(new TextRender());}
	]);
	WebGLContext2D.__init$=function(){
		/*下面的方式是有bug的。canvas是直接save，restore，现在是为了优化，但是有bug，所以先不重载了
		override public function saveTransform(matrix:Matrix):void {
			this._curMat.copyTo(matrix);
		}
		override public function restoreTransform(matrix:Matrix):void {
			matrix.copyTo(this._curMat);
		}
		override public function transformByMatrix(matrix:Matrix,tx:Number,ty:Number):void {
			var mat:Matrix=_curMat;
			matrix.setTranslate(tx,ty);
			Matrix.mul(matrix,mat,mat);
			matrix.setTranslate(0,0);
			mat._bTransform=true;
		}
		*/
		//class ContextParams
		ContextParams=(function(){
			function ContextParams(){
				this.lineWidth=1;
				this.path=null;
				this.textAlign=null;
				this.textBaseline=null;
			}
			__class(ContextParams,'');
			var __proto=ContextParams.prototype;
			__proto.clear=function(){
				this.lineWidth=1;
				this.path && this.path.clear();
				this.textAlign=this.textBaseline=null;
			}
			__proto.make=function(){
				return this===ContextParams.DEFAULT ? new ContextParams():this;
			}
			ContextParams.DEFAULT=null;
			return ContextParams;
		})()
	}

	return WebGLContext2D;
})(Context)


//class laya.webgl.shader.d2.skinAnishader.SkinSV extends laya.webgl.shader.d2.value.Value2D
var SkinSV=(function(_super){
	function SkinSV(type){
		this.texcoord=null;
		this.position=null;
		this.offsetX=300;
		this.offsetY=0;
		SkinSV.__super.call(this,/*laya.webgl.shader.d2.ShaderDefines2D.SKINMESH*/0x200,0);
		var _vlen=8 *CONST3D2D.BYTES_PE;
		this.position=[2,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,_vlen,0];
		this.texcoord=[2,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,_vlen,2 *CONST3D2D.BYTES_PE];
		this.color=[4,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,_vlen,4 *CONST3D2D.BYTES_PE];
	}

	__class(SkinSV,'laya.webgl.shader.d2.skinAnishader.SkinSV',_super);
	return SkinSV;
})(Value2D)


//class laya.webgl.shader.d2.value.TextureSV extends laya.webgl.shader.d2.value.Value2D
var TextureSV=(function(_super){
	function TextureSV(subID){
		this.u_colorMatrix=null;
		this.strength=0;
		this.blurInfo=null;
		this.colorMat=null;
		this.colorAlpha=null;
		(subID===void 0)&& (subID=0);
		TextureSV.__super.call(this,/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,subID);
		this._attribLocation=['posuv',0,'attribColor',1,'attribFlags',2];
	}

	__class(TextureSV,'laya.webgl.shader.d2.value.TextureSV',_super);
	var __proto=TextureSV.prototype;
	// ,'clipDir',3,'clipRect',4];
	__proto.clear=function(){
		this.texture=null;
		this.shader=null;
		this.defines._value=this.subID+(WebGL.shaderHighPrecision? /*laya.webgl.shader.d2.ShaderDefines2D.SHADERDEFINE_FSHIGHPRECISION*/0x400:0);
	}

	return TextureSV;
})(Value2D)


//class laya.webgl.shader.d2.value.PrimitiveSV extends laya.webgl.shader.d2.value.Value2D
var PrimitiveSV=(function(_super){
	function PrimitiveSV(args){
		PrimitiveSV.__super.call(this,/*laya.webgl.shader.d2.ShaderDefines2D.PRIMITIVE*/0x04,0);
		this._attribLocation=['position',0,'attribColor',1];
	}

	__class(PrimitiveSV,'laya.webgl.shader.d2.value.PrimitiveSV',_super);
	return PrimitiveSV;
})(Value2D)


/**
*drawImage，fillRect等会用到的简单的mesh。每次添加必然是一个四边形。
*/
//class laya.webgl.utils.MeshQuadTexture extends laya.webgl.utils.Mesh2D
var MeshQuadTexture=(function(_super){
	//private static var _num;
	function MeshQuadTexture(){
		MeshQuadTexture.__super.call(this,laya.webgl.utils.MeshQuadTexture.const_stride,4,4);
		this.canReuse=true;
		this.setAttributes(laya.webgl.utils.MeshQuadTexture._fixattriInfo);
		if(!laya.webgl.utils.MeshQuadTexture._fixib){
			this.createQuadIB(MeshQuadTexture._maxIB);
			laya.webgl.utils.MeshQuadTexture._fixib=this._ib;
			}else {
			this._ib=laya.webgl.utils.MeshQuadTexture._fixib;
			this._quadNum=MeshQuadTexture._maxIB;
		}
	}

	__class(MeshQuadTexture,'laya.webgl.utils.MeshQuadTexture',_super);
	var __proto=MeshQuadTexture.prototype;
	/**
	*把本对象放到回收池中，以便getMesh能用。
	*/
	__proto.releaseMesh=function(){
		this._vb.setByteLength(0);
		this.vertNum=0;
		this.indexNum=0;
		laya.webgl.utils.MeshQuadTexture._POOL.push(this);
	}

	__proto.destroy=function(){
		this._vb.destroy();
		this._vb.deleteBuffer();
	}

	/**
	*
	*@param pos
	*@param uv
	*@param color
	*@param clip ox,oy,xx,xy,yx,yy
	*@param useTex 是否使用贴图。false的话是给fillRect用的
	*/
	__proto.addQuad=function(pos,uv,color,useTex){
		var vb=this._vb;
		var vpos=(vb._byteLength >> 2);
		vb.setByteLength((vpos+laya.webgl.utils.MeshQuadTexture.const_stride)<<2);
		var vbdata=vb._floatArray32 || vb.getFloat32Array();
		var vbu32Arr=vb._uint32Array;
		var cpos=vpos;
		var useTexVal=useTex?0xff:0;
		vbdata[cpos++]=pos[0];vbdata[cpos++]=pos[1];vbdata[cpos++]=uv[0];vbdata[cpos++]=uv[1];vbu32Arr[cpos++]=color;vbu32Arr[cpos++]=useTexVal;
		vbdata[cpos++]=pos[2];vbdata[cpos++]=pos[3];vbdata[cpos++]=uv[2];vbdata[cpos++]=uv[3];vbu32Arr[cpos++]=color;vbu32Arr[cpos++]=useTexVal;
		vbdata[cpos++]=pos[4];vbdata[cpos++]=pos[5];vbdata[cpos++]=uv[4];vbdata[cpos++]=uv[5];vbu32Arr[cpos++]=color;vbu32Arr[cpos++]=useTexVal;
		vbdata[cpos++]=pos[6];vbdata[cpos++]=pos[7];vbdata[cpos++]=uv[6];vbdata[cpos++]=uv[7];vbu32Arr[cpos++]=color;vbu32Arr[cpos++]=useTexVal;
		vb._upload=true;
	}

	MeshQuadTexture.getAMesh=function(){
		if (laya.webgl.utils.MeshQuadTexture._POOL.length){
			return laya.webgl.utils.MeshQuadTexture._POOL.pop();
		}
		return new MeshQuadTexture();
	}

	MeshQuadTexture.const_stride=24;
	MeshQuadTexture._fixib=null;
	MeshQuadTexture._maxIB=16 *1024;
	MeshQuadTexture._POOL=[];
	__static(MeshQuadTexture,
	['_fixattriInfo',function(){return this._fixattriInfo=[
		/*laya.webgl.WebGLContext.FLOAT*/0x1406,4,0,
		/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,4,16,
		/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,4,20];}
	]);
	return MeshQuadTexture;
})(Mesh2D)


/**
*用来画矢量的mesh。顶点格式固定为 x,y,rgba
*/
//class laya.webgl.utils.MeshVG extends laya.webgl.utils.Mesh2D
var MeshVG=(function(_super){
	function MeshVG(){
		MeshVG.__super.call(this,laya.webgl.utils.MeshVG.const_stride,4,4);
		this.canReuse=true;
		this.setAttributes(laya.webgl.utils.MeshVG._fixattriInfo);
	}

	__class(MeshVG,'laya.webgl.utils.MeshVG',_super);
	var __proto=MeshVG.prototype;
	/**
	*往矢量mesh中添加顶点和index。会把rgba和points在mesh中合并。
	*@param points 顶点数组，只包含x,y。[x,y,x,y...]
	*@param rgba rgba颜色
	*@param ib index数组。
	*/
	__proto.addVertAndIBToMesh=function(ctx,points,rgba,ib){
		var startpos=this._vb.needSize(points.length / 2 *MeshVG.const_stride);
		var f32pos=startpos >> 2;
		var vbdata=this._vb._floatArray32 || this._vb.getFloat32Array();
		var vbu32Arr=this._vb._uint32Array;
		var ci=0;
		var sz=points.length / 2;
		for (var i=0;i < sz;i++){
			vbdata[f32pos++]=points[ci];vbdata[f32pos++]=points[ci+1];ci+=2;
			vbu32Arr[f32pos++]=rgba;
		}
		this._vb.setNeedUpload();
		this._ib.append(new Uint16Array(ib));
		this._ib.setNeedUpload();
		this.vertNum+=sz;
		this.indexNum+=ib.length;
	}

	/**
	*把本对象放到回收池中，以便getMesh能用。
	*/
	__proto.releaseMesh=function(){
		this._vb.setByteLength(0);
		this._ib.setByteLength(0);
		this.vertNum=0;
		this.indexNum=0;
		laya.webgl.utils.MeshVG._POOL.push(this);
	}

	__proto.destroy=function(){
		this._ib.destroy();
		this._vb.destroy();
		this._ib.disposeResource();
		this._vb.deleteBuffer();
	}

	MeshVG.getAMesh=function(){
		if (laya.webgl.utils.MeshVG._POOL.length){
			return laya.webgl.utils.MeshVG._POOL.pop();
		}
		return new MeshVG();
	}

	MeshVG.const_stride=12;
	MeshVG._POOL=[];
	__static(MeshVG,
	['_fixattriInfo',function(){return this._fixattriInfo=[
		/*laya.webgl.WebGLContext.FLOAT*/0x1406,2,0,
		/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,4,8];}
	]);
	return MeshVG;
})(Mesh2D)


/**
*与MeshQuadTexture基本相同。不过index不是固定的
*/
//class laya.webgl.utils.MeshTexture extends laya.webgl.utils.Mesh2D
var MeshTexture=(function(_super){
	function MeshTexture(){
		MeshTexture.__super.call(this,laya.webgl.utils.MeshTexture.const_stride,4,4);
		this.canReuse=true;
		this.setAttributes(laya.webgl.utils.MeshTexture._fixattriInfo);
	}

	__class(MeshTexture,'laya.webgl.utils.MeshTexture',_super);
	var __proto=MeshTexture.prototype;
	__proto.addData=function(vertices,uvs,idx,matrix,rgba,ctx){
		var vertsz=vertices.length / 2;
		var startpos=this._vb.needSize(vertsz *MeshTexture.const_stride);
		var f32pos=startpos >> 2;
		var vbdata=this._vb._floatArray32 || this._vb.getFloat32Array();
		var vbu32Arr=this._vb._uint32Array;
		var ci=0;
		for (var i=0;i < vertsz;i++){
			var x=vertices[ci],y=vertices[ci+1];
			var x1=x *matrix.a+y *matrix.c+matrix.tx;
			var y1=x *matrix.b+y *matrix.d+matrix.ty;
			vbdata[f32pos++]=x1;vbdata[f32pos++]=y1;
			vbdata[f32pos++]=uvs[ci];vbdata[f32pos++]=uvs[ci+1];
			ci+=2;
			vbu32Arr[f32pos++]=rgba;
			vbu32Arr[f32pos++]=0xff;
		}
		this._vb.setNeedUpload();
		var vertN=this.vertNum;
		if (vertN > 0){
			var sz=idx.length;
			if (sz > MeshTexture.tmpIdx.length)MeshTexture.tmpIdx=new Uint16Array(sz);
			for (var ii=0;ii < sz;ii++){
				MeshTexture.tmpIdx[ii]=idx[ii]+vertN;
			}
			this._ib.appendU16Array(MeshTexture.tmpIdx,idx.length);
			}else {
			this._ib.append(idx);
		}
		this._ib.setNeedUpload();
		this.vertNum+=vertsz;
		this.indexNum+=idx.length;
	}

	/**
	*把本对象放到回收池中，以便getMesh能用。
	*/
	__proto.releaseMesh=function(){
		this._vb.setByteLength(0);
		this._ib.setByteLength(0);
		this.vertNum=0;
		this.indexNum=0;
		laya.webgl.utils.MeshTexture._POOL.push(this);
	}

	__proto.destroy=function(){
		this._ib.destroy();
		this._vb.destroy();
		this._ib.disposeResource();
		this._vb.deleteBuffer();
	}

	MeshTexture.getAMesh=function(){
		if (laya.webgl.utils.MeshTexture._POOL.length){
			return laya.webgl.utils.MeshTexture._POOL.pop();
		}
		return new MeshTexture();
	}

	MeshTexture.const_stride=24;
	MeshTexture._POOL=[];
	__static(MeshTexture,
	['_fixattriInfo',function(){return this._fixattriInfo=[
		/*laya.webgl.WebGLContext.FLOAT*/0x1406,4,0,
		/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,4,16,
		/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,4,20];},'tmpIdx',function(){return this.tmpIdx=new Uint16Array(4);}
	]);
	return MeshTexture;
})(Mesh2D)


//class laya.webgl.shader.d2.ShaderDefines2D extends laya.webgl.shader.ShaderDefinesBase
var ShaderDefines2D=(function(_super){
	function ShaderDefines2D(){
		ShaderDefines2D.__super.call(this,ShaderDefines2D.__name2int,ShaderDefines2D.__int2name,ShaderDefines2D.__int2nameMap);
	}

	__class(ShaderDefines2D,'laya.webgl.shader.d2.ShaderDefines2D',_super);
	ShaderDefines2D.__init__=function(){
		ShaderDefines2D.reg("TEXTURE2D",0x01);
		ShaderDefines2D.reg("PRIMITIVE",0x04);
		ShaderDefines2D.reg("GLOW_FILTER",0x08);
		ShaderDefines2D.reg("BLUR_FILTER",0x10);
		ShaderDefines2D.reg("COLOR_FILTER",0x20);
		ShaderDefines2D.reg("COLOR_ADD",0x40);
		ShaderDefines2D.reg("WORLDMAT",0x80);
		ShaderDefines2D.reg("FILLTEXTURE",0x100);
		ShaderDefines2D.reg("FSHIGHPRECISION",0x400);
		ShaderDefines2D.reg('MVP3D',0x800);
	}

	ShaderDefines2D.reg=function(name,value){
		ShaderDefinesBase._reg(name,value,ShaderDefines2D.__name2int,ShaderDefines2D.__int2name);
	}

	ShaderDefines2D.toText=function(value,int2name,int2nameMap){
		return ShaderDefinesBase._toText(value,int2name,int2nameMap);
	}

	ShaderDefines2D.toInt=function(names){
		return ShaderDefinesBase._toInt(names,ShaderDefines2D.__name2int);
	}

	ShaderDefines2D.TEXTURE2D=0x01;
	ShaderDefines2D.PRIMITIVE=0x04;
	ShaderDefines2D.FILTERGLOW=0x08;
	ShaderDefines2D.FILTERBLUR=0x10;
	ShaderDefines2D.FILTERCOLOR=0x20;
	ShaderDefines2D.COLORADD=0x40;
	ShaderDefines2D.WORLDMAT=0x80;
	ShaderDefines2D.FILLTEXTURE=0x100;
	ShaderDefines2D.SKINMESH=0x200;
	ShaderDefines2D.SHADERDEFINE_FSHIGHPRECISION=0x400;
	ShaderDefines2D.MVP3D=0x800;
	ShaderDefines2D.NOOPTMASK=0x08|0x10|0x20|0x100;
	ShaderDefines2D.__name2int={};
	ShaderDefines2D.__int2name=[];
	ShaderDefines2D.__int2nameMap=[];
	return ShaderDefines2D;
})(ShaderDefinesBase)


//class laya.webgl.resource.CharRender_Canvas extends laya.webgl.resource.ICharRender
var CharRender_Canvas=(function(_super){
	function CharRender_Canvas(maxw,maxh,scalefont,useImageData,showdbg){
		this.lastScaleX=1.0;
		this.lastScaleY=1.0;
		this.needResetScale=false;
		this.maxTexW=0;
		this.maxTexH=0;
		this.scaleFontSize=true;
		this.showDbgInfo=false;
		this.supportImageData=true;
		CharRender_Canvas.__super.call(this);
		(scalefont===void 0)&& (scalefont=true);
		(useImageData===void 0)&& (useImageData=true);
		(showdbg===void 0)&& (showdbg=false);
		this.maxTexW=maxw;
		this.maxTexH=maxh;
		this.scaleFontSize=scalefont;
		this.supportImageData=useImageData;
		this.showDbgInfo=showdbg;
		if (!CharRender_Canvas.canvas){
			CharRender_Canvas.canvas=window.document.createElement('canvas');
			CharRender_Canvas.canvas.width=1024;
			CharRender_Canvas.canvas.height=512;
			CharRender_Canvas.canvas.style.left="-10000px";
			CharRender_Canvas.canvas.style.position="absolute";
			/*__JS__ */document.body.appendChild(CharRender_Canvas.canvas);;
			CharRender_Canvas.ctx=CharRender_Canvas.canvas.getContext('2d');
		}
	}

	__class(CharRender_Canvas,'laya.webgl.resource.CharRender_Canvas',_super);
	var __proto=CharRender_Canvas.prototype;
	__proto.getWidth=function(font,str){
		if (!CharRender_Canvas.ctx)return 0;
		if(CharRender_Canvas.ctx._lastFont!=font){
			CharRender_Canvas.ctx.font=font;
			CharRender_Canvas.ctx._lastFont=font;
		}
		return CharRender_Canvas.ctx.measureText(str).width;
	}

	__proto.scale=function(sx,sy){
		if (!this.supportImageData){
			this.lastScaleX=sx;
			this.lastScaleY=sy;
			return;
		}
		if (this.lastScaleX !=sx || this.lastScaleY !=sy){
			CharRender_Canvas.ctx.setTransform(sx,0,0,sy,0,0);
			this.lastScaleX=sx;
			this.lastScaleY=sy;
		}
	}

	/**
	*TODO stroke
	*@param char
	*@param font
	*@param cri 修改里面的width。
	*@return
	*/
	__proto.getCharBmp=function(char,font,lineWidth,colStr,strokeColStr,cri,margin_left,margin_top,margin_right,margin_bottom,rect){
		if (!this.supportImageData)
			return this.getCharCanvas(char,font,lineWidth,colStr,strokeColStr,cri,margin_left,margin_top,margin_right,margin_bottom);
		if (CharRender_Canvas.ctx.font !=font){
			CharRender_Canvas.ctx.font=font;
			CharRender_Canvas.ctx._lastFont=font;
		}
		cri.width=CharRender_Canvas.ctx.measureText(char).width;
		var w=cri.width *this.lastScaleX;
		var h=cri.height*this.lastScaleY;
		w+=(margin_left+margin_right)*this.lastScaleX;
		h+=(margin_top+margin_bottom)*this.lastScaleY;
		w=Math.ceil(w);
		h=Math.ceil(h);
		w=Math.min(w,laya.webgl.resource.CharRender_Canvas.canvas.width);
		h=Math.min(h,laya.webgl.resource.CharRender_Canvas.canvas.height);
		var clearW=w+lineWidth *2+1;
		var clearH=h+lineWidth *2+1;
		if (rect){
			clearW=Math.max(clearW,rect[0]+rect[2]+1);
			clearH=Math.max(clearH,rect[1]+rect[3]+1);
		}
		CharRender_Canvas.ctx.clearRect(0,0,clearW,clearH);
		CharRender_Canvas.ctx.save();
		CharRender_Canvas.ctx.textBaseline="top";
		if (lineWidth > 0){
			CharRender_Canvas.ctx.strokeStyle=strokeColStr;
			CharRender_Canvas.ctx.lineWidth=lineWidth;
			CharRender_Canvas.ctx.strokeText(char,margin_left,margin_top);
		}
		CharRender_Canvas.ctx.fillStyle=colStr;
		CharRender_Canvas.ctx.fillText(char,margin_left,margin_top);
		if (this.showDbgInfo){
			CharRender_Canvas.ctx.strokeStyle='#ff0000';
			CharRender_Canvas.ctx.strokeRect(0,0,w,h);
			CharRender_Canvas.ctx.strokeStyle='#00ff00';
			CharRender_Canvas.ctx.strokeRect(margin_left,margin_top,cri.width,cri.height);
		}
		if (rect){
			if (rect[2]==-1)rect[2]=Math.ceil((cri.width+lineWidth)*this.lastScaleX);
		};
		var imgdt=rect?(CharRender_Canvas.ctx.getImageData(rect[0],rect[1],rect[2],rect[3])):(CharRender_Canvas.ctx.getImageData(0,0,w,h));
		CharRender_Canvas.ctx.restore();
		cri.bmpWidth=imgdt.width;
		cri.bmpHeight=imgdt.height;
		return imgdt;
	}

	__proto.getCharCanvas=function(char,font,lineWidth,colStr,strokeColStr,cri,margin_left,margin_top,margin_right,margin_bottom){
		if (CharRender_Canvas.ctx.font !=font){
			CharRender_Canvas.ctx.font=font;
			CharRender_Canvas.ctx._lastFont=font;
		}
		cri.width=CharRender_Canvas.ctx.measureText(char).width;
		var w=cri.width *this.lastScaleX;
		var h=cri.height*this.lastScaleY;
		w+=(margin_left+margin_right)*this.lastScaleX;
		h+=((margin_top+margin_bottom)*this.lastScaleY+1);
		w=Math.min(w,this.maxTexW);
		h=Math.min(h,this.maxTexH);
		CharRender_Canvas.canvas.width=Math.min(w+1,this.maxTexW);
		CharRender_Canvas.canvas.height=Math.min(h+1,this.maxTexH);
		CharRender_Canvas.ctx.font=font;
		CharRender_Canvas.ctx.clearRect(0,0,w+1+lineWidth,h+1+lineWidth);
		CharRender_Canvas.ctx.setTransform(1,0,0,1,0,0);
		CharRender_Canvas.ctx.save();
		if (this.scaleFontSize){
			CharRender_Canvas.ctx.scale(this.lastScaleX,this.lastScaleY);
		}
		CharRender_Canvas.ctx.translate(margin_left,margin_top);
		CharRender_Canvas.ctx.textAlign="left";
		CharRender_Canvas.ctx.textBaseline="top";
		if (lineWidth > 0){
			CharRender_Canvas.ctx.strokeStyle=strokeColStr;
			CharRender_Canvas.ctx.fillStyle=colStr;
			CharRender_Canvas.ctx.lineWidth=lineWidth;
			if (CharRender_Canvas.ctx.fillAndStrokeText){
				CharRender_Canvas.ctx.fillAndStrokeText(char,0,0);
				}else{
				CharRender_Canvas.ctx.strokeText(char,0,0);
				CharRender_Canvas.ctx.fillText(char,0,0);
			}
			}else {
			CharRender_Canvas.ctx.fillStyle=colStr;
			CharRender_Canvas.ctx.fillText(char,0,0);
		}
		if (this.showDbgInfo){
			CharRender_Canvas.ctx.strokeStyle='#ff0000';
			CharRender_Canvas.ctx.strokeRect(0,0,w,h);
			CharRender_Canvas.ctx.strokeStyle='#00ff00';
			CharRender_Canvas.ctx.strokeRect(0,0,cri.width,cri.height);
		}
		CharRender_Canvas.ctx.restore();
		cri.bmpWidth=CharRender_Canvas.canvas.width;
		cri.bmpHeight=CharRender_Canvas.canvas.height;
		return CharRender_Canvas.canvas;
	}

	__getset(0,__proto,'canvasWidth',function(){
		return CharRender_Canvas.canvas.width;
		},function(w){
		if (CharRender_Canvas.canvas.width==w)
			return;
		CharRender_Canvas.canvas.width=w;
		if (w > 2048){
			console.warn("画文字设置的宽度太大，超过2048了");
		}
		CharRender_Canvas.ctx.setTransform(1,0,0,1,0,0);
		CharRender_Canvas.ctx.scale(this.lastScaleX,this.lastScaleY);
	});

	CharRender_Canvas.canvas=null;
	CharRender_Canvas.ctx=null;
	return CharRender_Canvas;
})(ICharRender)


/**
*...
*@author ...
*/
//class laya.webgl.BufferState2D extends laya.webgl.BufferStateBase
var BufferState2D=(function(_super){
	function BufferState2D(){
		BufferState2D.__super.call(this);
	}

	__class(BufferState2D,'laya.webgl.BufferState2D',_super);
	return BufferState2D;
})(BufferStateBase)


//class laya.webgl.resource.CharRender_Native extends laya.webgl.resource.ICharRender
var CharRender_Native=(function(_super){
	function CharRender_Native(){
		this.lastFont='';
		CharRender_Native.__super.call(this);
	}

	__class(CharRender_Native,'laya.webgl.resource.CharRender_Native',_super);
	var __proto=CharRender_Native.prototype;
	//TODO:coverage
	__proto.getWidth=function(font,str){
		if (!window.conchTextCanvas)return 0;
		if (this.lastFont !=font){
			window.conchTextCanvas.font=font;
			this.lastFont=font;
		}
		return window.conchTextCanvas.measureText(str).width;
	}

	__proto.scale=function(sx,sy){}
	//TODO:coverage
	__proto.getCharBmp=function(char,font,lineWidth,colStr,strokeColStr,size,margin_left,margin_top,margin_right,margin_bottom,rect){
		if (!window.conchTextCanvas)return null;
		if(this.lastFont!=font){
			window.conchTextCanvas.font=font;
			this.lastFont=font;
		};
		var w=size.width=window.conchTextCanvas.measureText(char).width;
		var h=size.height;
		w+=(margin_left+margin_right);
		h+=(margin_top+margin_bottom);
		var c1=ColorUtils.create(strokeColStr);
		var nStrokeColor=c1.numColor;
		var c2=ColorUtils.create(colStr);
		var nTextColor=c2.numColor;
		var textInfo=window.conchTextCanvas.getTextBitmapData(char,nTextColor,lineWidth>2?2:lineWidth,nStrokeColor);
		size.bmpWidth=textInfo.width;
		size.bmpHeight=textInfo.height;
		return textInfo;
	}

	return CharRender_Native;
})(ICharRender)


/**
*cache as normal 模式下的生成的canvas的渲染。
*/
//class laya.webgl.submit.SubmitCanvas extends laya.webgl.submit.Submit
var SubmitCanvas=(function(_super){
	function SubmitCanvas(){
		//this.canv=null;
		this._matrix=new Matrix();
		this._matrix4=CONST3D2D.defaultMatrix4.concat();
		SubmitCanvas.__super.call(this,/*laya.webgl.submit.Submit.TYPE_2D*/10000);
		this.shaderValue=new Value2D(0,0);
	}

	__class(SubmitCanvas,'laya.webgl.submit.SubmitCanvas',_super);
	var __proto=SubmitCanvas.prototype;
	__proto.renderSubmit=function(){
		var preAlpha=RenderState2D.worldAlpha;
		var preMatrix4=RenderState2D.worldMatrix4;
		var preMatrix=RenderState2D.worldMatrix;
		var preFilters=RenderState2D.worldFilters;
		var preWorldShaderDefines=RenderState2D.worldShaderDefines;
		var v=this.shaderValue;
		var m=this._matrix;
		var m4=this._matrix4;
		var mout=Matrix.TEMP;
		Matrix.mul(m,preMatrix,mout);
		m4[0]=mout.a;
		m4[1]=mout.b;
		m4[4]=mout.c;
		m4[5]=mout.d;
		m4[12]=mout.tx;
		m4[13]=mout.ty;
		RenderState2D.worldMatrix=mout.clone();
		RenderState2D.worldMatrix4=m4;
		RenderState2D.worldAlpha=RenderState2D.worldAlpha *v.alpha;
		if (v.filters && v.filters.length){
			RenderState2D.worldFilters=v.filters;
			RenderState2D.worldShaderDefines=v.defines;
		}
		this.canv['flushsubmit']();
		RenderState2D.worldAlpha=preAlpha;
		RenderState2D.worldMatrix4=preMatrix4;
		RenderState2D.worldMatrix.destroy();
		RenderState2D.worldMatrix=preMatrix;
		RenderState2D.worldFilters=preFilters;
		RenderState2D.worldShaderDefines=preWorldShaderDefines;
		return 1;
	}

	__proto.releaseRender=function(){
		if((--this._ref)<1){
			var cache=SubmitCanvas.POOL;
			this._mesh=null;
			cache[cache._length++]=this;
		}
	}

	//TODO:coverage
	__proto.clone=function(context,mesh,pos){
		return null;
	}

	//TODO:coverage
	__proto.getRenderType=function(){
		return /*laya.webgl.submit.Submit.TYPE_CANVAS*/10003;
	}

	SubmitCanvas.create=function(canvas,alpha,filters){
		var o=(!SubmitCanvas.POOL._length)? (new SubmitCanvas()):SubmitCanvas.POOL[--SubmitCanvas.POOL._length];
		o.canv=canvas;
		o._ref=1;
		o._numEle=0;
		var v=o.shaderValue;
		v.alpha=alpha;
		v.defines.setValue(0);
		filters && filters.length && v.setFilters(filters);
		return o;
	}

	SubmitCanvas.POOL=(SubmitCanvas.POOL=[],SubmitCanvas.POOL._length=0,SubmitCanvas.POOL);
	return SubmitCanvas;
})(Submit)


/**
*drawImage，fillRect等会用到的简单的mesh。每次添加必然是一个四边形。
*/
//class laya.webgl.utils.MeshParticle2D extends laya.webgl.utils.Mesh2D
var MeshParticle2D=(function(_super){
	//TODO:coverage
	function MeshParticle2D(maxNum){
		MeshParticle2D.__super.call(this,laya.webgl.utils.MeshParticle2D.const_stride,maxNum*4*MeshParticle2D.const_stride,4);
		this.canReuse=true;
		this.setAttributes(laya.webgl.utils.MeshParticle2D._fixattriInfo);
		this.createQuadIB(maxNum);
		this._quadNum=maxNum;
	}

	__class(MeshParticle2D,'laya.webgl.utils.MeshParticle2D',_super);
	var __proto=MeshParticle2D.prototype;
	__proto.setMaxParticleNum=function(maxNum){
		this._vb._resizeBuffer(maxNum *4 *MeshParticle2D.const_stride,false);
		this.createQuadIB(maxNum);
	}

	//TODO:coverage
	__proto.releaseMesh=function(){
		debugger;
		this._vb.setByteLength(0);
		this.vertNum=0;
		this.indexNum=0;
		laya.webgl.utils.MeshParticle2D._POOL.push(this);
	}

	//TODO:coverage
	__proto.destroy=function(){
		this._ib.destroy();
		this._vb.destroy();
		this._vb.deleteBuffer();
	}

	MeshParticle2D.getAMesh=function(maxNum){
		if (laya.webgl.utils.MeshParticle2D._POOL.length){
			var ret=laya.webgl.utils.MeshParticle2D._POOL.pop();
			ret.setMaxParticleNum(maxNum);
			return ret;
		}
		return new MeshParticle2D(maxNum);
	}

	MeshParticle2D.const_stride=29*4;
	MeshParticle2D._POOL=[];
	__static(MeshParticle2D,
	['_fixattriInfo',function(){return this._fixattriInfo=[
		/*laya.webgl.WebGLContext.FLOAT*/0x1406,4,0,
		/*laya.webgl.WebGLContext.FLOAT*/0x1406,3,16,
		/*laya.webgl.WebGLContext.FLOAT*/0x1406,3,28,
		/*laya.webgl.WebGLContext.FLOAT*/0x1406,4,40,
		/*laya.webgl.WebGLContext.FLOAT*/0x1406,4,56,
		/*laya.webgl.WebGLContext.FLOAT*/0x1406,3,72,
		/*laya.webgl.WebGLContext.FLOAT*/0x1406,2,84,
		/*laya.webgl.WebGLContext.FLOAT*/0x1406,4,92,
		/*laya.webgl.WebGLContext.FLOAT*/0x1406,1,108,
		/*laya.webgl.WebGLContext.FLOAT*/0x1406,1,112];}
	]);
	return MeshParticle2D;
})(Mesh2D)


//class laya.webgl.utils.Buffer2D extends laya.webgl.utils.Buffer
var Buffer2D=(function(_super){
	function Buffer2D(){
		this._maxsize=0;
		this._upload=true;
		this._uploadSize=0;
		this._bufferSize=0;
		this._u8Array=null;
		Buffer2D.__super.call(this);
	}

	__class(Buffer2D,'laya.webgl.utils.Buffer2D',_super);
	var __proto=Buffer2D.prototype;
	__proto.setByteLength=function(value){
		if (this._byteLength!==value){
			value <=this._bufferSize || (this._resizeBuffer(value *2+256,true));
			this._byteLength=value;
		}
	}

	/**
	*在当前的基础上需要多大空间，单位是byte
	*@param sz
	*@return 增加大小之前的写位置。单位是byte
	*/
	__proto.needSize=function(sz){
		var old=this._byteLength;
		if (sz){
			var needsz=this._byteLength+sz;
			needsz <=this._bufferSize || (this._resizeBuffer(needsz << 1,true));
			this._byteLength=needsz;
		}
		return old;
	}

	__proto._bufferData=function(){
		this._maxsize=Math.max(this._maxsize,this._byteLength);
		if (Stat.loopCount % 30==0){
			if (this._buffer.byteLength > (this._maxsize+64)){
				this._buffer=this._buffer.slice(0,this._maxsize+64);
				this._bufferSize=this._buffer.byteLength;
				this._checkArrayUse();
			}
			this._maxsize=this._byteLength;
		}
		if (this._uploadSize < this._buffer.byteLength){
			this._uploadSize=this._buffer.byteLength;
			LayaGL.instance.bufferData(this._bufferType,this._uploadSize,this._bufferUsage);
		}
		LayaGL.instance.bufferSubData(this._bufferType,0,this._buffer);
	}

	//TODO:coverage
	__proto._bufferSubData=function(offset,dataStart,dataLength){
		(offset===void 0)&& (offset=0);
		(dataStart===void 0)&& (dataStart=0);
		(dataLength===void 0)&& (dataLength=0);
		this._maxsize=Math.max(this._maxsize,this._byteLength);
		if (Stat.loopCount % 30==0){
			if (this._buffer.byteLength > (this._maxsize+64)){
				this._buffer=this._buffer.slice(0,this._maxsize+64);
				this._bufferSize=this._buffer.byteLength;
				this._checkArrayUse();
			}
			this._maxsize=this._byteLength;
		}
		if (this._uploadSize < this._buffer.byteLength){
			this._uploadSize=this._buffer.byteLength;
			LayaGL.instance.bufferData(this._bufferType,this._uploadSize,this._bufferUsage);
		}
		if (dataStart || dataLength){
			var subBuffer=this._buffer.slice(dataStart,dataLength);
			LayaGL.instance.bufferSubData(this._bufferType,offset,subBuffer);
			}else {
			LayaGL.instance.bufferSubData(this._bufferType,offset,this._buffer);
		}
	}

	/**
	*buffer重新分配了，继承类根据需要做相应的处理。
	*/
	__proto._checkArrayUse=function(){}
	/**
	*给vao使用的 _bind_upload函数。不要与已经绑定的判断是否相同
	*@return
	*/
	__proto._bind_uploadForVAO=function(){
		if (!this._upload)
			return false;
		this._upload=false;
		this._bindForVAO();
		this._bufferData();
		return true;
	}

	__proto._bind_upload=function(){
		if (!this._upload)
			return false;
		this._upload=false;
		this.bind();
		this._bufferData();
		return true;
	}

	//TODO:coverage
	__proto._bind_subUpload=function(offset,dataStart,dataLength){
		(offset===void 0)&& (offset=0);
		(dataStart===void 0)&& (dataStart=0);
		(dataLength===void 0)&& (dataLength=0);
		if (!this._upload)
			return false;
		this._upload=false;
		this.bind();
		this._bufferSubData(offset,dataStart,dataLength);
		return true;
	}

	/**
	*重新分配buffer大小，如果nsz比原来的小则什么都不做。
	*@param nsz buffer大小，单位是byte。
	*@param copy 是否拷贝原来的buffer的数据。
	*@return
	*/
	__proto._resizeBuffer=function(nsz,copy){
		if (nsz < this._buffer.byteLength)
			return this;
		if (copy && this._buffer && this._buffer.byteLength > 0){
			var newbuffer=new ArrayBuffer(nsz);
			var oldU8Arr=(this._u8Array && this._u8Array.buffer==this._buffer)?this._u8Array :new Uint8Array(this._buffer);
			this._u8Array=new Uint8Array(newbuffer);
			this._u8Array.set(oldU8Arr,0);
			this._buffer=newbuffer;
			}else{
			this._buffer=new ArrayBuffer(nsz);
		}
		this._checkArrayUse();
		this._upload=true;
		this._bufferSize=this._buffer.byteLength;
		return this;
	}

	__proto.append=function(data){
		this._upload=true;
		var byteLen=0,n;
		byteLen=data.byteLength;
		if ((data instanceof Uint8Array)){
			this._resizeBuffer(this._byteLength+byteLen,true);
			n=new Uint8Array(this._buffer,this._byteLength);
			}else if ((data instanceof Uint16Array)){
			this._resizeBuffer(this._byteLength+byteLen,true);
			n=new Uint16Array(this._buffer,this._byteLength);
			}else if ((data instanceof Float32Array)){
			this._resizeBuffer(this._byteLength+byteLen,true);
			n=new Float32Array(this._buffer,this._byteLength);
		}
		n.set(data,0);
		this._byteLength+=byteLen;
		this._checkArrayUse();
	}

	//TODO:coverage
	__proto.appendU16Array=function(data,len){
		this._resizeBuffer(this._byteLength+len*2,true);
		var u=new Uint16Array(this._buffer,this._byteLength,len);
		for (var i=0;i < len;i++){
			u[i]=data[i];
		}
		this._byteLength+=len *2;
		this._checkArrayUse();
	}

	//TODO:coverage
	__proto.appendEx=function(data,type){
		this._upload=true;
		var byteLen=0,n;
		byteLen=data.byteLength;
		this._resizeBuffer(this._byteLength+byteLen,true);
		n=new type(this._buffer,this._byteLength);
		n.set(data,0);
		this._byteLength+=byteLen;
		this._checkArrayUse();
	}

	//TODO:coverage
	__proto.appendEx2=function(data,type,dataLen,perDataLen){
		(perDataLen===void 0)&& (perDataLen=1);
		this._upload=true;
		var byteLen=0,n;
		byteLen=dataLen*perDataLen;
		this._resizeBuffer(this._byteLength+byteLen,true);
		n=new type(this._buffer,this._byteLength);
		var i=0;
		for (i=0;i < dataLen;i++){
			n[i]=data[i];
		}
		this._byteLength+=byteLen;
		this._checkArrayUse();
	}

	//TODO:coverage
	__proto.getBuffer=function(){
		return this._buffer;
	}

	__proto.setNeedUpload=function(){
		this._upload=true;
	}

	//TODO:coverage
	__proto.getNeedUpload=function(){
		return this._upload;
	}

	//TODO:coverage
	__proto.upload=function(){
		var scuess=this._bind_upload();
		LayaGL.instance.bindBuffer(this._bufferType,null);
		if(this._bufferType==/*laya.webgl.WebGLContext.ARRAY_BUFFER*/0x8892)Buffer._bindedVertexBuffer=null;
		if(this._bufferType==/*laya.webgl.WebGLContext.ELEMENT_ARRAY_BUFFER*/0x8893)Buffer._bindedIndexBuffer=null;
		BaseShader.activeShader=null
		return scuess;
	}

	//TODO:coverage
	__proto.subUpload=function(offset,dataStart,dataLength){
		(offset===void 0)&& (offset=0);
		(dataStart===void 0)&& (dataStart=0);
		(dataLength===void 0)&& (dataLength=0);
		var scuess=this._bind_subUpload();
		LayaGL.instance.bindBuffer(this._bufferType,null);
		if(this._bufferType==/*laya.webgl.WebGLContext.ARRAY_BUFFER*/0x8892)Buffer._bindedVertexBuffer=null;
		if(this._bufferType==/*laya.webgl.WebGLContext.ELEMENT_ARRAY_BUFFER*/0x8893)Buffer._bindedIndexBuffer=null;
		BaseShader.activeShader=null
		return scuess;
	}

	__proto._disposeResource=function(){
		this._upload=true;
		this._uploadSize=0;
	}

	/**
	*清理数据。保留ArrayBuffer
	*/
	__proto.clear=function(){
		this._byteLength=0;
		this._upload=true;
	}

	//反正常常要拷贝老的数据，所以保留这个可以提高效率
	__getset(0,__proto,'bufferLength',function(){
		return this._buffer.byteLength;
	});

	__getset(0,__proto,'byteLength',null,function(value){
		this.setByteLength(value);
	});

	Buffer2D.__int__=function(gl){}
	Buffer2D.FLOAT32=4;
	Buffer2D.SHORT=2;
	return Buffer2D;
})(Buffer)


//class laya.webgl.submit.SubmitTexture extends laya.webgl.submit.Submit
var SubmitTexture=(function(_super){
	function SubmitTexture(renderType){
		(renderType===void 0)&& (renderType=10000);
		SubmitTexture.__super.call(this,renderType);
	}

	__class(SubmitTexture,'laya.webgl.submit.SubmitTexture',_super);
	var __proto=SubmitTexture.prototype;
	__proto.clone=function(context,mesh,pos){
		var o=SubmitTexture._poolSize ? SubmitTexture.POOL[--SubmitTexture._poolSize] :new SubmitTexture();
		this._cloneInit(o,context,mesh,pos);
		return o;
	}

	__proto.releaseRender=function(){
		if ((--this._ref)< 1){
			SubmitTexture.POOL[SubmitTexture._poolSize++]=this;
			this.shaderValue.release();
			this._mesh=null;
			this._parent && (this._parent.releaseRender(),this._parent=null);
		}
	}

	__proto.renderSubmit=function(){
		if (this._numEle===0)
			return 1;
		var tex=this.shaderValue.textureHost;
		if(tex){
			var source=tex?tex._getSource():null;
			if (!source)return 1;
		};
		var gl=WebGL.mainContext;
		this._mesh.useMesh(gl);
		var lastSubmit=Submit.preRender;
		var prekey=(Submit.preRender)._key;
		if (this._key.blendShader===0 && (this._key.submitType===prekey.submitType && this._key.blendShader===prekey.blendShader)&& BaseShader.activeShader &&
			(Submit.preRender).clipInfoID==this.clipInfoID &&
		lastSubmit.shaderValue.defines._value===this.shaderValue.defines._value &&
		(this.shaderValue.defines._value & ShaderDefines2D.NOOPTMASK)==0){
			(BaseShader.activeShader).uploadTexture2D(source);
		}
		else{
			if (BlendMode.activeBlendFunction!==this._blendFn){
				WebGLContext.setBlend(gl,true);
				this._blendFn(gl);
				BlendMode.activeBlendFunction=this._blendFn;
			}
			this.shaderValue.texture=source;
			this.shaderValue.upload();
		}
		gl.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,this._numEle,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,this._startIdx);
		Stat.renderBatch++;
		Stat.trianglesFaces+=this._numEle / 3;
		return 1;
	}

	SubmitTexture.create=function(context,mesh,sv){
		var o=SubmitTexture._poolSize ? SubmitTexture.POOL[--SubmitTexture._poolSize] :new SubmitTexture(/*laya.webgl.submit.Submit.TYPE_TEXTURE*/10016);
		o._mesh=mesh;
		o._key.clear();
		o._key.submitType=/*laya.webgl.submit.Submit.KEY_DRAWTEXTURE*/2;
		o._ref=1;
		o._startIdx=mesh.indexNum *CONST3D2D.BYTES_PIDX;
		o._numEle=0;
		var blendType=context._nBlendType;
		o._key.blendShader=blendType;
		o._blendFn=context._targets ? BlendMode.targetFns[blendType] :BlendMode.fns[blendType];
		o.shaderValue=sv;
		if (context._colorFiler){
			var ft=context._colorFiler;
			sv.defines.add(ft.type);
			(sv).colorMat=ft._mat;
			(sv).colorAlpha=ft._alpha;
		}
		return o;
	}

	SubmitTexture._poolSize=0;
	SubmitTexture.POOL=[];
	return SubmitTexture;
})(Submit)


/**
*...
*@author ...
*/
//class laya.webgl.shader.BaseShader extends laya.resource.Resource
var BaseShader=(function(_super){
	//当前绑定的shader
	function BaseShader(){
		BaseShader.__super.call(this);
	}

	__class(BaseShader,'laya.webgl.shader.BaseShader',_super);
	BaseShader.activeShader=null;
	BaseShader.bindShader=null;
	return BaseShader;
})(Resource)


//class laya.webgl.resource.CharPageTexture extends laya.resource.Resource
var CharPageTexture=(function(_super){
	function CharPageTexture(textureW,textureH,gridNum){
		//假装自己是一个Texture对象
		this.texture=null;
		this._source=null;
		//格子的使用状态。使用的为1
		this._used=null;
		this._startFindPos=0;
		//private var _mgr:CharPages;
		this._texW=0;
		this._texH=0;
		this._gridNum=0;
		/**
		*charMaps 最多有16个，表示在与basesize的距离。每个元素是一个Object,里面保存了具体的ChareRenderInfo信息，key是 str+color+bold
		*/
		this.charMaps=([]);
		//public var charMap:*={};//本页保存的文字信息
		this._score=0;
		//本帧使用的文字的个数
		this._scoreTick=0;
		//_score是哪一帧计算的
		this.__destroyed=false;
		//父类有，但是private
		this._discardTm=0;
		//释放的时间。超过一定时间会被真正删除
		this.genID=0;
		this.ArrCharRenderInfo=[];
		CharPageTexture.__super.call(this);
		this._texW=textureW;
		this._texH=textureH;
		this._gridNum=gridNum;
		this.texture=new CharInternalTexture(this);
		this.setGridNum(gridNum);
		this.lock=true;
	}

	__class(CharPageTexture,'laya.webgl.resource.CharPageTexture',_super);
	var __proto=CharPageTexture.prototype;
	/**
	*找一个空余的格子。
	*@return
	*/
	__proto.findAGrid=function(){
		for (var i=this._startFindPos;i < this._gridNum;i++){
			if (this._used[i]==0){
				this._startFindPos=i+1;
				this._used[i]=1;
				var ri=this.ArrCharRenderInfo[i]=new CharRenderInfo();
				ri.tex=this;
				ri.pos=i;
				return ri;
			}
		}
		return null;
	}

	//TODO:coverage
	__proto.removeGrid=function(pos){
		if(this.ArrCharRenderInfo[pos]){
			this.ArrCharRenderInfo[pos].deleted=true;
		}
		this._used[pos]=0;
		if (pos < this._startFindPos)
			this._startFindPos=pos;
	}

	//TODO:coverage
	__proto.removeOld=function(tm){
		var num=0;
		var charMap=null;
		for (var i=0,sz=this.charMaps.length;i < sz;i++){
			charMap=this.charMaps[i];
			if (!charMap)continue ;
			var me=this;
			charMap.forEach(function(v,k,m){
				if (v){
					if (v.touchTick < tm){
						console.log('remove char '+k);
						me.removeGrid(v.pos);
						/*__JS__ */m.delete(k);;
						num++;
					}
				}
			});
		}
		return num;
	}

	// _used 后面有人请求的时候再处理
	__proto.reset=function(){
		this._discardTm=Laya.stage.getFrameTm();
		this._startFindPos=0;
		this.charMaps=([]);
		this._score=0;
		this._scoreTick=0;
		this.__destroyed=true;
		this.ArrCharRenderInfo.forEach(function(v){v.deleted=true;});
	}

	__proto.setGridNum=function(gridNum){
		this._gridNum=gridNum;
		if (!this._used || this._used.length !=this._gridNum){
			this._used=new Uint8Array(gridNum);
			}else {
			if ((this._used).fill)(this._used).fill(0);
			else {
				for (var i=0;i < this._used.length;i++)this._used[i]=0;
			}
		}
	}

	__proto.recreateResource=function(){
		if (this._source)
			return;
		var gl=Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
		var glTex=this._source=gl.createTexture();
		this.texture.bitmap._glTexture=this._source;
		WebGLContext.bindTexture(gl,/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,glTex);
		gl.texImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,this._texW,this._texH,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,null);
		gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,/*laya.webgl.WebGLContext.LINEAR*/0x2601);
		gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,/*laya.webgl.WebGLContext.LINEAR*/0x2601);
		gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
		gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
	}

	/**
	*
	*@param data
	*@param x 拷贝位置。
	*@param y
	*/
	__proto.addChar=function(data,x,y){
		if (CharBook.isWan1Wan){
			this.addCharCanvas(data ,x,y);
			return;
		}
		!this._source && this.recreateResource();
		var gl=Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
		WebGLContext.bindTexture(gl,/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,this._source);
		!Render.isConchApp && gl.pixelStorei(/*laya.webgl.WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL*/0x9241,true);
		var dt=data.data;
		if (/*__JS__ */data.data instanceof Uint8ClampedArray)
			dt=new Uint8Array(dt.buffer);
		gl.texSubImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,x,y,data.width,data.height,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,dt);
		!Render.isConchApp && gl.pixelStorei(/*laya.webgl.WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL*/0x9241,false);
	}

	/**
	*玩一玩不支持 getImageData
	*@param canv
	*@param x
	*@param y
	*/
	__proto.addCharCanvas=function(canv,x,y){
		!this._source && this.recreateResource();
		var gl=Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
		WebGLContext.bindTexture(gl,/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,this._source);
		!Render.isConchApp && gl.pixelStorei(/*laya.webgl.WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL*/0x9241,true);
		gl.texSubImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,x,y,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,canv);
		!Render.isConchApp && gl.pixelStorei(/*laya.webgl.WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL*/0x9241,false);
	}

	//TODO:coverage
	__proto.destroy=function(){
		console.log('destroy CharPageTexture');
		this.__destroyed=true;
		var gl=Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
		this._source && gl.deleteTexture(this._source);
		this._source=null;
		this.ArrCharRenderInfo.forEach(function(v){v.deleted=true;});
	}

	__proto.touchRect=function(ri,curloop){
		if(this._scoreTick!=curloop){
			this._score=0;
			this._scoreTick=curloop;
		}
		this._score++;
	}

	/**
	*打印调试相关的关键信息
	*/
	__proto.printDebugInfo=function(detail){
		(detail===void 0)&& (detail=false);
		console.log('。得分:',this._score,', 算分时间:',this._scoreTick,',格子数:',this._gridNum);
		var gridw=Math.sqrt(this._gridNum);
		var num=0;
		for (var i=0,sz=this.charMaps.length;i < sz;i++){
			var charMap=this.charMaps[i];
			if (!charMap)continue ;
			var me=this;
			var data='';
			if (detail){
				console.log('   与基本大小差'+i+'的map信息:');
			}
			charMap.forEach(function(v,k,m){
				if (v){
					if (detail){
						console.log(
						'      key:',k,
						' 位置:',(v.pos / gridw)| 0,(v.pos % gridw)| 0,
						' 宽高:',v.bmpWidth,v.bmpHeight,
						' 是否删除:',v.deleted,
						' touch时间:',v.touchTick);
					}else
					data+=k;
				}
			});
			if(!detail)
				console.log('data[',i,']:',data);
		}
	}

	return CharPageTexture;
})(Resource)


/**
*...
*@author ww
*/
//class laya.layagl.ConchSpriteAdpt extends laya.display.Node
var ConchSpriteAdpt=(function(_super){
	function ConchSpriteAdpt(){
		//this._drawSimpleImageData=null;
		//this._drawCanvasParamData=null;
		//this._drawSimpleRectParamData=null;
		//this._drawRectBorderParamData=null;
		//this._canvasBeginCmd=null;
		//this._canvasEndCmd=null;
		this._customRenderCmd=null;
		this._customCmds=null;
		//this._callbackFuncObj=null;
		//this._filterBeginCmd=null;
		//this._filterEndCmd=null;
		//this._maskCmd=null;
		//this._dataf32=null;
		//this._datai32=null;
		/**@private */
		this._x=0;
		/**@private */
		this._y=0;
		/**@private */
		this._renderType=0;
		this._bRepaintCanvas=false;
		this._lastContext=null;
		ConchSpriteAdpt.__super.call(this);
	}

	__class(ConchSpriteAdpt,'laya.layagl.ConchSpriteAdpt',_super);
	var __proto=ConchSpriteAdpt.prototype;
	__proto.createData=function(){
		var nSize=/*laya.display.SpriteConst.POSSIZE*/77 *4;
		this._conchData=/*__JS__ */new ParamData(nSize,false);
		this._datai32=this._conchData._int32Data;
		this._dataf32=this._conchData._float32Data;
		this._dataf32[ /*laya.display.SpriteConst.POSREPAINT*/4]=1;
		this._datai32[ /*laya.display.SpriteConst.POSFRAMECOUNT*/3]=-1;
		this._datai32[ /*laya.display.SpriteConst.POSBUFFERBEGIN*/1]=0;
		this._datai32[ /*laya.display.SpriteConst.POSBUFFEREND*/2]=0;
		this._datai32[ /*laya.display.SpriteConst.POSCOLOR*/22]=0xFFFFFFFF;
		this._datai32[ /*laya.display.SpriteConst.POSVISIBLE_NATIVE*/5]=1;
		this._dataf32[ /*laya.display.SpriteConst.POSPIVOTX*/8]=0;
		this._dataf32[ /*laya.display.SpriteConst.POSPIVOTY*/9]=0;
		this._dataf32[ /*laya.display.SpriteConst.POSSCALEX*/10]=1;
		this._dataf32[ /*laya.display.SpriteConst.POSSCALEY*/11]=1;
		this._dataf32[ /*laya.display.SpriteConst.POSMATRIX*/16]=1;
		this._dataf32[ /*laya.display.SpriteConst.POSMATRIX*/16+1]=0;
		this._dataf32[ /*laya.display.SpriteConst.POSMATRIX*/16+2]=0;
		this._dataf32[ /*laya.display.SpriteConst.POSMATRIX*/16+3]=1;
		this._dataf32[ /*laya.display.SpriteConst.POSMATRIX*/16+4]=0;
		this._dataf32[ /*laya.display.SpriteConst.POSMATRIX*/16+5]=0;
		this._datai32[ /*laya.display.SpriteConst.POSSIM_TEXTURE_ID*/24]=-1;
		this._datai32[ /*laya.display.SpriteConst.POSSIM_TEXTURE_DATA*/25]=-1;
		this._datai32[ /*laya.display.SpriteConst.POSCUSTOM*/27]=-1;
		this._datai32[ /*laya.display.SpriteConst.POSCLIP*/28]=0;
		this._datai32[ /*laya.display.SpriteConst.POSCLIP*/28+1]=0;
		this._datai32[ /*laya.display.SpriteConst.POSCLIP*/28+2]=1000000;
		this._datai32[ /*laya.display.SpriteConst.POSCLIP*/28+3]=1000000;
		this._datai32[ /*laya.display.SpriteConst.POSCACHE_CANVAS_SKIP_PAINT_FLAG*/63]=0;
		this._datai32[ /*laya.display.SpriteConst.POSBLEND_SRC*/71]=/*laya.webgl.WebGLContext.ONE*/1;
		this._datai32[ /*laya.display.SpriteConst.POSBLEND_DEST*/72]=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
		this._datai32[ /*laya.display.SpriteConst.POSGRAPHICS_CALLBACK_FUN_ID*/68]=-1;
		this._renderType |=/*laya.display.SpriteConst.TRANSFORM*/0x02;
		this._setRenderType(this._renderType);
	}

	//TODO:coverage
	__proto._createTransform=function(){
		return MatrixConch.create(new Float32Array(6));
	}

	//TODO:coverage
	__proto._setTransform=function(value){
		var f32=this._conchData._float32Data;
		f32[ /*laya.display.SpriteConst.POSTRANSFORM_FLAG*/15]=0;
		f32[ /*laya.display.SpriteConst.POSMATRIX*/16]=value.a;
		f32[ /*laya.display.SpriteConst.POSMATRIX*/16+1]=value.b;
		f32[ /*laya.display.SpriteConst.POSMATRIX*/16+2]=value.c;
		f32[ /*laya.display.SpriteConst.POSMATRIX*/16+3]=value.d;
		f32[ /*laya.display.SpriteConst.POSMATRIX*/16+4]=value.tx;
		f32[ /*laya.display.SpriteConst.POSMATRIX*/16+5]=value.ty;
	}

	/**@private */
	__proto._setTranformChange=function(){
		(this)._tfChanged=true;
		(this).parentRepaint(/*laya.display.SpriteConst.REPAINT_CACHE*/0x02);
	}

	//TODO:coverage
	__proto._setGraphics=function(value){
		this._datai32[ /*laya.display.SpriteConst.POSGRAPICS*/23]=(value)._commandEncoder.getPtrID();
	}

	__proto._setGraphicsCallBack=function(){
		if (!this._callbackFuncObj){
			this._callbackFuncObj=/*__JS__ */new CallbackFuncObj();
		}
		this._datai32[ /*laya.display.SpriteConst.POSCALLBACK_OBJ_ID*/54]=this._callbackFuncObj.id;
		this._callbackFuncObj.addCallbackFunc(5,(this.updateParticleFromNative).bind(this));
		this._datai32[ /*laya.display.SpriteConst.POSGRAPHICS_CALLBACK_FUN_ID*/68]=5;
	}

	//TODO:coverage
	__proto._setCacheAs=function(value){
		DrawCanvasCmdNative.createCommandEncoder();
		if (!this._drawCanvasParamData){
			this._drawCanvasParamData=/*__JS__ */new ParamData(33 *4,true);
		}
		if (!this._callbackFuncObj){
			this._callbackFuncObj=/*__JS__ */new CallbackFuncObj();
		}
		if (!this._canvasBeginCmd){
			this._canvasBeginCmd=LayaGL.instance.createCommandEncoder(128,64,false);
		}
		if (!this._canvasEndCmd){
			this._canvasEndCmd=LayaGL.instance.createCommandEncoder(128,64,false);
		}
		this._datai32[ /*laya.display.SpriteConst.POSCALLBACK_OBJ_ID*/54]=this._callbackFuncObj.id;
		this._callbackFuncObj.addCallbackFunc(1,(this.canvasBeginRenderFromNative).bind(this));
		this._callbackFuncObj.addCallbackFunc(2,(this.canvasEndRenderFromNative).bind(this));
		this._datai32[ /*laya.display.SpriteConst.POSCANVAS_CALLBACK_FUN_ID*/56]=1;
		this._datai32[ /*laya.display.SpriteConst.POSCANVAS_CALLBACK_END_FUN_ID*/57]=2;
		this._datai32[ /*laya.display.SpriteConst.POSCANVAS_BEGIN_CMD_ID*/58]=this._canvasBeginCmd.getPtrID();
		this._datai32[ /*laya.display.SpriteConst.POSCANVAS_END_CMD_ID*/59]=this._canvasEndCmd.getPtrID();
		this._datai32[ /*laya.display.SpriteConst.POSCANVAS_DRAW_TARGET_CMD_ID*/60]=DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_.getPtrID();
		this._datai32[ /*laya.display.SpriteConst.POSCANVAS_DRAW_TARGET_PARAM_ID*/61]=this._drawCanvasParamData.getPtrID();
	}

	//TODO:coverage
	__proto._setX=function(value){
		this._x=this._dataf32[ /*laya.display.SpriteConst.POSX*/6]=value;
		this._dataf32[ /*laya.display.SpriteConst.POSTRANSFORM_FLAG*/15]=1.0;
	}

	//TODO:coverage
	__proto._setY=function(value){
		this._y=this._dataf32[ /*laya.display.SpriteConst.POSY*/7]=value;
		this._dataf32[ /*laya.display.SpriteConst.POSTRANSFORM_FLAG*/15]=1.0;
	}

	//TODO:coverage
	__proto._setWidth=function(texture,width){
		if (texture && texture.getIsReady()){
			this._setTextureEx(texture,true);
		}
	}

	//TODO:coverage
	__proto._setHeight=function(texture,height){
		if (texture && texture.getIsReady()){
			this._setTextureEx(texture,true);
		}
	}

	//TODO:coverage
	__proto._setPivotX=function(value){
		this._renderType |=/*laya.display.SpriteConst.TRANSFORM*/0x02;
		this._dataf32[ /*laya.display.SpriteConst.POSPIVOTX*/8]=value;
		this._dataf32[ /*laya.display.SpriteConst.POSTRANSFORM_FLAG*/15]=1.0;
	}

	//TODO:coverage
	__proto._getPivotX=function(){
		return this._dataf32[ /*laya.display.SpriteConst.POSPIVOTX*/8];
	}

	//TODO:coverage
	__proto._setPivotY=function(value){
		this._renderType |=/*laya.display.SpriteConst.TRANSFORM*/0x02;
		this._dataf32[ /*laya.display.SpriteConst.POSPIVOTY*/9]=value;
		this._dataf32[ /*laya.display.SpriteConst.POSTRANSFORM_FLAG*/15]=1.0;
	}

	//TODO:coverage
	__proto._getPivotY=function(){
		return this._dataf32[ /*laya.display.SpriteConst.POSPIVOTY*/9];
	}

	//TODO:coverage
	__proto._setAlpha=function(value){
		var style=/*__JS__ */this.getStyle();
		style.alpha=value;
		value=value > 1 ? 1 :value;
		value=value < 0 ? 0 :value;
		var nColor=this._datai32[ /*laya.display.SpriteConst.POSCOLOR*/22];
		var nAlpha=nColor >> 24;
		nAlpha=value *255;
		nColor=(nColor & 0xffffff)| nAlpha<<24;
		this._datai32[ /*laya.display.SpriteConst.POSCOLOR*/22]=nColor;
		if (value!==1)
			this._renderType |=/*laya.display.SpriteConst.ALPHA*/0x01;
		else
		this._renderType &=~ /*laya.display.SpriteConst.ALPHA*/0x01;
		this._setRenderType(this._renderType);
		this.parentRepaint();
	}

	//TODO:coverage
	__proto._setRenderType=function(type){
		this._datai32[ /*laya.display.SpriteConst.POSRENDERTYPE*/0]=type;
		if (!LayaGLTemplate.GLS[type]){
			LayaGLTemplate.createByRenderType(type);
			LayaGLTemplate.createByRenderTypeEnd(type);
		}
	}

	__proto.parentRepaint=function(){}
	__proto._getAlpha=function(){
		return (this._datai32[ /*laya.display.SpriteConst.POSCOLOR*/22]>>>24)/255;
	}

	__proto._setScaleX=function(value){
		(this)._style.scaleX=this._dataf32[ /*laya.display.SpriteConst.POSSCALEX*/10]=value;
		this._dataf32[ /*laya.display.SpriteConst.POSTRANSFORM_FLAG*/15]=1.0;
	}

	__proto._setScaleY=function(value){
		(this)._style.scaleY=this._dataf32[ /*laya.display.SpriteConst.POSSCALEY*/11]=value;
		this._dataf32[ /*laya.display.SpriteConst.POSTRANSFORM_FLAG*/15]=1.0;
	}

	__proto._setSkewX=function(value){
		(this)._style.skewX=this._dataf32[ /*laya.display.SpriteConst.POSSKEWX*/12]=value;
		this._dataf32[ /*laya.display.SpriteConst.POSTRANSFORM_FLAG*/15]=1.0;
	}

	__proto._setSkewY=function(value){
		(this)._style.skewY=this._dataf32[ /*laya.display.SpriteConst.POSSKEWY*/13]=value;
		this._dataf32[ /*laya.display.SpriteConst.POSTRANSFORM_FLAG*/15]=1.0;
	}

	__proto._setRotation=function(value){
		(this)._style.rotation=this._dataf32[ /*laya.display.SpriteConst.POSROTATION*/14]=value;
		this._dataf32[ /*laya.display.SpriteConst.POSTRANSFORM_FLAG*/15]=1.0;
	}

	__proto._setBgStyleColor=function(x,y,width,height,fillColor){
		var _fb=null;
		var _i32b=null;
		if (!this._drawSimpleRectParamData){
			this._drawSimpleRectParamData=/*__JS__ */new ParamData(26 *4,true);
		}
		_fb=this._drawSimpleRectParamData._float32Data;
		_i32b=this._drawSimpleRectParamData._int32Data;
		var c1=ColorUtils.create(fillColor);
		var nFillColor=c1.numColor;
		_i32b[0]=1;
		_i32b[1]=24 *4;
		var ix=2;
		_fb[ix++]=x;_fb[ix++]=y;_fb[ix++]=0;_fb[ix++]=0;_i32b[ix++]=nFillColor;_fb[ix++]=0xffffffff;
		_fb[ix++]=x+width;_fb[ix++]=y;_fb[ix++]=0;_fb[ix++]=0;_i32b[ix++]=nFillColor;_fb[ix++]=0xffffffff;
		_fb[ix++]=x+width;_fb[ix++]=y+height;_fb[ix++]=0;_fb[ix++]=0;_i32b[ix++]=nFillColor;_fb[ix++]=0xffffffff;
		_fb[ix++]=x;_fb[ix++]=y+height;_fb[ix++]=0;_fb[ix++]=0;_i32b[ix++]=nFillColor;_fb[ix++]=0xffffffff;
		this._datai32[ /*laya.display.SpriteConst.POSSIM_RECT_FILL_DATA*/74]=this._drawSimpleRectParamData.getPtrID();
		LayaGL.syncBufferToRenderThread(this._drawSimpleRectParamData);
		this._datai32[ /*laya.display.SpriteConst.POSSIM_RECT_FILL_CMD*/73]=LayaNative2D._SIMPLE_RECT_CMDENCODER_.getPtrID();
	}

	__proto._setBorderStyleColor=function(x,y,width,height,fillColor,borderWidth){
		var _fb=null;
		var _i32b=null;
		if (!this._drawRectBorderParamData){
			this._drawRectBorderParamData=/*__JS__ */new ParamData(59 *4,true);
		}
		_fb=this._drawRectBorderParamData._float32Data;
		_i32b=this._drawRectBorderParamData._int32Data;
		var _linePoints=[];
		var _line_ibArray=[];
		var _line_vbArray=[];
		_linePoints.push(x);_linePoints.push(y);
		_linePoints.push(x+width);_linePoints.push(y);
		_linePoints.push(x+width);_linePoints.push(y+height);
		_linePoints.push(x);_linePoints.push(y+height);
		_linePoints.push(x);_linePoints.push(y-borderWidth / 2)
		BasePoly.createLine2(_linePoints,_line_ibArray,borderWidth,0,_line_vbArray,false);
		var _line_vertNum=_linePoints.length;
		_fb=this._drawRectBorderParamData._float32Data;
		_i32b=this._drawRectBorderParamData._int32Data;
		var _i16b=this._drawRectBorderParamData._int16Data;
		var c1=ColorUtils.create(fillColor);
		var nLineColor=c1.numColor;
		_i32b[0]=0;
		_i32b[1]=30 *4;
		_i32b[2]=0;
		_i32b[3]=_line_ibArray.length *2;
		_i32b[4]=0;
		var ix=5;
		for (var i=0;i < _line_vertNum;i++){
			_fb[ix++]=_line_vbArray[i *2];_fb[ix++]=_line_vbArray[i *2+1];_i32b[ix++]=nLineColor;
		}
		ix=35 *2;
		for (var ii=0;ii < _line_ibArray.length;ii++){
			_i16b[ix++]=_line_ibArray[ii];
		}
		this._datai32[ /*laya.display.SpriteConst.POSSIM_RECT_STROKE_DATA*/76]=this._drawRectBorderParamData.getPtrID();
		LayaGL.syncBufferToRenderThread(this._drawRectBorderParamData);
		this._datai32[ /*laya.display.SpriteConst.POSSIM_RECT_STROKE_CMD*/75]=LayaNative2D._RECT_BORDER_CMD_ENCODER_.getPtrID();
	}

	__proto._setTextureEx=function(value,isloaded){
		var _fb=null;
		var _i32b=null;
		if (!this._drawSimpleImageData){
			this._drawSimpleImageData=/*__JS__ */new ParamData(29 *4,true);
			_fb=this._drawSimpleImageData._float32Data;
			_i32b=this._drawSimpleImageData._int32Data;
			_i32b[0]=3;
			_i32b[1]=/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0;
			_i32b[2]=isloaded?value.bitmap._glTexture.id:0;
			_i32b[3]=1;
			_i32b[4]=24 *4;
			var uv=value.uv;
			_fb[5]=0;_fb[6]=0;_fb[7]=uv[0];_fb[8]=uv[1];_i32b[9]=0xffffffff;_i32b[10]=0xffffffff;
			_fb[11]=0;_fb[12]=0;_fb[13]=uv[2];_fb[14]=uv[3];_i32b[15]=0xffffffff;_i32b[16]=0xffffffff;
			_fb[17]=0;_fb[18]=0;_fb[19]=uv[4];_fb[20]=uv[5];_i32b[21]=0xffffffff;_i32b[22]=0xffffffff;
			_fb[23]=0;_fb[24]=0;_fb[25]=uv[6];_fb[26]=uv[7];_i32b[27]=0xffffffff;_i32b[28]=0xffffffff;
		}
		_fb=this._drawSimpleImageData._float32Data;
		_i32b=this._drawSimpleImageData._int32Data;
		_i32b[2]=isloaded?value.bitmap._glTexture.id:0;
		var w=isloaded?value.width:0;
		var h=isloaded?value.height:0;
		var spW=(this)._width;
		var spH=(this)._height;
		w=spW > 0 ? spW :w;
		h=spH > 0 ? spH :h;
		_fb[11]=_fb[17]=w;
		_fb[18]=_fb[24]=h;
		var nPtrID=this._drawSimpleImageData.getPtrID();
		this._datai32[ /*laya.display.SpriteConst.POSSIM_TEXTURE_DATA*/25]=nPtrID;
		LayaGL.syncBufferToRenderThread(this._drawSimpleImageData);
		this._datai32[ /*laya.display.SpriteConst.POSSIM_TEXTURE_ID*/24]=LayaNative2D._SIMPLE_TEXTURE_CMDENCODER_.getPtrID();
	}

	//TODO:coverage
	__proto._setTexture=function(value){
		if (!value)return;
		if (value.getIsReady()){
			this._setTextureEx(value,true);
		}
		else{
			this._setTextureEx(value,false);
			value.on(/*laya.events.Event.READY*/"ready",this,this._setTextureEx,[value,true]);
		}
	}

	//TODO:coverage
	__proto._setCustomRender=function(){
		if (!this._callbackFuncObj){
			this._callbackFuncObj=/*__JS__ */new CallbackFuncObj();
		}
		this._customCmds=[];
		this._callbackFuncObj.addCallbackFunc(0,(this.customRenderFromNative).bind(this));
		this._customRenderCmd=LayaGL.instance.createCommandEncoder(128,64,true);
		this._datai32[ /*laya.display.SpriteConst.POSCALLBACK_OBJ_ID*/54]=this._callbackFuncObj.id;
		this._datai32[ /*laya.display.SpriteConst.POSCUSTOM_CALLBACK_FUN_ID*/55]=0;
		this._datai32[ /*laya.display.SpriteConst.POSCUSTOM*/27]=this._customRenderCmd.getPtrID();
	}

	//TODO:coverage
	__proto._setScrollRect=function(value){
		this._dataf32[ /*laya.display.SpriteConst.POSCLIP*/28]=0;
		this._dataf32[ /*laya.display.SpriteConst.POSCLIP*/28+1]=0;
		this._dataf32[ /*laya.display.SpriteConst.POSCLIP*/28+2]=value.width;
		this._dataf32[ /*laya.display.SpriteConst.POSCLIP*/28+3]=value.height;
		this._dataf32[ /*laya.display.SpriteConst.POSCLIP_NEG_POS*/32]=-value.x;
		this._dataf32[ /*laya.display.SpriteConst.POSCLIP_NEG_POS*/32+1]=-value.y;
		value["onPropertyChanged"]=(this._setScrollRect).bind(this);
	}

	//TODO:coverage
	__proto._setColorFilter=function(value){
		if (!this._callbackFuncObj){
			this._callbackFuncObj=/*__JS__ */new CallbackFuncObj();
		}
		if (!this._filterBeginCmd){
			this._filterBeginCmd=LayaGL.instance.createCommandEncoder(128,64,false);
		}
		if (!this._filterEndCmd){
			this._filterEndCmd=LayaGL.instance.createCommandEncoder(128,64,true);
		}
		this._datai32[ /*laya.display.SpriteConst.POSCALLBACK_OBJ_ID*/54]=this._callbackFuncObj.id;
		this._callbackFuncObj.addCallbackFunc(3,(this.filterBeginRenderFromNative).bind(this));
		this._callbackFuncObj.addCallbackFunc(4,(this.filterEndRenderFromNative).bind(this));
		this._datai32[ /*laya.display.SpriteConst.POSFILTER_CALLBACK_FUN_ID*/65]=3;
		this._datai32[ /*laya.display.SpriteConst.POSFILTER_BEGIN_CMD_ID*/64]=this._filterBeginCmd.getPtrID();
		this._datai32[ /*laya.display.SpriteConst.POSFILTER_END_CALLBACK_FUN_ID*/67]=4;
		this._datai32[ /*laya.display.SpriteConst.POSFILTER_END_CMD_ID*/66]=this._filterEndCmd.getPtrID();
	}

	__proto._setMask=function(value){
		value.cacheAs="bitmap";
		if (!this._callbackFuncObj){
			this._callbackFuncObj=/*__JS__ */new CallbackFuncObj();
		}
		if (!this._maskCmd){
			this._maskCmd=LayaGL.instance.createCommandEncoder(128,64,false);
		}
		this._datai32[ /*laya.display.SpriteConst.POSCALLBACK_OBJ_ID*/54]=this._callbackFuncObj.id;
		this._callbackFuncObj.addCallbackFunc(6,(this.maskRenderFromNative).bind(this));
		this._datai32[ /*laya.display.SpriteConst.POSMASK_CALLBACK_FUN_ID*/69]=6;
		this._datai32[ /*laya.display.SpriteConst.POSMASK_CMD_ID*/70]=this._maskCmd.getPtrID();
	}

	//TODO:coverage
	__proto._adjustTransform=function(){
		var m=(this)._transform || ((this)._transform=this._createTransform());
		m._bTransform=true;
		LayaGL.instance.calcMatrixFromScaleSkewRotation(this._conchData._data["_ptrID"],/*laya.display.SpriteConst.POSTRANSFORM_FLAG*/15*4,/*laya.display.SpriteConst.POSMATRIX*/16*4,/*laya.display.SpriteConst.POSX*/6*4,/*laya.display.SpriteConst.POSY*/7*4,/*laya.display.SpriteConst.POSPIVOTX*/8*4,
		/*laya.display.SpriteConst.POSPIVOTY*/9*4,/*laya.display.SpriteConst.POSSCALEX*/10*4,/*laya.display.SpriteConst.POSSCALEY*/11*4,/*laya.display.SpriteConst.POSSKEWX*/12*4,/*laya.display.SpriteConst.POSSKEWY*/13*4,/*laya.display.SpriteConst.POSROTATION*/14*4);
		var f32=this._conchData._float32Data;
		m.a=f32[ /*laya.display.SpriteConst.POSMATRIX*/16];
		m.b=f32[ /*laya.display.SpriteConst.POSMATRIX*/16+1];
		m.c=f32[ /*laya.display.SpriteConst.POSMATRIX*/16+2];
		m.d=f32[ /*laya.display.SpriteConst.POSMATRIX*/16+3];
		m.tx=0;
		m.ty=0;
		return m;
	}

	__proto._setBlendMode=function(value){
		switch(value){
			case /*laya.webgl.canvas.BlendMode.NORMAL*/"normal":
				this._datai32[ /*laya.display.SpriteConst.POSBLEND_SRC*/71]=/*laya.webgl.WebGLContext.ONE*/1;
				this._datai32[ /*laya.display.SpriteConst.POSBLEND_DEST*/72]=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
				break ;
			case /*laya.webgl.canvas.BlendMode.ADD*/"add":
			case /*laya.webgl.canvas.BlendMode.LIGHTER*/"lighter":
				this._datai32[ /*laya.display.SpriteConst.POSBLEND_SRC*/71]=/*laya.webgl.WebGLContext.ONE*/1;
				this._datai32[ /*laya.display.SpriteConst.POSBLEND_DEST*/72]=/*laya.webgl.WebGLContext.DST_ALPHA*/0x0304;
				break ;
			case /*laya.webgl.canvas.BlendMode.MULTIPLY*/"multiply":
				this._datai32[ /*laya.display.SpriteConst.POSBLEND_SRC*/71]=/*laya.webgl.WebGLContext.DST_COLOR*/0x0306;
				this._datai32[ /*laya.display.SpriteConst.POSBLEND_DEST*/72]=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303;
				break ;
			case /*laya.webgl.canvas.BlendMode.SCREEN*/"screen":
				this._datai32[ /*laya.display.SpriteConst.POSBLEND_SRC*/71]=/*laya.webgl.WebGLContext.ONE*/1;
				this._datai32[ /*laya.display.SpriteConst.POSBLEND_DEST*/72]=/*laya.webgl.WebGLContext.ONE*/1;
				break ;
			case /*laya.webgl.canvas.BlendMode.OVERLAY*/"overlay":
				this._datai32[ /*laya.display.SpriteConst.POSBLEND_SRC*/71]=/*laya.webgl.WebGLContext.ONE*/1;
				this._datai32[ /*laya.display.SpriteConst.POSBLEND_DEST*/72]=/*laya.webgl.WebGLContext.ONE_MINUS_SRC_COLOR*/0x0301;
				break ;
			case /*laya.webgl.canvas.BlendMode.LIGHT*/"light":
				this._datai32[ /*laya.display.SpriteConst.POSBLEND_SRC*/71]=/*laya.webgl.WebGLContext.ONE*/1;
				this._datai32[ /*laya.display.SpriteConst.POSBLEND_DEST*/72]=/*laya.webgl.WebGLContext.ONE*/1;
				break ;
			case /*laya.webgl.canvas.BlendMode.MASK*/"mask":
				this._datai32[ /*laya.display.SpriteConst.POSBLEND_SRC*/71]=/*laya.webgl.WebGLContext.ZERO*/0;
				this._datai32[ /*laya.display.SpriteConst.POSBLEND_DEST*/72]=/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302;
				break ;
			case /*laya.webgl.canvas.BlendMode.DESTINATIONOUT*/"destination-out":
				this._datai32[ /*laya.display.SpriteConst.POSBLEND_SRC*/71]=/*laya.webgl.WebGLContext.ZERO*/0;
				this._datai32[ /*laya.display.SpriteConst.POSBLEND_DEST*/72]=/*laya.webgl.WebGLContext.ZERO*/0;
				break ;
			default :
				alert("_setBlendMode Unknown type");
				break ;
			}
	}

	//TODO:coverage
	__proto.customRenderFromNative=function(){
		var context=LayaGL.instance.getCurrentContext();
		this._customRenderCmd.beginEncoding();
		this._customRenderCmd.clearEncoding();
		context["_commandEncoder"]=this._customRenderCmd;
		context["_customCmds"]=this._customCmds;
		for (var i=0,n=this._customCmds.length;i < n;i++){
			this._customCmds[i].recover();
		}
		this._customCmds.length=0;
		(this).customRender(context,0,0);
		this._customRenderCmd.endEncoding();
	}

	//TODO:coverage
	__proto.canvasBeginRenderFromNative=function(){
		var layagl=LayaGL.instance;
		var htmlCanvas=null;
		var htmlContext=null;
		var cacheStyle=(this)._cacheStyle;
		if (cacheStyle.canvas && this._datai32[ /*laya.display.SpriteConst.POSREPAINT*/4]==0){
			htmlCanvas=cacheStyle.canvas;
			if (this._bRepaintCanvas !=false){
				this.setChildrenNativeVisible(false);
				this._bRepaintCanvas=false;
			}
			this._datai32[ /*laya.display.SpriteConst.POSCACHE_CANVAS_SKIP_PAINT_FLAG*/63]=1;
		}
		else{
			this._canvasBeginCmd.beginEncoding();
			this._canvasBeginCmd.clearEncoding();
			htmlCanvas=laya.layagl.ConchSpriteAdpt.buildCanvas((this),0,0);
			if (htmlCanvas){
				this._datai32[ /*laya.display.SpriteConst.POSCACHE_CANVAS_SKIP_PAINT_FLAG*/63]=0;
				this._lastContext=layagl.getCurrentContext();
				htmlContext=htmlCanvas.context;
				var target=htmlContext._targets;
				DrawCanvasCmdNative.setParamData(this._drawCanvasParamData,target,-/*laya.display.css.CacheStyle.CANVAS_EXTEND_EDGE*/16,-/*laya.display.css.CacheStyle.CANVAS_EXTEND_EDGE*/16,target.width,target.height);
				layagl.setCurrentContext(htmlContext);
				htmlContext.beginRT();
				layagl.save();
				ConchSpriteAdpt._tempFloatArrayMatrix[0]=1;ConchSpriteAdpt._tempFloatArrayMatrix[1]=0;ConchSpriteAdpt._tempFloatArrayMatrix[2]=0;ConchSpriteAdpt._tempFloatArrayMatrix[3]=1;
				ConchSpriteAdpt._tempFloatArrayMatrix[4]=/*laya.display.css.CacheStyle.CANVAS_EXTEND_EDGE*/16;ConchSpriteAdpt._tempFloatArrayMatrix[5]=/*laya.display.css.CacheStyle.CANVAS_EXTEND_EDGE*/16;
				layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_MATRIX32,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,ConchSpriteAdpt._tempFloatArrayMatrix);
				if (this._bRepaintCanvas !=true){
					this.setChildrenNativeVisible(true);
					this._bRepaintCanvas=true;
				}
			}
			this._canvasBeginCmd.endEncoding();
		}
	}

	//TODO:coverage
	__proto.setChildrenNativeVisible=function(visible){
		var childs=this._children,ele;
		var n=childs.length;
		for (var i=0;i < n;++i){
			ele=childs[i];
			ele._datai32[ /*laya.display.SpriteConst.POSVISIBLE_NATIVE*/5]=visible?1:0;
			ele.setChildrenNativeVisible(visible);
		}
	}

	//TODO:coverage
	__proto.canvasEndRenderFromNative=function(){
		var layagl=LayaGL.instance;
		this._canvasEndCmd.beginEncoding();
		this._canvasEndCmd.clearEncoding();
		if (this._bRepaintCanvas){
			var context=LayaGL.instance.getCurrentContext();
			layagl.restore();
			layagl.setCurrentContext(this._lastContext);
			layagl.commitContextToGPU(context);
			context.endRT();
			layagl.blendFunc(/*laya.webgl.WebGLContext.ONE*/1,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303);
		}
		this._canvasEndCmd.endEncoding();
	}

	//TODO:coverage
	__proto.filterBeginRenderFromNative=function(){
		var sprite=this;
		var layagl=LayaGL.instance;
		this._filterBeginCmd.beginEncoding();
		this._filterBeginCmd.clearEncoding();
		var filters=(this)._getCacheStyle().filters;
		var len=filters.length;
		if (((filters[0])instanceof laya.filters.ColorFilter )){
			layagl.addShaderMacro(LayaNative2D.SHADER_MACRO_COLOR_FILTER);
			var colorFilter=filters[0];
			layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_COLORFILTER_COLOR,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,colorFilter._mat);
			layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_COLORFILTER_ALPHA,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,colorFilter._alpha);
		}
		else{
			var p=Point.TEMP;
			var mat=Matrix.create();
			var tPadding=0;
			var tHalfPadding=0;
			var tIsHaveGlowFilter=sprite._isHaveGlowFilter();
			if (tIsHaveGlowFilter){
				tPadding=50;
				tHalfPadding=25;
			};
			var b=new Rectangle();
			b.copyFrom((sprite).getSelfBounds());
			b.x+=(sprite).x;
			b.y+=(sprite).y;
			b.x-=(sprite).pivotX+4;
			b.y-=(sprite).pivotY+4;
			var tSX=b.x;
			var tSY=b.y;
			b.width+=(tPadding+8);
			b.height+=(tPadding+8);
			p.x=b.x *mat.a+b.y *mat.c;
			p.y=b.y *mat.d+b.x *mat.b;
			b.x=p.x;
			b.y=p.y;
			p.x=b.width *mat.a+b.height *mat.c;
			p.y=b.height *mat.d+b.width *mat.b;
			b.width=p.x;
			b.height=p.y;
			if (b.width <=0 || b.height <=0){
				return;
			};
			var filterTarget=sprite._getCacheStyle().filterCache;
			if (filterTarget){
				WebGLRTMgr.releaseRT(filterTarget);
			}
			filterTarget=WebGLRTMgr.getRT(b.width,b.height);
			sprite._getCacheStyle().filterCache=filterTarget;
			ConchSpriteAdpt.useRenderTarget(filterTarget);
			ConchSpriteAdpt._tempFloatArrayMatrix[0]=1;ConchSpriteAdpt._tempFloatArrayMatrix[1]=0;ConchSpriteAdpt._tempFloatArrayMatrix[2]=0;ConchSpriteAdpt._tempFloatArrayMatrix[3]=1;
			ConchSpriteAdpt._tempFloatArrayMatrix[4]=sprite.x-tSX+tHalfPadding;
			ConchSpriteAdpt._tempFloatArrayMatrix[5]=sprite.y-tSY+tHalfPadding;
			layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_MATRIX32,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,ConchSpriteAdpt._tempFloatArrayMatrix);
		}
		this._filterBeginCmd.endEncoding();
	}

	//TODO:coverage
	__proto.filterEndRenderFromNative=function(){
		this._filterEndCmd.beginEncoding();
		this._filterEndCmd.clearEncoding();
		var sprite=this;
		var layagl=LayaGL.instance;
		var filters=(this)._getCacheStyle().filters;
		if (((filters[0])instanceof laya.filters.ColorFilter )){
		}
		else{
			layagl.restore();
			var context=LayaGL.instance.getCurrentContext();
			var target=RenderTexture2D.currentActive;
			RenderTexture2D.popRT();
			if(/*__JS__ */filters[0] instanceof Laya.BlurFilter){
				layagl.addShaderMacro(LayaNative2D.SHADER_MACRO_BLUR_FILTER);
				var blurFilter=filters[0];
				ConchSpriteAdpt._tempFloatArrayBuffer2[0]=target.width;
				ConchSpriteAdpt._tempFloatArrayBuffer2[1]=target.height;
				layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_BLURFILTER_BLURINFO,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,ConchSpriteAdpt._tempFloatArrayBuffer2);
				layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_BLURFILTER_STRENGTH,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,blurFilter.getStrenth_sig2_2sig2_native());
				context.drawTarget(this._filterEndCmd,target,-4,-4,0,0);
			}
			else if(/*__JS__ */filters[0] instanceof Laya.GlowFilter){
				var w=target.width;
				var h=target.height;
				var target1=WebGLRTMgr.getRT(w,h);
				ConchSpriteAdpt.useRenderTarget(target1);
				layagl.addShaderMacro(LayaNative2D.SHADER_MACRO_GLOW_FILTER);
				var glowFilter=filters[0];
				var info2=glowFilter.getBlurInfo2Native();
				info2[0]=w;
				info2[1]=h;
				layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_GLOWFILTER_COLOR,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,glowFilter.getColorNative());
				layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_GLOWFILTER_BLURINFO1,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,glowFilter.getBlurInfo1Native());
				layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_GLOWFILTER_BLURINFO2,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,info2);
				context.drawTarget(this._filterEndCmd,target,-/*laya.display.css.CacheStyle.CANVAS_EXTEND_EDGE*/16,-/*laya.display.css.CacheStyle.CANVAS_EXTEND_EDGE*/16,0,0);
				layagl.restore();
				RenderTexture2D.popRT();
				context.drawTarget(this._filterEndCmd,target1,-29,-29,0,0);
				context.drawTarget(this._filterEndCmd,target,-29,-29,0,0);
			}
		}
		this._filterEndCmd.endEncoding();
		LayaGL.syncBufferToRenderThread(this._filterEndCmd);
	}

	__proto.maskRenderFromNative=function(){
		this._maskCmd.beginEncoding();
		this._maskCmd.clearEncoding();
		var layagl=LayaGL.instance;
		var context=layagl.getCurrentContext();
		var mask=(this).mask;
		if (mask){
			if (mask._children.length > 0){
				layagl.blockStart(mask._conchData);
				(mask)._renderChilds(context);
				layagl.blockEnd(mask._conchData);
			}
			else{
				layagl.block(mask._conchData);
			}
		}
		ConchSpriteAdpt._tempInt1[0]=/*laya.webgl.WebGLContext.DST_ALPHA*/0x0304;
		layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,ConchSpriteAdpt._tempInt1);
		ConchSpriteAdpt._tempInt1[0]=/*laya.webgl.WebGLContext.ZERO*/0;
		layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,ConchSpriteAdpt._tempInt1);
		this._maskCmd.endEncoding();
	}

	__proto.updateParticleFromNative=function(){
		(this).tempCmd.updateParticle();
	}

	ConchSpriteAdpt.createMatrix=function(a,b,c,d,tx,ty,nums){
		(a===void 0)&& (a=1);
		(b===void 0)&& (b=0);
		(c===void 0)&& (c=0);
		(d===void 0)&& (d=1);
		(tx===void 0)&& (tx=0);
		(ty===void 0)&& (ty=0);
		return new MatrixConch(a,b,c,d,tx,ty,nums);
	}

	ConchSpriteAdpt.init=function(){
		ConchCmdReplace.__init__();
		ConchGraphicsAdpt.__init__();
		var spP=Sprite["prototype"];
		var mP=ConchSpriteAdpt["prototype"];
		var funs=[
		"_createTransform",
		"_setTransform",
		"_setGraphics",
		"_setGraphicsCallBack",
		"_setCacheAs",
		"_setX",
		"_setY",
		"_setPivotX",
		"_getPivotX",
		"_setPivotY",
		"_getPivotY",
		"_setAlpha",
		"_getAlpha",
		"_setScaleX",
		"_setScaleY",
		"_setSkewX",
		"_setSkewY",
		"_setRotation",
		"_adjustTransform",
		"_setRenderType",
		"_setTexture",
		"_setTextureEx",
		"_setCustomRender",
		"_setScrollRect",
		"_setColorFilter",
		"customRenderFromNative",
		"canvasBeginRenderFromNative",
		"canvasEndRenderFromNative",
		"setChildrenNativeVisible",
		"filterBeginRenderFromNative",
		"filterEndRenderFromNative",
		"updateParticleFromNative",
		"_setMask",
		"maskRenderFromNative",
		"_setBlendMode",
		"_setBgStyleColor",
		"_setBorderStyleColor",
		"_setWidth",
		"_setHeight",
		"_setTranformChange",];
		var i=0,len=0;
		len=funs.length;
		var tFunName;
		for (i=0;i < len;i++){
			tFunName=funs[i];
			spP[tFunName]=mP[tFunName];
		}
		spP["createGLBuffer"]=mP["createData"];
		Matrix._createFun=ConchSpriteAdpt.createMatrix;
		var sprite=Sprite;
		spP.render=spP.renderToNative=ConchSprite.prototype.renderToNative;
		spP.repaint=spP.repaintForNative=ConchSprite.prototype.repaintForNative;
		spP.parentRepaint=spP.parentRepaintForNative=ConchSprite.prototype.parentRepaintForNative;
		spP._renderChilds=ConchSprite.prototype._renderChilds;
		spP.writeBlockToNative=ConchSprite.prototype.writeBlockToNative;
		spP._writeBlockChilds=ConchSprite.prototype._writeBlockChilds;
	}

	ConchSpriteAdpt.useRenderTarget=function(target){
		var layagl=LayaGL.instance;
		RenderTexture2D.pushRT();
		target.start();
		layagl.clearColor(0,0,0,0);
		layagl.clear(/*laya.webgl.WebGLContext.COLOR_BUFFER_BIT*/0x00004000 | /*laya.webgl.WebGLContext.DEPTH_BUFFER_BIT*/0x00000100 | /*laya.webgl.WebGLContext.STENCIL_BUFFER_BIT*/0x00000400);
		layagl.save();
		ConchSpriteAdpt._tempFloatArrayBuffer2[0]=target.width;
		ConchSpriteAdpt._tempFloatArrayBuffer2[1]=target.height;
		layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_VIEWS,/*laya.layagl.LayaGL.VALUE_OPERATE_SET*/8,ConchSpriteAdpt._tempFloatArrayBuffer2);
	}

	ConchSpriteAdpt.buildCanvas=function(sprite,x,y){
		var _cacheStyle=sprite._cacheStyle;
		var tx;
		var canvas=_cacheStyle.canvas;
		var left;
		var top;
		var tRec;
		var tCacheType=_cacheStyle.cacheAs;
		var w,h;
		var scaleX,scaleY;
		var scaleInfo;
		scaleInfo=_cacheStyle._calculateCacheRect(sprite,tCacheType,x,y);
		scaleX=scaleInfo.x;
		scaleY=scaleInfo.y;
		tRec=_cacheStyle.cacheRect;
		w=tRec.width *scaleX;
		h=tRec.height *scaleY;
		left=tRec.x;
		top=tRec.y;
		if (tCacheType==='bitmap' && (w > 2048 || h > 2048)){
			alert("cache bitmap size larger than 2048,cache ignored");
			_cacheStyle.releaseContext();
			return null;
		}
		if (!canvas){
			_cacheStyle.createContext();
			canvas=_cacheStyle.canvas;
		}
		tx=canvas.context;
		canvas.context.sprite=sprite;
		if (canvas.width !=w || canvas.height !=h){
			canvas.size(w,h);
			if (tx._targets){
				tx._targets.destroy();
				tx._targets=null;
			}
		}
		if (tCacheType==='bitmap')canvas.context.asBitmap=true;
		else if (tCacheType==='normal')canvas.context.asBitmap=false;
		if (tCacheType==='normal'){
			tx.touches=[];
		}
		return canvas;
	}

	__static(ConchSpriteAdpt,
	['_tempFloatArrayBuffer2',function(){return this._tempFloatArrayBuffer2=new Float32Array(2);},'_tempFloatArrayMatrix',function(){return this._tempFloatArrayMatrix=new Float32Array(6);},'_tempInt1',function(){return this._tempInt1=new Int32Array(1);}
	]);
	return ConchSpriteAdpt;
})(Node)


//class laya.webgl.text.TextTexture extends laya.resource.Resource
var TextTexture=(function(_super){
	function TextTexture(textureW,textureH){
		this._source=null;
		// webgl 贴图
		this._texW=0;
		this._texH=0;
		this.__destroyed=false;
		//父类有，但是private
		this._discardTm=0;
		//释放的时间。超过一定时间会被真正删除
		this.genID=0;
		// 这个对象会重新利用，为了能让引用他的人知道自己引用的是否有效，加个id
		this.bitmap={id:0,_glTexture:null};
		//samekey的判断用的
		this.curUsedCovRate=0;
		// 当前使用到的使用率。根据面积算的
		this.curUsedCovRateAtlas=0;
		// 大图集中的占用率。由于大图集分辨率低，所以会浪费一些空间
		this.lastTouchTm=0;
		this.ri=null;
		TextTexture.__super.call(this);
		this._texW=textureW || TextRender.atlasWidth;
		this._texH=textureH || TextRender.atlasWidth;
		this.bitmap.id=this.id;
		this.lock=true;
	}

	__class(TextTexture,'laya.webgl.text.TextTexture',_super);
	var __proto=TextTexture.prototype;
	//防止被资源管理清除
	__proto.recreateResource=function(){
		if (this._source)
			return;
		var gl=Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
		var glTex=this._source=gl.createTexture();
		this.bitmap._glTexture=glTex;
		WebGLContext.bindTexture(gl,/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,glTex);
		gl.texImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,this._texW,this._texH,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,null);
		gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,/*laya.webgl.WebGLContext.LINEAR*/0x2601);
		gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,/*laya.webgl.WebGLContext.LINEAR*/0x2601);
		gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
		gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
		if (TextRender.debugUV){
			this.fillWhite();
		}
	}

	/**
	*
	*@param data
	*@param x 拷贝位置。
	*@param y
	*@param uv
	*@return uv数组 如果uv不为空就返回传入的uv，否则new一个数组
	*/
	__proto.addChar=function(data,x,y,uv){
		if(TextRender.isWan1Wan){
			return this.addCharCanvas(data ,x,y,uv);
		}
		!this._source && this.recreateResource();
		var gl=Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
		WebGLContext.bindTexture(gl,/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,this._source);
		!Render.isConchApp && gl.pixelStorei(/*laya.webgl.WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL*/0x9241,true);
		var dt=data.data;
		if (/*__JS__ */data.data instanceof Uint8ClampedArray)
			dt=new Uint8Array(dt.buffer);
		gl.texSubImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,x,y,data.width,data.height,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,dt);
		!Render.isConchApp && gl.pixelStorei(/*laya.webgl.WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL*/0x9241,false);
		var u0=NaN;
		var v0=NaN;
		var u1=NaN;
		var v1=NaN;
		if(Render.isConchApp){
			u0=x / this._texW;
			v0=y / this._texH;
			u1=(x+data.width)/ this._texW;
			v1=(y+data.height)/ this._texH;
			}else{
			u0=(x+1)/ this._texW;
			v0=(y+1)/ this._texH;
			u1=(x+data.width-1)/ this._texW;
			v1=(y+data.height-1)/ this._texH;
		}
		uv=uv || new Array(8);
		uv[0]=u0,uv[1]=v0;
		uv[2]=u1,uv[3]=v0;
		uv[4]=u1,uv[5]=v1;
		uv[6]=u0,uv[7]=v1;
		return uv;
	}

	/**
	*玩一玩不支持 getImageData
	*@param canv
	*@param x
	*@param y
	*/
	__proto.addCharCanvas=function(canv,x,y,uv){
		!this._source && this.recreateResource();
		var gl=Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
		WebGLContext.bindTexture(gl,/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,this._source);
		!Render.isConchApp && gl.pixelStorei(/*laya.webgl.WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL*/0x9241,true);
		gl.texSubImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,x,y,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,canv);
		!Render.isConchApp && gl.pixelStorei(/*laya.webgl.WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL*/0x9241,false);
		var u0=NaN;
		var v0=NaN;
		var u1=NaN;
		var v1=NaN;
		if(Render.isConchApp){
			u0=x / this._texW;
			v0=y / this._texH;
			u1=(x+canv.width)/ this._texW;
			v1=(y+canv.height)/ this._texH;
			}else{
			u0=(x+1)/ this._texW;
			v0=(y+1)/ this._texH;
			u1=(x+canv.width-1)/ this._texW;
			v1=(y+canv.height-1)/ this._texH;
		}
		uv=uv || new Array(8);
		uv[0]=u0,uv[1]=v0;
		uv[2]=u1,uv[3]=v0;
		uv[4]=u1,uv[5]=v1;
		uv[6]=u0,uv[7]=v1;
		return uv;
	}

	/**
	*填充白色。调试用。
	*/
	__proto.fillWhite=function(){
		!this._source && this.recreateResource();
		var gl=Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
		var dt=new Uint8Array(this._texW *this._texH *4);
		(dt).fill(0xff);
		gl.texSubImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,0,0,this._texW,this._texH,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,dt);
	}

	__proto.discard=function(){
		if (this._texW !=TextRender.atlasWidth || this._texH !=TextRender.atlasWidth){
			this.destroy();
			return;
		}
		this.genID++;
		if (TextTexture.poolLen >=TextTexture.pool.length){
			TextTexture.pool=TextTexture.pool.concat(new Array(10));
		}
		this._discardTm=Laya.stage.getFrameTm();
		TextTexture.pool[TextTexture.poolLen++]=this;
	}

	__proto.destroy=function(){
		console.log('destroy TextTexture');
		this.__destroyed=true;
		var gl=Render.isConchApp?LayaGL.instance.getDefaultCommandEncoder():WebGL.mainContext;
		this._source && gl.deleteTexture(this._source);
		this._source=null;
	}

	__proto.touchRect=function(ri,curloop){
		if (this.lastTouchTm !=curloop){
			this.curUsedCovRate=0;
			this.curUsedCovRateAtlas=0;
			this.lastTouchTm=curloop;
		};
		var texw2=TextRender.atlasWidth *TextRender.atlasWidth;
		var gridw2=TextAtlas.atlasGridW *TextAtlas.atlasGridW;
		this.curUsedCovRate+=(ri.bmpWidth *ri.bmpHeight)/ texw2;
		this.curUsedCovRateAtlas+=(Math.ceil(ri.bmpWidth / TextAtlas.atlasGridW)*Math.ceil(ri.bmpHeight / TextAtlas.atlasGridW))/ (texw2 / gridw2);
	}

	__proto._getSource=function(){
		return this._source;
	}

	// for debug
	__proto.drawOnScreen=function(x,y){}
	// 为了与当前的文字渲染兼容的补丁
	__getset(0,__proto,'texture',function(){
		return this;
	});

	TextTexture.getTextTexture=function(w,h){
		if (w !=TextRender.atlasWidth || w !=TextRender.atlasWidth)
			return new TextTexture(w,h);
		if (TextTexture.poolLen > 0){
			var ret=TextTexture.pool[--TextTexture.poolLen];
			if (TextTexture.poolLen > 0)
				TextTexture.clean();
			return ret;
		}
		return new TextTexture(w,h);
	}

	TextTexture.clean=function(){
		var curtm=Laya.stage.getFrameTm();
		if (TextTexture.cleanTm===0)TextTexture.cleanTm=curtm;
		if (curtm-TextTexture.cleanTm >=TextRender.checkCleanTextureDt){
			for (var i=0;i < TextTexture.poolLen;i++){
				var p=TextTexture.pool[i];
				if (curtm-p._discardTm >=TextRender.destroyUnusedTextureDt){
					p.destroy();
					TextTexture.pool[i]=TextTexture.pool[TextTexture.poolLen-1];
					TextTexture.poolLen--;
					i--;
				}
			}
			TextTexture.cleanTm=curtm;
		}
	}

	TextTexture.poolLen=0;
	TextTexture.cleanTm=0;
	__static(TextTexture,
	['pool',function(){return this.pool=new Array(10);}
	]);
	return TextTexture;
})(Resource)


//class laya.webgl.utils.IndexBuffer2D extends laya.webgl.utils.Buffer2D
var IndexBuffer2D=(function(_super){
	function IndexBuffer2D(bufferUsage){
		this._uint16Array=null;
		(bufferUsage===void 0)&& (bufferUsage=0x88e4);
		IndexBuffer2D.__super.call(this);
		this._bufferUsage=bufferUsage;
		this._bufferType=/*laya.webgl.WebGLContext.ELEMENT_ARRAY_BUFFER*/0x8893;
		this._buffer=new ArrayBuffer(8);
	}

	__class(IndexBuffer2D,'laya.webgl.utils.IndexBuffer2D',_super);
	var __proto=IndexBuffer2D.prototype;
	__proto._checkArrayUse=function(){
		this._uint16Array && (this._uint16Array=new Uint16Array(this._buffer));
	}

	__proto.getUint16Array=function(){
		return this._uint16Array || (this._uint16Array=new Uint16Array(this._buffer));
	}

	/**
	*@inheritDoc
	*/
	__proto._bindForVAO=function(){
		LayaGL.instance.bindBuffer(/*laya.webgl.WebGLContext.ELEMENT_ARRAY_BUFFER*/0x8893,this._glBuffer);
	}

	/**
	*@inheritDoc
	*/
	__proto.bind=function(){
		if (Buffer._bindedIndexBuffer!==this._glBuffer){
			LayaGL.instance.bindBuffer(/*laya.webgl.WebGLContext.ELEMENT_ARRAY_BUFFER*/0x8893,this._glBuffer);
			Buffer._bindedIndexBuffer=this._glBuffer;
			return true;
		}
		return false;
	}

	__proto.destory=function(){
		this._uint16Array=null;
		this._buffer=null;
	}

	__proto.disposeResource=function(){
		this._disposeResource();
	}

	IndexBuffer2D.create=function(bufferUsage){
		(bufferUsage===void 0)&& (bufferUsage=0x88e4);
		return new IndexBuffer2D(bufferUsage);
	}

	return IndexBuffer2D;
})(Buffer2D)


//class laya.webgl.utils.VertexBuffer2D extends laya.webgl.utils.Buffer2D
var VertexBuffer2D=(function(_super){
	function VertexBuffer2D(vertexStride,bufferUsage){
		this._floatArray32=null;
		this._uint32Array=null;
		this._vertexStride=0;
		VertexBuffer2D.__super.call(this);
		this._vertexStride=vertexStride;
		this._bufferUsage=bufferUsage;
		this._bufferType=/*laya.webgl.WebGLContext.ARRAY_BUFFER*/0x8892;
		this._buffer=new ArrayBuffer(8);
		this._floatArray32=new Float32Array(this._buffer);
		this._uint32Array=new Uint32Array(this._buffer);
	}

	__class(VertexBuffer2D,'laya.webgl.utils.VertexBuffer2D',_super);
	var __proto=VertexBuffer2D.prototype;
	__proto.getFloat32Array=function(){
		return this._floatArray32;
	}

	/**
	*在当前位置插入float数组。
	*@param data
	*@param pos
	*/
	__proto.appendArray=function(data){
		var oldoff=this._byteLength >> 2;
		this.setByteLength(this._byteLength+data.length *4);
		var vbdata=this.getFloat32Array();
		vbdata.set(data,oldoff);
		this._upload=true;
	}

	__proto._checkArrayUse=function(){
		this._floatArray32 && (this._floatArray32=new Float32Array(this._buffer));
		this._uint32Array && (this._uint32Array=new Uint32Array(this._buffer));
	}

	//只删除buffer，不disableVertexAttribArray
	__proto.deleteBuffer=function(){
		this._disposeResource();
	}

	/**
	*@inheritDoc
	*/
	__proto._bindForVAO=function(){
		LayaGL.instance.bindBuffer(/*laya.webgl.WebGLContext.ARRAY_BUFFER*/0x8892,this._glBuffer);
	}

	/**
	*@inheritDoc
	*/
	__proto.bind=function(){
		if (Buffer._bindedVertexBuffer!==this._glBuffer){
			LayaGL.instance.bindBuffer(/*laya.webgl.WebGLContext.ARRAY_BUFFER*/0x8892,this._glBuffer);
			Buffer._bindedVertexBuffer=this._glBuffer;
			return true;
		}
		return false;
	}

	__proto.destroy=function(){
		laya.webgl.utils.Buffer.prototype.destroy.call(this);
		this._byteLength=0;
		this._upload=true;
		this._buffer=null;
		this._floatArray32=null;
	}

	__getset(0,__proto,'vertexStride',function(){
		return this._vertexStride;
	});

	VertexBuffer2D.create=function(vertexStride,bufferUsage){
		(bufferUsage===void 0)&& (bufferUsage=0x88e8);
		return new VertexBuffer2D(vertexStride,bufferUsage);
	}

	return VertexBuffer2D;
})(Buffer2D)


/**
*<code>BaseTexture</code> 纹理的父类，抽象类，不允许实例。
*/
//class laya.webgl.resource.BaseTexture extends laya.resource.Bitmap
var BaseTexture=(function(_super){
	function BaseTexture(format,mipMap){
		/**@private */
		//this._readyed=false;
		/**@private */
		//this._glTextureType=0;
		/**@private */
		//this._glTexture=null;
		/**@private */
		//this._format=0;
		/**@private */
		//this._mipmap=false;
		/**@private */
		//this._wrapModeU=0;
		/**@private */
		//this._wrapModeV=0;
		/**@private */
		//this._filterMode=0;
		/**@private */
		//this._anisoLevel=0;
		BaseTexture.__super.call(this);
		this._wrapModeU=/*CLASS CONST:laya.webgl.resource.BaseTexture.WARPMODE_REPEAT*/0;
		this._wrapModeV=/*CLASS CONST:laya.webgl.resource.BaseTexture.WARPMODE_REPEAT*/0;
		this._filterMode=/*CLASS CONST:laya.webgl.resource.BaseTexture.FILTERMODE_BILINEAR*/1;
		this._readyed=false;
		this._width=-1;
		this._height=-1;
		this._format=format;
		this._mipmap=mipMap;
		this._anisoLevel=1;
		this._glTexture=LayaGL.instance.createTexture();
	}

	__class(BaseTexture,'laya.webgl.resource.BaseTexture',_super);
	var __proto=BaseTexture.prototype;
	/**
	*@private
	*/
	__proto._isPot=function(size){
		return (size & (size-1))===0;
	}

	/**
	*@private
	*/
	__proto._getGLFormat=function(){
		var glFormat=0;
		switch (this._format){
			case 0:
				glFormat=/*laya.webgl.WebGLContext.RGB*/0x1907;
				break ;
			case 1:
				glFormat=/*laya.webgl.WebGLContext.RGBA*/0x1908;
				break ;
			case 2:
				glFormat=/*laya.webgl.WebGLContext.ALPHA*/0x1906;
				break ;
			case 3:
				if (WebGLContext._compressedTextureS3tc)
					glFormat=WebGLContext._compressedTextureS3tc.COMPRESSED_RGB_S3TC_DXT1_EXT;
				else
				throw "BaseTexture: not support DXT1 format.";
				break ;
			case 4:
				if (WebGLContext._compressedTextureS3tc)
					glFormat=WebGLContext._compressedTextureS3tc.COMPRESSED_RGBA_S3TC_DXT5_EXT;
				else
				throw "BaseTexture: not support DXT5 format.";
				break ;
			case 5:
				if (WebGLContext._compressedTextureEtc1)
					glFormat=WebGLContext._compressedTextureEtc1.COMPRESSED_RGB_ETC1_WEBGL;
				else
				throw "BaseTexture: not support ETC1RGB format.";
				break ;
			case 9:
				if (WebGLContext._compressedTexturePvrtc)
					glFormat=WebGLContext._compressedTexturePvrtc.COMPRESSED_RGB_PVRTC_2BPPV1_IMG;
				else
				throw "BaseTexture: not support PVRTCRGB_2BPPV format.";
				break ;
			case 10:
				if (WebGLContext._compressedTexturePvrtc)
					glFormat=WebGLContext._compressedTexturePvrtc.COMPRESSED_RGBA_PVRTC_2BPPV1_IMG;
				else
				throw "BaseTexture: not support PVRTCRGBA_2BPPV format.";
				break ;
			case 11:
				if (WebGLContext._compressedTexturePvrtc)
					glFormat=WebGLContext._compressedTexturePvrtc.COMPRESSED_RGB_PVRTC_4BPPV1_IMG;
				else
				throw "BaseTexture: not support PVRTCRGB_4BPPV format.";
				break ;
			case 12:
				if (WebGLContext._compressedTexturePvrtc)
					glFormat=WebGLContext._compressedTexturePvrtc.COMPRESSED_RGBA_PVRTC_4BPPV1_IMG;
				else
				throw "BaseTexture: not support PVRTCRGBA_4BPPV format.";
				break ;
			default :
				throw "BaseTexture: unknown texture format.";
			}
		return glFormat;
	}

	/**
	*@private
	*/
	__proto._setFilterMode=function(value){
		var gl=LayaGL.instance;
		WebGLContext.bindTexture(gl,this._glTextureType,this._glTexture);
		switch (value){
			case 0:
				if (this._mipmap && this._isPot(this._width)&& this._isPot(this._height))
					gl.texParameteri(this._glTextureType,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,/*laya.webgl.WebGLContext.NEAREST_MIPMAP_NEAREST*/0x2700);
				else
				gl.texParameteri(this._glTextureType,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,/*laya.webgl.WebGLContext.NEAREST*/0x2600);
				gl.texParameteri(this._glTextureType,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,/*laya.webgl.WebGLContext.NEAREST*/0x2600);
				break ;
			case 1:
				if (this._mipmap && this._isPot(this._width)&& this._isPot(this._height))
					gl.texParameteri(this._glTextureType,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,/*laya.webgl.WebGLContext.LINEAR_MIPMAP_NEAREST*/0x2701);
				else
				gl.texParameteri(this._glTextureType,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				gl.texParameteri(this._glTextureType,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				break ;
			case 2:
				if (this._mipmap && this._isPot(this._width)&& this._isPot(this._height))
					gl.texParameteri(this._glTextureType,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,/*laya.webgl.WebGLContext.LINEAR_MIPMAP_LINEAR*/0x2703);
				else
				gl.texParameteri(this._glTextureType,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				gl.texParameteri(this._glTextureType,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				break ;
			default :
				throw new Error("BaseTexture:unknown filterMode value.");
			}
	}

	/**
	*@private
	*/
	__proto._setWarpMode=function(orientation,mode){
		var gl=LayaGL.instance;
		WebGLContext.bindTexture(gl,this._glTextureType,this._glTexture);
		if (this._isPot(this._width)&& this._isPot(this._height)){
			switch (mode){
				case 0:
					gl.texParameteri(this._glTextureType,orientation,/*laya.webgl.WebGLContext.REPEAT*/0x2901);
					break ;
				case 1:
					gl.texParameteri(this._glTextureType,orientation,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
					break ;
				}
			}else {
			gl.texParameteri(this._glTextureType,orientation,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
		}
	}

	/**
	*@private
	*/
	__proto._setAnisotropy=function(value){
		var anisotropic=WebGLContext._extTextureFilterAnisotropic;
		if (anisotropic && !Browser.onLimixiu){
			value=Math.max(value,1);
			var gl=LayaGL.instance;
			WebGLContext.bindTexture(gl,this._glTextureType,this._glTexture);
			value=Math.min(gl.getParameter(anisotropic.MAX_TEXTURE_MAX_ANISOTROPY_EXT),value);
			gl.texParameterf(this._glTextureType,anisotropic.TEXTURE_MAX_ANISOTROPY_EXT,value);
		}
	}

	/**
	*@inheritDoc
	*/
	__proto._disposeResource=function(){
		if (this._glTexture){
			LayaGL.instance.deleteTexture(this._glTexture);
			this._glTexture=null;
			this._setGPUMemory(0);
		}
	}

	/**
	*获取纹理资源。
	*/
	__proto._getSource=function(){
		if (this._readyed)
			return this._glTexture;
		else
		return null;
	}

	/**
	*设置纹理横向循环模式。
	*/
	/**
	*获取纹理横向循环模式。
	*/
	__getset(0,__proto,'wrapModeU',function(){
		return this._wrapModeU;
		},function(value){
		if (this._wrapModeU!==value){
			this._wrapModeU=value;
			(this._width!==-1)&& (this._setWarpMode(/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,value));
		}
	});

	/**
	*是否使用mipLevel
	*/
	__getset(0,__proto,'mipmap',function(){
		return this._mipmap;
	});

	/**
	*纹理格式
	*/
	__getset(0,__proto,'format',function(){
		return this._format;
	});

	/**
	*设置纹理纵向循环模式。
	*/
	/**
	*获取纹理纵向循环模式。
	*/
	__getset(0,__proto,'wrapModeV',function(){
		return this._wrapModeV;
		},function(value){
		if (this._wrapModeV!==value){
			this._wrapModeV=value;
			(this._height!==-1)&& (this._setWarpMode(/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,value));
		}
	});

	/**
	*获取默认纹理资源。
	*/
	__getset(0,__proto,'defaulteTexture',function(){
		throw "BaseTexture:must override it."
	});

	/**
	*缩小过滤器
	*/
	/**
	*缩小过滤器
	*/
	__getset(0,__proto,'filterMode',function(){
		return this._filterMode;
		},function(value){
		if (value!==this._filterMode){
			this._filterMode=value;
			((this._width!==-1)&& (this._height!==-1))&& (this._setFilterMode(value));
		}
	});

	/**
	*各向异性等级
	*/
	/**
	*各向异性等级
	*/
	__getset(0,__proto,'anisoLevel',function(){
		return this._anisoLevel;
		},function(value){
		if (value!==this._anisoLevel){
			this._anisoLevel=Math.max(1,Math.min(16,value));
			((this._width!==-1)&& (this._height!==-1))&& (this._setAnisotropy(value));
		}
	});

	BaseTexture.WARPMODE_REPEAT=0;
	BaseTexture.WARPMODE_CLAMP=1;
	BaseTexture.FILTERMODE_POINT=0;
	BaseTexture.FILTERMODE_BILINEAR=1;
	BaseTexture.FILTERMODE_TRILINEAR=2;
	BaseTexture.FORMAT_R8G8B8=0;
	BaseTexture.FORMAT_R8G8B8A8=1;
	BaseTexture.FORMAT_ALPHA8=2;
	BaseTexture.FORMAT_DXT1=3;
	BaseTexture.FORMAT_DXT5=4;
	BaseTexture.FORMAT_ETC1RGB=5;
	BaseTexture.FORMAT_PVRTCRGB_2BPPV=9;
	BaseTexture.FORMAT_PVRTCRGBA_2BPPV=10;
	BaseTexture.FORMAT_PVRTCRGB_4BPPV=11;
	BaseTexture.FORMAT_PVRTCRGBA_4BPPV=12;
	BaseTexture.FORMAT_DEPTH_16=0;
	BaseTexture.FORMAT_STENCIL_8=1;
	BaseTexture.FORMAT_DEPTHSTENCIL_16_8=2;
	BaseTexture.FORMAT_DEPTHSTENCIL_NONE=3;
	return BaseTexture;
})(Bitmap)


//class laya.layagl.ConchSprite extends laya.display.Sprite
var ConchSprite=(function(_super){
	function ConchSprite(){
		ConchSprite.__super.call(this);;
	}

	__class(ConchSprite,'laya.layagl.ConchSprite',_super);
	var __proto=ConchSprite.prototype;
	//TODO:coverage
	__proto.parentRepaintForNative=function(type){
		(type===void 0)&& (type=/*laya.display.SpriteConst.REPAINT_CACHE*/0x02);
		var p=this._parent;
		if (p){
			if (!((p._conchData._int32Data[ /*laya.display.SpriteConst.POSREPAINT*/4]&type)==type)){
				p._conchData._int32Data[ /*laya.display.SpriteConst.POSREPAINT*/4] |=type;
				p.parentRepaintForNative(type);
			}
		}
	}

	//TODO:coverage
	__proto.renderToNative=function(context,x,y){
		var layagl=context.gl;
		var nCurentFrameCount=LayaGL.getFrameCount()-1;
		var iData=this._conchData._int32Data;
		var nRepaint=iData[ /*laya.display.SpriteConst.POSREPAINT*/4];
		if (this._children.length > 0){
			if (nCurentFrameCount !=iData[ /*laya.display.SpriteConst.POSFRAMECOUNT*/3] || (nRepaint > 0 && ((nRepaint & /*laya.display.SpriteConst.REPAINT_NODE*/0x01)==/*laya.display.SpriteConst.REPAINT_NODE*/0x01))){
				layagl.blockStart(this._conchData);
				this._renderChilds(context);
				layagl.blockEnd(this._conchData);
			}
			else{
				layagl.copyCmdBuffer(this._conchData._int32Data[ /*laya.display.SpriteConst.POSBUFFERBEGIN*/1],this._conchData._int32Data[ /*laya.display.SpriteConst.POSBUFFEREND*/2]);
			}
		}
		else{
			layagl.block(this._conchData);
		}
	}

	__proto.writeBlockToNative=function(){
		var layagl=LayaGL.instance;
		if (this._children.length > 0){
			layagl.blockStart(this._conchData);
			this._writeBlockChilds();
			layagl.blockEnd(this._conchData);
		}
		else{
			layagl.block(this._conchData);
		}
	}

	//TODO:coverage
	__proto._renderChilds=function(context){
		var childs=this._children,ele;
		var i=0,n=childs.length;
		var style=(this)._style;
		if (style.viewport){
			var rect=style.viewport;
			var left=rect.x;
			var top=rect.y;
			var right=rect.right;
			var bottom=rect.bottom;
			var _x=NaN,_y=NaN;
			for (;i < n;++i){
				if ((ele=childs[i])._visible && ((_x=ele._x)< right && (_x+ele.width)> left && (_y=ele._y)< bottom && (_y+ele.height)> top))
					ele.renderToNative(context);
			}
			}else {
			for (;i < n;++i)
			(ele=childs[i])._visible && ele.renderToNative(context);
		}
	}

	__proto._writeBlockChilds=function(){
		var childs=this._children,ele;
		var i=0,n=childs.length;
		var style=(this)._style;
		if (style.viewport){
			var rect=style.viewport;
			var left=rect.x;
			var top=rect.y;
			var right=rect.right;
			var bottom=rect.bottom;
			var _x=NaN,_y=NaN;
			for (;i < n;++i){
				if ((ele=childs[i])._visible && ((_x=ele._x)< right && (_x+ele.width)> left && (_y=ele._y)< bottom && (_y+ele.height)> top))
					ele.writeBlockToNative();
			}
			}else {
			for (;i < n;++i)
			(ele=childs[i])._visible && ele.writeBlockToNative();
		}
	}

	//TODO:coverage
	__proto.repaintForNative=function(type){
		(type===void 0)&& (type=/*laya.display.SpriteConst.REPAINT_CACHE*/0x02);
		if (!((this._conchData._int32Data[ /*laya.display.SpriteConst.POSREPAINT*/4] & type)==type)){
			this._conchData._int32Data[ /*laya.display.SpriteConst.POSREPAINT*/4] |=type;
			this.parentRepaintForNative(type);
		}
	}

	return ConchSprite;
})(Sprite)


//class laya.webgl.shader.Shader extends laya.webgl.shader.BaseShader
var Shader=(function(_super){
	function Shader(vs,ps,saveName,nameMap,bindAttrib){
		//存储预编译结果，可以通过名字获得内容,目前不支持#ifdef嵌套和条件
		this._attribInfo=null;
		this.customCompile=false;
		//this._nameMap=null;
		//shader参数别名，语义
		//this._vs=null;
		//this._ps=null;
		this._curActTexIndex=0;
		//this._reCompile=false;
		//存储一些私有变量
		this.tag={};
		//this._vshader=null;
		//this._pshader=null;
		this._program=null;
		this._params=null;
		this._paramsMap={};
		Shader.__super.call(this);
		if ((!vs)|| (!ps))throw "Shader Error";
		this._attribInfo=bindAttrib;
		if (Render.isConchApp){
			this.customCompile=true;
		}
		this._id=++Shader._count;
		this._vs=vs;
		this._ps=ps;
		this._nameMap=nameMap ? nameMap :{};
		saveName !=null && (Shader.sharders[saveName]=this);
		this.recreateResource();
		this.lock=true;
	}

	__class(Shader,'laya.webgl.shader.Shader',_super);
	var __proto=Shader.prototype;
	__proto.recreateResource=function(){
		this._compile();
		this._setGPUMemory(0);
	}

	//TODO:coverage
	__proto._disposeResource=function(){
		WebGL.mainContext.deleteShader(this._vshader);
		WebGL.mainContext.deleteShader(this._pshader);
		WebGL.mainContext.deleteProgram(this._program);
		this._vshader=this._pshader=this._program=null;
		this._params=null;
		this._paramsMap={};
		this._setGPUMemory(0);
		this._curActTexIndex=0;
	}

	__proto._compile=function(){
		if (!this._vs || !this._ps || this._params)
			return;
		this._reCompile=true;
		this._params=[];
		var result;
		if (this.customCompile)
			result=ShaderCompile.preGetParams(this._vs,this._ps);
		var gl=WebGL.mainContext;
		this._program=gl.createProgram();
		this._vshader=Shader._createShader(gl,this._vs,/*laya.webgl.WebGLContext.VERTEX_SHADER*/0x8B31);
		this._pshader=Shader._createShader(gl,this._ps,/*laya.webgl.WebGLContext.FRAGMENT_SHADER*/0x8B30);
		gl.attachShader(this._program,this._vshader);
		gl.attachShader(this._program,this._pshader);
		var one,i=0,j=0,n=0,location;
		var attribDescNum=this._attribInfo?this._attribInfo.length:0;
		for (i=0;i < attribDescNum;i+=2){
			gl.bindAttribLocation(this._program,this._attribInfo[i+1],this._attribInfo[i]);
		}
		gl.linkProgram(this._program);
		if (!this.customCompile && !gl.getProgramParameter(this._program,/*laya.webgl.WebGLContext.LINK_STATUS*/0x8B82)){
			throw gl.getProgramInfoLog(this._program);
		};
		var nUniformNum=this.customCompile ? result.uniforms.length :gl.getProgramParameter(this._program,/*laya.webgl.WebGLContext.ACTIVE_UNIFORMS*/0x8B86);
		for (i=0;i < nUniformNum;i++){
			var uniform=this.customCompile ? result.uniforms[i] :gl.getActiveUniform(this._program,i);
			location=gl.getUniformLocation(this._program,uniform.name);
			one={vartype:"uniform",glfun:null,ivartype:1,location:location,name:uniform.name,type:uniform.type,isArray:false,isSame:false,preValue:null,indexOfParams:0};
			if (one.name.indexOf('[0]')> 0){
				one.name=one.name.substr(0,one.name.length-3);
				one.isArray=true;
				one.location=gl.getUniformLocation(this._program,one.name);
			}
			this._params.push(one);
		}
		for (i=0,n=this._params.length;i < n;i++){
			one=this._params[i];
			one.indexOfParams=i;
			one.index=1;
			one.value=[one.location,null];
			one.codename=one.name;
			one.name=this._nameMap[one.codename] ? this._nameMap[one.codename] :one.codename;
			this._paramsMap[one.name]=one;
			one._this=this;
			one.uploadedValue=[];
			switch (one.type){
				case /*laya.webgl.WebGLContext.INT*/0x1404:
					one.fun=one.isArray ? this._uniform1iv :this._uniform1i;
					break ;
				case /*laya.webgl.WebGLContext.FLOAT*/0x1406:
					one.fun=one.isArray ? this._uniform1fv :this._uniform1f;
					break ;
				case /*laya.webgl.WebGLContext.FLOAT_VEC2*/0x8B50:
					one.fun=one.isArray ? this._uniform_vec2v:this._uniform_vec2;
					break ;
				case /*laya.webgl.WebGLContext.FLOAT_VEC3*/0x8B51:
					one.fun=one.isArray ? this._uniform_vec3v:this._uniform_vec3;
					break ;
				case /*laya.webgl.WebGLContext.FLOAT_VEC4*/0x8B52:
					one.fun=one.isArray ? this._uniform_vec4v:this._uniform_vec4;
					break ;
				case /*laya.webgl.WebGLContext.SAMPLER_2D*/0x8B5E:
					one.fun=this._uniform_sampler2D;
					break ;
				case /*laya.webgl.WebGLContext.SAMPLER_CUBE*/0x8B60:
					one.fun=this._uniform_samplerCube;
					break ;
				case /*laya.webgl.WebGLContext.FLOAT_MAT4*/0x8B5C:
					one.glfun=gl.uniformMatrix4fv;
					one.fun=this._uniformMatrix4fv;
					break ;
				case /*laya.webgl.WebGLContext.BOOL*/0x8B56:
					one.fun=this._uniform1i;
					break ;
				case /*laya.webgl.WebGLContext.FLOAT_MAT2*/0x8B5A:
				case /*laya.webgl.WebGLContext.FLOAT_MAT3*/0x8B5B:
					throw new Error("compile shader err!");
				default :
					throw new Error("compile shader err!");
				}
		}
	}

	//TODO:coverage
	__proto.getUniform=function(name){
		return this._paramsMap[name];
	}

	//TODO:coverage
	__proto._uniform1f=function(one,value){
		var uploadedValue=one.uploadedValue;
		if (uploadedValue[0]!==value){
			WebGL.mainContext.uniform1f(one.location,uploadedValue[0]=value);
			return 1;
		}
		return 0;
	}

	//TODO:coverage
	__proto._uniform1fv=function(one,value){
		if (value.length < 4){
			var uploadedValue=one.uploadedValue;
			if (uploadedValue[0]!==value[0] || uploadedValue[1]!==value[1] || uploadedValue[2]!==value[2] || uploadedValue[3]!==value[3]){
				WebGL.mainContext.uniform1fv(one.location,value);
				uploadedValue[0]=value[0];
				uploadedValue[1]=value[1];
				uploadedValue[2]=value[2];
				uploadedValue[3]=value[3];
				return 1;
			}
			return 0;
			}else {
			WebGL.mainContext.uniform1fv(one.location,value);
			return 1;
		}
	}

	__proto._uniform_vec2=function(one,value){
		var uploadedValue=one.uploadedValue;
		if (uploadedValue[0]!==value[0] || uploadedValue[1]!==value[1]){
			WebGL.mainContext.uniform2f(one.location,uploadedValue[0]=value[0],uploadedValue[1]=value[1]);
			return 1;
		}
		return 0;
	}

	//TODO:coverage
	__proto._uniform_vec2v=function(one,value){
		if (value.length < 2){
			var uploadedValue=one.uploadedValue;
			if (uploadedValue[0]!==value[0] || uploadedValue[1]!==value[1] || uploadedValue[2]!==value[2] || uploadedValue[3]!==value[3]){
				WebGL.mainContext.uniform2fv(one.location,value);
				uploadedValue[0]=value[0];
				uploadedValue[1]=value[1];
				uploadedValue[2]=value[2];
				uploadedValue[3]=value[3];
				return 1;
			}
			return 0;
			}else {
			WebGL.mainContext.uniform2fv(one.location,value);
			return 1;
		}
	}

	//TODO:coverage
	__proto._uniform_vec3=function(one,value){
		var uploadedValue=one.uploadedValue;
		if (uploadedValue[0]!==value[0] || uploadedValue[1]!==value[1] || uploadedValue[2]!==value[2]){
			WebGL.mainContext.uniform3f(one.location,uploadedValue[0]=value[0],uploadedValue[1]=value[1],uploadedValue[2]=value[2]);
			return 1;
		}
		return 0;
	}

	//TODO:coverage
	__proto._uniform_vec3v=function(one,value){
		WebGL.mainContext.uniform3fv(one.location,value);
		return 1;
	}

	__proto._uniform_vec4=function(one,value){
		var uploadedValue=one.uploadedValue;
		if (uploadedValue[0]!==value[0] || uploadedValue[1]!==value[1] || uploadedValue[2]!==value[2] || uploadedValue[3]!==value[3]){
			WebGL.mainContext.uniform4f(one.location,uploadedValue[0]=value[0],uploadedValue[1]=value[1],uploadedValue[2]=value[2],uploadedValue[3]=value[3]);
			return 1;
		}
		return 0;
	}

	//TODO:coverage
	__proto._uniform_vec4v=function(one,value){
		WebGL.mainContext.uniform4fv(one.location,value);
		return 1;
	}

	//TODO:coverage
	__proto._uniformMatrix2fv=function(one,value){
		WebGL.mainContext.uniformMatrix2fv(one.location,false,value);
		return 1;
	}

	//TODO:coverage
	__proto._uniformMatrix3fv=function(one,value){
		WebGL.mainContext.uniformMatrix3fv(one.location,false,value);
		return 1;
	}

	__proto._uniformMatrix4fv=function(one,value){
		WebGL.mainContext.uniformMatrix4fv(one.location,false,value);
		return 1;
	}

	//TODO:coverage
	__proto._uniform1i=function(one,value){
		var uploadedValue=one.uploadedValue;
		if (uploadedValue[0]!==value){
			WebGL.mainContext.uniform1i(one.location,uploadedValue[0]=value);
			return 1;
		}
		return 0;
	}

	//TODO:coverage
	__proto._uniform1iv=function(one,value){
		WebGL.mainContext.uniform1iv(one.location,value);
		return 1;
	}

	//TODO:coverage
	__proto._uniform_ivec2=function(one,value){
		var uploadedValue=one.uploadedValue;
		if (uploadedValue[0]!==value[0] || uploadedValue[1]!==value[1]){
			WebGL.mainContext.uniform2i(one.location,uploadedValue[0]=value[0],uploadedValue[1]=value[1]);
			return 1;
		}
		return 0;
	}

	//TODO:coverage
	__proto._uniform_ivec2v=function(one,value){
		WebGL.mainContext.uniform2iv(one.location,value);
		return 1;
	}

	//TODO:coverage
	__proto._uniform_vec3i=function(one,value){
		var uploadedValue=one.uploadedValue;
		if (uploadedValue[0]!==value[0] || uploadedValue[1]!==value[1] || uploadedValue[2]!==value[2]){
			WebGL.mainContext.uniform3i(one.location,uploadedValue[0]=value[0],uploadedValue[1]=value[1],uploadedValue[2]=value[2]);
			return 1;
		}
		return 0;
	}

	__proto._uniform_vec3vi=function(one,value){
		WebGL.mainContext.uniform3iv(one.location,value);
		return 1;
	}

	//TODO:coverage
	__proto._uniform_vec4i=function(one,value){
		var uploadedValue=one.uploadedValue;
		if (uploadedValue[0]!==value[0] || uploadedValue[1]!==value[1] || uploadedValue[2]!==value[2] || uploadedValue[3]!==value[3]){
			WebGL.mainContext.uniform4i(one.location,uploadedValue[0]=value[0],uploadedValue[1]=value[1],uploadedValue[2]=value[2],uploadedValue[3]=value[3]);
			return 1;
		}
		return 0;
	}

	//TODO:coverage
	__proto._uniform_vec4vi=function(one,value){
		WebGL.mainContext.uniform4iv(one.location,value);
		return 1;
	}

	__proto._uniform_sampler2D=function(one,value){
		var gl=WebGL.mainContext;
		var uploadedValue=one.uploadedValue;
		if (uploadedValue[0]==null){
			uploadedValue[0]=this._curActTexIndex;
			gl.uniform1i(one.location,this._curActTexIndex);
			WebGLContext.activeTexture(gl,/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0+this._curActTexIndex);
			WebGLContext.bindTexture(gl,/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,value);
			this._curActTexIndex++;
			return 1;
			}else {
			WebGLContext.activeTexture(gl,/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0+uploadedValue[0]);
			WebGLContext.bindTexture(gl,/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,value);
			return 0;
		}
	}

	//TODO:coverage
	__proto._uniform_samplerCube=function(one,value){
		var gl=WebGL.mainContext;
		var uploadedValue=one.uploadedValue;
		if (uploadedValue[0]==null){
			uploadedValue[0]=this._curActTexIndex;
			gl.uniform1i(one.location,this._curActTexIndex);
			WebGLContext.activeTexture(gl,/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0+this._curActTexIndex);
			WebGLContext.bindTexture(gl,/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP*/0x8513,value);
			this._curActTexIndex++;
			return 1;
			}else {
			WebGLContext.activeTexture(gl,/*laya.webgl.WebGLContext.TEXTURE0*/0x84C0+uploadedValue[0]);
			WebGLContext.bindTexture(gl,/*laya.webgl.WebGLContext.TEXTURE_CUBE_MAP*/0x8513,value);
			return 0;
		}
	}

	//TODO:coverage
	__proto._noSetValue=function(one){
		console.log("no....:"+one.name);
	}

	//TODO:coverage
	__proto.uploadOne=function(name,value){
		WebGLContext.useProgram(WebGL.mainContext,this._program);
		var one=this._paramsMap[name];
		one.fun.call(this,one,value);
	}

	__proto.uploadTexture2D=function(value){
		var CTX=WebGLContext;
		if(CTX._activeTextures[0]!==value){
			CTX.bindTexture(WebGL.mainContext,CTX.TEXTURE_2D,value);
			CTX._activeTextures[0]=value;
		}
	}

	/**
	*提交shader到GPU
	*@param shaderValue
	*/
	__proto.upload=function(shaderValue,params){
		BaseShader.activeShader=BaseShader.bindShader=this;
		var gl=WebGL.mainContext;
		WebGLContext.useProgram(gl,this._program);
		if (this._reCompile){
			params=this._params;
			this._reCompile=false;
			}else {
			params=params || this._params;
		};
		var one,value,n=params.length,shaderCall=0;
		for (var i=0;i < n;i++){
			one=params[i];
			if ((value=shaderValue[one.name])!==null)
				shaderCall+=one.fun.call(this,one,value);
		}
		Stat.shaderCall+=shaderCall;
	}

	//TODO:coverage
	__proto.uploadArray=function(shaderValue,length,_bufferUsage){
		BaseShader.activeShader=this;
		BaseShader.bindShader=this;
		WebGLContext.useProgram(WebGL.mainContext,this._program);
		var params=this._params,value;
		var one,shaderCall=0;
		for (var i=length-2;i >=0;i-=2){
			one=this._paramsMap[shaderValue[i]];
			if (!one)
				continue ;
			value=shaderValue[i+1];
			if (value !=null){
				_bufferUsage && _bufferUsage[one.name] && _bufferUsage[one.name].bind();
				shaderCall+=one.fun.call(this,one,value);
			}
		}
		Stat.shaderCall+=shaderCall;
	}

	//TODO:coverage
	__proto.getParams=function(){
		return this._params;
	}

	//TODO:coverage
	__proto.setAttributesLocation=function(attribDesc){
		this._attribInfo=attribDesc;
	}

	Shader.getShader=function(name){
		return Shader.sharders[name];
	}

	Shader.create=function(vs,ps,saveName,nameMap,bindAttrib){
		return new Shader(vs,ps,saveName,nameMap,bindAttrib);
	}

	Shader.withCompile=function(nameID,define,shaderName,createShader){
		if (shaderName && Shader.sharders[shaderName])
			return Shader.sharders[shaderName];
		var pre=Shader._preCompileShader[0.0002 *nameID];
		if (!pre)
			throw new Error("withCompile shader err!"+nameID);
		return pre.createShader(define,shaderName,createShader,null);
	}

	Shader.withCompile2D=function(nameID,mainID,define,shaderName,createShader,bindAttrib){
		if (shaderName && Shader.sharders[shaderName])
			return Shader.sharders[shaderName];
		var pre=Shader._preCompileShader[0.0002 *nameID+mainID];
		if (!pre)
			throw new Error("withCompile shader err!"+nameID+" "+mainID);
		return pre.createShader(define,shaderName,createShader,bindAttrib);
	}

	Shader.addInclude=function(fileName,txt){
		ShaderCompile.addInclude(fileName,txt);
	}

	Shader.preCompile=function(nameID,vs,ps,nameMap){
		var id=0.0002 *nameID;
		Shader._preCompileShader[id]=new ShaderCompile(vs,ps,nameMap);
	}

	Shader.preCompile2D=function(nameID,mainID,vs,ps,nameMap){
		var id=0.0002 *nameID+mainID;
		Shader._preCompileShader[id]=new ShaderCompile(vs,ps,nameMap);
	}

	Shader._createShader=function(gl,str,type){
		var shader=gl.createShader(type);
		gl.shaderSource(shader,str);
		gl.compileShader(shader);
		if(gl.getShaderParameter(shader,/*laya.webgl.WebGLContext.COMPILE_STATUS*/0x8B81)){
			return shader;
			}else{
			console.log(gl.getShaderInfoLog(shader));
			return null;
		}
	}

	Shader._count=0;
	Shader._preCompileShader={};
	Shader.SHADERNAME2ID=0.0002;
	Shader.sharders=new Array(0x20);
	__static(Shader,
	['nameKey',function(){return this.nameKey=new StringKey();}
	]);
	return Shader;
})(BaseShader)


/**
*<code>RenderTexture</code> 类用于创建渲染目标。
*/
//class laya.webgl.resource.RenderTexture2D extends laya.webgl.resource.BaseTexture
var RenderTexture2D=(function(_super){
	function RenderTexture2D(width,height,format,depthStencilFormat){
		//this._lastRT=null;
		//this._lastWidth=NaN;
		//this._lastHeight=NaN;
		/**@private */
		//this._frameBuffer=null;
		/**@private */
		//this._depthStencilBuffer=null;
		/**@private */
		//this._depthStencilFormat=0;
		this._mgrKey=0;
		(format===void 0)&& (format=0);
		(depthStencilFormat===void 0)&& (depthStencilFormat=/*laya.webgl.resource.BaseTexture.FORMAT_DEPTH_16*/0);
		RenderTexture2D.__super.call(this,format,false);
		this._glTextureType=/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1;
		this._width=width;
		this._height=height;
		this._depthStencilFormat=depthStencilFormat;
		this._create(width,height);
	}

	__class(RenderTexture2D,'laya.webgl.resource.RenderTexture2D',_super);
	var __proto=RenderTexture2D.prototype;
	__proto.getIsReady=function(){
		return true;
	}

	/**
	*@private
	*/
	__proto._create=function(width,height){
		var gl=LayaGL.instance;
		this._frameBuffer=gl.createFramebuffer();
		WebGLContext.bindTexture(gl,this._glTextureType,this._glTexture);
		var glFormat=this._getGLFormat();
		gl.texImage2D(this._glTextureType,0,glFormat,width,height,0,glFormat,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,null);
		this._setGPUMemory(width *height *4);
		gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,this._frameBuffer);
		gl.framebufferTexture2D(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,/*laya.webgl.WebGLContext.COLOR_ATTACHMENT0*/0x8CE0,/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,this._glTexture,0);
		if (this._depthStencilFormat!==/*laya.webgl.resource.BaseTexture.FORMAT_DEPTHSTENCIL_NONE*/3){
			this._depthStencilBuffer=gl.createRenderbuffer();
			gl.bindRenderbuffer(/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,this._depthStencilBuffer);
			switch (this._depthStencilFormat){
				case /*laya.webgl.resource.BaseTexture.FORMAT_DEPTH_16*/0:
					gl.renderbufferStorage(/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,/*laya.webgl.WebGLContext.DEPTH_COMPONENT16*/0x81A5,width,height);
					gl.framebufferRenderbuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,/*laya.webgl.WebGLContext.DEPTH_ATTACHMENT*/0x8D00,/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,this._depthStencilBuffer);
					break ;
				case /*laya.webgl.resource.BaseTexture.FORMAT_STENCIL_8*/1:
					gl.renderbufferStorage(/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,/*laya.webgl.WebGLContext.STENCIL_INDEX8*/0x8D48,width,height);
					gl.framebufferRenderbuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,/*laya.webgl.WebGLContext.STENCIL_ATTACHMENT*/0x8D20,/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,this._depthStencilBuffer);
					break ;
				case /*laya.webgl.resource.BaseTexture.FORMAT_DEPTHSTENCIL_16_8*/2:
					gl.renderbufferStorage(/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,/*laya.webgl.WebGLContext.DEPTH_STENCIL*/0x84F9,width,height);
					gl.framebufferRenderbuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,/*laya.webgl.WebGLContext.DEPTH_STENCIL_ATTACHMENT*/0x821A,/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,this._depthStencilBuffer);
					break ;
				default :
					console.log("RenderTexture: unkonw depth format.");
				}
		}
		gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,null);
		gl.bindRenderbuffer(/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,null);
		this._setWarpMode(/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,this._wrapModeU);
		this._setWarpMode(/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,this._wrapModeV);
		this._setFilterMode(this._filterMode);
		this._setAnisotropy(this._anisoLevel);
		this._readyed=true;
		this._activeResource();
	}

	/**
	*生成mipMap。
	*/
	__proto.generateMipmap=function(){
		if (this._isPot(this.width)&& this._isPot(this.height)){
			this._mipmap=true;
			LayaGL.instance.generateMipmap(this._glTextureType);
			this._setFilterMode(this._filterMode);
			this._setGPUMemory(this.width *this.height *4 *(1+1 / 3));
			}else {
			this._mipmap=false;
			this._setGPUMemory(this.width *this.height *4);
		}
	}

	/**
	*开始绑定。
	*/
	__proto.start=function(){
		var gl=LayaGL.instance;
		LayaGL.instance.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,this._frameBuffer);
		RenderTexture2D._currentActive=this;
		this._readyed=true;
		gl.viewport(0,0,this._width,this._height);
		this._lastWidth=RenderState2D.width;
		this._lastHeight=RenderState2D.height;
		RenderState2D.width=this._width;
		RenderState2D.height=this._height;
		BaseShader.activeShader=null;
	}

	/**
	*结束绑定。
	*/
	__proto.end=function(){
		LayaGL.instance.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,null);
		RenderTexture2D._currentActive=null;
		this._readyed=true;
	}

	/**
	*恢复上一次的RenderTarge.由于使用自己保存的，所以如果被外面打断了的话，会出错。
	*/
	__proto.restore=function(){
		var gl=LayaGL.instance;
		if (this._lastRT !=RenderTexture2D._currentActive){
			LayaGL.instance.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,this._lastRT?this._lastRT._frameBuffer:null);
			RenderTexture2D._currentActive=this._lastRT;
		}
		this._readyed=true;
		gl.viewport(0,0,this._lastWidth,this._lastHeight);
		RenderState2D.width=this._lastWidth;
		RenderState2D.height=this._lastHeight;
		BaseShader.activeShader=null;
	}

	// gl.viewport(0,0,Laya.stage.width,Laya.stage.height);
	__proto.clear=function(r,g,b,a){
		(r===void 0)&& (r=0.0);
		(g===void 0)&& (g=0.0);
		(b===void 0)&& (b=0.0);
		(a===void 0)&& (a=1.0);
		var gl=LayaGL.instance;
		gl.clearColor(r,g,b,a);
		var clearFlag=/*laya.webgl.WebGLContext.COLOR_BUFFER_BIT*/0x00004000;
		switch (this._depthStencilFormat){
			case /*laya.webgl.WebGLContext.DEPTH_COMPONENT16*/0x81A5:
				clearFlag |=/*laya.webgl.WebGLContext.DEPTH_BUFFER_BIT*/0x00000100;
				break ;
			case /*laya.webgl.WebGLContext.STENCIL_INDEX8*/0x8D48:
				clearFlag |=/*laya.webgl.WebGLContext.STENCIL_BUFFER_BIT*/0x00000400;
				break ;
			case /*laya.webgl.WebGLContext.DEPTH_STENCIL*/0x84F9:
				clearFlag |=/*laya.webgl.WebGLContext.DEPTH_BUFFER_BIT*/0x00000100;
				clearFlag |=/*laya.webgl.WebGLContext.STENCIL_BUFFER_BIT*/0x00000400
				break ;
			}
		gl.clear(clearFlag);
	}

	/**
	*获得像素数据。
	*@param x X像素坐标。
	*@param y Y像素坐标。
	*@param width 宽度。
	*@param height 高度。
	*@return 像素数据。
	*/
	__proto.getData=function(x,y,width,height){
		var gl=LayaGL.instance;
		gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,this._frameBuffer);
		var canRead=(gl.checkFramebufferStatus(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40)===/*laya.webgl.WebGLContext.FRAMEBUFFER_COMPLETE*/0x8CD5);
		if (!canRead){
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,null);
			return null;
		};
		var pixels=new Uint8Array(this._width *this._height *4);
		var glFormat=this._getGLFormat();
		gl.readPixels(x,y,width,height,glFormat,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,pixels);
		gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,null);
		return pixels;
	}

	__proto.recycle=function(){}
	/**
	*@inheritDoc
	*/
	__proto._disposeResource=function(){
		if (this._frameBuffer){
			var gl=LayaGL.instance;
			gl.deleteTexture(this._glTexture);
			gl.deleteFramebuffer(this._frameBuffer);
			gl.deleteRenderbuffer(this._depthStencilBuffer);
			this._glTexture=null;
			this._frameBuffer=null;
			this._depthStencilBuffer=null;
			this._setGPUMemory(0);
		}
	}

	/**
	*获取深度格式。
	*@return 深度格式。
	*/
	__getset(0,__proto,'depthStencilFormat',function(){
		return this._depthStencilFormat;
	});

	/**
	*@inheritDoc
	*/
	__getset(0,__proto,'defaulteTexture',function(){
		return Texture2D.grayTexture;
	});

	/**
	*获取宽度。
	*/
	__getset(0,__proto,'sourceWidth',function(){
		return this._width;
	});

	/***
	*获取高度。
	*/
	__getset(0,__proto,'sourceHeight',function(){
		return this._height;
	});

	/**
	*获取offsetX。
	*/
	__getset(0,__proto,'offsetX',function(){
		return 0;
	});

	/***
	*获取offsetY
	*/
	__getset(0,__proto,'offsetY',function(){
		return 0;
	});

	/**
	*获取当前激活的Rendertexture
	*/
	__getset(1,RenderTexture2D,'currentActive',function(){
		return RenderTexture2D._currentActive;
	},laya.webgl.resource.BaseTexture._$SET_currentActive);

	RenderTexture2D.pushRT=function(){
		RenderTexture2D.rtStack.push({rt:RenderTexture2D._currentActive,w:RenderState2D.width,h:RenderState2D.height});
	}

	RenderTexture2D.popRT=function(){
		var gl=LayaGL.instance;
		var top=RenderTexture2D.rtStack.pop();
		if (top){
			if (RenderTexture2D._currentActive !=top.rt){
				LayaGL.instance.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,top.rt?top.rt._frameBuffer:null);
				RenderTexture2D._currentActive=top.rt;
			}
			gl.viewport(0,0,top.w,top.h);
			RenderState2D.width=top.w;
			RenderState2D.height=top.h;
		}
	}

	RenderTexture2D._currentActive=null;
	RenderTexture2D.rtStack=[];
	__static(RenderTexture2D,
	['defuv',function(){return this.defuv=[0,0,1,0,1,1,0,1];},'flipyuv',function(){return this.flipyuv=[0,1,1,1,1,0,0,0];}
	]);
	return RenderTexture2D;
})(BaseTexture)


/**
*<code>Texture2D</code> 类用于生成2D纹理。
*/
//class laya.webgl.resource.Texture2D extends laya.webgl.resource.BaseTexture
var Texture2D=(function(_super){
	function Texture2D(width,height,format,mipmap,canRead){
		/**@private */
		//this._canRead=false;
		/**@private */
		//this._pixels=null;
		(width===void 0)&& (width=0);
		(height===void 0)&& (height=0);
		(format===void 0)&& (format=1);
		(mipmap===void 0)&& (mipmap=true);
		(canRead===void 0)&& (canRead=false);
		Texture2D.__super.call(this,format,mipmap);
		this._glTextureType=/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1;
		this._width=width;
		this._height=height;
		this._canRead=canRead;
		this._setWarpMode(/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,this._wrapModeU);
		this._setWarpMode(/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,this._wrapModeV);
		Config.is2DPixelArtGame && (this._filterMode=/*laya.webgl.resource.BaseTexture.FILTERMODE_POINT*/0);
		this._setFilterMode(this._filterMode);
		this._setAnisotropy(this._anisoLevel);
	}

	__class(Texture2D,'laya.webgl.resource.Texture2D',_super);
	var __proto=Texture2D.prototype;
	/**
	*@private
	*/
	__proto._calcualatesCompressedDataSize=function(format,width,height){
		switch (format){
			case 3:
			case 5:
				return ((width+3)>> 2)*((height+3)>> 2)*8;
			case 4:
				return ((width+3)>> 2)*((height+3)>> 2)*16;
			case 11:
			case 12:
				return Math.floor((Math.max(width,8)*Math.max(height,8)*4+7)/ 8);
			case 9:
			case 10:
				return Math.floor((Math.max(width,16)*Math.max(height,8)*2+7)/ 8);
			default :
				return 0;
			}
	}

	/**
	*@private
	*/
	__proto._pharseDDS=function(arrayBuffer){
		var FOURCC_DXT1=827611204;
		var FOURCC_DXT5=894720068;
		var DDPF_FOURCC=0x4;
		var DDSD_MIPMAPCOUNT=0x20000;
		var DDS_MAGIC=0x20534444;
		var DDS_HEADER_LENGTH=31;
		var DDS_HEADER_MAGIC=0;
		var DDS_HEADER_SIZE=1;
		var DDS_HEADER_FLAGS=2;
		var DDS_HEADER_HEIGHT=3;
		var DDS_HEADER_WIDTH=4;
		var DDS_HEADER_MIPMAPCOUNT=7;
		var DDS_HEADER_PF_FLAGS=20;
		var DDS_HEADER_PF_FOURCC=21;
		var header=new Int32Array(arrayBuffer,0,DDS_HEADER_LENGTH);
		if (header[DDS_HEADER_MAGIC] !=DDS_MAGIC)
			throw "Invalid magic number in DDS header";
		if (!(header[DDS_HEADER_PF_FLAGS] & DDPF_FOURCC))
			throw "Unsupported format, must contain a FourCC code";
		var compressedFormat=header[DDS_HEADER_PF_FOURCC];
		switch (this._format){
			case 3:
				if (compressedFormat!==FOURCC_DXT1)
					throw "the FourCC code is not same with texture format.";
				break ;
			case 4:
				if (compressedFormat!==FOURCC_DXT5)
					throw "the FourCC code is not same with texture format.";
				break ;
			default :
				throw "unknown texture format.";
			};
		var mipLevels=1;
		if (header[DDS_HEADER_FLAGS] & DDSD_MIPMAPCOUNT){
			mipLevels=Math.max(1,header[DDS_HEADER_MIPMAPCOUNT]);
			if (!this._mipmap)
				throw "the mipmap is not same with Texture2D.";
			}else {
			if (this._mipmap)
				throw "the mipmap is not same with Texture2D.";
		};
		var width=header[DDS_HEADER_WIDTH];
		var height=header[DDS_HEADER_HEIGHT];
		this._width=width;
		this._height=height;
		var dataOffset=header[DDS_HEADER_SIZE]+4;
		this._upLoadCompressedTexImage2D(arrayBuffer,width,height,mipLevels,dataOffset,0);
	}

	/**
	*@private
	*/
	__proto._pharseKTX=function(arrayBuffer){
		var PVR_FORMAT_2BPP_RGB=0;
		var PVR_FORMAT_2BPP_RGBA=1;
		var PVR_FORMAT_4BPP_RGB=2;
		var PVR_FORMAT_4BPP_RGBA=3;
		var PVR_FORMAT_ETC1=6;
		var PVR_MAGIC=0x03525650;
		var ETC_HEADER_LENGTH=13;
		var ETC_HEADER_FORMAT=4;
		var ETC_HEADER_HEIGHT=7;
		var ETC_HEADER_WIDTH=6;
		var ETC_HEADER_MIPMAPCOUNT=11;
		var ETC_HEADER_METADATA=12;
		var id=new Uint8Array(arrayBuffer,0,12);
		if (id[0] !=0xAB || id[1] !=0x4B || id[2] !=0x54 || id[3] !=0x58 || id[4] !=0x20 || id[5] !=0x31 || id[6] !=0x31 || id[7] !=0xBB || id[8] !=0x0D || id[9] !=0x0A || id[10] !=0x1A || id[11] !=0x0A)
			throw("Invalid fileIdentifier in KTX header");
		var header=new Int32Array(id.buffer,id.length,ETC_HEADER_LENGTH);
		var compressedFormat=header[ETC_HEADER_FORMAT];
		var innerFormat=this._getGLFormat();
		switch (this._format){
			case 5:
				if (compressedFormat!==innerFormat)
					throw "the format  is not same with texture format FORMAT_ETC1RGB.";
				break ;
			default :
				throw "unknown texture format.";
			};
		var mipLevels=header[ETC_HEADER_MIPMAPCOUNT];
		var width=header[ETC_HEADER_WIDTH];
		var height=header[ETC_HEADER_HEIGHT];
		this._width=width;
		this._height=height;
		var dataOffset=64+header[ETC_HEADER_METADATA];
		this._upLoadCompressedTexImage2D(arrayBuffer,width,height,mipLevels,dataOffset,4);
	}

	/**
	*@private
	*/
	__proto._pharsePVR=function(arrayBuffer){
		var PVR_FORMAT_2BPP_RGB=0;
		var PVR_FORMAT_2BPP_RGBA=1;
		var PVR_FORMAT_4BPP_RGB=2;
		var PVR_FORMAT_4BPP_RGBA=3;
		var PVR_FORMAT_ETC1=6;
		var PVR_MAGIC=0x03525650;
		var PVR_HEADER_LENGTH=13;
		var PVR_HEADER_MAGIC=0;
		var PVR_HEADER_FORMAT=2;
		var PVR_HEADER_HEIGHT=6;
		var PVR_HEADER_WIDTH=7;
		var PVR_HEADER_MIPMAPCOUNT=11;
		var PVR_HEADER_METADATA=12;
		var header=new Int32Array(arrayBuffer,0,PVR_HEADER_LENGTH);
		if (header[PVR_HEADER_MAGIC] !=PVR_MAGIC)
			throw("Invalid magic number in PVR header");
		var compressedFormat=header[PVR_HEADER_FORMAT];
		switch (this._format){
			case 5:
				if (compressedFormat!==PVR_FORMAT_ETC1)
					throw "the format  is not same with texture format FORMAT_ETC1RGB.";
				break ;
			case 9:
				if (compressedFormat!==PVR_FORMAT_2BPP_RGB)
					throw "the format  is not same with texture format FORMAT_PVRTCRGB_2BPPV.";
				break ;
			case 11:
				if (compressedFormat!==PVR_FORMAT_4BPP_RGB)
					throw "the format  is not same with texture format FORMAT_PVRTCRGB_4BPPV.";
				break ;
			case 10:
				if (compressedFormat!==PVR_FORMAT_2BPP_RGBA)
					throw "the format  is not same with texture format FORMAT_PVRTCRGBA_2BPPV.";
				break ;
			case 12:
				if (compressedFormat!==PVR_FORMAT_4BPP_RGBA)
					throw "the format  is not same with texture format FORMAT_PVRTCRGBA_4BPPV.";
				break ;
			default :
				throw "unknown texture format.";
			};
		var mipLevels=header[PVR_HEADER_MIPMAPCOUNT];
		var width=header[PVR_HEADER_WIDTH];
		var height=header[PVR_HEADER_HEIGHT];
		this._width=width;
		this._height=height;
		var dataOffset=header[PVR_HEADER_METADATA]+52;
		this._upLoadCompressedTexImage2D(arrayBuffer,width,height,mipLevels,dataOffset,0);
	}

	/**
	*@private
	*/
	__proto._upLoadCompressedTexImage2D=function(data,width,height,miplevelCount,dataOffset,imageSizeOffset){
		var gl=LayaGL.instance;
		var textureType=this._glTextureType;
		WebGLContext.bindTexture(gl,textureType,this._glTexture);
		var glFormat=this._getGLFormat();
		var offset=dataOffset;
		for (var i=0;i < miplevelCount;i++){
			offset+=imageSizeOffset;
			var mipDataSize=this._calcualatesCompressedDataSize(this._format,width,height);
			var mipData=new Uint8Array(data,offset,mipDataSize);
			gl.compressedTexImage2D(textureType,i,glFormat,width,height,0,mipData);
			width=width >> 1;
			height=height >> 1;
			offset+=mipDataSize;
		};
		var memory=offset;
		this._setGPUMemory(memory);
		this._readyed=true;
		this._activeResource();
	}

	/**
	*通过图片源填充纹理,可为HTMLImageElement、HTMLCanvasElement、HTMLVideoElement、ImageBitmap、ImageData,
	*设置之后纹理宽高可能会发生变化。
	*/
	__proto.loadImageSource=function(source,premultiplyAlpha){
		(premultiplyAlpha===void 0)&& (premultiplyAlpha=false);
		var width=source.width;
		var height=source.height;
		this._width=width;
		this._height=height;
		this._setWarpMode(/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,this._wrapModeU);
		this._setWarpMode(/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,this._wrapModeV);
		this._setFilterMode(this._filterMode);
		var gl=LayaGL.instance;
		WebGLContext.bindTexture(gl,this._glTextureType,this._glTexture);
		var glFormat=this._getGLFormat();
		if (Render.isConchApp){
			source.setPremultiplyAlpha(premultiplyAlpha);
			gl.texImage2D(this._glTextureType,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,source);
			}else {
			(premultiplyAlpha)&& (gl.pixelStorei(/*laya.webgl.WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL*/0x9241,true));
			gl.texImage2D(this._glTextureType,0,glFormat,glFormat,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,source);
			(premultiplyAlpha)&& (gl.pixelStorei(/*laya.webgl.WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL*/0x9241,false));
		}
		if (this._mipmap && this._isPot(width)&& this._isPot(height)){
			gl.generateMipmap(this._glTextureType);
			this._setGPUMemory(width *height *4 *(1+1 / 3));
			}else {
			this._setGPUMemory(width *height *4);
		}
		if (this._canRead){
			if (Render.isConchApp){
				this._pixels=new Uint8Array(source._nativeObj.getImageData(0,0,width,height));
				}else {
				Browser.canvas.size(width,height);
				Browser.canvas.clear();
				Browser.context.drawImage(source,0,0,width,height);
				this._pixels=new Uint8Array(Browser.context.getImageData(0,0,width,height).data.buffer);
			}
		}
		this._readyed=true;
		this._activeResource();
	}

	/**
	*通过像素填充纹理。
	*@param pixels 像素。
	*@param miplevel 层级。
	*/
	__proto.setPixels=function(pixels,miplevel){
		(miplevel===void 0)&& (miplevel=0);
		if (!pixels)
			throw "Texture2D:pixels can't be null.";
		var width=this._width;
		var height=this._height;
		var gl=LayaGL.instance;
		var textureType=this._glTextureType;
		WebGLContext.bindTexture(gl,textureType,this._glTexture);
		var glFormat=this._getGLFormat();
		gl.texImage2D(textureType,miplevel,glFormat,width,height,0,glFormat,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,pixels);
		if (this._mipmap && this._isPot(width)&& this._isPot(height)){
			gl.generateMipmap(textureType);
			this._setGPUMemory(width *height *4 *(1+1 / 3));
			}else {
			this._setGPUMemory(width *height *4);
		}
		if (this._canRead)
			this._pixels=pixels;
		this._readyed=true;
		this._activeResource();
	}

	/**
	*通过压缩数据填充纹理。
	*@param data 压缩数据。
	*@param miplevel 层级。
	*/
	__proto.setCompressData=function(data){
		switch (this._format){
			case 3:
			case 4:
				this._pharseDDS(data);
				break ;
			case 5:
				this._pharseKTX(data);
				break ;
			case 9:
			case 10:
			case 11:
			case 12:
				this._pharsePVR(data);
				break ;
			default :
				throw "Texture2D:unkonwn format.";
			}
	}

	/**
	*@inheritDoc
	*/
	__proto._recoverResource=function(){}
	/**
	*返回图片像素。
	*@return 图片像素。
	*/
	__proto.getPixels=function(){
		if (this._canRead)
			return this._pixels;
		else
		throw new Error("Texture2D: must set texture canRead is true.");
	}

	/**
	*@inheritDoc
	*/
	__getset(0,__proto,'defaulteTexture',function(){
		return laya.webgl.resource.Texture2D.grayTexture;
	});

	Texture2D.__init__=function(){
		var pixels=new Uint8Array(3);
		pixels[0]=128;
		pixels[1]=128;
		pixels[2]=128;
		Texture2D.grayTexture=new Texture2D(1,1,0,false,false);
		Texture2D.grayTexture.setPixels(pixels);
		Texture2D.grayTexture.lock=true;
	}

	Texture2D._parse=function(data,propertyParams,constructParams){
		var texture=constructParams ? new Texture2D(constructParams[0],constructParams[1],constructParams[2],constructParams[3],constructParams[4]):new Texture2D(0,0);
		if (propertyParams){
			texture.wrapModeU=propertyParams.wrapModeU;
			texture.wrapModeV=propertyParams.wrapModeV;
			texture.filterMode=propertyParams.filterMode;
			texture.anisoLevel=propertyParams.anisoLevel;
		}
		switch (texture._format){
			case 0:
			case 1:
				texture.loadImageSource(data);
				break ;
			case 3:
			case 4:
			case 5:
			case 9:
			case 10:
			case 11:
			case 12:
				texture.setCompressData(data);
				break ;
			default :
				throw "Texture2D:unkonwn format.";
			}
		return texture;
	}

	Texture2D.load=function(url,complete){
		Laya.loader.create(url,complete,null,/*laya.net.Loader.TEXTURE2D*/"TEXTURE2D");
	}

	Texture2D.grayTexture=null;
	return Texture2D;
})(BaseTexture)


//class laya.webgl.shader.d2.Shader2X extends laya.webgl.shader.Shader
var Shader2X=(function(_super){
	function Shader2X(vs,ps,saveName,nameMap,bindAttrib){
		this._params2dQuick2=null;
		this._shaderValueWidth=0;
		this._shaderValueHeight=0;
		Shader2X.__super.call(this,vs,ps,saveName,nameMap,bindAttrib);
	}

	__class(Shader2X,'laya.webgl.shader.d2.Shader2X',_super);
	var __proto=Shader2X.prototype;
	//TODO:coverage
	__proto._disposeResource=function(){
		_super.prototype._disposeResource.call(this);
		this._params2dQuick2=null;
	}

	//TODO:coverage
	__proto.upload2dQuick2=function(shaderValue){
		this.upload(shaderValue,this._params2dQuick2 || this._make2dQuick2());
	}

	//去掉size的所有的uniform
	__proto._make2dQuick2=function(){
		if (!this._params2dQuick2){
			this._params2dQuick2=[];
			var params=this._params,one;
			for (var i=0,n=params.length;i < n;i++){
				one=params[i];
				if (one.name!=="size")this._params2dQuick2.push(one);
			}
		}
		return this._params2dQuick2;
	}

	Shader2X.create=function(vs,ps,saveName,nameMap,bindAttrib){
		return new Shader2X(vs,ps,saveName,nameMap,bindAttrib);
	}

	return Shader2X;
})(Shader)


	Laya.__init([CharBook,Path,WebGLContext2D]);
})(window,document,Laya);
