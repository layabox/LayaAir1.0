package laya.layagl.cmdNative {
	import laya.layagl.LayaGL;
	import laya.layagl.LayaNative2D;
	import laya.resource.Texture;
	import laya.utils.Pool;
	import laya.webgl.WebGLContext;
	/**
	 * ...
	 * @author ww
	 */
	public class DrawTexturesCmdNative  {
		public static const ID:String = "DrawTextures";
		public static var _DRAW_TEXTURES_CMD_ENCODER_:* = null;
		public static var _PARAM_UNIFORMLOCATION_POS_:int = 0;
		public static var _PARAM_TEXLOCATION_POS_:int = 1;
		public static var _PARAM_TEXTURE_POS_:int = 2;
		public static var _PARAM_RECT_NUM_POS_:int = 3;
		public static var _PARAM_VB_POS_:int = 4;
		public static var _PARAM_VB_SIZE_POS_:int = 5;
		public static var _PARAM_VB_OFFSET_POS_:int = 6;
		
		private var _graphicsCmdEncoder:*;
		private var _index:int;
		private var _paramData:* = null;
		private var _texture:Texture;
		private var _pos:Array;
		private var _rectNum:int;
		private var _vbSize:int = 0;
		private var vbBuffer:*;
		
		public static function create(texture:Texture, pos:Array):DrawTexturesCmdNative {
			var cmd:DrawTexturesCmdNative = Pool.getItemByClass("DrawTexturesCmd", DrawTexturesCmdNative);
			cmd._graphicsCmdEncoder = __JS__("this._commandEncoder;");
			if (!_DRAW_TEXTURES_CMD_ENCODER_)
			{
				_DRAW_TEXTURES_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(124, 32, true);
				_DRAW_TEXTURES_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				_DRAW_TEXTURES_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);//programID
				_DRAW_TEXTURES_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);//VAO ID
				_DRAW_TEXTURES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_TEXTURES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_TEXTURES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_TEXTURES_CMD_ENCODER_.uniformTextureByParamData(_PARAM_UNIFORMLOCATION_POS_, _PARAM_TEXLOCATION_POS_*4, _PARAM_TEXTURE_POS_*4);
				_DRAW_TEXTURES_CMD_ENCODER_.setRectMeshExByParamData(_PARAM_RECT_NUM_POS_*4, _PARAM_VB_POS_ * 4, _PARAM_VB_SIZE_POS_ * 4, _PARAM_VB_OFFSET_POS_ * 4);
				_DRAW_TEXTURES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_TEXTURES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				LayaGL.syncBufferToRenderThread( _DRAW_TEXTURES_CMD_ENCODER_ );
			}
			if (!cmd._paramData)
			{
				cmd._paramData = __JS__("new ParamData(7*4, true)");
			}
			//给参数赋值
			{			
				cmd._texture = texture;
				cmd._pos = pos;
				var w:Number = texture.bitmap.width;
				var h:Number = texture.bitmap.height;
				var uv:Array = texture.uv;
				var nRectNum:int = pos.length / 2;
				// Save vb
				if (!cmd.vbBuffer || cmd.vbBuffer.getByteLength() < nRectNum * 24* 4)
				{
					cmd.vbBuffer = __JS__("new ParamData(nRectNum*24*4, true)");						
				}
				cmd._vbSize = nRectNum * 24 * 4;
				cmd._rectNum = nRectNum;
				var _vb:Float32Array = cmd.vbBuffer._float32Data;
				var _vb_i32b:Int32Array = cmd.vbBuffer._int32Data;
				var ix:int = 0;
				
				for (var i:int = 0; i < nRectNum; i++)
				{
					var x:Number = pos[i * 2];
					var y:Number = pos[i * 2 + 1];
					_vb[ix++] = x; 		_vb[ix++] = y; 		_vb[ix++] = uv[0]; 	_vb[ix++] = uv[1]; _vb_i32b[ix++] = 0xffffffff; _vb_i32b[ix++] = 0xffffffff;
					_vb[ix++] = x + w; 	_vb[ix++] = y; 		_vb[ix++] = uv[2]; 	_vb[ix++] = uv[3]; _vb_i32b[ix++] = 0xffffffff; _vb_i32b[ix++] = 0xffffffff;
					_vb[ix++] = x + w; 	_vb[ix++] = y + h;	_vb[ix++] = uv[4];  _vb[ix++] = uv[5]; _vb_i32b[ix++] = 0xffffffff; _vb_i32b[ix++] = 0xffffffff;
					_vb[ix++] = x;		_vb[ix++] = y + h;  _vb[ix++] = uv[6];	_vb[ix++] = uv[7]; _vb_i32b[ix++] = 0xffffffff; _vb_i32b[ix++] = 0xffffffff;
				}
				
				// Save all the data into _paramData
				var _fb:Float32Array = cmd._paramData._float32Data;
				var _i32b:Int32Array = cmd._paramData._int32Data;
				_i32b[_PARAM_UNIFORMLOCATION_POS_] = 3;
				_i32b[_PARAM_TEXLOCATION_POS_] = WebGLContext.TEXTURE0;
				_i32b[_PARAM_TEXTURE_POS_] = texture.bitmap._glTexture.id;
				_i32b[_PARAM_RECT_NUM_POS_] = cmd._rectNum;
				_i32b[_PARAM_VB_POS_] = cmd.vbBuffer.getPtrID();
				_i32b[_PARAM_VB_SIZE_POS_] = cmd._vbSize;
				_i32b[_PARAM_VB_OFFSET_POS_] = 0;
				LayaGL.syncBufferToRenderThread(cmd.vbBuffer);
				LayaGL.syncBufferToRenderThread( cmd._paramData);			
			}
			cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_TEXTURES_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);
			LayaGL.syncBufferToRenderThread( cmd._graphicsCmdEncoder);
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			_texture = null;
			_pos = null;
			Pool.recover("DrawTexturesCmd", this);
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
			var w:Number = _texture.bitmap.width;
			var h:Number = _texture.bitmap.height;
			var uv:Array = _texture.uv;
			var _vb:Float32Array = vbBuffer._float32Data;
			var _vb_i32b:Int32Array = vbBuffer._int32Data;
			var ix:int = 0;
			for (var i:int = 0; i < _rectNum; i++)
			{
				var x:Number = pos[i * 2];
				var y:Number = pos[i * 2 + 1];
				//layajs编译会有bug，所以把太长的一行打散
				_vb[ix++] = x; 		
				_vb[ix++] = y; 		
				_vb[ix++] = uv[0]; 	
				_vb[ix++] = uv[1]; 
				_vb_i32b[ix++] = 0xffffffff; 
				_vb_i32b[ix++] = 0xffffffff;
				_vb[ix++] = x + w; 	
				_vb[ix++] = y; 		
				_vb[ix++] = uv[2]; 	
				_vb[ix++] = uv[3]; 
				_vb_i32b[ix++] = 0xffffffff; 
				_vb_i32b[ix++] = 0xffffffff;
				_vb[ix++] = x + w; 	
				_vb[ix++] = y + h;	
				_vb[ix++] = uv[4];  
				_vb[ix++] = uv[5]; 
				_vb_i32b[ix++] = 0xffffffff; 
				_vb_i32b[ix++] = 0xffffffff;
				_vb[ix++] = x;		
				_vb[ix++] = y + h;  
				_vb[ix++] = uv[6];	
				_vb[ix++] = uv[7]; 
				_vb_i32b[ix++] = 0xffffffff; 
				_vb_i32b[ix++] = 0xffffffff;
			}
			var _i32b:Int32Array = _paramData._int32Data;
			_i32b[_PARAM_TEXLOCATION_POS_] = WebGLContext.TEXTURE0;
			_i32b[_PARAM_TEXTURE_POS_] = _texture.bitmap._glTexture.id;
			LayaGL.syncBufferToRenderThread(vbBuffer);
			LayaGL.syncBufferToRenderThread(_paramData);
		}
		public function get pos():Array
		{
			return _pos;
		}
		
		public function set pos(value:Array):void
		{
			_pos = value;
			var nRectNum:int = _pos.length / 2;
			var w:Number = _texture.bitmap.width;
			var h:Number = _texture.bitmap.height;
			var uv:Array = _texture.uv;
			if (!vbBuffer || vbBuffer.getByteLength() < nRectNum * 24* 4)
			{
				vbBuffer = __JS__("new ParamData(nRectNum*24*4, true)");					
			}
			_vbSize = nRectNum * 24 * 4;
			_rectNum = nRectNum;
			var _vb:Float32Array = vbBuffer._float32Data;
			var _vb_i32b:Int32Array = vbBuffer._int32Data;
			var ix:int = 0;
			for (var i:int = 0; i < nRectNum; i++)
			{
				var x:Number = pos[i * 2];
				var y:Number = pos[i * 2 + 1];
				_vb[ix++] = x; 		_vb[ix++] = y; 		_vb[ix++] = uv[0]; 	_vb[ix++] = uv[1]; _vb_i32b[ix++] = 0xffffffff; _vb_i32b[ix++] = 0xffffffff;
				_vb[ix++] = x + w; 	_vb[ix++] = y; 		_vb[ix++] = uv[2]; 	_vb[ix++] = uv[3]; _vb_i32b[ix++] = 0xffffffff; _vb_i32b[ix++] = 0xffffffff;
				_vb[ix++] = x + w; 	_vb[ix++] = y + h;	_vb[ix++] = uv[4];  _vb[ix++] = uv[5]; _vb_i32b[ix++] = 0xffffffff; _vb_i32b[ix++] = 0xffffffff;
				_vb[ix++] = x;		_vb[ix++] = y + h;  _vb[ix++] = uv[6];	_vb[ix++] = uv[7]; _vb_i32b[ix++] = 0xffffffff; _vb_i32b[ix++] = 0xffffffff;
			}
			// Save all the data into _paramData
			var _fb:Float32Array = _paramData._float32Data;
			var _i32b:Int32Array = _paramData._int32Data;
			_i32b[_PARAM_RECT_NUM_POS_] = _rectNum;
			_i32b[_PARAM_VB_POS_] = vbBuffer.getPtrID();
			_i32b[_PARAM_VB_SIZE_POS_] = _vbSize;
			LayaGL.syncBufferToRenderThread(vbBuffer);
			LayaGL.syncBufferToRenderThread( _paramData);
		}
	}
}