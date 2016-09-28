package laya.webgl.text {
	import laya.renders.Render;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.webgl.resource.WebGLCharImage;
	
	public class DrawTextChar {
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
		
		public function DrawTextChar(content:String, drawValue:*) {
			char = content;
			isSpace = content === ' ';
			xs = drawValue.scaleX;
			ys = drawValue.scaleY;
			font = drawValue.font.toString();
			fontSize = drawValue.font.size;
			fillColor = drawValue.fillColor;
			borderColor = drawValue.borderColor;
			lineWidth = drawValue.lineWidth;
			
			var bIsConchApp:Boolean = Render.isConchApp;
			if (bIsConchApp) {
				__JS__("var pCanvas = ConchTextCanvas");
				__JS__("pCanvas._source = ConchTextCanvas");
				__JS__("pCanvas._source.canvas = ConchTextCanvas");
				__JS__("this.texture = new Texture(new WebGLCharImage(pCanvas, this))");
			} else {
				texture = new Texture(new WebGLCharImage(Browser.canvas.source, this));
			}
		}
		
		public function active():void {
			texture.active();
		}
		
		public static function createOneChar(content:String, drawValue:*):DrawTextChar {
			var char:DrawTextChar = new DrawTextChar(content, drawValue);
			return char;
		}
	}
}