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
	 * <p>动画播放基类，提供了基础的动画播放控制方法和帧标签事件相关功能。</p>
	 * <p>可以继承此类，但不要直接实例化此类，因为有些方法需要由子类实现。</p>
	 */
	public class AnimationPlayerBase extends Sprite {
		/**动画播放顺序类型：正序播放。 */
		public static const WRAP_POSITIVE:int = 0;
		/**动画播放顺序类型：逆序播放。 */
		public static const WRAP_REVERSE:int = 1;
		/**动画播放顺序类型：pingpong播放(当按指定顺序播放完结尾后，如果继续播发，则会改变播放顺序)。 */
		public static const WRAP_PINGPONG:int = 2;
		/**
		 * 是否循环播放，调用play(...)方法时，会将此值设置为指定的参数值。
		 */
		public var loop:Boolean;
		/**
		 * <p>播放顺序类型：AnimationPlayerBase.WRAP_POSITIVE为正序播放，AnimationPlayerBase.WRAP_REVERSE为倒序播放，AnimationPlayerBase.WRAP_PINGPONG为pingpong播放(当按指定顺序播放完结尾后，如果继续播发，则会改变播放顺序)。</p>
		 * <p>默认为正序播放。</p>
		 */
		public var wrapMode:int = 0;
		/**@private 播放间隔(单位：毫秒)。*/
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
		 * 可以继承此类，但不要直接实例化此类，因为有些方法需要由子类实现。
		 */
		public function AnimationPlayerBase() {
			_setUpNoticeType(Node.NOTICE_DISPLAY);
		}
		
		/**
		 * <p>开始播放动画。play(...)方法被设计为在创建实例后的任何时候都可以被调用，当相应的资源加载完毕、调用动画帧填充方法(set frames)或者将实例显示在舞台上时，会判断是否正在播放中，如果是，则进行播放。</p>
		 * <p>配合wrapMode属性，可设置动画播放顺序类型。</p>
		 * @param	start	（可选）指定动画播放开始的索引(int)或帧标签(String)。帧标签可以通过addLabel(...)和removeLabel(...)进行添加和删除。
		 * @param	loop	（可选）是否循环播放。
		 * @param	name	（可选）动画名称。
		 * @param	showWarn（可选）是否动画不存在时打印警告
		 */
		public function play(start:* = 0, loop:Boolean = true, name:String = "",showWarn:Boolean=true):void {
			this._isPlaying = true;
			this.index = (start is String) ? _getFrameByLabel(start) : start;
			this.loop = loop;
			this._actionName = name;
			_isReverse = wrapMode == WRAP_REVERSE;
			if (this.interval > 0) {
				timerLoop(this.interval, this, _frameLoop, null, true, true);
			}
		}
		
		/**
		 * <p>动画播放的帧间隔时间(单位：毫秒)。默认值依赖于Config.animationInterval=50，通过Config.animationInterval可以修改默认帧间隔时间。</p>
		 * <p>要想为某动画设置独立的帧间隔时间，可以使用set interval，注意：如果动画正在播放，设置后会重置帧循环定时器的起始时间为当前时间，也就是说，如果频繁设置interval，会导致动画帧更新的时间间隔会比预想的要慢，甚至不更新。</p>
		 */
		public function get interval():int {
			return _interval;
		}
		
		public function set interval(value:int):void {
			if (_interval != value) {
				_frameRateChanged = true;
				_interval = value;
				if (_isPlaying && value > 0) {
					timerLoop(value, this, _frameLoop, null, true, true);
				}
			}
		}
		
		/**@private */
		protected function _getFrameByLabel(label:String):int {
			var i:int;
			for (i = 0; i < _count; i++) {
				if (_labels[i] && (_labels[i] as Array).indexOf(label) >= 0) return i;
			}
			return 0;
		}
		
		/**@private */
		protected function _frameLoop():void {
			if (_isReverse) {
				this._index--;
				if (this._index < 0) {
					if (loop) {
						if (wrapMode == WRAP_PINGPONG) {
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
						if (wrapMode == WRAP_PINGPONG) {
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
				_controlNode.off(Event.DISPLAY, this, _checkResumePlaying);
				_controlNode.off(Event.UNDISPLAY, this, _checkResumePlaying);
			}
			_controlNode = node;
			if (node && node != this) {
				node.on(Event.DISPLAY, this, _checkResumePlaying);
				node.on(Event.UNDISPLAY, this, _checkResumePlaying);
			}
		}
		
		/**@private */
		override public function _setDisplay(value:Boolean):void {
			super._setDisplay(value);
			_checkResumePlaying();
		}
		
		/**@private */
		protected function _checkResumePlaying():void {
			if (_isPlaying) {
				if (_controlNode.displayedInStage) play(_index, loop, _actionName);
				else clearTimer(this, _frameLoop);
			}
		}
		
		/**
		 * 停止动画播放。
		 */
		public function stop():void {
			this._isPlaying = false;
			clearTimer(this, _frameLoop);
		}
		
		/**
		 * 是否正在播放中。
		 */
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		/**
		 * 增加一个帧标签到指定索引的帧上。当动画播放到此索引的帧时会派发Event.LABEL事件，派发事件是在完成当前帧画面更新之后。
		 * @param	label	帧标签名称
		 * @param	index	帧索引
		 */
		public function addLabel(label:String, index:int):void {
			if (!_labels) _labels = {};
			if (!_labels[index]) _labels[index] = [];
			_labels[index].push(label);
		}
		
		/**
		 * 删除指定的帧标签。
		 * @param	label 帧标签名称。注意：如果为空，则删除所有帧标签！
		 */
		public function removeLabel(label:String):void {
			if (!label) _labels = null;
			else if (_labels) {
				for (var name:String in _labels) {
					_removeLabelFromLabelList(_labels[name], label);
				}
			}
		}
		
		/**@private */
		private function _removeLabelFromLabelList(list:Array, label:String):void {
			if (!list) return;
			for (var i:int = list.length - 1; i >= 0; i--) {
				if (list[i] == label) {
					list.splice(i, 1);
				}
			}
		}
		
		/**
		 * 将动画切换到指定帧并停在那里。
		 * @param	position 帧索引或帧标签
		 */
		public function gotoAndStop(position:*):void {
			this.index = (position is String) ? _getFrameByLabel(position) : position;
			this.stop();
		}
		
		/**
		 * 动画当前帧的索引。
		 */
		public function get index():int {
			return _index;
		}
		
		public function set index(value:int):void {
			_index = value;
			_displayToIndex(value);
			if (_labels && _labels[value]) {
				var tArr:Array = _labels[value];
				for (var i:int = 0, len:int = tArr.length; i < len; i++) {
					event(Event.LABEL, tArr[i]);
				}
			}
		}
		
		/**
		 * @private
		 * 显示到某帧
		 * @param value 帧索引
		 */
		protected function _displayToIndex(value:int):void {
		}
		
		/**
		 * 当前动画中帧的总数。
		 */
		public function get count():int {
			return _count;
		}
		
		/**
		 * 停止动画播放，并清理对象属性。之后可存入对象池，方便对象复用。
		 */
		public function clear():void {
			stop();
			this._labels = null;
		}
	}
}