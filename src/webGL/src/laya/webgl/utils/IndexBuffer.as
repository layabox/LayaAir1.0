package laya.webgl.utils {
	import laya.webgl.WebGLContext;
	
	/**
	 * ...
	 * @author laya
	 */
	public class IndexBuffer extends Buffer {
		//! 全局的四边形索引缓冲区.
		public static var QuadrangleIB:IndexBuffer;
		
		public static var create:Function = function(bufferUsage:int=WebGLContext.STATIC_DRAW):IndexBuffer {
			return new IndexBuffer(bufferUsage);
		}
		
		public function IndexBuffer(bufferUsage:int=WebGLContext.STATIC_DRAW) {
			super();
			_bufferUsage = bufferUsage;
			_type = WebGLContext.ELEMENT_ARRAY_BUFFER;
		}
		
		public function getUint16Array():Uint16Array {
			return new Uint16Array(_buffer);
		}
	
	}

}