package laya.webgl.resource {
	import laya.renders.Render;
	import laya.resource.Bitmap;
	import laya.resource.Context;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	public class WebGLCanvas extends Bitmap {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static var create:Function = function(type:String):* {
			return new WebGLCanvas(type);
		}
		
		public static var _createContext:Function;
		
		private var _ctx:Context;
		private var _is2D:Boolean = false;
		
		/**HTML Canvas*/
		protected var _canvas:*;
		
		/**
		 * 返回HTML Image,as3无internal货friend，通常禁止开发者修改image内的任何属性
		 * @param HTML Image
		 */
		public function get canvas():* {
			return _canvas;
		}
		
		public var iscpuSource:Boolean;
		
		//待调整移除
		public function WebGLCanvas(type:String) {
			super();
			_canvas = this;
			if (type === "2D" || (type === "AUTO" && !Render.isWebGL)) {
				_is2D = true;
				_canvas = _source = Browser.createElement("canvas");//_canvas和_source均赋值
				iscpuSource = true;
				var o:* = this;
				o.getContext = function(contextID:String, other:*):Context {
					if (_ctx) return _ctx;
					var ctx:* = _ctx = _canvas.getContext(contextID, other);
					if (ctx) {
						ctx._canvas = o;
						ctx.size = function():void {
						};
					}
					//contextID === "2d" && Context._init(o, ctx);
					return ctx;
				}
			} else _canvas = {};
		}
		
		public function clear():void {
			_ctx && _ctx.clear();
		}
		
		public function destroy():void {
			_ctx && _ctx.destroy();
			_ctx = null;
		}
		
		public function get context():Context {
			return _ctx;
		}
		
		public function _setContext(context:Context):void {
			_ctx = context;
		}
		
		public function getContext(contextID:String, other:* = null):Context {
			return _ctx ? _ctx : (_ctx = _createContext(this));
		}
		
		/*override public function copyTo(dec:Bitmap):void {
		   super.copyTo(dec);
		   (dec as WebGLCanvas)._ctx = _ctx;
		   }*/
		
		public function size(w:Number, h:Number):void {
			if (_w != w || _h != h) {
				_w = w;
				_h = h;
				_ctx && _ctx.size(w, h);
				_canvas && (_canvas.height = h, _canvas.width = w);
			}
		}
		
		public function set asBitmap(value:Boolean):void {
			_ctx && (_ctx.asBitmap = value);
		}
		
		override protected function recreateResource():void {
			startCreate();
			createWebGlTexture();
			completeCreate();
		}
		
		override protected function detoryResource():void {
			if (_source && !iscpuSource) {
				WebGL.mainContext.deleteTexture(_source);
				_source = null;
				memorySize = 0;
			}
		}
		
		private function createWebGlTexture():void {
			var gl:WebGLContext = WebGL.mainContext;
			if (!_canvas) {
				throw "create GLTextur err:no data:" + _canvas;
			}
			var glTex:* = _source = gl.createTexture();
			iscpuSource = false;
			var preTarget:* = WebGLContext.curBindTexTarget;
			var preTexture:* = WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, glTex);
			
			gl.texImage2D(WebGLContext.TEXTURE_2D, 0, WebGLContext.RGBA, _w, _h, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, null);
			
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MAG_FILTER, WebGLContext.LINEAR);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MIN_FILTER, WebGLContext.LINEAR);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_S, WebGLContext.CLAMP_TO_EDGE);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_T, WebGLContext.CLAMP_TO_EDGE);
			memorySize = _w * _h * 4;
			(preTarget && preTexture) && (WebGLContext.bindTexture(gl, preTarget, preTexture));
			_canvas = null;
		}
		
		public function texSubImage2D(webglCanvas:WebGLCanvas, xoffset:Number, yoffset:Number):void {
			var gl:WebGLContext = WebGL.mainContext;
			var preTarget:* = WebGLContext.curBindTexTarget;
			var preTexture:* = WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, _source);
			gl.texSubImage2D(WebGLContext.TEXTURE_2D, 0, xoffset, yoffset, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, webglCanvas._source);
			(preTarget && preTexture) && (WebGLContext.bindTexture(gl, preTarget, preTexture));
		}
	
	}

}