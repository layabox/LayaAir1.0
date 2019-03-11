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
	public class DrawLineCmdNative  {
		public static const ID:String = "DrawLine";
		public static var _DRAW_LINE_CMD_ENCODER_:* = null;
		public static var _PARAM_VB_POS_:int = 3;
		public static var _PARAM_IB_POS_:int = 15;
		public static var _PARAM_LINECOLOR_POS_:int = 18;
		public static var _PARAM_LINEWIDTH_POS_:int = 19;
		public static var _PARAM_VID_POS_:int = 20;
		public static var _PARAM_VB_OFFSET_POS_:int = 21;
		public static var _PARAM_IB_OFFSET_POS_:int = 22;
		public static var _PARAM_INDEX_ELEMENT_OFFSET_POS_:int = 23;
		private var _graphicsCmdEncoder:*;
		private var _paramData:*= null;
		private var _fromX:Number;
		private var _fromY:Number;
		private var _toX:Number;
		private var _toY:Number;
		private var _lineColor:String;
		private var _lineWidth:Number;
		private var _vid:int;
		
		public static function create(fromX:Number,fromY:Number,toX:Number,toY:Number,lineColor:String,lineWidth:Number,vid:int):DrawLineCmdNative {
			var cmd:DrawLineCmdNative = Pool.getItemByClass("DrawLineCmd", DrawLineCmdNative);
			cmd._graphicsCmdEncoder = __JS__("this._commandEncoder;");
			if (!_DRAW_LINE_CMD_ENCODER_)
			{
				_DRAW_LINE_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(152, 32, true);
				_DRAW_LINE_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);//programID
				_DRAW_LINE_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);//VAO ID
				_DRAW_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
				_DRAW_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
				_DRAW_LINE_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
				_DRAW_LINE_CMD_ENCODER_.setMeshByParamData(_PARAM_VB_POS_*4, _PARAM_VB_OFFSET_POS_*4, 1*4, _PARAM_IB_POS_*4, _PARAM_IB_OFFSET_POS_*4, 2*4, _PARAM_INDEX_ELEMENT_OFFSET_POS_*4);
				_DRAW_LINE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
				_DRAW_LINE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
				LayaGL.syncBufferToRenderThread( _DRAW_LINE_CMD_ENCODER_ );
			}			
			if (!cmd._paramData)
			{
				cmd._paramData = __JS__("new ParamData(24 * 4, true)");
			}
			//给参数赋值
			{
				cmd._fromX = fromX;
				cmd._fromY = fromY;
				cmd._toX = toX;
				cmd._toY = toY;
				cmd._lineColor = lineColor;
				cmd._lineWidth = lineWidth;
				cmd._vid = vid;
				
				var c1:ColorUtils = ColorUtils.create(lineColor);
				var nColor:uint = c1.numColor;
				var points:Array = [fromX, fromY, toX, toY];
				// Get vb and ib
				var vbArray:Array = new Array();
				var ibArray:Array = new Array();
				BasePoly.createLine2(points, ibArray, lineWidth, 0, vbArray, false);
				var _fb:Float32Array = cmd._paramData._float32Data;
				var _i32b:Int32Array = cmd._paramData._int32Data;
				var _i16b:Int32Array = cmd._paramData._int16Data;
				_i32b[0] = 1;
				_i32b[1] = 12 * 4;
				_i32b[2] = 6 * 2;
				_i32b[_PARAM_VB_OFFSET_POS_] = 0;
				_i32b[_PARAM_IB_OFFSET_POS_] = 0;
				_i32b[_PARAM_INDEX_ELEMENT_OFFSET_POS_] = 0;
				// Save vb
				var ix:int = _PARAM_VB_POS_;				
				_fb[ix++] = vbArray[0];  	_fb[ix++] = vbArray[1];    	_i32b[ix++] = nColor; 
				_fb[ix++] = vbArray[2]; 	_fb[ix++] = vbArray[3]; 	_i32b[ix++] = nColor;
				_fb[ix++] = vbArray[4]; 	_fb[ix++] = vbArray[5]; 	_i32b[ix++] = nColor;
				_fb[ix++] = vbArray[6];		_fb[ix++] = vbArray[7];		_i32b[ix++] = nColor;				
				var ibx:int = _PARAM_IB_POS_*2;
				// Save ib
				_i16b[ibx++] = ibArray[0];  	_i16b[ibx++] = ibArray[1];
				_i16b[ibx++] = ibArray[2];  	_i16b[ibx++] = ibArray[3];
				_i16b[ibx++] = ibArray[4];  	_i16b[ibx++] = ibArray[5];								
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
				LayaGL.syncBufferToRenderThread( cmd._paramData );
			}
			cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_LINE_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);
			LayaGL.syncBufferToRenderThread( cmd._graphicsCmdEncoder );	
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {

			Pool.recover("DrawLineCmd", this);
		}
		
		public function get cmdID():String
		{
			return ID;
		}

		public function get fromX():Number
		{
			return _fromX;
		}
		
		public function set fromX(value:Number):void
		{
			_fromX = value;
			var points:Array = [_fromX, _fromY, _toX, _toY];
			// Get vb and ib
			var vbArray:Array = new Array();
			var ibArray:Array = new Array();
			BasePoly.createLine2(points, ibArray, _lineWidth, 0, vbArray, false);
			var _fb:Float32Array = _paramData._float32Data;
			var _i32b:Int32Array = _paramData._int32Data;
			var _i16b:Int32Array = _paramData._int16Data;
			// Save vb
			var ix:int = _PARAM_VB_POS_;				
			_fb[ix++] = vbArray[0];  	_fb[ix++] = vbArray[1];    	ix++;
			_fb[ix++] = vbArray[2]; 	_fb[ix++] = vbArray[3]; 	ix++;
			_fb[ix++] = vbArray[4]; 	_fb[ix++] = vbArray[5]; 	ix++;
			_fb[ix++] = vbArray[6];		_fb[ix++] = vbArray[7];		ix++;
			var ibx:int = _PARAM_IB_POS_*2;
			// Save ib
			_i16b[ibx++] = ibArray[0];  	_i16b[ibx++] = ibArray[1];
			_i16b[ibx++] = ibArray[2];  	_i16b[ibx++] = ibArray[3];
			_i16b[ibx++] = ibArray[4];  	_i16b[ibx++] = ibArray[5];
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get fromY():Number
		{
			return _fromY;
		}		
		public function set fromY(value:Number):void
		{
			_fromY = value;
			var points:Array = [_fromX, _fromY, _toX, _toY];
			// Get vb and ib
			var vbArray:Array = new Array();
			var ibArray:Array = new Array();
			BasePoly.createLine2(points, ibArray, _lineWidth, 0, vbArray, false);
			var _fb:Float32Array = _paramData._float32Data;
			var _i32b:Int32Array = _paramData._int32Data;
			var _i16b:Int32Array = _paramData._int16Data;
			// Save vb
			var ix:int = _PARAM_VB_POS_;				
			_fb[ix++] = vbArray[0];  	_fb[ix++] = vbArray[1];    	ix++; 
			_fb[ix++] = vbArray[2]; 	_fb[ix++] = vbArray[3]; 	ix++;
			_fb[ix++] = vbArray[4]; 	_fb[ix++] = vbArray[5]; 	ix++;
			_fb[ix++] = vbArray[6];		_fb[ix++] = vbArray[7];		ix++;				
			var ibx:int = _PARAM_IB_POS_*2;
			// Save ib
			_i16b[ibx++] = ibArray[0];  	_i16b[ibx++] = ibArray[1];
			_i16b[ibx++] = ibArray[2];  	_i16b[ibx++] = ibArray[3];
			_i16b[ibx++] = ibArray[4];  	_i16b[ibx++] = ibArray[5];
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get toX():Number
		{
			return _toX;
		}
		
		public function set toX(value:Number):void
		{
			_toX = value;
			var points:Array = [_fromX, _fromY, _toX, _toY];
			// Get vb and ib
			var vbArray:Array = new Array();
			var ibArray:Array = new Array();
			BasePoly.createLine2(points, ibArray, _lineWidth, 0, vbArray, false);
			var _fb:Float32Array = _paramData._float32Data;
			var _i32b:Int32Array = _paramData._int32Data;
			var _i16b:Int32Array = _paramData._int16Data;
			// Save vb
			var ix:int = _PARAM_VB_POS_;				
			_fb[ix++] = vbArray[0];  	_fb[ix++] = vbArray[1];    	ix++;
			_fb[ix++] = vbArray[2]; 	_fb[ix++] = vbArray[3]; 	ix++;
			_fb[ix++] = vbArray[4]; 	_fb[ix++] = vbArray[5]; 	ix++;
			_fb[ix++] = vbArray[6];		_fb[ix++] = vbArray[7];		ix++;		
			var ibx:int = _PARAM_IB_POS_*2;
			// Save ib
			_i16b[ibx++] = ibArray[0];  	_i16b[ibx++] = ibArray[1];
			_i16b[ibx++] = ibArray[2];  	_i16b[ibx++] = ibArray[3];
			_i16b[ibx++] = ibArray[4];  	_i16b[ibx++] = ibArray[5];
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get toY():Number
		{
			return _toY;
		}
		
		public function set toY(value:Number):void
		{
			_toY = value;
			var points:Array = [_fromX, _fromY, _toX, _toY];
			// Get vb and ib
			var vbArray:Array = new Array();
			var ibArray:Array = new Array();
			BasePoly.createLine2(points, ibArray, _lineWidth, 0, vbArray, false);
			var _fb:Float32Array = _paramData._float32Data;
			var _i32b:Int32Array = _paramData._int32Data;
			var _i16b:Int32Array = _paramData._int16Data;
			// Save vb
			var ix:int = _PARAM_VB_POS_;				
			_fb[ix++] = vbArray[0];  	_fb[ix++] = vbArray[1];    	ix++; 
			_fb[ix++] = vbArray[2]; 	_fb[ix++] = vbArray[3]; 	ix++;
			_fb[ix++] = vbArray[4]; 	_fb[ix++] = vbArray[5]; 	ix++;
			_fb[ix++] = vbArray[6];		_fb[ix++] = vbArray[7];		ix++;			
			var ibx:int = _PARAM_IB_POS_*2;
			// Save ib
			_i16b[ibx++] = ibArray[0];  	_i16b[ibx++] = ibArray[1];
			_i16b[ibx++] = ibArray[2];  	_i16b[ibx++] = ibArray[3];
			_i16b[ibx++] = ibArray[4];  	_i16b[ibx++] = ibArray[5];
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get lineColor():String
		{
			return _lineColor;
		}
		
		public function set lineColor(value:String):void
		{
			_lineColor = value;
			var c1:ColorUtils = ColorUtils.create(lineColor);
			var nColor:uint = c1.numColor;
			var _i32b:Int32Array = _paramData._int32Data;
			var ix:int = _PARAM_VB_POS_;				
			ix++; ix++; _i32b[ix++] = nColor;
			ix++; ix++; _i32b[ix++] = nColor;
			ix++; ix++; _i32b[ix++] = nColor;
			ix++; ix++; _i32b[ix++] = nColor;
			LayaGL.syncBufferToRenderThread( _paramData );
		}
		public function get lineWidth():Number
		{
			return _lineWidth;
		}
		
		public function set lineWidth(value:Number):void
		{
			_lineWidth = value;
			var points:Array = [_fromX, _fromY, _toX, _toY];
			// Get vb and ib
			var vbArray:Array = new Array();
			var ibArray:Array = new Array();
			BasePoly.createLine2(points, ibArray, lineWidth, 0, vbArray, false);
			var _fb:Float32Array = _paramData._float32Data;
			var _i32b:Int32Array = _paramData._int32Data;
			var _i16b:Int32Array = _paramData._int16Data;
			// Save vb
			var ix:int = _PARAM_VB_POS_;				
			_fb[ix++] = vbArray[0];  	_fb[ix++] = vbArray[1];    	ix++;
			_fb[ix++] = vbArray[2]; 	_fb[ix++] = vbArray[3]; 	ix++;
			_fb[ix++] = vbArray[4]; 	_fb[ix++] = vbArray[5]; 	ix++;
			_fb[ix++] = vbArray[6];		_fb[ix++] = vbArray[7];		ix++;			
			var ibx:int = _PARAM_IB_POS_*2;
			// Save ib
			_i16b[ibx++] = ibArray[0];  	_i16b[ibx++] = ibArray[1];
			_i16b[ibx++] = ibArray[2];  	_i16b[ibx++] = ibArray[3];
			_i16b[ibx++] = ibArray[4];  	_i16b[ibx++] = ibArray[5];
			LayaGL.syncBufferToRenderThread( _paramData );
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