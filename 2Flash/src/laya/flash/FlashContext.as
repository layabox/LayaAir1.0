/*[IF-FLASH]*/package laya.flash 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.utils.Color;
	import laya.utils.Stat;
	/**
	 * ...
	 * @author laya
	 */
	public class FlashContext  extends Context
	{
		private static var _textField:TextField = new TextField();
		private static var _dfontStr : String = "";
		private var _bitmapdata:BitmapData;
		private var _rectangle:Rectangle = new Rectangle();
		private var _flashCanvas:FlashCanvas;
		private var _fillColor:uint = 0;
		private var _textFormat:TextFormat;
		
		
		//@{ 以下为FlashContext的状态数据.目前用到的加入，还有没有加入的部分.
		private var _transx : Number = 0;
		private var _transy : Number = 0;
		private var _scalex : Number = 1;
		private var _scaley : Number = 1;
				
		private var _vecStateSave : Vector.<contextContent> = null;
		private var _curSSId : int = 0;
		//@}
		
		
		public    function get bitmapdata():BitmapData
		{
			return _bitmapdata;
		}
		
		public function FlashContext(c:FlashCanvas,w:Number,h:Number) 
		{
			super();
			_flashCanvas = c;
			w > 0 || (w = 800);
			h > 0 || (h = 800);
			size(w, h);
			
			_vecStateSave = new Vector.<contextContent>( 12 );
			for ( var ti :int = 0; ti < 12; ti ++ ) {
				_vecStateSave[ti] = new contextContent();
			}
		}
		
		public function size(w:Number, h:Number):void
		{
			if (w == 0 && h == 0)
			{
				return;
			}
			if (w < 0) w = _bitmapdata.width;
			if (h < 0) h = _bitmapdata.height;
			_bitmapdata = new BitmapData(w, h,true,0x00000000);
			(_flashCanvas.getDisplayObject() as Bitmap).bitmapData = _bitmapdata;
		}
		
		/*** @private */
		public override function translate(x:Number, y:Number):void {
			_transx = x;
			_transy = y;
		}
		
		/*** @private */
		public override function scale(scaleX:Number, scaleY:Number):void {
			_scalex = scaleX;
			_scaley = scaleY;
		}		
		
		/*** @private */
		public override function save():void {
			_curSSId ++;
			if ( _vecStateSave.length <= _curSSId )
				_vecStateSave.push( new contextContent() );
			var tc : contextContent = _vecStateSave[_curSSId];
			
			tc.scaleX = _scalex;
			tc.scaleY = _scaley;
			tc.transX = _transx;
			tc.transY = _transy;
		}
		
		/*** @private */
		public override function restore():void {
			_curSSId --;
			if ( _curSSId < 0 ) _curSSId = 0;
			var tc : contextContent = _vecStateSave[_curSSId];
			
			_scalex = tc.scaleX;
			_scaley = tc.scaleY;
			_transx = tc.transX;
			_transy = tc.transY;		
		}		
		
		public override function fillRect(x:Number, y:Number, width:Number, height:Number, style:*):void {
			Stat.drawCall++;
			style && (this.fillStyle = style);
			_rectangle.x = x; _rectangle.y = y; _rectangle.width = width; _rectangle.height = height;
			_bitmapdata.fillRect(_rectangle, _fillColor);
		}
		
		public override function clearRect(x:Number, y:Number, width:Number, height:Number):void {
			_rectangle.x = x; _rectangle.y = y; _rectangle.width = width; _rectangle.height = height;
			_bitmapdata.fillRect(_rectangle, 0x00000000);
		}
		/**
		 * 得到类似于"rgba( 50,50,30,0.8 )"   返回了ARGB的32位UINT
		 * @param	color
		 * @return
		 */
		private static function _getRGBA( color: String ) : uint {
			if (color.indexOf("rgba") != 0)
			{
				return Color.create(color).numColor;
			}
			var arr : Array = color.substring( color.indexOf("(") + 1, color.indexOf(")") ).split( "," );
			if ( arr.length != 4 ) return 0;
			return ((int(Number(arr[3]) * 0xff))<<24) + (int(arr[0]) << 16) + (int(arr[1]) << 8) + int(arr[2]);
		}
		
		/*** @private */
		public override function set fillStyle(value:*):void {
			_fillColor = _getRGBA(value as String);			
		}
		
		/*** @private */
		public override function set font(str:String):void {
			_dfontStr = str;
		}
		
		
		public static function __measureText(txt:String, font:String):* {
			if ( font == "" )
				font = _dfontStr;
				
			var textFormat:TextFormat = _textFormatMap[font];
			if (!textFormat)
			{
				//textFormat = _textFormatMap[font] = new TextFormat(font);
				
				// var ctxFont:String = (italic ? "italic " : "") + (bold ? "bold " : "") + fontSize + "px " + font;
				// 总共有4种格式需要处理:
				var ta : Array = font.split( "px " );
				var size : int = 14;
				var fname : String = "Verdana";
				var bbold : Boolean = false;
				var italic : Boolean = false;				
				if ( ta.length > 1 ) {
					fname = ta[1];
					var a1 : Array = (ta[0] as String).split( " " );
					if( a1.length == 1 )
						size = parseInt( ta[0] );
					else if( a1.length == 2 ){
						if ( a1[0] == "bold" )
							bbold = true;
						if ( a1[0] == "italic" )
							italic = true;
						size = parseInt( a1[1] as String );
					}else if ( a1.length == 3 ) {
						if ( a1[0] == "italic" )
							italic = true;
						if ( a1[1] == "bold" )
							bbold = true;
						size = parseInt( a1[2] as String );						
					}
				}
				
				textFormat = _textFormatMap[font] = new TextFormat(fname,size,null,bbold,italic );
			}
			_textField.defaultTextFormat = textFormat;
			_textField.setTextFormat(textFormat);			
			_textField.text = txt;
			//trace( "The font name & text:" + textFormat.font + "," + txt + "," + textFormat.size );
			var rect : Rectangle = _textField.getCharBoundaries( 0 );	
			if( rect ){
				rect.width = _textField.textWidth;
				rect.height = _textField.textHeight;
			}
			
			if( rect )
				return  { width: rect.width, height: rect.height };
			else
				return { width : 0, height : 0 };
		}
		
		/*** @private */
		public override function measureText(text:String):* {
			return __measureText( text,"" );
		}		
		
		/*** @private */
		private static var _textFormatMap:Dictionary = new Dictionary();
		private var _drawMatrix : Matrix = new Matrix( 1, 0, 0, 1 );
		public override function fillText(text:*, x:Number, y:Number, font:String, color:String, textAlign:String):void {
			Stat.drawCall++;
			var txtColor:uint = _fillColor;
			if (color) txtColor = _getRGBA(color);
			_textField.textColor = txtColor;
			/*if (font)
			{
				var textFormat:TextFormat = _textFormatMap[font];
				_textField.setTextFormat(new TextFormat(font));
			}*/
			var t_rect : Rectangle = _textField.getCharBoundaries( 0 );
			_textField.text = text;
			
			// River:这个_textField不设宽高，不设置AutoSize是个大坑。
			// 先调试画字顶点的数据和UV,再调试大图合集，最后才调到sourceCanvas,调了一天.
			_textField.autoSize = TextFieldAutoSize.LEFT;

			//_bitmapdata.draw( _textField, new Matrix(1, 0, 0, 1, x, y ) );
			_drawMatrix.identity();
			_drawMatrix.scale( _scalex, _scaley );
			_drawMatrix.tx = x + _transx;
			_drawMatrix.ty = y + _transy - 3;
			_bitmapdata.floodFill( 0, 0, 0 );
			_bitmapdata.draw( _textField, _drawMatrix );	
			
			/* River: 以下为测试文字的代码:
			var spi : Sprite = new Sprite();
			spi.addChild( new Bitmap( _bitmapdata ) );
			FlashMain.sta.addChild( spi );
			spi.x = 500;
			spi.y = 100;
			*/
		}
		
	}

}

/**
 * 用于FlashContext的Save和Restore
 */
class contextContent {
	public var scaleX : Number = 1.0;
	public var scaleY : Number = 1.0;
	public var transX : Number = 0.0;
	public var transY : Number = 0.0;
	public function contextContent() {
		
	}
}