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
	Laya.interface('laya.display.ILayout');
	Laya.interface('laya.filters.IFilterAction');
	Laya.interface('laya.resource.IDispose');
	var sleep=Laya.sleep=function(value){
		Asyn.sleep(value);
	}


	var load=Laya.load=function(url,type){
		return Asyn.load(url,type);
	}


	var await=Laya.await=function(caller,fn,nextLine){
		Asyn._caller_=caller;
		Asyn._callback_=fn;
		Asyn._nextLine_=nextLine;
	}


	var wait=Laya.wait=function(conditions){
		return Asyn.wait(conditions);
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


	//class Text_AutoSize
	var Text_AutoSize=(function(){
		function Text_AutoSize(){
			Laya.init(550,400);
			Laya.stage.scaleMode="showall";
			var autoSizeText=this.createSampleText();
			autoSizeText.overflow=Text.VISIBLE;
			autoSizeText.y=50;
			var widthLimitText=this.createSampleText();
			widthLimitText.width=100;
			widthLimitText.y=180;
			var heightLimitText=this.createSampleText();
			heightLimitText.height=20;
			heightLimitText.y=320;
		}

		__class(Text_AutoSize,'Text_AutoSize');
		var __proto=Text_AutoSize.prototype;
		__proto.createSampleText=function(){
			var text=new Text();
			text.overflow=Text.HIDDEN;
			text.color="#FFFFFF";
			text.font="Impact";
			text.fontSize=20;
			text.borderColor="#FFFF00";
			text.x=80;
			Laya.stage.addChild(text);
			text.text="A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL\n"+"A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL\n"+"A POWERFUL HTML5 ENGINE ON FLASH TECHNICAL";
			return text;
		}

		return Text_AutoSize;
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


	Laya.__init([LoaderManager,Timer,EventDispatcher,Browser]);
	new Text_AutoSize();

})(window,document,Laya);
