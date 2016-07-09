/*[IF-FLASH]*/package
{
	/**
	 * @private
	 */
	public dynamic class Uint16Array  extends Array {
		public static const BYTES_PER_ELEMENT:int = 16;
		
		private var vecData : Vector.<uint> = null;
		
		public var buffer:*;
		
		public function Uint16Array(...arg) {
			if ( arg.length == 1 ) {
			    // 引擎和项目内有这类的应用:
				if ( arg[0] is Array ) {
					var va : Array = (arg[0] as Array);
					vecData = new Vector.<uint>( va.length );
					for ( var ti :int = 0, len :int = va.length; ti < len; ti ++ ) {
						vecData[ti] = va[ti];
					}
				}				
			}
		}
		
		public function getVecBuf() : Vector.<uint> {
			return vecData;
		}
	}
}