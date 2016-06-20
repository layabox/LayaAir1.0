package laya.webgl.atlas {
	import laya.resource.Bitmap;
	import laya.resource.Texture;
	import laya.webgl.resource.IMergeAtlasBitmap;
	import laya.webgl.resource.WebGLImage;
	
	public class Atlaser extends AtlasGrid {
		private var _atlasCanvas:AtlasWebGLCanvas;
		private var _inAtlasTextureKey:Vector.<Texture>;
		private var _inAtlasTextureBitmapValue:Vector.<Bitmap>;
		private var _inAtlasTextureOriUVValue:Vector.<Array>;
		
		private var _InAtlasWebGLImagesKey:Vector.<WebGLImage>;
		private var _InAtlasWebGLImagesOffsetValue:Vector.<Array>;
		
		public function get texture():AtlasWebGLCanvas {
			return _atlasCanvas;
		}
		
		public function get inAtlasWebGLImagesKey():Vector.<WebGLImage> {
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
			_InAtlasWebGLImagesKey = new Vector.<WebGLImage>();
			_InAtlasWebGLImagesOffsetValue = new Vector.<Array>();
			_atlasCanvas = new AtlasWebGLCanvas();
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
		
		/**
		 *
		 * @param	inAtlasRes
		 * @return  是否已经存在队列中
		 */
		public function addToAtlasTexture(mergeAtlasBitmap:IMergeAtlasBitmap, offsetX:int, offsetY:int):void {
			(mergeAtlasBitmap is WebGLImage) && (_InAtlasWebGLImagesKey.push(mergeAtlasBitmap), _InAtlasWebGLImagesOffsetValue.push([offsetX, offsetY]));
			//if (bitmap is  WebGLSubImage)//临时
			//_atlasCanvas.texSubImage2DPixel(bitmap, offsetX,/* width, height, AtlasManager.BOARDER_TYPE_ALL, 1, 1*/ offsetY,bitmap.width,bitmap.height, bitmap.imageData);
			//else
			_atlasCanvas.texSubImage2D(offsetX,/* width, height, AtlasManager.BOARDER_TYPE_ALL, 1, 1*/ offsetY, mergeAtlasBitmap.atlasSource);
			mergeAtlasBitmap.clearAtlasSource();
		}
		
		public function addToAtlas(texture:Texture, offsetX:int, offsetY:int):void {
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
				_inAtlasTextureKey[i].bitmap.lock = false;//解锁资源
				_inAtlasTextureKey[i].bitmap.releaseResource();
				//_inAtlasTextureKey[i].bitmap.lock = false;//重新加锁
			}
			
			_inAtlasTextureKey.length = 0;
			_inAtlasTextureBitmapValue.length = 0;
			_inAtlasTextureOriUVValue.length = 0;
			_InAtlasWebGLImagesKey.length = 0;
			_InAtlasWebGLImagesOffsetValue.length = 0;
		}
		
		public function dispose():void {
			clear();
			_atlasCanvas.dispose();
		}
	}
}