package laya.d3.graphics {
	import laya.layagl.LayaGL;
	import laya.webgl.BufferStateBase;
	import laya.webgl.WebGLContext;
	import laya.webgl.utils.Buffer;
	
	/**
	 * <code>IndexBuffer3D</code> 类用于创建索引缓冲。
	 */
	public class IndexBuffer3D extends Buffer {
		/** 8位ubyte无符号索引类型。*/
		public static const INDEXTYPE_UBYTE:String = "ubyte";
		/** 16位ushort无符号索引类型。*/
		public static const INDEXTYPE_USHORT:String = "ushort";
		
		/** @private */
		private var _indexType:String;
		/** @private */
		private var _indexTypeByteCount:int;
		/** @private */
		private var _indexCount:int;
		/** @private */
		private var _canRead:Boolean;
		
		/**
		 * 获取索引类型。
		 *   @return	索引类型。
		 */
		public function get indexType():String {
			return _indexType;
		}
		
		/**
		 * 获取索引类型字节数量。
		 *   @return	索引类型字节数量。
		 */
		public function get indexTypeByteCount():int {
			return _indexTypeByteCount;
		}
		
		/**
		 * 获取索引个数。
		 *   @return	索引个数。
		 */
		public function get indexCount():int {
			return _indexCount;
		}
		
		/**
		 * 获取是否可读。
		 *   @return	是否可读。
		 */
		public function get canRead():Boolean {
			return _canRead;
		}
		
		/**
		 * 创建一个 <code>IndexBuffer3D,不建议开发者使用并用IndexBuffer3D.create()代替</code> 实例。
		 * @param	indexType 索引类型。
		 * @param	indexCount 索引个数。
		 * @param	bufferUsage IndexBuffer3D用途类型。
		 * @param	canRead 是否可读。
		 */
		public function IndexBuffer3D(indexType:String, indexCount:int, bufferUsage:int = 0x88E4/*WebGLContext.STATIC_DRAW*/, canRead:Boolean = false) {
			super();
			_indexType = indexType;
			_indexCount = indexCount;
			_bufferUsage = bufferUsage;
			_bufferType = WebGLContext.ELEMENT_ARRAY_BUFFER;
			_canRead = canRead;
			
			var byteLength:int;
			if (indexType == IndexBuffer3D.INDEXTYPE_USHORT)
				_indexTypeByteCount = 2;
			else if (indexType == IndexBuffer3D.INDEXTYPE_UBYTE)
				_indexTypeByteCount = 1;
			else
				throw new Error("unidentification index type.");
			
			byteLength = _indexTypeByteCount * indexCount;
			
			_byteLength = byteLength;
			
			var curBufSta:BufferStateBase = BufferStateBase._curBindedBufferState;
			if (curBufSta) {
				if (curBufSta._bindedIndexBuffer === this) {
					LayaGL.instance.bufferData(_bufferType, byteLength, _bufferUsage);
				} else {
					curBufSta.unBind();//避免影响VAO
					bind();
					LayaGL.instance.bufferData(_bufferType, byteLength, _bufferUsage);
					curBufSta.bind();
				}
			} else {
				bind();
				LayaGL.instance.bufferData(_bufferType, byteLength, _bufferUsage);
			}
			
			if (canRead) {
				if (indexType == IndexBuffer3D.INDEXTYPE_USHORT)
					_buffer = new Uint16Array(indexCount);
				else if (indexType == IndexBuffer3D.INDEXTYPE_UBYTE)
					_buffer = new Uint8Array(indexCount);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _bindForVAO():void {
			if (BufferStateBase._curBindedBufferState) {
				LayaGL.instance.bindBuffer(WebGLContext.ELEMENT_ARRAY_BUFFER, _glBuffer);
			} else {
				throw "IndexBuffer3D: must bind current BufferState.";
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function bind():Boolean {
			if (BufferStateBase._curBindedBufferState) {
				throw "IndexBuffer3D: must unbind current BufferState.";
			} else {
				if (_bindedIndexBuffer !== _glBuffer) {
					LayaGL.instance.bindBuffer(WebGLContext.ELEMENT_ARRAY_BUFFER, _glBuffer);
					_bindedIndexBuffer = _glBuffer;
					return true;
				} else {
					return false;
				}
			}
		}
		
		/**
		 * 设置数据。
		 * @param	data 索引数据。
		 * @param	bufferOffset 索引缓冲中的偏移。
		 * @param	dataStartIndex 索引数据的偏移。
		 * @param	dataCount 索引数据的数量。
		 */
		public function setData(data:*, bufferOffset:int = 0, dataStartIndex:int = 0, dataCount:Number = 4294967295/*uint.MAX_VALUE*/):void {
			var byteCount:int;
			if (_indexType == IndexBuffer3D.INDEXTYPE_USHORT) {
				byteCount = 2;
				if (dataStartIndex !== 0 || dataCount !== 4294967295/*uint.MAX_VALUE*/)
					data = new Uint16Array(data.buffer, dataStartIndex * byteCount, dataCount);
			} else if (_indexType == IndexBuffer3D.INDEXTYPE_UBYTE) {
				byteCount = 1;
				if (dataStartIndex !== 0 || dataCount !== 4294967295/*uint.MAX_VALUE*/)
					data = new Uint8Array(data.buffer, dataStartIndex * byteCount, dataCount);
			}
			
			var curBufSta:BufferStateBase = BufferStateBase._curBindedBufferState;
			if (curBufSta) {
				if (curBufSta._bindedIndexBuffer === this) {
					LayaGL.instance.bufferSubData(_bufferType, bufferOffset * byteCount, data);//offset==0情况下，某些特殊设备或情况下直接bufferData速度是否优于bufferSubData
				} else {
					curBufSta.unBind();//避免影响VAO
					bind();
					LayaGL.instance.bufferSubData(_bufferType, bufferOffset * byteCount, data);
					curBufSta.bind();
				}
			} else {
				bind();
				LayaGL.instance.bufferSubData(_bufferType, bufferOffset * byteCount, data);
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
		 * 获取索引数据。
		 *   @return	索引数据。
		 */
		public function getData():Uint16Array {
			if (_canRead)
				return _buffer;
			else
				throw new Error("Can't read data from VertexBuffer with only write flag!");
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void {
			super.destroy();
			_buffer = null;
		}
	
	}

}