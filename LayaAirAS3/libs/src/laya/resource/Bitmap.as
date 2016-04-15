package laya.resource {
	import laya.system.System;
	
	/**
	 * ...
	 * @author laya
	 */
	public class Bitmap extends Resource {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**HTML Image或HTML Canvas或WebGL Texture，as3无internal或friend，开发者通常禁止修改*/
		private static var __count:int = 0;
		
		protected var _source:*;
		/**宽度*/
		protected var _w:Number;
		/**高度*/
		protected var _h:Number;
		
		public var _id:int;
		
		/***
		 * 获取图片宽度
		 * @return 图片宽度
		 */
		public function get width():Number {
			return _w;
		}
		
		/***
		 * 获取图片高度
		 * @return 图片高度
		 */
		public function get height():Number {
			return _h;
		}
		
		/***
		 * 获取HTML Image或HTML Canvas或WebGL Texture
		 * @return HTML Image或HTML Canvas或WebGL Texture
		 */
		public function get source():* {
			return _source;
		}
		
		public function Bitmap() {
			_w = 0;
			_h = 0;
			_id= ++__count;
		}
		
		/***复制资源,此方法为浅复制*/
		public function copyTo(dec:Bitmap):void {
			dec._source = _source;
			dec._w = _w;
			dec._h = _h;
		}
		
		/**彻底清理资源*/
		override public function dispose():void {
			_resourceManager.removeResource(this);
			super.dispose();
		}
	}
}