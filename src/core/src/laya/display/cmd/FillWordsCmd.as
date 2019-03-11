package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 填充文字命令
	 * @private
	 */
	public class FillWordsCmd {
		public static const ID:String = "FillWords";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**
		 * 文字数组
		 */
		public var words:Array;
		/**
		 * 开始绘制文本的 x 坐标位置（相对于画布）。
		 */
		public var x:Number;
		/**
		 * 开始绘制文本的 y 坐标位置（相对于画布）。
		 */
		public var y:Number;
		/**
		 * 定义字体和字号，比如"20px Arial"。
		 */
		public var font:String;
		/**
		 * 定义文本颜色，比如"#ff0000"。
		 */
		public var color:String;
		
		/**@private */
		public static function create(words:Array, x:Number, y:Number, font:String, color:String):FillWordsCmd {
			var cmd:FillWordsCmd = Pool.getItemByClass("FillWordsCmd", FillWordsCmd);
			cmd.words = words;
			cmd.x = x;
			cmd.y = y;
			cmd.font = font;
			cmd.color = color;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			words = null;
			Pool.recover("FillWordsCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.fillWords(words, x + gx, y + gy, font, color);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}