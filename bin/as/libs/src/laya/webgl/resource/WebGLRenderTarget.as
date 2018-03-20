package laya.webgl.resource {
	import laya.maths.Arith;
	import laya.resource.Bitmap;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	public class WebGLRenderTarget extends Bitmap {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private var _frameBuffer:*;
		private var _depthStencilBuffer:*;
		
		private var _surfaceFormat:int;
		private var _surfaceType:int;
		private var _depthStencilFormat:int;
		
		private var _mipMap:Boolean;
		private var _repeat:Boolean;
		private var _minFifter:int;
		private var _magFifter:int;
		
		public function get frameBuffer():* {
			return _frameBuffer;
		}
		
		public function get depthStencilBuffer():* {
			return _depthStencilBuffer;
		}
		
		public function WebGLRenderTarget(width:int, height:int, surfaceFormat:int = WebGLContext.RGBA, surfaceType:int = WebGLContext.UNSIGNED_BYTE, depthStencilFormat:int = WebGLContext.DEPTH_STENCIL, mipMap:Boolean = false, repeat:Boolean = false, minFifter:int = -1, magFifter:int = 1) {
			super();
			_w = width;
			_h = height;
			_surfaceFormat = surfaceFormat;
			_surfaceType = surfaceType;
			_depthStencilFormat = depthStencilFormat;
			_mipMap = mipMap;
			_repeat = repeat;
			_minFifter = minFifter;
			_magFifter = magFifter;
		}
		
		override protected function recreateResource():void {
			var gl:WebGLContext = WebGL.mainContext;
			_frameBuffer || (_frameBuffer = gl.createFramebuffer());
			_source || (_source = gl.createTexture());
			var preTarget:* = WebGLContext.curBindTexTarget;
			var preTexture:* = WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, _source);
			gl.texImage2D(WebGLContext.TEXTURE_2D, 0, WebGLContext.RGBA, _w, _h, 0, _surfaceFormat, _surfaceType, null);
			
			var minFifter:int = this._minFifter;
			var magFifter:int = this._magFifter;
			var repeat:int = this._repeat ? WebGLContext.REPEAT : WebGLContext.CLAMP_TO_EDGE;
			
			var isPot:Boolean = Arith.isPOT(_w, _h);
			if (isPot) {
				if (this._mipMap)
					(minFifter !== -1) || (minFifter = WebGLContext.LINEAR_MIPMAP_LINEAR);
				else
					(minFifter !== -1) || (minFifter = WebGLContext.LINEAR);
				
				(magFifter !== -1) || (magFifter = WebGLContext.LINEAR);
				
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MIN_FILTER, minFifter);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MAG_FILTER, magFifter);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_S, repeat);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_T, repeat);
				this._mipMap && gl.generateMipmap(WebGLContext.TEXTURE_2D);
			} else {
				(minFifter !== -1) || (minFifter = WebGLContext.LINEAR);
				(magFifter !== -1) || (magFifter = WebGLContext.LINEAR);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MIN_FILTER, minFifter);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MAG_FILTER, magFifter);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_S, WebGLContext.CLAMP_TO_EDGE);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_T, WebGLContext.CLAMP_TO_EDGE);
			}
			
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, _frameBuffer);
			gl.framebufferTexture2D(WebGLContext.FRAMEBUFFER, WebGLContext.COLOR_ATTACHMENT0, WebGLContext.TEXTURE_2D, _source, 0);
			
			if (_depthStencilFormat)//depthFormat为空时不创建深度缓冲
			{
				
				_depthStencilBuffer || (_depthStencilBuffer = gl.createRenderbuffer());
				gl.bindRenderbuffer(WebGLContext.RENDERBUFFER, _depthStencilBuffer);
				gl.renderbufferStorage(WebGLContext.RENDERBUFFER, _depthStencilFormat, _w, _h);
				
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
			if (isPot && this._mipMap)
				memorySize = _w * _h * 4 * (1 + 1 / 3);//使用mipmap则在原来的基础上增加1/3
			else
				memorySize = _w * _h * 4;
			completeCreate();
		
		}
		
		override protected function disposeResource():void {
			if (_frameBuffer) {
				WebGL.mainContext.deleteTexture(_source);
				WebGL.mainContext.deleteFramebuffer(_frameBuffer);
				WebGL.mainContext.deleteRenderbuffer(_depthStencilBuffer);
				_source = null;
				_frameBuffer = null;
				_depthStencilBuffer = null;
				memorySize = 0;
			}
		}
	}
}