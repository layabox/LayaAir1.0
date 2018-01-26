package laya.webgl.canvas.save {
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.submit.Submit;
	
	public class SaveBase implements ISaveData {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/*[DISBALEOUTCONST-BEGIN]*/
		public static const TYPE_ALPHA:int = 0x1;
		public static const TYPE_FILESTYLE:int = 0x2;
		public static const TYPE_FONT:int = 0x8;
		public static const TYPE_LINEWIDTH:int = 0x100;
		public static const TYPE_STROKESTYLE:int = 0x200;
		public static const TYPE_MARK:int = 0x400;
		public static const TYPE_TRANSFORM:int = 0x800;
		public static const TYPE_TRANSLATE:int = 0x1000;
		public static const TYPE_ENABLEMERGE:int = 0x2000;
		
		public static const TYPE_TEXTBASELINE:int = 0x4000;
		public static const TYPE_TEXTALIGN:int = 0x8000;
		public static const TYPE_GLOBALCOMPOSITEOPERATION:int = 0x10000;
		public static const TYPE_CLIPRECT:int = 0x20000;
		public static const TYPE_CLIPRECT_STENCIL:int = 0x40000;
		public static const TYPE_IBVB:int = 0x80000;
		public static const TYPE_SHADER:int = 0x100000;
		public static const TYPE_FILTERS:int = 0x200000;
		public static const TYPE_FILTERS_TYPE:int = 0x400000;
		/*[DISBALEOUTCONST-END]*/
		private static var _cache:* =/*[STATIC SAFE]*/ SaveBase._createArray();
		private static var _namemap:* =/*[STATIC SAFE]*/ _init();
		
		public static function _createArray():Array {
			var value:* = [];
			value._length = 0;
			return value;
		}
		
		public static function _init():* {
			var namemap:* = _namemap = {};
			
			namemap[TYPE_ALPHA] = "ALPHA";
			namemap[TYPE_FILESTYLE] = "fillStyle";
			namemap[TYPE_FONT] = "font";
			namemap[TYPE_LINEWIDTH] = "lineWidth";
			namemap[TYPE_STROKESTYLE] = "strokeStyle";
			
			namemap[TYPE_ENABLEMERGE] = "_mergeID";
			
			namemap[TYPE_MARK] = namemap[TYPE_TRANSFORM] = namemap[TYPE_TRANSLATE] = [];
			
			namemap[TYPE_TEXTBASELINE] = "textBaseline";
			namemap[TYPE_TEXTALIGN] = "textAlign";
			namemap[TYPE_GLOBALCOMPOSITEOPERATION] = "_nBlendType";
			namemap[TYPE_SHADER] = "shader";
			namemap[TYPE_FILTERS] = "filters";
			
			return namemap;
		}
		
		private var _valueName:String;
		private var _value:*;
		private var _dataObj:*;
		private var _newSubmit:Boolean;
		
		public function SaveBase() {
		}
		
		public function isSaveMark():Boolean { return false; }
		
		public function restore(context:WebGLContext2D):void {
			_dataObj[_valueName] = _value;
			_cache[_cache._length++] = this;
			_newSubmit && (context._curSubmit = Submit.RENDERBASE, context._renderKey = 0);
		}
		
		public static function save(context:WebGLContext2D, type:int, dataObj:*, newSubmit:Boolean):void {
			if ((context._saveMark._saveuse & type) !== type) {
				context._saveMark._saveuse |= type;
				var cache:* = _cache;
				var o:* = cache._length > 0 ? cache[--cache._length] : (new SaveBase());
				o._value = dataObj[o._valueName = _namemap[type]];
				o._dataObj = dataObj;
				o._newSubmit = newSubmit;
				var _save:Array = context._save;
				_save[_save._length++] = o;
			}
		}
	}

}