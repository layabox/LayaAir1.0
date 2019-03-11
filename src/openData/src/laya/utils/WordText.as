package laya.utils {
	
	/**
	 * @private
	 */
	public class WordText {
		//TODO:
		public var id:Number;
		public var save:Array = [];
		public var toUpperCase:String = null;
		public var changed:Boolean;
		public var _text:String;
		public var width:int=-1;	//整个WordText的长度。-1表示没有计算还。
		public var pageChars:Array = [];	//把本对象的字符按照texture分组保存的文字信息。里面又是一个数组。具体含义见使用的地方。
		public var pageCharsStroke:Array = [];//
		public var startID:int = 0;	//上面的是个数组，但是可能前面都是空的，加个起始位置
		public var startIDStroke:int = 0;
		public var lastGCCnt:int = 0;	//如果文字gc了，需要检查缓存是否有效，这里记录上次检查对应的gc值。
		
		public function setText(txt:String):void {
			changed = true;
			_text = txt;
			width =-1;
			pageChars = [];//需要重新更新
		}
		
		//TODO:coverage
		public function toString():String {
			return this._text;
		}
		
		public function get length():int {
			return this._text ? this._text.length : 0;
		}
		
		//TODO:coverage
		public function charCodeAt(i:int):Number {
			return this._text ? this._text.charCodeAt(i) : NaN;
		}
		
		//TODO:coverage
		public function charAt(i:int):String {
			return this._text ? this._text.charAt(i) : null;
		}
		
		public function cleanCache():void {
			pageChars = [];	
			startID = 0;
		}
	}
}