package laya.d3.component.animation {
	import laya.ani.AnimationPlayer;
	import laya.ani.AnimationState;
	import laya.ani.AnimationTemplet;
	import laya.d3.animation.AnimationNode;
	import laya.d3.component.Component3D;
	import laya.d3.core.ComponentNode;
	import laya.d3.core.Sprite3D;
	import laya.events.Event;
	
	/**
	 * 在动画切换时调度调度。
	 * @eventType Event.ANIMATION_CHANGED
	 */
	[Event(name = "animationchanged", type = "laya.events.Event")]
	
	/**
	 * <code>KeyframeAnimation</code> 类用于帧动画组件的父类。
	 */
	public class KeyframeAnimations extends Component3D {
		/**动画播放器。*/
		protected var _player:AnimationPlayer;
		/** @private */
		protected var _templet:AnimationTemplet;
		
		/**
		 * 设置url地址。
		 * @param value 地址。
		 */
		public function set url(value:String):void {
			trace("Warning: discard property,please use templet property instead.");
			var templet:AnimationTemplet = Laya.loader.create(value, null, null, AnimationTemplet);
			if (_templet !== templet) {
				if (_player.state !== AnimationState.stopped)
					_player.stop(true);
				
				_templet = templet;
				_player.templet = templet;
				event(Event.ANIMATION_CHANGED, this);
			}
		}
		
		/**
		 * 获取动画模板。
		 * @return value 动画模板。
		 */
		public function get templet():AnimationTemplet {
			return _templet;
		}
		
		/**
		 * 设置动画模板。
		 * @param value 设置动画模板。
		 */
		public function set templet(value:AnimationTemplet):void {
			if (_templet !== value) {
				if (_player.state !== AnimationState.stopped)
					_player.stop(true);
				
				_templet = value;
				_player.templet = value;
				event(Event.ANIMATION_CHANGED, this);
			}
		}
		
		/**
		 * 获取动画播放器。
		 * @return 动画播放器。
		 */
		public function get player():AnimationPlayer {
			return _player;
		}
		
		/**
		 * 获取播放器帧数。
		 * @return 播放器帧数。
		 */
		public function get currentFrameIndex():int {
			return _player.currentKeyframeIndex;
		}
		
		/**
		 * 获取播放器的动画索引。
		 * @return 动画索引。
		 */
		public function get currentAnimationClipIndex():int {
			return _player.currentAnimationClipIndex;
		}
		
		/**
		 * 获取播放器当前动画的节点数量。
		 * @return 节点数量。
		 */
		public function get nodeCount():int {
			return _templet.getNodeCount(_player.currentAnimationClipIndex);
		}
		
		/**
		 * 创建一个新的 <code>KeyframeAnimation</code> 实例。
		 */
		public function KeyframeAnimations() {
			super();
			_player = new AnimationPlayer();
		}
		
		/**
		 * @private
		 */
		private function _updateAnimtionPlayer():void {
			_player._update(Laya.timer.delta);
		}
		
		/**
		 * @private
		 */
		private function _addUpdatePlayerToTimer():void {
			Laya.timer.frameLoop(1, this, _updateAnimtionPlayer);
		}
		
		/**
		 * @private
		 */
		private function _removeUpdatePlayerToTimer():void {
			Laya.timer.clear(this, _updateAnimtionPlayer);
		}
		
		/**
		 * @private
		 */
		private function _onOwnerActiveHierarchyChanged(active:Boolean):void {
			if ((_owner as Sprite3D).displayedInStage) {
				if (active)
					_addUpdatePlayerToTimer();
				else
					_removeUpdatePlayerToTimer();
			}
		}
		
		/**
		 * @private
		 * 载入组件时执行
		 */
		override public function _load(owner:ComponentNode):void {
			((owner as Sprite3D).activeInHierarchy) && (_addUpdatePlayerToTimer());
			owner.on(Event.ACTIVE_IN_HIERARCHY_CHANGED, this, _onOwnerActiveHierarchyChanged);
		}
		
		/**
		 * @private
		 * 卸载组件时执行
		 */
		override public function _unload(owner:ComponentNode):void {
			super._unload(owner);
			((owner as Sprite3D).activeInHierarchy) && (_removeUpdatePlayerToTimer());
			owner.off(Event.ACTIVE_IN_HIERARCHY_CHANGED, this, _onOwnerActiveHierarchyChanged);
			_player._destroy();
			_player = null;
			_templet = null;
		}
	}

}