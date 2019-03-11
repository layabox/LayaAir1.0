package laya.d3.component {
	import laya.components.Component;
	import laya.d3.core.Sprite3D;
	import laya.d3.physics.Collision;
	import laya.d3.physics.PhysicsComponent;
	import laya.events.Event;
	
	/**
	 * <code>Script3D</code> 类用于创建脚本的父类,该类为抽象类,不允许实例。
	 */
	public class Script3D extends Component {
		/**
		 * @inheritDoc
		 */
		override public function get isSingleton():Boolean {
			return false;
		}
		
		/**
		 * @private
		 */
		private function _checkProcessTriggers():Boolean {
			var prototype:* = Script3D.prototype;
			if (onTriggerEnter !== prototype.onTriggerEnter)
				return true;
			if (onTriggerStay !== prototype.onTriggerStay)
				return true;
			if (onTriggerExit !== prototype.onTriggerExit)
				return true;
			return false;
		}
		
		/**
		 * @private
		 */
		private function _checkProcessCollisions():Boolean {
			var prototype:* = Script3D.prototype;
			if (onCollisionEnter !== prototype.onCollisionEnter)
				return true;
			if (onCollisionStay !== prototype.onCollisionStay)
				return true;
			if (onCollisionExit !== prototype.onCollisionExit)
				return true;
			return false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onAwake():void {
			onAwake();
			if (this.onStart !== Script3D.prototype.onStart)
				Laya.startTimer.callLater(this, this.onStart);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onEnable():void {
			(owner as Object)._scene._scriptPool.add(this);
			
			var proto:* = Script3D.prototype;
			if (this.onKeyDown !== proto.onKeyDown) {
				Laya.stage.on(Event.KEY_DOWN, this, this.onKeyDown);
			}
			if (this.onKeyPress !== proto.onKeyPress) {
				Laya.stage.on(Event.KEY_PRESS, this, this.onKeyUp);
			}
			if (this.onKeyUp !== proto.onKeyUp) {
				Laya.stage.on(Event.KEY_UP, this, this.onKeyUp);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onDisable():void {
			(owner as Object)._scene._scriptPool.remove(this);
			owner.offAllCaller(this);
			Laya.stage.offAllCaller(this);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _isScript():Boolean {
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _onAdded():void {
			var sprite:Sprite3D = owner as Sprite3D;
			var scripts:Vector.<Script3D> = sprite._scripts;
			scripts || (sprite._scripts = scripts = new Vector.<Script3D>());
			scripts.push(this);
			
			if (!sprite._needProcessCollisions)
				sprite._needProcessCollisions = _checkProcessCollisions();//检查是否需要处理物理碰撞
			
			if (!sprite._needProcessTriggers)
				sprite._needProcessTriggers = _checkProcessTriggers();//检查是否需要处理触发器
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onDestroy():void {
			var scripts:Vector.<Script3D> = (owner as Sprite3D)._scripts;
			scripts.splice(scripts.indexOf(this), 1);
			
			var sprite:Sprite3D = owner as Sprite3D;
			sprite._needProcessTriggers = false;
			for (var i:int = 0, n:int = scripts.length; i < n; i++) {
				if (scripts[i]._checkProcessTriggers()) {
					sprite._needProcessTriggers = true;
					break;
				}
			}
			
			sprite._needProcessCollisions = false;
			for (i = 0, n = scripts.length; i < n; i++) {
				if (scripts[i]._checkProcessCollisions()) {
					sprite._needProcessCollisions = true;
					break;
				}
			}
			
			onDestroy();
		}
		
		/**
		 * 创建后只执行一次
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onAwake():void {
		
		}
		
		/**
		 * 每次启动后执行
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
		 * 开始触发时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onTriggerEnter(other:PhysicsComponent):void {
		
		}
		
		/**
		 * 持续触发时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onTriggerStay(other:PhysicsComponent):void {
		
		}
		
		/**
		 * 结束触发时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onTriggerExit(other:PhysicsComponent):void {
		
		}
		
		/**
		 * 开始碰撞时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onCollisionEnter(collision:Collision):void {
		
		}
		
		/**
		 * 持续碰撞时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onCollisionStay(collision:Collision):void {
		
		}
		
		/**
		 * 结束碰撞时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onCollisionExit(collision:Collision):void {
		
		}
		
		/**
		 * 鼠标按下时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onMouseDown():void {
		
		}
		
		/**
		 * 鼠标拖拽时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onMouseDrag():void {
		
		}
		
		/**
		 * 鼠标点击时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onMouseClick():void {
		
		}
		
		/**
		 * 鼠标弹起时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onMouseUp():void {
		
		}
		
		/**
		 * 鼠标进入时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onMouseEnter():void {
		
		}
		
		/**
		 * 鼠标经过时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onMouseOver():void {
		
		}
		
		/**
		 * 鼠标离开时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onMouseOut():void {
		
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
		 * 每帧更新时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onUpdate():void {
		
		}
		
		/**
		 * 每帧更新时执行，在update之后执行
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
		 * 禁用时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onDisable():void {
		
		}
		
		/**
		 * 销毁时执行
		 * 此方法为虚方法，使用时重写覆盖即可
		 */
		public function onDestroy():void {
		
		}
	}
}