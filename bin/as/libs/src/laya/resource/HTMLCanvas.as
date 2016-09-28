package laya.resource {
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.utils.RunDriver;
	
	/**
	 * <code>HTMLCanvas</code> 是 Html Canvas 的代理类，封装了 Canvas 的属性和方法。。请不要直接使用 new HTMLCanvas！
	 */
	public class HTMLCanvas extends Bitmap {
		
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/**
		 * 根据指定的类型，创建一个 <code>HTMLCanvas</code> 实例。
		 * @param	type 类型。2D、3D。
		 */
		public static var create:Function = function(type:String,canvas:*=null):HTMLCanvas
		{
			return new HTMLCanvas(type,canvas);
		}
		
		/** 2D 模式。*/
		public static const TYPE2D:String = "2D";
		/** 3D 模式。*/
		public static const TYPE3D:String = "3D";
		/** 自动模式。*/
		public static const TYPEAUTO:String = "AUTO";
		
		/** @private */
		public static var _createContext:Function;
		
		private var _ctx:*;
		private var _is2D:Boolean = false;
		
		/**
		 * 根据指定的类型，创建一个 <code>HTMLCanvas</code> 实例。请不要直接使用 new HTMLCanvas！
		 * @param	type 类型。2D、3D。
		 */
		public function HTMLCanvas(type:String,canvas:*=null) {
			_source = this;
			if (type === "2D" || (type === "AUTO" && !Render.isWebGL)) {
				_is2D = true;
				_source = canvas || Browser.createElement("canvas");
				var o:HTMLCanvas = this;
				o.getContext = function(contextID:String, other:*=null):Context {
					if (_ctx) return _ctx;
					var ctx:* = _ctx = _source.getContext(contextID, other);
					if (ctx) {
						ctx._canvas = o;
						if(!Render.isFlash) ctx.size = function(w:Number, h:Number):void {
						};
					}
					//contextID === "2d" && Context._init(o, ctx);
					return ctx;
				}
			} 
			else _source = {};
		}
		
		/**
		 * 清空画布内容。
		 */
		public function clear():void {
			_ctx && _ctx.clear();
		}
		
		/**
		 * 销毁。
		 */
		public function destroy():void {
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
			return _ctx;
		}
		
		/**
		 * @private
		 * 设置 Canvas 渲染上下文。
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
		/*[IF-FLASH]*/ public var getContext:Function =function
		//[IF-SCRIPT] public function getContext
		(contextID:String, other:* = null):Context {
			return _ctx ? _ctx : (_ctx = _createContext(this));
		}
		
		/**
		 * 获取内存大小。
		 * @return 内存大小。
		 */
		public function getMemSize():int {
			return /*_is2D ? super.getMemSize() :*/ 0;//待调整
		}
		
		/**
		 * 是否当作 Bitmap 对象。
		 */
		public function set asBitmap(value:Boolean):void {
		}
		
		/**
		 * 设置宽高。
		 * @param	w 宽度。
		 * @param	h 高度。
		 */
		public function size(w:Number, h:Number):void {
			if (_w != w || _h != h) {
				_w = w;
				_h = h;
				_ctx && _ctx.size(w, h);
				_source && (_source.height = h, _source.width = w);
			}
		}
	}
}