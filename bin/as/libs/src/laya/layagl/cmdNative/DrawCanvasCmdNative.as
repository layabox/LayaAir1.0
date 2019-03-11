package laya.layagl.cmdNative
{
	import laya.display.css.CacheStyle;
	import laya.layagl.LayaGL;
	import laya.layagl.LayaNative2D;
	import laya.utils.ColorUtils;
	import laya.maths.Point;
	import laya.resource.Texture;
	import laya.utils.Pool;
	import laya.maths.Matrix;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.RenderTexture2D;
	
	/**
	 * ...
	 * @author ww
	 */
	public class DrawCanvasCmdNative
	{
		public static const ID:String = "DrawCanvas";
		public static var _DRAW_CANVAS_CMD_ENCODER_:* = null;
		public static var _PARAM_TEXTURE_POS_:int = 2;
		public static var _PARAM_VB_POS_:int = 5;
		public static var _PARAM_CLIP_SIZE:int = 29;
		
		private var _graphicsCmdEncoder:*;
		private var _index:int;
		private var _paramData:* = null;
		private var _texture:RenderTexture2D;
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		
		public static function create(texture:RenderTexture2D,x:Number,y:Number,width:Number,height:Number):DrawCanvasCmdNative
		{
			var cmd:DrawCanvasCmdNative = Pool.getItemByClass("DrawCanvasCmd", DrawCanvasCmdNative);
			cmd._graphicsCmdEncoder = __JS__("this._commandEncoder;");
			createCommandEncoder();
			if (!cmd._paramData)
			{
				cmd._paramData = __JS__("new ParamData(33*4, true)");
			}
			cmd._texture = texture;
			cmd._x = x;
			cmd._y = y;
			cmd._width = width;
			cmd._height = height;
			setParamData(cmd._paramData,texture,x,y,width,height);
			
			var id1:int = _DRAW_CANVAS_CMD_ENCODER_.getPtrID();
			var id2:int = cmd._paramData.getPtrID();
			cmd._graphicsCmdEncoder.useCommandEncoder(id1,id2, -1);
			LayaGL.syncBufferToRenderThread( cmd._graphicsCmdEncoder );
			return cmd;
		}
		
		public static function createCommandEncoder():void
		{
			if (!_DRAW_CANVAS_CMD_ENCODER_)
			{
				_DRAW_CANVAS_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(172, 32, true);
				//TODO 这个地方mask的时候应该有问题
				//_DRAW_CANVAS_CMD_ENCODER_.save();
				//_DRAW_CANVAS_CMD_ENCODER_.setClipByParamData(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, LayaNative2D.GLOBALVALUE_MATRIX32, _PARAM_CLIP_SIZE * 4);
				_DRAW_CANVAS_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				_DRAW_CANVAS_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);//programID
				_DRAW_CANVAS_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);//VAO ID
				_DRAW_CANVAS_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_CANVAS_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_CANVAS_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_CANVAS_CMD_ENCODER_.uniformTextureByParamData(0, 1*4, _PARAM_TEXTURE_POS_*4);
				_DRAW_CANVAS_CMD_ENCODER_.setRectMeshByParamData(3*4,_PARAM_VB_POS_*4,4*4 );
				_DRAW_CANVAS_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_CANVAS_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				//_DRAW_CANVAS_CMD_ENCODER_.restore();
				LayaGL.syncBufferToRenderThread( _DRAW_CANVAS_CMD_ENCODER_ );
			}
		}
		
		public static function setParamData(_paramData:*,texture:RenderTexture2D,x:int,y:int,width:int,height:int):void
		{
			//给参数赋值
			var _fb:Float32Array = _paramData._float32Data;
			var _i32b:Int32Array = _paramData._int32Data;
			_i32b[0] = 3;
			_i32b[1] = WebGLContext.TEXTURE0;
			_i32b[_PARAM_TEXTURE_POS_] = texture._getSource().id;
			_i32b[3] = 1;
			_i32b[4] = 24 * 4;
			var w:Number = width != 0 ? width :  texture.width;
			var h:Number = height != 0 ? height :  texture.height;
			var uv:Array = RenderTexture2D.flipyuv;
			//var uv:Array = RenderTexture2D.defuv;
			var ix:int = _PARAM_VB_POS_;
			_fb[ix++] = x; 		_fb[ix++] = y; 		_fb[ix++] = uv[0]; 	_fb[ix++] = uv[1]; _i32b[ix++] = 0xffffffff; _i32b[ix++] = 0xffffffff;
			_fb[ix++] = x + w; 	_fb[ix++] = y; 		_fb[ix++] = uv[2]; 	_fb[ix++] = uv[3]; _i32b[ix++] = 0xffffffff; _i32b[ix++] = 0xffffffff;
			_fb[ix++] = x + w; 	_fb[ix++] = y + h;	_fb[ix++] = uv[4];  _fb[ix++] = uv[5]; _i32b[ix++] = 0xffffffff; _i32b[ix++] = 0xffffffff;
			_fb[ix++] = x;		_fb[ix++] = y + h;  _fb[ix++] = uv[6];	_fb[ix++] = uv[7]; _i32b[ix++] = 0xffffffff; _i32b[ix++] = 0xffffffff;
			_fb[_PARAM_CLIP_SIZE] = x+CacheStyle.CANVAS_EXTEND_EDGE;
			_fb[_PARAM_CLIP_SIZE+1] = y+CacheStyle.CANVAS_EXTEND_EDGE;
			_fb[_PARAM_CLIP_SIZE+2] = width-CacheStyle.CANVAS_EXTEND_EDGE*2;
			_fb[_PARAM_CLIP_SIZE+3] = height-CacheStyle.CANVAS_EXTEND_EDGE*2;
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void
		{
			_graphicsCmdEncoder = null;
			Pool.recover("DrawCanvasCmd", this);
		}
		
		public function get cmdID():String
		{
			return ID;
		}

		public function get texture():RenderTexture2D
		{
			return _texture;
		}
		
		public function set texture(value:RenderTexture2D):void
		{
			_texture = value;
			//TODO
			_paramData._int32Data[_PARAM_TEXTURE_POS_] = _texture._getSource().id;
			var _fb:Float32Array = _paramData._float32Data;
			var uv:Array = RenderTexture2D.flipyuv;
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
			_fb[_PARAM_CLIP_SIZE] = value+CacheStyle.CANVAS_EXTEND_EDGE;
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
			_fb[_PARAM_CLIP_SIZE+1] = value+CacheStyle.CANVAS_EXTEND_EDGE;
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
			_fb[_PARAM_CLIP_SIZE+2] = value-CacheStyle.CANVAS_EXTEND_EDGE*2;
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
			_fb[_PARAM_CLIP_SIZE+3] = value-CacheStyle.CANVAS_EXTEND_EDGE*2;
			LayaGL.syncBufferToRenderThread( _paramData );
		}
	}
}