package laya.d3.resource {
	import laya.d3.utils.Size;
	import laya.maths.Arith;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>RenderTarget</code> 类用于创建渲染目标。
	 */
	public class RenderTexture extends BaseTexture {
		/** @private */
		private static var _currentRenderTarget:RenderTexture;
		
		/** @private */
		private var _alreadyResolved:Boolean;
		
		/** @private */
		private var _surfaceFormat:int;
		/** @private */
		private var _surfaceType:int;
		/** @private */
		private var _depthStencilFormat:int;
		
		/** @private */
		private var _frameBuffer:*;
		/** @private */
		private var _depthStencilBuffer:*;
		
		/**
		 * 获取表面格式。
		 *@return 表面格式。
		 */
		public function get surfaceFormat():int {
			return _surfaceFormat;
		}
		
		/**
		 * 获取表面类型。
		 *@return 表面类型。
		 */
		public function get surfaceType():int {
			return _surfaceType;
		}
		
		/**
		 * 获取深度格式。
		 *@return 深度格式。
		 */
		public function get depthStencilFormat():int {
			return _depthStencilFormat;
		}
		
		public function get frameBuffer():* {
			return _frameBuffer;
		}
		
		public function get depthStencilBuffer():* {
			return _depthStencilBuffer;
		}
		
		/**
		 * 获取RenderTarget数据源,如果alreadyResolved等于false，则返回null。
		 * @return RenderTarget数据源。
		 */
		override public function get source():* {
			if (_alreadyResolved)
				return super.source;
			else
				return null;
		}
		
		/**
		 * 创建一个 <code>RenderTarget</code> 实例。
		 * @param	width  宽度。
		 * @param	height  高度。
		 * @param	mipMap  是否生成mipMap。
		 * @param	surfaceFormat  表面格式。
		 *   @param	surfaceType  表面类型。
		 *   @param	depthFormat  深度格式。
		 */
		public function RenderTexture(width:Number, height:Number, surfaceFormat:int = WebGLContext.RGBA, surfaceType:int = WebGLContext.UNSIGNED_BYTE, depthStencilFormat:int = WebGLContext.DEPTH_COMPONENT16, mipMap:Boolean = false, repeat:Boolean = false, minFifter:int = -1, magFifter:int = -1) {
			super();
			_type = WebGLContext.TEXTURE_2D;
			_width = width;
			_height = height;
			_size = new Size(width, height);
			_surfaceFormat = surfaceFormat;
			_surfaceType = surfaceType;
			_depthStencilFormat = depthStencilFormat;
			_mipmap = mipMap;
			_repeat = repeat;
			_minFifter = minFifter;
			_magFifter = magFifter;
			
			activeResource();
			_alreadyResolved = true;
		}
		
		override protected function recreateResource():void {
			var gl:WebGLContext = WebGL.mainContext;
			_frameBuffer = gl.createFramebuffer();
			//var ext = gl.getExtension('OES_texture_float');
			_source = gl.createTexture();
			var preTarget:* = WebGLContext.curBindTexTarget;
			var preTexture:* = WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl, _type, _source);
			gl.texImage2D(_type, 0, WebGLContext.RGBA, _width, _height, 0, _surfaceFormat, _surfaceType, null);
			//gl.texImage2D(WebGLContext.TEXTURE_2D, 0, WebGLContext.RGBA, _width, _height, 0, WebGLContext.RGBA, WebGLContext.FLOAT, null);
			var minFifter:int = this._minFifter;
			var magFifter:int = this._magFifter;
			var repeat:int = this._repeat ? WebGLContext.REPEAT : WebGLContext.CLAMP_TO_EDGE;
			
			var isPot:Boolean = Arith.isPOT(_width, _height);
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
				this._mipmap && gl.generateMipmap(_type);//TODO:这里生成有问题，要渲染结束再生成
			} else {
				(minFifter !== -1) || (minFifter = WebGLContext.LINEAR);
				(magFifter !== -1) || (magFifter = WebGLContext.LINEAR);
				gl.texParameteri(_type, WebGLContext.TEXTURE_MIN_FILTER, minFifter);
				gl.texParameteri(_type, WebGLContext.TEXTURE_MAG_FILTER, magFifter);
				gl.texParameteri(_type, WebGLContext.TEXTURE_WRAP_S, WebGLContext.CLAMP_TO_EDGE);
				gl.texParameteri(_type, WebGLContext.TEXTURE_WRAP_T, WebGLContext.CLAMP_TO_EDGE);
			}
			
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, _frameBuffer);
			gl.framebufferTexture2D(WebGLContext.FRAMEBUFFER, WebGLContext.COLOR_ATTACHMENT0, WebGLContext.TEXTURE_2D, _source, 0);
			
			if (_depthStencilFormat)//depthFormat为空时不创建深度缓冲
			{
				_depthStencilBuffer = gl.createRenderbuffer();
				gl.bindRenderbuffer(WebGLContext.RENDERBUFFER, _depthStencilBuffer);
				gl.renderbufferStorage(WebGLContext.RENDERBUFFER, _depthStencilFormat, _width, _height);
				
				switch (_depthStencilFormat) {
				//case WebGLContext.DEPTH_COMPONENT: 
				case WebGLContext.DEPTH_COMPONENT16: 
					gl.framebufferRenderbuffer(WebGLContext.FRAMEBUFFER, WebGLContext.DEPTH_ATTACHMENT, WebGLContext.RENDERBUFFER, _depthStencilBuffer);
					break;
				//case WebGLContext.STENCIL_INDEX:
				case WebGLContext.STENCIL_INDEX8: 
					gl.framebufferRenderbuffer(WebGLContext.FRAMEBUFFER, WebGLContext.STENCIL_ATTACHMENT, WebGLContext.RENDERBUFFER, _depthStencilBuffer);
					break;
				case WebGLContext.DEPTH_STENCIL: 
					gl.framebufferRenderbuffer(WebGLContext.FRAMEBUFFER, WebGLContext.DEPTH_STENCIL_ATTACHMENT, WebGLContext.RENDERBUFFER, _depthStencilBuffer);
					break;
				}
			}
			
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, null);
			(preTarget && preTexture) && (WebGLContext.bindTexture(gl, preTarget, preTexture));
			gl.bindRenderbuffer(WebGLContext.RENDERBUFFER, null);
			memorySize = _width * _height * 4;
			completeCreate();
		}
		
		/**
		 * 开始绑定。
		 */
		public function start():void {
			WebGL.mainContext.bindFramebuffer(WebGLContext.FRAMEBUFFER, frameBuffer);
			_currentRenderTarget = this;
			_alreadyResolved = false;
		}
		
		/**
		 * 结束绑定。
		 */
		public function end():void {
			WebGL.mainContext.bindFramebuffer(WebGLContext.FRAMEBUFFER, null);
			_currentRenderTarget = null;
			_alreadyResolved = true;
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
			var gl:WebGLContext = WebGL.mainContext;
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, _frameBuffer);
			var canRead:Boolean = (gl.checkFramebufferStatus(WebGLContext.FRAMEBUFFER) === WebGLContext.FRAMEBUFFER_COMPLETE);
			
			if (!canRead) {
				gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, null);
				return null;
			}
			
			var pixels:Uint8Array = new Uint8Array(_width * _height * 4);
			gl.readPixels(x, y, width, height, _surfaceFormat, _surfaceType, pixels);
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, null);
			return pixels;
		}
		
		/**
		 * 销毁资源。
		 */
		override protected function disposeResource():void {
			if (_frameBuffer) {
				var gl:WebGLContext = WebGL.mainContext;
				gl.deleteTexture(_source);
				gl.deleteFramebuffer(_frameBuffer);
				gl.deleteRenderbuffer(_depthStencilBuffer);
				_source = null;
				_frameBuffer = null;
				_depthStencilBuffer = null;
				memorySize = 0;
			}
		}
	
	}

}
