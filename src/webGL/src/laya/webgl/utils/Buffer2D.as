package laya.webgl.utils {
	import laya.layagl.LayaGL;
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.BaseShader;
	import laya.webgl.shader.Shader;
	
	public class Buffer2D extends Buffer {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static const FLOAT32:int = 4;
		public static const SHORT:int = 2;
		
		public static function __int__(gl:WebGLContext):void {
		}
		
		protected var _maxsize:int = 0;
		
		public var _upload:Boolean = true;
		protected var _uploadSize:int = 0;
		protected var _bufferSize:int = 0;
		protected var _u8Array:Uint8Array = null;		//反正常常要拷贝老的数据，所以保留这个可以提高效率
		
		public function get bufferLength():int {
			return _buffer.byteLength;
		}
		
		public function set byteLength(value:int):void {
			setByteLength(value);
		}
		
		public function setByteLength(value:int):void {
			if (_byteLength !== value)
			{
				value <= _bufferSize || (_resizeBuffer(value * 2 + 256, true));
				_byteLength = value;
			}
		}
		
		/**
		 * 在当前的基础上需要多大空间，单位是byte
		 * @param	sz
		 * @return  增加大小之前的写位置。单位是byte
		 */
		public function needSize(sz:int):int {
			var old:int = _byteLength;
			if (sz) {
				var needsz:Number = _byteLength + sz;
				needsz <= _bufferSize || (_resizeBuffer(needsz << 1, true));
				_byteLength = needsz;
			}
			return old;
		}
		
		public function Buffer2D() {
			super();
		}
		
		protected function _bufferData():void {
			_maxsize = Math.max(_maxsize, _byteLength);
			if (Stat.loopCount % 30 == 0) {//每30帧缩小一下buffer	。TODO 这个有问题。不知道_maxsize和_byteLength是怎么维护的，这里会导致重新分配64字节
				if (_buffer.byteLength > (_maxsize + 64)) {
					//_setGPUMemory(_buffer.byteLength);
					_buffer = _buffer.slice(0, _maxsize + 64);
					_bufferSize = _buffer.byteLength;
					_checkArrayUse();
				}
				_maxsize = _byteLength;
			}
			if (_uploadSize < _buffer.byteLength) {
				_uploadSize = _buffer.byteLength;
				
				LayaGL.instance.bufferData(_bufferType, _uploadSize, _bufferUsage);
				//_setGPUMemory(_uploadSize);
			}
			LayaGL.instance.bufferSubData(_bufferType, 0, _buffer);
		}
		
		//TODO:coverage
		protected function _bufferSubData(offset:int = 0, dataStart:int = 0, dataLength:int = 0):void {
			_maxsize = Math.max(_maxsize, _byteLength);
			if (Stat.loopCount % 30 == 0) {
				if (_buffer.byteLength > (_maxsize + 64)) {
					//_setGPUMemory(_buffer.byteLength);
					_buffer = _buffer.slice(0, _maxsize + 64);
					_bufferSize = _buffer.byteLength;
					_checkArrayUse();
				}
				_maxsize = _byteLength;
			}
			
			if (_uploadSize < _buffer.byteLength) {
				_uploadSize = _buffer.byteLength;
				LayaGL.instance.bufferData(_bufferType, _uploadSize, _bufferUsage);
				//_setGPUMemory(_uploadSize);
			}
			
			if (dataStart || dataLength) {
				var subBuffer:ArrayBuffer = _buffer.slice(dataStart, dataLength);
				LayaGL.instance.bufferSubData(_bufferType, offset, subBuffer);
			} else {
				LayaGL.instance.bufferSubData(_bufferType, offset, _buffer);
			}
		}
		
		/**
		 * buffer重新分配了，继承类根据需要做相应的处理。
		 */
		protected function _checkArrayUse():void {
		}

		/**
		 * 给vao使用的 _bind_upload函数。不要与已经绑定的判断是否相同
		 * @return
		 */
		public function _bind_uploadForVAO():Boolean {
			if (!_upload)
				return false;
			_upload = false;
			_bindForVAO();
			_bufferData();
			return true;
		}
		
		public function _bind_upload():Boolean {
			if (!_upload)
				return false;
			_upload = false;
			bind();
			_bufferData();
			return true;
		}
		
		//TODO:coverage
		public function _bind_subUpload(offset:int = 0, dataStart:int = 0, dataLength:int = 0):Boolean {
			if (!_upload)
				return false;
			
			_upload = false;
			bind();
			_bufferSubData(offset, dataStart, dataLength);
			return true;
		}
		
		/**
		 * 重新分配buffer大小，如果nsz比原来的小则什么都不做。
		 * @param	nsz		buffer大小，单位是byte。
		 * @param	copy	是否拷贝原来的buffer的数据。
		 * @return
		 */
		public function _resizeBuffer(nsz:int, copy:Boolean):Buffer2D //是否修改了长度
		{
			var buff:* = _buffer;
			if (nsz <= buff.byteLength)
				return this;
			var u8buf:Uint8Array = _u8Array;
			//_setGPUMemory(nsz);
			if (copy && buff && buff.byteLength > 0) {
				var newbuffer:ArrayBuffer = new ArrayBuffer(nsz);
				var oldU8Arr:Uint8Array = (u8buf && u8buf.buffer == buff)?u8buf : new Uint8Array(buff);
				u8buf = _u8Array = new Uint8Array(newbuffer);
				u8buf.set(oldU8Arr, 0);
				buff = _buffer = newbuffer;
			} else{
				buff = _buffer = new ArrayBuffer(nsz);
				_u8Array = null;
			}
			_checkArrayUse();
			_upload = true;
			_bufferSize = buff.byteLength;
			return this;
		}
		
		public function append(data:*):void {
			_upload = true;
			var byteLen:int, n:*;
			byteLen = data.byteLength;
			if (data is Uint8Array) {
				_resizeBuffer(_byteLength + byteLen, true);
				n = new Uint8Array(_buffer, _byteLength);
			} else if (data is Uint16Array) {
				_resizeBuffer(_byteLength + byteLen, true);
				n = new Uint16Array(_buffer, _byteLength);
			} else if (data is Float32Array) {
				_resizeBuffer(_byteLength + byteLen, true);
				n = new Float32Array(_buffer, _byteLength);
			}
			n.set(data, 0);
			_byteLength += byteLen;
			_checkArrayUse();
		}
		
		/**
		 * 附加Uint16Array的数据。数据长度是len。byte的话要*2
		 * @param	data
		 * @param	len
		 */
		public function appendU16Array(data:Uint16Array, len:int):void {
			_resizeBuffer(_byteLength + len*2, true);
			//(new Uint16Array(_buffer, _byteLength, len)).set(data.slice(0, len));
			//下面这种写法比上面的快多了
			var u:Uint16Array = new Uint16Array(_buffer, _byteLength, len);	//TODO 怎么能不用new
			if ( len == 6) {
				u[0] = data[0]; u[1] = data[1]; u[2] = data[2];
				u[3] = data[3]; u[4] = data[4]; u[5] = data[5];
			}else if(len>=100){
				__JS__('u.set(new Uint16Array(data.buffer, 0, len));')
			}else{
				for (var i:int = 0; i < len; i++) {
					u[i] = data[i];
				}
			}
			_byteLength += len * 2;
			_checkArrayUse();
		}
		
		//TODO:coverage
		public function appendEx(data:*,type:Class):void {
			_upload = true;
			var byteLen:int, n:*;
			byteLen = data.byteLength;
			_resizeBuffer(_byteLength + byteLen, true);
			n = new type(_buffer, _byteLength);
			n.set(data, 0);
			_byteLength += byteLen;
			_checkArrayUse();
		}
		
		//TODO:coverage
		public function appendEx2(data:*,type:Class,dataLen:int,perDataLen:int=1):void {
			_upload = true;
			var byteLen:int, n:*;
			byteLen =dataLen*perDataLen;
			_resizeBuffer(_byteLength + byteLen, true);
			n = new type(_buffer, _byteLength);
			var i:int;
			for (i = 0; i < dataLen;i++ )
			{
				n[i] = data[i];
			}
			_byteLength += byteLen;
			_checkArrayUse();
		}
		
		
		//TODO:coverage
		public function getBuffer():ArrayBuffer {
			return _buffer;
		}
		
		public function setNeedUpload():void {
			_upload = true;
		}
		
		//TODO:coverage
		public function getNeedUpload():Boolean {
			return _upload;
		}
		
		//TODO:coverage
		public function upload():Boolean {
			var scuess:Boolean = _bind_upload();
			LayaGL.instance.bindBuffer(_bufferType, null);
			if(_bufferType == WebGLContext.ARRAY_BUFFER )_bindedVertexBuffer = null;
			if(_bufferType == WebGLContext.ELEMENT_ARRAY_BUFFER ) _bindedIndexBuffer = null;
			BaseShader.activeShader = null
			return scuess;
		}
		
		//TODO:coverage
		public function subUpload(offset:int = 0, dataStart:int = 0, dataLength:int = 0):Boolean {
			var scuess:Boolean = _bind_subUpload();
			LayaGL.instance.bindBuffer(_bufferType, null);
			if(_bufferType == WebGLContext.ARRAY_BUFFER )_bindedVertexBuffer = null;
			if(_bufferType == WebGLContext.ELEMENT_ARRAY_BUFFER ) _bindedIndexBuffer = null;
			BaseShader.activeShader = null
			return scuess;
		}
		
		 protected function _disposeResource():void {
			_upload = true;
			_uploadSize = 0;
		}
		
		
		/**
		 * 清理数据。保留ArrayBuffer
		 */
		public function clear():void {
			_byteLength = 0;
			_upload = true;
		}
	}

}