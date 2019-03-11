package laya.display.cmd {
	import laya.renders.Render;
	import laya.resource.Context;
	import laya.utils.ColorUtils;
	import laya.utils.FontInfo;
	import laya.utils.Pool;
	import laya.utils.WordText;
	
	/**
	 * 绘制文字
	 */
	public class FillTextCmd {
		public static const ID:String = "FillText";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		private var _text:String;
		/**@private */
		public var _textIsWorldText:Boolean = false;
		/**
		 * 开始绘制文本的 x 坐标位置（相对于画布）。
		 */
		public var x:Number;
		/**
		 * 开始绘制文本的 y 坐标位置（相对于画布）。
		 */
		public var y:Number;
		private var _font:String;
		private var _color:String;
		private var _textAlign:String;
		private var _fontColor:uint = 0xffffffff;
		private var _strokeColor:uint = 0;
		private static var _defFontObj:FontInfo = new FontInfo(null);
		private var _fontObj:FontInfo = _defFontObj;
		private var _nTexAlign:int = 0;
		
		/**@private */
		public static function create(text:String, x:Number, y:Number, font:String, color:String, textAlign:String):FillTextCmd {
			var cmd:FillTextCmd = Pool.getItemByClass("FillTextCmd", FillTextCmd);
			cmd.text = text;
			cmd._textIsWorldText = text is WordText;
			cmd.x = x;
			cmd.y = y;
			cmd.font = font;
			cmd.color = color;
			cmd.textAlign = textAlign;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			
			Pool.recover("FillTextCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			if (_textIsWorldText && context._fast_filltext) {
				__JS__('context._fast_filltext(this._text, this.x + gx, this.y + gy, this._fontObj, this._fontColor, 0, 0, this._nTexAlign, 0);');
			} else
				context.drawText(_text, x + gx, y + gy, _font, _color, _textAlign);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
		
		/**
		 * 在画布上输出的文本。
		 */
		public function get text():String {
			return _text;
		}
		
		public function set text(value:String):void {
			//TODO 问题。 怎么通知native
			_text = value;
			_textIsWorldText = value is WordText;
			_textIsWorldText && (_text as WordText).cleanCache();
		}
		
		/**
		 * 定义字号和字体，比如"20px Arial"。
		 */
		public function get font():String {
			return _font;
		}
		
		public function set font(value:String):void {
			_font = value;
			if (Render.isWebGL || Render.isConchApp) {
				_fontObj = FontInfo.Parse(value);
			}
			_textIsWorldText && (_text as WordText).cleanCache();
		}
		
		/**
		 * 定义文本颜色，比如"#ff0000"。
		 */
		public function get color():String {
			return _color;
		}
		
		public function set color(value:String):void {
			_color = value;
			_fontColor = ColorUtils.create(value).numColor;
			_textIsWorldText && (_text as WordText).cleanCache();
		}
		
		/**
		 * 文本对齐方式，可选值："left"，"center"，"right"。
		 */
		public function get textAlign():String {
			return _textAlign;
		}
		
		public function set textAlign(value:String):void {
			_textAlign = value;
			switch (value) {
			case 'center': 
				_nTexAlign = Context.ENUM_TEXTALIGN_CENTER;
				break;
			case 'right': 
				_nTexAlign = Context.ENUM_TEXTALIGN_RIGHT;
				break;
			default: 
				_nTexAlign = Context.ENUM_TEXTALIGN_DEFAULT;
			}
			_textIsWorldText && (_text as WordText).cleanCache();
		}
	}
}