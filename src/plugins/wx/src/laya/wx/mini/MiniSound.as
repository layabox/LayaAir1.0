package laya.wx.mini {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.media.SoundManager;
	import laya.net.URL;
	import laya.utils.Handler;
	
	/** @private **/
	public class MiniSound extends EventDispatcher {
		/**@private **/
		private static var _musicAudio:*;
		/**@private **/
		private static var _id:int = 0;
		/**@private **/
		private var _sound:*;
		/**
		 * @private
		 * 声音URL
		 */
		public var url:String;
		/**
		 * @private
		 * 是否已加载完成
		 */
		public var loaded:Boolean = false;
		/**@private **/
		public var readyUrl:String;
		/**@private **/
		public static var _audioCache:Object = {};
		
		public function MiniSound() {
			//_sound = _createSound();
		}
		
		/** @private **/
		private static function _createSound():* {
			_id++;
			return MiniAdpter.window.wx.createInnerAudioContext();
		}
		
		/**
		 * @private
		 * 加载声音。
		 * @param url 地址。
		 *
		 */
		public function load(url:String):void {
			if (!MiniFileMgr.isLocalNativeFile(url)) {
				url = URL.formatURL(url);
			}else
			{
				if (url.indexOf("http://") != -1 || url.indexOf("https://") != -1)
				{
					if(MiniFileMgr.loadPath != "")
					{
						url = url.split(MiniFileMgr.loadPath)[1];//去掉http头
					}else
					{
						var tempStr:String = URL.rootPath != "" ? URL.rootPath : URL._basePath;
						if(tempStr != "")
							url = url.split(tempStr)[1];//去掉http头
					}
				}
			}
			this.url = url;
			this.readyUrl = url;
			if (_audioCache[this.readyUrl]) {
				event(Event.COMPLETE);
				return;
			}
			if(MiniAdpter.autoCacheFile&&MiniFileMgr.getFileInfo(url))
			{
				onDownLoadCallBack(url,0);
			}else
			{
				if(!MiniAdpter.autoCacheFile)
				{
					onDownLoadCallBack(url,0);
				}else
				{
                    if (MiniFileMgr.isLocalNativeFile(url))
					{
						tempStr = URL.rootPath != "" ? URL.rootPath : URL._basePath;
                        var tempUrl:String = url;
                        if(tempStr != "")
                            url = url.split(tempStr)[1];//去掉http头
                        if (!url){
                            url = tempUrl;
                        }
						//分包目录资源加载处理
						if (MiniAdpter.subNativeFiles && MiniAdpter.subNativeheads.length == 0)
						{
							for (var key:* in MiniAdpter.subNativeFiles)
							{
								var tempArr:Array = MiniAdpter.subNativeFiles[key];
								MiniAdpter.subNativeheads = MiniAdpter.subNativeheads.concat(tempArr);
								for (var aa:int = 0; aa < tempArr.length;aa++)
								{
									MiniAdpter.subMaps[tempArr[aa]] = key + "/" + tempArr[aa];
								}
							}
						}
						//判断当前的url是否为分包映射路径
						if(MiniAdpter.subNativeFiles && url.indexOf("/") != -1)
						{
							var curfileHead:String = url.split("/")[0] + "/";//文件头
							if(curfileHead && MiniAdpter.subNativeheads.indexOf(curfileHead) != -1)
							{
								var newfileHead:String = MiniAdpter.subMaps[curfileHead];
								url = url.replace(curfileHead,newfileHead);
							}
						}
                        onDownLoadCallBack(url,0);
					}else
					{
						if (!MiniFileMgr.isLocalNativeFile(url) &&  (url.indexOf("http://") == -1 && url.indexOf("https://") == -1) || (url.indexOf("http://usr/") != -1)) {
							this.onDownLoadCallBack(url, 0);
						}else
						{
							MiniFileMgr.downOtherFiles(url, Handler.create(this, this.onDownLoadCallBack, [url]), url);
						}
					}
				}
			}
		}
		
		/**@private **/
		private function onDownLoadCallBack(sourceUrl:String,errorCode:int):void
		{
			if (!errorCode)
			{
				var fileNativeUrl:String;
				if(MiniAdpter.autoCacheFile)
				{
					if (MiniFileMgr.isLocalNativeFile(sourceUrl)) {
						var tempStr:String = URL.rootPath != "" ? URL.rootPath : URL._basePath;
						var tempUrl:String = sourceUrl;
						if(tempStr != "" && (sourceUrl.indexOf("http://") != -1 || sourceUrl.indexOf("https://") != -1))
							fileNativeUrl = sourceUrl.split(tempStr)[1];//去掉http头
						if(!fileNativeUrl)
						{
							fileNativeUrl = tempUrl;
						}
					}else
					{
						var fileObj:Object = MiniFileMgr.getFileInfo(sourceUrl);
						if(fileObj && fileObj.md5)
						{
							var fileMd5Name:String = fileObj.md5;
							fileNativeUrl = MiniFileMgr.getFileNativePath(fileMd5Name);
						}else
						{
							fileNativeUrl = sourceUrl;
						}
					}
					_sound = _createSound();
					_sound.src = url =  fileNativeUrl;
				}else
				{
					_sound = _createSound();
					_sound.src = sourceUrl;
				}
				
				_sound.onCanplay(bindToThis(onCanPlay,this));
				_sound.onError(bindToThis(onError,this));
			}else
			{
				this.event(Event.ERROR);
			}
		}
		
		/**@private **/
		private function onError(error:*):void
		{
			try
			{
				trace("-----1---------------minisound-----id:" + _id);
				trace(error);
			} 
			catch(error:Error) 
			{
				trace("-----2---------------minisound-----id:" + _id);
				trace(error);
			}
			this.event(Event.ERROR);
			_sound.offError(null);
		}
			
		/**@private **/
		private function onCanPlay():void
		{
			this.loaded = true;
			this.event(Event.COMPLETE);
			//_audioCache[this.readyUrl] = this;
			_sound.offCanplay(null);
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
		
		/**
		 * @private
		 * 播放声音。
		 * @param startTime 开始时间,单位秒
		 * @param loops 循环次数,0表示一直循环
		 * @return 声道 SoundChannel 对象。
		 *
		 */
		public function play(startTime:Number = 0, loops:Number = 0):MiniSoundChannel {
			var tSound:*;
			if (url == SoundManager._bgMusic) {
				if (!_musicAudio) _musicAudio = _createSound();
				tSound = _musicAudio;
			} else {
				if(_audioCache[readyUrl])
				{
					tSound = _audioCache[readyUrl]._sound;
				}else
				{
					tSound = _createSound();
				}
			}
			if(!tSound)
				return null;
			if(MiniAdpter.autoCacheFile&&MiniFileMgr.getFileInfo(url))
			{
				var fileNativeUrl:String;
				var fileObj:Object = MiniFileMgr.getFileInfo(url);
				var fileMd5Name:String = fileObj.md5;
				tSound.src = this.url =MiniFileMgr.getFileNativePath(fileMd5Name);
			}else
			{
				tSound.src = this.url;
			}
			var channel:MiniSoundChannel = new MiniSoundChannel(tSound,this);
			channel.url = this.url;
			channel.loops = loops;
			channel.loop = (loops === 0 ? true : false);
			channel.startTime = startTime;
			channel.play();
			SoundManager.addChannel(channel);
			return channel;
		}
		
		/**
		 * @private
		 * 获取总时间。
		 */
		public function get duration():Number {
			return _sound.duration;
		}
		
		/**
		 * @private
		 * 释放声音资源。
		 *
		 */
		public function dispose():void {
			var ad:* = _audioCache[this.readyUrl];
			if (ad) {
				ad.src = "";
				if(ad._sound)
				{
					ad._sound.destroy();	
					ad._sound =null;
					ad =null;
				}
				delete _audioCache[this.readyUrl];
			}
		}
	}
}