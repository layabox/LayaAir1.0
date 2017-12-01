
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Browser=laya.utils.Browser,Event=laya.events.Event,EventDispatcher=laya.events.EventDispatcher;
	var HTMLImage=laya.resource.HTMLImage,Handler=laya.utils.Handler,Input=laya.display.Input,Loader=laya.net.Loader;
	var RunDriver=laya.utils.RunDriver,SoundChannel=laya.media.SoundChannel,SoundManager=laya.media.SoundManager;
	var Stage=laya.display.Stage,URL=laya.net.URL,Utils=laya.utils.Utils;
//class laya.wx.mini.MiniAdpter
var MiniAdpter=(function(){
	function MiniAdpter(){}
	__class(MiniAdpter,'laya.wx.mini.MiniAdpter');
	MiniAdpter.getJson=function(data){
		return JSON.parse(data);
	}

	MiniAdpter.init=function(){
		if (MiniAdpter._inited)return;
		MiniAdpter._inited=true;
		MiniAdpter.window=/*__JS__ */window;
		MiniAdpter.EnvConfig={};
		MiniFileMgr.setNativeFileDir("/layaairGame");
		MiniFileMgr.existDir(MiniFileMgr.fileNativeDir,null);
		Stage._wgColor=[0,0,0,1];
		MiniAdpter.window.focus=function (){
		};
		Laya['getUrlPath']=function (){
		};
		MiniAdpter.window.CanvasRenderingContext2D=function (){
		};
		MiniAdpter.window.CanvasRenderingContext2D.prototype=MiniAdpter.window.wx.createCanvas().getContext('2d').__proto__;
		MiniAdpter.window.document.body.appendChild=function (){
		};
		MiniAdpter.EnvConfig.pixelRatioInt=0;
		RunDriver.getPixelRatio=MiniAdpter.pixelRatio;
		MiniAdpter._preCreateElement=Browser.createElement;
		Browser["createElement"]=MiniAdpter.createElement;
		RunDriver.createShaderCondition=MiniAdpter.createShaderCondition;
		MiniAdpter.wxRequest=/*__JS__ */wx.request;
		/*__JS__ */wx.request=MiniAdpter.onWxRequest;
		Utils.parseXMLFromString=MiniAdpter.parseXMLFromString;
		Loader.prototype._loadImage=MiniImage.prototype._loadImage;
	}

	MiniAdpter.onWxRequest=function(data){
		var url=data.url;
		var type=Utils.getFileExtension(url);
		var responseType=data.responseType;
		if (MiniFileMgr.isLoadFile(type)){
			new MiniXMLHttpRequest().onFileLoad(url,responseType,data);
			}else {
			MiniAdpter.wxRequest(data)
		}
	}

	MiniAdpter.pixelRatio=function(){
		if (!MiniAdpter.EnvConfig.pixelRatioInt){
			try {
				var systemInfo=/*__JS__ */wx.getSystemInfoSync();
				MiniAdpter.EnvConfig.pixelRatioInt=systemInfo.pixelRatio;
				return systemInfo.pixelRatio;
			}catch (error){}
		}
		return MiniAdpter.EnvConfig.pixelRatioInt;
	}

	MiniAdpter.createElement=function(type){
		if (type=="canvas"){
			var _source;
			if (MiniAdpter.idx==1){
				_source=/*__JS__ */window.canvas;
				}else {
				_source=/*__JS__ */window.wx.createCanvas();
			}
			MiniAdpter.idx++;
			return _source;
			}else if (type=="textarea" || type=="input"){
			return MiniAdpter.onCreateInput(type);
			}else if (type=="div"){
			var node=MiniAdpter._preCreateElement(type);
			node.contains=function (value){
				return null
			};
			node.removeChild=function (value){
			};
			return node;
			}else {
			return MiniAdpter._preCreateElement(type);
		}
	}

	MiniAdpter.onCreateInput=function(type){
		var node=MiniAdpter._preCreateElement(type);
		node.focus=MiniInput.wxinputFocus;
		node.blur=MiniInput.wxinputblur;
		node.style={};
		node.value=0;
		node.parentElement={};
		node.placeholder={};
		node.type={};
		node.setColor=function (value){
		};
		node.setType=function (value){
		};
		node.setFontFace=function (value){
		};
		node.addEventListener=function (value){
		};
		node.contains=function (value){
			return null
		};
		node.removeChild=function (value){
		};
		return node;
	}

	MiniAdpter.createShaderCondition=function(conditionScript){
		var _$this=this;
		var func=function (){
			var abc=conditionScript;
			return _$this[conditionScript.replace("this.","")];
		}
		return func;
	}

	MiniAdpter.EnvConfig=null;
	MiniAdpter.window=null;
	MiniAdpter._preCreateElement=null;
	MiniAdpter._inited=false;
	MiniAdpter.wxRequest=null;
	MiniAdpter.parseXMLFromString=function(value){
		var rst;
		var Parser;
		value=value.replace(/>\s+</g,'><');
		try {
			/*__JS__ */rst=(new window.Parser.DOMParser()).parseFromString(value,'text/xml');
			}catch (error){
			throw "需要引入xml解析库文件";
		}
		return rst;
	}

	MiniAdpter.idx=1;
	return MiniAdpter;
})()


