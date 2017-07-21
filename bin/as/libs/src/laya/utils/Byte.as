package laya.utils {
	
	import laya.maths.Matrix;
	
	/**
	 * <p> <code>Byte</code> 类提供用于优化读取、写入以及处理二进制数据的方法和属性。</p>
	 * <p><b>注意：</b> <code>Byte</code> 类适用于需要在字节层访问数据的高级开发人员。</p>
	 */
	public class Byte {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**
		 * <p>主机字节序，是 CPU 存放数据的两种不同顺序，包括小端字节序和大端字节序。通过 <code>getSystemEndian</code> 可以获取当前系统的字节序。</p>
		 * <p> <code>BIG_ENDIAN</code> ：大端字节序，地址低位存储值的高位，地址高位存储值的低位。有时也称之为网络字节序。<br/>
		 *  <code>LITTLE_ENDIAN</code> ：小端字节序，地址低位存储值的低位，地址高位存储值的高位。</p>
		 */
		public static const BIG_ENDIAN:String = "bigEndian";
		/**
		 * <p>主机字节序，是 CPU 存放数据的两种不同顺序，包括小端字节序和大端字节序。通过 <code>getSystemEndian</code> 可以获取当前系统的字节序。</p>
		 * <p> <code>LITTLE_ENDIAN</code> ：小端字节序，地址低位存储值的低位，地址高位存储值的高位。<br/>
		 *  <code>BIG_ENDIAN</code> ：大端字节序，地址低位存储值的高位，地址高位存储值的低位。有时也称之为网络字节序。</p>
		 */
		public static const LITTLE_ENDIAN:String = "littleEndian";
		/**
		 * @private
		 * 是否为小端数据。
		 */
		protected var _xd_:Boolean = true;
		private var _allocated_:int = 8;
		/**
		 * @private
		 * 原始数据。
		 */
		protected var _d_:*
		/**
		 * @private
		 * DataView
		 */
		protected var _u8d_:*;
		/**@private */
		protected var _pos_:int = 0;
		/**@private */
		protected var _length:int = 0;
		/**@private */
		private static var _sysEndian:String = null;
		
		/**
		 * <p>获取当前主机的字节序。</p>
		 * <p>主机字节序，是 CPU 存放数据的两种不同顺序，包括小端字节序和大端字节序。</p>
		 * <p> <code>BIG_ENDIAN</code> ：大端字节序，地址低位存储值的高位，地址高位存储值的低位。有时也称之为网络字节序。<br/>
		 *  <code>LITTLE_ENDIAN</code> ：小端字节序，地址低位存储值的低位，地址高位存储值的高位。</p>
		 * @return 当前系统的字节序。
		 */
		public static function getSystemEndian():String {
			if (!_sysEndian) {
				var buffer:* = new ArrayBuffer(2);
				new DataView(buffer).setInt16(0, 256, true);
				_sysEndian = (new Int16Array(buffer))[0] === 256 ? Byte.LITTLE_ENDIAN : Byte.BIG_ENDIAN;
			}
			return _sysEndian;
		}
		
		/**
		 * 创建一个 <code>Byte</code> 类的实例。
		 * @param	data	用于指定初始化的元素数目，或者用于初始化的TypedArray对象、ArrayBuffer对象。如果为 null ，则预分配一定的内存空间，当可用空间不足时，优先使用这部分内存，如果还不够，则重新分配所需内存。
		 */
		public function Byte(data:* = null) {
			if (data) {
				this._u8d_ = new Uint8Array(data);
				this._d_ = new DataView(this._u8d_.buffer);
				_length = this._d_.byteLength;
			} else {
				this.___resizeBuffer(this._allocated_);
			}
		}
		
		/**
		 * 获取此对象的 ArrayBuffer 数据，数据只包含有效数据部分。
		 */
		public function get buffer():ArrayBuffer {
			var rstBuffer:ArrayBuffer = this._d_.buffer;
			if (rstBuffer.byteLength == this.length) return rstBuffer;
			return rstBuffer.slice(0, this.length);
		}
		
		/**
		 * <p> <code>Byte</code> 实例的字节序。取值为：<code>BIG_ENDIAN</code> 或 <code>BIG_ENDIAN</code> 。</p>
		 * <p>主机字节序，是 CPU 存放数据的两种不同顺序，包括小端字节序和大端字节序。通过 <code>getSystemEndian</code> 可以获取当前系统的字节序。</p>
		 * <p> <code>BIG_ENDIAN</code> ：大端字节序，地址低位存储值的高位，地址高位存储值的低位。有时也称之为网络字节序。<br/>
		 *  <code>LITTLE_ENDIAN</code> ：小端字节序，地址低位存储值的低位，地址高位存储值的高位。</p>
		 */
		public function get endian():String {
			return _xd_ ? LITTLE_ENDIAN : BIG_ENDIAN;
		}
		
		public function set endian(endianStr:String):void {
			_xd_ = (endianStr == LITTLE_ENDIAN);
		}
		
		/**
		 * <p> <code>Byte</code> 对象的长度（以字节为单位）。</p>
		 * <p>如果将长度设置为大于当前长度的值，则用零填充字节数组的右侧；如果将长度设置为小于当前长度的值，将会截断该字节数组。</p>
		 * <p>如果要设置的长度大于当前已分配的内存空间的字节长度，则重新分配内存空间，大小为以下两者较大者：要设置的长度、当前已分配的长度的2倍，并将原有数据拷贝到新的内存空间中；如果要设置的长度小于当前已分配的内存空间的字节长度，也会重新分配内存空间，大小为要设置的长度，并将原有数据从头截断为要设置的长度存入新的内存空间中。</p>
		 */
		public function set length(value:int):void {
			if (_allocated_ < value)
				___resizeBuffer(_allocated_ = Math.floor(Math.max(value, _allocated_ * 2)));
			else if (_allocated_ > value)
				___resizeBuffer(_allocated_ = value);
			_length = value;
		}
		
		public function get length():int {
			return _length;
		}
		
		/** @private */
		private function ___resizeBuffer(len:int):void {
			try {
				var newByteView:* = new Uint8Array(len);
				if (_u8d_ != null) {
					//[IF-JS]if (_u8d_.length <= len) newByteView.set(_u8d_);
					//[IF-JS]else newByteView.set(_u8d_.subarray(0, len));
					/*[IF-FLASH]*/
					if (_u8d_.length <= len) newByteView.setarr(_u8d_);
					/*[IF-FLASH]*/
					else newByteView.setarr(_u8d_.subarray(0, len));
				}
				this._u8d_ = newByteView;
				this._d_ = new DataView(newByteView.buffer);
			} catch (err:*) {
				throw "___resizeBuffer err:" + len;
			}
		}
		
		/**
		 * <p>常用于解析固定格式的字节流。</p>
		 * <p>先从字节流的当前字节偏移位置处读取一个 <code>Uint16</code> 值，然后以此值为长度，读取此长度的字符串。</p>
		 * @return 读取的字符串。
		 */
		public function getString():String {
			return rUTF(getUint16());
		}
		
		//LITTLE_ENDIAN only now;
		/**
		 * 从字节流中 <code>start</code> 参数指定的位置开始，读取 <code>len</code> 参数指定的字节数的数据，用于创建一个 <code>Float32Array</code> 对象并返回此对象。
		 * @param	start	开始位置。
		 * @param	len		需要读取的字节长度。如果要读取的长度超过可读取范围，则只返回可读范围内的值。
		 * @return  读取的 Float32Array 对象。
		 */
		public function getFloat32Array(start:int, len:int):* {
			var end:int = start + len;
			end = (end > _length) ? _length : end;
			var v:* = new Float32Array(this._d_.buffer.slice(start, end));
			_pos_ = end;
			return v;
		}
		
		/**
		 * 从字节流中 <code>start</code> 参数指定的位置开始，读取 <code>len</code> 参数指定的字节数的数据，用于创建一个 <code>Uint8Array</code> 对象并返回此对象。
		 * @param	start	开始位置。
		 * @param	len		需要读取的字节长度。如果要读取的长度超过可读取范围，则只返回可读范围内的值。
		 * @return  读取的 Uint8Array 对象。
		 */
		public function getUint8Array(start:int, len:int):Uint8Array {
			var end:int = start + len;
			end = (end > _length) ? _length : end;
			var v:* = new Uint8Array(this._d_.buffer.slice(start, end));
			_pos_ = end;
			return v;
		}
		
		/**
		 * 从字节流中 <code>start</code> 参数指定的位置开始，读取 <code>len</code> 参数指定的字节数的数据，用于创建一个 <code>Int16Array</code> 对象并返回此对象。
		 * @param	start	开始读取的字节偏移量位置。
		 * @param	len		需要读取的字节长度。如果要读取的长度超过可读取范围，则只返回可读范围内的值。
		 * @return  读取的 Uint8Array 对象。
		 */
		public function getInt16Array(start:int, len:int):* {
			var end:int = start + len;
			end = (end > _length) ? _length : end;
			var v:* = new Int16Array(this._d_.buffer.slice(start, end));
			_pos_ = end;
			return v;
		}
		
		/**
		 * 从字节流的当前字节偏移位置处读取一个 IEEE 754 单精度（32 位）浮点数。
		 * @return 单精度（32 位）浮点数。
		 */
		public function getFloat32():Number {
			if (_pos_ + 4 > _length) throw "getFloat32 error - Out of bounds";
			var v:Number = _d_.getFloat32(_pos_, _xd_);
			_pos_ += 4;
			return v;
		}
		
		/**
		 * 从字节流的当前字节偏移量位置处读取一个 IEEE 754 双精度（64 位）浮点数。
		 * @return 双精度（64 位）浮点数。
		 */
		public function getFloat64():Number {
			if (_pos_ + 8 > _length) throw "getFloat64 error - Out of bounds";
			var v:Number = _d_.getFloat64(_pos_, _xd_);
			_pos_ += 8;
			return v;
		}
		
		/**
		 * 在字节流的当前字节偏移量位置处写入一个 IEEE 754 单精度（32 位）浮点数。
		 * @param	value	单精度（32 位）浮点数。
		 */
		public function writeFloat32(value:Number):void {
			ensureWrite(this._pos_ + 4);
			_d_.setFloat32(_pos_, value, _xd_);
			_pos_ += 4;
		}
		
		/**
		 * 在字节流的当前字节偏移量位置处写入一个 IEEE 754 双精度（64 位）浮点数。
		 * @param	value	双精度（64 位）浮点数。
		 */
		public function writeFloat64(value:Number):void {
			ensureWrite(this._pos_ + 8);
			_d_.setFloat64(_pos_, value, _xd_);
			_pos_ += 8;
		}
		
		/**
		 * 从字节流的当前字节偏移量位置处读取一个 Int32 值。
		 * @return Int32 值。
		 */
		public function getInt32():int {
			if (_pos_ + 4 > _length) throw "getInt32 error - Out of bounds";
			var float:Number = _d_.getInt32(_pos_, _xd_);
			_pos_ += 4;
			return float;
		}
		
		/**
		 * 从字节流的当前字节偏移量位置处读取一个 Uint32 值。
		 * @return Uint32 值。
		 */
		public function getUint32():uint {
			if (_pos_ + 4 > _length) throw "getUint32 error - Out of bounds";
			var v:Number = _d_.getUint32(_pos_, _xd_);
			_pos_ += 4;
			return v;
		}
		
		/**
		 * 在字节流的当前字节偏移量位置处写入指定的 Int32 值。
		 * @param	value	需要写入的 Int32 值。
		 */
		public function writeInt32(value:int):void {
			ensureWrite(this._pos_ + 4);
			_d_.setInt32(_pos_, value, _xd_);
			_pos_ += 4;
		}
		
		/**
		 * 在字节流的当前字节偏移量位置处写入 Uint32 值。
		 * @param	value	需要写入的 Uint32 值。
		 */
		public function writeUint32(value:int):void {
			ensureWrite(this._pos_ + 4);
			_d_.setUint32(_pos_, value, _xd_);
			_pos_ += 4;
		}
		
		/**
		 * 从字节流的当前字节偏移量位置处读取一个 Int16 值。
		 * @return Int16 值。
		 */
		public function getInt16():int {
			if (_pos_ + 2 > _length) throw "getInt16 error - Out of bounds";
			var us:int = _d_.getInt16(this._pos_, _xd_);
			this._pos_ += 2;
			return us;
		}
		
		/**
		 * 从字节流的当前字节偏移量位置处读取一个 Uint16 值。
		 * @return Uint16 值。
		 */
		public function getUint16():uint {
			if (_pos_ + 2 > _length) throw "getUint16 error - Out of bounds";
			var us:int = _d_.getUint16(this._pos_, _xd_);
			this._pos_ += 2;
			return us;
		}
		
		/**
		 * 在字节流的当前字节偏移量位置处写入指定的 Uint16 值。
		 * @param	value	需要写入的Uint16 值。
		 */
		public function writeUint16(value:int):void {
			ensureWrite(this._pos_ + 2);
			_d_.setUint16(_pos_, value, _xd_);
			_pos_ += 2;
		}
		
		/**
		 * 在字节流的当前字节偏移量位置处写入指定的 Int16 值。
		 * @param	value	需要写入的 Int16 值。
		 */
		public function writeInt16(value:int):void {
			ensureWrite(this._pos_ + 2);
			_d_.setInt16(_pos_, value, _xd_);
			_pos_ += 2;
		}
		
		/**
		 * 从字节流的当前字节偏移量位置处读取一个 Uint8 值。
		 * @return Uint8 值。
		 */
		public function getUint8():uint {
			if (_pos_ + 1 > _length) throw "getUint8 error - Out of bounds";
			return _d_.getUint8(_pos_++);
		}
		
		/**
		 * 在字节流的当前字节偏移量位置处写入指定的 Uint8 值。
		 * @param	value	需要写入的 Uint8 值。
		 */
		public function writeUint8(value:int):void {
			ensureWrite(this._pos_ + 1);
			_d_.setUint8(_pos_, value);
			_pos_++;
		}
		
		/**
		 * @private
		 * 从字节流的指定字节偏移量位置处读取一个 Uint8 值。
		 * @param	pos	字节读取位置。
		 * @return Uint8 值。
		 */
		public function _getUInt8(pos:int):int {
			return _d_.getUint8(pos);
		}
		
		/**
		 * @private
		 * 从字节流的指定字节偏移量位置处读取一个 Uint16 值。
		 * @param	pos	字节读取位置。
		 * @return Uint16 值。
		 */
		public function _getUint16(pos:int):int {
			return _d_.getUint16(pos, _xd_);
		}
		
		/**
		 * @private
		 * 使用 getFloat32() 读取6个值，用于创建并返回一个 Matrix 对象。
		 * @return  Matrix 对象。
		 */
		public function _getMatrix():Matrix {
			var rst:Matrix = new Matrix(getFloat32(), getFloat32(), getFloat32(), getFloat32(), getFloat32(), getFloat32());
			return rst;
		}
		
		/**
		 * @private
		 * 读取指定长度的 UTF 型字符串。
		 * @param	len 需要读取的长度。
		 * @return 读取的字符串。
		 */
		private function rUTF(len:int):String {
			var v:String = "", max:int = this._pos_ + len, c:int, c2:int, c3:int, f:Function = String.fromCharCode;
			var u:* = this._u8d_, i:int = 0;
			while (_pos_ < max) {
				c = u[_pos_++];
				if (c < 0x80) {
					if (c != 0) {
						v += f(c);
					}
				} else if (c < 0xE0) {
					v += f(((c & 0x3F) << 6) | (u[_pos_++] & 0x7F));
				} else if (c < 0xF0) {
					c2 = u[_pos_++];
					v += f(((c & 0x1F) << 12) | ((c2 & 0x7F) << 6) | (u[_pos_++] & 0x7F));
				} else {
					c2 = u[_pos_++];
					c3 = u[_pos_++];
					v += f(((c & 0x0F) << 18) | ((c2 & 0x7F) << 12) | ((c3 << 6) & 0x7F) | (u[_pos_++] & 0x7F));
				}
				i++;
			}
			return v;
		}
		
		// River: 自定义的字符串读取,项目相关的内容
		/**
		 * @private
		 * 读取 <code>len</code> 参数指定的长度的字符串。
		 * @param	len	要读取的字符串的长度。
		 * @return 指定长度的字符串。
		 */
		public function getCustomString(len:int):String {
			var v:String = "", ulen:int = 0, c:int, c2:int, f:Function = String.fromCharCode;
			var u:* = this._u8d_, i:int = 0;
			while (len > 0) {
				c = u[this._pos_];
				if (c < 0x80) {
					v += f(c);
					this._pos_++;
					len--;
				} else {
					ulen = c - 0x80;
					this._pos_++;
					len -= ulen;
					while (ulen > 0) {
						c = u[_pos_++];
						c2 = u[_pos_++];
						v += f((c2 << 8) | c);
						ulen--;
					}
				}
			}
			
			return v;
		}
		
		/**
		 * 移动或返回 Byte 对象的读写指针的当前位置（以字节为单位）。下一次调用读取方法时将在此位置开始读取，或者下一次调用写入方法时将在此位置开始写入。
		 */
		public function get pos():int {
			return _pos_;
		}
		
		public function set pos(value:int):void {
			_pos_ = value;
			//$MOD byteOffset是只读的，这里进行赋值没有意义。
			//_d_.byteOffset = value;
		}
		
		/**
		 * 可从字节流的当前位置到末尾读取的数据的字节数。
		 */
		public function get bytesAvailable():int {
			return _length - _pos_;
		}
		
		/**
		 * 清除字节数组的内容，并将 length 和 pos 属性重置为 0。调用此方法将释放 Byte 实例占用的内存。
		 */
		public function clear():void {
			_pos_ = 0;
			length = 0;
		}
		
		/**
		 * @private
		 * 获取此对象的 ArrayBuffer 引用。
		 * @return
		 */
		public function __getBuffer():ArrayBuffer {
			//this._d_.buffer.byteLength = this.length;
			return _d_.buffer;
		}
		
		/**
		 * <p>将 UTF-8 字符串写入字节流。类似于 writeUTF() 方法，但 writeUTFBytes() 不使用 16 位长度的字为字符串添加前缀。</p>
		 * <p>对应的读取方法为： getUTFBytes 。</p>
		 * @param value 要写入的字符串。
		 */
		public function writeUTFBytes(value:String):void {
			// utf8-decode
			value = value + "";
			for (var i:int = 0, sz:int = value.length; i < sz; i++) {
				var c:int = value.charCodeAt(i);
				
				if (c <= 0x7F) {
					writeByte(c);
				} else if (c <= 0x7FF) {
					//优化为直接写入多个字节，而不必重复调用writeByte，免去额外的调用和逻辑开销。
					ensureWrite(this._pos_ + 2);
					this._u8d_.set([0xC0 | (c >> 6), 0x80 | (c & 0x3F)], _pos_);
					this._pos_ += 2;
				} else if (c <= 0xFFFF) {
					ensureWrite(this._pos_ + 3);
					this._u8d_.set([0xE0 | (c >> 12), 0x80 | ((c >> 6) & 0x3F), 0x80 | (c & 0x3F)], _pos_);
					this._pos_ += 3;
				} else {
					ensureWrite(this._pos_ + 4);
					this._u8d_.set([0xF0 | (c >> 18), 0x80 | ((c >> 12) & 0x3F), 0x80 | ((c >> 6) & 0x3F), 0x80 | (c & 0x3F)], _pos_);
					this._pos_ += 4;
				}
			}
		}
		
		/**
		 * <p>将 UTF-8 字符串写入字节流。先写入以字节表示的 UTF-8 字符串长度（作为 16 位整数），然后写入表示字符串字符的字节。</p>
		 * <p>对应的读取方法为： getUTFString 。</p>
		 * @param	value 要写入的字符串值。
		 */
		public function writeUTFString(value:String):void {
			var tPos:int = pos;
			writeUint16(1);
			writeUTFBytes(value);
			var dPos:int = pos - tPos - 2;
			//trace("writeLen:",dPos,"pos:",tPos);
			if (dPos >= 65536)
			{
				throw "writeUTFString byte len more than 65536";
			}
			_d_.setUint16(tPos, dPos, _xd_);
		}
		
		/**
		 * @private
		 * 读取 UTF-8 字符串。
		 * @return 读取的字符串。
		 */
		public function readUTFString():String {
			//var tPos:int = pos;
			//var len:int = getUint16();
			////trace("readLen:"+len,"pos,",tPos);
			return readUTFBytes(getUint16());
		}
		
		/**
		 * <p>从字节流中读取一个 UTF-8 字符串。假定字符串的前缀是一个无符号的短整型（以此字节表示要读取的长度）。</p>
		 * <p>对应的写入方法为： writeUTFString 。</p>
		 * @return 读取的字符串。
		 */
		public function getUTFString():String {
			return readUTFString();
		}
		
		/**
		 * @private
		 * 读字符串，必须是 writeUTFBytes 方法写入的字符串。
		 * @param len	要读的buffer长度，默认将读取缓冲区全部数据。
		 * @return 读取的字符串。
		 */
		public function readUTFBytes(len:int = -1):String {
			if (len == 0) return "";
			var lastBytes:int = bytesAvailable;
			if (len > lastBytes) throw "readUTFBytes error - Out of bounds";
			len = len > 0 ? len : lastBytes;
			return rUTF(len);
		}
		
		/**
		 * <p>从字节流中读取一个由 length 参数指定的长度的 UTF-8 字节序列，并返回一个字符串。</p>
		 * <p>一般读取的是由 writeUTFBytes 方法写入的字符串。</p>
		 * @param len	要读的buffer长度，默认将读取缓冲区全部数据。
		 * @return 读取的字符串。
		 */
		public function getUTFBytes(len:int = -1):String {
			return readUTFBytes(len);
		}
		
		/**
		 * <p>在字节流中写入一个字节。</p>
		 * <p>使用参数的低 8 位。忽略高 24 位。</p>
		 * @param	value
		 */
		public function writeByte(value:int):void {
			ensureWrite(this._pos_ + 1);
			_d_.setInt8(this._pos_, value);
			this._pos_ += 1;
		}
		
		/**
		 * @private
		 * 从字节流中读取带符号的字节。
		 */
		public function readByte():int {
			if (_pos_ + 1 > _length) throw "readByte error - Out of bounds";
			return _d_.getInt8(_pos_++);
		}
		
		/**
		 * <p>从字节流中读取带符号的字节。</p>
		 * <p>返回值的范围是从 -128 到 127。</p>
		 * @return 介于 -128 和 127 之间的整数。
		 */
		public function getByte():int {
			return readByte();
		}
		
		/**
		 * <p>保证该字节流的可用长度不小于 <code>lengthToEnsure</code> 参数指定的值。</p>
		 * @param	lengthToEnsure	指定的长度。
		 */
		public function ensureWrite(lengthToEnsure:int):void {
			if (this._length < lengthToEnsure) this._length = lengthToEnsure;
			if (this._allocated_ < lengthToEnsure) length = lengthToEnsure;
		}
		
		/**
		 * <p>将指定 arraybuffer 对象中的以 offset 为起始偏移量， length 为长度的字节序列写入字节流。</p>
		 * <p>如果省略 length 参数，则使用默认长度 0，该方法将从 offset 开始写入整个缓冲区；如果还省略了 offset 参数，则写入整个缓冲区。</p>
		 * <p>如果 offset 或 length 小于0，本函数将抛出异常。</p>
		 * $NEXTBIG 由于没有判断length和arraybuffer的合法性，当开发者填写了错误的length值时，会导致写入多余的空白数据甚至内存溢出，为了避免影响开发者正在使用此方法的功能，下个重大版本会修复这些问题。
		 * @param	arraybuffer	需要写入的 Arraybuffer 对象。
		 * @param	offset		Arraybuffer 对象的索引的偏移量（以字节为单位）
		 * @param	length		从 Arraybuffer 对象写入到 Byte 对象的长度（以字节为单位）
		 */
		public function writeArrayBuffer(arraybuffer:*, offset:uint = 0, length:uint = 0):void {
			if (offset < 0 || length < 0) throw "writeArrayBuffer error - Out of bounds";
			if (length == 0) length = arraybuffer.byteLength - offset;
			//$ALERT 这里会分配用户指定的内存空间，这可能导致分配多余的内存空间，甚至导致内存溢出。应该进行有效性检查。如果用户想要分配多余的空间，应该使用set length。
			ensureWrite(this._pos_ + length);
			var uint8array:* = new Uint8Array(arraybuffer);
			this._u8d_.set(uint8array.subarray(offset, offset + length), _pos_);
			this._pos_ += length;
		}
	}
}