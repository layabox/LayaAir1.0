package laya.webgl.canvas.save {
	import laya.maths.Matrix;
	import laya.webgl.canvas.WebGLContext2D;
	
	public class SaveTransform implements ISaveData {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		private static var _no:* =/*[STATIC SAFE]*/ SaveBase._createArray();
		
		public var _savematrix:Matrix;
		public var _matrix:Matrix = new Matrix();
		
		public function SaveTransform() {
			super()
		}
		
		public function isSaveMark():Boolean { return false; }
		
		public function restore(context:WebGLContext2D):void {
			context._curMat = _savematrix;
			_no[_no._length++] = this;
		}
		
		public static function save(context:WebGLContext2D):void {
			var _saveMark:* = context._saveMark;
			if ((_saveMark._saveuse & SaveBase.TYPE_TRANSFORM) === SaveBase.TYPE_TRANSFORM) return;
			_saveMark._saveuse |= SaveBase.TYPE_TRANSFORM;
			var no:* = _no;
			var o:SaveTransform = no._length > 0 ? no[--no._length] : (new SaveTransform());
			o._savematrix = context._curMat;
			context._curMat = context._curMat.copyTo(o._matrix);
			var _save:Array = context._save;
			_save[_save._length++] = o;
		}	
	}
}