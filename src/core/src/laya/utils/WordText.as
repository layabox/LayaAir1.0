package laya.utils {
	
	/**
	 * @private
	 */
	public class WordText {
		public var id:Number;
		public var save:Array = [];
		public var toUpperCase:String = null;
		public var changed:Boolean;
		private var _text:String;
		
		public function setText(txt:String):void {
			changed = true;
			_text = txt;
		}
		
		public function toString():String {
			return this._text;
		}
		
		public function get length():int {
			return this._text ? this._text.length : 0;
		}
		
		public function charCodeAt(i:int):Number {
			return this._text ? this._text.charCodeAt(i) : NaN;
		}
		
		public function charAt(i:int):String {
			return this._text ? this._text.charAt(i) : null;
		}
	}
}