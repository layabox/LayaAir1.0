package laya.webgl.atlas {
	import laya.maths.Rectangle;
	import laya.resource.Texture;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.resource.WebGLCanvas;
	import laya.webgl.resource.WebGLImage;
	
	public class AtlasManager {
		private static var _enabled:Boolean = false;
		private static var _atlasLimitWidth:int;
		private static var _atlasLimitHeight:int;
		
		public static var atlasTextureWidth:int = 2048;
		public static var atlasTextureHeight:int = 2048;
		public static var gridSize:int = 16;
		public static var maxTextureCount:int = 8;
		
		public static var BOARDER_TYPE_NO:int = 0;
		public static var BOARDER_TYPE_RIGHT:int = 1;
		public static var BOARDER_TYPE_LEFT:int = 2;
		public static var BOARDER_TYPE_BOTTOM:int = 4;
		public static var BOARDER_TYPE_TOP:int = 8;
		public static var BOARDER_TYPE_ALL:int = 15;
		private static var _sid_:int = 0;
		
		private var _maxAtlasNum:int = 0;
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
		private static var __S_Instance__:AtlasManager = null;
		
		public static function get instance():AtlasManager {
			if (!__S_Instance__) {
				__S_Instance__ = new AtlasManager(atlasTextureWidth, atlasTextureHeight, gridSize, maxTextureCount);
			}
			return __S_Instance__;
		}
		
		public static function get enabled():Boolean {
			return _enabled;
		}
		
		public static function get atlasLimitWidth():int {
			return _atlasLimitWidth;
		}
		
		public static function set atlasLimitWidth(value:int):void {
			
			_atlasLimitWidth = value;
			Config.atlasLimitWidth = value;
		}
		
		public static function get atlasLimitHeight():int {
			return _atlasLimitHeight;
		}
		
		public static function set atlasLimitHeight(value:int):void {
			_atlasLimitHeight = value;
			Config.atlasLimitHeight = value;
		}
		
		public static function enable():void {
			_enabled = true;
			Config.atlasEnable = true;
		}
		
		public static function __init__():void {
			atlasLimitWidth = 512;
			atlasLimitHeight = 512;
		}
		
		public function AtlasManager(width:int, height:int, gridSize:int, maxTexNum:int) {
			_setAtlasParam = true;
			
			_width = width;
			_height = height;
			_gridSize = gridSize;
			_maxAtlasNum = maxTexNum;
			_gridNumX = width / gridSize;
			_gridNumY = height / gridSize;
			_curAtlasIndex = 0;
			_atlaserArray = new Vector.<Atlaser>();
			if (WebGL.mainContext) Initialize();
		}
		
		public function Initialize():Boolean {
			for (var i:int = 0; i < _maxAtlasNum; i++) {
				_atlaserArray.push(new Atlaser(_gridNumX, _gridNumY, _width, _height, _sid_));
				_sid_++;
			}
			return true;
		}
		
		public function setAtlasParam(width:int, height:int, gridSize:int, maxTexNum:int):Boolean {
			if (_setAtlasParam == true) {
				_sid_ = 0;
				_width = width;
				_height = height;
				_gridSize = gridSize;
				_maxAtlasNum = maxTexNum;
				_gridNumX = width / gridSize;
				_gridNumY = height / gridSize;
				_curAtlasIndex = 0;
				freeAll();
				Initialize();
				return true;
			} else {
				trace("设置大图合集参数错误，只能在开始页面设置各种参数");
				throw-1;
				return false;
			}
			return false;
		}
		
		private function computeUVinAtlasTexture(texture:Texture, offsetX:int, offsetY:int):void {
			var tex:* = texture;//需要用到动态属性,使用弱类型
			var u1:Number = offsetX / _width, v1:Number = offsetY / _height, u2:Number = (offsetX + texture.bitmap.width) / _width, v2:Number = (offsetY + texture.bitmap.height) / _height;
			var inAltasUVWidth:Number = texture.bitmap.width / _width, inAltasUVHeight:Number = texture.bitmap.height / _height;
			var oriUV:Array = tex.originalUV;
			texture.uv = [u1 + oriUV[0] * inAltasUVWidth, v1 + oriUV[1] * inAltasUVHeight, u2 - (1 - oriUV[2]) * inAltasUVWidth, v1 + oriUV[3] * inAltasUVHeight, u2 - (1 - oriUV[4]) * inAltasUVWidth, v2 - (1 - oriUV[5]) * inAltasUVHeight, u1 + oriUV[6] * inAltasUVWidth, v2 - (1 - oriUV[7]) * inAltasUVHeight];
		}
		
		//添加 图片到大图集
		public function pushData(texture:Texture):Boolean {
			var tex:* = texture;//需要动态类型,设为弱类型
			_setAtlasParam = false;
			var bFound:Boolean = false;
			var nImageGridX:int = (Math.ceil((texture.bitmap.width + 2) / _gridSize));//加2个边缘像素
			var nImageGridY:int = (Math.ceil((texture.bitmap.height + 2) / _gridSize));//加2个边缘像素
			
			var bSuccess:Boolean = false;
			//这个for循环是为了 如果 贴图满了，再创建一张，继续放置
			for (var k:int = 0; k < 2; k++) {
				var nAtlasSize:int = _atlaserArray.length;
				for (var i:int = 0; i < nAtlasSize; ++i) {
					
					var altasIndex:int = (_curAtlasIndex + i) % nAtlasSize;
					var atlas:Atlaser = _atlaserArray[altasIndex];
					var bitmap:* = texture.bitmap;
					if (atlas.webGLImages.indexOf(bitmap) == -1) {
						var fillInfo:MergeFillInfo = atlas.addTex(1, nImageGridX, nImageGridY);
						if (fillInfo.ret) {
							var offsetX:int = fillInfo.x * _gridSize + 1;//排除边缘因素
							var offsetY:int = fillInfo.y * _gridSize + 1;//排除边缘因素
							
							atlas.addToAtlasTexture(bitmap, offsetX, offsetY);
							
							(!tex.originalUV) && (tex.originalUV = texture.uv.slice());//保存原始的uv，因为资源被挤掉的时候，要使用原始的UV数据,Texture应该抛个UVChanged事件
							bSuccess = true;
							_curAtlasIndex = altasIndex;
							computeUVinAtlasTexture(texture, bitmap.offsetX, bitmap.offsetY);
							atlas.addToAtlas(texture);
							break;
						}
					} else {
						(!tex.originalUV) && (tex.originalUV = texture.uv.slice());//保存原始的uv，因为资源被挤掉的时候，要使用原始的UV数据,Texture应该抛个UVChanged事件
						bSuccess = true;
						_curAtlasIndex = altasIndex;
						computeUVinAtlasTexture(texture, bitmap.offsetX, bitmap.offsetY);
						atlas.addToAtlas(texture);
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
		
		public function addToAtlas(tex:Texture):void {
			AtlasManager.instance.pushData(tex);
		}
		
		/**
		 * 回收大图合集,不建议手动调用
		 * @return
		 */
		public function garbageCollection():Boolean {
			if (_needGC === true) {
				var n:int = _atlaserArray.length - _maxAtlasNum;
				
				for (var i:int = 0; i < n; i++)//调用大图合集的destory
					_atlaserArray[i].destroy();
				_atlaserArray.splice(0, n);
				_needGC = false;
			}
			return true;
		}
		
		public function freeAll():void {
			for (var i:int = 0, n:int = _atlaserArray.length; i < n; i++) {
				_atlaserArray[i].destroy();
			}
			_atlaserArray.length = 0;
		}
	}
}