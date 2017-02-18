package laya.resource {
	import laya.utils.Browser;
	
	/**
	 * <code>HTMLImage</code> 用于创建 HTML Image 元素。
	 * @private
	 */
	public class HTMLImage extends FileBitmap {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/**
		 * 创建一个 <code>HTMLImage</code> 实例。请不要直接使用 new HTMLImage
		 */
		public static var create:Function = function(src:String, def:* = null):HTMLImage {
			return new HTMLImage(src, def);
		}
		
		/**异步加载锁*/
		protected var _recreateLock:Boolean = false;
		/**异步加载完成后是否需要释放（有可能在恢复过程中,再次被释放，用此变量做标记）*/
		protected var _needReleaseAgain:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		override public function set onload(value:Function):void {
			_onload = value;
			_source && (_source.onload = _onload != null ? (function():void {
				onresize();
				_onload();
			}) : null);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set onerror(value:Function):void {
			_onerror = value;
			_source && (_source.onerror = _onerror != null ? (function():void {
				_onerror()
			}) : null);
		}
		
		/**
		 * 创建一个 <code>HTMLImage</code> 实例。请不要直接使用 new HTMLImage
		 */
		public function HTMLImage(src:String, def:* = null) {
			super();
			_init_(src, def);
		}
		
		protected function _init_(src:String, def:*):void {
			_src = src;
			_source = new Browser.window.Image();
			if (def) {
				def.onload && (this.onload = def.onload);
				def.onerror && (this.onerror = def.onerror);
				def.onCreate && def.onCreate(this);
			}
			if (src.indexOf("data:image") != 0) _source.crossOrigin = "";
			
			(src) && (_source.src = src);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function recreateResource():void {
			if (_src === "")
				throw new Error("src no null！");
			
			_needReleaseAgain = false;
			if (!_source) {
				_recreateLock = true;
				startCreate();
				var _this:HTMLImage = this;
				_source = new Browser.window.Image();
				_source.crossOrigin = "";
				_source.onload = function():void {
					if (_this._needReleaseAgain)//异步处理，加载完后可能，如果强制释放资源存在已被释放的风险
					{
						_this._needReleaseAgain = false;
						_this._source.onload = null;
						_this._source = null;
						return;
					}
					_this._source.onload = null;
					_this.memorySize = _w * _h * 4;
					_this._recreateLock = false;
					_this.completeCreate();//处理创建完成后相关操作
				};
				_source.src = _src;
			} else {
				if (_recreateLock)
					return;
				startCreate();
				memorySize = _w * _h * 4;
				_recreateLock = false;
				completeCreate();//处理创建完成后相关操作
			}//资源恢复过程中会走此分支,_source中应为null（对应WebGLImage）,本类get source属性中处理
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function detoryResource():void {
			if (_recreateLock)
				_needReleaseAgain = true;
			(_source) && (_source = null, memorySize = 0);
		}
		
		/*** 调整尺寸。*/
		protected function onresize():void {
			this._w = this._source.width;
			this._h = this._source.height;
		}
	}
}