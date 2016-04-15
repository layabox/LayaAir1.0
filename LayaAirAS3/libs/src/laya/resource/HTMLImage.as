package laya.resource {
	import laya.utils.Browser;
	
	/**
	 * ...
	 * @author laya
	 */
	public class HTMLImage extends FileBitmap {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**异步加载锁*/
		private var _recreateLock:Boolean = false;
		/**异步加载完成后是否需要释放（有可能在恢复过程中,再次被释放，用此变量做标记）*/
		private var _needReleaseAgain:Boolean = false;
		
		/***
		 * 获取HTML Image
		 * @return HTML Image
		 */
		override public function get source():* {
			return _source;//可能受资源恢复影响，未恢复完成返回null
		}
		
		/**
		 * 设置文件路径全名
		 * @param 文件路径全名
		 */
		override public function set src(value:String):void {
			_src = value;
			_source && (_source.src = _src);
		}
		
		/***
		 * 设置onload函数
		 * @param value onload函数
		 */
		override public function set onload(value:Function):void {
			_onload = value;
			_source && (_source.onload = _onload != null ? (function():void {
				onresize();
				_onload();
			}) : null);
		}
		
		/***
		 * 设置onerror函数
		 * @param value onerror函数
		 */
		override public function set onerror(value:Function):void {
			_onerror = value;
			_source && (_source.onerror = _onerror != null ? (function():void {
				_onerror()
			}) : null);
		}
		
		public function HTMLImage(im:* = null) {
			_source = im || new Browser.window.Image();
			super();
		}
		
		/***重新创建资源*/
		override protected function recreateResource():void {
			if (_src === "")
				throw new Error("src不能为空！");
			
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
			}
			//else{}//资源恢复过程中会走此分支,_source中应为null（对应WebGLImage）,本类get source属性中处理
		}
		
		/***销毁资源*/
		override protected function detoryResource():void {
			if (_recreateLock)
				_needReleaseAgain = true;
			(_source) && (_source = null, memorySize = 0);
		}
		
		/***调整尺寸*/
		private function onresize():void {
			this._w = this._source.width;
			this._h = this._source.height;
		}
	}
}