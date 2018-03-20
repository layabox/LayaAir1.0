package laya.webgl.canvas.save {
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.submit.Submit;
	import laya.webgl.submit.SubmitStencil;
	
	public class SaveClipRectStencil implements ISaveData {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		private static var _cache:* = SaveBase._createArray();
		
		public var _clipSaveRect:Rectangle;
		public var _clipRect:Rectangle = new Rectangle();
		public var _rect:Rectangle = new Rectangle();
		public var _saveMatrix:Matrix;
		public var _matrix:Matrix = new Matrix();
		
		public var _contextX:Number = 0;
		public var _contextY:Number = 0;
		
		public var _submitStencil:SubmitStencil;
		
		public function isSaveMark():Boolean { return false; }
		
		public function restore(context:WebGLContext2D):void {
			//恢复模板
			SubmitStencil.restore(context,_rect,_saveMatrix,_contextX,_contextY);
			
			context._clipRect = _clipSaveRect;
			context._curMat = _saveMatrix;
			context._x = _contextX;
			context._y = _contextY;
			_cache[_cache._length++] = this;
			//先屏蔽掉，这个stencil模板缓冲区还没有考虑嵌套的情况
			//_submitStencil.submitLength = context._submits._length - _submitStencil.submitIndex;
			context._curSubmit = Submit.RENDERBASE;
		}
		
		public static function save(context:WebGLContext2D, submitStencil:SubmitStencil, x:Number, y:Number, width:Number, height:Number, clipX:Number, clipY:Number, clipWidth:Number, clipHeight:Number):void {
			if ((context._saveMark._saveuse & SaveBase.TYPE_CLIPRECT_STENCIL) == SaveBase.TYPE_CLIPRECT_STENCIL) return;
			context._saveMark._saveuse |= SaveBase.TYPE_CLIPRECT_STENCIL;
			var cache:* = _cache;
			var o:SaveClipRectStencil = cache._length > 0 ? cache[--cache._length] : (new SaveClipRectStencil());
			o._clipSaveRect = context._clipRect;
			o._clipRect.setTo(clipX, clipY, clipWidth, clipHeight);
			context._clipRect = o._clipRect;
			
			o._rect.x = x;
			o._rect.y = y;
			o._rect.width = width;
			o._rect.height = height;
			
			//sava x y
			o._contextX =  context._x;
			o._contextY =  context._y;
			
			//save matrix
			o._saveMatrix = context._curMat;
			context._curMat.copyTo( o._matrix );
			context._curMat = o._matrix;
			
			o._submitStencil = submitStencil;
			var _save:Array = context._save;
			_save[_save._length++] = o;
		}
	}
}