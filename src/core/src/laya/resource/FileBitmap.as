package laya.resource {
	
	/**
	 * @private
	 * <code>FileBitmap</code> 是图片文件资源类。
	 */
	public class FileBitmap extends Bitmap {
		
		/**@private 文件路径全名。*/
		protected var _src:String;
		
		/**
		 * 文件路径全名。
		 */
		public function get src():String {
			return _src;
		}
		
		public function set src(value:String):void {
			_src = value;
		}
		
		/**@private onload触发函数*/
		protected var _onload:Function;
		/**@private onerror触发函数*/
		protected var _onerror:Function;
		
		/**
		 * 载入完成处理函数。
		 */
		public function set onload(value:Function):void {
		}
		
		/**
		 * 错误处理函数。
		 */
		public function set onerror(value:Function):void {
		}
	}

}