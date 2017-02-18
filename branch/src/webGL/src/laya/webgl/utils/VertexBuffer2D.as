package laya.webgl.utils {
	import laya.renders.Render;
	import laya.renders.Render;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	public class VertexBuffer2D extends Buffer2D {
		public static var create:Function = function(vertexStride:int, bufferUsage:int = WebGLContext.DYNAMIC_DRAW):VertexBuffer2D {
			return new VertexBuffer2D(vertexStride, bufferUsage);
		}
		
		protected var _floatArray32:Float32Array;
		
		private var _vertexStride:int;
		
		public function get vertexStride():int {
			return _vertexStride;
		}
		
		public function VertexBuffer2D(vertexStride:int, bufferUsage:int) {
			super();
			_vertexStride = vertexStride;
			_bufferUsage = bufferUsage;
			_bufferType = WebGLContext.ARRAY_BUFFER;
			Render.isFlash || (_buffer = new ArrayBuffer(8));
			getFloat32Array();
		}
		
		public function getFloat32Array():* {
			return _floatArray32 || (_floatArray32 = new Float32Array(_buffer));
		}
		
		public function bind(ibBuffer:IndexBuffer2D):void {
			(ibBuffer) && (ibBuffer._bind());
			_bind();
		}
		
		public function insertData(data:Array, pos:int):void {
			var vbdata:* = getFloat32Array();
			vbdata.set(data, pos);
			_upload = true;
		}
		
		public function bind_upload(ibBuffer:IndexBuffer2D):void {
			(ibBuffer._bind_upload()) || (ibBuffer._bind());
			(_bind_upload()) || (_bind());
		}
		
		override protected function _checkArrayUse():void {
			_floatArray32 && (_floatArray32 = new Float32Array(_buffer));
		}
		
		override protected function detoryResource():void {
			super.detoryResource();
			//if (_glBuffer) {
			for (var i:int = 0; i < 10; i++)
				WebGL.mainContext.disableVertexAttribArray(i);//临时修复警告和闪屏
			//}
		}
	
	}

}