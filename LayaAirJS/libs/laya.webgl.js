
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Browser=laya.utils.Browser,Arith=laya.maths.Arith,ColorFilter=laya.filters.ColorFilter,Config=Laya.Config;
	var RenderSprite=laya.renders.RenderSprite,Stat=laya.utils.Stat,Matrix=laya.maths.Matrix,Rectangle=laya.maths.Rectangle;
	var Bitmap=laya.resource.Bitmap,Text=laya.display.Text,Sprite=laya.display.Sprite,Context=laya.resource.Context;
	var HTMLChar=laya.utils.HTMLChar,System=laya.system.System,Byte=laya.utils.Byte,Texture=laya.resource.Texture;
	var Utils=laya.utils.Utils,HTMLImage=laya.resource.HTMLImage,FileBitmap=laya.resource.FileBitmap,RenderContext=laya.renders.RenderContext;
	var Color=laya.utils.Color,Point=laya.maths.Point,Render=laya.renders.Render,HTMLCanvas=laya.resource.HTMLCanvas;
	var Graphics=laya.display.Graphics,StringKey=laya.utils.StringKey,Handler=laya.utils.Handler,Resource=laya.resource.Resource;
	var Style=laya.display.css.Style,Event=laya.events.Event,Filter=laya.filters.Filter;
	Laya.interface('laya.webgl.canvas.save.ISaveData');
	Laya.interface('laya.webgl.shapes.IShape');
	Laya.interface('laya.webgl.submit.ISubmit');
	Laya.interface('laya.filters.IFilterActionGL','laya.filters.IFilterAction');
	//class laya.filters.webgl.FilterActionGL
	var FilterActionGL=(function(){
		function FilterActionGL(){}
		__class(FilterActionGL,'laya.filters.webgl.FilterActionGL');
		var __proto=FilterActionGL.prototype;
		Laya.imps(__proto,{"laya.filters.IFilterActionGL":true})
		__proto.setValue=function(shader){}
		__proto.setValueMix=function(shader){}
		__proto.apply3d=function(scope,sprite,context,x,y){return null;}
		__proto.apply=function(srcCanvas){return null;}
		__getset(0,__proto,'typeMix',function(){
			return 0;
		});

		return FilterActionGL;
	})()


	//class laya.webgl.atlas.AtlasGrid
	var AtlasGrid=(function(){
		var TexMergeCellInfo,TexRowInfo,TexMergeTexSize;
		function AtlasGrid(width,height,atlasID){
			this._atlasID=0;
			this._width=0;
			this._height=0;
			this._texCount=0;
			this._rowInfo=null;
			this._cells=null;
			this._failSize=new TexMergeTexSize();
			(width===void 0)&& (width=0);
			(height===void 0)&& (height=0);
			(atlasID===void 0)&& (atlasID=0);
			this._cells=null;
			this._rowInfo=null;
			this._init(width,height);
			this._atlasID=atlasID;
		}

		__class(AtlasGrid,'laya.webgl.atlas.AtlasGrid');
		var __proto=AtlasGrid.prototype;
		//------------------------------------------------------------------------------
		__proto.getAltasID=function(){
			return this._atlasID;
		}

		//------------------------------------------------------------------------------
		__proto.setAltasID=function(atlasID){
			if(atlasID >=0){
				this._atlasID=atlasID;
			}
		}

		//------------------------------------------------------------------
		__proto.addTex=function(type,width,height){
			var result=this._get(width,height);
			if (result.ret==false){
				return result;
			}
			this._fill(result.x,result.y,width,height,type);
			this._texCount++;
			return result;
		}

		//------------------------------------------------------------------------------
		__proto._release=function(){
			if(this._cells !=null){
				this._cells.length=0;
				this._cells=null;
			}
			if(this._rowInfo){
				this._rowInfo.length=0;
				this._rowInfo=null;
			}
		}

		//------------------------------------------------------------------------------
		__proto._init=function(width,height){
			this._width=width;
			this._height=height;
			this._release();
			if (this._width==0)return false;
			this._cells=new Array(this._width *this._height);
			this._rowInfo=__newvec(this._height);
			for(var i=0;i < this._height;i++){
				this._rowInfo[i]=new TexRowInfo();
			}
			for(i=0;i < this._width *this._height;i++){
				this._cells[i]=new TexMergeCellInfo();
			}
			this._clear();
			return true;
		}

		//------------------------------------------------------------------
		__proto._get=function(width,height){
			var pFillInfo=new MergeFillInfo();
			if(width >=this._failSize.width && height >=this._failSize.height){
				return pFillInfo;
			};
			var rx=-1;
			var ry=-1;
			var nWidth=this._width;
			var nHeight=this._height;
			var pCellBox=this._cells;
			for(var y=0;y < nHeight;y++){
				if(this._rowInfo[y].spaceCount < width)continue ;
				for(var x=0;x < nWidth;){
					if (pCellBox[ y *nWidth+x].type !=0 || pCellBox[ y *nWidth+x].successionWidth < width || pCellBox[ y *nWidth+x].successionHeight < height){
						x+=pCellBox[y *nWidth+x].successionWidth;
						continue ;
					}
					rx=x;
					ry=y;
					for(var xx=0;xx < width;xx++){
						if (pCellBox[y *nWidth+x+xx].successionHeight < height){
							rx=-1;
							break ;
						}
					}
					if(rx < 0){
						x+=pCellBox[y *nWidth+x].successionWidth;
						continue ;
					}
					pFillInfo.ret=true;
					pFillInfo.x=rx;
					pFillInfo.y=ry;
					return pFillInfo;
				}
			}
			return pFillInfo;
		}

		//------------------------------------------------------------------
		__proto._fill=function(x,y,w,h,type){
			var nWidth=this._width;
			var nHeghit=this._height;
			this._check((x+w)<=nWidth && (y+h)<=nHeghit);
			for(var yy=y;yy < (h+y);++yy){
				this._check(this._rowInfo[yy].spaceCount >=w);
				this._rowInfo[yy].spaceCount-=w;
				for(var xx=0;xx < w;xx++){
					this._check(this._cells[x+yy *nWidth+xx].type==0);
					this._cells[x+yy *nWidth+xx].type=type;
					this._cells[x+yy *nWidth+xx].successionWidth=w;
					this._cells[x+yy *nWidth+xx].successionHeight=h;
				}
			}
			if(x>0){
				for(yy=0;yy < h;++yy){
					var s=0;
					for(xx=x-1;xx >=0;--xx,++s){
						if (this._cells[(y+yy)*nWidth+xx].type !=0)break ;
					}
					for(xx=s;xx>0;--xx){
						this._cells[(y+yy)*nWidth+x-xx].successionWidth=xx;
						this._check(xx>0);
					}
				}
			}
			if(y > 0){
				for(xx=x;xx < (x+w);++xx){
					s=0;
					for(yy=y-1;yy >=0;--yy,s++){
						if(this._cells[ xx+yy*nWidth].type!=0)break ;
					}
					for(yy=s;yy>0;--yy){
						this._cells[ xx+(y-yy)*nWidth].successionHeight=yy;
						this._check(yy>0);
					}
				}
			}
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
				this._rowInfo[y].spaceCount=this._width;
			}
			for (var i=0;i < this._height;i++){
				for (var j=0;j < this._width;j++){
					var pCellbox=this._cells[ i *this._width+j];
					pCellbox.type=0;
					pCellbox.successionWidth=this._width-j;
					pCellbox.successionHeight=this._width-i;
				}
			}
			this._failSize.width=this._width+1;
			this._failSize.height=this._height+1;
		}

		AtlasGrid.__init$=function(){
			//------------------------------------------------------------------------------
			//class TexMergeCellInfo
			TexMergeCellInfo=(function(){
				function TexMergeCellInfo(){
					this.type=0;
					this.successionWidth=0;
					this.successionHeight=0;
				}
				__class(TexMergeCellInfo,'');
				return TexMergeCellInfo;
			})()
			//------------------------------------------------------------------------------
			//class TexRowInfo
			TexRowInfo=(function(){
				function TexRowInfo(){
					this.spaceCount=0;
				}
				__class(TexRowInfo,'');
				return TexRowInfo;
			})()
			//------------------------------------------------------------------------------
			//class TexMergeTexSize
			TexMergeTexSize=(function(){
				function TexMergeTexSize(){
					this.width=0;
					this.height=0;
				}
				__class(TexMergeTexSize,'');
				return TexMergeTexSize;
			})()
		}

		return AtlasGrid;
	})()


	;
	;
	;
	//class laya.webgl.atlas.AtlasManager
	var AtlasManager=(function(){
		function AtlasManager(width,height,gridSize,maxTexNum){
			this._maxAtlasNum=0;
			this._width=0;
			this._height=0;
			this._gridSize=0;
			this._gridNumX=0;
			this._gridNumY=0;
			this._init=false;
			this._curAtlasIndex=0;
			this._setAtlasParam=false;
			this._atlaserArray=null;
			this._needGC=false;
			this._setAtlasParam=true;
			this._width=width;
			this._height=height;
			this._gridSize=gridSize;
			this._maxAtlasNum=maxTexNum;
			this._gridNumX=width / gridSize;
			this._gridNumY=height / gridSize;
			this._curAtlasIndex=0;
			this._atlaserArray=[];
			if (WebGL.mainContext)this.Initialize();
		}

		__class(AtlasManager,'laya.webgl.atlas.AtlasManager');
		var __proto=AtlasManager.prototype;
		__proto.Initialize=function(){
			for (var i=0;i < this._maxAtlasNum;i++){
				this._atlaserArray.push(new Atlaser(this._gridNumX,this._gridNumY,this._width,this._height,AtlasManager._sid_));
				AtlasManager._sid_++;
			}
			return true;
		}

		__proto.setAtlasParam=function(width,height,gridSize,maxTexNum){
			if (this._setAtlasParam==true){
				AtlasManager._sid_=0;
				this._width=width;
				this._height=height;
				this._gridSize=gridSize;
				this._maxAtlasNum=maxTexNum;
				this._gridNumX=width / gridSize;
				this._gridNumY=height / gridSize;
				this._curAtlasIndex=0;
				this.freeAll();
				this.Initialize();
				return true;
				}else {
				console.log("设置大图合集参数错误，只能在开始页面设置各种参数");
				throw-1;
				return false;
			}
			return false;
		}

		__proto.computeUVinAtlasTexture=function(texture,offsetX,offsetY){
			var tex=texture;
			var u1=offsetX / this._width,v1=offsetY / this._height,u2=(offsetX+texture.bitmap.width)/ this._width,v2=(offsetY+texture.bitmap.height)/ this._height;
			var inAltasUVWidth=texture.bitmap.width / this._width,inAltasUVHeight=texture.bitmap.height / this._height;
			var oriUV=tex.originalUV;
			texture.uv=[u1+oriUV[0] *inAltasUVWidth,v1+oriUV[1] *inAltasUVHeight,u2-(1-oriUV[2])*inAltasUVWidth,v1+oriUV[3] *inAltasUVHeight,u2-(1-oriUV[4])*inAltasUVWidth,v2-(1-oriUV[5])*inAltasUVHeight,u1+oriUV[6] *inAltasUVWidth,v2-(1-oriUV[7])*inAltasUVHeight];
		}

		//添加 图片到大图集
		__proto.pushData=function(texture){
			var tex=texture;
			this._setAtlasParam=false;
			var bFound=false;
			var nImageGridX=(Math.ceil((texture.bitmap.width+2)/ this._gridSize));
			var nImageGridY=(Math.ceil((texture.bitmap.height+2)/ this._gridSize));
			var bSuccess=false;
			for (var k=0;k < 2;k++){
				var nAtlasSize=this._atlaserArray.length;
				for (var i=0;i < nAtlasSize;++i){
					var altasIndex=(this._curAtlasIndex+i)% nAtlasSize;
					var atlas=this._atlaserArray[altasIndex];
					var bitmap=texture.bitmap;
					if (atlas.webGLImages.indexOf(bitmap)==-1){
						var fillInfo=atlas.addTex(1,nImageGridX,nImageGridY);
						if (fillInfo.ret){
							var offsetX=fillInfo.x *this._gridSize+1;
							var offsetY=fillInfo.y *this._gridSize+1;
							atlas.addToAtlasTexture(bitmap,offsetX,offsetY);
							(!tex.originalUV)&& (tex.originalUV=texture.uv.slice());
							bSuccess=true;
							this._curAtlasIndex=altasIndex;
							this.computeUVinAtlasTexture(texture,bitmap.offsetX,bitmap.offsetY);
							atlas.addToAtlas(texture);
							break ;
						}
						}else {
						(!tex.originalUV)&& (tex.originalUV=texture.uv.slice());
						bSuccess=true;
						this._curAtlasIndex=altasIndex;
						this.computeUVinAtlasTexture(texture,bitmap.offsetX,bitmap.offsetY);
						atlas.addToAtlas(texture);
						break ;
					}
				}
				if (bSuccess)
					break ;
				this._atlaserArray.push(new Atlaser(this._gridNumX,this._gridNumY,this._width,this._height,AtlasManager._sid_++));
				this._needGC=true;
				this.garbageCollection();
				this._curAtlasIndex=this._atlaserArray.length-1;
			}
			if (!bSuccess){
				console.log(">>>AtlasManager pushData error");
			}
			return bSuccess;
		}

		__proto.addToAtlas=function(tex){
			laya.webgl.atlas.AtlasManager.instance.pushData(tex);
		}

		/**
		*回收大图合集,不建议手动调用
		*@return
		*/
		__proto.garbageCollection=function(){
			if (this._needGC===true){
				var n=this._atlaserArray.length-this._maxAtlasNum;
				for (var i=0;i < n;i++)
				this._atlaserArray[i].destroy();
				this._atlaserArray.splice(0,n);
				this._needGC=false;
			}
			return true;
		}

		__proto.freeAll=function(){
			for (var i=0,n=this._atlaserArray.length;i < n;i++){
				this._atlaserArray[i].destroy();
			}
			this._atlaserArray.length=0;
		}

		__getset(1,AtlasManager,'instance',function(){
			if (!AtlasManager.__S_Instance__){
				AtlasManager.__S_Instance__=new AtlasManager(AtlasManager.atlasTextureWidth,AtlasManager.atlasTextureHeight,AtlasManager.gridSize,AtlasManager.maxTextureCount);
			}
			return AtlasManager.__S_Instance__;
		});

		__getset(1,AtlasManager,'atlasLimitWidth',function(){
			return AtlasManager._atlasLimitWidth;
			},function(value){
			AtlasManager._atlasLimitWidth=value;
			Config.atlasLimitWidth=value;
		});

		__getset(1,AtlasManager,'enabled',function(){
			return AtlasManager._enabled;
		});

		__getset(1,AtlasManager,'atlasLimitHeight',function(){
			return AtlasManager._atlasLimitHeight;
			},function(value){
			AtlasManager._atlasLimitHeight=value;
			Config.atlasLimitHeight=value;
		});

		AtlasManager.enable=function(){
			AtlasManager._enabled=true;
			Config.atlasEnable=true;
		}

		AtlasManager.__init__=function(){
			AtlasManager.atlasLimitWidth=512;
			AtlasManager.atlasLimitHeight=512;
		}

		AtlasManager._enabled=false;
		AtlasManager._atlasLimitWidth=0;
		AtlasManager._atlasLimitHeight=0;
		AtlasManager.atlasTextureWidth=2048;
		AtlasManager.atlasTextureHeight=2048;
		AtlasManager.gridSize=16;
		AtlasManager.maxTextureCount=8;
		AtlasManager.BOARDER_TYPE_NO=0;
		AtlasManager.BOARDER_TYPE_RIGHT=1;
		AtlasManager.BOARDER_TYPE_LEFT=2;
		AtlasManager.BOARDER_TYPE_BOTTOM=4;
		AtlasManager.BOARDER_TYPE_TOP=8;
		AtlasManager.BOARDER_TYPE_ALL=15;
		AtlasManager._sid_=0;
		AtlasManager.__S_Instance__=null;
		return AtlasManager;
	})()


	//class laya.webgl.atlas.MergeFillInfo
	var MergeFillInfo=(function(){
		function MergeFillInfo(){
			this.x=0;
			this.y=0;
			this.ret=false;
			this.ret=false;
			this.x=0;
			this.y=0;
		}

		__class(MergeFillInfo,'laya.webgl.atlas.MergeFillInfo');
		return MergeFillInfo;
	})()


	;
	//class laya.webgl.canvas.BlendMode
	var BlendMode=(function(){
		function BlendMode(){};
		__class(BlendMode,'laya.webgl.canvas.BlendMode');
		BlendMode._init_=function(gl){
			BlendMode.fns=[BlendMode.BlendNormal,BlendMode.BlendAdd,BlendMode.BlendMultiply,BlendMode.BlendScreen,BlendMode.BlendOverlay,BlendMode.BlendLight];
			BlendMode.targetFns=[BlendMode.BlendNormalTarget,BlendMode.BlendAddTarget,BlendMode.BlendMultiplyTarget,BlendMode.BlendScreenTarget,BlendMode.BlendOverlayTarget,BlendMode.BlendLightTarget];
		}

		BlendMode.BlendNormal=function(gl){
			gl.blendFunc(/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303);
		}

		BlendMode.BlendAdd=function(gl){
			gl.blendFunc(/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302,/*laya.webgl.WebGLContext.DST_ALPHA*/0x0304);
		}

		BlendMode.BlendMultiply=function(gl){
			gl.blendFunc(/*laya.webgl.WebGLContext.DST_COLOR*/0x0306,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303);
		}

		BlendMode.BlendScreen=function(gl){
			gl.blendFunc(/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302,/*laya.webgl.WebGLContext.ONE*/1);
		}

		BlendMode.BlendOverlay=function(gl){
			gl.blendFunc(/*laya.webgl.WebGLContext.ONE*/1,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_COLOR*/0x0301);
		}

		BlendMode.BlendLight=function(gl){
			gl.blendFunc(/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302,/*laya.webgl.WebGLContext.ONE*/1);
		}

		BlendMode.BlendNormalTarget=function(gl){
			gl.blendFuncSeparate(/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303,/*laya.webgl.WebGLContext.ONE*/1,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303);
		}

		BlendMode.BlendAddTarget=function(gl){
			gl.blendFunc(/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302,/*laya.webgl.WebGLContext.DST_ALPHA*/0x0304);
		}

		BlendMode.BlendMultiplyTarget=function(gl){
			gl.blendFunc(/*laya.webgl.WebGLContext.DST_COLOR*/0x0306,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_ALPHA*/0x0303);
		}

		BlendMode.BlendScreenTarget=function(gl){
			gl.blendFunc(/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302,/*laya.webgl.WebGLContext.ONE*/1);
		}

		BlendMode.BlendOverlayTarget=function(gl){
			gl.blendFunc(/*laya.webgl.WebGLContext.ONE*/1,/*laya.webgl.WebGLContext.ONE_MINUS_SRC_COLOR*/0x0301);
		}

		BlendMode.BlendLightTarget=function(gl){
			gl.blendFunc(/*laya.webgl.WebGLContext.SRC_ALPHA*/0x0302,/*laya.webgl.WebGLContext.ONE*/1);
		}

		BlendMode.NAMES=["normal","add","multiply","screen","overlay","light"];
		BlendMode.TOINT={"normal":0,"add":1,"multiply":2,"screen":3 ,"lighter":1,"overlay":4,"light":5};
		BlendMode.NORMAL="normal";
		BlendMode.ADD="add";
		BlendMode.MULTIPLY="multiply";
		BlendMode.SCREEN="screen";
		BlendMode.LIGHT="light";
		BlendMode.OVERLAY="overlay";
		BlendMode.fns=[];
		BlendMode.targetFns=[];
		return BlendMode;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.canvas.DrawStyle
	var DrawStyle=(function(){
		function DrawStyle(value){
			this._color=Color.create("black");
			this.setValue(value);
		}

		__class(DrawStyle,'laya.webgl.canvas.DrawStyle');
		var __proto=DrawStyle.prototype;
		__proto.setValue=function(value){
			if (value){
				if ((typeof value=='string')){
					this._color=Color.create(value);
					return;
				}
				if ((value instanceof laya.utils.Color )){
					this._color=value;
					return;
				}
			}
		}

		__proto.reset=function(){
			this._color=Color.create("black");
		}

		__proto.equal=function(value){
			if ((typeof value=='string'))return this._color.strColor===value;
			return false;
		}

		__proto.toColorStr=function(){
			return this._color.strColor;
		}

		DrawStyle.DEFAULT=new DrawStyle("#000000");
		return DrawStyle;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.canvas.Path
	var Path=(function(){
		function Path(){
			this._x=0;
			this._y=0;
			//this._rect=null;
			//this.ib=null;
			//this.vb=null;
			this.dirty=false;
			//this.geomatrys=null;
			//this._curGeomatry=null;
			this.offset=0;
			this.count=0;
			this.geoStart=0;
			this.geomatrys=[];
			var gl=WebGL.mainContext;
			this.ib=new Buffer(/*laya.webgl.WebGLContext.ELEMENT_ARRAY_BUFFER*/0x8893,/*laya.webgl.utils.Buffer.INDEX*/"INDEX",null,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4);
			this.vb=new Buffer(/*laya.webgl.WebGLContext.ARRAY_BUFFER*/0x8892);
		}

		__class(Path,'laya.webgl.canvas.Path');
		var __proto=Path.prototype;
		__proto.clear=function(){
			this._rect=null;
		}

		__proto.rect2=function(x,y,w,h,color,borderWidth,borderColor){
			(borderWidth===void 0)&& (borderWidth=2);
			(borderColor===void 0)&& (borderColor=0);
			this.geomatrys.push(this._curGeomatry=new Rect(x,y,w,h,color,borderWidth,borderColor));
		}

		__proto.rect=function(x,y,width,height){
			this._rect=new Rectangle(x,y,width,height);
			this.dirty=true;
		}

		__proto.strokeRect=function(x,y,width,height){
			this._rect=new Rectangle(x,y,width,height);
		}

		__proto.circle=function(x,y,r,color,borderWidth,borderColor,fill){
			this.geomatrys.push(this._curGeomatry=new Circle(x,y,r,color,borderWidth,borderColor,fill));
		}

		__proto.fan=function(x,y,r,r0,r1,color,borderWidth,borderColor){
			var geo;
			this.geomatrys.push(this._curGeomatry=geo=new Fan(x,y,r,r0,r1,color,borderWidth,borderColor));
			if(!color)geo.fill=false;
		}

		__proto.ellipse=function(x,y,rw,rh,color,borderWidth,borderColor){
			this.geomatrys.push(this._curGeomatry=new Ellipse(x,y,rw,rh,color,borderWidth,borderColor));
		}

		__proto.polygon=function(x,y,r,edges,color,borderWidth,borderColor){
			var geo;
			this.geomatrys.push(this._curGeomatry=geo=new Polygon(x,y,r,edges,color,borderWidth,borderColor));
			if(!color)geo.fill=false;if(borderColor==undefined)geo.borderWidth=0;
		}

		__proto.drawPath=function(x,y,points,color,borderWidth){
			this.geomatrys.push(this._curGeomatry=new Line(x,y,points,color,borderWidth));
		}

		__proto.update=function(){
			var si=this.ib.length;
			var len=this.geomatrys.length;
			this.offset=si;
			for(var i=this.geoStart;i<len;i++){
				this.geomatrys[i].getData(this.ib,this.vb,this.vb.length/(5*4));
			}
			this.geoStart=len;
			this.count=(this.ib.length-si)/2;
		}

		__proto.sector=function(x,y,rW,rH){}
		__proto.roundRect=function(x,y,w,h,rW,rH){}
		__proto.reset=function(){
			this.vb.clear();
			this.ib.clear();
			this.offset=this.count=this.geoStart=0;
			this.geomatrys.length=0;
		}

		return Path;
	})()


	/**
	*...
	*@author laya
	*/
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
			SaveBase._cache[SaveBase._cache._length++]=this;
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
			namemap[0x400]=
			namemap[0x800]=
			namemap[0x1000]=[];
			namemap[0x4000]="textBaseline";
			namemap[0x8000]="textAlign";
			namemap[0x10000]="_nBlendType";
			namemap[0x80000]="shader";
			namemap[0x100000]="filters";
			return namemap;
		}

		SaveBase.save=function(context,type,dataObj,newSubmit){
			if ((context._saveMark._saveuse & type)!==type){
				context._saveMark._saveuse |=type;
				var cache=SaveBase._cache;
				var o=cache._length > 0 ?cache[--cache._length] :(new SaveBase());
				o._value=dataObj[ o._valueName=SaveBase._namemap[type]];
				o._dataObj=dataObj;
				o._newSubmit=newSubmit;
				var _save=context._save;
				_save[_save._length++]=o;
			}
		}

		SaveBase._cache=laya.webgl.canvas.save.SaveBase._createArray();
		SaveBase._namemap=SaveBase._init();
		return SaveBase;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.canvas.save.SaveClipRect
	var SaveClipRect=(function(){
		function SaveClipRect(){
			//this._clipSaveRect=null;
			//this._submitScissor=null;
			this._clipRect=new Rectangle();
		}

		__class(SaveClipRect,'laya.webgl.canvas.save.SaveClipRect');
		var __proto=SaveClipRect.prototype;
		Laya.imps(__proto,{"laya.webgl.canvas.save.ISaveData":true})
		__proto.isSaveMark=function(){return false;}
		__proto.restore=function(context){
			context._clipRect=this._clipSaveRect;
			SaveClipRect._cache[SaveClipRect._cache._length++]=this;
			this._submitScissor.submitLength=context._submits._length-this._submitScissor.submitIndex;
			context._curSubmit=Submit.RENDERBASE;
		}

		SaveClipRect.save=function(context,submitScissor){
			if ((context._saveMark._saveuse & /*laya.webgl.canvas.save.SaveBase.TYPE_CLIPRECT*/0x20000)==/*laya.webgl.canvas.save.SaveBase.TYPE_CLIPRECT*/0x20000)return;
			context._saveMark._saveuse |=/*laya.webgl.canvas.save.SaveBase.TYPE_CLIPRECT*/0x20000;
			var cache=SaveClipRect._cache;
			var o=cache._length > 0?cache[--cache._length]:(new SaveClipRect());
			o._clipSaveRect=context._clipRect;
			context._clipRect=o._clipRect.copyFrom(context._clipRect);
			o._submitScissor=submitScissor;
			var _save=context._save;
			_save[_save._length++]=o;
		}

		SaveClipRect._cache=SaveBase._createArray();
		return SaveClipRect;
	})()


	/**
	*...
	*@author laya
	*/
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
			SaveMark._no[SaveMark._no._length++]=this;
		}

		SaveMark.Create=function(context){
			var no=SaveMark._no;
			var o=no._length > 0?no[--no._length]:(new SaveMark());
			o._saveuse=0;
			o._preSaveMark=context._saveMark;
			context._saveMark=o;
			return o;
		}

		SaveMark._no=SaveBase._createArray();
		return SaveMark;
	})()


	/**
	*...
	*@author laya
	*/
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
			SaveTransform._no[SaveTransform._no._length++]=this;
		}

		SaveTransform.save=function(context){
			var _saveMark=context._saveMark;
			if ((_saveMark._saveuse & /*laya.webgl.canvas.save.SaveBase.TYPE_TRANSFORM*/0x800)===/*laya.webgl.canvas.save.SaveBase.TYPE_TRANSFORM*/0x800)return;
			_saveMark._saveuse |=/*laya.webgl.canvas.save.SaveBase.TYPE_TRANSFORM*/0x800;
			var no=SaveTransform._no;
			var o=no._length > 0?no[--no._length]:(new SaveTransform());
			o._savematrix=context._curMat;
			context._curMat=context._curMat.copy(o._matrix);
			var _save=context._save;
			_save[_save._length++]=o;
		}

		SaveTransform._no=SaveBase._createArray();
		return SaveTransform;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.canvas.save.SaveTranslate
	var SaveTranslate=(function(){
		function SaveTranslate(){
			//this._x=NaN;
			//this._y=NaN;
		}

		__class(SaveTranslate,'laya.webgl.canvas.save.SaveTranslate');
		var __proto=SaveTranslate.prototype;
		Laya.imps(__proto,{"laya.webgl.canvas.save.ISaveData":true})
		__proto.isSaveMark=function(){return false;}
		__proto.restore=function(context){
			var mat=context._curMat;
			context._x=this._x;
			context._y=this._y;
			SaveTranslate._no[SaveTranslate._no._length++]=this;
		}

		SaveTranslate.save=function(context){
			var no=SaveTranslate._no;
			var o=no._length > 0?no[--no._length]:(new SaveTranslate());
			o._x=context._x;
			o._y=context._y;
			var _save=context._save;
			_save[_save._length++]=o;
		}

		SaveTranslate._no=SaveBase._createArray();
		return SaveTranslate;
	})()


	/**
	*...
	*@author
	*/
	//class laya.webgl.resource.GLRenderTargetCube
	var GLRenderTargetCube=(function(){
		function GLRenderTargetCube(){}
		__class(GLRenderTargetCube,'laya.webgl.resource.GLRenderTargetCube');
		return GLRenderTargetCube;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.resource.RenderTargetMAX
	var RenderTargetMAX=(function(){
		var OneTarget;
		function RenderTargetMAX(){
			this.targets=null;
			this.oneTargets=null;
			this.repaint=false;
			this._width=NaN;
			this._height=NaN;
			this._clipRect=new Rectangle();
		}

		__class(RenderTargetMAX,'laya.webgl.resource.RenderTargetMAX');
		var __proto=RenderTargetMAX.prototype;
		__proto.size=function(w,h){
			if (this._width===w && this._height===h)return;
			this.repaint=true;
			this._width=w;
			this._height=h;
			if (!this.oneTargets)this.oneTargets=new OneTarget(w,h);
			else this.oneTargets.target.size(w,h);
		}

		__proto._flushToTarget=function(context,target){
			var worldScissorTest=RenderState2D.worldScissorTest;
			var preworldClipRect=RenderState2D.worldClipRect;
			RenderState2D.worldClipRect=this._clipRect;
			this._clipRect.x=this._clipRect.y=0;
			this._clipRect.width=this._width;
			this._clipRect.height=this._height;
			WebGL.mainContext.disable(/*laya.webgl.WebGLContext.SCISSOR_TEST*/0x0C11);
			var preAlpha=RenderState2D.worldAlpha;
			var preMatrix4=RenderState2D.worldMatrix4;
			var preMatrix=RenderState2D.worldMatrix;
			var preFilters=RenderState2D.worldFilters;
			var preShaderDefinesValue=RenderState2D.worldShaderDefinesValue;
			RenderState2D.worldMatrix=RenderTargetMAX._matrixDefault;
			RenderState2D.worldMatrix4=RenderState2D.TEMPMAT4_ARRAY;
			RenderState2D.worldAlpha=1;
			RenderState2D.worldFilters=null;
			RenderState2D.worldShaderDefinesValue=0;
			Shader.activeShader=null;
			target.start();
			Config.showCanvasMark?target.clear(0,1,0,0.3):target.clear(0,0,0,0);
			context.flush();
			target.end();
			Shader.activeShader=null;
			RenderState2D.worldAlpha=preAlpha;
			RenderState2D.worldMatrix4=preMatrix4;
			RenderState2D.worldMatrix=preMatrix;
			RenderState2D.worldFilters=preFilters;
			RenderState2D.worldShaderDefinesValue=preShaderDefinesValue;
			worldScissorTest && WebGL.mainContext.enable(/*laya.webgl.WebGLContext.SCISSOR_TEST*/0x0C11);
			RenderState2D.worldClipRect=preworldClipRect;
		}

		__proto.flush=function(context){
			if (this.repaint){
				this._flushToTarget(context,this.oneTargets.target);
				this.repaint=false;
			}
		}

		__proto.drawTo=function(context,x,y,width,height){
			context.drawTexture(this.oneTargets.target.getTexture(),x,y,width,height,0,0);
		}

		__proto.destroy=function(){
			if (this.oneTargets){
				this.oneTargets.target.destroy();
				this.oneTargets.target=null;
				this.oneTargets=null;
			}
		}

		__static(RenderTargetMAX,
		['_matrixDefault',function(){return this._matrixDefault=new Matrix();}
		]);
		RenderTargetMAX.__init$=function(){
			//class OneTarget
			OneTarget=(function(){
				function OneTarget(w,h){
					//this.x=NaN;
					//this.y=NaN;
					//this.width=NaN;
					//this.height=NaN;
					//this.target=null;
					this.width=w;
					this.height=h;
					this.target=RenderTarget2D.create(w,h);
				}
				__class(OneTarget,'');
				return OneTarget;
			})()
		}

		return RenderTargetMAX;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.shader.Shader
	var Shader=(function(){
		function Shader(vs,ps,saveName,nameMap){
			this.customCompile=false;
			//this._nameMap=null;
			//this._vs=null;
			//this._ps=null;
			//this._texIndex=0;
			this.tag={};
			this._program=null;
			this._params=null;
			this._paramsMap={};
			this._offset=0;
			//this._id=0;
			this._id=++Shader._count;
			this._vs=vs;
			this._ps=ps;
			this._nameMap=nameMap ? nameMap :{};
			saveName !=null && (Shader.sharders[saveName]=this);
		}

		__class(Shader,'laya.webgl.shader.Shader');
		var __proto=Shader.prototype;
		__proto.compile=function(){
			if (!this._vs || !this._ps || this._params)
				return;
			this._params=[];
			var text=[this._vs,this._ps];
			var result;
			if (this.customCompile)
				result=this.preCompile(this._vs,this._ps);
			var gl=WebGL.mainContext;
			this._program=gl.createProgram();
			var vshader=Shader._createShader(gl,text[0],/*laya.webgl.WebGLContext.VERTEX_SHADER*/0x8B31);
			var pshader=Shader._createShader(gl,text[1],/*laya.webgl.WebGLContext.FRAGMENT_SHADER*/0x8B30);
			gl.attachShader(this._program,vshader);
			gl.attachShader(this._program,pshader);
			gl.linkProgram(this._program);
			if (!gl.getProgramParameter(this._program,/*laya.webgl.WebGLContext.LINK_STATUS*/0x8B82)){
				throw gl.getProgramInfoLog(this._program);
			};
			var one,i=0,j=0,n=0,location=0;
			var attribNum=0;
			if (this.customCompile)
				attribNum=result.attributes.length;
			else
			attribNum=gl.getProgramParameter(this._program,/*laya.webgl.WebGLContext.ACTIVE_ATTRIBUTES*/0x8B89);
			for (i=0;i < attribNum;i++){
				var attrib;
				if (this.customCompile)
					attrib=result.attributes[i];
				else
				attrib=gl.getActiveAttrib(this._program,i);
				location=gl.getAttribLocation(this._program,attrib.name);
				one={vartype:"attribute",ivartype:0,attrib:attrib,location:location,name:attrib.name,type:attrib.type,isArray:false,isSame:false,preValue:null,indexOfParams:0 };
				this._params.push(one);
			};
			var nUniformNum=0;
			if (this.customCompile)
				nUniformNum=result.uniforms.length;
			else
			nUniformNum=gl.getProgramParameter(this._program,/*laya.webgl.WebGLContext.ACTIVE_UNIFORMS*/0x8B86);
			for (i=0;i < nUniformNum;i++){
				var uniform;
				if (this.customCompile)
					uniform=result.uniforms[i];
				else
				uniform=gl.getActiveUniform(this._program,i);
				location=gl.getUniformLocation(this._program,uniform.name);
				one={vartype:"uniform",ivartype:1,attrib:attrib,location:location,name:uniform.name,type:uniform.type,isArray:false,isSame:false,preValue:null,indexOfParams:0};
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
				one.saveValue=[];
				if (one.vartype==="attribute"){
					one.fun=this._attribute;
					continue ;
				}
				switch (one.type){
					case /*laya.webgl.WebGLContext.FLOAT*/0x1406:
						one.fun=one.isArray ? this._uniform1fv :this._uniform1f;
						break ;
					case /*laya.webgl.WebGLContext.FLOAT_VEC2*/0x8B50:
						one.fun=this._uniform_vec2;
						break ;
					case /*laya.webgl.WebGLContext.FLOAT_VEC3*/0x8B51:
						one.fun=this._uniform_vec3;
						break ;
					case /*laya.webgl.WebGLContext.FLOAT_VEC4*/0x8B52:
						one.fun=this._uniform_vec4;
						break ;
					case /*laya.webgl.WebGLContext.SAMPLER_2D*/0x8B5E:
						one.fun=this._uniform_sampler2D;
						break ;
					case /*laya.webgl.WebGLContext.FLOAT_MAT4*/0x8B5C:
						one.fun=this._uniformMatrix4fv;
						break ;
					case /*laya.webgl.WebGLContext.BOOL*/0x8B56:
						one.fun=this._uniform1i;
						break ;
					case /*laya.webgl.WebGLContext.SAMPLER_CUBE*/0x8B60:
					case /*laya.webgl.WebGLContext.FLOAT_MAT2*/0x8B5A:
					case /*laya.webgl.WebGLContext.FLOAT_MAT3*/0x8B5B:
						throw new Error("compile shader err!");
						break ;
					default :
						throw new Error("compile shader err!");
						break ;
					}
			}
			this._vs=this._ps=null;
		}

		/**
		*根据变量名字获得
		*@param name
		*@return
		*/
		__proto.getUniform=function(name){
			return this._paramsMap[name];
		}

		__proto._attribute=function(one,value){
			var gl=WebGL.mainContext;
			gl.enableVertexAttribArray(one.location);
			gl.vertexAttribPointer(one.location,value[0],value[1],value[2],value[3],value[4]+this._offset);
			return 2;
		}

		__proto._uniformMatrix4fv=function(one,value){
			WebGL.mainContext.uniformMatrix4fv(one.location,false,value);
			return 1;
		}

		__proto._uniform1i=function(one,value){
			var saveValue=one.saveValue;
			if (saveValue[0]!==value){
				WebGL.mainContext.uniform1i(one.location,saveValue[0]=value);
				return 1;
			}
			return 0;
		}

		__proto._uniform1f=function(one,value){
			var saveValue=one.saveValue;
			if (saveValue[0]!==value){
				WebGL.mainContext.uniform1f(one.location,saveValue[0]=value);
				return 1;
			}
			return 0;
		}

		__proto._uniform1fv=function(one,value){
			var saveValue=one.saveValue;
			if (saveValue[0]!==value){
				WebGL.mainContext.uniform1fv(one.location,saveValue[0]=value);
				return 1;
			}
			return 0;
		}

		__proto._uniform_vec2=function(one,value){
			var saveValue=one.saveValue;
			if (saveValue[0]!==value[0] || saveValue[1]!==value[1]){
				WebGL.mainContext.uniform2f(one.location,saveValue[0]=value[0],saveValue[1]=value[1]);
				return 1;
			}
			return 0;
		}

		__proto._uniform_vec3=function(one,value){
			WebGL.mainContext.uniform3f(one.location,value[0],value[1],value[2]);
			return 1;
		}

		__proto._uniform_vec4=function(one,value){
			WebGL.mainContext.uniform4f(one.location,value[0],value[1],value[2],value[3]);
			return 1;
		}

		__proto._uniform_sampler2D=function(one,value){
			var gl=WebGL.mainContext;
			gl.activeTexture(Shader._TEXTURES[this._texIndex]);
			gl.bindTexture(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,value);
			var saveValue=one.saveValue;
			if (saveValue[0]!==this._texIndex)
				gl.uniform1i(one.location,saveValue[0]=this._texIndex);
			this._texIndex++;
			return 1;
		}

		__proto.uploadOne=function(name,value){
			this._program || this.compile();
			WebGLContext.UseProgram(this._program);
			var one=this._paramsMap[name];
			one.fun.call(this,one,value);
		}

		__proto._noSetValue=function(one){
			console.log("no....:"+one.name);
		}

		/**
		*提交shader到GPU
		*@param shaderValue
		*/
		__proto.upload=function(shaderValue,params){
			Shader.activeShader=this;
			this._program || this.compile();
			WebGLContext.UseProgram(this._program);
			this._texIndex=0;
			params=params || this._params;
			var one,value,n=params.length,shaderCall=0;
			for (var i=0;i < n;i++){
				one=params[i];
				((value=shaderValue[one.name])!==null)&& (shaderCall+=one.fun.call(this,one,value));
			}
			Stat.shaderCall+=shaderCall;
		}

		/**
		*按数组的定义提交
		*@param shaderValue 数组格式[name,[value,id],...]
		*/
		__proto.uploadArray=function(shaderValue,length,_bufferUsage){
			Shader.activeShader=this;
			this._program || this.compile();
			this._texIndex=0;
			var sameProgram=!WebGLContext.UseProgram(this._program);
			var params=this._params,value;
			var one,shaderCall=0,uploadArrayCount=Shader._uploadArrayCount++;
			for (var i=length-2;i >=0;i-=2){
				one=this._paramsMap[shaderValue[i]]
				if (!one || one._uploadArrayCount===uploadArrayCount)
					continue ;
				one._uploadArrayCount=uploadArrayCount;
				var v=shaderValue[i+1];
				var uid=v[1];
				if (sameProgram&&one.ivartype===1 && uid > 0 && uid===one.__uploadid)
					continue ;
				value=v[0];
				if (value!=null){
					_bufferUsage && _bufferUsage[one.name] && _bufferUsage[one.name].bind();
					shaderCall+=one.fun.call(this,one,value);
					one.__uploadid=uid;
				}
			}
			Stat.shaderCall+=shaderCall;
		}

		/**
		*得到编译后的变量及相关预定义
		*@return
		*/
		__proto.getParams=function(){
			return this._params;
		}

		__proto.preCompile=function(vs,ps){
			var text=[vs,ps];
			var result={};
			var attributes=[];
			var uniforms=[];
			result.attributes=attributes;
			result.uniforms=uniforms;
			var removeAnnotation=new RegExp("(/\\*([^*]|[\\r\\\n]|(\\*+([^*/]|[\\r\\n])))*\\*+/)|(//.*)","g");
			var reg=new RegExp("(\".*\")|('.*')|([\\w\\*-\\.+/()=<>{}\\\\]+)|([,;:\\\\])","g");
			var i=0,n=0,one;
			for (var s=0;s < 2;s++){
				text[s]=text[s].replace(removeAnnotation,"");
				var words=text[s].match(reg);
				var str="";
				var ofs=0;
				for (i=0,n=words.length;i < n;i++){
					var word=words[i];
					if (word !="attribute" && word !="uniform"){
						str+=word;
						if (word !=";")str+=" ";
						continue ;
					}
					one={type:Shader.shaderParamsMap[words[i+1]],name:words[i+2],size:isNaN(Laya.__parseInt(words[i+3]))?1:Laya.__parseInt(words[i+3])};
					if (word=="attribute"){
						attributes.push(one);
					}
					else{
						uniforms.push(one);
					}
					str+=one.vartype+" "+one.type+" "+one.name+" ";
					if (words[i+3]==':'){
						one.type=words[i+4];
						i+=2;
					}
					i+=2;
				}
				text[s]=str;
			}
			return result;
		}

		Shader.getShader=function(name){
			return Shader.sharders[name];
		}

		Shader.create=function(vs,ps,saveName,nameMap){
			return new Shader(vs,ps,saveName,nameMap);
		}

		Shader._createShader=function(gl,str,type){
			var shader=gl.createShader(type);
			gl.shaderSource(shader,str);
			gl.compileShader(shader);
			if (!gl.getShaderParameter(shader,/*laya.webgl.WebGLContext.COMPILE_STATUS*/0x8B81)){
				throw gl.getShaderInfoLog(shader);
			}
			return shader;
		}

		Shader.addInclude=function(fileName,txt){
			if (!txt || txt.length===0)
				throw new Error("add shader include file err:"+fileName);
			if (Shader._includeFiles[fileName])
				throw new Error("add shader include file err, has add:"+fileName);
			Shader._includeFiles[fileName]=txt;
		}

		Shader.preCompile=function(nameID,mainID,vs,ps,nameMap){
			var id=0.0002 *nameID+mainID;
			Shader._preCompileShader[id]=new ShaderCompile(id,vs,ps,nameMap,Shader._includeFiles);
		}

		Shader.withCompile=function(nameID,mainID,define,shaderName,createShader){
			if (shaderName && Shader.sharders[shaderName])
				return Shader.sharders[shaderName];
			var pre=Shader._preCompileShader[0.0002 *nameID+mainID];
			if (!pre)
				throw new Error("withCompile shader err!"+nameID+" "+mainID);
			return pre.createShader(define,shaderName,createShader);
		}

		Shader.SHADERNAME2ID=0.0002;
		Shader.activeShader=null
		Shader.sharders=(Shader.sharders=[],Shader.sharders.length=0x20,Shader.sharders);
		Shader._includeFiles={};
		Shader._count=0;
		Shader._preCompileShader={};
		Shader._uploadArrayCount=1;
		Shader._TEXTURES=[ /*laya.webgl.WebGLContext.TEXTURE0*/0x84C0,/*laya.webgl.WebGLContext.TEXTURE1*/0x84C1,/*laya.webgl.WebGLContext.TEXTURE2*/0x84C2,/*laya.webgl.WebGLContext.TEXTURE3*/0x84C3,/*laya.webgl.WebGLContext.TEXTURE4*/0x84C4,/*laya.webgl.WebGLContext.TEXTURE5*/0x84C5,/*laya.webgl.WebGLContext.TEXTURE6*/0x84C6,,/*laya.webgl.WebGLContext.TEXTURE7*/0x84C7,/*laya.webgl.WebGLContext.TEXTURE8*/0x84C8];
		__static(Shader,
		['nameKey',function(){return this.nameKey=new StringKey();},'shaderParamsMap',function(){return this.shaderParamsMap={
				"float":/*laya.webgl.WebGLContext.FLOAT*/0x1406,
				"int":/*laya.webgl.WebGLContext.INT*/0x1404,
				"bool":/*laya.webgl.WebGLContext.BOOL*/0x8B56,
				"vec2":/*laya.webgl.WebGLContext.FLOAT_VEC2*/0x8B50,
				"vec3":/*laya.webgl.WebGLContext.FLOAT_VEC3*/0x8B51,
				"vec4":/*laya.webgl.WebGLContext.FLOAT_VEC4*/0x8B52,
				"ivec2":/*laya.webgl.WebGLContext.INT_VEC2*/0x8B53,
				"ivec3":/*laya.webgl.WebGLContext.INT_VEC3*/0x8B54,
				"ivec4":/*laya.webgl.WebGLContext.INT_VEC4*/0x8B55,
				"bvec2":/*laya.webgl.WebGLContext.BOOL_VEC2*/0x8B57,
				"bvec3":/*laya.webgl.WebGLContext.BOOL_VEC3*/0x8B58,
				"bvec4":/*laya.webgl.WebGLContext.BOOL_VEC4*/0x8B59,
				"mat2":/*laya.webgl.WebGLContext.FLOAT_MAT2*/0x8B5A,
				"mat3":/*laya.webgl.WebGLContext.FLOAT_MAT3*/0x8B5B,
				"mat4":/*laya.webgl.WebGLContext.FLOAT_MAT4*/0x8B5C,
				"sampler2D":/*laya.webgl.WebGLContext.SAMPLER_2D*/0x8B5E,
				"samplerCube":/*laya.webgl.WebGLContext.SAMPLER_CUBE*/0x8B60
		};}

		]);
		return Shader;
	})()


	//class laya.webgl.shader.d2.Shader2D
	var Shader2D=(function(){
		function Shader2D(){
			this.ALPHA=1;
			//this.shader=null;
			//this.filters=null;
			this.shaderType=0;
			//this.colorAdd=null;
			//this.strokeStyle=null;
			//this.fillStyle=null;
			this.glTexture=new WebGLImage();
			this.defines=new ShaderDefines2D();
		}

		__class(Shader2D,'laya.webgl.shader.d2.Shader2D');
		Shader2D.__init__=function(){
			Shader.addInclude("parts/ColorFilter_ps_uniform.glsl","uniform float u_colorMatrix[20];\n"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/files/parts/colorfilter_ps_uniform.glsl*/);
			Shader.addInclude("parts/ColorFilter_ps_logic.glsl","vec4 rgba=gl_FragColor;\ngl_FragColor.r =rgba.r*u_colorMatrix[0]+rgba.g*u_colorMatrix[1]+rgba.b*u_colorMatrix[2]+rgba.a*u_colorMatrix[3]+u_colorMatrix[4];\ngl_FragColor.g =rgba.r*u_colorMatrix[5]+rgba.g*u_colorMatrix[6]+rgba.b*u_colorMatrix[7]+rgba.a*u_colorMatrix[8]+u_colorMatrix[9];\ngl_FragColor.b =rgba.r*u_colorMatrix[10]+rgba.g*u_colorMatrix[11]+rgba.b*u_colorMatrix[12]+rgba.a*u_colorMatrix[13]+u_colorMatrix[14];\ngl_FragColor.a =rgba.r*u_colorMatrix[15]+rgba.g*u_colorMatrix[16]+rgba.b*u_colorMatrix[17]+rgba.a*u_colorMatrix[18]+u_colorMatrix[19];"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/files/parts/colorfilter_ps_logic.glsl*/);
			Shader.addInclude("parts/GlowFilter_ps_uniform.glsl","uniform bool u_blurX;\nuniform vec4 u_color;\nuniform float u_offset;\nuniform float u_strength;\nuniform float u_texW;\nuniform float u_texH;"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/files/parts/glowfilter_ps_uniform.glsl*/);
			Shader.addInclude("parts/GlowFilter_ps_logic.glsl","const int c_FilterTime = 9;\nconst float c_Gene = (1.0/(1.0 + 2.0*(0.93 + 0.8 + 0.7 + 0.6 + 0.5 + 0.4 + 0.3 + 0.2 + 0.1)));\nvec4 vec4Color = gl_FragColor*c_Gene;\nfloat aryAttenuation[c_FilterTime];\naryAttenuation[0] = 0.93;\naryAttenuation[1] = 0.8;\naryAttenuation[2] = 0.7;\naryAttenuation[3] = 0.6;\naryAttenuation[4] = 0.5;\naryAttenuation[5] = 0.4;\naryAttenuation[6] = 0.3;\naryAttenuation[7] = 0.2;\naryAttenuation[8] = 0.1;\n\nfloat u_TexSpaceU=1.0/u_texW;\nfloat u_TexSpaceV=1.0/u_texH;\nvec2 vec2FilterDir;\nif(u_blurX)\n	vec2FilterDir = vec2(u_offset*u_TexSpaceU/9.0, 0.0);\nelse\n	vec2FilterDir = vec2(0.0,u_offset*u_TexSpaceV/9.0);\nvec2 vec2Step = vec2FilterDir;\n\nfor(int i = 0;i< c_FilterTime; ++i){\n	vec4Color += texture2D(texture, v_texcoord + vec2Step)*aryAttenuation[i]*c_Gene;\n	vec4Color += texture2D(texture, v_texcoord - vec2Step)*aryAttenuation[i]*c_Gene;\n	vec2Step += vec2FilterDir;\n}\n\ngl_FragColor = vec4Color.a*u_color*u_strength;"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/files/parts/glowfilter_ps_logic.glsl*/);
			Shader.addInclude("parts/BlurFilter_ps_logic.glsl","gl_FragColor=vec4(0.0);\ngl_FragColor += texture2D(texture, vBlurTexCoords[ 0])*0.004431848411938341;\ngl_FragColor += texture2D(texture, vBlurTexCoords[ 1])*0.05399096651318985;\ngl_FragColor += texture2D(texture, vBlurTexCoords[ 2])*0.2419707245191454;\ngl_FragColor += texture2D(texture, v_texcoord        )*0.3989422804014327;\ngl_FragColor += texture2D(texture, vBlurTexCoords[ 3])*0.2419707245191454;\ngl_FragColor += texture2D(texture, vBlurTexCoords[ 4])*0.05399096651318985;\ngl_FragColor += texture2D(texture, vBlurTexCoords[ 5])*0.004431848411938341;"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/files/parts/blurfilter_ps_logic.glsl*/);
			Shader.addInclude("parts/BlurFilter_ps_uniform.glsl","varying vec2 vBlurTexCoords[6];"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/files/parts/blurfilter_ps_uniform.glsl*/);
			Shader.addInclude("parts/BlurFilter_vs_uniform.glsl","uniform float strength;\nvarying vec2 vBlurTexCoords[6];"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/files/parts/blurfilter_vs_uniform.glsl*/);
			Shader.addInclude("parts/BlurFilter_vs_logic.glsl","\nvBlurTexCoords[ 0] = v_texcoord + vec2(-0.012 * strength, 0.0);\nvBlurTexCoords[ 1] = v_texcoord + vec2(-0.008 * strength, 0.0);\nvBlurTexCoords[ 2] = v_texcoord + vec2(-0.004 * strength, 0.0);\nvBlurTexCoords[ 3] = v_texcoord + vec2( 0.004 * strength, 0.0);\nvBlurTexCoords[ 4] = v_texcoord + vec2( 0.008 * strength, 0.0);\nvBlurTexCoords[ 5] = v_texcoord + vec2( 0.012 * strength, 0.0);"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/files/parts/blurfilter_vs_logic.glsl*/);
			Shader.addInclude("parts/ColorAdd_ps_uniform.glsl","uniform vec4 colorAdd;\n"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/files/parts/coloradd_ps_uniform.glsl*/);
			Shader.addInclude("parts/ColorAdd_ps_logic.glsl","gl_FragColor = vec4(colorAdd.rgb,colorAdd.a*gl_FragColor.a);"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/files/parts/coloradd_ps_logic.glsl*/);
			var vs,ps;
			vs="attribute vec4 position;\nattribute vec2 texcoord;\nuniform vec2 size;\nuniform mat4 mmat;\nvarying vec2 v_texcoord;\n\n#include?BLUR_FILTER  \"parts/BlurFilter_vs_uniform.glsl\";\nvoid main() {\n  vec4 pos=mmat*position;\n  gl_Position =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);\n  v_texcoord = texcoord;\n  #include?BLUR_FILTER  \"parts/BlurFilter_vs_logic.glsl\";\n}"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/files/texture.vs*/;
			ps="precision mediump float;\n//precision highp float;\nvarying vec2 v_texcoord;\nuniform sampler2D texture;\nuniform float alpha;\n#include?BLUR_FILTER  \"parts/BlurFilter_ps_uniform.glsl\";\n#include?COLOR_FILTER \"parts/ColorFilter_ps_uniform.glsl\";\n#include?GLOW_FILTER \"parts/GlowFilter_ps_uniform.glsl\";\n#include?COLOR_ADD \"parts/ColorAdd_ps_uniform.glsl\";\n\nvoid main() {\n   vec4 color= texture2D(texture, v_texcoord);\n   color.a*=alpha;\n   gl_FragColor=color;\n   #include?COLOR_ADD \"parts/ColorAdd_ps_logic.glsl\";   \n   #include?BLUR_FILTER  \"parts/BlurFilter_ps_logic.glsl\";\n   #include?COLOR_FILTER \"parts/ColorFilter_ps_logic.glsl\";\n   #include?GLOW_FILTER \"parts/GlowFilter_ps_logic.glsl\";\n}"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/files/texture.ps*/;
			Shader.preCompile(0,/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,vs,ps,null);
			vs="attribute vec4 position;\nuniform vec2 size;\nuniform mat4 mmat;\nvoid main() {\n  vec4 pos=mmat*position;\n  gl_Position =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);\n}"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/files/line.vs*/;
			ps="precision mediump float;\nuniform vec4 color;\nuniform float alpha;\n#include?COLOR_FILTER \"parts/ColorFilter_ps_uniform.glsl\";\nvoid main() {\n	vec4 a = vec4(color.r, color.g, color.b, color.a);\n	a.w = alpha;\n	gl_FragColor = a;\n	#include?COLOR_FILTER \"parts/ColorFilter_ps_logic.glsl\";\n}"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/files/line.ps*/;
			Shader.preCompile(0,/*laya.webgl.shader.d2.ShaderDefines2D.COLOR2D*/0x02,vs,ps,null);
			vs="attribute vec4 position;\nattribute vec3 a_color;\nuniform mat4 mmat;\nuniform mat4 u_mmat2;\nuniform vec2 size;\nvarying vec3 color;\nvoid main(){\n  vec4 pos=mmat*u_mmat2*position;\n  gl_Position =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);\n  color=a_color;\n}"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/files/primitive.vs*/;
			ps="precision mediump float;\n//precision mediump float;\nvarying vec3 color;\nuniform float alpha;\nvoid main(){\n	//vec4 a=vec4(color.r, color.g, color.b, 1);\n	//a.a*=alpha;\n    gl_FragColor=vec4(color.r, color.g, color.b, alpha);\n}"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/files/primitive.ps*/;
			Shader.preCompile(0,/*laya.webgl.shader.d2.ShaderDefines2D.PRIMITIVE*/0x04,vs,ps,null);
		}

		return Shader2D;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.shader.ShaderDefines
	var ShaderDefines=(function(){
		function ShaderDefines(name2int,int2name,int2nameMap){
			this._value=0;
			//this._name2int=null;
			//this._int2name=null;
			//this._int2nameMap=null;
			this._name2int=name2int;
			this._int2name=int2name;
			this._int2nameMap=int2nameMap;
		}

		__class(ShaderDefines,'laya.webgl.shader.ShaderDefines');
		var __proto=ShaderDefines.prototype;
		__proto.add=function(value){
			if ((typeof value=='string'))value=this._name2int[value];
			this._value |=value;
			return this._value;
		}

		__proto.addInt=function(value){
			this._value |=value;
			return this._value;
		}

		__proto.remove=function(value){
			if ((typeof value=='string'))value=this._name2int[value];
			this._value &=(~value);
			return this._value;
		}

		__proto.isDefine=function(def){
			return (this._value & def)===def;
		}

		__proto.getValue=function(){
			return this._value;
		}

		__proto.setValue=function(value){
			this._value=value;
		}

		__proto.toString=function(){
			var r=this._int2nameMap[this._value];
			return r?r:ShaderDefines._toText(this._value,this._int2name,this._int2nameMap);
		}

		ShaderDefines._reg=function(name,value,_name2int,_int2name){
			_name2int[name]=value;
			_int2name[value]=name;
		}

		ShaderDefines._toText=function(value,_int2name,_int2nameMap){
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

		ShaderDefines._toInt=function(names,_name2int){
			var words=names.split('.');
			var num=0;
			for (var i=0,n=words.length;i < n;i++){
				var value=_name2int[words[i]];
				if (!value)throw new Error("Defines to int err:"+names+"/"+words[i]);
				num |=value;
			}
			return num;
		}

		return ShaderDefines;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.shader.ShaderValue
	var ShaderValue=(function(){
		function ShaderValue(){}
		__class(ShaderValue,'laya.webgl.shader.ShaderValue');
		return ShaderValue;
	})()


	//此类可以减少代码
	//class laya.webgl.shapes.BasePoly
	var BasePoly=(function(){
		function BasePoly(x,y,width,height,edges,color,borderWidth,borderColor,round){
			//this.x=NaN;
			//this.y=NaN;
			//this.r=NaN;
			//this.width=NaN;
			//this.height=NaN;
			//this.edges=NaN;
			this.r0=0
			//this.color=0;
			//this.borderColor=NaN;
			//this.borderWidth=NaN;
			//this.round=0;
			this.fill=true;
			this.r1=Math.PI / 2;
			(round===void 0)&& (round=0);
			this.x=x;
			this.y=y;
			this.width=width;
			this.height=height;
			this.edges=edges;
			this.color=color;
			this.borderWidth=borderWidth;
			this.borderColor=borderColor;
		}

		__class(BasePoly,'laya.webgl.shapes.BasePoly');
		var __proto=BasePoly.prototype;
		Laya.imps(__proto,{"laya.webgl.shapes.IShape":true})
		__proto.getData=function(ib,vb,start){
			var indices=[];
			var verts=[];
			this.circle(verts,indices,start);
			if (this.fill){
				(this.borderWidth > 0)&& this.createLoopLine(verts,indices,this.borderWidth,start+verts.length / 5);
				ib.append(new Uint16Array(indices));
				vb.append(new Float32Array(verts));
			}
			else{
				var outV=[];
				var outI=[];
				this.createLoopLine(verts,indices,this.borderWidth,start,outV,outI);
				ib.append(new Uint16Array(outI));
				vb.append(new Float32Array(outV));
			}
		}

		__proto.circle=function(outVert,outIndex,start){
			var x=this.x,y=this.y,edges=this.edges,seg=(Math.PI *2)/ edges;
			var w=this.width,h=this.height,color=this.color;
			var r=((color >> 16)& 0x0000ff)/ 255,g=((color >> 8)& 0xff)/ 255,b=(color & 0x0000ff)/ 255;
			outVert.push(x,y,r,g,b);
			for (var i=0;i < edges;i++){
				outVert.push(x+Math.sin(seg *i)*w,y+Math.cos(seg *i)*h);
				outVert.push(r,g,b);
			}
			for (i=0;i < edges;i++){
				outIndex.push(start,start+i+1,start+i+2);
			}
			outIndex[outIndex.length-1]=start+1;
		}

		__proto.sector=function(outVert,outIndex,start){
			var x=this.x,y=this.y,edges=this.edges,seg=(this.r1-this.r0)/ edges;
			var w=this.width,h=this.height,color=this.color;
			var r=((color >> 16)& 0x0000ff)/ 255,g=((color >> 8)& 0xff)/ 255,b=(color & 0x0000ff)/ 255;
			outVert.push(x,y,r,g,b);
			for (var i=0;i < edges+1;i++){
				outVert.push(x+Math.sin(seg *i+this.r0)*w,y+Math.cos(seg *i+this.r0)*h);
				outVert.push(r,g,b);
			}
			for (i=0;i < edges;i++){
				outIndex.push(start,start+i+1,start+i+2);
			}
		}

		//outIndex[outIndex.length-1]=start+1;
		__proto.createFanLine=function(p,indices,lineWidth,len,outVertex,outIndex){
			var points=p.concat();
			var result=outVertex ? outVertex :p;
			var color=this.borderColor;
			var r=((color >> 16)& 0x0000ff)/ 255,g=((color >> 8)& 0xff)/ 255,b=(color & 0x0000ff)/ 255;
			var firstPoint=[points[0],points[1]];
			var lastPoint=[points[points.length-5],points[points.length-4]];
			var midPointX=lastPoint[0]+(firstPoint[0]-lastPoint[0])*0.5;
			var midPointY=lastPoint[1]+(firstPoint[1]-lastPoint[1])*0.5;
			points.unshift(midPointX,midPointY,0,0,0);
			points.push(midPointX,midPointY,0,0,0);
			var length=points.length / 5;
			var iStart=len,w=lineWidth / 2;
			var px,py,p1x,p1y,p2x,p2y,p3x,p3y;
			var perpx,perpy,perp2x,perp2y,perp3x,perp3y;
			var a1,b1,c1,a2,b2,c2;
			var denom,pdist,dist;
			p1x=points[0];
			p1y=points[1];
			p2x=points[5];
			p2y=points[6];
			perpx=-(p1y-p2y);
			perpy=p1x-p2x;
			dist=Math.sqrt(perpx *perpx+perpy *perpy);
			perpx=perpx / dist *w;
			perpy=perpy / dist *w;
			result.push(p1x-perpx,p1y-perpy,r,g,b,p1x+perpx,p1y+perpy,r,g,b);
			for (var i=1;i < length-1;i++){
				p1x=points[(i-1)*5];
				p1y=points[(i-1)*5+1];
				p2x=points[(i)*5];
				p2y=points[(i)*5+1];
				p3x=points[(i+1)*5];
				p3y=points[(i+1)*5+1];
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
					result.push(p2x-perpx,p2y-perpy,r,g,b,p2x+perpx,p2y+perpy,r,g,b);
					continue ;
				}
				px=(b1 *c2-b2 *c1)/ denom;
				py=(a2 *c1-a1 *c2)/ denom;
				pdist=(px-p2x)*(px-p2x)+(py-p2y)+(py-p2y);
				result.push(px,py,r,g,b,p2x-(px-p2x),p2y-(py-p2y),r,g,b);
			}
			indices=outIndex ? outIndex :indices;
			var groupLen=this.edges+3;
			for (i=1;i < groupLen;i++){
				indices.push(iStart+(i-1)*2,iStart+(i-1)*2+1,iStart+i *2+1,iStart+i *2+1,iStart+i *2,iStart+(i-1)*2);
			}
			indices.push(iStart+(i-1)*2,iStart+(i-1)*2+1,iStart+1,iStart+1,iStart,iStart+(i-1)*2);
			return result;
		}

		//用于画线
		__proto.createLine2=function(p,indices,lineWidth,len,outVertex,indexCount){
			var points=p.concat();
			var result=outVertex;
			var color=this.borderColor;
			var r=((color >> 16)& 0x0000ff)/ 255,g=((color >> 8)& 0xff)/ 255,b=(color & 0x0000ff)/ 255;
			var length=points.length / 2;
			var iStart=len,w=lineWidth / 2;
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
			result.push(p1x-perpx+this.x,p1y-perpy+this.y,r,g,b,p1x+perpx+this.x,p1y+perpy+this.y,r,g,b);
			for (var i=1;i < length-1;i++){
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
					result.push(p2x-perpx+this.x,p2y-perpy+this.y,r,g,b,p2x+perpx+this.x,p2y+perpy+this.y,r,g,b);
					continue ;
				}
				px=(b1 *c2-b2 *c1)/ denom;
				py=(a2 *c1-a1 *c2)/ denom;
				pdist=(px-p2x)*(px-p2x)+(py-p2y)+(py-p2y);
				result.push(px+this.x,py+this.y,r,g,b,p2x-(px-p2x)+this.x,p2y-(py-p2y)+this.y,r,g,b);
			}
			p1x=points[points.length-4];
			p1y=points[points.length-3];
			p2x=points[points.length-2];
			p2y=points[points.length-1];
			perpx=-(p1y-p2y);
			perpy=p1x-p2x;
			dist=Math.sqrt(perpx *perpx+perpy *perpy);
			perpx=perpx / dist *w;
			perpy=perpy / dist *w;
			result.push(p2x-perpx+this.x,p2y-perpy+this.y,r,g,b,p2x+perpx+this.x,p2y+perpy+this.y,r,g,b);
			var groupLen=indexCount;
			for (i=1;i < groupLen;i++){
				indices.push(iStart+(i-1)*2,iStart+(i-1)*2+1,iStart+i *2+1,iStart+i *2+1,iStart+i *2,iStart+(i-1)*2);
			}
			return result;
		}

		//用于比如 扇形 不带两直线
		__proto.createLine=function(p,indices,lineWidth,len){
			var points=p.concat();
			var result=p;
			var color=this.borderColor;
			var r=((color >> 16)& 0x0000ff)/ 255,g=((color >> 8)& 0xff)/ 255,b=(color & 0x0000ff)/ 255;
			points.splice(0,5);
			var length=points.length / 5;
			var iStart=len,w=lineWidth / 2;
			var px,py,p1x,p1y,p2x,p2y,p3x,p3y;
			var perpx,perpy,perp2x,perp2y,perp3x,perp3y;
			var a1,b1,c1,a2,b2,c2;
			var denom,pdist,dist;
			p1x=points[0];
			p1y=points[1];
			p2x=points[5];
			p2y=points[6];
			perpx=-(p1y-p2y);
			perpy=p1x-p2x;
			dist=Math.sqrt(perpx *perpx+perpy *perpy);
			perpx=perpx / dist *w;
			perpy=perpy / dist *w;
			result.push(p1x-perpx,p1y-perpy,r,g,b,p1x+perpx,p1y+perpy,r,g,b);
			for (var i=1;i < length-1;i++){
				p1x=points[(i-1)*5];
				p1y=points[(i-1)*5+1];
				p2x=points[(i)*5];
				p2y=points[(i)*5+1];
				p3x=points[(i+1)*5];
				p3y=points[(i+1)*5+1];
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
					result.push(p2x-perpx,p2y-perpy,r,g,b,p2x+perpx,p2y+perpy,r,g,b);
					continue ;
				}
				px=(b1 *c2-b2 *c1)/ denom;
				py=(a2 *c1-a1 *c2)/ denom;
				pdist=(px-p2x)*(px-p2x)+(py-p2y)+(py-p2y);
				result.push(px,py,r,g,b,p2x-(px-p2x),p2y-(py-p2y),r,g,b);
			}
			p1x=points[points.length-10];
			p1y=points[points.length-9];
			p2x=points[points.length-5];
			p2y=points[points.length-4];
			perpx=-(p1y-p2y);
			perpy=p1x-p2x;
			dist=Math.sqrt(perpx *perpx+perpy *perpy);
			perpx=perpx / dist *w;
			perpy=perpy / dist *w;
			result.push(p2x-perpx,p2y-perpy,r,g,b,p2x+perpx,p2y+perpy,r,g,b);
			var groupLen=this.edges+1;
			for (i=1;i < groupLen;i++){
				indices.push(iStart+(i-1)*2,iStart+(i-1)*2+1,iStart+i *2+1,iStart+i *2+1,iStart+i *2,iStart+(i-1)*2);
			}
			return result;
		}

		//闭合路径
		__proto.createLoopLine=function(p,indices,lineWidth,len,outVertex,outIndex){
			var points=p.concat();
			var result=outVertex ? outVertex :p;
			var color=this.borderColor;
			var r=((color >> 16)& 0x0000ff)/ 255,g=((color >> 8)& 0xff)/ 255,b=(color & 0x0000ff)/ 255;
			points.splice(0,5);
			var firstPoint=[points[0],points[1]];
			var lastPoint=[points[points.length-5],points[points.length-4]];
			var midPointX=lastPoint[0]+(firstPoint[0]-lastPoint[0])*0.5;
			var midPointY=lastPoint[1]+(firstPoint[1]-lastPoint[1])*0.5;
			points.unshift(midPointX,midPointY,0,0,0);
			points.push(midPointX,midPointY,0,0,0);
			var length=points.length / 5;
			var iStart=len,w=lineWidth / 2;
			var px,py,p1x,p1y,p2x,p2y,p3x,p3y;
			var perpx,perpy,perp2x,perp2y,perp3x,perp3y;
			var a1,b1,c1,a2,b2,c2;
			var denom,pdist,dist;
			p1x=points[0];
			p1y=points[1];
			p2x=points[5];
			p2y=points[6];
			perpx=-(p1y-p2y);
			perpy=p1x-p2x;
			dist=Math.sqrt(perpx *perpx+perpy *perpy);
			perpx=perpx / dist *w;
			perpy=perpy / dist *w;
			result.push(p1x-perpx,p1y-perpy,r,g,b,p1x+perpx,p1y+perpy,r,g,b);
			for (var i=1;i < length-1;i++){
				p1x=points[(i-1)*5];
				p1y=points[(i-1)*5+1];
				p2x=points[(i)*5];
				p2y=points[(i)*5+1];
				p3x=points[(i+1)*5];
				p3y=points[(i+1)*5+1];
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
					result.push(p2x-perpx,p2y-perpy,r,g,b,p2x+perpx,p2y+perpy,r,g,b);
					continue ;
				}
				px=(b1 *c2-b2 *c1)/ denom;
				py=(a2 *c1-a1 *c2)/ denom;
				pdist=(px-p2x)*(px-p2x)+(py-p2y)+(py-p2y);
				result.push(px,py,r,g,b,p2x-(px-p2x),p2y-(py-p2y),r,g,b);
			}
			if (outIndex){
				indices=outIndex;
			};
			var groupLen=this.edges+1;
			for (i=1;i < groupLen;i++){
				indices.push(iStart+(i-1)*2,iStart+(i-1)*2+1,iStart+i *2+1,iStart+i *2+1,iStart+i *2,iStart+(i-1)*2);
			}
			indices.push(iStart+(i-1)*2,iStart+(i-1)*2+1,iStart+1,iStart+1,iStart,iStart+(i-1)*2);
			return result;
		}

		return BasePoly;
	})()


	//class laya.webgl.shapes.GeometryData
	var GeometryData=(function(){
		function GeometryData(lineWidth,lineColor,lineAlpha,fillColor,fillAlpha,fill,shape){
			//this.lineWidth=NaN;
			//this.lineColor=NaN;
			//this.lineAlpha=NaN;
			//this.fillColor=NaN;
			//this.fillAlpha=NaN;
			//this.shape=null;
			//this.fill=false;
			this.lineWidth=lineWidth;
			this.lineColor=lineColor;
			this.lineAlpha=lineAlpha;
			this.fillColor=fillColor;
			this.fillAlpha=fillAlpha;
			this.shape=shape;
			this.fill=fill;
		}

		__class(GeometryData,'laya.webgl.shapes.GeometryData');
		var __proto=GeometryData.prototype;
		__proto.clone=function(){
			return new GeometryData(this.lineWidth,this.lineColor,this.lineAlpha,this.fillColor,this.fillAlpha,this.fill,this.shape);
		}

		__proto.getIndexData=function(){
			return null;
		}

		__proto.getVertexData=function(){
			return null;
		}

		__proto.destroy=function(){
			this.shape=null;
		}

		return GeometryData;
	})()


	//class laya.webgl.shapes.Vertex
	var Vertex=(function(){
		function Vertex(p){
			//this.points=null;
			if((p instanceof Float32Array))
				this.points=p;
			else if((p instanceof Array)){
				var len=p.length;
				this.points=new Float32Array(p);
			}
		}

		__class(Vertex,'laya.webgl.shapes.Vertex');
		var __proto=Vertex.prototype;
		Laya.imps(__proto,{"laya.webgl.shapes.IShape":true})
		__proto.getData=function(ib,vb,start){}
		return Vertex;
	})()


	/**
	*...
	*@author River
	*/
	//class laya.webgl.submit.Submit
	var Submit=(function(){
		function Submit(renderType){
			//this._renderType=0;
			//this._selfVb=null;
			//this._ib=null;
			//this._blendFn=null;
			//this._vb=null;
			//this._startIdx=0;
			//this._numEle=0;
			//this._submitID=NaN;
			//this._mergID=0;
			//this.shaderValue=null;
			(renderType===void 0)&& (renderType=1);
			this._renderType=renderType;
		}

		__class(Submit,'laya.webgl.submit.Submit');
		var __proto=Submit.prototype;
		Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
		__proto.releaseRender=function(){
			var cache=Submit._cache;
			cache[cache._length++]=this;
			this.shaderValue.release();
			this._submitID=-1;
			this._vb=null;
		}

		__proto.getRenderType=function(){
			return this._renderType;
		}

		__proto.renderSubmit=function(){
			if (this._numEle===0)return 1;
			if (this.shaderValue.textureHost){
				if (!this.shaderValue.textureHost.bitmap||!this.shaderValue.textureHost.source)
					return 1;
				this.shaderValue.texture=this.shaderValue.textureHost.source;
			}
			this._ib.upload_bind();
			this._vb.upload_bind();
			this.shaderValue.upload();
			var gl=WebGL.mainContext;
			if (Submit.activeBlendFunction!==this._blendFn){
				gl.enable(/*laya.webgl.WebGLContext.BLEND*/0x0BE2);
				this._blendFn(gl);
				Submit.activeBlendFunction=this._blendFn;
			}
			Stat.drawCall++;
			Stat.trianglesFaces+=this._numEle / 3;
			gl.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,this._numEle,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,this._startIdx);
			return 1;
		}

		Submit.__init__=function(){
			var s=Submit.RENDERBASE=new Submit(-1);
			s.shaderValue=new Value2D(0,0);
			s.shaderValue.ALPHA=-1234;
		}

		Submit.create=function(context,submitID,mergID,ib,vb,pos,sv){
			var o=Submit._cache._length?Submit._cache[--Submit._cache._length]:new Submit();
			if (vb==null){
				vb=o._selfVb || (o._selfVb=new Buffer(/*laya.webgl.WebGLContext.ARRAY_BUFFER*/0x8892));
				vb.clear();
				pos=0;
			}
			o._ib=ib;
			o._vb=vb;
			o._submitID=submitID;
			o._mergID=mergID;
			o._startIdx=pos *CONST3D2D.BYTES_PIDX;
			o._numEle=0;
			var blendType=context._nBlendType;
			o._blendFn=context._targets?BlendMode.targetFns[blendType]:BlendMode.fns[blendType];
			o.shaderValue=sv;
			o.shaderValue.setValue(context._shader2D);
			var filters=context._shader2D.filters;
			filters && o.shaderValue.setFilters(filters);
			return o;
		}

		Submit.createShape=function(ctx,ib,vb,numEle,offset,sv){
			var o=(!Submit._cache._length)?(new Submit()):Submit._cache[--Submit._cache._length];
			o._ib=ib;
			o._vb=vb;
			o._numEle=numEle;
			o._startIdx=offset;
			o.shaderValue=sv;
			o.shaderValue.setValue(ctx._shader2D);
			var blendType=ctx._nBlendType;
			o._blendFn=ctx._targets?BlendMode.targetFns[blendType]:BlendMode.fns[blendType];
			return o;
		}

		Submit.TYPE_2D=1;
		Submit.TYPE_CANVAS=3;
		Submit.TYPE_CMDSETRT=4;
		Submit.TYPE_CUSTOM=5;
		Submit.TYPE_BLURRT=6;
		Submit.TYPE_CMDDESTORYPRERT=7;
		Submit.TYPE_DISABLESTENCIL=8;
		Submit.TYPE_OTHERIBVB=9;
		Submit.TYPE_PRIMITIVE=10;
		Submit.TYPE_RT=11;
		Submit.TYPE_BLUR_RT=12;
		Submit.TYPE_TARGET=13;
		Submit.TYPE_CHANGE_VALUE=14;
		Submit.TYPE_SHAPE=15;
		Submit.RENDERBASE=null
		Submit.activeBlendFunction=null;
		Submit._cache=(Submit._cache=[],Submit._cache._length=0,Submit._cache);
		return Submit;
	})()


	//class laya.webgl.submit.SubmitCMD
	var SubmitCMD=(function(){
		function SubmitCMD(){
			this.fun=null;
			this.args=null;
		}

		__class(SubmitCMD,'laya.webgl.submit.SubmitCMD');
		var __proto=SubmitCMD.prototype;
		Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
		//debugger;
		__proto.renderSubmit=function(){
			this.fun.apply(null,this.args);
			return 1;
		}

		__proto.getRenderType=function(){
			return 0;
		}

		__proto.releaseRender=function(){
			var cache=SubmitCMD._cache;
			cache[cache._length++]=this;
		}

		SubmitCMD.create=function(args,fun){
			var o=SubmitCMD._cache._length?SubmitCMD._cache[--SubmitCMD._cache._length]:new SubmitCMD();
			o.fun=fun;
			o.args=args;
			return o;
		}

		SubmitCMD._cache=(SubmitCMD._cache=[],SubmitCMD._cache._length=0,SubmitCMD._cache);
		return SubmitCMD;
	})()


	//class laya.webgl.submit.SubmitCMDScope
	var SubmitCMDScope=(function(){
		function SubmitCMDScope(){
			this.variables={};
		}

		__class(SubmitCMDScope,'laya.webgl.submit.SubmitCMDScope');
		var __proto=SubmitCMDScope.prototype;
		__proto.getValue=function(name){
			return this.variables[name];
		}

		__proto.addValue=function(name,value){
			return this.variables[name]=value;
		}

		__proto.setValue=function(name,value){
			if(this.variables.hasOwnProperty(name)){
				return this.variables[name]=value;
			}
			return null;
		}

		__proto.clear=function(){
			for(var key in this.variables){
				delete this.variables[key];
			}
		}

		__proto.recycle=function(){
			this.clear();
			SubmitCMDScope.POOL.push(this);
		}

		SubmitCMDScope.create=function(){
			var scope=SubmitCMDScope.POOL.pop();
			scope||(scope=new SubmitCMDScope());
			return scope;
		}

		SubmitCMDScope.POOL=[];
		return SubmitCMDScope;
	})()


	/**
	*...
	*@author wk
	*/
	//class laya.webgl.submit.SubmitOtherIBVB
	var SubmitOtherIBVB=(function(){
		function SubmitOtherIBVB(){
			this.offset=0;
			//this._vb=null;
			//this._ib=null;
			//this._blendFn=null;
			//this._mat=null;
			//this._shader=null;
			//this._shaderValue=null;
			//this._numEle=0;
			this.startIndex=0;
			;
			this._mat=Matrix.create();
		}

		__class(SubmitOtherIBVB,'laya.webgl.submit.SubmitOtherIBVB');
		var __proto=SubmitOtherIBVB.prototype;
		Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
		__proto.releaseRender=function(){
			var cache=SubmitOtherIBVB._cache;
			cache[cache._length++]=this;
		}

		__proto.getRenderType=function(){
			return /*laya.webgl.submit.Submit.TYPE_OTHERIBVB*/9;
		}

		__proto.renderSubmit=function(){
			if (this._shaderValue.textureHost){
				var source=this._shaderValue.textureHost.source;
				if (!source)return 1;
				this._shaderValue.texture=source;
			}
			this._ib.upload_bind();
			this._vb.upload_bind();
			var w=RenderState2D.worldMatrix4;
			var wmat=Matrix.TEMP;
			Matrix.mulPre(this._mat,w[0],w[1],w[4],w[5],w[12],w[13],wmat);
			var tmp=RenderState2D.worldMatrix4=SubmitOtherIBVB.tempMatrix4;
			tmp[0]=wmat.a;
			tmp[1]=wmat.b;
			tmp[4]=wmat.c;
			tmp[5]=wmat.d;
			tmp[12]=wmat.tx;
			tmp[13]=wmat.ty;
			this._shader._offset=this.offset;
			this._shaderValue.refresh();
			this._shader.upload(this._shaderValue);
			this._shader._offset=0;
			var gl=WebGL.mainContext;
			if (Submit.activeBlendFunction!==this._blendFn){
				gl.enable(/*laya.webgl.WebGLContext.BLEND*/0x0BE2);
				this._blendFn(gl);
				Submit.activeBlendFunction=this._blendFn;
			}
			Stat.drawCall++;
			Stat.trianglesFaces+=this._numEle/3;
			gl.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,this._numEle,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,this.startIndex);
			RenderState2D.worldMatrix4=w;
			Shader.activeShader=null;
			return 1;
		}

		SubmitOtherIBVB.create=function(context,vb,ib,numElement,shader,shaderValue,startIndex,offset){
			var o=(!SubmitOtherIBVB._cache._length)?(new SubmitOtherIBVB()):SubmitOtherIBVB._cache[--SubmitOtherIBVB._cache._length];
			o._ib=ib;
			o._vb=vb;
			o._numEle=numElement;
			o._shader=shader;
			o._shaderValue=shaderValue;
			var blendType=context._nBlendType;
			o._blendFn=context._targets?BlendMode.targetFns[blendType]:BlendMode.fns[blendType];
			o.startIndex=startIndex;
			o.offset=offset;
			return o;
		}

		SubmitOtherIBVB._cache=(SubmitOtherIBVB._cache=[],SubmitOtherIBVB._cache._length=0,SubmitOtherIBVB._cache);
		SubmitOtherIBVB.tempMatrix4=[
		1,0,0,0,
		0,1,0,0,
		0,0,1,0,
		0,0,0,1,];
		return SubmitOtherIBVB;
	})()


	//class laya.webgl.submit.SubmitScissor
	var SubmitScissor=(function(){
		function SubmitScissor(){
			this.submitIndex=0;
			this.submitLength=0;
			this.context=null;
			this.clipRect=new Rectangle();
			this.screenRect=new Rectangle();
		}

		__class(SubmitScissor,'laya.webgl.submit.SubmitScissor');
		var __proto=SubmitScissor.prototype;
		Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
		__proto._scissor=function(x,y,w,h){
			var m=RenderState2D.worldMatrix4;
			var a=m[0],d=m[5],tx=m[12],ty=m[13];
			x=x *a+tx;
			y=y *d+ty;
			w *=a;
			h *=d;
			if (w < 1 || h < 1){
				return false;
			};
			var r=x+w;
			var b=y+h;
			x < 0 && (x=0,w=r-x);
			y < 0 && (y=0,h=b-y);
			var screen=RenderState2D.worldClipRect;
			x=Math.max(x,screen.x);
			y=Math.max(y,screen.y);
			w=Math.min(r,screen.right)-x;
			h=Math.min(b,screen.bottom)-y;
			if (w < 1 || h < 1){
				return false;
			};
			var worldScissorTest=RenderState2D.worldScissorTest;
			this.screenRect.copyFrom(screen);
			screen.x=x;
			screen.y=y;
			screen.width=w;
			screen.height=h;
			RenderState2D.worldScissorTest=true;
			y=RenderState2D.height-y-h;
			WebGL.mainContext.scissor(x,y,w,h);
			WebGL.mainContext.enable(/*laya.webgl.WebGLContext.SCISSOR_TEST*/0x0C11);
			this.context.submitElement(this.submitIndex,this.submitIndex+this.submitLength);
			if (worldScissorTest){
				y=RenderState2D.height-this.screenRect.y-this.screenRect.height;
				WebGL.mainContext.scissor(this.screenRect.x,y,this.screenRect.width,this.screenRect.height);
				WebGL.mainContext.enable(/*laya.webgl.WebGLContext.SCISSOR_TEST*/0x0C11);
			}
			else{
				WebGL.mainContext.disable(/*laya.webgl.WebGLContext.SCISSOR_TEST*/0x0C11);
				RenderState2D.worldScissorTest=false;
			}
			screen.copyFrom(this.screenRect);
			return true;
		}

		__proto._scissorWithTagart=function(x,y,w,h){
			if (w < 1 || h < 1){
				return false;
			};
			var r=x+w;
			var b=y+h;
			x < 0 && (x=0,w=r-x);
			y < 0 && (y=0,h=b-y);
			var screen=RenderState2D.worldClipRect;
			x=Math.max(x,screen.x);
			y=Math.max(y,screen.y);
			w=Math.min(r,screen.right)-x;
			h=Math.min(b,screen.bottom)-y;
			if (w < 1 || h < 1){
				return false;
			};
			var worldScissorTest=RenderState2D.worldScissorTest;
			this.screenRect.copyFrom(screen);
			RenderState2D.worldScissorTest=true;
			screen.x=x;
			screen.y=y;
			screen.width=w;
			screen.height=h;
			y=RenderState2D.height-y-h;
			WebGL.mainContext.scissor(x,y,w,h);
			WebGL.mainContext.enable(/*laya.webgl.WebGLContext.SCISSOR_TEST*/0x0C11);
			this.context.submitElement(this.submitIndex,this.submitIndex+this.submitLength);
			if (worldScissorTest){
				y=RenderState2D.height-this.screenRect.y-this.screenRect.height;
				WebGL.mainContext.scissor(this.screenRect.x,y,this.screenRect.width,this.screenRect.height);
				WebGL.mainContext.enable(/*laya.webgl.WebGLContext.SCISSOR_TEST*/0x0C11);
			}
			else{
				WebGL.mainContext.disable(/*laya.webgl.WebGLContext.SCISSOR_TEST*/0x0C11);
				RenderState2D.worldScissorTest=false;
			}
			screen.copyFrom(this.screenRect);
			return true;
		}

		__proto.renderSubmit=function(){
			this.submitLength=Math.min(this.context._submits._length-1,this.submitLength);
			if (this.submitLength < 1 || this.clipRect.width < 1 || this.clipRect.height < 1)
				return this.submitLength+1;
			if (this.context._targets)
				this._scissorWithTagart(this.clipRect.x,this.clipRect.y,this.clipRect.width,this.clipRect.height);
			else this._scissor(this.clipRect.x,this.clipRect.y,this.clipRect.width,this.clipRect.height);
			return this.submitLength+1;
		}

		__proto.getRenderType=function(){
			return 0;
		}

		__proto.releaseRender=function(){
			var cache=SubmitScissor._cache;
			cache[cache._length++]=this;
			this.context=null;
		}

		SubmitScissor.create=function(context){
			var o=SubmitScissor._cache._length?SubmitScissor._cache[--SubmitScissor._cache._length]:new SubmitScissor();
			o.context=context;
			return o;
		}

		SubmitScissor._cache=(SubmitScissor._cache=[],SubmitScissor._cache._length=0,SubmitScissor._cache);
		return SubmitScissor;
	})()


	//class laya.webgl.submit.SubmitStencil
	var SubmitStencil=(function(){
		function SubmitStencil(){
			this.step=0;
			this.level=0;
		}

		__class(SubmitStencil,'laya.webgl.submit.SubmitStencil');
		var __proto=SubmitStencil.prototype;
		Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
		__proto.renderSubmit=function(){
			switch(this.step){
				case 1:
					this.do1();
					break ;
				case 2:
					this.do2();
					break ;
				case 3:
					this.do3();
					break ;
				}
			return 1;
		}

		__proto.getRenderType=function(){
			return 0;
		}

		__proto.releaseRender=function(){
			var cache=SubmitStencil._cache;
			cache[cache._length++]=this;
		}

		__proto.do1=function(){
			var gl=WebGL.mainContext;
			gl.enable(/*laya.webgl.WebGLContext.STENCIL_TEST*/0x0B90);
			gl.clear(/*laya.webgl.WebGLContext.STENCIL_BUFFER_BIT*/0x00000400);
			gl.colorMask(false,false,false,false);
			gl.stencilFunc(/*laya.webgl.WebGLContext.EQUAL*/0x0202,this.level,0xFF);
			gl.stencilOp(/*laya.webgl.WebGLContext.KEEP*/0x1E00,/*laya.webgl.WebGLContext.KEEP*/0x1E00,/*laya.webgl.WebGLContext.INCR*/0x1E02);
		}

		//gl.stencilOp(WebGLContext.KEEP,WebGLContext.KEEP,WebGLContext.INVERT);//测试通过给模版缓冲 写入值 一开始是0 现在是 0xFF (模版缓冲中不知道是多少位的数据)
		__proto.do2=function(){
			var gl=WebGL.mainContext;
			gl.stencilFunc(/*laya.webgl.WebGLContext.EQUAL*/0x0202,this.level+1,0xFF);
			gl.colorMask(true,true,true,true);
			gl.stencilOp(/*laya.webgl.WebGLContext.KEEP*/0x1E00,/*laya.webgl.WebGLContext.KEEP*/0x1E00,/*laya.webgl.WebGLContext.KEEP*/0x1E00);
		}

		__proto.do3=function(){
			var gl=WebGL.mainContext;
			gl.clear(/*laya.webgl.WebGLContext.STENCIL_BUFFER_BIT*/0x00000400);
			gl.disable(/*laya.webgl.WebGLContext.STENCIL_TEST*/0x0B90);
		}

		SubmitStencil.create=function(step){
			var o=SubmitStencil._cache._length?SubmitStencil._cache[--SubmitStencil._cache._length]:new SubmitStencil();
			o.step=step;
			return o;
		}

		SubmitStencil._cache=(SubmitStencil._cache=[],SubmitStencil._cache._length=0,SubmitStencil._cache);
		return SubmitStencil;
	})()


	//class laya.webgl.submit.SubmitTarget
	var SubmitTarget=(function(){
		function SubmitTarget(){
			this._renderType=0;
			this._vb=null;
			this._ib=null;
			this._startIdx=0;
			this._numEle=0;
			this.shaderValue=null;
			this.blendType=0;
			this.proName=null;
			this.scope=null;
		}

		__class(SubmitTarget,'laya.webgl.submit.SubmitTarget');
		var __proto=SubmitTarget.prototype;
		Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
		__proto.renderSubmit=function(){
			this._ib.upload_bind();
			this._vb.upload_bind();
			var target=this.scope.getValue(this.proName);
			this.shaderValue.texture=target.source;
			this.shaderValue.upload();
			this.blend();
			Stat.drawCall++;
			Stat.trianglesFaces+=this._numEle/3;
			WebGL.mainContext.drawElements(/*laya.webgl.WebGLContext.TRIANGLES*/0x0004,this._numEle,/*laya.webgl.WebGLContext.UNSIGNED_SHORT*/0x1403,this._startIdx);
			return 1;
		}

		__proto.blend=function(){
			if (SubmitTarget.activeBlendType!==this.blendType){
				var gl=WebGL.mainContext;
				gl.enable(/*laya.webgl.WebGLContext.BLEND*/0x0BE2);
				BlendMode.fns[this.blendType](gl);
				SubmitTarget.activeBlendType=this.blendType;
			}
		}

		__proto.getRenderType=function(){
			return 0;
		}

		__proto.releaseRender=function(){
			var cache=SubmitTarget._cache;
			cache[cache._length++]=this;
		}

		SubmitTarget.create=function(context,ib,vb,pos,sv,proName){
			var o=SubmitTarget._cache._length?SubmitTarget._cache[--SubmitTarget._cache._length]:new SubmitTarget();
			o._ib=ib;
			o._vb=vb;
			o.proName=proName;
			o._startIdx=pos *CONST3D2D.BYTES_PIDX;
			o._numEle=0;
			o.blendType=context._nBlendType;
			o.shaderValue=sv;
			o.shaderValue.setValue(context._shader2D);
			return o;
		}

		SubmitTarget.activeBlendType=-1;
		SubmitTarget._cache=(SubmitTarget._cache=[],SubmitTarget._cache._length=0,SubmitTarget._cache);
		return SubmitTarget;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.webgl.text.CharValue
	var CharValue=(function(){
		function CharValue(){
			//this.txtID=NaN;
			//this.font=null;
			//this.fillColor=null;
			//this.borderColor=null;
			//this.lineWidth=0;
			//this.size=NaN;
			//this.scaleX=NaN;
			//this.scaleY=NaN;
		}

		__class(CharValue,'laya.webgl.text.CharValue');
		var __proto=CharValue.prototype;
		__proto.value=function(font,fillColor,borderColor,lineWidth,size,scaleX,scaleY){
			this.font=font;
			this.fillColor=fillColor;
			this.borderColor=borderColor;
			this.lineWidth=lineWidth;
			this.size=size;
			this.scaleX=scaleX;
			this.scaleY=scaleY;
			var key=[font,scaleX,scaleY,lineWidth,fillColor,borderColor].join('`');
			this.txtID=CharValue._keymap[key]
			if (!this.txtID){
				this.txtID=(++CharValue._keymapCount)*0.0000001;
				CharValue._keymap[key]=this.txtID;
			}
		}

		CharValue._keymap={};
		CharValue._keymapCount=1;
		return CharValue;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.text.DrawText
	var DrawText=(function(){
		function DrawText(){};
		__class(DrawText,'laya.webgl.text.DrawText');
		DrawText.getChar=function(char,id,drawValue){
			return DrawText._wordsMsg[id]=DrawTextChar.createOneChar(char,drawValue);
		}

		DrawText.drawText=function(ctx,txt,words,curMat,font,textAlign,fillColor,borderColor,lineWidth,x,y){
			if (txt && txt.length===0)return;
			if (words && words.length===0)return;
			DrawText._fontTemp || (DrawText._fontTemp=new FontInContext());
			var i,n;
			var rot=curMat.b==0 && curMat.c==0 ? 0 :1;
			var sx=curMat.a,sy=curMat.d;
			(rot!==0)&& (sx=sy=1);
			sx=sy=1;
			var sx2=1,sy2=1;
			var italic=font.hasType("italic");
			if (sx !=1 || sy !=1 || italic >=0)font=font.copyTo(DrawText._fontTemp);
			italic >=0 && font.removeType("italic");
			if (sx !=1 || sy !=1){
				if (sx > sy){
					font.size=font.size *sx;
					sy2=sy / sx;
					}else {
					font.size=font.size *sy;
					sx2=sx / sy;
				}
				font.size=Math.floor(font.size);
			};
			var width=0;
			var chars=DrawText._charsTemp;
			var oneChar;
			var htmlWord;
			var id;
			var size=Math.floor(font.size / 16+0.5)*16;
			var drawValue=DrawText._drawValue;
			drawValue.value(font,fillColor,borderColor,lineWidth,size,sx2,sy2);
			if (words){
				chars.length=words.length;
				for (i=0,n=words.length;i < n;i++){
					htmlWord=words[i];
					id=htmlWord.charNum+drawValue.txtID;
					chars[i]=oneChar=DrawText._wordsMsg[id] || DrawText.getChar(htmlWord.char,id,drawValue);
					oneChar.active();
				}
				}else {
				chars.length=txt.length;
				for (i=0,n=txt.length;i < n;i++){
					id=txt.charCodeAt(i)+drawValue.txtID;
					chars[i]=oneChar=DrawText._wordsMsg[id] || DrawText.getChar(txt.charAt(i),id,drawValue);
					oneChar.active();
					width+=oneChar.width;
				}
			};
			var curMat2=curMat;
			if (sx !=1 || sy !=1 || italic >=0){
				curMat2=WebGLContext2D._tmpMatrix;
				curMat.copy(curMat2);
			}
			if (sx !=1 || sy !=1){
				var tx=curMat2.tx;
				var ty=curMat2.ty;
				curMat2.scale(1 / sx,1 / sy);
				curMat2.tx=tx;
				curMat2.ty=ty;
				x *=sx;
				y *=sy;
			}
			curMat2.tx |=0;
			curMat2.ty |=0;
			switch (textAlign){
				case "center":
					x-=width / 2;
					break ;
				case "right":
					x-=width;
					break ;
				};
			var dx;
			var uv;
			var bdSz;
			var texture;
			if (words){
				for (i=0,n=chars.length;i < n;i++){
					oneChar=chars[i];
					if (!oneChar.isSpace){
						htmlWord=words[i];
						dx=italic >=0 ? (oneChar.height *0.4):0;
						bdSz=oneChar.borderSize;
						texture=oneChar.texture;
						ctx._drawText(texture,x+htmlWord.x *sx-bdSz,y+htmlWord.y *sy-bdSz,
						texture.width,texture.height,curMat2,0,0,dx,0);
					}
				}
				}else {
				for (i=0,n=chars.length;i < n;i++){
					oneChar=chars[i];
					if (!oneChar.isSpace){
						dx=italic >=0 ? (oneChar.height *0.4):0;
						bdSz=oneChar.borderSize;
						texture=oneChar.texture;
						ctx._drawText(texture,x-bdSz,y-bdSz,
						texture.width,texture.height,curMat2,0,0,dx,0);
					}
					x+=oneChar.width;
				}
			}
		}

		DrawText._wordsMsg={};
		DrawText._charsTemp=new Array;
		DrawText._fontTemp=null;
		__static(DrawText,
		['_drawValue',function(){return this._drawValue=new CharValue();}
		]);
		return DrawText;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.webgl.text.DrawTextChar
	var DrawTextChar=(function(){
		function DrawTextChar(content,drawValue){
			//this.xs=NaN;
			//this.ys=NaN;
			//this.width=0;
			//this.height=0;
			//this.char=null;
			//this.fillColor=null;
			//this.borderColor=null;
			//this.borderSize=0;
			//this.font=null;
			//this.fontSize=0;
			//this.texture=null;
			//this.lineWidth=0;
			//this.UV=null;
			//this.isSpace=false;
			this.char=content;
			this.isSpace=content===' ';
			this.xs=drawValue.scaleX;
			this.ys=drawValue.scaleY;
			this.font=drawValue.font.toString();
			this.fontSize=drawValue.size;
			this.fillColor=drawValue.fillColor;
			this.borderColor=drawValue.borderColor;
			this.lineWidth=drawValue.lineWidth;
			var bIsConchApp=System.isConchApp;
			if (bIsConchApp){
				/*__JS__ */canvas=ConchTextCanvas;;
				/*__JS__ */canvas._source=ConchTextCanvas;;
				/*__JS__ */canvas._source.canvas=ConchTextCanvas;;
			}
			else{
				this.texture=new Texture(new WebGLCharImage(Browser.canvas.source,this));
				(!AtlasManager.enabled)&& (System.addToAtlas)&& (System.addToAtlas(this.texture,true));
			}
		}

		__class(DrawTextChar,'laya.webgl.text.DrawTextChar');
		var __proto=DrawTextChar.prototype;
		//如果没有开启大图合集则也强制加入图集中
		__proto.active=function(){
			this.texture.active();
		}

		DrawTextChar.createOneChar=function(content,drawValue){
			var char=new DrawTextChar(content,drawValue);
			return char;
		}

		return DrawTextChar;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.text.FontInContext
	var FontInContext=(function(){
		function FontInContext(font){
			//this._text=null;
			//this._words=null;
			this._index=0;
			this._size=14;
			this.setFont(font || "14px Arial");
		}

		__class(FontInContext,'laya.webgl.text.FontInContext');
		var __proto=FontInContext.prototype;
		__proto.setFont=function(value){
			this._words=value.split(' ');
			for (var i=0,n=this._words.length;i < n;i++){
				if (this._words[i].indexOf('px')> 0){
					this._index=i;
					break ;
				}
			}
			this._size=Laya.__parseInt(this._words[this._index]);
			this._text=null;
		}

		__proto.hasType=function(name){
			for (var i=0,n=this._words.length;i < n;i++)
			if (this._words[i]===name)return i;
			return-1;
		}

		__proto.removeType=function(name){
			for (var i=0,n=this._words.length;i < n;i++)
			if (this._words[i]===name){
				this._words.splice(i,1);
				if (this._index > i)this._index--;
				break ;
			}
			this._text=null;
		}

		__proto.copyTo=function(dec){
			dec._text=this._text;
			dec._size=this._size;
			dec._index=this._index;
			dec._words=this._words.slice();
			return dec;
		}

		__proto.toString=function(){
			return this._text?this._text:(this._text=this._words.join(' '));
		}

		__getset(0,__proto,'size',function(){
			return this._size;
			},function(value){
			this._size=value;
			this._words[this._index]=value+"px";
			this._text=null;
		});

		FontInContext.EMPTY=new FontInContext();
		return FontInContext;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.utils.CONST3D2D
	var CONST3D2D=(function(){
		function CONST3D2D(){};
		__class(CONST3D2D,'laya.webgl.utils.CONST3D2D');
		CONST3D2D.BYTES_PE=/*__JS__ */window.Float32Array && Float32Array.BYTES_PER_ELEMENT;
		CONST3D2D.BYTES_PIDX=/*__JS__ */window.Uint16Array && Uint16Array.BYTES_PER_ELEMENT;
		CONST3D2D.defaultMatrix4=[
		1,0,0,0,
		0,1,0,0,
		0,0,1,0,
		0,0,0,1,];
		CONST3D2D.defaultMinusYMatrix4=[
		1,0,0,0,
		0,-1,0,0,
		0,0,1,0,
		0,0,0,1,];
		CONST3D2D.uniformMatrix3=[
		1,0 ,0,0,
		0,1,0,0,
		0,0,1,0];
		CONST3D2D._TMPARRAY=[];
		CONST3D2D._OFFSETX=0;
		CONST3D2D._OFFSETY=0;
		return CONST3D2D;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.utils.GlUtils
	var GlUtils=(function(){
		function GlUtils(){};
		__class(GlUtils,'laya.webgl.utils.GlUtils');
		GlUtils.make2DProjection=function(width,height,depth){
			return [
			2.0 / width,0,0,0,
			0,-2.0 / height,0,0,
			0,0,2.0 / depth,0,
			-1,1,0,1,];
		}

		GlUtils.fillIBQuadrangle=function(buffer,count){
			if (count> 65535/4){
				throw Error("IBQuadrangle count:"+count+" must<:"+Math.floor(65535/4));
				return false;
			}
			count=Math.floor(count);
			buffer._resizeBuffer((count+1)*6 */*laya.webgl.utils.Buffer.SHORT*/2,false);
			buffer.length=buffer.bufferLength;
			var bufferData=new Uint16Array(buffer.getBuffer());
			var idx=0;
			for (var i=0;i < count;i++){
				bufferData[idx++]=i *4;
				bufferData[idx++]=i *4+2;
				bufferData[idx++]=i *4+1;
				bufferData[idx++]=i *4;
				bufferData[idx++]=i *4+3;
				bufferData[idx++]=i *4+2;
			}
			buffer.setNeedUpload();
			buffer.upload();
			return true;
		}

		GlUtils.expandIBQuadrangle=function(buffer,count){
			buffer.bufferLength >=(count *6 */*laya.webgl.utils.Buffer.SHORT*/2)|| GlUtils.fillIBQuadrangle(buffer,count);
		}

		GlUtils.mathCeilPowerOfTwo=function(value){
			value--;
			value |=value >> 1;
			value |=value >> 2;
			value |=value >> 4;
			value |=value >> 8;
			value |=value >> 16;
			value++;
			return value;
		}

		GlUtils.fillQuadrangleImgVb=function(vb,x,y,point4,uv,m,_x,_y){
			'use strict';
			x |=0;y |=0;_x |=0;_y |=0;
			var vpos=(vb._length>>2)+/*laya.webgl.canvas.WebGLContext2D._RECTVBSIZE*/16;
			vb.length=(vpos << 2);
			var vbdata=vb.getFloat32Array();
			vpos-=/*laya.webgl.canvas.WebGLContext2D._RECTVBSIZE*/16;
			vbdata[vpos+2]=uv[0];
			vbdata[vpos+3]=uv[1];
			vbdata[vpos+6]=uv[2];
			vbdata[vpos+7]=uv[3];
			vbdata[vpos+10]=uv[4];
			vbdata[vpos+11]=uv[5];
			vbdata[vpos+14]=uv[6];
			vbdata[vpos+15]=uv[7];
			var a=m.a,b=m.b,c=m.c,d=m.d;
			if (a!==1 || b!==0 || c!==0 || d!==1){
				m.bTransform=true;
				var tx=m.tx+_x,ty=m.ty+_y;
				vbdata[vpos]=(point4[0]+x)*a+(point4[1]+y)*c+tx;
				vbdata[vpos+1]=(point4[0]+x)*b+(point4[1]+y)*d+ty;
				vbdata[vpos+4]=(point4[2]+x)*a+(point4[3]+y)*c+tx;
				vbdata[vpos+5]=(point4[2]+x)*b+(point4[3]+y)*d+ty;
				vbdata[vpos+8]=(point4[4]+x)*a+(point4[5]+y)*c+tx;
				vbdata[vpos+9]=(point4[4]+x)*b+(point4[5]+y)*d+ty;
				vbdata[vpos+12]=(point4[6]+x)*a+(point4[7]+y)*c+tx;
				vbdata[vpos+13]=(point4[6]+x)*b+(point4[7]+y)*d+ty;
			}
			else{
				m.bTransform=false;
				x+=m.tx+_x;
				y+=m.ty+_y;
				vbdata[vpos]=x+point4[0];
				vbdata[vpos+1]=y+point4[1];
				vbdata[vpos+4]=x+point4[2];
				vbdata[vpos+5]=y+point4[3];
				vbdata[vpos+8]=x+point4[4];
				vbdata[vpos+9]=y+point4[5];
				vbdata[vpos+12]=x+point4[6];
				vbdata[vpos+13]=y+point4[7];
			}
			vb._upload=true;
			return true;
		}

		GlUtils.fillTranglesVB=function(vb,x,y,points,m,_x,_y){
			'use strict';
			x |=0;y |=0;_x |=0;_y |=0;
			var vpos=(vb._length >> 2)+points.length;
			vb.length=(vpos << 2);
			var vbdata=vb.getFloat32Array();
			vpos-=points.length;
			var len=points.length;
			var a=m.a,b=m.b,c=m.c,d=m.d;
			for (var i=0;i < len;i+=4){
				vbdata[vpos+i+2]=points[i+2];
				vbdata[vpos+i+3]=points[i+3];
				if (a!==1 || b!==0 || c!==0 || d!==1){
					m.bTransform=true;
					var tx=m.tx+_x,ty=m.ty+_y;
					vbdata[vpos+i]=(points[i]+x)*a+(points[i+1]+y)*c+tx;
					vbdata[vpos+i+1]=(points[i]+x)*b+(points[i+1]+y)*d+ty;
				}
				else{
					m.bTransform=false;
					x+=m.tx+_x;
					y+=m.ty+_y;
					vbdata[vpos+i]=x+points[i];
					vbdata[vpos+i+1]=y+points[i+1];
				}
			}
			vb._upload=true;
			return true;
		}

		GlUtils.fillRectImgVb=function(vb,clip,x,y,width,height,uv,m,_x,_y,dx,dy){
			'use strict';
			var mType=1;
			var toBx,toBy,toEx,toEy;
			var cBx,cBy,cEx,cEy;
			var w0,h0,tx,ty;
			var a=m.a,b=m.b,c=m.c,d=m.d;
			var useClip=false;
			if (a!==1 || b!==0 || c!==0 || d!==1){
				m.bTransform=true;
				if (b===0 && c===0){
					mType=useClip?30:23;
					w0=width+x,h0=height+y;
					tx=m.tx+_x,ty=m.ty+_y;
					toBx=a *x+tx;
					toEx=a *w0+tx;
					toBy=d *y+ty;
					toEy=d *h0+ty;
				}
			}
			else{
				x |=0;y |=0;_x |=0;_y |=0;
				mType=useClip?30:23;
				m.bTransform=false;
				toBx=x+m.tx+_x;
				toEx=toBx+width;
				toBy=y+m.ty+_y;
				toEy=toBy+height;
			}
			if (useClip){
				cBx=clip.x,cBy=clip.y,cEx=clip.width+cBx,cEy=clip.height+cBy;
			}
			if (mType!==1 && (toBx >=cEx || toBy >=cEy || toEx <=cBx || toEy <=cBy))
				return false;
			var vpos=(vb._length >> 2)+/*laya.webgl.canvas.WebGLContext2D._RECTVBSIZE*/16;
			vb.seLength((vpos << 2));
			var vbdata=vb.getFloat32Array();
			vpos-=/*laya.webgl.canvas.WebGLContext2D._RECTVBSIZE*/16;
			vbdata[vpos+2]=uv[0];
			vbdata[vpos+3]=uv[1];
			vbdata[vpos+6]=uv[2];
			vbdata[vpos+7]=uv[3];
			vbdata[vpos+10]=uv[4];
			vbdata[vpos+11]=uv[5];
			vbdata[vpos+14]=uv[6];
			vbdata[vpos+15]=uv[7];
			switch(mType){
				case 1:
					tx=m.tx+_x,ty=m.ty+_y;
					w0=width+x,h0=height+y;
					var w1=x,h1=y;
					var aw1=a *w1,ch1=c *h1,dh1=d *h1,bw1=b *w1;
					var aw0=a *w0,ch0=c *h0,dh0=d *h0,bw0=b *w0;
					vbdata[vpos]=aw1+ch1+tx;
					vbdata[vpos+1]=dh1+bw1+ty;
					vbdata[vpos+4]=aw0+ch1+tx;
					vbdata[vpos+5]=dh1+bw0+ty;
					vbdata[vpos+8]=aw0+ch0+tx;
					vbdata[vpos+9]=dh0+bw0+ty;
					vbdata[vpos+12]=aw1+ch0+tx;
					vbdata[vpos+13]=dh0+bw1+ty;
					break ;
				case 23:
					vbdata[vpos]=toBx+dx;
					vbdata[vpos+1]=toBy;
					vbdata[vpos+4]=toEx+dx;
					vbdata[vpos+5]=toBy;
					vbdata[vpos+8]=toEx;
					vbdata[vpos+9]=toEy;
					vbdata[vpos+12]=toBx;
					vbdata[vpos+13]=toEy;
					break ;
				case 30:
					if (toBx < cBx || toBy < cBy || toEx > cEx || toEy > cEy){
						var dcx=cBx-toBx,dcty=cBy-toBy,decr=toEx-cEx,decb=toEy-cEy;
						if(dcx > 0){toBx=cBx;vbdata[vpos+14]=vbdata[vpos+2]=vbdata[vpos+2]+dcx / (width *a)*(vbdata[vpos+6]-vbdata[vpos+2])};
						if(dcty > 0){toBy=cBy;vbdata[vpos+7]=vbdata[vpos+3]=vbdata[vpos+3]+dcty / (height *d)*(vbdata[vpos+11]-vbdata[vpos+7])};
						if(decr > 0){toEx=cEx;vbdata[vpos+6]=vbdata[vpos+10]=vbdata[vpos+6]-decr / (width *a)*(vbdata[vpos+6]-vbdata[vpos+2])};
						if(decb > 0){toEy=cEy;vbdata[vpos+11]=vbdata[vpos+15]=vbdata[vpos+15]-decb / (height *d)*(vbdata[vpos+11]-vbdata[vpos+7])};
					}
					vbdata[vpos]=toBx+dx;
					vbdata[vpos+1]=toBy;
					vbdata[vpos+4]=toEx+dx;
					vbdata[vpos+5]=toBy;
					vbdata[vpos+8]=toEx;
					vbdata[vpos+9]=toEy;
					vbdata[vpos+12]=toBx;
					vbdata[vpos+13]=toEy;
				}
			vb._upload=true;
			return true;
		}

		GlUtils.fillLineVb=function(vb,clip,fx,fy,tx,ty,width,mat){
			'use strict';
			var linew=width *.5;
			var data=GlUtils._fillLineArray;
			var perpx=-(fy-ty),perpy=fx-tx;
			var dist=Math.sqrt(perpx*perpx+perpy*perpy);
			perpx /=dist,perpy /=dist,perpx *=width,perpy *=width;
			data[0]=fx-perpx,data[1]=fy-perpy,data[4]=fx+perpx,data[5]=fy+perpy,data[8]=tx+perpx,data[9]=ty+perpy,data[12]=tx-perpx,data[13]=ty-perpy;
			mat&&mat.transformPointArray(data,data);
			var vpos=(vb._length >> 2)+/*laya.webgl.canvas.WebGLContext2D._RECTVBSIZE*/16;
			vb.length=(vpos << 2);
			var vbdata=vb.getFloat32Array();
			vbdata.set(data,vpos-/*laya.webgl.canvas.WebGLContext2D._RECTVBSIZE*/16);
			vb._upload=true;
			return true;
		}

		GlUtils._fillLineArray=[[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]];
		return GlUtils;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.utils.RenderState2D
	var RenderState2D=(function(){
		function RenderState2D(){};
		__class(RenderState2D,'laya.webgl.utils.RenderState2D');
		RenderState2D.mat2MatArray=function(mat,matArray){
			var m=mat;
			var m4=matArray;
			m4[0]=m.a;
			m4[1]=m.b;
			m4[4]=m.c;
			m4[5]=m.d;
			m4[12]=m.tx;
			m4[13]=m.ty;
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
			RenderState2D.worldShaderDefinesValue=0;
			RenderState2D.worldFilters=null;
			RenderState2D.worldAlpha=1;
			RenderState2D.worldClipRect.x=RenderState2D.worldClipRect.y=0;
			RenderState2D.worldClipRect.width=RenderState2D.width;
			RenderState2D.worldClipRect.height=RenderState2D.height;
			RenderState2D.curRenderTarget=null;
		}

		RenderState2D._MAXSIZE=99999999;
		RenderState2D.TEMPMAT4_ARRAY=[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];
		RenderState2D.worldMatrix4=[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];
		RenderState2D.worldAlpha=1.0;
		RenderState2D.worldScissorTest=false;
		RenderState2D.worldFilters=null
		RenderState2D.worldShaderDefinesValue=0;
		RenderState2D.worldClipRect=new Rectangle(0,0,99999999,99999999);
		RenderState2D.curRenderTarget=null
		RenderState2D.width=0;
		RenderState2D.height=0;
		__static(RenderState2D,
		['worldMatrix',function(){return this.worldMatrix=new Matrix();}
		]);
		return RenderState2D;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.utils.ShaderCompile
	var ShaderCompile=(function(){
		var ShaderScriptBlock;
		function ShaderCompile(name,vs,ps,nameMap,includeFiles){
			//this._VS=null;
			//this._PS=null;
			//this._VSTXT=null;
			//this._PSTXT=null;
			//this._nameMap=null;
			this._VSTXT=vs;
			this._PSTXT=ps;
			function split (str){
				var words=str.split(' ');
				var out=[];
				for (var i=0;i < words.length;i++)
				words[i].length > 0 && out.push(words[i]);
				return out;
			}
			function c (script){
				var i=0,n=0,ofs=0,words,condition;
				var top=new ShaderScriptBlock(0,null,null,null);
				var parent=top;
				var lines=script.split('\n');
				for (i=0,n=lines.length;i < n;i++){
					var line=lines[i];
					if (line.indexOf("#ifdef")>=0){
						words=split(line);
						parent=new ShaderScriptBlock(1,words[1],"",parent);
						continue ;
					}
					if (line.indexOf("#else")>=0){
						condition=parent.condition;
						parent=new ShaderScriptBlock(2,null,"",parent.parent);
						parent.condition=condition;
						continue ;
					}
					if (line.indexOf("#endif")>=0){
						parent=parent.parent;
						continue ;
					}
					if (line.indexOf("#include")>=0){
						words=split(line);
						var fname=words[1];
						var chr=fname.charAt(0);
						if (chr==='"' || chr==="'"){
							fname=fname.substr(1,fname.length-2);
							ofs=fname.lastIndexOf(chr);
							if (ofs > 0)fname=fname.substr(0,ofs);
						}
						ofs=words[0].indexOf('?');
						var str=ofs > 0?words[0].substr(ofs+1):words[0];
						new ShaderScriptBlock(1,str,includeFiles[fname],parent);
						continue ;
					}
					if (parent.childs.length > 0 && parent.childs[parent.childs.length-1].type===0){
						parent.childs[parent.childs.length-1].text+="\n"+line;
					}
					else new ShaderScriptBlock(0,null,line,parent);
				}
				return top;
			}
			this._VS=c(vs);
			this._PS=c(ps);
			this._nameMap=nameMap;
		}

		__class(ShaderCompile,'laya.webgl.utils.ShaderCompile');
		var __proto=ShaderCompile.prototype;
		__proto.createShader=function(define,shaderName,createShader){
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
			return (createShader || Shader.create)(defineStr+vs.join('\n'),defineStr+ps.join('\n'),shaderName,this._nameMap);
		}

		ShaderCompile.IFDEF_NO=0;
		ShaderCompile.IFDEF_YES=1;
		ShaderCompile.IFDEF_ELSE=2;
		ShaderCompile.__init$=function(){
			//class ShaderScriptBlock
			ShaderScriptBlock=(function(){
				function ShaderScriptBlock(type,condition,text,parent){
					//this.type=0;
					//this.condition=null;
					//this.text=null;
					//this.parent=null;
					this.childs=new Array;
					this.type=type;
					this.text=text;
					this.parent=parent;
					parent && parent.childs.push(this);
					if (!condition)return;
					var newcondition="";
					var preIsParam=false,isParam=false;
					for (var i=0,n=condition.length;i < n;i++){
						var c=condition.charAt(i);
						isParam="!&|() \t".indexOf(c)< 0;
						if (preIsParam !=isParam){
							isParam && (newcondition+="this.");
							preIsParam=isParam;
						}
						newcondition+=c;
					};
					var fn="(function() {return "+newcondition+";})";
					this.condition=Browser.window.eval(fn);
				}
				__class(ShaderScriptBlock,'');
				var __proto=ShaderScriptBlock.prototype;
				//生成条件判断函数
				__proto.toscript=function(def,out){
					if (this.type===/*laya.webgl.utils.ShaderCompile.IFDEF_NO*/0){
						this.text && out.push(this.text);
					}
					if (this.childs.length < 1 && !this.text)return out;
					if (this.type!==/*laya.webgl.utils.ShaderCompile.IFDEF_NO*/0){
						var ifdef=!!this.condition.call(def);
						this.type===/*laya.webgl.utils.ShaderCompile.IFDEF_ELSE*/2 && (ifdef=!ifdef);
						if (!ifdef)return out;
						this.text && out.push(this.text);
					}
					this.childs.length>0 && this.childs.forEach(function(o){o.toscript(def,out)});
					return out;
				}
				return ShaderScriptBlock;
			})()
		}

		return ShaderCompile;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.WebGL
	var WebGL=(function(){
		function WebGL(){};
		__class(WebGL,'laya.webgl.WebGL');
		WebGL.enable=function(){
			if (!WebGL.isWebGLSupported())return false;
			/*__JS__ */HTMLImage=WebGLImage;
			/*__JS__ */HTMLCanvas=WebGLCanvas;
			/*__JS__ */HTMLSubImage=WebGLSubImage;
			System.changeDefinition("HTMLImage",WebGLImage);
			System.changeDefinition("HTMLCanvas",WebGLCanvas);
			System.changeDefinition("HTMLSubImage",WebGLSubImage);
			Render.WebGL=WebGL;
			System.createRenderSprite=function (type,next){
				return new RenderSprite3D(type,next);
			}
			System.createWebGLContext2D=function (c){
				return new WebGLContext2D(c);
			}
			System.changeWebGLSize=function (width,height){
				laya.webgl.WebGL.onStageResize(width,height);
			}
			System.createGraphics=function (){
				return new GraphicsGL();
			};
			var action=System.createFilterAction;
			System.createFilterAction=action ? action :function (type){
				return new ColorFilterActionGL()
			}
			Render.clear=function (color){
				RenderState2D.worldScissorTest && laya.webgl.WebGL.mainContext.disable(/*laya.webgl.WebGLContext.SCISSOR_TEST*/0x0C11);
				var c=Color.create(color)._color;
				Render.context.ctx.clearBG(c[0],c[1],c[2],c[3]);
				RenderState2D.clear();
			}
			System.addToAtlas=function (texture,force){
				(force===void 0)&& (force=false);
				var bitmap=texture.bitmap;
				var isEnable=AtlasManager.enabled || force;
				var bMerge=false;
				if (System.isConchApp){
					bMerge=(Render.isWebGl && isEnable && ((bitmap instanceof laya.webgl.resource.WebGLImage )|| /*__JS__ */bitmap==ConchTextCanvas)&& bitmap.width < AtlasManager.atlasLimitWidth && bitmap.height < AtlasManager.atlasLimitHeight);
					}else {
					bMerge=(Render.isWebGl && isEnable && ((bitmap instanceof laya.webgl.resource.WebGLImage )|| (bitmap instanceof laya.webgl.resource.WebGLSubImage )|| (bitmap instanceof laya.webgl.resource.WebGLCharImage ))&& bitmap.width < AtlasManager.atlasLimitWidth && bitmap.height < AtlasManager.atlasLimitHeight);
				}
				if (bMerge){
					bitmap.createOwnSource=false;
					(bitmap.resourceManager)&& (bitmap.resourceManager.removeResource(bitmap));
					if (System.isConchApp && /*__JS__ */bitmap==ConchTextCanvas){
						console.log(">>>>conchApp resotre todo todo");
						}else {
						bitmap.on(/*laya.events.Event.RECOVERED*/"recovered",this,function(bitmap){
							(AtlasManager.enable)&& (AtlasManager.instance.addToAtlas(texture));
						});
					}
				}
			}
			System.drawToCanvas=function (sprite,_renderType,canvasWidth,canvasHeight,offsetX,offsetY){
				var renderTarget=new RenderTarget2D(canvasWidth,canvasHeight,false,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,0);
				renderTarget.start();
				renderTarget.clear(1.0,0.0,0.0,1.0);
				sprite.render(Render.context,-offsetX,RenderState2D.height-canvasHeight-offsetY);
				Render.context.flush();
				renderTarget.end();
				var pixels=renderTarget.getData(0,0,renderTarget.width,renderTarget.height);
				renderTarget.dispose();
				return pixels;
			}
			System.createFilterAction=function (type){
				var action;
				switch (type){
					case /*laya.filters.Filter.COLOR*/0x20:
						action=new ColorFilterActionGL();
						break ;
					}
				return action;
			}
			Filter._filter=function (sprite,context,x,y){
				var next=this._next;
				if (next){
					var filters=sprite.filters,len=filters.length;
					if (len==1 && filters[0].type==/*laya.filters.Filter.COLOR*/0x20){
						context.ctx.save();
						context.ctx.setFilters(sprite.filters);
						next._fun.call(next,sprite,context,x,y);
						context.ctx.restore();
						return;
					}
				}
			}
			return true;
		}

		WebGL.isWebGLSupported=function(){
			var canvas=Browser.createElement('canvas');
			var gl;
			var names=["webgl","experimental-webgl","webkit-3d","moz-webgl"];
			for (var i=0;i < names.length;i++){
				try {
					gl=canvas.getContext(names[i]);
				}catch (e){}
				if (gl)return names[i];
			}
			return null;
		}

		WebGL.onStageResize=function(width,height){
			WebGL.mainContext.viewport(0,0,width,height);
			RenderState2D.width=width;
			RenderState2D.height=height;
			Value2D.needRezise=true;
		}

		WebGL.isExperimentalWebgl=function(){
			return WebGL._isExperimentalWebgl;
		}

		WebGL.addRenderFinish=function(){
			if (WebGL._isExperimentalWebgl){
				Render.finish=function (){
					Render.context.ctx.finish();
				}
			}
		}

		WebGL.init=function(canvas,width,height){
			WebGL.mainCanvas=canvas;
			HTMLCanvas._createContext=function (canvas){
				return new WebGLContext2D(canvas);
			};
			var webGLName=WebGL.isWebGLSupported();
			var gl=WebGL.mainContext=canvas.getContext(webGLName,{stencil:true,alpha:false,antialias:true,premultipliedAlpha:false});
			WebGL._isExperimentalWebgl=(webGLName=="experimental-webgl" && (Browser.onWeiXin || Browser.onMQQBrowser));
			Browser.window.SetupWebglContext && Browser.window.SetupWebglContext(gl);
			WebGL.onStageResize(width,height);
			if (WebGL.mainContext==null)
				throw new Error("webGL getContext err!");
			System.__init__();
			AtlasManager.__init__();
			ShaderDefines2D.__init__();
			Submit.__init__();
			WebGLContext2D.__init__();
			Value2D.__init__();
			Shader2D.__init__();
			Buffer.__int__(gl);
			BlendMode._init_(gl);
		}

		WebGL.mainCanvas=null
		WebGL.mainContext=null
		WebGL.antialias=true;
		WebGL._bg_null=[0,0,0,0];
		WebGL._isExperimentalWebgl=false;
		return WebGL;
	})()


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.WebGLContext
	var WebGLContext=(function(){
		function WebGLContext(){};
		__class(WebGLContext,'laya.webgl.WebGLContext');
		WebGLContext.UseProgram=function(program){
			if (WebGLContext._useProgram===program)return false;
			WebGL.mainContext.useProgram(program);
			WebGLContext._useProgram=program;
			return true;
		}

		WebGLContext.setDepthTest=function(gl,value){
			value!==WebGLContext._depthTest && (WebGLContext._depthTest=value,value?gl.enable(/*CLASS CONST:laya.webgl.WebGLContext.DEPTH_TEST*/0x0B71):gl.disable(/*CLASS CONST:laya.webgl.WebGLContext.DEPTH_TEST*/0x0B71));
		}

		WebGLContext.setDepthMask=function(gl,value){
			value!==WebGLContext._depthMask && (WebGLContext._depthMask=value,gl.depthMask(value));
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

		WebGLContext.setFrontFaceCCW=function(gl,value){
			value!==WebGLContext._frontFace && (WebGLContext._frontFace=value,gl.frontFace(value));
		}

		WebGLContext._useProgram=null;
		WebGLContext._depthTest=true;
		WebGLContext._depthMask=1;
		WebGLContext._blend=false;
		WebGLContext._cullFace=false;
		__static(WebGLContext,
		['_sFactor',function(){return this._sFactor=/*CLASS CONST:laya.webgl.WebGLContext.ONE*/1;},'_dFactor',function(){return this._dFactor=/*CLASS CONST:laya.webgl.WebGLContext.ZERO*/0;},'_frontFace',function(){return this._frontFace=/*CLASS CONST:laya.webgl.WebGLContext.CCW*/0x0901;}
		]);
		WebGLContext.__init$=function(){
			;
		}

		return WebGLContext;
	})()


	/**
	*...
	*@author laya
	*/
	//class LayaWebGLMain
	var LayaWebGLMain=(function(){
		function LayaWebGLMain(){
			this.img=null;
			WebGL.enable();
			Laya.init(800,800);
			Laya.stage.bgColor="gray";
			Stat.show();
		}

		__class(LayaWebGLMain,'LayaWebGLMain');
		return LayaWebGLMain;
	})()


	//class laya.webgl.display.GraphicsGL extends laya.display.Graphics
	var GraphicsGL=(function(_super){
		function GraphicsGL(){
			GraphicsGL.__super.call(this);
		}

		__class(GraphicsGL,'laya.webgl.display.GraphicsGL',_super);
		var __proto=GraphicsGL.prototype;
		__proto.setShader=function(shader){
			this._saveToCmd(Render.context._setShader,arguments);
		}

		__proto.setIBVB=function(x,y,ib,vb,numElement,shader){
			this._saveToCmd(Render.context._setIBVB,arguments);
		}

		__proto.drawParticle=function(x,y,ps){
			var pt=System.createParticleTemplate2D(ps);
			pt.x=x;
			pt.y=y;
			this._saveToCmd(Render.context.drawParticle,[pt]);
		}

		return GraphicsGL;
	})(Graphics)


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.canvas.WebGLContext2D extends laya.resource.Context
	var WebGLContext2D=(function(_super){
		var ContextParams;
		function WebGLContext2D(c){
			this._x=0;
			this._y=0;
			this._id=++WebGLContext2D._COUNT;
			//this._other=null;
			this._drawCount=1;
			this._maxNumEle=0;
			this._clear=false;
			this._submits=[];
			this._mergeID=0;
			this._curSubmit=null;
			this._ib=null;
			this._vb=null;
			//this._curMat=null;
			this._nBlendType=0;
			//this._save=null;
			//this._targets=null;
			this._saveMark=null;
			WebGLContext2D.__super.call(this);
			this._path=new Path();
			this._width=99999999;
			this._height=99999999;
			this._clipRect=WebGLContext2D.MAXCLIPRECT;
			this._shader2D=new Shader2D();
			/*__JS__ */this.drawTexture=this._drawTextureM;
			this._canvas=c;
			this._curMat=Matrix.create();
			this._ib=Buffer.QuadrangleIB;
			this._vb=new Buffer(/*laya.webgl.WebGLContext.ARRAY_BUFFER*/0x8892);
			this._vb.getFloat32Array();
			this._other=ContextParams.DEFAULT;
			this._save=[SaveMark.Create(this)];
			this._save.length=10;
			this.clear();
		}

		__class(WebGLContext2D,'laya.webgl.canvas.WebGLContext2D',_super);
		var __proto=WebGLContext2D.prototype;
		__proto.clearBG=function(r,g,b,a){
			var gl=WebGL.mainContext;
			gl.clearColor(r,g,b,a);
			gl.clear(/*laya.webgl.WebGLContext.COLOR_BUFFER_BIT*/0x00004000 | /*laya.webgl.WebGLContext.DEPTH_BUFFER_BIT*/0x00000100);
		}

		__proto._getSubmits=function(){
			return this._submits;
		}

		__proto.destroy=function(){
			this._curMat && this._curMat.destroy();
			this._targets && this._targets.destroy();
			this._vb && this._vb.releaseResource();
			this._ib && (this._ib !=Buffer.QuadrangleIB)&& this._ib.releaseResource();
		}

		__proto.clear=function(){
			this._vb.clear();
			this._targets && (this._targets.repaint=true);
			this._other=ContextParams.DEFAULT;
			this._clear=true;
			this._mergeID=0;
			this._repaint=false;
			this._drawCount=1;
			this._other.lineWidth=this._shader2D.ALPHA=1.0;
			this._nBlendType=0;
			this._clipRect=WebGLContext2D.MAXCLIPRECT;
			this._curSubmit=Submit.RENDERBASE;
			this._shader2D.glTexture=null;
			this._shader2D.fillStyle=this._shader2D.strokeStyle=DrawStyle.DEFAULT;
			for (var i=0,n=this._submits._length;i < n;i++)
			this._submits[i].releaseRender();
			this._submits._length=0;
			this._curMat.identity();
			this._other.clear();
			this._saveMark=this._save[0];
			this._save._length=1;
		}

		__proto.size=function(w,h){
			this._width=w;
			this._height=h;
			this._targets && (this._targets.size(w,h));
		}

		__proto._getTransformMatrix=function(){
			return this._curMat;
		}

		__proto.translate=function(x,y){
			if (x!==0 || y!==0){
				SaveTranslate.save(this);
				if (this._curMat.bTransform){
					SaveTransform.save(this);
					this._curMat.transformPoint(x,y,Point.TEMP);
					x=Point.TEMP.x;
					y=Point.TEMP.y;
				}
				this._x+=x;
				this._y+=y;
			}
		}

		__proto.save=function(){
			this._save[this._save._length++]=SaveMark.Create(this);
		}

		__proto.restore=function(){
			var sz=this._save._length;
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
		}

		__proto.measureText=function(text){
			return Utils.measureText(text,this._other.font.toString());
		}

		__proto._fillText=function(txt,words,x,y,fontStr,color,textAlign){
			var shader=this._shader2D;
			var curShader=this._curSubmit.shaderValue;
			var font=fontStr ? (WebGLContext2D._fontTemp.setFont(fontStr),WebGLContext2D._fontTemp):this._other.font;
			if (AtlasManager.enabled){
				if (shader.ALPHA!==curShader.ALPHA)
					shader.glTexture=null;
				DrawText.drawText(this,txt,words,this._curMat,font,textAlign || this._other.textAlign,color,null,-1,x,y);
				}else {
				var preDef=this._shader2D.defines.getValue();
				var colorAdd=color ? Color.create(color)._color :shader.colorAdd;
				if (shader.ALPHA!==curShader.ALPHA || colorAdd!==shader.colorAdd || curShader.colorAdd!==shader.colorAdd){
					shader.glTexture=null;
					shader.colorAdd=colorAdd;
				}
				shader.defines.add(/*laya.webgl.shader.d2.ShaderDefines2D.COLORADD*/0x40);
				DrawText.drawText(this,txt,words,this._curMat,font,textAlign || this._other.textAlign,null,null,-1,x,y);
				shader.defines.setValue(preDef);
			}
		}

		__proto.fillWords=function(words,x,y,fontStr,color){
			words.length > 0 && this._fillText(null,words,x,y,fontStr,color,null);
		}

		__proto.fillText=function(txt,x,y,fontStr,color,textAlign){
			txt.length > 0 && this._fillText(txt,null,x,y,fontStr,color,textAlign);
		}

		__proto.strokeText=function(txt,x,y,fontStr,color,lineWidth,textAlign){
			if (txt.length===0)
				return;
			var shader=this._shader2D;
			var curShader=this._curSubmit.shaderValue;
			var font=fontStr ? (WebGLContext2D._fontTemp.setFont(fontStr),WebGLContext2D._fontTemp):this._other.font;
			if (AtlasManager.enabled){
				if (shader.ALPHA!==curShader.ALPHA){
					shader.glTexture=null;
				}
				DrawText.drawText(this,txt,null,this._curMat,font,textAlign || this._other.textAlign,null,color,lineWidth || 1,x,y);
				}else {
				var preDef=this._shader2D.defines.getValue();
				var colorAdd=color ? Color.create(color)._color :shader.colorAdd;
				if (shader.ALPHA!==curShader.ALPHA || colorAdd!==shader.colorAdd || curShader.colorAdd!==shader.colorAdd){
					shader.glTexture=null;
					shader.colorAdd=colorAdd;
				}
				shader.defines.add(/*laya.webgl.shader.d2.ShaderDefines2D.COLORADD*/0x40);
				DrawText.drawText(this,txt,null,this._curMat,font,textAlign || this._other.textAlign,null,color,lineWidth || 1,x,y);
				shader.defines.setValue(preDef);
			}
		}

		__proto.fillBorderText=function(txt,x,y,fontStr,fillColor,borderColor,lineWidth,textAlign){
			if (txt.length===0)
				return;
			if (!AtlasManager.enabled){
				this.strokeText(txt,x,y,fontStr,borderColor,lineWidth,textAlign);
				this.fillText(txt,x,y,fontStr,fillColor,textAlign);
				return;
			};
			var shader=this._shader2D;
			var curShader=this._curSubmit.shaderValue;
			if (shader.ALPHA!==curShader.ALPHA)
				shader.glTexture=null;
			var font=fontStr ? (WebGLContext2D._fontTemp.setFont(fontStr),WebGLContext2D._fontTemp):this._other.font;
			DrawText.drawText(this,txt,null,this._curMat,font,textAlign || this._other.textAlign,fillColor,borderColor,lineWidth || 1,x,y);
		}

		__proto.fillRect=function(x,y,width,height,fillStyle){
			var vb=this._vb;
			if (GlUtils.fillRectImgVb(vb,this._clipRect,x,y,width,height,Texture.DEF_UV,this._curMat,this._x,this._y,0,0)){
				var pre=this._shader2D.fillStyle;
				fillStyle && (this._shader2D.fillStyle=new DrawStyle(fillStyle));
				var shader=this._shader2D;
				var curShader=this._curSubmit.shaderValue;
				if (shader.fillStyle!==curShader.fillStyle || shader.ALPHA!==curShader.ALPHA){
					shader.glTexture=null;
					var submit=this._curSubmit=Submit.create(this,0,this._mergeID,this._ib,vb,((vb._length-16 */*laya.webgl.utils.Buffer.FLOAT32*/4)/ 32)*3,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.COLOR2D*/0x02,0));
					submit.shaderValue.color=shader.fillStyle._color._color;
					submit.shaderValue.ALPHA=shader.ALPHA;
					this._submits[this._submits._length++]=submit;
				}
				this._curSubmit._numEle+=6;
				this._shader2D.fillStyle=pre;
			}
		}

		__proto.setShader=function(shader){
			SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_SHADER*/0x80000,this._shader2D,true);
			this._shader2D.shader=shader;
		}

		__proto.setFilters=function(value){
			SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_FILTERS*/0x100000,this._shader2D,true);
			this._shader2D.filters=value;
			this._curSubmit=Submit.RENDERBASE;
			this._mergeID=this._drawCount;
		}

		__proto._findSameSubmit=function(submitID){
			for (var i=this._submits._length-1;i >=0;i--){
				var submit=this._submits [i];
				if (submit._mergID && submit._mergID!==this._mergeID)break ;
				if (submit._submitID===submitID){
					return submit;
				}
			}
			return null;
		}

		__proto._drawTextureM=function(tex,x,y,width,height,tx,ty,m){
			if (!(tex.loaded && tex.bitmap && tex.source)){
				this._targets && (this._targets.repaint=true);
				return;
			};
			var webGLImg=tex.bitmap;
			var shader=this._shader2D;
			var curShader=this._curSubmit.shaderValue;
			this._drawCount++;
			if (shader.glTexture!==webGLImg || shader.ALPHA!==curShader.ALPHA){
				shader.glTexture=webGLImg;
				var vb=this._vb;
				var submit=null;
				var submitID=NaN;
				var vbSize=(vb._length / 32)*3;
				if (this._mergeID){
					submitID=webGLImg._id+shader.ALPHA / 10;
					submit=this._findSameSubmit(submitID);
					vb=null;
				}
				if (!submit){
					submit=Submit.create(this,submitID,this._mergeID,this._ib,vb,vbSize,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0));
					this._submits[this._submits._length++]=submit;
					submit.shaderValue.textureHost=tex;
				}
				this._curSubmit=submit;
			}
			if (GlUtils.fillRectImgVb(this._curSubmit._vb || this._vb,this._clipRect,x+tx+tex.offsetX,y+ty+tex.offsetY,width || tex.width,height || tex.height,tex.uv,m || this._curMat,this._x,this._y,0,0)){
				this._curSubmit._numEle+=6;
				this._maxNumEle=Math.max(this._maxNumEle,this._curSubmit._numEle);
			}
		}

		/**
		*请保证图片已经在内存
		*@param ... args
		*/
		__proto.drawImage=function(__args){
			var args=arguments;
			var img=args[0];
			var tex=(img.__texture || (img.__texture=new Texture(new WebGLImage(img))));
			tex.uv=Texture.DEF_UV;
			switch (args.length){
				case 3:
					if (!img.__width){
						img.__width=img.width;
						img.__height=img.height
					}
					this.drawTexture(tex,args[1],args[2],img.__width,img.__height,0,0);
					break ;
				case 5:
					this.drawTexture(tex,args[1],args[2],args[3],args[4],0,0);
					break ;
				case 9:;
					var x1=args[1] / img.__width;
					var x2=(args[1]+args[3])/ img.__width;
					var y1=args[2] / img.__height;
					var y2=(args[2]+args[4])/ img.__height;
					tex.uv=[x1,y1,x2,y1,x2,y2,x1,y2];
					this.drawTexture(tex,args[5],args[6],args[7],args[8],0,0);
					break ;
				}
		}

		__proto._drawText=function(tex,x,y,width,height,m,tx,ty,dx,dy){
			var webGLImg=tex.bitmap;
			var shader=this._shader2D;
			var curShader=this._curSubmit.shaderValue;
			this._drawCount++;
			if (shader.glTexture!==webGLImg){
				shader.glTexture=webGLImg;
				var vb=this._vb;
				var submit=null;
				var submitID=NaN;
				var vbSize=(vb._length / 32)*3;
				if (this._mergeID){
					submitID=webGLImg._id+shader.ALPHA / 10+(AtlasManager.enabled ? 0 :(shader.colorAdd.__id / 10000));
					submit=this._findSameSubmit(submitID);
					vb=null;
				}
				if (!submit){
					if (AtlasManager.enabled){
						submit=Submit.create(this,submitID,this._mergeID,this._ib,vb,vbSize,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0));
						}else {
						submit=Submit.create(this,submitID,this._mergeID,this._ib,vb,vbSize,TextSV.create());
						submit.shaderValue.colorAdd=shader.colorAdd;
						submit.shaderValue.defines.add(/*laya.webgl.shader.d2.ShaderDefines2D.COLORADD*/0x40);
					}
					submit.shaderValue.textureHost=tex;
					this._submits[this._submits._length++]=submit;
				}
				this._curSubmit=submit;
			}
			tex.active();
			if (GlUtils.fillRectImgVb(this._curSubmit._vb || this._vb,this._clipRect,x+tx,y+ty,width || tex.width,height || tex.height,tex.uv,m || this._curMat,this._x,this._y,dx,dy)){
				this._curSubmit._numEle+=6;
				this._maxNumEle=Math.max(this._maxNumEle,this._curSubmit._numEle);
			}
		}

		__proto.drawTextureWithTransform=function(tex,x,y,width,height,transform,tx,ty){
			var curMat=this._curMat;
			(tx!==0 || ty!==0)&& (this._x=tx *curMat.a+ty *curMat.c,this._y=ty *curMat.d+tx *curMat.b);
			if (transform && curMat.bTransform){
				Matrix.mul(transform,curMat,WebGLContext2D._tmpMatrix);
				transform=WebGLContext2D._tmpMatrix;
				transform._checkTransform();
				}else {
				this._x+=curMat.tx;
				this._y+=curMat.ty;
			}
			this._drawTextureM(tex,x,y,width,height,0,0,transform);
			this._x=this._y=0;
		}

		__proto.fillQuadrangle=function(tex,x,y,point4,m){
			var submit=this._curSubmit;
			var vb=this._vb;
			var shader=this._shader2D;
			var curShader=submit.shaderValue;
			if (tex.bitmap){
				var t_tex=tex.bitmap;
				if (shader.glTexture !=t_tex || shader.ALPHA!==curShader.ALPHA){
					shader.glTexture=t_tex;
					submit=this._curSubmit=Submit.create(this,0,this._mergeID,this._ib,vb,((vb._length)/ 32)*3,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0));
					submit.shaderValue.glTexture=t_tex;
					this._submits[this._submits._length++]=submit;
				}
				GlUtils.fillQuadrangleImgVb(vb,x,y,point4,tex.uv,m || this._curMat,this._x,this._y);
				}else {
				if (!submit.shaderValue.fillStyle || !submit.shaderValue.fillStyle.equal(tex)|| shader.ALPHA!==curShader.ALPHA){
					shader.glTexture=null;
					submit=this._curSubmit=Submit.create(this,0,this._mergeID,this._ib,vb,((vb._length)/ 32)*3,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.COLOR2D*/0x02,0));
					submit.shaderValue.defines.add(/*laya.webgl.shader.d2.ShaderDefines2D.COLOR2D*/0x02);
					submit.shaderValue.fillStyle=new DrawStyle(tex);
					this._submits[this._submits._length++]=submit;
				}
				GlUtils.fillQuadrangleImgVb(vb,x,y,point4,Texture.DEF_UV,m || this._curMat,this._x,this._y);
			}
			submit._numEle+=6;
		}

		__proto.drawTexture2=function(x,y,pivotX,pivotY,transform,alpha,blendMode,args){
			var curMat=this._curMat;
			this._x=x *curMat.a+y *curMat.c;
			this._y=y *curMat.d+x *curMat.b;
			if (transform && curMat.bTransform){
				Matrix.mul(transform,curMat,WebGLContext2D._tmpMatrix);
				transform=WebGLContext2D._tmpMatrix;
			}
			if (alpha===1 && !blendMode)
				this._drawTextureM(args[0],args[1]-pivotX,args[2]-pivotY,args[3],args[4],0,0,transform);
			else {
				var preAlpha=this._shader2D.ALPHA;
				var preblendType=this._nBlendType;
				this._shader2D.ALPHA=alpha;
				blendMode && (this._nBlendType=BlendMode.TOINT(blendMode));
				this._drawTextureM(args[0],args[1]-pivotX,args[2]-pivotY,args[3],args[4],0,0,transform);
				this._shader2D.ALPHA=preAlpha;
				this._nBlendType=preblendType;
			}
			this._x=this._y=0;
		}

		__proto.drawCanvas=function(canvas,x,y,width,height){
			var src=canvas.context;
			if (src._targets){
				this._submits[this._submits._length++]=SubmitCanvas.create(src,0,null);
				this._curSubmit=Submit.RENDERBASE;
				src._targets.drawTo(this,x,y,width,height);
				}else {
				var submit=this._submits[this._submits._length++]=SubmitCanvas.create(src,this._shader2D.ALPHA,this._shader2D.filters);
				var sx=width / canvas.width;
				var sy=height / canvas.height;
				var mat=submit._matrix;
				this._curMat.copy(mat);
				sx !=1 && sy !=1 && mat.scale(sx,sy);
				var tx=mat.tx,ty=mat.ty;
				mat.tx=mat.ty=0;
				mat.transformPoint(x,y,Point.TEMP);
				mat.translate(Point.TEMP.x+tx,Point.TEMP.y+ty);
				this._curSubmit=Submit.RENDERBASE;
			}
			if (Config.showCanvasMark){
				this.save();
				this.lineWidth=4;
				this.strokeStyle=src._targets ? "yellow" :"green";
				this.strokeRect(x-1,y-1,width+2,height+2);
				this.strokeRect(x,y,width,height);
				this.restore();
			}
		}

		__proto.transform=function(a,b,c,d,tx,ty){
			SaveTransform.save(this);
			Matrix.mul(Matrix.TEMP.setTo(a,b,c,d,tx,ty),this._curMat,this._curMat);
			this._curMat._checkTransform();
		}

		__proto.setTransformByMatrix=function(value){
			value.copy(this._curMat);
		}

		__proto.transformByMatrix=function(value){
			SaveTransform.save(this);
			Matrix.mul(value,this._curMat,this._curMat);
			this._curMat._checkTransform();
		}

		__proto.rotate=function(angle){
			SaveTransform.save(this);
			this._curMat.rotate(angle);
		}

		__proto.scale=function(scaleX,scaleY){
			SaveTransform.save(this);
			this._curMat.scale(scaleX,scaleY);
		}

		__proto.clipRect=function(x,y,width,height){
			width *=this._curMat.a;
			height *=this._curMat.d;
			var p=Point.TEMP;
			this._curMat.transformPoint(x,y,p);
			var submit=this._curSubmit=SubmitScissor.create(this);
			this._submits[this._submits._length++]=submit;
			submit.submitIndex=this._submits._length;
			submit.submitLength=9999999;
			SaveClipRect.save(this,submit);
			var clip=this._clipRect;
			var x1=clip.x,y1=clip.y;
			var r=p.x+width,b=p.y+height;
			x1 < p.x && (clip.x=p.x);
			y1 < p.y && (clip.y=p.y);
			clip.width=Math.min(r,x1+clip.width)-clip.x;
			clip.height=Math.min(b,y1+clip.height)-clip.y;
			this._shader2D.glTexture=null;
			submit.clipRect.copyFrom(clip);
			this._curSubmit=Submit.RENDERBASE;
			this._mergeID=0;
		}

		__proto.setIBVB=function(x,y,ib,vb,numElement,mat,shader,shaderValues,startIndex,offset){
			(startIndex===void 0)&& (startIndex=0);
			(offset===void 0)&& (offset=0);
			(ib===null)&& (GlUtils.expandIBQuadrangle(this._ib,(vb.length / (/*laya.webgl.utils.Buffer.FLOAT32*/4 *16)+8)),ib=this._ib);
			if (!shaderValues || !shader)
				throw Error("setIBVB must input:shader shaderValues");
			var submit=SubmitOtherIBVB.create(this,vb,ib,numElement,shader,shaderValues,startIndex,offset);
			mat || (mat=Matrix.EMPTY);
			mat.translate(x,y);
			Matrix.mul(mat,this._curMat,submit._mat);
			mat.translate(-x,-y);
			this._submits[this._submits._length++]=submit;
			this._curSubmit=Submit.RENDERBASE;
		}

		__proto.addRenderObject=function(o){
			this._submits[this._submits._length++]=o;
		}

		__proto.fillTrangles=function(tex,x,y,points,m){
			var submit=this._curSubmit;
			var vb=this._vb;
			var shader=this._shader2D;
			var curShader=submit.shaderValue;
			var length=points.length >> 4;
			var t_tex=tex.bitmap;
			if (shader.glTexture !=t_tex || shader.ALPHA!==curShader.ALPHA){
				submit=this._curSubmit=Submit.create(this,0,this._mergeID,this._ib,vb,((vb._length)/ 32)*3,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0));
				submit.shaderValue.textureHost=tex;
				this._submits[this._submits._length++]=submit;
			}
			GlUtils.fillTranglesVB(vb,x,y,points,m || this._curMat,this._x,this._y);
			submit._numEle+=length *6;
		}

		__proto.arc=function(x,y,r,sAngle,eAngle,counterclockwise){
			(counterclockwise===void 0)&& (counterclockwise=true);
		}

		// debugger;
		__proto.fill=function(){}
		// debugger;
		__proto.closePath=function(){}
		__proto.beginPath=function(){
			this._other=this._other.make();
			this._other.path || (this._other.path=new Path());
			this._other.path.clear();
		}

		__proto.rect=function(x,y,width,height){
			this._other=this._other.make();
			this._other.path || (this._other.path=new Path());
			this._other.path.rect(x,y,width,height);
		}

		__proto.strokeRect=function(x,y,width,height,lineWidth){
			(lineWidth===void 0)&& (lineWidth=1);
			this.line(x,y,x+width,y,lineWidth / 2,this._curMat);
			this.line(x+width,y,x+width,y+height,lineWidth / 2,this._curMat);
			this.line(x,y,x,y+height,lineWidth / 2,this._curMat);
			this.line(x,y+height,x+width,y+height,lineWidth / 2,this._curMat);
		}

		__proto.clip=function(){}
		// debugger;
		__proto.stroke=function(){
			if (this._other!==ContextParams.DEFAULT){
				if (this._other.path._rect){
					var r=this._other.path._rect;
					this.strokeRect(r.x,r.y,r.width,r.height,this._other.lineWidth);
				}
				this._other.path.clear();
			}
		}

		__proto.moveTo=function(x,y){
			this._other.path._x=x;
			this._other.path._y=y;
		}

		__proto.lineTo=function(x,y){
			this.line(this._other.path._x,this._other.path._y,x,y,this._other.lineWidth / 2,this._curMat);
		}

		__proto.line=function(fromX,fromY,toX,toY,lineWidth,mat){
			var submit=this._curSubmit;
			var vb=this._vb;
			if (GlUtils.fillLineVb(vb,this._clipRect,fromX,fromY,toX,toY,lineWidth,mat)){
				var shader=this._shader2D;
				var curShader=submit.shaderValue;
				if (shader.strokeStyle!==curShader.strokeStyle || shader.ALPHA!==curShader.ALPHA){
					shader.glTexture=null;
					submit=this._curSubmit=Submit.create(this,0,this._mergeID,this._ib,vb,((vb._length-16 */*laya.webgl.utils.Buffer.FLOAT32*/4)/ 32)*3,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.COLOR2D*/0x02,0));
					submit.shaderValue.strokeStyle=shader.strokeStyle;
					submit.shaderValue.mainID=/*laya.webgl.shader.d2.ShaderDefines2D.COLOR2D*/0x02;
					submit.shaderValue.ALPHA=shader.ALPHA;
					this._submits[this._submits._length++]=submit;
				}
				submit._numEle+=6;
			}
		}

		__proto.submitElement=function(start,end){
			var renderList=this._submits;
			end < 0 && (end=renderList._length);
			while (start < end){
				start+=renderList[start].renderSubmit();
			}
		}

		__proto.finish=function(){
			WebGL.mainContext.finish();
		}

		__proto.flush=function(){
			this._ib.upload_bind();
			var maxNum=Math.max(this._vb.length / (/*laya.webgl.utils.Buffer.FLOAT32*/4 *16),this._maxNumEle / 6)+8;
			if (maxNum > (this._ib.bufferLength / (6 */*laya.webgl.utils.Buffer.SHORT*/2))){
				GlUtils.expandIBQuadrangle(this._ib,maxNum);
			}
			this._vb.upload_bind();
			this.submitElement(0,this._submits._length);
			this._path.reset();
			Value2D.reset();
			this._curSubmit=Submit.RENDERBASE;
			return this._submits._length;
		}

		__proto.fan=function(x,y,r,sAngle,eAngle,fillColor,lineColor){
			this._path.fan(x,y,r,sAngle,eAngle,fillColor,this._other.lineWidth ? this._other.lineWidth :1,lineColor);
			this._path.update();
			var submit=Submit.createShape(this,this._path.ib,this._path.vb,this._path.count,this._path.offset,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.PRIMITIVE*/0x04,0));
			this._submits[this._submits._length++]=submit;
		}

		__proto.drawPoly=function(x,y,r,edges,boderColor,lineWidth,color){
			this._path.polygon(x,y,r,edges,color,lineWidth ? lineWidth :1,boderColor);
			this._path.update();
			var submit=Submit.createShape(this,this._path.ib,this._path.vb,this._path.count,this._path.offset,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.PRIMITIVE*/0x04,0));
			submit.shaderValue.ALPHA=this._shader2D.ALPHA;
			submit.shaderValue.u_mmat2=RenderState2D.mat2MatArray(this._curMat,RenderState2D.TEMPMAT4_ARRAY);
			this._submits[this._submits._length++]=submit;
		}

		__proto.drawPath=function(x,y,points,color,lineWidth){
			this._path.drawPath(x,y,points,color,lineWidth);
			this._path.update();
			var submit=Submit.createShape(this,this._path.ib,this._path.vb,this._path.count,this._path.offset,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.PRIMITIVE*/0x04,0));
			this._submits[this._submits._length++]=submit;
		}

		__proto.drawParticle=function(x,y,pt){
			pt.x=x;
			pt.y=y;
			this._submits[this._submits._length++]=pt;
		}

		__proto.drawLines=function(x,y,points,color,lineWidth){
			var tmp=Point.TEMP;
			this._curMat.transformPoint(x,y,tmp);
			if (this._curMat.bTransform){
				points=points.concat();
				this._curMat.transformPointArrayScale(points,points);
			}
			this._path.drawPath(tmp.x,tmp.y,points,color,lineWidth);
			this._path.update();
			var submit=Submit.createShape(this,this._path.ib,this._path.vb,this._path.count,this._path.offset,Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.PRIMITIVE*/0x04,0));
			this._submits[this._submits._length++]=submit;
		}

		__getset(0,__proto,'asBitmap',null,function(value){
			if (value){
				this._targets || (this._targets=new RenderTargetMAX());
				this._targets.repaint=true;
				if (!this._width || !this._height)throw Error("asBitmap no size!");
				this._targets.size(this._width,this._height);
			}else this._targets=null;
		});

		__getset(0,__proto,'fillStyle',function(){
			return this._shader2D.fillStyle;
			},function(value){
			this._shader2D.fillStyle.equal(value)|| (SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_FILESTYLE*/0x2,this._shader2D,false),this._shader2D.fillStyle=new DrawStyle(value));
		});

		/*,_shader2D.ALPHA=1*/
		__getset(0,__proto,'globalCompositeOperation',function(){
			return BlendMode.NAMES[this._nBlendType];
			},function(value){
			var n=BlendMode.TOINT[value];
			n==null || (this._nBlendType===n)|| (SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_GLOBALCOMPOSITEOPERATION*/0x10000,this,true),this._curSubmit=Submit.RENDERBASE,this._nBlendType=n);
		});

		__getset(0,__proto,'textAlign',function(){
			return this._other.textAlign;
			},function(value){
			(this._other.textAlign===value)|| (this._other=this._other.make(),SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_TEXTALIGN*/0x8000,this._other,false),this._other.textAlign=value);
		});

		__getset(0,__proto,'globalAlpha',function(){
			return this._shader2D.ALPHA;
			},function(value){
			value=Math.floor(value *1000)/ 1000;
			if (value !=this._shader2D.ALPHA){
				SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_ALPHA*/0x1,this._shader2D,true);
				this._shader2D.ALPHA=value;
			}
		});

		__getset(0,__proto,'textBaseline',function(){
			return this._other.textBaseline;
			},function(value){
			(this._other.textBaseline===value)|| (this._other=this._other.make(),SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_TEXTBASELINE*/0x4000,this._other,false),this._other.textBaseline=value);
		});

		__getset(0,__proto,'enableMerge',function(){
			return this._mergeID > 0;
			},function(value){
			SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_ENABLEMERGE*/0x2000,this,true);
			this._mergeID=this._drawCount;
		});

		__getset(0,__proto,'strokeStyle',function(){
			return this._shader2D.strokeStyle;
			},function(value){
			this._shader2D.strokeStyle.equal(value)|| (SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_STROKESTYLE*/0x200,this._shader2D,false),this._shader2D.strokeStyle=new DrawStyle(value));
		});

		__getset(0,__proto,'lineWidth',function(){
			return this._other.lineWidth;
			},function(value){
			(this._other.lineWidth===value)|| (this._other=this._other.make(),SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_LINEWIDTH*/0x100,this._other,false),this._other.lineWidth=value);
		});

		__getset(0,__proto,'font',null,function(str){
			if (str==this._other.font.toString())
				return;
			this._other=this._other.make();
			SaveBase.save(this,/*laya.webgl.canvas.save.SaveBase.TYPE_FONT*/0x8,this._other,false);
			this._other.font===FontInContext.EMPTY ? (this._other.font=new FontInContext(str)):(this._other.font.setFont(str));
		});

		WebGLContext2D.__init__=function(){
			ContextParams.DEFAULT=new ContextParams();
		}

		WebGLContext2D._SUBMITVBSIZE=32000;
		WebGLContext2D._MAXSIZE=99999999;
		WebGLContext2D._RECTVBSIZE=16;
		WebGLContext2D.MAXCLIPRECT=new Rectangle(0,0,99999999,99999999);
		WebGLContext2D._COUNT=0;
		WebGLContext2D._tmpMatrix=new Matrix();
		__static(WebGLContext2D,
		['_fontTemp',function(){return this._fontTemp=new FontInContext();},'_drawStyleTemp',function(){return this._drawStyleTemp=new DrawStyle(null);}
		]);
		WebGLContext2D.__init$=function(){
			//class ContextParams
			ContextParams=(function(){
				function ContextParams(){
					this.lineWidth=1;
					this.path=null;
					this.textAlign=null;
					this.textBaseline=null;
					this.font=FontInContext.EMPTY;
				}
				__class(ContextParams,'');
				var __proto=ContextParams.prototype;
				__proto.clear=function(){
					this.lineWidth=1;
					this.path && this.path.clear();
					this.textAlign=this.textBaseline=null;
					this.font=FontInContext.EMPTY;
				}
				__proto.make=function(){
					return this===ContextParams.DEFAULT ? new ContextParams():this;
				}
				ContextParams.DEFAULT=null
				return ContextParams;
			})()
		}

		return WebGLContext2D;
	})(Context)


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.utils.RenderSprite3D extends laya.renders.RenderSprite
	var RenderSprite3D=(function(_super){
		function RenderSprite3D(type,next){
			RenderSprite3D.__super.call(this,type,next);
		}

		__class(RenderSprite3D,'laya.webgl.utils.RenderSprite3D',_super);
		var __proto=RenderSprite3D.prototype;
		__proto.onCreate=function(type){
			switch (type){
				case 0x20:
					this._fun=this._blend;
					return;
				case 0x08:
					this._fun=this._transform;
					return;
				}
		}

		// }
		__proto._blend=function(sprite,context,x,y){
			var style=sprite._style;
			var submit,next
			context.ctx.save();
			if (sprite.mask){
				submit=SubmitStencil.create(1);
				context.addRenderObject(submit);
				sprite.mask.render(context,x,y);
				submit=SubmitStencil.create(2);
				context.addRenderObject(submit);
				next=this._next;
				next._fun.call(next,sprite,context,x,y);
				submit=SubmitStencil.create(3);
				context.ctx._curSubmit=Submit.RENDERBASE;
				context.addRenderObject(submit);
			}
			else{
				context.ctx.globalCompositeOperation=style.blendMode;
				next=this._next;
				next._fun.call(next,sprite,context,x,y);
			}
			context.ctx.restore();
		}

		// }
		__proto._transform=function(sprite,context,x,y){
			'use strict';
			var transform=sprite.transform,_next=this._next;
			if (transform && _next !=RenderSprite.NORENDER){
				var ctx=context.ctx;
				var style=sprite._style;
				transform.tx=x;
				transform.ty=y;
				var m2=ctx._getTransformMatrix();
				var m1=m2.clone();
				Matrix.mul(transform,m2,m2);
				m2._checkTransform();
				_next._fun.call(_next,sprite,context,0,0);
				m1.copy(m2);
				m1.destroy();
				transform.tx=transform.ty=0;
			}else
			_next._fun.call(_next,sprite,context,x,y);
		}

		return RenderSprite3D;
	})(RenderSprite)


	//class laya.filters.webgl.ColorFilterActionGL extends laya.filters.webgl.FilterActionGL
	var ColorFilterActionGL=(function(_super){
		function ColorFilterActionGL(){
			this.data=null;
			ColorFilterActionGL.__super.call(this);
		}

		__class(ColorFilterActionGL,'laya.filters.webgl.ColorFilterActionGL',_super);
		var __proto=ColorFilterActionGL.prototype;
		Laya.imps(__proto,{"laya.filters.IFilterActionGL":true})
		__proto.setValue=function(shader){
			shader.u_colorMatrix=this.data._elements;
		}

		return ColorFilterActionGL;
	})(FilterActionGL)


	//class laya.webgl.atlas.Atlaser extends laya.webgl.atlas.AtlasGrid
	var Atlaser=(function(_super){
		function Atlaser(gridNumX,gridNumY,width,height,atlasID){
			this._atlasCanvas=null;
			this._inAtlasTextureKey=null;
			this._inAtlasTextureValue=null;
			this._webGLImages=null;
			Atlaser.__super.call(this,gridNumX,gridNumY,atlasID);
			this._inAtlasTextureKey=[];
			this._inAtlasTextureValue=[];
			this._webGLImages=[];
			this._atlasCanvas=new AtlasWebGLCanvas();
			this._atlasCanvas.width=width;
			this._atlasCanvas.height=height;
			this._atlasCanvas.activeResource();
		}

		__class(Atlaser,'laya.webgl.atlas.Atlaser',_super);
		var __proto=Atlaser.prototype;
		/**
		*
		*@param inAtlasRes
		*@return 是否已经存在队列中
		*/
		__proto.addToAtlasTexture=function(bitmap,offsetX,offsetY){
			((bitmap instanceof laya.webgl.resource.WebGLImage ))&& (this._webGLImages.push(bitmap));
			bitmap.offsetX=offsetX;
			bitmap.offsetY=offsetY;
			this._atlasCanvas.texSubImage2D(bitmap,offsetX,offsetY,bitmap.image || bitmap.canvas);
			((bitmap instanceof laya.webgl.resource.WebGLImage ))&& (bitmap._image=null);
			((bitmap instanceof laya.webgl.resource.WebGLCharImage ))&&(bitmap.canvas=null);
			((bitmap instanceof laya.webgl.resource.WebGLSubImage ))&&(bitmap.canvas=null);
		}

		//_canvas为复用暂不清空
		__proto.addToAtlas=function(inAtlasRes){
			this._inAtlasTextureKey.push(inAtlasRes);
			this._inAtlasTextureValue.push(inAtlasRes.bitmap);
			inAtlasRes.bitmap=this._atlasCanvas;
		}

		__proto.clear=function(){
			for (var i=0,n=this._inAtlasTextureKey.length;i < n;i++){
				this._inAtlasTextureKey[i].bitmap=this._inAtlasTextureValue[i];
				this._inAtlasTextureKey[i].bitmap.releaseResource();
			}
			this._inAtlasTextureKey.length=0;
			this._inAtlasTextureValue.length=0;
			this._webGLImages.length=0;
		}

		__proto.destroy=function(){
			this.clear();
			this._atlasCanvas.releaseResource();
		}

		__getset(0,__proto,'texture',function(){
			return this._atlasCanvas;
		});

		__getset(0,__proto,'webGLImages',function(){
			return this._webGLImages;
		});

		return Atlaser;
	})(AtlasGrid)


	/**
	*@author wk
	*/
	//class laya.webgl.shader.d2.filters.ColorFilter extends laya.webgl.shader.Shader
	var ColorFilter1=(function(_super){
		function ColorFilter(){
			var vs="attribute vec4 position;\nattribute vec2 texcoord;\nuniform  mat4 mmat;\nuniform vec2 size;\nvarying vec2 v_texcoord;\nvoid main() {\n  gl_Position =mmat*vec4((position.x/size.x-0.5)*2.0,(0.5-position.y/size.y)*2.0,position.z,1.0);\n  v_texcoord = texcoord;\n}"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/filters/colorfilter.vert*/;
			var ps="precision mediump float;\nvarying vec2 v_texcoord;\nuniform sampler2D texture;\nuniform float alpha;\nuniform float u_colorMatrix[20];\n\nvoid main(){\n 	vec4 rgba=gl_FragColor= texture2D(texture, v_texcoord)*vec4(1,1,1,alpha);\n   gl_FragColor.r =rgba.r*u_colorMatrix[0]+rgba.g*u_colorMatrix[1]+rgba.b*u_colorMatrix[2]+rgba.a*u_colorMatrix[3]+u_colorMatrix[4];\n   gl_FragColor.g =rgba.r*u_colorMatrix[5]+rgba.g*u_colorMatrix[6]+rgba.b*u_colorMatrix[7]+rgba.a*u_colorMatrix[8]+u_colorMatrix[9];\n   gl_FragColor.b =rgba.r*u_colorMatrix[10]+rgba.g*u_colorMatrix[11]+rgba.b*u_colorMatrix[12]+rgba.a*u_colorMatrix[13]+u_colorMatrix[14];\n   gl_FragColor.a =rgba.r*u_colorMatrix[15]+rgba.g*u_colorMatrix[16]+rgba.b*u_colorMatrix[17]+rgba.a*u_colorMatrix[18]+u_colorMatrix[19];	   \n}\n"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/filters/colorfilter.frag*/;
			ColorFilter.__super.call(this,vs,ps,"colorFilter");
		}

		__class(ColorFilter,'laya.webgl.shader.d2.filters.ColorFilter',_super,'ColorFilter1');
		return ColorFilter;
	})(Shader)


	/**
	*@author wk
	*/
	//class laya.webgl.shader.d2.filters.GlowFilterShader extends laya.webgl.shader.Shader
	var GlowFilterShader=(function(_super){
		function GlowFilterShader(){
			var vs="attribute vec4 position;\nattribute vec2 texcoord;\nuniform vec2 size;\nuniform  mat4 mmat;\nuniform  mat4 pmat;\nvarying vec2  v_texcoord;\nvoid main(){\n gl_Position =mmat*vec4((position.x/size.x-0.5)*2.0,(0.5-position.y/size.y)*2.0,position.z,1.0);\n  v_texcoord = texcoord;\n}"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/filters/glowfilter.vert*/;
			var ps="precision mediump float;\nconst int c_FilterTime = 9;\nconst float c_Gene = (1.0/(1.0 + 2.0*(0.93 + 0.8 + 0.7 + 0.6 + 0.5 + 0.4 + 0.3 + 0.2 + 0.1)));\nuniform sampler2D texture;\nconst bool u_FiterMode=true;\nconst float u_GlowGene=1.5;\nconst vec4 u_GlowColor=vec4(1.0,0.0,0.0,0.5);\nconst float u_FilterOffset=2.0;\nconst float u_TexSpaceU=1.0/10.0;\nconst float u_TexSpaceV=1.0/10.0;\nvarying vec2 v_texcoord;\nvoid main()\n{\n	float aryAttenuation[c_FilterTime];\n	aryAttenuation[0] = 0.93;\n	aryAttenuation[1] = 0.8;\n	aryAttenuation[2] = 0.7;\n	aryAttenuation[3] = 0.6;\n	aryAttenuation[4] = 0.5;\n	aryAttenuation[5] = 0.4;\n	aryAttenuation[6] = 0.3;\n	aryAttenuation[7] = 0.2;\n	aryAttenuation[8] = 0.1;\n	vec4 vec4Color = texture2D(texture, v_texcoord)*c_Gene;\n	vec2 vec2FilterDir;\n	if(u_FiterMode)\n	  vec2FilterDir = vec2(u_FilterOffset*u_TexSpaceU/9.0, 0.0);\n	else\n		vec2FilterDir =  vec2(0.0, u_FilterOffset*u_TexSpaceV/9.0);\n	vec2 vec2Step = vec2FilterDir;\n	for(int i = 0;i< c_FilterTime; ++i){\n		vec4Color += texture2D(texture, v_texcoord + vec2Step)*aryAttenuation[i]*c_Gene;\n		vec4Color += texture2D(texture, v_texcoord - vec2Step)*aryAttenuation[i]*c_Gene;\n		vec2Step += vec2FilterDir;\n	}\n	if(u_FiterMode)\n		gl_FragColor = vec4Color.a*u_GlowColor*u_GlowGene;\n	else\n		gl_FragColor = vec4Color.a*u_GlowColor;\n}"/*__INCLUDESTR__e:/trank/libs/layaair/webgl/src/laya/webgl/shader/d2/filters/glowfilter.frag*/;
			GlowFilterShader.__super.call(this,vs,ps,"glowFilter");
		}

		__class(GlowFilterShader,'laya.webgl.shader.d2.filters.GlowFilterShader',_super);
		return GlowFilterShader;
	})(Shader)


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.shader.d2.Shader2X extends laya.webgl.shader.Shader
	var Shader2X=(function(_super){
		function Shader2X(vs,ps,saveName,nameMap){
			this._params2dQuick1=null;
			this._params2dQuick2=null;
			this._shaderValueWidth=0;
			this._shaderValueHeight=0;
			this._shaderValueAlpha=NaN;
			Shader2X.__super.call(this,vs,ps,saveName,nameMap);
		}

		__class(Shader2X,'laya.webgl.shader.d2.Shader2X',_super);
		var __proto=Shader2X.prototype;
		__proto.upload2dQuick1=function(shaderValue){
			this.upload(shaderValue,this._params2dQuick1 || this._make2dQuick1());
		}

		__proto._make2dQuick1=function(){
			try{
				if (!this._params2dQuick1){
					this._program || this.compile();
					this._params2dQuick1=[];
					var params=this._params,one;
					for (var i=0,n=params.length;i < n;i++){
						one=params[i];
						if ((!Value2D.needRezise&&one.name==="size")|| one.name==="al2pha" || one.name==="mmat" || one.name==="position" || one.name==="texcoord")continue ;
						this._params2dQuick1.push(one);
					}
				}
				return this._params2dQuick1;
			}
			catch (e){
			}
			return null;
		}

		__proto.upload2dQuick2=function(shaderValue){
			this.upload(shaderValue,this._params2dQuick2 || this._make2dQuick2());
		}

		__proto._make2dQuick2=function(){
			try{
				if (!this._params2dQuick2){
					this._program || this.compile();
					this._params2dQuick2=[];
					var params=this._params,one;
					for (var i=0,n=params.length;i < n;i++){
						one=params[i];
						if ((one.name==="size")|| one.name==="al2pha")continue ;
						this._params2dQuick2.push(one);
					}
				}
				return this._params2dQuick2;
			}
			catch (e){
			}
			return null;
		}

		Shader2X.create=function(vs,ps,saveName,nameMap){
			return new Shader2X(vs,ps,saveName,nameMap);
		}

		return Shader2X;
	})(Shader)


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.shader.d2.ShaderDefines2D extends laya.webgl.shader.ShaderDefines
	var ShaderDefines2D=(function(_super){
		function ShaderDefines2D(){
			ShaderDefines2D.__super.call(this,ShaderDefines2D._name2int,ShaderDefines2D._int2name,ShaderDefines2D._int2nameMap);
		}

		__class(ShaderDefines2D,'laya.webgl.shader.d2.ShaderDefines2D',_super);
		ShaderDefines2D.__init__=function(){
			ShaderDefines2D.reg("TEXTURE2D",0x01);
			ShaderDefines2D.reg("COLOR2D",0x02);
			ShaderDefines2D.reg("PRIMITIVE",0x04);
			ShaderDefines2D.reg("GLOW_FILTER",0x08);
			ShaderDefines2D.reg("BLUR_FILTER",0x10);
			ShaderDefines2D.reg("COLOR_FILTER",0x20);
			ShaderDefines2D.reg("COLOR_ADD",0x40);
		}

		ShaderDefines2D.reg=function(name,value){
			ShaderDefines._reg(name,value,ShaderDefines2D._name2int,ShaderDefines2D._int2name);
		}

		ShaderDefines2D.toText=function(value,_int2name,_int2nameMap){
			return ShaderDefines._toText(value,_int2name,_int2nameMap);
		}

		ShaderDefines2D.toInt=function(names){
			return ShaderDefines._toInt(names,ShaderDefines2D._name2int);
		}

		ShaderDefines2D.TEXTURE2D=0x01;
		ShaderDefines2D.COLOR2D=0x02;
		ShaderDefines2D.PRIMITIVE=0x04;
		ShaderDefines2D.FILTERGLOW=0x08;
		ShaderDefines2D.FILTERBLUR=0x10;
		ShaderDefines2D.FILTERCOLOR=0x20;
		ShaderDefines2D.COLORADD=0x40;
		ShaderDefines2D._name2int={};
		ShaderDefines2D._int2name=[];
		ShaderDefines2D._int2nameMap=[];
		return ShaderDefines2D;
	})(ShaderDefines)


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.shader.d2.value.Value2D extends laya.webgl.shader.ShaderValue
	var Value2D=(function(_super){
		function Value2D(mainID,subID){
			this.size=[0,0];
			this.alpha=1.0;
			this.mmat=null;
			this.ALPHA=1.0;
			this.shader=null;
			this.mainID=0;
			this.subID=0;
			this.filters=null;
			this.textureHost=null;
			this.texture=null;
			this.fillStyle=null;
			this.color=null;
			this.strokeStyle=null;
			this.colorAdd=null;
			this.glTexture=null;
			this.u_mmat2=null;
			this._inClassCache=null;
			this._cacheID=0;
			Value2D.__super.call(this);
			this.defines=new ShaderDefines2D();
			this.position=Value2D._POSITION;
			this.mainID=mainID;
			this.subID=subID;
			this.textureHost=null;
			this.texture=null;
			this.fillStyle=null;
			this.color=null;
			this.strokeStyle=null;
			this.colorAdd=null;
			this.glTexture=null;
			this.u_mmat2=null;
			this._cacheID=mainID|subID;
			this._inClassCache=Value2D._cache[this._cacheID];
			if (mainID>0 && !this._inClassCache){
				this._inClassCache=Value2D._cache[this._cacheID]=[];
				this._inClassCache._length=0;
			}
			this.clear();
		}

		__class(Value2D,'laya.webgl.shader.d2.value.Value2D',_super);
		var __proto=Value2D.prototype;
		__proto.setValue=function(value){}
		//throw new Error("todo in subclass");
		__proto.refresh=function(){
			var size=this.size;
			size[0]=RenderState2D.width;
			size[1]=RenderState2D.height;
			this.alpha=this.ALPHA *RenderState2D.worldAlpha;
			this.mmat=RenderState2D.worldMatrix4;
			return this;
		}

		__proto._ShaderWithCompile=function(){
			try{
				return Shader.withCompile(0,this.mainID,this.defines.toString(),this.mainID | this.defines._value | RenderState2D.worldShaderDefinesValue,Shader2X.create);
			}
			catch (e){
			}
			return null;
		}

		__proto._withWorldShaderDefinesValue=function(){
			try{
				var sd=Shader.sharders [this.mainID | this.defines._value | RenderState2D.worldShaderDefinesValue] || this._ShaderWithCompile();
				var worldFilters=RenderState2D.worldFilters;
				var n=worldFilters.length,f;
				for (var i=0;i < n;i++){
					((f=worldFilters[i]))&& f.action.setValue(this);
				}
			}
			catch (e){
			}
		}

		__proto.upload=function(){
			var sd;
			var renderstate2d=RenderState2D;
			this.alpha=this.ALPHA *renderstate2d.worldAlpha;
			renderstate2d.worldShaderDefinesValue?this._withWorldShaderDefinesValue()
			:(sd=Shader.sharders [this.mainID | this.defines._value] || this._ShaderWithCompile());
			var params;
			if (Shader.activeShader!==sd){
				this.mmat=renderstate2d.worldMatrix4;
				if (renderstate2d.width!==sd._shaderValueWidth || renderstate2d.height!==sd._shaderValueHeight){
					this.size[0]=sd._shaderValueWidth=renderstate2d.width;
					this.size[1]=sd._shaderValueHeight=renderstate2d.height;
				}
				else params=sd._params2dQuick2 || sd._make2dQuick2();
				sd.upload(this,params);
			}
			else{
				var needResize=laya.webgl.shader.d2.value.Value2D.needRezise;
				if (needResize){
					this.size[0]=sd._shaderValueWidth=renderstate2d.width;
					this.size[1]=sd._shaderValueHeight=renderstate2d.height;
					var preParams=sd._params2dQuick1;
					sd._params2dQuick1=null;
					params=sd._make2dQuick1();
					sd.upload(this,params);
					sd._params2dQuick1=preParams;
				}
				else{
					params=(sd._params2dQuick1)|| sd._make2dQuick1();
					sd.upload(this,params);
				}
			}
		}

		__proto.setFilters=function(value){
			if (!value)return;
			this.filters=value;
			var n=value.length,f;
			for (var i=0;i < n;i++){
				f=value[i]
				if (f){
					this.defines.add(f.type);
					f.action.setValue(this);
				}
			}
		}

		__proto.clear=function(){
			this.defines.setValue(this.subID);
		}

		__proto.release=function(){
			this._inClassCache[this._inClassCache._length++]=this;
			this.clear();
		}

		Value2D._initone=function(type,classT){
			Value2D._typeClass[type]=classT;
			Value2D._cache[type]=[];
			Value2D._cache[type]._length=0;
		}

		Value2D.__init__=function(){
			Value2D._POSITION=[2,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,4 *CONST3D2D.BYTES_PE,0];
			Value2D._TEXCOORD=[2,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,4 *CONST3D2D.BYTES_PE,2 *CONST3D2D.BYTES_PE];
			Value2D._initone(/*laya.webgl.shader.d2.ShaderDefines2D.COLOR2D*/0x02,Color2dSV);
			Value2D._initone(/*laya.webgl.shader.d2.ShaderDefines2D.PRIMITIVE*/0x04,PrimitiveSV);
			Value2D._initone(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,TextureSV);
			Value2D._initone(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01 | /*laya.webgl.shader.d2.ShaderDefines2D.COLORADD*/0x40,TextSV);
			Value2D._initone(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01 | /*laya.webgl.shader.d2.ShaderDefines2D.FILTERGLOW*/0x08,TextureSV);
		}

		Value2D.create=function(mainType,subType){
			var types=Value2D._cache[mainType|subType];
			if (types._length)
				return types[--types._length];
			else
			return new Value2D._typeClass[mainType|subType](subType);
		}

		Value2D.reset=function(){
			(laya.webgl.shader.d2.value.Value2D.needRezise)&& (laya.webgl.shader.d2.value.Value2D.needRezise=false);
		}

		Value2D._POSITION=null
		Value2D._TEXCOORD=null
		Value2D.needRezise=false;
		Value2D._cache=[];
		Value2D._typeClass=[];
		return Value2D;
	})(ShaderValue)


	//class laya.webgl.shapes.Circle extends laya.webgl.shapes.BasePoly
	var Circle=(function(_super){
		function Circle(x,y,r,color,borderWidth,borderColor,fill){
			Circle.__super.call(this,x,y,r,r,80,color,borderWidth,borderColor);
			this.fill=fill;
		}

		__class(Circle,'laya.webgl.shapes.Circle',_super);
		return Circle;
	})(BasePoly)


	//class laya.webgl.shapes.Ellipse extends laya.webgl.shapes.BasePoly
	var Ellipse=(function(_super){
		function Ellipse(x,y,width,height,color,borderWidth,borderColor){
			Ellipse.__super.call(this,x,y,width,height,40,color,borderWidth,borderColor);
		}

		__class(Ellipse,'laya.webgl.shapes.Ellipse',_super);
		return Ellipse;
	})(BasePoly)


	//class laya.webgl.shapes.Fan extends laya.webgl.shapes.BasePoly
	var Fan=(function(_super){
		function Fan(x,y,r,r0,r1,color,borderWidth,borderColor,round){
			(round===void 0)&& (round=0);
			Fan.__super.call(this,x,y,r,r,30,color,borderWidth,borderColor,round);
			this.r0=r0;
			this.r1=r1;
		}

		__class(Fan,'laya.webgl.shapes.Fan',_super);
		var __proto=Fan.prototype;
		__proto.getData=function(ib,vb,start){
			var indices=[];
			var verts=[];
			this.sector(verts,indices,start);
			if(this.fill){
				(this.borderWidth>0)&&(this.borderColor!=-1)&&this.createFanLine(verts,indices,this.borderWidth,start+verts.length/5,null,null);
				ib.append(new Uint16Array(indices));
				vb.append(new Float32Array(verts));
			}
			else{
				var outV=[];
				var outI=[];
				(this.borderColor!=-1)&&(this.borderWidth>0)&&this.createFanLine(verts,indices,this.borderWidth,start,outV,outI);
				ib.append(new Uint16Array(outI));
				vb.append(new Float32Array(outV));
			}
		}

		return Fan;
	})(BasePoly)


	//class laya.webgl.shapes.Line extends laya.webgl.shapes.BasePoly
	var Line=(function(_super){
		function Line(x,y,points,color,borderWidth){
			this.points
			Line.__super.call(this,x,y,0,0,0,color,borderWidth,color,0);
			this.points=points;
		}

		__class(Line,'laya.webgl.shapes.Line',_super);
		var __proto=Line.prototype;
		__proto.getData=function(ib,vb,start){
			var indices=[];
			var verts=[];
			(this.borderWidth > 0)&& this.createLine2(this.points,indices,this.borderWidth,start,verts,this.points.length / 2);
			ib.append(new Uint16Array(indices));
			vb.append(new Float32Array(verts));
		}

		return Line;
	})(BasePoly)


	//class laya.webgl.shapes.Polygon extends laya.webgl.shapes.BasePoly
	var Polygon=(function(_super){
		function Polygon(x,y,r,edges,color,borderWidth,borderColor){
			Polygon.__super.call(this,x,y,r,r,edges,color,borderWidth,borderColor);
		}

		__class(Polygon,'laya.webgl.shapes.Polygon',_super);
		return Polygon;
	})(BasePoly)


	//class laya.webgl.shapes.Rect extends laya.webgl.shapes.BasePoly
	var Rect=(function(_super){
		function Rect(x,y,width,height,color,borderWidth,borderColor){
			Rect.__super.call(this,x+width / 2,y+height / 2,width / 2,height / 2,4,color,borderWidth,borderColor);
		}

		__class(Rect,'laya.webgl.shapes.Rect',_super);
		return Rect;
	})(BasePoly)


	//class laya.webgl.shapes.RoundPolygon extends laya.webgl.shapes.BasePoly
	var RoundPolygon=(function(_super){
		function RoundPolygon(x,y,width,height,edges,color,borderWidth,borderColor,round){
			RoundPolygon.__super.call(this,x,y,width,height,edges,color,borderWidth,borderColor,round);
		}

		__class(RoundPolygon,'laya.webgl.shapes.RoundPolygon',_super);
		return RoundPolygon;
	})(BasePoly)


	/**
	*...
	*@author wk
	*/
	//class laya.webgl.submit.SubmitCanvas extends laya.webgl.submit.Submit
	var SubmitCanvas=(function(_super){
		function SubmitCanvas(){
			//this._ctx_src=null;
			//this._alpha=NaN;
			this._filters=[];
			//this._shaderDefines=null;
			SubmitCanvas.__super.call(this);
			this._matrix=new Matrix();
			this._matrix4=CONST3D2D.defaultMatrix4.concat();
		}

		__class(SubmitCanvas,'laya.webgl.submit.SubmitCanvas',_super);
		var __proto=SubmitCanvas.prototype;
		__proto.renderSubmit=function(){
			if (this._ctx_src._targets){
				this._ctx_src._targets.flush(this._ctx_src);
				return 1;
			};
			var preAlpha=RenderState2D.worldAlpha;
			var preMatrix4=RenderState2D.worldMatrix4;
			var preMatrix=RenderState2D.worldMatrix;
			var preFilters=RenderState2D.worldFilters;
			var preShaderDefinesValue=RenderState2D.worldShaderDefinesValue;
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
			RenderState2D.worldAlpha=RenderState2D.worldAlpha *this._alpha;
			if (this._filters.length){
				RenderState2D.worldFilters=this._filters;
				RenderState2D.worldShaderDefinesValue=this._shaderDefines._value;
			}
			this._ctx_src.flush();
			RenderState2D.worldAlpha=preAlpha;
			RenderState2D.worldMatrix4=preMatrix4;
			RenderState2D.worldMatrix.destroy();
			RenderState2D.worldMatrix=preMatrix;
			RenderState2D.worldFilters=preFilters;
			RenderState2D.worldShaderDefinesValue=preShaderDefinesValue;
			return 1;
		}

		__proto.releaseRender=function(){
			var cache=SubmitCanvas._cache;
			cache[cache._length++]=this;
		}

		__proto.getRenderType=function(){
			return /*laya.webgl.submit.Submit.TYPE_CANVAS*/3;
		}

		SubmitCanvas.create=function(ctx_src,alpha,filters){
			var o=(!SubmitCanvas._cache._length)?(new SubmitCanvas()):SubmitCanvas._cache[--SubmitCanvas._cache._length];
			o._ctx_src=ctx_src;
			o._alpha=alpha;
			if (filters && filters.length){
				o._shaderDefines || (o._shaderDefines=new ShaderDefines(SubmitCanvas._name2int,SubmitCanvas._int2name,SubmitCanvas._int2nameMap));
				var n=filters.length;
				o._filters.length=n;
				var f;
				for (var i=0;i < n;i++){
					o._filters[i]=f=filters[i];
					o._shaderDefines.add(f.type);
				}
			}
			else o._filters.length=0;
			return o;
		}

		SubmitCanvas._name2int={};
		SubmitCanvas._int2name=[];
		SubmitCanvas._int2nameMap=[];
		SubmitCanvas._cache=(SubmitCanvas._cache=[],SubmitCanvas._cache._length=0,SubmitCanvas._cache);
		return SubmitCanvas;
	})(Submit)


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.resource.RenderTarget2D extends laya.resource.Texture
	var RenderTarget2D=(function(_super){
		function RenderTarget2D(width,height,mipMap,surfaceFormat,surfaceType,depthFormat){
			this._type=0;
			this._svWidth=NaN;
			this._svHeight=NaN;
			this._preRenderTarget=null;
			this._alreadyResolved=false;
			this._looked=false;
			this._surfaceFormat=0;
			this._surfaceType=0;
			this._depthFormat=0;
			this._mipMap=false;
			this._destroy=false;
			this._type=1;
			this._w=width;
			this._h=height;
			this._surfaceFormat=surfaceFormat;
			this._surfaceType=surfaceType;
			this._depthFormat=depthFormat;
			this._mipMap=mipMap;
			this._createWebGLRenderTarget();
			this.bitmap.lock=true;
			RenderTarget2D.__super.call(this,this.bitmap,Texture.INV_UV);
		}

		__class(RenderTarget2D,'laya.webgl.resource.RenderTarget2D',_super);
		var __proto=RenderTarget2D.prototype;
		Laya.imps(__proto,{"laya.resource.IDispose":true})
		//TODO:临时......................................................
		__proto.getType=function(){
			return this._type;
		}

		//*/
		__proto.getTexture=function(){
			return this;
		}

		__proto.size=function(w,h){
			if (this._w==w && this._h==h)
				return;
			this._w=w;
			this._h=h;
			this.release();
		}

		__proto.release=function(){
			this.destroy();
		}

		__proto.recycle=function(){
			RenderTarget2D.POOL.push(this);
		}

		__proto.start=function(){
			var gl=WebGL.mainContext;
			this._destroy && this._createWebGLRenderTarget();
			this._preRenderTarget=RenderState2D.curRenderTarget;
			RenderState2D.curRenderTarget=this;
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,this.bitmap.frameBuffer);
			this._alreadyResolved=false;
			if (this._type==1){
				gl.viewport(0,0,this._w,this._h);
				this._svWidth=RenderState2D.width;
				this._svHeight=RenderState2D.height;
				RenderState2D.width=this._w;
				RenderState2D.height=this._h;
				Shader.activeShader=null;
			}
			return this;
		}

		__proto.clear=function(r,g,b,a){
			(r===void 0)&& (r=0.0);
			(g===void 0)&& (g=0.0);
			(b===void 0)&& (b=0.0);
			(a===void 0)&& (a=1.0);
			var gl=WebGL.mainContext;
			gl.clearColor(r,g,b,a);
			var clearFlag=/*laya.webgl.WebGLContext.COLOR_BUFFER_BIT*/0x00004000;
			(this._depthFormat)&& (clearFlag |=/*laya.webgl.WebGLContext.DEPTH_BUFFER_BIT*/0x00000100);
			gl.clear(clearFlag);
		}

		__proto.end=function(){
			var gl=WebGL.mainContext;
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,this._preRenderTarget?this._preRenderTarget.bitmap.frameBuffer:null);
			this._alreadyResolved=true;
			RenderState2D.curRenderTarget=this._preRenderTarget;
			if (this._type==1){
				gl.viewport(0,0,this._svWidth,this._svHeight);
				RenderState2D.width=this._svWidth;
				RenderState2D.height=this._svHeight;
				Shader.activeShader=null;
			}
			else gl.viewport(0,0,Laya.stage.width,Laya.stage.height);
		}

		__proto.getData=function(x,y,width,height){
			var gl=WebGL.mainContext;
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,(this.bitmap).frameBuffer);
			var canRead=(gl.checkFramebufferStatus(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40)===/*laya.webgl.WebGLContext.FRAMEBUFFER_COMPLETE*/0x8CD5);
			if (!canRead){
				gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,null);
				return null;
			};
			var pixels=new Uint8Array(this._w *this._h *4);
			gl.readPixels(x,y,width,height,this._surfaceFormat,this._surfaceType,pixels);
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,null);
			return pixels;
		}

		/**彻底清理资源,注意会强制解锁清理*/
		__proto.destroy=function(){
			if (!this._destroy){
				this._loaded=false;
				this.bitmap.dispose();
				this.bitmap=null;
				this._destroy=true;
				_super.prototype.destroy.call(this);
			}
		}

		//待测试
		__proto.dispose=function(){}
		__proto._createWebGLRenderTarget=function(){
			this.bitmap=new WebGLRenderTarget(this.width,this.height,this.mipMap,this.surfaceFormat,this.surfaceType,this.depthFormat);
			this.bitmap.activeResource();
			this._alreadyResolved=true;
			this._destroy=false;
			this._loaded=true;
		}

		__getset(0,__proto,'surfaceFormat',function(){
			return this._surfaceFormat;
		});

		__getset(0,__proto,'surfaceType',function(){
			return this._surfaceType;
		});

		__getset(0,__proto,'depthFormat',function(){
			return this._depthFormat;
		});

		__getset(0,__proto,'mipMap',function(){
			return this._mipMap;
		});

		/**返回RenderTarget的Texture*/
		__getset(0,__proto,'source',function(){
			if (this._alreadyResolved)
				return _super.prototype._$get_source.call(this);
			throw new Error("RenderTarget  还未准备好！");
		});

		RenderTarget2D.create=function(w,h,type){
			(type===void 0)&& (type=1);
			var t=RenderTarget2D.POOL.pop();
			t || (t=new RenderTarget2D(w,h,false,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,0));
			t._w=w;t._h=h;
			return t;
		}

		RenderTarget2D.TYPE2D=1;
		RenderTarget2D.TYPE3D=2;
		RenderTarget2D.POOL=[];
		return RenderTarget2D;
	})(Texture)


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.utils.Buffer extends laya.resource.Resource
	var Buffer=(function(_super){
		function Buffer(glTarget,usage,frome,bufferUsage){
			this._length=0;
			this._upload=true;
			//this._id=0;
			//this._glTarget=null;
			//this._buffer=null;
			//this._glBuffer=null;
			//this._bufferUsage=0;
			//this._floatArray32=null;
			this._uploadSize=0;
			//this._usage=null;
			this._maxsize=0;
			//this._uint16=null;
			(bufferUsage===void 0)&& (bufferUsage=0x88E8);
			Buffer.__super.call(this);
			this.lock=true;
			Buffer._gl=WebGL.mainContext;
			this._$2__id=++Buffer._COUNT;
			this._usage=usage;
			glTarget==/*laya.webgl.WebGLContext.ELEMENT_ARRAY_BUFFER*/0x8893 && (glTarget=/*laya.webgl.WebGLContext.ELEMENT_ARRAY_BUFFER*/0x8893,this._usage="INDEX");
			glTarget==/*laya.webgl.WebGLContext.ARRAY_BUFFER*/0x8892 && (glTarget=/*laya.webgl.WebGLContext.ARRAY_BUFFER*/0x8892);
			this._glTarget=glTarget;
			this._bufferUsage=bufferUsage;
			this._buffer=new ArrayBuffer(8);
			frome && this.append(frome);
		}

		__class(Buffer,'laya.webgl.utils.Buffer',_super);
		var __proto=Buffer.prototype;
		__proto.getFloat32Array=function(){
			return this._floatArray32 || (this._floatArray32=new Float32Array(this._buffer));
		}

		__proto.getUint16Array=function(){
			return new Uint16Array(this._buffer);
		}

		__proto.clear=function(){
			this._length=0;
			this._upload=true;
		}

		__proto.append=function(data){
			this._upload=true;
			var szu8=0,n;
			if ((data instanceof Uint8Array)){
				szu8=data.length;
				this._resizeBuffer(this._length+szu8,true);
				n=new Uint8Array(this._buffer,this._length);
				}else if ((data instanceof Float32Array)){
				szu8=data.length *4;
				this._resizeBuffer(this._length+szu8,true);
				n=new Float32Array(this._buffer,this._length);
				}else if ((data instanceof Uint16Array)){
				szu8=data.length *2;
				this._resizeBuffer(this._length+szu8,true);
				n=new Uint16Array(this._buffer,this._length);
			}
			n.set(data,0);
			this._length+=szu8;
			this._floatArray32 && (this._floatArray32=new Float32Array(this._buffer));
		}

		__proto.setdata=function(data){
			this._buffer=data.buffer;
			this._upload=true;
			this._floatArray32 || (this._floatArray32=new Float32Array(this._buffer));
			this._length=this._buffer.byteLength;
		}

		__proto.getBuffer=function(){
			return this._buffer;
		}

		__proto.seLength=function(value){
			if (this._length===value)
				return;
			value <=this._buffer.byteLength || (this._resizeBuffer(value *2+256,true));
			this._length=value;
		}

		__proto._resizeBuffer=function(nsz,copy){
			if (nsz < this._buffer.byteLength)
				return this;
			this.memorySize=this._buffer.byteLength;
			if (copy && this._buffer && this._buffer.byteLength > 0){
				var newbuffer=new ArrayBuffer(nsz);
				var n=new Uint8Array(newbuffer);
				n.set(new Uint8Array(this._buffer),0);
				this._buffer=newbuffer;
			}else
			this._buffer=new ArrayBuffer(nsz);
			this._floatArray32 && (this._floatArray32=new Float32Array(this._buffer));
			this._upload=true;
			return this;
		}

		__proto.setNeedUpload=function(){
			this._upload=true;
		}

		__proto.getNeedUpload=function(){
			return this._upload;
		}

		__proto.bind=function(){
			this.activeResource();
			(Buffer._bindActive[this._glTarget]===this._glBuffer)|| (Buffer._gl.bindBuffer(this._glTarget,Buffer._bindActive[this._glTarget]=this._glBuffer),Shader.activeShader=null);
		}

		__proto.recreateResource=function(){
			this._glBuffer || (this._glBuffer=Buffer._gl.createBuffer());
			this._upload=true;
			this.memorySize=0;
			_super.prototype.recreateResource.call(this);
		}

		__proto.detoryResource=function(){
			if (this._glBuffer){
				var glBuffer=this._glBuffer;
				Laya.timer.frameOnce(1,null,function(){
					WebGL.mainContext.deleteBuffer(glBuffer);
				});
				this._glBuffer=null;
				this._upload=true;
				this._uploadSize=0;
				this.memorySize=0;
			}
		}

		//待调整
		__proto.upload=function(){
			if (!this._upload)
				return false;
			this._upload=false;
			this.bind();
			this._maxsize=Math.max(this._maxsize,this._length);
			if (Stat.loopCount % 30==0){
				if (this._buffer.byteLength > (this._maxsize+64)){
					this.memorySize=this._buffer.byteLength;
					this._buffer=this._buffer.slice(0,this._maxsize+64);
					this._floatArray32 && (this._floatArray32=new Float32Array(this._buffer));
				}
				this._maxsize=this._length;
			}
			if (this._uploadSize < this._buffer.byteLength){
				this._uploadSize=this._buffer.byteLength;
				Buffer._gl.bufferData(this._glTarget,this._uploadSize,this._bufferUsage);
				this.memorySize=this._uploadSize;
			}
			Buffer._gl.bufferSubData(this._glTarget,0,this._buffer);
			Stat.bufferLen+=this._length;
			return true;
		}

		__proto.subUpload=function(offset,dataStart,dataLength){
			(offset===void 0)&& (offset=0);
			(dataStart===void 0)&& (dataStart=0);
			(dataLength===void 0)&& (dataLength=0);
			if (!this._upload)
				return false;
			this._upload=false;
			this.bind();
			this._maxsize=Math.max(this._maxsize,this._length);
			if (Stat.loopCount % 30==0){
				if (this._buffer.byteLength > (this._maxsize+64)){
					this.memorySize=this._buffer.byteLength;
					this._buffer=this._buffer.slice(0,this._maxsize+64);
					this._floatArray32 && (this._floatArray32=new Float32Array(this._buffer));
				}
				this._maxsize=this._length;
			}
			if (this._uploadSize < this._buffer.byteLength){
				this._uploadSize=this._buffer.byteLength;
				Buffer._gl.bufferData(this._glTarget,this._uploadSize,this._bufferUsage);
				this.memorySize=this._uploadSize;
			}
			if (dataStart || dataLength){
				var subBuffer=this._buffer.slice(dataStart,dataLength);
				Buffer._gl.bufferSubData(this._glTarget,offset,subBuffer);
				}else {
				Buffer._gl.bufferSubData(this._glTarget,offset,this._buffer);
			}
			return true;
		}

		__proto.upload_bind=function(){
			(this._upload && this.upload())|| this.bind();
		}

		/**
		*释放CPU中的内存（upload()后确定不再使用时可使用）
		*/
		__proto.disposeCPUData=function(){
			this._buffer=null;
			this._floatArray32=null;
		}

		__proto.dispose=function(){
			this._resourceManager=null;
			_super.prototype.dispose.call(this);
		}

		__getset(0,__proto,'uintArray16',function(){
			this._uint16=new Uint16Array(this._buffer);
			return this._uint16;
		});

		/*调试用*/
		__getset(0,__proto,'bufferLength',function(){
			return this._buffer.byteLength;
		});

		__getset(0,__proto,'length',function(){
			return this._length;
			},function(value){
			if (this._length===value)
				return;
			value <=this._buffer.byteLength || (this._resizeBuffer(value *2+256,true));
			this._length=value;
		});

		__getset(0,__proto,'usage',function(){
			return this._usage;
		});

		Buffer.__int__=function(gl){
			Buffer._gl=gl;
			Buffer.QuadrangleIB=new Buffer(/*laya.webgl.WebGLContext.ELEMENT_ARRAY_BUFFER*/0x8893,"INDEX",null,/*laya.webgl.WebGLContext.STATIC_DRAW*/0x88E4);
			GlUtils.fillIBQuadrangle(Buffer.QuadrangleIB,16);
		}

		Buffer.INDEX="INDEX";
		Buffer.POSITION0="POSITION";
		Buffer.NORMAL0="NORMAL";
		Buffer.COLOR0="COLOR";
		Buffer.UV0="UV";
		Buffer.NEXTUV0="NEXTUV";
		Buffer.UV1="UV1";
		Buffer.NEXTUV1="NEXTUV1";
		Buffer.BLENDWEIGHT0="BLENDWEIGHT";
		Buffer.BLENDINDICES0="BLENDINDICES";
		Buffer.MATRIX0="MATRIX0";
		Buffer.MATRIX1="MATRIX1";
		Buffer.MATRIX2="MATRIX2";
		Buffer.DIFFUSETEXTURE="DIFFUSETEXTURE";
		Buffer.NORMALTEXTURE="NORMALTEXTURE";
		Buffer.SPECULARTEXTURE="SPECULARTEXTURE";
		Buffer.EMISSIVETEXTURE="EMISSIVETEXTURE";
		Buffer.AMBIENTTEXTURE="AMBIENTTEXTURE";
		Buffer.REFLECTTEXTURE="REFLECTTEXTURE";
		Buffer.MATRIXARRAY0="MATRIXARRAY0";
		Buffer.FLOAT0="FLOAT0";
		Buffer.UVAGEX="UVAGEX";
		Buffer.CAMERAPOS="CAMERAPOS";
		Buffer.LUMINANCE="LUMINANCE";
		Buffer.ALPHATESTVALUE="ALPHATESTVALUE";
		Buffer.FOGCOLOR="FOGCOLOR";
		Buffer.FOGSTART="FOGSTART";
		Buffer.FOGRANGE="FOGRANGE";
		Buffer.MATERIALAMBIENT="MATERIALAMBIENT";
		Buffer.MATERIALDIFFUSE="MATERIALDIFFUSE";
		Buffer.MATERIALSPECULAR="MATERIALSPECULAR";
		Buffer.LIGHTDIRECTION="LIGHTDIRECTION";
		Buffer.LIGHTDIRDIFFUSE="LIGHTDIRDIFFUSE";
		Buffer.LIGHTDIRAMBIENT="LIGHTDIRAMBIENT";
		Buffer.LIGHTDIRSPECULAR="LIGHTDIRSPECULAR";
		Buffer.POINTLIGHTPOS="POINTLIGHTPOS";
		Buffer.POINTLIGHTRANGE="POINTLIGHTRANGE";
		Buffer.POINTLIGHTATTENUATION="POINTLIGHTATTENUATION";
		Buffer.POINTLIGHTDIFFUSE="POINTLIGHTDIFFUSE";
		Buffer.POINTLIGHTAMBIENT="POINTLIGHTAMBIENT";
		Buffer.POINTLIGHTSPECULAR="POINTLIGHTSPECULAR";
		Buffer.SPOTLIGHTPOS="SPOTLIGHTPOS";
		Buffer.SPOTLIGHTDIRECTION="SPOTLIGHTDIRECTION";
		Buffer.SPOTLIGHTSPOT="SPOTLIGHTSPOT";
		Buffer.SPOTLIGHTRANGE="SPOTLIGHTRANGE";
		Buffer.SPOTLIGHTATTENUATION="SPOTLIGHTATTENUATION";
		Buffer.SPOTLIGHTDIFFUSE="SPOTLIGHTDIFFUSE";
		Buffer.SPOTLIGHTAMBIENT="SPOTLIGHTAMBIENT";
		Buffer.SPOTLIGHTSPECULAR="SPOTLIGHTSPECULAR";
		Buffer.CORNERTEXTURECOORDINATE="CORNERTEXTURECOORDINATE";
		Buffer.VELOCITY="VELOCITY";
		Buffer.SIZEROTATION="SIZEROTATION";
		Buffer.RADIUSRADIAN="RADIUSRADIAN";
		Buffer.AGEADDSCALE="AGEADDSCALE";
		Buffer.TIME="TIME";
		Buffer.VIEWPORTSCALE="VIEWPORTSCALE";
		Buffer.CURRENTTIME="CURRENTTIME";
		Buffer.DURATION="DURATION";
		Buffer.GRAVITY="GRAVITY";
		Buffer.ENDVELOCITY="ENDVELOCITY";
		Buffer.FLOAT32=4;
		Buffer.SHORT=2;
		Buffer.QuadrangleIB=null
		Buffer._gl=null
		Buffer._bindActive=[];
		Buffer._COUNT=1;
		return Buffer;
	})(Resource)


	//class laya.webgl.shader.d2.value.Color2dSV extends laya.webgl.shader.d2.value.Value2D
	var Color2dSV=(function(_super){
		function Color2dSV(){
			Color2dSV.__super.call(this,/*laya.webgl.shader.d2.ShaderDefines2D.COLOR2D*/0x02,0);
			this.color=[];
		}

		__class(Color2dSV,'laya.webgl.shader.d2.value.Color2dSV',_super);
		var __proto=Color2dSV.prototype;
		__proto.setValue=function(value){
			value.fillStyle&&(this.color=value.fillStyle._color._color);
			value.strokeStyle&&(this.color=value.strokeStyle._color._color);
		}

		return Color2dSV;
	})(Value2D)


	//class laya.webgl.shader.d2.value.TextureSV extends laya.webgl.shader.d2.value.Value2D
	var TextureSV=(function(_super){
		function TextureSV(subID){
			this.u_colorMatrix=null;
			this.texcoord=Value2D._TEXCOORD;
			(subID===void 0)&& (subID=0);
			TextureSV.__super.call(this,/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,subID);
		}

		__class(TextureSV,'laya.webgl.shader.d2.value.TextureSV',_super);
		var __proto=TextureSV.prototype;
		__proto.setValue=function(vo){
			this.ALPHA=vo.ALPHA;
			vo.filters && this.setFilters(vo.filters);
		}

		__proto.clear=function(){
			this.texture=null;
			this.shader=null;
			this.defines.setValue(0);
		}

		return TextureSV;
	})(Value2D)


	//class laya.webgl.shader.d2.value.PrimitiveSV extends laya.webgl.shader.d2.value.Value2D
	var PrimitiveSV=(function(_super){
		function PrimitiveSV(){
			this.a_color=null;
			PrimitiveSV.__super.call(this,/*laya.webgl.shader.d2.ShaderDefines2D.PRIMITIVE*/0x04,0);
			this.position=[2,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,5 *CONST3D2D.BYTES_PE,0];
			this.a_color=[3,/*laya.webgl.WebGLContext.FLOAT*/0x1406,false,5 *CONST3D2D.BYTES_PE,2*4];
		}

		__class(PrimitiveSV,'laya.webgl.shader.d2.value.PrimitiveSV',_super);
		return PrimitiveSV;
	})(Value2D)


	//class laya.webgl.atlas.AtlasWebGLCanvas extends laya.resource.Bitmap
	var AtlasWebGLCanvas=(function(_super){
		function AtlasWebGLCanvas(){
			AtlasWebGLCanvas.__super.call(this);
			this._resourceManager.removeResource(this);
		}

		__class(AtlasWebGLCanvas,'laya.webgl.atlas.AtlasWebGLCanvas',_super);
		var __proto=AtlasWebGLCanvas.prototype;
		/***重新创建资源*/
		__proto.recreateResource=function(){
			var gl=WebGL.mainContext;
			var glTex=this._source=gl.createTexture();
			gl.bindTexture(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,glTex);
			gl.texImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,this._w,this._h,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,null);
			gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,/*laya.webgl.WebGLContext.LINEAR*/0x2601);
			gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,/*laya.webgl.WebGLContext.LINEAR*/0x2601);
			gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
			gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
			gl.bindTexture(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,null);
			this.memorySize=this._w *this._h *4;
			laya.resource.Resource.prototype.recreateResource.call(this);
		}

		/***销毁资源*/
		__proto.detoryResource=function(){
			if (this._source){
				WebGL.mainContext.deleteTexture(this._source);
				this._source=null;
				this.memorySize=0;
			}
		}

		/**采样image到WebGLTexture的一部分*/
		__proto.texSubImage2D=function(source,xoffset,yoffset,bitmap){
			var gl=WebGL.mainContext;
			gl.bindTexture(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,this._source);
			(xoffset-1 >=0)&& (gl.texSubImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,xoffset-1,yoffset,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,bitmap));
			(xoffset+1 <=source.width)&& (gl.texSubImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,xoffset+1,yoffset,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,bitmap));
			(yoffset-1 >=0)&& (gl.texSubImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,xoffset,yoffset-1,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,bitmap));
			(yoffset+1 <=source.height)&& (gl.texSubImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,xoffset,yoffset+1,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,bitmap));
			gl.texSubImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,xoffset,yoffset,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,bitmap);
			gl.bindTexture(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,null);
		}

		/**采样image到WebGLTexture的一部分*/
		__proto.texSubImage2DPixel=function(source,xoffset,yoffset,width,height,pixel){
			var gl=WebGL.mainContext;
			gl.bindTexture(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,this._source);
			var pixels=new Uint8Array(pixel.data);
			gl.texSubImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,xoffset,yoffset,width,height,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,pixels);
			gl.bindTexture(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,null);
		}

		/***
		*设置图片宽度
		*@param value 图片宽度
		*/
		__getset(0,__proto,'width',_super.prototype._$get_width,function(value){
			this._w=value;
		});

		/***
		*设置图片高度
		*@param value 图片高度
		*/
		__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
			this._h=value;
		});

		return AtlasWebGLCanvas;
	})(Bitmap)


	/**
	*...
	*@author
	*/
	//class laya.webgl.resource.WebGLCanvas extends laya.resource.Bitmap
	var WebGLCanvas=(function(_super){
		function WebGLCanvas(type){
			//this._ctx=null;
			this._is2D=false;
			//this._canvas=null;
			//this.createOwnSource=false;
			var _$this=this;
			WebGLCanvas.__super.call(this);
			this._canvas=this;
			if (type==="2D" || (type==="AUTO" && !Render.isWebGl)){
				this._is2D=true;
				this._canvas=this._source=Browser.createElement("canvas");
				var o=this;
				o.getContext=function (contextID,other){
					if (_$this._ctx)return _$this._ctx;
					var ctx=_$this._ctx=_$this._canvas.getContext(contextID,other);
					if (ctx){
						ctx._canvas=o;
						ctx.size=function (){
						};
					}
					contextID==="2d" && Context._init(o,ctx);
					return ctx;
				}
			}else this._canvas={};
			this.createOwnSource=true;
			this.lock=true;
		}

		__class(WebGLCanvas,'laya.webgl.resource.WebGLCanvas',_super);
		var __proto=WebGLCanvas.prototype;
		__proto.clear=function(){
			this._ctx && this._ctx.clear();
		}

		__proto.destroy=function(){
			this._ctx && this._ctx.destroy();
			this._ctx=null;
		}

		__proto._setContext=function(context){
			this._ctx=context;
		}

		__proto.getContext=function(contextID,other){
			return this._ctx ? this._ctx :(this._ctx=WebGLCanvas._createContext(this));
		}

		__proto.copyTo=function(dec){
			_super.prototype.copyTo.call(this,dec);
			(dec)._ctx=this._ctx;
		}

		__proto.size=function(w,h){
			if (this._w !=w || this._h !=h){
				this._w=w;
				this._h=h;
				this._ctx && this._ctx.size(w,h);
				this._canvas && (this._canvas.height=h,this._canvas.width=w);
			}
		}

		__proto.recreateResource=function(){
			this.createWebGlTexture();
			laya.resource.Resource.prototype.recreateResource.call(this);
		}

		__proto.detoryResource=function(){
			if (this._source){
				WebGL.mainContext.deleteTexture(this._source);
				this._source=null;
				this.memorySize=0;
			}
		}

		__proto.createWebGlTexture=function(){
			var gl=WebGL.mainContext;
			if (!this._canvas){
				debugger;
				throw "create GLTextur err:no data:"+this._canvas;
			};
			var glTex=this._source=gl.createTexture();
			gl.bindTexture(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,glTex);
			gl.texImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,this._w,this._h,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,null);
			gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,/*laya.webgl.WebGLContext.LINEAR*/0x2601);
			gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,/*laya.webgl.WebGLContext.LINEAR*/0x2601);
			gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
			gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
			this.memorySize=this._w *this._h *4;
			gl.bindTexture(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,null);
			this._canvas=null;
		}

		__proto.texSubImage2D=function(webglCanvas,xoffset,yoffset){
			var gl=WebGL.mainContext;
			gl.bindTexture(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,this._source);
			gl.texSubImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,xoffset,yoffset,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,webglCanvas._source);
		}

		/**
		*返回HTML Image,as3无internal货friend，通常禁止开发者修改image内的任何属性
		*@param HTML Image
		*/
		__getset(0,__proto,'canvas',function(){
			return this._canvas;
		});

		__getset(0,__proto,'context',function(){
			return this._ctx;
		});

		__getset(0,__proto,'asBitmap',null,function(value){
			this._ctx && (this._ctx.asBitmap=value);
		});

		WebGLCanvas._createContext=null
		return WebGLCanvas;
	})(Bitmap)


	/**
	*...
	*@author
	*/
	//class laya.webgl.resource.WebGLCharImage extends laya.resource.Bitmap
	var WebGLCharImage=(function(_super){
		function WebGLCharImage(canvas,char){
			//this._ctx=null;
			//this.canvas=null;
			//this.char=null;
			//this.createOwnSource=false;
			this.borderSize=4;
			WebGLCharImage.__super.call(this);
			this.canvas=canvas;
			this.char=char;
			var bIsConchApp=System.isConchApp;
			if (bIsConchApp){
				/*__JS__ */ctx=ConchTextCanvas;
				}else {
				this._ctx=canvas.getContext('2d',undefined);
			};
			var xs=char.xs,ys=char.ys;
			var t=null;
			if (bIsConchApp){
				this._ctx.font=char.font;
				t=this._ctx.measureText(char.char);
				char.width=t.width1 *xs;
				char.height=t.height *ys;
				}else {
				t=Utils.measureText(char.char,char.font);
				char.width=t.width *xs;
				char.height=t.height *ys;
			}
			this._w=char.width+this.borderSize *2;
			this._h=char.height+this.borderSize *2;
		}

		__class(WebGLCharImage,'laya.webgl.resource.WebGLCharImage',_super);
		var __proto=WebGLCharImage.prototype;
		__proto.size=function(w,h){
			this._w=w;
			this._h=h;
			this.canvas && (this.canvas.height=h,this.canvas.width=w);
		}

		//canvas为公用，其它地方也可能修改其尺寸
		__proto.recreateResource=function(){
			var char=this.char;
			var bIsConchApp=System.isConchApp;
			var xs=char.xs,ys=char.ys;
			this.size(char.width+this.borderSize *2,char.height+this.borderSize *2);
			if (bIsConchApp){
				var sFont="normal 100 "+char.fontSize+"px Arial";
				if (char.borderColor){
					sFont+=" 1 "+char.borderColor;
				}
				this._ctx.font=sFont;
				this._ctx.textBaseline="top";
				this._ctx.fillStyle=char.fillColor;
				this._ctx.fillText(char.char,this.borderSize,this.borderSize,null,null,null);
				}else {
				this._ctx.save();
				(this._ctx).clearRect(0,0,char.width+this.borderSize *4,char.height+this.borderSize *4);
				this._ctx.font=char.font;
				this._ctx.textBaseline="top";
				if (xs !=1 || ys !=1){
					alert("xs="+xs+",ys="+ys);
					this._ctx.scale(xs,ys);
				}
				this._ctx.translate(this.borderSize,this.borderSize);
				if (char.fillColor && char.borderColor){
					/*__JS__ */this._ctx.strokeStyle=char.borderColor;
					/*__JS__ */this._ctx.lineWidth=char.lineWidth;
					this._ctx.strokeText(char.char,0,0,null,null,0,null);
					this._ctx.fillStyle=char.fillColor;
					this._ctx.fillText(char.char,0,0,null,null,null);
					}else {
					if (char.lineWidth===-1){
						this._ctx.fillStyle=char.fillColor ? char.fillColor :"white";
						this._ctx.fillText(char.char,0,0,null,null,null);
						}else {
						/*__JS__ */this._ctx.strokeStyle=char.borderColor?char.borderColor:'white';
						/*__JS__ */this._ctx.lineWidth=char.lineWidth;
						this._ctx.strokeText(char.char,0,0,null,null,0,null);
					}
				}
				this._ctx.restore();
			}
			char.borderSize=this.borderSize;
			laya.resource.Resource.prototype.recreateResource.call(this);
		}

		__proto.copyTo=function(dec){
			var d=dec;
			d._ctx=this._ctx;
			d.canvas=this.canvas;
			d.char=this.char;
			_super.prototype.copyTo.call(this,dec);
		}

		return WebGLCharImage;
	})(Bitmap)


	/**
	*...
	*@author laya
	*/
	//class laya.webgl.resource.WebGLRenderTarget extends laya.resource.Bitmap
	var WebGLRenderTarget=(function(_super){
		function WebGLRenderTarget(width,height,mipMap,surfaceFormat,surfaceType,depthFormat){
			//this._frameBuffer=null;
			//this._depthBuffer=null;
			//this._surfaceFormat=0;
			//this._surfaceType=0;
			//this._depthFormat=0;
			//this._mipMap=false;
			(mipMap===void 0)&& (mipMap=false);
			(surfaceFormat===void 0)&& (surfaceFormat=/*laya.webgl.WebGLContext.RGBA*/0x1908);
			(surfaceType===void 0)&& (surfaceType=/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401);
			(depthFormat===void 0)&& (depthFormat=/*laya.webgl.WebGLContext.DEPTH_COMPONENT16*/0x81A5);
			WebGLRenderTarget.__super.call(this);
			this._w=width;
			this._h=height;
			this._mipMap=mipMap;
			this._surfaceFormat=surfaceFormat;
			this._surfaceType=surfaceType;
			this._depthFormat=depthFormat;
			this.lock=true;
		}

		__class(WebGLRenderTarget,'laya.webgl.resource.WebGLRenderTarget',_super);
		var __proto=WebGLRenderTarget.prototype;
		__proto.recreateResource=function(){
			var gl=WebGL.mainContext;
			this._frameBuffer || (this._frameBuffer=gl.createFramebuffer());
			this._source || (this._source=gl.createTexture());
			gl.bindTexture(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,this._source);
			gl.texImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,this._w,this._h,0,this._surfaceFormat,this._surfaceType,null);
			gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,/*laya.webgl.WebGLContext.LINEAR*/0x2601);
			gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
			gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
			var isPot=Arith.isPOT(this._w,this._h);
			if (this._mipMap && isPot){
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,/*laya.webgl.WebGLContext.LINEAR_MIPMAP_LINEAR*/0x2703);
				gl.generateMipmap(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1);
			}
			else{
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				(this._mipMap)&& (this._mipMap=false);
			}
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,this._frameBuffer);
			gl.framebufferTexture2D(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,/*laya.webgl.WebGLContext.COLOR_ATTACHMENT0*/0x8CE0,/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,this._source,0);
			if (this._depthFormat){
				this._depthBuffer || (this._depthBuffer=gl.createRenderbuffer());
				gl.bindRenderbuffer(/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,this._depthBuffer);
				gl.renderbufferStorage(/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,this._depthFormat,this._w,this._h);
				gl.framebufferRenderbuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,/*laya.webgl.WebGLContext.DEPTH_ATTACHMENT*/0x8D00,/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,this._depthBuffer);
			}
			gl.bindFramebuffer(/*laya.webgl.WebGLContext.FRAMEBUFFER*/0x8D40,null);
			gl.bindTexture(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,null);
			gl.bindRenderbuffer(/*laya.webgl.WebGLContext.RENDERBUFFER*/0x8D41,null);
			this.memorySize=this._w *this._h *4;
			laya.resource.Resource.prototype.recreateResource.call(this);
		}

		__proto.detoryResource=function(){
			if (this._frameBuffer){
				WebGL.mainContext.deleteTexture(this._source);
				WebGL.mainContext.deleteFramebuffer(this._frameBuffer);
				WebGL.mainContext.deleteRenderbuffer(this._depthBuffer);
				this._source=null;
				this._frameBuffer=null;
				this._depthBuffer=null;
				this.memorySize=0;
			}
		}

		__getset(0,__proto,'frameBuffer',function(){
			return this._frameBuffer;
		});

		__getset(0,__proto,'depthBuffer',function(){
			return this._depthBuffer;
		});

		return WebGLRenderTarget;
	})(Bitmap)


	/**
	*...
	*@author
	*/
	//class laya.webgl.resource.WebGLSubImage extends laya.resource.Bitmap
	var WebGLSubImage=(function(_super){
		function WebGLSubImage(canvas,offsetX,offsetY,width,height,atlasImage,src,createOwnSource){
			//this._ctx=null;
			//this.canvas=null;
			//this.repeat=false;
			//this.mipmap=false;
			//this.minFifter=0;
			//this.magFifter=0;
			//this.createOwnSource=false;
			//this.atlasImage=null;
			this.offsetX=0;
			this.offsetY=0;
			//this.src=null;
			(createOwnSource===void 0)&& (createOwnSource=false);
			WebGLSubImage.__super.call(this);
			this.repeat=true;
			this.mipmap=false;
			this.minFifter=-1;
			this.magFifter=-1;
			this.atlasImage=atlasImage;
			this.canvas=canvas;
			this._ctx=canvas.getContext('2d',undefined);
			this.createOwnSource=createOwnSource;
			this._w=width;
			this._h=height;
			this.offsetX=offsetX;
			this.offsetY=offsetY;
			this.src=src;
			this.activeResource();
		}

		__class(WebGLSubImage,'laya.webgl.resource.WebGLSubImage',_super);
		var __proto=WebGLSubImage.prototype;
		__proto.copyTo=function(dec){
			var d=dec;
			_super.prototype.copyTo.call(this,dec);
			d._ctx=this._ctx;
		}

		__proto.size=function(w,h){
			this._w=w;
			this._h=h;
			this._ctx && this._ctx.size(w,h);
			this.canvas && (this.canvas.height=h,this.canvas.width=w);
		}

		__proto.recreateResource=function(){
			this.size(this._w,this._h);
			this._ctx.drawImage(this.atlasImage,this.offsetX,this.offsetY,this._w,this._h,0,0,this._w,this._h);
			(this.createOwnSource)&& (this.createWebGlTexture());
			laya.resource.Resource.prototype.recreateResource.call(this);
		}

		__proto.createWebGlTexture=function(){
			var gl=WebGL.mainContext;
			if (!this.canvas){
				debugger;
				throw "create GLTextur err:no data:"+this.canvas;
			};
			var glTex=this._source=gl.createTexture();
			gl.bindTexture(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,glTex);
			gl.texImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,this.canvas);
			var minFifter=this.minFifter;
			var magFifter=this.magFifter;
			var repeat=this.repeat ? /*laya.webgl.WebGLContext.REPEAT*/0x2901 :/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F;
			var isPOT=Arith.isPOT(this.width,this.height);
			if (isPOT){
				if (this.mipmap)
					(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR_MIPMAP_LINEAR*/0x2703);
				else
				(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				(magFifter!==-1)|| (magFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,magFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,minFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,repeat);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,repeat);
				this.mipmap && gl.generateMipmap(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1);
				}else {
				(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				(magFifter!==-1)|| (magFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,minFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,magFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
			}
			gl.bindTexture(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,null);
			this.canvas=null;
			this.memorySize=this._w *this._h *4;
		}

		__proto.detoryResource=function(){
			if (this.createOwnSource && this._source){
				WebGL.mainContext.deleteTexture(this._source);
				this._source=null;
				this.memorySize=0;
			}
		}

		return WebGLSubImage;
	})(Bitmap)


	//class laya.webgl.shader.d2.value.GlowSV extends laya.webgl.shader.d2.value.TextureSV
	var GlowSV=(function(_super){
		function GlowSV(){
			this.u_blurX=false;
			this.u_color=null;
			this.u_offset=null;
			this.u_strength=NaN;
			this.u_texW=0;
			this.u_texH=0;
			GlowSV.__super.call(this,/*laya.webgl.shader.d2.ShaderDefines2D.FILTERGLOW*/0x08| /*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01);
		}

		__class(GlowSV,'laya.webgl.shader.d2.value.GlowSV',_super);
		var __proto=GlowSV.prototype;
		__proto.setValue=function(vo){
			_super.prototype.setValue.call(this,vo);
		}

		__proto.clear=function(){
			_super.prototype.clear.call(this);
		}

		return GlowSV;
	})(TextureSV)


	//class laya.webgl.shader.d2.value.TextSV extends laya.webgl.shader.d2.value.TextureSV
	var TextSV=(function(_super){
		function TextSV(){
			TextSV.__super.call(this,/*laya.webgl.shader.d2.ShaderDefines2D.COLORADD*/0x40);
			this.defines.add(/*laya.webgl.shader.d2.ShaderDefines2D.COLORADD*/0x40);
		}

		__class(TextSV,'laya.webgl.shader.d2.value.TextSV',_super);
		var __proto=TextSV.prototype;
		__proto.release=function(){
			TextSV.pool[TextSV._length++]=this;
			this.clear();
		}

		__proto.clear=function(){
			_super.prototype.clear.call(this);
		}

		TextSV.create=function(){
			if (TextSV._length)return TextSV.pool[--TextSV._length];
			else return new TextSV();
		}

		TextSV.pool=[];
		TextSV._length=0;
		return TextSV;
	})(TextureSV)


	/**
	*...
	*@author
	*/
	//class laya.webgl.resource.WebGLImage extends laya.resource.FileBitmap
	var WebGLImage=(function(_super){
		function WebGLImage(im){
			this._recreateLock=false;
			this._needReleaseAgain=false;
			this._image=null;
			this.repeat=false;
			this.mipmap=false;
			this.minFifter=0;
			this.magFifter=0;
			this.createOwnSource=false;
			WebGLImage.__super.call(this);
			this.repeat=true;
			this.mipmap=false;
			this.minFifter=-1;
			this.magFifter=-1;
			this._image=im || new Browser.window.Image();
			this.createOwnSource=true;
		}

		__class(WebGLImage,'laya.webgl.resource.WebGLImage',_super);
		var __proto=WebGLImage.prototype;
		/***重新创建资源*/
		__proto.recreateResource=function(){
			if (this._src==="")
				throw new Error("src不能为空！");
			var isPOT=Arith.isPOT(this.width,this.height);
			if (!this._image){
				this._recreateLock=true;
				var _this=this;
				this._image=new Browser.window.Image();
				this._image.onload=function (){
					_this._image.onload=null;
					if (_this._needReleaseAgain){
						_this._needReleaseAgain=false;
						_this._image=null;
						return;
					}
					(_this.createOwnSource)&& (_this.createWebGlTexture());
					_this.compoleteCreate();
				};
				_this._image.src=this._src;
				}else {
				if (this._recreateLock)
					return;
				(this.createOwnSource)&& (this.createWebGlTexture());
				this.compoleteCreate();
			}
		}

		/***复制资源,此方法为浅复制*/
		__proto.copyTo=function(dec){
			var webglImage=dec;
			webglImage._image=this._image;
			laya.resource.Bitmap.prototype.copyTo.call(this,webglImage);
		}

		/***销毁资源*/
		__proto.detoryResource=function(){
			if (this._recreateLock)
				this._needReleaseAgain=true;
			if (this._source){
				(this.createOwnSource)&& (WebGL.mainContext.deleteTexture(this._source));
				this._source=null;
				this.memorySize=0;
			}
		}

		__proto.createWebGlTexture=function(){
			var gl=WebGL.mainContext;
			if (!this._image){
				throw "create GLTextur err:no data:"+this._image;
			};
			var glTex=this._source=gl.createTexture();
			gl.bindTexture(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,glTex);
			gl.texImage2D(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,0,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.RGBA*/0x1908,/*laya.webgl.WebGLContext.UNSIGNED_BYTE*/0x1401,this._image);
			var minFifter=this.minFifter;
			var magFifter=this.magFifter;
			var repeat=this.repeat ? /*laya.webgl.WebGLContext.REPEAT*/0x2901 :/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F;
			var isPOT=Arith.isPOT(this.width,this.height);
			if (isPOT){
				if (this.mipmap)
					(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR_MIPMAP_LINEAR*/0x2703);
				else
				(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				(magFifter!==-1)|| (magFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,magFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,minFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,repeat);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,repeat);
				this.mipmap && gl.generateMipmap(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1);
				}else {
				(minFifter!==-1)|| (minFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				(magFifter!==-1)|| (magFifter=/*laya.webgl.WebGLContext.LINEAR*/0x2601);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MIN_FILTER*/0x2801,minFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_MAG_FILTER*/0x2800,magFifter);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_S*/0x2802,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
				gl.texParameteri(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,/*laya.webgl.WebGLContext.TEXTURE_WRAP_T*/0x2803,/*laya.webgl.WebGLContext.CLAMP_TO_EDGE*/0x812F);
			}
			gl.bindTexture(/*laya.webgl.WebGLContext.TEXTURE_2D*/0x0DE1,null);
			this._image=null;
			if (this.createOwnSource && isPOT)
				this.memorySize=this._w *this._h *4 *(1+1 / 3);
			else
			this.memorySize=this._w *this._h *4;
			this._recreateLock=false;
		}

		/***调整尺寸*/
		__proto.onresize=function(){
			this._w=this._image.width;
			this._h=this._image.height;
		}

		/**
		*返回HTML Image,as3无internal货friend，通常禁止开发者修改image内的任何属性
		*@param HTML Image
		*/
		__getset(0,__proto,'image',function(){
			return this._image;
		});

		/***
		*设置onload函数
		*@param value onload函数
		*/
		__getset(0,__proto,'onload',null,function(value){
			var _$this=this;
			this._onload=value;
			this._image && (this._image.onload=this._onload !=null ? (function(){
				_$this.onresize();
				_$this._onload();
			}):null);
		});

		/**
		*设置文件路径全名
		*@param 文件路径全名
		*/
		__getset(0,__proto,'src',_super.prototype._$get_src,function(value){
			this._src=value;
			this._image && (this._image.src=value);
		});

		/***
		*设置onerror函数
		*@param value onerror函数
		*/
		__getset(0,__proto,'onerror',null,function(value){
			var _$this=this;
			this._onerror=value;
			this._image && (this._image.onerror=this._onerror !=null ? (function(){
				_$this._onerror()
			}):null);
		});

		return WebGLImage;
	})(FileBitmap)


	Laya.__init([WebGLContext2D,ShaderCompile,AtlasGrid,WebGLContext,RenderTargetMAX]);
})(window,document,Laya);
