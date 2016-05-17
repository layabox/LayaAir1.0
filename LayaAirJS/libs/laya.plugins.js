
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Sprite=laya.display.Sprite,Texture=laya.resource.Texture,Point=laya.maths.Point,Rectangle=laya.maths.Rectangle;
	var WebGL=laya.webgl.WebGL,Loader=laya.net.Loader,Handler=laya.utils.Handler,Browser=laya.utils.Browser;
	/**
	*tiledMap是整个地图的核心
	*地图以层级来划分地图（例如：地表层，植被层，建筑层）
	*每层又以分块（GridSprite)来处理显示对象，只显示在视口区域的区
	*每块又包括N*N个格子（tile)
	*格子类型又分为动画格子跟图片格子两种
	*@author ...
	*/
	//class laya.map.TiledMap
	var TiledMap=(function(){
		var GRect,TileMapAniData,TileSet;
		function TiledMap(){
			this._jsonData=null;
			this._tileTexSetArr=[];
			this._texArray=[];
			this._x=0;
			this._y=0;
			this._width=0;
			this._height=0;
			this._mapW=0;
			this._mapH=0;
			this._mapTileW=0;
			this._mapTileH=0;
			this._mapSprite=null;
			this._layerArray=[];
			this._gridArray=[];
			this._showGridKey=false;
			this._totalGridNum=0;
			this._gridW=0;
			this._gridH=0;
			this._gridWidth=450;
			this._gridHeight=450;
			this._jsonLoader=null;
			this._loader=null;
			this._tileSetArray=[];
			this._currTileSet=null;
			this._completeHandler=null;
			this._index=0;
			this._animationDic={};
			this._orientation="orthogonal";
			this._renderOrder="right-down";
			this._colorArray=["FF","00","33","66"];
			this._rect=new Rectangle();
			this._paddingRect=new Rectangle();
			this._mapRect=new GRect();
			this._mapLastRect=new GRect();
		}

		__class(TiledMap,'laya.map.TiledMap');
		var __proto=TiledMap.prototype;
		/**
		*创建地图
		*@param mapName JSON文件名字
		*@param viewRect 视口区域
		*@param completeHandler 地图创建完成的回调函数
		*@param viewRectPadding 视口扩充区域，把视口区域上、下、左、右扩充一下，防止视口移动时的穿帮
		*@param gridSize grid大小
		*/
		__proto.createMap=function(mapName,viewRect,completeHandler,viewRectPadding,gridSize){
			this._rect.x=viewRect.x;
			this._rect.y=viewRect.y;
			this._rect.width=viewRect.width;
			this._rect.height=viewRect.height;
			this._completeHandler=completeHandler;
			if (viewRectPadding){
				this._paddingRect.copyFrom(viewRectPadding);
				}else {
				this._paddingRect.setTo(0,0,0,0);
			}
			if (gridSize){
				this._gridWidth=gridSize.x;
				this._gridHeight=gridSize.y;
			}
			this._jsonLoader=new Loader();
			this._jsonLoader.once("complete",this,this.onJsonComplete);
			this._jsonLoader.load(mapName,/*laya.net.Loader.JSOn*/"json",false);
		}

		/**
		*json文件读取成功后，解析里面的纹理数据，进行加载
		*@param e JSON数据
		*/
		__proto.onJsonComplete=function(e){
			this._mapSprite=new Sprite();
			Laya.stage.addChild(this._mapSprite);
			var tJsonData=this._jsonData=e;
			this._orientation=tJsonData.orientation;
			this._renderOrder=tJsonData.renderorder;
			this._mapW=tJsonData.width;
			this._mapH=tJsonData.height;
			this._mapTileW=tJsonData.tilewidth;
			this._mapTileH=tJsonData.tileheight;
			this._width=this._mapTileW *this._mapW;
			this._height=this._mapTileH *this._mapH;
			this._mapLastRect.top=this._mapLastRect.bottom=this._mapLastRect.left=this._mapLastRect.right=-1;
			this._mapRect.top=Math.floor(this._rect.y / this._mapTileH);
			this._mapRect.bottom=Math.floor((this._rect.y+this._rect.height)/ this._mapTileH);
			this._mapRect.left=Math.floor(this._rect.x / this._mapTileW);
			this._mapRect.right=Math.floor((this._rect.x+this._rect.width)/ this._mapTileW);
			var tArray=tJsonData.tilesets;
			var tileset;
			var tTileSet;
			for (var i=0;i < tArray.length;i++){
				tileset=tArray[i];
				tTileSet=new TileSet();
				tTileSet.init(tileset);
				this._tileSetArray.push(tTileSet);
				var tTiles=tileset.tiles;
				if (tTiles){
					for (var p in tTiles){
						var tAnimation=tTiles[p].animation;
						if (tAnimation){
							var tAniData=new TileMapAniData();
							this._animationDic[p]=tAniData;
							for (var j=0;j < tAnimation.length;j++){
								var tAnimationItem=tAnimation[j];
								tAniData.mAniIdArray.push(tAnimationItem.tileid);
								tAniData.mDurationTimeArray.push(tAnimationItem.duration);
							}
						}
					}
				}
			}
			this._tileTexSetArr.push(null);
			if (this._tileSetArray.length > 0){
				tTileSet=this._currTileSet=this._tileSetArray.shift();
				this._loader=new Loader();
				this._loader.once("complete",this,this.onTextureComplete);
				this._loader.load(tTileSet.image,/*laya.net.Loader.IMAGE*/"image",false);
			}
		}

		/**
		*纹理加载完成，如果所有的纹理加载，开始初始化地图
		*@param e 纹理数据
		*/
		__proto.onTextureComplete=function(e){
			var json=this._jsonData;
			var tTexture=e;
			this._texArray.push(tTexture);
			var tSubTexture=null;
			var tTileSet=this._currTileSet;
			var tTileTextureW=tTileSet.tilewidth;
			var tTileTextureH=tTileSet.tileheight;
			var tImageWidth=tTileSet.imagewidth;
			var tImageHeight=tTileSet.imageheight;
			var tFirstgid=tTileSet.firstgid;
			var tTileWNum=Math.floor((tImageWidth-tTileSet.margin-tTileTextureW)/ (tTileTextureW+tTileSet.spacing))+1;
			var tTileHNum=Math.floor((tImageHeight-tTileSet.margin-tTileTextureH)/ (tTileTextureH+tTileSet.spacing))+1;
			var tTileTexSet=null;
			for (var i=0;i < tTileHNum;i++){
				for (var j=0;j < tTileWNum;j++){
					tTileTexSet=new TileTexSet();
					tTileTexSet.offX=tTileSet.titleoffsetX;
					tTileTexSet.offY=tTileSet.titleoffsetY-(tTileTextureH-this._mapTileH);
					tTileTexSet.texture=Texture.create(tTexture,tTileSet.margin+(tTileTextureW+tTileSet.spacing)*j,tTileSet.margin+(tTileTextureH+tTileSet.spacing)*i,tTileTextureW,tTileTextureH);
					this._tileTexSetArr.push(tTileTexSet);
					tTileTexSet.gid=this._tileTexSetArr.length;
				}
			}
			if (this._tileSetArray.length > 0){
				tTileSet=this._currTileSet=this._tileSetArray.shift();
				this._loader.once("complete",this,this.onTextureComplete);
				this._loader.load(tTileSet.image,/*laya.net.Loader.IMAGE*/"image",false);
				}else {
				this._currTileSet=null;
				this.initMap();
			}
		}

		/**
		*初始化地图
		*/
		__proto.initMap=function(){
			var i=0;
			for (var p in this._animationDic){
				var tTileTexSet=this.getTexture(Laya.__parseInt(p)+1);
				var tAniData=this._animationDic[p];
				if (tAniData.mAniIdArray.length > 0){
					tTileTexSet.textureArray=[];
					tTileTexSet.durationTimeArray=tAniData.mDurationTimeArray;
					tTileTexSet.animationKey=true;
					for (i=0;i < tAniData.mAniIdArray.length;i++){
						var tTexture=this.getTexture(tAniData.mAniIdArray[i]+1);
						tTileTexSet.textureArray.push(tTexture);
					}
				}
			}
			this._gridWidth=Math.floor(this._gridWidth / this._mapTileW)*this._mapTileW;
			this._gridHeight=Math.floor(this._gridHeight / this._mapTileH)*this._mapTileH;
			if (this._gridWidth < this._mapTileW){
				this._gridWidth=this._mapTileW;
			}
			if (this._gridWidth < this._mapTileH){
				this._gridWidth=this._mapTileH;
			}
			this._gridW=Math.ceil(this._width / this._gridWidth);
			this._gridH=Math.ceil(this._height / this._gridHeight);
			this._totalGridNum=this._gridW *this._gridH;
			for (i=0;i < this._gridH;i++){
				var tGridArray=[];
				this._gridArray.push(tGridArray);
				for (var j=0;j < this._gridW;j++){
					tGridArray.push(null);
				}
			};
			var tLayerArray=this._jsonData.layers;
			for (var tLayerLoop=0;tLayerLoop < tLayerArray.length;tLayerLoop++){
				var tLayerData=tLayerArray[tLayerLoop];
				if (tLayerData.visible==true){
					var tMapLayer=new MapLayer();
					tMapLayer.init(tLayerData,this);
					this._mapSprite.addChild(tMapLayer);
					this._layerArray.push(tMapLayer);
				}
			}
			this.moveViewPort(this._rect.x,this._rect.y);
			if (this._completeHandler !=null){
				this._completeHandler.run();
			}
		}

		/**
		*得到一块指定的地图纹理
		*@param index 纹理的索引值，默认从1开始
		*@return
		*/
		__proto.getTexture=function(index){
			if (index < this._tileTexSetArr.length){
				return this._tileTexSetArr[index];
			}
			return null;
		}

		/**
		*通过纹理索引，生成一个可控制物件
		*@param index 纹理的索引值，默认从1开始
		*@return
		*/
		__proto.getSprite=function(index){
			if (0 < this._tileTexSetArr.length){
				var tGridSprite=new GridSprite();
				tGridSprite.initData(this,true);
				var tTileTexSet=this._tileTexSetArr[index];
				if (tTileTexSet !=null && tTileTexSet.texture !=null){
					if (tTileTexSet.animationKey){
						var tAnimationSprite=new TileAniSprite();
						this._index++;
						tAnimationSprite.setTileTextureSet(this._index.toString(),tTileTexSet);
						tGridSprite.addAniSprite(tAnimationSprite);
						tGridSprite.addChild(tAnimationSprite);
						}else {
						tGridSprite.graphics.drawTexture(tTileTexSet.texture,tTileTexSet.offX,tTileTexSet.offY,tTileTexSet.texture.width,tTileTexSet.texture.height);
					}
					tGridSprite.drawImageNum++;
				}
				return tGridSprite;
			}
			return null;
		}

		/**
		*移动视口
		*@param moveX 视口的坐标x
		*@param moveY 视口的坐标y
		*/
		__proto.moveViewPort=function(moveX,moveY){
			this._x=-moveX;
			this._y=-moveY;
			this._rect.x=moveX;
			this._rect.y=moveY;
			this.updateViewPort();
		}

		/**
		*改变视口大小
		*@param moveX 视口的坐标x
		*@param moveY 视口的坐标y
		*@param width 视口的宽
		*@param height 视口的高
		*/
		__proto.changeViewPort=function(moveX,moveY,width,height){
			this._x=-moveX;
			this._y=-moveY;
			this._rect.x=moveX;
			this._rect.y=moveY;
			this._rect.width=width;
			this._rect.height=height;
			this.updateViewPort();
		}

		/**
		*刷新视口
		*/
		__proto.updateViewPort=function(){
			var tPaddingRect=this._paddingRect;
			var tX=this._rect.x-tPaddingRect.x;
			var tY=this._rect.y-tPaddingRect.y;
			var tWidth=this._rect.width+tPaddingRect.width+tPaddingRect.x;
			var tHeight=this._rect.height+tPaddingRect.height+tPaddingRect.y;
			this._mapRect.top=Math.floor(tY / this._gridHeight);
			this._mapRect.bottom=Math.floor((tY+tHeight)/ this._gridHeight);
			this._mapRect.left=Math.floor(tX / this._gridWidth);
			this._mapRect.right=Math.floor((tX+tWidth)/ this._gridWidth);
			this.clipViewPort();
			this._mapLastRect.top=this._mapRect.top;
			this._mapLastRect.bottom=this._mapRect.bottom;
			this._mapLastRect.left=this._mapRect.left;
			this._mapLastRect.right=this._mapRect.right;
			var tMapLayer;
			for (var i=0;i < this._layerArray.length;i++){
				tMapLayer=this._layerArray[i];
				tMapLayer.updateGridPos();
			}
		}

		/**
		*GRID裁剪
		*/
		__proto.clipViewPort=function(){
			var tSpriteNum=0;
			var tSprite;
			var tIndex=0;
			var tSub=0;
			var tAdd=0;
			var i=0,j=0;
			if (this._mapRect.left > this._mapLastRect.left){
				tSub=this._mapRect.left-this._mapLastRect.left;
				if (tSub > 0){
					for (j=this._mapLastRect.left;j < this._mapLastRect.left+tSub;j++){
						for (i=this._mapLastRect.top;i <=this._mapLastRect.bottom;i++){
							this.hideGrid(j,i);
						}
					}
				}
				}else {
				tAdd=this._mapLastRect.left-this._mapRect.left;
				if (tAdd > 0){
					for (j=this._mapRect.left;j < this._mapRect.left+tAdd;j++){
						for (i=this._mapRect.top;i <=this._mapRect.bottom;i++){
							this.showGrid(j,i);
						}
					}
				}
			}
			if (this._mapRect.right > this._mapLastRect.right){
				tAdd=this._mapRect.right-this._mapLastRect.right;
				if (tAdd > 0){
					for (j=this._mapLastRect.right+1;j <=this._mapLastRect.right+tAdd;j++){
						for (i=this._mapRect.top;i <=this._mapRect.bottom;i++){
							this.showGrid(j,i);
						}
					}
				}
				}else {
				tSub=this._mapLastRect.right-this._mapRect.right
				if (tSub > 0){
					for (j=this._mapRect.right+1;j <=this._mapRect.right+tSub;j++){
						for (i=this._mapLastRect.top;i <=this._mapLastRect.bottom;i++){
							this.hideGrid(j,i);
						}
					}
				}
			}
			if (this._mapRect.top > this._mapLastRect.top){
				tSub=this._mapRect.top-this._mapLastRect.top;
				if (tSub > 0){
					for (i=this._mapLastRect.top;i < this._mapLastRect.top+tSub;i++){
						for (j=this._mapLastRect.left;j <=this._mapLastRect.right;j++){
							this.hideGrid(j,i);
						}
					}
				}
				}else {
				tAdd=this._mapLastRect.top-this._mapRect.top;
				if (tAdd > 0){
					for (i=this._mapRect.top;i < this._mapRect.top+tAdd;i++){
						for (j=this._mapRect.left;j <=this._mapRect.right;j++){
							this.showGrid(j,i);
						}
					}
				}
			}
			if (this._mapRect.bottom > this._mapLastRect.bottom){
				tAdd=this._mapRect.bottom-this._mapLastRect.bottom;
				if (tAdd > 0){
					for (i=this._mapLastRect.bottom+1;i <=this._mapLastRect.bottom+tAdd;i++){
						for (j=this._mapRect.left;j <=this._mapRect.right;j++){
							this.showGrid(j,i);
						}
					}
				}
				}else {
				tSub=this._mapLastRect.bottom-this._mapRect.bottom
				if (tSub > 0){
					for (i=this._mapRect.bottom+1;i <=this._mapRect.bottom+tSub;i++){
						for (j=this._mapLastRect.left;j <=this._mapLastRect.right;j++){
							this.hideGrid(j,i);
						}
					}
				}
			}
		}

		/**
		*显示指定的GRID
		*@param gridX
		*@param gridY
		*/
		__proto.showGrid=function(gridX,gridY){
			if (gridX < 0 || gridX >=this._gridW || gridY < 0 || gridY >=this._gridH){
				return;
			};
			var i=0,j=0;
			var tGridSprite;
			var tTempArray=this._gridArray[gridY][gridX];
			if (tTempArray==null){
				tTempArray=this._gridArray[gridY][gridX]=[];
				var tLeft=0;
				var tRight=0;
				var tTop=0;
				var tBottom=0;
				var tGridWidth=this._gridWidth;
				var tGridHeight=this._gridHeight;
				switch (this.orientation){
					case /*CLASS CONST:laya.map.TiledMap.ORIENTATION_ISOMETRIC*/"isometric":
						tLeft=Math.floor(gridX *tGridWidth);
						tRight=Math.floor(gridX *tGridWidth+tGridWidth);
						tTop=Math.floor(gridY *tGridHeight);
						tBottom=Math.floor(gridY *tGridHeight+tGridHeight);
						var tLeft1=0,tRight1=0,tTop1=0,tBottom1=0;
						break ;
					case /*CLASS CONST:laya.map.TiledMap.ORIENTATION_ORTHOGONAL*/"orthogonal":
						tLeft=Math.floor(gridX *tGridWidth / this._mapTileW);
						tRight=Math.floor((gridX *tGridWidth+tGridWidth)/ this._mapTileW);
						tTop=Math.floor(gridY *tGridHeight / this._mapTileH);
						tBottom=Math.floor((gridY *tGridHeight+tGridHeight)/ this._mapTileH);
						break ;
					case /*CLASS CONST:laya.map.TiledMap.ORIENTATION_HEXAGONAL*/"hexagonal":;
						var tHeight=this._mapTileH *2 / 3;
						tLeft=Math.floor(gridX *tGridWidth / this._mapTileW);
						tRight=Math.ceil((gridX *tGridWidth+tGridWidth)/ this._mapTileW);
						tTop=Math.floor(gridY *tGridHeight / tHeight);
						tBottom=Math.ceil((gridY *tGridHeight+tGridHeight)/ tHeight);
						break ;
					};
				var tLayer=null;
				for (var z=0;z < this._layerArray.length;z++){
					tLayer=this._layerArray[z];
					tGridSprite=tLayer.getDrawSprite(gridX,gridY);
					tTempArray.push(tGridSprite);
					var tColorStr;
					if (this._showGridKey){
						tColorStr="#";
						tColorStr+=this._colorArray[Math.floor(Math.random()*this._colorArray.length)];
						tColorStr+=this._colorArray[Math.floor(Math.random()*this._colorArray.length)];
						tColorStr+=this._colorArray[Math.floor(Math.random()*this._colorArray.length)];
					}
					switch (this.orientation){
						case /*CLASS CONST:laya.map.TiledMap.ORIENTATION_ISOMETRIC*/"isometric":;
							var tHalfTileHeight=this.TileHeight / 2;
							var tHalfTileWidth=this.TileWidth / 2;
							var tHalfMapWidth=this._width / 2;
							tTop1=Math.floor(tTop / tHalfTileHeight);
							tBottom1=Math.floor(tBottom / tHalfTileHeight);
							tLeft1=this._mapW+Math.floor((tLeft-tHalfMapWidth)/ tHalfTileWidth);
							tRight1=this._mapW+Math.floor((tRight-tHalfMapWidth)/ tHalfTileWidth);
							var tMapW=this._mapW *2;
							var tMapH=this._mapH *2;
							if (tTop1 < 0){
								tTop1=0;
							}
							if (tTop1 >=tMapH){
								tTop1=tMapH-1;
							}
							if (tBottom1 < 0){
								tBottom=0;
							}
							if (tBottom1 >=tMapH){
								tBottom1=tMapH-1;
							}
							tGridSprite.zOrder=this._totalGridNum *z+gridY *this._gridW+gridX;
							for (i=tTop1;i < tBottom1;i++){
								for (j=0;j <=i;j++){
									var tIndexX=i-j;
									var tIndexY=j;
									var tIndexValue=(tIndexX-tIndexY)+this._mapW;
									if (tIndexValue > tLeft1 && tIndexValue <=tRight1){
										if (tLayer.drawTileTexture(tGridSprite,tIndexX,tIndexY)){
											tGridSprite.drawImageNum++;
										}
									}
								}
							}
							break ;
						case /*CLASS CONST:laya.map.TiledMap.ORIENTATION_ORTHOGONAL*/"orthogonal":
						case /*CLASS CONST:laya.map.TiledMap.ORIENTATION_HEXAGONAL*/"hexagonal":
						switch (this._renderOrder){
							case "right-down":
								tGridSprite.zOrder=z *this._totalGridNum+gridY *this._gridW+gridX;
								for (i=tTop;i < tBottom;i++){
									for (j=tLeft;j < tRight;j++){
										if (tLayer.drawTileTexture(tGridSprite,j,i)){
											tGridSprite.drawImageNum++;
										}
									}
								}
								break ;
							case "right-up":
								tGridSprite.zOrder=z *this._totalGridNum+(this._gridH-1-gridY)*this._gridW+gridX;
								for (i=tBottom-1;i >=tTop;i--){
									for (j=tLeft;j < tRight;j++){
										if (tLayer.drawTileTexture(tGridSprite,j,i)){
											tGridSprite.drawImageNum++;
										}
									}
								}
								break ;
							case "left-down":
								tGridSprite.zOrder=z *this._totalGridNum+gridY *this._gridW+(this._gridW-1-gridX);
								for (i=tTop;i < tBottom;i++){
									for (j=tRight-1;j >=tLeft;j--){
										if (tLayer.drawTileTexture(tGridSprite,j,i)){
											tGridSprite.drawImageNum++;
										}
									}
								}
								break ;
							case "left-up":
								tGridSprite.zOrder=z *this._totalGridNum+(this._gridH-1-gridY)*this._gridW+(this._gridW-1-gridX);
								for (i=tBottom-1;i >=tTop;i--){
									for (j=tRight-1;j >=tLeft;j--){
										if (tLayer.drawTileTexture(tGridSprite,j,i)){
											tGridSprite.drawImageNum++;
										}
									}
								}
								break ;
							}
						break ;
					}
					if (!tGridSprite.haveAnimationKey){
						tGridSprite.autoSize=true;
						tGridSprite.cacheAsBitmap=true;
						tGridSprite.autoSize=false;
					}
					if (tGridSprite.drawImageNum > 0){
						tLayer.addChild(tGridSprite);
					}
					if (this._showGridKey){
						tGridSprite.graphics.drawRect(0,0,tGridWidth,tGridHeight,null,tColorStr);
					}
				}
				}else {
				for (i=0;i < tTempArray.length && i < this._layerArray.length;i++){
					var tLayerSprite=this._layerArray[i];
					if (tLayerSprite && tTempArray[i]){
						tGridSprite=tTempArray[i];
						if (tGridSprite.visible==false && tGridSprite.drawImageNum > 0){
							tGridSprite.show();
						}
					}
				}
			}
		}

		/**
		*隐藏指定的GRID
		*@param gridX
		*@param gridY
		*/
		__proto.hideGrid=function(gridX,gridY){
			if (gridX < 0 || gridX >=this._gridW || gridY < 0 || gridY >=this._gridH){
				return;
			};
			var tTempArray=this._gridArray[gridY][gridX];
			if (tTempArray){
				var tGridSprite;
				for (var i=0;i < tTempArray.length;i++){
					tGridSprite=tTempArray[i];
					if (tGridSprite.drawImageNum > 0){
						if (tGridSprite !=null){
							tGridSprite.hide();
						}
					}
				}
			}
		}

		/**
		*得到对象层上的某一个物品
		*@param layerName 层的名称
		*@param objectName 所找物品的名称
		*@return
		*/
		__proto.getLayerObject=function(layerName,objectName){
			var tLayer=null;
			for (var i=0;i < this._layerArray.length;i++){
				tLayer=this._layerArray[i];
				if (tLayer.layerName==layerName){
					break ;
				}
			}
			if (tLayer){
				return tLayer.getObjectByName(objectName);
			}
			return null;
		}

		/**
		*销毁地图
		*/
		__proto.destory=function(){
			this._orientation="orthogonal";
			this._jsonData=null;
			var i=0;
			var j=0;
			var z=0;
			this._gridArray=[];
			var tTileTexSet;
			for (i=0;i < this._tileTexSetArr.length;i++){
				tTileTexSet=this._tileTexSetArr[i];
				if (tTileTexSet){
					tTileTexSet.clearAll();
				}
			}
			this._tileTexSetArr=[];
			var tTexture;
			for (i=0;i < this._texArray.length;i++){
				tTexture=this._texArray[i];
				tTexture.destroy();
			}
			this._texArray=[];
			this._width=0;
			this._height=0;
			this._mapW=0;
			this._mapH=0;
			this._mapTileW=0;
			this._mapTileH=0;
			this._rect.setTo(0,0,0,0);
			var tLayer;
			for (i=0;i < this._layerArray.length;i++){
				tLayer=this._layerArray[i];
				tLayer.clearAll();
			}
			this._layerArray=[];
			if (this._mapSprite){
				this._mapSprite.destroy();
				this._mapSprite=null;
			}
			this._jsonLoader=null;
			this._loader=null;
			var tDic=this._animationDic;
			for (var p in tDic){
				delete tDic[p];
			}
			this._currTileSet=null;
			this._completeHandler=null;
			this._mapRect.clearAll();
			this._mapLastRect.clearAll();
			this._tileSetArray=[];
			this._gridWidth=450;
			this._gridHeight=450;
			this._gridW=0;
			this._gridH=0;
			this._x=0;
			this._y=0;
			this._index=0;
		}

		/**
		*整个地图的显示容器
		*@return 地图的显示容器
		*/
		__proto.mapSprite=function(){
			return this._mapSprite;
		}

		/**
		*得到指定的MapLayer
		*@param layerName 要找的层名称
		*@return
		*/
		__proto.getLayerByName=function(layerName){
			var tMapLayer;
			for (var i=0;i < this._layerArray.length;i++){
				tMapLayer=this._layerArray[i];
				if (layerName==tMapLayer.layerName){
					return tMapLayer;
				}
			}
			return null;
		}

		/**
		*通过索引得MapLayer
		*@param index 要找的层索引
		*@return
		*/
		__proto.getLayerByIndex=function(index){
			if (index < this._layerArray.length){
				return this._layerArray[index];
			}
			return null;
		}

		/**
		*格子的宽度
		*/
		__getset(0,__proto,'TileWidth',function(){
			return this._mapTileW;
		});

		/**
		*格子的高度
		*/
		__getset(0,__proto,'TileHeight',function(){
			return this._mapTileH;
		});

		/**
		*地图的横向块数
		*/
		__getset(0,__proto,'gridW',function(){
			return this._gridW;
		});

		/**
		*地图的宽度
		*/
		__getset(0,__proto,'width',function(){
			return this._width;
		});

		/**
		*地图的高度
		*/
		__getset(0,__proto,'height',function(){
			return this._height;
		});

		/**
		*视口x坐标
		*/
		__getset(0,__proto,'viewPortX',function(){
			return this._rect.x;
		});

		/**
		*视口的y坐标
		*/
		__getset(0,__proto,'viewPortY',function(){
			return this._rect.y;
		});

		/**
		*地图横向的格子数
		*/
		__getset(0,__proto,'MapWidth',function(){
			return this._mapW;
		});

		/**
		*地图竖向的格子数
		*/
		__getset(0,__proto,'MapHeight',function(){
			return this._mapH;
		});

		/**
		*地图的y坐标
		*/
		__getset(0,__proto,'y',function(){
			return this._y;
		});

		/**
		*地图的x坐标
		*/
		__getset(0,__proto,'x',function(){
			return this._x;
		});

		/**
		*块的宽度
		*/
		__getset(0,__proto,'gridWidth',function(){
			return this._gridWidth;
		});

		/**
		*块的高度
		*/
		__getset(0,__proto,'gridHeight',function(){
			return this._gridHeight;
		});

		/**
		*地图的坚向块数
		*/
		__getset(0,__proto,'gridH',function(){
			return this._gridH;
		});

		/**
		*当前地图类型
		*/
		__getset(0,__proto,'orientation',function(){
			return this._orientation;
		});

		/**
		*tile渲染顺序
		*/
		__getset(0,__proto,'renderOrder',function(){
			return this._renderOrder;
		});

		TiledMap.ORIENTATION_ORTHOGONAL="orthogonal";
		TiledMap.ORIENTATION_ISOMETRIC="isometric";
		TiledMap.ORIENTATION_HEXAGONAL="hexagonal";
		TiledMap.RENDERORDER_RIGHTDOWN="right-down";
		TiledMap.RENDERORDER_RIGHTUP="right-up";
		TiledMap.RENDERORDER_LEFTDOWN="left-down";
		TiledMap.RENDERORDER_LEFTUP="left-up";
		TiledMap.__init$=function(){
			//class GRect
			GRect=(function(){
				function GRect(){
					this.left=0;
					this.top=0;
					this.right=0;
					this.bottom=0;
				}
				__class(GRect,'');
				var __proto=GRect.prototype;
				__proto.clearAll=function(){
					this.left=this.top=this.right=this.bottom=0;
				}
				return GRect;
			})()
			//class TileMapAniData
			TileMapAniData=(function(){
				function TileMapAniData(){
					this.mAniIdArray=[];
					this.mDurationTimeArray=[];
					this.mTileTexSetArr=[];
				}
				__class(TileMapAniData,'');
				return TileMapAniData;
			})()
			//class TileSet
			TileSet=(function(){
				function TileSet(){
					this.firstgid=0;
					this.image="";
					this.imageheight=0;
					this.imagewidth=0;
					this.margin=0;
					this.name=0;
					this.properties=null;
					this.spacing=0;
					this.tileheight=0;
					this.tilewidth=0;
					this.titleoffsetX=0;
					this.titleoffsetY=0;
				}
				__class(TileSet,'');
				var __proto=TileSet.prototype;
				__proto.init=function(data){
					this.firstgid=data.firstgid;
					this.image=data.image;
					this.imageheight=data.imageheight;
					this.imagewidth=data.imagewidth;
					this.margin=data.margin;
					this.name=data.name;
					this.properties=data.properties;
					this.spacing=data.spacing;
					this.tileheight=data.tileheight;
					this.tilewidth=data.tilewidth;
					var tTileoffset=data.tileoffset;
					if (tTileoffset){
						this.titleoffsetX=tTileoffset.x;
						this.titleoffsetY=tTileoffset.y;
					}
				}
				return TileSet;
			})()
		}

		return TiledMap;
	})()


	/**
	*此类是子纹理类，也包括同类动画的管理
	*TiledMap会把纹理分割成无数子纹理，也可以把其中的某块子纹理替换成一个动画序列
	*本类的实现就是如果发现子纹理被替换成一个动画序列，animationKey会被设为true
	*即animationKey为true,就使用TileAniSprite来做显示，把动画序列根据时间画到TileAniSprite上
	*@author ...
	*/
	//class laya.map.TileTexSet
	var TileTexSet=(function(){
		function TileTexSet(){
			this.gid=-1;
			this.texture=null;
			this.offX=0;
			this.offY=0;
			this.textureArray=null;
			this.durationTimeArray=null;
			this.animationKey=false;
			this._spriteNum=0;
			this._aniDic=null;
			this._frameIndex=0;
			this._time=0;
			this._interval=0;
			this._preFrameTime=0;
		}

		__class(TileTexSet,'laya.map.TileTexSet');
		var __proto=TileTexSet.prototype;
		/**
		*加入一个动画显示对象到此动画中
		*@param aniName //显示对象的名字
		*@param sprite //显示对象
		*/
		__proto.addAniSprite=function(aniName,sprite){
			if (this._aniDic==null){
				this._aniDic={};
			}
			if (this._spriteNum==0){
				Laya.timer.frameLoop(3,this,this.animate);
				this._preFrameTime=Browser.now();
				this._frameIndex=0;
				this._time=0;
				this._interval=0;
			}
			this._spriteNum++;
			this._aniDic[aniName]=sprite;
			if (this.textureArray && this._frameIndex < this.textureArray.length){
				var tTileTextureSet=this.textureArray[this._frameIndex];
				this.drawTexture(sprite,tTileTextureSet);
			}
		}

		/**
		*把动画画到所有注册的SPRITE上
		*/
		__proto.animate=function(){
			if (this.textureArray && this.textureArray.length > 0 && this.durationTimeArray && this.durationTimeArray.length > 0){
				var tNow=Browser.now();
				this._interval=tNow-this._preFrameTime;
				this._preFrameTime=tNow;
				this._time+=this._interval;
				var tTime=this.durationTimeArray[this._frameIndex];
				if (this._time > tTime){
					this._time-=tTime;
					this._frameIndex++;
					if (this._frameIndex >=this.durationTimeArray.length || this._frameIndex >=this.textureArray.length){
						this._frameIndex=0;
					};
					var tTileTextureSet=this.textureArray[this._frameIndex];
					var tSprite;
					for (var p in this._aniDic){
						tSprite=this._aniDic[p];
						this.drawTexture(tSprite,tTileTextureSet);
					}
				}
			}
		}

		__proto.drawTexture=function(sprite,tileTextSet){
			sprite.graphics.clear();
			sprite.graphics.drawTexture(tileTextSet.texture,tileTextSet.offX,tileTextSet.offY,tileTextSet.texture.width,tileTextSet.texture.height);
		}

		/**
		*移除不需要更新的SPRITE
		*@param _name
		*/
		__proto.removeAniSprite=function(_name){
			if (this._aniDic && this._aniDic[_name]){
				delete this._aniDic[_name];
				this._spriteNum--
				if (this._spriteNum==0){
					Laya.timer.clear(this,this.animate);
				}
			}
		}

		/**
		*显示当前动画的使用情况
		*/
		__proto.showDebugInfo=function(){
			var tInfo=null;
			if (this._spriteNum > 0){
				tInfo="TileTextureSet::gid:"+this.gid.toString()+" 动画数:"+this._spriteNum.toString();
			}
			return tInfo;
		}

		/**
		*清理
		*/
		__proto.clearAll=function(){
			if (this._spriteNum > 0){
				console.log("error::"+this.showDebugInfo());
			}
			this.gid=-1;
			if (this.texture){
				this.texture.destroy();
				this.texture=null;
			}
			this.offX=0;
			this.offY=0;
			this.textureArray=null;
			this.durationTimeArray=null;
			this.animationKey=false;
			this._spriteNum=0;
			this._aniDic=null;
			this._frameIndex=0;
			this._preFrameTime=0;
			this._time=0;
			this._interval=0;
		}

		return TileTexSet;
	})()


	/**
	*地图的每层都会分块渲染处理
	*本类就是地图的块数据
	*@author ...
	*/
	//class laya.map.GridSprite extends laya.display.Sprite
	var GridSprite=(function(_super){
		function GridSprite(){
			this.relativeX=0;
			this.relativeY=0;
			this.isAloneObjectKey=false;
			this.haveAnimationKey=false;
			this.aniSpriteArray=null;
			this.drawImageNum=0;
			this._map=null;
			GridSprite.__super.call(this);
		}

		__class(GridSprite,'laya.map.GridSprite',_super);
		var __proto=GridSprite.prototype;
		/**
		*传入必要的参数，用于裁剪，跟确认此对象类型
		*@param map 把地图的引用传进来，参与一些裁剪计算
		*@param objectKey true:表示当前GridSprite是个活动对象，可以控制，false:地图层的组成块
		*/
		__proto.initData=function(map,objectKey){
			(objectKey===void 0)&& (objectKey=false);
			this._map=map;
			this.isAloneObjectKey=objectKey;
		}

		/**
		*把一个动画对象绑定到当前GridSprite
		*@param sprite 动画的显示对象
		*/
		__proto.addAniSprite=function(sprite){
			if (this.aniSpriteArray==null){
				this.aniSpriteArray=[];
			}
			this.aniSpriteArray.push(sprite);
		}

		/**
		*显示当前GridSprite，并把上面的动画全部显示
		*/
		__proto.show=function(){
			if (!this.visible){
				this.visible=true;
				if (this.aniSpriteArray==null){
					return;
				};
				var tAniSprite;
				for (var i=0;i < this.aniSpriteArray.length;i++){
					tAniSprite=this.aniSpriteArray[i];
					tAniSprite.show();
				}
			}
		}

		/**
		*隐藏当前GridSprite，并把上面绑定的动画全部移除
		*/
		__proto.hide=function(){
			if (this.visible){
				this.visible=false;
				if (this.aniSpriteArray==null){
					return;
				};
				var tAniSprite;
				for (var i=0;i < this.aniSpriteArray.length;i++){
					tAniSprite=this.aniSpriteArray[i];
					tAniSprite.hide();
				}
			}
		}

		/**
		*刷新坐标，当我们自己控制一个GridSprite移动时，需要调用此函数，手动刷新
		*/
		__proto.updatePos=function(){
			if (this.isAloneObjectKey){
				if (this._map){
					this.x=this.relativeX-this._map.viewPortX;
					this.y=this.relativeY-this._map.viewPortY;
				}
				if (this.x < 0 || this.x > Browser.width || this.y < 0 || this.y > Browser.height){
					this.hide();
					}else {
					this.show();
				}
				}else {
				if (this._map){
					this.x=this.relativeX-this._map.viewPortX;
					this.y=this.relativeY-this._map.viewPortY;
				}
			}
		}

		/**
		*重置当前对象的所有属性
		*/
		__proto.clearAll=function(){
			if (this._map){
				this._map=null;
			}
			this.visible=false;
			if (this.aniSpriteArray==null){
				return;
			};
			var tAniSprite;
			for (var i=0;i < this.aniSpriteArray.length;i++){
				tAniSprite=this.aniSpriteArray[i];
				tAniSprite.clearAll();
			}
			this.destroy();
			this.relativeX=0;
			this.relativeY=0;
			this.haveAnimationKey=false;
			this.aniSpriteArray=null;
			this.drawImageNum=0;
		}

		return GridSprite;
	})(Sprite)


	/**
	*地图支持多层渲染（例如，地表层，植被层，建筑层等）
	*本类就是层级类
	*@author ...
	*/
	//class laya.map.MapLayer extends laya.display.Sprite
	var MapLayer=(function(_super){
		function MapLayer(){
			this._map=null;
			this._mapData=null;
			this._tileWidthHalf=0;
			this._tileHeightHalf=0;
			this._mapWidthHalf=0;
			this._mapHeightHalf=0;
			this._gridSpriteArray=[];
			this._objDic=null;
			this.layerName=null;
			MapLayer.__super.call(this);
			this._tempMapPos=new Point();
		}

		__class(MapLayer,'laya.map.MapLayer',_super);
		var __proto=MapLayer.prototype;
		/**
		*解析LAYER数据，以及初始化一些数据
		*@param layerData 地图数据中，layer数据的引用
		*@param map 地图的引用
		*/
		__proto.init=function(layerData,map){
			this._map=map;
			this._mapData=layerData.data;
			var tHeight=layerData.height;
			var tWidth=layerData.width;
			var tTileW=map.TileWidth;
			var tTileH=map.TileHeight;
			this.layerName=layerData.name;
			this.alpha=layerData.opacity;
			this._tileWidthHalf=tTileW / 2;
			this._tileHeightHalf=tTileH / 2;
			this._mapWidthHalf=this._map.width / 2-this._tileWidthHalf;
			this._mapHeightHalf=this._map.height / 2;
			switch (layerData.type){
				case "tilelayer":
					break ;
				case "objectgroup":;
					var tObjectGid=0;
					var tArray=layerData.objects;
					if (tArray.length > 0){
						this._objDic={};
					};
					var tObjectData;
					for (var i=0;i < tArray.length;i++){
						tObjectData=tArray[i];
						if (tObjectData.visible==true){
							var tSprite=map.getSprite(tObjectData.gid);
							if (tSprite !=null){
								tSprite.x=tSprite.relativeX=tObjectData.x;
								tSprite.y=tSprite.relativeY=tObjectData.y-map.TileHeight;
								this.addChild(tSprite);
								this._gridSpriteArray.push(tSprite);
								this._objDic[tObjectData.name]=tSprite;
							}
						}
					}
					break ;
				}
		}

		/**
		*通过名字获取控制对象，如果找不到返回为null
		*@param objName 所要获取对象的名字
		*@return
		*/
		__proto.getObjectByName=function(objName){
			if (this._objDic){
				return this._objDic[objName];
			}
			return null;
		}

		/**
		*得到指定格子的数据
		*@param tileX 格子坐标X
		*@param tileY 格子坐标Y
		*@return
		*/
		__proto.getTileData=function(tileX,tileY){
			if (tileY >=0 && tileY < this._map.MapHeight && tileX >=0 && tileX < this._map.MapWidth){
				var tIndex=tileY *this._map.MapWidth+tileX;
				var tMapData=this._mapData;
				if (tMapData !=null && tIndex < tMapData.length){
					return tMapData[tIndex];
				}
			}
			return 0;
		}

		/**
		*通过地图坐标得到屏幕坐标
		*@param tileX 格子坐标X
		*@param tileY 格子坐标Y
		*@param screenPos 把计算好的屏幕坐标数据，放到此对象中
		*/
		__proto.getScreenPositionByTilePos=function(tileX,tileY,screenPos){
			if (screenPos){
				switch (this._map.orientation){
					case /*laya.map.TiledMap.ORIENTATION_ISOMETRIC*/"isometric":
						screenPos.x=this._map.width / 2-(tileY-tileX)*this._tileWidthHalf-this._map.viewPortX;
						screenPos.y=(tileY+tileX)*this._tileHeightHalf-this._map.viewPortY;
						break ;
					case /*laya.map.TiledMap.ORIENTATION_ORTHOGONAL*/"orthogonal":
						screenPos.x=tileX *this._map.TileWidth-this._map.viewPortX;
						screenPos.y=tileY *this._map.TileHeight-this._map.viewPortY;
						break ;
					case /*laya.map.TiledMap.ORIENTATION_HEXAGONAL*/"hexagonal":
						tileX=Math.floor(tileX);
						tileY=Math.floor(tileY);
						var tTileHeight=this._map.TileHeight *2 / 3;
						screenPos.x=(tileX *this._map.TileWidth+tileY % 2 *this._tileWidthHalf)% this._map.gridWidth-this._map.viewPortX;
						screenPos.y=(tileY *tTileHeight)% this._map.gridHeight-this._map.viewPortY;
						break ;
					}
			}
		}

		/**
		*通过屏幕坐标来获取选中格子的数据
		*@param screenX 屏幕坐标x
		*@param screenY 屏幕坐标y
		*@return
		*/
		__proto.getTileDataByScreenPos=function(screenX,screenY){
			var tData=0;
			if (this.getTilePositionByScreenPos(screenX,screenY,this._tempMapPos)){
				tData=this.getTileData(Math.floor(this._tempMapPos.x),Math.floor(this._tempMapPos.y));
			}
			return tData;
		}

		/**
		*通过屏幕坐标来获取选中格子的索引
		*@param screenX 屏幕坐标x
		*@param screenY 屏幕坐标y
		*@param result 把计算好的格子坐标，放到此对象中
		*@return
		*/
		__proto.getTilePositionByScreenPos=function(screenX,screenY,result){
			screenX=screenX+this._map.viewPortX;
			screenY=screenY+this._map.viewPortY;
			var tTileW=this._map.TileWidth;
			var tTileH=this._map.TileHeight;
			var tV=0;
			var tU=0;
			switch (this._map.orientation){
				case /*laya.map.TiledMap.ORIENTATION_ISOMETRIC*/"isometric":;
					var tDirX=screenX-this._map.width / 2;
					var tDirY=screenY;
					tV=-(tDirX / tTileW-tDirY / tTileH);
					tU=tDirX / tTileW+tDirY / tTileH;
					if (result){
						result.x=tU;
						result.y=tV;
					}
					return true;
					break ;
				case /*laya.map.TiledMap.ORIENTATION_ORTHOGONAL*/"orthogonal":
					tU=screenX / this._map.TileWidth;
					tV=screenY / this._map.TileHeight;
					if (result){
						result.x=tU;
						result.y=tV;
					}
					return true;
					break ;
				case /*laya.map.TiledMap.ORIENTATION_HEXAGONAL*/"hexagonal":;
					var tTileHeight=this._map.TileHeight *2 / 3;
					tV=screenY / tTileHeight;
					tU=(screenX-tV % 2 *this._tileWidthHalf)/ this._map.TileWidth;
					if (result){
						result.x=tU;
						result.y=tV;
					}
					break ;
				}
			return false;
		}

		/**
		*得到一个GridSprite
		*@param gridX 当前Grid的X轴索引
		*@param gridY 当前Grid的Y轴索引
		*@return 一个GridSprite对象
		*/
		__proto.getDrawSprite=function(gridX,gridY){
			var tSprite=new GridSprite();
			tSprite.relativeX=gridX *this._map.gridWidth;
			tSprite.relativeY=gridY *this._map.gridHeight;
			tSprite.initData(this._map);
			this._gridSpriteArray.push(tSprite);
			return tSprite;
		}

		/**
		*更新此层中块的坐标
		*手动刷新的目的是，保持层级的宽和高保持最小，加快渲染
		*/
		__proto.updateGridPos=function(){
			var tSprite;
			for (var i=0;i < this._gridSpriteArray.length;i++){
				tSprite=this._gridSpriteArray[i];
				if ((tSprite.visible || tSprite.isAloneObjectKey)&& tSprite.drawImageNum > 0){
					tSprite.updatePos();
				}
			}
		}

		/**
		*@private
		*把tile画到指定的显示对象上
		*@param gridSprite 被指定显示的目标
		*@param tileX 格子的X轴坐标
		*@param tileY 格子的Y轴坐标
		*@return
		*/
		__proto.drawTileTexture=function(gridSprite,tileX,tileY){
			if (tileY >=0 && tileY < this._map.MapHeight && tileX >=0 && tileX < this._map.MapWidth){
				var tIndex=tileY *this._map.MapWidth+tileX;
				var tMapData=this._mapData;
				if (tMapData !=null && tIndex < tMapData.length){
					if (tMapData[tIndex] !=0){
						var tTileTexSet=this._map.getTexture(tMapData[tIndex]);
						if (tTileTexSet){
							var tX=0;
							var tY=0;
							var tTexture=tTileTexSet.texture;
							switch (this._map.orientation){
								case /*laya.map.TiledMap.ORIENTATION_ORTHOGONAL*/"orthogonal":
									tX=tileX *this._map.TileWidth % this._map.gridWidth;
									tY=tileY *this._map.TileHeight % this._map.gridHeight;
									break ;
								case /*laya.map.TiledMap.ORIENTATION_ISOMETRIC*/"isometric":
									tX=(this._mapWidthHalf+(tileX-tileY)*this._tileWidthHalf)% this._map.gridWidth;
									tY=((tileX+tileY)*this._tileHeightHalf)% this._map.gridHeight;
									break ;
								case /*laya.map.TiledMap.ORIENTATION_HEXAGONAL*/"hexagonal":;
									var tTileHeight=this._map.TileHeight *2 / 3;
									tX=(tileX *this._map.TileWidth+tileY % 2 *this._tileWidthHalf)% this._map.gridWidth;
									tY=(tileY *tTileHeight)% this._map.gridHeight;
									break ;
								}
							if (tTileTexSet.animationKey){
								var tAnimationSprite=new TileAniSprite();
								tAnimationSprite.x=tX;
								tAnimationSprite.y=tY;
								tAnimationSprite.setTileTextureSet(tIndex.toString(),tTileTexSet);
								gridSprite.addAniSprite(tAnimationSprite);
								gridSprite.addChild(tAnimationSprite);
								gridSprite.haveAnimationKey=true;
								}else {
								gridSprite.graphics.drawTexture(tTileTexSet.texture,tX+tTileTexSet.offX,tY+tTileTexSet.offY,tTexture.width,tTexture.height);
							}
							return true;
						}
					}
				}
			}
			return false;
		}

		/**
		*@private
		*清理当前对象
		*/
		__proto.clearAll=function(){
			this._map=null;
			this._mapData=null;
			this._tileWidthHalf=0;
			this._tileHeightHalf=0;
			this._mapWidthHalf=0;
			this._mapHeightHalf=0;
			this.layerName=null;
			var i=0;
			if (this._objDic){
				for (var p in this._objDic){
					delete this._objDic[p];
				}
				this._objDic=null;
			};
			var tGridSprite;
			for (i=0;i < this._gridSpriteArray.length;i++){
				tGridSprite=this._gridSpriteArray[i];
				tGridSprite.clearAll();
			}
			this._tempMapPos=null;
		}

		return MapLayer;
	})(Sprite)


	/**
	*TildMap的动画显示对象（一个动画（TileTexSet），可以绑定多个动画显示对象（TileAniSprite））
	*@author ...
	*/
	//class laya.map.TileAniSprite extends laya.display.Sprite
	var TileAniSprite=(function(_super){
		function TileAniSprite(){
			this._tileTextureSet=null;
			this._aniName=null;
			TileAniSprite.__super.call(this);
		}

		__class(TileAniSprite,'laya.map.TileAniSprite',_super);
		var __proto=TileAniSprite.prototype;
		/**
		*确定当前显示对象的名称以及属于哪个动画
		*@param aniName 当前动画显示对象的名字，名字唯一
		*@param tileTextureSet 当前显示对象属于哪个动画（一个动画，可以绑定多个同类显示对象）
		*/
		__proto.setTileTextureSet=function(aniName,tileTextureSet){
			this._aniName=aniName;
			this._tileTextureSet=tileTextureSet;
			tileTextureSet.addAniSprite(this._aniName,this);
		}

		/**
		*把当前动画加入到对应的动画刷新列表中
		*/
		__proto.show=function(){
			this._tileTextureSet.addAniSprite(this._aniName,this);
		}

		/**
		*把当前动画从对应的动画刷新列表中移除
		*/
		__proto.hide=function(){
			this._tileTextureSet.removeAniSprite(this._aniName);
		}

		/**
		*清理
		*/
		__proto.clearAll=function(){
			this._tileTextureSet.removeAniSprite(this._aniName);
			this.destroy();
			this._tileTextureSet=null;
			this._aniName=null;
		}

		return TileAniSprite;
	})(Sprite)


	Laya.__init([TiledMap]);
})(window,document,Laya);
