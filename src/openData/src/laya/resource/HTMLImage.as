package laya.resource {
	import laya.net.URL;
	import laya.utils.Browser;
	
	/**
	 * @private
	 * <p> <code>HTMLImage</code> 用于创建 HTML Image 元素。</p>
	 * <p>请使用 <code>HTMLImage.create()<code>获取新实例，不要直接使用 <code>new HTMLImage<code> 。</p>
	 */
	public class HTMLImage extends Bitmap {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/**@private */
		public var _source:*;
		/**
		 * <p>创建一个 <code>HTMLImage</code> 实例。</p>
		 * <p>请使用 <code>HTMLImage.create()<code>创建实例，不要直接使用 <code>new HTMLImage<code> 。</p>
		 */
		//TODO:coverage
		public static var create:Function = function(width:int,height:int):Bitmap {
			return new HTMLImage();
		}
		
		/**
		 * <p>创建一个 <code>HTMLImage</code> 实例。</p>
		 * <p>请使用 <code>HTMLImage.create()<code>创建实例，不要直接使用 <code>new HTMLImage<code> 。</p>
		 */
		//TODO:coverage
		public function HTMLImage() {
			super();
		}
		
		/**
		 * 通过图片源填充纹理,可为HTMLImageElement、HTMLCanvasElement、HTMLVideoElement、ImageBitmap、ImageData。
		 */
		public function loadImageSource(source:*):void {
			var width:uint = source.width;
			var height:uint = source.height;
			if (width <= 0 || height <= 0)
				throw new Error("HTMLImage:width or height must large than 0.");
			
			_width = width;
			_height = height;
			_source = source;
			_setGPUMemory(width * height * 4);
			_activeResource();
		}
		
		/**
		 * @inheritDoc
		 */
		//TODO:coverage
		override protected function _disposeResource():void {
			(_source) && (_source = null, _setGPUMemory(0));
		}
		
		/**
		 * @inheritDoc
		 */
		//TODO:coverage
		override public function _getSource():* {
			return _source;
		}
	}
}