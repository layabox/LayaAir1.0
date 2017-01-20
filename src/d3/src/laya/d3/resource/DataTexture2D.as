package laya.d3.resource {
	import laya.d3.utils.Size;
	import laya.events.Event;
	import laya.maths.Arith;
	import laya.net.Loader;
	import laya.resource.Bitmap;
	import laya.ui.Image;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.Utils;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.WebGLImage;
	
	public class DataTexture2D extends BaseTexture {
		/**
		 * 加载Texture2D。
		 * @param url Texture2D地址。
		 */
		public static function load(url:String, w:int, h:int, magfilter:int, minfilter:int):DataTexture2D {
			var extension:String = Utils.getFileExtension(url);
			if (extension === 'mipmaps') {
				return Laya.loader.create(url, null, null, DataTexture2D, [function(data:ArrayBuffer) {
					this._mipmaps = [];
					this.mipmap = false;
					var iinfo = new Uint32Array(data);
					this._width = iinfo[0];
					this._height = iinfo[1];
					var curw:int = this._width;
					var curh:int = this._height;
					var cursz = 8;
					while (true) {
						var curbufsz = curw * curh * 4;
						if (cursz + curbufsz > data.byteLength) {
							throw "load mipmaps data size error ";
						}
						var tbuf = new Uint8Array(data, cursz,curbufsz);
						this._mipmaps.push(tbuf);
						cursz += curbufsz;
						if (curw == 1 && curh == 1) {
							break;
						}
						curw /= 2;
						curh /= 2;
						if (curw < 1) curw = 1;
						if (curh < 1) curh = 1;
					}
					return null;
				}]);
			}
			else if( typeof(w)=='number'){
				return Laya.loader.create(url, null, null, DataTexture2D, [function(data){
					this._width = w;
					this._height = h;
					this._buffer = data;
					return null;
				}]);
			}else if (typeof(w) == 'function') {
				return Laya.loader.create(url, null, null, DataTexture2D, [w]);	
			}
		}
		
		/**@private 文件路径全名。*/
		private var _src:String;
		/**@private Imagedata */
		private var _buffer:ArrayBuffer;
		private var _mipmaps:Array;
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
		public function DataTexture2D() {
			super();
		}
		
		/**
		 * @private
		 */
		private function _onTextureLoaded(buff:ArrayBuffer):void {
			/*
			this._buffer = buff;
			var w:int = img.width;
			var h:int = img.height;
			_width = w;
			_height = h;
			_size = new Size(w, h);
			*/
		}
		
		/**
		 * @private
		 */
		private function _createWebGlTexture():void {
			if (!_buffer && !_mipmaps)
				throw "create GLTextur err:no data";
			
			var gl:WebGLContext = WebGL.mainContext;
			//var exts =  gl.getSupportedExtensions();
			gl.getExtension("EXT_shader_texture_lod");
			var glTexture:* = _source = gl.createTexture();
			var w:int = _width;
			var h:int = _height;
			
			var preTarget:* = WebGLContext.curBindTexTarget;
			var preTexture:* = WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, glTexture);
			
			if (this._mipmaps) {
				var cw:int = this._width;
				var ch:int = this._height;
				for (var i:int = 0; i < this._mipmaps.length; i++) {
					if (_mipmaps[i].byteLength != cw * ch * 4) {
						throw	"mipmap size error  level:"+i;
					}
					gl.texImage2D(WebGLContext.TEXTURE_2D, i, WebGLContext.RGBA, cw, ch, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, new Uint8Array(_mipmaps[i]));
					cw /= 2;
					ch /= 2;
					if (cw < 1) cw = 1;
					if (ch < 1) ch = 1;
				}
				this.mipmap = false;
			}
			else{
				gl.texImage2D(WebGLContext.TEXTURE_2D, 0, WebGLContext.RGBA, w, h, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, new Uint8Array(_buffer));
			}
			
			var minFifter:int = this._minFifter;
			var magFifter:int = this._magFifter;
			var repeat:int = this._repeat ? WebGLContext.REPEAT : WebGLContext.CLAMP_TO_EDGE;
			
			var isPot:Boolean = Arith.isPOT(w, h);//提前修改内存尺寸，忽悠异步影响
			if (isPot) {
				if (this._mipmap || this._mipmaps)
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
				throw "data texture must be POT";
			}
			(preTarget && preTexture) && (WebGLContext.bindTexture(gl, preTarget, preTexture));
			//TODO 需要删除原始数据么
			this._buffer = null;
			
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
			if (!_buffer && !_mipmaps) {
				_recreateLock = true;
				startCreate();
				var _this:Texture2D = this;
				//TODO 怎么恢复
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
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			var imgdata;//width,height,data
			if (params) {
				imgdata = params[0].call(this,data);
			}
			if (imgdata) {
				this._width = imgdata.width;
				this._height = imgdata.height;
				this._buffer = imgdata.data;
			}
			_src = url;
			_size = new Size(this._width, this._height);
			if (_conchTexture) {//NATIVE
				//_conchTexture.setTexture2DImage(_image);
				throw '怎么给runtime传递datatexture数据';
			}
			else
				activeResource();
			
			_loaded = true;
			event(Event.LOADED, this);
		}
		
		/**
		 * 返回图片像素。
		 * @return 图片像素。
		 */
		public function getPixels():Uint8Array {
			return this._buffer;
		}
		
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
				_buffer = null;
				memorySize = 0;
			}
		}
	
	}

}

