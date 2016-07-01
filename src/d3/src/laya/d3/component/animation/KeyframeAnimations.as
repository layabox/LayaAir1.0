package laya.d3.component.animation {
	import laya.ani.AnimationPlayer;
	import laya.ani.AnimationState;
	import laya.ani.KeyframesAniTemplet;
	import laya.d3.component.Component3D;
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
		/** @private */
		public var _templet:KeyframesAniTemplet;
		/**动画播放器。*/
		public var player:AnimationPlayer;
		
		/**
		 * 获取url地址。
		 * @return 地址。
		 */
		public function get url():String {
			return _url;
		}
		
		/**
		 * 设置url地址。
		 * @param value 地址。
		 */
		public function set url(value:String):void {
			if (player.State !== AnimationState.stopped)
				player.stop(true);
			
			_url = URL.formatURL(value);
			
			var templet:KeyframesAniTemplet = Resource.animationCache[_url];
			
			var _this:KeyframeAnimations = this;
			if (!templet) {
				templet = Resource.animationCache[_url] = new KeyframesAniTemplet();
				_templet = templet;
				player.templet = templet;
				var onComp:Function = function(data:ArrayBuffer):void {
					var arraybuffer:ArrayBuffer = data;
					templet.parse(arraybuffer, player.cacheFrameRate);
				}
				var loader:Loader = new Loader();
				loader.once(Event.COMPLETE, null, onComp);
				loader.load(_url, Loader.BUFFER);
			} else {
				_templet = templet;
				player.templet = templet
			}
			
			if (!templet.loaded)
				templet.once(Event.LOADED, null, function(e:KeyframesAniTemplet):void { _this.event(Event.LOADED, _this)
				});
			else
				this.event(Event.LOADED, this);
		}
		
		/**
		 * 获取播放器帧率。
		 * @return 播放器帧率。
		 */
		public function get currentFrameIndex():int {
			return player.currentKeyframeIndex;
		}
		
		/**
		 * 获取播放器的动画索引。
		 * @return 动画索引。
		 */
		public function get currentAnimationClipIndex():int {
			return player.currentAnimationClipIndex;
		}
		
		/**
		 * 获取播放器是否暂停。
		 * @return 是否暂停。
		 */
		public function get paused():Boolean {
			return player.paused;
		}
		
		/**
		 * 设置播放器是否暂停。
		 * @param value 是否暂停。
		 */
		public function set paused(value:Boolean):void {
			player.paused = value;
		}
		
		/**
		 * 获取播放器的缓存帧率。
		 * @return 缓存帧率。
		 */
		public function get cacheFrameRate():int {
			return player.cacheFrameRate;
		}
		
		//public function set cacheFrameRate(value:int):void {
		//player.cacheFrameRate = value;
		//}
		
		/**
		 * 获取播放器当前动画的节点数量。
		 * @return 节点数量。
		 */
		public function get NodeCount():int {
			return _templet.getNodeCount(player.currentAnimationClipIndex);
		}
		
		/**
		 * 创建一个新的 <code>KeyframeAnimation</code> 实例。
		 */
		public function KeyframeAnimations() {
			super();
			player = new AnimationPlayer();
		}
		
		/**
		 * 播放动画。
		 * @param	index 动画索引。
		 * @param	playbackRate 播放速率。
		 * @param	duration 播放时长（Number.MAX_VALUE为循环播放，0为1次）。
		 */
		public function play(index:int = 0, playbackRate:Number = 1.0, duration:Number = Number.MAX_VALUE):void {
			player.play(index, playbackRate, duration);
		}
		
		/**
		 * 停止播放当前动画
		 * @param	immediate 是否立即停止
		 */
		public function stop(immediate:Boolean = true):void {
			player.stop(immediate);
		}
	
	}

}