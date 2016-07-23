package laya.map {
	import laya.display.Sprite;
	import laya.map.GridSprite;
	import laya.map.TileAniSprite;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.net.Loader;
	import laya.renders.Render;
	import laya.resource.Texture;
	import laya.utils.Handler;
	import laya.map.MapLayer;
	
	/**
	 * tiledMap是整个地图的核心
	 * 地图以层级来划分地图（例如：地表层，植被层，建筑层）
	 * 每层又以分块（GridSprite)来处理显示对象，只显示在视口区域的区
	 * 每块又包括N*N个格子（tile)
	 * 格子类型又分为动画格子跟图片格子两种
	 * @author ...
	 */
	public class TiledMap {
		//地图支持的类型(目前支持四边形地图，菱形地图，六边形地图)
		/**四边形地图*/
		public static const ORIENTATION_ORTHOGONAL:String = "orthogonal";
		/**菱形地图*/
		public static const ORIENTATION_ISOMETRIC:String = "isometric";
		/**45度交错地图*/
		public static const ORIENTATION_STAGGERED:String = "staggered";
		/**六边形地图*/
		public static const ORIENTATION_HEXAGONAL:String = "hexagonal";
		//地图格子（tile）的渲染顺序
		/**地图格子从左上角开始渲染*/
		public static const RENDERORDER_RIGHTDOWN:String = "right-down";
		/**地图格子从左下角开始渲染*/
		public static const RENDERORDER_RIGHTUP:String = "right-up";
		/**地图格子从右上角开始渲染*/
		public static const RENDERORDER_LEFTDOWN:String = "left-down";
		/**地图格子右下角开始渲染*/
		public static const RENDERORDER_LEFTUP:String = "left-up";
		
		//json数据
		private var _jsonData:*;
		//存放地图中用到的所有子纹理数据
		private var _tileTexSetArr:Array = [];
		//主纹理数据，主要在释放纹理资源时使用
		private var _texArray:Array = [];
		//地图信息中的一些基本数据
		private var _x:Number = 0;//地图的坐标
		private var _y:Number = 0;
		//_width = _mapTileW * _mapW
		//_height = _mapTileH * _mapH
		private var _width:int = 0;			//地图的宽度
		private var _height:int = 0;		//地图的高度
		private var _mapW:int = 0;			//地图的横向格子数
		private var _mapH:int = 0;			//地图的竖向格子数
		private var _mapTileW:int = 0;		//tile的宽度
		private var _mapTileH:int = 0;		//tile的高度
		
		//用来存放地图的视口信息
		private var _rect:Rectangle = new Rectangle();
		//用来存放地图的视口扩充区域
		private var _paddingRect:Rectangle = new Rectangle();
		//地图的显示对象
		private var _mapSprite:Sprite = null;		//地图的显示对象
		private var _layerArray:Array = [];			//这里保存所有的MapLayer对象
		private var _gridArray:Array = [];			//保存所有的块数据
		//地图块相关的
		private var _showGridKey:Boolean = false;	//是否显示块边界线（用来调试用）
		private var _totalGridNum:int = 0;			//一层中的GridSprite的总数
		private var _gridW:int = 0;					//地图的横向块数
		private var _gridH:int = 0;					//地图的坚向块数
		private var _gridWidth:Number = 450;		//块的默认宽度
		private var _gridHeight:Number = 450;		//块的默认高度
		
		private var _jsonLoader:Loader = null;		//用来加载JSON文件用的LOADER
		private var _loader:Loader = null;			//用来加载纹理数据用的LOADER
		private var _tileSetArray:Array = [];		//用来存放还需要哪些儿纹理等待加载
		private var _currTileSet:TileSet = null;	//正在加载的纹理需要的数据源
		private var _completeHandler:Handler = null;//地图创建完成的回调函数
		//用来裁剪块的区域（有当前视口和上次视口显示多少的块，就能哪些儿块需要显示或隐藏
		private var _mapRect:GRect = new GRect();		//当前视口显示的块范围
		private var _mapLastRect:GRect = new GRect();	//上次视口显示的块范围
		private var _index:int = 0;
		private var _animationDic:Object = { };		//需要创建的动画数据
		private var _properties:*;					//当前地图的自定义属性
		private var _tileProperties:Object = { };	//图块属性
		//默认的地图类型（具体要看JSON文件）
		private var _orientation:String = "orthogonal";
		//默认的tile渲染顺序（具体要看JSON文件）
		private var _renderOrder:String = "right-down";
		//调试用的颜色组合
		private var _colorArray:Array = ["FF", "00", "33", "66"];
		//缩放相关的操作
		private var _scale:Number = 1;
		private var _pivotScaleX:Number = 0.5;
		private var _pivotScaleY:Number = 0.5;
		private var _centerX:Number = 0;
		private var _centerY:Number = 0;
		private var _viewPortX:Number = 0;
		private var _viewPortY:Number = 0;
		private var _viewPortWidth:Number = 0;
		private var _viewPortHeight:Number = 0;
		//是否开启线性取样
		private var _enableLinear:Boolean = true;
		//资源的相对路径
		private var _resPath:String;
		private var _pathArray:Array;
		//把地图限制在显示区域
		private var _limitRange:Boolean = false;
		
		public function TiledMap() {
		
		}
		
		/**
		 * 创建地图
		 * @param	mapName 		JSON文件名字
		 * @param	viewRect 		视口区域
		 * @param	completeHandler 地图创建完成的回调函数
		 * @param	viewRectPadding 视口扩充区域，把视口区域上、下、左、右扩充一下，防止视口移动时的穿帮
		 * @param	gridSize 		grid大小
		 * @param	enableLinear 	是否开启线性取样（为false时，可以解决地图黑线的问题，但画质会锐化）
		 * @param	limitRange		把地图限制在显示区域
		 */
		public function createMap(mapName:String, viewRect:Rectangle, completeHandler:Handler, viewRectPadding:Rectangle = null, gridSize:Point = null, enableLinear:Boolean = true, limitRange:Boolean = false):void {
			_enableLinear = enableLinear;
			_limitRange = limitRange;
			_rect.x = viewRect.x;
			_rect.y = viewRect.y;
			_rect.width = viewRect.width;
			_rect.height = viewRect.height;
			_viewPortWidth = viewRect.width / _scale;
			_viewPortHeight = viewRect.height / _scale;
			_completeHandler = completeHandler;
			if (viewRectPadding) {
				_paddingRect.copyFrom(viewRectPadding);
			} else {
				_paddingRect.setTo(0, 0, 0, 0);
			}
			if (gridSize) {
				_gridWidth = gridSize.x;
				_gridHeight = gridSize.y;
			}
			var tIndex:int = mapName.lastIndexOf("/");
			if (tIndex > -1)
			{
				_resPath = mapName.substr(0, tIndex);
				_pathArray = _resPath.split("/");
			}else {
				_resPath = "";
				_pathArray = [];
			}
			
			_jsonLoader = new Loader();
			_jsonLoader.once("complete", this, onJsonComplete);
			_jsonLoader.load(mapName, Loader.JSON, false);
		}
		
		/**
		 * json文件读取成功后，解析里面的纹理数据，进行加载
		 * @param	e JSON数据
		 */
		private function onJsonComplete(e:*):void {
			_mapSprite = new Sprite();
			Laya.stage.addChild(_mapSprite);
			var tJsonData:* = _jsonData = e;
			
			_properties = tJsonData.properties;
			_orientation = tJsonData.orientation;
			_renderOrder = tJsonData.renderorder;
			_mapW = tJsonData.width;
			_mapH = tJsonData.height;
			
			_mapTileW = tJsonData.tilewidth;
			_mapTileH = tJsonData.tileheight;
			
			_width = _mapTileW * _mapW;
			_height = _mapTileH * _mapH;
			
			_mapLastRect.top = _mapLastRect.bottom = _mapLastRect.left = _mapLastRect.right = -1;
			
			var tArray:Array = tJsonData.tilesets;
			var tileset:*;
			var tTileSet:TileSet;
			var i:int = 0;
			for (i = 0; i < tArray.length; i++) {
				tileset = tArray[i];
				tTileSet = new TileSet();
				tTileSet.init(tileset);
				_tileProperties[i] = tTileSet.tileproperties;
				_tileSetArray.push(tTileSet);
				//动画数据
				var tTiles:* = tileset.tiles;
				if (tTiles) {
					for (var p:* in tTiles) {
						var tAnimation:Array = tTiles[p].animation;
						if (tAnimation) {
							var tAniData:TileMapAniData = new TileMapAniData();
							_animationDic[p] = tAniData;
							for (var j:int = 0; j < tAnimation.length; j++) {
								var tAnimationItem:Object = tAnimation[j];
								tAniData.mAniIdArray.push(tAnimationItem.tileid);
								tAniData.mDurationTimeArray.push(tAnimationItem.duration);
							}
						}
					}
				}
			}
			
			_tileTexSetArr.push(null);
			if (_tileSetArray.length > 0) {
				tTileSet = _currTileSet = _tileSetArray.shift();
				_loader = new Loader();
				_loader.once("complete", this, onTextureComplete);
				var tPath:String = mergePath(_resPath, tTileSet.image);
				_loader.load(tPath, Loader.IMAGE, false);
			}
		}
		
		/**
		 * 合并路径
		 * @param	resPath
		 * @param	relativePath
		 * @return
		 */
		private function mergePath(resPath:String,relativePath:String):String
		{
			var tResultPath:String = "";
			var tImageArray:Array = relativePath.split("/");
			var tParentPathNum:int = 0;
			var i:int = 0;
			for (i = tImageArray.length - 1; i >= 0; i--)
			{
				if (tImageArray[i] == "..")
				{
					tParentPathNum++;
				}
			}
			if (tParentPathNum == 0)
			{
				if (_pathArray.length > 0)
				{
					tResultPath = resPath + "/" + relativePath;
				}else {
					tResultPath = relativePath;
				}
				
				return tResultPath;
			}
			var tSrcNum:int = _pathArray.length - tParentPathNum;
			if (tSrcNum < 0)
			{
				trace("[error]path does not exist");
			}
			for (i = 0; i < tSrcNum; i++)
			{
				if (i == 0)
				{
					tResultPath += _pathArray[i];
				}else {
					tResultPath = tResultPath + "/" + _pathArray[i];
				}
			}
			for (i = tParentPathNum; i < tImageArray.length; i++)
			{
				tResultPath = tResultPath + "/" + tImageArray[i];
			}
			return tResultPath;
		}
		
		/**
		 * 纹理加载完成，如果所有的纹理加载，开始初始化地图
		 * @param	e 纹理数据
		 */
		private function onTextureComplete(e:*):void {
			var json:* = _jsonData;
			var tTexture:Texture = e;
			if (Render.isWebGL && (!_enableLinear))
			{
				tTexture.bitmap.minFifter = 0x2600;
				tTexture.bitmap.magFifter = 0x2600;
				tTexture.bitmap.enableMerageInAtlas = false;
			}
			_texArray.push(tTexture);
			var tSubTexture:Texture = null;
			
			//var tVersion:int = json.viersion;
			var tTileSet:TileSet = _currTileSet;
			var tTileTextureW:int = tTileSet.tilewidth;
			var tTileTextureH:int = tTileSet.tileheight;
			var tImageWidth:int = tTileSet.imagewidth;
			var tImageHeight:int = tTileSet.imageheight;
			var tFirstgid:int = tTileSet.firstgid;
			
			var tTileWNum:int = Math.floor((tImageWidth - tTileSet.margin - tTileTextureW) / (tTileTextureW + tTileSet.spacing)) + 1;
			var tTileHNum:int = Math.floor((tImageHeight - tTileSet.margin - tTileTextureH) / (tTileTextureH + tTileSet.spacing)) + 1;
			
			var tTileTexSet:TileTexSet = null;
			for (var i:int = 0; i < tTileHNum; i++) {
				for (var j:int = 0; j < tTileWNum; j++) {
					tTileTexSet = new TileTexSet();
					tTileTexSet.offX = tTileSet.titleoffsetX;
					tTileTexSet.offY = tTileSet.titleoffsetY - (tTileTextureH - _mapTileH);
					tTileTexSet.texture = Texture.create(tTexture, tTileSet.margin + (tTileTextureW + tTileSet.spacing) * j, tTileSet.margin + (tTileTextureH + tTileSet.spacing) * i, tTileTextureW, tTileTextureH);
					_tileTexSetArr.push(tTileTexSet);
					tTileTexSet.gid = _tileTexSetArr.length;
				}
			}
			
			if (_tileSetArray.length > 0) {
				tTileSet = _currTileSet = _tileSetArray.shift();
				_loader.once("complete", this, onTextureComplete);
				var tPath:String = mergePath(_resPath, tTileSet.image);
				_loader.load(tPath, Loader.IMAGE, false);
			} else {
				_currTileSet = null;
				initMap();
			}
		}
		
		/**
		 * 初始化地图
		 */
		private function initMap():void {
			var i:int,n:int;
			for (var p:* in _animationDic) {
				var tTileTexSet:TileTexSet = getTexture(parseInt(p) + 1);
				var tAniData:TileMapAniData = _animationDic[p];
				if (tAniData.mAniIdArray.length > 0) {
					tTileTexSet.textureArray = [];
					tTileTexSet.durationTimeArray = tAniData.mDurationTimeArray;
					tTileTexSet.isAnimation = true;
					tTileTexSet.animationTotalTime = 0;
					for (i = 0, n = tTileTexSet.durationTimeArray.length; i < n; i++)
					{
						tTileTexSet.animationTotalTime += tTileTexSet.durationTimeArray[i];
					}
					for (i = 0,n = tAniData.mAniIdArray.length; i < n; i++) {
						var tTexture:TileTexSet = getTexture(tAniData.mAniIdArray[i] + 1);
						tTileTexSet.textureArray.push(tTexture);
					}
				}
			}
			
			_gridWidth = Math.floor(_gridWidth / _mapTileW) * _mapTileW;
			_gridHeight = Math.floor(_gridHeight / _mapTileH) * _mapTileH;
			if (_gridWidth < _mapTileW) {
				_gridWidth = _mapTileW;
			}
			if (_gridWidth < _mapTileH) {
				_gridWidth = _mapTileH;
			}
			
			_gridW = Math.ceil(_width / _gridWidth);
			_gridH = Math.ceil(_height / _gridHeight);
			_totalGridNum = _gridW * _gridH;
			for (i = 0; i < _gridH; i++) {
				var tGridArray:Array = [];
				_gridArray.push(tGridArray);
				for (var j:int = 0; j < _gridW; j++) {
					tGridArray.push(null);
				}
			}
			
			var tLayerArray:Array = _jsonData.layers;
			//创建地图层级
			for (var tLayerLoop:int = 0; tLayerLoop < tLayerArray.length; tLayerLoop++) {
				var tLayerData:* = tLayerArray[tLayerLoop];
				if (tLayerData.visible == true)//如果不显示，那么也没必要创建
				{
					var tMapLayer:MapLayer = new MapLayer();
					tMapLayer.init(tLayerData, this);
					_mapSprite.addChild(tMapLayer);
					_layerArray.push(tMapLayer);
				}
			}
			moveViewPort(this._rect.x, this._rect.y);
			if (_completeHandler != null) {
				_completeHandler.run();
			}
			//这里应该发送消息，通知上层，地图创建完成
		}
		
		/**
		 * 得到一块指定的地图纹理
		 * @param	index 纹理的索引值，默认从1开始
		 * @return
		 */
		public function getTexture(index:int):TileTexSet {
			if (index < _tileTexSetArr.length) {
				return _tileTexSetArr[index];
			}
			return null;
		}
		
		/**
		 * 得到地图的自定义属性
		 * @param	name		属性名称
		 * @return
		 */
		public function getMapProperties(name:String):*
		{
			if (_properties)
			{
				return _properties[name];
			}
			return null;
		}
		
		/**
		 * 得到tile自定义属性
		 * @param	index		地图块索引
		 * @param	id			具体的TileSetID
		 * @param	name		属性名称
		 * @return
		 */
		public function getTileProperties(index:int,id:int, name:String):*
		{
			if (_tileProperties[index] && _tileProperties[index][id])
			{
				return _tileProperties[index][id][name];
			}
			return null;
		}
		
		/**
		 * 通过纹理索引，生成一个可控制物件
		 * @param	index 纹理的索引值，默认从1开始
		 * @return
		 */
		public function getSprite(index:int,width:Number,height:Number):GridSprite {
			if (0 < _tileTexSetArr.length) {
				var tGridSprite:GridSprite = new GridSprite();
				tGridSprite.initData(this, true);
				var tTileTexSet:TileTexSet = _tileTexSetArr[index];
				if (tTileTexSet != null && tTileTexSet.texture != null) {
					if (tTileTexSet.isAnimation) {
						var tAnimationSprite:TileAniSprite = new TileAniSprite();
						_index++;
						tAnimationSprite.setTileTextureSet(_index.toString(), tTileTexSet);
						tGridSprite.addAniSprite(tAnimationSprite);
						tGridSprite.addChild(tAnimationSprite);
					} else {
						tGridSprite.graphics.drawTexture(tTileTexSet.texture, 0, 0, width, height);
					}
					tGridSprite.drawImageNum++;
				}
				return tGridSprite;
			}
			return null;
		}
		
		/**
		 * 设置视口的缩放中心点（例如：scaleX= scaleY= 0.5,就是以视口中心缩放）
		 * @param	scaleX
		 * @param	scaleY
		 */
		public function setViewPortPivotByScale(scaleX:Number, scaleY:Number):void
		{
			_pivotScaleX = scaleX;
			_pivotScaleY = scaleY;
		}
		
		/**
		 * 设置地图缩放
		 * @param	scale
		 */
		public function set scale(scale:Number):void
		{
			if (scale <= 0) return;
			_scale = scale;
			_viewPortWidth = _rect.width / scale;
			_viewPortHeight = _rect.height / scale;
			_mapSprite.scale(_scale,_scale);
			updateViewPort();
		}
		
		/**
		 * 得到当前地图的缩放
		 */
		public function get scale():Number
		{
			return _scale;
		}
		
		/**
		 * 移动视口
		 * @param	moveX 视口的坐标x
		 * @param	moveY 视口的坐标y
		 */
		public function moveViewPort(moveX:Number, moveY:Number):void {
			_x = -moveX;
			_y = -moveY;
			_rect.x = moveX;
			_rect.y = moveY;
			updateViewPort();
		}
		
		/**
		 * 改变视口大小
		 * @param	moveX	视口的坐标x
		 * @param	moveY	视口的坐标y
		 * @param	width	视口的宽
		 * @param	height	视口的高
		 */
		public function changeViewPort(moveX:Number, moveY:Number, width:Number, height:Number):void {
			_x = -moveX;
			_y = -moveY;
			_rect.x = moveX;
			_rect.y = moveY;
			_rect.width = width;
			_rect.height = height;
			_viewPortWidth = width / _scale;
			_viewPortHeight = height / _scale;
			updateViewPort();
		}
		
		/**
		 * 在锚点的基础上计算，通过宽和高，重新计算视口
		 * @param	width		新视口宽
		 * @param	height		新视口高
		 * @param	rect		返回的结果
		 * @return
		 */
		public function changeViewPortBySize(width:Number, height:Number,rect:Rectangle = null):Rectangle
		{
			if (rect == null)
			{
				rect = new Rectangle();
			}
			_centerX = _rect.x + _rect.width * _pivotScaleX;
			_centerY = _rect.y + _rect.height * _pivotScaleY;
			rect.x = _centerX - width * _pivotScaleX;
			rect.y = _centerY - height * _pivotScaleY;
			rect.width = width;
			rect.height = height;
			changeViewPort(rect.x, rect.y, rect.width, rect.height);
			return rect;
		}
		
		/**
		 * 刷新视口
		 */
		private function updateViewPort():void {
			//_rect.x和rect.y是内部坐标，会自动叠加缩放
			_centerX = _rect.x + _rect.width * _pivotScaleX;
			_centerY = _rect.y + _rect.height * _pivotScaleY;
			_viewPortX = _centerX - _rect.width * _pivotScaleX/ _scale;
			_viewPortY = _centerY - _rect.height * _pivotScaleY / _scale;
			if (_limitRange)
			{
				var tRight:Number = _viewPortX + _viewPortWidth;
				if (tRight > _width)
				{
					_viewPortX = _width - _viewPortWidth;
				}
				var tBottom:Number = _viewPortY + _viewPortHeight;
				if (tBottom > _height)
				{
					_viewPortY = _height - _viewPortHeight;
				}
				if (_viewPortX < 0)
				{
					_viewPortX = 0;
				}
				if (_viewPortY < 0)
				{
					_viewPortY = 0;
				}
			}
			var tPaddingRect:Rectangle = _paddingRect;
			_mapRect.top = Math.floor((_viewPortY - tPaddingRect.y) / _gridHeight);
			_mapRect.bottom = Math.floor((_viewPortY + _viewPortHeight + tPaddingRect.height + tPaddingRect.y) / _gridHeight);
			_mapRect.left = Math.floor((_viewPortX - tPaddingRect.x) / _gridWidth);
			_mapRect.right = Math.floor((_viewPortX + _viewPortWidth + tPaddingRect.width + tPaddingRect.x) / _gridWidth);
			clipViewPort();
			_mapLastRect.top = _mapRect.top;
			_mapLastRect.bottom = _mapRect.bottom;
			_mapLastRect.left = _mapRect.left;
			_mapLastRect.right = _mapRect.right;
			var tMapLayer:MapLayer;
			for (var i:int = 0; i < this._layerArray.length; i++) {
				tMapLayer = this._layerArray[i];
				tMapLayer.updateGridPos();
			}
		}
		
		/**
		 * GRID裁剪
		 */
		private function clipViewPort():void {
			var tSpriteNum:int = 0;
			var tSprite:Sprite;
			var tIndex:int = 0;
			var tSub:int = 0;
			var tAdd:int = 0;
			var i:int, j:int;
			if (_mapRect.left > _mapLastRect.left) {
				//裁剪
				tSub = _mapRect.left - _mapLastRect.left;
				if (tSub > 0) {
					for (j = _mapLastRect.left; j < _mapLastRect.left + tSub; j++) {
						for (i = _mapLastRect.top; i <= _mapLastRect.bottom; i++) {
							hideGrid(j, i);
						}
					}
				}
			} else {
				//增加
				tAdd = _mapLastRect.left - _mapRect.left;
				if (tAdd > 0) {
					for (j = _mapRect.left; j < _mapRect.left + tAdd; j++) {
						for (i = _mapRect.top; i <= _mapRect.bottom; i++) {
							showGrid(j, i);
						}
					}
				}
			}
			if (_mapRect.right > _mapLastRect.right) {
				//增加
				tAdd = _mapRect.right - _mapLastRect.right;
				if (tAdd > 0) {
					for (j = _mapLastRect.right + 1; j <= _mapLastRect.right + tAdd; j++) {
						for (i = _mapRect.top; i <= _mapRect.bottom; i++) {
							showGrid(j, i);
						}
					}
				}
			} else {
				//裁剪
				tSub = _mapLastRect.right - _mapRect.right
				if (tSub > 0) {
					for (j = _mapRect.right + 1; j <= _mapRect.right + tSub; j++) {
						for (i = _mapLastRect.top; i <= _mapLastRect.bottom; i++) {
							hideGrid(j, i);
						}
					}
				}
			}
			if (_mapRect.top > _mapLastRect.top) {
				//裁剪
				tSub = _mapRect.top - _mapLastRect.top;
				if (tSub > 0) {
					for (i = _mapLastRect.top; i < _mapLastRect.top + tSub; i++) {
						for (j = _mapLastRect.left; j <= _mapLastRect.right; j++) {
							hideGrid(j, i);
						}
					}
				}
				
			} else {
				//增加
				tAdd = _mapLastRect.top - _mapRect.top;
				if (tAdd > 0) {
					for (i = _mapRect.top; i < _mapRect.top + tAdd; i++) {
						for (j = _mapRect.left; j <= _mapRect.right; j++) {
							showGrid(j, i);
						}
					}
				}
				
			}
			if (_mapRect.bottom > _mapLastRect.bottom) {
				//增加
				tAdd = _mapRect.bottom - _mapLastRect.bottom;
				if (tAdd > 0) {
					for (i = _mapLastRect.bottom + 1; i <= _mapLastRect.bottom + tAdd; i++) {
						for (j = _mapRect.left; j <= _mapRect.right; j++) {
							showGrid(j, i);
						}
					}
				}
			} else {
				//裁剪
				tSub = _mapLastRect.bottom - _mapRect.bottom
				if (tSub > 0) {
					for (i = _mapRect.bottom + 1; i <= _mapRect.bottom + tSub; i++) {
						for (j = _mapLastRect.left; j <= _mapLastRect.right; j++) {
							hideGrid(j, i);
						}
					}
				}
			}
		}
		
		/**
		 * 显示指定的GRID
		 * @param	gridX
		 * @param	gridY
		 */
		private function showGrid(gridX:int, gridY:int):void {
			if (gridX < 0 || gridX >= _gridW || gridY < 0 || gridY >= _gridH) {
				return;
			}
			var i:int, j:int;
			var tGridSprite:GridSprite
			var tTempArray:Array = _gridArray[gridY][gridX];
			if (tTempArray == null) {
				tTempArray = _gridArray[gridY][gridX] = [];
				
				var tLeft:int = 0;
				var tRight:int = 0;
				var tTop:int = 0;
				var tBottom:int = 0;
				
				var tGridWidth:int = _gridWidth
				var tGridHeight:int = _gridHeight;
				switch (orientation) {
				case TiledMap.ORIENTATION_ISOMETRIC://45度角
					tLeft = Math.floor(gridX * tGridWidth);
					tRight = Math.floor(gridX * tGridWidth + tGridWidth);
					tTop = Math.floor(gridY * tGridHeight);
					tBottom = Math.floor(gridY * tGridHeight + tGridHeight);
					var tLeft1:int,tRight1:int,tTop1:int,tBottom1:int;
					break;
				case TiledMap.ORIENTATION_STAGGERED://45度交错地图
					tLeft = Math.floor(gridX * tGridWidth / _mapTileW);
					tRight = Math.floor((gridX * tGridWidth + tGridWidth) / _mapTileW);
					tTop = Math.floor(gridY * tGridHeight / (_mapTileH/2));
					tBottom = Math.floor((gridY * tGridHeight + tGridHeight) / (_mapTileH/2));
					break;
				case TiledMap.ORIENTATION_ORTHOGONAL://直角
					tLeft = Math.floor(gridX * tGridWidth / _mapTileW);
					tRight = Math.floor((gridX * tGridWidth + tGridWidth) / _mapTileW);
					tTop = Math.floor(gridY * tGridHeight / _mapTileH);
					tBottom = Math.floor((gridY * tGridHeight + tGridHeight) / _mapTileH);
					break;
				case TiledMap.ORIENTATION_HEXAGONAL://六边形
					var tHeight:Number = _mapTileH * 2 / 3;
					tLeft = Math.floor(gridX * tGridWidth / _mapTileW);
					tRight = Math.ceil((gridX * tGridWidth + tGridWidth) / _mapTileW);
					tTop = Math.floor(gridY * tGridHeight / tHeight);
					tBottom = Math.ceil((gridY * tGridHeight + tGridHeight) / tHeight);
					break;
					
				}
				
				var tLayer:MapLayer = null;
				for (var z:int = 0; z < _layerArray.length; z++) {
					tLayer = _layerArray[z];
					tGridSprite = tLayer.getDrawSprite(gridX, gridY);
					tTempArray.push(tGridSprite);
					
					var tColorStr:String;
					if (_showGridKey)
					{
						tColorStr = "#";
						tColorStr += _colorArray[Math.floor(Math.random() * _colorArray.length)];
						tColorStr += _colorArray[Math.floor(Math.random() * _colorArray.length)];
						tColorStr += _colorArray[Math.floor(Math.random() * _colorArray.length)];
					}
					switch (orientation) {
					case TiledMap.ORIENTATION_ISOMETRIC://45度角
						var tHalfTileHeight:Number = tileHeight / 2;
						var tHalfTileWidth:Number = tileWidth / 2;
						var tHalfMapWidth:Number = _width / 2;
						tTop1 = Math.floor(tTop / tHalfTileHeight);
						tBottom1 = Math.floor(tBottom / tHalfTileHeight);
						tLeft1 = this._mapW + Math.floor((tLeft - tHalfMapWidth) / tHalfTileWidth);
						tRight1 = this._mapW + Math.floor((tRight - tHalfMapWidth) / tHalfTileWidth);
						
						var tMapW:Number = _mapW * 2;
						var tMapH:Number = _mapH * 2;
						
						if (tTop1 < 0) {
							tTop1 = 0;
						}
						if (tTop1 >= tMapH) {
							tTop1 = tMapH - 1;
						}
						if (tBottom1 < 0) {
							tBottom = 0;
						}
						if (tBottom1 >= tMapH) {
							tBottom1 = tMapH - 1;
						}
						tGridSprite.zOrder = _totalGridNum * z + gridY * _gridW + gridX;
						for (i = tTop1; i < tBottom1; i++) {
							for (j = 0; j <= i; j++) {
								var tIndexX:int = i - j;
								var tIndexY:int = j;
								var tIndexValue:int = (tIndexX - tIndexY) + _mapW;
								if (tIndexValue > tLeft1 && tIndexValue <= tRight1) {
									if (tLayer.drawTileTexture(tGridSprite, tIndexX, tIndexY)) {
										tGridSprite.drawImageNum++;
									}
								}
							}
						}
						break;
					case TiledMap.ORIENTATION_STAGGERED://45度交错地图
						tGridSprite.zOrder = z * _totalGridNum + gridY * _gridW + gridX;
						for (i = tTop; i < tBottom; i++) {
							for (j = tLeft; j < tRight; j++) {
								if (tLayer.drawTileTexture(tGridSprite, j, i)) {
									tGridSprite.drawImageNum++;
								}
							}
						}
						break;
					case TiledMap.ORIENTATION_ORTHOGONAL://直角
					case TiledMap.ORIENTATION_HEXAGONAL://六边形
						switch (_renderOrder) {
						case RENDERORDER_RIGHTDOWN: 
							tGridSprite.zOrder = z * _totalGridNum + gridY * _gridW + gridX;
							for (i = tTop; i < tBottom; i++) {
								for (j = tLeft; j < tRight; j++) {
									if (tLayer.drawTileTexture(tGridSprite, j, i)) {
										tGridSprite.drawImageNum++;
									}
								}
							}
							break;
						case RENDERORDER_RIGHTUP: 
							tGridSprite.zOrder = z * _totalGridNum + (_gridH - 1 - gridY) * _gridW + gridX;
							for (i = tBottom - 1; i >= tTop; i--) {
								for (j = tLeft; j < tRight; j++) {
									if (tLayer.drawTileTexture(tGridSprite, j, i)) {
										tGridSprite.drawImageNum++;
									}
								}
							}
							break;
						case RENDERORDER_LEFTDOWN: 
							tGridSprite.zOrder = z * _totalGridNum + gridY * _gridW + (_gridW - 1 - gridX);
							for (i = tTop; i < tBottom; i++) {
								for (j = tRight - 1; j >= tLeft; j--) {
									if (tLayer.drawTileTexture(tGridSprite, j, i)) {
										tGridSprite.drawImageNum++;
									}
								}
							}
							break;
						case RENDERORDER_LEFTUP: 
							tGridSprite.zOrder = z * _totalGridNum + (_gridH - 1 - gridY) * _gridW + (_gridW - 1 - gridX);
							for (i = tBottom - 1; i >= tTop; i--) {
								for (j = tRight - 1; j >= tLeft; j--) {
									if (tLayer.drawTileTexture(tGridSprite, j, i)) {
										tGridSprite.drawImageNum++;
									}
								}
							}
							break;
						}
						break;
					}
					//没动画了GRID，保存为图片
					if (!tGridSprite.isHaveAnimation) {
						tGridSprite.autoSize = true;
						tGridSprite.cacheAsBitmap = true;
						tGridSprite.autoSize = false;
					}
					if (tGridSprite.drawImageNum > 0) {
						tLayer.addChild(tGridSprite);
					}
					if (_showGridKey) {
						tGridSprite.graphics.drawRect(0, 0, tGridWidth, tGridHeight, null, tColorStr);
					}
				}
			} else {
				for (i = 0; i < tTempArray.length && i < _layerArray.length; i++) {
					var tLayerSprite:Sprite = _layerArray[i];
					if (tLayerSprite && tTempArray[i]) {
						tGridSprite = tTempArray[i];
						if (tGridSprite.visible == false && tGridSprite.drawImageNum > 0) {
							tGridSprite.show();
						}
					}
				}
			}
		}
		
		/**
		 * 隐藏指定的GRID
		 * @param	gridX
		 * @param	gridY
		 */
		private function hideGrid(gridX:int, gridY:int):void {
			if (gridX < 0 || gridX >= _gridW || gridY < 0 || gridY >= _gridH) {
				return;
			}
			var tTempArray:Array = _gridArray[gridY][gridX];
			if (tTempArray) {
				var tGridSprite:GridSprite;
				for (var i:int = 0; i < tTempArray.length; i++) {
					tGridSprite = tTempArray[i];
					if (tGridSprite.drawImageNum > 0) {
						if (tGridSprite != null) {
							tGridSprite.hide();
						}
					}
				}
			}
		}
		
		/**
		 * 得到对象层上的某一个物品
		 * @param	layerName   层的名称
		 * @param	objectName	所找物品的名称
		 * @return
		 */
		public function getLayerObject(layerName:String, objectName:String):GridSprite {
			var tLayer:MapLayer = null;
			for (var i:int = 0; i < _layerArray.length; i++) {
				tLayer = _layerArray[i];
				if (tLayer.layerName == layerName) {
					break;
				}
			}
			if (tLayer) {
				return tLayer.getObjectByName(objectName);
			}
			return null;
		}
		
		/**
		 * 销毁地图
		 */
		public function destroy():void {
			_orientation = ORIENTATION_ORTHOGONAL;
			//json数据
			_jsonData = null;
			
			var i:int = 0;
			var j:int = 0;
			var z:int = 0;
			
			_gridArray = [];//??这里因为跟LAYER中的数据重复，所以不做处理
			//清除子纹理
			var tTileTexSet:TileTexSet;
			for (i = 0; i < _tileTexSetArr.length; i++) {
				tTileTexSet = _tileTexSetArr[i];
				if (tTileTexSet) {
					tTileTexSet.clearAll();
				}
			}
			_tileTexSetArr = [];
			//清除主纹理
			var tTexture:Texture;
			for (i = 0; i < _texArray.length; i++) {
				tTexture = _texArray[i];
				tTexture.destroy();
			}
			_texArray = [];
			
			//地图信息中的一些基本数据
			_width = 0;
			_height = 0;
			_mapW = 0;
			_mapH = 0;
			_mapTileW = 0;
			_mapTileH = 0;
			
			_rect.setTo(0, 0, 0, 0);
			
			var tLayer:MapLayer;
			for (i = 0; i < _layerArray.length; i++) {
				tLayer = _layerArray[i];
				tLayer.clearAll();
			}
			
			_layerArray = [];
			if (_mapSprite) {
				_mapSprite.destroy();
				_mapSprite = null;
			}
			
			_jsonLoader = null;//??
			_loader = null;//??
			//
			var tDic:Object = _animationDic;
			for (var p:* in tDic) {
				delete tDic[p];
			}
			
			_properties = null;
			tDic = _tileProperties;
			for (p in tDic) {
				delete tDic[p];
			}
			
			_currTileSet = null;
			_completeHandler = null;
			
			_mapRect.clearAll();
			_mapLastRect.clearAll();
			
			_tileSetArray = [];
			
			_gridWidth = 450;
			_gridHeight = 450;
			
			_gridW = 0;
			_gridH = 0;
			
			_x = 0;
			_y = 0;
			
			_index = 0;
			
			_enableLinear = true;
			//资源的相对路径
			_resPath = null;
			_pathArray = null;
		}
		
		/****************************地图的基本数据***************************/
		/**
		 * 格子的宽度
		 */
		public function get tileWidth():int {
			return _mapTileW;
		}
		
		/**
		 * 格子的高度
		 */
		public function get tileHeight():int {
			return _mapTileH;
		}
		
		/**
		 * 地图的宽度
		 */
		public function get width():int {
			return _width;
		}
		
		/**
		 * 地图的高度
		 */
		public function get height():int {
			return _height;
		}
		
		/**
		 * 地图横向的格子数
		 */
		public function get numColumnsTile():int {
			return _mapW;
		}
		
		/**
		 * 地图竖向的格子数
		 */
		public function get numRowsTile():int {
			return _mapH;
		}
		
		/**
		 * @private
		 * 视口x坐标
		 */
		public function get viewPortX():Number {
			return -_viewPortX;
		}
		
		/**
		 * @private
		 * 视口的y坐标
		 */
		public function get viewPortY():Number {
			return -_viewPortY;
		}
		
		
		/**
		 * @private
		 * 视口的宽度
		 */
		public function get viewPortWidth():Number {
			return _viewPortWidth;
		}
		
		/**
		 * @private
		 * 视口的高度
		 */
		public function get viewPortHeight():Number {
			return _viewPortHeight;
		}
		
		/**
		 * 地图的x坐标
		 */
		public function get x():Number {
			return _x;
		}
		
		/**
		 * 地图的y坐标
		 */
		public function get y():Number {
			return _y;
		}
		
		/**
		 * 块的宽度
		 */
		public function get gridWidth():Number {
			return _gridWidth;
		}
		
		/**
		 * 块的高度
		 */
		public function get gridHeight():Number {
			return _gridHeight;
		}
		
		/**
		 * 地图的横向块数
		 */
		public function get numColumnsGrid():Number {
			return _gridW;
		}
		
		/**
		 * 地图的坚向块数
		 */
		public function get numRowsGrid():int {
			return _gridH;
		}
		
		/**
		 * 当前地图类型
		 */
		public function get orientation():String {
			return _orientation;
		}
		
		/**
		 * tile渲染顺序
		 */
		public function get renderOrder():String {
			return _renderOrder;
		}
		
		/*****************************************对外接口**********************************************/
		
		/**
		 * 整个地图的显示容器
		 * @return 地图的显示容器
		 */
		public function mapSprite():Sprite {
			return _mapSprite;
		}
		
		/**
		 * 得到指定的MapLayer
		 * @param layerName 要找的层名称
		 * @return 
		 */
		public function getLayerByName(layerName:String):MapLayer {
			var tMapLayer:MapLayer;
			for (var i:int = 0; i < _layerArray.length; i++) {
				tMapLayer = _layerArray[i];
				if (layerName == tMapLayer.layerName) {
					return tMapLayer;
				}
			}
			return null;
		}
		
		/**
		 * 通过索引得MapLayer
		 * @param	index 要找的层索引
		 * @return
		 */
		public function getLayerByIndex(index:int):MapLayer {
			if (index < _layerArray.length) {
				return _layerArray[index];
			}
			return null;
		}
	
	}

}

