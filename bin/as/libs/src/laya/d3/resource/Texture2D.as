package laya.d3.resource {
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
	 * <code>Texture2D</code> 二维纹理。
	 */
	public class Texture2D extends BaseTexture {
		/**
		 * 加载Texture2D。
		 * @param url Texture2D地址。
		 */
		public static function load(url:String):Texture2D {
			return Laya.loader.create(url, null, null, Texture2D);
		}
		
		/**@private 文件路径全名。*/
		private var _src:String;
		/**@private HTML Image*/
		private var _image:*;
		/**@private 异步加载锁*/
		private var _recreateLock:Boolean = false;
		/**@private 异步加载完成后是否需要释放（有可能在恢复过程中,再次被释放，用此变量做标记）*/
		private var _needReleaseAgain:Boolean = false;
		
		/**
		 * 获取文件路径全名。
		 */
		public function get src():String {
			return _src;
		}
		
		/**
		 * 创建一个 <code>Texture2D</code> 实例。
		 */
		public function Texture2D() {
			super();
		}
		
		/**
		 * @private
		 */
		private function _onTextureLoaded(img:*):void {
			_image = img;
			var w:int = img.width;
			var h:int = img.height;
			_width = w;
			_height = h;
			_size = new Size(w, h);
		}
		
		/**
		 * @private
		 */
		private function _createWebGlTexture():void {
			if (!_image) {
				throw "create GLTextur err:no data:" + _image;
			}
			
			var gl:WebGLContext = WebGL.mainContext;
			var glTex:* = _source = gl.createTexture();
			var w:int = _width;
			var h:int = _height;
			
			var preTarget:* = WebGLContext.curBindTexTarget;
			var preTexture:* = WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, glTex);
			gl.texImage2D(WebGLContext.TEXTURE_2D, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _image);
			
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
			_image.onload = null;
			//_image = null;//TODO:临时
			
			if (isPot)
				memorySize = w * h * 4 * (1 + 1 / 3);//使用mipmap则在原来的基础上增加1/3
			else
				memorySize = w * h * 4;
			_recreateLock = false;
		}
		
		/**
		 * 重新创建资源，如果异步创建中被强制释放再创建，则需等待释放完成后再重新加载创建。
		 */
		override protected function recreateResource():void {
			if (_src == null || _src === "")
				return;
			
			_needReleaseAgain = false;
			if (!_image) {
				_recreateLock = true;
				startCreate();
				var _this:Texture2D = this;
				_image = new Browser.window.Image();
				_image.crossOrigin = "";
				_image.onload = function():void {
					if (_this._needReleaseAgain)//异步处理，加载完后可能，如果强制释放资源存在已被释放的风险
					{
						_this._needReleaseAgain = false;
						_this._image.onload = null;
						_this._image = null;
						return;
					}
					_this._createWebGlTexture();
					
					_this.completeCreate();//处理创建完成后相关操作
				};
				_image.src = _src;
			} else {
				if (_recreateLock) {
					return;
				}
				startCreate();
				_createWebGlTexture();
				completeCreate();//处理创建完成后相关操作
			}
		}
		
		/**
		 *@private
		 */
		override public function onAsynLoaded(url:String, data:*):void {
			_src = url;
			_onTextureLoaded(data);
			if (_conchTexture) //NATIVE
				_conchTexture.setTexture2DImage(_image);
			else
				activeResource();
			_loaded = true;
			event(Event.LOADED, this);
		}
		
		///**
		 //* 返回图片像素。
		 //* @return 图片像素。
		 //*/
		//public function getPixels():Float32Array
		//{
			//var pixeles:Float32Array = new Float32Array(_width * _height);
			//
			//var rendertexture:RenderTexture = new RenderTexture(_width, _height);
			//rendertexture.start();
			//rendertexture.end();
			//
			//return  pixeles;
		//}
		
		/**
		 * 销毁资源。
		 */
		override protected function detoryResource():void {
			if (_recreateLock) {
				_needReleaseAgain = true;
			}
			if (_source) {
				WebGL.mainContext.deleteTexture(_source);
				_source = null;
				_image = null;
				memorySize = 0;
			}
		}
	
	}

}