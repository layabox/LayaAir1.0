package laya.display
{
	import laya.events.Event;
	import laya.events.EventDispatcher;	
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
	 * 
	 */
	public class AnimationPlayerBase extends Sprite
	{
		public function AnimationPlayerBase()
		{
		}
		/** 播放间隔(单位：毫秒)。*/
		public var interval:int = Config.animationInterval;
		/**是否循环播放 */
		public var loop:Boolean;
		/**@private */
		protected var _index:int;
		/**@private */
		protected var _count:int;
		/**@private */
		protected var _isPlaying:Boolean;
		/**@private */
		protected var _labels:Object;
		/**@private */
		private var _controlNode:Sprite;
		
		/**
		 * 播放动画。
		 * @param	start 开始播放的动画索引。
		 * @param	loop 是否循环。
		 * @param	name 如果name为空(可选)，则播放当前动画，如果不为空，则播放全局缓存动画（如果有）
		 */
		public function play(start:int = 0, loop:Boolean = true, name:String = ""):void {
			this._isPlaying = true;
			this.index = start;
			this.loop = loop;
			if (this.interval > 0) {
				_index++;
				Laya.timer.loop(this.interval, this, _frameLoop, null, true);
			}
		}
		/**@private */
		protected function _frameLoop():void {		
			this.index = _index, _index++;
			if (this._index >= this._count) {
				if (loop) this._index = 0;
				else {
					_index--;
					stop();
				}
				event(Event.COMPLETE);
			}		
		}
		/**@private */
		public function _setControlNode(node:Sprite):void
		{
			if(_controlNode)
			{
				_controlNode.off(Event.DISPLAY, this, _onDisplay);
				_controlNode.off(Event.UNDISPLAY, this, _onDisplay);
			}
			_controlNode=node;
			if(node)
			{
				node.on(Event.DISPLAY, this, _onDisplay);
				node.on(Event.UNDISPLAY, this, _onDisplay);
			}
			
		}
		/**@private */
		private function _onDisplay():void {
			if (_isPlaying) {
				if (_controlNode.displayedInStage) play(_index, loop);
				else Laya.timer.clear(this, _frameLoop);
			}
		}
		/**
		 * 停止播放。
		 */
		public function stop():void {
			this._isPlaying = false;
			Laya.timer.clear(this, _frameLoop);
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
			else if (!_labels) {
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
		 * @param	index 帧索引
		 */
		public function gotoAndStop(index:int):void {
			this.index = index;
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
		protected function _displayToIndex(value:int):void
		{			
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