package laya.webgl.resource {
	import laya.resource.IDispose;
	import laya.resource.Texture;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.RenderState2D;
	
	public class RenderTarget2D extends Texture implements IDispose {
		//TODO:临时...............................................
		public static const TYPE2D:int = 1;
		public static const TYPE3D:int = 2;
		private static var POOL:Array = [];
		private var _type:int;
		private var _svWidth:Number;
		private var _svHeight:Number;
		private var _preRenderTarget:RenderTarget2D;
		//TODO:.........................................................	
		private var _alreadyResolved:Boolean;
		private var _looked:Boolean;
		
		private var _surfaceFormat:int;
		private var _surfaceType:int;
		private var _depthStencilFormat:int;
		private var _mipMap:Boolean;
		private var _repeat:Boolean;
		private var _minFifter:int;
		private var _magFifter:int;
		private var _destroy:Boolean = false;
		
		public function get surfaceFormat():int {
			return _surfaceFormat;
		}
		
		public function get surfaceType():int {
			return _surfaceType;
		}
		
		public function get depthStencilFormat():int {
			return _depthStencilFormat;
		}
		
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
		
		/**返回RenderTarget的Texture*/
		override public function get source():* {
			if (_alreadyResolved)
				return super.source;
			throw new Error("RenderTarget  还未准备好！");
		}
		
		/**
		 * @param width
		 * @param height
		 * @param mimMap
		 * @param surfaceFormat RGB ,R,RGBA......
		 * @param surfaceType    WebGLContext.UNSIGNED_BYTE  数据类型
		 * @param depthFormat WebGLContext.DEPTH_COMPONENT16 数据类型等
		 * **/
		public function RenderTarget2D(width:int, height:int, surfaceFormat:int = WebGLContext.RGBA, surfaceType:int = WebGLContext.UNSIGNED_BYTE, depthStencilFormat:int = WebGLContext.DEPTH_COMPONENT16, mipMap:Boolean = false, repeat:Boolean = false, minFifter:int = -1, magFifter:int = -1) {
			_type = TYPE2D;//待调整
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
			super(bitmap, Texture.INV_UV);
		}
		
		//TODO:临时......................................................
		public function getType():int//待调整
		{
			return _type;
		}
		
		///**
		//* 获取纹理
		//* @return *
		//*/
		public function getTexture():Texture {
			return this;
		}
		
		public function size(w:Number, h:Number):void {
			if (bitmap && _w == w && _h == h)
				return;
			_w = w;
			_h = h;
			release();
			_createWebGLRenderTarget();
		}
		
		public function release():void {
			destroy();
		}
		
		public function recycle():void {
			POOL.push(this);
		}
		
		public static function create(w:int, h:int, surfaceFormat:int = WebGLContext.RGBA, surfaceType:int = WebGLContext.UNSIGNED_BYTE, depthStencilFormat:int = WebGLContext.DEPTH_COMPONENT16, mipMap:Boolean = false, repeat:Boolean = false, minFifter:int = -1, magFifter:int = -1):RenderTarget2D {
			var t:RenderTarget2D = POOL.pop();
			t || (t = new RenderTarget2D(w, h));
			
			if (!t.bitmap || t._w != w || t._h != h || t._surfaceFormat != surfaceFormat || t._surfaceType != surfaceType || t._depthStencilFormat != depthStencilFormat || t._mipMap != mipMap || t._repeat != repeat || t._minFifter != minFifter || t._magFifter != magFifter) {
				t._w = w;
				t._h = h;
				t._surfaceFormat = surfaceFormat;
				t._surfaceType = surfaceType;
				t._depthStencilFormat = depthStencilFormat;
				t._mipMap = mipMap;
				t._repeat = repeat;
				t._minFifter = minFifter;
				t._magFifter = magFifter;
				
				t.release();
				t._createWebGLRenderTarget();
			}
			return t;
		}
		
		public function start():RenderTarget2D {
			var gl:WebGLContext = WebGL.mainContext;
			_preRenderTarget = RenderState2D.curRenderTarget;
			
			RenderState2D.curRenderTarget = this;
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, bitmap.frameBuffer);
			
			_alreadyResolved = false;
			
			if (_type == TYPE2D) {
				gl.viewport(0, 0, _w, _h);//外部设置
				_svWidth = RenderState2D.width;
				_svHeight = RenderState2D.height;
				RenderState2D.width = _w;
				RenderState2D.height = _h;
				Shader.activeShader = null;
			}
			
			return this;
		}
		
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
		
		public function end():void {
			var gl:WebGLContext = WebGL.mainContext;
			
			gl.bindFramebuffer(WebGLContext.FRAMEBUFFER, _preRenderTarget ? _preRenderTarget.bitmap.frameBuffer : null);
			_alreadyResolved = true;
			RenderState2D.curRenderTarget = _preRenderTarget;
			if (_type == TYPE2D)//待调整
			{
				gl.viewport(0, 0, _svWidth, _svHeight);
				RenderState2D.width = _svWidth;
				RenderState2D.height = _svHeight;
				Shader.activeShader = null;
			} else gl.viewport(0, 0, Laya.stage.width, Laya.stage.height);
		}
		
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
		
		/**彻底清理资源,注意会强制解锁清理*/
		override public function destroy(foreDiposeTexture:Boolean = false):void {//待优化
			if (!_destroy) {
				_loaded = false;
				bitmap.dispose();
				bitmap = null;
				_destroy = true;
				super.destroy();//待测试
			}
		}
		
		public function dispose():void {
		}
		
		private function _createWebGLRenderTarget():void {
			bitmap = new WebGLRenderTarget(width, height, _surfaceFormat, _surfaceType, _depthStencilFormat, _mipMap, _repeat, _minFifter, _magFifter);
			bitmap.activeResource();
			_alreadyResolved = true;
			_destroy = false;
			_loaded = true;
		}
	
	}

}
