package laya.resource {
	
	/**
	 * @private
	 * <code>Bitmap</code> 图片资源类。
	 */
	public class Bitmap extends Resource {
		/**@private */
		protected var _width:Number;
		/**@private */
		protected var _height:Number;
		
		/**
		 * 获取宽度。
		 */
		public function get width():Number {
			return _width;
		}
		
		/***
		 * 获取高度。
		 */
		public function get height():Number {
			return _height;
		}
		
		/**
		 * 创建一个 <code>Bitmap</code> 实例。
		 */
		public function Bitmap() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_width = -1;
			_height = -1;
		}
		
		/**
		 * @private
		 * 获取纹理资源。
		 */
		//TODO:coverage
		public function _getSource():* {
			throw "Bitmap: must override it.";
		}
	}
}