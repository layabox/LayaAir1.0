package laya.d3.graphics {
	import laya.renders.Render;
	import laya.webgl.WebGLContext;
	import laya.webgl.utils.Buffer;
	
	/**
	 * <code>IndexBuffer3D</code> 类用于创建索引缓冲。
	 */
	public class IndexBuffer3D extends Buffer {
		public static var create:Function = function(indexCount:int, bufferUsage:int = WebGLContext.STATIC_DRAW):IndexBuffer3D {
			return new IndexBuffer3D(indexCount, bufferUsage);
		}
		
		private var _uint8Array:Uint8Array;
		private var _uint16Array:Uint16Array;
		private var _indexCount:int;
		
		public function get indexCount():int {
			return _indexCount;
		}
		
		public function IndexBuffer3D(indexCount:int, bufferUsage:int = WebGLContext.STATIC_DRAW) {
			super();
			_indexCount = indexCount;
			_bufferUsage = bufferUsage;
			_type = WebGLContext.ELEMENT_ARRAY_BUFFER;
			_buffer = new ArrayBuffer(2 * indexCount);//TODO:临时
		}
		
		override protected function _bufferData():void {
			_maxsize = Math.max(_maxsize, _length);
			if (_uploadSize < _buffer.byteLength) {
				_uploadSize = _buffer.byteLength;
				
				_gl.bufferData(_type, _uploadSize, _bufferUsage);
				memorySize = _uploadSize;
			}
			_gl.bufferSubData(_type, 0, _buffer);
		}
		
		override protected function _bufferSubData(offset:int = 0, dataStart:int = 0, dataLength:int = 0):void {
			_maxsize = Math.max(_maxsize, _length);
			
			if (_uploadSize < _buffer.byteLength) {
				_uploadSize = _buffer.byteLength;
				
				_gl.bufferData(_type, _uploadSize, _bufferUsage);
				memorySize = _uploadSize;
			}
			
			if (dataStart || dataLength) {
				var subBuffer:ArrayBuffer = _buffer.slice(dataStart, dataLength);
				_gl.bufferSubData(_type, offset, subBuffer);
			} else {
				_gl.bufferSubData(_type, offset, _buffer);
			}
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
	
	}

}