package laya.webgl.atlas {
	import laya.resource.Texture;
	import laya.webgl.resource.IMergeAtlasBitmap;
	
	public class AtlasResourceManager {
		private static var _atlasLimitWidth:int;
		private static var _atlasLimitHeight:int;
		
		public static const gridSize:int = 16;
		public static var atlasTextureWidth:int;
		public static var atlasTextureHeight:int;
		public static var maxTextureCount:int;
		public static var _atlasRestore:int = 0;
		
		public static var BOARDER_TYPE_NO:int = 0;
		public static var BOARDER_TYPE_RIGHT:int = 1;
		public static var BOARDER_TYPE_LEFT:int = 2;
		public static var BOARDER_TYPE_BOTTOM:int = 4;
		public static var BOARDER_TYPE_TOP:int = 8;
		public static var BOARDER_TYPE_ALL:int = 15;
		
		private static var _sid_:int = 0;
		private static var _Instance:AtlasResourceManager = null;
		
		private var _currentAtlasCount:int = 0;
		private var _maxAtlaserCount:int = 0;
		private var _width:int = 0;
		private var _height:int = 0;
		private var _gridSize:int = 0;
		private var _gridNumX:int = 0;
		private var _gridNumY:int = 0;
		private var _init:Boolean = false;
		private var _curAtlasIndex:int = 0;
		private var _setAtlasParam:Boolean = false;
		private var _atlaserArray:Vector.<Atlaser> = null;
		private var _needGC:Boolean = false;
		
		public static function get instance():AtlasResourceManager {
			if (!_Instance) {
				_Instance = new AtlasResourceManager(AtlasResourceManager.atlasTextureWidth, AtlasResourceManager.atlasTextureHeight, AtlasResourceManager.gridSize, AtlasResourceManager.maxTextureCount);
			}
			return _Instance;
		}
		
		public static function get enabled():Boolean {
			return Config.atlasEnable;
		}
		
		public static function get atlasLimitWidth():int {
			return _atlasLimitWidth;
		}
		
		public static function set atlasLimitWidth(value:int):void {
			
			_atlasLimitWidth = value;
		}
		
		public static function get atlasLimitHeight():int {
			return _atlasLimitHeight;
		}
		
		public static function set atlasLimitHeight(value:int):void {
			_atlasLimitHeight = value;
		}
		
		public static function _enable():void {
			Config.atlasEnable = true;
		}
		
		public static function _disable():void {
			Config.atlasEnable = false;
		}
		
		public static function __init__():void {
			atlasTextureWidth = 2048;
			atlasTextureHeight = 2048;
			maxTextureCount = 6;
			atlasLimitWidth = 512;
			atlasLimitHeight = 512;
		}
		
		public function AtlasResourceManager(width:int, height:int, gridSize:int, maxTexNum:int) {
			_setAtlasParam = true;
			_width = width;
			_height = height;
			_gridSize = gridSize;
			_maxAtlaserCount = maxTexNum;
			_gridNumX = width / gridSize;
			_gridNumY = height / gridSize;
			_curAtlasIndex = 0;
			_atlaserArray = new Vector.<Atlaser>();
		}
		
		public function setAtlasParam(width:int, height:int, gridSize:int, maxTexNum:int):Boolean {
			if (_setAtlasParam == true) {
				_sid_ = 0;
				_width = width;
				_height = height;
				_gridSize = gridSize;
				_maxAtlaserCount = maxTexNum;
				_gridNumX = width / gridSize;
				_gridNumY = height / gridSize;
				_curAtlasIndex = 0;
				freeAll();
				//Initialize();
				return true;
			} else {
				trace("设置大图合集参数错误，只能在开始页面设置各种参数");
				throw-1;
				return false;
			}
			return false;
		}
		
		//添加 图片到大图集
		public function pushData(texture:Texture):Boolean {
			var bitmap:* = texture.bitmap;
			var nWebGLImageIndex:int = -1;
			var curAtlas:Atlaser = null;
			var i:int, n:int, altasIndex:int;
			for (i = 0, n = _atlaserArray.length; i < n; i++) {
				altasIndex = (_curAtlasIndex + i) % n;
				curAtlas = _atlaserArray[altasIndex];
				nWebGLImageIndex = curAtlas.findBitmapIsExist(bitmap);
				if (nWebGLImageIndex != -1) {
					break;
				}
			}
			
			if (nWebGLImageIndex != -1) {
				var offset:Array = curAtlas.InAtlasWebGLImagesOffsetValue[nWebGLImageIndex];
				offsetX = offset[0];
				offsetY = offset[1];
				curAtlas.addToAtlas(texture, offsetX, offsetY);
				return true;
			} else {
				var tex:* = texture;//需要动态类型,设为弱类型
				_setAtlasParam = false;
				var bFound:Boolean = false;
				var nImageGridX:int = (Math.ceil((texture.bitmap.width + 2) / _gridSize));//加2个边缘像素
				var nImageGridY:int = (Math.ceil((texture.bitmap.height + 2) / _gridSize));//加2个边缘像素
				
				var bSuccess:Boolean = false;
				//这个for循环是为了 如果 贴图满了，再创建一张，继续放置
				for (var k:int = 0; k < 2; k++) {
					var maxAtlaserCount:int = _maxAtlaserCount;
					for (i = 0; i < maxAtlaserCount; i++) {
						altasIndex = (_curAtlasIndex + i) % maxAtlaserCount;
						
						(_atlaserArray.length - 1 >= altasIndex) || (_atlaserArray.push(new Atlaser(_gridNumX, _gridNumY, _width, _height, _sid_++)));//不存在则创建大图合集
						var atlas:Atlaser = _atlaserArray[altasIndex];
						var offsetX:int, offsetY:int;
						var fillInfo:MergeFillInfo = atlas.addTex(1, nImageGridX, nImageGridY);
						if (fillInfo.ret) {
							offsetX = fillInfo.x * _gridSize + 1;//加1为排除边缘因素
							offsetY = fillInfo.y * _gridSize + 1;//加1为排除边缘因素
							bitmap.lock = true;//资源加锁，防止资源被自动释放
							atlas.addToAtlasTexture((bitmap as IMergeAtlasBitmap), offsetX, offsetY);
							atlas.addToAtlas(texture, offsetX, offsetY);
							bSuccess = true;
							_curAtlasIndex = altasIndex;
							break;
						}
					}
					if (bSuccess)
						break;
					_atlaserArray.push(new Atlaser(_gridNumX, _gridNumY, _width, _height, _sid_++));
					_needGC = true;
					garbageCollection();
					_curAtlasIndex = _atlaserArray.length - 1;
				}
				if (!bSuccess) {
					trace(">>>AtlasManager pushData error");
				}
				return bSuccess;
			}
		}
		
		public function addToAtlas(tex:Texture):void {
			AtlasResourceManager.instance.pushData(tex);
		}
		
		/**
		 * 回收大图合集,不建议手动调用
		 * @return
		 */
		public function garbageCollection():Boolean {
			if (_needGC === true) {
				var n:int = _atlaserArray.length - _maxAtlaserCount;
				
				for (var i:int = 0; i < n; i++) {
					_atlaserArray[i].dispose();
					trace("AtlasResourceManager:Dispose the inner Atlas。");
				}
				trace(">>>>altas garbageCollection =" + n);
				_atlaserArray.splice(0, n);
				_needGC = false;
				
			}
			return true;
		}
		
		public function freeAll():void {
			for (var i:int = 0, n:int = _atlaserArray.length; i < n; i++) {
				_atlaserArray[i].dispose();
			}
			_atlaserArray.length = 0;
			_curAtlasIndex = 0;
		}
		
		public function getAtlaserCount():int {
			return _atlaserArray.length;
		}
		
		public function getAtlaserByIndex(index:int):Atlaser {
			return _atlaserArray[index];
		}
	}
}