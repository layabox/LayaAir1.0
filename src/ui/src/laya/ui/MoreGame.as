package laya.ui
{
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.net.HttpRequest;
	import laya.net.LocalStorage;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.TimeLine;

	/**
	 *  游戏中心插件 
	 * @author xiaosong
	 * @date 2018-12-26
	 */	
	public class MoreGame extends View
	{
		/**是否停止缓动，默认晃动**/
		private var gameStopHD:Boolean = false;
		/**icon动画**/
		private var iconImgTl:TimeLine;
		/**iconImage**/
		private var _iconImage:Image;
		/**更多游戏容器**/
		private var _moreBox:Box;
		/**游戏内盒子容器**/
		private var _gameBox:Box;
		/**屏幕方向, 默认0 横屏，1竖屏**/
		private var screenType:int =  0;
		/**更多游戏配置数据**/
		private var _moreGameDataUrl:String = "https://abc.layabox.com/public/more/gamelist2.json";
		/**加载请求实例**/
		private static var _http:* = new Browser.window.XMLHttpRequest();
		/**插件列表数据**/
		private static var _moreGameData:Object =null;
		/**图片尺寸设置信息**/
		private var _iconImageObj:Object;
		/**图标点击回调**/
		public var clickCallBack:Handler;
		/**关闭盒子回调**/
		public var closeCallBack:Handler;
		/**是否在显示中**/
		public var isShow:Boolean;
		/**系统信息**/
		private var dinfo:String;
		/**统计数据地址**/
		private var ErrorUrlHttps:String = "https://elastic.layabox.com/";
		/**统计类型**/
		private var tongjiType:String = "bdm";
		public function MoreGame(type:int = 0)
		{
			super();
			this.screenType = type;
			init();
			
			
		}
		
		/**
		 * 获取字符串时间戳，例如:2018-7-6 
		 * @param _timestamp
		 * @return 
		 * 
		 */		
		private  function getLocalDateString(_timestamp:* = 0):String {
			var timeStr:String = getDateByTimestamp(_timestamp).toLocaleDateString();
			if(Browser.onLimixiu || Browser.onMiniGame)
			{
				var date:Date = new Date();
				timeStr = toLocaleDateString(date.getTime());
			}
			var reg:RegExp=new RegExp("/","g"); //创建正则RegExp对象 
			timeStr = timeStr.replace(reg,"-");
			return timeStr;
		}
		
		private  function getDateByTimestamp(_timestamp:* = 0):*{
			if (!_timestamp || _timestamp == "") return __JS__("new Date()");
			return __JS__("new Date(_timestamp)");
		}
		
		/**
		 * 获取指定的时间戳 
		 * @param date
		 * @return 
		 */		
		public static function toLocaleDateString(dateNum:Number):String
		{
			return getDateFormatStr(dateNum,"/");
		}
		
		/**
		 *  获取时间戳 
		 * @param stamp
		 * @param formatStr 支持  /  或  年月日  或 年月日时分秒
		 * @return 
		 * 
		 */		
		public static function getDateFormatStr(stamp:Number,formatStr:String="yynndd"):String
		{
			var date:Date = new Date(stamp);
			var yy:uint = date.getFullYear();
			var nn:uint = date.getMonth() + 1;
			var dd:uint = date.getDate();
			var hh:uint = date.getHours();
			var mm:uint = date.getMinutes();
			var ss:uint = date.getSeconds();
			
			switch(formatStr)
			{
				case "yynndd":
					return yy.toString() + "年" + nn.toString() + "月" + dd.toString() + "日";
					break;
				case "/":
					return yy.toString() + "/" + nn.toString() + "/" + dd.toString();
					break;
			}
			return yy.toString() + "年" + nn.toString() + "月" + dd.toString() + "日" + hh.toString() + "时" + mm.toString() + "分" + ss.toString() + "秒";
		}
		
		/**
		 * 发送统计信息 
		 * @param etype 统计数据类型
		 * @param errorInfo 报错信息
		 * @param pro 统计扩展数据
		 */		
		private function reportError(etype:String, errorInfo:String = "",pro:Object = null):void
		{
			pro = pro || {};
			var now:int = __JS__("Date.now()");
			var date:Date = new Date(now+0);
			pro.date = date.toLocaleString();
			pro.etype = etype;
			if (etype != "error"){
				if (etype != "statistics")
				{
					etype = "statistics";
				}
			}	
			//统计报错来自哪个模块
			pro.version = "V0.0.1";
			pro.gameId = 10100;
			pro.dinfo = dinfo;
			pro.channel = -1000;
			pro.msg = errorInfo;
			pro["@timestamp"] = __JS__("date.toISOString()");
			pro.user = getUserId();
			pro.openid = getOpenId();
			var rdate:String = getDay(date);
			pro.rdate = rdate;
			pro.day = date.getDate()+"";
			pro.hour = date.getHours()+"";
			pro.minute = date.getMinutes()+"";
			pro.gameurl = __JS__("document.baseURI");
			pro.regTime= 0;
			if (etype == "error"){
				sendLog(pro, tongjiType+"error-" + rdate.substring(0, 6) + "/"+etype+"/",etype);
			}else{
				sendLog(pro, tongjiType+"-" + rdate.substring(0, 6) + "/"+etype+"/",etype);
			}
		}
		
		/**获取用户userid**/
		private function getUserId():int
		{
			var userid:int = parseInt(LocalStorage.getItem("layauserid") +"") || -1;
			if(userid == -1)
			{
				userid = randRange(0,1000000000);
				LocalStorage.setItem("layauserid",userid +"");
			}
			return userid;
		}
		
		/**获取用户的openid**/
		private function getOpenId():String
		{
			var str:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
			var openId:String = LocalStorage.getItem("openid");
			if(openId == null || openId == "")
			{
				openId = "";
				for(var i:int = 0,sz:int = 32;i<sz;i++)
				{
					var random:int = randRange(0,62);
					openId+= str.charAt(random);
				}
				LocalStorage.setItem("openid",openId);
			}
			return openId;
		}
		
		private function sendLog(pro:Object,path:String,btype:String):void
		{
			var htt:HttpRequest = new HttpRequest();
			htt.on(Event.ERROR, this, function(p:Object,bt:String,e:*):void{
				if (e && e.indexOf("[404]")!=-1)
				{
					var htt1:HttpRequest = new HttpRequest();
					htt1.send(ErrorUrlHttps+"garbage/"+bt+"/", JSON.stringify(p), "post", "text", ["Content-Type", "application/json"]);
				}
			},[pro,btype]);
			if(Browser.onBDMiniGame)
			{
				pro.gameurl = "";
			}
			htt.send(ErrorUrlHttps+path, JSON.stringify(pro), "post", "text", ["Content-Type", "application/json"]);
		}
		
		private static function  getDay(sdate:Date):String{
			var month:int = sdate.getMonth() + 1;
			var day:int   = sdate.getDate();
			var result:String = sdate.getFullYear() + "" + (month < 10?"0" + month:month) + "" + (day < 10?"0" + day:day);
			return result;
		}
		
		private function initEvent():void
		{
			this.on(Event.CLICK,this,onIconClick);
		}
		
		 private function onStageResize():void 
		 {
			 var scale:Number = Math.min(Laya.stage.width / Laya.stage.designWidth, Laya.stage.height / Laya.stage.designHeight);
			 if(Laya.stage.width < 720)
				 scale = 0.9;//修复适配的bug
			 if(_moreBox)
			 {
				 _moreBox.scale(scale,scale);
			 }
			 if(_gameBox)
			 {
				 _gameBox.scale(scale,scale);
			 }
		 }
		
		/**
		 * 晃动效果 
		 * @param target
		 * @param tTime
		 * @param sacleNum
		 * @param lastSacleNum
		 * @return 
		 */		
		public  function  tada(target:Node, tTime:Number,sacleNum:Number = 1.1,lastSacleNum:Number = 1):TimeLine
		{
			var tl:TimeLine = new TimeLine();
			tl.reset();
			tl.to(target, {scaleX:sacleNum, scaleY:sacleNum, rotation: 3}, tTime * 0.1)
				.to(target, {scaleX:sacleNum, scaleY:sacleNum, rotation: -3}, tTime * 0.1)
				.to(target, {scaleX:sacleNum, scaleY:sacleNum, rotation: 3}, tTime * 0.1)
				.to(target, {scaleX:sacleNum, scaleY:sacleNum, rotation: -3}, tTime * 0.1)
				.to(target, {scaleX:sacleNum, scaleY:sacleNum, rotation: 3}, tTime * 0.1)
				.to(target, {scaleX:sacleNum, scaleY:sacleNum, rotation: -3}, tTime * 0.1)
				.to(target, {scaleX:sacleNum, scaleY:sacleNum, rotation: 3}, tTime * 0.1)
				.to(target, {scaleX:sacleNum, scaleY:sacleNum, rotation: -3}, tTime * 0.1)
				.to(target, {scaleX:sacleNum, scaleY:sacleNum, rotation: 3}, tTime * 0.1)
				.to(target, {scaleX:lastSacleNum, scaleY:lastSacleNum, rotation: 0}, tTime * 0.1);
			tl.play(0);
			return tl;
		}
		
		/**销毁插件**/
		public function dispose():void
		{
			removeEvent();
			gameStopHD = true;
			_moreGameData =null;
			_iconImageObj =null;
			clickCallBack =null;
			closeCallBack =null;
			if(iconImgTl)
			{
				iconImgTl.offAll(Event.COMPLETE);
				iconImgTl =null;
			}
			if(_moreBox)
			{
				_moreBox.removeChildren();
				_moreBox = null;
			}
			if(_gameBox)
			{
				_gameBox.removeChildren();
				_gameBox = null;
			}
			if(_iconImage)
			{
				_iconImage.removeSelf();
				_iconImage =null;
			}
		}
		
		/**
		 * 设置icon的显示状态 
		 * @param type
		 */		
		public function onSetIconType(type:Boolean):void
		{
			gameStopHD = !type;
			this.visible = type;
		}
		
		/**检测晃动**/
		private function checkIconImgHD():void
		{
			if(!iconImgTl)
				iconImgTl = tada(_iconImage, 1200,1.1,0.9);
			else
				iconImgTl.play(0);
			iconImgTl.on(Event.COMPLETE,this,onTlComplete);
		}
		
		private function onTlComplete():void
		{
			if(this.parent)
			{
				_iconImage.scale(0.9, 0.9);
				_iconImage.rotation = 0;
				if (gameStopHD && iconImgTl)
				{
					iconImgTl.offAll(Event.COMPLETE);
					iconImgTl =null;
					return;
				}
				Laya.timer.once(1000,this,onYanChiPlay);
			}else
			{
				if(iconImgTl){
					iconImgTl.offAll();
					iconImgTl =null;
				}
			}
		}
		
		private function onYanChiPlay():void
		{
			if(this.parent && iconImgTl)
			{
				iconImgTl.play(0);
			}else
			{
				if(iconImgTl)
				{
					iconImgTl.offAll(Event.COMPLETE);
					iconImgTl =null;
				}
			}
		}
		
		private function removeEvent():void
		{
			this.off(Event.CLICK,this,onIconClick);
		}
		
		private function onIconClick():void
		{
			isShow = true;
			clickCallBack !=null && clickCallBack.run();
			var localCurrentTime:String = LocalStorage.getItem("currentTime");
			var currentTime:String = getLocalDateString();//获取本地时间戳
			if(localCurrentTime != currentTime)
			{
				LocalStorage.setItem("currentTime",currentTime);
				reportError(_moreGameData.statid1);//去重
			}else
			{
				reportError(_moreGameData.statid2);//不出重
			}
			onResLoaded();
		}
		
		private function onResLoaded():void
		{
			//容器的初始化操作应该是在点击了icon后才做到 事情
			if(!_moreBox)
			{
				//创建更多游戏容器
				_moreBox =new Box();
				Laya.stage.addChild(_moreBox);
				_moreBox.zOrder = 99999;
				_moreBox.left = _moreBox.right = _moreBox.top = _moreBox.bottom = 0;
				
				//整个背景
				var allBgImg:Image = onCreateImage(onGetAtlasDanImgUrl("img_white_bg"),_moreBox);
				allBgImg.top =  allBgImg.left = allBgImg.right = allBgImg.bottom = 0;
				allBgImg.sizeGrid = "1,1,1,1,1";
				
				//横线
				var hlineImg:Image = onCreateImage(onGetAtlasDanImgUrl("hengfengexian"),_moreBox);
				hlineImg.left = hlineImg.right = 0;
				hlineImg.y = 132;
				hlineImg.alpha = 0.2;
				
				//尖头
				var jiantouImg:Image = onCreateImage(onGetAtlasDanImgUrl("img_font_jingcai"),_moreBox);
				jiantouImg.on(Event.CLICK,this,onJiantouImgClick);
				
				//顶部高度设置
				if(isQMP() && this.screenType)
				{
					jiantouImg.pos(15,70);
				}else
				{
					jiantouImg.pos(15,45);
				}
				
				//更多游戏列表点击点击入口
				var gamelist:List =new List();
				
				_moreBox.addChild(gamelist);
				gamelist.itemRender = GameBox;
				gamelist.selectEnable = true;
				gamelist.vScrollBarSkin = "";
				gamelist.scrollBar.autoHide = true;
				gamelist.scrollBar.elasticDistance = 250;
				gamelist.renderHandler = new Handler(this,onGameListRender);
				
				//动态数据处理
				var tempGameListArr:Array = _moreGameData.marvellousGame.gameList;
				var gameListArr:Array = [];
				gameListArr.push(tempGameListArr[0]);
				gameListArr.push(tempGameListArr[1]);
				//从所有2开始随机
				var getRomdomArr:Array = RandomNumBoth(gameListArr.length,tempGameListArr.length-gameListArr.length,tempGameListArr.length);
				if(!getRomdomArr)
				{
					this.visible = false;//异常保护
					return;
				}
				try
				{
					for(var i:int = 0,sz:int = getRomdomArr.length;i<sz;i++)
					{
						var index:int = getRomdomArr[i];
						gameListArr.push(tempGameListArr[index]);
					}
					_moreGameData.marvellousGame.gameList = [];
					_moreGameData.marvellousGame.gameList = gameListArr;
					gamelist.array = _moreGameData.marvellousGame.gameList;
				} 
				catch(error:Error) 
				{
					gamelist.array = _moreGameData.marvellousGame.gameList;
				}
				
				//竖屏
				if(screenType)
				{
					gamelist.spaceY = 10;
					gamelist.width = 690;
					if(isQMP())
					{
						gamelist.height = Laya.stage.height + 130;
					}else
					{
						gamelist.height = 1139;	
					}
					gamelist.y = 139;
					gamelist.centerX = 0;
				}else
				{
				}
				onStageResize();
			}else
			{
				this._moreBox.visible = true;
			}
		}
		
		/**
		 * 取出随机数, maxNum为 取出随机数的个数 
		 * @param minNum 最小值 2
		 * @param maxNum 最大数值 14
		 * @param maxcount 最大范围 12
		 * @return 
		 */		
		private function RandomNumBoth(minNum:int,maxNum:int,maxcount:int):Array{  
			/**循环创建一个数组的函数**/
			var arr:Array = [];  
			for(var i:int=minNum;i<maxcount;i++){  
				arr.push(i);
			}  
			var numArr:Array = [];  
			//最大的循环次数  
			var arrLength:int = arr.length;  
			for(i = 0;i<arrLength;i++){  
				//获取arr的长度  
				var Rand:int = arr.length  
				//取出随机数   
				var number:int = Math.floor(Math.random()*arr.length); //生成随机数num  
				//往新建的数组里面传入数值  
				numArr.push(arr[number]);  
				//传入一个删除一个，避免重复  
				arr.splice(number,1);  
				if(arr.length <= arrLength-maxNum){  
					return numArr;  
				}  
			}  
			return null;
		} 
		
		/**
		 * 是否是全面屏 包括 安卓跟苹果
		 * @return 
		 */		
		public function isQMP():Boolean
		{
			var  isBoo:Boolean = false;
			var tempBL:Number = 0;
			if(Laya.stage.screenMode == Stage.SCREEN_HORIZONTAL)
			{
				tempBL = Browser.height%9;//横屏
			}else
			{
				tempBL = Browser.width%9;//竖屏
			}
			//安卓全面屏判断
			if(Browser.onAndroid && tempBL == 0)
			{
				var tempBL2:Number = 0;
				if(Laya.stage.screenMode == Stage.SCREEN_HORIZONTAL)
				{
					//横屏
					tempBL2 = Browser.width;
				}else
				{
					//竖屏
					tempBL2 = Browser.height;
				}
				if([2280,2160,2244,3120,2248,2340,2310].indexOf(tempBL2) != -1)
				{
					isBoo = true;
				}
			}
			var onIPhoneX:Boolean = /iPhone/gi.test(Browser.window.navigator.userAgent) && (Math.min(Browser.clientHeight,Browser.clientWidth) == 375 && Math.max(Browser.clientHeight,Browser.clientWidth) == 812);
			var onIPhoneXR:Boolean = (Math.min(Browser.clientHeight,Browser.clientWidth) == 414 && Math.max(Browser.clientHeight,Browser.clientWidth) == 896);
			//苹果手机
			if((((Browser.onMiniGame || Browser.onBDMiniGame) && !Browser.onAndroid ))&&(onIPhoneX || onIPhoneXR))
			{
				isBoo = true;
			}
			return isBoo;
		}
		
		
		/**
		 * 创建一个圆角矩形 
		 * @param width 
		 * @param height
		 * @param circleNum
		 * @return 
		 */		
		private function onDrawShapes(yuanWidth:Number,yuanHeight:Number,circleNum:Number = 5,isTeShu:Boolean = false):Sprite
		{
			var isTeShuCircleNum:int = circleNum;//特殊圆角值
			if(isTeShu)
				isTeShuCircleNum = 0;//大banner用
			var sprite:Sprite = new Sprite();
			//绘制圆角矩形，自定义路径
			sprite.graphics.drawPath(0, 0, [
				["moveTo", circleNum, 0],
				["lineTo", 105, 0],
				["arcTo", yuanWidth, 0, yuanWidth, circleNum, circleNum],
				["lineTo", yuanWidth, yuanHeight],
				["arcTo", yuanWidth, yuanHeight+circleNum, 105, yuanHeight+circleNum, isTeShuCircleNum],
				["lineTo", circleNum, yuanHeight+circleNum],
				["arcTo", 0, yuanHeight+circleNum, 0, yuanHeight, isTeShuCircleNum],
				["lineTo", 0, circleNum],
				["arcTo", 0, 0, circleNum, 0, circleNum],
				["closePath"]
			],
			{
				fillStyle: "#ff0000"
			});
			return sprite;
		}
		/**
		 * 创建遮罩的对象 
		 * @param url
		 * @param parent
		 * @return 
		 */		
		private function onCreateMaskImg(url:String,parent:*):Image
		{
			var kuangImg:Image = onCreateImage(onGetAtlasDanImgUrl("dayuan"),parent);
			var iconImg:Image = onCreateImage(url,kuangImg);
			iconImg.pos(11,10);
			var sprite:Sprite = new Sprite();
			sprite.graphics.drawCircle(71,74,68,"#ff0000");
			iconImg.mask = sprite;
			kuangImg.scale(0.7,0.7);
			return kuangImg;
		}
		
		
		/**
		 * 渲染更多游戏列表 
		 * @param item
		 * @param index
		 */		
		private function onGameListRender(item:GameBox,index:int):void
		{
			var gameList:Array = _moreGameData.marvellousGame.gameList;
			if(index < 0 || index > gameList.length -1)
				return;
			var gameObj:Object = gameList[index];
			item.init(gameObj,this.screenType,new Handler(this,onItemClickCallBack));
		}		
		
		/**
		 * 单元点击回调 
		 * @param itemData
		 */		
		private function onItemClickCallBack(itemData:Object):void
		{
			if(!__JS__('swan').navigateToMiniProgram)
				return;
			var appKey:String = itemData.appKey;
			var path:String = itemData.path;
			var extendInfo:String = itemData.extendInfo;
			__JS__('swan').navigateToMiniProgram({
				appKey:appKey,
				path:path,
				extraData:extendInfo,
				success:function success(e):void{
				},
				fail:function fail(e):void{
				}, 
				complete: function complete(e):void
				{
					//发信息统计成功
					reportError(itemData.statid);
				}.bind(this)
			});
		}
		
		/**更多游戏返回按钮点击**/
		private function onJiantouImgClick(type:int):void
		{
			isShow = false;
			if(_moreBox)
			{
				_moreBox.visible = false;
			}
			closeCallBack !=null && closeCallBack.run();
		}
		
		/**
		 * 获取图集中单张图片路径信息 
		 * @param url
		 * @return 
		 */		
		public static function onGetAtlasDanImgUrl(url):String
		{
			return _moreGameData.imgPath + _moreGameData.atlas + url + ".png";
		}
		
		/**
		 * 获取指定图片的绝对地址 
		 * @param resUrl
		 * @return 
		 */		
		public static function onGetImgSkinUrl(resUrl:String):String
		{
			return _moreGameData.imgPath + resUrl;
		}
		
		/**
		 * 获取Icon图片的绝对地址 
		 * @param resUrl
		 * @return 
		 */		
		public static function onGetIconImgSkinUrl(resUrl:String):String
		{
			return _moreGameData.iconPath + resUrl;
		}
		
		/**
		 * 创建文本 
		 * @param str
		 * @param parent
		 * @param width
		 * @param height
		 * @param size 
		 * @param color
		 * @param wordwarp
		 * @param align
		 * @param leading
		 * @return 
		 */		
		private function onCreateLabel(str:String,parent:*,size:int = 24,color:String = "#000000",wordwarp:Boolean = false,align:String = "center",leading:int = 10):Label
		{
			var  label:Label = new Label();
			label.text = str;
			label.font = "Microsoft YaHei";
			label.fontSize = size;
			label.color = color;
			label.bold = true;
			label.leading = leading;
			label.valign = "middle";
			label.align = align;
			label.wordWrap = wordwarp;
			parent.addChild(label);
			return label;
		}
		
		/**
		 * 创建图片 
		 * @param url
		 * @param parent  图片的父容器
		 * @return 
		 */		
		private function onCreateImage(url:String,parent:*):Image
		{
			var image:Image = new Image();
			image.skin = url;
			parent.addChild(image);
			return image;
		}
		
		
		/**初始化判断当前是否显示插件**/
		private function init():void
		{
			var userAgent:String = Browser.window.navigator.userAgent;
			var onBDMiniGame:Boolean =  userAgent.indexOf('SwanGame') > -1;
			this.visible = false;
			if(onBDMiniGame)
			{
				dinfo=JSON.stringify(__JS__('laya.bd.mini.BMiniAdapter.systemInfo'));//xiaosong2018
				//这里应该是显示外部更多游戏icon入口的操作，需要先请求一个外部json地址，来获取游戏列表数据等
				onGetAdvsListData();
			}
		}
		
		/**
		 * 生成指定范围的随机数
		 * @param  minNum 最小值
		 * @param  maxNum 最大值
		 */
		private  function randRange(minNum, maxNum):int
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
		/**
		 * 获取广告列表数据信息 
		 */		
		private function onGetAdvsListData():void
		{
			var _this:* = this;
			var random:int = randRange(10000,1000000);
			var url:String = _moreGameDataUrl +"?" + random;
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
		 * @private
		 * 请求出错侦的听处理函数。
		 * @param	e 事件对象。
		 */
		private function _onError(e:*):void {
			error("Request failed Status:" + _http.status + " text:" + _http.statusText);
		}
		
		/**
		 * @private
		 * 请求消息返回的侦听处理函数。
		 * @param	e 事件对象。
		 */
		private function _onLoad(e:*):void {
			var http:* = _http;
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
				//加载成功，做出回调通知处理
				var tempData:* = _http.response || _http.responseText;
				_moreGameData = JSON.parse(tempData);
				//初始化UI显示
				initUI();
			} catch (e:*) {
				flag = false;
				error(e.message);
			}
		}
		
		/**初始化UI显示**/
		private function initUI():void
		{
			//目前只针对竖屏做操作
			if(_moreGameData.isOpen && screenType)
			{
				//先显示外部icon入口
				if(!_iconImage)
				{
					_iconImage = new Image();
					this.addChild(_iconImage);
				}
				_iconImage.skin = onGetImgSkinUrl(_moreGameData.icon);
				if(_iconImageObj)
				{
					_iconImage.size(_iconImageObj.width,_iconImageObj.height);
					_iconImage.pivot(_iconImageObj.width/2,_iconImageObj.height/2);
					_iconImage.pos(_iconImageObj.width/2,_iconImageObj.height/2);
				}
				this.visible = true;
				initEvent();
				gameStopHD = false;
				//缓动icon图标
				checkIconImgHD();
			}else
			{
				this.visible = false;
			}
		}
		
		/**
		 * 设置icon的宽高尺寸 
		 * @param width
		 * @param height
		 */		
		public function setIconSize(w:Number,h:Number):void
		{
			if(_iconImage)
			{
				_iconImage.size(w,h);
				_iconImage.pivot(w/2,h/2);
				_iconImage.pos(w/2,h/2);
			}
			_iconImageObj = {width:w,height:h};
		}
	}
}


