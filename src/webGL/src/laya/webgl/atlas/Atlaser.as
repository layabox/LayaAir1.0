package laya.webgl.atlas {
	import laya.resource.Bitmap;
	import laya.resource.Texture;
	import laya.webgl.resource.IMergeAtlasBitmap;
	import laya.webgl.resource.WebGLImage;
	
	public class Atlaser extends AtlasGrid {
		private var _atlasCanvas:AtlasWebGLCanvas;
		public var _inAtlasTextureKey:Vector.<Texture>;
		public var _inAtlasTextureBitmapValue:Vector.<Bitmap>;
		public var _inAtlasTextureOriUVValue:Vector.<Array>;
		
		private var _InAtlasWebGLImagesKey:Object;
		private var _InAtlasWebGLImagesOffsetValue:Vector.<Array>;
		
		public function get texture():AtlasWebGLCanvas {
			return _atlasCanvas;
		}
		
		public function get inAtlasWebGLImagesKey():Object {
			return _InAtlasWebGLImagesKey;
		}
		
		public function get InAtlasWebGLImagesOffsetValue():Vector.<Array> {
			return _InAtlasWebGLImagesOffsetValue;
		}
		
		public function Atlaser(gridNumX:int, gridNumY:int, width:int, height:int, atlasID:uint) {
			super(gridNumX, gridNumY, atlasID);
			_inAtlasTextureKey = new Vector.<Texture>();
			_inAtlasTextureBitmapValue = new Vector.<Bitmap>();
			_inAtlasTextureOriUVValue = new Vector.<Array>();
			_InAtlasWebGLImagesKey = {};
			_InAtlasWebGLImagesOffsetValue = new Vector.<Array>();
			_atlasCanvas = new AtlasWebGLCanvas();
			_atlasCanvas._atlaser = this;
			_atlasCanvas.width = width;
			_atlasCanvas.height = height;
			_atlasCanvas.activeResource();
			_atlasCanvas.lock = true;
		}
		
		private function computeUVinAtlasTexture(texture:Texture, oriUV:Array, offsetX:int, offsetY:int):void {
			var tex:* = texture;//需要用到动态属性,使用弱类型
			var _width:int = AtlasResourceManager.atlasTextureWidth;
			var _height:int = AtlasResourceManager.atlasTextureHeight;
			var u1:Number = offsetX / _width, v1:Number = offsetY / _height, u2:Number = (offsetX + texture.bitmap.width) / _width, v2:Number = (offsetY + texture.bitmap.height) / _height;
			var inAltasUVWidth:Number = texture.bitmap.width / _width, inAltasUVHeight:Number = texture.bitmap.height / _height;
			texture.uv = [u1 + oriUV[0] * inAltasUVWidth, v1 + oriUV[1] * inAltasUVHeight, u2 - (1 - oriUV[2]) * inAltasUVWidth, v1 + oriUV[3] * inAltasUVHeight, u2 - (1 - oriUV[4]) * inAltasUVWidth, v2 - (1 - oriUV[5]) * inAltasUVHeight, u1 + oriUV[6] * inAltasUVWidth, v2 - (1 - oriUV[7]) * inAltasUVHeight];
		}
		
		public function findBitmapIsExist(bitmap:*):int
		{
			if (bitmap is WebGLImage)
			{
				var webImage:WebGLImage = bitmap;
				var sUrl:String = webImage.url;
				var object:* = _InAtlasWebGLImagesKey[sUrl?sUrl:webImage.id]
				if ( object )
				{
					return object.offsetInfoID;
				}
			}
			return -1;
		}
		
		/**
		 *
		 * @param	inAtlasRes
		 * @return  是否已经存在队列中
		 */
		public function addToAtlasTexture(mergeAtlasBitmap:IMergeAtlasBitmap, offsetX:int, offsetY:int):void {
			if (mergeAtlasBitmap is WebGLImage)
			{
				var webImage:WebGLImage = mergeAtlasBitmap as WebGLImage;
				var sUrl:String = webImage.url;
				_InAtlasWebGLImagesKey[sUrl?sUrl:webImage.id] = {bitmap:mergeAtlasBitmap,offsetInfoID:_InAtlasWebGLImagesOffsetValue.length};
				_InAtlasWebGLImagesOffsetValue.push([offsetX, offsetY]);
			}
			//if (bitmap is  WebGLSubImage)//临时
			//_atlasCanvas.texSubImage2DPixel(bitmap, offsetX,/* width, height, AtlasManager.BOARDER_TYPE_ALL, 1, 1*/ offsetY,bitmap.width,bitmap.height, bitmap.imageData);
			//else
			_atlasCanvas.texSubImage2D(offsetX,/* width, height, AtlasManager.BOARDER_TYPE_ALL, 1, 1*/ offsetY, mergeAtlasBitmap.atlasSource);
			mergeAtlasBitmap.clearAtlasSource();
		}
		
		public function addToAtlas(texture:Texture, offsetX:int, offsetY:int):void {
			texture._atlasID = _inAtlasTextureKey.length;
			var oriUV:Array = texture.uv.slice();
			var oriBitmap:Bitmap = texture.bitmap;
			_inAtlasTextureKey.push(texture);
			_inAtlasTextureOriUVValue.push(oriUV);
			_inAtlasTextureBitmapValue.push(oriBitmap);
			
			computeUVinAtlasTexture(texture, oriUV, offsetX, offsetY);
			texture.bitmap = _atlasCanvas;
		}
		
		public function clear():void {
			for (var i:int = 0, n:int = _inAtlasTextureKey.length; i < n; i++) {
				_inAtlasTextureKey[i].bitmap = _inAtlasTextureBitmapValue[i];//恢复原始bitmap
				_inAtlasTextureKey[i].uv = _inAtlasTextureOriUVValue[i];//恢复原始uv
				_inAtlasTextureKey[i]._atlasID = -1;
				_inAtlasTextureKey[i].bitmap.lock = false;//解锁资源
				_inAtlasTextureKey[i].bitmap.releaseResource();
				//_inAtlasTextureKey[i].bitmap.lock = false;//重新加锁
			}
			_inAtlasTextureKey.length = 0;
			_inAtlasTextureBitmapValue.length = 0;
			_inAtlasTextureOriUVValue.length = 0;
			_InAtlasWebGLImagesKey = null;
			_InAtlasWebGLImagesOffsetValue.length = 0;
		}
		
		public function dispose():void {
			clear();
			_atlasCanvas.destroy();
		}
	}
}