package laya.layagl.cmdNative
{
	import laya.layagl.LayaGL;
	import laya.layagl.LayaNative2D;
	import laya.utils.ColorUtils;
	import laya.maths.Point;
	import laya.resource.Texture;
	import laya.utils.Pool;
	import laya.maths.Matrix;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.canvas.DrawStyle;
	
	/**
	 * ...
	 * @author ww
	 */
	public class DrawTextureCmdNative
	{
		public static const ID:String = "DrawTexture";
		public static var _DRAW_TEXTURE_CMD_ENCODER_:* = null;
		public static var _DRAW_TEXTURE_CMD_ENCODER_MATRIX_:* = null;
		public static var _PARAM_UNIFORM_LOCATION_POS_:int = 0;
		public static var _PARAM_TEX_LOCATION_POS_:int = 1;
		public static var _PARAM_TEXTURE_POS_:int = 2;
		public static var _PARAM_RECT_NUM_POS_:int = 3;
		public static var _PARAM_VB_SIZE_POS_:int = 4;
		public static var _PARAM_VB_POS_:int = 5;
		public static var _PARAM_MATRIX_POS_:int = 29;
		public static var _PARAM_BLEND_SRC_POS_:int = 35;
		public static var _PARAM_BLEND_DEST_POS_:int = 36;
		
		
		private var _graphicsCmdEncoder:*;
		private var _index:int;
		private var _paramData:* = null;
		private var _texture:Texture;
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		private var _matrix:Matrix;
		private var _alpha:Number;
		private var _color:String;
		private var _blendMode:String;
		private var _cmdCurrentPos:int;
		private var _blend_src:int;
		private var _blend_dest:int;
		
		public static function create(texture:Texture, x:Number, y:Number, width:Number, height:Number, matrix:Matrix, alpha:Number, color:String, blendMode:String):DrawTextureCmdNative
		{
			var cmd:DrawTextureCmdNative = Pool.getItemByClass("DrawTextureCmd", DrawTextureCmdNative);
			cmd._graphicsCmdEncoder = __JS__("this._commandEncoder;");
			
			if (!_DRAW_TEXTURE_CMD_ENCODER_) 
			{
				_DRAW_TEXTURE_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(188, 32, true);
				_DRAW_TEXTURE_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				_DRAW_TEXTURE_CMD_ENCODER_.blendFuncByParamData(_PARAM_BLEND_SRC_POS_ * 4, _PARAM_BLEND_DEST_POS_ * 4);
				_DRAW_TEXTURE_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);//programID
				_DRAW_TEXTURE_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);//VAO ID
				_DRAW_TEXTURE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_TEXTURE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_TEXTURE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_TEXTURE_CMD_ENCODER_.uniformTextureByParamData(_PARAM_UNIFORM_LOCATION_POS_ * 4, _PARAM_TEX_LOCATION_POS_ * 4, _PARAM_TEXTURE_POS_ * 4);
				_DRAW_TEXTURE_CMD_ENCODER_.setRectMeshByParamData(_PARAM_RECT_NUM_POS_*4,_PARAM_VB_POS_*4,_PARAM_VB_SIZE_POS_*4 );
				_DRAW_TEXTURE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_TEXTURE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				LayaGL.syncBufferToRenderThread( _DRAW_TEXTURE_CMD_ENCODER_ );
			}
			
			if (!_DRAW_TEXTURE_CMD_ENCODER_MATRIX_) 
			{
				_DRAW_TEXTURE_CMD_ENCODER_MATRIX_ = LayaGL.instance.createCommandEncoder(224, 32, true);
				_DRAW_TEXTURE_CMD_ENCODER_MATRIX_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				_DRAW_TEXTURE_CMD_ENCODER_MATRIX_.blendFuncByParamData(_PARAM_BLEND_SRC_POS_ * 4, _PARAM_BLEND_DEST_POS_ * 4);
				_DRAW_TEXTURE_CMD_ENCODER_MATRIX_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);//programID
				_DRAW_TEXTURE_CMD_ENCODER_MATRIX_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);//VAO ID
				_DRAW_TEXTURE_CMD_ENCODER_MATRIX_.save();
				_DRAW_TEXTURE_CMD_ENCODER_MATRIX_.setGlobalValueByParamData(LayaNative2D.GLOBALVALUE_MATRIX32, LayaGL.VALUE_OPERATE_M32_MUL, _PARAM_MATRIX_POS_ * 4);
				_DRAW_TEXTURE_CMD_ENCODER_MATRIX_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_TEXTURE_CMD_ENCODER_MATRIX_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_TEXTURE_CMD_ENCODER_MATRIX_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_TEXTURE_CMD_ENCODER_MATRIX_.uniformTextureByParamData(_PARAM_UNIFORM_LOCATION_POS_ * 4, _PARAM_TEX_LOCATION_POS_ * 4, _PARAM_TEXTURE_POS_ * 4);
				_DRAW_TEXTURE_CMD_ENCODER_MATRIX_.setRectMeshByParamData(_PARAM_RECT_NUM_POS_*4,_PARAM_VB_POS_*4,_PARAM_VB_SIZE_POS_*4 );
				_DRAW_TEXTURE_CMD_ENCODER_MATRIX_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_TEXTURE_CMD_ENCODER_MATRIX_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				_DRAW_TEXTURE_CMD_ENCODER_MATRIX_.restore();
				LayaGL.syncBufferToRenderThread( _DRAW_TEXTURE_CMD_ENCODER_MATRIX_ );
			}
			
			if (!cmd._paramData)
			{
				cmd._paramData = __JS__("new ParamData(37*4, true)");
			}
			//给参数赋值
			{
				cmd._texture = texture;
				cmd._x = x;
				cmd._y = y;
				cmd._width = width;
				cmd._height = height;
				cmd._matrix = matrix;
				cmd._alpha = alpha;
				cmd._color = color;
				cmd._blendMode = blendMode;
				var w:Number = width != 0 ? width :  texture.bitmap.width;
				var h:Number = height != 0 ? height :  texture.bitmap.height;
				var uv:Array = texture.uv;
				var _fb:Float32Array = cmd._paramData._float32Data;
				var _i32b:Int32Array = cmd._paramData._int32Data;
				_i32b[_PARAM_UNIFORM_LOCATION_POS_] = 3;
				_i32b[_PARAM_TEX_LOCATION_POS_] = WebGLContext.TEXTURE0;
				_i32b[_PARAM_TEXTURE_POS_] = texture.bitmap._glTexture.id;
				_i32b[_PARAM_RECT_NUM_POS_] = 1;
				_i32b[_PARAM_VB_SIZE_POS_] = 24 * 4;
				
				if (blendMode) {
					cmd._setBlendMode(blendMode);
					_i32b[_PARAM_BLEND_SRC_POS_] = cmd._blend_src;
					_i32b[_PARAM_BLEND_DEST_POS_] = cmd._blend_dest;
				} else {
					_i32b[_PARAM_BLEND_SRC_POS_] = -1;
					_i32b[_PARAM_BLEND_DEST_POS_] = -1;
				}
				// Calculate color with alph
				var rgba:uint = 0xffffffff;
				if(alpha) {
					rgba = cmd._mixRGBandAlpha(rgba, alpha);
				}
				var ix:int = _PARAM_VB_POS_;
				_fb[ix++] = x; 		_fb[ix++] = y; 		_fb[ix++] = uv[0]; 	_fb[ix++] = uv[1]; _i32b[ix++] = rgba; _i32b[ix++] = 0xffffffff;
				_fb[ix++] = x + w; 	_fb[ix++] = y; 		_fb[ix++] = uv[2]; 	_fb[ix++] = uv[3]; _i32b[ix++] = rgba; _i32b[ix++] = 0xffffffff;
				_fb[ix++] = x + w; 	_fb[ix++] = y + h;	_fb[ix++] = uv[4];  _fb[ix++] = uv[5]; _i32b[ix++] = rgba; _i32b[ix++] = 0xffffffff;
				_fb[ix++] = x;		_fb[ix++] = y + h;  _fb[ix++] = uv[6];	_fb[ix++] = uv[7]; _i32b[ix++] = rgba; _i32b[ix++] = 0xffffffff;
				
				if (matrix) 
				{
					_fb[_PARAM_MATRIX_POS_] = matrix.a; _fb[_PARAM_MATRIX_POS_ +1] = matrix.b; _fb[_PARAM_MATRIX_POS_ +2] = matrix.c; 
					_fb[_PARAM_MATRIX_POS_+3] = matrix.d; _fb[_PARAM_MATRIX_POS_ +4] = matrix.tx; _fb[_PARAM_MATRIX_POS_ +5] = matrix.ty; 
				}
				LayaGL.syncBufferToRenderThread( cmd._paramData );
			}
			if (matrix) 
			{
				cmd._cmdCurrentPos = cmd._graphicsCmdEncoder.useCommandEncoder( _DRAW_TEXTURE_CMD_ENCODER_MATRIX_.getPtrID(), cmd._paramData.getPtrID(), -1);
			}
			else
			{
				cmd._cmdCurrentPos = cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_TEXTURE_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);
			}			
			LayaGL.syncBufferToRenderThread( cmd._graphicsCmdEncoder );
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void
		{
			_texture = null;
			Pool.recover("DrawTextureCmd", this);
		}
		
		public function get cmdID():String
		{
			return ID;
		}

		public function get texture():Texture
		{
			return _texture;
		}
		
		public function set texture(value:Texture):void
		{
			
			if (!value||!value.url)
			{
				return;
			}
			_texture = value;
			_paramData._int32Data[_PARAM_TEXTURE_POS_] = _texture.bitmap._glTexture.id;
			var _fb:Float32Array = _paramData._float32Data;
			var uv:Array = texture.uv;
			_fb[_PARAM_VB_POS_+2] = uv[0]; 	_fb[_PARAM_VB_POS_+3] = uv[1];
			_fb[_PARAM_VB_POS_+8] = uv[2]; 	_fb[_PARAM_VB_POS_+9] = uv[3];
			_fb[_PARAM_VB_POS_+14] = uv[4];	_fb[_PARAM_VB_POS_+15] = uv[5];
			_fb[_PARAM_VB_POS_ +20] = uv[6]; _fb[_PARAM_VB_POS_ +21] = uv[7];
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get x():Number
		{
			return _x; 
		}
		
		public function set x(value:Number):void
		{
			_x = value;
			var _fb:Float32Array = _paramData._float32Data;
			_fb[_PARAM_VB_POS_] = _x;
			_fb[_PARAM_VB_POS_+6] = _x + _width;
			_fb[_PARAM_VB_POS_+12] = _x + _width;
			_fb[_PARAM_VB_POS_ +18] = _x;
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
			var _fb:Float32Array = _paramData._float32Data;
			_fb[_PARAM_VB_POS_+1] = _y; 		
			_fb[_PARAM_VB_POS_+7] = _y; 		
			_fb[_PARAM_VB_POS_+13] = _y + _height;	
			_fb[_PARAM_VB_POS_ +19] = _y + _height; 
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
			var _fb:Float32Array = _paramData._float32Data;
			_fb[_PARAM_VB_POS_] = _x;
			_fb[_PARAM_VB_POS_+6] = _x + _width;
			_fb[_PARAM_VB_POS_+12] = _x + _width;
			_fb[_PARAM_VB_POS_ +18] = _x;
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
			var _fb:Float32Array = _paramData._float32Data;
			_fb[_PARAM_VB_POS_+1] = _y; 		
			_fb[_PARAM_VB_POS_+7] = _y; 		
			_fb[_PARAM_VB_POS_+13] = _y + _height;	
			_fb[_PARAM_VB_POS_ +19] = _y + _height; 
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		
		public function get matrix():Matrix
		{
			return _matrix;
		}
		
		public function set matrix(matrix:Matrix):void
		{
			if (!_matrix)
			{
				_graphicsCmdEncoder._idata[_cmdCurrentPos + 1] = _DRAW_TEXTURE_CMD_ENCODER_MATRIX_.getPtrID();
				LayaGL.syncBufferToRenderThread(_graphicsCmdEncoder);
			}
			_matrix = matrix;
			var _fb:Float32Array = _paramData._float32Data;
			_fb[_PARAM_MATRIX_POS_] = matrix.a;
			_fb[_PARAM_MATRIX_POS_+1] = matrix.b;
			_fb[_PARAM_MATRIX_POS_+2] = matrix.c;
			_fb[_PARAM_MATRIX_POS_+3] = matrix.d;
			_fb[_PARAM_MATRIX_POS_+4] = matrix.tx;
			_fb[_PARAM_MATRIX_POS_+5] = matrix.ty;
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
			_alpha = value;
		}
		
		public function _setBlendMode(value:String):void
		{
			switch(value)
			{
			case BlendMode.NORMAL:
				_blend_src = WebGLContext.ONE;
				_blend_dest = WebGLContext.ONE_MINUS_SRC_ALPHA;
				break;
			case BlendMode.ADD:
				_blend_src = WebGLContext.ONE;
				_blend_dest = WebGLContext.DST_ALPHA;
				break;
			case BlendMode.MULTIPLY:
				_blend_src = WebGLContext.DST_COLOR;
				_blend_dest = WebGLContext.ONE_MINUS_SRC_ALPHA;
				break;
			case BlendMode.SCREEN:
				_blend_src = WebGLContext.ONE;
				_blend_dest = WebGLContext.ONE;
				break;
			case BlendMode.LIGHT:
				_blend_src = WebGLContext.ONE;
				_blend_dest = WebGLContext.ONE;
				break;
			case BlendMode.OVERLAY:
				_blend_src = WebGLContext.ONE;
				_blend_dest = WebGLContext.ONE_MINUS_SRC_COLOR;
				break;
			case BlendMode.DESTINATIONOUT:
				_blend_src = WebGLContext.ZERO;
				_blend_dest = WebGLContext.ZERO;
				break;
			case BlendMode.MASK:
				_blend_src = WebGLContext.ZERO;
				_blend_dest = WebGLContext.SRC_ALPHA;
				break;
			default:
				alert("_setBlendMode Unknown type");
				break;
			}
		}
		
		public function _mixRGBandAlpha(color:uint, alpha:Number):uint {
			var a:int = ((color & 0xff000000) >>> 24);
			if (a != 0) {
				a*= alpha;
			}else {
				a=alpha*255;
			}
			return (color & 0x00ffffff) | (a << 24);	
		}
	}
}