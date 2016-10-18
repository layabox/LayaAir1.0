package laya.device.media
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.Utils;
	
	/**
	 * <code>Video</code>将视频显示到Canvas上。<code>Video</code>可能不会在所有浏览器有效。
	 * <p>关于Video支持的所有事件参见：<i>http://www.w3school.com.cn/tags/html_ref_audio_video_dom.asp</i>。</p>
	 * <p>
	 * <b>注意：</b><br/>
	 * 在PC端可以在任何时机调用<code>play()</code>因此，可以在程序开始运行时就使Video开始播放。但是在移动端，只有在用户第一次触碰屏幕后才可以调用play()，所以移动端不可能在程序开始运行时就自动开始播放Video。
	 * </p>
	 *
	 * <p>MDN Video链接： <i>https://developer.mozilla.org/en-US/docs/Web/HTML/Element/video</i></p>
	 */
	public class Video extends Sprite
	{
		public static var MP4:int = 1;
		public static var OGG:int = 2;
		public static var CAMERA:int = 4;
		public static var WEBM:int = 8;
		
		/** 表示最有可能支持。 */
		public static var SUPPORT_PROBABLY:String = "probably";
		/** 表示可能支持。*/
		public static var SUPPORT_MAYBY:String = "maybe";
		/** 表示不支持。 */
		public static var SUPPORT_NO:String = "";
		
		private var htmlVideo:HtmlVideo;
		private var videoElement:*;
		private var texture:Texture;
		
		public function Video(width:int = 320, height:int = 240)
		{
			super();
			
			if (Render.isWebGL)
				htmlVideo = new WebGLVideo();
			else
				htmlVideo = new HtmlVideo();

			videoElement = htmlVideo.getVideo();
			videoElement.layaTarget = this;
			
			texture = new Texture(htmlVideo);
			
			videoElement.addEventListener("abort", onAbort);
			videoElement.addEventListener("canplay", onCanplay);
			videoElement.addEventListener("canplaythrough", onCanplaythrough);
			videoElement.addEventListener("durationchange", onDurationchange);
			videoElement.addEventListener("emptied", onEmptied);
			videoElement.addEventListener("error", onError);
			videoElement.addEventListener("loadeddata", onLoadeddata);
			videoElement.addEventListener("loadedmetadata", onLoadedmetadata);
			videoElement.addEventListener("loadstart", onLoadstart);
			videoElement.addEventListener("pause", onPause);
			videoElement.addEventListener("play", onPlay);
			videoElement.addEventListener("playing", onPlaying);
			videoElement.addEventListener("progress", onProgress);
			videoElement.addEventListener("ratechange", onRatechange);
			videoElement.addEventListener("seeked", onSeeked);
			videoElement.addEventListener("seeking", onSeeking);
			videoElement.addEventListener("stalled", onStalled);
			videoElement.addEventListener("suspend", onSuspend);
			videoElement.addEventListener("timeupdate", onTimeupdate);
			videoElement.addEventListener("volumechange", onVolumechange);
			videoElement.addEventListener("waiting", onWaiting);
			videoElement.addEventListener("ended", onPlayComplete['bind'](this));
			
			size(width, height);
			if (Browser.onMobile)
			{
				__JS__("this.onDocumentClick = this.onDocumentClick.bind(this)");
				Browser.document.addEventListener("touchend", onDocumentClick);
			}
		}
		
		private static function onAbort(e:*):void  { e.target.layaTarget.event("abort") }
		
		private static function onCanplay(e:*):void  { e.target.layaTarget.event("canplay") }
		
		private static function onCanplaythrough(e:*):void  { e.target.layaTarget.event("canplaythrough") }
		
		private static function onDurationchange(e:*):void  { e.target.layaTarget.event("durationchange") }
		
		private static function onEmptied(e:*):void  { e.target.layaTarget.event("emptied") }
		
		private static function onError(e:*):void  { e.target.layaTarget.event("error") }
		
		private static function onLoadeddata(e:*):void  { e.target.layaTarget.event("loadeddata") }
		
		private static function onLoadedmetadata(e:*):void  { e.target.layaTarget.event("loadedmetadata") }
		
		private static function onLoadstart(e:*):void  { e.target.layaTarget.event("loadstart") }
		
		private static function onPause(e:*):void  { e.target.layaTarget.event("pause") }
		
		private static function onPlay(e:*):void  { e.target.layaTarget.event("play") }
		
		private static function onPlaying(e:*):void  { e.target.layaTarget.event("playing") }
		
		private static function onProgress(e:*):void  { e.target.layaTarget.event("progress") }
		
		private static function onRatechange(e:*):void  { e.target.layaTarget.event("ratechange") }
		
		private static function onSeeked(e:*):void  { e.target.layaTarget.event("seeked") }
		
		private static function onSeeking(e:*):void  { e.target.layaTarget.event("seeking") }
		
		private static function onStalled(e:*):void  { e.target.layaTarget.event("stalled") }
		
		private static function onSuspend(e:*):void  { e.target.layaTarget.event("suspend") }
		
		private static function onTimeupdate(e:*):void  { e.target.layaTarget.event("timeupdate") }
		
		private static function onVolumechange(e:*):void  { e.target.layaTarget.event("volumechange") }
		
		private static function onWaiting(e:*):void  { e.target.layaTarget.event("waiting") }
		
		private function onPlayComplete(e:*):void
		{
			Laya.timer.clear(this, renderCanvas);
			this.event("ended");
		}
		
		/**
		 * 设置播放源。
		 * @param url	播放源路径。
		 */
		public function load(url:String):void
		{
			// Camera
			if (url.indexOf("blob:") == 0)
				videoElement.src = url;
			else
				htmlVideo.setSource(url, Video.MP4);
		}
		
		/**
		 * 开始播放视频。
		 */
		public function play():void
		{
			videoElement.play();
			Laya.timer.frameLoop(1, this, renderCanvas);
		}
		
		/**
		 * 暂停视频播放。
		 */
		public function pause():void
		{
			videoElement.pause();
			
			Laya.timer.clear(this, renderCanvas);
		}
		
		/**
		 * 重新加载视频。
		 */
		public function reload():void
		{
			videoElement.load();
		}
		
		/**
		 * 检测是否支持播放指定格式视频。
		 * @param type	参数为Video.MP4 / Video.OGG / Video.WEBM之一。
		 * @return
		 */
		public function canPlayType(type:int):String
		{
			var typeString:String;
			switch (type)
			{
			case Video.MP4: 
				typeString = "video/mp4";
				break;
			case Video.OGG: 
				typeString = "video/ogg";
				break;
			case Video.WEBM: 
				typeString = "video/webm";
				break;
			}
			return videoElement.canPlayType(typeString);
		}
		
		private function renderCanvas():void
		{
			if (readyState === 0)
				return;
			
			if (Render.isWebGL)
				htmlVideo['updateTexture']();
			
			this.graphics.clear();
			this.graphics.drawTexture(texture, 0, 0, this.width, this.height);
		}
		
		private function onDocumentClick():void
		{
			videoElement.play();
			videoElement.pause();
			Browser.document.removeEventListener("touchend", onDocumentClick);
		}
		
		/**
		 * buffered 属性返回 TimeRanges(JS)对象。TimeRanges 对象表示用户的音视频缓冲范围。缓冲范围指的是已缓冲音视频的时间范围。如果用户在音视频中跳跃播放，会得到多个缓冲范围。
		 * <p>buffered.length返回缓冲范围个数。如获取第一个缓冲范围则是buffered.start(0)和buffered.end(0)。以秒计。</p>
		 * @return
		 */
		public function get buffered():*
		{
			return videoElement.buffered;
		}
		
		/**
		 * 获取当前播放源路径。
		 */
		public function get currentSrc():String
		{
			return videoElement.currentSrc;
		}
		
		/**
		 * 设置和获取当前播放头位置。
		 */
		public function get currentTime():Number
		{
			return videoElement.currentTime;
		}
		
		public function set currentTime(value:Number):void
		{
			videoElement.currentTime = value;
			renderCanvas();
		}
		
		/**
		 * 设置和获取当前音量。
		 */
		public function set volume(value:Number):void
		{
			videoElement.volume = value;
		}
		
		public function get volume():Number
		{
			return videoElement.volume;
		}
		
		/**
		 * 表示视频元素的就绪状态：
		 * <ul>
		 * <li>0 = HAVE_NOTHING - 没有关于音频/视频是否就绪的信息</li>
		 * <li>1 = HAVE_METADATA - 关于音频/视频就绪的元数据</li>
		 * <li>2 = HAVE_CURRENT_DATA - 关于当前播放位置的数据是可用的，但没有足够的数据来播放下一帧/毫秒</li>
		 * <li>3 = HAVE_FUTURE_DATA - 当前及至少下一帧的数据是可用的</li>
		 * <li>4 = HAVE_ENOUGH_DATA - 可用数据足以开始播放</li>
		 * </ul>
		 */
		public function get readyState():*
		{
			return videoElement.readyState;
		}
		
		/**
		 * 获取视频源尺寸。ready事件触发后可用。
		 */
		public function get videoWidth():int
		{
			return videoElement.videoWidth;
		}
		
		public function get videoHeight():int
		{
			return videoElement.videoHeight;
		}
		
		/**
		 * 获取视频长度（秒）。ready事件触发后可用。
		 */
		public function get duration():Number
		{
			return videoElement.duration;
		}
		
		/**
		 * 返回音频/视频的播放是否已结束
		 */
		public function get ended():Boolean
		{
			return videoElement.ended;
		}
		
		/**
		 * 返回表示音频/视频错误状态的 MediaError（JS）对象。
		 */
		public function get error():Boolean
		{
			return videoElement.error;
		}
		
		/**
		 * 设置或返回音频/视频是否应在结束时重新播放。
		 */
		public function get loop():Boolean
		{
			return videoElement.loop;
		}
		
		public function set loop(value:Boolean):void
		{
			videoElement.loop = value;
		}
		
		/**
		 * playbackRate 属性设置或返回音频/视频的当前播放速度。如：
		 * <ul>
		 * <li>1.0 正常速度</li>
		 * <li>0.5 半速（更慢）</li>
		 * <li>2.0 倍速（更快）</li>
		 * <li>-1.0 向后，正常速度</li>
		 * <li>-0.5 向后，半速</li>
		 * </ul>
		 * <p>只有 Google Chrome 和 Safari 支持 playbackRate 属性。</p>
		 */
		public function get playbackRate():Number
		{
			return videoElement.playbackRate;
		}
		
		public function set playbackRate(value:Number):void
		{
			videoElement.playbackRate = value;
		}
		
		/**
		 * 获取和设置静音状态。
		 */
		public function get muted():Boolean
		{
			return videoElement.muted;
		}
		
		public function set muted(value:Boolean):void
		{
			videoElement.muted = value;
		}
		
		/**
		 * 返回视频是否暂停
		 */
		public function get paused():Boolean
		{
			return videoElement.paused;
		}
		
		/**
		 * preload 属性设置或返回是否在页面加载后立即加载视频。可赋值如下：
		 * <ul>
		 * <li>auto	指示一旦页面加载，则开始加载视频。</li>
		 * <li>metadata	指示当页面加载后仅加载音频/视频的元数据。</li>
		 * <li>none	指示页面加载后不应加载音频/视频。</li>
		 * </ul>
		 * @return
		 *
		 */
		public function get preload():String
		{
			return videoElement.preload;
		}
		
		public function set preload(value:String):void
		{
			videoElement.preload = value;
		}
		
		/**
		 * 参见 <i>http://www.w3school.com.cn/tags/av_prop_seekable.asp</i>。
		 * @return
		 *
		 */
		public function get seekable():*
		{
			return videoElement.seekable;
		}
		
		/**
		 * seeking 属性返回用户目前是否在音频/视频中寻址。
		 * 寻址中（Seeking）指的是用户在音频/视频中移动/跳跃到新的位置。
		 */
		public function get seeking():Boolean
		{
			return videoElement.seeking;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			if (paused) renderCanvas();
		}
		
		override public function size(width:Number, height:Number):Sprite
		{
			super.size(width, height)
			
			videoElement.width = width / Browser.pixelRatio;
			
			if (paused) renderCanvas();
			return this;
		}
		
		override public function set width(value:Number):void
		{
			videoElement.width = width / Browser.pixelRatio;
			super.width = value;
			if (paused) renderCanvas();
		}
		
		/**
		 * 销毁内部事件绑定。
		 */
		override public function destroy(detroyChildren:Boolean = true):void
		{
			super.destroy(detroyChildren);
			
			videoElement.removeEventListener("abort", onAbort);
			videoElement.removeEventListener("canplay", onCanplay);
			videoElement.removeEventListener("canplaythrough", onCanplaythrough);
			videoElement.removeEventListener("durationchange", onDurationchange);
			videoElement.removeEventListener("emptied", onEmptied);
			videoElement.removeEventListener("error", onError);
			videoElement.removeEventListener("loadeddata", onLoadeddata);
			videoElement.removeEventListener("loadedmetadata", onLoadedmetadata);
			videoElement.removeEventListener("loadstart", onLoadstart);
			videoElement.removeEventListener("pause", onPause);
			videoElement.removeEventListener("play", onPlay);
			videoElement.removeEventListener("playing", onPlaying);
			videoElement.removeEventListener("progress", onProgress);
			videoElement.removeEventListener("ratechange", onRatechange);
			videoElement.removeEventListener("seeked", onSeeked);
			videoElement.removeEventListener("seeking", onSeeking);
			videoElement.removeEventListener("stalled", onStalled);
			videoElement.removeEventListener("suspend", onSuspend);
			videoElement.removeEventListener("timeupdate", onTimeupdate);
			videoElement.removeEventListener("volumechange", onVolumechange);
			videoElement.removeEventListener("waiting", onWaiting);
			videoElement.removeEventListener("ended", onPlayComplete);
		}
		
		private function syncVideoPosition():void
		{
			var stage:Stage = Laya.stage;
			var rec:Rectangle;
			rec = Utils.getGlobalPosAndScale(this);
			
			var a:Number = stage._canvasTransform.a, d:Number = stage._canvasTransform.d;
			var x:Number = rec.x * stage.clientScaleX * a + stage.offset.x;
			var y:Number = rec.y * stage.clientScaleY * d + stage.offset.y;
			videoElement.style.left = x + 'px';
			;
			videoElement.style.top = y + 'px';
			videoElement.width = width / Browser.pixelRatio;
			videoElement.height = height / Browser.pixelRatio;
		}
	}
}