package laya.ui {
	import laya.components.Component;
	import laya.display.Sprite;
	import laya.events.Event;
	
	/**
	 * 相对布局插件
	 */
	public class Widget extends Component {
		/**一个已初始化的 <code>Widget</code> 实例。*/
		public static const EMPTY:Widget = new Widget();
		
		private var _top:Number = NaN;
		private var _bottom:Number = NaN;
		private var _left:Number = NaN;
		private var _right:Number = NaN;
		private var _centerX:Number = NaN;
		private var _centerY:Number = NaN;
		
		override public function onReset():void {
			this._top = this._bottom = this._left = this._right = this._centerX = this._centerY = NaN;
		}
		
		override protected function _onEnable():void {
			if (this.owner.parent) this._onAdded();
			else this.owner.once(Event.ADDED, this, this._onAdded);
		}
		
		override protected function _onDisable():void {
			this.owner.off(Event.ADDED, this, this._onAdded);
			if (this.owner.parent) this.owner.parent.off(Event.RESIZE, this, this._onParentResize);
		}
		
		/**
		 * 对象被添加到显示列表的事件侦听处理函数。
		 */
		override public function _onAdded():void {
			if (this.owner.parent)
				this.owner.parent.on(Event.RESIZE, this, this._onParentResize);
			this.resetLayoutX();
			this.resetLayoutY();
		}
		
		/**
		 * 父容器的 <code>Event.RESIZE</code> 事件侦听处理函数。
		 */
		protected function _onParentResize():void {
			this.resetLayoutX();
			this.resetLayoutY();
			this.owner.event(Event.RESIZE);
		}
		
		/**
		 * <p>重置对象的 <code>X</code> 轴（水平方向）布局。</p>
		 * @private
		 */
		public function resetLayoutX():void {
			var owner:Sprite = this.owner as Sprite;
			if (!owner) return;
			var parent:Sprite = owner.parent as Sprite;
			if (parent) {
				if (!isNaN(centerX)) {
					owner.x = Math.round((parent.width - owner.displayWidth) * 0.5 + centerX + owner.pivotX * owner.scaleX);
				} else if (!isNaN(left)) {
					owner.x = Math.round(left + owner.pivotX * owner.scaleX);
					if (!isNaN(right)) {
						//TODO:如果用width，会死循环
						owner.width = (parent._width - left - right) / (owner.scaleX || 0.01);
					}
				} else if (!isNaN(right)) {
					owner.x = Math.round(parent.width - owner.displayWidth - right + owner.pivotX * owner.scaleX);
				}
			}
		}
		
		/**
		 * <p>重置对象的 <code>Y</code> 轴（垂直方向）布局。</p>
		 * @private
		 */
		public function resetLayoutY():void {
			var owner:Sprite = this.owner as Sprite;
			if (!owner) return;
			var parent:Sprite = owner.parent as Sprite;
			if (parent) {
				if (!isNaN(centerY)) {
					owner.y = Math.round((parent.height - owner.displayHeight) * 0.5 + centerY + owner.pivotY * owner.scaleY);
				} else if (!isNaN(top)) {
					owner.y = Math.round(top + owner.pivotY * owner.scaleY);
					if (!isNaN(bottom)) {
						//TODO:
						owner.height = (parent._height - top - bottom) / (owner.scaleY || 0.01);
					}
				} else if (!isNaN(bottom)) {
					owner.y = Math.round(parent.height - owner.displayHeight - bottom + owner.pivotY * owner.scaleY);
				}
			}
		}
		
		/**
		 * 重新计算布局
		 */
		public function resetLayout():void {
			if (this.owner) {
				resetLayoutX();
				resetLayoutY();
			}
		}
		
		/**表示距顶边的距离（以像素为单位）。*/
		public function get top():Number {
			return _top;
		}
		
		public function set top(value:Number):void {
			if (_top != value) {
				_top = value;
				resetLayoutY();
			}
		}
		
		/**表示距底边的距离（以像素为单位）。*/
		public function get bottom():Number {
			return _bottom;
		}
		
		public function set bottom(value:Number):void {
			if (_bottom != value) {
				_bottom = value;
				resetLayoutY();
			}
		}
		
		/**表示距左边的距离（以像素为单位）。*/
		public function get left():Number {
			return _left;
		}
		
		public function set left(value:Number):void {
			if (_left != value) {
				_left = value;
				resetLayoutX();
			}
		}
		
		/**表示距右边的距离（以像素为单位）。*/
		public function get right():Number {
			return _right;
		}
		
		public function set right(value:Number):void {
			if (_right != value) {
				_right = value;
				resetLayoutX();
			}
		}
		
		/**表示距水平方向中心轴的距离（以像素为单位）。*/
		public function get centerX():Number {
			return _centerX;
		}
		
		public function set centerX(value:Number):void {
			if (_centerX != value) {
				_centerX = value;
				resetLayoutX();
			}
		}
		
		/**表示距垂直方向中心轴的距离（以像素为单位）。*/
		public function get centerY():Number {
			return _centerY;
		}
		
		public function set centerY(value:Number):void {
			if (_centerY != value) {
				_centerY = value;
				resetLayoutY();
			}
		}
	}
}