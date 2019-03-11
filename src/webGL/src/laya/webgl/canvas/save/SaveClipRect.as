package laya.webgl.canvas.save {
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.submit.Submit;
	
	public class SaveClipRect implements ISaveData {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		private static var POOL:* =/*[STATIC SAFE]*/ SaveBase._createArray();
		
		//public var _clipSaveRect:Rectangle;
		//private var _transedClipInfo:Array = new Array(6);
		private var _globalClipMatrix:Matrix = new Matrix();
		private var _clipInfoID:int = -1;
		public var _clipRect:Rectangle = new Rectangle();
		
		public function isSaveMark():Boolean { return false; }
		
		public function restore(context:WebGLContext2D):void {
			/*
			context._transedClipInfo[0] = _transedClipInfo[0];
			context._transedClipInfo[1] = _transedClipInfo[1];
			context._transedClipInfo[2] = _transedClipInfo[2];
			context._transedClipInfo[3] = _transedClipInfo[3];
			context._transedClipInfo[4] = _transedClipInfo[4];
			context._transedClipInfo[5] = _transedClipInfo[5];
			*/
			_globalClipMatrix.copyTo(context._globalClipMatrix);
			_clipRect.clone(context._clipRect);
			context._clipInfoID = _clipInfoID;
			//context._clipTransed = false;	//直接重新计算
			POOL[POOL._length++] = this;
			/*
			context._clipRect = _clipSaveRect;
			context._curSubmit = context._submits[context._submits._length++] = Submit.RENDERBASE;
			context._submitKey.submitType=-1;
			*/
		}
		
		public static function save(context:WebGLContext2D):void {
			if ((context._saveMark._saveuse & SaveBase.TYPE_CLIPRECT) == SaveBase.TYPE_CLIPRECT) return;
			context._saveMark._saveuse |= SaveBase.TYPE_CLIPRECT;
			var cache:* = POOL;
			var o:SaveClipRect = cache._length > 0 ? cache[--cache._length] : (new SaveClipRect());
			//o._clipSaveRect = context._clipRect;
			//context._clipRect = o._clipRect.copyFrom(context._clipRect);
			//o._submitScissor = submitScissor;
			context._globalClipMatrix.copyTo(o._globalClipMatrix);
			/*
			o._transedClipInfo[0] = context._transedClipInfo[0];
			o._transedClipInfo[1] = context._transedClipInfo[1];
			o._transedClipInfo[2] = context._transedClipInfo[2];
			o._transedClipInfo[3] = context._transedClipInfo[3];
			o._transedClipInfo[4] = context._transedClipInfo[4];
			o._transedClipInfo[5] = context._transedClipInfo[5];
			*/
			context._clipRect.clone(o._clipRect);
			o._clipInfoID = context._clipInfoID;
			
			var _save:Array = context._save;
			_save[_save._length++] = o;
		}
	}
}