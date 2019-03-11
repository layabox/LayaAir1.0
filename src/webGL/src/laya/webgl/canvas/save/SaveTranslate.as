package laya.webgl.canvas.save {
	import laya.maths.Matrix;
	import laya.webgl.canvas.WebGLContext2D;
	
	public class SaveTranslate implements ISaveData {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		private static var POOL:* =/*[STATIC SAFE]*/ SaveBase._createArray();
		public var _mat:Matrix=new Matrix();
		public function isSaveMark():Boolean { return false; }
		
		public function restore(context:WebGLContext2D):void {
			_mat.copyTo(context._curMat);
			POOL[POOL._length++] = this;
		}
		
		public static function save(context:WebGLContext2D):void {
			var no:* = POOL;
			var o:SaveTranslate = no._length > 0 ? no[--no._length] : (new SaveTranslate());
			context._curMat.copyTo(o._mat);
			var _save:Array = context._save;
			_save[_save._length++] = o;
		}
	
	}

}