//class laya.wx.mini.MiniImage
var MiniImage=(function(){
	function MiniImage(){}
	__class(MiniImage,'laya.wx.mini.MiniImage');
	var __proto=MiniImage.prototype;
	__proto._loadImage=function(url){
		var thisLoader=this;
		url=URL.formatURL(url);
		if (!MiniFileMgr.getFileIsExist(url))
			MiniFileMgr.downImg(url,new Handler(MiniImage,MiniImage.onDownImgCallBack,[url,thisLoader]),url);
		else
		MiniImage.onCreateImage(url,thisLoader);
	}

	MiniImage.onDownImgCallBack=function(sourceUrl,thisLoader,errorCode){
		if (!errorCode)
			MiniImage.onCreateImage(sourceUrl,thisLoader);
		else
		thisLoader.onError(null);
	}

	MiniImage.onCreateImage=function(sourceUrl,thisLoader){
		var saveFileName=MiniFileMgr.getFileName(sourceUrl);
		var tempFileUrl=sourceUrl.split("?")[0];
		var totalUrl=MiniFileMgr.fileNativeDir+"/"+saveFileName;
		if (thisLoader.imgCache==null)
			thisLoader.imgCache={};
		var image;
		function clear (){
			image.onload=null;
			image.onerror=null;
			delete thisLoader.imgCache[sourceUrl]
		};
		var onload=function (){
			clear();
			thisLoader.onLoaded(image);
		};
		var onerror=function (){
			clear();
			thisLoader.event(/*laya.events.Event.ERROR*/"error","Load image failed");
		}
		if (thisLoader._type=="nativeimage"){
			image=new Browser.window.Image();
			image.crossOrigin="";
			image.onload=onload;
			image.onerror=onerror;
			image.src=totalUrl;
			thisLoader.imgCache[sourceUrl]=image;
			}else {
			new HTMLImage.create(totalUrl,{onload:onload,onerror:onerror,onCreate:function (img){
					image=img;
					thisLoader.imgCache[sourceUrl]=img;
			}});
		}
	}

	return MiniImage;
})()


