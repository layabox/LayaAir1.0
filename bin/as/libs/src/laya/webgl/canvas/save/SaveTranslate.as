package laya.webgl.canvas.save {
	import laya.maths.Matrix;
	import laya.webgl.canvas.WebGLContext2D;
	
	public class SaveTranslate implements ISaveData {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		private static var _no:* =/*[STATIC SAFE]*/ SaveBase._createArray();
		
		public var _x:Number;
		public var _y:Number;
		
		public function isSaveMark():Boolean { return false; }
		
		public function restore(context:WebGLContext2D):void {
			var mat:Matrix = context._curMat;
			context._x = _x;
			context._y = _y;
			_no[_no._length++] = this;
		}
		
		public static function save(context:WebGLContext2D):void {
			var no:* = _no;
			var o:SaveTranslate = no._length > 0 ? no[--no._length] : (new SaveTranslate());
			o._x = context._x;
			o._y = context._y;
			var _save:Array = context._save;
			_save[_save._length++] = o;
		}
	
	}

}