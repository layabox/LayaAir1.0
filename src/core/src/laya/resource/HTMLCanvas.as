package laya.resource {
	import laya.renders.Render;
	import laya.utils.Browser;
	
	/**
	 * <code>HTMLCanvas</code> 是 Html Canvas 的代理类，封装了 Canvas 的属性和方法。
	 */
	public class HTMLCanvas extends Bitmap {
		
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private var _ctx:*;
		public var _source:*;
		public var _texture:Texture;
		/**
		 * @inheritDoc
		 */
		 public function get source():* {
			return _source;
		}
		
		override public function _getSource():* 
		{
			return _source;
		}
		/**
		 * 根据指定的类型，创建一个 <code>HTMLCanvas</code> 实例。
		 */
		public function HTMLCanvas(createCanvas:Boolean = false) {
			if(createCanvas || !Render.isWebGL)	//webgl模式下不建立。除非强制指，例如绘制文字部分
				_source = Browser.createElement("canvas");
			else {
				_source = this;
			}
			lock = true;
		}
		
		/**
		 * 清空画布内容。
		 */
		public function clear():void {
			_ctx && _ctx.clear();
			if (_texture)
			{
				_texture.destroy();
				_texture = null;
			}
		}
		
		/**
		 * 销毁。
		 */
		override public function destroy():void {
			super.destroy();
			_setCPUMemory(0);
			_ctx && _ctx.destroy();
			_ctx = null;
		}
		
		/**
		 * 释放。
		 */
		public function release():void {
		}
		
		/**
		 * Canvas 渲染上下文。
		 */
		public function get context():Context {
			if (_ctx) return _ctx;
			if (Render.isWebGL && _source==this ) {	//是webgl并且不是真的画布。如果是真的画布，可能真的想要2d context
				_ctx = __JS__("new laya.webgl.canvas.WebGLContext2D();");
			}else {
				_ctx = _source.getContext(Render.isConchApp?'layagl':'2d');
			}
			_ctx._canvas = this;
			//if(!Browser.onLimixiu) _ctx.size = function(w:Number, h:Number):void {};	这个是干什么的，会导致ctx的size不好使
			return _ctx;
		}
		
		/**
		 * @private
		 * 设置 Canvas 渲染上下文。是webgl用来替换_ctx用的
		 * @param	context Canvas 渲染上下文。
		 */
		public function _setContext(context:Context):void {
			_ctx = context;
		}
		
		/**
		 * 获取 Canvas 渲染上下文。
		 * @param	contextID 上下文ID.
		 * @param	other
		 * @return  Canvas 渲染上下文 Context 对象。
		 */
		public function getContext(contextID:String, other:* = null):Context {
			return context;
		}
		
		/**
		 * 获取内存大小。
		 * @return 内存大小。
		 */
		//TODO:coverage
		public function getMemSize():int {
			return /*_is2D ? super.getMemSize() :*/ 0;//TODO:待调整
		}
		
		/**
		 * 设置宽高。
		 * @param	w 宽度。
		 * @param	h 高度。
		 */
		public function size(w:Number, h:Number):void {
			if (_width != w || _height != h || (_source && (_source.width != w || _source.height != h))) {
				_width = w;
				_height = h;
				_setCPUMemory(w * h * 4);
				_ctx && _ctx.size && _ctx.size(w, h);
				_source && (_source.height = h, _source.width = w);
				if (_texture)
				{
					_texture.destroy();
					_texture = null;
				}
			}
		}
		
		/**
		 * 获取texture实例
		 */
		public function getTexture():Texture
		{
			if (!_texture)
			{
				_texture = new Texture(this, Texture.DEF_UV);
			}
			return _texture;
		}
		
		/**
		 * 把图片转换为base64信息
		 * @param	type "image/png"
		 * @param	encoderOptions	质量参数，取值范围为0-1
		 */
		public function toBase64(type:String, encoderOptions:Number):String {
			if (_source) {
				if (Render.isConchApp) {
					if (__JS__("conchConfig.threadMode == 2")) {
						throw "native 2 thread mode use toBase64Async";
					}
					var width:Number = _ctx._targets.sourceWidth;
					var height:Number = _ctx._targets.sourceHeight;
					var data:* = _ctx._targets.getData(0, 0, width, height);
					__JS__("return conchToBase64(type, encoderOptions, data.buffer, width, height)");
				}
				else {
					return _source.toDataURL(type, encoderOptions);
				}
			}
			return null;
		}
		//native多线程
		public function toBase64Async(type:String, encoderOptions:Number, callBack:Function):void {
			var width:Number = _ctx._targets.sourceWidth;
			var height:Number = _ctx._targets.sourceHeight;
			_ctx._targets.getDataAsync(0, 0, width, height, function(data:Uint8Array):void {
				__JS__("var base64 = conchToBase64(type, encoderOptions, data.buffer, width, height)");
				__JS__("callBack(base64)");
			});	
		}
	}
}