//class laya.wx.mini.MiniInput
var MiniInput=(function(){
	function MiniInput(){}
	__class(MiniInput,'laya.wx.mini.MiniInput');
	MiniInput.wxinputFocus=function(e){
		var _inputTarget=Input['inputElement'].target;
		if (_inputTarget && !_inputTarget.editable){
			return;
		}
		MiniAdpter.window.wx.offKeyboardConfirm();
		MiniAdpter.window.wx.offKeyboardInput();
		MiniAdpter.window.wx.showKeyboard({defaultValue:_inputTarget.text,maxLength:_inputTarget.maxChars,multiple:_inputTarget.multiline,confirmHold:true,confirmType:'done',success:function (res){
				},fail:function (res){
		}});
		MiniAdpter.window.wx.onKeyboardConfirm(function(res){
			var str=res ? res.value :"";
			_inputTarget.text=str;
			_inputTarget.event(/*laya.events.Event.INPUT*/"input");
			laya.wx.mini.MiniInput.inputEnter();
		})
		MiniAdpter.window.wx.onKeyboardInput(function(res){
			var str=res ? res.value :"";
			if (!_inputTarget.multiline){
				if (str.indexOf("\n")!=-1){
					laya.wx.mini.MiniInput.inputEnter();
					return;
				}
			}
			_inputTarget.text=str;
			_inputTarget.event(/*laya.events.Event.INPUT*/"input");
		});
	}

	MiniInput.inputEnter=function(){
		Input['inputElement'].target.focus=false;
	}

	MiniInput.wxinputblur=function(){
		MiniInput.hideKeyboard();
	}

	MiniInput.hideKeyboard=function(){
		MiniAdpter.window.wx.offKeyboardConfirm();
		MiniAdpter.window.wx.offKeyboardInput();
		MiniAdpter.window.wx.hideKeyboard({success:function (res){
				console.log('隐藏键盘')
				},fail:function (res){
				console.log("隐藏键盘出错:"+(res ? res.errMsg :""));
		}});
	}

	return MiniInput;
})()


//class laya.wx.mini.MiniXMLHttpRequest
var MiniXMLHttpRequest=(function(){
	function MiniXMLHttpRequest(){}
	__class(MiniXMLHttpRequest,'laya.wx.mini.MiniXMLHttpRequest');
	var __proto=MiniXMLHttpRequest.prototype;
	/**
	*加载文件
	*@param url
	*@param responseType 加载文件类型 text或 arraybuffer
	*@param data 数据结构体
	*/
	__proto.onFileLoad=function(url,responseType,data){
		var encoding="ascii";
		if (url.indexOf(".fnt")!=-1 || url.indexOf("fighter.json")!=-1){
			encoding="utf8";
			}else if (responseType=="arraybuffer"){
			encoding="";
		}
		this.onReadNativeFile(url,encoding,data);
	}

	/**
	*读取本地文件
	*@param fileUrl
	*@param encoding
	*@param date
	*/
	__proto.onReadNativeFile=function(fileUrl,encoding,data){
		(encoding===void 0)&& (encoding="ascill");
		if (!MiniFileMgr.getFileIsExist(fileUrl)){
			MiniFileMgr.read(fileUrl,encoding,new Handler(this,this.onReadFileCallBack,[fileUrl,data]),fileUrl);
			}else {
			MiniFileMgr.down(fileUrl,encoding,new Handler(this,this.onReadFileCallBack,[fileUrl,data]),fileUrl);
		}
	}

	/**
	*读取文件回调
	*@param nativeFileUrl
	*@param fileData
	*/
	__proto.onReadFileCallBack=function(nativeFileUrl,data,errorCode,fileData){
		var tempData;
		var requestData={};
		requestData.statusCode=200;
		requestData.header=data.header;
		if (!errorCode){
			tempData=fileData.data;
			requestData.data=tempData;
			requestData.errMsg="request:ok";
			data.success(requestData);
			}else if (errorCode==2){
			}else {
			requestData.errMsg="request:error";
			data.fail(requestData);
		}
	}

	return MiniXMLHttpRequest;
})()


