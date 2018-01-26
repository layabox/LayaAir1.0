package laya.d3.graphics {
	import laya.renders.Render;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.utils.Buffer;
	
	/**
	 * <code>VertexBuffer3D</code> 类用于创建顶点缓冲。
	 */
	public class VertexBuffer3D extends Buffer {
		
		/**
		 * 创建VertexBuffer3D。
		 * @param	vertexDeclaration 顶点声明。
		 * @param	vertexCount 顶点个数。
		 * @param	bufferUsage VertexBuffer3D用途类型。
		 * @param	canRead 是否可读。
		 * @return	    顶点缓冲。
		 */
		public static var create:Function = function(vertexDeclaration:VertexDeclaration, vertexCount:int, bufferUsage:int = WebGLContext.STATIC_DRAW, canRead:Boolean = false):VertexBuffer3D {
			return new VertexBuffer3D(vertexDeclaration, vertexCount, bufferUsage, canRead);
		}
		
		/** @private */
		private var _vertexDeclaration:VertexDeclaration;
		/** @private */
		private var _vertexCount:int;
		/** @private */
		private var _canRead:Boolean;
		
		/**
		 * 获取顶点结构声明。
		 *   @return	顶点结构声明。
		 */
		public function get vertexDeclaration():VertexDeclaration {
			return _vertexDeclaration;
		}
		
		/**
		 * 获取顶点个数。
		 *   @return	顶点个数。
		 */
		public function get vertexCount():int {
			return _vertexCount;
		}
		
		/**
		 * 获取是否可读。
		 *   @return	是否可读。
		 */
		public function get canRead():Boolean {
			return _canRead;
		}
		
		/**
		 * 创建一个 <code>VertexBuffer3D,不建议开发者使用并用VertexBuffer3D.create()代替</code> 实例。
		 * @param	vertexDeclaration 顶点声明。
		 * @param	vertexCount 顶点个数。
		 * @param	bufferUsage VertexBuffer3D用途类型。
		 * @param	canRead 是否可读。
		 */
		public function VertexBuffer3D(vertexDeclaration:VertexDeclaration, vertexCount:int, bufferUsage:int, canRead:Boolean = false) {
			super();
			_vertexDeclaration = vertexDeclaration;
			_vertexCount = vertexCount;
			_bufferUsage = bufferUsage;
			_bufferType = WebGLContext.ARRAY_BUFFER;
			_canRead = canRead;
			
			memorySize = _byteLength = _vertexDeclaration.vertexStride * vertexCount;
			if (!Render.isConchNode) {//!NATIVE
				_bind();
				_gl.bufferData(_bufferType, _byteLength, _bufferUsage);
			}
			canRead && (_buffer = new Float32Array(_byteLength / 4));
		}
		
		/**
		 * 和索引缓冲一起绑定。
		 * @param	ib 索引缓冲。
		 */
		public function bindWithIndexBuffer(ib:IndexBuffer3D):void {
			(ib) && (ib._bind());
			_bind();
		}
		
		/**
		 * 设置数据。
		 * @param	data 顶点数据。
		 * @param	bufferOffset 顶点缓冲中的偏移。
		 * @param	dataStartIndex 顶点数据的偏移。
		 * @param	dataCount 顶点数据的数量。
		 */
		public function setData(data:Float32Array, bufferOffset:int = 0, dataStartIndex:int = 0, dataCount:uint = 4294967295/*uint.MAX_VALUE*/):void {
			if (dataStartIndex !== 0 || dataCount !== 4294967295/*uint.MAX_VALUE*/)
				data = new Float32Array(data.buffer, dataStartIndex * 4, dataCount);
			if (!Render.isConchNode) {//!NATIVE
				_bind();
				_gl.bufferSubData(_bufferType, bufferOffset * 4, data);
			}
			
			if (_canRead) {
				if (bufferOffset !== 0 || dataStartIndex !== 0 || dataCount !== 4294967295/*uint.MAX_VALUE*/) {
					var maxLength:int = _buffer.length - bufferOffset;
					if (dataCount > maxLength)
						dataCount = maxLength;
					for (var i:int = 0; i < dataCount; i++)
						_buffer[bufferOffset + i] = data[i];
				} else {
					_buffer = data;
				}
			}
		}
		
		/**
		 * 获取顶点数据。
		 *   @return	顶点数据。
		 */
		public function getData():Float32Array {
			if (_canRead)
				return _buffer;
			else
				throw new Error("Can't read data from VertexBuffer with only write flag!");
		}
		
		/** 销毁顶点缓冲。*/
		override protected function disposeResource():void {
			var gl:WebGLContext = WebGL.mainContext;
			var elements:Array = _vertexDeclaration.getVertexElements();
			var enableAtributes:Array = Buffer._enableAtributes;
			for (var i:int = 0, n:int = elements.length; i < n; i++) {
				if (enableAtributes[i] === _glBuffer) {
					gl.disableVertexAttribArray(i);
					enableAtributes[i] = null;
				}
			}
			super.disposeResource();
			_buffer = null;
			_vertexDeclaration = null;
			memorySize = 0;
		}
	}

}

