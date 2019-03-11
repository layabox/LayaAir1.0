package laya.ui {
	import laya.display.Animation;
	import laya.display.Scene;
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.events.Event;
	import laya.ui.Box;
	import laya.ui.Button;
	import laya.ui.CheckBox;
	import laya.ui.Image;
	import laya.ui.Label;
	import laya.ui.ProgressBar;
	import laya.ui.Radio;
	import laya.ui.RadioGroup;
	import laya.ui.Tab;
	import laya.ui.UIComponent;
	import laya.utils.ClassUtils;
	
	/**
	 * <code>View</code> 是一个视图类，2.0开始，更改继承至Scene类，相对于Scene，增加相对布局功能。
	 */
	public class View extends Scene {
		/**@private 兼容老版本*/
		public static var uiMap:Object = {};
		/**@private */
		public var _watchMap:Object = {};
		/**@private 相对布局组件*/
		protected var _widget:Widget;
		/**@private 控件的数据源。 */
		protected var _dataSource:*;
		/**X锚点，值为0-1，设置anchorX值最终通过pivotX值来改变节点轴心点。*/
		protected var _anchorX:Number = NaN;
		/**Y锚点，值为0-1，设置anchorY值最终通过pivotY值来改变节点轴心点。*/
		protected var _anchorY:Number = NaN;
		
		public function View() {
			_widget = Widget.EMPTY;
			super();
		}
		
		//注册UI类名称映射
		ClassUtils.regShortClassName([ViewStack, Button, TextArea, ColorPicker, Box, ScaleBox, Button, CheckBox, Clip, ComboBox, UIComponent, HScrollBar, HSlider, Image, Label, List, Panel, ProgressBar, Radio, RadioGroup, ScrollBar, Slider, Tab, TextInput, View, Dialog, VScrollBar, VSlider, Tree, HBox, VBox, Sprite, Animation, Text, FontClip]);
		
		/**
		 * @private 兼容老版本
		 * 注册组件类映射。
		 * <p>用于扩展组件及修改组件对应关系。</p>
		 * @param key 组件类的关键字。
		 * @param compClass 组件类对象。
		 */
		public static function regComponent(key:String, compClass:Class):void {
			ClassUtils.regClass(key, compClass);
		}
		
		/**
		 * @private 兼容老版本
		 * 注册UI视图类的逻辑处理类。
		 * @internal 注册runtime解析。
		 * @param key UI视图类的关键字。
		 * @param compClass UI视图类对应的逻辑处理类。
		 */
		public static function regViewRuntime(key:String, compClass:Class):void {
			ClassUtils.regClass(key, compClass);
		}
		
		/**
		 * @private 兼容老版本
		 * 注册UI配置信息，比如注册一个路径为"test/TestPage"的页面，UI内容是IDE生成的json
		 * @param	url		UI的路径
		 * @param	json	UI内容
		 */
		public static function regUI(url:String, json:Object):void {
			Laya.loader.cacheRes(url, json);
		}
		
		/** @inheritDoc */
		override public function destroy(destroyChild:Boolean = true):void {
			_watchMap = null;
			super.destroy(destroyChild);
		}
		
		/**@private */
		public function changeData(key:String):void {
			var arr:Array = _watchMap[key];
			if (!arr) return;
			for (var i:int = 0, n:int = arr.length; i < n; i++) {
				var watcher:* = arr[i];
				watcher.exe(this);
			}
		}
		
		/**
		 * <p>从组件顶边到其内容区域顶边之间的垂直距离（以像素为单位）。</p>
		 */
		public function get top():Number {
			return this._widget.top;
		}
		
		public function set top(value:Number):void {
			if (value != _widget.top) {
				_getWidget().top = value;
			}
		}
		
		/**
		 * <p>从组件底边到其内容区域底边之间的垂直距离（以像素为单位）。</p>
		 */
		public function get bottom():Number {
			return this._widget.bottom;
		}
		
		public function set bottom(value:Number):void {
			if (value != _widget.bottom) {
				_getWidget().bottom = value;
			}
		}
		
		/**
		 * <p>从组件左边到其内容区域左边之间的水平距离（以像素为单位）。</p>
		 */
		public function get left():Number {
			return this._widget.left;
		}
		
		public function set left(value:Number):void {
			if (value != _widget.left) {
				_getWidget().left = value;
			}
		}
		
		/**
		 * <p>从组件右边到其内容区域右边之间的水平距离（以像素为单位）。</p>
		 */
		public function get right():Number {
			return this._widget.right;
		}
		
		public function set right(value:Number):void {
			if (value != _widget.right) {
				_getWidget().right = value;
			}
		}
		
		/**
		 * <p>在父容器中，此对象的水平方向中轴线与父容器的水平方向中心线的距离（以像素为单位）。</p>
		 */
		public function get centerX():Number {
			return this._widget.centerX;
		}
		
		public function set centerX(value:Number):void {
			if (value != _widget.centerX) {
				_getWidget().centerX = value;
			}
		}
		
		/**
		 * <p>在父容器中，此对象的垂直方向中轴线与父容器的垂直方向中心线的距离（以像素为单位）。</p>
		 */
		public function get centerY():Number {
			return this._widget.centerY;
		}
		
		public function set centerY(value:Number):void {
			if (value != _widget.centerY) {
				_getWidget().centerY = value;
			}
		}
		
		/**X锚点，值为0-1，设置anchorX值最终通过pivotX值来改变节点轴心点。*/
		public function get anchorX():Number {
			return _anchorX;
		}
		
		public function set anchorX(value:Number):void {
			if (_anchorX != value) {
				_anchorX = value;
				callLater(_sizeChanged);
			}
		}
		
		/**Y锚点，值为0-1，设置anchorY值最终通过pivotY值来改变节点轴心点。*/
		public function get anchorY():Number {
			return _anchorY;
		}
		
		public function set anchorY(value:Number):void {
			if (_anchorY != value) {
				_anchorY = value
				callLater(_sizeChanged);
			}
		}
		
		/**@private */
		override protected function _sizeChanged():void {
			if (!isNaN(_anchorX)) this.pivotX = anchorX * width;
			if (!isNaN(_anchorY)) this.pivotY = anchorY * height;
			event(Event.RESIZE);
		}
		
		/**
		 * @private
		 * <p>获取对象的布局样式。请不要直接修改此对象</p>
		 */
		private function _getWidget():Widget {
			this._widget === Widget.EMPTY && (this._widget = addComponent(Widget));
			return this._widget;
		}
		
		/**@private 兼容老版本*/
		protected function loadUI(path:String):void {
			var uiView:Object = uiMap[path];
			uiMap && createView(uiView);
		}
		
		/**@see  laya.ui.UIComponent#dataSource*/
		public function get dataSource():* {
			return _dataSource;
		}
		
		public function set dataSource(value:*):void {
			_dataSource = value;
			for (var name:String in value) {
				var comp:* = getChildByName(name);
				if (comp is UIComponent) comp.dataSource = value[name];
				else if (hasOwnProperty(name) && !(this[name] is Function)) this[name] = value[name];
			}
		}
	}
}
