package laya.layagl.cmdNative {
	import laya.layagl.LayaGL;
	import laya.layagl.LayaNative2D;
	import laya.maths.Matrix;
	import laya.resource.Texture;
	import laya.utils.ColorUtils;
	import laya.utils.HTMLChar;
	import laya.utils.Pool;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.CharBook;
	import laya.webgl.text.TextRender;

	/**
	 * 填充文字命令
	 */
	public class FillBorderWordsCmdNative {
		public static const ID:String = "FillBorderWords";
		public var _draw_texture_cmd_encoder_:* = LayaGL.instance.createCommandEncoder(64, 32, true);
		private var _graphicsCmdEncoder:*;
		private static var cbook:CharBook = Laya['textRender'];
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private var words:Array;
		private var x:Number;
		private var y:Number;
		private var font:String;
		private var color:String;
		private var strokeColor:String;
		private var strokeWidth:int;
		
		public static function create(words:Array, x:Number, y:Number, font:String, color:String, strokeColor:String, strokeWidth:int):FillBorderWordsCmdNative {
			if (!cbook) new Error('Error:charbook not create!');
			var cmd:FillBorderWordsCmdNative = Pool.getItemByClass("FillBorderWordsCmd", FillBorderWordsCmdNative);
			var cbuf:* = cmd._graphicsCmdEncoder = __JS__("this._commandEncoder;");
			
			cmd.words = words;
			cmd.x = x;
			cmd.y = y;
			cmd.font = font;
			cmd.color = color;
			cmd.strokeColor = strokeColor;
			cmd.strokeWidth = strokeWidth;
			cmd._draw_texture_cmd_encoder_.clearEncoding();
			cmd.createFillBorderText(cmd._draw_texture_cmd_encoder_, words as Vector.<HTMLChar>, x, y, font, color, strokeColor, strokeWidth);
			LayaGL.syncBufferToRenderThread( cmd._draw_texture_cmd_encoder_ );
			cbuf.useCommandEncoder(cmd._draw_texture_cmd_encoder_.getPtrID(), -1, -1);
			LayaGL.syncBufferToRenderThread( cbuf );
			return cmd;
		}
		private function createFillBorderText(cbuf:*, data:Vector.<HTMLChar>, x:Number, y:Number, font:String, color:String, strokeColor:String, strokeWidth:int):void {
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
			cbook.filltext_native(ctx, null, data, x, y, font, color, strokeColor, strokeWidth, null, 0);
		}
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			_graphicsCmdEncoder = null;
			words = null;
			Pool.recover("FillBorderWordsCmd", this);
		}
		
		public function get cmdID():String {
			return ID;
		}
	
	}
}