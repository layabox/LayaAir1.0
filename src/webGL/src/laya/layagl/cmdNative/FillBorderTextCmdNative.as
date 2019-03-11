package laya.layagl.cmdNative {
	import laya.layagl.LayaGL;
	import laya.layagl.LayaNative2D;
	import laya.maths.Matrix;
	import laya.resource.Texture;
	import laya.utils.ColorUtils;
	import laya.utils.Pool;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.CharBook;
	import laya.webgl.text.TextRender;
	
	public class FillBorderTextCmdNative{
		public static const ID:String = "FillBorderText";
		public var _draw_texture_cmd_encoder_:* = LayaGL.instance.createCommandEncoder(64, 32, true);
		private var _graphicsCmdEncoder:*;
		private var _index:int;
		private static var cbook:CharBook = Laya['textRender'];
		private var _text:String;
		private var _x:Number;
		private var _y:Number;
		private var _font:String;
		private var _color:String;
		private var _strokeColor:String;
		private var _strokeWidth:int;
		private var _textAlign:String;
		
		public static function create(text:String, x:Number, y:Number, font:String, color:String, strokeColor:String, strokeWidth:int, textAlign:String):FillBorderTextCmdNative {
            
			if (!cbook) new Error('Error:charbook not create!');
			var cmd:FillBorderTextCmdNative = Pool.getItemByClass("FillBorderTextCmd", FillBorderTextCmdNative);
			var cbuf:* = cmd._graphicsCmdEncoder = __JS__("this._commandEncoder;");
			
			// 保存数据
			cmd._text = text;
			cmd._x = x;
			cmd._y = y;
			cmd._font = font;
			cmd._color = color;
			cmd._strokeColor = strokeColor;
			cmd._strokeWidth = strokeWidth;
			cmd._textAlign = textAlign;
			cmd._draw_texture_cmd_encoder_.clearEncoding();
			cmd.createFillBorderText(cmd._draw_texture_cmd_encoder_, text, x, y, font, color, strokeColor, strokeWidth, textAlign);
			LayaGL.syncBufferToRenderThread( cmd._draw_texture_cmd_encoder_ );
			cbuf.useCommandEncoder(cmd._draw_texture_cmd_encoder_.getPtrID(), -1, -1);
			LayaGL.syncBufferToRenderThread( cbuf );
			return cmd;
		}
		
		private function createFillBorderText(cbuf:*, text:String, x:Number, y:Number, font:String, color:String, strokeColor:String, strokeWidth:int, textAlign:String):void {
			var c1:ColorUtils = ColorUtils.create(color);
			var nColor:uint = c1.numColor;
			var ctx:* = { };
			ctx._curMat = new Matrix();
			ctx._italicDeg = 0;
			ctx._drawTextureUseColor = 0xffffffff;
			ctx.fillStyle = color;
			ctx._fillColor = 0xffffffff;
			ctx.setFillColor=function(color:uint):void {
				ctx._fillColor = color;
			}
			ctx.getFillColor=function():uint {
				return ctx._fillColor;
			}
			ctx.mixRGBandAlpha = function(value:uint):Number
			{
				return value;
			}
			ctx._drawTextureM = function(tex:Texture, x:Number, y:Number, width:Number, height:Number, m:Matrix, alpha:Number, uv:Array):void {
				cbuf.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				cbuf.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);
				cbuf.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);//VAO ID
				cbuf.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				cbuf.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				cbuf.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				cbuf.uniformTexture(3, WebGLContext.TEXTURE0, tex.bitmap._glTexture);
				var buffer:Float32Array = new Float32Array([
					x, y, uv[0], uv[1], 0, 0, 
					x+width, y, uv[2],uv[3], 0, 0,   
					x+width, y+height, uv[4],uv[5], 0, 0,
					x, y + height, uv[6], uv[7], 0, 0]);
				var i32:Int32Array = new Int32Array(buffer.buffer);
				i32[4] = i32[10] = i32[16] = i32[22] = 0xffffffff;
				i32[5] = i32[11] = i32[17] = i32[23] = 0xffffffff;
				cbuf.setRectMesh(1,buffer, buffer.length );
				cbuf.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				cbuf.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				LayaGL.syncBufferToRenderThread( cbuf );
			}
			cbook.filltext_native(ctx, text, null, x, y, font, color, strokeColor, strokeWidth, textAlign);
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void{
			_graphicsCmdEncoder = null;
			Pool.recover("FillBorderTextCmd", this);
		}
		
		public function get cmdID():String{
			return ID;
		}
		
		public function get color():String{
			return _color;
		}
		
		public function set color(value:String):void{
			var cbuf:* = _draw_texture_cmd_encoder_;
			cbuf.clearEncoding();
			_color = value;
			createFillBorderText(cbuf, _text, _x, _y, _font, _color, _strokeColor, _strokeWidth, _textAlign);
			LayaGL.syncBufferToRenderThread( cbuf );
		}
		
		public function get text():String{
			return _text;
		}
		
		public function set text(value:String):void{
			var cbuf:* = _draw_texture_cmd_encoder_;
			cbuf.clearEncoding();
			_text = value;
			createFillBorderText(cbuf, _text, _x, _y, _font, _color, _strokeColor, _strokeWidth, _textAlign);
			LayaGL.syncBufferToRenderThread( cbuf );
		}
		
		public function get x():Number{
			return _x;
		}
		
		public function set x(value:Number):void{
			var cbuf:* = _draw_texture_cmd_encoder_;
			cbuf.clearEncoding();
			_x = value;
			createFillBorderText(cbuf, _text, _x, _y, _font, _color, _strokeColor, _strokeWidth, _textAlign);
			LayaGL.syncBufferToRenderThread( cbuf );
		}
		
		public function get y():Number{
			return _y;
		}
		
		public function set y(value:Number):void{
			var cbuf:* = _draw_texture_cmd_encoder_;
			cbuf.clearEncoding();
			_y = value;
			createFillBorderText(cbuf, _text, _x, _y, _font, _color, _strokeColor, _strokeWidth, _textAlign);
			LayaGL.syncBufferToRenderThread( cbuf );
		}
		
		public function get font():String{
			return _font;
		}
		
		public function set font(value:String):void{
			var cbuf:* = _draw_texture_cmd_encoder_;
			cbuf.clearEncoding();
			_font = value;
			createFillBorderText(cbuf, _text, _x, _y, _font, _color, _strokeColor, _strokeWidth, _textAlign);
			LayaGL.syncBufferToRenderThread( cbuf );
		}
		
		public function get textAlign():String{
			return _textAlign;
		}
		
		public function set textAlign(value:String):void{
			var cbuf:* = _draw_texture_cmd_encoder_;
			cbuf.clearEncoding();
			_textAlign = value;
			createFillBorderText(cbuf, _text, _x, _y, _font, _color, _strokeColor, _strokeWidth, _textAlign);
			LayaGL.syncBufferToRenderThread( cbuf );
		}
	}
}