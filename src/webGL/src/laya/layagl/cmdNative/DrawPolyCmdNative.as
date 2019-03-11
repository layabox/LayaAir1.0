package laya.layagl.cmdNative {
	import laya.layagl.LayaGL;
	import laya.layagl.LayaNative2D;
	import laya.utils.ColorUtils;
	import laya.utils.Pool;
	import laya.webgl.shapes.BasePoly;
	import laya.webgl.shapes.Earcut;
	/**
	 * ...
	 * @author ww
	 */
	public class DrawPolyCmdNative  {
		public static const ID:String = "DrawPoly";
		public static var _DRAW_POLY_CMD_ENCODER_:* = null;
		public static var _DRAW_POLY_LINES_CMD_ENCODER_:* = null;
		public static var _PARAM_VB_POS_:int = 2;
		public static var _PARAM_IB_POS_:int = 3;
		public static var _PARAM_VB_SIZE_POS_:int = 4;
		public static var _PARAM_IB_SIZE_POS_:int = 5;
		
		public static var _PARAM_LINE_VB_POS_:int = 6;
		public static var _PARAM_LINE_IB_POS_:int = 7;
		public static var _PARAM_LINE_VB_SIZE_POS_:int = 8;
		public static var _PARAM_LINE_IB_SIZE_POS_:int = 9;
		
		public static var _PARAM_ISCONVEXT_POS_:int = 10;
		
		public static var _PARAM_VB_OFFSET_POS_:int = 11;
		public static var _PARAM_IB_OFFSET_POS_:int = 12;
		public static var _PARAM_LINE_VB_OFFSET_POS_:int = 13;
		public static var _PARAM_LINE_IB_OFFSET_POS_:int = 14;
		public static var _PARAM_INDEX_ELEMENT_OFFSET_POS_:int = 15;
		public static var _PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_:int = 16;
		
		private var _graphicsCmdEncoder:*;
		private var _graphicsCmdEncoder_lines:*;
		private var _paramData:* = null;
		private var _x:Number;
		private var _y:Number;
		private var _points:Array;
		private var _fillColor:*;
		private var _lineColor:*;
		private var _lineWidth:Number;
		private var _isConvexPolygon:Boolean;
		private var _vid:int;
		private var _vertNum:int;
		private var _line_vertNum:int;
		private var _linePoints:Array = new Array();
		private var _line_vbArray:Array = new Array();
		private var _line_ibArray:Array = new Array();
		
		private var ibBuffer:*;
		private var vbBuffer:*;
		private var line_ibBuffer:*;
		private var line_vbBuffer:*;
		private var _ibSize:int = 0;
		private var _vbSize:int = 0;
		private var _line_ibSize:int = 0;
		private var _line_vbSize:int = 0;
		
		private var _cmdCurrentPos:int;
			
		public static function create(x:Number,y:Number,points:Array,fillColor:*,lineColor:*,lineWidth:Number,isConvexPolygon:Boolean,vid:int):DrawPolyCmdNative {
			var cmd:DrawPolyCmdNative = Pool.getItemByClass("DrawPolyCmd", DrawPolyCmdNative);
			cmd._graphicsCmdEncoder = __JS__("this._commandEncoder;");					
			
			if (!_DRAW_POLY_CMD_ENCODER_)
			{
				_DRAW_POLY_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(168, 32, true);
				_DRAW_POLY_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				_DRAW_POLY_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);//programID
				_DRAW_POLY_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);//VAO ID
				_DRAW_POLY_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_POLY_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_POLY_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_POLY_CMD_ENCODER_.setMeshExByParamData(_PARAM_VB_POS_ * 4, _PARAM_VB_OFFSET_POS_ * 4, _PARAM_VB_SIZE_POS_ * 4, _PARAM_IB_POS_ * 4, _PARAM_IB_OFFSET_POS_ * 4, _PARAM_IB_SIZE_POS_ * 4, _PARAM_INDEX_ELEMENT_OFFSET_POS_ * 4);
				_DRAW_POLY_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_POLY_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				LayaGL.syncBufferToRenderThread( _DRAW_POLY_CMD_ENCODER_ );
			}
			if (!_DRAW_POLY_LINES_CMD_ENCODER_)
			{
				_DRAW_POLY_LINES_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(244, 32, true);
				_DRAW_POLY_LINES_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				_DRAW_POLY_LINES_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);//programID
				_DRAW_POLY_LINES_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);//VAO ID
				_DRAW_POLY_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_POLY_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_POLY_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_POLY_LINES_CMD_ENCODER_.setMeshExByParamData(_PARAM_VB_POS_ * 4, _PARAM_VB_OFFSET_POS_ * 4, _PARAM_VB_SIZE_POS_ * 4, _PARAM_IB_POS_ * 4, _PARAM_IB_OFFSET_POS_ * 4, _PARAM_IB_SIZE_POS_ * 4, _PARAM_INDEX_ELEMENT_OFFSET_POS_ * 4);
				_DRAW_POLY_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_POLY_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				_DRAW_POLY_LINES_CMD_ENCODER_.setMeshExByParamData(_PARAM_LINE_VB_POS_ * 4, _PARAM_LINE_VB_OFFSET_POS_ * 4, _PARAM_LINE_VB_SIZE_POS_ * 4, _PARAM_LINE_IB_POS_ * 4, _PARAM_LINE_VB_OFFSET_POS_ * 4, _PARAM_LINE_IB_SIZE_POS_ * 4, _PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_ * 4);
				_DRAW_POLY_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_POLY_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				LayaGL.syncBufferToRenderThread( _DRAW_POLY_LINES_CMD_ENCODER_ );
			}
			if (!cmd._paramData)
			{
				cmd._paramData = __JS__("new ParamData(17 * 4, true)");
			}
			
			//给参数赋值
			{
				cmd._x = x;
				cmd._y = y;
				cmd._points = points;
				cmd._fillColor = fillColor;
				cmd._lineColor = lineColor;
				cmd._lineWidth = lineWidth;
				cmd._isConvexPolygon = isConvexPolygon;
			
				cmd._vertNum = points.length / 2;
				var vertNumCopy:int = cmd._vertNum;
				// Create ib				
				var cur:Array = Earcut.earcut(points, null, 2);	//返回索引
				if (cur.length > 0) 
				{
					// Set polygon's ib
					if (!cmd.ibBuffer || cmd.ibBuffer.getByteLength() < cur.length*2)
					{
						cmd.ibBuffer = __JS__("new ParamData(cur.length*2,true,true)");							
					}						
					cmd._ibSize = cur.length * 2;
					var _ib:Int16Array = cmd.ibBuffer._int16Data;
					var idxpos:int = 0;
					for (var ii:int = 0; ii < cur.length; ii++) 
					{
						_ib[idxpos++] = cur[ii];
					}						
				}
				
				// Set polygon's vb
				var c1:ColorUtils = ColorUtils.create(fillColor);
				var nColor:uint = c1.numColor;				
				if (!cmd.vbBuffer || cmd.vbBuffer.getByteLength() < cmd._vertNum * 3 * 4)
				{
					cmd.vbBuffer = __JS__("new ParamData(vertNumCopy * 3 * 4,true)");					
				}
				cmd._vbSize = cmd._vertNum * 3 * 4;
				var _vb:Float32Array = cmd.vbBuffer._float32Data;
				var _vb_i32b:Int32Array = cmd.vbBuffer._int32Data;
				var ix:int = 0;
				for (var i:int = 0; i < cmd._vertNum; i++)
				{
					_vb[ix++] = points[i * 2] + x; 	_vb[ix++] = points[i * 2 + 1] + y; 	_vb_i32b[ix++] = nColor;
				}
				
				// Set lines' vb and ib
				for (i = 0; i < points.length; i++)
				{
					cmd._linePoints.push(points[i]);
				}
				cmd._linePoints.push(points[0]);
				cmd._linePoints.push(points[1]);
				if (lineColor)
				{
					BasePoly.createLine2(cmd._linePoints, cmd._line_ibArray, lineWidth, 0, cmd._line_vbArray, false);	
					cmd._line_vertNum = cmd._linePoints.length;
					var lineVertNumCopy:int = cmd._line_vertNum;				
					
					// Set lines' ib
					if (!cmd.line_ibBuffer || cmd.line_ibBuffer.getByteLength() < (cmd._line_vertNum-2)*3*2)
					{
						cmd.line_ibBuffer = __JS__("new ParamData((lineVertNumCopy-2)*3*2,true,true)");								
					}							
					cmd._line_ibSize = (cmd._line_vertNum - 2) * 3 * 2;
					var _line_ib:Int16Array = cmd.line_ibBuffer._int16Data;
					idxpos = 0;
					for (ii = 0; ii < (cmd._line_vertNum-2)*3; ii++) 
					{
						_line_ib[idxpos++] = cmd._line_ibArray[ii];
					}
					// Set lines' vb					
					if (!cmd.line_vbBuffer || cmd.line_vbBuffer.getByteLength() < cmd._line_vertNum*3 * 4) 
					{
						cmd.line_vbBuffer = __JS__("new ParamData(lineVertNumCopy*3 * 4,true)"); 					
					}
					cmd._line_vbSize = cmd._line_vertNum * 3 * 4;					
					var c2:ColorUtils = ColorUtils.create(lineColor);
					var nColor2:uint = c2.numColor;
					var _line_vb:Float32Array = cmd.line_vbBuffer._float32Data;
					var _line_vb_i32b:Int32Array = cmd.line_vbBuffer._int32Data;
					ix = 0;
					for (i = 0; i < cmd._line_vertNum; i++)
					{
						_line_vb[ix++] = cmd._line_vbArray[i * 2] + x; 	_line_vb[ix++] = cmd._line_vbArray[i * 2 + 1] + y; 	_line_vb_i32b[ix++] = nColor2;
					}
				}
				else
				{
					cmd._lineWidth = 1;
					var temp_lineColor:String = "#ffffff";
					BasePoly.createLine2(cmd._linePoints, cmd._line_ibArray, cmd._lineWidth, 0, cmd._line_vbArray, false);	
					cmd._line_vertNum = cmd._linePoints.length;
					lineVertNumCopy = cmd._line_vertNum;				
					
					// Set lines' ib
					if (!cmd.line_ibBuffer || cmd.line_ibBuffer.getByteLength() < (cmd._line_vertNum-2)*3*2)
					{
						cmd.line_ibBuffer = __JS__("new ParamData((lineVertNumCopy-2)*3*2,true,true)");								
					}							
					cmd._line_ibSize = (cmd._line_vertNum - 2) * 3 * 2;
					_line_ib = cmd.line_ibBuffer._int16Data;
					idxpos = 0;
					for (ii = 0; ii < (cmd._line_vertNum-2)*3; ii++) 
					{
						_line_ib[idxpos++] = cmd._line_ibArray[ii];
					}
					// Set lines' vb					
					if (!cmd.line_vbBuffer || cmd.line_vbBuffer.getByteLength() < cmd._line_vertNum*3 * 4) 
					{
						cmd.line_vbBuffer = __JS__("new ParamData(lineVertNumCopy*3 * 4,true)"); 					
					}
					cmd._line_vbSize = cmd._line_vertNum * 3 * 4;					
					c2 = ColorUtils.create(temp_lineColor);
					nColor2 = c2.numColor;
					_line_vb = cmd.line_vbBuffer._float32Data;
					_line_vb_i32b = cmd.line_vbBuffer._int32Data;
					ix = 0;
					for (i = 0; i < cmd._line_vertNum; i++)
					{
						_line_vb[ix++] = cmd._line_vbArray[i * 2] + x; 	_line_vb[ix++] = cmd._line_vbArray[i * 2 + 1] + y; 	_line_vb_i32b[ix++] = nColor2;
					}
				}
			}
			
			// Save to _paramData
			var _fb:Float32Array = cmd._paramData._float32Data;
			var _i32b:Int32Array = cmd._paramData._int32Data;
			_i32b[0] = 1;
			_i32b[1] = 8 * 4;
			if (cmd.ibBuffer == null) {
				return null;
			}
			_i32b[_PARAM_VB_POS_] = cmd.vbBuffer.getPtrID();
			_i32b[_PARAM_IB_POS_] = cmd.ibBuffer.getPtrID();				
			_i32b[_PARAM_VB_SIZE_POS_] = cmd._vbSize;
			_i32b[_PARAM_IB_SIZE_POS_] = cmd._ibSize;
			_i32b[_PARAM_VB_OFFSET_POS_] = 0;
			_i32b[_PARAM_IB_OFFSET_POS_] = 0;
			_i32b[_PARAM_INDEX_ELEMENT_OFFSET_POS_] = 0;
			_fb[_PARAM_ISCONVEXT_POS_] = isConvexPolygon;
			LayaGL.syncBufferToRenderThread(cmd.vbBuffer);
			LayaGL.syncBufferToRenderThread(cmd.ibBuffer);
			
			_i32b[_PARAM_LINE_VB_POS_] = cmd.line_vbBuffer.getPtrID();
			_i32b[_PARAM_LINE_IB_POS_] = cmd.line_ibBuffer.getPtrID();				
			_i32b[_PARAM_LINE_VB_SIZE_POS_] = cmd._line_vbSize;
			_i32b[_PARAM_LINE_IB_SIZE_POS_] = cmd._line_ibSize;
			_i32b[_PARAM_LINE_VB_OFFSET_POS_] = 0;
			_i32b[_PARAM_LINE_IB_OFFSET_POS_] = 0;
			_i32b[_PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_] = 0;
			LayaGL.syncBufferToRenderThread(cmd.line_vbBuffer);
			LayaGL.syncBufferToRenderThread(cmd.line_ibBuffer);
			
			LayaGL.syncBufferToRenderThread( cmd._paramData );
			if (lineColor)
			{
				cmd._cmdCurrentPos = cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_POLY_LINES_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);	
			}
			else
			{
				cmd._cmdCurrentPos = cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_POLY_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);	
			}
			LayaGL.syncBufferToRenderThread( cmd._graphicsCmdEncoder );
			
			return cmd;
		}
			
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			_points = null;
			_fillColor = null;
			_lineColor = null;
			_linePoints.length = 0;
			_line_vbArray.length = 0;
			_line_ibArray.length = 0;
			Pool.recover("DrawPolyCmd", this);
		}		
		
		public function get cmdID():String
		{
			return ID;
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
			for (var i:int = 0; i < _vertNum; i++)
			{
				_vb[ix++] = _points[i * 2] + _x; 	ix++;	ix++;				
			}
			if (_lineColor)
			{
				var _line_vb:Float32Array = line_vbBuffer._float32Data;
				ix = 0;
				for (i = 0; i < _line_vertNum; i++)
				{
					_line_vb[ix++] = _line_vbArray[i * 2] + _x;		ix++;	ix++;
				}
				LayaGL.syncBufferToRenderThread( line_vbBuffer );
			}
			LayaGL.syncBufferToRenderThread( vbBuffer );
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
			for (var i:int = 0; i < _vertNum; i++)
			{
				ix++;	_vb[ix++] = _points[i * 2 + 1] + _y;	ix++;
			}
			if (_lineColor)
			{
				var _line_vb:Float32Array = line_vbBuffer._float32Data;
				ix = 0;
				for (i = 0; i < _line_vertNum; i++)
				{
					ix++;	_line_vb[ix++] = _line_vbArray[i * 2 + 1] + _y;		ix++;
				}
				LayaGL.syncBufferToRenderThread( line_vbBuffer );
			}
			LayaGL.syncBufferToRenderThread( vbBuffer );
		}
		
		public function get points():Array
		{
			return _points;
		}
		
		public function set points(value:Array):void	
		{
			_points = value;
			//给参数赋值
			{
				_vertNum = value.length / 2;
				var vertNumCopy:int = _vertNum;
				var cur:Array = Earcut.earcut(value, null, 2);	//返回索引
				if (cur.length > 0) 
				{
					// Set polygon's ib
					if (!ibBuffer || ibBuffer.getByteLength() < cur.length*2)
					{
						ibBuffer = __JS__("new ParamData(cur.length*2,true,true)");							
					}						
					_ibSize = cur.length * 2;
					var _ib:Int16Array = ibBuffer._int16Data;
					var idxpos:int = 0;
					for (var ii:int = 0; ii < cur.length; ii++) 
					{
						_ib[idxpos++] = cur[ii];
					}						
				}
				
				// Set polygon's vb		
				if (!vbBuffer || vbBuffer.getByteLength() < _vertNum * 3 * 4)
				{
					vbBuffer = __JS__("new ParamData(vertNumCopy*3 * 4,true)");					
				}
				_vbSize = _vertNum * 3 * 4;
				var c1:ColorUtils = ColorUtils.create(_fillColor);
				var nColor:uint = c1.numColor;
				var _vb:Float32Array = vbBuffer._float32Data;
				var _vb_i32b:Int32Array = vbBuffer._int32Data;
				var ix:int = 0;
				for (var i:int = 0; i < _vertNum; i++)
				{
					_vb[ix++] = _points[i * 2] + _x; 	_vb[ix++] = _points[i * 2 + 1] + _y; 	_vb_i32b[ix++] = nColor;
				}
			}
			// Save to _paramData
			var _i32b:Int32Array = _paramData._int32Data;
			_i32b[_PARAM_VB_POS_] = vbBuffer.getPtrID();
			_i32b[_PARAM_IB_POS_] = ibBuffer.getPtrID();
			_i32b[_PARAM_VB_SIZE_POS_] = _vbSize;
			_i32b[_PARAM_IB_SIZE_POS_] = _ibSize;
			LayaGL.syncBufferToRenderThread(vbBuffer);
			LayaGL.syncBufferToRenderThread(ibBuffer);
			LayaGL.syncBufferToRenderThread( _paramData );
			
			if (lineColor)
			{
				//给参数赋值
				{
					var lineVertNumCopy:int = 0;				
					_linePoints.length = 0;
					_line_ibArray.length = 0;
					_line_vbArray.length = 0;
					for (i = 0; i < value.length; i++)
					{
						_linePoints.push(value[i]);
					}
					_linePoints.push(value[0]);
					_linePoints.push(value[1]);					
					BasePoly.createLine2(_linePoints, _line_ibArray, _lineWidth, 0, _line_vbArray, false);	
					_line_vertNum = _linePoints.length;
					lineVertNumCopy = _line_vertNum;				
					
					// Set lines' ib
					if (!line_ibBuffer || line_ibBuffer.getByteLength() < (_line_vertNum-2)*3*2)
					{
						line_ibBuffer = __JS__("new ParamData((lineVertNumCopy-2)*3*2,true,true)");								
					}							
					_line_ibSize = (_line_vertNum - 2) * 3 * 2;
					var _line_ib:Int16Array = line_ibBuffer._int16Data;
					idxpos = 0;
					for (ii = 0; ii < (_line_vertNum-2)*3; ii++) 
					{
						_line_ib[idxpos++] = _line_ibArray[ii];
					}
					// Set lines' vb					
					if (!line_vbBuffer || line_vbBuffer.getByteLength() < _line_vertNum*3 * 4) 
					{
						line_vbBuffer = __JS__("new ParamData(lineVertNumCopy*3 * 4,true)"); 					
					}
					_line_vbSize = _line_vertNum * 3 * 4;
					var c2:ColorUtils = ColorUtils.create(_lineColor);
					var nColor2:uint = c2.numColor;
					var _line_vb:Float32Array = line_vbBuffer._float32Data;
					var _line_vb_i32b:Int32Array = line_vbBuffer._int32Data;
					ix = 0;
					for (i = 0; i < _line_vertNum; i++)
					{
						_line_vb[ix++] = _line_vbArray[i * 2] + _x; 	
						_line_vb[ix++] = _line_vbArray[i * 2 + 1] + _y; 	
						_line_vb_i32b[ix++] = nColor2;
					}
				}
				// Save to _paramData
				_i32b = _paramData._int32Data;
				_i32b[_PARAM_LINE_VB_POS_] = line_vbBuffer.getPtrID();
				_i32b[_PARAM_LINE_IB_POS_] = line_ibBuffer.getPtrID();
				_i32b[_PARAM_LINE_VB_SIZE_POS_] = _line_vbSize;
				_i32b[_PARAM_LINE_IB_SIZE_POS_] = _line_ibSize;
				LayaGL.syncBufferToRenderThread(line_vbBuffer);
				LayaGL.syncBufferToRenderThread(line_ibBuffer);
			}
		}
		
		public function get fillColor():*
		{
			return _fillColor;
		}
		
		public function set fillColor(value:*):void
		{
			_fillColor = value;
			var c1:ColorUtils = ColorUtils.create(_fillColor);
			var nColor:uint = c1.numColor;
			var _i32b:Int32Array = vbBuffer._int32Data;
			var ix:int = 0;
			for (var i:int = 0; i < _vertNum; i++)
			{
				ix++; ix++; _i32b[ix++] = nColor;
			}
			LayaGL.syncBufferToRenderThread(vbBuffer);
		}
		public function get lineColor():*
		{
			return _lineColor;
		}
		
		public function set lineColor(value:*):void
		{
			_graphicsCmdEncoder._idata[_cmdCurrentPos + 1] = _DRAW_POLY_LINES_CMD_ENCODER_.getPtrID();
			LayaGL.syncBufferToRenderThread(_graphicsCmdEncoder);
			
			_lineColor = value;
			if (_lineColor && line_vbBuffer)
			{
				var c2:ColorUtils = ColorUtils.create(_lineColor);
				var nColor2:uint = c2.numColor;
				var _line_vb_i32b:Int32Array = line_vbBuffer._int32Data;
				var ix:int = 0;
				for (var i:int = 0; i < _line_vertNum; i++)
				{
					ix++;	ix++;	_line_vb_i32b[ix++] = nColor2;
				}
				LayaGL.syncBufferToRenderThread( line_vbBuffer );
			}
		}
		public function get lineWidth():Number
		{
			return _lineWidth;
		}
		
		public function set lineWidth(value:Number):void
		{
			if (lineColor)
			{
				_graphicsCmdEncoder._idata[_cmdCurrentPos + 1] = _DRAW_POLY_LINES_CMD_ENCODER_.getPtrID();
				LayaGL.syncBufferToRenderThread(_graphicsCmdEncoder);
			}
			_lineWidth = value;
			// Set lines' vb
			_linePoints.length = 0;
			_line_ibArray.length = 0;
			_line_vbArray.length = 0;
			for (var i:int = 0; i < _points.length; i++)
			{
				_linePoints.push(_points[i]);
			}
			_linePoints.push(_points[0]);
			_linePoints.push(_points[1]);					
			BasePoly.createLine2(_linePoints, _line_ibArray, _lineWidth, 0, _line_vbArray, false);	
			var _line_vb:Float32Array = line_vbBuffer._float32Data;
			var ix:int = 0;
			for (i = 0; i < _line_vertNum; i++)
			{
				_line_vb[ix++] = _line_vbArray[i * 2] + _x; 	
				_line_vb[ix++] = _line_vbArray[i * 2 + 1] + _y; 	
				ix++;
			}
			LayaGL.syncBufferToRenderThread( line_vbBuffer );
		}
		public function get isConvexPolygon():Boolean
		{
			return _isConvexPolygon;
		}
		
		public function set isConvexPolygon(value:Boolean):void
		{
			_isConvexPolygon = value;
		}
		public function get vid():int
		{
			return _vid;
		}
		
		public function set vid(value:int):void
		{
			_vid = value;
		}
	}
}