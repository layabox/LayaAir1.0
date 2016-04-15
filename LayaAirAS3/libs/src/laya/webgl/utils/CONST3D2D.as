package laya.webgl.utils {
	/**
	 * ...
	 * @author laya
	 */
	public class CONST3D2D 
	{
		public static var BYTES_PE : uint =/*[STATIC SAFE]*/ __JS__("window.Float32Array && Float32Array.BYTES_PER_ELEMENT");
		public static var BYTES_PIDX : uint =/*[STATIC SAFE]*/ __JS__("window.Uint16Array && Uint16Array.BYTES_PER_ELEMENT");
		
		public static var  defaultMatrix4:Array=/*[STATIC SAFE]*/[
			1, 0, 0, 0,
			0, 1, 0, 0,
			0, 0, 1, 0,
			0, 0, 0, 1,
		]; 
		
		public static var  defaultMinusYMatrix4:Array=/*[STATIC SAFE]*/[
			1, 0, 0, 0,
			0, -1, 0, 0,
			0, 0, 1, 0,
			0, 0, 0, 1,
		];

		public static var uniformMatrix3:Array =/*[STATIC SAFE]*/ [
				1,0 , 0, 0,
				0,1, 0, 0,
				0, 0, 1, 0
			];

		public static var _TMPARRAY:Array = [];
		
		public static var _OFFSETX:Number = 0;
		public static var _OFFSETY:Number = 0;
		

	}

}