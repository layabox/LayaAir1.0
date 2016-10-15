package laya.debug.tools
{
	import laya.utils.Byte;

	/**
	 * base64编码解码类
	 * @author ww
	 */
	public class Base64Tool
	{
		
		public function Base64Tool()
		{
		
		}
		public static var chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
		
		// Use a lookup table to find the index.
		public static var lookup:Uint8Array = null;
		
		public static function init():void
		{
			if (lookup)
				return;
			lookup = new Uint8Array(256)
			for (var i:int = 0; i < chars.length; i++)
			{
				lookup[chars.charCodeAt(i)] = i;
			}
		}
		
		/**
		 * 编码ArrayBuffer 
		 * @param arraybuffer
		 * @return 
		 * 
		 */
		public static function encode(arraybuffer:ArrayBuffer):String
		{
			var bytes:Uint8Array = new Uint8Array(arraybuffer), i:int, len:int = bytes.length, base64:String = "";
			
			for (i = 0; i < len; i += 3)
			{
				base64 += chars[bytes[i] >> 2];
				base64 += chars[((bytes[i] & 3) << 4) | (bytes[i + 1] >> 4)];
				base64 += chars[((bytes[i + 1] & 15) << 2) | (bytes[i + 2] >> 6)];
				base64 += chars[bytes[i + 2] & 63];
			}
			
			if ((len % 3) === 2)
			{
				base64 = base64.substring(0, base64.length - 1) + "=";
			}
			else if (len % 3 === 1)
			{
				base64 = base64.substring(0, base64.length - 2) + "==";
			}
			
			return base64;
		}
		/**
		 * 编码字符串 
		 * @param str
		 * @return 
		 * 
		 */
		public static function encodeStr(str:String):String
		{
			var byte:Byte;
			byte = new Byte();
			byte.writeUTFString(str);
			return encodeByte(byte);
		}
		/**
		 * 编码Byte 
		 * @param byte
		 * @param start
		 * @param end
		 * @return 
		 * 
		 */
		public static function encodeByte(byte:Byte, start:int = 0, end:int = -1):String
		{
			if (end < 0)
			{
				end = byte.length;
			}
			return encode(byte.buffer.slice(start,end));
		}
		
		/**
		 * 解码成Byte 
		 * @param base64
		 * @return 
		 * 
		 */
		public static function decodeToByte(base64:String):Byte
		{
			return new Byte(decode(base64));
		}
		/**
		 * 解码成ArrayBuffer 
		 * @param base64
		 * @return 
		 * 
		 */
		public static function decode(base64:String):ArrayBuffer
		{
			init();
			var bufferLength:int = base64.length * 0.75, len:int = base64.length, i:int, p:int = 0, encoded1:int, encoded2:int, encoded3:int, encoded4:int;
			
			if (base64[base64.length - 1] === "=")
			{
				bufferLength--;
				if (base64[base64.length - 2] === "=")
				{
					bufferLength--;
				}
			}
			
			var arraybuffer:ArrayBuffer = new ArrayBuffer(bufferLength), bytes:Uint8Array = new Uint8Array(arraybuffer);
			
			for (i = 0; i < len; i += 4)
			{
				encoded1 = lookup[base64.charCodeAt(i)];
				encoded2 = lookup[base64.charCodeAt(i + 1)];
				encoded3 = lookup[base64.charCodeAt(i + 2)];
				encoded4 = lookup[base64.charCodeAt(i + 3)];
				
				bytes[p++] = (encoded1 << 2) | (encoded2 >> 4);
				bytes[p++] = ((encoded2 & 15) << 4) | (encoded3 >> 2);
				bytes[p++] = ((encoded3 & 3) << 6) | (encoded4 & 63);
			}
			
			return arraybuffer;
		}
		;
	}

}