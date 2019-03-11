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
	public class DrawCircleCmdNative {
		public static const ID:String = "DrawCircle";
		public static var _DRAW_CIRCLE_CMD_ENCODER_:* = null;
		public static var _DRAW_CIRCLE_LINES_CMD_ENCODER_:* = null;
		public static var _PARAM_VB_POS_:int = 2;
		public static var _PARAM_IB_POS_:int = 3;
		public static var _PARAM_LINE_VB_POS_:int = 4;
		public static var _PARAM_LINE_IB_POS_:int = 5;
		public static var _PARAM_LINECOLOR_POS_:int = 6;
		public static var _PARAM_LINEWIDTH_POS_:int = 7;
		public static var _PARAM_VB_SIZE_POS_:int = 8;
		public static var _PARAM_IB_SIZE_POS_:int = 9;
		public static var _PARAM_LINE_VB_SIZE_POS_:int = 10;
		public static var _PARAM_LINE_IB_SIZE_POS_:int = 11;
		public static var _PARAM_VB_OFFSET_POS_:int = 12;
		public static var _PARAM_IB_OFFSET_POS_:int = 13;
		public static var _PARAM_LINE_VB_OFFSET_POS_:int = 14;
		public static var _PARAM_LINE_IB_OFFSET_POS_:int = 15;
		public static var _PARAM_INDEX_ELEMENT_OFFSET_POS_:int = 16;
		public static var _PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_:int = 17;
		
		private var _graphicsCmdEncoder:*;
		private var _paramData:* = null;
		private var _paramID:* = null;
		private var _x:Number;
		private var _y:Number;
		private var _radius:Number;
		private var _fillColor:*;
		private var _lineColor:*;
		private var _lineWidth:Number;
		private var _points:Array = new Array();
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
		
		public static function create(x:Number,y:Number,radius:Number,fillColor:*,lineColor:*,lineWidth:Number,vid:int):DrawCircleCmdNative {
			var cmd:DrawCircleCmdNative = Pool.getItemByClass("DrawCircleCmd", DrawCircleCmdNative);
			cmd._graphicsCmdEncoder = __JS__("this._commandEncoder;");
			
			if (!_DRAW_CIRCLE_LINES_CMD_ENCODER_)
			{
				_DRAW_CIRCLE_LINES_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(244, 32, true);
				_DRAW_CIRCLE_LINES_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				_DRAW_CIRCLE_LINES_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);//programID
				_DRAW_CIRCLE_LINES_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);//VAO ID
				_DRAW_CIRCLE_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_CIRCLE_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_CIRCLE_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_CIRCLE_LINES_CMD_ENCODER_.setMeshExByParamData(_PARAM_VB_POS_ * 4, _PARAM_VB_OFFSET_POS_ * 4, _PARAM_VB_SIZE_POS_ * 4, _PARAM_IB_POS_ * 4, _PARAM_IB_OFFSET_POS_ * 4, _PARAM_IB_SIZE_POS_ * 4, _PARAM_INDEX_ELEMENT_OFFSET_POS_ * 4);
				_DRAW_CIRCLE_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_CIRCLE_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				_DRAW_CIRCLE_LINES_CMD_ENCODER_.setMeshExByParamData(_PARAM_LINE_VB_POS_ * 4, _PARAM_LINE_VB_OFFSET_POS_ * 4, _PARAM_LINE_VB_SIZE_POS_ * 4, _PARAM_LINE_IB_POS_ * 4, _PARAM_LINE_IB_OFFSET_POS_ * 4, _PARAM_LINE_IB_SIZE_POS_ * 4, _PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_ * 4);
				// Modify only validate on last mesh. So there need to modify the new mesh again.
				_DRAW_CIRCLE_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_CIRCLE_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				LayaGL.syncBufferToRenderThread( _DRAW_CIRCLE_LINES_CMD_ENCODER_ );
			}	
			
			if (!_DRAW_CIRCLE_CMD_ENCODER_)
			{
				_DRAW_CIRCLE_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(168, 32, true);
				_DRAW_CIRCLE_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				_DRAW_CIRCLE_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);//programID
				_DRAW_CIRCLE_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);//VAO ID
				_DRAW_CIRCLE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_CIRCLE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_CIRCLE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_CIRCLE_CMD_ENCODER_.setMeshExByParamData(_PARAM_VB_POS_ * 4, _PARAM_VB_OFFSET_POS_ * 4, _PARAM_VB_SIZE_POS_ * 4, _PARAM_IB_POS_ * 4, _PARAM_IB_OFFSET_POS_ * 4, _PARAM_IB_SIZE_POS_ * 4, _PARAM_INDEX_ELEMENT_OFFSET_POS_ * 4);
				_DRAW_CIRCLE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_CIRCLE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				LayaGL.syncBufferToRenderThread( _DRAW_CIRCLE_CMD_ENCODER_ );
			}
			
			if (!cmd._paramData)
			{
				cmd._paramData = __JS__("new ParamData(18 * 4, true)");
			}
			
			//给参数赋值
			{
				cmd._x = x;
				cmd._y = y;
				cmd._radius = radius;
				cmd._fillColor = fillColor;
				cmd._lineColor = lineColor;
				cmd._lineWidth = lineWidth;
			
				// Calculate the curve points
				cmd._points = cmd._arc(0, 0, radius);				
				
				cmd._vertNum = cmd._points.length / 2;
				var vertNumCopy:int = cmd._vertNum;				
				
				// Set circle's ib		
				var curvert:int = 0;
				var faceNum:int = cmd._vertNum - 2;
				if (!cmd.ibBuffer || cmd.ibBuffer.getByteLength() < faceNum * 3 * 2 )
				{
					cmd.ibBuffer = __JS__("new ParamData(faceNum*3*2,true,true)");						
				}					
				cmd._ibSize = faceNum * 3 * 2;
				var _ib:Int16Array = cmd.ibBuffer._int16Data;
				var idxpos:int = 0;
				for (var fi:int = 0; fi < faceNum; fi++) 
				{
					_ib[idxpos++] = curvert ;
					_ib[idxpos++] = fi+1 + curvert;
					_ib[idxpos++] = fi+2 + curvert;
				}				
				
				// Set circle's vb
				var c1:ColorUtils = ColorUtils.create(fillColor);
				var nColor:uint = c1.numColor;				
				if (!cmd.vbBuffer || cmd.vbBuffer.getByteLength() < cmd._vertNum * 3 * 4)
				{
					cmd.vbBuffer = __JS__("new ParamData(vertNumCopy*3 * 4,true)");					
				}
				cmd._vbSize = cmd._vertNum * 3 * 4;
				var _vb:Float32Array = cmd.vbBuffer._float32Data;
				var _vb_i32b:Int32Array = cmd.vbBuffer._int32Data;
				var ix:int = 0;
				for (var i:int = 0; i < cmd._vertNum; i++)
				{
					_vb[ix++] = cmd._points[i * 2] + x; 	_vb[ix++] = cmd._points[i * 2 + 1] + y; 	_vb_i32b[ix++] = nColor;
				}
				
				var lineVertNumCopy:int = 0;								
				for (i = 0; i < cmd._points.length; i++)
				{
					cmd._linePoints.push(cmd._points[i]);
				}
				cmd._linePoints.push(cmd._points[0]);
				cmd._linePoints.push(cmd._points[1]);
				
				// Set lines' ib and vb
				if (lineColor)
				{					
					BasePoly.createLine2(cmd._linePoints, cmd._line_ibArray, lineWidth, 0, cmd._line_vbArray, false);	
					cmd._line_vertNum = cmd._linePoints.length;
					lineVertNumCopy = cmd._line_vertNum;
					
					// Set lines' ib
					if (!cmd.line_ibBuffer || cmd.line_ibBuffer.getByteLength() < (cmd._line_vertNum-2)*3*2)
					{
						cmd.line_ibBuffer = __JS__("new ParamData((lineVertNumCopy-2)*3*2,true,true)");							
					}
					cmd._line_ibSize = (cmd._line_vertNum - 2) * 3 * 2;
					var _line_ib:Int16Array = cmd.line_ibBuffer._int16Data;
					idxpos = 0;
					for (var ii:int = 0; ii < (cmd._line_vertNum-2)*3; ii++) 
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
				// Set a default value for line's ib and vb
				else
				{
					cmd._lineWidth = 1;
					var temp_lineColor:String = '#FFFFFF';
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
			_i32b[1] = 8*4;
			_i32b[_PARAM_VB_POS_] = cmd.vbBuffer.getPtrID();
			_i32b[_PARAM_IB_POS_] = cmd.ibBuffer.getPtrID();				
			_i32b[_PARAM_VB_SIZE_POS_] = cmd._vbSize;
			_i32b[_PARAM_IB_SIZE_POS_] = cmd._ibSize;
			_i32b[_PARAM_VB_OFFSET_POS_] = 0;
			_i32b[_PARAM_IB_OFFSET_POS_] = 0;
			_i32b[_PARAM_INDEX_ELEMENT_OFFSET_POS_] = 0;
			LayaGL.syncBufferToRenderThread(cmd.vbBuffer);
			LayaGL.syncBufferToRenderThread(cmd.ibBuffer);
			
			_i32b[_PARAM_LINE_VB_POS_] = cmd.line_vbBuffer.getPtrID();
			_i32b[_PARAM_LINE_IB_POS_] = cmd.line_ibBuffer.getPtrID();
			_fb[_PARAM_LINECOLOR_POS_] = lineColor;			
			_fb[_PARAM_LINEWIDTH_POS_] = lineWidth;
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
				cmd._cmdCurrentPos = cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_CIRCLE_LINES_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);
			}
			else
			{
				cmd._cmdCurrentPos = cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_CIRCLE_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);	
			}			
			LayaGL.syncBufferToRenderThread( cmd._graphicsCmdEncoder );
			
			return cmd;
		}
		
		private function _arc(cx:Number, cy:Number, r:Number, counterclockwise:Boolean = false, b:Boolean = true):Array {
			
			var newPoints:Array = new Array();
			
			var startAngle:Number = 0;
			var endAngle:Number = Math.PI * 2;
			
			var a:Number = 0, da:Number = 0, hda:Number = 0, kappa:Number = 0;
			var dx:Number = 0, dy:Number = 0, x:Number = 0, y:Number = 0, tanx:Number = 0, tany:Number = 0;
			var px:Number = 0, py:Number = 0, ptanx:Number = 0, ptany:Number = 0;
			var i:int, ndivs:int, nvals:int;
			
			// Clamp angles
			da = endAngle - startAngle;
			if (!counterclockwise) 
			{
				if (Math.abs(da) >= Math.PI * 2) 
				{
					da = Math.PI * 2;
				} 
				else 
				{
					while (da < 0.0) 
					{
						da += Math.PI * 2;
					}
				}
			} 
			else 
			{
				if (Math.abs(da) >= Math.PI * 2) 
				{
					da = -Math.PI * 2;
				} 
				else 
				{
					while (da > 0.0) 
					{
						da -= Math.PI * 2;
					}
				}
			}
			if (r < 101) 
			{
				ndivs = Math.max(10, da * r / 5);
			} 
			else if (r < 201) 
			{
				ndivs = Math.max(10, da * r / 20);
			} 
			else 
			{
				ndivs = Math.max(10, da * r / 40);
			}
			
			hda = (da / ndivs) / 2.0;
			kappa = Math.abs(4 / 3 * (1 - Math.cos(hda)) / Math.sin(hda));
			if (counterclockwise)
			{
				kappa = -kappa;
			}
			
			nvals = 0;
			var _x1:Number, _y1:Number;
			for (i = 0; i <= ndivs; i++) 
			{
				a = startAngle + da * (i / ndivs);
				dx = Math.cos(a);
				dy = Math.sin(a);
				x = cx + dx * r;
				y = cy + dy * r;
				newPoints.push(x);
				newPoints.push(y);
			}
			return newPoints;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			_fillColor = null;
			_lineColor = null;
			_points.length = 0;
			_linePoints.length = 0;
			_line_vbArray.length = 0;
			_line_ibArray.length = 0;
			Pool.recover("DrawCircleCmd", this);
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
		public function get radius():Number
		{
			return _radius;
		}
		
		public function set radius(value:Number):void
		{
			_points = _arc(0, 0, value);
			//给参数赋值
			{
				_vertNum = _points.length / 2;
				var vertNumCopy:int = _vertNum;
				var lineVertNumCopy:int = 0;				
				_linePoints.length = 0;
				_line_ibArray.length = 0;
				_line_vbArray.length = 0;	
				
				// Create ib				
				var curvert:int = 0;

				// Set circle's ib
				var faceNum:int = _vertNum - 2;
				if (!ibBuffer || ibBuffer.getByteLength() < faceNum * 3 * 2 )               
				{
					ibBuffer = __JS__("new ParamData(faceNum*3*2,true,true)");						
				}					
				_ibSize = faceNum * 3 * 2;
				var _ib:Int16Array = ibBuffer._int16Data;
				var idxpos:int = 0;
				for (var fi:int = 0; fi < faceNum; fi++) 
				{
					_ib[idxpos++] = curvert ;
					_ib[idxpos++] = fi+1 + curvert;
					_ib[idxpos++] = fi+2 + curvert;
				}
				// Set circle's vb		
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
				
				// Set line's ib and vb
				if (_lineColor) 
				{					
					for (i = 0; i < _points.length; i++)
					{
						_linePoints.push(_points[i]);
					}
					_linePoints.push(_points[0]);
					_linePoints.push(_points[1]);					
					BasePoly.createLine2(_linePoints, _line_ibArray, _lineWidth, 0, _line_vbArray, false);	
					_line_vertNum = _linePoints.length;
					lineVertNumCopy = _line_vertNum;

					if (!line_ibBuffer || line_ibBuffer.getByteLength() < (_line_vertNum-2)*3*2)
					{
						line_ibBuffer = __JS__("new ParamData((lineVertNumCopy-2)*3*2,true,true)");							
					}
					_line_ibSize = (_line_vertNum - 2) * 3 * 2;
					var _line_ib:Int16Array = line_ibBuffer._int16Data;
					idxpos = 0;
					for (var ii:int = 0; ii < (_line_vertNum-2)*3; ii++) 
					{
						_line_ib[idxpos++] = _line_ibArray[ii];
					}

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
				var _i32b:Int32Array = _paramData._int32Data;
				_i32b[_PARAM_VB_POS_] = vbBuffer.getPtrID();
				_i32b[_PARAM_IB_POS_] = ibBuffer.getPtrID();
				_i32b[_PARAM_VB_SIZE_POS_] = _vbSize;
				_i32b[_PARAM_IB_SIZE_POS_] = _ibSize;
				LayaGL.syncBufferToRenderThread(vbBuffer);
				LayaGL.syncBufferToRenderThread(ibBuffer);
				if (_lineColor)
				{
					_i32b[_PARAM_LINE_VB_POS_] = line_vbBuffer.getPtrID();
					_i32b[_PARAM_LINE_IB_POS_] = line_ibBuffer.getPtrID();
					_i32b[_PARAM_LINE_VB_SIZE_POS_] = _line_vbSize;
					_i32b[_PARAM_LINE_IB_SIZE_POS_] = _line_ibSize;
					LayaGL.syncBufferToRenderThread(line_vbBuffer);
					LayaGL.syncBufferToRenderThread(line_ibBuffer);	
				}				
				LayaGL.syncBufferToRenderThread( _paramData );
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
			if (!_lineColor&&_lineWidth)
			{
				_graphicsCmdEncoder._idata[_cmdCurrentPos + 1] = _DRAW_CIRCLE_LINES_CMD_ENCODER_.getPtrID();
				LayaGL.syncBufferToRenderThread(_graphicsCmdEncoder);
			}
			_lineColor = value;
			
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
			_line_vertNum = _linePoints.length;
			var lineVertNumCopy:int = _line_vertNum;
			
			// Set lines' ib
			if (!line_ibBuffer || line_ibBuffer.getByteLength() < (_line_vertNum-2)*3*2)
			{
				line_ibBuffer = __JS__("new ParamData((lineVertNumCopy-2)*3*2,true,true)");							
			}
			_line_ibSize = (_line_vertNum - 2) * 3 * 2;
			var _line_ib:Int16Array = line_ibBuffer._int16Data;
			var idxpos:int = 0;
			for (var ii:int = 0; ii < (_line_vertNum-2)*3; ii++) 
			{
				_line_ib[idxpos++] = _line_ibArray[ii];
			}
			
			// Set lines' vb					
			if (!line_vbBuffer || line_vbBuffer.getByteLength() < _line_vertNum*3 * 4) 
			{
				line_vbBuffer = __JS__("new ParamData(lineVertNumCopy*3 * 4,true)"); 					
			}
			_line_vbSize = _line_vertNum * 3 * 4;					
			var c2:ColorUtils = ColorUtils.create(value);
			var nColor2:uint = c2.numColor;
			var _line_vb:Float32Array = line_vbBuffer._float32Data;
			var _line_vb_i32b:Int32Array = line_vbBuffer._int32Data;
			var ix:int = 0;
			for (i = 0; i < _line_vertNum; i++)
			{
				_line_vb[ix++] = _line_vbArray[i * 2] + x; 	_line_vb[ix++] = _line_vbArray[i * 2 + 1] + y; 	_line_vb_i32b[ix++] = nColor2;
			}
			var _i32b:Int32Array = _paramData._int32Data;;
			_i32b[_PARAM_LINE_VB_POS_] = line_vbBuffer.getPtrID();
			_i32b[_PARAM_LINE_IB_POS_] = line_ibBuffer.getPtrID();
			_i32b[_PARAM_LINE_VB_SIZE_POS_] = _line_vbSize;
			_i32b[_PARAM_LINE_IB_SIZE_POS_] = _line_ibSize;
			LayaGL.syncBufferToRenderThread(line_vbBuffer);
			LayaGL.syncBufferToRenderThread(line_ibBuffer);	
			
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get lineWidth():Number
		{
			return _lineWidth;
		}
		
		public function set lineWidth(value:Number):void
		{
			if (!_lineWidth&&_lineColor)
			{
				_graphicsCmdEncoder._idata[_cmdCurrentPos + 1] = _DRAW_CIRCLE_LINES_CMD_ENCODER_.getPtrID();
				LayaGL.syncBufferToRenderThread(_graphicsCmdEncoder);
			}
			_lineWidth = value;

			_linePoints.length = 0;
			_line_ibArray.length = 0;
			_line_vbArray.length = 0;
			for (var i:int = 0; i < _points.length; i++)
			{
				_linePoints.push(_points[i]);
			}
			_linePoints.push(_points[0]);
			_linePoints.push(_points[1]);
			
			BasePoly.createLine2(_linePoints, _line_ibArray, value, 0, _line_vbArray, false);	
			_line_vertNum = _linePoints.length;
			var lineVertNumCopy:int = _line_vertNum;
			
			// Set lines' ib
			if (!line_ibBuffer || line_ibBuffer.getByteLength() < (_line_vertNum-2)*3*2)
			{
				line_ibBuffer = __JS__("new ParamData((lineVertNumCopy-2)*3*2,true,true)");							
			}
			_line_ibSize = (_line_vertNum - 2) * 3 * 2;
			var _line_ib:Int16Array = line_ibBuffer._int16Data;
			var idxpos:int = 0;
			for (var ii:int = 0; ii < (_line_vertNum-2)*3; ii++) 
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
			var ix:int = 0;
			for (i = 0; i < _line_vertNum; i++)
			{
				_line_vb[ix++] = _line_vbArray[i * 2] + x; 	_line_vb[ix++] = _line_vbArray[i * 2 + 1] + y; 	_line_vb_i32b[ix++] = nColor2;
			}
			var _i32b:Int32Array = _paramData._int32Data;;
			_i32b[_PARAM_LINE_VB_POS_] = line_vbBuffer.getPtrID();
			_i32b[_PARAM_LINE_IB_POS_] = line_ibBuffer.getPtrID();
			_i32b[_PARAM_LINE_VB_SIZE_POS_] = _line_vbSize;
			_i32b[_PARAM_LINE_IB_SIZE_POS_] = _line_ibSize;
			LayaGL.syncBufferToRenderThread(line_vbBuffer);
			LayaGL.syncBufferToRenderThread(line_ibBuffer);	
			
			LayaGL.syncBufferToRenderThread( _paramData );
		}
	}
}