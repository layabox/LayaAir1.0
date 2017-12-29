package laya.webgl.resource {
	import laya.display.Text;
	import laya.renders.Render;
	import laya.resource.Bitmap;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.Utils;
	import laya.webgl.atlas.AtlasResourceManager;
	
	public class WebGLCharImage extends Bitmap implements IMergeAtlasBitmap {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private const CborderSize:int = 12;
		private var _ctx:*;
		/***是否创建私有Source*/
		private var _allowMerageInAtlas:Boolean;
		/**是否允许加入大图合集*/
		private var _enableMerageInAtlas:Boolean;
		/**HTML Canvas，绘制字符载体,非私有数据载体*/
		public var canvas:*;
		/**********************************************************************************/
		public var cw:Number;
		public var ch:Number;
		public var xs:Number, ys:Number;
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
		public var underLine:int;
		/***********************************************************************************/
		/**
		 * 创建单个文字
		 * @param	content
		 * @param	drawValue
		 * @return
		 */
		public static function createOneChar(content:String, drawValue:*):WebGLCharImage {
			var char:WebGLCharImage = new WebGLCharImage(content, drawValue);
			return char;
		}
		
		public function active():void{
			texture.active();
		}
		
		
		public function get atlasSource():* {
			return canvas;
		}
		
		/**
		 * 是否创建私有Source
		 * @return 是否创建
		 */
		public function get allowMerageInAtlas():Boolean {
			return _allowMerageInAtlas;
		}
		
		/**
		 * 是否创建私有Source
		 * @return 是否创建
		 */
		public function get enableMerageInAtlas():Boolean {
			return _enableMerageInAtlas;
		}
		
		/**
		 * 是否创建私有Source,通常禁止修改
		 * @param value 是否创建
		 */
		public function set enableMerageInAtlas(value:Boolean):void {
			_enableMerageInAtlas = value;
		}
		
		/**
		 * WebGLCharImage依赖于外部canvas,自身并无私有数据载体
		 * @param	canvas
		 * @param	char
		 */
		public function WebGLCharImage(content:String, drawValue:*) {
			super();
			char = content;
			isSpace = content === ' ';
			xs = drawValue.scaleX;
			ys = drawValue.scaleY;
			font = drawValue.font.toString();
			fontSize = drawValue.font.size;
			fillColor = drawValue.fillColor;
			borderColor = drawValue.borderColor;
			lineWidth = drawValue.lineWidth;
			underLine = drawValue.underLine;
			var bIsConchApp:Boolean = Render.isConchApp;
			var pCanvas:*;
			if (bIsConchApp) {
				__JS__("pCanvas = ConchTextCanvas");
				__JS__("pCanvas._source = ConchTextCanvas");
				__JS__("pCanvas._source.canvas = ConchTextCanvas");
			} else {
				pCanvas = Browser.canvas.source;
			
			}
			
			
			this.canvas = pCanvas;
			//this.char = char;
			_enableMerageInAtlas = true;
		
			if (bIsConchApp) {
				__JS__("this._ctx = pCanvas;")
			} else {
				_ctx = canvas.getContext('2d', undefined);
			}
		
			var t:* = Utils.measureText(char, font);
			cw = t.width * xs;
			ch = (t.height || fontSize) * ys;
			
			onresize(cw + CborderSize * 2, ch + CborderSize * 2);
			
			texture = new Texture(this);
		}
		
		override protected function recreateResource():void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			//var char:DrawTextChar = this.char;
			
			var bIsConchApp:Boolean = Render.isConchApp;
			//var xs:Number = xs, ys:Number = char.ys;
			onresize(cw + CborderSize * 2, ch + CborderSize * 2);
			canvas && (canvas.height = _h, canvas.width = _w);//canvas为公用，其它地方也可能修改其尺寸
			if (bIsConchApp) {
				/*
				 *  参数说明：格式为	样式(normal、italic、oblique)	加粗	font-size	字体	borderSize	border颜色	DecorationLine(0代表没有 1下划线 2中划线 3上划线)	线的颜色
				 *  参数说明：格式为	normal 100 16px Arial 1 #ff0000 1 #00ff00
				 */
				var nFontSize:int = fontSize;
				if (xs != 1 || ys != 1) {
					//TODO先凑合一下，回头再把scale信息传入到C++
					nFontSize = parseInt(nFontSize * ((xs > ys) ? xs : ys) + "");
				}
				var sFont:String = "normal 100 " + nFontSize + "px Arial";
				if (borderColor) {
					sFont += " 1 " + borderColor;
				}
				_ctx.font = sFont;
				_ctx.textBaseline = "top";
				_ctx.fillStyle = fillColor;
				_ctx.fillText(char, CborderSize, CborderSize, null, null, null);
			} else {
				_ctx.save();
				(_ctx as Object).clearRect(0, 0, cw + CborderSize * 2, ch + CborderSize * 2);
				
				_ctx.font = font;
				if (Text.RightToLeft)
				{
					_ctx.textAlign = "end";
				}
				_ctx.textBaseline = "top";
				_ctx.translate(CborderSize, CborderSize);
				if (xs != 1 || ys != 1) {
					_ctx.scale(xs, ys);
				}
				
				if (fillColor && borderColor) {
					this._ctx.strokeStyle = this.borderColor;
					this._ctx.lineWidth = this.lineWidth;
					_ctx.strokeText(char, 0, 0, null, null, 0, null);
					_ctx.fillStyle = fillColor;
					_ctx.fillText(char, 0, 0, null, null, null);
				} else {
					if (lineWidth === -1) {
						_ctx.fillStyle = fillColor ? fillColor : "white";
						_ctx.fillText(char, 0, 0, null, null, null);
					} else {
						this._ctx.strokeStyle = this.borderColor?this.borderColor:'white';
						this._ctx.lineWidth = this.lineWidth;
						_ctx.strokeText(char, 0, 0, null, null, 0, null);
					}
				}
				if ( this.underLine )
				{
					this._ctx.lineWidth = 1;
					this._ctx.strokeStyle = this.fillColor;
					this._ctx.beginPath();
					this._ctx.moveTo(0, fontSize+1);
					var nW:int = this._ctx.measureText(char).width+1;
					this._ctx.lineTo(nW, fontSize+1);
					this._ctx.stroke();
				}
				_ctx.restore();
			}
			
			borderSize = CborderSize;
			completeCreate();
		}
		
		private function onresize(w:Number, h:Number):void {
			_w = w;
			_h = h;
			
			//文字强制加入大图合集
			_allowMerageInAtlas = true;
		}
		
		public function clearAtlasSource():void {//canvas为公用绘制载体,资源恢复时会使用,无需清空
		}
	}

}