//class laya.wx.mini.MiniFileMgr extends laya.events.EventDispatcher
var MiniFileMgr=(function(_super){
	function MiniFileMgr(){
		MiniFileMgr.__super.call(this);;
	}

	__class(MiniFileMgr,'laya.wx.mini.MiniFileMgr',_super);
	MiniFileMgr.isLoadFile=function(type){
		return MiniFileMgr._fileTypeArr.indexOf(type)!=-1 ? true :false;
	}

	MiniFileMgr.getFileIsExist=function(fileUrl){
		var fileNativePath=fileUrl.split("?")[0];
		var fileKey=MiniFileMgr._filesKey[fileNativePath];
		if (fileKey==null)
			return false;
		else
		return true;
		return false;
	}

	MiniFileMgr.onFileUpdate=function(tempFilePath,readyUrl){
		var fileurlkey=readyUrl.split("?")[0];
		var fileNativePath=MiniFileMgr._filesKey[fileurlkey];
		if (fileNativePath==null)
			MiniFileMgr._filesKey[fileurlkey]=readyUrl;
		else {
			if (fileNativePath !=readyUrl)
				MiniFileMgr.remove(readyUrl);
		}
	}

	MiniFileMgr.getFileName=function(fileUrl){
		try {
			return /*__JS__ */window.utilMd5.hexMD5(fileUrl);
			}catch (error){
			throw "需要引入md5库文件";
		}
		return /*__JS__ */window.utilMd5.hexMD5(fileUrl);
	}

	MiniFileMgr.exits=function(fileName,callBack){
		var nativeFileName=MiniFileMgr.getFileNativePath(fileName);
		MiniFileMgr.fs.getFileInfo({filePath:nativeFileName,success:function (data){
				callBack !=null && callBack.runWith([0,data]);
				},fail:function (data){
				callBack !=null && callBack.runWith([1,data]);
		}});
	}

	MiniFileMgr.read=function(filePath,encoding,callBack,readyUrl){
		(encoding===void 0)&& (encoding="ascill");
		(readyUrl===void 0)&& (readyUrl="");
		var fileUrl=MiniFileMgr.getFileNativePath(filePath);
		MiniFileMgr.fs.readFile({filePath:fileUrl,encoding:encoding,success:function (data){
				callBack !=null && callBack.runWith([0,data]);
				},fail:function (data){
				if (data)
					MiniFileMgr.down(readyUrl,encoding,callBack,readyUrl);
		}});
	}

	MiniFileMgr.down=function(fileUrl,encoding,callBack,readyUrl){
		(encoding===void 0)&& (encoding="ascill");
		(readyUrl===void 0)&& (readyUrl="");
		var savePath=MiniFileMgr.getFileNativePath(readyUrl);
		var downloadTask=MiniFileMgr.wxdown({url:fileUrl,filePath:savePath,success:function (data){
				if (data.statusCode===200)
					MiniFileMgr.readFile(data.filePath,encoding,callBack,readyUrl);
				},fail:function (data){
				callBack !=null && callBack.runWith([1,data]);
		}});
		downloadTask.onProgressUpdate(function(data){
			callBack !=null && callBack.runWith([2,data.progress]);
		});
	}

	MiniFileMgr.readFile=function(filePath,encoding,callBack,readyUrl){
		(encoding===void 0)&& (encoding="ascill");
		(readyUrl===void 0)&& (readyUrl="");
		MiniFileMgr.fs.readFile({filePath:filePath,encoding:encoding,success:function (data){
				MiniFileMgr.onFileUpdate(filePath,readyUrl);
				callBack !=null && callBack.runWith([0,data]);
				},fail:function (data){
				if (data)
					callBack !=null && callBack.runWith([1,data]);
		}});
	}

	MiniFileMgr.downImg=function(fileUrl,callBack,readyUrl){
		(readyUrl===void 0)&& (readyUrl="");
		var fileurlkey=readyUrl.split("?")[0];
		var fileNativePath=MiniFileMgr._filesKey[fileurlkey];
		var savePath=MiniFileMgr.getFileNativePath(readyUrl);
		var downloadTask=MiniFileMgr.wxdown({url:fileUrl,filePath:savePath,success:function (data){
				if (data.statusCode===200){
					if (fileNativePath==null)
						MiniFileMgr._filesKey[fileurlkey]=readyUrl;
					else {
						if (fileNativePath !=readyUrl)
							MiniFileMgr.remove(readyUrl);
					}
					callBack !=null && callBack.runWith([0]);
				}
				},fail:function (data){
				callBack !=null && callBack.runWith([1,data]);
		}});
	}

	MiniFileMgr.getFileNativePath=function(fileName){
		var nativeFileName=MiniFileMgr.getFileName(fileName);
		return laya.wx.mini.MiniFileMgr.fileNativeDir+"/"+nativeFileName;
	}

	MiniFileMgr.remove=function(readyUrl){
		var fileurlkey=readyUrl.split("?")[0];
		var fileKeyValue=MiniFileMgr._filesKey[fileurlkey];
		var deleteFileUrl=MiniFileMgr.getFileNativePath(fileKeyValue);
		Laya.loader.clearRes(fileKeyValue);
		MiniFileMgr.fs.unlink({filePath:deleteFileUrl,success:function (data){
				MiniFileMgr._filesKey[fileurlkey]=readyUrl;
				},fail:function (data){
		}});
	}

	MiniFileMgr.dir=function(callBack){
		MiniFileMgr.fs.getSavedFileList({success:function (res){
				callBack !=null && callBack.runWith([0,res]);
				},fail:function (res){
				callBack !=null && callBack.runWith([1,res]);
		}});
	}

	MiniFileMgr.existDir=function(dirPath,callBack){
		MiniFileMgr.fs.mkdir({dirPath:dirPath,success:function (data){
				callBack !=null && callBack.runWith([0,data]);
				},fail:function (data){
				callBack !=null && callBack.runWith([1,data]);
		}});
	}

	MiniFileMgr.setNativeFileDir=function(value){
		MiniFileMgr.fileNativeDir=/*__JS__ */wx.env.USER_DATA_PATH+value;
	}

	MiniFileMgr._filesKey={};
	MiniFileMgr.fileNativeDir=null;
	__static(MiniFileMgr,
	['_fileTypeArr',function(){return this._fileTypeArr=['json','ani','xml','sk','txt','atlas','swf','part','fnt','proto','lh','lav','lani','lmat','lm','ltc'];},'fs',function(){return this.fs=/*__JS__ */wx.getFileSystemManager();},'wxdown',function(){return this.wxdown=/*__JS__ */wx.downloadFile;}
	]);
	return MiniFileMgr;
})(EventDispatcher)


