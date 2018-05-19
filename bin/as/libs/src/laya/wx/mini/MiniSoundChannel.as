package laya.wx.mini {
	import laya.events.Event;
	import laya.media.SoundChannel;
	import laya.media.SoundManager;
	
	/** @private **/
	public class MiniSoundChannel extends SoundChannel {
		/**@private **/
		private var _audio:*;
		/**@private **/
		private var _onEnd:Function;
		/**@private **/
		private var _miniSound:MiniSound;
		public function MiniSoundChannel(audio:*,miniSound:MiniSound) {
			this._audio = audio;
			this._miniSound = miniSound;
			this._onEnd = bindToThis(this.__onEnd, this);
			audio.onEnded(this._onEnd);
		}
		/**
		 * @private 
		 * 给传入的函数绑定作用域，返回绑定后的函数。
		 * @param	fun 函数对象。
		 * @param	scope 函数作用域。
		 * @return 绑定后的函数。
		 */
		public static function bindToThis(fun:Function, scope:*):Function {
			var rst:Function = fun;
			__JS__("rst=fun.bind(scope);");
			return rst;
		}
		
		/**@private **/
		private function __onEnd():void {
			if (this.loops == 1) {
				if (completeHandler) {
					Laya.timer.once(10, this, __runComplete, [completeHandler], false);
					completeHandler = null;
				}
//				trace("-------------------__onEnd-------sound-yinxiao------------------");
				this.stop();
				event(Event.COMPLETE);
				return;
			}
			if (this.loops > 0) {
				this.loops--;
			}
			this.startTime = 0;
//			trace("-------------------__onEnd-------sound-beijing------------------");
			this.play();
		}
		
		
		
		/**
		 * @private 
		 * 播放
		 */
		override public function play():void {
			this.isStopped = false;
			SoundManager.addChannel(this);
			this._audio.play();
		}
		
			
		/**@private  **/
		public function set autoplay(value:Boolean):void
		{
			this._audio.autoplay = value;
		}
		/**
		 * @private 
		 * 自动播放 
		 * @param value
		 */	
		public function get autoplay():Boolean
		{
			return this._audio.autoplay;
		}
		
		/**
		 * @private 
		 * 当前播放到的位置
		 * @return
		 *
		 */
		override public function get position():Number {
			if (!this._audio)
				return 0;
			return _audio.currentTime;
		}
		
		/**
		 * @private 
		 * 获取总时间。
		 */
		override public function get duration():Number {
			if (!this._audio)
				return 0;
			return _audio.duration;
		}
		
		/**
		 * @private 
		 * 停止播放
		 *
		 */
		override public function stop():void {
//			trace("--------------stop--sound---------------------url:"+ this.url);
			this.isStopped = true;
			SoundManager.removeChannel(this);
			completeHandler = null;
			if (!this._audio)
				return;
			this._audio.pause();//停止播放
			this._audio.offEnded(null);
//			this._audio.destroy();//小游戏里声音销毁ios没问题，安卓存在问题。目前采用复用上次创建的实例，多次利用
//			this._miniSound.dispose();
			this._audio = null;
			this._miniSound = null;
			this._onEnd = null;
		}
		
		/**@private **/
		override public function pause():void {
			this.isStopped = true;
			_audio.pause();
		}
		
		/**@private **/
		public function get loop():Boolean
		{
			return _audio.loop;
		}
		/**@private **/
		public function set loop(value:Boolean):void
		{
			_audio.loop = value;
		}
		/**@private **/
		override public function resume():void {
			if (!_audio)
				return;
			this.isStopped = false;
			SoundManager.addChannel(this);
			_audio.play();
		}
		
		/**
		 * @private 
		 * 设置音量
		 * @param v
		 *
		 */
		override public function set volume(v:Number):void {
			if (!this._audio)return;
			this._audio.volume=v;
		}
		
		/**
		 * @private 
		 * 获取音量
		 * @return
		 */
		override public function get volume():Number {
			if (!this._audio)return 1;
			return this._audio.volume;
		}
	}	
}