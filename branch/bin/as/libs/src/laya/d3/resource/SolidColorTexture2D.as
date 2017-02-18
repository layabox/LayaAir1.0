package laya.d3.resource {
	import laya.d3.math.Vector4;
	import laya.d3.utils.Size;
	import laya.events.Event;
	import laya.maths.Arith;
	import laya.net.Loader;
	import laya.resource.Bitmap;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.WebGLImage;
	
	/**
	 * <code>SolidColorTexture2D</code> 二维纯色纹理。
	 */
	public class SolidColorTexture2D extends BaseTexture {
		/**洋红色纯色纹理。*/
		public static var magentaTexture:SolidColorTexture2D = new SolidColorTexture2D(new Vector4(1.0, 0.0, 1.0, 1.0));
		/**灰色纯色纹理。*/
		public static var grayTexture:SolidColorTexture2D = new SolidColorTexture2D(new Vector4(0.5, 0.5, 0.5, 1.0));
		
		private var _color:Vector4;
		private var _pixels:Uint8Array;
		
		override public function get source():* {
			return super.source;
		}
		
		/**
		 * 创建一个 <code>SolidColorTexture2D</code> 实例。
		 */
		public function SolidColorTexture2D(color:Vector4) {
			super();
			_width = 1;
			_height = 1;
			_size = new Size(width, height);
			_color = color;
			_pixels = new Uint8Array([color.x * 255, color.y * 255, color.z * 255, color.w * 255]);
		}
		
		/**
		 * @private
		 */
		private function _createWebGlTexture():void {
			var gl:WebGLContext = WebGL.mainContext;
			var glTex:* = _source = gl.createTexture();
			var w:int = _width;
			var h:int = _height;
			
			var preTarget:* = WebGLContext.curBindTexTarget;
			var preTexture:* = WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, glTex);
			
			gl.texImage2D(WebGLContext.TEXTURE_2D, 0, WebGLContext.RGBA, w, h, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _pixels);
			
			var minFifter:int = this._minFifter;
			var magFifter:int = this._magFifter;
			var repeat:int = this._repeat ? WebGLContext.REPEAT : WebGLContext.CLAMP_TO_EDGE;
			
			var isPot:Boolean = Arith.isPOT(w, h);//提前修改内存尺寸，忽悠异步影响
			if (isPot) {
				if (this._mipmap)
					(minFifter !== -1) || (minFifter = WebGLContext.LINEAR_MIPMAP_LINEAR);
				else
					(minFifter !== -1) || (minFifter = WebGLContext.LINEAR);
				
				(magFifter !== -1) || (magFifter = WebGLContext.LINEAR);
				
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MIN_FILTER, minFifter);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MAG_FILTER, magFifter);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_S, repeat);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_T, repeat);
				this._mipmap && gl.generateMipmap(WebGLContext.TEXTURE_2D);
			} else {
				(minFifter !== -1) || (minFifter = WebGLContext.LINEAR);
				(magFifter !== -1) || (magFifter = WebGLContext.LINEAR);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MIN_FILTER, minFifter);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MAG_FILTER, magFifter);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_S, WebGLContext.CLAMP_TO_EDGE);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_T, WebGLContext.CLAMP_TO_EDGE);
			}
			(preTarget && preTexture) && (WebGLContext.bindTexture(gl, preTarget, preTexture));
			
			if (isPot)
				memorySize = w * h * 4 * (1 + 1 / 3);//使用mipmap则在原来的基础上增加1/3
			else
				memorySize = w * h * 4;
		}
		
		/**
		 * 重新创建资源，如果异步创建中被强制释放再创建，则需等待释放完成后再重新加载创建。
		 */
		override protected function recreateResource():void {
			startCreate();
			_createWebGlTexture();
			completeCreate();//处理创建完成后相关操作
		}
		
		/**
		 * 销毁资源。
		 */
		override protected function detoryResource():void {
			if (_source) {
				WebGL.mainContext.deleteTexture(_source);
				_source = null;
				memorySize = 0;
			}
		}
	
	}

}