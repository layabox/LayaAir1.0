package laya.d3.resource {
	import laya.layagl.LayaGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.BaseTexture;
	import laya.webgl.resource.Texture2D;
	
	/**
	 //* <code>RenderTexture</code> 类用于创建渲染目标。
	 */
	public class RenderTexture extends BaseTexture {
		/** @private */
		private static var _currentActive:RenderTexture;
		
		/**
		 * 获取当前激活的Rendertexture
		 */
		public static function get currentActive():RenderTexture {
			return _currentActive;
		}
		
		/** @private */
		private var _frameBuffer:*;
		/** @private */
		private var _depthStencilBuffer:*;
		/** @private */
		private var _depthStencilFormat:int;
		
		/**
		 * 获取深度格式。
		 *@return 深度格式。
		 */
		public function get depthStencilFormat():int {
			return _depthStencilFormat;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get defaulteTexture():BaseTexture {
			return Texture2D.grayTexture;
		}
		
		/**
		 * @param width  宽度。
		 * @param height 高度。
		 * @param format 纹理格式。
		 * @param depthStencilFormat 深度格式。
		 * 创建一个 <code>RenderTexture</code> 实例。
		 */
		public function RenderTexture(width:Number, height:Number, format:int = FORMAT_R8G8B8, depthStencilFormat:int = BaseTexture.FORMAT_DEPTH_16) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super(format, false);
			_glTextureType = WebGLContext.TEXTURE_2D;
			_width = width;
			_height = height;
			_depthStencilFormat = depthStencilFormat;
			_create(width, height);
		}
		
		/**
		 * @private
		 */
		private function _create(width:int, height:int):void {
			var gl:WebGLContext = LayaGL.instance;
			_frameBuffer = gl.createFramebuffer();
			WebGLContext.bindTexture(gl, _glTextureType, _glTexture);
			var glFormat:int = _getGLFormat();
			gl.texImage2D(_glTextureType, 0, glFormat, width, height, 0, glFormat, WebGLContext.UNSIGNED_BYTE, null);
			_setGPUMemory(width * height * 4);
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, _frameBuffer);
			gl.framebufferTexture2D(WebGLContext.FRAMEBUFFER, WebGLContext.COLOR_ATTACHMENT0, WebGLContext.TEXTURE_2D, _glTexture, 0);
			if (_depthStencilFormat !== BaseTexture.FORMAT_DEPTHSTENCIL_NONE) {
				_depthStencilBuffer = gl.createRenderbuffer();
				gl.bindRenderbuffer(WebGLContext.RENDERBUFFER, _depthStencilBuffer);
				switch (_depthStencilFormat) {
				case BaseTexture.FORMAT_DEPTH_16: 
					gl.renderbufferStorage(WebGLContext.RENDERBUFFER, WebGLContext.DEPTH_COMPONENT16, width, height);
					gl.framebufferRenderbuffer(WebGLContext.FRAMEBUFFER, WebGLContext.DEPTH_ATTACHMENT, WebGLContext.RENDERBUFFER, _depthStencilBuffer);
					break;
				case BaseTexture.FORMAT_STENCIL_8: 
					gl.renderbufferStorage(WebGLContext.RENDERBUFFER, WebGLContext.STENCIL_INDEX8, width, height);
					gl.framebufferRenderbuffer(WebGLContext.FRAMEBUFFER, WebGLContext.STENCIL_ATTACHMENT, WebGLContext.RENDERBUFFER, _depthStencilBuffer);
					break;
				case BaseTexture.FORMAT_DEPTHSTENCIL_16_8: 
					gl.renderbufferStorage(WebGLContext.RENDERBUFFER, WebGLContext.DEPTH_STENCIL, width, height);
					gl.framebufferRenderbuffer(WebGLContext.FRAMEBUFFER, WebGLContext.DEPTH_STENCIL_ATTACHMENT, WebGLContext.RENDERBUFFER, _depthStencilBuffer);
					break;
				default: 
					throw "RenderTexture: unkonw depth format.";
				}
			}
			
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, null);
			gl.bindRenderbuffer(WebGLContext.RENDERBUFFER, null);
			
			_setWarpMode(WebGLContext.TEXTURE_WRAP_S, _wrapModeU);
			_setWarpMode(WebGLContext.TEXTURE_WRAP_T, _wrapModeV);
			_setFilterMode(_filterMode);
			_setAnisotropy(_anisoLevel);
			
			_readyed = true;
			_activeResource();
		}
		
		/**
		 * 生成mipMap。
		 */
		public function generateMipmap():void {
			if (_isPot(width) && _isPot(height)) {
				_mipmap = true;
				LayaGL.instance.generateMipmap(_glTextureType);
				_setFilterMode(_filterMode);
				_setGPUMemory(width * height * 4 * (1 + 1 / 3));
			} else {
				_mipmap = false;
				_setGPUMemory(width * height * 4 * (1 + 1 / 3));
			}
		}
		
		/**
		 * 开始绑定。
		 */
		public function start():void {
			LayaGL.instance.bindFramebuffer(WebGLContext.FRAMEBUFFER, _frameBuffer);
			_currentActive = this;
			_readyed = false;
		}
		
		/**
		 * 结束绑定。
		 */
		public function end():void {
			LayaGL.instance.bindFramebuffer(WebGLContext.FRAMEBUFFER, null);
			_currentActive = null;
			_readyed = true;
		}
		
		/**
		 * 获得像素数据。
		 * @param x X像素坐标。
		 * @param y Y像素坐标。
		 * @param width 宽度。
		 * @param height 高度。
		 * @return 像素数据。
		 */
		public function getData(x:Number, y:Number, width:Number, height:Number,out:Uint8Array):Uint8Array {//TODO:检查长度
			var gl:WebGLContext = LayaGL.instance;
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, _frameBuffer);
			var canRead:Boolean = (gl.checkFramebufferStatus(WebGLContext.FRAMEBUFFER) === WebGLContext.FRAMEBUFFER_COMPLETE);
			
			if (!canRead) {
				gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, null);
				return null;
			}
			gl.readPixels(x, y, width, height, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, out);
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, null);
			return out;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _disposeResource():void {
			if (_frameBuffer) {
				var gl:WebGLContext = LayaGL.instance;
				gl.deleteTexture(_glTexture);
				gl.deleteFramebuffer(_frameBuffer);
				gl.deleteRenderbuffer(_depthStencilBuffer);
				_glTexture = null;
				_frameBuffer = null;
				_depthStencilBuffer = null;
				_setGPUMemory(0);
			}
		}
	
	}

}
