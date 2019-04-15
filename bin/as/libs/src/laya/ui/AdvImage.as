package laya.ui
{
	import laya.events.Event;
	import laya.net.LocalStorage;
	import laya.utils.Browser;

	/**
	 * 广告插件 
	 * @author 小松
	 * @date -2018-09-19
	 */	
	public class AdvImage extends Image
	{
		/**广告列表数据**/
		private  var advsListArr:Array = [];
		/**资源列表请求地址**/
		private  var resUrl:String ="https://unioncdn.layabox.com/config/iconlist.json";
		/**加载请求实例**/
		private var _http:* = new Browser.window.XMLHttpRequest();
		/**广告列表信息**/
		private var _data:* = [];
		/**每6分钟重新请求一次新广告列表**/
		private var _resquestTime:int = 360000;
		/**微信跳转appid**/
		private var _appid:String;
		/**播放索引**/
		private  var _playIndex:int = 0;
		/**轮播间隔时间**/
		private var _lunboTime:int = 5000;
		public function AdvImage(skin:String=null)
		{
			this.skin = skin;
			setLoadUrl();
			init();
			this.size(120,120);
		}
		
		/**设置导量加载地址**/
		private function setLoadUrl():void
		{
			if(Browser.onLimixiu)
			{
				resUrl = "https://abc.layabox.com/public/wyw/gconfig.json";
			}
		}
		
		private function init():void
		{
			if(isSupportJump())
			{
				//这里需要去加载广告列表资源信息
				if(Browser.onMiniGame || Browser.onBDMiniGame)
				{
					Laya.timer.loop(_resquestTime,this,onGetAdvsListData);
				}
				onGetAdvsListData();
				initEvent();
			}else
				this.visible = false;
		}
		
		private function initEvent():void
		{
			this.on(Event.CLICK,this,onAdvsImgClick);
		}
		
		private function onAdvsImgClick():void
		{
			var currentJumpUrl:String = getCurrentAppidObj();
			if(currentJumpUrl)
				jumptoGame();
		}
		
		private function revertAdvsData():void
		{
			if(advsListArr[_playIndex])
			{
				this.visible = true;
				if(Browser.onLimixiu)
				{
					var ww:String = "https://abc.layabox.com/public/icon/";
					this.visible = true;
					var advsObj:Object = advsListArr[_playIndex];
					if(advsObj)
					{
						if(Browser.onLimixiu &&__JS__('GameStatusInfo').gameId == advsObj.gameid)
						{
							onLunbo();
						}else
						{
							this.skin = ww + advsObj.iconUrl;
							this.size(103,126);
						}
					}
				}else
				{
					this.skin = advsListArr[_playIndex];
				}
			}
		}
		
		/**当前小游戏环境是否支持游戏跳转功能**/
		public function  isSupportJump():Boolean
		{
			if(Browser.onMiniGame)
			{
				var isSupperJump:Boolean = __JS__('wx.navigateToMiniProgram') is Function;
				return isSupperJump;
			}else if(Browser.onLimixiu)
			{
				if(__JS__('BK').QQ.skipGame)
					return true;
			}else if(Browser.onBDMiniGame)
				return true;
			return false;
		}
		
		/**
		 * 跳转游戏 
		 * @param callBack Function 回调参数说明：type 0 跳转成功；1跳转失败；2跳转接口调用成功
		 */		
		private function jumptoGame():void
		{
			var advsObj:Object = advsListArr[_playIndex];
			var desGameId:int = parseInt(advsObj.gameid); //跳转的gameid，必须为数字
			var extendInfo:int = advsObj.extendInfo; //额外参数，必须为字符串
			var path:* = advsObj.path;//扩展数据
			if(Browser.onLimixiu)
			{
				//根据轮播状态处理数据，非轮播点击一次需要从数组中移除
				if(!advsObj.isLunBo)
				{
					//根据轮播状态处理数据，非轮播点击一次需要从数组中移除
					if(!advsObj.isLunBo)
					{
						//存储点击取消的游戏id数据
						var  gameAdvsObj:Object = LocalStorage.getJSON("gameObj");
						if(!gameAdvsObj)
						{
							gameAdvsObj = {};
						}
						if(!gameAdvsObj[advsObj.gameid])
						{
							gameAdvsObj[advsObj.gameid] = {};
						}
						gameAdvsObj[advsObj.gameid] = {isclick:true};
						LocalStorage.setJSON("gameObj",gameAdvsObj);
						advsListArr.splice(_playIndex,1);
					}
				}
				__JS__('BK').QQ.skipGame(desGameId, extendInfo);
				updateAdvsInfo();
			}else if(Browser.onMiniGame)
			{
				if(isSupportJump())
				{
					__JS__('wx').navigateToMiniProgram({
						appId:_appid,
						path:"",
						extraData:"",
						envVersion:"release",
						success:function success():void{
							trace("-------------跳转成功--------------");
						},
						fail:function fail():void{
							trace("-------------跳转失败--------------");
						}, 
						complete: function complete():void
						{
							trace("-------------跳转接口调用成功--------------");
							updateAdvsInfo();
						}.bind(this)
					});
				}
			}else if(Browser.onBDMiniGame)
			{
				
			}else
			{
				this.visible = false;
			}
		}
		
		private  function updateAdvsInfo():void
		{
			this.visible = false;
			onLunbo();
			Laya.timer.loop(_lunboTime,this,onLunbo);
		}
		
		private function onLunbo():void
		{
			if(_playIndex >= advsListArr.length-1)
				_playIndex =  0;
			else
				_playIndex += 1;
			this.visible = true;
			revertAdvsData();
		}
		
		/**获取轮播数据**/
		private  function getCurrentAppidObj():String
		{
			return advsListArr[_playIndex];
		}
		
		/**
		 * 获取广告列表数据信息 
		 */		
		private function onGetAdvsListData():void
		{
			var _this:* = this;
			var random:int = randRange(10000,1000000);
			var url:String = resUrl +"?" + random;
			_http.open("get", url, true);
			_http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
			_http.responseType = "text";
			_http.onerror = function(e:*):void {
				_this._onError(e);
			}
			_http.onload = function(e:*):void {
				_this._onLoad(e);
			}
			_http.send(null);
		}
		
		/**
		 * 生成指定范围的随机数
		 * @param {*} minNum 最小值
		 * @param {*} maxNum 最大值
		 */
		public static function randRange(minNum, maxNum):int
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
		/**
		 * @private
		 * 请求出错侦的听处理函数。
		 * @param	e 事件对象。
		 */
		private function _onError(e:*):void {
			error("Request failed Status:" + this._http.status + " text:" + this._http.statusText);
		}
		
		/**
		 * @private
		 * 请求消息返回的侦听处理函数。
		 * @param	e 事件对象。
		 */
		private function _onLoad(e:*):void {
			var http:* = this._http;
			var status:Number = http.status !== undefined ? http.status : 200;
			if (status === 200 || status === 204 || status === 0) {
				complete();
			} else {
				error("[" + http.status + "]" + http.statusText + ":" + http.responseURL);
			}
		}
		
		/**
		 * @private
		 * 请求错误的处理函数。
		 * @param	message 错误信息。
		 */
		private function error(message:String):void {
			event(Event.ERROR, message);
		}
		
		/**
		 * @private
		 * 请求成功完成的处理函数。
		 */
		private function complete():void {
			var flag:Boolean = true;
			try {
				this._data = _http.response || _http.responseText;
				this._data = JSON.parse(this._data);
				//加载成功，做出回调通知处理
				if(Browser.onLimixiu)
				{
					//玩一玩
					advsListArr = getAdvsQArr(this._data);
					if(advsListArr.length)
					{
						updateAdvsInfo();
						revertAdvsData();
					}else
					{
						this.visible =false;
					}
				}else
				{
					//百度，微信
					advsListArr = this._data.list;
					_appid = this._data.appid;
					updateAdvsInfo();
					revertAdvsData();
				}
			} catch (e:*) {
				flag = false;
				error(e.message);
			}
		}
		
		/**转换数据**/
		private function  getAdvsQArr(data:Object):Array
		{
			var tempArr:Array = [];
			var  gameAdvsObj:Object = LocalStorage.getJSON("gameObj");
			for(var key:* in data)
			{
				var tempObj:Object = data[key];
				if(gameAdvsObj && gameAdvsObj[tempObj.gameid] && !tempObj.isQiangZhi)
					continue;//如果游戏id之前点击过就跳过，放弃轮播显示
				tempArr.push(tempObj);
			}
			return tempArr;
		}
		
		/**
		 * @private
		 * 清除当前请求。
		 */
		private function clear():void {
			var http:* = this._http;
			http.onerror = http.onabort = http.onprogress = http.onload = null;
		}
		
		override public function destroy(destroyChild:Boolean=true):void
		{
			Laya.timer.clear(this,onLunbo);
			super.destroy(true);
			clear();
			Laya.timer.clear(this,onGetAdvsListData);
		}
	}
}