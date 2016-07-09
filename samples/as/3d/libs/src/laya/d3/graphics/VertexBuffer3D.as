package laya.d3.graphics {
	import laya.renders.Render;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.utils.Buffer;
	import laya.webgl.utils.ValusArray;
	
	/**
	 * ...
	 * @author ...
	 */
	public class VertexBuffer3D extends Buffer {
		public static var create:Function = function(vertexDeclaration:VertexDeclaration, vertexCount:int, bufferUsage:int = WebGLContext.STATIC_DRAW):VertexBuffer3D {
			return new VertexBuffer3D(vertexDeclaration, vertexCount, bufferUsage);
		}
		
		private var _floatArray32:Float32Array;
		private var _vertexDeclaration:VertexDeclaration;
		private var _vertexCount:int;
		
		public function get vertexDeclaration():VertexDeclaration {
			return _vertexDeclaration;
		}
		
		public function get vertexCount():int {
			return _vertexCount;
		}
		
		public function VertexBuffer3D(vertexDeclaration:VertexDeclaration, vertexCount:int, bufferUsage:int) {
			super();
			_vertexDeclaration = vertexDeclaration;
			_vertexCount = vertexCount;
			_bufferUsage = bufferUsage;
			_type = WebGLContext.ARRAY_BUFFER;
			_buffer = new ArrayBuffer(_vertexDeclaration.vertexStride*vertexCount);
		
			getFloat32Array();
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
		
		public function getFloat32Array():Float32Array {
			return _floatArray32 || (_floatArray32 = new Float32Array(_buffer));
		}
		
		public function bind(ibBuffer:IndexBuffer3D):void {
			(ibBuffer) && (ibBuffer._bind());
			_bind();
		}
		
		public function insertData(data:Array, pos:int):void {
			var vbdata:* = getFloat32Array();
			vbdata.set(data, pos);
			_upload = true;
		}
		
		public function bind_upload(ibBuffer:IndexBuffer3D):void {
			(ibBuffer._bind_upload()) || (ibBuffer._bind());
			(_bind_upload()) || (_bind());
		}
		
		override protected function _checkArrayUse():void {
			_floatArray32 && (_floatArray32 = new Float32Array(_buffer));
		}
		
		override public function disposeCPUData():void {
			super.disposeCPUData();
			_floatArray32 = null;
		}
		
		override protected function detoryResource():void {
			//TODO:应该判定当前状态是否绑定，如绑定则disableVertexAttribArray。
			var elements:Array = _vertexDeclaration.getVertexElements();
			for (var i:int = 0; i < elements.length; i++)
				WebGL.mainContext.disableVertexAttribArray(i);
			
			super.detoryResource();
		}
	
	}

}

