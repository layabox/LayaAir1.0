package laya.layagl.cmdNative {
	import laya.maths.Point;
	import laya.layagl.LayaGL;
	import laya.layagl.LayaNative2D;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Pool;
	import laya.maths.Matrix;
	
	public class ClipRectCmdNative  {
		public static const ID:String = "ClipRect";
		public var _graphicsCmdEncoder:*;
		private var _paramData:* = __JS__("new ParamData(4 * 4,true)");
		
		public static function create(x:Number, y:Number, w:Number, h:Number):ClipRectCmdNative {
			var cmd:ClipRectCmdNative = Pool.getItemByClass("ClipRectCmd", ClipRectCmdNative);
			cmd._graphicsCmdEncoder = __JS__("this._commandEncoder");
			var cbuf:* = cmd._graphicsCmdEncoder;
			//数据区
			var f32:Float32Array = cmd._paramData._float32Data;
			f32[0] = x;
			f32[1] = y;
			f32[2] = w;
			f32[3] = h;
			var nDataID:int = cmd._paramData.getPtrID();
			LayaGL.syncBufferToRenderThread( cmd._paramData );
			cbuf.setClipValueEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, LayaNative2D.GLOBALVALUE_MATRIX32, nDataID);
			LayaGL.syncBufferToRenderThread( cbuf );
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			Pool.recover("ClipRectCmd", this);
		}
		
		public function get cmdID():String{
			return ID;
		}

		public function get x():Number{
			return 0;
		}
		
		public function set x(value:Number):void{
		}
		public function get y():Number{
			return 0;
		}
		
		public function set y(value:Number):void{
		}
		public function get width():Number{
			return 0;
		}
		
		public function set width(value:Number):void{
		}
		public function get height():Number{
			return 0;
		}
		
		public function set height(value:Number):void{
		}		
	}
}