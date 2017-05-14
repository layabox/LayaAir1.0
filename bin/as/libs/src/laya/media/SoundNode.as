package laya.media {
	
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.utils.Handler;
	
	/**
	 * @private
	 */
	public class SoundNode extends Sprite {
		public var url:String;
		private var _channel:SoundChannel;
		private var _tar:Sprite;
		private var _playEvents:String;
		private var _stopEvents:String;
		
		public function SoundNode() {
			super();
			visible = false;
			on(Event.ADDED, this, _onParentChange);
			on(Event.REMOVED, this, _onParentChange);
		}
		
		/**@private */
		private function _onParentChange():void {
			
			target = parent as Sprite;
		}
		
		/**
		 * 播放
		 * @param loops 循环次数
		 * @param complete 完成回调
		 *
		 */
		public function play(loops:int = 1, complete:Handler = null):void {
			if (isNaN(loops)) {
				loops = 1;
			}
			if (!url) return;
			stop();
			_channel = SoundManager.playSound(url, loops, complete);
		}
		
		/**
		 * 停止播放
		 *
		 */
		public function stop():void {
			if (_channel && !_channel.isStopped) {
				_channel.stop();
			}
			_channel = null;
		}
		
		/**@private */
		private function _setPlayAction(tar:Sprite, event:String, action:String, add:Boolean = true):void {
			if (!this[action]) return;
			if (!tar) return;
			if (add) {
				tar.on(event, this, this[action]);
			} else {
				tar.off(event, this, this[action]);
			}
		
		}
		
		/**@private */
		private function _setPlayActions(tar:Sprite, events:String, action:String, add:Boolean = true):void {
			if (!tar) return;
			if (!events) return;
			var eventArr:Array = events.split(",");
			var i:int, len:int;
			len = eventArr.length;
			for (i = 0; i < len; i++) {
				_setPlayAction(tar, eventArr[i], action, add);
			}
		}
		
		/**
		 * 设置触发播放的事件
		 * @param events
		 *
		 */
		public function set playEvent(events:String):void {
			_playEvents = events;
			if (!events) return;
			if (_tar) {
				_setPlayActions(_tar, events, "play");
			}
		}
		
		/**
		 * 设置控制播放的对象
		 * @param tar
		 *
		 */
		public function set target(tar:Sprite):void {
			if (_tar) {
				_setPlayActions(_tar, _playEvents, "play", false);
				_setPlayActions(_tar, _stopEvents, "stop", false);
			}
			_tar = tar;
			if (_tar) {
				_setPlayActions(_tar, _playEvents, "play", true);
				_setPlayActions(_tar, _stopEvents, "stop", true);
			}
		}
		
		/**
		 * 设置触发停止的事件
		 * @param events
		 *
		 */
		public function set stopEvent(events:String):void {
			_stopEvents = events;
			if (!events) return;
			if (_tar) {
				_setPlayActions(_tar, events, "stop");
			}
		}
	}

}