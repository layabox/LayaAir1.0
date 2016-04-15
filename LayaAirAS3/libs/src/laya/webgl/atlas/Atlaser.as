package laya.webgl.atlas {
	import laya.resource.Texture;
	import laya.webgl.resource.WebGLCanvas;
	import laya.webgl.resource.WebGLCharImage;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.WebGL;
	import laya.webgl.resource.WebGLSubImage;
	
	public class Atlaser extends AtlasGrid {
		private var _atlasCanvas:AtlasWebGLCanvas;
		private var _inAtlasTextureKey:Vector.<Texture>;
		private var _inAtlasTextureValue:Vector.<Texture>;
		private var _webGLImages:Vector.<WebGLImage>;
		
		public function get texture():AtlasWebGLCanvas {
			return _atlasCanvas;
		}
		
		public function get webGLImages():Vector.<WebGLImage> {
			return _webGLImages;
		}
		
		public function Atlaser(gridNumX:int, gridNumY:int, width:int, height:int, atlasID:uint) {
			super(gridNumX, gridNumY, atlasID);
			_inAtlasTextureKey = new Vector.<Texture>();
			_inAtlasTextureValue = new Vector.<Texture>();
			_webGLImages = new Vector.<WebGLImage>();/*WebGLImage或WebGLCanvas*/
			_atlasCanvas = new AtlasWebGLCanvas();
			_atlasCanvas.width = width;
			_atlasCanvas.height = height;
			_atlasCanvas.activeResource();
		}
		
		/**
		 *
		 * @param	inAtlasRes
		 * @return  是否已经存在队列中
		 */
		public function addToAtlasTexture(bitmap:*/*WebGLImage或WebGLCanvas*/, offsetX:int, offsetY:int):void {
			(bitmap is WebGLImage) && (_webGLImages.push(bitmap));
			bitmap.offsetX = offsetX;//存储在大图合集中的X偏移位置
			bitmap.offsetY = offsetY;//存储在大图合集中的Y偏移位置
			//if (bitmap is  WebGLSubImage)//临时
			//_atlasCanvas.texSubImage2DPixel(bitmap, offsetX,/* width, height, AtlasManager.BOARDER_TYPE_ALL, 1, 1*/ offsetY,bitmap.width,bitmap.height, bitmap.imageData);
			//else
			_atlasCanvas.texSubImage2D(bitmap, offsetX,/* width, height, AtlasManager.BOARDER_TYPE_ALL, 1, 1*/ offsetY, bitmap.image || bitmap.canvas);
			(bitmap is WebGLImage) && (bitmap._image = null);
			(bitmap is WebGLCharImage) &&(bitmap.canvas= null);//_canvas为复用暂不清空
			(bitmap is WebGLSubImage) &&(bitmap.canvas= null);//_canvas为复用暂不清空
		}
		
		public function addToAtlas(inAtlasRes:Texture):void {
			_inAtlasTextureKey.push(inAtlasRes);
			_inAtlasTextureValue.push(inAtlasRes.bitmap);
			inAtlasRes.bitmap = _atlasCanvas;
		}
		
		public function clear():void {
			for (var i:int = 0, n:int = _inAtlasTextureKey.length; i < n; i++) {
				_inAtlasTextureKey[i].bitmap = _inAtlasTextureValue[i];//恢复原始bitmap
				_inAtlasTextureKey[i].bitmap.releaseResource();//待测试
			}
			
			_inAtlasTextureKey.length = 0;
			_inAtlasTextureValue.length = 0;
			_webGLImages.length = 0;
		}
		
		public function destroy():void {
			clear();
			_atlasCanvas.releaseResource();
		}
	}
}