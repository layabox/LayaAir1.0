package laya.display.cmd {
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 绘制描边文字
	 */
	public class StrokeTextCmd {
		public static const ID:String = "StrokeText";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**
		 * 在画布上输出的文本。
		 */
		public var text:String;
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
		/**
		 * 线条宽度。
		 */
		public var lineWidth:Number;
		/**
		 * 文本对齐方式，可选值："left"，"center"，"right"。
		 */
		public var textAlign:String;
		
		/**@private */
		public static function create(text:String, x:Number, y:Number, font:String, color:String, lineWidth:Number, textAlign:String):StrokeTextCmd {
			var cmd:StrokeTextCmd = Pool.getItemByClass("StrokeTextCmd", StrokeTextCmd);
			cmd.text = text;
			cmd.x = x;
			cmd.y = y;
			cmd.font = font;
			cmd.color = color;
			cmd.lineWidth = lineWidth;
			cmd.textAlign = textAlign;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			
			Pool.recover("StrokeTextCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.strokeWord(text, x + gx, y + gy, font, color, lineWidth, textAlign);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}