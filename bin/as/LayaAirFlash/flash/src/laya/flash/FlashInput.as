/*[IF-FLASH]*/
package laya.flash 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import laya.display.Input;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FlashInput extends FlashElement 
	{
		private var _multiline:Boolean;
		public var target:Input;
		public var _style:TextFormat = new TextFormat();
		
		public function FlashInput(multiline:Boolean) 
		{
			super();
			_multiline = multiline;
			
		}
			
		override public function createDisplayObject():DisplayObject
		{
			var tf:TextField = new TextField();
			tf.type = TextFieldType.INPUT;
			return tf;
		}
		
		public function set readOnly(value:Boolean):void
		{
			(_displayObject as TextField).type = (value ? TextFieldType.DYNAMIC :TextFieldType.INPUT);;
		}
		
		public function set maxLength(value:int):void
		{
			(_displayObject as TextField).maxChars = value;
		}
		
		public function set value(val:String):void
		{
			(_displayObject as TextField).text = val;
		}
		
		public function get value():String
		{
			return (_displayObject as TextField).text;
		}
		
		public function set type(value:String):void
		{
			(_displayObject as TextField).displayAsPassword = (value == "password");
		}
		
		public function set placeholder(value:String):void
		{
			
		}
		
		public function focus():void
		{
			(_displayObject as TextField).mouseEnabled = true;
			(_displayObject as TextField).multiline = _multiline;
			Window.stage.focus = (_displayObject as TextField);
		}
		
		public function setColor(value:String):void
		{
			_style.color = parseInt("0x" + value.substring(1));
			applyStyle();
		}
		
		public function setFontSize(value:int):void
		{
			_style.size = value;
			applyStyle();
		}
		
		public function setFontFace(value:String):void
		{
			_style.font = value;
			applyStyle();
		}
		
		private function applyStyle():void
		{
			(_displayObject as TextField).defaultTextFormat = _style;
			(_displayObject as TextField).setTextFormat(_style);
		}
		
		public function setSize(w:int, h:int):void
		{
			_displayObject.width = w;
			_displayObject.height = h;
		}
		
		public function setRestrict(value:String):void
		{
			(_displayObject as TextField).restrict = value;
		}
		
		override public function addEventListener(type:String,  listener:Function, useCapture:Boolean=false):void
		{
			// Empty
		}
	}
}