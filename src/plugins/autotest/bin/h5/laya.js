
/***********************************/
/*http://www.layabox.com  2017/12/12*/
/***********************************/
var Laya=window.Laya=(function(window,document){
	var Laya={
		__internals:[],
		__packages:{},
		__classmap:{'Object':Object,'Function':Function,'Array':Array,'String':String},
		__sysClass:{'object':'Object','array':'Array','string':'String','dictionary':'Dictionary'},
		__propun:{writable: true,enumerable: false,configurable: true},
		__presubstr:String.prototype.substr,
		__substr:function(ofs,sz){return arguments.length==1?Laya.__presubstr.call(this,ofs):Laya.__presubstr.call(this,ofs,sz>0?sz:(this.length+sz));},
		__init:function(_classs){_classs.forEach(function(o){o.__init$ && o.__init$();});},
		__isClass:function(o){return o && (o.__isclass || o==Object || o==String || o==Array);},
		__newvec:function(sz,value){
			var d=[];
			d.length=sz;
			for(var i=0;i<sz;i++) d[i]=value;
			return d;
		},
		__extend:function(d,b){
			for (var p in b){
				if (!b.hasOwnProperty(p)) continue;
				var gs=Object.getOwnPropertyDescriptor(b, p);
				var g = gs.get, s = gs.set; 
				if ( g || s ) {
					if ( g && s)
						Object.defineProperty(d,p,gs);
					else{
						g && Object.defineProperty(d, p, g);
						s && Object.defineProperty(d, p, s);
					}
				}
				else d[p] = b[p];
			}
			function __() { Laya.un(this,'constructor',d); }__.prototype=b.prototype;d.prototype=new __();Laya.un(d.prototype,'__imps',Laya.__copy({},b.prototype.__imps));
		},
		__copy:function(dec,src){
			if(!src) return null;
			dec=dec||{};
			for(var i in src) dec[i]=src[i];
			return dec;
		},
		__package:function(name,o){
			if(Laya.__packages[name]) return;
			Laya.__packages[name]=true;
			var p=window,strs=name.split('.');
			if(strs.length>1){
				for(var i=0,sz=strs.length-1;i<sz;i++){
					var c=p[strs[i]];
					p=c?c:(p[strs[i]]={});
				}
			}
			p[strs[strs.length-1]] || (p[strs[strs.length-1]]=o||{});
		},
		__hasOwnProperty:function(name,o){
			o=o ||this;
		    function classHas(name,o){
				if(Object.hasOwnProperty.call(o.prototype,name)) return true;
				var s=o.prototype.__super;
				return s==null?null:classHas(name,s);
			}
			return (Object.hasOwnProperty.call(o,name)) || classHas(name,o.__class);
		},
		__typeof:function(o,value){
			if(!o || !value) return false;
			if(value===String) return (typeof o==='string');
			if(value===Number) return (typeof o==='number');
			if(value.__interface__) value=value.__interface__;
			else if(typeof value!='string')  return (o instanceof value);
			return (o.__imps && o.__imps[value]) || (o.__class==value);
		},
		__as:function(value,type){
			return (this.__typeof(value,type))?value:null;
		},
        __int:function(value){
            return value?parseInt(value):0;
        },
		interface:function(name,_super){
			Laya.__package(name,{});
			var ins=Laya.__internals;
			var a=ins[name]=ins[name] || {self:name};
			if(_super)
			{
				var supers=_super.split(',');
				a.extend=[];
				for(var i=0;i<supers.length;i++){
					var nm=supers[i];
					ins[nm]=ins[nm] || {self:nm};
					a.extend.push(ins[nm]);
				}
			}
			var o=window,words=name.split('.');
			for(var i=0;i<words.length-1;i++) o=o[words[i]];
			o[words[words.length-1]]={__interface__:name};
		},
		class:function(o,fullName,_super,miniName){
			_super && Laya.__extend(o,_super);
			if(fullName){
				Laya.__package(fullName,o);
				Laya.__classmap[fullName]=o;
				if(fullName.indexOf('.')>0){
					if(fullName.indexOf('laya.')==0){
						var paths=fullName.split('.');
						miniName=miniName || paths[paths.length-1];
						if(Laya[miniName]) console.log("Warning!,this class["+miniName+"] already exist:",Laya[miniName]);
						Laya[miniName]=o;
					}
				}
				else {
					if(fullName=="Main")
						window.Main=o;
					else{
						if(Laya[fullName]){
							console.log("Error!,this class["+fullName+"] already exist:",Laya[fullName]);
						}
						Laya[fullName]=o;
					}
				}
			}
			var un=Laya.un,p=o.prototype;
			un(p,'hasOwnProperty',Laya.__hasOwnProperty);
			un(p,'__class',o);
			un(p,'__super',_super);
			un(p,'__className',fullName);
			un(o,'__super',_super);
			un(o,'__className',fullName);
			un(o,'__isclass',true);
			un(o,'super',function(o){this.__super.call(o);});
		},
		imps:function(dec,src){
			if(!src) return null;
			var d=dec.__imps|| Laya.un(dec,'__imps',{});
			function __(name){
				var c,exs;
				if(! (c=Laya.__internals[name]) ) return;
				d[name]=true;
				if(!(exs=c.extend)) return;
				for(var i=0;i<exs.length;i++){
					__(exs[i].self);
				}
			}
			for(var i in src) __(i);
		},
        superSet:function(clas,o,prop,value){
            var fun = clas.prototype["_$set_"+prop];
            fun && fun.call(o,value);
        },
        superGet:function(clas,o,prop){
            var fun = clas.prototype["_$get_"+prop];
           	return fun?fun.call(o):null;
        },
		getset:function(isStatic,o,name,getfn,setfn){
			if(!isStatic){
				getfn && Laya.un(o,'_$get_'+name,getfn);
				setfn && Laya.un(o,'_$set_'+name,setfn);
			}
			else{
				getfn && (o['_$GET_'+name]=getfn);
				setfn && (o['_$SET_'+name]=setfn);
			}
			if(getfn && setfn) 
				Object.defineProperty(o,name,{get:getfn,set:setfn,enumerable:false,configurable:true});
			else{
				getfn && Object.defineProperty(o,name,{get:getfn,enumerable:false,configurable:true});
				setfn && Object.defineProperty(o,name,{set:setfn,enumerable:false,configurable:true});
			}
		},
		static:function(_class,def){
				for(var i=0,sz=def.length;i<sz;i+=2){
					if(def[i]=='length') 
						_class.length=def[i+1].call(_class);
					else{
						function tmp(){
							var name=def[i];
							var getfn=def[i+1];
							Object.defineProperty(_class,name,{
								get:function(){delete this[name];return this[name]=getfn.call(this);},
								set:function(v){delete this[name];this[name]=v;},enumerable: true,configurable: true});
						}
						tmp();
					}
				}
		},		
		un:function(obj,name,value){
			value || (value=obj[name]);
			Laya.__propun.value=value;
			Object.defineProperty(obj, name, Laya.__propun);
			return value;
		},
		uns:function(obj,names){
			names.forEach(function(o){Laya.un(obj,o)});
		}
	};

    window.console=window.console || ({log:function(){}});
	window.trace=window.console.log;
	Error.prototype.throwError=function(){throw arguments;};
	//String.prototype.substr=Laya.__substr;
	Object.defineProperty(Array.prototype,'fixed',{enumerable: false});

	return Laya;
})(window,document);

(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;
	//file:///E:/git/layaair-master/core/src/laya/runtime/IMarket.as=======1100000100.000049/1100000100.000049
Laya.interface('laya.runtime.IMarket');
	//file:///E:/git/layaair-master/core/src/laya/resource/IDispose.as=======1100000100.000040/1100000100.000040
Laya.interface('laya.resource.IDispose');
	//file:///E:/git/layaair-master/core/src/laya/filters/IFilterAction.as=======1100000100.000029/1100000100.000029
Laya.interface('laya.filters.IFilterAction');
	//file:///E:/git/layaair-master/core/src/laya/runtime/ICPlatformClass.as=======1100000100.000025/1100000100.000025
Laya.interface('laya.runtime.ICPlatformClass');
	//file:///E:/git/layaair-master/core/src/Laya.as=======1000199.999824/1000199.999824
/**
*<code>Laya</code> 是全局对象的引用入口集。
*Laya类引用了一些常用的全局对象，比如Laya.stage：舞台，Laya.timer：时间管理器，Laya.loader：加载管理器，使用时注意大小写。
*/
//class Laya
var ___Laya=(function(){
	//function Laya(){}
	/**
	*表示是否捕获全局错误并弹出提示。默认为false。
	*适用于移动设备等不方便调试的时候，设置为true后，如有未知错误，可以弹窗抛出详细错误堆栈。
	*/
	__getset(1,Laya,'alertGlobalError',null,function(value){
		var erralert=0;
		if (value){
			Browser.window.onerror=function (msg,url,line,column,detail){
				if (erralert++< 5 && detail)
					alert("出错啦，请把此信息截图给研发商\n"+msg+"\n"+detail.stack);
			}
			}else {
			Browser.window.onerror=null;
		}
	});

	Laya.init=function(width,height,__plugins){
		var plugins=[];for(var i=2,sz=arguments.length;i<sz;i++)plugins.push(arguments[i]);
		if (Laya._isinit)return;
		Laya._isinit=true;
		if (window.conch)RunDriver.enableNative();
		ArrayBuffer.prototype.slice || (ArrayBuffer.prototype.slice=Laya._arrayBufferSlice);
		LayaGL.__init__();
		Browser.__init__();
		Context.__init__();
		Laya.timer=new Timer();
		Laya.loader=new LoaderManager();
		WeakObject.__init__();
		for (var i=0,n=plugins.length;i < n;i++){
			if (plugins[i].enable)plugins[i].enable();
		}
		ResourceManager.__init__();
		CacheManger.beginCheck();
		Laya._currentStage=Laya.stage=new Stage();
		var location=Browser.window.location;
		var pathName=location.pathname;
		pathName=pathName.charAt(2)==':' ? pathName.substring(1):pathName;
		URL.rootPath=URL.basePath=URL.getPath(location.protocol=="file:" ? pathName :location.protocol+"//"+location.host+location.pathname);
		Laya.render=new Render(0,0);
		Laya.stage.size(width,height);
		window.stage=Laya.stage;
		RenderSprite.__init__();
		KeyBoardManager.__init__();
		MouseManager.instance.__init__(Laya.stage,Render.canvas);
		Input.__init__();
		SoundManager.autoStopMusic=true;
		return Render.canvas;
	}

	Laya._arrayBufferSlice=function(start,end){
		var arr=this;
		var arrU8List=new Uint8Array(arr,start,end-start);
		var newU8List=new Uint8Array(arrU8List.length);
		newU8List.set(arrU8List);
		return newU8List.buffer;
	}

	Laya.stage=null;
	Laya.timer=null;
	Laya.loader=null;
	Laya.version="1.7.7beta";
	Laya.render=null;
	Laya._currentStage=null;
	Laya._isinit=false;
	__static(Laya,
	['conchMarket',function(){return this.conchMarket=window.conch?conchMarket:null;},'PlatformClass',function(){return this.PlatformClass=window.PlatformClass;}
	]);
	return Laya;
})()


	//file:///E:/git/layaair-master/core/src/Config.as=======199.999996/199.999996
/**
*Config 用于配置一些全局参数。如需更改，请在初始化引擎之前设置。
*/
//class Config
var Config=(function(){
	function Config(){}
	__class(Config,'Config');
	Config.WebGLTextCacheCount=500;
	Config.atlasEnable=false;
	Config.animationInterval=50;
	Config.isAntialias=false;
	Config.isAlpha=false;
	Config.premultipliedAlpha=true;
	Config.isStencil=true;
	Config.preserveDrawingBuffer=false;
	Config.smartCache=false;
	Config.webGL2D_MeshAllocMaxMem=true;
	return Config;
})()


	//file:///E:/git/layaair-master/core/src/laya/Const.as=======199.999995/199.999995
/**
*@private
*静态常量集合
*/
//class laya.Const
var Const=(function(){
	function Const(){}
	__class(Const,'laya.Const');
	Const.DISPLAY=0x01;
	Const.HAS_ZORDER=0x02;
	Const.HAS_MOUSE=0x04;
	Const.DISPLAYED_INSTAGE=0x08;
	return Const;
})()


	//file:///E:/git/layaair-master/core/src/laya/events/EventDispatcher.as=======199.999990/199.999990
/**
*<code>EventDispatcher</code> 类是可调度事件的所有类的基类。
*/
//class laya.events.EventDispatcher
var EventDispatcher=(function(){
	var EventHandler;
	function EventDispatcher(){
		/**@private */
		this._events=null;
	}

	__class(EventDispatcher,'laya.events.EventDispatcher');
	var __proto=EventDispatcher.prototype;
	/**
	*检查 EventDispatcher 对象是否为特定事件类型注册了任何侦听器。
	*@param type 事件的类型。
	*@return 如果指定类型的侦听器已注册，则值为 true；否则，值为 false。
	*/
	__proto.hasListener=function(type){
		var listener=this._events && this._events[type];
		return !!listener;
	}

	/**
	*派发事件。
	*@param type 事件类型。
	*@param data （可选）回调数据。<b>注意：</b>如果是需要传递多个参数 p1,p2,p3,...可以使用数组结构如：[p1,p2,p3,...] ；如果需要回调单个参数 p ，且 p 是一个数组，则需要使用结构如：[p]，其他的单个参数 p ，可以直接传入参数 p。
	*@return 此事件类型是否有侦听者，如果有侦听者则值为 true，否则值为 false。
	*/
	__proto.event=function(type,data){
		if (!this._events || !this._events[type])return false;
		var listeners=this._events[type];
		if (listeners.run){
			if (listeners.once)delete this._events[type];
			data !=null ? listeners.runWith(data):listeners.run();
			}else {
			for (var i=0,n=listeners.length;i < n;i++){
				var listener=listeners[i];
				if (listener){
					(data !=null)? listener.runWith(data):listener.run();
				}
				if (!listener || listener.once){
					listeners.splice(i,1);
					i--;
					n--;
				}
			}
			if (listeners.length===0 && this._events)delete this._events[type];
		}
		return true;
	}

	/**
	*使用 EventDispatcher 对象注册指定类型的事件侦听器对象，以使侦听器能够接收事件通知。
	*@param type 事件的类型。
	*@param caller 事件侦听函数的执行域。
	*@param listener 事件侦听函数。
	*@param args （可选）事件侦听函数的回调参数。
	*@return 此 EventDispatcher 对象。
	*/
	__proto.on=function(type,caller,listener,args){
		return this._createListener(type,caller,listener,args,false);
	}

	/**
	*使用 EventDispatcher 对象注册指定类型的事件侦听器对象，以使侦听器能够接收事件通知，此侦听事件响应一次后自动移除。
	*@param type 事件的类型。
	*@param caller 事件侦听函数的执行域。
	*@param listener 事件侦听函数。
	*@param args （可选）事件侦听函数的回调参数。
	*@return 此 EventDispatcher 对象。
	*/
	__proto.once=function(type,caller,listener,args){
		return this._createListener(type,caller,listener,args,true);
	}

	/**@private */
	__proto._createListener=function(type,caller,listener,args,once,offBefore){
		(offBefore===void 0)&& (offBefore=true);
		offBefore && this.off(type,caller,listener,once);
		var handler=EventHandler.create(caller || this,listener,args,once);
		this._events || (this._events={});
		var events=this._events;
		if (!events[type])events[type]=handler;
		else {
			if (!events[type].run)events[type].push(handler);
			else events[type]=[events[type],handler];
		}
		return this;
	}

	/**
	*从 EventDispatcher 对象中删除侦听器。
	*@param type 事件的类型。
	*@param caller 事件侦听函数的执行域。
	*@param listener 事件侦听函数。
	*@param onceOnly （可选）如果值为 true ,则只移除通过 once 方法添加的侦听器。
	*@return 此 EventDispatcher 对象。
	*/
	__proto.off=function(type,caller,listener,onceOnly){
		(onceOnly===void 0)&& (onceOnly=false);
		if (!this._events || !this._events[type])return this;
		var listeners=this._events[type];
		if (listener !=null){
			if (listeners.run){
				if ((!caller || listeners.caller===caller)&& listeners.method===listener && (!onceOnly || listeners.once)){
					delete this._events[type];
					listeners.recover();
				}
				}else {
				var count=0;
				for (var i=0,n=listeners.length;i < n;i++){
					var item=listeners[i];
					if (item && (!caller || item.caller===caller)&& item.method===listener && (!onceOnly || item.once)){
						count++;
						listeners[i]=null;
						item.recover();
					}
				}
				if (count===n)delete this._events[type];
			}
		}
		return this;
	}

	/**
	*从 EventDispatcher 对象中删除指定事件类型的所有侦听器。
	*@param type （可选）事件类型，如果值为 null，则移除本对象所有类型的侦听器。
	*@return 此 EventDispatcher 对象。
	*/
	__proto.offAll=function(type){
		var events=this._events;
		if (!events)return this;
		if (type){
			this._recoverHandlers(events[type]);
			delete events[type];
			}else {
			for (var name in events){
				this._recoverHandlers(events[name]);
			}
			this._events=null;
		}
		return this;
	}

	__proto._recoverHandlers=function(arr){
		if (!arr)return;
		if (arr.run){
			arr.recover();
			}else {
			for (var i=arr.length-1;i >-1;i--){
				if (arr[i]){
					arr[i].recover();
					arr[i]=null;
				}
			}
		}
	}

	/**
	*检测指定事件类型是否是鼠标事件。
	*@param type 事件的类型。
	*@return 如果是鼠标事件，则值为 true;否则，值为 false。
	*/
	__proto.isMouseEvent=function(type){
		return EventDispatcher.MOUSE_EVENTS[type] || false;
	}

	EventDispatcher.MOUSE_EVENTS={"rightmousedown":true,"rightmouseup":true,"rightclick":true,"mousedown":true,"mouseup":true,"mousemove":true,"mouseover":true,"mouseout":true,"click":true,"doubleclick":true};
	EventDispatcher.__init$=function(){
		Object.defineProperty(laya.events.EventDispatcher.prototype,"_events",{enumerable:false,writable:true});
		/**@private */
		//class EventHandler extends laya.utils.Handler
		EventHandler=(function(_super){
			function EventHandler(caller,method,args,once){
				EventHandler.__super.call(this,caller,method,args,once);
			}
			__class(EventHandler,'',_super);
			var __proto=EventHandler.prototype;
			__proto.recover=function(){
				if (this._id > 0){
					this._id=0;
					EventHandler._pool.push(this.clear());
				}
			}
			EventHandler.create=function(caller,method,args,once){
				(once===void 0)&& (once=true);
				if (EventHandler._pool.length)return EventHandler._pool.pop().setTo(caller,method,args,once);
				return new EventHandler(caller,method,args,once);
			}
			EventHandler._pool=[];
			return EventHandler;
		})(Handler)
	}

	return EventDispatcher;
})()


	//file:///E:/git/layaair-master/core/src/laya/utils/Handler.as=======199.999988/199.999988
/**
*<p><code>Handler</code> 是事件处理器类。</p>
*<p>推荐使用 Handler.create()方法从对象池创建，减少对象创建消耗。创建的 Handler 对象不再使用后，可以使用 Handler.recover()将其回收到对象池，回收后不要再使用此对象，否则会导致不可预料的错误。</p>
*<p><b>注意：</b>由于鼠标事件也用本对象池，不正确的回收及调用，可能会影响鼠标事件的执行。</p>
*/
//class laya.utils.Handler
var Handler=(function(){
	function Handler(caller,method,args,once){
		/**执行域(this)。*/
		//this.caller=null;
		/**处理方法。*/
		//this.method=null;
		/**参数。*/
		//this.args=null;
		/**表示是否只执行一次。如果为true，回调后执行recover()进行回收，回收后会被再利用，默认为false 。*/
		this.once=false;
		/**@private */
		this._id=0;
		(once===void 0)&& (once=false);
		this.setTo(caller,method,args,once);
	}

	__class(Handler,'laya.utils.Handler');
	var __proto=Handler.prototype;
	/**
	*设置此对象的指定属性值。
	*@param caller 执行域(this)。
	*@param method 回调方法。
	*@param args 携带的参数。
	*@param once 是否只执行一次，如果为true，执行后执行recover()进行回收。
	*@return 返回 handler 本身。
	*/
	__proto.setTo=function(caller,method,args,once){
		this._id=Handler._gid++;
		this.caller=caller;
		this.method=method;
		this.args=args;
		this.once=once;
		return this;
	}

	/**
	*执行处理器。
	*/
	__proto.run=function(){
		if (this.method==null)return null;
		var id=this._id;
		var result=this.method.apply(this.caller,this.args);
		this._id===id && this.once && this.recover();
		return result;
	}

	/**
	*执行处理器，并携带额外数据。
	*@param data 附加的回调数据，可以是单数据或者Array(作为多参)。
	*/
	__proto.runWith=function(data){
		if (this.method==null)return null;
		var id=this._id;
		if (data==null)
			var result=this.method.apply(this.caller,this.args);
		else if (!this.args && !data.unshift)result=this.method.call(this.caller,data);
		else if (this.args)result=this.method.apply(this.caller,this.args.concat(data));
		else result=this.method.apply(this.caller,data);
		this._id===id && this.once && this.recover();
		return result;
	}

	/**
	*清理对象引用。
	*/
	__proto.clear=function(){
		this.caller=null;
		this.method=null;
		this.args=null;
		return this;
	}

	/**
	*清理并回收到 Handler 对象池内。
	*/
	__proto.recover=function(){
		if (this._id > 0){
			this._id=0;
			Handler._pool.push(this.clear());
		}
	}

	Handler.create=function(caller,method,args,once){
		(once===void 0)&& (once=true);
		if (Handler._pool.length)return Handler._pool.pop().setTo(caller,method,args,once);
		return new Handler(caller,method,args,once);
	}

	Handler._pool=[];
	Handler._gid=1;
	return Handler;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/BitmapFont.as=======199.999987/199.999987
/**
*<code>BitmapFont</code> 是位图字体类，用于定义位图字体信息。
*字体制作及使用方法，请参考文章
*@see http://ldc.layabox.com/doc/?nav=ch-js-1-2-5
*/
//class laya.display.BitmapFont
var BitmapFont=(function(){
	function BitmapFont(){
		this._texture=null;
		this._fontCharDic={};
		this._fontWidthMap={};
		this._complete=null;
		this._path=null;
		this._maxWidth=0;
		this._spaceWidth=10;
		this._padding=null;
		/**当前位图字体字号，使用时，如果字号和设置不同，并且autoScaleSize=true，则按照设置字号比率进行缩放显示。*/
		this.fontSize=12;
		/**表示是否根据实际使用的字体大小缩放位图字体大小。*/
		this.autoScaleSize=false;
		/**字符间距（以像素为单位）。*/
		this.letterSpacing=0;
	}

	__class(BitmapFont,'laya.display.BitmapFont');
	var __proto=BitmapFont.prototype;
	/**
	*通过指定位图字体文件路径，加载位图字体文件，加载完成后会自动解析。
	*@param path 位图字体文件的路径。
	*@param complete 加载并解析完成的回调。
	*/
	__proto.loadFont=function(path,complete){
		this._path=path;
		this._complete=complete;
		if (!path || path.indexOf(".fnt")===-1){
			console.error('Bitmap font configuration information must be a ".fnt" file');
			return;
		}
		Laya.loader.load([{url:path,type:"xml"},{url:path.replace(".fnt",".png"),type:"image"}],Handler.create(this,this._onLoaded));
	}

	/**
	*@private
	*/
	__proto._onLoaded=function(){
		this.parseFont(Loader.getRes(this._path),Loader.getRes(this._path.replace(".fnt",".png")));
		this._complete && this._complete.run();
	}

	/**
	*解析字体文件。
	*@param xml 字体文件XML。
	*@param texture 字体的纹理。
	*/
	__proto.parseFont=function(xml,texture){
		if (xml==null || texture==null)return;
		this._texture=texture;
		var tX=0;
		var tScale=1;
		var tInfo=xml.getElementsByTagName("info");
		this.fontSize=parseInt(tInfo[0].attributes["size"].nodeValue);
		var tPadding=tInfo[0].attributes["padding"].nodeValue;
		var tPaddingArray=tPadding.split(",");
		this._padding=[parseInt(tPaddingArray[0]),parseInt(tPaddingArray[1]),parseInt(tPaddingArray[2]),parseInt(tPaddingArray[3])];
		var chars=xml.getElementsByTagName("char");
		var i=0;
		for (i=0;i < chars.length;i++){
			var tAttribute=chars[i].attributes;
			var tId=parseInt(tAttribute["id"].nodeValue);
			var xOffset=parseInt(tAttribute["xoffset"].nodeValue)/ tScale;
			var yOffset=parseInt(tAttribute["yoffset"].nodeValue)/ tScale;
			var xAdvance=parseInt(tAttribute["xadvance"].nodeValue)/ tScale;
			var region=new Rectangle();
			region.x=parseInt(tAttribute["x"].nodeValue);
			region.y=parseInt(tAttribute["y"].nodeValue);
			region.width=parseInt(tAttribute["width"].nodeValue);
			region.height=parseInt(tAttribute["height"].nodeValue);
			var tTexture=Texture.create(texture,region.x,region.y,region.width,region.height,xOffset,yOffset);
			this._maxWidth=Math.max(this._maxWidth,xAdvance+this.letterSpacing);
			this._fontCharDic[tId]=tTexture;
			this._fontWidthMap[tId]=xAdvance;
		}
	}

	/**
	*获取指定字符的字体纹理对象。
	*@param char 字符。
	*@return 指定的字体纹理对象。
	*/
	__proto.getCharTexture=function(char){
		return this._fontCharDic[char.charCodeAt(0)];
	}

	/**
	*销毁位图字体，调用Text.unregisterBitmapFont 时，默认会销毁。
	*/
	__proto.destroy=function(){
		if (this._texture){
			for (var p in this._fontCharDic){
				var tTexture=this._fontCharDic[p];
				if (tTexture)tTexture.destroy();
			}
			this._texture.destroy();
			this._fontCharDic=null;
			this._fontWidthMap=null;
			this._texture=null;
			this._complete=null;
			this._padding=null;
		}
	}

	/**
	*设置空格的宽（如果字体库有空格，这里就可以不用设置了）。
	*@param spaceWidth 宽度，单位为像素。
	*/
	__proto.setSpaceWidth=function(spaceWidth){
		this._spaceWidth=spaceWidth;
	}

	/**
	*获取指定字符的宽度。
	*@param char 字符。
	*@return 宽度。
	*/
	__proto.getCharWidth=function(char){
		var code=char.charCodeAt(0);
		if (this._fontWidthMap[code])return this._fontWidthMap[code]+this.letterSpacing;
		if (char===" ")return this._spaceWidth+this.letterSpacing;
		return 0;
	}

	/**
	*获取指定文本内容的宽度。
	*@param text 文本内容。
	*@return 宽度。
	*/
	__proto.getTextWidth=function(text){
		var tWidth=0;
		for (var i=0,n=text.length;i < n;i++){
			tWidth+=this.getCharWidth(text.charAt(i));
		}
		return tWidth;
	}

	/**
	*获取最大字符宽度。
	*/
	__proto.getMaxWidth=function(){
		return this._maxWidth;
	}

	/**
	*获取最大字符高度。
	*/
	__proto.getMaxHeight=function(){
		return this.fontSize;
	}

	/**
	*@private
	*将指定的文本绘制到指定的显示对象上。
	*/
	__proto._drawText=function(text,sprite,drawX,drawY,align,width){
		var tWidth=this.getTextWidth(text);
		var tTexture;
		var dx=0;
		align==="center" && (dx=(width-tWidth)/ 2);
		align==="right" && (dx=(width-tWidth));
		var tx=0;
		for (var i=0,n=text.length;i < n;i++){
			tTexture=this.getCharTexture(text.charAt(i));
			if (tTexture){
				sprite.graphics.drawImage(tTexture,drawX+tx+dx,drawY);
				tx+=this.getCharWidth(text.charAt(i));
			}
		}
	}

	return BitmapFont;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/AlphaCmd.as=======199.999986/199.999986
/**
*...
*@author ww
*/
//class laya.display.cmd.AlphaCmd
var AlphaCmd=(function(){
	function AlphaCmd(){
		//this._alpha=NaN;
	}

	__class(AlphaCmd,'laya.display.cmd.AlphaCmd');
	var __proto=AlphaCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("AlphaCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.alpha(this._alpha);
	}

	__getset(0,__proto,'cmdID',function(){
		return "Alpha";
	});

	__getset(0,__proto,'alpha',function(){
		return this._alpha;
		},function(value){
		this._alpha=value;
	});

	AlphaCmd.create=function(alpha){
		var cmd=Pool.getItemByClass("AlphaCmd",AlphaCmd);
		cmd._alpha=alpha;
		return cmd;
	}

	AlphaCmd.ID="Alpha";
	return AlphaCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/ClipRectCmd.as=======199.999985/199.999985
/**
*...
*@author ww
*/
//class laya.display.cmd.ClipRectCmd
var ClipRectCmd=(function(){
	function ClipRectCmd(){
		//this._x=NaN;
		//this._y=NaN;
		//this._width=NaN;
		//this._height=NaN;
	}

	__class(ClipRectCmd,'laya.display.cmd.ClipRectCmd');
	var __proto=ClipRectCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("ClipRectCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.clipRect(this._x+gx,this._y+gy,this._width,this._height);
	}

	__getset(0,__proto,'cmdID',function(){
		return "ClipRect";
	});

	__getset(0,__proto,'width',function(){
		return this._width;
		},function(value){
		this._width=value;
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'height',function(){
		return this._height;
		},function(value){
		this._height=value;
	});

	ClipRectCmd.create=function(x,y,width,height){
		var cmd=Pool.getItemByClass("ClipRectCmd",ClipRectCmd);
		cmd._x=x;
		cmd._y=y;
		cmd._width=width;
		cmd._height=height;
		return cmd;
	}

	ClipRectCmd.ID="ClipRect";
	return ClipRectCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/DrawCircleCmd.as=======199.999984/199.999984
/**
*...
*@author ww
*/
//class laya.display.cmd.DrawCircleCmd
var DrawCircleCmd=(function(){
	function DrawCircleCmd(){
		//this._x=NaN;
		//this._y=NaN;
		//this._radius=NaN;
		//this._fillColor=null;
		//this._lineColor=null;
		//this._lineWidth=NaN;
		//this._vid=0;
	}

	__class(DrawCircleCmd,'laya.display.cmd.DrawCircleCmd');
	var __proto=DrawCircleCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._fillColor=null;
		this._lineColor=null;
		Pool.recover("DrawCircleCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context._drawCircle(this._x+gx,this._y+gy,this._radius,this._fillColor,this._lineColor,this._lineWidth,this._vid);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._lineColor;
		},function(value){
		this._lineColor=value;
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawCircle";
	});

	__getset(0,__proto,'fillColor',function(){
		return this._fillColor;
		},function(value){
		this._fillColor=value;
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'vid',function(){
		return this._vid;
		},function(value){
		this._vid=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'radius',function(){
		return this._radius;
		},function(value){
		this._radius=value;
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		this._lineWidth=value;
	});

	DrawCircleCmd.create=function(x,y,radius,fillColor,lineColor,lineWidth,vid){
		var cmd=Pool.getItemByClass("DrawCircleCmd",DrawCircleCmd);
		cmd._x=x;
		cmd._y=y;
		cmd._radius=radius;
		cmd._fillColor=fillColor;
		cmd._lineColor=lineColor;
		cmd._lineWidth=lineWidth;
		cmd._vid=vid;
		return cmd;
	}

	DrawCircleCmd.ID="DrawCircle";
	return DrawCircleCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/DrawCurvesCmd.as=======199.999983/199.999983
/**
*...
*@author ww
*/
//class laya.display.cmd.DrawCurvesCmd
var DrawCurvesCmd=(function(){
	function DrawCurvesCmd(){
		//this._x=NaN;
		//this._y=NaN;
		//this._points=null;
		//this._lineColor=null;
		//this._lineWidth=NaN;
	}

	__class(DrawCurvesCmd,'laya.display.cmd.DrawCurvesCmd');
	var __proto=DrawCurvesCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._points=null;
		this._lineColor=null;
		Pool.recover("DrawCurvesCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.drawCurves(this._x+gx,this._y+gy,this._points,this._lineColor,this._lineWidth);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._lineColor;
		},function(value){
		this._lineColor=value;
	});

	__getset(0,__proto,'points',function(){
		return this._points;
		},function(value){
		this._points=value;
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawCurves";
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		this._lineWidth=value;
	});

	DrawCurvesCmd.create=function(x,y,points,lineColor,lineWidth){
		var cmd=Pool.getItemByClass("DrawCurvesCmd",DrawCurvesCmd);
		cmd._x=x;
		cmd._y=y;
		cmd._points=points;
		cmd._lineColor=lineColor;
		cmd._lineWidth=lineWidth;
		return cmd;
	}

	DrawCurvesCmd.ID="DrawCurves";
	return DrawCurvesCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/DrawImageCmd.as=======199.999982/199.999982
/**
*...
*@author ww
*/
//class laya.display.cmd.DrawImageCmd
var DrawImageCmd=(function(){
	function DrawImageCmd(){
		//this._texture=null;
		//this._x=NaN;
		//this._y=NaN;
		//this._width=NaN;
		//this._height=NaN;
	}

	__class(DrawImageCmd,'laya.display.cmd.DrawImageCmd');
	var __proto=DrawImageCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._texture=null;
		Pool.recover("DrawImageCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.drawTexture(this._texture,this._x+gx,this._y+gy,this._width,this._height);
	}

	__getset(0,__proto,'cmdID',function(){
		return "DrawImage";
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'texture',function(){
		return this._texture;
		},function(value){
		this._texture=value;
	});

	__getset(0,__proto,'width',function(){
		return this._width;
		},function(value){
		this._width=value;
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'height',function(){
		return this._height;
		},function(value){
		this._height=value;
	});

	DrawImageCmd.create=function(texture,x,y,width,height){
		var cmd=Pool.getItemByClass("DrawImageCmd",DrawImageCmd);
		cmd._texture=texture;
		cmd._x=x;
		cmd._y=y;
		cmd._width=width;
		cmd._height=height;
		return cmd;
	}

	DrawImageCmd.ID="DrawImage";
	return DrawImageCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/DrawLineCmd.as=======199.999981/199.999981
/**
*...
*@author ww
*/
//class laya.display.cmd.DrawLineCmd
var DrawLineCmd=(function(){
	function DrawLineCmd(){
		//this._fromX=NaN;
		//this._fromY=NaN;
		//this._toX=NaN;
		//this._toY=NaN;
		//this._lineColor=null;
		//this._lineWidth=NaN;
		//this._vid=0;
	}

	__class(DrawLineCmd,'laya.display.cmd.DrawLineCmd');
	var __proto=DrawLineCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("DrawLineCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context._drawLine(gx,gy,this._fromX,this._fromY,this._toX,this._toY,this._lineColor,this._lineWidth,this._vid);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._lineColor;
		},function(value){
		this._lineColor=value;
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawLine";
	});

	__getset(0,__proto,'toY',function(){
		return this._toY;
		},function(value){
		this._toY=value;
	});

	__getset(0,__proto,'fromX',function(){
		return this._fromX;
		},function(value){
		this._fromX=value;
	});

	__getset(0,__proto,'vid',function(){
		return this._vid;
		},function(value){
		this._vid=value;
	});

	__getset(0,__proto,'toX',function(){
		return this._toX;
		},function(value){
		this._toX=value;
	});

	__getset(0,__proto,'fromY',function(){
		return this._fromY;
		},function(value){
		this._fromY=value;
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		this._lineWidth=value;
	});

	DrawLineCmd.create=function(fromX,fromY,toX,toY,lineColor,lineWidth,vid){
		var cmd=Pool.getItemByClass("DrawLineCmd",DrawLineCmd);
		cmd._fromX=fromX;
		cmd._fromY=fromY;
		cmd._toX=toX;
		cmd._toY=toY;
		cmd._lineColor=lineColor;
		cmd._lineWidth=lineWidth;
		cmd._vid=vid;
		return cmd;
	}

	DrawLineCmd.ID="DrawLine";
	return DrawLineCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/DrawLinesCmd.as=======199.999980/199.999980
/**
*...
*@author ww
*/
//class laya.display.cmd.DrawLinesCmd
var DrawLinesCmd=(function(){
	function DrawLinesCmd(){
		//this._x=NaN;
		//this._y=NaN;
		//this._points=null;
		//this._lineColor=null;
		//this._lineWidth=NaN;
		//this._vid=0;
	}

	__class(DrawLinesCmd,'laya.display.cmd.DrawLinesCmd');
	var __proto=DrawLinesCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._points=null;
		this._lineColor=null;
		Pool.recover("DrawLinesCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context._drawLines(this._x+gx,this._y+gy,this._points,this._lineColor,this._lineWidth,this._vid);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._lineColor;
		},function(value){
		this._lineColor=value;
	});

	__getset(0,__proto,'points',function(){
		return this._points;
		},function(value){
		this._points=value;
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawLines";
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'vid',function(){
		return this._vid;
		},function(value){
		this._vid=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		this._lineWidth=value;
	});

	DrawLinesCmd.create=function(x,y,points,lineColor,lineWidth,vid){
		var cmd=Pool.getItemByClass("DrawLinesCmd",DrawLinesCmd);
		cmd._x=x;
		cmd._y=y;
		cmd._points=points;
		cmd._lineColor=lineColor;
		cmd._lineWidth=lineWidth;
		cmd._vid=vid;
		return cmd;
	}

	DrawLinesCmd.ID="DrawLines";
	return DrawLinesCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/DrawPathCmd.as=======199.999979/199.999979
/**
*...
*@author ww
*/
//class laya.display.cmd.DrawPathCmd
var DrawPathCmd=(function(){
	function DrawPathCmd(){
		//this._x=NaN;
		//this._y=NaN;
		//this._paths=null;
		//this._brush=null;
		//this._pen=null;
	}

	__class(DrawPathCmd,'laya.display.cmd.DrawPathCmd');
	var __proto=DrawPathCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._paths=null;
		this._brush=null;
		this._pen=null;
		Pool.recover("DrawPathCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context._drawPath(this._x+gx,this._y+gy,this._paths,this._brush,this._pen);
	}

	__getset(0,__proto,'cmdID',function(){
		return "DrawPath";
	});

	__getset(0,__proto,'paths',function(){
		return this._paths;
		},function(value){
		this._paths=value;
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'brush',function(){
		return this._brush;
		},function(value){
		this._brush=value;
	});

	__getset(0,__proto,'pen',function(){
		return this._pen;
		},function(value){
		this._pen=value;
	});

	DrawPathCmd.create=function(x,y,paths,brush,pen){
		var cmd=Pool.getItemByClass("DrawPathCmd",DrawPathCmd);
		cmd._x=x;
		cmd._y=y;
		cmd._paths=paths;
		cmd._brush=brush;
		cmd._pen=pen;
		return cmd;
	}

	DrawPathCmd.ID="DrawPath";
	return DrawPathCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/DrawPieCmd.as=======199.999978/199.999978
/**
*...
*@author ww
*/
//class laya.display.cmd.DrawPieCmd
var DrawPieCmd=(function(){
	function DrawPieCmd(){
		//this._x=NaN;
		//this._y=NaN;
		//this._radius=NaN;
		//this._startAngle=NaN;
		//this._endAngle=NaN;
		//this._fillColor=null;
		//this._lineColor=null;
		//this._lineWidth=NaN;
		//this._vid=0;
	}

	__class(DrawPieCmd,'laya.display.cmd.DrawPieCmd');
	var __proto=DrawPieCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._fillColor=null;
		this._lineColor=null;
		Pool.recover("DrawPieCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context._drawPie(this._x+gx,this._y+gy,this._radius,this._startAngle,this._endAngle,this._fillColor,this._lineColor,this._lineWidth,this._vid);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._lineColor;
		},function(value){
		this._lineColor=value;
	});

	__getset(0,__proto,'startAngle',function(){
		return this._startAngle;
		},function(value){
		this._startAngle=value;
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawPie";
	});

	__getset(0,__proto,'fillColor',function(){
		return this._fillColor;
		},function(value){
		this._fillColor=value;
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'radius',function(){
		return this._radius;
		},function(value){
		this._radius=value;
	});

	__getset(0,__proto,'endAngle',function(){
		return this._endAngle;
		},function(value){
		this._endAngle=value;
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		this._lineWidth=value;
	});

	__getset(0,__proto,'vid',function(){
		return this._vid;
		},function(value){
		this._vid=value;
	});

	DrawPieCmd.create=function(x,y,radius,startAngle,endAngle,fillColor,lineColor,lineWidth,vid){
		var cmd=Pool.getItemByClass("DrawPieCmd",DrawPieCmd);
		cmd._x=x;
		cmd._y=y;
		cmd._radius=radius;
		cmd._startAngle=startAngle;
		cmd._endAngle=endAngle;
		cmd._fillColor=fillColor;
		cmd._lineColor=lineColor;
		cmd._lineWidth=lineWidth;
		cmd._vid=vid;
		return cmd;
	}

	DrawPieCmd.ID="DrawPie";
	return DrawPieCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/DrawPolyCmd.as=======199.999977/199.999977
/**
*...
*@author ww
*/
//class laya.display.cmd.DrawPolyCmd
var DrawPolyCmd=(function(){
	function DrawPolyCmd(){
		//this._x=NaN;
		//this._y=NaN;
		//this._points=null;
		//this._fillColor=null;
		//this._lineColor=null;
		//this._lineWidth=NaN;
		//this._isConvexPolygon=false;
		//this._vid=0;
	}

	__class(DrawPolyCmd,'laya.display.cmd.DrawPolyCmd');
	var __proto=DrawPolyCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._points=null;
		this._fillColor=null;
		this._lineColor=null;
		Pool.recover("DrawPolyCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context._drawPoly(this._x+gx,this._y+gy,this._points,this._fillColor,this._lineColor,this._lineWidth,this._isConvexPolygon,this._vid);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._lineColor;
		},function(value){
		this._lineColor=value;
	});

	__getset(0,__proto,'points',function(){
		return this._points;
		},function(value){
		this._points=value;
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawPoly";
	});

	__getset(0,__proto,'fillColor',function(){
		return this._fillColor;
		},function(value){
		this._fillColor=value;
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'isConvexPolygon',function(){
		return this._isConvexPolygon;
		},function(value){
		this._isConvexPolygon=value;
	});

	__getset(0,__proto,'vid',function(){
		return this._vid;
		},function(value){
		this._vid=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		this._lineWidth=value;
	});

	DrawPolyCmd.create=function(x,y,points,fillColor,lineColor,lineWidth,isConvexPolygon,vid){
		var cmd=Pool.getItemByClass("DrawPolyCmd",DrawPolyCmd);
		cmd._x=x;
		cmd._y=y;
		cmd._points=points;
		cmd._fillColor=fillColor;
		cmd._lineColor=lineColor;
		cmd._lineWidth=lineWidth;
		cmd._isConvexPolygon=isConvexPolygon;
		cmd._vid=vid;
		return cmd;
	}

	DrawPolyCmd.ID="DrawPoly";
	return DrawPolyCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/DrawRectCmd.as=======199.999976/199.999976
/**
*...
*@author ww
*/
//class laya.display.cmd.DrawRectCmd
var DrawRectCmd=(function(){
	function DrawRectCmd(){
		//this._x=NaN;
		//this._y=NaN;
		//this._width=NaN;
		//this._height=NaN;
		//this._fillColor=null;
		//this._lineColor=null;
		//this._lineWidth=NaN;
	}

	__class(DrawRectCmd,'laya.display.cmd.DrawRectCmd');
	var __proto=DrawRectCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._fillColor=null;
		this._lineColor=null;
		Pool.recover("DrawRectCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.drawRect(this._x+gx,this._y+gy,this._width,this._height,this._fillColor,this._lineColor,this._lineWidth);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._lineColor;
		},function(value){
		this._lineColor=value;
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawRect";
	});

	__getset(0,__proto,'fillColor',function(){
		return this._fillColor;
		},function(value){
		this._fillColor=value;
	});

	__getset(0,__proto,'width',function(){
		return this._width;
		},function(value){
		this._width=value;
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'height',function(){
		return this._height;
		},function(value){
		this._height=value;
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		this._lineWidth=value;
	});

	DrawRectCmd.create=function(x,y,width,height,fillColor,lineColor,lineWidth){
		var cmd=Pool.getItemByClass("DrawRectCmd",DrawRectCmd);
		cmd._x=x;
		cmd._y=y;
		cmd._width=width;
		cmd._height=height;
		cmd._fillColor=fillColor;
		cmd._lineColor=lineColor;
		cmd._lineWidth=lineWidth;
		return cmd;
	}

	DrawRectCmd.ID="DrawRect";
	return DrawRectCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/DrawTextureCmd.as=======199.999975/199.999975
/**
*...
*@author ww
*/
//class laya.display.cmd.DrawTextureCmd
var DrawTextureCmd=(function(){
	function DrawTextureCmd(){
		//this._texture=null;
		//this._x=NaN;
		//this._y=NaN;
		//this._width=NaN;
		//this._height=NaN;
		//this._matrix=null;
		//this._alpha=NaN;
		//this._color=null;
		//this._blendMode=null;
	}

	__class(DrawTextureCmd,'laya.display.cmd.DrawTextureCmd');
	var __proto=DrawTextureCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._texture=null;
		this._matrix=null;
		Pool.recover("DrawTextureCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.drawTextureWithTransform(this._texture,this._x,this._y,this._width,this._height,this._matrix,gx,gy,this._alpha,this._blendMode);
	}

	__getset(0,__proto,'cmdID',function(){
		return "DrawTexture";
	});

	__getset(0,__proto,'matrix',function(){
		return this._matrix;
		},function(value){
		this._matrix=value;
	});

	__getset(0,__proto,'texture',function(){
		return this._texture;
		},function(value){
		this._texture=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'width',function(){
		return this._width;
		},function(value){
		this._width=value;
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'height',function(){
		return this._height;
		},function(value){
		this._height=value;
	});

	__getset(0,__proto,'alpha',function(){
		return this._alpha;
		},function(value){
		this._alpha=value;
	});

	__getset(0,__proto,'color',function(){
		return this._color;
		},function(value){
		this._color=value;
	});

	__getset(0,__proto,'blendMode',function(){
		return this._blendMode;
		},function(value){
		this._blendMode=value;
	});

	DrawTextureCmd.create=function(texture,x,y,width,height,matrix,alpha,color,blendMode){
		var cmd=Pool.getItemByClass("DrawTextureCmd",DrawTextureCmd);
		cmd._texture=texture;
		cmd._x=x;
		cmd._y=y;
		cmd._width=width;
		cmd._height=height;
		cmd._matrix=matrix;
		cmd._alpha=alpha;
		cmd._color=color;
		cmd._blendMode=blendMode;
		return cmd;
	}

	DrawTextureCmd.ID="DrawTexture";
	return DrawTextureCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/DrawTexturesCmd.as=======199.999974/199.999974
/**
*...
*@author ww
*/
//class laya.display.cmd.DrawTexturesCmd
var DrawTexturesCmd=(function(){
	function DrawTexturesCmd(){
		//this._texture=null;
		//this._pos=null;
	}

	__class(DrawTexturesCmd,'laya.display.cmd.DrawTexturesCmd');
	var __proto=DrawTexturesCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._texture=null;
		this._pos=null;
		Pool.recover("DrawTexturesCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.drawTextures(this._texture,this._pos,gx,gy);
	}

	__getset(0,__proto,'cmdID',function(){
		return "DrawTextures";
	});

	__getset(0,__proto,'texture',function(){
		return this._texture;
		},function(value){
		this._texture=value;
	});

	__getset(0,__proto,'pos',function(){
		return this._pos;
		},function(value){
		this._pos=value;
	});

	DrawTexturesCmd.create=function(texture,pos){
		var cmd=Pool.getItemByClass("DrawTexturesCmd",DrawTexturesCmd);
		cmd._texture=texture;
		cmd._pos=pos;
		return cmd;
	}

	DrawTexturesCmd.ID="DrawTextures";
	return DrawTexturesCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/DrawTrianglesCmd.as=======199.999973/199.999973
/**
*...
*@author ww
*/
//class laya.display.cmd.DrawTrianglesCmd
var DrawTrianglesCmd=(function(){
	function DrawTrianglesCmd(){
		//this._texture=null;
		//this._x=NaN;
		//this._y=NaN;
		//this._vertices=null;
		//this._uvs=null;
		//this._indices=null;
		//this._matrix=null;
		//this._alpha=NaN;
		//this._color=null;
		//this._blendMode=null;
	}

	__class(DrawTrianglesCmd,'laya.display.cmd.DrawTrianglesCmd');
	var __proto=DrawTrianglesCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._texture=null;
		this._vertices=null;
		this._uvs=null;
		this._indices=null;
		this._matrix=null;
		Pool.recover("DrawTrianglesCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.drawTriangles(this._texture,this._x+gx,this._y+gy,this._vertices,this._uvs,this._indices,this._matrix,this._alpha,this._color,this._blendMode);
	}

	__getset(0,__proto,'vertices',function(){
		return this._vertices;
		},function(value){
		this._vertices=value;
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawTriangles";
	});

	__getset(0,__proto,'matrix',function(){
		return this._matrix;
		},function(value){
		this._matrix=value;
	});

	__getset(0,__proto,'texture',function(){
		return this._texture;
		},function(value){
		this._texture=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'alpha',function(){
		return this._alpha;
		},function(value){
		this._alpha=value;
	});

	__getset(0,__proto,'uvs',function(){
		return this._uvs;
		},function(value){
		this._uvs=value;
	});

	__getset(0,__proto,'indices',function(){
		return this._indices;
		},function(value){
		this._indices=value;
	});

	__getset(0,__proto,'color',function(){
		return this._color;
		},function(value){
		this._color=value;
	});

	__getset(0,__proto,'blendMode',function(){
		return this._blendMode;
		},function(value){
		this._blendMode=value;
	});

	DrawTrianglesCmd.create=function(texture,x,y,vertices,uvs,indices,matrix,alpha,color,blendMode){
		var cmd=Pool.getItemByClass("DrawTrianglesCmd",DrawTrianglesCmd);
		cmd._texture=texture;
		cmd._x=x;
		cmd._y=y;
		cmd._vertices=vertices;
		cmd._uvs=uvs;
		cmd._indices=indices;
		cmd._matrix=matrix;
		cmd._alpha=alpha;
		cmd._color=color;
		cmd._blendMode=blendMode;
		return cmd;
	}

	DrawTrianglesCmd.ID="DrawTriangles";
	return DrawTrianglesCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/FillBorderTextCmd.as=======199.999972/199.999972
/**
*...
*@author ww
*/
//class laya.display.cmd.FillBorderTextCmd
var FillBorderTextCmd=(function(){
	function FillBorderTextCmd(){
		//this._text=null;
		//this._x=NaN;
		//this._y=NaN;
		//this._font=null;
		//this._fillColor=null;
		//this._borderColor=null;
		//this._lineWidth=NaN;
		//this._textAlign=null;
	}

	__class(FillBorderTextCmd,'laya.display.cmd.FillBorderTextCmd');
	var __proto=FillBorderTextCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("FillBorderTextCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.fillBorderText(this._text,this._x+gx,this._y+gy,this._font,this._fillColor,this._borderColor,this._lineWidth,this._textAlign);
	}

	__getset(0,__proto,'cmdID',function(){
		return "FillBorderText";
	});

	__getset(0,__proto,'borderColor',function(){
		return this._borderColor;
		},function(value){
		this._borderColor=value;
	});

	__getset(0,__proto,'text',function(){
		return this._text;
		},function(value){
		this._text=value;
	});

	__getset(0,__proto,'fillColor',function(){
		return this._fillColor;
		},function(value){
		this._fillColor=value;
	});

	__getset(0,__proto,'textAlign',function(){
		return this._textAlign;
		},function(value){
		this._textAlign=value;
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'font',function(){
		return this._font;
		},function(value){
		this._font=value;
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		this._lineWidth=value;
	});

	FillBorderTextCmd.create=function(text,x,y,font,fillColor,borderColor,lineWidth,textAlign){
		var cmd=Pool.getItemByClass("FillBorderTextCmd",FillBorderTextCmd);
		cmd._text=text;
		cmd._x=x;
		cmd._y=y;
		cmd._font=font;
		cmd._fillColor=fillColor;
		cmd._borderColor=borderColor;
		cmd._lineWidth=lineWidth;
		cmd._textAlign=textAlign;
		return cmd;
	}

	FillBorderTextCmd.ID="FillBorderText";
	return FillBorderTextCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/FillBorderWordsCmd.as=======199.999971/199.999971
/**
*...
*@author ww
*/
//class laya.display.cmd.FillBorderWordsCmd
var FillBorderWordsCmd=(function(){
	function FillBorderWordsCmd(){
		//this._words=null;
		//this._x=NaN;
		//this._y=NaN;
		//this._font=null;
		//this._fillColor=null;
		//this._borderColor=null;
		//this._lineWidth=0;
	}

	__class(FillBorderWordsCmd,'laya.display.cmd.FillBorderWordsCmd');
	var __proto=FillBorderWordsCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._words=null;
		Pool.recover("FillBorderWordsCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.fillBorderWords(this._words,this._x+gx,this._y+gy,this._font,this._fillColor,this._borderColor,this._lineWidth);
	}

	__getset(0,__proto,'borderColor',function(){
		return this._borderColor;
		},function(value){
		this._borderColor=value;
	});

	__getset(0,__proto,'cmdID',function(){
		return "FillBorderWords";
	});

	__getset(0,__proto,'words',function(){
		return this._words;
		},function(value){
		this._words=value;
	});

	__getset(0,__proto,'fillColor',function(){
		return this._fillColor;
		},function(value){
		this._fillColor=value;
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'font',function(){
		return this._font;
		},function(value){
		this._font=value;
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		this._lineWidth=value;
	});

	FillBorderWordsCmd.create=function(words,x,y,font,fillColor,borderColor,lineWidth){
		var cmd=Pool.getItemByClass("FillBorderWordsCmd",FillBorderWordsCmd);
		cmd._words=words;
		cmd._x=x;
		cmd._y=y;
		cmd._font=font;
		cmd._fillColor=fillColor;
		cmd._borderColor=borderColor;
		cmd._lineWidth=lineWidth;
		return cmd;
	}

	FillBorderWordsCmd.ID="FillBorderWords";
	return FillBorderWordsCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/FillTextCmd.as=======199.999970/199.999970
/**
*...
*@author ww
*/
//class laya.display.cmd.FillTextCmd
var FillTextCmd=(function(){
	function FillTextCmd(){
		//this._text=null;
		//this._x=NaN;
		//this._y=NaN;
		//this._font=null;
		//this._color=null;
		//this._textAlign=null;
	}

	__class(FillTextCmd,'laya.display.cmd.FillTextCmd');
	var __proto=FillTextCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("FillTextCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.drawText(this._text,this._x+gx,this._y+gy,this._font,this._color,this._textAlign);
	}

	__getset(0,__proto,'text',function(){
		return this._text;
		},function(value){
		this._text=value;
	});

	__getset(0,__proto,'cmdID',function(){
		return "FillText";
	});

	__getset(0,__proto,'textAlign',function(){
		return this._textAlign;
		},function(value){
		this._textAlign=value;
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'color',function(){
		return this._color;
		},function(value){
		this._color=value;
	});

	__getset(0,__proto,'font',function(){
		return this._font;
		},function(value){
		this._font=value;
	});

	FillTextCmd.create=function(text,x,y,font,color,textAlign){
		var cmd=Pool.getItemByClass("FillTextCmd",FillTextCmd);
		cmd._text=text;
		cmd._x=x;
		cmd._y=y;
		cmd._font=font;
		cmd._color=color;
		cmd._textAlign=textAlign;
		return cmd;
	}

	FillTextCmd.ID="FillText";
	return FillTextCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/FillTextureCmd.as=======199.999969/199.999969
/**
*...
*@author ww
*/
//class laya.display.cmd.FillTextureCmd
var FillTextureCmd=(function(){
	function FillTextureCmd(){
		//this._texture=null;
		//this._x=NaN;
		//this._y=NaN;
		//this._width=NaN;
		//this._height=NaN;
		//this._type=null;
		//this._offset=null;
		//this._other=null;
	}

	__class(FillTextureCmd,'laya.display.cmd.FillTextureCmd');
	var __proto=FillTextureCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._texture=null;
		this._offset=null;
		this._other=null;
		Pool.recover("FillTextureCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.fillTexture(this._texture,this._x+gx,this._y+gy,this._width,this._height,this._type,this._offset,this._other);
	}

	__getset(0,__proto,'cmdID',function(){
		return "FillTexture";
	});

	__getset(0,__proto,'texture',function(){
		return this._texture;
		},function(value){
		this._texture=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'width',function(){
		return this._width;
		},function(value){
		this._width=value;
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'offset',function(){
		return this._offset;
		},function(value){
		this._offset=value;
	});

	__getset(0,__proto,'height',function(){
		return this._height;
		},function(value){
		this._height=value;
	});

	__getset(0,__proto,'other',function(){
		return this._other;
		},function(value){
		this._other=value;
	});

	__getset(0,__proto,'type',function(){
		return this._type;
		},function(value){
		this._type=value;
	});

	FillTextureCmd.create=function(texture,x,y,width,height,type,offset,other){
		var cmd=Pool.getItemByClass("FillTextureCmd",FillTextureCmd);
		cmd._texture=texture;
		cmd._x=x;
		cmd._y=y;
		cmd._width=width;
		cmd._height=height;
		cmd._type=type;
		cmd._offset=offset;
		cmd._other=other;
		return cmd;
	}

	FillTextureCmd.ID="FillTexture";
	return FillTextureCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/FillWordsCmd.as=======199.999968/199.999968
/**
*...
*@author ww
*/
//class laya.display.cmd.FillWordsCmd
var FillWordsCmd=(function(){
	function FillWordsCmd(){
		//this._words=null;
		//this._x=NaN;
		//this._y=NaN;
		//this._font=null;
		//this._color=null;
	}

	__class(FillWordsCmd,'laya.display.cmd.FillWordsCmd');
	var __proto=FillWordsCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._words=null;
		Pool.recover("FillWordsCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.fillWords(this._words,this._x+gx,this._y+gy,this._font,this._color);
	}

	__getset(0,__proto,'cmdID',function(){
		return "FillWords";
	});

	__getset(0,__proto,'words',function(){
		return this._words;
		},function(value){
		this._words=value;
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'color',function(){
		return this._color;
		},function(value){
		this._color=value;
	});

	__getset(0,__proto,'font',function(){
		return this._font;
		},function(value){
		this._font=value;
	});

	FillWordsCmd.create=function(words,x,y,font,color){
		var cmd=Pool.getItemByClass("FillWordsCmd",FillWordsCmd);
		cmd._words=words;
		cmd._x=x;
		cmd._y=y;
		cmd._font=font;
		cmd._color=color;
		return cmd;
	}

	FillWordsCmd.ID="FillWords";
	return FillWordsCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/RestoreCmd.as=======199.999967/199.999967
/**
*...
*@author ww
*/
//class laya.display.cmd.RestoreCmd
var RestoreCmd=(function(){
	function RestoreCmd(){}
	__class(RestoreCmd,'laya.display.cmd.RestoreCmd');
	var __proto=RestoreCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("RestoreCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.restore();
	}

	__getset(0,__proto,'cmdID',function(){
		return "Restore";
	});

	RestoreCmd.create=function(){
		var cmd=Pool.getItemByClass("RestoreCmd",RestoreCmd);
		return cmd;
	}

	RestoreCmd.ID="Restore";
	return RestoreCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/RotateCmd.as=======199.999966/199.999966
/**
*...
*@author ww
*/
//class laya.display.cmd.RotateCmd
var RotateCmd=(function(){
	function RotateCmd(){
		//this._angle=NaN;
		//this._pivotX=NaN;
		//this._pivotY=NaN;
	}

	__class(RotateCmd,'laya.display.cmd.RotateCmd');
	var __proto=RotateCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("RotateCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context._rotate(this._angle,this._pivotX+gx,this._pivotY+gy);
	}

	__getset(0,__proto,'cmdID',function(){
		return "Rotate";
	});

	__getset(0,__proto,'angle',function(){
		return this._angle;
		},function(value){
		this._angle=value;
	});

	__getset(0,__proto,'pivotX',function(){
		return this._pivotX;
		},function(value){
		this._pivotX=value;
	});

	__getset(0,__proto,'pivotY',function(){
		return this._pivotY;
		},function(value){
		this._pivotY=value;
	});

	RotateCmd.create=function(angle,pivotX,pivotY){
		var cmd=Pool.getItemByClass("RotateCmd",RotateCmd);
		cmd._angle=angle;
		cmd._pivotX=pivotX;
		cmd._pivotY=pivotY;
		return cmd;
	}

	RotateCmd.ID="Rotate";
	return RotateCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/SaveCmd.as=======199.999965/199.999965
/**
*...
*@author ww
*/
//class laya.display.cmd.SaveCmd
var SaveCmd=(function(){
	function SaveCmd(){}
	__class(SaveCmd,'laya.display.cmd.SaveCmd');
	var __proto=SaveCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("SaveCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.save();
	}

	__getset(0,__proto,'cmdID',function(){
		return "Save";
	});

	SaveCmd.create=function(){
		var cmd=Pool.getItemByClass("SaveCmd",SaveCmd);
		return cmd;
	}

	SaveCmd.ID="Save";
	return SaveCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/ScaleCmd.as=======199.999964/199.999964
/**
*...
*@author ww
*/
//class laya.display.cmd.ScaleCmd
var ScaleCmd=(function(){
	function ScaleCmd(){
		//this._scaleX=NaN;
		//this._scaleY=NaN;
		//this._pivotX=NaN;
		//this._pivotY=NaN;
	}

	__class(ScaleCmd,'laya.display.cmd.ScaleCmd');
	var __proto=ScaleCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("ScaleCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context._scale(this._scaleX,this._scaleY,this._pivotX+gx,this._pivotY+gy);
	}

	__getset(0,__proto,'cmdID',function(){
		return "Scale";
	});

	__getset(0,__proto,'scaleX',function(){
		return this._scaleX;
		},function(value){
		this._scaleX=value;
	});

	__getset(0,__proto,'scaleY',function(){
		return this._scaleY;
		},function(value){
		this._scaleY=value;
	});

	__getset(0,__proto,'pivotX',function(){
		return this._pivotX;
		},function(value){
		this._pivotX=value;
	});

	__getset(0,__proto,'pivotY',function(){
		return this._pivotY;
		},function(value){
		this._pivotY=value;
	});

	ScaleCmd.create=function(scaleX,scaleY,pivotX,pivotY){
		var cmd=Pool.getItemByClass("ScaleCmd",ScaleCmd);
		cmd._scaleX=scaleX;
		cmd._scaleY=scaleY;
		cmd._pivotX=pivotX;
		cmd._pivotY=pivotY;
		return cmd;
	}

	ScaleCmd.ID="Scale";
	return ScaleCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/StrokeTextCmd.as=======199.999963/199.999963
/**
*...
*@author ww
*/
//class laya.display.cmd.StrokeTextCmd
var StrokeTextCmd=(function(){
	function StrokeTextCmd(){
		//this._text=null;
		//this._x=NaN;
		//this._y=NaN;
		//this._font=null;
		//this._color=null;
		//this._lineWidth=NaN;
		//this._textAlign=null;
	}

	__class(StrokeTextCmd,'laya.display.cmd.StrokeTextCmd');
	var __proto=StrokeTextCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("StrokeTextCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.strokeWord(this._text,this._x+gx,this._y+gy,this._font,this._color,this._lineWidth,this._textAlign);
	}

	__getset(0,__proto,'text',function(){
		return this._text;
		},function(value){
		this._text=value;
	});

	__getset(0,__proto,'cmdID',function(){
		return "StrokeText";
	});

	__getset(0,__proto,'textAlign',function(){
		return this._textAlign;
		},function(value){
		this._textAlign=value;
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		this._x=value;
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		this._y=value;
	});

	__getset(0,__proto,'color',function(){
		return this._color;
		},function(value){
		this._color=value;
	});

	__getset(0,__proto,'font',function(){
		return this._font;
		},function(value){
		this._font=value;
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._lineWidth;
		},function(value){
		this._lineWidth=value;
	});

	StrokeTextCmd.create=function(text,x,y,font,color,lineWidth,textAlign){
		var cmd=Pool.getItemByClass("StrokeTextCmd",StrokeTextCmd);
		cmd._text=text;
		cmd._x=x;
		cmd._y=y;
		cmd._font=font;
		cmd._color=color;
		cmd._lineWidth=lineWidth;
		cmd._textAlign=textAlign;
		return cmd;
	}

	StrokeTextCmd.ID="StrokeText";
	return StrokeTextCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/TransformCmd.as=======199.999962/199.999962
/**
*...
*@author ww
*/
//class laya.display.cmd.TransformCmd
var TransformCmd=(function(){
	function TransformCmd(){
		//this._matrix=null;
		//this._pivotX=NaN;
		//this._pivotY=NaN;
	}

	__class(TransformCmd,'laya.display.cmd.TransformCmd');
	var __proto=TransformCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._matrix=null;
		Pool.recover("TransformCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context._transform(this._matrix,this._pivotX+gx,this._pivotY+gy);
	}

	__getset(0,__proto,'cmdID',function(){
		return "Transform";
	});

	__getset(0,__proto,'matrix',function(){
		return this._matrix;
		},function(value){
		this._matrix=value;
	});

	__getset(0,__proto,'pivotX',function(){
		return this._pivotX;
		},function(value){
		this._pivotX=value;
	});

	__getset(0,__proto,'pivotY',function(){
		return this._pivotY;
		},function(value){
		this._pivotY=value;
	});

	TransformCmd.create=function(matrix,pivotX,pivotY){
		var cmd=Pool.getItemByClass("TransformCmd",TransformCmd);
		cmd._matrix=matrix;
		cmd._pivotX=pivotX;
		cmd._pivotY=pivotY;
		return cmd;
	}

	TransformCmd.ID="Transform";
	return TransformCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmd/TranslateCmd.as=======199.999961/199.999961
/**
*...
*@author ww
*/
//class laya.display.cmd.TranslateCmd
var TranslateCmd=(function(){
	function TranslateCmd(){
		//this._tx=NaN;
		//this._ty=NaN;
	}

	__class(TranslateCmd,'laya.display.cmd.TranslateCmd');
	var __proto=TranslateCmd.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		Pool.recover("TranslateCmd",this);
	}

	/**@private */
	__proto.run=function(context,gx,gy){
		context.translate(this._tx,this._ty);
	}

	__getset(0,__proto,'ty',function(){
		return this._ty;
		},function(value){
		this._ty=value;
	});

	__getset(0,__proto,'cmdID',function(){
		return "Translate";
	});

	__getset(0,__proto,'tx',function(){
		return this._tx;
		},function(value){
		this._tx=value;
	});

	TranslateCmd.create=function(tx,ty){
		var cmd=Pool.getItemByClass("TranslateCmd",TranslateCmd);
		cmd._tx=tx;
		cmd._ty=ty;
		return cmd;
	}

	TranslateCmd.ID="Translate";
	return TranslateCmd;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/AlphaCmdNative.as=======199.999960/199.999960
/**
*...
*@author ww
*/
//class laya.display.cmdNative.AlphaCmdNative
var AlphaCmdNative=(function(){
	function AlphaCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(AlphaCmdNative,'laya.display.cmdNative.AlphaCmdNative');
	var __proto=AlphaCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("AlphaCmdNative",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "Alpha";
	});

	__getset(0,__proto,'alpha',function(){
		return this._buffer.get_f(this._index+1);
		},function(value){
		this._buffer.set_f(this._index+1,value);
	});

	AlphaCmdNative.create=function(alpha){
		var cmd=Pool.getItemByClass("AlphaCmdNative",AlphaCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.ALPHA.id);
		bf.add_f(alpha);
		return cmd;
	}

	AlphaCmdNative.ID="Alpha";
	return AlphaCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/ClipRectCmdNative.as=======199.999959/199.999959
/**
*...
*@author ww
*/
//class laya.display.cmdNative.ClipRectCmdNative
var ClipRectCmdNative=(function(){
	function ClipRectCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(ClipRectCmdNative,'laya.display.cmdNative.ClipRectCmdNative');
	var __proto=ClipRectCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("ClipRectCmdNative",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "ClipRect";
	});

	__getset(0,__proto,'width',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+1);
		},function(value){
		this._buffer.set_f(this._index+1,value);
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'height',function(){
		return this._buffer.get_f(this._index+4);
		},function(value){
		this._buffer.set_f(this._index+4,value);
	});

	ClipRectCmdNative.create=function(x,y,width,height){
		var cmd=Pool.getItemByClass("ClipRectCmdNative",ClipRectCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.CLIP_RECT.id);
		bf.add_f(x);
		bf.add_f(y);
		bf.add_f(width);
		bf.add_f(height);
		return cmd;
	}

	ClipRectCmdNative.ID="ClipRect";
	return ClipRectCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/DrawCircleCmdNative.as=======199.999958/199.999958
/**
*...
*@author ww
*/
//class laya.display.cmdNative.DrawCircleCmdNative
var DrawCircleCmdNative=(function(){
	function DrawCircleCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(DrawCircleCmdNative,'laya.display.cmdNative.DrawCircleCmdNative');
	var __proto=DrawCircleCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("DrawCircleCmdNative",this);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._buffer.get_Color(this._index+5);
		},function(value){
		this._buffer.set_Color(this._index+5,value);
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawCircle";
	});

	__getset(0,__proto,'fillColor',function(){
		return this._buffer.get_Color(this._index+4);
		},function(value){
		this._buffer.set_Color(this._index+4,value);
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+1);
		},function(value){
		this._buffer.set_f(this._index+1,value);
	});

	__getset(0,__proto,'vid',function(){
		return this._buffer.get_i(this._index+7);
		},function(value){
		this._buffer.set_i(this._index+7,value);
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'radius',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._buffer.get_f(this._index+6);
		},function(value){
		this._buffer.set_f(this._index+6,value);
	});

	DrawCircleCmdNative.create=function(x,y,radius,fillColor,lineColor,lineWidth,vid){
		var cmd=Pool.getItemByClass("DrawCircleCmdNative",DrawCircleCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.DRAW_CIRCLE.id);
		bf.add_f(x);
		bf.add_f(y);
		bf.add_f(radius);
		bf.add_FillLineColorWithNative(fillColor,lineColor);
		bf.add_f(lineWidth);
		bf.add_i(vid);
		return cmd;
	}

	DrawCircleCmdNative.ID="DrawCircle";
	return DrawCircleCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/DrawCurvesCmdNative.as=======199.999957/199.999957
/**
*...
*@author ww
*/
//class laya.display.cmdNative.DrawCurvesCmdNative
var DrawCurvesCmdNative=(function(){
	function DrawCurvesCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(DrawCurvesCmdNative,'laya.display.cmdNative.DrawCurvesCmdNative');
	var __proto=DrawCurvesCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("DrawCurvesCmdNative",this);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._buffer.get_Color(this._index+4);
		},function(value){
		this._buffer.set_Color(this._index+4,value);
	});

	__getset(0,__proto,'points',function(){
		return this._buffer.get_FloatArray(this._index+3);
		},function(value){
		this._buffer.set_FloatArray(this._index+3,value);
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawCurves";
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+1);
		},function(value){
		this._buffer.set_f(this._index+1,value);
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._buffer.get_f(this._index+5);
		},function(value){
		this._buffer.set_f(this._index+5,value);
	});

	DrawCurvesCmdNative.create=function(x,y,points,lineColor,lineWidth){
		var cmd=Pool.getItemByClass("DrawCurvesCmdNative",DrawCurvesCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.DRAW_CURVES.id);
		bf.add_f(x);
		bf.add_f(y);
		bf.add_FloatArray(points);
		bf.add_Color(lineColor);
		bf.add_f(lineWidth);
		return cmd;
	}

	DrawCurvesCmdNative.ID="DrawCurves";
	return DrawCurvesCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/DrawImageCmdNative.as=======199.999956/199.999956
/**
*...
*@author ww
*/
//class laya.display.cmdNative.DrawImageCmdNative
var DrawImageCmdNative=(function(){
	function DrawImageCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(DrawImageCmdNative,'laya.display.cmdNative.DrawImageCmdNative');
	var __proto=DrawImageCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("DrawImageCmdNative",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "DrawImage";
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	__getset(0,__proto,'texture',function(){
		return this._buffer.get_TextureOne(this._index+1);
		},function(value){
		this._buffer.set_TextureOne(this._index+1,value);
	});

	__getset(0,__proto,'width',function(){
		return this._buffer.get_f(this._index+4);
		},function(value){
		this._buffer.set_f(this._index+4,value);
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'height',function(){
		return this._buffer.get_f(this._index+5);
		},function(value){
		this._buffer.set_f(this._index+5,value);
	});

	DrawImageCmdNative.create=function(texture,x,y,width,height){
		var cmd=Pool.getItemByClass("DrawImageCmdNative",DrawImageCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.DRAW_IMAGE.id);
		bf.add_TextureOne(texture);
		bf.add_f(x);
		bf.add_f(y);
		bf.add_f(width);
		bf.add_f(height);
		return cmd;
	}

	DrawImageCmdNative.ID="DrawImage";
	return DrawImageCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/DrawLineCmdNative.as=======199.999955/199.999955
/**
*...
*@author ww
*/
//class laya.display.cmdNative.DrawLineCmdNative
var DrawLineCmdNative=(function(){
	function DrawLineCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(DrawLineCmdNative,'laya.display.cmdNative.DrawLineCmdNative');
	var __proto=DrawLineCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("DrawLineCmdNative",this);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._buffer.get_Color(this._index+5);
		},function(value){
		this._buffer.set_Color(this._index+5,value);
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawLine";
	});

	__getset(0,__proto,'toY',function(){
		return this._buffer.get_f(this._index+4);
		},function(value){
		this._buffer.set_f(this._index+4,value);
	});

	__getset(0,__proto,'fromX',function(){
		return this._buffer.get_f(this._index+1);
		},function(value){
		this._buffer.set_f(this._index+1,value);
	});

	__getset(0,__proto,'vid',function(){
		return this._buffer.get_i(this._index+7);
		},function(value){
		this._buffer.set_i(this._index+7,value);
	});

	__getset(0,__proto,'toX',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	__getset(0,__proto,'fromY',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._buffer.get_f(this._index+6);
		},function(value){
		this._buffer.set_f(this._index+6,value);
	});

	DrawLineCmdNative.create=function(fromX,fromY,toX,toY,lineColor,lineWidth,vid){
		var cmd=Pool.getItemByClass("DrawLineCmdNative",DrawLineCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.DRAW_LINE.id);
		bf.add_f(fromX);
		bf.add_f(fromY);
		bf.add_f(toX);
		bf.add_f(toY);
		bf.add_Color(lineColor);
		bf.add_f(lineWidth);
		bf.add_i(vid);
		return cmd;
	}

	DrawLineCmdNative.ID="DrawLine";
	return DrawLineCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/DrawLinesCmdNative.as=======199.999954/199.999954
/**
*...
*@author ww
*/
//class laya.display.cmdNative.DrawLinesCmdNative
var DrawLinesCmdNative=(function(){
	function DrawLinesCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(DrawLinesCmdNative,'laya.display.cmdNative.DrawLinesCmdNative');
	var __proto=DrawLinesCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("DrawLinesCmdNative",this);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._buffer.get_Color(this._index+4);
		},function(value){
		this._buffer.set_Color(this._index+4,value);
	});

	__getset(0,__proto,'points',function(){
		return this._buffer.get_FloatArray(this._index+3);
		},function(value){
		this._buffer.set_FloatArray(this._index+3,value);
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawLines";
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+1);
		},function(value){
		this._buffer.set_f(this._index+1,value);
	});

	__getset(0,__proto,'vid',function(){
		return this._buffer.get_i(this._index+6);
		},function(value){
		this._buffer.set_i(this._index+6,value);
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._buffer.get_f(this._index+5);
		},function(value){
		this._buffer.set_f(this._index+5,value);
	});

	DrawLinesCmdNative.create=function(x,y,points,lineColor,lineWidth,vid){
		var cmd=Pool.getItemByClass("DrawLinesCmdNative",DrawLinesCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.DRAW_LINES.id);
		bf.add_f(x);
		bf.add_f(y);
		bf.add_FloatArray(points);
		bf.add_Color(lineColor);
		bf.add_f(lineWidth);
		bf.add_i(vid);
		return cmd;
	}

	DrawLinesCmdNative.ID="DrawLines";
	return DrawLinesCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/DrawPathCmdNative.as=======199.999953/199.999953
/**
*...
*@author ww
*/
//class laya.display.cmdNative.DrawPathCmdNative
var DrawPathCmdNative=(function(){
	function DrawPathCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(DrawPathCmdNative,'laya.display.cmdNative.DrawPathCmdNative');
	var __proto=DrawPathCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("DrawPathCmdNative",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "DrawPath";
	});

	__getset(0,__proto,'paths',function(){
		return this._buffer.get_FloatArray(this._index+3);
		},function(value){
		this._buffer.set_FloatArray(this._index+3,value);
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+1);
		},function(value){
		this._buffer.set_f(this._index+1,value);
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'brush',function(){
		return this._buffer.get_object(this._index+4);
		},function(value){
		this._buffer.set_object(this._index+4,value);
	});

	__getset(0,__proto,'pen',function(){
		return this._buffer.get_object(this._index+5);
		},function(value){
		this._buffer.set_object(this._index+5,value);
	});

	DrawPathCmdNative.create=function(x,y,paths,brush,pen){
		var cmd=Pool.getItemByClass("DrawPathCmdNative",DrawPathCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.DRAW_PATH.id);
		bf.add_f(x);
		bf.add_f(y);
		bf.add_FloatArray(paths);
		bf.add_object(brush);
		bf.add_object(pen);
		return cmd;
	}

	DrawPathCmdNative.ID="DrawPath";
	return DrawPathCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/DrawPieCmdNative.as=======199.999952/199.999952
/**
*...
*@author ww
*/
//class laya.display.cmdNative.DrawPieCmdNative
var DrawPieCmdNative=(function(){
	function DrawPieCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(DrawPieCmdNative,'laya.display.cmdNative.DrawPieCmdNative');
	var __proto=DrawPieCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("DrawPieCmdNative",this);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._buffer.get_Color(this._index+7);
		},function(value){
		this._buffer.set_Color(this._index+7,value);
	});

	__getset(0,__proto,'startAngle',function(){
		return this._buffer.get_f(this._index+4);
		},function(value){
		this._buffer.set_f(this._index+4,value);
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawPie";
	});

	__getset(0,__proto,'fillColor',function(){
		return this._buffer.get_Color(this._index+6);
		},function(value){
		this._buffer.set_Color(this._index+6,value);
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+1);
		},function(value){
		this._buffer.set_f(this._index+1,value);
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'radius',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	__getset(0,__proto,'endAngle',function(){
		return this._buffer.get_f(this._index+5);
		},function(value){
		this._buffer.set_f(this._index+5,value);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._buffer.get_f(this._index+8);
		},function(value){
		this._buffer.set_f(this._index+8,value);
	});

	__getset(0,__proto,'vid',function(){
		return this._buffer.get_i(this._index+9);
		},function(value){
		this._buffer.set_i(this._index+9,value);
	});

	DrawPieCmdNative.create=function(x,y,radius,startAngle,endAngle,fillColor,lineColor,lineWidth,vid){
		var cmd=Pool.getItemByClass("DrawPieCmdNative",DrawPieCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.DRAW_PIE.id);
		bf.add_f(x);
		bf.add_f(y);
		bf.add_f(radius);
		bf.add_f(startAngle);
		bf.add_f(endAngle);
		bf.add_FillLineColorWithNative(fillColor,lineColor);
		bf.add_f(lineWidth);
		bf.add_i(vid);
		return cmd;
	}

	DrawPieCmdNative.ID="DrawPie";
	return DrawPieCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/DrawPolyCmdNative.as=======199.999951/199.999951
/**
*...
*@author ww
*/
//class laya.display.cmdNative.DrawPolyCmdNative
var DrawPolyCmdNative=(function(){
	function DrawPolyCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(DrawPolyCmdNative,'laya.display.cmdNative.DrawPolyCmdNative');
	var __proto=DrawPolyCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("DrawPolyCmdNative",this);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._buffer.get_Color(this._index+5);
		},function(value){
		this._buffer.set_Color(this._index+5,value);
	});

	__getset(0,__proto,'points',function(){
		return this._buffer.get_FloatArray(this._index+3);
		},function(value){
		this._buffer.set_FloatArray(this._index+3,value);
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawPoly";
	});

	__getset(0,__proto,'fillColor',function(){
		return this._buffer.get_Color(this._index+4);
		},function(value){
		this._buffer.set_Color(this._index+4,value);
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+1);
		},function(value){
		this._buffer.set_f(this._index+1,value);
	});

	__getset(0,__proto,'isConvexPolygon',function(){
		return this._buffer.get_Boolean(this._index+7);
		},function(value){
		this._buffer.set_Boolean(this._index+7,value);
	});

	__getset(0,__proto,'vid',function(){
		return this._buffer.get_i(this._index+8);
		},function(value){
		this._buffer.set_i(this._index+8,value);
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._buffer.get_f(this._index+6);
		},function(value){
		this._buffer.set_f(this._index+6,value);
	});

	DrawPolyCmdNative.create=function(x,y,points,fillColor,lineColor,lineWidth,isConvexPolygon,vid){
		var cmd=Pool.getItemByClass("DrawPolyCmdNative",DrawPolyCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.DRAW_POLY.id);
		bf.add_f(x);
		bf.add_f(y);
		bf.add_FloatArray(points);
		bf.add_FillLineColorWithNative(fillColor,lineColor);
		bf.add_f(lineWidth);
		bf.add_Boolean(isConvexPolygon);
		bf.add_i(vid);
		return cmd;
	}

	DrawPolyCmdNative.ID="DrawPoly";
	return DrawPolyCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/DrawRectCmdNative.as=======199.999950/199.999950
/**
*...
*@author ww
*/
//class laya.display.cmdNative.DrawRectCmdNative
var DrawRectCmdNative=(function(){
	function DrawRectCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(DrawRectCmdNative,'laya.display.cmdNative.DrawRectCmdNative');
	var __proto=DrawRectCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("DrawRectCmdNative",this);
	}

	__getset(0,__proto,'lineColor',function(){
		return this._buffer.get_Color(this._index+6);
		},function(value){
		this._buffer.set_Color(this._index+6,value);
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawRect";
	});

	__getset(0,__proto,'fillColor',function(){
		return this._buffer.get_Color(this._index+5);
		},function(value){
		this._buffer.set_Color(this._index+5,value);
	});

	__getset(0,__proto,'width',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+1);
		},function(value){
		this._buffer.set_f(this._index+1,value);
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'height',function(){
		return this._buffer.get_f(this._index+4);
		},function(value){
		this._buffer.set_f(this._index+4,value);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._buffer.get_f(this._index+7);
		},function(value){
		this._buffer.set_f(this._index+7,value);
	});

	DrawRectCmdNative.create=function(x,y,width,height,fillColor,lineColor,lineWidth){
		var cmd=Pool.getItemByClass("DrawRectCmdNative",DrawRectCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.FILL_RECT.id);
		bf.add_f(x);
		bf.add_f(y);
		bf.add_f(width);
		bf.add_f(height);
		bf.add_FillLineColorWithNative(fillColor,lineColor);
		bf.add_f(lineWidth);
		return cmd;
	}

	DrawRectCmdNative.ID="DrawRect";
	return DrawRectCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/DrawTextureCmdNative.as=======199.999948/199.999948
/**
*...
*@author ww
*/
//class laya.display.cmdNative.DrawTextureCmdNative
var DrawTextureCmdNative=(function(){
	function DrawTextureCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(DrawTextureCmdNative,'laya.display.cmdNative.DrawTextureCmdNative');
	var __proto=DrawTextureCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("DrawTextureCmdNative",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "DrawTexture";
	});

	__getset(0,__proto,'matrix',function(){
		return this._buffer.get_matrix(this._index+6);
		},function(value){
		this._buffer.set_matrix(this._index+6,value);
	});

	__getset(0,__proto,'texture',function(){
		return this._buffer.get_TextureOne(this._index+1);
		},function(value){
		this._buffer.set_TextureOne(this._index+1,value);
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	__getset(0,__proto,'width',function(){
		return this._buffer.get_f(this._index+4);
		},function(value){
		this._buffer.set_f(this._index+4,value);
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'height',function(){
		return this._buffer.get_f(this._index+5);
		},function(value){
		this._buffer.set_f(this._index+5,value);
	});

	__getset(0,__proto,'alpha',function(){
		return this._buffer.get_f(this._index+7);
		},function(value){
		this._buffer.set_f(this._index+7,value);
	});

	__getset(0,__proto,'color',function(){
		return this._buffer.get_Color(this._index+8);
		},function(value){
		this._buffer.set_Color(this._index+8,value);
	});

	__getset(0,__proto,'blendMode',function(){
		return this._buffer.get_String(this._index+9);
		},function(value){
		this._buffer.set_String(this._index+9,value);
	});

	DrawTextureCmdNative.create=function(texture,x,y,width,height,matrix,alpha,color,blendMode){
		var cmd=Pool.getItemByClass("DrawTextureCmdNative",DrawTextureCmdNative);
		cmd._buffer=this._buffer;;
		cmd._index=cmd._buffer.add_texture(LayaGL.DRAW_TEXTURE.id,texture,x,y,width,height);
		return cmd;
	}

	DrawTextureCmdNative.ID="DrawTexture";
	return DrawTextureCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/DrawTexturesCmdNative.as=======199.999947/199.999947
/**
*...
*@author ww
*/
//class laya.display.cmdNative.DrawTexturesCmdNative
var DrawTexturesCmdNative=(function(){
	function DrawTexturesCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(DrawTexturesCmdNative,'laya.display.cmdNative.DrawTexturesCmdNative');
	var __proto=DrawTexturesCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("DrawTexturesCmdNative",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "DrawTextures";
	});

	__getset(0,__proto,'texture',function(){
		return this._buffer.get_TextureOne(this._index+1);
		},function(value){
		this._buffer.set_TextureOne(this._index+1,value);
	});

	__getset(0,__proto,'pos',function(){
		return this._buffer.get_FloatArray(this._index+2);
		},function(value){
		this._buffer.set_FloatArray(this._index+2,value);
	});

	DrawTexturesCmdNative.create=function(texture,pos){
		var cmd=Pool.getItemByClass("DrawTexturesCmdNative",DrawTexturesCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.DRAW_TEXTURES.id);
		bf.add_TextureOne(texture);
		bf.add_FloatArray(pos);
		return cmd;
	}

	DrawTexturesCmdNative.ID="DrawTextures";
	return DrawTexturesCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/DrawTrianglesCmdNative.as=======199.999946/199.999946
/**
*...
*@author ww
*/
//class laya.display.cmdNative.DrawTrianglesCmdNative
var DrawTrianglesCmdNative=(function(){
	function DrawTrianglesCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(DrawTrianglesCmdNative,'laya.display.cmdNative.DrawTrianglesCmdNative');
	var __proto=DrawTrianglesCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("DrawTrianglesCmdNative",this);
	}

	__getset(0,__proto,'vertices',function(){
		return this._buffer.get_object(this._index+4);
		},function(value){
		this._buffer.set_object(this._index+4,value);
	});

	__getset(0,__proto,'cmdID',function(){
		return "DrawTriangles";
	});

	__getset(0,__proto,'matrix',function(){
		return this._buffer.get_matrix(this._index+7);
		},function(value){
		this._buffer.set_matrix(this._index+7,value);
	});

	__getset(0,__proto,'texture',function(){
		return this._buffer.get_TextureOne(this._index+1);
		},function(value){
		this._buffer.set_TextureOne(this._index+1,value);
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'alpha',function(){
		return this._buffer.get_f(this._index+8);
		},function(value){
		this._buffer.set_f(this._index+8,value);
	});

	__getset(0,__proto,'uvs',function(){
		return this._buffer.get_object(this._index+5);
		},function(value){
		this._buffer.set_object(this._index+5,value);
	});

	__getset(0,__proto,'indices',function(){
		return this._buffer.get_object(this._index+6);
		},function(value){
		this._buffer.set_object(this._index+6,value);
	});

	__getset(0,__proto,'color',function(){
		return this._buffer.get_Color(this._index+9);
		},function(value){
		this._buffer.set_Color(this._index+9,value);
	});

	__getset(0,__proto,'blendMode',function(){
		return this._buffer.get_String(this._index+10);
		},function(value){
		this._buffer.set_String(this._index+10,value);
	});

	DrawTrianglesCmdNative.create=function(texture,x,y,vertices,uvs,indices,matrix,alpha,color,blendMode){
		var cmd=Pool.getItemByClass("DrawTrianglesCmdNative",DrawTrianglesCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.DRAW_TRIANGLES.id);
		bf.add_TextureOne(texture);
		bf.add_f(x);
		bf.add_f(y);
		bf.add_object(vertices);
		bf.add_object(uvs);
		bf.add_object(indices);
		bf.add_matrix(matrix);
		bf.add_f(alpha);
		bf.add_Color(color);
		bf.add_String(blendMode);
		return cmd;
	}

	DrawTrianglesCmdNative.ID="DrawTriangles";
	return DrawTrianglesCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/FillBorderTextCmdNative.as=======199.999945/199.999945
/**
*...
*@author ww
*/
//class laya.display.cmdNative.FillBorderTextCmdNative
var FillBorderTextCmdNative=(function(){
	function FillBorderTextCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(FillBorderTextCmdNative,'laya.display.cmdNative.FillBorderTextCmdNative');
	var __proto=FillBorderTextCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("FillBorderTextCmdNative",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "FillBorderText";
	});

	__getset(0,__proto,'borderColor',function(){
		return this._buffer.get_Color(this._index+6);
		},function(value){
		this._buffer.set_Color(this._index+6,value);
	});

	__getset(0,__proto,'text',function(){
		return this._buffer.get_String(this._index+1);
		},function(value){
		this._buffer.set_String(this._index+1,value);
	});

	__getset(0,__proto,'fillColor',function(){
		return this._buffer.get_Color(this._index+5);
		},function(value){
		this._buffer.set_Color(this._index+5,value);
	});

	__getset(0,__proto,'textAlign',function(){
		return this._buffer.get_String(this._index+8);
		},function(value){
		this._buffer.set_String(this._index+8,value);
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	__getset(0,__proto,'font',function(){
		return this._buffer.get_String(this._index+4);
		},function(value){
		this._buffer.set_String(this._index+4,value);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._buffer.get_f(this._index+7);
		},function(value){
		this._buffer.set_f(this._index+7,value);
	});

	FillBorderTextCmdNative.create=function(text,x,y,font,fillColor,borderColor,lineWidth,textAlign){
		var cmd=Pool.getItemByClass("FillBorderTextCmdNative",FillBorderTextCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.FILL_BORDER_TEXT.id);
		bf.add_String(text);
		bf.add_f(x);
		bf.add_f(y);
		bf.add_String(font);
		bf.add_Color(fillColor);
		bf.add_Color(borderColor);
		bf.add_f(lineWidth);
		bf.add_String(textAlign);
		return cmd;
	}

	FillBorderTextCmdNative.ID="FillBorderText";
	return FillBorderTextCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/FillBorderWordsCmdNative.as=======199.999944/199.999944
/**
*...
*@author ww
*/
//class laya.display.cmdNative.FillBorderWordsCmdNative
var FillBorderWordsCmdNative=(function(){
	function FillBorderWordsCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(FillBorderWordsCmdNative,'laya.display.cmdNative.FillBorderWordsCmdNative');
	var __proto=FillBorderWordsCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("FillBorderWordsCmdNative",this);
	}

	__getset(0,__proto,'borderColor',function(){
		return this._buffer.get_Color(this._index+6);
		},function(value){
		this._buffer.set_Color(this._index+6,value);
	});

	__getset(0,__proto,'cmdID',function(){
		return "FillBorderWords";
	});

	__getset(0,__proto,'words',function(){
		return this._buffer.get_FloatArray(this._index+1);
		},function(value){
		this._buffer.set_FloatArray(this._index+1,value);
	});

	__getset(0,__proto,'fillColor',function(){
		return this._buffer.get_Color(this._index+5);
		},function(value){
		this._buffer.set_Color(this._index+5,value);
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	__getset(0,__proto,'font',function(){
		return this._buffer.get_String(this._index+4);
		},function(value){
		this._buffer.set_String(this._index+4,value);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._buffer.get_i(this._index+7);
		},function(value){
		this._buffer.set_i(this._index+7,value);
	});

	FillBorderWordsCmdNative.create=function(words,x,y,font,fillColor,borderColor,lineWidth){
		var cmd=Pool.getItemByClass("FillBorderWordsCmdNative",FillBorderWordsCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.FILL_BORDER_WORDS.id);
		bf.add_FloatArray(words);
		bf.add_f(x);
		bf.add_f(y);
		bf.add_String(font);
		bf.add_Color(fillColor);
		bf.add_Color(borderColor);
		bf.add_i(lineWidth);
		return cmd;
	}

	FillBorderWordsCmdNative.ID="FillBorderWords";
	return FillBorderWordsCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/FillTextCmdNative.as=======199.999943/199.999943
/**
*...
*@author ww
*/
//class laya.display.cmdNative.FillTextCmdNative
var FillTextCmdNative=(function(){
	function FillTextCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(FillTextCmdNative,'laya.display.cmdNative.FillTextCmdNative');
	var __proto=FillTextCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("FillTextCmdNative",this);
	}

	__getset(0,__proto,'text',function(){
		return this._buffer.get_String(this._index+1);
		},function(value){
		this._buffer.set_String(this._index+1,value);
	});

	__getset(0,__proto,'cmdID',function(){
		return "FillText";
	});

	__getset(0,__proto,'textAlign',function(){
		return this._buffer.get_String(this._index+6);
		},function(value){
		this._buffer.set_String(this._index+6,value);
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	__getset(0,__proto,'color',function(){
		return this._buffer.get_Color(this._index+5);
		},function(value){
		this._buffer.set_Color(this._index+5,value);
	});

	__getset(0,__proto,'font',function(){
		return this._buffer.get_String(this._index+4);
		},function(value){
		this._buffer.set_String(this._index+4,value);
	});

	FillTextCmdNative.create=function(text,x,y,font,color,textAlign){
		var cmd=Pool.getItemByClass("FillTextCmdNative",FillTextCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.FILL_TEXT.id);
		bf.add_String(text);
		bf.add_f(x);
		bf.add_f(y);
		bf.add_String(font);
		bf.add_Color(color);
		bf.add_String(textAlign);
		return cmd;
	}

	FillTextCmdNative.ID="FillText";
	return FillTextCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/FillTextureCmdNative.as=======199.999942/199.999942
/**
*...
*@author ww
*/
//class laya.display.cmdNative.FillTextureCmdNative
var FillTextureCmdNative=(function(){
	function FillTextureCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(FillTextureCmdNative,'laya.display.cmdNative.FillTextureCmdNative');
	var __proto=FillTextureCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("FillTextureCmdNative",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "FillTexture";
	});

	__getset(0,__proto,'texture',function(){
		return this._buffer.get_TextureOne(this._index+1);
		},function(value){
		this._buffer.set_TextureOne(this._index+1,value);
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	__getset(0,__proto,'width',function(){
		return this._buffer.get_f(this._index+4);
		},function(value){
		this._buffer.set_f(this._index+4,value);
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'offset',function(){
		return this._buffer.get_point(this._index+7);
		},function(value){
		this._buffer.set_point(this._index+7,value);
	});

	__getset(0,__proto,'height',function(){
		return this._buffer.get_f(this._index+5);
		},function(value){
		this._buffer.set_f(this._index+5,value);
	});

	__getset(0,__proto,'other',function(){
		return this._buffer.get_object(this._index+8);
		},function(value){
		this._buffer.set_object(this._index+8,value);
	});

	__getset(0,__proto,'type',function(){
		return this._buffer.get_String(this._index+6);
		},function(value){
		this._buffer.set_String(this._index+6,value);
	});

	FillTextureCmdNative.create=function(texture,x,y,width,height,type,offset,other){
		var cmd=Pool.getItemByClass("FillTextureCmdNative",FillTextureCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.FILL_TEXTURE.id);
		bf.add_TextureOne(texture);
		bf.add_f(x);
		bf.add_f(y);
		bf.add_f(width);
		bf.add_f(height);
		bf.add_String(type);
		bf.add_point(offset);
		bf.add_object(other);
		return cmd;
	}

	FillTextureCmdNative.ID="FillTexture";
	return FillTextureCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/FillWordsCmdNative.as=======199.999941/199.999941
/**
*...
*@author ww
*/
//class laya.display.cmdNative.FillWordsCmdNative
var FillWordsCmdNative=(function(){
	function FillWordsCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(FillWordsCmdNative,'laya.display.cmdNative.FillWordsCmdNative');
	var __proto=FillWordsCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("FillWordsCmdNative",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "FillWords";
	});

	__getset(0,__proto,'words',function(){
		return this._buffer.get_FloatArray(this._index+1);
		},function(value){
		this._buffer.set_FloatArray(this._index+1,value);
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	__getset(0,__proto,'color',function(){
		return this._buffer.get_Color(this._index+5);
		},function(value){
		this._buffer.set_Color(this._index+5,value);
	});

	__getset(0,__proto,'font',function(){
		return this._buffer.get_String(this._index+4);
		},function(value){
		this._buffer.set_String(this._index+4,value);
	});

	FillWordsCmdNative.create=function(words,x,y,font,color){
		var cmd=Pool.getItemByClass("FillWordsCmdNative",FillWordsCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.FILL_WORDS.id);
		bf.add_FloatArray(words);
		bf.add_f(x);
		bf.add_f(y);
		bf.add_String(font);
		bf.add_Color(color);
		return cmd;
	}

	FillWordsCmdNative.ID="FillWords";
	return FillWordsCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/RestoreCmdNative.as=======199.999940/199.999940
/**
*...
*@author ww
*/
//class laya.display.cmdNative.RestoreCmdNative
var RestoreCmdNative=(function(){
	function RestoreCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(RestoreCmdNative,'laya.display.cmdNative.RestoreCmdNative');
	var __proto=RestoreCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("RestoreCmdNative",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "Restore";
	});

	RestoreCmdNative.create=function(){
		var cmd=Pool.getItemByClass("RestoreCmdNative",RestoreCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.RESTORE.id);
		return cmd;
	}

	RestoreCmdNative.ID="Restore";
	return RestoreCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/RotateCmdNative.as=======199.999939/199.999939
/**
*...
*@author ww
*/
//class laya.display.cmdNative.RotateCmdNative
var RotateCmdNative=(function(){
	function RotateCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(RotateCmdNative,'laya.display.cmdNative.RotateCmdNative');
	var __proto=RotateCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("RotateCmdNative",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "Rotate";
	});

	__getset(0,__proto,'angle',function(){
		return this._buffer.get_f(this._index+1);
		},function(value){
		this._buffer.set_f(this._index+1,value);
	});

	__getset(0,__proto,'pivotX',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'pivotY',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	RotateCmdNative.create=function(angle,pivotX,pivotY){
		var cmd=Pool.getItemByClass("RotateCmdNative",RotateCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.ROTATE.id);
		bf.add_f(angle);
		bf.add_f(pivotX);
		bf.add_f(pivotY);
		return cmd;
	}

	RotateCmdNative.ID="Rotate";
	return RotateCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/SaveCmdNative.as=======199.999938/199.999938
/**
*...
*@author ww
*/
//class laya.display.cmdNative.SaveCmdNative
var SaveCmdNative=(function(){
	function SaveCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(SaveCmdNative,'laya.display.cmdNative.SaveCmdNative');
	var __proto=SaveCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("SaveCmdNative",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "Save";
	});

	SaveCmdNative.create=function(){
		var cmd=Pool.getItemByClass("SaveCmdNative",SaveCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.SAVE.id);
		return cmd;
	}

	SaveCmdNative.ID="Save";
	return SaveCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/ScaleCmdNative.as=======199.999937/199.999937
/**
*...
*@author ww
*/
//class laya.display.cmdNative.ScaleCmdNative
var ScaleCmdNative=(function(){
	function ScaleCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(ScaleCmdNative,'laya.display.cmdNative.ScaleCmdNative');
	var __proto=ScaleCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("ScaleCmdNative",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "Scale";
	});

	__getset(0,__proto,'scaleX',function(){
		return this._buffer.get_f(this._index+1);
		},function(value){
		this._buffer.set_f(this._index+1,value);
	});

	__getset(0,__proto,'scaleY',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'pivotX',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	__getset(0,__proto,'pivotY',function(){
		return this._buffer.get_f(this._index+4);
		},function(value){
		this._buffer.set_f(this._index+4,value);
	});

	ScaleCmdNative.create=function(scaleX,scaleY,pivotX,pivotY){
		var cmd=Pool.getItemByClass("ScaleCmdNative",ScaleCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.SCALE.id);
		bf.add_f(scaleX);
		bf.add_f(scaleY);
		bf.add_f(pivotX);
		bf.add_f(pivotY);
		return cmd;
	}

	ScaleCmdNative.ID="Scale";
	return ScaleCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/StrokeTextCmdNative.as=======199.999936/199.999936
/**
*...
*@author ww
*/
//class laya.display.cmdNative.StrokeTextCmdNative
var StrokeTextCmdNative=(function(){
	function StrokeTextCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(StrokeTextCmdNative,'laya.display.cmdNative.StrokeTextCmdNative');
	var __proto=StrokeTextCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("StrokeTextCmdNative",this);
	}

	__getset(0,__proto,'text',function(){
		return this._buffer.get_String(this._index+1);
		},function(value){
		this._buffer.set_String(this._index+1,value);
	});

	__getset(0,__proto,'cmdID',function(){
		return "StrokeText";
	});

	__getset(0,__proto,'textAlign',function(){
		return this._buffer.get_String(this._index+7);
		},function(value){
		this._buffer.set_String(this._index+7,value);
	});

	__getset(0,__proto,'x',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'y',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	__getset(0,__proto,'color',function(){
		return this._buffer.get_Color(this._index+5);
		},function(value){
		this._buffer.set_Color(this._index+5,value);
	});

	__getset(0,__proto,'font',function(){
		return this._buffer.get_String(this._index+4);
		},function(value){
		this._buffer.set_String(this._index+4,value);
	});

	__getset(0,__proto,'lineWidth',function(){
		return this._buffer.get_f(this._index+6);
		},function(value){
		this._buffer.set_f(this._index+6,value);
	});

	StrokeTextCmdNative.create=function(text,x,y,font,color,lineWidth,textAlign){
		var cmd=Pool.getItemByClass("StrokeTextCmdNative",StrokeTextCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.STROKE_TEXT.id);
		bf.add_String(text);
		bf.add_f(x);
		bf.add_f(y);
		bf.add_String(font);
		bf.add_Color(color);
		bf.add_f(lineWidth);
		bf.add_String(textAlign);
		return cmd;
	}

	StrokeTextCmdNative.ID="StrokeText";
	return StrokeTextCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/TransformCmdNative.as=======199.999935/199.999935
/**
*...
*@author ww
*/
//class laya.display.cmdNative.TransformCmdNative
var TransformCmdNative=(function(){
	function TransformCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(TransformCmdNative,'laya.display.cmdNative.TransformCmdNative');
	var __proto=TransformCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("TransformCmdNative",this);
	}

	__getset(0,__proto,'cmdID',function(){
		return "Transform";
	});

	__getset(0,__proto,'matrix',function(){
		return this._buffer.get_matrix(this._index+1);
		},function(value){
		this._buffer.set_matrix(this._index+1,value);
	});

	__getset(0,__proto,'pivotX',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'pivotY',function(){
		return this._buffer.get_f(this._index+3);
		},function(value){
		this._buffer.set_f(this._index+3,value);
	});

	TransformCmdNative.create=function(matrix,pivotX,pivotY){
		var cmd=Pool.getItemByClass("TransformCmdNative",TransformCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.TRANSFORM.id);
		bf.add_matrix(matrix);
		bf.add_f(pivotX);
		bf.add_f(pivotY);
		return cmd;
	}

	TransformCmdNative.ID="Transform";
	return TransformCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/cmdNative/TranslateCmdNative.as=======199.999934/199.999934
/**
*...
*@author ww
*/
//class laya.display.cmdNative.TranslateCmdNative
var TranslateCmdNative=(function(){
	function TranslateCmdNative(){
		this._buffer=null;
		this._index=0;
	}

	__class(TranslateCmdNative,'laya.display.cmdNative.TranslateCmdNative');
	var __proto=TranslateCmdNative.prototype;
	/**
	*回收到对象池
	*/
	__proto.recover=function(){
		this._buffer=null;
		Pool.recover("TranslateCmdNative",this);
	}

	__getset(0,__proto,'ty',function(){
		return this._buffer.get_f(this._index+2);
		},function(value){
		this._buffer.set_f(this._index+2,value);
	});

	__getset(0,__proto,'cmdID',function(){
		return "Translate";
	});

	__getset(0,__proto,'tx',function(){
		return this._buffer.get_f(this._index+1);
		},function(value){
		this._buffer.set_f(this._index+1,value);
	});

	TranslateCmdNative.create=function(tx,ty){
		var cmd=Pool.getItemByClass("TranslateCmdNative",TranslateCmdNative);
		cmd._buffer=this._buffer;;
		var bf=cmd._buffer;
		cmd._index=bf.add_i(LayaGL.TRANSLATE.id);
		bf.add_f(tx);
		bf.add_f(ty);
		return cmd;
	}

	TranslateCmdNative.ID="Translate";
	return TranslateCmdNative;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/css/BoundsStyle.as=======199.999933/199.999933
/**
*@private
*Graphic bounds数据类
*/
//class laya.display.css.BoundsStyle
var BoundsStyle=(function(){
	function BoundsStyle(){
		/**@private */
		//this.bounds=null;
		/**用户设的bounds*/
		//this.userBounds=null;
		/**缓存的bounds顶点,sprite计算bounds用*/
		//this.temBM=null;
	}

	__class(BoundsStyle,'laya.display.css.BoundsStyle');
	var __proto=BoundsStyle.prototype;
	/**
	*重置
	*/
	__proto.reset=function(){
		if(this.bounds)this.bounds.recover();
		if(this.userBounds)this.userBounds.recover();
		this.bounds=null;
		this.userBounds=null;
		this.temBM=null;
		return this;
	}

	/**
	*回收
	*/
	__proto.recover=function(){
		Pool.recover("BoundsStyle",this.reset());
	}

	BoundsStyle.create=function(){
		return Pool.getItemByClass("BoundsStyle",BoundsStyle);
	}

	return BoundsStyle;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/css/CacheStyle.as=======199.999932/199.999932
/**
*@private
*存储cache相关
*/
//class laya.display.css.CacheStyle
var CacheStyle=(function(){
	function CacheStyle(){
		/**当前实际的cache状态*/
		//this.cacheAs=null;
		/**是否开启canvas渲染*/
		//this.enableCanvasRender=false;
		/**用户设的cacheAs类型*/
		//this.userSetCache=null;
		/**是否需要为滤镜cache*/
		//this.cacheForFilters=false;
		/**是否为静态缓存*/
		//this.staticCache=false;
		/**是否需要刷新缓存*/
		//this.reCache=false;
		/**mask对象*/
		//this.mask=null;
		/**作为mask时的父对象*/
		//this.maskParent=null;
		/**滤镜数据*/
		//this.filters=null;
		/**当前缓存区域*/
		//this.cacheRect=null;
		/**当前使用的canvas*/
		//this.canvas=null;
		/**滤镜数据*/
		//this.filterCache=null;
		/**是否有发光滤镜*/
		//this.hasGlowFilter=false;
		this.reset();
	}

	__class(CacheStyle,'laya.display.css.CacheStyle');
	var __proto=CacheStyle.prototype;
	/**
	*是否需要Bitmap缓存
	*@return
	*/
	__proto.needBitmapCache=function(){
		return this.cacheForFilters || this.mask;
	}

	/**
	*是否需要开启canvas渲染
	*/
	__proto.needEnableCanvasRender=function(){
		return this.userSetCache !="none" || this.cacheForFilters || this.mask;
	}

	/**
	*释放cache的资源
	*/
	__proto.releaseContext=function(){
		if (this.canvas){
			Pool.recover("CacheCanvas",this.canvas);
			this.canvas.size(0,0);
			this.canvas=null;
		}
	}

	__proto.createContext=function(){
		if (!this.canvas){
			this.canvas=Pool.getItem("CacheCanvas")|| HTMLCanvas.create("AUTO");
			var tx=this.canvas.context;
			if (!tx){
				tx=this.canvas.getContext('2d');
				tx.__tx=0;
				tx.__ty=0;
			}
		}
	}

	/**
	*释放滤镜资源
	*/
	__proto.releaseFilterCache=function(){
		var fc=this.filterCache;
		if (fc){
			fc.destroy();
			fc.recycle();
			this.filterCache=null;
		}
	}

	/**
	*回收
	*/
	__proto.recover=function(){
		if (this===CacheStyle.EMPTY)return;
		Pool.recover("SpriteCache",this.reset());
	}

	/**
	*重置
	*/
	__proto.reset=function(){
		this.releaseContext();
		this.releaseFilterCache();
		this.cacheAs="none";
		this.enableCanvasRender=false;
		this.userSetCache="none";
		this.cacheForFilters=false;
		this.staticCache=false;
		this.reCache=true;
		this.mask=null;
		this.maskParent=null;
		this.filterCache=null;
		this.filters=null;
		this.hasGlowFilter=false;
		if(this.cacheRect)this.cacheRect.recover();
		this.cacheRect=null;
		return this
	}

	__proto._calculateCacheRect=function(sprite,tCacheType,x,y){
		var _cacheStyle=sprite._cacheStyle;
		if (!_cacheStyle.cacheRect)
			_cacheStyle.cacheRect=Rectangle.create();
		var tRec;
		if (!Render.isWebGL || tCacheType==="bitmap"){
			tRec=sprite.getSelfBounds();
			tRec.x=tRec.x;
			tRec.y=tRec.y;
			tRec.x=tRec.x-16;
			tRec.y=tRec.y-16;
			tRec.width=tRec.width+32;
			tRec.height=tRec.height+32;
			tRec.x=Math.floor(tRec.x+x)-x;
			tRec.y=Math.floor(tRec.y+y)-y;
			tRec.width=Math.floor(tRec.width);
			tRec.height=Math.floor(tRec.height);
			_cacheStyle.cacheRect.copyFrom(tRec);
			}else {
			_cacheStyle.cacheRect.setTo(-sprite._style.pivotX,-sprite._style.pivotY,1,1);
		}
		tRec=_cacheStyle.cacheRect;
		var scaleX=Render.isWebGL ? 1 :Browser.pixelRatio *Laya.stage.clientScaleX;
		var scaleY=Render.isWebGL ? 1 :Browser.pixelRatio *Laya.stage.clientScaleY;
		if (!Render.isWebGL){
			var chainScaleX=1;
			var chainScaleY=1;
			var tar;
			tar=sprite;
			while (tar && tar !=Laya.stage){
				chainScaleX *=tar.scaleX;
				chainScaleY *=tar.scaleY;
				tar=tar.parent;
			}
			if (chainScaleX > 1)scaleX *=chainScaleX;
			if (chainScaleY > 1)scaleY *=chainScaleY;
		}
		if (sprite._style.scrollRect){
			var scrollRect=sprite._style.scrollRect;
			tRec.x-=scrollRect.x;
			tRec.y-=scrollRect.y;
		}
		CacheStyle._scaleInfo.setTo(scaleX,scaleY);
		return CacheStyle._scaleInfo;
	}

	CacheStyle.create=function(){
		return Pool.getItemByClass("SpriteCache",CacheStyle);
	}

	CacheStyle.EMPTY=new CacheStyle();
	__static(CacheStyle,
	['_scaleInfo',function(){return this._scaleInfo=new Point();}
	]);
	return CacheStyle;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/css/SpriteStyle.as=======199.999931/199.999931
/**
*@private
*元素样式
*/
//class laya.display.css.SpriteStyle
var SpriteStyle=(function(){
	function SpriteStyle(){
		//this.scaleX=NaN;
		//this.scaleY=NaN;
		//this.skewX=NaN;
		//this.skewY=NaN;
		//this.pivotX=NaN;
		//this.pivotY=NaN;
		//this.rotation=NaN;
		//this.alpha=NaN;
		//this.scrollRect=null;
		//this.viewport=null;
		//this.hitArea=null;
		//this.dragging=null;
		//this.blendMode=null;
		this.reset();
	}

	__class(SpriteStyle,'laya.display.css.SpriteStyle');
	var __proto=SpriteStyle.prototype;
	/**
	*重置，方便下次复用
	*/
	__proto.reset=function(){
		this.scaleX=this.scaleY=1;
		this.skewX=this.skewY=0;
		this.pivotX=this.pivotY=this.rotation=0;
		this.alpha=1;
		if(this.scrollRect)this.scrollRect.recover();
		this.scrollRect=null;
		if(this.viewport)this.viewport.recover();
		this.viewport=null;
		this.hitArea=null;
		this.dragging=null;
		this.blendMode=null;
		return this
	}

	/**
	*回收
	*/
	__proto.recover=function(){
		if (this===SpriteStyle.EMPTY)return;
		Pool.recover("SpriteStyle",this.reset());
	}

	SpriteStyle.create=function(){
		return Pool.getItemByClass("SpriteStyle",SpriteStyle);
	}

	SpriteStyle.EMPTY=new SpriteStyle();
	return SpriteStyle;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/Graphics.as=======199.999927/199.999927
/**
*<code>Graphics</code> 类用于创建绘图显示对象。Graphics可以同时绘制多个位图或者矢量图，还可以结合save，restore，transform，scale，rotate，translate，alpha等指令对绘图效果进行变化。
*Graphics以命令流方式存储，可以通过cmds属性访问所有命令流。Graphics是比Sprite更轻量级的对象，合理使用能提高应用性能(比如把大量的节点绘图改为一个节点的Graphics命令集合，能减少大量节点创建消耗)。
*@see laya.display.Sprite#graphics
*/
//class laya.display.Graphics
var Graphics=(function(){
	function Graphics(){
		/**@private */
		//this._sp=null;
		/**@private */
		this._one=null;
		/**@private */
		this._cmds=null;
		/**@private */
		//this._vectorgraphArray=null;
		/**@private */
		//this._graphicBounds=null;
		this._render=this._renderEmpty;
		this._createData();
	}

	__class(Graphics,'laya.display.Graphics');
	var __proto=Graphics.prototype;
	__proto._createData=function(){}
	__proto._clearData=function(){}
	__proto._destroyData=function(){}
	/**
	*<p>销毁此对象。</p>
	*/
	__proto.destroy=function(){
		this.clear(true);
		if (this._graphicBounds)this._graphicBounds.destroy();
		this._graphicBounds=null;
		this._vectorgraphArray=null;
		if (this._sp){
			this._sp._renderType=0;
			this._sp._setRenderType(0);
			this._sp=null;
		}
		this._destroyData();
	}

	/**
	*<p>清空绘制命令。</p>
	*@param recoverCmds 是否回收绘图指令数组，设置为true，则对指令数组进行回收以节省内存开销，建议设置为true进行回收，但如果手动引用了数组，不建议回收
	*/
	__proto.clear=function(recoverCmds){
		(recoverCmds===void 0)&& (recoverCmds=false);
		if (recoverCmds){
			var tCmd=this._one;
			if (this._cmds){
				var i=0,len=this._cmds.length;
				for (i=0;i < len;i++){
					tCmd=this._cmds[i];
					tCmd.recover();
				}
				this._cmds.length=0;
				}else if (tCmd){
				tCmd.recover();
			}
			}else {
			this._cmds=null;
		}
		this._one=null;
		this._render=this._renderEmpty;
		this._clearData();
		if (this._sp){
			this._sp._renderType &=~0x200;
			this._sp._setRenderType(this._sp._renderType);
		}
		this._repaint();
		if (this._vectorgraphArray){
			for (i=0,len=this._vectorgraphArray.length;i < len;i++){
				VectorGraphManager.getInstance().deleteShape(this._vectorgraphArray[i]);
			}
			this._vectorgraphArray.length=0;
		}
	}

	/**@private */
	__proto._clearBoundsCache=function(){
		if(this._graphicBounds)this._graphicBounds.reset();
	}

	/**@private */
	__proto._initGraphicBounds=function(){
		if (!this._graphicBounds){
			this._graphicBounds=GraphicsBounds.create();
			this._graphicBounds._graphics=this;
		}
	}

	/**
	*@private
	*重绘此对象。
	*/
	__proto._repaint=function(){
		this._clearBoundsCache();
		this._sp && this._sp.repaint();
	}

	/**@private */
	__proto._isOnlyOne=function(){
		return !this._cmds || this._cmds.length===0;
	}

	/**
	*获取位置及宽高信息矩阵(比较耗CPU，频繁使用会造成卡顿，尽量少用)。
	*@param realSize （可选）使用图片的真实大小，默认为false
	*@return 位置与宽高组成的 一个 Rectangle 对象。
	*/
	__proto.getBounds=function(realSize){
		(realSize===void 0)&& (realSize=false);
		this._initGraphicBounds();
		return this._graphicBounds.getBounds(realSize);
	}

	/**
	*@private
	*@param realSize （可选）使用图片的真实大小，默认为false
	*获取端点列表。
	*/
	__proto.getBoundPoints=function(realSize){
		(realSize===void 0)&& (realSize=false);
		this._initGraphicBounds();
		return this._graphicBounds.getBoundPoints(realSize);
	}

	/**
	*
	*@param tex
	*@param x
	*@param y
	*@param width
	*@param height
	*/
	__proto.drawImage=function(texture,x,y,width,height){
		(x===void 0)&& (x=0);
		(y===void 0)&& (y=0);
		(width===void 0)&& (width=0);
		(height===void 0)&& (height=0);
		if (!texture)return null;
		if (!width)width=texture.sourceWidth;
		if (!height)height=texture.sourceHeight;
		if (texture.loaded){
			var wRate=width / texture.sourceWidth;
			var hRate=height / texture.sourceHeight;
			width=texture.width *wRate;
			height=texture.height *hRate;
			if (width <=0 || height <=0)return null;
			x+=texture.offsetX *wRate;
			y+=texture.offsetY *hRate;
		}
		if (this._sp){
			this._sp._renderType |=0x200;
			this._sp._setRenderType(this._sp._renderType);
		};
		var args=DrawImageCmd.create.call(this,texture,x,y,width,height);
		if (this._one==null){
			this._one=args;
			this._render=this._renderOneImg;
			}else {
			this._saveToCmd(null,args);
		}
		this._repaint();
		return args;
	}

	/**@private */
	__proto._isOneImage=function(){
		return this._render===this._renderOneImg;
	}

	/**
	*绘制纹理。
	*@param tex 纹理。
	*@param x （可选）X轴偏移量。
	*@param y （可选）Y轴偏移量。
	*@param width （可选）宽度。
	*@param height （可选）高度。
	*@param matrix （可选）矩阵信息。
	*@param alpha （可选）透明度。
	*/
	__proto.drawTexture=function(texture,x,y,width,height,matrix,alpha,color,blendMode){
		(x===void 0)&& (x=0);
		(y===void 0)&& (y=0);
		(width===void 0)&& (width=0);
		(height===void 0)&& (height=0);
		(alpha===void 0)&& (alpha=1);
		if (!texture || alpha < 0.01)return null;
		if (!texture.loaded)return null;
		if (!width)width=texture.sourceWidth;
		if (!height)height=texture.sourceHeight;
		if (texture.loaded){
			var wRate=width / texture.sourceWidth;
			var hRate=height / texture.sourceHeight;
			width=texture.width *wRate;
			height=texture.height *hRate;
			if (width <=0 || height <=0)return null;
			x+=texture.offsetX *wRate;
			y+=texture.offsetY *hRate;
		}
		if (this._sp){
			this._sp._renderType |=0x200;
			this._sp._setRenderType(this._sp._renderType);
		}
		if (!Render.isWebGL && (blendMode || color)){
			var canvas=HTMLCanvas.create("2D");
			canvas.size(width,height);
			var ctx=canvas.getContext('2d');
			ctx.drawTexture(texture,0,0,width,height);
			texture=new Texture(canvas);
			if (color){
				var filter=new ColorFilterAction();
				var colorArr=Color.create(color).arrColor;
				filter.data=new ColorFilter().color(colorArr[0] *255,colorArr[1] *255,colorArr[2] *255);
				filter.apply({ctx:{ctx:ctx}});
			}
		};
		var args=DrawTextureCmd.create.call(this,texture,x,y,width,height,matrix,alpha,color,blendMode);
		this._repaint();
		return this._saveToCmd(null,args);
	}

	/**
	*@private 清理贴图并替换为最新的
	*@param tex
	*/
	__proto.cleanByTexture=function(texture,x,y,width,height){
		(width===void 0)&& (width=0);
		(height===void 0)&& (height=0);
		if (!texture)return this.clear(true);
		if (this._one && this._render===this._renderOneImg){
			if (!width)width=texture.sourceWidth;
			if (!height)height=texture.sourceHeight;
			var wRate=width / texture.sourceWidth;
			var hRate=height / texture.sourceHeight;
			width=texture.width *wRate;
			height=texture.height *hRate;
			x+=texture.offsetX *wRate;
			y+=texture.offsetY *hRate;
			var drawImageCmd=this._one;
			drawImageCmd.texture=texture;
			drawImageCmd.x=x;
			drawImageCmd.y=y;
			drawImageCmd.width=width;
			drawImageCmd.height=height;
			this._repaint();
			}else {
			this.clear(true);
			texture && this.drawImage(texture,x,y,width,height);
		}
	}

	/**
	*批量绘制同样纹理。
	*@param tex 纹理。
	*@param pos 绘制次数和坐标。
	*/
	__proto.drawTextures=function(texture,pos){
		if (!texture)return null;
		return this._saveToCmd(Render._context._drawTextures,DrawTexturesCmd.create.call(this,texture,pos));
	}

	/**
	*绘制一组三角形
	*@param texture 纹理。
	*@param x X轴偏移量。
	*@param y Y轴偏移量。
	*@param vertices 顶点数组。
	*@param indices 顶点索引。
	*@param uvData UV数据。
	*@param matrix 缩放矩阵。
	*@param alpha alpha
	*@param color 颜色变换
	*@param blendMode blend模式
	*/
	__proto.drawTriangles=function(texture,x,y,vertices,uvs,indices,matrix,alpha,color,blendMode){
		(alpha===void 0)&& (alpha=1);
		return this._saveToCmd(Render._context.drawTriangles,DrawTrianglesCmd.create.call(this,texture,x,y,vertices,uvs,indices,matrix,alpha,color,blendMode));
	}

	/**
	*用texture填充。
	*@param tex 纹理。
	*@param x X轴偏移量。
	*@param y Y轴偏移量。
	*@param width （可选）宽度。
	*@param height （可选）高度。
	*@param type （可选）填充类型 repeat|repeat-x|repeat-y|no-repeat
	*@param offset （可选）贴图纹理偏移
	*
	*/
	__proto.fillTexture=function(texture,x,y,width,height,type,offset){
		(width===void 0)&& (width=0);
		(height===void 0)&& (height=0);
		(type===void 0)&& (type="repeat");
		if (!texture||!texture.loaded)return null;
		return this._saveToCmd(Render._context._fillTexture,FillTextureCmd.create.call(this,texture,x,y,width,height,type,offset || Point.EMPTY,{}));
	}

	/**
	*@private
	*保存到命令流。
	*/
	__proto._saveToCmd=function(fun,args){
		if (this._sp){
			this._sp._renderType |=0x200;
			this._sp._setRenderType(this._sp._renderType);
		}
		if (this._one==null){
			this._one=args;
			this._render=this._renderOne;
			}else {
			this._render=this._renderAll;
			(this._cmds || (this._cmds=[])).length===0 && this._cmds.push(this._one);
			this._cmds.push(args);
		}
		this._repaint();
		return args;
	}

	/**
	*设置剪裁区域，超出剪裁区域的坐标不显示。
	*@param x X 轴偏移量。
	*@param y Y 轴偏移量。
	*@param width 宽度。
	*@param height 高度。
	*/
	__proto.clipRect=function(x,y,width,height){
		return this._saveToCmd(Render._context._clipRect,ClipRectCmd.create.call(this,x,y,width,height));
	}

	/**
	*在画布上绘制文本。
	*@param text 在画布上输出的文本。
	*@param x 开始绘制文本的 x 坐标位置（相对于画布）。
	*@param y 开始绘制文本的 y 坐标位置（相对于画布）。
	*@param font 定义字号和字体，比如"20px Arial"。
	*@param color 定义文本颜色，比如"#ff0000"。
	*@param textAlign 文本对齐方式，可选值："left"，"center"，"right"。
	*/
	__proto.fillText=function(text,x,y,font,color,textAlign){
		return this._saveToCmd(Render._context._fillText,FillTextCmd.create.call(this,text,x,y,font||Text.defaultFontStr(),color,textAlign));
	}

	/**
	*在画布上绘制“被填充且镶边的”文本。
	*@param text 在画布上输出的文本。
	*@param x 开始绘制文本的 x 坐标位置（相对于画布）。
	*@param y 开始绘制文本的 y 坐标位置（相对于画布）。
	*@param font 定义字体和字号，比如"20px Arial"。
	*@param fillColor 定义文本颜色，比如"#ff0000"。
	*@param borderColor 定义镶边文本颜色。
	*@param lineWidth 镶边线条宽度。
	*@param textAlign 文本对齐方式，可选值："left"，"center"，"right"。
	*/
	__proto.fillBorderText=function(text,x,y,font,fillColor,borderColor,lineWidth,textAlign){
		return this._saveToCmd(Render._context._fillBorderText,FillBorderTextCmd.create.call(this,text,x,y,font||Text.defaultFontStr(),fillColor,borderColor,lineWidth,textAlign));
	}

	/***@private */
	__proto.fillWords=function(words,x,y,font,color){
		return this._saveToCmd(Render._context._fillWords,FillWordsCmd.create.call(this,words,x,y,font||Text.defaultFontStr(),color));
	}

	/***@private */
	__proto.fillBorderWords=function(words,x,y,font,fillColor,borderColor,lineWidth){
		return this._saveToCmd(Render._context._fillBorderWords,FillBorderWordsCmd.create.call(this,words,x,y,font||Text.defaultFontStr(),fillColor,borderColor,lineWidth));
	}

	/**
	*在画布上绘制文本（没有填色）。文本的默认颜色是黑色。
	*@param text 在画布上输出的文本。
	*@param x 开始绘制文本的 x 坐标位置（相对于画布）。
	*@param y 开始绘制文本的 y 坐标位置（相对于画布）。
	*@param font 定义字体和字号，比如"20px Arial"。
	*@param color 定义文本颜色，比如"#ff0000"。
	*@param lineWidth 线条宽度。
	*@param textAlign 文本对齐方式，可选值："left"，"center"，"right"。
	*/
	__proto.strokeText=function(text,x,y,font,color,lineWidth,textAlign){
		return this._saveToCmd(Render._context._strokeText,StrokeTextCmd.create.call(this,text,x,y,font||Text.defaultFontStr(),color,lineWidth,textAlign));
	}

	/**
	*设置透明度。
	*@param value 透明度。
	*/
	__proto.alpha=function(alpha){
		return this._saveToCmd(Render._context._alpha,AlphaCmd.create.call(this,alpha));
	}

	/**
	*替换绘图的当前转换矩阵。
	*@param mat 矩阵。
	*@param pivotX （可选）水平方向轴心点坐标。
	*@param pivotY （可选）垂直方向轴心点坐标。
	*/
	__proto.transform=function(matrix,pivotX,pivotY){
		(pivotX===void 0)&& (pivotX=0);
		(pivotY===void 0)&& (pivotY=0);
		return this._saveToCmd(Render._context._transform,TransformCmd.create.call(this,matrix,pivotX,pivotY));
	}

	/**
	*旋转当前绘图。(推荐使用transform，性能更高)
	*@param angle 旋转角度，以弧度计。
	*@param pivotX （可选）水平方向轴心点坐标。
	*@param pivotY （可选）垂直方向轴心点坐标。
	*/
	__proto.rotate=function(angle,pivotX,pivotY){
		(pivotX===void 0)&& (pivotX=0);
		(pivotY===void 0)&& (pivotY=0);
		return this._saveToCmd(Render._context._rotate,RotateCmd.create.call(this,angle,pivotX,pivotY));
	}

	/**
	*缩放当前绘图至更大或更小。(推荐使用transform，性能更高)
	*@param scaleX 水平方向缩放值。
	*@param scaleY 垂直方向缩放值。
	*@param pivotX （可选）水平方向轴心点坐标。
	*@param pivotY （可选）垂直方向轴心点坐标。
	*/
	__proto.scale=function(scaleX,scaleY,pivotX,pivotY){
		(pivotX===void 0)&& (pivotX=0);
		(pivotY===void 0)&& (pivotY=0);
		return this._saveToCmd(Render._context._scale,ScaleCmd.create.call(this,scaleX,scaleY,pivotX,pivotY));
	}

	/**
	*重新映射画布上的 (0,0)位置。
	*@param x 添加到水平坐标（x）上的值。
	*@param y 添加到垂直坐标（y）上的值。
	*/
	__proto.translate=function(tx,ty){
		return this._saveToCmd(Render._context._translate,TranslateCmd.create.call(this,tx,ty));
	}

	/**
	*保存当前环境的状态。
	*/
	__proto.save=function(){
		return this._saveToCmd(Render._context._save,SaveCmd.create.call(this));
	}

	/**
	*返回之前保存过的路径状态和属性。
	*/
	__proto.restore=function(){
		return this._saveToCmd(Render._context._restore,RestoreCmd.create.call(this));
	}

	/**
	*@private
	*替换文本内容。
	*@param text 文本内容。
	*@return 替换成功则值为true，否则值为flase。
	*/
	__proto.replaceText=function(text){
		this._repaint();
		var cmds=this._cmds;
		if (!cmds){
			if (this._one && this._isTextCmd(this._one)){
				this._one.text=text;
				return true;
			}
			}else {
			for (var i=cmds.length-1;i >-1;i--){
				if (this._isTextCmd(cmds[i])){
					cmds[i].text=text;
					return true;
				}
			}
		}
		return false;
	}

	/**@private */
	__proto._isTextCmd=function(cmd){
		var cmdID=cmd.cmdID;
		return cmdID=="FillText" || cmdID=="StrokeText" || cmdID=="FillBorderText";
	}

	/**
	*@private
	*替换文本颜色。
	*@param color 颜色。
	*/
	__proto.replaceTextColor=function(color){
		this._repaint();
		var cmds=this._cmds;
		if (!cmds){
			if (this._one && this._isTextCmd(this._one)){
				this._setTextCmdColor(this._one,color);
			}
			}else {
			for (var i=cmds.length-1;i >-1;i--){
				if (this._isTextCmd(cmds[i])){
					this._setTextCmdColor(cmds[i],color);
				}
			}
		}
	}

	__proto._setTextCmdColor=function(cmdO,color){
		var cmdID=cmdO.cmdID;
		switch(cmdID){
			case "FillText":
			case "StrokeText":
				cmdO.color=color;
				break ;
			case "FillBorderText":
			case "FillBorderWords":
			case "FillBorderText":
				cmdO.fillColor=color;
				break ;
			}
	}

	/**
	*加载并显示一个图片。
	*@param url 图片地址。
	*@param x （可选）显示图片的x位置。
	*@param y （可选）显示图片的y位置。
	*@param width （可选）显示图片的宽度，设置为0表示使用图片默认宽度。
	*@param height （可选）显示图片的高度，设置为0表示使用图片默认高度。
	*@param complete （可选）加载完成回调。
	*/
	__proto.loadImage=function(url,x,y,width,height,complete){
		(x===void 0)&& (x=0);
		(y===void 0)&& (y=0);
		(width===void 0)&& (width=0);
		(height===void 0)&& (height=0);
		var tex=Loader.getRes(url);
		if (!tex){
			tex=new Texture();
			tex.load(url);
			Loader.cacheRes(url,tex);
			tex.once("loaded",this,this.drawImage,[tex,x,y,width,height]);
			}else{
			if (!tex.loaded){
				tex.once("loaded",this,this.drawImage,[tex,x,y,width,height]);
			}else
			this.drawImage(tex,x,y,width,height);
		}
		if (complete !=null){
			tex._loaded ? complete.call(this._sp):tex.on("loaded",this._sp,complete);
		}
	}

	/**
	*@private
	*/
	__proto._renderEmpty=function(sprite,context,x,y){}
	/**
	*@private
	*/
	__proto._renderAll=function(sprite,context,x,y){
		var cmds=this._cmds,cmd;
		for (var i=0,n=cmds.length;i < n;i++){
			(cmd=cmds[i]).run(context,x,y);
		}
	}

	/**
	*@private
	*/
	__proto._renderOne=function(sprite,context,x,y){
		this._one.run(context,x,y);
	}

	/**
	*@private
	*/
	__proto._renderOneImg=function(sprite,context,x,y){
		this._one.run(context,x,y);
	}

	/**
	*绘制一条线。
	*@param fromX X轴开始位置。
	*@param fromY Y轴开始位置。
	*@param toX X轴结束位置。
	*@param toY Y轴结束位置。
	*@param lineColor 颜色。
	*@param lineWidth （可选）线条宽度。
	*/
	__proto.drawLine=function(fromX,fromY,toX,toY,lineColor,lineWidth){
		(lineWidth===void 0)&& (lineWidth=1);
		var tId=0;
		if (Render.isWebGL){
			tId=VectorGraphManager.getInstance().getId();
			if (this._vectorgraphArray==null)this._vectorgraphArray=[];
			this._vectorgraphArray.push(tId);
		};
		var offset=lineWidth % 2===0 ? 0 :0.5;
		return this._saveToCmd(Render._context._drawLine,DrawLineCmd.create.call(this,fromX+offset,fromY+offset,toX+offset,toY+offset,lineColor,lineWidth,tId));
	}

	/**
	*绘制一系列线段。
	*@param x 开始绘制的X轴位置。
	*@param y 开始绘制的Y轴位置。
	*@param points 线段的点集合。格式:[x1,y1,x2,y2,x3,y3...]。
	*@param lineColor 线段颜色，或者填充绘图的渐变对象。
	*@param lineWidth （可选）线段宽度。
	*/
	__proto.drawLines=function(x,y,points,lineColor,lineWidth){
		(lineWidth===void 0)&& (lineWidth=1);
		var tId=0;
		if (!points || points.length < 4)return null;
		if (Render.isWebGL){
			tId=VectorGraphManager.getInstance().getId();
			if (this._vectorgraphArray==null)this._vectorgraphArray=[];
			this._vectorgraphArray.push(tId);
		};
		var offset=lineWidth % 2===0 ? 0 :0.5;
		return this._saveToCmd(Render._context._drawLines,DrawLinesCmd.create.call(this,x+offset,y+offset,points,lineColor,lineWidth,tId));
	}

	/**
	*绘制一系列曲线。
	*@param x 开始绘制的 X 轴位置。
	*@param y 开始绘制的 Y 轴位置。
	*@param points 线段的点集合，格式[controlX,controlY,anchorX,anchorY...]。
	*@param lineColor 线段颜色，或者填充绘图的渐变对象。
	*@param lineWidth （可选）线段宽度。
	*/
	__proto.drawCurves=function(x,y,points,lineColor,lineWidth){
		(lineWidth===void 0)&& (lineWidth=1);
		return this._saveToCmd(Render._context._drawCurves,DrawCurvesCmd.create.call(this,x,y,points,lineColor,lineWidth));
	}

	/**
	*绘制矩形。
	*@param x 开始绘制的 X 轴位置。
	*@param y 开始绘制的 Y 轴位置。
	*@param width 矩形宽度。
	*@param height 矩形高度。
	*@param fillColor 填充颜色，或者填充绘图的渐变对象。
	*@param lineColor （可选）边框颜色，或者填充绘图的渐变对象。
	*@param lineWidth （可选）边框宽度。
	*/
	__proto.drawRect=function(x,y,width,height,fillColor,lineColor,lineWidth){
		(lineWidth===void 0)&& (lineWidth=1);
		var offset=lineColor ? lineWidth / 2 :0;
		var lineOffset=lineColor ? lineWidth :0;
		return this._saveToCmd(Render._context.drawRect,DrawRectCmd.create.call(this,x+offset,y+offset,width-lineOffset,height-lineOffset,fillColor,lineColor,lineWidth));
	}

	/**
	*绘制圆形。
	*@param x 圆点X 轴位置。
	*@param y 圆点Y 轴位置。
	*@param radius 半径。
	*@param fillColor 填充颜色，或者填充绘图的渐变对象。
	*@param lineColor （可选）边框颜色，或者填充绘图的渐变对象。
	*@param lineWidth （可选）边框宽度。
	*/
	__proto.drawCircle=function(x,y,radius,fillColor,lineColor,lineWidth){
		(lineWidth===void 0)&& (lineWidth=1);
		var offset=lineColor ? lineWidth / 2 :0;
		var tId=0;
		if (Render.isWebGL){
			tId=VectorGraphManager.getInstance().getId();
			if (this._vectorgraphArray==null)this._vectorgraphArray=[];
			this._vectorgraphArray.push(tId);
		}
		return this._saveToCmd(Render._context._drawCircle,DrawCircleCmd.create.call(this,x,y,radius-offset,fillColor,lineColor,lineWidth,tId));
	}

	/**
	*绘制扇形。
	*@param x 开始绘制的 X 轴位置。
	*@param y 开始绘制的 Y 轴位置。
	*@param radius 扇形半径。
	*@param startAngle 开始角度。
	*@param endAngle 结束角度。
	*@param fillColor 填充颜色，或者填充绘图的渐变对象。
	*@param lineColor （可选）边框颜色，或者填充绘图的渐变对象。
	*@param lineWidth （可选）边框宽度。
	*/
	__proto.drawPie=function(x,y,radius,startAngle,endAngle,fillColor,lineColor,lineWidth){
		(lineWidth===void 0)&& (lineWidth=1);
		var offset=lineColor ? lineWidth / 2 :0;
		var lineOffset=lineColor ? lineWidth :0;
		var tId=0;
		if (Render.isWebGL){
			tId=VectorGraphManager.getInstance().getId();
			if (this._vectorgraphArray==null)this._vectorgraphArray=[];
			this._vectorgraphArray.push(tId);
		}
		return this._saveToCmd(Render._context._drawPie,DrawPieCmd.create.call(this,x+offset,y+offset,radius-lineOffset,Utils.toRadian(startAngle),Utils.toRadian(endAngle),fillColor,lineColor,lineWidth,tId));
	}

	/**
	*绘制多边形。
	*@param x 开始绘制的 X 轴位置。
	*@param y 开始绘制的 Y 轴位置。
	*@param points 多边形的点集合。
	*@param fillColor 填充颜色，或者填充绘图的渐变对象。
	*@param lineColor （可选）边框颜色，或者填充绘图的渐变对象。
	*@param lineWidth （可选）边框宽度。
	*/
	__proto.drawPoly=function(x,y,points,fillColor,lineColor,lineWidth){
		(lineWidth===void 0)&& (lineWidth=1);
		var tId=0;
		if (Render.isWebGL){
			tId=VectorGraphManager.getInstance().getId();
			if (this._vectorgraphArray==null)this._vectorgraphArray=[];
			this._vectorgraphArray.push(tId);
			var tIsConvexPolygon=false;
			if (points.length > 6){
				tIsConvexPolygon=false;
				}else {
				tIsConvexPolygon=true;
			}
		};
		var offset=lineColor ? (lineWidth % 2===0 ? 0 :0.5):0;
		return this._saveToCmd(Render._context._drawPoly,DrawPolyCmd.create.call(this,x+offset,y+offset,points,fillColor,lineColor,lineWidth,tIsConvexPolygon,tId));
	}

	/**
	*绘制路径。
	*@param x 开始绘制的 X 轴位置。
	*@param y 开始绘制的 Y 轴位置。
	*@param paths 路径集合，路径支持以下格式：[["moveTo",x,y],["lineTo",x,y],["arcTo",x1,y1,x2,y2,r],["closePath"]]。
	*@param brush （可选）刷子定义，支持以下设置{fillStyle:"#FF0000"}。
	*@param pen （可选）画笔定义，支持以下设置{strokeStyle,lineWidth,lineJoin:"bevel|round|miter",lineCap:"butt|round|square",miterLimit}。
	*/
	__proto.drawPath=function(x,y,paths,brush,pen){
		return this._saveToCmd(Render._context._drawPath,DrawPathCmd.create.call(this,x,y,paths,brush,pen));
	}

	/**
	*@private
	*命令流。存储了所有绘制命令。
	*/
	__getset(0,__proto,'cmds',function(){
		return this._cmds;
		},function(value){
		if (this._sp){
			this._sp._renderType |=0x200;
			this._sp._setRenderType(this._sp._renderType);
		}
		this._cmds=value;
		this._render=this._renderAll;
		this._repaint();
	});

	return Graphics;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/GraphicsBounds.as=======199.999926/199.999926
/**
*@private
*Graphic bounds数据类
*/
//class laya.display.GraphicsBounds
var GraphicsBounds=(function(){
	function GraphicsBounds(){
		/**@private */
		//this._temp=null;
		/**@private */
		//this._bounds=null;
		/**@private */
		//this._rstBoundPoints=null;
		/**@private */
		this._cacheBoundsType=false;
		/**@private */
		//this._graphics=null;
	}

	__class(GraphicsBounds,'laya.display.GraphicsBounds');
	var __proto=GraphicsBounds.prototype;
	/**
	*销毁
	*/
	__proto.destroy=function(){
		this._graphics=null;
		this._cacheBoundsType=false;
		if (this._temp)this._temp.length=0;
		if (this._rstBoundPoints)this._rstBoundPoints.length=0;
		if (this._bounds)this._bounds.recover();
		this._bounds=null;
		Pool.recover("GraphicsBounds",this);
	}

	/**
	*重置数据
	*/
	__proto.reset=function(){
		this._temp && (this._temp.length=0);
	}

	/**
	*获取位置及宽高信息矩阵(比较耗CPU，频繁使用会造成卡顿，尽量少用)。
	*@param realSize （可选）使用图片的真实大小，默认为false
	*@return 位置与宽高组成的 一个 Rectangle 对象。
	*/
	__proto.getBounds=function(realSize){
		(realSize===void 0)&& (realSize=false);
		if (!this._bounds || !this._temp || this._temp.length < 1 || realSize !=this._cacheBoundsType){
			this._bounds=Rectangle._getWrapRec(this.getBoundPoints(realSize),this._bounds)
		}
		this._cacheBoundsType=realSize;
		return this._bounds;
	}

	/**
	*@private
	*@param realSize （可选）使用图片的真实大小，默认为false
	*获取端点列表。
	*/
	__proto.getBoundPoints=function(realSize){
		(realSize===void 0)&& (realSize=false);
		if (!this._temp || this._temp.length < 1 || realSize !=this._cacheBoundsType)
			this._temp=this._getCmdPoints(realSize);
		this._cacheBoundsType=realSize;
		return this._rstBoundPoints=Utils.copyArray(this._rstBoundPoints,this._temp);
	}

	__proto._getCmdPoints=function(realSize){
		(realSize===void 0)&& (realSize=false);
		var context=Render._context;
		var cmds=this._graphics.cmds;
		var rst;
		rst=this._temp || (this._temp=[]);
		rst.length=0;
		if (!cmds && this._graphics._one !=null){
			GraphicsBounds._tempCmds.length=0;
			GraphicsBounds._tempCmds.push(this._graphics._one);
			cmds=GraphicsBounds._tempCmds;
		}
		if (!cmds)return rst;
		var matrixs=GraphicsBounds._tempMatrixArrays;
		matrixs.length=0;
		var tMatrix=GraphicsBounds._initMatrix;
		tMatrix.identity();
		var tempMatrix=GraphicsBounds._tempMatrix;
		var cmd;
		var tex;
		for (var i=0,n=cmds.length;i < n;i++){
			cmd=cmds[i];
			switch (cmd.cmdID){
				case "Alpha":
					matrixs.push(tMatrix);
					tMatrix=tMatrix.clone();
					break ;
				case "Restore":
					tMatrix=matrixs.pop();
					break ;
				case "Scale":
					tempMatrix.identity();
					tempMatrix.translate(-cmd.pivotX,-cmd.pivotY);
					tempMatrix.scale(cmd.scaleX,cmd.scaleY);
					tempMatrix.translate(cmd.pivotX,cmd.pivotY);
					this._switchMatrix(tMatrix,tempMatrix);
					break ;
				case "Rotate":
					tempMatrix.identity();
					tempMatrix.translate(-cmd.pivotX,-cmd.pivotY);
					tempMatrix.rotate(cmd.angle);
					tempMatrix.translate(cmd.pivotX,cmd.pivotY);
					this._switchMatrix(tMatrix,tempMatrix);
					break ;
				case "Translate":
					tempMatrix.identity();
					tempMatrix.translate(cmd.tx,cmd.ty);
					this._switchMatrix(tMatrix,tempMatrix);
					break ;
				case "Transform":
					tempMatrix.identity();
					tempMatrix.translate(-cmd.pivotX,-cmd.pivotY);
					tempMatrix.concat(cmd.matrix);
					tempMatrix.translate(cmd.pivotX,cmd.pivotY);
					this._switchMatrix(tMatrix,tempMatrix);
					break ;
				case "DrawImage":
				case "FillTexture":
					GraphicsBounds._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd.x,cmd.y,cmd.width,cmd.height),tMatrix);
					break ;
				case "DrawTexture":
					tMatrix.copyTo(tempMatrix);
					if(cmd.matrix)
						tempMatrix.concat(cmd.matrix);
					GraphicsBounds._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd.x,cmd.y,cmd.width,cmd.height),tempMatrix);
					break ;
				case "DrawImage":
					tex=cmd.texture;
					if (realSize){
						if (cmd.width && cmd.height){
							GraphicsBounds._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd.x,cmd.y,cmd.width,cmd.height),tMatrix);
							}else {
							GraphicsBounds._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd.x,cmd.y,tex.width,tex.height),tMatrix);
						}
						}else {
						var wRate=(cmd.width || tex.sourceWidth)/ tex.width;
						var hRate=(cmd.height || tex.sourceHeight)/ tex.height;
						var oWidth=wRate *tex.sourceWidth;
						var oHeight=hRate *tex.sourceHeight;
						var offX=tex.offsetX > 0 ? tex.offsetX :0;
						var offY=tex.offsetY > 0 ? tex.offsetY :0;
						offX *=wRate;
						offY *=hRate;
						GraphicsBounds._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd.x-offX,cmd.y-offY,oWidth,oHeight),tMatrix);
					}
					break ;
				case "FillTexture":
					if (cmd.width && cmd.height){
						GraphicsBounds._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd.x,cmd.y,cmd.width,cmd.height),tMatrix);
						}else {
						tex=cmd.texture;
						GraphicsBounds._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd.x,cmd.y,tex.width,tex.height),tMatrix);
					}
					break ;
				case "DrawTexture":;
					var drawMatrix;
					if (cmd.matrix){
						tMatrix.copyTo(tempMatrix);
						tempMatrix.concat(cmd.matrix);
						drawMatrix=tempMatrix;
						}else {
						drawMatrix=tMatrix;
					}
					if (realSize){
						if (cmd.width && cmd.height){
							GraphicsBounds._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd.x,cmd.y,cmd.width,cmd.height),drawMatrix);
							}else {
							tex=cmd.texture;
							GraphicsBounds._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd.x,cmd.y,tex.width,tex.height),drawMatrix);
						}
						}else {
						tex=cmd.texture;
						wRate=(cmd.width || tex.sourceWidth)/ tex.width;
						hRate=(cmd.height || tex.sourceHeight)/ tex.height;
						oWidth=wRate *tex.sourceWidth;
						oHeight=hRate *tex.sourceHeight;
						offX=tex.offsetX > 0 ? tex.offsetX :0;
						offY=tex.offsetY > 0 ? tex.offsetY :0;
						offX *=wRate;
						offY *=hRate;
						GraphicsBounds._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd.x-offX,cmd.y-offY,oWidth,oHeight),drawMatrix);
					}
					break ;
				case "DrawRect":
					GraphicsBounds._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd.x,cmd.y,cmd.width,cmd.height),tMatrix);
					break ;
				case "DrawCircle":
					GraphicsBounds._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd.x-cmd.radius,cmd.y-cmd.radius,cmd.x+cmd.radius,cmd.y+cmd.radius),tMatrix);
					break ;
				case "DrawLine":
					GraphicsBounds._tempPoints.length=0;
					var lineWidth=NaN;
					lineWidth=cmd.lineWidth *0.5;
					if (cmd.fromX==cmd.toX){
						GraphicsBounds._tempPoints.push(cmd.fromX+lineWidth,cmd.fromY,cmd.toX+lineWidth,cmd.toY,cmd.fromX-lineWidth,cmd.fromY,cmd.toX-lineWidth,cmd.toY);
						}else if (cmd.fromY==cmd.toY){
						GraphicsBounds._tempPoints.push(cmd.fromX,cmd.fromY+lineWidth,cmd.toX,cmd.toY+lineWidth,cmd.fromX,cmd.fromY-lineWidth,cmd.toX,cmd.toY-lineWidth);
						}else {
						GraphicsBounds._tempPoints.push(cmd.fromX,cmd.fromY,cmd.toX,cmd.toY);
					}
					GraphicsBounds._addPointArrToRst(rst,GraphicsBounds._tempPoints,tMatrix);
					break ;
				case "DrawCurves":
					GraphicsBounds._addPointArrToRst(rst,Bezier.I.getBezierPoints(cmd.points),tMatrix,cmd.x,cmd.y);
					break ;
				case "DrawLines":
				case "DrawPoly":
					GraphicsBounds._addPointArrToRst(rst,cmd.points,tMatrix,cmd.x,cmd.y);
					break ;
				case "DrawPath":
					GraphicsBounds._addPointArrToRst(rst,this._getPathPoints(cmd.paths),tMatrix,cmd.x,cmd.y);
					break ;
				case "DrawPie":
					GraphicsBounds._addPointArrToRst(rst,this._getPiePoints(cmd.x,cmd.y,cmd.radius,cmd.startAngle,cmd.endAngle),tMatrix);
					break ;
				}
		}
		if (rst.length > 200){
			rst=Utils.copyArray(rst,Rectangle._getWrapRec(rst)._getBoundPoints());
		}else if (rst.length > 8)
		rst=GrahamScan.scanPList(rst);
		return rst;
	}

	__proto._switchMatrix=function(tMatix,tempMatrix){
		tempMatrix.concat(tMatix);
		tempMatrix.copyTo(tMatix);
	}

	__proto._getPiePoints=function(x,y,radius,startAngle,endAngle){
		var rst=GraphicsBounds._tempPoints;
		GraphicsBounds._tempPoints.length=0;
		rst.push(x,y);
		var dP=Math.PI / 10;
		var i=NaN;
		for (i=startAngle;i < endAngle;i+=dP){
			rst.push(x+radius *Math.cos(i),y+radius *Math.sin(i));
		}
		if (endAngle !=i){
			rst.push(x+radius *Math.cos(endAngle),y+radius *Math.sin(endAngle));
		}
		return rst;
	}

	__proto._getPathPoints=function(paths){
		var i=0,len=0;
		var rst=GraphicsBounds._tempPoints;
		rst.length=0;
		len=paths.length;
		var tCMD;
		for (i=0;i < len;i++){
			tCMD=paths[i];
			if (tCMD.length > 1){
				rst.push(tCMD[1],tCMD[2]);
				if (tCMD.length > 3){
					rst.push(tCMD[3],tCMD[4]);
				}
			}
		}
		return rst;
	}

	GraphicsBounds.create=function(){
		return Pool.getItemByClass("GraphicsBounds",GraphicsBounds);
	}

	GraphicsBounds._addPointArrToRst=function(rst,points,matrix,dx,dy){
		(dx===void 0)&& (dx=0);
		(dy===void 0)&& (dy=0);
		var i=0,len=0;
		len=points.length;
		for (i=0;i < len;i+=2){
			GraphicsBounds._addPointToRst(rst,points[i]+dx,points[i+1]+dy,matrix);
		}
	}

	GraphicsBounds._addPointToRst=function(rst,x,y,matrix){
		var _tempPoint=Point.TEMP;
		_tempPoint.setTo(x ? x :0,y ? y :0);
		matrix.transformPoint(_tempPoint);
		rst.push(_tempPoint.x,_tempPoint.y);
	}

	GraphicsBounds._tempPoints=[];
	GraphicsBounds._tempMatrixArrays=[];
	GraphicsBounds._tempCmds=[];
	__static(GraphicsBounds,
	['_tempMatrix',function(){return this._tempMatrix=new Matrix();},'_initMatrix',function(){return this._initMatrix=new Matrix();}
	]);
	return GraphicsBounds;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/SpriteConst.as=======199.999923/199.999923
/**
*@private
*/
//class laya.display.SpriteConst
var SpriteConst=(function(){
	function SpriteConst(){}
	__class(SpriteConst,'laya.display.SpriteConst');
	SpriteConst.POSRENDERTYPE=0;
	SpriteConst.POSX=1;
	SpriteConst.POSY=2;
	SpriteConst.POSPIVOTX=3;
	SpriteConst.POSPIVOTY=4;
	SpriteConst.POSALPHA=5;
	SpriteConst.POSGRAPICS=6;
	SpriteConst.POSLAYAGL3D=7;
	SpriteConst.POSSCALEX=8;
	SpriteConst.POSSCALEY=9;
	SpriteConst.POSSKEWX=10;
	SpriteConst.POSSKEWY=11;
	SpriteConst.POSROTATION=12;
	SpriteConst.POSTRANSFORM_FLAG=13;
	SpriteConst.POSMATRIX=14;
	SpriteConst.POSTEXTURE=20;
	SpriteConst.POSCACHE=21;
	SpriteConst.POSCUSTOM=22;
	SpriteConst.POSBUFFERBEGIN=23;
	SpriteConst.POSBUFFEREND=24;
	SpriteConst.POSSCROLLRECT=25;
	SpriteConst.POSSIZE=26;
	SpriteConst.ALPHA=0x01;
	SpriteConst.TRANSFORM=0x02;
	SpriteConst.BLEND=0x04;
	SpriteConst.CANVAS=0x08;
	SpriteConst.FILTERS=0x10;
	SpriteConst.MASK=0x20;
	SpriteConst.CLIP=0x40;
	SpriteConst.STYLE=0x80;
	SpriteConst.TEXTURE=0x100;
	SpriteConst.GRAPHICS=0x200;
	SpriteConst.LAYAGL3D=0x400;
	SpriteConst.CUSTOM=0x800;
	SpriteConst.ONECHILD=0x1000;
	SpriteConst.CHILDS=0x2000;
	SpriteConst.REPAINT_NONE=0;
	SpriteConst.REPAINT_NODE=0x01;
	SpriteConst.REPAINT_CACHE=0x02;
	SpriteConst.REPAINT_ALL=0x03;
	__static(SpriteConst,
	['SPRITE_DATA',function(){return this.SPRITE_DATA={
			x:1,
			y:2,
			pivotX:3,
			pivotY:4,
			alpha:5,
			graphics:6,
			layaGL3D:7,
			transformFlag:13,
			matrix:14,
			texture:20,
			cacheCanvas:21
	};}

	]);
	return SpriteConst;
})()


	//file:///E:/git/layaair-master/core/src/laya/events/Event.as=======199.999921/199.999921
/**
*<code>Event</code> 是事件类型的集合。一般当发生事件时，<code>Event</code> 对象将作为参数传递给事件侦听器。
*/
//class laya.events.Event
var Event=(function(){
	function Event(){
		/**事件类型。*/
		//this.type=null;
		/**原生浏览器事件。*/
		//this.nativeEvent=null;
		/**事件目标触发对象。*/
		//this.target=null;
		/**事件当前冒泡对象。*/
		//this.currentTarget=null;
		/**@private */
		//this._stoped=false;
		/**分配给触摸点的唯一标识号（作为 int）。*/
		//this.touchId=0;
		/**键盘值*/
		//this.keyCode=0;
		/**滚轮滑动增量*/
		//this.delta=0;
	}

	__class(Event,'laya.events.Event');
	var __proto=Event.prototype;
	/**
	*设置事件数据。
	*@param type 事件类型。
	*@param currentTarget 事件目标触发对象。
	*@param target 事件当前冒泡对象。
	*@return 返回当前 Event 对象。
	*/
	__proto.setTo=function(type,currentTarget,target){
		this.type=type;
		this.currentTarget=currentTarget;
		this.target=target;
		return this;
	}

	/**
	*阻止对事件流中当前节点的后续节点中的所有事件侦听器进行处理。此方法不会影响当前节点 (currentTarget)中的任何事件侦听器。
	*/
	__proto.stopPropagation=function(){
		this._stoped=true;
	}

	/**鼠标在 Stage 上的 Y 轴坐标*/
	__getset(0,__proto,'stageY',function(){
		return Laya.stage.mouseY;
	});

	/**
	*包含按下或释放的键的字符代码值。字符代码值为英文键盘值。
	*/
	__getset(0,__proto,'charCode',function(){
		return this.nativeEvent.charCode;
	});

	/**
	*触摸点列表。
	*/
	__getset(0,__proto,'touches',function(){
		var arr=this.nativeEvent.touches;
		if (arr){
			var stage=Laya.stage;
			for (var i=0,n=arr.length;i < n;i++){
				var e=arr[i];
				var point=Point.TEMP;
				point.setTo(e.clientX,e.clientY);
				stage._canvasTransform.invertTransformPoint(point);
				stage.transform.invertTransformPoint(point);
				e.stageX=point.x;
				e.stageY=point.y;
			}
		}
		return arr;
	});

	/**
	*表示键在键盘上的位置。这对于区分在键盘上多次出现的键非常有用。<br>
	*例如，您可以根据此属性的值来区分左 Shift 键和右 Shift 键：左 Shift 键的值为 KeyLocation.LEFT，右 Shift 键的值为 KeyLocation.RIGHT。另一个示例是区分标准键盘 (KeyLocation.STANDARD)与数字键盘 (KeyLocation.NUM_PAD)上按下的数字键。
	*/
	__getset(0,__proto,'keyLocation',function(){
		return this.nativeEvent.location || this.nativeEvent.keyLocation;
	});

	/**
	*表示 Ctrl 键是处于活动状态 (true)还是非活动状态 (false)。
	*/
	__getset(0,__proto,'ctrlKey',function(){
		return this.nativeEvent.ctrlKey;
	});

	/**
	*表示 Alt 键是处于活动状态 (true)还是非活动状态 (false)。
	*/
	__getset(0,__proto,'altKey',function(){
		return this.nativeEvent.altKey;
	});

	/**
	*表示 Shift 键是处于活动状态 (true)还是非活动状态 (false)。
	*/
	__getset(0,__proto,'shiftKey',function(){
		return this.nativeEvent.shiftKey;
	});

	/**鼠标在 Stage 上的 X 轴坐标*/
	__getset(0,__proto,'stageX',function(){
		return Laya.stage.mouseX;
	});

	Event.EMPTY=new Event();
	Event.MOUSE_DOWN="mousedown";
	Event.MOUSE_UP="mouseup";
	Event.CLICK="click";
	Event.RIGHT_MOUSE_DOWN="rightmousedown";
	Event.RIGHT_MOUSE_UP="rightmouseup";
	Event.RIGHT_CLICK="rightclick";
	Event.MOUSE_MOVE="mousemove";
	Event.MOUSE_OVER="mouseover";
	Event.MOUSE_OUT="mouseout";
	Event.MOUSE_WHEEL="mousewheel";
	Event.ROLL_OVER="mouseover";
	Event.ROLL_OUT="mouseout";
	Event.DOUBLE_CLICK="doubleclick";
	Event.CHANGE="change";
	Event.CHANGED="changed";
	Event.RESIZE="resize";
	Event.ADDED="added";
	Event.REMOVED="removed";
	Event.DISPLAY="display";
	Event.UNDISPLAY="undisplay";
	Event.ERROR="error";
	Event.COMPLETE="complete";
	Event.LOADED="loaded";
	Event.PROGRESS="progress";
	Event.INPUT="input";
	Event.RENDER="render";
	Event.OPEN="open";
	Event.MESSAGE="message";
	Event.CLOSE="close";
	Event.KEY_DOWN="keydown";
	Event.KEY_PRESS="keypress";
	Event.KEY_UP="keyup";
	Event.FRAME="enterframe";
	Event.DRAG_START="dragstart";
	Event.DRAG_MOVE="dragmove";
	Event.DRAG_END="dragend";
	Event.ENTER="enter";
	Event.SELECT="select";
	Event.BLUR="blur";
	Event.FOCUS="focus";
	Event.VISIBILITY_CHANGE="visibilitychange";
	Event.FOCUS_CHANGE="focuschange";
	Event.PLAYED="played";
	Event.PAUSED="paused";
	Event.STOPPED="stopped";
	Event.START="start";
	Event.END="end";
	Event.ENABLE_CHANGED="enablechanged";
	Event.ACTIVE_IN_HIERARCHY_CHANGED="activeinhierarchychanged";
	Event.COMPONENT_ADDED="componentadded";
	Event.COMPONENT_REMOVED="componentremoved";
	Event.LAYER_CHANGED="layerchanged";
	Event.HIERARCHY_LOADED="hierarchyloaded";
	Event.RECOVERING="recovering";
	Event.RECOVERED="recovered";
	Event.RELEASED="released";
	Event.LINK="link";
	Event.LABEL="label";
	Event.FULL_SCREEN_CHANGE="fullscreenchange";
	Event.DEVICE_LOST="devicelost";
	Event.MESH_CHANGED="meshchanged";
	Event.MATERIAL_CHANGED="materialchanged";
	Event.RENDERQUEUE_CHANGED="renderqueuechanged";
	Event.WORLDMATRIX_NEEDCHANGE="worldmatrixneedchanged";
	Event.ANIMATION_CHANGED="animationchanged";
	return Event;
})()


	//file:///E:/git/layaair-master/core/src/laya/events/KeyBoardManager.as=======199.999919/199.999919
/**
*<p><code>KeyBoardManager</code> 是键盘事件管理类。该类从浏览器中接收键盘事件，并派发该事件。</p>
*<p>派发事件时若 Stage.focus 为空则只从 Stage 上派发该事件，否则将从 Stage.focus 对象开始一直冒泡派发该事件。所以在 Laya.stage 上监听键盘事件一定能够收到，如果在其他地方监听，则必须处在Stage.focus的冒泡链上才能收到该事件。</p>
*<p>用户可以通过代码 Laya.stage.focus=someNode 的方式来设置focus对象。</p>
*<p>用户可统一的根据事件对象中 e.keyCode 来判断按键类型，该属性兼容了不同浏览器的实现。</p>
*/
//class laya.events.KeyBoardManager
var KeyBoardManager=(function(){
	function KeyBoardManager(){}
	__class(KeyBoardManager,'laya.events.KeyBoardManager');
	KeyBoardManager.__init__=function(){
		KeyBoardManager._addEvent("keydown");
		KeyBoardManager._addEvent("keypress");
		KeyBoardManager._addEvent("keyup");
	}

	KeyBoardManager._addEvent=function(type){
		Browser.document.addEventListener(type,function(e){
			laya.events.KeyBoardManager._dispatch(e,type);
		},true);
	}

	KeyBoardManager._dispatch=function(e,type){
		if (!KeyBoardManager.enabled)return;
		KeyBoardManager._event._stoped=false;
		KeyBoardManager._event.nativeEvent=e;
		KeyBoardManager._event.keyCode=e.keyCode || e.which || e.charCode;
		if (type==="keydown")KeyBoardManager._pressKeys[KeyBoardManager._event.keyCode]=true;
		else if (type==="keyup")KeyBoardManager._pressKeys[KeyBoardManager._event.keyCode]=null;
		var target=(Laya.stage.focus && (Laya.stage.focus.event !=null)&& Laya.stage.focus.displayedInStage)? Laya.stage.focus :Laya.stage;
		var ct=target;
		while (ct){
			ct.event(type,KeyBoardManager._event.setTo(type,ct,target));
			ct=ct.parent;
		}
	}

	KeyBoardManager.hasKeyDown=function(key){
		return KeyBoardManager._pressKeys[key];
	}

	KeyBoardManager._pressKeys={};
	KeyBoardManager.enabled=true;
	__static(KeyBoardManager,
	['_event',function(){return this._event=new Event();}
	]);
	return KeyBoardManager;
})()


	//file:///E:/git/layaair-master/core/src/laya/events/MouseManager.as=======199.999917/199.999917
/**
*<p><code>MouseManager</code> 是鼠标、触摸交互管理器。</p>
*<p>鼠标事件流包括捕获阶段、目标阶段、冒泡阶段。<br/>
*捕获阶段：此阶段引擎会从stage开始递归检测stage及其子对象，直到找到命中的目标对象或者未命中任何对象；<br/>
*目标阶段：找到命中的目标对象；<br/>
*冒泡阶段：事件离开目标对象，按节点层级向上逐层通知，直到到达舞台的过程。</p>
*/
//class laya.events.MouseManager
var MouseManager=(function(){
	function MouseManager(){
		/**canvas 上的鼠标X坐标。*/
		this.mouseX=0;
		/**canvas 上的鼠标Y坐标。*/
		this.mouseY=0;
		/**是否禁用除 stage 以外的鼠标事件检测。*/
		this.disableMouseEvent=false;
		/**鼠标按下的时间。单位为毫秒。*/
		this.mouseDownTime=0;
		/**鼠标移动精度。*/
		this.mouseMoveAccuracy=2;
		this._stage=null;
		this._target=null;
		this._lastMoveTimer=0;
		this._isLeftMouse=false;
		this._eventList=[];
		this._touchIDs={};
		this._id=1;
		this._tTouchID=0;
		this._event=new Event();
		this._matrix=new Matrix();
		this._point=new Point();
		this._rect=new Rectangle();
		this._prePoint=new Point();
		this._curTouchID=NaN;
	}

	__class(MouseManager,'laya.events.MouseManager');
	var __proto=MouseManager.prototype;
	/**
	*@private
	*初始化。
	*/
	__proto.__init__=function(stage,canvas){
		this._stage=stage;
		var _this=this;
		var list=this._eventList;
		canvas.oncontextmenu=function (e){
			if (MouseManager.enabled)return false;
		}
		canvas.addEventListener('mousedown',function(e){
			if (MouseManager.enabled){
				if (!Browser.onIE)e.preventDefault();
				list.push(e);
				_this.mouseDownTime=Browser.now();
			}
		});
		canvas.addEventListener('mouseup',function(e){
			if (MouseManager.enabled){
				e.preventDefault();
				list.push(e);
				_this.mouseDownTime=-Browser.now();
			}
		},true);
		canvas.addEventListener('mousemove',function(e){
			if (MouseManager.enabled){
				e.preventDefault();
				var now=Browser.now();
				if (now-_this._lastMoveTimer < 10)return;
				_this._lastMoveTimer=now;
				list.push(e);
			}
		},true);
		canvas.addEventListener("mouseout",function(e){
			if (MouseManager.enabled)list.push(e);
		})
		canvas.addEventListener("mouseover",function(e){
			if (MouseManager.enabled)list.push(e);
		})
		canvas.addEventListener("touchstart",function(e){
			if (MouseManager.enabled){
				list.push(e);
				if (!Input.isInputting)e.preventDefault();
				_this.mouseDownTime=Browser.now();
			}
		});
		canvas.addEventListener("touchend",function(e){
			if (MouseManager.enabled){
				if (!Input.isInputting)e.preventDefault();
				list.push(e);
				_this.mouseDownTime=-Browser.now();
			}
		},true);
		canvas.addEventListener("touchmove",function(e){
			if (MouseManager.enabled){
				e.preventDefault();
				list.push(e);
			}
		},true);
		canvas.addEventListener("touchcancel",function(e){
			if (MouseManager.enabled){
				e.preventDefault();
				list.push(e);
			}
		},true);
		canvas.addEventListener('mousewheel',function(e){
			if (MouseManager.enabled)list.push(e);
		});
		canvas.addEventListener('DOMMouseScroll',function(e){
			if (MouseManager.enabled)list.push(e);
		});
	}

	__proto.initEvent=function(e,nativeEvent){
		var _this=this;
		_this._event._stoped=false;
		_this._event.nativeEvent=nativeEvent || e;
		_this._target=null;
		this._point.setTo(e.pageX || e.clientX,e.pageY || e.clientY);
		this._stage._canvasTransform.invertTransformPoint(this._point);
		_this.mouseX=this._point.x;
		_this.mouseY=this._point.y;
		_this._event.touchId=e.identifier || 0;
		this._tTouchID=_this._event.touchId;
		var evt;
		evt=TouchManager.I._event;
		evt._stoped=false;
		evt.nativeEvent=_this._event.nativeEvent;
		evt.touchId=_this._event.touchId;
	}

	__proto.checkMouseWheel=function(e){
		this._event.delta=e.wheelDelta ? e.wheelDelta *0.025 :-e.detail;
		var _lastOvers=TouchManager.I.getLastOvers();
		for (var i=0,n=_lastOvers.length;i < n;i++){
			var ele=_lastOvers[i];
			ele.event("mousewheel",this._event.setTo("mousewheel",ele,this._target));
		}
	}

	// _stage.event(Event.MOUSE_WHEEL,_event.setTo(Event.MOUSE_WHEEL,_stage,_target));
	__proto.onMouseMove=function(ele){
		TouchManager.I.onMouseMove(ele,this._tTouchID);
	}

	__proto.onMouseDown=function(ele){
		if (Input.isInputting && Laya.stage.focus && Laya.stage.focus["focus"] && !Laya.stage.focus.contains(this._target)){
			var pre_input=Laya.stage.focus['_tf'] || Laya.stage.focus;
			var new_input=ele['_tf'] || ele;
			if ((new_input instanceof laya.display.Input )&& new_input.multiline==pre_input.multiline)
				pre_input['_focusOut']();
			else
			pre_input.focus=false;
		}
		TouchManager.I.onMouseDown(ele,this._tTouchID,this._isLeftMouse);
	}

	__proto.onMouseUp=function(ele){
		TouchManager.I.onMouseUp(ele,this._tTouchID,this._isLeftMouse);
	}

	__proto.check=function(sp,mouseX,mouseY,callBack){
		this._point.setTo(mouseX,mouseY);
		sp.fromParentPoint(this._point);
		mouseX=this._point.x;
		mouseY=this._point.y;
		var scrollRect=sp._style.scrollRect;
		if (scrollRect){
			this._rect.setTo(scrollRect.x,scrollRect.y,scrollRect.width,scrollRect.height);
			if (!this._rect.contains(mouseX,mouseY))return false;
		}
		if (!this.disableMouseEvent){
			if (sp.hitTestPrior && !sp.mouseThrough && !this.hitTest(sp,mouseX,mouseY)){
				return false;
			}
			for (var i=sp._children.length-1;i >-1;i--){
				var child=sp._children[i];
				if (!child.destroyed && child._mouseState > 1 && child._visible){
					if (this.check(child,mouseX,mouseY,callBack))return true;
				}
			}
		};
		var isHit=(sp.hitTestPrior && !sp.mouseThrough && !this.disableMouseEvent)? true :this.hitTest(sp,mouseX,mouseY);
		if (isHit){
			this._target=sp;
			callBack.call(this,sp);
			}else if (callBack===this.onMouseUp && sp===this._stage){
			this._target=this._stage;
			callBack.call(this,this._target);
		}
		return isHit;
	}

	__proto.hitTest=function(sp,mouseX,mouseY){
		var isHit=false;
		if (sp.scrollRect){
			mouseX-=sp._style.scrollRect.x;
			mouseY-=sp._style.scrollRect.y;
		};
		var hitArea=sp._style.hitArea;
		if (hitArea && hitArea.isHitGraphic){
			return hitArea.isHit(mouseX,mouseY);
		}
		if (sp.width > 0 && sp.height > 0 || sp.mouseThrough || hitArea){
			if (!sp.mouseThrough){
				isHit=(hitArea ? hitArea :this._rect.setTo(0,0,sp.width,sp.height)).contains(mouseX,mouseY);
				}else {
				isHit=sp.getGraphicBounds().contains(mouseX,mouseY);
			}
		}
		return isHit;
	}

	/**
	*执行事件处理。
	*/
	__proto.runEvent=function(){
		var len=this._eventList.length;
		if (!len)return;
		var _this=this;
		var i=0;
		while (i < len){
			var evt=this._eventList[i];
			if (evt.type!=='mousemove')this._prePoint.x=this._prePoint.y=-1000000;
			switch (evt.type){
				case 'mousedown':
					this._touchIDs[0]=this._id++;
					if (!MouseManager._isTouchRespond){
						_this._isLeftMouse=evt.button===0;
						_this.initEvent(evt);
						_this.check(_this._stage,_this.mouseX,_this.mouseY,_this.onMouseDown);
					}else
					MouseManager._isTouchRespond=false;
					break ;
				case 'mouseup':
					_this._isLeftMouse=evt.button===0;
					_this.initEvent(evt);
					_this.check(_this._stage,_this.mouseX,_this.mouseY,_this.onMouseUp);
					break ;
				case 'mousemove':
					if ((Math.abs(this._prePoint.x-evt.clientX)+Math.abs(this._prePoint.y-evt.clientY))>=this.mouseMoveAccuracy){
						this._prePoint.x=evt.clientX;
						this._prePoint.y=evt.clientY;
						_this.initEvent(evt);
						_this.check(_this._stage,_this.mouseX,_this.mouseY,_this.onMouseMove);
					}
					break ;
				case "touchstart":
					MouseManager._isTouchRespond=true;
					_this._isLeftMouse=true;
					var touches=evt.changedTouches;
					for (var j=0,n=touches.length;j < n;j++){
						var touch=touches[j];
						if (MouseManager.multiTouchEnabled || isNaN(this._curTouchID)){
							this._curTouchID=touch.identifier;
							if (this._id % 200===0)this._touchIDs={};
							this._touchIDs[touch.identifier]=this._id++;
							_this.initEvent(touch,evt);
							_this.check(_this._stage,_this.mouseX,_this.mouseY,_this.onMouseDown);
						}
					}
					break ;
				case "touchend":
				case "touchcancel":
					MouseManager._isTouchRespond=true;
					_this._isLeftMouse=true;
					var touchends=evt.changedTouches;
					for (j=0,n=touchends.length;j < n;j++){
						touch=touchends[j];
						if (MouseManager.multiTouchEnabled || touch.identifier==this._curTouchID){
							this._curTouchID=NaN;
							_this.initEvent(touch,evt);
							var isChecked=false;
							isChecked=_this.check(_this._stage,_this.mouseX,_this.mouseY,_this.onMouseUp);
							if (!isChecked){
								_this.onMouseUp(null);
							}
						}
					}
					break ;
				case "touchmove":;
					var touchemoves=evt.changedTouches;
					for (j=0,n=touchemoves.length;j < n;j++){
						touch=touchemoves[j];
						if (MouseManager.multiTouchEnabled || touch.identifier==this._curTouchID){
							_this.initEvent(touch,evt);
							_this.check(_this._stage,_this.mouseX,_this.mouseY,_this.onMouseMove);
						}
					}
					break ;
				case "wheel":
				case "mousewheel":
				case "DOMMouseScroll":
					_this.checkMouseWheel(evt);
					break ;
				case "mouseout":
					_this._stage.event("mouseout",_this._event.setTo("mouseout",_this._stage,_this._stage));
					break ;
				case "mouseover":
					_this._stage.event("mouseover",_this._event.setTo("mouseover",_this._stage,_this._stage));
					break ;
				}
			i++;
		}
		this._eventList.length=0;
	}

	MouseManager.enabled=true;
	MouseManager.multiTouchEnabled=true;
	MouseManager._isTouchRespond=false;
	__static(MouseManager,
	['instance',function(){return this.instance=new MouseManager();}
	]);
	return MouseManager;
})()


	//file:///E:/git/layaair-master/core/src/laya/events/TouchManager.as=======199.999916/199.999916
/**
*@private
*Touch事件管理类，处理多点触控下的鼠标事件
*/
//class laya.events.TouchManager
var TouchManager=(function(){
	function TouchManager(){
		/**
		*当前over的touch表
		*/
		this.preOvers=[];
		/**
		*当前down的touch表
		*/
		this.preDowns=[];
		this.preRightDowns=[];
		/**
		*是否启用
		*/
		this.enable=true;
		this._lastClickTime=0;
		this._event=new Event();
	}

	__class(TouchManager,'laya.events.TouchManager');
	var __proto=TouchManager.prototype;
	/**
	*从touch表里查找对应touchID的数据
	*@param touchID touch ID
	*@param arr touch表
	*@return
	*
	*/
	__proto.getTouchFromArr=function(touchID,arr){
		var i=0,len=0;
		len=arr.length;
		var tTouchO;
		for (i=0;i < len;i++){
			tTouchO=arr[i];
			if (tTouchO.id==touchID){
				return tTouchO;
			}
		}
		return null;
	}

	/**
	*从touch表里移除一个元素
	*@param touchID touch ID
	*@param arr touch表
	*
	*/
	__proto.removeTouchFromArr=function(touchID,arr){
		var i=0;
		for (i=arr.length-1;i >=0;i--){
			if (arr[i].id==touchID){
				arr.splice(i,1);
			}
		}
	}

	/**
	*创建一个touch数据
	*@param ele 当前的根节点
	*@param touchID touchID
	*@return
	*
	*/
	__proto.createTouchO=function(ele,touchID){
		var rst;
		rst=Pool.getItem("TouchData")|| {};
		rst.id=touchID;
		rst.tar=ele;
		return rst;
	}

	/**
	*处理touchStart
	*@param ele 根节点
	*@param touchID touchID
	*@param isLeft （可选）是否为左键
	*/
	__proto.onMouseDown=function(ele,touchID,isLeft){
		(isLeft===void 0)&& (isLeft=false);
		if (!this.enable)
			return;
		var preO;
		var tO;
		var arrs;
		preO=this.getTouchFromArr(touchID,this.preOvers);
		arrs=this.getEles(ele,null,TouchManager._tEleArr);
		if (!preO){
			tO=this.createTouchO(ele,touchID);
			this.preOvers.push(tO);
			}else {
			preO.tar=ele;
		}
		if (Browser.onMobile)
			this.sendEvents(arrs,"mouseover",touchID);
		var preDowns;
		preDowns=isLeft ? this.preDowns :this.preRightDowns;
		preO=this.getTouchFromArr(touchID,preDowns);
		if (!preO){
			tO=this.createTouchO(ele,touchID);
			preDowns.push(tO);
			}else {
			preO.tar=ele;
		}
		this.sendEvents(arrs,isLeft ? "mousedown" :"rightmousedown",touchID);
	}

	/**
	*派发事件。
	*@param eles 对象列表。
	*@param type 事件类型。
	*@param touchID （可选）touchID，默认为0。
	*/
	__proto.sendEvents=function(eles,type,touchID){
		(touchID===void 0)&& (touchID=0);
		var i=0,len=0;
		len=eles.length;
		this._event._stoped=false;
		var _target;
		_target=eles[0];
		var tE;
		for (i=0;i < len;i++){
			tE=eles[i];
			if (tE.destroyed)return;
			tE.event(type,this._event.setTo(type,tE,_target));
			if (this._event._stoped)
				break ;
		}
	}

	/**
	*获取对象列表。
	*@param start 起始节点。
	*@param end 结束节点。
	*@param rst 返回值。如果此值不为空，则将其赋值为计算结果，从而避免创建新数组；如果此值为空，则创建新数组返回。
	*@return Array 返回节点列表。
	*/
	__proto.getEles=function(start,end,rst){
		if (!rst){
			rst=[];
			}else {
			rst.length=0;
		}
		while (start && start !=end){
			rst.push(start);
			start=start._parent;
		}
		return rst;
	}

	/**
	*touchMove时处理out事件和over时间。
	*@param eleNew 新的根节点。
	*@param elePre 旧的根节点。
	*@param touchID （可选）touchID，默认为0。
	*/
	__proto.checkMouseOutAndOverOfMove=function(eleNew,elePre,touchID){
		(touchID===void 0)&& (touchID=0);
		if (elePre==eleNew)
			return;
		var tar;
		var arrs;
		var i=0,len=0;
		if (elePre.contains(eleNew)){
			arrs=this.getEles(eleNew,elePre,TouchManager._tEleArr);
			this.sendEvents(arrs,"mouseover",touchID);
			}else if (eleNew.contains(elePre)){
			arrs=this.getEles(elePre,eleNew,TouchManager._tEleArr);
			this.sendEvents(arrs,"mouseout",touchID);
			}else {
			arrs=TouchManager._tEleArr;
			arrs.length=0;
			var oldArr;
			oldArr=this.getEles(elePre,null,TouchManager._oldArr);
			var newArr;
			newArr=this.getEles(eleNew,null,TouchManager._newArr);
			len=oldArr.length;
			var tIndex=0;
			for (i=0;i < len;i++){
				tar=oldArr[i];
				tIndex=newArr.indexOf(tar);
				if (tIndex >=0){
					newArr.splice(tIndex,newArr.length-tIndex);
					break ;
					}else {
					arrs.push(tar);
				}
			}
			if (arrs.length > 0){
				this.sendEvents(arrs,"mouseout",touchID);
			}
			if (newArr.length > 0){
				this.sendEvents(newArr,"mouseover",touchID);
			}
		}
	}

	/**
	*处理TouchMove事件
	*@param ele 根节点
	*@param touchID touchID
	*
	*/
	__proto.onMouseMove=function(ele,touchID){
		if (!this.enable)
			return;
		var preO;
		preO=this.getTouchFromArr(touchID,this.preOvers);
		var arrs;
		var tO;
		if (!preO){
			arrs=this.getEles(ele,null,TouchManager._tEleArr);
			this.sendEvents(arrs,"mouseover",touchID);
			this.preOvers.push(this.createTouchO(ele,touchID));
			}else {
			this.checkMouseOutAndOverOfMove(ele,preO.tar);
			preO.tar=ele;
			arrs=this.getEles(ele,null,TouchManager._tEleArr);
		}
		this.sendEvents(arrs,"mousemove",touchID);
	}

	__proto.getLastOvers=function(){
		TouchManager._tEleArr.length=0;
		if (this.preOvers.length > 0 && this.preOvers[0].tar){
			return this.getEles(this.preOvers[0].tar,null,TouchManager._tEleArr);
		}
		TouchManager._tEleArr.push(Laya.stage);
		return TouchManager._tEleArr;
	}

	/**
	*处理TouchEnd事件
	*@param ele 根节点
	*@param touchID touchID
	*@param isLeft 是否为左键
	*/
	__proto.onMouseUp=function(ele,touchID,isLeft){
		(isLeft===void 0)&& (isLeft=false);
		if (!this.enable)
			return;
		var preO;
		var tO;
		var arrs;
		var oldArr;
		var i=0,len=0;
		var tar;
		var sendArr;
		var onMobile=Browser.onMobile;
		arrs=this.getEles(ele,null,TouchManager._tEleArr);
		this.sendEvents(arrs,isLeft ? "mouseup" :"rightmouseup",touchID);
		var preDowns;
		preDowns=isLeft ? this.preDowns :this.preRightDowns;
		preO=this.getTouchFromArr(touchID,preDowns);
		if (!preO){
			}else {
			var isDouble=false;
			var now=Browser.now();
			isDouble=now-this._lastClickTime < 300;
			this._lastClickTime=now;
			if (ele==preO.tar){
				sendArr=arrs;
				}else {
				oldArr=this.getEles(preO.tar,null,TouchManager._oldArr);
				sendArr=TouchManager._newArr;
				sendArr.length=0;
				len=oldArr.length;
				for (i=0;i < len;i++){
					tar=oldArr[i];
					if (arrs.indexOf(tar)>=0){
						sendArr.push(tar);
					}
				}
			}
			if (sendArr.length > 0){
				this.sendEvents(sendArr,isLeft ? "click" :"rightclick",touchID);
			}
			if (isLeft && isDouble){
				this.sendEvents(sendArr,"doubleclick",touchID);
			}
			this.removeTouchFromArr(touchID,preDowns);
			preO.tar=null;
			Pool.recover("TouchData",preO);
		}
		preO=this.getTouchFromArr(touchID,this.preOvers);
		if (!preO){
			}else {
			if (onMobile){
				sendArr=this.getEles(preO.tar,null,sendArr);
				if (sendArr && sendArr.length > 0){
					this.sendEvents(sendArr,"mouseout",touchID);
				}
				this.removeTouchFromArr(touchID,this.preOvers);
				preO.tar=null;
				Pool.recover("TouchData",preO);
			}
		}
	}

	TouchManager._oldArr=[];
	TouchManager._newArr=[];
	TouchManager._tEleArr=[];
	__static(TouchManager,
	['I',function(){return this.I=new TouchManager();}
	]);
	return TouchManager;
})()


	//file:///E:/git/layaair-master/core/src/laya/filters/Filter.as=======199.999914/199.999914
/**
*<code>Filter</code> 是滤镜基类。
*/
//class laya.filters.Filter
var Filter=(function(){
	function Filter(){
		/**@private */
		this._action=null;
	}

	__class(Filter,'laya.filters.Filter');
	var __proto=Filter.prototype;
	Laya.imps(__proto,{"laya.filters.IFilter":true})
	/**@private 滤镜类型。*/
	__getset(0,__proto,'type',function(){return-1});
	/**@private 滤镜动作。*/
	__getset(0,__proto,'action',function(){return this._action });
	Filter.BLUR=0x10;
	Filter.COLOR=0x20;
	Filter.GLOW=0x08;
	return Filter;
})()


	//file:///E:/git/layaair-master/core/src/laya/filters/ColorFilterAction.as=======199.999913/199.999913
/**
*@private
*<code>ColorFilterAction</code> 是一个颜色滤镜应用类。
*/
//class laya.filters.ColorFilterAction
var ColorFilterAction=(function(){
	function ColorFilterAction(){
		this.data=null;
	}

	__class(ColorFilterAction,'laya.filters.ColorFilterAction');
	var __proto=ColorFilterAction.prototype;
	Laya.imps(__proto,{"laya.filters.IFilterAction":true})
	/**
	*给指定的对象应用颜色滤镜。
	*@param srcCanvas 需要应用画布对象。
	*@return 应用了滤镜后的画布对象。
	*/
	__proto.apply=function(srcCanvas){
		var canvas=srcCanvas.canvas;
		var ctx=canvas.context;
		if (canvas.width==0 || canvas.height==0)return canvas;
		var imgdata=ctx.getImageData(0,0,canvas.width,canvas.height);
		var data=imgdata.data;
		var nData;
		for (var i=0,n=data.length;i < n;i+=4){
			nData=this.getColor(data[i],data[i+1],data[i+2],data[i+3]);
			if (data[i+3]==0)continue ;
			data[i]=nData[0];
			data[i+1]=nData[1];
			data[i+2]=nData[2];
			data[i+3]=nData[3];
		}
		ctx.putImageData(imgdata,0,0);
		return srcCanvas;
	}

	__proto.getColor=function(red,green,blue,alpha){
		var rst=[];
		if (this.data._mat && this.data._alpha){
			var mat=this.data._mat;
			var tempAlpha=this.data._alpha;
			rst[0]=mat[0] *red+mat[1] *green+mat[2] *blue+mat[3] *alpha+tempAlpha[0];
			rst[1]=mat[4] *red+mat[5] *green+mat[6] *blue+mat[7] *alpha+tempAlpha[1];
			rst[2]=mat[8] *red+mat[9] *green+mat[10] *blue+mat[11] *alpha+tempAlpha[2];
			rst[3]=mat[12] *red+mat[13] *green+mat[14] *blue+mat[15] *alpha+tempAlpha[3];
		}
		return rst;
	}

	return ColorFilterAction;
})()


	//file:///E:/git/layaair-master/core/src/laya/maths/Bezier.as=======199.999910/199.999910
/**
*@private
*计算贝塞尔曲线的工具类。
*/
//class laya.maths.Bezier
var Bezier=(function(){
	function Bezier(){
		/**@private */
		this._controlPoints=[new Point(),new Point(),new Point()];
		this._calFun=this.getPoint2;
	}

	__class(Bezier,'laya.maths.Bezier');
	var __proto=Bezier.prototype;
	/**@private */
	__proto._switchPoint=function(x,y){
		var tPoint=this._controlPoints.shift();
		tPoint.setTo(x,y);
		this._controlPoints.push(tPoint);
	}

	/**
	*计算二次贝塞尔点。
	*/
	__proto.getPoint2=function(t,rst){
		var p1=this._controlPoints[0];
		var p2=this._controlPoints[1];
		var p3=this._controlPoints[2];
		var lineX=Math.pow((1-t),2)*p1.x+2 *t *(1-t)*p2.x+Math.pow(t,2)*p3.x;
		var lineY=Math.pow((1-t),2)*p1.y+2 *t *(1-t)*p2.y+Math.pow(t,2)*p3.y;
		rst.push(lineX,lineY);
	}

	/**
	*计算三次贝塞尔点
	*/
	__proto.getPoint3=function(t,rst){
		var p1=this._controlPoints[0];
		var p2=this._controlPoints[1];
		var p3=this._controlPoints[2];
		var p4=this._controlPoints[3];
		var lineX=Math.pow((1-t),3)*p1.x+3 *p2.x *t *(1-t)*(1-t)+3 *p3.x *t *t *(1-t)+p4.x *Math.pow(t,3);
		var lineY=Math.pow((1-t),3)*p1.y+3 *p2.y *t *(1-t)*(1-t)+3 *p3.y *t *t *(1-t)+p4.y *Math.pow(t,3);
		rst.push(lineX,lineY);
	}

	/**
	*计算贝塞尔点序列
	*/
	__proto.insertPoints=function(count,rst){
		var i=NaN;
		count=count > 0 ? count :5;
		var dLen=NaN;
		dLen=1 / count;
		for (i=0;i <=1;i+=dLen){
			this._calFun(i,rst);
		}
	}

	/**
	*获取贝塞尔曲线上的点。
	*@param pList 控制点[x0,y0,x1,y1...]
	*@param inSertCount 每次曲线的插值数量
	*/
	__proto.getBezierPoints=function(pList,inSertCount,count){
		(inSertCount===void 0)&& (inSertCount=5);
		(count===void 0)&& (count=2);
		var i=0,len=0;
		len=pList.length;
		if (len < (count+1)*2)return [];
		var rst=[];
		switch (count){
			case 2:
				this._calFun=this.getPoint2;
				break ;
			case 3:
				this._calFun=this.getPoint3;
				break ;
			default :
				return [];
			}
		while (this._controlPoints.length <=count){
			this._controlPoints.push(Point.create());
		}
		for (i=0;i < count *2;i+=2){
			this._switchPoint(pList[i],pList[i+1]);
		}
		for (i=count *2;i < len;i+=2){
			this._switchPoint(pList[i],pList[i+1]);
			if ((i / 2)% count==0)this.insertPoints(inSertCount,rst);
		}
		return rst;
	}

	__static(Bezier,
	['I',function(){return this.I=new Bezier();}
	]);
	return Bezier;
})()


	//file:///E:/git/layaair-master/core/src/laya/maths/GrahamScan.as=======199.999909/199.999909
/**
*@private
*凸包算法。
*/
//class laya.maths.GrahamScan
var GrahamScan=(function(){
	function GrahamScan(){}
	__class(GrahamScan,'laya.maths.GrahamScan');
	GrahamScan.multiply=function(p1,p2,p0){
		return ((p1.x-p0.x)*(p2.y-p0.y)-(p2.x-p0.x)*(p1.y-p0.y));
	}

	GrahamScan.dis=function(p1,p2){
		return (p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y);
	}

	GrahamScan._getPoints=function(count,tempUse,rst){
		(tempUse===void 0)&& (tempUse=false);
		if (!GrahamScan._mPointList)GrahamScan._mPointList=[];
		while (GrahamScan._mPointList.length < count)GrahamScan._mPointList.push(new Point());
		if (!rst)rst=[];
		rst.length=0;
		if (tempUse){
			GrahamScan.getFrom(rst,GrahamScan._mPointList,count);
			}else {
			GrahamScan.getFromR(rst,GrahamScan._mPointList,count);
		}
		return rst;
	}

	GrahamScan.getFrom=function(rst,src,count){
		var i=0;
		for (i=0;i < count;i++){
			rst.push(src[i]);
		}
		return rst;
	}

	GrahamScan.getFromR=function(rst,src,count){
		var i=0;
		for (i=0;i < count;i++){
			rst.push(src.pop());
		}
		return rst;
	}

	GrahamScan.pListToPointList=function(pList,tempUse){
		(tempUse===void 0)&& (tempUse=false);
		var i=0,len=pList.length / 2,rst=GrahamScan._getPoints(len,tempUse,GrahamScan._tempPointList);
		for (i=0;i < len;i++){
			rst[i].setTo(pList[i+i],pList[i+i+1]);
		}
		return rst;
	}

	GrahamScan.pointListToPlist=function(pointList){
		var i=0,len=pointList.length,rst=GrahamScan._temPList,tPoint;
		rst.length=0;
		for (i=0;i < len;i++){
			tPoint=pointList[i];
			rst.push(tPoint.x,tPoint.y);
		}
		return rst;
	}

	GrahamScan.scanPList=function(pList){
		return Utils.copyArray(pList,GrahamScan.pointListToPlist(GrahamScan.scan(GrahamScan.pListToPointList(pList,true))));
	}

	GrahamScan.scan=function(PointSet){
		var i=0,j=0,k=0,top=2,tmp,n=PointSet.length,ch;
		var _tmpDic={};
		var key;
		ch=GrahamScan._temArr;
		ch.length=0;
		n=PointSet.length;
		for (i=n-1;i >=0;i--){
			tmp=PointSet[i];
			key=tmp.x+"_"+tmp.y;
			if (!_tmpDic.hasOwnProperty(key)){
				_tmpDic[key]=true;
				ch.push(tmp);
			}
		}
		n=ch.length;
		Utils.copyArray(PointSet,ch);
		for (i=1;i < n;i++)
		if ((PointSet[i].y < PointSet[k].y)|| ((PointSet[i].y==PointSet[k].y)&& (PointSet[i].x < PointSet[k].x)))
			k=i;
		tmp=PointSet[0];
		PointSet[0]=PointSet[k];
		PointSet[k]=tmp;
		for (i=1;i < n-1;i++){
			k=i;
			for (j=i+1;j < n;j++)
			if ((GrahamScan.multiply(PointSet[j],PointSet[k],PointSet[0])> 0)|| ((GrahamScan.multiply(PointSet[j],PointSet[k],PointSet[0])==0)&& (GrahamScan.dis(PointSet[0],PointSet[j])< GrahamScan.dis(PointSet[0],PointSet[k]))))
				k=j;
			tmp=PointSet[i];
			PointSet[i]=PointSet[k];
			PointSet[k]=tmp;
		}
		ch=GrahamScan._temArr;
		ch.length=0;
		if (PointSet.length < 3){
			return Utils.copyArray(ch,PointSet);
		}
		ch.push(PointSet[0],PointSet[1],PointSet[2]);
		for (i=3;i < n;i++){
			while (ch.length >=2 && GrahamScan.multiply(PointSet[i],ch[ch.length-1],ch[ch.length-2])>=0)ch.pop();
			PointSet[i] && ch.push(PointSet[i]);
		}
		return ch;
	}

	GrahamScan._mPointList=null;
	GrahamScan._tempPointList=[];
	GrahamScan._temPList=[];
	GrahamScan._temArr=[];
	return GrahamScan;
})()


	//file:///E:/git/layaair-master/core/src/laya/maths/Matrix.as=======199.999907/199.999907
/**
*<p> <code>Matrix</code> 类表示一个转换矩阵，它确定如何将点从一个坐标空间映射到另一个坐标空间。</p>
*<p>您可以对一个显示对象执行不同的图形转换，方法是设置 Matrix 对象的属性，将该 Matrix 对象应用于 Transform 对象的 matrix 属性，然后应用该 Transform 对象作为显示对象的 transform 属性。这些转换函数包括平移（x 和 y 重新定位）、旋转、缩放和倾斜。</p>
*/
//class laya.maths.Matrix
var Matrix=(function(){
	function Matrix(a,b,c,d,tx,ty,nums){
		/**缩放或旋转图像时影响像素沿 x 轴定位的值。*/
		//this.a=NaN;
		/**旋转或倾斜图像时影响像素沿 y 轴定位的值。*/
		//this.b=NaN;
		/**旋转或倾斜图像时影响像素沿 x 轴定位的值。*/
		//this.c=NaN;
		/**缩放或旋转图像时影响像素沿 y 轴定位的值。*/
		//this.d=NaN;
		/**沿 x 轴平移每个点的距离。*/
		//this.tx=NaN;
		/**沿 y 轴平移每个点的距离。*/
		//this.ty=NaN;
		/**@private 是否有旋转缩放操作*/
		this._bTransform=false;
		(a===void 0)&& (a=1);
		(b===void 0)&& (b=0);
		(c===void 0)&& (c=0);
		(d===void 0)&& (d=1);
		(tx===void 0)&& (tx=0);
		(ty===void 0)&& (ty=0);
		(nums===void 0)&& (nums=0);
		if (Matrix._createFun!=null){
			return Matrix._createFun(a,b,c,d,tx,ty,nums);
		}
		this.a=a;
		this.b=b;
		this.c=c;
		this.d=d;
		this.tx=tx;
		this.ty=ty;
		this._checkTransform();
	}

	__class(Matrix,'laya.maths.Matrix');
	var __proto=Matrix.prototype;
	/**
	*将本矩阵设置为单位矩阵。
	*@return 返回当前矩形。
	*/
	__proto.identity=function(){
		this.a=this.d=1;
		this.b=this.tx=this.ty=this.c=0;
		this._bTransform=false;
		return this;
	}

	/**@private */
	__proto._checkTransform=function(){
		return this._bTransform=(this.a!==1 || this.b!==0 || this.c!==0 || this.d!==1);
	}

	/**
	*设置沿 x 、y 轴平移每个点的距离。
	*@param x 沿 x 轴平移每个点的距离。
	*@param y 沿 y 轴平移每个点的距离。
	*@return 返回对象本身
	*/
	__proto.setTranslate=function(x,y){
		this.tx=x;
		this.ty=y;
		return this;
	}

	/**
	*沿 x 和 y 轴平移矩阵，平移的变化量由 x 和 y 参数指定。
	*@param x 沿 x 轴向右移动的量（以像素为单位）。
	*@param y 沿 y 轴向下移动的量（以像素为单位）。
	*@return 返回此矩形对象。
	*/
	__proto.translate=function(x,y){
		this.tx+=x;
		this.ty+=y;
		return this;
	}

	/**
	*对矩阵应用缩放转换。
	*@param x 用于沿 x 轴缩放对象的乘数。
	*@param y 用于沿 y 轴缩放对象的乘数。
	*@return 返回矩阵对象本身
	*/
	__proto.scale=function(x,y){
		this.a *=x;
		this.d *=y;
		this.c *=x;
		this.b *=y;
		this.tx *=x;
		this.ty *=y;
		this._bTransform=true;
		return this;
	}

	/**
	*对 Matrix 对象应用旋转转换。
	*@param angle 以弧度为单位的旋转角度。
	*@return 返回矩阵对象本身
	*/
	__proto.rotate=function(angle){
		var cos=Math.cos(angle);
		var sin=Math.sin(angle);
		var a1=this.a;
		var c1=this.c;
		var tx1=this.tx;
		this.a=a1 *cos-this.b *sin;
		this.b=a1 *sin+this.b *cos;
		this.c=c1 *cos-this.d *sin;
		this.d=c1 *sin+this.d *cos;
		this.tx=tx1 *cos-this.ty *sin;
		this.ty=tx1 *sin+this.ty *cos;
		this._bTransform=true;
		return this;
	}

	/**
	*对 Matrix 对象应用倾斜转换。
	*@param x 沿着 X 轴的 2D 倾斜弧度。
	*@param y 沿着 Y 轴的 2D 倾斜弧度。
	*@return 当前 Matrix 对象。
	*/
	__proto.skew=function(x,y){
		var tanX=Math.tan(x);
		var tanY=Math.tan(y);
		var a1=this.a;
		var b1=this.b;
		this.a+=tanY *this.c;
		this.b+=tanY *this.d;
		this.c+=tanX *a1;
		this.d+=tanX *b1;
		return this;
	}

	/**
	*对指定的点应用当前矩阵的逆转化并返回此点。
	*@param out 待转化的点 Point 对象。
	*@return 返回out
	*/
	__proto.invertTransformPoint=function(out){
		var a1=this.a;
		var b1=this.b;
		var c1=this.c;
		var d1=this.d;
		var tx1=this.tx;
		var n=a1 *d1-b1 *c1;
		var a2=d1 / n;
		var b2=-b1 / n;
		var c2=-c1 / n;
		var d2=a1 / n;
		var tx2=(c1 *this.ty-d1 *tx1)/ n;
		var ty2=-(a1 *this.ty-b1 *tx1)/ n;
		return out.setTo(a2 *out.x+c2 *out.y+tx2,b2 *out.x+d2 *out.y+ty2);
	}

	/**
	*将 Matrix 对象表示的几何转换应用于指定点。
	*@param out 用来设定输出结果的点。
	*@return 返回out
	*/
	__proto.transformPoint=function(out){
		return out.setTo(this.a *out.x+this.c *out.y+this.tx,this.b *out.x+this.d *out.y+this.ty);
	}

	/**
	*将 Matrix 对象表示的几何转换应用于指定点，忽略tx、ty。
	*@param out 用来设定输出结果的点。
	*@return 返回out
	*/
	__proto.transformPointN=function(out){
		return out.setTo(this.a *out.x+this.c *out.y ,this.b *out.x+this.d *out.y);
	}

	/**
	*@private
	*将 Matrix 对象表示的几何转换应用于指定点。
	*@param data 点集合。
	*@param out 存储应用转化的点的列表。
	*@return 返回out数组
	*/
	__proto.transformPointArray=function(data,out){
		var len=data.length;
		for (var i=0;i < len;i+=2){
			var x=data[i],y=data[i+1];
			out[i]=this.a *x+this.c *y+this.tx;
			out[i+1]=this.b *x+this.d *y+this.ty;
		}
		return out;
	}

	/**
	*获取 X 轴缩放值。
	*@return X 轴缩放值。
	*/
	__proto.getScaleX=function(){
		return this.b===0 ? this.a :Math.sqrt(this.a *this.a+this.b *this.b);
	}

	/**
	*获取 Y 轴缩放值。
	*@return Y 轴缩放值。
	*/
	__proto.getScaleY=function(){
		return this.c===0 ? this.d :Math.sqrt(this.c *this.c+this.d *this.d);
	}

	/**
	*执行原始矩阵的逆转换。
	*@return 当前矩阵对象。
	*/
	__proto.invert=function(){
		var a1=this.a;
		var b1=this.b;
		var c1=this.c;
		var d1=this.d;
		var tx1=this.tx;
		var n=a1 *d1-b1 *c1;
		this.a=d1 / n;
		this.b=-b1 / n;
		this.c=-c1 / n;
		this.d=a1 / n;
		this.tx=(c1 *this.ty-d1 *tx1)/ n;
		this.ty=-(a1 *this.ty-b1 *tx1)/ n;
		return this;
	}

	/**
	*将 Matrix 的成员设置为指定值。
	*@param a 缩放或旋转图像时影响像素沿 x 轴定位的值。
	*@param b 旋转或倾斜图像时影响像素沿 y 轴定位的值。
	*@param c 旋转或倾斜图像时影响像素沿 x 轴定位的值。
	*@param d 缩放或旋转图像时影响像素沿 y 轴定位的值。
	*@param tx 沿 x 轴平移每个点的距离。
	*@param ty 沿 y 轴平移每个点的距离。
	*@return 当前矩阵对象。
	*/
	__proto.setTo=function(a,b,c,d,tx,ty){
		this.a=a,this.b=b,this.c=c,this.d=d,this.tx=tx,this.ty=ty;
		return this;
	}

	/**
	*将指定矩阵与当前矩阵连接，从而将这两个矩阵的几何效果有效地结合在一起。
	*@param matrix 要连接到源矩阵的矩阵。
	*@return 当前矩阵。
	*/
	__proto.concat=function(matrix){
		var a=this.a;
		var c=this.c;
		var tx=this.tx;
		this.a=a *matrix.a+this.b *matrix.c;
		this.b=a *matrix.b+this.b *matrix.d;
		this.c=c *matrix.a+this.d *matrix.c;
		this.d=c *matrix.b+this.d *matrix.d;
		this.tx=tx *matrix.a+this.ty *matrix.c+matrix.tx;
		this.ty=tx *matrix.b+this.ty *matrix.d+matrix.ty;
		return this;
	}

	/**
	*@private
	*对矩阵应用缩放转换。反向相乘
	*@param x 用于沿 x 轴缩放对象的乘数。
	*@param y 用于沿 y 轴缩放对象的乘数。
	*/
	__proto.scaleEx=function(x,y){
		var ba=this.a,bb=this.b,bc=this.c,bd=this.d;
		if (bb!==0 || bc!==0){
			this.a=x *ba;
			this.b=x *bb;
			this.c=y *bc;
			this.d=y *bd;
			}else {
			this.a=x *ba;
			this.b=0 *bd;
			this.c=0 *ba;
			this.d=y *bd;
		}
		this._bTransform=true;
	}

	/**
	*@private
	*对 Matrix 对象应用旋转转换。反向相乘
	*@param angle 以弧度为单位的旋转角度。
	*/
	__proto.rotateEx=function(angle){
		var cos=Math.cos(angle);
		var sin=Math.sin(angle);
		var ba=this.a,bb=this.b,bc=this.c,bd=this.d;
		if (bb!==0 || bc!==0){
			this.a=cos *ba+sin *bc;
			this.b=cos *bb+sin *bd;
			this.c=-sin *ba+cos *bc;
			this.d=-sin *bb+cos *bd;
			}else {
			this.a=cos *ba;
			this.b=sin *bd;
			this.c=-sin *ba;
			this.d=cos *bd;
		}
		this._bTransform=true;
	}

	/**
	*返回此 Matrix 对象的副本。
	*@return 与原始实例具有完全相同的属性的新 Matrix 实例。
	*/
	__proto.clone=function(){
		var dec=Matrix.create();
		dec.a=this.a;
		dec.b=this.b;
		dec.c=this.c;
		dec.d=this.d;
		dec.tx=this.tx;
		dec.ty=this.ty;
		dec._bTransform=this._bTransform;
		return dec;
	}

	/**
	*将当前 Matrix 对象中的所有矩阵数据复制到指定的 Matrix 对象中。
	*@param dec 要复制当前矩阵数据的 Matrix 对象。
	*@return 已复制当前矩阵数据的 Matrix 对象。
	*/
	__proto.copyTo=function(dec){
		dec.a=this.a;
		dec.b=this.b;
		dec.c=this.c;
		dec.d=this.d;
		dec.tx=this.tx;
		dec.ty=this.ty;
		dec._bTransform=this._bTransform;
		return dec;
	}

	/**
	*返回列出该 Matrix 对象属性的文本值。
	*@return 一个字符串，它包含 Matrix 对象的属性值：a、b、c、d、tx 和 ty。
	*/
	__proto.toString=function(){
		return this.a+","+this.b+","+this.c+","+this.d+","+this.tx+","+this.ty;
	}

	/**
	*销毁此对象。
	*/
	__proto.destroy=function(){
		this.recover();
	}

	/**
	*回收到对象池，方便复用
	*/
	__proto.recover=function(){
		Pool.recover("Matrix",this.identity());
	}

	Matrix.mul=function(m1,m2,out){
		var aa=m1.a,ab=m1.b,ac=m1.c,ad=m1.d,atx=m1.tx,aty=m1.ty;
		var ba=m2.a,bb=m2.b,bc=m2.c,bd=m2.d,btx=m2.tx,bty=m2.ty;
		if (bb!==0 || bc!==0){
			out.a=aa *ba+ab *bc;
			out.b=aa *bb+ab *bd;
			out.c=ac *ba+ad *bc;
			out.d=ac *bb+ad *bd;
			out.tx=ba *atx+bc *aty+btx;
			out.ty=bb *atx+bd *aty+bty;
			}else {
			out.a=aa *ba;
			out.b=ab *bd;
			out.c=ac *ba;
			out.d=ad *bd;
			out.tx=ba *atx+btx;
			out.ty=bd *aty+bty;
		}
		return out;
	}

	Matrix.mul16=function(m1,m2,out){
		var aa=m1.a,ab=m1.b,ac=m1.c,ad=m1.d,atx=m1.tx,aty=m1.ty;
		var ba=m2.a,bb=m2.b,bc=m2.c,bd=m2.d,btx=m2.tx,bty=m2.ty;
		if (bb!==0 || bc!==0){
			out[0]=aa *ba+ab *bc;
			out[1]=aa *bb+ab *bd;
			out[4]=ac *ba+ad *bc;
			out[5]=ac *bb+ad *bd;
			out[12]=ba *atx+bc *aty+btx;
			out[13]=bb *atx+bd *aty+bty;
			}else {
			out[0]=aa *ba;
			out[1]=ab *bd;
			out[4]=ac *ba;
			out[5]=ad *bd;
			out[12]=ba *atx+btx;
			out[13]=bd *aty+bty;
		}
		return out;
	}

	Matrix.mulPre=function(m1,ba,bb,bc,bd,btx,bty,out){
		var aa=m1.a,ab=m1.b,ac=m1.c,ad=m1.d,atx=m1.tx,aty=m1.ty;
		if (bb!==0 || bc!==0){
			out.a=aa *ba+ab *bc;
			out.b=aa *bb+ab *bd;
			out.c=ac *ba+ad *bc;
			out.d=ac *bb+ad *bd;
			out.tx=ba *atx+bc *aty+btx;
			out.ty=bb *atx+bd *aty+bty;
			}else {
			out.a=aa *ba;
			out.b=ab *bd;
			out.c=ac *ba;
			out.d=ad *bd;
			out.tx=ba *atx+btx;
			out.ty=bd *aty+bty;
		}
		return out;
	}

	Matrix.mulPos=function(m1,aa,ab,ac,ad,atx,aty,out){
		var ba=m1.a,bb=m1.b,bc=m1.c,bd=m1.d,btx=m1.tx,bty=m1.ty;
		if (bb!==0 || bc!==0){
			out.a=aa *ba+ab *bc;
			out.b=aa *bb+ab *bd;
			out.c=ac *ba+ad *bc;
			out.d=ac *bb+ad *bd;
			out.tx=ba *atx+bc *aty+btx;
			out.ty=bb *atx+bd *aty+bty;
			}else {
			out.a=aa *ba;
			out.b=ab *bd;
			out.c=ac *ba;
			out.d=ad *bd;
			out.tx=ba *atx+btx;
			out.ty=bd *aty+bty;
		}
		return out;
	}

	Matrix.preMul=function(parent,self,out){
		var pa=parent.a,pb=parent.b,pc=parent.c,pd=parent.d;
		var na=self.a,nb=self.b,nc=self.c,nd=self.d,ntx=self.tx,nty=self.ty;
		out.a=na *pa;
		out.b=out.c=0;
		out.d=nd *pd;
		out.tx=ntx *pa+parent.tx;
		out.ty=nty *pd+parent.ty;
		if (nb!==0 || nc!==0 || pb!==0 || pc!==0){
			out.a+=nb *pc;
			out.d+=nc *pb;
			out.b+=na *pb+nb *pd;
			out.c+=nc *pa+nd *pc;
			out.tx+=nty *pc;
			out.ty+=ntx *pb;
		}
		return out;
	}

	Matrix.preMulXY=function(parent,x,y,out){
		var pa=parent.a,pb=parent.b,pc=parent.c,pd=parent.d;
		out.a=pa;
		out.b=pb;
		out.c=pc;
		out.d=pd;
		out.tx=x *pa+parent.tx+y *pc;
		out.ty=y *pd+parent.ty+x *pb;
		return out;
	}

	Matrix.create=function(){
		return Pool.getItemByClass("Matrix",Matrix);
	}

	Matrix.EMPTY=new Matrix();
	Matrix.TEMP=new Matrix();
	Matrix._createFun=null;
	return Matrix;
})()


	//file:///E:/git/layaair-master/core/src/laya/maths/Point.as=======199.999906/199.999906
/**
*<code>Point</code> 对象表示二维坐标系统中的某个位置，其中 x 表示水平轴，y 表示垂直轴。
*/
//class laya.maths.Point
var Point=(function(){
	function Point(x,y){
		/**该点的水平坐标。*/
		//this.x=NaN;
		/**该点的垂直坐标。*/
		//this.y=NaN;
		(x===void 0)&& (x=0);
		(y===void 0)&& (y=0);
		this.x=x;
		this.y=y;
	}

	__class(Point,'laya.maths.Point');
	var __proto=Point.prototype;
	/**
	*将 <code>Point</code> 的成员设置为指定值。
	*@param x 水平坐标。
	*@param y 垂直坐标。
	*@return 当前 Point 对象。
	*/
	__proto.setTo=function(x,y){
		this.x=x;
		this.y=y;
		return this;
	}

	/**
	*重置
	*/
	__proto.reset=function(){
		this.x=this.y=0;
		return this;
	}

	/**
	*回收到对象池，方便复用
	*/
	__proto.recover=function(){
		Pool.recover("Point",this.reset());
	}

	/**
	*计算当前点和目标点(x，y)的距离。
	*@param x 水平坐标。
	*@param y 垂直坐标。
	*@return 返回当前点和目标点之间的距离。
	*/
	__proto.distance=function(x,y){
		return Math.sqrt((this.x-x)*(this.x-x)+(this.y-y)*(this.y-y));
	}

	/**返回包含 x 和 y 坐标的值的字符串。*/
	__proto.toString=function(){
		return this.x+","+this.y;
	}

	/**
	*标准化向量。
	*/
	__proto.normalize=function(){
		var d=Math.sqrt(this.x *this.x+this.y *this.y);
		if (d > 0){
			var id=1.0 / d;
			this.x *=id;
			this.y *=id;
		}
	}

	Point.create=function(){
		return Pool.getItemByClass("Point",Point);
	}

	Point.TEMP=new Point();
	Point.EMPTY=new Point();
	return Point;
})()


	//file:///E:/git/layaair-master/core/src/laya/maths/Rectangle.as=======199.999905/199.999905
/**
*<p><code>Rectangle</code> 对象是按其位置（由它左上角的点 (x,y)确定）以及宽度和高度定义的区域。</p>
*<p>Rectangle 类的 x、y、width 和 height 属性相互独立；更改一个属性的值不会影响其他属性。</p>
*/
//class laya.maths.Rectangle
var Rectangle=(function(){
	function Rectangle(x,y,width,height){
		/**矩形左上角的 X 轴坐标。*/
		//this.x=NaN;
		/**矩形左上角的 Y 轴坐标。*/
		//this.y=NaN;
		/**矩形的宽度。*/
		//this.width=NaN;
		/**矩形的高度。*/
		//this.height=NaN;
		(x===void 0)&& (x=0);
		(y===void 0)&& (y=0);
		(width===void 0)&& (width=0);
		(height===void 0)&& (height=0);
		this.x=x;
		this.y=y;
		this.width=width;
		this.height=height;
	}

	__class(Rectangle,'laya.maths.Rectangle');
	var __proto=Rectangle.prototype;
	/**
	*将 Rectangle 的属性设置为指定值。
	*@param x x 矩形左上角的 X 轴坐标。
	*@param y x 矩形左上角的 Y 轴坐标。
	*@param width 矩形的宽度。
	*@param height 矩形的高。
	*@return 返回属性值修改后的矩形对象本身。
	*/
	__proto.setTo=function(x,y,width,height){
		this.x=x;
		this.y=y;
		this.width=width;
		this.height=height;
		return this;
	}

	/**
	*重置
	*/
	__proto.reset=function(){
		this.x=this.y=this.width=this.height=0;
		return this;
	}

	/**
	*回收
	*/
	__proto.recover=function(){
		Pool.recover("Rectangle",this.reset());
	}

	/**
	*复制 source 对象的属性值到此矩形对象中。
	*@param sourceRect 源 Rectangle 对象。
	*@return 返回属性值修改后的矩形对象本身。
	*/
	__proto.copyFrom=function(source){
		this.x=source.x;
		this.y=source.y;
		this.width=source.width;
		this.height=source.height;
		return this;
	}

	/**
	*确定由此 Rectangle 对象定义的矩形区域内是否包含指定的点。
	*@param x 点的 X 轴坐标值（水平位置）。
	*@param y 点的 Y 轴坐标值（垂直位置）。
	*@return 如果 Rectangle 对象包含指定的点，则值为 true；否则为 false。
	*/
	__proto.contains=function(x,y){
		if (this.width <=0 || this.height <=0)return false;
		if (x >=this.x && x < this.right){
			if (y >=this.y && y < this.bottom){
				return true;
			}
		}
		return false;
	}

	/**
	*确定在 rect 参数中指定的对象是否与此 Rectangle 对象相交。此方法检查指定的 Rectangle 对象的 x、y、width 和 height 属性，以查看它是否与此 Rectangle 对象相交。
	*@param rect Rectangle 对象。
	*@return 如果传入的矩形对象与此对象相交，则返回 true 值，否则返回 false。
	*/
	__proto.intersects=function(rect){
		return !(rect.x > (this.x+this.width)|| (rect.x+rect.width)< this.x || rect.y > (this.y+this.height)|| (rect.y+rect.height)< this.y);
	}

	/**
	*如果在 rect 参数中指定的 Rectangle 对象与此 Rectangle 对象相交，则返回交集区域作为 Rectangle 对象。如果矩形不相交，则此方法返回null。
	*@param rect 待比较的矩形区域。
	*@param out （可选）待输出的矩形区域。如果为空则创建一个新的。建议：尽量复用对象，减少对象创建消耗。
	*@return 返回相交的矩形区域对象。
	*/
	__proto.intersection=function(rect,out){
		if (!this.intersects(rect))return null;
		out || (out=new Rectangle());
		out.x=Math.max(this.x,rect.x);
		out.y=Math.max(this.y,rect.y);
		out.width=Math.min(this.right,rect.right)-out.x;
		out.height=Math.min(this.bottom,rect.bottom)-out.y;
		return out;
	}

	/**
	*<p>矩形联合，通过填充两个矩形之间的水平和垂直空间，将这两个矩形组合在一起以创建一个新的 Rectangle 对象。</p>
	*<p>注意：union()方法忽略高度或宽度值为 0 的矩形，如：var rect2:Rectangle=new Rectangle(300,300,50,0);</p>
	*@param 要添加到此 Rectangle 对象的 Rectangle 对象。
	*@param out 用于存储输出结果的矩形对象。如果为空，则创建一个新的。建议：尽量复用对象，减少对象创建消耗。Rectangle.TEMP对象用于对象复用。
	*@return 充当两个矩形的联合的新 Rectangle 对象。
	*/
	__proto.union=function(source,out){
		out || (out=new Rectangle());
		this.clone(out);
		if (source.width <=0 || source.height <=0)return out;
		out.addPoint(source.x,source.y);
		out.addPoint(source.right,source.bottom);
		return this;
	}

	/**
	*返回一个 Rectangle 对象，其 x、y、width 和 height 属性的值与当前 Rectangle 对象的对应值相同。
	*@param out （可选）用于存储结果的矩形对象。如果为空，则创建一个新的。建议：尽量复用对象，减少对象创建消耗。。Rectangle.TEMP对象用于对象复用。
	*@return Rectangle 对象，其 x、y、width 和 height 属性的值与当前 Rectangle 对象的对应值相同。
	*/
	__proto.clone=function(out){
		out || (out=new Rectangle());
		out.x=this.x;
		out.y=this.y;
		out.width=this.width;
		out.height=this.height;
		return out;
	}

	/**
	*当前 Rectangle 对象的水平位置 x 和垂直位置 y 以及高度 width 和宽度 height 以逗号连接成的字符串。
	*/
	__proto.toString=function(){
		return this.x+","+this.y+","+this.width+","+this.height;
	}

	/**
	*检测传入的 Rectangle 对象的属性是否与当前 Rectangle 对象的属性 x、y、width、height 属性值都相等。
	*@param rect 待比较的 Rectangle 对象。
	*@return 如果判断的属性都相等，则返回 true ,否则返回 false。
	*/
	__proto.equals=function(rect){
		if (!rect || rect.x!==this.x || rect.y!==this.y || rect.width!==this.width || rect.height!==this.height)return false;
		return true;
	}

	/**
	*<p>为当前矩形对象加一个点，以使当前矩形扩展为包含当前矩形和此点的最小矩形。</p>
	*<p>此方法会修改本对象。</p>
	*@param x 点的 X 坐标。
	*@param y 点的 Y 坐标。
	*@return 返回此 Rectangle 对象。
	*/
	__proto.addPoint=function(x,y){
		this.x > x && (this.width+=this.x-x,this.x=x);
		this.y > y && (this.height+=this.y-y,this.y=y);
		if (this.width < x-this.x)this.width=x-this.x;
		if (this.height < y-this.y)this.height=y-this.y;
		return this;
	}

	/**
	*@private
	*返回代表当前矩形的顶点数据。
	*@return 顶点数据。
	*/
	__proto._getBoundPoints=function(){
		var rst=Rectangle._temB;
		rst.length=0;
		if (this.width==0 || this.height==0)return rst;
		rst.push(this.x,this.y,this.x+this.width,this.y,this.x,this.y+this.height,this.x+this.width,this.y+this.height);
		return rst;
	}

	/**
	*确定此 Rectangle 对象是否为空。
	*@return 如果 Rectangle 对象的宽度或高度小于等于 0，则返回 true 值，否则返回 false。
	*/
	__proto.isEmpty=function(){
		if (this.width <=0 || this.height <=0)return true;
		return false;
	}

	/**此矩形右侧的 X 轴坐标。 x 和 width 属性的和。*/
	__getset(0,__proto,'right',function(){
		return this.x+this.width;
	});

	/**此矩形底端的 Y 轴坐标。y 和 height 属性的和。*/
	__getset(0,__proto,'bottom',function(){
		return this.y+this.height;
	});

	Rectangle.create=function(){
		return Pool.getItemByClass("Rectangle",Rectangle);
	}

	Rectangle._getBoundPointS=function(x,y,width,height){
		var rst=Rectangle._temA;
		rst.length=0;
		if (width==0 || height==0)return rst;
		rst.push(x,y,x+width,y,x,y+height,x+width,y+height);
		return rst;
	}

	Rectangle._getWrapRec=function(pointList,rst){
		if (!pointList || pointList.length < 1)return rst ? rst.setTo(0,0,0,0):Rectangle.TEMP.setTo(0,0,0,0);
		rst=rst ? rst :laya.maths.Rectangle.create();
		var i,len=pointList.length,minX,maxX,minY,maxY,tPoint=Point.TEMP;
		minX=minY=99999;
		maxX=maxY=-minX;
		for (i=0;i < len;i+=2){
			tPoint.x=pointList[i];
			tPoint.y=pointList[i+1];
			minX=minX < tPoint.x ? minX :tPoint.x;
			minY=minY < tPoint.y ? minY :tPoint.y;
			maxX=maxX > tPoint.x ? maxX :tPoint.x;
			maxY=maxY > tPoint.y ? maxY :tPoint.y;
		}
		return rst.setTo(minX,minY,maxX-minX,maxY-minY);
	}

	Rectangle.EMPTY=new Rectangle();
	Rectangle.TEMP=new Rectangle();
	Rectangle._temB=[];
	Rectangle._temA=[];
	return Rectangle;
})()


	//file:///E:/git/layaair-master/core/src/laya/media/SoundManager.as=======199.999900/199.999900
/**
*<code>SoundManager</code> 是一个声音管理类。提供了对背景音乐、音效的播放控制方法。
*引擎默认有两套声音方案：WebAudio和H5Audio
*播放音效，优先使用WebAudio播放声音，如果WebAudio不可用，则用H5Audio播放，H5Audio在部分机器上有兼容问题（比如不能混音，播放有延迟等）。
*播放背景音乐，则使用H5Audio播放（使用WebAudio会增加特别大的内存，并且要等加载完毕后才能播放，有延迟）
*建议背景音乐用mp3类型，音效用wav或者mp3类型（如果打包为app，音效只能用wav格式）。
*详细教程及声音格式请参考：http://ldc.layabox.com/doc/?nav=ch-as-1-7-0
*/
//class laya.media.SoundManager
var SoundManager=(function(){
	function SoundManager(){}
	__class(SoundManager,'laya.media.SoundManager');
	/**
	*失去焦点后是否自动停止背景音乐。
	*/
	__getset(1,SoundManager,'autoStopMusic',function(){
		return SoundManager._autoStopMusic;
		},function(v){
		Laya.stage.off("blur",null,SoundManager._stageOnBlur);
		Laya.stage.off("focus",null,SoundManager._stageOnFocus);
		Laya.stage.off("visibilitychange",null,SoundManager._visibilityChange);
		SoundManager._autoStopMusic=v;
		if (v){
			Laya.stage.on("blur",null,SoundManager._stageOnBlur);
			Laya.stage.on("focus",null,SoundManager._stageOnFocus);
			Laya.stage.on("visibilitychange",null,SoundManager._visibilityChange);
		}
	});

	/**
	*背景音乐和所有音效是否静音。
	*/
	__getset(1,SoundManager,'muted',function(){
		return SoundManager._muted;
		},function(value){
		if (value)SoundManager.stopAllSound();
		SoundManager.musicMuted=value;
		SoundManager._muted=value;
	});

	/**
	*背景音乐（不包括音效）是否静音。
	*/
	__getset(1,SoundManager,'musicMuted',function(){
		return SoundManager._musicMuted;
		},function(value){
		if (value){
			if (SoundManager._bgMusic)SoundManager.stopSound(SoundManager._bgMusic);
			SoundManager._musicMuted=value;
			}else {
			SoundManager._musicMuted=value;
			if (SoundManager._bgMusic)SoundManager.playMusic(SoundManager._bgMusic);
		}
	});

	/**
	*所有音效（不包括背景音乐）是否静音。
	*/
	__getset(1,SoundManager,'soundMuted',function(){
		return SoundManager._soundMuted;
		},function(value){
		SoundManager._soundMuted=value;
	});

	SoundManager.__init__=function(){
		var win=Browser.window;
		var supportWebAudio=win["AudioContext"] || win["webkitAudioContext"] || win["mozAudioContext"] ? true :false;
		if (supportWebAudio)WebAudioSound.initWebAudio();
		SoundManager._soundClass=supportWebAudio?WebAudioSound:AudioSound;
		return supportWebAudio;
	}

	SoundManager.addChannel=function(channel){
		if (SoundManager._channels.indexOf(channel)>=0)return;
		SoundManager._channels.push(channel);
	}

	SoundManager.removeChannel=function(channel){
		for (var i=SoundManager._channels.length-1;i >=0;i--){
			if (SoundManager._channels[i]===channel){
				SoundManager._channels.splice(i,1);
				return;
			}
		}
	}

	SoundManager._visibilityChange=function(){
		if (Laya.stage.isVisibility)SoundManager._stageOnFocus();
		else SoundManager._stageOnBlur();
	}

	SoundManager._stageOnBlur=function(){
		SoundManager._isActive=false;
		if (SoundManager._musicChannel){
			if (!SoundManager._musicChannel.isStopped){
				SoundManager._blurPaused=true;
				SoundManager._musicLoops=SoundManager._musicChannel.loops;
				SoundManager._musicCompleteHandler=SoundManager._musicChannel.completeHandler;
				SoundManager._musicPosition=SoundManager._musicChannel.position;
				SoundManager._musicChannel.stop();
				Laya.stage.once("mousedown",null,SoundManager._stageOnFocus);
			}
		}
		SoundManager.stopAllSound();
	}

	SoundManager._stageOnFocus=function(){
		SoundManager._isActive=true;
		Laya.stage.off("mousedown",null,SoundManager._stageOnFocus);
		if (SoundManager._blurPaused){
			if (SoundManager._bgMusic)SoundManager.playMusic(SoundManager._bgMusic,SoundManager._musicLoops,SoundManager._musicCompleteHandler,SoundManager._musicPosition);
			SoundManager._blurPaused=false;
		}
	}

	SoundManager.playSound=function(url,loops,complete,soundClass,startTime){
		(loops===void 0)&& (loops=1);
		(startTime===void 0)&& (startTime=0);
		if (!SoundManager._isActive)return null;
		if (SoundManager._muted)return null;
		url=URL.formatURL(url);
		if (url===SoundManager._bgMusic){
			if (SoundManager._musicMuted)return null;
			}else {
			if (Render.isConchApp){
				var ext=Utils.getFileExtension(url);
				if (ext !="wav" && ext !="ogg"){
					alert("The sound only supports wav or ogg format,for optimal performance reason,please refer to the official website document.");
					return null;
				}
			}
			if (SoundManager._soundMuted)return null;
		};
		var tSound=Laya.loader.getRes(url);
		if (!soundClass)soundClass=SoundManager._soundClass;
		if (!tSound){
			tSound=new soundClass();
			tSound.load(url);
			Loader.cacheRes(url,tSound);
		};
		var channel;
		channel=tSound.play(startTime,loops);
		channel.url=url;
		channel.volume=(url===SoundManager._bgMusic)? SoundManager.musicVolume :SoundManager.soundVolume;
		channel.completeHandler=complete;
		return channel;
	}

	SoundManager.destroySound=function(url){
		var tSound=Laya.loader.getRes(url);
		if (tSound){
			Loader.clearRes(url);
			tSound.dispose();
		}
	}

	SoundManager.playMusic=function(url,loops,complete,startTime){
		(loops===void 0)&& (loops=0);
		(startTime===void 0)&& (startTime=0);
		url=URL.formatURL(url);
		SoundManager._bgMusic=url;
		if (SoundManager._musicChannel)SoundManager._musicChannel.stop();
		return SoundManager._musicChannel=SoundManager.playSound(url,loops,complete,null,startTime);
	}

	SoundManager.stopSound=function(url){
		url=URL.formatURL(url);
		var channel;
		for (var i=SoundManager._channels.length-1;i >=0;i--){
			channel=SoundManager._channels[i];
			if (channel.url===url){
				channel.stop();
			}
		}
	}

	SoundManager.stopAll=function(){
		SoundManager._bgMusic=null;
		var channel;
		for (var i=SoundManager._channels.length-1;i >=0;i--){
			channel=SoundManager._channels[i];
			channel.stop();
		}
	}

	SoundManager.stopAllSound=function(){
		var channel;
		for (var i=SoundManager._channels.length-1;i >=0;i--){
			channel=SoundManager._channels[i];
			if (channel.url!==SoundManager._bgMusic){
				channel.stop();
			}
		}
	}

	SoundManager.stopMusic=function(){
		SoundManager._bgMusic=null;
		if (SoundManager._musicChannel)SoundManager._musicChannel.stop();
	}

	SoundManager.setSoundVolume=function(volume,url){
		if (url){
			url=URL.formatURL(url);
			SoundManager._setVolume(url,volume);
			}else {
			SoundManager.soundVolume=volume;
			var channel;
			for (var i=SoundManager._channels.length-1;i >=0;i--){
				channel=SoundManager._channels[i];
				if (channel.url!==SoundManager._bgMusic){
					channel.volume=volume;
				}
			}
		}
	}

	SoundManager.setMusicVolume=function(volume){
		SoundManager.musicVolume=volume;
		SoundManager._setVolume(SoundManager._bgMusic,volume);
	}

	SoundManager._setVolume=function(url,volume){
		url=URL.formatURL(url);
		var channel;
		for (var i=SoundManager._channels.length-1;i >=0;i--){
			channel=SoundManager._channels[i];
			if (channel.url===url){
				channel.volume=volume;
			}
		}
	}

	SoundManager.musicVolume=1;
	SoundManager.soundVolume=1;
	SoundManager.playbackRate=1;
	SoundManager._muted=false;
	SoundManager._soundMuted=false;
	SoundManager._musicMuted=false;
	SoundManager._bgMusic=null;
	SoundManager._musicChannel=null;
	SoundManager._channels=[];
	SoundManager._autoStopMusic=false;
	SoundManager._blurPaused=false;
	SoundManager._isActive=true;
	SoundManager._musicLoops=0;
	SoundManager._musicPosition=0;
	SoundManager._musicCompleteHandler=null;
	SoundManager._soundClass=null;
	return SoundManager;
})()


	//file:///E:/git/layaair-master/core/src/laya/net/LocalStorage.as=======199.999892/199.999892
/**
*<p> <code>LocalStorage</code> 类用于没有时间限制的本地数据存储。</p>
*/
//class laya.net.LocalStorage
var LocalStorage=(function(){
	function LocalStorage(){}
	__class(LocalStorage,'laya.net.LocalStorage');
	LocalStorage.__init__=function(){
		var window=Browser.window;
		if (window.localStorage){
			try {
				LocalStorage.items=window.localStorage;
				LocalStorage.setItem('laya','1');
				LocalStorage.removeItem('laya');
				LocalStorage.support=true;
			}catch (e){}
		}
		if (!LocalStorage.support)console.warn('LocalStorage is not supprot or browser is private mode.');
		return LocalStorage.support;
	}

	LocalStorage.setItem=function(key,value){
		try {
			LocalStorage.support && LocalStorage.items.setItem(key,value);
			}catch (e){
			console.warn("set localStorage failed",e);
		}
	}

	LocalStorage.getItem=function(key){
		return LocalStorage.support ? LocalStorage.items.getItem(key):null;
	}

	LocalStorage.setJSON=function(key,value){
		try {
			LocalStorage.support && LocalStorage.items.setItem(key,JSON.stringify(value));
			}catch (e){
			console.log("set localStorage failed",e);
		}
	}

	LocalStorage.getJSON=function(key){
		return LocalStorage.support ? JSON.parse(LocalStorage.items.getItem(key)):null;
	}

	LocalStorage.removeItem=function(key){
		LocalStorage.support && LocalStorage.items.removeItem(key);
	}

	LocalStorage.clear=function(){
		LocalStorage.support && LocalStorage.items.clear();
	}

	LocalStorage.items=null;
	LocalStorage.support=false;
	return LocalStorage;
})()


	//file:///E:/git/layaair-master/core/src/laya/net/URL.as=======199.999890/199.999890
/**
*<p><code>URL</code> 提供URL格式化，URL版本管理的类。</p>
*<p>引擎加载资源的时候，会自动调用formatURL函数格式化URL路径</p>
*<p>通过basePath属性可以设置网络基础路径</p>
*<p>通过设置customFormat函数，可以自定义URL格式化的方式</p>
*<p>除了默认的通过增加后缀的格式化外，通过VersionManager类，可以开启IDE提供的，基于目录的管理方式来替代 "?v=" 的管理方式</p>
*@see laya.net.VersionManager
*/
//class laya.net.URL
var URL=(function(){
	function URL(url){
		/**@private */
		this._url=null;
		/**@private */
		this._path=null;
		this._url=URL.formatURL(url);
		this._path=URL.getPath(url);
	}

	__class(URL,'laya.net.URL');
	var __proto=URL.prototype;
	/**地址的文件夹路径（不包括文件名）。*/
	__getset(0,__proto,'path',function(){
		return this._path;
	});

	/**格式化后的地址。*/
	__getset(0,__proto,'url',function(){
		return this._url;
	});

	URL.formatURL=function(url){
		if (!url)return "null path";
		if (url.indexOf(":")> 0)return url;
		if (URL.customFormat !=null)url=URL.customFormat(url);
		var char1=url.charAt(0);
		if (char1==="."){
			return URL._formatRelativePath (URL.basePath+url);
			}else if (char1==='~'){
			return URL.rootPath+url.substring(1);
			}else if (char1==="d"){
			if (url.indexOf("data:image")===0)return url;
			}else if (char1==="/"){
			return url;
		}
		return URL.basePath+url;
	}

	URL._formatRelativePath=function(value){
		var parts=value.split("/");
		for (var i=0,len=parts.length;i < len;i++){
			if (parts[i]=='..'){
				parts.splice(i-1,2);
				i-=2;
			}
		}
		return parts.join('/');
	}

	URL.getPath=function(url){
		var ofs=url.lastIndexOf('/');
		return ofs > 0 ? url.substr(0,ofs+1):"";
	}

	URL.getFileName=function(url){
		var ofs=url.lastIndexOf('/');
		return ofs > 0 ? url.substr(ofs+1):url;
	}

	URL.version={};
	URL.basePath="";
	URL.rootPath="";
	URL.customFormat=function(url){
		var newUrl=URL.version[url];
		if (!Render.isConchApp && newUrl)url+="?v="+newUrl;
		return url;
	}

	return URL;
})()


	//file:///E:/git/layaair-master/core/src/laya/renders/layagl/GLBuffer.as=======199.999887/199.999887
/**
*@private
*对buffer进行封装，自动扩容
*/
//class laya.renders.layagl.GLBuffer
var GLBuffer=(function(){
	function GLBuffer(reserveSize,adjustSize,isUsrArray,isSyncToRenderThread){
		this._idata=null;
		this._fdata=null;
		this._byteArray=null;
		this._buffer=null;
		this._adjustSize=0;
		this._byteLen=0;
		this._index=1;
		this._byteLen=reserveSize;
		this._adjustSize=adjustSize;
		this._init(isUsrArray,isSyncToRenderThread);
	}

	__class(GLBuffer,'laya.renders.layagl.GLBuffer');
	var __proto=GLBuffer.prototype;
	__proto._init=function(isUsrArray,isSyncToRenderThread){
		if (isUsrArray){
			this._buffer=this._idata=this._fdata=[];
			}else {
			this._buffer=new ArrayBuffer(this._byteLen);
			this._idata=new Int32Array(this._buffer);
			this._fdata=new Float32Array(this._buffer);
			this._byteArray=new Uint8Array(this._buffer);
		}
	}

	__proto._initWithNative=function(isUsrArray,isSyncToRenderThread){
		this._buffer=new ArrayBuffer(this._byteLen);
		this._idata=new Int32Array(this._buffer);
		this._fdata=new Float32Array(this._buffer);
		this._byteArray=new Uint8Array(this._buffer);
		this._buffer["conchRef"]=LayaGLNativeContext.createArrayBufferRef(this._buffer,1,isSyncToRenderThread);
		this._buffer["_ptrID"]=this._buffer["conchRef"].id;
	}

	__proto.clear=function(){
		this._index=1;
	}

	__proto.getCount=function(){
		return this._index;
	}

	__proto._need=function(sz){}
	__proto._needWithNative=function(sz){
		if ((this._byteLen-(this._index << 2))>=sz)return;
		this._byteLen+=(sz > this._adjustSize)?sz:this._adjustSize;
		var pre=this._idata;
		var preConchRef=this._buffer["conchRef"];
		var prePtrID=this._buffer["_ptrID"];
		this._buffer=new ArrayBuffer(this._byteLen);
		this._idata=new Int32Array(this._buffer);
		this._fdata=new Float32Array(this._buffer);
		this._byteArray=new Uint8Array(this._buffer);
		this._buffer["conchRef"]=preConchRef;
		this._buffer["_ptrID"]=prePtrID;
		pre && this._idata.set(pre,0);
		window.conch.updateArrayBufferRef(this._buffer["_ptrID"],preConchRef.isSyncToRender(),this._buffer);
	}

	/**
	*将当前指针移到指定位置
	*@param pos
	*/
	__proto.setPos=function(pos){
		this._index=pos;
	}

	/**
	*将当前指针移到最后
	*/
	__proto.moveToEnd=function(){
		this._index=this._idata[0] > 0 ? this._idata[0] :1;
	}

	__proto._setSize=function(){
		this._idata[0]=this._index;
	}

	__proto.add_i=function(a){
		this._need(4);
		this._idata[this._index++]=a;
		this._setSize();
		return this._index-1;
	}

	__proto.set_i=function(index,value){
		this._idata[index]=value;
	}

	__proto.get_i=function(index){
		return this._idata[index];
	}

	__proto.add_f=function(a){
		this._need(4);
		this._fdata[this._index++]=a;
		this._setSize();
		return this._index-1;
	}

	__proto.set_f=function(index,value){
		this._fdata[index]=value;
	}

	__proto.get_f=function(index){
		return this._fdata[index];
	}

	__proto.add_Boolean=function(value){
		this._need(4);
		this._idata[this._index++]=value?1:0;
		this._setSize();
		return this._index-1;
	}

	__proto.set_Boolean=function(index,value){
		this._idata[index]=value?1:0;
	}

	__proto.get_Boolean=function(index){
		return this._idata[index] > 0;
	}

	__proto.add_Color=function(value){
		this._need(4);
		this._idata[this._index++]=Color.create(value).numColor;
		this._setSize();
		return this._index-1;
	}

	__proto.add_FillLineColorWithNative=function(fillColor,lineColor){
		var mask=0x00;
		(fillColor==null)|| (mask |=0x02);
		(lineColor==null)|| (mask |=0x01);
		this._need(12);
		this._idata[this._index++]=Color.create(fillColor).numColor;
		this._idata[this._index++]=Color.create(lineColor).numColor;
		this._idata[this._index++]=mask;
		this._setSize();
		return this._index-3;
	}

	__proto.set_Color=function(index,value){
		this._idata[index]=Color.create(value).numColor;
	}

	__proto.get_Color=function(index){
		return Color.create(this._idata[index]).strColor;
	}

	__proto.add_FloatArray=function(value){
		var n=value.length;
		this._need((n+1)*4);
		this._idata[this._index++]=n;
		for (var i=0;i < n;i++){
			this._fdata[this._index++]=value[i];
		}
		this._setSize();
		return this._index-(n+1);
	}

	__proto.set_FloatArray=function(index,value){}
	//todo:
	__proto.get_FloatArray=function(index){
		return null;
	}

	__proto.add_ff=function(a,b){
		this._need(8);
		this._fdata[this._index++]=a;
		this._fdata[this._index++]=b;
		this._setSize();
		return this._index-2;
	}

	__proto.add_point=function(point){
		this._need(4);
		this._idata[this._index++]=point;
		this._setSize();
		return this._index-1;
	}

	__proto.set_point=function(index,point){}
	//todo
	__proto.get_point=function(index){}
	/**
	*仅供非加速器模式用
	*@param obj
	*@return
	*/
	__proto.add_object=function(obj){
		return this._index;
	}

	__proto.set_object=function(index,obj){}
	//todo
	__proto.get_object=function(index){
		return null;
	}

	__proto.add_ii=function(a,b){
		this._need(8);
		this._idata[this._index++]=a;
		this._idata[this._index++]=b;
		this._setSize();
		return this._index-2;
	}

	__proto.add_if=function(a,b){
		this._need(8);
		this._idata[this._index++]=a;
		this._fdata[this._index++]=b;
		this._setSize();
		return this._index-2;
	}

	__proto.add_iii=function(a,b,c){
		this._need(12);
		var idata=this._idata;
		idata[this._index++]=a;
		idata[this._index++]=b;
		idata[this._index++]=c;
		this._setSize();
		return this._index-3;
	}

	__proto.add_iif=function(a,b,c){
		this._need(12);
		var idata=this._idata;
		idata[this._index++]=a;
		idata[this._index++]=b;
		this._fdata[this._index++]=c;
		this._setSize();
		return this._index-3;
	}

	__proto.add_ifi=function(a,b,c){
		this._need(12);
		var idata=this._idata;
		idata[this._index++]=a;
		this._fdata[this._index++]=b;
		idata[this._index++]=c;
		this._setSize();
		return this._index-3;
	}

	__proto.add_iiii=function(a,b,c,d){
		this._need(16);
		var i=this._index;
		var idata=this._idata;
		idata[i]=a;
		idata[i+1]=b;
		idata[i+2]=c;
		idata[i+3]=d;
		this._index+=4;
		this._setSize();
		return i;
	}

	__proto.add_iiif=function(a,b,c,d){
		this._need(16);
		var i=this._index;
		var idata=this._idata;
		idata[i]=a;
		idata[i+1]=b;
		idata[i+2]=c;
		this._fdata[i+3]=d;
		this._index+=4;
		this._setSize();
		return i;
	}

	__proto.add_iiff=function(a,b,c,d){
		this._need(16);
		var i=this._index;
		var idata=this._idata;
		var fdata=this._fdata;
		idata[i]=a;
		idata[i+1]=b;
		fdata[i+2]=c;
		fdata[i+3]=d;
		this._index+=4;
		this._setSize();
		return i;
	}

	__proto.add_iifff=function(a,b,c,d,e){
		this._need(20);
		var i=this._index;
		var idata=this._idata;
		var fdata=this._fdata;
		idata[i]=a;
		idata[i+1]=b;
		fdata[i+2]=c;
		fdata[i+3]=d;
		fdata[i+4]=e;
		this._index+=5;
		this._setSize();
		return i;
	}

	__proto.add_iiffff=function(a,b,c,d,e,f){
		this._need(24);
		var i=this._index;
		var idata=this._idata;
		var fdata=this._fdata;
		idata[i]=a;
		idata[i+1]=b;
		fdata[i+2]=c;
		fdata[i+3]=d;
		fdata[i+4]=e;
		fdata[i+5]=f;
		this._index+=6;
		this._setSize();
		return i;
	}

	__proto.add_iiiii=function(a,b,c,d,e){
		this._need(20);
		var i=this._index;
		var idata=this._idata;
		idata[i]=a;
		idata[i+1]=b;
		idata[i+2]=c;
		idata[i+3]=d;
		idata[i+4]=e;
		this._index+=5;
		this._setSize();
		return i;
	}

	__proto.add_iiiiii=function(a,b,c,d,e,f){
		this._need(24);
		var i=this._index;
		var idata=this._idata;
		idata[i]=a;
		idata[i+1]=b;
		idata[i+2]=c;
		idata[i+3]=d;
		idata[i+4]=e;
		idata[i+5]=f;
		this._index+=6;
		this._setSize();
		return i;
	}

	__proto.add_iiiiiii=function(a,b,c,d,e,f,g){
		this._need(28);
		var i=this._index;
		var idata=this._idata;
		idata[i]=a;
		idata[i+1]=b;
		idata[i+2]=c;
		idata[i+3]=d;
		idata[i+4]=e;
		idata[i+5]=f;
		idata[i+6]=g;
		this._index+=7;
		this._setSize();
		return i;
	}

	__proto.add_blockStart=function(a,data){
		this._need(8);
		var i=this._index;
		var idata=this._idata;
		idata[i]=a;
		idata[i+1]=data._data["_ptrID"];
		this._index+=2;
		this._setSize();
		return i;
	}

	__proto.add_blockEnd=function(a,data){
		this._need(8);
		var i=this._index;
		var idata=this._idata;
		idata[i]=a;
		idata[i+1]=data._data["_ptrID"];
		this._index+=2;
		this._setSize();
		return i;
	}

	__proto.add_blockOne=function(data){
		this._need(16);
		var i=this._index;
		var idata=this._idata;
		idata[i]=15;
		idata[i+1]=data._data["_ptrID"];
		idata[i+2]=16;
		idata[i+3]=data._data["_ptrID"];
		this._index+=4;
		this._setSize();
		return i;
	}

	__proto.add_iff=function(a,b,c){
		this._need(12);
		this._idata[this._index++]=a;
		this._fdata[this._index++]=b;
		this._fdata[this._index++]=c;
		this._setSize();
		return this._index-3;
	}

	__proto.add_iffi=function(a,b,c,d){
		this._need(16);
		this._idata[this._index++]=a;
		this._fdata[this._index++]=b;
		this._fdata[this._index++]=c;
		this._idata[this._index++]=d;
		this._setSize();
		return this._index-4;
	}

	__proto.add_ifffi=function(a,b,c,d,e){
		this._need(20);
		this._idata[this._index++]=a;
		this._fdata[this._index++]=b;
		this._fdata[this._index++]=c;
		this._fdata[this._index++]=d;
		this._idata[this._index++]=e;
		this._setSize();
		return this._index-5;
	}

	__proto.add_iffff=function(a,b,c,d,e){
		this._need(20);
		var i=this._index;
		var fdata=this._fdata;
		this._idata[i]=a;
		fdata[i+1]=b;
		fdata[i+2]=c;
		fdata[i+3]=d;
		fdata[i+4]=e;
		this._index+=5;
		this._setSize();
		return i;
	}

	__proto.add_iffffi=function(a,b,c,d,e,f){
		this._need(24);
		var i=this._index;
		var fdata=this._fdata;
		this._idata[i]=a;
		fdata[i+1]=b;
		fdata[i+2]=c;
		fdata[i+3]=d;
		fdata[i+4]=e;
		this._idata[i+5]=f;
		this._index+=6;
		this._setSize();
		return i;
	}

	__proto.add_ifffffi=function(a,b,c,d,e,f,g){
		this._need(28);
		var i=this._index;
		var fdata=this._fdata;
		this._idata[i]=a;
		fdata[i+1]=b;
		fdata[i+2]=c;
		fdata[i+3]=d;
		fdata[i+4]=e;
		fdata[i+5]=f;
		this._idata[i+6]=g;
		this._index+=7;
		this._setSize();
		return i;
	}

	__proto.add_iffffiif=function(a,b,c,d,e,f,g,h){
		this._need(28);
		var i=this._index;
		var fdata=this._fdata;
		this._idata[i]=a;
		fdata[i+1]=b;
		fdata[i+2]=c;
		fdata[i+3]=d;
		fdata[i+4]=e;
		this._idata[i+5]=f;
		this._idata[i+6]=g;
		fdata[i+7]=h;
		this._index+=8;
		this._setSize();
		return i;
	}

	__proto.add_iffffiii=function(a,b,c,d,e,f,g,h){
		this._need(32);
		var i=this._index;
		var fdata=this._fdata;
		this._idata[i]=a;
		fdata[i+1]=b;
		fdata[i+2]=c;
		fdata[i+3]=d;
		fdata[i+4]=e;
		this._idata[i+5]=f;
		this._idata[i+6]=g;
		this._idata[i+7]=h;
		this._index+=8;
		this._setSize();
		return i;
	}

	__proto.add_iiiiiiii=function(a,b,c,d,e,f,g,h){
		this._need(32);
		var i=this._index;
		var idata=this._idata;
		idata[i]=a;
		idata[i+1]=b;
		idata[i+2]=c;
		idata[i+3]=d;
		idata[i+4]=e;
		idata[i+5]=f;
		idata[i+6]=g;
		idata[i+7]=h;
		this._index+=8;
		this._setSize();
		return i;
	}

	__proto.add_iiiiiiiii=function(a,b,c,d,e,f,g,h,j){
		this._need(36);
		var i=this._index;
		var idata=this._idata;
		idata[i]=a;
		idata[i+1]=b;
		idata[i+2]=c;
		idata[i+3]=d;
		idata[i+4]=e;
		idata[i+5]=f;
		idata[i+6]=g;
		idata[i+7]=h;
		idata[i+8]=j;
		this._index+=9;
		this._setSize();
		return i;
	}

	/*
	public function add_StringForNative(str:String):void {
		_need(str.length *4+4);
		var idata:Int32Array=this._idata;
		idata[_index++]=str.length;
		for (var i:int=0,sz:int=str.length;i < sz;i++){
			idata[_index+i]=str.charCodeAt(i);
		}
		_index+=str.length;
		_setSize();
	}

	*/
	__proto.add_StringForNative=function(str){
		var ab=window.conch.strTobufer(str);
		var len=ab.byteLength;
		this._need(len+4);
		this._idata[this._index++]=len;
		if (len==0)return;
		var uint8array=new Uint8Array(ab);
		this._byteArray.set(uint8array,this._index *4);
		this._index+=len / 4;
		this._setSize();
	}

	__proto.add_String=function(str){
		this._need(1);
		var i=this._index;
		this._idata[i]=str;
		this._index+=1;
		this._setSize();
		return i;
	}

	__proto.set_String=function(index,str){}
	__proto.get_String=function(index){
		return null;
	}

	__proto.add_TextureOne=function(tex){
		this._need(4);
		this._idata[this._index++]=tex._conchTexture.id;
		this._setSize();
		return this._index-1;
	}

	__proto.set_TextureOne=function(index,tex){
		this._idata[index]=tex._conchTexture.id;
	}

	__proto.get_TextureOne=function(index){
		return null;
	}

	__proto.add_Array=function(arr){
		this._need(1);
		var i=this._index;
		this._idata[i]=arr;
		this._index+=1;
		this._setSize();
		return i;
	}

	__proto.add_textureOnly=function(id,tex){
		this._need(8);
		var i=this._index;
		this._idata[i]=id;
		this._idata[i+1]=tex;
		this._index+=2;
		this._setSize();
		return i;
	}

	__proto.add_matrix=function(m){
		this._need(24);
		var i=this._index;
		this._idata[i]=m;
		this._index+=1;
		this._setSize();
		return i;
	}

	__proto.set_matrix=function(index,m){}
	//todo
	__proto.get_matrix=function(index){
		return null;
	}

	__proto.add_texture=function(id,tex,x,y,w,h){
		this._need(24);
		var i=this._index;
		var fdata=this._fdata;
		this._idata[i]=id;
		this._idata[i+1]=tex;
		fdata[i+2]=x;
		fdata[i+3]=y;
		fdata[i+4]=w;
		fdata[i+5]=h;
		this._index+=6;
		this._setSize();
		return i;
	}

	__proto.add_textureWithNative=function(id,tex,x,y,w,h){
		this._need(24);
		var i=this._index;
		var fdata=this._fdata;
		this._idata[i]=id;
		this._idata[i+1]=tex._conchTexture.id;
		fdata[i+2]=x;
		fdata[i+3]=y;
		fdata[i+4]=w;
		fdata[i+5]=h;
		this._index+=6;
		this._setSize();
		return i;
	}

	__proto.add_ShaderValue=function(o){
		this._need(4);
		this._idata[this._index++]=o;
		this._setSize();
		return this._index-1;
	}

	__proto.wab=function(arraybuffer,length,offset){
		(offset===void 0)&& (offset=0);
		offset=offset?offset:0;
		var nAlignLength=(length+3)& 0xfffffffc;
		this._need(nAlignLength+4);
		this._idata[this._index++]=length;
		var ab=null;
		if ((arraybuffer instanceof ArrayBuffer)){
			ab=arraybuffer;
		}
		else if (arraybuffer.buffer){
			ab=arraybuffer.buffer;
		}
		else {
			console.log("not arraybuffer/dataview ");
			return;
		};
		var uint8array=new Uint8Array(ab,offset,length);
		this._byteArray.set(uint8array,this._index *4);
		this._index+=nAlignLength / 4;
		this._setSize();
	}

	__proto.copyBuffer=function(arraybuffer,length,offset){
		(offset===void 0)&& (offset=0);
		offset=offset?offset:0;
		this._need(length);
		var ab=null;
		if ((arraybuffer instanceof ArrayBuffer)){
			ab=arraybuffer;
		}
		else if (arraybuffer.buffer){
			ab=arraybuffer.buffer;
		}
		else {
			console.log("not arraybuffer/dataview ");
			return;
		};
		var uint8array=new Uint8Array(ab,offset,length);
		this._byteArray.set(uint8array,this._index *4);
		this._index+=length / 4;
		this._setSize();
	}

	__getset(0,__proto,'length',function(){
		return this._index *4;
	});

	return GLBuffer;
})()


	//file:///E:/git/layaair-master/core/src/laya/renders/layagl/LayaGL.as=======199.999886/199.999886
/**
*@private
*封装GL命令
*/
//class laya.renders.layagl.LayaGL
var LayaGL=(function(){
	var ProgramLocationTable;
	function LayaGL(reserveSize,adjustSize,isUsrArray,isSyncToRenderThread){
		//------------------------------------------------------------------------------
		this._buffer=null;
		/**@private */
		this._vectorgraphArray=null;
		(reserveSize===void 0)&& (reserveSize=1024);
		(adjustSize===void 0)&& (adjustSize=512);
		(isUsrArray===void 0)&& (isUsrArray=true);
		(isSyncToRenderThread===void 0)&& (isSyncToRenderThread=false);
		this._buffer=new GLBuffer(reserveSize,adjustSize,isUsrArray,isSyncToRenderThread);
	}

	__class(LayaGL,'laya.renders.layagl.LayaGL');
	var __proto=LayaGL.prototype;
	__proto._addVectorGraphicID=function(){
		var tId=0;
		if (Render.isWebGL){
			tId=VectorGraphManager.getInstance().getId();
			if (this._vectorgraphArray==null)this._vectorgraphArray=[];
			this._vectorgraphArray.push(tId);
		}
		this._buffer.add_i(tId);
	}

	__proto._addNoTextureCmd=function(){}
	/**
	*清空buffer
	*这个函数特别为native做的，因为在native中使用完这个buffer会把[0]设置成1
	*所以这个函数只用moveToEnd就可以，就是把index=buffer[0];
	*为什么这样做呢？因为很多下载的回调函数，比如mesh.onload，要把输入append进去，但是渲染的时候又被清空了
	*/
	__proto.clearBufferForNative=function(recoverCmds){
		(recoverCmds===void 0)&& (recoverCmds=false);
		this._buffer.moveToEnd();
		if (this._vectorgraphArray){
			for (var i=0,len=this._vectorgraphArray.length;i < len;i++){
				VectorGraphManager.getInstance().deleteShape(this._vectorgraphArray[i]);
			}
			this._vectorgraphArray.length=0;
		}
	}

	__proto.clearBuffer=function(recoverCmds){
		(recoverCmds===void 0)&& (recoverCmds=false);
		this._buffer.clear();
		if (this._vectorgraphArray){
			for (var i=0,len=this._vectorgraphArray.length;i < len;i++){
				VectorGraphManager.getInstance().deleteShape(this._vectorgraphArray[i]);
			}
			this._vectorgraphArray.length=0;
		}
	}

	__proto.createFakeID=function(){
		return++LayaGL._fakeIDCount;
	}

	__proto.render=function(ctx){
		var cmds=LayaGL._glCmds;
		var i32=this._buffer._idata;
		var f32=this._buffer._fdata;
		for (var ofs=1,size=this._buffer.getCount();ofs < size;){
			ofs+=cmds[i32[ofs]].fun.call(ctx,ctx,i32,f32,ofs+1)+1;
		}
	}

	//ctx.restore();
	__proto.save=function(){
		this._addNoTextureCmd();
		return this._buffer.add_i(LayaGL.SAVE.id);
	}

	__proto.restore=function(){
		this._addNoTextureCmd();
		return this._buffer.add_i(LayaGL.RESTORE.id);
	}

	__proto.translate=function(x,y){
		this._addNoTextureCmd();
		return this._buffer.add_iff(LayaGL.TRANSLATE.id,x,y);
	}

	__proto.fillText=function(text,x,y,font,color,textAlign){
		this._addNoTextureCmd();
		var index=0;
		index=this._buffer.add_iffi(LayaGL.FILL_TEXT.id,x,y,Color.create(color).numColor);
		this._buffer.add_String(text);
		this._buffer.add_String(font || Text.defaultFontStr());
		this._buffer.add_String(textAlign);
		return index;
	}

	__proto.strokeText=function(text,x,y,font,color,lineWidth,textAlign){
		this._addNoTextureCmd();
		var index=0;
		index=this._buffer.add_iffi(LayaGL.STROKE_TEXT.id,x,y,Color.create(color).numColor);
		this._buffer.add_f(lineWidth);
		this._buffer.add_String(text);
		this._buffer.add_String(font || Text.defaultFontStr());
		this._buffer.add_String(textAlign);
		return index;
	}

	__proto.fillBorderText=function(text,x,y,font,fillColor,borderColor,lineWidth,textAlign){
		this._addNoTextureCmd();
		var index=0;
		index=this._buffer.add_iffi(LayaGL.FILLBORDER_TEXT.id,x,y,Color.create(fillColor).numColor);
		this._buffer.add_f(lineWidth);
		this._buffer.add_String(text);
		this._buffer.add_String(font || Text.defaultFontStr());
		this._buffer.add_String(textAlign);
		this._buffer.add_i(Color.create(borderColor).numColor);
		return index;
	}

	__proto.fillRect=function(x,y,width,height,bgColor,lineColor,lineWidth){
		(lineWidth===void 0)&& (lineWidth=1);
		this._addNoTextureCmd();
		var offset=lineColor ? lineWidth / 2 :0;
		var lineOffset=lineColor ? lineWidth :0;
		var _index=0;
		_index=this._buffer.add_iffffii(LayaGL.FILL_RECT.id,x+offset,y+offset,width-lineOffset,height-lineOffset,Color.create(bgColor).numColor,Color.create(lineColor).numColor);
		this._buffer.add_f(lineWidth);
		return _index;
	}

	__proto.clipRect=function(x,y,w,h,bgColor){
		this._addNoTextureCmd();
		return this._buffer.add_iffff(LayaGL.CLIP_RECT.id,x,y,w,h);
	}

	__proto.drawLine=function(fromX,fromY,toX,toY,color,lineWidth){
		(lineWidth===void 0)&& (lineWidth=1);
		this._addNoTextureCmd();
		var offset=lineWidth % 2===0 ? 0 :0.5;
		fromX+=offset;
		fromY+=offset;
		toX+=offset;
		toY+=offset;
		var _index=0;
		_index=this._buffer.add_ifffffi(LayaGL.DRAW_LINE.id,fromX,fromY,toX,toY,lineWidth,Color.create(color).numColor);
		this._addVectorGraphicID();
		return _index;
	}

	/**
	*绘制一系列线段。
	*@param x 开始绘制的X轴位置。
	*@param y 开始绘制的Y轴位置。
	*@param points 线段的点集合。格式:[x1,y1,x2,y2,x3,y3...]。
	*@param lineColor 线段颜色，或者填充绘图的渐变对象。
	*@param lineWidth （可选）线段宽度。
	*/
	__proto.drawLines=function(x,y,points,lineColor,lineWidth){
		(lineWidth===void 0)&& (lineWidth=1);
		this._addNoTextureCmd();
		if (!points || points.length < 4)return-1;
		var offset=lineWidth % 2===0 ? 0 :0.5;
		var _index=0;
		_index=this._buffer.add_ifffi(LayaGL.DRAW_LINES.id,x+offset,y+offset,lineWidth,Color.create(lineColor).numColor);
		this._buffer.add_Array(points);
		this._addVectorGraphicID();
		return _index;
	}

	/**
	*绘制一系列曲线。
	*@param x 开始绘制的 X 轴位置。
	*@param y 开始绘制的 Y 轴位置。
	*@param points 线段的点集合，格式[startx,starty,ctrx,ctry,startx,starty...]。
	*@param lineColor 线段颜色，或者填充绘图的渐变对象。
	*@param lineWidth （可选）线段宽度。
	*/
	__proto.drawCurves=function(x,y,points,lineColor,lineWidth){
		(lineWidth===void 0)&& (lineWidth=1);
		this._addNoTextureCmd();
		var _index=0;
		_index=this._buffer.add_ifffi(LayaGL.DRAW_CURVES.id,x,y,lineWidth,Color.create(lineColor).numColor);
		this._buffer.add_Array(points);
		return _index;
	}

	/**
	*绘制多边形。
	*@param x 开始绘制的 X 轴位置。
	*@param y 开始绘制的 Y 轴位置。
	*@param points 多边形的点集合。
	*@param fillColor 填充颜色，或者填充绘图的渐变对象。
	*@param lineColor （可选）边框颜色，或者填充绘图的渐变对象。
	*@param lineWidth （可选）边框宽度。
	*/
	__proto.drawPoly=function(x,y,points,fillColor,lineColor,lineWidth){
		(lineWidth===void 0)&& (lineWidth=1);
		this._addNoTextureCmd();
		var tIsConvexPolygon=false;
		if (Render.isWebGL){
			if (points.length > 6){
				tIsConvexPolygon=false;
				}else {
				tIsConvexPolygon=true;
			}
		};
		var offset=lineColor ? (lineWidth % 2===0 ? 0 :0.5):0;
		var _index=0;
		_index=this._buffer.add_ifffi(LayaGL.DRAW_POLY.id,x+offset,y+offset,lineWidth,Color.create(lineColor).numColor);
		this._buffer.add_Array(points);
		this._buffer.add_i(Color.create(fillColor).numColor);
		this._buffer.add_i(tIsConvexPolygon ? 1 :0);
		this._addVectorGraphicID();
		return _index;
	}

	/**
	*绘制一组三角形
	*@param tex 纹理。
	*@param x X轴偏移量。
	*@param y Y轴偏移量。
	*@param vertices 顶点数组。
	*@param indices 顶点索引。
	*@param uvData UV数据
	*@param matrix 缩放矩阵。
	*/
	__proto.drawTriangles=function(texture,x,y,vertices,uvs,indices,matrix,alpha,color,blendMode){
		(alpha===void 0)&& (alpha=1);
		var _index=0;
		_index=this._buffer.add_textureOnly(LayaGL.DRAW_TRIANGLES.id,texture);
		this._buffer.add_ff(x,y);
		this._buffer.add_Array(vertices);
		this._buffer.add_Array(uvs);
		this._buffer.add_Array(indices);
		this._buffer.add_matrix(matrix);
		this._buffer.add_f(alpha);
		this._buffer.add_i(Color.create(color).numColor);
		this._buffer.add_String(blendMode);
		return _index;
	}

	/**
	*批量绘制同样纹理。
	*@param tex 纹理。
	*@param pos 绘制坐标。
	*/
	__proto.drawTextures=function(tex,pos){
		if (!tex)return-1;
		this._addNoTextureCmd();
		var _index=0;
		_index=this._buffer.add_textureOnly(LayaGL.DRAW_TEXTURES.id,tex);
		this._buffer.add_Array(pos);
		return _index;
	}

	__proto.drawCircle=function(x,y,radius,fillColor,lineColor,lineWidth){
		(lineWidth===void 0)&& (lineWidth=1);
		this._addNoTextureCmd();
		var _index=0;
		_index=this._buffer.add_iffffii(LayaGL.DRAW_CIRCLE.id,x,y,radius,lineWidth,Color.create(fillColor).numColor,Color.create(lineColor).numColor);
		this._addVectorGraphicID();
		return _index;
	}

	/**
	*绘制扇形。
	*@param x 开始绘制的 X 轴位置。
	*@param y 开始绘制的 Y 轴位置。
	*@param radius 扇形半径。
	*@param startAngle 开始角度。
	*@param endAngle 结束角度。
	*@param fillColor 填充颜色，或者填充绘图的渐变对象。
	*@param lineColor （可选）边框颜色，或者填充绘图的渐变对象。
	*@param lineWidth （可选）边框宽度。
	*/
	__proto.drawPie=function(x,y,radius,startAngle,endAngle,fillColor,lineColor,lineWidth){
		(lineWidth===void 0)&& (lineWidth=1);
		this._addNoTextureCmd();
		var offset=lineColor ? lineWidth / 2 :0;
		var lineOffset=lineColor ? lineWidth :0;
		startAngle=Utils.toRadian(startAngle);
		endAngle=Utils.toRadian(endAngle);
		var _index=0;
		_index=this._buffer.add_iffffii(LayaGL.DRAW_PIE.id,x+offset,y+offset,radius-lineOffset,lineWidth,Color.create(fillColor).numColor,Color.create(lineColor).numColor);
		this._buffer.add_f(startAngle);
		this._buffer.add_f(endAngle);
		this._addVectorGraphicID();
		return _index;
	}

	__proto.drawImage=function(tex,x,y,width,height){
		return this._buffer.add_texture(LayaGL.DRAW_IMAGE.id,tex,x,y,width,height);
	}

	__proto.drawTexture=function(tex,x,y,width,height,m,alpha,color,blendMode){
		(x===void 0)&& (x=0);
		(y===void 0)&& (y=0);
		(width===void 0)&& (width=0);
		(height===void 0)&& (height=0);
		(alpha===void 0)&& (alpha=1);
		var _index=0;
		_index=this._buffer.add_texture(LayaGL.DRAW_TEXTURE.id,tex,x,y,width,height);
		this._buffer.add_matrix(m);
		this._buffer.add_f(alpha);
		this._buffer.add_i(Color.create(color).numColor);
		this._buffer.add_String(blendMode);
		return _index;
	}

	/**
	*用texture填充。
	*@param tex 纹理。
	*@param x X轴偏移量。
	*@param y Y轴偏移量。
	*@param width （可选）宽度。
	*@param height （可选）高度。
	*@param type （可选）填充类型 repeat|repeat-x|repeat-y|no-repeat
	*@param offset （可选）贴图纹理偏移
	*
	*/
	__proto.fillTexture=function(tex,x,y,width,height,type,offset){
		(width===void 0)&& (width=0);
		(height===void 0)&& (height=0);
		(type===void 0)&& (type="repeat");
		if (!tex)return;
		var _index=0;
		_index=this._buffer.add_texture(LayaGL.FILL_TEXTURE.id,tex,x,y,width,height);
		this._buffer.add_String(type);
		this._buffer.add_point(offset || Point.EMPTY);
		this._buffer.add_object({});
		return _index;
	}

	__proto.blockStart=function(data){
		return this._buffer.add_blockStart(15,data);
	}

	__proto.blockEnd=function(data){
		return this._buffer.add_blockEnd(16,data);
	}

	__proto.blockOne=function(data){
		return this._buffer.add_blockOne(data);
	}

	__proto.drawCanvas=function(args){
		debugger;
		return 0;
	}

	//------------------------------------------------------------------------------
	__proto.getContextAttributes=function(){
		return LayaGL.webGLContext.getContextAttributes();
	}

	__proto.isContextLost=function(){
		LayaGL.webGLContext.isContextLost();
	}

	__proto.getSupportedExtensions=function(){
		return LayaGL.webGLContext.getSupportedExtensions();
	}

	__proto.getExtension=function(name){
		return LayaGL.webGLContext.getExtension(name);
	}

	__proto.activeTexture=function(texture){
		LayaGL.webGLContext.activeTexture(texture);
	}

	__proto.attachShader=function(program,shader){
		LayaGL.webGLContext.attachShader(program,shader);
	}

	__proto.bindAttribLocation=function(program,index,name){
		LayaGL.webGLContext.bindAttribLocation(program,index,name);
	}

	__proto.bindBuffer=function(target,buffer){
		LayaGL.webGLContext.bindBuffer(target,buffer);
	}

	__proto.bindFramebuffer=function(target,framebuffer){
		LayaGL.webGLContext.bindFramebuffer(target,framebuffer);
	}

	__proto.bindRenderbuffer=function(target,renderbuffer){
		LayaGL.webGLContext.bindRenderbuffer(target,renderbuffer);
	}

	__proto.bindTexture=function(target,texture){
		LayaGL.webGLContext.bindTexture(target,texture);
	}

	__proto.useTexture=function(value){
		LayaGL.webGLContext.useTexture(value);
	}

	__proto.blendColor=function(red,green,blue,alpha){
		LayaGL.webGLContext.blendColor(red,green,blue,alpha);
	}

	__proto.blendEquation=function(mode){
		LayaGL.webGLContext.blendEquation(mode);
	}

	__proto.blendEquationSeparate=function(modeRGB,modeAlpha){
		LayaGL.webGLContext.blendEquationSeparate(modeRGB,modeAlpha);
	}

	__proto.blendFunc=function(sfactor,dfactor){
		LayaGL.webGLContext.blendFunc(sfactor,dfactor);
	}

	__proto.blendFuncSeparate=function(srcRGB,dstRGB,srcAlpha,dstAlpha){
		LayaGL.webGLContext.blendFuncSeparate(srcRGB,dstRGB,srcAlpha,dstAlpha);
	}

	__proto.bufferData=function(target,size,usage){
		LayaGL.webGLContext.bufferData(target,size,usage);
	}

	__proto.bufferSubData=function(target,offset,data){
		LayaGL.webGLContext.bufferSubData(target,offset,data);
	}

	__proto.checkFramebufferStatus=function(target){
		return LayaGL.webGLContext.checkFramebufferStatus(target);
	}

	__proto.clear=function(mask){
		LayaGL.webGLContext.clear(mask);
	}

	__proto.clearColor=function(red,green,blue,alpha){
		LayaGL.webGLContext.clearColor(red,green,blue,alpha);
	}

	__proto.clearDepth=function(depth){
		LayaGL.webGLContext.clearDepth(depth);
	}

	__proto.clearStencil=function(s){
		LayaGL.webGLContext.clearStencil(s);
	}

	__proto.colorMask=function(red,green,blue,alpha){
		LayaGL.webGLContext.colorMask(red,green,blue,alpha);
	}

	__proto.compileShader=function(shader){
		LayaGL.webGLContext.compileShader(shader);
	}

	__proto.copyTexImage2D=function(target,level,internalformat,x,y,width,height,border){
		LayaGL.webGLContext.copyTexImage2D(target,level,internalformat,x,y,width,height,border);
	}

	__proto.copyTexSubImage2D=function(target,level,xoffset,yoffset,x,y,width,height){
		LayaGL.webGLContext.copyTexSubImage2D(target,level,xoffset,yoffset,x,y,width,height);
	}

	__proto.createBuffer=function(){
		return LayaGL.webGLContext.createBuffer();
	}

	__proto.createFramebuffer=function(){
		return LayaGL.webGLContext.createFramebuffer();
	}

	__proto.createProgram=function(){
		return LayaGL.webGLContext.createProgram();
	}

	__proto.createRenderbuffer=function(){
		return LayaGL.webGLContext.createRenderbuffer();
	}

	__proto.createShader=function(type){
		return LayaGL.webGLContext.createShader(type);
	}

	__proto.createTexture=function(){
		return LayaGL.webGLContext.createTexture();
	}

	__proto.cullFace=function(mode){
		LayaGL.webGLContext.cullFace(mode);
	}

	__proto.deleteBuffer=function(buffer){
		LayaGL.webGLContext.deleteBuffer(buffer);
	}

	__proto.deleteFramebuffer=function(framebuffer){
		LayaGL.webGLContext.deleteFramebuffer(framebuffer);
	}

	__proto.deleteProgram=function(program){
		LayaGL.webGLContext.deleteProgram(program);
	}

	__proto.deleteRenderbuffer=function(renderbuffer){
		LayaGL.webGLContext.deleteRenderbuffer(renderbuffer);
	}

	__proto.deleteShader=function(shader){
		LayaGL.webGLContext.deleteShader(shader);
	}

	__proto.deleteTexture=function(texture){
		LayaGL.webGLContext.deleteTexture(texture);
	}

	__proto.depthFunc=function(func){
		LayaGL.webGLContext.depthFunc(func);
	}

	__proto.depthMask=function(flag){
		LayaGL.webGLContext.depthMask(flag);
	}

	__proto.depthRange=function(zNear,zFar){
		LayaGL.webGLContext.depthRange(zNear,zFar);
	}

	__proto.detachShader=function(program,shader){
		LayaGL.webGLContext.detachShader(program,shader);
	}

	__proto.disable=function(cap){
		LayaGL.webGLContext.disable(cap);
	}

	__proto.disableVertexAttribArray=function(index){
		LayaGL.webGLContext.disableVertexAttribArray(index);
	}

	__proto.drawArrays=function(mode,first,count){
		LayaGL.webGLContext.drawArrays(mode,first,count);
	}

	__proto.drawElements=function(mode,count,type,offset){
		LayaGL.webGLContext.drawElements(mode,count,type,offset);
	}

	__proto.enable=function(cap){
		LayaGL.webGLContext.enable(cap);
	}

	__proto.enableVertexAttribArray=function(index){
		LayaGL.webGLContext.enableVertexAttribArray(index);
	}

	__proto.finish=function(){
		LayaGL.webGLContext.finish();
	}

	__proto.flush=function(){
		LayaGL.webGLContext.flush();
	}

	__proto.framebufferRenderbuffer=function(target,attachment,renderbuffertarget,renderbuffer){
		LayaGL.webGLContext.framebufferRenderbuffer(target,attachment,renderbuffertarget,renderbuffer);
	}

	__proto.framebufferTexture2D=function(target,attachment,textarget,texture,level){
		LayaGL.webGLContext.framebufferTexture2D(target,attachment,textarget,texture,level);
	}

	__proto.frontFace=function(mode){
		return LayaGL.webGLContext.frontFace(mode);
	}

	__proto.generateMipmap=function(target){
		return LayaGL.webGLContext.generateMipmap(target);
	}

	__proto.getActiveAttrib=function(program,index){
		return LayaGL.webGLContext.getActiveAttrib(program,index);
	}

	__proto.getActiveUniform=function(program,index){
		return LayaGL.webGLContext.getActiveUniform(program,index);
	}

	__proto.getAttribLocation=function(program,name){
		return LayaGL.webGLContext.getAttribLocation(program,name);
	}

	__proto.getParameter=function(pname){
		return LayaGL.webGLContext.getParameter(pname);
	}

	__proto.getBufferParameter=function(target,pname){
		return LayaGL.webGLContext.getBufferParameter(target,pname);
	}

	__proto.getError=function(){
		return LayaGL.webGLContext.getError();
	}

	__proto.getFramebufferAttachmentParameter=function(target,attachment,pname){
		LayaGL.webGLContext.getFramebufferAttachmentParameter(target,attachment,pname);
	}

	__proto.getProgramParameter=function(program,pname){
		return LayaGL.webGLContext.getProgramParameter(program,pname);
	}

	__proto.getProgramInfoLog=function(program){
		return LayaGL.webGLContext.getProgramInfoLog(program);
	}

	__proto.getRenderbufferParameter=function(target,pname){
		return LayaGL.webGLContext.getRenderbufferParameter(target,pname);
	}

	__proto.getShaderPrecisionFormat=function(__arg){
		var arg=arguments;
		return LayaGL.webGLContext.getShaderPrecisionFormat(arg);
	}

	__proto.getShaderParameter=function(shader,pname){
		LayaGL.webGLContext.getShaderParameter(shader,pname);
	}

	__proto.getShaderInfoLog=function(shader){
		return LayaGL.webGLContext.getShaderInfoLog(shader);
	}

	__proto.getShaderSource=function(shader){
		return LayaGL.webGLContext.getShaderSource(shader);
	}

	__proto.getTexParameter=function(target,pname){
		LayaGL.webGLContext.getTexParameter(target,pname);
	}

	__proto.getUniform=function(program,location){
		LayaGL.webGLContext.getUniform(program,location);
	}

	__proto.getUniformLocation=function(program,name){
		return LayaGL.webGLContext.getUniformLocation(program,name);
	}

	__proto.getVertexAttrib=function(index,pname){
		return LayaGL.webGLContext.getVertexAttrib(index,pname);
	}

	__proto.getVertexAttribOffset=function(index,pname){
		return LayaGL.webGLContext.getVertexAttribOffset(index,pname);
	}

	__proto.hint=function(target,mode){
		LayaGL.webGLContext.hint(target,mode);
	}

	__proto.isBuffer=function(buffer){
		LayaGL.webGLContext.isBuffer(buffer);
	}

	__proto.isEnabled=function(cap){
		LayaGL.webGLContext.isEnabled(cap);
	}

	__proto.isFramebuffer=function(framebuffer){
		LayaGL.webGLContext.isFramebuffer(framebuffer);
	}

	__proto.isProgram=function(program){
		LayaGL.webGLContext.isProgram(program);
	}

	__proto.isRenderbuffer=function(renderbuffer){
		LayaGL.webGLContext.isRenderbuffer(renderbuffer);
	}

	__proto.isShader=function(shader){
		LayaGL.webGLContext.isShader(shader);
	}

	__proto.isTexture=function(texture){
		LayaGL.webGLContext.isTexture(texture);
	}

	__proto.lineWidth=function(width){
		LayaGL.webGLContext.lineWidth(width);
	}

	__proto.linkProgram=function(program){
		LayaGL.webGLContext.linkProgram(program);
	}

	__proto.pixelStorei=function(pname,param){
		LayaGL.webGLContext.pixelStorei(pname,param);
	}

	__proto.polygonOffset=function(factor,units){
		LayaGL.webGLContext.polygonOffset(factor,units);
	}

	__proto.readPixels=function(x,y,width,height,format,type,pixels){
		LayaGL.webGLContext.readPixels(x,y,width,height,format,type,pixels);
	}

	__proto.renderbufferStorage=function(target,internalformat,width,height){
		LayaGL.webGLContext.renderbufferStorage(target,internalformat,width,height);
	}

	__proto.sampleCoverage=function(value,invert){
		LayaGL.webGLContext.sampleCoverage(value,invert);
	}

	__proto.scissor=function(x,y,width,height){
		LayaGL.webGLContext.scissor(x,y,width,height);
	}

	__proto.shaderSource=function(shader,source){
		LayaGL.webGLContext.shaderSource(shader,source);
	}

	__proto.stencilFunc=function(func,ref,mask){
		LayaGL.webGLContext.stencilFunc(func,ref,mask);
	}

	__proto.stencilFuncSeparate=function(face,func,ref,mask){
		LayaGL.webGLContext.stencilFuncSeparate(face,func,ref,mask);
	}

	__proto.stencilMask=function(mask){
		LayaGL.webGLContext.stencilMask(mask);
	}

	__proto.stencilMaskSeparate=function(face,mask){
		LayaGL.webGLContext.stencilMaskSeparate(face,mask);
	}

	__proto.stencilOp=function(fail,zfail,zpass){
		LayaGL.webGLContext.stencilOp(fail,zfail,zpass);
	}

	__proto.stencilOpSeparate=function(face,fail,zfail,zpass){
		LayaGL.webGLContext.stencilOpSeparate(face,fail,zfail,zpass);
	}

	__proto.texImage2D=function(__args){
		var args=arguments;
		LayaGL.webGLContext.texImage2D(args);
	}

	__proto.texParameterf=function(target,pname,param){
		LayaGL.webGLContext.texParameterf(target,pname,param);
	}

	__proto.texParameteri=function(target,pname,param){
		LayaGL.webGLContext.texParameteri(target,pname,param);
	}

	__proto.texSubImage2D=function(__args){
		var args=arguments;
		LayaGL.webGLContext.texSubImage2D(args);
	}

	__proto.uniform1f=function(location,x){
		LayaGL.webGLContext.uniform1f(location,x);
	}

	__proto.uniform1fv=function(location,v){
		LayaGL.webGLContext.uniform1fv(location,v);
	}

	__proto.uniform1i=function(location,x){
		LayaGL.webGLContext.uniform1i(location,x);
	}

	__proto.uniform1iv=function(location,v){
		LayaGL.webGLContext.uniform1iv(location,v);
	}

	__proto.uniform2f=function(location,x,y){
		LayaGL.webGLContext.uniform2f(location,x,y);
	}

	__proto.uniform2fv=function(location,v){
		LayaGL.webGLContext.uniform2fv(location,v);
	}

	__proto.uniform2i=function(location,x,y){
		LayaGL.webGLContext.uniform2i(location,x,y);
	}

	__proto.uniform2iv=function(location,v){
		LayaGL.webGLContext.uniform2iv(location,v);
	}

	__proto.uniform3f=function(location,x,y,z){
		LayaGL.webGLContext.uniform3f(location,x,y,z);
	}

	__proto.uniform3fv=function(location,v){
		LayaGL.webGLContext.uniform3fv(location,v);
	}

	__proto.uniform3i=function(location,x,y,z){
		LayaGL.webGLContext.uniform3i(location,x,y,z);
	}

	__proto.uniform3iv=function(location,v){
		LayaGL.webGLContext.uniform3iv(location,v);
	}

	__proto.uniform4f=function(location,x,y,z,w){
		LayaGL.webGLContext.uniform4f(location,x,y,z,w);
	}

	__proto.uniform4fv=function(location,v){
		LayaGL.webGLContext.uniform4fv(location,v);
	}

	__proto.uniform4i=function(location,x,y,z,w){
		LayaGL.webGLContext.uniform4i(location,x,y,z,w);
	}

	__proto.uniform4iv=function(location,v){
		LayaGL.webGLContext.uniform4iv(location,v);
	}

	__proto.uniformMatrix2fv=function(location,transpose,value){
		LayaGL.webGLContext.uniformMatrix2fv(location,transpose,value);
	}

	__proto.uniformMatrix3fv=function(location,transpose,value){
		LayaGL.webGLContext.uniformMatrix3fv(location,transpose,value);
	}

	__proto.uniformMatrix4fv=function(location,transpose,value){
		LayaGL.webGLContext.uniformMatrix4fv(location,transpose,value);
	}

	__proto.useProgram=function(program){
		LayaGL.webGLContext.useProgram(program);
	}

	__proto.validateProgram=function(program){
		LayaGL.webGLContext.validateProgram(program);
	}

	__proto.vertexAttrib1f=function(indx,x){
		LayaGL.webGLContext.vertexAttrib1f(indx,x);
	}

	__proto.vertexAttrib1fv=function(indx,values){
		LayaGL.webGLContext.vertexAttrib1fv(indx,values);
	}

	__proto.vertexAttrib2f=function(indx,x,y){
		LayaGL.webGLContext.vertexAttrib2f(indx,x,y);
	}

	__proto.vertexAttrib2fv=function(indx,values){
		LayaGL.webGLContext.vertexAttrib2fv(indx,values);
	}

	__proto.vertexAttrib3f=function(indx,x,y,z){
		LayaGL.webGLContext.vertexAttrib3f(indx,x,y,z);
	}

	__proto.vertexAttrib3fv=function(indx,values){
		LayaGL.webGLContext.vertexAttrib3fv(indx,values);
	}

	__proto.vertexAttrib4f=function(indx,x,y,z,w){
		LayaGL.webGLContext.vertexAttrib4f(indx,x,y,z,w);
	}

	__proto.vertexAttrib4fv=function(indx,values){
		LayaGL.webGLContext.vertexAttrib4fv(indx,values);
	}

	__proto.vertexAttribPointer=function(indx,size,type,normalized,stride,offset){
		LayaGL.webGLContext.vertexAttribPointer(indx,size,type,normalized,stride,offset);
	}

	__proto.viewport=function(x,y,width,height){
		LayaGL.webGLContext.viewport(x,y,width,height);
	}

	__proto.configureBackBuffer=function(width,height,antiAlias,enableDepthAndStencil,wantsBestResolution){
		(enableDepthAndStencil===void 0)&& (enableDepthAndStencil=true);
		(wantsBestResolution===void 0)&& (wantsBestResolution=false);
		LayaGL.webGLContext.configureBackBuffer(width,height,antiAlias,enableDepthAndStencil,wantsBestResolution);
	}

	__proto.compressedTexImage2D=function(__args){
		var args=arguments;
		LayaGL.webGLContext.compressedTexImage2D(args);
	}

	/**
	*@private
	*添加shaderAttribute变量。
	*/
	__proto.addShaderAttribute=function(one){
		this._buffer.add_ShaderValue(one);
	}

	/**
	*@private
	*添加shaderUniform变量。
	*/
	__proto.addShaderUniform=function(one){
		this._buffer.add_ShaderValue(one);
	}

	//------------------------------------------------------------------------------
	__proto.getContextAttributesForNative=function(){
		console.log("getContextAttributes can't support");
		return null;
	}

	__proto.isContextLostForNative=function(){
		console.log("isContextLost can't support");
		return false;
	}

	__proto.getSupportedExtensionsForNative=function(){
		console.log("getSupportedExtensions can't support");
		return 0;
	}

	__proto.getExtensionForNative=function(name){
		console.log("getExtension can't support");
		return null;
	}

	__proto.activeTextureForNative=function(texture){
		this._buffer.add_ii(68,texture);
	}

	__proto.attachShaderForNative=function(program,shader){
		this._buffer.add_iii(69,program,shader);
	}

	__proto.bindAttribLocationForNative=function(program,index,name){
		this._buffer.add_iii(70,program,index);
		this._buffer.add_String(name);
	}

	__proto.bindBufferForNative=function(target,buffer){
		this._buffer.add_iii(71,target,buffer);
	}

	__proto.bindFramebufferForNative=function(target,framebuffer){
		this._buffer.add_iii(72,target,framebuffer);
	}

	__proto.bindRenderbufferForNative=function(target,renderbuffer){
		this._buffer.add_iii(73,target,renderbuffer);
	}

	__proto.bindTextureForNative=function(target,texture){
		this._buffer.add_iii(74,target,texture);
	}

	__proto.useTextureForNative=function(value){
		this._buffer.add_ii(75,value);
	}

	__proto.blendColorForNative=function(red,green,blue,alpha){
		this._buffer.add_iffff(76,red,green,blue,alpha);
	}

	__proto.blendEquationForNative=function(mode){
		this._buffer.add_ii(77,mode);
	}

	__proto.blendEquationSeparateForNative=function(modeRGB,modeAlpha){
		this._buffer.add_iii(78,modeRGB,modeAlpha);
	}

	__proto.blendFuncForNative=function(sfactor,dfactor){
		this._buffer.add_iii(79,sfactor,dfactor);
	}

	__proto.blendFuncSeparateForNative=function(srcRGB,dstRGB,srcAlpha,dstAlpha){
		this._buffer.add_iiiii(80,srcRGB,dstRGB,srcAlpha,dstAlpha);
	}

	__proto.bufferDataForNative=function(target,sizeOrArray,usage){
		if ((typeof sizeOrArray=='number')){
			this._buffer.add_iiii(81,target,sizeOrArray,usage);
			}else {
			this._buffer.add_iii(82,target,usage);
			this._buffer.wab(sizeOrArray,sizeOrArray.byteLength);
		}
	}

	__proto.bufferSubDataForNative=function(target,offset,data){
		this._buffer.add_iii(83,target,offset);
		this._buffer.wab(data,data.byteLength);
	}

	__proto.checkFramebufferStatusForNative=function(target){
		console.log("checkFramebufferStatus can't support");
		return true;
	}

	__proto.clearForNative=function(mask){
		this._buffer.add_ii(85,mask);
	}

	__proto.clearColorForNative=function(red,green,blue,alpha){
		this._buffer.add_iffff(86,red,green,blue,alpha);
	}

	__proto.clearDepthForNative=function(depth){
		this._buffer.add_if(87,depth);
	}

	__proto.clearStencilForNative=function(s){
		this._buffer.add_ii(88,s);
	}

	__proto.colorMaskForNative=function(red,green,blue,alpha){
		this._buffer.add_iiiii(89,red,green,blue,alpha);
	}

	__proto.compileShaderForNative=function(shader){
		this._buffer.add_ii(90,shader);
	}

	__proto.copyTexImage2DForNative=function(target,level,internalformat,x,y,width,height,border){
		this._buffer.add_iiiiiiiii(91,target,level,internalformat,x,y,width,height,border);
	}

	__proto.copyTexSubImage2DForNative=function(target,level,xoffset,yoffset,x,y,width,height){
		this._buffer.add_iiiiiiiii(92,target,level,xoffset,yoffset,x,y,width,height);
	}

	__proto.createBufferForNative=function(){
		var fakeID=this.createFakeID();
		this._buffer.add_ii(93,fakeID);
		return fakeID;
	}

	__proto.createFramebufferForNative=function(){
		var fakeID=this.createFakeID();
		this._buffer.add_ii(94,fakeID);
		return fakeID;
	}

	__proto.createProgramForNative=function(){
		var fakeID=this.createFakeID();
		this._buffer.add_ii(95,fakeID);
		return fakeID;
	}

	__proto.createRenderbufferForNative=function(){
		var fakeID=this.createFakeID();
		this._buffer.add_ii(96,fakeID);
		return fakeID;
	}

	__proto.createShaderForNative=function(type){
		var fakeID=this.createFakeID();
		this._buffer.add_iii(97,fakeID,type);
		return fakeID;
	}

	__proto.createTextureForNative=function(){
		var fakeID=this.createFakeID();
		this._buffer.add_ii(98,fakeID);
		return fakeID;
	}

	__proto.cullFaceForNative=function(mode){
		this._buffer.add_ii(99,mode);
	}

	__proto.deleteBufferForNative=function(buffer){
		this._buffer.add_ii(100,buffer);
	}

	__proto.deleteFramebufferForNative=function(framebuffer){
		this._buffer.add_ii(101,framebuffer);
	}

	__proto.deleteProgramForNative=function(program){
		this._buffer.add_ii(102,program);
	}

	__proto.deleteRenderbufferForNative=function(renderbuffer){
		this._buffer.add_ii(103,renderbuffer);
	}

	__proto.deleteShaderForNative=function(shader){
		this._buffer.add_ii(104,shader);
	}

	__proto.deleteTextureForNative=function(texture){
		this._buffer.add_ii(105,texture);
	}

	__proto.depthFuncForNative=function(func){
		this._buffer.add_ii(106,func);
	}

	__proto.depthMaskForNative=function(flag){
		this._buffer.add_ii(107,flag);
	}

	__proto.depthRangeForNative=function(zNear,zFar){
		this._buffer.add_iff(108,zNear,zFar);
	}

	__proto.detachShaderForNative=function(program,shader){
		this._buffer.add_iii(109,program,shader);
	}

	__proto.disableForNative=function(cap){
		this._buffer.add_ii(110,cap);
	}

	__proto.disableVertexAttribArrayForNative=function(index){
		this._buffer.add_ii(111,index);
	}

	__proto.drawArraysForNative=function(mode,first,count){
		this._buffer.add_iiii(112,mode,first,count);
	}

	__proto.drawElementsForNative=function(mode,count,type,offset){
		this._buffer.add_iiiii(113,mode,count,type,offset);
	}

	__proto.enableForNative=function(cap){
		this._buffer.add_ii(114,cap);
	}

	__proto.enableVertexAttribArrayForNative=function(index){
		this._buffer.add_ii(115,index);
	}

	__proto.finishForNative=function(){
		this._buffer.add_i(116);
	}

	__proto.flushForNative=function(){
		this._buffer.add_i(117);
	}

	__proto.framebufferRenderbufferForNative=function(target,attachment,renderbuffertarget,renderbuffer){
		this._buffer.add_iiiii(118,target,attachment,renderbuffertarget,renderbuffer);
	}

	__proto.framebufferTexture2DForNative=function(target,attachment,textarget,texture,level){
		this._buffer.add_iiiiii(119,target,attachment,textarget,texture,level);
	}

	__proto.frontFaceForNative=function(mode){
		this._buffer.add_ii(120,mode);
	}

	__proto.generateMipmapForNative=function(target){
		this._buffer.add_ii(121,target);
	}

	__proto.getActiveAttribForNative=function(program,index){
		alert("getActiveAttribForNative");
		console.log("getActiveAttrib can't support");
	}

	__proto.getActiveUniformForNative=function(program,index){
		alert("getActiveUniformForNative");
		console.log("getActiveUniform can't support");
	}

	__proto.getAttribLocationForNative=function(program,name){
		var fakeLoc=LayaGL._locTable.getFakeLocation(program,name);
		this._buffer.add_iii(124,program,fakeLoc);
		this._buffer.add_String(name);
		return fakeLoc;
	}

	__proto.getParameterForNative=function(pname){
		var fakeID=this.createFakeID();
		this._buffer.add_iii(125,pname,fakeID);
		return fakeID;
	}

	__proto.getBufferParameterForNative=function(target,pname){
		console.log("getBufferParameter can't support");
		return 0;
	}

	__proto.getErrorForNative=function(){
		console.log("getError can't support");
		return 0;
	}

	__proto.getFramebufferAttachmentParameterForNative=function(target,attachment,pname){
		console.log("getFramebufferAttachmentParameter can't support");
	}

	__proto.getProgramParameterForNative=function(program,pname){
		console.log("getProgramParameter can't support");
		return 0;
	}

	__proto.getProgramInfoLogForNative=function(program){
		console.log("getProgramInfoLog can't support");
		return 0;
	}

	__proto.getRenderbufferParameterForNative=function(target,pname){
		console.log("getRenderbufferParameter can't support");
	}

	__proto.getShaderPrecisionFormatForNative=function(__arg){
		var arg=arguments;
		console.log("getShaderPrecision can't support");
	}

	__proto.getShaderParameterForNative=function(shader,pname){
		console.log("getShaderParameter can't support");
	}

	__proto.getShaderInfoLogForNative=function(shader){
		console.log("getShaderInfoLog can't support");
	}

	__proto.getShaderSourceForNative=function(shader){
		console.log("getShaderSource can't support");
	}

	__proto.getTexParameterForNative=function(target,pname){
		console.log("getTexParameter can't support");
	}

	__proto.getUniformForNative=function(program,location){
		console.log("getUniform can't support");
	}

	__proto.getUniformLocationForNative=function(program,name){
		var fakeLoc=LayaGL._locTable.getFakeLocation(program,name);
		this._buffer.add_iii(138,program,fakeLoc);
		this._buffer.add_String(name);
		return fakeLoc;
	}

	__proto.getVertexAttribForNative=function(index,pname){
		console.log("getVertexAttrib can't support");
		return 0;
	}

	__proto.getVertexAttribOffsetForNative=function(index,pname){
		console.log("getVertexAttribOffset can't support");
		return 0;
	}

	__proto.hintForNative=function(target,mode){
		this._buffer.add_iii(141,target,mode);
	}

	__proto.isBufferForNative=function(buffer){
		console.log("isBuffer can't support");
		return true;
	}

	__proto.isEnabledForNative=function(cap){
		console.log("isEnabled can't support");
		return true;
	}

	__proto.isFramebufferForNative=function(framebuffer){
		console.log("isFramebuffer can't support");
		return true;
	}

	__proto.isProgramForNative=function(program){
		console.log("isProgram can't support");
		return true;
	}

	__proto.isRenderbufferForNative=function(renderbuffer){
		console.log("isRenderbuffer can't support");
		return true;
	}

	__proto.isShaderForNative=function(shader){
		console.log("isShader can't support");
		return true;
	}

	__proto.isTextureForNative=function(texture){
		console.log("isTexture can't support");
		return true;
	}

	__proto.lineWidthForNative=function(width){
		this._buffer.add_if(149,width);
	}

	__proto.linkProgramForNative=function(program){
		this._buffer.add_ii(150,program);
	}

	__proto.pixelStoreiForNative=function(pname,param){
		this._buffer.add_iii(151,pname,param);
	}

	__proto.polygonOffsetForNative=function(factor,units){
		this._buffer.add_iff(152,factor,units);
	}

	__proto.readPixelsForNative=function(x,y,width,height,format,type,pixels){
		console.log("readPixels can't support");
	}

	__proto.renderbufferStorageForNative=function(target,internalformat,width,height){
		this._buffer.add_iiiii(154,target,internalformat,width,height);
	}

	__proto.sampleCoverageForNative=function(value,invert){
		this._buffer.add_ifi(155,value,invert);
	}

	__proto.scissorForNative=function(x,y,width,height){
		this._buffer.add_iiiii(156,x,y,width,height);
	}

	__proto.shaderSourceForNative=function(shader,source){
		this._buffer.add_ii(157,shader);
		this._buffer.add_String(source);
	}

	__proto.stencilFuncForNative=function(func,ref,mask){
		this._buffer.add_iiii(158,func,ref,mask);
	}

	__proto.stencilFuncSeparateForNative=function(face,func,ref,mask){
		this._buffer.add_iiiii(159,face,func,ref,mask);
	}

	__proto.stencilMaskForNative=function(mask){
		this._buffer.add_ii(160,mask);
	}

	__proto.stencilMaskSeparateForNative=function(face,mask){
		this._buffer.add_iii(161,face,mask);
	}

	__proto.stencilOpForNative=function(fail,zfail,zpass){
		this._buffer.add_iiii(162,fail,zfail,zpass);
	}

	__proto.stencilOpSeparateForNative=function(face,fail,zfail,zpass){
		this._buffer.add_iiiii(163,face,fail,zfail,zpass);
	}

	__proto.texImage2DForNative=function(__args){
		var args=arguments;
		if (args.length==6){
			if (args[5]._nativeObj){
				this._buffer.add_iiiiiii(164,args[0],args[1],args[2],args[3],args[4],args[5]._nativeObj.conchImgId);
			}
		}
	}

	__proto.texParameterfForNative=function(target,pname,param){
		this._buffer.add_iiif(165,target,pname,param);
	}

	__proto.texParameteriForNative=function(target,pname,param){
		this._buffer.add_iiii(166,target,pname,param);
	}

	__proto.texSubImage2DForNative=function(__args){
		var args=arguments;
		if (args.length==7){
			if (args[6]._nativeObj){
				this._buffer.add_iiiiiiii(167,args[0],args[1],args[2],args[3],args[4],args[5],args[6]._nativeObj.conchImgId);
			}
		}
	}

	__proto.uniform1fForNative=function(location,x){
		this._buffer.add_iif(168,location,x);
	}

	__proto.uniform1fvForNative=function(location,values){
		this._buffer.add_ii(169,location);
		this._buffer.wab(values,values.byteLength);
	}

	__proto.uniform1iForNative=function(location,x){
		this._buffer.add_iii(170,location,x);
	}

	__proto.uniform1ivForNative=function(location,values){
		this._buffer.add_ii(171,location);
		this._buffer.wab(values,values.byteLength);
	}

	__proto.uniform2fForNative=function(location,x,y){
		this._buffer.add_iiff(172,location,x,y);
	}

	__proto.uniform2fvForNative=function(location,values){
		this._buffer.add_ii(173,location);
		this._buffer.wab(values,values.byteLength);
	}

	__proto.uniform2iForNative=function(location,x,y){
		this._buffer.add_iiii(174,location,x,y);
	}

	__proto.uniform2ivForNative=function(location,values){
		this._buffer.add_ii(175,location);
		this._buffer.wab(values,values.byteLength);
	}

	__proto.uniform3fForNative=function(location,x,y,z){
		this._buffer.add_iifff(176,location,x,y,z);
	}

	__proto.uniform3fvForNative=function(location,values){
		this._buffer.add_ii(177,location);
		this._buffer.wab(values,values.byteLength);
	}

	__proto.uniform3iForNative=function(location,x,y,z){
		this._buffer.add_iiiii(178,location,x,y,z);
	}

	__proto.uniform3ivForNative=function(location,values){
		this._buffer.add_ii(179,location);
		this._buffer.wab(values,values.byteLength);
	}

	__proto.uniform4fForNative=function(location,x,y,z,w){
		this._buffer.add_iiffff(180,location,x,y,z,w);
	}

	__proto.uniform4fvForNative=function(location,values){
		this._buffer.add_ii(181,location);
		this._buffer.wab(values,values.byteLength);
	}

	__proto.uniform4iForNative=function(location,x,y,z,w){
		this._buffer.add_iiiiii(182,location,x,y,z,w);
	}

	__proto.uniform4ivForNative=function(location,values){
		this._buffer.add_ii(183,location);
		this._buffer.wab(values,values.byteLength);
	}

	__proto.uniformMatrix2fvForNative=function(location,transpose,value){
		this._buffer.add_iii(184,location,transpose);
		this._buffer.wab(value,value.byteLength);
	}

	__proto.uniformMatrix3fvForNative=function(location,transpose,value){
		this._buffer.add_iii(185,location,transpose);
		this._buffer.wab(value,value.byteLength);
	}

	__proto.uniformMatrix4fvForNative=function(location,transpose,value){
		this._buffer.add_iii(186,location,transpose);
		this._buffer.wab(value,value.byteLength);
	}

	__proto.useProgramForNative=function(program){
		this._buffer.add_ii(187,program);
	}

	__proto.validateProgramForNative=function(program){
		this._buffer.add_ii(188,program);
	}

	__proto.vertexAttrib1fForNative=function(indx,x){
		this._buffer.add_iif(189,indx,x);
	}

	__proto.vertexAttrib1fvForNative=function(indx,values){
		this._buffer.add_ii(190,indx);
		this._buffer.wab(values,values.byteLength);
	}

	__proto.vertexAttrib2fForNative=function(indx,x,y){
		this._buffer.add_iiff(191,indx,x,y);
	}

	__proto.vertexAttrib2fvForNative=function(indx,values){
		this._buffer.add_ii(192,indx);
		this._buffer.wab(values,values.byteLength);
	}

	__proto.vertexAttrib3fForNative=function(indx,x,y,z){
		this._buffer.add_iifff(193,indx,x,y,z);
	}

	__proto.vertexAttrib3fvForNative=function(indx,values){
		this._buffer.add_ii(194,indx);
		this._buffer.wab(values,values.byteLength);
	}

	__proto.vertexAttrib4fForNative=function(indx,x,y,z,w){
		this._buffer.add_iiffff(195,indx,x,y,z,w);
	}

	__proto.vertexAttrib4fvForNative=function(indx,values){
		this._buffer.add_ii(196,indx);
		this._buffer.wab(values,values.byteLength);
	}

	__proto.vertexAttribPointerForNative=function(indx,size,type,normalized,stride,offset){
		this._buffer.add_iiiiiii(197,indx,size,type,normalized,stride,offset);
	}

	__proto.viewportForNative=function(x,y,width,height){
		this._buffer.add_iiiii(198,x,y,width,height);
	}

	__proto.configureBackBufferForNative=function(width,height,antiAlias,enableDepthAndStencil,wantsBestResolution){
		(enableDepthAndStencil===void 0)&& (enableDepthAndStencil=true);
		(wantsBestResolution===void 0)&& (wantsBestResolution=false);
		console.log("configureBackBuffer can't support");
	}

	//_buffer.add_iiiiii(CONFIGUREBACKBUFFER,width,height,antiAlias,enableDepthAndStencil,wantsBestResolution);
	__proto.compressedTexImage2DForNative=function(__args){
		var args=arguments;
		console.log("compressedTexImage2D can't support");
	}

	__proto.uniformMatrix2fvEx=function(location,transpose,value){
		if (!value["_ptrID"]){
			value["conchRef"]=LayaGLNativeContext.createArrayBufferRef(value,0,true);
			value["_ptrID"]=value["conchRef"].id;
		};
		var nID=value["_ptrID"];
		LayaGLNativeContext.syncArrayBufferID(nID);
		this._buffer.add_iiii(201,location,transpose,nID);
	}

	__proto.uniformMatrix3fvEx=function(location,transpose,value){
		if (!value["_ptrID"]){
			value["conchRef"]=LayaGLNativeContext.createArrayBufferRef(value,0,true);
			value["_ptrID"]=value["conchRef"].id;
		};
		var nID=value["_ptrID"];
		LayaGLNativeContext.syncArrayBufferID(nID);
		this._buffer.add_iiii(202,location,transpose,nID);
	}

	__proto.uniformMatrix4fvEx=function(location,transpose,value){
		if (!value["_ptrID"]){
			value["conchRef"]=LayaGLNativeContext.createArrayBufferRef(value,0,true);
			value["_ptrID"]=value["conchRef"].id;
		};
		var nID=value["_ptrID"];
		LayaGLNativeContext.syncArrayBufferID(nID);
		this._buffer.add_iiii(203,location,transpose,nID);
	}

	__proto.addShaderAttributeForNative=function(one){
		LayaGLNativeContext.syncArrayBufferID(this._buffer._buffer["_ptrID"]);
		this._buffer.add_iiii(204,one.location,one.type,one.dataOffset);
	}

	__proto.addShaderUniformForNative=function(one){
		var funID=0;
		var isArray=one.isArray;
		switch (one.type){
			case laya.webgl.WebGLContext.INT:
				funID=isArray ? 3 :2;
				break ;
			case laya.webgl.WebGLContext.FLOAT:
				funID=isArray ? 1 :0;
				break ;
			case laya.webgl.WebGLContext.FLOAT_VEC2:
				funID=isArray ? 5 :4;
				break ;
			case laya.webgl.WebGLContext.FLOAT_VEC3:
				funID=isArray ? 9 :8;
				break ;
			case laya.webgl.WebGLContext.FLOAT_VEC4:
				funID=isArray ? 13 :12;
				break ;
			case laya.webgl.WebGLContext.SAMPLER_2D:
				funID=19;
				break ;
			case laya.webgl.WebGLContext.SAMPLER_CUBE:
				funID=20;
				break ;
			case laya.webgl.WebGLContext.FLOAT_MAT4:
				funID=18;
				break ;
			case laya.webgl.WebGLContext.BOOL:
				funID=2;
				break ;
			case laya.webgl.WebGLContext.FLOAT_MAT2:
				funID=16;
				break ;
			case laya.webgl.WebGLContext.FLOAT_MAT3:
				funID=17;
				break ;
			default :
				throw new Error("compile shader err!");
				break ;
			}
		LayaGLNativeContext.syncArrayBufferID(this._buffer._buffer["_ptrID"]);
		this._buffer.add_iiiiii(205,funID,one.location,one.type,one.dataOffset,one.textureID);
	}

	__proto.uploadShaderAttributesForNative=function(glBuffer,data){
		var dataID=data["_ptrID"];
		LayaGLNativeContext.syncArrayBufferID(dataID);
		this._buffer.add_iii(206,glBuffer._buffer["_ptrID"],dataID);
		return 0;
	}

	__proto.uploadShaderUniformsForNative=function(glBuffer,data){
		var dataID=data["_ptrID"];
		LayaGLNativeContext.syncArrayBufferID(dataID);
		this._buffer.add_iii(207,glBuffer._buffer["_ptrID"],dataID);
		return 0;
	}

	__proto.uploadShaderParamForNative=function(shaderParamBuffer,attrValue,sceneValue,cameraValue,spriteValue,materialValue){
		var shaderParamID=shaderParamBuffer["_ptrID"];
		var attrValueID=attrValue["_ptrID"];
		var sceneValue=sceneValue["_ptrID"];
		var cameraValue=cameraValue["_ptrID"];
		var spriteValue=spriteValue["_ptrID"];
		var materialValue=materialValue["_ptrID"];
		var nCurentFrame=LayaGLNativeContext._frameCount;
		var syncArrayBufferList=LayaGLNativeContext._syncArrayBufferList;
		syncArrayBufferList[shaderParamID]=nCurentFrame;
		syncArrayBufferList[attrValueID]=nCurentFrame;
		syncArrayBufferList[sceneValue]=nCurentFrame;
		syncArrayBufferList[cameraValue]=nCurentFrame;
		syncArrayBufferList[spriteValue]=nCurentFrame;
		syncArrayBufferList[materialValue]=nCurentFrame;
		this._buffer.add_iiiiiii(208,shaderParamID,attrValueID,sceneValue,cameraValue,spriteValue,materialValue);
		return 0;
	}

	LayaGL.__init__=function(){
		LayaGL._glCmds.length=16;
		var gl=LayaGL;
		for (var i in gl){
			var o=gl[i];
			if (!o || !o.id)continue ;
			LayaGL._glCmds[o.id]=o;
			LayaGL._glMap[o.name]=o;
		}
		if (Render.isConchApp){
			LayaGL._locTable=new ProgramLocationTable();
		}
	}

	LayaGL.webGLContext=null;
	LayaGL._fakeIDCount=0;
	LayaGL._locTable=null;
	LayaGL.MASK_LINE_COLOR=0x01;
	LayaGL.MASK_FILL_COLOR=0x02;
	LayaGL.TRANSLATE={id:1,name:"translate"};
	LayaGL.FILL_RECT={id:2,name:"fillRect"};
	LayaGL.SAVE={id:3,name:"save"};
	LayaGL.RESTORE={id:4,name:"restore"};
	LayaGL.ALPHA={id:5,name:"alpha"};
	LayaGL.TRANSFORM={id:6,name:"transform"};
	LayaGL.DRAW_TEXTURE={id:7,name:"drawTexture"};
	LayaGL.DRAW_TEXTURES={id:8,name:"drawTextures"};
	LayaGL.DRAW_LAYAGL={id:9,name:"drawLayaGL"};
	LayaGL.DRAW_LAYAGL3D={id:10,name:"drawLayaGL3D"};
	LayaGL.DRAW_NODE={id:11,name:"drawNode"};
	LayaGL.DRAW_NODES={id:12,name:"drawNodes"};
	LayaGL.DRAW_IMG={id:13,name:"drawImage"};
	LayaGL.DRAW_TEXTURE_AND_GRAPHICS={id:14,name:"drawTextureWithGr"};
	LayaGL.BLOCK_START={id:15,name:"blockStart"};
	LayaGL.BLOCK_END={id:16,name:"blockEnd"};
	LayaGL.DRAW_CANVAS={id:17,name:"drawCanvas"};
	LayaGL.DRAW_LINE={id:18,name:"drawLine"};
	LayaGL.DRAW_CIRCLE={id:19,name:"drawCircle"};
	LayaGL.CLIP_RECT={id:20,name:"clipRect"};
	LayaGL.FILL_TEXT={id:21,name:"fillText"};
	LayaGL.STROKE_TEXT={id:22,name:"strokeText"};
	LayaGL.FILLBORDER_TEXT={id:23,name:"fillBorderText"};
	LayaGL.DRAW_LINES={id:24,name:"drawLines"};
	LayaGL.DRAW_CURVES={id:25,name:"drawCurves"};
	LayaGL.DRAW_POLY={id:26,name:"drawPoly"};
	LayaGL.DRAW_PIE={id:27,name:"drawPie"};
	LayaGL.DRAW_IMAGE={id:28,name:"drawImage"};
	LayaGL.FILL_TEXTURE={id:29,name:"fillTexture"};
	LayaGL.DRAW_BLEND={id:30,name:"drawBlend"};
	LayaGL.DRAW_FILTERS={id:31,name:"drawFilters"};
	LayaGL.DRAW_MASK={id:32,name:"drawMask"};
	LayaGL.DRAW_CLIP={id:33,name:"drawClip"};
	LayaGL.DRAW_TRIANGLES={id:34,name:"drawTriangles"};
	LayaGL.SCALE={id:35,name:"scale" };
	LayaGL.ROTATE={id:36,name:"rotate" };
	LayaGL.DRAW_PATH={id:37,name:"drawPath" };
	LayaGL.BLOCK_START_ID=15;
	LayaGL.BLOCK_END_ID=16;
	LayaGL.GETCONTEXTATTRIBUTES=64;
	LayaGL.ISCONTEXTLOST=65;
	LayaGL.GETSUPPORTEDEXTENSIONS=66;
	LayaGL.GETEXTENSION=67;
	LayaGL.ACTIVETEXTURE=68;
	LayaGL.ATTACHSHADER=69;
	LayaGL.BINDATTRIBLOCATION=70;
	LayaGL.BINDBUFFER=71;
	LayaGL.BINDFRAMEBUFFER=72;
	LayaGL.BINDRENDERBUFFER=73;
	LayaGL.BINDTEXTURE=74;
	LayaGL.USETEXTURE=75;
	LayaGL.BLENDCOLOR=76;
	LayaGL.BLENDEQUATION=77;
	LayaGL.BLENDEQUATIONSEPARATE=78;
	LayaGL.BLENDFUNC=79;
	LayaGL.BLENDFUNCSEPARATE=80;
	LayaGL.BUFFERDATA_SIZE=81;
	LayaGL.BUFFERDATA_ARRAYBUFFER=82;
	LayaGL.BUFFERSUBDATA=83;
	LayaGL.CHECKFRAMEBUFFERSTATUS=84;
	LayaGL.CLEAR=85;
	LayaGL.CLEARCOLOR=86;
	LayaGL.CLEARDEPTH=87;
	LayaGL.CLEARSTENCIL=88;
	LayaGL.COLORMASK=89;
	LayaGL.COMPILESHADER=90;
	LayaGL.COPYTEXIMAGE2D=91;
	LayaGL.COPYTEXSUBIMAGE2D=92;
	LayaGL.CREATEBUFFER=93;
	LayaGL.CREATEFRAMEBUFFER=94;
	LayaGL.CREATEPROGRAM=95;
	LayaGL.CREATERENDERBUFFER=96;
	LayaGL.CREATESHADER=97;
	LayaGL.CREATETEXTURE=98;
	LayaGL.CULLFACE=99;
	LayaGL.DELETEBUFFER=100;
	LayaGL.DELETEFRAMEBUFFER=101;
	LayaGL.DELETEPROGRAM=102;
	LayaGL.DELETERENDERBUFFER=103;
	LayaGL.DELETESHADER=104;
	LayaGL.DELETETEXTURE=105;
	LayaGL.DEPTHFUNC=106;
	LayaGL.DEPTHMASK=107;
	LayaGL.DEPTHRANGE=108;
	LayaGL.DETACHSHADER=109;
	LayaGL.DISABLE=110;
	LayaGL.DISABLEVERTEXATTRIBARRAY=111;
	LayaGL.DRAWARRAYS=112;
	LayaGL.DRAWELEMENTS=113;
	LayaGL.ENABLE=114;
	LayaGL.ENABLEVERTEXATTRIBARRAY=115;
	LayaGL.FINISH=116;
	LayaGL.FLUSH=117;
	LayaGL.FRAMEBUFFERRENDERBUFFER=118;
	LayaGL.FRAMEBUFFERTEXTURE2D=119;
	LayaGL.FRONTFACE=120;
	LayaGL.GENERATEMIPMAP=121;
	LayaGL.GETACTIVEATTRIB=122;
	LayaGL.GETACTIVEUNIFORM=123;
	LayaGL.GETATTRIBLOCATION=124;
	LayaGL.GETPARAMETER=125;
	LayaGL.GETBUFFERPARAMETER=126;
	LayaGL.GETERROR=127;
	LayaGL.GETFRAMEBUFFERATTACHMENTPARAMETER=128;
	LayaGL.GETPROGRAMPARAMETER=129;
	LayaGL.GETPROGRAMINFOLOG=130;
	LayaGL.GETRENDERBUFFERPARAMETER=131;
	LayaGL.GETSHADERPRECISIONFORMAT=132;
	LayaGL.GETSHADERPARAMETER=133;
	LayaGL.GETSHADERINFOLOG=134;
	LayaGL.GETSHADERSOURCE=135;
	LayaGL.GETTEXPARAMETER=136;
	LayaGL.GETUNIFORM=137;
	LayaGL.GETUNIFORMLOCATION=138;
	LayaGL.GETVERTEXATTRIB=139;
	LayaGL.GETVERTEXATTRIBOFFSET=140;
	LayaGL.HINT=141;
	LayaGL.ISBUFFER=142;
	LayaGL.ISENABLED=143;
	LayaGL.ISFRAMEBUFFER=144;
	LayaGL.ISPROGRAM=145;
	LayaGL.ISRENDERBUFFER=146;
	LayaGL.ISSHADER=147;
	LayaGL.ISTEXTURE=148;
	LayaGL.LINEWIDTH=149;
	LayaGL.LINKPROGRAM=150;
	LayaGL.PIXELSTOREI=151;
	LayaGL.POLYGONOFFSET=152;
	LayaGL.READPIXELS=153;
	LayaGL.RENDERBUFFERSTORAGE=154;
	LayaGL.SAMPLECOVERAGE=155;
	LayaGL.SCISSOR=156;
	LayaGL.SHADERSOURCE=157;
	LayaGL.STENCILFUNC=158;
	LayaGL.STENCILFUNCSEPARATE=159;
	LayaGL.STENCILMASK=160;
	LayaGL.STENCILMASKSEPARATE=161;
	LayaGL.STENCILOP=162;
	LayaGL.STENCILOPSEPARATE=163;
	LayaGL.TEXIMAGE2D=164;
	LayaGL.TEXPARAMETERF=165;
	LayaGL.TEXPARAMETERI=166;
	LayaGL.TEXSUBIMAGE2D=167;
	LayaGL.UNIFORM1F=168;
	LayaGL.UNIFORM1FV=169;
	LayaGL.UNIFORM1I=170;
	LayaGL.UNIFORM1IV=171;
	LayaGL.UNIFORM2F=172;
	LayaGL.UNIFORM2FV=173;
	LayaGL.UNIFORM2I=174;
	LayaGL.UNIFORM2IV=175;
	LayaGL.UNIFORM3F=176;
	LayaGL.UNIFORM3FV=177;
	LayaGL.UNIFORM3I=178;
	LayaGL.UNIFORM3IV=179;
	LayaGL.UNIFORM4F=180;
	LayaGL.UNIFORM4FV=181;
	LayaGL.UNIFORM4I=182;
	LayaGL.UNIFORM4IV=183;
	LayaGL.UNIFORMMATRIX2FV=184;
	LayaGL.UNIFORMMATRIX3FV=185;
	LayaGL.UNIFORMMATRIX4FV=186;
	LayaGL.USEPROGRAM=187;
	LayaGL.VALIDATEPROGRAM=188;
	LayaGL.VERTEXATTRIB1F=189;
	LayaGL.VERTEXATTRIB1FV=190;
	LayaGL.VERTEXATTRIB2F=191;
	LayaGL.VERTEXATTRIB2FV=192;
	LayaGL.VERTEXATTRIB3F=193;
	LayaGL.VERTEXATTRIB3FV=194;
	LayaGL.VERTEXATTRIB4F=195;
	LayaGL.VERTEXATTRIB4FV=196;
	LayaGL.VERTEXATTRIBPOINTER=197;
	LayaGL.VIEWPORT=198;
	LayaGL.CONFIGUREBACKBUFFER=199;
	LayaGL.COMPRESSEDTEXIMAGE2D=200;
	LayaGL.UNIFORMMATRIX2FVEX=201;
	LayaGL.UNIFORMMATRIX3FVEX=202;
	LayaGL.UNIFORMMATRIX4FVEX=203;
	LayaGL.ADDSHADERATTRIBUTE=204;
	LayaGL.ADDSHADERUNIFORM=205;
	LayaGL.UPLOADSHADERATTRIBUTES=206;
	LayaGL.UPLOADSHADERUNIFORMS=207;
	LayaGL.UPLOADSHADERPARAMS=208;
	LayaGL.INTERIOR_UNIFORM1F=0;
	LayaGL.INTERIOR_UNIFORM1FV=1;
	LayaGL.INTERIOR_UNIFORM1I=2;
	LayaGL.INTERIOR_UNIFORM1IV=3;
	LayaGL.INTERIOR_UNIFORM2F=4;
	LayaGL.INTERIOR_UNIFORM2FV=5;
	LayaGL.INTERIOR_UNIFORM2I=6;
	LayaGL.INTERIOR_UNIFORM2IV=7;
	LayaGL.INTERIOR_UNIFORM3F=8;
	LayaGL.INTERIOR_UNIFORM3FV=9;
	LayaGL.INTERIOR_UNIFORM3I=10;
	LayaGL.INTERIOR_UNIFORM3IV=11;
	LayaGL.INTERIOR_UNIFORM4F=12;
	LayaGL.INTERIOR_UNIFORM4FV=13;
	LayaGL.INTERIOR_UNIFORM4I=14;
	LayaGL.INTERIOR_UNIFORM4IV=15;
	LayaGL.INTERIOR_UNIFORMMATRIX2FV=16;
	LayaGL.INTERIOR_UNIFORMMATRIX3FV=17;
	LayaGL.INTERIOR_UNIFORMMATRIX4FV=18;
	LayaGL.INTERIOR_UNIFORMSAMPLER_2D=19;
	LayaGL.INTERIOR_UNIFORMSAMPLER_CUBE=20;
	LayaGL._glPool=[];
	LayaGL._glCmds=[];
	LayaGL._glMap={};
	LayaGL.__init$=function(){
		//class ProgramLocationTable
		ProgramLocationTable=(function(){
			function ProgramLocationTable(){
				this._fakeLocationNum=0;
				this._map={};
			}
			__class(ProgramLocationTable,'');
			var __proto=ProgramLocationTable.prototype;
			__proto.getFakeLocation=function(fakeProgramID,name){
				var key=fakeProgramID+"-"+name;
				var fakeID=this._map[key];
				if (!fakeID){
					fakeID=this._fakeLocationNum++;
					this._map[key]=fakeID;
				}
				return fakeID;
			}
			return ProgramLocationTable;
		})()
	}

	return LayaGL;
})()


	//file:///E:/git/layaair-master/core/src/laya/renders/layagl/LayaGLContext.as=======199.999884/199.999884
/**
**<code>LayaGLContext</code> 类用于实现LayaGL上下文。
*/
//class laya.renders.layagl.LayaGLContext
var LayaGLContext=(function(){
	/**
	*创建一个 <code>LayaGLContext</code> 实例。
	*/
	function LayaGLContext(){}
	__class(LayaGLContext,'laya.renders.layagl.LayaGLContext');
	LayaGLContext.setCurrent=function(layagl){}
	LayaGLContext.revert=function(){}
	LayaGLContext.setCurrentForNative=function(laygl){
		LayaGLContext._saveLayaGLS.push(LayaGLContext._current);
		LayaGLContext._current=laygl;
	}

	LayaGLContext.revertForNative=function(){
		LayaGLContext._current=LayaGLContext._saveLayaGLS.pop();
	}

	LayaGLContext._saveLayaGLS=[];
	LayaGLContext._mainGL=null;
	__static(LayaGLContext,
	['_current',function(){return this._current=LayaGLContext._mainGL;}
	]);
	return LayaGLContext;
})()


	//file:///E:/git/layaair-master/core/src/laya/renders/layagl/LayaGLQuickRunner.as=======199.999882/199.999882
/**
*@private
*快速节点命令执行器
*多个指令组合才有意义，单个指令没必要在下面加
*/
//class laya.renders.layagl.LayaGLQuickRunner
var LayaGLQuickRunner=(function(){
	function LayaGLQuickRunner(){}
	__class(LayaGLQuickRunner,'laya.renders.layagl.LayaGLQuickRunner');
	LayaGLQuickRunner.__init__=function(){
		LayaGLQuickRunner.map[0x01 | 0x02 | 0x200]=LayaGLQuickRunner.alpha_transform_drawLayaGL;
		LayaGLQuickRunner.map[0x01 | 0x200]=LayaGLQuickRunner.alpha_drawLayaGL;
		LayaGLQuickRunner.map[0x02 | 0x200]=LayaGLQuickRunner.transform_drawLayaGL;
		LayaGLQuickRunner.map[0x02 | 0x2000]=LayaGLQuickRunner.transform_drawNodes;
		LayaGLQuickRunner.map[0x01 | 0x02 | 0x100]=LayaGLQuickRunner.alpha_transform_drawTexture;
		LayaGLQuickRunner.map[0x01 | 0x100]=LayaGLQuickRunner.alpha_drawTexture;
		LayaGLQuickRunner.map[0x02 | 0x100]=LayaGLQuickRunner.transform_drawTexture;
		LayaGLQuickRunner.map[0x200 | 0x2000]=LayaGLQuickRunner.drawLayaGL_drawNodes;
	}

	LayaGLQuickRunner.transform_drawTexture=function(sprite,context,x,y){
		var style=sprite._style;
		var tex=sprite.texture;
		context.saveTransform(LayaGLQuickRunner.curMat);
		context.transformByMatrix(sprite.transform,x+style.pivotX,y+style.pivotY);
		context.drawTexture(tex,-style.pivotX,-style.pivotY,tex.width,tex.height);
		context.restoreTransform(LayaGLQuickRunner.curMat);
	}

	LayaGLQuickRunner.alpha_drawTexture=function(sprite,context,x,y){
		var style=sprite._style;
		var alpha=NaN;
		var tex=sprite.texture;
		if ((alpha=style.alpha)> 0.01 || sprite._needRepaint()){
			var temp=context.globalAlpha;
			context.globalAlpha *=alpha;
			context.drawTexture(tex,-style.pivotX,-style.pivotY,tex.width,tex.height);
			context.globalAlpha=temp;
		}
	}

	LayaGLQuickRunner.alpha_transform_drawTexture=function(sprite,context,x,y){
		var style=sprite._style;
		var alpha=NaN;
		var tex=sprite.texture;
		if ((alpha=style.alpha)> 0.01 || sprite._needRepaint()){
			var temp=context.globalAlpha;
			context.globalAlpha *=alpha;
			context.saveTransform(LayaGLQuickRunner.curMat);
			context.transformByMatrix(sprite.transform,x+style.pivotX,y+style.pivotY);
			context.drawTexture(tex,-style.pivotX,-style.pivotY,tex.width,tex.height);
			context.restoreTransform(LayaGLQuickRunner.curMat);
			context.globalAlpha=temp;
		}
	}

	LayaGLQuickRunner.alpha_transform_drawLayaGL=function(sprite,context,x,y){
		var style=sprite._style;
		var alpha=NaN;
		if ((alpha=style.alpha)> 0.01 || sprite._needRepaint()){
			var temp=context.globalAlpha;
			var transform=sprite.transform;
			context.globalAlpha *=alpha;
			context.saveTransform(LayaGLQuickRunner.curMat);
			context.transformByMatrix(sprite.transform,x+style.pivotX,y+style.pivotY);
			sprite._graphics && sprite._graphics._render(sprite,context,-style.pivotX,-style.pivotY);
			context.restoreTransform(LayaGLQuickRunner.curMat);
			context.globalAlpha=temp;
		}
	}

	LayaGLQuickRunner.alpha_drawLayaGL=function(sprite,context,x,y){
		var style=sprite._style;
		var alpha=NaN;
		if ((alpha=style.alpha)> 0.01 || sprite._needRepaint()){
			var temp=context.globalAlpha;
			context.globalAlpha *=alpha;
			sprite._graphics && sprite._graphics._render(sprite,context,x,y);
			context.globalAlpha=temp;
		}
	}

	LayaGLQuickRunner.transform_drawLayaGL=function(sprite,context,x,y){
		var style=sprite._style;
		var transform=sprite.transform;
		context.saveTransform(LayaGLQuickRunner.curMat);
		context.transformByMatrix(sprite.transform,x+style.pivotX,y+style.pivotY);
		sprite._graphics && sprite._graphics._render(sprite,context,-style.pivotX,-style.pivotY);
		context.restoreTransform(LayaGLQuickRunner.curMat);
	}

	LayaGLQuickRunner.transform_drawNodes=function(sprite,context,x,y){
		var transform=sprite.transform;
		var style=sprite._style;
		context.saveTransform(LayaGLQuickRunner.curMat);
		context.transformByMatrix(sprite.transform,x+style.pivotX,y+style.pivotY);
		x=-style.pivotX;
		y=-style.pivotY;
		var childs=sprite._children,n=childs.length,ele;
		if (style.viewport){
			var rect=style.viewport;
			var left=rect.x;
			var top=rect.y;
			var right=rect.right;
			var bottom=rect.bottom;
			var _x=NaN,_y=NaN;
			for (i=0;i < n;++i){
				if ((ele=childs [i])._visible && ((_x=ele._x)< right && (_x+ele.width)> left && (_y=ele._y)< bottom && (_y+ele.height)> top)){
					ele.render(context,x,y);
				}
			}
			}else {
			for (var i=0;i < n;++i)
			(ele=(childs [i]))._visible && ele.render(context,x,y);
		}
		context.restoreTransform(LayaGLQuickRunner.curMat);
	}

	LayaGLQuickRunner.drawNode=function(renderData,x,y){
		debugger;
	}

	LayaGLQuickRunner.drawLayaGL=function(sprite,context,x,y){
		sprite._graphics && sprite._graphics._render(sprite,context,x,y);
	}

	LayaGLQuickRunner.drawLayaGL_drawNodes=function(sprite,context,x,y){
		sprite._graphics && sprite._graphics._render(sprite,context,x,y);
		var style=sprite._style;
		var childs=sprite._children,n=childs.length,ele;
		if (style.viewport){
			var rect=style.viewport;
			var left=rect.x;
			var top=rect.y;
			var right=rect.right;
			var bottom=rect.bottom;
			var _x=NaN,_y=NaN;
			for (i=0;i < n;++i){
				if ((ele=childs [i])._visible && ((_x=ele._x)< right && (_x+ele.width)> left && (_y=ele._y)< bottom && (_y+ele.height)> top)){
					ele.render(context,x,y);
				}
			}
			}else {
			for (var i=0;i < n;++i)
			(ele=(childs [i]))._visible && ele.render(context,x,y);
		}
	}

	LayaGLQuickRunner.map={};
	__static(LayaGLQuickRunner,
	['curMat',function(){return this.curMat=new Matrix();}
	]);
	return LayaGLQuickRunner;
})()


	//file:///E:/git/layaair-master/core/src/laya/renders/layagl/LayaGLRunner.as=======199.999881/199.999881
/**
*@private
*普通命令执行器
*/
//class laya.renders.layagl.LayaGLRunner
var LayaGLRunner=(function(){
	function LayaGLRunner(){}
	__class(LayaGLRunner,'laya.renders.layagl.LayaGLRunner');
	LayaGLRunner.uploadShaderAttributes=function(layaGL,glBuffer,data){
		var attributeParamsMap=glBuffer._buffer;
		var value;
		var one,shaderCall=0;
		for (var i=1,n=attributeParamsMap.length;i < n;i++){
			one=attributeParamsMap[i];
			value=data[one.dataOffset];
			if (value !=null)
				shaderCall+=one.fun.call(one.caller,one,value);
		}
		return shaderCall;
	}

	LayaGLRunner.uploadShaderUniforms=function(layaGL,glBuffer,data,uploadUnTexture){
		var shaderUniform=glBuffer._buffer;
		var shaderCall=0;
		for (var i=1,n=shaderUniform.length;i < n;i++){
			var one=shaderUniform[i];
			if (uploadUnTexture || one.textureID!==-1){
				var value=data[one.dataOffset];
				if (value !=null)
					shaderCall+=one.fun.call(one.caller,one,value);
			}
		}
		return shaderCall;
	}

	LayaGLRunner.uploadCustomUniform=function(layaGL,custom,index,data){
		var shaderCall=0;
		var one=custom[index];
		if (one && data !=null)
			shaderCall+=one.fun.call(one.caller,one,data);
		return shaderCall;
	}

	LayaGLRunner.uploadShaderAttributesForNative=function(layaGL,glBuffer,data){
		return layaGL.uploadShaderAttributesForNative(glBuffer,data);
	}

	LayaGLRunner.uploadShaderUniformsForNative=function(layaGL,glBuffer,data){
		return layaGL.uploadShaderUniformsForNative(glBuffer,data);
	}

	return LayaGLRunner;
})()


	//file:///E:/git/layaair-master/core/src/laya/renders/layagl/ParamData.as=======199.999880/199.999880
/**
*@private
*精灵参数数据
*/
//class laya.renders.layagl.ParamData
var ParamData=(function(){
	function ParamData(sz){
		this._data=null;
		this._int32Data=null;
		this._float32Data=null;
		this._data=new ArrayBuffer(sz *4);
		this._int32Data=new Int32Array(this._data);
		this._float32Data=new Float32Array(this._data);
		if (Render.isConchApp){
			this._data["conchRef"]=LayaGLNativeContext.createArrayBufferRef(this._data,0,false);
			this._data["_ptrID"]=this._data["conchRef"].id;
		}
	}

	__class(ParamData,'laya.renders.layagl.ParamData');
	var __proto=ParamData.prototype;
	__proto.setI=function(name,value){
		this._int32Data[SpriteConst.SPRITE_DATA[name]]=value;
	}

	__proto.getI=function(name){
		return this._int32Data[SpriteConst.SPRITE_DATA[name]];
	}

	__proto.setF=function(name,value){
		this._float32Data[SpriteConst.SPRITE_DATA[name]]=value;
	}

	__proto.getF=function(name){
		return this._float32Data[SpriteConst.SPRITE_DATA[name]];
	}

	__proto.setColor=function(name,value){
		this._int32Data[SpriteConst.SPRITE_DATA[name]]=Color.create(value).numColor;
	}

	ParamData.create=function(sz){
		return new ParamData(sz);
	}

	ParamData._pool=[];
	return ParamData;
})()


	//file:///E:/git/layaair-master/core/src/laya/renders/Render.as=======199.999878/199.999878
/**
*@private
*<code>Render</code> 是渲染管理类。它是一个单例，可以使用 Laya.render 访问。
*/
//class laya.renders.Render
var Render=(function(){
	function Render(width,height){
		/**@private */
		this._timeId=0;
		var style=Render._mainCanvas.source.style;
		style.position='absolute';
		style.top=style.left="0px";
		style.background="#000000";
		Render._mainCanvas.source.id="layaCanvas";
		var isWebGl=laya.renders.Render.isWebGL;
		Render._mainCanvas.source.width=width;
		Render._mainCanvas.source.height=height;
		isWebGl && Render.WebGL.init(Render._mainCanvas,width,height);
		Browser.container.appendChild(Render._mainCanvas.source);
		function getContext (width,height,canvas){
			if (canvas){
				Render._context=canvas.getContext('2d');
				Render._context.__tx=0;
				Render._context.__ty=0;
				}else {
				canvas=HTMLCanvas.create("3D");
				Render._context=RunDriver.createWebGLContext2D(canvas);
				canvas._setContext(Render._context);
			}
			canvas.size(width,height);
			return Render._context;
		}
		Render._context=getContext(width,height,isWebGl ? null :Render._mainCanvas);
		Render._context.setIsMainContext();
		Browser.window.requestAnimationFrame(loop);
		function loop (){
			Laya.stage._loop();
			Browser.window.requestAnimationFrame(loop);
		}
		Laya.stage.on("visibilitychange",this,this._onVisibilitychange);
	}

	__class(Render,'laya.renders.Render');
	var __proto=Render.prototype;
	/**@private */
	__proto._onVisibilitychange=function(){
		if (!Laya.stage.isVisibility){
			this._timeId=Browser.window.setInterval(this._enterFrame,1000);
			}else if (this._timeId !=0){
			Browser.window.clearInterval(this._timeId);
		}
	}

	/**@private */
	__proto._enterFrame=function(e){
		Laya.stage._loop();
	}

	/**目前使用的渲染器。*/
	__getset(1,Render,'context',function(){
		return Render._context;
	});

	/**渲染使用的原生画布引用。 */
	__getset(1,Render,'canvas',function(){
		return Render._mainCanvas.source;
	});

	Render._context=null;
	Render._mainCanvas=null;
	Render.WebGL=null;
	Render.isConchNode=false;
	Render.isConchApp=false;
	Render.isConchWebGL=false;
	Render.isWebGL=false;
	Render.is3DMode=false;
	Render.optimizeTextureMemory=function(url,texture){
		return true;
	}

	Render.__init$=function(){
		window.ConchRenderType=window.ConchRenderType||1;
		window.ConchRenderType|=(!window.conch?0:0x04);;{
			Render.isConchNode=(window.ConchRenderType & 5)==5;
			Render.isConchApp=(window.ConchRenderType & 0x04)==0x04;
			Render.isConchWebGL=window.ConchRenderType==6;
		};;
	}

	return Render;
})()


	//file:///E:/git/layaair-master/core/src/laya/renders/RenderContext.as=======199.999877/199.999877
/**
*@private
*渲染环境
*/
//class laya.renders.RenderContext
var RenderContext=(function(){
	function RenderContext(width,height,canvas){
		/**全局x坐标 */
		this.x=0;
		/**全局y坐标 */
		this.y=0;
		/**当前使用的画布 */
		//this.canvas=null;
		/**当前使用的画布上下文 */
		//this.ctx=null;
		//if (tex._loaded)this.ctx.drawTexture(tex,x,y,width,height,this.x,this.y);
		this._drawTexture=function(x,y,args){}
		this._fillTexture=function(x,y,args){
			if (args[0]._loaded)this.ctx.fillTexture(args[0],args[1]+x,args[2]+y,args[3],args[4],args[5],args[6],args[7]);
		}
		this._drawTextureWithTransform=function(x,y,args){
			if (args[0]._loaded)this.ctx.drawTextureWithTransform(args[0],args[1],args[2],args[3],args[4],args[5],x,y,args[6],args[7]);
		}
		this._fillQuadrangle=function(x,y,args){
			this.ctx.fillQuadrangle(args[0],args[1],args[2],args[3],args[4]);
		}
		//矢量方法
		this._drawPie=function(x,y,args){
			var ctx=this.ctx;
			Render.isWebGL && ctx.setPathId(args[8]);
			ctx.beginPath();
			if (Render.isWebGL){
				ctx.movePath(args[0]+x,args[1]+y);
				ctx.moveTo(0,0);
				}else {
				ctx.moveTo(x+args[0],y+args[1]);
			}
			ctx.arc(x+args[0],y+args[1],args[2],args[3],args[4]);
			ctx.closePath();
			this._fillAndStroke(args[5],args[6],args[7],true);
		}
		this._clipRect=function(x,y,args){
			this.ctx.clipRect(x+args[0],y+args[1],args[2],args[3]);
		}
		this._fillRect=function(x,y,args){
			this.ctx._drawRect(x+args[0],y+args[1],args[2],args[3],args[4]);
		}
		this._setShader=function(x,y,args){
			this.ctx.setShader(args[0]);
		}
		this._drawLine=function(x,y,args){
			var ctx=this.ctx;
			Render.isWebGL && ctx.setPathId(args[6]);
			ctx.beginPath();
			ctx.strokeStyle=args[4];
			ctx.lineWidth=args[5];
			if (Render.isWebGL){
				ctx.movePath(x,y);
				ctx.moveTo(args[0],args[1]);
				ctx.lineTo(args[2],args[3]);
				}else {
				ctx.moveTo(x+args[0],y+args[1]);
				ctx.lineTo(x+args[2],y+args[3]);
			}
			ctx.stroke();
		}
		this._drawLines=function(x,y,args){
			var ctx=this.ctx;
			Render.isWebGL && ctx.setPathId(args[5]);
			ctx.beginPath();
			x+=args[0],y+=args[1];
			Render.isWebGL && ctx.movePath(x,y);
			ctx.strokeStyle=args[3];
			ctx.lineWidth=args[4];
			var points=args[2];
			var i=2,n=points.length;
			if (Render.isWebGL){
				ctx.moveTo(points[0],points[1]);
				while (i < n){
					ctx.lineTo(points[i++],points[i++]);
				}
				}else {
				ctx.moveTo(x+points[0],y+points[1]);
				while (i < n){
					ctx.lineTo(x+points[i++],y+points[i++]);
				}
			}
			ctx.stroke();
		}
		this._drawLinesWebGL=function(x,y,args){
			this.ctx.drawLines(x+this.x+args[0],y+this.y+args[1],args[2],args[3],args[4]);
		}
		//x:Number,y:Number,points:Array,lineColor:String,lineWidth:Number=1
		this._drawCurves=function(x,y,args){}
		//this.ctx.drawCurves(x,y,args);
		this._draw=function(x,y,args){
			args[0].call(null,this,x,y);
		}
		this._transformByMatrix=function(x,y,args){
			this.ctx.transformByMatrix(args[0]);
		}
		this._setTransform=function(x,y,args){
			this.ctx.setTransform(args[0],args[1],args[2],args[3],args[4],args[5]);
		}
		this._setTransformByMatrix=function(x,y,args){
			this.ctx.setTransformByMatrix(args[0]);
		}
		this._save=function(x,y,args){
			this.ctx.save();
		}
		this._restore=function(x,y,args){
			this.ctx.restore();
		}
		this._translate=function(x,y,args){
			this.ctx.translate(args[0],args[1]);
		}
		this._transform=function(x,y,args){
			this.ctx.translate(args[1]+x,args[2]+y);
			var mat=args[0];
			this.ctx.transform(mat.a,mat.b,mat.c,mat.d,mat.tx,mat.ty);
			this.ctx.translate(-x-args[1],-y-args[2]);
		}
		this._rotate=function(x,y,args){
			this.ctx.translate(args[1]+x,args[2]+y);
			this.ctx.rotate(args[0]);
			this.ctx.translate(-x-args[1],-y-args[2]);
		}
		this._scale=function(x,y,args){
			this.ctx.translate(args[2]+x,args[3]+y);
			this.ctx.scale(args[0],args[1]);
			this.ctx.translate(-x-args[2],-y-args[3]);
		}
		this._alpha=function(x,y,args){
			this.ctx.globalAlpha *=args[0];
		}
		this._setAlpha=function(x,y,args){
			this.ctx.globalAlpha=args[0];
		}
		this._fillText=function(x,y,args){
			this.ctx.drawText(args[0],args[1]+x,args[2]+y,args[3],args[4],args[5]);
		}
		this._strokeText=function(x,y,args){
			this.ctx.strokeWord(args[0],args[1]+x,args[2]+y,args[3],args[4],args[5],args[6]);
		}
		this._fillBorderText=function(x,y,args){
			this.ctx.fillBorderText(args[0],args[1]+x,args[2]+y,args[3],args[4],args[5],args[6],args[7]);
		}
		this._fillWords=function(x,y,args){
			this.ctx.fillWords(args[0],args[1]+x,args[2]+y,args[3],args[4]);
		}
		/***@private */
		this._fillBorderWords=function(x,y,args){
			this.ctx.fillBorderWords(args[0],args[1]+x,args[2]+y,args[3],args[4],args[5],args[6]);
		}
		this._blendMode=function(x,y,args){
			this.ctx.globalCompositeOperation=args[0];
		}
		this._beginClip=function(x,y,args){
			this.ctx.beginClip && this.ctx.beginClip(x+args[0],y+args[1],args[2],args[3]);
		}
		this._setIBVB=function(x,y,args){
			this.ctx.setIBVB(args[0]+x,args[1]+y,args[2],args[3],args[4],args[5],args[6],args[7]);
		}
		this._fillTrangles=function(x,y,args){
			this.ctx.fillTrangles(args[0],args[1]+x,args[2]+y,args[3],args[4]);
		}
		//x:Number,y:Number,paths:Array,brush:Object=null,pen:Object=null
		this._drawPath=function(x,y,args){
			var ctx=this.ctx;
			Render.isWebGL && ctx.setPathId(-1);
			ctx.beginPath();
			x+=args[0],y+=args[1];
			var paths=args[2];
			for (var i=0,n=paths.length;i < n;i++){
				var path=paths[i];
				switch (path[0]){
					case "moveTo":
						ctx.moveTo(x+path[1],y+path[2]);
						break ;
					case "lineTo":
						ctx.lineTo(x+path[1],y+path[2]);
						break ;
					case "arcTo":
						ctx.arcTo(x+path[1],y+path[2],x+path[3],y+path[4],path[5]);
						break ;
					case "closePath":
						ctx.closePath();
						break ;
					}
			};
			var brush=args[3];
			if (brush !=null){
				ctx.fillStyle=brush.fillStyle;
				ctx.fill();
			};
			var pen=args[4];
			if (pen !=null){
				ctx.strokeStyle=pen.strokeStyle;
				ctx.lineWidth=pen.lineWidth || 1;
				ctx.lineJoin=pen.lineJoin;
				ctx.lineCap=pen.lineCap;
				ctx.miterLimit=pen.miterLimit;
				ctx.stroke();
			}
		}
		// polygon(x:Number,y:Number,r:Number,edges:Number,color:uint,borderWidth:int=2,borderColor:uint=0)
		this.drawPoly=function(x,y,args){
			this.ctx.drawPoly(x+this.x+args[0],y+this.y+args[1],args[2],args[3],args[4],args[5],args[6]);
		}
		//x:Number,y:Number,points:Array,fillColor:String,lineColor:String=null,lineWidth:Number=1
		this._drawPoly=function(x,y,args){
			var ctx=this.ctx;
			var points=args[2];
			var i=2,n=points.length;
			if (Render.isWebGL){
				ctx.setPathId(args[6]);
				ctx.beginPath();
				x+=args[0],y+=args[1];
				ctx.movePath(x,y);
				ctx.moveTo(points[0],points[1]);
				while (i < n){
					ctx.lineTo(points[i++],points[i++]);
				}
				}else {
				ctx.beginPath();
				x+=args[0],y+=args[1];
				ctx.moveTo(x+points[0],y+points[1]);
				while (i < n){
					ctx.lineTo(x+points[i++],y+points[i++]);
				}
			}
			ctx.closePath();
			this._fillAndStroke(args[3],args[4],args[5],args[7]);
		}
		this._drawSkin=function(x,y,args){
			var tSprite=args[0];
			if (tSprite){
				var ctx=this.ctx;
				tSprite.render(ctx,x,y);
			}
		}
		this._drawParticle=function(x,y,args){
			this.ctx.drawParticle(x+this.x,y+this.y,args[0]);
		}
		if (canvas){
			this.ctx=canvas.getContext('2d');
			}else {
			canvas=HTMLCanvas.create("3D");
			this.ctx=RunDriver.createWebGLContext2D(canvas);
			canvas._setContext(this.ctx);
		}
		canvas.size(width,height);
		this.canvas=canvas;
	}

	__class(RenderContext,'laya.renders.RenderContext');
	var __proto=RenderContext.prototype;
	/**销毁当前渲染环境*/
	__proto.destroy=function(){
		if (this.canvas){
			this.canvas.destroy();
			this.canvas=null;
		}
		if (this.ctx){
			this.ctx.destroy();
			this.ctx=null;
		}
	}

	__proto.drawTexture=function(tex,x,y,width,height){}
	//if (args[0]._loaded)this.ctx.drawTexture(args[0],args[1],args[2],args[3],args[4],x,y);
	__proto._drawTextures=function(x,y,args){
		if (args[0]._loaded)this.ctx.drawTextures(args[0],args[1],x+this.x,y+this.y);
	}

	__proto.fillQuadrangle=function(tex,x,y,point4,m){
		this.ctx.fillQuadrangle(tex,x,y,point4,m);
	}

	__proto.drawCanvas=function(canvas,x,y,width,height){
		this.ctx.drawCanvas(canvas,x+this.x,y+this.y,width,height);
	}

	__proto.drawRect=function(x,y,width,height,fillColor,lineColor,lineWidth){
		var ctx=this.ctx;
		if (fillColor !=null){
			ctx.fillStyle=fillColor;
			ctx.fillRect(x,y,width,height);
		}
		if (lineColor !=null){
			ctx.strokeStyle=lineColor;
			ctx.lineWidth=lineWidth;
			ctx.strokeRect(x,y,width,height);
		}
	}

	__proto._fillAndStroke=function(fillColor,strokeColor,lineWidth,isConvexPolygon){
		(isConvexPolygon===void 0)&& (isConvexPolygon=false);
		var ctx=this.ctx;
		if (fillColor !=null){
			ctx.fillStyle=fillColor;
			if (Render.isWebGL){
				ctx.fill(isConvexPolygon);
				}else {
				ctx.fill();
			}
		}
		if (strokeColor !=null && lineWidth > 0){
			ctx.strokeStyle=strokeColor;
			ctx.lineWidth=lineWidth;
			ctx.stroke();
		}
	}

	//ctx.translate(-x-args[0],-y-args[1]);
	__proto.clipRect=function(x,y,width,height){
		this.ctx.clipRect(x+this.x,y+this.y,width,height);
	}

	__proto.fillRect=function(x,y,width,height,fillStyle){
		this.ctx._drawRect(x+this.x,y+this.y,width,height,fillStyle);
	}

	__proto.drawCircle=function(x,y,radius,color,lineWidth){
		(lineWidth===void 0)&& (lineWidth=1);
		Stat.drawCall++;
		var ctx=this.ctx;
		ctx.beginPath();
		ctx.strokeStyle=color;
		ctx.lineWidth=lineWidth;
		ctx.arc(x+this.x,y+this.y,radius,0,RenderContext.PI2);
		ctx.stroke();
	}

	__proto._drawCircle=function(x,y,args){
		var ctx=this.ctx;
		Render.isWebGL && ctx.setPathId(args[6]);
		Stat.drawCall++;
		ctx.beginPath();
		Render.isWebGL && ctx.movePath(args[0]+x,args[1]+y);
		ctx.arc(args[0]+x,args[1]+y,args[2],0,RenderContext.PI2);
		ctx.closePath();
		this._fillAndStroke(args[3],args[4],args[5],true);
	}

	/**
	*绘制三角形
	*@param x
	*@param y
	*@param tex
	*@param args [x,y,texture,vertices,indices,uvs,matrix]
	*/
	__proto.drawTriangles=function(x,y,args){
		var indices=args[4];
		var i=0,len=indices.length;
		var ctx=this.ctx;
		for (i=0;i < len;i+=3){
			var index0=indices[i] *2;
			var index1=indices[i+1] *2;
			var index2=indices[i+2] *2;
			ctx.drawTriangle(args[2],args[3],args[5],index0,index1,index2,args[6],true);
		}
	}

	__proto.fillCircle=function(x,y,radius,color){
		Stat.drawCall++;
		var ctx=this.ctx;
		ctx.beginPath();
		ctx.fillStyle=color;
		ctx.arc(x+this.x,y+this.y,radius,0,RenderContext.PI2);
		ctx.fill();
	}

	/**
	*绘制圆形
	*@param x
	*@param y
	*@param args [radius:Number,color:String]
	*/
	__proto._fillCircle=function(x,y,args){
		Stat.drawCall++;
		var ctx=this.ctx;
		ctx.beginPath();
		ctx.fillStyle=args[3];
		ctx.arc(args[0]+x,args[1]+y,args[2],0,RenderContext.PI2);
		ctx.fill();
	}

	__proto.setShader=function(shader){
		this.ctx.setShader(shader);
	}

	__proto.drawLine=function(fromX,fromY,toX,toY,color,lineWidth){
		(lineWidth===void 0)&& (lineWidth=1);
		var ctx=this.ctx;
		ctx.beginPath();
		ctx.strokeStyle=color;
		ctx.lineWidth=lineWidth;
		ctx.moveTo(this.x+fromX,this.y+fromY);
		ctx.lineTo(this.x+toX,this.y+toY);
		ctx.stroke();
	}

	__proto.clear=function(){
		this.ctx.clear();
	}

	__proto.transformByMatrix=function(value){
		this.ctx.transformByMatrix(value);
	}

	__proto.setTransform=function(a,b,c,d,tx,ty){
		this.ctx.setTransform(a,b,c,d,tx,ty);
	}

	__proto.setTransformByMatrix=function(value){
		this.ctx.setTransformByMatrix(value);
	}

	__proto.save=function(){
		this.ctx.save();
	}

	__proto.restore=function(){
		this.ctx.restore();
	}

	__proto.translate=function(x,y){
		this.ctx.translate(x,y);
	}

	__proto.transform=function(a,b,c,d,tx,ty){
		this.ctx.transform(a,b,c,d,tx,ty);
	}

	__proto.rotate=function(angle){
		this.ctx.rotate(angle);
	}

	__proto.scale=function(scaleX,scaleY){
		this.ctx.scale(scaleX,scaleY);
	}

	__proto.alpha=function(value){
		this.ctx.globalAlpha *=value;
	}

	__proto.setAlpha=function(value){
		this.ctx.globalAlpha=value;
	}

	__proto.fillText=function(text,x,y,font,color,textAlign){
		this.ctx.drawText(text,x+this.x,y+this.y,font,color,textAlign);
	}

	__proto.strokeText=function(text,x,y,font,color,lineWidth,textAlign){
		this.ctx.strokeWord(text,x+this.x,y+this.y,font,color,lineWidth,textAlign);
	}

	__proto.blendMode=function(type){
		this.ctx.globalCompositeOperation=type;
	}

	__proto.flush=function(){
		this.ctx.flush && this.ctx.flush();
	}

	__proto.addRenderObject=function(o){
		this.ctx.addRenderObject(o);
	}

	__proto.beginClip=function(x,y,w,h){
		this.ctx.beginClip && this.ctx.beginClip(x,y,w,h);
	}

	__proto.endClip=function(){
		this.ctx.endClip && this.ctx.endClip();
	}

	__proto.fillTrangles=function(x,y,args){
		this.ctx.fillTrangles(args[0],args[1],args[2],args[3],args.length > 4 ? args[4] :null);
	}

	RenderContext.PI2=2 *Math.PI;
	return RenderContext;
})()


	//file:///E:/git/layaair-master/core/src/laya/renders/RenderData.as=======199.999876/199.999876
//TODO:是否还有用
//class laya.renders.RenderData
var RenderData=(function(){
	function RenderData(){
		this.context=null;
		this.sprite=null;
		this.data=null;
		this.x=NaN;
		this.y=NaN;
	}

	__class(RenderData,'laya.renders.RenderData');
	return RenderData;
})()


	//file:///E:/git/layaair-master/core/src/laya/renders/RenderSprite.as=======199.999875/199.999875
/**
*@private
*精灵渲染器
*/
//class laya.renders.RenderSprite
var RenderSprite=(function(){
	function RenderSprite(type,next){
		/**@private */
		//this._next=null;
		/**@private */
		//this._fun=null;
		if (LayaGLQuickRunner.map[type]){
			this._fun=LayaGLQuickRunner.map[type];
			this._next=RenderSprite.NORENDER;
			return;
		}
		this._next=next || RenderSprite.NORENDER;
		switch (type){
			case 0:
				this._fun=this._no;
				return;
			case 0x01:
				this._fun=this._alpha;
				return;
			case 0x02:
				this._fun=this._transform;
				return;
			case 0x04:
				this._fun=this._blend;
				return;
			case 0x08:
				this._fun=this._canvas;
				return;
			case 0x20:
				this._fun=this._mask;
				return;
			case 0x40:
				this._fun=this._clip;
				return;
			case 0x80:
				this._fun=this._style;
				return;
			case 0x200:
				this._fun=this._graphics;
				return;
			case 0x2000:
				this._fun=this._children;
				return;
			case 0x800:
				this._fun=this._custom;
				return;
			case 0x100:
				this._fun=this._texture;
				return;
			case 0x10:
				this._fun=Filter._filter;
				return;
			case 0x11111:
				this._fun=RenderSprite._initRenderFun;
				return;
			}
		this.onCreate(type);
	}

	__class(RenderSprite,'laya.renders.RenderSprite');
	var __proto=RenderSprite.prototype;
	__proto.onCreate=function(type){}
	__proto._style=function(sprite,context,x,y){
		var style=sprite._style;
		if (style.render !=null)style.render(sprite,context,x,y);
		var next=this._next;
		next._fun.call(next,sprite,context,x,y);
	}

	__proto._no=function(sprite,context,x,y){}
	__proto._custom=function(sprite,context,x,y){
		sprite.customRender(context,x,y);
		this._next._fun.call(this._next,sprite,context,x,y);
	}

	__proto._clip=function(sprite,context,x,y){
		var next=this._next;
		if (next==RenderSprite.NORENDER)return;
		var r=sprite._style.scrollRect;
		context.save();
		context.clipRect(x,y,r.width,r.height);
		next._fun.call(next,sprite,context,x-r.x,y-r.y);
		context.restore();
	}

	__proto._blend=function(sprite,context,x,y){
		var style=sprite._style;
		if (style.blendMode){
			context.globalCompositeOperation=style.blendMode;
		};
		var next=this._next;
		next._fun.call(next,sprite,context,x,y);
		context.globalCompositeOperation="source-over";
	}

	__proto._mask=function(sprite,context,x,y){
		var next=this._next;
		next._fun.call(next,sprite,context,x,y);
		var mask=sprite.mask;
		if (mask){
			context.globalCompositeOperation="destination-in";
			if (mask.numChildren > 0 || !mask.graphics._isOnlyOne()){
				mask.cacheAs="bitmap";
			}
			mask.render(context,x-sprite._style.pivotX,y-sprite._style.pivotY);
		}
		context.globalCompositeOperation="source-over";
	}

	__proto._texture=function(sprite,context,x,y){
		var tex;
		tex=sprite.texture;
		context.drawTexture(tex,x,y,tex.width,tex.height);
		var next=this._next;
		next._fun.call(next,sprite,context,x,y);
	}

	__proto._graphics=function(sprite,context,x,y){
		sprite._graphics && sprite._graphics._render(sprite,context,x,y);
		var next=this._next;
		next._fun.call(next,sprite,context,x,y);
	}

	__proto._image=function(sprite,context,x,y){
		var style=sprite._style;
		context.drawTexture2(x,y,style.pivotX,style.pivotY,sprite.transform,sprite._graphics._one);
	}

	__proto._image2=function(sprite,context,x,y){
		var style=sprite._style;
		context.drawTexture2(x,y,style.pivotX,style.pivotY,sprite.transform,sprite._graphics._one);
	}

	__proto._alpha=function(sprite,context,x,y){
		var style=sprite._style;
		var alpha;
		if ((alpha=style.alpha)> 0.01 || sprite._needRepaint()){
			var temp=context.globalAlpha;
			context.globalAlpha *=alpha;
			var next=this._next;
			next._fun.call(next,sprite,context,x,y);
			context.globalAlpha=temp;
		}
	}

	__proto._transform=function(sprite,context,x,y){
		var transform=sprite.transform,_next=this._next;
		var style=sprite._style;
		if (transform && _next !=RenderSprite.NORENDER){
			context.save();
			context.transform(transform.a,transform.b,transform.c,transform.d,transform.tx+x+style.pivotX,transform.ty+y+style.pivotY);
			_next._fun.call(_next,sprite,context,-style.pivotX,-style.pivotY);
			context.restore();
		}else
		_next._fun.call(_next,sprite,context,x,y);
	}

	__proto._children=function(sprite,context,x,y){
		var style=sprite._style;
		var childs=sprite._children,n=childs.length,ele;
		if (style.viewport){
			var rect=style.viewport;
			var left=rect.x;
			var top=rect.y;
			var right=rect.right;
			var bottom=rect.bottom;
			var _x=NaN,_y=NaN;
			for (i=0;i < n;++i){
				if ((ele=childs [i])._visible && ((_x=ele._x)< right && (_x+ele.width)> left && (_y=ele._y)< bottom && (_y+ele.height)> top)){
					ele.render(context,x,y);
				}
			}
			}else {
			for (var i=0;i < n;++i)
			(ele=(childs [i]))._visible && ele.render(context,x,y);
		}
	}

	__proto._canvas=function(sprite,context,x,y){
		var _cacheStyle=sprite._cacheStyle;
		var _next=this._next;
		if (!_cacheStyle.enableCanvasRender){
			_next._fun.call(_next,sprite,context,x,y);
			return;
		}
		_cacheStyle.cacheAs==='bitmap' ? (Stat.canvasBitmap++):(Stat.canvasNormal++);
		if (sprite._needRepaint()|| (!_cacheStyle.canvas)){
			this._canvas_repaint(sprite,context,x,y);
			}else {
			var tRec=_cacheStyle.cacheRect;
			context.drawCanvas(_cacheStyle.canvas,x+tRec.x,y+tRec.y,tRec.width,tRec.height);
		}
	}

	__proto._canvas_repaint=function(sprite,context,x,y){
		var _cacheStyle=sprite._cacheStyle;
		var _next=this._next;
		var tx;
		var canvas=_cacheStyle.canvas;
		var left;
		var top;
		var tRec;
		var tCacheType=_cacheStyle.cacheAs;
		var w,h;
		var scaleX,scaleY;
		var scaleInfo;
		scaleInfo=_cacheStyle._calculateCacheRect(sprite,tCacheType,x,y);
		scaleX=scaleInfo.x;
		scaleY=scaleInfo.y;
		tRec=_cacheStyle.cacheRect;
		w=tRec.width *scaleX;
		h=tRec.height *scaleY;
		left=tRec.x;
		top=tRec.y;
		if (Render.isWebGL && tCacheType==='bitmap' && (w > 2048 || h > 2048)){
			console.warn("cache bitmap size larger than 2048,cache ignored");
			_cacheStyle.releaseContext();
			_next._fun.call(_next,sprite,context,x,y);
			return;
		}
		if (!canvas){
			_cacheStyle.createContext();
			canvas=_cacheStyle.canvas;
		}
		tx=canvas.context;
		canvas.context.sprite=sprite;
		(canvas.width !=w || canvas.height !=h)&& canvas.size(w,h);
		if (tCacheType==='bitmap')canvas.context.asBitmap=true;
		else if (tCacheType==='normal')canvas.context.asBitmap=false;
		canvas.clear();
		if (scaleX !=1 || scaleY !=1){
			var ctx=tx;
			ctx.save();
			ctx.scale(scaleX,scaleY);
			_next._fun.call(_next,sprite,tx,-left,-top);
			ctx.restore();
			sprite._applyFilters();
			}else {
			ctx=tx;
			_next._fun.call(_next,sprite,tx,-left,-top);
			sprite._applyFilters();
		}
		if (_cacheStyle.staticCache)_cacheStyle.reCache=false;
		Stat.canvasReCache++;
		context.drawCanvas(canvas,x+left,y+top,tRec.width,tRec.height);
	}

	RenderSprite.__init__=function(){
		LayaGLQuickRunner.__init__();
		var i=0,len=0;
		var initRender;
		initRender=RunDriver.createRenderSprite(0x11111,null);
		len=RenderSprite.renders.length=0x2000 *2;
		for (i=0;i < len;i++)
		RenderSprite.renders[i]=initRender;
		RenderSprite.renders[0]=RunDriver.createRenderSprite(0,null);
		function _initSame (value,o){
			var n=0;
			for (var i=0;i < value.length;i++){
				n |=value[i];
				RenderSprite.renders[n]=o;
			}
		}
	}

	RenderSprite._initRenderFun=function(sprite,context,x,y){
		var type=sprite._renderType;
		var r=RenderSprite.renders[type]=RenderSprite._getTypeRender(type);
		r._fun(sprite,context,x,y);
	}

	RenderSprite._getTypeRender=function(type){
		if (LayaGLQuickRunner.map[type])return RunDriver.createRenderSprite(type,null);
		var rst=null;
		var tType=0x2000;
		while (tType > 1){
			if (tType & type)
				rst=RunDriver.createRenderSprite(tType,rst);
			tType=tType >> 1;
		}
		return rst;
	}

	RenderSprite.INIT=0x11111;
	RenderSprite.renders=[];
	RenderSprite.NORENDER=new RenderSprite(0,null);
	return RenderSprite;
})()


	//file:///E:/git/layaair-master/core/src/laya/resource/Context.as=======199.999872/199.999872
/**
*@private
*Context扩展类
*/
//class laya.resource.Context
var Context=(function(){
	function Context(){
		//this._canvas=null;
	}

	__class(Context,'laya.resource.Context');
	var __proto=Context.prototype;
	__proto.setIsMainContext=function(){}
	/**@private */
	__proto.drawCanvas=function(canvas,x,y,width,height){
		Stat.drawCall++;
		this.drawImage(canvas._source,x,y,width,height);
	}

	/**@private */
	__proto._drawRect=function(x,y,width,height,style){
		Stat.drawCall++;
		style && (this.fillStyle=style);
		this.fillRect(x,y,width,height);
	}

	/**@private */
	__proto.drawText=function(text,x,y,font,color,textAlign){
		Stat.drawCall++;
		if (arguments.length > 3 && font !=null){
			this.font=font;
			this.fillStyle=color;
			this.textAlign=textAlign;
			this.textBaseline="top";
		}
		this.fillText(text,x,y);
	}

	/**@private */
	__proto.fillBorderText=function(text,x,y,font,fillColor,borderColor,lineWidth,textAlign){
		Stat.drawCall++;
		this.font=font;
		this.fillStyle=fillColor;
		this.textBaseline="top";
		this.strokeStyle=borderColor;
		this.lineWidth=lineWidth;
		this.textAlign=textAlign;
		this.strokeText(text,x,y);
		this.fillText(text,x,y);
	}

	/***@private */
	__proto.fillWords=function(words,x,y,font,color){
		font && (this.font=font);
		color && (this.fillStyle=color);
		this.textBaseline="top";
		this.textAlign='left';
		for (var i=0,n=words.length;i < n;i++){
			var a=words[i];
			this.fillText(a.char,a.x+x,a.y+y);
		}
	}

	/***@private */
	__proto.fillBorderWords=function(words,x,y,font,color,borderColor,lineWidth){
		font && (this.font=font);
		color && (this.fillStyle=color);
		this.textBaseline="top";
		this.lineWidth=lineWidth;
		this.textAlign='left';
		this.strokeStyle=borderColor;
		for (var i=0,n=words.length;i < n;i++){
			var a=words[i];
			this.strokeText(a.char,a.x+x,a.y+y);
			this.fillText(a.char,a.x+x,a.y+y);
		}
	}

	/**@private */
	__proto.strokeWord=function(text,x,y,font,color,lineWidth,textAlign){
		Stat.drawCall++;
		if (arguments.length > 3 && font !=null){
			this.font=font;
			this.strokeStyle=color;
			this.lineWidth=lineWidth;
			this.textAlign=textAlign;
			this.textBaseline="top";
		}
		this.strokeText(text,x,y);
	}

	/**@private */
	__proto.setTransformByMatrix=function(value){
		this.setTransform(value.a,value.b,value.c,value.d,value.tx,value.ty);
	}

	/**@private */
	__proto.clipRect=function(x,y,width,height){
		Stat.drawCall++;
		this.beginPath();
		this.rect(x,y,width,height);
		this.clip();
	}

	/**@private */
	__proto.drawTextureWithTransform=function(tex,tx,ty,width,height,m,gx,gy,alpha,blendMode){
		'use strict';
		if (!tex.getEnabled())
			return;
		Stat.drawCall++;
		var alphaChanged=alpha!==1;
		if (alphaChanged){
			var temp=this.globalAlpha;
			this.globalAlpha *=alpha;
		}
		if (blendMode)
			this.globalCompositeOperation=blendMode;
		var uv=tex.uv,w=tex.bitmap._w,h=tex.bitmap._h;
		if (m){
			this.save();
			this.transform(m.a,m.b,m.c,m.d,m.tx+gx,m.ty+gy);
			this.drawImage(tex.bitmap._source,uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h,tx,ty,width,height);
			this.restore();
			}else {
			this.drawImage(tex.bitmap._source,uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h,gx+tx,gy+ty,width,height);
		}
		if (alphaChanged)
			this.globalAlpha=temp;
		if (blendMode)
			this.globalCompositeOperation="source-over";
	}

	/**@private */
	__proto.drawTexture2=function(x,y,pivotX,pivotY,m,args2){
		'use strict';
		var tex=args2[0];
		if (!tex.getEnabled())
			return;
		Stat.drawCall++;
		var uv=tex.uv,w=tex.bitmap._w,h=tex.bitmap._h;
		if (m){
			this.save();
			this.transform(m.a,m.b,m.c,m.d,m.tx+x,m.ty+y);
			this.drawImage(tex.bitmap._source,uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h,args2[1]-pivotX,args2[2]-pivotY,args2[3],args2[4]);
			this.restore();
			}else {
			this.drawImage(tex.bitmap._source,uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h,args2[1]-pivotX+x,args2[2]-pivotY+y,args2[3],args2[4]);
		}
	}

	__proto.fillTexture=function(texture,x,y,width,height,type,offset,other){
		if (!other.pat){
			if (texture.uv !=Texture.DEF_UV){
				var canvas=new HTMLCanvas("2D");
				canvas.getContext('2d');
				canvas.size(texture.width,texture.height);
				canvas.context.drawTexture(texture,0,0,texture.width,texture.height);
				texture=new Texture(canvas);
			}
			other.pat=this.createPattern(texture.bitmap.source,type);
		};
		var oX=x,oY=y;
		var sX=0,sY=0;
		if (offset){
			oX+=offset.x % texture.width;
			oY+=offset.y % texture.height;
			sX-=offset.x % texture.width;
			sY-=offset.y % texture.height;
		}
		this.translate(oX,oY);
		this._drawRect(sX,sY,width,height,other.pat);
		this.translate(-oX,-oY);
	}

	/**@private */
	__proto.flush=function(){
		return 0;
	}

	/**@private */
	__proto.destroy=function(){
		this.canvas.width=this.canvas.height=0;
	}

	/**@private */
	__proto.clear=function(){
		this.clearRect(0,0,this._canvas.width,this._canvas.height);
	}

	__proto.drawTriangle=function(texture,vertices,uvs,index0,index1,index2,matrix,canvasPadding){
		var source=texture.bitmap;
		var textureSource=source.source;
		var textureWidth=texture.width;
		var textureHeight=texture.height;
		var sourceWidth=source.width;
		var sourceHeight=source.height;
		var u0=uvs[index0] *sourceWidth;
		var u1=uvs[index1] *sourceWidth;
		var u2=uvs[index2] *sourceWidth;
		var v0=uvs[index0+1] *sourceHeight;
		var v1=uvs[index1+1] *sourceHeight;
		var v2=uvs[index2+1] *sourceHeight;
		var x0=vertices[index0];
		var x1=vertices[index1];
		var x2=vertices[index2];
		var y0=vertices[index0+1];
		var y1=vertices[index1+1];
		var y2=vertices[index2+1];
		if (canvasPadding){
			var paddingX=1;
			var paddingY=1;
			var centerX=(x0+x1+x2)/ 3;
			var centerY=(y0+y1+y2)/ 3;
			var normX=x0-centerX;
			var normY=y0-centerY;
			var dist=Math.sqrt((normX *normX)+(normY *normY));
			x0=centerX+((normX / dist)*(dist+paddingX));
			y0=centerY+((normY / dist)*(dist+paddingY));
			normX=x1-centerX;
			normY=y1-centerY;
			dist=Math.sqrt((normX *normX)+(normY *normY));
			x1=centerX+((normX / dist)*(dist+paddingX));
			y1=centerY+((normY / dist)*(dist+paddingY));
			normX=x2-centerX;
			normY=y2-centerY;
			dist=Math.sqrt((normX *normX)+(normY *normY));
			x2=centerX+((normX / dist)*(dist+paddingX));
			y2=centerY+((normY / dist)*(dist+paddingY));
		}
		this.save();
		if (matrix)
			this.transform(matrix.a,matrix.b,matrix.c,matrix.d,matrix.tx,matrix.ty);
		this.beginPath();
		this.moveTo(x0,y0);
		this.lineTo(x1,y1);
		this.lineTo(x2,y2);
		this.closePath();
		this.clip();
		var delta=(u0 *v1)+(v0 *u2)+(u1 *v2)-(v1 *u2)-(v0 *u1)-(u0 *v2);
		var dDelta=1 / delta;
		var deltaA=(x0 *v1)+(v0 *x2)+(x1 *v2)-(v1 *x2)-(v0 *x1)-(x0 *v2);
		var deltaB=(u0 *x1)+(x0 *u2)+(u1 *x2)-(x1 *u2)-(x0 *u1)-(u0 *x2);
		var deltaC=(u0 *v1 *x2)+(v0 *x1 *u2)+(x0 *u1 *v2)-(x0 *v1 *u2)-(v0 *u1 *x2)-(u0 *x1 *v2);
		var deltaD=(y0 *v1)+(v0 *y2)+(y1 *v2)-(v1 *y2)-(v0 *y1)-(y0 *v2);
		var deltaE=(u0 *y1)+(y0 *u2)+(u1 *y2)-(y1 *u2)-(y0 *u1)-(u0 *y2);
		var deltaF=(u0 *v1 *y2)+(v0 *y1 *u2)+(y0 *u1 *v2)-(y0 *v1 *u2)-(v0 *u1 *y2)-(u0 *y1 *v2);
		this.transform(deltaA *dDelta,deltaD *dDelta,deltaB *dDelta,deltaE *dDelta,deltaC *dDelta,deltaF *dDelta);
		this.drawImage(textureSource,texture.uv[0] *sourceWidth,texture.uv[1] *sourceHeight,textureWidth,textureHeight,texture.uv[0] *sourceWidth,texture.uv[1] *sourceHeight,textureWidth,textureHeight);
		this.restore();
	}

	//=============新增==================
	__proto.transformByMatrix=function(matrix,tx,ty){
		this.transform(matrix.a,matrix.b,matrix.c,matrix.d,matrix.tx+tx,matrix.ty+ty);
	}

	__proto.saveTransform=function(matrix){
		this.save();
	}

	__proto.restoreTransform=function(matrix){
		this.restore();
	}

	__proto.drawRect=function(x,y,width,height,fillColor,lineColor,lineWidth){
		var ctx=this;
		if (fillColor !=null){
			ctx.fillStyle=fillColor;
			ctx.fillRect(x,y,width,height);
		}
		if (lineColor !=null){
			ctx.strokeStyle=lineColor;
			ctx.lineWidth=lineWidth;
			ctx.strokeRect(x,y,width,height);
		}
	}

	/**@private */
	__proto.drawTexture=function(tex,x,y,width,height){
		if (!tex.loaded)return;
		Stat.drawCall++;
		var uv=tex.uv,w=tex.bitmap.width,h=tex.bitmap.height;
		this.drawImage(tex.bitmap._source,uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h,x,y,width,height);
	}

	__proto.drawTextures=function(tex,pos,tx,ty){
		Stat.drawCall+=pos.length / 2;
		var w=tex.width;
		var h=tex.height;
		for (var i=0,sz=pos.length;i < sz;i+=2){
			this.drawTexture(tex,pos[i]+tx,pos[i+1]+ty,w,h);
		}
	}

	/**
	*绘制三角形
	*@param x
	*@param y
	*@param tex
	*@param args [x,y,texture,vertices,indices,uvs,matrix]
	*/
	__proto.drawTriangles=function(texture,x,y,vertices,uvs,indices,matrix,alpha,color,blendMode){
		var i=0,len=indices.length;
		this.translate(x,y);
		for (i=0;i < len;i+=3){
			var index0=indices[i] *2;
			var index1=indices[i+1] *2;
			var index2=indices[i+2] *2;
			this.drawTriangle(texture,vertices,uvs,index0,index1,index2,matrix,true);
		}
		this.translate(-x,-y);
	}

	__proto.alpha=function(value){
		this.globalAlpha *=value;
	}

	__proto._transform=function(mat,pivotX,pivotY){
		this.translate(pivotX,pivotY);
		this.transform(mat.a,mat.b,mat.c,mat.d,mat.tx,mat.ty);
		this.translate(-pivotX,-pivotY);
	}

	__proto._rotate=function(angle,pivotX,pivotY){
		this.translate(pivotX,pivotY);
		this.rotate(angle);
		this.translate(-pivotX,-pivotY);
	}

	__proto._scale=function(scaleX,scaleY,pivotX,pivotY){
		this.translate(pivotX,pivotY);
		this.scale(scaleX,scaleY);
		this.translate(-pivotX,-pivotY);
	}

	__proto._drawLine=function(x,y,fromX,fromY,toX,toY,lineColor,lineWidth,vid){
		var ctx=this.ctx;
		this.beginPath();
		this.strokeStyle=lineColor;
		this.lineWidth=lineWidth;
		this.moveTo(x+fromX,y+fromY);
		this.lineTo(x+toX,y+toY);
		this.stroke();
	}

	__proto._drawLines=function(x,y,points,lineColor,lineWidth,vid){
		Render.isWebGL && this.setPathId(vid);
		this.beginPath();
		this.strokeStyle=lineColor;
		this.lineWidth=lineWidth;
		var i=2,n=points.length;
		if (Render.isWebGL){
			this.addPath(points.slice(),false,false,x,y);
			}else {
			this.moveTo(x+points[0],y+points[1]);
			while (i < n){
				this.lineTo(x+points[i++],y+points[i++]);
			}
		}
		this.stroke();
	}

	__proto.drawCurves=function(x,y,points,lineColor,lineWidth){
		this.beginPath();
		this.strokeStyle=lineColor;
		this.lineWidth=lineWidth;
		this.moveTo(x+points[0],y+points[1]);
		var i=2,n=points.length;
		while (i < n){
			this.quadraticCurveTo(x+points[i++],y+points[i++],x+points[i++],y+points[i++]);
		}
		this.stroke();
	}

	__proto._fillAndStroke=function(fillColor,strokeColor,lineWidth,isConvexPolygon){
		(isConvexPolygon===void 0)&& (isConvexPolygon=false);
		if (fillColor !=null){
			this.fillStyle=fillColor;
			this.fill();
		}
		if (strokeColor !=null && lineWidth > 0){
			this.strokeStyle=strokeColor;
			this.lineWidth=lineWidth;
			this.stroke();
		}
	}

	__proto._drawCircle=function(x,y,radius,fillColor,lineColor,lineWidth,vid){
		Stat.drawCall++;
		Render.isWebGL? this.beginPath(true):this.beginPath();
		this.arc(x,y,radius,0,Context.PI2);
		this.closePath();
		this._fillAndStroke(fillColor,lineColor,lineWidth);
	}

	//矢量方法
	__proto._drawPie=function(x,y,radius,startAngle,endAngle,fillColor,lineColor,lineWidth,vid){
		this.beginPath();
		this.moveTo(x ,y);
		this.arc(x,y,radius,startAngle,endAngle);
		this.closePath();
		this._fillAndStroke(fillColor,lineColor,lineWidth);
	}

	//ctx.translate(-x-args[0],-y-args[1]);
	__proto._drawPoly=function(x,y,points,fillColor,lineColor,lineWidth,isConvexPolygon,vid){
		var i=2,n=points.length;
		this.beginPath();
		if (Render.isWebGL){
			this.setPathId(vid);
			this.addPath(points.slice(),true,isConvexPolygon,x,y);
			}else {
			this.moveTo(x+points[0],y+points[1]);
			while (i < n){
				this.lineTo(x+points[i++],y+points[i++]);
			}
		}
		this.closePath();
		this._fillAndStroke(fillColor,lineColor,lineWidth,isConvexPolygon);
	}

	__proto._drawPath=function(x,y,paths,brush,pen){
		var ctx=this.ctx;
		this.beginPath();
		for (var i=0,n=paths.length;i < n;i++){
			var path=paths[i];
			switch (path[0]){
				case "moveTo":
					this.moveTo(x+path[1],y+path[2]);
					break ;
				case "lineTo":
					this.lineTo(x+path[1],y+path[2]);
					break ;
				case "arcTo":
					this.arcTo(x+path[1],y+path[2],x+path[3],y+path[4],path[5]);
					break ;
				case "closePath":
					this.closePath();
					break ;
				}
		}
		if (brush !=null){
			this.fillStyle=brush.fillStyle;
			this.fill();
		}
		if (pen !=null){
			this.strokeStyle=pen.strokeStyle;
			this.lineWidth=pen.lineWidth || 1;
			this.lineJoin=pen.lineJoin;
			this.lineCap=pen.lineCap;
			this.miterLimit=pen.miterLimit;
			this.stroke();
		}
	}

	Context.__init__=function(to){
		var from=laya.resource.Context.prototype;
		to=to || CanvasRenderingContext2D.prototype;
		var funs=["saveTransform","restoreTransform","transformByMatrix","drawTriangles","drawTriangle",'drawTextures','fillWords','fillBorderWords','setIsMainContext','drawRect','strokeWord','drawText','fillTexture','setTransformByMatrix','clipRect','drawTexture','drawTexture2','drawTextureWithTransform','flush','clear','destroy','drawCanvas','fillBorderText','drawCurves',"_drawRect","alpha","_transform","_rotate","_scale","_drawLine","_drawLines","_drawCircle","_fillAndStroke","_drawPie","_drawPoly","_drawPath","drawTextureWithTransform"];
		funs.forEach(function(i){
			to[i]=from[i];
		});
	}

	Context.PI2=2 *Math.PI;
	return Context;
})()


	//file:///E:/git/layaair-master/core/src/laya/resource/ResourceManager.as=======199.999866/199.999866
/**
*@private
*<code>ResourceManager</code> 是资源管理类。它用于资源的载入、获取、销毁。
*/
//class laya.resource.ResourceManager
var ResourceManager=(function(){
	function ResourceManager(name){
		/**唯一标识ID。*/
		this._id=0;
		/**名字。*/
		this._name=null;
		/**所管理资源。*/
		this._resources=null;
		/**所管理资源的累计内存,以字节为单位。*/
		this._memorySize=0;
		/**垃圾回收比例，范围是0到1。*/
		this._garbageCollectionRate=NaN;
		/**自动释放机制中内存是否溢出。*/
		this._isOverflow=false;
		/**是否启用自动释放机制。*/
		this.autoRelease=false;
		/**自动释放机制的内存触发上限,以字节为单位。*/
		this.autoReleaseMaxSize=0;
		this._id=++ResourceManager._uniqueIDCounter;
		this._name=name ? name :"Content Manager";
		ResourceManager._isResourceManagersSorted=false;
		this._memorySize=0;
		this._isOverflow=false;
		this.autoRelease=false;
		this.autoReleaseMaxSize=1024 *1024 *512;
		this._garbageCollectionRate=0.2;
		ResourceManager._resourceManagers.push(this);
		this._resources=[];
	}

	__class(ResourceManager,'laya.resource.ResourceManager');
	var __proto=ResourceManager.prototype;
	Laya.imps(__proto,{"laya.resource.IDispose":true})
	/**
	*获取指定索引的资源 Resource 对象。
	*@param 索引。
	*@return 资源 Resource 对象。
	*/
	__proto.getResourceByIndex=function(index){
		return this._resources[index];
	}

	/**
	*获取此管理器所管理的资源个数。
	*@return 资源个数。
	*/
	__proto.getResourcesLength=function(){
		return this._resources.length;
	}

	/**
	*添加指定资源。
	*@param resource 需要添加的资源 Resource 对象。
	*@return 是否添加成功。
	*/
	__proto.addResource=function(resource){
		if (resource.resourceManager)
			resource.resourceManager.removeResource(resource);
		var index=this._resources.indexOf(resource);
		if (index===-1){
			resource._resourceManager=this;
			this._resources.push(resource);
			this.addSize(resource.memorySize);
			return true;
		}
		return false;
	}

	/**
	*移除指定资源。
	*@param resource 需要移除的资源 Resource 对象
	*@return 是否移除成功。
	*/
	__proto.removeResource=function(resource){
		var index=this._resources.indexOf(resource);
		if (index!==-1){
			this._resources.splice(index,1);
			resource._resourceManager=null;
			this._memorySize-=resource.memorySize;
			return true;
		}
		return false;
	}

	/**
	*卸载此资源管理器载入的资源。
	*/
	__proto.unload=function(){
		var tempResources=this._resources.slice(0,this._resources.length);
		for (var i=0;i < tempResources.length;i++){
			var resource=tempResources[i];
			resource.destroy();
		}
		tempResources.length=0;
	}

	/**释放资源。*/
	__proto.dispose=function(){
		if (this===ResourceManager._systemResourceManager)
			throw new Error("systemResourceManager不能被释放！");
		ResourceManager._resourceManagers.splice(ResourceManager._resourceManagers.indexOf(this),1);
		ResourceManager._isResourceManagersSorted=false;
		var tempResources=this._resources.slice(0,this._resources.length);
		for (var i=0;i < tempResources.length;i++){
			var resource=tempResources[i];
			resource.resourceManager.removeResource(resource);
			resource.destroy();
		}
		tempResources.length=0;
	}

	/**
	*增加内存。
	*@param add 需要增加的内存大小。
	*/
	__proto.addSize=function(add){
		if (add){
			if (this.autoRelease && add > 0)
				((this._memorySize+add)> this.autoReleaseMaxSize)&& (this.garbageCollection((1-this._garbageCollectionRate)*this.autoReleaseMaxSize));
			this._memorySize+=add;
		}
	}

	/**
	*垃圾回收。
	*@param reserveSize 保留尺寸。
	*/
	__proto.garbageCollection=function(reserveSize){
		var all=this._resources;
		all=all.slice();
		all.sort(function(a,b){
			if (!a || !b)
				throw new Error("a或b不能为空！");
			if (a.released && b.released)
				return 0;
			else if (a.released)
			return 1;
			else if (b.released)
			return-1;
			return a._lastUseFrameCount-b._lastUseFrameCount;
		});
		var currentFrameCount=Stat.loopCount;
		for (var i=0,n=all.length;i < n;i++){
			var resou=all[i];
			if (currentFrameCount-resou._lastUseFrameCount > 1){
				resou.releaseResource();
				}else {
				if (this._memorySize >=reserveSize)
					this._isOverflow=true;
				return;
			}
			if (this._memorySize < reserveSize){
				this._isOverflow=false;
				return;
			}
		}
	}

	/**
	*唯一标识 ID 。
	*/
	__getset(0,__proto,'id',function(){
		return this._id;
	});

	/**
	*名字。
	*/
	__getset(0,__proto,'name',function(){
		return this._name;
		},function(value){
		if ((value || value!=="")&& this._name!==value){
			this._name=value;
			ResourceManager._isResourceManagersSorted=false;
		}
	});

	/**
	*此管理器所管理资源的累计内存，以字节为单位。
	*/
	__getset(0,__proto,'memorySize',function(){
		return this._memorySize;
	});

	/**
	*系统资源管理器。
	*/
	__getset(1,ResourceManager,'systemResourceManager',function(){
		return ResourceManager._systemResourceManager;
	});

	ResourceManager.__init__=function(){
		ResourceManager.currentResourceManager=ResourceManager.systemResourceManager;
	}

	ResourceManager.getLoadedResourceManagerByIndex=function(index){
		return ResourceManager._resourceManagers[index];
	}

	ResourceManager.getLoadedResourceManagersCount=function(){
		return ResourceManager._resourceManagers.length;
	}

	ResourceManager.recreateContentManagers=function(force){
		(force===void 0)&& (force=false);
		var temp=ResourceManager.currentResourceManager;
		for (var i=0;i < ResourceManager._resourceManagers.length;i++){
			ResourceManager.currentResourceManager=ResourceManager._resourceManagers[i];
			for (var j=0;j < ResourceManager.currentResourceManager._resources.length;j++){
				ResourceManager.currentResourceManager._resources[j].releaseResource(force);
				ResourceManager.currentResourceManager._resources[j].activeResource(force);
			}
		}
		ResourceManager.currentResourceManager=temp;
	}

	ResourceManager.releaseContentManagers=function(force){
		(force===void 0)&& (force=false);
		var temp=ResourceManager.currentResourceManager;
		for (var i=0;i < ResourceManager._resourceManagers.length;i++){
			ResourceManager.currentResourceManager=ResourceManager._resourceManagers[i];
			for (var j=0;j < ResourceManager.currentResourceManager._resources.length;j++){
				var resource=ResourceManager.currentResourceManager._resources[j];
				(!resource.released)&& (resource.releaseResource(force));
			}
		}
		ResourceManager.currentResourceManager=temp;
	}

	ResourceManager._uniqueIDCounter=0;
	ResourceManager._isResourceManagersSorted=false;
	ResourceManager._resourceManagers=[];
	__static(ResourceManager,
	['_systemResourceManager',function(){return this._systemResourceManager=new ResourceManager("System Resource Manager");},'currentResourceManager',function(){return this.currentResourceManager=ResourceManager._systemResourceManager;}
	]);
	return ResourceManager;
})()


	//file:///E:/git/layaair-master/core/src/laya/runtime/ConchCmdReplace.as=======199.999864/199.999864
/**
*...
*@author ww
*/
//class laya.runtime.ConchCmdReplace
var ConchCmdReplace=(function(){
	function ConchCmdReplace(){}
	__class(ConchCmdReplace,'laya.runtime.ConchCmdReplace');
	ConchCmdReplace.__init__=function(){
		DrawImageCmdNative;
		DrawTextureCmdNative;
		DrawTexturesCmdNative;
		DrawTrianglesCmdNative;
		FillTextureCmdNative;
		ClipRectCmdNative;
		FillTextCmdNative;
		FillBorderTextCmdNative;
		FillWordsCmdNative;
		FillBorderWordsCmdNative;
		StrokeTextCmdNative;
		AlphaCmdNative;
		TransformCmdNative;
		RotateCmdNative;
		ScaleCmdNative;
		TranslateCmdNative;
		SaveCmdNative;
		RestoreCmdNative;
		DrawLineCmdNative;
		DrawLinesCmdNative;
		DrawCurvesCmdNative;
		DrawRectCmdNative;
		DrawCircleCmdNative;
		DrawPieCmdNative;
		DrawPolyCmdNative;
		DrawPathCmdNative;
		var cmdO=laya.display.cmd;
		var cmdONative=laya.display.cmdNative;
		var key;
		for (key in cmdO){
			if (cmdONative[key+"Native"]){
				cmdO[key].create=cmdONative[key+"Native"].create;
			}
		}
	}

	return ConchCmdReplace;
})()


	//file:///E:/git/layaair-master/core/src/laya/runtime/ConchGraphicsAdpt.as=======199.999863/199.999863
/**
*...
*@author ww
*/
//class laya.runtime.ConchGraphicsAdpt
var ConchGraphicsAdpt=(function(){
	function ConchGraphicsAdpt(){
		this._buffer=null;
	}

	__class(ConchGraphicsAdpt,'laya.runtime.ConchGraphicsAdpt');
	var __proto=ConchGraphicsAdpt.prototype;
	__proto._createData=function(){
		this._buffer=new GLBuffer(128,64,false,false);
	}

	__proto._clearData=function(){
		if(this._buffer)
			this._buffer.clear();
	}

	__proto._destroyData=function(){
		if (this._buffer){
			this._buffer.clear();
			this._buffer=null;
		}
	}

	ConchGraphicsAdpt.__init__=function(){
		var spP=Graphics["prototype"];
		var mP=ConchGraphicsAdpt["prototype"];
		var funs=[
		"_createData",
		"_clearData",
		"_destroyData"];
		var i=0,len=0;
		len=funs.length;
		var tFunName;
		for (i=0;i < len;i++){
			tFunName=funs[i];
			spP[tFunName]=mP[tFunName];
		}
	}

	return ConchGraphicsAdpt;
})()


	//file:///E:/git/layaair-master/core/src/laya/runtime/layagl/LayaGL2DTemplateCreater.as=======199.999856/199.999856
/**
*@private
*模板组合创建器
*/
//class laya.runtime.layagl.LayaGL2DTemplateCreater
var LayaGL2DTemplateCreater=(function(){
	var LayaGLEmpty;
	function LayaGL2DTemplateCreater(){}
	__class(LayaGL2DTemplateCreater,'laya.runtime.layagl.LayaGL2DTemplateCreater');
	LayaGL2DTemplateCreater.createByRenderType=function(renderType){
		var hasSave=false;
		var tI=0;
		var gl=LayaGL2DTemplateCreater.GLS[renderType]=new LayaGLTemplate();
		if (Render.isConchApp){
			window.conch.setGLTemplate(renderType,gl._buffer._buffer["_ptrID"]);
		}
		if (renderType & 0x01){
			if (!Render.isConchApp){
				gl.addComd(LayaGL.SAVE.name);
				hasSave=true;
			}
			gl.addComd(LayaGL.ALPHA.name);
		}
		if (renderType & 0x02){
			if (!hasSave){
				if (!Render.isConchApp){
					gl.addComd(LayaGL.SAVE.name);
					hasSave=true;
				}
			}
			gl.addComd(LayaGL.TRANSFORM.name);
		}
		tI=0x02 *2;
		while (tI <=0x2000){
			if ((renderType & tI)&& LayaGL2DTemplateCreater._cmds[tI]){
				gl.addComd(LayaGL2DTemplateCreater._cmds[tI]);
			}
			tI=tI *2;
		}
		if (hasSave){
			gl.addComd(LayaGL.RESTORE.name);
		}
		gl._id=renderType;
		return gl;
	}

	LayaGL2DTemplateCreater._getCMDName=function(cmdID){
		if (!LayaGL2DTemplateCreater._cmds[0x01])LayaGL2DTemplateCreater.__initCmds__();
		return LayaGL2DTemplateCreater._cmds[cmdID];
	}

	LayaGL2DTemplateCreater.__initCmds__=function(){
		LayaGL2DTemplateCreater._cmds[0x01]=LayaGL.ALPHA.name;
		LayaGL2DTemplateCreater._cmds[0x02]=LayaGL.TRANSFORM.name;
		LayaGL2DTemplateCreater._cmds[0x100]=LayaGL.DRAW_TEXTURE.name;
		LayaGL2DTemplateCreater._cmds[0x200]=LayaGL.DRAW_LAYAGL.name;
		LayaGL2DTemplateCreater._cmds[0x1000]=Render.isConchApp ? "" :LayaGL.DRAW_NODE.name;
		LayaGL2DTemplateCreater._cmds[0x2000]=Render.isConchApp ? "" :LayaGL.DRAW_NODES.name;
		LayaGL2DTemplateCreater._cmds[0x02 | 0x01]=LayaGL.DRAW_NODES.name;
		LayaGL2DTemplateCreater._cmds[0x08]=LayaGL.DRAW_CANVAS.name;
		LayaGL2DTemplateCreater._cmds[0x04]=LayaGL.DRAW_BLEND.name;
		LayaGL2DTemplateCreater._cmds[0x10]=LayaGL.DRAW_FILTERS.name;
		LayaGL2DTemplateCreater._cmds[0x20]=LayaGL.DRAW_MASK.name;
		LayaGL2DTemplateCreater._cmds[0x40]=LayaGL.DRAW_CLIP.name;
		LayaGL2DTemplateCreater._cmds[0x400]=LayaGL.DRAW_LAYAGL3D.name;
	}

	LayaGL2DTemplateCreater.__init__=function(){
		function one (a,b,c){
			var id=a | b | c;
			if (a < 1 && b < 1){
				var tgl=LayaGL2DTemplateCreater.GLS[id]=new LayaGLEmpty();
				if (Render.isConchApp){
					window.conch.setGLTemplate(id,tgl._buffer._buffer["_ptrID"]);
				}
				return tgl;
			}
			if (LayaGL2DTemplateCreater.GLS[id])
				return LayaGL2DTemplateCreater.GLS[id];
			if (LayaGL2DTemplateCreater.GLS.length <=id)
				LayaGL2DTemplateCreater.GLS.length=id;
			var gl=LayaGL2DTemplateCreater.GLS[id]=new LayaGLTemplate();
			if (Render.isConchApp){
				window.conch.setGLTemplate(id,gl._buffer._buffer["_ptrID"]);
			}
			if (c > 0){
				Render.isConchApp || gl.addComd(LayaGL.SAVE.name);
				if (c===(0x02 | 0x01)){
					gl.addComd(LayaGL.ALPHA.name);
					gl.addComd(LayaGL.TRANSFORM.name);
				}
				else
				gl.addComd(LayaGL2DTemplateCreater._cmds[c]);
			}
			if ((a | b)==(0x200 | 0x100)){
				gl.addComd(LayaGL.DRAW_TEXTURE_AND_GRAPHICS.name);
			}
			else {
				if (a > 0){
					gl.addComd(LayaGL2DTemplateCreater._cmds[a]);
				}
				if (b > 0 && a!==b){
					gl.addComd(LayaGL2DTemplateCreater._cmds[b]);
				}
			}
			if (c > 0){
				Render.isConchApp || gl.addComd(LayaGL.RESTORE.name);
			}
			gl._id=id;
			return gl;
		}
		function some (a,b,c){
			for (var ia=0;ia < a.length;ia++)
			for (var ib=0;ib < b.length;ib++)
			for (var ic=0;ic < c.length;ic++)
			one(a[ia],b[ib],c[ic]);
		}
		LayaGL2DTemplateCreater.__initCmds__();
		LayaGL2DTemplateCreater.GLS.length=0x2000 *2;
		some([0,0x200,0x100],[0,0x200,0x100,0x1000,0x2000],[0,0x01,0x02,0x01 | 0x02,0x08]);
	}

	LayaGL2DTemplateCreater.GLS=[];
	LayaGL2DTemplateCreater._cmds=[];
	LayaGL2DTemplateCreater.__init$=function(){
		//class LayaGLEmpty extends laya.runtime.layagl.LayaGLTemplate
		LayaGLEmpty=(function(_super){
			function LayaGLEmpty(){
				LayaGLEmpty.__super.call(this);;
			}
			__class(LayaGLEmpty,'',_super);
			return LayaGLEmpty;
		})(LayaGLTemplate)
	}

	return LayaGL2DTemplateCreater;
})()


	//file:///E:/git/layaair-master/core/src/laya/runtime/layagl/LayaGLTemplate.as=======199.999854/199.999854
/**
*@private
*命令模板，用来优化合并命令执行
*/
//class laya.runtime.layagl.LayaGLTemplate
var LayaGLTemplate=(function(){
	function LayaGLTemplate(){
		this._commStr="";
		this._id=0;
		this._buffer=new GLBuffer(64,16,true,false);
	}

	__class(LayaGLTemplate,'laya.runtime.layagl.LayaGLTemplate');
	var __proto=LayaGLTemplate.prototype;
	__proto.addComd=function(name){
		if (!name)return this._buffer.getCount();
		this._commStr+=name+";";
		return this._buffer.add_i(LayaGL._glMap[name].id);
	}

	return LayaGLTemplate;
})()


	//file:///E:/git/layaair-master/core/src/laya/runtime/MatrixConch.as=======199.999853/199.999853
/**
*<p> <code>Matrix</code> 类表示一个转换矩阵，它确定如何将点从一个坐标空间映射到另一个坐标空间。</p>
*<p>您可以对一个显示对象执行不同的图形转换，方法是设置 Matrix 对象的属性，将该 Matrix 对象应用于 Transform 对象的 matrix 属性，然后应用该 Transform 对象作为显示对象的 transform 属性。这些转换函数包括平移（x 和 y 重新定位）、旋转、缩放和倾斜。</p>
*/
//class laya.runtime.MatrixConch
var MatrixConch=(function(){
	function MatrixConch(a,b,c,d,tx,ty,nums){
		/**@private */
		//this._nums=null;
		/**@private 是否有旋转缩放操作*/
		//this._bTransform=false;
		(a===void 0)&& (a=1);
		(b===void 0)&& (b=0);
		(c===void 0)&& (c=0);
		(d===void 0)&& (d=1);
		(tx===void 0)&& (tx=0);
		(ty===void 0)&& (ty=0);
		this._nums=nums=nums ? nums :new Float32Array(6);
		nums[0]=a;
		nums[1]=b;
		nums[2]=c;
		nums[3]=d;
		nums[4]=tx;
		nums[5]=ty;
		this._checkTransform();
	}

	__class(MatrixConch,'laya.runtime.MatrixConch');
	var __proto=MatrixConch.prototype;
	/**
	*将本矩阵设置为单位矩阵。
	*@return 返回矩阵对象本身
	*/
	__proto.identity=function(){
		var nums=this._nums;
		nums[0]=nums[3]=1;
		nums[1]=nums[4]=nums[5]=nums[2]=0;
		this._bTransform=false;
		return this;
	}

	/**@private */
	__proto._checkTransform=function(){
		var nums=this._nums;
		return this._bTransform=(nums[0]!==1 || nums[1]!==0 || nums[2]!==0 || nums[3]!==1);
	}

	/**
	*设置沿 x 、y 轴平移每个点的距离。
	*@param x 沿 x 轴平移每个点的距离。
	*@param y 沿 y 轴平移每个点的距离。
	*@return 返回矩阵对象本身
	*/
	__proto.setTranslate=function(x,y){
		this._nums[4]=x;
		this._nums[5]=y;
		return this;
	}

	/**
	*沿 x 和 y 轴平移矩阵，平移的变化量由 x 和 y 参数指定。
	*@param x 沿 x 轴向右移动的量（以像素为单位）。
	*@param y 沿 y 轴向下移动的量（以像素为单位）。
	*@return 返回矩阵对象本身
	*/
	__proto.translate=function(x,y){
		this._nums[4]+=x;
		this._nums[5]+=y;
		return this;
	}

	/**
	*对矩阵应用缩放转换。
	*@param x 用于沿 x 轴缩放对象的乘数。
	*@param y 用于沿 y 轴缩放对象的乘数。
	*@return 返回矩阵对象本身
	*/
	__proto.scale=function(x,y){
		var nums=this._nums;
		nums[0] *=x;
		nums[3] *=y;
		nums[2] *=x;
		nums[1] *=y;
		nums[4] *=x;
		nums[5] *=y;
		this._bTransform=true;
		return this;
	}

	/**
	*对 Matrix 对象应用旋转转换。
	*@param angle 以弧度为单位的旋转角度。
	*@return 返回矩阵对象本身
	*/
	__proto.rotate=function(angle){
		var nums=this._nums;
		var cos=Math.cos(angle);
		var sin=Math.sin(angle);
		var a1=nums[0];
		var c1=nums[2];
		var tx1=nums[4];
		nums[0]=a1 *cos-nums[1] *sin;
		nums[1]=a1 *sin+nums[1] *cos;
		nums[2]=c1 *cos-nums[3] *sin;
		nums[3]=c1 *sin+nums[3] *cos;
		nums[4]=tx1 *cos-nums[5] *sin;
		nums[5]=tx1 *sin+nums[5] *cos;
		this._bTransform=true;
		return this;
	}

	/**
	*对 Matrix 对象应用倾斜转换。
	*@param x 沿着 X 轴的 2D 倾斜弧度。
	*@param y 沿着 Y 轴的 2D 倾斜弧度。
	*@return 返回矩阵对象本身
	*/
	__proto.skew=function(x,y){
		var nums=this._nums;
		var tanX=Math.tan(x);
		var tanY=Math.tan(y);
		var a1=nums[0];
		var b1=nums[1];
		nums[0]+=tanY *nums[2];
		nums[1]+=tanY *nums[3];
		nums[2]+=tanX *a1;
		nums[3]+=tanX *b1;
		return this;
	}

	/**
	*对指定的点应用当前矩阵的逆转化并返回此点。
	*@param out 待转化的点 Point 对象。
	*@return 返回out
	*/
	__proto.invertTransformPoint=function(out){
		var nums=this._nums;
		var a1=nums[0];
		var b1=nums[1];
		var c1=nums[2];
		var d1=nums[3];
		var tx1=nums[4];
		var n=a1 *d1-b1 *c1;
		var a2=d1 / n;
		var b2=-b1 / n;
		var c2=-c1 / n;
		var d2=a1 / n;
		var tx2=(c1 *nums[5]-d1 *tx1)/ n;
		var ty2=-(a1 *nums[5]-b1 *tx1)/ n;
		return out.setTo(a2 *out.x+c2 *out.y+tx2,b2 *out.x+d2 *out.y+ty2);
	}

	/**
	*将 Matrix 对象表示的几何转换应用于指定点。
	*@param out 用来设定输出结果的点。
	*@return 返回out
	*/
	__proto.transformPoint=function(out){
		var nums=this._nums;
		return out.setTo(nums[0] *out.x+nums[2] *out.y+nums[4],nums[1] *out.x+nums[3] *out.y+nums[5]);
	}

	/**
	*将 Matrix 对象表示的几何转换应用于指定点，忽略tx、ty。
	*@param out 用来设定输出结果的点。
	*@return 返回out
	*/
	__proto.transformPointN=function(out){
		var nums=this._nums;
		return out.setTo(nums[0] *out.x+nums[2] *out.y ,nums[1] *out.x+nums[3] *out.y);
	}

	/**
	*获取 X 轴缩放值。
	*@return X 轴缩放值。
	*/
	__proto.getScaleX=function(){
		var nums=this._nums;
		return nums[1]===0 ? this.a :Math.sqrt(nums[0] *nums[0]+nums[1] *nums[1]);
	}

	/**
	*获取 Y 轴缩放值。
	*@return Y 轴缩放值。
	*/
	__proto.getScaleY=function(){
		var nums=this._nums;
		return nums[2]===0 ? nums[3] :Math.sqrt(nums[2] *nums[2]+nums[3] *nums[3]);
	}

	/**
	*执行原始矩阵的逆转换。
	*@return 返回矩阵对象本身
	*/
	__proto.invert=function(){
		var nums=this._nums;
		var a1=nums[0];
		var b1=nums[1];
		var c1=nums[2];
		var d1=nums[3];
		var tx1=nums[4];
		var n=a1 *d1-b1 *c1;
		nums[0]=d1 / n;
		nums[1]=-b1 / n;
		nums[2]=-c1 / n;
		nums[3]=a1 / n;
		nums[4]=(c1 *this.ty-d1 *tx1)/ n;
		nums[5]=-(a1 *this.ty-b1 *tx1)/ n;
		return this;
	}

	/**
	*将 Matrix 的成员设置为指定值。
	*@param a 缩放或旋转图像时影响像素沿 x 轴定位的值。
	*@param b 旋转或倾斜图像时影响像素沿 y 轴定位的值。
	*@param c 旋转或倾斜图像时影响像素沿 x 轴定位的值。
	*@param d 缩放或旋转图像时影响像素沿 y 轴定位的值。
	*@param tx 沿 x 轴平移每个点的距离。
	*@param ty 沿 y 轴平移每个点的距离。
	*@return 返回矩阵对象本身
	*/
	__proto.setTo=function(a,b,c,d,tx,ty){
		var nums=this._nums;
		nums[0]=a,nums[1]=b,nums[2]=c,nums[3]=d,nums[4]=tx,nums[5]=ty;
		return this;
	}

	/**
	*将指定矩阵与当前矩阵连接，从而将这两个矩阵的几何效果有效地结合在一起。
	*@param matrix 要连接到源矩阵的矩阵。
	*@return 当前矩阵。
	*/
	__proto.concat=function(matrix){
		var nums=this._nums;
		var aNums=matrix._nums;
		var a=nums[0];
		var c=nums[2];
		var tx=nums[4];
		nums[0]=a *aNums[0]+nums[1] *aNums[2];
		nums[1]=a *aNums[1]+nums[1] *aNums[3];
		nums[2]=c *aNums[0]+nums[3] *aNums[2];
		nums[3]=c *aNums[1]+nums[3] *aNums[3];
		nums[4]=tx *aNums[0]+nums[5] *aNums[2]+aNums[4];
		nums[5]=tx *aNums[1]+nums[5] *aNums[3]+aNums[5];
		return this;
	}

	/**
	*@private
	*对矩阵应用缩放转换。反向相乘
	*@param x 用于沿 x 轴缩放对象的乘数。
	*@param y 用于沿 y 轴缩放对象的乘数。
	*/
	__proto.scaleEx=function(x,y){
		var nums=this._nums;
		var ba=nums[0],bb=nums[1],bc=nums[2],bd=nums[3];
		if (bb!==0 || bc!==0){
			nums[0]=x *ba;
			nums[1]=x *bb;
			nums[2]=y *bc;
			nums[3]=y *bd;
			}else {
			nums[0]=x *ba;
			nums[1]=0 *bd;
			nums[2]=0 *ba;
			nums[3]=y *bd;
		}
		this._bTransform=true;
	}

	/**
	*@private
	*对 Matrix 对象应用旋转转换。反向相乘
	*@param angle 以弧度为单位的旋转角度。
	*/
	__proto.rotateEx=function(angle){
		var nums=this._nums;
		var cos=Math.cos(angle);
		var sin=Math.sin(angle);
		var ba=nums[0],bb=nums[1],bc=nums[2],bd=nums[3];
		if (bb!==0 || bc!==0){
			nums[0]=cos *ba+sin *bc;
			nums[1]=cos *bb+sin *bd;
			nums[2]=-sin *ba+cos *bc;
			nums[3]=-sin *bb+cos *bd;
			}else {
			nums[0]=cos *ba;
			nums[1]=sin *bd;
			nums[2]=-sin *ba;
			nums[3]=cos *bd;
		}
		this._bTransform=true;
	}

	/**
	*返回此 Matrix 对象的副本。
	*@return 与原始实例具有完全相同的属性的新 Matrix 实例。
	*/
	__proto.clone=function(){
		var nums=this._nums;
		var dec=MatrixConch.create();
		var dNums=dec._nums;
		dNums[0]=nums[0];
		dNums[1]=nums[1];
		dNums[2]=nums[2];
		dNums[3]=nums[3];
		dNums[4]=nums[4];
		dNums[5]=nums[5];
		dec._bTransform=this._bTransform;
		return dec;
	}

	/**
	*将当前 Matrix 对象中的所有矩阵数据复制到指定的 Matrix 对象中。
	*@param dec 要复制当前矩阵数据的 Matrix 对象。
	*@return 已复制当前矩阵数据的 Matrix 对象。
	*/
	__proto.copyTo=function(dec){
		var nums=this._nums;
		var dNums=dec._nums;
		dNums[0]=nums[0];
		dNums[1]=nums[1];
		dNums[2]=nums[2];
		dNums[3]=nums[3];
		dNums[4]=nums[4];
		dNums[5]=nums[5];
		dec._bTransform=this._bTransform;
		return dec;
	}

	/**
	*返回列出该 Matrix 对象属性的文本值。
	*@return 一个字符串，它包含 Matrix 对象的属性值：a、b、c、d、tx 和 ty。
	*/
	__proto.toString=function(){
		return this.a+","+this.b+","+this.c+","+this.d+","+this.tx+","+this.ty;
	}

	/**
	*销毁此对象。
	*/
	__proto.destroy=function(){
		this.recover();
	}

	/**
	*回收到对象池，方便复用
	*/
	__proto.recover=function(){
		MatrixConch._pool.push(this);
	}

	/**缩放或旋转图像时影响像素沿 x 轴定位的值。*/
	__getset(0,__proto,'a',function(){
		return this._nums[0];
		},function(value){
		this._nums[0]=value;
	});

	/**旋转或倾斜图像时影响像素沿 y 轴定位的值。*/
	__getset(0,__proto,'b',function(){
		return this._nums[1];
		},function(value){
		this._nums[1]=value;
	});

	/**旋转或倾斜图像时影响像素沿 x 轴定位的值。*/
	__getset(0,__proto,'c',function(){
		return this._nums[2];
		},function(value){
		this._nums[2]=value;
	});

	/**缩放或旋转图像时影响像素沿 y 轴定位的值。*/
	__getset(0,__proto,'d',function(){
		return this._nums[3];
		},function(value){
		this._nums[3]=value;
	});

	/**沿 x 轴平移每个点的距离。*/
	__getset(0,__proto,'tx',function(){
		return this._nums[4];
		},function(value){
		this._nums[4]=value;
	});

	/**沿 y 轴平移每个点的距离。*/
	__getset(0,__proto,'ty',function(){
		return this._nums[5];
		},function(value){
		this._nums[5]=value;
	});

	MatrixConch.mul=function(m1,m2,out){
		var m1Nums=m1._nums;
		var m2Nums=m2._nums;
		var oNums=out._nums;
		var aa=m1Nums[0],ab=m1Nums[1],ac=m1Nums[2],ad=m1Nums[3],atx=m1Nums[4],aty=m1Nums[5];
		var ba=m2Nums[0],bb=m2Nums[1],bc=m2Nums[2],bd=m2Nums[3],btx=m2Nums[4],bty=m2Nums[5];
		if (bb!==0 || bc!==0){
			oNums[0]=aa *ba+ab *bc;
			oNums[1]=aa *bb+ab *bd;
			oNums[2]=ac *ba+ad *bc;
			oNums[3]=ac *bb+ad *bd;
			oNums[4]=ba *atx+bc *aty+btx;
			oNums[5]=bb *atx+bd *aty+bty;
			}else {
			oNums[0]=aa *ba;
			oNums[1]=ab *bd;
			oNums[2]=ac *ba;
			oNums[3]=ad *bd;
			oNums[4]=ba *atx+btx;
			oNums[5]=bd *aty+bty;
		}
		return out;
	}

	MatrixConch.mul16=function(m1,m2,out){
		var m1Nums=m1._nums;
		var m2Nums=m2._nums;
		var aa=m1Nums[0],ab=m1Nums[1],ac=m1Nums[2],ad=m1Nums[3],atx=m1Nums[4],aty=m1Nums[5];
		var ba=m2Nums[0],bb=m2Nums[1],bc=m2Nums[2],bd=m2Nums[3],btx=m2Nums[4],bty=m2Nums[5];
		if (bb!==0 || bc!==0){
			out[0]=aa *ba+ab *bc;
			out[1]=aa *bb+ab *bd;
			out[4]=ac *ba+ad *bc;
			out[5]=ac *bb+ad *bd;
			out[12]=ba *atx+bc *aty+btx;
			out[13]=bb *atx+bd *aty+bty;
			}else {
			out[0]=aa *ba;
			out[1]=ab *bd;
			out[4]=ac *ba;
			out[5]=ad *bd;
			out[12]=ba *atx+btx;
			out[13]=bd *aty+bty;
		}
		return out;
	}

	MatrixConch.mulPre=function(m1,ba,bb,bc,bd,btx,bty,out){
		var m1Nums=m1._nums;
		var oNums=out._nums;
		var aa=m1Nums[0],ab=m1Nums[1],ac=m1Nums[2],ad=m1Nums[3],atx=m1Nums[4],aty=m1Nums[5];
		if (bb!==0 || bc!==0){
			oNums[0]=aa *ba+ab *bc;
			oNums[1]=aa *bb+ab *bd;
			oNums[2]=ac *ba+ad *bc;
			oNums[3]=ac *bb+ad *bd;
			oNums[4]=ba *atx+bc *aty+btx;
			oNums[5]=bb *atx+bd *aty+bty;
			}else {
			oNums[0]=aa *ba;
			oNums[1]=ab *bd;
			oNums[2]=ac *ba;
			oNums[3]=ad *bd;
			oNums[4]=ba *atx+btx;
			oNums[5]=bd *aty+bty;
		}
		return out;
	}

	MatrixConch.mulPos=function(m1,aa,ab,ac,ad,atx,aty,out){
		var m1Nums=m1._nums;
		var oNums=out._nums;
		var ba=m1Nums[0],bb=m1Nums[1],bc=m1Nums[2],bd=m1Nums[3],btx=m1Nums[4],bty=m1Nums[5];
		if (bb!==0 || bc!==0){
			oNums[0]=aa *ba+ab *bc;
			oNums[1]=aa *bb+ab *bd;
			oNums[2]=ac *ba+ad *bc;
			oNums[3]=ac *bb+ad *bd;
			oNums[4]=ba *atx+bc *aty+btx;
			oNums[5]=bb *atx+bd *aty+bty;
			}else {
			oNums[0]=aa *ba;
			oNums[1]=ab *bd;
			oNums[2]=ac *ba;
			oNums[3]=ad *bd;
			oNums[4]=ba *atx+btx;
			oNums[5]=bd *aty+bty;
		}
		return out;
	}

	MatrixConch.preMul=function(parent,self,out){
		var pNums=parent._nums;
		var sNums=self._nums;
		var oNums=out._nums;
		var pa=pNums[0],pb=pNums[1],pc=pNums[2],pd=pNums[3];
		var na=sNums[0],nb=sNums[1],nc=sNums[2],nd=sNums[3],ntx=sNums[4],nty=sNums[5];
		oNums[0]=na *pa;
		oNums[1]=oNums[2]=0;
		oNums[3]=nd *pd;
		oNums[4]=ntx *pa+pNums[4];
		oNums[5]=nty *pd+pNums[5];
		if (nb!==0 || nc!==0 || pb!==0 || pc!==0){
			oNums[0]+=nb *pc;
			oNums[3]+=nc *pb;
			oNums[1]+=na *pb+nb *pd;
			oNums[2]+=nc *pa+nd *pc;
			oNums[4]+=nty *pc;
			oNums[5]+=ntx *pb;
		}
		return out;
	}

	MatrixConch.preMulXY=function(parent,x,y,out){
		var pNums=parent._nums;
		var oNums=out._nums;
		var pa=pNums[0],pb=pNums[1],pc=pNums[2],pd=pNums[3];
		oNums[0]=pa;
		oNums[1]=pb;
		oNums[2]=pc;
		oNums[3]=pd;
		oNums[4]=x *pa+pNums[4]+y *pc;
		oNums[5]=y *pd+pNums[5]+x *pb;
		return out;
	}

	MatrixConch.create=function(nums){
		var m;
		if (MatrixConch._pool.length){
			m=MatrixConch._pool.pop();
			nums && (m._nums=nums);
			m.identity();
			return m;
		}else return new MatrixConch(1,0,0,1,0,0,nums);
	}

	MatrixConch.A=0;
	MatrixConch.B=1;
	MatrixConch.C=2;
	MatrixConch.D=3;
	MatrixConch.TX=4;
	MatrixConch.TY=5;
	MatrixConch.EMPTY=new MatrixConch();
	MatrixConch.TEMP=new MatrixConch();
	MatrixConch._pool=[];
	return MatrixConch;
})()


	//file:///E:/git/layaair-master/core/src/laya/utils/Browser.as=======199.999851/199.999851
/**
*<code>Browser</code> 是浏览器代理类。封装浏览器及原生 js 提供的一些功能。
*/
//class laya.utils.Browser
var Browser=(function(){
	function Browser(){}
	__class(Browser,'laya.utils.Browser');
	/**获得设备像素比。*/
	__getset(1,Browser,'pixelRatio',function(){
		if (Browser._pixelRatio < 0){
			Browser.__init__();
			if (Browser.userAgent.indexOf("Mozilla/6.0(Linux; Android 6.0; HUAWEI NXT-AL10 Build/HUAWEINXT-AL10)")>-1)Browser._pixelRatio=2;
			else {
				var ctx=Browser.context;
				var backingStore=ctx.backingStorePixelRatio || ctx.webkitBackingStorePixelRatio || ctx.mozBackingStorePixelRatio || ctx.msBackingStorePixelRatio || ctx.oBackingStorePixelRatio || ctx.backingStorePixelRatio || 1;
				Browser._pixelRatio=(Browser._window.devicePixelRatio || 1)/ backingStore;
				if (Browser._pixelRatio < 1)Browser._pixelRatio=1;
			}
		}
		return Browser._pixelRatio;
	});

	/**浏览器窗口物理高度。考虑了设备像素比。*/
	__getset(1,Browser,'height',function(){
		Browser.__init__();
		return ((Laya.stage && Laya.stage.canvasRotation)? Browser.clientWidth :Browser.clientHeight)*Browser.pixelRatio;
	});

	/**
	*浏览器窗口可视宽度。
	*通过分析浏览器信息获得。浏览器多个属性值优先级为：window.innerWidth(包含滚动条宽度)> document.body.clientWidth(不包含滚动条宽度)，如果前者为0或为空，则选择后者。
	*/
	__getset(1,Browser,'clientWidth',function(){
		Browser.__init__();
		return Browser._window.innerWidth || Browser._document.body.clientWidth;
	});

	/**浏览器原生 window 对象的引用。*/
	__getset(1,Browser,'window',function(){
		return Browser._window || Browser.__init__();
	});

	/**
	*浏览器窗口可视高度。
	*通过分析浏览器信息获得。浏览器多个属性值优先级为：window.innerHeight(包含滚动条高度)> document.body.clientHeight(不包含滚动条高度)> document.documentElement.clientHeight(不包含滚动条高度)，如果前者为0或为空，则选择后者。
	*/
	__getset(1,Browser,'clientHeight',function(){
		Browser.__init__();
		return Browser._window.innerHeight || Browser._document.body.clientHeight || Browser._document.documentElement.clientHeight;
	});

	/**浏览器窗口物理宽度。考虑了设备像素比。*/
	__getset(1,Browser,'width',function(){
		Browser.__init__();
		return ((Laya.stage && Laya.stage.canvasRotation)? Browser.clientHeight :Browser.clientWidth)*Browser.pixelRatio;
	});

	/**画布容器，用来盛放画布的容器。方便对画布进行控制*/
	__getset(1,Browser,'container',function(){
		if (!Browser._container){
			Browser.__init__();
			Browser._container=Browser.createElement("div");
			Browser._container.id="layaContainer";
			Browser._document.body.appendChild(Browser._container);
		}
		return Browser._container;
		},function(value){
		Browser._container=value;
	});

	/**浏览器原生 document 对象的引用。*/
	__getset(1,Browser,'document',function(){
		Browser.__init__();
		return Browser._document;
	});

	Browser.__init__=function(){
		if (Browser._window)return Browser._window;
		var win=Browser._window=window;
		var doc=Browser._document=win.document;
		win.requestAnimationFrame=win.requestAnimationFrame || win.webkitRequestAnimationFrame || win.mozRequestAnimationFrame || win.oRequestAnimationFrame || win.msRequestAnimationFrame || function (fun){
			return win.setTimeout(fun,1000 / 60);
		};
		var bodyStyle=doc.body.style;
		bodyStyle.margin=0;
		bodyStyle.overflow='hidden';
		var metas=doc.getElementsByTagName('meta');
		var i=0,flag=false,content='width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no';
		while (i < metas.length){
			var meta=metas[i];
			if (meta.name=='viewport'){
				meta.content=content;
				flag=true;
				break ;
			}
			i++;
		}
		if (!flag){
			meta=doc.createElement('meta');
			meta.name='viewport',meta.content=content;
			doc.getElementsByTagName('head')[0].appendChild(meta);
		};
		var u=Browser.userAgent=win.navigator.userAgent;
		Browser.onMobile=u.indexOf("Mobile")>-1;
		Browser.onIOS=!!u.match(/\(i[^;]+;(U;)? CPU.+Mac OS X/);
		Browser.onIPhone=u.indexOf("iPhone")>-1;
		Browser.onIPad=u.indexOf("iPad")>-1;
		Browser.onAndroid=u.indexOf('Android')>-1 || u.indexOf('Adr')>-1;
		Browser.onWP=u.indexOf("Windows Phone")>-1;
		Browser.onQQBrowser=u.indexOf("QQBrowser")>-1;
		Browser.onMQQBrowser=u.indexOf("MQQBrowser")>-1 ||(u.indexOf("Mobile")>-1 && u.indexOf("QQ")>-1);
		Browser.onIE=!!win.ActiveXObject || "ActiveXObject" in win;
		Browser.onWeiXin=u.indexOf('MicroMessenger')>-1;
		Browser.onSafari=!!u.match(/Version\/\d+\.\d\x20Mobile\/\S+\x20Safari/);
		Browser.onPC=!Browser.onMobile;
		Browser.supportLocalStorage=LocalStorage.__init__();
		Browser.supportWebAudio=SoundManager.__init__();
		Render._mainCanvas=HTMLCanvas.create('2D');
		Browser.canvas=HTMLCanvas.create('2D');
		Browser.context=Browser.canvas.getContext('2d');
		return win;
	}

	Browser.createElement=function(type){
		Browser.__init__();
		return Browser._document.createElement(type);
	}

	Browser.getElementById=function(type){
		Browser.__init__();
		return Browser._document.getElementById(type);
	}

	Browser.removeElement=function(ele){
		if (ele && ele.parentNode)ele.parentNode.removeChild(ele);
	}

	Browser.now=function(){
		return Date.now();;
	}

	Browser.userAgent=null;
	Browser.onMobile=false;
	Browser.onIOS=false;
	Browser.onIPhone=false;
	Browser.onIPad=false;
	Browser.onAndroid=false;
	Browser.onWP=false;
	Browser.onQQBrowser=false;
	Browser.onMQQBrowser=false;
	Browser.onSafari=false;
	Browser.onIE=false;
	Browser.onWeiXin=false;
	Browser.onPC=false;
	Browser.supportWebAudio=false;
	Browser.supportLocalStorage=false;
	Browser.canvas=null;
	Browser.context=null;
	Browser._window=null;
	Browser._document=null;
	Browser._container=null;
	Browser._pixelRatio=-1;
	return Browser;
})()


	//file:///E:/git/layaair-master/core/src/laya/utils/CacheManger.as=======199.999849/199.999849
/**
*@private
*对象缓存统一管理类
*/
//class laya.utils.CacheManger
var CacheManger=(function(){
	function CacheManger(){}
	__class(CacheManger,'laya.utils.CacheManger');
	CacheManger.regCacheByFunction=function(disposeFunction,getCacheListFunction){
		CacheManger.unRegCacheByFunction(disposeFunction,getCacheListFunction);
		var cache;
		cache={tryDispose:disposeFunction,getCacheList:getCacheListFunction};
		CacheManger._cacheList.push(cache);
	}

	CacheManger.unRegCacheByFunction=function(disposeFunction,getCacheListFunction){
		var i=0,len=0;
		len=CacheManger._cacheList.length;
		for (i=0;i < len;i++){
			if (CacheManger._cacheList[i].tryDispose==disposeFunction && CacheManger._cacheList[i].getCacheList==getCacheListFunction){
				CacheManger._cacheList.splice(i,1);
				return;
			}
		}
	}

	CacheManger.forceDispose=function(){
		var i=0,len=CacheManger._cacheList.length;
		for (i=0;i < len;i++){
			CacheManger._cacheList[i].tryDispose(true);
		}
	}

	CacheManger.beginCheck=function(waitTime){
		(waitTime===void 0)&& (waitTime=15000);
		Laya.timer.loop(waitTime,null,CacheManger._checkLoop);
	}

	CacheManger.stopCheck=function(){
		Laya.timer.clear(null,CacheManger._checkLoop);
	}

	CacheManger._checkLoop=function(){
		var cacheList=CacheManger._cacheList;
		if (cacheList.length < 1)return;
		var tTime=Browser.now();
		var count=0;
		var len=0;
		len=count=cacheList.length;
		while (count > 0){
			CacheManger._index++;
			CacheManger._index=CacheManger._index % len;
			cacheList[CacheManger._index].tryDispose(false);
			if (Browser.now()-tTime > CacheManger.loopTimeLimit)break ;
			count--;
		}
	}

	CacheManger.loopTimeLimit=2;
	CacheManger._cacheList=[];
	CacheManger._index=0;
	return CacheManger;
})()


	//file:///E:/git/layaair-master/core/src/laya/utils/Color.as=======199.999847/199.999847
/**
*@private
*<code>Color</code> 是一个颜色值处理类。
*/
//class laya.utils.Color
var Color=(function(){
	function Color(value){
		//TODO:delete？
		this.arrColor=[];
		/**字符串型颜色值。*/
		//this.strColor=null;
		/**uint 型颜色值。*/
		//this.numColor=0;
		/**@private TODO:*/
		//this._drawStyle=null;
		if (value==null){
			this.strColor="#00000000";
			this.numColor=0;
			this.arrColor=[0,0,0,0];
			return;
		};
		var i=0,len=0;
		var color=0;
		if ((typeof value=='string')){
			if ((value).indexOf("rgba(")>=0){
				var tStr=value;
				var beginI=0,endI=0;
				beginI=tStr.indexOf("(");
				endI=tStr.indexOf(")");
				tStr=tStr.substring(beginI+1,endI);
				this.arrColor=tStr.split(",");
				len=this.arrColor.length;
				for (i=0;i < len;i++){
					this.arrColor[i]=parseFloat(this.arrColor[i]);
				}
				color=((this.arrColor[0] *256+this.arrColor[1])*256+this.arrColor[2])*256+Math.round(this.arrColor[3] *255);
				this.strColor=value;
				}else{
				this.strColor=value;
				value.charAt(0)==='#' && (value=value.substr(1));
				len=value.length;
				if (len===3 || len===4){
					var temp="";
					for (i=0;i < len;i++){
						temp+=(value[i]+value[i]);
					}
					value=temp;
				}
				color=parseInt(value,16);
			}
			}else {
			color=value;
			this.strColor=Utils.toHexColor(color);
		}
		if (this.strColor.indexOf("rgba")>=0 || this.strColor.length===9){
			this.arrColor=[((0xFF000000 & color)>>>24)/ 255,((0xFF0000 & color)>> 16)/ 255,((0xFF00 & color)>>8)/ 255,(0xFF & color)/ 255];
			this.numColor=(0xff000000&color)>>>24|(color & 0xff0000)>> 8 | (color & 0x00ff00)<<8 | ((color & 0xff)<<24);
			}else {
			this.arrColor=[((0xFF0000 & color)>> 16)/ 255,((0xFF00 & color)>> 8)/ 255,(0xFF & color)/ 255,1];
			this.numColor=0xff000000|(color & 0xff0000)>> 16 | (color & 0x00ff00)| (color & 0xff)<< 16;
		}
		(this.arrColor).__id=++Color._COLODID;
	}

	__class(Color,'laya.utils.Color');
	Color._initDefault=function(){
		Color._DEFAULT={};
		for (var i in Color._COLOR_MAP)Color._SAVE[i]=Color._DEFAULT[i]=new Color(Color._COLOR_MAP[i]);
		return Color._DEFAULT;
	}

	Color._initSaveMap=function(){
		Color._SAVE_SIZE=0;
		Color._SAVE={};
		for (var i in Color._DEFAULT)Color._SAVE[i]=Color._DEFAULT[i];
	}

	Color.create=function(value){
		var key=value+"";
		var color=Color._SAVE[key];
		if (color !=null)return color;
		if (Color._SAVE_SIZE < 1000)Color._initSaveMap();
		return Color._SAVE[key]=new Color(value);
	}

	Color._SAVE={};
	Color._SAVE_SIZE=0;
	Color._COLOR_MAP={"white":'#FFFFFF',"red":'#FF0000',"green":'#00FF00',"blue":'#0000FF',"black":'#000000',"yellow":'#FFFF00','gray':'#808080'};
	Color._DEFAULT=Color._initDefault();
	Color._COLODID=1;
	return Color;
})()


	//file:///E:/git/layaair-master/core/src/laya/utils/Dragging.as=======199.999846/199.999846
/**
*@private
*<code>Dragging</code> 类是触摸滑动控件。
*/
//class laya.utils.Dragging
var Dragging=(function(){
	function Dragging(){
		/**被拖动的对象。*/
		//this.target=null;
		/**缓动衰减系数。*/
		this.ratio=0.92;
		/**单帧最大偏移量。*/
		this.maxOffset=60;
		/**滑动范围。*/
		//this.area=null;
		/**表示拖动是否有惯性。*/
		//this.hasInertia=false;
		/**橡皮筋最大值。*/
		//this.elasticDistance=NaN;
		/**橡皮筋回弹时间，单位为毫秒。*/
		//this.elasticBackTime=NaN;
		/**事件携带数据。*/
		//this.data=null;
		this._dragging=false;
		this._clickOnly=true;
		//this._elasticRateX=NaN;
		//this._elasticRateY=NaN;
		//this._lastX=NaN;
		//this._lastY=NaN;
		//this._offsetX=NaN;
		//this._offsetY=NaN;
		//this._offsets=null;
		//this._disableMouseEvent=false;
		//this._tween=null;
		//this._parent=null;
	}

	__class(Dragging,'laya.utils.Dragging');
	var __proto=Dragging.prototype;
	/**
	*开始拖拽。
	*@param target 待拖拽的 <code>Sprite</code> 对象。
	*@param area 滑动范围。
	*@param hasInertia 拖动是否有惯性。
	*@param elasticDistance 橡皮筋最大值。
	*@param elasticBackTime 橡皮筋回弹时间，单位为毫秒。
	*@param data 事件携带数据。
	*@param disableMouseEvent 鼠标事件是否有效。
	*@param ratio 惯性阻尼系数
	*/
	__proto.start=function(target,area,hasInertia,elasticDistance,elasticBackTime,data,disableMouseEvent,ratio){
		(ratio===void 0)&& (ratio=0.92);
		this.clearTimer();
		this.target=target;
		this.area=area;
		this.hasInertia=hasInertia;
		this.elasticDistance=area ? elasticDistance :0;
		this.elasticBackTime=elasticBackTime;
		this.data=data;
		this._disableMouseEvent=disableMouseEvent;
		this.ratio=ratio;
		if (target.globalScaleX !=1 || target.globalScaleY !=1){
			this._parent=target.parent;
			}else {
			this._parent=Laya.stage;
		}
		this._clickOnly=true;
		this._dragging=true;
		this._elasticRateX=this._elasticRateY=1;
		this._lastX=this._parent.mouseX;
		this._lastY=this._parent.mouseY;
		Laya.stage.on("mouseup",this,this.onStageMouseUp);
		Laya.stage.on("mouseout",this,this.onStageMouseUp);
		Laya.timer.frameLoop(1,this,this.loop);
	}

	/**
	*清除计时器。
	*/
	__proto.clearTimer=function(){
		Laya.timer.clear(this,this.loop);
		Laya.timer.clear(this,this.tweenMove);
		if (this._tween){
			this._tween.recover();
			this._tween=null;
		}
	}

	/**
	*停止拖拽。
	*/
	__proto.stop=function(){
		if (this._dragging){
			MouseManager.instance.disableMouseEvent=false;
			Laya.stage.off("mouseup",this,this.onStageMouseUp);
			Laya.stage.off("mouseout",this,this.onStageMouseUp);
			this._dragging=false;
			this.target && this.area && this.backToArea();
			this.clear();
		}
	}

	/**
	*拖拽的循环处理函数。
	*/
	__proto.loop=function(){
		var point=this._parent.getMousePoint();
		var mouseX=point.x;
		var mouseY=point.y;
		var offsetX=mouseX-this._lastX;
		var offsetY=mouseY-this._lastY;
		if (this._clickOnly){
			if (Math.abs(offsetX *Laya.stage._canvasTransform.getScaleX())> 1 || Math.abs(offsetY *Laya.stage._canvasTransform.getScaleY())> 1){
				this._clickOnly=false;
				this._offsets || (this._offsets=[]);
				this._offsets.length=0;
				this.target.event("dragstart",this.data);
				MouseManager.instance.disableMouseEvent=this._disableMouseEvent;
			}else return;
			}else {
			this._offsets.push(offsetX,offsetY);
		}
		if (offsetX===0 && offsetY===0)return;
		this._lastX=mouseX;
		this._lastY=mouseY;
		this.target.x+=offsetX *this._elasticRateX;
		this.target.y+=offsetY *this._elasticRateY;
		this.area && this.checkArea();
		this.target.event("dragmove",this.data);
	}

	/**
	*拖拽区域检测。
	*/
	__proto.checkArea=function(){
		if (this.elasticDistance <=0){
			this.backToArea();
			}else {
			if (this.target._x < this.area.x){
				var offsetX=this.area.x-this.target._x;
				}else if (this.target._x > this.area.x+this.area.width){
				offsetX=this.target._x-this.area.x-this.area.width;
				}else {
				offsetX=0;
			}
			this._elasticRateX=Math.max(0,1-(offsetX / this.elasticDistance));
			if (this.target._y < this.area.y){
				var offsetY=this.area.y-this.target.y;
				}else if (this.target._y > this.area.y+this.area.height){
				offsetY=this.target._y-this.area.y-this.area.height;
				}else {
				offsetY=0;
			}
			this._elasticRateY=Math.max(0,1-(offsetY / this.elasticDistance));
		}
	}

	/**
	*移动至设定的拖拽区域。
	*/
	__proto.backToArea=function(){
		this.target.x=Math.min(Math.max(this.target._x,this.area.x),this.area.x+this.area.width);
		this.target.y=Math.min(Math.max(this.target._y,this.area.y),this.area.y+this.area.height);
	}

	/**
	*舞台的抬起事件侦听函数。
	*@param e Event 对象。
	*/
	__proto.onStageMouseUp=function(e){
		MouseManager.instance.disableMouseEvent=false;
		Laya.stage.off("mouseup",this,this.onStageMouseUp);
		Laya.stage.off("mouseout",this,this.onStageMouseUp);
		Laya.timer.clear(this,this.loop);
		if (this._clickOnly || !this.target)return;
		if (this.hasInertia){
			if (this._offsets.length < 1){
				this._offsets.push(this._parent.mouseX-this._lastX,this._parent.mouseY-this._lastY);
			}
			this._offsetX=this._offsetY=0;
			var len=this._offsets.length;
			var n=Math.min(len,6);
			var m=this._offsets.length-n;
			for (var i=len-1;i > m;i--){
				this._offsetY+=this._offsets[i--];
				this._offsetX+=this._offsets[i];
			}
			this._offsetX=this._offsetX / n *2;
			this._offsetY=this._offsetY / n *2;
			if (Math.abs(this._offsetX)> this.maxOffset)this._offsetX=this._offsetX > 0 ? this.maxOffset :-this.maxOffset;
			if (Math.abs(this._offsetY)> this.maxOffset)this._offsetY=this._offsetY > 0 ? this.maxOffset :-this.maxOffset;
			Laya.timer.frameLoop(1,this,this.tweenMove);
			}else if (this.elasticDistance > 0){
			this.checkElastic();
			}else {
			this.clear();
		}
	}

	/**
	*橡皮筋效果检测。
	*/
	__proto.checkElastic=function(){
		var tx=NaN;
		var ty=NaN;
		if (this.target.x < this.area.x)tx=this.area.x;
		else if (this.target._x > this.area.x+this.area.width)tx=this.area.x+this.area.width;
		if (this.target.y < this.area.y)ty=this.area.y;
		else if (this.target._y > this.area.y+this.area.height)ty=this.area.y+this.area.height;
		if (!isNaN(tx)|| !isNaN(ty)){
			var obj={};
			if (!isNaN(tx))obj.x=tx;
			if (!isNaN(ty))obj.y=ty;
			this._tween=Tween.to(this.target,obj,this.elasticBackTime,Ease.sineOut,Handler.create(this,this.clear),0,false,false);
			}else {
			this.clear();
		}
	}

	/**
	*移动。
	*/
	__proto.tweenMove=function(){
		this._offsetX *=this.ratio *this._elasticRateX;
		this._offsetY *=this.ratio *this._elasticRateY;
		this.target.x+=this._offsetX;
		this.target.y+=this._offsetY;
		this.area && this.checkArea();
		this.target.event("dragmove",this.data);
		if ((Math.abs(this._offsetX)< 1 && Math.abs(this._offsetY)< 1)|| this._elasticRateX < 0.5 || this._elasticRateY < 0.5){
			Laya.timer.clear(this,this.tweenMove);
			if (this.elasticDistance > 0)this.checkElastic();
			else this.clear();
		}
	}

	/**
	*结束拖拽。
	*/
	__proto.clear=function(){
		if (this.target){
			this.clearTimer();
			var sp=this.target;
			this.target=null;
			this._parent=null;
			sp.event("dragend",this.data);
		}
	}

	return Dragging;
})()


	//file:///E:/git/layaair-master/core/src/laya/utils/Ease.as=======199.999845/199.999845
/**
*<code>Ease</code> 类定义了缓动函数，以便实现 <code>Tween</code> 动画的缓动效果。
*/
//class laya.utils.Ease
var Ease=(function(){
	function Ease(){}
	__class(Ease,'laya.utils.Ease');
	Ease.linearNone=function(t,b,c,d){
		return c *t / d+b;
	}

	Ease.linearIn=function(t,b,c,d){
		return c *t / d+b;
	}

	Ease.linearInOut=function(t,b,c,d){
		return c *t / d+b;
	}

	Ease.linearOut=function(t,b,c,d){
		return c *t / d+b;
	}

	Ease.bounceIn=function(t,b,c,d){
		return c-Ease.bounceOut(d-t,0,c,d)+b;
	}

	Ease.bounceInOut=function(t,b,c,d){
		if (t < d *0.5)return Ease.bounceIn(t *2,0,c,d)*.5+b;
		else return Ease.bounceOut(t *2-d,0,c,d)*.5+c *.5+b;
	}

	Ease.bounceOut=function(t,b,c,d){
		if ((t /=d)< (1 / 2.75))return c *(7.5625 *t *t)+b;
		else if (t < (2 / 2.75))return c *(7.5625 *(t-=(1.5 / 2.75))*t+.75)+b;
		else if (t < (2.5 / 2.75))return c *(7.5625 *(t-=(2.25 / 2.75))*t+.9375)+b;
		else return c *(7.5625 *(t-=(2.625 / 2.75))*t+.984375)+b;
	}

	Ease.backIn=function(t,b,c,d,s){
		(s===void 0)&& (s=1.70158);
		return c *(t /=d)*t *((s+1)*t-s)+b;
	}

	Ease.backInOut=function(t,b,c,d,s){
		(s===void 0)&& (s=1.70158);
		if ((t /=d *0.5)< 1)return c *0.5 *(t *t *(((s *=(1.525))+1)*t-s))+b;
		return c / 2 *((t-=2)*t *(((s *=(1.525))+1)*t+s)+2)+b;
	}

	Ease.backOut=function(t,b,c,d,s){
		(s===void 0)&& (s=1.70158);
		return c *((t=t / d-1)*t *((s+1)*t+s)+1)+b;
	}

	Ease.elasticIn=function(t,b,c,d,a,p){
		(a===void 0)&& (a=0);
		(p===void 0)&& (p=0);
		var s;
		if (t==0)return b;
		if ((t /=d)==1)return b+c;
		if (!p)p=d *.3;
		if (!a || (c > 0 && a < c)|| (c < 0 && a <-c)){
			a=c;
			s=p / 4;
		}else s=p / Ease.PI2 *Math.asin(c / a);
		return-(a *Math.pow(2,10 *(t-=1))*Math.sin((t *d-s)*Ease.PI2 / p))+b;
	}

	Ease.elasticInOut=function(t,b,c,d,a,p){
		(a===void 0)&& (a=0);
		(p===void 0)&& (p=0);
		var s;
		if (t==0)return b;
		if ((t /=d *0.5)==2)return b+c;
		if (!p)p=d *(.3 *1.5);
		if (!a || (c > 0 && a < c)|| (c < 0 && a <-c)){
			a=c;
			s=p / 4;
		}else s=p / Ease.PI2 *Math.asin(c / a);
		if (t < 1)return-.5 *(a *Math.pow(2,10 *(t-=1))*Math.sin((t *d-s)*Ease.PI2 / p))+b;
		return a *Math.pow(2,-10 *(t-=1))*Math.sin((t *d-s)*Ease.PI2 / p)*.5+c+b;
	}

	Ease.elasticOut=function(t,b,c,d,a,p){
		(a===void 0)&& (a=0);
		(p===void 0)&& (p=0);
		var s;
		if (t==0)return b;
		if ((t /=d)==1)return b+c;
		if (!p)p=d *.3;
		if (!a || (c > 0 && a < c)|| (c < 0 && a <-c)){
			a=c;
			s=p / 4;
		}else s=p / Ease.PI2 *Math.asin(c / a);
		return (a *Math.pow(2,-10 *t)*Math.sin((t *d-s)*Ease.PI2 / p)+c+b);
	}

	Ease.strongIn=function(t,b,c,d){
		return c *(t /=d)*t *t *t *t+b;
	}

	Ease.strongInOut=function(t,b,c,d){
		if ((t /=d *0.5)< 1)return c *0.5 *t *t *t *t *t+b;
		return c *0.5 *((t-=2)*t *t *t *t+2)+b;
	}

	Ease.strongOut=function(t,b,c,d){
		return c *((t=t / d-1)*t *t *t *t+1)+b;
	}

	Ease.sineInOut=function(t,b,c,d){
		return-c *0.5 *(Math.cos(Math.PI *t / d)-1)+b;
	}

	Ease.sineIn=function(t,b,c,d){
		return-c *Math.cos(t / d *Ease.HALF_PI)+c+b;
	}

	Ease.sineOut=function(t,b,c,d){
		return c *Math.sin(t / d *Ease.HALF_PI)+b;
	}

	Ease.quintIn=function(t,b,c,d){
		return c *(t /=d)*t *t *t *t+b;
	}

	Ease.quintInOut=function(t,b,c,d){
		if ((t /=d *0.5)< 1)return c *0.5 *t *t *t *t *t+b;
		return c *0.5 *((t-=2)*t *t *t *t+2)+b;
	}

	Ease.quintOut=function(t,b,c,d){
		return c *((t=t / d-1)*t *t *t *t+1)+b;
	}

	Ease.quartIn=function(t,b,c,d){
		return c *(t /=d)*t *t *t+b;
	}

	Ease.quartInOut=function(t,b,c,d){
		if ((t /=d *0.5)< 1)return c *0.5 *t *t *t *t+b;
		return-c *0.5 *((t-=2)*t *t *t-2)+b;
	}

	Ease.quartOut=function(t,b,c,d){
		return-c *((t=t / d-1)*t *t *t-1)+b;
	}

	Ease.cubicIn=function(t,b,c,d){
		return c *(t /=d)*t *t+b;
	}

	Ease.cubicInOut=function(t,b,c,d){
		if ((t /=d *0.5)< 1)return c *0.5 *t *t *t+b;
		return c *0.5 *((t-=2)*t *t+2)+b;
	}

	Ease.cubicOut=function(t,b,c,d){
		return c *((t=t / d-1)*t *t+1)+b;
	}

	Ease.quadIn=function(t,b,c,d){
		return c *(t /=d)*t+b;
	}

	Ease.quadInOut=function(t,b,c,d){
		if ((t /=d *0.5)< 1)return c *0.5 *t *t+b;
		return-c *0.5 *((--t)*(t-2)-1)+b;
	}

	Ease.quadOut=function(t,b,c,d){
		return-c *(t /=d)*(t-2)+b;
	}

	Ease.expoIn=function(t,b,c,d){
		return (t==0)? b :c *Math.pow(2,10 *(t / d-1))+b-c *0.001;
	}

	Ease.expoInOut=function(t,b,c,d){
		if (t==0)return b;
		if (t==d)return b+c;
		if ((t /=d *0.5)< 1)return c *0.5 *Math.pow(2,10 *(t-1))+b;
		return c *0.5 *(-Math.pow(2,-10 *--t)+2)+b;
	}

	Ease.expoOut=function(t,b,c,d){
		return (t==d)? b+c :c *(-Math.pow(2,-10 *t / d)+1)+b;
	}

	Ease.circIn=function(t,b,c,d){
		return-c *(Math.sqrt(1-(t /=d)*t)-1)+b;
	}

	Ease.circInOut=function(t,b,c,d){
		if ((t /=d *0.5)< 1)return-c *0.5 *(Math.sqrt(1-t *t)-1)+b;
		return c *0.5 *(Math.sqrt(1-(t-=2)*t)+1)+b;
	}

	Ease.circOut=function(t,b,c,d){
		return c *Math.sqrt(1-(t=t / d-1)*t)+b;
	}

	Ease.HALF_PI=Math.PI *0.5;
	Ease.PI2=Math.PI *2;
	return Ease;
})()


	//file:///E:/git/layaair-master/core/src/laya/utils/Pool.as=======199.999838/199.999838
/**
*<p> <code>Pool</code> 是对象池类，用于对象的存储、重复使用。</p>
*<p>合理使用对象池，可以有效减少对象创建的开销，避免频繁的垃圾回收，从而优化游戏流畅度。</p>
*/
//class laya.utils.Pool
var Pool=(function(){
	function Pool(){}
	__class(Pool,'laya.utils.Pool');
	Pool.getPoolBySign=function(sign){
		return Pool._poolDic[sign] || (Pool._poolDic[sign]=[]);
	}

	Pool.clearBySign=function(sign){
		if (Pool._poolDic[sign])Pool._poolDic[sign].length=0;
	}

	Pool.recover=function(sign,item){
		if (item["__InPool"])return;
		item["__InPool"]=true;
		Pool.getPoolBySign(sign).push(item);
	}

	Pool.getItemByClass=function(sign,cls){
		var pool=Pool.getPoolBySign(sign);
		if (pool.length){
			var rst=pool.pop();
			rst["__InPool"]=false;
			}else {
			rst=new cls();
		}
		return rst;
	}

	Pool.getItemByCreateFun=function(sign,createFun){
		var pool=Pool.getPoolBySign(sign);
		var rst=pool.length ? pool.pop():createFun();
		rst["__InPool"]=false;
		return rst;
	}

	Pool.getItem=function(sign){
		var pool=Pool.getPoolBySign(sign);
		var rst=pool.length ? pool.pop():null;
		if (rst){
			rst["__InPool"]=false;
		}
		return rst;
	}

	Pool.POOLSIGN="__InPool";
	Pool._poolDic={};
	return Pool;
})()


	//file:///E:/git/layaair-master/core/src/laya/utils/RunDriver.as=======199.999836/199.999836
/**
*@private
*/
//class laya.utils.RunDriver
var RunDriver=(function(){
	function RunDriver(){}
	__class(RunDriver,'laya.utils.RunDriver');
	RunDriver.update3DLoop=function(){}
	RunDriver.enableNative=function(){
		LayaGLContext.setCurrent=LayaGLContext.setCurrentForNative;
		LayaGLContext.revert=LayaGLContext.revertForNative;
		LayaGLRunner.uploadShaderAttributes=LayaGLRunner.uploadShaderAttributesForNative;
		LayaGLRunner.uploadShaderUniforms=LayaGLRunner.uploadShaderUniformsForNative;
		LayaGLContext.prototype.setCurrent=LayaGLContext.prototype.setCurrentForNative;
		LayaGLContext.prototype.revert=LayaGLContext.prototype.revertForNative;
		var sprite=Sprite;
		sprite.prototype.render=sprite.prototype.renderToNative;
		var buffer=GLBuffer;
		var texture=Texture;
		var layaGL=LayaGL;
		var shaderData=laya.d3.shader.ShaderDatas;
		var shader3D=laya.d3.shader.ShaderInstance;
		var baseTexture=laya.webgl.resource.BaseTexture;
		var skinnedMeshRender=laya.d3.core.SkinnedMeshRender;
		if (window.conch){
			buffer.prototype._init=buffer.prototype._initWithNative;
			buffer.prototype._need=buffer.prototype._needWithNative
			buffer.prototype.add_texture=buffer.prototype.add_textureWithNative;
			buffer.prototype.add_String=buffer.prototype.add_StringForNative;
			texture.prototype._onLoaded=texture.prototype._onLoadedWithNative;
			texture.prototype.setTo=texture.prototype.setToWithNative;
			texture.prototype._setUV=texture.prototype._setUVWithNative;
			layaGL.prototype.getContextAttributes=layaGL.prototype.getContextAttributesForNative;
			layaGL.prototype.isContextLost=layaGL.prototype.isContextLostForNative;
			layaGL.prototype.getSupportedExtensions=layaGL.prototype.getSupportedExtensionsForNative;
			layaGL.prototype.getExtension=layaGL.prototype.getExtensionForNative;
			layaGL.prototype.activeTexture=layaGL.prototype.activeTextureForNative;
			layaGL.prototype.attachShader=layaGL.prototype.attachShaderForNative;
			layaGL.prototype.bindAttribLocation=layaGL.prototype.bindAttribLocationForNative;
			layaGL.prototype.bindBuffer=layaGL.prototype.bindBufferForNative;
			layaGL.prototype.bindFramebuffer=layaGL.prototype.bindFramebufferForNative;
			layaGL.prototype.bindRenderbuffer=layaGL.prototype.bindRenderbufferForNative;
			layaGL.prototype.bindTexture=layaGL.prototype.bindTextureForNative;
			layaGL.prototype.useTexture=layaGL.prototype.useTextureForNative;
			layaGL.prototype.blendColor=layaGL.prototype.blendColorForNative;
			layaGL.prototype.blendEquation=layaGL.prototype.blendEquationForNative;
			layaGL.prototype.blendEquationSeparate=layaGL.prototype.blendEquationSeparateForNative;
			layaGL.prototype.blendFunc=layaGL.prototype.blendFuncForNative;
			layaGL.prototype.blendFuncSeparate=layaGL.prototype.blendFuncSeparateForNative;
			layaGL.prototype.bufferData=layaGL.prototype.bufferDataForNative;
			layaGL.prototype.bufferSubData=layaGL.prototype.bufferSubDataForNative;
			layaGL.prototype.checkFramebufferStatus=layaGL.prototype.checkFramebufferStatusForNative;
			layaGL.prototype.clear=layaGL.prototype.clearForNative;
			layaGL.prototype.clearColor=layaGL.prototype.clearColorForNative;
			layaGL.prototype.clearDepth=layaGL.prototype.clearDepthForNative;
			layaGL.prototype.clearStencil=layaGL.prototype.clearStencilForNative;
			layaGL.prototype.colorMask=layaGL.prototype.colorMaskForNative;
			layaGL.prototype.compileShader=layaGL.prototype.compileShaderForNative;
			layaGL.prototype.copyTexImage2D=layaGL.prototype.copyTexImage2DForNative;
			layaGL.prototype.copyTexSubImage2D=layaGL.prototype.copyTexSubImage2DForNative;
			layaGL.prototype.createBuffer=layaGL.prototype.createBufferForNative;
			layaGL.prototype.createFramebuffer=layaGL.prototype.createFramebufferForNative;
			layaGL.prototype.createProgram=layaGL.prototype.createProgramForNative;
			layaGL.prototype.createRenderbuffer=layaGL.prototype.createRenderbufferForNative;
			layaGL.prototype.createShader=layaGL.prototype.createShaderForNative;
			layaGL.prototype.createTexture=layaGL.prototype.createTextureForNative;
			layaGL.prototype.cullFace=layaGL.prototype.cullFaceForNative;
			layaGL.prototype.deleteBuffer=layaGL.prototype.deleteBufferForNative;
			layaGL.prototype.deleteFramebuffer=layaGL.prototype.deleteFramebufferForNative;
			layaGL.prototype.deleteProgram=layaGL.prototype.deleteProgramForNative;
			layaGL.prototype.deleteRenderbuffer=layaGL.prototype.deleteRenderbufferForNative;
			layaGL.prototype.deleteShader=layaGL.prototype.deleteShaderForNative;
			layaGL.prototype.deleteTexture=layaGL.prototype.deleteTextureForNative;
			layaGL.prototype.depthFunc=layaGL.prototype.depthFuncForNative;
			layaGL.prototype.depthMask=layaGL.prototype.depthMaskForNative;
			layaGL.prototype.depthRange=layaGL.prototype.depthRangeForNative;
			layaGL.prototype.detachShader=layaGL.prototype.detachShaderForNative;
			layaGL.prototype.disable=layaGL.prototype.disableForNative;
			layaGL.prototype.disableVertexAttribArray=layaGL.prototype.disableVertexAttribArrayForNative;
			layaGL.prototype.drawArrays=layaGL.prototype.drawArraysForNative;
			layaGL.prototype.drawElements=layaGL.prototype.drawElementsForNative;
			layaGL.prototype.enable=layaGL.prototype.enableForNative;
			layaGL.prototype.enableVertexAttribArray=layaGL.prototype.enableVertexAttribArrayForNative;
			layaGL.prototype.finish=layaGL.prototype.finishForNative;
			layaGL.prototype.flush=layaGL.prototype.flushForNative;
			layaGL.prototype.framebufferRenderbuffer=layaGL.prototype.framebufferRenderbufferForNative;
			layaGL.prototype.framebufferTexture2D=layaGL.prototype.framebufferTexture2DForNative;
			layaGL.prototype.frontFace=layaGL.prototype.frontFaceForNative;
			layaGL.prototype.generateMipmap=layaGL.prototype.generateMipmapForNative;
			layaGL.prototype.getActiveAttrib=layaGL.prototype.getActiveAttribForNative;
			layaGL.prototype.getActiveUniform=layaGL.prototype.getActiveUniformForNative;
			layaGL.prototype.getAttribLocation=layaGL.prototype.getAttribLocationForNative;
			layaGL.prototype.getParameter=layaGL.prototype.getParameterForNative;
			layaGL.prototype.getBufferParameter=layaGL.prototype.getBufferParameterForNative;
			layaGL.prototype.getError=layaGL.prototype.getErrorForNative;
			layaGL.prototype.getFramebufferAttachmentParameter=layaGL.prototype.getFramebufferAttachmentParameterForNative;
			layaGL.prototype.getProgramParameter=layaGL.prototype.getProgramParameterForNative;
			layaGL.prototype.getProgramInfoLog=layaGL.prototype.getProgramInfoLogForNative;
			layaGL.prototype.getRenderbufferParameter=layaGL.prototype.getRenderbufferParameterForNative;
			layaGL.prototype.getShaderPrecisionFormat=layaGL.prototype.getShaderPrecisionFormatForNative;
			layaGL.prototype.getShaderParameter=layaGL.prototype.getShaderParameterForNative;
			layaGL.prototype.getShaderInfoLog=layaGL.prototype.getShaderInfoLogForNative;
			layaGL.prototype.getShaderSource=layaGL.prototype.getShaderSourceForNative;
			layaGL.prototype.getTexParameter=layaGL.prototype.getTexParameterForNative;
			layaGL.prototype.getUniform=layaGL.prototype.getUniformForNative;
			layaGL.prototype.getUniformLocation=layaGL.prototype.getUniformLocationForNative;
			layaGL.prototype.getVertexAttrib=layaGL.prototype.getVertexAttribForNative;
			layaGL.prototype.getVertexAttribOffset=layaGL.prototype.getVertexAttribOffsetForNative;
			layaGL.prototype.hint=layaGL.prototype.hintForNative;
			layaGL.prototype.isBuffer=layaGL.prototype.isBufferForNative;
			layaGL.prototype.isEnabled=layaGL.prototype.isEnabledForNative;
			layaGL.prototype.isFramebuffer=layaGL.prototype.isFramebufferForNative;
			layaGL.prototype.isProgram=layaGL.prototype.isProgramForNative;
			layaGL.prototype.isRenderbuffer=layaGL.prototype.isRenderbufferForNative;
			layaGL.prototype.isShader=layaGL.prototype.isShaderForNative;
			layaGL.prototype.isTexture=layaGL.prototype.isTextureForNative;
			layaGL.prototype.lineWidth=layaGL.prototype.lineWidthForNative;
			layaGL.prototype.linkProgram=layaGL.prototype.linkProgramForNative;
			layaGL.prototype.pixelStorei=layaGL.prototype.pixelStoreiForNative;
			layaGL.prototype.polygonOffset=layaGL.prototype.polygonOffsetForNative;
			layaGL.prototype.readPixels=layaGL.prototype.readPixelsForNative;
			layaGL.prototype.renderbufferStorage=layaGL.prototype.renderbufferStorageForNative;
			layaGL.prototype.sampleCoverage=layaGL.prototype.sampleCoverageForNative;
			layaGL.prototype.scissor=layaGL.prototype.scissorForNative;
			layaGL.prototype.shaderSource=layaGL.prototype.shaderSourceForNative;
			layaGL.prototype.stencilFunc=layaGL.prototype.stencilFuncForNative;
			layaGL.prototype.stencilFuncSeparate=layaGL.prototype.stencilFuncSeparateForNative;
			layaGL.prototype.stencilMask=layaGL.prototype.stencilMaskForNative;
			layaGL.prototype.stencilMaskSeparate=layaGL.prototype.stencilMaskSeparateForNative;
			layaGL.prototype.stencilOp=layaGL.prototype.stencilOpForNative;
			layaGL.prototype.stencilOpSeparate=layaGL.prototype.stencilOpSeparateForNative;
			layaGL.prototype.texImage2D=layaGL.prototype.texImage2DForNative;
			layaGL.prototype.texParameterf=layaGL.prototype.texParameterfForNative;
			layaGL.prototype.texParameteri=layaGL.prototype.texParameteriForNative;
			layaGL.prototype.texSubImage2D=layaGL.prototype.texSubImage2DForNative;
			layaGL.prototype.uniform1f=layaGL.prototype.uniform1fForNative;
			layaGL.prototype.uniform1fv=layaGL.prototype.uniform1fvForNative;
			layaGL.prototype.uniform1i=layaGL.prototype.uniform1iForNative;
			layaGL.prototype.uniform1iv=layaGL.prototype.uniform1ivForNative;
			layaGL.prototype.uniform2f=layaGL.prototype.uniform2fForNative;
			layaGL.prototype.uniform2fv=layaGL.prototype.uniform2fvForNative;
			layaGL.prototype.uniform2i=layaGL.prototype.uniform2iForNative;
			layaGL.prototype.uniform2iv=layaGL.prototype.uniform2ivForNative;
			layaGL.prototype.uniform3f=layaGL.prototype.uniform3fForNative;
			layaGL.prototype.uniform3fv=layaGL.prototype.uniform3fvForNative;
			layaGL.prototype.uniform3i=layaGL.prototype.uniform3iForNative;
			layaGL.prototype.uniform3iv=layaGL.prototype.uniform3ivForNative;
			layaGL.prototype.uniform4f=layaGL.prototype.uniform4fForNative;
			layaGL.prototype.uniform4fv=layaGL.prototype.uniform4fvForNative;
			layaGL.prototype.uniform4i=layaGL.prototype.uniform4iForNative;
			layaGL.prototype.uniform4iv=layaGL.prototype.uniform4ivForNative;
			layaGL.prototype.uniformMatrix2fv=layaGL.prototype.uniformMatrix2fvForNative;
			layaGL.prototype.uniformMatrix3fv=layaGL.prototype.uniformMatrix3fvForNative;
			layaGL.prototype.uniformMatrix4fv=layaGL.prototype.uniformMatrix4fvForNative;
			layaGL.prototype.useProgram=layaGL.prototype.useProgramForNative;
			layaGL.prototype.validateProgram=layaGL.prototype.validateProgramForNative;
			layaGL.prototype.vertexAttrib1f=layaGL.prototype.vertexAttrib1fForNative;
			layaGL.prototype.vertexAttrib1fv=layaGL.prototype.vertexAttrib1fvForNative;
			layaGL.prototype.vertexAttrib2f=layaGL.prototype.vertexAttrib2fForNative;
			layaGL.prototype.vertexAttrib2fv=layaGL.prototype.vertexAttrib2fvForNative;
			layaGL.prototype.vertexAttrib3f=layaGL.prototype.vertexAttrib3fForNative;
			layaGL.prototype.vertexAttrib3fv=layaGL.prototype.vertexAttrib3fvForNative;
			layaGL.prototype.vertexAttrib4f=layaGL.prototype.vertexAttrib4fForNative;
			layaGL.prototype.vertexAttrib4fv=layaGL.prototype.vertexAttrib4fvForNative;
			layaGL.prototype.vertexAttribPointer=layaGL.prototype.vertexAttribPointerForNative;
			layaGL.prototype.viewport=layaGL.prototype.viewportForNative;
			layaGL.prototype.configureBackBuffer=layaGL.prototype.configureBackBufferForNative;
			layaGL.prototype.compressedTexImage2D=layaGL.prototype.compressedTexImage2DForNative;
			layaGL.prototype.addShaderAttribute=layaGL.prototype.addShaderAttributeForNative;
			layaGL.prototype.addShaderUniform=layaGL.prototype.addShaderUniformForNative;
			layaGL.prototype.uploadShaderAttributes=layaGL.prototype.uploadShaderAttributesForNative;
			layaGL.prototype.uploadShaderUniforms=layaGL.prototype.uploadShaderUniformsForNative;
			shaderData.prototype._initData=shaderData.prototype._initDataForNative;
			shaderData.prototype.setBool=shaderData.prototype.setBoolForNative;
			shaderData.prototype.getBool=shaderData.prototype.getBoolForNative;
			shaderData.prototype.setInt=shaderData.prototype.setIntForNative;
			shaderData.prototype.getInt=shaderData.prototype.getIntForNative;
			shaderData.prototype.setNumber=shaderData.prototype.setNumberForNative;
			shaderData.prototype.getNumber=shaderData.prototype.getNumberForNative;
			shaderData.prototype.setVector=shaderData.prototype.setVectorForNative;
			shaderData.prototype.getVector=shaderData.prototype.getVectorForNative;
			shaderData.prototype.setQuaternion=shaderData.prototype.setQuaternionForNative;
			shaderData.prototype.getQuaternion=shaderData.prototype.getQuaternionForNative;
			shaderData.prototype.setMatrix4x4=shaderData.prototype.setMatrix4x4ForNative;
			shaderData.prototype.getMatrix4x4=shaderData.prototype.getMatrix4x4ForNative;
			shaderData.prototype.setBuffer=shaderData.prototype.setBufferForNative;
			shaderData.prototype.getBuffer=shaderData.prototype.getBufferForNative;
			shaderData.prototype.setTexture=shaderData.prototype.setTextureForNative;
			shaderData.prototype.getTexture=shaderData.prototype.getTextureForNative;
			shaderData.prototype.setAttribute=shaderData.prototype.setAttributeForNative;
			shaderData.prototype.getAttribute=shaderData.prototype.getAttributeForNative;
			shader3D.prototype._uniformMatrix2fv=shader3D.prototype._uniformMatrix2fvForNative;
			shader3D.prototype._uniformMatrix3fv=shader3D.prototype._uniformMatrix3fvForNative;
			shader3D.prototype._uniformMatrix4fv=shader3D.prototype._uniformMatrix4fvForNative;
			baseTexture.prototype._getGLFormat=baseTexture.prototype._getGLFormatForNative;
			skinnedMeshRender.prototype._computeSkinnedData=skinnedMeshRender.prototype._computeSkinnedDataForNative;
			laya.d3.utils.Utils3D.matrix4x4MultiplyFFF=laya.d3.utils.Utils3D.matrix4x4MultiplyFFFForNative;
		}
		ConchSpriteAdpt.init();
	}

	RunDriver.FILTER_ACTIONS=[];
	RunDriver.getIncludeStr=function(name){
		return null;
	}

	RunDriver.createShaderCondition=function(conditionScript){
		var fn="(function() {return "+conditionScript+";})";
		return Browser.window.eval(fn);
	}

	RunDriver.fontMap=[];
	RunDriver.measureText=function(txt,font){
		var isChinese=RunDriver.hanzi.test(txt);
		if (isChinese && RunDriver.fontMap[font]){
			return RunDriver.fontMap[font];
		};
		var ctx=Browser.context;
		ctx.font=font;
		var r=ctx.measureText(txt);
		if (isChinese)RunDriver.fontMap[font]=r;
		return r;
	}

	RunDriver.flashFlushImage=function(atlasWebGLCanvas){
	};

	RunDriver.drawToCanvas=function(sprite,_renderType,canvasWidth,canvasHeight,offsetX,offsetY){
		debugger;
		return null;
	}

	RunDriver.createParticleTemplate2D=null;
	RunDriver.createGLTextur=null;
	RunDriver.createWebGLContext2D=null;
	RunDriver.changeWebGLSize=function(w,h){
	};

	RunDriver.createRenderSprite=function(type,next){
		return new RenderSprite(type,next);
	}

	RunDriver.createFilterAction=function(type){
		return new ColorFilterAction();
	}

	RunDriver.createGraphics=function(){
		return new Graphics();
	}

	RunDriver.clear=function(value){
		if (!Render.isConchApp){
			Render._context.clear();
		}
		else{
			Render._context.clearBufferForNative();
		}
	}

	RunDriver.getTexturePixels=function(value,x,y,width,height){
		return null;
	}

	RunDriver.skinAniSprite=function(){
		return null;
	}

	__static(RunDriver,
	['hanzi',function(){return this.hanzi=new RegExp("^[\u4E00-\u9FA5]$");}
	]);
	return RunDriver;
})()


	//file:///E:/git/layaair-master/core/src/laya/utils/Stat.as=======199.999835/199.999835
/**
*<p> <code>Stat</code> 是一个性能统计面板，可以实时更新相关的性能参数。</p>
*<p>参与统计的性能参数如下（所有参数都是每大约1秒进行更新）：<br/>
*FPS(Canvas)/FPS(WebGL)：Canvas 模式或者 WebGL 模式下的帧频，也就是每秒显示的帧数，值越高、越稳定，感觉越流畅；<br/>
*Sprite：统计所有渲染节点（包括容器）数量，它的大小会影响引擎进行节点遍历、数据组织和渲染的效率。其值越小，游戏运行效率越高；<br/>
*DrawCall：此值是决定性能的重要指标，其值越小，游戏运行效率越高。Canvas模式下表示每大约1秒的图像绘制次数；WebGL模式下表示每大约1秒的渲染提交批次，每次准备数据并通知GPU渲染绘制的过程称为1次DrawCall，在每次DrawCall中除了在通知GPU的渲染上比较耗时之外，切换材质与shader也是非常耗时的操作；<br/>
*Memory：Canvas模式下，表示内存占用大小，值越小越好，过高会导致游戏闪退；WebGL模式下，表示内存与显存的占用，值越小越好；<br/>
*Shader：是 WebGL 模式独有的性能指标，表示每大约1秒 Shader 提交次数，值越小越好；<br/>
*Canvas：由三个数值组成，只有设置 CacheAs 后才会有值，默认为0/0/0。从左到右数值的意义分别为：每帧重绘的画布数量 / 缓存类型为"normal"类型的画布数量 / 缓存类型为"bitmap"类型的画布数量。</p>
*/
//class laya.utils.Stat
var Stat=(function(){
	function Stat(){}
	__class(Stat,'laya.utils.Stat');
	/**
	*设置点击FPS区域后，触发的函数。里面可以放置一些调试逻辑处理。
	*/
	__getset(1,Stat,'onclick',null,function(fn){
		Stat._canvas.source.onclick=fn;
		Stat._canvas.source.style.pointerEvents='';
	});

	Stat.show=function(x,y){
		(x===void 0)&& (x=0);
		(y===void 0)&& (y=0);
		if (Render.isConchApp){
			window.conch && window.conch.showFPS&&window.conch.showFPS(x,y);
			return;
		};
		var pixel=Browser.pixelRatio;
		Stat._width=pixel *130;
		Stat._vx=pixel *75;
		Stat._view[0]={title:"FPS(Canvas)",value:"_fpsStr",color:"yellow",units:"int"};
		Stat._view[1]={title:"Sprite",value:"spriteCount",color:"white",units:"int"};
		Stat._view[2]={title:"DrawCall",value:"drawCall",color:"white",units:"int"};
		Stat._view[3]={title:"Memory",value:"currentMemorySize",color:"yellow",units:"M"};
		if (Render.isWebGL){
			Stat._view[4]={title:"Shader",value:"shaderCall",color:"white",units:"int"};
			if (!Render.is3DMode){
				Stat._view[0].title="FPS(WebGL)";
				Stat._view[5]={title:"Canvas",value:"_canvasStr",color:"white",units:"int" };
				Stat._view[6]={title:"Mesh2D",value:"mesh2DNum",color:"white",uints:"int" };
				}else {
				Stat._view[0].title="FPS(3D)";
				Stat._view[5]={title:"TriFaces",value:"trianglesFaces",color:"white",units:"int"};
				Stat._view[6]={title:"treeNodeColl",value:"treeNodeCollision",color:"white",units:"int"};
				Stat._view[7]={title:"treeSpriteColl",value:"treeSpriteCollision",color:"white",units:"int"};
			}
			}else {
			Stat._view[4]={title:"Canvas",value:"_canvasStr",color:"white",units:"int"};
		}
		Stat._fontSize=12 *pixel;
		for (var i=0;i < Stat._view.length;i++){
			Stat._view[i].x=4;
			Stat._view[i].y=i *Stat._fontSize+2 *pixel;
		}
		Stat._height=pixel *(Stat._view.length *12+3 *pixel)+4;
		if (!Stat._canvas){
			Stat._canvas=new HTMLCanvas('2D');
			Stat._canvas.size(Stat._width,Stat._height);
			Stat._ctx=Stat._canvas.getContext('2d');
			Stat._ctx.textBaseline="top";
			Stat._ctx.font=Stat._fontSize+"px Sans-serif";
			Stat._canvas.source.style.cssText="pointer-events:none;background:rgba(150,150,150,0.8);z-index:100000;position: absolute;left:"+x+"px;top:"+y+"px;width:"+(Stat._width / pixel)+"px;height:"+(Stat._height / pixel)+"px;";
		}
		Stat._first=true;
		Stat._loop();
		Stat._first=false;
		Browser.container.appendChild(Stat._canvas.source);
		Stat.enable();
	}

	Stat.enable=function(){
		Laya.timer.frameLoop(1,Stat,Stat._loop);
	}

	Stat.hide=function(){
		if (Stat._canvas){
			Browser.removeElement(Stat._canvas.source);
			Laya.timer.clear(Stat,Stat._loop);
		}
	}

	Stat.clear=function(){
		Stat.trianglesFaces=Stat.drawCall=Stat.shaderCall=Stat.spriteCount=Stat.treeNodeCollision=Stat.treeSpriteCollision=Stat.canvasNormal=Stat.canvasBitmap=Stat.canvasReCache=0;
	}

	Stat._loop=function(){
		Stat._count++;
		var timer=Browser.now();
		if (timer-Stat._timer < 1000)return;
		var count=Stat._count;
		Stat.FPS=Math.round((count *1000)/ (timer-Stat._timer));
		if (Stat._canvas){
			Stat.trianglesFaces=Math.round(Stat.trianglesFaces / count);
			Stat.drawCall=Math.round(Stat.drawCall / count);
			Stat.shaderCall=Math.round(Stat.shaderCall / count);
			Stat.spriteCount=Math.round(Stat.spriteCount / count)-1;
			Stat.canvasNormal=Math.round(Stat.canvasNormal / count);
			Stat.canvasBitmap=Math.round(Stat.canvasBitmap / count);
			Stat.canvasReCache=Math.ceil(Stat.canvasReCache / count);
			Stat.treeNodeCollision=Math.round(Stat.treeNodeCollision / count);
			Stat.treeSpriteCollision=Math.round(Stat.treeSpriteCollision / count);
			var delay=Stat.FPS > 0 ? Math.floor(1000 / Stat.FPS).toString():" ";
			Stat._fpsStr=Stat.FPS+(Stat.renderSlow ? " slow" :"")+" "+delay;
			Stat._canvasStr=Stat.canvasReCache+"/"+Stat.canvasNormal+"/"+Stat.canvasBitmap;
			Stat.currentMemorySize=ResourceManager.systemResourceManager.memorySize;
			var ctx=Stat._ctx;
			ctx.clearRect(Stat._first ? 0 :Stat._vx,0,Stat._width,Stat._height);
			for (var i=0;i < Stat._view.length;i++){
				var one=Stat._view[i];
				if (Stat._first){
					ctx.fillStyle="white";
					ctx.fillText(one.title,one.x,one.y);
				}
				ctx.fillStyle=one.color;
				var value=Stat[one.value];
				(one.units=="M")&& (value=Math.floor(value / (1024 *1024)*100)/ 100+" M");
				ctx.fillText(value+"",one.x+Stat._vx,one.y);
			}
			Stat.clear();
		}
		Stat._count=0;
		Stat._timer=timer;
	}

	Stat.FPS=0;
	Stat.loopCount=0;
	Stat.shaderCall=0;
	Stat.drawCall=0;
	Stat.trianglesFaces=0;
	Stat.spriteCount=0;
	Stat.treeNodeCollision=0;
	Stat.treeSpriteCollision=0;
	Stat.canvasNormal=0;
	Stat.canvasBitmap=0;
	Stat.canvasReCache=0;
	Stat.renderSlow=false;
	Stat.currentMemorySize=0;
	Stat.mesh2DNum=0;
	Stat._fpsStr=null;
	Stat._canvasStr=null;
	Stat._canvas=null;
	Stat._ctx=null;
	Stat._timer=0;
	Stat._count=0;
	Stat._width=0;
	Stat._height=100;
	Stat._view=[];
	Stat._fontSize=12;
	Stat._first=false;
	Stat._vx=NaN;
	return Stat;
})()


	//file:///E:/git/layaair-master/core/src/laya/utils/Timer.as=======199.999831/199.999831
/**
*<code>Timer</code> 是时钟管理类。它是一个单例，不要手动实例化此类，应该通过 Laya.timer 访问。
*/
//class laya.utils.Timer
var Timer=(function(){
	var TimerHandler;
	function Timer(){
		/**两帧之间的时间间隔,单位毫秒。*/
		this._delta=0;
		/**时针缩放。*/
		this.scale=1;
		/**当前的帧数。*/
		this.currFrame=0;
		/**@private */
		this._mid=1;
		/**@private */
		this._map=[];
		/**@private */
		this._laters=[];
		/**@private */
		this._handlers=[];
		/**@private */
		this._temp=[];
		/**@private */
		this._count=0;
		this.currTimer=Browser.now();
		this._lastTimer=Browser.now();
		Laya.timer && Laya.timer.frameLoop(1,this,this._update);
	}

	__class(Timer,'laya.utils.Timer');
	var __proto=Timer.prototype;
	/**
	*@private
	*帧循环处理函数。
	*/
	__proto._update=function(){
		if (this.scale <=0){
			this._lastTimer=Browser.now();
			return;
		};
		var frame=this.currFrame=this.currFrame+this.scale;
		var now=Browser.now();
		this._delta=(now-this._lastTimer)*this.scale;
		var timer=this.currTimer=this.currTimer+this._delta;
		this._lastTimer=now;
		var handlers=this._handlers;
		this._count=0;
		for (i=0,n=handlers.length;i < n;i++){
			handler=handlers[i];
			if (handler.method!==null){
				var t=handler.userFrame ? frame :timer;
				if (t >=handler.exeTime){
					if (handler.repeat){
						if (!handler.jumpFrame){
							handler.exeTime+=handler.delay;
							handler.run(false);
							if (t > handler.exeTime){
								handler.exeTime+=Math.ceil((t-handler.exeTime)/ handler.delay)*handler.delay;
							}
							}else {
							while (t >=handler.exeTime){
								handler.exeTime+=handler.delay;
								handler.run(false);
							}
						}
						}else {
						handler.run(true);
					}
				}
				}else {
				this._count++;
			}
		}
		if (this._count > 30 || frame % 200===0)this._clearHandlers();
		var laters=this._laters;
		for (var i=0,n=laters.length-1;i <=n;i++){
			var handler=laters[i];
			if (handler.method!==null){
				this._map[handler.key]=null;
				handler.run(false);
			}
			this._recoverHandler(handler);
			i===n && (n=laters.length-1);
		}
		laters.length=0;
	}

	/**@private */
	__proto._clearHandlers=function(){
		var handlers=this._handlers;
		for (var i=0,n=handlers.length;i < n;i++){
			var handler=handlers[i];
			if (handler.method!==null)this._temp.push(handler);
			else this._recoverHandler(handler);
		}
		this._handlers=this._temp;
		handlers.length=0;
		this._temp=handlers;
	}

	/**@private */
	__proto._recoverHandler=function(handler){
		if(this._map[handler.key]==handler)this._map[handler.key]=null;
		handler.clear();
		Timer._pool.push(handler);
	}

	/**@private */
	__proto._create=function(useFrame,repeat,delay,caller,method,args,coverBefore){
		if (!delay){
			method.apply(caller,args);
			return null;
		}
		if (coverBefore){
			var handler=this._getHandler(caller,method);
			if (handler){
				handler.repeat=repeat;
				handler.userFrame=useFrame;
				handler.delay=delay;
				handler.caller=caller;
				handler.method=method;
				handler.args=args;
				handler.exeTime=delay+(useFrame ? this.currFrame :this.currTimer+Browser.now()-this._lastTimer);
				return handler;
			}
		}
		handler=Timer._pool.length > 0 ? Timer._pool.pop():new TimerHandler();
		handler.repeat=repeat;
		handler.userFrame=useFrame;
		handler.delay=delay;
		handler.caller=caller;
		handler.method=method;
		handler.args=args;
		handler.exeTime=delay+(useFrame ? this.currFrame :this.currTimer+Browser.now()-this._lastTimer);
		this._indexHandler(handler);
		this._handlers.push(handler);
		return handler;
	}

	/**@private */
	__proto._indexHandler=function(handler){
		var caller=handler.caller;
		var method=handler.method;
		var cid=caller ? caller.$_GID || (caller.$_GID=Utils.getGID()):0;
		var mid=method.$_TID || (method.$_TID=(this._mid++)*100000);
		handler.key=cid+mid;
		this._map[handler.key]=handler;
	}

	/**
	*定时执行一次。
	*@param delay 延迟时间(单位为毫秒)。
	*@param caller 执行域(this)。
	*@param method 定时器回调函数。
	*@param args 回调参数。
	*@param coverBefore 是否覆盖之前的延迟执行，默认为 true 。
	*/
	__proto.once=function(delay,caller,method,args,coverBefore){
		(coverBefore===void 0)&& (coverBefore=true);
		this._create(false,false,delay,caller,method,args,coverBefore);
	}

	/**
	*定时重复执行。
	*@param delay 间隔时间(单位毫秒)。
	*@param caller 执行域(this)。
	*@param method 定时器回调函数。
	*@param args 回调参数。
	*@param coverBefore 是否覆盖之前的延迟执行，默认为 true 。
	*@param jumpFrame 时钟是否跳帧。基于时间的循环回调，单位时间间隔内，如能执行多次回调，出于性能考虑，引擎默认只执行一次，设置jumpFrame=true后，则回调会连续执行多次
	*/
	__proto.loop=function(delay,caller,method,args,coverBefore,jumpFrame){
		(coverBefore===void 0)&& (coverBefore=true);
		(jumpFrame===void 0)&& (jumpFrame=false);
		var handler=this._create(false,true,delay,caller,method,args,coverBefore);
		if (handler)handler.jumpFrame=jumpFrame;
	}

	/**
	*定时执行一次(基于帧率)。
	*@param delay 延迟几帧(单位为帧)。
	*@param caller 执行域(this)。
	*@param method 定时器回调函数。
	*@param args 回调参数。
	*@param coverBefore 是否覆盖之前的延迟执行，默认为 true 。
	*/
	__proto.frameOnce=function(delay,caller,method,args,coverBefore){
		(coverBefore===void 0)&& (coverBefore=true);
		this._create(true,false,delay,caller,method,args,coverBefore);
	}

	/**
	*定时重复执行(基于帧率)。
	*@param delay 间隔几帧(单位为帧)。
	*@param caller 执行域(this)。
	*@param method 定时器回调函数。
	*@param args 回调参数。
	*@param coverBefore 是否覆盖之前的延迟执行，默认为 true 。
	*/
	__proto.frameLoop=function(delay,caller,method,args,coverBefore){
		(coverBefore===void 0)&& (coverBefore=true);
		this._create(true,true,delay,caller,method,args,coverBefore);
	}

	/**返回统计信息。*/
	__proto.toString=function(){
		return "callLater:"+this._laters.length+" handlers:"+this._handlers.length+" pool:"+Timer._pool.length;
	}

	/**
	*清理定时器。
	*@param caller 执行域(this)。
	*@param method 定时器回调函数。
	*/
	__proto.clear=function(caller,method){
		var handler=this._getHandler(caller,method);
		if (handler){
			this._map[handler.key]=null;handler.key=0;
			handler.clear();
		}
	}

	/**
	*清理对象身上的所有定时器。
	*@param caller 执行域(this)。
	*/
	__proto.clearAll=function(caller){
		if (!caller)return;
		for (var i=0,n=this._handlers.length;i < n;i++){
			var handler=this._handlers[i];
			if (handler.caller===caller){
				this._map[handler.key]=null;handler.key=0;
				handler.clear();
			}
		}
	}

	/**@private */
	__proto._getHandler=function(caller,method){
		var cid=caller ? caller.$_GID || (caller.$_GID=Utils.getGID()):0;
		var mid=method.$_TID || (method.$_TID=(this._mid++)*100000);
		return this._map[cid+mid];
	}

	/**
	*延迟执行。
	*@param caller 执行域(this)。
	*@param method 定时器回调函数。
	*@param args 回调参数。
	*/
	__proto.callLater=function(caller,method,args){
		if (this._getHandler(caller,method)==null){
			if (Timer._pool.length)
				var handler=Timer._pool.pop();
			else handler=new TimerHandler();
			handler.caller=caller;
			handler.method=method;
			handler.args=args;
			this._indexHandler(handler);
			this._laters.push(handler);
		}
	}

	/**
	*立即执行 callLater 。
	*@param caller 执行域(this)。
	*@param method 定时器回调函数。
	*/
	__proto.runCallLater=function(caller,method){
		var handler=this._getHandler(caller,method);
		if (handler && handler.method !=null){
			this._map[handler.key]=null;
			handler.run(true);
		}
	}

	/**
	*立即提前执行定时器，执行之后从队列中删除
	*@param caller 执行域(this)。
	*@param method 定时器回调函数。
	*/
	__proto.runTimer=function(caller,method){
		this.runCallLater(caller,method);
	}

	/**
	*两帧之间的时间间隔,单位毫秒。
	*/
	__getset(0,__proto,'delta',function(){
		return this._delta;
	});

	Timer._pool=[];
	Timer.__init$=function(){
		/**@private */
		//class TimerHandler
		TimerHandler=(function(){
			function TimerHandler(){
				this.key=0;
				this.repeat=false;
				this.delay=0;
				this.userFrame=false;
				this.exeTime=0;
				this.caller=null;
				this.method=null;
				this.args=null;
				this.jumpFrame=false;
			}
			__class(TimerHandler,'');
			var __proto=TimerHandler.prototype;
			__proto.clear=function(){
				this.caller=null;
				this.method=null;
				this.args=null;
			}
			__proto.run=function(withClear){
				var caller=this.caller;
				if (caller && caller.destroyed)return this.clear();
				var method=this.method;
				var args=this.args;
				withClear && this.clear();
				if (method==null)return;
				args ? method.apply(caller,args):method.call(caller);
			}
			return TimerHandler;
		})()
	}

	return Timer;
})()


	//file:///E:/git/layaair-master/core/src/laya/utils/Tween.as=======199.999829/199.999829
/**
*<code>Tween</code> 是一个缓动类。使用此类能够实现对目标对象属性的渐变。
*/
//class laya.utils.Tween
var Tween=(function(){
	function Tween(){
		/**@private */
		//this._complete=null;
		/**@private */
		//this._target=null;
		/**@private */
		//this._ease=null;
		/**@private */
		//this._props=null;
		/**@private */
		//this._duration=0;
		/**@private */
		//this._delay=0;
		/**@private */
		//this._startTimer=0;
		/**@private */
		//this._usedTimer=0;
		/**@private */
		//this._usedPool=false;
		/**@private 唯一标识，TimeLintLite用到*/
		this.gid=0;
		/**更新回调，缓动数值发生变化时，回调变化的值*/
		//this.update=null;
	}

	__class(Tween,'laya.utils.Tween');
	var __proto=Tween.prototype;
	/**
	*缓动对象的props属性到目标值。
	*@param target 目标对象(即将更改属性值的对象)。
	*@param props 变化的属性列表，比如{x:100,y:20,ease:Ease.backOut,complete:Handler.create(this,onComplete),update:new Handler(this,onComplete)}。
	*@param duration 花费的时间，单位毫秒。
	*@param ease 缓动类型，默认为匀速运动。
	*@param complete 结束回调函数。
	*@param delay 延迟执行时间。
	*@param coverBefore 是否覆盖之前的缓动。
	*@return 返回Tween对象。
	*/
	__proto.to=function(target,props,duration,ease,complete,delay,coverBefore){
		(delay===void 0)&& (delay=0);
		(coverBefore===void 0)&& (coverBefore=false);
		return this._create(target,props,duration,ease,complete,delay,coverBefore,true,false,true);
	}

	/**
	*从props属性，缓动到当前状态。
	*@param target 目标对象(即将更改属性值的对象)。
	*@param props 变化的属性列表，比如{x:100,y:20,ease:Ease.backOut,complete:Handler.create(this,onComplete),update:new Handler(this,onComplete)}。
	*@param duration 花费的时间，单位毫秒。
	*@param ease 缓动类型，默认为匀速运动。
	*@param complete 结束回调函数。
	*@param delay 延迟执行时间。
	*@param coverBefore 是否覆盖之前的缓动。
	*@return 返回Tween对象。
	*/
	__proto.from=function(target,props,duration,ease,complete,delay,coverBefore){
		(delay===void 0)&& (delay=0);
		(coverBefore===void 0)&& (coverBefore=false);
		return this._create(target,props,duration,ease,complete,delay,coverBefore,false,false,true);
	}

	/**@private */
	__proto._create=function(target,props,duration,ease,complete,delay,coverBefore,isTo,usePool,runNow){
		if (!target)throw new Error("Tween:target is null");
		this._target=target;
		this._duration=duration;
		this._ease=ease || props.ease || Tween.easeNone;
		this._complete=complete || props.complete;
		this._delay=delay;
		this._props=[];
		this._usedTimer=0;
		this._startTimer=Browser.now();
		this._usedPool=usePool;
		this.update=props.update;
		var gid=(target.$_GID || (target.$_GID=Utils.getGID()));
		if (!Tween.tweenMap[gid]){
			Tween.tweenMap[gid]=[this];
			}else {
			if (coverBefore)Tween.clearTween(target);
			Tween.tweenMap[gid].push(this);
		}
		if (runNow){
			if (delay <=0)this.firstStart(target,props,isTo);
			else Laya.timer.once(delay,this,this.firstStart,[target,props,isTo]);
			}else {
			this._initProps(target,props,isTo);
		}
		return this;
	}

	__proto.firstStart=function(target,props,isTo){
		if (target.destroyed){
			this.clear();
			return;
		}
		this._initProps(target,props,isTo);
		this._beginLoop();
	}

	__proto._initProps=function(target,props,isTo){
		for (var p in props){
			if ((typeof (target[p])=='number')){
				var start=isTo ? target[p] :props[p];
				var end=isTo ? props[p] :target[p];
				this._props.push([p,start,end-start]);
				if (!isTo)target[p]=start;
			}
		}
	}

	__proto._beginLoop=function(){
		Laya.timer.frameLoop(1,this,this._doEase);
	}

	/**执行缓动**/
	__proto._doEase=function(){
		this._updateEase(Browser.now());
	}

	/**@private */
	__proto._updateEase=function(time){
		var target=this._target;
		if (!target)return;
		if (target.destroyed)return Tween.clearTween(target);
		var usedTimer=this._usedTimer=time-this._startTimer-this._delay;
		if (usedTimer < 0)return;
		if (usedTimer >=this._duration)return this.complete();
		var ratio=usedTimer > 0 ? this._ease(usedTimer,0,1,this._duration):0;
		var props=this._props;
		for (var i=0,n=props.length;i < n;i++){
			var prop=props[i];
			target[prop[0]]=prop[1]+(ratio *prop[2]);
		}
		if (this.update)this.update.run();
	}

	/**
	*立即结束缓动并到终点。
	*/
	__proto.complete=function(){
		if (!this._target)return;
		Laya.timer.runTimer(this,this.firstStart);
		var target=this._target;
		var props=this._props;
		var handler=this._complete;
		for (var i=0,n=props.length;i < n;i++){
			var prop=props[i];
			target[prop[0]]=prop[1]+prop[2];
		}
		if (this.update)this.update.run();
		this.clear();
		handler && handler.run();
	}

	/**
	*暂停缓动，可以通过resume或restart重新开始。
	*/
	__proto.pause=function(){
		Laya.timer.clear(this,this._beginLoop);
		Laya.timer.clear(this,this._doEase);
	}

	/**
	*设置开始时间。
	*@param startTime 开始时间。
	*/
	__proto.setStartTime=function(startTime){
		this._startTimer=startTime;
	}

	/**
	*停止并清理当前缓动。
	*/
	__proto.clear=function(){
		if (this._target){
			this._remove();
			this._clear();
		}
	}

	/**
	*@private
	*/
	__proto._clear=function(){
		this.pause();
		Laya.timer.clear(this,this.firstStart);
		this._complete=null;
		this._target=null;
		this._ease=null;
		this._props=null;
		if (this._usedPool){
			this.update=null;
			Pool.recover("tween",this);
		}
	}

	/**回收到对象池。*/
	__proto.recover=function(){
		this._usedPool=true;
		this._clear();
	}

	__proto._remove=function(){
		var tweens=Tween.tweenMap[this._target.$_GID];
		if (tweens){
			for (var i=0,n=tweens.length;i < n;i++){
				if (tweens[i]===this){
					tweens.splice(i,1);
					break ;
				}
			}
		}
	}

	/**
	*重新开始暂停的缓动。
	*/
	__proto.restart=function(){
		this.pause();
		this._usedTimer=0;
		this._startTimer=Browser.now();
		var props=this._props;
		for (var i=0,n=props.length;i < n;i++){
			var prop=props[i];
			this._target[prop[0]]=prop[1];
		}
		Laya.timer.once(this._delay,this,this._beginLoop);
	}

	/**
	*恢复暂停的缓动。
	*/
	__proto.resume=function(){
		if (this._usedTimer >=this._duration)return;
		this._startTimer=Browser.now()-this._usedTimer-this._delay;
		this._beginLoop();
	}

	/**设置当前执行比例**/
	__getset(0,__proto,'progress',null,function(v){
		var uTime=v *this._duration;
		this._startTimer=Browser.now()-this._delay-uTime;
	});

	Tween.to=function(target,props,duration,ease,complete,delay,coverBefore,autoRecover){
		(delay===void 0)&& (delay=0);
		(coverBefore===void 0)&& (coverBefore=false);
		(autoRecover===void 0)&& (autoRecover=true);
		return Pool.getItemByClass("tween",Tween)._create(target,props,duration,ease,complete,delay,coverBefore,true,autoRecover,true);
	}

	Tween.from=function(target,props,duration,ease,complete,delay,coverBefore,autoRecover){
		(delay===void 0)&& (delay=0);
		(coverBefore===void 0)&& (coverBefore=false);
		(autoRecover===void 0)&& (autoRecover=true);
		return Pool.getItemByClass("tween",Tween)._create(target,props,duration,ease,complete,delay,coverBefore,false,autoRecover,true);
	}

	Tween.clearAll=function(target){
		if (!target || !target.$_GID)return;
		var tweens=Tween.tweenMap[target.$_GID];
		if (tweens){
			for (var i=0,n=tweens.length;i < n;i++){
				tweens[i]._clear();
			}
			tweens.length=0;
		}
	}

	Tween.clear=function(tween){
		tween.clear();
	}

	Tween.clearTween=function(target){
		Tween.clearAll(target);
	}

	Tween.easeNone=function(t,b,c,d){
		return c *t / d+b;
	}

	Tween.tweenMap=[];
	return Tween;
})()


	//file:///E:/git/layaair-master/core/src/laya/utils/Utils.as=======199.999828/199.999828
/**
*<code>Utils</code> 是工具类。
*/
//class laya.utils.Utils
var Utils=(function(){
	function Utils(){}
	__class(Utils,'laya.utils.Utils');
	Utils.toRadian=function(angle){
		return angle *Utils._pi2;
	}

	Utils.toAngle=function(radian){
		return radian *Utils._pi;
	}

	Utils.toHexColor=function(color){
		if (color < 0 || isNaN(color))return null;
		var str=color.toString(16);
		while (str.length < 6)str="0"+str;
		return "#"+str;
	}

	Utils.getGID=function(){
		return Utils._gid++;
	}

	Utils.parseXMLFromString=function(value){
		var rst;
		value=value.replace(/>\s+</g,'><');
		rst=(new DOMParser()).parseFromString(value,'text/xml');
		if (rst.firstChild.textContent.indexOf("This page contains the following errors")>-1){
			throw new Error(rst.firstChild.firstChild.textContent);
		}
		return rst;
	}

	Utils.concatArray=function(source,array){
		if (!array)return source;
		if (!source)return array;
		var i=0,len=array.length;
		for (i=0;i < len;i++){
			source.push(array[i]);
		}
		return source;
	}

	Utils.clearArray=function(array){
		if (!array)return array;
		array.length=0;
		return array;
	}

	Utils.copyArray=function(source,array){
		source || (source=[]);
		if (!array)return source;
		source.length=array.length;
		var i=0,len=array.length;
		for (i=0;i < len;i++){
			source[i]=array[i];
		}
		return source;
	}

	Utils.getGlobalRecByPoints=function(sprite,x0,y0,x1,y1){
		var newLTPoint;
		newLTPoint=Point.create().setTo(x0,y0);
		newLTPoint=sprite.localToGlobal(newLTPoint);
		var newRBPoint;
		newRBPoint=Point.create().setTo(x1,y1);
		newRBPoint=sprite.localToGlobal(newRBPoint);
		var rst=Rectangle._getWrapRec([newLTPoint.x,newLTPoint.y,newRBPoint.x,newRBPoint.y]);
		newLTPoint.recover();
		newRBPoint.recover();
		return rst;
	}

	Utils.getGlobalPosAndScale=function(sprite){
		return Utils.getGlobalRecByPoints(sprite,0,0,1,1);
	}

	Utils.bind=function(fun,scope){
		var rst=fun;
		rst=fun.bind(scope);;
		return rst;
	}

	Utils.measureText=function(txt,font){
		return RunDriver.measureText(txt,font);
	}

	Utils.updateOrder=function(array){
		if (!array || array.length < 2)return false;
		var i=1,j=0,len=array.length,key=NaN,c;
		while (i < len){
			j=i;
			c=array[j];
			key=array[j]._zOrder;
			while (--j >-1){
				if (array[j]._zOrder > key)array[j+1]=array[j];
				else break ;
			}
			array[j+1]=c;
			i++;
		}
		return true;
	}

	Utils.transPointList=function(points,x,y){
		var i=0,len=points.length;
		for (i=0;i < len;i+=2){
			points[i]+=x;
			points[i+1]+=y;
		}
	}

	Utils.parseInt=function(str,radix){
		(radix===void 0)&& (radix=0);
		var result=Browser.window.parseInt(str,radix);
		if (isNaN(result))return 0;
		return result;
	}

	Utils.getFileExtension=function(path){
		Utils._extReg.lastIndex=path.lastIndexOf(".");
		var result=Utils._extReg.exec(path);
		if (result && result.length > 1){
			return result[1].toLowerCase();
		}
		return null;
	}

	Utils.getTransformRelativeToWindow=function(coordinateSpace,x,y){
		var stage=Laya.stage;
		var globalTransform=laya.utils.Utils.getGlobalPosAndScale(coordinateSpace);
		var canvasMatrix=stage._canvasTransform.clone();
		var canvasLeft=canvasMatrix.tx;
		var canvasTop=canvasMatrix.ty;
		canvasMatrix.rotate(-Math.PI / 180 *Laya.stage.canvasDegree);
		canvasMatrix.scale(Laya.stage.clientScaleX,Laya.stage.clientScaleY);
		var perpendicular=(Laya.stage.canvasDegree % 180 !=0);
		var tx=NaN,ty=NaN;
		if (perpendicular){
			tx=y+globalTransform.y;
			ty=x+globalTransform.x;
			tx *=canvasMatrix.d;
			ty *=canvasMatrix.a;
			if (Laya.stage.canvasDegree==90){
				tx=canvasLeft-tx;
				ty+=canvasTop;
			}
			else {
				tx+=canvasLeft;
				ty=canvasTop-ty;
			}
		}
		else {
			tx=x+globalTransform.x;
			ty=y+globalTransform.y;
			tx *=canvasMatrix.a;
			ty *=canvasMatrix.d;
			tx+=canvasLeft;
			ty+=canvasTop;
		}
		ty+=Laya.stage['_safariOffsetY'];
		var domScaleX=NaN,domScaleY=NaN;
		if (perpendicular){
			domScaleX=canvasMatrix.d *globalTransform.height;
			domScaleY=canvasMatrix.a *globalTransform.width;
			}else {
			domScaleX=canvasMatrix.a *globalTransform.width;
			domScaleY=canvasMatrix.d *globalTransform.height;
		}
		return {x:tx,y:ty,scaleX:domScaleX,scaleY:domScaleY};
	}

	Utils.fitDOMElementInArea=function(dom,coordinateSpace,x,y,width,height){
		if (!dom._fitLayaAirInitialized){
			dom._fitLayaAirInitialized=true;
			dom.style.transformOrigin=dom.style.webKittransformOrigin="left top";
			dom.style.position="absolute"
		};
		var transform=Utils.getTransformRelativeToWindow(coordinateSpace,x,y);
		dom.style.transform=dom.style.webkitTransform="scale("+transform.scaleX+","+transform.scaleY+") rotate("+(Laya.stage.canvasDegree)+"deg)";
		dom.style.width=width+'px';
		dom.style.height=height+'px';
		dom.style.left=transform.x+'px';
		dom.style.top=transform.y+'px';
	}

	Utils._gid=1;
	Utils._pi=180 / Math.PI;
	Utils._pi2=Math.PI / 180;
	Utils._extReg=/\.(\w+)\??/g;
	return Utils;
})()


	//file:///E:/git/layaair-master/core/src/laya/utils/VectorGraphManager.as=======199.999827/199.999827
/**
*@private
*TODO:
*/
//class laya.utils.VectorGraphManager
var VectorGraphManager=(function(){
	function VectorGraphManager(){
		this.useDic={};
		this.shapeDic={};
		this.shapeLineDic={};
		this._id=0;
		this._checkKey=false;
		this._freeIdArray=[];
		if (Render.isWebGL){
			CacheManger.regCacheByFunction(Utils.bind(this.startDispose,this),Utils.bind(this.getCacheList,this));
		}
	}

	__class(VectorGraphManager,'laya.utils.VectorGraphManager');
	var __proto=VectorGraphManager.prototype;
	/**
	*得到个空闲的ID
	*@return
	*/
	__proto.getId=function(){
		return this._id++;
	}

	/**
	*添加一个图形到列表中
	*@param id
	*@param shape
	*/
	__proto.addShape=function(id,shape){
		this.shapeDic[id]=shape;
		if (!this.useDic[id]){
			this.useDic[id]=true;
		}
	}

	/**
	*添加一个线图形到列表中
	*@param id
	*@param Line
	*/
	__proto.addLine=function(id,Line){
		this.shapeLineDic[id]=Line;
		if (!this.shapeLineDic[id]){
			this.shapeLineDic[id]=true;
		}
	}

	/**
	*检测一个对象是否在使用中
	*@param id
	*/
	__proto.getShape=function(id){
		if (this._checkKey){
			if (this.useDic[id] !=null){
				this.useDic[id]=true;
			}
		}
	}

	/**
	*删除一个图形对象
	*@param id
	*/
	__proto.deleteShape=function(id){
		if (this.shapeDic[id]){
			this.shapeDic[id]=null;
			delete this.shapeDic[id];
		}
		if (this.shapeLineDic[id]){
			this.shapeLineDic[id]=null;
			delete this.shapeLineDic[id];
		}
		if (this.useDic[id] !=null){
			delete this.useDic[id];
		}
	}

	/**
	*得到缓存列表
	*@return
	*/
	__proto.getCacheList=function(){
		var str;
		var list=[];
		for (str in this.shapeDic){
			list.push(this.shapeDic[str]);
		}
		for (str in this.shapeLineDic){
			list.push(this.shapeLineDic[str]);
		}
		return list;
	}

	/**
	*开始清理状态，准备销毁
	*/
	__proto.startDispose=function(key){
		var str;
		for (str in this.useDic){
			this.useDic[str]=false;
		}
		this._checkKey=true;
	}

	/**
	*确认销毁
	*/
	__proto.endDispose=function(){
		if (this._checkKey){
			var str;
			for (str in this.useDic){
				if (!this.useDic[str]){
					this.deleteShape(str);
				}
			}
			this._checkKey=false;
		}
	}

	VectorGraphManager.getInstance=function(){
		return VectorGraphManager.instance=VectorGraphManager.instance|| new VectorGraphManager();
	}

	VectorGraphManager.instance=null;
	return VectorGraphManager;
})()


	//file:///E:/git/layaair-master/core/src/laya/utils/WeakObject.as=======199.999826/199.999826
/**
*封装弱引用WeakMap
*如果支持WeakMap，则使用WeakMap，如果不支持，则用Object代替
*注意：如果采用Object，为了防止内存泄漏，则采用定时清理缓存策略
*/
//class laya.utils.WeakObject
var WeakObject=(function(){
	function WeakObject(){
		/**@private */
		this._obj=null;
		this._obj=WeakObject.supportWeakMap ? new Browser.window.WeakMap():{};
		if (!WeakObject.supportWeakMap)WeakObject._maps.push(this);
	}

	__class(WeakObject,'laya.utils.WeakObject');
	var __proto=WeakObject.prototype;
	/**
	*设置缓存
	*@param key kye对象，可被回收
	*@param value object对象，可被回收
	*/
	__proto.set=function(key,value){
		if (key==null)return;
		if (WeakObject.supportWeakMap){
			var objKey=key;
			if ((typeof key=='string')|| (typeof key=='number')){
				objKey=WeakObject._keys[key];
				if (!objKey)objKey=WeakObject._keys[key]={k:key};
			}
			this._obj.set(objKey,value);
			}else {
			if ((typeof key=='string')|| (typeof key=='number')){
				this._obj[key]=value;
				}else {
				key.$_GID || (key.$_GID=Utils.getGID());
				this._obj[key.$_GID]=value;
			}
		}
	}

	/**
	*获取缓存
	*@param key kye对象，可被回收
	*/
	__proto.get=function(key){
		if (key==null)return null;
		if (WeakObject.supportWeakMap){
			var objKey=((typeof key=='string')|| (typeof key=='number'))? WeakObject._keys[key] :key;
			return this._obj.get(objKey);
			}else {
			if ((typeof key=='string')|| (typeof key=='number'))return this._obj[key];
			return this._obj[key.$_GID];
		}
	}

	/**
	*删除缓存
	*/
	__proto.del=function(key){
		if (key==null)return;
		if (WeakObject.supportWeakMap){
			var objKey=((typeof key=='string')|| (typeof key=='number'))? WeakObject._keys[key] :key;
			_obj.delete(objKey);
			}else {
			if ((typeof key=='string')|| (typeof key=='number'))delete this._obj[key];
			else delete this._obj[this._obj.$_GID];
		}
	}

	/**
	*是否有缓存
	*/
	__proto.has=function(key){
		if (key==null)return false;
		if (WeakObject.supportWeakMap){
			var objKey=((typeof key=='string')|| (typeof key=='number'))? WeakObject._keys[key] :key;
			return this._obj.has(objKey);
			}else {
			if ((typeof key=='string')|| (typeof key=='number'))return this._obj[key] !=null;
			return this._obj[this._obj.$_GID] !=null;
		}
	}

	WeakObject.__init__=function(){
		WeakObject.supportWeakMap=Browser.window.WeakMap !=null;
		if (!WeakObject.supportWeakMap)Laya.timer.loop(WeakObject.delInterval,null,WeakObject.clearCache);
	}

	WeakObject.clearCache=function(){
		for (var i=0,n=WeakObject._maps.length;i < n;i++){
			var obj=WeakObject._maps[i];
			obj._obj={};
		}
	}

	WeakObject.supportWeakMap=false;
	WeakObject.delInterval=10 *60 *1000;
	WeakObject._keys={};
	WeakObject._maps=[];
	__static(WeakObject,
	['I',function(){return this.I=new WeakObject();}
	]);
	return WeakObject;
})()


	//file:///E:/git/layaair-master/core/src/laya/utils/WordText.as=======199.999825/199.999825
/**
*@private
*/
//class laya.utils.WordText
var WordText=(function(){
	function WordText(){
		//TODO:
		this.id=NaN;
		this.save=[];
		this.toUpperCase=null;
		this.changed=false;
		this._text=null;
		this.width=-1;
		//整个WordText的长度。-1表示没有计算还。
		this.pageChars=[];
	}

	__class(WordText,'laya.utils.WordText');
	var __proto=WordText.prototype;
	//同一个texture的文字。里面又是一个数组。具体含义见使用的地方。
	__proto.setText=function(txt){
		this.changed=true;
		this._text=txt;
		this.width=-1;
		this.pageChars=[];
	}

	//需要重新更新
	__proto.toString=function(){
		return this._text;
	}

	__proto.charCodeAt=function(i){
		return this._text ? this._text.charCodeAt(i):NaN;
	}

	__proto.charAt=function(i){
		return this._text ? this._text.charAt(i):null;
	}

	__getset(0,__proto,'length',function(){
		return this._text ? this._text.length :0;
	});

	return WordText;
})()


	//file:///E:/git/layaair-master/core/src/laya/display/Node.as=======98.999981/98.999981
/**
*<code>Node</code> 类是可放在显示列表中的所有对象的基类。该显示列表管理 Laya 运行时中显示的所有对象。使用 Node 类排列显示列表中的显示对象。Node 对象可以有子显示对象。
*/
//class laya.display.Node extends laya.events.EventDispatcher
var Node=(function(_super){
	function Node(){
		/**@private */
		this._bits=0;
		/**@private 父节点对象*/
		this._parent=null;
		/**节点名称。*/
		this.name="";
		/**[只读]是否已经销毁。对象销毁后不能再使用。*/
		this.destroyed=false;
		this.data=null;
		Node.__super.call(this);
		this._children=Node.ARRAY_EMPTY;
		this._$P=Node.PROP_EMPTY;
		this.timer=Laya.timer;
		this.createGLBuffer();
	}

	__class(Node,'laya.display.Node',_super);
	var __proto=Node.prototype;
	__proto.createGLBuffer=function(){}
	/**@private */
	__proto._setBit=function(type,value){
		if (type===0x01){
			var preValue=this._getBit(type);
			if (preValue !=value)this._updateDisplayedInstage();
		}
		if (value)this._bits |=type;
		else this._bits &=~type;
	}

	/**@private */
	__proto._getBit=function(type){
		return (this._bits & type)!=0;
	}

	/**@private */
	__proto._setUpNoticeChain=function(){
		if (this._getBit(0x01))this._setBitUp(0x01);
	}

	/**@private */
	__proto._setBitUp=function(type){
		var ele=this;
		ele._setBit(type,true);
		ele=ele._parent;
		while (ele){
			if (ele._getBit(type))return;
			ele._setBit(type,true);
			ele=ele._parent;
		}
	}

	/**@private */
	__proto._set$P=function(key,value){
		if (!this.destroyed){
			this._$P===Node.PROP_EMPTY && (this._$P={});
			this._$P[key]=value;
		}
		return value;
	}

	/**
	*<p>增加事件侦听器，以使侦听器能够接收事件通知。</p>
	*<p>如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnabled 的值为 true(如果父节点mouseEnabled=false，则停止设置父节点mouseEnabled属性)。</p>
	*@param type 事件的类型。
	*@param caller 事件侦听函数的执行域。
	*@param listener 事件侦听函数。
	*@param args （可选）事件侦听函数的回调参数。
	*@return 此 EventDispatcher 对象。
	*/
	__proto.on=function(type,caller,listener,args){
		if (type==="display" || type==="undisplay"){
			if (!this._getBit(0x01))this._setBitUp(0x01);
		}
		return this._createListener(type,caller,listener,args,false);
	}

	/**
	*<p>增加事件侦听器，以使侦听器能够接收事件通知，此侦听事件响应一次后则自动移除侦听。</p>
	*<p>如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnabled 的值为 true(如果父节点mouseEnabled=false，则停止设置父节点mouseEnabled属性)。</p>
	*@param type 事件的类型。
	*@param caller 事件侦听函数的执行域。
	*@param listener 事件侦听函数。
	*@param args （可选）事件侦听函数的回调参数。
	*@return 此 EventDispatcher 对象。
	*/
	__proto.once=function(type,caller,listener,args){
		if (type==="display" || type==="undisplay"){
			if (!this._getBit(0x01))this._setBitUp(0x01);
		}
		return this._createListener(type,caller,listener,args,true);
	}

	/**
	*<p>销毁此对象。destroy对象默认会把自己从父节点移除，并且清理自身引用关系，等待js自动垃圾回收机制回收。destroy后不能再使用。</p>
	*<p>destroy时会移除自身的事情监听，自身的timer监听，移除子对象及从父节点移除自己。</p>
	*@param destroyChild （可选）是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
	*/
	__proto.destroy=function(destroyChild){
		(destroyChild===void 0)&& (destroyChild=true);
		this.destroyed=true;
		this._parent && this._parent.removeChild(this);
		if (this._children){
			if (destroyChild)this.destroyChildren();
			else this.removeChildren();
		}
		this._children=null;
		this.offAll();
		this.timer.clearAll(this);
	}

	/**
	*销毁所有子对象，不销毁自己本身。
	*/
	__proto.destroyChildren=function(){
		if (this._children){
			for (var i=this._children.length-1;i >-1;i--){
				this._children[i].destroy(true);
			}
		}
	}

	/**
	*添加子节点。
	*@param node 节点对象
	*@return 返回添加的节点
	*/
	__proto.addChild=function(node){
		if (!node || this.destroyed || node===this)return node;
		if ((node)._zOrder)this._setBit(0x02,true);
		if (node._parent===this){
			var index=this.getChildIndex(node);
			if (index!==this._children.length-1){
				this._children.splice(index,1);
				this._children.push(node);
				this._childChanged();
			}
			}else {
			node._parent && node._parent.removeChild(node);
			this._children===Node.ARRAY_EMPTY && (this._children=[]);
			this._children.push(node);
			node._setParent(this);
			this._childChanged();
		}
		return node;
	}

	/**
	*批量增加子节点
	*@param ...args 无数子节点。
	*/
	__proto.addChildren=function(__args){
		var args=arguments;
		var i=0,n=args.length;
		while (i < n){
			this.addChild(args[i++]);
		}
	}

	/**
	*添加子节点到指定的索引位置。
	*@param node 节点对象。
	*@param index 索引位置。
	*@return 返回添加的节点。
	*/
	__proto.addChildAt=function(node,index){
		if (!node || this.destroyed || node===this)return node;
		if ((node)._zOrder)this._setBit(0x02,true);
		if (index >=0 && index <=this._children.length){
			if (node._parent===this){
				var oldIndex=this.getChildIndex(node);
				this._children.splice(oldIndex,1);
				this._children.splice(index,0,node);
				this._childChanged();
				}else {
				node._parent && node._parent.removeChild(node);
				this._children===Node.ARRAY_EMPTY && (this._children=[]);
				this._children.splice(index,0,node);
				node._setParent(this);
			}
			return node;
			}else {
			throw new Error("appendChildAt:The index is out of bounds");
		}
	}

	/**
	*根据子节点对象，获取子节点的索引位置。
	*@param node 子节点。
	*@return 子节点所在的索引位置。
	*/
	__proto.getChildIndex=function(node){
		return this._children.indexOf(node);
	}

	/**
	*根据子节点的名字，获取子节点对象。
	*@param name 子节点的名字。
	*@return 节点对象。
	*/
	__proto.getChildByName=function(name){
		var nodes=this._children;
		if (nodes){
			for (var i=0,n=nodes.length;i < n;i++){
				var node=nodes[i];
				if (node.name===name)return node;
			}
		}
		return null;
	}

	/**
	*根据子节点的索引位置，获取子节点对象。
	*@param index 索引位置
	*@return 子节点
	*/
	__proto.getChildAt=function(index){
		return this._children[index] || null;
	}

	/**
	*设置子节点的索引位置。
	*@param node 子节点。
	*@param index 新的索引。
	*@return 返回子节点本身。
	*/
	__proto.setChildIndex=function(node,index){
		var childs=this._children;
		if (index < 0 || index >=childs.length){
			throw new Error("setChildIndex:The index is out of bounds.");
		};
		var oldIndex=this.getChildIndex(node);
		if (oldIndex < 0)throw new Error("setChildIndex:node is must child of this object.");
		childs.splice(oldIndex,1);
		childs.splice(index,0,node);
		this._childChanged();
		return node;
	}

	/**
	*@private
	*子节点发生改变。
	*@param child 子节点。
	*/
	__proto._childChanged=function(child){}
	/**
	*删除子节点。
	*@param node 子节点
	*@return 被删除的节点
	*/
	__proto.removeChild=function(node){
		if (!this._children)return node;
		var index=this._children.indexOf(node);
		return this.removeChildAt(index);
	}

	/**
	*从父容器删除自己，如已经被删除不会抛出异常。
	*@return 当前节点（ Node ）对象。
	*/
	__proto.removeSelf=function(){
		this._parent && this._parent.removeChild(this);
		return this;
	}

	/**
	*根据子节点名字删除对应的子节点对象，如果找不到不会抛出异常。
	*@param name 对象名字。
	*@return 查找到的节点（ Node ）对象。
	*/
	__proto.removeChildByName=function(name){
		var node=this.getChildByName(name);
		node && this.removeChild(node);
		return node;
	}

	/**
	*根据子节点索引位置，删除对应的子节点对象。
	*@param index 节点索引位置。
	*@return 被删除的节点。
	*/
	__proto.removeChildAt=function(index){
		var node=this.getChildAt(index);
		if (node){
			this._children.splice(index,1);
			node._setParent(null);
		}
		return node;
	}

	/**
	*删除指定索引区间的所有子对象。
	*@param beginIndex 开始索引。
	*@param endIndex 结束索引。
	*@return 当前节点对象。
	*/
	__proto.removeChildren=function(beginIndex,endIndex){
		(beginIndex===void 0)&& (beginIndex=0);
		(endIndex===void 0)&& (endIndex=0x7fffffff);
		if (this._children && this._children.length > 0){
			var childs=this._children;
			if (beginIndex===0 && endIndex >=childs.length-1){
				var arr=childs;
				this._children=Node.ARRAY_EMPTY;
				}else {
				arr=childs.splice(beginIndex,endIndex-beginIndex);
			}
			for (var i=0,n=arr.length;i < n;i++){
				arr[i]._setParent(null);
			}
		}
		return this;
	}

	/**
	*替换子节点。
	*@internal 将传入的新节点对象替换到已有子节点索引位置处。
	*@param newNode 新节点。
	*@param oldNode 老节点。
	*@return 返回新节点。
	*/
	__proto.replaceChild=function(newNode,oldNode){
		var index=this._children.indexOf(oldNode);
		if (index >-1){
			this._children.splice(index,1,newNode);
			oldNode._setParent(null);
			newNode._setParent(this);
			return newNode;
		}
		return null;
	}

	__proto._setParent=function(value){
		if (this._parent!==value){
			if (value){
				this._parent=value;
				this.event("added");
				if (this._getBit(0x01)){
					this._setUpNoticeChain();
					value.displayedInStage && this._displayChild(this,true);
				}
				value._childChanged(this);
				}else {
				this.event("removed");
				this._parent._childChanged();
				if (this._getBit(0x01))this._displayChild(this,false);
				this._parent=value;
			}
		}
	}

	/**@private */
	__proto._updateDisplayedInstage=function(){
		var ele;
		ele=this;
		var stage=Laya.stage;
		var displayedInStage=false;
		while (ele){
			if (ele._getBit(0x01)){
				displayedInStage=ele._getBit(0x08);
				break ;
			}
			if (ele===stage || ele._getBit(0x08)){
				displayedInStage=true;
				break ;
			}
			ele=ele._parent;
		}
		this._setBit(0x08,displayedInStage);
	}

	/**@private */
	__proto._setDisplay=function(value){
		if (this._getBit(0x08)!==value){
			this._setBit(0x08,value);
			if (value)this.event("display");
			else this.event("undisplay");
		}
	}

	/**
	*@private
	*设置指定节点对象是否可见(是否在渲染列表中)。
	*@param node 节点。
	*@param display 是否可见。
	*/
	__proto._displayChild=function(node,display){
		var childs=node._children;
		if (childs){
			for (var i=0,n=childs.length;i < n;i++){
				var child=childs[i];
				if (!child._getBit(0x01))continue ;
				if (child._children.length > 0){
					this._displayChild(child,display);
					}else {
					child._setDisplay(display);
				}
			}
		}
		node._setDisplay(display);
	}

	/**
	*当前容器是否包含指定的 <code>Node</code> 节点对象 。
	*@param node 指定的 <code>Node</code> 节点对象 。
	*@return 一个布尔值表示是否包含指定的 <code>Node</code> 节点对象 。
	*/
	__proto.contains=function(node){
		if (node===this)return true;
		while (node){
			if (node._parent===this)return true;
			node=node._parent;
		}
		return false;
	}

	/**
	*定时重复执行某函数。功能同Laya.timer.timerLoop()。
	*@param delay 间隔时间(单位毫秒)。
	*@param caller 执行域(this)。
	*@param method 结束时的回调方法。
	*@param args （可选）回调参数。
	*@param coverBefore （可选）是否覆盖之前的延迟执行，默认为true。
	*@param jumpFrame 时钟是否跳帧。基于时间的循环回调，单位时间间隔内，如能执行多次回调，出于性能考虑，引擎默认只执行一次，设置jumpFrame=true后，则回调会连续执行多次
	*/
	__proto.timerLoop=function(delay,caller,method,args,coverBefore,jumpFrame){
		(coverBefore===void 0)&& (coverBefore=true);
		(jumpFrame===void 0)&& (jumpFrame=false);
		this.timer.loop(delay,caller,method,args,coverBefore,jumpFrame);
	}

	/**
	*定时执行某函数一次。功能同Laya.timer.timerOnce()。
	*@param delay 延迟时间(单位毫秒)。
	*@param caller 执行域(this)。
	*@param method 结束时的回调方法。
	*@param args （可选）回调参数。
	*@param coverBefore （可选）是否覆盖之前的延迟执行，默认为true。
	*/
	__proto.timerOnce=function(delay,caller,method,args,coverBefore){
		(coverBefore===void 0)&& (coverBefore=true);
		this.timer._create(false,false,delay,caller,method,args,coverBefore);
	}

	/**
	*定时重复执行某函数(基于帧率)。功能同Laya.timer.frameLoop()。
	*@param delay 间隔几帧(单位为帧)。
	*@param caller 执行域(this)。
	*@param method 结束时的回调方法。
	*@param args （可选）回调参数。
	*@param coverBefore （可选）是否覆盖之前的延迟执行，默认为true。
	*/
	__proto.frameLoop=function(delay,caller,method,args,coverBefore){
		(coverBefore===void 0)&& (coverBefore=true);
		this.timer._create(true,true,delay,caller,method,args,coverBefore);
	}

	/**
	*定时执行一次某函数(基于帧率)。功能同Laya.timer.frameOnce()。
	*@param delay 延迟几帧(单位为帧)。
	*@param caller 执行域(this)
	*@param method 结束时的回调方法
	*@param args （可选）回调参数
	*@param coverBefore （可选）是否覆盖之前的延迟执行，默认为true
	*/
	__proto.frameOnce=function(delay,caller,method,args,coverBefore){
		(coverBefore===void 0)&& (coverBefore=true);
		this.timer._create(true,false,delay,caller,method,args,coverBefore);
	}

	/**
	*清理定时器。功能同Laya.timer.clearTimer()。
	*@param caller 执行域(this)。
	*@param method 结束时的回调方法。
	*/
	__proto.clearTimer=function(caller,method){
		this.timer.clear(caller,method);
	}

	/**
	*子对象数量。
	*/
	__getset(0,__proto,'numChildren',function(){
		return this._children.length;
	});

	/**父节点。*/
	__getset(0,__proto,'parent',function(){
		return this._parent;
	});

	/**表示是否在显示列表中显示。*/
	__getset(0,__proto,'displayedInStage',function(){
		if (this._getBit(0x01))return this._getBit(0x08);
		this._setBitUp(0x01);
		return this._getBit(0x08);
	});

	Node.ARRAY_EMPTY=[];
	Node.PROP_EMPTY={};
	return Node;
})(EventDispatcher)


	//file:///E:/git/layaair-master/core/src/laya/media/h5audio/AudioSound.as=======98.999894/98.999894
/**
*@private
*使用Audio标签播放声音
*/
//class laya.media.h5audio.AudioSound extends laya.events.EventDispatcher
var AudioSound=(function(_super){
	function AudioSound(){
		/**
		*声音URL
		*/
		this.url=null;
		/**
		*播放用的audio标签
		*/
		this.audio=null;
		/**
		*是否已加载完成
		*/
		this.loaded=false;
		AudioSound.__super.call(this);
	}

	__class(AudioSound,'laya.media.h5audio.AudioSound',_super);
	var __proto=AudioSound.prototype;
	/**
	*释放声音
	*/
	__proto.dispose=function(){
		var ad=AudioSound._audioCache[this.url];
		if (ad){
			ad.src="";
			delete AudioSound._audioCache[this.url];
		}
	}

	/**
	*加载声音
	*@param url
	*
	*/
	__proto.load=function(url){
		url=URL.formatURL(url);
		this.url=url;
		var ad=AudioSound._audioCache[url];
		if (ad && ad.readyState >=2){
			this.event("complete");
			return;
		}
		if (!ad){
			ad=Browser.createElement("audio");
			ad.src=url;
			AudioSound._audioCache[url]=ad;
		}
		ad.addEventListener("canplaythrough",onLoaded);
		ad.addEventListener("error",onErr);
		var me=this;
		function onLoaded (){
			offs();
			me.loaded=true;
			me.event("complete");
		}
		function onErr (){
			ad.load=null;
			offs();
			me.event("error");
		}
		function offs (){
			ad.removeEventListener("canplaythrough",onLoaded);
			ad.removeEventListener("error",onErr);
		}
		this.audio=ad;
		if (ad.load)ad.load();
		else onErr();
	}

	/**
	*播放声音
	*@param startTime 起始时间
	*@param loops 循环次数
	*/
	__proto.play=function(startTime,loops){
		(startTime===void 0)&& (startTime=0);
		(loops===void 0)&& (loops=0);
		if (!this.url)return null;
		var ad;
		ad=AudioSound._audioCache[this.url];
		if (!ad)return null;
		var tAd;
		tAd=Pool.getItem("audio:"+this.url);
		if (Render.isConchApp){
			if (!tAd){
				tAd=Browser.createElement("audio");
				tAd.src=ad.src;
			}
			}else {
			tAd=tAd ? tAd :ad.cloneNode(true);
		};
		var channel=new AudioSoundChannel(tAd);
		channel.url=this.url;
		channel.loops=loops;
		channel.startTime=startTime;
		channel.play();
		SoundManager.addChannel(channel);
		return channel;
	}

	/**
	*获取总时间。
	*/
	__getset(0,__proto,'duration',function(){
		var ad=AudioSound._audioCache[this.url];
		if (!ad)return 0;
		return ad.duration;
	});

	AudioSound._audioCache={};
	return AudioSound;
})(EventDispatcher)


	//file:///E:/git/layaair-master/core/src/laya/media/SoundChannel.as=======98.999892/98.999892
/**
*<p> <code>SoundChannel</code> 用来控制程序中的声音。每个声音均分配给一个声道，而且应用程序可以具有混合在一起的多个声道。</p>
*<p> <code>SoundChannel</code> 类包含控制声音的播放、暂停、停止、音量的方法，以及获取声音的播放状态、总时间、当前播放时间、总循环次数、播放地址等信息的方法。</p>
*/
//class laya.media.SoundChannel extends laya.events.EventDispatcher
var SoundChannel=(function(_super){
	function SoundChannel(){
		/**
		*声音地址。
		*/
		this.url=null;
		/**
		*循环次数。
		*/
		this.loops=0;
		/**
		*播放声音开始时间。
		*/
		this.startTime=NaN;
		/**
		*表示声音是否已暂停。
		*/
		this.isStopped=false;
		/**
		*播放完成处理器。
		*/
		this.completeHandler=null;
		SoundChannel.__super.call(this);
	}

	__class(SoundChannel,'laya.media.SoundChannel',_super);
	var __proto=SoundChannel.prototype;
	/**
	*播放声音。
	*/
	__proto.play=function(){}
	/**
	*停止播放。
	*/
	__proto.stop=function(){}
	/**
	*暂停播放。
	*/
	__proto.pause=function(){}
	/**
	*继续播放。
	*/
	__proto.resume=function(){}
	/**
	*private
	*/
	__proto.__runComplete=function(handler){
		if (handler){
			handler.run();
		}
	}

	/**
	*音量范围从 0（静音）至 1（最大音量）。
	*/
	__getset(0,__proto,'volume',function(){
		return 1;
		},function(v){
	});

	/**
	*获取当前播放时间，单位是秒。
	*/
	__getset(0,__proto,'position',function(){
		return 0;
	});

	/**
	*获取总时间，单位是秒。
	*/
	__getset(0,__proto,'duration',function(){
		return 0;
	});

	return SoundChannel;
})(EventDispatcher)


	//file:///E:/git/layaair-master/core/src/laya/media/Sound.as=======98.999891/98.999891
/**
*<code>Sound</code> 类是用来播放控制声音的类。
*引擎默认有两套声音方案，优先使用WebAudio播放声音，如果WebAudio不可用，则用H5Audio播放，H5Audio在部分机器上有兼容问题（比如不能混音，播放有延迟等）。
*/
//class laya.media.Sound extends laya.events.EventDispatcher
var Sound=(function(_super){
	function Sound(){
		Sound.__super.call(this);;
	}

	__class(Sound,'laya.media.Sound',_super);
	var __proto=Sound.prototype;
	/**
	*加载声音。
	*@param url 地址。
	*/
	__proto.load=function(url){}
	/**
	*播放声音。
	*@param startTime 开始时间,单位秒
	*@param loops 循环次数,0表示一直循环
	*@return 声道 SoundChannel 对象。
	*/
	__proto.play=function(startTime,loops){
		(startTime===void 0)&& (startTime=0);
		(loops===void 0)&& (loops=0);
		return null;
	}

	/**
	*释放声音资源。
	*/
	__proto.dispose=function(){}
	/**
	*获取总时间。
	*/
	__getset(0,__proto,'duration',function(){
		return 0;
	});

	return Sound;
})(EventDispatcher)


	//file:///E:/git/layaair-master/core/src/laya/media/webaudio/WebAudioSound.as=======98.999888/98.999888
/**
*@private
*web audio api方式播放声音
*/
//class laya.media.webaudio.WebAudioSound extends laya.events.EventDispatcher
var WebAudioSound=(function(_super){
	function WebAudioSound(){
		/**
		*声音URL
		*/
		this.url=null;
		/**
		*是否已加载完成
		*/
		this.loaded=false;
		/**
		*声音文件数据
		*/
		this.data=null;
		/**
		*声音原始文件数据
		*/
		this.audioBuffer=null;
		/**
		*待播放的声音列表
		*/
		this.__toPlays=null;
		WebAudioSound.__super.call(this);
	}

	__class(WebAudioSound,'laya.media.webaudio.WebAudioSound',_super);
	var __proto=WebAudioSound.prototype;
	/**
	*加载声音
	*/
	__proto.load=function(url){
		var me=this;
		url=URL.formatURL(url);
		this.url=url;
		this.audioBuffer=WebAudioSound._dataCache[url];
		if (this.audioBuffer){
			this._loaded(this.audioBuffer);
			return;
		}
		WebAudioSound.e.on("loaded:"+url,this,this._loaded);
		WebAudioSound.e.on("err:"+url,this,this._err);
		if (WebAudioSound.__loadingSound[url])return;
		WebAudioSound.__loadingSound[url]=true;
		var request=new Browser.window.XMLHttpRequest();
		request.open("GET",url,true);
		request.responseType="arraybuffer";
		request.onload=function (){
			me.data=request.response;
			WebAudioSound.buffs.push({"buffer":me.data,"url":me.url});
			WebAudioSound.decode();
		}
		request.onerror=function (e){
			me._err();
		}
		request.send();
	}

	__proto._err=function(){
		this._removeLoadEvents();
		WebAudioSound.__loadingSound[this.url]=false;
		this.event("error");
	}

	__proto._loaded=function(audioBuffer){
		this._removeLoadEvents();
		this.audioBuffer=audioBuffer;
		WebAudioSound._dataCache[this.url]=this.audioBuffer;
		this.loaded=true;
		this.event("complete");
	}

	__proto._removeLoadEvents=function(){
		WebAudioSound.e.off("loaded:"+this.url,this,this._loaded);
		WebAudioSound.e.off("err:"+this.url,this,this._err);
	}

	__proto.__playAfterLoaded=function(){
		if (!this.__toPlays)return;
		var i=0,len=0;
		var toPlays;
		toPlays=this.__toPlays;
		len=toPlays.length;
		var tParams;
		for (i=0;i < len;i++){
			tParams=toPlays[i];
			if (tParams[2] && !(tParams [2]).isStopped){
				this.play(tParams[0],tParams[1],tParams[2]);
			}
		}
		this.__toPlays.length=0;
	}

	/**
	*播放声音
	*@param startTime 起始时间
	*@param loops 循环次数
	*/
	__proto.play=function(startTime,loops,channel){
		(startTime===void 0)&& (startTime=0);
		(loops===void 0)&& (loops=0);
		channel=channel ? channel :new WebAudioSoundChannel();
		if (!this.audioBuffer){
			if (this.url){
				if (!this.__toPlays)this.__toPlays=[];
				this.__toPlays.push([startTime,loops,channel]);
				this.once("complete",this,this.__playAfterLoaded);
				this.load(this.url);
			}
		}
		channel.url=this.url;
		channel.loops=loops;
		channel["audioBuffer"]=this.audioBuffer;
		channel.startTime=startTime;
		channel.play();
		SoundManager.addChannel(channel);
		return channel;
	}

	__proto.dispose=function(){
		delete WebAudioSound._dataCache[this.url];
		delete WebAudioSound.__loadingSound[this.url];
	}

	__getset(0,__proto,'duration',function(){
		if (this.audioBuffer){
			return this.audioBuffer.duration;
		}
		return 0;
	});

	WebAudioSound.decode=function(){
		if (WebAudioSound.buffs.length <=0 || WebAudioSound.isDecoding){
			return;
		}
		WebAudioSound.isDecoding=true;
		WebAudioSound.tInfo=WebAudioSound.buffs.shift();
		WebAudioSound.ctx.decodeAudioData(WebAudioSound.tInfo["buffer"],WebAudioSound._done,WebAudioSound._fail);
	}

	WebAudioSound._done=function(audioBuffer){
		WebAudioSound.e.event("loaded:"+WebAudioSound.tInfo.url,audioBuffer);
		WebAudioSound.isDecoding=false;
		WebAudioSound.decode();
	}

	WebAudioSound._fail=function(){
		WebAudioSound.e.event("err:"+WebAudioSound.tInfo.url,null);
		WebAudioSound.isDecoding=false;
		WebAudioSound.decode();
	}

	WebAudioSound._playEmptySound=function(){
		if (WebAudioSound.ctx==null)return;
		var source=WebAudioSound.ctx.createBufferSource();
		source.buffer=WebAudioSound._miniBuffer;
		source.connect(WebAudioSound.ctx.destination);
		source.start(0,0,0);
	}

	WebAudioSound._unlock=function(){
		if (WebAudioSound._unlocked)return;
		WebAudioSound._playEmptySound();
		if (WebAudioSound.ctx.state==="running"){
			Browser.document.removeEventListener("mousedown",WebAudioSound._unlock,true);
			Browser.document.removeEventListener("touchend",WebAudioSound._unlock,true);
			WebAudioSound._unlocked=true;
		}
	}

	WebAudioSound.initWebAudio=function(){
		if (WebAudioSound.ctx.state!=="running"){
			WebAudioSound._unlock();
			Browser.document.addEventListener("mousedown",WebAudioSound._unlock,true);
			Browser.document.addEventListener("touchend",WebAudioSound._unlock,true);
		}
	}

	WebAudioSound._dataCache={};
	WebAudioSound.buffs=[];
	WebAudioSound.isDecoding=false;
	WebAudioSound._unlocked=false;
	WebAudioSound.tInfo=null;
	WebAudioSound.__loadingSound={};
	__static(WebAudioSound,
	['window',function(){return this.window=Browser.window;},'webAudioEnabled',function(){return this.webAudioEnabled=WebAudioSound.window["AudioContext"] || WebAudioSound.window["webkitAudioContext"] || WebAudioSound.window["mozAudioContext"];},'ctx',function(){return this.ctx=WebAudioSound.webAudioEnabled ? new (WebAudioSound.window["AudioContext"] || WebAudioSound.window["webkitAudioContext"] || WebAudioSound.window["mozAudioContext"])():undefined;},'_miniBuffer',function(){return this._miniBuffer=WebAudioSound.ctx.createBuffer(1,1,22050);},'e',function(){return this.e=new EventDispatcher();}
	]);
	return WebAudioSound;
})(EventDispatcher)


	//file:///E:/git/layaair-master/core/src/laya/net/HttpRequest.as=======98.999886/98.999886
/**
*<p> <code>HttpRequest</code> 通过封装 HTML <code>XMLHttpRequest</code> 对象提供了对 HTTP 协议的完全的访问，包括做出 POST 和 HEAD 请求以及普通的 GET 请求的能力。 <code>HttpRequest</code> 只提供以异步的形式返回 Web 服务器的响应，并且能够以文本或者二进制的形式返回内容。</p>
*<p><b>注意：</b>建议每次请求都使用新的 <code>HttpRequest</code> 对象，因为每次调用该对象的send方法时，都会清空之前设置的数据，并重置 HTTP 请求的状态，这会导致之前还未返回响应的请求被重置，从而得不到之前请求的响应结果。
*/
//class laya.net.HttpRequest extends laya.events.EventDispatcher
var HttpRequest=(function(_super){
	function HttpRequest(){
		/**@private */
		this._responseType=null;
		/**@private */
		this._data=null;
		HttpRequest.__super.call(this);
		this._http=new Browser.window.XMLHttpRequest();
	}

	__class(HttpRequest,'laya.net.HttpRequest',_super);
	var __proto=HttpRequest.prototype;
	/**
	*发送 HTTP 请求。
	*@param url 请求的地址。大多数浏览器实施了一个同源安全策略，并且要求这个 URL 与包含脚本的文本具有相同的主机名和端口。
	*@param data (default=null)发送的数据。
	*@param method (default="get")用于请求的 HTTP 方法。值包括 "get"、"post"、"head"。
	*@param responseType (default="text")Web 服务器的响应类型，可设置为 "text"、"json"、"xml"、"arraybuffer"。
	*@param headers (default=null)HTTP 请求的头部信息。参数形如key-value数组：key是头部的名称，不应该包括空白、冒号或换行；value是头部的值，不应该包括换行。比如["Content-Type","application/json"]。
	*/
	__proto.send=function(url,data,method,responseType,headers){
		(method===void 0)&& (method="get");
		(responseType===void 0)&& (responseType="text");
		this._responseType=responseType;
		this._data=null;
		var _this=this;
		var http=this._http;
		http.open(method,url,true);
		if (headers){
			for (var i=0;i < headers.length;i++){
				http.setRequestHeader(headers[i++],headers[i]);
			}
			}else if (!Render.isConchApp){
			if (!data || (typeof data=='string'))http.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
			else http.setRequestHeader("Content-Type","application/json");
		}
		http.responseType=responseType!=="arraybuffer" ? "text" :"arraybuffer";
		http.onerror=function (e){
			_this._onError(e);
		}
		http.onabort=function (e){
			_this._onAbort(e);
		}
		http.onprogress=function (e){
			_this._onProgress(e);
		}
		http.onload=function (e){
			_this._onLoad(e);
		}
		http.send(data);
	}

	/**
	*@private
	*请求进度的侦听处理函数。
	*@param e 事件对象。
	*/
	__proto._onProgress=function(e){
		if (e && e.lengthComputable)this.event("progress",e.loaded / e.total);
	}

	/**
	*@private
	*请求中断的侦听处理函数。
	*@param e 事件对象。
	*/
	__proto._onAbort=function(e){
		this.error("Request was aborted by user");
	}

	/**
	*@private
	*请求出错侦的听处理函数。
	*@param e 事件对象。
	*/
	__proto._onError=function(e){
		this.error("Request failed Status:"+this._http.status+" text:"+this._http.statusText);
	}

	/**
	*@private
	*请求消息返回的侦听处理函数。
	*@param e 事件对象。
	*/
	__proto._onLoad=function(e){
		var http=this._http;
		var status=http.status!==undefined ? http.status :200;
		if (status===200 || status===204 || status===0){
			this.complete();
			}else {
			this.error("["+http.status+"]"+http.statusText+":"+http.responseURL);
		}
	}

	/**
	*@private
	*请求错误的处理函数。
	*@param message 错误信息。
	*/
	__proto.error=function(message){
		this.clear();
		this.event("error",message);
	}

	/**
	*@private
	*请求成功完成的处理函数。
	*/
	__proto.complete=function(){
		this.clear();
		var flag=true;
		try {
			if (this._responseType==="json"){
				this._data=JSON.parse(this._http.responseText);
				}else if (this._responseType==="xml"){
				this._data=Utils.parseXMLFromString(this._http.responseText);
				}else {
				this._data=this._http.response || this._http.responseText;
			}
			}catch (e){
			flag=false;
			this.error(e.message);
		}
		flag && this.event("complete",(this._data instanceof Array)? [this._data] :this._data);
	}

	/**
	*@private
	*清除当前请求。
	*/
	__proto.clear=function(){
		var http=this._http;
		http.onerror=http.onabort=http.onprogress=http.onload=null;
	}

	/**请求的地址。*/
	__getset(0,__proto,'url',function(){
		return this._http.responseURL;
	});

	/**
	*本对象所封装的原生 XMLHttpRequest 引用。
	*/
	__getset(0,__proto,'http',function(){
		return this._http;
	});

	/**返回的数据。*/
	__getset(0,__proto,'data',function(){
		return this._data;
	});

	return HttpRequest;
})(EventDispatcher)


	//file:///E:/git/layaair-master/core/src/laya/net/Loader.as=======98.999885/98.999885
/**
*<code>Loader</code> 类可用来加载文本、JSON、XML、二进制、图像等资源。
*/
//class laya.net.Loader extends laya.events.EventDispatcher
var Loader=(function(_super){
	function Loader(){
		/**@private 加载后的数据对象，只读*/
		this._data=null;
		/**@private */
		this._class=null;
		/**@private */
		this._url=null;
		/**@private */
		this._type=null;
		/**@private */
		this._cache=false;
		/**@private */
		this._http=null;
		/**@private */
		this._useWorkerLoader=false;
		/**@private 自定义解析不派发complete事件，但会派发loaded事件，手动调用endLoad方法再派发complete事件*/
		this._customParse=false;
		Loader.__super.call(this);
	}

	__class(Loader,'laya.net.Loader',_super);
	var __proto=Loader.prototype;
	/**
	*加载资源。加载错误会派发 Event.ERROR 事件，参数为错误信息。
	*@param url 资源地址。
	*@param type (default=null)资源类型。可选值为：Loader.TEXT、Loader.JSON、Loader.XML、Loader.BUFFER、Loader.IMAGE、Loader.SOUND、Loader.ATLAS、Loader.FONT。如果为null，则根据文件后缀分析类型。
	*@param cache (default=true)是否缓存数据。
	*@param group (default=null)分组名称。
	*@param ignoreCache (default=false)是否忽略缓存，强制重新加载。
	*@param useWorkerLoader(default=false)是否使用worker加载（只针对IMAGE类型和ATLAS类型，并且浏览器支持的情况下生效）
	*/
	__proto.load=function(url,type,cache,group,ignoreCache,useWorkerLoader){
		(cache===void 0)&& (cache=true);
		(ignoreCache===void 0)&& (ignoreCache=false);
		(useWorkerLoader===void 0)&& (useWorkerLoader=false);
		this._url=url;
		if (url.indexOf("data:image")===0)type="image";
		else url=URL.formatURL(url);
		this._type=type || (type=this.getTypeFromUrl(url));
		this._cache=cache;
		this._useWorkerLoader=useWorkerLoader;
		this._data=null;
		if (useWorkerLoader)WorkerLoader.enableWorkerLoader();
		if (!ignoreCache && Loader.loadedMap[url]){
			this._data=Loader.loadedMap[url];
			this.event("progress",1);
			this.event("complete",this._data);
			return;
		}
		if (group)Loader.setGroup(url,group);
		if (Loader.parserMap[type] !=null){
			this._customParse=true;
			if (((Loader.parserMap[type])instanceof laya.utils.Handler ))Loader.parserMap[type].runWith(this);
			else Loader.parserMap[type].call(null,this);
			return;
		}
		if (type==="image" || type==="htmlimage" || type==="nativeimage")return this._loadImage(url);
		if (type==="sound")return this._loadSound(url);
		if (type==="atlas"){
			if (Loader._preLoadedAtlasMap[url]){
				this.onLoaded(Loader._preLoadedAtlasMap[url]);
				delete Loader._preLoadedAtlasMap[url];
				return;
			}
		}
		if (!this._http){
			this._http=new HttpRequest();
			this._http.on("progress",this,this.onProgress);
			this._http.on("error",this,this.onError);
			this._http.on("complete",this,this.onLoaded);
		};
		var contentType;
		switch (type){
			case "atlas":
				contentType="json";
				break ;
			case "font":
				contentType="xml";
				break ;
			case "pkm":
				contentType="arraybuffer";
				break
			default :
				contentType=type;
			}
		this._http.send(url,null,"get",contentType);
	}

	/**
	*获取指定资源地址的数据类型。
	*@param url 资源地址。
	*@return 数据类型。
	*/
	__proto.getTypeFromUrl=function(url){
		var type=Utils.getFileExtension(url);
		if (type)return Loader.typeMap[type];
		console.warn("Not recognize the resources suffix",url);
		return "text";
	}

	/**
	*@private
	*加载图片资源。
	*@param url 资源地址。
	*/
	__proto._loadImage=function(url){
		var _$this=this;
		url=URL.formatURL(url);
		var _this=this;
		var image;
		function clear (){
			image.onload=null;
			image.onerror=null;
			delete Loader._imgCache[url]
		};
		var onload=function (){
			(_$this._type==="nativeimage")||(image.setImageSource(imageSource,true));
			clear();
			_this.onLoaded(image);
		};
		var onerror=function (){
			clear();
			_this.event("error","Load image failed");
		}
		if (this._type==="nativeimage"){
			image=new Browser.window.Image();
			image.crossOrigin="";
			image.onload=onload;
			image.onerror=onerror;
			image.src=url;
			Loader._imgCache[url]=image;
			}else {
			image=HTMLImage.create(url);
			var imageSource=new Browser.window.Image();
			imageSource.crossOrigin="";
			imageSource.onload=onload;
			imageSource.onerror=onerror;
			imageSource.src=url;
			image._setUrl(url);
			Loader._imgCache[url]=image;
		}
	}

	/**
	*@private
	*加载声音资源。
	*@param url 资源地址。
	*/
	__proto._loadSound=function(url){
		var sound=(new SoundManager._soundClass());
		var _this=this;
		sound.on("complete",this,soundOnload);
		sound.on("error",this,soundOnErr);
		sound.load(url);
		function soundOnload (){
			clear();
			_this.onLoaded(sound);
		}
		function soundOnErr (){
			clear();
			sound.dispose();
			_this.event("error","Load sound failed");
		}
		function clear (){
			sound.offAll();
		}
	}

	/**@private */
	__proto.onProgress=function(value){
		if (this._type==="atlas")this.event("progress",value *0.3);
		else this.event("progress",value);
	}

	/**@private */
	__proto.onError=function(message){
		this.event("error",message);
	}

	/**
	*资源加载完成的处理函数。
	*@param data 数据。
	*/
	__proto.onLoaded=function(data){
		var type=this._type;
		if (type==="image"){
			var tex=new Texture(data);
			tex.url=this._url;
			this.complete(tex);
			}else if (type==="sound" || type==="htmlimage" || type==="nativeimage"){
			this.complete(data);
			}else if (type==="atlas"){
			if (!data.url && !data._setContext){
				if (!this._data){
					this._data=data;
					if (data.meta && data.meta.image){
						var toloadPics=data.meta.image.split(",");
						var split=this._url.indexOf("/")>=0 ? "/" :"\\";
						var idx=this._url.lastIndexOf(split);
						var folderPath=idx >=0 ? this._url.substr(0,idx+1):"";
						for (var i=0,len=toloadPics.length;i < len;i++){
							toloadPics[i]=folderPath+toloadPics[i];
						}
						}else {
						toloadPics=[this._url.replace(".json",".png")];
					}
					toloadPics.reverse();
					data.toLoads=toloadPics;
					data.pics=[];
				}
				this.event("progress",0.3+1 / toloadPics.length *0.6);
				return this._loadImage(toloadPics.pop());
				}else {
				this._data.pics.push(data);
				if (this._data.toLoads.length > 0){
					this.event("progress",0.3+1 / this._data.toLoads.length *0.6);
					return this._loadImage(this._data.toLoads.pop());
				};
				var frames=this._data.frames;
				var cleanUrl=this._url.split("?")[0];
				var directory=(this._data.meta && this._data.meta.prefix)? this._data.meta.prefix :cleanUrl.substring(0,cleanUrl.lastIndexOf("."))+"/";
				var pics=this._data.pics;
				var atlasURL=URL.formatURL(this._url);
				var map=Loader.atlasMap[atlasURL] || (Loader.atlasMap[atlasURL]=[]);
				map.dir=directory;
				for (var name in frames){
					var obj=frames[name];
					var tPic=pics[obj.frame.idx ? obj.frame.idx :0];
					var url=URL.formatURL(directory+name);
					Loader.cacheRes(url,Texture.create(tPic,obj.frame.x,obj.frame.y,obj.frame.w,obj.frame.h,obj.spriteSourceSize.x,obj.spriteSourceSize.y,obj.sourceSize.w,obj.sourceSize.h));
					Loader.loadedMap[url].url=url;
					map.push(url);
				}
				delete this._data.pics;
				this.complete(this._data);
			}
			}else if (type==="font"){
			if (!data.src){
				this._data=data;
				this.event("progress",0.5);
				return this._loadImage(this._url.replace(".fnt",".png"));
				}else {
				var bFont=new BitmapFont();
				bFont.parseFont(this._data,data);
				var tArr=this._url.split(".fnt")[0].split("/");
				var fontName=tArr[tArr.length-1];
				Text.registerBitmapFont(fontName,bFont);
				this._data=bFont;
				this.complete(this._data);
			}
			}else if (type=="pkm"){
			var image=HTMLImage.create(data,this._url);
			var tex1=new Texture(image);
			tex1.url=this._url;
			this.complete(tex1);
			}else {
			this.complete(data);
		}
	}

	/**
	*加载完成。
	*@param data 加载的数据。
	*/
	__proto.complete=function(data){
		this._data=data;
		if (this._customParse){
			this.event("loaded",(data instanceof Array)? [data] :data);
			}else {
			Loader._loaders.push(this);
			if (!Loader._isWorking)Loader.checkNext();
		}
	}

	/**
	*结束加载，处理是否缓存及派发完成事件 <code>Event.COMPLETE</code> 。
	*@param content 加载后的数据
	*/
	__proto.endLoad=function(content){
		content && (this._data=content);
		if (this._cache)Loader.cacheRes(this._url,this._data);
		this._customParse=false;
		this.event("progress",1);
		this.event("complete",(this.data instanceof Array)? [this.data] :this.data);
	}

	/**加载地址。*/
	__getset(0,__proto,'url',function(){
		return this._url;
	});

	/**返回的数据。*/
	__getset(0,__proto,'data',function(){
		return this._data;
	});

	/**是否缓存。*/
	__getset(0,__proto,'cache',function(){
		return this._cache;
	});

	/**加载类型。*/
	__getset(0,__proto,'type',function(){
		return this._type;
	});

	Loader.checkNext=function(){
		Loader._isWorking=true;
		var startTimer=Browser.now();
		var thisTimer=startTimer;
		while (Loader._startIndex < Loader._loaders.length){
			thisTimer=Browser.now();
			Loader._loaders[Loader._startIndex].endLoad();
			Loader._startIndex++;
			if (Browser.now()-startTimer > Loader.maxTimeOut){
				console.warn("loader callback cost a long time:"+(Browser.now()-startTimer)+" url="+Loader._loaders[Loader._startIndex-1].url);
				Laya.timer.frameOnce(1,null,Loader.checkNext);
				return;
			}
		}
		Loader._loaders.length=0;
		Loader._startIndex=0;
		Loader._isWorking=false;
	}

	Loader.clearRes=function(url,forceDispose){
		(forceDispose===void 0)&& (forceDispose=false);
		url=URL.formatURL(url);
		var arr=Loader.getAtlas(url);
		if (arr){
			for (var i=0,n=arr.length;i < n;i++){
				var resUrl=arr[i];
				var tex=Loader.getRes(resUrl);
				if (tex)tex.destroy(forceDispose);
				delete Loader.loadedMap[resUrl];
			}
			arr.length=0;
			delete Loader.atlasMap[url];
			delete Loader.loadedMap[url];
			}else {
			var res=Loader.loadedMap[url];
			if (res){
				if ((res instanceof laya.resource.Texture )&& res.bitmap)(res).destroy(forceDispose);
				delete Loader.loadedMap[url];
			}
		}
	}

	Loader.setAtlasConfigs=function(url,config){
		Loader._preLoadedAtlasMap[URL.formatURL(url)]=config;
	}

	Loader.getRes=function(url){
		return Loader.loadedMap[URL.formatURL(url)];
	}

	Loader.getAtlas=function(url){
		return Loader.atlasMap[URL.formatURL(url)];
	}

	Loader.cacheRes=function(url,data){
		url=URL.formatURL(url);
		if (Loader.loadedMap[url] !=null){
			console.warn("Resources already exist,is repeated loading:",url);
			}else {
			Loader.loadedMap[url]=data;
		}
	}

	Loader.setGroup=function(url,group){
		if (!Loader.groupMap[group])Loader.groupMap[group]=[];
		Loader.groupMap[group].push(url);
	}

	Loader.clearResByGroup=function(group){
		if (!Loader.groupMap[group])return;
		var arr=Loader.groupMap[group],i=0,len=arr.length;
		for (i=0;i < len;i++){
			Loader.clearRes(arr[i]);
		}
		arr.length=0;
	}

	Loader.TEXT="text";
	Loader.JSON="json";
	Loader.XML="xml";
	Loader.BUFFER="arraybuffer";
	Loader.IMAGE="image";
	Loader.SOUND="sound";
	Loader.ATLAS="atlas";
	Loader.FONT="font";
	Loader.PKM="pkm";
	Loader.typeMap={"png":"image","jpg":"image","jpeg":"image","txt":"text","json":"json","xml":"xml","als":"atlas","atlas":"atlas","mp3":"sound","ogg":"sound","wav":"sound","part":"json","fnt":"font","pkm":"pkm"};
	Loader.parserMap={};
	Loader.maxTimeOut=100;
	Loader.groupMap={};
	Loader.loadedMap={};
	Loader.atlasMap={};
	Loader._preLoadedAtlasMap={};
	Loader._imgCache={};
	Loader._loaders=[];
	Loader._isWorking=false;
	Loader._startIndex=0;
	return Loader;
})(EventDispatcher)


	//file:///E:/git/layaair-master/core/src/laya/net/LoaderManager.as=======98.999884/98.999884
/**
*<p> <code>LoaderManager</code> 类用于用于批量加载资源。此类是单例，不要手动实例化此类，请通过Laya.loader访问。</p>
*<p>全部队列加载完成，会派发 Event.COMPLETE 事件；如果队列中任意一个加载失败，会派发 Event.ERROR 事件，事件回调参数值为加载出错的资源地址。</p>
*<p> <code>LoaderManager</code> 类提供了以下几种功能：<br/>
*多线程：默认5个加载线程，可以通过maxLoader属性修改线程数量；<br/>
*多优先级：有0-4共5个优先级，优先级高的优先加载。0最高，4最低；<br/>
*重复过滤：自动过滤重复加载（不会有多个相同地址的资源同时加载）以及复用缓存资源，防止重复加载；<br/>
*错误重试：资源加载失败后，会重试加载（以最低优先级插入加载队列），retryNum设定加载失败后重试次数，retryDelay设定加载重试的时间间隔。</p>
*@see laya.net.Loader
*/
//class laya.net.LoaderManager extends laya.events.EventDispatcher
var LoaderManager=(function(_super){
	var ResInfo;
	function LoaderManager(){
		/**加载出错后的重试次数，默认重试一次*/
		this.retryNum=1;
		/**延迟时间多久再进行错误重试，默认立即重试*/
		this.retryDelay=0;
		/**最大下载线程，默认为5个*/
		this.maxLoader=5;
		/**@private */
		this._loaders=[];
		/**@private */
		this._loaderCount=0;
		/**@private */
		this._resInfos=[];
		/**@private */
		this._infoPool=[];
		/**@private */
		this._maxPriority=5;
		/**@private */
		this._failRes={};
		LoaderManager.__super.call(this);
		for (var i=0;i < this._maxPriority;i++)this._resInfos[i]=[];
	}

	__class(LoaderManager,'laya.net.LoaderManager',_super);
	var __proto=LoaderManager.prototype;
	/**
	*<p>根据clas类型创建一个未初始化资源的对象，随后进行异步加载，资源加载完成后，初始化对象的资源，并通过此对象派发 Event.LOADED 事件，事件回调参数值为此对象本身。套嵌资源的子资源会保留资源路径"?"后的部分。</p>
	*<p>如果url为数组，返回true；否则返回指定的资源类对象，可以通过侦听此对象的 Event.LOADED 事件来判断资源是否已经加载完毕。</p>
	*<p><b>注意：</b>cache参数只能对文件后缀为atlas的资源进行缓存控制，其他资源会忽略缓存，强制重新加载。</p>
	*@param url 资源地址或者数组。如果url和clas同时指定了资源类型，优先使用url指定的资源类型。参数形如：[{url:xx,clas:xx,priority:xx,params:xx},{url:xx,clas:xx,priority:xx,params:xx}]。
	*@param complete 加载结束回调。根据url类型不同分为2种情况：1. url为String类型，也就是单个资源地址，如果加载成功，则回调参数值为加载完成的资源，否则为null；2. url为数组类型，指定了一组要加载的资源，如果全部加载成功，则回调参数值为true，否则为false。
	*@param progress 资源加载进度回调，回调参数值为当前资源加载的进度信息(0-1)。
	*@param clas 资源类名。如果url和clas同时指定了资源类型，优先使用url指定的资源类型。参数形如：Texture。
	*@param params 资源构造参数。
	*@param priority (default=1)加载的优先级，优先级高的优先加载。有0-4共5个优先级，0最高，4最低。
	*@param cache 是否缓存加载的资源。
	*@return 如果url为数组，返回true；否则返回指定的资源类对象。
	*/
	__proto.create=function(url,complete,progress,clas,params,priority,cache,group){
		(priority===void 0)&& (priority=1);
		(cache===void 0)&& (cache=true);
		if ((url instanceof Array)){
			var items=url;
			var itemCount=items.length;
			var loadedCount=0;
			if (progress){
				var progress2=Handler.create(progress.caller,progress.method,progress.args,false);
			}
			for (var i=0;i < itemCount;i++){
				var item=items[i];
				if ((typeof item=='string'))item=items[i]={url:item};
				item.progress=0;
				var progressHandler=progress ? Handler.create(null,onProgress,[item],false):null;
				var completeHandler=(progress || complete)? Handler.create(null,onComplete,[item]):null;
				this._create(item.url,completeHandler,progressHandler,item.clas || clas,item.params || params,item.priority || priority,cache,item.group || group);
			}
			function onComplete (item,content){
				loadedCount++;
				item.progress=1;
				if (loadedCount===itemCount && complete){
					complete.run();
				}
			}
			function onProgress (item,value){
				item.progress=value;
				var num=0;
				for (var j=0;j < itemCount;j++){
					var item1=items[j];
					num+=item1.progress;
				};
				var v=num / itemCount;
				progress2.runWith(v);
			}
			return true;
		}else return this._create(url,complete,progress,clas,params,priority,cache,group);
	}

	__proto._create=function(url,complete,progress,clas,params,priority,cache,group){
		(priority===void 0)&& (priority=1);
		(cache===void 0)&& (cache=true);
		var formarUrl=URL.formatURL(url);
		var item=this.getRes(formarUrl);
		if (!item){
			var extension=Utils.getFileExtension(url);
			var creatItem=LoaderManager.createMap[extension];
			if (!creatItem)
				throw new Error("LoaderManager:unknown file("+url+") extension with: "+extension+".");
			if (!clas)clas=creatItem[0];
			var type=creatItem[1];
			if (extension=="atlas"){
				this.load(url,complete,progress,type,priority,cache);
				}else {
				if (clas===Texture)type="htmlimage";
				item=clas ? new clas():null;
				if (item.hasOwnProperty("_loaded"))
					item._loaded=false;
				item._setUrl(url);
				(group)&& (item._setGroup(group));
				this._createLoad(item,url,Handler.create(null,onLoaded),progress,type,priority,false,group,true);
				function onLoaded (data){
					if (item && !item.destroyed && data){
						item.onAsynLoaded.call(item,data,params);
						item._completeLoad();
					}
					if (complete)complete.run();
					Laya.loader.event(url);
				}
				(cache)&& (this.cacheRes(formarUrl,item));
			}
			}else {
			if (!item.hasOwnProperty("loaded")|| item.loaded){
				progress && progress.runWith(1);
				complete && complete.run();
				}else if (complete){
				Laya.loader._createListener(url,complete.caller,complete.method,complete.args,true,false);
			}
		}
		return item;
	}

	/**
	*<p>加载资源。资源加载错误时，本对象会派发 Event.ERROR 事件，事件回调参数值为加载出错的资源地址。</p>
	*<p>因为返回值为 LoaderManager 对象本身，所以可以使用如下语法：loaderManager.load(...).load(...);</p>
	*@param url 要加载的单个资源地址或资源信息数组。比如：简单数组：["a.png","b.png"]；复杂数组[{url:"a.png",type:Loader.IMAGE,size:100,priority:1},{url:"b.json",type:Loader.JSON,size:50,priority:1}]。
	*@param complete 加载结束回调。根据url类型不同分为2种情况：1. url为String类型，也就是单个资源地址，如果加载成功，则回调参数值为加载完成的资源，否则为null；2. url为数组类型，指定了一组要加载的资源，如果全部加载成功，则回调参数值为true，否则为false。
	*@param progress 加载进度回调。回调参数值为当前资源的加载进度信息(0-1)。
	*@param type 资源类型。比如：Loader.IMAGE。
	*@param priority (default=1)加载的优先级，优先级高的优先加载。有0-4共5个优先级，0最高，4最低。
	*@param cache 是否缓存加载结果。
	*@param group 分组，方便对资源进行管理。
	*@param ignoreCache 是否忽略缓存，强制重新加载。
	*@param useWorkerLoader(default=false)是否使用worker加载（只针对IMAGE类型和ATLAS类型，并且浏览器支持的情况下生效）
	*@return 此 LoaderManager 对象本身。
	*/
	__proto.load=function(url,complete,progress,type,priority,cache,group,ignoreCache,useWorkerLoader){
		var _$this=this;
		(priority===void 0)&& (priority=1);
		(cache===void 0)&& (cache=true);
		(ignoreCache===void 0)&& (ignoreCache=false);
		(useWorkerLoader===void 0)&& (useWorkerLoader=false);
		if ((url instanceof Array))return this._loadAssets(url,complete,progress,type,priority,cache,group);
		var content=Loader.getRes(url);
		if (!ignoreCache && content !=null){
			Laya.timer.frameOnce(1,null,function(){
				progress && progress.runWith(1);
				complete && complete.runWith(content);
				_$this._loaderCount || _$this.event("complete");
			});
			}else {
			var info=LoaderManager._resMap[url];
			if (!info){
				info=this._infoPool.length ? this._infoPool.pop():new ResInfo();
				info.url=url;
				info.type=type;
				info.cache=cache;
				info.group=group;
				info.ignoreCache=ignoreCache;
				info.useWorkerLoader=useWorkerLoader;
				complete && info.on("complete",complete.caller,complete.method,complete.args);
				progress && info.on("progress",progress.caller,progress.method,progress.args);
				LoaderManager._resMap[url]=info;
				priority=priority < this._maxPriority ? priority :this._maxPriority-1;
				this._resInfos[priority].push(info);
				this._next();
				}else {
				complete && info._createListener("complete",complete.caller,complete.method,complete.args,false,false);
				progress && info._createListener("progress",progress.caller,progress.method,progress.args,false,false);
			}
		}
		return this;
	}

	/**
	*@private
	*/
	__proto._createLoad=function(item,url,complete,progress,type,priority,cache,group,ignoreCache){
		var _$this=this;
		(priority===void 0)&& (priority=1);
		(cache===void 0)&& (cache=true);
		(ignoreCache===void 0)&& (ignoreCache=false);
		if ((url instanceof Array))return this._loadAssets(url,complete,progress,type,priority,cache,group);
		var content=Loader.getRes(url);
		if (content !=null){
			Laya.timer.frameOnce(1,null,function(){
				progress && progress.runWith(1);
				complete && complete.runWith(content);
				_$this._loaderCount || _$this.event("complete");
			});
			}else {
			var info=LoaderManager._resMap[url];
			if (!info){
				info=this._infoPool.length ? this._infoPool.pop():new ResInfo();
				info.url=url;
				info.clas=item;
				info.type=type;
				info.cache=cache;
				info.group=group;
				info.ignoreCache=ignoreCache;
				complete && info.on("complete",complete.caller,complete.method,complete.args);
				progress && info.on("progress",progress.caller,progress.method,progress.args);
				LoaderManager._resMap[url]=info;
				priority=priority < this._maxPriority ? priority :this._maxPriority-1;
				this._resInfos[priority].push(info);
				this._next();
				}else {
				complete && info._createListener("complete",complete.caller,complete.method,complete.args,false,false);
				progress && info._createListener("progress",progress.caller,progress.method,progress.args,false,false);
			}
		}
		return this;
	}

	__proto._next=function(){
		if (this._loaderCount >=this.maxLoader)return;
		for (var i=0;i < this._maxPriority;i++){
			var infos=this._resInfos[i];
			if (infos.length > 0){
				var info=infos.shift();
				if (info)return this._doLoad(info);
			}
		}
		this._loaderCount || this.event("complete");
	}

	__proto._doLoad=function(resInfo){
		this._loaderCount++;
		var loader=this._loaders.length ? this._loaders.pop():new Loader();
		loader.on("complete",null,onLoaded);
		loader.on("progress",null,function(num){
			resInfo.event("progress",num);
		});
		loader.on("error",null,function(msg){
			onLoaded(null);
		});
		var _this=this;
		function onLoaded (data){
			loader.offAll();
			loader._data=null;
			_this._loaders.push(loader);
			_this._endLoad(resInfo,(data instanceof Array)? [data] :data);
			_this._loaderCount--;
			_this._next();
		}
		loader._class=resInfo.clas;
		loader.load(resInfo.url,resInfo.type,resInfo.cache,resInfo.group,resInfo.ignoreCache,resInfo.useWorkerLoader);
	}

	__proto._endLoad=function(resInfo,content){
		var url=resInfo.url;
		if (content==null){
			var errorCount=this._failRes[url] || 0;
			if (errorCount < this.retryNum){
				console.warn("[warn]Retry to load:",url);
				this._failRes[url]=errorCount+1;
				Laya.timer.once(this.retryDelay,this,this._addReTry,[resInfo],false);
				return;
				}else {
				console.warn("[error]Failed to load:",url);
				this.event("error",url);
			}
		}
		if (this._failRes[url])this._failRes[url]=0;
		delete LoaderManager._resMap[url];
		resInfo.event("complete",content);
		resInfo.offAll();
		this._infoPool.push(resInfo);
	}

	__proto._addReTry=function(resInfo){
		this._resInfos[this._maxPriority-1].push(resInfo);
		this._next();
	}

	/**
	*清理指定资源地址缓存。
	*@param url 资源地址。
	*@param forceDispose 是否强制销毁，有些资源是采用引用计数方式销毁，如果forceDispose=true，则忽略引用计数，直接销毁，比如Texture，默认为false
	*/
	__proto.clearRes=function(url,forceDispose){
		(forceDispose===void 0)&& (forceDispose=false);
		Loader.clearRes(url,forceDispose);
	}

	/**
	*获取指定资源地址的资源。
	*@param url 资源地址。
	*@return 返回资源。
	*/
	__proto.getRes=function(url){
		return Loader.getRes(url);
	}

	/**
	*缓存资源。
	*@param url 资源地址。
	*@param data 要缓存的内容。
	*/
	__proto.cacheRes=function(url,data){
		Loader.cacheRes(url,data);
	}

	/**
	*设置资源分组。
	*@param url 资源地址。
	*@param group 分组名
	*/
	__proto.setGroup=function(url,group){
		Loader.setGroup(url,group);
	}

	/**
	*根据分组清理资源。
	*@param group 分组名
	*/
	__proto.clearResByGroup=function(group){
		Loader.clearResByGroup(group);
	}

	/**清理当前未完成的加载，所有未加载的内容全部停止加载。*/
	__proto.clearUnLoaded=function(){
		for (var i=0;i < this._maxPriority;i++){
			var infos=this._resInfos[i];
			for (var j=infos.length-1;j >-1;j--){
				var info=infos[j];
				if (info){
					info.offAll();
					this._infoPool.push(info);
				}
			}
			infos.length=0;
		}
		this._loaderCount=0;
		LoaderManager._resMap={};
	}

	/**
	*根据地址集合清理掉未加载的内容
	*@param urls 资源地址集合
	*/
	__proto.cancelLoadByUrls=function(urls){
		if (!urls)return;
		for (var i=0,n=urls.length;i < n;i++){
			this.cancelLoadByUrl(urls[i]);
		}
	}

	/**
	*根据地址清理掉未加载的内容
	*@param url 资源地址
	*/
	__proto.cancelLoadByUrl=function(url){
		for (var i=0;i < this._maxPriority;i++){
			var infos=this._resInfos[i];
			for (var j=infos.length-1;j >-1;j--){
				var info=infos[j];
				if (info && info.url===url){
					infos[j]=null;
					info.offAll();
					this._infoPool.push(info);
				}
			}
		}
		if (LoaderManager._resMap[url])delete LoaderManager._resMap[url];
	}

	/**
	*@private
	*加载数组里面的资源。
	*@param arr 简单：["a.png","b.png"]，复杂[{url:"a.png",type:Loader.IMAGE,size:100,priority:1,useWorkerLoader:true},{url:"b.json",type:Loader.JSON,size:50,priority:1}]*/
	__proto._loadAssets=function(arr,complete,progress,type,priority,cache,group){
		(priority===void 0)&& (priority=1);
		(cache===void 0)&& (cache=true);
		var itemCount=arr.length;
		var loadedCount=0;
		var totalSize=0;
		var items=[];
		var success=true;
		for (var i=0;i < itemCount;i++){
			var item=arr[i];
			if ((typeof item=='string'))item={url:item,type:type,size:1,priority:priority};
			if (!item.size)item.size=1;
			item.progress=0;
			totalSize+=item.size;
			items.push(item);
			var progressHandler=progress ? Handler.create(null,loadProgress,[item],false):null;
			var completeHandler=(complete || progress)? Handler.create(null,loadComplete,[item]):null;
			this.load(item.url,completeHandler,progressHandler,item.type,item.priority || 1,cache,item.group || group,false,item.useWorkerLoader);
		}
		function loadComplete (item,content){
			loadedCount++;
			item.progress=1;
			if (!content)success=false;
			if (loadedCount===itemCount && complete){
				complete.runWith(success);
			}
		}
		function loadProgress (item,value){
			if (progress !=null){
				item.progress=value;
				var num=0;
				for (var j=0;j < items.length;j++){
					var item1=items[j];
					num+=item1.size *item1.progress;
				};
				var v=num / totalSize;
				progress.runWith(v);
			}
		}
		return this;
	}

	//TODO:TESTs
	__proto.decodeBitmaps=function(urls){
		var i=0,len=urls.length;
		var ctx;
		ctx=Render._context.ctx;
		for (i=0;i < len;i++){
			var atlas;
			atlas=Loader.getAtlas(urls[i]);
			if (atlas){
				this._decodeTexture(atlas[0],ctx);
				}else {
				var tex;
				tex=this.getRes(urls[i]);
				if (tex && (tex instanceof laya.resource.Texture )){
					this._decodeTexture(tex,ctx);
				}
			}
		}
	}

	__proto._decodeTexture=function(tex,ctx){
		var bitmap=tex.bitmap;
		if (!tex || !bitmap)return;
		var tImg=bitmap.source || bitmap.image;
		if (!tImg)return;
		if (Laya.__typeof(tImg,Browser.window.HTMLImageElement)){
			ctx.drawImage(tImg,0,0,1,1);
			var info=ctx.getImageData(0,0,1,1);
		}
	}

	LoaderManager.cacheRes=function(url,data){
		Loader.cacheRes(url,data);
	}

	LoaderManager._resMap={};
	__static(LoaderManager,
	['createMap',function(){return this.createMap={atlas:[null,"atlas"]};}
	]);
	LoaderManager.__init$=function(){
		//class ResInfo extends laya.events.EventDispatcher
		ResInfo=(function(_super){
			function ResInfo(){
				this.url=null;
				this.type=null;
				this.cache=false;
				this.group=null;
				this.ignoreCache=false;
				this.useWorkerLoader=false;
				this.clas=null;
				ResInfo.__super.call(this);
			}
			__class(ResInfo,'',_super);
			return ResInfo;
		})(EventDispatcher)
	}

	return LoaderManager;
})(EventDispatcher)


	//file:///E:/git/layaair-master/core/src/laya/net/WorkerLoader.as=======98.999878/98.999878
/**
*@private
*Worker Image加载器
*/
//class laya.net.WorkerLoader extends laya.events.EventDispatcher
var WorkerLoader=(function(_super){
	function WorkerLoader(){
		/**使用的Worker对象。*/
		this.worker=null;
		/**@private */
		this._useWorkerLoader=false;
		WorkerLoader.__super.call(this);
		var _$this=this;
		this.worker=new Browser.window.Worker(WorkerLoader.workerPath);
		this.worker.onmessage=function (evt){
			_$this.workerMessage(evt.data);
		}
	}

	__class(WorkerLoader,'laya.net.WorkerLoader',_super);
	var __proto=WorkerLoader.prototype;
	/**
	*@private
	*/
	__proto.workerMessage=function(data){
		if (data){
			switch (data.type){
				case "Image":
					this.imageLoaded(data);
					break ;
				case "Disable":
					WorkerLoader.enable=false;
					break ;
				}
		}
	}

	/**
	*@private
	*/
	__proto.imageLoaded=function(data){
		if (!data.dataType || data.dataType !="imageBitmap"){
			this.event(data.url,null);
			return;
		};
		var canvas=new HTMLCanvas("2D");
		var ctx=canvas.source.getContext("2d");
		switch (data.dataType){
			case "imageBitmap":;
				var imageData=data.imageBitmap;
				canvas.size(imageData.width,imageData.height);
				ctx.drawImage(imageData,0,0);
				break ;
			}
		console.log("load:",data.url);
		if (Render.isWebGL){
			canvas.memorySize=0;
			canvas=new laya.webgl.resource.WebGLImage(canvas,data.url);;
		}
		this.event(data.url,canvas);
	}

	/**
	*加载图片
	*@param url 图片地址
	*/
	__proto.loadImage=function(url){
		this.worker.postMessage(url);
	}

	/**
	*@private
	*加载图片资源。
	*@param url 资源地址。
	*/
	__proto._loadImage=function(url){
		var _this=this;
		if (!this._useWorkerLoader || !WorkerLoader._enable){
			WorkerLoader._preLoadFun.call(_this,url);
			return;
		}
		url=URL.formatURL(url);
		function clear (){
			laya.net.WorkerLoader.I.off(url,_this,onload);
		};
		var onload=function (image){
			clear();
			if (image){
				_this["onLoaded"](image);
				}else {
				WorkerLoader._preLoadFun.call(_this,url);
			}
		};
		laya.net.WorkerLoader.I.on(url,_this,onload);
		laya.net.WorkerLoader.I.loadImage(url);
	}

	/**
	*是否启用。
	*/
	__getset(1,WorkerLoader,'enable',function(){
		return WorkerLoader._enable;
		},function(value){
		if (WorkerLoader._enable !=value){
			WorkerLoader._enable=value;
			if (value && WorkerLoader._preLoadFun==null)WorkerLoader._enable=WorkerLoader.__init__();
		}
	});

	WorkerLoader.__init__=function(){
		if (WorkerLoader._preLoadFun !=null)return false;
		if (!Browser.window.Worker)return false;
		WorkerLoader._preLoadFun=Loader["prototype"]["_loadImage"];
		Loader["prototype"]["_loadImage"]=WorkerLoader["prototype"]["_loadImage"];
		if (!WorkerLoader.I)WorkerLoader.I=new WorkerLoader();
		return true;
	}

	WorkerLoader.workerSupported=function(){
		return Browser.window.Worker ? true :false;
	}

	WorkerLoader.enableWorkerLoader=function(){
		if (!WorkerLoader._tryEnabled){
			WorkerLoader.enable=true;
			WorkerLoader._tryEnabled=true;
		}
	}

	WorkerLoader.I=null;
	WorkerLoader.workerPath="libs/workerloader.js";
	WorkerLoader._preLoadFun=null;
	WorkerLoader._enable=false;
	WorkerLoader._tryEnabled=false;
	return WorkerLoader;
})(EventDispatcher)


	//file:///E:/git/layaair-master/core/src/laya/resource/Resource.as=======98.999863/98.999863
/**
*@private
*<code>Resource</code> 资源存取类。
*/
//class laya.resource.Resource extends laya.events.EventDispatcher
var Resource=(function(_super){
	function Resource(){
		/**@private */
		//this.__loaded=false;
		/**@private */
		//this._id=0;
		/**@private */
		//this._url=null;
		/**@private */
		//this._memorySize=0;
		/**@private */
		//this._released=false;
		/**@private */
		//this._destroyed=false;
		/**@private */
		//this._referenceCount=0;
		/**@private */
		//this._group=null;
		/**@private */
		//this._resourceManager=null;
		/**是否加锁，如果true为不能使用自动释放机制。*/
		//this.lock=false;
		/**名称。 */
		//this.name=null;
		Resource.__super.call(this);
		this._id=++Resource._uniqueIDCounter;
		this.__loaded=true;
		this._destroyed=false;
		this._referenceCount=0;
		Resource._idResourcesMap[this.id]=this;
		this._released=true;
		this.lock=false;
		this._memorySize=0;
		(ResourceManager.currentResourceManager)&& (ResourceManager.currentResourceManager.addResource(this));
	}

	__class(Resource,'laya.resource.Resource',_super);
	var __proto=Resource.prototype;
	Laya.imps(__proto,{"laya.resource.ICreateResource":true,"laya.resource.IDestroy":true})
	/**
	*@private
	*/
	__proto._setUrl=function(url){
		if (this._url!==url){
			var resList;
			if (this._url){
				resList=Resource._urlResourcesMap[this._url];
				resList.splice(resList.indexOf(this),1);
				(resList.length===0)&& (delete Resource._urlResourcesMap[this._url]);
			}
			if (url){
				resList=Resource._urlResourcesMap[url];
				(resList)|| (Resource._urlResourcesMap[url]=resList=[]);
				resList.push(this);
			}
			this._url=url;
		}
	}

	/**
	*@private
	*/
	__proto._getGroup=function(){
		return this._group;
	}

	/**
	*@private
	*/
	__proto._setGroup=function(value){
		if (this._group!==value){
			var groupList;
			if (this._group){
				groupList=Resource._groupResourcesMap[this._group];
				groupList.splice(groupList.indexOf(this),1);
				(groupList.length===0)&& (delete Resource._groupResourcesMap[this._group]);
			}
			if (value){
				groupList=Resource._groupResourcesMap[value];
				(groupList)|| (Resource._groupResourcesMap[value]=groupList=[]);
				groupList.push(this);
			}
			this._group=value;
		}
	}

	/**
	*@private
	*/
	__proto._addReference=function(){
		this._referenceCount++;
	}

	/**
	*@private
	*/
	__proto._removeReference=function(){
		this._referenceCount--;
	}

	/**
	*@private
	*/
	__proto._clearReference=function(){
		this._referenceCount=0;
	}

	/**
	*@private
	*/
	__proto._completeLoad=function(){
		this.__loaded=true;
		this._released=false;
		this.event("loaded",this);
	}

	/**
	*@private
	*/
	__proto.recoverResource=function(){}
	/**
	*@private
	*/
	__proto.disposeResource=function(){}
	/**
	*@private
	*/
	__proto._activeResource=function(){
		this._released=false;
	}

	/**
	*释放资源。
	*@param force 是否强制释放。
	*@return 是否成功释放。
	*/
	__proto.releaseResource=function(force){
		(force===void 0)&& (force=false);
		if (!force && this.lock)
			return false;
		if (!this._released || force){
			this.disposeResource();
			this._released=true;
			return true;
			}else {
			return false;
		}
	}

	/**
	*@private
	*/
	__proto.onAsynLoaded=function(data,params){
		throw new Error("Resource: must override this function!");
	}

	/**
	*<p>彻底处理资源，处理后不能恢复。</p>
	*<p><b>注意：</b>会强制解锁清理。</p>
	*/
	__proto.destroy=function(){
		if (this._destroyed)
			return;
		if (this._resourceManager!==null)
			this._resourceManager.removeResource(this);
		this._destroyed=true;
		this.lock=false;
		this.releaseResource();
		delete Resource._idResourcesMap[this.id];
		var resList;
		if (this._url){
			resList=Resource._urlResourcesMap[this._url];
			if (resList){
				resList.splice(resList.indexOf(this),1);
				(resList.length===0)&& (delete Resource._urlResourcesMap[this.url]);
			}
			Loader.clearRes(this._url);
		}
		if (this._group){
			resList=Resource._groupResourcesMap[this._group];
			resList.splice(resList.indexOf(this),1);
			(resList.length===0)&& (delete Resource._groupResourcesMap[this.url]);
		}
	}

	/**
	*@private
	*/
	/**
	*占用内存尺寸。
	*/
	__getset(0,__proto,'memorySize',function(){
		return this._memorySize;
		},function(value){
		var offsetValue=value-this._memorySize;
		this._memorySize=value;
		this.resourceManager && this.resourceManager.addSize(offsetValue);
	});

	/**
	*@private
	*/
	__getset(0,__proto,'_loaded',null,function(value){
		this.__loaded=value;
	});

	/**
	*获取是否已加载完成。
	*/
	__getset(0,__proto,'loaded',function(){
		return this.__loaded;
	});

	/**
	*获取唯一标识ID,通常用于识别。
	*/
	__getset(0,__proto,'id',function(){
		return this._id;
	});

	/**
	*是否已释放。
	*/
	__getset(0,__proto,'released',function(){
		return this._released;
	});

	/**
	*获取资源的URL地址。
	*@return URL地址。
	*/
	__getset(0,__proto,'url',function(){
		return this._url;
	});

	/**
	*设置资源组名。
	*/
	/**
	*获取资源组名。
	*/
	__getset(0,__proto,'group',function(){
		return this._getGroup();
		},function(value){
		this._setGroup(value);
	});

	/**
	*是否已处理。
	*/
	__getset(0,__proto,'destroyed',function(){
		return this._destroyed;
	});

	/**
	*资源管理员。
	*/
	__getset(0,__proto,'resourceManager',function(){
		return this._resourceManager;
	});

	/**
	*获取资源的引用计数。
	*/
	__getset(0,__proto,'referenceCount',function(){
		return this._referenceCount;
	});

	Resource.getResourceByID=function(id){
		return Resource._idResourcesMap[id];
	}

	Resource.getResourceByURL=function(url,index){
		(index===void 0)&& (index=0);
		return Resource._urlResourcesMap[url][index];
	}

	Resource.destroyUnusedResources=function(group){
		var res;
		if (group){
			var resouList=Resource._groupResourcesMap[group];
			if (resouList){
				var tempResouList=resouList.slice();
				for (var i=0,n=tempResouList.length;i < n;i++){
					res=tempResouList[i];
					if (!res.lock && res._referenceCount===0)
						res.destroy();
				}
			}
			}else {
			for (var k in Resource._idResourcesMap){
				res=Resource._idResourcesMap[k];
				if (!res.lock && res._referenceCount===0)
					res.destroy();
			}
		}
	}

	Resource._uniqueIDCounter=0;
	Resource._idResourcesMap={};
	Resource._urlResourcesMap={};
	Resource._groupResourcesMap={};
	return Resource;
})(EventDispatcher)


	//file:///E:/git/layaair-master/core/src/laya/display/css/TextStyle.as=======98.999861/98.999861
/**
*文本的样式类
*/
//class laya.display.css.TextStyle extends laya.display.css.SpriteStyle
var TextStyle=(function(_super){
	function TextStyle(){
		/**
		*表示使用此文本格式的文本是否为斜体。
		*@default false
		*/
		this.italic=false;
		/**
		*<p>表示使用此文本格式的文本段落的水平对齐方式。</p>
		*@default "left"
		*/
		//this.align=null;
		/**
		*<p>表示使用此文本格式的文本字段是否自动换行。</p>
		*如果 wordWrap 的值为 true，则该文本字段自动换行；如果值为 false，则该文本字段不自动换行。
		*@default false。
		*/
		//this.wordWrap=false;
		/**
		*<p>垂直行间距（以像素为单位）</p>
		*/
		//this.leading=NaN;
		/**
		*<p>默认边距信息</p>
		*<p>[左边距，上边距，右边距，下边距]（边距以像素为单位）</p>
		*/
		//this.padding=null;
		/**
		*文本背景颜色，以字符串表示。
		*/
		//this.bgColor=null;
		/**
		*文本边框背景颜色，以字符串表示。
		*/
		//this.borderColor=null;
		/**
		*<p>指定文本字段是否是密码文本字段。</p>
		*如果此属性的值为 true，则文本字段被视为密码文本字段，并使用星号而不是实际字符来隐藏输入的字符。如果为 false，则不会将文本字段视为密码文本字段。
		*/
		//this.asPassword=false;
		/**
		*<p>描边宽度（以像素为单位）。</p>
		*默认值0，表示不描边。
		*@default 0
		*/
		//this.stroke=NaN;
		/**
		*<p>描边颜色，以字符串表示。</p>
		*@default "#000000";
		*/
		//this.strokeColor=null;
		/**是否为粗体*/
		//this.bold=false;
		/**是否显示下划线*/
		//this.underline=false;
		/**下划线颜色*/
		//this.underlineColor=null;
		/**当前使用的位置字体。*/
		//this.currBitmapFont=null;
		TextStyle.__super.call(this);
	}

	__class(TextStyle,'laya.display.css.TextStyle',_super);
	var __proto=TextStyle.prototype;
	__proto.reset=function(){
		_super.prototype.reset.call(this);
		this.italic=false;
		this.align="left";
		this.wordWrap=false;
		this.leading=0;
		this.padding=[0,0,0,0];
		this.bgColor=null;
		this.borderColor=null;
		this.asPassword=false;
		this.stroke=0;
		this.strokeColor="#000000";
		this.bold=false;
		this.underline=false;
		this.underlineColor=null;
		this.currBitmapFont=null;
		return this;
	}

	__proto.recover=function(){
		if (this===TextStyle.EMPTY)
			return;
		Pool.recover("TextStyle",this.reset());
	}

	/**@inheritDoc */
	__proto.render=function(sprite,context,x,y){
		(this.bgColor || this.borderColor)&& context.drawRect(x,y,sprite.width,sprite.height,this.bgColor,this.borderColor,1);
	}

	TextStyle.create=function(){
		return Pool.getItemByClass("TextStyle",TextStyle);
	}

	TextStyle.EMPTY=new TextStyle();
	return TextStyle;
})(SpriteStyle)


	//file:///E:/git/layaair-master/core/src/laya/resource/Texture.as=======98.999855/98.999855
/**
*<code>Texture</code> 是一个纹理处理类。
*/
//class laya.resource.Texture extends laya.events.EventDispatcher
var Texture=(function(_super){
	function Texture(bitmap,uv,sourceWidth,sourceHeight){
		/**图片或者canvas 。*/
		//this.bitmap=null;
		/**UV信息。*/
		//this._uv=null;
		/**沿 X 轴偏移量。*/
		this.offsetX=0;
		/**沿 Y 轴偏移量。*/
		this.offsetY=0;
		/**原始宽度（包括被裁剪的透明区域）。*/
		this.sourceWidth=0;
		/**原始高度（包括被裁剪的透明区域）。*/
		this.sourceHeight=0;
		/**@private */
		//this._loaded=false;
		/**@private */
		this._w=0;
		/**@private */
		this._h=0;
		/**@private 唯一ID*/
		//this.$_GID=NaN;
		/**图片地址*/
		//this.url=null;
		/**@private */
		this._uvID=0;
		/**@private */
		//this._id=0;
		/**@private */
		this._saveRef=0;
		/**@private native使用*/
		//this._conchTexture=null;
		Texture.__super.call(this);
		(sourceWidth===void 0)&& (sourceWidth=0);
		(sourceHeight===void 0)&& (sourceHeight=0);
		this._id=++Texture._uniqueIDCounter;
		if (Render.isConchApp){
			this._conchTexture=new LayaAirTexture();
		}
		if (bitmap){
			bitmap.useNum++;
		}
		this.setTo(bitmap,uv,sourceWidth,sourceHeight);
	}

	__class(Texture,'laya.resource.Texture',_super);
	var __proto=Texture.prototype;
	__proto._saveAddref=function(){
		this._saveRef++;
		Texture._pool[this._id]=this;
	}

	__proto._saveRelease=function(){
		this._saveRef--;
		this._saveRef===0 && (Texture._pool[this._id]=null);
	}

	__proto.getID=function(){
		return this._id;
	}

	/**privaye*/
	__proto._getSource=function(){
		return this.bitmap?this.bitmap._getSource():null;
	}

	__proto._setUV=function(value){}
	__proto._setUVWithNative=function(value){
		this._conchTexture.setUVWidthHeight(value[0],value[1],value[4],value[5],this.sourceWidth || this._w,this.sourceHeight || this._h);
	}

	/**
	*设置此对象的位图资源、UV数据信息。
	*@param bitmap 位图资源
	*@param uv UV数据信息
	*/
	__proto.setTo=function(bitmap,uv,sourceWidth,sourceHeight){
		(sourceWidth===void 0)&& (sourceWidth=0);
		(sourceHeight===void 0)&& (sourceHeight=0);
		this.bitmap=bitmap;
		this.sourceWidth=sourceWidth;
		this.sourceHeight=sourceHeight;
		if (bitmap){
			this._w=bitmap.width;
			this._h=bitmap.height;
			this.sourceWidth=this.sourceWidth || this._w;
			this.sourceHeight=this.sourceHeight || this._h
			this._loaded=this._w > 0;
			var _this=this;
		}
		this.uv=uv || Texture.DEF_UV;
	}

	__proto.setToWithNative=function(bitmap,uv,sourceWidth,sourceHeight){
		(sourceWidth===void 0)&& (sourceWidth=0);
		(sourceHeight===void 0)&& (sourceHeight=0);
		this.bitmap=bitmap;
		this.sourceWidth=sourceWidth;
		this.sourceHeight=sourceHeight;
		if (bitmap){
			this._w=bitmap.width;
			this._h=bitmap.height;
			this.sourceWidth=this.sourceWidth || this._w;
			this.sourceHeight=this.sourceHeight || this._h
			this._loaded=this._w > 0;
			var _this=this;
			this._conchTexture.setImageID(bitmap._source._nativeObj.conchImgId);
		}
		this.uv=uv || Texture.DEF_UV;
	}

	/**@private 激活资源。*/
	__proto.active=function(){
		if(this.bitmap)this.bitmap.activeResource();
	}

	__proto.getEnabled=function(){
		if (this._loaded && this.bitmap){
			return true
		}
		return false;
	}

	/**
	*销毁纹理（分直接销毁，跟计数销毁两种）。
	*@param forceDispose (default=false)true为强制销毁主纹理，false是通过计数销毁纹理。
	*/
	__proto.destroy=function(forceDispose){
		(forceDispose===void 0)&& (forceDispose=false);
		if (this.bitmap && (this.bitmap).useNum > 0){
			if (forceDispose){
				this.bitmap.destroy();
				(this.bitmap).useNum=0;
				}else {
				(this.bitmap).useNum--;
				if ((this.bitmap).useNum==0){
					this.bitmap.destroy();
				}
			}
			this.bitmap=null;
			if (this.url && this===Laya.loader.getRes(this.url))Laya.loader.clearRes(this.url,forceDispose);
			this._loaded=false;
		}
	}

	/**
	*加载指定地址的图片。
	*@param url 图片地址。
	*/
	__proto.load=function(url){
		this._loaded=false;
		Laya.loader.load(url,Handler.create(this,this._onLoaded),null,"htmlimage",1,false,null,true);
	}

	__proto._onLoaded=function(context){
		this.bitmap=context;
		this.bitmap.useNum++;
		this._loaded=true;
		this.sourceWidth=this._w=context.width;
		this.sourceHeight=this._h=context.height;
		this.event("loaded",this);
	}

	__proto._onLoadedWithNative=function(context){
		this.bitmap=context;
		this._conchTexture.setImageID(this.bitmap._source._nativeObj.conchImgId);
		this.bitmap.useNum++;
		this._loaded=true;
		this.sourceWidth=this._w=context.width;
		this.sourceHeight=this._h=context.height;
		this.event("loaded",this);
	}

	/**
	*获取Texture上的某个区域的像素点
	*@param x
	*@param y
	*@param width
	*@param height
	*@return 返回像素点集合
	*/
	__proto.getPixels=function(x,y,width,height){
		if (Render.isWebGL){
			return RunDriver.getTexturePixels(this,x,y,width,height);
			}else {
			Browser.canvas.size(width,height);
			Browser.canvas.clear();
			Browser.context.drawImage(this,-x,-y,this.width,this.height,0,0);
			var info=Browser.context.getImageData(0,0,width,height);
		}
		return info.data;
	}

	/**@private */
	__proto.onAsynLoaded=function(url,bitmap){
		if (bitmap)bitmap.useNum++;
		this.setTo(bitmap,this.uv);
	}

	/**
	*通过外部设置是否启用纹理平铺(后面要改成在着色器里计算)
	*/
	/**
	*获取当前纹理是否启用了纹理平铺
	*/
	__getset(0,__proto,'repeat',function(){
		if (Render.isWebGL && this.bitmap){
			return this.bitmap.repeat;
		}
		return true;
		},function(value){
		if (value){
			if (Render.isWebGL && this.bitmap){
				this.bitmap.repeat=value;
				if (value){
					this.bitmap.enableMerageInAtlas=false;
				}
			}
		}
	});

	/**实际高度。*/
	__getset(0,__proto,'height',function(){
		if (!this.loaded)return 0;
		if (this._h)return this._h;
		return (this.uv && this.uv!==Texture.DEF_UV)? (this.uv[5]-this.uv[1])*this.bitmap.height :this.bitmap.height;
		},function(value){
		this._h=value;
		this.sourceHeight || (this.sourceHeight=value);
	});

	__getset(0,__proto,'uv',function(){
		return this._uv;
		},function(value){
		this._uv=value;
		this._setUV(value);
	});

	/**
	*表示是否加载成功，只能表示初次载入成功（通常包含下载和载入）,并不能完全表示资源是否可立即使用（资源管理机制释放影响等）。
	*/
	__getset(0,__proto,'loaded',function(){
		return this._loaded;
	});

	/**
	*表示资源是否已释放。
	*/
	__getset(0,__proto,'released',function(){
		if (!this.bitmap)return true;
		return this.bitmap.released;
	});

	/**实际宽度。*/
	__getset(0,__proto,'width',function(){
		if (!this.loaded)return 0;
		if (this._w)return this._w;
		return (this.uv && this.uv!==Texture.DEF_UV)? (this.uv[2]-this.uv[0])*this.bitmap.width :this.bitmap.width;
		},function(value){
		this._w=value;
		this.sourceWidth || (this.sourceWidth=value);
	});

	/**
	*设置线性采样的状态（目前只能第一次绘制前设置false生效,来关闭线性采样）。
	*/
	/**
	*获取当前纹理是否启用了线性采样。
	*/
	__getset(0,__proto,'isLinearSampling',function(){
		return Render.isWebGL ? (this.bitmap.minFifter !=0x2600):true;
		},function(value){
		if (!value && Render.isWebGL){
			if (!value && (this.bitmap.minFifter==-1)&& (this.bitmap.magFifter==-1)){
				this.bitmap.minFifter=0x2600;
				this.bitmap.magFifter=0x2600;
				this.bitmap.enableMerageInAtlas=false;
			}
		}
	});

	Texture.getTextureByID=function(id){
		return Texture._pool[id];
	}

	Texture.moveUV=function(offsetX,offsetY,uv){
		for (var i=0;i < 8;i+=2){
			uv[i]+=offsetX;
			uv[i+1]+=offsetY;
		}
		return uv;
	}

	Texture.create=function(source,x,y,width,height,offsetX,offsetY,sourceWidth,sourceHeight){
		(offsetX===void 0)&& (offsetX=0);
		(offsetY===void 0)&& (offsetY=0);
		(sourceWidth===void 0)&& (sourceWidth=0);
		(sourceHeight===void 0)&& (sourceHeight=0);
		var btex=(source instanceof laya.resource.Texture );
		var uv=btex ? source.uv :Texture.DEF_UV;
		var bitmap=btex ? source.bitmap :source;
		if (bitmap.width && (x+width)> bitmap.width)width=bitmap.width-x;
		if (bitmap.height && (y+height)> bitmap.height)height=bitmap.height-y;
		var tex=new Texture(bitmap,null,sourceWidth || width,sourceHeight || height);
		tex.width=width;
		tex.height=height;
		tex.offsetX=offsetX;
		tex.offsetY=offsetY;
		var dwidth=1 / bitmap.width;
		var dheight=1 / bitmap.height;
		x *=dwidth;
		y *=dheight;
		width *=dwidth;
		height *=dheight;
		var u1=tex.uv[0],v1=tex.uv[1],u2=tex.uv[4],v2=tex.uv[5];
		var inAltasUVWidth=(u2-u1),inAltasUVHeight=(v2-v1);
		var oriUV=Texture.moveUV(uv[0],uv[1],[x,y,x+width,y,x+width,y+height,x,y+height]);
		tex.uv=[u1+oriUV[0] *inAltasUVWidth,v1+oriUV[1] *inAltasUVHeight,u2-(1-oriUV[2])*inAltasUVWidth,v1+oriUV[3] *inAltasUVHeight,u2-(1-oriUV[4])*inAltasUVWidth,v2-(1-oriUV[5])*inAltasUVHeight,u1+oriUV[6] *inAltasUVWidth,v2-(1-oriUV[7])*inAltasUVHeight];
		return tex;
	}

	Texture.createFromTexture=function(texture,x,y,width,height){
		var rect=Rectangle.TEMP.setTo(x-texture.offsetX,y-texture.offsetY,width,height);
		var result=rect.intersection(Texture._rect1.setTo(0,0,texture.width,texture.height),Texture._rect2);
		if (result)
			var tex=Texture.create(texture,result.x,result.y,result.width,result.height,result.x-rect.x,result.y-rect.y,width,height);
		else return null;
		tex.bitmap.useNum--;
		return tex;
	}

	Texture.DEF_UV=[0,0,1.0,0,1.0,1.0,0,1.0];
	Texture.NO_UV=[0,0,0,0,0,0,0,0];
	Texture.INV_UV=[0,1,1.0,1,1.0,0.0,0,0.0];
	Texture._rect1=new Rectangle();
	Texture._rect2=new Rectangle();
	Texture._uniqueIDCounter=0;
	Texture._pool=[];
	return Texture;
})(EventDispatcher)


	//file:///E:/git/layaair-master/core/src/laya/filters/ColorFilter.as=======98.999829/98.999829
/**
*<p><code>ColorFilter</code> 是颜色滤镜。使用 ColorFilter 类可以将 4 x 5 矩阵转换应用于输入图像上的每个像素的 RGBA 颜色和 Alpha 值，以生成具有一组新的 RGBA 颜色和 Alpha 值的结果。该类允许饱和度更改、色相旋转、亮度转 Alpha 以及各种其他效果。您可以将滤镜应用于任何显示对象（即，从 Sprite 类继承的对象）。</p>
*<p>注意：对于 RGBA 值，最高有效字节代表红色通道值，其后的有效字节分别代表绿色、蓝色和 Alpha 通道值。</p>
*/
//class laya.filters.ColorFilter extends laya.filters.Filter
var ColorFilter=(function(_super){
	function ColorFilter(mat){
		/**@private */
		//this._mat=null;
		/**@private */
		//this._alpha=null;
		/**当前使用的矩阵*/
		//this._matrix=null;
		ColorFilter.__super.call(this);
		if (!mat)mat=this._copyMatrix(ColorFilter.IDENTITY_MATRIX);
		this._mat=new Float32Array(16);
		this._alpha=new Float32Array(4);
		this.setByMatrix(mat);
		this._action=RunDriver.createFilterAction(0x20);
		this._action.data=this;
	}

	__class(ColorFilter,'laya.filters.ColorFilter',_super);
	var __proto=ColorFilter.prototype;
	Laya.imps(__proto,{"laya.filters.IFilter":true})
	/**
	*设置为灰色滤镜
	*/
	__proto.gray=function(){
		return this.setByMatrix(ColorFilter.GRAY_MATRIX);
	}

	/**
	*设置为变色滤镜
	*@param red 红色增量,范围:0~255
	*@param green 绿色增量,范围:0~255
	*@param blue 蓝色增量,范围:0~255
	*@param alpha alpha,范围:0~1
	*/
	__proto.color=function(red,green,blue,alpha){
		(red===void 0)&& (red=0);
		(green===void 0)&& (green=0);
		(blue===void 0)&& (blue=0);
		(alpha===void 0)&& (alpha=1);
		return this.setByMatrix([1,0,0,0,red,0,1,0,0,green,0,0,1,0,blue,0,0,0,1,alpha]);
	}

	/**
	*设置矩阵数据
	*@param matrix 由 20 个项目（排列成 4 x 5 矩阵）组成的数组
	*@return this
	*/
	__proto.setByMatrix=function(matrix){
		if (this._matrix !=matrix)this._copyMatrix(matrix);
		var j=0;
		var z=0;
		for (var i=0;i < 20;i++){
			if (i % 5 !=4){
				this._mat[j++]=matrix[i];
				}else {
				this._alpha[z++]=matrix[i];
			}
		}
		return this;
	}

	/**
	*调整颜色，包括亮度，对比度，饱和度和色调
	*@param brightness 亮度,范围:-100~100
	*@param contrast 对比度,范围:-100~100
	*@param saturation 饱和度,范围:-100~100
	*@param hue 色调,范围:-180~180
	*@return this
	*/
	__proto.adjustColor=function(brightness,contrast,saturation,hue){
		this.adjustHue(hue);
		this.adjustContrast(contrast);
		this.adjustBrightness(brightness);
		this.adjustSaturation(saturation);
		return this;
	}

	/**
	*调整亮度
	*@param brightness 亮度,范围:-100~100
	*@return this
	*/
	__proto.adjustBrightness=function(brightness){
		brightness=this._clampValue(brightness,100);
		if (brightness==0 || isNaN(brightness))return this;
		return this._multiplyMatrix([1,0,0,0,brightness,0,1,0,0,brightness,0,0,1,0,brightness,0,0,0,1,0,0,0,0,0,1]);
	}

	/**
	*调整对比度
	*@param contrast 对比度,范围:-100~100
	*@return this
	*/
	__proto.adjustContrast=function(contrast){
		contrast=this._clampValue(contrast,100);
		if (contrast==0 || isNaN(contrast))return this;
		var x=NaN;
		if (contrast < 0){
			x=127+contrast / 100 *127
			}else {
			x=contrast % 1;
			if (x==0){
				x=ColorFilter.DELTA_INDEX[contrast];
				}else {
				x=ColorFilter.DELTA_INDEX[(contrast << 0)] *(1-x)+ColorFilter.DELTA_INDEX[(contrast << 0)+1] *x;
			}
			x=x *127+127;
		};
		var x1=x / 127;
		var x2=(127-x)*0.5;
		return this._multiplyMatrix([x1,0,0,0,x2,0,x1,0,0,x2,0,0,x1,0,x2,0,0,0,1,0,0,0,0,0,1]);
	}

	/**
	*调整饱和度
	*@param saturation 饱和度,范围:-100~100
	*@return this
	*/
	__proto.adjustSaturation=function(saturation){
		saturation=this._clampValue(saturation,100);
		if (saturation==0 || isNaN(saturation))return this;
		var x=1+((saturation > 0)? 3 *saturation / 100 :saturation / 100);
		var dx=1-x;
		var r=0.3086 *dx;
		var g=0.6094 *dx;
		var b=0.0820 *dx;
		return this._multiplyMatrix([r+x,g,b,0,0,r,g+x,b,0,0,r,g,b+x,0,0,0,0,0,1,0,0,0,0,0,1]);
	}

	/**
	*调整色调
	*@param hue 色调,范围:-180~180
	*@return this
	*/
	__proto.adjustHue=function(hue){
		hue=this._clampValue(hue,180)/ 180 *Math.PI;
		if (hue==0 || isNaN(hue))return this;
		var cos=Math.cos(hue);
		var sin=Math.sin(hue);
		var r=0.213;
		var g=0.715;
		var b=0.072;
		return this._multiplyMatrix([r+cos *(1-r)+sin *(-r),g+cos *(-g)+sin *(-g),b+cos *(-b)+sin *(1-b),0,0,r+cos *(-r)+sin *(0.143),g+cos *(1-g)+sin *(0.140),b+cos *(-b)+sin *(-0.283),0,0,r+cos *(-r)+sin *(-(1-r)),g+cos *(-g)+sin *(g),b+cos *(1-b)+sin *(b),0,0,0,0,0,1,0,0,0,0,0,1]);
	}

	/**
	*重置成单位矩阵，去除滤镜效果
	*/
	__proto.reset=function(){
		return this.setByMatrix(this._copyMatrix(ColorFilter.IDENTITY_MATRIX));
	}

	/**
	*矩阵乘法
	*@param matrix
	*@return this
	*/
	__proto._multiplyMatrix=function(matrix){
		var col=[];
		this._matrix=this._fixMatrix(this._matrix);
		for (var i=0;i < 5;i++){
			for (var j=0;j < 5;j++){
				col[j]=this._matrix[j+i *5];
			}
			for (j=0;j < 5;j++){
				var val=0;
				for (var k=0;k < 5;k++){
					val+=matrix[j+k *5] *col[k];
				}
				this._matrix[j+i *5]=val;
			}
		}
		return this.setByMatrix(this._matrix);
	}

	/**
	*规范值的范围
	*@param val 当前值
	*@param limit 值的范围-limit~limit
	*/
	__proto._clampValue=function(val,limit){
		return Math.min(limit,Math.max(-limit,val));
	}

	/**
	*规范矩阵,将矩阵调整到正确的大小
	*@param matrix 需要调整的矩阵
	*/
	__proto._fixMatrix=function(matrix){
		if (matrix==null)return ColorFilter.IDENTITY_MATRIX;
		if (matrix.length < 25)matrix=matrix.slice(0,matrix.length).concat(ColorFilter.IDENTITY_MATRIX.slice(matrix.length,25));
		else if (matrix.length > 25)matrix=matrix.slice(0,25);
		return matrix;
	}

	/**
	*复制矩阵
	*/
	__proto._copyMatrix=function(matrix){
		var len=25;
		if (!this._matrix)this._matrix=[];
		for (var i=0;i < len;i++){
			this._matrix[i]=matrix[i];
		}
		return this._matrix;
	}

	/**@private */
	__getset(0,__proto,'type',function(){
		return 0x20;
	});

	/**@private */
	__getset(0,__proto,'action',function(){
		return this._action;
	});

	ColorFilter.LENGTH=25;
	__static(ColorFilter,
	['DELTA_INDEX',function(){return this.DELTA_INDEX=[0,0.01,0.02,0.04,0.05,0.06,0.07,0.08,0.1,0.11,0.12,0.14,0.15,0.16,0.17,0.18,0.20,0.21,0.22,0.24,0.25,0.27,0.28,0.30,0.32,0.34,0.36,0.38,0.40,0.42,0.44,0.46,0.48,0.5,0.53,0.56,0.59,0.62,0.65,0.68,0.71,0.74,0.77,0.80,0.83,0.86,0.89,0.92,0.95,0.98,1.0,1.06,1.12,1.18,1.24,1.30,1.36,1.42,1.48,1.54,1.60,1.66,1.72,1.78,1.84,1.90,1.96,2.0,2.12,2.25,2.37,2.50,2.62,2.75,2.87,3.0,3.2,3.4,3.6,3.8,4.0,4.3,4.7,4.9,5.0,5.5,6.0,6.5,6.8,7.0,7.3,7.5,7.8,8.0,8.4,8.7,9.0,9.4,9.6,9.8,10.0];},'GRAY_MATRIX',function(){return this.GRAY_MATRIX=[0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0];},'IDENTITY_MATRIX',function(){return this.IDENTITY_MATRIX=[1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1];}
	]);
	return ColorFilter;
})(Filter)


	//file:///E:/git/layaair-master/core/src/laya/renders/layagl/LayaGLNativeContext.as=======98.999769/98.999769
/**
*...
*@author guo
*/
//class laya.renders.layagl.LayaGLNativeContext extends laya.renders.layagl.LayaGL
var LayaGLNativeContext=(function(_super){
	function LayaGLNativeContext(c){
		this._canvas=null;
		this.__tx=0;
		this.__ty=0;
		this._mainContext=null;
		this.width=0;
		this.height=0;
		this._buffer1=null;
		if (!LayaGLNativeContext._syncArrayBufferList){
			LayaGLNativeContext._syncArrayBufferList=new Int32Array(LayaGLNativeContext._syncArrayBufferSize);
			LayaGLNativeContext._syncArrayBufferList["conchRef"]=window.conch.createArrayBufferRef(LayaGLNativeContext._syncArrayBufferList,0,false);
			LayaGLNativeContext._syncArrayBufferList["_ptrID"]=LayaGLNativeContext._syncArrayBufferList["conchRef"].id;
		}
		LayaGLNativeContext.__super.call(this,102400,51200,false,false);
		this._buffer1=new GLBuffer(102400,12800,false,false);
		this._canvas=c;
		this._mainContext=this._canvas._source.getContext("2d");
		this._mainContext._canvas=this._canvas;
		this._mainContext.setSyncArrayBufferID(LayaGLNativeContext._syncArrayBufferList["_ptrID"]);
	}

	__class(LayaGLNativeContext,'laya.renders.layagl.LayaGLNativeContext',_super);
	var __proto=LayaGLNativeContext.prototype;
	__proto.size=function(w,h){
		this.width=w;
		this.height=h;
	}

	__proto.setIsMainContext=function(){
		this._mainContext.size=function (w,h){};
		this._mainContext.__tx=0;
		this._mainContext.__ty=0;
	}

	__proto.flush=function(ctx){
		this._mainContext.setTemplateArryBufferID(this._buffer._buffer["_ptrID"],LayaGLNativeContext._frameCount);
		LayaGLNativeContext.tempBuffer=this._buffer1;
		this._buffer1=this._buffer;
		this._buffer=LayaGLNativeContext.tempBuffer;
		this._buffer.clear();
		LayaGLNativeContext._frameCount++;
	}

	__proto.copyCmdBuffer=function(begin,end){
		this._buffer.copyBuffer(this._buffer1._buffer,end-begin,begin);
	}

	LayaGLNativeContext.createArrayBufferRef=function(arrayBuffer,type,syncRender){
		var bufferConchRef=window.conch.createArrayBufferRef(arrayBuffer,type,syncRender);
		if (syncRender==true && bufferConchRef.id >=LayaGLNativeContext._syncArrayBufferSize){
			var pre=LayaGLNativeContext._syncArrayBufferList;
			var preConchRef=LayaGLNativeContext._syncArrayBufferList["conchRef"];
			var prePtrID=LayaGLNativeContext._syncArrayBufferList["_ptrID"];
			LayaGLNativeContext._syncArrayBufferSize+=4096;
			LayaGLNativeContext._syncArrayBufferList=new Int32Array(LayaGLNativeContext._syncArrayBufferSize);
			LayaGLNativeContext._syncArrayBufferList["conchRef"]=preConchRef;
			LayaGLNativeContext._syncArrayBufferList["_ptrID"]=prePtrID;
			pre && LayaGLNativeContext._syncArrayBufferList.set(pre,0);
			window.conch.updateArrayBufferRef(LayaGLNativeContext._syncArrayBufferList["_ptrID"],false,LayaGLNativeContext._syncArrayBufferList);
		}
		return bufferConchRef;
	}

	LayaGLNativeContext.syncArrayBufferID=function(id){
		LayaGLNativeContext._syncArrayBufferList[id]=LayaGLNativeContext._frameCount;
	}

	LayaGLNativeContext._SYNC_ARRAYBUFFER_SIZE_=4096;
	LayaGLNativeContext.tempBuffer=null;
	LayaGLNativeContext._syncArrayBufferSize=4096;
	LayaGLNativeContext._syncArrayBufferList=null;
	LayaGLNativeContext._frameCount=0;
	return LayaGLNativeContext;
})(LayaGL)


	//file:///E:/git/layaair-master/core/src/laya/display/Sprite.as=======97.999973/97.999973
/**
*<p> <code>Sprite</code> 是基本的显示图形的显示列表节点。 <code>Sprite</code> 默认没有宽高，默认不接受鼠标事件。通过 <code>graphics</code> 可以绘制图片或者矢量图，支持旋转，缩放，位移等操作。<code>Sprite</code>同时也是容器类，可用来添加多个子节点。</p>
*<p>注意： <code>Sprite</code> 默认没有宽高，可以通过<code>getBounds</code>函数获取；也可手动设置宽高；还可以设置<code>autoSize=true</code>，然后再获取宽高。<code>Sprite</code>的宽高一般用于进行碰撞检测和排版，并不影响显示图像大小，如果需要更改显示图像大小，请使用 <code>scaleX</code> ， <code>scaleY</code> ， <code>scale</code>。</p>
*<p> <code>Sprite</code> 默认不接受鼠标事件，即<code>mouseEnabled=false</code>，但是只要对其监听任意鼠标事件，会自动打开自己以及所有父对象的<code>mouseEnabled=true</code>。所以一般也无需手动设置<code>mouseEnabled</code>。</p>
*<p>LayaAir引擎API设计精简巧妙。核心显示类只有一个<code>Sprite</code>。<code>Sprite</code>针对不同的情况做了渲染优化，所以保证一个类实现丰富功能的同时，又达到高性能。</p>
*
*@example <caption>创建了一个 <code>Sprite</code> 实例。</caption>
*package
*{
	*import laya.display.Sprite;
	*import laya.events.Event;
	*
	*public class Sprite_Example
	*{
		*private var sprite:Sprite;
		*private var shape:Sprite
		*public function Sprite_Example()
		*{
			*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*onInit();
			*}
		*private function onInit():void
		*{
			*sprite=new Sprite();//创建一个 Sprite 类的实例对象 sprite 。
			*sprite.loadImage("resource/ui/bg.png");//加载并显示图片。
			*sprite.x=200;//设置 sprite 对象相对于父容器的水平方向坐标值。
			*sprite.y=200;//设置 sprite 对象相对于父容器的垂直方向坐标值。
			*sprite.pivotX=0;//设置 sprite 对象的水平方法轴心点坐标。
			*sprite.pivotY=0;//设置 sprite 对象的垂直方法轴心点坐标。
			*Laya.stage.addChild(sprite);//将此 sprite 对象添加到显示列表。
			*sprite.on(Event.CLICK,this,onClickSprite);//给 sprite 对象添加点击事件侦听。
			*shape=new Sprite();//创建一个 Sprite 类的实例对象 sprite 。
			*shape.graphics.drawRect(0,0,100,100,"#ccff00","#ff0000",2);//绘制一个有边框的填充矩形。
			*shape.x=400;//设置 shape 对象相对于父容器的水平方向坐标值。
			*shape.y=200;//设置 shape 对象相对于父容器的垂直方向坐标值。
			*shape.width=100;//设置 shape 对象的宽度。
			*shape.height=100;//设置 shape 对象的高度。
			*shape.pivotX=50;//设置 shape 对象的水平方法轴心点坐标。
			*shape.pivotY=50;//设置 shape 对象的垂直方法轴心点坐标。
			*Laya.stage.addChild(shape);//将此 shape 对象添加到显示列表。
			*shape.on(Event.CLICK,this,onClickShape);//给 shape 对象添加点击事件侦听。
			*}
		*private function onClickSprite():void
		*{
			*trace("点击 sprite 对象。");
			*sprite.rotation+=5;//旋转 sprite 对象。
			*}
		*private function onClickShape():void
		*{
			*trace("点击 shape 对象。");
			*shape.rotation+=5;//旋转 shape 对象。
			*}
		*}
	*}
*
*@example
*var sprite;
*var shape;
*Sprite_Example();
*function Sprite_Example()
*{
	*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
	*onInit();
	*}
*function onInit()
*{
	*sprite=new laya.display.Sprite();//创建一个 Sprite 类的实例对象 sprite 。
	*sprite.loadImage("resource/ui/bg.png");//加载并显示图片。
	*sprite.x=200;//设置 sprite 对象相对于父容器的水平方向坐标值。
	*sprite.y=200;//设置 sprite 对象相对于父容器的垂直方向坐标值。
	*sprite.pivotX=0;//设置 sprite 对象的水平方法轴心点坐标。
	*sprite.pivotY=0;//设置 sprite 对象的垂直方法轴心点坐标。
	*Laya.stage.addChild(sprite);//将此 sprite 对象添加到显示列表。
	*sprite.on(Event.CLICK,this,onClickSprite);//给 sprite 对象添加点击事件侦听。
	*shape=new laya.display.Sprite();//创建一个 Sprite 类的实例对象 sprite 。
	*shape.graphics.drawRect(0,0,100,100,"#ccff00","#ff0000",2);//绘制一个有边框的填充矩形。
	*shape.x=400;//设置 shape 对象相对于父容器的水平方向坐标值。
	*shape.y=200;//设置 shape 对象相对于父容器的垂直方向坐标值。
	*shape.width=100;//设置 shape 对象的宽度。
	*shape.height=100;//设置 shape 对象的高度。
	*shape.pivotX=50;//设置 shape 对象的水平方法轴心点坐标。
	*shape.pivotY=50;//设置 shape 对象的垂直方法轴心点坐标。
	*Laya.stage.addChild(shape);//将此 shape 对象添加到显示列表。
	*shape.on(laya.events.Event.CLICK,this,onClickShape);//给 shape 对象添加点击事件侦听。
	*}
*function onClickSprite()
*{
	*console.log("点击 sprite 对象。");
	*sprite.rotation+=5;//旋转 sprite 对象。
	*}
*function onClickShape()
*{
	*console.log("点击 shape 对象。");
	*shape.rotation+=5;//旋转 shape 对象。
	*}
*
*@example
*import Sprite=laya.display.Sprite;
*class Sprite_Example {
	*private sprite:Sprite;
	*private shape:Sprite
	*public Sprite_Example(){
		*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
		*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
		*this.onInit();
		*}
	*private onInit():void {
		*this.sprite=new Sprite();//创建一个 Sprite 类的实例对象 sprite 。
		*this.sprite.loadImage("resource/ui/bg.png");//加载并显示图片。
		*this.sprite.x=200;//设置 sprite 对象相对于父容器的水平方向坐标值。
		*this.sprite.y=200;//设置 sprite 对象相对于父容器的垂直方向坐标值。
		*this.sprite.pivotX=0;//设置 sprite 对象的水平方法轴心点坐标。
		*this.sprite.pivotY=0;//设置 sprite 对象的垂直方法轴心点坐标。
		*Laya.stage.addChild(this.sprite);//将此 sprite 对象添加到显示列表。
		*this.sprite.on(laya.events.Event.CLICK,this,this.onClickSprite);//给 sprite 对象添加点击事件侦听。
		*this.shape=new Sprite();//创建一个 Sprite 类的实例对象 sprite 。
		*this.shape.graphics.drawRect(0,0,100,100,"#ccff00","#ff0000",2);//绘制一个有边框的填充矩形。
		*this.shape.x=400;//设置 shape 对象相对于父容器的水平方向坐标值。
		*this.shape.y=200;//设置 shape 对象相对于父容器的垂直方向坐标值。
		*this.shape.width=100;//设置 shape 对象的宽度。
		*this.shape.height=100;//设置 shape 对象的高度。
		*this.shape.pivotX=50;//设置 shape 对象的水平方法轴心点坐标。
		*this.shape.pivotY=50;//设置 shape 对象的垂直方法轴心点坐标。
		*Laya.stage.addChild(this.shape);//将此 shape 对象添加到显示列表。
		*this.shape.on(laya.events.Event.CLICK,this,this.onClickShape);//给 shape 对象添加点击事件侦听。
		*}
	*private onClickSprite():void {
		*console.log("点击 sprite 对象。");
		*this.sprite.rotation+=5;//旋转 sprite 对象。
		*}
	*private onClickShape():void {
		*console.log("点击 shape 对象。");
		*this.shape.rotation+=5;//旋转 shape 对象。
		*}
	*}
*/
//class laya.display.Sprite extends laya.display.Node
var Sprite=(function(_super){
	function Sprite(){
		/**@private */
		this._x=0;
		/**@private */
		this._y=0;
		/**@private */
		this._width=0;
		/**@private */
		this._height=0;
		/**@private */
		this._visible=true;
		/**@private 鼠标状态，0:auto,1:mouseEnabled=false,2:mouseEnabled=true。*/
		this._mouseState=0;
		/**@private z排序，数值越大越靠前。*/
		this._zOrder=0;
		/**@private */
		this._renderType=0;
		/**@private */
		this._transform=null;
		/**@private */
		this._tfChanged=false;
		/**@private */
		this._texture=null;
		/**@private */
		this._boundStyle=null;
		/**@private */
		this._graphics=null;
		/**
		*<p>鼠标事件与此对象的碰撞检测是否可穿透。碰撞检测发生在鼠标事件的捕获阶段，此阶段引擎会从stage开始递归检测stage及其子对象，直到找到命中的目标对象或者未命中任何对象。</p>
		*<p>穿透表示鼠标事件发生的位置处于本对象绘图区域内时，才算命中，而与对象宽高和值为Rectangle对象的hitArea属性无关。如果sprite.hitArea值是HitArea对象，表示显式声明了此对象的鼠标事件响应区域，而忽略对象的宽高、mouseThrough属性。</p>
		*<p>影响对象鼠标事件响应区域的属性为：width、height、hitArea，优先级顺序为：hitArea(type:HitArea)>hitArea(type:Rectangle)>width/height。</p>
		*@default false 不可穿透，此对象的鼠标响应区域由width、height、hitArea属性决定。</p>
		*/
		this.mouseThrough=false;
		/**
		*<p>指定是否自动计算宽高数据。默认值为 false 。</p>
		*<p>Sprite宽高默认为0，并且不会随着绘制内容的变化而变化，如果想根据绘制内容获取宽高，可以设置本属性为true，或者通过getBounds方法获取。设置为true，对性能有一定影响。</p>
		*/
		this.autoSize=false;
		/**
		*<p>指定鼠标事件检测是优先检测自身，还是优先检测其子对象。鼠标事件检测发生在鼠标事件的捕获阶段，此阶段引擎会从stage开始递归检测stage及其子对象，直到找到命中的目标对象或者未命中任何对象。</p>
		*<p>如果为false，优先检测子对象，当有子对象被命中时，中断检测，获得命中目标。如果未命中任何子对象，最后再检测此对象；如果为true，则优先检测本对象，如果本对象没有被命中，直接中断检测，表示没有命中目标；如果本对象被命中，则进一步递归检测其子对象，以确认最终的命中目标。</p>
		*<p>合理使用本属性，能减少鼠标事件检测的节点，提高性能。可以设置为true的情况：开发者并不关心此节点的子节点的鼠标事件检测结果，也就是以此节点作为其子节点的鼠标事件检测依据。</p>
		*<p>Stage对象和UI的View组件默认为true。</p>
		*@default false 优先检测此对象的子对象，当递归检测完所有子对象后，仍然没有找到目标对象，最后再检测此对象。
		*/
		this.hitTestPrior=false;
		Sprite.__super.call(this);
		this._repaint=0;
		this._style=SpriteStyle.EMPTY;
		this._cacheStyle=CacheStyle.EMPTY;
	}

	__class(Sprite,'laya.display.Sprite',_super);
	var __proto=Sprite.prototype;
	/**@inheritDoc */
	__proto.destroy=function(destroyChild){
		(destroyChild===void 0)&& (destroyChild=true);
		_super.prototype.destroy.call(this,destroyChild);
		this._style && this._style.recover();
		this._cacheStyle && this._cacheStyle.recover();
		this._boundStyle && this._boundStyle.recover();
		this._style=null;
		this._cacheStyle=null;
		this._boundStyle=null;
		this._transform=null;
		this._graphics=null;
	}

	/**根据zOrder进行重新排序。*/
	__proto.updateZOrder=function(){
		Utils.updateOrder(this._children)&& this.repaint();
	}

	/**
	*@private
	*/
	__proto._getBoundsStyle=function(){
		if (!this._boundStyle)this._boundStyle=BoundsStyle.create();
		return this._boundStyle;
	}

	__proto._setCacheAs=function(value){}
	/**
	*更新_cnavas相关的状态
	*/
	__proto._checkCanvasEnable=function(){
		var tEnable=this._cacheStyle.needEnableCanvasRender();
		this._getCacheStyle().enableCanvasRender=tEnable;
		if (tEnable){
			if (this._cacheStyle.needBitmapCache()){
				this._cacheStyle.cacheAs="bitmap";
				}else {
				this._cacheStyle.cacheAs=this._cacheStyle.userSetCache;
			}
			this._cacheStyle.reCache=true;
			this._renderType |=0x08;
			}else {
			this._cacheStyle.cacheAs="none";
			this._cacheStyle.releaseContext();
			this._renderType &=~0x08;
		}
		this._setRenderType(this._renderType);
	}

	/**在设置cacheAs的情况下，调用此方法会重新刷新缓存。*/
	__proto.reCache=function(){
		this._cacheStyle.reCache=true;
		this._repaint |=0x02;
	}

	__proto._setX=function(value){
		this._x=value;
	}

	__proto._setY=function(value){
		this._y=value;
	}

	/**
	*设置对象bounds大小，如果有设置，则不再通过getBounds计算，合理使用能提高性能。
	*@param bound bounds矩形区域
	*/
	__proto.setSelfBounds=function(bound){
		this._getBoundsStyle().userBounds=bound;
	}

	/**
	*<p>获取本对象在父容器坐标系的矩形显示区域。</p>
	*<p><b>注意：</b>计算量较大，尽量少用。</p>
	*@return 矩形区域。
	*/
	__proto.getBounds=function(){
		return this._getBoundsStyle().bounds=Rectangle._getWrapRec(this._boundPointsToParent());
	}

	/**
	*获取本对象在自己坐标系的矩形显示区域。
	*<p><b>注意：</b>计算量较大，尽量少用。</p>
	*@return 矩形区域。
	*/
	__proto.getSelfBounds=function(){
		if (this._boundStyle && this._boundStyle.userBounds)return this._boundStyle.userBounds;
		if (!this._graphics && this._children.length===0)return Rectangle.TEMP.setTo(0,0,0,0);
		return this._getBoundsStyle().bounds=Rectangle._getWrapRec(this._getBoundPointsM(false));
	}

	/**
	*@private
	*获取本对象在父容器坐标系的显示区域多边形顶点列表。
	*当显示对象链中有旋转时，返回多边形顶点列表，无旋转时返回矩形的四个顶点。
	*@param ifRotate （可选）之前的对象链中是否有旋转。
	*@return 顶点列表。结构：[x1,y1,x2,y2,x3,y3,...]。
	*/
	__proto._boundPointsToParent=function(ifRotate){
		(ifRotate===void 0)&& (ifRotate=false);
		var pX=0,pY=0;
		if (this._style){
			ifRotate=ifRotate || (this._style.rotation!==0);
			if (this._style.scrollRect){
				pX+=this._style.scrollRect.x;
				pY+=this._style.scrollRect.y;
			}
		};
		var pList=this._getBoundPointsM(ifRotate);
		if (!pList || pList.length < 1)return pList;
		if (pList.length !=8){
			pList=ifRotate ? GrahamScan.scanPList(pList):Rectangle._getWrapRec(pList,Rectangle.TEMP)._getBoundPoints();
		}
		if (!this.transform){
			Utils.transPointList(pList,this._x-pX,this._y-pY);
			return pList;
		};
		var tPoint=Point.TEMP;
		var i=0,len=pList.length;
		for (i=0;i < len;i+=2){
			tPoint.x=pList[i];
			tPoint.y=pList[i+1];
			this.toParentPoint(tPoint);
			pList[i]=tPoint.x;
			pList[i+1]=tPoint.y;
		}
		return pList;
	}

	/**
	*返回此实例中的绘图对象（ <code>Graphics</code> ）的显示区域，不包括子对象。
	*@param realSize （可选）使用图片的真实大小，默认为false
	*@return 一个 Rectangle 对象，表示获取到的显示区域。
	*/
	__proto.getGraphicBounds=function(realSize){
		(realSize===void 0)&& (realSize=false);
		if (!this._graphics)return Rectangle.TEMP.setTo(0,0,0,0);
		return this._graphics.getBounds(realSize);
	}

	/**
	*@private
	*获取自己坐标系的显示区域多边形顶点列表
	*@param ifRotate （可选）当前的显示对象链是否由旋转
	*@return 顶点列表。结构：[x1,y1,x2,y2,x3,y3,...]。
	*/
	__proto._getBoundPointsM=function(ifRotate){
		(ifRotate===void 0)&& (ifRotate=false);
		if (this._boundStyle && this._boundStyle.userBounds)return this._boundStyle.userBounds._getBoundPoints();
		if (!this._boundStyle)this._getBoundsStyle();
		if (!this._boundStyle.temBM)this._boundStyle.temBM=[];
		if (this._style.scrollRect){
			var rst=Utils.clearArray(this._boundStyle.temBM);
			var rec=Rectangle.TEMP;
			rec.copyFrom(this._style.scrollRect);
			Utils.concatArray(rst,rec._getBoundPoints());
			return rst;
		};
		var pList;
		if (this._graphics){
			pList=this._graphics.getBoundPoints();
			}else {
			pList=Utils.clearArray(this._boundStyle.temBM);
		};
		var child;
		var cList;
		var __childs;
		__childs=this._children;
		for (var i=0,n=__childs.length;i < n;i++){
			child=__childs [i];
			if ((child instanceof laya.display.Sprite )&& child._visible===true){
				cList=child._boundPointsToParent(ifRotate);
				if (cList)
					pList=pList ? Utils.concatArray(pList,cList):cList;
			}
		}
		return pList;
	}

	/**
	*@private
	*获取cache数据。
	*@return cache数据 CacheStyle 。
	*/
	__proto._getCacheStyle=function(){
		this._cacheStyle===CacheStyle.EMPTY && (this._cacheStyle=CacheStyle.create());
		return this._cacheStyle;
	}

	/**
	*@private
	*获取样式。
	*@return 样式 Style 。
	*/
	__proto.getStyle=function(){
		this._style===SpriteStyle.EMPTY && (this._style=SpriteStyle.create());
		return this._style;
	}

	/**
	*@private
	*设置样式。
	*@param value 样式。
	*/
	__proto.setStyle=function(value){
		this._style=value;
	}

	__proto._setScaleX=function(value){
		this._style.scaleX=value;
	}

	__proto._setScaleY=function(value){
		this._style.scaleY=value;
	}

	__proto._setRotation=function(value){
		this._style.rotation=value;
	}

	__proto._setSkewX=function(value){
		this._style.skewX=value;
	}

	__proto._setSkewY=function(value){
		this._style.skewY=value;
	}

	__proto._createTransform=function(){
		return Matrix.create();
	}

	/**@private */
	__proto._adjustTransform=function(){
		'use strict';
		this._tfChanged=false;
		var style=this._style;
		var sx=style.scaleX,sy=style.scaleY;
		var m;
		if (style.rotation || sx!==1 || sy!==1 || style.skewX || style.skewY){
			m=this._transform || (this._transform=this._createTransform());
			m._bTransform=true;
			var skx=(style.rotation-style.skewX)*0.0174532922222222;
			var sky=(style.rotation+style.skewY)*0.0174532922222222;
			var cx=Math.cos(sky);
			var ssx=Math.sin(sky);
			var cy=Math.sin(skx);
			var ssy=Math.cos(skx);
			m.a=sx *cx;
			m.b=sx *ssx;
			m.c=-sy *cy;
			m.d=sy *ssy;
			m.tx=m.ty=0;
			return m;
			}else {
			this._transform && this._transform.destroy();
			this._transform=null;
			this._renderType &=~0x02;
			this._setRenderType(this._renderType);
		}
		return m;
	}

	__proto._setPivotX=function(value){
		var style=this.getStyle();
		style.pivotX=value;
	}

	__proto._getPivotX=function(){
		return this._style.pivotX;
	}

	__proto._setPivotY=function(value){
		var style=this.getStyle();
		style.pivotY=value;
	}

	__proto._getPivotY=function(){
		return this._style.pivotY;
	}

	__proto._setAlpha=function(value){
		if (this._style.alpha!==value){
			var style=this.getStyle();
			style.alpha=value;
			if (value!==1)this._renderType |=0x01;
			else this._renderType &=~0x01;
			this._setRenderType(this._renderType);
			this.parentRepaint();
		}
	}

	__proto._getAlpha=function(){
		return this._style.alpha;
	}

	__proto._setGraphics=function(value){}
	__proto.setLayaGL3D=function(value){
		if (value){
			if (Render.isConchApp){
				this.data._int32Data[7]=value._buffer._buffer["_ptrID"];
			}
			this._renderType |=0x400;
		}
		else{
			this._renderType &=~0x400;
		}
		this._setRenderType(this._renderType);
		this.repaint();
	}

	/**
	*<p>设置坐标位置。相当于分别设置x和y属性。</p>
	*<p>因为返回值为Sprite对象本身，所以可以使用如下语法：spr.pos(...).scale(...);</p>
	*@param x X轴坐标。
	*@param y Y轴坐标。
	*@param speedMode （可选）是否极速模式，正常是调用this.x=value进行赋值，极速模式直接调用内部函数处理，如果未重写x,y属性，建议设置为急速模式性能更高。
	*@return 返回对象本身。
	*/
	__proto.pos=function(x,y,speedMode){
		(speedMode===void 0)&& (speedMode=false);
		if (this._x!==x || this._y!==y){
			if (this.destroyed)return this;
			if (speedMode){
				this._setX(x);
				this._setY(y);
				var p=this._parent;
				if (p && !(p._repaint&0x02)){
					p._repaint |=0x02;
					p.parentRepaint();
				}
				if (this._cacheStyle.maskParent){
					p=this._cacheStyle.maskParent;
					if(!(p._repaint&0x02)){
						p._repaint |=0x02;
						p.parentRepaint();
					}
				}
				}else {
				this.x=x;
				this.y=y;
			}
		}
		return this;
	}

	/**
	*<p>设置轴心点。相当于分别设置pivotX和pivotY属性。</p>
	*<p>因为返回值为Sprite对象本身，所以可以使用如下语法：spr.pivot(...).pos(50,100);</p>
	*@param x X轴心点。
	*@param y Y轴心点。
	*@return 返回对象本身。
	*/
	__proto.pivot=function(x,y){
		this.pivotX=x;
		this.pivotY=y;
		return this;
	}

	/**
	*<p>设置宽高。相当于分别设置width和height属性。</p>
	*<p>因为返回值为Sprite对象本身，所以可以使用如下语法：spr.size(...).pos(50,100);</p>
	*@param width 宽度值。
	*@param hegiht 高度值。
	*@return 返回对象本身。
	*/
	__proto.size=function(width,height){
		this.width=width;
		this.height=height;
		return this;
	}

	/**
	*<p>设置缩放。相当于分别设置scaleX和scaleY属性。</p>
	*<p>因为返回值为Sprite对象本身，所以可以使用如下语法：spr.scale(...).pos(50,100);</p>
	*@param scaleX X轴缩放比例。
	*@param scaleY Y轴缩放比例。
	*@param speedMode （可选）是否极速模式，正常是调用this.scaleX=value进行赋值，极速模式直接调用内部函数处理，如果未重写scaleX,scaleY属性，建议设置为急速模式性能更高。
	*@return 返回对象本身。
	*/
	__proto.scale=function(scaleX,scaleY,speedMode){
		(speedMode===void 0)&& (speedMode=false);
		var style=this.getStyle();
		if (style.scaleX !=scaleX || style.scaleY !=scaleY){
			if (this.destroyed)return this;
			if (speedMode){
				this._setScaleX(scaleX);
				this._setScaleY(scaleY);
				this._setTranformChange();
				}else {
				this.scaleX=scaleX;
				this.scaleY=scaleY;
			}
		}
		return this;
	}

	/**
	*<p>设置倾斜角度。相当于分别设置skewX和skewY属性。</p>
	*<p>因为返回值为Sprite对象本身，所以可以使用如下语法：spr.skew(...).pos(50,100);</p>
	*@param skewX 水平倾斜角度。
	*@param skewY 垂直倾斜角度。
	*@return 返回对象本身
	*/
	__proto.skew=function(skewX,skewY){
		this.skewX=skewX;
		this.skewY=skewY;
		return this;
	}

	/**
	*更新、呈现显示对象。由系统调用。
	*@param context 渲染的上下文引用。
	*@param x X轴坐标。
	*@param y Y轴坐标。
	*/
	__proto.render=function(context,x,y){
		Stat.spriteCount++;
		RenderSprite.renders[this._renderType]._fun(this,context,x+this._x,y+this._y);
		this._repaint=0;
	}

	__proto.renderToNative=function(context){
		if ((this._repaint & 0x01)==0x01 || this.data._int32Data[24]==0){
			var gl=LayaGL2DTemplateCreater.GLS[this._renderType] || LayaGL2DTemplateCreater.createByRenderType(this._renderType);
			if (this._children.length > 0){
				context.blockStart(this.data);
				this._renderChilds(context);
				context.blockEnd(this.data);
			}
			else{
				context.blockOne(this.data);
			}
		}
		else{
			context.copyCmdBuffer(this.data._int32Data[23],this.data._int32Data[24]);
		}
		this._repaint=0;
	}

	__proto._renderChilds=function(context){
		var childs=this._children,ele;
		var i=0,n=childs.length;
		var style=this._style;
		if (style.viewport){
			var rect=style.viewport;
			var left=rect.x;
			var top=rect.y;
			var right=rect.right;
			var bottom=rect.bottom;
			var _x=NaN,_y=NaN;
			for (;i < n;++i){
				if ((ele=childs[i])._visible && ((_x=ele._x)< right && (_x+ele.width)> left && (_y=ele._y)< bottom && (_y+ele.height)> top))
					ele.renderToNative(context);
			}
			}else {
			for (;i < n;++i)
			(ele=childs[i])._visible && ele.renderToNative(context);
		}
	}

	/**
	*<p>绘制 当前<code>Sprite</code> 到 <code>Canvas</code> 上，并返回一个HtmlCanvas。</p>
	*<p>绘制的结果可以当作图片源，再次绘制到其他Sprite里面，示例：</p>
	*
	*var htmlCanvas:HTMLCanvas=sprite.drawToCanvas(100,100,0,0);//把精灵绘制到canvas上面
	*var texture:Texture=new Texture(htmlCanvas);//使用htmlCanvas创建Texture
	*var sp:Sprite=new Sprite().pos(0,200);//创建精灵并把它放倒200位置
	*sp.graphics.drawImage(texture);//把截图绘制到精灵上
	*Laya.stage.addChild(sp);//把精灵显示到舞台
	*
	*<p>也可以获取原始图片数据，分享到网上，从而实现截图效果，示例：</p>
	*
	*var htmlCanvas:HTMLCanvas=sprite.drawToCanvas(100,100,0,0);//把精灵绘制到canvas上面
	*var canvas:*=htmlCanvas.getCanvas();//获取原生的canvas对象
	*trace(canvas.toDataURL("image/png"));//打印图片base64信息，可以发给服务器或者保存为图片
	*
	*@param canvasWidth 画布宽度。
	*@param canvasHeight 画布高度。
	*@param x 绘制的 X 轴偏移量。
	*@param y 绘制的 Y 轴偏移量。
	*@return HTMLCanvas 对象。
	*/
	__proto.drawToCanvas=function(canvasWidth,canvasHeight,offsetX,offsetY){
		return RunDriver.drawToCanvas(this,this._renderType,canvasWidth,canvasHeight,offsetX,offsetY);
	}

	/**
	*<p>自定义更新、呈现显示对象。一般用来扩展渲染模式，请合理使用，可能会导致在加速器上无法渲染。</p>
	*<p><b>注意</b>不要在此函数内增加或删除树节点，否则会对树节点遍历造成影响。</p>
	*@param context 渲染的上下文引用。
	*@param x X轴坐标。
	*@param y Y轴坐标。
	*/
	__proto.customRender=function(context,x,y){
		this._renderType |=0x800;
		this._setRenderType(this._renderType);
	}

	/**
	*@private
	*应用滤镜。
	*/
	__proto._applyFilters=function(){
		if (Render.isWebGL)return;
		var _filters;
		_filters=this._cacheStyle.filters;
		if (!_filters || _filters.length < 1)return;
		for (var i=0,n=_filters.length;i < n;i++){
			_filters[i].action.apply(this._cacheStyle);
		}
	}

	/**
	*@private
	*查看当前原件中是否包含发光滤镜。
	*@return 一个 Boolean 值，表示当前原件中是否包含发光滤镜。
	*/
	__proto._isHaveGlowFilter=function(){
		var i=0,len=0;
		if (this.filters){
			for (i=0;i < this.filters.length;i++){
				if (this.filters[i].type==0x08){
					return true;
				}
			}
		}
		for (i=0,len=this._children.length;i < len;i++){
			if (this._children[i]._isHaveGlowFilter()){
				return true;
			}
		}
		return false;
	}

	/**
	*把本地坐标转换为相对stage的全局坐标。
	*@param point 本地坐标点。
	*@param createNewPoint （可选）是否创建一个新的Point对象作为返回值，默认为false，使用输入的point对象返回，减少对象创建开销。
	*@return 转换后的坐标的点。
	*/
	__proto.localToGlobal=function(point,createNewPoint){
		(createNewPoint===void 0)&& (createNewPoint=false);
		if (createNewPoint===true){
			point=new Point(point.x,point.y);
		};
		var ele=this;
		while (ele){
			if (ele==Laya.stage)break ;
			point=ele.toParentPoint(point);
			ele=ele.parent;
		}
		return point;
	}

	/**
	*把stage的全局坐标转换为本地坐标。
	*@param point 全局坐标点。
	*@param createNewPoint （可选）是否创建一个新的Point对象作为返回值，默认为false，使用输入的point对象返回，减少对象创建开销。
	*@return 转换后的坐标的点。
	*/
	__proto.globalToLocal=function(point,createNewPoint){
		(createNewPoint===void 0)&& (createNewPoint=false);
		if (createNewPoint){
			point=new Point(point.x,point.y);
		};
		var ele=this;
		var list=[];
		while (ele){
			if (ele==Laya.stage)break ;
			list.push(ele);
			ele=ele.parent;
		};
		var i=list.length-1;
		while (i >=0){
			ele=list[i];
			point=ele.fromParentPoint(point);
			i--;
		}
		return point;
	}

	/**
	*将本地坐标系坐标转转换到父容器坐标系。
	*@param point 本地坐标点。
	*@return 转换后的点。
	*/
	__proto.toParentPoint=function(point){
		if (!point)return point;
		if (this.transform){
			this._transform.transformPoint(point);
		}
		point.x+=this._x;
		point.y+=this._y;
		var scroll=this._style.scrollRect;
		if (scroll){
			point.x-=scroll.x;
			point.y-=scroll.y;
		}
		return point;
	}

	/**
	*将父容器坐标系坐标转换到本地坐标系。
	*@param point 父容器坐标点。
	*@return 转换后的点。
	*/
	__proto.fromParentPoint=function(point){
		if (!point)return point;
		point.x-=this._x;
		point.y-=this._y;
		var scroll=this._style.scrollRect;
		if (scroll){
			point.x+=scroll.x;
			point.y+=scroll.y;
		}
		if (this.transform){
			this._transform.invertTransformPoint(point);
		}
		return point;
	}

	/**
	*<p>增加事件侦听器，以使侦听器能够接收事件通知。</p>
	*<p>如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnabled 的值为 true(如果父节点mouseEnabled=false，则停止设置父节点mouseEnabled属性)。</p>
	*@param type 事件的类型。
	*@param caller 事件侦听函数的执行域。
	*@param listener 事件侦听函数。
	*@param args （可选）事件侦听函数的回调参数。
	*@return 此 EventDispatcher 对象。
	*/
	__proto.on=function(type,caller,listener,args){
		if (this._mouseState!==1 && this.isMouseEvent(type)){
			this.mouseEnabled=true;
			this._setBit(0x04,true);
			if (this._parent){
				this._onDisplay();
			}
			return this._createListener(type,caller,listener,args,false);
		}
		return _super.prototype.on.call(this,type,caller,listener,args);
	}

	/**
	*<p>增加事件侦听器，以使侦听器能够接收事件通知，此侦听事件响应一次后则自动移除侦听。</p>
	*<p>如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnabled 的值为 true(如果父节点mouseEnabled=false，则停止设置父节点mouseEnabled属性)。</p>
	*@param type 事件的类型。
	*@param caller 事件侦听函数的执行域。
	*@param listener 事件侦听函数。
	*@param args （可选）事件侦听函数的回调参数。
	*@return 此 EventDispatcher 对象。
	*/
	__proto.once=function(type,caller,listener,args){
		if (this._mouseState!==1 && this.isMouseEvent(type)){
			this.mouseEnabled=true;
			this._setBit(0x04,true);
			if (this._parent){
				this._onDisplay();
			}
			return this._createListener(type,caller,listener,args,true);
		}
		return _super.prototype.once.call(this,type,caller,listener,args);
	}

	/**@private */
	__proto._onDisplay=function(){
		if (this._mouseState!==1){
			var ele=this;
			ele=ele.parent;
			while (ele && ele._mouseState!==1){
				if (ele._getBit(0x04))break ;
				ele.mouseEnabled=true;
				ele._setBit(0x04,true);
				ele=ele.parent;
			}
		}
	}

	__proto._setParent=function(value){
		_super.prototype._setParent.call(this,value);
		if (value && this._getBit(0x04)){
			this._onDisplay();
		}
	}

	/**
	*<p>加载并显示一个图片。功能等同于graphics.loadImage方法。支持异步加载。</p>
	*<p>注意：多次调用loadImage绘制不同的图片，会同时显示。</p>
	*@param url 图片地址。
	*@param x （可选）显示图片的x位置。
	*@param y （可选）显示图片的y位置。
	*@param width （可选）显示图片的宽度，设置为0表示使用图片默认宽度。
	*@param height （可选）显示图片的高度，设置为0表示使用图片默认高度。
	*@param complete （可选）加载完成回调。
	*@return 返回精灵对象本身。
	*/
	__proto.loadImage=function(url,x,y,width,height,complete){
		var _$this=this;
		(x===void 0)&& (x=0);
		(y===void 0)&& (y=0);
		(width===void 0)&& (width=0);
		(height===void 0)&& (height=0);
		function loaded (tex){
			if (!_$this.destroyed){
				_$this.repaint();
				complete && complete.runWith(tex);
			}
		}
		this.graphics.loadImage(url,x,y,width,height,loaded);
		return this;
	}

	/**cacheAs后，设置自己和父对象缓存失效。*/
	__proto.repaint=function(type){
		(type===void 0)&& (type=0x02);
		if (!(this._repaint&type)){
			this._repaint |=type;
			this.parentRepaint(type);
		}
		if (this._cacheStyle && this._cacheStyle.maskParent){
			this._cacheStyle.maskParent.repaint(type);
		}
	}

	/**
	*@private
	*获取是否重新缓存。
	*@return 如果重新缓存值为 true，否则值为 false。
	*/
	__proto._needRepaint=function(){
		return (this._repaint&0x02)&& this._cacheStyle.enableCanvasRender && this._cacheStyle.reCache;
	}

	/**@private */
	__proto._childChanged=function(child){
		if (this._children.length)this._renderType |=0x2000;
		else this._renderType &=~0x2000;
		this._setRenderType(this._renderType);
		if (child && this._getBit(0x02))Laya.timer.callLater(this,this.updateZOrder);
		this.repaint(0x03);
	}

	/**cacheAs时，设置所有父对象缓存失效。 */
	__proto.parentRepaint=function(type){
		(type===void 0)&& (type=0x02);
		var p=this._parent;
		if (p && !(p._repaint&type)){
			p._repaint |=type;
			p.parentRepaint(type);
		}
	}

	/**
	*开始拖动此对象。
	*@param area （可选）拖动区域，此区域为当前对象注册点活动区域（不包括对象宽高），可选。
	*@param hasInertia （可选）鼠标松开后，是否还惯性滑动，默认为false，可选。
	*@param elasticDistance （可选）橡皮筋效果的距离值，0为无橡皮筋效果，默认为0，可选。
	*@param elasticBackTime （可选）橡皮筋回弹时间，单位为毫秒，默认为300毫秒，可选。
	*@param data （可选）拖动事件携带的数据，可选。
	*@param disableMouseEvent （可选）禁用其他对象的鼠标检测，默认为false，设置为true能提高性能。
	*@param ratio （可选）惯性阻尼系数，影响惯性力度和时长。
	*/
	__proto.startDrag=function(area,hasInertia,elasticDistance,elasticBackTime,data,disableMouseEvent,ratio){
		(hasInertia===void 0)&& (hasInertia=false);
		(elasticDistance===void 0)&& (elasticDistance=0);
		(elasticBackTime===void 0)&& (elasticBackTime=300);
		(disableMouseEvent===void 0)&& (disableMouseEvent=false);
		(ratio===void 0)&& (ratio=0.92);
		this._style.dragging || (this.getStyle().dragging=new Dragging());
		this._style.dragging.start(this,area,hasInertia,elasticDistance,elasticBackTime,data,disableMouseEvent,ratio);
	}

	/**停止拖动此对象。*/
	__proto.stopDrag=function(){
		this._style.dragging && this._style.dragging.stop();
	}

	/**@private */
	__proto._setDisplay=function(value){
		if (!value){
			this._cacheStyle.releaseContext();
			this._cacheStyle.releaseFilterCache();
			if (this._cacheStyle.hasGlowFilter){
				this._cacheStyle.hasGlowFilter=false;
			}
		}
		_super.prototype._setDisplay.call(this,value);
	}

	/**
	*检测某个点是否在此对象内。
	*@param x 全局x坐标。
	*@param y 全局y坐标。
	*@return 表示是否在对象内。
	*/
	__proto.hitTestPoint=function(x,y){
		var point=this.globalToLocal(Point.TEMP.setTo(x,y));
		x=point.x;
		y=point.y;
		var rect=this._style.hitArea ? this._style.hitArea :(this._width > 0 && this._height > 0)? Rectangle.TEMP.setTo(0,0,this._width,this._height):this.getSelfBounds();
		return rect.contains(x,y);
	}

	/**获得相对于本对象上的鼠标坐标信息。*/
	__proto.getMousePoint=function(){
		return this.globalToLocal(Point.TEMP.setTo(Laya.stage.mouseX,Laya.stage.mouseY));
	}

	__proto._setTexture=function(value){}
	__proto._setRenderType=function(type){}
	__proto._setTranformChange=function(){
		this._tfChanged=true;
		this._renderType |=0x02
		this._setRenderType(this._renderType);
		var p=this._parent;
		if (p && !(p._repaint&0x02)){
			p._repaint |=0x02;
			p.parentRepaint();
		}
	}

	/**
	*设置是否开启自定义渲染，只有开启自定义渲染，才能使用customRender函数渲染。
	*/
	__getset(0,__proto,'customRenderEnable',null,function(b){
		if (b){
			this._renderType |=0x800;
			this._setRenderType(this._renderType);
		}
	});

	//_dataf32[SpriteConst.POSCACHE]=value=="bitmap"?2:(value=="normal"?1:0);
	/**
	*<p>指定显示对象是否缓存为静态图像，cacheAs时，子对象发生变化，会自动重新缓存，同时也可以手动调用reCache方法更新缓存。</p>
	*<p>建议把不经常变化的“复杂内容”缓存为静态图像，能极大提高渲染性能。cacheAs有"none"，"normal"和"bitmap"三个值可选。
	*<li>默认为"none"，不做任何缓存。</li>
	*<li>当值为"normal"时，canvas模式下进行画布缓存，webgl模式下进行命令缓存。</li>
	*<li>当值为"bitmap"时，canvas模式下进行依然是画布缓存，webgl模式下使用renderTarget缓存。</li></p>
	*<p>webgl下renderTarget缓存模式缺点：会额外创建renderTarget对象，增加内存开销，缓存面积有最大2048限制，不断重绘时会增加CPU开销。优点：大幅减少drawcall，渲染性能最高。
	*webgl下命令缓存模式缺点：只会减少节点遍历及命令组织，不会减少drawcall数，性能中等。优点：没有额外内存开销，无需renderTarget支持。</p>
	*/
	__getset(0,__proto,'cacheAs',function(){
		return this._cacheStyle.cacheAs;
		},function(value){
		if (value===this._cacheStyle.userSetCache)return;
		this._setCacheAs(value);
		this._getCacheStyle().userSetCache=value;
		this._checkCanvasEnable();
		this.repaint();
	});

	/**z排序，更改此值，则会按照值的大小对同一容器的所有对象重新排序。值越大，越靠上。默认为0，则根据添加顺序排序。*/
	__getset(0,__proto,'zOrder',function(){
		return this._zOrder;
		},function(value){
		if (this._zOrder !=value){
			this._zOrder=value;
			if (this._parent){
				value && this._parent._setBit(0x02,true);
				Laya.timer.callLater(this._parent,this.updateZOrder);
			}
		}
	});

	/**旋转角度，默认值为0。以角度为单位。*/
	__getset(0,__proto,'rotation',function(){
		return this._style.rotation;
		},function(value){
		var style=this.getStyle();
		if (style.rotation!==value){
			this._setRotation(value);
			this._setTranformChange();
		}
	});

	/**
	*<p>显示对象的宽度，单位为像素，默认为0。</p>
	*<p>此宽度用于鼠标碰撞检测，并不影响显示对象图像大小。需要对显示对象的图像进行缩放，请使用scale、scaleX、scaleY。</p>
	*<p>可以通过getbounds获取显示对象图像的实际宽度。</p>
	*/
	__getset(0,__proto,'width',function(){
		if (!this.autoSize)return this._width;
		if (!this._graphics && this._children.length===0)return 0;
		return this.getSelfBounds().width;
		},function(value){
		if (this._width!==value){
			this._width=value;
			this.repaint();
		}
	});

	/**表示显示对象相对于父容器的水平方向坐标值。*/
	__getset(0,__proto,'x',function(){
		return this._x;
		},function(value){
		if (this.destroyed)return;
		if (this._x!==value){
			this._setX(value);
			var p=this._parent;
			if (p && !(p._repaint&0x02)){
				p._repaint |=0x02;
				p.parentRepaint();
			}
			p=this._cacheStyle.maskParent;
			if (p && !(p._repaint&0x02)){
				p._repaint |=0x02;
				p.parentRepaint();
			}
		}
	});

	/**
	*获得相对于stage的全局Y轴缩放值（会叠加父亲节点的缩放值）。
	*/
	__getset(0,__proto,'globalScaleY',function(){
		var scale=1;
		var ele=this;
		while (ele){
			if (ele===Laya.stage)break ;
			scale *=ele.scaleY;
			ele=ele.parent;
		}
		return scale;
	});

	/**
	*<p>可以设置一个Rectangle区域作为点击区域，或者设置一个<code>HitArea</code>实例作为点击区域，HitArea内可以设置可点击和不可点击区域。</p>
	*<p>如果不设置hitArea，则根据宽高形成的区域进行碰撞。</p>
	*/
	__getset(0,__proto,'hitArea',function(){
		return this._style.hitArea;
		},function(value){
		this.getStyle().hitArea=value;
	});

	/**设置cacheAs为非空时此值才有效，staticCache=true时，子对象变化时不会自动更新缓存，只能通过调用reCache方法手动刷新。*/
	__getset(0,__proto,'staticCache',function(){
		return this._cacheStyle.staticCache;
		},function(value){
		this._getCacheStyle().staticCache=value;
		if (!value)this.reCache();
	});

	/**设置一个Texture实例，并显示此图片（如果之前有其他绘制，则会被清除掉）。等同于graphics.clear();graphics.drawImage()*/
	__getset(0,__proto,'texture',function(){
		return this._texture;
		},function(value){
		if (this._texture !=value){
			this._texture=value;
			this._setTexture(value);
			if (value)this._renderType |=0x100;
			else this._renderType &=~0x100;
			this._setRenderType(this._renderType);
		}
	});

	/**表示显示对象相对于父容器的垂直方向坐标值。*/
	__getset(0,__proto,'y',function(){
		return this._y;
		},function(value){
		if (this.destroyed)return;
		if (this._y!==value){
			this._setY(value);
			var p=this._parent;
			if (p && !(p._repaint&0x02)){
				p._repaint |=0x02;
				p.parentRepaint();
			}
			p=this._cacheStyle.maskParent;
			if (p && !(p._repaint&0x02)){
				p._repaint |=0x02;
				p.parentRepaint();
			}
		}
	});

	/**
	*<p>显示对象的高度，单位为像素，默认为0。</p>
	*<p>此高度用于鼠标碰撞检测，并不影响显示对象图像大小。需要对显示对象的图像进行缩放，请使用scale、scaleX、scaleY。</p>
	*<p>可以通过getbounds获取显示对象图像的实际高度。</p>
	*/
	__getset(0,__proto,'height',function(){
		if (!this.autoSize)return this._height;
		if (!this._graphics && this._children.length===0)return 0;
		return this.getSelfBounds().height;
		},function(value){
		if (this._height!==value){
			this._height=value;
			this.repaint();
		}
	});

	/**指定要使用的混合模式。目前只支持"lighter"。*/
	__getset(0,__proto,'blendMode',function(){
		return this._style.blendMode;
		},function(value){
		this.getStyle().blendMode=value;
		if (value && value !="source-over")this._renderType |=0x04;
		else this._renderType &=~0x04;
		this._setRenderType(this._renderType);
		this.parentRepaint();
	});

	/**X轴缩放值，默认值为1。设置为负数，可以实现水平反转效果，比如scaleX=-1。*/
	__getset(0,__proto,'scaleX',function(){
		return this._style.scaleX;
		},function(value){
		var style=this.getStyle();
		if (style.scaleX!==value){
			this._setScaleX(value);
			this._setTranformChange();
		}
	});

	/**Y轴缩放值，默认值为1。设置为负数，可以实现垂直反转效果，比如scaleX=-1。*/
	__getset(0,__proto,'scaleY',function(){
		return this._style.scaleY;
		},function(value){
		var style=this.getStyle();
		if (style.scaleY!==value){
			this._setScaleY(value);
			this._setTranformChange();
		}
	});

	/**对舞台 <code>stage</code> 的引用。*/
	__getset(0,__proto,'stage',function(){
		return Laya.stage;
	});

	/**水平倾斜角度，默认值为0。以角度为单位。*/
	__getset(0,__proto,'skewX',function(){
		return this._style.skewX;
		},function(value){
		var style=this.getStyle();
		if (style.skewX!==value){
			this._setSkewX(value);
			this._setTranformChange();
		}
	});

	/**
	*<p>显示对象的滚动矩形范围，具有裁剪效果(如果只想限制子对象渲染区域，请使用viewport)</p>
	*<p> srollRect和viewport的区别：<br/>
	*1.srollRect自带裁剪效果，viewport只影响子对象渲染是否渲染，不具有裁剪效果（性能更高）。<br/>
	*2.设置rect的x,y属性均能实现区域滚动效果，但scrollRect会保持0,0点位置不变。</p>
	*/
	__getset(0,__proto,'scrollRect',function(){
		return this._style.scrollRect;
		},function(value){
		this.getStyle().scrollRect=value;
		this.repaint();
		if (value){
			this._renderType |=0x40;
			}else {
			this._renderType &=~0x40;
		}
		this._setRenderType(this._renderType);
	});

	/**垂直倾斜角度，默认值为0。以角度为单位。*/
	__getset(0,__proto,'skewY',function(){
		return this._style.skewY;
		},function(value){
		var style=this.getStyle();
		if (style.skewY!==value){
			this._setSkewY(value);
			this._setTranformChange();
		}
	});

	/**
	*<p>对象的矩阵信息。通过设置矩阵可以实现节点旋转，缩放，位移效果。</p>
	*<p>矩阵更多信息请参考 <code>Matrix</code></p>
	*/
	__getset(0,__proto,'transform',function(){
		return this._tfChanged ? this._adjustTransform():this._transform;
		},function(value){
		this._tfChanged=false;
		var m=this._transform || (this._transform=this._createTransform());
		value.copyTo(m);
		if (value){
			this._x=value.tx;
			this._y=value.ty;
			value.tx=value.ty=0;
		}
		if (value)this._renderType |=0x02;
		else {
			this._renderType &=~0x02;
		}
		this._setRenderType(this._renderType);
		this.parentRepaint();
	});

	/**X轴 轴心点的位置，单位为像素，默认为0。轴心点会影响对象位置，缩放中心，旋转中心。*/
	__getset(0,__proto,'pivotX',function(){
		return this._getPivotX();
		},function(value){
		this._setPivotX(value);
		this.repaint();
	});

	/**Y轴 轴心点的位置，单位为像素，默认为0。轴心点会影响对象位置，缩放中心，旋转中心。*/
	__getset(0,__proto,'pivotY',function(){
		return this._getPivotY();
		},function(value){
		this._setPivotY(value);
		this.repaint();
	});

	/**透明度，值为0-1，默认值为1，表示不透明。更改alpha值会影响drawcall。*/
	__getset(0,__proto,'alpha',function(){
		return this._getAlpha();
		},function(value){
		value=value < 0 ? 0 :(value > 1 ? 1 :value);
		this._setAlpha(value);
	});

	/**表示是否可见，默认为true。如果设置不可见，节点将不被渲染。*/
	__getset(0,__proto,'visible',function(){
		return this._visible;
		},function(value){
		if (this._visible!==value){
			this._visible=value;
			this.parentRepaint();
		}
	});

	/**绘图对象。封装了绘制位图和矢量图的接口，Sprite所有的绘图操作都通过Graphics来实现的。*/
	__getset(0,__proto,'graphics',function(){
		return this._graphics || (this.graphics=RunDriver.createGraphics());
		},function(value){
		if (this._graphics)this._graphics._sp=null;
		this._graphics=value;
		if (value){
			this._setGraphics(value);
			this._renderType |=0x200;
			value._sp=this;
			}else {
			this._renderType &=~0x200;
		}
		this._setRenderType(this._renderType);
		this.repaint();
	});

	/**滤镜集合。可以设置多个滤镜组合。*/
	__getset(0,__proto,'filters',function(){
		return this._cacheStyle.filters;
		},function(value){
		value && value.length===0 && (value=null);
		if (this._cacheStyle.filters==value)return;
		this._getCacheStyle().filters=value ? value.slice():null;
		if (Render.isWebGL){
			if (value && value.length){
				this._renderType |=0x10;
				}else {
				this._renderType &=~0x10;
			}
			this._setRenderType(this._renderType);
		}
		if (value && value.length > 0){
			if (!this._getBit(0x01))this._setBitUp(0x01);
			if (!(Render.isWebGL && value.length==1 && (((value[0])instanceof laya.filters.ColorFilter )))){
				this._getCacheStyle().cacheForFilters=true;
				this._checkCanvasEnable();
			}
			}else {
			if (this._cacheStyle.cacheForFilters){
				this._cacheStyle.cacheForFilters=false;
				this._checkCanvasEnable();
			}
		}
		this.repaint();
	});

	/**
	*<p>遮罩，可以设置一个对象(支持位图和矢量图)，根据对象形状进行遮罩显示。</p>
	*<p>【注意】遮罩对象坐标系是相对遮罩对象本身的，和Flash机制不同</p>
	*/
	__getset(0,__proto,'mask',function(){
		return this._cacheStyle.mask;
		},function(value){
		if (value && this.mask && this.mask._cacheStyle.maskParent)return;
		this._getCacheStyle().mask=value;
		this._checkCanvasEnable();
		if (value){
			value._getCacheStyle().maskParent=this;
			}else {
			if (this.mask){
				this.mask._getCacheStyle().maskParent=null;
			}
		}
		this._renderType |=0x20;
		this._setRenderType(this._renderType);
		this.parentRepaint();
	});

	/**
	*是否接受鼠标事件。
	*默认为false，如果监听鼠标事件，则会自动设置本对象及父节点的属性 mouseEnable 的值都为 true（如果父节点手动设置为false，则不会更改）。
	**/
	__getset(0,__proto,'mouseEnabled',function(){
		return this._mouseState > 1;
		},function(value){
		this._mouseState=value ? 2 :1;
	});

	/**
	*获得相对于stage的全局X轴缩放值（会叠加父亲节点的缩放值）。
	*/
	__getset(0,__proto,'globalScaleX',function(){
		var scale=1;
		var ele=this;
		while (ele){
			if (ele===Laya.stage)break ;
			scale *=ele.scaleX;
			ele=ele.parent;
		}
		return scale;
	});

	/**
	*返回鼠标在此对象坐标系上的 X 轴坐标信息。
	*/
	__getset(0,__proto,'mouseX',function(){
		return this.getMousePoint().x;
	});

	/**
	*返回鼠标在此对象坐标系上的 Y 轴坐标信息。
	*/
	__getset(0,__proto,'mouseY',function(){
		return this.getMousePoint().y;
	});

	/**
	*<p>视口大小，视口外的子对象，将不被渲染(如果想实现裁剪效果，请使用srollRect)，合理使用能提高渲染性能。比如由一个个小图片拼成的地图块，viewport外面的小图片将不渲染</p>
	*<p>srollRect和viewport的区别：<br/>
	*1. srollRect自带裁剪效果，viewport只影响子对象渲染是否渲染，不具有裁剪效果（性能更高）。<br/>
	*2. 设置rect的x,y属性均能实现区域滚动效果，但scrollRect会保持0,0点位置不变。</p>
	*@default null
	*/
	__getset(0,__proto,'viewport',function(){
		return this._style.viewport;
		},function(value){
		this.getStyle().viewport=value;
	});

	Sprite.fromImage=function(url){
		return new Sprite().loadImage(url);
	}

	return Sprite;
})(Node)


	//file:///E:/git/layaair-master/core/src/laya/runtime/ConchSpriteAdpt.as=======97.999843/97.999843
/**
*...
*@author ww
*/
//class laya.runtime.ConchSpriteAdpt extends laya.display.Node
var ConchSpriteAdpt=(function(_super){
	function ConchSpriteAdpt(){
		this._dataf32=null;
		this._datai32=null;
		/**@private */
		this._x=0;
		/**@private */
		this._y=0;
		/**@private */
		this._renderType=0;
		ConchSpriteAdpt.__super.call(this);
	}

	__class(ConchSpriteAdpt,'laya.runtime.ConchSpriteAdpt',_super);
	var __proto=ConchSpriteAdpt.prototype;
	__proto.createData=function(){
		this.data=ParamData.create(26 *4);
		this._datai32=this.data._int32Data;
		this._dataf32=this.data._float32Data;
		this._dataf32[5]=1;
		this._dataf32[3]=0;
		this._dataf32[4]=0;
		this._dataf32[8]=1;
		this._dataf32[9]=1;
	}

	__proto._createTransform=function(){
		return MatrixConch.create(new Float32Array(this._dataf32.buffer,14*4,6*4));
	}

	__proto._setGraphics=function(value){
		this.data._int32Data[6]=value._buffer._buffer["_ptrID"];
	}

	__proto._setCacheAs=function(value){
		this._dataf32[21]=value=="bitmap"?2:(value=="normal"?1:0);
	}

	__proto._setX=function(value){
		this._x=this._dataf32[1]=value;
	}

	__proto._setY=function(value){
		this._y=this._dataf32[2]=value;
	}

	__proto._setPivotX=function(value){
		this._dataf32[3]=value;
	}

	__proto._getPivotX=function(){
		return this._dataf32[3];
	}

	__proto._setPivotY=function(value){
		this._dataf32[4]=value;
	}

	__proto._getPivotY=function(){
		return this._dataf32[4];
	}

	__proto._setAlpha=function(value){
		if (this._dataf32[5]!==value){
			this._dataf32[5]=value;
			if (value!==1)
				this._renderType |=0x01;
			else
			this._renderType &=~0x01;
			this.parentRepaint();
		}
	}

	__proto._setRenderType=function(type){
		this._datai32[0]=type;
	}

	__proto.parentRepaint=function(){}
	__proto._getAlpha=function(){
		return this._dataf32[5];
	}

	__proto._setScaleX=function(value){
		this._style.scaleX=this._dataf32[8]=value;
		this._dataf32[13]=1.0;
	}

	__proto._setScaleY=function(value){
		this._style.scaleY=this._dataf32[9]=value;
		this._dataf32[13]=1.0;
	}

	__proto._setSkewX=function(value){
		this._style.skewX=this._dataf32[10]=value;
		this._dataf32[13]=1.0;
	}

	__proto._setSkewY=function(value){
		this._style.skewY=this._dataf32[11]=value;
		this._dataf32[13]=1.0;
	}

	__proto._setRotation=function(value){
		this._style.rotation=this._dataf32[12]=value;
		this._dataf32[13]=1.0;
	}

	__proto._setTexture=function(value){
		this._datai32[20]=value._conchTexture.id;
	}

	__proto._adjustTransform=function(){
		var style=this._style;
		var sx=style.scaleX,sy=style.scaleY;
		var m;
		if (style.rotation || sx!==1 || sy!==1 || style.skewX || style.skewY){
			m=this._transform || (this._transform=this._createTransform());
			m._bTransform=true;
			window.conch.calcMatrixFromScaleSkewRotation(this.data._data["_ptrID"]);
			return m;
			}else {
			this._transform && this._transform.destroy();
			this._transform=null;
			this._renderType &=~0x02;
			this._setRenderType(this._renderType);
		}
		return m;
	}

	ConchSpriteAdpt.createMatrix=function(a,b,c,d,tx,ty,nums){
		(a===void 0)&& (a=1);
		(b===void 0)&& (b=0);
		(c===void 0)&& (c=0);
		(d===void 0)&& (d=1);
		(tx===void 0)&& (tx=0);
		(ty===void 0)&& (ty=0);
		return new MatrixConch(a,b,c,d,tx,ty,nums);
	}

	ConchSpriteAdpt.init=function(){
		ConchCmdReplace.__init__();
		ConchGraphicsAdpt.__init__();
		var spP=Sprite["prototype"];
		var mP=ConchSpriteAdpt["prototype"];
		var funs=[
		"_createTransform",
		"_setGraphics",
		"_setCacheAs",
		"_setX",
		"_setY",
		"_setPivotX",
		"_getPivotX",
		"_setPivotY",
		"_getPivotY",
		"_setAlpha",
		"_getAlpha",
		"_setScaleX",
		"_setScaleY",
		"_setSkewX",
		"_setSkewY",
		"_setRotation",
		"_adjustTransform",
		"_setRenderType",
		"_setTexture"];
		var i=0,len=0;
		len=funs.length;
		var tFunName;
		for (i=0;i < len;i++){
			tFunName=funs[i];
			spP[tFunName]=mP[tFunName];
		}
		spP["createGLBuffer"]=mP["createData"];
		Matrix._createFun=ConchSpriteAdpt.createMatrix;
		LayaGL.__init__();
		LayaGL2DTemplateCreater.__init__();
	}

	return ConchSpriteAdpt;
})(Node)


	//file:///E:/git/layaair-master/core/src/laya/media/h5audio/AudioSoundChannel.as=======97.999795/97.999795
/**
*@private
*audio标签播放声音的音轨控制
*/
//class laya.media.h5audio.AudioSoundChannel extends laya.media.SoundChannel
var AudioSoundChannel=(function(_super){
	function AudioSoundChannel(audio){
		/**
		*播放用的audio标签
		*/
		this._audio=null;
		this._onEnd=null;
		this._resumePlay=null;
		AudioSoundChannel.__super.call(this);
		this._onEnd=Utils.bind(this.__onEnd,this);
		this._resumePlay=Utils.bind(this.__resumePlay,this);
		audio.addEventListener("ended",this._onEnd);
		this._audio=audio;
	}

	__class(AudioSoundChannel,'laya.media.h5audio.AudioSoundChannel',_super);
	var __proto=AudioSoundChannel.prototype;
	__proto.__onEnd=function(){
		if (this.loops===1){
			if (this.completeHandler){
				Laya.timer.once(10,this,this.__runComplete,[this.completeHandler],false);
				this.completeHandler=null;
			}
			this.stop();
			this.event("complete");
			return;
		}
		if (this.loops > 0){
			this.loops--;
		}
		this.play();
	}

	__proto.__resumePlay=function(){
		if (this._audio)this._audio.removeEventListener("canplay",this._resumePlay);
		try {
			this._audio.currentTime=this.startTime;
			Browser.container.appendChild(this._audio);
			this._audio.play();
			}catch (e){
			this.event("error");
		}
	}

	/**
	*播放
	*/
	__proto.play=function(){
		this.isStopped=false;
		try {
			this._audio.playbackRate=SoundManager.playbackRate;
			this._audio.currentTime=this.startTime;
			}catch (e){
			this._audio.addEventListener("canplay",this._resumePlay);
			return;
		}
		SoundManager.addChannel(this);
		Browser.container.appendChild(this._audio);
		if ("play" in this._audio)this._audio.play();
	}

	/**
	*停止播放
	*/
	__proto.stop=function(){
		this.isStopped=true;
		SoundManager.removeChannel(this);
		this.completeHandler=null;
		if (!this._audio)return;
		if (Render.isConchApp){
			this._audio.stop();
		}
		if ("pause" in this._audio)this._audio.pause();
		this._audio.removeEventListener("ended",this._onEnd);
		this._audio.removeEventListener("canplay",this._resumePlay);
		if (!Browser.onIE)Pool.recover("audio:"+this.url,this._audio);
		Browser.removeElement(this._audio);
		this._audio=null;
	}

	__proto.pause=function(){
		this.isStopped=true;
		SoundManager.removeChannel(this);
		if ("pause" in this._audio)this._audio.pause();
	}

	__proto.resume=function(){
		if (!this._audio)return;
		this.isStopped=false;
		SoundManager.addChannel(this);
		if ("play" in this._audio)this._audio.play();
	}

	/**
	*当前播放到的位置
	*/
	__getset(0,__proto,'position',function(){
		if (!this._audio)return 0;
		return this._audio.currentTime;
	});

	/**
	*获取总时间。
	*/
	__getset(0,__proto,'duration',function(){
		if (!this._audio)return 0;
		return this._audio.duration;
	});

	/**
	*设置音量
	*/
	/**
	*获取音量
	*/
	__getset(0,__proto,'volume',function(){
		if (!this._audio)return 1;
		return this._audio.volume;
		},function(v){
		if (!this._audio)return;
		this._audio.volume=v;
	});

	return AudioSoundChannel;
})(SoundChannel)


	//file:///E:/git/layaair-master/core/src/laya/media/webaudio/WebAudioSoundChannel.as=======97.999789/97.999789
/**
*@private
*web audio api方式播放声音的音轨控制
*/
//class laya.media.webaudio.WebAudioSoundChannel extends laya.media.SoundChannel
var WebAudioSoundChannel=(function(_super){
	function WebAudioSoundChannel(){
		/**
		*声音原始文件数据
		*/
		this.audioBuffer=null;
		/**
		*gain节点
		*/
		this.gain=null;
		/**
		*播放用的数据
		*/
		this.bufferSource=null;
		/**
		*当前时间
		*/
		this._currentTime=0;
		/**
		*当前音量
		*/
		this._volume=1;
		/**
		*播放开始时的时间戳
		*/
		this._startTime=0;
		this._pauseTime=0;
		this._onPlayEnd=null;
		WebAudioSoundChannel.__super.call(this);
		this.context=WebAudioSound.ctx;
		this._onPlayEnd=Utils.bind(this.__onPlayEnd,this);
		if (this.context["createGain"]){
			this.gain=this.context["createGain"]();
			}else {
			this.gain=this.context["createGainNode"]();
		}
	}

	__class(WebAudioSoundChannel,'laya.media.webaudio.WebAudioSoundChannel',_super);
	var __proto=WebAudioSoundChannel.prototype;
	/**
	*播放声音
	*/
	__proto.play=function(){
		SoundManager.addChannel(this);
		this.isStopped=false;
		this._clearBufferSource();
		if (!this.audioBuffer)return;
		var context=this.context;
		var gain=this.gain;
		var bufferSource=context.createBufferSource();
		this.bufferSource=bufferSource;
		bufferSource.buffer=this.audioBuffer;
		bufferSource.connect(gain);
		if (gain)gain.disconnect();
		gain.connect(context.destination);
		bufferSource.onended=this._onPlayEnd;
		if (this.startTime >=this.duration)this.startTime=0;
		this._startTime=Browser.now();
		this.gain.gain.value=this._volume;
		if (this.loops==0){
			bufferSource.loop=true;
		}
		bufferSource.playbackRate.value=SoundManager.playbackRate;
		bufferSource.start(0,this.startTime);
		this._currentTime=0;
	}

	__proto.__onPlayEnd=function(){
		if (this.loops===1){
			if (this.completeHandler){
				Laya.timer.once(10,this,this.__runComplete,[this.completeHandler],false);
				this.completeHandler=null;
			}
			this.stop();
			this.event("complete");
			return;
		}
		if (this.loops > 0){
			this.loops--;
		}
		this.play();
	}

	__proto._clearBufferSource=function(){
		if (this.bufferSource){
			var sourceNode=this.bufferSource;
			if (sourceNode.stop){
				sourceNode.stop(0);
				}else {
				sourceNode.noteOff(0);
			}
			sourceNode.disconnect(0);
			sourceNode.onended=null;
			if (!WebAudioSoundChannel._tryCleanFailed)this._tryClearBuffer(sourceNode);
			this.bufferSource=null;
		}
	}

	__proto._tryClearBuffer=function(sourceNode){
		if (!Browser.onIOS){
			WebAudioSoundChannel._tryCleanFailed=true;
			return;
		}
		try {
			sourceNode.buffer=WebAudioSound._miniBuffer;
			}catch (e){
			WebAudioSoundChannel._tryCleanFailed=true;
		}
	}

	/**
	*停止播放
	*/
	__proto.stop=function(){
		this._clearBufferSource();
		this.audioBuffer=null;
		if (this.gain)this.gain.disconnect();
		this.isStopped=true;
		SoundManager.removeChannel(this);
		this.completeHandler=null;
	}

	__proto.pause=function(){
		if (!this.isStopped){
			this._pauseTime=this.position;
		}
		this._clearBufferSource();
		if (this.gain)this.gain.disconnect();
		this.isStopped=true;
		SoundManager.removeChannel(this);
	}

	__proto.resume=function(){
		this.startTime=this._pauseTime;
		this.play();
	}

	/**
	*获取当前播放位置
	*/
	__getset(0,__proto,'position',function(){
		if (this.bufferSource){
			return (Browser.now()-this._startTime)/ 1000+this.startTime;
		}
		return 0;
	});

	__getset(0,__proto,'duration',function(){
		if (this.audioBuffer){
			return this.audioBuffer.duration;
		}
		return 0;
	});

	/**
	*设置音量
	*/
	/**
	*获取音量
	*/
	__getset(0,__proto,'volume',function(){
		return this._volume;
		},function(v){
		if (this.isStopped)return;
		this._volume=v;
		this.gain.gain.value=v;
	});

	WebAudioSoundChannel._tryCleanFailed=false;
	return WebAudioSoundChannel;
})(SoundChannel)


	//file:///E:/git/layaair-master/core/src/laya/resource/Bitmap.as=======97.999737/97.999737
/**
*@private
*<code>Bitmap</code> 图片资源类。
*/
//class laya.resource.Bitmap extends laya.resource.Resource
var Bitmap=(function(_super){
	function Bitmap(){
		/**@private */
		//this._width=NaN;
		/**@private */
		//this._height=NaN;
		Bitmap.__super.call(this);
		this._width=-1;
		this._height=-1;
	}

	__class(Bitmap,'laya.resource.Bitmap',_super);
	var __proto=Bitmap.prototype;
	/**
	*@private
	*获取纹理资源。
	*/
	__proto._getSource=function(){
		throw "Bitmap: must override it.";
	}

	/**
	*获取宽度。
	*/
	__getset(0,__proto,'width',function(){
		return this._width;
	});

	/***
	*获取高度。
	*/
	__getset(0,__proto,'height',function(){
		return this._height;
	});

	return Bitmap;
})(Resource)


	//file:///E:/git/layaair-master/core/src/laya/display/Text.as=======96.999897/96.999897
/**
*<p> <code>Text</code> 类用于创建显示对象以显示文本。</p>
*<p>
*注意：如果运行时系统找不到设定的字体，则用系统默认的字体渲染文字，从而导致显示异常。(通常电脑上显示正常，在一些移动端因缺少设置的字体而显示异常)。
*</p>
*@example
*package
*{
	*import laya.display.Text;
	*public class Text_Example
	*{
		*public function Text_Example()
		*{
			*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*onInit();
			*}
		*private function onInit():void
		*{
			*var text:Text=new Text();//创建一个 Text 类的实例对象 text 。
			*text.text="这个是一个 Text 文本示例。";
			*text.color="#008fff";//设置 text 的文本颜色。
			*text.font="Arial";//设置 text 的文本字体。
			*text.bold=true;//设置 text 的文本显示为粗体。
			*text.fontSize=30;//设置 text 的字体大小。
			*text.wordWrap=true;//设置 text 的文本自动换行。
			*text.x=100;//设置 text 对象的属性 x 的值，用于控制 text 对象的显示位置。
			*text.y=100;//设置 text 对象的属性 y 的值，用于控制 text 对象的显示位置。
			*text.width=300;//设置 text 的宽度。
			*text.height=200;//设置 text 的高度。
			*text.italic=true;//设置 text 的文本显示为斜体。
			*text.borderColor="#fff000";//设置 text 的文本边框颜色。
			*Laya.stage.addChild(text);//将 text 添加到显示列表。
			*}
		*}
	*}
*@example
*Text_Example();
*function Text_Example()
*{
	*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
	*onInit();
	*}
*function onInit()
*{
	*var text=new laya.display.Text();//创建一个 Text 类的实例对象 text 。
	*text.text="这个是一个 Text 文本示例。";
	*text.color="#008fff";//设置 text 的文本颜色。
	*text.font="Arial";//设置 text 的文本字体。
	*text.bold=true;//设置 text 的文本显示为粗体。
	*text.fontSize=30;//设置 text 的字体大小。
	*text.wordWrap=true;//设置 text 的文本自动换行。
	*text.x=100;//设置 text 对象的属性 x 的值，用于控制 text 对象的显示位置。
	*text.y=100;//设置 text 对象的属性 y 的值，用于控制 text 对象的显示位置。
	*text.width=300;//设置 text 的宽度。
	*text.height=200;//设置 text 的高度。
	*text.italic=true;//设置 text 的文本显示为斜体。
	*text.borderColor="#fff000";//设置 text 的文本边框颜色。
	*Laya.stage.addChild(text);//将 text 添加到显示列表。
	*}
*@example
*class Text_Example {
	*constructor(){
		*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
		*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
		*this.onInit();
		*}
	*private onInit():void {
		*var text:laya.display.Text=new laya.display.Text();//创建一个 Text 类的实例对象 text 。
		*text.text="这个是一个 Text 文本示例。";
		*text.color="#008fff";//设置 text 的文本颜色。
		*text.font="Arial";//设置 text 的文本字体。
		*text.bold=true;//设置 text 的文本显示为粗体。
		*text.fontSize=30;//设置 text 的字体大小。
		*text.wordWrap=true;//设置 text 的文本自动换行。
		*text.x=100;//设置 text 对象的属性 x 的值，用于控制 text 对象的显示位置。
		*text.y=100;//设置 text 对象的属性 y 的值，用于控制 text 对象的显示位置。
		*text.width=300;//设置 text 的宽度。
		*text.height=200;//设置 text 的高度。
		*text.italic=true;//设置 text 的文本显示为斜体。
		*text.borderColor="#fff000";//设置 text 的文本边框颜色。
		*Laya.stage.addChild(text);//将 text 添加到显示列表。
		*}
	*}
*/
//class laya.display.Text extends laya.display.Sprite
var Text=(function(_super){
	function Text(){
		/**@private */
		this._clipPoint=null;
		/**@private 表示文本内容字符串。*/
		this._text=null;
		/**@private 表示文本内容是否发生改变。*/
		this._isChanged=false;
		/**@private 表示文本的宽度，以像素为单位。*/
		this._textWidth=0;
		/**@private 表示文本的高度，以像素为单位。*/
		this._textHeight=0;
		/**@private 存储文字行数信息。*/
		this._lines=[];
		/**@private 保存每行宽度*/
		this._lineWidths=[];
		/**@private 文本的内容位置 X 轴信息。*/
		this._startX=NaN;
		/**@private 文本的内容位置X轴信息。 */
		this._startY=NaN;
		/**@private */
		this._words=null;
		/**@private */
		this._charSize={};
		/**@private */
		this._valign="top";
		/**@private */
		this._color="#000000";
		Text.__super.call(this);
		this._fontSize=Text.defaultFontSize;
		this._font=Text.defaultFont;
		this.overflow="visible";
		this._style=TextStyle.EMPTY;
	}

	__class(Text,'laya.display.Text',_super);
	var __proto=Text.prototype;
	/**
	*@private
	*获取样式。
	*@return 样式 Style 。
	*/
	__proto.getStyle=function(){
		this._style===TextStyle.EMPTY && (this._style=TextStyle.create());
		return this._style;
	}

	__proto._getTextStyle=function(){
		if (this._style===TextStyle.EMPTY){
			this._style=TextStyle.create();
		}
		return this._style;
	}

	/**@inheritDoc */
	__proto.destroy=function(destroyChild){
		(destroyChild===void 0)&& (destroyChild=true);
		_super.prototype.destroy.call(this,destroyChild);
		this._clipPoint=null;
		this._lines=null;
		this._lineWidths=null;
		this._words=null;
		this._charSize=null;
	}

	/**
	*@private
	*@inheritDoc
	*/
	__proto._getBoundPointsM=function(ifRotate){
		(ifRotate===void 0)&& (ifRotate=false);
		var rec=Rectangle.TEMP;
		rec.setTo(0,0,this.width,this.height);
		return rec._getBoundPoints();
	}

	/**
	*@inheritDoc
	*/
	__proto.getGraphicBounds=function(realSize){
		(realSize===void 0)&& (realSize=false);
		var rec=Rectangle.TEMP;
		rec.setTo(0,0,this.width,this.height);
		return rec;
	}

	/**
	*@private
	*/
	__proto._getCSSStyle=function(){
		return this._style;
	}

	/**
	*<p>根据指定的文本，从语言包中取当前语言的文本内容。并对此文本中的{i}文本进行替换。</p>
	*<p>设置Text.langPacks语言包后，即可使用lang获取里面的语言</p>
	*<p>例如：
	*<li>（1）text 的值为“我的名字”，先取到这个文本对应的当前语言版本里的值“My name”，将“My name”设置为当前文本的内容。</li>
	*<li>（2）text 的值为“恭喜你赢得{0}个钻石，{1}经验。”，arg1 的值为100，arg2 的值为200。
	*则先取到这个文本对应的当前语言版本里的值“Congratulations on your winning {0}diamonds,{1}experience.”，
	*然后将文本里的{0}、{1}，依据括号里的数字从0开始替换为 arg1、arg2 的值。
	*将替换处理后的文本“Congratulations on your winning 100 diamonds,200 experience.”设置为当前文本的内容。
	*</li>
	*</p>
	*@param text 文本内容。
	*@param ...args 文本替换参数。
	*/
	__proto.lang=function(text,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10){
		text=Text.langPacks && Text.langPacks[text] ? Text.langPacks[text] :text;
		if (arguments.length < 2){
			this._text=text;
			}else {
			for (var i=0,n=arguments.length;i < n;i++){
				text=text.replace("{"+i+"}",arguments[i+1]);
			}
			this._text=text;
		}
	}

	/**
	*@private
	*/
	__proto._getContextFont=function(){
		return (this.italic ? "italic " :"")+(this.bold ? "bold " :"")+this.fontSize+"px "+(Browser.onIPhone ? (laya.display.Text.fontFamilyMap[this.font] || this.font):this.font);
	}

	/**
	*@private
	*渲染文字。
	*@param begin 开始渲染的行索引。
	*@param visibleLineCount 渲染的行数。
	*/
	__proto._renderText=function(){
		var padding=this.padding;
		var visibleLineCount=this._lines.length;
		if (this.overflow !="visible"){
			visibleLineCount=Math.min(visibleLineCount,Math.floor((this.height-padding[0]-padding[2])/ (this.leading+this._charSize.height))+1);
		};
		var beginLine=this.scrollY / (this._charSize.height+this.leading)| 0;
		var graphics=this.graphics;
		graphics.clear(true);
		var ctxFont=this._getContextFont();
		Browser.context.font=ctxFont;
		var startX=padding[3];
		var textAlgin="left";
		var lines=this._lines;
		var lineHeight=this.leading+this._charSize.height;
		var tCurrBitmapFont=(this._style).currBitmapFont;
		if (tCurrBitmapFont){
			lineHeight=this.leading+tCurrBitmapFont.getMaxHeight();
		};
		var startY=padding[0];
		if ((!tCurrBitmapFont)&& this._width > 0 && this._textWidth <=this._width){
			if (this.align=="right"){
				textAlgin="right";
				startX=this._width-padding[1];
				}else if (this.align=="center"){
				textAlgin="center";
				startX=this._width *0.5+padding[3]-padding[1];
			}
		}
		if (this._height > 0){
			var tempVAlign=(this._textHeight > this._height)? "top" :this.valign;
			if (tempVAlign==="middle")
				startY=(this._height-visibleLineCount *lineHeight)*0.5+padding[0]-padding[2];
			else if (tempVAlign==="bottom")
			startY=this._height-visibleLineCount *lineHeight-padding[2];
		};
		var style=this._style;
		if (tCurrBitmapFont && tCurrBitmapFont.autoScaleSize){
			var bitmapScale=tCurrBitmapFont.fontSize / this.fontSize;
		}
		if (this._clipPoint){
			graphics.save();
			if (tCurrBitmapFont && tCurrBitmapFont.autoScaleSize){
				var tClipWidth=0;
				var tClipHeight=0;
				this._width ? tClipWidth=(this._width-padding[3]-padding[1]):tClipWidth=this._textWidth;
				this._height ? tClipHeight=(this._height-padding[0]-padding[2]):tClipHeight=this._textHeight;
				tClipWidth *=bitmapScale;
				tClipHeight *=bitmapScale;
				graphics.clipRect(padding[3],padding[0],tClipWidth,tClipHeight);
				}else {
				graphics.clipRect(padding[3],padding[0],this._width ? (this._width-padding[3]-padding[1]):this._textWidth,this._height ? (this._height-padding[0]-padding[2]):this._textHeight);
			}
			this.repaint();
		};
		var password=style.asPassword;
		if (("prompt" in this)&& this['prompt']==this._text)
			password=false;
		var x=0,y=0;
		var end=Math.min(this._lines.length,visibleLineCount+beginLine)|| 1;
		for (var i=beginLine;i < end;i++){
			var word=lines[i];
			var _word;
			if (password){
				var len=word.length;
				word="";
				for (var j=len;j > 0;j--){
					word+="●";
				}
			}
			x=startX-(this._clipPoint ? this._clipPoint.x :0);
			y=startY+lineHeight *i-(this._clipPoint ? this._clipPoint.y :0);
			this.underline && this._drawUnderline(textAlgin,x,y,i);
			if (tCurrBitmapFont){
				var tWidth=this.width;
				if (tCurrBitmapFont.autoScaleSize){
					tWidth=this.width *bitmapScale;
				}
				tCurrBitmapFont._drawText(word,this,x,y,this.align,tWidth);
				}else {
				if (Render.isWebGL){
					this._words || (this._words=[]);
					_word=this._words.length > (i-beginLine)? this._words[i-beginLine] :new WordText();
					_word.setText(word);
					}else {
					_word=word;
				}
				style.stroke ? graphics.fillBorderText(_word,x,y,ctxFont,this.color,style.strokeColor,style.stroke,textAlgin):graphics.fillText(_word,x,y,ctxFont,this.color,textAlgin);
			}
		}
		if (tCurrBitmapFont && tCurrBitmapFont.autoScaleSize){
			var tScale=1 / bitmapScale;
			this.scale(tScale,tScale);
		}
		if (this._clipPoint)graphics.restore();
		this._startX=startX;
		this._startY=startY;
	}

	/**
	*@private
	*绘制下划线
	*@param x 本行坐标
	*@param y 本行坐标
	*@param lineIndex 本行索引
	*/
	__proto._drawUnderline=function(align,x,y,lineIndex){
		var lineWidth=this._lineWidths[lineIndex];
		switch (align){
			case 'center':
				x-=lineWidth / 2;
				break ;
			case 'right':
				x-=lineWidth;
				break ;
			case 'left':
			default :
				break ;
			}
		y+=this._charSize.height;
		this._graphics.drawLine(x,y,x+lineWidth,y,this.underlineColor || this.color,1);
	}

	/**
	*<p>排版文本。</p>
	*<p>进行宽高计算，渲染、重绘文本。</p>
	*/
	__proto.typeset=function(){
		this._isChanged=false;
		if (!this._text){
			this._clipPoint=null;
			this._textWidth=this._textHeight=0;
			this.graphics.clear(true);
			return;
		}
		Browser.context.font=this._getContextFont();
		this._lines.length=0;
		this._lineWidths.length=0;
		this._parseLines(this._text);
		this._evalTextSize();
		if (this._checkEnabledViewportOrNot())this._clipPoint || (this._clipPoint=new Point(0,0));
		else this._clipPoint=null;
		this._renderText();
	}

	/**@private */
	__proto._evalTextSize=function(){
		var nw=NaN,nh=NaN;
		nw=Math.max.apply(this,this._lineWidths);
		if ((this._style).currBitmapFont)
			nh=this._lines.length *((this._style).currBitmapFont.getMaxHeight()+this.leading)+this.padding[0]+this.padding[2];
		else
		nh=this._lines.length *(this._charSize.height+this.leading)+this.padding[0]+this.padding[2];
		if (nw !=this._textWidth || nh !=this._textHeight){
			this._textWidth=nw;
			this._textHeight=nh;
		}
	}

	/**@private */
	__proto._checkEnabledViewportOrNot=function(){
		return this.overflow=="scroll" && ((this._width > 0 && this._textWidth > this._width)|| (this._height > 0 && this._textHeight > this._height));
	}

	/**
	*<p>快速更改显示文本。不进行排版计算，效率较高。</p>
	*<p>如果只更改文字内容，不更改文字样式，建议使用此接口，能提高效率。</p>
	*@param text 文本内容。
	*/
	__proto.changeText=function(text){
		if (this._text!==text){
			this.lang(text+"");
			if (this._graphics && this._graphics.replaceText(this._text)){
				}else {
				this.typeset();
			}
		}
	}

	/**
	*@private
	*分析文本换行。
	*/
	__proto._parseLines=function(text){
		var needWordWrapOrTruncate=this.wordWrap || this.overflow=="hidden";
		if (needWordWrapOrTruncate){
			var wordWrapWidth=this._getWordWrapWidth();
		};
		var bitmapFont=(this._style).currBitmapFont;
		if (bitmapFont){
			this._charSize.width=bitmapFont.getMaxWidth();
			this._charSize.height=bitmapFont.getMaxHeight();
			}else {
			var measureResult=Browser.context.measureText(Text._testWord);
			this._charSize.width=measureResult.width;
			this._charSize.height=(measureResult.height || this.fontSize);
		};
		var lines=text.replace(/\r\n/g,"\n").split("\n");
		for (var i=0,n=lines.length;i < n;i++){
			var line=lines[i];
			if (needWordWrapOrTruncate)
				this._parseLine(line,wordWrapWidth);
			else {
				this._lineWidths.push(this._getTextWidth(line));
				this._lines.push(line);
			}
		}
	}

	/**
	*@private
	*解析行文本。
	*@param line 某行的文本。
	*@param wordWrapWidth 文本的显示宽度。
	*/
	__proto._parseLine=function(line,wordWrapWidth){
		var ctx=Browser.context;
		var lines=this._lines;
		var maybeIndex=0;
		var execResult;
		var charsWidth=NaN;
		var wordWidth=NaN;
		var startIndex=0;
		charsWidth=this._getTextWidth(line);
		if (charsWidth <=wordWrapWidth){
			lines.push(line);
			this._lineWidths.push(charsWidth);
			return;
		}
		charsWidth=this._charSize.width;
		maybeIndex=Math.floor(wordWrapWidth / charsWidth);
		(maybeIndex==0)&& (maybeIndex=1);
		charsWidth=this._getTextWidth(line.substring(0,maybeIndex));
		wordWidth=charsWidth;
		for (var j=maybeIndex,m=line.length;j < m;j++){
			charsWidth=this._getTextWidth(line.charAt(j));
			wordWidth+=charsWidth;
			if (wordWidth > wordWrapWidth){
				if (this.wordWrap){
					var newLine=line.substring(startIndex,j);
					if (newLine.charCodeAt(newLine.length-1)< 255){
						execResult=/(?:\w|-)+$/.exec(newLine);
						if (execResult){
							j=execResult.index+startIndex;
							if (execResult.index==0)j+=newLine.length;
							else newLine=line.substring(startIndex,j);
						}
					}
					lines.push(newLine);
					this._lineWidths.push(wordWidth-charsWidth);
					startIndex=j;
					if (j+maybeIndex < m){
						j+=maybeIndex;
						charsWidth=this._getTextWidth(line.substring(startIndex,j));
						wordWidth=charsWidth;
						j--;
						}else {
						lines.push(line.substring(startIndex,m));
						this._lineWidths.push(this._getTextWidth(lines[lines.length-1]));
						startIndex=-1;
						break ;
					}
					}else if (this.overflow=="hidden"){
					lines.push(line.substring(0,j));
					this._lineWidths.push(this._getTextWidth(lines[lines.length-1]));
					return;
				}
			}
		}
		if (this.wordWrap && startIndex !=-1){
			lines.push(line.substring(startIndex,m));
			this._lineWidths.push(this._getTextWidth(lines[lines.length-1]));
		}
	}

	/**@private */
	__proto._getTextWidth=function(text){
		var bitmapFont=(this._style).currBitmapFont;
		if (bitmapFont)return bitmapFont.getTextWidth(text);
		else return Browser.context.measureText(text).width;
	}

	/**
	*@private
	*获取换行所需的宽度。
	*/
	__proto._getWordWrapWidth=function(){
		var p=this.padding;
		var w=NaN;
		var bitmapFont=(this._style).currBitmapFont;
		if (bitmapFont && bitmapFont.autoScaleSize)w=this._width *(bitmapFont.fontSize / this.fontSize);
		else w=this._width;
		if (w <=0){
			w=this.wordWrap ? 100 :Browser.width;
		}
		w <=0 && (w=100);
		return w-p[3]-p[1];
	}

	/**
	*返回字符在本类实例的父坐标系下的坐标。
	*@param charIndex 索引位置。
	*@param out （可选）输出的Point引用。
	*@return Point 字符在本类实例的父坐标系下的坐标。如果out参数不为空，则将结果赋值给指定的Point对象，否则创建一个新的Point对象返回。建议使用Point.TEMP作为out参数，可以省去Point对象创建和垃圾回收的开销，尤其是在需要频繁执行的逻辑中，比如帧循环和MOUSE_MOVE事件回调函数里面。
	*/
	__proto.getCharPoint=function(charIndex,out){
		this._isChanged && Laya.timer.runCallLater(this,this.typeset);
		var len=0,lines=this._lines,startIndex=0;
		for (var i=0,n=lines.length;i < n;i++){
			len+=lines[i].length;
			if (charIndex < len){
				var line=i;
				break ;
			}
			startIndex=len;
		};
		var ctxFont=(this.italic ? "italic " :"")+(this.bold ? "bold " :"")+this.fontSize+"px "+this.font;
		Browser.context.font=ctxFont;
		var width=this._getTextWidth(this._text.substring(startIndex,charIndex));
		var point=out || new Point();
		return point.setTo(this._startX+width-(this._clipPoint ? this._clipPoint.x :0),this._startY+line *(this._charSize.height+this.leading)-(this._clipPoint ? this._clipPoint.y :0));
	}

	/**
	*@inheritDoc
	*/
	__getset(0,__proto,'width',function(){
		if (this._width)return this._width;
		return this.textWidth+this.padding[1]+this.padding[3];
		},function(value){
		if (value !=this._width){
			Laya.superSet(Sprite,this,'width',value);
			this.isChanged=true;
		}
	});

	/**
	*表示文本的宽度，以像素为单位。
	*/
	__getset(0,__proto,'textWidth',function(){
		this._isChanged && Laya.timer.runCallLater(this,this.typeset);
		return this._textWidth;
	});

	/**
	*@inheritDoc
	*/
	__getset(0,__proto,'height',function(){
		if (this._height)return this._height;
		return this.textHeight+this.padding[0]+this.padding[2];
		},function(value){
		if (value !=this._height){
			Laya.superSet(Sprite,this,'height',value);
			this.isChanged=true;
		}
	});

	/**
	*表示文本的高度，以像素为单位。
	*/
	__getset(0,__proto,'textHeight',function(){
		this._isChanged && Laya.timer.runCallLater(this,this.typeset);
		return this._textHeight;
	});

	/**
	*<p>边距信息。</p>
	*<p>数据格式：[上边距，右边距，下边距，左边距]（边距以像素为单位）。</p>
	*/
	__getset(0,__proto,'padding',function(){
		return (this._style).padding;
		},function(value){
		this._getTextStyle().padding=value;
		this.isChanged=true;
	});

	/**
	*<p>指定文本是否为粗体字。</p>
	*<p>默认值为 false，这意味着不使用粗体字。如果值为 true，则文本为粗体字。</p>
	*/
	__getset(0,__proto,'bold',function(){
		return (this._style).bold;
		},function(value){
		this._getTextStyle().bold=value;
		this.isChanged=true;
	});

	/**当前文本的内容字符串。*/
	__getset(0,__proto,'text',function(){
		return this._text || "";
		},function(value){
		if (this._text!==value){
			this.lang(value+"");
			this.isChanged=true;
			this.event("change");
		}
	});

	/**
	*<p>表示文本的颜色值。可以通过 <code>Text.defaultColor</code> 设置默认颜色。</p>
	*<p>默认值为黑色。</p>
	*/
	__getset(0,__proto,'color',function(){
		return this._color;
		},function(value){
		if (this._color !=value){
			this._color=value;
			if (!this._isChanged && this._graphics){
				this._graphics.replaceTextColor(this.color)
				}else {
				this.isChanged=true;
			}
		}
	});

	/**
	*<p>文本的字体名称，以字符串形式表示。</p>
	*<p>默认值为："Arial"，可以通过Text.defaultFont设置默认字体。</p>
	*<p>如果运行时系统找不到设定的字体，则用系统默认的字体渲染文字，从而导致显示异常。(通常电脑上显示正常，在一些移动端因缺少设置的字体而显示异常)。</p>
	*@see laya.display.Text#defaultFont
	*/
	__getset(0,__proto,'font',function(){
		return this._font;
		},function(value){
		if ((this._style).currBitmapFont){
			this._getTextStyle().currBitmapFont=null;
			this.scale(1,1);
		}
		if (Text._bitmapFonts && Text._bitmapFonts[value]){
			this._getTextStyle().currBitmapFont=Text._bitmapFonts[value];
		}
		this._font=value;
		this.isChanged=true;
	});

	/**
	*<p>指定文本的字体大小（以像素为单位）。</p>
	*<p>默认为20像素，可以通过 <code>Text.defaultFontSize</code> 设置默认大小。</p>
	*/
	__getset(0,__proto,'fontSize',function(){
		return this._fontSize;
		},function(value){
		this._fontSize=value;
		this.isChanged=true;
	});

	/**
	*<p>表示使用此文本格式的文本是否为斜体。</p>
	*<p>默认值为 false，这意味着不使用斜体。如果值为 true，则文本为斜体。</p>
	*/
	__getset(0,__proto,'italic',function(){
		return (this._style).italic;
		},function(value){
		this._getTextStyle().italic=value;
		this.isChanged=true;
	});

	/**
	*<p>表示文本的水平显示方式。</p>
	*<p><b>取值：</b>
	*<li>"left"： 居左对齐显示。</li>
	*<li>"center"： 居中对齐显示。</li>
	*<li>"right"： 居右对齐显示。</li>
	*</p>
	*/
	__getset(0,__proto,'align',function(){
		return (this._style).align;
		},function(value){
		this._getTextStyle().align=value;
		this.isChanged=true;
	});

	/**
	*<p>表示文本的垂直显示方式。</p>
	*<p><b>取值：</b>
	*<li>"top"： 居顶部对齐显示。</li>
	*<li>"middle"： 居中对齐显示。</li>
	*<li>"bottom"： 居底部对齐显示。</li>
	*</p>
	*/
	__getset(0,__proto,'valign',function(){
		return this._valign;
		},function(value){
		this._valign=value;
		this.isChanged=true;
	});

	/**
	*<p>表示文本是否自动换行，默认为false。</p>
	*<p>若值为true，则自动换行；否则不自动换行。</p>
	*/
	__getset(0,__proto,'wordWrap',function(){
		return (this._style).wordWrap;
		},function(value){
		this._getTextStyle().wordWrap=value;
		this.isChanged=true;
	});

	/**
	*垂直行间距（以像素为单位）。
	*/
	__getset(0,__proto,'leading',function(){
		return (this._style).leading;
		},function(value){
		this._getTextStyle().leading=value;
		this.isChanged=true;
	});

	/**
	*文本背景颜色，以字符串表示。
	*/
	__getset(0,__proto,'bgColor',function(){
		return (this._style).bgColor;
		},function(value){
		this._getTextStyle().bgColor=value;
		this._renderType |=0x80;
		this.isChanged=true;
	});

	/**
	*文本边框背景颜色，以字符串表示。
	*/
	__getset(0,__proto,'borderColor',function(){
		return (this._style).borderColor;
		},function(value){
		this._getTextStyle().borderColor=value;
		this._renderType |=0x80;
		this.isChanged=true;
	});

	/**
	*<p>描边宽度（以像素为单位）。</p>
	*<p>默认值0，表示不描边。</p>
	*/
	__getset(0,__proto,'stroke',function(){
		return (this._style).stroke;
		},function(value){
		this._getTextStyle().stroke=value;
		this.isChanged=true;
	});

	/**
	*<p>描边颜色，以字符串表示。</p>
	*<p>默认值为 "#000000"（黑色）;</p>
	*/
	__getset(0,__proto,'strokeColor',function(){
		return (this._style).strokeColor;
		},function(value){
		this._getTextStyle().strokeColor=value;
		this.isChanged=true;
	});

	/**
	*@private
	*一个布尔值，表示文本的属性是否有改变。若为true表示有改变。
	*/
	__getset(0,__proto,'isChanged',null,function(value){
		if (this._isChanged!==value){
			this._isChanged=value;
			value && Laya.timer.callLater(this,this.typeset);
		}
	});

	/**
	*<p>设置横向滚动量。</p>
	*<p>即使设置超出滚动范围的值，也会被自动限制在可能的最大值处。</p>
	*/
	/**
	*获取横向滚动量。
	*/
	__getset(0,__proto,'scrollX',function(){
		if (!this._clipPoint)return 0;
		return this._clipPoint.x;
		},function(value){
		if (this.overflow !="scroll" || (this.textWidth < this._width || !this._clipPoint))return;
		value=value < this.padding[3] ? this.padding[3] :value;
		var maxScrollX=this._textWidth-this._width;
		value=value > maxScrollX ? maxScrollX :value;
		this._clipPoint.x=value;
		this._renderText();
	});

	/**
	*设置纵向滚动量（px)。即使设置超出滚动范围的值，也会被自动限制在可能的最大值处。
	*/
	/**
	*获取纵向滚动量。
	*/
	__getset(0,__proto,'scrollY',function(){
		if (!this._clipPoint)return 0;
		return this._clipPoint.y;
		},function(value){
		if (this.overflow !="scroll" || (this.textHeight < this._height || !this._clipPoint))return;
		value=value < this.padding[0] ? this.padding[0] :value;
		var maxScrollY=this._textHeight-this._height;
		value=value > maxScrollY ? maxScrollY :value;
		this._clipPoint.y=value;
		this._renderText();
	});

	/**
	*获取横向可滚动最大值。
	*/
	__getset(0,__proto,'maxScrollX',function(){
		return (this.textWidth < this._width)? 0 :this._textWidth-this._width;
	});

	/**
	*获取纵向可滚动最大值。
	*/
	__getset(0,__proto,'maxScrollY',function(){
		return (this.textHeight < this._height)? 0 :this._textHeight-this._height;
	});

	/**返回文字行信息*/
	__getset(0,__proto,'lines',function(){
		if (this._isChanged)this.typeset();
		return this._lines;
	});

	/**下划线的颜色，为null则使用字体颜色。*/
	__getset(0,__proto,'underlineColor',function(){
		return (this._style).underlineColor;
		},function(value){
		this._getTextStyle().underlineColor=value;
		if (!this._isChanged)this._renderText();
	});

	/**是否显示下划线。*/
	__getset(0,__proto,'underline',function(){
		return (this._style).underline;
		},function(value){
		this._getTextStyle().underline=value;
	});

	Text.defaultFontStr=function(){
		return Text.defaultFontSize+"px "+Text.defaultFont;
	}

	Text.registerBitmapFont=function(name,bitmapFont){
		Text._bitmapFonts || (Text._bitmapFonts={});
		Text._bitmapFonts[name]=bitmapFont;
	}

	Text.unregisterBitmapFont=function(name,destroy){
		(destroy===void 0)&& (destroy=true);
		if (Text._bitmapFonts && Text._bitmapFonts[name]){
			var tBitmapFont=Text._bitmapFonts[name];
			if (destroy)tBitmapFont.destroy();
			delete Text._bitmapFonts[name];
		}
	}

	Text.VISIBLE="visible";
	Text.SCROLL="scroll";
	Text.HIDDEN="hidden";
	Text.defaultFontSize=12;
	Text.defaultFont="Arial";
	Text.langPacks=null;
	Text.isComplexText=false;
	Text._testWord="游";
	Text._bitmapFonts=null;
	Text.CharacterCache=true;
	__static(Text,
	['fontFamilyMap',function(){return this.fontFamilyMap={"报隶":"报隶-简","黑体":"黑体-简","楷体":"楷体-简","兰亭黑":"兰亭黑-简","隶变":"隶变-简","凌慧体":"凌慧体-简","翩翩体":"翩翩体-简","苹方":"苹方-简","手札体":"手札体-简","宋体":"宋体-简","娃娃体":"娃娃体-简","魏碑":"魏碑-简","行楷":"行楷-简","雅痞":"雅痞-简","圆体":"圆体-简"};}
	]);
	return Text;
})(Sprite)


	//file:///E:/git/layaair-master/core/src/laya/display/Stage.as=======96.999895/96.999895
/**
*<p> <code>Stage</code> 是舞台类，显示列表的根节点，所有显示对象都在舞台上显示。通过 Laya.stage 单例访问。</p>
*<p>Stage提供几种适配模式，不同的适配模式会产生不同的画布大小，画布越大，渲染压力越大，所以要选择合适的适配方案。</p>
*<p>Stage提供不同的帧率模式，帧率越高，渲染压力越大，越费电，合理使用帧率甚至动态更改帧率有利于改进手机耗电。</p>
*/
//class laya.display.Stage extends laya.display.Sprite
var Stage=(function(_super){
	function Stage(){
		/**当前焦点对象，此对象会影响当前键盘事件的派发主体。*/
		this.focus=null;
		/**帧率类型，支持三种模式：fast-60帧(默认)，slow-30帧，mouse-30帧（鼠标活动后会自动加速到60，鼠标不动2秒后降低为30帧，以节省消耗），sleep-1帧。*/
		this.frameRate="fast";
		/**设计宽度（初始化时设置的宽度Laya.init(width,height)）*/
		this.designWidth=0;
		/**设计高度（初始化时设置的高度Laya.init(width,height)）*/
		this.designHeight=0;
		/**画布是否发生翻转。*/
		this.canvasRotation=false;
		/**画布的旋转角度。*/
		this.canvasDegree=0;
		/**
		*<p>设置是否渲染，设置为false，可以停止渲染，画面会停留到最后一次渲染上，减少cpu消耗，此设置不影响时钟。</p>
		*<p>比如非激活状态，可以设置renderingEnabled=true以节省消耗。</p>
		**/
		this.renderingEnabled=true;
		/**是否启用屏幕适配，可以适配后，在某个时候关闭屏幕适配，防止某些操作导致的屏幕意外改变*/
		this.screenAdaptationEnabled=true;
		/**@private */
		this._screenMode="none";
		/**@private */
		this._scaleMode="noscale";
		/**@private */
		this._alignV="top";
		/**@private */
		this._alignH="left";
		/**@private */
		this._bgColor="black";
		/**@private */
		this._mouseMoveTime=0;
		/**@private */
		this._renderCount=0;
		/**@private */
		this._safariOffsetY=0;
		/**@private */
		this._frameStartTime=NaN;
		/**@private */
		this._isFocused=false;
		/**@private */
		this._isVisibility=false;
		/**@private 3D场景*/
		this._scenes=null;
		/**@private webgl Color*/
		this._wgColor=null;
		Stage.__super.call(this);
		this.offset=new Point();
		this._canvasTransform=new Matrix();
		this._previousOrientation=Browser.window.orientation;
		var _$this=this;
		this.transform=Matrix.create();
		this._scenes=[];
		this.mouseEnabled=true;
		this.hitTestPrior=true;
		this.autoSize=false;
		this._setBit(0x08,true);
		this._isFocused=true;
		this._isVisibility=true;
		var window=Browser.window;
		var _this=this;
		window.addEventListener("focus",function(){
			_$this._isFocused=true;
			_this.event("focus");
			_this.event("focuschange");
		});
		window.addEventListener("blur",function(){
			_$this._isFocused=false;
			_this.event("blur");
			_this.event("focuschange");
			if (_this._isInputting())Input["inputElement"].target.focus=false;
		});
		var hidden="hidden",state="visibilityState",visibilityChange="visibilitychange";
		var document=window.document;
		if (typeof document.hidden!=="undefined"){
			visibilityChange="visibilitychange";
			state="visibilityState";
			}else if (typeof document.mozHidden!=="undefined"){
			visibilityChange="mozvisibilitychange";
			state="mozVisibilityState";
			}else if (typeof document.msHidden!=="undefined"){
			visibilityChange="msvisibilitychange";
			state="msVisibilityState";
			}else if (typeof document.webkitHidden!=="undefined"){
			visibilityChange="webkitvisibilitychange";
			state="webkitVisibilityState";
		}
		window.document.addEventListener(visibilityChange,visibleChangeFun);
		function visibleChangeFun (){
			if (Browser.document[state]=="hidden"){
				_$this._isVisibility=false;
				if (_this._isInputting())Input["inputElement"].target.focus=false;
				}else {
				_$this._isVisibility=true;
			}
			_this.event("visibilitychange");
		}
		window.addEventListener("resize",function(){
			var orientation=Browser.window.orientation;
			if (orientation !=null && orientation !=_$this._previousOrientation && _this._isInputting()){
				Input["inputElement"].target.focus=false;
			}
			_$this._previousOrientation=orientation;
			if (_this._isInputting())return;
			if (Browser.onSafari)
				_this._safariOffsetY=(Browser.window.__innerHeight || Browser.document.body.clientHeight || Browser.document.documentElement.clientHeight)-Browser.window.innerHeight;
			_this._resetCanvas();
		});
		window.addEventListener("orientationchange",function(e){
			_this._resetCanvas();
		});
		this.on("mousemove",this,this._onmouseMove);
		if (Browser.onMobile)this.on("mousedown",this,this._onmouseMove);
	}

	__class(Stage,'laya.display.Stage',_super);
	var __proto=Stage.prototype;
	/**
	*@private
	*在移动端输入时，输入法弹出期间不进行画布尺寸重置。
	*/
	__proto._isInputting=function(){
		return (Browser.onMobile && Input.isInputting);
	}

	/**@private */
	__proto._changeCanvasSize=function(){
		this.setScreenSize(Browser.clientWidth *Browser.pixelRatio,Browser.clientHeight *Browser.pixelRatio);
	}

	/**@private */
	__proto._resetCanvas=function(){
		if (!this.screenAdaptationEnabled)return;
		var canvas=Render._mainCanvas;
		var canvasStyle=canvas.source.style;
		canvas.size(1,1);
		Laya.timer.once(100,this,this._changeCanvasSize);
	}

	/**
	*设置屏幕大小，场景会根据屏幕大小进行适配。可以动态调用此方法，来更改游戏显示的大小。
	*@param screenWidth 屏幕宽度。
	*@param screenHeight 屏幕高度。
	*/
	__proto.setScreenSize=function(screenWidth,screenHeight){
		var rotation=false;
		if (this._screenMode!=="none"){
			var screenType=screenWidth / screenHeight < 1 ? "vertical" :"horizontal";
			rotation=screenType!==this._screenMode;
			if (rotation){
				var temp=screenHeight;
				screenHeight=screenWidth;
				screenWidth=temp;
			}
		}
		this.canvasRotation=rotation;
		var canvas=Render._mainCanvas;
		var canvasStyle=canvas.source.style;
		var mat=this._canvasTransform.identity();
		var scaleMode=this._scaleMode;
		var scaleX=screenWidth / this.designWidth;
		var scaleY=screenHeight / this.designHeight;
		var canvasWidth=this.designWidth;
		var canvasHeight=this.designHeight;
		var realWidth=screenWidth;
		var realHeight=screenHeight;
		var pixelRatio=Browser.pixelRatio;
		this._width=this.designWidth;
		this._height=this.designHeight;
		switch (scaleMode){
			case "noscale":
				scaleX=scaleY=1;
				realWidth=this.designWidth;
				realHeight=this.designHeight;
				break ;
			case "showall":
				scaleX=scaleY=Math.min(scaleX,scaleY);
				canvasWidth=realWidth=Math.round(this.designWidth *scaleX);
				canvasHeight=realHeight=Math.round(this.designHeight *scaleY);
				break ;
			case "noborder":
				scaleX=scaleY=Math.max(scaleX,scaleY);
				realWidth=Math.round(this.designWidth *scaleX);
				realHeight=Math.round(this.designHeight *scaleY);
				break ;
			case "full":
				scaleX=scaleY=1;
				this._width=canvasWidth=screenWidth;
				this._height=canvasHeight=screenHeight;
				break ;
			case "fixedwidth":
				scaleY=scaleX;
				this._height=canvasHeight=Math.round(screenHeight / scaleX);
				break ;
			case "fixedheight":
				scaleX=scaleY;
				this._width=canvasWidth=Math.round(screenWidth / scaleY);
				break ;
			case "fixedauto":
				if ((screenWidth / screenHeight)< (this.designWidth / this.designHeight)){
					scaleY=scaleX;
					this._height=canvasHeight=Math.round(screenHeight / scaleX);
					}else {
					scaleX=scaleY;
					this._width=canvasWidth=Math.round(screenWidth / scaleY);
				}
				break ;
			}
		scaleX *=this.scaleX;
		scaleY *=this.scaleY;
		if (scaleX===1 && scaleY===1){
			this.transform.identity();
			}else {
			this.transform.a=this._formatData(scaleX / (realWidth / canvasWidth));
			this.transform.d=this._formatData(scaleY / (realHeight / canvasHeight));
		}
		canvas.size(canvasWidth,canvasHeight);
		RunDriver.changeWebGLSize(canvasWidth,canvasHeight);
		mat.scale(realWidth / canvasWidth / pixelRatio,realHeight / canvasHeight / pixelRatio);
		if (this._alignH==="left")this.offset.x=0;
		else if (this._alignH==="right")this.offset.x=screenWidth-realWidth;
		else this.offset.x=(screenWidth-realWidth)*0.5 / pixelRatio;
		if (this._alignV==="top")this.offset.y=0;
		else if (this._alignV==="bottom")this.offset.y=screenHeight-realHeight;
		else this.offset.y=(screenHeight-realHeight)*0.5 / pixelRatio;
		this.offset.x=Math.round(this.offset.x);
		this.offset.y=Math.round(this.offset.y);
		mat.translate(this.offset.x,this.offset.y);
		if (this._safariOffsetY)mat.translate(0,this._safariOffsetY);
		this.canvasDegree=0;
		if (rotation){
			if (this._screenMode==="horizontal"){
				mat.rotate(Math.PI / 2);
				mat.translate(screenHeight / pixelRatio,0);
				this.canvasDegree=90;
				}else {
				mat.rotate(-Math.PI / 2);
				mat.translate(0,screenWidth / pixelRatio);
				this.canvasDegree=-90;
			}
		}
		mat.a=this._formatData(mat.a);
		mat.d=this._formatData(mat.d);
		mat.tx=this._formatData(mat.tx);
		mat.ty=this._formatData(mat.ty);
		canvasStyle.transformOrigin=canvasStyle.webkitTransformOrigin=canvasStyle.msTransformOrigin=canvasStyle.mozTransformOrigin=canvasStyle.oTransformOrigin="0px 0px 0px";
		canvasStyle.transform=canvasStyle.webkitTransform=canvasStyle.msTransform=canvasStyle.mozTransform=canvasStyle.oTransform="matrix("+mat.toString()+")";
		if (this._safariOffsetY)mat.translate(0,-this._safariOffsetY);
		mat.translate(parseInt(canvasStyle.left)|| 0,parseInt(canvasStyle.top)|| 0);
		this.visible=true;
		this._repaint |=0x02;
		this.event("resize");
	}

	/**@private */
	__proto._formatData=function(value){
		if (Math.abs(value)< 0.000001)return 0;
		if (Math.abs(1-value)< 0.001)return value > 0 ? 1 :-1;
		return value;
	}

	/**@inheritDoc */
	__proto.getMousePoint=function(){
		return Point.TEMP.setTo(this.mouseX,this.mouseY);
	}

	/**@inheritDoc */
	__proto.repaint=function(type){
		(type===void 0)&& (type=0x02);
		this._repaint=type;
	}

	/**@inheritDoc */
	__proto.parentRepaint=function(type){
		(type===void 0)&& (type=0x02);
	}

	/**@private */
	__proto._loop=function(){
		this.render(Render._context,0,0);
		return true;
	}

	/**@private */
	__proto._onmouseMove=function(e){
		this._mouseMoveTime=Browser.now();
	}

	/**
	*<p>获得距当前帧开始后，过了多少时间，单位为毫秒。</p>
	*<p>可以用来判断函数内时间消耗，通过合理控制每帧函数处理消耗时长，避免一帧做事情太多，对复杂计算分帧处理，能有效降低帧率波动。</p>
	*/
	__proto.getTimeFromFrameStart=function(){
		return Browser.now()-this._frameStartTime;
	}

	/**@inheritDoc */
	__proto.render=function(context,x,y){
		if (this.frameRate==="sleep"){
			var now=Browser.now();
			if (now-this._frameStartTime >=1000)this._frameStartTime=now;
			else return;
		}
		this._renderCount++;
		if (!this._visible){
			if (this._renderCount % 5===0){
				Stat.loopCount++;
				MouseManager.instance.runEvent();
				Laya.timer._update();
			}
			return;
		}
		this._frameStartTime=Browser.now();
		var frameMode=this.frameRate==="mouse" ? (((this._frameStartTime-this._mouseMoveTime)< 2000)? "fast" :"slow"):this.frameRate;
		var isFastMode=(frameMode!=="slow");
		var isDoubleLoop=(this._renderCount % 2===0);
		Stat.renderSlow=!isFastMode;
		Stat.mesh2DNum=0;
		if (isFastMode || isDoubleLoop){
			Stat.loopCount++;
			MouseManager.instance.runEvent();
			Laya.timer._update();
			RunDriver.update3DLoop();
			var scene;
			var i=0,n=0;
			for (i=0,n=this._scenes.length;i < n;i++){
				scene=this._scenes[i];
				(scene)&& (scene._updateScene());
			}
			if (Render.isWebGL && this.renderingEnabled){
				context.clear();
				_super.prototype.render.call(this,context,x,y);
			}
		}
		if (this.renderingEnabled && (isFastMode || !isDoubleLoop)){
			if (Render.isWebGL){
				RunDriver.clear(this._bgColor);
				context.flush();
				var cbook=laya.webgl.resource.CharBook.charbookInst;
				cbook.GC();
				VectorGraphManager.instance && VectorGraphManager.getInstance().endDispose();
				}else {
				RunDriver.clear(this._bgColor);
				_super.prototype.render.call(this,context,x,y);
				Render.isConchApp && context.flush();
			}
		}
	}

	/**@private */
	__proto._requestFullscreen=function(){
		var element=Browser.document.documentElement;
		if (element.requestFullscreen){
			element.requestFullscreen();
			}else if (element.mozRequestFullScreen){
			element.mozRequestFullScreen();
			}else if (element.webkitRequestFullscreen){
			element.webkitRequestFullscreen();
			}else if (element.msRequestFullscreen){
			element.msRequestFullscreen();
		}
	}

	/**@private */
	__proto._fullScreenChanged=function(){
		Laya.stage.event("fullscreenchange");
	}

	/**退出全屏模式*/
	__proto.exitFullscreen=function(){
		var document=Browser.document;
		if (document.exitFullscreen){
			document.exitFullscreen();
			}else if (document.mozCancelFullScreen){
			document.mozCancelFullScreen();
			}else if (document.webkitExitFullscreen){
			document.webkitExitFullscreen();
		}
	}

	/**当前视窗由缩放模式导致的 Y 轴缩放系数。*/
	__getset(0,__proto,'clientScaleY',function(){
		return this._transform ? this._transform.getScaleY():1;
	});

	__getset(0,__proto,'width',_super.prototype._$get_width,function(value){
		this.designWidth=value;
		Laya.superSet(Sprite,this,'width',value);
		Laya.timer.callLater(this,this._changeCanvasSize);
	});

	/**
	*舞台是否获得焦点。
	*/
	__getset(0,__proto,'isFocused',function(){
		return this._isFocused;
	});

	/**
	*<p>水平对齐方式。默认值为"left"。</p>
	*<p><ul>取值范围：
	*<li>"left" ：居左对齐；</li>
	*<li>"center" ：居中对齐；</li>
	*<li>"right" ：居右对齐；</li>
	*</ul></p>
	*/
	__getset(0,__proto,'alignH',function(){
		return this._alignH;
		},function(value){
		this._alignH=value;
		Laya.timer.callLater(this,this._changeCanvasSize);
	});

	__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
		this.designHeight=value;
		Laya.superSet(Sprite,this,'height',value);
		Laya.timer.callLater(this,this._changeCanvasSize);
	});

	__getset(0,__proto,'transform',function(){
		if (this._tfChanged)this._adjustTransform();
		return this._transform=this._transform|| this._createTransform();
	},_super.prototype._$set_transform);

	/**
	*舞台是否处于可见状态(是否进入后台)。
	*/
	__getset(0,__proto,'isVisibility',function(){
		return this._isVisibility;
	});

	/**
	*<p>缩放模式。默认值为 "noscale"。</p>
	*<p><ul>取值范围：
	*<li>"noscale" ：不缩放；</li>
	*<li>"exactfit" ：全屏不等比缩放；</li>
	*<li>"showall" ：最小比例缩放；</li>
	*<li>"noborder" ：最大比例缩放；</li>
	*<li>"full" ：不缩放，stage的宽高等于屏幕宽高；</li>
	*<li>"fixedwidth" ：宽度不变，高度根据屏幕比缩放；</li>
	*<li>"fixedheight" ：高度不变，宽度根据屏幕比缩放；</li>
	*<li>"fixedauto" ：根据宽高比，自动选择使用fixedwidth或fixedheight；</li>
	*</ul></p>
	*/
	__getset(0,__proto,'scaleMode',function(){
		return this._scaleMode;
		},function(value){
		this._scaleMode=value;
		Laya.timer.callLater(this,this._changeCanvasSize);
	});

	/**
	*<p>垂直对齐方式。默认值为"top"。</p>
	*<p><ul>取值范围：
	*<li>"top" ：居顶部对齐；</li>
	*<li>"middle" ：居中对齐；</li>
	*<li>"bottom" ：居底部对齐；</li>
	*</ul></p>
	*/
	__getset(0,__proto,'alignV',function(){
		return this._alignV;
		},function(value){
		this._alignV=value;
		Laya.timer.callLater(this,this._changeCanvasSize);
	});

	/**舞台的背景颜色，默认为黑色，null为透明。*/
	__getset(0,__proto,'bgColor',function(){
		return this._bgColor;
		},function(value){
		this._bgColor=value;
		if (Render.isWebGL){
			if (value && value!=="black" && value!=="#000000"){
				this._wgColor=Color.create(value).arrColor;
				}else {
				this._wgColor=null;
			}
		}
		if (value){
			Render.canvas.style.background=value;
			}else {
			Render.canvas.style.background="none";
		}
	});

	/**鼠标在 Stage 上的 X 轴坐标。*/
	__getset(0,__proto,'mouseX',function(){
		return Math.round(MouseManager.instance.mouseX / this.clientScaleX);
	});

	/**鼠标在 Stage 上的 Y 轴坐标。*/
	__getset(0,__proto,'mouseY',function(){
		return Math.round(MouseManager.instance.mouseY / this.clientScaleY);
	});

	/**当前视窗由缩放模式导致的 X 轴缩放系数。*/
	__getset(0,__proto,'clientScaleX',function(){
		return this._transform ? this._transform.getScaleX():1;
	});

	/**
	*<p>场景布局类型。</p>
	*<p><ul>取值范围：
	*<li>"none" ：不更改屏幕</li>
	*<li>"horizontal" ：自动横屏</li>
	*<li>"vertical" ：自动竖屏</li>
	*</ul></p>
	*/
	__getset(0,__proto,'screenMode',function(){
		return this._screenMode;
		},function(value){
		this._screenMode=value;
	});

	__getset(0,__proto,'visible',_super.prototype._$get_visible,function(value){
		if (this.visible!==value){
			Laya.superSet(Sprite,this,'visible',value);
			var style=Render._mainCanvas.source.style;
			style.visibility=value ? "visible" :"hidden";
		}
	});

	/**
	*<p>是否开启全屏，用户点击后进入全屏。</p>
	*<p>兼容性提示：部分浏览器不允许点击进入全屏，比如Iphone等。</p>
	*/
	__getset(0,__proto,'fullScreenEnabled',null,function(value){
		var document=Browser.document;
		var canvas=Render.canvas;
		if (value){
			canvas.addEventListener('mousedown',this._requestFullscreen);
			canvas.addEventListener('touchstart',this._requestFullscreen);
			document.addEventListener("fullscreenchange",this._fullScreenChanged);
			document.addEventListener("mozfullscreenchange",this._fullScreenChanged);
			document.addEventListener("webkitfullscreenchange",this._fullScreenChanged);
			document.addEventListener("msfullscreenchange",this._fullScreenChanged);
			}else {
			canvas.removeEventListener('mousedown',this._requestFullscreen);
			canvas.removeEventListener('touchstart',this._requestFullscreen);
			document.removeEventListener("fullscreenchange",this._fullScreenChanged);
			document.removeEventListener("mozfullscreenchange",this._fullScreenChanged);
			document.removeEventListener("webkitfullscreenchange",this._fullScreenChanged);
			document.removeEventListener("msfullscreenchange",this._fullScreenChanged);
		}
	});

	Stage.SCALE_NOSCALE="noscale";
	Stage.SCALE_EXACTFIT="exactfit";
	Stage.SCALE_SHOWALL="showall";
	Stage.SCALE_NOBORDER="noborder";
	Stage.SCALE_FULL="full";
	Stage.SCALE_FIXED_WIDTH="fixedwidth";
	Stage.SCALE_FIXED_HEIGHT="fixedheight";
	Stage.SCALE_FIXED_AUTO="fixedauto";
	Stage.ALIGN_LEFT="left";
	Stage.ALIGN_RIGHT="right";
	Stage.ALIGN_CENTER="center";
	Stage.ALIGN_TOP="top";
	Stage.ALIGN_MIDDLE="middle";
	Stage.ALIGN_BOTTOM="bottom";
	Stage.SCREEN_NONE="none";
	Stage.SCREEN_HORIZONTAL="horizontal";
	Stage.SCREEN_VERTICAL="vertical";
	Stage.FRAME_FAST="fast";
	Stage.FRAME_SLOW="slow";
	Stage.FRAME_MOUSE="mouse";
	Stage.FRAME_SLEEP="sleep";
	return Stage;
})(Sprite)


	//file:///E:/git/layaair-master/core/src/laya/resource/HTMLCanvas.as=======96.999608/96.999608
/**
*<code>HTMLCanvas</code> 是 Html Canvas 的代理类，封装了 Canvas 的属性和方法。。请不要直接使用 new HTMLCanvas！
*/
//class laya.resource.HTMLCanvas extends laya.resource.Bitmap
var HTMLCanvas=(function(_super){
	function HTMLCanvas(type){
		//this._ctx=null;
		this._is2D=false;
		//this._source=null;
		/**
		*获取 Canvas 渲染上下文。
		*@param contextID 上下文ID.
		*@param other
		*@return Canvas 渲染上下文 Context 对象。
		*/
		this.getContext=function(contextID,other){
			return _$this._ctx ? _$this._ctx :(_$this._ctx=HTMLCanvas._createContext(this));
		}
		HTMLCanvas.__super.call(this);
		var _$this=this;
		this._source=this;
		if (type==="2D" || (type==="AUTO" && !Render.isWebGL)){
			this._is2D=true;
			this._source=Browser.createElement("canvas");
			var o=this;
			o.getContext=function (contextID,other){
				if (_$this._ctx)return _$this._ctx;
				if (Render.isConchApp){
					_$this._ctx=new LayaGLNativeContext(this);
					LayaGLContext._mainGL=_$this._ctx;
					return _$this._ctx;
				};
				var ctx=_$this._ctx=_$this._source.getContext(contextID,other);
				if (ctx){
					ctx._canvas=o;
					ctx.size=function (w,h){
					};
				}
				return ctx;
			}
		}
	}

	__class(HTMLCanvas,'laya.resource.HTMLCanvas',_super);
	var __proto=HTMLCanvas.prototype;
	/**
	*清空画布内容。
	*/
	__proto.clear=function(){
		this._ctx && this._ctx.clear();
	}

	/**
	*销毁。
	*/
	__proto.destroy=function(){
		this._ctx && this._ctx.destroy();
		this._ctx=null;
	}

	/**
	*释放。
	*/
	__proto.release=function(){}
	/**
	*@private
	*设置 Canvas 渲染上下文。
	*@param context Canvas 渲染上下文。
	*/
	__proto._setContext=function(context){
		this._ctx=context;
	}

	/**
	*获取内存大小。
	*@return 内存大小。
	*/
	__proto.getMemSize=function(){
		return 0;
	}

	/**
	*设置宽高。
	*@param w 宽度。
	*@param h 高度。
	*/
	__proto.size=function(w,h){
		if (this._width !=w || this._height !=h || (this._source && (this._source.width !=w || this._source.height !=h))){
			this._width=w;
			this._height=h;
			this.memorySize=w *h *4;
			this._ctx && this._ctx.size(w,h);
			this._source && (this._source.height=h,this._source.width=w);
		}
	}

	__proto.getCanvas=function(){
		return this._source;
	}

	/**
	*@inheritDoc
	*/
	__getset(0,__proto,'source',function(){
		return this._source;
	});

	/**
	*Canvas 渲染上下文。
	*/
	__getset(0,__proto,'context',function(){
		return this._ctx;
	});

	/**
	*是否当作 Bitmap 对象。
	*/
	__getset(0,__proto,'asBitmap',null,function(value){
	});

	HTMLCanvas.create=function(type){
		return new HTMLCanvas(type);
	}

	HTMLCanvas.TYPE2D="2D";
	HTMLCanvas.TYPE3D="3D";
	HTMLCanvas.TYPEAUTO="AUTO";
	HTMLCanvas._createContext=null;
	return HTMLCanvas;
})(Bitmap)


	//file:///E:/git/layaair-master/core/src/laya/resource/HTMLImage.as=======96.999607/96.999607
/**
*@private
*<p> <code>HTMLImage</code> 用于创建 HTML Image 元素。</p>
*<p>请使用 <code>HTMLImage.create()<code>获取新实例，不要直接使用 <code>new HTMLImage<code> 。</p>
*/
//class laya.resource.HTMLImage extends laya.resource.Bitmap
var HTMLImage=(function(_super){
	function HTMLImage(){
		/**@private */
		//this._source=null;
		HTMLImage.__super.call(this);
	}

	__class(HTMLImage,'laya.resource.HTMLImage',_super);
	var __proto=HTMLImage.prototype;
	/**
	*通过图片源填充纹理,可为HTMLImageElement、HTMLCanvasElement、HTMLVideoElement、ImageBitmap、ImageData。
	*/
	__proto.setImageSource=function(source){
		var width=source.width;
		var height=source.height;
		if (width <=0 || height <=0)
			throw new Error("HTMLImage:width or height must large than 0.");
		this._width=width;
		this._height=height;
		this._source=source;
		this.memorySize=width *height *4;
		this._activeResource();
	}

	/**
	*@inheritDoc
	*/
	__proto.disposeResource=function(){
		(this._source)&& (this._source=null,this.memorySize=0);
	}

	/**
	*@inheritDoc
	*/
	__proto._getSource=function(){
		return this._source;
	}

	HTMLImage.create=function(){
		return new HTMLImage();
	}

	return HTMLImage;
})(Bitmap)


	//file:///E:/git/layaair-master/core/src/laya/display/Input.as=======95.999822/95.999822
/**
*<p><code>Input</code> 类用于创建显示对象以显示和输入文本。</p>
*<p>Input 类封装了原生的文本输入框，由于不同浏览器的差异，会导致此对象的默认文本的位置与用户点击输入时的文本的位置有少许的偏差。</p>
*/
//class laya.display.Input extends laya.display.Text
var Input=(function(_super){
	function Input(){
		/**@private */
		this._focus=false;
		/**@private */
		this._multiline=false;
		/**@private */
		this._editable=true;
		/**@private */
		this._restrictPattern=null;
		/**@private */
		this._type="text";
		/**@private 输入提示符。*/
		this._prompt='';
		/**@private 输入提示符颜色。*/
		this._promptColor="#A9A9A9";
		/**@private */
		this._originColor="#000000";
		/**@private */
		this._content='';
		Input.__super.call(this);
		this._maxChars=1E5;
		this._width=100;
		this._height=20;
		this.multiline=false;
		this.overflow="scroll";
		this.on("mousedown",this,this._onMouseDown);
		this.on("undisplay",this,this._onUnDisplay);
	}

	__class(Input,'laya.display.Input',_super);
	var __proto=Input.prototype;
	/**
	*设置光标位置和选取字符。
	*@param startIndex 光标起始位置。
	*@param endIndex 光标结束位置。
	*/
	__proto.setSelection=function(startIndex,endIndex){
		laya.display.Input.inputElement.selectionStart=startIndex;
		laya.display.Input.inputElement.selectionEnd=endIndex;
	}

	__proto._onUnDisplay=function(e){
		this.focus=false;
	}

	__proto._onMouseDown=function(e){
		this.focus=true;
	}

	/**
	*在输入期间，如果 Input 实例的位置改变，调用_syncInputTransform同步输入框的位置。
	*/
	__proto._syncInputTransform=function(){
		var inputElement=this.nativeInput;
		var transform=Utils.getTransformRelativeToWindow(this,this.padding[3],this.padding[0]);
		var inputWid=this._width-this.padding[1]-this.padding[3];
		var inputHei=this._height-this.padding[0]-this.padding[2];
		if (Render.isConchApp){
			inputElement.setScale(transform.scaleX,transform.scaleY);
			inputElement.setSize(inputWid,inputHei);
			inputElement.setPos(transform.x,transform.y);
			}else {
			Input.inputContainer.style.transform=Input.inputContainer.style.webkitTransform="scale("+transform.scaleX+","+transform.scaleY+") rotate("+(Laya.stage.canvasDegree)+"deg)";
			inputElement.style.width=inputWid+'px';
			inputElement.style.height=inputHei+'px';
			Input.inputContainer.style.left=transform.x+'px';
			Input.inputContainer.style.top=transform.y+'px';
		}
	}

	/**选中当前实例的所有文本。*/
	__proto.select=function(){
		this.nativeInput.select();
	}

	__proto._setInputMethod=function(){
		Input.input.parentElement && (Input.inputContainer.removeChild(Input.input));
		Input.area.parentElement && (Input.inputContainer.removeChild(Input.area));
		Input.inputElement=(this._multiline ? Input.area :Input.input);
		Input.inputContainer.appendChild(Input.inputElement);
	}

	__proto._focusIn=function(){
		laya.display.Input.isInputting=true;
		var input=this.nativeInput;
		this._focus=true;
		var cssStyle=input.style;
		cssStyle.whiteSpace=(this.wordWrap ? "pre-wrap" :"nowrap");
		this._setPromptColor();
		input.readOnly=!this._editable;
		if (Render.isConchApp){
			input.setForbidEdit(!this._editable);
		}
		input.maxLength=this._maxChars;
		var padding=this.padding;
		input.type=this._type;
		input.value=this._content;
		input.placeholder=this._prompt;
		Laya.stage.off("keydown",this,this._onKeyDown);
		Laya.stage.on("keydown",this,this._onKeyDown);
		Laya.stage.focus=this;
		this.event("focus");
		if (Browser.onPC)input.focus();
		var temp=this._text;
		this._text=null;
		this.typeset();
		input.setColor(this._originColor);
		input.setFontSize(this.fontSize);
		input.setFontFace(Browser.onIPhone ? (Text.fontFamilyMap[this.font] || this.font):this.font);
		if (Render.isConchApp){
			input.setMultiAble && input.setMultiAble(this._multiline);
		}
		cssStyle.lineHeight=(this.leading+this.fontSize)+"px";
		cssStyle.fontStyle=(this.italic ? "italic" :"normal");
		cssStyle.fontWeight=(this.bold ? "bold" :"normal");
		cssStyle.textAlign=this.align;
		cssStyle.padding="0 0";
		this._syncInputTransform();
		if (!Render.isConchApp && Browser.onPC)
			Laya.timer.frameLoop(1,this,this._syncInputTransform);
	}

	// 设置DOM输入框提示符颜色。
	__proto._setPromptColor=function(){
		Input.promptStyleDOM=Browser.getElementById("promptStyle");
		if (!Input.promptStyleDOM){
			Input.promptStyleDOM=Browser.createElement("style");
			Input.promptStyleDOM.setAttribute("id","promptStyle");
			Browser.document.head.appendChild(Input.promptStyleDOM);
		}
		Input.promptStyleDOM.innerText="input::-webkit-input-placeholder, textarea::-webkit-input-placeholder {"+"color:"+this._promptColor+"}"+"input:-moz-placeholder, textarea:-moz-placeholder {"+"color:"+this._promptColor+"}"+"input::-moz-placeholder, textarea::-moz-placeholder {"+"color:"+this._promptColor+"}"+"input:-ms-input-placeholder, textarea:-ms-input-placeholder {"+"color:"+this._promptColor+"}";
	}

	/**@private */
	__proto._focusOut=function(){
		laya.display.Input.isInputting=false;
		this._focus=false;
		this._text=null;
		this._content=this.nativeInput.value;
		if (!this._content){
			Laya.superSet(Text,this,'text',this._prompt);
			Laya.superSet(Text,this,'color',this._promptColor);
			}else {
			Laya.superSet(Text,this,'text',this._content);
			Laya.superSet(Text,this,'color',this._originColor);
		}
		Laya.stage.off("keydown",this,this._onKeyDown);
		Laya.stage.focus=null;
		this.event("blur");
		if (Render.isConchApp)this.nativeInput.blur();
		Browser.onPC && Laya.timer.clear(this,this._syncInputTransform);
	}

	/**@private */
	__proto._onKeyDown=function(e){
		if (e.keyCode===13){
			if (Browser.onMobile && !this._multiline)this.focus=false;
			this.event("enter");
		}
	}

	__proto.changeText=function(text){
		this._content=text;
		if (this._focus){
			this.nativeInput.value=text || '';
			this.event("change");
		}else
		_super.prototype.changeText.call(this,text);
	}

	/**@inheritDoc */
	__getset(0,__proto,'color',_super.prototype._$get_color,function(value){
		if (this._focus)this.nativeInput.setColor(value);
		Laya.superSet(Text,this,'color',this._content?value:this._promptColor);
		this._originColor=value;
	});

	/**表示是否是多行输入框。*/
	__getset(0,__proto,'multiline',function(){
		return this._multiline;
		},function(value){
		this._multiline=value;
		this.valign=value ? "top" :"middle";
	});

	/**
	*<p>字符数量限制，默认为10000。</p>
	*<p>设置字符数量限制时，小于等于0的值将会限制字符数量为10000。</p>
	*/
	__getset(0,__proto,'maxChars',function(){
		return this._maxChars;
		},function(value){
		if (value <=0)value=1E5;
		this._maxChars=value;
	});

	/**@inheritDoc */
	__getset(0,__proto,'text',function(){
		if (this._focus)return this.nativeInput.value;
		else return this._content || "";
		},function(value){
		Laya.superSet(Text,this,'color',this._originColor);
		value+='';
		if (this._focus){
			this.nativeInput.value=value || '';
			this.event("change");
			}else {
			if (!this._multiline)value=value.replace(/\r?\n/g,'');
			this._content=value;
			if (value)
				Laya.superSet(Text,this,'text',value);
			else {
				Laya.superSet(Text,this,'text',this._prompt);
				Laya.superSet(Text,this,'color',this.promptColor);
			}
		}
	});

	/**
	*获取对输入框的引用实例。
	*/
	__getset(0,__proto,'nativeInput',function(){
		return this._multiline ? Input.area :Input.input;
	});

	/**
	*设置输入提示符。
	*/
	__getset(0,__proto,'prompt',function(){
		return this._prompt;
		},function(value){
		if (!this._text && value)Laya.superSet(Text,this,'color',this._promptColor);
		this.promptColor=this._promptColor;
		if (this._text)Laya.superSet(Text,this,'text',(this._text==this._prompt)?value:this._text);
		else Laya.superSet(Text,this,'text',value);
		this._prompt=Text.langPacks && Text.langPacks[value] ? Text.langPacks[value] :value;
	});

	// 因此 调用focus接口是无法都在移动平台立刻弹出键盘的
	/**
	*表示焦点是否在此实例上。
	*/
	__getset(0,__proto,'focus',function(){
		return this._focus;
		},function(value){
		var input=this.nativeInput;
		if (this._focus!==value){
			if (value){
				if (input.target){
					input.target._focusOut();
					}else {
					this._setInputMethod();
				}
				input.target=this;
				this._focusIn();
				}else {
				input.target=null;
				this._focusOut();
				input.blur();
				if (Render.isConchApp)input.setPos(-10000,-10000);
				else if (Input.inputContainer.contains(input))Input.inputContainer.removeChild(input);
			}
		}
	});

	/**限制输入的字符。*/
	__getset(0,__proto,'restrict',function(){
		if (this._restrictPattern){
			return this._restrictPattern.source;
		}
		return "";
		},function(pattern){
		if (pattern){
			pattern="[^"+pattern+"]";
			if (pattern.indexOf("^^")>-1)pattern=pattern.replace("^^","");
			this._restrictPattern=new RegExp(pattern,"g");
		}else
		this._restrictPattern=null;
	});

	/**
	*是否可编辑。
	*/
	__getset(0,__proto,'editable',function(){
		return this._editable;
		},function(value){
		this._editable=value;
		if (Render.isConchApp){
			Input.input.setForbidEdit(!value);
		}
	});

	/**
	*设置输入提示符颜色。
	*/
	__getset(0,__proto,'promptColor',function(){
		return this._promptColor;
		},function(value){
		this._promptColor=value;
		if (!this._content)Laya.superSet(Text,this,'color',value);
	});

	/**
	*<p>输入框类型为Input静态常量之一。</p>
	*<ul>
	*<li>TYPE_TEXT</li>
	*<li>TYPE_PASSWORD</li>
	*<li>TYPE_EMAIL</li>
	*<li>TYPE_URL</li>
	*<li>TYPE_NUMBER</li>
	*<li>TYPE_DATE</li>
	*<li>TYPE_MONTH</li>
	*<li>TYPE_WEEK</li>
	*<li>TYPE_TIME</li>
	*<li>TYPE_DATE_TIME</li>
	*<li>TYPE_DATE_TIME_LOCAL</li>
	*</ul>
	*<p>平台兼容性参见http://www.w3school.com.cn/html5/html_5_form_input_types.asp。</p>
	*/
	__getset(0,__proto,'type',function(){
		return this._type;
		},function(value){
		if (value==="password")this._getTextStyle().asPassword=true;
		else this._getTextStyle().asPassword=false;
		this._type=value;
	});

	Input.__init__=function(){
		Input._createInputElement();
		if (Browser.onMobile)Render.canvas.addEventListener(Input.IOS_IFRAME ? "click" :"touchend",Input._popupInputMethod);
	}

	Input._popupInputMethod=function(e){
		if (!laya.display.Input.isInputting)return;
		laya.display.Input.inputElement.focus();
	}

	Input._createInputElement=function(){
		Input._initInput(Input.area=Browser.createElement("textarea"));
		Input._initInput(Input.input=Browser.createElement("input"));
		Input.inputContainer=Browser.createElement("div");
		Input.inputContainer.style.position="absolute";
		Input.inputContainer.style.zIndex=1E5;
		Browser.container.appendChild(Input.inputContainer);
		Input.inputContainer.setPos=function (x,y){
			Input.inputContainer.style.left=x+'px';
			Input.inputContainer.style.top=y+'px';
		};
	}

	Input._initInput=function(input){
		var style=input.style;
		style.cssText="position:absolute;overflow:hidden;resize:none;transform-origin:0 0;-webkit-transform-origin:0 0;-moz-transform-origin:0 0;-o-transform-origin:0 0;";
		style.resize='none';
		style.backgroundColor='transparent';
		style.border='none';
		style.outline='none';
		style.zIndex=1;
		input.addEventListener('input',Input._processInputting);
		input.addEventListener('mousemove',Input._stopEvent);
		input.addEventListener('mousedown',Input._stopEvent);
		input.addEventListener('touchmove',Input._stopEvent);
		input.setFontFace=function (fontFace){input.style.fontFamily=fontFace;};
		if(!Render.isConchApp){
			input.setColor=function (color){input.style.color=color;};
			input.setFontSize=function (fontSize){input.style.fontSize=fontSize+'px';};
		}
	}

	Input._processInputting=function(e){
		var input=laya.display.Input.inputElement.target;
		if (!input)return;
		var value=laya.display.Input.inputElement.value;
		if (input._restrictPattern){
			value=value.replace(/\u2006|\x27/g,"");
			if (input._restrictPattern.test(value)){
				value=value.replace(input._restrictPattern,"");
				laya.display.Input.inputElement.value=value;
			}
		}
		input._text=value;
		input.event("input");
	}

	Input._stopEvent=function(e){
		if (e.type=='touchmove')e.preventDefault();
		e.stopPropagation && e.stopPropagation();
	}

	Input.TYPE_TEXT="text";
	Input.TYPE_PASSWORD="password";
	Input.TYPE_EMAIL="email";
	Input.TYPE_URL="url";
	Input.TYPE_NUMBER="number";
	Input.TYPE_DATE="date";
	Input.TYPE_MONTH="month";
	Input.TYPE_WEEK="week";
	Input.TYPE_TIME="time";
	Input.TYPE_DATE_TIME="datetime";
	Input.TYPE_DATE_TIME_LOCAL="datetime-local";
	Input.TYPE_SEARCH="search";
	Input.input=null;
	Input.area=null;
	Input.inputElement=null;
	Input.inputContainer=null;
	Input.promptStyleDOM=null;
	Input.isInputting=false;
	__static(Input,
	['IOS_IFRAME',function(){return this.IOS_IFRAME=(Browser.onIOS && Browser.window.top !=Browser.window.self);}
	]);
	return Input;
})(Text)


	Laya.__init([LayaGL,EventDispatcher,Render,LayaGL2DTemplateCreater,Timer,LoaderManager]);
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