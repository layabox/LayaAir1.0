package laya.ui {
	import laya.events.Event;
	
	/**
	 * <code>TextArea</code> 类用于创建显示对象以显示和输入文本。
	 * @example 以下示例代码，创建了一个 <code>TextArea</code> 实例。
	 * <listing version="3.0">
	 * package
	 *	{
	 *		import laya.ui.TextArea;
	 *		import laya.utils.Handler;
	 *		public class TextArea_Example
	 *		{
	 *			public function TextArea_Example()
	 *			{
	 *				Laya.init(640, 800);//设置游戏画布宽高。
	 *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *				Laya.loader.load(["resource/ui/input.png"], Handler.create(this, onLoadComplete));//加载资源。
	 *			}
	 *			private function onLoadComplete():void
	 *			{
	 *				var textArea:TextArea = new TextArea("这个一个TextArea实例。");//创建一个 TextArea 类的实例对象 textArea 。
	 *				textArea.skin = "resource/ui/input.png";//设置 textArea 的皮肤。
	 *				textArea.sizeGrid = "4,4,4,4";//设置 textArea 的网格信息。
	 *				textArea.color = "#008fff";//设置 textArea 的文本颜色。
	 *				textArea.font = "Arial";//设置 textArea 的字体。
	 *				textArea.bold = true;//设置 textArea 的文本显示为粗体。
	 *				textArea.fontSize = 20;//设置 textArea 的文本字体大小。
	 *				textArea.wordWrap = true;//设置 textArea 的文本自动换行。
	 *				textArea.x = 100;//设置 textArea 对象的属性 x 的值，用于控制 textArea 对象的显示位置。
	 *				textArea.y = 100;//设置 textArea 对象的属性 y 的值，用于控制 textArea 对象的显示位置。
	 *				textArea.width = 300;//设置 textArea 的宽度。
	 *				textArea.height = 200;//设置 textArea 的高度。
	 *				Laya.stage.addChild(textArea);//将 textArea 添加到显示列表。
	 *			}
	 *		}
	 *	}
	 * </listing>
	 * <listing version="3.0">
	 * Laya.init(640, 800);//设置游戏画布宽高、渲染模式
	 * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
	 * Laya.loader.load(["resource/ui/input.png"], laya.utils.Handler.create(this, onLoadComplete));//加载资源。
	 * function onLoadComplete() {
	 *     var textArea = new laya.ui.TextArea("这个一个TextArea实例。");//创建一个 TextArea 类的实例对象 textArea 。
	 *     textArea.skin = "resource/ui/input.png";//设置 textArea 的皮肤。
	 *     textArea.sizeGrid = "4,4,4,4";//设置 textArea 的网格信息。
	 *     textArea.color = "#008fff";//设置 textArea 的文本颜色。
	 *     textArea.font = "Arial";//设置 textArea 的字体。
	 *     textArea.bold = true;//设置 textArea 的文本显示为粗体。
	 *     textArea.fontSize = 20;//设置 textArea 的文本字体大小。
	 *     textArea.wordWrap = true;//设置 textArea 的文本自动换行。
	 *     textArea.x = 100;//设置 textArea 对象的属性 x 的值，用于控制 textArea 对象的显示位置。
	 *     textArea.y = 100;//设置 textArea 对象的属性 y 的值，用于控制 textArea 对象的显示位置。
	 *     textArea.width = 300;//设置 textArea 的宽度。
	 *     textArea.height = 200;//设置 textArea 的高度。
	 *     Laya.stage.addChild(textArea);//将 textArea 添加到显示列表。
	 * }
	 * </listing>
	 * <listing version="3.0">
	 * import TextArea = laya.ui.TextArea;
	 * import Handler = laya.utils.Handler;
	 * class TextArea_Example {
	 *     constructor() {
	 *         Laya.init(640, 800);//设置游戏画布宽高、渲染模式。
	 *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *         Laya.loader.load(["resource/ui/input.png"], Handler.create(this, this.onLoadComplete));//加载资源。
	 *     }
	
	 *     private onLoadComplete(): void {
	 *         var textArea: TextArea = new TextArea("这个一个TextArea实例。");//创建一个 TextArea 类的实例对象 textArea 。
	 *         textArea.skin = "resource/ui/input.png";//设置 textArea 的皮肤。
	 *         textArea.sizeGrid = "4,4,4,4";//设置 textArea 的网格信息。
	 *         textArea.color = "#008fff";//设置 textArea 的文本颜色。
	 *         textArea.font = "Arial";//设置 textArea 的字体。
	 *         textArea.bold = true;//设置 textArea 的文本显示为粗体。
	 *         textArea.fontSize = 20;//设置 textArea 的文本字体大小。
	 *         textArea.wordWrap = true;//设置 textArea 的文本自动换行。
	 *         textArea.x = 100;//设置 textArea 对象的属性 x 的值，用于控制 textArea 对象的显示位置。
	 *         textArea.y = 100;//设置 textArea 对象的属性 y 的值，用于控制 textArea 对象的显示位置。
	 *         textArea.width = 300;//设置 textArea 的宽度。
	 *         textArea.height = 200;//设置 textArea 的高度。
	 *         Laya.stage.addChild(textArea);//将 textArea 添加到显示列表。
	 *     }
	 * }
	 * </listing>
	 */
	public class TextArea extends TextInput {
		/**@private */
		protected var _vScrollBar:VScrollBar;
		/**@private */
		protected var _hScrollBar:HScrollBar;
		
		/**
		 * <p>创建一个新的 <code>TextArea</code> 示例。</p>
		 * @param text 文本内容字符串。
		 */
		public function TextArea(text:String = "") {
			super(text);
		}
		
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_vScrollBar && _vScrollBar.destroy();
			_hScrollBar && _hScrollBar.destroy();
			_vScrollBar = null;
			_hScrollBar = null;
		}
		
		override protected function initialize():void {
			width = 180;
			height = 150;
			_tf.wordWrap = true;
			multiline = true;
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			callLater(changeScroll);
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			callLater(changeScroll);
		}
		
		/**垂直滚动条皮肤*/
		public function get vScrollBarSkin():String {
			return _vScrollBar ? _vScrollBar.skin : null;
		}
		
		public function set vScrollBarSkin(value:String):void {
			if (_vScrollBar == null) {
				addChild(_vScrollBar = new VScrollBar());
				_vScrollBar.on(Event.CHANGE, this, onVBarChanged);
				_vScrollBar.target = _tf;
				callLater(changeScroll);
			}
			_vScrollBar.skin = value;
		}
		
		/**水平滚动条皮肤*/
		public function get hScrollBarSkin():String {
			return _hScrollBar ? _hScrollBar.skin : null;
		}
		
		public function set hScrollBarSkin(value:String):void {
			if (_hScrollBar == null) {
				addChild(_hScrollBar = new HScrollBar());
				_hScrollBar.on(Event.CHANGE, this, onHBarChanged);
				_hScrollBar.mouseWheelEnable = false;
				_hScrollBar.target = _tf;
				callLater(changeScroll);
			}
			_hScrollBar.skin = value;
		}
		
		protected function onVBarChanged(e:Event):void {
			if (_tf.scrollY != _vScrollBar.value) {
				_tf.scrollY = _vScrollBar.value;
			}
		}
		
		protected function onHBarChanged(e:Event):void {
			if (_tf.scrollX != _hScrollBar.value) {
				_tf.scrollX = _hScrollBar.value;
			}
		}
		
		/**垂直滚动条实体*/
		public function get vScrollBar():VScrollBar {
			return _vScrollBar;
		}
		
		/**水平滚动条实体*/
		public function get hScrollBar():HScrollBar {
			return _hScrollBar;
		}
		
		/**垂直滚动最大值*/
		public function get maxScrollY():int {
			return _tf.maxScrollY;
		}
		
		/**垂直滚动值*/
		public function get scrollY():int {
			return _tf.scrollY;
		}
		
		/**水平滚动最大值*/
		public function get maxScrollX():int {
			return _tf.maxScrollX;
		}
		
		/**水平滚动值*/
		public function get scrollX():int {
			return _tf.scrollX;
		}
		
		private function changeScroll():void {
			var vShow:Boolean = _vScrollBar && _tf.maxScrollY > 0;
			var hShow:Boolean = _hScrollBar && _tf.maxScrollX > 0;
			var showWidth:Number = vShow ? _width - _vScrollBar.width : _width;
			var showHeight:Number = hShow ? _height - _hScrollBar.height : _height;
			var padding:Array = _tf.padding || Styles.labelPadding;
			
			_tf.width = showWidth;
			_tf.height = showHeight;
			
			if (_vScrollBar) {
				_vScrollBar.x = _width - _vScrollBar.width - padding[2];
				_vScrollBar.y = padding[1];
				_vScrollBar.height = _height - (hShow ? _hScrollBar.height : 0) - padding[1] - padding[3];
				_vScrollBar.scrollSize = 1;
				_vScrollBar.thumbPercent = showHeight / Math.max(_tf.textHeight, showHeight);
				_vScrollBar.setScroll(1, _tf.maxScrollY, _tf.scrollY);
				_vScrollBar.visible = vShow;
			}
			if (_hScrollBar) {
				_hScrollBar.x = padding[0];
				_hScrollBar.y = _height - _hScrollBar.height - padding[3];
				_hScrollBar.width = _width - (vShow ? _vScrollBar.width : 0) - padding[0] - padding[2];
				_hScrollBar.scrollSize = Math.max(showWidth * 0.033, 1);
				_hScrollBar.thumbPercent = showWidth / Math.max(_tf.textWidth, showWidth);
				_hScrollBar.setScroll(0, maxScrollX, scrollX);
				_hScrollBar.visible = hShow;
			}
		}
		
		/**滚动到某个位置*/
		public function scrollTo(y:Number):void {
			commitMeasure();
			_tf.scrollY = y;
		}
	}
}