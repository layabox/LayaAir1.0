package laya.resource {
	
	/**
	 * ...
	 * @author
	 */
	public class FileBitmap extends Bitmap {
		
		/**文件路径全名*/
		protected var _src:String;
		
		/**
		 * 获取文件路径全名
		 * @return 文件路径全名
		 */
		public function get src():String {
			return _src;
		}
		
		/**
		 * 设置文件路径全名
		 * @param 文件路径全名
		 */
		public function set src(value:String):void {
			_src = value;
		}
		
		/**onload触发函数*/
		protected var _onload:Function;
		/**onerror触发函数*/
		protected var _onerror:Function;
		
		/***
		 * 设置onload函数,override it!
		 * @param value onload函数
		 */
		public function set onload(value:Function):void {
		}
		
		/***
		 * 设置onerror函数,override it!
		 * @param value onerror函数
		 */
		public function set onerror(value:Function):void {
		}
	}

}