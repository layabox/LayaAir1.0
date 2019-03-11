package laya.layagl.cmdNative {
	
	import laya.layagl.LayaGL;
	import laya.layagl.LayaNative2D;
	import laya.utils.ColorUtils;
	import laya.utils.Pool;
	import laya.webgl.shapes.BasePoly;
	
	/**
	 * ...
	 * @author ww
	 */
	public class DrawRectCmdNative{
		public static const ID:String = "DrawRect";
		public static var _DRAW_RECT_CMD_ENCODER_:* = null;
		public static var _DRAW_RECT_LINE_CMD_ENCODER_:* = null;
		public static var _PARAM_RECT_NUM_POS_:int = 0;
		public static var _PARAM_VB_SIZE_POS_:int = 1;
		public static var _PARAM_VB_POS_:int = 2;
		public static var _PARAM_LINE_VB_SIZE_POS_:int = 26;
		public static var _PARAM_LINE_VB_POS_:int = 27;
		public static var _PARAM_LINE_IB_SIZE_POS_:int = 57;
		public static var _PARAM_LINE_IB_POS_:int = 58;
		public static var _PARAM_LINE_VB_OFFSET_POS_:int = 70;
		public static var _PARAM_LINE_IB_OFFSET_POS_:int = 71;
		public static var _PARAM_LINE_IBELEMENT_OFFSET_POS_:int = 72;
		private var _graphicsCmdEncoder:*;
		private var _index:int;
		private var _paramData:* = null;
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		private var _fillColor:*;
		private var _lineColor:*;
		private var _lineWidth:Number;
		private var _linePoints:Array = new Array();
		private var _line_ibArray:Array = new Array();
		private var _line_vbArray:Array = new Array();
		private var _line_vertNum:int = 0;
		
		private var _cmdCurrentPos:int;
		
		public static function create(x:Number, y:Number, width:Number, height:Number, fillColor:*, lineColor:*, lineWidth:Number):DrawRectCmdNative{
			var cmd:DrawRectCmdNative = Pool.getItemByClass("DrawRectCmd", DrawRectCmdNative);
			cmd._graphicsCmdEncoder = __JS__("this._commandEncoder;");
			
			if (!_DRAW_RECT_LINE_CMD_ENCODER_)
			{
				_DRAW_RECT_LINE_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(300, 32, true);
				_DRAW_RECT_LINE_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				// Draw Rectangle
				_DRAW_RECT_LINE_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);//programID
				_DRAW_RECT_LINE_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);//VAO ID
				_DRAW_RECT_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_RECT_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_RECT_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_RECT_LINE_CMD_ENCODER_.setRectMeshByParamData(_PARAM_RECT_NUM_POS_ * 4, _PARAM_VB_POS_ * 4, _PARAM_VB_SIZE_POS_ * 4 );
				_DRAW_RECT_LINE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_RECT_LINE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				// Draw Line
				_DRAW_RECT_LINE_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);//programID
				_DRAW_RECT_LINE_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);//VAO ID
				_DRAW_RECT_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name					
				_DRAW_RECT_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_RECT_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_RECT_LINE_CMD_ENCODER_.setMeshByParamData(_PARAM_LINE_VB_POS_ * 4, _PARAM_LINE_VB_OFFSET_POS_ * 4, _PARAM_LINE_VB_SIZE_POS_ * 4, _PARAM_LINE_IB_POS_ * 4, _PARAM_LINE_IB_OFFSET_POS_ * 4, _PARAM_LINE_IB_SIZE_POS_ * 4, _PARAM_LINE_IBELEMENT_OFFSET_POS_ * 4 );
				_DRAW_RECT_LINE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_RECT_LINE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);				
				LayaGL.syncBufferToRenderThread( _DRAW_RECT_LINE_CMD_ENCODER_ );
			}
			if (!_DRAW_RECT_CMD_ENCODER_)
			{
				_DRAW_RECT_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(152, 32, true);
				_DRAW_RECT_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				_DRAW_RECT_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);//programID
				_DRAW_RECT_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);//VAO ID
				_DRAW_RECT_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_RECT_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_RECT_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_RECT_CMD_ENCODER_.setRectMeshByParamData(_PARAM_RECT_NUM_POS_*4, _PARAM_VB_POS_ * 4, _PARAM_VB_SIZE_POS_ * 4 );
				_DRAW_RECT_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_RECT_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				LayaGL.syncBufferToRenderThread( _DRAW_RECT_CMD_ENCODER_ );
			}
			if (!cmd._paramData)
			{
				cmd._paramData = __JS__("new ParamData(73*4, true)");
			}
			//给参数赋值
			{
				cmd._x = x;
				cmd._y = y;
				cmd._width = width;
				cmd._height = height;
				cmd._fillColor = fillColor;
				cmd._lineColor = lineColor;
				cmd._lineWidth = lineWidth;
				
				var c1:ColorUtils = ColorUtils.create(fillColor);
				var nFillColor:uint = c1.numColor;			
				var _fb:Float32Array = cmd._paramData._float32Data;
				var _i32b:Int32Array = cmd._paramData._int32Data;
				_i32b[_PARAM_RECT_NUM_POS_] = 1;
				_i32b[_PARAM_VB_SIZE_POS_] = 24 * 4;
				var ix:int = _PARAM_VB_POS_;
				_fb[ix++] = x; 			_fb[ix++] = y;    		_fb[ix++] = 0; _fb[ix++] = 0;		_i32b[ix++] = nFillColor; _fb[ix++] = 0xffffffff;
				_fb[ix++] = x + width; 	_fb[ix++] = y; 		 	_fb[ix++] = 0; _fb[ix++] = 0;		_i32b[ix++] = nFillColor; _fb[ix++] = 0xffffffff;
				_fb[ix++] = x + width; 	_fb[ix++] = y + height; _fb[ix++] = 0; _fb[ix++] = 0;		_i32b[ix++] = nFillColor; _fb[ix++] = 0xffffffff;
				_fb[ix++] = x;			_fb[ix++] = y + height;	_fb[ix++] = 0; _fb[ix++] = 0;		_i32b[ix++] = nFillColor; _fb[ix++] = 0xffffffff;
				
				cmd._linePoints.push(x);			cmd._linePoints.push(y);
				cmd._linePoints.push(x + width);	cmd._linePoints.push(y);
				cmd._linePoints.push(x + width);	cmd._linePoints.push(y + height);
				cmd._linePoints.push(x);			cmd._linePoints.push(y + height);
				cmd._linePoints.push(x);			cmd._linePoints.push(y - lineWidth/ 2)
				if (lineColor)
				{
					BasePoly.createLine2(cmd._linePoints, cmd._line_ibArray, lineWidth, 0, cmd._line_vbArray, false);	
					cmd._line_vertNum = cmd._linePoints.length;					
					// Set lines' vb					
					_i32b[_PARAM_LINE_VB_SIZE_POS_] = 30 * 4;
					var c2:ColorUtils = ColorUtils.create(lineColor);
					var nLineColor:uint = c2.numColor;
					ix = _PARAM_LINE_VB_POS_;
					for (var i:int = 0; i < cmd._line_vertNum; i++)
					{
						_fb[ix++] = cmd._line_vbArray[i * 2]; 	_fb[ix++] = cmd._line_vbArray[i * 2 + 1]; 	_i32b[ix++] = nLineColor;
					}
					// Set lines' ib
					_i32b[_PARAM_LINE_IB_SIZE_POS_] = cmd._line_ibArray.length * 2;
					var _i16b:Int16Array = cmd._paramData._int16Data;
					ix = _PARAM_LINE_IB_POS_*2;
					for (var ii:int = 0; ii < cmd._line_ibArray.length; ii++) 
					{
						_i16b[ix++] = cmd._line_ibArray[ii];
					}
				}
				// Set a default value for line's ib and vb
				else
				{
					cmd._lineWidth = 1;
					var temp_lineColor:String = "#ffffff";
					BasePoly.createLine2(cmd._linePoints, cmd._line_ibArray, cmd._lineWidth, 0, cmd._line_vbArray, false);	
					cmd._line_vertNum = cmd._linePoints.length;					
					// Set lines' vb					
					_i32b[_PARAM_LINE_VB_SIZE_POS_] = 30 * 4;
					c2 = ColorUtils.create(temp_lineColor);
					nLineColor = c2.numColor;
					ix = _PARAM_LINE_VB_POS_;
					for (i = 0; i < cmd._line_vertNum; i++)
					{
						_fb[ix++] = cmd._line_vbArray[i * 2]; 	_fb[ix++] = cmd._line_vbArray[i * 2 + 1]; 	_i32b[ix++] = nLineColor;
					}
					// Set lines' ib
					_i32b[_PARAM_LINE_IB_SIZE_POS_] = cmd._line_ibArray.length * 2;
					_i16b = cmd._paramData._int16Data;
					ix = _PARAM_LINE_IB_POS_*2;
					for (ii = 0; ii < cmd._line_ibArray.length; ii++) 
					{
						_i16b[ix++] = cmd._line_ibArray[ii];
					}
				}
				_i32b[_PARAM_LINE_VB_OFFSET_POS_] = 0;
				_i32b[_PARAM_LINE_IB_OFFSET_POS_] = 0;
				_i32b[_PARAM_LINE_IBELEMENT_OFFSET_POS_] = 0;
				LayaGL.syncBufferToRenderThread( cmd._paramData );
			}			                      
			if (lineColor)
			{
				cmd._cmdCurrentPos = cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_RECT_LINE_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);
			}
			else
			{
				cmd._cmdCurrentPos = cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_RECT_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);
			}
			LayaGL.syncBufferToRenderThread( cmd._graphicsCmdEncoder );
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			_linePoints.length = 0;
			_line_ibArray.length = 0;
			_line_vbArray.length = 0;
			_graphicsCmdEncoder = null;
			Pool.recover("DrawRectCmd", this);
		}
		
		public function get cmdID():String{
			return ID;
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
			if (lineColor)
			{
				_line_ibArray.length = 0;
				_line_vbArray.length = 0;
				_linePoints[0] = _x;			_linePoints[2] = _x + _width;
				_linePoints[4] = _x + _width;   _linePoints[6] = _x;			_linePoints[8] = _x;
				BasePoly.createLine2(_linePoints, _line_ibArray, _lineWidth, 0, _line_vbArray, false);						
				// Set lines' vb					
				var ix:int = _PARAM_LINE_VB_POS_;
				for (var i:int = 0; i < _line_vertNum; i++)
				{
					_fb[ix++] = _line_vbArray[i * 2]; 	_fb[ix++] = _line_vbArray[i * 2 + 1]; 	ix++;
				}
			}
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
			if (lineColor)
			{
				_line_ibArray.length = 0;
				_line_vbArray.length = 0;
				_linePoints[1] = _y;			_linePoints[3] = _y;
				_linePoints[5] = _y + _height;  _linePoints[7] = _y + _height;			_linePoints[9] = _y - _lineWidth / 2;
				BasePoly.createLine2(_linePoints, _line_ibArray, _lineWidth, 0, _line_vbArray, false);						
				// Set lines' vb					
				var ix:int = _PARAM_LINE_VB_POS_;
				for (var i:int = 0; i < _line_vertNum; i++)
				{
					_fb[ix++] = _line_vbArray[i * 2]; 	_fb[ix++] = _line_vbArray[i * 2 + 1]; 	ix++;
				}
			}
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
			_fb[_PARAM_VB_POS_+6] = _x + _width;
			_fb[_PARAM_VB_POS_+12] = _x + _width;
			if (lineColor)
			{
				_line_ibArray.length = 0;
				_line_vbArray.length = 0;
				_linePoints[2] = _x + _width;
				_linePoints[4] = _x + _width;
				BasePoly.createLine2(_linePoints, _line_ibArray, _lineWidth, 0, _line_vbArray, false);		
				_line_vertNum = _linePoints.length;					
				// Set lines' vb					
				var ix:int = _PARAM_LINE_VB_POS_;
				for (var i:int = 0; i < _line_vertNum; i++)
				{
					_fb[ix++] = _line_vbArray[i * 2]; 	_fb[ix++] = _line_vbArray[i * 2 + 1]; 	ix++;
				}
			}
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
			_fb[_PARAM_VB_POS_+13] = _y + _height;	
			_fb[_PARAM_VB_POS_ +19] = _y + _height; 
			if (lineColor)
			{
				_line_ibArray.length = 0;
				_line_vbArray.length = 0;
				_linePoints[5] = _y + _height;
				_linePoints[7] = _y + _height;
				BasePoly.createLine2(_linePoints, _line_ibArray, _lineWidth, 0, _line_vbArray, false);		
				// Set lines' vb					
				var ix:int = _PARAM_LINE_VB_POS_;
				for (var i:int = 0; i < _line_vertNum; i++)
				{
					_fb[ix++] = _line_vbArray[i * 2]; 	_fb[ix++] = _line_vbArray[i * 2 + 1]; 	ix++;
				}
			}
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		
		public function get fillColor():*
		{
			return _fillColor;
		}
		
		public function set fillColor(value:*): void
		{
            _fillColor = value;
			if (typeof value === 'string')
			{
				var c1:ColorUtils = ColorUtils.create(_fillColor);
				var nFillColor:uint = c1.numColor;
				var _i32b:Int32Array = _paramData._int32Data;
				_i32b[_PARAM_VB_POS_ +4] = nFillColor;
				_i32b[_PARAM_VB_POS_ +10] = nFillColor;
				_i32b[_PARAM_VB_POS_ +16] = nFillColor;
				_i32b[_PARAM_VB_POS_ +22] = nFillColor;
			}
			else
			{
				_i32b = _paramData._int32Data;
				_i32b[_PARAM_VB_POS_ +4] = value;
				_i32b[_PARAM_VB_POS_ +10] = value;
				_i32b[_PARAM_VB_POS_ +16] = value;
				_i32b[_PARAM_VB_POS_ +22] = value;
			}
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		
		public function get lineColor():*
		{
			return _lineColor;
		}
		
		public function set lineColor(value:*): void
		{
			_graphicsCmdEncoder._idata[_cmdCurrentPos + 1] = _DRAW_RECT_LINE_CMD_ENCODER_.getPtrID();
			LayaGL.syncBufferToRenderThread(_graphicsCmdEncoder);

			_lineColor = value;
			var _i32b:Int32Array = _paramData._int32Data;
			var c2:ColorUtils = ColorUtils.create(value);
			var nLineColor:uint = c2.numColor;
			var ix:int = _PARAM_LINE_VB_POS_;
			for (var i:int = 0; i < _line_vertNum; i++)
			{
				ix++;	ix++;	_i32b[ix++] = nLineColor;
			}
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		
		public function get lineWidth():Number
		{
			return _lineWidth;
		}
		
		public function set lineWidth(value:Number): void
		{
			if (lineColor)
			{
				_graphicsCmdEncoder._idata[_cmdCurrentPos + 1] = _DRAW_RECT_LINE_CMD_ENCODER_.getPtrID();
				LayaGL.syncBufferToRenderThread(_graphicsCmdEncoder);
			}
			_lineWidth = value;
			_line_ibArray.length = 0;
			_line_vbArray.length = 0;
			_linePoints[9] = _y - _lineWidth / 2;
			BasePoly.createLine2(_linePoints, _line_ibArray, _lineWidth, 0, _line_vbArray, false);	
			_line_vertNum = _linePoints.length;					
			// Set lines' vb
			var _fb:Float32Array = _paramData._float32Data;
			var ix:int = _PARAM_LINE_VB_POS_;
			for (var i:int = 0; i < _line_vertNum; i++)
			{
				_fb[ix++] = _line_vbArray[i * 2]; 	_fb[ix++] = _line_vbArray[i * 2 + 1]; 	ix++;
			}
			LayaGL.syncBufferToRenderThread( _paramData );
		}
	}
}