class GRect {
	public var left:int;
	public var top:int;
	public var right:int;
	public var bottom:int;
	
	public function clearAll():void {
		left = top = right = bottom = 0;
	}
}

class TileMapAniData {
	public var mAniIdArray:Array = [];
	public var mDurationTimeArray:Array = [];
	public var mTileTexSetArr:Array = [];
}

class TileSet {
	
	public var firstgid:int = 0;
	public var image:String = "";
	public var imageheight:int = 0;
	public var imagewidth:int = 0;
	public var margin:int = 0;
	public var name:int = 0;
	public var properties:*;
	public var spacing:int = 0;
	public var tileheight:int = 0;
	public var tilewidth:int = 0;
	
	public var titleoffsetX:int = 0;
	public var titleoffsetY:int = 0;
	public var tileproperties:*;
	
	public function init(data:*):void {
		firstgid = data.firstgid;
		image = data.image;
		imageheight = data.imageheight;
		imagewidth = data.imagewidth;
		margin = data.margin;
		name = data.name;
		properties = data.properties;
		spacing = data.spacing;
		tileheight = data.tileheight;
		tilewidth = data.tilewidth;
		
		//自定义属性
		tileproperties = data.tileproperties;
		var tTileoffset:* = data.tileoffset;
		if (tTileoffset) {
			titleoffsetX = tTileoffset.x;
			titleoffsetY = tTileoffset.y;
		}
	}
}