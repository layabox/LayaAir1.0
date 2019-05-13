package laya.webgl.resource {
	import laya.layagl.LayaGL;
	import laya.renders.Render;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.BaseShader;
	import laya.webgl.utils.RenderState2D;
	
	/**
	 * <code>RenderTexture</code> 类用于创建渲染目标。
	 */
	public class RenderTexture2D extends BaseTexture {
		/** @private */
		private static var _currentActive:RenderTexture2D;
		private var _lastRT:RenderTexture2D;
		private var _lastWidth:Number;
		private var _lastHeight:Number;
		
		//为push,pop 用的。以后和上面只保留一份。
		//由于可能递归，所以不能简单的用save，restore
		private static var rtStack:Array = [];//rt:RenderTexture，w:int，h:int
		
		public static var defuv:Array = [0, 0, 1, 0, 1, 1, 0, 1];
		public static var flipyuv:Array = [0,1,1,1,1,0,0,0];
		/**
		 * 获取当前激活的Rendertexture
		 */
		public static function get currentActive():RenderTexture2D {
			return _currentActive;
		}
		
		/** @private */
		private var _frameBuffer:*;
		/** @private */
		private var _depthStencilBuffer:*;
		/** @private */
		private var _depthStencilFormat:int;
		
		public var _mgrKey:int = 0;	//给WebGLRTMgr用的

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
		
		public function getIsReady():Boolean {
			return true;
		}
		
		/**
		 * 获取宽度。
		 */
		public function get sourceWidth():Number {
			return _width;
		}
		
		/***
		 * 获取高度。
		 */
		public function get sourceHeight():Number {
			return _height;
		}
		
		/**
		 * 获取offsetX。
		 */
		public function get offsetX():Number {
			return 0;
		}
		
		/***
		 * 获取offsetY
		 */
		public function get offsetY():Number {
			return 0;
		}
		
		/**
		 * @param width  宽度。
		 * @param height 高度。
		 * @param format 纹理格式。
		 * @param depthStencilFormat 深度格式。
		 * 创建一个 <code>RenderTexture</code> 实例。
		 */
		public function RenderTexture2D(width:Number, height:Number, format:int = FORMAT_R8G8B8, depthStencilFormat:int = BaseTexture.FORMAT_DEPTH_16) {//TODO:待老郭清理
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super(format, false);
			_glTextureType = WebGLContext.TEXTURE_2D;
			_width = width;
			_height = height;
			_depthStencilFormat = depthStencilFormat;
			_create(width, height);
			lock = true;
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
					console.log("RenderTexture: unkonw depth format.");//2d并不需要depthbuffer
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
		override public function generateMipmap():void {
			if (_isPot(width) && _isPot(height)) {
				_mipmap = true;
				LayaGL.instance.generateMipmap(_glTextureType);
				_setFilterMode(_filterMode);
				_setGPUMemory(width * height * 4 * (1 + 1 / 3));
			} else {
				_mipmap = false;
				_setGPUMemory(width * height * 4);
			}
		}
		
		/**
		 * 保存当前的RT信息。
		 */
		public static function pushRT():void {
			rtStack.push( { rt:_currentActive,w:RenderState2D.width,h:RenderState2D.height} );
		}
		/**
		 * 恢复上次保存的RT信息
		 */
		public static function popRT():void {
			var gl:WebGLContext = LayaGL.instance;
			var top:* = rtStack.pop();
			if (top) {
				if (_currentActive != top.rt) {
					LayaGL.instance.bindFramebuffer(WebGLContext.FRAMEBUFFER,  top.rt?top.rt._frameBuffer:null);
					_currentActive = top.rt;
				}
				gl.viewport(0, 0, top.w,top.h);
				RenderState2D.width = top.w;
				RenderState2D.height = top.h;
			}
		}
		/**
		 * 开始绑定。
		 */
		public function start():void {
			var gl:WebGLContext = LayaGL.instance;
			//(memorySize == 0) && recreateResource();
			LayaGL.instance.bindFramebuffer(WebGLContext.FRAMEBUFFER, _frameBuffer);
			_lastRT = _currentActive;
			_currentActive = this;
			_readyed = true;
			
			//var gl:LayaGL = LayaGL.instance;//TODO:这段代码影响2D、3D混合
			////(memorySize == 0) && recreateResource();
			//LayaGL.instance.bindFramebuffer(WebGLContext.FRAMEBUFFER, _frameBuffer);
			//_lastRT = _currentActive;
			//_currentActive = this;
			////_readyed = false;  
			//_readyed = true;	//这个没什么用。还会影响流程，比如我有时候并不调用end。所以直接改成true
			//
			////if (_type == TYPE2D) {
				gl.viewport(0, 0, _width, _height);//外部设置
				_lastWidth = RenderState2D.width;
				_lastHeight = RenderState2D.height;
				RenderState2D.width = _width;
				RenderState2D.height = _height;
				BaseShader.activeShader = null;
			////}
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
		 * 恢复上一次的RenderTarge.由于使用自己保存的，所以如果被外面打断了的话，会出错。
		 */
		public function restore():void {
			var gl:WebGLContext = LayaGL.instance;
			if (_lastRT != _currentActive) {
				LayaGL.instance.bindFramebuffer(WebGLContext.FRAMEBUFFER,  _lastRT?_lastRT._frameBuffer:null);
				_currentActive = _lastRT;
			}
			_readyed = true;
			//if (_type == TYPE2D)//待调整
			//{
				gl.viewport(0, 0, _lastWidth,_lastHeight);
				RenderState2D.width = _lastWidth;
				RenderState2D.height = _lastHeight;
				BaseShader.activeShader = null;
			//} else 
			//	gl.viewport(0, 0, Laya.stage.width, Laya.stage.height);
			
		}		
		
		public function clear(r:Number = 0.0, g:Number = 0.0, b:Number = 0.0, a:Number = 1.0):void {
			var gl:WebGLContext = LayaGL.instance;
			gl.clearColor(r, g, b, a);
			var clearFlag:int = WebGLContext.COLOR_BUFFER_BIT;
			switch (_depthStencilFormat) {
			//case WebGLContext.DEPTH_COMPONENT: 
			case WebGLContext.DEPTH_COMPONENT16: 
				clearFlag |= WebGLContext.DEPTH_BUFFER_BIT;
				break;
			//case WebGLContext.STENCIL_INDEX:
			case WebGLContext.STENCIL_INDEX8: 
				clearFlag |= WebGLContext.STENCIL_BUFFER_BIT;
				break;
			case WebGLContext.DEPTH_STENCIL: 
				clearFlag |= WebGLContext.DEPTH_BUFFER_BIT;
				clearFlag |= WebGLContext.STENCIL_BUFFER_BIT
				break;
			}
			gl.clear(clearFlag);
		}
				
		
		/**
		 * 获得像素数据。
		 * @param x X像素坐标。
		 * @param y Y像素坐标。
		 * @param width 宽度。
		 * @param height 高度。
		 * @return 像素数据。
		 */
		public function getData(x:Number, y:Number, width:Number, height:Number):Uint8Array {
			if (Render.isConchApp && __JS__("conchConfig.threadMode == 2")) {
				throw "native 2 thread mode use getDataAsync";
			}
			var gl:WebGLContext = LayaGL.instance;
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, _frameBuffer);
			var canRead:Boolean = (gl.checkFramebufferStatus(WebGLContext.FRAMEBUFFER) === WebGLContext.FRAMEBUFFER_COMPLETE);
			
			if (!canRead) {
				gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, null);
				return null;
			}
			
			var pixels:Uint8Array = new Uint8Array(_width * _height * 4);
			var glFormat:int = _getGLFormat();
			gl.readPixels(x, y, width, height, glFormat, WebGLContext.UNSIGNED_BYTE, pixels);
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, null);
			return pixels;
		}
		/**
		 * native多线程
		 */
		public function getDataAsync(x:Number, y:Number, width:Number, height:Number, callBack:Function):void {
			var gl:* = LayaGL.instance;
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, this._frameBuffer);
			gl.readPixelsAsync(x, y, width, height, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, function(data:ArrayBuffer):void {
				__JS__("callBack(new Uint8Array(data))");
			});
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, null);
		}
		public function recycle():void {
			
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
