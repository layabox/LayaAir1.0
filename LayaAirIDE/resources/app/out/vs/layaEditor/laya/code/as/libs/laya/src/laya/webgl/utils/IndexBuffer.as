package laya.webgl.utils {
	import laya.webgl.WebGLContext;
	
	/**
	 * ...
	 * @author laya
	 */
	public class IndexBuffer extends Buffer {
		//! 全局的四边形索引缓冲区.
		public static var QuadrangleIB:IndexBuffer;
		
		public static var create:Function = function():IndexBuffer {
			return new IndexBuffer();
		}
		
		public function IndexBuffer() {
			super();
			_bufferUsage = 0x88E4/*WebGLContext.STATIC_DRAW*/;
			_type = WebGLContext.ELEMENT_ARRAY_BUFFER;
		}
		
		public function getUint16Array():Uint16Array {
			return new Uint16Array(_buffer);
		}
	
	}

}