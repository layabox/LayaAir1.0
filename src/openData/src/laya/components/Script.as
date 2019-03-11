package laya.components {
	import laya.events.Event;
	
	/**
	 * <code>Script</code> 类用于创建脚本的父类，该类为抽象类，不允许实例。
	 * 组件的生命周期
	 */
	public class Script extends Component {
		/**
		 * @inheritDoc
		 */
		override public function get isSingleton():Boolean {
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onAwake():void {
			onAwake();
			if (this.onStart !== Script.prototype.onStart) {
				Laya.startTimer.callLater(this, this.onStart);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onEnable():void {
			var proto:* = Script.prototype;
			if (this.onTriggerEnter !== proto.onTriggerEnter) {
				owner.on(Event.TRIGGER_ENTER, this, this.onTriggerEnter);
			}
			if (this.onTriggerStay !== proto.onTriggerStay) {
				owner.on(Event.TRIGGER_STAY, this, this.onTriggerStay);
			}
			if (this.onTriggerExit !== proto.onTriggerExit) {
				owner.on(Event.TRIGGER_EXIT, this, this.onTriggerExit);
			}
			
			if (this.onMouseDown !== proto.onMouseDown) {
				owner.on(Event.MOUSE_DOWN, this, this.onMouseDown);
			}
			if (this.onMouseUp !== proto.onMouseUp) {
				owner.on(Event.MOUSE_UP, this, this.onMouseUp);
			}
			if (this.onClick !== proto.onClick) {
				owner.on(Event.CLICK, this, this.onClick);
			}
			if (this.onStageMouseDown !== proto.onStageMouseDown) {
				Laya.stage.on(Event.MOUSE_DOWN, this, this.onStageMouseDown);
			}
			if (this.onStageMouseUp !== proto.onStageMouseUp) {
				Laya.stage.on(Event.MOUSE_UP, this, this.onStageMouseUp);
			}
			if (this.onStageClick !== proto.onStageClick) {
				Laya.stage.on(Event.CLICK, this, this.onStageClick);
			}
			if (this.onStageMouseMove !== proto.onStageMouseMove) {
				Laya.stage.on(Event.MOUSE_MOVE, this, this.onStageMouseMove);
			}
			if (this.onDoubleClick !== proto.onDoubleClick) {
				owner.on(Event.DOUBLE_CLICK, this, this.onDoubleClick);
			}
			if (this.onRightClick !== proto.onRightClick) {
				owner.on(Event.RIGHT_CLICK, this, this.onRightClick);
			}
			if (this.onMouseMove !== proto.onMouseMove) {
				owner.on(Event.MOUSE_MOVE, this, this.onMouseMove);
			}
			if (this.onMouseOver !== proto.onMouseOver) {
				owner.on(Event.MOUSE_OVER, this, this.onMouseOver);
			}
			if (this.onMouseOut !== proto.onMouseOut) {
				owner.on(Event.MOUSE_OUT, this, this.onMouseOut);
			}
			if (this.onKeyDown !== proto.onKeyDown) {
				Laya.stage.on(Event.KEY_DOWN, this, this.onKeyDown);
			}
			if (this.onKeyPress !== proto.onKeyPress) {
				Laya.stage.on(Event.KEY_PRESS, this, this.onKeyPress);
			}
			if (this.onKeyUp !== proto.onKeyUp) {
				Laya.stage.on(Event.KEY_UP, this, this.onKeyUp);
			}
			if (this.onUpdate !== proto.onUpdate) {
				Laya.updateTimer.frameLoop(1, this, this.onUpdate);
			}
			if (this.onLateUpdate !== proto.onLateUpdate) {
				Laya.lateTimer.frameLoop(1, this, this.onLateUpdate);
			}
			if (this.onPreRender !== proto.onPreRender) {
				Laya.lateTimer.frameLoop(1, this, this.onPreRender);
			}
			onEnable();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onDisable():void {
			owner.offAllCaller(this);
			Laya.stage.offAllCaller(this);
			Laya.startTimer.clearAll(this);
			Laya.updateTimer.clearAll(this);
			Laya.lateTimer.clearAll(this);
			onDisable();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onDestroy():void {
			onDestroy();
		}
		
		/**
		 * 组件被激活后执行，此时所有节点和组件均已创建完毕，次方法只执行一次
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onAwake():void {
		
		}
		
		/**
		 * 组件被启用后执行，比如节点被添加到舞台后
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onEnable():void {
		
		}
		
		/**
		 * 第一次执行update之前执行，只会执行一次
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onStart():void {
		
		}
		
		/**
		 * 开始碰撞时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onTriggerEnter(other:*, self:*, contact:*):void {
		
		}
		
		/**
		 * 持续碰撞时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onTriggerStay(other:*, self:*, contact:*):void {
		
		}
		
		/**
		 * 结束碰撞时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onTriggerExit(other:*, self:*, contact:*):void {
		
		}
		
		/**
		 * 鼠标按下时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onMouseDown(e:Event):void {
		
		}
		
		/**
		 * 鼠标抬起时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onMouseUp(e:Event):void {
		
		}
		
		/**
		 * 鼠标点击时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onClick(e:Event):void {
		
		}
		
		/**
		 * 鼠标在舞台按下时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onStageMouseDown(e:Event):void {
		
		}
		
		/**
		 * 鼠标在舞台抬起时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onStageMouseUp(e:Event):void {
		
		}
		
		/**
		 * 鼠标在舞台点击时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onStageClick(e:Event):void {
		
		}
		
		/**
		 * 鼠标在舞台移动时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onStageMouseMove(e:Event):void {
		
		}
		
		/**
		 * 鼠标双击时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onDoubleClick(e:Event):void {
		
		}
		
		/**
		 * 鼠标右键点击时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onRightClick(e:Event):void {
		
		}
		
		/**
		 * 鼠标移动时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onMouseMove(e:Event):void {
		
		}
		
		/**
		 * 鼠标经过节点时触发
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onMouseOver(e:Event):void {
		
		}
		
		/**
		 * 鼠标离开节点时触发
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onMouseOut(e:Event):void {
		
		}
		
		/**
		 * 键盘按下时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onKeyDown(e:Event):void {
		
		}
		
		/**
		 * 键盘产生一个字符时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onKeyPress(e:Event):void {
		
		}
		
		/**
		 * 键盘抬起时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onKeyUp(e:Event):void {
		
		}
		
		/**
		 * 每帧更新时执行，尽量不要在这里写大循环逻辑或者使用getComponent方法
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onUpdate():void {
		
		}
		
		/**
		 * 每帧更新时执行，在update之后执行，尽量不要在这里写大循环逻辑或者使用getComponent方法
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onLateUpdate():void {
		
		}
		
		/**
		 * 渲染之前执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onPreRender():void {
		
		}
		
		/**
		 * 渲染之后执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onPostRender():void {
		
		}
		
		/**
		 * 组件被禁用时执行，比如从节点从舞台移除后
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onDisable():void {
		
		}
		
		/**
		 * 手动调用节点销毁时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onDestroy():void {
		
		}
	}
}