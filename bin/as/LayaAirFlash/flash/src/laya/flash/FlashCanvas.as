/*[IF-FLASH]*/
package laya.flash {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import laya.webgl.WebGLContext;
	
	/**
	 * ...
	 * @author laya
	 */
	public dynamic class FlashCanvas extends FlashElement {
		private var _flashContext:FlashContext;
		
		public function get bitmapdata():BitmapData {
			return _flashContext.bitmapdata;
		}
		
		public function FlashCanvas() {
			super();
		}
		
		public override function createDisplayObject():DisplayObject {
			if (_displayObject) {
				return _displayObject;
			}
			var bitmap:Bitmap = new Bitmap();
			_displayObject = bitmap;
			bitmap.width = bitmap.height = 1;
			return bitmap;
		}
		
		public var getContext:Function = function(contextID:String, other:* = null):* {
			if (contextID == "webgl") return new WebGLContext();
			if (_flashContext) return _flashContext;
			_flashContext = new FlashContext(this, width, height);
			return _flashContext;
		}
		
		public override function set width(value:Number):void {
			super.width = value;
			if (_flashContext) _flashContext.size(value, -1);
		}
		
		public override function set height(value:Number):void {
			super.height = value;
			if (_flashContext) _flashContext.size(-1, value);
		}
	
	}

}