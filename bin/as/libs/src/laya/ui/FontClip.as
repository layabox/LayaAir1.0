package laya.ui {
	import laya.events.Event;
	import laya.resource.Texture;
	import laya.ui.AutoBitmap;
	import laya.ui.Clip;
	
	/**
	 * 字体切片，简化版的位图字体，只需设置一个切片图片和文字内容即可使用，效果同位图字体
	 * 使用方式：设置位图字体皮肤skin，设置皮肤对应的字体内容sheet（如果多行，可以使用空格换行），示例：
	 * fontClip.skin = "font1.png";//设置皮肤
	 * fontClip.sheet = "abc123 456";//设置皮肤对应的内容，空格换行。此皮肤为2行5列（显示时skin会被等分为2行5列），第一行对应的文字为"abc123"，第二行为"456"
	 * fontClip.value = "a1326";//显示"a1326"文字
	 */
	public class FontClip extends Clip {
		/**数值*/
		protected var _valueArr:String;
		/**文字内容数组**/
		protected var _indexMap:Object;
		/**位图字体内容**/
		protected var _sheet:String;
		/**@private */
		protected var _direction:String = "horizontal";
		/**X方向间隙*/
		protected var _spaceX:int;
		/**Y方向间隙*/
		protected var _spaceY:int;
		/**@private 水平对齐方式*/
		private var _align:String = "left";
		/**@private 显示文字宽*/
		private var _wordsW:Number = 0;
		/**@private 显示文字高*/
		private var _wordsH:Number=0;
		
		/**
		 * @param skin 位图字体皮肤
		 * @param sheet 位图字体内容，空格代表换行
		 */
		public function FontClip(skin:String = null, sheet:String = null) {
			if (skin) this.skin = skin;
			if (sheet) this.sheet = sheet;
		}
		
		override protected function createChildren():void {
			_bitmap = new AutoBitmap();
			this.on(Event.LOADED, this, _onClipLoaded);
		}
		
		/**
		 * 资源加载完毕
		 */
		private function _onClipLoaded():void {
			callLater(changeValue);
		}
		
		/**
		 * 设置位图字体内容，空格代表换行。比如"abc123 456"，代表第一行对应的文字为"abc123"，第二行为"456"
		 */
		public function get sheet():String {
			return _sheet;
		}
		
		public function set sheet(value:String):void {
			value += "";
			_sheet = value;
			//根据空格换行
			var arr:Array = value.split(" ");
			_clipX = String(arr[0]).length;
			clipY = arr.length;
			
			_indexMap = {};
			for (var i:int = 0; i < _clipY; i++) {
				var line:Array = arr[i].split("");
				for (var j:int = 0, n:int = line.length; j < n; j++) {
					_indexMap[line[j]] = i * _clipX + j;
				}
			}
		}
		
		/**
		 * 设置位图字体的显示内容
		 */
		public function get value():String {
			if (!_valueArr) return "";
			return _valueArr;
		}
		
		public function set value(value:String):void {
			value += "";
			_valueArr = value;
			callLater(changeValue);
		}
		
		/**
		 * 布局方向。
		 * <p>默认值为"horizontal"。</p>
		 * <p><b>取值：</b>
		 * <li>"horizontal"：表示水平布局。</li>
		 * <li>"vertical"：表示垂直布局。</li>
		 * </p>
		 */
		public function get direction():String {
			return _direction;
		}
		
		public function set direction(value:String):void {
			_direction = value;
			callLater(changeValue);
		}
		
		/**X方向文字间隙*/
		public function get spaceX():int {
			return _spaceX;
		}
		
		public function set spaceX(value:int):void {
			_spaceX = value;
			if (_direction === "horizontal") callLater(changeValue);
		}
		
		/**Y方向文字间隙*/
		public function get spaceY():int {
			return _spaceY;
		}
		
		public function set spaceY(value:int):void {
			_spaceY = value;
			if (!(_direction === "horizontal")) callLater(changeValue);
		}
		
		
		public function set align(v:String):void
		{
			this._align = v;
			callLater(changeValue);
		}
		
		/**水平对齐方式*/
		public function get align():String
		{
			return _align;
		}
		
			
		/**渲染数值*/
		protected function changeValue():void {
			if (!this._sources) return;
			if (!_valueArr) return;
			this.graphics.clear(true);
			var texture:Texture;
			texture = this._sources[0];
			if (!texture) return;
			var isHorizontal:Boolean = (_direction === "horizontal");
			if (isHorizontal)
			{
				_wordsW = _valueArr.length * (texture.sourceWidth + spaceX);
				_wordsH = texture.sourceHeight;
			}else
			{
				_wordsW = texture.sourceWidth;
				_wordsH = (texture.sourceHeight + spaceY) * _valueArr.length;
			}
			var dX:Number=0;
			if (_width)
			{
				switch(_align)
				{
					case "center":
						dX = 0.5 * (_width - _wordsW);
						break;
					case "right":
						dX=_width - _wordsW;
						break;
					default:
						dX = 0;
				}
			}
			
			for (var i:int = 0, sz:int = _valueArr.length; i < sz; i++) {
				var index:int = _indexMap[_valueArr.charAt(i)];
				if (!this.sources[index]) continue;
				texture = this.sources[index];
				if (isHorizontal) this.graphics.drawTexture(texture, dX+i * (texture.sourceWidth + spaceX), 0, texture.sourceWidth, texture.sourceHeight);
				else this.graphics.drawTexture(texture, 0+dX, i * (texture.sourceHeight + spaceY), texture.sourceWidth, texture.sourceHeight);
			}
			if (!_width)
			{
				resetLayoutX();
				callLater(changeSize);
			}
			if (!_height)
			{
				resetLayoutY();
				callLater(changeSize);
			}
		}
		override public function set width(value:Number):void 
		{
			super.width = value;
			callLater(changeValue);
		}
		
		override public function set height(value:Number):void 
		{
			super.height = value;
			callLater(changeValue);
		}
		
		override protected function get measureWidth():Number 
		{
			return _wordsW;
		}
		
		override protected function get measureHeight():Number 
		{
			return _wordsH;
		}
		
		override public function destroy(destroyChild:Boolean = true):void {
			_valueArr = null;
			_indexMap = null;
			this.graphics.clear(true);
			this.removeSelf();
			this.off(Event.LOADED, this, _onClipLoaded);
			super.destroy(destroyChild);
		}
	}
}