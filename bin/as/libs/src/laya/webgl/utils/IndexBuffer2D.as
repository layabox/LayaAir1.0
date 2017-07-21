package laya.webgl.utils {
	import laya.renders.Render;
	import laya.webgl.WebGLContext;
	
	public class IndexBuffer2D extends Buffer2D {
		//! 全局的四边形索引缓冲区.
		public static var QuadrangleIB:IndexBuffer2D;
		
		public static var create:Function = function(bufferUsage:int = WebGLContext.STATIC_DRAW):IndexBuffer2D {
			return new IndexBuffer2D(bufferUsage);
		}
		
		protected var _uint8Array:Uint8Array;
		protected var _uint16Array:Uint16Array;
		
		public function IndexBuffer2D(bufferUsage:int = WebGLContext.STATIC_DRAW) {
			super();
			_bufferUsage = bufferUsage;
			_bufferType = WebGLContext.ELEMENT_ARRAY_BUFFER;
			Render.isFlash || (_buffer = new ArrayBuffer(8));
		}
		
		override protected function _checkArrayUse():void {
			_uint8Array && (_uint8Array = new Uint8Array(_buffer));
			_uint16Array && (_uint16Array = new Uint16Array(_buffer));
		}
		
		public function getUint8Array():Uint8Array {
			return _uint8Array || (_uint8Array = new Uint8Array(_buffer));
		}
		
		public function getUint16Array():Uint16Array {
			return _uint16Array || (_uint16Array = new Uint16Array(_buffer));
		}
		
		public function destory():void
		{
			_uint16Array = null;
			_uint8Array = null;
			_buffer = null;
		}
	
	}

}