package laya.utils {
	
	import laya.maths.Matrix;
	
	public class Byte {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		public static const BIG_ENDIAN:String = "bigEndian";
		public static const LITTLE_ENDIAN:String = "littleEndian";
		/**
		 * 是否为小端数据
		 */
		protected var _xd_:Boolean = true;
		private var _allocated_:int = 8;
		/**
		 * 原始数据
		 */
		protected var _d_:*
		/**
		 * DataView
		 */
		protected var _u8d_:*;
		protected var _pos_:int = 0;
		protected var _length:int = 0;
		
		private static var _sysEndian:String = null;
		
		public static function getSystemEndian():String {
			if (!_sysEndian) {
				var buffer:* = new ArrayBuffer(2);
				new DataView(buffer).setInt16(0, 256, true);
				_sysEndian = (new Int16Array(buffer))[0] === 256 ? Byte.LITTLE_ENDIAN : Byte.BIG_ENDIAN;
			}
			return _sysEndian;
		}
		
		public function Byte(d:* = null) {
			if (d) {
				this._u8d_ = new Uint8Array(d);
				this._d_ = new DataView(this._u8d_.buffer);
				_length = this._d_.byteLength;
			} else {
				this.___resizeBuffer(this._allocated_);
			}
		
		}
		
		public function get buffer():* {
			return _u8d_.buffer;
		}
		
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
		
		public function get length():int {
			return _length;
		}
		
		private function ___resizeBuffer(len:int):void {
			try {
				var newByteView:* = new Uint8Array(len);
				if (_u8d_ != null) {
					if (_u8d_.length <= len) newByteView.set(_u8d_);
					else newByteView.set(_u8d_.subarray(0, len));
				}
				this._u8d_ = newByteView;
				this._d_ = new DataView(newByteView.buffer);
			} catch (err:*) {
				throw "___resizeBuffer err:" + len;
			}
		}
		
		public function getString():String {
			return rUTF(getUint16());
		}
		
		//LITTLE_ENDIAN only now;
		public function getFloat32Array(start:int, len:int):* {
			var v:* = new Float32Array(this._d_.buffer.slice(start, start + len));
			_pos_ += len;
			return v;
		}
		
		public function getUint8Array(start:int, len:int):Uint8Array {
			var v:* = new Uint8Array(this._d_.buffer.slice(start, start + len));
			_pos_ += len;
			return v;
		}
		
		public function getInt16Array(start:int, len:int):* {
			var v:* = new Int16Array(this._d_.buffer.slice(start, start + len));
			_pos_ += len;
			return v;
		}
		
		public function getFloat32():Number {
			var v:Number = _d_.getFloat32(_pos_, _xd_);
			_pos_ += 4;
			return v;
		}
		
		public function writeFloat32(value:Number):void {
			ensureWrite(this._pos_ + 4);
			_d_.setFloat32(_pos_, value, _xd_);
			_pos_ += 4;
		}
		
		public function getInt32():int {
			var float:Number = _d_.getInt32(_pos_, _xd_);
			_pos_ += 4;
			return float;
		}
		
		public function getUint32():uint {
			var v:Number = _d_.getUint32(_pos_, _xd_);
			_pos_ += 4;
			return v;
		}
		
		public function writeInt32(value:int):void {
			ensureWrite(this._pos_ + 4);
			_d_.setInt32(_pos_, value, _xd_);
			_pos_ += 4;
		}
		
		public function writeUint32(value:int):void {
			ensureWrite(this._pos_ + 4);
			_d_.setUint32(_pos_, value, _xd_);
			_pos_ += 4;
		}
		
		public function getInt16():int {
			var us:int = _d_.getInt16(this._pos_, _xd_);
			this._pos_ += 2;
			return us;
		}
		
		public function getUint16():uint {
			var us:int = _d_.getUint16(this._pos_, _xd_);
			this._pos_ += 2;
			return us;
		}
		
		public function writeUint16(value:int):void {
			ensureWrite(this._pos_ + 2);
			_d_.setUint16(_pos_, value, _xd_);
			_pos_ += 2;
		}
		
		public function writeInt16(value:int):void {
			ensureWrite(this._pos_ + 2);
			_d_.setInt16(_pos_, value, _xd_);
			_pos_ += 2;
		}
		
		public function getUint8():uint {
			return _d_.getUint8(_pos_++);
		}
		
		public function writeUint8(value:int):void {
			ensureWrite(this._pos_ + 1);
			_d_.setUint8(_pos_, value, _xd_);
			_pos_++;
		}
		
		public function _getUInt8(pos:int):int {
			return _d_.getUint8(pos);
		}
		
		public function _getUint16(pos:int):int {
			return _d_.getUint16(pos, _xd_);
		}
		
		public function _getMatrix():Matrix {
			var rst:Matrix = new Matrix(getFloat32(), getFloat32(), getFloat32(), getFloat32(), getFloat32(), getFloat32());
			return rst;
		}
		
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
		
		// 
		// River: 自定义的字符串读取,项目相关的内容
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
		
		public function get pos():int {
			return _pos_;
		}
		
		public function set pos(value:int):void {
			_pos_ = value;
			_d_.byteOffset = value;
		}
		
		public function get bytesAvailable():int {
			return length - _pos_;
		}
		
		public function clear():void {
			
			_pos_ = 0;
			length = 0;
		}
		
		public function __getBuffer():ArrayBuffer {
			//this._d_.buffer.byteLength = this.length;
			return _d_.buffer;
		}
		
		/**
		 *  写字符串，该方法写的字符串要使用 readUTFBytes方法读
		 * @param value 要写入的字符串
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
		
		public function writeUTFString(value:String):void {
			var tPos:int;
			tPos = pos;
			writeInt16(1);
			writeUTFBytes(value);
			var dPos:int;
			dPos = pos - tPos - 2;
			//trace("writeLen:",dPos,"pos:",tPos);
			_d_.setInt16(tPos, dPos, _xd_);
		}
		
		public function readUTFString():String {
			var tPos:int;
			tPos = pos;
			var len:int;
			len = getInt16();
			//trace("readLen:"+len,"pos,",tPos);
			return readUTFBytes(len);
		}
		
		/**
		 * 读字符串，必须是 writeUTFBytes方法写入的字符串
		 * @param len 要读的buffer长度,默认将读取缓冲区全部数据
		 * @return 读取的字符串
		 */
		public function readUTFBytes(len:int = -1):String {
			len = len > 0 ? len : bytesAvailable;
			return rUTF(len);
		}
		
		public function writeByte(value:int):void {
			ensureWrite(this._pos_ + 1);
			_d_.setInt8(this._pos_, value);
			this._pos_ += 1;
		}
		
		public function ensureWrite(lengthToEnsure:int):void {
			if (this._length < lengthToEnsure) length = lengthToEnsure;
		}
		
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