/**
 * 有渲染游戏单元 
 * @author xiaosong
 * @date -2019-03-26
 */
class GameBox extends Box
{
	/**游戏类型**/
	public var titleLabel:Label;
	/**游戏列表容器**/
	public var gameListBox:Box;
	public function GameBox():void
	{
	}
	
	/**
	 * 初始化列表数据 
	 * @param data
	 */	
	public function init(data:Object,screenType:int,callBack:Handler):void
	{
		if(!titleLabel)
		{
			titleLabel = onCreateLabel(data.title,this,32,"#3d3939");
			titleLabel.pos(8,0);
			titleLabel.size(162,50);
		}else
		{
			titleLabel.text = data.title;
		}
		
		if(!gameListBox)
		{
			gameListBox = new Box();
			this.addChild(gameListBox);
			//渲染单元
			var tempX:Number = 0;
			var tempY:Number = 65;
			var tempWidth:Number = 175;
			for(var i:int = 0,sz:int = data.gameList.length;i<sz;i++)
			{
				var gameitem:GameItem = new GameItem();
				gameitem.init(data.gameList[i],screenType,callBack);
				gameitem.x = tempX + i * tempWidth;
				gameitem.y = tempY;
				gameListBox.addChild(gameitem);
			}
		}else
		{
			for(i = 0,sz = gameListBox._children.length;i<sz;i++)
			{
				gameitem = gameListBox._children[i];
				gameitem.init(data.gameList[i],screenType,callBack);
			}
		}
		this.size(695,340);
		//this.cacheAs = "bitmap";
	}
	
