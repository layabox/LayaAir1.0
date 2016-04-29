package laya.webgl.atlas {
	import laya.resource.Bitmap;
	import laya.utils.Stat;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	public class AtlasWebGLCanvas extends Bitmap {
		/***
		 * 设置图片宽度
		 * @param value 图片宽度
		 */
		public function set width(value:Number):void {
			_w = value;
		}
		
		/***
		 * 设置图片高度
		 * @param value 图片高度
		 */
		public function set height(value:Number):void {
			_h = value;
		}
		
		public function AtlasWebGLCanvas() {
			super();
		}
		
		/***重新创建资源*/
		override protected function recreateResource():void {
			startCreate();
			var gl:WebGLContext = WebGL.mainContext;
			var glTex:* = _source = gl.createTexture();
			gl.bindTexture(WebGLContext.TEXTURE_2D, glTex);
			gl.texImage2D(WebGLContext.TEXTURE_2D, 0, WebGLContext.RGBA, _w, _h, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, null);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MIN_FILTER, WebGLContext.LINEAR);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MAG_FILTER, WebGLContext.LINEAR);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_S, WebGLContext.CLAMP_TO_EDGE);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_T, WebGLContext.CLAMP_TO_EDGE);
			gl.bindTexture(WebGLContext.TEXTURE_2D, null);
			memorySize = _w * _h * 4;
			compoleteCreate();
		}
		
		/***销毁资源*/
		override protected function detoryResource():void {
			if (_source) {
				WebGL.mainContext.deleteTexture(_source);
				_source = null;
				memorySize = 0;
			}
		}
		
		/**采样image到WebGLTexture的一部分*/
		public function texSubImage2D(source:Bitmap, xoffset:Number, yoffset:Number, bitmap:*):void {
			var gl:WebGLContext = WebGL.mainContext;
			gl.bindTexture(WebGLContext.TEXTURE_2D, _source);
			//由于HTML5中Image不能直接获取像素素数,只能先画到Canvas上再取出像素数据，再分别texSubImage2D四个边缘（包含一次行列转换），性能可能低于直接texSubImage2D整张image，
			//实测76*59的image此函数耗时1.2毫秒
			(xoffset - 1 >= 0) && (gl.texSubImage2D(WebGLContext.TEXTURE_2D, 0, xoffset - 1, yoffset, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, bitmap));
			(xoffset + 1 <= source.width) && (gl.texSubImage2D(WebGLContext.TEXTURE_2D, 0, xoffset + 1, yoffset, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, bitmap));
			(yoffset - 1 >= 0) && (gl.texSubImage2D(WebGLContext.TEXTURE_2D, 0, xoffset, yoffset - 1, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, bitmap));
			(yoffset + 1 <= source.height) && (gl.texSubImage2D(WebGLContext.TEXTURE_2D, 0, xoffset, yoffset + 1, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, bitmap));
			gl.texSubImage2D(WebGLContext.TEXTURE_2D, 0, xoffset, yoffset, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, bitmap);
			gl.bindTexture(WebGLContext.TEXTURE_2D, null);
		}
		
		/**采样image到WebGLTexture的一部分*/
		public function texSubImage2DPixel(source:AtlasWebGLCanvas, xoffset:Number, yoffset:Number, width:int, height:int, pixel:*):void {
			var gl:WebGLContext = WebGL.mainContext;
			gl.bindTexture(WebGLContext.TEXTURE_2D, _source);
			////由于HTML5中Image不能直接获取像素素数,只能先画到Canvas上再取出像素数据，再分别texSubImage2D四个边缘（包含一次行列转换），性能可能低于直接texSubImage2D整张image，
			////实测76*59的image此函数耗时1.2毫秒
			//(xoffset - 1 >= 0) && (gl.texSubImage2D(WebGLContext.TEXTURE_2D, 0, xoffset - 1, yoffset, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, bitmap));
			//(xoffset + 1 <= source.width) && (gl.texSubImage2D(WebGLContext.TEXTURE_2D, 0, xoffset + 1, yoffset, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, bitmap));
			//(yoffset - 1 >= 0) && (gl.texSubImage2D(WebGLContext.TEXTURE_2D, 0, xoffset, yoffset - 1, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, bitmap));
			//(yoffset + 1 <= source.height) && (gl.texSubImage2D(WebGLContext.TEXTURE_2D, 0, xoffset, yoffset + 1, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, bitmap));
			var pixels:Uint8Array = new Uint8Array(pixel.data);
			gl.texSubImage2D(WebGLContext.TEXTURE_2D, 0, xoffset, yoffset, width, height, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, pixels);
			gl.bindTexture(WebGLContext.TEXTURE_2D, null);
		}
	}
}