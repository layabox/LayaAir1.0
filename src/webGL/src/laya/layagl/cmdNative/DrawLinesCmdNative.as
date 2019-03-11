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
	public class DrawLinesCmdNative  {
		public static const ID:String = "DrawLines";
		public static var _DRAW_LINES_CMD_ENCODER_:* = null;
		public static var _PARAM_VB_POS_:int = 1;
		public static var _PARAM_IB_POS_:int = 2;
		public static var _PARAM_LINECOLOR_POS_:int = 3;
		public static var _PARAM_LINEWIDTH_POS_:int = 4;
		public static var _PARAM_VID_POS_:int = 5;
		public static var _PARAM_VB_SIZE_POS_:int = 6;
		public static var _PARAM_IB_SIZE_POS_:int = 7;
		public static var _PARAM_VB_OFFSET_POS_:int = 8;
		public static var _PARAM_IB_OFFSET_POS_:int = 9;
		public static var _PARAM_INDEX_ELEMENT_OFFSET_POS_:int = 10;
		
		private var _graphicsCmdEncoder:*;
		private var _paramData:* = null;		
		private var _x:Number;
		private var _y:Number;
		private var _points:Array;
		private var _lineColor:*;
		private var _lineWidth:Number;
		private var _vid:int;
		private var _vertNum:int;
		
		private var ibBuffer:*;
		private var vbBuffer:*;
		private var _ibSize:int = 0;
		private var _vbSize:int = 0;
		private var _ibArray:Array = new Array();
		private var _vbArray:Array = new Array();
		
		public static function create(x:Number,y:Number,points:Array,lineColor:*,lineWidth:Number,vid:int):DrawLinesCmdNative {
			var cmd:DrawLinesCmdNative = Pool.getItemByClass("DrawLinesCmd", DrawLinesCmdNative);
			cmd._graphicsCmdEncoder = __JS__("this._commandEncoder;");			
			if (!_DRAW_LINES_CMD_ENCODER_)
			{
				_DRAW_LINES_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(152, 32, true);
				_DRAW_LINES_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);//programID
				_DRAW_LINES_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);//VAO ID
				_DRAW_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_LINES_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_LINES_CMD_ENCODER_.setMeshExByParamData(_PARAM_VB_POS_ * 4, _PARAM_VB_OFFSET_POS_ * 4, _PARAM_VB_SIZE_POS_ * 4, _PARAM_IB_POS_ * 4, _PARAM_IB_OFFSET_POS_ * 4, _PARAM_IB_SIZE_POS_ * 4, _PARAM_INDEX_ELEMENT_OFFSET_POS_ * 4);
				_DRAW_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_LINES_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				LayaGL.syncBufferToRenderThread( _DRAW_LINES_CMD_ENCODER_ );
			}
			
			if (!cmd._paramData)
			{
				cmd._paramData = __JS__("new ParamData(11 * 4, true)");
			}
			//给参数赋值
			{
				cmd._x = x;
				cmd._y = y;
				cmd._points = points;
				cmd._lineColor = lineColor;
				cmd._lineWidth = lineWidth;
				cmd._vid = vid;
				// Get vb and ib
				BasePoly.createLine2(points, cmd._ibArray, lineWidth, 0, cmd._vbArray, false);
				// Save vb
				var c1:ColorUtils = ColorUtils.create(lineColor);
				var nColor:uint = c1.numColor;
				cmd._vertNum = points.length;
				var vertNumCopy:int = cmd._vertNum;
				if (!cmd.vbBuffer || cmd.vbBuffer.getByteLength() < cmd._vertNum*3*4)
				{					
					cmd.vbBuffer = __JS__("new ParamData(vertNumCopy*3*4, true)");					
				}			
				cmd._vbSize = cmd._vertNum * 3 * 4;
				var _vb:Float32Array = cmd.vbBuffer._float32Data;
				var _i32b:Int32Array = cmd.vbBuffer._int32Data;
				var ix:int = 0;
				for (var i:int = 0; i < cmd._vertNum; i++)
				{
					_vb[ix++] = cmd._vbArray[i * 2] + x; 	_vb[ix++] = cmd._vbArray[i * 2 + 1] + y; 	_i32b[ix++] = nColor;
				}
				// Save ib
				if (!cmd.ibBuffer || cmd.ibBuffer.getByteLength() < (cmd._vertNum-2)*3 * 2)
				{
					cmd.ibBuffer = __JS__("new ParamData((vertNumCopy-2)*3 * 2, true, true)");					
				}				
				cmd._ibSize = (cmd._vertNum - 2) * 3 * 2;
				var _ib:Int16Array = cmd.ibBuffer._int16Data;
				for (var ii:int = 0; ii < (cmd._vertNum-2)*3; ii++) 
				{
					_ib[ii] = cmd._ibArray[ii];
				}
				
			}
			// Save all the data in _paramData
			var _fb:Float32Array = cmd._paramData._float32Data;
			_i32b = cmd._paramData._int32Data;
			_i32b[0] = 1;
			_i32b[_PARAM_VB_POS_] = cmd.vbBuffer.getPtrID();
			_i32b[_PARAM_IB_POS_] = cmd.ibBuffer.getPtrID();
			if (!lineColor)
			{
				_fb[_PARAM_LINECOLOR_POS_] = 0xff0000ff;
			}
			else
			{
				_fb[_PARAM_LINECOLOR_POS_] = lineColor; 
			}			
			_fb[_PARAM_LINEWIDTH_POS_] = lineWidth;
			_fb[_PARAM_VID_POS_] = vid;
			_i32b[_PARAM_VB_SIZE_POS_] = cmd._vbSize;
			_i32b[_PARAM_IB_SIZE_POS_] = cmd._ibSize;
			_i32b[_PARAM_VB_OFFSET_POS_] = 0;
			_i32b[_PARAM_IB_OFFSET_POS_] = 0;
			_i32b[_PARAM_INDEX_ELEMENT_OFFSET_POS_] = 0;
			LayaGL.syncBufferToRenderThread(cmd.vbBuffer);
			LayaGL.syncBufferToRenderThread(cmd.ibBuffer);
			LayaGL.syncBufferToRenderThread( cmd._paramData);
			cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_LINES_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);
			LayaGL.syncBufferToRenderThread( cmd._graphicsCmdEncoder);
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			_points = null;
			_lineColor = null;
			_ibArray.length = 0;	
			_vbArray.length = 0;
			Pool.recover("DrawLinesCmd", this);
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
				_vb[ix++] = _vbArray[i * 2] + _x;	ix++;	ix++;
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
			for (var i:int = 0; i < _vertNum; i++)
			{
				ix++;	_vb[ix++] = _vbArray[i * 2 + 1] + _y;	ix++;
			}
			LayaGL.syncBufferToRenderThread(vbBuffer);
		}
		public function get points():Array
		{
			return _points;
		}
		
		public function set points(value:Array):void
		{	
			_points = value;
			// Get vb and ib
			_ibArray.length = 0;
			_vbArray.length = 0;
			BasePoly.createLine2(_points, _ibArray, _lineWidth, 0, _vbArray, false);
			// Save vb
			var c1:ColorUtils = ColorUtils.create(_lineColor);
			var nColor:uint = c1.numColor;
			_vertNum = _points.length;
			var vertNumCopy:int = _vertNum;
			if (!vbBuffer || vbBuffer.getByteLength() < _vertNum*3*4)
			{					
				vbBuffer = __JS__("new ParamData(vertNumCopy*3*4, true)");					
			}			
			_vbSize = _vertNum * 3 * 4;
			var _vb:Float32Array = vbBuffer._float32Data;
			var _i32b:Int32Array = vbBuffer._int32Data;
			var ix:int = 0;
			for (var i:int = 0; i < _vertNum; i++)
			{
				_vb[ix++] = _vbArray[i * 2] + x; 	_vb[ix++] = _vbArray[i * 2 + 1] + y; 	_i32b[ix++] = nColor;
			}
			// Save ib
			if (!ibBuffer || ibBuffer.getByteLength() < (_vertNum-2)*3 * 2)
			{
				ibBuffer = __JS__("new ParamData((vertNumCopy-2)*3 * 2, true, true)");					
			}				
			_ibSize = (_vertNum - 2) * 3 * 2;
			var _ib:Int16Array = ibBuffer._int16Data;
			for (var ii:int = 0; ii < (_vertNum-2)*3; ii++) 
			{
				_ib[ii] = _ibArray[ii];
			}
			_i32b = _paramData._int32Data;
			_i32b[_PARAM_VB_SIZE_POS_] = _vbSize;
			_i32b[_PARAM_IB_SIZE_POS_] = _ibSize;
			LayaGL.syncBufferToRenderThread( ibBuffer );
			LayaGL.syncBufferToRenderThread( vbBuffer );
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get lineColor():*
		{
			return _lineColor;
		}
		
		public function set lineColor(value:*):void
		{
			_lineColor = value;
			var c1:ColorUtils = ColorUtils.create(_lineColor);
			var nColor:uint = c1.numColor;
			var _i32b:Int32Array = vbBuffer._int32Data;
			var ix:int = 0;
			for (var i:int = 0; i < _vertNum; i++)
			{
				ix++;	ix++; 	_i32b[ix++] = nColor;
			}
			LayaGL.syncBufferToRenderThread( vbBuffer );
		}
		public function get lineWidth():Number
		{
			return _lineWidth;
		}
		
		public function set lineWidth(value:Number):void
		{
			_lineWidth = value;
			// Get vb and ib
			_ibArray.length = 0;
			_vbArray.length = 0;
			BasePoly.createLine2(_points, _ibArray, _lineWidth, 0, _vbArray, false);
			var _vb:Float32Array = vbBuffer._float32Data;
			var ix:int = 0;
			for (var i:int = 0; i < _vertNum; i++)
			{
				_vb[ix++] = _vbArray[i * 2] + x; 	_vb[ix++] = _vbArray[i * 2 + 1] + y; 	ix++;
			}
			LayaGL.syncBufferToRenderThread( vbBuffer);
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