package laya.webgl.utils {
	import laya.webgl.WebGLContext;
	
	/**
	 * ...
	 * @author laya
	 */
	public class VertexBuffer extends Buffer {
		public static var create:Function = function(bufferUsage:int = 0x88E8 /*WebGLContext.DYNAMIC_DRAW*/):VertexBuffer {
			return new VertexBuffer(bufferUsage);
		}
		
		protected var _floatArray32:Float32Array;
		
		public function VertexBuffer(bufferUsage:int) {
			super();
			_bufferUsage = bufferUsage;
			_type = WebGLContext.ARRAY_BUFFER;
			getFloat32Array();
		}
		
		public function getFloat32Array():* {
			return _floatArray32 || (_floatArray32 = new Float32Array(_buffer));
		}
		
		public function bind(ibBuffer:IndexBuffer):void {
			(ibBuffer) && (ibBuffer._bind());
			_bind();
		}
		
		public function insertData(data:Array, pos:int):void
		{
			var vbdata:* = getFloat32Array();
			vbdata.set(data, pos);
			_upload = true;
		}
		
		public function bind_upload(ibBuffer:IndexBuffer):void {
			(ibBuffer._bind_upload()) || (ibBuffer._bind());
			(_bind_upload()) || (_bind());
		}
		
		override protected function _checkFloatArray32Use():void {
			_floatArray32 && (_floatArray32 = new Float32Array(_buffer));
		}
		
		override public function disposeCPUData():void {
			super.disposeCPUData();
			_floatArray32 = null;
		}
	
	}

}