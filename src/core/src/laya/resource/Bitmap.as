package laya.resource {
	
	/**
	 * @private
	 * <code>Bitmap</code> 是图片资源类。
	 */
	public class Bitmap extends Resource {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**@private
		 * HTML Image或HTML Canvas或WebGL Texture。
		 * */
		protected var _source:*;
		/**@private 宽度*/
		protected var _w:Number;
		/**@private 高度*/
		protected var _h:Number;
		
		/***
		 * 宽度。
		 */
		public function get width():Number {
			return _w;
		}
		
		/***
		 * 高度。
		 */
		public function get height():Number {
			return _h;
		}
		
		/***
		 * HTML Image 或 HTML Canvas 或 WebGL Texture 。
		 */
		public function get source():* {
			return _source;
		}
		
		/**
		 * 创建一个 <code>Bitmap</code> 实例。
		 */
		public function Bitmap() {
			_w = 0;
			_h = 0;
		}
	}
}