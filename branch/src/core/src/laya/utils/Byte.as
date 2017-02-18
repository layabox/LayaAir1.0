package laya.utils {
	
	import laya.maths.Matrix;
	
	/**
	 *
	 * <code>Byte</code> 类提供用于优化读取、写入以及处理二进制数据的方法和属性。
	 */
	public class Byte {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**
		 * 表示多字节数字的最高有效字节位于字节序列的最前面。
		 */
		public static const BIG_ENDIAN:String = "bigEndian";
		/**
		 * 表示多字节数字的最低有效字节位于字节序列的最前面。
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
		 * 获取系统的字节存储顺序。
		 * @return 字节存储顺序。
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
		 * @param	data 用于指定元素的数目、类型化数组、ArrayBuffer。
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
		 * 获取此对象的 ArrayBuffer数据,数据只包含有效数据部分 。
		 */
		public function get buffer():ArrayBuffer {
			var rstBuffer:ArrayBuffer= this._d_.buffer;
			if (rstBuffer.byteLength == this.length) return  rstBuffer;
			return rstBuffer.slice(0, this.length);
		}
		
		/**
		 * 字节顺序。
		 */
		public function get endian():String {
			return _xd_ ? LITTLE_ENDIAN : BIG_ENDIAN;
		}
		
		public function set endian(endianStr:String):void {
			_xd_ = (endianStr == LITTLE_ENDIAN);
		}
		
		public function set length(value:int):void {
			if (_allocated_ < value)
				___resizeBuffer(_allocated_ = Math.floor(Math.max(value, _allocated_ * 2)));
			else if (_allocated_ > value)
				___resizeBuffer(_allocated_ = value);
			_length = value;
		}
		
		/**
		 * 字节长度。
		 */
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
					/*[IF-FLASH]*/if (_u8d_.length <= len) newByteView.setarr(_u8d_);
					/*[IF-FLASH]*/else newByteView.setarr(_u8d_.subarray(0, len));
				}
				this._u8d_ = newByteView;
				this._d_ = new DataView(newByteView.buffer);
			} catch (err:*) {
				throw "___resizeBuffer err:" + len;
			}
		}
		
		/**
		 * 读取字符型值。
		 * @return
		 */
		public function getString():String {
			return rUTF(getUint16());
		}
		
		//LITTLE_ENDIAN only now;
		/**
		 * 从指定的位置读取指定长度的数据用于创建一个 Float32Array 对象并返回此对象。
		 * @param	start 开始位置。
		 * @param	len 需要读取的字节长度。
		 * @return  读出的 Float32Array 对象。
		 */
		public function getFloat32Array(start:int, len:int):* {
			var v:* = new Float32Array(this._d_.buffer.slice(start, start + len));
			_pos_ += len;
			return v;
		}
		
		/**
		 * 从指定的位置读取指定长度的数据用于创建一个 Uint8Array 对象并返回此对象。
		 * @param	start 开始位置。
		 * @param	len 需要读取的字节长度。
		 * @return  读出的 Uint8Array 对象。
		 */
		public function getUint8Array(start:int, len:int):Uint8Array {
			var v:* = new Uint8Array(this._d_.buffer.slice(start, start + len));
			_pos_ += len;
			return v;
		}
		
		/**
		 * 从指定的位置读取指定长度的数据用于创建一个 Int16Array 对象并返回此对象。
		 * @param	start 开始位置。
		 * @param	len 需要读取的字节长度。
		 * @return  读出的 Uint8Array 对象。
		 */
		public function getInt16Array(start:int, len:int):* {
			var v:* = new Int16Array(this._d_.buffer.slice(start, start + len));
			_pos_ += len;
			return v;
		}
		
		/**
		 * 在指定字节偏移量位置处读取 Float32 值。
		 * @return Float32 值。
		 */
		public function getFloat32():Number {
			var v:Number = _d_.getFloat32(_pos_, _xd_);
			_pos_ += 4;
			return v;
		}
		
		public function getFloat64():Number {
			var v:Number = _d_.getFloat64(_pos_, _xd_);
			_pos_ += 8;
			return v;
		}
		
		/**
		 * 在当前字节偏移量位置处写入 Float32 值。
		 * @param	value 需要写入的 Float32 值。
		 */
		public function writeFloat32(value:Number):void {
			ensureWrite(this._pos_ + 4);
			_d_.setFloat32(_pos_, value, _xd_);
			_pos_ += 4;
		}
		
		public function writeFloat64(value:Number):void {
			ensureWrite(this._pos_ + 8);
			_d_.setFloat64(_pos_, value, _xd_);
			_pos_ += 8;
		}
		
		/**
		 * 在当前字节偏移量位置处读取 Int32 值。
		 * @return Int32 值。
		 */
		public function getInt32():int {
			var float:Number = _d_.getInt32(_pos_, _xd_);
			_pos_ += 4;
			return float;
		}
		
		/**
		 * 在当前字节偏移量位置处读取 Uint32 值。
		 * @return Uint32 值。
		 */
		public function getUint32():uint {
			var v:Number = _d_.getUint32(_pos_, _xd_);
			_pos_ += 4;
			return v;
		}
		
		/**
		 * 在当前字节偏移量位置处写入 Int32 值。
		 * @param	value 需要写入的 Int32 值。
		 */
		public function writeInt32(value:int):void {
			ensureWrite(this._pos_ + 4);
			_d_.setInt32(_pos_, value, _xd_);
			_pos_ += 4;
		}
		
		/**
		 * 在当前字节偏移量位置处写入 Uint32 值。
		 * @param	value 需要写入的 Uint32 值。
		 */
		public function writeUint32(value:int):void {
			ensureWrite(this._pos_ + 4);
			_d_.setUint32(_pos_, value, _xd_);
			_pos_ += 4;
		}
		
		/**
		 * 在当前字节偏移量位置处读取 Int16 值。
		 * @return Int16 值。
		 */
		public function getInt16():int {
			var us:int = _d_.getInt16(this._pos_, _xd_);
			this._pos_ += 2;
			return us;
		}
		
		/**
		 * 在当前字节偏移量位置处读取 Uint16 值。
		 * @return Uint16 值。
		 */
		public function getUint16():uint {
			var us:int = _d_.getUint16(this._pos_, _xd_);
			this._pos_ += 2;
			return us;
		}
		
		/**
		 * 在当前字节偏移量位置处写入 Uint16 值。
		 * @param	value 需要写入的Uint16 值。
		 */
		public function writeUint16(value:int):void {
			ensureWrite(this._pos_ + 2);
			_d_.setUint16(_pos_, value, _xd_);
			_pos_ += 2;
		}
		
		/**
		 * 在当前字节偏移量位置处写入 Int16 值。
		 * @param	value 需要写入的 Int16 值。
		 */
		public function writeInt16(value:int):void {
			ensureWrite(this._pos_ + 2);
			_d_.setInt16(_pos_, value, _xd_);
			_pos_ += 2;
		}
		
		/**
		 * 在当前字节偏移量位置处读取 Uint8 值。
		 * @return Uint8 值。
		 */
		public function getUint8():uint {
			return _d_.getUint8(_pos_++);
		}
		
		/**
		 * 在当前字节偏移量位置处写入 Uint8 值。
		 * @param	value 需要写入的 Uint8 值。
		 */
		public function writeUint8(value:int):void {
			ensureWrite(this._pos_ + 1);
			_d_.setUint8(_pos_, value, _xd_);
			_pos_++;
		}
		
		/**
		 * @private
		 * 在指定位置处读取 Uint8 值。
		 * @param	pos 字节读取位置。
		 * @return Uint8 值。
		 */
		public function _getUInt8(pos:int):int {
			return _d_.getUint8(pos);
		}
		
		/**
		 * @private
		 * 在指定位置处读取 Uint16 值。
		 * @param	pos 字节读取位置。
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
		 * @return 读出的字符串。
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
		 * 字符串读取。
		 * @param	len
		 * @return
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
		 * 当前读取到的位置。
		 */
		public function get pos():int {
			return _pos_;
		}
		
		public function set pos(value:int):void {
			_pos_ = value;
			_d_.byteOffset = value;
		}
		
		/**
		 * 可从字节流的当前位置到末尾读取的数据的字节数。
		 */
		public function get bytesAvailable():int {
			return length - _pos_;
		}
		
		/**
		 * 清除数据。
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
		 * 写入字符串，该方法写的字符串要使用 readUTFBytes 方法读取。
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
					//这里要优化,胡高，writeShort,后面也是
					writeByte(0xC0 | (c >> 6));
					writeByte(0x80 | (c & 63));
					
				} else if (c <= 0xFFFF) {
					
					writeByte(0xE0 | (c >> 12));
					writeByte(0x80 | ((c >> 6) & 63));
					writeByte(0x80 | (c & 63));
					
				} else {
					
					writeByte(0xF0 | (c >> 18));
					writeByte(0x80 | ((c >> 12) & 63));
					writeByte(0x80 | ((c >> 6) & 63));
					writeByte(0x80 | (c & 63));
				}
			}
		}
		
		/**
		 * 将 UTF-8 字符串写入字节流。
		 * @param	value 要写入的字符串值。
		 */
		public function writeUTFString(value:String):void {
			var tPos:int;
			tPos = pos;
			writeUint16(1);
			writeUTFBytes(value);
			var dPos:int;
			dPos = pos - tPos - 2;
			//trace("writeLen:",dPos,"pos:",tPos);
			_d_.setUint16(tPos, dPos, _xd_);
		}
		
		/**
		 * @private
		 * 读取 UTF-8 字符串。
		 * @return 读出的字符串。
		 */
		public function readUTFString():String {
			var tPos:int;
			tPos = pos;
			var len:int;
			len = getUint16();
			//trace("readLen:"+len,"pos,",tPos);
			return readUTFBytes(len);
		}
		
		/**
		 * 读取 UTF-8 字符串。
		 * @return 读出的字符串。
		 */
		public function getUTFString():String {
			return readUTFString();
		}
		
		/**
		 * @private
		 * 读字符串，必须是 writeUTFBytes 方法写入的字符串。
		 * @param len 要读的buffer长度,默认将读取缓冲区全部数据。
		 * @return 读取的字符串。
		 */
		public function readUTFBytes(len:int = -1):String {
			if(len==0) return "";
			len = len > 0 ? len : bytesAvailable;
			return rUTF(len);
		}
		
		/**
		 * 读字符串，必须是 writeUTFBytes 方法写入的字符串。
		 * @param len 要读的buffer长度,默认将读取缓冲区全部数据。
		 * @return 读取的字符串。
		 */
		public function getUTFBytes(len:int = -1):String {
			return readUTFBytes(len);
		}
		
		/**
		 * 在字节流中写入一个字节。
		 * @param	value
		 */
		public function writeByte(value:int):void {
			ensureWrite(this._pos_ + 1);
			_d_.setInt8(this._pos_, value);
			this._pos_ += 1;
		}
		
		/**
		 * @private
		 * 在字节流中读一个字节。
		 */
		public function readByte():int {
			return _d_.getInt8(_pos_++);
		}
		
		/**
		 * 在字节流中读一个字节。
		 */
		public function getByte():int {
			return readByte();
		}
		
		/**
		 * 指定该字节流的长度。
		 * @param	lengthToEnsure 指定的长度。
		 */
		public function ensureWrite(lengthToEnsure:int):void {
			if (this._length < lengthToEnsure) this._length = lengthToEnsure;
			if (this._allocated_ < lengthToEnsure) length = lengthToEnsure;
		}
		
		/**
		 * 写入指定的 Arraybuffer 对象。
		 * @param	arraybuffer 需要写入的 Arraybuffer 对象。
		 * @param	offset 偏移量（以字节为单位）
		 * @param	length 长度（以字节为单位）
		 */
		public function writeArrayBuffer(arraybuffer:*, offset:uint = 0, length:uint = 0):void {
			if (offset < 0 || length < 0) throw "writeArrayBuffer error - Out of bounds";
			if (length == 0) length = arraybuffer.byteLength - offset;
			ensureWrite(this._pos_ + length);
			var uint8array:* = new Uint8Array(arraybuffer);
			this._u8d_.set(uint8array.subarray(offset, offset + length), _pos_);
			this._pos_ += length;
		}
	}
}