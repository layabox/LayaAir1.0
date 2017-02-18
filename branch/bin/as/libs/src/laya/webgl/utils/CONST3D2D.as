package laya.webgl.utils {
	
	public class CONST3D2D {
		/*[IF-FLASH-BEGIN]*/
		public static var BYTES_PE:uint =/*[STATIC SAFE]*/ 1;
		public static var BYTES_PIDX:uint =/*[STATIC SAFE]*/ 1;
		/*[IF-FLASH-END]*/
		
		/*[IF-SCRIPT-BEGIN]
		   public static var BYTES_PE : uint =__JS__('Float32Array.BYTES_PER_ELEMENT');
		   public static var BYTES_PIDX : uint =__JS__('Uint16Array.BYTES_PER_ELEMENT');
		   [IF-SCRIPT-END]*/
		
		public static var defaultMatrix4:Array =/*[STATIC SAFE]*/ [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
		
		public static var defaultMinusYMatrix4:Array =/*[STATIC SAFE]*/ [1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
		
		public static var uniformMatrix3:Array =/*[STATIC SAFE]*/ [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0];
		
		public static var _TMPARRAY:Array = [];
		
		public static var _OFFSETX:Number = 0;
		public static var _OFFSETY:Number = 0;
	
	}

}