//class laya.wx.mini.MiniSound extends laya.events.EventDispatcher
var MiniSound=(function(_super){
	function MiniSound(){
		this._sound=null;
		/**
		*声音URL
		*/
		this.url=null;
		/**
		*是否已加载完成
		*/
		this.loaded=false;
		MiniSound.__super.call(this);
		this._sound=MiniSound._createSound();
	}

	__class(MiniSound,'laya.wx.mini.MiniSound',_super);
	var __proto=MiniSound.prototype;
	/**
	*加载声音。
	*@param url 地址。
	*
	*/
	__proto.load=function(url){
		var _$this=this;
		url=URL.formatURL(url);
		this.url=url;
		if (MiniSound._audioCache[url]){
			this.event(/*laya.events.Event.COMPLETE*/"complete");
			return;
		}
		this._sound.src=url;
		this._sound.onCanplay(onCanPlay);
		var me=this;
		function onCanPlay (){
			_clearSound();
			me.loaded=true;
			me.event(/*laya.events.Event.COMPLETE*/"complete");
			MiniSound._audioCache[me.url]=me;
		}
		this._sound.onError(onError);
		function onError (){
			_clearSound();
			me.event(/*laya.events.Event.ERROR*/"error");
		}
		function _clearSound (){
			_$this._sound.onCanplay(null);
			_$this._sound.onError(null);
		}
	}

	/**
	*播放声音。
	*@param startTime 开始时间,单位秒
	*@param loops 循环次数,0表示一直循环
	*@return 声道 SoundChannel 对象。
	*
	*/
	__proto.play=function(startTime,loops){
		(startTime===void 0)&& (startTime=0);
		(loops===void 0)&& (loops=0);
		var tSound;
		if (this.url==SoundManager._musicClass){
			if (!MiniSound._musicAudio)MiniSound._musicAudio=MiniSound._createSound();
			tSound=MiniSound._musicAudio;
			}else {
			tSound=MiniSound._createSound();
		}
		tSound.src=this.url;
		var channel=new MiniSoundChannel(tSound);
		channel.url=this.url;
		channel.loops=loops;
		channel.startTime=startTime;
		channel.play();
		SoundManager.addChannel(channel);
		return channel;
	}

	/**
	*释放声音资源。
	*
	*/
	__proto.dispose=function(){
		var ad=MiniSound._audioCache[this.url];
		if (ad){
			ad.src="";
			delete MiniSound._audioCache[this.url];
		}
	}

	/**
	*获取总时间。
	*/
	__getset(0,__proto,'duration',function(){
		return this._sound.duration;
	});

	MiniSound._createSound=function(){
		MiniSound._id++;
		return MiniAdpter.window.wx.createInnerAudioContext();
	}

	MiniSound._musicAudio=null;
	MiniSound._id=0;
	MiniSound._audioCache={};
	return MiniSound;
})(EventDispatcher)


