package laya.d3.resource {
	import laya.layagl.LayaGL;
	import laya.renders.Render;
	import laya.utils.Handler;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.BaseTexture;
	
	/**
	 * <code>TextureCube</code> 类用于生成立方体纹理。
	 */
	public class TextureCube extends BaseTexture {
		/**灰色纯色纹理。*/
		public static var grayTexture:TextureCube;
		
		/**
		 * @private
		 */
		public static function __init__():void {
			var pixels:Uint8Array = new Uint8Array(3);
			pixels[0] = 128;
			pixels[1] = 128;
			pixels[2] = 128;
			grayTexture = new TextureCube(FORMAT_R8G8B8, false);
			grayTexture.setSixSidePixels(1, 1, [pixels, pixels, pixels, pixels, pixels, pixels]);
			grayTexture.lock = true;//锁住资源防止被资源管理释放
		}
		
		/**
		 * @inheritDoc
		 */
		public static function _parse(data:*, propertyParams:Object = null, constructParams:Array = null):TextureCube {
			var texture:TextureCube = constructParams ? new TextureCube(constructParams[0], constructParams[1]) : new TextureCube();
			texture.setSixSideImageSources(data);
			return texture;
		}
		
		/**
		 * 加载TextureCube。
		 * @param url TextureCube地址。
		 * @param complete 完成回调。
		 */
		public static function load(url:String, complete:Handler):void {
			Laya.loader.create(url, complete, null, Laya3D.TEXTURECUBE);
		}
		
		/** @private */
		private var _premultiplyAlpha:int;
		
		/**
		 * @inheritDoc
		 */
		override public function get defaulteTexture():BaseTexture {
			return grayTexture;
		}
		
		/**
		 * 创建一个 <code>TextureCube</code> 实例。
		 * @param	format 贴图格式。
		 * @param	mipmap 是否生成mipmap。
		 */
		public function TextureCube(format:int = FORMAT_R8G8B8, mipmap:Boolean = false) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super(format, mipmap);
			_glTextureType = WebGLContext.TEXTURE_CUBE_MAP;
		}
		
		/**
		 * 通过六张图片源填充纹理。
		 * @param 图片源数组。
		 */
		public function setSixSideImageSources(source:Array, premultiplyAlpha:Boolean = false):void {
			var width:int;
			var height:int;
			for (var i:int = 0; i < 6; i++) {
				var img:*= source[i];
				if (!img){//TODO:
					trace("TextureCube: image Source can't be null.");
					return;
				}
				
				var nextWidth:int = img.width;
				var nextHeight:int = img.height;
				if (i > 0) {
					if (width !== nextWidth){
						trace("TextureCube: each side image's width and height must same.");
						return;
					}
				}
				
				width = nextWidth;
				height = nextHeight;
				if (width !== height){
					trace("TextureCube: each side image's width and height must same.");
					return;
				}
			}
			_width = width;
			_height = height;
			
			var gl:WebGLContext = LayaGL.instance;
			WebGLContext.bindTexture(gl, _glTextureType, _glTexture);
			var glFormat:int = _getGLFormat();
			
			if (!Render.isConchApp) {
				(premultiplyAlpha) && (gl.pixelStorei(WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL, true));
				gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_Z, 0, glFormat, glFormat, WebGLContext.UNSIGNED_BYTE, source[0]);//back
				gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, glFormat, glFormat, WebGLContext.UNSIGNED_BYTE, source[1]);//front
				gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_X, 0, glFormat, glFormat, WebGLContext.UNSIGNED_BYTE, source[2]);//right
				gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_X, 0, glFormat, glFormat, WebGLContext.UNSIGNED_BYTE, source[3]);//left
				gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_Y, 0, glFormat, glFormat, WebGLContext.UNSIGNED_BYTE, source[4]);//up
				gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, glFormat, glFormat, WebGLContext.UNSIGNED_BYTE, source[5]);//down
				(premultiplyAlpha) && (gl.pixelStorei(WebGLContext.UNPACK_PREMULTIPLY_ALPHA_WEBGL, false));
			} else {
				if (premultiplyAlpha == true) {
					for (var j:int = 0; j < 6; j++)
						source[j].setPremultiplyAlpha(premultiplyAlpha);
				}
				gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_Z, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, source[0]);//back
				gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, source[1]);//front
				gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_X, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, source[2]);//right
				gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_X, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, source[3]);//left
				gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_Y, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, source[4]);//up
				gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, source[5]);//down
			}
			if (_mipmap && _isPot(width) && _isPot(height)) {
				gl.generateMipmap(_glTextureType);
				_setGPUMemory(width * height * 4 * (1 + 1 / 3) * 6);
			} else {
				_setGPUMemory(width * height * 4 * 6);
			}
			
			_setWarpMode(WebGLContext.TEXTURE_WRAP_S, _wrapModeU);
			_setWarpMode(WebGLContext.TEXTURE_WRAP_T, _wrapModeV);
			_setFilterMode(_filterMode);
			_readyed = true;
			_activeResource();
		}
		
		/**
		 * 通过六张图片源填充纹理。
		 * @param 图片源数组。
		 */
		public function setSixSidePixels(width:int, height:int, pixels:Array):void {
			if (width <= 0 || height <= 0)
				throw new Error("TextureCube:width or height must large than 0.");
			
			if (!pixels)
				throw new Error("TextureCube:pixels can't be null.");
			_width = width;
			_height = height;
			
			var gl:WebGLContext = LayaGL.instance;
			WebGLContext.bindTexture(gl, _glTextureType, _glTexture);
			var glFormat:int = _getGLFormat();
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_Z, 0, glFormat, width, height, 0, glFormat, WebGLContext.UNSIGNED_BYTE, pixels[0]);//back
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, glFormat, width, height, 0, glFormat, WebGLContext.UNSIGNED_BYTE, pixels[1]);//front
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_X, 0, glFormat, width, height, 0, glFormat, WebGLContext.UNSIGNED_BYTE, pixels[2]);//right
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_X, 0, glFormat, width, height, 0, glFormat, WebGLContext.UNSIGNED_BYTE, pixels[3]);//left
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_Y, 0, glFormat, width, height, 0, glFormat, WebGLContext.UNSIGNED_BYTE, pixels[4]);//up
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, glFormat, width, height, 0, glFormat, WebGLContext.UNSIGNED_BYTE, pixels[5]);//down
			if (_mipmap && _isPot(width) && _isPot(height)) {
				gl.generateMipmap(_glTextureType);
				_setGPUMemory(width * height * 4 * (1 + 1 / 3) * 6);
			} else {
				_setGPUMemory(width * height * 4 * 6);
			}
			
			_setWarpMode(WebGLContext.TEXTURE_WRAP_S, _wrapModeU);
			_setWarpMode(WebGLContext.TEXTURE_WRAP_T, _wrapModeV);
			_setFilterMode(_filterMode);
			_readyed = true;
			_activeResource();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _recoverResource():void {
			//TODO:补充
		}
	
	}

}