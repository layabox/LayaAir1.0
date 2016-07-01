package laya.d3.resource {
	import laya.resource.IDispose;
	import laya.resource.Texture;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.WebGLRenderTarget;
	
	/**
	 * <code>RenderTarget</code> 类用于创建渲染目标。
	 */
	public class RenderTarget extends Texture implements IDispose {
		
		/** @private */
		private static var _currentRenderTarget:RenderTarget;
		
		/** @private */
		private var _alreadyResolved:Boolean;
		/** @private */
		private var _looked:Boolean;
		
		/** @private */
		private var _surfaceFormat:int;
		/** @private */
		private var _surfaceType:int;
		/** @private */
		private var _depthStencilFormat:int;
		/** @private */
		private var _mipMap:Boolean;
		/** @private */
		private var _repeat:Boolean;
		/** @private */
		private var _minFifter:int;
		/** @private */
		private var _magFifter:int;
		
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
		
		/**
		 * 获取是否为多级纹理。
		 *@return 是否为多级纹理。
		 */
		public function get mipMap():Boolean {
			return _mipMap;
		}
		
		//public function get repeat():Boolean {
			//return _repeat;
		//}
		
		public function get minFifter():int {
			return _minFifter;
		}
		
		public function get magFifter():int {
			return _magFifter;
		}
		
		/**
		 * 获取RenderTarget数据源。
		 * @return RenderTarget数据源。
		 */
		override public function get source():* {
			if (_alreadyResolved)
				return super.source;
			throw new Error("RenderTarget  还未准备好！");
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
		public function RenderTarget(width:Number, height:Number, surfaceFormat:int = WebGLContext.RGBA, surfaceType:int = WebGLContext.UNSIGNED_BYTE, depthStencilFormat:int = WebGLContext.DEPTH_COMPONENT16, mipMap:Boolean = false, repeat:Boolean = false, minFifter:int = -1, magFifter:int = -1) {
			
			_w = width;
			_h = height;
			_surfaceFormat = surfaceFormat;
			_surfaceType = surfaceType;
			_depthStencilFormat = depthStencilFormat;
			_mipMap = mipMap;
			_repeat = repeat;
			_minFifter = minFifter;
			_magFifter = magFifter;
			
			_createWebGLRenderTarget();
			bitmap.lock = true;
		}
		
		/** @private */
		private function _createWebGLRenderTarget():void {
			bitmap = new WebGLRenderTarget(width, height, _surfaceFormat, _surfaceType, _depthStencilFormat, _mipMap, _repeat, _minFifter, _magFifter);
			bitmap.activeResource();
			_alreadyResolved = true;
		}
		
		/**
		 * 开始绑定。
		 */
		public function start():void {
			var gl:WebGLContext = WebGL.mainContext;
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, (bitmap as WebGLRenderTarget).frameBuffer); // Change the drawing destination to FBO
			_currentRenderTarget = this;
			_alreadyResolved = false;
			
			_currentRenderTarget = this;
		}
		
		/**
		 * 清理并着色。
		 */
		public function clear(r:Number = 0.0, g:Number = 0.0, b:Number = 0.0, a:Number = 1.0):void {
			var gl:WebGLContext = WebGL.mainContext;
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
		 * 结束绑定。
		 */
		public function end():void {
			var gl:WebGLContext = WebGL.mainContext;
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, null);
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
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, (bitmap as WebGLRenderTarget).frameBuffer);
			var canRead:Boolean = (gl.checkFramebufferStatus(WebGLContext.FRAMEBUFFER) === WebGLContext.FRAMEBUFFER_COMPLETE);
			
			if (!canRead) {
				gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, null);
				return null;
			}
			
			var pixels:Uint8Array = new Uint8Array(_w * _h * 4);
			gl.readPixels(x, y, width, height, _surfaceFormat, _surfaceType, pixels);
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, null);
			return pixels;
		}
		
		/**
		 * 彻底清理资源,注意会强制解锁清理
		 */
		public function dispose():void//待优化
		{
			bitmap.dispose();
		}
	
	}

}
