package laya.display {
	import laya.events.Event;
	
	/**
	 * 动画播放完毕后调度。
	 * @eventType Event.COMPLETE
	 */
	[Event(name = "complete", type = "laya.events.Event")]
	
	/**
	 * 播放到某标签后调度。
	 * @eventType Event.LABEL
	 */
	[Event(name = "label", type = "laya.events.Event")]
	
	/**
	 *  动画播放控制器
	 */
	public class AnimationPlayerBase extends Sprite {
		/**是否循环播放 */
		public var loop:Boolean;
		/**播放类型：0为正序播放，1为倒序播放，2为pingpong播放*/
		public var wrapMode:int = 0;
		/** 播放间隔(单位：毫秒)。*/
		protected var _interval:int = Config.animationInterval;
		/**@private */
		protected var _index:int;
		/**@private */
		protected var _count:int;
		/**@private */
		protected var _isPlaying:Boolean;
		/**@private */
		protected var _labels:Object;
		/**是否是逆序播放*/
		protected var _isReverse:Boolean = false;
		/**@private */
		protected var _frameRateChanged:Boolean = false;
		/**@private */
		private var _controlNode:Sprite;
		/**@private */
		protected var _actionName:String;
		
		/**
		 * 播放动画。
		 * @param	start 开始播放的动画索引或label。
		 * @param	loop 是否循环。
		 * @param	name 如果name为空(可选)，则播放当前动画，如果不为空，则播放全局缓存动画（如果有）
		 */
		public function play(start:* = 0, loop:Boolean = true, name:String = ""):void {
			this._isPlaying = true;
			this.index = (start is String) ? _getFrameByLabel(start) : start;
			this.loop = loop;
			this._actionName = name;
			_isReverse = wrapMode == 1;
			if (this.interval > 0) {
				timerLoop(this.interval, this, _frameLoop, null, true);
			}
		}
		
		/** 播放间隔(单位：毫秒)。*/
		public function set interval(value:int):void {
			if (_interval != value) {
				_frameRateChanged = true;
				_interval = value;
				if (_isPlaying && value > 0) {
					timerLoop(value, this, _frameLoop, null, true);
				}
			}
		}
		
		/** 播放间隔(单位：毫秒)。*/
		public function get interval():int {
			return _interval;
		}
		
		/**@private */
		protected function _getFrameByLabel(label:String):int {
			var i:int;
			for (i = 0; i < _count; i++) {
				if (_labels[i] == label) return i;
			}
			return 0;
		}
		
		/**@private */
		protected function _frameLoop():void {
			if (_isReverse) {
				this._index--;
				if (this._index < 0) {
					if (loop) {
						if (wrapMode == 2) {
							this._index = this._count > 0 ? 1 : 0;
							_isReverse = false;
						} else {
							this._index = this._count - 1;
						}
						event(Event.COMPLETE);
					} else {
						this._index = 0;
						stop();
						event(Event.COMPLETE);
						return;
					}
				}
			} else {
				this._index++;
				if (this._index >= this._count) {
					if (loop) {
						if (wrapMode == 2) {
							this._index = this._count - 2 >= 0 ? this._count - 2 : 0;
							_isReverse = true;
						} else {
							this._index = 0;
						}
						event(Event.COMPLETE);
					} else {
						this._index--;
						stop();
						event(Event.COMPLETE);
						return;
					}
				}
			}
			this.index = this._index;
		}
		
		/**@private */
		public function _setControlNode(node:Sprite):void {
			if (_controlNode) {
				_controlNode.off(Event.DISPLAY, this, _onDisplay);
				_controlNode.off(Event.UNDISPLAY, this, _onDisplay);
			}
			_controlNode = node;
			if (node && node != this) {
				node.on(Event.DISPLAY, this, _onDisplay);
				node.on(Event.UNDISPLAY, this, _onDisplay);
			}
		}
		
		/**@private */
		override public function _setDisplay(value:Boolean):void {
			super._setDisplay(value);
			_onDisplay();
		}
		
		/**@private */
		private function _onDisplay():void {
			if (_isPlaying) {
				if (_controlNode.displayedInStage) play(_index, loop, _actionName);
				else clearTimer(this, _frameLoop);
			}
		}
		
		/**
		 * 停止播放。
		 */
		public function stop():void {
			this._isPlaying = false;
			clearTimer(this, _frameLoop);
		}
		
		/**
		 * 是否在播放中
		 */
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		/**
		 * 增加一个标签到index帧上，播放到此index后会派发label事件
		 * @param	label	标签名称
		 * @param	index	索引位置
		 */
		public function addLabel(label:String, index:int):void {
			if (!_labels) _labels = {};
			_labels[index] = label;
		}
		
		/**
		 * 删除某个标签
		 * @param	label 标签名字，如果label为空，则删除所有Label
		 */
		public function removeLabel(label:String):void {
			if (!label) _labels = null;
			else if (_labels) {
				for (var name:String in _labels) {
					if (_labels[name] === label) {
						delete _labels[name];
						break;
					}
				}
			}
		}
		
		/**
		 * 切换到某帧并停止
		 * @param	position 帧索引或label
		 */
		public function gotoAndStop(position:*):void {
			this.index = (position is String) ? _getFrameByLabel(position) : position;
			this.stop();
		}
		
		/**当前播放索引。*/
		public function get index():int {
			return _index;
		}
		
		public function set index(value:int):void {
			_index = value;
			_displayToIndex(value);
			if (_labels && _labels[value]) event(Event.LABEL, _labels[value]);
		}
		
		/**
		 * @private
		 * 显示到某帧
		 * @param value 帧索引
		 *
		 */
		protected function _displayToIndex(value:int):void {
		}
		
		/**动画长度。*/
		public function get count():int {
			return _count;
		}
		
		/**清理。方便对象复用。*/
		public function clear():void {
			stop();
			this._labels = null;
		}
	}
}