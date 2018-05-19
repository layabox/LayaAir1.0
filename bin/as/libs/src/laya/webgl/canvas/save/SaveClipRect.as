package laya.webgl.canvas.save {
	import laya.maths.Rectangle;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.submit.Submit;
	import laya.webgl.submit.SubmitScissor;
	
	public class SaveClipRect implements ISaveData {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		private static var _cache:* = SaveBase._createArray();
		
		public var _clipSaveRect:Rectangle;
		public var _clipRect:Rectangle = new Rectangle();
		public var _submitScissor:SubmitScissor;
		
		public function isSaveMark():Boolean { return false; }
		
		public function restore(context:WebGLContext2D):void {
			context._clipRect = _clipSaveRect;
			_cache[_cache._length++] = this;
			_submitScissor.submitLength = context._submits._length - _submitScissor.submitIndex;
			context._curSubmit = Submit.RENDERBASE;
			context._renderKey = 0;
		}
		
		public static function save(context:WebGLContext2D, submitScissor:SubmitScissor):void {
			if ((context._saveMark._saveuse & SaveBase.TYPE_CLIPRECT) == SaveBase.TYPE_CLIPRECT) return;
			context._saveMark._saveuse |= SaveBase.TYPE_CLIPRECT;
			var cache:* = _cache;
			var o:SaveClipRect = cache._length > 0 ? cache[--cache._length] : (new SaveClipRect());
			o._clipSaveRect = context._clipRect;
			context._clipRect = o._clipRect.copyFrom(context._clipRect);
			o._submitScissor = submitScissor;
			var _save:Array = context._save;
			_save[_save._length++] = o;
		}
	}
}