package laya.utils {
	
	/**
	 * @private
	 * <code>HTMLChar</code> 是一个 HTML 字符类。
	 */
	public class HTMLChar {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private static var _isWordRegExp:RegExp =/*[STATIC SAFE]*/ new RegExp("[\\w\.]", "");
		
		/** x坐标*/
		public var x:Number;
		/** y坐标*/
		public var y:Number;
		/** 宽*/
		public var width:Number;
		/** 高*/
		public var height:Number;
		/** 表示是否是正常单词(英文|.|数字)。*/
		public var isWord:Boolean;
		/** 字符。*/
		public var char:String;
		/** 字符数量。*/
		public var charNum:Number;
		/** CSS 样式。*/
		public var style:*;
		
		/**
		 * 创建实例
		 */
		public function HTMLChar() {
			reset();
		}
		
		/**
		 * 根据指定的字符、宽高、样式，创建一个 <code>HTMLChar</code> 类的实例。
		 * @param	char 字符。
		 * @param	w 宽度。
		 * @param	h 高度。
		 * @param	style CSS 样式。
		 */
		public function setData(char:String, w:Number, h:Number, style:*):HTMLChar {
			this.char = char;
			this.charNum = char.charCodeAt(0);
			x = y = 0;
			this.width = w;
			this.height = h;
			this.style = style;
			this.isWord = !_isWordRegExp.test(char);
			return this;
		}
		
		/**
		 * 重置
		 */
		public function reset():HTMLChar {
			x = y = width = height = 0;
			isWord = false;
			char = null;
			charNum = 0;
			style = null;
			return this;
		}
		
		/**
		 * 回收
		 */
		//TODO:coverage
		public function recover():void {
			Pool.recover("HTMLChar", reset());
		}
		
		/**
		 * 创建
		 */
		public static function create():HTMLChar {
			return Pool.getItemByClass("HTMLChar", HTMLChar);
		}
		
		/** @private */
		public function _isChar():Boolean {
			return true;
		}
		
		/** @private */
		public function _getCSSStyle():* {
			return style;
		}
	}
}