	/**
	 * 创建文本 
	 * @param str
	 * @param parent
	 * @param width
	 * @param height
	 * @param size 
	 * @param color
	 * @param wordwarp
	 * @return 
	 */		
	private function onCreateLabel(str:String,parent:Box,size:int = 26,color:String = "#000000",bold:Boolean = true):Label
	{
		var  label:Label = new Label();
		label.text = str;
		label.font = "Microsoft YaHei";
		label.fontSize = size;
		label.color = color;
		label.bold = bold;
		label.leading = 10;
		label.valign = "middle";
		label.align = "center";
		label.overflow = "hidden";
		parent.addChild(label);
		return label;
	}
}


import laya.display.Sprite;
import laya.events.Event;
import laya.ui.Box;
import laya.ui.Image;
import laya.ui.Label;
import laya.ui.MoreGame;
import laya.utils.Handler;

/**
 * 更多游戏单元 
 * @author xiaosong
 * @date 2018-12-26
 */
class GameItem extends Box
{
	/**icon框**/
	public var kuangImg:Image;
	/**icon名字**/
	public var iconNameLabel:Label;
	/**icon图标**/
	public var iconImg:Image;
	/**玩一玩按钮**/
	public var playImg:Image;
	/**渲染单元数据**/
	public var itemData:Object;
	/**回调方法**/
	private var callBackHandler:Handler;
	public function MoveGameItem():void
	{
	}
	
