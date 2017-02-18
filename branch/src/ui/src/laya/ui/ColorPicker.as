package laya.ui {
	import laya.display.Graphics;
	import laya.display.Input;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Point;
	import laya.utils.Handler;
	
	/**
	 * 选择项改变后调度。
	 * @eventType laya.events.Event
	 */
	[Event(name = "change", type = "laya.events.Event")]
	
	/**
	 * <code>ColorPicker</code> 组件将显示包含多个颜色样本的列表，用户可以从中选择颜色。
	 *
	 * @example 以下示例代码，创建了一个 <code>ColorPicker</code> 实例。
	 * <listing version="3.0">
	 * package
	 *	{
	 *		import laya.ui.ColorPicker;
	 *		import laya.utils.Handler;
	 *		public class ColorPicker_Example
	 *		{
	 *			public function ColorPicker_Example()
	 *			{
	 *				Laya.init(640, 800);//设置游戏画布宽高。
	 *				Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *				Laya.loader.load("resource/ui/color.png", Handler.create(this,onLoadComplete));//加载资源。
	 *			}
	 *			private function onLoadComplete():void
	 *			{
	 *				trace("资源加载完成！");
	 *				var colorPicket:ColorPicker = new ColorPicker();//创建一个 ColorPicker 类的实例对象 colorPicket 。
	 *				colorPicket.skin = "resource/ui/color.png";//设置 colorPicket 的皮肤。
	 *				colorPicket.x = 100;//设置 colorPicket 对象的属性 x 的值，用于控制 colorPicket 对象的显示位置。
	 *				colorPicket.y = 100;//设置 colorPicket 对象的属性 y 的值，用于控制 colorPicket 对象的显示位置。
	 *				colorPicket.changeHandler = new Handler(this, onChangeColor,[colorPicket]);//设置 colorPicket 的颜色改变回调函数。
	 *				Laya.stage.addChild(colorPicket);//将此 colorPicket 对象添加到显示列表。
	 *			}
	 *			private function onChangeColor(colorPicket:ColorPicker):void
	 *			{
	 *				trace("当前选择的颜色： " + colorPicket.selectedColor);
	 *			}
	 *		}
	 *	}
	 * </listing>
	 * <listing version="3.0">
	 * Laya.init(640, 800);//设置游戏画布宽高
	 * Laya.stage.bgColor = "#efefef";//设置画布的背景颜色
	 * Laya.loader.load("resource/ui/color.png",laya.utils.Handler.create(this,loadComplete));//加载资源
	 * function loadComplete()
	 * {
	 *     console.log("资源加载完成！");
	 *     var colorPicket = new laya.ui.ColorPicker();//创建一个 ColorPicker 类的实例对象 colorPicket 。
	 *     colorPicket.skin = "resource/ui/color.png";//设置 colorPicket 的皮肤。
	 *     colorPicket.x = 100;//设置 colorPicket 对象的属性 x 的值，用于控制 colorPicket 对象的显示位置。
	 *     colorPicket.y = 100;//设置 colorPicket 对象的属性 y 的值，用于控制 colorPicket 对象的显示位置。
	 *     colorPicket.changeHandler = laya.utils.Handler.create(this, onChangeColor,[colorPicket],false);//设置 colorPicket 的颜色改变回调函数。
	 *     Laya.stage.addChild(colorPicket);//将此 colorPicket 对象添加到显示列表。
	 * }
	 * function onChangeColor(colorPicket)
	 * {
	 *     console.log("当前选择的颜色： " + colorPicket.selectedColor);
	 * }
	 * </listing>
	 * <listing version="3.0">
	 * import ColorPicker = laya.ui.ColorPicker;
	 * import Handler = laya.utils.Handler;
	 * class ColorPicker_Example {
	 *     constructor() {
	 *         Laya.init(640, 800);//设置游戏画布宽高。
	 *         Laya.stage.bgColor = "#efefef";//设置画布的背景颜色。
	 *         Laya.loader.load("resource/ui/color.png", Handler.create(this, this.onLoadComplete));//加载资源。
	 *     }
	 *     private onLoadComplete(): void {
	 *         console.log("资源加载完成！");
	 *         var colorPicket: ColorPicker = new ColorPicker();//创建一个 ColorPicker 类的实例对象 colorPicket 。
	 *         colorPicket.skin = "resource/ui/color.png";//设置 colorPicket 的皮肤。
	 *         colorPicket.x = 100;//设置 colorPicket 对象的属性 x 的值，用于控制 colorPicket 对象的显示位置。
	 *         colorPicket.y = 100;//设置 colorPicket 对象的属性 y 的值，用于控制 colorPicket 对象的显示位置。
	 *         colorPicket.changeHandler = new Handler(this, this.onChangeColor, [colorPicket]);//设置 colorPicket 的颜色改变回调函数。
	 *         Laya.stage.addChild(colorPicket);//将此 colorPicket 对象添加到显示列表。
	 *     }
	 *     private onChangeColor(colorPicket: ColorPicker): void {
	 *         console.log("当前选择的颜色： " + colorPicket.selectedColor);
	 *     }
	 * }
	 * </listing>
	 */
	public class ColorPicker extends Component {
		
		/**
		 * 当颜色发生改变时执行的函数处理器。
		 * 默认返回参数color：颜色值字符串。
		 */
		public var changeHandler:Handler;
		
		/**
		 * @private
		 * 指定每个正方形的颜色小格子的宽高（以像素为单位）。
		 */
		protected var _gridSize:int = 11;
		/**
		 * @private
		 * 表示颜色样本列表面板的背景颜色值。
		 */
		protected var _bgColor:String = "#ffffff";
		/**
		 * @private
		 * 表示颜色样本列表面板的边框颜色值。
		 */
		protected var _borderColor:String = "#000000";
		/**
		 * @private
		 * 表示颜色样本列表面板选择或输入的颜色值。
		 */
		protected var _inputColor:String = "#000000";
		/**
		 * @private
		 * 表示颜色输入框的背景颜色值。
		 */
		protected var _inputBgColor:String = "#efefef";
		/**
		 * @private
		 * 表示颜色样本列表面板。
		 */
		protected var _colorPanel:Box;
		/**
		 * @private
		 * 表示颜色网格。
		 */
		protected var _colorTiles:Sprite;
		/**
		 * @private
		 * 表示颜色块显示对象。
		 */
		protected var _colorBlock:Sprite;
		/**
		 * @private
		 * 表示颜色输入框控件 <code>Input</code> 。
		 */
		protected var _colorInput:Input;
		/**
		 * @private
		 * 表示点击后显示颜色样本列表面板的按钮控件 <code>Button</code> 。
		 */
		protected var _colorButton:Button;
		/**
		 * @private
		 * 表示颜色值列表。
		 */
		protected var _colors:Array = [];
		/**
		 * @private
		 * 表示选择的颜色值。
		 */
		protected var _selectedColor:String = "#000000";
		/** @private */
		protected var _panelChanged:Boolean;
		
		/**@inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			_colorPanel && _colorPanel.destroy(destroyChild);
			_colorButton && _colorButton.destroy(destroyChild);
			_colorPanel = null;
			_colorTiles = null;
			_colorBlock = null;
			_colorInput = null;
			_colorButton = null;
			_colors = null;
			changeHandler = null;
		}
		
		/**@inheritDoc */
		override protected function createChildren():void {
			addChild(_colorButton = new Button());
			_colorPanel = new Box();
			_colorPanel.size(230, 166);
			_colorPanel.addChild(_colorTiles = new Sprite());
			_colorPanel.addChild(_colorBlock = new Sprite());
			_colorPanel.addChild(_colorInput = new Input());
		}
		
		/**@inheritDoc */
		override protected function initialize():void {
			_colorButton.on(Event.CLICK, this, onColorButtonClick);
			
			_colorBlock.pos(5, 5);
			
			_colorInput.pos(60, 5);
			_colorInput.size(60, 20);
			_colorInput.on(Event.CHANGE, this, onColorInputChange);
			_colorInput.on(Event.KEY_DOWN, this, onColorFieldKeyDown);
			
			_colorTiles.pos(5, 30);
			_colorTiles.on(Event.MOUSE_MOVE, this, onColorTilesMouseMove);
			_colorTiles.on(Event.CLICK, this, onColorTilesClick);
			_colorTiles.size(20 * _gridSize, 12 * _gridSize);
			
			_colorPanel.on(Event.MOUSE_DOWN, this, onPanelMouseDown);
			
			bgColor = _bgColor;
		}
		
		private function onPanelMouseDown(e:Event):void {
			e.stopPropagation();
		}
		
		/**
		 * 改变颜色样本列表面板。
		 */
		protected function changePanel():void {
			_panelChanged = false;
			var g:Graphics = _colorPanel.graphics;
			g.clear();
			//g.drawRect(0, 0, 230, 166, _bgColor);
			g.drawRect(0, 0, 230, 166, _bgColor, _borderColor);
			
			drawBlock(_selectedColor);
			
			_colorInput.borderColor = _borderColor;
			_colorInput.bgColor = _inputBgColor;
			_colorInput.color = _inputColor;
			
			g = _colorTiles.graphics;
			g.clear();
			
			var mainColors:Array = [0x000000, 0x333333, 0x666666, 0x999999, 0xCCCCCC, 0xFFFFFF, 0xFF0000, 0x00FF00, 0x0000FF, 0xFFFF00, 0x00FFFF, 0xFF00FF];
			for (var i:int = 0; i < 12; i++) {
				for (var j:int = 0; j < 20; j++) {
					var color:uint;
					if (j === 0) color = mainColors[i];
					else if (j === 1) color = 0x000000;
					else color = (((i * 3 + j / 6) % 3 << 0) + ((i / 6) << 0) * 3) * 0x33 << 16 | j % 6 * 0x33 << 8 | (i << 0) % 6 * 0x33;
					
					var strColor:String = UIUtils.toColor(color);
					_colors.push(strColor);
					
					var x:int = j * _gridSize;
					var y:int = i * _gridSize;
					
					g.drawRect(x, y, _gridSize, _gridSize, strColor, "#000000");
						//g.drawRect(x + 1, y + 1, _gridSize - 1, _gridSize - 1, strColor);
				}
			}
		}
		
		/**
		 * 颜色样本列表面板的显示按钮的 <code>Event.MOUSE_DOWN</code> 事件侦听处理函数。
		 */
		private function onColorButtonClick(e:Event):void {
			if (_colorPanel.parent) close();
			else open();
		}
		
		/**
		 * 打开颜色样本列表面板。
		 */
		public function open():void {
			var p:Point = localToGlobal(new Point());
			var px:Number = p.x + _colorPanel.width <= Laya.stage.width ? p.x : Laya.stage.width - _colorPanel.width;
			var py:Number = p.y + _colorButton.height;
			py = py + _colorPanel.height <= Laya.stage.height ? py : p.y - _colorPanel.height;
			_colorPanel.pos(px, py);
			Laya.stageBox.addChild(_colorPanel);
			Laya.stage.on(Event.MOUSE_DOWN, this, removeColorBox);
		}
		
		/**
		 * 关闭颜色样本列表面板。
		 */
		public function close():void {
			Laya.stage.off(Event.MOUSE_DOWN, this, removeColorBox);
			_colorPanel.removeSelf();
		}
		
		/**
		 * 舞台的 <code>Event.MOUSE_DOWN</code> 事件侦听处理函数。
		 */
		private function removeColorBox(e:Event = null):void {
			close();
			//var target:Sprite = e.target as Sprite;
			//if (!_colorButton.contains(target) && !_colorPanel.contains(target)) {
			//close();
			//}
		}
		
		/**
		 * 小格子色块的 <code>Event.KEY_DOWN</code> 事件侦听处理函数。
		 */
		private function onColorFieldKeyDown(e:Event):void {
			if (e.keyCode == 13) {
				if (_colorInput.text) selectedColor = _colorInput.text;
				else selectedColor = null;
				close();
				e.stopPropagation();
			}
		}
		
		/**
		 * 颜色值输入框 <code>Event.CHANGE</code> 事件侦听处理函数。
		 */
		private function onColorInputChange(e:Event = null):void {
			if (_colorInput.text) drawBlock(_colorInput.text);
			else drawBlock("#FFFFFF");
		}
		
		/**
		 * 小格子色块的 <code>Event.CLICK</code> 事件侦听处理函数。
		 */
		private function onColorTilesClick(e:Event):void {
			selectedColor = getColorByMouse();
			close();
		}
		
		/**
		 * @private
		 * 小格子色块的 <code>Event.MOUSE_MOVE</code> 事件侦听处理函数。
		 */
		private function onColorTilesMouseMove(e:Event):void {
			_colorInput.focus = false;
			var color:String = getColorByMouse();
			_colorInput.text = color;
			drawBlock(color);
		}
		
		/**
		 * 通过鼠标位置取对应的颜色块的颜色值。
		 */
		protected function getColorByMouse():String {
			var point:Point = _colorTiles.getMousePoint();
			var x:int = Math.floor(point.x / _gridSize);
			var y:int = Math.floor(point.y / _gridSize);
			return _colors[y * 20 + x];
		}
		
		/**
		 * 绘制颜色块。
		 * @param color 需要绘制的颜色块的颜色值。
		 */
		private function drawBlock(color:String):void {
			var g:Graphics = _colorBlock.graphics;
			g.clear();
			var showColor:String = color ? color : "#ffffff";
			g.drawRect(0, 0, 50, 20, showColor, _borderColor);
			
			color || g.drawLine(0, 0, 50, 20, "#ff0000");
		}
		
		/**
		 * 表示选择的颜色值。
		 */
		public function get selectedColor():String {
			return _selectedColor;
		}
		
		public function set selectedColor(value:String):void {
			if (_selectedColor != value) {
				_selectedColor = _colorInput.text = value;
				drawBlock(value);
				changeColor();
				changeHandler && changeHandler.runWith(_selectedColor);
				event(Event.CHANGE, Event.EMPTY.setTo(Event.CHANGE, this, this));
			}
		}
		
		/**
		 * @copy laya.ui.Button#skin
		 */
		public function get skin():String {
			return _colorButton.skin;
		}
		
		public function set skin(value:String):void {
			_colorButton.skin = value;
			changeColor();
		}
		
		/**
		 * 改变颜色。
		 */
		private function changeColor():void {
			var g:Graphics = this.graphics;
			g.clear();
			var showColor:String = _selectedColor || "#000000";
			g.drawRect(0, 0, _colorButton.width, _colorButton.height, showColor);
		}
		
		/**
		 * 表示颜色样本列表面板的背景颜色值。
		 */
		public function get bgColor():String {
			return _bgColor;
		}
		
		public function set bgColor(value:String):void {
			_bgColor = value;
			_setPanelChanged();
		}
		
		/**
		 * 表示颜色样本列表面板的边框颜色值。
		 */
		public function get borderColor():String {
			return _borderColor;
		}
		
		public function set borderColor(value:String):void {
			_borderColor = value;
			_setPanelChanged();
		}
		
		/**
		 * 表示颜色样本列表面板选择或输入的颜色值。
		 */
		public function get inputColor():String {
			return _inputColor;
		}
		
		public function set inputColor(value:String):void {
			_inputColor = value;
			_setPanelChanged();
		}
		
		/**
		 * 表示颜色输入框的背景颜色值。
		 */
		public function get inputBgColor():String {
			return _inputBgColor;
		}
		
		public function set inputBgColor(value:String):void {
			_inputBgColor = value;
			_setPanelChanged();
		}
		
		/**@private */
		protected function _setPanelChanged():void {
			if (!_panelChanged) {
				_panelChanged = true;
				callLater(changePanel);
			}
		}
	}
}