package laya.webgl.text
{
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.system.System;
	import laya.utils.Browser;
	import laya.utils.Stat;
	import laya.utils.Utils;
	import laya.webgl.atlas.AtlasManager;
	import laya.webgl.resource.WebGLCharImage;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DrawTextChar
	{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var xs:Number, ys:Number;
		public var width:int, height:int;
		public var char:String;
		public var fillColor:String;
		public var borderColor:String;
		public var borderSize:int;
		public var font:String;
		public var fontSize:int;
		public var texture:Texture;
		public var lineWidth:int;
		public var UV:Array;
		public var isSpace:Boolean;
		
		public function DrawTextChar(content:String, drawValue:CharValue)
		{
			char = content;
			isSpace = content === ' ';
			xs = drawValue.scaleX;
			ys = drawValue.scaleY;
			font = drawValue.font.toString();
			fontSize = drawValue.size;
			fillColor = drawValue.fillColor;
			borderColor = drawValue.borderColor;
			lineWidth = drawValue.lineWidth;
			
			var bIsConchApp:Boolean = System.isConchApp;
			if (bIsConchApp)
			{
				__JS__("canvas = ConchTextCanvas;");
				__JS__("canvas._source = ConchTextCanvas;");
				__JS__("canvas._source.canvas = ConchTextCanvas;");
			}
			else
			{
				texture = new Texture(new WebGLCharImage(Browser.canvas.source, this));
				(!AtlasManager.enabled) && (System.addToAtlas) && (System.addToAtlas(texture, true));//如果没有开启大图合集则也强制加入图集中
			}
		}
		
		public function active():void
		{
			texture.active();
		}
		
		public static function createOneChar(content:String, drawValue:CharValue):DrawTextChar
		{
			var char:DrawTextChar = new DrawTextChar(content, drawValue);
			return char;
		}
	}

}