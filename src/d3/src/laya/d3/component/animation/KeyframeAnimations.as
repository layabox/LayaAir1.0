package laya.d3.component.animation {
	import laya.ani.AnimationPlayer;
	import laya.ani.AnimationState;
	import laya.ani.KeyframesAniTemplet;
	import laya.d3.component.Component3D;
	import laya.d3.core.Sprite3D;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.resource.Resource;
	
	/**
	 * 在动画加载完成后调度。
	 * @eventType Event.LOADED
	 */
	[Event(name = "loaded", type = "laya.events.Event")]
	
	/**
	 * <code>KeyframeAnimation</code> 类用于帧动画组件的父类。
	 */
	public class KeyframeAnimations extends Component3D {
		/** @private */
		protected var _url:String;
		/**动画播放器。*/
		protected var _player:AnimationPlayer;
		/** @private */
		public var _templet:KeyframesAniTemplet;
		
		/**
		 * 获取url地址。
		 * @return 地址。
		 */
		public function get url():String {
			return _url;
		}
		
		/**
		 * 获取动画播放器。
		 * @return 动画播放器。
		 */
		public function get player():AnimationPlayer {
			return _player;
		}
		
		/**
		 * 设置url地址。
		 * @param value 地址。
		 */
		public function set url(value:String):void {
			if (_player.state !== AnimationState.stopped)
				_player.stop(true);
			
			_url = URL.formatURL(value);
			
			var templet:KeyframesAniTemplet = Resource.animationCache[_url];
			
			var _this:KeyframeAnimations = this;
			if (!templet) {
				templet = Resource.animationCache[_url] = new KeyframesAniTemplet();
				_templet = templet;
				_player.templet = templet;
				var onComp:Function = function(data:ArrayBuffer):void {
					var arraybuffer:ArrayBuffer = data;
					templet.parse(arraybuffer);
				}
				var loader:Loader = new Loader();
				loader.once(Event.COMPLETE, null, onComp);
				loader.load(_url, Loader.BUFFER);
			} else {
				_templet = templet;
				_player.templet = templet
			}
	
			event(Event.ANIMATION_CHANGED, this);
			
			if (!templet.loaded)
				templet.once(Event.LOADED, null, function(e:KeyframesAniTemplet):void {
					_this.event(Event.LOADED, _this)
				});
			else {
				this.event(Event.LOADED, this);
			}
		}
		
		/**
		 * 获取播放器帧率。
		 * @return 播放器帧率。
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
		public function get NodeCount():int {
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
			_player.update(Laya.timer.delta);//为避免事件破坏for循环问题,需最先执行（如不则内部可能触发Stop事件等，如事件中加载新动画，可能_templet未加载完成，导致BUG）
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
		private function _onOwnerEnableChanged(enable:Boolean):void {
			if (_owner.isInStage) {
				if (enable)
					_addUpdatePlayerToTimer();
				else
					_removeUpdatePlayerToTimer();
			}
		}
		
		/**
		 * @private
		 */
		private function _onIsInStageChanged(isInStage:Boolean):void {
			if (_owner.enable) {
				if (isInStage)
					_addUpdatePlayerToTimer();
				else
					_removeUpdatePlayerToTimer();
			}
		}
		
		/**
		 * @private
		 * 载入组件时执行
		 */
		override public function _load(owner:Sprite3D):void {
			(_owner.isInStage && _owner.enable) && (_addUpdatePlayerToTimer());
			_owner.on(Event.ENABLED_CHANGED, this, _onOwnerEnableChanged);
			_owner.on(Event.INSTAGE_CHANGED, this, _onIsInStageChanged);
		}
		
		/**
		 * @private
		 * 卸载组件时执行
		 */
		override public function _unload(owner:Sprite3D):void {
			(_owner.isInStage && _owner.enable) && (_removeUpdatePlayerToTimer());
			_owner.off(Event.ENABLED_CHANGED, this, _onOwnerEnableChanged);
			_owner.off(Event.INSTAGE_CHANGED, this, _onIsInStageChanged);
		}
		
		/**
		 * 停止播放当前动画
		 * @param	immediate 是否立即停止
		 */
		public function stop(immediate:Boolean = true):void {
			_player.stop(immediate);
		}
	
	}

}