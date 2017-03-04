/*[IF-FLASH]*/package {
	/**
	 * littleEndian和bigEndian在As内是用不到的,传入参数仅用于兼容JS
	 * @private
	 */
	public class DataView {
		private var _byteArr : ArrayBuffer;
		
		// 数据位置指针
		public  var byteOffset : int = 0;
		
		public function DataView( ...arg ) {
			if ( arg.length == 1 ) {
				if ( arg[0] is ArrayBuffer ) {
					_byteArr = arg[0];
				}
			}
		}
		public function setUint8(pos : int, val : int,le:Boolean=false):void
		{
			_byteArr[pos] = val;
		}

		public function setInt16( idx : int,val:int,le : Boolean = false ) : void {
			_byteArr.position = idx;
			_byteArr.writeShort( val );
		}
		public function getInt16( idx : int, le : Boolean = false ) : int {
			_byteArr.position = idx;
			return _byteArr.readShort();
		}
		
		public function getUint16( idx : int, le : Boolean = false ) : uint {
			_byteArr.position = idx;
			return _byteArr.readUnsignedShort();
		}
		
		public function setUint16( pos : int, val:uint, le : Boolean = false ) : void {
			_byteArr.position = pos;
			// as3的ByteArray没有直接 writeUnsignedShort函数，直接写writeShort可以达到这个功能
			_byteArr.writeShort( val );
		}
		
		
		public function getUint32( pos : int, littleEndian : Boolean = false ) : uint {
			_byteArr.position = pos;
			return _byteArr.readUnsignedInt();
		}
		
		public function setUint32( pos : int, val : uint, littleEndian : Boolean = false ) : void {
			_byteArr.position = pos;
			_byteArr.writeUnsignedInt( val );
		}
		
		public function setInt32( pos : int, val : int, le : Boolean = false ) : void {
			_byteArr.position = pos;
			_byteArr.writeInt( val );
		}
		public function getInt32( pos : int, le : Boolean = false ) : int {
			_byteArr.position = pos;
			return _byteArr.readInt();
		}
		
		
		public function setInt8( pos : int, val : int ) : void {
			_byteArr[pos] = val;
		}
		
		public function getInt8(pos:int):int{
			return _byteArr[pos];
		}
		
		public function getUint8( pos : int ) : uint {
			return _byteArr[pos];
		}
		
		public function getFloat32( pos : int, littleEndian: Boolean = false ) : Number {
			_byteArr.position = pos;
			return _byteArr.readFloat();
		}
		
		public function setFloat32( pos : int, val :Number, littleEndian:Boolean = false ) : void {
			_byteArr.position = pos;
			_byteArr.writeFloat( val );
			return;
		}
		
		public function get byteLength() : int {
			return _byteArr.length;
		}
		public function get buffer() : ArrayBuffer {
			return _byteArr;
		}
		
		
		
		
		
	}
}