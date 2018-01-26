package laya.d3.resource {
	import laya.d3.utils.Size;
	import laya.events.Event;
	import laya.maths.Arith;
	import laya.utils.Browser;
	import laya.utils.Byte;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
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
		
		/** @private */
		private var _canRead:Boolean;
		/**@private HTML Image*/
		private var _image:*;
		/** @private */
		private var _pixels:Uint8Array;
		
		/** @private */
		public function get _src():String {//兼容接口
			return url;
		}
		
		/** @private */
		public function get src():String {//兼容接口
			return url;
		}
		
		/**
		 * 创建一个 <code>Texture2D</code> 实例。
		 */
		public function Texture2D(canRead:Boolean = false, reapeat:Boolean = true, format:int = WebGLContext.RGBA, mipmap:Boolean = true) {
			super();
			_type = WebGLContext.TEXTURE_2D;
			_repeat = reapeat;
			_canRead = canRead;
			_format = format;
			_mipmap = mipmap;
		}
		
		/**
		 * @private
		 */
		private function _createWebGlTexture():void {
			if (!_image)
				throw "create GLTextur err:no data:" + _image;
			
			var gl:WebGLContext = WebGL.mainContext;
			var glTexture:* = _source = gl.createTexture();
			var w:int = _width;
			var h:int = _height;
			var preTarget:* = WebGLContext.curBindTexTarget;
			var preTexture:* = WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl, _type, glTexture);
			//for (var k:* in WebGL.compressEtc1){
			//alert(k+" "+WebGL.compressEtc1[k]);
			//}
			switch (_format) {
			case WebGLContext.RGB: 
			case WebGLContext.RGBA: 
				if (_canRead)
					gl.texImage2D(_type, 0, _format, w, h, 0, _format, WebGLContext.UNSIGNED_BYTE, _pixels);//TODO:JPG无需使用alpha通道
				else
					gl.texImage2D(_type, 0, _format, _format, WebGLContext.UNSIGNED_BYTE, _image);//TODO:JPG无需使用alpha通道
				break;
			case WebGL.compressEtc1.COMPRESSED_RGB_ETC1_WEBGL: 
				gl.compressedTexImage2D(_type, 0, _format, _width, _height, 0, _image);
				break;
			}
			
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
				
				gl.texParameteri(_type, WebGLContext.TEXTURE_MIN_FILTER, minFifter);
				gl.texParameteri(_type, WebGLContext.TEXTURE_MAG_FILTER, magFifter);
				gl.texParameteri(_type, WebGLContext.TEXTURE_WRAP_S, repeat);
				gl.texParameteri(_type, WebGLContext.TEXTURE_WRAP_T, repeat);
				this._mipmap && gl.generateMipmap(_type);
			} else {
				(minFifter !== -1) || (minFifter = WebGLContext.LINEAR);
				(magFifter !== -1) || (magFifter = WebGLContext.LINEAR);
				gl.texParameteri(_type, WebGLContext.TEXTURE_MIN_FILTER, minFifter);
				gl.texParameteri(_type, WebGLContext.TEXTURE_MAG_FILTER, magFifter);
				gl.texParameteri(_type, WebGLContext.TEXTURE_WRAP_S, WebGLContext.CLAMP_TO_EDGE);
				gl.texParameteri(_type, WebGLContext.TEXTURE_WRAP_T, WebGLContext.CLAMP_TO_EDGE);
			}
			(preTarget && preTexture) && (WebGLContext.bindTexture(gl, preTarget, preTexture));
			_image.onload = null;
			_image = null;
			
			if (isPot)
				memorySize = w * h * 4 * (1 + 1 / 3);//使用mipmap则在原来的基础上增加1/3
			else
				memorySize = w * h * 4;
		}
		
		/**
		 * 重新创建资源，如果异步创建中被强制释放再创建，则需等待释放完成后再重新加载创建。
		 */
		override protected function recreateResource():void {
			_createWebGlTexture();
			completeCreate();//处理创建完成后相关操作
		}
		
		/**
		 *@private
		 */
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			if (params) {
				var canRead:* = params[0];
				(canRead!==undefined) && (_canRead = canRead);
				var repeat:* = params[1];
				(repeat!==undefined) && (_repeat = repeat);
				var format:* = params[2];
				(format!==undefined) && (_format = format);
				var mipmap:* = params[3];
				(mipmap !== undefined) && (_mipmap = mipmap);
			}
			switch (_format) {
			case WebGLContext.RGB: 
			case WebGLContext.RGBA: 
				_image = data;
				var w:int = data.width;
				var h:int = data.height;
				_width = w;
				_height = h;
				_size = new Size(w, h);
				if (_canRead) {
					Browser.canvas.size(w, h);
					Browser.canvas.clear();
					Browser.context.drawImage(data, 0, 0, w, h);
					_pixels = new Uint8Array(Browser.context.getImageData(0, 0, w, h).data.buffer);//TODO:如果为RGB,会错误
				}
				break;
			case WebGL.compressEtc1.COMPRESSED_RGB_ETC1_WEBGL: 
				var readData:Byte = new Byte(data);
				var magicNumber:String = readData.readUTFBytes(4);
				var version:String = readData.readUTFBytes(2);
				var dataType:int = readData.getInt16();
				readData.endian = Byte.BIG_ENDIAN;
				_width = readData.getInt16();//extendWidth
				_height = readData.getInt16();//extendHeight
				_size = new Size(_width, _height);
				var originalWidth:int = readData.getInt16();
				var originalHeight:int = readData.getInt16();
				_image = new Uint8Array(data, readData.pos);
					//if (_canRead)//TODO:取像素问题
					//_pixels = _image;
			}
			
			recreateResource();
			_endLoaded();
		}
		
		/**
		 * 返回图片像素。
		 * @return 图片像素。
		 */
		public function getPixels():Uint8Array {
			if (_canRead)
				return _pixels;
			else
				throw new Error("Texture2D: must set texture canRead is true.");
		}
		
		/**
		 * 销毁资源。
		 */
		override protected function disposeResource():void {
			if (_source) {
				WebGL.mainContext.deleteTexture(_source);
				_source = null;
				_image = null;
				memorySize = 0;
			}
		}
	
	}

}