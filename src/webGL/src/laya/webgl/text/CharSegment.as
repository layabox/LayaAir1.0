package laya.webgl.text {
	
	/**
	 * ...特殊的字符，如泰文，必须重新实现这个类
	 */
	public class CharSegment implements ICharSegment {
		private var _sourceStr:String;
		
		public function CharSegment() {
		}
		
		public function textToSpit(str:String):void {
			_sourceStr = str;
		}
		
		public function getChar(i:int):String {
			return _sourceStr.charAt(i);
		}
		
		public function getCharCode(i:int):int {
			return _sourceStr.charCodeAt(i);
		}
		
		public function length():int {
			return _sourceStr.length;
		}
	
	}

}