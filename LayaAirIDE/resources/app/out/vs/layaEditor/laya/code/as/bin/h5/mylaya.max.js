/***********************************/
/*http://www.layabox.com 2016/2/27*/
/***********************************/
window.Laya=(function(window,document){
	var Laya={
		__internals:[],
		__packages:{},
		__classmap:{'Object':Object,'Function':Function,'Array':Array,'String':String},
		__sysClass:{'object':'Object','array':'Array','string':'String','dictionary':'Dictionary'},
		__propun:{writable: true,enumerable: false,configurable: true},
		__presubstr:String.prototype.substr,
		__substr:function(ofs,sz){return arguments.length==1?Laya.__presubstr.call(this,ofs):Laya.__presubstr.call(this,ofs,sz>0?sz:(this.length+sz));},
		__init:function(_classs){_classs.forEach(function(o){o.__init$ && o.__init$();});},
		__parseInt:function(value){return !value?0:parseInt(value);},
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
				var g = b.__lookupGetter__(p), s = b.__lookupSetter__(p); 
				if ( g || s ) {
					g && d.__defineGetter__(p, g);
					s && d.__defineSetter__(p, s);
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
			if(value==String) return (typeof o=='string');
			if(value==Number) return (typeof o=='number');
			if(value.__interface__) value=value.__interface__;
			else if(typeof value!='string')  return (o instanceof value);
			return (o.__imps && o.__imps[value]) || (o.__class==value);
		},
		__as:function(value,type){
			return (this.__typeof(value,type))?value:null;
		},		
		interface:function(name,_super){
			Laya.__package(name,{});
			var ins=Laya.__internals;
			var a=ins[name]=ins[name] || {};
			a.self=name;
			if(_super)a.extend=ins[_super]=ins[_super] || {};
			var o=window,words=name.split('.');
			for(var i=0;i<words.length-1;i++) o=o[words[i]];o[words[words.length-1]]={__interface__:name};
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
						if(Laya[miniName]) console.log('warning:class name redefinition,'+fullName+'/'+Laya[miniName]);
						Laya[miniName]=o;
					}					
				}
				else {
					if(fullName=="Main")
						window.Main=o;
					else{
						if(Laya[fullName]){
							console.log('warning:class name redefinition,'+fullName+'/'+Laya[fullName]);
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
			for(var i in src){
				d[i]=src[i];
				var c=i;
				while((c=this.__internals[c]) && (c=c.extend) ){
					c=c.self;d[c]=true;
				}
			}
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
				Object.defineProperty(o,name,{get:getfn,set:setfn,enumerable:false});
			else{
				getfn && Object.defineProperty(o,name,{get:getfn,enumerable:false});
				setfn && Object.defineProperty(o,name,{set:setfn,enumerable:false});
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
			arguments.length<3 &&(value=obj[name]);
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
	String.prototype.substr=Laya.__substr;
	Object.defineProperty(Array.prototype,'fixed',{enumerable: false});

	return Laya;
})(window,document);

(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;
	Laya.interface('laya.resource.IDispose');
	Laya.interface('laya.ui.IRender');
	Laya.interface('laya.display.ILayout');
	Laya.interface('laya.ui.IItem');
	Laya.interface('laya.ui.ISelect');
	Laya.interface('laya.filters.IFilter');
	Laya.interface('laya.filters.IFilterAction');
	var wait=Laya.wait=function(conditions){
		return Asyn.wait(conditions);
	}


	var await=Laya.await=function(caller,fn,nextLine){
		Asyn._caller_=caller;
		Asyn._callback_=fn;
		Asyn._nextLine_=nextLine;
	}


	var sleep=Laya.sleep=function(value){
		Asyn.sleep(value);
	}


	var load=Laya.load=function(url,type){
		return Asyn.load(url,type);
	}


	/**
	*<code>Laya</code> 是全局对象的引用入口集。
	*/
	//class Laya
	var ___Laya=(function(){
		//function Laya(){};
		/**
		*表示是否捕获全局错误并弹出提示。
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
			for (var i=0,n=plugins.length;i < n;i++){
				if (plugins[i].enable)plugins[i].enable();
			}
			Font.__init__();
			Style.__init__();
			ResourceManager.__init__();
			Laya.stage=new Stage();
			var location=Browser.window.location;
			URL.rootPath=URL.basePath=URL.getPath(location.protocal=="file:" ? location.pathname :location.href);
			Laya.initAsyn();
			Laya.render=new Render(width,height);
			Laya.stage.size(width,height);
			RenderSprite.__init__();
			KeyBoardManager.__init__();
			MouseManager.instance.__init__();
		}

		Laya.initAsyn=function(){
			Asyn.loadDo=function (url,type,d){
				var l=new Loader();
				if (d){
					l.once("complete",null,function(data){
						d.callback(data);
					});
					l.once("error",null,function(err){
					});
				}
				l.load(url,type);
				return d;
			}
			Asyn.onceTimer=function (delay,d){
				Laya.timer.once(delay,d,d.callback);
			}
			Asyn.onceEvent=function (type,listener){
				Laya.stage.once(type,null,listener);
			}
			Laya.timer.frameLoop(1,null,Asyn._loop_);
		}

		Laya.stage=null;
		Laya.render=null
		Laya.version="0.9.8";
		Laya.is3DMode=false;
		__static(Laya,
		['timer',function(){return this.timer=new Timer();},'loader',function(){return this.loader=new LoaderManager();}
		]);
		return Laya;
	})()


	/**
	*<code>EventDispatcher</code> 类是可调度事件的所有类的基类。
	*/
	//class laya.events.EventDispatcher
	var EventDispatcher=(function(){
		var EventHandler;
		function EventDispatcher(){
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
		*@param data 回调数据。
		*<b>注意：</b>如果是需要传递多个参数 p1,p2,p3,...可以使用数组结构如：[p1,p2,p3,...] ；如果需要回调单个参数 p 是一个数组，则需要使用结构如：[p]，其他的单个参数 p ，可以直接传入参数 p。
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
						data !=null ? listener.runWith(data):listener.run();
					}
					if (!listener || listener.once){
						listeners.splice(i,1);
						i--;
						n--;
					}
				}
				if (listeners.length===0)delete this._events[type];
			}
			return true;
		}

		/**
		*使用 EventDispatcher 对象注册指定类型的事件侦听器对象，以使侦听器能够接收事件通知。
		*@param type 事件的类型。
		*@param caller 事件侦听函数的执行域。
		*@param listener 事件侦听函数。
		*@param args 事件侦听函数的回调参数。
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
		*@param args 事件侦听函数的回调参数。
		*@return 此 EventDispatcher 对象。
		*/
		__proto.once=function(type,caller,listener,args){
			return this._createListener(type,caller,listener,args,true);
		}

		__proto._createListener=function(type,caller,listener,args,once){
			this.off(type,caller,listener,once);
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
		*@param onceOnly 如果值为 true ,则只移除通过 once 方法添加的侦听器。
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
		*@param type 事件类型，如果值为 null，则移除本对象所有类型的侦听器。
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
			return EventDispatcher.MOUSE_EVENTS[type];
		}

		EventDispatcher.MOUSE_EVENTS={"rightmousedown":true,"rightmouseup":true,"rightclick":true,"mousedown":true,"mouseup":true,"mousemove":true,"mouseover":true,"mouseout":true,"click":true,"doubleclick":true};
		EventDispatcher.__init$=function(){
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


	/**
	*<p><code>Handler</code> 是事件处理器类。</p>
	*<p>推荐使用 Handler.create()方法从对象池创建，减少对象创建消耗。</p>
	*<p><b>注意：</b>由于鼠标事件也用本对象池，不正确的回收及调用，可能会影响鼠标事件的执行。</p>
	*/
	//class laya.utils.Handler
	var Handler=(function(){
		function Handler(caller,method,args,once){
			//this.caller=null;
			//this.method=null;
			//this.args=null;
			this.once=false;
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
			if (this.method==null)return;
			var id=this._id;
			this.method.apply(this.caller,this.args);
			this._id===id && this.once && this.recover();
		}

		/**
		*执行处理器，携带额外数据。
		*@param data 附加的回调数据，可以是单数据或者Array(作为多参)。
		*/
		__proto.runWith=function(data){
			if (this.method==null)return;
			var id=this._id;
			if (data==null)this.method.apply(this.caller,this.args);
			else if (!this.args && !data.unshift)this.method.call(this.caller,data);
			else if (this.args)this.method.apply(this.caller,this.args ? this.args.concat(data):data);
			else this.method.apply(this.caller,data);
			this._id===id && this.once && this.recover();
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


	//class Main
	var Main=(function(){
		function Main(){
			Laya.init(600,400);
			Laya.loader.load([{url:"res/atlas/comp.json",type:"atlas"}],Handler.create(this,this.onLoaded));
		}

		__class(Main,'Main');
		var __proto=Main.prototype;
		__proto.onLoaded=function(){
			var testView=new TestView();
			Laya.stage.addChild(testView);
		}

		return Main;
	})()


	/**
	*Config 用于配置一些全局参数。
	*/
	//class Config
	var Config=(function(){
		function Config(){};
		__class(Config,'Config');
		Config.showLog=false;
		Config.atlasEnable=false;
		Config.showCanvasMark=false;
		Config.CPUMemoryLimit=120 *1024 *1024;
		Config.GPUMemoryLimit=160 *1024 *1024;
		Config.animationInterval=30;
		return Config;
	})()


	/**
	*<code>Asyn</code> 用于函数异步处理。
	*/
	//class laya.asyn.Asyn
	var Asyn=(function(){
		function Asyn(){};
		__class(Asyn,'laya.asyn.Asyn');
		Asyn.wait=function(conditions){
			var d=new Deferred();
			if (conditions.indexOf("event:")==0){
				Asyn.onceEvent(conditions.substr(8),function(){
					d.callback();
				});
				return null;
			}
			d.loopIndex=Asyn._loopCount;
			return Asyn._Deferreds[conditions]=d;
		}

		Asyn.callLater=function(d){
			Asyn._callLater.push(d);
		}

		Asyn.notify=function(conditions,value){
			var o=Asyn._Deferreds[conditions];
			if (o){
				Asyn._Deferreds[conditions]=null;
				o.callback(value);
			}
		}

		Asyn.load=function(url,type){
			return Asyn.loadDo(url,type,new Deferred());
		}

		Asyn.sleep=function(delay){
			if (delay < 1){
				if (Asyn._loopsCount >=Asyn.loops[Asyn._loopsIndex].length){
					Asyn._loopsCount++;
					Asyn.loops[Asyn._loopsIndex].push(new Deferred());
					}else {
					var d=Asyn.loops[Asyn._loopsIndex][Asyn._loopsCount];
					d._reset();
					Asyn._loopsCount++;
				}
				return;
			}
			Asyn.onceTimer(delay,new Deferred());
		}

		Asyn._loop_=function(){
			Deferred._TIMECOUNT_++;
			Asyn._loopCount++;
			var sz=0;
			if ((sz=Asyn._loopsCount)> 0){
				var _loops=Asyn.loops[Asyn._loopsIndex];
				Asyn._loopsCount=0;
				Asyn._loopsIndex=(Asyn._loopsIndex+1)% 2;
				for (var i=0;i < sz;i++)
				_loops[i].callback();
			}
			if ((sz=Asyn._callLater.length)> 0){
				var accept=Asyn._callLater;
				Asyn._callLater=[];
				for (i=0,sz=accept.length;i < sz;i++){
					var d=accept[i];
					d.callback();
				}
			}
		}

		Asyn._Deferreds={};
		Asyn.loops=[[],[]];
		Asyn._loopsIndex=0;
		Asyn._loopCount=0;
		Asyn._loopsCount=0;
		Asyn._callLater=[];
		Asyn._waitFunctionId=0;
		Asyn.loadDo=null
		Asyn.onceEvent=null
		Asyn.onceTimer=null
		Asyn._caller_=null
		Asyn._callback_=null
		Asyn._nextLine_=0;
		return Asyn;
	})()


	/**
	*<code>Deferred</code> 用于延迟处理函数。
	*/
	//class laya.asyn.Deferred
	var Deferred=(function(){
		function Deferred(){
			this._caller=null;
			this._callback=null;
			this._nextLine=0;
			this._value=null;
			this._createTime=0;
			this._reset();
		}

		__class(Deferred,'laya.asyn.Deferred');
		var __proto=Deferred.prototype;
		/**
		*设置回调参数。
		*@param v 回调参数。
		*/
		__proto.setValue=function(v){
			this._value=v;
		}

		/**
		*获取回调参数。
		*@return 回调参数。
		*/
		__proto.getValue=function(){
			return this._value;
		}

		/**
		*@private
		*/
		__proto._reset=function(){
			this._caller=Asyn._caller_;
			this._callback=Asyn._callback_;
			this._nextLine=Asyn._nextLine_;
			this._createTime=Deferred._TIMECOUNT_;
		}

		/**
		*回调此对象存储的函数并传递参数 value。
		*@param value 回调数据。
		*/
		__proto.callback=function(value){
			(arguments.length > 0)&& (this._value=value);
			if (this._createTime==Deferred._TIMECOUNT_)
				Asyn.callLater(this);
			else this._callback && this._callback.call(this._caller,this._nextLine);
		}

		/**
		*失败回调。
		*@param value 回调数据。
		*/
		__proto.errback=function(value){
			(arguments.length > 0)&& (this._value=value);
			this._callback && this._callback.call(this._caller,this._nextLine);
		}

		Deferred._TIMECOUNT_=0;
		return Deferred;
	})()


	/**
	*<code>BitmapFont</code> 是位图字体类，用于定义位图字体信息。
	*/
	//class laya.display.BitmapFont
	var BitmapFont=(function(){
		function BitmapFont(){
			this.fontSize=12;
			this.autoScaleSize=false;
			this._texture=null;
			this._fontCharDic={};
			this._complete=null;
			this._path=null;
			this._maxHeight=0;
			this._maxWidth=0;
			this._spaceWidth=10;
			this._leftPadding=0;
			this._rightPadding=0;
		}

		__class(BitmapFont,'laya.display.BitmapFont');
		var __proto=BitmapFont.prototype;
		/**
		*通过指定位图字体文件路径，加载位图字体文件。
		*@param path 位图字体文件的路径。
		*@param complete 加载完成的回调，通知上层字体文件已经完成加载并解析。
		*/
		__proto.loadFont=function(path,complete){
			this._path=path;
			this._complete=complete;
			Laya.loader.load([{url:this._path,type:"xml"},{url:this._path.replace(".fnt",".png"),type:"image"}],Handler.create(this,this.onLoaded));
		}

		__proto.onLoaded=function(){
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
			this.fontSize=Laya.__parseInt(tInfo[0].attributes["size"].nodeValue);
			var tPadding=tInfo[0].attributes["padding"].nodeValue;
			var tPaddingArray=tPadding.split(",");
			var tUpPadding=Laya.__parseInt(tPaddingArray[0]);
			var tDownPadding=Laya.__parseInt(tPaddingArray[2]);
			this._leftPadding=Laya.__parseInt(tPaddingArray[3]);
			this._rightPadding=Laya.__parseInt(tPaddingArray[1]);
			var chars=xml.getElementsByTagName("char");
			var i=0;
			for (i=0;i < chars.length;i++){
				var tAttribute=chars[i].attributes;
				var tId=Laya.__parseInt(tAttribute["id"].nodeValue);
				var xOffset=Laya.__parseInt(tAttribute["xoffset"].nodeValue)/ tScale;
				var yOffset=Laya.__parseInt(tAttribute["yoffset"].nodeValue)/ tScale;
				var xAdvance=Laya.__parseInt(tAttribute["xadvance"].nodeValue)/ tScale;
				var region=new Rectangle();
				region.x=Laya.__parseInt(tAttribute["x"].nodeValue);
				region.y=Laya.__parseInt(tAttribute["y"].nodeValue);
				region.width=Laya.__parseInt(tAttribute["width"].nodeValue);
				region.height=Laya.__parseInt(tAttribute["height"].nodeValue);
				var tTexture=Texture.create(texture,region.x,region.y,region.width,region.height,xOffset,yOffset);
				this._maxHeight=Math.max(this._maxHeight,tUpPadding+tDownPadding+tTexture.height);
				this._maxWidth=Math.max(this._maxWidth,tTexture.width);
				this._fontCharDic[tId]=tTexture;
			}
			if (this.getCharTexture(" "))this.setSpaceWidth(this.getCharWidth(" "));
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
		__proto.destory=function(){
			var tTexture=null;
			for (var p in this._fontCharDic){
				tTexture=this._fontCharDic[p];
				if (tTexture)tTexture.destroy();
				delete this._fontCharDic[p];
			}
			this._texture.destroy();
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
			if (char==" ")return this._spaceWidth;
			var tTexture=this.getCharTexture(char)
			if (tTexture)return tTexture.width+tTexture.offsetX *2;
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
				tWidth+=this.getCharWidth(text[i]);
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
			return this._maxHeight;
		}

		/**
		*@private
		*将指定的文本绘制到指定的显示对象上。
		*/
		__proto.drawText=function(text,sprite,drawX,drawY,align,width){
			var tWidth=0;
			var tTexture;
			for (var i=0,n=text.length;i < n;i++){
				tWidth+=this.getCharWidth(text[i]);
			};
			var dx=this._leftPadding;
			align==="center" && (dx=(width-tWidth)/ 2);
			align==="right" && (dx=(width-tWidth)-this._rightPadding);
			var tX=0;
			for (i=0,n=text.length;i < n;i++){
				tTexture=this.getCharTexture(text[i]);
				if (tTexture)sprite.graphics.drawTexture(tTexture,drawX+tX+dx,drawY,tTexture.width,tTexture.height);
				tX+=this.getCharWidth(text[i]);
			}
		}

		return BitmapFont;
	})()


	/**
	*<code>Style</code> 类是元素样式定义类。
	*/
	//class laya.display.css.Style
	var Style=(function(){
		function Style(){
			this.alpha=1;
			this.visible=true;
			this.scrollRect=null;
			this.blendMode=null;
			this._type=0;
			this._tf=Style._TF_EMPTY;
		}

		__class(Style,'laya.display.css.Style');
		var __proto=Style.prototype;
		/**销毁此对象。*/
		__proto.destroy=function(){
			this.scrollRect=null;
		}

		/**@private */
		__proto.render=function(sprite,context,x,y){}
		/**@private */
		__proto.getCSSStyle=function(){
			return CSSStyle.EMPTY;
		}

		/**@private */
		__proto._enableLayout=function(){
			return false;
		}

		/**表示元素是否显示为块级元素。*/
		__getset(0,__proto,'block',function(){
			return (this._type & 0x1)!=0;
		});

		/**表示元素的上内边距。*/
		__getset(0,__proto,'paddingTop',function(){
			return 0;
		});

		/**X 轴缩放值。*/
		__getset(0,__proto,'scaleX',function(){
			return this._tf.scaleX;
			},function(value){
			this._tf===Style._TF_EMPTY && (this._tf=Style._createTransform());
			this._tf.scaleX=value;
		});

		/**Y 轴缩放值。*/
		__getset(0,__proto,'scaleY',function(){
			return this._tf.scaleY;
			},function(value){
			this._tf===Style._TF_EMPTY && (this._tf=Style._createTransform());
			this._tf.scaleY=value;
		});

		/**元素应用的 2D 或 3D 转换的值。该属性允许我们对元素进行旋转、缩放、移动或倾斜。*/
		__getset(0,__proto,'transform',function(){
			return this._tf;
			},function(value){
			this._tf=value==='none' || !value ? Style._TF_EMPTY :value;
		});

		/**定义转换，只是用 X 轴的值。*/
		__getset(0,__proto,'translateX',function(){
			return this._tf.translateX;
			},function(value){
			this._tf===Style._TF_EMPTY && (this._tf=Style._createTransform());
			this._tf.translateX=value;
		});

		/**定义转换，只是用 Y 轴的值。*/
		__getset(0,__proto,'translateY',function(){
			return this._tf.translateY;
			},function(value){
			this._tf===Style._TF_EMPTY && (this._tf=Style._createTransform());
			this._tf.translateY=value;
		});

		/**定义旋转角度。*/
		__getset(0,__proto,'rotate',function(){
			return this._tf.rotate;
			},function(value){
			this._tf===Style._TF_EMPTY && (this._tf=Style._createTransform());
			this._tf.rotate=value;
		});

		/**定义沿着 X 轴的 2D 倾斜转换。*/
		__getset(0,__proto,'skewX',function(){
			return this._tf.skewX;
			},function(value){
			this._tf===Style._TF_EMPTY && (this._tf=Style._createTransform());
			this._tf.skewX=value;
		});

		/**定义沿着 Y 轴的 2D 倾斜转换。*/
		__getset(0,__proto,'skewY',function(){
			return this._tf.skewY;
			},function(value){
			this._tf===Style._TF_EMPTY && (this._tf=Style._createTransform());
			this._tf.skewY=value;
		});

		/**是否为绝对定位。*/
		__getset(0,__proto,'absolute',function(){
			return true;
		});

		/**表示元素的左内边距。*/
		__getset(0,__proto,'paddingLeft',function(){
			return 0;
		});

		Style.__init__=function(){
			Style._TF_EMPTY=Style._createTransform();
			Style.EMPTY=new Style();
		}

		Style._createTransform=function(){
			return {translateX:0,translateY:0,scaleX:1,scaleY:1,rotate:0,skewX:0,skewY:0};
		}

		Style.EMPTY=null
		Style._TF_EMPTY=null
		return Style;
	})()


	/**
	*<code>Font</code> 类是字体显示定义类。
	*/
	//class laya.display.css.Font
	var Font=(function(){
		function Font(src){
			this._type=0;
			this._weight=0;
			this._decoration=null;
			this._text=null;
			this.indent=0;
			this._color=Color.create(Font.defaultColor);
			this.family=Font.defaultFamily;
			this.stroke=Font._STROKE;
			this.size=Font.defaultSize;
			src && src!==Font.EMPTY && src.copyTo(this);
		}

		__class(Font,'laya.display.css.Font');
		var __proto=Font.prototype;
		/**
		*字体样式字符串。
		*/
		__proto.set=function(value){
			this._text=null;
			var strs=value.split(' ');
			for (var i=0,n=strs.length;i < n;i++){
				var str=strs[i];
				switch (str){
					case 'italic':
						this.italic=true;
						continue ;
					case 'bold':
						this.bold=true;
						continue ;
					}
				if (str.indexOf('px')> 0){
					this.size=Laya.__parseInt(str);
					this.family=strs[i+1];
					i++;
					continue ;
				}
			}
		}

		/**
		*返回字体样式字符串。
		*@return 字体样式字符串。
		*/
		__proto.toString=function(){
			this._text=""
			this.italic && (this._text+="italic ");
			this.bold && (this._text+="bold ");
			return this._text+=this.size+"px "+this.family;
		}

		/**
		*将当前的属性值复制到传入的 <code>Font</code> 对象。
		*@param dec 一个 Font 对象。
		*/
		__proto.copyTo=function(dec){
			dec._type=this._type;
			dec._text=this._text;
			dec._weight=this._weight;
			dec._color=this._color;
			dec.family=this.family;
			dec.stroke=this.stroke !=Font._STROKE ? this.stroke.slice():Font._STROKE;
			dec.indent=this.indent;
			dec.size=this.size;
		}

		/**
		*表示颜色字符串。
		*/
		__getset(0,__proto,'color',function(){
			return this._color.strColor;
			},function(value){
			this._color=Color.create(value);
		});

		/**
		*规定添加到文本的修饰。
		*/
		__getset(0,__proto,'decoration',function(){
			return this._decoration ? this._decoration.value :"none";
			},function(value){
			var strs=value.split(' ');
			this._decoration || (this._decoration={});
			switch (strs[0]){
				case '_':
					this._decoration.type='underline'
					break ;
				case '-':
					this._decoration.type='line-through'
					break ;
				case 'overline':
					this._decoration.type='overline'
					break ;
				default :
					this._decoration.type=strs[0];
				}
			strs[1] && (this._decoration.color=Color.create(strs));
			this._decoration.value=value;
		});

		/**
		*表示是否为斜体。
		*/
		__getset(0,__proto,'italic',function(){
			return (this._type & 0x200)!==0;
			},function(value){
			value ? (this._type |=0x200):(this._type &=~0x200);
		});

		/**
		*表示是否为粗体。
		*/
		__getset(0,__proto,'bold',function(){
			return (this._type & 0x800)!==0;
			},function(value){
			value ? (this._type |=0x800):(this._type &=~0x800);
		});

		/**
		*表示是否为密码格式。
		*/
		__getset(0,__proto,'password',function(){
			return (this._type & 0x400)!==0;
			},function(value){
			value ? (this._type |=0x400):(this._type &=~0x400);
		});

		/**
		*文本的粗细。
		*/
		__getset(0,__proto,'weight',function(){
			return ""+this._weight;
			},function(value){
			var weight=0;
			switch (value){
				case 'normal':
					break ;
				case 'bold':
					this.bold=true;
					weight=700;
					break ;
				case 'bolder':
					weight=800;
					break ;
				case 'lighter':
					weight=100;
					break ;
				default :
					weight=Laya.__parseInt(value);
				}
			this._weight=weight;
			this._text=null;
		});

		Font.__init__=function(){
			Font.EMPTY=new Font(null);
		}

		Font.EMPTY=null
		Font.defaultColor="#000000";
		Font.defaultSize=12;
		Font.defaultFamily="Arial";
		Font.defaultFont="12px Arial";
		Font._STROKE=[0,"#000000"];
		Font._ITALIC=0x200;
		Font._PASSWORD=0x400;
		Font._BOLD=0x800;
		return Font;
	})()


	/**
	*<code>Graphics</code> 类用于创建绘图显示对象。
	*@see laya.display.Sprite#graphics
	*/
	//class laya.display.Graphics
	var Graphics=(function(){
		function Graphics(){
			//this._sp=null;
			this._one=null;
			this._cmds=null;
			//this._temp=null;
			//this._bounds=null;
			//this._rstBoundPoints=null;
			this._render=this._renderEmpty;
			this._render=this._renderEmpty;
		}

		__class(Graphics,'laya.display.Graphics');
		var __proto=Graphics.prototype;
		/**
		*<p>销毁此对象。</p>
		*/
		__proto.destroy=function(){
			this.clear();
			this._temp=null;
			this._bounds=null;
			this._rstBoundPoints=null;
			this._sp && (this._sp._renderType=0);
			this._sp=null;
		}

		/**
		*<p>清理此对象。</p>
		*/
		__proto.clear=function(){
			this._one=null;
			this._render=this._renderEmpty;
			this._cmds=null;
			this._temp && (this._temp.length=0);
			this._sp && (this._sp._renderType &=~0x01);
			this._sp && (this._sp._renderType &=~0x100);
			this._repaint();
		}

		/**
		*返回命令是否为空。
		*/
		__proto.empty=function(){
			return this._one===null && (!this._cmds || this._cmds.length===0);
		}

		/**
		*@private
		*重绘此对象。
		*/
		__proto._repaint=function(){
			this._temp && (this._temp.length=0);
			this._sp && this._sp.repaint();
		}

		/**@private */
		__proto._isOnlyOne=function(){
			return !this._cmds || this._cmds.length===0;
		}

		/**
		*获取位置及宽高信息矩阵(比较耗，尽量少用)。
		*@return 位置与宽高组成的 一个 Rectangle 对象。
		*/
		__proto.getBounds=function(){
			if (!this._bounds || !this._temp || this._temp.length < 1){
				this._bounds=Rectangle._getWrapRec(this.getBoundPoints(),this._bounds)
			}
			return this._bounds;
		}

		/**
		*@private
		*获取端点列表。
		*/
		__proto.getBoundPoints=function(){
			if (!this._temp || this._temp.length < 1)
				this._temp=this._getCmdPoints();
			return this._rstBoundPoints=Utils.setValueArr(this._rstBoundPoints,this._temp);
		}

		__proto._getCmdPoints=function(){
			var context=Render.context;
			var cmds=this._cmds;
			var rst;
			rst=this._temp || (this._temp=[]);
			rst.length=0;
			if (!cmds && this._one !=null){
				cmds=[this._one];
			}
			if (!cmds)
				return [];
			var matrixs;
			matrixs=[];
			var tMatrix=new Matrix();
			var tempMatrix=Graphics._tempMatrix;
			var cmd;
			for (var i=0,n=cmds.length;i < n;i++){
				cmd=cmds[i];
				switch (cmd.callee){
					case context.save:
						matrixs.push(tMatrix);
						tMatrix=tMatrix.clone();
						break ;
					case context.restore:
						tMatrix=matrixs.pop();
						break ;
					case context._scale:
						tempMatrix.identity();
						tempMatrix.translate(-cmd[2],-cmd[3]);
						tempMatrix.scale(cmd[0],cmd[1]);
						tempMatrix.translate(cmd[2],cmd[3]);
						this._switchMatrix(tMatrix,tempMatrix);
						break ;
					case context._rotate:
						tempMatrix.identity();
						tempMatrix.translate(-cmd[1],-cmd[2]);
						tempMatrix.rotate(cmd[0]);
						tempMatrix.translate(cmd[1],cmd[2]);
						this._switchMatrix(tMatrix,tempMatrix);
						break ;
					case context._translate:
						tempMatrix.identity();
						tempMatrix.translate(cmd[0],cmd[1]);
						this._switchMatrix(tMatrix,tempMatrix);
						break ;
					case context._transform:
						tempMatrix.identity();
						tempMatrix.translate(-cmd[1],-cmd[2]);
						tempMatrix.concat(cmd[0]);
						tempMatrix.translate(cmd[1],cmd[2]);
						this._switchMatrix(tMatrix,tempMatrix);
						break ;
					case context._drawTexture:
						if (cmd[3] && cmd[4]){
							Graphics._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd[1],cmd[2],cmd[3],cmd[4]),tMatrix);
							}else {
							var tex=cmd[0];
							Graphics._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd[1],cmd[2],tex.width,tex.height),tMatrix);
						}
						break ;
					case context._drawRect:
					case context._fillRect:
						Graphics._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd[0],cmd[1],cmd[2],cmd[3]),tMatrix);
						break ;
					case context._drawCircle:
					case context._fillCircle:
						Graphics._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd[0]-cmd[2],cmd[1]-cmd[2],cmd[2]+cmd[2],cmd[2]+cmd[2]),tMatrix);
						break ;
					case context._drawLine:
						Graphics._addPointArrToRst(rst,[cmd[0],cmd[1],cmd[2],cmd[3]],tMatrix);
						break ;
					case context.drawCurves:
						Graphics._addPointArrToRst(rst,Bezier.I.getBezierPoints(cmd[2]),tMatrix,cmd[0],cmd[1]);
						break ;
					case context._drawPoly:
						Graphics._addPointArrToRst(rst,cmd[2],tMatrix,cmd[0],cmd[1]);
						break ;
					case context._drawPath:
						Graphics._addPointArrToRst(rst,this._getPathPoints(cmd[2]),tMatrix,cmd[0],cmd[1]);
						break ;
					case context._drawPie:
					case context._drawPieWebGL:
						Graphics._addPointArrToRst(rst,this._getPiePoints(cmd[0],cmd[1],cmd[2],cmd[3],cmd[4]),tMatrix);
						break ;
					}
			}
			if (rst.length > 200){
				rst=Utils.setValueArr(rst,Rectangle._getWrapRec(rst)._getBoundPoints());
			}else if (rst.length > 8)
			rst=GrahamScan.scanPList(rst);
			return rst;
		}

		__proto._switchMatrix=function(tMatix,tempMatrix){
			tempMatrix.concat(tMatix);
			tempMatrix.copy(tMatix);
		}

		/**
		*绘制纹理。
		*@param tex 纹理。
		*@param x X 轴偏移量。
		*@param y Y 轴偏移量。
		*@param width 宽度。
		*@param height 高度。
		*@param m 矩阵信息。
		*/
		__proto.drawTexture=function(tex,x,y,width,height,m){
			(width===void 0)&& (width=0);
			(height===void 0)&& (height=0);
			this._sp && (this._sp._renderType |=0x100);
			if (!width)width=tex.width;
			if (!height)height=tex.height;
			var args=[tex,x,y,width,height,m];
			if (this._one==null){
				this._one=args;
				this._render=this._renderOneImg;
				}else {
				this._render=this._renderAll;
				(this._cmds || (this._cmds=[])).length===0 && this._cmds.push(this._one);
				this._cmds.push(args);
			}
			args.callee=m ? Render.context._drawTextureWithTransform :Render.context._drawTexture;
			this._repaint();
		}

		__proto._textureLoaded=function(tex,param){
			tex.off("loaded",this,this._textureLoaded);
			param[3]=tex.width;
			param[4]=tex.height;
			this._repaint();
		}

		/**
		*绘制渲染对象。
		*@param tex 纹理。
		*@param x X 轴偏移量。
		*@param y Y 轴偏移量。
		*@param width 宽度。
		*@param height 高度。
		*/
		__proto.drawRenderTarget=function(tex,x,y,width,height){
			var mat=new Matrix(1,0,0,-1,0,height);
			this.drawTexture(tex,x,y,width,height,mat);
		}

		/**
		*@private
		*保存到命令流。
		*/
		__proto._saveToCmd=function(fun,args){
			this._sp && (this._sp._renderType |=0x100);
			if (this._one==null){
				this._one=args;
				this._render=this._renderOne;
				}else {
				this._sp && (this._sp._renderType &=~0x01);
				this._render=this._renderAll;
				(this._cmds || (this._cmds=[])).length===0 && this._cmds.push(this._one);
				this._cmds.push(args);
			}
			args.callee=fun;
			this._temp && (this._temp.length=0);
			this._repaint();
			return args;
		}

		/**
		*画布的剪裁区域，超出剪裁区域的坐标可以画图，但不能显示。
		*@param x X 轴偏移量。
		*@param y Y 轴偏移量。
		*@param width 宽度。
		*@param height 高度。
		*/
		__proto.clipRect=function(x,y,width,height){
			this._saveToCmd(Render.context._clipRect,arguments);
		}

		/**
		*在画布上绘制“被填充的”文本。
		*@param text 在画布上输出的文本。
		*@param x 开始绘制文本的 x 坐标位置（相对于画布）。
		*@param y 开始绘制文本的 y 坐标位置（相对于画布）。
		*@param font 定义字体和字号。
		*@param color 定义文本颜色。
		*@param textAlign 文本对齐方式。
		*/
		__proto.fillText=function(text,x,y,font,color,textAlign){
			this._saveToCmd(Render.context._fillText,[text,x,y,font || Font.defaultFont,color,textAlign]);
		}

		/**
		*在画布上绘制“被填充且镶边的”文本。
		*@param text 在画布上输出的文本。
		*@param x 开始绘制文本的 x 坐标位置（相对于画布）。
		*@param y 开始绘制文本的 y 坐标位置（相对于画布）。
		*@param font 定义字体和字号。
		*@param fillColor 定义文本颜色。
		*@param borderColor 定义镶边文本颜色。
		*@param lineWidth 镶边线条宽度。
		*@param textAlign 文本对齐方式。
		*/
		__proto.fillBorderText=function(text,x,y,font,fillColor,borderColor,lineWidth,textAlign){
			this._saveToCmd(Render.context._fillBorderText,[text,x,y,font || Font.defaultFont,fillColor,borderColor,lineWidth,textAlign]);
		}

		/**
		*在画布上绘制文本（没有填色）。文本的默认颜色是黑色。
		*@param text 在画布上输出的文本。
		*@param x 开始绘制文本的 x 坐标位置（相对于画布）。
		*@param y 开始绘制文本的 y 坐标位置（相对于画布）。
		*@param font 定义字体和字号。
		*@param color 定义文本颜色。
		*@param lineWidth 线条宽度。
		*@param textAlign 文本对齐方式。
		*/
		__proto.strokeText=function(text,x,y,font,color,lineWidth,textAlign){
			this._saveToCmd(Render.context._strokeText,[text,x,y,font || Font.defaultFont,color,lineWidth,textAlign]);
		}

		/**
		*设置透明度。
		*@param value 透明度。
		*/
		__proto.alpha=function(value){
			this._saveToCmd(Render.context._alpha,arguments);
		}

		/**
		*设置混合模式。
		*@param value 混合模式。
		*/
		__proto.blendMode=function(value){
			this._saveToCmd(Render.context._blendMode,arguments);
		}

		/**
		*替换绘图的当前转换矩阵。
		*@param mat 矩阵。
		*@param pivotX 水平方向轴心点坐标。
		*@param pivotY 垂直方向轴心点坐标。
		*/
		__proto.transform=function(mat,pivotX,pivotY){
			(pivotX===void 0)&& (pivotX=0);
			(pivotY===void 0)&& (pivotY=0);
			this._saveToCmd(Render.context._transform,[mat,pivotX,pivotY]);
		}

		/**
		*旋转当前绘图。
		*@param angle 旋转角度，以弧度计。
		*@param pivotX 水平方向轴心点坐标。
		*@param pivotY 垂直方向轴心点坐标。
		*/
		__proto.rotate=function(angle,pivotX,pivotY){
			(pivotX===void 0)&& (pivotX=0);
			(pivotY===void 0)&& (pivotY=0);
			this._saveToCmd(Render.context._rotate,[angle,pivotX,pivotY]);
		}

		/**
		*缩放当前绘图至更大或更小。
		*@param scaleX 水平方向缩放值。
		*@param scaleY 垂直方向缩放值。
		*@param pivotX 水平方向轴心点坐标。
		*@param pivotY 垂直方向轴心点坐标。
		*/
		__proto.scale=function(scaleX,scaleY,pivotX,pivotY){
			(pivotX===void 0)&& (pivotX=0);
			(pivotY===void 0)&& (pivotY=0);
			this._saveToCmd(Render.context._scale,[scaleX,scaleY,pivotX,pivotY]);
		}

		/**
		*重新映射画布上的 (0,0)位置。
		*@param x 添加到水平坐标（x）上的值。
		*@param y 添加到垂直坐标（y）上的值。
		*/
		__proto.translate=function(x,y){
			this._saveToCmd(Render.context._translate,[x,y]);
		}

		/**
		*保存当前环境的状态。
		*/
		__proto.save=function(){
			this._saveToCmd(Render.context.save,arguments);
		}

		/**
		*返回之前保存过的路径状态和属性。
		*/
		__proto.restore=function(){
			this._saveToCmd(Render.context.restore,arguments);
		}

		/**
		*替换文本内容。
		*@param text 文本内容。
		*@return 替换成功则值为true，否则值为flase。
		*/
		__proto.replaceText=function(text){
			this._repaint();
			var cmds=this._cmds;
			if (!cmds){
				return this._one && this._one.callee===Render.context._fillText && (this._one[0]=text,true);
			}
			for (var i=cmds.length-1;i >-1;i--){
				if (cmds[i].callee===Render.context._fillText){
					cmds[i][0]=text;
					return true;
				}
			}
			return false;
		}

		/**
		*替换文本颜色。
		*@param color 颜色。
		*@return 替换成功则值为true，否则值为flase。
		*/
		__proto.replaceTextColor=function(color){
			this._repaint();
			var cmds=this._cmds;
			if (!cmds){
				return this._one && (this._one.callee===Render.context._fillBorderText || this._one.callee===Render.context._fillText)&& (this._one[4]=color,true);
			}
			for (var i=cmds.length-1;i >-1;i--){
				if (cmds[i].callee===Render.context._fillText){
					cmds[i][4]=color;
					return true;
				}
			}
			return false;
		}

		/**
		*加载并显示一个图片。
		*@param url 图片地址。
		*@param x 显示图片的x位置。
		*@param y 显示图片的y位置。
		*@param width 显示图片的宽度，设置为0表示使用图片默认宽度。
		*@param height 显示图片的高度，设置为0表示使用图片默认高度。
		*@param complete 加载完成回调。
		*/
		__proto.loadImage=function(url,x,y,width,height,complete){
			var _$this=this;
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			(width===void 0)&& (width=0);
			(height===void 0)&& (height=0);
			var tex=Loader.getRes(url);
			if (tex)onloaded(tex);
			else Laya.loader.load(url,Handler.create(null,onloaded),null,"image");
			function onloaded (tex){
				if (tex){
					_$this.drawTexture(tex,x,y,width,height);
					if (complete !=null)complete.call(_$this._sp,tex);
				}
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
				(cmd=cmds[i]).callee.call(context,x,y,cmd);
			}
		}

		/**
		*@private
		*/
		__proto._renderOne=function(sprite,context,x,y){
			this._one.callee.call(context,x,y,this._one);
		}

		/**
		*@private
		*/
		__proto._renderOneImg=function(sprite,context,x,y){
			this._one.callee.call(context,x,y,this._one);
			if (sprite._renderType!==2305){
				sprite._renderType |=0x01;
			}
		}

		/**
		*绘制一条线。
		*@param fromX X 轴开始位置。
		*@param fromY Y 轴开始位置。
		*@param toX X 轴结束位置。
		*@param toY Y 轴结束位置。
		*@param lineColor 颜色。
		*@param lineWidth 线条宽度。
		*/
		__proto.drawLine=function(fromX,fromY,toX,toY,lineColor,lineWidth){
			(lineWidth===void 0)&& (lineWidth=1);
			var arr=[fromX+0.5,fromY+0.5,toX+0.5,toY+0.5,lineColor,lineWidth];
			this._saveToCmd(Render.context._drawLine,arr);
		}

		/**
		*绘制一系列线段。
		*@param x 开始绘制的 X 轴位置。
		*@param y 开始绘制的 Y 轴位置。
		*@param points 线段的点集合。格式:[x1,y1,x2,y2,x3,y3...]。
		*@param lineColor 线段颜色，或者填充绘图的渐变对象。
		*@param lineWidth 线段宽度。
		*/
		__proto.drawLines=function(x,y,points,lineColor,lineWidth){
			(lineWidth===void 0)&& (lineWidth=1);
			var arr=[x+0.5,y+0.5,points,lineColor,lineWidth];
			if (Render.isWebGl)
				arr[3]=Color.create(lineColor).numColor;
			this._saveToCmd(Render.isWebGl ? Render.context.drawLinesWebGL :Render.context.drawLines,arr);
		}

		/**
		*绘制一系列曲线。
		*@param x 开始绘制的 X 轴位置。
		*@param y 开始绘制的 Y 轴位置。
		*@param points 线段的点集合，格式[startx,starty,ctrx,ctry,startx,starty...]。
		*@param lineColor 线段颜色，或者填充绘图的渐变对象。
		*@param lineWidth 线段宽度。
		*/
		__proto.drawCurves=function(x,y,points,lineColor,lineWidth){
			(lineWidth===void 0)&& (lineWidth=1);
			var arr=[x+0.5,y+0.5,points,lineColor,lineWidth];
			if (Render.isWebGl)
				arr[3]=Color.create(lineColor).numColor;
			this._saveToCmd(Render.isWebGl ? Render.context.drawCurvesGL :Render.context.drawCurves,arr);
		}

		/**
		*绘制矩形。
		*@param x 开始绘制的 X 轴位置。
		*@param y 开始绘制的 Y 轴位置。
		*@param width 矩形宽度。
		*@param height 矩形高度。
		*@param fillColor 填充颜色，或者填充绘图的渐变对象。
		*@param lineColor 边框颜色，或者填充绘图的渐变对象。
		*@param lineWidth 边框宽度。
		*/
		__proto.drawRect=function(x,y,width,height,fillColor,lineColor,lineWidth){
			(lineWidth===void 0)&& (lineWidth=1);
			var offset=lineColor ? 0.5 :0;
			var arr=[x+offset,y+offset,width,height,fillColor,lineColor,lineWidth];
			this._saveToCmd(Render.context._drawRect,arr);
		}

		/**
		*绘制圆形。
		*@param x 圆点X 轴位置。
		*@param y 圆点Y 轴位置。
		*@param radius 半径。
		*@param fillColor 填充颜色，或者填充绘图的渐变对象。
		*@param lineColor 边框颜色，或者填充绘图的渐变对象。
		*@param lineWidth 边框宽度。
		*/
		__proto.drawCircle=function(x,y,radius,fillColor,lineColor,lineWidth){
			(lineWidth===void 0)&& (lineWidth=1);
			var offset=lineColor ? 0.5 :0;
			var arr=[x+offset,y+offset,radius,fillColor,lineColor,lineWidth];
			if (Render.isWebGl){
				arr[3]=fillColor ? Color.create(fillColor).numColor :fillColor;
				arr[4]=lineColor ? Color.create(lineColor).numColor :lineColor;
			}
			this._saveToCmd(Render.isWebGl ? Render.context._drawCircleWebGL :Render.context._drawCircle,arr);
		}

		/**
		*绘制扇形。
		*@param x 开始绘制的 X 轴位置。
		*@param y 开始绘制的 Y 轴位置。
		*@param radius 扇形半径。
		*@param startAngle 开始角度。
		*@param endAngle 结束角度。
		*@param fillColor 填充颜色，或者填充绘图的渐变对象。
		*@param lineColor 边框颜色，或者填充绘图的渐变对象。
		*@param lineWidth 边框宽度。
		*/
		__proto.drawPie=function(x,y,radius,startAngle,endAngle,fillColor,lineColor,lineWidth){
			(lineWidth===void 0)&& (lineWidth=1);
			var offset=lineColor ? 0.5 :0;
			var arr=[x+offset,y+offset,radius,startAngle,endAngle,fillColor,lineColor,lineWidth];
			if (Render.isWebGl){
				startAngle=90-startAngle;
				endAngle=90-endAngle;
				arr[5]=fillColor ? Color.create(fillColor).numColor :fillColor;
				arr[6]=lineColor ? Color.create(lineColor).numColor :lineColor;
			}
			arr[3]=Utils.toRadian(startAngle);
			arr[4]=Utils.toRadian(endAngle);
			this._saveToCmd(Render.isWebGl ? Render.context._drawPieWebGL :Render.context._drawPie,arr);
		}

		__proto._getPiePoints=function(x,y,radius,startAngle,endAngle){
			var rst;
			rst=[x,y];
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

		/**
		*绘制多边形。
		*@param x 开始绘制的 X 轴位置。
		*@param y 开始绘制的 Y 轴位置。
		*@param points 多边形的点集合。
		*@param fillColor 填充颜色，或者填充绘图的渐变对象。
		*@param lineColor 边框颜色，或者填充绘图的渐变对象。
		*@param lineWidth 边框宽度。
		*/
		__proto.drawPoly=function(x,y,points,fillColor,lineColor,lineWidth){
			(lineWidth===void 0)&& (lineWidth=1);
			var offset=lineColor ? 0.5 :0;
			var arr=[x+offset,y+offset,points,fillColor,lineColor,lineWidth];
			if (Render.isWebGl){
				if (fillColor !=null){
					arr[3]=Color.create(fillColor).numColor;
				}
				if (lineColor !=null){
					arr[4]=Color.create(lineColor).numColor;
				}
			}
			this._saveToCmd(Render.isWebGl ? Render.context._drawPolyGL :Render.context._drawPoly,arr);
		}

		__proto._getPathPoints=function(paths){
			var i=0,len=0;
			var rst=[];
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

		/**
		*绘制路径。
		*@param x 开始绘制的 X 轴位置。
		*@param y 开始绘制的 Y 轴位置。
		*@param paths 路径集合，路径支持以下格式：[["moveTo",x,y],["lineTo",x,y],["arcTo",x1,y1,x2,y2,r],["closePath"]]。
		*@param brush 刷子定义，支持以下设置{fillStyle}。
		*@param pen 画笔定义，支持以下设置{strokeStyle,lineWidth,lineJoin,lineCap,miterLimit}。
		*/
		__proto.drawPath=function(x,y,paths,brush,pen){
			var arr=[x+0.5,y+0.5,paths,brush,pen];
			this._saveToCmd(Render.context._drawPath,arr);
		}

		/**@private */
		/**
		*@private
		*命令流。
		*/
		__getset(0,__proto,'cmds',function(){
			return this._cmds;
			},function(value){
			this._sp && (this._sp._renderType |=0x100);
			this._cmds=value;
			this._render=this._renderAll;
			this._repaint();
		});

		Graphics._addPointArrToRst=function(rst,points,matrix,dx,dy){
			(dx===void 0)&& (dx=0);
			(dy===void 0)&& (dy=0);
			var i=0,len=0;
			len=points.length;
			for (i=0;i < len;i+=2){
				Graphics._addPointToRst(rst,points[i]+dx,points[i+1]+dy,matrix);
			}
		}

		Graphics._addPointToRst=function(rst,x,y,matrix){
			var _tempPoint=Point.TEMP;
			x=x ? x :0;
			y=y ? y :0;
			_tempPoint.setTo(x,y);
			matrix.transformPoint(x,y,_tempPoint);
			rst.push(_tempPoint.x,_tempPoint.y);
		}

		__static(Graphics,
		['_tempMatrix',function(){return this._tempMatrix=new Matrix();}
		]);
		return Graphics;
	})()


	/**
	*<code>Event</code> 是事件类型的集合。
	*/
	//class laya.events.Event
	var Event=(function(){
		function Event(){
			//this.type=null;
			//this.nativeEvent=null;
			//this.target=null;
			//this.currentTarget=null;
			//this._stoped=false;
			//this.touchId=0;
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
		*防止对事件流中当前节点的后续节点中的所有事件侦听器进行处理。
		*/
		__proto.stopPropagation=function(){
			this._stoped=true;
		}

		/**
		*表示 Shift 键是处于活动状态 (true)还是非活动状态 (false)。
		*/
		__getset(0,__proto,'shiftKey',function(){
			return this.nativeEvent.shiftKey;
		});

		/**
		*触摸点列表。
		*/
		__getset(0,__proto,'touches',function(){
			var arr=this.nativeEvent.touches;
			if (arr){
				for (var i=0,n=arr.length;i < n;i++){
					var e=arr[i];
					var point=Point.TEMP;
					point.setTo(e.clientX,e.clientY);
					Laya.stage._canvasTransform.invertTransformPoint(point);
					e.stageX=point.x;
					e.stageY=point.y;
				}
			}
			return arr;
		});

		/**
		*表示 Alt 键是处于活动状态 (true)还是非活动状态 (false)。
		*/
		__getset(0,__proto,'altKey',function(){
			return this.nativeEvent.altKey;
		});

		/**
		*表示 Ctrl 键是处于活动状态 (true)还是非活动状态 (false)。
		*/
		__getset(0,__proto,'ctrlKey',function(){
			return this.nativeEvent.ctrlKey;
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
		Event.ENTER_FRAME="enterframe";
		Event.DRAG_START="dragstart";
		Event.DRAG_MOVE="dragmove";
		Event.DRAG_END="dragend";
		Event.ENTER="enter";
		Event.SELECT="select";
		Event.BLUR="blur";
		Event.FOCUS="focus";
		Event.PLAYED="played";
		Event.PAUSED="paused";
		Event.STOPPED="stopped";
		Event.START="start";
		Event.END="end";
		Event.ENABLED_CHANGED="enabledchanged";
		Event.COMPONENT_ADDED="componentadded";
		Event.COMPONENT_REMOVED="componentremoved";
		Event.ACTIVE_CHANGED="activechanged";
		Event.LAYER_CHANGED="layerchanged";
		Event.HIERARCHY_LOADED="hierarchyloaded";
		Event.MEMORY_CHANGED="memorychanged";
		Event.RECOVERING="recovering";
		Event.RECOVERED="recovered";
		Event.RELEASED="released";
		Event.LINK="link";
		Event.LABEL="label";
		return Event;
	})()


	/**
	*<p><code>KeyBoardManager</code> 是键盘事件管理类。</p>
	*<p>该类从浏览器中接收键盘事件，并派发该事件。
	*派发事件时若 Stage.focus 为空则只从 Stage 上派发该事件，否则将从 Stage.focus 对象开始一直冒泡派发该事件。
	*所以在 Laya.stage 上监听键盘事件一定能够收到，如果在其他地方监听，则必须处在Stage.focus的冒泡链上才能收到该事件。</p>
	*<p>用户可以通过代码 Laya.stage.focus=someNode 的方式来设置focus对象。</p>
	*<p>用户可统一的根据事件对象中 e.keyCode 来判断按键类型，该属性兼容了不同浏览器的实现。</p>
	*/
	//class laya.events.KeyBoardManager
	var KeyBoardManager=(function(){
		function KeyBoardManager(){};
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
			e.keyCode=e.keyCode || e.which || e.charCode;
			if (type==="keydown")KeyBoardManager._pressKeys[e.keyCode]=true;
			else if (type==="keyup")KeyBoardManager._pressKeys[e.keyCode]=null;
			var tar=(Laya.stage.focus && (Laya.stage.focus.event !=null))? Laya.stage.focus :Laya.stage;
			while (tar){
				tar.event(type,e);
				tar=tar.parent;
			}
		}

		KeyBoardManager.hasKeyDown=function(key){
			return KeyBoardManager._pressKeys[key];
		}

		KeyBoardManager._pressKeys={};
		return KeyBoardManager;
	})()


	/**
	*<code>MouseManager</code> 是鼠标、触摸交互管理器。
	*/
	//class laya.events.MouseManager
	var MouseManager=(function(){
		function MouseManager(){
			this.mouseX=0;
			this.mouseY=0;
			this.disableMouseEvent=false;
			this.mouseDownTime=0;
			this._stage=null;
			this._target=null;
			this._lastOvers=[];
			this._currOvers=[];
			this._lastClickTimer=0;
			this._lastMoveTimer=0;
			this._isDoubleClick=false;
			this._isLeftMouse=false;
			this._eventList=[];
			this._event=new Event();
			this._matrix=new Matrix();
			this._point=new Point();
			this._rect=new Rectangle();
		}

		__class(MouseManager,'laya.events.MouseManager');
		var __proto=MouseManager.prototype;
		/**
		*@private
		*初始化。
		*/
		__proto.__init__=function(){
			this._stage=Laya.stage;
			var _this=this;
			var canvas=Render.canvas.source;
			var list=this._eventList;
			Browser.document.oncontextmenu=function (e){
				if (MouseManager.enabled)return false;
			}
			canvas.addEventListener('mousedown',function(e){
				if (MouseManager.enabled){
					e.preventDefault();
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
			Browser.document.addEventListener('mousemove',function(e){
				if (MouseManager.enabled){
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
					e.preventDefault();
					list.push(e);
					_this.mouseDownTime=Browser.now();
				}
			});
			canvas.addEventListener("touchend",function(e){
				if (MouseManager.enabled){
					e.preventDefault();
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
			canvas.addEventListener('mousewheel',function(e){
				if (MouseManager.enabled)list.push(e);
			});
			canvas.addEventListener('DOMMouseScroll',function(e){
				if (MouseManager.enabled)list.push(e);
			});
		}

		__proto.initEvent=function(e,nativeEvent){
			var _this=laya.events.MouseManager.instance;
			_this._event._stoped=false;
			_this._event.nativeEvent=nativeEvent || e;
			_this._target=null;
			this._point.setTo(e.clientX,e.clientY);
			this._stage._canvasTransform.invertTransformPoint(this._point);
			e.stageX=_this.mouseX=this._point.x;
			e.stageY=_this.mouseY=this._point.y;
			_this._event.touchId=e.identifier;
		}

		__proto.checkMouseWheel=function(e){
			this._event.delta=e.wheelDelta ? e.wheelDelta *0.025 :-e.detail;
			for (var i=0,n=this._lastOvers.length;i < n;i++){
				var ele=this._lastOvers[i];
				ele.event("mousewheel",this._event.setTo("mousewheel",ele,this._target));
			}
		}

		__proto.checkMouseOut=function(){
			if (this.disableMouseEvent)return;
			for (var i=0,n=this._lastOvers.length;i < n;i++){
				var ele=this._lastOvers[i];
				if (this._currOvers.indexOf(ele)< 0){
					ele.$_MOUSEOVER=false;
					ele.event("mouseout",this._event.setTo("mouseout",ele,this._target));
				}
			};
			var temp=this._lastOvers;
			this._lastOvers=this._currOvers;
			this._currOvers=temp;
			this._currOvers.length=0;
		}

		__proto.onMouseMove=function(ele){
			this.sendMouseMove(ele);
			this._event._stoped=false;
			this.sendMouseOver(this._target);
		}

		__proto.sendMouseMove=function(ele){
			ele.event("mousemove",this._event.setTo("mousemove",ele,this._target));
			!this._event._stoped && ele.parent && this.sendMouseMove(ele.parent);
		}

		__proto.sendMouseOver=function(ele){
			if (ele.parent){
				if (!ele.$_MOUSEOVER){
					ele.$_MOUSEOVER=true;
					ele.event("mouseover",this._event.setTo("mouseover",ele,this._target));
				}
				this._currOvers.push(ele);
			}
			!this._event._stoped && ele.parent && this.sendMouseOver(ele.parent);
		}

		__proto.onMouseDown=function(ele){
			if (this._isLeftMouse){
				ele.$_MOUSEDOWN=true;
				ele.event("mousedown",this._event.setTo("mousedown",ele,this._target));
				}else {
				ele.$_RIGHTMOUSEDOWN=true;
				ele.event("rightmousedown",this._event.setTo("rightmousedown",ele,this._target));
			}
			!this._event._stoped && ele.parent && this.onMouseDown(ele.parent);
		}

		__proto.onMouseUp=function(ele){
			var type=this._isLeftMouse ? "mouseup" :"rightmouseup";
			this.sendMouseUp(ele,type);
			this._event._stoped=false;
			this.sendClick(this._target,type);
		}

		__proto.sendMouseUp=function(ele,type){
			ele.event(type,this._event.setTo(type,ele,this._target));
			!this._event._stoped && ele.parent && this.sendMouseUp(ele.parent,type);
		}

		__proto.sendClick=function(ele,type){
			if (type==="mouseup" && ele.$_MOUSEDOWN){
				ele.$_MOUSEDOWN=false;
				ele.event("click",this._event.setTo("click",ele,this._target));
				this._isDoubleClick && ele.event("doubleclick",this._event.setTo("doubleclick",ele,this._target));
				}else if (type==="rightmouseup" && ele.$_RIGHTMOUSEDOWN){
				ele.$_RIGHTMOUSEDOWN=false;
				ele.event("rightclick",this._event.setTo("rightclick",ele,this._target));
			}
			!this._event._stoped && ele.parent && this.sendClick(ele.parent,type);
		}

		__proto.check=function(sp,mouseX,mouseY,callBack){
			var transform=sp.transform || this._matrix;
			var pivotX=sp.pivotX;
			var pivotY=sp.pivotY;
			if (pivotX===0 && pivotY===0){
				transform.setTranslate(sp.x,sp.y);
				}else {
				if (transform===this._matrix){
					transform.setTranslate(sp.x-pivotX,sp.y-pivotY);
					}else {
					var cos=transform.cos;
					var sin=transform.sin;
					transform.setTranslate(sp.x-(pivotX *cos-pivotY *sin)*sp.scaleX,sp.y-(pivotX *sin+pivotY *cos)*sp.scaleY);
				}
			}
			transform.invertTransformPoint(this._point.setTo(mouseX,mouseY));
			transform.setTranslate(0,0);
			mouseX=this._point.x;
			mouseY=this._point.y;
			var scrollRect=sp.scrollRect;
			if (scrollRect){
				this._rect.setTo(0,0,scrollRect.width,scrollRect.height);
				var isHit=this._rect.contains(mouseX,mouseY);
				if (!isHit)return false;
			}
			if (!this.disableMouseEvent){
				var flag=false;
				for (var i=sp._childs.length-1;i >-1;i--){
					var child=sp._childs[i];
					if (child.mouseEnabled && child.visible){
						flag=this.check(child,mouseX+(scrollRect ? scrollRect.x :0),mouseY+(scrollRect ? scrollRect.y :0),callBack);
						if (flag)return true;
					}
				}
			}
			if (sp.width > 0 && sp.height > 0){
				var graphicHit=false;
				var hitRect=this._rect;
				if (!sp.mouseThrough){
					if (sp.hitArea)hitRect=sp.hitArea;
					else hitRect.setTo(0,0,sp.width,sp.height);
					isHit=hitRect.contains(mouseX,mouseY);
					}else {
					isHit=sp.getGraphicBounds().contains(mouseX,mouseY);
				}
				if (isHit){
					this._target=sp;
					callBack.call(this,sp);
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
				switch (evt.type){
					case 'mousedown':
						_this._isLeftMouse=evt.button===0;
						_this.initEvent(evt);
						_this.check(_this._stage,_this.mouseX,_this.mouseY,_this.onMouseDown);
						break ;
					case 'mouseup':
						_this._isLeftMouse=evt.button===0;
						var now=Browser.now();
						_this._isDoubleClick=(now-_this._lastClickTimer)< 300;
						_this._lastClickTimer=now;
						_this.initEvent(evt);
						_this.check(_this._stage,_this.mouseX,_this.mouseY,_this.onMouseUp);
						break ;
					case 'mousemove':
						_this.initEvent(evt);
						_this.check(_this._stage,_this.mouseX,_this.mouseY,_this.onMouseMove);
						_this.checkMouseOut();
						break ;
					case "touchstart":
						_this._isLeftMouse=true;
						var touches=evt.changedTouches;
						for (var j=0,n=touches.length;j < n;j++){
							_this.initEvent(touches[j],evt);
							_this.check(_this._stage,_this.mouseX,_this.mouseY,_this.onMouseDown);
						}
						break ;
					case "touchend":
						_this._isLeftMouse=true;
						var touchends=evt.changedTouches;
						for (j=0,n=touchends.length;j < n;j++){
							_this.initEvent(touchends[j],evt);
							_this.check(_this._stage,_this.mouseX,_this.mouseY,_this.onMouseUp);
						}
						break ;
					case "touchmove":;
						var touchemoves=evt.changedTouches;
						for (j=0,n=touchemoves.length;j < n;j++){
							_this.initEvent(touchemoves[j],evt);
							_this.check(_this._stage,_this.mouseX,_this.mouseY,_this.onMouseMove);
						}
						_this.checkMouseOut();
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
		__static(MouseManager,
		['instance',function(){return this.instance=new MouseManager();}
		]);
		return MouseManager;
	})()


	/**
	*<code>Filter</code> 是滤镜基类。
	*/
	//class laya.filters.Filter
	var Filter=(function(){
		function Filter(){
			this._action=null;
		}

		__class(Filter,'laya.filters.Filter');
		var __proto=Filter.prototype;
		Laya.imps(__proto,{"laya.filters.IFilter":true})
		/**滤镜类型。 */
		__getset(0,__proto,'type',function(){return-1});
		/**滤镜动作。*/
		__getset(0,__proto,'action',function(){return this._action});
		Filter.BLUR=0x10;
		Filter.COLOR=0x20;
		Filter.GLOW=0x08;
		Filter._filterStart=null
		Filter._filterEnd=null
		Filter._EndTarget=null
		Filter._recycleScope=null
		Filter._filter=null
		Filter._useSrc=null
		Filter._endSrc=null
		Filter._useOut=null
		Filter._endOut=null
		return Filter;
	})()


	/**
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
			var ctx=srcCanvas.ctx.ctx;
			var canvas=srcCanvas.ctx.ctx.canvas;
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
			if (this.data._elements){
				var a=this.data._elements;
				rst[0]=a[0] *red+a[1] *green+a[2] *blue+a[3] *alpha+a[4];
				rst[1]=a[5] *red+a[6] *green+a[7] *blue+a[8] *alpha+a[9];
				rst[2]=a[10] *red+a[11] *green+a[12] *blue+a[13] *alpha+a[14];
				rst[3]=a[15] *red+a[16] *green+a[17] *blue+a[18] *alpha+a[19];
			}
			return rst;
		}

		return ColorFilterAction;
	})()


	/**
	*计算贝塞尔曲线的工具类。
	*/
	//class laya.maths.Bezier
	var Bezier=(function(){
		function Bezier(){
			this.controlPoints=[new Point(),new Point(),new Point()];
			this._calFun=this.getPoint2;
		}

		__class(Bezier,'laya.maths.Bezier');
		var __proto=Bezier.prototype;
		__proto._switchPoint=function(x,y){
			var tPoint=this.controlPoints.shift();
			tPoint.setTo(x,y);
			this.controlPoints.push(tPoint);
		}

		/**
		*计算二次贝塞尔点。
		*@param t
		*@param rst
		*
		*/
		__proto.getPoint2=function(t,rst){
			var p1=this.controlPoints[0];
			var p2=this.controlPoints[1];
			var p3=this.controlPoints[2];
			var lineX=Math.pow((1-t),2)*p1.x+2 *t *(1-t)*p2.x+Math.pow(t,2)*p3.x;
			var lineY=Math.pow((1-t),2)*p1.y+2 *t *(1-t)*p2.y+Math.pow(t,2)*p3.y;
			rst.push(lineX,lineY);
		}

		/**
		*计算三次贝塞尔点
		*@param t
		*@param rst
		*
		*/
		__proto.getPoint3=function(t,rst){
			var p1=this.controlPoints[0];
			var p2=this.controlPoints[1];
			var p3=this.controlPoints[2];
			var p4=this.controlPoints[3];
			var lineX=Math.pow((1-t),3)*p1.x+3 *p2.x *t *(1-t)*(1-t)+3 *p3.x *t *t *(1-t)+p4.x *Math.pow(t,3);
			var lineY=Math.pow((1-t),3)*p1.y+3 *p2.y *t *(1-t)*(1-t)+3 *p3.y *t *t *(1-t)+p4.y *Math.pow(t,3);
			rst.push(lineX,lineY);
		}

		/**
		*计算贝塞尔点序列
		*@param count
		*@param rst
		*
		*/
		__proto.insertPoints=function(count,rst){
			var i=0,len=0;
			count=count > 0 ? count :5;
			len=count;
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
		*@return
		*
		*/
		__proto.getBezierPoints=function(pList,inSertCount,count){
			(inSertCount===void 0)&& (inSertCount=5);
			(count===void 0)&& (count=2);
			var i=0,len=0;
			len=pList.length;
			if (len < (count+1)*2)return [];
			var rst;
			rst=[];
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
			for (i=0;i < count *2;i+=2){
				this._switchPoint(pList[i],pList[i+1]);
			}
			for (i=count *2;i < len;i+=2){
				this._switchPoint(pList[i],pList[i+1]);
				if ((i / 2)% count==0)
					this.insertPoints(inSertCount,rst);
			}
			return rst;
		}

		__static(Bezier,
		['I',function(){return this.I=new Bezier();}
		]);
		return Bezier;
	})()


	/**
	*@private
	*凸包算法。
	*/
	//class laya.maths.GrahamScan
	var GrahamScan=(function(){
		function GrahamScan(){};
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
				Utils.getFrom(rst,GrahamScan._mPointList,count);
				}else {
				Utils.getFromR(rst,GrahamScan._mPointList,count);
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
			return Utils.setValueArr(pList,GrahamScan.pointListToPlist(GrahamScan.scan(GrahamScan.pListToPointList(pList,true))));
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
			Utils.setValueArr(PointSet,ch);
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
				return Utils.setValueArr(ch,PointSet);
			}
			ch.push(PointSet[0],PointSet[1],PointSet[2]);
			for (i=3;i < n;i++){
				while (ch.length >=2 && GrahamScan.multiply(PointSet[i],ch[ch.length-1],ch[ch.length-2])>=0)ch.pop();
				PointSet[i] && ch.push(PointSet[i]);
			}
			return ch;
		}

		GrahamScan._mPointList=null
		GrahamScan._tempPointList=[];
		GrahamScan._temPList=[];
		GrahamScan._temArr=[];
		return GrahamScan;
	})()


	/**
	*<code>Matrix</code> 类表示一个转换矩阵，它确定如何将点从一个坐标空间映射到另一个坐标空间。
	*/
	//class laya.maths.Matrix
	var Matrix=(function(){
		function Matrix(a,b,c,d,tx,ty){
			this.cos=1;
			this.sin=0;
			//this.a=NaN;
			//this.b=NaN;
			//this.c=NaN;
			//this.d=NaN;
			//this.tx=NaN;
			//this.ty=NaN;
			this.bTransform=false;
			this.inPool=false;
			(a===void 0)&& (a=1);
			(b===void 0)&& (b=0);
			(c===void 0)&& (c=0);
			(d===void 0)&& (d=1);
			(tx===void 0)&& (tx=0);
			(ty===void 0)&& (ty=0);
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
		*为每个矩阵属性设置一个值。
		*@return 返回当前矩形。
		*/
		__proto.identity=function(){
			this.a=this.d=1;
			this.b=this.tx=this.ty=this.c=0;
			this.bTransform=false;
			return this;
		}

		/**
		*@private
		*/
		__proto._checkTransform=function(){
			return this.bTransform=(this.a!==1 || this.b!==0 || this.c!==0 || this.d!==1);
		}

		/**
		*设置沿 x 、y 轴平移每个点的距离。
		*@param x 沿 x 轴平移每个点的距离。
		*@param y 沿 y 轴平移每个点的距离。
		*/
		__proto.setTranslate=function(x,y){
			this.tx=x;
			this.ty=y;
		}

		/**
		*沿 x 和 y 轴平移矩阵，由 x 和 y 参数指定。
		*@param x 沿 x 轴向右移动的量（以像素为单位）。
		*@param y 沿 y 轴向下移动的量（以像素为单位）。
		*@return 返回此矩形。
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
		*/
		__proto.scale=function(x,y){
			this.a *=x;
			this.d *=y;
			this.c *=x;
			this.b *=y;
			this.tx *=x;
			this.ty *=y;
			this.bTransform=true;
		}

		/**
		*对 Matrix 对象应用旋转转换。
		*@param angle 以弧度为单位的旋转角度。
		*/
		__proto.rotate=function(angle){
			var cos=this.cos=Math.cos(angle);
			var sin=this.sin=Math.sin(angle);
			var a1=this.a;
			var c1=this.c;
			var tx1=this.tx;
			this.a=a1 *cos-this.b *sin;
			this.b=a1 *sin+this.b *cos;
			this.c=c1 *cos-this.d *sin;
			this.d=c1 *sin+this.d *cos;
			this.tx=tx1 *cos-this.ty *sin;
			this.ty=tx1 *sin+this.ty *cos;
			this.bTransform=true;
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
			out.setTo(a2 *out.x+c2 *out.y+tx2,b2 *out.x+d2 *out.y+ty2);
		}

		/**
		*将 Matrix 对象表示的几何转换应用于指定点。
		*@param x 点的 X 轴坐标点。
		*@param y 点的 Y 轴坐标点。
		*@param out 用来设定输出结果的点。
		*/
		__proto.transformPoint=function(x,y,out){
			out.setTo(this.a *x+this.c *y+this.tx,this.b *x+this.d *y+this.ty);
		}

		/**
		*将 Matrix 对象表示的几何转换应用于指定点。
		*@param data 点集合。
		*@param out 存储应用转化的点的列表。
		*/
		__proto.transformPointArray=function(data,out){
			var len=data.length;
			for (var i=0;i < len;i+=2){
				var x=data[i],y=data[i+1];
				out[i]=this.a *x+this.c *y+this.tx;
				out[i+1]=this.b *x+this.d *y+this.ty;
			}
		}

		/**
		*将 Matrix 对象表示的几何缩放转换应用于指定点。
		*@param data 点集合。
		*@param out 存储应用转化的点的列表。
		*/
		__proto.transformPointArrayScale=function(data,out){
			var len=data.length;
			for (var i=0;i < len;i+=2){
				var x=data[i],y=data[i+1];
				out[i]=this.a *x+this.c *y;
				out[i+1]=this.b *x+this.d *y;
			}
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
		*@param mtx 要连接到源矩阵的矩阵。
		*@return 当前矩阵。
		*/
		__proto.concat=function(mtx){
			var a=this.a;
			var c=this.c;
			var tx=this.tx;
			this.a=a *mtx.a+this.b *mtx.c;
			this.b=a *mtx.b+this.b *mtx.d;
			this.c=c *mtx.a+this.d *mtx.c;
			this.d=c *mtx.b+this.d *mtx.d;
			this.tx=tx *mtx.a+this.ty *mtx.c+mtx.tx;
			this.ty=tx *mtx.b+this.ty *mtx.d+mtx.ty;
			return this;
		}

		/**
		*返回一个新的 Matrix 对象，它是此矩阵的克隆，带有与所含对象完全相同的副本。
		*@return 一个 Matrix 对象。
		*/
		__proto.clone=function(){
			var no=Matrix._cache;
			var dec=!no._length ? (new Matrix()):no[--no._length];
			dec.a=this.a;
			dec.b=this.b;
			dec.c=this.c;
			dec.d=this.d;
			dec.tx=this.tx;
			dec.ty=this.ty;
			dec.bTransform=this.bTransform;
			return dec;
		}

		/**
		*将当前 Matrix 对象中的所有矩阵数据复制到指定的 Matrix 对象中。
		*@param dec 要复制当前矩阵数据的 Matrix 对象。
		*@return 已复制当前矩阵数据的 Matrix 对象。
		*/
		__proto.copy=function(dec){
			dec.a=this.a;
			dec.b=this.b;
			dec.c=this.c;
			dec.d=this.d;
			dec.tx=this.tx;
			dec.ty=this.ty;
			dec.bTransform=this.bTransform;
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
			if (this.inPool)return;
			var cache=Matrix._cache;
			this.inPool=true;
			cache._length || (cache._length=0);
			cache[cache._length++]=this;
			this.a=this.d=1;
			this.b=this.c=this.tx=this.ty=0;
			this.bTransform=false;
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
			var cache=Matrix._cache;
			var mat=!cache._length ? (new Matrix()):cache[--cache._length];
			mat.inPool=false;
			return mat;
		}

		Matrix.EMPTY=new Matrix();
		Matrix.TEMP=new Matrix();
		Matrix._cache=[];
		return Matrix;
	})()


	/**
	*<code>Point</code> 对象表示二维坐标系统中的某个位置，其中 x 表示水平轴，y 表示垂直轴。
	*/
	//class laya.maths.Point
	var Point=(function(){
		function Point(x,y){
			//this.x=NaN;
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

		Point.TEMP=new Point();
		Point.EMPTY=new Point();
		return Point;
	})()


	/**
	*<code>Rectangle</code> 对象是按其位置（由它左上角的点 (x,y)确定）以及宽度和高度定义的区域。
	*/
	//class laya.maths.Rectangle
	var Rectangle=(function(){
		function Rectangle(x,y,width,height){
			//this.x=NaN;
			//this.y=NaN;
			//this.width=NaN;
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
		*检测此矩形对象是否包含指定的点。
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
		*检测传入的矩形对象是否与此对象相交。
		*@param rect Rectangle 对象。
		*@return 如果传入的矩形对象与此对象相交，则返回 true 值，否则返回 false。
		*/
		__proto.intersects=function(rect){
			return !(rect.x > this.right || rect.right < this.x || rect.y > this.bottom || rect.bottom < this.y);
		}

		/**
		*获取此对象与传入的矩形对象的相交区域。并将相交区域赋值给传入的输出矩形对象。
		*@param rect 待比较的矩形区域。
		*@param out 待输出的矩形区域。建议：尽量用此对象复用对象，减少对象创建消耗。
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
		*矩形联合，通过填充两个矩形之间的水平和垂直空间，将这两个矩形组合在一起以创建一个新的 Rectangle 对象。
		*@param 目标矩形对象。
		*@param out 待输出结果的矩形对象。建议：尽量用此对象复用对象，减少对象创建消耗。
		*@return 两个矩形后联合的 Rectangle 对象 out 。
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
		*@param out 待输出的矩形对象。建议：尽量用此对象复用对象，减少对象创建消耗。
		*@return Rectangle 对象 out ，其 x、y、width 和 height 属性的值与当前 Rectangle 对象的对应值相同。
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
		__proto.equal=function(rect){
			if (!rect || rect.x!==this.x || rect.y!==this.y || rect.width!==this.width || rect.height!==this.height)return false;
			return true;
		}

		/**
		*在当前矩形区域中加一个点。
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

		/**此矩形的右边距。 x 和 width 属性的和。*/
		__getset(0,__proto,'right',function(){
			return this.x+this.width;
		});

		/**此矩形的底边距。y 和 height 属性的和。*/
		__getset(0,__proto,'bottom',function(){
			return this.y+this.height;
		});

		Rectangle._getBoundPointS=function(x,y,width,height){
			var rst=Rectangle._temA;
			rst.length=0;
			if (width==0 || height==0)return rst;
			rst.push(x,y,x+width,y,x,y+height,x+width,y+height);
			return rst;
		}

		Rectangle._getWrapRec=function(pointList,rst){
			if (!pointList || pointList.length < 1)return rst ? rst.setTo(0,0,0,0):Rectangle.EMPTY;
			rst=rst ? rst :new Rectangle();
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


	/**
	*<code>SoundManager</code> 是一个声音管理类。
	*/
	//class laya.media.SoundManager
	var SoundManager=(function(){
		function SoundManager(){};
		__class(SoundManager,'laya.media.SoundManager');
		/**
		*设置是否失去焦点后自动停止背景音乐。
		*@param v Boolean 值。
		*
		*/
		/**
		*表示是否失去焦点后自动停止背景音乐。
		*@return
		*/
		__getset(1,SoundManager,'autoStopMusic',function(){
			return SoundManager._autoStopMusic;
			},function(v){
			Laya.stage.off("blur",null,SoundManager._stageOnBlur);
			Laya.stage.off("focus",null,SoundManager._stageOnFocus);
			SoundManager._autoStopMusic=v;
			if (v){
				Laya.stage.on("blur",null,SoundManager._stageOnBlur);
				Laya.stage.on("focus",null,SoundManager._stageOnFocus);
			}
		});

		/**
		*表示是否静音。
		*/
		__getset(1,SoundManager,'muted',function(){
			return SoundManager._muted;
			},function(value){
			if (value){
				if (SoundManager._tMusic)
					SoundManager.stopSound(SoundManager._tMusic);
			}
			SoundManager._muted=value;
		});

		/**表示是否使音效静音。*/
		__getset(1,SoundManager,'soundMuted',function(){
			return SoundManager._soundMuted;
			},function(value){
			SoundManager._soundMuted=value;
		});

		/**表示是否使背景音乐静音。*/
		__getset(1,SoundManager,'musicMuted',function(){
			return SoundManager._musicMuted;
			},function(value){
			if (value){
				if (SoundManager._tMusic)
					SoundManager.stopSound(SoundManager._tMusic);
				SoundManager._musicMuted=value;
				}else {
				SoundManager._musicMuted=value;
				if (SoundManager._tMusic){
					SoundManager.playMusic(SoundManager._tMusic);
				}
			}
		});

		SoundManager.addChannel=function(channel){
			if (SoundManager._channels.indexOf(channel)>=0)return;
			SoundManager._channels.push(channel);
		}

		SoundManager.removeChannel=function(channel){
			var i=0;
			for (i=SoundManager._channels.length-1;i >=0;i--){
				if (SoundManager._channels[i]==channel){
					SoundManager._channels.splice(i,1);
				}
			}
		}

		SoundManager._stageOnBlur=function(){
			if (SoundManager._musicChannel){
				if (!SoundManager._musicChannel.isStopped){
					SoundManager._blurPaused=true;
					SoundManager._musicChannel.stop();
				}
			}
		}

		SoundManager._stageOnFocus=function(){
			if (SoundManager._blurPaused){
				SoundManager.playMusic(SoundManager._tMusic);
				SoundManager._blurPaused=false;
			}
		}

		SoundManager.playSound=function(url,loops,complete,soundClass){
			(loops===void 0)&& (loops=1);
			if (SoundManager._muted)
				return null;
			if (url==SoundManager._tMusic){
				if (SoundManager._musicMuted)return null;
				}else {
				if (SoundManager._soundMuted)return null;
			};
			var tSound=Laya.loader.getRes(url);
			if (!soundClass)soundClass=Sound;
			if (!tSound){
				tSound=new soundClass();
				tSound.load(url);
				Loader.cacheRes(url,tSound);
			};
			var channel;
			channel=tSound.play(0,loops);
			channel.volume=(url==SoundManager._tMusic)? SoundManager.musicVolume :SoundManager.soundVolume;
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

		SoundManager.playMusic=function(url,loops,complete){
			(loops===void 0)&& (loops=0);
			SoundManager._tMusic=url;
			if (SoundManager._musicChannel)
				SoundManager._musicChannel.stop();
			return SoundManager._musicChannel=SoundManager.playSound(url,loops,complete,AudioSound);
		}

		SoundManager.stopSound=function(url){
			var i=0;
			var channel;
			for (i=SoundManager._channels.length-1;i >=0;i--){
				channel=SoundManager._channels[i];
				if (channel.url==url){
					channel.stop();
				}
			}
		}

		SoundManager.stopMusic=function(){
			if (SoundManager._musicChannel)
				SoundManager._musicChannel.stop();
		}

		SoundManager.setSoundVolume=function(volume,url){
			if (url){
				SoundManager._setVolume(url,volume);
				}else {
				SoundManager.soundVolume=volume;
			}
		}

		SoundManager.setMusicVolume=function(volume){
			SoundManager.musicVolume=volume;
			SoundManager._setVolume(SoundManager._tMusic,volume);
		}

		SoundManager._setVolume=function(url,volume){
			var i=0;
			var channel;
			for (i=SoundManager._channels.length-1;i >=0;i--){
				channel=SoundManager._channels[i];
				if (channel.url==url){
					channel.volume=volume;
				}
			}
		}

		SoundManager.musicVolume=1;
		SoundManager.soundVolume=1;
		SoundManager._muted=false;
		SoundManager._soundMuted=false;
		SoundManager._musicMuted=false;
		SoundManager._tMusic=null;
		SoundManager._musicChannel=null;
		SoundManager._channels=[];
		SoundManager._autoStopMusic=false;
		SoundManager._blurPaused=false;
		return SoundManager;
	})()


	/**
	*<p> <code>URL</code> 类用于定义地址信息。</p>
	*/
	//class laya.net.URL
	var URL=(function(){
		function URL(url){
			this._url=null;
			this._path=null;
			this._url=URL.formatURL(url);
			this._path=URL.getPath(url);
		}

		__class(URL,'laya.net.URL');
		var __proto=URL.prototype;
		/**
		*格式化后的地址。
		*/
		__getset(0,__proto,'url',function(){
			return this._url;
		});

		/**
		*地址的路径。
		*/
		__getset(0,__proto,'path',function(){
			return this._path;
		});

		URL.formatURL=function(url,_basePath){
			if (URL.customFormat !=null)url=URL.customFormat(url,_basePath);
			if (!url)return "null path";
			URL.version[url] && (url+="?v="+URL.version[url]);
			if (!Browser.httpProtocol && url[0]=='/')
				return URL.rootPath+url;
			if (URL.isAbsolute(url))
				return url;
			return (_basePath || URL.basePath)+url;
		}

		URL.isAbsolute=function(url){
			return url.indexOf(":")> 0 || url.charAt(0)=='/';
		}

		URL.getPath=function(url){
			var ofs=url.lastIndexOf('/');
			return ofs > 0 ? url.substr(0,ofs+1):"";
		}

		URL.getName=function(url){
			var ofs=url.lastIndexOf('/');
			return ofs > 0 ? url.substr(ofs+1):url;
		}

		URL.version={};
		URL.basePath="";
		URL.rootPath="";
		URL.customFormat=null
		return URL;
	})()


	/**
	*@private
	*<code>Render</code> 是渲染管理类。它是一个单例，可以使用 Laya.render 访问。
	*/
	//class laya.renders.Render
	var Render=(function(){
		/**
		*初始化引擎。
		*@param width 游戏窗口宽度。
		*@param height 游戏窗口高度。
		*/
		function Render(width,height){
			Render._mainCanvas=new HTMLCanvas('2D');
			var style=Render._mainCanvas.source.style;
			style.position='absolute';
			style.top=style.left="0px";
			style.background="#000000";
			Render._mainCanvas.source.id="layaCanvas";
			var isWebGl=Render.WebGL !=null;
			isWebGl && Render.WebGL.init(Render.canvas,width,height);
			Browser.document.body.appendChild(Render._mainCanvas.source);
			Render._context=new RenderContext(width,height,isWebGl ? null :Render._mainCanvas);
			Browser.window.requestAnimationFrame(loop);
			function loop (){
				Laya.stage._loop();
				Browser.window.requestAnimationFrame(loop);
			}
		}

		__class(Render,'laya.renders.Render');
		/**目前使用的渲染器。*/
		__getset(1,Render,'context',function(){
			return Render._context;
		});

		/**是否是 WebGl 模式。*/
		__getset(1,Render,'isWebGl',function(){
			return Render.WebGL !=null;
		});

		/**渲染使用的画布引用。 */
		__getset(1,Render,'canvas',function(){
			return Render._mainCanvas;
		});

		Render._context=null
		Render._mainCanvas=null
		Render.WebGL=null
		Render.clear=function(value){
			Render._context.ctx.clear();
		}

		Render.clearAtlas=function(value){
		};

		Render.finish=function(){
		};

		return Render;
	})()


	/**
	*@private
	*渲染环境
	*/
	//class laya.renders.RenderContext
	var RenderContext=(function(){
		function RenderContext(width,height,canvas){
			this.x=0;
			this.y=0;
			//this.canvas=null;
			//this.ctx=null;
			if (canvas){
				this.ctx=canvas.getContext('2d');
				}else {
				canvas=new HTMLCanvas("3D");
				this.ctx=System.createWebGLContext2D(canvas);
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

		__proto.drawTexture=function(tex,x,y,width,height){
			tex.loaded ? this.ctx.drawTexture(tex,x,y,width,height,this.x,this.y):(this.ctx._repaint=true);
		}

		__proto._drawTexture=function(x,y,args){
			args[0].loaded ? this.ctx.drawTexture(args[0],args[1],args[2],args[3],args[4],x,y):(this.ctx._repaint=true);
		}

		__proto.drawTextureWithTransform=function(tex,x,y,width,height,m){
			tex.loaded ? this.ctx.drawTextureWithTransform(tex,x,y,width,height,m,this.x,this.y):(this.ctx._repaint=true);
		}

		__proto._drawTextureWithTransform=function(x,y,args){
			args[0].loaded ? this.ctx.drawTextureWithTransform(args[0],args[1],args[2],args[3],args[4],args[5],x,y):(this.ctx._repaint=true);
		}

		__proto.fillQuadrangle=function(tex,x,y,point4,m){
			this.ctx.fillQuadrangle(tex,x,y,point4,m);
		}

		__proto._fillQuadrangle=function(x,y,args){
			this.ctx.fillQuadrangle(args[0],args[1],args[2],args[3],args[4]);
		}

		__proto.drawCanvas=function(canvas,x,y,width,height){
			this.ctx.drawCanvas(canvas,x+this.x,y+this.y,width,height);
		}

		__proto.drawRect=function(x,y,width,height,color,lineWidth){
			(lineWidth===void 0)&& (lineWidth=1);
			var ctx=this.ctx;
			ctx.strokeStyle=color;
			ctx.lineWidth=lineWidth;
			ctx.strokeRect(x+this.x,y+this.y,width,height,lineWidth);
		}

		__proto._drawRect=function(x,y,args){
			var ctx=this.ctx;
			if (args[4] !=null){
				ctx.fillStyle=args[4];
				ctx.fillRect(x+args[0],y+args[1],args[2],args[3]);
			}
			if (args[5] !=null){
				ctx.strokeStyle=args[5];
				ctx.lineWidth=args[6];
				ctx.strokeRect(x+args[0],y+args[1],args[2],args[3],args[6]);
			}
		}

		//x:Number,y:Number,points:Array,fillColor:String,lineColor:String=null,lineWidth:Number=1
		__proto._drawPoly=function(x,y,args){
			var ctx=this.ctx;
			ctx.beginPath();
			var points=args[2];
			x+=args[0],y+=args[1];
			ctx.moveTo(x+points[0],y+points[1]);
			var i=2,n=points.length;
			while (i < n){
				ctx.lineTo(x+points[i++],y+points[i++]);
			}
			ctx.closePath();
			this.fillAndStroke(args[3],args[4],args[5]);
		}

		__proto._drawPolyGL=function(x,y,args){
			var points=args[2];
			x+=args[0],y+=args[1];
			this.ctx.drawPoly(x,y,points,args[3],args[5],args[4]);
		}

		//x:Number,y:Number,paths:Array,brush:Object=null,pen:Object=null
		__proto._drawPath=function(x,y,args){
			var ctx=this.ctx;
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

		__proto.fillAndStroke=function(fillColor,strokeColor,lineWidth){
			if (fillColor !=null){
				this.ctx.fillStyle=fillColor;
				this.ctx.fill();
			}
			if (strokeColor !=null){
				this.ctx.strokeStyle=strokeColor;
				this.ctx.lineWidth=lineWidth;
				this.ctx.stroke();
			}
		}

		//矢量方法
		__proto._drawPie=function(x,y,args){
			var ctx=this.ctx;
			ctx.translate(x+args[0],y+args[1]);
			ctx.beginPath();
			ctx.moveTo(0,0);
			ctx.arc(0,0,args[2],args[3],args[4]);
			ctx.closePath();
			this.fillAndStroke(args[5],args[6],args[7]);
			ctx.translate(-x-args[0],-y-args[1]);
		}

		__proto._drawPieWebGL=function(x,y,args){
			var ctx=this.ctx;
			ctx.lineWidth=args[7];
			ctx.fan(x+this.x+args[0],y+this.y+args[1],args[2],args[3],args[4],args[5],args[6]);
		}

		__proto.clipRect=function(x,y,width,height){
			this.ctx.clipRect(x+this.x,y+this.y,width,height);
		}

		__proto._clipRect=function(x,y,args){
			this.ctx.clipRect(x+args[0],y+args[1],args[2],args[3]);
		}

		__proto.fillRect=function(x,y,width,height,fillStyle){
			this.ctx.fillRect(x+this.x,y+this.y,width,height,fillStyle);
		}

		__proto._fillRect=function(x,y,args){
			this.ctx.fillRect(x+args[0],y+args[1],args[2],args[3],args[4]);
		}

		__proto.drawCircle=function(x,y,radius,color,lineWidth){
			(lineWidth===void 0)&& (lineWidth=1);
			var ctx=this.ctx;
			ctx.beginPath();
			ctx.strokeStyle=color;
			ctx.lineWidth=lineWidth;
			ctx.arc(x+this.x,y+this.y,radius,0,RenderContext.PI2);
			ctx.stroke();
		}

		__proto._drawCircle=function(x,y,args){
			var ctx=this.ctx;
			ctx.beginPath();
			ctx.arc(args[0]+x,args[1]+y,args[2],0,RenderContext.PI2);
			this.fillAndStroke(args[3],args[4],args[5]);
		}

		__proto._drawCircleWebGL=function(x,y,args){
			this.ctx.drawCircle(x+this.x+args[0],y+this.y+args[1],args[2],40,args[4],args[5],args[3]);
		}

		__proto.fillCircle=function(x,y,radius,color){
			var ctx=this.ctx;
			ctx.beginPath();
			ctx.fillStyle=color;
			ctx.arc(x+this.x,y+this.y,radius,0,RenderContext.PI2);
			ctx.fill();
		}

		__proto._fillCircle=function(x,y,args){
			var ctx=this.ctx;
			ctx.beginPath();
			ctx.fillStyle=args[3];
			ctx.arc(args[0]+x,args[1]+y,args[2],0,RenderContext.PI2);
			ctx.fill();
		}

		__proto.setShader=function(shader){
			this.ctx.setShader(shader);
		}

		__proto._setShader=function(x,y,args){
			this.ctx.setShader(args[0]);
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

		__proto._drawLine=function(x,y,args){
			var ctx=this.ctx;
			ctx.beginPath();
			ctx.strokeStyle=args[4];
			ctx.lineWidth=args[5];
			ctx.moveTo(x+args[0],y+args[1]);
			ctx.lineTo(x+args[2],y+args[3]);
			ctx.stroke();
		}

		__proto.drawLines=function(x,y,args){
			var ctx=this.ctx;
			ctx.beginPath();
			ctx.strokeStyle=args[3];
			ctx.lineWidth=args[4];
			var points=args[2];
			x+=args[0],y+=args[1];
			ctx.moveTo(x+points[0],y+points[1]);
			var i=2,n=points.length;
			while (i < n){
				ctx.lineTo(x+points[i++],y+points[i++]);
			}
			ctx.stroke();
		}

		__proto.drawLinesWebGL=function(x,y,args){
			this.ctx.drawLines(x+this.x+args[0],y+this.y+args[1],args[2],args[3],args[4]);
		}

		//x:Number,y:Number,points:Array,lineColor:String,lineWidth:Number=1
		__proto.drawCurves=function(x,y,args){
			var ctx=this.ctx;
			ctx.beginPath();
			ctx.strokeStyle=args[3];
			ctx.lineWidth=args[4];
			var points=args[2];
			x+=args[0],y+=args[1];
			ctx.moveTo(x+points[0],y+points[1]);
			var i=2,n=points.length;
			while (i < n){
				ctx.quadraticCurveTo(x+points[i++],y+points[i++],x+points[i++],y+points[i++]);
			}
			ctx.stroke();
		}

		__proto.drawCurvesGL=function(x,y,args){
			var points=args[2];
			x+=args[0],y+=args[1];
			var tBezier=Bezier.I;
			var i=0;
			var n=points.length;
			var tResultArray=[];
			while (i < n){
				var tArray=tBezier.getBezierPoints([points[i++],points[i++],points[i++],points[i++],points[i++],points[i++]],30,2)
				tResultArray=tResultArray.concat(tArray);
				if (i < n){
					i-=2;
				}
			}
			this.ctx.drawLines(x,y,tResultArray,args[3],args[4]);
		}

		__proto.draw=function(x,y,args){
			args[0].call(null,this,x,y);
		}

		__proto.clear=function(){
			this.ctx.clear();
		}

		__proto.transform=function(a,b,c,d,tx,ty){
			this.ctx.transform(a,b,c,d,tx,ty);
		}

		__proto.transformByMatrix=function(value){
			this.ctx.transformByMatrix(value);
		}

		__proto._transformByMatrix=function(x,y,args){
			this.ctx.transformByMatrix(args[0]);
		}

		__proto.setTransform=function(a,b,c,d,tx,ty){
			this.ctx.setTransform(a,b,c,d,tx,ty);
		}

		__proto._setTransform=function(x,y,args){
			this.ctx.setTransform(args[0],args[1],args[2],args[3],args[4],args[5]);
		}

		__proto.setTransformByMatrix=function(value){
			this.ctx.setTransformByMatrix(value);
		}

		__proto._setTransformByMatrix=function(x,y,args){
			this.ctx.setTransformByMatrix(args[0]);
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

		__proto._translate=function(x,y,args){
			this.ctx.translate(args[0],args[1]);
		}

		__proto.rotate=function(angle){
			this.ctx.rotate(angle);
		}

		__proto._transform=function(x,y,args){
			this.ctx.translate(args[1]+x,args[2]+y);
			var mat=args[0];
			this.ctx.transform(mat.a,mat.b,mat.c,mat.d,mat.tx,mat.ty);
			this.ctx.translate(-x-args[1],-y-args[2]);
		}

		__proto._rotate=function(x,y,args){
			this.ctx.translate(args[1]+x,args[2]+y);
			this.ctx.rotate(args[0]);
			this.ctx.translate(-x-args[1],-y-args[2]);
		}

		__proto._scale=function(x,y,args){
			this.ctx.translate(args[2]+x,args[3]+y);
			this.ctx.scale(args[0],args[1]);
			this.ctx.translate(-x-args[2],-y-args[3]);
		}

		__proto.scale=function(scaleX,scaleY){
			this.ctx.scale(scaleX,scaleY);
		}

		__proto.alpha=function(value){
			this.ctx.globalAlpha=value;
		}

		__proto._alpha=function(x,y,args){
			this.ctx.globalAlpha=args[0];
		}

		__proto.setAlpha=function(value){
			this.ctx.globalAlpha=value;
		}

		__proto._setAlpha=function(x,y,args){
			this.ctx.globalAlpha=args[0];
		}

		__proto.fillWords=function(words,x,y,font,color){
			this.ctx.fillWords(words,x,y,font,color);
		}

		__proto.fillText=function(text,x,y,font,color,textAlign){
			this.ctx.fillText(text,x+this.x,y+this.y,font,color,textAlign);
		}

		__proto._fillText=function(x,y,args){
			this.ctx.fillText(args[0],args[1]+x,args[2]+y,args[3],args[4],args[5]);
		}

		__proto.strokeText=function(text,x,y,font,color,lineWidth,textAlign){
			this.ctx.strokeText(text,x+this.x,y+this.y,font,color,lineWidth,textAlign);
		}

		__proto._strokeText=function(x,y,args){
			this.ctx.strokeText(args[0],args[1]+x,args[2]+y,args[3],args[4],args[5],args[6]);
		}

		__proto._fillBorderText=function(x,y,args){
			this.ctx.fillBorderText(args[0],args[1]+x,args[2]+y,args[3],args[4],args[5],args[6],args[7]);
		}

		__proto.blendMode=function(type){
			this.ctx.globalCompositeOperation=type;
		}

		__proto._blendMode=function(x,y,args){
			this.ctx.globalCompositeOperation=args[0];
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

		__proto._beginClip=function(x,y,args){
			this.ctx.beginClip && this.ctx.beginClip(x+args[0],y+args[1],args[2],args[3]);
		}

		__proto.endClip=function(){
			this.ctx.endClip && this.ctx.endClip();
		}

		__proto._setIBVB=function(x,y,args){
			this.ctx.setIBVB(args[0]+x,args[1]+y,args[2],args[3],args[4],args[5],args[6],args[7]);
		}

		__proto.fillTrangles=function(x,y,args){
			this.ctx.fillTrangles(args[0],args[1],args[2],args[3],args.length > 4 ? args[4] :null);
		}

		__proto._fillTrangles=function(x,y,args){
			this.ctx.fillTrangles(args[0],args[1]+x,args[2]+y,args[3],args[4]);
		}

		__proto.drawPath=function(x,y,args){
			this.ctx.drawPath(x+this.x+args[0],y+this.y+args[1],args[2],args[3],args[4]);
		}

		// polygon(x:Number,y:Number,r:Number,edges:Number,color:uint,borderWidth:int=2,borderColor:uint=0)
		__proto.drawPoly=function(x,y,args){
			this.ctx.drawPoly(x+this.x+args[0],y+this.y+args[1],args[2],args[3],args[4],args[5],args[6]);
		}

		__proto.drawParticle=function(x,y,args){
			this.ctx.drawParticle(x+this.x,y+this.y,args[0]);
		}

		__getset(0,__proto,'enableMerge',null,function(value){
			this.ctx.enableMerge=value;
		});

		RenderContext.PI2=2 *Math.PI;
		return RenderContext;
	})()


	/**
	*@private
	*精灵渲染器
	*/
	//class laya.renders.RenderSprite
	var RenderSprite=(function(){
		function RenderSprite(type,next){
			//this._next=null;
			//this._fun=null;
			this._next=next || RenderSprite.NORENDER;
			switch (type){
				case 0:
					this._fun=this._no;
					return;
				case 0x01:
					this._fun=this._image;
					return;
				case 0x04:
					this._fun=this._alpha;
					return;
				case 0x08:
					this._fun=this._transform;
					return;
				case 0x20:
					this._fun=this._blend;
					return;
				case 0x10:
					this._fun=this._canvas;
					return;
				case 0x40:
					this._fun=this._clip;
					return;
				case 0x80:
					this._fun=this._style;
					return;
				case 0x100:
					this._fun=this._graphics;
					return;
				case 0x400:
					this._fun=this._enableRenderMerge;
					return;
				case 0x800:
					this._fun=this._childs;
					return;
				case 0x200:
					this._fun=this._custom;
					return;
				case 0x01 | 0x100:
					this._fun=this._image2;
					return;
				case 0x01 | 0x08 | 0x100:
					this._fun=this._image2;
					return;
				case 0x02:
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
			sprite._style.render(sprite,context,x,y);
			var next=this._next;
			next._fun.call(next,sprite,context,x,y);
		}

		__proto._no=function(sprite,context,x,y){}
		__proto._custom=function(sprite,context,x,y){
			sprite.customRender(context,x,y);
			var style=sprite._style;
			this._next._fun.call(this._next,sprite,context,x-style.translateX,y-style.translateY);
		}

		__proto._clip=function(sprite,context,x,y){
			var next=this._next;
			if (next==RenderSprite.NORENDER)return;
			var r=sprite._style.scrollRect;
			context.ctx.save();
			context.ctx.clipRect(x,y,r.width,r.height);
			next._fun.call(next,sprite,context,x-r.x,y-r.y);
			context.ctx.restore();
		}

		__proto._enableRenderMerge=function(sprite,context,x,y){
			var next=this._next;
			if (next==RenderSprite.NORENDER)return;
			context.ctx.save();
			context.ctx.enableMerge=true;
			next._fun.call(next,sprite,context,x,y);
			context.ctx.restore();
		}

		__proto._blend=function(sprite,context,x,y){
			var style=sprite._style;
			if (style.blendMode){
				context.ctx.globalCompositeOperation=style.blendMode;
			};
			var next=this._next;
			next._fun.call(next,sprite,context,x,y);
			var mask=sprite.mask;
			if (mask){
				context.ctx.globalCompositeOperation="destination-in";
				if (mask.numChildren > 0 || !mask.graphics._isOnlyOne()){
					mask.cacheAsBitmap=true;
				}
				mask.render(context,x,y);
			}
			context.ctx.globalCompositeOperation="source-over";
		}

		__proto._graphics=function(sprite,context,x,y){
			var style=sprite._style;
			sprite._graphics && sprite._graphics._render(sprite,context,x-style.translateX,y-style.translateY);
			var next=this._next;
			next._fun.call(next,sprite,context,x,y);
		}

		__proto._image=function(sprite,context,x,y){
			var style=sprite._style;
			context.ctx.drawTexture2(x,y,style.translateX,style.translateY,sprite.transform,style.alpha,style.blendMode,sprite._graphics._one);
		}

		__proto._image2=function(sprite,context,x,y){
			var style=sprite._style;
			context.ctx.drawTexture2(x,y,style.translateX,style.translateY,sprite.transform,1,null,sprite._graphics._one);
		}

		__proto._alpha=function(sprite,context,x,y){
			var style=sprite._style;
			var alpha;
			if ((alpha=style.alpha)> 0.01){
				var temp=context.ctx.globalAlpha;
				context.ctx.globalAlpha *=alpha;
				var next=this._next;
				next._fun.call(next,sprite,context,x,y);
				context.ctx.globalAlpha=temp;
			}
		}

		__proto._transform=function(sprite,context,x,y){
			var transform=sprite.transform,_next=this._next;
			if (transform && _next !=RenderSprite.NORENDER){
				context.save();
				context.transform(transform.a,transform.b,transform.c,transform.d,transform.tx+x,transform.ty+y);
				_next._fun.call(_next,sprite,context,0,0);
				context.restore();
			}else
			_next._fun.call(_next,sprite,context,x,y);
		}

		__proto._childs=function(sprite,context,x,y){
			var style=sprite._style;
			x+=-style.translateX+style.paddingLeft;
			y+=-style.translateY+style.paddingTop;
			var words=sprite._getWords();
			words && context.fillWords(words,x,y,(style).font,(style).color);
			var childs=sprite._childs,n=childs.length,ele;
			if (!sprite.optimizeFloat || sprite.scrollRect==null){
				for (var i=0;i < n;++i)
				(ele=(childs [i]))._style.visible && ele.render(context,x,y);
				}else {
				var rect=sprite.scrollRect;
				for (i=0;i < n;++i){
					ele=childs [i];
					if (ele._style.visible && rect.intersects(Rectangle.TEMP.setTo(ele.x,ele.y,ele.width,ele.height)))
						ele.render(context,x,y);
				}
			}
		}

		__proto._canvas=function(sprite,context,x,y){
			var _cacheCanvas=sprite._$P.cacheCanvas;
			var _next=this._next;
			if (!_cacheCanvas){
				_next._fun.call(_next,sprite,tx,x,y);
				return;
			};
			var tx=_cacheCanvas.ctx;
			var _repaint=sprite.isRepaint()|| (!tx)|| tx.ctx._repaint;
			var canvas;
			var left;
			var top;
			var tRec;
			_cacheCanvas.type==='bitmap' ? (Stat.canvasBitmap++):(Stat.canvasNormal++);
			if (_repaint){
				if (!_cacheCanvas._cacheRec)
					_cacheCanvas._cacheRec=new Rectangle();
				var w,h;
				tRec=sprite.getSelfBounds();
				if (_cacheCanvas.type==='bitmap'&&(tRec.width > 2048 || tRec.height > 2048)){
					throw new Error("cache bitmap size larger than 2048");
				}
				tRec.x-=sprite.pivotX;
				tRec.y-=sprite.pivotY;
				tRec.x-=10;
				tRec.y-=10;
				tRec.width+=20;
				tRec.height+=20;
				_cacheCanvas._cacheRec.copyFrom(tRec);
				tRec=_cacheCanvas._cacheRec;
				w=tRec.width;
				h=tRec.height;
				left=tRec.x;
				top=tRec.y;
				if (!tx){
					tx=_cacheCanvas.ctx=new RenderContext(w,h,new HTMLCanvas("AUTO"));
					tx.ctx.sprite=sprite;
				}
				canvas=tx.canvas;
				if (_cacheCanvas.type==='bitmap')canvas.asBitmap=true;
				canvas.clear();
				(canvas.width !=w || canvas.height !=h)&& canvas.size(w,h);
				_next._fun.call(_next,sprite,tx,-left,-top);
				sprite.applyFilters();
				if (sprite._$P.isStatic)_cacheCanvas.reCache=false;
				Stat.canvasReCache++;
				}else {
				tRec=_cacheCanvas._cacheRec;
				left=tRec.x;
				top=tRec.y;
				canvas=tx.canvas;
			}
			context.drawCanvas(canvas,x+left,y+top,canvas.width,canvas.height);
		}

		RenderSprite.__init__=function(){
			var i=0,len=0;
			var initRender;
			initRender=System.createRenderSprite(0x11111,null);
			len=RenderSprite.renders.length=0x800 *2;
			for (i=0;i < len;i++)
			RenderSprite.renders[i]=initRender;
			RenderSprite.renders[0]=System.createRenderSprite(0,null);
			function _initSame (value,o){
				var n=0;
				for (var i=0;i < value.length;i++){
					n |=value[i];
					RenderSprite.renders[n]=o;
				}
			}
			_initSame([0x01,0x100,0x08,0x04],new RenderSprite(0x01,null));
			RenderSprite.renders[0x01 | 0x100]=System.createRenderSprite(0x01 | 0x100,null);
			RenderSprite.renders[0x01 | 0x08 | 0x100]=new RenderSprite(0x01 | 0x08 | 0x100,null);
		}

		RenderSprite._initRenderFun=function(sprite,context,x,y){
			var type=sprite._renderType;
			var r=RenderSprite.renders[type]=RenderSprite._getTypeRender(type);
			r._fun(sprite,context,x,y);
		}

		RenderSprite._getTypeRender=function(type){
			var rst=null;
			var tType=0x800;
			while (tType > 1){
				if (tType & type)
					rst=System.createRenderSprite(tType,rst);
				tType=tType >> 1;
			}
			return rst;
		}

		RenderSprite.IMAGE=0x01;
		RenderSprite.FILTERS=0x02;
		RenderSprite.ALPHA=0x04;
		RenderSprite.TRANSFORM=0x08;
		RenderSprite.CANVAS=0x10;
		RenderSprite.BLEND=0x20;
		RenderSprite.CLIP=0x40;
		RenderSprite.STYLE=0x80;
		RenderSprite.GRAPHICS=0x100;
		RenderSprite.CUSTOM=0x200;
		RenderSprite.ENABLERENDERMERGE=0x400;
		RenderSprite.CHILDS=0x800;
		RenderSprite.INIT=0x11111;
		RenderSprite.renders=[];
		RenderSprite.NORENDER=new RenderSprite(0,null);
		return RenderSprite;
	})()


	/**
	*@private
	*Context扩展类
	*/
	//class laya.resource.Context
	var Context=(function(){
		function Context(){
			//this._canvas=null;
			this._repaint=false;
		}

		__class(Context,'laya.resource.Context');
		var __proto=Context.prototype;
		/***@private */
		__proto.drawCanvas=function(canvas,x,y,width,height){
			Stat.drawCall++;
			this.drawImage(canvas.source,x,y,width,height);
		}

		/***@private */
		__proto.fillRect=function(x,y,width,height,style){
			Stat.drawCall++;
			style && (this.fillStyle=style);
			this.__fillRect(x,y,width,height);
		}

		/***@private */
		__proto.fillText=function(text,x,y,font,color,textAlign){
			Stat.drawCall++;
			if (arguments.length > 3 && font !=null){
				this.font=font;
				this.fillStyle=color;
				this.textAlign=textAlign;
				this.textBaseline="top";
			}
			this.__fillText(text,x,y);
		}

		/***@private */
		__proto.fillBorderText=function(text,x,y,font,fillColor,borderColor,lineWidth,textAlign){
			Stat.drawCall++;
			this.font=font;
			this.fillStyle=fillColor;
			this.textBaseline="top";
			this.strokeStyle=borderColor;
			this.lineWidth=lineWidth;
			this.textAlign=textAlign;
			this.__strokeText(text,x,y);
			this.__fillText(text,x,y);
		}

		/***@private */
		__proto.strokeText=function(text,x,y,font,color,lineWidth,textAlign){
			Stat.drawCall++;
			if (arguments.length > 3 && font !=null){
				this.font=font;
				this.strokeStyle=color;
				this.lineWidth=lineWidth;
				this.textAlign=textAlign;
				this.textBaseline="top";
			}
			this.__strokeText(text,x,y);
		}

		/***@private */
		__proto.transformByMatrix=function(value){
			this.transform(value.a,value.b,value.c,value.d,value.tx,value.ty);
		}

		/***@private */
		__proto.setTransformByMatrix=function(value){
			this.setTransform(value.a,value.b,value.c,value.d,value.tx,value.ty);
		}

		/***@private */
		__proto.clipRect=function(x,y,width,height){
			Stat.drawCall++;
			this.beginPath();
			this.rect(x,y,width,height);
			this.clip();
		}

		/***@private */
		__proto.drawTexture=function(tex,x,y,width,height,tx,ty){
			Stat.drawCall++;
			var uv=tex.uv,w=tex.bitmap.width,h=tex.bitmap.height;
			this.drawImage(tex.bitmap.source,uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h,x+tex.offsetX+tx,y+tex.offsetY+ty,width,height);
		}

		/***@private */
		__proto.drawTextureWithTransform=function(tex,x,y,width,height,m,tx,ty){
			Stat.drawCall++;
			var uv=tex.uv,w=tex.bitmap.width,h=tex.bitmap.height;
			this.save();
			this.transform(m.a,m.b,m.c,m.d,m.tx+tx,m.ty+ty);
			this.drawImage(tex.bitmap.source,uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h,x+tex.offsetX,y+tex.offsetY,width,height);
			this.restore();
		}

		/***@private */
		__proto.drawTexture2=function(x,y,pivotX,pivotY,m,alpha,blendMode,args2){
			'use strict';
			Stat.drawCall++;
			var alphaChanged=alpha!==1;
			if (alphaChanged){
				var temp=this.globalAlpha;
				this.globalAlpha *=alpha;
			};
			var tex=args2[0];
			var uv=tex.uv,w=tex.bitmap.width,h=tex.bitmap.height;
			if (m){
				this.save();
				this.transform(m.a,m.b,m.c,m.d,m.tx+x,m.ty+y);
				this.drawImage(tex.bitmap.source,uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h,args2[1]-pivotX+tex.offsetX,args2[2]-pivotY+tex.offsetY,args2[3],args2[4]);
				this.restore();
				}else {
				this.drawImage(tex.bitmap.source,uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h,args2[1]-pivotX+x+tex.offsetX,args2[2]-pivotY+y+tex.offsetY,args2[3],args2[4]);
			}
			if (alphaChanged)this.globalAlpha=temp;
		}

		/***@private */
		__proto.flush=function(){
			return 0;
		}

		/***@private */
		__proto.fillWords=function(words,x,y,font,color){
			font && (this.font=font);
			color && (this.fillStyle=color);
			var _this=this;
			this.textBaseline="top";
			this.textAlign='left';
			for (var i=0,n=words.length;i < n;i++){
				var a=words[i];
				this.__fillText(a.char,a.x+x,a.y+y);
			}
		}

		/***@private */
		__proto.destroy=function(){
			this.canvas.width=this.canvas.height=0;
		}

		/***@private */
		__proto.clear=function(){
			this.clearRect(0,0,this._canvas.width,this._canvas.height);
			this._repaint=false;
		}

		/***@private */
		__getset(0,__proto,'enableMerge',function(){
			return false;
			},function(value){
		});

		Context._init=function(canvas,ctx){
			ctx.__fillText=ctx.fillText;
			ctx.__fillRect=ctx.fillRect;
			ctx.__strokeText=ctx.strokeText;
			var funs=['fillWords','fillRect','strokeText','fillText','transformByMatrix','setTransformByMatrix','clipRect','drawTexture','drawTexture2','drawTextureWithTransform','flush','clear','destroy','drawCanvas','fillBorderText'];
			funs.forEach(function(i){
				ctx[i]=Context._default[i];
			});
		}

		Context._default=new Context();
		return Context;
	})()


	/**
	*<code>ResourceManager</code> 是资源管理类。它用于资源的载入、获取、销毁。
	*/
	//class laya.resource.ResourceManager
	var ResourceManager=(function(){
		function ResourceManager(){
			this._id=0;
			this._name=null;
			this._resources=null;
			this._memorySize=0;
			this._garbageCollectionRate=NaN;
			this._isOverflow=false;
			this.autoRelease=false;
			this.autoReleaseMaxSize=0;
			this._id=++ResourceManager._uniqueIDCounter;
			this._name="Content Manager";
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
				resource.on("memorychanged",this,this.addSize);
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
				resource.off("memorychanged",this,this.addSize);
				return true;
			}
			return false;
		}

		/**
		*卸载此资源管理器载入的资源。
		*/
		__proto.unload=function(){
			if (this===ResourceManager._systemResourceManager)
				throw new Error("systemResourceManager不能被释放！");
			var tempResources=this._resources.slice(0,this._resources.length);
			for (var i=0;i < tempResources.length;i++){
				var resource=tempResources[i];
				resource.resourceManager.removeResource(resource);
				resource.dispose();
			}
			tempResources.length=0;
		}

		/**
		*设置唯一名字。
		*@param newName 名字，如果名字重复则自动加上“-copy”。
		*/
		__proto.setUniqueName=function(newName){
			var isUnique=true;
			for (var i=0;i < ResourceManager._resourceManagers.length;i++){
				if (ResourceManager._resourceManagers[i]._name!==newName || ResourceManager._resourceManagers[i]===this)
					continue ;
				isUnique=false;
				return;
			}
			if (isUnique){
				if (this.name !=newName){
					this.name=newName;
					ResourceManager._isResourceManagersSorted=false;
				}
				}else{
				this.setUniqueName(newName.concat("-copy"));
			}
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
				resource.dispose();
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
				return a.lastUseFrameCount-b.lastUseFrameCount;
			});
			var currentFrameCount=Stat.loopCount;
			for (var i=0,n=all.length;i < n;i++){
				var resou=all[i];
				if (currentFrameCount-resou.lastUseFrameCount > 1){
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
		*排序后的资源管理器列表。
		*/
		__getset(1,ResourceManager,'sortedResourceManagersByName',function(){
			if (!ResourceManager._isResourceManagersSorted){
				ResourceManager._isResourceManagersSorted=true;
				ResourceManager._resourceManagers.sort(ResourceManager.compareResourceManagersByName);
			}
			return ResourceManager._resourceManagers;
		});

		/**
		*系统资源管理器。
		*/
		__getset(1,ResourceManager,'systemResourceManager',function(){
			(ResourceManager._systemResourceManager===null)&& (ResourceManager._systemResourceManager=new ResourceManager(),ResourceManager._systemResourceManager._name="System Resource Manager");
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

		ResourceManager.compareResourceManagersByName=function(left,right){
			if (left==right)
				return 0;
			var x=left._name;
			var y=right._name;
			if (x==null){
				if (y==null)
					return 0;
				else
				return-1;
				}else {
				if (y==null)
					return 1;
				else {
					var retval=x.localeCompare(y);
					if (retval !=0)
						return retval;
					else {
						right.setUniqueName(y);
						y=right._name;
						return x.localeCompare(y);
					}
				}
			}
		}

		ResourceManager._uniqueIDCounter=0;
		ResourceManager._systemResourceManager=null
		ResourceManager._isResourceManagersSorted=false;
		ResourceManager._resourceManagers=[];
		ResourceManager.currentResourceManager=null
		return ResourceManager;
	})()


	/**
	*@private
	*/
	//class laya.system.System
	var System=(function(){
		function System(){};
		__class(System,'laya.system.System');
		System.changeDefinition=function(name,classObj){
			Laya[name]=classObj;
			var str=name+"=classObj";
			eval(str);
		}

		System.__init__=function(){
			System.isConchApp=window.conch ? true :false;;
			if (System.isConchApp){
				conch.disableConchResManager();
				conch.disableConchAutoRestoreLostedDevice();
			}
		}

		System.isConchApp=false;
		System.FILTER_ACTIONS=[];
		System.createRenderSprite=function(type,next){
			return new RenderSprite(type,next);
		}

		System.createGLTextur=null;
		System.createWebGLContext2D=null;
		System.changeWebGLSize=function(w,h){
		};

		System.createGraphics=function(){
			return new Graphics();
		}

		System.createFilterAction=function(type){
			return new ColorFilterAction();
		}

		System.drawToCanvas=function(sprite,_renderType,canvasWidth,canvasHeight,offsetX,offsetY){
			var canvas=new HTMLCanvas("2D");
			var context=new RenderContext(canvasWidth,canvasHeight,canvas);
			RenderSprite.renders[_renderType]._fun(sprite,context,offsetX,offsetY);
			return canvas;
		}

		System.addToAtlas=null
		System.createParticleTemplate2D=null
		return System;
	})()


	/**
	*<code>LayoutStyle</code> 是一个布局样式类。
	*/
	//class laya.ui.LayoutStyle
	var LayoutStyle=(function(){
		function LayoutStyle(){
			this.enable=false;
			this.top=NaN;
			this.bottom=NaN;
			this.left=NaN;
			this.right=NaN;
			this.centerX=NaN;
			this.centerY=NaN;
		}

		__class(LayoutStyle,'laya.ui.LayoutStyle');
		__static(LayoutStyle,
		['EMPTY',function(){return this.EMPTY=new LayoutStyle();}
		]);
		return LayoutStyle;
	})()


	/**
	*<code>Styles</code> 定义了组件常用的样式属性。
	*/
	//class laya.ui.Styles
	var Styles=(function(){
		function Styles(){};
		__class(Styles,'laya.ui.Styles');
		Styles.labelColor="#000000";
		Styles.buttonStateNum=3;
		Styles.scrollBarMinNum=15;
		Styles.scrollBarDelayTime=500;
		__static(Styles,
		['defaultSizeGrid',function(){return this.defaultSizeGrid=[4,4,4,4,0];},'labelPadding',function(){return this.labelPadding=[2,2,2,2];},'inputLabelPadding',function(){return this.inputLabelPadding=[1,1,1,3];},'buttonLabelColors',function(){return this.buttonLabelColors=["#32556b","#32cc6b","#ff0000","#C0C0C0"];},'comboBoxItemColors',function(){return this.comboBoxItemColors=["#5e95b6","#ffffff","#000000","#8fa4b1","#ffffff"];}
		]);
		return Styles;
	})()


	/**
	*<code>UIUtils</code> 是文本工具集。
	*/
	//class laya.ui.UIUtils
	var UIUtils=(function(){
		function UIUtils(){};
		__class(UIUtils,'laya.ui.UIUtils');
		UIUtils.fillArray=function(arr,str,type){
			var temp=arr.concat();
			if (str){
				var a=str.split(",");
				for (var i=0,n=Math.min(temp.length,a.length);i < n;i++){
					var value=a[i];
					temp[i]=(value=="true" ? true :(value=="false" ? false :value));
					if (type !=null)temp[i]=type(value);
				}
			}
			return temp;
		}

		UIUtils.toColor=function(color){
			var str=color.toString("16");
			while (str.length < 6)str="0"+str;
			return "#"+str;
		}

		UIUtils.gray=function(traget,isGray){
			(isGray===void 0)&& (isGray=true);
			if (isGray){
				UIUtils.addFilter(traget,UIUtils.grayFilter);
				}else {
				UIUtils.clearFilter(traget,ColorFilter);
			}
		}

		UIUtils.addFilter=function(target,filter){
			var filters=target.filters || [];
			filters.push(filter);
			target.filters=filters;
		}

		UIUtils.clearFilter=function(target,filterType){
			var filters=target.filters;
			if (filters !=null && filters.length > 0){
				for (var i=filters.length-1;i >-1;i--){
					var filter=filters[i];
					if (Laya.__typeof(filter,filterType))filters.splice(i,1);
				}
				target.filters=filters;
			}
		}

		__static(UIUtils,
		['grayFilter',function(){return this.grayFilter=new ColorFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0]);}
		]);
		return UIUtils;
	})()


	/**
	*<code>Browser</code> 是浏览器代理类。封装浏览器及原生 js 提供的一些功能。
	*/
	//class laya.utils.Browser
	var Browser=(function(){
		function Browser(){};
		__class(Browser,'laya.utils.Browser');
		/**浏览器可视宽度。*/
		__getset(1,Browser,'clientWidth',function(){
			return Browser.document.body.clientWidth;
		});

		/**浏览器可视高度。*/
		__getset(1,Browser,'clientHeight',function(){
			return Browser.document.body.clientHeight || Browser.document.documentElement.clientHeight;
		});

		/**设备像素比。*/
		__getset(1,Browser,'pixelRatio',function(){
			if (Browser._pixelRatio < 0){
				var ctx=laya.utils.Browser.ctx;
				var backingStore=ctx.backingStorePixelRatio || ctx.webkitBackingStorePixelRatio || ctx.mozBackingStorePixelRatio || ctx.msBackingStorePixelRatio || ctx.oBackingStorePixelRatio || ctx.backingStorePixelRatio || 1;
				Browser._pixelRatio=(laya.utils.Browser.window.devicePixelRatio || 1)/ backingStore;
			}
			return Browser._pixelRatio;
		});

		/**浏览器物理宽度。*/
		__getset(1,Browser,'width',function(){
			return ((Laya.stage && Laya.stage.canvasRotation)? Browser.clientHeight :Browser.clientWidth)*Browser.pixelRatio;
		});

		/**浏览器物理高度。*/
		__getset(1,Browser,'height',function(){
			return ((Laya.stage && Laya.stage.canvasRotation)? Browser.clientWidth :Browser.clientHeight)*Browser.pixelRatio;
		});

		Browser.createElement=function(type){
			return Browser.document.__createElement(type);
		}

		Browser.getElementById=function(type){
			return Browser.document.getElementById(type);
		}

		Browser.removeElement=function(ele){
			if(ele&&ele.parentNode)ele.parentNode.removeChild(ele);
		}

		Browser.now=function(){
			return Date.now();
		}

		Browser.window=null
		Browser.document=null
		Browser.userAgent=navigator.userAgent;
		Browser.u=Browser.userAgent;
		Browser.onIOS=!!Browser.u.match(/\(i[^;]+;(U;)? CPU.+Mac OS X/);
		Browser.onMobile=!!Browser.u.match(/AppleWebKit.*Mobile.*/);
		Browser.onIPhone=Browser.u.indexOf("iPhone")>-1;
		Browser.onIPad=Browser.u.indexOf("iPad")>-1;
		Browser.onAndriod=Browser.u.indexOf('Android')>-1 || Browser.u.indexOf('Adr')>-1;
		Browser.onWP=Browser.u.indexOf("Windows Phone")>-1;
		Browser.onQQBrowser=Browser.u.indexOf("QQBrowser")>-1;
		Browser.onMQQBrowser=Browser.u.indexOf("MQQBrowser")>-1;
		Browser.onWeiXin=Browser.u.indexOf('MicroMessenger')>-1;
		Browser.onPC=!Browser.onMobile;
		Browser.httpProtocol=window.location.protocol=="http:";
		Browser.webAudioOK=false;
		Browser.soundType=null
		Browser._pixelRatio=-1;
		__static(Browser,
		['canvas',function(){return this.canvas=new HTMLCanvas('2D');},'ctx',function(){return this.ctx=Browser.canvas.getContext('2d');}
		]);
		Browser.__init$=function(){
			AudioSound;
			WebAudioSound;
			Browser.window=window;
			Browser.document=window.document;
			Browser.document.__createElement=Browser.document.createElement;
			window.requestAnimationFrame=(function(){return window.requestAnimationFrame || window.webkitRequestAnimationFrame ||window.mozRequestAnimationFrame || window.oRequestAnimationFrame ||function (c){return window.setTimeout(c,1000 / 60);};})();
			var bs=window.document.body.style;bs.margin=0;bs.overflow='hidden';;
			var metas=window.document.getElementsByTagName('meta');;
			if(metas){var i=0,flag=false,content='width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no';;
				while(i<metas.length){var meta=metas[i];if(meta.name=='viewport'){meta.content=content;flag=true;break;}i++;};
				if(!flag){meta=document.createElement('meta');meta.name='viewport',meta.content=content;document.getElementsByTagName('head')[0].appendChild(meta);}};
			Browser.webAudioOK=Browser.window["AudioContext"] || Browser.window["webkitAudioContext"] || Browser.window["mozAudioContext"] ? true :false;
			Browser.soundType=Browser.webAudioOK ? "WEBAUDIOSOUND" :"AUDIOSOUND";
			Sound=Browser.webAudioOK?WebAudioSound:AudioSound;;
		}

		return Browser;
	})()


	/**
	*<code>Color</code> 是一个颜色值处理类。
	*/
	//class laya.utils.Color
	var Color=(function(){
		function Color(str){
			this._color=[];
			//this.strColor=null;
			//this.numColor=0;
			if ((typeof str=='string')){
				this.strColor=str;
				if (str===null)str="#000000";
				str.charAt(0)=='#' && (str=str.substr(1));
				var color=this.numColor=parseInt(str,16);
				var flag=(str.length==8);
				if (flag){
					this._color=[parseInt(str.substr(0,2),16)/ 255,((0x00FF0000 & color)>> 16)/ 255,((0x0000FF00 & color)>> 8)/ 255,(0x000000FF & color)/ 255];
					return;
				}
				}else {
				color=this.numColor=str;
				this.strColor=Utils.toHexColor(color);
			}
			this._color=[((0xFF0000 & color)>> 16)/ 255,((0xFF00 & color)>> 8)/ 255,(0xFF & color)/ 255,1];
			(this._color).__id=++Color._COLODID;
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

		Color.create=function(str){
			var color=Color._SAVE[str+""];
			if (color !=null)return color;
			(Color._SAVE_SIZE < 1000)|| Color._initSaveMap();
			return Color._SAVE[str+""]=new Color(str);
		}

		Color._SAVE={};
		Color._SAVE_SIZE=0;
		Color._COLOR_MAP={"white":'#FFFFFF',"red":'#FF0000',"green":'#00FF00',"blue":'#0000FF',"black":'#000000',"yellow":'#FFFF00','gray':'#AAAAAA'};
		Color._DEFAULT=Color._initDefault();
		Color._COLODID=1;
		return Color;
	})()


	/**
	*<code>Dragging</code> 类是触摸滑动控件。
	*/
	//class laya.utils.Dragging
	var Dragging=(function(){
		function Dragging(){
			//this.target=null;
			this.ratio=0.92;
			this.maxOffset=60;
			//this.area=null;
			//this.hasInertia=false;
			//this.elasticDistance=NaN;
			//this.elasticBackTime=NaN;
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
		*/
		__proto.start=function(target,area,hasInertia,elasticDistance,elasticBackTime,data,disableMouseEvent){
			this.clearTimer();
			this.target=target;
			this.area=area;
			this.hasInertia=hasInertia;
			this.elasticDistance=elasticDistance;
			this.elasticBackTime=elasticBackTime;
			this.data=data;
			this._disableMouseEvent=disableMouseEvent;
			this._clickOnly=true;
			this._dragging=true;
			this._elasticRateX=this._elasticRateY=1;
			this._lastX=Laya.stage.mouseX;
			this._lastY=Laya.stage.mouseY;
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
			var mouseX=Laya.stage.mouseX;
			var mouseY=Laya.stage.mouseY;
			var offsetX=mouseX-this._lastX;
			var offsetY=mouseY-this._lastY;
			if (this._clickOnly){
				if (Math.abs(offsetX *Laya.stage._canvasTransform.getScaleX())> 1 || Math.abs(offsetY *Laya.stage._canvasTransform.getScaleY())> 1){
					this._clickOnly=false;
					this._offsets || (this._offsets=[]);
					this._offsets.length=0;
					this.target.event("dragstart",this.data);
					MouseManager.instance.disableMouseEvent=this._disableMouseEvent;
					this.target["$_MOUSEDOWN"]=false;
				}else return;
				}else {
				this._offsets.push(offsetX,offsetY);
				this._lastX=mouseX;
				this._lastY=mouseY;
			}
			if (offsetX===0 && offsetY===0)return;
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
				if (this.target.x < this.area.x){
					var offsetX=this.area.x-this.target.x;
					}else if (this.target.x > this.area.x+this.area.width){
					offsetX=this.target.x-this.area.x-this.area.width;
					}else {
					offsetX=0;
				}
				this._elasticRateX=Math.max(0,1-(offsetX / this.elasticDistance));
				if (this.target.y < this.area.y){
					var offsetY=this.area.y-this.target.y;
					}else if (this.target.y > this.area.y+this.area.height){
					offsetY=this.target.y-this.area.y-this.area.height;
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
			this.target.x=Math.min(Math.max(this.target.x,this.area.x),this.area.x+this.area.width);
			this.target.y=Math.min(Math.max(this.target.y,this.area.y),this.area.y+this.area.height);
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
					this._offsets.push(Laya.stage.mouseX-this._lastX,Laya.stage.mouseY-this._lastY);
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
			else if (this.target.x > this.area.x+this.area.width)tx=this.area.x+this.area.width;
			if (this.target.y < this.area.y)ty=this.area.y;
			else if (this.target.y > this.area.y+this.area.height)ty=this.area.y+this.area.height;
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
				sp.event("dragend",this.data);
			}
		}

		return Dragging;
	})()


	/**
	*<code>Ease</code> 类定义了缓动函数，以便实现 <code>Tween</code> 动画的缓动效果。
	*/
	//class laya.utils.Ease
	var Ease=(function(){
		function Ease(){};
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

		Ease.QuadIn=function(t,b,c,d){
			return c *(t /=d)*t+b;
		}

		Ease.QuadInOut=function(t,b,c,d){
			if ((t /=d *0.5)< 1)return c *0.5 *t *t+b;
			return-c *0.5 *((--t)*(t-2)-1)+b;
		}

		Ease.QuadOut=function(t,b,c,d){
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


	/**
	*<code>HTMLChar</code> 是一个 HTML 字符类。
	*/
	//class laya.utils.HTMLChar
	var HTMLChar=(function(){
		function HTMLChar(char,w,h,style){
			//this._sprite=null;
			//this._x=NaN;
			//this._y=NaN;
			//this._w=NaN;
			//this._h=NaN;
			//this.isWord=false;
			//this.char=null;
			//this.charNum=NaN;
			//this.style=null;
			this.char=char;
			this.charNum=char.charCodeAt(0);
			this._x=this._y=0;
			this.width=w;
			this.height=h;
			this.style=style;
			this.isWord=!HTMLChar._isWordRegExp.test(char);
		}

		__class(HTMLChar,'laya.utils.HTMLChar');
		var __proto=HTMLChar.prototype;
		Laya.imps(__proto,{"laya.display.ILayout":true})
		/**
		*设置与此对象绑定的显示对象 <code>Sprite</code> 。
		*@param sprite 显示对象 <code>Sprite</code> 。
		*/
		__proto.setSprite=function(sprite){
			this._sprite=sprite;
		}

		/**
		*获取与此对象绑定的显示对象 <code>Sprite</code>。
		*@return
		*/
		__proto.getSprite=function(){
			return this._sprite;
		}

		/**@private */
		__proto._isChar=function(){
			return true;
		}

		/**@private */
		__proto._getCSSStyle=function(){
			return this.style;
		}

		/**
		*此对象存储的 X 轴坐标值。
		*当设置此值时，如果此对象有绑定的 Sprite 对象，则改变 Sprite 对象的属性 x 的值。
		*/
		__getset(0,__proto,'x',function(){
			return this._x;
			},function(value){
			if (this._sprite){
				this._sprite.x=value;
			}
			this._x=value;
		});

		/**
		*此对象存储的 Y 轴坐标值。
		*当设置此值时，如果此对象有绑定的 Sprite 对象，则改变 Sprite 对象的属性 y 的值。
		*/
		__getset(0,__proto,'y',function(){
			return this._y;
			},function(value){
			if (this._sprite){
				this._sprite.y=value;
			}
			this._y=value;
		});

		/**
		*宽度。
		*/
		__getset(0,__proto,'width',function(){
			return this._w;
			},function(value){
			this._w=value;
		});

		/**
		*高度。
		*/
		__getset(0,__proto,'height',function(){
			return this._h;
			},function(value){
			this._h=value;
		});

		HTMLChar._isWordRegExp=new RegExp("[\\w\.]","");
		return HTMLChar;
	})()


	/**
	*<code>Log</code> 类用于显示日志记录信息。
	*/
	//class laya.utils.Log
	var Log=(function(){
		function Log(){};
		__class(Log,'laya.utils.Log');
		Log.start=function(){
			Log._logdiv=Browser.window.document.createElement('div');
			Browser.window.document.body.appendChild(Log._logdiv);
			Log._logdiv.style.cssText="border:white;overflow:scroll;z-index:1000000;background:rgba(100,100,100,0.7);color:white;position: absolute;left:0px;top:0px;width:100%;height:50%";
			Log._logdiv.onclick=function (){
				if (Laya.__parseInt(this.style.width)==30){
					this.style.width='100%';
					this.style.height="50%";
					this.style.overflow="scroll"
					this.style.background="rgba(100,100,100,0.7)"
					}else {
					this.style.width=this.style.height="30px";
					this.style.overflow="hidden";
					this.style.background="white"
				}
			}
		}

		Log.print=function(value){
			if (!Log._logdiv){
				return;
			}
			Log._logdiv.innerText+=value+"\n";
		}

		Log.enable=function(){
			return Log._logdiv !=null;
		}

		Log._logdiv=null
		return Log;
	})()


	/**
	*<code>Pool</code> 是对象池类，用于对象的存贮、重复使用。
	*/
	//class laya.utils.Pool
	var Pool=(function(){
		/**@private */
		function Pool(){}
		__class(Pool,'laya.utils.Pool');
		Pool.getPoolBySign=function(sign){
			return Pool._poolDic[sign] || (Pool._poolDic[sign]=[]);
		}

		Pool.recover=function(sign,item){
			if (item["__InPool"])return;
			item["__InPool"]=true;
			Pool.getPoolBySign(sign).push(item);
		}

		Pool.getItemByClass=function(sign,clz){
			var pool=Pool.getPoolBySign(sign);
			var rst=pool.length ? pool.pop():new clz();
			rst["__InPool"]=false;
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
			if (rst)rst["__InPool"]=false;
			return rst;
		}

		Pool._poolDic={};
		Pool.InPoolSign="__InPool";
		return Pool;
	})()


	/**
	*<code>Stat</code> 用于显示帧率统计信息。
	*/
	//class laya.utils.Stat
	var Stat=(function(){
		function Stat(){};
		__class(Stat,'laya.utils.Stat');
		/**
		*点击帧频显示区域的处理函数。
		*/
		__getset(1,Stat,'onclick',null,function(fn){
			Stat._canvas.source.onclick=fn;
			Stat._canvas.source.style.pointerEvents='';
		});

		Stat.show=function(x,y){
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			Stat.preFrameTime=Stat._timer=Browser.now()-1000;
			Stat._view[0]={title:"FPS(3D)",value:"_fpsStr",color:"yellow",units:"int"};
			Stat._view[1]={title:"Sprite",value:"spriteDraw",color:"white",units:"int"};
			Stat._view[2]={title:"DrawCall",value:"drawCall",color:"white",units:"int"};
			Stat._view[3]={title:"Canvas",value:"_canvasStr",color:"white",units:"int"};
			Stat._view[4]={title:"Shader",value:"shaderCall",color:"white",units:"int"};
			if (!Render.isWebGl){
				Stat._view[0].title="FPS(2D)";
				Stat._view.length=4;
			}
			for (var i=0;i < Stat._view.length;i++){
				Stat._view[i].x=4;
				Stat._view[i].y=i *12+2;
			}
			Stat._height=Stat._view.length *12+4;
			if (!Stat._canvas){
				Stat._canvas=new HTMLCanvas('2D');
				Stat._canvas.size(Stat._width,Stat._height);
				Stat._ctx=Stat._canvas.getContext('2d');
				Stat._ctx.textBaseline="top";
				var canvas=Stat._canvas.source;
				canvas.style.cssText="pointer-events:none;z-index:100000;position: absolute;left:"+x+"px;top:"+y+"px;width:"+Stat._width+"px;height:"+Stat._height+"px;";
			}
			Laya.timer.frameLoop(1,Stat,Stat.loop);
			Browser.document.body.appendChild(Stat._canvas.source);
		}

		Stat.hide=function(){
			var canvas=Stat._canvas.source;
			Browser.removeElement(canvas);
			Laya.timer.clear(Stat,Stat.loop);
		}

		Stat.clear=function(){
			Stat.trianglesFaces=0;
			Stat.drawCall=0;
			Stat.shaderCall=0;
			Stat.spriteDraw=-1;
			Stat.bufferLen=0;
			Stat.canvasNormal=0;
			Stat.canvasBitmap=0;
			Stat.canvasReCache=0;
		}

		Stat.loop=function(){
			Stat._count++;
			var timer=Browser.now();
			Stat.interval=Browser.now()-Stat.preFrameTime;
			Stat.preFrameTime=timer;
			if (timer-Stat._timer < 1000){
				Stat.clear();
				return;
			}
			Stat._count=Math.round((Stat._count *1000)/ (timer-Stat._timer));
			Stat.maxMemorySize=ResourceManager.systemResourceManager.autoReleaseMaxSize;
			Stat.currentMemorySize=ResourceManager.systemResourceManager.memorySize;
			Stat.texturesMemSize=0;
			Stat.buffersMemSize=0;
			for (var i=0;i < Resource.getLoadedResourcesCount();i++){
				var resource=Resource.getLoadedResourceByIndex(i);
				if (((resource instanceof laya.resource.Bitmap )))
					Stat.texturesMemSize+=resource.memorySize;
			}
			Stat.FPS=Stat._count;
			Stat._fpsStr=Stat._count+(Stat.renderSlow ? " slow" :"");
			Stat._canvasStr=Stat.canvasReCache+"/"+Stat.canvasNormal+"/"+Stat.canvasBitmap;
			var ctx=Stat._ctx;
			ctx.clearRect(0,0,Stat._width,Stat._height);
			ctx.fillStyle="rgba(50,50,60,0.8)";
			ctx.fillRect(0,0,Stat._width,Stat._height);
			for (i=0;i < Stat._view.length;i++){
				var one=Stat._view[i];
				ctx.fillStyle="white";
				ctx.fillText(one.title,one.x,one.y);
				ctx.fillStyle=one.color;
				var value=Stat[one.value];
				(one.units=="M")&& (value=Math.floor(value / (1024 *1024)*100)/ 100+" M");
				ctx.fillText(value+"",one.x+60,one.y);
			}
			Stat._count=0;
			Stat._timer=timer;
			Stat.clear();
		}

		Stat.loopCount=0;
		Stat.maxMemorySize=0;
		Stat.currentMemorySize=0;
		Stat.texturesMemSize=0;
		Stat.buffersMemSize=0;
		Stat.shaderCall=0;
		Stat.drawCall=0;
		Stat.trianglesFaces=0;
		Stat.spriteDraw=0;
		Stat.FPS=0;
		Stat.canvasNormal=0;
		Stat.canvasBitmap=0;
		Stat.canvasReCache=0;
		Stat.interval=0;
		Stat.preFrameTime=0;
		Stat.bufferLen=0;
		Stat.renderSlow=false;
		Stat._fpsStr=null
		Stat._canvasStr=null
		Stat._canvas=null
		Stat._ctx=null
		Stat._timer=NaN
		Stat._count=0;
		Stat._width=120;
		Stat._height=100;
		Stat._view=[];
		return Stat;
	})()


	/**
	*<code>Timer</code> 是时钟管理类。它是一个单例，可以通过 Laya.timer 访问。
	*/
	//class laya.utils.Timer
	var Timer=(function(){
		var TimerHandler;
		function Timer(){
			this.scale=1;
			this.currFrame=0;
			this._mid=1;
			this._map=[];
			this._laters=[];
			this._handlers=[];
			this._temp=[];
			this._pool=[];
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
			var now=Browser.now()
			Timer.DELTA=now-this._lastTimer;
			var timer=this.currTimer=this.currTimer+Timer.DELTA *this.scale;
			this._lastTimer=now;
			var handlers=this._handlers;
			this._count=0;
			for (i=0,n=handlers.length;i < n;i++){
				handler=handlers[i];
				if (handler.method!==null){
					var t=handler.userFrame ? frame :timer;
					if (t >=handler.exeTime){
						if (handler.repeat){
							if (t > handler.exeTime){
								handler.exeTime+=handler.delay;
								handler.run(false);
								if (t >=handler.exeTime){
									handler.exeTime+=Math.ceil((t-handler.exeTime)/ handler.delay)*handler.delay;
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
				handler.method!==null && handler.run(false);
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
			this._temp=handlers;
			this._temp.length=0;
		}

		/**@private */
		__proto._recoverHandler=function(handler){
			handler.clear();
			this._map[handler.key]=null;
			this._pool.push(handler);
		}

		/**@private */
		__proto._create=function(useFrame,repeat,delay,caller,method,args,coverBefore){
			if (!delay){
				method.apply(caller,args);
				return;
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
					handler.exeTime=delay+(useFrame ? this.currFrame :this.currTimer);
					return;
				}
			}
			handler=this._pool.length > 0 ? this._pool.pop():new TimerHandler();
			handler.repeat=repeat;
			handler.userFrame=useFrame;
			handler.delay=delay;
			handler.caller=caller;
			handler.method=method;
			handler.args=args;
			handler.exeTime=delay+(useFrame ? this.currFrame :this.currTimer);
			this._indexHandler(handler);
			this._handlers.push(handler);
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
		*/
		__proto.loop=function(delay,caller,method,args,coverBefore){
			(coverBefore===void 0)&& (coverBefore=true);
			this._create(false,true,delay,caller,method,args,coverBefore);
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
			return "callLater:"+this._laters.length+" handlers:"+this._handlers.length+" pool:"+this._pool.length;
		}

		/**
		*清理定时器。
		*@param caller 执行域(this)。
		*@param method 定时器回调函数。
		*/
		__proto.clear=function(caller,method){
			var handler=this._getHandler(caller,method);
			if (handler){
				this._map[handler.key]=null;
				handler.key=0;
				handler.clear();
			}
		}

		/**
		*清理对象身上的所有定时器。
		*@param caller 执行域(this)。
		*/
		__proto.clearAll=function(caller){
			for (var i=0,n=this._handlers.length;i < n;i++){
				var handler=this._handlers[i];
				if (handler.caller===caller){
					this._map[handler.key]=null;
					handler.key=0;
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
				if (this._pool.length)
					var handler=this._pool.pop();
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
				handler.run(true);
				this._map[handler.key]=null;
			}
		}

		Timer.DELTA=0;
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
				}
				__class(TimerHandler,'');
				var __proto=TimerHandler.prototype;
				__proto.clear=function(){
					this.caller=null;
					this.method=null;
					this.args=null;
				}
				__proto.run=function(widthClear){
					var caller=this.caller;
					if (caller && caller.destroyed)return this.clear();
					var method=this.method;
					var args=this.args;
					widthClear && this.clear();
					if (method==null)return;
					args ? method.apply(caller,args):method.call(caller);
				}
				return TimerHandler;
			})()
		}

		return Timer;
	})()


	/**
	*<code>Tween</code> 是一个缓动类。使用实现目标对象属性的渐变。
	*/
	//class laya.utils.Tween
	var Tween=(function(){
		function Tween(){
			//this._complete=null;
			//this._target=null;
			//this._ease=null;
			//this._props=null;
			//this._duration=0;
			//this._delay=0;
			//this._startTimer=0;
			//this._usedTimer=0;
			//this._usedPool=false;
			this.gid=0;
		}

		__class(Tween,'laya.utils.Tween');
		var __proto=Tween.prototype;
		/**
		*缓动对象的props属性到目标值。
		*@param target 目标对象(即将更改属性值的对象)。
		*@param props 变化的属性列表，比如{x:100,y:20}。
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
		*@param props 变化的属性列表，比如{x:100,y:20}。
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
			this._ease=ease || Tween.easeNone;
			this._complete=complete;
			this._delay=delay;
			this._props=[];
			this._usedTimer=0;
			this._startTimer=Browser.now();
			this._usedPool=usePool;
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
			this._initProps(target,props,isTo);
			this._beginLoop();
		}

		__proto._initProps=function(target,props,isTo){
			for (var p in props){
				if ((typeof (target[p])=='number')){
					var start=isTo ? target[p] :props[p];
					var end=isTo ? props[p] :target[p];
					this._props.push([p,start,end-start]);
				}
			}
		}

		__proto._beginLoop=function(){
			Laya.timer.frameLoop(1,this,this._doEase);
		}

		/**执行缓动**/
		__proto._doEase=function(){
			this.updateEase(Browser.now());
		}

		__proto.updateEase=function(time){
			var target=this._target;
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
		}

		/**
		*立即结束缓动并到终点。
		*/
		__proto.complete=function(){
			if (!this._target)return;
			var target=this._target;
			var props=this._props;
			var handler=this._complete;
			this.clear();
			for (var i=0,n=props.length;i < n;i++){
				var prop=props[i];
				target[prop[0]]=prop[1]+prop[2];
			}
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

		Tween.tweenMap={};
		return Tween;
	})()


	/**
	*<code>Utils</code> 是工具类。
	*/
	//class laya.utils.Utils
	var Utils=(function(){
		function Utils(){};
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
			rst=(new DOMParser()).parseFromString(value,'text/xml');
			return rst;
		}

		Utils.preFixNumber=function(num,strLen){
			return ("0000000000"+num).slice(-strLen);
		}

		Utils.concatArr=function(src,a){
			if (!a)return src;
			if (!src)return a;
			var i=0,len=a.length;
			for (i=0;i < len;i++){
				src.push(a[i]);
			}
			return src;
		}

		Utils.clearArr=function(arr){
			if (!arr)return arr;
			arr.length=0;
			return arr;
		}

		Utils.setValueArr=function(src,v){
			src || (src=[]);
			src.length=0;
			return Utils.concatArr(src,v);
		}

		Utils.getFrom=function(rst,src,count){
			var i=0;
			for (i=0;i < count;i++){
				rst.push(src[i]);
			}
			return rst;
		}

		Utils.getFromR=function(rst,src,count){
			var i=0;
			for (i=0;i < count;i++){
				rst.push(src.pop());
			}
			return rst;
		}

		Utils.getGlobalRec=function(sprite){
			return Utils.getGlobalRecByPoints(sprite,0,0,sprite.width,sprite.height);
		}

		Utils.getGlobalRecByPoints=function(sprite,x0,y0,x1,y1){
			var newLTPoint;
			newLTPoint=new Point(x0,y0);
			newLTPoint=sprite.localToGlobal(newLTPoint);
			var newRBPoint;
			newRBPoint=new Point(x1,y1);
			newRBPoint=sprite.localToGlobal(newRBPoint);
			var rst;
			rst=Rectangle._getWrapRec([newLTPoint.x,newLTPoint.y,newRBPoint.x,newRBPoint.y]);
			return rst;
		}

		Utils.getGlobalPosAndScale=function(sprite){
			return Utils.getGlobalRecByPoints(sprite,0,0,1,1);
		}

		Utils.enableDisplayTree=function(dis){
			while (dis){
				dis.mouseEnabled=true;
				dis=dis.parent;
			}
		}

		Utils.bind=function(fun,_scope){
			var rst;
			rst=fun.bind(_scope);;
			return rst;
		}

		Utils.copyFunction=function(src,dec,permitOverrides){
			for (var i in src){
				if (!permitOverrides && dec[i])continue ;
				dec[i]=src[i];
			}
		}

		Utils.measureText=function(txt,font){
			if (Utils._charSizeTestDiv==null){
				Utils._charSizeTestDiv=Browser.createElement('div');
				Utils._charSizeTestDiv.style.cssText="z-index:10000000;padding:0px;position: absolute;left:0px;visibility:hidden;top:0px;background:white";
				Browser.document.body.appendChild(Utils._charSizeTestDiv);
			}
			Utils._charSizeTestDiv.style.font=font;
			Utils._charSizeTestDiv.innerText=txt==" " ? "i" :txt;
			var out={width:Utils._charSizeTestDiv.offsetWidth,height:Utils._charSizeTestDiv.offsetHeight};
			return out;
		}

		Utils.regClass=function(className,fullClassName){
			Utils._systemClass[className]=fullClassName;
		}

		Utils.New=function(className){
			className=Utils._systemClass[className] || className;
			return new Laya.__classmap[className];
		}

		Utils.updateOrder=function(childs){
			if (childs.length < 2)return false;
			var c=childs[0];
			var i=1,sz=childs.length;
			var z=c._zOrder,low=NaN,high=NaN,mid=NaN,zz=NaN;
			var repaint=false;
			for (i=1;i < sz;i++){
				c=childs [i];
				if (!c)continue ;
				if ((z=c._zOrder)< 0)z=c._zOrder;
				if (z < childs[i-1]._zOrder){
					mid=low=0;
					high=i-1;
					while (low <=high){
						mid=(low+high)>>> 1;
						if (!childs[mid])break ;
						zz=childs[mid]._zOrder;
						if (zz < 0)zz=childs[mid]._zOrder;
						if (zz < z)
							low=mid+1;
						else if (zz > z)
						high=mid-1;
						else break ;
					}
					if (z > childs[mid]._zOrder)mid++;
					childs.splice(i,1);
					childs.splice(mid,0,c);
					repaint=true;
				}
			}
			return repaint;
		}

		Utils.attachAllClassTimeDelay=function(timeout,exclude){
			Utils._attachAllClassTimeDelay=timeout;
			var __classmap=Laya["__classmap"];
			var excludes=((exclude ? exclude.join('%'):"")+"%Laya%laya.ui.%laya.utils.Log%laya2.display%laya.utils2%laya.asyn%laya.display.css%laya.maths%laya.utils").split("%");
			var j=0,excludelen=excludes.length;
			for (var i in __classmap){
				if (i.indexOf('.')< 0)continue ;
				for (j=0;j < excludelen;j++){
					if (i.indexOf(excludes[j])==0){
						j=-1;
						break ;
					}
				}
				if (j > 0)Utils.attachClassTimeDelay(__classmap[i],i,timeout);
			}
		}

		Utils.transPointList=function(pList,x,y){
			var i=0,len=pList.length;
			for (i=0;i < len;i+=2){
				pList[i]+=x;
				pList[i+1]+=y;
			}
		}

		Utils.attachClassTimeDelay=function(_class,className,timeout){
			var i;
			var pre;
			for (i in _class){
				if (_class['_$GET_'+i] !=null || i.charAt(0)=='_')continue ;
				pre=_class[i];
				if (((typeof pre=='function'))){
					_class[i]=function (_class,className,protoName,pre,timeout){
						return function (){
							var tm=Browser.now();
							var r=pre.apply(_class,arguments);
							if ((Browser.now()-tm)> timeout)Log.print("static prototype delay: "+className+"."+protoName+" "+(Browser.now()-tm));
							return r;
						}
					}(_class,className,i,pre,timeout);
				}
			};
			var __proto=_class.prototype;
			for (i in __proto){
				if (__proto['_$get_'+i] !=null || i.charAt(0)=='_')continue ;
				pre=__proto[i];
				if (((typeof pre=='function'))&& !pre.__ISCHECK){
					pre.__ISCHECK=true;
					__proto[i]=function (_class,className,protoName,pre,timeout){
						return function (){
							var tm=Browser.now();
							var r=pre.apply(this,arguments);
							if ((Browser.now()-tm)> timeout)Log.print("prototype delay:"+className+"."+protoName+" "+(Browser.now()-tm));
							return r;
						}
					}(_class,className,i,pre,timeout);
					__proto[i].__ISCHECK=true;
				}
			}
		}

		Utils._gid=1;
		Utils._pi=180 / Math.PI;
		Utils._pi2=Math.PI / 180;
		Utils._charSizeTestDiv=null
		Utils._systemClass={'Sprite':'laya.display.Sprite','Sprite3D':'laya.d3.display.Sprite3D','Mesh':'laya.d3.display.Mesh','Sky':'laya.d3.display.Sky','div':'laya.html.dom.HTMLDivElement','img':'laya.html.dom.HTMLImageElement','span':'laya.html.dom.HTMLElement','br':'laya.html.dom.HTMLBrElement','style':'laya.html.dom.HTMLStyleElement','font':'laya.html.dom.HTMLElement','a':'laya.html.dom.HTMLElement','#text':'laya.html.dom.HTMLElement'};
		Utils._attachAllClassTimeDelay=-1;
		return Utils;
	})()


	/**全局配置*/
	//class UIConfig
	var UIConfig=(function(){
		function UIConfig(){};
		__class(UIConfig,'UIConfig');
		UIConfig.resPath="";
		UIConfig.uiPath="";
		UIConfig.touchScrollEnable=true;
		UIConfig.mouseWheelEnable=true;
		UIConfig.showButtons=true;
		UIConfig.popupBgColor="#000000";
		UIConfig.popupBgAlpha=0.5;
		return UIConfig;
	})()


	/**
	*<code>Node</code> 类用于创建节点对象，节点是最基本的元素。
	*/
	//class laya.display.Node extends laya.events.EventDispatcher
	var Node=(function(_super){
		function Node(){
			this.name="";
			this.destroyed=false;
			this._displayInStage=false;
			this._parent=null;
			this._privates=null;
			Node.__super.call(this);
			this._childs=Node.ARRAY_EMPTY;
			this.timer=Laya.timer;
		}

		__class(Node,'laya.display.Node',_super);
		var __proto=Node.prototype;
		/**
		*<p>销毁此对象。</p>
		*@param destroyChild 是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
		*/
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			this.destroyed=true;
			this._parent && this._parent.removeChild(this);
			if (this._childs){
				if (destroyChild)this.destroyChildren();
				else this.removeChildren();
			}
			this._childs=null;
			this._privates && (this._privates=null);
			this.offAll();
		}

		/**
		*销毁所有子对象，不销毁自己本身。
		*/
		__proto.destroyChildren=function(){
			if (this._childs){
				for (var i=this._childs.length-1;i >-1;i--){
					this._childs[i].destroy(true);
				}
			}
		}

		/**
		*添加子节点。
		*@param node 节点对象
		*@return 返回添加的节点
		*/
		__proto.addChild=function(node){
			if (node===this)return node;
			if (node._parent===this){
				this._childs.splice(this.getChildIndex(node),1);
				this._childs.push(node);
				this.childChanged();
				}else {
				node.parent && node.parent.removeChild(node);
				this._childs===Node.ARRAY_EMPTY && (this._childs=[]);
				this._childs.push(node);
				node.parent=this;
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
			if (node===this)return node;
			if (index >=0 && index <=this._childs.length){
				if (node._parent===this){
					this._childs.splice(this.getChildIndex(node),1);
					this._childs.splice(index,0,node);
					this.childChanged();
					}else {
					node.parent && node.parent.removeChild(node);
					this._childs===Node.ARRAY_EMPTY && (this._childs=[]);
					this._childs.splice(index,0,node);
					node.parent=this;
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
			return this._childs.indexOf(node);
		}

		/**
		*根据子节点的名字，获取子节点对象。
		*@param name 子节点的名字。
		*@return 节点对象。
		*/
		__proto.getChildByName=function(name){
			var nodes=this._childs;
			for (var i=0,n=nodes.length;i < n;i++){
				var node=nodes[i];
				if (node.name===name)return node;
			}
			return null;
		}

		/**@private */
		__proto.getPrivates=function(){
			return this._privates;
		}

		/**
		*根据子节点的索引位置，获取子节点对象。
		*@param index 索引位置
		*@return 子节点
		*/
		__proto.getChildAt=function(index){
			return this._childs[index];
		}

		/**
		*设置子节点的索引位置。
		*@param node 子节点。
		*@param index 新的索引。
		*@return 返回子节点本身。
		*/
		__proto.setChildIndex=function(node,index){
			var childs=this._childs;
			if (index < 0 || index >=childs.length){
				throw new Error("setChildIndex:The index is out of bounds.");
			};
			var oldIndex=this.getChildIndex(node);
			childs.splice(oldIndex,1);
			childs.splice(index,0,node);
			this.childChanged();
			return node;
		}

		/**
		*子节点发生改变。
		*@param child 子节点。
		*/
		__proto.childChanged=function(child){}
		/**
		*删除子节点。
		*@param node 子节点
		*@return 被删除的节点
		*/
		__proto.removeChild=function(node){
			if (!this._childs)return node;
			var index=this._childs.indexOf(node);
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
				this._childs.splice(index,1);
				node.parent=null;
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
			if (this._childs.length > 0){
				var childs=this._childs;
				if (beginIndex===0 && endIndex >=n){
					var arr=childs;
					this._childs=Node.ARRAY_EMPTY;
					}else {
					arr=childs.splice(beginIndex,endIndex-beginIndex);
				}
				for (var i=0,n=arr.length;i < n;i++){
					arr[i].parent=null;
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
			var index=this._childs.indexOf(oldNode);
			if (index >-1){
				this._childs.splice(index,1,newNode);
				oldNode.parent=null;
				newNode.parent=this;
				return newNode;
			}
			return null;
		}

		/**@private */
		__proto._setDisplay=function(value){
			if (this._displayInStage!==value){
				this._displayInStage=value;
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
			node._setDisplay(display);
			var childs=node._childs;
			if (childs){
				for (var i=childs.length-1;i >-1;i--){
					var child=childs[i];
					child._setDisplay(display);
					child.numChildren && this._displayChild(child,display);
				}
			}
		}

		/**
		*询问是否为某类型的某值。
		*<p>常用来对对象类型进行快速判断。</p>
		*@param type 类型。
		*@param value 数值。
		*@return 如果类型和值检测都相等则值为 ture，否则值为 false。
		*/
		__proto.ask=function(type,value){
			return type==1 ? (value==1):false;
		}

		/**
		*当前容器是否包含 <code>node</code> 节点。
		*@param node 某一个节点 <code>Node</code>。
		*@return 一个布尔值表示是否包含<code>node</code>节点。
		*/
		__proto.contains=function(node){
			if (node===this)return true;
			while (node){
				if (node.parent===this.parent)return true;
				node=node.parent;
			}
			return false;
		}

		/**
		*定时重复执行某函数。
		*@param delay 间隔时间(单位毫秒)。
		*@param caller 执行域(this)。
		*@param method 结束时的回调方法。
		*@param args 回调参数。
		*@param coverBefore 是否覆盖之前的延迟执行，默认为true。
		*/
		__proto.timerLoop=function(delay,caller,method,args,coverBefore){
			(coverBefore===void 0)&& (coverBefore=false);
			this.timer._create(false,true,delay,caller,method,args,coverBefore);
		}

		/**
		*定时执行某函数一次。
		*@param delay 延迟时间(单位毫秒)。
		*@param caller 执行域(this)。
		*@param method 结束时的回调方法。
		*@param args 回调参数。
		*@param coverBefore 是否覆盖之前的延迟执行，默认为true。
		*/
		__proto.timerOnce=function(delay,caller,method,args,coverBefore){
			(coverBefore===void 0)&& (coverBefore=false);
			this.timer._create(false,false,delay,caller,method,args,coverBefore);
		}

		/**
		*定时重复执行某函数(基于帧率)。
		*@param delay 间隔几帧(单位为帧)。
		*@param caller 执行域(this)。
		*@param method 结束时的回调方法。
		*@param args 回调参数。
		*@param coverBefore 是否覆盖之前的延迟执行，默认为true。
		*/
		__proto.frameLoop=function(delay,caller,method,args,coverBefore){
			(coverBefore===void 0)&& (coverBefore=false);
			this.timer._create(true,true,delay,caller,method,args,coverBefore);
		}

		/**
		*定时执行一次某函数(基于帧率)。
		*@param delay 延迟几帧(单位为帧)。
		*@param caller 执行域(this)
		*@param method 结束时的回调方法
		*@param args 回调参数
		*@param coverBefore 是否覆盖之前的延迟执行，默认为true
		*/
		__proto.frameOnce=function(delay,caller,method,args,coverBefore){
			(coverBefore===void 0)&& (coverBefore=false);
			this.timer._create(true,false,delay,caller,method,args,coverBefore);
		}

		/**
		*清理定时器。
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
			return this._childs.length;
		});

		/**父节点。*/
		__getset(0,__proto,'parent',function(){
			return this._parent;
			},function(value){
			if (this._parent!==value){
				if (value){
					this._parent=value;
					this.event("added");
					value.displayInStage && this._displayChild(this,true);
					value.childChanged(this);
					}else {
					this.event("removed");
					this._parent.childChanged();
					this._displayChild(this,false);
					this._parent=value;
				}
			}
		});

		/**表示是否在显示列表中显示。是否在显示渲染列表中。*/
		__getset(0,__proto,'displayInStage',function(){
			return this._displayInStage;
		});

		Node.ASK_CLASS=1;
		Node.ASK_VALUE_NODE=1;
		Node.ASK_VALUE_SPRITE=2;
		Node.ASK_VALUE_HTMLELEMENT=3;
		Node.ASK_VALUE_SPRITE3D=100;
		Node.ARRAY_EMPTY=[];
		return Node;
	})(EventDispatcher)


	/**
	*<code>CSSStyle</code> 类是元素CSS样式定义类。
	*/
	//class laya.display.css.CSSStyle extends laya.display.css.Style
	var CSSStyle=(function(_super){
		function CSSStyle(ower){
			this._bgground=null;
			this._border=null;
			//this._ower=null;
			this._rect=null;
			this.lineHeight=0;
			CSSStyle.__super.call(this);
			this._padding=CSSStyle._PADDING;
			this._spacing=CSSStyle._SPACING;
			this._aligns=CSSStyle._ALIGNS;
			this._font=Font.EMPTY;
			this._ower=ower;
		}

		__class(CSSStyle,'laya.display.css.CSSStyle',_super);
		var __proto=CSSStyle.prototype;
		/**@inheritDoc */
		__proto.destroy=function(){
			this._ower=null;
			this._font=null;
			this._rect=null;
		}

		/**
		*复制传入的 CSSStyle 属性值。
		*@param src 待复制的 CSSStyle 对象。
		*/
		__proto.inherit=function(src){
			this._font=src._font;
			this._spacing=src._spacing===CSSStyle._SPACING ? CSSStyle._SPACING :src._spacing.slice();
			this.lineHeight=src.lineHeight;
		}

		/**@private */
		__proto._widthAuto=function(){
			return (this._type & 0x40000)!==0;
		}

		/**@inheritDoc */
		__proto.widthed=function(sprite){
			return (this._type & 0x8)!=0;
		}

		__proto._calculation=function(type,value){
			if (value.indexOf('%')< 0)return false;
			var ower=this._ower;
			var parent=ower.parent;
			var rect=this._rect;
			function getValue (pw,w,nums){
				return (pw *nums[0]+w *nums[1]+nums[2]);
			}
			function onParentResize (type){
				var pw=parent.width,w=ower.width;
				rect.width && (ower.width=getValue(pw,w,rect.width));
				rect.height && (ower.height=getValue(pw,w,rect.height));
				rect.left && (ower.x=getValue(pw,w,rect.left));
				rect.top && (ower.y=getValue(pw,w,rect.top));
			}
			if (rect===null){
				parent._getCSSStyle()._type |=0x80000;
				parent.on("resize",this,onParentResize);
				this._rect=rect={input:{}};
			};
			var nums=value.split(' ');
			nums[0]=parseFloat(nums[0])/ 100;
			if (nums.length==1)
				nums[1]=nums[2]=0;
			else {
				nums[1]=parseFloat(nums[1])/ 100;
				nums[2]=parseFloat(nums[2]);
			}
			rect[type]=nums;
			rect.input[type]=value;
			onParentResize(type);
			return true;
		}

		/**
		*是否已设置高度。
		*@param sprite 显示对象 Sprite。
		*@return 一个Boolean 表示是否已设置高度。
		*/
		__proto.heighted=function(sprite){
			return (this._type & 0x2000)!=0;
		}

		/**
		*设置宽高。
		*@param w 宽度。
		*@param h 高度。
		*/
		__proto.size=function(w,h){
			var ower=this._ower;
			var resize=false;
			if (w!==-1 && w !=this._ower.width){
				this._type |=0x8;
				this._ower.width=w;
				resize=true;
			}
			if (h!==-1 && h !=this._ower.height){
				this._type |=0x2000;
				this._ower.height=h;
				resize=true;
			}
			if (resize){
				ower.layoutLater();
				(this._type & 0x80000)&& ower.event("resize",this);
			}
		}

		/**@private */
		__proto._getAlign=function(){
			return this._aligns[0];
		}

		/**@private */
		__proto._getValign=function(){
			return this._aligns[1];
		}

		/**@private */
		__proto._getCssFloat=function(){
			return (this._type & 0x8000)!=0 ? 0x8000 :0;
		}

		__proto._createFont=function(){
			return (this._type & 0x1000)? this._font :(this._type |=0x1000,this._font=new Font(this._font));
		}

		/**@inheritDoc */
		__proto.render=function(sprite,context,x,y){
			var w=sprite.width;
			var h=sprite.height;
			this._bgground && this._bgground.color !=null && context.ctx.fillRect(x,y,w,h,this._bgground.color);
			this._border && this._border.color && context.drawRect(x,y,w,h,this._border.color.strColor,this._border.size);
		}

		/**@inheritDoc */
		__proto.getCSSStyle=function(){
			return this;
		}

		/**
		*设置 CSS 样式字符串。
		*@param text CSS样式字符串。
		*/
		__proto.cssText=function(text){
			this.attrs(CSSStyle.parseOneCSS(text,';'));
		}

		/**
		*根据传入的属性名、属性值列表，设置此对象的属性值。
		*@param attrs 属性名与属性值列表。
		*/
		__proto.attrs=function(attrs){
			if (attrs){
				for (var i=0,n=attrs.length;i < n;i++){
					var attr=attrs[i];
					this[attr[0]]=attr[1];
				}
			}
		}

		/**
		*定义 X 轴、Y 轴移动转换。
		*@param x X 轴平移量。
		*@param y Y 轴平移量。
		*/
		__proto.translate=function(x,y){
			this._tf===Style._TF_EMPTY && (this._tf=Style._createTransform());
			this._tf.translateX=x;
			this._tf.translateY=y;
		}

		/**
		*定义 缩放转换。
		*@param x X 轴缩放值。
		*@param y Y 轴缩放值。
		*/
		__proto.scale=function(x,y){
			this._tf===Style._TF_EMPTY && (this._tf=Style._createTransform());
			this._tf.scaleX=x;
			this._tf.scaleY=y;
		}

		/**@private */
		__proto._enableLayout=function(){
			return (this._type & 0x2)===0 && (this._type & 0x4)===0;
		}

		/**
		*水平对齐方式。
		*/
		__getset(0,__proto,'align',function(){
			return CSSStyle._aligndef[this._aligns[0]];
			},function(value){
			this._aligns===CSSStyle._ALIGNS && (this._aligns=[0,0,0]);
			this._aligns[0]=CSSStyle._aligndef[value];
		});

		/**@inheritDoc */
		__getset(0,__proto,'paddingTop',function(){
			return this.padding[0];
		});

		/**
		*是否显示为块级元素。
		*/
		__getset(0,__proto,'block',_super.prototype._$get_block,function(value){
			value ? (this._type |=0x1):(this._type &=(~0x1));
		});

		/**
		*边距信息。
		*/
		__getset(0,__proto,'padding',function(){
			return this._padding;
			},function(value){
			this._padding=value;
		});

		/**
		*宽度。
		*/
		__getset(0,__proto,'width',null,function(w){
			this._type |=0x8;
			if ((typeof w=='string')){
				var offset=w.indexOf('auto');
				if (offset >=0){
					this._type |=0x40000;
					w=w.substr(0,offset);
				}
				if (this._calculation("width",w))return;
				w=Laya.__parseInt(w);
			}
			this.size(w,-1);
		});

		/**
		*高度。
		*/
		__getset(0,__proto,'height',null,function(h){
			this._type |=0x2000;
			if ((typeof h=='string')){
				if (this._calculation("height",h))return;
				h=Laya.__parseInt(h);
			}
			this.size(-1,h);
		});

		__getset(0,__proto,'_scale',null,function(value){
			this._ower.scale(value[0],value[1]);
		});

		/**
		*浮动方向。
		*/
		__getset(0,__proto,'cssFloat',function(){
			return (this._type & 0x8000)!=0 ? "right" :"left";
			},function(value){
			this.lineElement=false;
			value==="right" ? (this._type |=0x8000):(this._type &=(~0x8000));
		});

		/**
		*字体信息。
		*/
		__getset(0,__proto,'font',function(){
			return this._font.toString();
			},function(value){
			this._createFont().set(value);
		});

		/**
		*是否是行元素。
		*/
		__getset(0,__proto,'lineElement',function(){
			return (this._type & 0x10000)!=0;
			},function(value){
			value ? (this._type |=0x10000):(this._type &=(~0x10000));
		});

		/**
		*垂直对齐方式。
		*/
		__getset(0,__proto,'valign',function(){
			return CSSStyle._valigndef[this._aligns[1]];
			},function(value){
			this._aligns===CSSStyle._ALIGNS && (this._aligns=[0,0,0]);
			this._aligns[1]=CSSStyle._valigndef[value];
		});

		/**
		*边框属性。
		*/
		__getset(0,__proto,'border',function(){
			return this._border ? this._border.value :"";
			},function(value){
			if (value=='none'){
				this._border=null;
				return;
			}
			this._border || (this._border={});
			this._border.value=value;
			var values=value.split(' ');
			this._border.color=Color.create(values[values.length-1]);
			if (values.length==1){
				this._border.size=1;
				this._border.type='solid';
				return;
			};
			var i=0;
			if (values[0].indexOf('px')> 0){
				this._border.size=Laya.__parseInt(values[0]);
				i++;
			}else this._border.size=1;
			this._border.type=values[i];
			this._ower._renderType |=0x80;
		});

		/**
		*行间距。
		*/
		__getset(0,__proto,'leading',function(){
			return this._spacing[1];
			},function(d){
			((typeof d=='string'))&& (d=Laya.__parseInt(d+""));
			this._spacing===CSSStyle._SPACING && (this._spacing=[0,0]);
			this._spacing[1]=d;
		});

		/**
		*表示左边距。
		*/
		__getset(0,__proto,'left',null,function(value){
			var ower=this._ower;
			if (((typeof value=='string'))){
				if (value==="center")
					value="50% -50% 0";
				else if (value==="right")
				value="100% -100% 0";
				if (this._calculation("left",value))return;
				value=Laya.__parseInt(value);
			}
			ower.x=value;
		});

		/**
		*元素的定位类型。
		*/
		__getset(0,__proto,'position',function(){
			return (this._type & 0x4)? "absolute" :"";
			},function(value){
			value=="absolute" ? (this._type |=0x4):(this._type &=~0x4);
		});

		/**
		*表示上边距。
		*/
		__getset(0,__proto,'top',null,function(value){
			var ower=this._ower;
			if (((typeof value=='string'))){
				if (value==="middle")
					value="50% -50% 0";
				else if (value==="bottom")
				value="100% -100% 0";
				if (this._calculation("top",value))return;
				value=Laya.__parseInt(value);
			}
			ower.y=value;
		});

		/**
		*设置如何处理元素内的空白。
		*/
		__getset(0,__proto,'whiteSpace',function(){
			return (this._type & 0x20000)? "nowrap" :"";
			},function(type){
			type==="nowrap" && (this._type |=0x20000);
			type==="none" && (this._type &=~0x20000);
		});

		/**
		*表示是否换行。
		*/
		__getset(0,__proto,'wordWrap',function(){
			return (this._type & 0x20000)===0;
			},function(value){
			value ? (this._type &=~0x20000):(this._type |=0x20000);
		});

		/**
		*表示是否加粗。
		*/
		__getset(0,__proto,'bold',function(){
			return this._font.bold;
			},function(value){
			this._createFont().bold=value;
		});

		/**
		*<p>指定文本字段是否是密码文本字段。</p>
		*如果此属性的值为 true，则文本字段被视为密码文本字段，并使用星号而不是实际字符来隐藏输入的字符。如果为 false，则不会将文本字段视为密码文本字段。
		*/
		__getset(0,__proto,'password',function(){
			return this._font.password;
			},function(value){
			this._createFont().password=value;
		});

		/**
		*文本的粗细。
		*/
		__getset(0,__proto,'weight',null,function(value){
			this._createFont().weight=value;
		});

		/**
		*间距。
		*/
		__getset(0,__proto,'letterSpacing',function(){
			return this._spacing[0];
			},function(d){
			((typeof d=='string'))&& (d=Laya.__parseInt(d+""));
			this._spacing===CSSStyle._SPACING && (this._spacing=[0,0]);
			this._spacing[0]=d;
		});

		/**
		*字体大小。
		*/
		__getset(0,__proto,'fontSize',function(){
			return this._font.size;
			},function(value){
			this._createFont().size=value;
		});

		/**
		*表示是否为斜体。
		*/
		__getset(0,__proto,'italic',function(){
			return this._font.italic;
			},function(value){
			this._createFont().italic=value;
		});

		/**
		*字体系列。
		*/
		__getset(0,__proto,'fontFamily',function(){
			return this._font.family;
			},function(value){
			this._createFont().family=value;
		});

		/**
		*字体粗细。
		*/
		__getset(0,__proto,'fontWeight',function(){
			return this._font.weight;
			},function(value){
			this._createFont().weight=value;
		});

		/**
		*添加到文本的修饰。
		*/
		__getset(0,__proto,'textDecoration',function(){
			return this._font.decoration;
			},function(value){
			this._createFont().decoration=value;
		});

		/**
		*字体颜色。
		*/
		__getset(0,__proto,'color',function(){
			return this._font.color;
			},function(value){
			this._createFont().color=value;
		});

		/**
		*<p>描边颜色，以字符串表示。</p>
		*@default "#000000";
		*/
		__getset(0,__proto,'strokeColor',function(){
			return this._font.stroke[1];
			},function(value){
			if (this._createFont().stroke===Font._STROKE)this._font.stroke=[0,"#000000"];
			this._font.stroke[1]=value;
		});

		/**
		*边框的颜色。
		*/
		__getset(0,__proto,'borderColor',function(){
			return (this._border && this._border.color)? this._border.color.strColor :null;
			},function(value){
			this._border || (this._border={size:1,type:'solid'});
			this._border.color=(value==null)? null :Color.create(value);
			this._ower._renderType |=0x80;
		});

		/**
		*<p>描边宽度（以像素为单位）。</p>
		*默认值0，表示不描边。
		*@default 0
		*/
		__getset(0,__proto,'stroke',function(){
			return this._font.stroke[0];
			},function(value){
			if (this._createFont().stroke===Font._STROKE)this._font.stroke=[0,"#000000"];
			this._font.stroke[0]=value;
		});

		/**
		*背景颜色。
		*/
		__getset(0,__proto,'backgroundColor',function(){
			return this._bgground ? this._bgground.color :"";
			},function(value){
			if (value==='none')this._bgground=null;
			else (this._bgground || (this._bgground={}),this._bgground.color=value);
			this._ower._renderType |=0x80;
		});

		/**@inheritDoc */
		__getset(0,__proto,'absolute',function(){
			return (this._type & 0x4)!==0;
		});

		__getset(0,__proto,'background',null,function(value){
			this._bgground || (this._bgground={});
			this._bgground.color=value;
			this._type |=0x4000;
			this._ower._renderType |=0x80;
		});

		/**@inheritDoc */
		__getset(0,__proto,'paddingLeft',function(){
			return this.padding[3];
		});

		/**
		*规定元素应该生成的框的类型。
		*/
		__getset(0,__proto,'display',null,function(value){
			switch (value){
				case '':
					this._type &=~0x2;
					this.visible=true;
					break ;
				case 'none':
					this._type |=0x2;
					this.visible=false;
					this._ower.layoutLater();
					break ;
				}
		});

		/**@inheritDoc */
		__getset(0,__proto,'transform',_super.prototype._$get_transform,function(value){
			(value==='none')? (this._tf=Style._TF_EMPTY):this.attrs(CSSStyle.parseOneCSS(value,','));
		});

		__getset(0,__proto,'_translate',null,function(value){
			this.translate(value[0],value[1]);
		});

		__getset(0,__proto,'_rotate',null,function(value){
			this._ower.rotation=value;
		});

		CSSStyle.parseOneCSS=function(text,clipWord){
			var out=[];
			var attrs=text.split(clipWord);
			var valueArray;
			for (var i=0,n=attrs.length;i < n;i++){
				var attr=attrs[i];
				var ofs=attr.indexOf(':');
				var name=attr.substr(0,ofs).replace(/^\s+|\s+$/g,'');
				var value=attr.substr(ofs+1).replace(/^\s+|\s+$/g,'');
				var one=[name,value];
				switch (name){
					case 'italic':
					case 'bold':
						one[1]=value=="true";
						break ;
					case 'line-height':
						one[0]='lineHeight';
						one[1]=Laya.__parseInt(value);
						break ;
					case 'font-size':
						one[0]='fontSize';
						one[1]=Laya.__parseInt(value);
						break ;
					case 'padding':
						valueArray=value.split(' ');
						valueArray.length > 1 || (valueArray[1]=valueArray[2]=valueArray[3]=valueArray[0]);
						one[1]=[Laya.__parseInt(valueArray[0]),Laya.__parseInt(valueArray[1]),Laya.__parseInt(valueArray[2]),Laya.__parseInt(valueArray[3])];
						break ;
					case 'rotate':
						one[0]="_rotate";
						one[1]=parseFloat(value);
						break ;
					case 'scale':
						valueArray=value.split(' ');
						one[0]="_scale";
						one[1]=[parseFloat(valueArray[0]),parseFloat(valueArray[1])];
						break ;
					case 'translate':
						valueArray=value.split(' ');
						one[0]="_translate";
						one[1]=[Laya.__parseInt(valueArray[0]),Laya.__parseInt(valueArray[1])];
						break ;
					default :
						(one[0]=CSSStyle._CSSTOVALUE[name])|| (one[0]=name);
					}
				out.push(one);
			}
			return out;
		}

		CSSStyle.parseCSS=function(text,uri){
			var one;
			while ((one=CSSStyle._parseCSSRegExp.exec(text))!=null){
				CSSStyle.styleSheets[one[1]]=CSSStyle.parseOneCSS(one[2],';');
			}
		}

		CSSStyle.EMPTY=new CSSStyle(null);
		CSSStyle._CSSTOVALUE={'letter-spacing':'letterSpacing','line-spacing':'lineSpacing','white-space':'whiteSpace','line-height':'lineHeight','scale-x':'scaleX','scale-y':'scaleY','translate-x':'translateX','translate-y':'translateY','font-family':'fontFamily','font-weight':'fontWeight','vertical-align':'valign','text-decoration':'textDecoration','background-color':'backgroundColor','border-color':'borderColor','float':'cssFloat'};
		CSSStyle._parseCSSRegExp=new RegExp("([\.\#]\\w+)\\s*{([\\s\\S]*?)}","g");
		CSSStyle._aligndef={'left':0,'center':1,'right':2,0:'left',1:'center',2:'right'};
		CSSStyle._valigndef={'top':0,'middle':1,'bottom':2,0:'top',1:'middle',2:'bottom'};
		CSSStyle.styleSheets={};
		CSSStyle.ALIGN_CENTER=1;
		CSSStyle.ALIGN_RIGHT=2;
		CSSStyle.VALIGN_MIDDLE=1;
		CSSStyle.VALIGN_BOTTOM=2;
		CSSStyle._CSS_BLOCK=0x1;
		CSSStyle._DISPLAY_NONE=0x2;
		CSSStyle._ABSOLUTE=0x4;
		CSSStyle._WIDTH_SET=0x8;
		CSSStyle._PADDING=[0,0,0,0];
		CSSStyle._RECT=[-1,-1,-1,-1];
		CSSStyle._SPACING=[0,0];
		CSSStyle._ALIGNS=[0,0,0];
		CSSStyle.ADDLAYOUTED=0x200;
		CSSStyle._NEWFONT=0x1000;
		CSSStyle._HEIGHT_SET=0x2000;
		CSSStyle._BACKGROUND_SET=0x4000;
		CSSStyle._FLOAT_RIGHT=0x8000;
		CSSStyle._LINE_ELEMENT=0x10000;
		CSSStyle._NOWARP=0x20000;
		CSSStyle._WIDTHAUTO=0x40000;
		CSSStyle._LISTERRESZIE=0x80000;
		return CSSStyle;
	})(Style)


	/**
	*<p><code>ColorFilter</code> 是颜色滤镜。</p>
	*/
	//class laya.filters.ColorFilter extends laya.filters.Filter
	var ColorFilter=(function(_super){
		function ColorFilter(mat){
			//this._elements=null;
			ColorFilter.__super.call(this);
			if (!mat){
				this._elements=ColorFilter.DEFAULT._elements;
				return;
			}
			this._elements=new Float32Array(20);
			for (var i=0;i < 20;i++){
				this._elements[i]=mat[i];
			}
			this._action=System.createFilterAction(0x20);
			this._action.data=this;
		}

		__class(ColorFilter,'laya.filters.ColorFilter',_super);
		var __proto=ColorFilter.prototype;
		Laya.imps(__proto,{"laya.filters.IFilter":true})
		/**@inheritDoc */
		__getset(0,__proto,'type',function(){
			return 0x20;
		});

		/**@inheritDoc */
		__getset(0,__proto,'action',function(){
			return this._action;
		});

		__static(ColorFilter,
		['DEFAULT',function(){return this.DEFAULT=new ColorFilter([1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0]);},'GRAY',function(){return this.GRAY=new ColorFilter([0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0]);}
		]);
		return ColorFilter;
	})(Filter)


	/**
	*@private
	*使用Audio标签播放声音
	*/
	//class laya.media.h5audio.AudioSound extends laya.events.EventDispatcher
	var AudioSound=(function(_super){
		function AudioSound(){
			this.url=null;
			this.audio=null;
			this.loaded=false;
			AudioSound.__super.call(this);
		}

		__class(AudioSound,'laya.media.h5audio.AudioSound',_super);
		var __proto=AudioSound.prototype;
		/**
		*释放声音
		*
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
				offs();
				me.event("error");
			}
			function offs (){
				ad.removeEventListener("canplaythrough",onLoaded);
				ad.removeEventListener("error",onErr);
			}
			this.audio=ad;
			ad.load();
		}

		/**
		*播放声音
		*@param startTime 起始时间
		*@param loops 循环次数
		*@return
		*
		*/
		__proto.play=function(startTime,loops){
			(startTime===void 0)&& (startTime=0);
			(loops===void 0)&& (loops=0);
			if (!this.url)return null;
			var ad;
			ad=AudioSound._audioCache[this.url];
			if (!ad)return null;
			ad.autoplay=true;
			var tAd;
			tAd=Pool.getItem("audio:"+this.url);
			tAd=tAd?tAd:ad.cloneNode(true);
			var channel=new AudioSoundChannel(tAd);
			channel.url=this.url;
			channel.loops=loops;
			channel.startTime=startTime;
			channel.play();
			SoundManager.addChannel(channel);
			return channel;
		}

		AudioSound._audioCache={};
		return AudioSound;
	})(EventDispatcher)


	/**
	*<code>SoundChannel</code> 用来控制程序中的声音。
	*/
	//class laya.media.SoundChannel extends laya.events.EventDispatcher
	var SoundChannel=(function(_super){
		function SoundChannel(){
			this.url=null;
			this.loops=0;
			this.startTime=NaN;
			this.isStopped=false;
			this.completeHandler=null;
			SoundChannel.__super.call(this);
		}

		__class(SoundChannel,'laya.media.SoundChannel',_super);
		var __proto=SoundChannel.prototype;
		/**
		*播放。
		*/
		__proto.play=function(){}
		/**
		*停止。
		*/
		__proto.stop=function(){}
		/**
		*音量。
		*/
		__getset(0,__proto,'volume',function(){
			return 1;
			},function(v){
		});

		/**
		*获取当前播放时间。
		*/
		__getset(0,__proto,'position',function(){
			return 0;
		});

		return SoundChannel;
	})(EventDispatcher)


	/**
	*<code>Sound</code> 类是用来播放控制声音的类。
	*/
	//class laya.media.Sound extends laya.events.EventDispatcher
	var Sound=(function(_super){
		function Sound(){Sound.__super.call(this);;
		};

		__class(Sound,'laya.media.Sound',_super);
		var __proto=Sound.prototype;
		/**
		*加载声音。
		*@param url 地址。
		*
		*/
		__proto.load=function(url){}
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
			return null;
		}

		/**
		*释放声音资源。
		*
		*/
		__proto.dispose=function(){}
		return Sound;
	})(EventDispatcher)


	/**
	*@private
	*web audio api方式播放声音
	*/
	//class laya.media.webaudio.WebAudioSound extends laya.events.EventDispatcher
	var WebAudioSound=(function(_super){
		function WebAudioSound(){
			this.url=null;
			this.loaded=false;
			this.data=null;
			this.audioBuffer=null;
			WebAudioSound.__super.call(this);
		}

		__class(WebAudioSound,'laya.media.webaudio.WebAudioSound',_super);
		var __proto=WebAudioSound.prototype;
		/**
		*加载声音
		*@param url
		*
		*/
		__proto.load=function(url){
			var me=this;
			this.url=url;
			this.audioBuffer=WebAudioSound._dataCache[url];
			if (this.audioBuffer){
				_loaded();
				return;
			};
			var request=new Browser.window.XMLHttpRequest();
			request.open("GET",url,true);
			request.responseType="arraybuffer";
			request.onload=function (){
				me.data=request.response;
				WebAudioSound.buffs.push({"buffer":me.data,"loaded":_loaded,"err":_err,"me":me,"url":me.url});
				WebAudioSound.decode();
			};
			request.send();
			function _loaded (){
				WebAudioSound._dataCache[url]=me.audioBuffer;
				me.loaded=true;
				me.event("complete");
			}
			function _err (){
				me.event("error");
			}
		}

		/**
		*播放声音
		*@param startTime 起始时间
		*@param loops 循环次数
		*@return
		*
		*/
		__proto.play=function(startTime,loops,channel){
			(startTime===void 0)&& (startTime=0);
			(loops===void 0)&& (loops=0);
			channel=channel ? channel :new WebAudioSoundChannel();
			if (!this.audioBuffer){
				if (this.url){
					this.once("complete",this,this.play,[startTime,loops,channel]);
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
		}

		WebAudioSound.decode=function(){
			if (WebAudioSound.buffs.length <=0 || WebAudioSound.isDecoding){
				return;
			}
			WebAudioSound.isDecoding=true;
			WebAudioSound.tInfo=WebAudioSound.buffs.shift();
			WebAudioSound.ctx.decodeAudioData(WebAudioSound.tInfo["buffer"],WebAudioSound._done,WebAudioSound._fail);
		}

		WebAudioSound._done=function(audioBuffer){
			WebAudioSound.tInfo["me"].audioBuffer=audioBuffer;
			if (WebAudioSound.tInfo["loaded"]){
				WebAudioSound.tInfo["loaded"]();
			}
			WebAudioSound.isDecoding=false;
			WebAudioSound.decode();
		}

		WebAudioSound._fail=function(){
			if (WebAudioSound.tInfo["err"]){
				WebAudioSound.tInfo["err"]();
			}
			WebAudioSound.isDecoding=false;
			WebAudioSound.decode();
		}

		WebAudioSound._dataCache={};
		WebAudioSound.buffs=[];
		WebAudioSound.isDecoding=false;
		WebAudioSound.tInfo=null
		__static(WebAudioSound,
		['window',function(){return this.window=Browser.window;},'webAudioOK',function(){return this.webAudioOK=WebAudioSound.window["AudioContext"] || WebAudioSound.window["webkitAudioContext"] || WebAudioSound.window["mozAudioContext"];},'ctx',function(){return this.ctx=WebAudioSound.webAudioOK ? new (WebAudioSound.window["AudioContext"] || WebAudioSound.window["webkitAudioContext"] || WebAudioSound.window["mozAudioContext"])():undefined;}
		]);
		return WebAudioSound;
	})(EventDispatcher)


	/**
	*<code>HttpRequest</code> 通过 HTTP 协议传送或接收 XML 及其他数据。
	*/
	//class laya.net.HttpRequest extends laya.events.EventDispatcher
	var HttpRequest=(function(_super){
		function HttpRequest(){
			this._responseType=null;
			this._data=null;
			HttpRequest.__super.call(this);
			this._http=new Browser.window.XMLHttpRequest();
		}

		__class(HttpRequest,'laya.net.HttpRequest',_super);
		var __proto=HttpRequest.prototype;
		/**
		*发送请求。
		*@param url 请求的地址。
		*@param data 发送的数据，可选。
		*@param method 发送数据方式，值为“get”或“post”，默认为 “get”方式。
		*@param responseType 返回消息类型，可设置为"text"，"json"，"xml","arraybuffer"。
		*@param headers 头信息，key value数组，比如["Content-Type","application/json"]。
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
				}else {
				if (!data || (typeof data=='string'))http.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				else http.setRequestHeader("Content-Type","application/json");
			}
			http.responseType=responseType!=="arraybuffer" ? "text" :"arraybuffer";
			http.onerror=function (e){
				_this.onError(e);
			}
			http.onabort=function (e){
				_this.onAbort(e);
			}
			http.onprogress=function (e){
				_this.onProgress(e);
			}
			http.onload=function (e){
				_this.onLoad(e);
			}
			http.send(data);
		}

		/**
		*请求进度的侦听处理函数。
		*@param e 事件对象。
		*/
		__proto.onProgress=function(e){
			if (e && e.lengthComputable)this.event("progress",e.loaded / e.total);
		}

		/**
		*请求中断的侦听处理函数。
		*@param e 事件对象。
		*/
		__proto.onAbort=function(e){
			this.error("Request was aborted by user");
		}

		/**
		*请求出错侦的听处理函数。
		*@param e 事件对象。
		*/
		__proto.onError=function(e){
			this.error("Request failed Status:"+this._http.status+" text:"+this._http.statusText);
		}

		/**
		*请求消息返回的侦听处理函数。
		*@param e 事件对象。
		*/
		__proto.onLoad=function(e){
			var http=this._http;
			var status=http.status!==undefined ? http.status :200;
			if (status===200 || status===204 || status===0){
				this.complete();
				}else {
				this.error("["+http.status+"]"+http.statusText+":"+http.responseURL);
			}
		}

		/**
		*请求错误的处理函数。
		*@param message 错误信息。
		*/
		__proto.error=function(message){
			this.clear();
			this.event("error",message);
		}

		/**
		*请求成功完成的处理函数。
		*/
		__proto.complete=function(){
			this.clear();
			if (this._responseType==="json"){
				this._data=JSON.parse(this._http.responseText);
				}else if (this._responseType==="xml"){
				var dom=new Browser.window.DOMParser();
				this._data=dom.parseFromString(this._http.responseText,"text/xml");
				}else {
				this._data=this._http.response || this._http.responseText;
			}
			this.event("complete",(this._data instanceof Array)? [this._data] :this._data);
		}

		/**
		*清除当前请求。
		*/
		__proto.clear=function(){
			var http=this._http;
			http.onerror=http.onabort=http.onprogress=http.onload=null;
		}

		/**返回的数据。*/
		__getset(0,__proto,'data',function(){
			return this._data;
		});

		/**请求的地址。*/
		__getset(0,__proto,'url',function(){
			return this._http.responseURL;
		});

		return HttpRequest;
	})(EventDispatcher)


	/**
	*<code>Loader</code> 类可用来加载文本、JSON、XML、二进制、图像等资源。
	*/
	//class laya.net.Loader extends laya.events.EventDispatcher
	var Loader=(function(_super){
		function Loader(){
			this._data=null;
			this._url=null;
			this._type=null;
			this._cache=false;
			this._http=null;
			Loader.__super.call(this);
		}

		__class(Loader,'laya.net.Loader',_super);
		var __proto=Loader.prototype;
		/**
		*加载资源。
		*@param url 地址
		*@param type 类型，如果为null，则根据文件后缀，自动分析类型。
		*@param cache 是否缓存数据。
		*/
		__proto.load=function(url,type,cache){
			(cache===void 0)&& (cache=true);
			url=URL.formatURL(url);
			this._url=url;
			this._type=type || (type=this.getTypeFromUrl(url));
			this._cache=cache;
			this._data=null;
			if (Loader.loadedMap[url]){
				this._data=Loader.loadedMap[url];
				this.event("progress",1);
				this.event("complete",this._data);
				return;
			}
			if (type==="image")
				return this._loadImage(url);
			if (type==="sound")
				return this._loadSound(url);
			if (!this._http){
				this._http=new HttpRequest();
				this._http.on("progress",this,this.onProgress);
				this._http.on("error",this,this.onError);
				this._http.on("complete",this,this.onLoaded);
			}
			this._http.send(url,null,"get",type!=="atlas" ? type :"json");
		}

		/**
		*获取指定资源地址的数据类型。
		*@param url 资源地址。
		*@return 数据类型。
		*/
		__proto.getTypeFromUrl=function(url){
			Loader._extReg.lastIndex=url.lastIndexOf(".");
			var result=Loader._extReg.exec(url);
			if (result && result.length > 1){
				return Loader.typeMap[result[1].toLowerCase()];
			}
			console.log("Not recognize the resources suffix",url);
			return "text";
		}

		/**
		*@private
		*加载图片资源。
		*@param url 资源地址。
		*/
		__proto._loadImage=function(url){
			var image=new HTMLImage();
			var _this=this;
			image.onload=function (){
				clear();
				_this.onLoaded(image);
			};
			image.onerror=function (){
				clear();
				_this.event("error","Load image filed");
			}
			function clear (){
				image.onload=null;
				image.onerror=null;
			}
			image.src=url;
		}

		/**
		*@private
		*加载声音资源。
		*@param url 资源地址。
		*/
		__proto._loadSound=function(url){
			var _$this=this;
			var sound=new Sound();
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
				_this.event("error","Load sound filed");
			}
			function clear (){
				sound.off("complete",_$this,soundOnload);
				sound.off("error",_$this,soundOnErr);
			}
		}

		/**@private */
		__proto.onProgress=function(value){
			this.event("progress",value);
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
				this.complete(new Texture(data));
				}else if (type==="sound"){
				this.complete(data);
				}else if (type==="texture"){
				this.complete(new Texture(data));
				}else if (type==="atlas"){
				var toloadPics;
				if (!data.src){
					if (!this._data){
						this._data=data;
						if (data.meta && data.meta.image){
							toloadPics=data.meta.image.split(",");
							var folderPath;
							var split;
							split=this._url.indexOf("/")>=0 ? "/" :"\\";
							var idx=0;
							idx=this._url.lastIndexOf(split);
							if (idx >=0){
								folderPath=this._url.substr(0,idx+1);
								}else {
								folderPath="";
							};
							var i=0,len=0;
							len=toloadPics.length;
							for (i=0;i < len;i++){
								toloadPics[i]=folderPath+toloadPics[i];
							}
							}else{
							toloadPics=[this._url.replace(".json",".png")];
						}
						toloadPics.reverse();
						data.toLoads=toloadPics;
						data.pics=[];
					}
					return this._loadImage(URL.formatURL(toloadPics.pop()));
					}else {
					this._data.pics.push(data);
					if (this._data.toLoads.length > 0){
						return this._loadImage(URL.formatURL(this._data.toLoads.pop()));
					};
					var frames=this._data.frames;
					var directory=(this._data.meta && this._data.meta.prefix)? URL.basePath+this._data.meta.prefix :this._url.substring(0,this._url.lastIndexOf("."))+"/";
					var pics;
					pics=this._data.pics;
					var tPic;
					var map=Loader.atlasMap[this._url] || (Loader.atlasMap[this._url]=[]);
					var needSub=Config.atlasEnable && Render.isWebGl;
					for (var name in frames){
						var obj=frames[name];
						tPic=pics[obj.frame.idx ? obj.frame.idx :0];
						var url=directory+name;
						Loader.loadedMap[url]=Texture.create(tPic,obj.frame.x,obj.frame.y,obj.frame.w,obj.frame.h,obj.spriteSourceSize.x,obj.spriteSourceSize.y);
						map.push(Loader.loadedMap[url]);
					}
					this.complete(this._data);
				}
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
			Loader._loaders.push(this);
			if (!Loader._isWorking)Loader.checkNext();
		}

		/**
		*@private
		*结束加载，派发进度 <code>Event.PROGRESS</code> 和完成事件 <code>Event.COMPLETE</code> 。
		*/
		__proto._endLoad=function(){
			if (this._cache)Loader.loadedMap[this._url]=this._data;
			this.event("progress",1);
			this.event("complete",(this.data instanceof Array)? [this.data] :this.data);
		}

		/**是否缓存。*/
		__getset(0,__proto,'cache',function(){
			return this._cache;
		});

		/**返回的数据。*/
		__getset(0,__proto,'data',function(){
			return this._data;
		});

		/**加载地址。*/
		__getset(0,__proto,'url',function(){
			return this._url;
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
				Loader._loaders[Loader._startIndex]._endLoad();
				Loader._startIndex++;
				if (Browser.now()-startTimer > Loader.maxTimeOut){
					console.log("loader callback cost a long time:"+(Browser.now()-startTimer)+")"+" url="+Loader._loaders[Loader._startIndex-1].url);
					Laya.timer.frameOnce(1,null,Loader.checkNext);
					return;
				}
			}
			Loader._loaders.length=0;
			Loader._startIndex=0;
			Loader._isWorking=false;
		}

		Loader.clearRes=function(url){
			url=URL.formatURL(url);
			var arr=Loader.atlasMap[url];
			if (arr){
				for (var i=0,n=arr.length;i < n;i++){
					var tex=arr[i];
					if (tex)tex.destroy();
				}
				arr.length=0;
				delete Loader.atlasMap[url];
			}
			delete Loader.loadedMap[url];
		}

		Loader.getRes=function(url){
			return Loader.loadedMap[URL.formatURL(url)];
		}

		Loader.getAtlas=function(url){
			return Loader.atlasMap[URL.formatURL(url)];
		}

		Loader.cacheRes=function(url,data){
			Loader.loadedMap[URL.formatURL(url)]=data;
		}

		Loader.basePath="";
		Loader.TEXT="text";
		Loader.JSOn="json";
		Loader.XML="xml";
		Loader.BUFFER="arraybuffer";
		Loader.IMAGE="image";
		Loader.SOUND="sound";
		Loader.TEXTURE="texture";
		Loader.ATLAS="atlas";
		Loader.typeMap={"png":"image","jpg":"image","txt":"text","json":"json","xml":"xml","als":"atlas","mp3":"sound","ogg":"sound","wav":"sound"};
		Loader.loadedMap={};
		Loader.atlasMap={};
		Loader._loaders=[];
		Loader._isWorking=false;
		Loader._startIndex=0;
		Loader.maxTimeOut=100;
		Loader._extReg=/\.(\w+)\??/g;
		return Loader;
	})(EventDispatcher)


	/**
	*<p> <code>LoaderManager</code> 类用于用于批量加载资源、数据。</p>
	*<p>批量加载器，单例，可以通过Laya.loader访问。</p>
	*多线程(默认5个线程)，5个优先级(0最快，4最慢,默认为1)
	*某个资源加载失败后，会按照最低优先级重试加载(属性retryNum决定重试几次)，如果重试后失败，则调用complete函数，并返回null
	*/
	//class laya.net.LoaderManager extends laya.events.EventDispatcher
	var LoaderManager=(function(_super){
		var ResInfo;
		function LoaderManager(){
			this.retryNum=1;
			this.maxLoader=5;
			this._loaders=[];
			this._loaderCount=0;
			this._resInfos=[];
			this._resMap={};
			this._infoPool=[];
			this._maxPriority=5;
			this._failRes={};
			LoaderManager.__super.call(this);
			for (var i=0;i < this._maxPriority;i++)this._resInfos[i]=[];
		}

		__class(LoaderManager,'laya.net.LoaderManager',_super);
		var __proto=LoaderManager.prototype;
		/**
		*加载资源。
		*@param url 地址，或者资源对象数组。
		*@param complete 结束回调，如果加载失败，则返回 null 。
		*@param progress 进度回调，回调参数为当前文件加载的进度信息(0-1)。
		*@param type 资源类型。
		*@param priority 优先级，0-4，五个优先级，0优先级最高，默认为1。
		*@param cache 是否缓存加载结果。
		*@return 此 LoaderManager 对象。
		*/
		__proto.load=function(url,complete,progress,type,priority,cache){
			(priority===void 0)&& (priority=1);
			(cache===void 0)&& (cache=true);
			if ((url instanceof Array))return this._loadAssets(url,complete,progress,cache);
			var content=Loader.getRes(url);
			if (content !=null){
				complete && complete.runWith(content);
				this._loaderCount || this.event("complete");
				}else {
				var info=this._resMap[url];
				if (!info){
					info=this._infoPool.length ? this._infoPool.pop():new ResInfo();
					info.url=url;
					info.type=type;
					info.cache=cache;
					complete && info.on("complete",complete.caller,complete.method,complete.args);
					progress && info.on("progress",progress.caller,progress.method,progress.args);
					this._resMap[url]=info;
					priority=priority < this._maxPriority ? priority :this._maxPriority-1;
					this._resInfos[priority].push(info);
					this._next();
					}else {
					complete && info.on("complete",complete.caller,complete.method,complete.args);
					progress && info.on("progress",progress.caller,progress.method,progress.args);
				}
			}
			return this;
		}

		__proto._next=function(){
			if (this._loaderCount >=this.maxLoader)return;
			for (var i=0;i < this._maxPriority;i++){
				var infos=this._resInfos[i];
				if (infos.length > 0)return this._doLoad(infos.shift())
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
				_this._loaders.push(loader);
				_this._endLoad(resInfo,data);
				_this._loaderCount--;
				_this._next();
			}
			loader.load(resInfo.url,resInfo.type,resInfo.cache);
		}

		__proto._endLoad=function(resInfo,content){
			if (content===null){
				var errorCount=this._failRes[resInfo.url] || 0;
				if (errorCount < this.retryNum){
					console.log("[warn]Retry to load:",resInfo.url);
					this._failRes[resInfo.url]=errorCount+1;
					this._resInfos[this._maxPriority-1].push(resInfo);
					return;
					}else {
					console.log("[error]Failed to load:",resInfo.url);
					this.event("error",resInfo.url);
				}
			}
			delete this._resMap[resInfo.url];
			resInfo.event("complete",content);
			resInfo.offAll();
			this._infoPool.push(resInfo);
		}

		/**
		*清理指定资源地址缓存。
		*@param url 资源地址。
		*/
		__proto.clearRes=function(url){
			Loader.clearRes(url);
		}

		/**
		*获取指定资源地址的资源。
		*@param url 资源地址。
		*@return 返回资源。
		*/
		__proto.getRes=function(url){
			return Loader.getRes(url);
		}

		/**清理当前未完成的加载。*/
		__proto.clearUnLoaded=function(){
			this._resInfos.length=0;
			this._loaderCount=0;
			this._resMap={};
		}

		/**
		*@private
		*加载数组里面的资源。
		*@param arr 简单：["a.png","b.png"]，复杂[{url:"a.png",type:Loader.IMAGE,size:100,priority:1},{url:"b.json",type:Loader.JSOn,size:50,priority:1}]*/
		__proto._loadAssets=function(arr,complete,progress,cache){
			(cache===void 0)&& (cache=true);
			var itemCount=arr.length;
			var loadedSize=0;
			var totalSize=0;
			var items=[];
			for (var i=0;i < itemCount;i++){
				var item=arr[i];
				if ((typeof item=='string'))item={url:item,type:"image",size:1,priority:1};
				if (!item.size)item.size=1;
				item.progress=0;
				totalSize+=item.size;
				items.push(item);
				var progressHandler=progress ? Handler.create(this,loadProgress,[item]):null;
				this.load(item.url,Handler.create(item,loadComplete,[item]),progressHandler,item.type,item.priority || 1,cache);
			}
			function loadComplete (item,content){
				loadedSize++;
				item.progress=1;
				if (loadedSize===itemCount && complete){
					complete.run();
				}
			}
			function loadProgress (item,value){
				if (progress !=null){
					item.progress=value;
					var num=0;
					for (var j=0;j < itemCount;j++){
						var item1=items[j];
						num+=item1.size *item1.progress;
					};
					var v=num / totalSize;
					progress.runWith(v);
				}
			}
			return this;
		}

		LoaderManager.cacheRes=function(url,data){
			Loader.cacheRes(url,data);
		}

		LoaderManager.__init$=function(){
			//class ResInfo extends laya.events.EventDispatcher
			ResInfo=(function(_super){
				function ResInfo(){
					this.url=null;
					this.type=null;
					this.cache=false;
					ResInfo.__super.call(this);
				}
				__class(ResInfo,'',_super);
				return ResInfo;
			})(EventDispatcher)
		}

		return LoaderManager;
	})(EventDispatcher)


	/**
	*<code>Resource</code> 是一个资源存取类。
	*/
	//class laya.resource.Resource extends laya.events.EventDispatcher
	var Resource=(function(_super){
		function Resource(){
			this._id=0;
			this._lastUseFrameCount=0;
			this._memorySize=0;
			this._name=null;
			this._released=false;
			this._resourceManager=null;
			this.lock=false;
			Resource.__super.call(this);
			this._$1__id=++Resource._uniqueIDCounter;
			Resource._loadedResources.push(this);
			Resource._isLoadedResourcesSorted=false;
			this._released=true;
			this.lock=false;
			this._memorySize=0;
			this._lastUseFrameCount=-1;
			(ResourceManager.currentResourceManager)&& (ResourceManager.currentResourceManager.addResource(this));
		}

		__class(Resource,'laya.resource.Resource',_super);
		var __proto=Resource.prototype;
		Laya.imps(__proto,{"laya.resource.IDispose":true})
		/**重新创建资源。override it，同时修改memorySize属性、处理startCreate()和compoleteCreate()方法。*/
		__proto.recreateResource=function(){
			this.startCreate();
			this.compoleteCreate();
		}

		/**销毁资源，override it,同时修改memorySize属性。*/
		__proto.detoryResource=function(){}
		/**
		*激活资源，使用资源前应先调用此函数激活。
		*@param force 是否强制创建。
		*/
		__proto.activeResource=function(force){
			(force===void 0)&& (force=false);
			this._lastUseFrameCount=Stat.loopCount;
			if (this._released || force){
				this.recreateResource();
			}
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
				this.detoryResource();
				this._released=true;
				this._lastUseFrameCount=-1;
				this.event("released",this);
				return true;
				}else {
				return false;
			}
		}

		/**
		*设置唯一名字,如果名字重复则自动加上“-copy”。
		*@param newName 名字。
		*/
		__proto.setUniqueName=function(newName){
			var isUnique=true;
			for (var i=0;i < Resource._loadedResources.length;i++){
				if (Resource._loadedResources[i]._name!==newName || Resource._loadedResources[i]===this)
					continue ;
				isUnique=false;
				return;
			}
			if (isUnique){
				if (this.name !=newName){
					this.name=newName;
					Resource._isLoadedResourcesSorted=false;
				}
				}else{
				this.setUniqueName(newName.concat("-copy"));
			}
		}

		/**
		*<p>彻底清理资源。</p>
		*<p><b>注意：</b>会强制解锁清理。</p>
		*/
		__proto.dispose=function(){
			if (this._resourceManager!==null)
				throw new Error("附属于resourceManager的资源不能独立释放！");
			this.lock=false;
			this.releaseResource();
			var index=Resource._loadedResources.indexOf(this);
			if (index!==-1){
				Resource._loadedResources.splice(index,1);
				Resource._isLoadedResourcesSorted=false;
			}
		}

		/**开始资源激活。*/
		__proto.startCreate=function(){
			this.event("recovering",this);
		}

		/**完成资源激活。*/
		__proto.compoleteCreate=function(){
			this._released=false;
			this.event("recovered",this);
		}

		/**
		*获取唯一标识ID(通常用于优化或识别)。
		*/
		__getset(0,__proto,'id',function(){
			return this._$1__id;
		});

		/**
		*距离上次使用帧率。
		*/
		__getset(0,__proto,'lastUseFrameCount',function(){
			return this._lastUseFrameCount;
		});

		/**
		*设置名字
		*/
		/**
		*获取名字。
		*/
		__getset(0,__proto,'name',function(){
			return this._name;
			},function(value){
			if ((value || value!=="")&& this.name!==value){
				this._name=value;
				Resource._isLoadedResourcesSorted=false;
			}
		});

		/**
		*资源管理员。
		*/
		__getset(0,__proto,'resourceManager',function(){
			return this._resourceManager;
		});

		/**
		*占用内存尺寸。
		*/
		__getset(0,__proto,'memorySize',function(){
			return this._memorySize;
			},function(value){
			var offsetValue=value-this._memorySize;
			this._memorySize=value;
			this.event("memorychanged",offsetValue);
		});

		/**
		*是否已释放。
		*/
		__getset(0,__proto,'released',function(){
			return this._released;
		});

		/**
		*本类型排序后的已载入资源。
		*/
		__getset(1,Resource,'sortedLoadedResourcesByName',function(){
			if (!Resource._isLoadedResourcesSorted){
				Resource._isLoadedResourcesSorted=true;
				Resource._loadedResources.sort(Resource.compareResourcesByName);
			}
			return Resource._loadedResources;
		},laya.events.EventDispatcher._$SET_sortedLoadedResourcesByName);

		Resource.getLoadedResourceByIndex=function(index){
			return Resource._loadedResources[index];
		}

		Resource.getLoadedResourcesCount=function(){
			return Resource._loadedResources.length;
		}

		Resource.compareResourcesByName=function(left,right){
			if (left===right)
				return 0;
			var x=left.name;
			var y=right.name;
			if (x===null){
				if (y===null)
					return 0;
				else
				return-1;
				}else {
				if (y==null)
					return 1;
				else {
					var retval=x.localeCompare(y);
					if (retval !=0)
						return retval;
					else {
						right.setUniqueName(y);
						y=right.name;
						return x.localeCompare(y);
					}
				}
			}
		}

		Resource.animationCache={};
		Resource.meshCache={};
		Resource._uniqueIDCounter=0;
		Resource._loadedResources=[];
		Resource._isLoadedResourcesSorted=false;
		return Resource;
	})(EventDispatcher)


	/**
	*<code>Texture</code> 是一个纹理处理类。
	*/
	//class laya.resource.Texture extends laya.events.EventDispatcher
	var Texture=(function(_super){
		function Texture(bitmapResource,uv){
			//this.bitmap=null;
			//this.uv=null;
			//this._loaded=false;
			this._w=0;
			this._h=0;
			this.offsetX=0;
			this.offsetY=0;
			Texture.__super.call(this);
			this.set(bitmapResource,uv);
		}

		__class(Texture,'laya.resource.Texture',_super);
		var __proto=Texture.prototype;
		/**
		*设置此对象的位图资源、UV数据信息。
		*@param bitmapResource 位图资源
		*@param uv UV数据信息
		*@param canInAtlas 是否存入图集。
		*/
		__proto.set=function(bitmapResource,uv){
			this.bitmap=bitmapResource;
			this.uv=uv || Texture.DEF_UV;
			if (bitmapResource){
				this._w=bitmapResource.width;
				this._h=bitmapResource.height;
				this._loaded=this._w > 0;
				var _this=this;
				if (this._loaded){
					(System.addToAtlas)&& (System.addToAtlas(_this));
					}else {
					var bm=bitmapResource;
					if (((bm instanceof laya.resource.HTMLImage ))&& (bm.image))
						bm.image.addEventListener('load',function(e){
						(System.addToAtlas)&& (System.addToAtlas(_this));
					},false);
				}
			}
		}

		/**激活资源。*/
		__proto.active=function(){
			this.bitmap.activeResource();
		}

		/**销毁。*/
		__proto.destroy=function(){
			this.bitmap=null;
		}

		/**
		*加载指定地址的图片。
		*@param url 图片地址。
		*/
		__proto.load=function(url){
			var _$this=this;
			this._loaded=false;
			var fileBitmap=(this.bitmap || (this.bitmap=new HTMLImage()));
			var _this=this;
			fileBitmap.onload=function (){
				fileBitmap.onload=null;
				_this._loaded=true;
				_$this._w=fileBitmap.width;
				_$this._h=fileBitmap.height;
				_this.event("loaded",this);
				(System.addToAtlas)&& (System.addToAtlas(_this));
			};
			fileBitmap.src=URL.formatURL(url);
		}

		/**实际高度。*/
		__getset(0,__proto,'height',function(){
			if (this._h)return this._h;
			return (this.uv && this.uv!==Texture.DEF_UV)? (this.uv[5]-this.uv[1])*this.bitmap.height :this.bitmap.height;
			},function(value){
			this._h=value;
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
			return this.bitmap.released;
		});

		/**激活并获取资源。*/
		__getset(0,__proto,'source',function(){
			this.bitmap.activeResource();
			return this.bitmap.source;
		});

		/**实际宽度。*/
		__getset(0,__proto,'width',function(){
			if (this._w)return this._w;
			return (this.uv && this.uv!==Texture.DEF_UV)? (this.uv[2]-this.uv[0])*this.bitmap.width :this.bitmap.width;
			},function(value){
			this._w=value;
		});

		Texture.moveUV=function(offsetX,offsetY,uv){
			for (var i=0;i < 8;i+=2){
				uv[i]+=offsetX;
				uv[i+1]+=offsetY;
			}
			return uv;
		}

		Texture.create=function(source,x,y,width,height,offsetX,offsetY){
			(offsetX===void 0)&& (offsetX=0);
			(offsetY===void 0)&& (offsetY=0);
			var uv=source.uv || Texture.DEF_UV;
			var bitmapResource=source.bitmap || source;
			var tex=new Texture(bitmapResource,null);
			tex.width=width;
			tex.height=height;
			tex.offsetX=offsetX;
			tex.offsetY=offsetY;
			var dwidth=1 / bitmapResource.width;
			var dheight=1 / bitmapResource.height;
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

		Texture.TEXTURE2D=1;
		Texture.TEXTURE3D=2;
		Texture.DEF_UV=[0,0,1.0,0,1.0,1.0,0,1.0];
		Texture.INV_UV=[0,1,1.0,1,1.0,0.0,0,0.0];
		return Texture;
	})(EventDispatcher)


	/**
	*<code>AutoBitmap</code> 类是用于表示位图图像或绘制图形的显示对象。
	*<p>封装了位置，宽高及九宫格的处理，供UI组件使用。</p>
	*/
	//class laya.ui.AutoBitmap extends laya.display.Graphics
	var AutoBitmap=(function(_super){
		function AutoBitmap(){
			this.autoCacheCmd=true;
			this._width=0;
			this._height=0;
			this._source=null;
			this._sizeGrid=null;
			AutoBitmap.__super.call(this);
		}

		__class(AutoBitmap,'laya.ui.AutoBitmap',_super);
		var __proto=AutoBitmap.prototype;
		/**@inheritDoc */
		__proto.destroy=function(){
			_super.prototype.destroy.call(this);
			this._source=null;
			this._sizeGrid=null;
		}

		/**
		*@private
		*修改纹理资源。
		*/
		__proto.changeSource=function(){
			var source=this._source;
			if (!source)return;
			var width=this.width;
			var height=this.height;
			var sizeGrid=this._sizeGrid;
			var sw=source.width;
			var sh=source.height;
			if (!sizeGrid || (sw===width && sh===height)){
				this.clear();
				this.drawTexture(source,0,0,width,height);
				}else {
				source.$_GID || (source.$_GID=Utils.getGID());
				var key=source.$_GID+"."+width+"."+height+"."+sizeGrid.join(".");
				if (AutoBitmap.cmdCaches[key]){
					this.cmds=AutoBitmap.cmdCaches[key];
					return;
				}
				this.clear();
				var top=sizeGrid[0];
				var right=sizeGrid[1];
				var bottom=sizeGrid[2];
				var left=sizeGrid[3];
				if (left+right > width){
					right=0;
				}
				left && top && this.drawTexture(AutoBitmap.getTexture(source,0,0,left,top),0,0,left,top);
				right && top && this.drawTexture(AutoBitmap.getTexture(source,sw-right,0,right,top),width-right,0,right,top);
				left && bottom && this.drawTexture(AutoBitmap.getTexture(source,0,sh-bottom,left,bottom),0,height-bottom,left,bottom);
				right && bottom && this.drawTexture(AutoBitmap.getTexture(source,sw-right,sh-bottom,right,bottom),width-right,height-bottom,right,bottom);
				top && this.drawTexture(AutoBitmap.getTexture(source,left,0,sw-left-right,top),left,0,width-left-right,top);
				bottom && this.drawTexture(AutoBitmap.getTexture(source,left,sh-bottom,sw-left-right,bottom),left,height-bottom,width-left-right,bottom);
				left && this.drawTexture(AutoBitmap.getTexture(source,0,top,left,sh-top-bottom),0,top,left,height-top-bottom);
				right && this.drawTexture(AutoBitmap.getTexture(source,sw-right,top,right,sh-top-bottom),width-right,top,right,height-top-bottom);
				this.drawTexture(AutoBitmap.getTexture(source,left,top,sw-left-right,sh-top-bottom),left,top,width-left-right,height-top-bottom);
				if (this.autoCacheCmd)AutoBitmap.cmdCaches[key]=this.cmds;
			}
			this._repaint();
		}

		/**
		*当前实例的有效缩放网格数据。
		*<p>如果设置为null,则在应用任何缩放转换时，将正常缩放整个显示对象。</p>
		*<p>数据格式：[上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)]。
		*<ul><li>例如：[4,4,4,4,1]</li></ul></p>
		*<p> <code>sizeGrid</code> 的值如下所示：
		*<ol>
		*<li>上边距</li>
		*<li>右边距</li>
		*<li>下边距</li>
		*<li>左边距</li>
		*<li>是否重复填充(值为0：不重复填充，1：重复填充)</li>
		*</ol></p>
		*<p>当定义 <code>sizeGrid</code> 属性时，该显示对象被分割到以 <code>sizeGrid</code> 数据中的"上边距,右边距,下边距,左边距" 组成的矩形为基础的具有九个区域的网格中，该矩形定义网格的中心区域。网格的其它八个区域如下所示：
		*<ul>
		*<li>矩形上方的区域</li>
		*<li>矩形外的右上角</li>
		*<li>矩形左侧的区域</li>
		*<li>矩形右侧的区域</li>
		*<li>矩形外的左下角</li>
		*<li>矩形下方的区域</li>
		*<li>矩形外的右下角</li>
		*<li>矩形外的左上角</li>
		*</ul>
		*同时也支持3宫格，比如0,4,0,4,1为水平3宫格，4,0,4,0,1为垂直3宫格，3宫格性能比9宫格高。
		*</p>
		*/
		__getset(0,__proto,'sizeGrid',function(){
			return this._sizeGrid;
			},function(value){
			this._sizeGrid=value;
			Laya.timer.callLater(this,this.changeSource);
		});

		/**
		*对象的纹理资源。
		*@see laya.resource.Texture
		*/
		__getset(0,__proto,'source',function(){
			return this._source;
			},function(value){
			if (value){
				this._source=value
				Laya.timer.callLater(this,this.changeSource);
				}else {
				this._source=null;
				this.clear();
			}
		});

		/**
		*表示显示对象的宽度，以像素为单位。
		*/
		__getset(0,__proto,'width',function(){
			if (this._width)return this._width;
			if (this._source)return this._source.width;
			return 0;
			},function(value){
			this._width=value;
			Laya.timer.callLater(this,this.changeSource);
		});

		/**
		*表示显示对象的高度，以像素为单位。
		*/
		__getset(0,__proto,'height',function(){
			if (this._height)return this._height;
			if (this._source)return this._source.height;
			return 0;
			},function(value){
			this._height=value;
			Laya.timer.callLater(this,this.changeSource);
		});

		AutoBitmap.getTexture=function(source,x,y,width,height){
			source.$GID || (source.$GID=Utils.getGID())
			var key=source.$GID+"."+x+"."+y+"."+width+"."+height;
			var texture=AutoBitmap.textureCache[key];
			if (!texture){
				texture=AutoBitmap.textureCache[key]=Texture.create(source,x,y,width,height);
			}
			return texture;
		}

		AutoBitmap.clearCache=function(){
			AutoBitmap.cmdCaches={};
			AutoBitmap.textureCache={};
		}

		AutoBitmap.cmdCaches={};
		AutoBitmap.textureCache={};
		return AutoBitmap;
	})(Graphics)


	/**
	*<code>UIEvent</code> 类用来定义UI组件类的事件类型。
	*/
	//class laya.ui.UIEvent extends laya.events.Event
	var UIEvent=(function(_super){
		function UIEvent(){UIEvent.__super.call(this);;
		};

		__class(UIEvent,'laya.ui.UIEvent',_super);
		UIEvent.SHOW_TIP="showtip";
		UIEvent.HIDE_TIP="hidetip";
		return UIEvent;
	})(Event)


	/**
	*<p> <code>Sprite</code> 类是基本显示列表构造块：一个可显示图形并且也可包含子项的显示列表节点。</p>
	*
	*@example 以下示例代码，创建了一个 <code>Text</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.display.Sprite;
		*import laya.events.Event;
		*
		*public class Sprite_Example
		*{
			*private var sprite:Sprite;
			*private var shape:Sprite
			*
			*public function Sprite_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*onInit();
				*}
			*
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
				*
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
			*
			*private function onClickSprite():void
			*{
				*trace("点击 sprite 对象。");
				*sprite.rotation+=5;//旋转 sprite 对象。
				*}
			*
			*private function onClickShape():void
			*{
				*trace("点击 shape 对象。");
				*shape.rotation+=5;//旋转 shape 对象。
				*}
			*}
		*}
	*</listing>
	*<listing version="3.0">
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
	*</listing>
	*<listing version="3.0">
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
			*
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
		*
		*private onClickSprite():void {
			*console.log("点击 sprite 对象。");
			*this.sprite.rotation+=5;//旋转 sprite 对象。
			*}
		*
		*private onClickShape():void {
			*console.log("点击 shape 对象。");
			*this.shape.rotation+=5;//旋转 shape 对象。
			*}
		*}
	*</listing>
	*/
	//class laya.display.Sprite extends laya.display.Node
	var Sprite=(function(_super){
		function Sprite(){
			this.mouseThrough=false;
			this._transform=null;
			this._tfChanged=false;
			this._x=0;
			this._y=0;
			this._width=0;
			this._height=0;
			this._repaint=1;
			this._mouseEnableState=0;
			this._enableRenderMerge=false;
			this._zOrder=0;
			this._graphics=null;
			this._renderType=0;
			this.autoSize=false;
			this.optimizeFloat=false;
			Sprite.__super.call(this);
			this._style=Style.EMPTY;
			this._$P=Sprite.PropEmpty;
		}

		__class(Sprite,'laya.display.Sprite',_super);
		var __proto=Sprite.prototype;
		Laya.imps(__proto,{"laya.display.ILayout":true})
		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			this._style && this._style.destroy();
			this._transform=null;
			this._style=null;
			this._graphics=null;
			this._$P=null
		}

		/**根据Z进行重新排序。*/
		__proto.updateOrder=function(){
			Utils.updateOrder(this._childs)&& this.repaint();
		}

		/**在设置cacheAsBtimap=true或者staticCache=true的情况下，调用此方法会重新刷新缓存。*/
		__proto.reCache=function(){
			if (this._$P.cacheCanvas)this._$P.cacheCanvas.reCache=true;
		}

		__proto.setBounds=function(bound){
			this.get$P().uBounds=bound;
		}

		/**
		*获取本对象在父容器坐标系的矩形显示区域。
		*<p><b>注意：</b>计算量较大，尽量少用。</p>
		*@return 矩形区域。
		*/
		__proto.getBounds=function(){
			return Rectangle._getWrapRec(this.boundPointsToParent(),Rectangle.TEMP);
		}

		/**
		*获取本对象在自己坐标系的矩形显示区域。
		*<p><b>注意：</b>计算量较大，尽量少用。</p>
		*@return 矩形区域。
		*/
		__proto.getSelfBounds=function(){
			return Rectangle._getWrapRec(this._getBoundPointsM(false),Rectangle.TEMP);
		}

		/**
		*获取本对象在父容器坐标系的显示区域多边形顶点列表。
		*当显示对象链中有旋转时，返回多边形顶点列表，无旋转时返回矩形的四个顶点。
		*@param ifRotate 之前的对象链中是否有旋转。
		*@return 顶点列表。结构：[x1,y1,x2,y2,x3,y3,...]。
		*/
		__proto.boundPointsToParent=function(ifRotate){
			(ifRotate===void 0)&& (ifRotate=false);
			var pX=0,pY=0;
			if (this._style){
				pX=this._style.translateX;
				pY=this._style.translateY;
				ifRotate=ifRotate || (this._style.rotate!==0);
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
				Utils.transPointList(pList,this.x-pX,this.y-pY);
				return pList;
			};
			var tPoint=Point.TEMP;
			var rst=[];
			var i=0,len=pList.length;
			for (i=0;i < len;i+=2){
				tPoint.x=pList[i];
				tPoint.y=pList[i+1];
				this.toParentPoint(tPoint);
				rst.push(tPoint.x,tPoint.y);
			}
			return rst;
		}

		/**
		*返回此实例中的绘图对象（ <code>Graphics</code> ）的显示区域。
		*@return 一个 Rectangle 对象，表示获取到的显示区域。
		*/
		__proto.getGraphicBounds=function(){
			if (!this._graphics)return Rectangle.EMPTY;
			return this._graphics.getBounds();
		}

		/**
		*@private
		*获取自己坐标系的显示区域多边形顶点列表
		*@param ifRotate 当前的显示对象链是否由旋转
		*@return 顶点列表。结构：[x1,y1,x2,y2,x3,y3,...]。
		*/
		__proto._getBoundPointsM=function(ifRotate){
			(ifRotate===void 0)&& (ifRotate=false);
			if (this._$P.uBounds)return this._$P.uBounds._getBoundPoints();
			if (!this._$P.temBM)this.get$P().temBM=[];
			var pList=this._graphics ? this._graphics.getBoundPoints():Utils.clearArr(this._$P.temBM);
			var child;
			var cList;
			for (var i=0,n=this.numChildren;i < n;i++){
				child=this.getChildAt(i);
				if ((child instanceof laya.display.Sprite )&& child.visible==true){
					cList=child.boundPointsToParent(ifRotate);
					if (cList)
						pList=pList ? Utils.concatArr(pList,cList):cList;
				}
			}
			return pList;
		}

		/**
		*@private
		*获取样式。
		*@return 样式 Style 。
		*/
		__proto.getStyle=function(){
			this._style===Style.EMPTY && (this._style=new Style());
			return this._style;
		}

		/**@private */
		__proto.get$P=function(){
			this._$P===Sprite.PropEmpty && (this._$P={});
			return this._$P;
		}

		/**
		*设置样式。
		*@param value 样式。
		*/
		__proto.setStyle=function(value){
			this._style=value;
		}

		/**@private */
		__proto._adjustTransform=function(){
			'use strict';
			this._tfChanged=false;
			var style=this._style;
			var sx=style.scaleX,sy=style.scaleY;
			var m;
			if (style.rotate || sx!==1 || sy!==1 || style.skewX || style.skewY){
				m=this._transform || (this._transform=Matrix.create());
				m.bTransform=true;
				if (style.rotate){
					var angle=style.rotate *0.0174532922222222;
					var cos=m.cos=Math.cos(angle);
					var sin=m.sin=Math.sin(angle);
					m.a=sx *cos;
					m.b=sx *sin;
					m.c=-sy *sin;
					m.d=sy *cos;
					m.tx=m.ty=0;
					return m;
					}else {
					m.a=sx;
					m.d=sy;
					m.c=m.b=m.tx=m.ty=0;
					if (style.skewX || style.skewY){
						return m.skew(style.skewX *0.0174532922222222,style.skewY *0.0174532922222222);
					}
					return m;
				}
				}else {
				this._transform && this._transform.destroy();
				this._transform=null;
				this._renderType &=~0x08;
			}
			return m;
		}

		/**
		*设置坐标位置。
		*@param x X 轴坐标。
		*@param y Y 轴坐标。
		*@return 返回对象本身。
		*/
		__proto.pos=function(x,y){
			if (this._x!==x || this._y!==y){
				this.x=x;
				this.y=y;
			}
			return this;
		}

		/**
		*设置轴心点。
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
		*设置宽高。
		*@param width 宽度。
		*@param hegiht 高度。
		*@return 返回对象本身。
		*/
		__proto.size=function(width,height){
			this.width=width;
			this.height=height;
			return this;
		}

		/**
		*设置缩放。
		*@param scaleX X轴缩放比例。
		*@param scaleY Y轴缩放比例。
		*@return 返回对象本身。
		*/
		__proto.scale=function(scaleX,scaleY){
			this.scaleX=scaleX;
			this.scaleY=scaleY;
			return this;
		}

		/**
		*设置倾斜角度。
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
		*更新、呈现显示对象。
		*@param context 渲染的上下文引用。
		*@param x X轴坐标。
		*@param y Y轴坐标。
		*/
		__proto.render=function(context,x,y){
			Stat.spriteDraw++;
			RenderSprite.renders[this._renderType]._fun(this,context,x+this._x,y+this._y);
			this._repaint=0;
		}

		/**
		*绘制 <code>Sprite</code> 到 <code>canvas</code> 上。
		*@param canvasWidth 画布宽度。
		*@param canvasHeight 画布高度。
		*@param x 绘制的 X 轴偏移量。
		*@param y 绘制的 Y 轴偏移量。
		*@return HTMLCanvas 对象。
		*/
		__proto.drawToCanvas=function(canvasWidth,canvasHeight,offsetX,offsetY){
			return System.drawToCanvas(this,this._renderType,canvasWidth,canvasHeight,offsetX,offsetY);
		}

		/**
		*自定义更新、呈现显示对象。
		*<p><b>注意</b>不要在此函数内增加或删除树节点，否则会树节点遍历照成影响。</p>
		*@param context 渲染的上下文引用。
		*@param x X轴坐标。
		*@param y Y轴坐标。
		*/
		__proto.customRender=function(context,x,y){}
		/**
		*应用滤镜。
		*/
		__proto.applyFilters=function(){
			if (Render.isWebGl)return;
			var _filters;
			_filters=this._$P.filters;
			if (!_filters || _filters.length < 1)return;
			for (var i=0,n=_filters.length;i < n;i++){
				_filters[i].action.apply(this._$P.cacheCanvas);
			}
		}

		/**
		*查看当前原件中是否包含发光滤镜。
		*@return 一个 Boolean 值，表示当前原件中是否包含发光滤镜。
		*/
		__proto.isHaveGlowFilter=function(){
			var i=0,len=0;
			for (i=0;i < this.filters.length;i++){
				if (this.filters[i].type==0x08){
					return true;
				}
			}
			for (i=0,len=this._childs.length;i < len;i++){
				if (this._childs[i].isHaveGlowFilter()){
					return true;
				}
			}
			return false;
		}

		/**@inheritDoc */
		__proto.ask=function(type,value){
			return type==1 ? (value==2):false;
		}

		/**
		*本地坐标转全局坐标。
		*@param point 本地坐标点。
		*@param createNewPoint 用于存储转换后的坐标的点。
		*@return 转换后的坐标的点。
		*/
		__proto.localToGlobal=function(point,createNewPoint){
			(createNewPoint===void 0)&& (createNewPoint=false);
			if (!this._displayInStage || !point)return point;
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
		*全局坐标转本地坐标。
		*@param point 全局坐标点。
		*@param createNewPoint 用于存储转换后的坐标的点。
		*@return 转换后的坐标的点。
		*/
		__proto.globalToLocal=function(point,createNewPoint){
			(createNewPoint===void 0)&& (createNewPoint=false);
			if (!this._displayInStage || !point)return point;
			if (createNewPoint===true){
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
		*将本地坐标系坐标转换到父容器坐标系。
		*@param point 本地坐标点。
		*@return 转换后的点。
		*/
		__proto.toParentPoint=function(point){
			if (!point)return point;
			point.x-=this.pivotX;
			point.y-=this.pivotY;
			if (this.transform){
				this._transform.transformPoint(point.x,point.y,point);
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
			point.x+=this.pivotX;
			point.y+=this.pivotY;
			return point;
		}

		/**
		*使用 EventDispatcher 对象注册指定类型的事件侦听器对象，以使侦听器能够接收事件通知。
		*如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnable 的值为 true。
		*@param type 事件的类型。
		*@param caller 事件侦听函数的执行域。
		*@param listener 事件侦听函数。
		*@param args 事件侦听函数的回调参数。
		*@return 此 EventDispatcher 对象。
		*/
		__proto.on=function(type,caller,listener,args){
			if (this._mouseEnableState!==1 && this.isMouseEvent(type)){
				if (this._displayInStage)this._$2__onDisplay();
				else laya.events.EventDispatcher.prototype.once.call(this,"display",this,this._$2__onDisplay);
			}
			return laya.events.EventDispatcher.prototype.on.call(this,type,caller,listener,args);
		}

		/**
		*使用 EventDispatcher 对象注册指定类型的事件侦听器对象，以使侦听器能够接收事件通知，此侦听事件响应一次后自动移除。
		*如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnable 的值为 true。
		*@param type 事件的类型。
		*@param caller 事件侦听函数的执行域。
		*@param listener 事件侦听函数。
		*@param args 事件侦听函数的回调参数。
		*@return 此 EventDispatcher 对象。
		*/
		__proto.once=function(type,caller,listener,args){
			if (this._mouseEnableState!==1 && this.isMouseEvent(type)){
				if (this._displayInStage)this._$2__onDisplay();
				else laya.events.EventDispatcher.prototype.once.call(this,"display",this,this._$2__onDisplay);
			}
			return laya.events.EventDispatcher.prototype.once.call(this,type,caller,listener,args);
		}

		/**@private */
		__proto._$2__onDisplay=function(){
			if (this._mouseEnableState!==1){
				var ele=this;
				while (ele && ele._mouseEnableState!==1){
					ele.mouseEnabled=true;
					ele=ele.parent;
				}
			}
		}

		/**
		*加载并显示一个图片。
		*<p><b>注意：</b>调用本方法自动调用 graphics.clear()（清除所有命令），只显示新load的图片，如果想显示多个，请用 graphics.drawTexture 或者 graphics.loadImage 。</p>
		*@param url 图片地址。
		*@param x 显示图片的x位置
		*@param y 显示图片的y位置
		*@param width 显示图片的宽度，设置为0表示使用图片默认宽度
		*@param height 显示图片的高度，设置为0表示使用图片默认高度
		*@param complete 加载完成回调
		*@return 返回精灵对象本身
		*/
		__proto.loadImage=function(url,x,y,width,height,complete){
			var _$this=this;
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			(width===void 0)&& (width=0);
			(height===void 0)&& (height=0);
			this.graphics.clear();
			function loaded (tex){
				_$this.size(tex.width,tex.height);
				_$this.repaint();
				complete && complete.runWith(tex);
			}
			this.graphics.loadImage(url,x,y,width,height,loaded);
			return this;
		}

		/**cacheAsBitmap值为true时，手动重新缓存本对象。*/
		__proto.repaint=function(){
			(this._repaint===0)&& (this._repaint=1,this.parentRepaint(this));
		}

		/**
		*获取是否重新缓存。
		*@return 如果重新缓存值为 true，否则值为 false。
		*/
		__proto.isRepaint=function(){
			return (this._repaint!==0)&& this._$P.cacheCanvas && this._$P.cacheCanvas.reCache;
		}

		/**@inheritDoc */
		__proto.childChanged=function(child){
			if (this._childs.length)this._renderType |=0x800;
			else this._renderType &=~0x800;
			if (child && (child).zOrder)Laya.timer.callLater(this,this.updateOrder);
			this.repaint();
		}

		/**cacheAsBitmap=true时，手动重新缓存父对象。 */
		__proto.parentRepaint=function(child){
			var p=this._parent;
			p && p._repaint===0 && (p._repaint=1,p.parentRepaint(this));
		}

		/**
		*开始拖动此对象。
		*@param area 拖动区域，此区域为当前对象注册点活动区域（不包括对象宽高），可选。
		*@param hasInertia 鼠标松开后，是否还惯性滑动，默认为false，可选。
		*@param elasticDistance 橡皮筋效果的距离值，0为无橡皮筋效果，默认为0，可选。
		*@param elasticBackTime 橡皮筋回弹时间，单位为毫秒，默认为300毫秒，可选。
		*@param data 拖动事件携带的数据，可选。
		*@param disableMouseEvent 禁用其他对象的鼠标检测，默认为false，设置为true能提高性能
		*/
		__proto.startDrag=function(area,hasInertia,elasticDistance,elasticBackTime,data,disableMouseEvent){
			(hasInertia===void 0)&& (hasInertia=false);
			(elasticDistance===void 0)&& (elasticDistance=0);
			(elasticBackTime===void 0)&& (elasticBackTime=300);
			(disableMouseEvent===void 0)&& (disableMouseEvent=false);
			this._$P.dragging || (this.get$P().dragging=new Dragging());
			this._$P.dragging.start(this,area,hasInertia,elasticDistance,elasticBackTime,data,disableMouseEvent);
		}

		/**停止拖动此对象。*/
		__proto.stopDrag=function(){
			this._$P.dragging && this._$P.dragging.stop();
		}

		/**@private */
		__proto._setDisplay=function(value){
			if (!value && this._$P.cacheCanvas && this._$P.cacheCanvas.ctx){
				this._$P.cacheCanvas.ctx.destroy();
				this._$P.cacheCanvas.ctx=null;
			};
			var fc=this["_filterCache"];
			fc && (fc.destroy(),fc.recycle(),this["_filterCache"]=null);
			this["_isHaveGlowFilter"]=false;
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
			var rect=this._$P.hitArea ? this._$P.hitArea :Rectangle.EMPTY.setTo(0,0,this._width,this._height);
			return rect.contains(point.x,point.y);
		}

		/**获得相对于本对象上的鼠标坐标信息。*/
		__proto.getMousePoint=function(){
			return this.globalToLocal(Point.TEMP.setTo(Laya.stage.mouseX,Laya.stage.mouseY));
		}

		/**@private */
		__proto._getWords=function(){
			return null;
		}

		/**@private */
		__proto._addChildsToLayout=function(out){
			var words=this._getWords();
			if (words==null && this._childs.length==0)return false;
			words && words.forEach(function(o){
				out.push(o);
			});
			this._childs.forEach(function(o){
				o._style._enableLayout()&& o._addToLayout(out);
			});
			return true;
		}

		/**@private */
		__proto._addToLayout=function(out){
			if (this._style.absolute)return;
			this._style.block ? out.push(this):(this._addChildsToLayout(out)&& (this.x=this.y=0));
		}

		/**@private */
		__proto._isChar=function(){
			return false;
		}

		/**@private */
		__proto._getCSSStyle=function(){
			return this._style.getCSSStyle();
		}

		/**
		*设置指定属性名的属性值。
		*@param name 属性名。
		*@param value 属性值。
		*/
		__proto.setValue=function(name,value){
			switch (name){
				case 'x':
					this.x=parseFloat(value);
					break ;
				case 'y':
					this.y=parseFloat(value);
					break ;
				case 'width':
					this.width=parseFloat(value);
					break ;
				case 'height':
					this.height=parseFloat(value);
					break ;
				default :
					this[name]=value;
				}
		}

		/**
		*@private
		*/
		__proto.layoutLater=function(){
			this.parent && (this.parent).layoutLater();
		}

		/**
		*指定显示对象是否缓存为静态图像。功能同cacheAs的normal模式。
		*/
		__getset(0,__proto,'cacheAsBitmap',function(){
			return this.cacheAs!=="none";
			},function(value){
			this.cacheAs=value ? "normal" :"none";
		});

		/**显示对象的滚动矩形范围。*/
		__getset(0,__proto,'scrollRect',function(){
			return this._style.scrollRect;
			},function(value){
			this.getStyle().scrollRect=value;
			this.repaint();
			if (value)this._renderType |=0x40;
			else this._renderType &=~0x40;
		});

		/**
		*表示显示对象的显示高度，以像素为单位。
		*/
		__getset(0,__proto,'viewHeight',function(){
			return this.height *this._style.scaleY;
		});

		/**
		*<p>指定显示对象是否缓存为静态图像，cacheAs时，子对象发生变化，会自动重新缓存，同时也可以手动调用reCache方法更新缓存。</p>
		*建议把不经常变化的复杂内容缓存为静态图像，能极大提高渲染性能，有"none"，"normal"和"bitmap"三个值可选。
		*<li>默认为"none"，不做任何缓存。</li>
		*<li>当值为"normal"时，canvas下进行画布缓存，webgl模式下进行命令缓存。</li>
		*<li>当值为"bitmap"时，canvas下进行依然是画布缓存，webgl模式下使用renderTarget缓存。</li>
		*webgl下renderTarget缓存模式有最大2048大小限制，会额外增加内存开销，不断重绘时开销比较大，但是会减少drawcall，渲染性能最高。
		*webgl下命令缓存模式只会减少节点遍历及命令组织，不会减少drawcall，性能中等。
		*/
		__getset(0,__proto,'cacheAs',function(){
			return this._$P.cacheCanvas==null ? "none" :this._$P.cacheCanvas.type;
			},function(value){
			if (value===(this._$P.cacheCanvas ? this._$P.cacheCanvas.type :"none"))return;
			if (value!=="none"){
				this._$P.cacheCanvas || (this.get$P().cacheCanvas=Pool.getItemByClass("cacheCanvas",Object));
				this._$P.cacheCanvas.type=value;
				this._$P.cacheCanvas.reCache=true;
				this._renderType |=0x10;
				}else {
				if (this._$P.cacheCanvas)Pool.recover("cacheCanvas",this._$P.cacheCanvas);
				this._$P.cacheCanvas=null;
				this._renderType &=~0x10;
			}
			this.repaint();
		});

		/**cacheAsBitmap=true时此值才有效，staticCache=true时，子对象变化时不会自动更新缓存，只能通过调用reCache方法手动刷新。*/
		__getset(0,__proto,'staticCache',function(){
			return this._$P.staticCache;
			},function(value){
			this._$P.staticCache=value;
			if (!value && this._$P.cacheCanvas){
				this._$P.cacheCanvas.reCache=true;
			}
		});

		/**表示显示对象相对于父容器的水平方向坐标值。*/
		__getset(0,__proto,'x',function(){
			return this._x;
			},function(value){
			var p=this._parent;
			this._x!==value && (this._x=value,p && p._repaint===0 && (p._repaint=1,p.parentRepaint(this)));
		});

		/**表示显示对象相对于父容器的垂直方向坐标值。*/
		__getset(0,__proto,'y',function(){
			return this._y;
			},function(value){
			var p=this._parent;
			this._y!==value && (this._y=value,p && p._repaint===0 && (p._repaint=1,p.parentRepaint(this)));
		});

		/**水平倾斜角度，默认值为0。*/
		__getset(0,__proto,'skewX',function(){
			return this._style.skewX;
			},function(value){
			var style=this.getStyle();
			if (style.skewX!==value){
				style.skewX=value;
				this._tfChanged=true;
				this._renderType |=0x08;
				var p=this._parent;
				p && p._repaint===0 && (p._repaint=1,p.parentRepaint(this));
			}
		});

		/**
		*表示显示对象的宽度，以像素为单位。
		*/
		__getset(0,__proto,'width',function(){
			if (!this.autoSize)return this._width;
			return this.getSelfBounds().width;
			},function(value){
			this._width!==value && (this._width=value,this.repaint());
		});

		/**
		*表示显示对象的高度，以像素为单位。
		*/
		__getset(0,__proto,'height',function(){
			if (!this.autoSize)return this._height;
			return this.getSelfBounds().height;
			},function(value){
			this._height!==value && (this._height=value,this.repaint());
		});

		/**
		*表示显示对象的显示宽度，以像素为单位。
		*/
		__getset(0,__proto,'viewWidth',function(){
			return this.width *this._style.scaleX;
		});

		/**X轴缩放值，默认值为1。*/
		__getset(0,__proto,'scaleX',function(){
			return this._style.scaleX;
			},function(value){
			var style=this.getStyle();
			if (style.scaleX!==value){
				style.scaleX=value;
				this._tfChanged=true;
				this._renderType |=0x08;
				var p=this._parent;
				p && p._repaint===0 && (p._repaint=1,p.parentRepaint(this));
			}
		});

		/**手动设置的可点击区域。*/
		__getset(0,__proto,'hitArea',function(){
			return this._$P.hitArea;
			},function(value){
			this.get$P().hitArea=value;
		});

		/**旋转角度，默认值为0。*/
		__getset(0,__proto,'rotation',function(){
			return this._style.rotate;
			},function(value){
			var style=this.getStyle();
			if (style.rotate!==value){
				style.rotate=value;
				this._tfChanged=true;
				this._renderType |=0x08;
				var p=this._parent;
				p && p._repaint===0 && (p._repaint=1,p.parentRepaint(this));
			}
		});

		/**Y轴缩放值，默认值为1。*/
		__getset(0,__proto,'scaleY',function(){
			return this._style.scaleY;
			},function(value){
			var style=this.getStyle();
			if (style.scaleY!==value){
				style.scaleY=value;
				this._tfChanged=true;
				this._renderType |=0x08;
				var p=this._parent;
				p && p._repaint===0 && (p._repaint=1,p.parentRepaint(this));
			}
		});

		/**指定要使用的混合模式。*/
		__getset(0,__proto,'blendMode',function(){
			return this._style.blendMode;
			},function(value){
			this.getStyle().blendMode=value;
			if (value && value !="source-over")this._renderType |=0x20;
			else this._renderType &=~0x20;
			this.parentRepaint(this);
		});

		/**垂直倾斜角度，默认值为0。*/
		__getset(0,__proto,'skewY',function(){
			return this._style.skewY;
			},function(value){
			var style=this.getStyle();
			if (style.skewY!==value){
				style.skewY=value;
				this._tfChanged=true;
				this._renderType |=0x08;
				var p=this._parent;
				p && p._repaint===0 && (p._repaint=1,p.parentRepaint(this));
			}
		});

		/**
		*对象的矩阵信息。
		*/
		__getset(0,__proto,'transform',function(){
			return this._tfChanged ? this._adjustTransform():this._transform;
			},function(value){
			this._tfChanged=false;
			this._transform=value;
			if (value){
				this._x=value.tx;
				this._y=value.ty;
				value.tx=value.ty=0;
			}
			if (value)this._renderType |=0x08;
			else this._renderType &=~0x08;
			this.parentRepaint(this);
		});

		/**X轴 轴心点的位置，默认为0，轴心点会影响对象位置，缩放，旋转。*/
		__getset(0,__proto,'pivotX',function(){
			return this._style.translateX;
			},function(value){
			this.getStyle().translateX=value;
			this.repaint();
		});

		/**Y轴 轴心点的位置，默认为0，轴心点会影响对象位置，缩放，旋转。*/
		__getset(0,__proto,'pivotY',function(){
			return this._style.translateY;
			},function(value){
			this.getStyle().translateY=value;
			this.repaint();
		});

		/**透明度，值为0-1，默认值为1，表示不透明。*/
		__getset(0,__proto,'alpha',function(){
			return this._style.alpha;
			},function(value){
			if (this._style.alpha!==value){
				value=value < 0 ? 0 :(value > 1 ? 1 :value);
				this.getStyle().alpha=value;
				if (value!==1)this._renderType |=0x04;
				else this._renderType &=~0x04;
				this.parentRepaint(this);
			}
		});

		/**表示是否可见，默认为true。*/
		__getset(0,__proto,'visible',function(){
			return this._style.visible;
			},function(value){
			if (this._style.visible!==value){
				this.getStyle().visible=value;
				this.parentRepaint(this);
			}
		});

		/**绘图对象。*/
		__getset(0,__proto,'graphics',function(){
			return this._graphics || (this.graphics=System.createGraphics());
			},function(value){
			if (this._graphics)this._graphics._sp=null;
			this._graphics=value;
			if (value){
				this._renderType &=~0x01;
				this._renderType |=0x100;
				value._sp=this;
				}else {
				this._renderType &=~0x100;
				this._renderType &=~0x01;
			}
			this.repaint();
		});

		/**滤镜集合。*/
		__getset(0,__proto,'filters',function(){
			return this._$P.filters;
			},function(value){
			value && value.length===0 && (value=null);
			if (this._$P.filters==value)return;
			this.get$P().filters=value ? value.slice():null;
			if (Render.isWebGl){
				if (value && value.length){
					this._renderType |=0x02;
					}else {
					this._renderType &=~0x02;
				}
				this.repaint();
				return;
			}
			this.cacheAsBitmap=value && value.length > 0;
			this.repaint();
		});

		/**遮罩。*/
		__getset(0,__proto,'mask',function(){
			return this._$P._mask;
			},function(value){
			this.cacheAsBitmap=true;
			this.get$P()._mask=value;
			this._renderType |=0x20;
			this.parentRepaint(this);
		});

		/**对舞台 <code>stage</code> 的引用。*/
		__getset(0,__proto,'stage',function(){
			return Laya.stage;
		});

		/**
		*是否接受鼠标事件。
		*默认为false，如果监听鼠标事件，则会自动设置本对象及父节点的属性 mouseEnable 的值都为 true。
		**/
		__getset(0,__proto,'mouseEnabled',function(){
			return this._mouseEnableState > 1;
			},function(value){
			this._mouseEnableState=value ? 2 :1;
		});

		/**是否允许webgl绘制时进行指令合并优化。*/
		__getset(0,__proto,'enableRenderMerge',function(){
			return this._enableRenderMerge;
			},function(value){
			if (Render.isWebGl){
				if (value){
					this._renderType |=0x400;
					}else {
					this._renderType &=~0x400;
				}
				this._enableRenderMerge=value;
			}
		});

		/**
		*表示鼠标在此对象上的 Y 轴坐标信息。
		*/
		__getset(0,__proto,'mouseY',function(){
			return this.getMousePoint().y;
		});

		/**
		*表示鼠标在此对象上的 X 轴坐标信息。
		*/
		__getset(0,__proto,'mouseX',function(){
			return this.getMousePoint().x;
		});

		/**z排序，更改此值，按照值的大小进行显示层级排序。*/
		__getset(0,__proto,'zOrder',function(){
			return this._zOrder;
			},function(value){
			if (this._zOrder !=value){
				this._zOrder=value;
				this._parent && Laya.timer.callLater(this._parent,this.updateOrder);
			}
		});

		Sprite.fromImage=function(url){
			return new Sprite().loadImage(url);
		}

		Sprite.PropEmpty={};
		return Sprite;
	})(Node)


	/**
	*@private
	*audio标签播放声音的音轨控制
	*/
	//class laya.media.h5audio.AudioSoundChannel extends laya.media.SoundChannel
	var AudioSoundChannel=(function(_super){
		function AudioSoundChannel(audio){
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
			if (this.loops==1){
				if (this.completeHandler){
					this.completeHandler.run();
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
			try {
				this._audio.removeEventListener("canplay",this._resumePlay);
				this._audio.currentTime=this.startTime;
				Browser.document.body.appendChild(this._audio);
				this._audio.play();
				}catch (e){
				this.event("error");
			}
		}

		/**
		*播放
		*/
		__proto.play=function(){
			try {
				this._audio.currentTime=this.startTime;
				}catch (e){
				this._audio.addEventListener("canplay",this._resumePlay);
				return;
			}
			Browser.document.body.appendChild(this._audio);
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
			this._audio.pause();
			this._audio.removeEventListener("ended",this._onEnd);
			this._audio.removeEventListener("canplay",this._resumePlay);
			Pool.recover("audio:"+this.url,this._audio);
			Browser.removeElement(this._audio);
			this._audio=null;
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
			if (!this._audio)return 1;
			return this._audio.volume;
			},function(v){
			if (!this._audio)return;
			this._audio.volume=v;
		});

		return AudioSoundChannel;
	})(SoundChannel)


	/**
	*@private
	*web audio api方式播放声音的音轨控制
	*/
	//class laya.media.webaudio.WebAudioSoundChannel extends laya.media.SoundChannel
	var WebAudioSoundChannel=(function(_super){
		function WebAudioSoundChannel(){
			this.audioBuffer=null;
			this.gain=null;
			this.bufferSource=null;
			this._currentTime=0;
			this._volume=1;
			this._startTime=0;
			this._onPlayEnd=null;
			this.context=WebAudioSound.ctx;
			WebAudioSoundChannel.__super.call(this);
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
		*
		*/
		__proto.play=function(){
			if (this.bufferSource){
				this.bufferSource.disconnect();
				this.bufferSource.onended=null;
				this.bufferSource=null;
			}
			if (!this.audioBuffer)return;
			var context=this.context;
			var gain=this.gain;
			var bufferSource=context.createBufferSource();
			this.bufferSource=bufferSource;
			bufferSource.buffer=this.audioBuffer;
			bufferSource.connect(gain);
			if (gain)
				gain.disconnect();
			gain.connect(context.destination);
			bufferSource.onended=this._onPlayEnd;
			this._startTime=Browser.now();
			this.gain.gain.value=this._volume;
			if (this.loops==0){
				bufferSource.loop=true;
			}
			bufferSource.start(0,this.startTime);
			this._currentTime=0;
		}

		__proto.__onPlayEnd=function(){
			if (this.loops==1){
				if (this.completeHandler){
					this.completeHandler.run();
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

		/**
		*停止播放
		*
		*/
		__proto.stop=function(){
			if (this.bufferSource){
				var sourceNode=this.bufferSource;
				if (sourceNode.stop){
					sourceNode.stop(0);
					}else {
					sourceNode.noteOff(0);
				}
				this.bufferSource.disconnect();
				this.bufferSource=null;
				this.audioBuffer=null;
			}
			if (this.gain)
				this.gain.disconnect();
			this.isStopped=true;
			SoundManager.removeChannel(this);
			this.completeHandler=null;
		}

		/**
		*获取当前播放位置
		*@return
		*
		*/
		__getset(0,__proto,'position',function(){
			if (this.bufferSource){
				return (Browser.now()-this._startTime)/ 1000+this.startTime;
			}
			return 0;
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
			return this._volume;
			},function(v){
			if (this.isStopped){
				return;
			}
			this._volume=v;
			this.gain.gain.value=v;
		});

		return WebAudioSoundChannel;
	})(SoundChannel)


	/**
	*<code>Bitmap</code> 是图片资源类。
	*/
	//class laya.resource.Bitmap extends laya.resource.Resource
	var Bitmap=(function(_super){
		function Bitmap(){
			//this._source=null;
			//this._w=NaN;
			//this._h=NaN;
			Bitmap.__super.call(this);
			this._w=0;
			this._h=0;
		}

		__class(Bitmap,'laya.resource.Bitmap',_super);
		var __proto=Bitmap.prototype;
		/**
		*将此对象的成员（资源、宽、高）属性值复制给指定的 Bitmap 对象。
		*@param dec 一个 Bitmap 对象。
		*/
		__proto.copyTo=function(dec){
			dec._source=this._source;
			dec._w=this._w;
			dec._h=this._h;
		}

		/**
		*彻底清理资源。
		*/
		__proto.dispose=function(){
			this._resourceManager.removeResource(this);
			_super.prototype.dispose.call(this);
		}

		/***
		*HTML Image 或 HTML Canvas 或 WebGL Texture 。
		*/
		__getset(0,__proto,'source',function(){
			return this._source;
		});

		/***
		*宽度。
		*/
		__getset(0,__proto,'width',function(){
			return this._w;
		});

		/***
		*高度。
		*/
		__getset(0,__proto,'height',function(){
			return this._h;
		});

		return Bitmap;
	})(Resource)


	/**
	*<code>Component</code> 是ui控件类的基类。
	*<p>生命周期：preinitialize > createChildren > initialize > 组件构造函数</p>
	*/
	//class laya.ui.Component extends laya.display.Sprite
	var Component=(function(_super){
		function Component(){
			this._comXml=null;
			this._dataSource=null;
			this._toolTip=null;
			this._tag=null;
			this._disabled=false;
			Component.__super.call(this);
			this._layout=LayoutStyle.EMPTY;
			this.preinitialize();
			this.createChildren();
			this.initialize();
		}

		__class(Component,'laya.ui.Component',_super);
		var __proto=Component.prototype;
		Laya.imps(__proto,{"laya.ui.IComponent":true})
		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			this._dataSource=this._layout=null;
			this._tag=null;
			this._toolTip=null;
		}

		/**
		*<p>预初始化。</p>
		*@internal 子类可在此函数内设置、修改属性默认值
		*/
		__proto.preinitialize=function(){}
		/**
		*<p>创建并添加控件子节点。</p>
		*@internal 子类可在此函数内创建并添加子节点。
		*/
		__proto.createChildren=function(){}
		/**
		*<p>控件初始化。</p>
		*@internal 在此子对象已被创建，可以对子对象进行修改。
		*/
		__proto.initialize=function(){}
		/**
		*<p>延迟运行指定的函数。</p>
		*<p>在控件被显示在屏幕之前调用，一般用于延迟计算数据。</p>
		*@param method 要执行的函数的名称。例如，functionName。
		*@param args 传递给 <code>method</code> 函数的可选参数列表。
		*
		*@see #runCallLater()
		*/
		__proto.callLater=function(method,args){
			Laya.timer.callLater(this,method,args);
		}

		/**
		*<p>如果有需要延迟调用的函数（通过 <code>callLater</code> 函数设置），则立即执行延迟调用函数。</p>
		*@param method 要执行的函数名称。例如，functionName。
		*@see #callLater()
		*/
		__proto.runCallLater=function(method){
			Laya.timer.runCallLater(this,method);
		}

		/**
		*<p>立即执行影响宽高度量的延迟调用函数。</p>
		*@internal <p>使用 <code>runCallLater</code> 函数，立即执行影响宽高度量的延迟运行函数(使用 <code>callLater</code> 设置延迟执行函数)。</p>
		*@see #callLater()
		*@see #runCallLater()
		*/
		__proto.commitMeasure=function(){}
		/**
		*<p>重新调整对象的大小。</p>
		*/
		__proto.changeSize=function(){
			this.event("resize");
		}

		/**
		*@private
		*<p>获取对象的布局样式。</p>
		*/
		__proto.getLayout=function(){
			this._layout===LayoutStyle.EMPTY && (this._layout=new LayoutStyle());
			return this._layout;
		}

		/**
		*对象从显示列表移除的事件侦听处理函数。
		*/
		__proto.onRemoved=function(){
			this.parent.off("resize",this,this.onCompResize);
		}

		/**
		*对象被添加到显示列表的事件侦听处理函数。
		*/
		__proto.onAdded=function(){
			this.parent.on("resize",this,this.onCompResize);
			this.resetLayoutX();
			this.resetLayoutY();
		}

		/**
		*父容器的 <code>Event.RESIZE</code> 事件侦听处理函数。
		*/
		__proto.onCompResize=function(){
			if (this._layout.enable){
				this.resetLayoutX();
				this.resetLayoutY();
			}
		}

		/**
		*<p>重置对象的 <code>X</code> 轴（水平方向）布局。</p>
		*/
		__proto.resetLayoutX=function(){
			var parent=this.parent;
			if (parent){
				var layout=this._layout;
				if (!isNaN(layout.centerX)){
					this.x=(parent.width-this.displayWidth)*0.5+layout.centerX;
					}else if (!isNaN(layout.left)){
					this.x=layout.left;
					if (!isNaN(layout.right)){
						this.width=(parent._width-layout.left-layout.right)/ this.scaleX;
					}
					}else if (!isNaN(layout.right)){
					this.x=parent.width-this.displayWidth-layout.right;
				}
			}
		}

		/**
		*<p>重置对象的 <code>Y</code> 轴（垂直方向）布局。</p>
		*/
		__proto.resetLayoutY=function(){
			var parent=this.parent;
			if (parent){
				var layout=this._layout;
				if (!isNaN(layout.centerY)){
					this.y=(parent.height-this.displayHeight)*0.5+layout.centerY;
					}else if (!isNaN(layout.top)){
					this.y=layout.top;
					if (!isNaN(layout.bottom)){
						this.height=(parent._height-layout.top-layout.bottom)/ this.scaleY;
					}
					}else if (!isNaN(layout.bottom)){
					this.y=parent.height-this.displayHeight-layout.bottom;
				}
			}
		}

		/**
		*对象的 <code>Event.MOUSE_OVER</code> 事件侦听处理函数。
		*/
		__proto.onMouseOver=function(e){
			Laya.stage.event("showtip",this._toolTip);
		}

		/**
		*对象的 <code>Event.MOUSE_OUT</code> 事件侦听处理函数。
		*/
		__proto.onMouseOut=function(e){
			Laya.stage.event("hidetip",this._toolTip);
		}

		/**
		*<p>表示显示对象的宽度，以像素为单位。</p>
		*<p><b>注：</b>当值为0时，宽度为自适应大小。</p>
		*/
		__getset(0,__proto,'width',function(){
			if (this._width)return this._width;
			return this.measureWidth;
			},function(value){
			if (this._width !=value){
				this._width=value;
				this.callLater(this.changeSize);
				if (this._layout.enable && (!isNaN(this._layout.centerX)|| !isNaN(this._layout.right)))this.resetLayoutX();
			}
		});

		/**
		*<p>对象的显示宽度（以像素为单位）。</p>
		*/
		__getset(0,__proto,'displayWidth',function(){
			return this.width *this.scaleX;
		});

		/**
		*<p>在父容器中，此对象的水平方向中轴线与父容器的水平方向中心线的距离（以像素为单位）。</p>
		*/
		__getset(0,__proto,'centerX',function(){
			return this._layout.centerX;
			},function(value){
			this.getLayout().centerX=value;
			this.layOutEabled=true;
			this.resetLayoutX();
		});

		/**
		*<p>对象的显示高度（以像素为单位）。</p>
		*/
		__getset(0,__proto,'displayHeight',function(){
			return this.height *this.scaleY;
		});

		/**
		*<p>显示对象的实际显示区域高度（以像素为单位）。</p>
		*/
		__getset(0,__proto,'measureHeight',function(){
			var max=0;
			this.commitMeasure();
			for (var i=this.numChildren-1;i >-1;i--){
				var comp=this.getChildAt(i);
				if (comp.visible){
					max=Math.max(comp.y+comp.height *comp.scaleY,max);
				}
			}
			return max;
		});

		/**
		*<p>显示对象的实际显示区域宽度（以像素为单位）。</p>
		*/
		__getset(0,__proto,'measureWidth',function(){
			var max=0;
			this.commitMeasure();
			for (var i=this.numChildren-1;i >-1;i--){
				var comp=this.getChildAt(i);
				if (comp.visible){
					max=Math.max(comp.x+comp.width *comp.scaleX,max);
				}
			}
			return max;
		});

		/**
		*<p>表示显示对象的高度，以像素为单位。</p>
		*<p><b>注：</b>当值为0时，高度为自适应大小。</p>
		*@return
		*/
		__getset(0,__proto,'height',function(){
			if (this._height)return this._height;
			return this.measureHeight;
			},function(value){
			if (this._height !=value){
				this._height=value;
				this.callLater(this.changeSize);
				if (this._layout.enable && (!isNaN(this._layout.centerY)|| !isNaN(this._layout.bottom)))this.resetLayoutY();
			}
		});

		/**@inheritDoc */
		__getset(0,__proto,'scaleX',_super.prototype._$get_scaleX,function(value){
			if (_super.prototype._$get_scaleX.call(this)!=value){
				_super.prototype._$set_scaleX.call(this,value);
				this.callLater(this.changeSize);
				this._layout.enable && this.resetLayoutX();
			}
		});

		/**@inheritDoc */
		__getset(0,__proto,'scaleY',_super.prototype._$get_scaleY,function(value){
			if (_super.prototype._$get_scaleY.call(this)!=value){
				_super.prototype._$set_scaleY.call(this,value);
				this.callLater(this.changeSize);
				this._layout.enable && this.resetLayoutY();
			}
		});

		/**
		*<p>数据赋值，通过对UI赋值来控制UI显示逻辑。</p>
		*<p>简单赋值会更改组件的默认属性，使用大括号可以指定组件的任意属性进行赋值。</p>
		*@example 以下示例中， <code>label1、checkbox1</code> 分别为示例的name属性值。
		<listing version="3.0">
		//默认属性赋值
		dataSource={label1:"改变了label",checkbox1:true};//(更改了label1的text属性值，更改checkbox1的selected属性)。
		//任意属性赋值
		dataSource={label2:{text:"改变了label",size:14},checkbox2:{selected:true,x:10}};
		</listing>
		*@return
		*/
		__getset(0,__proto,'dataSource',function(){
			return this._dataSource;
			},function(value){
			this._dataSource=value;
			for (var prop in this._dataSource){
				if (this.hasOwnProperty(prop)){
					this[prop]=this._dataSource[prop];
				}
			}
		});

		/**
		*<p>鼠标悬停提示。</p>
		*<p>可以赋值为文本 <code>String</code> 或函数 <code>Function</code> ，用来实现自定义样式的鼠标提示和参数携带等。</p>
		*@example 以下例子展示了三种鼠标提示：
		<listing version="3.0">
		private var _testTips:TestTipsUI=new TestTipsUI();
		private function testTips():void {
			//简单鼠标提示
			btn2.toolTip="这里是鼠标提示&lt;b&gt;粗体&lt;/b&gt;&lt;br&gt;换行";
			//自定义的鼠标提示
			btn1.toolTip=showTips1;
			//带参数的自定义鼠标提示
			clip.toolTip=new Handler(this,showTips2,["clip"]);
		}

		private function showTips1():void {
			_testTips.label.text="这里是按钮["+btn1.label+"]";
			App.tip.addChild(_testTips);
		}

		private function showTips2(name:String):void {
			_testTips.label.text="这里是"+name;
			App.tip.addChild(_testTips);
		}

		</listing>
		*/
		__getset(0,__proto,'toolTip',function(){
			return this._toolTip;
			},function(value){
			if (this._toolTip !=value){
				this._toolTip=value;
				if (value !=null){
					this.on("mouseover",this,this.onMouseOver);
					this.on("mouseout",this,this.onMouseOut);
					}else {
					this.off("mouseover",this,this.onMouseOver);
					this.off("mouseout",this,this.onMouseOut);
				}
			}
		});

		/**
		*<p>从组件顶边到其内容区域顶边之间的垂直距离（以像素为单位）。</p>
		*/
		__getset(0,__proto,'top',function(){
			return this._layout.top;
			},function(value){
			this.getLayout().top=value;
			this.layOutEabled=true;
			this.resetLayoutY();
		});

		/**
		*<p>从组件底边到其内容区域底边之间的垂直距离（以像素为单位）。</p>
		*/
		__getset(0,__proto,'bottom',function(){
			return this._layout.bottom;
			},function(value){
			this.getLayout().bottom=value;
			this.layOutEabled=true;
			this.resetLayoutY();
		});

		/**
		*<p>从组件左边到其内容区域左边之间的水平距离（以像素为单位）。</p>
		*/
		__getset(0,__proto,'left',function(){
			return this._layout.left;
			},function(value){
			this.getLayout().left=value;
			this.layOutEabled=true;
			this.resetLayoutX();
		});

		/**
		*<p>从组件右边到其内容区域右边之间的水平距离（以像素为单位）。</p>
		*/
		__getset(0,__proto,'right',function(){
			return this._layout.right;
			},function(value){
			this.getLayout().right=value;
			this.layOutEabled=true;
			this.resetLayoutX();
		});

		/**
		*<p>在父容器中，此对象的垂直方向中轴线与父容器的垂直方向中心线的距离（以像素为单位）。</p>
		*/
		__getset(0,__proto,'centerY',function(){
			return this._layout.centerY;
			},function(value){
			this.getLayout().centerY=value;
			this.layOutEabled=true;
			this.resetLayoutY();
		});

		/**
		*<p>对象的标签。</p>
		*@internal 冗余字段，可以用来储存数据。
		*/
		__getset(0,__proto,'tag',function(){
			return this._tag;
			},function(value){
			this._tag=value;
		});

		/**
		*<p>指定对象是否可使用布局。</p>
		*<p>如果值为true,则此对象可以使用布局样式，否则不使用布局样式。</p>
		*@param value 一个 Boolean 值，指定对象是否可使用布局。
		*/
		__getset(0,__proto,'layOutEabled',null,function(value){
			if (this._layout.enable !=value){
				this._layout.enable=value;
				if (!this.hasListener("added")){
					this.on("added",this,this.onAdded);
					this.on("removed",this,this.onRemoved);
				}
			}
		});

		/**
		*XML 数据。
		*/
		__getset(0,__proto,'comXml',function(){
			return this._comXml;
			},function(value){
			this._comXml=value;
		});

		/**@inheritDoc */
		__getset(0,__proto,'x',_super.prototype._$get_x,function(value){
			_super.prototype._$set_x.call(this,Math.round(value));
		});

		/**@inheritDoc */
		__getset(0,__proto,'y',_super.prototype._$get_y,function(value){
			_super.prototype._$set_y.call(this,Math.round(value));
		});

		/**是否禁用页面(变灰)。*/
		__getset(0,__proto,'disabled',function(){
			return this._disabled;
			},function(value){
			if (value!==this._disabled){
				this._disabled=value;
				UIUtils.gray(this,value);
			}
		});

		return Component;
	})(Sprite)


	/**
	*<p> <code>Text</code> 类用于创建显示对象以显示文本。</p>
	*@example 以下示例代码，创建了一个 <code>Text</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.display.Text;
		*
		*public class Text_Example
		*{
			*public function Text_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*onInit();
				*}
			*
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
	*</listing>
	*<listing version="3.0">
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
	*</listing>
	*<listing version="3.0">
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
	*</listing>
	*/
	//class laya.display.Text extends laya.display.Sprite
	var Text=(function(_super){
		function Text(){
			this._text=null;
			this._isChanged=false;
			this._textWidth=0;
			this._textHeight=0;
			this._lines=[];
			this._startX=NaN;
			this._startY=NaN;
			this._lastVisibleLineIndex=-1;
			this._clipPoint=null;
			this._currBitmapFont=null;
			Text.__super.call(this);
			this.overflow=Text.VISIBLE;
			this._style=new CSSStyle(this);
			(this._style).wordWrap=false;
		}

		__class(Text,'laya.display.Text',_super);
		var __proto=Text.prototype;
		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			this._lines=null;
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
		__proto.getGraphicBounds=function(){
			var rec=Rectangle.TEMP;
			rec.setTo(0,0,this.width,this.height);
			return rec;
		}

		/**
		*@private
		*@inheritDoc
		*/
		__proto._getCSSStyle=function(){
			return this._style;
		}

		/**
		*<p>根据指定的文本，从语言包中取当前语言的文本内容。并对此文本中的{i}文本进行替换。</p>
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
			text=Text.langPacks ? Text.langPacks[text] :text;
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
		*渲染文字。
		*@param begin 开始渲染的行索引。
		*@param visibleLineCount 渲染的行数。
		*/
		__proto.renderText=function(begin,visibleLineCount){
			var graphics=this.graphics;
			graphics.clear();
			var ctxFont=(this.italic ? "italic " :"")+(this.bold ? "bold " :"")+this.fontSize+"px "+this.font;
			Browser.ctx.font=ctxFont;
			var padding=this.padding;
			var startX=padding[3];
			var textAlgin="left";
			var lines=this._lines;
			var lineHeight=this.leading+this.fontSize;
			var tCurrBitmapFont=this._currBitmapFont;
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
			};
			var x=0,y=0;
			var end=Math.min(this._lines.length,visibleLineCount+begin)|| 1;
			for (var i=begin;i < end;i++){
				var word=lines[i];
				if (style.password){
					var len=word.length;
					word="";
					for (var j=len;j > 0;j--){
						word+="·";
					}
				}
				x=startX-(this._clipPoint ? this._clipPoint.x :0);
				y=startY+lineHeight *i-(this._clipPoint ? this._clipPoint.y :0);
				if (tCurrBitmapFont){
					var tWidth=this.width;
					if (tCurrBitmapFont.autoScaleSize){
						tWidth=this.width *bitmapScale;
					}
					tCurrBitmapFont.drawText(word,this,x,y,this.align,tWidth);
					}else {
					style.stroke ? graphics.fillBorderText(word,x,y,ctxFont,this.color,style.strokeColor,style.stroke,textAlgin):graphics.fillText(word,x,y,ctxFont,this.color,textAlgin);
				}
			}
			if (tCurrBitmapFont && tCurrBitmapFont.autoScaleSize){
				var tScale=1 / bitmapScale;
				this.scale(tScale,tScale);
			}
			if (this._clipPoint)
				graphics.restore();
			this._startX=startX;
			this._startY=startY;
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
				this.graphics.clear();
				return;
			}
			Browser.ctx.font=this._getCSSStyle().font;
			this._lines.length=0;
			this.parseLines(this._text);
			this.evalTextSize();
			if (this.checkEnabledViewportOrNot())
				this._clipPoint || (this._clipPoint=new Point(0,0));
			else
			this._clipPoint=null;
			var endLine=this._lines.length;
			if (this.overflow !=Text.VISIBLE){
				var func=this.overflow==Text.HIDDEN ? Math.floor :Math.ceil;
				endLine=Math.min(endLine,func((this.height-this.padding[0]-this.padding[2])/ (this.leading+this.fontSize)));
			}
			this.renderText(0,endLine);
			this.repaint();
		}

		__proto.evalTextSize=function(){
			this._textWidth=0;
			for (var n=0,len=this._lines.length;n < len;++n){
				var word=this._lines[n];
				this._textWidth=Math.max(this.getTextWidth(word)+this.padding[3]+this.padding[1],this._textWidth);
			}
			if (this._currBitmapFont){
				this._textHeight=this._lines.length *(this._currBitmapFont.getMaxHeight()+this.leading)+this.padding[0]+this.padding[2];
			}else
			this._textHeight=this._lines.length *(this.fontSize+this.leading)+this.padding[0]+this.padding[2];
		}

		__proto.checkEnabledViewportOrNot=function(){
			return this.overflow==Text.SCROLL && ((this._width > 0 && this._textWidth > this._width)|| (this._height > 0 && this._textHeight > this._height));
		}

		/**
		*快速更改显示文本。不进行排版计算，效率较高。
		*<p>如果只更改文字内容，不更改文字样式，建议使用此接口，能提高效率。</p>
		*@param text 文本内容。
		*/
		__proto.changeText=function(text){
			if (this._text!==text){
				this.lang(text);
				if (this._graphics && this._graphics.replaceText(text)){
					}else {
					this.typeset();
				}
			}
		}

		/**
		*@private
		*分析文本换行。
		*/
		__proto.parseLines=function(text){
			var needWordWrapOrTruncate=this.wordWrap || this.overflow==Text.HIDDEN;
			if (needWordWrapOrTruncate){
				var wordWrapWidth=this.getWordWrapWidth();
			};
			var lines=text.split(/\r|\n|\\n/);
			for (var i=0,n=lines.length;i < n;i++){
				if (i < n-1)
					lines[i]+="\n";
				if (needWordWrapOrTruncate)
					this.parseLine(lines[i],wordWrapWidth);
				else
				this._lines[i]=lines[i];
			}
		}

		/**
		*@private
		*解析行文本。
		*@param line 某行的文本。
		*@param wordWrapWidth 文本的显示宽度。
		*/
		__proto.parseLine=function(line,wordWrapWidth){
			var ctx=Browser.ctx;
			var lines=this._lines;
			var maybeIndex=0;
			var execResult;
			var charsWidth=NaN;
			var wordWidth=NaN;
			var startIndex=0;
			charsWidth=this.getTextWidth(line);
			if (charsWidth <=wordWrapWidth){
				lines.push(line);
				return;
			}
			charsWidth=this._currBitmapFont ? this._currBitmapFont.getMaxWidth():Browser.ctx.measureText("阳").width;
			maybeIndex=Math.floor(wordWrapWidth / charsWidth);
			(maybeIndex==0)&& (maybeIndex=1);
			charsWidth=this.getTextWidth(line.substring(0,maybeIndex));
			wordWidth=charsWidth;
			for (var j=maybeIndex,m=line.length;j < m;j++){
				charsWidth=this.getTextWidth(line.charAt(j));
				wordWidth+=charsWidth;
				if (wordWidth > wordWrapWidth){
					if (this.wordWrap){
						var newLine=line.substring(startIndex,j);
						execResult=/\b\w+$/.exec(newLine);
						if (execResult){
							j=execResult.index+startIndex;
							if (execResult.index==0)
								j+=newLine.length;
							else
							newLine=line.substring(startIndex,j);
						}
						lines.push(newLine);
						startIndex=j;
						if (j+maybeIndex < m){
							j+=maybeIndex;
							charsWidth=this.getTextWidth(line.substring(startIndex,j));
							wordWidth=charsWidth;
							j--;
							}else {
							lines.push(line.substring(startIndex,m));
							startIndex=-1;
							break ;
						}
						}else if (this.overflow==Text.HIDDEN){
						lines.push(line.substring(0,j));
						return;
					}
				}
			}
			if (this.wordWrap && startIndex !=-1)
				lines.push(line.substring(startIndex,m));
		}

		__proto.getTextWidth=function(text){
			if (this._currBitmapFont)
				return this._currBitmapFont.getTextWidth(text);
			else
			return Browser.ctx.measureText(text).width;
		}

		/**
		*获取换行所需的宽度。
		*/
		__proto.getWordWrapWidth=function(){
			var p=this.padding;
			var w=NaN;
			if (this._currBitmapFont && this._currBitmapFont.autoScaleSize)
				w=this._width *(this._currBitmapFont.fontSize / this.fontSize);
			else
			w=this._width;
			if (w <=0){
				w=this.wordWrap ? 100 :Browser.width;
			}
			w <=0 && (w=100);
			return w-p[3]-p[1];
		}

		/**
		*返回字符的位置信息。
		*@param charIndex 索引位置。
		*@param out 输出的Point引用。
		*@return 返回Point位置信息。
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
			Browser.ctx.font=ctxFont;
			var width=Browser.ctx.measureText(this._text.substring(startIndex,charIndex)).width;
			var point=out || new Point();
			return point.setTo(this._startX+width-(this._clipPoint ? this._clipPoint.x :0),this._startY+line *(this.fontSize+this.leading)-(this._clipPoint ? this._clipPoint.y :0));
		}

		/**
		*表示文本的高度，以像素为单位。
		*/
		__getset(0,__proto,'textHeight',function(){
			this._isChanged && Laya.timer.runCallLater(this,this.typeset);
			return this._textHeight;
		});

		/**
		*@inheritDoc
		*/
		__getset(0,__proto,'width',function(){
			if (this._width)
				return this._width;
			return this.textWidth;
			},function(value){
			_super.prototype._$set_width.call(this,value);
			this.isChanged=true;
		});

		/**
		*文本的字体名称，以字符串形式表示。
		*<p>默认值为："Arial"，可以通过Text.defaultFont设置默认字体。</p> *
		*@see laya.display.css.Font#defaultFamily
		*/
		__getset(0,__proto,'font',function(){
			return this._getCSSStyle().fontFamily;
			},function(value){
			if (this._currBitmapFont){
				this._currBitmapFont=null;
				this.scale(1,1);
			}
			if (Text.bitmapFonts && Text.bitmapFonts[value]){
				this._currBitmapFont=Text.bitmapFonts[value];
			}
			this._getCSSStyle().fontFamily=value;
			this.isChanged=true;
		});

		/**
		*@inheritDoc
		*/
		__getset(0,__proto,'height',function(){
			if (this._height)
				return this._height;
			return this.textHeight;
			},function(value){
			_super.prototype._$set_height.call(this,value);
			this.isChanged=true;
		});

		/**
		*垂直行间距（以像素为单位）。
		*/
		__getset(0,__proto,'leading',function(){
			return this._getCSSStyle().leading;
			},function(value){
			this._getCSSStyle().leading=value;
			this.isChanged=true;
		});

		/**当前文本的内容字符串。*/
		__getset(0,__proto,'text',function(){
			return this._text;
			},function(value){
			if (this._text!==value){
				this.lang(value+"");
				this.isChanged=true;
				this.event("change");
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
		*指定文本的字体大小（以像素为单位）。
		*<p>默认为20像素，可以通过 <code>Text.defaultSize</code> 设置默认大小。</p>
		*/
		__getset(0,__proto,'fontSize',function(){
			return this._getCSSStyle().fontSize;
			},function(value){
			this._getCSSStyle().fontSize=value;
			this.isChanged=true;
		});

		/**
		*指定文本是否为粗体字。
		*<p>默认值为 false，这意味着不使用粗体字。如果值为 true，则文本为粗体字。</p>
		*/
		__getset(0,__proto,'bold',function(){
			return this._getCSSStyle().bold;
			},function(value){
			this._getCSSStyle().bold=value;
			this.isChanged=true;
		});

		/**
		*表示文本的颜色值。可以通过 <code>Text.defaultColor</code> 设置默认颜色。
		*<p>默认值为黑色。</p>
		*/
		__getset(0,__proto,'color',function(){
			return this._getCSSStyle().color;
			},function(value){
			this._getCSSStyle().color=value;
			if (!this._isChanged && this._graphics){
				this._graphics.replaceTextColor(this.color)
				}else {
				this.isChanged=true;
			}
		});

		/**
		*<p>描边颜色，以字符串表示。</p>
		*默认值为 "#000000"（黑色）;
		*/
		__getset(0,__proto,'strokeColor',function(){
			return this._getCSSStyle().strokeColor;
			},function(value){
			this._getCSSStyle().strokeColor=value;
			this.isChanged=true;
		});

		/**
		*表示使用此文本格式的文本是否为斜体。
		*<p>默认值为 false，这意味着不使用斜体。如果值为 true，则文本为斜体。</p>
		*/
		__getset(0,__proto,'italic',function(){
			return this._getCSSStyle().italic;
			},function(value){
			this._getCSSStyle().italic=value;
			this.isChanged=true;
		});

		/**
		*表示文本的水平显示方式。
		*<p><b>取值：</b>
		*<li>"left"： 居左对齐显示。</li>
		*<li>"center"： 居中对齐显示。</li>
		*<li>"right"： 居右对齐显示。</li>
		*</p>
		*/
		__getset(0,__proto,'align',function(){
			return this._getCSSStyle().align;
			},function(value){
			this._getCSSStyle().align=value;
			this.isChanged=true;
		});

		/**
		*表示文本的垂直显示方式。
		*<p><b>取值：</b>
		*<li>"top"： 居顶部对齐显示。</li>
		*<li>"middle"： 居中对齐显示。</li>
		*<li>"bottom"： 居底部对齐显示。</li>
		*</p>
		*/
		__getset(0,__proto,'valign',function(){
			return this._getCSSStyle().valign;
			},function(value){
			this._getCSSStyle().valign=value;
			this.isChanged=true;
		});

		/**
		*表示文本是否自动换行，默认为false。
		*<p>若值为true，则自动换行；否则不自动换行。</p>
		*/
		__getset(0,__proto,'wordWrap',function(){
			return this._getCSSStyle().wordWrap;
			},function(value){
			this._getCSSStyle().wordWrap=value;
			this.isChanged=true;
		});

		/**
		*边距信息。
		*<p>数据格式：[上边距，右边距，下边距，左边距]（边距以像素为单位）。</p>
		*/
		__getset(0,__proto,'padding',function(){
			return this._getCSSStyle().padding;
			},function(value){
			this._getCSSStyle().padding=value;
			this.isChanged=true;
		});

		/**
		*文本背景颜色，以字符串表示。
		*/
		__getset(0,__proto,'bgColor',function(){
			return this._getCSSStyle().backgroundColor;
			},function(value){
			this._getCSSStyle().backgroundColor=value;
			this.isChanged=true;
		});

		/**
		*文本边框背景颜色，以字符串表示。
		*/
		__getset(0,__proto,'borderColor',function(){
			return this._getCSSStyle().borderColor;
			},function(value){
			this._getCSSStyle().borderColor=value;
			this.isChanged=true;
		});

		/**
		*<p>描边宽度（以像素为单位）。</p>
		*默认值0，表示不描边。
		*/
		__getset(0,__proto,'stroke',function(){
			return this._getCSSStyle().stroke;
			},function(value){
			this._getCSSStyle().stroke=value;
			this.isChanged=true;
		});

		/**
		*<p>指定文本字段是否是密码文本字段。</p>
		*<p>如果此属性的值为 true，则文本字段被视为密码文本字段，并使用星号而不是实际字符来隐藏输入的字符。如果为 false，则不会将文本字段视为密码文本字段。</p>
		*<p>默认值为false。</p>
		*/
		__getset(0,__proto,'asPassword',function(){
			return this._getCSSStyle().password;
			},function(value){
			this._getCSSStyle().password=value;
			this.isChanged=true;
		});

		/**
		*一个布尔值，表示文本的属性是否有改变。若为true表示有改变。
		*/
		__getset(0,__proto,'isChanged',null,function(value){
			if (this._isChanged!==value){
				this._isChanged=value;
				value && Laya.timer.callLater(this,this.typeset);
			}
		});

		/**
		*设置横向滚动量。
		*<p>即使设置超出滚动范围的值，也会被自动限制在可能的最大值处。</p>
		*/
		/**
		*获取横向滚动量。
		*/
		__getset(0,__proto,'scrollX',function(){
			if (!this._clipPoint)
				return 0;
			return this._clipPoint.x;
			},function(value){
			if (this.overflow !=Text.SCROLL || (this.textWidth < this._width || !this._clipPoint))
				return;
			value=value < this.padding[3] ? this.padding[3] :value;
			var maxScrollX=this._textWidth-this._width;
			value=value > maxScrollX ? maxScrollX :value;
			var visibleLineCount=this._height / (this.fontSize+this.leading)| 0+1;
			this._clipPoint.x=value;
			this.renderText(this._lastVisibleLineIndex,visibleLineCount);
		});

		/**
		*设置纵向滚动量（px)。即使设置超出滚动范围的值，也会被自动限制在可能的最大值处。
		*/
		/**
		*获取纵向滚动量。
		*/
		__getset(0,__proto,'scrollY',function(){
			if (!this._clipPoint)
				return 0;
			return this._clipPoint.y;
			},function(value){
			if (this.overflow !=Text.SCROLL || (this.textHeight < this._height || !this._clipPoint))
				return;
			value=value < this.padding[0] ? this.padding[0] :value;
			var maxScrollY=this._textHeight-this._height;
			value=value > maxScrollY ? maxScrollY :value;
			var startLine=value / (this.fontSize+this.leading)| 0;
			this._lastVisibleLineIndex=startLine;
			var visibleLineCount=(this._height / (this.fontSize+this.leading)| 0)+1;
			this._clipPoint.y=value;
			this.renderText(startLine,visibleLineCount);
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

		Text.registerBitmapFont=function(name,bitmapFont){
			Text.bitmapFonts || (Text.bitmapFonts={});
			Text.bitmapFonts[name]=bitmapFont;
		}

		Text.unregisterBitmapFont=function(name,destory){
			(destory===void 0)&& (destory=true);
			if (Text.bitmapFonts && Text.bitmapFonts[name]){
				var tBitmapFont=Text.bitmapFonts[name];
				if (destory){
					tBitmapFont.destory();
				}
				delete Text.bitmapFonts[name];
			}
		}

		Text.langPacks=null
		Text.bitmapFonts=null
		Text.VISIBLE="visible";
		Text.SCROLL="scroll";
		Text.HIDDEN="hidden";
		return Text;
	})(Sprite)


	/**
	*<p> <code>Stage</code> 类是显示对象的根节点。</p>
	*可以通过 Laya.stage 访问。
	*/
	//class laya.display.Stage extends laya.display.Sprite
	var Stage=(function(_super){
		function Stage(){
			this.focus=null;
			this.frameRate="fast";
			this.desginWidth=0;
			this.desginHeight=0;
			this.canvasRotation=false;
			this._screenMode="none";
			this._scaleMode="noscale";
			this._alignV="top";
			this._alignH="left";
			this._bgColor="black";
			this._mouseMoveTime=0;
			this._renderCount=0;
			Stage.__super.call(this);
			this.offset=new Point();
			this.now=Browser.now();
			this._canvasTransform=new Matrix();
			this._preLoopTime=Browser.now();
			this.mouseEnabled=true;
			this._displayInStage=true;
			var _this=this;
			var window=Browser.window;
			window.addEventListener("focus",function(){
				_this.event("focus");
			})
			window.addEventListener("blur",function(){
				_this.event("blur");
			})
			window.addEventListener("resize",function(){
				_this._resetCanvas();
				Laya.timer.once(100,_this,_this._changeCanvasSize);
			})
			window.addEventListener("orientationchange",function(e){
				_this._resetCanvas();
				Laya.timer.once(100,_this,_this._changeCanvasSize);
			})
			this.on("mousemove",this,this._onmouseMove);
		}

		__class(Stage,'laya.display.Stage',_super);
		var __proto=Stage.prototype;
		/**@inheritDoc */
		__proto.size=function(width,height){
			this.desginWidth=this.width=width;
			this.desginHeight=this.height=height;
			Laya.timer.callLater(this,this._changeCanvasSize);
			return this;
		}

		/**@private */
		__proto._changeCanvasSize=function(){
			this.setScreenSize(Browser.clientWidth *Browser.pixelRatio,Browser.clientHeight *Browser.pixelRatio);
		}

		/**@private */
		__proto._resetCanvas=function(){
			var canvas=Render.canvas;
			var canvasStyle=canvas.source.style;
			canvas.size(1,1);
			canvasStyle.transform=canvasStyle.webkitTransform=canvasStyle.msTransform=canvasStyle.mozTransform=canvasStyle.oTransform="";
			this.visible=false;
		}

		/**
		*设置屏幕大小。
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
			var canvas=Render.canvas;
			var canvasStyle=canvas.source.style;
			var mat=this._canvasTransform.identity();
			var scaleMode=this._scaleMode;
			var scaleX=screenWidth / this.desginWidth;
			var scaleY=screenHeight / this.desginHeight;
			var canvasWidth=this.desginWidth;
			var canvasHeight=this.desginHeight;
			var realWidth=screenWidth;
			var realHeight=screenHeight;
			var pixelRatio=Browser.pixelRatio;
			this._width=this.desginWidth;
			this._height=this.desginHeight;
			switch (scaleMode){
				case "noscale":
					scaleX=scaleY=1;
					realWidth=this.desginWidth;
					realHeight=this.desginHeight;
					break ;
				case "showall":
					scaleX=scaleY=Math.min(scaleX,scaleY);
					realWidth=Math.round(this.desginWidth *scaleX);
					realHeight=Math.round(this.desginHeight *scaleY);
					break ;
				case "noborder":
					scaleX=scaleY=Math.max(scaleX,scaleY);
					realWidth=Math.round(this.desginWidth *scaleX);
					realHeight=Math.round(this.desginHeight *scaleY);
					break ;
				case "full":
					scaleX=scaleY=1;
					this._width=canvasWidth=screenWidth;
					this._height=canvasHeight=screenHeight;
					break ;
				case "fixedwidth":
					scaleY=scaleX;
					this._height=screenHeight / scaleX;
					canvasHeight=Math.round(screenHeight / scaleX);
					break ;
				case "fixedheight":
					scaleX=scaleY;
					this._width=screenWidth / scaleY;
					canvasWidth=Math.round(screenWidth / scaleY);
					break ;
				}
			if (scaleX===1 && scaleY===1){
				this.transform && this.transform.identity();
				}else {
				this.transform || (this.transform=new Matrix());
				this.transform.a=scaleX / (realWidth / canvasWidth);
				this.transform.d=scaleY / (realHeight / canvasHeight);
			}
			canvas.size(canvasWidth,canvasHeight);
			System.changeWebGLSize(canvasWidth,canvasHeight);
			mat.scale(realWidth / canvasWidth / pixelRatio,realHeight / canvasHeight / pixelRatio);
			if (this._alignH==="left")this.offset.x=0;
			else if (this._alignH==="right")this.offset.x=screenWidth-realWidth;
			else this.offset.x=(screenWidth-realWidth)*0.5 / pixelRatio;
			if (this._alignV==="top")this.offset.y=0;
			else if (this._alignV==="bottom")this.offset.y=screenHeight-realHeight;
			else this.offset.y=(screenHeight-realHeight)*0.5 / pixelRatio;
			mat.translate(this.offset.x,this.offset.y);
			if (rotation){
				if (this._screenMode==="horizontal"){
					mat.rotate(Math.PI / 2);
					mat.translate(screenHeight / pixelRatio,0);
					}else {
					mat.rotate(-Math.PI / 2);
					mat.translate(0,screenWidth / pixelRatio);
				}
			}
			if (mat.a < 0.00000000000001)mat.a=mat.d=0;
			canvasStyle.transformOrigin=canvasStyle.webkitTransformOrigin=canvasStyle.msTransformOrigin=canvasStyle.mozTransformOrigin=canvasStyle.oTransformOrigin="0px 0px 0px";
			canvasStyle.transform=canvasStyle.webkitTransform=canvasStyle.msTransform=canvasStyle.mozTransform=canvasStyle.oTransform="matrix("+mat.toString()+")";
			this.visible=true;
			this._repaint=1;
			this.event("resize");
		}

		/**@inheritDoc */
		__proto.repaint=function(){
			this._repaint=1;
		}

		/**@inheritDoc */
		__proto.parentRepaint=function(child){}
		/**@private */
		__proto._loop=function(){
			this.render(Render.context,0,0);
			return true;
		}

		/**@private */
		__proto._onmouseMove=function(e){
			this._mouseMoveTime=Browser.now();
		}

		/**@inheritDoc */
		__proto.render=function(context,x,y){
			var loopTime=Browser.now();
			if (Log.enable()&& (loopTime-this.now)> 500){
				Log.print("-------------render delay:"+(Browser.now()-this.now)+"  cound:"+this._renderCount);
			}
			this.now=loopTime;
			this._renderCount++;
			var delay=loopTime-this._preLoopTime;
			var isFastMode=(this.frameRate!=="slow");
			var isDoubleLoop=(this._renderCount % 2===0);
			var ctx=Render.context;
			Stat.renderSlow=!isFastMode;
			if (isFastMode || isDoubleLoop){
				Stat.loopCount++;
				MouseManager.instance.runEvent();
				Laya.timer._update();
				if (this._style.visible){
					Render.isWebGl ? ctx.clear():Render.clear(this._bgColor);
					_super.prototype.render.call(this,context,x,y);
				}
			}
			if (this._style.visible && (isFastMode || !isDoubleLoop)){
				Render.isWebGl && Render.clear(this._bgColor);
				context.flush();
				Render.finish();
			}
			this._preLoopTime=loopTime;
		}

		/**
		*<p>缩放模式。</p>
		*<p><ul>取值范围：
		*<li>"noScale" ：不缩放；</li>
		*<li>"exactFit" ：全屏不等比缩放；</li>
		*<li>"showAll" ：最小比例缩放；</li>
		*<li>"noBorder" ：最大比例缩放；</li>
		*</ul></p>
		*默认值为 "noScale"。
		*/
		__getset(0,__proto,'scaleMode',function(){
			return this._scaleMode;
			},function(value){
			this._scaleMode=value;
			Laya.timer.callLater(this,this._changeCanvasSize);
		});

		/**
		*水平对齐方式。
		*<p><ul>取值范围：
		*<li>"left" ：居左对齐；</li>
		*<li>"center" ：居中对齐；</li>
		*<li>"right" ：居右对齐；</li>
		*</ul></p>
		*默认值为"left"。
		*/
		__getset(0,__proto,'alignH',function(){
			return this._alignH;
			},function(value){
			this._alignH=value;
			Laya.timer.callLater(this,this._changeCanvasSize);
		});

		/**
		*垂直对齐方式。
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
			if (value){
				Render.canvas.source.style.background=value;
				}else {
				Render.canvas.source.style.background="none";
			}
		});

		/**鼠标在 Stage 上的 X 轴坐标。*/
		__getset(0,__proto,'mouseX',function(){
			return Math.round(MouseManager.instance.mouseX / (this._transform ? this._transform.a :1));
		});

		/**鼠标在 Stage 上的 Y 轴坐标。*/
		__getset(0,__proto,'mouseY',function(){
			return Math.round(MouseManager.instance.mouseY / (this._transform ? this._transform.d :1));
		});

		/**当前视窗 X 轴缩放系数。*/
		__getset(0,__proto,'clientScaleX',function(){
			return this._transform ? this._transform.a :1;
		});

		/**当前视窗 Y 轴缩放系数。*/
		__getset(0,__proto,'clientScaleY',function(){
			return this._transform ? this._transform.d :1;
		});

		/**
		*场景布局类型。
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

		Stage.SCALE_NOSCALE="noscale";
		Stage.SCALE_EXACTFIT="exactfit";
		Stage.SCALE_SHOWALL="showall";
		Stage.SCALE_NOBORDER="noborder";
		Stage.SCALE_FULL="full";
		Stage.SCALE_FIXED_WIDTH="fixedwidth";
		Stage.SCALE_FIXED_HEIGHT="fixedheight";
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
		return Stage;
	})(Sprite)


	/**
	*<code>FileBitmap</code> 是图片文件资源类。
	*/
	//class laya.resource.FileBitmap extends laya.resource.Bitmap
	var FileBitmap=(function(_super){
		function FileBitmap(){
			this._src=null;
			this._onload=null;
			this._onerror=null;
			FileBitmap.__super.call(this);
		}

		__class(FileBitmap,'laya.resource.FileBitmap',_super);
		var __proto=FileBitmap.prototype;
		/**
		*载入完成处理函数。
		*/
		__getset(0,__proto,'onload',null,function(value){
		});

		/**
		*文件路径全名。
		*/
		__getset(0,__proto,'src',function(){
			return this._src;
			},function(value){
			this._src=value;
		});

		/**
		*错误处理函数。
		*/
		__getset(0,__proto,'onerror',null,function(value){
		});

		return FileBitmap;
	})(Bitmap)


	/**
	*<code>HTMLCanvas</code> 是 Html Canvas 的代理类，封装了 Canvas 的属性和方法。
	*/
	//class laya.resource.HTMLCanvas extends laya.resource.Bitmap
	var HTMLCanvas=(function(_super){
		function HTMLCanvas(type){
			//this._ctx=null;
			this._is2D=false;
			HTMLCanvas.__super.call(this);
			var _$this=this;
			this._source=this;
			if (type==="2D" || (type==="AUTO" && !Render.isWebGl)){
				this._is2D=true;
				this._source=Browser.createElement("canvas");
				var o=this;
				o.getContext=function (contextID,other){
					if (_$this._ctx)return _$this._ctx;
					var ctx=_$this._ctx=_$this._source.getContext(contextID,other);
					if (ctx){
						ctx._canvas=o;
						ctx.size=function (){
						};
					}
					contextID==="2d" && Context._init(o,ctx);
					return ctx;
				}
			}else this._source={};
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
		*获取 Canvas 渲染上下文。
		*@param contextID 上下文ID.
		*@param other
		*@return Canvas 渲染上下文 Context 对象。
		*/
		__proto.getContext=function(contextID,other){
			return this._ctx ? this._ctx :(this._ctx=HTMLCanvas._createContext(this));
		}

		/**
		*将此对象的成员属性值复制给指定的 Bitmap 对象。
		*@param dec 一个 Bitmap 对象。
		*/
		__proto.copyTo=function(dec){
			_super.prototype.copyTo.call(this,dec);
			(dec)._ctx=this._ctx;
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
			if (this._w !=w || this._h !=h){
				this._w=w;
				this._h=h;
				this._ctx && this._ctx.size(w,h);
				this._source && (this._source.height=h,this._source.width=w);
			}
		}

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

		HTMLCanvas.TYPE2D="2D";
		HTMLCanvas.TYPE3D="3D";
		HTMLCanvas.TYPEAUTO="AUTO";
		HTMLCanvas._createContext=null
		return HTMLCanvas;
	})(Bitmap)


	/**
	*<code>Box</code> 类是一个控件容器类。
	*/
	//class laya.ui.Box extends laya.ui.Component
	var Box=(function(_super){
		function Box(){Box.__super.call(this);;
		};

		__class(Box,'laya.ui.Box',_super);
		var __proto=Box.prototype;
		Laya.imps(__proto,{"laya.ui.IBox":true})
		/**@inheritDoc */
		__getset(0,__proto,'dataSource',_super.prototype._$get_dataSource,function(value){
			this._dataSource=value;
			for (var name in value){
				var comp=this.getChildByName(name);
				if (comp)comp.dataSource=value[name];
				else if (this.hasOwnProperty(name))this[name]=value[name];
			}
		});

		return Box;
	})(Component)


	/**
	*<p><code>Input</code> 类用于创建显示对象以显示和输入文本。</p>
	*
	*@example 以下示例代码，创建了一个 <code>Text</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.display.Input;
		*import laya.events.Event;
		*
		*public class Input_Example
		*{
			*private var input:Input;
			*public function Input_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*onInit();
				*}
			*
			*private function onInit():void
			*{
				*input=new Input();//创建一个 Input 类的实例对象 input 。
				*input.text="这个是一个 Input 文本示例。";
				*input.color="#008fff";//设置 input 的文本颜色。
				*input.font="Arial";//设置 input 的文本字体。
				*input.bold=true;//设置 input 的文本显示为粗体。
				*input.fontSize=30;//设置 input 的字体大小。
				*input.wordWrap=true;//设置 input 的文本自动换行。
				*input.x=100;//设置 input 对象的属性 x 的值，用于控制 input 对象的显示位置。
				*input.y=100;//设置 input 对象的属性 y 的值，用于控制 input 对象的显示位置。
				*input.width=300;//设置 input 的宽度。
				*input.height=200;//设置 input 的高度。
				*input.italic=true;//设置 input 的文本显示为斜体。
				*input.borderColor="#fff000";//设置 input 的文本边框颜色。
				*Laya.stage.addChild(input);//将 input 添加到显示列表。
				*input.on(Event.FOCUS,this,onFocus);//给 input 对象添加获得焦点事件侦听。
				*input.on(Event.BLUR,this,onBlur);//给 input 对象添加失去焦点事件侦听。
				*input.on(Event.INPUT,this,onInput);//给 input 对象添加输入字符事件侦听。
				*input.on(Event.ENTER,this,onEnter);//给 input 对象添加敲回车键事件侦听。
				*}
			*
			*private function onFocus():void
			*{
				*trace("输入框 input 获得焦点。");
				*}
			*
			*private function onBlur():void
			*{
				*trace("输入框 input 失去焦点。");
				*}
			*
			*private function onInput():void
			*{
				*trace("用户在输入框 input 输入字符。文本内容：",input.text);
				*}
			*
			*private function onEnter():void
			*{
				*trace("用户在输入框 input 内敲回车键。");
				*}
			*}
		*}
	*</listing>
	*<listing version="3.0">
	*var input;
	*Input_Example();
	*function Input_Example()
	*{
		*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
		*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
		*onInit();
		*}
	*function onInit()
	*{
		*input=new laya.display.Input();//创建一个 Input 类的实例对象 input 。
		*input.text="这个是一个 Input 文本示例。";
		*input.color="#008fff";//设置 input 的文本颜色。
		*input.font="Arial";//设置 input 的文本字体。
		*input.bold=true;//设置 input 的文本显示为粗体。
		*input.fontSize=30;//设置 input 的字体大小。
		*input.wordWrap=true;//设置 input 的文本自动换行。
		*input.x=100;//设置 input 对象的属性 x 的值，用于控制 input 对象的显示位置。
		*input.y=100;//设置 input 对象的属性 y 的值，用于控制 input 对象的显示位置。
		*input.width=300;//设置 input 的宽度。
		*input.height=200;//设置 input 的高度。
		*input.italic=true;//设置 input 的文本显示为斜体。
		*input.borderColor="#fff000";//设置 input 的文本边框颜色。
		*Laya.stage.addChild(input);//将 input 添加到显示列表。
		*input.on(laya.events.Event.FOCUS,this,onFocus);//给 input 对象添加获得焦点事件侦听。
		*input.on(laya.events.Event.BLUR,this,onBlur);//给 input 对象添加失去焦点事件侦听。
		*input.on(laya.events.Event.INPUT,this,onInput);//给 input 对象添加输入字符事件侦听。
		*input.on(laya.events.Event.ENTER,this,onEnter);//给 input 对象添加敲回车键事件侦听。
		*}
	*function onFocus()
	*{
		*console.log("输入框 input 获得焦点。");
		*}
	*function onBlur()
	*{
		*console.log("输入框 input 失去焦点。");
		*}
	*function onInput()
	*{
		*console.log("用户在输入框 input 输入字符。文本内容：",input.text);
		*}
	*function onEnter()
	*{
		*console.log("用户在输入框 input 内敲回车键。");
		*}
	*</listing>
	*<listing version="3.0">
	*import Input=laya.display.Input;
	*class Input_Example {
		*private input:Input;
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*this.onInit();
			*}
		*private onInit():void {
			*this.input=new Input();//创建一个 Input 类的实例对象 input 。
			*this.input.text="这个是一个 Input 文本示例。";
			*this.input.color="#008fff";//设置 input 的文本颜色。
			*this.input.font="Arial";//设置 input 的文本字体。
			*this.input.bold=true;//设置 input 的文本显示为粗体。
			*this.input.fontSize=30;//设置 input 的字体大小。
			*this.input.wordWrap=true;//设置 input 的文本自动换行。
			*this.input.x=100;//设置 input 对象的属性 x 的值，用于控制 input 对象的显示位置。
			*this.input.y=100;//设置 input 对象的属性 y 的值，用于控制 input 对象的显示位置。
			*this.input.width=300;//设置 input 的宽度。
			*this.input.height=200;//设置 input 的高度。
			*this.input.italic=true;//设置 input 的文本显示为斜体。
			*this.input.borderColor="#fff000";//设置 input 的文本边框颜色。
			*Laya.stage.addChild(this.input);//将 input 添加到显示列表。
			*this.input.on(laya.events.Event.FOCUS,this,this.onFocus);//给 input 对象添加获得焦点事件侦听。
			*this.input.on(laya.events.Event.BLUR,this,this.onBlur);//给 input 对象添加失去焦点事件侦听。
			*this.input.on(laya.events.Event.INPUT,this,this.onInput);//给 input 对象添加输入字符事件侦听。
			*this.input.on(laya.events.Event.ENTER,this,this.onEnter);//给 input 对象添加敲回车键事件侦听。
			*}
		*private onFocus():void {
			*console.log("输入框 input 获得焦点。");
			*}
		*private onBlur():void {
			*console.log("输入框 input 失去焦点。");
			*}
		*private onInput():void {
			*console.log("用户在输入框 input 输入字符。文本内容：",this.input.text);
			*}
		*private onEnter():void {
			*console.log("用户在输入框 input 内敲回车键。");
			*}
		*}
	*</listing>
	*/
	//class laya.display.Input extends laya.display.Text
	var Input=(function(_super){
		function Input(){
			this._focus=false;
			this._multiline=false;
			this._editable=true;
			this._restrictPattern=null;
			this.inputElementXAdjuster=0;
			this.inputElementYAdjuster=0;
			this.title='';
			this.clearOnFocus=false;
			Input.__super.call(this);
			this._maxChars=1E5;
			this._width=100;
			this._height=20;
			this.multiline=false;
			this.overflow=Text.SCROLL;
			this.on("mousedown",this,this.onMouseDown);
			this.on("undisplay",this,this.onUnDisplay);
		}

		__class(Input,'laya.display.Input',_super);
		var __proto=Input.prototype;
		/**@private */
		__proto.onStageDown=function(e){
			if (e.target==this)
				return;
			if ((e.target instanceof laya.display.Input )){
				this.focusOut();
				this.removeNeedlessInputMethod();
			}else
			this.focus=false;
			Laya.stage.off("mousedown",this,this.onStageDown);
		}

		/**@private */
		__proto.onUnDisplay=function(e){
			this.focus=false;
		}

		/**@private */
		__proto.onMouseDown=function(e){
			this.focus=true;
			if (!Browser.onMobile)
				Laya.stage.on("mousedown",this,this.onStageDown);
		}

		/**@inheritDoc */
		__proto.render=function(context,x,y){
			laya.display.Sprite.prototype.render.call(this,context,x,y);
		}

		/**
		*在输入期间，如果 Input 实例的位置改变，调用该方法同步输入框的位置。
		*/
		__proto.syncInputPosition=function(){
			var style=this.nativeInput.style;
			var stage=Laya.stage;
			var rec;
			rec=Utils.getGlobalPosAndScale(this);
			var a=stage._canvasTransform.a,d=stage._canvasTransform.d;
			style.left=(rec.x+this.padding[3]+this.inputElementXAdjuster)*stage.clientScaleX *a+stage.offset.x+"px";
			style.top=(rec.y+this.padding[0]+this.inputElementYAdjuster)*stage.clientScaleY *d+stage.offset.y+"px";
			if (!this._getVisible())this.focus=false;
			if (stage.transform || rec.width !=1 || rec.height !=1){
				var ts="scale("+stage.clientScaleX *a *rec.width+","+stage.clientScaleY *d *rec.height+")";
				if (ts !=style.transform){
					style.transformOrigin="0 0";
					style.transform=ts;
				}
			}
		}

		/**@private */
		__proto._getVisible=function(){
			var target=this;
			while (target){
				if (target.visible===false)return false;
				target=target.parent;
			}
			return true;
		}

		/**选中所有文本。*/
		__proto.select=function(){
			this.nativeInput.select();
		}

		__proto.focusIn=function(){
			var input=this.nativeInput;
			this._focus=true;
			var cssText=Input.cssStyle;
			cssText+=";white-space:"+(this.wordWrap ? "normal" :"nowrap");
			input.readOnly=!this._editable;
			input.maxLength=this._maxChars;
			var padding=this.padding;
			var inputWid=this._width-padding[1]-padding[3];
			var inputHei=this._height-padding[0]-padding[2];
			cssText+=";width:"+inputWid+"px";
			cssText+=";height:"+inputHei+"px";
			cssText+=";color:"+this.color;
			cssText+=";font-size:"+this.fontSize+"px";
			cssText+=";font-family:"+this.font;
			cssText+=";line-height:"+(this.leading+this.fontSize)+"px";
			cssText+=";font-style:"+(this.italic ? "italic" :"normal");
			cssText+=";font-weight:"+(this.bold ? "bold" :"normal");
			cssText+=";text-align:"+this.align;
			var temp=this._text;
			input.value=temp;
			this._text="";
			this.typeset();
			this._text=temp;
			input.style.cssText=cssText;
			input.type=this.asPassword ? "password" :"input";
			input.focus();
			Laya.stage.off("keydown",this,this.onKeyDown);
			Laya.stage.on("keydown",this,this.onKeyDown);
			Laya.stage.focus=this;
			this.event("focus");
			Laya.timer.frameLoop(1,this,this.syncInputPosition);
		}

		__proto.focusOut=function(){
			this._focus=false;
			var temp=this._text || "";
			this._text="";
			_super.prototype._$set_text.call(this,temp);
			Laya.stage.off("keydown",this,this.onKeyDown);
			Laya.stage.focus=null;
			this.event("blur");
			Browser.document.body.scrollTop=0;
			Laya.timer.clear(this,this.syncInputPosition);
		}

		__proto.removeNeedlessInputMethod=function(){
			var body=Browser.document.body;
			if (!this._multiline && body.contains(Input.input)&& body.contains(Input.area))
				Browser.document.body.removeChild(Input.input);
			else if (this._multiline && body.contains(Input.area)&& body.contains(Input.input))
			Browser.document.body.removeChild(Input.area);
		}

		/**@private */
		__proto.onKeyDown=function(e){
			if (e.keyCode===13)this.event("enter");
		}

		/**表示是否是多行输入框。*/
		__getset(0,__proto,'multiline',function(){
			return this._multiline;
			},function(value){
			this._multiline=value;
			this.valign=value ? "top" :"middle";
			if (!Browser.onMobile){
				if (value){
					Input.area || Input.initInput(Input.area=Browser.createElement("textarea"));
					}else {
					Input.input || Input.initInput(Input.input=Browser.createElement("input"));
				}
			}
		});

		/**@inheritDoc */
		__getset(0,__proto,'color',_super.prototype._$get_color,function(value){
			if (this._focus)
				this.nativeInput.style.color=value;
			_super.prototype._$set_color.call(this,value);
		});

		/**
		*获取对输入框的引用实例。
		*/
		__getset(0,__proto,'nativeInput',function(){
			return this._multiline ? Input.area :Input.input;
		});

		// 因此 调用focus接口是无法都在移动平台立刻弹出键盘的
		/**
		*表示焦点是否在显示对象上。
		*/
		__getset(0,__proto,'focus',function(){
			return this._focus;
			},function(value){
			if (Browser.onMobile){
				if (value && this._editable){
					var str=Browser.window.prompt(this.clearOnFocus ? '' :(this.title,this._text || ''));
					if (str !=null){
						if (this._restrictPattern)
							str=str.replace(this._restrictPattern,'');
						this.text=str;
						this.event("input");
						this.event("blur");
					}
				}
				return;
			};
			var input=this.nativeInput;
			if (this._focus!==value){
				laya.display.Input.isInputting=value;
				if (value){
					input.target && (input.target.focus=false);
					input.target=this;
					Browser.document.body.appendChild(input);
					this.focusIn();
					}else {
					input.target=null;
					this.focusOut();
					Browser.document.body.removeChild(input);
				}
			}
		});

		/**@inheritDoc */
		__getset(0,__proto,'text',function(){
			if (this._focus)
				return this.nativeInput.value;
			else
			return this._text;
			},function(value){
			if (this._focus){
				this.nativeInput.value=value || '';
			}
			_super.prototype._$set_text.call(this,value);
		});

		/**
		*字符数量限制，默认为10000。
		*设置字符数量限制时，小于等于0的值将会限制字符数量为10000。
		*/
		__getset(0,__proto,'maxChars',function(){
			return this._maxChars;
			},function(value){
			if (value <=0)
				value=1E5;
			this._maxChars=value;
		});

		/**限制输入的字符。*/
		__getset(0,__proto,'restrict',function(){
			return this._restrictPattern.source;
			},function(pattern){
			if (pattern){
				pattern="[^"+pattern+"]";
				if (pattern.indexOf("^^")>-1)
					pattern=pattern.replace("^^","");
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
		});

		Input.getActiveInput=function(){
			if (Browser.document.body.contains(Input.input))
				return Input.input;
			else if (Browser.document.body.contains(Input.area))
			return Input.area;
			return null;
		}

		Input.initInput=function(input){
			var style=input.style;
			style.cssText=Input.cssStyle;
			input.addEventListener('input',function(e){
				var target=input.target;
				if (!target)
					return;
				var value=input.value;
				if (target._restrictPattern){
					value=value.replace(target._restrictPattern,"");
					input.value=value;
				}
				target._text=value;
				target.event("input");
			});
			input.addEventListener('mousemove',Input._stopEvent);
			input.addEventListener('mousedown',Input._stopEvent);
			input.addEventListener('touchmove',Input._stopEvent);
		}

		Input._stopEvent=function(e){
			e.stopPropagation();
		}

		Input.cssStyle="position:absolute;background-color:transparent;border:none;outline:none;resize:none;overflow:hidden;z-index:999";
		Input.input=null
		Input.area=null
		Input.inputHeight=50;
		Input.textAreaHeight=75;
		Input.inputFontSize=25;
		Input.borderStyle="3px solid orange";
		Input.backgroundStyle="Linen";
		Input.isInputting=false;
		return Input;
	})(Text)


	/**
	*<code>Button</code> 组件用来表示常用的多态按钮。 <code>Button</code> 组件可显示文本标签、图标或同时显示两者。 *
	*<p>可以是单态，两态和三态，默认三态(up,over,down)。</p>
	*
	*@example 以下示例代码，创建了一个 <code>Button</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.Button;
		*import laya.utils.Handler;
		*
		*public class Button_Example
		*{
			*public function Button_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load("resource/ui/button.png",Handler.create(this,onLoadComplete));//加载资源。
				*}
			*private function onLoadComplete():void
			*{
				*trace("资源加载完成！");
				*var button:Button=new Button("resource/ui/button.png","label");//创建一个 Button 类的实例对象 button ,并传入它的皮肤。
				*button.x=100;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
				*button.y=100;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
				*button.clickHandler=new Handler(this,onClickButton,[button]);//设置 button 的点击事件处理器。
				*Laya.stage.addChild(button);//将此 button 对象添加到显示列表。
				*}
			*
			*private function onClickButton(button:Button):void
			*{
				*trace("按钮button被点击了！");
				*}
			*}
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
	*Laya.loader.load("resource/ui/button.png",laya.utils.Handler.create(this,loadComplete));//加载资源
	*function loadComplete()
	*{
		*console.log("资源加载完成！");
		*var button=new laya.ui.Button("resource/ui/button.png","label");//创建一个 Button 类的实例对象 button ,传入它的皮肤skin和标签label。
		*button.x=100;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
		*button.y=100;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
		*button.clickHandler=laya.utils.Handler.create(this,onClickButton,[button],false);//设置 button 的点击事件处理函数。
		*Laya.stage.addChild(button);//将此 button 对象添加到显示列表。
		*}
	*function onClickButton(button)
	*{
		*console.log("按钮被点击了。",button);
		*}
	*</listing>
	*<listing version="3.0">
	*import Button=laya.ui.Button;
	*import Handler=laya.utils.Handler;
	*class Button_Example{
		*constructor()
		*{
			*Laya.init(640,800);
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load("resource/ui/button.png",laya.utils.Handler.create(this,this.onLoadComplete));//加载资源。
			*}
		*private onLoadComplete()
		*{
			*var button:Button=new Button("resource/ui/button.png","label");//创建一个 Button 类的实例对象 button ,并传入它的皮肤。
			*button.x=100;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
			*button.y=100;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
			*button.clickHandler=new Handler(this,this.onClickButton,[button]);//设置 button 的点击事件处理器。
			*Laya.stage.addChild(button);//将此 button 对象添加到显示列表。
			*}
		*private onClickButton(button:Button):void
		*{
			*console.log("按钮button被点击了！")
			*}
		*}
	*</listing>
	*/
	//class laya.ui.Button extends laya.ui.Component
	var Button=(function(_super){
		function Button(skin,label){
			this.toggle=false;
			this._bitmap=null;
			this._text=null;
			this._strokeColors=null;
			this._state=0;
			this._selected=false;
			this._skin=null;
			this._autoSize=true;
			this._sources=null;
			this._clickHandler=null;
			Button.__super.call(this);
			this._labelColors=Styles.buttonLabelColors;
			this._stateNum=Styles.buttonStateNum;
			(label===void 0)&& (label="");
			this.skin=skin;
			this.label=label;
		}

		__class(Button,'laya.ui.Button',_super);
		var __proto=Button.prototype;
		Laya.imps(__proto,{"laya.ui.ISelect":true})
		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			this._bitmap && this._bitmap.destroy();
			this._text && this._text.destroy(destroyChild);
			this._sources && (this._sources.length=0);
			this._bitmap=null;
			this._text=null;
			this._clickHandler=null;
			this._labelColors=this._sources=this._strokeColors=null;
		}

		/**@inheritDoc */
		__proto.createChildren=function(){
			this.graphics=this._bitmap=new AutoBitmap();
			this._text=new Text();
			this._text.align="center";
			this._text.valign="middle";
		}

		/**@inheritDoc */
		__proto.initialize=function(){
			this.on("mouseover",this,this.onMouse);
			this.on("mouseout",this,this.onMouse);
			this.on("mousedown",this,this.onMouse);
			this.on("mouseup",this,this.onMouse);
			this.on("click",this,this.onMouse);
		}

		/**
		*对象的 <code>Event.MOUSE_OVER、Event.MOUSE_OUT、Event.MOUSE_DOWN、Event.MOUSE_UP、Event.CLICK</code> 事件侦听处理函数。
		*@param e Event 对象。
		*/
		__proto.onMouse=function(e){
			if ((this.toggle===false && this._selected)|| this.disabled)return;
			if (e.type==="click"){
				this.toggle && (this.selected=!this._selected);
				this._clickHandler && this._clickHandler.run();
				return;
			}
			!this._selected && (this.state=Button.stateMap[e.type]);
		}

		/**
		*@private
		*对象的资源切片发生改变。
		*/
		__proto.changeClips=function(){
			var img=Loader.getRes(this._skin);
			if (!img){
				console.log("lose skin",this._skin);
				return;
			}
			this._sources || (this._sources=[]);
			this._sources.length=0;
			var width=img.width;
			var height=img.height / this._stateNum;
			for (var i=0;i < this._stateNum;i++){
				this._sources.push(Texture.create(img,0,height *i,width,height));
			}
			if (this._autoSize){
				this._bitmap.width=this._text.width=this._width || width;
				this._bitmap.height=this._text.height=this._height || height;
				}else {
				this._text.x=width;
			}
		}

		/**
		*@private
		*改变对象的状态。
		*/
		__proto.changeState=function(){
			this.runCallLater(this.changeClips);
			var index=this._state < this._stateNum ? this._state :this._stateNum-1;
			this._sources && (this._bitmap.source=this._sources[index]);
			if (this.label){
				this._text.color=this._labelColors[index];
				if (this._strokeColors)this._text.strokeColor=this._strokeColors[index];
			}
		}

		/**
		*<p>描边颜色，以字符串表示。</p>
		*默认值为 "#000000"（黑色）;
		*@see laya.display.Text.strokeColor()
		*/
		__getset(0,__proto,'labelStrokeColor',function(){
			return this._text.strokeColor;
			},function(value){
			this._text.strokeColor=value
		});

		/**
		*<p>对象的皮肤资源地址。</p>
		*支持单态，两态和三态，用 <code>stateNum</code> 属性设置
		*<p>对象的皮肤地址，以字符串表示。</p>
		*@see #stateNum
		*/
		__getset(0,__proto,'skin',function(){
			return this._skin;
			},function(value){
			if (this._skin !=value){
				this._skin=value;
				this.callLater(this.changeClips);
				this.callLater(this.changeState);
			}
		});

		/**
		*对象的状态值。
		*@see #stateMap
		*/
		__getset(0,__proto,'state',function(){
			return this._state;
			},function(value){
			if (this._state !=value){
				this._state=value;
				this.callLater(this.changeState);
			}
		});

		/**
		*按钮的文本内容。
		*/
		__getset(0,__proto,'label',function(){
			return this._text.text;
			},function(value){
			if (this._text.text !=value){
				value && !this._text.displayInStage && this.addChild(this._text);
				this._text.text=value;
				this.callLater(this.changeState);
			}
		});

		/**
		*<p>指定对象的状态值，以数字表示。</p>
		*<p>默认值为3。此值决定皮肤资源图片的切割方式。</p>
		*<p><b>取值：</b>
		*<li>1：单态。图片不做切割，按钮的皮肤状态只有一种。</li>
		*<li>2：两态。图片将以竖直方向被等比切割为2部分，从上向下，依次为
		*弹起状态皮肤、
		*按下和经过及选中状态皮肤。</li>
		*<li>3：三态。图片将以竖直方向被等比切割为2部分，从上向下，依次为
		*弹起状态皮肤、
		*经过状态皮肤、
		*按下和选中状态皮肤</li>
		*</p>
		*/
		__getset(0,__proto,'stateNum',function(){
			return this._stateNum;
			},function(value){
			if (this._stateNum !=value){
				this._stateNum=value < 1 ? 1 :value > 3 ? 3 :value;
				this.callLater(this.changeClips);
			}
		});

		/**
		*表示按钮各个状态下的描边颜色。
		*<p><b>格式:</b> "upColor,overColor,downColor,disableColor"。</p>
		*/
		__getset(0,__proto,'strokeColors',function(){
			return this._strokeColors ? this._strokeColors.join(","):"";
			},function(value){
			this._strokeColors=UIUtils.fillArray(Styles.buttonLabelColors,value,String);
			this.callLater(this.changeState);
		});

		/**
		*<p>描边宽度（以像素为单位）。</p>
		*默认值0，表示不描边。
		*@see laya.display.Text.stroke()
		*/
		__getset(0,__proto,'labelStroke',function(){
			return this._text.stroke;
			},function(value){
			this._text.stroke=value
		});

		/**
		*@inheritDoc
		*/
		__getset(0,__proto,'measureHeight',function(){
			this.runCallLater(this.changeClips);
			return this._bitmap.height;
		});

		/**
		*@inheritDoc
		*/
		__getset(0,__proto,'measureWidth',function(){
			this.runCallLater(this.changeClips);
			if (this._autoSize)return this._bitmap.width;
			this.runCallLater(this.changeState);
			return this._bitmap.width+this._text.width;
		});

		/**
		*表示按钮的选中状态。
		*<p>如果值为true，表示该对象处于选中状态。否则该对象处于未选中状态。</p>
		*/
		__getset(0,__proto,'selected',function(){
			return this._selected;
			},function(value){
			if (this._selected !=value){
				this._selected=value;
				this.state=this._selected ? 2 :0;
				this.event("change");
			}
		});

		/**
		*表示按钮各个状态下的文本颜色。
		*<p><b>格式:</b> "upColor,overColor,downColor,disableColor"。</p>
		*/
		__getset(0,__proto,'labelColors',function(){
			return this._labelColors.join(",");
			},function(value){
			this._labelColors=UIUtils.fillArray(Styles.buttonLabelColors,value,String);
			this.callLater(this.changeState);
		});

		/**
		*表示按钮文本标签的边距。
		*<p><b>格式：</b>"上边距,右边距,下边距,左边距"。</p>
		*/
		__getset(0,__proto,'labelPadding',function(){
			return this._text.padding.join(",");
			},function(value){
			this._text.padding=UIUtils.fillArray(Styles.labelPadding,value,Number);
		});

		/**
		*表示按钮文本标签的字体大小。
		*@see laya.display.Text.fontSize()
		*/
		__getset(0,__proto,'labelSize',function(){
			return this._text.fontSize;
			},function(value){
			this._text.fontSize=value
		});

		/**
		*表示按钮文本标签是否为粗体字。
		*@see laya.display.Text.bold()
		*/
		__getset(0,__proto,'labelBold',function(){
			return this._text.bold;
			},function(value){
			this._text.bold=value;
		});

		/**标签对齐模式，默认为居中对齐。*/
		__getset(0,__proto,'labelAlign',function(){
			return this._text.align;
			},function(value){
			this._text.align=value;
		});

		/**
		*表示按钮文本标签的字体名称，以字符串形式表示。
		*@see laya.display.Text.font()
		*/
		__getset(0,__proto,'labelFont',function(){
			return this._text.font;
			},function(value){
			this._text.font=value;
		});

		/**
		*对象的点击事件处理器函数（无默认参数）。
		*/
		__getset(0,__proto,'clickHandler',function(){
			return this._clickHandler;
			},function(value){
			this._clickHandler=value;
		});

		/**
		*按钮文本标签 <code>Text</code> 控件。
		*/
		__getset(0,__proto,'text',function(){
			return this._text;
		});

		/**
		*<p>当前实例的位图 <code>AutoImage</code> 实例的有效缩放网格数据。</p>
		*<p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
		*<ul><li>例如："4,4,4,4,1"</li></ul></p>
		*@see laya.ui.AutoBitmap.sizeGrid
		*/
		__getset(0,__proto,'sizeGrid',function(){
			if (this._bitmap.sizeGrid)return this._bitmap.sizeGrid.join(",");
			return null;
			},function(value){
			this._bitmap.sizeGrid=UIUtils.fillArray(Styles.defaultSizeGrid,value,Number);
		});

		/**@inheritDoc */
		__getset(0,__proto,'width',_super.prototype._$get_width,function(value){
			_super.prototype._$set_width.call(this,value);
			if (this._autoSize){
				this._bitmap.width=value;
				this._text.width=value;
			}
		});

		/**@inheritDoc */
		__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
			_super.prototype._$set_height.call(this,value);
			if (this._autoSize){
				this._bitmap.height=value;
				this._text.height=value;
			}
		});

		/**@inheritDoc */
		__getset(0,__proto,'dataSource',_super.prototype._$get_dataSource,function(value){
			this._dataSource=value;
			if ((typeof value=='number')|| (typeof value=='string'))this.label=value+"";
			else _super.prototype._$set_dataSource.call(this,value);
		});

		__static(Button,
		['stateMap',function(){return this.stateMap={"mouseup":0,"mouseover":1,"mousedown":2,"mouseout":0};}
		]);
		return Button;
	})(Component)


	/**
	*<p> <code>Clip</code> 类是位图切片动画。</p>
	*<p> <code>Clip</code> 可将一张图片，按横向分割数量 <code>clipX</code> 、竖向分割数量 <code>clipY</code> ，
	*或横向分割每个切片的宽度 <code>clipWidth</code> 、竖向分割每个切片的高度 <code>clipHeight</code> ，
	*从左向右，从上到下，分割组合为一个切片动画。</p>
	*
	*@example 以下示例代码，创建了一个 <code>Clip</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.Clip;
		*
		*public class Clip_Example
		*{
			*private var clip:Clip;
			*
			*public function Clip_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*onInit();
				*}
			*
			*private function onInit():void
			*{
				*clip=new Clip("resource/ui/clip_num.png",10,1);//创建一个 Clip 类的实例对象 clip ,传入它的皮肤skin和横向分割数量、竖向分割数量。
				*clip.autoPlay=true;//设置 clip 动画自动播放。
				*clip.interval=100;//设置 clip 动画的播放时间间隔。
				*clip.x=100;//设置 clip 对象的属性 x 的值，用于控制 clip 对象的显示位置。
				*clip.y=100;//设置 clip 对象的属性 y 的值，用于控制 clip 对象的显示位置。
				*clip.on(Event.CLICK,this,onClick);//给 clip 添加点击事件函数侦听。
				*Laya.stage.addChild(clip);//将此 clip 对象添加到显示列表。
				*}
			*
			*private function onClick():void
			*{
				*trace("clip 的点击事件侦听处理函数。clip.total="+clip.total);
				*if (clip.isPlaying==true)
				*{
					*clip.stop();//停止动画。
					*}else {
					*clip.play();//播放动画。
					*}
				*}
			*}
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*var clip;
	*Laya.loader.load("resource/ui/clip_num.png",laya.utils.Handler.create(this,loadComplete));//加载资源
	*
	*function loadComplete(){
		*console.log("资源加载完成！");
		*clip=new laya.ui.Clip("resource/ui/clip_num.png",10,1);//创建一个 Clip 类的实例对象 clip ,传入它的皮肤skin和横向分割数量、竖向分割数量。
		*clip.autoPlay=true;//设置 clip 动画自动播放。
		*clip.interval=100;//设置 clip 动画的播放时间间隔。
		*clip.x=100;//设置 clip 对象的属性 x 的值，用于控制 clip 对象的显示位置。
		*clip.y=100;//设置 clip 对象的属性 y 的值，用于控制 clip 对象的显示位置。
		*clip.on(Event.CLICK,this,onClick);//给 clip 添加点击事件函数侦听。
		*Laya.stage.addChild(clip);//将此 clip 对象添加到显示列表。
		*}
	*function onClick()
	*{
		*console.log("clip 的点击事件侦听处理函数。");
		*if(clip.isPlaying==true)
		*{
			*clip.stop();
			*}else {
			*clip.play();
			*}
		*}
	*</listing>
	*<listing version="3.0">
	*import Clip=laya.ui.Clip;
	*import Handler=laya.utils.Handler;
	*class Clip_Example {
		*private clip:Clip;
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*this.onInit();
			*}
		*
		*private onInit():void {
			*this.clip=new Clip("resource/ui/clip_num.png",10,1);//创建一个 Clip 类的实例对象 clip ,传入它的皮肤skin和横向分割数量、竖向分割数量。
			*this.clip.autoPlay=true;//设置 clip 动画自动播放。
			*this.clip.interval=100;//设置 clip 动画的播放时间间隔。
			*this.clip.x=100;//设置 clip 对象的属性 x 的值，用于控制 clip 对象的显示位置。
			*this.clip.y=100;//设置 clip 对象的属性 y 的值，用于控制 clip 对象的显示位置。
			*this.clip.on(laya.events.Event.CLICK,this,this.onClick);//给 clip 添加点击事件函数侦听。
			*Laya.stage.addChild(this.clip);//将此 clip 对象添加到显示列表。
			*}
		*private onClick():void {
			*console.log("clip 的点击事件侦听处理函数。clip.total="+this.clip.total);
			*if (this.clip.isPlaying==true){
				*this.clip.stop();//停止动画。
				*}else {
				*this.clip.play();//播放动画。
				*}
			*}
		*}
	*
	*</listing>
	*/
	//class laya.ui.Clip extends laya.ui.Component
	var Clip=(function(_super){
		function Clip(url,clipX,clipY){
			this._sources=null;
			this._bitmap=null;
			this._skin=null;
			this._clipX=1;
			this._clipY=1;
			this._clipWidth=0;
			this._clipHeight=0;
			this._autoPlay=false;
			this._interval=50;
			this._complete=null;
			this._isPlaying=false;
			this._index=0;
			Clip.__super.call(this);
			(clipX===void 0)&& (clipX=1);
			(clipY===void 0)&& (clipY=1);
			this._clipX=clipX;
			this._clipY=clipY;
			this.skin=url;
		}

		__class(Clip,'laya.ui.Clip',_super);
		var __proto=Clip.prototype;
		/**@inheritDoc */
		__proto.destroy=function(clearFromCache){
			(clearFromCache===void 0)&& (clearFromCache=false);
			_super.prototype.destroy.call(this,true);
			this._bitmap && this._bitmap.destroy();
			this._bitmap=null;
			this._sources=null;
		}

		/**
		*销毁对象并释放加载的皮肤资源。
		*/
		__proto.dispose=function(){
			this.destroy(true);
			Laya.loader.clearRes(this._skin);
		}

		/**@inheritDoc */
		__proto.createChildren=function(){
			this.graphics=this._bitmap=new AutoBitmap();
		}

		/**@inheritDoc */
		__proto.initialize=function(){
			this.on("display",this,this._onDisplay);
			this.on("undisplay",this,this._onDisplay);
		}

		/**@private */
		__proto._onDisplay=function(e){
			if (this._isPlaying){
				if (this._displayInStage)this.play();
				else this.stop();
				}else if (this._autoPlay && this._displayInStage){
				this.play();
			}
		}

		/**
		*@private
		*改变切片的资源、切片的大小。
		*/
		__proto.changeClip=function(){
			var img=Loader.getRes(this._skin);
			if (img){
				this.loadComplete(this._skin,img);
				}else {
				Laya.loader.load(this._skin,Handler.create(this,this.loadComplete,[this._skin]));
			}
		}

		/**
		*@private
		*加载切片图片资源完成函数。
		*@param url 资源地址。
		*@param img 纹理。
		*/
		__proto.loadComplete=function(url,img){
			if (url===this._skin && img){
				this._clipWidth || (this._clipWidth=Math.ceil(img.width / this._clipX));
				this._clipHeight || (this._clipHeight=Math.ceil(img.height / this._clipY));
				this._sources || (this._sources=[]);
				this._sources.length=0;
				for (var i=0;i < this._clipY;i++){
					for (var j=0;j < this._clipX;j++){
						this._sources.push(Texture.create(img,this._clipWidth *j,this._clipHeight *i,this._clipWidth,this._clipHeight));
					}
				}
				this.index=this._index;
				this.event("loaded");
				this.onCompResize();
			}
		}

		/**
		*播放动画。
		*/
		__proto.play=function(){
			this._isPlaying=true;
			this._index=0;
			Laya.timer.loop(this.interval,this,this._loop);
		}

		/**
		*@private
		*/
		__proto._loop=function(){
			if (this._style.visible && this._sources){
				this.index=this._index,this._index++;
				this._index >=this._sources.length && (this._index=0);
			}
		}

		/**
		*停止动画。
		*/
		__proto.stop=function(){
			this._isPlaying=false;
			Laya.timer.clear(this,this._loop);
		}

		/**
		*表示是否自动播放动画，若自动播放值为true,否则值为false;
		*<p>可控制切片动画的播放、停止。</p>
		*/
		__getset(0,__proto,'autoPlay',function(){
			return this._autoPlay;
			},function(value){
			if (this._autoPlay !=value){
				this._autoPlay=value;
				value ? this.play():this.stop();
			}
		});

		/**X轴（横向）切片数量。*/
		__getset(0,__proto,'clipX',function(){
			return this._clipX;
			},function(value){
			this._clipX=value;
			this.callLater(this.changeClip);
		});

		/**
		*@copy laya.ui.Image#skin
		*/
		__getset(0,__proto,'skin',function(){
			return this._skin;
			},function(value){
			this._skin=value;
			this.callLater(this.changeClip);
		});

		/**
		*源数据。
		*/
		__getset(0,__proto,'sources',function(){
			return this._sources;
			},function(value){
			this._sources=value;
			this.index=this._index;
			this.event("loaded");
		});

		/**Y轴(竖向)切片数量。*/
		__getset(0,__proto,'clipY',function(){
			return this._clipY;
			},function(value){
			this._clipY=value;
			this.callLater(this.changeClip);
		});

		/**
		*横向分割时每个切片的宽度，与 <code>clipX</code> 同时设置时优先级高于 <code>clipX</code> 。
		*/
		__getset(0,__proto,'clipWidth',function(){
			return this._clipWidth;
			},function(value){
			this._clipWidth=value;
			this.callLater(this.changeClip);
		});

		/**@inheritDoc */
		__getset(0,__proto,'measureWidth',function(){
			this.runCallLater(this.changeClip);
			return this._bitmap.width;
		});

		/**
		*竖向分割时每个切片的高度，与 <code>clipY</code> 同时设置时优先级高于 <code>clipY</code> 。
		*/
		__getset(0,__proto,'clipHeight',function(){
			return this._clipHeight;
			},function(value){
			this._clipHeight=value;
			this.callLater(this.changeClip);
		});

		/**
		*切片动画的总帧数。
		*/
		__getset(0,__proto,'total',function(){
			this.runCallLater(this.changeClip);
			return this._sources ? this._sources.length :0;
		});

		/**@inheritDoc */
		__getset(0,__proto,'width',_super.prototype._$get_width,function(value){
			_super.prototype._$set_width.call(this,value);
			this._bitmap.width=value;
		});

		/**@inheritDoc */
		__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
			_super.prototype._$set_height.call(this,value);
			this._bitmap.height=value;
		});

		/**@inheritDoc */
		__getset(0,__proto,'measureHeight',function(){
			this.runCallLater(this.changeClip);
			return this._bitmap.height;
		});

		/**
		*<p>当前实例的位图 <code>AutoImage</code> 实例的有效缩放网格数据。</p>
		*<p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
		*<ul><li>例如："4,4,4,4,1"</li></ul></p>
		*@see laya.ui.AutoBitmap.sizeGrid
		*/
		__getset(0,__proto,'sizeGrid',function(){
			if (this._bitmap.sizeGrid)return this._bitmap.sizeGrid.join(",");
			return null;
			},function(value){
			this._bitmap.sizeGrid=UIUtils.fillArray(Styles.defaultSizeGrid,value,Number);
		});

		/**
		*当前帧索引。
		*/
		__getset(0,__proto,'index',function(){
			return this._index;
			},function(value){
			this._index=value;
			this._bitmap && this._sources && (this._bitmap.source=this._sources[value]);
			this.event("change");
		});

		/**
		*表示动画播放间隔时间(以毫秒为单位)。
		*/
		__getset(0,__proto,'interval',function(){
			return this._interval;
			},function(value){
			if (this._interval !=value){
				this._interval=value;
				if (this._isPlaying)this.play();
			}
		});

		/**
		*表示动画的当前播放状态。
		*如果动画正在播放中，则为true，否则为flash。
		*/
		__getset(0,__proto,'isPlaying',function(){
			return this._isPlaying;
			},function(value){
			this._isPlaying=value;
		});

		/**@inheritDoc */
		__getset(0,__proto,'dataSource',_super.prototype._$get_dataSource,function(value){
			this._dataSource=value;
			if (((typeof value=='number')&& Math.floor(value)==value)|| (typeof value=='string'))this.index=Laya.__parseInt(value);
			else _super.prototype._$set_dataSource.call(this,value);
		});

		/**
		*<code>AutoBitmap</code> 位图实例。
		*/
		__getset(0,__proto,'bitmap',function(){
			return this._bitmap;
		});

		return Clip;
	})(Component)


	/**
	*<code>ColorPicker</code> 组件将显示包含多个颜色样本的列表，用户可以从中选择颜色。
	*
	*@example 以下示例代码，创建了一个 <code>ColorPicker</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.ColorPicker;
		*import laya.utils.Handler;
		*
		*public class ColorPicker_Example
		*{
			*
			*public function ColorPicker_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load("resource/ui/color.png",Handler.create(this,onLoadComplete));//加载资源。
				*}
			*
			*private function onLoadComplete():void
			*{
				*trace("资源加载完成！");
				*var colorPicket:ColorPicker=new ColorPicker();//创建一个 ColorPicker 类的实例对象 colorPicket 。
				*colorPicket.skin="resource/ui/color.png";//设置 colorPicket 的皮肤。
				*colorPicket.x=100;//设置 colorPicket 对象的属性 x 的值，用于控制 colorPicket 对象的显示位置。
				*colorPicket.y=100;//设置 colorPicket 对象的属性 y 的值，用于控制 colorPicket 对象的显示位置。
				*colorPicket.changeHandler=new Handler(this,onChangeColor,[colorPicket]);//设置 colorPicket 的颜色改变回调函数。
				*Laya.stage.addChild(colorPicket);//将此 colorPicket 对象添加到显示列表。
				*}
			*private function onChangeColor(colorPicket:ColorPicker):void
			*{
				*trace("当前选择的颜色： "+colorPicket.selectedColor);
				*}
			*
			*}
		*
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*Laya.loader.load("resource/ui/color.png",laya.utils.Handler.create(this,loadComplete));//加载资源
	*function loadComplete()
	*{
		*console.log("资源加载完成！");
		*var colorPicket=new laya.ui.ColorPicker();//创建一个 ColorPicker 类的实例对象 colorPicket 。
		*colorPicket.skin="resource/ui/color.png";//设置 colorPicket 的皮肤。
		*colorPicket.x=100;//设置 colorPicket 对象的属性 x 的值，用于控制 colorPicket 对象的显示位置。
		*colorPicket.y=100;//设置 colorPicket 对象的属性 y 的值，用于控制 colorPicket 对象的显示位置。
		*colorPicket.changeHandler=laya.utils.Handler.create(this,onChangeColor,[colorPicket],false);//设置 colorPicket 的颜色改变回调函数。
		*Laya.stage.addChild(colorPicket);//将此 colorPicket 对象添加到显示列表。
		*}
	*function onChangeColor(colorPicket)
	*{
		*console.log("当前选择的颜色： "+colorPicket.selectedColor);
		*}
	*</listing>
	*<listing version="3.0">
	*import ColorPicker=laya.ui.ColorPicker;
	*import Handler=laya.utils.Handler;
	*
	*class ColorPicker_Example {
		*
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load("resource/ui/color.png",Handler.create(this,this.onLoadComplete));//加载资源。
			*}
		*
		*private onLoadComplete():void {
			*console.log("资源加载完成！");
			*var colorPicket:ColorPicker=new ColorPicker();//创建一个 ColorPicker 类的实例对象 colorPicket 。
			*colorPicket.skin="resource/ui/color.png";//设置 colorPicket 的皮肤。
			*colorPicket.x=100;//设置 colorPicket 对象的属性 x 的值，用于控制 colorPicket 对象的显示位置。
			*colorPicket.y=100;//设置 colorPicket 对象的属性 y 的值，用于控制 colorPicket 对象的显示位置。
			*colorPicket.changeHandler=new Handler(this,this.onChangeColor,[colorPicket]);//设置 colorPicket 的颜色改变回调函数。
			*Laya.stage.addChild(colorPicket);//将此 colorPicket 对象添加到显示列表。
			*}
		*private onChangeColor(colorPicket:ColorPicker):void {
			*console.log("当前选择的颜色： "+colorPicket.selectedColor);
			*}
		*
		*}
	*</listing>
	*/
	//class laya.ui.ColorPicker extends laya.ui.Component
	var ColorPicker=(function(_super){
		function ColorPicker(){
			this.changeHandler=null;
			this._gridSize=11;
			this._bgColor="#ffffff";
			this._borderColor="#000000";
			this._inputColor="#000000";
			this._inputBgColor="#efefef";
			this._colorPanel=null;
			this._colorTiles=null;
			this._colorBlock=null;
			this._colorInput=null;
			this._colorButton=null;
			this._colors=[];
			this._selectedColor="#000000";
			ColorPicker.__super.call(this);
		}

		__class(ColorPicker,'laya.ui.ColorPicker',_super);
		var __proto=ColorPicker.prototype;
		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			this._colorPanel && this._colorPanel.destroy(destroyChild);
			this._colorButton && this._colorButton.destroy(destroyChild);
			this._colorPanel=null;
			this._colorTiles=null;
			this._colorBlock=null;
			this._colorInput=null;
			this._colorButton=null;
			this._colors=null;
			this.changeHandler=null;
		}

		/**@inheritDoc */
		__proto.createChildren=function(){
			this.addChild(this._colorButton=new Button());
			this._colorPanel=new Box();
			this._colorPanel.size(230,166);
			this._colorPanel.addChild(this._colorTiles=new Sprite());
			this._colorPanel.addChild(this._colorBlock=new Sprite());
			this._colorPanel.addChild(this._colorInput=new Input());
		}

		/**@inheritDoc */
		__proto.initialize=function(){
			this._colorButton.on("click",this,this.onColorButtonClick);
			this._colorBlock.pos(5,5);
			this._colorInput.pos(60,5);
			this._colorInput.size(60,20);
			this._colorInput.on("change",this,this.onColorInputChange);
			this._colorInput.on("keydown",this,this.onColorFieldKeyDown);
			this._colorTiles.pos(5,30);
			this._colorTiles.on("mousemove",this,this.onColorTilesMouseMove);
			this._colorTiles.on("click",this,this.onColorTilesClick);
			this._colorTiles.size(20 *this._gridSize,12 *this._gridSize);
			this._colorPanel.on("mousedown",this,this.onPanelMouseDown);
			this.bgColor=this._bgColor;
		}

		__proto.onPanelMouseDown=function(e){
			e.stopPropagation();
		}

		/**
		*改变颜色样本列表面板。
		*/
		__proto.changePanel=function(){
			var g=this._colorPanel.graphics;
			g.clear();
			g.drawRect(0,0,230,166,this._bgColor,this._borderColor);
			this.drawBlock(this._selectedColor);
			this._colorInput.borderColor=this._borderColor;
			this._colorInput.bgColor=this._inputBgColor;
			this._colorInput.color=this._inputColor;
			g=this._colorTiles.graphics;
			g.clear();
			var mainColors=[0x000000,0x333333,0x666666,0x999999,0xCCCCCC,0xFFFFFF,0xFF0000,0x00FF00,0x0000FF,0xFFFF00,0x00FFFF,0xFF00FF];
			for (var i=0;i < 12;i++){
				for (var j=0;j < 20;j++){
					var color=0;
					if (j===0)color=mainColors[i];
					else if (j===1)color=0x000000;
					else color=(((i *3+j / 6)% 3 << 0)+((i / 6)<< 0)*3)*0x33 << 16 | j % 6 *0x33 << 8 | (i << 0)% 6 *0x33;
					var strColor=UIUtils.toColor(color);
					this._colors.push(strColor);
					var x=j *this._gridSize;
					var y=i *this._gridSize;
					g.drawRect(x,y,this._gridSize,this._gridSize,strColor,"#000000");
				}
			}
		}

		/**
		*颜色样本列表面板的显示按钮的 <code>Event.MOUSE_DOWN</code> 事件侦听处理函数。
		*/
		__proto.onColorButtonClick=function(e){
			if (this._colorPanel.parent)this.close();
			else this.open();
		}

		/**
		*打开颜色样本列表面板。
		*/
		__proto.open=function(){
			var p=this.localToGlobal(new Point());
			var px=p.x+this._colorPanel.width <=Laya.stage.width ? p.x :Laya.stage.width-this._colorPanel.width;
			var py=p.y+this._colorButton.height;
			py=py+this._colorPanel.height <=Laya.stage.height ? py :p.y-this._colorPanel.height;
			this._colorPanel.pos(px,py);
			Laya.stage.addChild(this._colorPanel);
			Laya.stage.on("mousedown",this,this.removeColorBox);
		}

		/**
		*关闭颜色样本列表面板。
		*/
		__proto.close=function(){
			Laya.stage.off("mousedown",this,this.removeColorBox);
			this._colorPanel.removeSelf();
		}

		/**
		*舞台的 <code>Event.MOUSE_DOWN</code> 事件侦听处理函数。
		*/
		__proto.removeColorBox=function(e){
			this.close();
		}

		/**
		*小格子色块的 <code>Event.KEY_DOWN</code> 事件侦听处理函数。
		*/
		__proto.onColorFieldKeyDown=function(e){
			if (e.keyCode==13){
				if (this._colorInput.text)this.selectedColor=this._colorInput.text;
				else this.selectedColor=null;
				this.close();
				e.stopPropagation();
			}
		}

		/**
		*颜色值输入框 <code>Event.CHANGE</code> 事件侦听处理函数。
		*/
		__proto.onColorInputChange=function(e){
			if (this._colorInput.text)this.drawBlock(this._colorInput.text);
			else this.drawBlock("#FFFFFF");
		}

		/**
		*小格子色块的 <code>Event.CLICK</code> 事件侦听处理函数。
		*/
		__proto.onColorTilesClick=function(e){
			this.selectedColor=this.getColorByMouse();
			this.close();
		}

		/**
		*@private
		*小格子色块的 <code>Event.MOUSE_MOVE</code> 事件侦听处理函数。
		*/
		__proto.onColorTilesMouseMove=function(e){
			this._colorInput.focus=false;
			var color=this.getColorByMouse();
			this._colorInput.text=color;
			this.drawBlock(color);
		}

		/**
		*通过鼠标位置取对应的颜色块的颜色值。
		*/
		__proto.getColorByMouse=function(){
			var point=this._colorTiles.getMousePoint();
			var x=Math.floor(point.x / this._gridSize);
			var y=Math.floor(point.y / this._gridSize);
			return this._colors[y *20+x];
		}

		/**
		*绘制颜色块。
		*@param color 需要绘制的颜色块的颜色值。
		*/
		__proto.drawBlock=function(color){
			var g=this._colorBlock.graphics;
			g.clear();
			var showColor=color ? color :"#ffffff";
			g.drawRect(0,0,50,20,showColor,this._borderColor);
			color || g.drawLine(0,0,50,20,"#ff0000");
		}

		/**
		*改变颜色。
		*/
		__proto.changeColor=function(){
			var g=this.graphics;
			g.clear();
			var showColor=this._selectedColor || "#000000";
			g.drawRect(0,0,this._colorButton.width,this._colorButton.height,showColor);
		}

		/**
		*表示颜色样本列表面板的边框颜色值。
		*/
		__getset(0,__proto,'borderColor',function(){
			return this._borderColor;
			},function(value){
			this._borderColor=value;
			this.callLater(this.changePanel);
		});

		/**
		*表示选择的颜色值。
		*/
		__getset(0,__proto,'selectedColor',function(){
			return this._selectedColor;
			},function(value){
			if (this._selectedColor !=value){
				this._selectedColor=this._colorInput.text=value;
				this.drawBlock(value);
				this.changeColor();
				this.changeHandler && this.changeHandler.runWith(this._selectedColor);
				this.event("change",Event.EMPTY.setTo("change",this,this));
			}
		});

		/**
		*表示颜色输入框的背景颜色值。
		*/
		__getset(0,__proto,'inputBgColor',function(){
			return this._inputBgColor;
			},function(value){
			this._inputBgColor=value;
			this.callLater(this.changePanel);
		});

		/**
		*@copy laya.ui.Button#skin
		*/
		__getset(0,__proto,'skin',function(){
			return this._colorButton.skin;
			},function(value){
			this._colorButton.skin=value;
			this.changeColor();
		});

		/**
		*表示颜色样本列表面板的背景颜色值。
		*/
		__getset(0,__proto,'bgColor',function(){
			return this._bgColor;
			},function(value){
			this._bgColor=value;
			this.callLater(this.changePanel);
		});

		/**
		*表示颜色样本列表面板选择或输入的颜色值。
		*/
		__getset(0,__proto,'inputColor',function(){
			return this._inputColor;
			},function(value){
			this._inputColor=value;
			this.callLater(this.changePanel);
		});

		return ColorPicker;
	})(Component)


	/**
	*<code>ComboBox</code> 组件包含一个下拉列表，用户可以从该列表中选择单个值。
	*
	*@example 以下示例代码，创建了一个 <code>ComboBox</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.ComboBox;
		*import laya.utils.Handler;
		*
		*public class ComboBox_Example
		*{
			*public function ComboBox_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load("resource/ui/button.png",Handler.create(this,onLoadComplete));//加载资源。
				*}
			*
			*private function onLoadComplete():void
			*{
				*trace("资源加载完成！");
				*var comboBox:ComboBox=new ComboBox("resource/ui/button.png","item0,item1,item2,item3,item4,item5");//创建一个 ComboBox 类的实例对象 comboBox ,传入它的皮肤和标签集。
				*comboBox.x=100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
				*comboBox.y=100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
				*comboBox.selectHandler=new Handler(this,onSelect);//设置 comboBox 选择项改变时执行的处理器。
				*Laya.stage.addChild(comboBox);//将此 comboBox 对象添加到显示列表。
				*}
			*
			*private function onSelect(index:int):void
			*{
				*trace("当前选中的项对象索引： ",index);
				*}
			*
			*}
		*
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高。
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
	*Laya.loader.load("resource/ui/button.png",laya.utils.Handler.create(this,loadComplete));//加载资源
	*function loadComplete(){
		*console.log("资源加载完成！");
		*var comboBox=new laya.ui.ComboBox("resource/ui/button.png","item0,item1,item2,item3,item4,item5");//创建一个 ComboBox 类的实例对象 comboBox ,传入它的皮肤和标签集。
		*comboBox.x=100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
		*comboBox.y=100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
		*comboBox.selectHandler=new laya.utils.Handler(this,onSelect);//设置 comboBox 选择项改变时执行的处理器。
		*Laya.stage.addChild(comboBox);//将此 comboBox 对象添加到显示列表。
		*}
	*function onSelect(index)
	*{
		*console.log("当前选中的项对象索引： ",index);
		*}
	*</listing>
	*<listing version="3.0">
	*import ComboBox=laya.ui.ComboBox;
	*import Handler=laya.utils.Handler;
	*class ComboBox_Example {
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load("resource/ui/button.png",Handler.create(this,this.onLoadComplete));//加载资源。
			*}
		*
		*private onLoadComplete():void {
			*console.log("资源加载完成！");
			*var comboBox:ComboBox=new ComboBox("resource/ui/button.png","item0,item1,item2,item3,item4,item5");//创建一个 ComboBox 类的实例对象 comboBox ,传入它的皮肤和标签集。
			*comboBox.x=100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
			*comboBox.y=100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
			*comboBox.selectHandler=new Handler(this,this.onSelect);//设置 comboBox 选择项改变时执行的处理器。
			*Laya.stage.addChild(comboBox);//将此 comboBox 对象添加到显示列表。
			*}
		*
		*private onSelect(index:number):void {
			*console.log("当前选中的项对象索引： ",index);
			*}
		*
		*}
	*
	*</listing>
	*/
	//class laya.ui.ComboBox extends laya.ui.Component
	var ComboBox=(function(_super){
		function ComboBox(skin,labels){
			this._visibleNum=6;
			this._button=null;
			this._list=null;
			this._isOpen=false;
			this._scrollBar=null;
			this._itemSize=12;
			this._labels=[];
			this._selectedIndex=-1;
			this._selectHandler=null;
			this._itemHeight=NaN;
			this._listHeight=NaN;
			this._listChanged=false;
			this._itemChanged=false;
			this._scrollBarSkin=null;
			ComboBox.__super.call(this);
			this._itemColors=Styles.comboBoxItemColors;
			this.skin=skin;
			this.labels=labels;
		}

		__class(ComboBox,'laya.ui.ComboBox',_super);
		var __proto=ComboBox.prototype;
		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			this._button && this._button.destroy(destroyChild);
			this._list && this._list.destroy(destroyChild);
			this._scrollBar && this._scrollBar.destroy(destroyChild);
			this._button=null;
			this._list=null;
			this._scrollBar=null;
			this._itemColors=null;
			this._labels=null;
			this._selectHandler=null;
		}

		/**@inheritDoc */
		__proto.createChildren=function(){
			this.addChild(this._button=new Button());
			this._button.text.align="left";
			this._button.labelPadding="0,0,0,5";
			this._button.on("mousedown",this,this.onButtonMouseDown);
		}

		__proto._createList=function(){
			this._list=new List();
			this._list.selectEnable=true;
			this._list.on("mousedown",this,this.onListDown);
			this._list.mouseHandler=Handler.create(this,this.onlistItemMouse,null,false);
			if (this._scrollBarSkin){
				this._list.addChild(this._scrollBar=new VScrollBar());
				this._scrollBar.skin=this._scrollBarSkin;
				this._scrollBar.name="scrollBar";
				this._scrollBar.y=1;
				this._scrollBar.on("mousedown",this,this.onScrollBarDown);
			}
		}

		/**
		*@private
		*/
		__proto.onListDown=function(e){
			e.stopPropagation();
		}

		__proto.onScrollBarDown=function(e){
			e.stopPropagation();
		}

		__proto.onButtonMouseDown=function(e){
			this.callLater(this.switchTo,[!this._isOpen]);
		}

		/**
		*@private
		*/
		__proto.changeList=function(){
			this._listChanged=false;
			var labelWidth=this.width-2;
			var labelColor=this._itemColors[2];
			this._itemHeight=this._itemSize+6;
			this._list.itemRender={type:"Box",child:[{type:"Label",props:{name:"label",x:1,padding:"3,3,3,3",width:labelWidth,height:this._itemHeight,fontSize:this._itemSize,color:labelColor}}]};
			this._list.repeatY=this._visibleNum;
			if (this._scrollBar)
				this._scrollBar.x=this.width-this._scrollBar.width-1;
			this._list.refresh();
		}

		/**
		*@private
		*下拉列表的鼠标事件响应函数。
		*/
		__proto.onlistItemMouse=function(e,index){
			var type=e.type;
			if (type==="mouseover" || type==="mouseout"){
				var box=this._list.getCell(index);
				if (!box)return;
				var label=box.getChildByName("label");
				if (type==="mouseover"){
					label.bgColor=this._itemColors[0];
					label.color=this._itemColors[1];
					}else {
					label.bgColor=null;
					label.color=this._itemColors[2];
				}
				}else if (type==="click"){
				this.selectedIndex=index;
				this.isOpen=false;
			}
		}

		/**
		*@private
		*/
		__proto.switchTo=function(value){
			this.isOpen=value;
		}

		/**
		*更改下拉列表的打开状态。
		*/
		__proto.changeOpen=function(){
			this.isOpen=!this._isOpen;
		}

		/**
		*更改下拉列表。
		*/
		__proto.changeItem=function(){
			this._itemChanged=false;
			this.runCallLater(this.changeList);
			this._listHeight=this._labels.length > 0 ? Math.min(this._visibleNum,this._labels.length)*this._itemHeight :this._itemHeight;
			if (this._scrollBar)
				this._scrollBar.height=this._listHeight-2;
			var g=this._list.graphics;
			g.clear();
			g.drawRect(0,0,this.width-1,this._listHeight,this._itemColors[4],this._itemColors[3]);
			var a=this._list.array || [];
			a.length=0;
			for (var i=0,n=this._labels.length;i < n;i++){
				a.push({label:this._labels[i]});
			}
			this._list.array=a;
		}

		__proto.changeSelected=function(){
			this._button.label=this.selectedLabel;
		}

		/**
		*关闭下拉列表。
		*/
		__proto.removeList=function(e){
			this.isOpen=false;
		}

		/**
		*标签集合字符串。
		*/
		__getset(0,__proto,'labels',function(){
			return this._labels.join(",");
			},function(value){
			if (this._labels.length > 0)this.selectedIndex=-1;
			if (value)this._labels=value.split(",");
			else this._labels.length=0;
			this._itemChanged=true;
		});

		/**
		*@copy laya.ui.Button#skin
		*/
		__getset(0,__proto,'skin',function(){
			return this._button.skin;
			},function(value){
			if (this._button.skin !=value){
				this._button.skin=value;
				this._listChanged=true;
			}
		});

		/**@inheritDoc */
		__getset(0,__proto,'measureHeight',function(){
			return this._button.height;
		});

		/**@inheritDoc */
		__getset(0,__proto,'measureWidth',function(){
			return this._button.width;
		});

		/**
		*表示选择的下拉列表项的的标签。
		*/
		__getset(0,__proto,'selectedLabel',function(){
			return this._selectedIndex >-1 && this._selectedIndex < this._labels.length ? this._labels[this._selectedIndex] :null;
			},function(value){
			this.selectedIndex=this._labels.indexOf(value);
		});

		/**
		*表示选择的下拉列表项的索引。
		*/
		__getset(0,__proto,'selectedIndex',function(){
			return this._selectedIndex;
			},function(value){
			if (this._selectedIndex !=value){
				this._selectedIndex=value;
				if (this._labels.length > 0)this.changeSelected();
				else this.callLater(this.changeSelected);
				this.event("change",[Event.EMPTY.setTo("change",this,this)]);
				this._selectHandler && this._selectHandler.runWith(this._selectedIndex);
			}
		});

		/**@inheritDoc */
		__getset(0,__proto,'width',_super.prototype._$get_width,function(value){
			_super.prototype._$set_width.call(this,value);
			this._button.width=this._width;
			this._itemChanged=true;
			this._listChanged=true;
		});

		/**@inheritDoc */
		__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
			_super.prototype._$set_height.call(this,value);
			this._button.height=this._height;
		});

		/**
		*改变下拉列表的选择项时执行的处理器(默认返回参数index:int)。
		*/
		__getset(0,__proto,'selectHandler',function(){
			return this._selectHandler;
			},function(value){
			this._selectHandler=value;
		});

		/**
		*表示按钮的状态值。
		*@see laya.ui.Button#stateNum
		*/
		__getset(0,__proto,'stateNum',function(){
			return this._button.stateNum;
			},function(value){
			this._button.stateNum=value
		});

		/**
		*获取或设置没有滚动条的下拉列表中可显示的最大行数。
		*/
		__getset(0,__proto,'visibleNum',function(){
			return this._visibleNum;
			},function(value){
			this._visibleNum=value;
			this._listChanged=true;
		});

		/**
		*下拉列表项颜色。
		*<p><b>格式：</b>"悬停或被选中时背景颜色,悬停或被选中时标签颜色,标签颜色,边框颜色,背景颜色"</p>
		*/
		__getset(0,__proto,'itemColors',function(){
			return String(this._itemColors)
			},function(value){
			this._itemColors=UIUtils.fillArray(this._itemColors,value,String);
			this._listChanged=true;
		});

		/**
		*下拉列表项标签的字体大小。
		*/
		__getset(0,__proto,'itemSize',function(){
			return this._itemSize;
			},function(value){
			this._itemSize=value;
			this._listChanged=true;
		});

		/**
		*表示下拉列表的打开状态。
		*/
		__getset(0,__proto,'isOpen',function(){
			return this._isOpen;
			},function(value){
			if (this._isOpen !=value){
				this._isOpen=value;
				this._button.selected=this._isOpen;
				if (this._isOpen){
					this._list || this._createList();
					this._listChanged && this.changeList();
					this._itemChanged && this.changeItem();
					Point.EMPTY.setTo(0,0);
					var p=this.localToGlobal(Point.EMPTY);
					var py=p.y+this._button.height;
					py=py+this._listHeight <=Laya.stage.width ? py :p.y-this._listHeight;
					this._list.pos(p.x,py);
					Laya.stage.addChild(this._list);
					Laya.stage.once("mousedown",this,this.removeList);
					this._list.selectedIndex=this._selectedIndex;
					}else {
					this._list && this._list.removeSelf();
				}
			}
		});

		/**
		*<p>当前实例的位图 <code>AutoImage</code> 实例的有效缩放网格数据。</p>
		*<p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
		*<ul><li>例如："4,4,4,4,1"</li></ul></p>
		*@see laya.ui.AutoBitmap.sizeGrid
		*/
		__getset(0,__proto,'sizeGrid',function(){
			return this._button.sizeGrid;
			},function(value){
			this._button.sizeGrid=value;
		});

		/**
		*获取对 <code>ComboBox</code> 组件所包含的 <code>Button</code> 组件的引用。
		*/
		__getset(0,__proto,'button',function(){
			return this._button;
		});

		/**
		*滚动条皮肤。
		*/
		__getset(0,__proto,'scrollBarSkin',function(){
			return this._scrollBarSkin;
			},function(value){
			this._scrollBarSkin=value;
		});

		/**
		*获取对 <code>ComboBox</code> 组件所包含的 <code>VScrollBar</code> 滚动条组件的引用。
		*/
		__getset(0,__proto,'scrollBar',function(){
			return this._scrollBar;
		});

		/**
		*获取对 <code>ComboBox</code> 组件所包含的 <code>List</code> 列表组件的引用。
		*/
		__getset(0,__proto,'list',function(){
			return this._list;
		});

		/**@inheritDoc */
		__getset(0,__proto,'dataSource',_super.prototype._$get_dataSource,function(value){
			this._dataSource=value;
			if (((typeof value=='number')&& Math.floor(value)==value)|| (typeof value=='string'))this.selectedIndex=Laya.__parseInt(value);
			else if ((value instanceof Array))this.labels=(value).join(",");
			else _super.prototype._$set_dataSource.call(this,value);
		});

		/**
		*获取或设置对 <code>ComboBox</code> 组件所包含的 <code>Button</code> 组件的文本标签颜色。
		*<p><b>格式：</b>upColor,overColor,downColor,disableColor</p>
		*/
		__getset(0,__proto,'labelColors',function(){
			return this._button.labelColors;
			},function(value){
			this._button.labelColors=value;
		});

		/**
		*获取或设置对 <code>ComboBox</code> 组件所包含的 <code>Button</code> 组件的文本边距。
		*<p><b>格式：</b>上边距,右边距,下边距,左边距</p>
		*/
		__getset(0,__proto,'labelPadding',function(){
			return this._button.text.padding.join(",");
			},function(value){
			this._button.text.padding=UIUtils.fillArray(Styles.labelPadding,value,Number);
		});

		/**
		*获取或设置对 <code>ComboBox</code> 组件所包含的 <code>Button</code> 组件的标签字体大小。
		*/
		__getset(0,__proto,'labelSize',function(){
			return this._button.text.fontSize;
			},function(value){
			this._button.text.fontSize=value
		});

		/**
		*表示按钮文本标签是否为粗体字。
		*@see laya.display.Text#bold
		*/
		__getset(0,__proto,'labelBold',function(){
			return this._button.text.bold;
			},function(value){
			this._button.text.bold=value
		});

		/**
		*表示按钮文本标签的字体名称，以字符串形式表示。
		*@see laya.display.Text#font
		*/
		__getset(0,__proto,'labelFont',function(){
			return this._button.text.font;
			},function(value){
			this._button.text.font=value
		});

		return ComboBox;
	})(Component)


	/**
	*<code>ScrollBar</code> 组件是一个滚动条组件。
	*<p>当数据太多以至于显示区域无法容纳时，最终用户可以使用 <code>ScrollBar</code> 组件控制所显示的数据部分。</p>
	*<p> 滚动条由四部分组成：两个箭头按钮、一个轨道和一个滑块。 </p> *
	*
	*@see laya.ui.VScrollBar
	*@see laya.ui.HScrollBar
	*/
	//class laya.ui.ScrollBar extends laya.ui.Component
	var ScrollBar=(function(_super){
		function ScrollBar(skin){
			this.changeHandler=null;
			this.scaleBar=true;
			this.autoHide=false;
			this.elasticDistance=0;
			this.elasticBackTime=500;
			this._scrollSize=1;
			this._skin=null;
			this._upButton=null;
			this._downButton=null;
			this._slider=null;
			this._thumbPercent=1;
			this._target=null;
			this._lastPoint=null;
			this._lastOffset=0;
			this._checkElastic=false;
			this._isElastic=false;
			this._value=NaN;
			this._hide=false;
			this._clickOnly=true;
			this._offsets=null;
			ScrollBar.__super.call(this);
			this._showButtons=UIConfig.showButtons;
			this._touchScrollEnable=UIConfig.touchScrollEnable;
			this._mouseWheelEnable=UIConfig.mouseWheelEnable;
			this.skin=skin;
			this.max=1;
		}

		__class(ScrollBar,'laya.ui.ScrollBar',_super);
		var __proto=ScrollBar.prototype;
		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			this._upButton && this._upButton.destroy(destroyChild);
			this._downButton && this._downButton.destroy(destroyChild);
			this._slider && this._slider.destroy(destroyChild);
			this._upButton=this._downButton=null;
			this._slider=null;
			this.changeHandler=null;
			this._offsets=null;
		}

		/**@inheritDoc */
		__proto.createChildren=function(){
			this.addChild(this._slider=new Slider());
			this.addChild(this._upButton=new Button());
			this.addChild(this._downButton=new Button());
		}

		/**@inheritDoc */
		__proto.initialize=function(){
			this._slider.showLabel=false;
			this._slider.on("change",this,this.onSliderChange);
			this._slider.setSlider(0,0,0);
			this._upButton.on("mousedown",this,this.onButtonMouseDown);
			this._downButton.on("mousedown",this,this.onButtonMouseDown);
		}

		/**
		*@private
		*滑块位置发生改变的处理函数。
		*/
		__proto.onSliderChange=function(e){
			this.value=this._slider.value;
		}

		/**
		*@private
		*向上和向下按钮的 <code>Event.MOUSE_DOWN</code> 事件侦听处理函数。
		*/
		__proto.onButtonMouseDown=function(e){
			var isUp=e.currentTarget===this._upButton;
			this.slide(isUp);
			Laya.timer.once(Styles.scrollBarDelayTime,this,this.startLoop,[isUp]);
			Laya.stage.once("mouseup",this,this.onStageMouseUp);
		}

		/**@private */
		__proto.startLoop=function(isUp){
			Laya.timer.frameLoop(1,this,this.slide,[isUp]);
		}

		/**@private */
		__proto.slide=function(isUp){
			if (isUp)this.value-=this._scrollSize;
			else this.value+=this._scrollSize;
		}

		/**
		*@private
		*舞台的 <code>Event.MOUSE_DOWN</code> 事件侦听处理函数。
		*/
		__proto.onStageMouseUp=function(e){
			Laya.timer.clear(this,this.startLoop);
			Laya.timer.clear(this,this.slide);
		}

		/**
		*@private
		*更改对象的皮肤及位置。
		*/
		__proto.changeScrollBar=function(){
			this._upButton.visible=this._showButtons;
			this._downButton.visible=this._showButtons;
			if (this._showButtons){
				this._upButton.skin=this._skin.replace(".png","$up.png");
				this._downButton.skin=this._skin.replace(".png","$down.png");
			}
			if (this._slider.isVertical)this._slider.y=this._showButtons ? this._upButton.height :0;
			else this._slider.x=this._showButtons ? this._upButton.width :0;
			this.resetPositions();
		}

		/**@inheritDoc */
		__proto.changeSize=function(){
			_super.prototype.changeSize.call(this);
			this.resetPositions();
			this.event("change");
			this.changeHandler && this.changeHandler.runWith(this.value);
		}

		/**@private */
		__proto.resetPositions=function(){
			if (this._slider.isVertical)this._slider.height=this.height-(this._showButtons ? (this._upButton.height+this._downButton.height):0);
			else this._slider.width=this.width-(this._showButtons ? (this._upButton.width+this._downButton.width):0);
			this.resetButtonPosition();
		}

		/**@private */
		__proto.resetButtonPosition=function(){
			if (this._slider.isVertical)this._downButton.y=this._slider.y+this._slider.height;
			else this._downButton.x=this._slider.x+this._slider.width;
		}

		/**
		*设置滚动条信息。
		*@param min 滚动条最小位置值。
		*@param max 滚动条最大位置值。
		*@param value 滚动条当前位置值。
		*/
		__proto.setScroll=function(min,max,value){
			this.runCallLater(this.changeSize);
			this._slider.setSlider(min,max,value);
			this._slider.bar.visible=max > 0;
			if (!this._hide && this.autoHide)this.visible=false;
		}

		/**@private */
		__proto.onTargetMouseWheel=function(e){
			this.value-=e.delta *this._scrollSize;
			this.target=this._target;
		}

		/**@private */
		__proto.onTargetMouseDown=function(e){
			this._clickOnly=true;
			this._lastOffset=0;
			this._checkElastic=false;
			this._lastPoint || (this._lastPoint=new Point());
			this._lastPoint.setTo(Laya.stage.mouseX,Laya.stage.mouseY);
			Laya.timer.clear(this,this.tweenMove);
			Tween.clearTween(this);
			Laya.stage.once("mouseup",this,this.onStageMouseUp2);
			Laya.stage.once("mouseout",this,this.onStageMouseUp2);
			Laya.timer.frameLoop(1,this,this.loop);
			this.event("start");
		}

		/**@private */
		__proto.loop=function(){
			var mouseY=Laya.stage.mouseY;
			var mouseX=Laya.stage.mouseX;
			this._lastOffset=this.isVertical ? (mouseY-this._lastPoint.y):(mouseX-this._lastPoint.x);
			if (this._clickOnly){
				if (Math.abs(this._lastOffset *(this.isVertical ? Laya.stage._canvasTransform.getScaleY():Laya.stage._canvasTransform.getScaleX()))> 1){
					this._clickOnly=false;
					this._offsets || (this._offsets=[]);
					this._offsets.length=0;
					this._target.mouseEnabled=false;
					if (!this.hide && this.autoHide){
						this.alpha=1;
						this.visible=true;
					}
				}else return;
			}
			this._offsets.push(this._lastOffset);
			this._lastPoint.x=mouseX;
			this._lastPoint.y=mouseY;
			if (this._lastOffset===0)return;
			if (!this._checkElastic){
				if (this.elasticDistance > 0){
					if (!this._checkElastic && this._lastOffset !=0){
						this._checkElastic=true;
						if ((this._lastOffset > 0 && this._value <=this.min)|| (this._lastOffset < 0 && this._value >=this.max)){
							this._isElastic=true;
							}else {
							this._isElastic=false;
						}
					}
					}else {
					this._checkElastic=true;
				}
			}
			if (this._checkElastic){
				if (this._isElastic){
					if (this._value <=this.min){
						this.value-=this._lastOffset *Math.max(0,(1-((this.min-this._value)/ this.elasticDistance)));
						}else if (this._value >=this.max){
						this.value-=this._lastOffset *Math.max(0,(1-((this._value-this.max)/ this.elasticDistance)));
					}
					}else {
					this.value-=this._lastOffset;
				}
			}
		}

		/**@private */
		__proto.onStageMouseUp2=function(e){
			Laya.stage.off("mouseup",this,this.onStageMouseUp2);
			Laya.stage.off("mouseout",this,this.onStageMouseUp2);
			Laya.timer.clear(this,this.loop);
			if (this._clickOnly)return;
			this._target.mouseEnabled=true;
			if (this._isElastic){
				if (this._value < this.min){
					Tween.to(this,{value:this.min},this.elasticBackTime,Ease.sineOut,Handler.create(this,this.elasticOver));
					}else if (this._value > this.max){
					Tween.to(this,{value:this.max},this.elasticBackTime,Ease.sineOut,Handler.create(this,this.elasticOver));
				}
				}else {
				if (this._offsets.length < 1){
					this._offsets[0]=this.isVertical ? Laya.stage.mouseY-this._lastPoint.y :Laya.stage.mouseX-this._lastPoint.x;
				};
				var offset=0;
				var n=Math.min(this._offsets.length,3);
				for (var i=0;i < n;i++){
					offset+=this._offsets[this._offsets.length-1-i];
				}
				this._lastOffset=offset / n;
				offset=Math.abs(this._lastOffset);
				if (offset < 2)return;
				if (offset > 60)this._lastOffset=this._lastOffset > 0 ? 60 :-60;
				Laya.timer.frameLoop(1,this,this.tweenMove);
			}
		}

		/**@private */
		__proto.elasticOver=function(){
			this._isElastic=false;
			if (!this.hide && this.autoHide){
				Tween.to(this,{alpha:0},500);
			}
		}

		/**@private */
		__proto.tweenMove=function(){
			this._lastOffset *=0.95;
			this.value-=this._lastOffset;
			if (Math.abs(this._lastOffset)< 1){
				Laya.timer.clear(this,this.tweenMove);
				this.event("end");
				if (!this.hide && this.autoHide){
					Tween.to(this,{alpha:0},500);
				}
			}
		}

		/**
		*停止滑动。
		*/
		__proto.stopScroll=function(){
			this.onStageMouseUp2(null);
			Laya.timer.clear(this,this.tweenMove);
			Tween.clearTween(this);
		}

		/**
		*一个布尔值，指示滚动条是否为垂直滚动。如果值为true，则为垂直滚动，否则为水平滚动。
		*<p>默认值为：true。</p>
		*/
		__getset(0,__proto,'isVertical',function(){
			return this._slider.isVertical;
			},function(value){
			this._slider.isVertical=value;
		});

		/**
		*@copy laya.ui.Image#skin
		*/
		__getset(0,__proto,'skin',function(){
			return this._skin;
			},function(value){
			if (this._skin !=value){
				this._skin=value;
				this._slider.skin=this._skin;
				this.callLater(this.changeScrollBar);
			}
		});

		/**
		*获取或设置表示最高滚动位置的数字。
		*/
		__getset(0,__proto,'max',function(){
			return this._slider.max;
			},function(value){
			this._slider.max=value;
		});

		/**获取或设置一个值，该值表示按下滚动条轨道时页面滚动的增量。 */
		__getset(0,__proto,'scrollSize',function(){
			return this._scrollSize;
			},function(value){
			this._scrollSize=value;
		});

		/**@inheritDoc */
		__getset(0,__proto,'measureHeight',function(){
			if (this._slider.isVertical)return 100;
			return this._slider.height;
		});

		/**@inheritDoc */
		__getset(0,__proto,'measureWidth',function(){
			if (this._slider.isVertical)return this._slider.width;
			return 100;
		});

		/**
		*<p>当前实例的 <code>Slider</code> 实例的有效缩放网格数据。</p>
		*<p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
		*<ul><li>例如："4,4,4,4,1"</li></ul></p>
		*@see laya.ui.AutoBitmap.sizeGrid
		*/
		__getset(0,__proto,'sizeGrid',function(){
			return this._slider.sizeGrid;
			},function(value){
			this._slider.sizeGrid=value;
		});

		/**
		*获取或设置表示最低滚动位置的数字。
		*/
		__getset(0,__proto,'min',function(){
			return this._slider.min;
			},function(value){
			this._slider.min=value;
		});

		/**
		*获取或设置表示当前滚动位置的数字。
		*/
		__getset(0,__proto,'value',function(){
			return this._value;
			},function(v){
			if (v!==this._value){
				if (this._isElastic)this._value=v;
				else {
					this._slider.value=v;
					this._value=this._slider.value;
				}
				this.event("change");
				this.changeHandler && this.changeHandler.runWith(this.value);
			}
		});

		/**@inheritDoc */
		__getset(0,__proto,'dataSource',_super.prototype._$get_dataSource,function(value){
			this._dataSource=value;
			if ((typeof value=='number')|| (typeof value=='string'))this.value=Number(value);
			else _super.prototype._$set_dataSource.call(this,value);
		});

		/**获取或设置一个值，该值表示滑条长度比例，值为：（0-1）。 */
		__getset(0,__proto,'thumbPercent',function(){
			return this._thumbPercent;
			},function(value){
			this.runCallLater(this.changeScrollBar);
			this.runCallLater(this.changeSize);
			value=value >=1 ? 0.99 :value;
			this._thumbPercent=value;
			if (this.scaleBar){
				if (this._slider.isVertical)this._slider.bar.height=Math.max(this._slider.height *value,Styles.scrollBarMinNum);
				else this._slider.bar.width=Math.max(this._slider.width *value,Styles.scrollBarMinNum);
			}
		});

		/**
		*设置滚动对象。
		*@see laya.ui.TouchScroll#target
		*/
		__getset(0,__proto,'target',function(){
			return this._target;
			},function(value){
			if (this._target){
				this._target.off("mousewheel",this,this.onTargetMouseWheel);
				this._target.off("mousedown",this,this.onTargetMouseDown);
			}
			this._target=value;
			if (value){
				this._mouseWheelEnable && this._target.on("mousewheel",this,this.onTargetMouseWheel);
				this._touchScrollEnable && this._target.on("mousedown",this,this.onTargetMouseDown);
			}
		});

		/**是否隐藏滚动条，不显示滚动条，但是可以正常滚动，默认为false。*/
		__getset(0,__proto,'hide',function(){
			return this._hide;
			},function(value){
			this._hide=value;
			this.visible=!value;
		});

		/**一个布尔值，指定是否显示向上、向下按钮，默认值为true。*/
		__getset(0,__proto,'showButtons',function(){
			return this._showButtons;
			},function(value){
			this._showButtons=value;
			this.callLater(this.changeScrollBar);
		});

		/**一个布尔值，指定是否开启触摸，默认值为true。*/
		__getset(0,__proto,'touchScrollEnable',function(){
			return this._touchScrollEnable;
			},function(value){
			this._touchScrollEnable=value;
			this.target=this._target;
		});

		/**一个布尔值，指定是否滑轮滚动，默认值为true。*/
		__getset(0,__proto,'mouseWheelEnable',function(){
			return this._mouseWheelEnable;
			},function(value){
			this._mouseWheelEnable=value;
		});

		return ScrollBar;
	})(Component)


	/**
	*使用 <code>Slider</code> 控件，用户可以通过在滑块轨道的终点之间移动滑块来选择值。
	*<p>滑块的当前值由滑块端点（对应于滑块的最小值和最大值）之间滑块的相对位置确定。</p>
	*<p>滑块允许最小值和最大值之间特定间隔内的值。滑块还可以使用数据提示显示其当前值。</p>
	*
	*@see laya.ui.HSlider
	*@see laya.ui.VSlider
	*/
	//class laya.ui.Slider extends laya.ui.Component
	var Slider=(function(_super){
		function Slider(skin){
			this.changeHandler=null;
			this.isVertical=true;
			this.showLabel=true;
			this._allowClickBack=false;
			this._max=100;
			this._min=0;
			this._tick=1;
			this._value=0;
			this._skin=null;
			this._bg=null;
			this._bar=null;
			this._tx=NaN;
			this._ty=NaN;
			this._maxMove=NaN;
			Slider.__super.call(this);
			this.skin=skin;
		}

		__class(Slider,'laya.ui.Slider',_super);
		var __proto=Slider.prototype;
		/**
		*@inheritDoc
		*/
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			this._bg && this._bg.destroy(destroyChild);
			this._bar && this._bar.destroy(destroyChild);
			this._bg=null;
			this._bar=null;
			this.changeHandler=null;
		}

		/**@inheritDoc */
		__proto.createChildren=function(){
			this.addChild(this._bg=new Image());
			this.addChild(this._bar=new Button());
		}

		/**@inheritDoc */
		__proto.initialize=function(){
			this._bar.on("mousedown",this,this.onBarMouseDown);
			this._bg.sizeGrid=this._bar.sizeGrid="4,4,4,4,0";
			this.allowClickBack=true;
		}

		/**
		*@private
		*滑块的的 <code>Event.MOUSE_DOWN</code> 事件侦听处理函数。
		*@param e
		*/
		__proto.onBarMouseDown=function(e){
			this._maxMove=this.isVertical ? (this.height-this._bar.height):(this.width-this._bar.width);
			this._tx=Laya.stage.mouseX;
			this._ty=Laya.stage.mouseY;
			Laya.stage.on("mousemove",this,this.mouseMove);
			Laya.stage.once("mouseup",this,this.mouseUp);
			this.showValueText();
		}

		/**
		*@private
		*显示标签。
		*/
		__proto.showValueText=function(){
			if (this.showLabel){
				var label=laya.ui.Slider.label;
				this.addChild(label);
				label.textField.changeText(this._value+"");
				if (this.isVertical){
					label.x=this._bar.x+20;
					label.y=(this._bar.height-label.height)*0.5+this._bar.y;
					}else {
					label.y=this._bar.y-20;
					label.x=(this._bar.width-label.width)*0.5+this._bar.x;
				}
			}
		}

		/**
		*@private
		*隐藏标签。
		*/
		__proto.hideValueText=function(){
			laya.ui.Slider.label && laya.ui.Slider.label.removeSelf();
		}

		/**
		*@private
		*@param e
		*/
		__proto.mouseUp=function(e){
			Laya.stage.off("mousemove",this,this.mouseMove);
			this.sendChangeEvent("changed");
			this.hideValueText();
		}

		/**
		*@private
		*@param e
		*/
		__proto.mouseMove=function(e){
			var oldValue=this._value;
			if (this.isVertical){
				this._bar.y+=Laya.stage.mouseY-this._ty;
				if (this._bar.y > this._maxMove)this._bar.y=this._maxMove;
				else if (this._bar.y < 0)this._bar.y=0;
				this._value=this._bar.y / this._maxMove *(this._max-this._min)+this._min;
				}else {
				this._bar.x+=Laya.stage.mouseX-this._tx;
				if (this._bar.x > this._maxMove)this._bar.x=this._maxMove;
				else if (this._bar.x < 0)this._bar.x=0;
				this._value=this._bar.x / this._maxMove *(this._max-this._min)+this._min;
			}
			this._tx=Laya.stage.mouseX;
			this._ty=Laya.stage.mouseY;
			var pow=Math.pow(10,(this._tick+"").length-1);
			this._value=Math.round(Math.round(this._value / this._tick)*this._tick *pow)/ pow;
			if (this._value !=oldValue){
				this.sendChangeEvent();
			}
			this.showValueText();
		}

		/**
		*@private
		*@param type
		*/
		__proto.sendChangeEvent=function(type){
			(type===void 0)&& (type="change");
			this.event(type);
			this.changeHandler && this.changeHandler.runWith(this._value);
		}

		/**
		*@private
		*设置滑块的位置信息。
		*/
		__proto.setBarPoint=function(){
			if (this.isVertical)this._bar.x=(this._bg.width-this._bar.width)*0.5;
			else this._bar.y=(this._bg.height-this._bar.height)*0.5;
		}

		/**@inheritDoc */
		__proto.changeSize=function(){
			_super.prototype.changeSize.call(this);
			if (this.isVertical)this._bg.height=this.height;
			else this._bg.width=this.width;
			this.setBarPoint();
			this.changeValue();
		}

		/**
		*设置滑动条的信息。
		*@param min 滑块的最小值。
		*@param max 滑块的最小值。
		*@param value 滑块的当前值。
		*/
		__proto.setSlider=function(min,max,value){
			this._value=-1;
			this._min=min;
			this._max=max > min ? max :min;
			this.value=value < min ? min :value > max ? max :value;
		}

		/**
		*@private
		*改变滑块的位置值。
		*/
		__proto.changeValue=function(){
			var pow=Math.pow(10,(this._tick+"").length-1);
			this._value=Math.round(Math.round(this._value / this._tick)*this._tick *pow)/ pow;
			this._value=this._value > this._max ? this._max :this._value < this._min ? this._min :this._value;
			if (this.isVertical)this._bar.y=(this._value-this._min)/ (this._max-this._min)*(this.height-this._bar.height);
			else this._bar.x=(this._value-this._min)/ (this._max-this._min)*(this.width-this._bar.width);
		}

		/**
		*@private
		*滑动条的 <code>Event.MOUSE_DOWN</code> 事件侦听处理函数。
		*/
		__proto.onBgMouseDown=function(e){
			var point=this._bg.getMousePoint();
			if (this.isVertical)this.value=point.y / (this.height-this._bar.height)*(this._max-this._min)+this._min;
			else this.value=point.x / (this.width-this._bar.width)*(this._max-this._min)+this._min;
		}

		/**
		*@copy laya.ui.Image#skin
		*@return
		*/
		__getset(0,__proto,'skin',function(){
			return this._skin;
			},function(value){
			if (this._skin !=value){
				this._skin=value;
				this._bg.skin=this._skin;
				this._bar.skin=this._skin.replace(".png","$bar.png");
				this.setBarPoint();
			}
		});

		/**
		*获取或设置表示最高位置的数字。 默认值为100。
		*/
		__getset(0,__proto,'max',function(){
			return this._max;
			},function(value){
			if (this._max !=value){
				this._max=value;
				this.callLater(this.changeValue);
			}
		});

		/**
		*表示滑块按钮的引用。
		*/
		__getset(0,__proto,'bar',function(){
			return this._bar;
		});

		/**@inheritDoc */
		__getset(0,__proto,'measureHeight',function(){
			return Math.max(this._bg.height,this._bar.height);
		});

		/**@inheritDoc */
		__getset(0,__proto,'measureWidth',function(){
			return Math.max(this._bg.width,this._bar.width);
		});

		/**
		*<p>当前实例的背景图（ <code>Image</code> ）和滑块按钮（ <code>Button</code> ）实例的有效缩放网格数据。</p>
		*<p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
		*<ul><li>例如："4,4,4,4,1"</li></ul></p>
		*@see laya.ui.AutoBitmap.sizeGrid
		*@return
		*/
		__getset(0,__proto,'sizeGrid',function(){
			return this._bg.sizeGrid;
			},function(value){
			this._bg.sizeGrid=value;
			this._bar.sizeGrid=value;
		});

		/**
		*表示当前的刻度值。默认值为1。
		*@return
		*/
		__getset(0,__proto,'tick',function(){
			return this._tick;
			},function(value){
			this._tick=value;
			this.callLater(this.changeValue);
		});

		/**
		*获取或设置表示最低位置的数字。 默认值为0。
		*/
		__getset(0,__proto,'min',function(){
			return this._min;
			},function(value){
			if (this._min !=value){
				this._min=value;
				this.callLater(this.changeValue);
			}
		});

		/**
		*获取或设置表示当前滑块位置的数字。
		*/
		__getset(0,__proto,'value',function(){
			return this._value;
			},function(num){
			if (this._value !=num){
				var oldValue=this._value;
				this._value=num;
				this.changeValue();
				if (this._value !=oldValue){
					this.sendChangeEvent();
				}
			}
		});

		/**
		*一个布尔值，指定是否允许通过点击滑动条改变 <code>Slider</code> 的 <code>value</code> 属性值。
		*/
		__getset(0,__proto,'allowClickBack',function(){
			return this._allowClickBack;
			},function(value){
			if (this._allowClickBack !=value){
				this._allowClickBack=value;
				if (value)this._bg.on("mousedown",this,this.onBgMouseDown);
				else this._bg.off("mousedown",this,this.onBgMouseDown);
			}
		});

		/**@inheritDoc */
		__getset(0,__proto,'dataSource',_super.prototype._$get_dataSource,function(value){
			this._dataSource=value;
			if ((typeof value=='number')|| (typeof value=='string'))this.value=Number(value);
			else _super.prototype._$set_dataSource.call(this,value);
		});

		__static(Slider,
		['label',function(){return this.label=new Label();}
		]);
		return Slider;
	})(Component)


	/**
	*<code>Image</code> 类是用于表示位图图像或绘制图形的显示对象。
	*@example 以下示例代码，创建了一个新的 <code>Image</code> 实例，设置了它的皮肤、位置信息，并添加到舞台上。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.Image;
		*public class Image_Example
		*{
			*public function Image_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*onInit();
				*}
			*private function onInit():void
			*{
				*var bg:Image=new Image("resource/ui/bg.png");//创建一个 Image 类的实例对象 bg ,并传入它的皮肤。
				*bg.x=100;//设置 bg 对象的属性 x 的值，用于控制 bg 对象的显示位置。
				*bg.y=100;//设置 bg 对象的属性 y 的值，用于控制 bg 对象的显示位置。
				*bg.sizeGrid="40,10,5,10";//设置 bg 对象的网格信息。
				*bg.width=150;//设置 bg 对象的宽度。
				*bg.height=250;//设置 bg 对象的高度。
				*Laya.stage.addChild(bg);//将此 bg 对象添加到显示列表。
				*
				*var image:Image=new Image("resource/ui/image.png");//创建一个 Image 类的实例对象 image ,并传入它的皮肤。
				*image.x=100;//设置 image 对象的属性 x 的值，用于控制 image 对象的显示位置。
				*image.y=100;//设置 image 对象的属性 y 的值，用于控制 image 对象的显示位置。
				*Laya.stage.addChild(image);//将此 image 对象添加到显示列表。
				*}
			*}
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*onInit();
	*function onInit(){
		*var bg=new laya.ui.Image("resource/ui/bg.png");//创建一个 Image 类的实例对象 bg ,并传入它的皮肤。
		*bg.x=100;//设置 bg 对象的属性 x 的值，用于控制 bg 对象的显示位置。
		*bg.y=100;//设置 bg 对象的属性 y 的值，用于控制 bg 对象的显示位置。
		*bg.sizeGrid="40,10,5,10";//设置 bg 对象的网格信息。
		*bg.width=150;//设置 bg 对象的宽度。
		*bg.height=250;//设置 bg 对象的高度。
		*Laya.stage.addChild(bg);//将此 bg 对象添加到显示列表。
		*
		*var image=new laya.ui.Image("resource/ui/image.png");//创建一个 Image 类的实例对象 image ,并传入它的皮肤。
		*image.x=100;//设置 image 对象的属性 x 的值，用于控制 image 对象的显示位置。
		*image.y=100;//设置 image 对象的属性 y 的值，用于控制 image 对象的显示位置。
		*Laya.stage.addChild(image);//将此 image 对象添加到显示列表。
		*}
	*</listing>
	*<listing version="3.0">
	*class Image_Example {
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*this.onInit();
			*}
		*private onInit():void {
			*var bg:laya.ui.Image=new laya.ui.Image("resource/ui/bg.png");//创建一个 Image 类的实例对象 bg ,并传入它的皮肤。
			*bg.x=100;//设置 bg 对象的属性 x 的值，用于控制 bg 对象的显示位置。
			*bg.y=100;//设置 bg 对象的属性 y 的值，用于控制 bg 对象的显示位置。
			*bg.sizeGrid="40,10,5,10";//设置 bg 对象的网格信息。
			*bg.width=150;//设置 bg 对象的宽度。
			*bg.height=250;//设置 bg 对象的高度。
			*Laya.stage.addChild(bg);//将此 bg 对象添加到显示列表。
			*
			*var image:laya.ui.Image=new laya.ui.Image("resource/ui/image.png");//创建一个 Image 类的实例对象 image ,并传入它的皮肤。
			*image.x=100;//设置 image 对象的属性 x 的值，用于控制 image 对象的显示位置。
			*image.y=100;//设置 image 对象的属性 y 的值，用于控制 image 对象的显示位置。
			*Laya.stage.addChild(image);//将此 image 对象添加到显示列表。
			*}
		*}
	*</listing>
	*@see laya.ui.AutoBitmap
	*/
	//class laya.ui.Image extends laya.ui.Component
	var Image=(function(_super){
		function Image(skin){
			this._bitmap=null;
			this._skin=null;
			Image.__super.call(this);
			this.skin=skin;
		}

		__class(Image,'laya.ui.Image',_super);
		var __proto=Image.prototype;
		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,true);
			this._bitmap && this._bitmap.destroy();
			this._bitmap=null;
		}

		/**
		*销毁对象并释放加载的皮肤资源。
		*/
		__proto.dispose=function(){
			this.destroy(true);
			Laya.loader.clearRes(this._skin);
		}

		/**@inheritDoc */
		__proto.createChildren=function(){
			this.graphics=this._bitmap=new AutoBitmap();
			this._bitmap.autoCacheCmd=false;
		}

		/**
		*@private
		*设置皮肤资源。
		*/
		__proto.setSource=function(url,value){
			url===this._skin && (this.source=value);
			this.onCompResize();
		}

		/**
		*<p>对象的皮肤地址，以字符串表示。</p>
		*<p>如果资源未加载，则先加载资源，加载完成后应用于此对象。</p>
		*<b>注意：</b>资源加载完成后，会自动缓存至资源库中。
		*/
		__getset(0,__proto,'skin',function(){
			return this._skin;
			},function(value){
			if (this._skin !=value){
				this._skin=value;
				if (value){
					var source=Loader.getRes(value);
					if (source)this.source=source;
					else Laya.loader.load(this._skin,Handler.create(this,this.setSource,[this._skin]),null,"image");
					}else {
					this.source=null;
				}
			}
		});

		/**
		*@copy laya.ui.AutoBitmap#source
		*/
		__getset(0,__proto,'source',function(){
			return this._bitmap.source;
			},function(value){
			if (!this._bitmap)return;
			this._bitmap.source=value;
			this.event("loaded");
			this.repaint();
		});

		/**@inheritDoc */
		__getset(0,__proto,'width',_super.prototype._$get_width,function(value){
			_super.prototype._$set_width.call(this,value);
			this._bitmap.width=value==0 ? 0.0000001 :value;
		});

		/**@inheritDoc */
		__getset(0,__proto,'measureHeight',function(){
			return this._bitmap.height;
		});

		/**@inheritDoc */
		__getset(0,__proto,'measureWidth',function(){
			return this._bitmap.width;
		});

		/**
		*<p>当前实例的位图 <code>AutoImage</code> 实例的有效缩放网格数据。</p>
		*<p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
		*<ul><li>例如："4,4,4,4,1"。</li></ul></p>
		*@see laya.ui.AutoBitmap#sizeGrid
		*/
		__getset(0,__proto,'sizeGrid',function(){
			if (this._bitmap.sizeGrid)return this._bitmap.sizeGrid.join(",");
			return null;
			},function(value){
			this._bitmap.sizeGrid=UIUtils.fillArray(Styles.defaultSizeGrid,value,Number);
		});

		/**@inheritDoc */
		__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
			_super.prototype._$set_height.call(this,value);
			this._bitmap.height=value==0 ? 0.0000001 :value;
		});

		/**@inheritDoc */
		__getset(0,__proto,'dataSource',_super.prototype._$get_dataSource,function(value){
			this._dataSource=value;
			if ((typeof value=='string'))this.skin=value;
			else _super.prototype._$set_dataSource.call(this,value);
		});

		return Image;
	})(Component)


	/**
	*<p> <code>Label</code> 类用于创建显示对象以显示文本。</p>
	*
	*@example 以下示例代码，创建了一个 <code>Label</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.Label;
		*
		*public class Label_Example
		*{
			*public function Label_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*onInit();
				*}
			*
			*private function onInit():void
			*{
				*var label:Label=new Label();//创建一个 Label 类的实例对象 label 。
				*label.font="Arial";//设置 label 的字体。
				*label.bold=true;//设置 label 显示为粗体。
				*label.leading=4;//设置 label 的行间距。
				*label.wordWrap=true;//设置 label 自动换行。
				*label.padding="10,10,10,10";//设置 label 的边距。
				*label.color="#ff00ff";//设置 label 的颜色。
				*label.text="Hello everyone,我是一个可爱的文本！";//设置 label 的文本内容。
				*label.x=100;//设置 label 对象的属性 x 的值，用于控制 label 对象的显示位置。
				*label.y=100;//设置 label 对象的属性 y 的值，用于控制 label 对象的显示位置。
				*label.width=300;//设置 label 的宽度。
				*label.height=200;//设置 label 的高度。
				*Laya.stage.addChild(label);//将 label 添加到显示列表。
				*
				*var passwordLabel:Label=new Label("请原谅我，我不想被人看到我心里话。");//创建一个 Label 类的实例对象 passwordLabel 。
				*passwordLabel.asPassword=true;//设置 passwordLabel 的显示反式为密码显示。
				*passwordLabel.x=100;//设置 passwordLabel 对象的属性 x 的值，用于控制 passwordLabel 对象的显示位置。
				*passwordLabel.y=350;//设置 passwordLabel 对象的属性 y 的值，用于控制 passwordLabel 对象的显示位置。
				*passwordLabel.width=300;//设置 passwordLabel 的宽度。
				*passwordLabel.color="#000000";//设置 passwordLabel 的文本颜色。
				*passwordLabel.bgColor="#ccffff";//设置 passwordLabel 的背景颜色。
				*passwordLabel.fontSize=20;//设置 passwordLabel 的文本字体大小。
				*Laya.stage.addChild(passwordLabel);//将 passwordLabel 添加到显示列表。
				*}
			*
			*}
		*
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*onInit();
	*function onInit(){
		*var label=new laya.ui.Label();//创建一个 Label 类的实例对象 label 。
		*label.font="Arial";//设置 label 的字体。
		*label.bold=true;//设置 label 显示为粗体。
		*label.leading=4;//设置 label 的行间距。
		*label.wordWrap=true;//设置 label 自动换行。
		*label.padding="10,10,10,10";//设置 label 的边距。
		*label.color="#ff00ff";//设置 label 的颜色。
		*label.text="Hello everyone,我是一个可爱的文本！";//设置 label 的文本内容。
		*label.x=100;//设置 label 对象的属性 x 的值，用于控制 label 对象的显示位置。
		*label.y=100;//设置 label 对象的属性 y 的值，用于控制 label 对象的显示位置。
		*label.width=300;//设置 label 的宽度。
		*label.height=200;//设置 label 的高度。
		*Laya.stage.addChild(label);//将 label 添加到显示列表。
		*
		*var passwordLabel=new laya.ui.Label("请原谅我，我不想被人看到我心里话。");//创建一个 Label 类的实例对象 passwordLabel 。
		*passwordLabel.asPassword=true;//设置 passwordLabel 的显示反式为密码显示。
		*passwordLabel.x=100;//设置 passwordLabel 对象的属性 x 的值，用于控制 passwordLabel 对象的显示位置。
		*passwordLabel.y=350;//设置 passwordLabel 对象的属性 y 的值，用于控制 passwordLabel 对象的显示位置。
		*passwordLabel.width=300;//设置 passwordLabel 的宽度。
		*passwordLabel.color="#000000";//设置 passwordLabel 的文本颜色。
		*passwordLabel.bgColor="#ccffff";//设置 passwordLabel 的背景颜色。
		*passwordLabel.fontSize=20;//设置 passwordLabel 的文本字体大小。
		*Laya.stage.addChild(passwordLabel);//将 passwordLabel 添加到显示列表。
		*}
	*</listing>
	*<listing version="3.0">
	*import Label=laya.ui.Label;
	*class Label_Example {
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*this.onInit();
			*}
		*private onInit():void {
			*var label:Label=new Label();//创建一个 Label 类的实例对象 label 。
			*label.font="Arial";//设置 label 的字体。
			*label.bold=true;//设置 label 显示为粗体。
			*label.leading=4;//设置 label 的行间距。
			*label.wordWrap=true;//设置 label 自动换行。
			*label.padding="10,10,10,10";//设置 label 的边距。
			*label.color="#ff00ff";//设置 label 的颜色。
			*label.text="Hello everyone,我是一个可爱的文本！";//设置 label 的文本内容。
			*label.x=100;//设置 label 对象的属性 x 的值，用于控制 label 对象的显示位置。
			*label.y=100;//设置 label 对象的属性 y 的值，用于控制 label 对象的显示位置。
			*label.width=300;//设置 label 的宽度。
			*label.height=200;//设置 label 的高度。
			*Laya.stage.addChild(label);//将 label 添加到显示列表。
			*var passwordLabel:Label=new Label("请原谅我，我不想被人看到我心里话。");//创建一个 Label 类的实例对象 passwordLabel 。
			*passwordLabel.asPassword=true;//设置 passwordLabel 的显示反式为密码显示。
			*passwordLabel.x=100;//设置 passwordLabel 对象的属性 x 的值，用于控制 passwordLabel 对象的显示位置。
			*passwordLabel.y=350;//设置 passwordLabel 对象的属性 y 的值，用于控制 passwordLabel 对象的显示位置。
			*passwordLabel.width=300;//设置 passwordLabel 的宽度。
			*passwordLabel.color="#000000";//设置 passwordLabel 的文本颜色。
			*passwordLabel.bgColor="#ccffff";//设置 passwordLabel 的背景颜色。
			*passwordLabel.fontSize=20;//设置 passwordLabel 的文本字体大小。
			*Laya.stage.addChild(passwordLabel);//将 passwordLabel 添加到显示列表。
			*}
		*}
	*</listing>
	*@see laya.display.Text
	*/
	//class laya.ui.Label extends laya.ui.Component
	var Label=(function(_super){
		function Label(text){
			this._tf=null;
			Label.__super.call(this);
			(text===void 0)&& (text="");
			Font.defaultColor=Styles.labelColor;
			this.text=text;
		}

		__class(Label,'laya.ui.Label',_super);
		var __proto=Label.prototype;
		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			this._tf=null;
		}

		/**@inheritDoc */
		__proto.createChildren=function(){
			this.addChild(this._tf=new Text());
		}

		/**
		*@copy laya.display.Text#leading
		*/
		__getset(0,__proto,'leading',function(){
			return this._tf.leading;
			},function(value){
			this._tf.leading=value;
		});

		/**
		*当前文本内容字符串。
		*@see laya.display.Text.text
		*/
		__getset(0,__proto,'text',function(){
			return this._tf.text;
			},function(value){
			if (this._tf.text !=value){
				this._tf.text=value;
				this.event("change");
			}
		});

		/**
		*@copy laya.display.Text#color
		*/
		__getset(0,__proto,'color',function(){
			return this._tf.color;
			},function(value){
			this._tf.color=value;
		});

		/**
		*@copy laya.display.Text#strokeColor
		*/
		__getset(0,__proto,'strokeColor',function(){
			return this._tf.strokeColor;
			},function(value){
			this._tf.strokeColor=value;
		});

		/**
		*@copy laya.display.Text#wordWrap
		*/
		/**
		*@copy laya.display.Text#wordWrap
		*/
		__getset(0,__proto,'wordWrap',function(){
			return this._tf.wordWrap;
			},function(value){
			this._tf.wordWrap=value;
		});

		/**
		*@copy laya.display.Text#font
		*/
		__getset(0,__proto,'font',function(){
			return this._tf.font;
			},function(value){
			this._tf.font=value;
		});

		/**
		*@copy laya.display.Text#italic
		*/
		__getset(0,__proto,'italic',function(){
			return this._tf.italic;
			},function(value){
			this._tf.italic=value;
		});

		/**
		*@copy laya.display.Text#valign
		*/
		__getset(0,__proto,'valign',function(){
			return this._tf.valign;
			},function(value){
			this._tf.valign=value;
		});

		/**
		*@copy laya.display.Text#align
		*/
		__getset(0,__proto,'align',function(){
			return this._tf.align;
			},function(value){
			this._tf.align=value;
		});

		/**
		*@copy laya.display.Text#bold
		*/
		__getset(0,__proto,'bold',function(){
			return this._tf.bold;
			},function(value){
			this._tf.bold=value;
		});

		/**
		*文本控件实体 <code>Text</code> 实例。
		*/
		__getset(0,__proto,'textField',function(){
			return this._tf;
		});

		/**
		*@copy laya.display.Text#fontSize
		*/
		__getset(0,__proto,'fontSize',function(){
			return this._tf.fontSize;
			},function(value){
			this._tf.fontSize=value;
		});

		/**
		*<p>边距信息</p>
		*<p>"上边距，右边距，下边距 , 左边距（边距以像素为单位）"</p>
		*@see laya.display.Text.padding
		*/
		__getset(0,__proto,'padding',function(){
			return this._tf.padding.join(",");
			},function(value){
			this._tf.padding=UIUtils.fillArray(Styles.labelPadding,value,Number);
		});

		/**
		*@copy laya.display.Text#bgColor
		*/
		__getset(0,__proto,'bgColor',function(){
			return this._tf.bgColor
			},function(value){
			this._tf.bgColor=value;
		});

		/**
		*@inheritDoc
		*/
		__getset(0,__proto,'measureWidth',function(){
			return this._tf.width;
		});

		/**
		*@copy laya.display.Text#borderColor
		*/
		__getset(0,__proto,'borderColor',function(){
			return this._tf.borderColor
			},function(value){
			this._tf.borderColor=value;
		});

		/**
		*@copy laya.display.Text#stroke
		*/
		__getset(0,__proto,'stroke',function(){
			return this._tf.stroke;
			},function(value){
			this._tf.stroke=value;
		});

		/**
		*@copy laya.display.Text#asPassword
		*/
		__getset(0,__proto,'asPassword',function(){
			return this._tf.asPassword;
			},function(value){
			this._tf.asPassword=value;
		});

		/**
		*@inheritDoc
		*/
		__getset(0,__proto,'measureHeight',function(){
			return this._tf.height;
		});

		/**
		*@inheritDoc
		*/
		/**
		*@inheritDoc
		*/
		__getset(0,__proto,'width',function(){
			if (this._width || this._tf.text)return _super.prototype._$get_width.call(this);
			return 0;
			},function(value){
			_super.prototype._$set_width.call(this,value);
			this._tf.width=value;
		});

		/**
		*@inheritDoc
		*/
		/**
		*@inheritDoc
		*/
		__getset(0,__proto,'height',function(){
			if (this._height || this._tf.text)return _super.prototype._$get_height.call(this);
			return 0;
			},function(value){
			_super.prototype._$set_height.call(this,value);
			this._tf.height=value;
		});

		/**@inheritDoc */
		__getset(0,__proto,'dataSource',_super.prototype._$get_dataSource,function(value){
			this._dataSource=value;
			if ((typeof value=='number')|| (typeof value=='string'))this.text=value+"";
			else _super.prototype._$set_dataSource.call(this,value);
		});

		return Label;
	})(Component)


	/**
	*<code>ProgressBar</code> 组件显示内容的加载进度。
	*@example 以下示例代码，创建了一个新的 <code>ProgressBar</code> 实例，设置了它的皮肤、位置、宽高、网格等信息，并添加到舞台上。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.ProgressBar;
		*import laya.utils.Handler;
		*public class ProgressBar_Example
		*{
			*private var progressBar:ProgressBar;
			*public function ProgressBar_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/progress.png","resource/ui/progress$bar.png"],Handler.create(this,onLoadComplete));//加载资源。
				*}
			*
			*private function onLoadComplete():void
			*{
				*progressBar=new ProgressBar("resource/ui/progress.png");//创建一个 ProgressBar 类的实例对象 progressBar 。
				*progressBar.x=100;//设置 progressBar 对象的属性 x 的值，用于控制 progressBar 对象的显示位置。
				*progressBar.y=100;//设置 progressBar 对象的属性 y 的值，用于控制 progressBar 对象的显示位置。
				*progressBar.value=0.3;//设置 progressBar 的进度值。
				*progressBar.width=200;//设置 progressBar 的宽度。
				*progressBar.height=50;//设置 progressBar 的高度。
				*progressBar.sizeGrid="5,10,5,10";//设置 progressBar 的网格信息。
				*progressBar.changeHandler=new Handler(this,onChange);//设置 progressBar 的value值改变时执行的处理器。
				*Laya.stage.addChild(progressBar);//将 progressBar 添加到显示列表。
				*Laya.timer.once(3000,this,changeValue);//设定 3000ms（毫秒）后，执行函数changeValue。
				*}
			*
			*private function changeValue():void
			*{
				*trace("改变进度条的进度值。");
				*progressBar.value=0.6;
				*}
			*
			*private function onChange(value:Number):void
			*{
				*trace("进度发生改变： value=" ,value);
				*}
			*}
		*}
	*
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*var res=["resource/ui/progress.png","resource/ui/progress$bar.png"];
	*Laya.loader.load(res,laya.utils.Handler.create(this,onLoadComplete));//加载资源。
	*function onLoadComplete()
	*{
		*progressBar=new laya.ui.ProgressBar("resource/ui/progress.png");//创建一个 ProgressBar 类的实例对象 progressBar 。
		*progressBar.x=100;//设置 progressBar 对象的属性 x 的值，用于控制 progressBar 对象的显示位置。
		*progressBar.y=100;//设置 progressBar 对象的属性 y 的值，用于控制 progressBar 对象的显示位置。
		*progressBar.value=0.3;//设置 progressBar 的进度值。
		*progressBar.width=200;//设置 progressBar 的宽度。
		*progressBar.height=50;//设置 progressBar 的高度。
		*progressBar.sizeGrid="10,5,10,5";//设置 progressBar 的网格信息。
		*progressBar.changeHandler=new laya.utils.Handler(this,onChange);//设置 progressBar 的value值改变时执行的处理器。
		*Laya.stage.addChild(progressBar);//将 progressBar 添加到显示列表。
		*Laya.timer.once(3000,this,changeValue);//设定 3000ms（毫秒）后，执行函数changeValue。
		*}
	*function changeValue()
	*{
		*console.log("改变进度条的进度值。");
		*progressBar.value=0.6;
		*}
	*
	*function onChange(value)
	*{
		*console.log("进度发生改变： value=" ,value);
		*}
	*</listing>
	*<listing version="3.0">
	*import ProgressBar=laya.ui.ProgressBar;
	*import Handler=laya.utils.Handler;
	*class ProgressBar_Example {
		*private progressBar:ProgressBar;
		*public ProgressBar_Example(){
			*Laya.init(640,800);//设置游戏画布宽高。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load(["resource/ui/progress.png","resource/ui/progress$bar.png"],Handler.create(this,this.onLoadComplete));//加载资源。
			*}
		*private onLoadComplete():void {
			*this.progressBar=new ProgressBar("resource/ui/progress.png");//创建一个 ProgressBar 类的实例对象 progressBar 。
			*this.progressBar.x=100;//设置 progressBar 对象的属性 x 的值，用于控制 progressBar 对象的显示位置。
			*this.progressBar.y=100;//设置 progressBar 对象的属性 y 的值，用于控制 progressBar 对象的显示位置。
			*this.progressBar.value=0.3;//设置 progressBar 的进度值。
			*this.progressBar.width=200;//设置 progressBar 的宽度。
			*this.progressBar.height=50;//设置 progressBar 的高度。
			*this.progressBar.sizeGrid="5,10,5,10";//设置 progressBar 的网格信息。
			*this.progressBar.changeHandler=new Handler(this,this.onChange);//设置 progressBar 的value值改变时执行的处理器。
			*Laya.stage.addChild(this.progressBar);//将 progressBar 添加到显示列表。
			*Laya.timer.once(3000,this,this.changeValue);//设定 3000ms（毫秒）后，执行函数changeValue。
			*}
		*private changeValue():void {
			*console.log("改变进度条的进度值。");
			*this.progressBar.value=0.6;
			*}
		*private onChange(value:number):void {
			*console.log("进度发生改变： value=",value);
			*}
		*}
	*</listing>
	*/
	//class laya.ui.ProgressBar extends laya.ui.Component
	var ProgressBar=(function(_super){
		function ProgressBar(skin){
			this.changeHandler=null;
			this._bg=null;
			this._bar=null;
			this._skin=null;
			this._value=0.5;
			ProgressBar.__super.call(this);
			this.skin=skin;
		}

		__class(ProgressBar,'laya.ui.ProgressBar',_super);
		var __proto=ProgressBar.prototype;
		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			this._bg && this._bg.destroy(destroyChild);
			this._bar && this._bar.destroy(destroyChild);
			this._bg=this._bar=null;
			this.changeHandler=null;
		}

		/**@inheritDoc */
		__proto.createChildren=function(){
			this.addChild(this._bg=new Image());
			this.addChild(this._bar=new Image());
			this._bar["_bitmap"].autoCacheCmd=false;
		}

		/**
		*@private
		*更改进度值的显示。
		*/
		__proto.changeValue=function(){
			if (this.sizeGrid){
				var grid=this.sizeGrid.split(",");
				var left=Number(grid[0]);
				var right=Number(grid[2]);
				var max=this.width-left-right;
				var sw=max *this._value;
				this._bar.width=left+right+sw;
				this._bar.visible=this._bar.width > left+right;
				}else {
				this._bar.width=this.width *this._value;
			}
		}

		/**
		*@copy laya.ui.Image#skin
		*/
		__getset(0,__proto,'skin',function(){
			return this._skin;
			},function(value){
			if (this._skin !=value){
				this._skin=value;
				this._bg.skin=this._skin;
				this._bar.skin=this._skin.replace(".png","$bar.png");
				this.callLater(this.changeValue);
			}
		});

		/**
		*获取进度条对象。
		*/
		__getset(0,__proto,'bar',function(){
			return this._bar;
		});

		/**@inheritDoc */
		__getset(0,__proto,'measureHeight',function(){
			return this._bg.height;
		});

		/**@inheritDoc */
		__getset(0,__proto,'measureWidth',function(){
			return this._bg.width;
		});

		/**
		*<p>当前 <code>ProgressBar</code> 实例的进度条背景位图（ <code>Image</code> 实例）的有效缩放网格数据。</p>
		*<p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
		*<ul><li>例如："4,4,4,4,1"</li></ul></p>
		*@see laya.ui.AutoBitmap.sizeGrid
		*/
		__getset(0,__proto,'sizeGrid',function(){
			return this._bg.sizeGrid;
			},function(value){
			this._bg.sizeGrid=this._bar.sizeGrid=value;
		});

		/**
		*获取背景条对象。
		*/
		__getset(0,__proto,'bg',function(){
			return this._bg;
		});

		/**@inheritDoc */
		__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
			_super.prototype._$set_height.call(this,value);
			this._bg.height=this._height;
			this._bar.height=this._height;
		});

		/**
		*当前的进度量。
		*<p><b>取值：</b>介于0和1之间。</p>
		*/
		__getset(0,__proto,'value',function(){
			return this._value;
			},function(num){
			if (this._value !=num){
				num=num > 1 ? 1 :num < 0 ? 0 :num;
				this._value=num;
				this.callLater(this.changeValue);
				this.event("change");
				this.changeHandler && this.changeHandler.runWith(num);
			}
		});

		/**@inheritDoc */
		__getset(0,__proto,'width',_super.prototype._$get_width,function(value){
			_super.prototype._$set_width.call(this,value);
			this._bg.width=this._width;
			this.callLater(this.changeValue);
		});

		/**@inheritDoc */
		__getset(0,__proto,'dataSource',_super.prototype._$get_dataSource,function(value){
			this._dataSource=value;
			if ((typeof value=='number')|| (typeof value=='string'))this.value=Number(value);
			else _super.prototype._$set_dataSource.call(this,value);
		});

		return ProgressBar;
	})(Component)


	/**
	*<code>HTMLImage</code> 用于创建 HTML Image 元素。
	*/
	//class laya.resource.HTMLImage extends laya.resource.FileBitmap
	var HTMLImage=(function(_super){
		function HTMLImage(im){
			this._recreateLock=false;
			this._needReleaseAgain=false;
			this._source=im || new Browser.window.Image();
			HTMLImage.__super.call(this);
		}

		__class(HTMLImage,'laya.resource.HTMLImage',_super);
		var __proto=HTMLImage.prototype;
		/**
		*@inheritDoc
		*/
		__proto.recreateResource=function(){
			var _$this=this;
			if (this._src==="")
				throw new Error("src不能为空！");
			this.startCreate();
			if (!this._source){
				this._recreateLock=true;
				var _this=this;
				this._source=new Browser.window.Image();
				this._source.onload=function (){
					_this._source.onload=null;
					if (_this._needReleaseAgain){
						_this._needReleaseAgain=false;
						_this._source=null;
						return;
					}
					_this.memorySize=_$this._w *_$this._h *4;
					_this._recreateLock=false;
					_this.compoleteCreate();
				};
				this._source.src=this._src;
				}else {
				if (this._recreateLock)
					return;
				this.memorySize=this._w *this._h *4;
				this._recreateLock=false;
				this.compoleteCreate();
			}
		}

		/**
		*@inheritDoc
		*/
		__proto.detoryResource=function(){
			if (this._recreateLock)
				this._needReleaseAgain=true;
			(this._source)&& (this._source=null,this.memorySize=0);
		}

		/***调整尺寸。*/
		__proto.onresize=function(){
			this._w=this._source.width;
			this._h=this._source.height;
		}

		/**
		*@inheritDoc
		*/
		__proto.dispose=function(){
			this.resourceManager.removeResource(this);
			laya.resource.Bitmap.prototype.dispose.call(this);
		}

		/***
		*HTML Image。
		*/
		__getset(0,__proto,'source',function(){
			return this._source;
		});

		/**
		*@inheritDoc
		*/
		__getset(0,__proto,'onload',null,function(value){
			var _$this=this;
			this._onload=value;
			this._source && (this._source.onload=this._onload !=null ? (function(){
				_$this.onresize();
				_$this._onload();
			}):null);
		});

		/**
		*@inheritDoc
		*/
		__getset(0,__proto,'src',_super.prototype._$get_src,function(value){
			this._src=value;
			this._source && (this._source.src=this._src);
		});

		/**
		*@inheritDoc
		*/
		__getset(0,__proto,'onerror',null,function(value){
			var _$this=this;
			this._onerror=value;
			this._source && (this._source.onerror=this._onerror !=null ? (function(){
				_$this._onerror()
			}):null);
		});

		return HTMLImage;
	})(FileBitmap)


	/**
	*<code>View</code> 是一个视图类。
	*@internal <p><code>View</code></p>
	*/
	//class laya.ui.View extends laya.ui.Box
	var View=(function(_super){
		function View(){View.__super.call(this);;
		};

		__class(View,'laya.ui.View',_super);
		var __proto=View.prototype;
		/**
		*@private
		*通过视图数据创建视图。
		*@param uiView 视图数据信息。
		*/
		__proto.createView=function(uiView){
			View.createComp(uiView,this,this);
		}

		/**
		*@private
		*装载UI视图。用于加载模式。
		*@param path UI资源地址。
		*/
		__proto.loadUI=function(path){
			var uiView=View.uiMap[path];
			uiView && this.createView(uiView);
		}

		View.createComp=function(uiView,comp,view){
			comp=comp || View.getCompInstance(uiView);
			var child=uiView.child;
			if (child){
				for (var i=0,n=child.length;i < n;i++){
					var node=child[i];
					if (comp.hasOwnProperty("itemRender")&& node.props.name=="render"){
						(comp).itemRender=node;
						}else {
						comp.addChild(View.createComp(node,null,view));
					}
				}
			};
			var props=uiView.props;
			for (var prop in props){
				var value=props[prop];
				View.setCompValue(comp,prop,value,view);
			}
			if (comp["initItems"])(comp).initItems();
			return comp;
		}

		View.setCompValue=function(comp,prop,value,view){
			if (prop==="var" && view){
				view[value]=comp;
				}else if (prop==="width" || prop==="height" || prop==="x" || prop==="y" || prop==="pivotX" || prop==="pivotY" || (typeof (comp[prop])=='number')){
				comp[prop]=Number(value);
				}else {
				comp[prop]=(value==="true" ? true :(value==="false" ? false :value))
			}
		}

		View.getCompInstance=function(json){
			var runtime=json.props ? json.props.runtime :"";
			var compClass=runtime ? (View.viewClassMap[runtime] || Laya["__classmap"][runtime]):View.uiClassMap[json.type];
			return compClass ? new compClass():null;
		}

		View.regComponent=function(key,compClass){
			View.uiClassMap[key]=compClass;
		}

		View.regViewRuntime=function(key,compClass){
			View.viewClassMap[key]=compClass;
		}

		View.uiMap={};
		View.viewClassMap={};
		__static(View,
		['uiClassMap',function(){return this.uiClassMap={"ViewStack":ViewStack,"LinkButton":Button,"TextArea":TextArea,"ColorPicker":ColorPicker,"Box":Box,"Button":Button,"CheckBox":CheckBox,"Clip":Clip,"ComboBox":ComboBox,"Component":Component,"HScrollBar":HScrollBar,"HSlider":HSlider,"Image":Image,"Label":Label,"List":List,"Panel":Panel,"ProgressBar":ProgressBar,"Radio":Radio,"RadioGroup":RadioGroup,"ScrollBar":ScrollBar,"Slider":Slider,"Tab":Tab,"TextInput":TextInput,"View":View,"VScrollBar":VScrollBar,"VSlider":VSlider,"Tree":Tree,"HBox":HBox,"VBox":VBox};}
		]);
		return View;
	})(Box)


	/**
	*<code>Group</code> 是一个可以自动布局的项集合控件。
	*<p> <code>Group</code> 的默认项对象为 <code>Button</code> 类实例。
	*<code>Group</code> 是 <code>Tab</code> 和 <code>RadioGroup</code> 的基类。</p>
	*/
	//class laya.ui.Group extends laya.ui.Box
	var Group=(function(_super){
		function Group(labels,skin){
			this.selectHandler=null;
			this._items=null;
			this._selectedIndex=-1;
			this._skin=null;
			this._direction="horizontal";
			this._space=0;
			this._labels=null;
			this._labelColors=null;
			this._labelStrokeColor=null;
			this._strokeColors=null;
			this._labelStroke=NaN;
			this._labelSize=0;
			this._labelBold=false;
			this._labelPadding=null;
			this._labelAlign=null;
			this._stateNum=0;
			Group.__super.call(this);
			this.skin=skin;
			this.labels=labels;
		}

		__class(Group,'laya.ui.Group',_super);
		var __proto=Group.prototype;
		Laya.imps(__proto,{"laya.ui.IItem":true})
		/**@inheritDoc */
		__proto.preinitialize=function(){
			this.mouseEnabled=true;
		}

		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			laya.ui.Component.prototype.destroy.call(this,destroyChild);
			this._items && (this._items.length=0);
			this._items=null;
			this.selectHandler=null;
		}

		/**
		*添加一个项对象，返回此项对象的索引id。
		*
		*@param item 需要添加的项对象。
		*@param autoLayOut 是否自动布局，如果为true，会根据 <code>direction</code> 和 <code>space</code> 属性计算item的位置。
		*@return
		*/
		__proto.addItem=function(item,autoLayOut){
			(autoLayOut===void 0)&& (autoLayOut=true);
			var display=item;
			var index=this._items.length;
			display.name="item"+index;
			this.addChild(display);
			this.initItems();
			if (autoLayOut && index > 0){
				var preItem=this._items [index-1];
				if (this._direction=="horizontal"){
					display.x=preItem.x+preItem.width+this._space;
					}else {
					display.y=preItem.y+preItem.height+this._space;
				}
				}else {
				if (autoLayOut){
					display.x=0;
					display.y=0;
				}
			}
			return index;
		}

		/**
		*删除一个项对象。
		*@param item 需要删除的项对象。
		*@param autoLayOut 是否自动布局，如果为true，会根据 <code>direction</code> 和 <code>space</code> 属性计算item的位置。
		*/
		__proto.delItem=function(item,autoLayOut){
			(autoLayOut===void 0)&& (autoLayOut=true);
			var index=this._items.indexOf(item);
			if (index !=-1){
				var display=item;
				this.removeChild(display);
				for (var i=index+1,n=this._items.length;i < n;i++){
					var child=this._items [i];
					child.name="item"+(i-1);
					if (autoLayOut){
						if (this._direction=="horizontal"){
							child.x-=display.width+this._space;
							}else {
							child.y-=display.height+this._space;
						}
					}
				}
				this.initItems();
				if (this._selectedIndex >-1){
					var newIndex=0;
					newIndex=this._selectedIndex < this._items.length ? this._selectedIndex :(this._selectedIndex-1);
					this._selectedIndex=-1;
					this.selectedIndex=newIndex;
				}
			}
		}

		/**
		*初始化项对象们。
		*/
		__proto.initItems=function(){
			this._items || (this._items=[]);
			this._items.length=0;
			for (var i=0;i < 10000;i++){
				var item=this.getChildByName("item"+i);
				if (item==null)break ;
				this._items.push(item);
				item.selected=(i===this._selectedIndex);
				item.clickHandler=Handler.create(this,this.itemClick,[i],false);
			}
		}

		/**
		*@private
		*项对象的点击事件侦听处理函数。
		*@param index 项索引。
		*/
		__proto.itemClick=function(index){
			this.selectedIndex=index;
		}

		/**
		*@private
		*通过对象的索引设置项对象的 <code>selected</code> 属性值。
		*@param index 需要设置的项对象的索引。
		*@param selected 表示项对象的选中状态。
		*/
		__proto.setSelect=function(index,selected){
			if (this._items && index >-1 && index < this._items.length)this._items[index].selected=selected;
		}

		/**
		*@private
		*创建一个项显示对象。
		*@param skin 项对象的皮肤。
		*@param label 项对象标签。
		*/
		__proto.createItem=function(skin,label){
			return null;
		}

		/**
		*@private
		*更改项对象的属性值。
		*/
		__proto.changeLabels=function(){
			if (this._items){
				var left=0
				for (var i=0,n=this._items.length;i < n;i++){
					var btn=this._items [i];
					this._skin && (btn.skin=this._skin);
					this._labelColors && (btn.labelColors=this._labelColors);
					this._labelSize && (btn.labelSize=this._labelSize);
					this._labelStroke && (btn.labelStroke=this._labelStroke);
					this._labelStrokeColor && (btn.labelStrokeColor=this._labelStrokeColor);
					this._strokeColors && (btn.strokeColors=this._strokeColors);
					this._labelBold && (btn.labelBold=this._labelBold);
					this._labelPadding && (btn.labelPadding=this._labelPadding);
					this._labelAlign && (btn.labelAlign=this._labelAlign);
					this._stateNum && (btn.stateNum=this._stateNum);
					if (this._direction==="horizontal"){
						btn.y=0;
						btn.x=left;
						left+=btn.width+this._space;
						}else {
						btn.x=0;
						btn.y=left;
						left+=btn.height+this._space;
					}
				}
			}
			this.changeSize();
		}

		/**@inheritDoc */
		__proto.commitMeasure=function(){
			this.runCallLater(this.changeLabels);
		}

		/**
		*表示当前选择的项索引。默认值为-1。
		*/
		__getset(0,__proto,'selectedIndex',function(){
			return this._selectedIndex;
			},function(value){
			if (this._selectedIndex !=value){
				this.setSelect(this._selectedIndex,false);
				this._selectedIndex=value;
				this.setSelect(value,true);
				this.event("change");
				this.selectHandler && this.selectHandler.runWith(this._selectedIndex);
			}
		});

		/**
		*<p>描边颜色，以字符串表示。</p>
		*默认值为 "#000000"（黑色）;
		*@see laya.display.Text.strokeColor()
		*/
		__getset(0,__proto,'labelStrokeColor',function(){
			return this._labelStrokeColor;
			},function(value){
			if (this._labelStrokeColor !=value){
				this._labelStrokeColor=value;
				this.callLater(this.changeLabels);
			}
		});

		/**
		*@copy laya.ui.Image#skin
		*/
		__getset(0,__proto,'skin',function(){
			return this._skin;
			},function(value){
			if (this._skin !=value){
				this._skin=value;
				this.callLater(this.changeLabels);
			}
		});

		/**
		*标签集合字符串。以逗号做分割，如"item0,item1,item2,item3,item4,item5"。
		*/
		__getset(0,__proto,'labels',function(){
			return this._labels;
			},function(value){
			if (this._labels !=value){
				this._labels=value;
				this.removeChildren();
				this.callLater(this.changeLabels);
				if (this._labels){
					var a=this._labels.split(",");
					for (var i=0,n=a.length;i < n;i++){
						var item=this.createItem(this._skin,a[i]);
						item.name="item"+i;
						this.addChild(item);
					}
				}
				this.initItems();
			}
		});

		/**
		*@copy laya.ui.Button#labelColors()
		*/
		__getset(0,__proto,'labelColors',function(){
			return this._labelColors;
			},function(value){
			if (this._labelColors !=value){
				this._labelColors=value;
				this.callLater(this.changeLabels);
			}
		});

		/**
		*<p>描边宽度（以像素为单位）。</p>
		*默认值0，表示不描边。
		*@see laya.display.Text.stroke()
		*/
		__getset(0,__proto,'labelStroke',function(){
			return this._labelStroke;
			},function(value){
			if (this._labelStroke !=value){
				this._labelStroke=value;
				this.callLater(this.changeLabels);
			}
		});

		/**
		*表示按钮文本标签的字体大小。
		*/
		__getset(0,__proto,'stateNum',function(){
			return this._stateNum;
			},function(value){
			if (this._stateNum !=value){
				this._stateNum=value;
				this.callLater(this.changeLabels);
			}
		});

		/**
		*<p>表示各个状态下的描边颜色。</p>
		*@see laya.display.Text.strokeColor()
		*/
		__getset(0,__proto,'strokeColors',function(){
			return this._strokeColors;
			},function(value){
			if (this._strokeColors !=value){
				this._strokeColors=value;
				this.callLater(this.changeLabels);
			}
		});

		/**
		*表示按钮文本标签的字体大小。
		*/
		__getset(0,__proto,'labelSize',function(){
			return this._labelSize;
			},function(value){
			if (this._labelSize !=value){
				this._labelSize=value;
				this.callLater(this.changeLabels);
			}
		});

		/**
		*项对象们之间的间隔（以像素为单位）。
		*/
		__getset(0,__proto,'space',function(){
			return this._space;
			},function(value){
			this._space=value;
			this.callLater(this.changeLabels);
		});

		/**
		*表示按钮文本标签是否为粗体字。
		*/
		__getset(0,__proto,'labelBold',function(){
			return this._labelBold;
			},function(value){
			if (this._labelBold !=value){
				this._labelBold=value;
				this.callLater(this.changeLabels);
			}
		});

		/**
		*表示按钮文本标签的边距。
		*<p><b>格式：</b>"上边距,右边距,下边距,左边距"。</p>
		*/
		__getset(0,__proto,'labelPadding',function(){
			return this._labelPadding;
			},function(value){
			if (this._labelPadding !=value){
				this._labelPadding=value;
				this.callLater(this.changeLabels);
			}
		});

		/**
		*获取或设置当前选择的项对象。
		*/
		__getset(0,__proto,'selection',function(){
			return this._selectedIndex >-1 && this._selectedIndex < this._items.length ? this._items[this._selectedIndex] :null;
			},function(value){
			this.selectedIndex=this._items.indexOf(value);
		});

		/**
		*布局方向。
		*<p>默认值为"horizontal"。</p>
		*<p><b>取值：</b>
		*<li>"horizontal"：表示水平布局。</li>
		*<li>"vertical"：表示垂直布局。</li>
		*</p>
		*/
		__getset(0,__proto,'direction',function(){
			return this._direction;
			},function(value){
			this._direction=value;
			this.callLater(this.changeLabels);
		});

		/**
		*项对象们的存放数组。
		*/
		__getset(0,__proto,'items',function(){
			return this._items;
		});

		/**@inheritDoc */
		__getset(0,__proto,'dataSource',_super.prototype._$get_dataSource,function(value){
			this._dataSource=value;
			if (((typeof value=='number')&& Math.floor(value)==value)|| (typeof value=='string'))this.selectedIndex=int(value);
			else if ((value instanceof Array))this.labels=(value).join(",");
			else _super.prototype._$set_dataSource.call(this,value);
		});

		return Group;
	})(Box)


	/**
	*<code>LayoutBox</code> 是一个布局容器类。
	*/
	//class laya.ui.LayoutBox extends laya.ui.Box
	var LayoutBox=(function(_super){
		function LayoutBox(){
			this._space=0;
			this._align="none";
			LayoutBox.__super.call(this);
		}

		__class(LayoutBox,'laya.ui.LayoutBox',_super);
		var __proto=LayoutBox.prototype;
		/**@inheritDoc */
		__proto.addChild=function(child){
			child.on("resize",this,this.onResize);
			this.callLater(this.changeItems);
			return laya.display.Node.prototype.addChild.call(this,child);
		}

		__proto.onResize=function(e){
			this.callLater(this.changeItems);
		}

		/**@inheritDoc */
		__proto.addChildAt=function(child,index){
			child.on("resize",this,this.onResize);
			this.callLater(this.changeItems);
			return laya.display.Node.prototype.addChildAt.call(this,child,index);
		}

		/**@inheritDoc */
		__proto.removeChild=function(child){
			child.off("resize",this,this.onResize);
			this.callLater(this.changeItems);
			return laya.display.Node.prototype.removeChild.call(this,child);
		}

		/**@inheritDoc */
		__proto.removeChildAt=function(index){
			this.getChildAt(index).off("resize",this,this.onResize);
			this.callLater(this.changeItems);
			return laya.display.Node.prototype.removeChildAt.call(this,index);
		}

		/**刷新。*/
		__proto.refresh=function(){
			this.callLater(this.changeItems);
		}

		/**
		*改变子对象的布局。
		*/
		__proto.changeItems=function(){}
		/**
		*排序项目列表。可通过重写改变默认排序规则。
		*@param items 项目列表。
		*/
		__proto.sortItem=function(items){
			if (items)items.sort(function(a,b){return a.y > b.y ? 1 :-1
			});
		}

		/**子对象的间隔。*/
		__getset(0,__proto,'space',function(){
			return this._space;
			},function(value){
			this._space=value;
			this.callLater(this.changeItems);
		});

		/**子对象对齐方式。*/
		__getset(0,__proto,'align',function(){
			return this._align;
			},function(value){
			this._align=value;
			this.callLater(this.changeItems);
		});

		return LayoutBox;
	})(Box)


	/**
	*<code>List</code> 控件可显示项目列表。默认为垂直方向列表。可通过UI编辑器自定义列表。
	*
	*@example 以下示例代码，创建了一个 <code>List</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.List;
		*import laya.utils.Handler;
		*
		*public class List_Example
		*{
			*public function List_Example()
			*{
				*Laya.init(640,800,"false");//设置游戏画布宽高、渲染模式。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/vscroll.png","resource/ui/vscroll$bar.png","resource/ui/vscroll$down.png","resource/ui/vscroll$up.png"],Handler.create(this,onLoadComplete));
				*}
			*
			*private function onLoadComplete():void
			*{
				*var arr:Array=[];//创建一个数组，用于存贮列表的数据信息。
				*for (var i:int=0;i &lt;20;i++)
				*{
					*arr.push({label:"item"+i});
					*}
				*
				*var list:List=new List();//创建一个 List 类的实例对象 list 。
				*list.itemRender=Item;//设置 list 的单元格渲染器。
				*list.repeatX=1;//设置 list 的水平方向单元格数量。
				*list.repeatY=10;//设置 list 的垂直方向单元格数量。
				*list.vScrollBarSkin="resource/ui/vscroll.png";//设置 list 的垂直方向滚动条皮肤。
				*list.array=arr;//设置 list 的列表数据源。
				*list.pos(100,100);//设置 list 的位置。
				*list.selectEnable=true;//设置 list 可选。
				*list.selectHandler=new Handler(this,onSelect);//设置 list 改变选择项执行的处理器。
				*Laya.stage.addChild(list);//将 list 添加到显示列表。
				*}
			*
			*private function onSelect(index:int):void
			*{
				*trace("当前选择的项目索引： index= ",index);
				*}
			*}
		*}
	*import laya.ui.Box;
	*import laya.ui.Label;
	*class Item extends Box
	*{
		*public function Item()
		*{
			*graphics.drawRect(0,0,100,20,null,"#ff0000");
			*var label:Label=new Label();
			*label.text="100000";
			*label.name="label";//设置 label 的name属性值。
			*label.size(100,20);
			*addChild(label);
			*}
		*}
	*</listing>
	*<listing version="3.0">
	*import List=laya.ui.List;
	*import Handler=laya.utils.Handler;
	*public class List_Example {
		*public List_Example(){
			*Laya.init(640,800);//设置游戏画布宽高。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load(["resource/ui/vscroll.png","resource/ui/vscroll$bar.png","resource/ui/vscroll$down.png","resource/ui/vscroll$up.png"],Handler.create(this,this.onLoadComplete));
			*}
		*private onLoadComplete():void {
			*var arr=[];//创建一个数组，用于存贮列表的数据信息。
			*for (var i:number=0;i &lt;20;i++)
			*{
				*arr.push({label:"item"+i });
				*}
			*var list:List=new List();//创建一个 List 类的实例对象 list 。
			*list.itemRender=Item;//设置 list 的单元格渲染器。
			*list.repeatX=1;//设置 list 的水平方向单元格数量。
			*list.repeatY=10;//设置 list 的垂直方向单元格数量。
			*list.vScrollBarSkin="resource/ui/vscroll.png";//设置 list 的垂直方向滚动条皮肤。
			*list.array=arr;//设置 list 的列表数据源。
			*list.pos(100,100);//设置 list 的位置。
			*list.selectEnable=true;//设置 list 可选。
			*list.selectHandler=new Handler(this,this.onSelect);//设置 list 改变选择项执行的处理器。
			*Laya.stage.addChild(list);//将 list 添加到显示列表。
			*}
		*private onSelect(index:number):void {
			*console.log("当前选择的项目索引： index= ",index);
			*}
		*}
	*import Box=laya.ui.Box;
	*import Label=laya.ui.Label;
	*class Item extends Box {
		*constructor(){
			*this.graphics.drawRect(0,0,100,20,null,"#ff0000");
			*var label:Label=new Label();
			*label.text="100000";
			*label.name="label";//设置 label 的name属性值。
			*label.size(100,20);
			*this.addChild(label);
			*}
		*}
	*</listing>
	*/
	//class laya.ui.List extends laya.ui.Box
	var List=(function(_super){
		function List(){
			this.selectHandler=null;
			this.renderHandler=null;
			this.mouseHandler=null;
			this.selectEnable=false;
			this.totalPage=0;
			this._content=null;
			this._scrollBar=null;
			this._itemRender=null;
			this._repeatX=0;
			this._repeatY=0;
			this._repeatX2=0;
			this._repeatY2=0;
			this._spaceX=0;
			this._spaceY=0;
			this._array=null;
			this._startIndex=0;
			this._selectedIndex=-1;
			this._page=0;
			this._isVertical=true;
			this._cellSize=20;
			this._cellOffset=0;
			this._isMoved=false;
			this._cacheBox=null;
			this.cacheContent=false;
			List.__super.call(this);
			this._cells=[];
		}

		__class(List,'laya.ui.List',_super);
		var __proto=List.prototype;
		Laya.imps(__proto,{"laya.ui.IItem":true,"laya.ui.IRender":true})
		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			laya.ui.Component.prototype.destroy.call(this,destroyChild);
			this._content && this._content.destroy(destroyChild);
			this._scrollBar && this._scrollBar.destroy(destroyChild);
			this._content=null;
			this._scrollBar=null;
			this._itemRender=null;
			this._cells=null;
			this._array=null;
			this.selectHandler=this.renderHandler=this.mouseHandler=null;
		}

		/**@inheritDoc */
		__proto.createChildren=function(){
			this.addChild(this._content=new Box());
		}

		__proto.onMouseDown=function(){
			this._$P.cacheAs=_super.prototype._$get_cacheAs.call(this);
			_super.prototype._$set_cacheAs.call(this,"none");
			this._scrollBar && this._scrollBar.once("end",this,this.onScrollEnd);
		}

		__proto.onScrollEnd=function(){
			_super.prototype._$set_cacheAs.call(this,this._$P.cacheAs);
		}

		/**
		*@private
		*更改单元格的信息。
		*@internal 在此销毁、创建单元格，并设置单元格的位置等属性。相当于此列表内容发送改变时调用此函数。
		*/
		__proto.changeCells=function(){
			if (this._itemRender){
				for (var i=this._cells.length-1;i >-1;i--){
					this._cells[i].destroy();
				}
				this._cells.length=0;
				this.scrollBar=this.getChildByName("scrollBar");
				var cell=this.createItem();
				var cellWidth=cell.width+this._spaceX;
				var cellHeight=cell.height+this._spaceY;
				if (this._width > 0)this._repeatX2=this._isVertical ? Math.round(this._width / cellWidth):Math.ceil(this._width / cellWidth);
				if (this._height > 0)this._repeatY2=this._isVertical ? Math.ceil(this._height / cellHeight):Math.round(this._height / cellHeight);
				var listWidth=this._width ? this._width :(cellWidth *this.repeatX-this._spaceX);
				var listHeight=this._height ? this._height :(cellHeight *this.repeatY-this._spaceY);
				this._cellSize=this._isVertical ? cellHeight :cellWidth;
				this._cellOffset=this._isVertical ? (cellHeight *Math.max(this._repeatY2,this._repeatY)-listHeight-this._spaceY):(cellWidth *Math.max(this._repeatX2,this._repeatX)-listWidth-this._spaceX);
				if (this._isVertical && this._scrollBar)this._scrollBar.height=listHeight;
				else if (!this._isVertical && this._scrollBar)this._scrollBar.width=listWidth;
				this.setContentSize(listWidth,listHeight);
				var numX=this._isVertical ? this.repeatX :this.repeatY;
				var numY=(this._isVertical ? this.repeatY :this.repeatX)+(this._scrollBar ? 1 :0);
				this._createItems(0,numX,numY);
				if (this._array){
					this.array=this._array;
					this.runCallLater(this.renderItems);
				}
			}
		}

		__proto._createItems=function(startY,numX,numY){
			var box=this._content;
			if (this.cacheContent){
				if (!this._cacheBox){
					this._content.addChild(this._cacheBox=new Box());
					this._cacheBox.cacheAsBitmap=true;
				}
				box=this._cacheBox;
			}
			for (var k=startY;k < numY;k++){
				for (var l=0;l < numX;l++){
					var cell=this.createItem();
					cell.x=(this._isVertical ? l :k)*(cell.width+this._spaceX);
					cell.y=(this._isVertical ? k :l)*(cell.height+this._spaceY);
					cell.name="item"+(k *numX+l);
					box.addChild(cell);
					this.addCell(cell);
				}
			}
		}

		__proto.createItem=function(){
			return (typeof this._itemRender=='function')? new this._itemRender():View.createComp(this._itemRender);
		}

		/**
		*@private
		*添加单元格。
		*@param cell 需要添加的单元格对象。
		*/
		__proto.addCell=function(cell){
			cell.on("click",this,this.onCellMouse);
			cell.on("rightclick",this,this.onCellMouse);
			cell.on("mouseover",this,this.onCellMouse);
			cell.on("mouseout",this,this.onCellMouse);
			cell.on("mousedown",this,this.onCellMouse);
			cell.on("mouseup",this,this.onCellMouse);
			this._cells.push(cell);
		}

		/**
		*初始化单元格信息。
		*/
		__proto.initItems=function(){
			if (!this._itemRender){
				for (var i=0;i < 10000;i++){
					var cell=this.getChildByName("item"+i);
					if (cell){
						this.addCell(cell);
						continue ;
					}
					break ;
				}
			}
		}

		/**
		*设置可视区域大小。
		*<p>以（0，0，width参数，height参数）组成的矩形区域为可视区域。</p>
		*@param width 可视区域宽度。
		*@param height 可视区域高度。
		*/
		__proto.setContentSize=function(width,height){
			this._content.width=width;
			this._content.height=height;
			if (this._scrollBar){
				this._content.scrollRect || (this._content.scrollRect=new Rectangle());
				this._content.scrollRect.setTo(0,0,width,height);
				this.event("resize");
			}
		}

		/**
		*@private
		*单元格的鼠标事件侦听处理函数。
		*/
		__proto.onCellMouse=function(e){
			if (e.type==="mousedown")this._isMoved=false;
			var cell=e.currentTarget;
			var index=this._startIndex+this._cells.indexOf(cell);
			if (index < 0)return;
			if (e.type==="click" || e.type==="rightclick"){
				if (this.selectEnable && !this._isMoved)this.selectedIndex=index;
				else this.changeCellState(cell,true,0);
				}else if ((e.type==="mouseover" || e.type==="mouseout")&& this._selectedIndex!==index){
				this.changeCellState(cell,e.type==="mouseover",0);
			}
			this.mouseHandler && this.mouseHandler.runWith([e,index]);
		}

		/**
		*@private
		*改变单元格的可视状态。
		*@param cell 单元格对象。
		*@param visable 是否显示。
		*@param index 单元格的属性 <code>index</code> 值。
		*/
		__proto.changeCellState=function(cell,visable,index){
			var selectBox=cell.getChildByName("selectBox");
			if (selectBox){
				this.selectEnable=true;
				selectBox.visible=visable;
				selectBox.index=index;
			}
		}

		/**@inheritDoc */
		__proto.changeSize=function(){
			laya.ui.Component.prototype.changeSize.call(this);
			if (this._scrollBar)
				Laya.timer.once(10,this,this.onScrollBarChange);
		}

		/**
		*@private
		*滚动条的 <code>Event.CHANGE</code> 事件侦听处理函数。
		*/
		__proto.onScrollBarChange=function(e){
			this.runCallLater(this.changeCells);
			var scrollValue=this._scrollBar.value;
			if (!this.cacheContent){
				var lineX=(this._isVertical ? this.repeatX :this.repeatY);
				var lineY=(this._isVertical ? this.repeatY :this.repeatX);
				var index=Math.floor(scrollValue / this._cellSize)*lineX;
				if (index > this._startIndex){
					var num=index-this._startIndex;
					var down=true;
					var toIndex=this._startIndex+lineX *(lineY+1);
					this._isMoved=true;
					}else if (index < this._startIndex){
					num=this._startIndex-index;
					down=false;
					toIndex=this._startIndex-1;
					this._isMoved=true;
				}
				for (var i=0;i < num;i++){
					if (down){
						var cell=this._cells.shift();
						this._cells[this._cells.length]=cell;
						var cellIndex=toIndex+i;
						}else {
						cell=this._cells.pop();
						this._cells.unshift(cell);
						cellIndex=toIndex-i;
					};
					var pos=Math.floor(cellIndex / lineX)*this._cellSize;
					this._isVertical ? cell.y=pos :cell.x=pos;
					this.renderItem(cell,cellIndex);
				}
				this._startIndex=index;
			}
			if (this._isVertical)this._content.scrollRect.y=scrollValue;
			else this._content.scrollRect.x=scrollValue;
			this.repaint();
		}

		__proto.posCell=function(cell,cellIndex){
			if (!this._scrollBar)return;
			var lineX=(this._isVertical ? this.repeatX :this.repeatY);
			var lineY=(this._isVertical ? this.repeatY :this.repeatX);
			var pos=Math.floor(cellIndex / lineX)*this._cellSize;
			this._isVertical ? cell.y=pos :cell.x=pos;
		}

		/**
		*@private
		*改变单元格的选择状态。
		*/
		__proto.changeSelectStatus=function(){
			for (var i=0,n=this._cells.length;i < n;i++){
				this.changeCellState(this._cells[i],this._selectedIndex===this._startIndex+i,1);
			}
		}

		/**
		*@private
		*渲染单元格列表。
		*/
		__proto.renderItems=function(){
			for (var i=0,n=this._cells.length;i < n;i++){
				this.renderItem(this._cells[i],this._startIndex+i);
			}
			this.changeSelectStatus();
		}

		/**
		*渲染一个单元格。
		*@param cell 需要渲染的单元格对象。
		*@param index 单元格索引。
		*/
		__proto.renderItem=function(cell,index){
			if (index >=0 && index < this._array.length){
				cell.visible=true;
				cell.dataSource=this._array[index];
				this.posCell(cell,index);
				}else {
				cell.visible=false;
				cell.dataSource=null;
			}
			this.event("render",[cell,index]);
			this.renderHandler && this.renderHandler.runWith([cell,index]);
		}

		/**
		*刷新列表数据源。
		*/
		__proto.refresh=function(){
			this.array=this._array;
		}

		/**
		*获取单元格数据源。
		*@param index 单元格索引。
		*/
		__proto.getItem=function(index){
			if (index >-1 && index < this._array.length){
				return this._array[index];
			}
			return null;
		}

		/**
		*修改单元格数据源。
		*@param index 单元格索引。
		*@param source 单元格数据源。
		*/
		__proto.changeItem=function(index,source){
			if (index >-1 && index < this._array.length){
				this._array[index]=source;
				if (index >=this._startIndex && index < this._startIndex+this._cells.length){
					this.renderItem(this.getCell(index),index);
				}
			}
		}

		/**
		*添加单元格数据源。
		*@param souce 数据源。
		*/
		__proto.addItem=function(souce){
			this._array.push(souce);
			this.array=this._array;
		}

		/**
		*添加单元格数据源到对应的数据索引处。
		*@param souce 单元格数据源。
		*@param index 索引。
		*/
		__proto.addItemAt=function(souce,index){
			this._array.splice(index,0,souce);
			this.array=this._array;
		}

		/**
		*通过数据源索引删除单元格数据源。
		*@param index 需要删除的数据源索引值。
		*/
		__proto.deleteItem=function(index){
			this._array.splice(index,1);
			this.array=this._array;
		}

		/**
		*通过可视单元格索引，获取单元格。
		*@param index 可视单元格索引。
		*@return 单元格对象。
		*/
		__proto.getCell=function(index){
			this.runCallLater(this.changeCells);
			if (index >-1 && this._cells){
				return this._cells[(index-this._startIndex)% this._cells.length];
			}
			return null;
		}

		/**
		*<p>滚动列表，以设定的数据索引对应的单元格为当前可视列表的第一项。</p>
		*@param index 单元格在数据列表中的索引。
		*/
		__proto.scrollTo=function(index){
			if (this._scrollBar){
				var numX=this._isVertical ? this.repeatX :this.repeatY;
				this._scrollBar.value=Math.floor(index / numX)*this._cellSize;
				}else {
				this.startIndex=index;
			}
		}

		/**
		*<p>缓动滚动列表，以设定的数据索引对应的单元格为当前可视列表的第一项。</p>
		*@param index 单元格在数据列表中的索引。
		*@param time 缓动时间。
		*/
		__proto.tweenTo=function(index,time){
			(time===void 0)&& (time=200);
			if (this._scrollBar){
				var numX=this._isVertical ? this.repeatX :this.repeatY;
				Tween.to(this._scrollBar,{value:Math.floor(index / numX)*this._cellSize},time,null,null,0,true);
				}else {
				this.startIndex=index;
			}
		}

		/**@inheritDoc */
		__getset(0,__proto,'cacheAs',_super.prototype._$get_cacheAs,function(value){
			_super.prototype._$set_cacheAs.call(this,value);
			if (this._scrollBar){
				if (value!=="none")this.on("mousedown",this,this.onMouseDown);
				else this.off("mousedown",this,this.onMouseDown);
			}
		});

		/**
		*获取对 <code>List</code> 组件所包含的内容容器 <code>Box</code> 组件的引用。
		*/
		__getset(0,__proto,'content',function(){
			return this._content;
		});

		/**
		*水平方向滚动条皮肤。
		*/
		__getset(0,__proto,'hScrollBarSkin',function(){
			return this._scrollBar ? this._scrollBar.skin :null;
			},function(value){
			this.removeChildByName("scrollBar");
			var scrollBar=new HScrollBar();
			scrollBar.name="scrollBar";
			scrollBar.bottom=0;
			scrollBar.skin=value;
			this.scrollBar=scrollBar;
			this.addChild(scrollBar);
			this.callLater(this.changeCells);
		});

		/**@inheritDoc */
		__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
			_super.prototype._$set_height.call(this,value);
			this.callLater(this.changeCells);
		});

		/**
		*垂直方向滚动条皮肤。
		*/
		__getset(0,__proto,'vScrollBarSkin',function(){
			return this._scrollBar ? this._scrollBar.skin :null;
			},function(value){
			this.removeChildByName("scrollBar");
			var scrollBar=new VScrollBar();
			scrollBar.name="scrollBar";
			scrollBar.right=0;
			scrollBar.skin=value;
			this.scrollBar=scrollBar;
			this.addChild(scrollBar);
			this.callLater(this.changeCells);
		});

		/**
		*单元格渲染器。
		*<p><b>取值：</b>
		*<ol>
		*<li>单元格类对象。</li>
		*<li> UI 的 JSON 描述。</li>
		*</ol></p>
		*/
		__getset(0,__proto,'itemRender',function(){
			return this._itemRender;
			},function(value){
			this._itemRender=value;
			this.callLater(this.changeCells);
		});

		/**
		*获取对 <code>List</code> 组件所包含的滚动条 <code>ScrollBar</code> 组件的引用。
		*/
		__getset(0,__proto,'scrollBar',function(){
			return this._scrollBar;
			},function(value){
			if (this._scrollBar !=value){
				this._scrollBar=value;
				if (value){
					this.addChild(this._scrollBar);
					this._scrollBar.on("change",this,this.onScrollBarChange);
					this._isVertical=this._scrollBar.isVertical;
				}
			}
		});

		/**
		*表示当前选择的项索引。
		*/
		__getset(0,__proto,'selectedIndex',function(){
			return this._selectedIndex;
			},function(value){
			if (this._selectedIndex !=value){
				this._selectedIndex=value;
				this.changeSelectStatus();
				this.event("change");
				this.selectHandler && this.selectHandler.runWith(value);
			}
			if (this.selectEnable && this._scrollBar){
				var numX=this._isVertical ? this.repeatX :this.repeatY;
				if (value < this._startIndex || (value+numX > this._startIndex+this.repeatX *this.repeatY)){
					this.scrollTo(value);
				}
			}
		});

		/**@inheritDoc */
		__getset(0,__proto,'width',_super.prototype._$get_width,function(value){
			_super.prototype._$set_width.call(this,value);
			this.callLater(this.changeCells);
		});

		/**
		*水平方向显示的单元格数量。
		*/
		__getset(0,__proto,'repeatX',function(){
			return this._repeatX > 0 ? this._repeatX :this._repeatX2 > 0 ? this._repeatX2 :1;
			},function(value){
			this._repeatX=value;
			this.callLater(this.changeCells);
		});

		/**
		*垂直方向显示的单元格数量。
		*/
		__getset(0,__proto,'repeatY',function(){
			return this._repeatY > 0 ? this._repeatY :this._repeatY2 > 0 ? this._repeatY2 :1;
			},function(value){
			this._repeatY=value;
			this.callLater(this.changeCells);
		});

		/**
		*水平方向显示的单元格之间的间距（以像素为单位）。
		*/
		__getset(0,__proto,'spaceX',function(){
			return this._spaceX;
			},function(value){
			this._spaceX=value;
			this.callLater(this.changeCells);
		});

		/**
		*列表数据源。
		*/
		__getset(0,__proto,'array',function(){
			return this._array;
			},function(value){
			this.runCallLater(this.changeCells);
			this._array=value || [];
			if (this.cacheContent && value.length > this._cells.length){
				var numX1=this._isVertical ? this.repeatX :this.repeatY;
				var numY1=(this._isVertical ? this.repeatY :this.repeatX)+(this._scrollBar ? 1 :0);
				var num1=Math.ceil(value.length / numX1);
				this._createItems(numY1,numX1,num1);
			};
			var length=this._array.length;
			this.totalPage=Math.ceil(length / (this.repeatX *this.repeatY));
			this._selectedIndex=this._selectedIndex < length ? this._selectedIndex :length-1;
			this.startIndex=this._startIndex;
			if (this._scrollBar){
				var numX=this._isVertical ? this.repeatX :this.repeatY;
				var numY=this._isVertical ? this.repeatY :this.repeatX;
				var lineCount=Math.ceil(length / numX);
				var total=this._cellOffset > 0 ? this.totalPage+1 :this.totalPage;
				if (total > 1){
					this._scrollBar.scrollSize=this._cellSize;
					this._scrollBar.thumbPercent=numY / lineCount;
					this._scrollBar.setScroll(0,(lineCount-numY)*this._cellSize+this._cellOffset,this._isVertical ? this._content.scrollRect.y :this._content.scrollRect.x);
					this._scrollBar.target=this._content;
					}else {
					this._scrollBar.setScroll(0,0,0);
					this._scrollBar.target=this._content;
				}
			}
		});

		/**
		*垂直方向显示的单元格之间的间距（以像素为单位）。
		*/
		__getset(0,__proto,'spaceY',function(){
			return this._spaceY;
			},function(value){
			this._spaceY=value;
			this.callLater(this.changeCells);
		});

		/**
		*当前选中的单元格数据源。
		*/
		__getset(0,__proto,'selectedItem',function(){
			return this._selectedIndex !=-1 ? this._array[this._selectedIndex] :null;
			},function(value){
			this.selectedIndex=this._array.indexOf(value);
		});

		/**
		*获取或设置当前选择的单元格对象。
		*/
		__getset(0,__proto,'selection',function(){
			return this.getCell(this._selectedIndex);
			},function(value){
			this.selectedIndex=this._startIndex+this._cells.indexOf(value);
		});

		/**
		*当前显示的单元格列表的开始索引。
		*/
		__getset(0,__proto,'startIndex',function(){
			return this._startIndex;
			},function(value){
			this._startIndex=value > 0 ? value :0;
			this.callLater(this.renderItems);
		});

		/**
		*列表的当前页码。
		*/
		__getset(0,__proto,'page',function(){
			return this._page;
			},function(value){
			this._page=value
			if (this._array){
				this._page=value > 0 ? value :0;
				this._page=this._page < this.totalPage ? this._page :this.totalPage-1;
				this.startIndex=this._page *this.repeatX *this.repeatY;
			}
		});

		/**
		*列表的数据总个数。
		*/
		__getset(0,__proto,'length',function(){
			return this._array.length;
		});

		/**@inheritDoc */
		__getset(0,__proto,'dataSource',_super.prototype._$get_dataSource,function(value){
			this._dataSource=value;
			if (((typeof value=='number')&& Math.floor(value)==value)|| (typeof value=='string'))this.selectedIndex=Laya.__parseInt(value);
			else if ((value instanceof Array))this.array=value
			else _super.prototype._$set_dataSource.call(this,value);
		});

		/**
		*单元格集合。
		*/
		__getset(0,__proto,'cells',function(){
			this.runCallLater(this.changeCells);
			return this._cells;
		});

		return List;
	})(Box)


	/**
	*<code>Panel</code> 是一个面板容器类。
	*/
	//class laya.ui.Panel extends laya.ui.Box
	var Panel=(function(_super){
		function Panel(){
			this._content=null;
			this._vScrollBar=null;
			this._hScrollBar=null;
			Panel.__super.call(this);
			this.width=this.height=100;
			this._content.optimizeFloat=true;
		}

		__class(Panel,'laya.ui.Panel',_super);
		var __proto=Panel.prototype;
		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			laya.ui.Component.prototype.destroy.call(this,destroyChild);
			this._content && this._content.destroy(destroyChild);
			this._vScrollBar && this._vScrollBar.destroy(destroyChild);
			this._hScrollBar && this._hScrollBar.destroy(destroyChild);
			this._vScrollBar=null;
			this._hScrollBar=null;
			this._content=null;
		}

		/**@inheritDoc */
		__proto.destroyChildren=function(){
			this._content.destroyChildren();
		}

		/**@inheritDoc */
		__proto.createChildren=function(){
			laya.display.Node.prototype.addChild.call(this,this._content=new Box());
		}

		/**@inheritDoc */
		__proto.addChild=function(child){
			child.on("resize",this,this.onResize);
			this.callLater(this.changeScroll);
			return this._content.addChild(child);
		}

		/**
		*@private
		*子对象的 <code>Event.RESIZE</code> 事件侦听处理函数。
		*/
		__proto.onResize=function(e){
			this.callLater(this.changeScroll);
		}

		/**@inheritDoc */
		__proto.addChildAt=function(child,index){
			child.on("resize",this,this.onResize);
			this.callLater(this.changeScroll);
			return this._content.addChildAt(child,index);
		}

		/**@inheritDoc */
		__proto.removeChild=function(child){
			child.off("resize",this,this.onResize);
			this.callLater(this.changeScroll);
			return this._content.removeChild(child);
		}

		/**@inheritDoc */
		__proto.removeChildAt=function(index){
			this.getChildAt(index).off("resize",this,this.onResize);
			this.callLater(this.changeScroll);
			return this._content.removeChildAt(index);
		}

		/**@inheritDoc */
		__proto.removeChildren=function(beginIndex,endIndex){
			(beginIndex===void 0)&& (beginIndex=0);
			(endIndex===void 0)&& (endIndex=0x7fffffff);
			for (var i=this._content.numChildren-1;i >-1;i--){
				this._content.removeChildAt(i);
			}
			this.callLater(this.changeScroll);
			return this;
		}

		/**@inheritDoc */
		__proto.getChildAt=function(index){
			return this._content.getChildAt(index);
		}

		/**@inheritDoc */
		__proto.getChildByName=function(name){
			return this._content.getChildByName(name);
		}

		/**@inheritDoc */
		__proto.getChildIndex=function(child){
			return this._content.getChildIndex(child);
		}

		/**@private */
		__proto.changeScroll=function(){
			var contentW=this.contentWidth;
			var contentH=this.contentHeight;
			var vscroll=this._vScrollBar;
			var hscroll=this._hScrollBar;
			var vShow=vscroll && contentH > this._height;
			var hShow=hscroll && contentW > this._width;
			var showWidth=vShow ? this._width-vscroll.width :this._width;
			var showHeight=hShow ? this._height-hscroll.height :this._height;
			if (vscroll){
				vscroll.x=this._width-vscroll.width;
				vscroll.y=0;
				vscroll.height=this._height-(hShow ? hscroll.height :0);
				vscroll.scrollSize=Math.max(this._height *0.033,1);
				vscroll.thumbPercent=showHeight / contentH;
				vscroll.setScroll(0,contentH-showHeight,vscroll.value);
			}
			if (hscroll){
				hscroll.x=0;
				hscroll.y=this._height-hscroll.height;
				hscroll.width=this._width-(vShow ? vscroll.width :0);
				hscroll.scrollSize=Math.max(this._width *0.033,1);
				hscroll.thumbPercent=showWidth / contentW;
				hscroll.setScroll(0,contentW-showWidth,hscroll.value);
			}
		}

		/**@inheritDoc */
		__proto.changeSize=function(){
			laya.ui.Component.prototype.changeSize.call(this);
			this.setContentSize(this._width,this._height);
		}

		/**
		*@private
		*设置内容的宽度、高度（以像素为单位）。
		*@param width 宽度。
		*@param height 高度。
		*/
		__proto.setContentSize=function(width,height){
			var content=this._content;
			content.width=width;
			content.height=height;
			content.scrollRect || (content.scrollRect=new Rectangle());
			content.scrollRect.setTo(0,0,width,height);
		}

		/**
		*@private
		*滚动条的<code><code>Event.MOUSE_DOWN</code>事件侦听处理函数。</code>事件侦听处理函数。
		*@param scrollBar 滚动条对象。
		*@param e Event 对象。
		*/
		__proto.onScrollBarChange=function(scrollBar,e){
			var rect=this._content.scrollRect;
			if (rect){
				var start=Math.round(scrollBar.value);
				scrollBar.isVertical ? rect.y=start :rect.x=start;
			}
		}

		/**
		*<p>滚动内容容器至设定的垂直、水平方向滚动条位置。</p>
		*@param x 水平方向滚动条属性value值。滚动条位置数字。
		*@param y 垂直方向滚动条属性value值。滚动条位置数字。
		*/
		__proto.scrollTo=function(x,y){
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			if (this.vScrollBar)this.vScrollBar.value=y;
			if (this.hScrollBar)this.hScrollBar.value=x;
		}

		/**
		*刷新滚动内容。
		*/
		__proto.refresh=function(){
			this.changeScroll();
		}

		__proto.onMouseDown=function(){
			this._$P.cacheAs=_super.prototype._$get_cacheAs.call(this);
			_super.prototype._$set_cacheAs.call(this,"none");
			this._hScrollBar && this._hScrollBar.once("end",this,this.onScrollEnd);
			this._vScrollBar && this._vScrollBar.once("end",this,this.onScrollEnd);
		}

		__proto.onScrollEnd=function(){
			_super.prototype._$set_cacheAs.call(this,this._$P.cacheAs);
		}

		/**@inheritDoc */
		__getset(0,__proto,'numChildren',function(){
			return this._content.numChildren;
		});

		/**
		*@private
		*获取内容宽度（以像素为单位）。
		*/
		__getset(0,__proto,'contentWidth',function(){
			var max=0;
			for (var i=this._content.numChildren-1;i >-1;i--){
				var comp=this._content.getChildAt(i);
				max=Math.max(comp.x+comp.width *comp.scaleX,max);
			}
			return max;
		});

		/**
		*@private
		*获取内容高度（以像素为单位）。
		*/
		__getset(0,__proto,'contentHeight',function(){
			var max=0;
			for (var i=this._content.numChildren-1;i >-1;i--){
				var comp=this._content.getChildAt(i);
				max=Math.max(comp.y+comp.height *comp.scaleY,max);
			}
			return max;
		});

		/**
		*垂直方向滚动条对象。
		*/
		__getset(0,__proto,'vScrollBar',function(){
			return this._vScrollBar;
		});

		/**
		*@inheritDoc
		*/
		__getset(0,__proto,'width',_super.prototype._$get_width,function(value){
			_super.prototype._$set_width.call(this,value);
			this.callLater(this.changeScroll);
		});

		/**
		*水平方向滚动条皮肤。
		*/
		__getset(0,__proto,'hScrollBarSkin',function(){
			return this._hScrollBar ? this._hScrollBar.skin :null;
			},function(value){
			if (this._hScrollBar==null){
				laya.display.Node.prototype.addChild.call(this,this._hScrollBar=new HScrollBar());
				this._hScrollBar.on("change",this,this.onScrollBarChange,[this._hScrollBar]);
				this._hScrollBar.target=this._content;
				this.callLater(this.changeScroll);
			}
			this._hScrollBar.skin=value;
		});

		/**@inheritDoc */
		__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
			_super.prototype._$set_height.call(this,value);
			this.callLater(this.changeScroll);
		});

		/**
		*垂直方向滚动条皮肤。
		*/
		__getset(0,__proto,'vScrollBarSkin',function(){
			return this._vScrollBar ? this._vScrollBar.skin :null;
			},function(value){
			if (this._vScrollBar==null){
				laya.display.Node.prototype.addChild.call(this,this._vScrollBar=new VScrollBar());
				this._vScrollBar.on("change",this,this.onScrollBarChange,[this._vScrollBar]);
				this._vScrollBar.target=this._content;
				this.callLater(this.changeScroll);
			}
			this._vScrollBar.skin=value;
		});

		/**
		*水平方向滚动条对象。
		*/
		__getset(0,__proto,'hScrollBar',function(){
			return this._hScrollBar;
		});

		/**
		*获取内容容器对象。
		*/
		__getset(0,__proto,'content',function(){
			return this._content;
		});

		/**@inheritDoc */
		__getset(0,__proto,'cacheAs',_super.prototype._$get_cacheAs,function(value){
			_super.prototype._$set_cacheAs.call(this,value);
			if (value!=="none")this.on("mousedown",this,this.onMouseDown);
			else this.off("mousedown",this,this.onMouseDown);
		});

		return Panel;
	})(Box)


	/**
	*<code>Tree</code> 控件使用户可以查看排列为可扩展树的层次结构数据。
	*
	*@example 以下示例代码，创建了一个 <code>Tree</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.Tree;
		*import laya.utils.Browser;
		*import laya.utils.Handler;
		*
		*public class Tree_Example
		*{
			*
			*public function Tree_Example()
			*{
				*Laya.init(640,800);
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/vscroll.png","resource/ui/vscroll$bar.png","resource/ui/vscroll$down.png","resource/ui/vscroll$up.png","resource/ui/clip_selectBox.png","resource/ui/clip_tree_folder.png","resource/ui/clip_tree_arrow.png"],Handler.create(this,onLoadComplete));
				*}
			*
			*private function onLoadComplete():void
			*{
				*var xmlString:String;//创建一个xml字符串，用于存储树结构数据。
				*xmlString="&lt;root&gt;&lt;item label='box1'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;abc label='child5'/&gt;&lt;/item&gt;&lt;item label='box2'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;/item&gt;&lt;/root&gt;";
				*var domParser:*=new Browser.window.DOMParser();//创建一个DOMParser实例domParser。
				*var xml:*=domParser.parseFromString(xmlString,"text/xml");//解析xml字符。
				*
				*var tree:Tree=new Tree();//创建一个 Tree 类的实例对象 tree 。
				*tree.scrollBarSkin="resource/ui/vscroll.png";//设置 tree 的皮肤。
				*tree.itemRender=Item;//设置 tree 的项渲染器。
				*tree.xml=xml;//设置 tree 的树结构数据。
				*tree.x=100;//设置 tree 对象的属性 x 的值，用于控制 tree 对象的显示位置。
				*tree.y=100;//设置 tree 对象的属性 y 的值，用于控制 tree 对象的显示位置。
				*tree.width=200;//设置 tree 的宽度。
				*tree.height=100;//设置 tree 的高度。
				*Laya.stage.addChild(tree);//将 tree 添加到显示列表。
				*}
			*}
		*}
	*
	*import laya.ui.Box;
	*import laya.ui.Clip;
	*import laya.ui.Label;
	*class Item extends Box
	*{
		*public function Item()
		*{
			*this.name="render";
			*this.right=0;
			*this.left=0;
			*
			*var selectBox:Clip=new Clip("resource/ui/clip_selectBox.png",1,2);
			*selectBox.name="selectBox";
			*selectBox.height=24;
			*selectBox.x=13;
			*selectBox.y=0;
			*selectBox.left=12;
			*addChild(selectBox);
			*
			*var folder:Clip=new Clip("resource/ui/clip_tree_folder.png",1,3);
			*folder.name="folder";
			*folder.x=14;
			*folder.y=4;
			*addChild(folder);
			*
			*var label:Label=new Label("treeItem");
			*label.name="label";
			*label.color="#ffff00";
			*label.width=150;
			*label.height=22;
			*label.x=33;
			*label.y=1;
			*label.left=33;
			*label.right=0;
			*addChild(label);
			*
			*var arrow:Clip=new Clip("resource/ui/clip_tree_arrow.png",1,2);
			*arrow.name="arrow";
			*arrow.x=0;
			*arrow.y=5;
			*addChild(arrow);
			*}
		*}
	*
	*
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高、渲染模式
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*var res=["resource/ui/vscroll.png","resource/ui/vscroll$bar.png","resource/ui/vscroll$down.png","resource/ui/vscroll$up.png","resource/ui/clip_selectBox.png","resource/ui/clip_tree_folder.png","resource/ui/clip_tree_arrow.png"];
	*Laya.loader.load(res,new laya.utils.Handler(this,onLoadComplete));
	*function onLoadComplete(){
		*var xmlString;//创建一个xml字符串，用于存储树结构数据。
		*xmlString="&lt;root&gt;&lt;item label='box1'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;abc label='child5'/&gt;&lt;/item&gt;&lt;item label='box2'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;/item&gt;&lt;/root&gt;";
		*var domParser=new laya.utils.Browser.window.DOMParser();//创建一个DOMParser实例domParser。
		*var xml=domParser.parseFromString(xmlString,"text/xml");//解析xml字符。
		*var tree=new laya.ui.Tree();//创建一个 Tree 类的实例对象 tree 。
		*tree.scrollBarSkin="resource/ui/vscroll.png";//设置 tree 的皮肤。
		*tree.itemRender=mypackage.treeExample.Item;//设置 tree 的项渲染器。
		*tree.xml=xml;//设置 tree 的树结构数据。
		*tree.x=100;//设置 tree 对象的属性 x 的值，用于控制 tree 对象的显示位置。
		*tree.y=100;//设置 tree 对象的属性 y 的值，用于控制 tree 对象的显示位置。
		*tree.width=200;//设置 tree 的宽度。
		*tree.height=100;//设置 tree 的高度。
		*Laya.stage.addChild(tree);//将 tree 添加到显示列表。
		*}
	*(function (_super){
		*function Item(){
			*Item.__super.call(this);//初始化父类。
			*this.right=0;
			*this.left=0;
			*var selectBox=new laya.ui.Clip("resource/ui/clip_selectBox.png",1,2);
			*selectBox.name="selectBox";//设置 selectBox 的name 为“selectBox”时，将被识别为树结构的项的背景。2帧：悬停时背景、选中时背景。
			*selectBox.height=24;
			*selectBox.x=13;
			*selectBox.y=0;
			*selectBox.left=12;
			*this.addChild(selectBox);//需要使用this.访问父类的属性或方法。
			*var folder=new laya.ui.Clip("resource/ui/clip_tree_folder.png",1,3);
			*folder.name="folder";//设置 folder 的name 为“folder”时，将被识别为树结构的文件夹开启状态图表。2帧：折叠状态、打开状态。
			*folder.x=14;
			*folder.y=4;
			*this.addChild(folder);
			*var label=new laya.ui.Label("treeItem");
			*label.name="label";//设置 label 的name 为“label”时，此值将用于树结构数据赋值。
			*label.color="#ffff00";
			*label.width=150;
			*label.height=22;
			*label.x=33;
			*label.y=1;
			*label.left=33;
			*label.right=0;
			*this.addChild(label);
			*var arrow=new laya.ui.Clip("resource/ui/clip_tree_arrow.png",1,2);
			*arrow.name="arrow";//设置 arrow 的name 为“arrow”时，将被识别为树结构的文件夹开启状态图表。2帧：折叠状态、打开状态。
			*arrow.x=0;
			*arrow.y=5;
			*this.addChild(arrow);
			*};
		*Laya.class(Item,"mypackage.treeExample.Item",_super);//注册类 Item 。
		*})(laya.ui.Box);
	*</listing>
	*<listing version="3.0">
	*import Tree=laya.ui.Tree;
	*import Browser=laya.utils.Browser;
	*import Handler=laya.utils.Handler;
	*class Tree_Example {
		*
		*constructor(){*
			*Laya.init(640,800);*
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。 *
			*Laya.loader.load(["resource/ui/vscroll.png","resource/ui/vscroll$bar.png","resource/ui/vscroll$down.png","resource/ui/vscroll$up.png","resource/ui/vscroll$up.png","resource/ui/clip_selectBox.png","resource/ui/clip_tree_folder * . * png","resource/ui/clip_tree_arrow.png"],Handler.create(this,this.onLoadComplete));*
			*}*
		*private onLoadComplete():void {*
			*var xmlString:String;//创建一个xml字符串，用于存储树结构数据。 *
			*xmlString="&lt;root&gt;&lt;item label='box1'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;abc label='child5'/&gt;&lt;/item&gt;&lt;item label='box2'&gt;&lt;abc  * label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;/item&gt;&lt;/root&gt;";
			*var domParser:any=new Browser.window.DOMParser();//创建一个DOMParser实例domParser。
			*var xml:any=domParser.parseFromString(xmlString,"text/xml");//解析xml字符。
			*
			*var tree:Tree=new Tree();//创建一个 Tree 类的实例对象 tree 。
			*tree.scrollBarSkin="resource/ui/vscroll.png";//设置 tree 的皮肤。
			*tree.itemRender=Item;//设置 tree 的项渲染器。
			*tree.xml=xml;//设置 tree 的树结构数据。
			*tree.x=100;//设置 tree 对象的属性 x 的值，用于控制 tree 对象的显示位置。
			*tree.y=100;//设置 tree 对象的属性 y 的值，用于控制 tree 对象的显示位置。
			*tree.width=200;//设置 tree 的宽度。
			*tree.height=100;//设置 tree 的高度。
			*Laya.stage.addChild(tree);//将 tree 添加到显示列表。
			*}
		*}
	*import Box=laya.ui.Box;
	*import Clip=laya.ui.Clip;
	*import Label=laya.ui.Label;
	*class Item extends Box {
		*constructor(){
			*super();
			*this.name="render";
			*this.right=0;
			*this.left=0;
			*var selectBox:Clip=new Clip("resource/ui/clip_selectBox.png",1,2);
			*selectBox.name="selectBox";
			*selectBox.height=24;
			*selectBox.x=13;
			*selectBox.y=0;
			*selectBox.left=12;
			*this.addChild(selectBox);
			*
			*var folder:Clip=new Clip("resource/ui/clip_tree_folder.png",1,3);
			*folder.name="folder";
			*folder.x=14;
			*folder.y=4;
			*this.addChild(folder);
			*
			*var label:Label=new Label("treeItem");
			*label.name="label";
			*label.color="#ffff00";
			*label.width=150;
			*label.height=22;
			*label.x=33;
			*label.y=1;
			*label.left=33;
			*label.right=0;
			*this.addChild(label);
			*
			*var arrow:Clip=new Clip("resource/ui/clip_tree_arrow.png",1,2);
			*arrow.name="arrow";
			*arrow.x=0;
			*arrow.y=5;
			*this.addChild(arrow);
			*}
		*}
	*</listing>
	*/
	//class laya.ui.Tree extends laya.ui.Box
	var Tree=(function(_super){
		function Tree(){
			this._list=null;
			this._source=null;
			this._renderHandler=null;
			this._spaceLeft=10;
			this._spaceBottom=0;
			this._keepStatus=true;
			Tree.__super.call(this);
			this.width=this.height=200;
		}

		__class(Tree,'laya.ui.Tree',_super);
		var __proto=Tree.prototype;
		Laya.imps(__proto,{"laya.ui.IRender":true})
		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			laya.ui.Component.prototype.destroy.call(this,destroyChild);
			this._list && this._list.destroy(destroyChild);
			this._list=null;
			this._source=null;
			this._renderHandler=null;
		}

		/**@inheritDoc */
		__proto.createChildren=function(){
			this.addChild(this._list=new List());
			this._list.renderHandler=Handler.create(this,this.renderItem,null,false);
			this._list.repeatX=1;
			this._list.on("change",this,this.onListChange);
		}

		/**
		*@private
		*此对象包含的<code>List</code>实例的<code>Event.CHANGE</code>事件侦听处理函数。
		*/
		__proto.onListChange=function(e){
			this.event("change");
		}

		/**
		*@private
		*获取数据源集合。
		*/
		__proto.getArray=function(){
			var arr=[];
			var item;
			for(var $each_item in this._source){
				item=this._source[$each_item];
				if (this.getParentOpenStatus(item)){
					item.x=this._spaceLeft *this.getDepth(item);
					arr.push(item);
				}
			}
			return arr;
		}

		/**
		*@private
		*获取项对象的深度。
		*/
		__proto.getDepth=function(item,num){
			(num===void 0)&& (num=0);
			if (item.nodeParent==null)return num;
			else return this.getDepth(item.nodeParent,num+1);
		}

		/**
		*@private
		*获取项对象的上一级的打开状态。
		*/
		__proto.getParentOpenStatus=function(item){
			var parent=item.nodeParent;
			if (parent==null){
				return true;
				}else {
				if (parent.isOpen){
					if (parent.nodeParent !=null)return this.getParentOpenStatus(parent);
					else return true;
					}else {
					return false;
				}
			}
		}

		/**
		*@private
		*渲染一个项对象。
		*@param cell 一个项对象。
		*@param index 项的索引。
		*/
		__proto.renderItem=function(cell,index){
			var item=cell.dataSource;
			if (item){
				cell.left=item.x;
				var arrow=cell.getChildByName("arrow");
				if (arrow){
					if (item.hasChild){
						arrow.visible=true;
						arrow.index=item.isOpen ? 1 :0;
						arrow.tag=index;
						arrow.off("click",this,this.onArrowClick);
						arrow.on("click",this,this.onArrowClick);
						}else {
						arrow.visible=false;
					}
				};
				var folder=cell.getChildByName("folder");
				if (folder){
					if (folder.clipY==2){
						folder.index=item.isDirectory ? 0 :1;
						}else {
						folder.index=item.isDirectory ? item.isOpen ? 1 :0 :2;
					}
				}
				this._renderHandler && this._renderHandler.runWith([cell,index]);
			}
		}

		/**
		*@private
		*/
		__proto.onArrowClick=function(e){
			var arrow=e.currentTarget;
			var index=arrow.tag;
			this._list.array[index].isOpen=!this._list.array[index].isOpen;
			this._list.array=this.getArray();
		}

		/**
		*设置指定项索引的项对象的打开状态。
		*@param index 项索引。
		*@param isOpen 是否处于打开状态。
		*/
		__proto.setItemState=function(index,isOpen){
			if (!this._list.array[index])return;
			this._list.array[index].isOpen=isOpen;
			this._list.array=this.getArray();
		}

		/**
		*刷新项列表。
		*/
		__proto.fresh=function(){
			this._list.array=this.getArray();
			this.repaint();
		}

		/**
		*@private
		*解析并处理XML类型的数据源。
		*/
		__proto.parseXml=function(xml,source,nodeParent,isRoot){
			var obj;
			var list=xml.childNodes;
			var childCount=list.length;
			if (!isRoot){
				obj={};
				var list2=xml.attributes;
				var attrs;
				for(var $each_attrs in list2){
					attrs=list2[$each_attrs];
					var prop=attrs.nodeName;
					var value=attrs.nodeValue;
					obj[prop]=value=="true" ? true :value=="false" ? false :value;
				}
				obj.nodeParent=nodeParent;
				if (childCount > 0)obj.isDirectory=true;
				obj.hasChild=childCount > 0;
				source.push(obj);
			}
			for (var i=0;i < childCount;i++){
				var node=list[i];
				this.parseXml(node,source,obj,false);
			}
		}

		/**
		*@private
		*处理数据项的打开状态。
		*/
		__proto.parseOpenStatus=function(oldSource,newSource){
			for (var i=0,n=newSource.length;i < n;i++){
				var newItem=newSource[i];
				if (newItem.isDirectory){
					for (var j=0,m=oldSource.length;j < m;j++){
						var oldItem=oldSource[j];
						if (oldItem.isDirectory && this.isSameParent(oldItem,newItem)&& newItem.label==oldItem.label){
							newItem.isOpen=oldItem.isOpen;
							break ;
						}
					}
				}
			}
		}

		/**
		*@private
		*判断两个项对象在树结构中的父节点是否相同。
		*@param item1 项对象。
		*@param item2 项对象。
		*@return 如果父节点相同值为true，否则值为false。
		*/
		__proto.isSameParent=function(item1,item2){
			if (item1.nodeParent==null && item2.nodeParent==null)return true;
			else if (item1.nodeParent==null || item2.nodeParent==null)return false
			else {
				if (item1.nodeParent.label==item2.nodeParent.label)return this.isSameParent(item1.nodeParent,item2.nodeParent);
				else return false;
			}
		}

		/**
		*更新项列表，显示指定键名的数据项。
		*@param key 键名。
		*/
		__proto.filter=function(key){
			if (Boolean(key)){
				var result=[];
				this.getFilterSource(this._source,result,key);
				this._list.array=result;
				}else {
				this._list.array=this.getArray();
			}
		}

		/**
		*@private
		*获取数据源中指定键名的值。
		*/
		__proto.getFilterSource=function(array,result,key){
			key=key.toLocaleLowerCase();
			var item;
			for(var $each_item in array){
				item=array[$each_item];
				if (!item.isDirectory && String(item.label).toLowerCase().indexOf(key)>-1){
					item.x=0;
					result.push(item);
				}
				if (item.child && item.child.length > 0){
					this.getFilterSource(item.child,result,key);
				}
			}
		}

		/**
		*数据源发生变化后，是否保持之前打开状态，默认为true。
		*<p><b>取值：</b>
		*<li>true：保持之前打开状态。</li>
		*<li>false：不保持之前打开状态。</li>
		*</p>
		*/
		__getset(0,__proto,'keepStatus',function(){
			return this._keepStatus;
			},function(value){
			this._keepStatus=value;
		});

		/**
		*此对象包含的<code>List</code>实例对象。
		*/
		__getset(0,__proto,'list',function(){
			return this._list;
		});

		/**
		*滚动条皮肤。
		*/
		__getset(0,__proto,'scrollBarSkin',function(){
			return this._list.vScrollBarSkin;
			},function(value){
			this._list.vScrollBarSkin=value;
		});

		/**
		*列表数据源，只包含当前可视节点数据。
		*/
		__getset(0,__proto,'array',function(){
			return this._list.array;
			},function(value){
			if (this._keepStatus && this._list.array && value){
				this.parseOpenStatus(this._list.array,value);
			}
			this._source=value;
			this._list.array=this.getArray();
		});

		/**
		*当前选中的项对象的数据源。
		*/
		__getset(0,__proto,'selectedItem',function(){
			return this._list.selectedItem;
			},function(value){
			this._list.selectedItem=value;
		});

		/**
		*数据源，全部节点数据。
		*/
		__getset(0,__proto,'source',function(){
			return this._source;
		});

		/**
		*此对象包含的<code>List</code>实例的单元格渲染器。
		*<p><b>取值：</b>
		*<ol>
		*<li>单元格类对象。</li>
		*<li> UI 的 JSON 描述。</li>
		*</ol></p>
		*/
		__getset(0,__proto,'itemRender',function(){
			return this._list.itemRender;
			},function(value){
			this._list.itemRender=value;
		});

		/**滚动条*/
		__getset(0,__proto,'scrollBar',function(){
			return this._list.scrollBar;
		});

		/**
		*单元格鼠标事件处理器。
		*<p>默认返回参数（e:Event,index:int）。</p>
		*/
		__getset(0,__proto,'mouseHandler',function(){
			return this._list.mouseHandler;
			},function(value){
			this._list.mouseHandler=value;
		});

		/**
		*<code>Tree</code> 实例的渲染处理器。
		*/
		__getset(0,__proto,'renderHandler',function(){
			return this._renderHandler;
			},function(value){
			this._renderHandler=value;
		});

		/**
		*左侧缩进距离（以像素为单位）。
		*/
		__getset(0,__proto,'spaceLeft',function(){
			return this._spaceLeft;
			},function(value){
			this._spaceLeft=value;
		});

		/**
		*每一项之间的间隔距离（以像素为单位）。
		*/
		__getset(0,__proto,'spaceBottom',function(){
			return this._list.spaceY;
			},function(value){
			this._list.spaceY=value;
		});

		/**
		*表示当前选择的项索引。
		*/
		__getset(0,__proto,'selectedIndex',function(){
			return this._list.selectedIndex;
			},function(value){
			this._list.selectedIndex=value;
		});

		/**
		*@inheritDoc
		*/
		__getset(0,__proto,'width',_super.prototype._$get_width,function(value){
			_super.prototype._$set_width.call(this,value);
			this._list.width=value;
		});

		/**@inheritDoc */
		__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
			_super.prototype._$set_height.call(this,value);
			this._list.height=value;
		});

		/**@inheritDoc */
		__getset(0,__proto,'dataSource',_super.prototype._$get_dataSource,function(value){
			this._dataSource=value;
			if (Laya.__typeof(value,laya.ui.XmlDom))this.xml=value;
			else _super.prototype._$set_dataSource.call(this,value);
		});

		/**
		*xml结构的数据源。
		*/
		__getset(0,__proto,'xml',null,function(value){
			var arr=[];
			this.parseXml(value.childNodes[0],arr,null,true);
			this.array=arr;
		});

		/**
		*表示选择的树节点项的<code>path</code>属性值。
		*/
		__getset(0,__proto,'selectedPath',function(){
			if (this._list.selectedItem){
				return this._list.selectedItem.path;
			}
			return null;
		});

		return Tree;
	})(Box)


	/**
	*<code>ViewStack</code> 类用于视图堆栈类，用于视图的显示等设置处理。
	*/
	//class laya.ui.ViewStack extends laya.ui.Box
	var ViewStack=(function(_super){
		function ViewStack(){
			this._items=null;
			this._selectedIndex=0;
			ViewStack.__super.call(this);
			this._setIndexHandler=Handler.create(this,this.setIndex,null,false);
		}

		__class(ViewStack,'laya.ui.ViewStack',_super);
		var __proto=ViewStack.prototype;
		Laya.imps(__proto,{"laya.ui.IItem":true})
		/**
		*批量设置视图对象。
		*@param views 视图对象数组。
		*/
		__proto.setItems=function(views){
			this.removeChildren();
			var index=0;
			for (var i=0,n=views.length;i < n;i++){
				var item=views[i];
				if (item){
					item.name="item"+index;
					this.addChild(item);
					index++;
				}
			}
			this.initItems();
		}

		/**
		*添加视图。
		*@internal 添加视图对象，并设置此视图对象的<code>name</code> 属性。
		*@param view 需要添加的视图对象。
		*/
		__proto.addItem=function(view){
			view.name="item"+this._items.length;
			this.addChild(view);
			this.initItems();
		}

		/**
		*初始化视图对象集合。
		*/
		__proto.initItems=function(){
			this._items=[];
			for (var i=0;i < 10000;i++){
				var item=this.getChildByName("item"+i);
				if (item==null){
					break ;
				}
				this._items.push(item);
				item.visible=(i==this._selectedIndex);
			}
		}

		/**
		*@private
		*通过对象的索引设置项对象的 <code>selected</code> 属性值。
		*@param index 需要设置的对象的索引。
		*@param selected 表示对象的选中状态。
		*/
		__proto.setSelect=function(index,selected){
			if (this._items && index >-1 && index < this._items.length){
				this._items[index].visible=selected;
			}
		}

		/**
		*@private
		*设置属性<code>selectedIndex</code>的值。
		*@param index 选中项索引值。
		*/
		__proto.setIndex=function(index){
			this.selectedIndex=index;
		}

		/**
		*表示当前视图索引。
		*/
		__getset(0,__proto,'selectedIndex',function(){
			return this._selectedIndex;
			},function(value){
			if (this._selectedIndex !=value){
				this.setSelect(this._selectedIndex,false);
				this._selectedIndex=value;
				this.setSelect(this._selectedIndex,true);
			}
		});

		/**
		*获取或设置当前选择的项对象。
		*/
		__getset(0,__proto,'selection',function(){
			return this._selectedIndex >-1 && this._selectedIndex < this._items.length ? this._items[this._selectedIndex] :null;
			},function(value){
			this.selectedIndex=this._items.indexOf(value);
		});

		/**
		*索引设置处理器。
		*<p>默认回调参数：index:int</p>
		*/
		__getset(0,__proto,'setIndexHandler',function(){
			return this._setIndexHandler;
			},function(value){
			this._setIndexHandler=value;
		});

		/**
		*视图集合数组。
		*/
		__getset(0,__proto,'items',function(){
			return this._items;
		});

		/**@inheritDoc */
		__getset(0,__proto,'dataSource',_super.prototype._$get_dataSource,function(value){
			this._dataSource=value;
			if (((typeof value=='number')&& Math.floor(value)==value)|| (typeof value=='string')){
				this.selectedIndex=int(value);
				}else {
				for (var prop in this._dataSource){
					if (this.hasOwnProperty(prop)){
						this[prop]=this._dataSource[prop];
					}
				}
			}
		});

		return ViewStack;
	})(Box)


	/**
	*<code>CheckBox</code> 组件显示一个小方框，该方框内可以有选中标记。
	*<code>CheckBox</code> 组件还可以显示可选的文本标签，默认该标签位于 CheckBox 右侧。
	*<p><code>CheckBox</code> 使用 <code>dataSource</code>赋值时的的默认属性是：<code>selected</code>。</p>
	*
	*@example 以下示例代码，创建了一个 <code>CheckBox</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.CheckBox;
		*import laya.utils.Handler;
		*
		*public class CheckBox_Example
		*{
			*public function CheckBox_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load("resource/ui/check.png",Handler.create(this,onLoadComplete));//加载资源。
				*}
			*
			*private function onLoadComplete():void
			*{
				*trace("资源加载完成！");
				*var checkBox:CheckBox=new CheckBox("resource/ui/check.png","这个是一个CheckBox组件。");//创建一个 CheckBox 类的实例对象 checkBox ,传入它的皮肤skin和标签label。
				*checkBox.x=100;//设置 checkBox 对象的属性 x 的值，用于控制 checkBox 对象的显示位置。
				*checkBox.y=100;//设置 checkBox 对象的属性 y 的值，用于控制 checkBox 对象的显示位置。
				*checkBox.clickHandler=new Handler(this,onClick,[checkBox]);//设置 checkBox 的点击事件处理器。
				*Laya.stage.addChild(checkBox);//将此 checkBox 对象添加到显示列表。
				*}
			*
			*private function onClick(checkBox:CheckBox):void
			*{
				*trace("输出选中状态: checkBox.selected = "+checkBox.selected);
				*}
			*}
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*Laya.loader.load("resource/ui/check.png",laya.utils.Handler.create(this,loadComplete));//加载资源
	*function loadComplete()
	*{
		*console.log("资源加载完成！");
		*var checkBox=new laya.ui.CheckBox("resource/ui/check.png","这个是一个CheckBox组件。");//创建一个 CheckBox 类的类的实例对象 checkBox ,传入它的皮肤skin和标签label。
		*checkBox.x=100;//设置 checkBox 对象的属性 x 的值，用于控制 checkBox 对象的显示位置。
		*checkBox.y=100;//设置 checkBox 对象的属性 y 的值，用于控制 checkBox 对象的显示位置。
		*checkBox.clickHandler=new laya.utils.Handler(this,onClick,[checkBox],false);//设置 checkBox 的点击事件处理器。
		*Laya.stage.addChild(checkBox);//将此 checkBox 对象添加到显示列表。
		*}
	*function onClick(checkBox)
	*{
		*console.log("checkBox.selected = ",checkBox.selected);
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*Laya.loader.load("resource/ui/check.png",laya.utils.Handler.create(this,loadComplete));//加载资源
	*function loadComplete()
	*{
		*console.log("资源加载完成！");
		*var checkBox:laya.ui.CheckBox=new laya.ui.CheckBox("resource/ui/check.png","这个是一个CheckBox组件。");//创建一个 CheckBox 类的类的实例对象 checkBox ,传入它的皮肤skin和标签label。
		*checkBox.x=100;//设置 checkBox 对象的属性 x 的值，用于控制 checkBox 对象的显示位置。
		*checkBox.y=100;//设置 checkBox 对象的属性 y 的值，用于控制 checkBox 对象的显示位置。
		*checkBox.clickHandler=new laya.utils.Handler(this,this.onClick,[checkBox],false);//设置 checkBox 的点击事件处理器。
		*Laya.stage.addChild(checkBox);//将此 checkBox 对象添加到显示列表。
		*}
	*function onClick(checkBox)
	*{
		*console.log("checkBox.selected = ",checkBox.selected);
		*}
	*</listing>
	*<listing version="3.0">
	*import CheckBox=laya.ui.CheckBox;
	*import Handler=laya.utils.Handler;
	*class CheckBox_Example{
		*constructor()
		*{
			*Laya.init(640,800);
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load("resource/ui/check.png",Handler.create(this,this.onLoadComplete));//加载资源。
			*}
		*private onLoadComplete()
		*{
			*var checkBox:CheckBox=new CheckBox("resource/ui/check.png","这个是一个CheckBox组件。");//创建一个 CheckBox 类的实例对象 checkBox ,传入它的皮肤skin和标签label。
			*checkBox.x=100;//设置 checkBox 对象的属性 x 的值，用于控制 checkBox 对象的显示位置。
			*checkBox.y=100;//设置 checkBox 对象的属性 y 的值，用于控制 checkBox 对象的显示位置。
			*checkBox.clickHandler=new Handler(this,this.onClick,[checkBox]);//设置 checkBox 的点击事件处理器。
			*Laya.stage.addChild(checkBox);//将此 checkBox 对象添加到显示列表。
			*}
		*private onClick(checkBox:CheckBox):void
		*{
			*console.log("输出选中状态: checkBox.selected = "+checkBox.selected);
			*}
		*}
	*</listing>
	*/
	//class laya.ui.CheckBox extends laya.ui.Button
	var CheckBox=(function(_super){
		/**
		*创建一个新的 <code>CheckBox</code> 组件实例。
		*@param skin 皮肤资源地址。
		*@param label 文本标签的内容。
		*/
		function CheckBox(skin,label){
			(label===void 0)&& (label="");
			CheckBox.__super.call(this,skin,label);
		}

		__class(CheckBox,'laya.ui.CheckBox',_super);
		var __proto=CheckBox.prototype;
		/**@inheritDoc */
		__proto.preinitialize=function(){
			laya.ui.Component.prototype.preinitialize.call(this);
			this.toggle=true;
			this._autoSize=false;
		}

		/**@inheritDoc */
		__proto.initialize=function(){
			_super.prototype.initialize.call(this);
			this._text.align="left";
			this._text.valign="top";
			this._text.width=0;
		}

		/**@inheritDoc */
		__getset(0,__proto,'dataSource',_super.prototype._$get_dataSource,function(value){
			this._dataSource=value;
			if ((typeof value=='boolean'))this.selected=value;
			else if ((typeof value=='string'))this.selected=value==="true";
			else _super.prototype._$set_dataSource.call(this,value);
		});

		return CheckBox;
	})(Button)


	/**
	*使用 <code>HScrollBar</code> （水平 <code>ScrollBar</code> ）控件，可以在因数据太多而不能在显示区域完全显示时控制显示的数据部分。
	*@example 以下示例代码，创建了一个 <code>HScrollBar</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.HScrollBar;
		*import laya.utils.Handler;
		*
		*public class HScrollBar_Example
		*{
			*private var hScrollBar:HScrollBar;
			*public function HScrollBar_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/hscroll.png","resource/ui/hscroll$bar.png","resource/ui/hscroll$down.png","resource/ui/hscroll$up.png"],Handler.create(this,onLoadComplete));//加载资源。
				*}
			*
			*private function onLoadComplete():void
			*{
				*hScrollBar=new HScrollBar();//创建一个 HScrollBar 类的实例对象 hScrollBar 。
				*hScrollBar.skin="resource/ui/hscroll.png";//设置 hScrollBar 的皮肤。
				*hScrollBar.x=100;//设置 hScrollBar 对象的属性 x 的值，用于控制 hScrollBar 对象的显示位置。
				*hScrollBar.y=100;//设置 hScrollBar 对象的属性 y 的值，用于控制 hScrollBar 对象的显示位置。
				*hScrollBar.changeHandler=new Handler(this,onChange);//设置 hScrollBar 的滚动变化处理器。
				*Laya.stage.addChild(hScrollBar);//将此 hScrollBar 对象添加到显示列表。
				*}
			*
			*private function onChange(value:Number):void
			*{
				*trace("滚动条的位置： value="+value);
				*}
			*
			*}
		*
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*var hScrollBar;
	*var res=["resource/ui/hscroll.png","resource/ui/hscroll$bar.png","resource/ui/hscroll$down.png","resource/ui/hscroll$up.png"];
	*Laya.loader.load(res,laya.utils.Handler.create(this,onLoadComplete));//加载资源。
	*
	*function onLoadComplete(){
		*console.log("资源加载完成！");
		*hScrollBar=new laya.ui.HScrollBar();//创建一个 HScrollBar 类的实例对象 hScrollBar 。
		*hScrollBar.skin="resource/ui/hscroll.png";//设置 hScrollBar 的皮肤。
		*hScrollBar.x=100;//设置 hScrollBar 对象的属性 x 的值，用于控制 hScrollBar 对象的显示位置。
		*hScrollBar.y=100;//设置 hScrollBar 对象的属性 y 的值，用于控制 hScrollBar 对象的显示位置。
		*hScrollBar.changeHandler=new laya.utils.Handler(this,onChange);//设置 hScrollBar 的滚动变化处理器。
		*Laya.stage.addChild(hScrollBar);//将此 hScrollBar 对象添加到显示列表。
		*}
	*
	*function onChange(value)
	*{
		*console.log("滚动条的位置： value="+value);
		*}
	*</listing>
	*<listing version="3.0">
	*import HScrollBar=laya.ui.HScrollBar;
	*import Handler=laya.utils.Handler;
	*class HScrollBar_Example {
		*private hScrollBar:HScrollBar;
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load(["resource/ui/hscroll.png","resource/ui/hscroll$bar.png","resource/ui/hscroll$down.png","resource/ui/hscroll$up.png"],Handler.create(this,this.onLoadComplete));//加载资源。
			*}
		*private onLoadComplete():void {
			*this.hScrollBar=new HScrollBar();//创建一个 HScrollBar 类的实例对象 hScrollBar 。
			*this.hScrollBar.skin="resource/ui/hscroll.png";//设置 hScrollBar 的皮肤。
			*this.hScrollBar.x=100;//设置 hScrollBar 对象的属性 x 的值，用于控制 hScrollBar 对象的显示位置。
			*this.hScrollBar.y=100;//设置 hScrollBar 对象的属性 y 的值，用于控制 hScrollBar 对象的显示位置。
			*this.hScrollBar.changeHandler=new Handler(this,this.onChange);//设置 hScrollBar 的滚动变化处理器。
			*Laya.stage.addChild(this.hScrollBar);//将此 hScrollBar 对象添加到显示列表。
			*}
		*private onChange(value:number):void {
			*console.log("滚动条的位置： value="+value);
			*}
		*}
	*</listing>
	*/
	//class laya.ui.HScrollBar extends laya.ui.ScrollBar
	var HScrollBar=(function(_super){
		function HScrollBar(){HScrollBar.__super.call(this);;
		};

		__class(HScrollBar,'laya.ui.HScrollBar',_super);
		var __proto=HScrollBar.prototype;
		/**@inheritDoc */
		__proto.initialize=function(){
			_super.prototype.initialize.call(this);
			this._slider.isVertical=false;
		}

		return HScrollBar;
	})(ScrollBar)


	/**
	*<code>Radio</code> 控件使用户可在一组互相排斥的选择中做出一种选择。
	*用户一次只能选择 <code>Radio</code> 组中的一个成员。选择未选中的组成员将取消选择该组中当前所选的 <code>Radio</code> 控件。
	*@see laya.ui.RadioGroup
	*/
	//class laya.ui.Radio extends laya.ui.Button
	var Radio=(function(_super){
		function Radio(skin,label){
			this._value=null;
			(label===void 0)&& (label="");
			Radio.__super.call(this,skin,label);
		}

		__class(Radio,'laya.ui.Radio',_super);
		var __proto=Radio.prototype;
		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			this._value=null;
		}

		/**@inheritDoc */
		__proto.preinitialize=function(){
			laya.ui.Component.prototype.preinitialize.call(this);
			this.toggle=false;
			this._autoSize=false;
		}

		/**@inheritDoc */
		__proto.initialize=function(){
			_super.prototype.initialize.call(this);
			this._text.align="left";
			this._text.valign="top";
			this._text.width=0;
			this.on("click",this,this.onClick);
		}

		/**
		*@private
		*对象的<code>Event.CLICK</code>事件侦听处理函数。
		*/
		__proto.onClick=function(e){
			this.selected=true;
		}

		/**
		*获取或设置 <code>Radio</code> 关联的可选用户定义值。
		*/
		__getset(0,__proto,'value',function(){
			return this._value !=null ? this._value :this.label;
			},function(obj){
			this._value=obj;
		});

		return Radio;
	})(Button)


	/**
	*使用 <code>HSlider</code> 控件，用户可以通过在滑块轨道的终点之间移动滑块来选择值。
	*<p> <code>HSlider</code> 控件采用水平方向。滑块轨道从左向右扩展，而标签位于轨道的顶部或底部。</p>
	*
	*@example 以下示例代码，创建了一个 <code>HSlider</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.HSlider;
		*import laya.utils.Handler;
		*
		*public class HSlider_Example
		*{
			*private var hSlider:HSlider;
			*
			*public function HSlider_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/hslider.png","resource/ui/hslider$bar.png"],Handler.create(this,onLoadComplete));//加载资源。
				*}
			*
			*private function onLoadComplete():void
			*{
				*hSlider=new HSlider();//创建一个 HSlider 类的实例对象 hSlider 。
				*hSlider.skin="resource/ui/hslider.png";//设置 hSlider 的皮肤。
				*hSlider.min=0;//设置 hSlider 最低位置值。
				*hSlider.max=10;//设置 hSlider 最高位置值。
				*hSlider.value=2;//设置 hSlider 当前位置值。
				*hSlider.tick=1;//设置 hSlider 刻度值。
				*hSlider.x=100;//设置 hSlider 对象的属性 x 的值，用于控制 hSlider 对象的显示位置。
				*hSlider.y=100;//设置 hSlider 对象的属性 y 的值，用于控制 hSlider 对象的显示位置。
				*hSlider.changeHandler=new Handler(this,onChange);//设置 hSlider 位置变化处理器。
				*Laya.stage.addChild(hSlider);//把 hSlider 添加到显示列表。
				*}
			*
			*private function onChange(value:Number):void
			*{
				*trace("滑块的位置： value="+value);
				*}
			*
			*}
		*
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800,"canvas");//设置游戏画布宽高、渲染模式
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*var hSlider;
	*var res=["resource/ui/hslider.png","resource/ui/hslider$bar.png"];
	*Laya.loader.load(res,laya.utils.Handler.create(this,onLoadComplete));
	*function onLoadComplete(){
		*console.log("资源加载完成！");
		*hSlider=new laya.ui.HSlider();//创建一个 HSlider 类的实例对象 hSlider 。
		*hSlider.skin="resource/ui/hslider.png";//设置 hSlider 的皮肤。
		*hSlider.min=0;//设置 hSlider 最低位置值。
		*hSlider.max=10;//设置 hSlider 最高位置值。
		*hSlider.value=2;//设置 hSlider 当前位置值。
		*hSlider.tick=1;//设置 hSlider 刻度值。
		*hSlider.x=100;//设置 hSlider 对象的属性 x 的值，用于控制 hSlider 对象的显示位置。
		*hSlider.y=100;//设置 hSlider 对象的属性 y 的值，用于控制 hSlider 对象的显示位置。
		*hSlider.changeHandler=new laya.utils.Handler(this,onChange);//设置 hSlider 位置变化处理器。
		*Laya.stage.addChild(hSlider);//把 hSlider 添加到显示列表。
		*}
	*
	*function onChange(value)
	*{
		*console.log("滑块的位置： value="+value);
		*}
	*</listing>
	*<listing version="3.0">
	*import Handler=laya.utils.Handler;
	*import HSlider=laya.ui.HSlider;
	*class HSlider_Example {
		*private hSlider:HSlider;
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load(["resource/ui/hslider.png","resource/ui/hslider$bar.png"],Handler.create(this,this.onLoadComplete));//加载资源。
			*}
		*private onLoadComplete():void {
			*this.hSlider=new HSlider();//创建一个 HSlider 类的实例对象 hSlider 。
			*this.hSlider.skin="resource/ui/hslider.png";//设置 hSlider 的皮肤。
			*this.hSlider.min=0;//设置 hSlider 最低位置值。
			*this.hSlider.max=10;//设置 hSlider 最高位置值。
			*this.hSlider.value=2;//设置 hSlider 当前位置值。
			*this.hSlider.tick=1;//设置 hSlider 刻度值。
			*this.hSlider.x=100;//设置 hSlider 对象的属性 x 的值，用于控制 hSlider 对象的显示位置。
			*this.hSlider.y=100;//设置 hSlider 对象的属性 y 的值，用于控制 hSlider 对象的显示位置。
			*this.hSlider.changeHandler=new Handler(this,this.onChange);//设置 hSlider 位置变化处理器。
			*Laya.stage.addChild(this.hSlider);//把 hSlider 添加到显示列表。
			*}
		*
		*private onChange(value:number):void {
			*console.log("滑块的位置： value="+value);
			*}
		*
		*}
	*</listing>
	*
	*@see laya.ui.Slider
	*/
	//class laya.ui.HSlider extends laya.ui.Slider
	var HSlider=(function(_super){
		/**
		*创建一个 <code>HSlider</code> 类实例。
		*@param skin 皮肤。
		*/
		function HSlider(skin){
			HSlider.__super.call(this,skin);
			this.isVertical=false;
		}

		__class(HSlider,'laya.ui.HSlider',_super);
		return HSlider;
	})(Slider)


	/**
	*
	*使用 <code>VScrollBar</code> （垂直 <code>ScrollBar</code> ）控件，可以在因数据太多而不能在显示区域完全显示时控制显示的数据部分。
	*
	*@example 以下示例代码，创建了一个 <code>VScrollBar</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.vScrollBar;
		*import laya.ui.VScrollBar;
		*import laya.utils.Handler;
		*
		*public class VScrollBar_Example
		*{
			*private var vScrollBar:VScrollBar;
			*public function VScrollBar_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/vscroll.png","resource/ui/vscroll$bar.png","resource/ui/vscroll$down.png","resource/ui/vscroll$up.png"],Handler.create(this,onLoadComplete));
				*}
			*
			*private function onLoadComplete():void
			*{
				*vScrollBar=new VScrollBar();//创建一个 vScrollBar 类的实例对象 hScrollBar 。
				*vScrollBar.skin="resource/ui/vscroll.png";//设置 vScrollBar 的皮肤。
				*vScrollBar.x=100;//设置 vScrollBar 对象的属性 x 的值，用于控制 vScrollBar 对象的显示位置。
				*vScrollBar.y=100;//设置 vScrollBar 对象的属性 y 的值，用于控制 vScrollBar 对象的显示位置。
				*vScrollBar.changeHandler=new Handler(this,onChange);//设置 vScrollBar 的滚动变化处理器。
				*Laya.stage.addChild(vScrollBar);//将此 vScrollBar 对象添加到显示列表。
				*}
			*
			*private function onChange(value:Number):void
			*{
				*trace("滚动条的位置： value="+value);
				*}
			*
			*}
		*
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*var vScrollBar;
	*var res=["resource/ui/vscroll.png","resource/ui/vscroll$bar.png","resource/ui/vscroll$down.png","resource/ui/vscroll$up.png"];
	*Laya.loader.load(res,laya.utils.Handler.create(this,onLoadComplete));//加载资源。
	*function onLoadComplete(){
		*vScrollBar=new laya.ui.VScrollBar();//创建一个 vScrollBar 类的实例对象 hScrollBar 。
		*vScrollBar.skin="resource/ui/vscroll.png";//设置 vScrollBar 的皮肤。
		*vScrollBar.x=100;//设置 vScrollBar 对象的属性 x 的值，用于控制 vScrollBar 对象的显示位置。
		*vScrollBar.y=100;//设置 vScrollBar 对象的属性 y 的值，用于控制 vScrollBar 对象的显示位置。
		*vScrollBar.changeHandler=new laya.utils.Handler(this,onChange);//设置 vScrollBar 的滚动变化处理器。
		*Laya.stage.addChild(vScrollBar);//将此 vScrollBar 对象添加到显示列表。
		*}
	*function onChange(value){
		*console.log("滚动条的位置： value="+value);
		*}
	*</listing>
	*<listing version="3.0">
	*import VScrollBar=laya.ui.VScrollBar;
	*import Handler=laya.utils.Handler;
	*class VScrollBar_Example {
		*private vScrollBar:VScrollBar;
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load(["resource/ui/vscroll.png","resource/ui/vscroll$bar.png","resource/ui/vscroll$down.png","resource/ui/vscroll$up.png"],Handler.create(this,this.onLoadComplete));
			*}
		*
		*private onLoadComplete():void {
			*this.vScrollBar=new VScrollBar();//创建一个 vScrollBar 类的实例对象 hScrollBar 。
			*this.vScrollBar.skin="resource/ui/vscroll.png";//设置 vScrollBar 的皮肤。
			*this.vScrollBar.x=100;//设置 vScrollBar 对象的属性 x 的值，用于控制 vScrollBar 对象的显示位置。
			*this.vScrollBar.y=100;//设置 vScrollBar 对象的属性 y 的值，用于控制 vScrollBar 对象的显示位置。
			*this.vScrollBar.changeHandler=new Handler(this,this.onChange);//设置 vScrollBar 的滚动变化处理器。
			*Laya.stage.addChild(this.vScrollBar);//将此 vScrollBar 对象添加到显示列表。
			*}
		*
		*private onChange(value:number):void {
			*console.log("滚动条的位置： value="+value);
			*}
		*
		*}
	*</listing>
	*/
	//class laya.ui.VScrollBar extends laya.ui.ScrollBar
	var VScrollBar=(function(_super){
		function VScrollBar(){VScrollBar.__super.call(this);;
		};

		__class(VScrollBar,'laya.ui.VScrollBar',_super);
		return VScrollBar;
	})(ScrollBar)


	/**
	*使用 <code>VSlider</code> 控件，用户可以通过在滑块轨道的终点之间移动滑块来选择值。
	*<p> <code>VSlider</code> 控件采用垂直方向。滑块轨道从下往上扩展，而标签位于轨道的左右两侧。</p>
	*
	*@example 以下示例代码，创建了一个 <code>VSlider</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.HSlider;
		*import laya.ui.VSlider;
		*import laya.utils.Handler;
		*
		*public class VSlider_Example
		*{
			*private var vSlider:VSlider;
			*
			*public function VSlider_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/vslider.png","resource/ui/vslider$bar.png"],Handler.create(this,onLoadComplete));//加载资源。
				*}
			*
			*private function onLoadComplete():void
			*{
				*vSlider=new VSlider();//创建一个 VSlider 类的实例对象 vSlider 。
				*vSlider.skin="resource/ui/vslider.png";//设置 vSlider 的皮肤。
				*vSlider.min=0;//设置 vSlider 最低位置值。
				*vSlider.max=10;//设置 vSlider 最高位置值。
				*vSlider.value=2;//设置 vSlider 当前位置值。
				*vSlider.tick=1;//设置 vSlider 刻度值。
				*vSlider.x=100;//设置 vSlider 对象的属性 x 的值，用于控制 vSlider 对象的显示位置。
				*vSlider.y=100;//设置 vSlider 对象的属性 y 的值，用于控制 vSlider 对象的显示位置。
				*vSlider.changeHandler=new Handler(this,onChange);//设置 vSlider 位置变化处理器。
				*Laya.stage.addChild(vSlider);//把 vSlider 添加到显示列表。
				*}
			*
			*private function onChange(value:Number):void
			*{
				*trace("滑块的位置： value="+value);
				*}
			*
			*}
		*
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*var vSlider;
	*Laya.loader.load(["resource/ui/vslider.png","resource/ui/vslider$bar.png"],laya.utils.Handler.create(this,onLoadComplete));//加载资源。
	*function onLoadComplete(){
		*vSlider=new laya.ui.VSlider();//创建一个 VSlider 类的实例对象 vSlider 。
		*vSlider.skin="resource/ui/vslider.png";//设置 vSlider 的皮肤。
		*vSlider.min=0;//设置 vSlider 最低位置值。
		*vSlider.max=10;//设置 vSlider 最高位置值。
		*vSlider.value=2;//设置 vSlider 当前位置值。
		*vSlider.tick=1;//设置 vSlider 刻度值。
		*vSlider.x=100;//设置 vSlider 对象的属性 x 的值，用于控制 vSlider 对象的显示位置。
		*vSlider.y=100;//设置 vSlider 对象的属性 y 的值，用于控制 vSlider 对象的显示位置。
		*vSlider.changeHandler=new laya.utils.Handler(this,onChange);//设置 vSlider 位置变化处理器。
		*Laya.stage.addChild(vSlider);//把 vSlider 添加到显示列表。
		*}
	*function onChange(value){
		*console.log("滑块的位置： value="+value);
		*}
	*</listing>
	*<listing version="3.0">
	*import HSlider=laya.ui.HSlider;
	*import VSlider=laya.ui.VSlider;
	*import Handler=laya.utils.Handler;
	*class VSlider_Example {
		*private vSlider:VSlider;
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load(["resource/ui/vslider.png","resource/ui/vslider$bar.png"],Handler.create(this,this.onLoadComplete));//加载资源。
			*}
		*
		*private onLoadComplete():void {
			*this.vSlider=new VSlider();//创建一个 VSlider 类的实例对象 vSlider 。
			*this.vSlider.skin="resource/ui/vslider.png";//设置 vSlider 的皮肤。
			*this.vSlider.min=0;//设置 vSlider 最低位置值。
			*this.vSlider.max=10;//设置 vSlider 最高位置值。
			*this.vSlider.value=2;//设置 vSlider 当前位置值。
			*this.vSlider.tick=1;//设置 vSlider 刻度值。
			*this.vSlider.x=100;//设置 vSlider 对象的属性 x 的值，用于控制 vSlider 对象的显示位置。
			*this.vSlider.y=100;//设置 vSlider 对象的属性 y 的值，用于控制 vSlider 对象的显示位置。
			*this.vSlider.changeHandler=new Handler(this,this.onChange);//设置 vSlider 位置变化处理器。
			*Laya.stage.addChild(this.vSlider);//把 vSlider 添加到显示列表。
			*}
		*
		*private onChange(value:number):void {
			*console.log("滑块的位置： value="+value);
			*}
		*
		*}
	*</listing>
	*@see laya.ui.Slider
	*/
	//class laya.ui.VSlider extends laya.ui.Slider
	var VSlider=(function(_super){
		function VSlider(){VSlider.__super.call(this);;
		};

		__class(VSlider,'laya.ui.VSlider',_super);
		return VSlider;
	})(Slider)


	/**
	*<code>TextInput</code> 类用于创建显示对象以显示和输入文本。
	*
	*@example 以下示例代码，创建了一个 <code>TextInput</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.display.Stage;
		*import laya.ui.TextInput;
		*import laya.utils.Handler;
		*
		*public class TextInput_Example
		*{
			*public function TextInput_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/input.png"],Handler.create(this,onLoadComplete));//加载资源。
				*}
			*
			*private function onLoadComplete():void
			*{
				*var textInput:TextInput=new TextInput("这是一个TextInput实例。");//创建一个 TextInput 类的实例对象 textInput 。
				*textInput.skin="resource/ui/input.png";//设置 textInput 的皮肤。
				*textInput.sizeGrid="4,4,4,4";//设置 textInput 的网格信息。
				*textInput.color="#008fff";//设置 textInput 的文本颜色。
				*textInput.font="Arial";//设置 textInput 的文本字体。
				*textInput.bold=true;//设置 textInput 的文本显示为粗体。
				*textInput.fontSize=30;//设置 textInput 的字体大小。
				*textInput.wordWrap=true;//设置 textInput 的文本自动换行。
				*textInput.x=100;//设置 textInput 对象的属性 x 的值，用于控制 textInput 对象的显示位置。
				*textInput.y=100;//设置 textInput 对象的属性 y 的值，用于控制 textInput 对象的显示位置。
				*textInput.width=300;//设置 textInput 的宽度。
				*textInput.height=200;//设置 textInput 的高度。
				*Laya.stage.addChild(textInput);//将 textInput 添加到显示列表。
				*}
			*
			*}
		*
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*Laya.loader.load(["resource/ui/input.png"],laya.utils.Handler.create(this,onLoadComplete));//加载资源。
	*function onLoadComplete(){
		*var textInput=new laya.ui.TextInput("这是一个TextInput实例。");//创建一个 TextInput 类的实例对象 textInput 。
		*textInput.skin="resource/ui/input.png";//设置 textInput 的皮肤。
		*textInput.sizeGrid="4,4,4,4";//设置 textInput 的网格信息。
		*textInput.color="#008fff";//设置 textInput 的文本颜色。
		*textInput.font="Arial";//设置 textInput 的文本字体。
		*textInput.bold=true;//设置 textInput 的文本显示为粗体。
		*textInput.fontSize=30;//设置 textInput 的字体大小。
		*textInput.wordWrap=true;//设置 textInput 的文本自动换行。
		*textInput.x=100;//设置 textInput 对象的属性 x 的值，用于控制 textInput 对象的显示位置。
		*textInput.y=100;//设置 textInput 对象的属性 y 的值，用于控制 textInput 对象的显示位置。
		*textInput.width=300;//设置 textInput 的宽度。
		*textInput.height=200;//设置 textInput 的高度。
		*Laya.stage.addChild(textInput);//将 textInput 添加到显示列表。
		*}
	*</listing>
	*<listing version="3.0">
	*import Stage=laya.display.Stage;
	*import TextInput=laya.ui.TextInput;
	*import Handler=laya.utils.Handler;
	*class TextInput_Example {
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load(["resource/ui/input.png"],Handler.create(this,this.onLoadComplete));//加载资源。
			*}
		*private onLoadComplete():void {
			*var textInput:TextInput=new TextInput("这是一个TextInput实例。");//创建一个 TextInput 类的实例对象 textInput 。
			*textInput.skin="resource/ui/input.png";//设置 textInput 的皮肤。
			*textInput.sizeGrid="4,4,4,4";//设置 textInput 的网格信息。
			*textInput.color="#008fff";//设置 textInput 的文本颜色。
			*textInput.font="Arial";//设置 textInput 的文本字体。
			*textInput.bold=true;//设置 textInput 的文本显示为粗体。
			*textInput.fontSize=30;//设置 textInput 的字体大小。
			*textInput.wordWrap=true;//设置 textInput 的文本自动换行。
			*textInput.x=100;//设置 textInput 对象的属性 x 的值，用于控制 textInput 对象的显示位置。
			*textInput.y=100;//设置 textInput 对象的属性 y 的值，用于控制 textInput 对象的显示位置。
			*textInput.width=300;//设置 textInput 的宽度。
			*textInput.height=200;//设置 textInput 的高度。
			*Laya.stage.addChild(textInput);//将 textInput 添加到显示列表。
			*}
		*
		*}
	*</listing>
	*/
	//class laya.ui.TextInput extends laya.ui.Label
	var TextInput=(function(_super){
		function TextInput(text){
			this._bg=null;
			this._skin=null;
			TextInput.__super.call(this);
			(text===void 0)&& (text="");
			this.text=text;
			this.skin=this.skin;
		}

		__class(TextInput,'laya.ui.TextInput',_super);
		var __proto=TextInput.prototype;
		/**@inheritDoc */
		__proto.preinitialize=function(){
			this.mouseEnabled=true;
		}

		/**@inheritDoc */
		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			_super.prototype.destroy.call(this,destroyChild);
			this._bg && this._bg.destroy();
			this._bg=null;
		}

		/**@inheritDoc */
		__proto.createChildren=function(){
			this.addChild(this._tf=new Input());
			this._tf.padding=Styles.inputLabelPadding;
			this._tf.on("input",this,this.onInput);
			this._tf.on("enter",this,this.onEnter);
			this._tf.on("blur",this,this.onBlur);
			this._tf.on("focus",this,this.onFocus);
		}

		/**
		*@private
		*/
		__proto.onFocus=function(e){
			this.event("focus",this);
		}

		/**
		*@private
		*/
		__proto.onBlur=function(e){
			this.event("blur",this);
		}

		/**
		*@private
		*/
		__proto.onInput=function(e){
			this.event("input",this);
		}

		/**
		*@private
		*/
		__proto.onEnter=function(e){
			this.event("enter",this);
		}

		/**@inheritDoc */
		__proto.initialize=function(){
			this.width=128;
			this.height=22;
		}

		/**选中输入框内的文本。*/
		__proto.select=function(){
			(this._tf).select();
		}

		/**
		*表示此对象包含的文本背景 <code>AutoBitmap</code> 组件实例。
		*/
		__getset(0,__proto,'bg',function(){
			return this._bg;
			},function(value){
			this.graphics=this._bg=value;
		});

		/**
		*设置可编辑状态。
		*/
		__getset(0,__proto,'editable',function(){
			return (this._tf).editable;
			},function(value){
			(this._tf).editable=value;
		});

		/**
		*设置原生input输入框的y坐标偏移。
		*/
		__getset(0,__proto,'inputElementYAdjuster',function(){
			return (this._tf).inputElementYAdjuster;
			},function(value){
			(this._tf).inputElementYAdjuster=value;
		});

		/**@inheritDoc */
		__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
			_super.prototype._$set_height.call(this,value);
			this._bg && (this._bg.height=value);
		});

		/**
		*@copy laya.ui.Image#skin
		*/
		__getset(0,__proto,'skin',function(){
			return this._skin;
			},function(value){
			if (this._skin !=value){
				this._skin=value;
				this._bg || (this.graphics=this._bg=new AutoBitmap());
				this._bg.source=Loader.getRes(this._skin);
				this._width && (this._bg.width=this._width);
				this._height && (this._bg.height=this._height);
			}
		});

		/**
		*<p>当前实例的背景图（ <code>AutoBitmap</code> ）实例的有效缩放网格数据。</p>
		*<p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
		*<ul><li>例如："4,4,4,4,1"</li></ul></p>
		*@see laya.ui.AutoBitmap.sizeGrid
		*/
		__getset(0,__proto,'sizeGrid',function(){
			return this._bg && this._bg.sizeGrid ? this._bg.sizeGrid.join(","):null;
			},function(value){
			this._bg || (this.graphics=this._bg=new AutoBitmap());
			this._bg.sizeGrid=UIUtils.fillArray(Styles.defaultSizeGrid,value,Number);
		});

		/**
		*@copy laya.display.Input#title
		*/
		__getset(0,__proto,'title',function(){
			return (this._tf).title;
			},function(value){
			(this._tf).title=value;
		});

		/**@inheritDoc */
		__getset(0,__proto,'width',_super.prototype._$get_width,function(value){
			_super.prototype._$set_width.call(this,value);
			this._bg && (this._bg.width=value);
		});

		/**
		*设置原生input输入框的x坐标偏移。
		*/
		__getset(0,__proto,'inputElementXAdjuster',function(){
			return (this._tf).inputElementXAdjuster;
			},function(value){
			(this._tf).inputElementXAdjuster=value;
		});

		/**
		*<p>指示当前是否是文本域。</p>
		*值为true表示当前是文本域，否则不是文本域。
		*/
		__getset(0,__proto,'multiline',function(){
			return (this._tf).multiline;
			},function(value){
			(this._tf).multiline=value;
		});

		/**限制输入的字符。*/
		__getset(0,__proto,'restrict',function(){
			return (this._tf).restrict;
			},function(pattern){
			(this._tf).restrict=pattern;
		});

		/**
		*@copy laya.display.Input#clearOnFocus
		*/
		__getset(0,__proto,'clearOnFocus',function(){
			return (this._tf).clearOnFocus;
			},function(value){
			(this._tf).clearOnFocus=value;
		});

		/**
		*@copy laya.display.Input#maxChars
		*/
		__getset(0,__proto,'maxChars',function(){
			return (this._tf).maxChars;
			},function(value){
			(this._tf).maxChars=value;
		});

		return TextInput;
	})(Label)


	//class game.ui.test.TestPageUI extends laya.ui.View
	var TestPageUI=(function(_super){
		function TestPageUI(){
			this.btn=null;
			this.clip=null;
			this.combobox=null;
			this.tab=null;
			this.list=null;
			this.btn2=null;
			this.check=null;
			this.radio=null;
			this.box=null;
			TestPageUI.__super.call(this);
		}

		__class(TestPageUI,'game.ui.test.TestPageUI',_super);
		var __proto=TestPageUI.prototype;
		__proto.createChildren=function(){
			laya.ui.Component.prototype.createChildren.call(this);
			this.createView(TestPageUI.uiView);
		}

		__static(TestPageUI,
		['uiView',function(){return this.uiView={"type":"View","child":[{"props":{"x":0,"y":0,"skin":"comp/bg.png","sizeGrid":"30,4,4,4","width":600,"height":400},"type":"Image"},{"props":{"x":-39,"y":58,"skin":"comp/button.png","label":"点我赋值","width":150,"height":37,"sizeGrid":"4,4,4,4","var":"btn"},"type":"Button"},{"props":{"x":401,"y":56,"skin":"comp/clip_num.png","clipX":10,"var":"clip"},"type":"Clip"},{"props":{"x":220,"y":143,"skin":"comp/combobox.png","labels":"select1,select2,selecte3","selectedIndex":1,"sizeGrid":"4,20,4,4","width":200,"height":23,"var":"combobox"},"type":"ComboBox"},{"props":{"x":220,"y":96,"skin":"comp/tab.png","labels":"tab1,tab2,tab3","var":"tab"},"type":"Tab"},{"props":{"x":259,"y":223,"skin":"comp/vscroll.png","height":150},"type":"VScrollBar"},{"props":{"x":224,"y":223,"skin":"comp/vslider.png","height":150},"type":"VSlider"},{"type":"List","child":[{"type":"Box","child":[{"props":{"skin":"comp/label.png","text":"this is a list","x":26,"y":5,"width":78,"height":20,"fontSize":14,"name":"label"},"type":"Label"},{"props":{"x":0,"y":2,"skin":"comp/clip_num.png","clipX":10,"name":"clip"},"type":"Clip"}],"props":{"name":"render","x":0,"y":0,"width":112,"height":30}}],"props":{"x":452,"y":68,"width":128,"height":299,"vScrollBarSkin":"comp/vscroll.png","repeatX":1,"var":"list"}},{"props":{"x":563,"y":4,"skin":"comp/btn_close.png","name":"close"},"type":"Button"},{"props":{"x":-73,"y":115,"skin":"comp/button.png","label":"点我赋值","width":150,"height":66,"sizeGrid":"4,4,4,4","labelSize":30,"labelBold":true,"var":"btn2"},"type":"Button"},{"props":{"x":220,"y":188,"skin":"comp/checkbox.png","label":"checkBox1","var":"check"},"type":"CheckBox"},{"props":{"x":220,"y":61,"skin":"comp/radiogroup.png","labels":"radio1,radio2,radio3","label2'":"","var":"radio"},"type":"RadioGroup"},{"type":"Panel","child":[{"props":{"skin":"comp/image.png"},"type":"Image"}],"props":{"x":299,"y":223,"width":127,"height":150,"vScrollBarSkin":"comp/vscroll.png"}},{"props":{"x":326,"y":188,"skin":"comp/checkbox.png","label":"checkBox2","labelColors":"#ff0000"},"type":"CheckBox"},{"type":"Box","child":[{"props":{"y":70,"skin":"comp/progress.png","width":150,"height":14,"sizeGrid":"4,4,4,4","name":"progress"},"type":"ProgressBar"},{"props":{"y":103,"skin":"comp/label.png","text":"This is a Label","width":137,"height":26,"fontSize":20,"name":"label"},"type":"Label"},{"props":{"y":148,"skin":"comp/textinput.png","text":"textinput","width":150,"name":"input"},"type":"TextInput"},{"props":{"skin":"comp/hslider.png","width":150,"name":"slider"},"type":"HSlider"},{"props":{"y":34,"skin":"comp/hscroll.png","width":150,"name":"scroll"},"type":"HScrollBar"}],"props":{"x":41,"y":197,"var":"box"}}],"props":{"width":600,"height":400}};}
		]);
		return TestPageUI;
	})(View)


	/**
	*<code>VBox</code> 是一个垂直布局容器类。
	*/
	//class laya.ui.HBox extends laya.ui.LayoutBox
	var HBox=(function(_super){
		/**
		*创建一个新的 <code>HBox</code> 类实例。
		*/
		function HBox(){
			HBox.__super.call(this);
		}

		__class(HBox,'laya.ui.HBox',_super);
		var __proto=HBox.prototype;
		/**@inheritDoc */
		__proto.sortItem=function(items){
			if (items)items.sort(function(a,b){return a.x > b.x ? 1 :-1
			});
		}

		/**@inheritDoc */
		__proto.changeItems=function(){
			var items=[];
			var maxHeight=0;
			for (var i=0,n=this.numChildren;i < n;i++){
				var item=this.getChildAt(i);
				if (item){
					items.push(item);
					maxHeight=Math.max(maxHeight,item.displayHeight);
				}
			}
			this.sortItem(items);
			var left=0;
			var $each_item;
			for($each_item in items){
				item=items[$each_item];
				item.x=left;
				left+=item.displayWidth+this._space;
				if (this._align=="top"){
					item.y=0;
					}else if (this._align=="middle"){
					item.y=(maxHeight-item.displayHeight)*0.5;
					}else if (this._align=="bottom"){
					item.y=maxHeight-item.displayHeight;
				}
			}
			this.changeSize();
		}

		HBox.NONE="none";
		HBox.TOP="top";
		HBox.MIDDLE="middle";
		HBox.BOTTOM="bottom";
		return HBox;
	})(LayoutBox)


	/**
	*<code>RadioGroup</code> 控件定义一组 <code>Radio</code> 控件，这些控件相互排斥；
	*因此，用户每次只能选择一个 <code>Radio</code> 控件。
	*
	*@example 以下示例代码，创建了一个 <code>RadioGroup</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.Radio;
		*import laya.ui.RadioGroup;
		*import laya.utils.Handler;
		*
		*public class RadioGroup_Example
		*{
			*
			*public function RadioGroup_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/radio.png"],Handler.create(this,onLoadComplete));//加载资源。
				*}
			*
			*private function onLoadComplete():void
			*{
				*var radioGroup:RadioGroup=new RadioGroup();//创建一个 RadioGroup 类的实例对象 radioGroup 。
				*radioGroup.pos(100,100);//设置 radioGroup 的位置信息。
				*radioGroup.labels="item0,item1,item2";//设置 radioGroup 的标签集。
				*radioGroup.skin="resource/ui/radio.png";//设置 radioGroup 的皮肤。
				*radioGroup.space=10;//设置 radioGroup 的项间隔距离。
				*radioGroup.selectHandler=new Handler(this,onSelect);//设置 radioGroup 的选择项发生改变时执行的处理器。
				*Laya.stage.addChild(radioGroup);//将 radioGroup 添加到显示列表。
				*}
			*
			*private function onSelect(index:int):void
			*{
				*trace("当前选择的单选按钮索引: index= ",index);
				*}
			*
			*}
		*
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高、渲染模式
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*Laya.loader.load(["resource/ui/radio.png"],laya.utils.Handler.create(this,onLoadComplete));
	*function onLoadComplete(){
		*var radioGroup=new laya.ui.RadioGroup();//创建一个 RadioGroup 类的实例对象 radioGroup 。
		*radioGroup.pos(100,100);//设置 radioGroup 的位置信息。
		*radioGroup.labels="item0,item1,item2";//设置 radioGroup 的标签集。
		*radioGroup.skin="resource/ui/radio.png";//设置 radioGroup 的皮肤。
		*radioGroup.space=10;//设置 radioGroup 的项间隔距离。
		*radioGroup.selectHandler=new laya.utils.Handler(this,onSelect);//设置 radioGroup 的选择项发生改变时执行的处理器。
		*Laya.stage.addChild(radioGroup);//将 radioGroup 添加到显示列表。
		*}
	*function onSelect(index){
		*console.log("当前选择的单选按钮索引: index= ",index);
		*}
	*</listing>
	*<listing version="3.0">
	*import Radio=laya.ui.Radio;
	*import RadioGroup=laya.ui.RadioGroup;
	*import Handler=laya.utils.Handler;
	*class RadioGroup_Example {
		*
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load(["resource/ui/radio.png"],Handler.create(this,this.onLoadComplete));//加载资源。
			*}
		*
		*private onLoadComplete():void {
			*var radioGroup:RadioGroup=new RadioGroup();//创建一个 RadioGroup 类的实例对象 radioGroup 。
			*radioGroup.pos(100,100);//设置 radioGroup 的位置信息。
			*radioGroup.labels="item0,item1,item2";//设置 radioGroup 的标签集。
			*radioGroup.skin="resource/ui/radio.png";//设置 radioGroup 的皮肤。
			*radioGroup.space=10;//设置 radioGroup 的项间隔距离。
			*radioGroup.selectHandler=new Handler(this,this.onSelect);//设置 radioGroup 的选择项发生改变时执行的处理器。
			*Laya.stage.addChild(radioGroup);//将 radioGroup 添加到显示列表。
			*}
		*
		*private onSelect(index:number):void {
			*console.log("当前选择的单选按钮索引: index= ",index);
			*}
		*
		*}
	*</listing>
	*/
	//class laya.ui.RadioGroup extends laya.ui.Group
	var RadioGroup=(function(_super){
		function RadioGroup(){RadioGroup.__super.call(this);;
		};

		__class(RadioGroup,'laya.ui.RadioGroup',_super);
		var __proto=RadioGroup.prototype;
		/**@inheritDoc */
		__proto.createItem=function(skin,label){
			return new Radio(skin,label);
		}

		return RadioGroup;
	})(Group)


	/**
	*<code>Tab</code> 组件用来定义选项卡按钮组。 *
	*@internal <p>属性：<code>selectedIndex</code> 的默认值为-1。</p>
	*
	*@example 以下示例代码，创建了一个 <code>Tab</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.Tab;
		*import laya.utils.Handler;
		*
		*public class Tab_Example
		*{
			*
			*public function Tab_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/tab.png"],Handler.create(this,onLoadComplete));//加载资源。
				*}
			*
			*private function onLoadComplete():void
			*{
				*var tab:Tab=new Tab();//创建一个 Tab 类的实例对象 tab 。
				*tab.skin="resource/ui/tab.png";//设置 tab 的皮肤。
				*tab.labels="item0,item1,item2";//设置 tab 的标签集。
				*tab.x=100;//设置 tab 对象的属性 x 的值，用于控制 tab 对象的显示位置。
				*tab.y=100;//设置 tab 对象的属性 y 的值，用于控制 tab 对象的显示位置。
				*tab.selectHandler=new Handler(this,onSelect);//设置 tab 的选择项发生改变时执行的处理器。
				*Laya.stage.addChild(tab);//将 tab 添到显示列表。
				*}
			*
			*private function onSelect(index:int):void
			*{
				*trace("当前选择的表情页索引: index= ",index);
				*}
			*}
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*Laya.loader.load(["resource/ui/tab.png"],laya.utils.Handler.create(this,onLoadComplete));
	*
	*function onLoadComplete(){
		*var tab=new laya.ui.Tab();//创建一个 Tab 类的实例对象 tab 。
		*tab.skin="resource/ui/tab.png";//设置 tab 的皮肤。
		*tab.labels="item0,item1,item2";//设置 tab 的标签集。
		*tab.x=100;//设置 tab 对象的属性 x 的值，用于控制 tab 对象的显示位置。
		*tab.y=100;//设置 tab 对象的属性 y 的值，用于控制 tab 对象的显示位置。
		*tab.selectHandler=new laya.utils.Handler(this,onSelect);//设置 tab 的选择项发生改变时执行的处理器。
		*Laya.stage.addChild(tab);//将 tab 添到显示列表。
		*}
	*function onSelect(index){
		*console.log("当前选择的标签页索引: index= ",index);
		*}
	*</listing>
	*<listing version="3.0">
	*import Tab=laya.ui.Tab;
	*import Handler=laya.utils.Handler;
	*class Tab_Example {
		*
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load(["resource/ui/tab.png"],Handler.create(this,this.onLoadComplete));//加载资源。
			*}
		*
		*private onLoadComplete():void {
			*var tab:Tab=new Tab();//创建一个 Tab 类的实例对象 tab 。
			*tab.skin="resource/ui/tab.png";//设置 tab 的皮肤。
			*tab.labels="item0,item1,item2";//设置 tab 的标签集。
			*tab.x=100;//设置 tab 对象的属性 x 的值，用于控制 tab 对象的显示位置。
			*tab.y=100;//设置 tab 对象的属性 y 的值，用于控制 tab 对象的显示位置。
			*tab.selectHandler=new Handler(this,this.onSelect);//设置 tab 的选择项发生改变时执行的处理器。
			*Laya.stage.addChild(tab);//将 tab 添到显示列表。
			*}
		*
		*private onSelect(index:number):void {
			*console.log("当前选择的表情页索引: index= ",index);
			*}
		*}
	*</listing>
	*/
	//class laya.ui.Tab extends laya.ui.Group
	var Tab=(function(_super){
		function Tab(){Tab.__super.call(this);;
		};

		__class(Tab,'laya.ui.Tab',_super);
		var __proto=Tab.prototype;
		/**
		*@private
		*@inheritDoc
		*/
		__proto.createItem=function(skin,label){
			return new Button(skin,label);
		}

		return Tab;
	})(Group)


	/**
	*<code>VBox</code> 是一个垂直布局容器类。
	*/
	//class laya.ui.VBox extends laya.ui.LayoutBox
	var VBox=(function(_super){
		/**
		*创建一个新的 <code>VBox</code> 类实例。
		*/
		function VBox(){
			VBox.__super.call(this);
		}

		__class(VBox,'laya.ui.VBox',_super);
		var __proto=VBox.prototype;
		/**@inheritDoc */
		__proto.changeItems=function(){
			var items=[];
			var maxWidth=0;
			for (var i=0,n=this.numChildren;i < n;i++){
				var item=this.getChildAt(i);
				if (item){
					items.push(item);
					maxWidth=Math.max(maxWidth,item.displayWidth);
				}
			}
			this.sortItem(items);
			var top=0;
			var $each_item;
			for($each_item in items){
				item=items[$each_item];
				item.y=top;
				top+=item.displayHeight+this._space;
				if (this._align=="left"){
					item.x=0;
					}else if (this._align=="center"){
					item.x=(maxWidth-item.displayWidth)*0.5;
					}else if (this._align=="right"){
					item.x=maxWidth-item.displayWidth;
				}
			}
			this.changeSize();
		}

		VBox.NONE="none";
		VBox.LEFT="left";
		VBox.CENTER="center";
		VBox.RIGHT="right";
		return VBox;
	})(LayoutBox)


	/**
	*<code>TextArea</code> 类用于创建显示对象以显示和输入文本。
	*@example 以下示例代码，创建了一个 <code>TextArea</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.TextArea;
		*import laya.utils.Handler;
		*
		*public class TextArea_Example
		*{
			*
			*public function TextArea_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/input.png"],Handler.create(this,onLoadComplete));//加载资源。
				*}
			*
			*private function onLoadComplete():void
			*{
				*var textArea:TextArea=new TextArea("这个一个TextArea实例。");//创建一个 TextArea 类的实例对象 textArea 。
				*textArea.skin="resource/ui/input.png";//设置 textArea 的皮肤。
				*textArea.sizeGrid="4,4,4,4";//设置 textArea 的网格信息。
				*textArea.color="#008fff";//设置 textArea 的文本颜色。
				*textArea.font="Arial";//设置 textArea 的字体。
				*textArea.bold=true;//设置 textArea 的文本显示为粗体。
				*textArea.fontSize=20;//设置 textArea 的文本字体大小。
				*textArea.wordWrap=true;//设置 textArea 的文本自动换行。
				*textArea.x=100;//设置 textArea 对象的属性 x 的值，用于控制 textArea 对象的显示位置。
				*textArea.y=100;//设置 textArea 对象的属性 y 的值，用于控制 textArea 对象的显示位置。
				*textArea.width=300;//设置 textArea 的宽度。
				*textArea.height=200;//设置 textArea 的高度。
				*Laya.stage.addChild(textArea);//将 textArea 添加到显示列表。
				*}
			*
			*}
		*
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高、渲染模式
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*Laya.loader.load(["resource/ui/input.png"],laya.utils.Handler.create(this,onLoadComplete));//加载资源。
	*function onLoadComplete(){
		*var textArea=new laya.ui.TextArea("这个一个TextArea实例。");//创建一个 TextArea 类的实例对象 textArea 。
		*textArea.skin="resource/ui/input.png";//设置 textArea 的皮肤。
		*textArea.sizeGrid="4,4,4,4";//设置 textArea 的网格信息。
		*textArea.color="#008fff";//设置 textArea 的文本颜色。
		*textArea.font="Arial";//设置 textArea 的字体。
		*textArea.bold=true;//设置 textArea 的文本显示为粗体。
		*textArea.fontSize=20;//设置 textArea 的文本字体大小。
		*textArea.wordWrap=true;//设置 textArea 的文本自动换行。
		*textArea.x=100;//设置 textArea 对象的属性 x 的值，用于控制 textArea 对象的显示位置。
		*textArea.y=100;//设置 textArea 对象的属性 y 的值，用于控制 textArea 对象的显示位置。
		*textArea.width=300;//设置 textArea 的宽度。
		*textArea.height=200;//设置 textArea 的高度。
		*Laya.stage.addChild(textArea);//将 textArea 添加到显示列表。
		*}
	*</listing>
	*<listing version="3.0">
	*import TextArea=laya.ui.TextArea;
	*import Handler=laya.utils.Handler;
	*class TextArea_Example {
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load(["resource/ui/input.png"],Handler.create(this,this.onLoadComplete));//加载资源。
			*}
		*private onLoadComplete():void {
			*var textArea:TextArea=new TextArea("这个一个TextArea实例。");//创建一个 TextArea 类的实例对象 textArea 。
			*textArea.skin="resource/ui/input.png";//设置 textArea 的皮肤。
			*textArea.sizeGrid="4,4,4,4";//设置 textArea 的网格信息。
			*textArea.color="#008fff";//设置 textArea 的文本颜色。
			*textArea.font="Arial";//设置 textArea 的字体。
			*textArea.bold=true;//设置 textArea 的文本显示为粗体。
			*textArea.fontSize=20;//设置 textArea 的文本字体大小。
			*textArea.wordWrap=true;//设置 textArea 的文本自动换行。
			*textArea.x=100;//设置 textArea 对象的属性 x 的值，用于控制 textArea 对象的显示位置。
			*textArea.y=100;//设置 textArea 对象的属性 y 的值，用于控制 textArea 对象的显示位置。
			*textArea.width=300;//设置 textArea 的宽度。
			*textArea.height=200;//设置 textArea 的高度。
			*Laya.stage.addChild(textArea);//将 textArea 添加到显示列表。
			*}
		*}
	*</listing>
	*/
	//class laya.ui.TextArea extends laya.ui.TextInput
	var TextArea=(function(_super){
		/**
		*<p>创建一个新的 <code>TextArea</code> 示例。</p>
		*@param text 文本内容字符串。
		*/
		function TextArea(text){
			(text===void 0)&& (text="");
			TextArea.__super.call(this,text);
			this.multiline=true;
		}

		__class(TextArea,'laya.ui.TextArea',_super);
		return TextArea;
	})(TextInput)


	//class game.view.TestView extends game.ui.test.TestPageUI
	var TestView=(function(_super){
		function TestView(){
			TestView.__super.call(this);
			this.btn.on("click",this,this.onBtnClick);
			this.btn2.on("click",this,this.onBtn2Click);
		}

		__class(TestView,'game.view.TestView',_super);
		var __proto=TestView.prototype;
		__proto.onBtnClick=function(){
			this.radio.selectedIndex=1;
			this.clip.index=8;
			this.tab.selectedIndex=2;
			this.combobox.selectedIndex=0;
			this.check.selected=true;
		}

		__proto.onBtn2Click=function(){
			this.box.dataSource={slider:50,scroll:80,progress:0.2,input:"This is a input",label:{color:"#ff0000",text:"Hello LayaAir"}};
			var arr=[];
			for (var i=0;i < 100;i++){
				arr.push({label:"item "+i,clip:i % 9});
			}
			this.list.array=arr;
		}

		//list.renderHandler=new Handler(this,onListRender);
		__proto.onListRender=function(item,index){
			var label=item.getChildByName("label");
			if (index % 2){
				label.color="#ff0000";
				}else {
				label.color="#000000";
			}
		}

		return TestView;
	})(TestPageUI)


	Laya.__init([Timer,LoaderManager,Browser,EventDispatcher]);
	new Main();

})(window,document,Laya);
