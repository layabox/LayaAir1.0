package laya.resource {
	import laya.renders.Render;
	import laya.renders.Render;
	import laya.utils.Browser;
	
	/**
	 * ...
	 * @author laya
	 */
	public class HTMLCanvas extends Bitmap {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		public static const TYPE2D:String = "2D";
		public static const TYPE3D:String = "3D";
		public static const TYPEAUTO:String = "AUTO";
		
		public static var _createContext:Function;
		
		private var _ctx:Context;
		private var _is2D:Boolean = false;
		
		public function HTMLCanvas(type:String) {
			_source = this;
			
			if (type === "2D" || (type === "AUTO" && !Render.isWebGl)) {
				_is2D = true;
				_source = Browser.createElement("canvas");
				var o:* = this;
				o.getContext = function(contextID:String, other:*):Context {
					if (_ctx) return _ctx;
					var ctx:* = _ctx = _source.getContext(contextID, other);
					if (ctx) {
						ctx._canvas = o;
						ctx.size = function():void {
						};
					}
					contextID === "2d" && Context._init(o, ctx);
					return ctx;
				}
			} else _source = {};
		}
		
		public function clear():void {
			_ctx && _ctx.clear();
		}
		
		public function destroy():void {
			_ctx && _ctx.destroy();
			_ctx = null;
		}
		
		public function release():void {
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
		
		override public function copyTo(dec:Bitmap):void {
			super.copyTo(dec);
			(dec as HTMLCanvas)._ctx = _ctx;
		}
		
		public function getMemSize():int {
			return /*_is2D ? super.getMemSize() :*/ 0;//待调整
		}
		
		public function set asBitmap(value:Boolean):void {
		}
		
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