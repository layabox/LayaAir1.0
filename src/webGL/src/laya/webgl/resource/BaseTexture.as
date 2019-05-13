package laya.webgl.resource {
	import laya.layagl.LayaGL;
	import laya.renders.Render;
	import laya.resource.Bitmap;
	import laya.resource.Resource;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>BaseTexture</code> 纹理的父类，抽象类，不允许实例。
	 */
	public class BaseTexture extends Bitmap {
		/** @private */
		public static const WARPMODE_REPEAT:int = 0;
		/** @private */
		public static const WARPMODE_CLAMP:int = 1;
		
		/**寻址模式_重复。*/
		public static const FILTERMODE_POINT:int = 0;
		/**寻址模式_不循环。*/
		public static const FILTERMODE_BILINEAR:int = 1;
		/**寻址模式_不循环。*/
		public static const FILTERMODE_TRILINEAR:int = 2;
		
		/**纹理格式_R8G8B8。*/
		public static const FORMAT_R8G8B8:int = 0;
		/**纹理格式_R8G8B8A8。*/
		public static const FORMAT_R8G8B8A8:int = 1;
		/**纹理格式_ALPHA8。*/
		public static const FORMAT_ALPHA8:int = 2;
		/**纹理格式_DXT1。*/
		public static const FORMAT_DXT1:int = 3;
		/**纹理格式_DXT5。*/
		public static const FORMAT_DXT5:int = 4;
		/**纹理格式_ETC2RGB。*/
		public static const FORMAT_ETC1RGB:int = 5;
		///**纹理格式_ETC2RGB。*/
		//public static const FORMAT_ETC2RGB:int = 6;
		///**纹理格式_ETC2RGBA。*/
		//public static const FORMAT_ETC2RGBA:int = 7;
		/**纹理格式_ETC2RGB_PUNCHTHROUGHALPHA。*/
		//public static const FORMAT_ETC2RGB_PUNCHTHROUGHALPHA:int = 8;
		/**纹理格式_PVRTCRGB_2BPPV。*/
		public static const FORMAT_PVRTCRGB_2BPPV:int = 9;
		/**纹理格式_PVRTCRGBA_2BPPV。*/
		public static const FORMAT_PVRTCRGBA_2BPPV:int = 10;
		/**纹理格式_PVRTCRGB_4BPPV。*/
		public static const FORMAT_PVRTCRGB_4BPPV:int = 11;
		/**纹理格式_PVRTCRGBA_4BPPV。*/
		public static const FORMAT_PVRTCRGBA_4BPPV:int = 12;
		
		/**深度格式_DEPTH_16。*/
		public static const FORMAT_DEPTH_16:int = 0;
		/**深度格式_STENCIL_8。*/
		public static const FORMAT_STENCIL_8:int = 1;
		/**深度格式_DEPTHSTENCIL_16_8。*/
		public static const FORMAT_DEPTHSTENCIL_16_8:int = 2;
		/**深度格式_DEPTHSTENCIL_NONE。*/
		public static const FORMAT_DEPTHSTENCIL_NONE:int = 3;
		
		/** @private */
		protected var _readyed:Boolean;
		/** @private */
		protected var _glTextureType:int;
		/** @private */
		protected var _glTexture:*;
		/** @private */
		protected var _format:int;
		/** @private */
		protected var _mipmap:Boolean;
		/** @private */
		protected var _wrapModeU:int;
		/** @private */
		protected var _wrapModeV:int;
		/** @private */
		protected var _filterMode:int;
		/** @private */
		protected var _anisoLevel:int;
		
		/**
		 * 是否使用mipLevel
		 */
		public function get mipmap():Boolean {
			return _mipmap;
		}
		
		/**
		 * 纹理格式
		 */
		public function get format():int {
			return _format;
		}
		
		/**
		 * 获取纹理横向循环模式。
		 */
		public function get wrapModeU():int {
			return _wrapModeU;
		}
		
		/**
		 * 设置纹理横向循环模式。
		 */
		public function set wrapModeU(value:int):void {
			if (_wrapModeU !== value) {
				_wrapModeU = value;
				(_width !== -1) && (_setWarpMode(WebGLContext.TEXTURE_WRAP_S, value));
			}
		}
		
		/**
		 * 获取纹理纵向循环模式。
		 */
		public function get wrapModeV():int {
			return _wrapModeV;
		}
		
		/**
		 * 设置纹理纵向循环模式。
		 */
		public function set wrapModeV(value:int):void {
			if (_wrapModeV !== value) {
				_wrapModeV = value;
				(_height !== -1) && (_setWarpMode(WebGLContext.TEXTURE_WRAP_T, value));
			}
		}
		
		/**
		 * 缩小过滤器
		 */
		public function get filterMode():int {
			return _filterMode;
		}
		
		/**
		 * 缩小过滤器
		 */
		public function set filterMode(value:int):void {
			if (value !== _filterMode) {
				_filterMode = value;
				((_width !== -1) && (_height !== -1)) && (_setFilterMode(value));
			}
		}
		
		/**
		 * 各向异性等级
		 */
		public function get anisoLevel():int {
			return _anisoLevel;
		}
		
		/**
		 * 各向异性等级
		 */
		public function set anisoLevel(value:int):void {
			if (value !== _anisoLevel) {
				_anisoLevel = Math.max(1, Math.min(16, value));
				((_width !== -1) && (_height !== -1)) && (_setAnisotropy(value));
			}
		}
		
		/**
		 * 获取默认纹理资源。
		 */
		public function get defaulteTexture():BaseTexture {
			throw "BaseTexture:must override it."
		}
		
		/**
		 * 创建一个 <code>BaseTexture</code> 实例。
		 */
		public function BaseTexture(format:int, mipMap:Boolean) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_wrapModeU = BaseTexture.WARPMODE_REPEAT;
			_wrapModeV = BaseTexture.WARPMODE_REPEAT;
			_filterMode = BaseTexture.FILTERMODE_BILINEAR;
			
			_readyed = false;
			_width = -1;
			_height = -1;
			_format = format;
			_mipmap = mipMap;
			_anisoLevel = 1;
			_glTexture = LayaGL.instance.createTexture();
		}
		
		/**
		 * @private
		 */
		protected function _isPot(size:uint):Boolean {
			return (size & (size - 1)) === 0;
		}
		
		/**
		 * @private
		 */
		protected function _getGLFormat():int {
			var glFormat:int;
			switch (_format) {
			case FORMAT_R8G8B8: 
				glFormat = WebGLContext.RGB;
				break;
			case FORMAT_R8G8B8A8: 
				glFormat = WebGLContext.RGBA;
				break;
			case FORMAT_ALPHA8: 
				glFormat = WebGLContext.ALPHA;
				break;
			case FORMAT_DXT1: 
				if (WebGLContext._compressedTextureS3tc)
					glFormat = WebGLContext._compressedTextureS3tc.COMPRESSED_RGB_S3TC_DXT1_EXT;
				else
					throw "BaseTexture: not support DXT1 format.";
				break;
			case FORMAT_DXT5: 
				if (WebGLContext._compressedTextureS3tc)
					glFormat = WebGLContext._compressedTextureS3tc.COMPRESSED_RGBA_S3TC_DXT5_EXT;
				else
					throw "BaseTexture: not support DXT5 format.";
				break;
			case FORMAT_ETC1RGB: 
				if (WebGLContext._compressedTextureEtc1)
					glFormat = WebGLContext._compressedTextureEtc1.COMPRESSED_RGB_ETC1_WEBGL;
				else
					throw "BaseTexture: not support ETC1RGB format.";
				break;
			case FORMAT_PVRTCRGB_2BPPV: 
				if (WebGLContext._compressedTexturePvrtc)
					glFormat = WebGLContext._compressedTexturePvrtc.COMPRESSED_RGB_PVRTC_2BPPV1_IMG;
				else
					throw "BaseTexture: not support PVRTCRGB_2BPPV format.";
				break;
			case FORMAT_PVRTCRGBA_2BPPV: 
				if (WebGLContext._compressedTexturePvrtc)
					glFormat = WebGLContext._compressedTexturePvrtc.COMPRESSED_RGBA_PVRTC_2BPPV1_IMG;
				else
					throw "BaseTexture: not support PVRTCRGBA_2BPPV format.";
				break;
			case FORMAT_PVRTCRGB_4BPPV: 
				if (WebGLContext._compressedTexturePvrtc)
					glFormat = WebGLContext._compressedTexturePvrtc.COMPRESSED_RGB_PVRTC_4BPPV1_IMG;
				else
					throw "BaseTexture: not support PVRTCRGB_4BPPV format.";
				break;
			case FORMAT_PVRTCRGBA_4BPPV: 
				if (WebGLContext._compressedTexturePvrtc)
					glFormat = WebGLContext._compressedTexturePvrtc.COMPRESSED_RGBA_PVRTC_4BPPV1_IMG;
				else
					throw "BaseTexture: not support PVRTCRGBA_4BPPV format.";
				break;
			default: 
				throw "BaseTexture: unknown texture format.";
			}
			return glFormat;
		}
		
		/**
		 * @private
		 */
		protected function _setFilterMode(value:int):void {
			var gl:WebGLContext = LayaGL.instance;
			WebGLContext.bindTexture(gl, _glTextureType, _glTexture);
			switch (value) {
			case FILTERMODE_POINT: 
				if (_mipmap)
					gl.texParameteri(_glTextureType, WebGLContext.TEXTURE_MIN_FILTER, WebGLContext.NEAREST_MIPMAP_NEAREST);
				else
					gl.texParameteri(_glTextureType, WebGLContext.TEXTURE_MIN_FILTER, WebGLContext.NEAREST);
				gl.texParameteri(_glTextureType, WebGLContext.TEXTURE_MAG_FILTER, WebGLContext.NEAREST);
				break;
			case FILTERMODE_BILINEAR: 
				if (_mipmap)
					gl.texParameteri(_glTextureType, WebGLContext.TEXTURE_MIN_FILTER, WebGLContext.LINEAR_MIPMAP_NEAREST);
				else
					gl.texParameteri(_glTextureType, WebGLContext.TEXTURE_MIN_FILTER, WebGLContext.LINEAR);
				gl.texParameteri(_glTextureType, WebGLContext.TEXTURE_MAG_FILTER, WebGLContext.LINEAR);
				break;
			case FILTERMODE_TRILINEAR: 
				if (_mipmap)
					gl.texParameteri(_glTextureType, WebGLContext.TEXTURE_MIN_FILTER, WebGLContext.LINEAR_MIPMAP_LINEAR);
				else
					gl.texParameteri(_glTextureType, WebGLContext.TEXTURE_MIN_FILTER, WebGLContext.LINEAR);
				gl.texParameteri(_glTextureType, WebGLContext.TEXTURE_MAG_FILTER, WebGLContext.LINEAR);
				break;
			default: 
				throw new Error("BaseTexture:unknown filterMode value.");
			}
		}
		
		/**
		 * @private
		 */
		protected function _setWarpMode(orientation:int, mode:int):void {
			var gl:WebGLContext = LayaGL.instance;
			WebGLContext.bindTexture(gl, _glTextureType, _glTexture);
			if (_isPot(_width) && _isPot(_height)) {
				switch (mode) {
				case WARPMODE_REPEAT: 
					gl.texParameteri(_glTextureType, orientation, WebGLContext.REPEAT);
					break;
				case WARPMODE_CLAMP: 
					gl.texParameteri(_glTextureType, orientation, WebGLContext.CLAMP_TO_EDGE);
					break;
				}
			} else {
				gl.texParameteri(_glTextureType, orientation, WebGLContext.CLAMP_TO_EDGE);
			}
		}
		
		/**
		 * @private
		 */
		protected function _setAnisotropy(value:int):void {
			var anisotropic:* = WebGLContext._extTextureFilterAnisotropic;
			if (anisotropic && !Browser.onLimixiu) {
				value = Math.max(value, 1);
				var gl:WebGLContext = LayaGL.instance;
				WebGLContext.bindTexture(gl, _glTextureType, _glTexture);
				value = Math.min(gl.getParameter(anisotropic.MAX_TEXTURE_MAX_ANISOTROPY_EXT), value);
				gl.texParameterf(_glTextureType, anisotropic.TEXTURE_MAX_ANISOTROPY_EXT, value);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _disposeResource():void {
			if (_glTexture) {
				LayaGL.instance.deleteTexture(_glTexture);
				_glTexture = null;
				_setGPUMemory(0);
			}
		}
		
		/**
		 * 获取纹理资源。
		 */
		override public function _getSource():* {
			if (_readyed)
				return _glTexture;
			else
				return null;
		}
		
		/**
		 * 通过基础数据生成mipMap。
		 */
		public function generateMipmap():void {
			if (_isPot(width) && _isPot(height))
				LayaGL.instance.generateMipmap(_glTextureType);
		}
	}
}