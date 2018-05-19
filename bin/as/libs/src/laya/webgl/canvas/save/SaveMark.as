package laya.webgl.canvas.save {
	import laya.webgl.canvas.WebGLContext2D;
	
	public class SaveMark implements ISaveData {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private static var _no:* = SaveBase._createArray();
		public var _saveuse:int = 0;
		public var _preSaveMark:SaveMark;
		
		public function SaveMark() {
			super();		
		}
		
		public function isSaveMark():Boolean {
			return true;
		}
		
		public function restore(context:WebGLContext2D):void {
			context._saveMark = _preSaveMark;
			_no[_no._length++] = this;
		}
		
		public static function Create(context:WebGLContext2D):SaveMark {
			var no:* = _no;
			var o:SaveMark = no._length > 0 ? no[--no._length] : (new SaveMark());
			o._saveuse = 0;
			o._preSaveMark = context._saveMark;
			context._saveMark = o;
			return o;
		}	
	}
}