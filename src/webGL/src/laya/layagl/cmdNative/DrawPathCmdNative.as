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
	public class DrawPathCmdNative  {
		public static const ID:String = "DrawPath";
		public static var _DRAW_LINES_CMD_ENCODER_:* = null;
		public static var _DRAW_LINES_FILL_CMD_ENCODER_:* = null;
		public static var _DRAW_FILL_CMD_ENCODER_:* = null;
		public static var _PARAM_LINES_VB_POS_:int = 1;
		public static var _PARAM_LINES_IB_POS_:int = 2;
		public static var _PARAM_LINES_VB_SIZE_POS_:int = 3;
		public static var _PARAM_LINES_IB_SIZE_POS_:int = 4;
		public static var _PARAM_FILL_VB_POS_:int = 5;
		public static var _PARAM_FILL_IB_POS_:int = 6;
		public static var _PARAM_FILL_VB_SIZE_POS_:int = 7;
		public static var _PARAM_FILL_IB_SIZE_POS_:int = 8;
		
		public static var _PARAM_FILL_VB_OFFSET_POS_:int = 9;
		public static var _PARAM_FILL_IB_OFFSET_POS_:int = 10;
		public static var _PARAM_LINE_VB_OFFSET_POS_:int = 11;
		public static var _PARAM_LINE_IB_OFFSET_POS_:int = 12;
		public static var _PARAM_FILL_INDEX_ELEMENT_OFFSET_POS_:int = 13;
		public static var _PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_:int = 14;
		
		private var _graphicsCmdEncoder:*;
		private var _paramData:* = null;
		private var _graphicsCmdEncoder_fill:*;
		private var _paramData_fill:* = null;
		private var _x:Number;
		private var _y:Number;
		private var _paths:Array;
		private var _brush:Object;
		private var _pen:Object;
		private var _points:Array = new Array();
		private var _vertNum:int;
		private var _startOriX:Number = 0;
		private var _startOriY:Number = 0;
		private var _lastOriX:Number = 0;
		private var _lastOriY:Number = 0;
		private var SEGNUM:int = 32;
		
		private var lines_ibBuffer:*;
		private var lines_vbBuffer:*;
		private var _lines_ibSize:int = 0;
		private var _lines_vbSize:int = 0;
		private var _lines_ibArray:Array = new Array();
		private var _lines_vbArray:Array = new Array();
		private var fill_ibBuffer:*;
		private var fill_vbBuffer:*;
		private var _fill_ibSize:int = 0;
		private var _fill_vbSize:int = 0;
		private var _fill_ibArray:Array = new Array();
		private var _fill_vbArray:Array = new Array();
		
		private var _cmdCurrentPos:int;
		
		public static function create(x:Number,y:Number,paths:Array,brush:Object,pen:Object):DrawPathCmdNative {
			var cmd:DrawPathCmdNative = Pool.getItemByClass("DrawPathCmd", DrawPathCmdNative);
			
			cmd._graphicsCmdEncoder = __JS__("this._commandEncoder;");
			
			if (!_DRAW_LINES_CMD_ENCODER_)
			{
				_DRAW_LINES_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(188, 32, true);
				_DRAW_LINES_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				_DRAW_LINES_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);//programID
				_DRAW_LINES_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);//VAO ID
				_DRAW_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_LINES_CMD_ENCODER_.setMeshExByParamData(_PARAM_LINES_VB_POS_ * 4, _PARAM_LINE_VB_OFFSET_POS_*4, _PARAM_LINES_VB_SIZE_POS_ * 4, _PARAM_LINES_IB_POS_ * 4, _PARAM_LINE_IB_OFFSET_POS_*4, _PARAM_LINES_IB_SIZE_POS_ * 4, _PARAM_FILL_INDEX_ELEMENT_OFFSET_POS_ * 4);
				_DRAW_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				LayaGL.syncBufferToRenderThread( _DRAW_LINES_CMD_ENCODER_ );
			}
			if (!_DRAW_FILL_CMD_ENCODER_)
			{
				_DRAW_FILL_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(168, 32, true);
				_DRAW_FILL_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				_DRAW_FILL_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);//programID
				_DRAW_FILL_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);//VAO ID
				_DRAW_FILL_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_FILL_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_FILL_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_FILL_CMD_ENCODER_.setMeshExByParamData(_PARAM_FILL_VB_POS_ * 4, _PARAM_FILL_VB_OFFSET_POS_*4, _PARAM_FILL_VB_SIZE_POS_ * 4, _PARAM_FILL_IB_POS_ * 4, _PARAM_FILL_IB_OFFSET_POS_*4, _PARAM_FILL_IB_SIZE_POS_ * 4, _PARAM_FILL_INDEX_ELEMENT_OFFSET_POS_ * 4);
				_DRAW_FILL_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_FILL_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				LayaGL.syncBufferToRenderThread( _DRAW_FILL_CMD_ENCODER_ );
			}
			if (!_DRAW_LINES_FILL_CMD_ENCODER_)
			{
				_DRAW_LINES_FILL_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(244, 32, true);
				_DRAW_LINES_FILL_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				_DRAW_LINES_FILL_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);//programID
				_DRAW_LINES_FILL_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);//VAO ID
				_DRAW_LINES_FILL_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_LINES_FILL_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_LINES_FILL_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_LINES_FILL_CMD_ENCODER_.setMeshExByParamData(_PARAM_FILL_VB_POS_ * 4, _PARAM_FILL_VB_OFFSET_POS_*4, _PARAM_FILL_VB_SIZE_POS_ * 4, _PARAM_FILL_IB_POS_ * 4, _PARAM_FILL_IB_OFFSET_POS_*4, _PARAM_FILL_IB_SIZE_POS_ * 4, _PARAM_FILL_INDEX_ELEMENT_OFFSET_POS_ * 4);
				_DRAW_LINES_FILL_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_LINES_FILL_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				_DRAW_LINES_FILL_CMD_ENCODER_.setMeshExByParamData(_PARAM_LINES_VB_POS_ * 4, _PARAM_LINE_VB_OFFSET_POS_*4, _PARAM_LINES_VB_SIZE_POS_ * 4, _PARAM_LINES_IB_POS_ * 4, _PARAM_LINE_IB_OFFSET_POS_*4, _PARAM_LINES_IB_SIZE_POS_ * 4, _PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_ * 4);
				_DRAW_LINES_FILL_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_LINES_FILL_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				LayaGL.syncBufferToRenderThread( _DRAW_LINES_FILL_CMD_ENCODER_ );
			}
			if (!cmd._paramData)
			{
				cmd._paramData = __JS__("new ParamData(15 * 4, true)");
			}
			//给参数赋值
			{
				cmd._x = x;
				cmd._y = y;
				cmd._paths = paths;
				cmd._brush = brush;
				cmd._pen = pen;
				// Get vb and ib
				for ( var i:int = 0, n:int = paths.length; i < n; i++ )
				{
					var path:Array = paths[i];
					if (i == 0)
					{
						cmd._startOriX = path[1];
						cmd._startOriY = path[2];
					}
					switch(path[0])
					{
						case "moveTo":
							cmd._lastOriX = path[1];
							cmd._lastOriY = path[2];
							cmd._points.push(path[1]);
							cmd._points.push(path[2]);
							break;
						case "lineTo":
							cmd._lastOriX = path[1];
							cmd._lastOriY = path[2];
							cmd._points.push(path[1]);
							cmd._points.push(path[2]);
							break; 
						case "arcTo":
							cmd._arcTo(path);
							break;
						case "closePath":
							cmd._points.push(cmd._startOriX);
							cmd._points.push(cmd._startOriY);
							break;
					}
				}
				
				cmd._vertNum = cmd._points.length;
				// Set line
				if(pen){
					BasePoly.createLine2(cmd._points, cmd._lines_ibArray,  pen.lineWidth, 0, cmd._lines_vbArray, false);
					// Save vb
					var c1:ColorUtils = ColorUtils.create(pen.strokeStyle);
					var nColor:uint = c1.numColor;
					
					var vertNumCopy:int = cmd._vertNum;
					if (!cmd.lines_vbBuffer || cmd.lines_vbBuffer.getByteLength() < cmd._vertNum*3*4)
					{					
						cmd.lines_vbBuffer = __JS__("new ParamData(vertNumCopy*3*4, true)");					
					}			
					cmd._lines_vbSize = cmd._vertNum * 3 * 4;
					var _vb:Float32Array = cmd.lines_vbBuffer._float32Data;
					var _i32b:Int32Array = cmd.lines_vbBuffer._int32Data;
					var ix:int = 0;
					for (i = 0; i < cmd._vertNum; i++)
					{
						_vb[ix++] = cmd._lines_vbArray[i * 2] + x; 	_vb[ix++] = cmd._lines_vbArray[i * 2 + 1] + y; 	_i32b[ix++] = nColor;
					}
					// Save ib
					if (!cmd.lines_ibBuffer || cmd.lines_ibBuffer.getByteLength() < (cmd._vertNum-2)*3 * 2)
					{
						cmd.lines_ibBuffer = __JS__("new ParamData((vertNumCopy-2)*3 * 2, true, true)");					
					}				
					cmd._lines_ibSize = (cmd._vertNum - 2) * 3 * 2;
					var _ib:Int16Array = cmd.lines_ibBuffer._int16Data;
					for (var ii:int = 0; ii < (cmd._vertNum-2)*3; ii++) 
					{
						_ib[ii] = cmd._lines_ibArray[ii];
					}
				}
				
				
				// Set fill
				if (brush)
				{
					vertNumCopy = cmd._vertNum;
					// Create ib				
					var cur:Array = Earcut.earcut(cmd._points, null, 2);	//返回索引
					if (cur.length > 0) 
					{
						// Set fill's ib
						if (!cmd.fill_ibBuffer || cmd.fill_ibBuffer.getByteLength() < cur.length*2)
						{
							cmd.fill_ibBuffer = __JS__("new ParamData(cur.length*2,true,true)");							
						}						
						cmd._fill_ibSize = cur.length * 2;
						_ib = cmd.fill_ibBuffer._int16Data;
						var idxpos:int = 0;
						for (ii = 0; ii < cur.length; ii++) 
						{
							_ib[idxpos++] = cur[ii];
						}						
					}
					
					// Set fill's vb
					c1 = ColorUtils.create(brush.fillStyle);
					nColor = c1.numColor;				
					if (!cmd.fill_vbBuffer || cmd.fill_vbBuffer.getByteLength() < cmd._vertNum * 3 * 4)
					{
						cmd.fill_vbBuffer = __JS__("new ParamData(vertNumCopy*3 * 4,true)");					
					}
					cmd._fill_vbSize = cmd._vertNum * 3 * 4;
					_vb = cmd.fill_vbBuffer._float32Data;
					var _vb_i32b:Int32Array = cmd.fill_vbBuffer._int32Data;
					_vb_i32b = cmd.fill_vbBuffer._int32Data;
					ix = 0;
					for (i = 0; i < cmd._vertNum; i++)
					{
						_vb[ix++] = cmd._points[i * 2] + x; 	_vb[ix++] = cmd._points[i * 2 + 1] + y; 	_vb_i32b[ix++] = nColor;
					}
				}
			}
			
			// Save all the data in _paramData
			var _fb:Float32Array = cmd._paramData._float32Data;
			_i32b = cmd._paramData._int32Data;
			_i32b[0] = 1;
			if (pen) {
				_i32b[_PARAM_LINES_VB_POS_] = cmd.lines_vbBuffer.getPtrID();
				_i32b[_PARAM_LINES_IB_POS_] = cmd.lines_ibBuffer.getPtrID();			
				_i32b[_PARAM_LINES_VB_SIZE_POS_] = cmd._lines_vbSize;
				_i32b[_PARAM_LINES_IB_SIZE_POS_] = cmd._lines_ibSize;
				_i32b[_PARAM_LINE_VB_OFFSET_POS_] = 0;
				_i32b[_PARAM_LINE_IB_OFFSET_POS_] = 0;
				_i32b[_PARAM_LINE_INDEX_ELEMENT_OFFSET_POS_] = 0;
				LayaGL.syncBufferToRenderThread(cmd.lines_vbBuffer);
				LayaGL.syncBufferToRenderThread(cmd.lines_ibBuffer);
			}			
			
			if (brush) {
				_i32b[_PARAM_FILL_VB_POS_] = cmd.fill_vbBuffer.getPtrID();
				_i32b[_PARAM_FILL_IB_POS_] = cmd.fill_ibBuffer.getPtrID();			
				_i32b[_PARAM_FILL_VB_SIZE_POS_] = cmd._fill_vbSize;
				_i32b[_PARAM_FILL_IB_SIZE_POS_] = cmd._fill_ibSize;
				_i32b[_PARAM_FILL_VB_OFFSET_POS_] = 0;
				_i32b[_PARAM_FILL_IB_OFFSET_POS_] = 0;
				_i32b[_PARAM_FILL_INDEX_ELEMENT_OFFSET_POS_] = 0;
				LayaGL.syncBufferToRenderThread(cmd.fill_vbBuffer);
				LayaGL.syncBufferToRenderThread(cmd.fill_ibBuffer);
			}			
			
			LayaGL.syncBufferToRenderThread( cmd._paramData);
			
			if (brush && pen)
			{
				cmd._cmdCurrentPos = cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_LINES_FILL_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);
			}
			else if (brush && !pen)
			{
				cmd._cmdCurrentPos = cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_FILL_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);				
			}			
			else if (!brush && pen)
			{
				cmd._cmdCurrentPos = cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_LINES_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);	
			}
			LayaGL.syncBufferToRenderThread( cmd._graphicsCmdEncoder);
			
			return cmd;
		}
		
		private function _arcTo(path:Array):void
		{
			var x1:Number = path[1];
			var y1:Number = path[2];
			var x2:Number = path[3];
			var y2:Number = path[4];
			var r:Number = path[5];
			
			var i:int = 0;
			var x:Number = 0, y:Number = 0;
			var dx:Number = _lastOriX - x1;
			var dy:Number = _lastOriY - y1;
			var len1:Number = Math.sqrt(dx*dx + dy*dy);
			if (len1 <= 0.000001) {
				return;
			}
			var ndx:Number = dx / len1;
			var ndy:Number = dy / len1;
			var dx2:Number = x2 - x1;
			var dy2:Number = y2 - y1;
			var len22:Number = dx2*dx2 + dy2*dy2;
			var len2:Number = Math.sqrt(len22);
			if (len2 <= 0.000001) {
				return;
			}
			var ndx2:Number = dx2 / len2;
			var ndy2:Number = dy2 / len2;
			var odx:Number = ndx + ndx2;
			var ody:Number = ndy + ndy2;
			var olen:Number = Math.sqrt(odx*odx + ody*ody);
			if (olen <= 0.000001) {
				return;
			}

			var nOdx:Number = odx / olen;
			var nOdy:Number = ody / olen;

			var alpha:Number = Math.acos(nOdx*ndx + nOdy*ndy);
			var halfAng:Number = Math.PI / 2 - alpha; 
                                
			len1 = r / Math.tan(halfAng);
			var ptx1:Number = len1*ndx + x1;
			var pty1:Number = len1*ndy + y1;
  
			var orilen:Number = Math.sqrt(len1 * len1 + r * r);
			//圆心
			var orix:Number = x1 + nOdx*orilen;
			var oriy:Number = y1 + nOdy*orilen;

			var ptx2:Number = len1*ndx2 + x1;
			var pty2:Number = len1*ndy2 + y1;

			var dir:Number = ndx * ndy2 - ndy * ndx2;

			var fChgAng:Number = 0;
			var sinx:Number = 0.0;
			var cosx:Number = 0.0;
			if (dir >= 0) {
				fChgAng = halfAng * 2;
				var fda:Number = fChgAng / SEGNUM;
				sinx = Math.sin(fda);
				cosx = Math.cos(fda);
			}
			else {
				fChgAng = -halfAng * 2;
				fda = fChgAng / SEGNUM;
				sinx = Math.sin(fda);
				cosx = Math.cos(fda);
			}
		
			var lastx:Number=_lastOriX, lasty:Number=_lastOriY;	//没有矩阵转换的上一个点
			var cvx:Number = ptx1 - orix;
			var cvy:Number = pty1 - oriy;
			var tx:Number = 0.0;
			var ty:Number = 0.0;
			for (i = 0; i < SEGNUM; i++) {
				var cx:Number = cvx*cosx + cvy*sinx;
				var cy:Number = -cvx*sinx + cvy*cosx;
				x = cx + orix;
				y = cy + oriy;
				if ( Math.abs(lastx-x)>0.1 || Math.abs(lasty - y)>0.1) {
					_points.push(x);
					_points.push(y);
				}
				cvx = cx;
				cvy = cy;
			}
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			_paths = null;
			_brush = null;
			_pen = null;
			_points.length = 0;
			_lines_ibArray.length = 0;
			_lines_vbArray.length = 0;
			_fill_ibArray.length = 0;
			_fill_vbArray.length = 0;
			Pool.recover("DrawPathCmd", this);
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
			var _vb:Float32Array = lines_vbBuffer._float32Data;
			var ix:int = 0;
			for (var i:int = 0; i < _vertNum; i++)
			{
				_vb[ix++] = _lines_vbArray[i * 2] + value; 	ix++; 	ix++;
			}
			LayaGL.syncBufferToRenderThread( lines_vbBuffer );
		}
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
			var _vb:Float32Array = lines_vbBuffer._float32Data;
			var ix:int = 0;
			for (var i:int = 0; i < _vertNum; i++)
			{
				ix++;	_vb[ix++] = _lines_vbArray[i * 2 + 1] + value; 	ix++;
			}
			LayaGL.syncBufferToRenderThread( lines_vbBuffer );
		}
		public function get paths():Array
		{
			return _paths;
		}
		
		public function set paths(value:Array):void
		{
			_paths = value;
		}
		public function get brush():Object
		{
			return _brush;
		}
		
		public function set brush(value:Object):void
		{
			if (!_brush)
			{
				_graphicsCmdEncoder._idata[_cmdCurrentPos + 1] = _DRAW_LINES_FILL_CMD_ENCODER_.getPtrID();
				LayaGL.syncBufferToRenderThread(_graphicsCmdEncoder);
			}
			_brush = value;
			var vertNumCopy:int = _vertNum;
			// Create ib				
			var cur:Array = Earcut.earcut(_points, null, 2);	//返回索引
			if (cur.length > 0) 
			{
				// Set fill's ib
				if (!fill_ibBuffer || fill_ibBuffer.getByteLength() < cur.length*2)
				{
					fill_ibBuffer = __JS__("new ParamData(cur.length*2,true,true)");							
				}						
				_fill_ibSize = cur.length * 2;
				var _ib:Int16Array = fill_ibBuffer._int16Data;
				var idxpos:int = 0;
				for (var ii:int = 0; ii < cur.length; ii++) 
				{
					_ib[idxpos++] = cur[ii];
				}						
			}
			
			// Set fill's vb
			var c1:ColorUtils = ColorUtils.create(value.fillStyle);
			var nColor:uint = c1.numColor;				
			if (!fill_vbBuffer || fill_vbBuffer.getByteLength() < _vertNum * 3 * 4)
			{
				fill_vbBuffer = __JS__("new ParamData(vertNumCopy*3 * 4,true)");					
			}
			_fill_vbSize = _vertNum * 3 * 4;
			var _vb:Float32Array = fill_vbBuffer._float32Data;
			var _vb_i32b:Int32Array = fill_vbBuffer._int32Data;
			var ix:int = 0;
			for (var i:int = 0; i < _vertNum; i++)
			{
				_vb[ix++] = _points[i * 2] + x; 	_vb[ix++] = _points[i * 2 + 1] + y; 	_vb_i32b[ix++] = nColor;
			}
			var _i32b:Int32Array = _paramData._int32Data;
			_i32b[_PARAM_FILL_VB_POS_] = fill_vbBuffer.getPtrID();
			_i32b[_PARAM_FILL_IB_POS_] = fill_ibBuffer.getPtrID();			
			_i32b[_PARAM_FILL_VB_SIZE_POS_] = _fill_vbSize;
			_i32b[_PARAM_FILL_IB_SIZE_POS_] = _fill_ibSize;
			LayaGL.syncBufferToRenderThread(fill_vbBuffer);
			LayaGL.syncBufferToRenderThread(fill_ibBuffer);
			
			LayaGL.syncBufferToRenderThread( _paramData);
		}
		public function get pen():Object
		{
			return _pen;
		}
		
		public function set pen(value:Object):void
		{
			_pen = value;
			_lines_ibArray.length = 0;
			_lines_vbArray.length = 0;
			BasePoly.createLine2(_points, _lines_ibArray,  value.lineWidth, 0, _lines_vbArray, false);

			// Save vb
			var c1:ColorUtils = ColorUtils.create(value.strokeStyle);
			var nColor:uint = c1.numColor;
			var vertNumCopy:int = _vertNum;
			if (!lines_vbBuffer || lines_vbBuffer.getByteLength() < _vertNum*3*4)
			{					
				lines_vbBuffer = __JS__("new ParamData(vertNumCopy*3*4, true)");					
			}			
			_lines_vbSize = _vertNum * 3 * 4;
			var _vb:Float32Array = lines_vbBuffer._float32Data;
			var _i32b:Int32Array = lines_vbBuffer._int32Data;
			var ix:int = 0;
			for (var i:int = 0; i < _vertNum; i++)
			{
				_vb[ix++] = _lines_vbArray[i * 2] + x; 	_vb[ix++] = _lines_vbArray[i * 2 + 1] + y; 	_i32b[ix++] = nColor;
			}
			// Save ib
			if (!lines_ibBuffer || lines_ibBuffer.getByteLength() < (_vertNum-2)*3 * 2)
			{
				lines_ibBuffer = __JS__("new ParamData((vertNumCopy-2)*3 * 2, true, true)");					
			}				
			_lines_ibSize = (_vertNum - 2) * 3 * 2;
			var _ib:Int16Array = lines_ibBuffer._int16Data;
			for (var ii:int = 0; ii < (_vertNum-2)*3; ii++) 
			{
				_ib[ii] = _lines_ibArray[ii];
			}
			_i32b = _paramData._int32Data;
			_i32b[_PARAM_LINES_VB_POS_] = lines_vbBuffer.getPtrID();
			_i32b[_PARAM_LINES_IB_POS_] = lines_ibBuffer.getPtrID();			
			_i32b[_PARAM_LINES_VB_SIZE_POS_] = _lines_vbSize;
			_i32b[_PARAM_LINES_IB_SIZE_POS_] = _lines_ibSize;
			LayaGL.syncBufferToRenderThread(lines_vbBuffer);
			LayaGL.syncBufferToRenderThread(lines_ibBuffer);
			LayaGL.syncBufferToRenderThread(_paramData);
		}
	}
}