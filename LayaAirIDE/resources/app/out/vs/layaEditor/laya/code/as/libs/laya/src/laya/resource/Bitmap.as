package laya.resource {
	
	/**
	 * <code>Bitmap</code> 是图片资源类。
	 */
	public class Bitmap extends Resource {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**@private
		 * HTML Image或HTML Canvas或WebGL Texture，as3无internal或friend，开发者通常禁止修改。
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
		
		/**
		 * 将此对象的成员（资源、宽、高）属性值复制给指定的 Bitmap 对象。
		 * @param	dec 一个 Bitmap 对象。
		 */
		public function copyTo(dec:Bitmap):void {
			dec._source = _source;
			dec._w = _w;
			dec._h = _h;
		}
		
		/**
		 * 彻底清理资源。
		 */
		override public function dispose():void {
			_resourceManager.removeResource(this);
			super.dispose();
		}
	}
}