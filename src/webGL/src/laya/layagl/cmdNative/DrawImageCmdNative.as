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
	
	/**
	 * ...
	 * @author ww
	 */
	public class DrawImageCmdNative
	{
		public static const ID:String = "DrawImage";
		public static var _DRAW_IMAGE_CMD_ENCODER_:* = null;
		public static var _PARAM_TEXTURE_POS_:int = 2;
		public static var _PARAM_VB_POS_:int = 5;
		
		private var _graphicsCmdEncoder:*;
		private var _index:int;
		private var _paramData:* = null;
		private var _texture:Texture;
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		
		public static function create(texture:Texture,x:Number,y:Number,width:Number,height:Number):DrawImageCmdNative
		{
			var cmd:DrawImageCmdNative = Pool.getItemByClass("DrawImageCmd", DrawImageCmdNative);
			cmd._graphicsCmdEncoder = __JS__("this._commandEncoder;");
			
			if (!_DRAW_IMAGE_CMD_ENCODER_)
			{
				_DRAW_IMAGE_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(172, 32, true);
				_DRAW_IMAGE_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				_DRAW_IMAGE_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);//programID
				_DRAW_IMAGE_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);//VAO ID
				_DRAW_IMAGE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_IMAGE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_IMAGE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_IMAGE_CMD_ENCODER_.uniformTextureByParamData(0, 1 * 4, _PARAM_TEXTURE_POS_ * 4);
				_DRAW_IMAGE_CMD_ENCODER_.setRectMeshByParamData(3*4,_PARAM_VB_POS_*4,4*4 );
				_DRAW_IMAGE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_IMAGE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				LayaGL.syncBufferToRenderThread( _DRAW_IMAGE_CMD_ENCODER_ );
			}
			if (!cmd._paramData)
			{
				cmd._paramData = __JS__("new ParamData(29*4, true)");
			}
			//给参数赋值
			{
				cmd._texture = texture;
				texture._addReference();
				cmd._x = x;
				cmd._y = y;
				cmd._width = width;
				cmd._height = height;
				
				var _fb:Float32Array = cmd._paramData._float32Data;
				var _i32b:Int32Array = cmd._paramData._int32Data;
				_i32b[0] = 3;
				_i32b[1] = WebGLContext.TEXTURE0;
				_i32b[_PARAM_TEXTURE_POS_] = texture.getIsReady() ? texture.bitmap._glTexture.id : 0;
				_i32b[3] = 1;
				_i32b[4] = 24 * 4;
				var w:Number = width != 0 ? width :  texture.bitmap.width;
				var h:Number = height != 0 ? height :  texture.bitmap.height;
				var uv:Array = texture.uv;
				var ix:int = _PARAM_VB_POS_;
				_fb[ix++] = x; 		_fb[ix++] = y; 		_fb[ix++] = uv[0]; 	_fb[ix++] = uv[1]; _i32b[ix++] = 0xffffffff; _i32b[ix++] = 0xffffffff;
				_fb[ix++] = x + w; 	_fb[ix++] = y; 		_fb[ix++] = uv[2]; 	_fb[ix++] = uv[3]; _i32b[ix++] = 0xffffffff; _i32b[ix++] = 0xffffffff;
				_fb[ix++] = x + w; 	_fb[ix++] = y + h;	_fb[ix++] = uv[4];  _fb[ix++] = uv[5]; _i32b[ix++] = 0xffffffff; _i32b[ix++] = 0xffffffff;
				_fb[ix++] = x;		_fb[ix++] = y + h;  _fb[ix++] = uv[6];	_fb[ix++] = uv[7]; _i32b[ix++] = 0xffffffff; _i32b[ix++] = 0xffffffff;
				LayaGL.syncBufferToRenderThread( cmd._paramData );
			}
			cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_IMAGE_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);
			LayaGL.syncBufferToRenderThread( cmd._graphicsCmdEncoder );
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void
		{
			_texture._removeReference();
			_texture = null;
			_graphicsCmdEncoder = null;
			Pool.recover("DrawImageCmd", this);
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
			_texture = value;
			_paramData._int32Data[_PARAM_TEXTURE_POS_] = _texture.bitmap._glTexture.id;
			var _fb:Float32Array = _paramData._float32Data;
			var uv:Array = _texture.uv;
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
	}
}