/**
*@private
*wxaudio 方式播放声音的音轨控制
*/
//class laya.wx.mini.MiniSoundChannel extends laya.media.SoundChannel
var MiniSoundChannel=(function(_super){
	function MiniSoundChannel(audio){
		this._audio=null;
		this._onEnd=null;
		MiniSoundChannel.__super.call(this);
		this._audio=audio;
		this._onEnd=Utils.bind(this.__onEnd,this);
		audio.onEnded(this._onEnd);
	}

	__class(MiniSoundChannel,'laya.wx.mini.MiniSoundChannel',_super);
	var __proto=MiniSoundChannel.prototype;
	__proto.__onEnd=function(){
		if (this.loops==1){
			if (this.completeHandler){
				Laya.timer.once(10,this,this.__runComplete,[this.completeHandler],false);
				this.completeHandler=null;
			}
			this.stop();
			this.event(/*laya.events.Event.COMPLETE*/"complete");
			return;
		}
		if (this.loops > 0){
			this.loops--;
		}
		this.startTime=0;
		this.play();
	}

	/**
	*播放
	*/
	__proto.play=function(){
		this.isStopped=false;
		SoundManager.addChannel(this);
		this._audio.play();
	}

	/**
	*停止播放
	*
	*/
	__proto.stop=function(){
		this.isStopped=true;
		SoundManager.removeChannel(this);
		this.completeHandler=null;
		if (!this._audio)
			return;
		this._audio.stop();
		this._audio.onEnded(null);
		this._audio=null;
	}

	__proto.pause=function(){
		this.isStopped=true;
		this._audio.pause();
	}

	__proto.resume=function(){
		if (!this._audio)
			return;
		this.isStopped=false;
		SoundManager.addChannel(this);
		this._audio.play();
	}

	/**
	*当前播放到的位置
	*@return
	*
	*/
	__getset(0,__proto,'position',function(){
		if (!this._audio)
			return 0;
		return this._audio.currentTime;
	});

	/**
	*获取总时间。
	*/
	__getset(0,__proto,'duration',function(){
		if (!this._audio)
			return 0;
		return this._audio.duration;
	});

	/**
	*设置音量
	*@param v
	*
	*/
	/**
	*获取音量
	*@return
	*
	*/
	__getset(0,__proto,'volume',function(){
		return 1;
		},function(v){
	});

	return MiniSoundChannel;
})(SoundChannel)



})(window,document,Laya);

if (typeof define === 'function' && define.amd){
	define('laya.core', ['require', "exports"], function(require, exports) {
        'use strict';
        Object.defineProperty(exports, '__esModule', { value: true });
        for (var i in Laya) {
			var o = Laya[i];
            o && o.__isclass && (exports[i] = o);
        }
    });
}