	/**注册事件监听**/
	private function initEvent():void
	{
		this.on(Event.CLICK,this,onItemClick);
	}
	
	private function onItemClick():void
	{
		callBackHandler != null && callBackHandler.runWith([itemData]);
	}
	
	/**
	 * 初始化单元数据 
	 * @param data
	 */	
	public function init(data:Object,screenType:int,callBack:Handler):void
	{
		itemData = data;
		callBackHandler = callBack;
		
		//推荐icon框
		if(!kuangImg)
			kuangImg = onCreateImage(MoreGame.onGetAtlasDanImgUrl("dayuan"),this);
		else
		{
			kuangImg.skin = MoreGame.onGetAtlasDanImgUrl("dayuan");
		}
		//推荐icon
		if(!iconImg)
		{
			iconImg = onCreateImage(MoreGame.onGetIconImgSkinUrl(data.icon),this);
			var sprite:Sprite = new Sprite();
			sprite.graphics.drawCircle(71,74,68,"#ff0000");
			iconImg.mask = sprite;
			iconImg.pos(13,10);
		}else
		{
			iconImg.skin = MoreGame.onGetIconImgSkinUrl(data.icon);
		}
		
		//icon的名字
		if(!iconNameLabel)
		{
			iconNameLabel = onCreateLabel(data.name,this,28,"#3d3939");
			iconNameLabel.pos(7,165);
		}else
		{
			iconNameLabel.text = data.name;
		}
		
		//玩一玩按钮
		if(!playImg)
		{
			playImg = onCreateImage(MoreGame.onGetAtlasDanImgUrl("img_play"),this);
			playImg.pos(12,210);
		}else
		{
			playImg.skin = MoreGame.onGetAtlasDanImgUrl("img_play");
		}
		
		this.size(165,270);
		initEvent();
	}
	
	
	/**
	 * 创建文本 
	 * @param str
	 * @param parent
	 * @param width
	 * @param height
	 * @param size 
	 * @param color
	 * @param wordwarp
	 * @return 
	 */		
	private function onCreateLabel(str:String,parent:Box,size:int = 24,color:String = "#000000",bold:Boolean = false):Label
	{
		var  label:Label = new Label();
		label.text = str;
		label.font = "Microsoft YaHei";
		label.fontSize = size;
		label.color = color;
		label.bold = bold;
		label.leading = 10;
		label.valign = "middle";
		label.align = "center";
		label.size(152,44);
		label.overflow = "hidden";
		parent.addChild(label);
		return label;
	}
	
	/**
	 * 创建图片 
	 * @param url
	 * @param parent  图片的父容器
	 * @return 
	 */		
	private function onCreateImage(url:String,parent:Box):Image
	{
		var image:Image = new Image();
		image.skin = url;
		parent.addChild(image);
		return image;
	}
}