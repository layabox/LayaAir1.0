package laya.webgl.utils {
	import laya.utils.Stat;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.BaseShader;
	import laya.webgl.shader.Shader;
	
	public class Buffer2D extends Buffer {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static const FLOAT32:int = 4;
		public static const SHORT:int = 2;
		
		public static function __int__(gl:WebGLContext):void {
			IndexBuffer2D.QuadrangleIB = IndexBuffer2D.create(WebGLContext.STATIC_DRAW);
			GlUtils.fillIBQuadrangle(IndexBuffer2D.QuadrangleIB, 16);
		}
		
		protected var _maxsize:int = 0;
		
		public var _upload:Boolean = true;
		protected var _uploadSize:int = 0;
		
		public function get bufferLength():int {
			return _buffer.byteLength;
		}
		
		public function set byteLength(value:int):void {
			if (_byteLength === value)
				return;
			value <= _buffer.byteLength || (_resizeBuffer(value * 2 + 256, true));
			_byteLength = value;
		}
		
		/**
		 * 在当前的基础上需要多大空间，单位是byte
		 * @param	sz
		 * @return  增加大小之前的写位置。单位是byte
		 */
		public function needSize(sz:int):int {
			var old:int = _byteLength;
			if (sz) {
				var needsz:int = _byteLength + sz;
				needsz <= _buffer.byteLength || (_resizeBuffer(needsz << 1, true));
				_byteLength = needsz;
			}
			return old;
		}		
		
		public function Buffer2D() {
			super();
			lock = true;
		}
		
		protected function _bufferData():void {
			_maxsize = Math.max(_maxsize, _byteLength);
			if (Stat.loopCount % 30 == 0) {
				if (_buffer.byteLength > (_maxsize + 64)) {
					memorySize = _buffer.byteLength;
					_buffer = _buffer.slice(0, _maxsize + 64);
					_checkArrayUse();
				}
				_maxsize = _byteLength;
			}
			if (_uploadSize < _buffer.byteLength) {
				_uploadSize = _buffer.byteLength;
				
				_gl.bufferData(_bufferType, _uploadSize, _bufferUsage);
				memorySize = _uploadSize;
			}
			_gl.bufferSubData(_bufferType, 0, _buffer);
		}
		
		protected function _bufferSubData(offset:int = 0, dataStart:int = 0, dataLength:int = 0):void {
			_maxsize = Math.max(_maxsize, _byteLength);
			if (Stat.loopCount % 30 == 0) {
				if (_buffer.byteLength > (_maxsize + 64)) {
					memorySize = _buffer.byteLength;
					_buffer = _buffer.slice(0, _maxsize + 64);
					_checkArrayUse();
				}
				_maxsize = _byteLength;
			}
			
			if (_uploadSize < _buffer.byteLength) {
				_uploadSize = _buffer.byteLength;
				
				_gl.bufferData(_bufferType, _uploadSize, _bufferUsage);
				memorySize = _uploadSize;
			}
			
			if (dataStart || dataLength) {
				var subBuffer:ArrayBuffer = _buffer.slice(dataStart, dataLength);
				_gl.bufferSubData(_bufferType, offset, subBuffer);
			} else {
				_gl.bufferSubData(_bufferType, offset, _buffer);
			}
		}
		
		protected function _checkArrayUse():void {
		}
		
		public function _bind_upload():Boolean {
			if (!_upload)
				return false;
			_upload = false;
			_bind();
			_bufferData();
			return true;
		}
		
		public function _bind_subUpload(offset:int = 0, dataStart:int = 0, dataLength:int = 0):Boolean {
			if (!_upload)
				return false;
			
			_upload = false;
			_bind();
			_bufferSubData(offset, dataStart, dataLength);
			return true;
		}
		
		public function _resizeBuffer(nsz:int, copy:Boolean):Buffer2D //是否修改了长度
		{
			if (nsz < _buffer.byteLength)
				return this;
			memorySize = nsz;
			if (copy && _buffer && _buffer.byteLength > 0) {
				var newbuffer:ArrayBuffer = new ArrayBuffer(nsz);
				var n:* = new Uint8Array(newbuffer);
				n.set(new Uint8Array(_buffer), 0);
				_buffer = newbuffer;
			} else
				_buffer = new ArrayBuffer(nsz);
			_checkArrayUse();
			_upload = true;
			
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
			for (var i:int = 0; i < len; i++) {
				u[i] = data[i];
			}
			_byteLength += len * 2;
			_checkArrayUse();
		}		
		
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
		
		
		
		public function getBuffer():ArrayBuffer {
			return _buffer;
		}
		
		public function setNeedUpload():void {
			_upload = true;
		}
		
		public function getNeedUpload():Boolean {
			return _upload;
		}
		
		public function upload():Boolean {
			var scuess:Boolean = _bind_upload();
			_gl.bindBuffer(_bufferType, null);
			_bindActive[_bufferType] = null;
			BaseShader.activeShader = null
			return scuess;
		}
		
		public function subUpload(offset:int = 0, dataStart:int = 0, dataLength:int = 0):Boolean {
			var scuess:Boolean = _bind_subUpload();
			_gl.bindBuffer(_bufferType, null);
			_bindActive[_bufferType] = null;
			BaseShader.activeShader = null
			return scuess;
		}
		
		override protected function disposeResource():void {
			super.disposeResource();
			_upload = true;
			_uploadSize = 0;
		}
		
		public function clear():void {
			_byteLength = 0;
			_upload = true;
		}
	}

}