package laya.map {
	import laya.display.Sprite;
	import laya.map.GridSprite;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.resource.Texture;
	
	/**
	 * 地图支持多层渲染（例如，地表层，植被层，建筑层等）
	 * 本类就是层级类
	 * @author ...
	 */
	public class MapLayer extends Sprite {
		
		private var _map:TiledMap;
		private var _mapData:Array = null;
		
		private var _tileWidthHalf:Number = 0;
		private var _tileHeightHalf:Number = 0;
		
		private var _mapWidthHalf:Number = 0;
		private var _mapHeightHalf:Number = 0;
		
		private var _gridSpriteArray:Array = [];
		private var _objDic:Object = null;//用来做字典，方便查询
		
		private var _tempMapPos:Point = new Point();//临时变量
		private var _properties:*;
		/**当前Layer的名称*/
		public var layerName:String = null;
		
		/**
		 * 解析LAYER数据，以及初始化一些数据
		 * @param	layerData 地图数据中，layer数据的引用
		 * @param	map 地图的引用
		 */
		public function init(layerData:*, map:TiledMap):void {
			_map = map;
			_mapData = layerData.data;
			//地图宽和高（单位:格子）
			var tHeight:int = layerData.height;
			var tWidth:int = layerData.width;
			
			var tTileW:int = map.tileWidth;
			var tTileH:int = map.tileHeight;
			
			layerName = layerData.name;
			_properties = layerData.properties;
			this.alpha = layerData.opacity;
			
			_tileWidthHalf = tTileW / 2;
			_tileHeightHalf = tTileH / 2;
			
			//减一半的格子，加到这，是因为，下面计算坐标的时候，可以减少计算量
			_mapWidthHalf = _map.width / 2 - _tileWidthHalf;
			_mapHeightHalf = _map.height / 2;
			//这里要特别注意，有时间去查查JS源代码支持的所有类型
			switch (layerData.type) {
			case "tilelayer": 
				break;
			case "objectgroup": 
				//这里的东西必需要一开始就创建，所以要用物品的动态管理做下
				var tObjectGid:int = 0;
				var tArray:Array = layerData.objects;
				if (tArray.length > 0) {
					_objDic = {};
				}
				var tObjectData:*;
				var tObjWidth:Number;
				var tObjHeight:Number;
				for (var i:int = 0; i < tArray.length; i++) {
					tObjectData = tArray[i];
					//这里要看具体需求，看是不是要开放
					if (tObjectData.visible == true) {
						tObjWidth = tObjectData.width;
						tObjHeight = tObjectData.height;
						var tSprite:GridSprite = map.getSprite(tObjectData.gid, tObjWidth, tObjHeight);
						if (tSprite != null) {
							switch (_map.orientation) {
							case TiledMap.ORIENTATION_ISOMETRIC:
								getScreenPositionByTilePos(tObjectData.x / tTileH, tObjectData.y / tTileH, Point.TEMP);
								tSprite.pivot(tObjWidth / 2, tObjHeight / 2);
								tSprite.rotation = tObjectData.rotation;
								tSprite.x = tSprite.relativeX = Point.TEMP.x + _map.viewPortX;
								tSprite.y = tSprite.relativeY = Point.TEMP.y + _map.viewPortY - tObjHeight / 2;
								break;
							case TiledMap.ORIENTATION_STAGGERED://对象旋转后坐标计算的不对。。
								tSprite.pivot(tObjWidth / 2, tObjHeight / 2);
								tSprite.rotation = tObjectData.rotation;
								tSprite.x = tSprite.relativeX = tObjectData.x + tObjWidth / 2;
								tSprite.y = tSprite.relativeY = tObjectData.y - tObjHeight / 2;
								break;
							case TiledMap.ORIENTATION_ORTHOGONAL: 
								tSprite.pivot(tObjWidth / 2, tObjHeight / 2);
								tSprite.rotation = tObjectData.rotation;
								tSprite.x = tSprite.relativeX = tObjectData.x + tObjWidth / 2;
								tSprite.y = tSprite.relativeY = tObjectData.y - tObjHeight / 2;
								break;
							case TiledMap.ORIENTATION_HEXAGONAL://待测试
								tSprite.x = tSprite.relativeX = tObjectData.x;
								tSprite.y = tSprite.relativeY = tObjectData.y;
								break;
							}
							this.addChild(tSprite);
							_gridSpriteArray.push(tSprite);
							_objDic[tObjectData.name] = tSprite;
						}
					}
				}
				break;
			}
		}
		
		/******************************************对外接口*********************************************/
		/**
		 * 通过名字获取控制对象，如果找不到返回为null
		 * @param	objName 所要获取对象的名字
		 * @return
		 */
		public function getObjectByName(objName:String):GridSprite {
			if (_objDic) {
				return _objDic[objName];
			}
			return null;
		}
		
		/**
		 * 得到地图层的自定义属性
		 * @param	name
		 * @return
		 */
		public function getLayerProperties(name:String):*
		{
			if (_properties)
			{
				return _properties[name];
			}
			return null;
		}
		
		/**
		 * 得到指定格子的数据
		 * @param	tileX 格子坐标X
		 * @param	tileY 格子坐标Y
		 * @return
		 */
		public function getTileData(tileX:int, tileY:int):int {
			if (tileY >= 0 && tileY < _map.numRowsTile && tileX >= 0 && tileX < _map.numColumnsTile) {
				var tIndex:int = tileY * _map.numColumnsTile + tileX;
				var tMapData:Array = _mapData;
				if (tMapData != null && tIndex < tMapData.length) {
					return tMapData[tIndex];
				}
			}
			return 0;
		}
		
		/**
		 * 通过地图坐标得到屏幕坐标
		 * @param	tileX 格子坐标X
		 * @param	tileY 格子坐标Y
		 * @param	screenPos 把计算好的屏幕坐标数据，放到此对象中
		 */
		public function getScreenPositionByTilePos(tileX:Number, tileY:Number, screenPos:Point = null):void {
			if (screenPos) {
				switch (_map.orientation) {
				case TiledMap.ORIENTATION_ISOMETRIC: 
					screenPos.x = _map.width / 2 - (tileY - tileX) * _tileWidthHalf;
					screenPos.y = (tileY + tileX) * _tileHeightHalf;
					break;
				case TiledMap.ORIENTATION_STAGGERED:
					tileX = Math.floor(tileX);
					tileY = Math.floor(tileY);
					screenPos.x = tileX * _map.tileWidth + (tileY & 1) * _tileWidthHalf;
					screenPos.y = tileY * _tileHeightHalf;
					break;
				case TiledMap.ORIENTATION_ORTHOGONAL: 
					screenPos.x = tileX * _map.tileWidth;
					screenPos.y = tileY * _map.tileHeight;
					break;
				case TiledMap.ORIENTATION_HEXAGONAL: 
					tileX = Math.floor(tileX);
					tileY = Math.floor(tileY);
					var tTileHeight:Number = _map.tileHeight * 2 / 3;
					screenPos.x = (tileX * _map.tileWidth + tileY % 2 * _tileWidthHalf) % _map.gridWidth;
					screenPos.y = (tileY * tTileHeight) % _map.gridHeight;
					break;
				}
				//地图坐标转换成屏幕坐标
				screenPos.x = (screenPos.x + _map.viewPortX) * _map.scale;
				screenPos.y = (screenPos.y + _map.viewPortY) * _map.scale;
			}
		}
		
		/**
		 * 通过屏幕坐标来获取选中格子的数据
		 * @param	screenX 屏幕坐标x
		 * @param	screenY 屏幕坐标y
		 * @return
		 */
		public function getTileDataByScreenPos(screenX:Number, screenY:Number):int {
			var tData:int = 0;
			if (this.getTilePositionByScreenPos(screenX, screenY, _tempMapPos)) {
				tData = getTileData(Math.floor(_tempMapPos.x), Math.floor(_tempMapPos.y));
			}
			return tData;
		}
		
		/**
		 * 通过屏幕坐标来获取选中格子的索引
		 * @param	screenX 屏幕坐标x
		 * @param	screenY 屏幕坐标y
		 * @param	result 把计算好的格子坐标，放到此对象中
		 * @return
		 */
		public function getTilePositionByScreenPos(screenX:Number, screenY:Number, result:Point = null):Boolean {
			//转换成地图坐标
			screenX = screenX/_map.scale - _map.viewPortX;
			screenY = screenY/_map.scale - _map.viewPortY;
			var tTileW:int = _map.tileWidth;
			var tTileH:int = _map.tileHeight;
			
			var tV:Number = 0;
			var tU:Number = 0;
			switch (_map.orientation) {
			case TiledMap.ORIENTATION_ISOMETRIC://45度角
				var tDirX:Number = screenX - _map.width / 2;
				var tDirY:Number = screenY;
				tV = -(tDirX / tTileW - tDirY / tTileH);
				tU = tDirX / tTileW + tDirY / tTileH;
				if (result) {
					result.x = tU;
					result.y = tV;
				}
				return true;
				break;
			case TiledMap.ORIENTATION_STAGGERED://45度交错地图
				if (result) {
					var cx:int, cy:int, rx:int, ry:int;
					cx = Math.floor(screenX / tTileW) * tTileW + tTileW / 2;        //计算出当前X所在的以tileWidth为宽的矩形的中心的X坐标
					cy = Math.floor(screenY / tTileH) * tTileH + tTileH / 2;//计算出当前Y所在的以tileHeight为高的矩形的中心的Y坐标
					
					rx = (screenX - cx) * tTileH / 2;
					ry = (screenY - cy) * tTileW / 2;
					
					if (Math.abs(rx) + Math.abs(ry) <= tTileW * tTileH / 4) {
						tU = Math.floor(screenX / tTileW);
						tV = Math.floor(screenY / tTileH) * 2;
					} else {
						screenX = screenX - tTileW / 2;
						tU = Math.floor(screenX / tTileW) + 1;
						screenY = screenY - tTileH / 2;
						tV = Math.floor(screenY / tTileH) * 2 + 1;
					}
					result.x = tU - (tV & 1);
					result.y = tV;
				}
				return true;
				break;
			case TiledMap.ORIENTATION_ORTHOGONAL://直角
				tU = screenX / tTileW;
				tV = screenY / tTileH;
				if (result) {
					result.x = tU;
					result.y = tV;
				}
				return true;
				break;
			case TiledMap.ORIENTATION_HEXAGONAL://六边形
				var tTileHeight:Number = tTileH * 2 / 3;
				tV = screenY / tTileHeight;
				tU = (screenX - tV % 2 * _tileWidthHalf) / tTileW;
				if (result) {
					result.x = tU;
					result.y = tV;
				}
				break;
			}
			return false;
		}
		
		/***********************************************************************************************/
		/**
		 * 得到一个GridSprite
		 * @param	gridX 当前Grid的X轴索引
		 * @param	gridY 当前Grid的Y轴索引
		 * @return  一个GridSprite对象
		 */
		public function getDrawSprite(gridX:int, gridY:int):GridSprite {
			var tSprite:GridSprite = new GridSprite();
			tSprite.relativeX = gridX * _map.gridWidth;
			tSprite.relativeY = gridY * _map.gridHeight;
			tSprite.initData(_map);
			_gridSpriteArray.push(tSprite);
			return tSprite;
		}
		
		/**
		 * 更新此层中块的坐标
		 * 手动刷新的目的是，保持层级的宽和高保持最小，加快渲染
		 */
		public function updateGridPos():void {
			var tSprite:GridSprite;
			for (var i:int = 0; i < this._gridSpriteArray.length; i++) {
				tSprite = this._gridSpriteArray[i];
				if ((tSprite.visible || tSprite.isAloneObject) && tSprite.drawImageNum > 0) {
					tSprite.updatePos();
				}
			}
		}
		
		/**
		 * @private
		 * 把tile画到指定的显示对象上
		 * @param	gridSprite 被指定显示的目标
		 * @param	tileX 格子的X轴坐标
		 * @param	tileY 格子的Y轴坐标
		 * @return
		 */
		public function drawTileTexture(gridSprite:GridSprite, tileX:int, tileY:int):Boolean {
			if (tileY >= 0 && tileY < _map.numRowsTile && tileX >= 0 && tileX < _map.numColumnsTile) {
				var tIndex:int = tileY * _map.numColumnsTile + tileX;
				var tMapData:Array = _mapData;
				if (tMapData != null && tIndex < tMapData.length) {
					if (tMapData[tIndex] != 0) {
						var tTileTexSet:TileTexSet = _map.getTexture(tMapData[tIndex]);
						if (tTileTexSet) {
							var tX:Number = 0;
							var tY:Number = 0;
							var tTexture:Texture = tTileTexSet.texture;
							switch (_map.orientation) {
							case TiledMap.ORIENTATION_STAGGERED://45度交错地图
								tX = tileX * _map.tileWidth % _map.gridWidth + (tileY & 1) * _tileWidthHalf;
								tY = tileY * _tileHeightHalf % _map.gridHeight;
								break;
							case TiledMap.ORIENTATION_ORTHOGONAL://直角
								tX = tileX * _map.tileWidth % _map.gridWidth;
								tY = tileY * _map.tileHeight % _map.gridHeight;
								break;
							case TiledMap.ORIENTATION_ISOMETRIC://45度角
								tX = (_mapWidthHalf + (tileX - tileY) * _tileWidthHalf) % _map.gridWidth;
								tY = ((tileX + tileY) * _tileHeightHalf) % _map.gridHeight;
								break;
							case TiledMap.ORIENTATION_HEXAGONAL://六边形
								var tTileHeight:Number = _map.tileHeight * 2 / 3;
								tX = (tileX * _map.tileWidth + tileY % 2 * _tileWidthHalf) % _map.gridWidth;
								tY = (tileY * tTileHeight) % _map.gridHeight;
								break;
							}
							if (tTileTexSet.isAnimation) {
								var tAnimationSprite:TileAniSprite = new TileAniSprite();
								tAnimationSprite.x = tX;
								tAnimationSprite.y = tY;
								tAnimationSprite.setTileTextureSet(tIndex.toString(), tTileTexSet);
								gridSprite.addAniSprite(tAnimationSprite);
								gridSprite.addChild(tAnimationSprite);
								gridSprite.isHaveAnimation = true;
							} else {
								gridSprite.graphics.drawTexture(tTileTexSet.texture, tX + tTileTexSet.offX, tY + tTileTexSet.offY, tTexture.width, tTexture.height);
							}
							return true;
						}
					}
				}
			}
			return false;
		}
		
		/**
		 * @private
		 * 清理当前对象
		 */
		public function clearAll():void {
			_map = null;
			_mapData = null;
			_tileWidthHalf = 0;
			_tileHeightHalf = 0;
			_mapWidthHalf = 0;
			_mapHeightHalf = 0;
			layerName = null;
			var i:int = 0;
			if (_objDic) {
				for (var p:* in _objDic) {
					delete _objDic[p];
				}
				_objDic = null;
			}
			var tGridSprite:GridSprite;
			for (i = 0; i < _gridSpriteArray.length; i++) {
				tGridSprite = _gridSpriteArray[i];
				tGridSprite.clearAll();
			}
			_properties = null;
			_tempMapPos = null;
		}
	}
}