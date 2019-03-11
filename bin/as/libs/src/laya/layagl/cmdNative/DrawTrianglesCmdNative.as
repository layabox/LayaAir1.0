package laya.layagl.cmdNative {
	import laya.filters.ColorFilter;
	import laya.layagl.LayaGL;
	import laya.layagl.LayaNative2D;
	import laya.maths.Matrix;
	import laya.resource.Texture;
	import laya.utils.ColorUtils;
	import laya.utils.Pool;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.BlendMode;
	/**
	 * ...
	 * @author ww
	 */
	public class DrawTrianglesCmdNative  {
		public static const ID:String = "DrawTriangles";
		
		public static var _DRAW_TRIANGLES_CMD_ENCODER_:* = null;
		public static var _DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_:* = null;
		public static var _PARAM_UNIFORMLOCATION_POS_:int = 0;
		public static var _PARAM_TEXLOCATION_POS_:int = 1;
		public static var _PARAM_TEXTURE_POS_:int = 2;
		public static var _PARAM_VB_POS_:int = 3;
		public static var _PARAM_VB_SIZE_POS_:int = 4;
		public static var _PARAM_IB_POS_:int = 5;
		public static var _PARAM_IB_SIZE_POS_:int = 6;
		public static var _PARAM_VB_OFFSET_POS_:int = 7;
		public static var _PARAM_IB_OFFSET_POS_:int = 8;
		public static var _PARAM_INDEX_ELEMENT_OFFSET_POS_:int = 9;
		public static var _PARAM_BLEND_SRC_POS_:int = 10;
		public static var _PARAM_BLEND_DEST_POS_:int = 11;
		public static var _PARAM_MATRIX_POS_:int = 12;
		public static var _PARAM_FILTER_COLOR_POS_:int = 18;
		public static var _PARAM_FILTER_ALPHA_POS_:int = 34;
		
		private var _graphicsCmdEncoder:*;
		private var _paramData:* = null;
		private var _texture:Texture;
		private var _x:Number;
		private var _y:Number;
		private var _vertices:Float32Array;
		private var _uvs:Float32Array;
		private var _indices:Uint16Array;
		private var _matrix:Matrix;
		private var _alpha:Number;
		private var _color:String;
		private var _blendMode:String;
		private var vbBuffer:*;
		private var _vbSize:Number;
		private var ibBuffer:*;
		private var _ibSize:Number;
		private var _verticesNum:Number;
		private var _ibNum:Number;
		private var _blend_src:int;
		private var _blend_dest:int;
		
		public static function create(texture:Texture,x:Number,y:Number,vertices:Float32Array,uvs:Float32Array,indices:Uint16Array,matrix:Matrix,alpha:Number,color:String,blendMode:String):DrawTrianglesCmdNative {
			var cmd:DrawTrianglesCmdNative = Pool.getItemByClass("DrawTrianglesCmd", DrawTrianglesCmdNative);
			cmd._graphicsCmdEncoder = __JS__("this._commandEncoder;");
			if (!_DRAW_TRIANGLES_CMD_ENCODER_)
			{
				_DRAW_TRIANGLES_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(152, 32, true);
				
				_DRAW_TRIANGLES_CMD_ENCODER_.save();	// Save the current status.
				_DRAW_TRIANGLES_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				_DRAW_TRIANGLES_CMD_ENCODER_.blendFuncByParamData(_PARAM_BLEND_SRC_POS_ * 4, _PARAM_BLEND_DEST_POS_ * 4);
				_DRAW_TRIANGLES_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);//programID
				_DRAW_TRIANGLES_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);//VAO ID				
				// Multiply the local matrix to global matrix => setGlobalValueByParam
				_DRAW_TRIANGLES_CMD_ENCODER_.setGlobalValueByParamData(LayaNative2D.GLOBALVALUE_MATRIX32, LayaGL.VALUE_OPERATE_M32_MUL, _PARAM_MATRIX_POS_ * 4);
				_DRAW_TRIANGLES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_TRIANGLES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_TRIANGLES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_TRIANGLES_CMD_ENCODER_.uniformTextureByParamData(_PARAM_UNIFORMLOCATION_POS_ * 4, _PARAM_TEXLOCATION_POS_ * 4, _PARAM_TEXTURE_POS_ * 4);
				
				_DRAW_TRIANGLES_CMD_ENCODER_.setMeshExByParamData(_PARAM_VB_POS_ * 4, _PARAM_VB_OFFSET_POS_*4, _PARAM_VB_SIZE_POS_ * 4, _PARAM_IB_POS_ * 4, _PARAM_IB_OFFSET_POS_*4, _PARAM_IB_SIZE_POS_ * 4, _PARAM_INDEX_ELEMENT_OFFSET_POS_ * 4);
				_DRAW_TRIANGLES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_TRIANGLES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				_DRAW_TRIANGLES_CMD_ENCODER_.restore();
				LayaGL.syncBufferToRenderThread( _DRAW_TRIANGLES_CMD_ENCODER_ );
			}
			if (!_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_)
			{
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(152, 32, true);
				
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.save();	// Save the current status.
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.blendFuncByParamData(_PARAM_BLEND_SRC_POS_ * 4, _PARAM_BLEND_DEST_POS_ * 4);
				
				// Add color filter
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.addShaderMacro( LayaNative2D.SHADER_MACRO_COLOR_FILTER);
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.setGlobalValueByParamData(LayaNative2D.GLOBALVALUE_COLORFILTER_COLOR, LayaGL.VALUE_OPERATE_SET, _PARAM_FILTER_COLOR_POS_ * 4);
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.setGlobalValueByParamData(LayaNative2D.GLOBALVALUE_COLORFILTER_ALPHA, LayaGL.VALUE_OPERATE_SET, _PARAM_FILTER_ALPHA_POS_ * 4);
				
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);//programID
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);//VAO ID	
				
				// Multiply the local matrix to global matrix => setGlobalValueByParam
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.setGlobalValueByParamData(LayaNative2D.GLOBALVALUE_MATRIX32, LayaGL.VALUE_OPERATE_M32_MUL, _PARAM_MATRIX_POS_ * 4);
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.uniformTextureByParamData(_PARAM_UNIFORMLOCATION_POS_ * 4, _PARAM_TEXLOCATION_POS_ * 4, _PARAM_TEXTURE_POS_ * 4);
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.setMeshExByParamData(_PARAM_VB_POS_ * 4, _PARAM_VB_OFFSET_POS_*4, _PARAM_VB_SIZE_POS_ * 4, _PARAM_IB_POS_ * 4, _PARAM_IB_OFFSET_POS_*4, _PARAM_IB_SIZE_POS_ * 4, _PARAM_INDEX_ELEMENT_OFFSET_POS_ * 4);
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.restore();
				LayaGL.syncBufferToRenderThread( _DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_ );
			}
			if (!cmd._paramData)
			{
				cmd._paramData = __JS__("new ParamData(38*4, true)");
			}
			//给参数赋值
			{
				cmd._texture = texture;
				cmd._x = x;
				cmd._y = y;
				cmd._vertices = vertices;
				cmd._uvs = uvs;
				cmd._indices = indices;
				if (matrix) {
					cmd._matrix = matrix;
				} else {
					cmd._matrix = new Matrix();
				}
				cmd._alpha = alpha;
				cmd._color = color;
				cmd._blendMode = blendMode;
				
				// Color filter
				var colorFilter:ColorFilter = new ColorFilter();
				var rgba:ColorUtils = ColorUtils.create(color);
				colorFilter.color(rgba.arrColor[0], rgba.arrColor[1], rgba.arrColor[2], rgba.arrColor[3]);
				
				cmd._verticesNum = cmd._vertices.length / 2;
				var verticesNumCopy:int = cmd._verticesNum;
				if (!cmd.vbBuffer || cmd.vbBuffer.getByteLength() < verticesNumCopy * 24 * 3)
				{
					cmd.vbBuffer = __JS__("new ParamData(verticesNumCopy*24*3, true)");					
				}
				cmd._vbSize = verticesNumCopy * 24 * 3;
				var _vb:Float32Array = cmd.vbBuffer._float32Data;
				var _vb_i32b:Int32Array = cmd.vbBuffer._int32Data;
				// Calculate color with alph
				var nrgba:uint = 0xffffffff;
				if(alpha) {
					//var drawstyle:DrawStyle = color? DrawStyle.create(color) : DrawStyle.DEFAULT;
					nrgba = cmd._mixRGBandAlpha(nrgba, alpha);
				}
				var ix:int = 0;
				for (var i:int = 0; i < cmd._verticesNum; i++)
				{
					_vb[ix++] = x/cmd._matrix.a + vertices[i * 2];	_vb[ix++] = y/cmd._matrix.d + vertices[i * 2 + 1]; _vb[ix++] = uvs[i * 2]; _vb[ix++] = uvs[i * 2 + 1];   _vb_i32b[ix++] = nrgba; _vb_i32b[ix++] = 0xffffffff;
				}
				
				// Save ib
				cmd._ibNum = indices.length;
				var ibNumCopy:int = cmd._ibNum;
				if (!cmd.ibBuffer || cmd.ibBuffer.getByteLength() < ibNumCopy * 2)
				{
					cmd.ibBuffer = __JS__("new ParamData(ibNumCopy* 2,true,true)");
				}
				cmd._ibSize = ibNumCopy* 2;
				var _ib:Int16Array = cmd.ibBuffer._int16Data;
				var idxpos:int = 0;
				for (var ii:int = 0; ii < cmd._ibNum; ii++) 
				{
					_ib[idxpos++] = indices[ii];
				}
				
			}
			// Save all the data into _paramData
			var _fb:Float32Array = cmd._paramData._float32Data;
			var _i32b:Int32Array = cmd._paramData._int32Data;
			_i32b[_PARAM_UNIFORMLOCATION_POS_] = 3;
			_i32b[_PARAM_TEXLOCATION_POS_] = WebGLContext.TEXTURE0;
			_i32b[_PARAM_TEXTURE_POS_] = texture.bitmap._glTexture.id;
			//_i32b[_PARAM_RECT_NUM_POS_] = cmd._nTrianglesNum;
			_i32b[_PARAM_VB_POS_] = cmd.vbBuffer.getPtrID();
			_i32b[_PARAM_VB_SIZE_POS_] = cmd._vbSize;
			_i32b[_PARAM_IB_POS_] = cmd.ibBuffer.getPtrID();
			_i32b[_PARAM_IB_SIZE_POS_] = cmd._ibSize;
			_i32b[_PARAM_VB_OFFSET_POS_] = 0;
			_i32b[_PARAM_IB_OFFSET_POS_] = 0;
			_i32b[_PARAM_INDEX_ELEMENT_OFFSET_POS_] = 0;
			_fb[_PARAM_MATRIX_POS_] = cmd._matrix.a; _fb[_PARAM_MATRIX_POS_ +1] = cmd._matrix.b; _fb[_PARAM_MATRIX_POS_ +2] = cmd._matrix.c; 
			_fb[_PARAM_MATRIX_POS_ +3] = cmd._matrix.d; _fb[_PARAM_MATRIX_POS_ +4] = cmd._matrix.tx; _fb[_PARAM_MATRIX_POS_ +5] = cmd._matrix.ty;
			if (blendMode) {
				cmd._setBlendMode(blendMode);
				_i32b[_PARAM_BLEND_SRC_POS_] = cmd._blend_src;
				_i32b[_PARAM_BLEND_DEST_POS_] = cmd._blend_dest;
			} else {
				_i32b[_PARAM_BLEND_SRC_POS_] = -1;
				_i32b[_PARAM_BLEND_DEST_POS_] = -1;
			}
			// Set color filter
			if (color) {
				ix = _PARAM_FILTER_COLOR_POS_;
				var mat:Float32Array = colorFilter._mat;
				_fb[ix++] = mat[0]; _fb[ix++] = mat[1]; _fb[ix++] = mat[2]; _fb[ix++] = mat[3]; 
				_fb[ix++] = mat[4]; _fb[ix++] = mat[5]; _fb[ix++] = mat[6]; _fb[ix++] = mat[7]; 
				_fb[ix++] = mat[8]; _fb[ix++] = mat[9]; _fb[ix++] = mat[10]; _fb[ix++] = mat[11]; 
				_fb[ix++] = mat[12]; _fb[ix++] = mat[13]; _fb[ix++] = mat[14]; _fb[ix++] = mat[15];
				ix = _PARAM_FILTER_ALPHA_POS_;
				var _alpha:Float32Array = colorFilter._alpha;
				_fb[ix++] = _alpha[0] * 255; _fb[ix++] = _alpha[1] * 255; _fb[ix++] = _alpha[2] * 255; _fb[ix++] = _alpha[3] * 255;
			}
			  
			LayaGL.syncBufferToRenderThread(cmd.vbBuffer);
			LayaGL.syncBufferToRenderThread(cmd.ibBuffer);
			LayaGL.syncBufferToRenderThread( cmd._paramData);
			if (color)
			{
				cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_TRIANGLES_COLORFILTER_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);
			}
			else 
			{
				cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_TRIANGLES_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);
			}			
			LayaGL.syncBufferToRenderThread( cmd._graphicsCmdEncoder);
			
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			_texture = null;
			_vertices = null;
			_uvs = null;
			_indices = null;
			_matrix = null;
			Pool.recover("DrawTrianglesCmd", this);
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
			var _i32b:Int32Array = _paramData._int32Data;
			_i32b[_PARAM_TEXTURE_POS_] = _texture.bitmap._glTexture.id;
			LayaGL.syncBufferToRenderThread(_paramData);
		}
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
			var _vb:Float32Array = vbBuffer._float32Data;
			var ix:int = 0;
			for (var i:int = 0; i < _verticesNum; i++)
			{
				_vb[ix++] = value + vertices[i * 2];	ix++;	ix++;	ix++;	ix++;	ix++;
			}
			LayaGL.syncBufferToRenderThread(vbBuffer);
		}
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
			var _vb:Float32Array = vbBuffer._float32Data;
			var ix:int = 0;
			for (var i:int = 0; i < _verticesNum; i++)
			{
				ix++;	_vb[ix++] = value + vertices[i * 2 + 1];	ix++;	ix++;	ix++;	ix++;
			}
			LayaGL.syncBufferToRenderThread(vbBuffer);
		}
		public function get vertices():Float32Array
		{
			return _vertices;
		}
		
		public function set vertices(value:Float32Array):void
		{
			_vertices = value;
			var _vb:Float32Array = vbBuffer._float32Data;
			var ix:int = 0;
			for (var i:int = 0; i < _verticesNum; i++)
			{
				_vb[ix++] = _x + value[i * 2];	_vb[ix++] = _y + value[i * 2 + 1];	ix++;	ix++;	ix++;	ix++;
			}
			LayaGL.syncBufferToRenderThread(vbBuffer);
		}
		public function get uvs():Float32Array
		{
			return _uvs;
		}
		
		public function set uvs(value:Float32Array):void
		{
			_uvs = value;
            var _vb:Float32Array = vbBuffer._float32Data;
			var ix:int = 0;
			for (var i:int = 0; i < _verticesNum; i++)
			{
				ix++;	ix++;	_vb[ix++] = value[i * 2]; _vb[ix++] = value[i * 2 + 1];	ix++;	ix++;
			}
			LayaGL.syncBufferToRenderThread(vbBuffer);
		}
		public function get indices():Uint16Array
		{
			return _indices;
		}
		
		public function set indices(value:Uint16Array):void
		{
			_indices = value;
			var _ib:Int16Array = ibBuffer._int16Data;
			var idxpos:int = 0;
			for (var ii:int = 0; ii < _ibNum; ii++) 
			{
				_ib[idxpos++] = value[ii];
			}
			LayaGL.syncBufferToRenderThread(ibBuffer);
		}
		public function get matrix():Matrix
		{
			return _matrix;
		}
		
		public function set matrix(value:Matrix):void
		{
			_matrix = value;
			var _fb:Float32Array = _paramData._float32Data;
			_fb[_PARAM_MATRIX_POS_] = value.a;
			_fb[_PARAM_MATRIX_POS_+1] = value.b;
			_fb[_PARAM_MATRIX_POS_+2] = value.c;
			_fb[_PARAM_MATRIX_POS_+3] = value.d;
			_fb[_PARAM_MATRIX_POS_+4] = value.tx;
			_fb[_PARAM_MATRIX_POS_+5] = value.ty;
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
		public function get color():String
		{
			return _color;
		}
		
		public function set color(value:String):void
		{
			_color = value;
		}
		public function get blendMode():String
		{
			return _blendMode;
		}
		
		public function set blendMode(value:String):void
		{
			_blendMode = value;
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