
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Bezier=laya.maths.Bezier,Bitmap=laya.resource.Bitmap,Browser=laya.utils.Browser,ColorFilter=laya.filters.ColorFilter;
	var ColorUtils=laya.utils.ColorUtils,Config=Laya.Config,Context=laya.resource.Context,DrawImageCmd=laya.display.cmd.DrawImageCmd;
	var Event=laya.events.Event,FillTextCmd=laya.display.cmd.FillTextCmd,Filter=laya.filters.Filter,FontInfo=laya.utils.FontInfo;
	var HTMLCanvas=laya.resource.HTMLCanvas,HTMLChar=laya.utils.HTMLChar,HTMLImage=laya.resource.HTMLImage,Handler=laya.utils.Handler;
	var Loader=laya.net.Loader,Matrix=laya.maths.Matrix,Point=laya.maths.Point,Rectangle=laya.maths.Rectangle;
	var Render=laya.renders.Render,RenderSprite=laya.renders.RenderSprite,Resource=laya.resource.Resource,RestoreCmd=laya.display.cmd.RestoreCmd;
	var RotateCmd=laya.display.cmd.RotateCmd,RunDriver=laya.utils.RunDriver,SaveCmd=laya.display.cmd.SaveCmd;
	var ScaleCmd=laya.display.cmd.ScaleCmd,Sprite=laya.display.Sprite,SpriteConst=laya.display.SpriteConst,SpriteStyle=laya.display.css.SpriteStyle;
	var Stage=laya.display.Stage,Stat=laya.utils.Stat,StringKey=laya.utils.StringKey,System=laya.system.System;
	var Text=laya.display.Text,Texture=laya.resource.Texture,TransformCmd=laya.display.cmd.TransformCmd,TranslateCmd=laya.display.cmd.TranslateCmd;
	var VectorGraphManager=laya.utils.VectorGraphManager,WordText=laya.utils.WordText;
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
		if (!Render.isConchApp && TextRender.scaleFontWithCtx){
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
							add.push({ri:ri,x:stx+1/this.fontScaleX,y:sty/this.fontScaleY,w:(ri.bmpWidth-2)/ this.fontScaleX,h:(ri.bmpHeight-1)/ this.fontScaleY });
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
					sameTexData[0]=[{ri:ri,x:1/this.fontScaleX,y:0/this.fontScaleY,w:(ri.bmpWidth-2)/ this.fontScaleX,h:(ri.bmpHeight-1)/ this.fontScaleY }];
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
			this.fontSizeW=this.charRender.getWidth(fontstr,'有')*1.5;
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
		bmpdt=this.charRender.getCharBmp('有',fontstr,0,'red',null,TextRender.tmpRI,oriy,oriy,marginr,marginb);
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
		if (shaderData._runtimeCopyValues.length > 0){
			nType=/*laya.layagl.LayaGL.UPLOAD_SHADER_UNIFORM_TYPE_DATA*/1;
		};
		var data=shaderData._data;
		return layaGL.uploadShaderUniforms(commandEncoder,data,nType);
	}

	return LayaGLRunner;
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
*@private
*<code>ShaderCompile</code> 类用于实现Shader编译。
*/
//class laya.webgl.utils.ShaderCompile
var ShaderCompile=(function(){
	function ShaderCompile(vs,ps,nameMap,defs){
		//this._nameMap=null;
		//this._VS=null;
		//this._PS=null;
		this._clearCR=new RegExp("\r","g");
		var _$this=this;
		function _compile (script){
			script=script.replace(_$this._clearCR,"");
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
		laya.webgl.WebGLContext._checkExtensions(gl);
		if (!WebGL._isWebGL2 && !Render.isConchApp){
			VertexArrayObject;
			if (window._setupVertexArrayObject){
				if (Browser.onBDMiniGame||Browser.onLimixiu)
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
		if (!Render.supportWebGLPlusRendering)return;
		var webGLContext=WebGLContext;
		webGLContext.activeTexture=webGLContext.activeTextureForNative;
		webGLContext.bindTexture=webGLContext.bindTextureForNative;
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
		Shader.prototype.uploadTexture2D=function (value){
			var CTX=WebGLContext;
			CTX.bindTexture(laya.webgl.WebGL.mainContext,CTX.TEXTURE_2D,value);
		}
		RenderState2D.width=Browser.window.innerWidth;
		RenderState2D.height=Browser.window.innerHeight;
		RunDriver.measureText=function (txt,font){
			window["conchTextCanvas"].font=font;
			return window["conchTextCanvas"].measureText(txt);
		}
		RunDriver.enableNative=function (){
			if (Render.supportWebGLPlusRendering){
				(LayaGLRunner).uploadShaderUniforms=LayaGLRunner.uploadShaderUniformsForNative;
				/*__JS__ */CommandEncoder=window.GLCommandEncoder;
				/*__JS__ */LayaGL=window.LayaGLContext;
			};
			var stage=Stage;
			stage.prototype.render=stage.prototype.renderToNative;
			if (Render.isConchApp){
				ConchPropertyAdpt.rewriteProperties();
			}
		}
		RunDriver.clear=function (color){
			var c=ColorUtils.create(color).arrColor;
			var gl=LayaGL.instance;
			if (c)gl.clearColor(c[0],c[1],c[2],c[3]);
			gl.clear(/*laya.webgl.WebGLContext.COLOR_BUFFER_BIT*/0x00004000 | /*laya.webgl.WebGLContext.DEPTH_BUFFER_BIT*/0x00000100 | /*laya.webgl.WebGLContext.STENCIL_BUFFER_BIT*/0x00000400);
		}
		RunDriver.drawToCanvas=function (sprite,_renderType,canvasWidth,canvasHeight,offsetX,offsetY){
			offsetX-=sprite.x;
			offsetY-=sprite.y;
			offsetX |=0;
			offsetY |=0;
			canvasWidth |=0;
			canvasHeight |=0;
			var canv=new HTMLCanvas(false);
			var ctx=canv.getContext('2d');
			canv.size(canvasWidth,canvasHeight);
			ctx.asBitmap=true;
			ctx._targets.start();
			RenderSprite.renders[_renderType]._fun(sprite,ctx,offsetX,offsetY);
			ctx.flush();
			ctx._targets.end();
			ctx._targets.restore();
			return canv;
		}
		RenderTexture2D.prototype.getData=function (x,y,width,height,callBack){
			var gl=LayaGL.instance;
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,this._frameBuffer);
			gl.readPixelsAsync(x,y,width,height,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,function(data){
				/*__JS__ */callBack(data);
			});
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,null);
		}
		RenderTexture2D.prototype._uv=RenderTexture2D.flipyuv;
		Object["defineProperty"](RenderTexture2D.prototype,"uv",{
			"get":function (){
				return this._uv;
			},
			"set":function (v){
				this._uv=v;
			}
		});
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
		HTMLImage.create=function (width,height,format){
			var tex=new Texture2D(width,height,format,false,false);
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
		WebGL._webglRender_enable();
		if (Render.isConchApp){
			WebGL._nativeRender_enable();
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
		vs="/*\n	texture和fillrect使用的。\n*/\nattribute vec4 posuv;\nattribute vec4 attribColor;\nattribute vec4 attribFlags;\n//attribute vec4 clipDir;\n//attribute vec2 clipRect;\nuniform vec4 clipMatDir;\nuniform vec2 clipMatPos;		// 这个是全局的，不用再应用矩阵了。\nvarying vec2 cliped;\nuniform vec2 size;\n\n#ifdef WORLDMAT\n	uniform mat4 mmat;\n#endif\n#ifdef MVP3D\n	uniform mat4 u_MvpMatrix;\n#endif\nvarying vec4 v_texcoordAlpha;\nvarying vec4 v_color;\nvarying float v_useTex;\n\nvoid main() {\n\n	vec4 pos = vec4(posuv.xy,0.,1.);\n#ifdef WORLDMAT\n	pos=mmat*pos;\n#endif\n	vec4 pos1  =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,0.,1.0);\n#ifdef MVP3D\n	gl_Position=u_MvpMatrix*pos1;\n#else\n	gl_Position=pos1;\n#endif\n	v_texcoordAlpha.xy = posuv.zw;\n	//v_texcoordAlpha.z = attribColor.a/255.0;\n	v_color = attribColor/255.0;\n	v_color.xyz*=v_color.w;//反正后面也要预乘\n	\n	v_useTex = attribFlags.r/255.0;\n	float clipw = length(clipMatDir.xy);\n	float cliph = length(clipMatDir.zw);\n	vec2 clippos = pos.xy - clipMatPos.xy;	//pos已经应用矩阵了，为了减的有意义，clip的位置也要缩放\n	if(clipw>20000. && cliph>20000.)\n		cliped = vec2(0.5,0.5);\n	else {\n		//转成0到1之间。/clipw/clipw 表示clippos与normalize之后的clip朝向点积之后，再除以clipw\n		cliped=vec2( dot(clippos,clipMatDir.xy)/clipw/clipw, dot(clippos,clipMatDir.zw)/cliph/cliph);\n	}\n\n}";
		ps="/*\n	texture和fillrect使用的。\n*/\n\nprecision mediump float;\n//precision highp float;\nvarying vec4 v_texcoordAlpha;\nvarying vec4 v_color;\nvarying float v_useTex;\nuniform sampler2D texture;\nvarying vec2 cliped;\n\n#ifdef BLUR_FILTER\nuniform vec4 strength_sig2_2sig2_gauss1;\nuniform vec2 blurInfo;\n\n#define PI 3.141593\n\nfloat getGaussian(float x, float y){\n    return strength_sig2_2sig2_gauss1.w*exp(-(x*x+y*y)/strength_sig2_2sig2_gauss1.z);\n}\n\nvec4 blur(){\n    const float blurw = 9.0;\n    vec4 vec4Color = vec4(0.0,0.0,0.0,0.0);\n    vec2 halfsz=vec2(blurw,blurw)/2.0/blurInfo;    \n    vec2 startpos=v_texcoordAlpha.xy-halfsz;\n    vec2 ctexcoord = startpos;\n    vec2 step = 1.0/blurInfo;  //每个像素      \n    \n    for(float y = 0.0;y<=blurw; ++y){\n        ctexcoord.x=startpos.x;\n        for(float x = 0.0;x<=blurw; ++x){\n            //TODO 纹理坐标的固定偏移应该在vs中处理\n            vec4Color += texture2D(texture, ctexcoord)*getGaussian(x-blurw/2.0,y-blurw/2.0);\n            ctexcoord.x+=step.x;\n        }\n        ctexcoord.y+=step.y;\n    }\n    return vec4Color;\n}\n#endif\n\n#ifdef COLOR_FILTER\nuniform vec4 colorAlpha;\nuniform mat4 colorMat;\n#endif\n\n#ifdef GLOW_FILTER\nuniform vec4 u_color;\nuniform vec4 u_blurInfo1;\nuniform vec4 u_blurInfo2;\n#endif\n\n#ifdef COLOR_ADD\nuniform vec4 colorAdd;\n#endif\n\n#ifdef FILLTEXTURE	\nuniform vec4 u_TexRange;//startu,startv,urange, vrange\n#endif\nvoid main() {\n	if(cliped.x<0.) discard;\n	if(cliped.x>1.) discard;\n	if(cliped.y<0.) discard;\n	if(cliped.y>1.) discard;\n	\n#ifdef FILLTEXTURE	\n   vec4 color= texture2D(texture, fract(v_texcoordAlpha.xy)*u_TexRange.zw + u_TexRange.xy);\n#else\n   vec4 color= texture2D(texture, v_texcoordAlpha.xy);\n#endif\n\n   if(v_useTex<=0.)color = vec4(1.,1.,1.,1.);\n   color.a*=v_color.w;\n   //color.rgb*=v_color.w;\n   color.rgb*=v_color.rgb;\n   gl_FragColor=color;\n   \n   #ifdef COLOR_ADD\n	gl_FragColor = vec4(colorAdd.rgb,colorAdd.a*gl_FragColor.a);\n	gl_FragColor.xyz *= colorAdd.a;\n   #endif\n   \n   #ifdef BLUR_FILTER\n	gl_FragColor =   blur();\n	gl_FragColor.w*=v_color.w;   \n   #endif\n   \n   #ifdef COLOR_FILTER\n	mat4 alphaMat =colorMat;\n\n	alphaMat[0][3] *= gl_FragColor.a;\n	alphaMat[1][3] *= gl_FragColor.a;\n	alphaMat[2][3] *= gl_FragColor.a;\n\n	gl_FragColor = gl_FragColor * alphaMat;\n	gl_FragColor += colorAlpha/255.0*gl_FragColor.a;\n   #endif\n   \n   #ifdef GLOW_FILTER\n	const float c_IterationTime = 10.0;\n	float floatIterationTotalTime = c_IterationTime * c_IterationTime;\n	vec4 vec4Color = vec4(0.0,0.0,0.0,0.0);\n	vec2 vec2FilterDir = vec2(-(u_blurInfo1.z)/u_blurInfo2.x,-(u_blurInfo1.w)/u_blurInfo2.y);\n	vec2 vec2FilterOff = vec2(u_blurInfo1.x/u_blurInfo2.x/c_IterationTime * 2.0,u_blurInfo1.y/u_blurInfo2.y/c_IterationTime * 2.0);\n	float maxNum = u_blurInfo1.x * u_blurInfo1.y;\n	vec2 vec2Off = vec2(0.0,0.0);\n	float floatOff = c_IterationTime/2.0;\n	for(float i = 0.0;i<=c_IterationTime; ++i){\n		for(float j = 0.0;j<=c_IterationTime; ++j){\n			vec2Off = vec2(vec2FilterOff.x * (i - floatOff),vec2FilterOff.y * (j - floatOff));\n			vec4Color += texture2D(texture, v_texcoordAlpha.xy + vec2FilterDir + vec2Off)/floatIterationTotalTime;\n		}\n	}\n	gl_FragColor = vec4(u_color.rgb,vec4Color.a * u_blurInfo2.z);\n	gl_FragColor.rgb *= gl_FragColor.a;   \n   #endif\n   \n}";
		Shader.preCompile2D(0,/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,vs,ps,null);
		vs="attribute vec4 position;\nattribute vec4 attribColor;\n//attribute vec4 clipDir;\n//attribute vec2 clipRect;\nuniform vec4 clipMatDir;\nuniform vec2 clipMatPos;\n#ifdef WORLDMAT\n	uniform mat4 mmat;\n#endif\nuniform mat4 u_mmat2;\n//uniform vec2 u_pos;\nuniform vec2 size;\nvarying vec4 color;\n//vec4 dirxy=vec4(0.9,0.1, -0.1,0.9);\n//vec4 clip=vec4(100.,30.,300.,600.);\nvarying vec2 cliped;\nvoid main(){\n	\n#ifdef WORLDMAT\n	vec4 pos=mmat*vec4(position.xy,0.,1.);\n	gl_Position =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);\n#else\n	gl_Position =vec4((position.x/size.x-0.5)*2.0,(0.5-position.y/size.y)*2.0,position.z,1.0);\n#endif	\n	float clipw = length(clipMatDir.xy);\n	float cliph = length(clipMatDir.zw);\n	vec2 clippos = position.xy - clipMatPos.xy;	//pos已经应用矩阵了，为了减的有意义，clip的位置也要缩放\n	if(clipw>20000. && cliph>20000.)\n		cliped = vec2(0.5,0.5);\n	else {\n		//clipdir是带缩放的方向，由于上面clippos是在缩放后的空间计算的，所以需要把方向先normalize一下\n		cliped=vec2( dot(clippos,clipMatDir.xy)/clipw/clipw, dot(clippos,clipMatDir.zw)/cliph/cliph);\n	}\n  //pos2d.x = dot(clippos,dirx);\n  color=attribColor/255.;\n}";
		ps="precision mediump float;\n//precision mediump float;\nvarying vec4 color;\n//uniform float alpha;\nvarying vec2 cliped;\nvoid main(){\n	//vec4 a=vec4(color.r, color.g, color.b, 1);\n	//a.a*=alpha;\n    gl_FragColor= color;// vec4(color.r, color.g, color.b, alpha);\n	gl_FragColor.rgb*=color.a;\n	if(cliped.x<0.) discard;\n	if(cliped.x>1.) discard;\n	if(cliped.y<0.) discard;\n	if(cliped.y>1.) discard;\n}";
		Shader.preCompile2D(0,/*laya.webgl.shader.d2.ShaderDefines2D.PRIMITIVE*/0x04,vs,ps,null);
		vs="/*\n	texture和fillrect使用的。\n*/\nattribute vec4 posuv;\nattribute vec4 attribColor;\nattribute vec4 attribFlags;\n//attribute vec4 clipDir;\n//attribute vec2 clipRect;\nuniform vec4 clipMatDir;\nuniform vec2 clipMatPos;		// 这个是全局的，不用再应用矩阵了。\nvarying vec2 cliped;\nuniform vec2 size;\n\n#ifdef WORLDMAT\n	uniform mat4 mmat;\n#endif\n#ifdef MVP3D\n	uniform mat4 u_MvpMatrix;\n#endif\nvarying vec4 v_texcoordAlpha;\nvarying vec4 v_color;\nvarying float v_useTex;\n\nvoid main() {\n\n	vec4 pos = vec4(posuv.xy,0.,1.);\n#ifdef WORLDMAT\n	pos=mmat*pos;\n#endif\n	vec4 pos1  =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,0.,1.0);\n#ifdef MVP3D\n	gl_Position=u_MvpMatrix*pos1;\n#else\n	gl_Position=pos1;\n#endif\n	v_texcoordAlpha.xy = posuv.zw;\n	//v_texcoordAlpha.z = attribColor.a/255.0;\n	v_color = attribColor/255.0;\n	v_color.xyz*=v_color.w;//反正后面也要预乘\n	\n	v_useTex = attribFlags.r/255.0;\n	float clipw = length(clipMatDir.xy);\n	float cliph = length(clipMatDir.zw);\n	vec2 clippos = pos.xy - clipMatPos.xy;	//pos已经应用矩阵了，为了减的有意义，clip的位置也要缩放\n	if(clipw>20000. && cliph>20000.)\n		cliped = vec2(0.5,0.5);\n	else {\n		//转成0到1之间。/clipw/clipw 表示clippos与normalize之后的clip朝向点积之后，再除以clipw\n		cliped=vec2( dot(clippos,clipMatDir.xy)/clipw/clipw, dot(clippos,clipMatDir.zw)/cliph/cliph);\n	}\n\n}";
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
			ops[0]=Math.round(ops[0]);
			ops[1]=Math.round(ops[1]);
			ops[2]=Math.round(ops[2]);
			ops[3]=Math.round(ops[3]);
			ops[4]=Math.round(ops[4]);
			ops[5]=Math.round(ops[5]);
			ops[6]=Math.round(ops[6]);
			ops[7]=Math.round(ops[7]);
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
		if (!canvas)return;
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
	['_drawStyleTemp',function(){return this._drawStyleTemp=new DrawStyle(null);},'_keyMap',function(){return this._keyMap=new StringKey();},'_drawTexToDrawTri_Vert',function(){return this._drawTexToDrawTri_Vert=new Float32Array(8);},'_drawTexToDrawTri_Index',function(){return this._drawTexToDrawTri_Index=new Uint16Array([0,1,2,0,2,3]);},'_textRender',function(){return this._textRender=new TextRender();}
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
			if (rect[2]==-1)rect[2]=Math.ceil((cri.width+lineWidth*2)*this.lastScaleX);
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
		window.conchTextCanvas.font=font;
		this.lastFont=font;
		return window.conchTextCanvas.measureText(str).width;
	}

	__proto.scale=function(sx,sy){}
	//TODO:coverage
	__proto.getCharBmp=function(char,font,lineWidth,colStr,strokeColStr,size,margin_left,margin_top,margin_right,margin_bottom,rect){
		if (!window.conchTextCanvas)return null;
		window.conchTextCanvas.font=font;
		this.lastFont=font;
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
			v0=(y)/ this._texH;
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
		this._lastRT=RenderTexture2D._currentActive;
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
		switch (compressedFormat){
			case WebGLContext._compressedTextureEtc1.COMPRESSED_RGB_ETC1_WEBGL:
				this._format=5;
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
		switch (compressedFormat){
			case PVR_FORMAT_2BPP_RGB:
				this._format=9;
				break ;
			case PVR_FORMAT_4BPP_RGB:
				this._format=11;
				break ;
			case PVR_FORMAT_2BPP_RGBA:
				this._format=10;
				break ;
			case PVR_FORMAT_4BPP_RGBA:
				this._format=12;
				break ;
			default :
				throw "Texture2D:unknown PVR format.";
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
			width=Math.max(width >> 1,1.0);
			height=Math.max(height >> 1,1.0);
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


	Laya.__init([Path,WebGLContext2D]);
})(window,document,Laya);
