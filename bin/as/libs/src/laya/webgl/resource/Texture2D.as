package laya.webgl.resource {
	import laya.layagl.LayaGL;
	import laya.net.Loader;
	import laya.renders.Render;
	import laya.resource.HTMLCanvas;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>Texture2D</code> 类用于生成2D纹理。
	 */
	public class Texture2D extends BaseTexture {
		/**灰色纯色纹理。*/
		public static var grayTexture:Texture2D;
		
		/**
		 * @private
		 */
		public static function __init__():void {
			var pixels:Uint8Array = new Uint8Array(3);
			pixels[0] = 128;
			pixels[1] = 128;
			pixels[2] = 128;
			grayTexture = new Texture2D(1, 1, FORMAT_R8G8B8, false, false);
			grayTexture.setPixels(pixels);
			grayTexture.lock = true;//锁住资源防止被资源管理释放
		}
		
		/**
		 * @inheritDoc
		 */
		public static function _parse(data:*, propertyParams:Object = null, constructParams:Array = null):Texture2D {
			var texture:Texture2D = constructParams ? new Texture2D(constructParams[0], constructParams[1], constructParams[2], constructParams[3], constructParams[4]) : new Texture2D(0, 0);
			if (propertyParams) {
				texture.wrapModeU = propertyParams.wrapModeU;
				texture.wrapModeV = propertyParams.wrapModeV;
				texture.filterMode = propertyParams.filterMode;
				texture.anisoLevel = propertyParams.anisoLevel;
			}
			switch (texture._format) {
			case FORMAT_R8G8B8: 
			case FORMAT_R8G8B8A8: 
				texture.loadImageSource(data);
				break;
			case FORMAT_DXT1: 
			case FORMAT_DXT5: 
			case FORMAT_ETC1RGB: 
			case FORMAT_PVRTCRGB_2BPPV: 
			case FORMAT_PVRTCRGBA_2BPPV: 
			case FORMAT_PVRTCRGB_4BPPV: 
			case FORMAT_PVRTCRGBA_4BPPV: 
				texture.setCompressData(data);
				break;
			default: 
				throw "Texture2D:unkonwn format.";
			}
			return texture;
		}
		
		/**
		 * 加载Texture2D。
		 * @param url Texture2D地址。
		 * @param complete 完成回掉。
		 */
		public static function load(url:String, complete:Handler):void {
			Laya.loader.create(url, complete, null, Loader.TEXTURE2D);
		}
		
		/** @private */
		private var _canRead:Boolean;
		/** @private */
		private var _pixels:Uint8Array;
		/** @private */
		private var _mipmapCount:int;
		
		/**
		 * 获取mipmap数量。
		 */
		public function get mipmapCount():int {
			return _mipmapCount;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get defaulteTexture():BaseTexture {
			return Texture2D.grayTexture;
		}
		
		/**
		 * 创建一个 <code>Texture2D</code> 实例。
		 * @param	width 宽。
		 * @param	height 高。
		 * @param	format 贴图格式。
		 * @param	mipmap 是否生成mipmap。
		 * @param	canRead 是否可读像素,如果为true,会在内存保留像素数据。
		 */
		public function Texture2D(width:int = 0, height:int = 0, format:int = FORMAT_R8G8B8A8, mipmap:Boolean = true, canRead:Boolean = false) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super(format, mipmap);
			_glTextureType = WebGLContext.TEXTURE_2D;
			_width = width;
			_height = height;
			_canRead = canRead;
			
			_setWarpMode(WebGLContext.TEXTURE_WRAP_S, _wrapModeU);//TODO:重置宽高需要调整
			_setWarpMode(WebGLContext.TEXTURE_WRAP_T, _wrapModeV);//TODO:重置宽高需要调整
			_setFilterMode(_filterMode);//TODO:重置宽高需要调整
			_setAnisotropy(_anisoLevel);
			
			if (_mipmap) {
				_mipmapCount = __JS__("Math.max(Math.ceil(Math.log2(width)) + 1, Math.ceil(Math.log2(2)) + 1)");
				for (var i:int = 0; i < _mipmapCount; i++)
					_setPixels(null, i, Math.max(width >> i, 1), Math.max(height >> i, 1));//初始化各级mipmap
				_setGPUMemory(width * height * 4 * (1 + 1 / 3));
			} else {
				_mipmapCount = 1;
				_setGPUMemory(width * height * 4);
			}
		}
		
		/**
		 * @private
		 */
		private function _getFormatByteCount():int {
			switch (_format) {
			case FORMAT_R8G8B8: 
				return 3;
			case FORMAT_R8G8B8A8: 
				return 4;
			case FORMAT_ALPHA8: 
				return 1;
			default: 
				throw "Texture2D: unknown format.";
			}
		}
		
		/**
		 * @private
		 */
		private function _setPixels(pixels:Uint8Array, miplevel:int, width:int, height:int):void {
			var gl:WebGLContext = LayaGL.instance;
			var textureType:int = _glTextureType;
			var glFormat:int = _getGLFormat();
			WebGLContext.bindTexture(gl, textureType, _glTexture);
			if (format === BaseTexture.FORMAT_R8G8B8) {
				gl.pixelStorei(WebGLContext.UNPACK_ALIGNMENT, 1);//字节对齐
				gl.texImage2D(textureType, miplevel, glFormat, width, height, 0, glFormat, WebGLContext.UNSIGNED_BYTE, pixels);
				gl.pixelStorei(WebGLContext.UNPACK_ALIGNMENT, 4);
			} else {
				gl.texImage2D(textureType, miplevel, glFormat, width, height, 0, glFormat, WebGLContext.UNSIGNED_BYTE, pixels);
			}
		}
		
		/**
		 * @private
		 */
		private function _calcualatesCompressedDataSize(format:int, width:int, height:int):int {
			switch (format) {
			case FORMAT_DXT1: 
			case FORMAT_ETC1RGB: 
				return ((width + 3) >> 2) * ((height + 3) >> 2) * 8;
			case FORMAT_DXT5: 
				return ((width + 3) >> 2) * ((height + 3) >> 2) * 16;
			case FORMAT_PVRTCRGB_4BPPV: 
			case FORMAT_PVRTCRGBA_4BPPV: 
				return Math.floor((Math.max(width, 8) * Math.max(height, 8) * 4 + 7) / 8);
			case FORMAT_PVRTCRGB_2BPPV: 
			case FORMAT_PVRTCRGBA_2BPPV: 
				return Math.floor((Math.max(width, 16) * Math.max(height, 8) * 2 + 7) / 8);
			default: 
				return 0;
			}
		}
		
		/**
		 * @private
		 */
		private function _pharseDDS(arrayBuffer:ArrayBuffer):void {
			const FOURCC_DXT1:int = 827611204;
			const FOURCC_DXT5:int = 894720068;
			const DDPF_FOURCC:int = 0x4;
			const DDSD_MIPMAPCOUNT:int = 0x20000;
			const DDS_MAGIC:int = 0x20534444;
			const DDS_HEADER_LENGTH:int = 31;
			const DDS_HEADER_MAGIC:int = 0;
			const DDS_HEADER_SIZE:int = 1;
			const DDS_HEADER_FLAGS:int = 2;
			const DDS_HEADER_HEIGHT:int = 3;
			const DDS_HEADER_WIDTH:int = 4;
			const DDS_HEADER_MIPMAPCOUNT:int = 7;
			const DDS_HEADER_PF_FLAGS:int = 20;
			const DDS_HEADER_PF_FOURCC:int = 21;
			
			var header:Int32Array = new Int32Array(arrayBuffer, 0, DDS_HEADER_LENGTH);
			
			if (header[DDS_HEADER_MAGIC] != DDS_MAGIC)
				throw "Invalid magic number in DDS header";
			
			if (!(header[DDS_HEADER_PF_FLAGS] & DDPF_FOURCC))
				throw "Unsupported format, must contain a FourCC code";
			
			var compressedFormat:int = header[DDS_HEADER_PF_FOURCC];
			switch (_format) {
			case FORMAT_DXT1: 
				if (compressedFormat !== FOURCC_DXT1)
					throw "the FourCC code is not same with texture format.";
				break;
			case FORMAT_DXT5: 
				if (compressedFormat !== FOURCC_DXT5)
					throw "the FourCC code is not same with texture format.";
				break;
			default: 
				throw "unknown texture format.";
			}
			
			var mipLevels:int = 1;
			if (header[DDS_HEADER_FLAGS] & DDSD_MIPMAPCOUNT) {
				mipLevels = Math.max(1, header[DDS_HEADER_MIPMAPCOUNT]);
				if (!_mipmap)
					throw "the mipmap is not same with Texture2D.";
			} else {
				if (_mipmap)
					throw "the mipmap is not same with Texture2D.";
			}
			
			var width:int = header[DDS_HEADER_WIDTH];
			var height:int = header[DDS_HEADER_HEIGHT];
			_width = width;
			_height = height;
			
			var dataOffset:int = header[DDS_HEADER_SIZE] + 4;
			_upLoadCompressedTexImage2D(arrayBuffer, width, height, mipLevels, dataOffset, 0);
		}
		
		/**
		 * @private
		 */
		private function _pharseKTX(arrayBuffer:ArrayBuffer):void {
			const ETC_HEADER_LENGTH:int = 13;
			const ETC_HEADER_FORMAT:int = 4;
			const ETC_HEADER_HEIGHT:int = 7;
			const ETC_HEADER_WIDTH:int = 6;
			const ETC_HEADER_MIPMAPCOUNT:int = 11;
			const ETC_HEADER_METADATA:int = 12;
			
			var id:Uint8Array = new Uint8Array(arrayBuffer, 0, 12);
			if (id[0] != 0xAB || id[1] != 0x4B || id[2] != 0x54 || id[3] != 0x58 || id[4] != 0x20 || id[5] != 0x31 || id[6] != 0x31 || id[7] != 0xBB || id[8] != 0x0D || id[9] != 0x0A || id[10] != 0x1A || id[11] != 0x0A)
				throw("Invalid fileIdentifier in KTX header");
			var header:Int32Array = new Int32Array(id.buffer, id.length, ETC_HEADER_LENGTH);
			var compressedFormat:int = header[ETC_HEADER_FORMAT];
			switch (compressedFormat) {
			case WebGLContext._compressedTextureEtc1.COMPRESSED_RGB_ETC1_WEBGL: 
				_format = FORMAT_ETC1RGB;
				break;
			default: 
				throw "unknown texture format.";
			}
			
			var mipLevels:int = header[ETC_HEADER_MIPMAPCOUNT];
			var width:int = header[ETC_HEADER_WIDTH];
			var height:int = header[ETC_HEADER_HEIGHT];
			_width = width;
			_height = height;
			
			var dataOffset:int = 64 + header[ETC_HEADER_METADATA];
			_upLoadCompressedTexImage2D(arrayBuffer, width, height, mipLevels, dataOffset, 4);
		}
		
		/**
		 * @private
		 */
		private function _pharsePVR(arrayBuffer:ArrayBuffer):void {
			const PVR_FORMAT_2BPP_RGB:int = 0;
			const PVR_FORMAT_2BPP_RGBA:int = 1;
			const PVR_FORMAT_4BPP_RGB:int = 2;
			const PVR_FORMAT_4BPP_RGBA:int = 3;
			const PVR_MAGIC:int = 0x03525650;
			const PVR_HEADER_LENGTH:int = 13;
			const PVR_HEADER_MAGIC:int = 0;
			const PVR_HEADER_FORMAT:int = 2;
			const PVR_HEADER_HEIGHT:int = 6;
			const PVR_HEADER_WIDTH:int = 7;
			const PVR_HEADER_MIPMAPCOUNT:int = 11;
			const PVR_HEADER_METADATA:int = 12;
			var header:Int32Array = new Int32Array(arrayBuffer, 0, PVR_HEADER_LENGTH);
			
			if (header[PVR_HEADER_MAGIC] != PVR_MAGIC)
				throw("Invalid magic number in PVR header");
			var compressedFormat:int = header[PVR_HEADER_FORMAT];
			switch (compressedFormat) {
			case PVR_FORMAT_2BPP_RGB: 
				_format = FORMAT_PVRTCRGB_2BPPV;
				break;
			case PVR_FORMAT_4BPP_RGB: 
				_format = FORMAT_PVRTCRGB_4BPPV;
				break;
			case PVR_FORMAT_2BPP_RGBA: 
				_format = FORMAT_PVRTCRGBA_2BPPV;
				break;
			case PVR_FORMAT_4BPP_RGBA: 
				_format = FORMAT_PVRTCRGBA_4BPPV;
				break;
			default: 
				throw "Texture2D:unknown PVR format.";
			}
			
			var mipLevels:int = header[PVR_HEADER_MIPMAPCOUNT];
			var width:int = header[PVR_HEADER_WIDTH];
			var height:int = header[PVR_HEADER_HEIGHT];
			_width = width;
			_height = height;
			
			var dataOffset:int = header[PVR_HEADER_METADATA] + 52;
			_upLoadCompressedTexImage2D(arrayBuffer, width, height, mipLevels, dataOffset, 0);
		}
		
		/**
		 * @private
		 */
		public function _upLoadCompressedTexImage2D(data:ArrayBuffer, width:int, height:int, miplevelCount:int, dataOffset:int, imageSizeOffset:int):void {
			var gl:WebGLContext = LayaGL.instance;
			var textureType:int = _glTextureType;
			WebGLContext.bindTexture(gl, textureType, _glTexture);
			var glFormat:int = _getGLFormat();
			var offset:int = dataOffset;
			for (var i:int = 0; i < miplevelCount; i++) {
				offset += imageSizeOffset;
				var mipDataSize:int = _calcualatesCompressedDataSize(_format, width, height);
				var mipData:Uint8Array = new Uint8Array(data, offset, mipDataSize);
				gl.compressedTexImage2D(textureType, i, glFormat, width, height, 0, mipData);
				width = Math.max(width >> 1, 1.0);
				height = Math.max(height >> 1, 1.0);
				offset += mipDataSize;
			}
			var memory:int = offset;
			_setGPUMemory(memory);
			
			//if (_canRead)
			//_pixels = pixels;
			_readyed = true;
			_activeResource();
		}
		
		/**
		 * 通过图片源填充纹理,可为HTMLImageElement、HTMLCanvasElement、HTMLVideoElement、ImageBitmap、ImageData,
		 * 设置之后纹理宽高可能会发生变化。
		 */
		public function loadImageSource(source:*, premultiplyAlpha:Boolean = false):void {
			var width:uint = source.width;
			var height:uint = source.height;
			_width = width;
			_height = height;
			if (!(_isPot(width) && _isPot(height)))
				_mipmap = false;
			_setWarpMode(WebGLContext.TEXTURE_WRAP_S, _wrapModeU);//宽高变化后需要重新设置
			_setWarpMode(WebGLContext.TEXTURE_WRAP_T, _wrapModeV);//宽高变化后需要重新设置
			_setFilterMode(_filterMode);//宽高变化后需要重新设置
			
			var gl:WebGLContext = LayaGL.instance;
			
			WebGLContext.bindTexture(gl, _glTextureType, _glTexture);
			var glFormat:int = _getGLFormat();
			
			if (Render.isConchApp) {//[NATIVE]临时
				if (source is HTMLCanvas) {
					//todo premultiply alpha
					gl.texImage2D(_glTextureType, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, source);
				}
				else {
					source.setPremultiplyAlpha(premultiplyAlpha);
					gl.texImage2D(_glTextureType, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, source);
				}
			} else {
				(premultiplyAlpha) && (gl.pixelStorei(WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL, true));
				gl.texImage2D(_glTextureType, 0, glFormat, glFormat, WebGLContext.UNSIGNED_BYTE, source);
				(premultiplyAlpha) && (gl.pixelStorei(WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL, false));
			}
			if (_mipmap) {
				gl.generateMipmap(_glTextureType);
				_setGPUMemory(width * height * 4 * (1 + 1 / 3));
			} else {
				_setGPUMemory(width * height * 4);
			}
			
			if (_canRead) {//TODO:是否所有图源都可以
				if (Render.isConchApp) {
					_pixels = new Uint8Array(source._nativeObj.getImageData(0, 0, width, height));//TODO:如果为RGB,会错误
				} else {
					Browser.canvas.size(width, height);
					Browser.canvas.clear();
					Browser.context.drawImage(source, 0, 0, width, height);
					_pixels = new Uint8Array(Browser.context.getImageData(0, 0, width, height).data.buffer);//TODO:如果为RGB,会错误
				}
			}
			_readyed = true;
			_activeResource();
		}
		
		/**
		 * 通过像素填充纹理。
		 * @param	pixels 像素。
		 * @param   miplevel 层级。
		 */
		public function setPixels(pixels:Uint8Array, miplevel:int = 0):void {
			if (!pixels)
				throw "Texture2D:pixels can't be null.";
			var width:int = Math.max(_width >> miplevel, 1);
			var height:int = Math.max(_height >> miplevel, 1);
			var pixelsCount:int = width * height * _getFormatByteCount();
			if (pixels.length < pixelsCount)
				throw "Texture2D:pixels length should at least " + pixelsCount + ".";
			_setPixels(pixels, miplevel, width, height);
			
			if (_canRead)
				_pixels = pixels;
			
			_readyed = true;
			_activeResource();
		}
		
		/**
		 * 通过像素填充部分纹理。
		 * @param  x X轴像素起点。
		 * @param  y Y轴像素起点。
		 * @param  width 像素宽度。
		 * @param  height 像素高度。
		 * @param  pixels 像素数组。
		 * @param  miplevel 层级。
		 */
		public function setSubPixels(x:int, y:int, width:int, height:int, pixels:Uint8Array, miplevel:int = 0):void {
			if (!pixels)
				throw "Texture2D:pixels can't be null.";
			
			var gl:WebGLContext = LayaGL.instance;
			var textureType:int = _glTextureType;
			WebGLContext.bindTexture(gl, textureType, _glTexture);
			var glFormat:int = _getGLFormat();
			
			if (_format === BaseTexture.FORMAT_R8G8B8) {
				gl.pixelStorei(WebGLContext.UNPACK_ALIGNMENT, 1);//字节对齐
				gl.texSubImage2D(textureType, miplevel, x, y, width, height, glFormat, WebGLContext.UNSIGNED_BYTE, pixels);
				gl.pixelStorei(WebGLContext.UNPACK_ALIGNMENT, 4);
			} else {
				gl.texSubImage2D(textureType, miplevel, x, y, width, height, glFormat, WebGLContext.UNSIGNED_BYTE, pixels);
			}
			
			//if (_canRead)
			//_pixels = pixels;//TODO:
			
			_readyed = true;
			_activeResource();
		}
		
		/**
		 * 通过压缩数据填充纹理。
		 * @param	data 压缩数据。
		 * @param   miplevel 层级。
		 */
		public function setCompressData(data:ArrayBuffer):void {
			switch (_format) {
			case FORMAT_DXT1: 
			case FORMAT_DXT5: 
				_pharseDDS(data);
				break;
			case FORMAT_ETC1RGB: 
				_pharseKTX(data);
				break;
			case FORMAT_PVRTCRGB_2BPPV: 
			case FORMAT_PVRTCRGBA_2BPPV: 
			case FORMAT_PVRTCRGB_4BPPV: 
			case FORMAT_PVRTCRGBA_4BPPV: 
				_pharsePVR(data);
				break;
			default: 
				throw "Texture2D:unkonwn format.";
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _recoverResource():void {
			//TODO:补充
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
	
	}

}