package laya.webgl.resource
{
	import laya.maths.Arith;
	import laya.resource.Bitmap;
	import laya.resource.Texture;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * ...
	 * @author laya
	 */
	public class WebGLRenderTarget extends Bitmap
	{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private var _frameBuffer:*;
		private var _depthBuffer:*;
		
		private var _surfaceFormat:int;
		private var _surfaceType:int;
		private var _depthFormat:int;
		private var _mipMap:Boolean;
		
		public function get frameBuffer():*
		{
			return _frameBuffer;
		}
		
		public function get depthBuffer():*
		{
			return _depthBuffer;
		}
		
		public function WebGLRenderTarget(width:int, height:int, mipMap:Boolean = false, surfaceFormat:int = WebGLContext.RGBA, surfaceType:int = WebGLContext.UNSIGNED_BYTE, depthFormat:int = WebGLContext.DEPTH_COMPONENT16)
		{
			super();
			_w = width;
			_h = height;
			_mipMap = mipMap;
			_surfaceFormat = surfaceFormat;
			_surfaceType = surfaceType;
			_depthFormat = depthFormat;
			lock = true;
		}
		
		override protected function recreateResource():void
		{
			var gl:WebGLContext = WebGL.mainContext;
			_frameBuffer || (_frameBuffer = gl.createFramebuffer());
			_source || (_source = gl.createTexture()); 
			gl.bindTexture(WebGLContext.TEXTURE_2D, _source); 
			gl.texImage2D(WebGLContext.TEXTURE_2D, 0, WebGLContext.RGBA, _w, _h, 0, _surfaceFormat, _surfaceType, null);
			
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MIN_FILTER, WebGLContext.LINEAR);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_S, WebGLContext.CLAMP_TO_EDGE);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_T, WebGLContext.CLAMP_TO_EDGE);
			
			var isPot:Boolean = Arith.isPOT(_w, _h);
			if (_mipMap && isPot)
			{
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MAG_FILTER, WebGLContext.LINEAR_MIPMAP_LINEAR);
				gl.generateMipmap(WebGLContext.TEXTURE_2D);
			}
			else
			{
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MAG_FILTER, WebGLContext.LINEAR);
				(_mipMap) && (_mipMap = false);
			}
			
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, _frameBuffer);
			gl.framebufferTexture2D(WebGLContext.FRAMEBUFFER, WebGLContext.COLOR_ATTACHMENT0, WebGLContext.TEXTURE_2D, _source, 0);
			
			if (_depthFormat)//depthFormat为空时不创建深度缓冲
			{
				_depthBuffer || (_depthBuffer = gl.createRenderbuffer());
				gl.bindRenderbuffer(WebGLContext.RENDERBUFFER, _depthBuffer);
				gl.renderbufferStorage(WebGLContext.RENDERBUFFER, _depthFormat, _w, _h);
				gl.framebufferRenderbuffer(WebGLContext.FRAMEBUFFER, WebGLContext.DEPTH_ATTACHMENT, WebGLContext.RENDERBUFFER, _depthBuffer);
			}
			
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, null);
			gl.bindTexture(WebGLContext.TEXTURE_2D, null);
			gl.bindRenderbuffer(WebGLContext.RENDERBUFFER, null);
			memorySize = _w * _h * 4;
			
			super.recreateResource();
		}
		
		override protected function detoryResource():void
		{
			if (_frameBuffer)
			{
				WebGL.mainContext.deleteTexture(_source);
				WebGL.mainContext.deleteFramebuffer(_frameBuffer);
				WebGL.mainContext.deleteRenderbuffer(_depthBuffer);
				_source = null;
				_frameBuffer = null;
				_depthBuffer = null;
				memorySize = 0;
			}
		}
	}
}