package laya.flash.text
{
	import laya.display.Text;

	public class TextField extends Text
	{
		private var textFormat:TextFormat;
		
		public function TextField()
		{
		}
		
		public function getLineLength(lineIndex:int):int
		{
			return _lines[lineIndex].length;
		}
		
		public function getLineText(lineIndex:int):String
		{
			return _lines[lineIndex];
		}
		
		public function getTextFormat(beginIndex:int = -1, endIndex:int = -1):TextFormat
		{
			return textFormat;
		}
		
		public function replaceText(beginIndex:int, endIndex:int, newText:String):void
		{
			var leftPart:String = _text.substring(0, beginIndex);
			var rightPart:String = _text.substr(endIndex);
			
			this.text = leftPart + newText + rightPart;
		}
		
		public function setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1):void
		{
			this.textFormat = format;
			
			this.color = "#" + format.color.toString(16);
			this.align = format.align;
			this.bold = format.bold;
			this.font = format.font;
			this.italic = format.italic;
			this.leading = format.leading as int;
			this.fontSize = format.size as int;
			this.underline = format.underline;
		}
	}
}