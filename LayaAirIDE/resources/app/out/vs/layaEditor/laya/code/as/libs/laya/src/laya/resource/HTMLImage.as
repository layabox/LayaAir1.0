package laya.resource {
	import laya.utils.Browser;
	
	/**
	 * <code>HTMLImage</code> 用于创建 HTML Image 元素。
	 */
	public class HTMLImage extends FileBitmap {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**异步加载锁*/
		private var _recreateLock:Boolean = false;
		/**异步加载完成后是否需要释放（有可能在恢复过程中,再次被释放，用此变量做标记）*/
		private var _needReleaseAgain:Boolean = false;
		
		/***
		 * HTML Image。
		 */
		override public function get source():* {
			return _source;//可能受资源恢复影响，未恢复完成返回null
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set src(value:String):void {
			_src = value;
			_source && (_source.src = _src);
		}
		
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
		 * 创建一个 <code>HTMLImage</code> 实例。
		 */
		public function HTMLImage(im:* = null) {
			_source = im || new Browser.window.Image();
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function recreateResource():void {
			if (_src === "")
				throw new Error("src不能为空！");
			startCreate();
			if (!_source) {
				_recreateLock = true;
				var _this:HTMLImage = this;
				_source = new Browser.window.Image();
				_source.onload = function():void {
					_this._source.onload = null;
					if (_this._needReleaseAgain)//异步处理，加载完后可能，资源存在已被释放的风险
					{
						_this._needReleaseAgain = false;
						_this._source = null;
						return;
					}
					_this.memorySize = _w * _h * 4;
					_this._recreateLock = false;
					_this.compoleteCreate();//处理创建完成后相关操作
				};
				_source.src = _src;
			} else {
				if (_recreateLock)
					return;
				memorySize = _w * _h * 4;
				_recreateLock = false;
				compoleteCreate();//处理创建完成后相关操作
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
		private function onresize():void {
			this._w = this._source.width;
			this._h = this._source.height;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void {
			resourceManager.removeResource(this);
			super.dispose();
		}
	}
}