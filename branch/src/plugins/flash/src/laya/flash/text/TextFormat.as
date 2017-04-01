package laya.flash.text
{
	public class TextFormat
	{
		public var align:String = "left";
		public var bold:Object = false;
		public var color:int = 0;	
		public var font:String;
		public var italic:Boolean = false;
		public var leading:int = 0;
		public var size:int = 12;
		public var underline:Boolean = false;

		public function TextFormat(font:String = null, size:int = null, color:int = null, bold:Boolean = null, italic:Boolean = null, underline:Boolean = null, url:String = null, target:String = null, align:String = null, leftMargin:Object = null, rightMargin:Object = null, indent:Object = null, leading:int = null)
		{
			this.font = font || this.font;
			this.size = size || this.size;
			this.color = color || this.color;
			this.bold = bold || this.bold;
			this.italic = italic || this.italic;
			this.underline = underline || this.underline;
			this.align = align || this.align;
			this.leading = leading || this.leading;
		}
	}
}