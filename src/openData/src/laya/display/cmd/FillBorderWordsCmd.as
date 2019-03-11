package laya.display.cmd
{
	import laya.maths.Point;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Pool;
	import laya.maths.Matrix;
	
	/**
	 * 绘制边框
	 * @private
	 */
	public class FillBorderWordsCmd
	{
		public static const ID:String = "FillBorderWords";
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
		public var fillColor:String;
		/**
		 * 定义镶边文本颜色。
		 */
		public var borderColor:String;
		/**
		 * 镶边线条宽度。
		 */
		public var lineWidth:int;
		
		/**@private */
		public static function create(words:Array, x:Number, y:Number, font:String, fillColor:String, borderColor:String, lineWidth:int):FillBorderWordsCmd
		{
			var cmd:FillBorderWordsCmd = Pool.getItemByClass("FillBorderWordsCmd", FillBorderWordsCmd);
			cmd.words = words;
			cmd.x = x;
			cmd.y = y;
			cmd.font = font;
			cmd.fillColor = fillColor;
			cmd.borderColor = borderColor;
			cmd.lineWidth = lineWidth;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void
		{
			words = null;
			Pool.recover("FillBorderWordsCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void
		{
			context.fillBorderWords(words, x + gx, y + gy, font, fillColor, borderColor, lineWidth);
		}
		
		/**@private */
		public function get cmdID():String
		{
			return ID;
		}
	
	}
}