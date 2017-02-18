/***********************************/
/*http://www.layabox.com 2016/05/19*/
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
						if(Laya[miniName]) debugger;
						Laya[miniName]=o;
					}					
				}
				else {
					if(fullName=="Main")
						window.Main=o;
					else{
						if(Laya[fullName]){
							console.log("Err!,Same class:"+fullName,Laya[fullName]);
							debugger;
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
	String.prototype.substr=Laya.__substr;
	Object.defineProperty(Array.prototype,'fixed',{enumerable: false});

	return Laya;
})(window,document);

(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;
	Laya.interface('laya.webgl.text.ICharSegment');
	Laya.interface('laya.display.ILayout');
	Laya.interface('laya.resource.IDispose');
	Laya.interface('laya.d3.graphics.IVertex');
	Laya.interface('laya.runtime.IMarket');
	Laya.interface('laya.filters.IFilterAction');
	Laya.interface('laya.d3.core.render.IRenderable');
	Laya.interface('laya.runtime.ICPlatformClass');
	Laya.interface('laya.runtime.IConchNode');
	Laya.interface('laya.webgl.resource.IMergeAtlasBitmap');
	Laya.interface('laya.webgl.canvas.save.ISaveData');
	Laya.interface('laya.webgl.shapes.IShape');
	Laya.interface('laya.webgl.submit.ISubmit');
	Laya.interface('laya.filters.IFilterActionGL','laya.filters.IFilterAction');
	/**
	*@private
	*/
	//class laya.utils.RunDriver
	var RunDriver=(function(){
		function RunDriver(){};
		__class(RunDriver,'laya.utils.RunDriver');
		RunDriver.FILTER_ACTIONS=[];
		RunDriver.pixelRatio=-1;
		RunDriver._charSizeTestDiv=null
		RunDriver.now=function(){
			return Date.now();
		}

		RunDriver.getWindow=function(){
			return window;
		}

		RunDriver.newWebGLContext=function(canvas,webGLName){
			return canvas.getContext(webGLName,{stencil:true,alpha:false,antialias:Config.isAntialias,premultipliedAlpha:false});
		}

		RunDriver.getPixelRatio=function(){
			if (RunDriver.pixelRatio < 0){
				var ctx=Browser.context;
				var backingStore=ctx.backingStorePixelRatio || ctx.webkitBackingStorePixelRatio || ctx.mozBackingStorePixelRatio || ctx.msBackingStorePixelRatio || ctx.oBackingStorePixelRatio || ctx.backingStorePixelRatio || 1;
				RunDriver.pixelRatio=(Browser.window.devicePixelRatio || 1)/ backingStore;
			}
			return RunDriver.pixelRatio;
		}

		RunDriver.getIncludeStr=function(name){
			return null;
		}

		RunDriver.createShaderCondition=function(conditionScript){
			var fn="(function() {return "+conditionScript+";})";
			return Browser.window.eval(fn);
		}

		RunDriver.measureText=function(txt,font){
			if (Render.isConchApp){
				var ctx=ConchTextCanvas;
				ctx.font=font;
				return ctx.measureText(txt);
			}
			if (RunDriver._charSizeTestDiv==null){
				RunDriver._charSizeTestDiv=Browser.createElement('div');
				RunDriver._charSizeTestDiv.style.cssText="z-index:10000000;padding:0px;position: absolute;left:0px;visibility:hidden;top:0px;background:white";
				Browser.container.appendChild(RunDriver._charSizeTestDiv);
			}
			RunDriver._charSizeTestDiv.style.font=font;
			RunDriver._charSizeTestDiv.innerText=txt==" " ? "i" :txt;
			return {width:RunDriver._charSizeTestDiv.offsetWidth,height:RunDriver._charSizeTestDiv.offsetHeight};
		}

		RunDriver.beginFlush=function(){
		};

		RunDriver.endFinish=function(){
		};

		RunDriver.addToAtlas=null
		RunDriver.flashFlushImage=function(atlasWebGLCanvas){
		};

		RunDriver.drawToCanvas=function(sprite,_renderType,canvasWidth,canvasHeight,offsetX,offsetY){
			var canvas=HTMLCanvas.create("2D");
			var context=new RenderContext(canvasWidth,canvasHeight,canvas);
			RenderSprite.renders[_renderType]._fun(sprite,context,offsetX,offsetY);
			return canvas;
		}

		RunDriver.createParticleTemplate2D=null
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
			Render._context.ctx.clear();
		}

		RunDriver.clearAtlas=function(value){
		};

		RunDriver.addTextureToAtlas=function(value){
		};

		RunDriver.getTexturePixels=function(value,x,y,width,height){
			return null;
		}

		RunDriver.fillTextureShader=function(value,x,y,width,height){
			return null;
		}

		RunDriver.skinAniSprite=function(){
			return null;
		}

		return RunDriver;
	})()


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
			Browser.__init__();
			Context.__init__();
			Graphics.__init__();
			Laya.timer=new Timer();
			Laya.loader=new LoaderManager();
			for (var i=0,n=plugins.length;i < n;i++){
				if (plugins[i].enable)plugins[i].enable();
			}
			Font.__init__();
			Style.__init__();
			ResourceManager.__init__();
			CacheManger.beginCheck();
			Laya.stageBox=Laya.stage=new Stage();
			Laya.stage.model&&Laya.stage.model.setRootNode();
			var location=Browser.window.location;
			var pathName=location.pathname;
			pathName=pathName.charAt(2)==':' ? pathName.substring(1):pathName;
			URL.rootPath=URL.basePath=URL.getPath(location.protocol=="file:" ? pathName :location.protocol+"//"+location.host+location.pathname);
			Laya.render=new Render(0,0);
			Laya.stage.size(width,height);
			RenderSprite.__init__();
			KeyBoardManager.__init__();
			MouseManager.instance.__init__(Laya.stage,Render.canvas);
			Input.__init__();
			SoundManager.autoStopMusic=true;
			LocalStorage.__init__();
			return Render.canvas;
		}

		Laya.stage=null;
		Laya.timer=null;
		Laya.loader=null;
		Laya.render=null
		Laya.version="1.5.0";
		Laya.stageBox=null
		__static(Laya,
		['conchMarket',function(){return this.conchMarket=window.conch?conchMarket:null;},'PlatformClass',function(){return this.PlatformClass=window.PlatformClass;}
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
						(data !=null)? listener.runWith(data):listener.run();
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
			if(!arr)return;
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
			if (this.method==null)return null;
			var id=this._id;
			var result=this.method.apply(this.caller,this.args);
			this._id===id && this.once && this.recover();
			return result;
		}

		/**
		*执行处理器，携带额外数据。
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


	/*[COMPI2LER OPTIONS:showdebug]*/
	//class threeDimen.advancedStage.D3Advance_MousePickingSample
	var D3Advance_MousePickingSample=(function(){
		function D3Advance_MousePickingSample(){
			Laya3D.init(0,0,true);
			Laya.stage.scaleMode="full";
			Laya.stage.screenMode="none";
			Stat.show();
			Laya.stage.addChild(new MousePickingScene());
		}

		__class(D3Advance_MousePickingSample,'threeDimen.advancedStage.D3Advance_MousePickingSample');
		return D3Advance_MousePickingSample;
	})()


	/**
	*Config 用于配置一些全局参数。
	*/
	//class Config
	var Config=(function(){
		function Config(){};
		__class(Config,'Config');
		Config.WebGLTextCacheCount=500;
		Config.atlasEnable=false;
		Config.showCanvasMark=false;
		Config.CPUMemoryLimit=120 *1024 *1024;
		Config.GPUMemoryLimit=160 *1024 *1024;
		Config.animationInterval=50;
		Config.isAntialias=false;
		return Config;
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
			//this._vectorgraphArray=null;
			this._render=this._renderEmpty;
			this._render=this._renderEmpty;
			if (Render.isConchNode){
				this._nativeObj=new _conchGraphics();;
				this.id=this._nativeObj.conchID;;
			}
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
		*<p>清空绘制命令。</p>
		*/
		__proto.clear=function(){
			this._one=null;
			this._render=this._renderEmpty;
			this._cmds=null;
			this._temp && (this._temp.length=0);
			this._sp && (this._sp._renderType &=~0x01);
			this._sp && (this._sp._renderType &=~0x100);
			this._repaint();
			if (this._vectorgraphArray){
				for (var i=0,n=this._vectorgraphArray.length;i < n;i++){
					VectorGraphManager.getInstance().deleteShape(this._vectorgraphArray[i]);
				}
				this._vectorgraphArray.length=0;
			}
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
			return this._rstBoundPoints=Utils.copyArray(this._rstBoundPoints,this._temp);
		}

		__proto._addCmd=function(a){
			this._cmds=this._cmds || [];
			a.callee=a.shift();
			this._cmds.push(a);
		}

		__proto._getCmdPoints=function(){
			var context=Render._context;
			var cmds=this._cmds;
			var rst;
			rst=this._temp || (this._temp=[]);
			rst.length=0;
			if (!cmds && this._one !=null){
				Graphics._tempCmds.length=0;
				Graphics._tempCmds.push(this._one);
				cmds=Graphics._tempCmds;
			}
			if (!cmds)
				return rst;
			var matrixs;
			matrixs=Graphics._tempMatrixArrays;
			matrixs.length=0;
			var tMatrix=Graphics._initMatrix;
			tMatrix.identity();
			var tempMatrix=Graphics._tempMatrix;
			var cmd;
			for (var i=0,n=cmds.length;i < n;i++){
				cmd=cmds[i];
				switch (cmd.callee){
					case context.save:
					case 7:
						matrixs.push(tMatrix);
						tMatrix=tMatrix.clone();
						break ;
					case context.restore:
					case 8:
						tMatrix=matrixs.pop();
						break ;
					case context._scale:
					case 5:
						tempMatrix.identity();
						tempMatrix.translate(-cmd[2],-cmd[3]);
						tempMatrix.scale(cmd[0],cmd[1]);
						tempMatrix.translate(cmd[2],cmd[3]);
						this._switchMatrix(tMatrix,tempMatrix);
						break ;
					case context._rotate:
					case 3:
						tempMatrix.identity();
						tempMatrix.translate(-cmd[1],-cmd[2]);
						tempMatrix.rotate(cmd[0]);
						tempMatrix.translate(cmd[1],cmd[2]);
						this._switchMatrix(tMatrix,tempMatrix);
						break ;
					case context._translate:
					case 6:
						tempMatrix.identity();
						tempMatrix.translate(cmd[0],cmd[1]);
						this._switchMatrix(tMatrix,tempMatrix);
						break ;
					case context._transform:
					case 4:
						tempMatrix.identity();
						tempMatrix.translate(-cmd[1],-cmd[2]);
						tempMatrix.concat(cmd[0]);
						tempMatrix.translate(cmd[1],cmd[2]);
						this._switchMatrix(tMatrix,tempMatrix);
						break ;
					case 16:
					case 24:
						Graphics._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd[0],cmd[1],cmd[2],cmd[3]),tMatrix);
						break ;
					case 17:
						tMatrix.copyTo(tempMatrix);
						tempMatrix.concat(cmd[4]);
						Graphics._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd[0],cmd[1],cmd[2],cmd[3]),tempMatrix);
						break ;
					case context._drawTexture:
					case context._fillTexture:
						if (cmd[3] && cmd[4]){
							Graphics._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd[1],cmd[2],cmd[3],cmd[4]),tMatrix);
							}else {
							var tex=cmd[0];
							Graphics._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd[1],cmd[2],tex.width,tex.height),tMatrix);
						}
						break ;
					case context._drawTextureWithTransform:
						tMatrix.copyTo(tempMatrix);
						tempMatrix.concat(cmd[5]);
						if (cmd[3] && cmd[4]){
							Graphics._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd[1],cmd[2],cmd[3],cmd[4]),tempMatrix);
							}else {
							tex=cmd[0];
							Graphics._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd[1],cmd[2],tex.width,tex.height),tempMatrix);
						}
						break ;
					case context._drawRect:
					case 13:
						Graphics._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd[0],cmd[1],cmd[2],cmd[3]),tMatrix);
						break ;
					case context._drawCircle:
					case context._fillCircle:
					case 14:
						Graphics._addPointArrToRst(rst,Rectangle._getBoundPointS(cmd[0]-cmd[2],cmd[1]-cmd[2],cmd[2]+cmd[2],cmd[2]+cmd[2]),tMatrix);
						break ;
					case context._drawLine:
					case 20:
						Graphics._tempPoints.length=0;
						var lineWidth=NaN;
						lineWidth=cmd[5] *0.5;
						if (cmd[0]==cmd[2]){
							Graphics._tempPoints.push(cmd[0]+lineWidth,cmd[1],cmd[2]+lineWidth,cmd[3],cmd[0]-lineWidth,cmd[1],cmd[2]-lineWidth,cmd[3]);
							}else if (cmd[1]==cmd[3]){
							Graphics._tempPoints.push(cmd[0],cmd[1]+lineWidth,cmd[2],cmd[3]+lineWidth,cmd[0],cmd[1]-lineWidth,cmd[2],cmd[3]-lineWidth);
							}else {
							Graphics._tempPoints.push(cmd[0],cmd[1],cmd[2],cmd[3]);
						}
						Graphics._addPointArrToRst(rst,Graphics._tempPoints,tMatrix);
						break ;
					case context._drawCurves:
					case 22:
						Graphics._addPointArrToRst(rst,Bezier.I.getBezierPoints(cmd[2]),tMatrix,cmd[0],cmd[1]);
						break ;
					case context._drawPoly:
					case context._drawLines:
					case 18:
						Graphics._addPointArrToRst(rst,cmd[2],tMatrix,cmd[0],cmd[1]);
						break ;
					case context._drawPath:
					case 19:
						Graphics._addPointArrToRst(rst,this._getPathPoints(cmd[2]),tMatrix,cmd[0],cmd[1]);
						break ;
					case context._drawPie:
					case 15:
						Graphics._addPointArrToRst(rst,this._getPiePoints(cmd[0],cmd[1],cmd[2],cmd[3],cmd[4]),tMatrix);
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

		/**
		*绘制纹理。
		*@param tex 纹理。
		*@param x X 轴偏移量。
		*@param y Y 轴偏移量。
		*@param width 宽度。
		*@param height 高度。
		*@param m 矩阵信息。
		*/
		__proto.drawTexture=function(tex,x,y,width,height,m,alpha){
			(width===void 0)&& (width=0);
			(height===void 0)&& (height=0);
			(alpha===void 0)&& (alpha=1);
			if (!tex)return;
			if (!width)width=tex.sourceWidth;
			if (!height)height=tex.sourceHeight;
			width=width-tex.sourceWidth+tex.width;
			height=height-tex.sourceHeight+tex.height;
			if (tex.loaded && (width <=0 || height <=0))return;
			x+=tex.offsetX;
			y+=tex.offsetY;
			this._sp && (this._sp._renderType |=0x100);
			var args=[tex,x,y,width,height,m,alpha];
			args.callee=(m || alpha!=1)? Render._context._drawTextureWithTransform :Render._context._drawTexture;
			if (this._one==null && !m && alpha==1){
				this._one=args;
				this._render=this._renderOneImg;
				}else {
				this._saveToCmd(args.callee,args);
			}
			if (!tex.loaded){
				tex.once("loaded",this,this._textureLoaded,[tex,args]);
			}
			this._repaint();
		}

		/**
		*批量绘制同样纹理。
		*@param tex 纹理。
		*@param pos 绘制次数和坐标。
		*/
		__proto.drawTextures=function(tex,pos){
			if (!tex)return;
			this._saveToCmd(Render._context._drawTextures,[tex,pos]);
		}

		/**
		*用texture填充
		*@param tex 纹理。
		*@param x X 轴偏移量。
		*@param y Y 轴偏移量。
		*@param width 宽度。
		*@param height 高度。
		*@param type 填充类型 repeat|repeat-x|repeat-y|no-repeat
		*@param offset 贴图纹理偏移
		*
		*/
		__proto.fillTexture=function(tex,x,y,width,height,type,offset){
			(width===void 0)&& (width=0);
			(height===void 0)&& (height=0);
			(type===void 0)&& (type="repeat");
			if (!tex)return;
			var args=[tex,x,y,width,height,type,offset];
			if (!tex.loaded){
				tex.once("loaded",this,this._textureLoaded,[tex,args]);
			}
			if (Render.isWebGL){
				var tFillTextureSprite=RunDriver.fillTextureShader(tex,x,y,width,height);
				args.push(tFillTextureSprite);
			}
			this._saveToCmd(Render._context._fillTexture,args);
		}

		__proto._textureLoaded=function(tex,param){
			param[3]=param[3] || tex.width;
			param[4]=param[4] || tex.height;
			this._repaint();
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
		*设置剪裁区域，超出剪裁区域的坐标不显示。
		*@param x X 轴偏移量。
		*@param y Y 轴偏移量。
		*@param width 宽度。
		*@param height 高度。
		*/
		__proto.clipRect=function(x,y,width,height){
			this._saveToCmd(Render._context._clipRect,[x,y,width,height]);
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
			this._saveToCmd(Render._context._fillText,[text,x,y,font || Font.defaultFont,color,textAlign]);
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
			this._saveToCmd(Render._context._fillBorderText,[text,x,y,font || Font.defaultFont,fillColor,borderColor,lineWidth,textAlign]);
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
			this._saveToCmd(Render._context._strokeText,[text,x,y,font || Font.defaultFont,color,lineWidth,textAlign]);
		}

		/**
		*设置透明度。
		*@param value 透明度。
		*/
		__proto.alpha=function(value){
			this._saveToCmd(Render._context._alpha,[value]);
		}

		/**
		*替换绘图的当前转换矩阵。
		*@param mat 矩阵。
		*@param pivotX 水平方向轴心点坐标。
		*@param pivotY 垂直方向轴心点坐标。
		*/
		__proto.transform=function(matrix,pivotX,pivotY){
			(pivotX===void 0)&& (pivotX=0);
			(pivotY===void 0)&& (pivotY=0);
			this._saveToCmd(Render._context._transform,[matrix,pivotX,pivotY]);
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
			this._saveToCmd(Render._context._rotate,[angle,pivotX,pivotY]);
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
			this._saveToCmd(Render._context._scale,[scaleX,scaleY,pivotX,pivotY]);
		}

		/**
		*重新映射画布上的 (0,0)位置。
		*@param x 添加到水平坐标（x）上的值。
		*@param y 添加到垂直坐标（y）上的值。
		*/
		__proto.translate=function(x,y){
			this._saveToCmd(Render._context._translate,[x,y]);
		}

		/**
		*保存当前环境的状态。
		*/
		__proto.save=function(){
			this._saveToCmd(Render._context._save,[]);
		}

		/**
		*返回之前保存过的路径状态和属性。
		*/
		__proto.restore=function(){
			this._saveToCmd(Render._context._restore,[]);
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
				if (this._one && this._isTextCmd(this._one.callee)){
					if (this._one[0].toUpperCase)this._one[0]=text;
					else this._one[0].setText(text);
					return true;
				}
				}else {
				for (var i=cmds.length-1;i >-1;i--){
					if (this._isTextCmd(cmds[i].callee)){
						if (cmds[i][0].toUpperCase)cmds[i][0]=text;
						else cmds[i][0].setText(text);
						return true;
					}
				}
			}
			return false;
		}

		/**@private */
		__proto._isTextCmd=function(fun){
			return fun===Render._context._fillText || fun===Render._context._fillBorderText || fun===Render._context._strokeText;
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
				if (this._one && this._isTextCmd(this._one.callee)){
					this._one[4]=color;
					if (!this._one[0].toUpperCase)this._one[0].changed=true;
				}
				}else {
				for (var i=cmds.length-1;i >-1;i--){
					if (this._isTextCmd(cmds[i].callee)){
						cmds[i][4]=color;
						if (!cmds[i][0].toUpperCase)cmds[i][0].changed=true;
					}
				}
			}
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
			var tId=0;
			if (Render.isWebGL){
				tId=VectorGraphManager.getInstance().getId();
				if (this._vectorgraphArray==null)this._vectorgraphArray=[];
				this._vectorgraphArray.push(tId);
			};
			var arr=[fromX+0.5,fromY+0.5,toX+0.5,toY+0.5,lineColor,lineWidth,tId];
			this._saveToCmd(Render._context._drawLine,arr);
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
			var tId=0;
			if (Render.isWebGL){
				tId=VectorGraphManager.getInstance().getId();
				if (this._vectorgraphArray==null)this._vectorgraphArray=[];
				this._vectorgraphArray.push(tId);
			};
			var arr=[x+0.5,y+0.5,points,lineColor,lineWidth,tId];
			this._saveToCmd(Render._context._drawLines,arr);
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
			this._saveToCmd(Render._context._drawCurves,arr);
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
			this._saveToCmd(Render._context._drawRect,arr);
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
			var tId=0;
			if (Render.isWebGL){
				tId=VectorGraphManager.getInstance().getId();
				if (this._vectorgraphArray==null)this._vectorgraphArray=[];
				this._vectorgraphArray.push(tId);
			};
			var arr=[x+offset,y+offset,radius,fillColor,lineColor,lineWidth,tId];
			this._saveToCmd(Render._context._drawCircle,arr);
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
			var tId=0;
			if (Render.isWebGL){
				tId=VectorGraphManager.getInstance().getId();
				if (this._vectorgraphArray==null)this._vectorgraphArray=[];
				this._vectorgraphArray.push(tId);
			};
			var arr=[x+offset,y+offset,radius,startAngle,endAngle,fillColor,lineColor,lineWidth,tId];
			arr[3]=Utils.toRadian(startAngle);
			arr[4]=Utils.toRadian(endAngle);
			this._saveToCmd(Render._context._drawPie,arr);
		}

		__proto._getPiePoints=function(x,y,radius,startAngle,endAngle){
			var rst=Graphics._tempPoints;
			Graphics._tempPoints.length=0;
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
			var arr=[x+offset,y+offset,points,fillColor,lineColor,lineWidth,tId,tIsConvexPolygon];
			this._saveToCmd(Render._context._drawPoly,arr);
		}

		__proto._getPathPoints=function(paths){
			var i=0,len=0;
			var rst=Graphics._tempPoints;
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

		/**
		*绘制路径。
		*@param x 开始绘制的 X 轴位置。
		*@param y 开始绘制的 Y 轴位置。
		*@param paths 路径集合，路径支持以下格式：[["moveTo",x,y],["lineTo",x,y,x,y,x,y],["arcTo",x1,y1,x2,y2,r],["closePath"]]。
		*@param brush 刷子定义，支持以下设置{fillStyle}。
		*@param pen 画笔定义，支持以下设置{strokeStyle,lineWidth,lineJoin,lineCap,miterLimit}。
		*/
		__proto.drawPath=function(x,y,paths,brush,pen){
			var arr=[x+0.5,y+0.5,paths,brush,pen];
			this._saveToCmd(Render._context._drawPath,arr);
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

		Graphics.__init__=function(){
			if (Render.isConchNode){
				var from=laya.display.Graphics.prototype;
				var to=ConchGraphics.prototype;
				var list=["clear","destroy","alpha","rotate","transform","scale","translate","save","restore","clipRect","blendMode","fillText","fillBorderText","_fands","drawRect","drawCircle","drawPie","drawPoly","drawPath","drawImageM","drawLine","drawLines","_drawPs","drawCurves","replaceText","replaceTextColor","_fillImage","fillTexture"];
				for (var i=0,len=list.length;i <=len;i++){
					var temp=list[i];
					from[temp]=to[temp];
				}
				from._saveToCmd=null;
				from.drawTexture=function (tex,x,y,width,height,m){
					(x===void 0)&& (x=0);
					(y===void 0)&& (y=0);
					(width===void 0)&& (width=0);
					(height===void 0)&& (height=0);
					if (!tex)return;
					if (!(tex.loaded && tex.bitmap && tex.source)){
						return;
					}
					if (!width)width=tex.sourceWidth;
					if (!height)height=tex.sourceHeight;
					width=width-tex.sourceWidth+tex.width;
					height=height-tex.sourceHeight+tex.height;
					if (width <=0 || height <=0)return;
					x+=tex.offsetX;
					y+=tex.offsetY;
					var uv=tex.uv,w=tex.bitmap.width,h=tex.bitmap.height;
					this.drawImageM(tex.bitmap.source,uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h,x,y,width,height,m);
				}
				from.fillTexture=function (tex,x,y,width,height,type,offset){
					(width===void 0)&& (width=0);
					(height===void 0)&& (height=0);
					(type===void 0)&& (type="repeat");
					if (!tex)return;
					if (tex.loaded){
						var ctxi=Render._context.ctx;
						var w=tex.bitmap.width,h=tex.bitmap.height,uv=tex.uv;
						var pat;
						if (tex.uv !=Texture.DEF_UV){
							pat=ctxi.createPattern(tex.bitmap.source,type,uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h);
							}else {
							pat=ctxi.createPattern(tex.bitmap.source,type);
						};
						var sX=0,sY=0;
						if (offset){
							x+=offset.x % tex.width;
							y+=offset.y % tex.height;
							sX-=offset.x % tex.width;
							sY-=offset.y % tex.height;
						}
						this._fillImage(pat,x,y,sX,sY,width,height);
					}
				}
			}
		}

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
			_tempPoint.setTo(x ? x :0,y ? y :0);
			matrix.transformPoint(_tempPoint);
			rst.push(_tempPoint.x,_tempPoint.y);
		}

		Graphics._tempPoints=[];
		Graphics._tempMatrixArrays=[];
		Graphics._tempCmds=[];
		__static(Graphics,
		['_tempMatrix',function(){return this._tempMatrix=new Matrix();},'_initMatrix',function(){return this._initMatrix=new Matrix();}
		]);
		return Graphics;
	})()


	/**
	*<code>Layer</code> 类用于实现遮罩层。
	*/
	//class laya.d3.core.Layer
	var Layer=(function(){
		function Layer(){
			this._id=0;
			this._number=0;
			this._mask=0;
			this._active=true;
			this._visible=true;
			this.name=null;
			this._id=Layer._uniqueIDCounter;
			Layer._uniqueIDCounter++;
			if (this._id > 1+31)
				throw new Error("不允许创建Layer，请参考函数getLayerByNumber、getLayerByMask、getLayerByName！");
		}

		__class(Layer,'laya.d3.core.Layer');
		var __proto=Layer.prototype;
		/**
		*获取编号。
		*@return 编号。
		*/
		__getset(0,__proto,'number',function(){
			return this._number;
		});

		/**
		*获取蒙版值。
		*@return 蒙版值。
		*/
		__getset(0,__proto,'mask',function(){
			return this._mask;
		});

		/**
		*设置是否激活。
		*@param value 是否激活。
		*/
		/**
		*获取是否激活。
		*@return 是否激活。
		*/
		__getset(0,__proto,'active',function(){
			return this._active;
			},function(value){
			if (this._number===29 || this._number==30)
				return;
			this._active=value;
			if (value)
				Layer._activeLayers=Layer._activeLayers | this.mask;
			else
			Layer._activeLayers=Layer._activeLayers & ~this.mask;
		});

		/**
		*设置是否显示。
		*@param value 是否显示。
		*/
		/**
		*获取是否显示。
		*@return 是否显示。
		*/
		__getset(0,__proto,'visible',function(){
			return this._visible;
			},function(value){
			if (this._number===29 || this._number==30)
				return;
			this._visible=value;
			if (value)
				Layer._visibleLayers=Layer._visibleLayers | this.mask;
			else
			Layer._visibleLayers=Layer._visibleLayers & ~this.mask;
		});

		/**
		*设置Layer激活层。
		*@param value 激活层。
		*/
		/**
		*获取Layer激活层。
		*@return 激活层。
		*/
		__getset(1,Layer,'activeLayers',function(){
			return Layer._activeLayers;
			},function(value){
			Layer._activeLayers=value | Layer.getLayerByNumber(29).mask | Layer.getLayerByNumber(30).mask;
			for (var i=0;i < Layer._layerList.length;i++){
				var layer=Layer._layerList[i];
				layer._active=(layer._mask & Layer._activeLayers)!==0;
			}
		});

		/**
		*设置Layer显示层。
		*@param value 显示层。
		*/
		/**
		*获取Layer显示层。
		*@return 显示层。
		*/
		__getset(1,Layer,'visibleLayers',function(){
			return Layer._visibleLayers;
			},function(value){
			Layer._visibleLayers=value | Layer.getLayerByNumber(29).mask | Layer.getLayerByNumber(30).mask;
			for (var i=0;i < Layer._layerList.length;i++){
				var layer=Layer._layerList[i];
				layer._visible=(layer._mask & Layer._visibleLayers)!==0;
			}
		});

		Layer.__init__=function(){
			Layer._layerList.length=31;
			for (var i=0;i < 31;i++){
				var layer=new Layer();
				Layer._layerList[i]=layer;
				if (i===0)
					layer.name="Default Layer";
				else if (i===29)
				layer.name="Reserved Layer0";
				else if (i===30)
				layer.name="Reserved Layer1";
				else
				layer.name="Layer-"+i;
				layer._number=i;
				layer._mask=Math.pow(2,i);
			}
			Layer._activeLayers=2147483647;
			Layer._visibleLayers=2147483647;
			Layer._currentCameraCullingMask=2147483647;
			Layer.currentCreationLayer=Layer._layerList[0];
		}

		Layer.getLayerByNumber=function(number){
			if (number < 0 || number > 30)
				throw new Error("无法返回指定Layer，该number超出范围！");
			return Layer._layerList[number];
		}

		Layer.getLayerByMask=function(mask){
			for (var i=0;i < 31;i++){
				if (Layer._layerList[i].mask===mask)
					return Layer._layerList[i];
			}
			throw new Error("无法返回指定Layer,该mask不存在");
		}

		Layer.getLayerByName=function(name){
			for (var i=0;i < 31;i++){
				if (Layer._layerList[i].name===name)
					return Layer._layerList[i];
			}
			throw new Error("无法返回指定Layer,该name不存在");
		}

		Layer.isActive=function(mask){
			return (mask & Layer._activeLayers)!=0;
		}

		Layer.isVisible=function(mask){
			return (mask & Layer._currentCameraCullingMask & Layer._visibleLayers)!=0;
		}

		Layer._uniqueIDCounter=1;
		Layer._layerCount=31;
		Layer._layerList=[];
		Layer._activeLayers=0;
		Layer._visibleLayers=0;
		Layer._currentCameraCullingMask=0;
		Layer.currentCreationLayer=null
		return Layer;
	})()


	/**
	*@private
	*<code>PhasorSpriter3D</code> 类用于创建矢量笔刷。
	*/
	//class laya.d3.core.PhasorSpriter3D
	var PhasorSpriter3D=(function(){
		function PhasorSpriter3D(){
			this._tempInt0=0;
			this._tempInt1=0;
			this._tempUint0=0;
			this._tempUint1=0;
			this._tempUint2=0;
			this._tempUint3=0;
			this._tempUint4=0;
			this._tempUint5=0;
			this._tempUint6=0;
			this._tempUint7=0;
			this._tempNumver0=NaN;
			this._tempNumver1=NaN;
			this._tempNumver2=NaN;
			this._tempNumver3=NaN;
			this._floatSizePerVer=7;
			this._defaultBufferSize=600 *this._floatSizePerVer;
			this._vb=null;
			this._posInVBData=0;
			this._ib=null;
			this._posInIBData=0;
			this._primitiveType=NaN;
			this._hasBegun=false;
			this._numVertsPerPrimitive=0;
			this._renderState=null;
			this._sharderNameID=0;
			this._shader=null;
			this._posShaderValue=[3,0x1406,false,28,0];
			this._colorShaderValue=[4,0x1406,false,28,12];
			this._albedo=new Vector4(1.0,1.0,1.0,1.0);
			this._vbData=new Float32Array(this._defaultBufferSize);
			this._ibData=new Uint16Array(this._defaultBufferSize);
			this._wvpMatrix=new Matrix4x4();
			;
			this._vb=new VertexBuffer2D(-1,0x88E8);
			this._ib=new IndexBuffer2D();
			this._sharderNameID=Shader.nameKey.get("SIMPLE");
		}

		__class(PhasorSpriter3D,'laya.d3.core.PhasorSpriter3D');
		var __proto=PhasorSpriter3D.prototype;
		__proto.line=function(startX,startY,startZ,startR,startG,startB,startA,endX,endY,endZ,endR,endG,endB,endA){
			if (!this._hasBegun || this._primitiveType!==0x0001)
				this.drawLinesException();
			if (this._posInVBData+2 *this._floatSizePerVer > this._vbData.length || this._posInIBData+2 > this._ibData.length)
				this.flush();
			this._tempUint0=this._posInVBData / this._floatSizePerVer;
			this.addVertex(startX,startY,startZ,startR,startG,startB,startA);
			this.addVertex(endX,endY,endZ,endR,endG,endB,endA);
			this.addIndexes(this._tempUint0,this._tempUint0+1);
			return this;
		}

		__proto.circle=function(radius,numberOfPoints,r,g,b,a){
			if (!this._hasBegun || (this._primitiveType!==0x0001))
				this.drawLinesException();
			this._tempUint0=numberOfPoints *2;
			if (this._posInVBData+this._tempUint0 *this._floatSizePerVer > this._vbData.length || this._posInIBData+2 *this._tempUint0 > this._ibData.length)
				this.flush();
			this._tempUint1=this._posInVBData / this._floatSizePerVer;
			for (this._tempNumver0=0,this._tempInt0=0;this._tempNumver0 < 3.1416 *2;this._tempNumver0=this._tempNumver0+(3.1416 / numberOfPoints),this._tempInt0++){
				this.addVertex(Math.sin(this._tempNumver0)*radius,Math.cos(this._tempNumver0)*radius,0,r,g,b,a);
				if (this._tempInt0===0){
					this.addIndexes(this._tempUint1);
					}else if (this._tempInt0===this._tempUint0-1){
					this._tempUint2=this._tempUint1+this._tempInt0;
					this.addIndexes(this._tempUint2,this._tempUint2,this._tempUint1);
					}else {
					this._tempUint2=this._tempUint1+this._tempInt0;
					this.addIndexes(this._tempUint2,this._tempUint2);
				}
			}
			return this;
		}

		__proto.plane=function(positionX,positionY,positionZ,width,height,r,g,b,a){
			if (!this._hasBegun || this._primitiveType!==0x0004)
				this.drawTrianglesException();
			if (this._posInVBData+4 *this._floatSizePerVer > this._vbData.length || this._posInIBData+6 > this._ibData.length)
				this.flush();
			this._tempNumver0=width / 2;
			this._tempNumver1=height / 2;
			this._tempUint0=this._posInVBData / this._floatSizePerVer;
			this.addVertex(positionX-this._tempNumver0,positionY+this._tempNumver1,positionZ,r,g,b,a);
			this.addVertex(positionX+this._tempNumver0,positionY+this._tempNumver1,positionZ,r,g,b,a);
			this.addVertex(positionX-this._tempNumver0,positionY-this._tempNumver1,positionZ,r,g,b,a);
			this.addVertex(positionX+this._tempNumver0,positionY-this._tempNumver1,positionZ,r,g,b,a);
			this._tempUint1=this._tempUint0+1;
			this._tempUint2=this._tempUint0+2;
			this.addIndexes(this._tempUint0,this._tempUint1,this._tempUint2,this._tempUint2,this._tempUint1,this._tempUint0+3);
			return this;
		}

		__proto.box=function(positionX,positionY,positionZ,width,height,depth,r,g,b,a){
			if (!this._hasBegun || this._primitiveType!==0x0004)
				this.drawTrianglesException();
			if (this._posInVBData+8 *this._floatSizePerVer > this._vbData.length || this._posInIBData+36 > this._ibData.length)
				this.flush();
			this._tempNumver0=width / 2;
			this._tempNumver1=height / 2;
			this._tempNumver2=depth / 2;
			this._tempUint0=this._posInVBData / this._floatSizePerVer;
			this.addVertex(positionX-this._tempNumver0,positionY+this._tempNumver1,positionZ+this._tempNumver2,r,g,b,a);
			this.addVertex(positionX+this._tempNumver0,positionY+this._tempNumver1,positionZ+this._tempNumver2,r,g,b,a);
			this.addVertex(positionX-this._tempNumver0,positionY-this._tempNumver1,positionZ+this._tempNumver2,r,g,b,a);
			this.addVertex(positionX+this._tempNumver0,positionY-this._tempNumver1,positionZ+this._tempNumver2,r,g,b,a);
			this.addVertex(positionX+this._tempNumver0,positionY+this._tempNumver1,positionZ-this._tempNumver2,r,g,b,a);
			this.addVertex(positionX-this._tempNumver0,positionY+this._tempNumver1,positionZ-this._tempNumver2,r,g,b,a);
			this.addVertex(positionX+this._tempNumver0,positionY-this._tempNumver1,positionZ-this._tempNumver2,r,g,b,a);
			this.addVertex(positionX-this._tempNumver0,positionY-this._tempNumver1,positionZ-this._tempNumver2,r,g,b,a);
			this._tempUint1=this._tempUint0+1;
			this._tempUint2=this._tempUint0+2;
			this._tempUint3=this._tempUint0+3;
			this._tempUint4=this._tempUint0+4;
			this._tempUint5=this._tempUint0+5;
			this._tempUint6=this._tempUint0+6;
			this._tempUint7=this._tempUint0+7;
			this.addIndexes(this._tempUint0,this._tempUint1,this._tempUint2,this._tempUint2,this._tempUint1,this._tempUint3,
			this._tempUint4,this._tempUint5,this._tempUint6,this._tempUint6,this._tempUint5,this._tempUint7,
			this._tempUint5,this._tempUint0,this._tempUint7,this._tempUint7,this._tempUint0,this._tempUint2,
			this._tempUint1,this._tempUint4,this._tempUint3,this._tempUint3,this._tempUint4,this._tempUint6,
			this._tempUint5,this._tempUint4,this._tempUint0,this._tempUint0,this._tempUint4,this._tempUint1,
			this._tempUint2,this._tempUint3,this._tempUint7,this._tempUint7,this._tempUint3,this._tempUint6);
			return this;
		}

		__proto.cone=function(radius,length,Slices,r,g,b,a){
			if (!this._hasBegun || this._primitiveType!==0x0004)
				this.drawTrianglesException();
			if (this._posInVBData+(2 *Slices+2)*this._floatSizePerVer > this._vbData.length || this._posInIBData+6 *Slices > this._ibData.length)
				this.flush();
			this._tempUint0=this._posInVBData;
			this._tempUint1=this._posInVBData / this._floatSizePerVer;
			this._tempNumver0=Math.PI *2 / Slices;
			this.addVertexIndex(0,length,0,r,g,b,a,this._tempUint0);
			this.addVertexIndex(0,0,0,r,g,b,a,this._tempUint0+this._floatSizePerVer);
			this._tempInt0=2;
			this._tempNumver1=0;
			for (this._tempInt1=0;this._tempInt1 < Slices;this._tempInt1++){
				this._tempNumver2=Math.cos(this._tempNumver1);
				this._tempNumver3=Math.sin(this._tempNumver1);
				this.addVertexIndex(radius *this._tempNumver2,0,radius *this._tempNumver3,r,g,b,a,this._tempUint0+this._tempInt0 *this._floatSizePerVer);
				this.addIndexes(this._tempUint1,this._tempUint1+this._tempInt0);
				if (this._tempInt1==Slices-1)
					this.addIndexes(this._tempUint1+2);
				else
				this.addIndexes(this._tempUint1+this._tempInt0+1);
				this.addVertexIndex(radius *this._tempNumver2,0,radius *this._tempNumver3,r,g,b,a,this._tempUint0+(this._tempInt0+Slices)*this._floatSizePerVer);
				this.addIndexes(this._tempUint1+1);
				if (this._tempInt1==Slices-1)
					this.addIndexes(this._tempUint1+Slices+2);
				else
				this.addIndexes(this._tempUint1+this._tempInt0+Slices+1);
				this.addIndexes(this._tempUint1+this._tempInt0+Slices);
				this._tempInt0++;
				this._tempNumver1+=this._tempNumver0;
			}
			return this;
		}

		__proto.boundingBoxLine=function(minX,minY,minZ,maxX,maxY,maxZ,r,g,b,a){
			if (!this._hasBegun || this._primitiveType!==0x0001)
				this.drawLinesException();
			if (this._posInVBData+8 *this._floatSizePerVer > this._vbData.length || this._posInIBData+48 > this._ibData.length)
				this.flush();
			this._tempUint0=this._posInVBData / this._floatSizePerVer;
			this.addVertex(minX,maxY,maxZ,r,g,b,a);
			this.addVertex(maxX,maxY,maxZ,r,g,b,a);
			this.addVertex(minX,minY,maxZ,r,g,b,a);
			this.addVertex(maxX,minY,maxZ,r,g,b,a);
			this.addVertex(maxX,maxY,minZ,r,g,b,a);
			this.addVertex(minX,maxY,minZ,r,g,b,a);
			this.addVertex(maxX,minY,minZ,r,g,b,a);
			this.addVertex(minX,minY,minZ,r,g,b,a);
			this._tempUint1=this._tempUint0+1;
			this._tempUint2=this._tempUint0+2;
			this._tempUint3=this._tempUint0+3;
			this._tempUint4=this._tempUint0+4;
			this._tempUint5=this._tempUint0+5;
			this._tempUint6=this._tempUint0+6;
			this._tempUint7=this._tempUint0+7;
			this.addIndexes(this._tempUint0,this._tempUint1,this._tempUint1,this._tempUint3,this._tempUint3,this._tempUint2,this._tempUint2,this._tempUint0,
			this._tempUint4,this._tempUint5,this._tempUint5,this._tempUint7,this._tempUint7,this._tempUint6,this._tempUint6,this._tempUint4,
			this._tempUint5,this._tempUint0,this._tempUint0,this._tempUint2,this._tempUint2,this._tempUint7,this._tempUint7,this._tempUint5,
			this._tempUint1,this._tempUint4,this._tempUint4,this._tempUint6,this._tempUint6,this._tempUint3,this._tempUint3,this._tempUint1,
			this._tempUint5,this._tempUint4,this._tempUint4,this._tempUint1,this._tempUint1,this._tempUint0,this._tempUint0,this._tempUint5,
			this._tempUint2,this._tempUint3,this._tempUint3,this._tempUint6,this._tempUint6,this._tempUint7,this._tempUint7,this._tempUint2);
			return this;
		}

		__proto.addVertex=function(x,y,z,r,g,b,a){
			if (!this._hasBegun)
				this.addVertexIndexException();
			this._vbData[this._posInVBData]=x,this._vbData[this._posInVBData+1]=y,this._vbData[this._posInVBData+2]=z;
			this._vbData[this._posInVBData+3]=r,this._vbData[this._posInVBData+4]=g,this._vbData[this._posInVBData+5]=b,this._vbData[this._posInVBData+6]=a;
			this._posInVBData+=this._floatSizePerVer;
			return this;
		}

		__proto.addVertexIndex=function(x,y,z,r,g,b,a,index){
			if (!this._hasBegun)
				this.addVertexIndexException();
			this._vbData[index]=x,this._vbData[index+1]=y,this._vbData[index+2]=z;
			this._vbData[index+3]=r,this._vbData[index+4]=g,this._vbData[index+5]=b,this._vbData[index+6]=a;
			index+=this._floatSizePerVer;
			if (index > this._posInVBData)
				this._posInVBData=index;
			return this;
		}

		__proto.addIndexes=function(__indexes){
			var indexes=arguments;
			if (!this._hasBegun)
				this.addVertexIndexException();
			for (var i=0;i < indexes.length;i++){
				this._ibData[this._posInIBData]=indexes[i];
				this._posInIBData++;
			}
			return this;
		}

		__proto.begin=function(primitive,wvpMatrix,renState){
			if (this._hasBegun)
				this.beginException0();
			if (primitive!==0x0001 && primitive!==0x0004)
				this.beginException1();
			this._primitiveType=primitive;
			this._wvpMatrix=wvpMatrix;
			this._renderState=renState;
			this._hasBegun=true;
			return this;
		}

		__proto.end=function(){
			if (!this._hasBegun)
				this.endException();
			this.flush();
			this._hasBegun=false;
			return this;
		}

		__proto.flush=function(){
			if (this._posInVBData===0)
				return;
			this._ib.clear();
			this._ib.append(this._ibData);
			this._vb.clear();
			this._vb.append(this._vbData);
			this._vb.bind_upload(this._ib);
			var presz=this._renderState.shaderValue.length;
			var predef=this._renderState.shaderDefs.getValue();
			this._shader=this.getShader(this._renderState);
			this._renderState.shaderValue.pushValue("POSITION",this._posShaderValue);
			this._renderState.shaderValue.pushValue("COLOR",this._colorShaderValue);
			this._renderState.shaderValue.pushValue("MVPMATRIX",this._wvpMatrix.elements);
			this._renderState.shaderValue.pushValue("ALBEDO",this._albedo.elements);
			this._shader.uploadArray(this._renderState.shaderValue.data,this._renderState.shaderValue.length,null);
			this._renderState.shaderDefs.setValue(predef);
			this._renderState.shaderValue.length=presz;
			Stat.drawCall++;
			WebGL.mainContext.drawElements(this._primitiveType,this._posInIBData,0x1403,0);
			this._posInIBData=0;
			this._posInVBData=0;
		}

		__proto.getShader=function(state){
			var preDef=state.shaderDefs._value;
			state.shaderDefs._value=preDef & (~(0x80 | 0x100 | 0x40));
			state.shaderDefs.add(0x20);
			var nameID=state.shaderDefs.getValue()+this._sharderNameID *0.0002;
			var shader=this._shader ? this._shader :Shader.getShader(nameID);
			return shader || (shader=Shader.withCompile(this._sharderNameID,state.shaderDefs.toNameDic(),nameID,null));
		}

		__proto.addVertexIndexException=function(){
			throw new Error("请先调用begin()函数");
		}

		__proto.beginException0=function(){
			throw new Error("调用begin()前请确保已成功调用end()！");
		}

		__proto.beginException1=function(){
			throw new Error("只支持“LINES”和“TRIANGLES”两种基元！");
		}

		__proto.endException=function(){
			throw new Error("调用end()前请确保已成功调用begin()！");
		}

		__proto.drawLinesException=function(){
			throw new Error("您必须确保在此之前已调用begin()且使用“LINES”基元！");
		}

		__proto.drawTrianglesException=function(){
			throw new Error("您必须确保在此之前已调用begin()且使用“TRIANGLES”基元！");
		}

		return PhasorSpriter3D;
	})()


	/**
	*<code>RenderConfig</code> 类用于实现渲染配置。
	*/
	//class laya.d3.core.render.RenderConfig
	var RenderConfig=(function(){
		function RenderConfig(){
			this.depthTest=true;
			this.depthMask=1;
			this.blend=false;
			this.cullFace=true;
			this.sFactor=1;
			this.dFactor=0;
			this.frontFace=0x0900;
		}

		__class(RenderConfig,'laya.d3.core.render.RenderConfig');
		return RenderConfig;
	})()


	/**
	*@private
	*<code>RenderElement</code> 类用于实现渲染物体。
	*/
	//class laya.d3.core.render.RenderElement
	var RenderElement=(function(){
		function RenderElement(){
			this._type=0;
			this._mainSortID=0;
			this._renderObject=null;
			this._sprite3D=null;
			this._material=null;
			this._renderObj=null;
			this._staticBatch=null;
			this._batchIndexStart=0;
			this._batchIndexEnd=0;
		}

		__class(RenderElement,'laya.d3.core.render.RenderElement');
		var __proto=RenderElement.prototype;
		/**
		*@private
		*/
		__proto.getStaticBatchBakedVertexs=function(index){
			var byteSizeInFloat=4;
			var vb=this._renderObj._getVertexBuffer(index);
			var bakedVertexes=vb.getData().slice();
			var vertexDeclaration=vb.vertexDeclaration;
			var positionOffset=vertexDeclaration.getVertexElementByUsage("POSITION").offset / byteSizeInFloat;
			var normalOffset=vertexDeclaration.getVertexElementByUsage("NORMAL").offset / byteSizeInFloat;
			var rootTransform=this._staticBatch._rootSprite.transform.worldMatrix;
			var transform=this._sprite3D.transform.worldMatrix;
			var rootInvertMat=RenderElement._tempMatrix4x40;
			var result=RenderElement._tempMatrix4x41;
			rootTransform.invert(rootInvertMat);
			Matrix4x4.multiply(rootInvertMat,transform,result);
			var rotation=RenderElement._tempQuaternion0;
			result.decompose(RenderElement._tempVector30,rotation,RenderElement._tempVector31);
			var vertexFloatCount=vertexDeclaration.vertexStride / byteSizeInFloat;
			for (var i=0,n=bakedVertexes.length;i < n;i+=vertexFloatCount){
				var posOffset=i+positionOffset;
				var norOffset=i+normalOffset;
				Utils3D.transformVector3ArrayToVector3ArrayCoordinate(bakedVertexes,posOffset,result,bakedVertexes,posOffset);
				Utils3D.transformVector3ArrayByQuat(bakedVertexes,normalOffset,rotation,bakedVertexes,normalOffset);
			}
			return bakedVertexes;
		}

		/**
		*@private
		*/
		__proto.getDynamicBatchBakedVertexs=function(index){
			var byteSizeInFloat=4;
			var vb=this._renderObj._getVertexBuffer(index);
			var bakedVertexes=vb.getData().slice();
			var vertexDeclaration=vb.vertexDeclaration;
			var positionOffset=vertexDeclaration.getVertexElementByUsage("POSITION").offset / byteSizeInFloat;
			var normalOffset=vertexDeclaration.getVertexElementByUsage("NORMAL").offset / byteSizeInFloat;
			var transform=this._sprite3D.transform;
			var worldMatrix=transform.worldMatrix;
			var rotation=transform.rotation;
			var vertexFloatCount=vertexDeclaration.vertexStride / byteSizeInFloat;
			for (var i=0,n=bakedVertexes.length;i < n;i+=vertexFloatCount){
				var posOffset=i+positionOffset;
				var norOffset=i+normalOffset;
				Utils3D.transformVector3ArrayToVector3ArrayCoordinate(bakedVertexes,posOffset,worldMatrix,bakedVertexes,posOffset);
				Utils3D.transformVector3ArrayByQuat(bakedVertexes,normalOffset,rotation,bakedVertexes,normalOffset);
			}
			return bakedVertexes;
		}

		/**
		*@private
		*/
		__proto.getBakedIndices=function(){
			return this._renderObj._getIndexBuffer().getData();
		}

		__getset(0,__proto,'renderObj',function(){
			return this._renderObj;
			},function(value){
			if (this._renderObj!==value){
				this._renderObj=value;
			}
		});

		__static(RenderElement,
		['_tempVector30',function(){return this._tempVector30=new Vector3();},'_tempVector31',function(){return this._tempVector31=new Vector3();},'_tempQuaternion0',function(){return this._tempQuaternion0=new Quaternion();},'_tempMatrix4x40',function(){return this._tempMatrix4x40=new Matrix4x4();},'_tempMatrix4x41',function(){return this._tempMatrix4x41=new Matrix4x4();}
		]);
		return RenderElement;
	})()


	/**
	*@private
	*<code>RenderQuene</code> 类用于实现渲染队列。
	*/
	//class laya.d3.core.render.RenderQueue
	var RenderQueue=(function(){
		function RenderQueue(renderConfig,scene){
			this._id=0;
			this._needSort=false;
			this._renderElements=null;
			this._staticBatches=null;
			this._renderableRenderObjects=null;
			this._renderConfig=null;
			this._staticBatchCombineRenderElements=null;
			this._dynamicBatchCombineRenderElements=null;
			this._finalElements=null;
			this._scene=null;
			this._id=++RenderQueue._uniqueIDCounter;
			this._needSort=false;
			this._renderConfig=renderConfig;
			this._scene=scene;
			this._renderElements=[];
			this._renderableRenderObjects=[];
			this._staticBatchCombineRenderElements=[];
			this._dynamicBatchCombineRenderElements=[];
			this._staticBatches=[];
		}

		__class(RenderQueue,'laya.d3.core.render.RenderQueue');
		var __proto=RenderQueue.prototype;
		__proto._sortAlphaFunc=function(a,b){
			if (a._renderObject && b._renderObject)
				return Vector3.distance(b._renderObject._boundingSphere.center,RenderQueue._cameraPosition)-Vector3.distance(a._renderObject._boundingSphere.center,RenderQueue._cameraPosition);
			else
			return 0;
		}

		/**
		*@private
		*/
		__proto._begainRenderElement=function(state,renderObj,material){
			if (renderObj._beforeRender(state)){
				state.shaderValue.pushArray(renderObj._getVertexBuffer(0).vertexDeclaration.shaderValues);
				return true;
			}
			return false;
		}

		/**
		*@private
		*/
		__proto._endRenderElement=function(state,renderObj,material){
			material._upload(state,renderObj._getVertexBuffer(0).vertexDeclaration,null);
			renderObj._render(state);
		}

		/**
		*@private
		*更新组件preRenderUpdate函数
		*@param state 渲染相关状态
		*/
		__proto._preRenderUpdateComponents=function(sprite3D,state){
			for (var i=0;i < sprite3D.componentsCount;i++){
				var component=sprite3D.getComponentByIndex(i);
				(!component.started)&& (component._start(state),component.started=true);
				(component.isActive)&& (component._preRenderUpdate(state));
			}
		}

		/**
		*@private
		*更新组件postRenderUpdate函数
		*@param state 渲染相关状态
		*/
		__proto._postRenderUpdateComponents=function(sprite3D,state){
			for (var i=0;i < sprite3D.componentsCount;i++){
				var component=sprite3D.getComponentByIndex(i);
				(!component.started)&& (component._start(state),component.started=true);
				(component.isActive)&& (component._postRenderUpdate(state));
			}
		}

		/**
		*@private
		*/
		__proto._sortAlpha=function(cameraPos){
			RenderQueue._cameraPosition=cameraPos;
			this._finalElements.sort(this._sortAlphaFunc);
		}

		/**
		*@private
		*应用渲染状态到显卡。
		*@param gl WebGL上下文。
		*/
		__proto._setState=function(gl,state){
			WebGLContext.setDepthTest(gl,this._renderConfig.depthTest);
			WebGLContext.setDepthMask(gl,this._renderConfig.depthMask);
			WebGLContext.setBlend(gl,this._renderConfig.blend);
			WebGLContext.setBlendFunc(gl,this._renderConfig.sFactor,this._renderConfig.dFactor);
			WebGLContext.setCullFace(gl,this._renderConfig.cullFace);
			if (state.camera.renderTarget)
				WebGLContext.setFrontFaceCCW(gl,this._renderConfig.frontFace===0x0900 ? 0x0901 :0x0900);
			else
			WebGLContext.setFrontFaceCCW(gl,this._renderConfig.frontFace);
		}

		/**
		*@private
		*准备渲染队列。
		*@param state 渲染状态。
		*/
		__proto._preRender=function(state){
			this._staticBatchCombineRenderElements.length=0;
			for (var i=0,n=this._staticBatches.length;i < n;i++)
			this._staticBatches[i]._getRenderElement(this._staticBatchCombineRenderElements);
			this._finalElements=this._renderElements.concat(this._staticBatchCombineRenderElements,this._dynamicBatchCombineRenderElements);
		}

		/**
		*@private
		*渲染队列。
		*@param state 渲染状态。
		*/
		__proto._render=function(state){
			var preShaderValue=state.shaderValue.length;
			var preShadeDef=state.shaderDefs.getValue();
			for (var i=0,n=this._finalElements.length;i < n;i++){
				var renderElement=this._finalElements[i];
				var renderObj,material;
				if (renderElement._type===0){
					var owner=renderElement._sprite3D;
					state.owner=owner;
					state.renderElement=renderElement;
					this._preRenderUpdateComponents(owner,state);
					renderObj=renderElement.renderObj,material=renderElement._material;
					if (this._begainRenderElement(state,renderObj,material)){
						material._setLoopShaderParams(state,state.projectionViewMatrix,owner.transform.worldMatrix,renderElement.renderObj,material);
						this._endRenderElement(state,renderObj,material);
					}
					this._postRenderUpdateComponents(owner,state);
					}else if (renderElement._type===1){
					var staticBatch=renderElement.renderObj;
					state.owner=null;
					state.renderElement=renderElement;
					state._batchIndexStart=renderElement._batchIndexStart;
					state._batchIndexEnd=renderElement._batchIndexEnd;
					renderObj=renderElement.renderObj,material=renderElement._material;
					if (this._begainRenderElement(state,renderObj,material)){
						renderElement._material._setLoopShaderParams(state,state.projectionViewMatrix,staticBatch._rootSprite.transform.worldMatrix,renderElement.renderObj,renderElement._material);
						this._endRenderElement(state,renderObj,material);
					}
					}else if (renderElement._type===2){
					var dynamicBatch=renderElement.renderObj;
					state.owner=null;
					state.renderElement=renderElement;
					state._batchIndexStart=renderElement._batchIndexStart;
					state._batchIndexEnd=renderElement._batchIndexEnd;
					renderObj=renderElement.renderObj,material=renderElement._material;
					if (this._begainRenderElement(state,renderObj,material)){
						renderElement._material._setLoopShaderParams(state,state.projectionViewMatrix,Matrix4x4.DEFAULT,renderElement.renderObj,renderElement._material);
						this._endRenderElement(state,renderObj,material);
					}
				}
				state.shaderDefs.setValue(preShadeDef);
				state.shaderValue.length=preShaderValue;
			}
		}

		/**
		*清空队列中的渲染物体。
		*/
		__proto._clearRenderElements=function(){
			this._staticBatches.length=0;
			this._dynamicBatchCombineRenderElements.length=0;
			this._renderElements.length=0;
			this._needSort=true;
		}

		/**
		*添加渲染物体。
		*@param renderObj 渲染物体。
		*/
		__proto._addRenderElement=function(renderElement){
			this._renderElements.push(renderElement);
			this._needSort=true;
		}

		/**
		*添加静态批处理。
		*@param renderObj 静态批处理。
		*/
		__proto._addStaticBatch=function(staticBatch){
			this._staticBatches.push(staticBatch)
		}

		/**
		*添加动态批处理。
		*@param renderObj 动态批处理。
		*/
		__proto._addDynamicBatchElement=function(dynamicBatchElement){
			this._dynamicBatchCombineRenderElements.push(dynamicBatchElement);
		}

		/**
		*获取唯一标识ID(通常用于优化或识别)。
		*/
		__getset(0,__proto,'id',function(){
			return this._id;
		});

		RenderQueue._uniqueIDCounter=0;
		RenderQueue.OPAQUE=1;
		RenderQueue.OPAQUE_DOUBLEFACE=2;
		RenderQueue.ALPHA_BLEND=3;
		RenderQueue.ALPHA_BLEND_DOUBLEFACE=4;
		RenderQueue.ALPHA_ADDTIVE_BLEND=5;
		RenderQueue.ALPHA_ADDTIVE_BLEND_DOUBLEFACE=6;
		RenderQueue.DEPTHREAD_ALPHA_BLEND=7;
		RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE=8;
		RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND=9;
		RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE=10;
		RenderQueue.NONDEPTH_ALPHA_BLEND=11;
		RenderQueue.NONDEPTH_ALPHA_BLEND_DOUBLEFACE=12;
		RenderQueue.NONDEPTH_ALPHA_ADDTIVE_BLEND=13;
		RenderQueue.NONDEPTH_ALPHA_ADDTIVE_BLEND_DOUBLEFACE=14;
		RenderQueue._cameraPosition=null
		return RenderQueue;
	})()


	/**
	*<code>RenderState</code> 类用于实现渲染状态。
	*/
	//class laya.d3.core.render.RenderState
	var RenderState=(function(){
		function RenderState(){
			this.elapsedTime=NaN;
			this.loopCount=0;
			this.context=null;
			this.scene=null;
			this.owner=null;
			this.renderElement=null;
			this._staticBatch=null;
			this._batchIndexStart=0;
			this._batchIndexEnd=0;
			this.camera=null;
			this.viewMatrix=null;
			this.projectionMatrix=null;
			this.projectionViewMatrix=null;
			this.cameraBoundingFrustum=null;
			this.viewport=null;
			this.worldShaderValue=new ValusArray;
			this.shaderValue=new ValusArray;
			this.shaderDefs=new ShaderDefines3D();
			this.reset();
		}

		__class(RenderState,'laya.d3.core.render.RenderState');
		var __proto=RenderState.prototype;
		/**
		*重置。
		*/
		__proto.reset=function(){
			this.worldShaderValue.length=0;
			this.shaderValue.length=0;
			this.shaderDefs.setValue(0);
			(WebGL.frameShaderHighPrecision)&& (this.shaderDefs.setValue(0x100000));
		}

		RenderState.VERTEXSHADERING=0x04;
		RenderState.PIXELSHADERING=0x08;
		RenderState.clientWidth=0;
		RenderState.clientHeight=0;
		return RenderState;
	})()


	/**
	*@private
	*<code>DynamicBatch</code> 类用于动态批处理。
	*/
	//class laya.d3.graphics.DynamicBatch
	var DynamicBatch=(function(){
		function DynamicBatch(vertexDeclaration){
			this._vertexDeclaration=null;
			this._vertexDatas=null;
			this._indexDatas=null;
			this._vertexBuffer=null;
			this._indexBuffer=null;
			this._currentCombineVertexCount=0;
			this._currentCombineIndexCount=0;
			this._combineRenderElements=null;
			this._materials=null;
			this._materialToRenderElementsOffsets=null;
			this._merageElements=null;
			this._combineRenderElementPool=null;
			this._combineRenderElementPoolIndex=0;
			this._currentCombineVertexCount=0;
			this._currentCombineIndexCount=0;
			this._combineRenderElements=[];
			this._materialToRenderElementsOffsets=[];
			this._materials=[];
			this._merageElements=[];
			this._combineRenderElementPool=[];
			this._combineRenderElementPoolIndex=0;
			this._vertexDeclaration=vertexDeclaration;
		}

		__class(DynamicBatch,'laya.d3.graphics.DynamicBatch');
		var __proto=DynamicBatch.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IRenderable":true})
		__proto._getVertexBuffer=function(index){
			(index===void 0)&& (index=0);
			if (index===0)
				return this._vertexBuffer;
			else
			return null;
		}

		__proto._getIndexBuffer=function(){
			return this._indexBuffer;
		}

		__proto._testTangent=function(state){}
		//}
		__proto._getCombineRenderElementFromPool=function(){
			var renderElement=this._combineRenderElementPool[this._combineRenderElementPoolIndex++];
			return renderElement || (this._combineRenderElementPool[this._combineRenderElementPoolIndex-1]=new RenderElement());
		}

		__proto._getRenderElement=function(){
			if (!this._vertexDatas){
				this._vertexDatas=new Float32Array(this._vertexDeclaration.vertexStride / 4 *DynamicBatch.maxVertexCount);
				this._indexDatas=new Uint16Array(DynamicBatch.maxIndexCount);
				this._vertexBuffer=VertexBuffer3D.create(this._vertexDeclaration,DynamicBatch.maxVertexCount,0x88E8);
				this._indexBuffer=IndexBuffer3D.create("ushort",DynamicBatch.maxIndexCount,0x88E8);
			}
			this._merageElements.length=0;
			var curMerVerCount=0;
			var curIndexCount=0;
			for (var i=0,n=this._combineRenderElements.length;i < n;i++){
				var renderElement=this._combineRenderElements[i];
				var subVertexDatas=renderElement.getDynamicBatchBakedVertexs(0);
				var subIndexDatas=renderElement.getBakedIndices();
				var indexOffset=curMerVerCount / (this._vertexDeclaration.vertexStride / 4);
				var indexStart=curIndexCount;
				var indexEnd=indexStart+subIndexDatas.length;
				renderElement._batchIndexStart=indexStart;
				renderElement._batchIndexEnd=indexEnd;
				this._indexDatas.set(subIndexDatas,curIndexCount);
				for (var k=indexStart;k < indexEnd;k++)
				this._indexDatas[k]=indexOffset+this._indexDatas[k];
				curIndexCount+=subIndexDatas.length;
				this._vertexDatas.set(subVertexDatas,curMerVerCount);
				curMerVerCount+=subVertexDatas.length;
			}
			this._vertexBuffer.setData(this._vertexDatas);
			this._indexBuffer.setData(this._indexDatas);
			this._combineRenderElementPoolIndex=0;
			for (i=0,n=this._materials.length;i < n;i++){
				var merageElement=this._getCombineRenderElementFromPool();
				merageElement._type=2;
				merageElement._staticBatch=null;
				merageElement.renderObj=this;
				var renderElementStartIndex=this._combineRenderElements[this._materialToRenderElementsOffsets[i]]._batchIndexStart;
				var renderElementEndIndex=(i+1===this._materialToRenderElementsOffsets.length)? curIndexCount :this._combineRenderElements[this._materialToRenderElementsOffsets[i+1]]._batchIndexStart;
				merageElement._batchIndexStart=renderElementStartIndex;
				merageElement._batchIndexEnd=renderElementEndIndex;
				merageElement._material=this._materials[i];
				this._merageElements.push(merageElement);
			}
		}

		__proto._addCombineRenderObjTest=function(renderElement){
			var renderObj=renderElement.renderObj;
			var indexCount=this._currentCombineIndexCount+renderObj._getIndexBuffer().indexCount;
			var vertexCount=this._currentCombineVertexCount+renderObj._getVertexBuffer().vertexCount;
			if (vertexCount > DynamicBatch.maxVertexCount || indexCount > DynamicBatch.maxIndexCount){
				return false;
			}
			return true;
		}

		__proto._addCombineRenderObj=function(renderElement){
			var renderObj=renderElement.renderObj;
			this._combineRenderElements.push(renderElement);
			this._currentCombineIndexCount=this._currentCombineIndexCount+renderObj._getIndexBuffer().indexCount;
			this._currentCombineVertexCount=this._currentCombineVertexCount+renderObj._getVertexBuffer().vertexCount;
		}

		__proto._addCombineMaterial=function(material){
			this._materials.push(material);
		}

		__proto._addMaterialToRenderElementOffset=function(offset){
			this._materialToRenderElementsOffsets.push(offset);
		}

		__proto._clearRenderElements=function(){
			this._combineRenderElements.length=0;
			this._materials.length=0;
			this._materialToRenderElementsOffsets.length=0;
			this._currentCombineVertexCount=0;
			this._currentCombineIndexCount=0;
		}

		__proto._addToRenderQueue=function(scene){
			this._getRenderElement();
			for (var i=0,n=this._materials.length;i < n;i++)
			scene.getRenderQueue(this._materials[i].renderQueue)._addDynamicBatchElement(this._merageElements[i]);
		}

		__proto._beforeRender=function(state){
			this._vertexBuffer._bind();
			this._indexBuffer._bind();
			return true;
		}

		__proto._render=function(state){
			var indexCount=state._batchIndexEnd-state._batchIndexStart;
			state.context.drawElements(0x0004,indexCount,0x1403,state._batchIndexStart *2);
			Stat.drawCall++;
			Stat.trianglesFaces+=indexCount / 3;
		}

		__getset(0,__proto,'indexOfHost',function(){
			return 0;
		});

		__getset(0,__proto,'_vertexBufferCount',function(){
			return 1;
		});

		__getset(0,__proto,'combineRenderElementsCount',function(){
			return this._combineRenderElements.length;
		});

		__getset(0,__proto,'triangleCount',function(){
			return this._indexBuffer.indexCount / 3;
		});

		DynamicBatch.maxVertexCount=20000;
		DynamicBatch.maxIndexCount=40000;
		DynamicBatch.maxCombineTriangleCount=50;
		return DynamicBatch;
	})()


	/**
	*@private
	*<code>DynamicBatchManager</code> 类用于管理动态批处理。
	*/
	//class laya.d3.graphics.DynamicBatchManager
	var DynamicBatchManager=(function(){
		function DynamicBatchManager(){
			this._dynamicBatches=null;
			this._prepareDynamicBatchCombineElements=null;
			this._dynamicBatches={};
			this._prepareDynamicBatchCombineElements=[];
		}

		__class(DynamicBatchManager,'laya.d3.graphics.DynamicBatchManager');
		var __proto=DynamicBatchManager.prototype;
		__proto.getDynamicBatch=function(_vertexDeclaration,number){
			var dynamicBatch;
			var key=_vertexDeclaration.id.toString()+number;
			if (!this._dynamicBatches[key]){
				this._dynamicBatches[key]=dynamicBatch=new DynamicBatch(_vertexDeclaration);
				}else {
				dynamicBatch=this._dynamicBatches[key];
			}
			return dynamicBatch;
		}

		/**需手动调用*/
		__proto._garbageCollection=function(){
			for (var key in this._dynamicBatches)
			if (this._dynamicBatches[key].combineRenderElementsCount===0)
				delete this._dynamicBatches[key];
		}

		__proto._addPrepareRenderElement=function(renderElement){
			this._prepareDynamicBatchCombineElements.push(renderElement);
		}

		/**@private */
		__proto._finishCombineDynamicBatch=function(scene){
			this._prepareDynamicBatchCombineElements.sort(DynamicBatchManager._sortPrepareDynamicBatch);
			var lastMaterial;
			var lastVertexDeclaration;
			var lastRenderElement;
			var lastBatchNumber=-1;
			var lastCanMerage=true;
			var curMaterial;
			var curRenderElement;
			var curDynamicBatch;
			var curbatchNumber=0;
			var laterAddMaterial;
			var laterAddRenderElement;
			var laterAddMatToElementOffset=-1;
			for (var i=0,n=this._prepareDynamicBatchCombineElements.length;i < n;i++){
				curRenderElement=this._prepareDynamicBatchCombineElements[i];
				var curDeclaration=curRenderElement.renderObj._getVertexBuffer(0).vertexDeclaration;
				var declarationChanged=(lastVertexDeclaration!==curDeclaration);
				declarationChanged && (curbatchNumber=0,lastVertexDeclaration=curDeclaration);
				var batchNumbrChanged=(curbatchNumber!==lastBatchNumber);
				batchNumbrChanged && (lastBatchNumber=curbatchNumber);
				if ((declarationChanged)|| batchNumbrChanged){
					curDynamicBatch=this.getDynamicBatch(curDeclaration,curbatchNumber);
					lastMaterial=null;
				}
				if (lastCanMerage){
					if (curDynamicBatch._addCombineRenderObjTest(curRenderElement)){
						curMaterial=curRenderElement._material;
						if (lastMaterial!==curMaterial){
							if (laterAddMaterial){
								scene.getRenderQueue(laterAddRenderElement._material.renderQueue)._addRenderElement(laterAddRenderElement);
								laterAddMaterial=null;
								laterAddRenderElement=null;
								laterAddMatToElementOffset=-1;
							}
							laterAddMaterial=curMaterial;
							laterAddMatToElementOffset=curDynamicBatch.combineRenderElementsCount;
							laterAddRenderElement=curRenderElement;
							lastMaterial=curMaterial;
							}else {
							if (laterAddMaterial){
								var lastRenderObj=laterAddRenderElement.renderObj;
								var curRenderObj=curRenderElement.renderObj;
								if (((lastRenderObj._getVertexBuffer().vertexCount+curRenderObj._getVertexBuffer().vertexCount)> DynamicBatch.maxVertexCount)|| ((lastRenderObj._getIndexBuffer().indexCount+curRenderObj._getIndexBuffer().indexCount)> DynamicBatch.maxIndexCount)){
									scene.getRenderQueue(laterAddRenderElement._material.renderQueue)._addRenderElement(laterAddRenderElement);
									laterAddMaterial=curMaterial;
									laterAddMatToElementOffset=curDynamicBatch.combineRenderElementsCount;
									laterAddRenderElement=curRenderElement;
									}else {
									curDynamicBatch._addCombineMaterial(laterAddMaterial);
									curDynamicBatch._addMaterialToRenderElementOffset(laterAddMatToElementOffset);
									curDynamicBatch._addCombineRenderObj(laterAddRenderElement);
									laterAddMaterial=null;
									laterAddRenderElement=null;
									laterAddMatToElementOffset=-1;
									curDynamicBatch._addCombineRenderObj(curRenderElement);
								}
								}else {
								curDynamicBatch._addCombineRenderObj(curRenderElement);
							}
						}
						lastCanMerage=true;
						}else {
						if (laterAddMaterial){
							scene.getRenderQueue(laterAddRenderElement._material.renderQueue)._addRenderElement(laterAddRenderElement);
							laterAddMaterial=null;
							laterAddRenderElement=null;
							laterAddMatToElementOffset=-1;
						}
						curbatchNumber++;
						lastCanMerage=false;
					}
					}else {
					lastRenderElement=this._prepareDynamicBatchCombineElements[i-1];
					curDynamicBatch._addMaterialToRenderElementOffset(curDynamicBatch.combineRenderElementsCount);
					lastMaterial=lastRenderElement._material;
					curDynamicBatch._addCombineMaterial(lastMaterial);
					curDynamicBatch._addCombineRenderObj(lastRenderElement);
					lastCanMerage=true;
					curMaterial=curRenderElement._material;
					if (lastMaterial!==curMaterial){
						laterAddMaterial=curMaterial;
						laterAddMatToElementOffset=curDynamicBatch.combineRenderElementsCount;
						laterAddRenderElement=curRenderElement;
						}else {
						curDynamicBatch._addCombineRenderObj(curRenderElement);
					}
					lastMaterial=curMaterial;
				}
			}
			if (laterAddMaterial){
				scene.getRenderQueue(laterAddRenderElement._material.renderQueue)._addRenderElement(laterAddRenderElement);
				laterAddMaterial=null;
				laterAddRenderElement=null;
				laterAddMatToElementOffset=-1;
			}
			this._prepareDynamicBatchCombineElements.length=0;
		}

		__proto._clearRenderElements=function(){
			for (var key in this._dynamicBatches)
			this._dynamicBatches[key]._clearRenderElements();
		}

		__proto._addToRenderQueue=function(scene){
			for (var key in this._dynamicBatches){
				var dynamicBatch=this._dynamicBatches[key];
				(dynamicBatch.combineRenderElementsCount > 0)&& (dynamicBatch._addToRenderQueue(scene));
			}
		}

		__proto.dispose=function(){
			this._dynamicBatches=null;
		}

		DynamicBatchManager._sortPrepareDynamicBatch=function(a,b){
			return a._mainSortID-b._mainSortID;
		}

		return DynamicBatchManager;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.d3.graphics.FrustumCulling
	var FrustumCulling=(function(){
		function FrustumCulling(){}
		__class(FrustumCulling,'laya.d3.graphics.FrustumCulling');
		FrustumCulling.RenderObjectCulling=function(boundFrustum,scene){
			var i=0,iNum=0,j=0,jNum=0;
			var frustumCullingObject;
			var renderElement;
			var curRenderQueue;
			var queues=scene._quenes;
			var staticBatchMananger=scene._staticBatchManager;
			var dynamicBatchManager=scene._dynamicBatchManager;
			var frustumCullingObjects=scene._frustumCullingObjects;
			for (i=0,iNum=queues.length;i < iNum;i++)
			(queues[i])&& (queues[i]._clearRenderElements());
			staticBatchMananger._clearRenderElements();
			dynamicBatchManager._clearRenderElements();
			for (i=0,iNum=frustumCullingObjects.length;i < iNum;i++){
				frustumCullingObject=frustumCullingObjects[i];
				if (Layer.isVisible(frustumCullingObject._layerMask)&& frustumCullingObject._ownerEnable && frustumCullingObject._enable && (boundFrustum.ContainsBoundSphere(frustumCullingObject._boundingSphere)!==0)){
					for (j=0,jNum=frustumCullingObject._renderElements.length;j < jNum;j++){
						renderElement=frustumCullingObject._renderElements[j];
						var staticBatch=renderElement._staticBatch;
						if (staticBatch && (staticBatch._material===renderElement._material)){
							staticBatch._addRenderElement(renderElement);
							}else {
							var renderObj=renderElement.renderObj;
							if ((renderObj.triangleCount < 50)&& (renderObj._vertexBufferCount===1)&& (renderObj._getIndexBuffer())&&(renderElement._material.renderQueue<3))
								dynamicBatchManager._addPrepareRenderElement(renderElement);
							else
							scene.getRenderQueue(renderElement._material.renderQueue)._addRenderElement(renderElement);
						}
					}
				}
			}
			staticBatchMananger._addToRenderQueue(scene);
			dynamicBatchManager._finishCombineDynamicBatch(scene);
			dynamicBatchManager._addToRenderQueue(scene);
		}

		return FrustumCulling;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.d3.graphics.RenderObject
	var RenderObject=(function(){
		function RenderObject(){
			this._render=null;
			this._renderElements=null;
			this._layerMask=0;
			this._ownerEnable=false;
			this._enable=false;
			this._renderElements=[];
		}

		__class(RenderObject,'laya.d3.graphics.RenderObject');
		var __proto=RenderObject.prototype;
		__getset(0,__proto,'_boundingSphere',function(){
			return this._render.boundingSphere;
		});

		return RenderObject;
	})()


	/**
	*@private
	*<code>StaticBatch</code> 类用于静态批处理。
	*/
	//class laya.d3.graphics.StaticBatch
	var StaticBatch=(function(){
		function StaticBatch(rootSprite,vertexDeclaration,material){
			this._vertexBuffer=null;
			this._indexBuffer=null;
			this._renderElements=null;
			this._combineRenderElementPool=null;
			this._combineRenderElementPoolIndex=0;
			this._combineRenderElements=null;
			this._currentCombineVertexCount=0;
			this._currentCombineIndexCount=0;
			this._needFinishCombine=false;
			this._rootSprite=null;
			this._vertexDeclaration=null;
			this._material=null;
			this._currentCombineVertexCount=0;
			this._currentCombineIndexCount=0;
			this._needFinishCombine=false;
			this._renderElements=[];
			this._combineRenderElements=[];
			this._combineRenderElementPool=[];
			this._combineRenderElementPoolIndex=0;
			this._rootSprite=rootSprite;
			this._vertexDeclaration=vertexDeclaration;
			this._material=material;
		}

		__class(StaticBatch,'laya.d3.graphics.StaticBatch');
		var __proto=StaticBatch.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IRenderable":true})
		__proto._testTangent=function(state){}
		//}
		__proto._getVertexBuffer=function(index){
			(index===void 0)&& (index=0);
			if (index===0)
				return this._vertexBuffer;
			else
			return null;
		}

		__proto._getIndexBuffer=function(){
			return this._indexBuffer;
		}

		__proto._getCombineRenderElementFromPool=function(){
			var renderElement=this._combineRenderElementPool[this._combineRenderElementPoolIndex++];
			return renderElement || (this._combineRenderElementPool[this._combineRenderElementPoolIndex-1]=new RenderElement());
		}

		__proto._addCombineRenderObjTest=function(renderElement){
			var renderObj=renderElement.renderObj;
			var vertexCount=this._currentCombineVertexCount+renderObj._getVertexBuffer().vertexCount;
			if (vertexCount > StaticBatch.maxVertexCount){
				return false;
			}
			return true;
		}

		__proto._addCombineRenderObj=function(renderElement){
			var renderObj=renderElement.renderObj;
			this._combineRenderElements.push(renderElement);
			renderElement._staticBatch=this;
			this._currentCombineIndexCount=this._currentCombineIndexCount+renderObj._getIndexBuffer().indexCount;
			this._currentCombineVertexCount=this._currentCombineVertexCount+renderObj._getVertexBuffer().vertexCount;
			this._needFinishCombine=true;
		}

		__proto._deleteCombineRenderObj=function(renderElement){
			var renderObj=renderElement.renderObj;
			var index=this._combineRenderElements.indexOf(renderElement);
			if (index!==-1){
				this._combineRenderElements.splice(index,1);
				renderElement._staticBatch=null;
				this._currentCombineIndexCount=this._currentCombineIndexCount-renderObj._getIndexBuffer().indexCount;
				this._currentCombineVertexCount=this._currentCombineVertexCount-renderObj._getVertexBuffer().vertexCount;
				this._needFinishCombine=true;
			}
		}

		__proto._finshCombine=function(){
			if (this._needFinishCombine){
				var curMerVerCount=0;
				var curIndexCount=0;
				var vertexDatas=new Float32Array(this._vertexDeclaration.vertexStride / 4 *this._currentCombineVertexCount);
				var indexDatas=new Uint16Array(this._currentCombineIndexCount);
				if (this._vertexBuffer){
					this._vertexBuffer.dispose();
					this._indexBuffer.dispose();
				}
				this._vertexBuffer=VertexBuffer3D.create(this._vertexDeclaration,this._currentCombineVertexCount,0x88E4);
				this._indexBuffer=IndexBuffer3D.create("ushort",this._currentCombineIndexCount,0x88E4);
				for (var i=0,n=this._combineRenderElements.length;i < n;i++){
					var renderElement=this._combineRenderElements[i];
					var subVertexDatas=renderElement.getStaticBatchBakedVertexs(0);
					var subIndexDatas=renderElement.getBakedIndices();
					var indexOffset=curMerVerCount / (this._vertexDeclaration.vertexStride / 4);
					var indexStart=curIndexCount;
					var indexEnd=indexStart+subIndexDatas.length;
					renderElement._batchIndexStart=indexStart;
					renderElement._batchIndexEnd=indexEnd;
					indexDatas.set(subIndexDatas,curIndexCount);
					for (var k=indexStart;k < indexEnd;k++)
					indexDatas[k]=indexOffset+indexDatas[k];
					curIndexCount+=subIndexDatas.length;
					vertexDatas.set(subVertexDatas,curMerVerCount);
					curMerVerCount+=subVertexDatas.length;
				}
				this._vertexBuffer.setData(vertexDatas);
				this._indexBuffer.setData(indexDatas);
				this._needFinishCombine=false;
			}
		}

		__proto._clearRenderElements=function(){
			this._renderElements.length=0;
		}

		__proto._addRenderElement=function(renderElement){
			for (var i=0,n=this._renderElements.length;i < n;i++){
				if (this._renderElements[i]._batchIndexStart > renderElement._batchIndexStart){
					this._renderElements.splice(i,0,renderElement);
					return;
				}
			}
			this._renderElements.push(renderElement);
		}

		__proto._getRenderElement=function(mergeElements){
			this._combineRenderElementPoolIndex=0;
			var length=this._renderElements.length;
			var merageElement=this._getCombineRenderElementFromPool();
			merageElement._type=1;
			merageElement._staticBatch=null;
			merageElement.renderObj=this;
			merageElement._batchIndexStart=this._renderElements[0]._batchIndexStart;
			merageElement._batchIndexEnd=this._renderElements[0]._batchIndexEnd;
			merageElement._material=this._material;
			merageElement._material=this._material;
			mergeElements.push(merageElement);
			if (length > 1){
				for (var i=1;i < length;i++){
					var renderElement=this._renderElements[i];
					if (this._renderElements[i-1]._batchIndexEnd!==renderElement._batchIndexStart){
						merageElement=this._getCombineRenderElementFromPool();
						merageElement._type=1;
						merageElement._staticBatch=null;
						merageElement.renderObj=this;
						merageElement._batchIndexStart=renderElement._batchIndexStart;
						merageElement._batchIndexEnd=renderElement._batchIndexEnd;
						merageElement._material=this._material;
						mergeElements.push(merageElement);
						}else {
						merageElement._batchIndexEnd=renderElement._batchIndexEnd;
					}
				}
			}
		}

		__proto._addToRenderQueue=function(scene){
			(this._renderElements.length > 0)&& (scene.getRenderQueue(this._material.renderQueue)._addStaticBatch(this));
		}

		//TODO:>0移到外层
		__proto._beforeRender=function(state){
			this._vertexBuffer._bind();
			this._indexBuffer._bind();
			return true;
		}

		__proto._render=function(state){
			var indexCount=state._batchIndexEnd-state._batchIndexStart;
			state.context.drawElements(0x0004,indexCount,0x1403,state._batchIndexStart *2);
			Stat.drawCall++;
			Stat.trianglesFaces+=indexCount / 3;
		}

		__getset(0,__proto,'_vertexBufferCount',function(){
			return 1;
		});

		__getset(0,__proto,'indexOfHost',function(){
			return 0;
		});

		__getset(0,__proto,'triangleCount',function(){
			return this._indexBuffer.indexCount / 3;
		});

		StaticBatch._addToRenderQueueStaticBatch=function(scene,sprite3D){
			var i=0,n=0;
			if (((sprite3D instanceof laya.d3.core.MeshSprite3D ))&& (sprite3D.isStatic)){
				var renderElements=(sprite3D).meshRender.renderCullingObject._renderElements;
				for (i=0,n=renderElements.length;i < n;i++){
					var renderElement=renderElements[i];
					if (renderElement.renderObj._vertexBufferCount===1)
						scene._staticBatchManager._addPrepareRenderElement(renderElement);
				}
			}
			for (i=0,n=sprite3D.numChildren;i < n;i++)
			StaticBatch._addToRenderQueueStaticBatch(scene,sprite3D._childs [i]);
		}

		StaticBatch.combine=function(staticBatchRoot){
			var scene=staticBatchRoot.scene;
			if (!scene)
				throw new Error("BaseScene: staticBatchRoot is not a part of scene.");
			StaticBatch._addToRenderQueueStaticBatch(scene,staticBatchRoot);
			scene._staticBatchManager._finishCombineStaticBatch(staticBatchRoot);
		}

		StaticBatch.maxVertexCount=65535;
		return StaticBatch;
	})()


	/**
	*@private
	*<code>StaticBatchManager</code> 类用于管理静态批处理。
	*/
	//class laya.d3.graphics.StaticBatchManager
	var StaticBatchManager=(function(){
		function StaticBatchManager(){
			this._staticBatches=null;
			this._prepareStaticBatchCombineElements=null;
			this._staticBatches={};
			this._prepareStaticBatchCombineElements=[];
		}

		__class(StaticBatchManager,'laya.d3.graphics.StaticBatchManager');
		var __proto=StaticBatchManager.prototype;
		/**完成合并*/
		__proto._finshCombine=function(){
			for (var key in this._staticBatches)
			this._staticBatches[key]._finshCombine();
		}

		__proto.getStaticBatch=function(rootSprite,_vertexDeclaration,material,number){
			var staticBatch;
			var key=rootSprite.id.toString()+material.id.toString()+_vertexDeclaration.id.toString()+number;
			if (!this._staticBatches[key]){
				this._staticBatches[key]=staticBatch=new StaticBatch(rootSprite,_vertexDeclaration,material);
				}else {
				staticBatch=this._staticBatches[key];
			}
			return staticBatch;
		}

		/**@private 通常应在所有getStaticBatchQneue函数相关操作结束后执行*/
		__proto._garbageCollection=function(){
			for (var key in this._staticBatches)
			if (this._staticBatches[key].combineRenderElementsCount===0)
				delete this._staticBatches[key];
		}

		/**@private */
		__proto._addPrepareRenderElement=function(renderElement){
			this._prepareStaticBatchCombineElements.push(renderElement);
		}

		/**@private */
		__proto._finishCombineStaticBatch=function(rootSprite){
			this._prepareStaticBatchCombineElements.sort(StaticBatchManager._sortPrepareStaticBatch);
			var lastMaterial;
			var lastVertexDeclaration;
			var lastCanMerage=false;
			var curStaticBatch;
			var renderElement;
			var lastRenderObj;
			var vb;
			var oldStaticBatch;
			var batchNumber=0;
			for (var i=0,n=this._prepareStaticBatchCombineElements.length;i < n;i++){
				renderElement=this._prepareStaticBatchCombineElements[i];
				vb=renderElement.renderObj._getVertexBuffer(0);
				if ((lastVertexDeclaration===vb.vertexDeclaration)&& (lastMaterial===renderElement._material)){
					if (!lastCanMerage){
						lastRenderObj=this._prepareStaticBatchCombineElements[i-1];
						var lastRenderElement=lastRenderObj.renderObj;
						var curRenderElement=renderElement.renderObj;
						if (((lastRenderElement._getVertexBuffer().vertexCount+curRenderElement._getVertexBuffer().vertexCount)> StaticBatch.maxVertexCount)){
							lastCanMerage=false;
							}else {
							curStaticBatch=this.getStaticBatch(rootSprite,lastVertexDeclaration,lastMaterial,batchNumber);
							oldStaticBatch=lastRenderObj._staticBatch;
							(oldStaticBatch)&& (oldStaticBatch!==curStaticBatch)&& (oldStaticBatch._deleteCombineRenderObj(lastRenderObj));
							curStaticBatch._addCombineRenderObj(lastRenderObj);
							oldStaticBatch=renderElement._staticBatch;
							(oldStaticBatch)&& (oldStaticBatch!==curStaticBatch)&& (oldStaticBatch._deleteCombineRenderObj(renderElement));
							curStaticBatch._addCombineRenderObj(renderElement);
							lastCanMerage=true;
						}
						}else {
						if (!curStaticBatch._addCombineRenderObjTest(renderElement)){
							lastCanMerage=false;
							batchNumber++;
							}else {
							oldStaticBatch=renderElement._staticBatch;
							(oldStaticBatch)&& (oldStaticBatch!==curStaticBatch)&& (oldStaticBatch._deleteCombineRenderObj(renderElement));
							curStaticBatch._addCombineRenderObj(renderElement)
						}
					}
					}else {
					lastCanMerage=false;
					batchNumber=0;
				}
				lastMaterial=renderElement._material;
				lastVertexDeclaration=vb.vertexDeclaration;
			}
			this._garbageCollection();
			this._finshCombine();
			this._prepareStaticBatchCombineElements.length=0;
		}

		__proto._clearRenderElements=function(){
			for (var key in this._staticBatches)
			this._staticBatches[key]._clearRenderElements();
		}

		__proto._addToRenderQueue=function(scene){
			for (var key in this._staticBatches)
			this._staticBatches[key]._addToRenderQueue(scene);
		}

		__proto.dispose=function(){
			this._staticBatches=null;
		}

		StaticBatchManager._sortPrepareStaticBatch=function(a,b){
			var id=a._mainSortID-b._mainSortID;
			return (id===0)? (a.renderObj.triangleCount-b.renderObj.triangleCount):id;
		}

		return StaticBatchManager;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.d3.graphics.VertexDeclaration
	var VertexDeclaration=(function(){
		function VertexDeclaration(vertexStride,vertexElements){
			this._id=0;
			this._shaderValues=null;
			this._shaderDefine=0;
			this._vertexStride=0;
			this._vertexElements=null;
			this._vertexElementsDic=null;
			this._id=++VertexDeclaration._uniqueIDCounter;
			if (this._id > VertexDeclaration.maxVertexDeclaration)
				throw new Error("VertexDeclaration: VertexDeclaration count should not large than ",VertexDeclaration.maxVertexDeclaration);
			this._shaderValues=new ValusArray();
			this._vertexElementsDic={};
			this._vertexStride=vertexStride;
			this._vertexElements=vertexElements;
			for (var i=0;i < vertexElements.length;i++){
				var vertexElement=vertexElements[i];
				var attributeName=vertexElement.elementUsage;
				this._vertexElementsDic[attributeName]=vertexElement;
				var value=[VertexDeclaration._getTypeSize(vertexElement.elementFormat)/ 4,0x1406,false,this._vertexStride,vertexElement.offset];
				this._shaderValues.pushValue(attributeName,value);
				switch (attributeName){
					case "UV":
						this._shaderDefine |=0x200000;
						break ;
					case "COLOR":
						this._shaderDefine |=0x20;
						break ;
					}
			}
		}

		__class(VertexDeclaration,'laya.d3.graphics.VertexDeclaration');
		var __proto=VertexDeclaration.prototype;
		__proto.getVertexElements=function(){
			return this._vertexElements.slice();
		}

		__proto.getVertexElementByUsage=function(usage){
			return this._vertexElementsDic[usage];
		}

		__proto.unBinding=function(){}
		/**
		*获取唯一标识ID(通常用于优化或识别)。
		*@return 唯一标识ID
		*/
		__getset(0,__proto,'id',function(){
			return this._id;
		});

		__getset(0,__proto,'shaderDefine',function(){
			return this._shaderDefine;
		});

		__getset(0,__proto,'shaderValues',function(){
			return this._shaderValues;
		});

		__getset(0,__proto,'vertexStride',function(){
			return this._vertexStride;
		});

		VertexDeclaration._getTypeSize=function(format){
			switch (format){
				case "single":
					return 4;
				case "vector2":
					return 8;
				case "vector3":
					return 12;
				case "vector4":
					return 16;
				case "volor":
					return 4;
				case "byte4":
					return 4;
				case "short2":
					return 4;
				case "short4":
					return 8;
				case "normalizedshort2":
					return 4;
				case "normalizedshort4":
					return 8;
				case "halfvector2":
					return 4;
				case "halfvector4":
					return 8;
				}
			return 0;
		}

		VertexDeclaration.getVertexStride=function(vertexElements){
			var curStride=0;
			for (var i=0;i < vertexElements.Length;i++){
				var element=vertexElements[i];
				var stride=element.offset+VertexDeclaration._getTypeSize(element.elementFormat);
				if (curStride < stride){
					curStride=stride;
				}
			}
			return curStride;
		}

		VertexDeclaration._maxVertexDeclarationBit=1000;
		VertexDeclaration._uniqueIDCounter=1;
		__static(VertexDeclaration,
		['maxVertexDeclaration',function(){return this.maxVertexDeclaration=2147483647-Math.floor(2147483647 / 1000)*1000;}
		]);
		return VertexDeclaration;
	})()


	/**
	*<code>VertexElement</code> 类用于创建顶点结构分配。
	*/
	//class laya.d3.graphics.VertexElement
	var VertexElement=(function(){
		function VertexElement(offset,elementFormat,elementUsage){
			this.offset=0;
			this.elementFormat=null;
			this.elementUsage=null;
			this.offset=offset;
			this.elementFormat=elementFormat;
			this.elementUsage=elementUsage;
		}

		__class(VertexElement,'laya.d3.graphics.VertexElement');
		return VertexElement;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.d3.graphics.VertexElementFormat
	var VertexElementFormat=(function(){
		function VertexElementFormat(){};
		__class(VertexElementFormat,'laya.d3.graphics.VertexElementFormat');
		VertexElementFormat.Single="single";
		VertexElementFormat.Vector2="vector2";
		VertexElementFormat.Vector3="vector3";
		VertexElementFormat.Vector4="vector4";
		VertexElementFormat.Color="volor";
		VertexElementFormat.Byte4="byte4";
		VertexElementFormat.Short2="short2";
		VertexElementFormat.Short4="short4";
		VertexElementFormat.NormalizedShort2="normalizedshort2";
		VertexElementFormat.NormalizedShort4="normalizedshort4";
		VertexElementFormat.HalfVector2="halfvector2";
		VertexElementFormat.HalfVector4="halfvector4";
		return VertexElementFormat;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.d3.graphics.VertexElementUsage
	var VertexElementUsage=(function(){
		function VertexElementUsage(){};
		__class(VertexElementUsage,'laya.d3.graphics.VertexElementUsage');
		VertexElementUsage.POSITION0="POSITION";
		VertexElementUsage.COLOR0="COLOR";
		VertexElementUsage.TEXTURECOORDINATE0="UV";
		VertexElementUsage.NORMAL0="NORMAL";
		VertexElementUsage.BINORMAL0="BINORMAL";
		VertexElementUsage.TANGENT0="TANGENT0";
		VertexElementUsage.BLENDINDICES0="BLENDINDICES";
		VertexElementUsage.BLENDWEIGHT0="BLENDWEIGHT";
		VertexElementUsage.DEPTH0="DEPTH";
		VertexElementUsage.FOG0="FOG";
		VertexElementUsage.POINTSIZE0="POINTSIZE";
		VertexElementUsage.SAMPLE0="SAMPLE";
		VertexElementUsage.TESSELLATEFACTOR0="TESSELLATEFACTOR";
		VertexElementUsage.COLOR1="COLOR1";
		VertexElementUsage.NEXTTEXTURECOORDINATE0="NEXTUV";
		VertexElementUsage.TEXTURECOORDINATE1="UV1";
		VertexElementUsage.NEXTTEXTURECOORDINATE1="NEXTUV1";
		VertexElementUsage.CORNERTEXTURECOORDINATE0="CORNERTEXTURECOORDINATE";
		VertexElementUsage.VELOCITY0="VELOCITY";
		VertexElementUsage.STARTCOLOR0="STARTCOLOR";
		VertexElementUsage.ENDCOLOR0="ENDCOLOR";
		VertexElementUsage.SIZEROTATION0="SIZEROTATION";
		VertexElementUsage.RADIUS0="RADIUS";
		VertexElementUsage.RADIAN0="RADIAN";
		VertexElementUsage.AGEADDSCALE0="AGEADDSCALE";
		VertexElementUsage.TIME0="TIME";
		return VertexElementUsage;
	})()


	/**
	*<code>VertexPositionNormalColor</code> 类用于创建位置、法线、颜色顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColor
	var VertexPositionNormalColor=(function(){
		function VertexPositionNormalColor(position,normal,color){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
		}

		__class(VertexPositionNormalColor,'laya.d3.graphics.VertexPositionNormalColor');
		var __proto=VertexPositionNormalColor.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColor._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColor,'vertexDeclaration',function(){
			return VertexPositionNormalColor._vertexDeclaration;
		});

		__static(VertexPositionNormalColor,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(40,[
			new VertexElement(0,"vector3","POSITION"),
			new VertexElement(12,"vector3","NORMAL"),
			new VertexElement(24,"vector4","COLOR")]);}
		]);
		return VertexPositionNormalColor;
	})()


	/**
	*<code>VertexPositionNormalColorSkin</code> 类用于创建位置、法线、颜色、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorSkin
	var VertexPositionNormalColorSkin=(function(){
		function VertexPositionNormalColorSkin(position,normal,color,blendIndex,blendWeight){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__class(VertexPositionNormalColorSkin,'laya.d3.graphics.VertexPositionNormalColorSkin');
		var __proto=VertexPositionNormalColorSkin.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorSkin._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorSkin,'vertexDeclaration',function(){
			return VertexPositionNormalColorSkin._vertexDeclaration;
		});

		__static(VertexPositionNormalColorSkin,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(72,[
			new VertexElement(0,"vector3","POSITION"),
			new VertexElement(12,"vector3","NORMAL"),
			new VertexElement(24,"vector4","COLOR"),
			new VertexElement(40,"vector4","BLENDWEIGHT"),
			new VertexElement(56,"vector4","BLENDINDICES")]);}
		]);
		return VertexPositionNormalColorSkin;
	})()


	/**
	*<code>VertexPositionNormalColorSkin</code> 类用于创建位置、法线、颜色、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorSkinTangent
	var VertexPositionNormalColorSkinTangent=(function(){
		function VertexPositionNormalColorSkinTangent(position,normal,color,tangent,blendIndex,blendWeight){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._tangent=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._tangent=tangent;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__class(VertexPositionNormalColorSkinTangent,'laya.d3.graphics.VertexPositionNormalColorSkinTangent');
		var __proto=VertexPositionNormalColorSkinTangent.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorSkinTangent._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorSkinTangent,'vertexDeclaration',function(){
			return VertexPositionNormalColorSkinTangent._vertexDeclaration;
		});

		__static(VertexPositionNormalColorSkinTangent,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(84,[
			new VertexElement(0,"vector3","POSITION"),
			new VertexElement(12,"vector3","NORMAL"),
			new VertexElement(24,"vector4","COLOR"),
			new VertexElement(40,"vector4","BLENDWEIGHT"),
			new VertexElement(56,"vector4","BLENDINDICES"),
			new VertexElement(72,"vector3","TANGENT0")]);}
		]);
		return VertexPositionNormalColorSkinTangent;
	})()


	/**
	*<code>VertexPositionNormalColorTangent</code> 类用于创建位置、法线、颜色、切线顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorTangent
	var VertexPositionNormalColorTangent=(function(){
		function VertexPositionNormalColorTangent(position,normal,color,tangent){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._tangent=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._tangent=tangent;
		}

		__class(VertexPositionNormalColorTangent,'laya.d3.graphics.VertexPositionNormalColorTangent');
		var __proto=VertexPositionNormalColorTangent.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTangent._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorTangent,'vertexDeclaration',function(){
			return VertexPositionNormalColorTangent._vertexDeclaration;
		});

		__static(VertexPositionNormalColorTangent,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(52,[
			new VertexElement(0,"vector3","POSITION"),
			new VertexElement(12,"vector3","NORMAL"),
			new VertexElement(24,"vector4","COLOR"),
			new VertexElement(40,"vector3","TANGENT0")]);}
		]);
		return VertexPositionNormalColorTangent;
	})()


	/**
	*<code>VertexPositionNormalColorTexture</code> 类用于创建位置、法线、颜色、纹理顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorTexture
	var VertexPositionNormalColorTexture=(function(){
		function VertexPositionNormalColorTexture(position,normal,color,textureCoordinate){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._textureCoordinate=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._textureCoordinate=textureCoordinate;
		}

		__class(VertexPositionNormalColorTexture,'laya.d3.graphics.VertexPositionNormalColorTexture');
		var __proto=VertexPositionNormalColorTexture.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorTexture,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture._vertexDeclaration;
		});

		__static(VertexPositionNormalColorTexture,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(48,[
			new VertexElement(0,"vector3","POSITION"),
			new VertexElement(12,"vector3","NORMAL"),
			new VertexElement(24,"vector4","COLOR"),
			new VertexElement(40,"vector2","UV")]);}
		]);
		return VertexPositionNormalColorTexture;
	})()


	/**
	*<code>VertexPositionNormalColorTexture</code> 类用于创建位置、法线、颜色、纹理顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorTexture0Texture1
	var VertexPositionNormalColorTexture0Texture1=(function(){
		function VertexPositionNormalColorTexture0Texture1(position,normal,color,textureCoordinate0,textureCoordinate1){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._textureCoordinate0=null;
			this._textureCoordinate1=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._textureCoordinate0=textureCoordinate0;
			this._textureCoordinate1=textureCoordinate1;
		}

		__class(VertexPositionNormalColorTexture0Texture1,'laya.d3.graphics.VertexPositionNormalColorTexture0Texture1');
		var __proto=VertexPositionNormalColorTexture0Texture1.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture0Texture1._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorTexture0Texture1,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture0Texture1._vertexDeclaration;
		});

		__static(VertexPositionNormalColorTexture0Texture1,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(56,[
			new VertexElement(0,"vector3","POSITION"),
			new VertexElement(12,"vector3","NORMAL"),
			new VertexElement(24,"vector4","COLOR"),
			new VertexElement(40,"vector2","UV"),
			new VertexElement(48,"vector2","UV1")]);}
		]);
		return VertexPositionNormalColorTexture0Texture1;
	})()


	/**
	*<code>VertexPositionNormalColorTextureSkin</code> 类用于创建位置、法线、颜色、纹理、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorTexture0Texture1Skin
	var VertexPositionNormalColorTexture0Texture1Skin=(function(){
		function VertexPositionNormalColorTexture0Texture1Skin(position,normal,color,textureCoordinate0,textureCoordinate1,blendIndex,blendWeight){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._textureCoordinate0=null;
			this._textureCoordinate1=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._textureCoordinate0=textureCoordinate0;
			this._textureCoordinate1=textureCoordinate1;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__class(VertexPositionNormalColorTexture0Texture1Skin,'laya.d3.graphics.VertexPositionNormalColorTexture0Texture1Skin');
		var __proto=VertexPositionNormalColorTexture0Texture1Skin.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture0Texture1Skin._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorTexture0Texture1Skin,'vertexDeclaration',function(){
			return VertexPositionNormalColorTexture0Texture1Skin._vertexDeclaration;
		});

		__static(VertexPositionNormalColorTexture0Texture1Skin,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(88,[
			new VertexElement(0,"vector3","POSITION"),
			new VertexElement(12,"vector3","NORMAL"),
			new VertexElement(24,"vector4","COLOR"),
			new VertexElement(40,"vector2","UV"),
			new VertexElement(48,"vector2","UV1"),
			new VertexElement(56,"vector4","BLENDWEIGHT"),
			new VertexElement(72,"vector4","BLENDINDICES")]);}
		]);
		return VertexPositionNormalColorTexture0Texture1Skin;
	})()


	/**
	*<code>VertexPositionNormalColorTextureSkin</code> 类用于创建位置、法线、颜色、纹理、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorTextureSkin
	var VertexPositionNormalColorTextureSkin=(function(){
		function VertexPositionNormalColorTextureSkin(position,normal,color,textureCoordinate,blendIndex,blendWeight){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._textureCoordinate=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._textureCoordinate=textureCoordinate;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__class(VertexPositionNormalColorTextureSkin,'laya.d3.graphics.VertexPositionNormalColorTextureSkin');
		var __proto=VertexPositionNormalColorTextureSkin.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTextureSkin._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorTextureSkin,'vertexDeclaration',function(){
			return VertexPositionNormalColorTextureSkin._vertexDeclaration;
		});

		__static(VertexPositionNormalColorTextureSkin,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(80,[
			new VertexElement(0,"vector3","POSITION"),
			new VertexElement(12,"vector3","NORMAL"),
			new VertexElement(24,"vector4","COLOR"),
			new VertexElement(40,"vector2","UV"),
			new VertexElement(48,"vector4","BLENDWEIGHT"),
			new VertexElement(64,"vector4","BLENDINDICES")]);}
		]);
		return VertexPositionNormalColorTextureSkin;
	})()


	/**
	*<code>VertexPositionNormalTextureSkin</code> 类用于创建位置、法线、纹理、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorTextureSkinTangent
	var VertexPositionNormalColorTextureSkinTangent=(function(){
		function VertexPositionNormalColorTextureSkinTangent(position,normal,color,textureCoordinate,tangent,blendIndex,blendWeight){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._textureCoordinate=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._tangent=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._textureCoordinate=textureCoordinate;
			this._tangent=tangent;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__class(VertexPositionNormalColorTextureSkinTangent,'laya.d3.graphics.VertexPositionNormalColorTextureSkinTangent');
		var __proto=VertexPositionNormalColorTextureSkinTangent.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTextureSkinTangent._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorTextureSkinTangent,'vertexDeclaration',function(){
			return VertexPositionNormalColorTextureSkinTangent._vertexDeclaration;
		});

		__static(VertexPositionNormalColorTextureSkinTangent,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(92,[
			new VertexElement(0,"vector3","POSITION"),
			new VertexElement(12,"vector3","NORMAL"),
			new VertexElement(24,"vector4","COLOR"),
			new VertexElement(40,"vector2","UV"),
			new VertexElement(48,"vector4","BLENDWEIGHT"),
			new VertexElement(64,"vector4","BLENDINDICES"),
			new VertexElement(80,"vector3","TANGENT0")]);}
		]);
		return VertexPositionNormalColorTextureSkinTangent;
	})()


	/**
	*<code>VertexPositionNormalColorTextureTangent</code> 类用于创建位置、法线、颜色、纹理、切线顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalColorTextureTangent
	var VertexPositionNormalColorTextureTangent=(function(){
		function VertexPositionNormalColorTextureTangent(position,normal,color,textureCoordinate,tangent){
			this._position=null;
			this._normal=null;
			this._color=null;
			this._textureCoordinate=null;
			this._tangent=null;
			this._position=position;
			this._normal=normal;
			this._color=color;
			this._textureCoordinate=textureCoordinate;
			this._tangent=tangent;
		}

		__class(VertexPositionNormalColorTextureTangent,'laya.d3.graphics.VertexPositionNormalColorTextureTangent');
		var __proto=VertexPositionNormalColorTextureTangent.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'color',function(){
			return this._color;
		});

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalColorTextureTangent._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalColorTextureTangent,'vertexDeclaration',function(){
			return VertexPositionNormalColorTextureTangent._vertexDeclaration;
		});

		__static(VertexPositionNormalColorTextureTangent,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(60,[
			new VertexElement(0,"vector3","POSITION"),
			new VertexElement(12,"vector3","NORMAL"),
			new VertexElement(24,"vector4","COLOR"),
			new VertexElement(40,"vector2","UV"),
			new VertexElement(48,"vector3","TANGENT0")]);}
		]);
		return VertexPositionNormalColorTextureTangent;
	})()


	/**
	*<code>VertexPositionNormalTexture</code> 类用于创建位置、法线、纹理顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalTexture
	var VertexPositionNormalTexture=(function(){
		function VertexPositionNormalTexture(position,normal,textureCoordinate){
			this._position=null;
			this._normal=null;
			this._textureCoordinate=null;
			this._position=position;
			this._normal=normal;
			this._textureCoordinate=textureCoordinate;
		}

		__class(VertexPositionNormalTexture,'laya.d3.graphics.VertexPositionNormalTexture');
		var __proto=VertexPositionNormalTexture.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTexture._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalTexture,'vertexDeclaration',function(){
			return VertexPositionNormalTexture._vertexDeclaration;
		});

		__static(VertexPositionNormalTexture,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(32,[
			new VertexElement(0,"vector3","POSITION"),
			new VertexElement(12,"vector3","NORMAL"),
			new VertexElement(24,"vector2","UV")]);}
		]);
		return VertexPositionNormalTexture;
	})()


	/**
	*<code>VertexPositionNormalTexture</code> 类用于创建位置、法线、纹理顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalTexture0Texture1
	var VertexPositionNormalTexture0Texture1=(function(){
		function VertexPositionNormalTexture0Texture1(position,normal,textureCoordinate0,textureCoordinate1){
			this._position=null;
			this._normal=null;
			this._textureCoordinate0=null;
			this._textureCoordinate1=null;
			this._position=position;
			this._normal=normal;
			this._textureCoordinate0=textureCoordinate0;
			this._textureCoordinate1=textureCoordinate1;
		}

		__class(VertexPositionNormalTexture0Texture1,'laya.d3.graphics.VertexPositionNormalTexture0Texture1');
		var __proto=VertexPositionNormalTexture0Texture1.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTexture0Texture1._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalTexture0Texture1,'vertexDeclaration',function(){
			return VertexPositionNormalTexture0Texture1._vertexDeclaration;
		});

		__static(VertexPositionNormalTexture0Texture1,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(40,[
			new VertexElement(0,"vector3","POSITION"),
			new VertexElement(12,"vector3","NORMAL"),
			new VertexElement(24,"vector2","UV"),
			new VertexElement(32,"vector2","UV1")]);}
		]);
		return VertexPositionNormalTexture0Texture1;
	})()


	/**
	*<code>VertexPositionNormalColorTextureSkin</code> 类用于创建位置、法线、颜色、纹理、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalTexture0Texture1Skin
	var VertexPositionNormalTexture0Texture1Skin=(function(){
		function VertexPositionNormalTexture0Texture1Skin(position,normal,textureCoordinate0,textureCoordinate1,blendIndex,blendWeight){
			this._position=null;
			this._normal=null;
			this._textureCoordinate0=null;
			this._textureCoordinate1=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._position=position;
			this._normal=normal;
			this._textureCoordinate0=textureCoordinate0;
			this._textureCoordinate1=textureCoordinate1;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__class(VertexPositionNormalTexture0Texture1Skin,'laya.d3.graphics.VertexPositionNormalTexture0Texture1Skin');
		var __proto=VertexPositionNormalTexture0Texture1Skin.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'textureCoordinate0',function(){
			return this._textureCoordinate0;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'textureCoordinate1',function(){
			return this._textureCoordinate1;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTexture0Texture1Skin._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalTexture0Texture1Skin,'vertexDeclaration',function(){
			return VertexPositionNormalTexture0Texture1Skin._vertexDeclaration;
		});

		__static(VertexPositionNormalTexture0Texture1Skin,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(72,[
			new VertexElement(0,"vector3","POSITION"),
			new VertexElement(12,"vector3","NORMAL"),
			new VertexElement(24,"vector2","UV"),
			new VertexElement(32,"vector2","UV1"),
			new VertexElement(40,"vector4","BLENDWEIGHT"),
			new VertexElement(56,"vector4","BLENDINDICES")]);}
		]);
		return VertexPositionNormalTexture0Texture1Skin;
	})()


	/**
	*<code>VertexPositionNormalColorTextureSkin</code> 类用于创建位置、法线、颜色、纹理、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalTextureSkin
	var VertexPositionNormalTextureSkin=(function(){
		function VertexPositionNormalTextureSkin(position,normal,textureCoordinate,blendIndex,blendWeight){
			this._position=null;
			this._normal=null;
			this._textureCoordinate=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._position=position;
			this._normal=normal;
			this._textureCoordinate=textureCoordinate;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__class(VertexPositionNormalTextureSkin,'laya.d3.graphics.VertexPositionNormalTextureSkin');
		var __proto=VertexPositionNormalTextureSkin.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTextureSkin._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalTextureSkin,'vertexDeclaration',function(){
			return VertexPositionNormalTextureSkin._vertexDeclaration;
		});

		__static(VertexPositionNormalTextureSkin,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(64,[
			new VertexElement(0,"vector3","POSITION"),
			new VertexElement(12,"vector3","NORMAL"),
			new VertexElement(24,"vector2","UV"),
			new VertexElement(32,"vector4","BLENDWEIGHT"),
			new VertexElement(48,"vector4","BLENDINDICES")]);}
		]);
		return VertexPositionNormalTextureSkin;
	})()


	/**
	*<code>VertexPositionNormalTextureSkin</code> 类用于创建位置、法线、纹理、骨骼索引、骨骼权重顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalTextureSkinTangent
	var VertexPositionNormalTextureSkinTangent=(function(){
		function VertexPositionNormalTextureSkinTangent(position,normal,textureCoordinate,tangent,blendIndex,blendWeight){
			this._position=null;
			this._normal=null;
			this._textureCoordinate=null;
			this._blendIndex=null;
			this._blendWeight=null;
			this._tangent=null;
			this._position=position;
			this._normal=normal;
			this._textureCoordinate=textureCoordinate;
			this._tangent=tangent;
			this._blendIndex=blendIndex;
			this._blendWeight=blendWeight;
		}

		__class(VertexPositionNormalTextureSkinTangent,'laya.d3.graphics.VertexPositionNormalTextureSkinTangent');
		var __proto=VertexPositionNormalTextureSkinTangent.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'blendIndex',function(){
			return this._blendIndex;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'blendWeight',function(){
			return this._blendWeight;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTextureSkinTangent._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalTextureSkinTangent,'vertexDeclaration',function(){
			return VertexPositionNormalTextureSkinTangent._vertexDeclaration;
		});

		__static(VertexPositionNormalTextureSkinTangent,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(76,[
			new VertexElement(0,"vector3","POSITION"),
			new VertexElement(12,"vector3","NORMAL"),
			new VertexElement(24,"vector2","UV"),
			new VertexElement(32,"vector4","BLENDWEIGHT"),
			new VertexElement(48,"vector4","BLENDINDICES"),
			new VertexElement(64,"vector3","TANGENT0")]);}
		]);
		return VertexPositionNormalTextureSkinTangent;
	})()


	/**
	*<code>VertexPositionNormalTextureTangent</code> 类用于创建位置、法线、纹理、切线顶点结构。
	*/
	//class laya.d3.graphics.VertexPositionNormalTextureTangent
	var VertexPositionNormalTextureTangent=(function(){
		function VertexPositionNormalTextureTangent(position,normal,textureCoordinate,tangent){
			this._position=null;
			this._normal=null;
			this._textureCoordinate=null;
			this._tangent=null;
			this._position=position;
			this._normal=normal;
			this._textureCoordinate=textureCoordinate;
			this._tangent=tangent;
		}

		__class(VertexPositionNormalTextureTangent,'laya.d3.graphics.VertexPositionNormalTextureTangent');
		var __proto=VertexPositionNormalTextureTangent.prototype;
		Laya.imps(__proto,{"laya.d3.graphics.IVertex":true})
		__getset(0,__proto,'position',function(){
			return this._position;
		});

		__getset(0,__proto,'normal',function(){
			return this._normal;
		});

		__getset(0,__proto,'textureCoordinate',function(){
			return this._textureCoordinate;
		});

		__getset(0,__proto,'tangent',function(){
			return this._tangent;
		});

		__getset(0,__proto,'vertexDeclaration',function(){
			return VertexPositionNormalTextureTangent._vertexDeclaration;
		});

		__getset(1,VertexPositionNormalTextureTangent,'vertexDeclaration',function(){
			return VertexPositionNormalTextureTangent._vertexDeclaration;
		});

		__static(VertexPositionNormalTextureTangent,
		['_vertexDeclaration',function(){return this._vertexDeclaration=new VertexDeclaration(44,[
			new VertexElement(0,"vector3","POSITION"),
			new VertexElement(12,"vector3","NORMAL"),
			new VertexElement(24,"vector2","UV"),
			new VertexElement(32,"vector3","TANGENT0")]);}
		]);
		return VertexPositionNormalTextureTangent;
	})()


	/**
	*@private
	*<code>LoadModel</code> 类用于模型加载。
	*/
	//class laya.d3.loaders.LoadModel
	var LoadModel=(function(){
		function LoadModel(data,mesh,materials,url){
			this._version=null;
			this._strings=['BLOCK','DATA',"STRINGS"];
			this._materials=null;
			this._fileData=null;
			this._readData=null;
			this._mesh=null;
			this._BLOCK={count:0};
			this._DATA={offset:0,size:0};
			this._STRINGS={offset:0,size:0};
			this._shaderAttributes=null;
			this._mesh=mesh;
			this._materials=materials;
			this._onLoaded(data,url);
		}

		__class(LoadModel,'laya.d3.loaders.LoadModel');
		var __proto=LoadModel.prototype;
		/**
		*@private
		*/
		__proto._onLoaded=function(data,url){
			var preBasePath=URL.basePath;
			URL.basePath=URL.getPath(URL.formatURL(url));
			this._fileData=data;
			this._readData=new Byte(this._fileData);
			this._readData.pos=0;
			this._version=this._readData.readUTFString();
			this.READ_BLOCK();
			for (var i=0;i < this._BLOCK.count;i++){
				var index=this._readData.getUint16();
				var blockName=this._strings[index];
				var fn=this["READ_"+blockName];
				if (fn==null)throw new Error("model file err,no this function:"+index+" "+blockName);
				if (!fn.call(this))break ;
			}
			URL.basePath=preBasePath;
			return this._mesh;
		}

		__proto.onError=function(){}
		/**
		*@private
		*/
		__proto._readString=function(){
			return this._strings[this._readData.getUint16()];
		}

		__proto.READ_BLOCK=function(){
			var n=this._readData.getUint16();
			this._BLOCK.count=this._readData.getUint16();
			return true;
		}

		__proto.READ_DATA=function(){
			this._DATA.offset=this._readData.getUint32();
			this._DATA.size=this._readData.getUint32();
			return true;
		}

		__proto.READ_STRINGS=function(){
			this._STRINGS.offset=this._readData.getUint16();
			this._STRINGS.size=this._readData.getUint16();
			var ofs=this._readData.pos;
			this._readData.pos=this._STRINGS.offset+this._DATA.offset;
			for (var i=0;i < this._STRINGS.size;i++){
				this._strings[i]=this._readData.readUTFString();
			}
			this._readData.pos=ofs;
			return true;
		}

		__proto.READ_MATERIAL=function(){
			var i=0,n=0;
			var index=this._readData.getUint16();
			var shaderName=this._readString();
			var url=this._readString();
			if (url!=="null"){
				url=URL.formatURL(url);
				var material=Resource.materialCache[url];
				if (material){
					this._materials[index]=material;
					}else {
					material=this._materials[index]=Resource.materialCache[url]=new StandardMaterial();
					material.setShaderName(shaderName);
					BaseMaterial.createFromFile(url,material);
				}
				}else {
				this._materials[index]=new BaseMaterial();
			}
			return true;
		}

		__proto.READ_MESH=function(){
			var name=this._readString();
			switch (this._version){
				case "LAYAMODEL:01":
					console.log("Warning: The (.lm) file is converted by old fbxTools,please reConverted it use  lastest fbxTools version,later we will remove the  support of old version (.lm) support.");
					break ;
				case "LAYASKINANI:01":;
					var arrayBuffer=this._readData.__getBuffer();
					var i=0,n=0;
					var bindPoseStart=this._readData.getUint32();
					var binPoseLength=this._readData.getUint32();
					var bindPoseDatas=new Float32Array(arrayBuffer.slice(bindPoseStart+this._DATA.offset,bindPoseStart+this._DATA.offset+binPoseLength));
					this.mesh._bindPoses=[];
					for (i=0,n=bindPoseDatas.length;i < n;i+=16){
						var bindPose=new Matrix4x4(bindPoseDatas[i+0],bindPoseDatas[i+1],bindPoseDatas[i+2],bindPoseDatas[i+3],bindPoseDatas[i+4],bindPoseDatas[i+5],bindPoseDatas[i+6],bindPoseDatas[i+7],bindPoseDatas[i+8],bindPoseDatas[i+9],bindPoseDatas[i+10],bindPoseDatas[i+11],bindPoseDatas[i+12],bindPoseDatas[i+13],bindPoseDatas[i+14],bindPoseDatas[i+15]);
						this.mesh._bindPoses.push(bindPose);
					};
					var inverseGlobalBindPoseStart=this._readData.getUint32();
					var inverseGlobalBinPoseLength=this._readData.getUint32();
					var invGloBindPoseDatas=new Float32Array(arrayBuffer.slice(inverseGlobalBindPoseStart+this._DATA.offset,inverseGlobalBindPoseStart+this._DATA.offset+inverseGlobalBinPoseLength));
					this.mesh._inverseBindPoses=[];
					for (i=0,n=invGloBindPoseDatas.length;i < n;i+=16){
						var inverseGlobalBindPose=new Matrix4x4(invGloBindPoseDatas[i+0],invGloBindPoseDatas[i+1],invGloBindPoseDatas[i+2],invGloBindPoseDatas[i+3],invGloBindPoseDatas[i+4],invGloBindPoseDatas[i+5],invGloBindPoseDatas[i+6],invGloBindPoseDatas[i+7],invGloBindPoseDatas[i+8],invGloBindPoseDatas[i+9],invGloBindPoseDatas[i+10],invGloBindPoseDatas[i+11],invGloBindPoseDatas[i+12],invGloBindPoseDatas[i+13],invGloBindPoseDatas[i+14],invGloBindPoseDatas[i+15]);
						this.mesh._inverseBindPoses.push(inverseGlobalBindPose);
					}
					break ;
				default :
					throw new Error("LoadModel:unknown version.");
				}
			return true;
		}

		__proto.READ_SUBMESH=function(){
			var className=this._readString();
			var material=this._readData.getUint8();
			var bufferAttribute=this._readString();
			this._shaderAttributes=bufferAttribute.match(LoadModel._attrReg);
			var ibofs=this._readData.getUint32();
			var ibsize=this._readData.getUint32();
			var vbIndicesofs=this._readData.getUint32();
			var vbIndicessize=this._readData.getUint32();
			var vbofs=this._readData.getUint32();
			var vbsize=this._readData.getUint32();
			var boneDicofs=this._readData.getUint32();
			var boneDicsize=this._readData.getUint32();
			var arrayBuffer=this._readData.__getBuffer();
			var submesh=new SubMesh();
			var vertexDeclaration=this._getVertexDeclaration();
			var vb=VertexBuffer3D.create(vertexDeclaration,vbsize / vertexDeclaration.vertexStride,0x88E4,true);
			var vbStart=vbofs+this._DATA.offset;
			var vbArrayBuffer=arrayBuffer.slice(vbStart,vbStart+vbsize);
			vb.setData(new Float32Array(vbArrayBuffer));
			submesh._vertexBuffer=vb;
			var vertexElements=vb.vertexDeclaration.getVertexElements();
			for (var i=0;i < vertexElements.length;i++)
			submesh._bufferUsage[(vertexElements [i]).elementUsage]=vb;
			var ib=IndexBuffer3D.create("ushort",ibsize / 2,0x88E4,true);
			var ibStart=ibofs+this._DATA.offset;
			var ibArrayBuffer=arrayBuffer.slice(ibStart,ibStart+ibsize);
			ib.setData(new Uint16Array(ibArrayBuffer));
			submesh._indexBuffer=ib;
			var boneDicArrayBuffer=arrayBuffer.slice(boneDicofs+this._DATA.offset,boneDicofs+this._DATA.offset+boneDicsize);
			submesh._boneIndices=new Uint8Array(boneDicArrayBuffer);
			this._mesh._add(submesh);
			return true;
		}

		__proto.READ_DATAAREA=function(){
			return false;
		}

		__proto._getVertexDeclaration=function(){
			var position=false,normal=false,color=false,texcoord0=false,texcoord1=false,tangent=false,blendWeight=false,blendIndex=false;
			for (var i=0;i < this._shaderAttributes.length;i+=8){
				switch (this._shaderAttributes[i]){
					case "POSITION":
						position=true;
						break ;
					case "NORMAL":
						normal=true;
						break ;
					case "COLOR":
						color=true;
						break ;
					case "UV":
						texcoord0=true;
						break ;
					case "UV1":
						texcoord1=true;
						break ;
					case "TANGENT":
						tangent=true;
						break ;
					case "BLENDWEIGHT":
						blendWeight=true;
						break ;
					case "BLENDINDICES":
						blendIndex=true;
						break ;
					}
			};
			var vertexDeclaration;
			if (position && normal && color && texcoord0 && texcoord1 && blendWeight && blendIndex)
				vertexDeclaration=VertexPositionNormalColorTexture0Texture1Skin.vertexDeclaration;
			else if (position && normal && texcoord0 && texcoord1 && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalTexture0Texture1Skin.vertexDeclaration;
			else if (position && normal && color && texcoord0 && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalColorTextureSkin.vertexDeclaration;
			else if (position && normal && texcoord0 && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalTextureSkin.vertexDeclaration;
			else if (position && normal && color && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalColorSkin.vertexDeclaration;
			else if (position && normal && color && texcoord0 && texcoord1)
			vertexDeclaration=VertexPositionNormalColorTexture0Texture1.vertexDeclaration;
			else if (position && normal && texcoord0 && texcoord1)
			vertexDeclaration=VertexPositionNormalTexture0Texture1.vertexDeclaration;
			else if (position && normal && color && texcoord0)
			vertexDeclaration=VertexPositionNormalColorTexture.vertexDeclaration;
			else if (position && normal && texcoord0)
			vertexDeclaration=VertexPositionNormalTexture.vertexDeclaration;
			else if (position && normal && color)
			vertexDeclaration=VertexPositionNormalColor.vertexDeclaration;
			return vertexDeclaration;
		}

		__getset(0,__proto,'mesh',function(){
			return this._mesh;
		});

		LoadModel._attrReg=new RegExp("(\\w+)|([:,;])","g");
		return LoadModel;
	})()


	/**
	*<code>BoundBox</code> 类用于创建包围盒。
	*/
	//class laya.d3.math.BoundBox
	var BoundBox=(function(){
		function BoundBox(min,max){
			this.min=null;
			this.max=null;
			this.min=min;
			this.max=max;
		}

		__class(BoundBox,'laya.d3.math.BoundBox');
		var __proto=BoundBox.prototype;
		/**
		*获取包围盒的8个角顶点。
		*@param corners 返回顶点的输出队列。
		*/
		__proto.getCorners=function(corners){
			corners.length=8;
			var mine=this.min.elements;
			var maxe=this.max.elements;
			var minX=mine[0];
			var minY=mine[1];
			var minZ=mine[2];
			var maxX=maxe[0];
			var maxY=maxe[1];
			var maxZ=maxe[2];
			corners[0]=new Vector3(minX,maxY,maxZ);
			corners[1]=new Vector3(maxX,maxY,maxZ);
			corners[2]=new Vector3(maxX,minY,maxZ);
			corners[3]=new Vector3(minX,minY,maxZ);
			corners[4]=new Vector3(minX,maxY,minZ);
			corners[5]=new Vector3(maxX,maxY,minZ);
			corners[6]=new Vector3(maxX,minY,minZ);
			corners[7]=new Vector3(minX,minY,minZ);
		}

		__proto.toDefault=function(){
			this.min.toDefault();
			this.max.toDefault();
		}

		BoundBox.createfromPoints=function(points,out){
			if (points==null)
				throw new Error("points");
			var min=new Vector3(Number.MAX_VALUE);
			var max=new Vector3(-Number.MAX_VALUE);
			for (var i=0;i < points.length;++i){
				Vector3.min(min,points[i],min);
				Vector3.max(max,points[i],max);
			}
			out.min=min;
			out.max=max;
		}

		return BoundBox;
	})()


	/**
	*<code>BoundFrustum</code> 类用于创建锥截体。
	*/
	//class laya.d3.math.BoundFrustum
	var BoundFrustum=(function(){
		function BoundFrustum(matrix){
			this._matrix=null;
			this._near=null;
			this._far=null;
			this._left=null;
			this._right=null;
			this._top=null;
			this._bottom=null;
			this._matrix=matrix;
			this._near=new Plane(new Vector3());
			this._far=new Plane(new Vector3());
			this._left=new Plane(new Vector3());
			this._right=new Plane(new Vector3());
			this._top=new Plane(new Vector3());
			this._bottom=new Plane(new Vector3());
			BoundFrustum._getPlanesFromMatrix(this._matrix,this._near,this._far,this._left,this._right,this._top,this._bottom);
		}

		__class(BoundFrustum,'laya.d3.math.BoundFrustum');
		var __proto=BoundFrustum.prototype;
		/**
		*判断是否与其他锥截体相等。
		*@param other 锥截体。
		*/
		__proto.equalsBoundFrustum=function(other){
			return this._matrix.equalsOtherMatrix(other.matrix)
		}

		/**
		*判断是否与其他对象相等。
		*@param obj 对象。
		*/
		__proto.equalsObj=function(obj){
			if ((obj instanceof laya.d3.math.BoundFrustum )){
				var bf=obj;
				return this.equalsBoundFrustum(bf);
			}
			return false;
		}

		/**
		*获取锥截体的任意一平面。
		*0:近平面
		*1:远平面
		*2:左平面
		*3:右平面
		*4:顶平面
		*5:底平面
		*@param index 索引。
		*/
		__proto.getPlane=function(index){
			switch(index){
				case 0:
					return this._near;
				case 1:
					return this._far;
				case 2:
					return this._left;
				case 3:
					return this._right;
				case 4:
					return this._top;
				case 5:
					return this._bottom;
				default :
					return null;
				}
		}

		/**
		*锥截体的8个顶点。
		*@param corners 返回顶点的输出队列。
		*/
		__proto.getCorners=function(corners){
			corners[0]=BoundFrustum.get3PlaneInterPoint(this._near,this._bottom,this._right);
			corners[1]=BoundFrustum.get3PlaneInterPoint(this._near,this._top,this._right);
			corners[2]=BoundFrustum.get3PlaneInterPoint(this._near,this._top,this._left);
			corners[3]=BoundFrustum.get3PlaneInterPoint(this._near,this._bottom,this._left);
			corners[4]=BoundFrustum.get3PlaneInterPoint(this._far,this._bottom,this._right);
			corners[5]=BoundFrustum.get3PlaneInterPoint(this._far,this._top,this._right);
			corners[6]=BoundFrustum.get3PlaneInterPoint(this._far,this._top,this._left);
			corners[7]=BoundFrustum.get3PlaneInterPoint(this._far,this._bottom,this._left);
		}

		/**
		*与点的位置关系。返回-1,包涵;0,相交;1,不相交
		*@param point 点。
		*/
		__proto.ContainsPoint=function(point){
			var result=Plane.PlaneIntersectionType_Front;
			var planeResult=Plane.PlaneIntersectionType_Front;
			for (var i=0;i < 6;i++){
				switch(i){
					case 0:
						planeResult=Collision.intersectsPlaneAndPoint(this._near,point);
						break ;
					case 1:
						planeResult=Collision.intersectsPlaneAndPoint(this._far,point);
						break ;
					case 2:
						planeResult=Collision.intersectsPlaneAndPoint(this._left,point);
						break ;
					case 3:
						planeResult=Collision.intersectsPlaneAndPoint(this._right,point);
						break ;
					case 4:
						planeResult=Collision.intersectsPlaneAndPoint(this._top,point);
						break ;
					case 5:
						planeResult=Collision.intersectsPlaneAndPoint(this._bottom,point);
						break ;
					}
				switch(planeResult){
					case Plane.PlaneIntersectionType_Back:
						return 0;
					case Plane.PlaneIntersectionType_Intersecting:
						result=Plane.PlaneIntersectionType_Intersecting;
						break ;
					}
			}
			switch(result){
				case Plane.PlaneIntersectionType_Intersecting:
					return 2;
				default :
					return 1;
				}
		}

		/**
		*与包围盒的位置关系。返回-1,包涵;0,相交;1,不相交
		*@param box 包围盒。
		*/
		__proto.ContainsBoundBox=function(box){
			var plane;
			var result=1;
			for (var i=0;i < 6;i++){
				plane=this.getPlane(i);
				this._getBoxToPlanePVertexNVertex(box,plane.normal,BoundFrustum._tempV30,BoundFrustum._tempV31);
				if (Collision.intersectsPlaneAndPoint(plane,BoundFrustum._tempV30)==Plane.PlaneIntersectionType_Back)
					return 0;
				if (Collision.intersectsPlaneAndPoint(plane,BoundFrustum._tempV31)==Plane.PlaneIntersectionType_Back)
					result=2;
			}
			return result;
		}

		/**
		*与包围球的位置关系。返回-1,包涵;0,相交;1,不相交
		*@param sphere 包围球。
		*/
		__proto.ContainsBoundSphere=function(sphere){
			var result=Plane.PlaneIntersectionType_Front;
			var planeResult=Plane.PlaneIntersectionType_Front;
			for (var i=0;i < 6;i++){
				switch(i){
					case 0:
						planeResult=Collision.intersectsPlaneAndSphere(this._near,sphere);
						break ;
					case 1:
						planeResult=Collision.intersectsPlaneAndSphere(this._far,sphere);
						break ;
					case 2:
						planeResult=Collision.intersectsPlaneAndSphere(this._left,sphere);
						break ;
					case 3:
						planeResult=Collision.intersectsPlaneAndSphere(this._right,sphere);
						break ;
					case 4:
						planeResult=Collision.intersectsPlaneAndSphere(this._top,sphere);
						break ;
					case 5:
						planeResult=Collision.intersectsPlaneAndSphere(this._bottom,sphere);
						break ;
					}
				switch(planeResult){
					case Plane.PlaneIntersectionType_Back:
						return 0;
					case Plane.PlaneIntersectionType_Intersecting:
						result=Plane.PlaneIntersectionType_Intersecting;
						break ;
					}
			}
			switch(result){
				case Plane.PlaneIntersectionType_Intersecting:
					return 2;
				default :
					return 1;
				}
		}

		/**
		*@private
		*/
		__proto._getBoxToPlanePVertexNVertex=function(box,planeNormal,outP,outN){
			var boxMin=box.min;
			var boxMinE=boxMin.elements;
			var boxMax=box.max;
			var boxMaxE=boxMax.elements;
			var planeNorE=planeNormal.elements;
			var planeNorEX=planeNorE[0];
			var planeNorEY=planeNorE[1];
			var planeNorEZ=planeNorE[2];
			outP=boxMin;
			var outPE=outP.elements;
			if (planeNorEX >=0)
				outPE[0]=boxMaxE[0];
			if (planeNorEY >=0)
				outPE[1]=boxMaxE[1];
			if (planeNorEZ >=0)
				outPE[2]=boxMaxE[2];
			outN=boxMax;
			var outNE=outN.elements;
			if (planeNorEX >=0)
				outNE[0]=boxMinE[0];
			if (planeNorEY >=0)
				outNE[1]=boxMinE[1];
			if (planeNorEZ >=0)
				outNE[2]=boxMinE[2];
		}

		/**
		*获取底平面。
		*@return 底平面。
		*/
		__getset(0,__proto,'bottom',function(){
			return this._bottom;
		});

		/**
		*设置描述矩阵。
		*@param matrix 描述矩阵。
		*/
		/**
		*获取描述矩阵。
		*@return 描述矩阵。
		*/
		__getset(0,__proto,'matrix',function(){
			return this._matrix;
			},function(matrix){
			this._matrix=matrix;
			BoundFrustum._getPlanesFromMatrix(this._matrix,this._near,this._far,this._left,this._right,this._top,this._bottom);
		});

		/**
		*获取顶平面。
		*@return 顶平面。
		*/
		__getset(0,__proto,'top',function(){
			return this._top;
		});

		/**
		*获取近平面。
		*@return 近平面。
		*/
		__getset(0,__proto,'near',function(){
			return this._near;
		});

		/**
		*获取远平面。
		*@return 远平面。
		*/
		__getset(0,__proto,'far',function(){
			return this._far;
		});

		/**
		*获取左平面。
		*@return 左平面。
		*/
		__getset(0,__proto,'left',function(){
			return this._left;
		});

		/**
		*获取右平面。
		*@return 右平面。
		*/
		__getset(0,__proto,'right',function(){
			return this._right;
		});

		BoundFrustum._getPlanesFromMatrix=function(m,np,fp,lp,rp,tp,bp){
			var matrixE=m.elements;
			var m11=matrixE[0];
			var m12=matrixE[1];
			var m13=matrixE[2];
			var m14=matrixE[3];
			var m21=matrixE[4];
			var m22=matrixE[5];
			var m23=matrixE[6];
			var m24=matrixE[7];
			var m31=matrixE[8];
			var m32=matrixE[9];
			var m33=matrixE[10];
			var m34=matrixE[11];
			var m41=matrixE[12];
			var m42=matrixE[13];
			var m43=matrixE[14];
			var m44=matrixE[15];
			var nearNorE=np.normal.elements;
			nearNorE[0]=m13;
			nearNorE[1]=m23;
			nearNorE[2]=m33;
			np.distance=m43;
			np.normalize();
			var farNorE=fp.normal.elements;
			farNorE[0]=m14-m13;
			farNorE[1]=m24-m23;
			farNorE[2]=m34-m33;
			fp.distance=m44-m43;
			fp.normalize();
			var leftNorE=lp.normal.elements;
			leftNorE[0]=m14+m11;
			leftNorE[1]=m24+m21;
			leftNorE[2]=m34+m31;
			lp.distance=m44+m41;
			lp.normalize();
			var rightNorE=rp.normal.elements;
			rightNorE[0]=m14-m11;
			rightNorE[1]=m24-m21;
			rightNorE[2]=m34-m31;
			rp.distance=m44-m41;
			rp.normalize();
			var topNorE=tp.normal.elements;
			topNorE[0]=m14-m12;
			topNorE[1]=m24-m22;
			topNorE[2]=m34-m32;
			tp.distance=m44-m42;
			tp.normalize();
			var bottomNorE=bp.normal.elements;
			bottomNorE[0]=m14+m12;
			bottomNorE[1]=m24+m22;
			bottomNorE[2]=m34+m32;
			bp.distance=m44+m42;
			bp.normalize();
		}

		BoundFrustum.get3PlaneInterPoint=function(p1,p2,p3){
			var p1Nor=p1.normal;
			var p2Nor=p2.normal;
			var p3Nor=p3.normal;
			Vector3.cross(p2Nor,p3Nor,BoundFrustum._tempV30);
			Vector3.cross(p3Nor,p1Nor,BoundFrustum._tempV31);
			Vector3.cross(p1Nor,p2Nor,BoundFrustum._tempV32);
			var a=Vector3.dot(p1Nor,BoundFrustum._tempV30);
			var b=Vector3.dot(p2Nor,BoundFrustum._tempV31);
			var c=Vector3.dot(p3Nor,BoundFrustum._tempV32);
			Vector3.scale(BoundFrustum._tempV30,-p1.distance / a,BoundFrustum._tempV33);
			Vector3.scale(BoundFrustum._tempV31,-p2.distance / b,BoundFrustum._tempV34);
			Vector3.scale(BoundFrustum._tempV32,-p3.distance / c,BoundFrustum._tempV35);
			Vector3.add(BoundFrustum._tempV33,BoundFrustum._tempV34,BoundFrustum._tempV36);
			Vector3.add(BoundFrustum._tempV35,BoundFrustum._tempV36,BoundFrustum._tempV37);
			var v=BoundFrustum._tempV37;
			return v;
		}

		__static(BoundFrustum,
		['_tempV30',function(){return this._tempV30=new Vector3();},'_tempV31',function(){return this._tempV31=new Vector3();},'_tempV32',function(){return this._tempV32=new Vector3();},'_tempV33',function(){return this._tempV33=new Vector3();},'_tempV34',function(){return this._tempV34=new Vector3();},'_tempV35',function(){return this._tempV35=new Vector3();},'_tempV36',function(){return this._tempV36=new Vector3();},'_tempV37',function(){return this._tempV37=new Vector3();}
		]);
		return BoundFrustum;
	})()


	/**
	*<code>BoundSphere</code> 类用于创建包围球。
	*/
	//class laya.d3.math.BoundSphere
	var BoundSphere=(function(){
		function BoundSphere(center,radius){
			this.center=null;
			this.radius=NaN;
			this.center=center;
			this.radius=radius;
		}

		__class(BoundSphere,'laya.d3.math.BoundSphere');
		var __proto=BoundSphere.prototype;
		__proto.toDefault=function(){
			this.center.toDefault();
			this.radius=0;
		}

		BoundSphere.createFromSubPoints=function(points,start,count,out){
			if (points==null){
				throw new Error("points");
			}
			if (start < 0 || start >=points.length){
				throw new Error("start"+start+"Must be in the range [0, "+(points.length-1)+"]");
			}
			if (count < 0 || (start+count)> points.length){
				throw new Error("count"+count+"Must be in the range <= "+points.length+"}");
			};
			var upperEnd=start+count;
			var center=BoundSphere._tempVector3;
			center.elements[0]=0;
			center.elements[1]=0;
			center.elements[2]=0;
			for (var i=start;i < upperEnd;++i){
				Vector3.add(points[i],center,center);
			};
			var outCenter=out.center;
			Vector3.scale(center,1 / count,outCenter);
			var radius=0.0;
			for (i=start;i < upperEnd;++i){
				var distance=Vector3.distanceSquared(outCenter,points[i]);
				if (distance > radius)
					radius=distance;
			}
			out.radius=Math.sqrt(radius);
		}

		BoundSphere.createfromPoints=function(points,out){
			if (points==null){
				throw new Error("points");
			}
			BoundSphere.createFromSubPoints(points,0,points.length,out);
		}

		__static(BoundSphere,
		['_tempVector3',function(){return this._tempVector3=new Vector3();}
		]);
		return BoundSphere;
	})()


	/**
	*<code>Collision</code> 类用于检测碰撞。
	*/
	//class laya.d3.math.Collision
	var Collision=(function(){
		/**
		*创建一个 <code>Collision</code> 实例。
		*/
		function Collision(){}
		__class(Collision,'laya.d3.math.Collision');
		Collision.distancePlaneToPoint=function(plane,point){
			var dot=Vector3.dot(plane.normal,point);
			return dot-plane.distance;
		}

		Collision.distanceBoxToPoint=function(box,point){
			var boxMine=box.min.elements;
			var boxMineX=boxMine[0];
			var boxMineY=boxMine[1];
			var boxMineZ=boxMine[2];
			var boxMaxe=box.max.elements;
			var boxMaxeX=boxMaxe[0];
			var boxMaxeY=boxMaxe[1];
			var boxMaxeZ=boxMaxe[2];
			var pointe=point.elements;
			var pointeX=pointe[0];
			var pointeY=pointe[1];
			var pointeZ=pointe[2];
			var distance=0;
			if (pointeX < boxMineX)
				distance+=(boxMineX-pointeX)*(boxMineX-pointeX);
			if (pointeX > boxMaxeX)
				distance+=(boxMaxeX-pointeX)*(boxMaxeX-pointeX);
			if (pointeY < boxMineY)
				distance+=(boxMineY-pointeY)*(boxMineY-pointeY);
			if (pointeY > boxMaxeY)
				distance+=(boxMaxeY-pointeY)*(boxMaxeY-pointeY);
			if (pointeZ < boxMineZ)
				distance+=(boxMineZ-pointeZ)*(boxMineZ-pointeZ);
			if (pointeZ > boxMaxeZ)
				distance+=(boxMaxeZ-pointeZ)*(boxMaxeZ-pointeZ);
			return Math.sqrt(distance);
		}

		Collision.distanceBoxToBox=function(box1,box2){
			var box1Mine=box1.min.elements;
			var box1MineX=box1Mine[0];
			var box1MineY=box1Mine[1];
			var box1MineZ=box1Mine[2];
			var box1Maxe=box1.max.elements;
			var box1MaxeX=box1Maxe[0];
			var box1MaxeY=box1Maxe[1];
			var box1MaxeZ=box1Maxe[2];
			var box2Mine=box2.min.elements;
			var box2MineX=box2Mine[0];
			var box2MineY=box2Mine[1];
			var box2MineZ=box2Mine[2];
			var box2Maxe=box2.max.elements;
			var box2MaxeX=box2Maxe[0];
			var box2MaxeY=box2Maxe[1];
			var box2MaxeZ=box2Maxe[2];
			var distance=0;
			var delta=NaN;
			if (box1MineX > box2MaxeX){
				delta=box1MineX-box2MaxeX;
				distance+=delta *delta;
				}else if (box2MineX > box1MaxeX){
				delta=box2MineX-box1MaxeX;
				distance+=delta *delta;
			}
			if (box1MineY > box2MaxeY){
				delta=box1MineY-box2MaxeY;
				distance+=delta *delta;
				}else if (box2MineY > box1MaxeY){
				delta=box2MineY-box1MaxeY;
				distance+=delta *delta;
			}
			if (box1MineZ > box2MaxeZ){
				delta=box1MineZ-box2MaxeZ;
				distance+=delta *delta;
				}else if (box2MineZ > box1MaxeZ){
				delta=box2MineZ-box1MaxeZ;
				distance+=delta *delta;
			}
			return Math.sqrt(distance);
		}

		Collision.distanceSphereToPoint=function(sphere,point){
			var distance=Math.sqrt(Vector3.distanceSquared(sphere.center,point));
			distance-=sphere.radius;
			return Math.max(distance,0);
		}

		Collision.distanceSphereToSphere=function(sphere1,sphere2){
			var distance=Math.sqrt(Vector3.distanceSquared(sphere1.center,sphere2.center));
			distance-=sphere1.radius+sphere2.radius;
			return Math.max(distance,0);
		}

		Collision.intersectsRayAndTriangleRD=function(ray,vertex1,vertex2,vertex3,out){
			var rayO=ray.origin;
			var rayOe=rayO.elements;
			var rayOeX=rayOe[0];
			var rayOeY=rayOe[1];
			var rayOeZ=rayOe[2];
			var rayD=ray.direction;
			var rayDe=rayD.elements;
			var rayDeX=rayDe[0];
			var rayDeY=rayDe[1];
			var rayDeZ=rayDe[2];
			var v1e=vertex1.elements;
			var v1eX=v1e[0];
			var v1eY=v1e[1];
			var v1eZ=v1e[2];
			var v2e=vertex2.elements;
			var v2eX=v2e[0];
			var v2eY=v2e[1];
			var v2eZ=v2e[2];
			var v3e=vertex3.elements;
			var v3eX=v3e[0];
			var v3eY=v3e[1];
			var v3eZ=v3e[2];
			var _tempV30e=Collision._tempV30.elements;
			var _tempV30eX=_tempV30e[0];
			var _tempV30eY=_tempV30e[1];
			var _tempV30eZ=_tempV30e[2];
			_tempV30eX=v2eX-v1eX;
			_tempV30eY=v2eY-v1eY;
			_tempV30eZ=v2eZ-v1eZ;
			var _tempV31e=Collision._tempV31.elements;
			var _tempV31eX=_tempV31e[0];
			var _tempV31eY=_tempV31e[1];
			var _tempV31eZ=_tempV31e[2];
			_tempV31eX=v3eX-v1eX;
			_tempV31eY=v3eY-v1eY;
			_tempV31eZ=v3eZ-v1eZ;
			var _tempV32e=Collision._tempV32.elements;
			var _tempV32eX=_tempV32e[0];
			var _tempV32eY=_tempV32e[1];
			var _tempV32eZ=_tempV32e[2];
			_tempV32eX=(rayDeY *_tempV31eZ)-(rayDeZ *_tempV31eY);
			_tempV32eY=(rayDeZ *_tempV31eX)-(rayDeX *_tempV31eZ);
			_tempV32eZ=(rayDeX *_tempV31eY)-(rayDeY *_tempV31eX);
			var determinant=(_tempV30eX *_tempV32eX)+(_tempV30eY *_tempV32eY)+(_tempV30eZ *_tempV32eZ);
			if (MathUtils3D.isZero(determinant)){
				out=0;
				return false;
			};
			var inversedeterminant=1 / determinant;
			var _tempV33e=Collision._tempV33.elements;
			var _tempV33eX=_tempV33e[0];
			var _tempV33eY=_tempV33e[1];
			var _tempV33eZ=_tempV33e[2];
			_tempV33eX=rayOeX-v1eX;
			_tempV33eY=rayOeY-v1eY;
			_tempV33eZ=rayOeZ-v1eZ;
			var triangleU=(_tempV33eX *_tempV32eX)+(_tempV33eY *_tempV32eY)+(_tempV33eZ *_tempV32eZ);
			triangleU *=inversedeterminant;
			if (triangleU < 0 || triangleU > 1){
				out=0;
				return false;
			};
			var _tempV34e=Collision._tempV34.elements;
			var _tempV34eX=_tempV34e[0];
			var _tempV34eY=_tempV34e[1];
			var _tempV34eZ=_tempV34e[2];
			_tempV34eX=(_tempV33eY *_tempV30eZ)-(_tempV33eZ *_tempV30eY);
			_tempV34eY=(_tempV33eZ *_tempV30eX)-(_tempV33eX *_tempV30eZ);
			_tempV34eZ=(_tempV33eX *_tempV30eY)-(_tempV33eY *_tempV30eX);
			var triangleV=((rayDeX *_tempV34eX)+(rayDeY *_tempV34eY))+(rayDeZ *_tempV34eZ);
			triangleV *=inversedeterminant;
			if (triangleV < 0 || triangleU+triangleV > 1){
				out=0;
				return false;
			};
			var raydistance=(_tempV31eX *_tempV34eX)+(_tempV31eY *_tempV34eY)+(_tempV31eZ *_tempV34eZ);
			raydistance *=inversedeterminant;
			if (raydistance < 0){
				out=0;
				return false;
			}
			out=raydistance;
			return true;
		}

		Collision.intersectsRayAndTriangleRP=function(ray,vertex1,vertex2,vertex3,out){
			var distance=NaN;
			if (!Collision.intersectsRayAndTriangleRD(ray,vertex1,vertex2,vertex3,distance)){
				out=Vector3.ZERO;
				return false;
			}
			Vector3.scale(ray.direction,distance,Collision._tempV30);
			Vector3.add(ray.origin,Collision._tempV30,out);
			return true;
		}

		Collision.intersectsRayAndPoint=function(ray,point){
			Vector3.subtract(ray.origin,point,Collision._tempV30);
			var b=Vector3.dot(Collision._tempV30,ray.direction);
			var c=Vector3.dot(Collision._tempV30,Collision._tempV30)-MathUtils3D.zeroTolerance;
			if (c > 0 && b > 0)
				return false;
			var discriminant=b *b-c;
			if (discriminant < 0)
				return false;
			return true;
		}

		Collision.intersectsRayAndRay=function(ray1,ray2,out){
			var ray1o=ray1.origin;
			var ray1oe=ray1o.elements;
			var ray1oeX=ray1oe[0];
			var ray1oeY=ray1oe[1];
			var ray1oeZ=ray1oe[2];
			var ray1d=ray1.direction;
			var ray1de=ray1d.elements;
			var ray1deX=ray1de[0];
			var ray1deY=ray1de[1];
			var ray1deZ=ray1de[2];
			var ray2o=ray2.origin;
			var ray2oe=ray2o.elements;
			var ray2oeX=ray2oe[0];
			var ray2oeY=ray2oe[1];
			var ray2oeZ=ray2oe[2];
			var ray2d=ray2.direction;
			var ray2de=ray2d.elements;
			var ray2deX=ray2de[0];
			var ray2deY=ray2de[1];
			var ray2deZ=ray2de[2];
			Vector3.cross(ray1d,ray2d,Collision._tempV30);
			var tempV3e=Collision._tempV30.elements;
			var denominator=Vector3.scalarLength(Collision._tempV30);
			if (MathUtils3D.isZero(denominator)){
				if (MathUtils3D.nearEqual(ray2oeX,ray1oeX)&& MathUtils3D.nearEqual(ray2oeY,ray1oeY)&& MathUtils3D.nearEqual(ray2oeZ,ray1oeZ)){
					out=Vector3.ZERO;
					return true;
				}
			}
			denominator=denominator *denominator;
			var m11=ray2oeX-ray1oeX;
			var m12=ray2oeY-ray1oeY;
			var m13=ray2oeZ-ray1oeZ;
			var m21=ray2deX;
			var m22=ray2deY;
			var m23=ray2deZ;
			var m31=tempV3e[0];
			var m32=tempV3e[1];
			var m33=tempV3e[2];
			var dets=m11 *m22 *m33+m12 *m23 *m31+m13 *m21 *m32-m11 *m23 *m32-m12 *m21 *m33-m13 *m22 *m31;
			m21=ray1deX;
			m22=ray1deY;
			m23=ray1deZ;
			var dett=m11 *m22 *m33+m12 *m23 *m31+m13 *m21 *m32-m11 *m23 *m32-m12 *m21 *m33-m13 *m22 *m31;
			var s=dets / denominator;
			var t=dett / denominator;
			Vector3.scale(ray1d,s,Collision._tempV30);
			Vector3.scale(ray2d,s,Collision._tempV31);
			Vector3.add(ray1o,Collision._tempV30,Collision._tempV32);
			Vector3.add(ray2o,Collision._tempV31,Collision._tempV33);
			var point1e=Collision._tempV32.elements;
			var point2e=Collision._tempV33.elements;
			if (!MathUtils3D.nearEqual(point2e[0],point1e[0])|| !MathUtils3D.nearEqual(point2e[1],point1e[1])|| !MathUtils3D.nearEqual(point2e[2],point1e[2])){
				out=Vector3.ZERO;
				return false;
			}
			out=Collision._tempV32;
			return true;
		}

		Collision.intersectsPlaneAndTriangle=function(plane,vertex1,vertex2,vertex3){
			var test1=Collision.intersectsPlaneAndPoint(plane,vertex1);
			var test2=Collision.intersectsPlaneAndPoint(plane,vertex2);
			var test3=Collision.intersectsPlaneAndPoint(plane,vertex3);
			if (test1==Plane.PlaneIntersectionType_Front && test2==Plane.PlaneIntersectionType_Front && test3==Plane.PlaneIntersectionType_Front)
				return Plane.PlaneIntersectionType_Front;
			if (test1==Plane.PlaneIntersectionType_Back && test2==Plane.PlaneIntersectionType_Back && test3==Plane.PlaneIntersectionType_Back)
				return Plane.PlaneIntersectionType_Back;
			return Plane.PlaneIntersectionType_Intersecting;
		}

		Collision.intersectsRayAndPlaneRD=function(ray,plane,out){
			var planeNor=plane.normal;
			var direction=Vector3.dot(planeNor,ray.direction);
			if (MathUtils3D.isZero(direction)){
				out=0;
				return false;
			};
			var position=Vector3.dot(planeNor,ray.origin);
			out=(-plane.distance-position)/ direction;
			if (out < 0){
				out=0;
				return false;
			}
			return true;
		}

		Collision.intersectsRayAndPlaneRP=function(ray,plane,out){
			var distance=NaN;
			if (!Collision.intersectsRayAndPlaneRD(ray,plane,distance)){
				out=Vector3.ZERO;
				return false;
			}
			Vector3.scale(ray.direction,distance,Collision._tempV30);
			Vector3.add(ray.origin,Collision._tempV30,Collision._tempV31);
			out=Collision._tempV31;
			return true;
		}

		Collision.intersectsRayAndBoxRD=function(ray,box,out){
			var rayoe=ray.origin.elements;
			var rayoeX=rayoe[0];
			var rayoeY=rayoe[1];
			var rayoeZ=rayoe[2];
			var rayde=ray.direction.elements;
			var raydeX=rayde[0];
			var raydeY=rayde[1];
			var raydeZ=rayde[2];
			var boxMine=box.min.elements;
			var boxMineX=boxMine[0];
			var boxMineY=boxMine[1];
			var boxMineZ=boxMine[2];
			var boxMaxe=box.max.elements;
			var boxMaxeX=boxMaxe[0];
			var boxMaxeY=boxMaxe[1];
			var boxMaxeZ=boxMaxe[2];
			out=0;
			var tmax=MathUtils3D.MaxValue;
			if (MathUtils3D.isZero(raydeX)){
				if (rayoeX < boxMineX || rayoeX > boxMaxeX){
					out=0;
					return false;
				}
				}else {
				var inverse=1 / raydeX;
				var t1=(boxMineX-rayoeX)*inverse;
				var t2=(boxMaxeX-rayoeX)*inverse;
				if (t1 > t2){
					var temp=t1;
					t1=t2;
					t2=temp;
				}
				out=Math.max(t1,out);
				tmax=Math.min(t2,tmax);
				if (out > tmax){
					out=0;
					return false;
				}
			}
			if (MathUtils3D.isZero(raydeY)){
				if (rayoeY < boxMineY || rayoeY > boxMaxeY){
					out=0;
					return false;
				}
				}else {
				var inverse1=1 / raydeY;
				var t3=(boxMineY-rayoeY)*inverse1;
				var t4=(boxMaxeY-rayoeY)*inverse1;
				if (t3 > t4){
					var temp1=t3;
					t3=t4;
					t4=temp1;
				}
				out=Math.max(t3,out);
				tmax=Math.min(t4,tmax);
				if (out > tmax){
					out=0;
					return false;
				}
			}
			if (MathUtils3D.isZero(raydeZ)){
				if (rayoeZ < boxMineZ || rayoeZ > boxMaxeZ){
					out=0;
					return false;
				}
				}else {
				var inverse2=1 / raydeZ;
				var t5=(boxMineZ-rayoeZ)*inverse2;
				var t6=(boxMaxeZ-rayoeZ)*inverse2;
				if (t5 > t6){
					var temp2=t5;
					t5=t6;
					t6=temp2;
				}
				out=Math.max(t5,out);
				tmax=Math.min(t6,tmax);
				if (out > tmax){
					out=0;
					return false;
				}
			}
			return true;
		}

		Collision.intersectsRayAndBoxRP=function(ray,box,out){
			var distance=NaN;
			if (!Collision.intersectsRayAndBoxRD(ray,box,distance)){
				out=Vector3.ZERO;
				return false;
			}
			Vector3.scale(ray.direction,distance,Collision._tempV30);
			Vector3.add(ray.origin,Collision._tempV30,Collision._tempV31);
			out=Collision._tempV31;
			return true;
		}

		Collision.intersectsRayAndSphereRD=function(ray,sphere,out){
			var sphereR=sphere.radius;
			Vector3.subtract(ray.origin,sphere.center,Collision._tempV30);
			var b=Vector3.dot(Collision._tempV30,ray.direction);
			var c=Vector3.dot(Collision._tempV30,Collision._tempV30)-(sphereR *sphereR);
			if (c > 0 && b > 0){
				out=0;
				return false;
			};
			var discriminant=b *b-c;
			if (discriminant < 0){
				out=0;
				return false;
			}
			out=-b-Math.sqrt(discriminant);
			if (out < 0)
				out=0;
			return true;
		}

		Collision.intersectsRayAndSphereRP=function(ray,sphere,out){
			var distance=NaN;
			if (!Collision.intersectsRayAndSphereRD(ray,sphere,distance)){
				out=Vector3.ZERO;
				return false;
			}
			Vector3.scale(ray.direction,distance,Collision._tempV30);
			Vector3.add(ray.origin,Collision._tempV30,Collision._tempV31);
			out=Collision._tempV31;
			return true;
		}

		Collision.intersectsSphereAndTriangle=function(sphere,vertex1,vertex2,vertex3){
			var sphereC=sphere.center;
			var sphereR=sphere.radius;
			Collision.closestPointPointTriangle(sphereC,vertex1,vertex2,vertex3,Collision._tempV30);
			Vector3.subtract(Collision._tempV30,sphereC,Collision._tempV31);
			var dot=Vector3.dot(Collision._tempV31,Collision._tempV31);
			return dot <=sphereR *sphereR;
		}

		Collision.intersectsPlaneAndPoint=function(plane,point){
			var distance=Vector3.dot(plane.normal,point)+plane.distance;
			if (distance > 0)
				return Plane.PlaneIntersectionType_Front;
			else if (distance < 0)
			return Plane.PlaneIntersectionType_Back;
			else
			return Plane.PlaneIntersectionType_Intersecting;
		}

		Collision.intersectsPlaneAndPlane=function(plane1,plane2){
			Vector3.cross(plane1.normal,plane2.normal,Collision._tempV30);
			var denominator=Vector3.dot(Collision._tempV30,Collision._tempV30);
			if (MathUtils3D.isZero(denominator))
				return false;
			return true;
		}

		Collision.intersectsPlaneAndPlaneRL=function(plane1,plane2,line){
			var plane1nor=plane1.normal;
			var plane2nor=plane2.normal;
			Vector3.cross(plane1nor,plane2nor,Collision._tempV34);
			var denominator=Vector3.dot(Collision._tempV34,Collision._tempV34);
			if (MathUtils3D.isZero(denominator))
				return false;
			Vector3.scale(plane2nor,plane1.distance,Collision._tempV30);
			Vector3.scale(plane1nor,plane2.distance,Collision._tempV31);
			Vector3.subtract(Collision._tempV30,Collision._tempV31,Collision._tempV32);
			Vector3.cross(Collision._tempV32,Collision._tempV34,Collision._tempV33);
			Vector3.normalize(Collision._tempV34,Collision._tempV34);
			line=new Ray(Collision._tempV33,Collision._tempV34);
			return true;
		}

		Collision.intersectsPlaneAndBox=function(plane,box){
			var planeD=plane.distance;
			var planeNor=plane.normal;
			var planeNore=planeNor.elements;
			var planeNoreX=planeNore[0];
			var planeNoreY=planeNore[1];
			var planeNoreZ=planeNore[2];
			var boxMine=box.min.elements;
			var boxMineX=boxMine[0];
			var boxMineY=boxMine[1];
			var boxMineZ=boxMine[2];
			var boxMaxe=box.max.elements;
			var boxMaxeX=boxMaxe[0];
			var boxMaxeY=boxMaxe[1];
			var boxMaxeZ=boxMaxe[2];
			Collision._tempV30.elements[0]=(planeNoreX > 0)? boxMineX :boxMaxeX;
			Collision._tempV30.elements[1]=(planeNoreY > 0)? boxMineY :boxMaxeY;
			Collision._tempV30.elements[2]=(planeNoreZ > 0)? boxMineZ :boxMaxeZ;
			Collision._tempV31.elements[0]=(planeNoreX > 0)? boxMaxeX :boxMineX;
			Collision._tempV31.elements[1]=(planeNoreY > 0)? boxMaxeY :boxMineY;
			Collision._tempV31.elements[2]=(planeNoreZ > 0)? boxMaxeZ :boxMineZ;
			var distance=Vector3.dot(planeNor,Collision._tempV30);
			if (distance+planeD > 0)
				return Plane.PlaneIntersectionType_Front;
			distance=Vector3.dot(planeNor,Collision._tempV31);
			if (distance+planeD < 0)
				return Plane.PlaneIntersectionType_Back;
			return Plane.PlaneIntersectionType_Intersecting;
		}

		Collision.intersectsPlaneAndSphere=function(plane,sphere){
			var sphereR=sphere.radius;
			var distance=Vector3.dot(plane.normal,sphere.center)+plane.distance;
			if (distance > sphereR)
				return Plane.PlaneIntersectionType_Front;
			if (distance <-sphereR)
				return Plane.PlaneIntersectionType_Back;
			return Plane.PlaneIntersectionType_Intersecting;
		}

		Collision.intersectsBoxAndBox=function(box1,box2){
			var box1Mine=box1.min.elements;
			var box1Maxe=box1.max.elements;
			var box2Mine=box2.min.elements;
			var box2Maxe=box2.max.elements;
			if (box1Mine[0] > box2Maxe[0] || box2Mine[0] > box1Maxe[0])
				return false;
			if (box1Mine[1] > box2Maxe[1] || box2Mine[1] > box1Maxe[1])
				return false;
			if (box1Mine[2] > box2Maxe[2] || box2Mine[2] > box1Maxe[2])
				return false;
			return true;
		}

		Collision.intersectsBoxAndSphere=function(box,sphere){
			var sphereC=sphere.center;
			var sphereR=sphere.radius;
			Vector3.Clamp(sphereC,box.min,box.max,Collision._tempV30);
			var distance=Vector3.distanceSquared(sphereC,Collision._tempV30);
			return distance <=sphereR *sphereR;
		}

		Collision.intersectsSphereAndSphere=function(sphere1,sphere2){
			var radiisum=sphere1.radius+sphere2.radius;
			return Vector3.distanceSquared(sphere1.center,sphere2.center)<=radiisum *radiisum;
		}

		Collision.boxContainsPoint=function(box,point){
			var boxMine=box.min.elements;
			var boxMaxe=box.max.elements;
			var pointe=point.elements;
			if (boxMine[0] <=pointe[0] && boxMaxe[0] >=pointe[0] && boxMine[1] <=pointe[1] && boxMaxe[1] >=pointe[1] && boxMine[2] <=pointe[2] && boxMaxe[2] >=pointe[2])
				return 1;
			return 0;
		}

		Collision.boxContainsBox=function(box1,box2){
			var box1Mine=box1.min.elements;
			var box1MineX=box1Mine[0];
			var box1MineY=box1Mine[1];
			var box1MineZ=box1Mine[2];
			var box1Maxe=box1.max.elements;
			var box1MaxeX=box1Maxe[0];
			var box1MaxeY=box1Maxe[1];
			var box1MaxeZ=box1Maxe[2];
			var box2Mine=box2.min.elements;
			var box2MineX=box2Mine[0];
			var box2MineY=box2Mine[1];
			var box2MineZ=box2Mine[2];
			var box2Maxe=box2.max.elements;
			var box2MaxeX=box2Maxe[0];
			var box2MaxeY=box2Maxe[1];
			var box2MaxeZ=box2Maxe[2];
			if (box1MaxeX < box2MineX || box1MineX > box2MaxeX)
				return 0;
			if (box1MaxeY < box2MineY || box1MineY > box2MaxeY)
				return 0;
			if (box1MaxeZ < box2MineZ || box1MineZ > box2MaxeZ)
				return 0;
			if (box1MineX <=box2MineX && box2MaxeX <=box2MineX && box1MineY <=box2MineY && box2MaxeY <=box1MaxeY && box1MineZ <=box2MineZ && box2MaxeZ <=box1MaxeZ){
				return 1;
			}
			return 2;
		}

		Collision.boxContainsSphere=function(box,sphere){
			var boxMin=box.min;
			var boxMine=boxMin.elements;
			var boxMineX=boxMine[0];
			var boxMineY=boxMine[1];
			var boxMineZ=boxMine[2];
			var boxMax=box.max;
			var boxMaxe=boxMax.elements;
			var boxMaxeX=boxMaxe[0];
			var boxMaxeY=boxMaxe[1];
			var boxMaxeZ=boxMaxe[2];
			var sphereC=sphere.center;
			var sphereCe=sphereC.elements;
			var sphereCeX=sphereCe[0];
			var sphereCeY=sphereCe[1];
			var sphereCeZ=sphereCe[2];
			var sphereR=sphere.radius;
			Vector3.Clamp(sphereC,boxMin,boxMax,Collision._tempV30);
			var distance=Vector3.distanceSquared(sphereC,Collision._tempV30);
			if (distance > sphereR *sphereR)
				return 0;
			if ((((boxMineX+sphereR <=sphereCeX)&& (sphereCeX <=boxMaxeX-sphereR))&& ((boxMaxeX-boxMineX > sphereR)&&
				(boxMineY+sphereR <=sphereCeY)))&& (((sphereCeY <=boxMaxeY-sphereR)&& (boxMaxeY-boxMineY > sphereR))&&
			(((boxMineZ+sphereR <=sphereCeZ)&& (sphereCeZ <=boxMaxeZ-sphereR))&& (boxMaxeZ-boxMineZ > sphereR))))
			return 1;
			return 2;
		}

		Collision.sphereContainsPoint=function(sphere,point){
			if (Vector3.distanceSquared(point,sphere.center)<=sphere.radius *sphere.radius)
				return 1;
			return 0;
		}

		Collision.sphereContainsTriangle=function(sphere,vertex1,vertex2,vertex3){
			var test1=Collision.sphereContainsPoint(sphere,vertex1);
			var test2=Collision.sphereContainsPoint(sphere,vertex2);
			var test3=Collision.sphereContainsPoint(sphere,vertex3);
			if (test1==1 && test2==1 && test3==1)
				return 1;
			if (Collision.intersectsSphereAndTriangle(sphere,vertex1,vertex2,vertex3))
				return 2;
			return 0;
		}

		Collision.sphereContainsBox=function(sphere,box){
			var sphereC=sphere.center;
			var sphereCe=sphereC.elements;
			var sphereCeX=sphereCe[0];
			var sphereCeY=sphereCe[1];
			var sphereCeZ=sphereCe[2];
			var sphereR=sphere.radius;
			var boxMin=box.min;
			var boxMine=boxMin.elements;
			var boxMineX=boxMine[0];
			var boxMineY=boxMine[1];
			var boxMineZ=boxMine[2];
			var boxMax=box.max;
			var boxMaxe=boxMax.elements;
			var boxMaxeX=boxMaxe[0];
			var boxMaxeY=boxMaxe[1];
			var boxMaxeZ=boxMaxe[2];
			var _tempV30e=Collision._tempV30.elements;
			var _tempV30eX=_tempV30e[0];
			var _tempV30eY=_tempV30e[1];
			var _tempV30eZ=_tempV30e[2];
			if (!Collision.intersectsBoxAndSphere(box,sphere))
				return 0;
			var radiusSquared=sphereR *sphereR;
			_tempV30eX=sphereCeX-boxMineX;
			_tempV30eY=sphereCeY-boxMaxeY;
			_tempV30eZ=sphereCeZ-boxMaxeZ;
			if (Vector3.scalarLengthSquared(Collision._tempV30)> radiusSquared)
				return 2;
			_tempV30eX=sphereCeX-boxMaxeX;
			_tempV30eY=sphereCeY-boxMaxeY;
			_tempV30eZ=sphereCeZ-boxMaxeZ;
			if (Vector3.scalarLengthSquared(Collision._tempV30)> radiusSquared)
				return 2;
			_tempV30eX=sphereCeX-boxMaxeX;
			_tempV30eY=sphereCeY-boxMineY;
			_tempV30eZ=sphereCeZ-boxMaxeZ;
			if (Vector3.scalarLengthSquared(Collision._tempV30)> radiusSquared)
				return 2;
			_tempV30eX=sphereCeX-boxMineX;
			_tempV30eY=sphereCeY-boxMineY;
			_tempV30eZ=sphereCeZ-boxMaxeZ;
			if (Vector3.scalarLengthSquared(Collision._tempV30)> radiusSquared)
				return 2;
			_tempV30eX=sphereCeX-boxMineX;
			_tempV30eY=sphereCeY-boxMaxeY;
			_tempV30eZ=sphereCeZ-boxMineZ;
			if (Vector3.scalarLengthSquared(Collision._tempV30)> radiusSquared)
				return 2;
			_tempV30eX=sphereCeX-boxMaxeX;
			_tempV30eY=sphereCeY-boxMaxeY;
			_tempV30eZ=sphereCeZ-boxMineZ;
			if (Vector3.scalarLengthSquared(Collision._tempV30)> radiusSquared)
				return 2;
			_tempV30eX=sphereCeX-boxMaxeX;
			_tempV30eY=sphereCeY-boxMineY;
			_tempV30eZ=sphereCeZ-boxMineZ;
			if (Vector3.scalarLengthSquared(Collision._tempV30)> radiusSquared)
				return 2;
			_tempV30eX=sphereCeX-boxMineX;
			_tempV30eY=sphereCeY-boxMineY;
			_tempV30eZ=sphereCeZ-boxMineZ;
			if (Vector3.scalarLengthSquared(Collision._tempV30)> radiusSquared)
				return 2;
			return 1;
		}

		Collision.sphereContainsSphere=function(sphere1,sphere2){
			var sphere1R=sphere1.radius;
			var sphere2R=sphere2.radius;
			var distance=Vector3.distance(sphere1.center,sphere2.center);
			if (sphere1R+sphere2R < distance)
				return 0;
			if (sphere1R-sphere2R < distance)
				return 2;
			return 1;
		}

		Collision.closestPointPointTriangle=function(point,vertex1,vertex2,vertex3,out){
			Vector3.subtract(vertex2,vertex1,Collision._tempV30);
			Vector3.subtract(vertex3,vertex1,Collision._tempV31);
			Vector3.subtract(point,vertex1,Collision._tempV32);
			Vector3.subtract(point,vertex2,Collision._tempV33);
			Vector3.subtract(point,vertex3,Collision._tempV34);
			var d1=Vector3.dot(Collision._tempV30,Collision._tempV32);
			var d2=Vector3.dot(Collision._tempV31,Collision._tempV32);
			var d3=Vector3.dot(Collision._tempV30,Collision._tempV33);
			var d4=Vector3.dot(Collision._tempV31,Collision._tempV33);
			var d5=Vector3.dot(Collision._tempV30,Collision._tempV34);
			var d6=Vector3.dot(Collision._tempV31,Collision._tempV34);
			if (d1 <=0 && d2 <=0){
				vertex1.cloneTo(out);
				return;
			}
			if (d3 >=0 && d4 <=d3){
				vertex2.cloneTo(out);
				return;
			};
			var vc=d1 *d4-d3 *d2;
			if (vc <=0 && d1 >=0 && d3 <=0){
				var v=d1 / (d1-d3);
				Vector3.scale(Collision._tempV30,v,out);
				Vector3.add(vertex1,out,out);
				return;
			}
			if (d6 >=0 && d5 <=d6){
				vertex3.cloneTo(out);
				return;
			};
			var vb=d5 *d2-d1 *d6;
			if (vb <=0 && d2 >=0 && d6 <=0){
				var w=d2 / (d2-d6);
				Vector3.scale(Collision._tempV31,w,out);
				Vector3.add(vertex1,out,out);
				return;
			};
			var va=d3 *d6-d5 *d4;
			if (va <=0 && (d4-d3)>=0 && (d5-d6)>=0){
				var w3=(d4-d3)/ ((d4-d3)+(d5-d6));
				Vector3.subtract(vertex3,vertex2,out);
				Vector3.scale(out,w3,out);
				Vector3.add(vertex2,out,out);
				return;
			};
			var denom=1 / (va+vb+vc);
			var v2=vb *denom;
			var w2=vc *denom;
			Vector3.scale(Collision._tempV30,v2,Collision._tempV35);
			Vector3.scale(Collision._tempV31,w2,Collision._tempV36);
			Vector3.add(Collision._tempV35,Collision._tempV36,out);
			Vector3.add(vertex1,out,out);
		}

		Collision.closestPointPlanePoint=function(plane,point,out){
			var planeN=plane.normal;
			var t=Vector3.dot(planeN,point)-plane.distance;
			Vector3.scale(planeN,t,Collision._tempV30);
			Vector3.subtract(point,Collision._tempV30,out);
		}

		Collision.closestPointBoxPoint=function(box,point,out){
			Vector3.max(point,box.min,Collision._tempV30);
			Vector3.min(Collision._tempV30,box.max,out);
		}

		Collision.closestPointSpherePoint=function(sphere,point,out){
			var sphereC=sphere.center;
			Vector3.subtract(point,sphereC,out);
			Vector3.normalize(out,out);
			Vector3.scale(out,sphere.radius,out);
			Vector3.add(out,sphereC,out);
		}

		Collision.closestPointSphereSphere=function(sphere1,sphere2,out){
			var sphere1C=sphere1.center;
			Vector3.subtract(sphere2.center,sphere1C,out);
			Vector3.normalize(out,out);
			Vector3.scale(out,sphere1.radius,out);
			Vector3.add(out,sphere1C,out);
		}

		__static(Collision,
		['_tempV30',function(){return this._tempV30=new Vector3();},'_tempV31',function(){return this._tempV31=new Vector3();},'_tempV32',function(){return this._tempV32=new Vector3();},'_tempV33',function(){return this._tempV33=new Vector3();},'_tempV34',function(){return this._tempV34=new Vector3();},'_tempV35',function(){return this._tempV35=new Vector3();},'_tempV36',function(){return this._tempV36=new Vector3();}
		]);
		return Collision;
	})()


	/**
	*<code>ContainmentType</code> 类用于定义空间物体位置关系。
	*/
	//class laya.d3.math.ContainmentType
	var ContainmentType=(function(){
		function ContainmentType(){};
		__class(ContainmentType,'laya.d3.math.ContainmentType');
		ContainmentType.Disjoint=0;
		ContainmentType.Contains=1;
		ContainmentType.Intersects=2;
		return ContainmentType;
	})()


	/**
	*<code>MathUtils</code> 类用于创建数学工具。
	*/
	//class laya.d3.math.MathUtils3D
	var MathUtils3D=(function(){
		/**
		*创建一个 <code>MathUtils</code> 实例。
		*/
		function MathUtils3D(){}
		__class(MathUtils3D,'laya.d3.math.MathUtils3D');
		MathUtils3D.isZero=function(v){
			return Math.abs(v)< MathUtils3D.zeroTolerance;
		}

		MathUtils3D.nearEqual=function(n1,n2){
			if (MathUtils3D.isZero(n1-n2))
				return true;
			return false;
		}

		__static(MathUtils3D,
		['zeroTolerance',function(){return this.zeroTolerance=1e-6;},'MaxValue',function(){return this.MaxValue=3.40282347e+38;},'MinValue',function(){return this.MinValue=-3.40282347e+38;}
		]);
		return MathUtils3D;
	})()


	/**
	*<code>Matrix3x3</code> 类用于创建3x3矩阵。
	*/
	//class laya.d3.math.Matrix3x3
	var Matrix3x3=(function(){
		function Matrix3x3(){
			//this.elements=null;
			var e=this.elements=new Float32Array(9);
			e[0]=1;
			e[1]=0;
			e[2]=0;
			e[3]=0;
			e[4]=1;
			e[5]=0;
			e[6]=0;
			e[7]=0;
			e[8]=1;
		}

		__class(Matrix3x3,'laya.d3.math.Matrix3x3');
		var __proto=Matrix3x3.prototype;
		/**
		*计算3x3矩阵的行列式
		*@return 矩阵的行列式
		*/
		__proto.determinant=function(){
			var f=this.elements;
			var a00=f[0],a01=f[1],a02=f[2];
			var a10=f[3],a11=f[4],a12=f[5];
			var a20=f[6],a21=f[7],a22=f[8];
			return a00 *(a22 *a11-a12 *a21)+a01 *(-a22 *a10+a12 *a20)+a02 *(a21 *a10-a11 *a20);
		}

		/**
		*通过一个二维向量转换3x3矩阵
		*@param tra 转换向量
		*@param out 输出矩阵
		*/
		__proto.translate=function(trans,out){
			var e=out.elements;
			var f=this.elements;
			var g=trans.elements;
			var a00=f[0],a01=f[1],a02=f[2];
			var a10=f[3],a11=f[4],a12=f[5];
			var a20=f[6],a21=f[7],a22=f[8];
			var x=g[0],y=g[1];
			e[0]=a00;
			e[1]=a01;
			e[2]=a02;
			e[3]=a10;
			e[4]=a11;
			e[5]=a12;
			e[6]=x *a00+y *a10+a20;
			e[7]=x *a01+y *a11+a21;
			e[8]=x *a02+y *a12+a22;
		}

		/**
		*根据指定角度旋转3x3矩阵
		*@param rad 旋转角度
		*@param out 输出矩阵
		*/
		__proto.rotate=function(rad,out){
			var e=out.elements;
			var f=this.elements;
			var a00=f[0],a01=f[1],a02=f[2];
			var a10=f[3],a11=f[4],a12=f[5];
			var a20=f[6],a21=f[7],a22=f[8];
			var s=Math.sin(rad);
			var c=Math.cos(rad);
			e[0]=c *a00+s *a10;
			e[1]=c *a01+s *a11;
			e[2]=c *a02+s *a12;
			e[3]=c *a10-s *a00;
			e[4]=c *a11-s *a01;
			e[5]=c *a12-s *a02;
			e[6]=a20;
			e[7]=a21;
			e[8]=a22;
		}

		/**
		*根据制定缩放3x3矩阵
		*@param scale 缩放值
		*@param out 输出矩阵
		*/
		__proto.scale=function(scale,out){
			var e=out.elements;
			var f=this.elements;
			var g=scale.elements;
			var x=g[0],y=g[1];
			e[0]=x *f[0];
			e[1]=x *f[1];
			e[2]=x *f[2];
			e[3]=y *f[3];
			e[4]=y *f[4];
			e[5]=y *f[5];
			e[6]=f[6];
			e[7]=f[7];
			e[8]=f[8];
		}

		/**
		*计算3x3矩阵的逆矩阵
		*@param out 输出的逆矩阵
		*/
		__proto.invert=function(out){
			var e=out.elements;
			var f=this.elements;
			var a00=f[0],a01=f[1],a02=f[2];
			var a10=f[3],a11=f[4],a12=f[5];
			var a20=f[6],a21=f[7],a22=f[8];
			var b01=a22 *a11-a12 *a21;
			var b11=-a22 *a10+a12 *a20;
			var b21=a21 *a10-a11 *a20;
			var det=a00 *b01+a01 *b11+a02 *b21;
			if (!det){
				out=null;
			}
			det=1.0 / det;
			e[0]=b01 *det;
			e[1]=(-a22 *a01+a02 *a21)*det;
			e[2]=(a12 *a01-a02 *a11)*det;
			e[3]=b11 *det;
			e[4]=(a22 *a00-a02 *a20)*det;
			e[5]=(-a12 *a00+a02 *a10)*det;
			e[6]=b21 *det;
			e[7]=(-a21 *a00+a01 *a20)*det;
			e[8]=(a11 *a00-a01 *a10)*det;
		}

		/**
		*计算3x3矩阵的转置矩阵
		*@param out 输出矩阵
		*/
		__proto.transpose=function(out){
			var e=out.elements;
			var f=this.elements;
			if (out===this){
				var a01=f[1],a02=f[2],a12=f[5];
				e[1]=f[3];
				e[2]=f[6];
				e[3]=a01;
				e[5]=f[7];
				e[6]=a02;
				e[7]=a12;
				}else {
				e[0]=f[0];
				e[1]=f[3];
				e[2]=f[6];
				e[3]=f[1];
				e[4]=f[4];
				e[5]=f[7];
				e[6]=f[2];
				e[7]=f[5];
				e[8]=f[8];
			}
		}

		/**设置已有的矩阵为单位矩阵*/
		__proto.identity=function(){
			var e=this.elements;
			e[0]=1;
			e[1]=0;
			e[2]=0;
			e[3]=0;
			e[4]=1;
			e[5]=0;
			e[6]=0;
			e[7]=0;
			e[8]=1;
		}

		/**
		*克隆一个3x3矩阵
		*@param out 输出的3x3矩阵
		*/
		__proto.cloneTo=function(out){
			var i,s,d;
			s=this.elements;
			d=out.elements;
			if (s===d){
				return;
			}
			for (i=0;i < 9;++i){
				d[i]=s[i];
			}
		}

		/**
		*从一个3x3矩阵复制
		*@param sou 源3x3矩阵
		*/
		__proto.copyFrom=function(sou){
			var i,s,d;
			s=sou.elements;
			d=this.elements;
			if (s===d){
				return;
			}
			for (i=0;i < 9;++i){
				d[i]=s[i];
			}
		}

		/**
		*从一个数组复制
		*@param sou 源Float32Array数组
		*/
		__proto.copyFromArray=function(sou){
			var i,d;
			d=this.elements;
			if (sou===d){
				return;
			}
			for (i=0;i < 9;++i){
				d[i]=sou[i];
			}
		}

		Matrix3x3.createFromTranslation=function(trans,out){
			var e=out.elements;
			var g=trans.elements;
			out[0]=1;
			out[1]=0;
			out[2]=0;
			out[3]=0;
			out[4]=1;
			out[5]=0;
			out[6]=g[0];
			out[7]=g[1];
			out[8]=1;
		}

		Matrix3x3.createFromRotation=function(rad,out){
			var e=out.elements;
			var s=Math.sin(rad),c=Math.cos(rad);
			e[0]=c;
			e[1]=s;
			e[2]=0;
			e[3]=-s;
			e[4]=c;
			e[5]=0;
			e[6]=0;
			e[7]=0;
			e[8]=1;
		}

		Matrix3x3.createFromScaling=function(scale,out){
			var e=out.elements;
			var g=scale.elements;
			e[0]=g[0];
			e[1]=0;
			e[2]=0;
			e[3]=0;
			e[4]=g[1];
			e[5]=0;
			e[6]=0;
			e[7]=0;
			e[8]=1;
		}

		Matrix3x3.createFromMatrix4x4=function(sou,out){
			out[0]=sou[0];
			out[1]=sou[1];
			out[2]=sou[2];
			out[3]=sou[4];
			out[4]=sou[5];
			out[5]=sou[6];
			out[6]=sou[8];
			out[7]=sou[9];
			out[8]=sou[10];
		}

		Matrix3x3.multiply=function(left,right,out){
			var e=out.elements;
			var f=left.elements;
			var g=right.elements;
			var a00=f[0],a01=f[1],a02=f[2];
			var a10=f[3],a11=f[4],a12=f[5];
			var a20=f[6],a21=f[7],a22=f[8];
			var b00=g[0],b01=g[1],b02=g[2];
			var b10=g[3],b11=g[4],b12=g[5];
			var b20=g[6],b21=g[7],b22=g[8];
			e[0]=b00 *a00+b01 *a10+b02 *a20;
			e[1]=b00 *a01+b01 *a11+b02 *a21;
			e[2]=b00 *a02+b01 *a12+b02 *a22;
			e[3]=b10 *a00+b11 *a10+b12 *a20;
			e[4]=b10 *a01+b11 *a11+b12 *a21;
			e[5]=b10 *a02+b11 *a12+b12 *a22;
			e[6]=b20 *a00+b21 *a10+b22 *a20;
			e[7]=b20 *a01+b21 *a11+b22 *a21;
			e[8]=b20 *a02+b21 *a12+b22 *a22;
		}

		Matrix3x3.DEFAULT=new Matrix3x3();
		return Matrix3x3;
	})()


	/**
	*<code>Matrix4x4</code> 类用于创建4x4矩阵。
	*/
	//class laya.d3.math.Matrix4x4
	var Matrix4x4=(function(){
		function Matrix4x4(m11,m12,m13,m14,m21,m22,m23,m24,m31,m32,m33,m34,m41,m42,m43,m44){
			//this.elements=null;
			(m11===void 0)&& (m11=1);
			(m12===void 0)&& (m12=0);
			(m13===void 0)&& (m13=0);
			(m14===void 0)&& (m14=0);
			(m21===void 0)&& (m21=0);
			(m22===void 0)&& (m22=1);
			(m23===void 0)&& (m23=0);
			(m24===void 0)&& (m24=0);
			(m31===void 0)&& (m31=0);
			(m32===void 0)&& (m32=0);
			(m33===void 0)&& (m33=1);
			(m34===void 0)&& (m34=0);
			(m41===void 0)&& (m41=0);
			(m42===void 0)&& (m42=0);
			(m43===void 0)&& (m43=0);
			(m44===void 0)&& (m44=1);
			var e=this.elements=new Float32Array(16);
			e[0]=m11;
			e[1]=m12;
			e[2]=m13;
			e[3]=m14;
			e[4]=m21;
			e[5]=m22;
			e[6]=m23;
			e[7]=m24;
			e[8]=m31;
			e[9]=m32;
			e[10]=m33;
			e[11]=m34;
			e[12]=m41;
			e[13]=m42;
			e[14]=m43;
			e[15]=m44;
		}

		__class(Matrix4x4,'laya.d3.math.Matrix4x4');
		var __proto=Matrix4x4.prototype;
		/**
		*判断两个4x4矩阵的值是否相等。
		*@param other 4x4矩阵
		*/
		__proto.equalsOtherMatrix=function(other){
			var e=this.elements;
			var oe=other.elements;
			return (MathUtils3D.nearEqual(e[0],oe[0])&&
			MathUtils3D.nearEqual(e[1],oe[1])&&
			MathUtils3D.nearEqual(e[2],oe[2])&&
			MathUtils3D.nearEqual(e[3],oe[3])&&
			MathUtils3D.nearEqual(e[4],oe[4])&&
			MathUtils3D.nearEqual(e[5],oe[5])&&
			MathUtils3D.nearEqual(e[6],oe[6])&&
			MathUtils3D.nearEqual(e[7],oe[7])&&
			MathUtils3D.nearEqual(e[8],oe[8])&&
			MathUtils3D.nearEqual(e[9],oe[9])&&
			MathUtils3D.nearEqual(e[10],oe[10])&&
			MathUtils3D.nearEqual(e[11],oe[11])&&
			MathUtils3D.nearEqual(e[12],oe[12])&&
			MathUtils3D.nearEqual(e[13],oe[13])&&
			MathUtils3D.nearEqual(e[14],oe[14])&&
			MathUtils3D.nearEqual(e[15],oe[15]));
		}

		/**
		*分解矩阵
		*@param translation 平移
		*@param rotation 旋转
		*@param scale 缩放
		*@return 是否成功
		*/
		__proto.decompose=function(translation,rotation,scale){
			var me=this.elements;
			var te=translation.elements;
			var re=rotation.elements;
			var se=scale.elements;
			te[0]=me[12];
			te[1]=me[13];
			te[2]=me[14];
			se[0]=Math.sqrt((me[0] *me[0])+(me[1] *me[1])+(me[2] *me[2]));
			se[1]=Math.sqrt((me[4] *me[4])+(me[5] *me[5])+(me[6] *me[6]));
			se[2]=Math.sqrt((me[8] *me[8])+(me[9] *me[9])+(me[10] *me[10]));
			if (MathUtils3D.isZero(se[0])|| MathUtils3D.isZero(se[1])|| MathUtils3D.isZero(se[2])){
				re[0]=re[1]=re[2]=0;
				re[3]=1;
				return false;
			};
			var rotationmatrix=new Matrix4x4();
			var rme=rotationmatrix.elements;
			rme[0]=me[0] / se[0];
			rme[1]=me[1] / se[0];
			rme[2]=me[2] / se[0];
			rme[4]=me[4] / se[1];
			rme[5]=me[5] / se[1];
			rme[6]=me[6] / se[1];
			rme[8]=me[8] / se[2];
			rme[9]=me[9] / se[2];
			rme[10]=me[10] / se[2];
			rotationmatrix[15]=1;
			Quaternion.createFromMatrix4x4(rotationmatrix,rotation);
			return true;
		}

		/**归一化矩阵 */
		__proto.normalize=function(){
			var v=this.elements;
			var c=v[0],d=v[1],e=v[2],g=Math.sqrt(c *c+d *d+e *e);
			if (g){
				if (g==1)
					return;
				}else {
				v[0]=0;
				v[1]=0;
				v[2]=0;
				return;
			}
			g=1 / g;
			v[0]=c *g;
			v[1]=d *g;
			v[2]=e *g;
		}

		/**计算矩阵的转置矩阵*/
		__proto.transpose=function(){
			var e,t;
			e=this.elements;
			t=e[1];
			e[1]=e[4];
			e[4]=t;
			t=e[2];
			e[2]=e[8];
			e[8]=t;
			t=e[3];
			e[3]=e[12];
			e[12]=t;
			t=e[6];
			e[6]=e[9];
			e[9]=t;
			t=e[7];
			e[7]=e[13];
			e[13]=t;
			t=e[11];
			e[11]=e[14];
			e[14]=t;
			return this;
		}

		/**
		*计算一个矩阵的逆矩阵
		*@param out 输出矩阵
		*/
		__proto.invert=function(out){
			var ae=this.elements;
			var oe=out.elements;
			var a00=ae[0],a01=ae[1],a02=ae[2],a03=ae[3],a10=ae[4],a11=ae[5],a12=ae[6],a13=ae[7],a20=ae[8],a21=ae[9],a22=ae[10],a23=ae[11],a30=ae[12],a31=ae[13],a32=ae[14],a33=ae[15],
			b00=a00 *a11-a01 *a10,b01=a00 *a12-a02 *a10,b02=a00 *a13-a03 *a10,b03=a01 *a12-a02 *a11,b04=a01 *a13-a03 *a11,b05=a02 *a13-a03 *a12,b06=a20 *a31-a21 *a30,b07=a20 *a32-a22 *a30,b08=a20 *a33-a23 *a30,b09=a21 *a32-a22 *a31,b10=a21 *a33-a23 *a31,b11=a22 *a33-a23 *a32,
			det=b00 *b11-b01 *b10+b02 *b09+b03 *b08-b04 *b07+b05 *b06;
			if (Math.abs(det)===0.0){
				return;
			}
			det=1.0 / det;
			oe[0]=(a11 *b11-a12 *b10+a13 *b09)*det;
			oe[1]=(a02 *b10-a01 *b11-a03 *b09)*det;
			oe[2]=(a31 *b05-a32 *b04+a33 *b03)*det;
			oe[3]=(a22 *b04-a21 *b05-a23 *b03)*det;
			oe[4]=(a12 *b08-a10 *b11-a13 *b07)*det;
			oe[5]=(a00 *b11-a02 *b08+a03 *b07)*det;
			oe[6]=(a32 *b02-a30 *b05-a33 *b01)*det;
			oe[7]=(a20 *b05-a22 *b02+a23 *b01)*det;
			oe[8]=(a10 *b10-a11 *b08+a13 *b06)*det;
			oe[9]=(a01 *b08-a00 *b10-a03 *b06)*det;
			oe[10]=(a30 *b04-a31 *b02+a33 *b00)*det;
			oe[11]=(a21 *b02-a20 *b04-a23 *b00)*det;
			oe[12]=(a11 *b07-a10 *b09-a12 *b06)*det;
			oe[13]=(a00 *b09-a01 *b07+a02 *b06)*det;
			oe[14]=(a31 *b01-a30 *b03-a32 *b00)*det;
			oe[15]=(a20 *b03-a21 *b01+a22 *b00)*det;
		}

		/**设置矩阵为单位矩阵*/
		__proto.identity=function(){
			var e=this.elements;
			e[1]=e[2]=e[3]=e[4]=e[6]=e[7]=e[8]=e[9]=e[11]=e[12]=e[13]=e[14]=0;
			e[0]=e[5]=e[10]=e[15]=1;
		}

		/**
		*克隆一个4x4矩阵
		*@param out 输出的4x4矩阵
		*/
		__proto.cloneTo=function(out){
			var i,s,d;
			s=this.elements;
			d=out.elements;
			if (s===d){
				return;
			}
			for (i=0;i < 16;++i){
				d[i]=s[i];
			}
		}

		/**
		*从一个4x4矩阵复制
		*@param sou 源4x4矩阵
		*/
		__proto.copyFrom=function(sou){
			var i,s,d;
			s=sou.elements;
			d=this.elements;
			if (s===d){
				return;
			}
			for (i=0;i < 16;++i){
				d[i]=s[i];
			}
		}

		/**
		*从一个数组复制
		*@param sou 源Float32Array数组
		*/
		__proto.copyFromArray=function(sou){
			var i,d;
			d=this.elements;
			if (sou===d){
				return;
			}
			for (i=0;i < 16;++i){
				d[i]=sou[i];
			}
		}

		Matrix4x4.createRotationX=function(rad,out){
			var oe=out.elements;
			var s=Math.sin(rad),c=Math.cos(rad);
			oe[1]=oe[2]=oe[3]=oe[4]=oe[7]=oe[8]=oe[11]=oe[12]=oe[13]=oe[14]=0;
			oe[0]=oe[15]=1;
			oe[5]=oe[10]=c;
			oe[6]=s;
			oe[9]=-s;
		}

		Matrix4x4.createRotationY=function(rad,out){
			var oe=out.elements;
			var s=Math.sin(rad),c=Math.cos(rad);
			oe[1]=oe[3]=oe[4]=oe[6]=oe[7]=oe[9]=oe[11]=oe[12]=oe[13]=oe[14]=0;
			oe[5]=oe[15]=1;
			oe[0]=oe[10]=c;
			oe[2]=-s;
			oe[8]=s;
		}

		Matrix4x4.createRotationZ=function(rad,out){
			var oe=out.elements;
			var s=Math.sin(rad),c=Math.cos(rad);
			oe[2]=oe[3]=oe[6]=oe[7]=oe[8]=oe[9]=oe[11]=oe[12]=oe[13]=oe[14]=0;
			oe[10]=oe[15]=1;
			oe[0]=oe[5]=c;
			oe[1]=s;
			oe[4]=-s;
		}

		Matrix4x4.createTranslate=function(trans,out){
			var te=trans.elements;
			var oe=out.elements;
			oe[4]=oe[8]=oe[1]=oe[9]=oe[2]=oe[6]=oe[3]=oe[7]=oe[11]=0;
			oe[0]=oe[5]=oe[10]=oe[15]=1;
			oe[12]=te[0];
			oe[13]=te[1];
			oe[14]=te[2];
		}

		Matrix4x4.createScaling=function(scale,out){
			var se=scale.elements;
			var oe=out.elements;
			oe[0]=se[0];
			oe[5]=se[1];
			oe[10]=se[2];
			oe[1]=oe[4]=oe[8]=oe[12]=oe[9]=oe[13]=oe[2]=oe[6]=oe[14]=oe[3]=oe[7]=oe[11]=0;
			oe[15]=1;
		}

		Matrix4x4.multiply=function(left,right,out){
			var i,e,a,b,ai0,ai1,ai2,ai3;
			e=out.elements;
			a=left.elements;
			b=right.elements;
			if (e===b){
				b=new Float32Array(16);
				for (i=0;i < 16;++i){
					b[i]=e[i];
				}
			}
			for (i=0;i < 4;i++){
				ai0=a[i];
				ai1=a[i+4];
				ai2=a[i+8];
				ai3=a[i+12];
				e[i]=ai0 *b[0]+ai1 *b[1]+ai2 *b[2]+ai3 *b[3];
				e[i+4]=ai0 *b[4]+ai1 *b[5]+ai2 *b[6]+ai3 *b[7];
				e[i+8]=ai0 *b[8]+ai1 *b[9]+ai2 *b[10]+ai3 *b[11];
				e[i+12]=ai0 *b[12]+ai1 *b[13]+ai2 *b[14]+ai3 *b[15];
			}
		}

		Matrix4x4.createFromQuaternion=function(rotation,out){
			var e=out.elements;
			var q=rotation.elements;
			var x=q[0],y=q[1],z=q[2],w=q[3];
			var x2=x+x;
			var y2=y+y;
			var z2=z+z;
			var xx=x *x2;
			var yx=y *x2;
			var yy=y *y2;
			var zx=z *x2;
			var zy=z *y2;
			var zz=z *z2;
			var wx=w *x2;
			var wy=w *y2;
			var wz=w *z2;
			e[0]=1-yy-zz;
			e[1]=yx+wz;
			e[2]=zx-wy;
			e[3]=0;
			e[4]=yx-wz;
			e[5]=1-xx-zz;
			e[6]=zy+wx;
			e[7]=0;
			e[8]=zx+wy;
			e[9]=zy-wx;
			e[10]=1-xx-yy;
			e[11]=0;
			e[12]=0;
			e[13]=0;
			e[14]=0;
			out[15]=1;
		}

		Matrix4x4.createAffineTransformation=function(trans,rot,scale,out){
			var te=trans.elements;
			var re=rot.elements;
			var se=scale.elements;
			var oe=out.elements;
			var x=re[0],y=re[1],z=re[2],w=re[3],x2=x+x,y2=y+y,z2=z+z;
			var xx=x *x2,xy=x *y2,xz=x *z2,yy=y *y2,yz=y *z2,zz=z *z2;
			var wx=w *x2,wy=w *y2,wz=w *z2,sx=se[0],sy=se[1],sz=se[2];
			oe[0]=(1-(yy+zz))*sx;
			oe[1]=(xy+wz)*sx;
			oe[2]=(xz-wy)*sx;
			oe[3]=0;
			oe[4]=(xy-wz)*sy;
			oe[5]=(1-(xx+zz))*sy;
			oe[6]=(yz+wx)*sy;
			oe[7]=0;
			oe[8]=(xz+wy)*sz;
			oe[9]=(yz-wx)*sz;
			oe[10]=(1-(xx+yy))*sz;
			oe[11]=0;
			oe[12]=te[0];
			oe[13]=te[1];
			oe[14]=te[2];
			oe[15]=1;
		}

		Matrix4x4.createLookAt=function(eye,center,up,out){
			var ee=eye.elements;
			var ce=center.elements;
			var ue=up.elements;
			var oe=out.elements;
			var x0,x1,x2,y0,y1,y2,z0,z1,z2,len,eyex=ee[0],eyey=ee[1],eyez=ee[2],upx=ue[0],upy=ue[1],upz=ue[2],centerx=ce[0],centery=ce[1],centerz=ce[2];
			if (Math.abs(eyex-centerx)< MathUtils3D.zeroTolerance && Math.abs(eyey-centery)< MathUtils3D.zeroTolerance && Math.abs(eyez-centerz)< MathUtils3D.zeroTolerance){
				out.identity();
				return;
			}
			z0=eyex-centerx;
			z1=eyey-centery;
			z2=eyez-centerz;
			len=1 / Math.sqrt(z0 *z0+z1 *z1+z2 *z2);
			z0 *=len;
			z1 *=len;
			z2 *=len;
			x0=upy *z2-upz *z1;
			x1=upz *z0-upx *z2;
			x2=upx *z1-upy *z0;
			len=Math.sqrt(x0 *x0+x1 *x1+x2 *x2);
			if (!len){
				x0=x1=x2=0;
				}else {
				len=1 / len;
				x0 *=len;
				x1 *=len;
				x2 *=len;
			}
			y0=z1 *x2-z2 *x1;
			y1=z2 *x0-z0 *x2;
			y2=z0 *x1-z1 *x0;
			len=Math.sqrt(y0 *y0+y1 *y1+y2 *y2);
			if (!len){
				y0=y1=y2=0;
				}else {
				len=1 / len;
				y0 *=len;
				y1 *=len;
				y2 *=len;
			}
			oe[0]=x0;
			oe[1]=y0;
			oe[2]=z0;
			oe[3]=0;
			oe[4]=x1;
			oe[5]=y1;
			oe[6]=z1;
			oe[7]=0;
			oe[8]=x2;
			oe[9]=y2;
			oe[10]=z2;
			oe[11]=0;
			oe[12]=-(x0 *eyex+x1 *eyey+x2 *eyez);
			oe[13]=-(y0 *eyex+y1 *eyey+y2 *eyez);
			oe[14]=-(z0 *eyex+z1 *eyey+z2 *eyez);
			oe[15]=1;
		}

		Matrix4x4.createPerspective=function(fov,aspect,near,far,out){
			var oe=out.elements;
			var yScale=1.0 / Math.tan(fov *0.5);
			var q=far / (near-far);
			oe[0]=yScale / aspect;
			oe[5]=yScale;
			oe[10]=q;
			oe[11]=-1.0;
			oe[14]=q *near;
			oe[1]=oe[2]=oe[3]=oe[4]=oe[6]=oe[7]=oe[8]=oe[9]=oe[12]=oe[13]=oe[15]=0;
		}

		Matrix4x4.createOrthogonal=function(left,right,bottom,top,near,far,out){
			var oe=out.elements;
			var lr=1 / (left-right);
			var bt=1 / (bottom-top);
			var nf=1 / (near-far);
			oe[1]=oe[2]=oe[3]=oe[4]=oe[6]=oe[7]=oe[8]=oe[9]=oe[11]=0;
			oe[15]=1;
			oe[0]=-2 *lr;
			oe[5]=-2 *bt;
			oe[10]=2 *nf;
			oe[12]=(left+right)*lr;
			oe[13]=(top+bottom)*bt;
			oe[14]=(far+near)*nf;
		}

		Matrix4x4.TEMP=new Matrix4x4();
		Matrix4x4.DEFAULT=new Matrix4x4();
		return Matrix4x4;
	})()


	/**
	*<code>Plane</code> 类用于创建平面。
	*/
	//class laya.d3.math.Plane
	var Plane=(function(){
		function Plane(normal,d){
			this.normal=null;
			this.distance=NaN;
			(d===void 0)&& (d=0);
			this.normal=normal;
			this.distance=d;
		}

		__class(Plane,'laya.d3.math.Plane');
		var __proto=Plane.prototype;
		/**
		*更改平面法线向量的系数，使之成单位长度。
		*/
		__proto.normalize=function(){
			var normalE=this.normal.elements;
			var normalEX=normalE[0];
			var normalEY=normalE[1];
			var normalEZ=normalE[2];
			var magnitude=1 / Math.sqrt(normalEX *normalEX+normalEY *normalEY+normalEZ *normalEZ);
			normalE[0]=normalEX *magnitude;
			normalE[1]=normalEY *magnitude;
			normalE[2]=normalEZ *magnitude;
			this.distance *=magnitude;
		}

		Plane.createPlaneBy3P=function(point1,point2,point3){
			var point1e=point1.elements;
			var point2e=point2.elements;
			var point3e=point3.elements;
			var x1=point2e[0]-point1e[0];
			var y1=point2e[1]-point1e[1];
			var z1=point2e[2]-point1e[2];
			var x2=point3e[0]-point1e[0];
			var y2=point3e[1]-point1e[1];
			var z2=point3e[2]-point1e[2];
			var yz=(y1 *z2)-(z1 *y2);
			var xz=(z1 *x2)-(x1 *z2);
			var xy=(x1 *y2)-(y1 *x2);
			var invPyth=1 / (Math.sqrt((yz *yz)+(xz *xz)+(xy *xy)));
			var x=yz *invPyth;
			var y=xz *invPyth;
			var z=xy *invPyth;
			var TEMPVec3e=Plane._TEMPVec3.elements;
			TEMPVec3e[0]=x;
			TEMPVec3e[1]=y;
			TEMPVec3e[2]=z;
			var d=-((x *point1e[0])+(y *point1e[1])+(z *point1e[2]));
			var plane=new Plane(Plane._TEMPVec3,d);
			return plane;
		}

		Plane.PlaneIntersectionType_Back=0;
		Plane.PlaneIntersectionType_Front=1;
		Plane.PlaneIntersectionType_Intersecting=2;
		__static(Plane,
		['_TEMPVec3',function(){return this._TEMPVec3=new Vector3();}
		]);
		return Plane;
	})()


	/**
	*<code>Quaternion</code> 类用于创建四元数。
	*/
	//class laya.d3.math.Quaternion
	var Quaternion=(function(){
		function Quaternion(x,y,z,w){
			this.elements=new Float32Array(4);
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			(z===void 0)&& (z=0);
			(w===void 0)&& (w=1);
			this.elements[0]=x;
			this.elements[1]=y;
			this.elements[2]=z;
			this.elements[3]=w;
		}

		__class(Quaternion,'laya.d3.math.Quaternion');
		var __proto=Quaternion.prototype;
		/**
		*根据缩放值缩放四元数
		*@param scale 缩放值
		*@param out 输出四元数
		*/
		__proto.scaling=function(scaling,out){
			var e=out.elements;
			var f=this.elements;
			e[0]=f[0] *scaling;
			e[1]=f[1] *scaling;
			e[2]=f[2] *scaling;
			e[3]=f[3] *scaling;
		}

		/**
		*归一化四元数
		*@param out 输出四元数
		*/
		__proto.normalize=function(out){
			var e=out.elements;
			var f=this.elements;
			var x=f[0],y=f[1],z=f[2],w=f[3];
			var len=x *x+y *y+z *z+w *w;
			if (len > 0){
				len=1 / Math.sqrt(len);
				e[0]=x *len;
				e[1]=y *len;
				e[2]=z *len;
				e[3]=w *len;
			}
		}

		/**
		*计算四元数的长度
		*@return 长度
		*/
		__proto.length=function(){
			var f=this.elements;
			var x=f[0],y=f[1],z=f[2],w=f[3];
			return Math.sqrt(x *x+y *y+z *z+w *w);
		}

		/**
		*根据绕X轴的角度旋转四元数
		*@param rad 角度
		*@param out 输出四元数
		*/
		__proto.rotateX=function(rad,out){
			var e=out.elements;
			var f=this.elements;
			rad *=0.5;
			var ax=f[0],ay=f[1],az=f[2],aw=f[3];
			var bx=Math.sin(rad),bw=Math.cos(rad);
			e[0]=ax *bw+aw *bx;
			e[1]=ay *bw+az *bx;
			e[2]=az *bw-ay *bx;
			e[3]=aw *bw-ax *bx;
		}

		/**
		*根据绕Y轴的制定角度旋转四元数
		*@param rad 角度
		*@param out 输出四元数
		*/
		__proto.rotateY=function(rad,out){
			var e=out.elements;
			var f=this.elements;
			rad *=0.5;
			var ax=f[0],ay=f[1],az=f[2],aw=f[3],by=Math.sin(rad),bw=Math.cos(rad);
			e[0]=ax *bw-az *by;
			e[1]=ay *bw+aw *by;
			e[2]=az *bw+ax *by;
			e[3]=aw *bw-ay *by;
		}

		/**
		*根据绕Z轴的制定角度旋转四元数
		*@param rad 角度
		*@param out 输出四元数
		*/
		__proto.rotateZ=function(rad,out){
			var e=out.elements;
			var f=this.elements;
			rad *=0.5;
			var ax=f[0],ay=f[1],az=f[2],aw=f[3],bz=Math.sin(rad),bw=Math.cos(rad);
			e[0]=ax *bw+ay *bz;
			e[1]=ay *bw-ax *bz;
			e[2]=az *bw+aw *bz;
			e[3]=aw *bw-az *bz;
		}

		/**
		*分解四元数到欧拉角（顺序为Yaw、Pitch、Roll），参考自http://xboxforums.create.msdn.com/forums/p/4574/23988.aspx#23988,问题绕X轴翻转超过±90度时有，会产生瞬间反转
		*@param quaternion 源四元数
		*@param out 欧拉角值
		*/
		__proto.getYawPitchRoll=function(out){
			Vector3.transformQuat(Vector3.ForwardRH,this,Quaternion.TEMPVector31);
			Vector3.transformQuat(Vector3.Up,this,Quaternion.TEMPVector32);
			var upe=Quaternion.TEMPVector32.elements;
			Quaternion.angleTo(Vector3.ZERO,Quaternion.TEMPVector31,Quaternion.TEMPVector33);
			var anglee=Quaternion.TEMPVector33.elements;
			if (anglee[0]==Math.PI / 2){
				anglee[1]=Quaternion.arcTanAngle(upe[2],upe[0]);
				anglee[2]=0;
				}else if (anglee[0]==-Math.PI / 2){
				anglee[1]=Quaternion.arcTanAngle(-upe[2],-upe[0]);
				anglee[2]=0;
				}else {
				Matrix4x4.createRotationY(-anglee[1],Quaternion.TEMPMatrix0);
				Matrix4x4.createRotationX(-anglee[0],Quaternion.TEMPMatrix1);
				Vector3.transformCoordinate(Quaternion.TEMPVector32,Quaternion.TEMPMatrix0,Quaternion.TEMPVector32);
				Vector3.transformCoordinate(Quaternion.TEMPVector32,Quaternion.TEMPMatrix1,Quaternion.TEMPVector32);
				anglee[2]=Quaternion.arcTanAngle(upe[1],-upe[0]);
			}
			if (anglee[1] <=-Math.PI)
				anglee[1]=Math.PI;
			if (anglee[2] <=-Math.PI)
				anglee[2]=Math.PI;
			if (anglee[1] >=Math.PI && anglee[2] >=Math.PI){
				anglee[1]=0;
				anglee[2]=0;
				anglee[0]=Math.PI-anglee[0];
			};
			var oe=out.elements;
			oe[0]=anglee[1];
			oe[1]=anglee[0];
			oe[2]=anglee[2];
		}

		/**
		*求四元数的逆
		*@param out 输出四元数
		*/
		__proto.invert=function(out){
			var e=out.elements;
			var f=this.elements;
			var a0=f[0],a1=f[1],a2=f[2],a3=f[3];
			var dot=a0 *a0+a1 *a1+a2 *a2+a3 *a3;
			var invDot=dot ? 1.0 / dot :0;
			e[0]=-a0 *invDot;
			e[1]=-a1 *invDot;
			e[2]=-a2 *invDot;
			e[3]=a3 *invDot;
		}

		/**
		*设置四元数为单位算数
		*@param out 输出四元数
		*/
		__proto.identity=function(){
			var e=this.elements;
			e[0]=0;
			e[1]=0;
			e[2]=0;
			e[3]=1;
		}

		/**
		*克隆一个四元数
		*@param out 输出的四元数
		*/
		__proto.cloneTo=function(out){
			var i,s,d;
			s=this.elements;
			d=out.elements;
			if (s===d){
				return;
			}
			for (i=0;i < 4;++i){
				d[i]=s[i];
			}
		}

		/**
		*从一个四元数复制
		*@param sou 源四元数
		*/
		__proto.copyFrom=function(sou){
			var i,s,d;
			s=sou.elements;
			d=this.elements;
			if (s===d){
				return;
			}
			for (i=0;i < 4;++i){
				d[i]=s[i];
			}
		}

		/**
		*从一个数组复制
		*@param sou 源Float32Array数组
		*/
		__proto.copyFromArray=function(sou){
			var i,d;
			d=this.elements;
			if (sou===d){
				return;
			}
			for (i=0;i < 4;++i){
				d[i]=sou[i];
			}
		}

		/**
		*获取四元数的x值
		*/
		__getset(0,__proto,'x',function(){
			return this.elements[0];
		});

		/**
		*获取四元数的y值
		*/
		__getset(0,__proto,'y',function(){
			return this.elements[1];
		});

		/**
		*获取四元数的z值
		*/
		__getset(0,__proto,'z',function(){
			return this.elements[2];
		});

		/**
		*获取四元数的w值
		*/
		__getset(0,__proto,'w',function(){
			return this.elements[3];
		});

		Quaternion.createFromYawPitchRoll=function(yaw,pitch,roll,out){
			var halfRoll=roll *0.5;
			var halfPitch=pitch *0.5;
			var halfYaw=yaw *0.5;
			var sinRoll=Math.sin(halfRoll);
			var cosRoll=Math.cos(halfRoll);
			var sinPitch=Math.sin(halfPitch);
			var cosPitch=Math.cos(halfPitch);
			var sinYaw=Math.sin(halfYaw);
			var cosYaw=Math.cos(halfYaw);
			var oe=out.elements;
			oe[0]=(cosYaw *sinPitch *cosRoll)+(sinYaw *cosPitch *sinRoll);
			oe[1]=(sinYaw *cosPitch *cosRoll)-(cosYaw *sinPitch *sinRoll);
			oe[2]=(cosYaw *cosPitch *sinRoll)-(sinYaw *sinPitch *cosRoll);
			oe[3]=(cosYaw *cosPitch *cosRoll)+(sinYaw *sinPitch *sinRoll);
		}

		Quaternion.multiply=function(left,right,out){
			var le=left.elements;
			var re=right.elements;
			var oe=out.elements;
			var lx=le[0];
			var ly=le[1];
			var lz=le[2];
			var lw=le[3];
			var rx=re[0];
			var ry=re[1];
			var rz=re[2];
			var rw=re[3];
			var a=(ly *rz-lz *ry);
			var b=(lz *rx-lx *rz);
			var c=(lx *ry-ly *rx);
			var d=(lx *rx+ly *ry+lz *rz);
			oe[0]=(lx *rw+rx *lw)+a;
			oe[1]=(ly *rw+ry *lw)+b;
			oe[2]=(lz *rw+rz *lw)+c;
			oe[3]=lw *rw-d;
		}

		Quaternion.arcTanAngle=function(x,y){
			if (x==0){
				if (y==1)
					return Math.PI / 2;
				return-Math.PI / 2;
			}
			if (x > 0)
				return Math.atan(y / x);
			if (x < 0){
				if (y > 0)
					return Math.atan(y / x)+Math.PI;
				return Math.atan(y / x)-Math.PI;
			}
			return 0;
		}

		Quaternion.angleTo=function(from,location,angle){
			Vector3.subtract(location,from,Quaternion.TEMPVector30);
			Vector3.normalize(Quaternion.TEMPVector30,Quaternion.TEMPVector30);
			angle.elements[0]=Math.asin(Quaternion.TEMPVector30.y);
			angle.elements[1]=Quaternion.arcTanAngle(-Quaternion.TEMPVector30.z,-Quaternion.TEMPVector30.x);
		}

		Quaternion.createFromAxisAngle=function(axis,rad,out){
			var e=out.elements;
			var f=axis.elements;
			rad=rad *0.5;
			var s=Math.sin(rad);
			e[0]=s *f[0];
			e[1]=s *f[1];
			e[2]=s *f[2];
			e[3]=Math.cos(rad);
		}

		Quaternion.createFromMatrix3x3=function(sou,out){
			var e=out.elements;
			var f=sou.elements;
			var fTrace=f[0]+f[4]+f[8];
			var fRoot;
			if (fTrace > 0.0){
				fRoot=Math.sqrt(fTrace+1.0);
				e[3]=0.5 *fRoot;
				fRoot=0.5 / fRoot;
				e[0]=(f[5]-f[7])*fRoot;
				e[1]=(f[6]-f[2])*fRoot;
				e[2]=(f[1]-f[3])*fRoot;
				}else {
				var i=0;
				if (f[4] > f[0])
					i=1;
				if (f[8] > f[i *3+i])
					i=2;
				var j=(i+1)% 3;
				var k=(i+2)% 3;
				fRoot=Math.sqrt(f[i *3+i]-f[j *3+j]-f[k *3+k]+1.0);
				e[i]=0.5 *fRoot;
				fRoot=0.5 / fRoot;
				e[3]=(f[j *3+k]-f[k *3+j])*fRoot;
				e[j]=(f[j *3+i]+f[i *3+j])*fRoot;
				e[k]=(f[k *3+i]+f[i *3+k])*fRoot;
			}
			return;
		}

		Quaternion.createFromMatrix4x4=function(mat,out){
			var me=mat.elements;
			var oe=out.elements;
			var sqrt;
			var half;
			var scale=me[0]+me[5]+me[10];
			if (scale > 0.0){
				sqrt=Math.sqrt(scale+1.0);
				oe[3]=sqrt *0.5;
				sqrt=0.5 / sqrt;
				oe[0]=(me[6]-me[9])*sqrt;
				oe[1]=(me[8]-me[2])*sqrt;
				oe[2]=(me[1]-me[4])*sqrt;
				}else if ((me[0] >=me[5])&& (me[0] >=me[10])){
				sqrt=Math.sqrt(1.0+me[0]-me[5]-me[10]);
				half=0.5 / sqrt;
				oe[0]=0.5 *sqrt;
				oe[1]=(me[1]+me[4])*half;
				oe[2]=(me[2]+me[8])*half;
				oe[3]=(me[6]-me[9])*half;
				}else if (me[5] > me[10]){
				sqrt=Math.sqrt(1.0+me[5]-me[0]-me[10]);
				half=0.5 / sqrt;
				oe[0]=(me[4]+me[1])*half;
				oe[1]=0.5 *sqrt;
				oe[2]=(me[9]+me[6])*half;
				oe[3]=(me[8]-me[2])*half;
				}else {
				sqrt=Math.sqrt(1.0+me[10]-me[0]-me[5]);
				half=0.5 / sqrt;
				oe[0]=(me[8]+me[2])*half;
				oe[1]=(me[9]+me[6])*half;
				oe[2]=0.5 *sqrt;
				oe[3]=(me[1]-me[4])*half;
			}
		}

		Quaternion.slerp=function(left,right,t,out){
			var a=left.elements;
			var b=right.elements;
			var oe=out.elements;
			var ax=a[0],ay=a[1],az=a[2],aw=a[3],bx=b[0],by=b[1],bz=b[2],bw=b[3];
			var omega,cosom,sinom,scale0,scale1;
			cosom=ax *bx+ay *by+az *bz+aw *bw;
			if (cosom < 0.0){
				cosom=-cosom;
				bx=-bx;
				by=-by;
				bz=-bz;
				bw=-bw;
			}
			if ((1.0-cosom)> 0.000001){
				omega=Math.acos(cosom);
				sinom=Math.sin(omega);
				scale0=Math.sin((1.0-t)*omega)/ sinom;
				scale1=Math.sin(t *omega)/ sinom;
				}else {
				scale0=1.0-t;
				scale1=t;
			}
			oe[0]=scale0 *ax+scale1 *bx;
			oe[1]=scale0 *ay+scale1 *by;
			oe[2]=scale0 *az+scale1 *bz;
			oe[3]=scale0 *aw+scale1 *bw;
			return oe;
		}

		Quaternion.lerp=function(left,right,t,out){
			var e=out.elements;
			var f=left.elements;
			var g=right.elements;
			var ax=f[0],ay=f[1],az=f[2],aw=f[3];
			e[0]=ax+t *(g[0]-ax);
			e[1]=ay+t *(g[1]-ay);
			e[2]=az+t *(g[2]-az);
			e[3]=aw+t *(g[3]-aw);
		}

		Quaternion.add=function(left,right,out){
			var e=out.elements;
			var f=left.elements;
			var g=right.elements;
			e[0]=f[0]+g[0];
			e[1]=f[1]+g[1];
			e[2]=f[2]+g[2];
			e[3]=f[3]+g[3];
		}

		Quaternion.dot=function(left,right){
			var f=left.elements;
			var g=right.elements;
			return f[0] *g[0]+f[1] *g[1]+f[2] *g[2]+f[3] *g[3];
		}

		Quaternion.DEFAULT=new Quaternion();
		__static(Quaternion,
		['TEMPVector30',function(){return this.TEMPVector30=new Vector3();},'TEMPVector31',function(){return this.TEMPVector31=new Vector3();},'TEMPVector32',function(){return this.TEMPVector32=new Vector3();},'TEMPVector33',function(){return this.TEMPVector33=new Vector3();},'TEMPMatrix0',function(){return this.TEMPMatrix0=new Matrix4x4();},'TEMPMatrix1',function(){return this.TEMPMatrix1=new Matrix4x4();}
		]);
		return Quaternion;
	})()


	/**
	*<code>Ray</code> 类用于创建射线。
	*/
	//class laya.d3.math.Ray
	var Ray=(function(){
		function Ray(origin,direction){
			this.origin=null;
			this.direction=null;
			this.origin=origin;
			this.direction=direction;
		}

		__class(Ray,'laya.d3.math.Ray');
		return Ray;
	})()


	/**
	*<code>Vector2</code> 类用于创建二维向量。
	*/
	//class laya.d3.math.Vector2
	var Vector2=(function(){
		function Vector2(x,y){
			this.elements=new Float32Array(2);
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			var v=this.elements;
			v[0]=x;
			v[1]=y;
		}

		__class(Vector2,'laya.d3.math.Vector2');
		var __proto=Vector2.prototype;
		/**
		*从一个克隆二维向量克隆。
		*@param v 源二维向量。
		*/
		__proto.clone=function(v){
			var out=this.elements,s=v.elements;
			out[0]=s[0];
			out[1]=s[1];
		}

		/**
		*获取X轴坐标。
		*@return x X轴坐标。
		*/
		__getset(0,__proto,'x',function(){
			return this.elements[0];
		});

		/**
		*获取Y轴坐标。
		*@return y Y轴坐标。
		*/
		__getset(0,__proto,'y',function(){
			return this.elements[1];
		});

		__static(Vector2,
		['ZERO',function(){return this.ZERO=new Vector2(0.0,0.0);},'ONE',function(){return this.ONE=new Vector2(1.0,1.0);}
		]);
		return Vector2;
	})()


	/**
	*<code>Vector3</code> 类用于创建三维向量。
	*/
	//class laya.d3.math.Vector3
	var Vector3=(function(){
		function Vector3(x,y,z){
			this.elements=new Float32Array(3);
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			(z===void 0)&& (z=0);
			var v=this.elements;
			v[0]=x;
			v[1]=y;
			v[2]=z;
		}

		__class(Vector3,'laya.d3.math.Vector3');
		var __proto=Vector3.prototype;
		/**
		*从一个三维向量复制。
		*@param v 源向量。
		*/
		__proto.copyFrom=function(v){
			var e=this.elements,s=v.elements;
			e[0]=s[0];
			e[1]=s[1];
			e[2]=s[2];
			return this;
		}

		/**
		*克隆三维向量。
		*@return 输出三维向量。
		*/
		__proto.clone=function(){
			var out=new Vector3();
			var oe=out.elements,s=this.elements;
			oe[0]=s[0];
			oe[1]=s[1];
			oe[2]=s[2];
			return out;
		}

		/**
		*克隆三维向量。
		*@param dest 输出三维向量。
		*/
		__proto.cloneTo=function(dest){
			var oe=dest.elements,s=this.elements;
			oe[0]=s[0];
			oe[1]=s[1];
			oe[2]=s[2];
		}

		__proto.toDefault=function(){
			this.elements[0]=0;
			this.elements[1]=0;
			this.elements[2]=0;
		}

		/**
		*设置X轴坐标。
		*@param x X轴坐标。
		*/
		/**
		*获取X轴坐标。
		*@return x X轴坐标。
		*/
		__getset(0,__proto,'x',function(){
			return this.elements[0];
			},function(value){
			this.elements[0]=value;
		});

		/**
		*设置Y轴坐标。
		*@param y Y轴坐标。
		*/
		/**
		*获取Y轴坐标。
		*@return y Y轴坐标。
		*/
		__getset(0,__proto,'y',function(){
			return this.elements[1];
			},function(value){
			this.elements[1]=value;
		});

		/**
		*设置Z轴坐标。
		*@param z Z轴坐标。
		*/
		/**
		*获取Z轴坐标。
		*@return z Z轴坐标。
		*/
		__getset(0,__proto,'z',function(){
			return this.elements[2];
			},function(value){
			this.elements[2]=value;
		});

		Vector3.distanceSquared=function(value1,value2){
			var value1e=value1.elements;
			var value2e=value2.elements;
			var x=value1e[0]-value2e[0];
			var y=value1e[1]-value2e[1];
			var z=value1e[2]-value2e[2];
			return (x *x)+(y *y)+(z *z);
		}

		Vector3.distance=function(value1,value2){
			var value1e=value1.elements;
			var value2e=value2.elements;
			var x=value1e[0]-value2e[0];
			var y=value1e[1]-value2e[1];
			var z=value1e[2]-value2e[2];
			return Math.sqrt((x *x)+(y *y)+(z *z));
		}

		Vector3.min=function(a,b,out){
			var e=out.elements;
			var f=a.elements;
			var g=b.elements
			e[0]=Math.min(f[0],g[0]);
			e[1]=Math.min(f[1],g[1]);
			e[2]=Math.min(f[2],g[2]);
		}

		Vector3.max=function(a,b,out){
			var e=out.elements;
			var f=a.elements;
			var g=b.elements
			e[0]=Math.max(f[0],g[0]);
			e[1]=Math.max(f[1],g[1]);
			e[2]=Math.max(f[2],g[2]);
		}

		Vector3.transformQuat=function(source,rotation,out){
			var destination=out.elements;
			var se=source.elements;
			var re=rotation.elements;
			var x=se[0],y=se[1],z=se[2],qx=re[0],qy=re[1],qz=re[2],qw=re[3],
			ix=qw *x+qy *z-qz *y,iy=qw *y+qz *x-qx *z,iz=qw *z+qx *y-qy *x,iw=-qx *x-qy *y-qz *z;
			destination[0]=ix *qw+iw *-qx+iy *-qz-iz *-qy;
			destination[1]=iy *qw+iw *-qy+iz *-qx-ix *-qz;
			destination[2]=iz *qw+iw *-qz+ix *-qy-iy *-qx;
		}

		Vector3.scalarLength=function(a){
			var f=a.elements;
			var x=f[0],y=f[1],z=f[2];
			return Math.sqrt(x *x+y *y+z *z);
		}

		Vector3.scalarLengthSquared=function(a){
			var f=a.elements;
			var x=f[0],y=f[1],z=f[2];
			return x *x+y *y+z *z;
		}

		Vector3.normalize=function(s,out){
			var se=s.elements;
			var oe=out.elements;
			var x=se[0],y=se[1],z=se[2];
			var len=x *x+y *y+z *z;
			if (len > 0){
				len=1 / Math.sqrt(len);
				oe[0]=se[0] *len;
				oe[1]=se[1] *len;
				oe[2]=se[2] *len;
			}
		}

		Vector3.multiply=function(a,b,out){
			var e=out.elements;
			var f=a.elements;
			var g=b.elements
			e[0]=f[0] *g[0];
			e[1]=f[1] *g[1];
			e[2]=f[2] *g[2];
		}

		Vector3.scale=function(a,b,out){
			var e=out.elements;
			var f=a.elements;
			e[0]=f[0] *b;
			e[1]=f[1] *b;
			e[2]=f[2] *b;
		}

		Vector3.lerp=function(a,b,t,out){
			var e=out.elements;
			var f=a.elements;
			var g=b.elements;
			var ax=f[0],ay=f[1],az=f[2];
			e[0]=ax+t *(g[0]-ax);
			e[1]=ay+t *(g[1]-ay);
			e[2]=az+t *(g[2]-az);
		}

		Vector3.transformV3ToV3=function(vector,transform,result){
			var intermediate=new Vector4();
			Vector3.transformV3ToV4(vector,transform,intermediate);
			var intermediateElem=intermediate.elements;
			var resultElem=result.elements;
			resultElem[0]=intermediateElem[0];
			resultElem[1]=intermediateElem[1];
			resultElem[2]=intermediateElem[2];
		}

		Vector3.transformV3ToV4=function(vector,transform,result){
			var vectorElem=vector.elements;
			var vectorX=vectorElem[0];
			var vectorY=vectorElem[1];
			var vectorZ=vectorElem[2];
			var transformElem=transform.elements;
			var resultElem=result.elements;
			resultElem[0]=(vectorX *transformElem[0])+(vectorY *transformElem[4])+(vectorZ *transformElem[8])+transformElem[12];
			resultElem[1]=(vectorX *transformElem[1])+(vectorY *transformElem[5])+(vectorZ *transformElem[9])+transformElem[13];
			resultElem[2]=(vectorX *transformElem[2])+(vectorY *transformElem[6])+(vectorZ *transformElem[10])+transformElem[14];
			resultElem[3]=(vectorX *transformElem[3])+(vectorY *transformElem[7])+(vectorZ *transformElem[11])+transformElem[15];
		}

		Vector3.TransformNormal=function(normal,transform,result){
			var normalElem=normal.elements;
			var normalX=normalElem[0];
			var normalY=normalElem[1];
			var normalZ=normalElem[2];
			var transformElem=transform.elements;
			var resultElem=result.elements;
			resultElem[0]=(normalX *transformElem[0])+(normalY *transformElem[4])+(normalZ *transformElem[8]);
			resultElem[1]=(normalX *transformElem[1])+(normalY *transformElem[5])+(normalZ *transformElem[9]);
			resultElem[2]=(normalX *transformElem[2])+(normalY *transformElem[6])+(normalZ *transformElem[10]);
		}

		Vector3.transformCoordinate=function(coordinate,transform,result){
			var vectorElem=Vector3.TEMPVec4.elements;
			var coordinateElem=coordinate.elements;
			var coordinateX=coordinateElem[0];
			var coordinateY=coordinateElem[1];
			var coordinateZ=coordinateElem[2];
			var transformElem=transform.elements;
			vectorElem[0]=(coordinateX *transformElem[0])+(coordinateY *transformElem[4])+(coordinateZ *transformElem[8])+transformElem[12];
			vectorElem[1]=(coordinateX *transformElem[1])+(coordinateY *transformElem[5])+(coordinateZ *transformElem[9])+transformElem[13];
			vectorElem[2]=(coordinateX *transformElem[2])+(coordinateY *transformElem[6])+(coordinateZ *transformElem[10])+transformElem[14];
			vectorElem[3]=1.0 / ((coordinateX *transformElem[3])+(coordinateY *transformElem[7])+(coordinateZ *transformElem[11])+transformElem[15]);
			var resultElem=result.elements;
			resultElem[0]=vectorElem[0] *vectorElem[3];
			resultElem[1]=vectorElem[1] *vectorElem[3];
			resultElem[2]=vectorElem[2] *vectorElem[3];
		}

		Vector3.Clamp=function(value,min,max,out){
			var valuee=value.elements;
			var x=valuee[0];
			var y=valuee[1];
			var z=valuee[2];
			var mine=min.elements;
			var mineX=mine[0];
			var mineY=mine[1];
			var mineZ=mine[2];
			var maxe=max.elements;
			var maxeX=maxe[0];
			var maxeY=maxe[1];
			var maxeZ=maxe[2];
			var oute=out.elements;
			x=(x > maxeX)? maxeX :x;
			x=(x < mineX)? mineX :x;
			y=(y > maxeY)? maxeY :y;
			y=(y < mineY)? mineY :y;
			z=(z > maxeZ)? maxeZ :z;
			z=(z < mineZ)? mineZ :z;
			oute[0]=x;
			oute[1]=y;
			oute[2]=z;
		}

		Vector3.add=function(a,b,out){
			var e=out.elements;
			var f=a.elements;
			var g=b.elements
			e[0]=f[0]+g[0];
			e[1]=f[1]+g[1];
			e[2]=f[2]+g[2];
		}

		Vector3.subtract=function(a,b,o){
			var oe=o.elements;
			var ae=a.elements;
			var be=b.elements;
			oe[0]=ae[0]-be[0];
			oe[1]=ae[1]-be[1];
			oe[2]=ae[2]-be[2];
		}

		Vector3.cross=function(a,b,o){
			var ae=a.elements;
			var be=b.elements;
			var oe=o.elements;
			var ax=ae[0],ay=ae[1],az=ae[2],bx=be[0],by=be[1],bz=be[2];
			oe[0]=ay *bz-az *by;
			oe[1]=az *bx-ax *bz;
			oe[2]=ax *by-ay *bx;
		}

		Vector3.dot=function(a,b){
			var ae=a.elements;
			var be=b.elements;
			var r=(ae[0] *be[0])+(ae[1] *be[1])+(ae[2] *be[2]);
			return r;
		}

		Vector3.equals=function(a,b){
			var ae=a.elements;
			var be=b.elements;
			return MathUtils3D.nearEqual(Math.abs(ae[0]),Math.abs(be[0]))
			&& MathUtils3D.nearEqual(Math.abs(ae[1]),Math.abs(be[1]))
			&& MathUtils3D.nearEqual(Math.abs(ae[2]),Math.abs(be[2]));
		}

		__static(Vector3,
		['TEMPVec4',function(){return this.TEMPVec4=new Vector4();},'ZERO',function(){return this.ZERO=new Vector3(0.0,0.0,0.0);},'ONE',function(){return this.ONE=new Vector3(1.0,1.0,1.0);},'UnitX',function(){return this.UnitX=new Vector3(1,0,0);},'UnitY',function(){return this.UnitY=new Vector3(0,1,0);},'UnitZ',function(){return this.UnitZ=new Vector3(0,0,1);},'ForwardRH',function(){return this.ForwardRH=new Vector3(0,0,-1);},'ForwardLH',function(){return this.ForwardLH=new Vector3(0,0,1);},'Up',function(){return this.Up=new Vector3(0,1,0);}
		]);
		return Vector3;
	})()


	/**
	*<code>Vector4</code> 类用于创建四维向量。
	*/
	//class laya.d3.math.Vector4
	var Vector4=(function(){
		function Vector4(x,y,z,w){
			this.elements=new Float32Array(4);
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			(z===void 0)&& (z=0);
			(w===void 0)&& (w=0);
			var v=this.elements;
			v[0]=x;
			v[1]=y;
			v[2]=z;
			v[3]=w;
		}

		__class(Vector4,'laya.d3.math.Vector4');
		var __proto=Vector4.prototype;
		/**
		*从一个四维向量复制。
		*@param v 源向量。
		*/
		__proto.copyFrom=function(v){
			var e=this.elements,s=v.elements;
			e[0]=s[0];
			e[1]=s[1];
			e[2]=s[2];
			e[3]=s[3];
			return this;
		}

		/**
		*获取X轴坐标。
		*@return x X轴坐标。
		*/
		__getset(0,__proto,'x',function(){
			return this.elements[0];
		});

		/**
		*获取Y轴坐标。
		*@return y Y轴坐标。
		*/
		__getset(0,__proto,'y',function(){
			return this.elements[1];
		});

		/**
		*获取Z轴坐标。
		*@return z Z轴坐标。
		*/
		__getset(0,__proto,'z',function(){
			return this.elements[2];
		});

		/**
		*获取W轴坐标。
		*@return w W轴坐标。
		*/
		__getset(0,__proto,'w',function(){
			return this.elements[3];
		});

		Vector4.lerp=function(a,b,t,out){
			var e=out.elements;
			var f=a.elements;
			var g=b.elements;
			var ax=f[0],ay=f[1],az=f[2],aw=f[3];
			e[0]=ax+t *(g[0]-ax);
			e[1]=ay+t *(g[1]-ay);
			e[2]=az+t *(g[2]-az);
			e[3]=aw+t *(g[3]-aw);
		}

		__static(Vector4,
		['ZERO',function(){return this.ZERO=new Vector4();}
		]);
		return Vector4;
	})()


	/**
	*<code>Viewport</code> 类用于创建视口。
	*/
	//class laya.d3.math.Viewport
	var Viewport=(function(){
		function Viewport(x,y,width,height){
			//this.x=NaN;
			//this.y=NaN;
			//this.width=NaN;
			//this.height=NaN;
			//this.minDepth=NaN;
			//this.maxDepth=NaN;
			this.minDepth=0.0;
			this.maxDepth=1.0;
			this.x=x;
			this.y=y;
			this.width=width;
			this.height=height;
		}

		__class(Viewport,'laya.d3.math.Viewport');
		var __proto=Viewport.prototype;
		/**
		*变换一个三维向量。
		*@param source 源三维向量。
		*@param matrix 变换矩阵。
		*@param vector 输出三维向量。
		*/
		__proto.project=function(source,matrix,out){
			Vector3.transformV3ToV3(source,matrix,out);
			var sourceEleme=source.elements;
			var matrixEleme=matrix.elements;
			var outEleme=out.elements;
			var a=(((sourceEleme[0] *matrixEleme[3])+(sourceEleme[1] *matrixEleme[7]))+(sourceEleme[2] *matrixEleme[11]))+matrixEleme[15];
			if (a!==1.0){
				outEleme[0]=outEleme[0] / a;
				outEleme[1]=outEleme[1] / a;
				outEleme[2]=outEleme[2] / a;
			}
			outEleme[0]=(((outEleme[0]+1.0)*0.5)*this.width)+this.x;
			outEleme[1]=(((-outEleme[1]+1.0)*0.5)*this.height)+this.y;
			outEleme[2]=(outEleme[2] *(this.maxDepth-this.minDepth))+this.minDepth;
		}

		/**
		*反变换一个三维向量。
		*@param source 源三维向量。
		*@param matrix 变换矩阵。
		*@param vector 输出三维向量。
		*/
		__proto.unprojectFromMat=function(source,matrix,out){
			var sourceEleme=source.elements;
			var matrixEleme=matrix.elements;
			var outEleme=out.elements;
			outEleme[0]=(((sourceEleme[0]-this.x)/ (this.width))*2.0)-1.0;
			outEleme[1]=-((((sourceEleme[1]-this.y)/ (this.height))*2.0)-1.0);
			var halfDepth=(this.maxDepth-this.minDepth)/ 2;
			outEleme[2]=(sourceEleme[2]-this.minDepth-halfDepth)/ halfDepth;
			var a=(((outEleme[0] *matrixEleme[3])+(outEleme[1] *matrixEleme[7]))+(outEleme[2] *matrixEleme[11]))+matrixEleme[15];
			Vector3.transformV3ToV3(out,matrix,out);
			if (a!==1.0){
				outEleme[0]=outEleme[0] / a;
				outEleme[1]=outEleme[1] / a;
				outEleme[2]=outEleme[2] / a;
			}
		}

		/**
		*反变换一个三维向量。
		*@param source 源三维向量。
		*@param projection 透视投影矩阵。
		*@param view 视图矩阵。
		*@param world 世界矩阵,可设置为null。
		*@param out 输出向量。
		*/
		__proto.unprojectFromWVP=function(source,projection,view,world,out){
			Matrix4x4.multiply(projection,view,Viewport._tempMatrix4x4);
			(world)&& (Matrix4x4.multiply(Viewport._tempMatrix4x4,world,Viewport._tempMatrix4x4));
			Viewport._tempMatrix4x4.invert(Viewport._tempMatrix4x4);
			this.unprojectFromMat(source,Viewport._tempMatrix4x4,out);
		}

		__static(Viewport,
		['_tempMatrix4x4',function(){return this._tempMatrix4x4=new Matrix4x4();}
		]);
		return Viewport;
	})()


	/**
	*<code>SubMesh</code> 类用于创建子网格数据模板。
	*/
	//class laya.d3.resource.models.SubMesh
	var SubMesh=(function(){
		function SubMesh(){
			this._indexBuffer=null;
			this._vertexBuffer=null;
			this._boneIndices=null;
			this._bufferUsage=null;
			this._indexInMesh=0;
			this._bufferUsage={};
		}

		__class(SubMesh,'laya.d3.resource.models.SubMesh');
		var __proto=SubMesh.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IRenderable":true,"laya.resource.IDispose":true})
		/**
		*@private
		*/
		__proto._testTangent=function(state){
			var vb=this._vertexBuffer;
			var vertexDeclaration=vb.vertexDeclaration;
			var material=state.renderElement._material;
			if (material.normalTexture && !vertexDeclaration.getVertexElementByUsage("TANGENT0")){
				var vertexDatas=vb.getData();
				var newVertexDatas=Utils3D.generateTangent(vertexDatas,vertexDeclaration.vertexStride / 4,vertexDeclaration.getVertexElementByUsage("POSITION").offset / 4,vertexDeclaration.getVertexElementByUsage("UV").offset / 4,this._indexBuffer.getData());
				vertexDeclaration=Utils3D.getVertexTangentDeclaration(vertexDeclaration.getVertexElements());
				var newVB=VertexBuffer3D.create(vertexDeclaration,0x88E4);
				newVB.setData(newVertexDatas);
				vb.dispose();
				this._vertexBuffer=newVB;
				this._bufferUsage["TANGENT0"]=newVB;
			}
		}

		/**
		*@private
		*/
		__proto._getVertexBuffer=function(index){
			(index===void 0)&& (index=0);
			if (index===0)
				return this._vertexBuffer;
			else
			return null;
		}

		/**
		*@private
		*/
		__proto._getIndexBuffer=function(){
			return this._indexBuffer;
		}

		/**
		*@private
		*/
		__proto._beforeRender=function(state){
			this._testTangent(state);
			this._vertexBuffer._bind();
			this._indexBuffer._bind();
			return true;
		}

		/**
		*@private
		*渲染。
		*@param state 渲染状态。
		*/
		__proto._render=function(state){
			var indexCount=this._indexBuffer.indexCount;
			state.context.drawElements(0x0004,indexCount,0x1403,0);
			Stat.drawCall++;
			Stat.trianglesFaces+=indexCount / 3;
		}

		/**
		*<p>彻底清理资源。</p>
		*<p><b>注意：</b>会强制解锁清理。</p>
		*/
		__proto.dispose=function(){
			this._boneIndices=null;
			this._indexBuffer.dispose();
			this._vertexBuffer.dispose();
		}

		/**
		*@private
		*/
		__getset(0,__proto,'_vertexBufferCount',function(){
			return 1;
		});

		/**
		*@private
		*/
		__getset(0,__proto,'indexOfHost',function(){
			return this._indexInMesh;
		});

		/**
		*@private
		*/
		__getset(0,__proto,'triangleCount',function(){
			return this._indexBuffer.indexCount / 3;
		});

		return SubMesh;
	})()


	//class laya.webgl.shader.ShaderDefines
	var ShaderDefines=(function(){
		function ShaderDefines(name2int,int2name,int2nameMap){
			this._value=0;
			//this._name2int=null;
			//this._int2name=null;
			//this._int2nameMap=null;
			this._name2int=name2int;
			this._int2name=int2name;
			this._int2nameMap=int2nameMap;
		}

		__class(ShaderDefines,'laya.webgl.shader.ShaderDefines');
		var __proto=ShaderDefines.prototype;
		__proto.add=function(value){
			if ((typeof value=='string'))value=this._name2int[value];
			this._value |=value;
			return this._value;
		}

		__proto.addInt=function(value){
			this._value |=value;
			return this._value;
		}

		__proto.remove=function(value){
			if ((typeof value=='string'))value=this._name2int[value];
			this._value &=(~value);
			return this._value;
		}

		__proto.isDefine=function(def){
			return (this._value & def)===def;
		}

		__proto.getValue=function(){
			return this._value;
		}

		__proto.setValue=function(value){
			this._value=value;
		}

		__proto.toNameDic=function(){
			var r=this._int2nameMap[this._value];
			return r ? r :ShaderDefines._toText(this._value,this._int2name,this._int2nameMap);
		}

		ShaderDefines._reg=function(name,value,_name2int,_int2name){
			_name2int[name]=value;
			_int2name[value]=name;
		}

		ShaderDefines._toText=function(value,_int2name,_int2nameMap){
			var r=_int2nameMap[value];
			if (r)return r;
			var o={};
			var d=1;
			for (var i=0;i < 32;i++){
				d=1 << i;
				if (d > value)break ;
				if (value & d){
					var name=_int2name[d];
					name && (o[name]="");
				}
			}
			_int2nameMap[value]=o;
			return o;
		}

		ShaderDefines._toInt=function(names,_name2int){
			var words=names.split('.');
			var num=0;
			for (var i=0,n=words.length;i < n;i++){
				var value=_name2int[words[i]];
				if (!value)throw new Error("Defines to int err:"+names+"/"+words[i]);
				num |=value;
			}
			return num;
		}

		return ShaderDefines;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.d3.utils.Physics
	var Physics=(function(){
		function Physics(){}
		__class(Physics,'laya.d3.utils.Physics');
		Physics.rayCastNode=function(ray,sprite3D,outHitInfo){
			if ((sprite3D instanceof laya.d3.core.MeshSprite3D )){
				var meshSprite3D=sprite3D;
				var worldMatrix=sprite3D.transform.worldMatrix;
				var invertWorldMatrix=Physics._tempMatrix4x40;
				worldMatrix.invert(invertWorldMatrix);
				var preRayOrigin=Physics._tempVector30;
				var preRayDirection=Physics._tempVector31;
				var rayOrigin=ray.origin;
				var rayDirection=ray.direction;
				rayOrigin.cloneTo(preRayOrigin);
				rayDirection.cloneTo(preRayDirection);
				Vector3.transformCoordinate(rayOrigin,invertWorldMatrix,rayOrigin);
				Vector3.TransformNormal(rayDirection,invertWorldMatrix,rayDirection);
				Vector3.normalize(rayDirection,rayDirection);
				var renderElements=meshSprite3D.meshRender.renderCullingObject._renderElements;
				for (var i=0,iNum=renderElements.length;i < iNum;i++){
					var renderObj=renderElements[i].renderObj;
					var vertexBuffer=renderObj._getVertexBuffer(0);
					var vertexDatas=vertexBuffer.getData();
					var indexDatas=renderObj._getIndexBuffer().getData();
					var elementRaycastHit=Physics._tempRaycastHit0;
					var isHit=Picker.rayIntersectsPositionsAndIndices(ray,vertexDatas,vertexBuffer.vertexDeclaration,indexDatas,elementRaycastHit);
					if (isHit){
						Vector3.transformCoordinate(elementRaycastHit.position,worldMatrix,elementRaycastHit.position);
						var trianglePositions=elementRaycastHit.trianglePositions;
						Vector3.transformCoordinate(trianglePositions[0],worldMatrix,trianglePositions[0]);
						Vector3.transformCoordinate(trianglePositions[1],worldMatrix,trianglePositions[1]);
						Vector3.transformCoordinate(trianglePositions[2],worldMatrix,trianglePositions[2]);
						var triangleNormals=elementRaycastHit.triangleNormals;
						Vector3.transformCoordinate(triangleNormals[0],worldMatrix,triangleNormals[0]);
						Vector3.transformCoordinate(triangleNormals[1],worldMatrix,triangleNormals[1]);
						Vector3.transformCoordinate(triangleNormals[2],worldMatrix,triangleNormals[2]);
						var rayOriToPos=Physics._tempVector33;
						Vector3.subtract(preRayOrigin,elementRaycastHit.position,rayOriToPos);
						outHitInfo.distance=Vector3.scalarLength(rayOriToPos);
					}
					if (isHit && elementRaycastHit.distance < outHitInfo.distance){
						elementRaycastHit.copy(outHitInfo);
					}
				}
				preRayOrigin.cloneTo(rayOrigin);
				preRayDirection.cloneTo(rayDirection);
			}
			for (var j=0,jNum=sprite3D._childs.length;j < jNum;j++)
			Physics.rayCast(ray,sprite3D._childs[j],outHitInfo);
		}

		Physics.rayCast=function(ray,sprite3D,outHitInfo){
			outHitInfo.position.toDefault();
			outHitInfo.distance=Number.MAX_VALUE;
			outHitInfo.trianglePositions[0].toDefault();
			outHitInfo.trianglePositions[1].toDefault();
			outHitInfo.trianglePositions[2].toDefault();
			outHitInfo.triangleNormals[0].toDefault();
			outHitInfo.triangleNormals[1].toDefault();
			outHitInfo.triangleNormals[2].toDefault();
			Physics.rayCastNode(ray,sprite3D,outHitInfo);
		}

		__static(Physics,
		['_tempVector30',function(){return this._tempVector30=new Vector3();},'_tempVector31',function(){return this._tempVector31=new Vector3();},'_tempVector33',function(){return this._tempVector33=new Vector3();},'_tempMatrix4x40',function(){return this._tempMatrix4x40=new Matrix4x4();},'_tempRaycastHit0',function(){return this._tempRaycastHit0=new RaycastHit();}
		]);
		return Physics;
	})()


	/**
	*<code>Picker</code> 类用于创建拾取。
	*/
	//class laya.d3.utils.Picker
	var Picker=(function(){
		/**
		*创建一个 <code>Picker</code> 实例。
		*/
		function Picker(){}
		__class(Picker,'laya.d3.utils.Picker');
		Picker.calculateCursorRay=function(point,viewPort,projectionMatrix,viewMatrix,world,out){
			var x=point.elements[0];
			var y=point.elements[1];
			var nearSource=Picker._tempVector30;
			var nerSourceE=nearSource.elements;
			nerSourceE[0]=x;
			nerSourceE[1]=y;
			nerSourceE[2]=viewPort.minDepth;
			var farSource=Picker._tempVector31;
			var farSourceE=farSource.elements;
			farSourceE[0]=x;
			farSourceE[1]=y;
			farSourceE[2]=viewPort.maxDepth;
			var nearPoint=out.origin;
			var farPoint=Picker._tempVector32;
			viewPort.unprojectFromWVP(nearSource,projectionMatrix,viewMatrix,world,nearPoint);
			viewPort.unprojectFromWVP(farSource,projectionMatrix,viewMatrix,world,farPoint);
			var outDire=out.direction.elements;
			outDire[0]=farPoint.x-nearPoint.x;
			outDire[1]=farPoint.y-nearPoint.y;
			outDire[2]=farPoint.z-nearPoint.z;
			Vector3.normalize(out.direction,out.direction);
		}

		Picker.rayIntersectsPositionsAndIndices=function(ray,vertexDatas,vertexDeclaration,indices,outHitInfo){
			var vertexStrideFloatCount=vertexDeclaration.vertexStride / 4;
			var positionVertexElementOffset=vertexDeclaration.getVertexElementByUsage("POSITION").offset / 4;
			var closestIntersection=Number.MAX_VALUE;
			var closestTriangleVertexIndex1=-1;
			var closestTriangleVertexIndex2=-1;
			var closestTriangleVertexIndex3=-1;
			for (var j=0;j < indices.length;j+=3){
				var vertex1=Picker._tempVector35;
				var vertex1E=vertex1.elements;
				var vertex1Index=indices[j] *vertexStrideFloatCount;
				var vertex1PositionIndex=vertex1Index+positionVertexElementOffset;
				vertex1E[0]=vertexDatas[vertex1PositionIndex];
				vertex1E[1]=vertexDatas[vertex1PositionIndex+1];
				vertex1E[2]=vertexDatas[vertex1PositionIndex+2];
				var vertex2=Picker._tempVector36;
				var vertex2E=vertex2.elements;
				var vertex2Index=indices[j+1] *vertexStrideFloatCount;
				var vertex2PositionIndex=vertex2Index+positionVertexElementOffset;
				vertex2E[0]=vertexDatas[vertex2PositionIndex];
				vertex2E[1]=vertexDatas[vertex2PositionIndex+1];
				vertex2E[2]=vertexDatas[vertex2PositionIndex+2];
				var vertex3=Picker._tempVector37;
				var vertex3E=vertex3.elements;
				var vertex3Index=indices[j+2] *vertexStrideFloatCount;
				var vertex3PositionIndex=vertex3Index+positionVertexElementOffset;
				vertex3E[0]=vertexDatas[vertex3PositionIndex];
				vertex3E[1]=vertexDatas[vertex3PositionIndex+1];
				vertex3E[2]=vertexDatas[vertex3PositionIndex+2];
				var intersection=laya.d3.utils.Picker.rayIntersectsTriangle(ray,vertex1,vertex2,vertex3);
				if (!isNaN(intersection)&& intersection < closestIntersection){
					closestIntersection=intersection;
					closestTriangleVertexIndex1=vertex1Index;
					closestTriangleVertexIndex2=vertex2Index;
					closestTriangleVertexIndex3=vertex3Index;
				}
			}
			if (closestIntersection!==Number.MAX_VALUE){
				outHitInfo.distance=closestIntersection;
				Vector3.normalize(ray.direction,ray.direction);
				Vector3.scale(ray.direction,closestIntersection,outHitInfo.position);
				Vector3.add(ray.origin,outHitInfo.position,outHitInfo.position);
				var trianglePositions=outHitInfo.trianglePositions;
				var position0=trianglePositions[0];
				var position1=trianglePositions[1];
				var position2=trianglePositions[2];
				var position0E=position0.elements;
				var position1E=position1.elements;
				var position2E=position2.elements;
				var closestVertex1PositionIndex=closestTriangleVertexIndex1+positionVertexElementOffset;
				position0E[0]=vertexDatas[closestVertex1PositionIndex];
				position0E[1]=vertexDatas[closestVertex1PositionIndex+1];
				position0E[2]=vertexDatas[closestVertex1PositionIndex+2];
				var closestVertex2PositionIndex=closestTriangleVertexIndex2+positionVertexElementOffset;
				position1E[0]=vertexDatas[closestVertex2PositionIndex];
				position1E[1]=vertexDatas[closestVertex2PositionIndex+1];
				position1E[2]=vertexDatas[closestVertex2PositionIndex+2];
				var closestVertex3PositionIndex=closestTriangleVertexIndex3+positionVertexElementOffset;
				position2E[0]=vertexDatas[closestVertex3PositionIndex];
				position2E[1]=vertexDatas[closestVertex3PositionIndex+1];
				position2E[2]=vertexDatas[closestVertex3PositionIndex+2];
				var normalVertexElement=vertexDeclaration.getVertexElementByUsage("NORMAL");
				if (normalVertexElement){
					var normalVertexElementOffset=normalVertexElement.offset / 4;
					var triangleNormals=outHitInfo.triangleNormals;
					var normal0=triangleNormals[0];
					var normal1=triangleNormals[1];
					var normal2=triangleNormals[2];
					var normal0E=normal0.elements;
					var normal1E=normal1.elements;
					var normal2E=normal2.elements;
					var closestVertex1NormalIndex=closestTriangleVertexIndex1+normalVertexElementOffset;
					normal0E[0]=vertexDatas[closestVertex1NormalIndex];
					normal0E[1]=vertexDatas[closestVertex1NormalIndex+1];
					normal0E[2]=vertexDatas[closestVertex1NormalIndex+2];
					var closestVertex2NormalIndex=closestTriangleVertexIndex2+normalVertexElementOffset;
					normal1E[0]=vertexDatas[closestVertex2NormalIndex];
					normal1E[1]=vertexDatas[closestVertex2NormalIndex+1];
					normal1E[2]=vertexDatas[closestVertex2NormalIndex+2];
					var closestVertex3NormalIndex=closestTriangleVertexIndex3+normalVertexElementOffset;
					normal2E[0]=vertexDatas[closestVertex3NormalIndex];
					normal2E[1]=vertexDatas[closestVertex3NormalIndex+1];
					normal2E[2]=vertexDatas[closestVertex3NormalIndex+2];
				}
				return true;
				}else {
				outHitInfo.position.toDefault();
				outHitInfo.distance=Number.MAX_VALUE;
				outHitInfo.trianglePositions[0].toDefault();
				outHitInfo.trianglePositions[1].toDefault();
				outHitInfo.trianglePositions[2].toDefault();
				outHitInfo.triangleNormals[0].toDefault();
				outHitInfo.triangleNormals[1].toDefault();
				outHitInfo.triangleNormals[2].toDefault();
				return false;
			}
		}

		Picker.rayIntersectsTriangle=function(ray,vertex1,vertex2,vertex3){
			var result;
			var edge1=Picker._tempVector30,edge2=Picker._tempVector31;
			Vector3.subtract(vertex2,vertex1,edge1);
			Vector3.subtract(vertex3,vertex1,edge2);
			var directionCrossEdge2=Picker._tempVector32;
			Vector3.cross(ray.direction,edge2,directionCrossEdge2);
			var determinant;
			determinant=Vector3.dot(edge1,directionCrossEdge2);
			if (determinant >-Number.MIN_VALUE && determinant < Number.MIN_VALUE){
				result=Number.NaN;
				return result;
			};
			var inverseDeterminant=1.0 / determinant;
			var distanceVector=Picker._tempVector33;
			Vector3.subtract(ray.origin,vertex1,distanceVector);
			var triangleU;
			triangleU=Vector3.dot(distanceVector,directionCrossEdge2);
			triangleU *=inverseDeterminant;
			if (triangleU < 0 || triangleU > 1){
				result=Number.NaN;
				return result;
			};
			var distanceCrossEdge1=Picker._tempVector34;
			Vector3.cross(distanceVector,edge1,distanceCrossEdge1);
			var triangleV;
			triangleV=Vector3.dot(ray.direction,distanceCrossEdge1);
			triangleV *=inverseDeterminant;
			if (triangleV < 0 || triangleU+triangleV > 1){
				result=Number.NaN;
				return result;
			};
			var rayDistance;
			rayDistance=Vector3.dot(edge2,distanceCrossEdge1);
			rayDistance *=inverseDeterminant;
			if (rayDistance < 0){
				result=Number.NaN;
				return result;
			}
			result=rayDistance;
			return result;
		}

		__static(Picker,
		['_tempVector30',function(){return this._tempVector30=new Vector3();},'_tempVector31',function(){return this._tempVector31=new Vector3();},'_tempVector32',function(){return this._tempVector32=new Vector3();},'_tempVector33',function(){return this._tempVector33=new Vector3();},'_tempVector34',function(){return this._tempVector34=new Vector3();},'_tempVector35',function(){return this._tempVector35=new Vector3();},'_tempVector36',function(){return this._tempVector36=new Vector3();},'_tempVector37',function(){return this._tempVector37=new Vector3();}
		]);
		return Picker;
	})()


	/**
	*...
	*@author ...
	*/
	//class laya.d3.utils.RaycastHit
	var RaycastHit=(function(){
		function RaycastHit(){
			this.distance=NaN;
			this.trianglePositions=null;
			this.triangleNormals=null;
			this.position=null;
			this.distance=Number.MAX_VALUE;
			this.trianglePositions=[new Vector3(),new Vector3(),new Vector3()];
			this.trianglePositions.length=3;
			this.triangleNormals=[new Vector3(),new Vector3(),new Vector3()];
			this.triangleNormals.length=3;
			this.position=new Vector3();
		}

		__class(RaycastHit,'laya.d3.utils.RaycastHit');
		var __proto=RaycastHit.prototype;
		__proto.copy=function(dec){
			dec.distance=this.distance;
			this.trianglePositions[0].cloneTo(dec.trianglePositions[0]);
			this.trianglePositions[1].cloneTo(dec.trianglePositions[1]);
			this.trianglePositions[2].cloneTo(dec.trianglePositions[2]);
			this.triangleNormals[0].cloneTo(dec.triangleNormals[0]);
			this.triangleNormals[1].cloneTo(dec.triangleNormals[1]);
			this.triangleNormals[2].cloneTo(dec.triangleNormals[2]);
			this.position.cloneTo(dec.position);
		}

		return RaycastHit;
	})()


	//class laya.d3.utils.Size
	var Size=(function(){
		function Size(width,height){
			this._width=0;
			this._height=0;
			this._width=width;
			this._height=height;
		}

		__class(Size,'laya.d3.utils.Size');
		var __proto=Size.prototype;
		__getset(0,__proto,'width',function(){
			if (this._width===-1)
				return RenderState.clientWidth;
			return this._width;
		});

		__getset(0,__proto,'height',function(){
			if (this._height===-1)
				return RenderState.clientHeight;
			return this._height;
		});

		__getset(1,Size,'fullScreen',function(){
			return new Size(-1,-1);
		});

		return Size;
	})()


	/**
	*<code>Utils3D</code> 类用于创建3D工具。
	*/
	//class laya.d3.utils.Utils3D
	var Utils3D=(function(){
		function Utils3D(){};
		__class(Utils3D,'laya.d3.utils.Utils3D');
		Utils3D._getTexturePath=function(path){
			var extenIndex=path.length-4;
			if (path.indexOf(".dds")==extenIndex || path.indexOf(".tga")==extenIndex || path.indexOf(".exr")==extenIndex || path.indexOf(".DDS")==extenIndex || path.indexOf(".TGA")==extenIndex || path.indexOf(".EXR")==extenIndex)
				path=path.substr(0,extenIndex)+".png";
			return path=URL.formatURL(path);
		}

		Utils3D._rotationTransformScaleSkinAnimation=function(tx,ty,tz,qx,qy,qz,qw,sx,sy,sz,outArray,outOffset){
			var re=Utils3D._tempArray16_0;
			var se=Utils3D._tempArray16_1;
			var tse=Utils3D._tempArray16_2;
			var x2=qx+qx;
			var y2=qy+qy;
			var z2=qz+qz;
			var xx=qx *x2;
			var yx=qy *x2;
			var yy=qy *y2;
			var zx=qz *x2;
			var zy=qz *y2;
			var zz=qz *z2;
			var wx=qw *x2;
			var wy=qw *y2;
			var wz=qw *z2;
			re[15]=1;
			re[0]=1-yy-zz;
			re[1]=yx+wz;
			re[2]=zx-wy;
			re[4]=yx-wz;
			re[5]=1-xx-zz;
			re[6]=zy+wx;
			re[8]=zx+wy;
			re[9]=zy-wx;
			re[10]=1-xx-yy;
			se[15]=1;
			se[0]=sx;
			se[5]=sy;
			se[10]=sz;
			var i,a,b,e,ai0,ai1,ai2,ai3;
			for (i=0;i < 4;i++){
				ai0=re[i];
				ai1=re[i+4];
				ai2=re[i+8];
				ai3=re[i+12];
				tse[i]=ai0;
				tse[i+4]=ai1;
				tse[i+8]=ai2;
				tse[i+12]=ai0 *tx+ai1 *ty+ai2 *tz+ai3;
			}
			for (i=0;i < 4;i++){
				ai0=tse[i];
				ai1=tse[i+4];
				ai2=tse[i+8];
				ai3=tse[i+12];
				outArray[i+outOffset]=ai0 *se[0]+ai1 *se[1]+ai2 *se[2]+ai3 *se[3];
				outArray[i+outOffset+4]=ai0 *se[4]+ai1 *se[5]+ai2 *se[6]+ai3 *se[7];
				outArray[i+outOffset+8]=ai0 *se[8]+ai1 *se[9]+ai2 *se[10]+ai3 *se[11];
				outArray[i+outOffset+12]=ai0 *se[12]+ai1 *se[13]+ai2 *se[14]+ai3 *se[15];
			}
		}

		Utils3D._parseHierarchyProp=function(node,prop,value){
			switch (prop){
				case "translate":
					node.transform.localPosition=new Vector3(value[0],value[1],value[2]);
					break ;
				case "rotation":
					node.transform.localRotation=new Quaternion(value[0],value[1],value[2],value[3]);
					break ;
				case "scale":
					node.transform.localScale=new Vector3(value[0],value[1],value[2]);
					break ;
				}
		}

		Utils3D._parseHierarchyNode=function(instanceParams){
			if (instanceParams)
				return new MeshSprite3D(Mesh.load(instanceParams.loadPath));
			else
			return new Sprite3D();
		}

		Utils3D._parseMaterial=function(material,prop,value){
			switch (prop){
				case "ambientColor":
					material.ambientColor=new Vector3(value[0],value[1],value[2]);
					break ;
				case "diffuseColor":
					material.diffuseColor=new Vector3(value[0],value[1],value[2]);
					break ;
				case "specularColor":
					material.specularColor=new Vector4(value[0],value[1],value[2],value[3]);
					break ;
				case "reflectColor":
					material.reflectColor=new Vector3(value[0],value[1],value[2]);
					break ;
				case "diffuseTexture":
					(value.texture2D)&& (Laya.loader.load(Utils3D._getTexturePath(value.texture2D),Handler.create(null,function(tex){
						material.diffuseTexture=tex;
					}),null,"texture2d"));
					break ;
				case "normalTexture":
					(value.texture2D)&& (Laya.loader.load(Utils3D._getTexturePath(value.texture2D),Handler.create(null,function(tex){
						material.normalTexture=tex;
					}),null,"texture2d"));
					break ;
				case "specularTexture":
					(value.texture2D)&& (Laya.loader.load(Utils3D._getTexturePath(value.texture2D),Handler.create(null,function(tex){
						material.specularTexture=tex;
					}),null,"texture2d"));
					break ;
				case "emissiveTexture":
					(value.texture2D)&& (Laya.loader.load(Utils3D._getTexturePath(value.texture2D),Handler.create(null,function(tex){
						material.emissiveTexture=tex;
					}),null,"texture2d"));
					break ;
				case "ambientTexture":
					(value.texture2D)&& (Laya.loader.load(Utils3D._getTexturePath(value.texture2D),Handler.create(null,function(tex){
						material.ambientTexture=tex;
					}),null,"texture2d"));
					break ;
				case "reflectTexture":
					(value.texture2D)&& (Laya.loader.load(Utils3D._getTexturePath(value.texture2D),Handler.create(null,function(tex){
						material.reflectTexture=tex;
					}),null,"texture2d"));
					break ;
				}
		}

		Utils3D._computeBoneAndAnimationDatas=function(bones,curData,exData,outBonesDatas,outAnimationDatas){
			var offset=0;
			var matOffset=0;
			var len=exData.length / 2;
			var i;
			var parentOffset;
			var boneLength=bones.length;
			for (i=0;i < boneLength;offset+=bones[i].keyframeWidth,matOffset+=16,i++){
				laya.d3.utils.Utils3D._rotationTransformScaleSkinAnimation(curData[offset+7],curData[offset+8],curData[offset+9],curData[offset+3],curData[offset+4],curData[offset+5],curData[offset+6],curData[offset+0],curData[offset+1],curData[offset+2],outBonesDatas,matOffset);
				if (i !=0){
					parentOffset=bones[i].parentIndex *16;
					laya.d3.utils.Utils3D.mulMatrixByArray(outBonesDatas,parentOffset,outBonesDatas,matOffset,outBonesDatas,matOffset);
				}
			}
			for (i=0;i < len;i+=16){
				laya.d3.utils.Utils3D.mulMatrixByArrayFast(outBonesDatas,i,exData,len+i,outAnimationDatas,i);
			}
		}

		Utils3D._computeAnimationDatas=function(exData,bonesDatas,outAnimationDatas){
			var len=exData.length / 2;
			for (var i=0;i < len;i+=16){
				laya.d3.utils.Utils3D.mulMatrixByArrayFast(bonesDatas,i,exData,len+i,outAnimationDatas,i);
			}
		}

		Utils3D._computeBoneAndAnimationDatasByBindPoseMatrxix=function(bones,curData,inverGlobalBindPose,outBonesDatas,outAnimationDatas){
			var offset=0;
			var matOffset=0;
			var i;
			var parentOffset;
			var boneLength=bones.length;
			for (i=0;i < boneLength;offset+=bones[i].keyframeWidth,matOffset+=16,i++){
				laya.d3.utils.Utils3D._rotationTransformScaleSkinAnimation(curData[offset+7],curData[offset+8],curData[offset+9],curData[offset+3],curData[offset+4],curData[offset+5],curData[offset+6],curData[offset+0],curData[offset+1],curData[offset+2],outBonesDatas,matOffset);
				if (i !=0){
					parentOffset=bones[i].parentIndex *16;
					laya.d3.utils.Utils3D.mulMatrixByArray(outBonesDatas,parentOffset,outBonesDatas,matOffset,outBonesDatas,matOffset);
				}
			};
			var n=inverGlobalBindPose.length;
			for (i=0;i < n;i++){
				var arrayOffset=i *16;
				laya.d3.utils.Utils3D.mulMatrixByArrayAndMatrixFast(outBonesDatas,arrayOffset,inverGlobalBindPose[i],outAnimationDatas,arrayOffset);
			}
		}

		Utils3D._computeAnimationDatasByArrayAndMatrixFast=function(inverGlobalBindPose,bonesDatas,outAnimationDatas){
			var n=inverGlobalBindPose.length;
			for (var i=0;i < n;i++){
				var arrayOffset=i *16;
				laya.d3.utils.Utils3D.mulMatrixByArrayAndMatrixFast(bonesDatas,arrayOffset,inverGlobalBindPose[i],outAnimationDatas,arrayOffset);
			}
		}

		Utils3D._computeRootAnimationData=function(bones,curData,animationDatas){
			for (var i=0,offset=0,matOffset=0,boneLength=bones.length;i < boneLength;offset+=bones[i].keyframeWidth,matOffset+=16,i++)
			laya.d3.utils.Utils3D.createAffineTransformationArray(curData[offset+0],curData[offset+1],curData[offset+2],curData[offset+3],curData[offset+4],curData[offset+5],curData[offset+6],curData[offset+7],curData[offset+8],curData[offset+9],animationDatas,matOffset);
		}

		Utils3D.generateTangent=function(vertexDatas,vertexStride,positionOffset,uvOffset,indices){
			var tangentElementCount=3;
			var newVertexStride=vertexStride+tangentElementCount;
			var tangentVertexDatas=new Float32Array(newVertexStride *(vertexDatas.length / vertexStride));
			for (var i=0;i < indices.length;i+=3){
				var index1=indices[i+0];
				var index2=indices[i+1];
				var index3=indices[i+2];
				var position1Offset=vertexStride *index1+positionOffset;
				var position1=Utils3D._tempVector3_0;
				position1.x=vertexDatas[position1Offset+0];
				position1.y=vertexDatas[position1Offset+1];
				position1.z=vertexDatas[position1Offset+2];
				var position2Offset=vertexStride *index2+positionOffset;
				var position2=Utils3D._tempVector3_1;
				position2.x=vertexDatas[position2Offset+0];
				position2.y=vertexDatas[position2Offset+1];
				position2.z=vertexDatas[position2Offset+2];
				var position3Offset=vertexStride *index3+positionOffset;
				var position3=Utils3D._tempVector3_2;
				position3.x=vertexDatas[position3Offset+0];
				position3.y=vertexDatas[position3Offset+1];
				position3.z=vertexDatas[position3Offset+2];
				var uv1Offset=vertexStride *index1+uvOffset;
				var UV1X=vertexDatas[uv1Offset+0];
				var UV1Y=vertexDatas[uv1Offset+1];
				var uv2Offset=vertexStride *index2+uvOffset;
				var UV2X=vertexDatas[uv2Offset+0];
				var UV2Y=vertexDatas[uv2Offset+1];
				var uv3Offset=vertexStride *index3+uvOffset;
				var UV3X=vertexDatas[uv3Offset+0];
				var UV3Y=vertexDatas[uv3Offset+1];
				var lengthP2ToP1=Utils3D._tempVector3_3;
				Vector3.subtract(position2,position1,lengthP2ToP1);
				var lengthP3ToP1=Utils3D._tempVector3_4;
				Vector3.subtract(position3,position1,lengthP3ToP1);
				Vector3.scale(lengthP2ToP1,UV3Y-UV1Y,lengthP2ToP1);
				Vector3.scale(lengthP3ToP1,UV2Y-UV1Y,lengthP3ToP1);
				var tangent=Utils3D._tempVector3_5;
				Vector3.subtract(lengthP2ToP1,lengthP3ToP1,tangent);
				Vector3.scale(tangent,1.0 / ((UV2X-UV1X)*(UV3Y-UV1Y)-(UV2Y-UV1Y)*(UV3X-UV1X)),tangent);
				var j=0;
				for (j=0;j < vertexStride;j++)
				tangentVertexDatas[newVertexStride *index1+j]=vertexDatas[vertexStride *index1+j];
				for (j=0;j < tangentElementCount;j++)
				tangentVertexDatas[newVertexStride *index1+vertexStride+j]=+tangent.elements[j];
				for (j=0;j < vertexStride;j++)
				tangentVertexDatas[newVertexStride *index2+j]=vertexDatas[vertexStride *index2+j];
				for (j=0;j < tangentElementCount;j++)
				tangentVertexDatas[newVertexStride *index2+vertexStride+j]=+tangent.elements[j];
				for (j=0;j < vertexStride;j++)
				tangentVertexDatas[newVertexStride *index3+j]=vertexDatas[vertexStride *index3+j];
				for (j=0;j < tangentElementCount;j++)
				tangentVertexDatas[newVertexStride *index3+vertexStride+j]=+tangent.elements[j];
			}
			for (i=0;i < tangentVertexDatas.length;i+=newVertexStride){
				var tangentStartIndex=newVertexStride *i+vertexStride;
				var t=Utils3D._tempVector3_6;
				t.x=tangentVertexDatas[tangentStartIndex+0];
				t.y=tangentVertexDatas[tangentStartIndex+1];
				t.z=tangentVertexDatas[tangentStartIndex+2];
				Vector3.normalize(t,t);
				tangentVertexDatas[tangentStartIndex+0]=t.x;
				tangentVertexDatas[tangentStartIndex+1]=t.y;
				tangentVertexDatas[tangentStartIndex+2]=t.z;
			}
			return tangentVertexDatas;
		}

		Utils3D.getVertexTangentDeclaration=function(vertexElements){
			var position=false,normal=false,color=false,texcoord=false,blendWeight=false,blendIndex=false;
			for (var i=0;i < vertexElements.length;i++){
				switch ((vertexElements [i]).elementUsage){
					case "POSITION":
						position=true;
						break ;
					case "NORMAL":
						normal=true;
						break ;
					case "COLOR":
						color=true;
						break ;
					case "UV":
						texcoord=true;
						break ;
					case "BLENDWEIGHT":
						blendWeight=true;
						break ;
					case "BLENDINDICES":
						blendIndex=true;
						break ;
					}
			};
			var vertexDeclaration;
			if (position && normal && color && texcoord && blendWeight && blendIndex)
				vertexDeclaration=VertexPositionNormalColorTextureSkinTangent.vertexDeclaration;
			else if (position && normal && texcoord && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalTextureSkinTangent.vertexDeclaration;
			else if (position && normal && color && blendWeight && blendIndex)
			vertexDeclaration=VertexPositionNormalColorSkinTangent.vertexDeclaration;
			else if (position && normal && color && texcoord)
			vertexDeclaration=VertexPositionNormalColorTextureTangent.vertexDeclaration;
			else if (position && normal && texcoord)
			vertexDeclaration=VertexPositionNormalTextureTangent.vertexDeclaration;
			else if (position && normal && color)
			vertexDeclaration=VertexPositionNormalColorTangent.vertexDeclaration;
			return vertexDeclaration;
		}

		Utils3D.transformVector3ArrayByQuat=function(sourceArray,sourceOffset,rotation,outArray,outOffset){
			var re=rotation.elements;
			var x=sourceArray[sourceOffset],y=sourceArray[sourceOffset+1],z=sourceArray[sourceOffset+2],qx=re[0],qy=re[1],qz=re[2],qw=re[3],
			ix=qw *x+qy *z-qz *y,iy=qw *y+qz *x-qx *z,iz=qw *z+qx *y-qy *x,iw=-qx *x-qy *y-qz *z;
			outArray[outOffset]=ix *qw+iw *-qx+iy *-qz-iz *-qy;
			outArray[outOffset+1]=iy *qw+iw *-qy+iz *-qx-ix *-qz;
			outArray[outOffset+2]=iz *qw+iw *-qz+ix *-qy-iy *-qx;
		}

		Utils3D.mulMatrixByArray=function(leftArray,leftOffset,rightArray,rightOffset,outArray,outOffset){
			var i,ai0,ai1,ai2,ai3;
			if (outArray===rightArray){
				rightArray=Utils3D._tempArray16_3;
				for (i=0;i < 16;++i){
					rightArray[i]=outArray[outOffset+i];
				}
				rightOffset=0;
			}
			for (i=0;i < 4;i++){
				ai0=leftArray[leftOffset+i];
				ai1=leftArray[leftOffset+i+4];
				ai2=leftArray[leftOffset+i+8];
				ai3=leftArray[leftOffset+i+12];
				outArray[outOffset+i]=ai0 *rightArray[rightOffset+0]+ai1 *rightArray[rightOffset+1]+ai2 *rightArray[rightOffset+2]+ai3 *rightArray[rightOffset+3];
				outArray[outOffset+i+4]=ai0 *rightArray[rightOffset+4]+ai1 *rightArray[rightOffset+5]+ai2 *rightArray[rightOffset+6]+ai3 *rightArray[rightOffset+7];
				outArray[outOffset+i+8]=ai0 *rightArray[rightOffset+8]+ai1 *rightArray[rightOffset+9]+ai2 *rightArray[rightOffset+10]+ai3 *rightArray[rightOffset+11];
				outArray[outOffset+i+12]=ai0 *rightArray[rightOffset+12]+ai1 *rightArray[rightOffset+13]+ai2 *rightArray[rightOffset+14]+ai3 *rightArray[rightOffset+15];
			}
		}

		Utils3D.mulMatrixByArrayFast=function(leftArray,leftOffset,rightArray,rightOffset,outArray,outOffset){
			var i,ai0,ai1,ai2,ai3;
			for (i=0;i < 4;i++){
				ai0=leftArray[leftOffset+i];
				ai1=leftArray[leftOffset+i+4];
				ai2=leftArray[leftOffset+i+8];
				ai3=leftArray[leftOffset+i+12];
				outArray[outOffset+i]=ai0 *rightArray[rightOffset+0]+ai1 *rightArray[rightOffset+1]+ai2 *rightArray[rightOffset+2]+ai3 *rightArray[rightOffset+3];
				outArray[outOffset+i+4]=ai0 *rightArray[rightOffset+4]+ai1 *rightArray[rightOffset+5]+ai2 *rightArray[rightOffset+6]+ai3 *rightArray[rightOffset+7];
				outArray[outOffset+i+8]=ai0 *rightArray[rightOffset+8]+ai1 *rightArray[rightOffset+9]+ai2 *rightArray[rightOffset+10]+ai3 *rightArray[rightOffset+11];
				outArray[outOffset+i+12]=ai0 *rightArray[rightOffset+12]+ai1 *rightArray[rightOffset+13]+ai2 *rightArray[rightOffset+14]+ai3 *rightArray[rightOffset+15];
			}
		}

		Utils3D.mulMatrixByArrayAndMatrixFast=function(leftArray,leftOffset,rightMatrix,outArray,outOffset){
			var i,ai0,ai1,ai2,ai3;
			var rightMatrixE=rightMatrix.elements;
			var m11=rightMatrixE[0],m12=rightMatrixE[1],m13=rightMatrixE[2],m14=rightMatrixE[3];
			var m21=rightMatrixE[4],m22=rightMatrixE[5],m23=rightMatrixE[6],m24=rightMatrixE[7];
			var m31=rightMatrixE[8],m32=rightMatrixE[9],m33=rightMatrixE[10],m34=rightMatrixE[11];
			var m41=rightMatrixE[12],m42=rightMatrixE[13],m43=rightMatrixE[14],m44=rightMatrixE[15];
			var ai0LeftOffset=leftOffset;
			var ai1LeftOffset=leftOffset+4;
			var ai2LeftOffset=leftOffset+8;
			var ai3LeftOffset=leftOffset+12;
			var ai0OutOffset=outOffset;
			var ai1OutOffset=outOffset+4;
			var ai2OutOffset=outOffset+8;
			var ai3OutOffset=outOffset+12;
			for (i=0;i < 4;i++){
				ai0=leftArray[ai0LeftOffset+i];
				ai1=leftArray[ai1LeftOffset+i];
				ai2=leftArray[ai2LeftOffset+i];
				ai3=leftArray[ai3LeftOffset+i];
				outArray[ai0OutOffset+i]=ai0 *m11+ai1 *m12+ai2 *m13+ai3 *m14;
				outArray[ai1OutOffset+i]=ai0 *m21+ai1 *m22+ai2 *m23+ai3 *m24;
				outArray[ai2OutOffset+i]=ai0 *m31+ai1 *m32+ai2 *m33+ai3 *m34;
				outArray[ai3OutOffset+i]=ai0 *m41+ai1 *m42+ai2 *m43+ai3 *m44;
			}
		}

		Utils3D.createAffineTransformationArray=function(tX,tY,tZ,rX,rY,rZ,rW,sX,sY,sZ,outArray,outOffset){
			var x2=rX+rX,y2=rY+rY,z2=rZ+rZ;
			var xx=rX *x2,xy=rX *y2,xz=rX *z2,yy=rY *y2,yz=rY *z2,zz=rZ *z2;
			var wx=rW *x2,wy=rW *y2,wz=rW *z2;
			outArray[outOffset+0]=(1-(yy+zz))*sX;
			outArray[outOffset+1]=(xy+wz)*sX;
			outArray[outOffset+2]=(xz-wy)*sX;
			outArray[outOffset+3]=0;
			outArray[outOffset+4]=(xy-wz)*sY;
			outArray[outOffset+5]=(1-(xx+zz))*sY;
			outArray[outOffset+6]=(yz+wx)*sY;
			outArray[outOffset+7]=0;
			outArray[outOffset+8]=(xz+wy)*sZ;
			outArray[outOffset+9]=(yz-wx)*sZ;
			outArray[outOffset+10]=(1-(xx+yy))*sZ;
			outArray[outOffset+11]=0;
			outArray[outOffset+12]=tX;
			outArray[outOffset+13]=tY;
			outArray[outOffset+14]=tZ;
			outArray[outOffset+15]=1;
		}

		Utils3D.transformVector3ArrayToVector3ArrayCoordinate=function(source,sourceOffset,transform,result,resultOffset){
			var vectorElem=Utils3D._tempArray4_0;
			var coordinateX=source[sourceOffset+0];
			var coordinateY=source[sourceOffset+1];
			var coordinateZ=source[sourceOffset+2];
			var transformElem=transform.elements;
			vectorElem[0]=(coordinateX *transformElem[0])+(coordinateY *transformElem[4])+(coordinateZ *transformElem[8])+transformElem[12];
			vectorElem[1]=(coordinateX *transformElem[1])+(coordinateY *transformElem[5])+(coordinateZ *transformElem[9])+transformElem[13];
			vectorElem[2]=(coordinateX *transformElem[2])+(coordinateY *transformElem[6])+(coordinateZ *transformElem[10])+transformElem[14];
			vectorElem[3]=1.0 / ((coordinateX *transformElem[3])+(coordinateY *transformElem[7])+(coordinateZ *transformElem[11])+transformElem[15]);
			result[resultOffset+0]=vectorElem[0] *vectorElem[3];
			result[resultOffset+1]=vectorElem[1] *vectorElem[3];
			result[resultOffset+2]=vectorElem[2] *vectorElem[3];
		}

		Utils3D.convert3DCoordTo2DScreenCoord=function(source,out){
			var se=source.elements;
			var oe=out.elements;
			oe[0]=-RenderState.clientWidth / 2+se[0];
			oe[1]=RenderState.clientHeight / 2-se[1];
			oe[2]=se[2];
		}

		Utils3D._tempVector3_0=new Vector3();
		Utils3D._tempVector3_1=new Vector3();
		Utils3D._tempVector3_2=new Vector3();
		Utils3D._tempVector3_3=new Vector3();
		Utils3D._tempVector3_4=new Vector3();
		Utils3D._tempVector3_5=new Vector3();
		Utils3D._tempVector3_6=new Vector3();
		Utils3D._tempArray4_0=new Float32Array(4);
		Utils3D._tempArray16_0=new Float32Array(16);
		Utils3D._tempArray16_1=new Float32Array(16);
		Utils3D._tempArray16_2=new Float32Array(16);
		Utils3D._tempArray16_3=new Float32Array(16);
		__static(Utils3D,
		['_typeToFunO',function(){return this._typeToFunO={"INT16":"writeInt16","SHORT":"writeInt16","UINT16":"writeUint16","UINT32":"writeUint32","FLOAT32":"writeFloat32","INT":"writeInt32","UINT":"writeUint32","BYTE":"writeByte","STRING":"writeUTFString"};}
		]);
		return Utils3D;
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
			this._letterSpacing=0;
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
			this.fontSize=parseInt(tInfo[0].attributes["size"].nodeValue);
			var tPadding=tInfo[0].attributes["padding"].nodeValue;
			var tPaddingArray=tPadding.split(",");
			var tUpPadding=parseInt(tPaddingArray[0]);
			var tDownPadding=parseInt(tPaddingArray[2]);
			this._leftPadding=parseInt(tPaddingArray[3]);
			this._rightPadding=parseInt(tPaddingArray[1]);
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
		__proto.destroy=function(){
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
			if (char==" ")return this._spaceWidth+this._letterSpacing;
			var tTexture=this.getCharTexture(char)
			if (tTexture)return tTexture.width+tTexture.offsetX *2+this._letterSpacing;
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
			return this._maxWidth+this._letterSpacing;
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
				tWidth+=this.getCharWidth(text.charAt(i));
			};
			var dx=this._leftPadding;
			align==="center" && (dx=(width-tWidth)/ 2);
			align==="right" && (dx=(width-tWidth)-this._rightPadding);
			var tX=0;
			for (i=0,n=text.length;i < n;i++){
				tTexture=this.getCharTexture(text.charAt(i));
				if (tTexture)sprite.graphics.drawTexture(tTexture,drawX+tX+dx,drawY,tTexture.width,tTexture.height);
				tX+=this.getCharWidth(text.charAt(i));
			}
		}

		/**
		*设置字符之间的间距（以像素为单位）。
		*/
		/**
		*获取字符之间的间距（以像素为单位）。
		*/
		__getset(0,__proto,'letterSpacing',function(){
			return this._letterSpacing;
			},function(value){
			this._letterSpacing=value;
		});

		return BitmapFont;
	})()


	/**
	*@private
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
		__proto.getTransform=function(){
			return this._tf;
		}

		__proto.setTransform=function(value){
			this._tf=value==='none' || !value ? Style._TF_EMPTY :value;
		}

		__proto.setTranslateX=function(value){
			this._tf===Style._TF_EMPTY && (this._tf=Style._createTransform());
			this._tf.translateX=value;
		}

		__proto.setTranslateY=function(value){
			this._tf===Style._TF_EMPTY && (this._tf=Style._createTransform());
			this._tf.translateY=value;
		}

		__proto.setScaleX=function(value){
			this._tf===Style._TF_EMPTY && (this._tf=Style._createTransform());
			this._tf.scaleX=value;
		}

		__proto.setScaleY=function(value){
			this._tf===Style._TF_EMPTY && (this._tf=Style._createTransform());
			this._tf.scaleY=value;
		}

		__proto.setRotate=function(value){
			this._tf===Style._TF_EMPTY && (this._tf=Style._createTransform());
			this._tf.rotate=value;
		}

		__proto.setSkewX=function(value){
			this._tf===Style._TF_EMPTY && (this._tf=Style._createTransform());
			this._tf.skewX=value;
		}

		__proto.setSkewY=function(value){
			this._tf===Style._TF_EMPTY && (this._tf=Style._createTransform());
			this._tf.skewY=value;
		}

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
			this.setScaleX(value);
		});

		/**Y 轴缩放值。*/
		__getset(0,__proto,'scaleY',function(){
			return this._tf.scaleY;
			},function(value){
			this.setScaleY(value);
		});

		/**元素应用的 2D 或 3D 转换的值。该属性允许我们对元素进行旋转、缩放、移动或倾斜。*/
		__getset(0,__proto,'transform',function(){
			return this.getTransform();
			},function(value){
			this.setTransform(value);
		});

		/**定义转换，只是用 X 轴的值。*/
		__getset(0,__proto,'translateX',function(){
			return this._tf.translateX;
			},function(value){
			this.setTranslateX(value);
		});

		/**定义转换，只是用 Y 轴的值。*/
		__getset(0,__proto,'translateY',function(){
			return this._tf.translateY;
			},function(value){
			this.setTranslateY(value);
		});

		/**定义旋转角度。*/
		__getset(0,__proto,'rotate',function(){
			return this._tf.rotate;
			},function(value){
			this.setRotate(value);
		});

		/**定义沿着 X 轴的 2D 倾斜转换。*/
		__getset(0,__proto,'skewX',function(){
			return this._tf.skewX;
			},function(value){
			this.setSkewX(value);
		});

		/**定义沿着 Y 轴的 2D 倾斜转换。*/
		__getset(0,__proto,'skewY',function(){
			return this._tf.skewY;
			},function(value){
			this.setSkewY(value);
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
	*@private
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
					this.size=parseInt(str);
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
					weight=parseInt(value);
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
			//this.keyCode=0;
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

		/**鼠标在 Stage 上的 X 轴坐标*/
		__getset(0,__proto,'stageX',function(){
			return Laya.stage.mouseX;
		});

		/**鼠标在 Stage 上的 Y 轴坐标*/
		__getset(0,__proto,'stageY',function(){
			return Laya.stage.mouseY;
		});

		/**
		*表示 Ctrl 键是处于活动状态 (true)还是非活动状态 (false)。
		*/
		__getset(0,__proto,'ctrlKey',function(){
			return this.nativeEvent.ctrlKey;
		});

		/**
		*表示键在键盘上的位置。这对于区分在键盘上多次出现的键非常有用。<br>
		*例如，您可以根据此属性的值来区分左 Shift 键和右 Shift 键：左 Shift 键的值为 KeyLocation.LEFT，右 Shift 键的值为 KeyLocation.RIGHT。另一个示例是区分标准键盘 (KeyLocation.STANDARD)与数字键盘 (KeyLocation.NUM_PAD)上按下的数字键。
		*/
		__getset(0,__proto,'keyLocation',function(){
			return this.nativeEvent.keyLocation;
		});

		/**
		*包含按下或释放的键的字符代码值。字符代码值为英文键盘值。
		*/
		__getset(0,__proto,'charCode',function(){
			return this.nativeEvent.charCode;
		});

		Event.EMPTY=new Event();
		Event.TYPE1="type1";
		Event.TYPE1_1="type1_1";
		Event.TYPE2="type2";
		Event.TYPE2_1="type2_1";
		Event.TYPE2_2="type2_2";
		Event.TYPE2_3="type2_3";
		Event.TYPE2_4="type2_4";
		Event.TYPE3="type3";
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
		Event.ANIMATION_CHANGED="actionchanged";
		Event.INSTAGE_CHANGED="instagechanged";
		Event.CACHEFRAMEINDEX_CHANGED="cacheframeindexchanged";
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
			if (!KeyBoardManager.enabled)return;
			KeyBoardManager._event._stoped=false;
			KeyBoardManager._event.nativeEvent=e;
			KeyBoardManager._event.keyCode=e.keyCode || e.which || e.charCode;
			if (type==="keydown")KeyBoardManager._pressKeys[KeyBoardManager._event.keyCode]=true;
			else if (type==="keyup")KeyBoardManager._pressKeys[KeyBoardManager._event.keyCode]=null;
			var target=(Laya.stage.focus && (Laya.stage.focus.event !=null))? Laya.stage.focus :Laya.stage;
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
			this.mouseMoveAccuracy=2;
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
			this._prePoint=new Point();
		}

		__class(MouseManager,'laya.events.MouseManager');
		var __proto=MouseManager.prototype;
		/**
		*@private
		*初始化。
		*/
		__proto.__init__=function(stage,canvas){
			var _$this=this;
			this._stage=stage;
			var _this=this;
			var list=this._eventList;
			canvas.oncontextmenu=function (e){
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
					_$this.runEvent();
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
			this._point.setTo(e.clientX,e.clientY);
			this._stage._canvasTransform.invertTransformPoint(this._point);
			_this.mouseX=this._point.x;
			_this.mouseY=this._point.y;
			_this._event.touchId=e.identifier;
		}

		__proto.checkMouseWheel=function(e){
			this._event.delta=e.wheelDelta ? e.wheelDelta *0.025 :-e.detail;
			for (var i=0,n=this._lastOvers.length;i < n;i++){
				var ele=this._lastOvers[i];
				ele.event("mousewheel",this._event.setTo("mousewheel",ele,this._target));
			}
			this._stage.event("mousewheel",this._event.setTo("mousewheel",this._stage,this._target));
		}

		__proto.checkMouseOut=function(){
			if (this.disableMouseEvent)return;
			for (var i=0,n=this._lastOvers.length;i < n;i++){
				var ele=this._lastOvers[i];
				if (!ele.destroyed && this._currOvers.indexOf(ele)< 0){
					ele._set$P("$_MOUSEOVER",false);
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
			if (ele.parent || ele===this._stage){
				if (!ele._get$P("$_MOUSEOVER")){
					ele._set$P("$_MOUSEOVER",true);
					ele.event("mouseover",this._event.setTo("mouseover",ele,this._target));
				}
				this._currOvers.push(ele);
			}
			!this._event._stoped && ele.parent && this.sendMouseOver(ele.parent);
		}

		__proto.onMouseDown=function(ele){
			if (Input.isInputting && Laya.stage.focus && Laya.stage.focus["focus"] && !Laya.stage.focus.contains(this._target)){
				Laya.stage.focus["focus"]=false;
			}
			this._onMouseDown(ele);
		}

		__proto._onMouseDown=function(ele){
			if (this._isLeftMouse){
				ele._set$P("$_MOUSEDOWN",true);
				ele.event("mousedown",this._event.setTo("mousedown",ele,this._target));
				}else {
				ele._set$P("$_RIGHTMOUSEDOWN",true);
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
			if (ele.destroyed)return;
			if (type==="mouseup" && ele._get$P("$_MOUSEDOWN")){
				ele._set$P("$_MOUSEDOWN",false);
				ele.event("click",this._event.setTo("click",ele,this._target));
				this._isDoubleClick && ele.event("doubleclick",this._event.setTo("doubleclick",ele,this._target));
				}else if (type==="rightmouseup" && ele._get$P("$_RIGHTMOUSEDOWN")){
				ele._set$P("$_RIGHTMOUSEDOWN",false);
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
				if (sp.hitTestPrior && !sp.mouseThrough && !this.hitTest(sp,mouseX,mouseY)){
					return false;
				}
				for (var i=sp._childs.length-1;i >-1;i--){
					var child=sp._childs[i];
					if (!child.destroyed && child.mouseEnabled && child.visible){
						flag=this.check(child,mouseX+(scrollRect ? scrollRect.x :0),mouseY+(scrollRect ? scrollRect.y :0),callBack);
						if (flag)return true;
					}
				}
			}
			isHit=this.hitTest(sp,mouseX,mouseY);
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
			if ((sp.hitArea instanceof laya.utils.HitArea )){
				return sp.hitArea.isHit(mouseX,mouseY);
			}
			if (sp.width > 0 && sp.height > 0 || sp.mouseThrough || sp.hitArea){
				var hitRect=this._rect;
				if (!sp.mouseThrough){
					if (sp.hitArea)hitRect=sp.hitArea;
					else hitRect.setTo(0,0,sp.width,sp.height);
					isHit=hitRect.contains(mouseX,mouseY);
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
						if (!MouseManager._isTouchRespond){
							_this._isLeftMouse=evt.button===0;
							_this.initEvent(evt);
							_this.check(_this._stage,_this.mouseX,_this.mouseY,_this.onMouseDown);
						}else
						MouseManager._isTouchRespond=false;
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
						if ((Math.abs(this._prePoint.x-evt.clientX)+Math.abs(this._prePoint.y-evt.clientY))>=this.mouseMoveAccuracy){
							this._prePoint.x=evt.clientX;
							this._prePoint.y=evt.clientY;
							_this.initEvent(evt);
							_this.check(_this._stage,_this.mouseX,_this.mouseY,_this.onMouseMove);
							_this.checkMouseOut();
						}
						break ;
					case "touchstart":
						MouseManager._isTouchRespond=true;
						_this._isLeftMouse=true;
						var touches=evt.changedTouches;
						for (var j=0,n=touches.length;j < n;j++){
							_this.initEvent(touches[j],evt);
							_this.check(_this._stage,_this.mouseX,_this.mouseY,_this.onMouseDown);
						}
						break ;
					case "touchend":
						MouseManager._isTouchRespond=true;
						_this._isLeftMouse=true;
						now=Browser.now();
						_this._isDoubleClick=(now-_this._lastClickTimer)< 300;
						_this._lastClickTimer=now;
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
		MouseManager._isTouchRespond=false;
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
		/**@private */
		__proto.callNative=function(sp){}
		/**@private 滤镜类型。*/
		__getset(0,__proto,'type',function(){return-1});
		/**@private 滤镜动作。*/
		__getset(0,__proto,'action',function(){return this._action });
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


	//class laya.filters.webgl.FilterActionGL
	var FilterActionGL=(function(){
		function FilterActionGL(){}
		__class(FilterActionGL,'laya.filters.webgl.FilterActionGL');
		var __proto=FilterActionGL.prototype;
		Laya.imps(__proto,{"laya.filters.IFilterActionGL":true})
		__proto.setValue=function(shader){}
		__proto.setValueMix=function(shader){}
		__proto.apply3d=function(scope,sprite,context,x,y){return null;}
		__proto.apply=function(srcCanvas){return null;}
		__getset(0,__proto,'typeMix',function(){
			return 0;
		});

		return FilterActionGL;
	})()


	/**
	*@private
	*/
	//class laya.maths.Arith
	var Arith=(function(){
		function Arith(){};
		__class(Arith,'laya.maths.Arith');
		Arith.formatR=function(r){
			if (r > Math.PI)r-=Math.PI *2;
			if (r <-Math.PI)r+=Math.PI *2;
			return r;
		}

		Arith.isPOT=function(w,h){
			return (w > 0 && (w & (w-1))===0 && h > 0 && (h & (h-1))===0);
		}

		Arith.setMatToArray=function(mat,array){
			mat.a,mat.b,0,0,mat.c,mat.d,0,0,0,0,1,0,mat.tx+20,mat.ty+20,0,1
			array[0]=mat.a;
			array[1]=mat.b;
			array[4]=mat.c;
			array[5]=mat.d;
			array[12]=mat.tx;
			array[13]=mat.ty;
		}

		return Arith;
	})()


	/**
	*@private
	*计算贝塞尔曲线的工具类。
	*/
	//class laya.maths.Bezier
	var Bezier=(function(){
		function Bezier(){
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
		*@param t
		*@param rst
		*
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
		*@param t
		*@param rst
		*
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
		*@param count
		*@param rst
		*
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
			this.inPool=false;
			this.bTransform=false;
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

		/**@private*/
		__proto._checkTransform=function(){
			return this.bTransform=(this.a!==1 || this.b!==0 || this.c!==0 || this.d!==1);
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
		*@private
		*将 Matrix 对象表示的几何缩放转换应用于指定点。
		*@param data 点集合。
		*@param out 存储应用转化的点的列表。
		*@return 返回out数组
		*/
		__proto.transformPointArrayScale=function(data,out){
			var len=data.length;
			for (var i=0;i < len;i+=2){
				var x=data[i],y=data[i+1];
				out[i]=this.a *x+this.c *y;
				out[i+1]=this.b *x+this.d *y;
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
		__proto.copyTo=function(dec){
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

		/**
		*计算当前点和目标x，y点的距离
		*@param x 水平坐标。
		*@param y 垂直坐标。
		*@return 返回之间的距离
		*/
		__proto.distance=function(x,y){
			return Math.sqrt((this.x-x)*(this.x-x)+(this.y-y)*(this.y-y));
		}

		/**返回包含 x 和 y 坐标的值的字符串。*/
		__proto.toString=function(){
			return this.x+","+this.y;
		}

		/**
		*标准化向量
		*/
		__proto.normalize=function(){
			var d=Math.sqrt(this.x *this.x+this.y *this.y);
			if (d > 0){
				var id=1.0 / d;
				this.x *=id;
				this.y *=id;
			}
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
			return !(rect.x > (this.x+this.width)|| (rect.x+rect.width)< this.x || rect.y > (this.y+this.height)|| (rect.y+rect.height)< this.y);
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
		__proto.equals=function(rect){
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

		/**确定此 Rectangle 对象是否为空。*/
		__proto.isEmpty=function(){
			if (this.width <=0 || this.height <=0)return true;
			return false;
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
			if (!pointList || pointList.length < 1)return rst ? rst.setTo(0,0,0,0):Rectangle.TEMP.setTo(0,0,0,0);
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
				SoundManager.stopAll();
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
					SoundManager._musicLoops=SoundManager._musicChannel.loops;
					SoundManager._musicCompleteHandler=SoundManager._musicChannel.completeHandler;
					SoundManager._musicPosition=SoundManager._musicChannel.position;
					SoundManager._musicChannel.stop();
				}
			}
		}

		SoundManager._stageOnFocus=function(){
			if (SoundManager._blurPaused){
				SoundManager.playMusic(SoundManager._tMusic,SoundManager._musicLoops,SoundManager._musicCompleteHandler,SoundManager._musicPosition);
				SoundManager._blurPaused=false;
			}
		}

		SoundManager.playSound=function(url,loops,complete,soundClass,startTime){
			(loops===void 0)&& (loops=1);
			(startTime===void 0)&& (startTime=0);
			if (SoundManager._muted)
				return null;
			if (url==SoundManager._tMusic){
				if (SoundManager._musicMuted)return null;
				}else {
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

		SoundManager.playMusic=function(url,loops,complete,startTime){
			(loops===void 0)&& (loops=0);
			(startTime===void 0)&& (startTime=0);
			SoundManager._tMusic=url;
			if (SoundManager._musicChannel)
				SoundManager._musicChannel.stop();
			return SoundManager._musicChannel=SoundManager.playSound(url,loops,complete,null,startTime);
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

		SoundManager.stopAll=function(){
			var i=0;
			var channel;
			for (i=SoundManager._channels.length-1;i >=0;i--){
				channel=SoundManager._channels[i];
				channel.stop();
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
		SoundManager._musicLoops=0;
		SoundManager._musicPosition=0;
		SoundManager._musicCompleteHandler=null;
		SoundManager._soundClass=null
		return SoundManager;
	})()


	/**
	*<p> <code>LocalStorage</code> 类用于没有时间限制的数据存储。</p>
	*/
	//class laya.net.LocalStorage
	var LocalStorage=(function(){
		var Storage;
		function LocalStorage(){};
		__class(LocalStorage,'laya.net.LocalStorage');
		LocalStorage.__init__=function(){
			if (!LocalStorage._baseClass){
				LocalStorage._baseClass=Storage;
				Storage.init();
			}
			LocalStorage.items=LocalStorage._baseClass.items;
			LocalStorage.support=LocalStorage._baseClass.support;
		}

		LocalStorage.setItem=function(key,value){
			LocalStorage._baseClass.setItem(key,value);
		}

		LocalStorage.getItem=function(key){
			return LocalStorage._baseClass.getItem(key);
		}

		LocalStorage.setJSON=function(key,value){
			LocalStorage._baseClass.setJSON(key,value);
		}

		LocalStorage.getJSON=function(key){
			return LocalStorage._baseClass.getJSON(key);
		}

		LocalStorage.removeItem=function(key){
			LocalStorage._baseClass.removeItem(key);
		}

		LocalStorage.clear=function(){
			LocalStorage._baseClass.clear();
		}

		LocalStorage._baseClass=null
		LocalStorage.items=null
		LocalStorage.support=false;
		LocalStorage.__init$=function(){
			//class Storage
			Storage=(function(){
				function Storage(){};
				__class(Storage,'');
				Storage.init=function(){
					try{Storage.items=window.localStorage;Storage.setItem('laya','1');Storage.removeItem('laya');Storage.support=true;}catch(e){}if(!Storage.support)console.log('LocalStorage is not supprot or browser is private mode.');
				}
				Storage.setItem=function(key,value){
					try {
						Storage.support && Storage.items.setItem(key,value);
						}catch (e){
						console.log("set localStorage failed",e);
					}
				}
				Storage.getItem=function(key){
					return Storage.support ? Storage.items.getItem(key):null;
				}
				Storage.setJSON=function(key,value){
					try {
						Storage.support && Storage.items.setItem(key,JSON.stringify(value));
						}catch (e){
						console.log("set localStorage failed",e);
					}
				}
				Storage.getJSON=function(key){
					return JSON.parse(Storage.support ? Storage.items.getItem(key):null);
				}
				Storage.removeItem=function(key){
					Storage.support && Storage.items.removeItem(key);
				}
				Storage.clear=function(){
					Storage.support && Storage.items.clear();
				}
				Storage.items=null
				Storage.support=true;
				return Storage;
			})()
		}

		return LocalStorage;
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
		/**格式化后的地址。*/
		__getset(0,__proto,'url',function(){
			return this._url;
		});

		/**地址的路径。*/
		__getset(0,__proto,'path',function(){
			return this._path;
		});

		URL.formatURL=function(url,base){
			if (URL.customFormat !=null)url=URL.customFormat(url,base);
			if (!url)return "null path";
			if (Render.isConchApp==false){
				URL.version[url] && (url+="?v="+URL.version[url]);
			}
			if (url.charAt(0)=='~')return URL.rootPath+url.substring(1);
			if (URL.isAbsolute(url))return url;
			var retVal=(base || URL.basePath)+url;
			return retVal;
		}

		URL.formatRelativePath=function(value){
			if (value.indexOf("../")>-1){
				var parts=value.split("/");
				for (var i=0,len=parts.length;i < len;i++){
					if (parts[i]=='..'){
						parts.splice(i-1,2);
						i-=2;
					}
				}
				return parts.join('/');
			}
			return value;
		}

		URL.isAbsolute=function(url){
			return url.indexOf(":")> 0 || url.charAt(0)=='/';
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
		URL.customFormat=null
		return URL;
	})()


	//class laya.webgl.shader.ShaderValue
	var ShaderValue=(function(){
		function ShaderValue(){}
		__class(ShaderValue,'laya.webgl.shader.ShaderValue');
		return ShaderValue;
	})()


	/**
	*@private
	*<code>Render</code> 是渲染管理类。它是一个单例，可以使用 Laya.render 访问。
	*/
	//class laya.renders.Render
	var Render=(function(){
		function Render(width,height){
			this._timeId=0;
			var style=Render._mainCanvas.source.style;
			style.position='absolute';
			style.top=style.left="0px";
			style.background="#000000";
			Render._mainCanvas.source.id=Render._mainCanvas.source.id || "layaCanvas";
			var isWebGl=laya.renders.Render.isWebGL;
			isWebGl && Render.WebGL.init(Render._mainCanvas,width,height);
			if (Render._mainCanvas.source.nodeName || laya.renders.Render.isConchApp){
				Browser.container.appendChild(Render._mainCanvas.source);
			}
			Render._context=new RenderContext(width,height,isWebGl ? null :Render._mainCanvas);
			Render._context.ctx.setIsMainContext();
			Browser.window.requestAnimationFrame(loop);
			function loop (){
				Laya.stage._loop();
				Browser.window.requestAnimationFrame(loop);
			}
			Laya.stage.on("blur",this,this._onBlur);
			Laya.stage.on("focus",this,this._onFocus);
		}

		__class(Render,'laya.renders.Render');
		var __proto=Render.prototype;
		/**@private */
		__proto._onFocus=function(){
			Browser.window.clearInterval(this._timeId);
		}

		/**@private */
		__proto._onBlur=function(){
			this._timeId=Browser.window.setInterval(this._enterFrame,1000);
		}

		/**@private */
		__proto._enterFrame=function(e){
			Laya.stage._loop();
		}

		/**是否是加速器 只读*/
		__getset(1,Render,'isConchApp',function(){
			return (window.ConchRenderType & 0x04)==0x04;
		});

		/**加速器模式下设置是否是节点模式 如果是否就是非节点模式 默认为canvas模式 如果设置了isConchWebGL则是webGL模式*/
		__getset(1,Render,'isConchNode',function(){
			return (window.ConchRenderType & 5)==5;
			},function(b){
			if (b){
				window.ConchRenderType |=0x01;
				}else {
				window.ConchRenderType &=~ 0x01;
			}
		});

		/**目前使用的渲染器。*/
		__getset(1,Render,'context',function(){
			return Render._context;
		});

		/**加速器模式下设置是否是WebGL模式*/
		__getset(1,Render,'isConchWebGL',function(){
			return window.ConchRenderType==6;
			},function(b){
			if (b){
				Render.isConchNode=false;
				window.ConchRenderType |=0x02;
				}else {
				window.ConchRenderType &=~ 0x02;
			}
		});

		/**渲染使用的原生画布引用。 */
		__getset(1,Render,'canvas',function(){
			return Render._mainCanvas.source;
		});

		Render._context=null
		Render._mainCanvas=null
		Render.WebGL=null
		Render.NODE=0x01;
		Render.WEBGL=0x02;
		Render.CONCH=0x04;
		Render.isWebGL=false;
		Render.is3DMode=false;
		Render.optimizeTextureMemory=function(url,texture){
			return true;
		}

		Render.__init$=function(){
			window.ConchRenderType=window.ConchRenderType||1;;
			window.ConchRenderType|=(!window.conch?0:0x04);;;
		}

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
			this._drawTexture=function(x,y,args){
				if (args[0].loaded)this.ctx.drawTexture(args[0],args[1],args[2],args[3],args[4],x,y);
			}
			this._fillTexture=function(x,y,args){
				if (args[0].loaded){
					var texture=args[0];
					var ctxi=this.ctx;
					var pat;
					if (Render.isWebGL){
						var tSprite=args[7];
						if (tSprite){
							if (args[6]){
								tSprite.initTexture(texture,args[1],args[2],args[3],args[4],args[6].x,args[6].y);
								}else {
								tSprite.initTexture(texture,args[1],args[2],args[3],args[4],0,0);
							};
							var ctx=this.ctx;
							tSprite.render(ctx,x,y);
						}
						return;
					}
					if (!Render.isConchApp){
						if (texture.uv !=Texture.DEF_UV){
							var canvas=new HTMLCanvas("2D");
							canvas.getContext('2d');
							canvas.size(texture.width,texture.height);
							canvas.context.drawTexture(texture,0,0,texture.width,texture.height,0,0);
							args[0]=texture=new Texture(canvas);
						}
						pat=args[7] ? args[7] :args[7]=ctxi.createPattern(texture.bitmap.source,args[5]);
						}else {
						if (texture.uv !=Texture.DEF_UV){
							var w=texture.bitmap.width,h=texture.bitmap.height,uv=texture.uv;
							pat=args[7] ? args[7] :args[7]=ctxi.createPattern(texture.bitmap.source,args[5],uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h);
							}else {
							pat=args[7] ? args[7] :args[7]=ctxi.createPattern(texture.bitmap.source,args[5]);
						}
					};
					var oX=x+args[1],oY=y+args[2];
					var sX=0,sY=0;
					if (args[6]){
						oX+=args[6].x % texture.width;
						oY+=args[6].y % texture.height;
						sX-=args[6].x % texture.width;
						sY-=args[6].y % texture.height;
					}
					ctxi.translate(oX,oY);
					ctxi.fillStyle=pat;
					ctxi.fillRect(sX,sY,args[3],args[4]);
					ctxi.translate(-oX,-oY);
				}else {}
			}
			this._drawTextureWithTransform=function(x,y,args){
				if (args[0].loaded)this.ctx.drawTextureWithTransform(args[0],args[1],args[2],args[3],args[4],args[5],x,y,args[6]);
			}
			this._fillQuadrangle=function(x,y,args){
				this.ctx.fillQuadrangle(args[0],args[1],args[2],args[3],args[4]);
			}
			this._drawRect=function(x,y,args){
				var ctx=this.ctx;
				if (args[4] !=null){
					ctx.fillStyle=args[4];
					ctx.fillRect(x+args[0],y+args[1],args[2],args[3],null);
				}
				if (args[5] !=null){
					ctx.strokeStyle=args[5];
					ctx.lineWidth=args[6];
					ctx.strokeRect(x+args[0],y+args[1],args[2],args[3],args[6]);
				}
			}
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
				this.ctx.fillRect(x+args[0],y+args[1],args[2],args[3],args[4]);
			}
			this._drawCircle=function(x,y,args){
				var ctx=this.ctx;
				Render.isWebGL && ctx.setPathId(args[6]);
				Stat.drawCall++;
				ctx.beginPath();
				Render.isWebGL && ctx.movePath(args[0]+x,args[1]+y);
				ctx.arc(args[0]+x,args[1]+y,args[2],0,RenderContext.PI2);
				ctx.closePath();
				this._fillAndStroke(args[3],args[4],args[5],true);
			}
			this._fillCircle=function(x,y,args){
				Stat.drawCall++;
				var ctx=this.ctx;
				ctx.beginPath();
				ctx.fillStyle=args[3];
				ctx.arc(args[0]+x,args[1]+y,args[2],0,RenderContext.PI2);
				ctx.fill();
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
			this._drawCurves=function(x,y,args){
				var ctx=this.ctx;
				Render.isWebGL && ctx.setPathId(-1);
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
				this.ctx.fillText(args[0],args[1]+x,args[2]+y,args[3],args[4],args[5]);
			}
			this._strokeText=function(x,y,args){
				this.ctx.strokeText(args[0],args[1]+x,args[2]+y,args[3],args[4],args[5],args[6]);
			}
			this._fillBorderText=function(x,y,args){
				this.ctx.fillBorderText(args[0],args[1]+x,args[2]+y,args[3],args[4],args[5],args[6],args[7]);
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
			this.drawPoly=function(x,y,args){
				this.ctx.drawPoly(x+this.x+args[0],y+this.y+args[1],args[2],args[3],args[4],args[5],args[6]);
			}
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

		__proto.drawTexture=function(tex,x,y,width,height){
			if (tex.loaded)this.ctx.drawTexture(tex,x,y,width,height,this.x,this.y);
		}

		__proto._drawTextures=function(x,y,args){
			if (args[0].loaded)this.ctx.drawTextures(args[0],args[1],x+this.x,y+this.y);
		}

		__proto.drawTextureWithTransform=function(tex,x,y,width,height,m,alpha){
			if (tex.loaded)this.ctx.drawTextureWithTransform(tex,x,y,width,height,m,this.x,this.y,alpha);
		}

		__proto.fillQuadrangle=function(tex,x,y,point4,m){
			this.ctx.fillQuadrangle(tex,x,y,point4,m);
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
			this.ctx.fillRect(x+this.x,y+this.y,width,height,fillStyle);
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

		__proto.fillCircle=function(x,y,radius,color){
			Stat.drawCall++;
			var ctx=this.ctx;
			ctx.beginPath();
			ctx.fillStyle=color;
			ctx.arc(x+this.x,y+this.y,radius,0,RenderContext.PI2);
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

		__proto.fillWords=function(words,x,y,font,color){
			this.ctx.fillWords(words,x,y,font,color);
		}

		__proto.fillText=function(text,x,y,font,color,textAlign){
			this.ctx.fillText(text,x+this.x,y+this.y,font,color,textAlign);
		}

		__proto.strokeText=function(text,x,y,font,color,lineWidth,textAlign){
			this.ctx.strokeText(text,x+this.x,y+this.y,font,color,lineWidth,textAlign);
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
				case 0x02:
					this._fun=this._alpha;
					return;
				case 0x04:
					this._fun=this._transform;
					return;
				case 0x20:
					this._fun=this._blend;
					return;
				case 0x08:
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
				case 0x800:
					this._fun=this._childs;
					return;
				case 0x200:
					this._fun=this._custom;
					return;
				case 0x01 | 0x100:
					this._fun=this._image2;
					return;
				case 0x01 | 0x04 | 0x100:
					this._fun=this._image2;
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
			sprite._style.render(sprite,context,x,y);
			var next=this._next;
			next._fun.call(next,sprite,context,x,y);
		}

		__proto._no=function(sprite,context,x,y){}
		__proto._custom=function(sprite,context,x,y){
			sprite.customRender(context,x,y);
			var tf=sprite._style._tf;
			this._next._fun.call(this._next,sprite,context,x-tf.translateX,y-tf.translateY);
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
			var tf=sprite._style._tf;
			sprite._graphics && sprite._graphics._render(sprite,context,x-tf.translateX,y-tf.translateY);
			var next=this._next;
			next._fun.call(next,sprite,context,x,y);
		}

		__proto._image=function(sprite,context,x,y){
			var style=sprite._style;
			context.ctx.drawTexture2(x,y,style._tf.translateX,style._tf.translateY,sprite.transform,style.alpha,style.blendMode,sprite._graphics._one);
		}

		__proto._image2=function(sprite,context,x,y){
			var tf=sprite._style._tf;
			context.ctx.drawTexture2(x,y,tf.translateX,tf.translateY,sprite.transform,1,null,sprite._graphics._one);
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
			x+=-style._tf.translateX+style.paddingLeft;
			y+=-style._tf.translateY+style.paddingTop;
			var words=sprite._getWords();
			words && context.fillWords(words,x,y,(style).font,(style).color);
			var childs=sprite._childs,n=childs.length,ele;
			if (!sprite.viewport){
				for (var i=0;i < n;++i)
				(ele=(childs [i]))._style.visible && ele.render(context,x,y);
				}else {
				var rect=sprite.viewport;
				var left=rect.x;
				var top=rect.y;
				var right=rect.right;
				var bottom=rect.bottom;
				var _x=0,_y=0;
				for (i=0;i < n;++i){
					if ((ele=childs [i])._style.visible && ((_x=ele.x)< right && (_x+ele.width)> left && (_y=ele.y)< bottom && (_y+ele.height)> top)){
						ele.render(context,x,y);
					}
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
			var _repaint=sprite._needRepaint()|| (!tx);
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
				if (Render.isWebGL && _cacheCanvas.type==='bitmap' && (tRec.width > 2048 || tRec.height > 2048)){
					console.log("cache bitmap size larger than 2048,cache ignored");
					_next._fun.call(_next,sprite,tx,x,y);
					return;
				}
				tRec.x-=sprite.pivotX;
				tRec.y-=sprite.pivotY;
				tRec.x-=10;
				tRec.y-=10;
				tRec.width+=20;
				tRec.height+=20;
				tRec.x=Math.floor(tRec.x+x)-x;
				tRec.y=Math.floor(tRec.y+y)-y;
				tRec.width=Math.floor(tRec.width);
				tRec.height=Math.floor(tRec.height);
				_cacheCanvas._cacheRec.copyFrom(tRec);
				tRec=_cacheCanvas._cacheRec;
				var scaleX=Render.isWebGL?1:Browser.pixelRatio *Laya.stage.clientScaleX;
				var scaleY=Render.isWebGL?1:Browser.pixelRatio *Laya.stage.clientScaleY;
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
				w=tRec.width *scaleX;
				h=tRec.height *scaleY;
				left=tRec.x;
				top=tRec.y;
				if (!tx){
					tx=_cacheCanvas.ctx=Pool.getItem("RenderContext")||new RenderContext(w,h,HTMLCanvas.create("AUTO"));
					tx.ctx.sprite=sprite;
				}
				canvas=tx.canvas;
				if (_cacheCanvas.type==='bitmap')canvas.context.asBitmap=true;
				canvas.clear();
				(canvas.width !=w || canvas.height !=h)&& canvas.size(w,h);
				var t;
				if (scaleX!=1||scaleY!=1){
					var ctx=(tx).ctx;
					ctx.save();
					ctx.scale(scaleX,scaleY);
					if (!Render.isConchWebGL&&Render.isConchApp){
						t=sprite._$P.cf;
						t&&ctx.setFilterMatrix&&ctx.setFilterMatrix(t._mat,t._alpha);
					}
					_next._fun.call(_next,sprite,tx,-left,-top);
					ctx.restore();
					if(!Render.isConchApp||Render.isConchWebGL)sprite._applyFilters();
					}else {
					ctx=(tx).ctx;
					if (!Render.isConchWebGL&&Render.isConchApp){
						t=sprite._$P.cf;
						t&&ctx.setFilterMatrix&&ctx.setFilterMatrix(t._mat,t._alpha);
					}
					_next._fun.call(_next,sprite,tx,-left,-top);
					if(!Render.isConchApp||Render.isConchWebGL)sprite._applyFilters();
				}
				if (sprite._$P.staticCache)_cacheCanvas.reCache=false;
				Stat.canvasReCache++;
				}else {
				tRec=_cacheCanvas._cacheRec;
				left=tRec.x;
				top=tRec.y;
				canvas=tx.canvas;
			}
			context.drawCanvas(canvas,x+left,y+top,tRec.width,tRec.height);
		}

		RenderSprite.__init__=function(){
			var i=0,len=0;
			var initRender;
			initRender=RunDriver.createRenderSprite(0x11111,null);
			len=RenderSprite.renders.length=0x800 *2;
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
			_initSame([0x01,0x100,0x04,0x02],new RenderSprite(0x01,null));
			RenderSprite.renders[0x01 | 0x100]=RunDriver.createRenderSprite(0x01 | 0x100,null);
			RenderSprite.renders[0x01 | 0x04 | 0x100]=new RenderSprite(0x01 | 0x04 | 0x100,null);
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
					rst=RunDriver.createRenderSprite(tType,rst);
				tType=tType >> 1;
			}
			return rst;
		}

		RenderSprite.IMAGE=0x01;
		RenderSprite.ALPHA=0x02;
		RenderSprite.TRANSFORM=0x04;
		RenderSprite.CANVAS=0x08;
		RenderSprite.FILTERS=0x10;
		RenderSprite.BLEND=0x20;
		RenderSprite.CLIP=0x40;
		RenderSprite.STYLE=0x80;
		RenderSprite.GRAPHICS=0x100;
		RenderSprite.CUSTOM=0x200;
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
		__proto.setIsMainContext=function(){}
		__proto.drawTextures=function(tex,pos,tx,ty){
			Stat.drawCall+=pos.length / 2;
			var w=tex.bitmap.width;
			var h=tex.bitmap.height;
			for (var i=0,sz=pos.length;i < sz;i+=2){
				this.drawTexture(tex,pos[i],pos[i+1],w,h,tx,ty);
			}
		}

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
			this.drawImage(tex.source,uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h,x+tx,y+ty,width,height);
		}

		/***@private */
		__proto.drawTextureWithTransform=function(tex,x,y,width,height,m,tx,ty,alpha){
			Stat.drawCall++;
			var uv=tex.uv,w=tex.bitmap.width,h=tex.bitmap.height;
			this.save();
			alpha !=1 && (this.globalAlpha *=alpha);
			if (m){
				this.transform(m.a,m.b,m.c,m.d,m.tx+tx,m.ty+ty);
				this.drawImage(tex.source,uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h,x ,y,width,height);
				}else {
				this.drawImage(tex.source,uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h,x+tx ,y+ty,width,height);
			}
			this.restore();
		}

		/***@private */
		__proto.drawTexture2=function(x,y,pivotX,pivotY,m,alpha,blendMode,args2){
			'use strict';
			var tex=args2[0];
			if (!(tex.loaded && tex.bitmap && tex.source)){
				return;
			}
			Stat.drawCall++;
			var alphaChanged=alpha!==1;
			if (alphaChanged){
				var temp=this.globalAlpha;
				this.globalAlpha *=alpha;
			};
			var uv=tex.uv,w=tex.bitmap.width,h=tex.bitmap.height;
			if (m){
				this.save();
				this.transform(m.a,m.b,m.c,m.d,m.tx+x,m.ty+y);
				this.drawImage(tex.source,uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h,args2[1]-pivotX ,args2[2]-pivotY,args2[3],args2[4]);
				this.restore();
				}else {
				this.drawImage(tex.source,uv[0] *w,uv[1] *h,(uv[2]-uv[0])*w,(uv[5]-uv[3])*h,args2[1]-pivotX+x ,args2[2]-pivotY+y,args2[3],args2[4]);
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

		Context.__init__=function(to){
			var from=laya.resource.Context.prototype;
			to=to || CanvasRenderingContext2D.prototype;
			to.__fillText=to.fillText;
			to.__fillRect=to.fillRect;
			to.__strokeText=to.strokeText;
			var funs=['drawTextures','fillWords','setIsMainContext','fillRect','strokeText','fillText','transformByMatrix','setTransformByMatrix','clipRect','drawTexture','drawTexture2','drawTextureWithTransform','flush','clear','destroy','drawCanvas','fillBorderText'];
			funs.forEach(function(i){
				to[i]=from[i] || to[i];
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
	//class laya.resource.WXCanvas
	var WXCanvas=(function(){
		function WXCanvas(id){
			this._ctx=null;
			this._id=null;
			this.style={};
			this._id=id;
		}

		__class(WXCanvas,'laya.resource.WXCanvas');
		var __proto=WXCanvas.prototype;
		__proto.getContext=function(){
			var wx=laya.resource.WXCanvas.wx;
			var ctx=wx.createContext();
			ctx.id=this._id;
			ctx.fillRect=function (x,y,w,h){
				this.rect(x,y,w,h);
				this.fill();
			}
			ctx.strokeRect=function (x,y,w,h){
				this.rect(x,y,w,h);
				this.stroke();
			}
			ctx.___drawImage=ctx.drawImage;
			ctx.drawImage=function (){
				var img=arguments[0].tempFilePath;
				if (img==null)return;
				switch(arguments.length){
					case 3:
						this.___drawImage(img,arguments[1],arguments[2],arguments[0].width,arguments[0].height);
						return;
					case 5:
						this.___drawImage(img,arguments[1],arguments[2],arguments[3],arguments[4]);
						return;
					case 9:
						this.___drawImage(img,arguments[5],arguments[6],arguments[7],arguments[8]);
						return;
					}
			}
			Object.defineProperty(ctx,"strokeStyle",{set:function (value){this.setStrokeStyle(value)},enumerable:false });
			Object.defineProperty(ctx,"fillStyle",{set:function (value){this.setFillStyle(value)},enumerable:false });
			Object.defineProperty(ctx,"fontSize",{set:function (value){this.setFontSize(value)},enumerable:false });
			Object.defineProperty(ctx,"lineWidth",{set:function (value){this.setLineWidth(value)},enumerable:false });
			Context.__init__(ctx);
			ctx.flush=function (){
				wx.drawCanvas({canvasId:this.id,actions:this.getActions()});
			}
			return ctx;
		}

		__proto.oncontextmenu=function(e){}
		__proto.addEventListener=function(){}
		__getset(0,__proto,'id',function(){
			return this._id;
			},function(value){
			this._id=value;
		});

		WXCanvas.wx=null;
		return WXCanvas;
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
			if (Render.isConchApp){
				conch.disableConchResManager();
				conch.disableConchAutoRestoreLostedDevice();
			}
		}

		return System;
	})()


	SoundManager;
	/**
	*<code>Browser</code> 是浏览器代理类。封装浏览器及原生 js 提供的一些功能。
	*/
	//class laya.utils.Browser
	var Browser=(function(){
		function Browser(){};
		__class(Browser,'laya.utils.Browser');
		/**浏览器可视宽度。*/
		__getset(1,Browser,'clientWidth',function(){
			Browser.__init__();
			return Browser.window.innerWidth || Browser.document.body.clientWidth;
		});

		/**浏览器可视高度。*/
		__getset(1,Browser,'clientHeight',function(){
			Browser.__init__();
			return Browser.window.innerHeight || Browser.document.body.clientHeight || Browser.document.documentElement.clientHeight;
		});

		/**浏览器原生 window 对象的引用。*/
		__getset(1,Browser,'window',function(){
			Browser.__init__();
			return Browser._window;
		});

		/**设备像素比。*/
		__getset(1,Browser,'pixelRatio',function(){
			Browser.__init__();
			return RunDriver.getPixelRatio();
		});

		/**浏览器物理宽度，。*/
		__getset(1,Browser,'width',function(){
			Browser.__init__();
			return ((Laya.stage && Laya.stage.canvasRotation)? Browser.clientHeight :Browser.clientWidth)*Browser.pixelRatio;
		});

		/**浏览器物理高度。*/
		__getset(1,Browser,'height',function(){
			Browser.__init__();
			return ((Laya.stage && Laya.stage.canvasRotation)? Browser.clientWidth :Browser.clientHeight)*Browser.pixelRatio;
		});

		/**画布容器，用来盛放画布的容器。方便对画布进行控制*/
		__getset(1,Browser,'container',function(){
			Browser.__init__();
			if (!Browser._container){
				Browser._container=Browser.createElement("div");
				Browser._container.id="layaContainer";
				Browser._container.style.cssText="width:100%;height:100%";
				Browser.document.body.appendChild(Browser._container);
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
			SoundManager;
			if (Browser._window)return;
			Browser._window=RunDriver.getWindow();
			Browser._document=Browser.window.document;
			Browser.document.__createElement=Browser.document.createElement;
			window.requestAnimationFrame=(function(){return window.requestAnimationFrame || window.webkitRequestAnimationFrame ||window.mozRequestAnimationFrame || window.oRequestAnimationFrame ||function (c){return window.setTimeout(c,1000 / 60);};})();
			var $BS=window.document.body.style;$BS.margin=0;$BS.overflow='hidden';;
			var metas=window.document.getElementsByTagName('meta');;
			var i=0,flag=false,content='width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no';;
			while(i<metas.length){var meta=metas[i];if(meta.name=='viewport'){meta.content=content;flag=true;break;}i++;};
			if(!flag){meta=document.createElement('meta');meta.name='viewport',meta.content=content;document.getElementsByTagName('head')[0].appendChild(meta);};
			Browser.userAgent=/*[SAFE]*/ Browser.window.navigator.userAgent;
			Browser.u=/*[SAFE]*/ Browser.userAgent;
			Browser.onIOS=/*[SAFE]*/ !!Browser.u.match(/\(i[^;]+;(U;)? CPU.+Mac OS X/);
			Browser.onMobile=/*[SAFE]*/ Browser.u.indexOf("Mobile")>-1;
			Browser.onIPhone=/*[SAFE]*/ Browser.u.indexOf("iPhone")>-1;
			Browser.onIPad=/*[SAFE]*/ Browser.u.indexOf("iPad")>-1;
			Browser.onAndriod=/*[SAFE]*/ Browser.u.indexOf('Android')>-1 || Browser.u.indexOf('Adr')>-1;
			Browser.onWP=/*[SAFE]*/ Browser.u.indexOf("Windows Phone")>-1;
			Browser.onQQBrowser=/*[SAFE]*/ Browser.u.indexOf("QQBrowser")>-1;
			Browser.onMQQBrowser=/*[SAFE]*/ Browser.u.indexOf("MQQBrowser")>-1;
			Browser.onWeiXin=/*[SAFE]*/ Browser.u.indexOf('MicroMessenger')>-1;
			Browser.onPC=/*[SAFE]*/ !Browser.onMobile;
			Browser.onSafari=/*[SAFE]*/ !!Browser.u.match(/Version\/\d\.\d\x20Mobile\/\S+\x20Safari/);
			Browser.httpProtocol=/*[SAFE]*/ Browser.window.location.protocol=="http:";
			Browser.webAudioEnabled=/*[SAFE]*/ Browser.window["AudioContext"] || Browser.window["webkitAudioContext"] || Browser.window["mozAudioContext"] ? true :false;
			Browser.soundType=/*[SAFE]*/ Browser.webAudioEnabled ? "WEBAUDIOSOUND" :"AUDIOSOUND";
			Sound=Browser.webAudioEnabled?WebAudioSound:AudioSound;;
			if (Browser.webAudioEnabled)WebAudioSound.initWebAudio();;
			Browser.enableTouch=(('ontouchstart' in window)|| window.DocumentTouch && document instanceof DocumentTouch);
			window.focus();
			SoundManager._soundClass=Sound;;
			var MainCanvas=null;
			if (Browser.window.MainCanvasID){
				var _wx=wx;
				if (_wx && !_wx.createContext)_wx=null;
				if ((WXCanvas.wx=_wx)!=null){
					MainCanvas=new WXCanvas(Browser.window.MainCanvasID);
					var from=Context.prototype;
					from.flush=null;
					Browser.window.Image=function (){
						this.setSrc=function (url){
							this.__src=url;
							var _this=this;
							this.success();
						}
						this.success=function (res){
							this.width=200;
							this.height=200;
							this.tempFilePath=res ? res.tempFilePath :this.__src;
							this.onload && this.onload();
						}
						this.getSrc=function (){
							return this.__src;
						}
						Object.defineProperty(this,"src",{get:this.getSrc,set:this.setSrc,enumerable:false });
					}
					}else {
					MainCanvas=Browser.document.getElementById(Browser.window.MainCanvasID);
				}
			}
			Render._mainCanvas=Render._mainCanvas || HTMLCanvas.create('2D',MainCanvas);
			if (Browser.canvas)return;
			Browser.canvas=HTMLCanvas.create('2D');
			Browser.context=Browser.canvas.getContext('2d');
		}

		Browser.createElement=function(type){
			Browser.__init__();
			return Browser.document.__createElement(type);
		}

		Browser.getElementById=function(type){
			Browser.__init__();
			return Browser.document.getElementById(type);
		}

		Browser.removeElement=function(ele){
			if (ele && ele.parentNode)ele.parentNode.removeChild(ele);
		}

		Browser.now=function(){
			return RunDriver.now();
		}

		Browser._window=null
		Browser._document=null
		Browser._container=null
		Browser.userAgent=null
		Browser.u=null
		Browser.onIOS=false;
		Browser.onMobile=false;
		Browser.onIPhone=false;
		Browser.onIPad=false;
		Browser.onAndriod=false;
		Browser.onWP=false;
		Browser.onQQBrowser=false;
		Browser.onMQQBrowser=false;
		Browser.onSafari=false;
		Browser.onWeiXin=false;
		Browser.onPC=false;
		Browser.httpProtocol=false;
		Browser.webAudioEnabled=false;
		Browser.soundType=null
		Browser.enableTouch=false;
		Browser.canvas=null
		Browser.context=null
		Browser.__init$=function(){
			AudioSound;
			WebAudioSound;
		}

		return Browser;
	})()


	/**
	*
	*<code>Byte</code> 类提供用于优化读取、写入以及处理二进制数据的方法和属性。
	*/
	//class laya.utils.Byte
	var Byte=(function(){
		function Byte(data){
			this._xd_=true;
			this._allocated_=8;
			//this._d_=null;
			//this._u8d_=null;
			this._pos_=0;
			this._length=0;
			if (data){
				this._u8d_=new Uint8Array(data);
				this._d_=new DataView(this._u8d_.buffer);
				this._length=this._d_.byteLength;
				}else {
				this.___resizeBuffer(this._allocated_);
			}
		}

		__class(Byte,'laya.utils.Byte');
		var __proto=Byte.prototype;
		/**@private */
		__proto.___resizeBuffer=function(len){
			try {
				var newByteView=new Uint8Array(len);
				if (this._u8d_ !=null){
					if (this._u8d_.length <=len)newByteView.set(this._u8d_);
					else newByteView.set(this._u8d_.subarray(0,len));
				}
				this._u8d_=newByteView;
				this._d_=new DataView(newByteView.buffer);
				}catch (err){
				throw "___resizeBuffer err:"+len;
			}
		}

		/**
		*读取字符型值。
		*@return
		*/
		__proto.getString=function(){
			return this.rUTF(this.getUint16());
		}

		/**
		*从指定的位置读取指定长度的数据用于创建一个 Float32Array 对象并返回此对象。
		*@param start 开始位置。
		*@param len 需要读取的字节长度。
		*@return 读出的 Float32Array 对象。
		*/
		__proto.getFloat32Array=function(start,len){
			var v=new Float32Array(this._d_.buffer.slice(start,start+len));
			this._pos_+=len;
			return v;
		}

		/**
		*从指定的位置读取指定长度的数据用于创建一个 Uint8Array 对象并返回此对象。
		*@param start 开始位置。
		*@param len 需要读取的字节长度。
		*@return 读出的 Uint8Array 对象。
		*/
		__proto.getUint8Array=function(start,len){
			var v=new Uint8Array(this._d_.buffer.slice(start,start+len));
			this._pos_+=len;
			return v;
		}

		/**
		*从指定的位置读取指定长度的数据用于创建一个 Int16Array 对象并返回此对象。
		*@param start 开始位置。
		*@param len 需要读取的字节长度。
		*@return 读出的 Uint8Array 对象。
		*/
		__proto.getInt16Array=function(start,len){
			var v=new Int16Array(this._d_.buffer.slice(start,start+len));
			this._pos_+=len;
			return v;
		}

		/**
		*在指定字节偏移量位置处读取 Float32 值。
		*@return Float32 值。
		*/
		__proto.getFloat32=function(){
			var v=this._d_.getFloat32(this._pos_,this._xd_);
			this._pos_+=4;
			return v;
		}

		__proto.getFloat64=function(){
			var v=this._d_.getFloat64(this._pos_,this._xd_);
			this._pos_+=8;
			return v;
		}

		/**
		*在当前字节偏移量位置处写入 Float32 值。
		*@param value 需要写入的 Float32 值。
		*/
		__proto.writeFloat32=function(value){
			this.ensureWrite(this._pos_+4);
			this._d_.setFloat32(this._pos_,value,this._xd_);
			this._pos_+=4;
		}

		__proto.writeFloat64=function(value){
			this.ensureWrite(this._pos_+8);
			this._d_.setFloat64(this._pos_,value,this._xd_);
			this._pos_+=8;
		}

		/**
		*在当前字节偏移量位置处读取 Int32 值。
		*@return Int32 值。
		*/
		__proto.getInt32=function(){
			var float=this._d_.getInt32(this._pos_,this._xd_);
			this._pos_+=4;
			return float;
		}

		/**
		*在当前字节偏移量位置处读取 Uint32 值。
		*@return Uint32 值。
		*/
		__proto.getUint32=function(){
			var v=this._d_.getUint32(this._pos_,this._xd_);
			this._pos_+=4;
			return v;
		}

		/**
		*在当前字节偏移量位置处写入 Int32 值。
		*@param value 需要写入的 Int32 值。
		*/
		__proto.writeInt32=function(value){
			this.ensureWrite(this._pos_+4);
			this._d_.setInt32(this._pos_,value,this._xd_);
			this._pos_+=4;
		}

		/**
		*在当前字节偏移量位置处写入 Uint32 值。
		*@param value 需要写入的 Uint32 值。
		*/
		__proto.writeUint32=function(value){
			this.ensureWrite(this._pos_+4);
			this._d_.setUint32(this._pos_,value,this._xd_);
			this._pos_+=4;
		}

		/**
		*在当前字节偏移量位置处读取 Int16 值。
		*@return Int16 值。
		*/
		__proto.getInt16=function(){
			var us=this._d_.getInt16(this._pos_,this._xd_);
			this._pos_+=2;
			return us;
		}

		/**
		*在当前字节偏移量位置处读取 Uint16 值。
		*@return Uint16 值。
		*/
		__proto.getUint16=function(){
			var us=this._d_.getUint16(this._pos_,this._xd_);
			this._pos_+=2;
			return us;
		}

		/**
		*在当前字节偏移量位置处写入 Uint16 值。
		*@param value 需要写入的Uint16 值。
		*/
		__proto.writeUint16=function(value){
			this.ensureWrite(this._pos_+2);
			this._d_.setUint16(this._pos_,value,this._xd_);
			this._pos_+=2;
		}

		/**
		*在当前字节偏移量位置处写入 Int16 值。
		*@param value 需要写入的 Int16 值。
		*/
		__proto.writeInt16=function(value){
			this.ensureWrite(this._pos_+2);
			this._d_.setInt16(this._pos_,value,this._xd_);
			this._pos_+=2;
		}

		/**
		*在当前字节偏移量位置处读取 Uint8 值。
		*@return Uint8 值。
		*/
		__proto.getUint8=function(){
			return this._d_.getUint8(this._pos_++);
		}

		/**
		*在当前字节偏移量位置处写入 Uint8 值。
		*@param value 需要写入的 Uint8 值。
		*/
		__proto.writeUint8=function(value){
			this.ensureWrite(this._pos_+1);
			this._d_.setUint8(this._pos_,value,this._xd_);
			this._pos_++;
		}

		/**
		*@private
		*在指定位置处读取 Uint8 值。
		*@param pos 字节读取位置。
		*@return Uint8 值。
		*/
		__proto._getUInt8=function(pos){
			return this._d_.getUint8(pos);
		}

		/**
		*@private
		*在指定位置处读取 Uint16 值。
		*@param pos 字节读取位置。
		*@return Uint16 值。
		*/
		__proto._getUint16=function(pos){
			return this._d_.getUint16(pos,this._xd_);
		}

		/**
		*@private
		*使用 getFloat32()读取6个值，用于创建并返回一个 Matrix 对象。
		*@return Matrix 对象。
		*/
		__proto._getMatrix=function(){
			var rst=new Matrix(this.getFloat32(),this.getFloat32(),this.getFloat32(),this.getFloat32(),this.getFloat32(),this.getFloat32());
			return rst;
		}

		/**
		*@private
		*读取指定长度的 UTF 型字符串。
		*@param len 需要读取的长度。
		*@return 读出的字符串。
		*/
		__proto.rUTF=function(len){
			var v="",max=this._pos_+len,c=0,c2=0,c3=0,f=String.fromCharCode;
			var u=this._u8d_,i=0;
			while (this._pos_ < max){
				c=u[this._pos_++];
				if (c < 0x80){
					if (c !=0){
						v+=f(c);
					}
					}else if (c < 0xE0){
					v+=f(((c & 0x3F)<< 6)| (u[this._pos_++] & 0x7F));
					}else if (c < 0xF0){
					c2=u[this._pos_++];
					v+=f(((c & 0x1F)<< 12)| ((c2 & 0x7F)<< 6)| (u[this._pos_++] & 0x7F));
					}else {
					c2=u[this._pos_++];
					c3=u[this._pos_++];
					v+=f(((c & 0x0F)<< 18)| ((c2 & 0x7F)<< 12)| ((c3 << 6)& 0x7F)| (u[this._pos_++] & 0x7F));
				}
				i++;
			}
			return v;
		}

		/**
		*字符串读取。
		*@param len
		*@return
		*/
		__proto.getCustomString=function(len){
			var v="",ulen=0,c=0,c2=0,f=String.fromCharCode;
			var u=this._u8d_,i=0;
			while (len > 0){
				c=u[this._pos_];
				if (c < 0x80){
					v+=f(c);
					this._pos_++;
					len--;
					}else {
					ulen=c-0x80;
					this._pos_++;
					len-=ulen;
					while (ulen > 0){
						c=u[this._pos_++];
						c2=u[this._pos_++];
						v+=f((c2 << 8)| c);
						ulen--;
					}
				}
			}
			return v;
		}

		/**
		*清除数据。
		*/
		__proto.clear=function(){
			this._pos_=0;
			this.length=0;
		}

		/**
		*@private
		*获取此对象的 ArrayBuffer 引用。
		*@return
		*/
		__proto.__getBuffer=function(){
			return this._d_.buffer;
		}

		/**
		*写入字符串，该方法写的字符串要使用 readUTFBytes 方法读取。
		*@param value 要写入的字符串。
		*/
		__proto.writeUTFBytes=function(value){
			value=value+"";
			for (var i=0,sz=value.length;i < sz;i++){
				var c=value.charCodeAt(i);
				if (c <=0x7F){
					this.writeByte(c);
					}else if (c <=0x7FF){
					this.writeByte(0xC0 | (c >> 6));
					this.writeByte(0x80 | (c & 63));
					}else if (c <=0xFFFF){
					this.writeByte(0xE0 | (c >> 12));
					this.writeByte(0x80 | ((c >> 6)& 63));
					this.writeByte(0x80 | (c & 63));
					}else {
					this.writeByte(0xF0 | (c >> 18));
					this.writeByte(0x80 | ((c >> 12)& 63));
					this.writeByte(0x80 | ((c >> 6)& 63));
					this.writeByte(0x80 | (c & 63));
				}
			}
		}

		/**
		*将 UTF-8 字符串写入字节流。
		*@param value 要写入的字符串值。
		*/
		__proto.writeUTFString=function(value){
			var tPos=0;
			tPos=this.pos;
			this.writeUint16(1);
			this.writeUTFBytes(value);
			var dPos=0;
			dPos=this.pos-tPos-2;
			this._d_.setUint16(tPos,dPos,this._xd_);
		}

		/**
		*@private
		*读取 UTF-8 字符串。
		*@return 读出的字符串。
		*/
		__proto.readUTFString=function(){
			var tPos=0;
			tPos=this.pos;
			var len=0;
			len=this.getUint16();
			return this.readUTFBytes(len);
		}

		/**
		*读取 UTF-8 字符串。
		*@return 读出的字符串。
		*/
		__proto.getUTFString=function(){
			return this.readUTFString();
		}

		/**
		*@private
		*读字符串，必须是 writeUTFBytes 方法写入的字符串。
		*@param len 要读的buffer长度,默认将读取缓冲区全部数据。
		*@return 读取的字符串。
		*/
		__proto.readUTFBytes=function(len){
			(len===void 0)&& (len=-1);
			if(len==0)return "";
			len=len > 0 ? len :this.bytesAvailable;
			return this.rUTF(len);
		}

		/**
		*读字符串，必须是 writeUTFBytes 方法写入的字符串。
		*@param len 要读的buffer长度,默认将读取缓冲区全部数据。
		*@return 读取的字符串。
		*/
		__proto.getUTFBytes=function(len){
			(len===void 0)&& (len=-1);
			return this.readUTFBytes(len);
		}

		/**
		*在字节流中写入一个字节。
		*@param value
		*/
		__proto.writeByte=function(value){
			this.ensureWrite(this._pos_+1);
			this._d_.setInt8(this._pos_,value);
			this._pos_+=1;
		}

		/**
		*@private
		*在字节流中读一个字节。
		*/
		__proto.readByte=function(){
			return this._d_.getInt8(this._pos_++);
		}

		/**
		*在字节流中读一个字节。
		*/
		__proto.getByte=function(){
			return this.readByte();
		}

		/**
		*指定该字节流的长度。
		*@param lengthToEnsure 指定的长度。
		*/
		__proto.ensureWrite=function(lengthToEnsure){
			if (this._length < lengthToEnsure)this._length=lengthToEnsure;
			if (this._allocated_ < lengthToEnsure)this.length=lengthToEnsure;
		}

		/**
		*写入指定的 Arraybuffer 对象。
		*@param arraybuffer 需要写入的 Arraybuffer 对象。
		*@param offset 偏移量（以字节为单位）
		*@param length 长度（以字节为单位）
		*/
		__proto.writeArrayBuffer=function(arraybuffer,offset,length){
			(offset===void 0)&& (offset=0);
			(length===void 0)&& (length=0);
			if (offset < 0 || length < 0)throw "writeArrayBuffer error - Out of bounds";
			if (length==0)length=arraybuffer.byteLength-offset;
			this.ensureWrite(this._pos_+length);
			var uint8array=new Uint8Array(arraybuffer);
			this._u8d_.set(uint8array.subarray(offset,offset+length),this._pos_);
			this._pos_+=length;
		}

		/**
		*获取此对象的 ArrayBuffer数据,数据只包含有效数据部分 。
		*/
		__getset(0,__proto,'buffer',function(){
			var rstBuffer=this._d_.buffer;
			if (rstBuffer.byteLength==this.length)return rstBuffer;
			return rstBuffer.slice(0,this.length);
		});

		/**
		*字节顺序。
		*/
		__getset(0,__proto,'endian',function(){
			return this._xd_ ? "littleEndian" :"bigEndian";
			},function(endianStr){
			this._xd_=(endianStr=="littleEndian");
		});

		/**
		*可从字节流的当前位置到末尾读取的数据的字节数。
		*/
		__getset(0,__proto,'bytesAvailable',function(){
			return this.length-this._pos_;
		});

		/**
		*字节长度。
		*/
		__getset(0,__proto,'length',function(){
			return this._length;
			},function(value){
			if (this._allocated_ < value)
				this.___resizeBuffer(this._allocated_=Math.floor(Math.max(value,this._allocated_ *2)));
			else if (this._allocated_ > value)
			this.___resizeBuffer(this._allocated_=value);
			this._length=value;
		});

		/**
		*当前读取到的位置。
		*/
		__getset(0,__proto,'pos',function(){
			return this._pos_;
			},function(value){
			this._pos_=value;
			this._d_.byteOffset=value;
		});

		Byte.getSystemEndian=function(){
			if (!Byte._sysEndian){
				var buffer=new ArrayBuffer(2);
				new DataView(buffer).setInt16(0,256,true);
				Byte._sysEndian=(new Int16Array(buffer))[0]===256 ? "littleEndian" :"bigEndian";
			}
			return Byte._sysEndian;
		}

		Byte.BIG_ENDIAN="bigEndian";
		Byte.LITTLE_ENDIAN="littleEndian";
		Byte._sysEndian=null;
		return Byte;
	})()


	/**
	*对象缓存统一管理类
	*/
	//class laya.utils.CacheManger
	var CacheManger=(function(){
		function CacheManger(){}
		__class(CacheManger,'laya.utils.CacheManger');
		CacheManger.regCacheByFunction=function(disposeFunction,getCacheListFunction){
			CacheManger.unRegCacheByFunction(disposeFunction,getCacheListFunction);
			var cache;
			cache={
				tryDispose:disposeFunction,
				getCacheList:getCacheListFunction
			};
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
			for(i=0;i<len;i++){
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


	/**
	*<code>ClassUtils</code> 是一个类工具类。
	*/
	//class laya.utils.ClassUtils
	var ClassUtils=(function(){
		function ClassUtils(){};
		__class(ClassUtils,'laya.utils.ClassUtils');
		ClassUtils.regClass=function(className,classDef){
			ClassUtils._classMap[className]=classDef;
		}

		ClassUtils.getRegClass=function(className){
			return ClassUtils._classMap[className];
		}

		ClassUtils.getInstance=function(className){
			var compClass=ClassUtils.getClass(className);
			if (compClass)
				return new compClass();
			else
			console.log("[error] Undefined class:",className);
			return null;
		}

		ClassUtils.createByJson=function(json,node,root,customHandler,instanceHandler){
			if ((typeof json=='string'))
				json=JSON.parse(json);
			var props=json.props;
			if (!node){
				node=instanceHandler ? instanceHandler.runWith(json.instanceParams):ClassUtils.getInstance(props.runtime || json.type);
				if (!node)
					return null;
			};
			var child=json.child;
			if (child){
				for (var i=0,n=child.length;i < n;i++){
					var data=child[i];
					if ((data.props.name==="render" || data.props.renderType==="render")&& node["_$set_itemRender"])
						node.itemRender=data;
					else {
						if (data.type=="Graphic"){
							ClassUtils.addGraphicsToSprite(data,node);
							}else if (ClassUtils.isDrawType(data.type)){
							ClassUtils.addGraphicToSprite(data,node,true);
							}else {
							var tChild=ClassUtils.createByJson(data,null,root,customHandler,instanceHandler)
							if (data.type=="Script"){
								tChild["owner"]=node;
								}else if (data.props.renderType=="mask"){
								node.mask=tChild;
								}else {
								node.addChild(tChild);
							}
						}
					}
				}
			}
			if (props){
				for (var prop in props){
					var value=props[prop];
					if (prop==="var" && root){
						root[value]=node;
						}else if ((value instanceof Array)&& (typeof (node[prop])=='function')){
						node[prop].apply(node,value);
						}else {
						node[prop]=value;
					}
				}
			};
			var customProps=json.customProps;
			if (customHandler && customProps){
				for (prop in customProps){
					value=customProps[prop];
					customHandler.runWith([node,prop,value]);
				}
			}
			if (node["created"])
				node.created();
			return node;
		}

		ClassUtils.addGraphicsToSprite=function(graphicO,sprite){
			var graphics;
			graphics=graphicO.child;
			if (!graphics || graphics.length < 1)
				return;
			var g;
			g=ClassUtils._getGraphicsFromSprite(graphicO,sprite);
			var ox=0;
			var oy=0;
			if (graphicO.props){
				ox=ClassUtils._getObjVar(graphicO.props,"x",0);
				oy=ClassUtils._getObjVar(graphicO.props,"y",0);
			}
			if (ox !=0 && oy !=0){
				g.translate(ox,oy);
			};
			var i=0,len=0;
			len=graphics.length;
			for (i=0;i < len;i++){
				ClassUtils._addGraphicToGraphics(graphics[i],g);
			}
			if (ox !=0 && oy !=0){
				g.translate(-ox,-oy);
			}
		}

		ClassUtils.addGraphicToSprite=function(graphicO,sprite,isChild){
			(isChild===void 0)&& (isChild=false);
			var g;
			g=isChild ? ClassUtils._getGraphicsFromSprite(graphicO,sprite):sprite.graphics;
			ClassUtils._addGraphicToGraphics(graphicO,g);
		}

		ClassUtils._getGraphicsFromSprite=function(dataO,sprite){
			var g;
			if (!dataO || !dataO.props)
				return sprite.graphics;
			var propsName;
			propsName=dataO.props.renderType;
			switch (propsName){
				case "hit":
				case "unHit":;
					var hitArea;
					if (!sprite.hitArea){
						sprite.hitArea=new HitArea();
					}
					hitArea=sprite.hitArea;
					if (!hitArea[propsName]){
						hitArea[propsName]=new Graphics();
					}
					g=hitArea[propsName];
					break ;
				default :
				}
			if (!g)
				g=sprite.graphics;
			return g;
		}

		ClassUtils._getTransformData=function(propsO){
			var m;
			if (propsO.hasOwnProperty("pivotX")|| propsO.hasOwnProperty("pivotY")){
				m=m || new Matrix();
				m.translate(-ClassUtils._getObjVar(propsO,"pivotX",0),-ClassUtils._getObjVar(propsO,"pivotY",0));
			};
			var sx=ClassUtils._getObjVar(propsO,"scaleX",1),sy=ClassUtils._getObjVar(propsO,"scaleY",1);
			var rotate=ClassUtils._getObjVar(propsO,"rotation",0);
			var skewX=ClassUtils._getObjVar(propsO,"skewX",0);
			var skewY=ClassUtils._getObjVar(propsO,"skewY",0);
			if (sx !=1 || sy !=1 || rotate !=0){
				m=m || new Matrix();
				m.scale(sx,sy);
				m.rotate(rotate *0.0174532922222222);
			}
			return m;
		}

		ClassUtils._addGraphicToGraphics=function(graphicO,graphic){
			var propsO;
			propsO=graphicO.props;
			if (!propsO)
				return;
			var drawConfig;
			drawConfig=ClassUtils.DrawTypeDic[graphicO.type];
			if (!drawConfig)
				return;
			var g;
			g=graphic;
			var m;
			var params=ClassUtils._getParams(propsO,drawConfig[1],drawConfig[2],drawConfig[3]);
			m=ClassUtils._tM;
			if (m){
				g.save();
				g.transform(m);
			}
			g[drawConfig[0]].apply(g,params);
			if (m){
				g.restore();
			}
		}

		ClassUtils._adptLineData=function(params){
			params[2]=parseFloat(params[0])+parseFloat(params[2]);
			params[3]=parseFloat(params[1])+parseFloat(params[3]);
			return params;
		}

		ClassUtils._adptTextureData=function(params){
			params[0]=Loader.getRes(params[0]);
			return params;
		}

		ClassUtils._adptLinesData=function(params){
			params[2]=ClassUtils._getPointListByStr(params[2]);
			return params;
		}

		ClassUtils.isDrawType=function(type){
			if (type=="Image")
				return false;
			return ClassUtils.DrawTypeDic.hasOwnProperty(type);
		}

		ClassUtils._getParams=function(obj,params,xPos,adptFun){
			(xPos===void 0)&& (xPos=0);
			var rst;
			rst=ClassUtils._temParam;
			rst.length=params.length;
			var i=0,len=0;
			len=params.length;
			for (i=0;i < len;i++){
				rst[i]=ClassUtils._getObjVar(obj,params[i][0],params[i][1]);
			};
			var m;
			m=ClassUtils._getTransformData(obj);
			if (m){
				if (!xPos)xPos=0;
				m.translate(rst[xPos],rst[xPos+1]);
				rst[xPos]=rst[xPos+1]=0;
				ClassUtils._tM=m;
				}else {
				ClassUtils._tM=null;
			}
			if (adptFun && ClassUtils[adptFun]){
				rst=ClassUtils[adptFun](rst);
			}
			return rst;
		}

		ClassUtils._getPointListByStr=function(str){
			var pointArr;
			pointArr=str.split(",");
			var i=0,len=0;
			len=pointArr.length;
			for (i=0;i < len;i++){
				pointArr[i]=parseFloat(pointArr[i]);
			}
			return pointArr;
		}

		ClassUtils._getObjVar=function(obj,key,noValue){
			if (obj.hasOwnProperty(key)){
				return obj[key];
			}
			return noValue;
		}

		ClassUtils._temParam=[];
		ClassUtils._classMap={'Sprite':'laya.display.Sprite','Text':'laya.display.Text','Animation':'laya.display.Animation','Skeleton':'laya.ani.bone.Skeleton','Particle2D':'laya.particle.Particle2D','div':'laya.html.dom.HTMLDivElement','img':'laya.html.dom.HTMLImageElement','span':'laya.html.dom.HTMLElement','br':'laya.html.dom.HTMLBrElement','style':'laya.html.dom.HTMLStyleElement','font':'laya.html.dom.HTMLElement','a':'laya.html.dom.HTMLElement','#text':'laya.html.dom.HTMLElement'};
		ClassUtils.getClass=function(className){
			var classObject=ClassUtils._classMap[className] || className;
			if ((typeof classObject=='string'))
				return Laya["__classmap"][classObject];
			return classObject;
		}

		ClassUtils._tM=null
		__static(ClassUtils,
		['DrawTypeDic',function(){return this.DrawTypeDic={"Rect":["drawRect",[["x",0],["y",0],["width",0],["height",0],["fillColor",null],["lineColor",null],["lineWidth",1]]],"Circle":["drawCircle",[["x",0],["y",0],["radius",0],["fillColor",null],["lineColor",null],["lineWidth",1]]],"Pie":["drawPie",[["x",0],["y",0],["radius",0],["startAngle",0],["endAngle",0],["fillColor",null],["lineColor",null],["lineWidth",1]]],"Image":["drawTexture",[["x",0],["y",0],["width",0],["height",0]]],"Texture":["drawTexture",[["skin",null],["x",0],["y",0],["width",0],["height",0]],1,"_adptTextureData"],"FillTexture":["fillTexture",[["skin",null],["x",0],["y",0],["width",0],["height",0],["repeat",null]],1,"_adptTextureData"],"FillText":["fillText",[["text",""],["x",0],["y",0],["font",null],["color",null],["textAlign",null]],1],"Line":["drawLine",[["x",0],["y",0],["toX",0],["toY",0],["lineColor",null],["lineWidth",0]],0,"_adptLineData"],"Lines":["drawLines",[["x",0],["y",0],["points",""],["lineColor",null],["lineWidth",0]],0,"_adptLinesData"],"Curves":["drawCurves",[["x",0],["y",0],["points",""],["lineColor",null],["lineWidth",0]],0,"_adptLinesData"],"Poly":["drawPoly",[["x",0],["y",0],["points",""],["fillColor",null],["lineColor",null],["lineWidth",1]],0,"_adptLinesData"]};}
		]);
		return ClassUtils;
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
			//this._drawStyle=null;
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
					this.target._set$P("$_MOUSEDOWN",false);
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
				this._parent=null;
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


	/**
	*鼠标点击区域，可以设置绘制一系列矢量图作为点击区域和非点击区域（目前只支持圆形，矩形，多边形）
	*/
	//class laya.utils.HitArea
	var HitArea=(function(){
		function HitArea(){
			this._hit=null;
			this._unHit=null;
		}

		__class(HitArea,'laya.utils.HitArea');
		var __proto=HitArea.prototype;
		/**
		*是否包含某个点
		*@param x x坐标
		*@param y y坐标
		*@return 是否点击到
		*/
		__proto.isHit=function(x,y){
			if (!HitArea.isHitGraphic(x,y,this.hit))return false;
			return !HitArea.isHitGraphic(x,y,this.unHit);
		}

		/**
		*可点击区域，可以设置绘制一系列矢量图作为点击区域（目前只支持圆形，矩形，多边形）
		*/
		__getset(0,__proto,'hit',function(){
			if (!this._hit)this._hit=new Graphics();
			return this._hit;
			},function(value){
			this._hit=value;
		});

		/**
		*不可点击区域，可以设置绘制一系列矢量图作为非点击区域（目前只支持圆形，矩形，多边形）
		*/
		__getset(0,__proto,'unHit',function(){
			if (!this._unHit)this._unHit=new Graphics();
			return this._unHit;
			},function(value){
			this._unHit=value;
		});

		HitArea.isHitGraphic=function(x,y,graphic){
			if (!graphic)return false;
			var cmds;
			cmds=graphic.cmds;
			if (!cmds && graphic._one){
				cmds=HitArea._cmds;
				cmds.length=1;
				cmds[0]=graphic._one;
			}
			if (!cmds)return false;
			var i=0,len=0;
			len=cmds.length;
			var cmd;
			for (i=0;i < len;i++){
				cmd=cmds[i];
				if (!cmd)continue ;
				var context=Render._context;
				switch (cmd.callee){
					case context._translate:
					case 6:
						x-=cmd[0];
						y-=cmd[1];
					default :
					}
				if (HitArea.isHitCmd(x,y,cmd))return true;
			}
			return false;
		}

		HitArea.isHitCmd=function(x,y,cmd){
			if (!cmd)return false;
			var context=Render._context;
			var rst=false;
			switch (cmd["callee"]){
				case context._drawRect:
				case 13:
					HitArea._rec.setTo(cmd[0],cmd[1],cmd[2],cmd[3]);
					rst=HitArea._rec.contains(x,y);
					break ;
				case context._drawCircle:
				case context._fillCircle:
				case 14:;
					var d=NaN;
					x-=cmd[0];
					y-=cmd[1];
					d=x *x+y *y;
					rst=d < cmd[2] *cmd[2];
					break ;
				case context._drawPoly:
				case 18:
					x-=cmd[0];
					y-=cmd[1];
					rst=HitArea.ptInPolygon(x,y,cmd[2]);
					break ;
				default :
					break ;
				}
			return rst;
		}

		HitArea.ptInPolygon=function(x,y,areaPoints){
			var p;
			p=HitArea._ptPoint;
			p.setTo(x,y);
			var nCross=0;
			var p1x=NaN,p1y=NaN,p2x=NaN,p2y=NaN;
			var len=0;
			len=areaPoints.length;
			for (var i=0;i < len;i+=2){
				p1x=areaPoints[i];
				p1y=areaPoints[i+1];
				p2x=areaPoints[(i+2)% len];
				p2y=areaPoints[(i+3)% len];
				var p1=areaPoints[i];
				var p2=areaPoints[(i+1)% areaPoints.length];
				if (p1y==p2y)
					continue ;
				if (p.y < Math.min(p1y,p2y))
					continue ;
				if (p.y >=Math.max(p1y,p2y))
					continue ;
				var tx=(p.y-p1y)*(p2x-p1x)/ (p2y-p1y)+p1x;
				if (tx > p.x){
					nCross++;
				}
			}
			return (nCross % 2==1);
		}

		HitArea._cmds=[];
		__static(HitArea,
		['_rec',function(){return this._rec=new Rectangle();},'_ptPoint',function(){return this._ptPoint=new Point();}
		]);
		return HitArea;
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
	*<code>Pool</code> 是对象池类，用于对象的存贮、重复使用。
	*/
	//class laya.utils.Pool
	var Pool=(function(){
		function Pool(){};
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
			var rst=pool.length ? pool.pop():new cls();
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
			if (rst){
				rst["__InPool"]=false;
			}
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
			if (Render.isConchApp){
				conch.showFPS&&conch.showFPS(x,y);
				return;
			};
			var pixel=Browser.pixelRatio;
			Stat._width=pixel *130;
			Stat._vx=pixel *70;
			Stat._view[0]={title:"FPS(Canvas)",value:"_fpsStr",color:"yellow",units:"int"};
			Stat._view[1]={title:"Sprite",value:"spriteCount",color:"white",units:"int"};
			Stat._view[2]={title:"DrawCall",value:"drawCall",color:"white",units:"int"};
			Stat._view[3]={title:"CurMem",value:"currentMemorySize",color:"yellow",units:"M"};
			if (Render.isWebGL){
				Stat._view[4]={title:"Shader",value:"shaderCall",color:"white",units:"int"};
				if (!Render.is3DMode){
					Stat._view[0].title="FPS(WebGL)";
					Stat._view[5]={title:"Canvas",value:"_canvasStr",color:"white",units:"int"};
					}else {
					Stat._view[0].title="FPS(3D)";
					Stat._view[5]={title:"TriFaces",value:"trianglesFaces",color:"white",units:"int"};
				}
				}else {
				Stat._view[4]={title:"Canvas",value:"_canvasStr",color:"white",units:"int"};
			}
			Stat._fontSize=12 *pixel;
			for (var i=0;i < Stat._view.length;i++){
				Stat._view[i].x=4;
				Stat._view[i].y=i *Stat._fontSize+2 *pixel;
			}
			Stat._height=pixel *(Stat._view.length *12+3 *pixel);
			if (!Stat._canvas){
				Stat._canvas=new HTMLCanvas('2D');
				Stat._canvas.size(Stat._width,Stat._height);
				Stat._ctx=Stat._canvas.getContext('2d');
				Stat._ctx.textBaseline="top";
				Stat._ctx.font=Stat._fontSize+"px Sans-serif";
				Stat._canvas.source.style.cssText="pointer-events:none;background:rgba(150,150,150,0.8);z-index:100000;position: absolute;left:"+x+"px;top:"+y+"px;width:"+(Stat._width / pixel)+"px;height:"+(Stat._height / pixel)+"px;";
			}
			Stat._first=true;
			Stat.loop();
			Stat._first=false;
			Browser.container.appendChild(Stat._canvas.source);
			Stat.enable();
		}

		Stat.enable=function(){
			Laya.timer.frameLoop(1,Stat,Stat.loop);
		}

		Stat.hide=function(){
			Browser.removeElement(Stat._canvas.source);
			Laya.timer.clear(Stat,Stat.loop);
		}

		Stat.clear=function(){
			Stat.trianglesFaces=Stat.drawCall=Stat.shaderCall=Stat.spriteCount=Stat.canvasNormal=Stat.canvasBitmap=Stat.canvasReCache=0;
		}

		Stat.loop=function(){
			Stat._count++;
			var timer=Browser.now();
			if (timer-Stat._timer < 1000)return;
			var count=Stat._count;
			Stat.FPS=Math.round((count *1000)/ (timer-Stat._timer));
			if (Stat._canvas){
				Stat.trianglesFaces=Math.round(Stat.trianglesFaces / count);
				Stat.drawCall=Math.round(Stat.drawCall / count)-2;
				Stat.shaderCall=Math.round(Stat.shaderCall / count);
				Stat.spriteCount=Math.round(Stat.spriteCount / count)-1;
				Stat.canvasNormal=Math.round(Stat.canvasNormal / count);
				Stat.canvasBitmap=Math.round(Stat.canvasBitmap / count);
				Stat.canvasReCache=Math.ceil(Stat.canvasReCache / count);
				Stat._fpsStr=Stat.FPS+(Stat.renderSlow ? " slow" :"");
				Stat._canvasStr=Stat.canvasReCache+"/"+Stat.canvasNormal+"/"+Stat.canvasBitmap;
				Stat.currentMemorySize=ResourceManager.systemResourceManager.memorySize;
				var ctx=Stat._ctx;
				ctx.clearRect(Stat._first ? 0 :Stat._vx,0,Stat._width,Stat._height);
				for (var i=0;i < Stat._view.length;i++){
					var one=Stat._view[i];
					if (Stat._first){
						ctx.fillStyle="white";
						ctx.fillText(one.title,one.x,one.y,null,null,null);
					}
					ctx.fillStyle=one.color;
					var value=Stat[one.value];
					(one.units=="M")&& (value=Math.floor(value / (1024 *1024)*100)/ 100+" M");
					ctx.fillText(value+"",one.x+Stat._vx,one.y,null,null,null);
				}
				Stat.clear();
			}
			Stat._count=0;
			Stat._timer=timer;
		}

		Stat.loopCount=0;
		Stat.shaderCall=0;
		Stat.drawCall=0;
		Stat.trianglesFaces=0;
		Stat.spriteCount=0;
		Stat.FPS=0;
		Stat.canvasNormal=0;
		Stat.canvasBitmap=0;
		Stat.canvasReCache=0;
		Stat.renderSlow=false;
		Stat.currentMemorySize=0;
		Stat._fpsStr=null
		Stat._canvasStr=null
		Stat._canvas=null
		Stat._ctx=null
		Stat._timer=0;
		Stat._count=0;
		Stat._width=120;
		Stat._height=100;
		Stat._view=[];
		Stat._fontSize=12;
		Stat._first=false;
		Stat._vx=NaN
		return Stat;
	})()


	/**
	*<code>StringKey</code> 类用于存取字符串对应的数字。
	*/
	//class laya.utils.StringKey
	var StringKey=(function(){
		function StringKey(){
			this._strs={};
			this._length=0;
		}

		__class(StringKey,'laya.utils.StringKey');
		var __proto=StringKey.prototype;
		/**
		*添加一个字符。
		*@param str 字符，将作为key 存储相应生成的数字。
		*@return 此字符对应的数字。
		*/
		__proto.add=function(str){
			var index=this._strs[str];
			if (index !=null)return index;
			return this._strs[str]=this._length++;
		}

		/**
		*获取指定字符对应的数字。
		*@param str key 字符。
		*@return 此字符对应的数字。
		*/
		__proto.get=function(str){
			var index=this._strs[str];
			return index==null ?-1 :index;
		}

		return StringKey;
	})()


	/**
	*<code>Timer</code> 是时钟管理类。它是一个单例，可以通过 Laya.timer 访问。
	*/
	//class laya.utils.Timer
	var Timer=(function(){
		var TimerHandler;
		function Timer(){
			this._delta=0;
			this.scale=1;
			this.currFrame=0;
			this._mid=1;
			this._map=[];
			this._laters=[];
			this._handlers=[];
			this._temp=[];
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
							if (t > handler.exeTime){
								handler.exeTime+=handler.delay;
								handler.run(false);
								if (t > handler.exeTime){
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
			this._map[handler.key]=null;
			handler.clear();
			Timer._pool.push(handler);
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
			handler=Timer._pool.length > 0 ? Timer._pool.pop():new TimerHandler();
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
			this._updateEase(Browser.now());
		}

		/**@private */
		__proto._updateEase=function(time){
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
			if (this.update)this.update.run();
		}

		/**
		*立即结束缓动并到终点。
		*/
		__proto.complete=function(){
			if (!this._target)return;
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
			newLTPoint=new Point(x0,y0);
			newLTPoint=sprite.localToGlobal(newLTPoint);
			var newRBPoint;
			newRBPoint=new Point(x1,y1);
			newRBPoint=sprite.localToGlobal(newRBPoint);
			return Rectangle._getWrapRec([newLTPoint.x,newLTPoint.y,newRBPoint.x,newRBPoint.y]);
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

		Utils._gid=1;
		Utils._pi=180 / Math.PI;
		Utils._pi2=Math.PI / 180;
		Utils.parseXMLFromString=function(value){
			var rst;
			value=value.replace(/>\s+</g,'><');
			rst=(new DOMParser()).parseFromString(value,'text/xml');
			if (rst.firstChild.textContent.indexOf("This page contains the following errors")>-1){
				throw new Error(rst.firstChild.firstChild.textContent);
			}
			return rst;
		}

		return Utils;
	})()


	/**
	*@private
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

		VectorGraphManager.instance=null
		return VectorGraphManager;
	})()


	/**
	*@private
	*/
	//class laya.utils.WordText
	var WordText=(function(){
		function WordText(){
			this.id=NaN;
			this.save=[];
			this.toUpperCase=null;
			this.changed=false;
			this._text=null;
		}

		__class(WordText,'laya.utils.WordText');
		var __proto=WordText.prototype;
		__proto.setText=function(txt){
			this.changed=true;
			this._text=txt;
		}

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


	//class laya.webgl.atlas.AtlasGrid
	var AtlasGrid=(function(){
		var TexRowInfo,TexMergeTexSize;
		function AtlasGrid(width,height,atlasID){
			this._atlasID=0;
			this._width=0;
			this._height=0;
			this._texCount=0;
			this._rowInfo=null;
			this._cells=null;
			this._failSize=new TexMergeTexSize();
			(width===void 0)&& (width=0);
			(height===void 0)&& (height=0);
			(atlasID===void 0)&& (atlasID=0);
			this._cells=null;
			this._rowInfo=null;
			this._init(width,height);
			this._atlasID=atlasID;
		}

		__class(AtlasGrid,'laya.webgl.atlas.AtlasGrid');
		var __proto=AtlasGrid.prototype;
		//------------------------------------------------------------------------------
		__proto.getAltasID=function(){
			return this._atlasID;
		}

		//------------------------------------------------------------------------------
		__proto.setAltasID=function(atlasID){
			if (atlasID >=0){
				this._atlasID=atlasID;
			}
		}

		//------------------------------------------------------------------
		__proto.addTex=function(type,width,height){
			var result=this._get(width,height);
			if (result.ret==false){
				return result;
			}
			this._fill(result.x,result.y,width,height,type);
			this._texCount++;
			return result;
		}

		//------------------------------------------------------------------------------
		__proto._release=function(){
			if (this._cells !=null){
				this._cells.length=0;
				this._cells=null;
			}
			if (this._rowInfo){
				this._rowInfo.length=0;
				this._rowInfo=null;
			}
		}

		//------------------------------------------------------------------------------
		__proto._init=function(width,height){
			this._width=width;
			this._height=height;
			this._release();
			if (this._width==0)return false;
			this._cells=new Uint8Array(this._width *this._height*3);
			this._rowInfo=__newvec(this._height);
			for (var i=0;i < this._height;i++){
				this._rowInfo[i]=new TexRowInfo();
			}
			this._clear();
			return true;
		}

		//------------------------------------------------------------------
		__proto._get=function(width,height){
			var pFillInfo=new MergeFillInfo();
			if (width >=this._failSize.width && height >=this._failSize.height){
				return pFillInfo;
			};
			var rx=-1;
			var ry=-1;
			var nWidth=this._width;
			var nHeight=this._height;
			var pCellBox=this._cells;
			for (var y=0;y < nHeight;y++){
				if (this._rowInfo[y].spaceCount < width)continue ;
				for (var x=0;x < nWidth;){
					var tm=(y *nWidth+x)*3;
					if (pCellBox[tm] !=0 || pCellBox[tm+1] < width || pCellBox[tm+2] < height){
						x+=pCellBox[tm+1];
						continue ;
					}
					rx=x;
					ry=y;
					for (var xx=0;xx < width;xx++){
						if (pCellBox[3*xx+tm+2] < height){
							rx=-1;
							break ;
						}
					}
					if (rx < 0){
						x+=pCellBox[tm+1];
						continue ;
					}
					pFillInfo.ret=true;
					pFillInfo.x=rx;
					pFillInfo.y=ry;
					return pFillInfo;
				}
			}
			return pFillInfo;
		}

		//------------------------------------------------------------------
		__proto._fill=function(x,y,w,h,type){
			var nWidth=this._width;
			var nHeghit=this._height;
			this._check((x+w)<=nWidth && (y+h)<=nHeghit);
			for (var yy=y;yy < (h+y);++yy){
				this._check(this._rowInfo[yy].spaceCount >=w);
				this._rowInfo[yy].spaceCount-=w;
				for (var xx=0;xx < w;xx++){
					var tm=(x+yy *nWidth+xx)*3;
					this._check(this._cells[tm]==0);
					this._cells[tm]=type;
					this._cells[tm+1]=w;
					this._cells[tm+2]=h;
				}
			}
			if (x > 0){
				for (yy=0;yy < h;++yy){
					var s=0;
					for (xx=x-1;xx >=0;--xx,++s){
						if (this._cells[((y+yy)*nWidth+xx)*3] !=0)break ;
					}
					for (xx=s;xx > 0;--xx){
						this._cells[((y+yy)*nWidth+x-xx)*3+1]=xx;
						this._check(xx > 0);
					}
				}
			}
			if (y > 0){
				for (xx=x;xx < (x+w);++xx){
					s=0;
					for (yy=y-1;yy >=0;--yy,s++){
						if (this._cells[(xx+yy *nWidth)*3] !=0)break ;
					}
					for (yy=s;yy > 0;--yy){
						this._cells[(xx+(y-yy)*nWidth)*3+2]=yy;
						this._check(yy > 0);
					}
				}
			}
		}

		__proto._check=function(ret){
			if (ret==false){
				console.log("xtexMerger 错误啦");
			}
		}

		//------------------------------------------------------------------
		__proto._clear=function(){
			this._texCount=0;
			for (var y=0;y < this._height;y++){
				this._rowInfo[y].spaceCount=this._width;
			}
			for (var i=0;i < this._height;i++){
				for (var j=0;j < this._width;j++){
					var tm=(i *this._width+j)*3;
					this._cells[tm]=0;
					this._cells[tm+1]=this._width-j;
					this._cells[tm+2]=this._width-i;
				}
			}
			this._failSize.width=this._width+1;
			this._failSize.height=this._height+1;
		}

		AtlasGrid.__init$=function(){
			//------------------------------------------------------------------------------
			//class TexRowInfo
			TexRowInfo=(function(){
				function TexRowInfo(){
					this.spaceCount=0;
				}
				__class(TexRowInfo,'');
				return TexRowInfo;
			})()
			//------------------------------------------------------------------------------
			//class TexMergeTexSize
			TexMergeTexSize=(function(){
				function TexMergeTexSize(){
					this.width=0;
					this.height=0;
				}
				__class(TexMergeTexSize,'');
				return TexMergeTexSize;
			})()
		}

		return AtlasGrid;
	})()


	//class laya.webgl.atlas.AtlasResourceManager
	var AtlasResourceManager=(function(){
		function AtlasResourceManager(width,height,gridSize,maxTexNum){
			this._currentAtlasCount=0;
			this._maxAtlaserCount=0;
			this._width=0;
			this._height=0;
			this._gridSize=0;
			this._gridNumX=0;
			this._gridNumY=0;
			this._init=false;
			this._curAtlasIndex=0;
			this._setAtlasParam=false;
			this._atlaserArray=null;
			this._needGC=false;
			this._setAtlasParam=true;
			this._width=width;
			this._height=height;
			this._gridSize=gridSize;
			this._maxAtlaserCount=maxTexNum;
			this._gridNumX=width / gridSize;
			this._gridNumY=height / gridSize;
			this._curAtlasIndex=0;
			this._atlaserArray=[];
		}

		__class(AtlasResourceManager,'laya.webgl.atlas.AtlasResourceManager');
		var __proto=AtlasResourceManager.prototype;
		__proto.setAtlasParam=function(width,height,gridSize,maxTexNum){
			if (this._setAtlasParam==true){
				AtlasResourceManager._sid_=0;
				this._width=width;
				this._height=height;
				this._gridSize=gridSize;
				this._maxAtlaserCount=maxTexNum;
				this._gridNumX=width / gridSize;
				this._gridNumY=height / gridSize;
				this._curAtlasIndex=0;
				this.freeAll();
				return true;
				}else {
				console.log("设置大图合集参数错误，只能在开始页面设置各种参数");
				throw-1;
				return false;
			}
			return false;
		}

		//添加 图片到大图集
		__proto.pushData=function(texture){
			var tex=texture;
			this._setAtlasParam=false;
			var bFound=false;
			var nImageGridX=(Math.ceil((texture.bitmap.width+2)/ this._gridSize));
			var nImageGridY=(Math.ceil((texture.bitmap.height+2)/ this._gridSize));
			var bSuccess=false;
			for (var k=0;k < 2;k++){
				var maxAtlaserCount=this._maxAtlaserCount;
				for (var i=0;i < maxAtlaserCount;i++){
					var altasIndex=(this._curAtlasIndex+i)% maxAtlaserCount;
					(this._atlaserArray.length-1>=altasIndex)|| (this._atlaserArray.push(new Atlaser(this._gridNumX,this._gridNumY,this._width,this._height,AtlasResourceManager._sid_++)));
					var atlas=this._atlaserArray[altasIndex];
					var bitmap=texture.bitmap;
					var webGLImageIndex=atlas.inAtlasWebGLImagesKey.indexOf(bitmap);
					var offsetX=0,offsetY=0;
					if (webGLImageIndex==-1){
						var fillInfo=atlas.addTex(1,nImageGridX,nImageGridY);
						if (fillInfo.ret){
							offsetX=fillInfo.x *this._gridSize+1;
							offsetY=fillInfo.y *this._gridSize+1;
							bitmap.lock=true;
							atlas.addToAtlasTexture((bitmap),offsetX,offsetY);
							atlas.addToAtlas(texture,offsetX,offsetY);
							bSuccess=true;
							this._curAtlasIndex=altasIndex;
							break ;
						}
						}else {
						var offset=atlas.InAtlasWebGLImagesOffsetValue[webGLImageIndex];
						offsetX=offset[0];
						offsetY=offset[1];
						atlas.addToAtlas(texture,offsetX,offsetY);
						bSuccess=true;
						this._curAtlasIndex=altasIndex;
						break ;
					}
				}
				if (bSuccess)
					break ;
				this._atlaserArray.push(new Atlaser(this._gridNumX,this._gridNumY,this._width,this._height,AtlasResourceManager._sid_++));
				this._needGC=true;
				this.garbageCollection();
				this._curAtlasIndex=this._atlaserArray.length-1;
			}
			if (!bSuccess){
				console.log(">>>AtlasManager pushData error");
			}
			return bSuccess;
		}

		__proto.addToAtlas=function(tex){
			laya.webgl.atlas.AtlasResourceManager.instance.pushData(tex);
		}

		/**
		*回收大图合集,不建议手动调用
		*@return
		*/
		__proto.garbageCollection=function(){
			if (this._needGC===true){
				var n=this._atlaserArray.length-this._maxAtlaserCount;
				for (var i=0;i < n;i++)
				this._atlaserArray[i].dispose();
				this._atlaserArray.splice(0,n);
				this._needGC=false;
			}
			return true;
		}

		__proto.freeAll=function(){
			for (var i=0,n=this._atlaserArray.length;i < n;i++){
				this._atlaserArray[i].dispose();
			}
			this._atlaserArray.length=0;
			this._curAtlasIndex=0;
		}

		__proto.getAtlaserCount=function(){
			return this._atlaserArray.length;
		}

		__proto.getAtlaserByIndex=function(index){
			return this._atlaserArray[index];
		}

		__getset(1,AtlasResourceManager,'instance',function(){
			if (!AtlasResourceManager._Instance){
				AtlasResourceManager._Instance=new AtlasResourceManager(laya.webgl.atlas.AtlasResourceManager.atlasTextureWidth,laya.webgl.atlas.AtlasResourceManager.atlasTextureHeight,16,laya.webgl.atlas.AtlasResourceManager.maxTextureCount);
			}
			return AtlasResourceManager._Instance;
		});

		__getset(1,AtlasResourceManager,'atlasLimitWidth',function(){
			return AtlasResourceManager._atlasLimitWidth;
			},function(value){
			AtlasResourceManager._atlasLimitWidth=value;
		});

		__getset(1,AtlasResourceManager,'enabled',function(){
			return AtlasResourceManager._enabled;
		});

		__getset(1,AtlasResourceManager,'atlasLimitHeight',function(){
			return AtlasResourceManager._atlasLimitHeight;
			},function(value){
			AtlasResourceManager._atlasLimitHeight=value;
		});

		AtlasResourceManager._enable=function(){
			AtlasResourceManager._enabled=true;
			Config.atlasEnable=true;
		}

		AtlasResourceManager._disable=function(){
			AtlasResourceManager._enabled=false;
			Config.atlasEnable=false;
		}

		AtlasResourceManager.__init__=function(){
			AtlasResourceManager.atlasTextureWidth=2048;
			AtlasResourceManager.atlasTextureHeight=2048;
			AtlasResourceManager.maxTextureCount=6;
			AtlasResourceManager.atlasLimitWidth=512;
			AtlasResourceManager.atlasLimitHeight=512;
		}

		AtlasResourceManager._enabled=false;
		AtlasResourceManager._atlasLimitWidth=0;
		AtlasResourceManager._atlasLimitHeight=0;
		AtlasResourceManager.gridSize=16;
		AtlasResourceManager.atlasTextureWidth=0;
		AtlasResourceManager.atlasTextureHeight=0;
		AtlasResourceManager.maxTextureCount=0;
		AtlasResourceManager._atlasRestore=0;
		AtlasResourceManager.BOARDER_TYPE_NO=0;
		AtlasResourceManager.BOARDER_TYPE_RIGHT=1;
		AtlasResourceManager.BOARDER_TYPE_LEFT=2;
		AtlasResourceManager.BOARDER_TYPE_BOTTOM=4;
		AtlasResourceManager.BOARDER_TYPE_TOP=8;
		AtlasResourceManager.BOARDER_TYPE_ALL=15;
		AtlasResourceManager._sid_=0;
		AtlasResourceManager._Instance=null;
		return AtlasResourceManager;
	})()


	//class laya.webgl.atlas.MergeFillInfo
	var MergeFillInfo=(function(){
		function MergeFillInfo(){
			this.x=0;
			this.y=0;
			this.ret=false;
			this.ret=false;
			this.x=0;
			this.y=0;
		}

		__class(MergeFillInfo,'laya.webgl.atlas.MergeFillInfo');
		return MergeFillInfo;
	})()


	;
	//class laya.webgl.canvas.BlendMode
	var BlendMode=(function(){
		function BlendMode(){};
		__class(BlendMode,'laya.webgl.canvas.BlendMode');
		BlendMode._init_=function(gl){
			BlendMode.fns=[BlendMode.BlendNormal,BlendMode.BlendAdd,BlendMode.BlendMultiply,BlendMode.BlendScreen,BlendMode.BlendOverlay,BlendMode.BlendLight,BlendMode.BlendMask];
			BlendMode.targetFns=[BlendMode.BlendNormalTarget,BlendMode.BlendAddTarget,BlendMode.BlendMultiplyTarget,BlendMode.BlendScreenTarget,BlendMode.BlendOverlayTarget,BlendMode.BlendLightTarget,BlendMode.BlendMask];
		}

		BlendMode.BlendNormal=function(gl){
			gl.blendFunc(0x0302,0x0303);
		}

		BlendMode.BlendAdd=function(gl){
			gl.blendFunc(0x0302,0x0304);
		}

		BlendMode.BlendMultiply=function(gl){
			gl.blendFunc(0x0306,0x0303);
		}

		BlendMode.BlendScreen=function(gl){
			gl.blendFunc(0x0302,1);
		}

		BlendMode.BlendOverlay=function(gl){
			gl.blendFunc(1,0x0301);
		}

		BlendMode.BlendLight=function(gl){
			gl.blendFunc(0x0302,1);
		}

		BlendMode.BlendNormalTarget=function(gl){
			gl.blendFuncSeparate(0x0302,0x0303,1,0x0303);
		}

		BlendMode.BlendAddTarget=function(gl){
			gl.blendFunc(0x0302,0x0304);
		}

		BlendMode.BlendMultiplyTarget=function(gl){
			gl.blendFunc(0x0306,0x0303);
		}

		BlendMode.BlendScreenTarget=function(gl){
			gl.blendFunc(0x0302,1);
		}

		BlendMode.BlendOverlayTarget=function(gl){
			gl.blendFunc(1,0x0301);
		}

		BlendMode.BlendLightTarget=function(gl){
			gl.blendFunc(0x0302,1);
		}

		BlendMode.BlendMask=function(gl){
			gl.blendFunc(0,0x0302);
		}

		BlendMode.activeBlendFunction=null;
		BlendMode.NAMES=["normal","add","multiply","screen","overlay","light","mask"];
		BlendMode.TOINT={"normal":0,"add":1,"multiply":2,"screen":3 ,"lighter":1,"overlay":4,"light":5,"mask":6};
		BlendMode.NORMAL="normal";
		BlendMode.ADD="add";
		BlendMode.MULTIPLY="multiply";
		BlendMode.SCREEN="screen";
		BlendMode.LIGHT="light";
		BlendMode.OVERLAY="overlay";
		BlendMode.fns=[];
		BlendMode.targetFns=[];
		return BlendMode;
	})()


	//class laya.webgl.canvas.DrawStyle
	var DrawStyle=(function(){
		function DrawStyle(value){
			this._color=Color.create("black");
			this.setValue(value);
		}

		__class(DrawStyle,'laya.webgl.canvas.DrawStyle');
		var __proto=DrawStyle.prototype;
		__proto.setValue=function(value){
			if (value){
				if ((typeof value=='string')){
					this._color=Color.create(value);
					return;
				}
				if ((value instanceof laya.utils.Color )){
					this._color=value;
					return;
				}
			}
		}

		__proto.reset=function(){
			this._color=Color.create("black");
		}

		__proto.equal=function(value){
			if ((typeof value=='string'))return this._color.strColor===value;
			if ((value instanceof laya.utils.Color ))return this._color.numColor===(value).numColor;
			return false;
		}

		__proto.toColorStr=function(){
			return this._color.strColor;
		}

		DrawStyle.create=function(value){
			if (value){
				var color;
				if ((typeof value=='string'))color=Color.create(value);
				else if ((value instanceof laya.utils.Color ))color=value;
				if (color){
					return color._drawStyle || (color._drawStyle=new DrawStyle(value));
				}
			}
			return null;
		}

		DrawStyle.DEFAULT=new DrawStyle("#000000");
		return DrawStyle;
	})()


	//class laya.webgl.canvas.Path
	var Path=(function(){
		function Path(){
			this._x=0;
			this._y=0;
			//this._rect=null;
			//this.ib=null;
			//this.vb=null;
			this.dirty=false;
			//this.geomatrys=null;
			//this._curGeomatry=null;
			this.offset=0;
			this.count=0;
			this.geoStart=0;
			this.tempArray=[];
			this.closePath=false;
			this.geomatrys=[];
			var gl=WebGL.mainContext;
			this.ib=IndexBuffer2D.create(0x88E8);
			this.vb=VertexBuffer2D.create(5);
		}

		__class(Path,'laya.webgl.canvas.Path');
		var __proto=Path.prototype;
		__proto.addPoint=function(pointX,pointY){
			this.tempArray.push(pointX,pointY);
		}

		__proto.getEndPointX=function(){
			return this.tempArray[this.tempArray.length-2];
		}

		__proto.getEndPointY=function(){
			return this.tempArray[this.tempArray.length-1];
		}

		__proto.polygon=function(x,y,points,color,borderWidth,borderColor){
			var geo;
			this.geomatrys.push(this._curGeomatry=geo=new Polygon(x,y,points,color,borderWidth,borderColor));
			if (!color)geo.fill=false;
			if (borderColor==undefined)geo.borderWidth=0;
			return geo;
		}

		__proto.setGeomtry=function(shape){
			this.geomatrys.push(this._curGeomatry=shape);
		}

		__proto.drawLine=function(x,y,points,width,color){
			var geo;
			if (this.closePath){
				this.geomatrys.push(this._curGeomatry=geo=new LoopLine(x,y,points,width,color));
				}else {
				this.geomatrys.push(this._curGeomatry=geo=new Line(x,y,points,width,color));
			}
			geo.fill=false;
			return geo;
		}

		__proto.update=function(){
			var si=this.ib.byteLength;
			var len=this.geomatrys.length;
			this.offset=si;
			for (var i=this.geoStart;i < len;i++){
				this.geomatrys[i].getData(this.ib,this.vb,this.vb.byteLength / 20);
			}
			this.geoStart=len;
			this.count=(this.ib.byteLength-si)/ CONST3D2D.BYTES_PIDX;
		}

		__proto.reset=function(){
			this.vb.clear();
			this.ib.clear();
			this.offset=this.count=this.geoStart=0;
			this.geomatrys.length=0;
		}

		return Path;
	})()


	//class laya.webgl.canvas.save.SaveBase
	var SaveBase=(function(){
		function SaveBase(){
			//this._valueName=null;
			//this._value=null;
			//this._dataObj=null;
			//this._newSubmit=false;
		}

		__class(SaveBase,'laya.webgl.canvas.save.SaveBase');
		var __proto=SaveBase.prototype;
		Laya.imps(__proto,{"laya.webgl.canvas.save.ISaveData":true})
		__proto.isSaveMark=function(){return false;}
		__proto.restore=function(context){
			this._dataObj[this._valueName]=this._value;
			SaveBase._cache[SaveBase._cache._length++]=this;
			this._newSubmit && (context._curSubmit=Submit.RENDERBASE);
		}

		SaveBase._createArray=function(){
			var value=[];
			value._length=0;
			return value;
		}

		SaveBase._init=function(){
			var namemap=SaveBase._namemap={};
			namemap[0x1]="ALPHA";
			namemap[0x2]="fillStyle";
			namemap[0x8]="font";
			namemap[0x100]="lineWidth";
			namemap[0x200]="strokeStyle";
			namemap[0x2000]="_mergeID";
			namemap[0x400]=namemap[0x800]=namemap[0x1000]=[];
			namemap[0x4000]="textBaseline";
			namemap[0x8000]="textAlign";
			namemap[0x10000]="_nBlendType";
			namemap[0x80000]="shader";
			namemap[0x100000]="filters";
			return namemap;
		}

		SaveBase.save=function(context,type,dataObj,newSubmit){
			if ((context._saveMark._saveuse & type)!==type){
				context._saveMark._saveuse |=type;
				var cache=SaveBase._cache;
				var o=cache._length > 0 ? cache[--cache._length] :(new SaveBase());
				o._value=dataObj[o._valueName=SaveBase._namemap[type]];
				o._dataObj=dataObj;
				o._newSubmit=newSubmit;
				var _save=context._save;
				_save[_save._length++]=o;
			}
		}

		SaveBase._cache=laya.webgl.canvas.save.SaveBase._createArray();
		SaveBase._namemap=SaveBase._init();
		return SaveBase;
	})()


	//class laya.webgl.canvas.save.SaveClipRect
	var SaveClipRect=(function(){
		function SaveClipRect(){
			//this._clipSaveRect=null;
			//this._submitScissor=null;
			this._clipRect=new Rectangle();
		}

		__class(SaveClipRect,'laya.webgl.canvas.save.SaveClipRect');
		var __proto=SaveClipRect.prototype;
		Laya.imps(__proto,{"laya.webgl.canvas.save.ISaveData":true})
		__proto.isSaveMark=function(){return false;}
		__proto.restore=function(context){
			context._clipRect=this._clipSaveRect;
			SaveClipRect._cache[SaveClipRect._cache._length++]=this;
			this._submitScissor.submitLength=context._submits._length-this._submitScissor.submitIndex;
			context._curSubmit=Submit.RENDERBASE;
		}

		SaveClipRect.save=function(context,submitScissor){
			if ((context._saveMark._saveuse & 0x20000)==0x20000)return;
			context._saveMark._saveuse |=0x20000;
			var cache=SaveClipRect._cache;
			var o=cache._length > 0 ? cache[--cache._length] :(new SaveClipRect());
			o._clipSaveRect=context._clipRect;
			context._clipRect=o._clipRect.copyFrom(context._clipRect);
			o._submitScissor=submitScissor;
			var _save=context._save;
			_save[_save._length++]=o;
		}

		SaveClipRect._cache=SaveBase._createArray();
		return SaveClipRect;
	})()


	//class laya.webgl.canvas.save.SaveMark
	var SaveMark=(function(){
		function SaveMark(){
			this._saveuse=0;
			//this._preSaveMark=null;
			;
		}

		__class(SaveMark,'laya.webgl.canvas.save.SaveMark');
		var __proto=SaveMark.prototype;
		Laya.imps(__proto,{"laya.webgl.canvas.save.ISaveData":true})
		__proto.isSaveMark=function(){
			return true;
		}

		__proto.restore=function(context){
			context._saveMark=this._preSaveMark;
			SaveMark._no[SaveMark._no._length++]=this;
		}

		SaveMark.Create=function(context){
			var no=SaveMark._no;
			var o=no._length > 0 ? no[--no._length] :(new SaveMark());
			o._saveuse=0;
			o._preSaveMark=context._saveMark;
			context._saveMark=o;
			return o;
		}

		SaveMark._no=SaveBase._createArray();
		return SaveMark;
	})()


	//class laya.webgl.canvas.save.SaveTransform
	var SaveTransform=(function(){
		function SaveTransform(){
			//this._savematrix=null;
			this._matrix=new Matrix();
		}

		__class(SaveTransform,'laya.webgl.canvas.save.SaveTransform');
		var __proto=SaveTransform.prototype;
		Laya.imps(__proto,{"laya.webgl.canvas.save.ISaveData":true})
		__proto.isSaveMark=function(){return false;}
		__proto.restore=function(context){
			context._curMat=this._savematrix;
			SaveTransform._no[SaveTransform._no._length++]=this;
		}

		SaveTransform.save=function(context){
			var _saveMark=context._saveMark;
			if ((_saveMark._saveuse & 0x800)===0x800)return;
			_saveMark._saveuse |=0x800;
			var no=SaveTransform._no;
			var o=no._length > 0 ? no[--no._length] :(new SaveTransform());
			o._savematrix=context._curMat;
			context._curMat=context._curMat.copyTo(o._matrix);
			var _save=context._save;
			_save[_save._length++]=o;
		}

		SaveTransform._no=SaveBase._createArray();
		return SaveTransform;
	})()


	//class laya.webgl.canvas.save.SaveTranslate
	var SaveTranslate=(function(){
		function SaveTranslate(){
			//this._x=NaN;
			//this._y=NaN;
		}

		__class(SaveTranslate,'laya.webgl.canvas.save.SaveTranslate');
		var __proto=SaveTranslate.prototype;
		Laya.imps(__proto,{"laya.webgl.canvas.save.ISaveData":true})
		__proto.isSaveMark=function(){return false;}
		__proto.restore=function(context){
			var mat=context._curMat;
			context._x=this._x;
			context._y=this._y;
			SaveTranslate._no[SaveTranslate._no._length++]=this;
		}

		SaveTranslate.save=function(context){
			var no=SaveTranslate._no;
			var o=no._length > 0 ? no[--no._length] :(new SaveTranslate());
			o._x=context._x;
			o._y=context._y;
			var _save=context._save;
			_save[_save._length++]=o;
		}

		SaveTranslate._no=SaveBase._createArray();
		return SaveTranslate;
	})()


	//class laya.webgl.resource.RenderTargetMAX
	var RenderTargetMAX=(function(){
		var OneTarget;
		function RenderTargetMAX(){
			this.targets=null;
			this.oneTargets=null;
			this.repaint=false;
			this._width=NaN;
			this._height=NaN;
			this._clipRect=new Rectangle();
		}

		__class(RenderTargetMAX,'laya.webgl.resource.RenderTargetMAX');
		var __proto=RenderTargetMAX.prototype;
		__proto.size=function(w,h){
			if (this._width===w && this._height===h)return;
			this.repaint=true;
			this._width=w;
			this._height=h;
			if (!this.oneTargets)
				this.oneTargets=new OneTarget(w,h);
			else
			this.oneTargets.target.size(w,h);
		}

		__proto._flushToTarget=function(context,target){
			var worldScissorTest=RenderState2D.worldScissorTest;
			var preworldClipRect=RenderState2D.worldClipRect;
			RenderState2D.worldClipRect=this._clipRect;
			this._clipRect.x=this._clipRect.y=0;
			this._clipRect.width=this._width;
			this._clipRect.height=this._height;
			RenderState2D.worldScissorTest=false;
			WebGL.mainContext.disable(0x0C11);
			var preAlpha=RenderState2D.worldAlpha;
			var preMatrix4=RenderState2D.worldMatrix4;
			var preMatrix=RenderState2D.worldMatrix;
			var preFilters=RenderState2D.worldFilters;
			var preShaderDefines=RenderState2D.worldShaderDefines;
			RenderState2D.worldMatrix=RenderTargetMAX._matrixDefault;
			RenderState2D.restoreTempArray();
			RenderState2D.worldMatrix4=RenderState2D.TEMPMAT4_ARRAY;
			RenderState2D.worldAlpha=1;
			RenderState2D.worldFilters=null;
			RenderState2D.worldShaderDefines=null;
			Shader.activeShader=null;
			target.start();
			Config.showCanvasMark ? target.clear(0,1,0,0.3):target.clear(0,0,0,0);
			context.flush();
			target.end();
			Shader.activeShader=null;
			RenderState2D.worldAlpha=preAlpha;
			RenderState2D.worldMatrix4=preMatrix4;
			RenderState2D.worldMatrix=preMatrix;
			RenderState2D.worldFilters=preFilters;
			RenderState2D.worldShaderDefines=preShaderDefines;
			RenderState2D.worldScissorTest=worldScissorTest
			if (worldScissorTest){
				var y=RenderState2D.height-preworldClipRect.y-preworldClipRect.height;
				WebGL.mainContext.scissor(preworldClipRect.x,y,preworldClipRect.width,preworldClipRect.height);
				WebGL.mainContext.enable(0x0C11);
			}
			RenderState2D.worldClipRect=preworldClipRect;
		}

		__proto.flush=function(context){
			if (this.repaint){
				this._flushToTarget(context,this.oneTargets.target);
				this.repaint=false;
			}
		}

		__proto.drawTo=function(context,x,y,width,height){
			context.drawTexture(this.oneTargets.target.getTexture(),x,y,width,height,0,0);
		}

		__proto.destroy=function(){
			if (this.oneTargets){
				this.oneTargets.target.destroy();
				this.oneTargets.target=null;
				this.oneTargets=null;
			}
		}

		__static(RenderTargetMAX,
		['_matrixDefault',function(){return this._matrixDefault=new Matrix();}
		]);
		RenderTargetMAX.__init$=function(){
			//class OneTarget
			OneTarget=(function(){
				function OneTarget(w,h){
					//this.x=NaN;
					//this.width=NaN;
					//this.height=NaN;
					//this.target=null;
					this.width=w;
					this.height=h;
					this.target=RenderTarget2D.create(w,h);
				}
				__class(OneTarget,'');
				return OneTarget;
			})()
		}

		return RenderTargetMAX;
	})()


	//class laya.webgl.shader.d2.fillTexture.FillTextureSprite
	var FillTextureSprite=(function(){
		function FillTextureSprite(){
			this.mVBBuffer=null;
			this.mIBBuffer=null;
			this.mVBData=null;
			this.mIBData=null;
			this.mEleNum=0;
			this.mShaderValue=null;
			this.mTexture=null;
			this.transform=null;
			this._start=-1;
			this._indexStart=-1;
			this._resultPs=null;
			this._ps=null;
			this._vb=null;
			this.u_texRange=[0,1,0,1];
			this.u_offset=[0,0];
			this._tempMatrix=new Matrix();
		}

		__class(FillTextureSprite,'laya.webgl.shader.d2.fillTexture.FillTextureSprite');
		var __proto=FillTextureSprite.prototype;
		__proto.initTexture=function(texture,x,y,width,height,offsetX,offsetY){
			this.mTexture=texture;
			if (this._vb==null)this._vb=[];
			this._vb.length=0;
			var w=texture.bitmap.width,h=texture.bitmap.height,uv=texture.uv;
			var tTextureX=uv[0] *w;
			var tTextureY=uv[1] *h;
			var tTextureW=(uv[2]-uv[0])*w;
			var tTextureH=(uv[5]-uv[3])*h;
			var tU=width / tTextureW;
			var tV=height / tTextureH;
			var tWidth=width;
			var tHeight=height;
			var tRed=1;
			var tGreed=1;
			var tBlue=1;
			var tAlpha=1;
			this._vb.push(x,y,0,0,tRed,tGreed,tBlue,tAlpha);
			this._vb.push(x+tWidth,y,tU,0,tRed,tGreed,tBlue,tAlpha);
			this._vb.push(x+tWidth,y+tHeight,tU,tV,tRed,tGreed,tBlue,tAlpha);
			this._vb.push(x,y+tHeight,0,tV,tRed,tGreed,tBlue,tAlpha);
			if (this._ps==null)this._ps=[];
			this._ps.length=0;
			this._ps.push(0,1,3,3,1,2);
			this.mEleNum=this._ps.length;
			this.mVBData=new Float32Array(this._vb);
			this.u_offset[0]=-offsetX / tTextureW;
			this.u_offset[1]=-offsetY / tTextureH;
			this.u_texRange[0]=tTextureX / w;
			this.u_texRange[1]=tTextureW / w;
			this.u_texRange[2]=tTextureY / h;
			this.u_texRange[3]=tTextureH / h;
		}

		__proto.getData=function(vb,ib,start){
			this.mVBBuffer=vb;
			this.mIBBuffer=ib;
			vb.append(this.mVBData);
			this._start=start;
			this._indexStart=ib.byteLength;
			if (this._resultPs==null)this._resultPs=[];
			this._resultPs.length=0;
			for (var i=0,n=this._ps.length;i < n;i++){
				this._resultPs.push(this._ps[i]+start);
			}
			this.mIBData=new Uint16Array(this._resultPs);
			ib.append(this.mIBData);
		}

		__proto.render=function(context,x,y){
			if (Render.isWebGL){
				SkinMeshBuffer.getInstance().addFillTexture(this);
				if (this.mIBBuffer && this.mIBBuffer){
					context._shader2D.glTexture=null;
					var tempSubmit=Submit.createShape(context,this.mIBBuffer,this.mVBBuffer,this.mEleNum,this._indexStart,Value2D.create(0x100,0));
					Matrix.TEMP.identity();
					this.transform || (this.transform=Matrix.EMPTY);
					this.transform.translate(x,y);
					Matrix.mul(this.transform,context._curMat,this._tempMatrix);
					this.transform.translate(-x,-y);
					var tArray=RenderState2D.getMatrArray();
					RenderState2D.mat2MatArray(this._tempMatrix,tArray);
					var tShaderValue=tempSubmit.shaderValue;
					tShaderValue.textureHost=this.mTexture;
					tShaderValue.u_offset[0]=this.u_offset[0];
					tShaderValue.u_offset[1]=this.u_offset[1];
					tShaderValue.u_texRange[0]=this.u_texRange[0];
					tShaderValue.u_texRange[1]=this.u_texRange[1];
					tShaderValue.u_texRange[2]=this.u_texRange[2];
					tShaderValue.u_texRange[3]=this.u_texRange[3];
					tShaderValue.ALPHA=context._shader2D.ALPHA;
					tShaderValue.u_mmat2=tArray;
					(context)._submits[(context)._submits._length++]=tempSubmit;
				}
			}
		}

		return FillTextureSprite;
	})()


	//class laya.webgl.shader.d2.Shader2D
	var Shader2D=(function(){
		function Shader2D(){
			this.ALPHA=1;
			//this.glTexture=null;
			//this.shader=null;
			//this.filters=null;
			this.shaderType=0;
			//this.colorAdd=null;
			//this.strokeStyle=null;
			//this.fillStyle=null;
			this.defines=new ShaderDefines2D();
		}

		__class(Shader2D,'laya.webgl.shader.d2.Shader2D');
		Shader2D.__init__=function(){
			Shader.addInclude("parts/ColorFilter_ps_uniform.glsl","uniform vec4 colorAlpha;\nuniform mat4 colorMat;");
			Shader.addInclude("parts/ColorFilter_ps_logic.glsl","gl_FragColor = gl_FragColor * colorMat + colorAlpha/255.0;");
			Shader.addInclude("parts/GlowFilter_ps_uniform.glsl","uniform vec4 u_color;\nuniform float u_strength;\nuniform float u_blurX;\nuniform float u_blurY;\nuniform float u_offsetX;\nuniform float u_offsetY;\nuniform float u_textW;\nuniform float u_textH;");
			Shader.addInclude("parts/GlowFilter_ps_logic.glsl","const float c_IterationTime = 10.0;\nfloat floatIterationTotalTime = c_IterationTime * c_IterationTime;\nvec4 vec4Color = vec4(0.0,0.0,0.0,0.0);\nvec2 vec2FilterDir = vec2(-(u_offsetX)/u_textW,-(u_offsetY)/u_textH);\nvec2 vec2FilterOff = vec2(u_blurX/u_textW/c_IterationTime * 2.0,u_blurY/u_textH/c_IterationTime * 2.0);\nfloat maxNum = u_blurX * u_blurY;\nvec2 vec2Off = vec2(0.0,0.0);\nfloat floatOff = c_IterationTime/2.0;\nfor(float i = 0.0;i<=c_IterationTime; ++i){\n	for(float j = 0.0;j<=c_IterationTime; ++j){\n		vec2Off = vec2(vec2FilterOff.x * (i - floatOff),vec2FilterOff.y * (j - floatOff));\n		vec4Color += texture2D(texture, v_texcoord + vec2FilterDir + vec2Off)/floatIterationTotalTime;\n	}\n}\ngl_FragColor = vec4(u_color.rgb,vec4Color.a * u_strength);");
			Shader.addInclude("parts/BlurFilter_ps_logic.glsl","gl_FragColor=vec4(0.0);\ngl_FragColor += texture2D(texture, vBlurTexCoords[ 0])*0.004431848411938341;\ngl_FragColor += texture2D(texture, vBlurTexCoords[ 1])*0.05399096651318985;\ngl_FragColor += texture2D(texture, vBlurTexCoords[ 2])*0.2419707245191454;\ngl_FragColor += texture2D(texture, v_texcoord        )*0.3989422804014327;\ngl_FragColor += texture2D(texture, vBlurTexCoords[ 3])*0.2419707245191454;\ngl_FragColor += texture2D(texture, vBlurTexCoords[ 4])*0.05399096651318985;\ngl_FragColor += texture2D(texture, vBlurTexCoords[ 5])*0.004431848411938341;");
			Shader.addInclude("parts/BlurFilter_ps_uniform.glsl","varying vec2 vBlurTexCoords[6];");
			Shader.addInclude("parts/BlurFilter_vs_uniform.glsl","uniform float strength;\nvarying vec2 vBlurTexCoords[6];");
			Shader.addInclude("parts/BlurFilter_vs_logic.glsl","\nvBlurTexCoords[ 0] = v_texcoord + vec2(-0.012 * strength, 0.0);\nvBlurTexCoords[ 1] = v_texcoord + vec2(-0.008 * strength, 0.0);\nvBlurTexCoords[ 2] = v_texcoord + vec2(-0.004 * strength, 0.0);\nvBlurTexCoords[ 3] = v_texcoord + vec2( 0.004 * strength, 0.0);\nvBlurTexCoords[ 4] = v_texcoord + vec2( 0.008 * strength, 0.0);\nvBlurTexCoords[ 5] = v_texcoord + vec2( 0.012 * strength, 0.0);");
			Shader.addInclude("parts/ColorAdd_ps_uniform.glsl","uniform vec4 colorAdd;\n");
			Shader.addInclude("parts/ColorAdd_ps_logic.glsl","gl_FragColor = vec4(colorAdd.rgb,colorAdd.a*gl_FragColor.a);");
			var vs,ps;
			vs="attribute vec4 position;\nattribute vec2 texcoord;\nuniform vec2 size;\n\n#ifdef WORLDMAT\nuniform mat4 mmat;\n#endif\nvarying vec2 v_texcoord;\n\n#include?BLUR_FILTER  \"parts/BlurFilter_vs_uniform.glsl\";\nvoid main() {\n  #ifdef WORLDMAT\n  vec4 pos=mmat*position;\n  gl_Position =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);\n  #else\n  gl_Position =vec4((position.x/size.x-0.5)*2.0,(0.5-position.y/size.y)*2.0,position.z,1.0);\n  #endif\n  \n  v_texcoord = texcoord;\n  #include?BLUR_FILTER  \"parts/BlurFilter_vs_logic.glsl\";\n}";
			ps="precision mediump float;\n//precision highp float;\nvarying vec2 v_texcoord;\nuniform sampler2D texture;\nuniform float alpha;\n#include?BLUR_FILTER  \"parts/BlurFilter_ps_uniform.glsl\";\n#include?COLOR_FILTER \"parts/ColorFilter_ps_uniform.glsl\";\n#include?GLOW_FILTER \"parts/GlowFilter_ps_uniform.glsl\";\n#include?COLOR_ADD \"parts/ColorAdd_ps_uniform.glsl\";\n\nvoid main() {\n   vec4 color= texture2D(texture, v_texcoord);\n   color.a*=alpha;\n   gl_FragColor=color;\n   #include?COLOR_ADD \"parts/ColorAdd_ps_logic.glsl\";   \n   #include?BLUR_FILTER  \"parts/BlurFilter_ps_logic.glsl\";\n   #include?COLOR_FILTER \"parts/ColorFilter_ps_logic.glsl\";\n   #include?GLOW_FILTER \"parts/GlowFilter_ps_logic.glsl\";\n}";
			Shader.preCompile2D(0,0x01,vs,ps,null);
			vs="attribute vec4 position;\nuniform vec2 size;\nuniform mat4 mmat;\nvoid main() {\n  vec4 pos=mmat*position;\n  gl_Position =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);\n}";
			ps="precision mediump float;\nuniform vec4 color;\nuniform float alpha;\n#include?COLOR_FILTER \"parts/ColorFilter_ps_uniform.glsl\";\nvoid main() {\n	vec4 a = vec4(color.r, color.g, color.b, color.a);\n	a.w = alpha;\n	gl_FragColor = a;\n	#include?COLOR_FILTER \"parts/ColorFilter_ps_logic.glsl\";\n}";
			Shader.preCompile2D(0,0x02,vs,ps,null);
			vs="attribute vec4 position;\nattribute vec3 a_color;\nuniform mat4 mmat;\nuniform mat4 u_mmat2;\nuniform vec2 u_pos;\nuniform vec2 size;\nvarying vec3 color;\nvoid main(){\n  vec4 tPos = vec4(position.x + u_pos.x,position.y + u_pos.y,position.z,position.w);\n  vec4 pos=mmat*u_mmat2*tPos;\n  gl_Position =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);\n  color=a_color;\n}";
			ps="precision mediump float;\n//precision mediump float;\nvarying vec3 color;\nuniform float alpha;\nvoid main(){\n	//vec4 a=vec4(color.r, color.g, color.b, 1);\n	//a.a*=alpha;\n    gl_FragColor=vec4(color.r, color.g, color.b, alpha);\n}";
			Shader.preCompile2D(0,0x04,vs,ps,null);
			vs="attribute vec2 position;\nattribute vec2 texcoord;\nattribute vec4 color;\nuniform vec2 size;\nuniform mat4 mmat;\nuniform mat4 u_mmat2;\nvarying vec2 v_texcoord;\nvarying vec4 v_color;\nvoid main() {\n  vec4 pos=mmat*u_mmat2*vec4(position.x,position.y,0,1 );\n  gl_Position = vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);\n  v_color = color;\n  v_texcoord = texcoord;  \n}";
			ps="precision mediump float;\nvarying vec2 v_texcoord;\nvarying vec4 v_color;\nuniform sampler2D texture;\nuniform vec4 u_texRange;\nuniform vec2 u_offset;\nuniform float alpha;\nvoid main() {\n	vec2 newTexCoord;\n	newTexCoord.x = mod(((u_offset.x + v_texcoord.x) * u_texRange.y),u_texRange.y) + u_texRange.x;\n	newTexCoord.y = mod(((u_offset.y + v_texcoord.y) * u_texRange.w),u_texRange.w) + u_texRange.z;\n	vec4 t_color = texture2D(texture, newTexCoord);\n	gl_FragColor = t_color * v_color;\n	gl_FragColor.a = gl_FragColor.a * alpha;\n}";
			Shader.preCompile2D(0,0x100,vs,ps,null);
			vs="attribute vec2 position;\nattribute vec2 texcoord;\nattribute vec4 color;\nuniform vec2 size;\nuniform float offsetX;\nuniform float offsetY;\nuniform mat4 mmat;\nuniform mat4 u_mmat2;\nvarying vec2 v_texcoord;\nvarying vec4 v_color;\nvoid main() {\n  vec4 pos=mmat*u_mmat2*vec4(offsetX+position.x,offsetY+position.y,0,1 );\n  gl_Position = vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);\n  v_color = color;\n  v_texcoord = texcoord;  \n}";
			ps="precision mediump float;\nvarying vec2 v_texcoord;\nvarying vec4 v_color;\nuniform sampler2D texture;\nuniform float alpha;\nvoid main() {\n	vec4 t_color = texture2D(texture, v_texcoord);\n	gl_FragColor = t_color.rgba * v_color;\n	gl_FragColor.a = gl_FragColor.a * alpha;\n}";
			Shader.preCompile2D(0,0x200,vs,ps,null);
		}

		return Shader2D;
	})()


	/**
	*这里销毁的问题，后面待确认
	*/
	//class laya.webgl.shader.d2.skinAnishader.SkinMesh
	var SkinMesh=(function(){
		function SkinMesh(){
			this.mVBBuffer=null;
			this.mIBBuffer=null;
			this.mVBData=null;
			this.mIBData=null;
			this.mEleNum=0;
			this.mTexture=null;
			this.transform=null;
			this._vs=null;
			this._ps=null;
			this._resultPs=null;
			this._start=-1;
			this._indexStart=-1;
			this._tempMatrix=new Matrix();
		}

		__class(SkinMesh,'laya.webgl.shader.d2.skinAnishader.SkinMesh');
		var __proto=SkinMesh.prototype;
		__proto.init=function(texture,vs,ps){
			if (vs){
				this._vs=vs;
				}else {
				this._vs=[];
				var tWidth=texture.width;
				var tHeight=texture.height;
				var tRed=1;
				var tGreed=1;
				var tBlue=1;
				var tAlpha=1;
				this._vs.push(0,0,0,0,tRed,tGreed,tBlue,tAlpha);
				this._vs.push(tWidth,0,1,0,tRed,tGreed,tBlue,tAlpha);
				this._vs.push(tWidth,tHeight,1,1,tRed,tGreed,tBlue,tAlpha);
				this._vs.push(0,tHeight,0,1,tRed,tGreed,tBlue,tAlpha);
			}
			if (ps){
				this._ps=ps;
				}else {
				this._ps=[];
				this._ps.push(0,1,3,3,1,2);
			}
			this.mVBData=new Float32Array(this._vs);
			this.mEleNum=this._ps.length;
			this.mTexture=texture;
		}

		__proto.getData=function(vb,ib,start){
			this.mVBBuffer=vb;
			this.mIBBuffer=ib;
			vb.append(this.mVBData);
			this._start=start;
			this._indexStart=ib.byteLength;
			if (this._resultPs==null)this._resultPs=[];
			this._resultPs.length=0;
			for (var i=0,n=this._ps.length;i < n;i++){
				this._resultPs.push(this._ps[i]+start);
			}
			this.mIBData=new Uint16Array(this._resultPs);
			ib.append(this.mIBData);
		}

		__proto.render=function(context,x,y){
			if (Render.isWebGL && this.mTexture){
				context._shader2D.glTexture=null;
				SkinMeshBuffer.getInstance().addSkinMesh(this);
				var tempSubmit=Submit.createShape(context,this.mIBBuffer,this.mVBBuffer,this.mEleNum,this._indexStart,Value2D.create(0x200,0));
				this.transform || (this.transform=Matrix.EMPTY);
				this.transform.translate(x,y);
				Matrix.mul(this.transform,context._curMat,this._tempMatrix);
				this.transform.translate(-x,-y);
				var tArray=RenderState2D.getMatrArray();
				RenderState2D.mat2MatArray(this._tempMatrix,tArray);
				var tShaderValue=tempSubmit.shaderValue;
				tShaderValue.textureHost=this.mTexture;
				tShaderValue.offsetX=0;
				tShaderValue.offsetY=0;
				tShaderValue.u_mmat2=tArray;
				tShaderValue.ALPHA=context._shader2D.ALPHA;
				context._submits[context._submits._length++]=tempSubmit;
			}
		}

		return SkinMesh;
	})()


	//class laya.webgl.shader.d2.skinAnishader.SkinMeshBuffer
	var SkinMeshBuffer=(function(){
		function SkinMeshBuffer(){
			this.ib=null;
			this.vb=null;
			var gl=WebGL.mainContext;
			this.ib=IndexBuffer2D.create(0x88E8);
			this.vb=VertexBuffer2D.create(8);
		}

		__class(SkinMeshBuffer,'laya.webgl.shader.d2.skinAnishader.SkinMeshBuffer');
		var __proto=SkinMeshBuffer.prototype;
		__proto.addSkinMesh=function(skinMesh){
			skinMesh.getData(this.vb,this.ib,this.vb.byteLength / 32);
		}

		__proto.addFillTexture=function(fillTexture){
			fillTexture.getData(this.vb,this.ib,this.vb.byteLength / 32);
		}

		__proto.reset=function(){
			this.vb.clear();
			this.ib.clear();
		}

		SkinMeshBuffer.getInstance=function(){
			return SkinMeshBuffer.instance=SkinMeshBuffer.instance|| new SkinMeshBuffer();
		}

		SkinMeshBuffer.instance=null
		return SkinMeshBuffer;
	})()


	//此类可以减少代码
	//class laya.webgl.shapes.BasePoly
	var BasePoly=(function(){
		function BasePoly(x,y,width,height,edges,color,borderWidth,borderColor,round){
			//this.x=NaN;
			//this.y=NaN;
			//this.r=NaN;
			//this.width=NaN;
			//this.height=NaN;
			//this.edges=NaN;
			this.r0=0
			//this.color=0;
			//this.borderColor=NaN;
			//this.borderWidth=NaN;
			//this.round=0;
			this.fill=true;
			this.r1=Math.PI / 2;
			(round===void 0)&& (round=0);
			this.x=x;
			this.y=y;
			this.width=width;
			this.height=height;
			this.edges=edges;
			this.color=color;
			this.borderWidth=borderWidth;
			this.borderColor=borderColor;
		}

		__class(BasePoly,'laya.webgl.shapes.BasePoly');
		var __proto=BasePoly.prototype;
		Laya.imps(__proto,{"laya.webgl.shapes.IShape":true})
		__proto.getData=function(ib,vb,start){}
		__proto.sector=function(outVert,outIndex,start){
			var x=this.x,y=this.y,edges=this.edges,seg=(this.r1-this.r0)/ edges;
			var w=this.width,h=this.height,color=this.color;
			var r=((color >> 16)& 0x0000ff)/ 255,g=((color >> 8)& 0xff)/ 255,b=(color & 0x0000ff)/ 255;
			outVert.push(x,y,r,g,b);
			for (var i=0;i < edges+1;i++){
				outVert.push(x+Math.sin(seg *i+this.r0)*w,y+Math.cos(seg *i+this.r0)*h);
				outVert.push(r,g,b);
			}
			for (i=0;i < edges;i++){
				outIndex.push(start,start+i+1,start+i+2);
			}
		}

		//用于画线
		__proto.createLine2=function(p,indices,lineWidth,len,outVertex,indexCount){
			var points=p.concat();
			var result=outVertex;
			var color=this.borderColor;
			var r=((color >> 16)& 0x0000ff)/ 255,g=((color >> 8)& 0xff)/ 255,b=(color & 0x0000ff)/ 255;
			var length=points.length / 2;
			var iStart=len,w=lineWidth / 2;
			var px,py,p1x,p1y,p2x,p2y,p3x,p3y;
			var perpx,perpy,perp2x,perp2y,perp3x,perp3y;
			var a1,b1,c1,a2,b2,c2;
			var denom,pdist,dist;
			p1x=points[0];
			p1y=points[1];
			p2x=points[2];
			p2y=points[3];
			perpx=-(p1y-p2y);
			perpy=p1x-p2x;
			dist=Math.sqrt(perpx *perpx+perpy *perpy);
			perpx=perpx / dist *w;
			perpy=perpy / dist *w;
			result.push(p1x-perpx+this.x,p1y-perpy+this.y,r,g,b,p1x+perpx+this.x,p1y+perpy+this.y,r,g,b);
			for (var i=1;i < length-1;i++){
				p1x=points[(i-1)*2];
				p1y=points[(i-1)*2+1];
				p2x=points[(i)*2];
				p2y=points[(i)*2+1];
				p3x=points[(i+1)*2];
				p3y=points[(i+1)*2+1];
				perpx=-(p1y-p2y);
				perpy=p1x-p2x;
				dist=Math.sqrt(perpx *perpx+perpy *perpy);
				perpx=perpx / dist *w;
				perpy=perpy / dist *w;
				perp2x=-(p2y-p3y);
				perp2y=p2x-p3x;
				dist=Math.sqrt(perp2x *perp2x+perp2y *perp2y);
				perp2x=perp2x / dist *w;
				perp2y=perp2y / dist *w;
				a1=(-perpy+p1y)-(-perpy+p2y);
				b1=(-perpx+p2x)-(-perpx+p1x);
				c1=(-perpx+p1x)*(-perpy+p2y)-(-perpx+p2x)*(-perpy+p1y);
				a2=(-perp2y+p3y)-(-perp2y+p2y);
				b2=(-perp2x+p2x)-(-perp2x+p3x);
				c2=(-perp2x+p3x)*(-perp2y+p2y)-(-perp2x+p2x)*(-perp2y+p3y);
				denom=a1 *b2-a2 *b1;
				if (Math.abs(denom)< 0.1){
					denom+=10.1;
					result.push(p2x-perpx+this.x,p2y-perpy+this.y,r,g,b,p2x+perpx+this.x,p2y+perpy+this.y,r,g,b);
					continue ;
				}
				px=(b1 *c2-b2 *c1)/ denom;
				py=(a2 *c1-a1 *c2)/ denom;
				pdist=(px-p2x)*(px-p2x)+(py-p2y)+(py-p2y);
				result.push(px+this.x,py+this.y,r,g,b,p2x-(px-p2x)+this.x,p2y-(py-p2y)+this.y,r,g,b);
			}
			p1x=points[points.length-4];
			p1y=points[points.length-3];
			p2x=points[points.length-2];
			p2y=points[points.length-1];
			perpx=-(p1y-p2y);
			perpy=p1x-p2x;
			dist=Math.sqrt(perpx *perpx+perpy *perpy);
			perpx=perpx / dist *w;
			perpy=perpy / dist *w;
			result.push(p2x-perpx+this.x,p2y-perpy+this.y,r,g,b,p2x+perpx+this.x,p2y+perpy+this.y,r,g,b);
			var groupLen=indexCount;
			for (i=1;i < groupLen;i++){
				indices.push(iStart+(i-1)*2,iStart+(i-1)*2+1,iStart+i *2+1,iStart+i *2+1,iStart+i *2,iStart+(i-1)*2);
			}
			return result;
		}

		//用于比如 扇形 不带两直线
		__proto.createLine=function(p,indices,lineWidth,len){
			var points=p.concat();
			var result=p;
			var color=this.borderColor;
			var r=((color >> 16)& 0x0000ff)/ 255,g=((color >> 8)& 0xff)/ 255,b=(color & 0x0000ff)/ 255;
			points.splice(0,5);
			var length=points.length / 5;
			var iStart=len,w=lineWidth / 2;
			var px,py,p1x,p1y,p2x,p2y,p3x,p3y;
			var perpx,perpy,perp2x,perp2y,perp3x,perp3y;
			var a1,b1,c1,a2,b2,c2;
			var denom,pdist,dist;
			p1x=points[0];
			p1y=points[1];
			p2x=points[5];
			p2y=points[6];
			perpx=-(p1y-p2y);
			perpy=p1x-p2x;
			dist=Math.sqrt(perpx *perpx+perpy *perpy);
			perpx=perpx / dist *w;
			perpy=perpy / dist *w;
			result.push(p1x-perpx,p1y-perpy,r,g,b,p1x+perpx,p1y+perpy,r,g,b);
			for (var i=1;i < length-1;i++){
				p1x=points[(i-1)*5];
				p1y=points[(i-1)*5+1];
				p2x=points[(i)*5];
				p2y=points[(i)*5+1];
				p3x=points[(i+1)*5];
				p3y=points[(i+1)*5+1];
				perpx=-(p1y-p2y);
				perpy=p1x-p2x;
				dist=Math.sqrt(perpx *perpx+perpy *perpy);
				perpx=perpx / dist *w;
				perpy=perpy / dist *w;
				perp2x=-(p2y-p3y);
				perp2y=p2x-p3x;
				dist=Math.sqrt(perp2x *perp2x+perp2y *perp2y);
				perp2x=perp2x / dist *w;
				perp2y=perp2y / dist *w;
				a1=(-perpy+p1y)-(-perpy+p2y);
				b1=(-perpx+p2x)-(-perpx+p1x);
				c1=(-perpx+p1x)*(-perpy+p2y)-(-perpx+p2x)*(-perpy+p1y);
				a2=(-perp2y+p3y)-(-perp2y+p2y);
				b2=(-perp2x+p2x)-(-perp2x+p3x);
				c2=(-perp2x+p3x)*(-perp2y+p2y)-(-perp2x+p2x)*(-perp2y+p3y);
				denom=a1 *b2-a2 *b1;
				if (Math.abs(denom)< 0.1){
					denom+=10.1;
					result.push(p2x-perpx,p2y-perpy,r,g,b,p2x+perpx,p2y+perpy,r,g,b);
					continue ;
				}
				px=(b1 *c2-b2 *c1)/ denom;
				py=(a2 *c1-a1 *c2)/ denom;
				pdist=(px-p2x)*(px-p2x)+(py-p2y)+(py-p2y);
				result.push(px,py,r,g,b,p2x-(px-p2x),p2y-(py-p2y),r,g,b);
			}
			p1x=points[points.length-10];
			p1y=points[points.length-9];
			p2x=points[points.length-5];
			p2y=points[points.length-4];
			perpx=-(p1y-p2y);
			perpy=p1x-p2x;
			dist=Math.sqrt(perpx *perpx+perpy *perpy);
			perpx=perpx / dist *w;
			perpy=perpy / dist *w;
			result.push(p2x-perpx,p2y-perpy,r,g,b,p2x+perpx,p2y+perpy,r,g,b);
			var groupLen=this.edges+1;
			for (i=1;i < groupLen;i++){
				indices.push(iStart+(i-1)*2,iStart+(i-1)*2+1,iStart+i *2+1,iStart+i *2+1,iStart+i *2,iStart+(i-1)*2);
			}
			return result;
		}

		//闭合路径
		__proto.createLoopLine=function(p,indices,lineWidth,len,outVertex,outIndex){
			var points=p.concat();
			var result=outVertex ? outVertex :p;
			var color=this.borderColor;
			var r=((color >> 16)& 0x0000ff)/ 255,g=((color >> 8)& 0xff)/ 255,b=(color & 0x0000ff)/ 255;
			points.splice(0,5);
			var firstPoint=[points[0],points[1]];
			var lastPoint=[points[points.length-5],points[points.length-4]];
			var midPointX=lastPoint[0]+(firstPoint[0]-lastPoint[0])*0.5;
			var midPointY=lastPoint[1]+(firstPoint[1]-lastPoint[1])*0.5;
			points.unshift(midPointX,midPointY,0,0,0);
			points.push(midPointX,midPointY,0,0,0);
			var length=points.length / 5;
			var iStart=len,w=lineWidth / 2;
			var px,py,p1x,p1y,p2x,p2y,p3x,p3y;
			var perpx,perpy,perp2x,perp2y,perp3x,perp3y;
			var a1,b1,c1,a2,b2,c2;
			var denom,pdist,dist;
			p1x=points[0];
			p1y=points[1];
			p2x=points[5];
			p2y=points[6];
			perpx=-(p1y-p2y);
			perpy=p1x-p2x;
			dist=Math.sqrt(perpx *perpx+perpy *perpy);
			perpx=perpx / dist *w;
			perpy=perpy / dist *w;
			result.push(p1x-perpx,p1y-perpy,r,g,b,p1x+perpx,p1y+perpy,r,g,b);
			for (var i=1;i < length-1;i++){
				p1x=points[(i-1)*5];
				p1y=points[(i-1)*5+1];
				p2x=points[(i)*5];
				p2y=points[(i)*5+1];
				p3x=points[(i+1)*5];
				p3y=points[(i+1)*5+1];
				perpx=-(p1y-p2y);
				perpy=p1x-p2x;
				dist=Math.sqrt(perpx *perpx+perpy *perpy);
				perpx=perpx / dist *w;
				perpy=perpy / dist *w;
				perp2x=-(p2y-p3y);
				perp2y=p2x-p3x;
				dist=Math.sqrt(perp2x *perp2x+perp2y *perp2y);
				perp2x=perp2x / dist *w;
				perp2y=perp2y / dist *w;
				a1=(-perpy+p1y)-(-perpy+p2y);
				b1=(-perpx+p2x)-(-perpx+p1x);
				c1=(-perpx+p1x)*(-perpy+p2y)-(-perpx+p2x)*(-perpy+p1y);
				a2=(-perp2y+p3y)-(-perp2y+p2y);
				b2=(-perp2x+p2x)-(-perp2x+p3x);
				c2=(-perp2x+p3x)*(-perp2y+p2y)-(-perp2x+p2x)*(-perp2y+p3y);
				denom=a1 *b2-a2 *b1;
				if (Math.abs(denom)< 0.1){
					denom+=10.1;
					result.push(p2x-perpx,p2y-perpy,r,g,b,p2x+perpx,p2y+perpy,r,g,b);
					continue ;
				}
				px=(b1 *c2-b2 *c1)/ denom;
				py=(a2 *c1-a1 *c2)/ denom;
				pdist=(px-p2x)*(px-p2x)+(py-p2y)+(py-p2y);
				result.push(px,py,r,g,b,p2x-(px-p2x),p2y-(py-p2y),r,g,b);
			}
			if (outIndex){
				indices=outIndex;
			};
			var groupLen=this.edges+1;
			for (i=1;i < groupLen;i++){
				indices.push(iStart+(i-1)*2,iStart+(i-1)*2+1,iStart+i *2+1,iStart+i *2+1,iStart+i *2,iStart+(i-1)*2);
			}
			indices.push(iStart+(i-1)*2,iStart+(i-1)*2+1,iStart+1,iStart+1,iStart,iStart+(i-1)*2);
			return result;
		}

		return BasePoly;
	})()


	//class laya.webgl.submit.Submit
	var Submit=(function(){
		function Submit(renderType){
			//this._selfVb=null;
			//this._ib=null;
			//this._blendFn=null;
			//this._renderType=0;
			//this._vb=null;
			//this._startIdx=0;
			//this._numEle=0;
			//this.shaderValue=null;
			(renderType===void 0)&& (renderType=1);
			this._renderType=renderType;
		}

		__class(Submit,'laya.webgl.submit.Submit');
		var __proto=Submit.prototype;
		Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
		__proto.releaseRender=function(){
			var cache=Submit._cache;
			cache[cache._length++]=this;
			this.shaderValue.release();
			this._vb=null;
		}

		__proto.getRenderType=function(){
			return this._renderType;
		}

		__proto.renderSubmit=function(){
			if (this._numEle===0)return 1;
			var _tex=this.shaderValue.textureHost;
			if (_tex){
				var source=_tex.source;
				if (!_tex.bitmap || !source)
					return 1;
				this.shaderValue.texture=source;
			}
			this._vb.bind_upload(this._ib);
			var gl=WebGL.mainContext;
			this.shaderValue.upload();
			if (BlendMode.activeBlendFunction!==this._blendFn){
				gl.enable(0x0BE2);
				this._blendFn(gl);
				BlendMode.activeBlendFunction=this._blendFn;
			}
			Stat.drawCall++;
			Stat.trianglesFaces+=this._numEle / 3;
			gl.drawElements(0x0004,this._numEle,0x1403,this._startIdx);
			return 1;
		}

		Submit.__init__=function(){
			var s=Submit.RENDERBASE=new Submit(-1);
			s.shaderValue=new Value2D(0,0);
			s.shaderValue.ALPHA=-1234;
		}

		Submit.create=function(context,ib,vb,pos,sv){
			var o=Submit._cache._length ? Submit._cache[--Submit._cache._length] :new Submit();
			if (vb==null){
				vb=o._selfVb || (o._selfVb=VertexBuffer2D.create(-1));
				vb.clear();
				pos=0;
			}
			o._ib=ib;
			o._vb=vb;
			o._startIdx=pos *CONST3D2D.BYTES_PIDX;
			o._numEle=0;
			var blendType=context._nBlendType;
			o._blendFn=context._targets ? BlendMode.targetFns[blendType] :BlendMode.fns[blendType];
			o.shaderValue=sv;
			o.shaderValue.setValue(context._shader2D);
			var filters=context._shader2D.filters;
			filters && o.shaderValue.setFilters(filters);
			return o;
		}

		Submit.createShape=function(ctx,ib,vb,numEle,offset,sv){
			var o=(!Submit._cache._length)? (new Submit()):Submit._cache[--Submit._cache._length];
			o._ib=ib;
			o._vb=vb;
			o._numEle=numEle;
			o._startIdx=offset;
			o.shaderValue=sv;
			o.shaderValue.setValue(ctx._shader2D);
			var blendType=ctx._nBlendType;
			o._blendFn=ctx._targets ? BlendMode.targetFns[blendType] :BlendMode.fns[blendType];
			return o;
		}

		Submit.TYPE_2D=1;
		Submit.TYPE_CANVAS=3;
		Submit.TYPE_CMDSETRT=4;
		Submit.TYPE_CUSTOM=5;
		Submit.TYPE_BLURRT=6;
		Submit.TYPE_CMDDESTORYPRERT=7;
		Submit.TYPE_DISABLESTENCIL=8;
		Submit.TYPE_OTHERIBVB=9;
		Submit.TYPE_PRIMITIVE=10;
		Submit.TYPE_RT=11;
		Submit.TYPE_BLUR_RT=12;
		Submit.TYPE_TARGET=13;
		Submit.TYPE_CHANGE_VALUE=14;
		Submit.TYPE_SHAPE=15;
		Submit.TYPE_TEXTURE=16;
		Submit.RENDERBASE=null
		Submit._cache=(Submit._cache=[],Submit._cache._length=0,Submit._cache);
		return Submit;
	})()


	//class laya.webgl.submit.SubmitCMD
	var SubmitCMD=(function(){
		function SubmitCMD(){
			this.fun=null;
			this.args=null;
		}

		__class(SubmitCMD,'laya.webgl.submit.SubmitCMD');
		var __proto=SubmitCMD.prototype;
		Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
		__proto.renderSubmit=function(){
			this.fun.apply(null,this.args);
			return 1;
		}

		__proto.getRenderType=function(){
			return 0;
		}

		__proto.releaseRender=function(){
			var cache=SubmitCMD._cache;
			cache[cache._length++]=this;
		}

		SubmitCMD.create=function(args,fun){
			var o=SubmitCMD._cache._length?SubmitCMD._cache[--SubmitCMD._cache._length]:new SubmitCMD();
			o.fun=fun;
			o.args=args;
			return o;
		}

		SubmitCMD._cache=(SubmitCMD._cache=[],SubmitCMD._cache._length=0,SubmitCMD._cache);
		return SubmitCMD;
	})()


	//class laya.webgl.submit.SubmitCMDScope
	var SubmitCMDScope=(function(){
		function SubmitCMDScope(){
			this.variables={};
		}

		__class(SubmitCMDScope,'laya.webgl.submit.SubmitCMDScope');
		var __proto=SubmitCMDScope.prototype;
		__proto.getValue=function(name){
			return this.variables[name];
		}

		__proto.addValue=function(name,value){
			return this.variables[name]=value;
		}

		__proto.setValue=function(name,value){
			if(this.variables.hasOwnProperty(name)){
				return this.variables[name]=value;
			}
			return null;
		}

		__proto.clear=function(){
			for(var key in this.variables){
				delete this.variables[key];
			}
		}

		__proto.recycle=function(){
			this.clear();
			SubmitCMDScope.POOL.push(this);
		}

		SubmitCMDScope.create=function(){
			var scope=SubmitCMDScope.POOL.pop();
			scope||(scope=new SubmitCMDScope());
			return scope;
		}

		SubmitCMDScope.POOL=[];
		return SubmitCMDScope;
	})()


	//class laya.webgl.submit.SubmitOtherIBVB
	var SubmitOtherIBVB=(function(){
		function SubmitOtherIBVB(){
			this.offset=0;
			//this._vb=null;
			//this._ib=null;
			//this._blendFn=null;
			//this._mat=null;
			//this._shader=null;
			//this._shaderValue=null;
			//this._numEle=0;
			this.startIndex=0;
			;
			this._mat=Matrix.create();
		}

		__class(SubmitOtherIBVB,'laya.webgl.submit.SubmitOtherIBVB');
		var __proto=SubmitOtherIBVB.prototype;
		Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
		__proto.releaseRender=function(){
			var cache=SubmitOtherIBVB._cache;
			cache[cache._length++]=this;
		}

		__proto.getRenderType=function(){
			return 9;
		}

		__proto.renderSubmit=function(){
			var _tex=this._shaderValue.textureHost;
			if (_tex){
				var source=_tex.source;
				if (!_tex.bitmap || !source)
					return 1;
				this._shaderValue.texture=source;
			}
			this._vb.bind_upload(this._ib);
			var w=RenderState2D.worldMatrix4;
			var wmat=Matrix.TEMP;
			Matrix.mulPre(this._mat,w[0],w[1],w[4],w[5],w[12],w[13],wmat);
			var tmp=RenderState2D.worldMatrix4=SubmitOtherIBVB.tempMatrix4;
			tmp[0]=wmat.a;
			tmp[1]=wmat.b;
			tmp[4]=wmat.c;
			tmp[5]=wmat.d;
			tmp[12]=wmat.tx;
			tmp[13]=wmat.ty;
			this._shader._offset=this.offset;
			this._shaderValue.refresh();
			this._shader.upload(this._shaderValue);
			this._shader._offset=0;
			var gl=WebGL.mainContext;
			if (BlendMode.activeBlendFunction!==this._blendFn){
				gl.enable(0x0BE2);
				this._blendFn(gl);
				BlendMode.activeBlendFunction=this._blendFn;
			}
			Stat.drawCall++;
			Stat.trianglesFaces+=this._numEle / 3;
			gl.drawElements(0x0004,this._numEle,0x1403,this.startIndex);
			RenderState2D.worldMatrix4=w;
			Shader.activeShader=null;
			return 1;
		}

		SubmitOtherIBVB.create=function(context,vb,ib,numElement,shader,shaderValue,startIndex,offset,type){
			(type===void 0)&& (type=0);
			var o=(!SubmitOtherIBVB._cache._length)? (new SubmitOtherIBVB()):SubmitOtherIBVB._cache[--SubmitOtherIBVB._cache._length];
			o._ib=ib;
			o._vb=vb;
			o._numEle=numElement;
			o._shader=shader;
			o._shaderValue=shaderValue;
			var blendType=context._nBlendType;
			o._blendFn=context._targets ? BlendMode.targetFns[blendType] :BlendMode.fns[blendType];
			switch(type){
				case 0:
					o.offset=0;
					o.startIndex=offset / (CONST3D2D.BYTES_PE *vb.vertexStride)*1.5;
					o.startIndex *=CONST3D2D.BYTES_PIDX;
					break ;
				case 1:
					o.startIndex=startIndex;
					o.offset=offset;
					break ;
				}
			return o;
		}

		SubmitOtherIBVB._cache=(SubmitOtherIBVB._cache=[],SubmitOtherIBVB._cache._length=0,SubmitOtherIBVB._cache);
		SubmitOtherIBVB.tempMatrix4=[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,];
		return SubmitOtherIBVB;
	})()


	//class laya.webgl.submit.SubmitScissor
	var SubmitScissor=(function(){
		function SubmitScissor(){
			this.submitIndex=0;
			this.submitLength=0;
			this.context=null;
			this.clipRect=new Rectangle();
			this.screenRect=new Rectangle();
		}

		__class(SubmitScissor,'laya.webgl.submit.SubmitScissor');
		var __proto=SubmitScissor.prototype;
		Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
		__proto._scissor=function(x,y,w,h){
			var m=RenderState2D.worldMatrix4;
			var a=m[0],d=m[5],tx=m[12],ty=m[13];
			x=x *a+tx;
			y=y *d+ty;
			w *=a;
			h *=d;
			if (w < 1 || h < 1){
				return false;
			};
			var r=x+w;
			var b=y+h;
			x < 0 && (x=0,w=r-x);
			y < 0 && (y=0,h=b-y);
			var screen=RenderState2D.worldClipRect;
			x=Math.max(x,screen.x);
			y=Math.max(y,screen.y);
			w=Math.min(r,screen.right)-x;
			h=Math.min(b,screen.bottom)-y;
			if (w < 1 || h < 1){
				return false;
			};
			var worldScissorTest=RenderState2D.worldScissorTest;
			this.screenRect.copyFrom(screen);
			screen.x=x;
			screen.y=y;
			screen.width=w;
			screen.height=h;
			RenderState2D.worldScissorTest=true;
			y=RenderState2D.height-y-h;
			WebGL.mainContext.scissor(x,y,w,h);
			WebGL.mainContext.enable(0x0C11);
			this.context.submitElement(this.submitIndex,this.submitIndex+this.submitLength);
			if (worldScissorTest){
				y=RenderState2D.height-this.screenRect.y-this.screenRect.height;
				WebGL.mainContext.scissor(this.screenRect.x,y,this.screenRect.width,this.screenRect.height);
				WebGL.mainContext.enable(0x0C11);
			}
			else{
				WebGL.mainContext.disable(0x0C11);
				RenderState2D.worldScissorTest=false;
			}
			screen.copyFrom(this.screenRect);
			return true;
		}

		__proto._scissorWithTagart=function(x,y,w,h){
			if (w < 1 || h < 1){
				return false;
			};
			var r=x+w;
			var b=y+h;
			x < 0 && (x=0,w=r-x);
			y < 0 && (y=0,h=b-y);
			var screen=RenderState2D.worldClipRect;
			x=Math.max(x,screen.x);
			y=Math.max(y,screen.y);
			w=Math.min(r,screen.right)-x;
			h=Math.min(b,screen.bottom)-y;
			if (w < 1 || h < 1){
				return false;
			};
			var worldScissorTest=RenderState2D.worldScissorTest;
			this.screenRect.copyFrom(screen);
			RenderState2D.worldScissorTest=true;
			screen.x=x;
			screen.y=y;
			screen.width=w;
			screen.height=h;
			y=RenderState2D.height-y-h;
			WebGL.mainContext.scissor(x,y,w,h);
			WebGL.mainContext.enable(0x0C11);
			this.context.submitElement(this.submitIndex,this.submitIndex+this.submitLength);
			if (worldScissorTest){
				y=RenderState2D.height-this.screenRect.y-this.screenRect.height;
				WebGL.mainContext.scissor(this.screenRect.x,y,this.screenRect.width,this.screenRect.height);
				WebGL.mainContext.enable(0x0C11);
			}
			else{
				WebGL.mainContext.disable(0x0C11);
				RenderState2D.worldScissorTest=false;
			}
			screen.copyFrom(this.screenRect);
			return true;
		}

		__proto.renderSubmit=function(){
			this.submitLength=Math.min(this.context._submits._length-1,this.submitLength);
			if (this.submitLength < 1 || this.clipRect.width < 1 || this.clipRect.height < 1)
				return this.submitLength+1;
			if (this.context._targets)
				this._scissorWithTagart(this.clipRect.x,this.clipRect.y,this.clipRect.width,this.clipRect.height);
			else this._scissor(this.clipRect.x,this.clipRect.y,this.clipRect.width,this.clipRect.height);
			return this.submitLength+1;
		}

		__proto.getRenderType=function(){
			return 0;
		}

		__proto.releaseRender=function(){
			var cache=SubmitScissor._cache;
			cache[cache._length++]=this;
			this.context=null;
		}

		SubmitScissor.create=function(context){
			var o=SubmitScissor._cache._length?SubmitScissor._cache[--SubmitScissor._cache._length]:new SubmitScissor();
			o.context=context;
			return o;
		}

		SubmitScissor._cache=(SubmitScissor._cache=[],SubmitScissor._cache._length=0,SubmitScissor._cache);
		return SubmitScissor;
	})()


	//class laya.webgl.submit.SubmitStencil
	var SubmitStencil=(function(){
		function SubmitStencil(){
			this.step=0;
			this.blendMode=null;
			this.level=0;
		}

		__class(SubmitStencil,'laya.webgl.submit.SubmitStencil');
		var __proto=SubmitStencil.prototype;
		Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
		__proto.renderSubmit=function(){
			switch(this.step){
				case 1:
					this.do1();
					break ;
				case 2:
					this.do2();
					break ;
				case 3:
					this.do3();
					break ;
				case 4:
					this.do4();
					break ;
				case 5:
					this.do5();
					break ;
				case 6:
					this.do6();
					break ;
				}
			return 1;
		}

		__proto.getRenderType=function(){
			return 0;
		}

		__proto.releaseRender=function(){
			var cache=SubmitStencil._cache;
			cache[cache._length++]=this;
		}

		__proto.do1=function(){
			var gl=WebGL.mainContext;
			gl.enable(0x0B90);
			gl.clear(0x00000400);
			gl.colorMask(false,false,false,false);
			gl.stencilFunc(0x0202,this.level,0xFF);
			gl.stencilOp(0x1E00,0x1E00,0x1E02);
		}

		//gl.stencilOp(WebGLContext.KEEP,WebGLContext.KEEP,WebGLContext.INVERT);//测试通过给模版缓冲 写入值 一开始是0 现在是 0xFF (模版缓冲中不知道是多少位的数据)
		__proto.do2=function(){
			var gl=WebGL.mainContext;
			gl.stencilFunc(0x0202,this.level+1,0xFF);
			gl.colorMask(true,true,true,true);
			gl.stencilOp(0x1E00,0x1E00,0x1E00);
		}

		__proto.do3=function(){
			var gl=WebGL.mainContext;
			gl.colorMask(true,true,true,true);
			gl.stencilOp(0x1E00,0x1E00,0x1E00);
			gl.clear(0x00000400);
			gl.disable(0x0B90);
		}

		__proto.do4=function(){
			var gl=WebGL.mainContext;
			gl.enable(0x0B90);
			gl.clear(0x00000400);
			gl.colorMask(false,false,false,false);
			gl.stencilFunc(0x0207,this.level,0xFF);
			gl.stencilOp(0x1E00,0x1E00,0x150A);
		}

		__proto.do5=function(){
			var gl=WebGL.mainContext;
			gl.stencilFunc(0x0202,0xff,0xFF);
			gl.colorMask(true,true,true,true);
			gl.stencilOp(0x1E00,0x1E00,0x1E00);
		}

		__proto.do6=function(){
			var gl=WebGL.mainContext;
			BlendMode.targetFns[BlendMode.TOINT[this.blendMode]](gl);
		}

		SubmitStencil.create=function(step){
			var o=SubmitStencil._cache._length?SubmitStencil._cache[--SubmitStencil._cache._length]:new SubmitStencil();
			o.step=step;
			return o;
		}

		SubmitStencil._cache=(SubmitStencil._cache=[],SubmitStencil._cache._length=0,SubmitStencil._cache);
		return SubmitStencil;
	})()


	//class laya.webgl.submit.SubmitTarget
	var SubmitTarget=(function(){
		function SubmitTarget(){
			this._renderType=0;
			this._vb=null;
			this._ib=null;
			this._startIdx=0;
			this._numEle=0;
			this.shaderValue=null;
			this.blendType=0;
			this.proName=null;
			this.scope=null;
		}

		__class(SubmitTarget,'laya.webgl.submit.SubmitTarget');
		var __proto=SubmitTarget.prototype;
		Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
		__proto.renderSubmit=function(){
			this._vb.bind_upload(this._ib);
			var target=this.scope.getValue(this.proName);
			if (target){
				this.shaderValue.texture=target.source;
				this.shaderValue.upload();
				this.blend();
				Stat.drawCall++;
				Stat.trianglesFaces+=this._numEle/3;
				WebGL.mainContext.drawElements(0x0004,this._numEle,0x1403,this._startIdx);
			}
			return 1;
		}

		__proto.blend=function(){
			if (BlendMode.activeBlendFunction!==BlendMode.fns[this.blendType]){
				var gl=WebGL.mainContext;
				gl.enable(0x0BE2);
				BlendMode.fns[this.blendType](gl);
				BlendMode.activeBlendFunction=BlendMode.fns[this.blendType];
			}
		}

		__proto.getRenderType=function(){
			return 0;
		}

		__proto.releaseRender=function(){
			var cache=SubmitTarget._cache;
			cache[cache._length++]=this;
		}

		SubmitTarget.create=function(context,ib,vb,pos,sv,proName){
			var o=SubmitTarget._cache._length?SubmitTarget._cache[--SubmitTarget._cache._length]:new SubmitTarget();
			o._ib=ib;
			o._vb=vb;
			o.proName=proName;
			o._startIdx=pos *CONST3D2D.BYTES_PIDX;
			o._numEle=0;
			o.blendType=context._nBlendType;
			o.shaderValue=sv;
			o.shaderValue.setValue(context._shader2D);
			return o;
		}

		SubmitTarget._cache=(SubmitTarget._cache=[],SubmitTarget._cache._length=0,SubmitTarget._cache);
		return SubmitTarget;
	})()


	/**
	*...特殊的字符，如泰文，必须重新实现这个类
	*/
	//class laya.webgl.text.CharSegment
	var CharSegment=(function(){
		function CharSegment(){
			this._sourceStr=null;
		}

		__class(CharSegment,'laya.webgl.text.CharSegment');
		var __proto=CharSegment.prototype;
		Laya.imps(__proto,{"laya.webgl.text.ICharSegment":true})
		__proto.textToSpit=function(str){
			this._sourceStr=str;
		}

		__proto.getChar=function(i){
			return this._sourceStr.charAt(i);
		}

		__proto.getCharCode=function(i){
			return this._sourceStr.charCodeAt(i);
		}

		__proto.length=function(){
			return this._sourceStr.length;
		}

		return CharSegment;
	})()


	//class laya.webgl.text.DrawText
	var DrawText=(function(){
		var CharValue;
		function DrawText(){};
		__class(DrawText,'laya.webgl.text.DrawText');
		DrawText.__init__=function(){
			DrawText._charsTemp=new Array;
			DrawText._drawValue=new CharValue();
			DrawText._charSeg=new CharSegment();
		}

		DrawText.customCharSeg=function(charseg){
			DrawText._charSeg=charseg;
		}

		DrawText.getChar=function(char,id,drawValue){
			return DrawText._charsCache[id]=DrawTextChar.createOneChar(char,drawValue);
		}

		DrawText._drawSlow=function(save,ctx,txt,words,curMat,font,textAlign,fillColor,borderColor,lineWidth,x,y,sx,sy){
			var drawValue=DrawText._drawValue.value(font,fillColor,borderColor,lineWidth,sx,sy);
			var i=0,n=0;
			var chars=DrawText._charsTemp;
			var width=0,oneChar,htmlWord,id=NaN;
			if (words){
				chars.length=words.length;
				for (i=0,n=words.length;i < n;i++){
					htmlWord=words[i];
					id=htmlWord.charNum+drawValue.txtID;
					chars[i]=oneChar=DrawText._charsCache[id] || DrawText.getChar(htmlWord.char,id,drawValue);
					oneChar.active();
				}
				}else {
				if ((txt instanceof laya.utils.WordText ))
					DrawText._charSeg.textToSpit((txt).toString());
				else
				DrawText._charSeg.textToSpit(txt);
				var len=/*if err,please use iflash.method.xmlLength()*/DrawText._charSeg.length();
				chars.length=len;
				for (i=0,n=len;i < n;i++){
					id=DrawText._charSeg.getCharCode(i)+drawValue.txtID;
					chars[i]=oneChar=DrawText._charsCache[id] || DrawText.getChar(DrawText._charSeg.getChar(i),id,drawValue);
					oneChar.active();
					width+=oneChar.width;
				}
			};
			var dx=0;
			if (textAlign!==null && textAlign!=="left")
				dx=-(textAlign=="center" ? (width / 2):width);
			var uv,bdSz=NaN,texture,value,saveLength=0;
			if (words){
				for (i=0,n=chars.length;i < n;i++){
					oneChar=chars[i];
					if (!oneChar.isSpace){
						htmlWord=words[i];
						bdSz=oneChar.borderSize;
						texture=oneChar.texture;
						ctx._drawText(texture,x+dx+htmlWord.x *sx-bdSz,y+htmlWord.y *sy-bdSz,texture.width,texture.height,curMat,0,0,0,0);
					}
				}
				}else {
				for (i=0,n=chars.length;i < n;i++){
					oneChar=chars[i];
					if (!oneChar.isSpace){
						bdSz=oneChar.borderSize;
						texture=oneChar.texture;
						ctx._drawText(texture,x+dx-bdSz,y-bdSz,texture.width,texture.height,curMat,0,0,0,0);
						save && (value=save[saveLength++],value || (value=save[saveLength-1]=[]),value[0]=texture,value[1]=dx-bdSz,value[2]=-bdSz);
					}
					dx+=oneChar.width;
				}
				save && (save.length=saveLength);
			}
		}

		DrawText._drawFast=function(save,ctx,curMat,x,y){
			var texture,value;
			for (var i=0,n=save.length;i < n;i++){
				value=save[i];
				texture=value[0];
				texture.active();
				ctx._drawText(texture,x+value[1],y+value[2],texture.width,texture.height,curMat,0,0,0,0);
			}
		}

		DrawText.drawText=function(ctx,txt,words,curMat,font,textAlign,fillColor,borderColor,lineWidth,x,y){
			if ((txt && txt.length===0)|| (words && words.length===0))
				return;
			var sx=curMat.a,sy=curMat.d;
			(curMat.b!==0 || curMat.c!==0)&& (sx=sy=1);
			var scale=sx!==1 || sy!==1;
			if (scale && Laya.stage.transform){
				var t=Laya.stage.transform;
				scale=t.a===sx && t.d===sy;
			}else scale=false;
			if (scale){
				curMat=curMat.copyTo(WebGLContext2D._tmpMatrix);
				curMat.scale(1 / sx,1 / sy);
				curMat._checkTransform();
				x *=sx;
				y *=sy;
			}else sx=sy=1;
			if (words){
				DrawText._drawSlow(null,ctx,txt,words,curMat,font,textAlign,fillColor,borderColor,lineWidth,x,y,sx,sy);
				}else {
				if (txt.toUpperCase===null){
					var idNum=sx+sy *100000;
					var myCache=txt;
					if (!myCache.changed && myCache.id===idNum){
						DrawText._drawFast(myCache.save,ctx,curMat,x,y);
						}else {
						myCache.id=idNum;
						myCache.changed=false;
						DrawText._drawSlow(myCache.save,ctx,txt,words,curMat,font,textAlign,fillColor,borderColor,lineWidth,x,y,sx,sy);
					}
					return;
				};
				var id=txt+font.toString()+fillColor+borderColor+lineWidth+sx+sy+textAlign;
				var cache=DrawText._textsCache[id];
				if (cache){
					DrawText._drawFast(cache,ctx,curMat,x,y);
					}else {
					DrawText._textsCache.__length || (DrawText._textsCache.__length=0);
					if (DrawText._textsCache.__length > Config.WebGLTextCacheCount){
						DrawText._textsCache={};
						DrawText._textsCache.__length=0;
						DrawText._curPoolIndex=0;
					}
					DrawText._textCachesPool[DrawText._curPoolIndex] ? (cache=DrawText._textsCache[id]=DrawText._textCachesPool[DrawText._curPoolIndex],cache.length=0):(DrawText._textCachesPool[DrawText._curPoolIndex]=cache=DrawText._textsCache[id]=[]);
					DrawText._textsCache.__length++
					DrawText._curPoolIndex++;
					DrawText._drawSlow(cache,ctx,txt,words,curMat,font,textAlign,fillColor,borderColor,lineWidth,x,y,sx,sy);
				}
			}
		}

		DrawText._charsTemp=null
		DrawText._textCachesPool=[];
		DrawText._curPoolIndex=0;
		DrawText._charsCache={};
		DrawText._textsCache={};
		DrawText._drawValue=null
		DrawText.d=[];
		DrawText._charSeg=null;
		DrawText.__init$=function(){
			//class CharValue
			CharValue=(function(){
				function CharValue(){
					//this.txtID=NaN;
					//this.font=null;
					//this.fillColor=null;
					//this.borderColor=null;
					//this.lineWidth=0;
					//this.scaleX=NaN;
					//this.scaleY=NaN;
				}
				__class(CharValue,'');
				var __proto=CharValue.prototype;
				__proto.value=function(font,fillColor,borderColor,lineWidth,scaleX,scaleY){
					this.font=font;
					this.fillColor=fillColor;
					this.borderColor=borderColor;
					this.lineWidth=lineWidth;
					this.scaleX=scaleX;
					this.scaleY=scaleY;
					var key=font.toString()+scaleX+scaleY+lineWidth+fillColor+borderColor;
					this.txtID=CharValue._keymap[key];
					if (!this.txtID){
						this.txtID=(++CharValue._keymapCount)*0.0000001;
						CharValue._keymap[key]=this.txtID;
					}
					return this;
				}
				CharValue.clear=function(){
					CharValue._keymap={};
					CharValue._keymapCount=1;
				}
				CharValue._keymap={};
				CharValue._keymapCount=1;
				return CharValue;
			})()
		}

		return DrawText;
	})()


	//class laya.webgl.text.DrawTextChar
	var DrawTextChar=(function(){
		function DrawTextChar(content,drawValue){
			//this.xs=NaN;
			//this.ys=NaN;
			//this.width=0;
			//this.height=0;
			//this.char=null;
			//this.fillColor=null;
			//this.borderColor=null;
			//this.borderSize=0;
			//this.font=null;
			//this.fontSize=0;
			//this.texture=null;
			//this.lineWidth=0;
			//this.UV=null;
			//this.isSpace=false;
			this.char=content;
			this.isSpace=content===' ';
			this.xs=drawValue.scaleX;
			this.ys=drawValue.scaleY;
			this.font=drawValue.font.toString();
			this.fontSize=drawValue.font.size;
			this.fillColor=drawValue.fillColor;
			this.borderColor=drawValue.borderColor;
			this.lineWidth=drawValue.lineWidth;
			var bIsConchApp=Render.isConchApp;
			if (bIsConchApp){
				var pCanvas=ConchTextCanvas;
				pCanvas._source=ConchTextCanvas;
				pCanvas._source.canvas=ConchTextCanvas;
				this.texture=new Texture(new WebGLCharImage(pCanvas,this));
				}else {
				this.texture=new Texture(new WebGLCharImage(Browser.canvas.source,this));
			}
		}

		__class(DrawTextChar,'laya.webgl.text.DrawTextChar');
		var __proto=DrawTextChar.prototype;
		__proto.active=function(){
			this.texture.active();
		}

		DrawTextChar.createOneChar=function(content,drawValue){
			var char=new DrawTextChar(content,drawValue);
			return char;
		}

		return DrawTextChar;
	})()


	//class laya.webgl.text.FontInContext
	var FontInContext=(function(){
		function FontInContext(font){
			//this._text=null;
			//this._words=null;
			this._index=0;
			this._size=14;
			this._italic=-2;
			this.setFont(font || "14px Arial");
		}

		__class(FontInContext,'laya.webgl.text.FontInContext');
		var __proto=FontInContext.prototype;
		__proto.setFont=function(value){
			this._words=value.split(' ');
			for (var i=0,n=this._words.length;i < n;i++){
				if (this._words[i].indexOf('px')> 0){
					this._index=i;
					break ;
				}
			}
			this._size=parseInt(this._words[this._index]);
			this._text=null;
			this._italic=-2;
		}

		__proto.getItalic=function(){
			this._italic===-2 && (this._italic=this.hasType("italic"));
			return this._italic;
		}

		__proto.hasType=function(name){
			for (var i=0,n=this._words.length;i < n;i++)
			if (this._words[i]===name)return i;
			return-1;
		}

		__proto.removeType=function(name){
			for (var i=0,n=this._words.length;i < n;i++)
			if (this._words[i]===name){
				this._words.splice(i,1);
				if (this._index > i)this._index--;
				break ;
			}
			this._text=null;
			this._italic=-2;
		}

		__proto.copyTo=function(dec){
			dec._text=this._text;
			dec._size=this._size;
			dec._index=this._index;
			dec._words=this._words.slice();
			dec._italic=-2;
			return dec;
		}

		__proto.toString=function(){
			return this._text ? this._text :(this._text=this._words.join(' '));
		}

		__getset(0,__proto,'size',function(){
			return this._size;
			},function(value){
			this._size=value;
			this._words[this._index]=value+"px";
			this._text=null;
		});

		FontInContext.create=function(font){
			var r=FontInContext._cache[font];
			if (r)return r;
			r=FontInContext._cache[font]=new FontInContext(font);
			return r;
		}

		FontInContext.EMPTY=new FontInContext();
		FontInContext._cache={};
		return FontInContext;
	})()


	//class laya.webgl.utils.CONST3D2D
	var CONST3D2D=(function(){
		function CONST3D2D(){};
		__class(CONST3D2D,'laya.webgl.utils.CONST3D2D');
		CONST3D2D.defaultMatrix4=[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];
		CONST3D2D.defaultMinusYMatrix4=[1,0,0,0,0,-1,0,0,0,0,1,0,0,0,0,1];
		CONST3D2D.uniformMatrix3=[1,0,0,0,0,1,0,0,0,0,1,0];
		CONST3D2D._TMPARRAY=[];
		CONST3D2D._OFFSETX=0;
		CONST3D2D._OFFSETY=0;
		__static(CONST3D2D,
		['BYTES_PE',function(){return this.BYTES_PE=Float32Array.BYTES_PER_ELEMENT;},'BYTES_PIDX',function(){return this.BYTES_PIDX=Uint16Array.BYTES_PER_ELEMENT;}
		]);
		return CONST3D2D;
	})()


	//class laya.webgl.utils.GlUtils
	var GlUtils=(function(){
		function GlUtils(){};
		__class(GlUtils,'laya.webgl.utils.GlUtils');
		GlUtils.make2DProjection=function(width,height,depth){
			return [2.0 / width,0,0,0,0,-2.0 / height,0,0,0,0,2.0 / depth,0,-1,1,0,1,];
		}

		GlUtils.fillIBQuadrangle=function(buffer,count){
			if (count > 65535 / 4){
				throw Error("IBQuadrangle count:"+count+" must<:"+Math.floor(65535 / 4));
				return false;
			}
			count=Math.floor(count);
			buffer._resizeBuffer((count+1)*6 *2,false);
			buffer.byteLength=buffer.bufferLength;
			var bufferData=buffer.getUint16Array();
			var idx=0;
			for (var i=0;i < count;i++){
				bufferData[idx++]=i *4;
				bufferData[idx++]=i *4+2;
				bufferData[idx++]=i *4+1;
				bufferData[idx++]=i *4;
				bufferData[idx++]=i *4+3;
				bufferData[idx++]=i *4+2;
			}
			buffer.setNeedUpload();
			return true;
		}

		GlUtils.expandIBQuadrangle=function(buffer,count){
			buffer.bufferLength >=(count *6 *2)|| GlUtils.fillIBQuadrangle(buffer,count);
		}

		GlUtils.mathCeilPowerOfTwo=function(value){
			value--;
			value |=value >> 1;
			value |=value >> 2;
			value |=value >> 4;
			value |=value >> 8;
			value |=value >> 16;
			value++;
			return value;
		}

		GlUtils.fillQuadrangleImgVb=function(vb,x,y,point4,uv,m,_x,_y){
			'use strict';
			var vpos=(vb._byteLength >> 2)+16;
			vb.byteLength=(vpos << 2);
			var vbdata=vb.getFloat32Array();
			vpos-=16;
			vbdata[vpos+2]=uv[0];
			vbdata[vpos+3]=uv[1];
			vbdata[vpos+6]=uv[2];
			vbdata[vpos+7]=uv[3];
			vbdata[vpos+10]=uv[4];
			vbdata[vpos+11]=uv[5];
			vbdata[vpos+14]=uv[6];
			vbdata[vpos+15]=uv[7];
			var a=m.a,b=m.b,c=m.c,d=m.d;
			if (a!==1 || b!==0 || c!==0 || d!==1){
				m.bTransform=true;
				var tx=m.tx+_x,ty=m.ty+_y;
				vbdata[vpos]=(point4[0]+x)*a+(point4[1]+y)*c+tx;
				vbdata[vpos+1]=(point4[0]+x)*b+(point4[1]+y)*d+ty;
				vbdata[vpos+4]=(point4[2]+x)*a+(point4[3]+y)*c+tx;
				vbdata[vpos+5]=(point4[2]+x)*b+(point4[3]+y)*d+ty;
				vbdata[vpos+8]=(point4[4]+x)*a+(point4[5]+y)*c+tx;
				vbdata[vpos+9]=(point4[4]+x)*b+(point4[5]+y)*d+ty;
				vbdata[vpos+12]=(point4[6]+x)*a+(point4[7]+y)*c+tx;
				vbdata[vpos+13]=(point4[6]+x)*b+(point4[7]+y)*d+ty;
				}else {
				m.bTransform=false;
				x+=m.tx+_x;
				y+=m.ty+_y;
				vbdata[vpos]=x+point4[0];
				vbdata[vpos+1]=y+point4[1];
				vbdata[vpos+4]=x+point4[2];
				vbdata[vpos+5]=y+point4[3];
				vbdata[vpos+8]=x+point4[4];
				vbdata[vpos+9]=y+point4[5];
				vbdata[vpos+12]=x+point4[6];
				vbdata[vpos+13]=y+point4[7];
			}
			vb._upload=true;
			return true;
		}

		GlUtils.fillTranglesVB=function(vb,x,y,points,m,_x,_y){
			'use strict';
			var vpos=(vb._byteLength >> 2)+points.length;
			vb.byteLength=(vpos << 2);
			var vbdata=vb.getFloat32Array();
			vpos-=points.length;
			var len=points.length;
			var a=m.a,b=m.b,c=m.c,d=m.d;
			for (var i=0;i < len;i+=4){
				vbdata[vpos+i+2]=points[i+2];
				vbdata[vpos+i+3]=points[i+3];
				if (a!==1 || b!==0 || c!==0 || d!==1){
					m.bTransform=true;
					var tx=m.tx+_x,ty=m.ty+_y;
					vbdata[vpos+i]=(points[i]+x)*a+(points[i+1]+y)*c+tx;
					vbdata[vpos+i+1]=(points[i]+x)*b+(points[i+1]+y)*d+ty;
					}else {
					m.bTransform=false;
					x+=m.tx+_x;
					y+=m.ty+_y;
					vbdata[vpos+i]=x+points[i];
					vbdata[vpos+i+1]=y+points[i+1];
				}
			}
			vb._upload=true;
			return true;
		}

		GlUtils.copyPreImgVb=function(vb,dx,dy){
			var vpos=(vb._byteLength >> 2);
			vb.byteLength=((vpos+16)<< 2);
			var vbdata=vb.getFloat32Array();
			for (var i=0;i < 16;i++){
				vbdata[vpos+i]=vbdata[vpos+i-16];
			}
			vbdata[vpos]+=dx;
			vbdata[vpos+1]+=dy;
			vbdata[vpos+4]+=dx;
			vbdata[vpos+5]+=dy;
			vbdata[vpos+8]+=dx;
			vbdata[vpos+9]+=dy;
			vbdata[vpos+12]+=dx;
			vbdata[vpos+13]+=dy;
			vb._upload=true;
		}

		GlUtils.fillRectImgVb=function(vb,clip,x,y,width,height,uv,m,_x,_y,dx,dy,round){
			(round===void 0)&& (round=false);
			'use strict';
			var mType=1;
			var toBx,toBy,toEx,toEy;
			var cBx,cBy,cEx,cEy;
			var w0,h0,tx,ty;
			var finalX,finalY,offsetX,offsetY;
			var a=m.a,b=m.b,c=m.c,d=m.d;
			var useClip=clip.width < 99999999;
			if (a!==1 || b!==0 || c!==0 || d!==1){
				m.bTransform=true;
				if (b===0 && c===0){
					mType=23;
					w0=width+x,h0=height+y;
					tx=m.tx+_x,ty=m.ty+_y;
					toBx=a *x+tx;
					toEx=a *w0+tx;
					toBy=d *y+ty;
					toEy=d *h0+ty;
				}
				}else {
				mType=23;
				m.bTransform=false;
				toBx=x+m.tx+_x;
				toEx=toBx+width;
				toBy=y+m.ty+_y;
				toEy=toBy+height;
			}
			if (useClip){
				cBx=clip.x,cBy=clip.y,cEx=clip.width+cBx,cEy=clip.height+cBy;
			}
			if (mType!==1 && (toBx >=cEx || toBy >=cEy || toEx <=cBx || toEy <=cBy))
				return false;
			var vpos=(vb._byteLength >> 2);
			vb.byteLength=((vpos+16)<< 2);
			var vbdata=vb.getFloat32Array();
			vbdata[vpos+2]=uv[0];
			vbdata[vpos+3]=uv[1];
			vbdata[vpos+6]=uv[2];
			vbdata[vpos+7]=uv[3];
			vbdata[vpos+10]=uv[4];
			vbdata[vpos+11]=uv[5];
			vbdata[vpos+14]=uv[6];
			vbdata[vpos+15]=uv[7];
			switch (mType){
				case 1:
					tx=m.tx+_x,ty=m.ty+_y;
					w0=width+x,h0=height+y;
					var w1=x,h1=y;
					var aw1=a *w1,ch1=c *h1,dh1=d *h1,bw1=b *w1;
					var aw0=a *w0,ch0=c *h0,dh0=d *h0,bw0=b *w0;
					if (round){
						finalX=aw1+ch1+tx;
						offsetX=Math.round(finalX)-finalX;
						finalY=dh1+bw1+ty;
						offsetY=Math.round(finalY)-finalY;
						vbdata[vpos]=finalX+offsetX;
						vbdata[vpos+1]=finalY+offsetY;
						vbdata[vpos+4]=aw0+ch1+tx+offsetX;
						vbdata[vpos+5]=dh1+bw0+ty+offsetY;
						vbdata[vpos+8]=aw0+ch0+tx+offsetX;
						vbdata[vpos+9]=dh0+bw0+ty+offsetY;
						vbdata[vpos+12]=aw1+ch0+tx+offsetX;
						vbdata[vpos+13]=dh0+bw1+ty+offsetY;
						}else {
						vbdata[vpos]=aw1+ch1+tx;
						vbdata[vpos+1]=dh1+bw1+ty;
						vbdata[vpos+4]=aw0+ch1+tx;
						vbdata[vpos+5]=dh1+bw0+ty;
						vbdata[vpos+8]=aw0+ch0+tx;
						vbdata[vpos+9]=dh0+bw0+ty;
						vbdata[vpos+12]=aw1+ch0+tx;
						vbdata[vpos+13]=dh0+bw1+ty;
					}
					break ;
				case 23:
					if (round){
						finalX=toBx+dx;
						offsetX=Math.round(finalX)-finalX;
						finalY=toBy;
						offsetY=Math.round(finalY)-finalY;
						vbdata[vpos]=finalX+offsetX;
						vbdata[vpos+1]=finalY+offsetY;
						vbdata[vpos+4]=toEx+dx+offsetX;
						vbdata[vpos+5]=toBy+offsetY;
						vbdata[vpos+8]=toEx+offsetX;
						vbdata[vpos+9]=toEy+offsetY;
						vbdata[vpos+12]=toBx+offsetX;
						vbdata[vpos+13]=toEy+offsetY;
						}else {
						vbdata[vpos]=toBx+dx;
						vbdata[vpos+1]=toBy;
						vbdata[vpos+4]=toEx+dx;
						vbdata[vpos+5]=toBy;
						vbdata[vpos+8]=toEx;
						vbdata[vpos+9]=toEy;
						vbdata[vpos+12]=toBx;
						vbdata[vpos+13]=toEy;
					}
					break ;
				}
			vb._upload=true;
			return true;
		}

		GlUtils.fillLineVb=function(vb,clip,fx,fy,tx,ty,width,mat){
			'use strict';
			var linew=width *.5;
			var data=GlUtils._fillLineArray;
			var perpx=-(fy-ty),perpy=fx-tx;
			var dist=Math.sqrt(perpx *perpx+perpy *perpy);
			perpx /=dist,perpy /=dist,perpx *=linew,perpy *=linew;
			data[0]=fx-perpx,data[1]=fy-perpy,data[4]=fx+perpx,data[5]=fy+perpy,data[8]=tx+perpx,data[9]=ty+perpy,data[12]=tx-perpx,data[13]=ty-perpy;
			mat && mat.transformPointArray(data,data);
			var vpos=(vb._byteLength >> 2)+16;
			vb.byteLength=(vpos << 2);
			vb.insertData(data,vpos-16);
			return true;
		}

		GlUtils._fillLineArray=[[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]];
		return GlUtils;
	})()


	//class laya.webgl.utils.MatirxArray
	var MatirxArray=(function(){
		function MatirxArray(){};
		__class(MatirxArray,'laya.webgl.utils.MatirxArray');
		MatirxArray.ArrayMul=function(a,b,o){
			if (!a){
				MatirxArray.copyArray(b,o);
				return;
			}
			if (!b){
				MatirxArray.copyArray(a,o);
				return;
			};
			var ai0=NaN,ai1=NaN,ai2=NaN,ai3=NaN;
			for (var i=0;i < 4;i++){
				ai0=a[i];
				ai1=a[i+4];
				ai2=a[i+8];
				ai3=a[i+12];
				o[i]=ai0 *b[0]+ai1 *b[1]+ai2 *b[2]+ai3 *b[3];
				o[i+4]=ai0 *b[4]+ai1 *b[5]+ai2 *b[6]+ai3 *b[7];
				o[i+8]=ai0 *b[8]+ai1 *b[9]+ai2 *b[10]+ai3 *b[11];
				o[i+12]=ai0 *b[12]+ai1 *b[13]+ai2 *b[14]+ai3 *b[15];
			}
		}

		MatirxArray.copyArray=function(f,t){
			if (!f)return;
			if (!t)return;
			for (var i=0;i < f.length;i++){
				t[i]=f[i];
			}
		}

		return MatirxArray;
	})()


	//class laya.webgl.utils.RenderState2D
	var RenderState2D=(function(){
		function RenderState2D(){};
		__class(RenderState2D,'laya.webgl.utils.RenderState2D');
		RenderState2D.getMatrArray=function(){
			return [1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];
		}

		RenderState2D.mat2MatArray=function(mat,matArray){
			var m=mat;
			var m4=matArray;
			m4[0]=m.a;
			m4[1]=m.b;
			m4[4]=m.c;
			m4[5]=m.d;
			m4[12]=m.tx;
			m4[13]=m.ty;
			return matArray;
		}

		RenderState2D.restoreTempArray=function(){
			RenderState2D.TEMPMAT4_ARRAY[0]=1;
			RenderState2D.TEMPMAT4_ARRAY[1]=0;
			RenderState2D.TEMPMAT4_ARRAY[4]=0;
			RenderState2D.TEMPMAT4_ARRAY[5]=1;
			RenderState2D.TEMPMAT4_ARRAY[12]=0;
			RenderState2D.TEMPMAT4_ARRAY[13]=0;
		}

		RenderState2D.clear=function(){
			RenderState2D.worldScissorTest=false;
			RenderState2D.worldShaderDefines=null;
			RenderState2D.worldFilters=null;
			RenderState2D.worldAlpha=1;
			RenderState2D.worldClipRect.x=RenderState2D.worldClipRect.y=0;
			RenderState2D.worldClipRect.width=RenderState2D.width;
			RenderState2D.worldClipRect.height=RenderState2D.height;
			RenderState2D.curRenderTarget=null;
		}

		RenderState2D._MAXSIZE=99999999;
		RenderState2D.TEMPMAT4_ARRAY=[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];
		RenderState2D.worldMatrix4=RenderState2D.TEMPMAT4_ARRAY;
		RenderState2D.worldAlpha=1.0;
		RenderState2D.worldScissorTest=false;
		RenderState2D.worldFilters=null
		RenderState2D.worldShaderDefines=null
		RenderState2D.worldClipRect=new Rectangle(0,0,99999999,99999999);
		RenderState2D.curRenderTarget=null
		RenderState2D.width=0;
		RenderState2D.height=0;
		__static(RenderState2D,
		['worldMatrix',function(){return this.worldMatrix=new Matrix();}
		]);
		return RenderState2D;
	})()


	//class laya.webgl.utils.ShaderCompile
	var ShaderCompile=(function(){
		var ShaderScriptBlock;
		function ShaderCompile(name,vs,ps,nameMap,includeFiles){
			//this._VS=null;
			//this._PS=null;
			//this._VSTXT=null;
			//this._PSTXT=null;
			//this._nameMap=null;
			this._VSTXT=vs;
			this._PSTXT=ps;
			function split (str){
				var words=str.split(' ');
				var out=[];
				for (var i=0;i < words.length;i++)
				words[i].length > 0 && out.push(words[i]);
				return out;
			}
			function c (script){
				var i=0,n=0,ofs=0,words,condition;
				var top=new ShaderScriptBlock(0,null,null,null);
				var parent=top;
				var lines=script.split('\n');
				for (i=0,n=lines.length;i < n;i++){
					var line=lines[i];
					if (line.indexOf("#ifdef")>=0){
						words=split(line);
						parent=new ShaderScriptBlock(1,words[1],"",parent);
						continue ;
					}
					if (line.indexOf("#else")>=0){
						condition=parent.condition;
						parent=new ShaderScriptBlock(2,null,"",parent.parent);
						parent.condition=condition;
						continue ;
					}
					if (line.indexOf("#endif")>=0){
						parent=parent.parent;
						continue ;
					}
					if (line.indexOf("#include")>=0){
						words=split(line);
						var fname=words[1];
						var chr=fname.charAt(0);
						if (chr==='"' || chr==="'"){
							fname=fname.substr(1,fname.length-2);
							ofs=fname.lastIndexOf(chr);
							if (ofs > 0)fname=fname.substr(0,ofs);
						}
						ofs=words[0].indexOf('?');
						var str=ofs > 0 ? words[0].substr(ofs+1):words[0];
						new ShaderScriptBlock(1,str,includeFiles[fname],parent);
						continue ;
					}
					if (parent.childs.length > 0 && parent.childs[parent.childs.length-1].type===0){
						parent.childs[parent.childs.length-1].text+="\n"+line;
					}else new ShaderScriptBlock(0,null,line,parent);
				}
				return top;
			}
			this._VS=c(vs);
			this._PS=c(ps);
			this._nameMap=nameMap;
		}

		__class(ShaderCompile,'laya.webgl.utils.ShaderCompile');
		var __proto=ShaderCompile.prototype;
		__proto.createShader=function(define,shaderName,createShader){
			var defMap={};
			var defineStr="";
			if (define){
				for (var i in define){
					defineStr+="#define "+i+"\n";
					defMap[i]=true;
				}
			};
			var vs=this._VS.toscript(defMap,[]);
			var ps=this._PS.toscript(defMap,[]);
			return (createShader || Shader.create)(defineStr+vs.join('\n'),defineStr+ps.join('\n'),shaderName,this._nameMap);
		}

		ShaderCompile.IFDEF_NO=0;
		ShaderCompile.IFDEF_YES=1;
		ShaderCompile.IFDEF_ELSE=2;
		ShaderCompile.__init$=function(){
			//class ShaderScriptBlock
			ShaderScriptBlock=(function(){
				function ShaderScriptBlock(type,condition,text,parent){
					//this.type=0;
					//this.condition=null;
					//this.text=null;
					//this.parent=null;
					this.childs=new Array;
					this.type=type;
					this.text=text;
					this.parent=parent;
					parent && parent.childs.push(this);
					if (!condition)return;
					var newcondition="";
					var preIsParam=false,isParam=false;
					for (var i=0,n=condition.length;i < n;i++){
						var c=condition.charAt(i);
						isParam="!&|() \t".indexOf(c)< 0;
						if (preIsParam !=isParam){
							isParam && (newcondition+="this.");
							preIsParam=isParam;
						}
						newcondition+=c;
					}
					this.condition=RunDriver.createShaderCondition(newcondition);
				}
				__class(ShaderScriptBlock,'');
				var __proto=ShaderScriptBlock.prototype;
				__proto.toscript=function(def,out){
					if (this.type===0){
						this.text && out.push(this.text);
					}
					if (this.childs.length < 1 && !this.text)return out;
					if (this.type!==0){
						var ifdef=!!this.condition.call(def);
						this.type===2 && (ifdef=!ifdef);
						if (!ifdef)return out;
						this.text && out.push(this.text);
					}
					this.childs.length > 0 && this.childs.forEach(function(o,index,arr){
						o.toscript(def,out)
					});
					return out;
				}
				return ShaderScriptBlock;
			})()
		}

		return ShaderCompile;
	})()


	/**
	*@private
	*<code>Shader3D</code> 主要用数组的方式保存shader变量定义，后期合并ShaderValue不使用for in，性能较高。
	*/
	//class laya.webgl.utils.ValusArray
	var ValusArray=(function(){
		function ValusArray(){
			this._data=[];
			this._length=0;
			this._data._length=0;
		}

		__class(ValusArray,'laya.webgl.utils.ValusArray');
		var __proto=ValusArray.prototype;
		__proto.pushValue=function(name,value){
			this.setValue(this._length,name,value);
			this._length+=2;
		}

		__proto.setValue=function(index,name,value){
			this._data[index++]=name;
			this._data[index]=value;
		}

		__proto.pushArray=function(value){
			var data=this._data;
			var len=this._length;
			var inData=value._data;
			var dec;
			for (var i=0,n=value.length;i < n;i++,len++){
				data[len++]=inData[i++];
				data[len]=inData[i];
			}
			this._length=len;
		}

		__proto.copyTo=function(dec){
			dec || (dec=new ValusArray());
			var values=this._data;
			var decData=dec._data;
			for (var i=0;i < this._length;i++){
				decData[i]=values[i];
			}
			dec.length=this._length;
			return dec;
		}

		__getset(0,__proto,'length',function(){
			return this._length;
			},function(value){
			this._length=value;
		});

		__getset(0,__proto,'data',function(){
			return this._data;
		});

		return ValusArray;
	})()


	/**
	*@private
	*/
	//class laya.webgl.WebGL
	var WebGL=(function(){
		function WebGL(){};
		__class(WebGL,'laya.webgl.WebGL');
		WebGL._float32ArraySlice=function(){
			var _this=this;
			var sz=_this.length;
			var dec=new Float32Array(_this.length);
			for (var i=0;i < sz;i++)dec[i]=_this[i];
			return dec;
		}

		WebGL._uint16ArraySlice=function(__arg){
			var arg=arguments;
			var _this=this;
			var sz=0;
			var dec;
			var i=0;
			if (arg.length===0){
				sz=_this.length;
				dec=new Uint16Array(sz);
				for (i=0;i < sz;i++)
				dec[i]=_this[i];
				}else if (arg.length===2){
				var start=arg[0];
				var end=arg[1];
				if (end > start){
					sz=end-start;
					dec=new Uint16Array(sz);
					for (i=start;i < end;i++)
					dec[i-start]=_this[i];
					}else {
					dec=new Uint16Array(0);
				}
			}
			return dec;
		}

		WebGL.expandContext=function(){
			var from=Context.prototype;
			var to=CanvasRenderingContext2D.prototype;
			to.fillTrangles=from.fillTrangles;
			Buffer2D.__int__(null);
			to.setIBVB=function (x,y,ib,vb,numElement,mat,shader,shaderValues,startIndex,offset){
				(startIndex===void 0)&& (startIndex=0);
				(offset===void 0)&& (offset=0);
				if (ib===null){
					this._ib=this._ib || IndexBuffer2D.QuadrangleIB;
					ib=this._ib;
					GlUtils.expandIBQuadrangle(ib,(vb.byteLength / (4 *16)+8));
				}
				this._setIBVB(x,y,ib,vb,numElement,mat,shader,shaderValues,startIndex,offset);
			};
			to.fillTrangles=function (tex,x,y,points,m){
				this._curMat=this._curMat || Matrix.create();
				this._vb=this._vb || VertexBuffer2D.create();
				if (!this._ib){
					this._ib=IndexBuffer2D.create();
					GlUtils.fillIBQuadrangle(this._ib,length / 4);
				};
				var vb=this._vb;
				var length=points.length >> 4;
				GlUtils.fillTranglesVB(vb,x,y,points,m || this._curMat,0,0);
				GlUtils.expandIBQuadrangle(this._ib,(vb.byteLength / (4 *16)+8));
				var shaderValues=new Value2D(0x01,0);
				shaderValues.textureHost=tex;
				var sd=new Shader2X("attribute vec2 position; attribute vec2 texcoord; uniform vec2 size; uniform mat4 mmat; varying vec2 v_texcoord; void main() { vec4 p=vec4(position.xy,0.0,1.0);vec4 pos=mmat*p; gl_Position =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0); v_texcoord = texcoord; }","precision mediump float; varying vec2 v_texcoord; uniform sampler2D texture; void main() {vec4 color= texture2D(texture, v_texcoord); color.a*=1.0; gl_FragColor= color;}");
				vb._vertType=3;
				this._setIBVB(x,y,this._ib,vb,length *6,m,sd,shaderValues,0,0);
			}
		}

		WebGL.enable=function(){
			if (Render.isConchApp){
				if (!Render.isConchWebGL){
					WebGL.expandContext();
					return false;
				}
			}
			if (!WebGL.isWebGLSupported())return false;
			if (Render.isWebGL)return true;
			HTMLImage.create=function (src,def){
				return new WebGLImage(src,def);
			}
			Render.WebGL=WebGL;
			Render.isWebGL=true;
			DrawText.__init__();
			RunDriver.createRenderSprite=function (type,next){
				return new RenderSprite3D(type,next);
			}
			RunDriver.createWebGLContext2D=function (c){
				return new WebGLContext2D(c);
			}
			RunDriver.changeWebGLSize=function (width,height){
				laya.webgl.WebGL.onStageResize(width,height);
			}
			RunDriver.createGraphics=function (){
				return new GraphicsGL();
			};
			var action=RunDriver.createFilterAction;
			RunDriver.createFilterAction=action ? action :function (type){
				return new ColorFilterActionGL()
			}
			RunDriver.clear=function (color){
				RenderState2D.worldScissorTest && laya.webgl.WebGL.mainContext.disable(0x0C11);
				if (color==null){
					Render.context.ctx.clearBG(0,0,0,0);
					}else {
					var c=Color.create(color)._color;
					Render.context.ctx.clearBG(c[0],c[1],c[2],c[3]);
				}
				RenderState2D.clear();
			}
			RunDriver.addToAtlas=function (texture,force){
				(force===void 0)&& (force=false);
				var bitmap=texture.bitmap;
				if (!Render.optimizeTextureMemory(texture.url,texture)){
					(bitmap).enableMerageInAtlas=false;
					return;
				}
				if ((Laya.__typeof(bitmap,'laya.webgl.resource.IMergeAtlasBitmap'))&& ((bitmap).allowMerageInAtlas)){
					bitmap.on("recovered",texture,texture.addTextureToAtlas);
				}
			}
			AtlasResourceManager._enable();
			RunDriver.beginFlush=function (){
				var atlasResourceManager=AtlasResourceManager.instance;
				var count=atlasResourceManager.getAtlaserCount();
				for (var i=0;i < count;i++){
					var atlerCanvas=atlasResourceManager.getAtlaserByIndex(i).texture;
					(atlerCanvas._flashCacheImageNeedFlush)&& (RunDriver.flashFlushImage(atlerCanvas));
				}
			}
			RunDriver.drawToCanvas=function (sprite,_renderType,canvasWidth,canvasHeight,offsetX,offsetY){
				var renderTarget=new RenderTarget2D(canvasWidth,canvasHeight,0x1908,0x1401,0,false);
				renderTarget.start();
				renderTarget.clear(1.0,0.0,0.0,1.0);
				sprite.render(Render.context,-offsetX,RenderState2D.height-canvasHeight-offsetY);
				Render.context.flush();
				renderTarget.end();
				var pixels=renderTarget.getData(0,0,renderTarget.width,renderTarget.height);
				renderTarget.dispose();
				return pixels;
			}
			RunDriver.createFilterAction=function (type){
				var action;
				switch (type){
					case 0x20:
						action=new ColorFilterActionGL();
						break ;
					}
				return action;
			}
			RunDriver.addTextureToAtlas=function (texture){
				texture._uvID++;
				AtlasResourceManager._atlasRestore++;
				((texture.bitmap).enableMerageInAtlas)&& (AtlasResourceManager.instance.addToAtlas(texture));
			}
			RunDriver.getTexturePixels=function (value,x,y,width,height){
				var tSprite=new Sprite();
				tSprite.x=-x;
				tSprite.y=-y;
				tSprite.graphics.drawTexture(value,0,0,value.sourceWidth,value.sourceHeight);
				var tRenderTarget=RenderTarget2D.create(width,height);
				tRenderTarget.start();
				tRenderTarget.clear(0,0,0,0);
				tSprite.render(Render.context,0,0);
				(Render.context.ctx).flush();
				tRenderTarget.end();
				var tUint8Array=tRenderTarget.getData(0,0,width,height);
				var tArray=[];
				var tIndex=0;
				for (var i=height-1;i >=0;i--){
					for (var j=0;j < width;j++){
						tIndex=(i *width+j)*4;
						tArray.push(tUint8Array[tIndex]);
						tArray.push(tUint8Array[tIndex+1]);
						tArray.push(tUint8Array[tIndex+2]);
						tArray.push(tUint8Array[tIndex+3]);
					}
				}
				return tArray;
			}
			RunDriver.fillTextureShader=function (value,x,y,width,height){
				var tFillTetureSprite=new FillTextureSprite();
				return tFillTetureSprite;
			}
			RunDriver.skinAniSprite=function (){
				var tSkinSprite=new SkinMesh()
				return tSkinSprite;
			}
			Filter._filterStart=function (scope,sprite,context,x,y){
				var b=scope.getValue("bounds");
				var source=RenderTarget2D.create(b.width,b.height);
				source.start();
				source.clear(0,0,0,0);
				scope.addValue("src",source);
				scope.addValue("ScissorTest",RenderState2D.worldScissorTest);
				if (RenderState2D.worldScissorTest){
					var tClilpRect=new Rectangle();
					tClilpRect.copyFrom((context.ctx)._clipRect)
					scope.addValue("clipRect",tClilpRect);
					RenderState2D.worldScissorTest=false;
					laya.webgl.WebGL.mainContext.disable(0x0C11);
				}
			}
			Filter._filterEnd=function (scope,sprite,context,x,y){
				var b=scope.getValue("bounds");
				var source=scope.getValue("src");
				source.end();
				var out=RenderTarget2D.create(b.width,b.height);
				out.start();
				out.clear(0,0,0,0);
				scope.addValue("out",out);
				sprite._set$P('_filterCache',out);
				sprite._set$P('_isHaveGlowFilter',scope.getValue("_isHaveGlowFilter"));
			}
			Filter._EndTarget=function (scope,context){
				var source=scope.getValue("src");
				source.recycle();
				var out=scope.getValue("out");
				out.end();
				var b=scope.getValue("ScissorTest");
				if (b){
					RenderState2D.worldScissorTest=true;
					laya.webgl.WebGL.mainContext.enable(0x0C11);
					context.ctx.save();
					var tClipRect=scope.getValue("clipRect");
					(context.ctx).clipRect(tClipRect.x,tClipRect.y,tClipRect.width,tClipRect.height);
				}
			}
			Filter._useSrc=function (scope){
				var source=scope.getValue("out");
				source.end();
				source=scope.getValue("src");
				source.start();
				source.clear(0,0,0,0);
			}
			Filter._endSrc=function (scope){
				var source=scope.getValue("src");
				source.end();
			}
			Filter._useOut=function (scope){
				var source=scope.getValue("src");
				source.end();
				source=scope.getValue("out");
				source.start();
				source.clear(0,0,0,0);
			}
			Filter._endOut=function (scope){
				var source=scope.getValue("out");
				source.end();
			}
			Filter._recycleScope=function (scope){
				scope.recycle();
			}
			Filter._filter=function (sprite,context,x,y){
				var next=this._next;
				if (next){
					var filters=sprite.filters,len=filters.length;
					if (len==1 && (filters[0].type==0x20)){
						context.ctx.save();
						context.ctx.setFilters([filters[0]]);
						next._fun.call(next,sprite,context,x,y);
						context.ctx.restore();
						return;
					};
					var shaderValue;
					var b;
					var scope=SubmitCMDScope.create();
					var p=Point.TEMP;
					var tMatrix=context.ctx._getTransformMatrix();
					var mat=Matrix.create();
					tMatrix.copyTo(mat);
					var tPadding=0;
					var tHalfPadding=0;
					var tIsHaveGlowFilter=false;
					var out=sprite._$P._filterCache ? sprite._$P._filterCache :null;
					if (!out || sprite._repaint){
						tIsHaveGlowFilter=sprite._isHaveGlowFilter();
						scope.addValue("_isHaveGlowFilter",tIsHaveGlowFilter);
						if (tIsHaveGlowFilter){
							tPadding=50;
							tHalfPadding=25;
						}
						b=new Rectangle();
						b.copyFrom((sprite).getBounds());
						var tSX=b.x;
						var tSY=b.y;
						b.width+=tPadding;
						b.height+=tPadding;
						p.x=b.x *mat.a+b.y *mat.c;
						p.y=b.y *mat.d+b.x *mat.b;
						b.x=p.x;
						b.y=p.y;
						p.x=b.width *mat.a+b.height *mat.c;
						p.y=b.height *mat.d+b.width *mat.b;
						b.width=p.x;
						b.height=p.y;
						if (b.width <=0 || b.height <=0){
							return;
						}
						out && out.recycle();
						scope.addValue("bounds",b);
						var submit=SubmitCMD.create([scope,sprite,context,0,0],Filter._filterStart);
						context.addRenderObject(submit);
						(context.ctx)._shader2D.glTexture=null;
						var tX=sprite.x-tSX+tHalfPadding;
						var tY=sprite.y-tSY+tHalfPadding;
						next._fun.call(next,sprite,context,tX,tY);
						submit=SubmitCMD.create([scope,sprite,context,0,0],Filter._filterEnd);
						context.addRenderObject(submit);
						for (var i=0;i < len;i++){
							if (i !=0){
								submit=SubmitCMD.create([scope],Filter._useSrc);
								context.addRenderObject(submit);
								shaderValue=Value2D.create(0x01,0);
								Matrix.TEMP.identity();
								context.ctx.drawTarget(scope,0,0,b.width,b.height,Matrix.TEMP,"out",shaderValue,null,BlendMode.TOINT.overlay);
								submit=SubmitCMD.create([scope],Filter._useOut);
								context.addRenderObject(submit);
							};
							var fil=filters[i];
							fil.action.apply3d(scope,sprite,context,0,0);
						}
						submit=SubmitCMD.create([scope,context],Filter._EndTarget);
						context.addRenderObject(submit);
						}else {
						tIsHaveGlowFilter=sprite._$P._isHaveGlowFilter ? sprite._$P._isHaveGlowFilter :false;
						if (tIsHaveGlowFilter){
							tPadding=50;
							tHalfPadding=25;
						}
						b=sprite.getBounds();
						if (b.width <=0 || b.height <=0){
							return;
						}
						b.width+=tPadding;
						b.height+=tPadding;
						p.x=b.x *mat.a+b.y *mat.c;
						p.y=b.y *mat.d+b.x *mat.b;
						b.x=p.x;
						b.y=p.y;
						p.x=b.width *mat.a+b.height *mat.c;
						p.y=b.height *mat.d+b.width *mat.b;
						b.width=p.x;
						b.height=p.y;
						scope.addValue("out",out);
					}
					x=x-tHalfPadding-sprite.x;
					y=y-tHalfPadding-sprite.y;
					p.setTo(x,y);
					mat.transformPoint(p);
					x=p.x+b.x;
					y=p.y+b.y;
					shaderValue=Value2D.create(0x01,0);
					Matrix.TEMP.identity();
					(context.ctx).drawTarget(scope,x,y,b.width,b.height,Matrix.TEMP,"out",shaderValue,null,BlendMode.TOINT.overlay);
					submit=SubmitCMD.create([scope],Filter._recycleScope);
					context.addRenderObject(submit);
					mat.destroy();
				}
			}
			Float32Array.prototype.slice || (Float32Array.prototype.slice=WebGL._float32ArraySlice);
			Uint16Array.prototype.slice || (Uint16Array.prototype.slice=WebGL._uint16ArraySlice);
			return true;
		}

		WebGL.isWebGLSupported=function(){
			var canvas=Browser.createElement('canvas');
			var gl;
			var names=["webgl","experimental-webgl","webkit-3d","moz-webgl"];
			for (var i=0;i < names.length;i++){
				try {
					gl=canvas.getContext(names[i]);
				}catch (e){}
				if (gl)return names[i];
			}
			return null;
		}

		WebGL.onStageResize=function(width,height){
			WebGL.mainContext.viewport(0,0,width,height);
			RenderState2D.width=width;
			RenderState2D.height=height;
		}

		WebGL.isExperimentalWebgl=function(){
			return WebGL._isExperimentalWebgl;
		}

		WebGL.addRenderFinish=function(){
			if (WebGL._isExperimentalWebgl || Render.isFlash){
				RunDriver.endFinish=function (){
					Render.context.ctx.finish();
				}
			}
		}

		WebGL.removeRenderFinish=function(){
			if (WebGL._isExperimentalWebgl){
				RunDriver.endFinish=function (){}
			}
		}

		WebGL.onInvalidGLRes=function(){
			AtlasResourceManager.instance.freeAll();
			ResourceManager.releaseContentManagers(true);
			WebGL.doNodeRepaint(Laya.stage);
			WebGL.mainContext.viewport(0,0,RenderState2D.width,RenderState2D.height);
			Laya.stage.event("devicelost");
		}

		WebGL.doNodeRepaint=function(sprite){
			(sprite.numChildren==0)&& (sprite.repaint());
			for (var i=0;i < sprite.numChildren;i++)
			WebGL.doNodeRepaint(sprite.getChildAt(i));
		}

		WebGL.init=function(canvas,width,height){
			WebGL.mainCanvas=canvas;
			HTMLCanvas._createContext=function (canvas){
				return new WebGLContext2D(canvas);
			};
			var webGLName=WebGL.isWebGLSupported();
			var gl=WebGL.mainContext=RunDriver.newWebGLContext(canvas,webGLName);
			WebGL._isExperimentalWebgl=(webGLName !="webgl" && (Browser.onWeiXin || Browser.onMQQBrowser));
			WebGL.frameShaderHighPrecision=false;
			try {
				var precisionFormat=laya.webgl.WebGL.mainContext.getShaderPrecisionFormat(0x8B30,0x8DF2);
				precisionFormat.precision ? WebGL.frameShaderHighPrecision=true :WebGL.frameShaderHighPrecision=false;
			}catch (e){}
			Browser.window.SetupWebglContext && Browser.window.SetupWebglContext(gl);
			WebGL.onStageResize(width,height);
			if (WebGL.mainContext==null)
				throw new Error("webGL getContext err!");
			System.__init__();
			AtlasResourceManager.__init__();
			ShaderDefines2D.__init__();
			Submit.__init__();
			WebGLContext2D.__init__();
			Value2D.__init__();
			Shader2D.__init__();
			Buffer2D.__int__(gl);
			BlendMode._init_(gl);
			if (Render.isConchApp){
				conch.setOnInvalidGLRes(WebGL.onInvalidGLRes);
			}
		}

		WebGL.mainCanvas=null
		WebGL.mainContext=null
		WebGL.antialias=true;
		WebGL.frameShaderHighPrecision=false;
		WebGL._bg_null=[0,0,0,0];
		WebGL._isExperimentalWebgl=false;
		return WebGL;
	})()


	//class laya.webgl.WebGLContext
	var WebGLContext=(function(){
		function WebGLContext(){};
		__class(WebGLContext,'laya.webgl.WebGLContext');
		WebGLContext.UseProgram=function(program){
			if (WebGLContext._useProgram===program)return false;
			WebGL.mainContext.useProgram(program);
			WebGLContext._useProgram=program;
			return true;
		}

		WebGLContext.setDepthTest=function(gl,value){
			value!==WebGLContext._depthTest && (WebGLContext._depthTest=value,value?gl.enable(0x0B71):gl.disable(0x0B71));
		}

		WebGLContext.setDepthMask=function(gl,value){
			value!==WebGLContext._depthMask && (WebGLContext._depthMask=value,gl.depthMask(value));
		}

		WebGLContext.setDepthFunc=function(gl,value){
			value!==WebGLContext._depthFunc && (WebGLContext._depthFunc=value,gl.depthFunc(value));
		}

		WebGLContext.setBlend=function(gl,value){
			value!==WebGLContext._blend && (WebGLContext._blend=value,value?gl.enable(0x0BE2):gl.disable(0x0BE2));
		}

		WebGLContext.setBlendFunc=function(gl,sFactor,dFactor){
			(sFactor!==WebGLContext._sFactor||dFactor!==WebGLContext._dFactor)&& (WebGLContext._sFactor=sFactor,WebGLContext._dFactor=dFactor,gl.blendFunc(sFactor,dFactor));
		}

		WebGLContext.setCullFace=function(gl,value){
			value!==WebGLContext._cullFace && (WebGLContext._cullFace=value,value?gl.enable(0x0B44):gl.disable(0x0B44));
		}

		WebGLContext.setFrontFaceCCW=function(gl,value){
			value!==WebGLContext._frontFace && (WebGLContext._frontFace=value,gl.frontFace(value));
		}

		WebGLContext.bindTexture=function(gl,target,texture){
			gl.bindTexture(target,texture);
			WebGLContext.curBindTexTarget=target;
			WebGLContext.curBindTexValue=texture;
		}

		WebGLContext._useProgram=null;
		WebGLContext._depthTest=true;
		WebGLContext._depthMask=1;
		WebGLContext._depthFunc=0x0201;
		WebGLContext._blend=false;
		WebGLContext._sFactor=1;
		WebGLContext._dFactor=0;
		WebGLContext._cullFace=false;
		WebGLContext._frontFace=0x0901;
		WebGLContext.curBindTexTarget=null
		WebGLContext.curBindTexValue=null
		WebGLContext.__init$=function(){
			;
		}

		return WebGLContext;
	})()


	/**
	*<code>Laya3D</code> 类用于初始化3D设置。
	*/
	//class Laya3D
	var Laya3D=(function(){
		/**
		*创建一个 <code>Laya3D</code> 实例。
		*/
		function Laya3D(){}
		__class(Laya3D,'Laya3D');
		Laya3D._initShader=function(){
			Shader.addInclude("LightHelper.glsl","\nstruct DirectionLight\n{\n vec3 Direction;\n vec3 Diffuse;\n vec3 Ambient;\n vec3 Specular;\n};\n\nstruct PointLight\n{\n vec3 Diffuse;\n vec3 Ambient;\n vec3 Specular;\n vec3 Attenuation;\n vec3 Position;\n float Range;\n};\n\nstruct SpotLight\n{\n vec3 Diffuse;\n vec3 Ambient;\n vec3 Specular;\n vec3 Attenuation;\n vec3 Position;\n vec3 Direction;\n float Spot;\n float Range;\n};\n\n\nvoid  computeDirectionLight(in vec3 matDif,in vec3 matAmb,in vec4 matSpe,in DirectionLight dirLight,in vec3 normal,in vec3 toEye,out vec3 dif,out vec3 amb,out vec3 spec)\n{\n	dif=vec3(0.0);//不初始化在IOS中闪烁，PC中不会闪烁\n	amb=vec3(0.0);\n	spec=vec3(0.0);\n	vec3 lightVec=-normalize(dirLight.Direction);\n	\n	amb=matAmb*dirLight.Ambient;\n	\n	float  diffuseFactor=dot(lightVec, normal);\n	\n	if(diffuseFactor>0.0)\n	{\n	   vec3 v = reflect(-lightVec, normal);\n	   float specFactor = pow(max(dot(v, toEye), 0.0), matSpe.w);\n	   \n	   dif = diffuseFactor * matDif * dirLight.Diffuse;\n	   spec = specFactor * matSpe.rgb * dirLight.Specular;\n	}\n	\n}\n\nvoid computePointLight(in vec3 matDif,in vec3 matAmb,in vec4 matSpe,in PointLight poiLight, in vec3 pos,in vec3 normal,in vec3 toEye,out vec3 dif,out vec3 amb,out vec3 spec)\n{\n	dif=vec3(0.0);\n	amb=vec3(0.0);\n	spec=vec3(0.0);\n	vec3 lightVec = poiLight.Position - pos;\n		\n	float d = length(lightVec);\n	\n	if( d > poiLight.Range )\n		return;\n		\n	lightVec /= d; \n	\n	amb = matAmb * poiLight.Ambient;	\n\n	float diffuseFactor = dot(lightVec, normal);\n\n	if( diffuseFactor > 0.0 )\n	{\n		vec3 v= reflect(-lightVec, normal);\n		float specFactor = pow(max(dot(v, toEye), 0.0), matSpe.w);\n					\n		dif = diffuseFactor * matDif * poiLight.Diffuse;\n		spec = specFactor * matSpe.rgb * poiLight.Specular;\n	}\n\n	float attenuate = 1.0 / dot(poiLight.Attenuation, vec3(1.0, d, d*d));\n\n	dif *= attenuate;\n	spec*= attenuate;\n}\n\nvoid ComputeSpotLight(in vec3 matDif,in vec3 matAmb,in vec4 matSpe,in SpotLight spoLight,in vec3 pos, in vec3 normal,in vec3 toEye,out vec3 dif,out vec3 amb,out vec3 spec)\n{\n	amb = vec3(0.0);\n	dif =vec3(0.0);\n	spec= vec3(0.0);\n	vec3 lightVec = spoLight.Position - pos;\n		\n	float d = length(lightVec);\n	\n	if( d > spoLight.Range)\n		return;\n		\n	lightVec /= d; \n	\n	amb = matAmb * spoLight.Ambient;	\n\n	float diffuseFactor = dot(lightVec, normal);\n\n	if(diffuseFactor > 0.0)\n	{\n		vec3 v= reflect(-lightVec, normal);\n		float specFactor = pow(max(dot(v, toEye), 0.0), matSpe.w);\n					\n		dif = diffuseFactor * matDif * spoLight.Diffuse;\n		spec = specFactor * matSpe.rgb * spoLight.Specular;\n	}\n	\n	float spot = pow(max(dot(-lightVec, normalize(spoLight.Direction)), 0.0), spoLight.Spot);\n\n	float attenuate = spot/dot(spoLight.Attenuation, vec3(1.0, d, d*d));\n\n	amb *= spot;\n	dif *= attenuate;\n	spec*= attenuate;\n}\n\nvec3 NormalSampleToWorldSpace(vec3 normalMapSample, vec3 unitNormal, vec3 tangent)\n{\n	vec3 normalT = 2.0*normalMapSample - 1.0;\n\n	// Build orthonormal basis.\n	vec3 N = normalize(unitNormal);\n	vec3 T = normalize( tangent- dot(tangent, N)*N);\n	vec3 B = cross(T, N);\n\n	mat3 TBN = mat3(T, B, N);\n\n	// Transform from tangent space to world space.\n	vec3 bumpedNormal = TBN*normalT;\n\n	return bumpedNormal;\n}\n");
			Shader.addInclude("VRHelper.glsl","\nvec4 DistortFishEye(vec4 p)\n{\n    vec2 v = p.xy / p.w;\n    float radius = length(v);// Convert to polar coords\n    if (radius > 0.0)\n    {\n      float theta = atan(v.y,v.x);\n      \n      radius = pow(radius, 0.93);// Distort:\n\n      v.x = radius * cos(theta);// Convert back to Cartesian\n      v.y = radius * sin(theta);\n      p.xy = v.xy * p.w;\n    }\n    return p;\n}");
			var vs,ps;
			var shaderNameMap={
				'a_Position':"POSITION",
				'a_Color':"COLOR",
				'a_Normal':"NORMAL",
				'a_Texcoord0':"UV",
				'a_Texcoord1':"UV1",
				'a_TexcoordNext0':"NEXTUV",
				'a_BoneWeights':"BLENDWEIGHT",
				'a_BoneIndices':"BLENDINDICES",
				'a_Tangent0':"TANGENT0",
				'u_WorldMat':"MATRIX1",
				'u_CameraPos':"CAMERAPOS",
				'u_DiffuseTexture':"DIFFUSETEXTURE",
				'u_SpecularTexture':"SPECULARTEXTURE",
				'u_NormalTexture':"NORMALTEXTURE",
				'u_AmbientTexture':"AMBIENTTEXTURE",
				'u_ReflectTexture':"REFLECTTEXTURE",
				'u_MvpMatrix':"MVPMATRIX",
				'u_Bones':"MATRIXARRAY0",
				'u_FogStart':"FOGSTART",
				'u_FogRange':"FOGRANGE",
				'u_FogColor':"FOGCOLOR",
				'u_Albedo':"ALBEDO",
				'u_AlphaTestValue':"ALPHATESTVALUE",
				'u_UVMatrix':"MATRIX2",
				'u_UVAge':"FLOAT0",
				'u_UVAniAge':"UVAGEX",
				'u_DirectionLight.Direction':"LIGHTDIRECTION",
				'u_DirectionLight.Diffuse':"LIGHTDIRDIFFUSE",
				'u_DirectionLight.Ambient':"LIGHTDIRAMBIENT",
				'u_DirectionLight.Specular':"LIGHTDIRSPECULAR",
				'u_PointLight.Position':"POINTLIGHTPOS",
				'u_PointLight.Range':"POINTLIGHTRANGE",
				'u_PointLight.Attenuation':"POINTLIGHTATTENUATION",
				'u_PointLight.Diffuse':"POINTLIGHTDIFFUSE",
				'u_PointLight.Ambient':"POINTLIGHTAMBIENT",
				'u_PointLight.Specular':"POINTLIGHTSPECULAR",
				'u_MaterialDiffuse':"MATERIALDIFFUSE",
				'u_MaterialAmbient':"MATERIALAMBIENT",
				'u_MaterialSpecular':"MATERIALSPECULAR",
				'u_MaterialReflect':"MATERIALREFLECT",
				'u_SpotLight.Position':"SPOTLIGHTPOS",
				'u_SpotLight.Direction':"SPOTLIGHTDIRECTION",
				'u_SpotLight.Range':"SPOTLIGHTRANGE",
				'u_SpotLight.Spot':"SPOTLIGHTSPOT",
				'u_SpotLight.Attenuation':"SPOTLIGHTATTENUATION",
				'u_SpotLight.Diffuse':"SPOTLIGHTDIFFUSE",
				'u_SpotLight.Ambient':"SPOTLIGHTAMBIENT",
				'u_SpotLight.Specular':"SPOTLIGHTSPECULAR"
			};
			var SIMPLE=Shader.nameKey.add("SIMPLE");
			vs="#include?VR \"VRHelper.glsl\";\nattribute vec4 a_Position;\nuniform mat4 u_MvpMatrix;\n\n\n\n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&(COLOR&&SPECULARMAP||NORMALMAP))\nattribute vec2 a_Texcoord0;\nvarying vec2 v_Texcoord0;\n  #ifdef MIXUV\n  attribute vec2 a_TexcoordNext0;\n  uniform float  u_UVAge;\n  #endif\n  #ifdef UVTRANSFORM \n  uniform mat4 u_UVMatrix;\n  #endif\n#endif\n\n#ifdef AMBIENTMAP\nattribute vec2 a_Texcoord1;\nvarying vec2 v_Texcoord1;\n#endif\n\n#ifdef COLOR\nattribute vec4 a_Color;\nvarying vec4 v_Color;\n#endif\n\n#ifdef BONE\nattribute vec4 a_BoneIndices;\nattribute vec4 a_BoneWeights;\nconst int c_MaxBoneCount = 24;\nuniform mat4 u_Bones[c_MaxBoneCount];\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\nattribute vec3 a_Normal;\nvarying vec3 v_Normal;\n#endif\n\n#ifdef (DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP)&&NORMALMAP\nattribute vec3 a_Tangent0;\nvarying vec3 v_Tangent0;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\nuniform mat4 u_WorldMat;\nvarying vec3 v_PositionWorld;\n#endif\n\n\nvoid main()\n{\n #ifdef BONE\n mat4 skinTransform=mat4(0.0);\n skinTransform += u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;\n skinTransform += u_Bones[int(a_BoneIndices.y)] * a_BoneWeights.y;\n skinTransform += u_Bones[int(a_BoneIndices.z)] * a_BoneWeights.z;\n skinTransform += u_Bones[int(a_BoneIndices.w)] * a_BoneWeights.w;\n vec4 position=skinTransform*a_Position;\n   #ifdef VR\n   gl_Position = DistortFishEye(u_MvpMatrix * position);\n   #else\n   gl_Position = u_MvpMatrix * position;\n   #endif\n #else\n   #ifdef VR\n   gl_Position = DistortFishEye(u_MvpMatrix * a_Position);\n   #else\n   gl_Position = u_MvpMatrix * a_Position;\n   #endif\n #endif\n \n\n #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\n mat3 worldMat;\n   #ifdef BONE\n   worldMat=mat3(u_WorldMat*skinTransform);\n   #else\n   worldMat=mat3(u_WorldMat);\n   #endif  \n v_Normal=worldMat*a_Normal;\n   #ifdef (DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&NORMALMAP\n   v_Tangent0=worldMat*a_Tangent0;\n   #endif\n #endif\n \n #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG\n   #ifdef BONE\n   v_PositionWorld=(u_WorldMat*position).xyz;\n   #else\n   v_PositionWorld=(u_WorldMat*a_Position).xyz;\n   #endif\n #endif\n \n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&(COLOR&&SPECULARMAP||NORMALMAP))\n  #ifdef MIXUV\n  v_Texcoord0=mix(a_Texcoord0,a_TexcoordNext0,u_UVAge);\n  #else\n  v_Texcoord0=a_Texcoord0;\n  #endif\n  #ifdef UVTRANSFORM\n  v_Texcoord0=(u_UVMatrix*vec4(v_Texcoord0,0.0,1.0)).xy;\n  #endif\n#endif\n\n#ifdef AMBIENTMAP\nv_Texcoord1=a_Texcoord1;\n#endif\n\n  \n#ifdef COLOR\nv_Color=a_Color;\n#endif\n}";
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\n#include?DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT \"LightHelper.glsl\";\n\nuniform vec4 u_Albedo;\n\n#ifdef ALPHATEST\nuniform float u_AlphaTestValue;\n#endif\n\n#ifdef DIFFUSEMAP\nuniform sampler2D u_DiffuseTexture;\n#endif\n\n#ifdef REFLECTMAP\nuniform samplerCube u_ReflectTexture;\nuniform vec3 u_MaterialReflect;\n#endif\n\n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&(COLOR&&SPECULARMAP||NORMALMAP))\nvarying vec2 v_Texcoord0;\n#endif\n\n#ifdef AMBIENTMAP\nvarying vec2 v_Texcoord1;\nuniform sampler2D u_AmbientTexture;\n#endif\n\n#ifdef COLOR\nvarying vec4 v_Color;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\nuniform vec3 u_MaterialDiffuse;\nuniform vec4 u_MaterialSpecular;\n  #ifdef (DIFFUSEMAP||COLOR)&&SPECULARMAP \n  uniform sampler2D u_SpecularTexture;\n  #endif\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||AMBIENTMAP\nuniform vec3 u_MaterialAmbient;\n#endif\n\n#ifdef FOG\nuniform float u_FogStart;\nuniform float u_FogRange;\nuniform vec3 u_FogColor;\n#endif\n\n#ifdef MIXUV\nuniform float  u_UVAniAge;\n#endif\n\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\nvarying vec3 v_Normal;\n#endif\n\n#ifdef (DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&NORMALMAP\nuniform sampler2D u_NormalTexture;\nvarying vec3 v_Tangent0;\n#endif\n\n#ifdef DIRECTIONLIGHT\nuniform DirectionLight u_DirectionLight;\n#endif\n\n#ifdef POINTLIGHT\nuniform PointLight u_PointLight;\n#endif\n\n#ifdef SPOTLIGHT\nuniform SpotLight u_SpotLight;\n#endif\n\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\nuniform vec3 u_CameraPos;\nvarying vec3 v_PositionWorld;\n#endif\n\n\nvoid main()\n{\n  #ifdef DIFFUSEMAP&&!COLOR\n  gl_FragColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n  #endif \n  \n  #ifdef COLOR&&!DIFFUSEMAP\n  gl_FragColor=v_Color;\n  #endif \n  \n  #ifdef DIFFUSEMAP&&COLOR\n  vec4 texColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n  gl_FragColor=texColor*v_Color;\n  #endif\n  \n  #ifdef !DIFFUSEMAP&&!COLOR\n  gl_FragColor=vec4(1.0,1.0,1.0,1.0);\n  #endif \n  \n  #ifdef AMBIENTMAP\n  gl_FragColor.rgb=gl_FragColor.rgb*(u_MaterialAmbient+texture2D(u_AmbientTexture, v_Texcoord1).rgb);\n  #endif \n  \n  gl_FragColor=gl_FragColor*u_Albedo;\n  \n  #ifdef ALPHATEST\n  if(gl_FragColor.a-u_AlphaTestValue<0.0)\n    discard;\n  #endif\n  \n  \n  #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\n  vec3 normal;\n    #ifdef (DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&NORMALMAP\n    vec3 normalMapSample = texture2D(u_NormalTexture, v_Texcoord0).rgb;\n	normal = normalize(NormalSampleToWorldSpace(normalMapSample, v_Normal, v_Tangent0));\n	#else\n	normal = normalize(v_Normal);\n    #endif\n  #endif\n	\n  #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\n  vec3 diffuse = vec3(0.0);\n  vec3 ambient = vec3(0.0);\n  vec3 specular= vec3(0.0);\n  vec3 dif, amb, spe;\n  #endif\n  \n  #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\n  vec3 toEye;\n    #ifdef FOG\n	toEye=u_CameraPos-v_PositionWorld;\n    float toEyeLength=length(toEye);\n    toEye/=toEyeLength;\n    #else\n	toEye=normalize(u_CameraPos-v_PositionWorld);\n    #endif\n  #endif\n	\n  #ifdef DIRECTIONLIGHT\n  computeDirectionLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_DirectionLight,normal,toEye, dif, amb, spe);\n  diffuse+=dif;\n  ambient+=amb;\n  specular+=spe;\n  #endif\n \n  #ifdef POINTLIGHT\n  computePointLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_PointLight,v_PositionWorld,normal,toEye, dif, amb, spe);\n  diffuse+=dif;\n  ambient+=amb;\n  specular+=spe;\n  #endif\n\n  #ifdef SPOTLIGHT\n  ComputeSpotLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_SpotLight,v_PositionWorld,normal,toEye, dif, amb, spe);\n  diffuse+=dif;\n  ambient+=amb;\n  specular+=spe;\n  #endif\n  \n\n  \n  \n  \n  #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\n    #ifdef (DIFFUSEMAP||COLOR)&&SPECULARMAP\n    specular =specular*texture2D(u_SpecularTexture, v_Texcoord0).rgb;\n    #endif\n  gl_FragColor =vec4( gl_FragColor.rgb*(ambient + diffuse) + specular,gl_FragColor.a);\n  #endif\n  \n  #ifdef REFLECTMAP\n  vec3 incident = -toEye;\n  vec3 reflectionVector = reflect(incident,normal);\n  vec3 reflectionColor  = textureCube(u_ReflectTexture,reflectionVector).rgb;\n  gl_FragColor.rgb += u_MaterialReflect*reflectionColor;\n  #endif\n  \n  #ifdef FOG\n  float lerpFact=clamp((toEyeLength-u_FogStart)/u_FogRange,0.0,1.0);\n  gl_FragColor.rgb=mix(gl_FragColor.rgb,u_FogColor,lerpFact);\n  #endif\n}\n\n";
			Shader.preCompile(SIMPLE ,vs,ps,shaderNameMap);
			var SIMPLEVEXTEX=Shader.nameKey.add("SIMPLEVEXTEX");
			vs="#include?DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT \"LightHelper.glsl\";\n\nattribute vec4 a_Position;\nuniform mat4 u_MvpMatrix;\n\n#include?VR \"VRHelper.glsl\";\n\n\n\n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&COLOR&&SPECULARMAP)\nattribute vec2 a_Texcoord0;\nvarying vec2 v_Texcoord0;\n  #ifdef MIXUV\n  attribute vec2 a_TexcoordNext0;\n  uniform float  u_UVAge;\n  #endif\n  #ifdef UVTRANSFORM\n  uniform mat4 u_UVMatrix;\n  #endif\n#endif\n\n#ifdef AMBIENTMAP\nattribute vec2 a_Texcoord1;\nvarying vec2 v_Texcoord1;\n#endif\n\n\n#ifdef COLOR\nattribute vec4 a_Color;\nvarying vec4 v_Color;\n#endif\n\n#ifdef BONE\nattribute vec4 a_BoneIndices;\nattribute vec4 a_BoneWeights;\nconst int c_MaxBoneCount = 24;\nuniform mat4 u_Bones[c_MaxBoneCount];\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\nattribute vec3 a_Normal;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\nuniform mat4 u_WorldMat;\nuniform vec3 u_CameraPos;\n#endif\n\n#ifdef DIRECTIONLIGHT\nuniform DirectionLight u_DirectionLight;\n#endif\n\n#ifdef POINTLIGHT\nuniform PointLight u_PointLight;\n#endif\n\n#ifdef SPOTLIGHT\nuniform SpotLight u_SpotLight;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\nuniform vec3 u_MaterialDiffuse;\nuniform vec4 u_MaterialSpecular;\n\nvarying vec3 v_Diffuse;\nvarying vec3 v_Ambient;\nvarying vec3 v_Specular;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||AMBIENTMAP\nuniform vec3 u_MaterialAmbient;\n#endif\n\n#ifdef FOG\nvarying float v_ToEyeLength;\n#endif\n\n#ifdef REFLECTMAP\nvarying vec3 v_ToEye;\nvarying vec3 v_Normal;\n#endif\n\n\nvoid main()\n{\n #ifdef BONE\n mat4 skinTransform=mat4(0.0);\n skinTransform += u_Bones[int(a_BoneIndices.x)] * a_BoneWeights.x;\n skinTransform += u_Bones[int(a_BoneIndices.y)] * a_BoneWeights.y;\n skinTransform += u_Bones[int(a_BoneIndices.z)] * a_BoneWeights.z;\n skinTransform += u_Bones[int(a_BoneIndices.w)] * a_BoneWeights.w;\n vec4 position=skinTransform*a_Position;\n   #ifdef VR\n   gl_Position = DistortFishEye(u_MvpMatrix * position);\n   #else\n   gl_Position = u_MvpMatrix * position;\n   #endif\n #else\n   #ifdef VR\n   gl_Position = DistortFishEye(u_MvpMatrix * a_Position);\n   #else\n   gl_Position = u_MvpMatrix * a_Position;\n   #endif\n #endif\n \n \n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||REFLECTMAP\n  #ifdef BONE\n  vec3 normal=normalize( mat3(u_WorldMat*skinTransform)*a_Normal);\n  #else\n  vec3 normal=normalize( mat3(u_WorldMat)*a_Normal);\n  #endif\n \n  #ifdef REFLECTMAP\n  v_Normal=normal;\n  #endif\n#endif\n \n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\n  v_Diffuse=vec3(0.0);\n  v_Ambient=vec3(0.0);\n  v_Specular=vec3(0.0);\n  vec3 dif, amb, spe;\n#endif\n\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\n  #ifdef BONE\n  vec3 positionWorld=(u_WorldMat*position).xyz;\n  #else\n  vec3 positionWorld=(u_WorldMat*a_Position).xyz;\n  #endif\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||FOG||REFLECTMAP\nvec3 toEye;\n  #ifdef FOG\n  toEye=u_CameraPos-positionWorld;\n  v_ToEyeLength=length(toEye);\n  toEye/=v_ToEyeLength;\n  #else\n  toEye=normalize(u_CameraPos-positionWorld);\n  #endif\n \n  #ifdef REFLECTMAP\n  v_ToEye=toEye;\n  #endif\n#endif\n \n#ifdef DIRECTIONLIGHT\ncomputeDirectionLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_DirectionLight,normal,toEye, dif, amb, spe);\nv_Diffuse+=dif;\nv_Ambient+=amb;\nv_Specular+=spe;\n#endif\n \n#ifdef POINTLIGHT\ncomputePointLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_PointLight,positionWorld,normal,toEye, dif, amb, spe);\nv_Diffuse+=dif;\nv_Ambient+=amb;\nv_Specular+=spe;\n#endif\n\n#ifdef SPOTLIGHT\nComputeSpotLight(u_MaterialDiffuse,u_MaterialAmbient,u_MaterialSpecular,u_SpotLight,positionWorld,normal,toEye, dif, amb, spe);\nv_Diffuse+=dif;\nv_Ambient+=amb;\nv_Specular+=spe;\n#endif\n  \n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&COLOR&&SPECULARMAP)\n  #ifdef MIXUV\n  v_Texcoord0=mix(a_Texcoord0,a_TexcoordNext0,u_UVAge);\n  #else\n  v_Texcoord0=a_Texcoord0;\n  #endif\n  #ifdef UVTRANSFORM\n  v_Texcoord0=(u_UVMatrix*vec4(v_Texcoord0,0.0,1.0)).xy;\n  #endif\n#endif\n\n#ifdef AMBIENTMAP\nv_Texcoord1=a_Texcoord1;\n#endif\n  \n#ifdef COLOR\nv_Color=a_Color;\n#endif\n}";
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform vec4 u_Albedo;\n\n#ifdef ALPHATEST\nuniform float u_AlphaTestValue;\n#endif\n\n#ifdef DIFFUSEMAP\nuniform sampler2D u_DiffuseTexture;\n#endif\n\n#ifdef REFLECTMAP\nuniform samplerCube u_ReflectTexture;\nuniform vec3 u_MaterialReflect;\n#endif\n\n\n#ifdef DIFFUSEMAP||((DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT)&&COLOR&&SPECULARMAP)\nvarying vec2 v_Texcoord0;\n#endif\n\n#ifdef AMBIENTMAP\nvarying vec2 v_Texcoord1;\nuniform sampler2D u_AmbientTexture;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT||AMBIENTMAP\nuniform vec3 u_MaterialAmbient;\n#endif\n\n#ifdef COLOR\nvarying vec4 v_Color;\n#endif\n\n#ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\nvarying vec3 v_Diffuse;\nvarying vec3 v_Ambient;\nvarying vec3 v_Specular;\n  #ifdef (DIFFUSEMAP||COLOR)&&SPECULARMAP\n  uniform sampler2D u_SpecularTexture;\n  #endif\n#endif\n\n#ifdef FOG\nuniform float u_FogStart;\nuniform float u_FogRange;\nuniform vec3 u_FogColor;\nvarying float v_ToEyeLength;\n#endif\n\n#ifdef MIXUV\nuniform float  u_UVAniAge;\n#endif\n\n#ifdef REFLECTMAP\nvarying vec3 v_Normal;\nvarying vec3 v_ToEye;\n#endif\n\n\nvoid main()\n{\n #ifdef DIFFUSEMAP&&!COLOR\n gl_FragColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n #endif \n \n #ifdef COLOR&&!DIFFUSEMAP\n gl_FragColor=v_Color;\n #endif \n \n #ifdef DIFFUSEMAP&&COLOR\n vec4 texColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n gl_FragColor=texColor*v_Color;\n #endif\n \n #ifdef !DIFFUSEMAP&&!COLOR\n gl_FragColor=vec4(1.0,1.0,1.0,1.0);\n #endif \n \n #ifdef AMBIENTMAP\n gl_FragColor.rgb=gl_FragColor.rgb*(u_MaterialAmbient+texture2D(u_AmbientTexture, v_Texcoord1).rgb);\n #endif \n \n gl_FragColor=gl_FragColor*u_Albedo;\n  \n #ifdef ALPHATEST\n   if(gl_FragColor.a-u_AlphaTestValue<0.0)\n    discard;\n #endif\n \n \n #ifdef REFLECTMAP\n vec3 normal=normalize(v_Normal);\n #endif 	\n\n  \n #ifdef DIRECTIONLIGHT||POINTLIGHT||SPOTLIGHT\n   #ifdef (DIFFUSEMAP||COLOR)&&SPECULARMAP\n   vec3 specular =v_Specular*texture2D(u_SpecularTexture,v_Texcoord0).rgb;\n   gl_FragColor =vec4( gl_FragColor.rgb*(v_Ambient + v_Diffuse)+specular,gl_FragColor.a);\n   #else\n   gl_FragColor =vec4( gl_FragColor.rgb*(v_Ambient + v_Diffuse)+v_Specular,gl_FragColor.a);\n   #endif\n #endif\n \n #ifdef REFLECTMAP\n vec3 incident = -v_ToEye;\n vec3 reflectionVector = reflect(incident,v_Normal);\n vec3 reflectionColor  = textureCube(u_ReflectTexture,reflectionVector).rgb;\n gl_FragColor.rgb += u_MaterialReflect*reflectionColor;\n #endif\n \n #ifdef FOG\n float lerpFact=clamp((v_ToEyeLength-u_FogStart)/u_FogRange,0.0,1.0);\n gl_FragColor.rgb=mix(gl_FragColor.rgb,u_FogColor,lerpFact);\n #endif\n}\n\n";
			Shader.preCompile(SIMPLEVEXTEX,vs,ps,shaderNameMap);
			shaderNameMap={
				'a_Position':"POSITION",
				'a_Texcoord':"UV",
				'u_FogStart':"FOGSTART",
				'u_FogRange':"FOGRANGE",
				'u_FogColor':"FOGCOLOR",
				'u_WorldMat':"MATRIX1",
				'u_CameraPos':"CAMERAPOS",
				'u_BlendTexture':"DIFFUSETEXTURE",
				'u_LayerTexture0':"NORMALTEXTURE",
				'u_LayerTexture1':"SPECULARTEXTURE",
				'u_LayerTexture2':"EMISSIVETEXTURE",
				'u_LayerTexture3':"AMBIENTTEXTURE",
				'u_MvpMatrix':"MVPMATRIX",
				'u_Albedo':"ALBEDO",
				'u_Ambient':"MATERIALAMBIENT",
				'u_UVMatrix':"MATRIX2"
			};
			var TERRAIN=Shader.nameKey.add("TERRAIN");
			vs="#include?VR \"VRHelper.glsl\";\nattribute vec4 a_Position;\nuniform mat4 u_MvpMatrix;\nuniform mat4 u_UVMatrix;\n\n#ifdef DIFFUSEMAP&&NORMALMAP&&SPECULARMAP&&EMISSIVEMAP&&AMBIENTMAP\nattribute vec2 a_Texcoord;\nvarying vec2 v_Texcoord;\nvarying vec2 v_TiledTexcoord;\n#endif\n\n#ifdef FOG\nuniform mat4 u_WorldMat;\nvarying vec3 v_PositionWorld;\n#endif\n\n\nvoid main()\n{\n #ifdef VR\n gl_Position = DistortFishEye(u_MvpMatrix * a_Position);\n #else\n gl_Position = u_MvpMatrix * a_Position;\n #endif\n \n #ifdef FOG\n v_PositionWorld=(u_WorldMat*a_Position).xyz;\n #endif\n \n #ifdef DIFFUSEMAP&&NORMALMAP&&SPECULARMAP&&EMISSIVEMAP&&AMBIENTMAP\n v_Texcoord=a_Texcoord;\n v_TiledTexcoord=(u_UVMatrix*vec4(a_Texcoord,0.0,1.0)).xy;\n #endif\n}";
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform vec4 u_Albedo;\nuniform vec3 u_Ambient;\n\n#ifdef FOG\nuniform vec3 u_CameraPos;\nvarying vec3 v_PositionWorld;\n\nuniform float u_FogStart;\nuniform float u_FogRange;\nuniform vec3 u_FogColor;\n#endif\n\n#ifdef DIFFUSEMAP&&NORMALMAP&&SPECULARMAP&&EMISSIVEMAP&&AMBIENTMAP\n  varying vec2 v_Texcoord;\n  varying vec2 v_TiledTexcoord;\n  uniform sampler2D u_BlendTexture;\n  uniform sampler2D u_LayerTexture0;\n  uniform sampler2D u_LayerTexture1;\n  uniform sampler2D u_LayerTexture2;\n  uniform sampler2D u_LayerTexture3;\n#endif\n\nvoid main()\n{	\n  #ifdef DIFFUSEMAP&&NORMALMAP&&SPECULARMAP&&EMISSIVEMAP&&AMBIENTMAP\n  vec4 blend=texture2D(u_BlendTexture, v_Texcoord);\n  vec4 c0=texture2D(u_LayerTexture0, v_TiledTexcoord);\n  vec4 c1=texture2D(u_LayerTexture1, v_TiledTexcoord);\n  vec4 c2=texture2D(u_LayerTexture2, v_TiledTexcoord);\n  vec4 c3=texture2D(u_LayerTexture3, v_TiledTexcoord);\n  vec4 texColor = c0;\n  texColor = mix(texColor, c1, blend.r);\n  texColor = mix(texColor, c2, blend.g);\n  texColor = mix(texColor, c3, blend.b);\n  gl_FragColor=vec4(texColor.rgb*u_Ambient.rgb*blend.a,1.0);\n  gl_FragColor=gl_FragColor*u_Albedo;\n  #endif \n  \n  #ifdef FOG\n  vec3 toEye=u_CameraPos-v_PositionWorld;\n  float toEyeLength=length(toEye);\n  \n  float lerpFact=clamp((toEyeLength-u_FogStart)/u_FogRange,0.0,1.0);\n  gl_FragColor.rgb=mix(gl_FragColor.rgb,u_FogColor,lerpFact);\n  #endif\n}\n\n";
			Shader.preCompile(TERRAIN,vs,ps,shaderNameMap);
			shaderNameMap={
				'a_CornerTextureCoordinate':"CORNERTEXTURECOORDINATE",
				'a_Position':"POSITION",
				'a_Velocity':"VELOCITY",
				'a_StartColor':"STARTCOLOR",
				'a_EndColor':"ENDCOLOR",
				'a_SizeRotation':"SIZEROTATION",
				'a_Radius':"RADIUS",
				'a_Radian':"RADIAN",
				'a_AgeAddScale':"AGEADDSCALE",
				'a_Time':"TIME",
				'u_WorldMat':"MVPMATRIX",
				'u_View':"MATRIX1",
				'u_Projection':"MATRIX2",
				'u_ViewportScale':"VIEWPORTSCALE",
				'u_CurrentTime':"CURRENTTIME",
				'u_Duration':"DURATION",
				'u_Gravity':"GRAVITY",
				'u_EndVelocity':"ENDVELOCITY",
				'u_texture':"DIFFUSETEXTURE"
			};
			var PARTICLE=Shader.nameKey.add("PARTICLE");
			Shader.preCompile(PARTICLE,ParticleShader.vs,ParticleShader.ps,shaderNameMap);
			shaderNameMap={
				'a_CornerTextureCoordinate':"CORNERTEXTURECOORDINATE",
				'a_Position':"POSITION",
				'a_Velocity':"VELOCITY",
				'a_StartColor':"STARTCOLOR",
				'a_EndColor':"ENDCOLOR",
				'a_SizeRotation':"SIZEROTATION",
				'a_Radius':"RADIUS",
				'a_Radian':"RADIAN",
				'a_AgeAddScale':"AGEADDSCALE",
				'a_Time':"TIME",
				'u_WorldMat':"MVPMATRIX",
				'u_View':"MATRIX1",
				'u_Projection':"MATRIX2",
				'u_ViewportScale':"VIEWPORTSCALE",
				'u_CurrentTime':"CURRENTTIME",
				'u_Duration':"DURATION",
				'u_Gravity':"GRAVITY",
				'u_EndVelocity':"ENDVELOCITY",
				'u_texture':"DIFFUSETEXTURE"
			};
			var U3DPARTICLE=Shader.nameKey.add("U3DPARTICLE");
			Shader.preCompile(U3DPARTICLE,ParticleShader.vs,ParticleShader.ps,shaderNameMap);
			shaderNameMap={
				'a_Position':"POSITION",
				'a_Texcoord0':"UV",
				'a_Time':"TIME",
				'u_Texture':"DIFFUSETEXTURE",
				'u_MvpMatrix':"MVPMATRIX",
				'u_Albedo':"ALBEDO",
				'u_CurrentTime':"CURRENTTIME",
				'u_Color':"UNICOLOR" ,
				'u_Duration':"DURATION"
			};
			var GLITTER=Shader.nameKey.add("GLITTER");
			vs="attribute vec4 a_Position;\nattribute vec2 a_Texcoord0;\nattribute float a_Time;\n\nuniform mat4 u_MvpMatrix;\nuniform  float u_CurrentTime;\nuniform  vec4 u_Color;\nuniform float u_Duration;\n\nvarying vec2 v_Texcoord;\nvarying vec4 v_Color;\n\n\nvoid main()\n{\n  gl_Position = u_MvpMatrix * a_Position;\n  \n  float age = u_CurrentTime-a_Time;\n  float normalizedAge = clamp(age / u_Duration,0.0,1.0);\n   \n  v_Texcoord=a_Texcoord0;\n  \n  v_Color=u_Color;\n  v_Color.a*=1.0-normalizedAge;\n}\n";
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform vec4 u_Albedo;\nuniform sampler2D u_Texture;\n\nvarying vec2 v_Texcoord;\nvarying vec4 v_Color;\n\n\nvoid main()\n{	\n  gl_FragColor=texture2D(u_Texture, v_Texcoord)*v_Color;\n  gl_FragColor=gl_FragColor*u_Albedo;\n}\n\n";
			Shader.preCompile(GLITTER,vs,ps,shaderNameMap);
			shaderNameMap={
				'a_Position':"POSITION",
				'a_Color':"COLOR",
				'a_Texcoord0':"UV",
				'a_TexcoordNext0':"NEXTUV",
				'a_Texcoord1':"UV1",
				'a_TexcoordNext1':"NEXTUV1",
				'u_DiffuseTexture':"DIFFUSETEXTURE",
				'u_SpecularTexture':"SPECULARTEXTURE",
				'u_MvpMatrix':"MVPMATRIX",
				'u_FogStart':"FOGSTART",
				'u_FogRange':"FOGRANGE",
				'u_FogColor':"FOGCOLOR",
				'u_Albedo':"ALBEDO",
				'u_UVAge':"FLOAT0",
				'u_UVAniAge':"UVAGEX"
			};
			var SIMPLE_EFFECT=Shader.nameKey.add("SIMPLE_EFFECT");
			vs="attribute vec4 a_Position;\nuniform mat4 u_MvpMatrix;\n\n#ifdef DIFFUSEMAP\nattribute vec2 a_Texcoord0;\nattribute vec2 a_Texcoord1;\nvarying vec2 v_Texcoord0;\nvarying vec2 v_Texcoord1;\n#ifdef MIXUV\nattribute vec2 a_TexcoordNext0;\nattribute vec2 a_TexcoordNext1;\nuniform float  u_UVAge;\n#endif\n#endif\n\n#ifdef COLOR\nattribute vec4 a_Color;\nvarying vec4 v_Color;\n#endif\n\n\nvoid main()\n{\n gl_Position = u_MvpMatrix * a_Position;\n \n \n #ifdef DIFFUSEMAP\n  #ifdef MIXUV\n  v_Texcoord0=mix(a_Texcoord0,a_TexcoordNext0,u_UVAge);\n   v_Texcoord1=mix(a_Texcoord1,a_TexcoordNext1,u_UVAge);\n  #else\n  v_Texcoord0=a_Texcoord0;\n  v_Texcoord1=a_Texcoord1;\n  #endif\n #endif\n  \n #ifdef COLOR\n v_Color=a_Color;\n #endif\n}";
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform float u_Luminance;\n\n#ifdef DIFFUSEMAP\nvarying vec2 v_Texcoord0;\nuniform sampler2D u_DiffuseTexture;\n#endif\n\n#ifdef SPECULARMAP \nvarying vec2 v_Texcoord1;\nuniform sampler2D u_SpecularTexture;\n#endif\n\n#ifdef COLOR\nvarying vec4 v_Color;\n#endif\n\n\n\n#ifdef FOG\nuniform float u_FogStart;\nuniform float u_FogRange;\nuniform vec3 u_FogColor;\n#endif\n\nvoid main()\n{\n  \n  #ifdef DIFFUSEMAP&&!COLOR\n  gl_FragColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n  #endif \n  \n  #ifdef COLOR&&!DIFFUSEMAP\n  gl_FragColor=v_Color;\n  #endif \n  \n  #ifdef DIFFUSEMAP&&COLOR\n  vec4 texColor=texture2D(u_DiffuseTexture, v_Texcoord0);\n  gl_FragColor=texColor*v_Color;\n  #endif\n  \n  #ifdef SPECULARMAP \n  vec4 specularColor=texture2D(u_SpecularTexture, v_Texcoord1);\n  gl_FragColor=gl_FragColor*specularColor;\n  #endif\n \n  gl_FragColor.rgb=gl_FragColor.rgb*u_Luminance;\n  \n  #ifdef FOG\n  float lerpFact=clamp((toEyeLength-u_FogStart)/u_FogRange,0.0,1.0);\n  gl_FragColor.rgb=mix(gl_FragColor.rgb,u_FogColor,lerpFact);\n  #endif\n}\n\n";
			Shader.preCompile(SIMPLE_EFFECT ,vs,ps,shaderNameMap);
			shaderNameMap={
				'a_Position':"POSITION",
				'u_MvpMatrix':"MVPMATRIX",
				'u_Intensity':"INTENSITY",
				'u_AlphaBlending':"ALPHABLENDING",
				'u_CubeTexture':"DIFFUSETEXTURE"
			};
			var skyBox=Shader.nameKey.add("SkyBox");
			vs="attribute vec4 a_Position;\nuniform mat4 u_MvpMatrix;\nvarying vec3 v_Texcoord;\n\n\nvoid main()\n{\n  gl_Position = (u_MvpMatrix*a_Position).xyww;\n  v_Texcoord=a_Position.xyz;\n}\n";
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform float u_Intensity;\nuniform float u_AlphaBlending;\nuniform samplerCube u_CubeTexture;\n\nvarying vec3 v_Texcoord;\n\n\nvoid main()\n{	\n  gl_FragColor=vec4(textureCube(u_CubeTexture, v_Texcoord).rgb*u_Intensity,u_AlphaBlending);\n}\n\n";
			Shader.preCompile(skyBox ,vs,ps,shaderNameMap);
			shaderNameMap={
				'a_Position':"POSITION",
				'a_Texcoord0':"UV",
				'u_MvpMatrix':"MVPMATRIX",
				'u_Intensity':"INTENSITY",
				'u_AlphaBlending':"ALPHABLENDING",
				'u_texture':"DIFFUSETEXTURE"
			};
			var skyDome=Shader.nameKey.add("SkyDome");
			vs="attribute vec4 a_Position;\nattribute vec2 a_Texcoord0;\nuniform mat4 u_MvpMatrix;\nvarying vec2 v_Texcoord;\n\n\nvoid main()\n{\n  gl_Position = (u_MvpMatrix*a_Position).xyww;\n  v_Texcoord = a_Texcoord0;\n}\n";
			ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nuniform float u_Intensity;\nuniform float u_AlphaBlending;\nuniform sampler2D u_texture;\n\nvarying vec2 v_Texcoord;\n\n\nvoid main()\n{	\n  gl_FragColor=vec4(texture2D(u_texture, v_Texcoord).rgb*u_Intensity,u_AlphaBlending);\n}\n\n";
			Shader.preCompile(skyDome,vs,ps,shaderNameMap);
		}

		Laya3D._regClassforJson=function(){
			ClassUtils.regClass("Sprite3D",Sprite3D);
			ClassUtils.regClass("MeshSprite3D",MeshSprite3D);
			ClassUtils.regClass("Material",BaseMaterial);
		}

		Laya3D._loadTexture2D=function(loader){
			var url=loader.url;
			var preBasePath=URL.basePath;
			URL.basePath=URL.getPath(url);
			var texture2D=new Texture2D(url);
			URL.basePath=preBasePath;
			texture2D.on("loaded",null,function(tex2D){
				loader.endLoad(tex2D);
			});
		}

		Laya3D._loadTextureCube=function(loader){
			var urls=loader.url.split(',');
			var preBasePath=URL.basePath;
			URL.basePath=URL.getPath(urls[0]);
			var textureCube=new TextureCube(urls);
			URL.basePath=preBasePath;
			textureCube.on("loaded",null,function(imgCube){
				loader.endLoad(imgCube);
			});
		}

		Laya3D.init=function(width,height,antialias){
			(antialias===void 0)&& (antialias=false);
			if (!WebGL.enable()){
				alert("Laya3D init err,must support webGL!");
				return;
			}
			Loader.parserMap["texture2d"]=Laya3D._loadTexture2D;
			Loader.parserMap["texturecube"]=Laya3D._loadTextureCube;
			RunDriver.changeWebGLSize=function (width,height){
				WebGL.onStageResize(width,height);
				RenderState.clientWidth=width;
				RenderState.clientHeight=height;
			}
			Config.isAntialias=antialias;
			Render.is3DMode=true;
			Laya.init(width,height);
			Layer.__init__();
			ShaderDefines3D.__init__();
			Laya3D._initShader();
			Laya3D._regClassforJson();
		}

		return Laya3D;
	})()


	/**
	*<code>BaseMaterial</code> 类用于创建材质,抽象类,不允许实例。
	*/
	//class laya.d3.core.material.BaseMaterial extends laya.events.EventDispatcher
	var BaseMaterial=(function(_super){
		function BaseMaterial(){
			this._id=0;
			this._loaded=true;
			this._renderQueue=0;
			this._renderMode=0;
			this._sharderNameID=0;
			this._shaderDefine=0;
			this._disableShaderDefine=0;
			this._shaderValues=null;
			this._textures=null;
			this._colors=null;
			this._numbers=null;
			this._matrix4x4s=null;
			this._textureSharderIndices=null;
			this._colorSharderIndices=null;
			this._numberSharderIndices=null;
			this._matrix4x4SharderIndices=null;
			this._isInstance=false;
			this.name=null;
			this.shader=null;
			BaseMaterial.__super.call(this);
			this._id=++BaseMaterial._uniqueIDCounter;
			this._shaderDefine=0;
			this._disableShaderDefine=0;
			this._shaderValues=new ValusArray();
			this._textures=[];
			this._colors=[];
			this._numbers=[];
			this._matrix4x4s=[];
			this._textureSharderIndices=[];
			this._colorSharderIndices=[];
			this._numberSharderIndices=[];
			this._matrix4x4SharderIndices=[];
			this.renderMode=1;
		}

		__class(BaseMaterial,'laya.d3.core.material.BaseMaterial',_super);
		var __proto=BaseMaterial.prototype;
		/**
		*@private
		*/
		__proto._eventLoaded=function(){
			this._loaded=true;
			this.event("loaded",this);
		}

		/**
		*@private
		*/
		__proto._uploadTextures=function(){
			for (var i=0,n=this._textures.length;i < n;i++){
				var texture=this._textures[i];
				if (texture){
					var source=texture.source;
					(source)? this._uploadTexture(i,source):this._uploadTexture(i,SolidColorTexture2D.pickTexture.source);
				}
			}
		}

		/**
		*获取Shader。
		*@param state 相关渲染状态。
		*@return Shader。
		*/
		__proto._getShader=function(state,vertexDeclaration){
			var shaderDefs=state.shaderDefs;
			var shaderDefsValue=state.shaderDefs._value;
			shaderDefsValue |=vertexDeclaration.shaderDefine | this._shaderDefine;
			this._disableShaderDefine && (shaderDefsValue=shaderDefsValue & (~this._disableShaderDefine));
			shaderDefs._value=shaderDefsValue;
			var nameID=shaderDefs._value+this._sharderNameID *0.0002;
			this.shader=Shader.withCompile(this._sharderNameID,shaderDefs.toNameDic(),nameID,null);
		}

		/**
		*@private
		*/
		__proto._uploadTexture=function(shaderIndex,textureSource){
			this._shaderValues.data[this._textureSharderIndices[shaderIndex]]=textureSource;
		}

		/**
		*增加Shader宏定义。
		*@param value 宏定义。
		*/
		__proto._addShaderDefine=function(value){
			this._shaderDefine |=value;
		}

		/**
		*移除Shader宏定义。
		*@param value 宏定义。
		*/
		__proto._removeShaderDefine=function(value){
			this._shaderDefine &=~value;
		}

		/**
		*增加禁用宏定义。
		*@param value 宏定义。
		*/
		__proto._addDisableShaderDefine=function(value){
			this._disableShaderDefine |=value;
		}

		/**
		*移除禁用宏定义。
		*@param value 宏定义。
		*/
		__proto._removeDisableShaderDefine=function(value){
			this._disableShaderDefine &=~value;
		}

		__proto._setMatrix4x4=function(matrix4x4Index,shaderName,matrix4x4){
			var shaderValue=this._shaderValues;
			var index=this._matrix4x4SharderIndices[matrix4x4Index];
			if (!index && matrix4x4){
				this._matrix4x4SharderIndices[matrix4x4Index]=index=shaderValue.length+1;
				shaderValue.pushValue(shaderName,null);
			}
			shaderValue.data[index]=matrix4x4.elements;
			this._matrix4x4s[matrix4x4Index]=matrix4x4;
		}

		__proto._getMatrix4x4=function(matrix4x4Index){
			return this._matrix4x4s[matrix4x4Index];
		}

		__proto._setNumber=function(numberIndex,shaderName,number){
			var shaderValue=this._shaderValues;
			var index=this._numberSharderIndices[numberIndex];
			if (!index && number){
				this._numberSharderIndices[numberIndex]=index=shaderValue.length+1;
				shaderValue.pushValue(shaderName,null);
			}
			shaderValue.data[index]=number;
			this._numbers[numberIndex]=number;
		}

		__proto._getNumber=function(numberIndex){
			return this._numbers[numberIndex];
		}

		__proto._setColor=function(colorIndex,shaderName,color){
			var shaderValue=this._shaderValues;
			var index=this._colorSharderIndices[colorIndex];
			if (!index && color){
				this._colorSharderIndices[colorIndex]=index=shaderValue.length+1;
				shaderValue.pushValue(shaderName,null);
			}
			shaderValue.data[index]=color.elements;
			this._colors[colorIndex]=color;
		}

		__proto._getColor=function(colorIndex){
			return this._colors[colorIndex];
		}

		/**
		*设置纹理。
		*/
		__proto._setTexture=function(texture,textureIndex,shaderName){
			var shaderValue=this._shaderValues;
			var index=this._textureSharderIndices[textureIndex];
			if (!index && texture){
				this._textureSharderIndices[textureIndex]=index=shaderValue.length+1;
				shaderValue.pushValue(shaderName,null);
			}
			this._textures[textureIndex]=texture;
		}

		/**
		*获取纹理。
		*/
		__proto._getTexture=function(textureIndex){
			return this._textures[textureIndex];
		}

		/**
		*上传材质。
		*@param state 相关渲染状态。
		*@param bufferUsageShader Buffer相关绑定。
		*@param shader 着色器。
		*@return 是否成功。
		*/
		__proto._upload=function(state,vertexDeclaration,bufferUsageShader){
			this._uploadTextures();
			this._getShader(state,vertexDeclaration);
			var shaderValue=state.shaderValue;
			shaderValue.pushArray(this._shaderValues);
			this.shader.uploadArray(shaderValue.data,shaderValue.length,bufferUsageShader);
		}

		/**
		*设置使用Shader名字。
		*@param name 名称。
		*/
		__proto.setShaderName=function(name){
			this._sharderNameID=Shader.nameKey.get(name);
		}

		__proto._setLoopShaderParams=function(state,projectionView,worldMatrix,mesh,material){
			throw new Error("Marterial:must override it.");
		}

		/**
		*复制材质
		*@param dec 目标材质
		*/
		__proto.copy=function(dec){
			dec._loaded=this._loaded;
			dec._renderQueue=this._renderQueue;
			dec._renderMode=this._renderMode;
			dec._textures=this._textures.slice();
			dec._colors=this._colors.slice();
			dec._numbers=this._numbers.slice();
			dec._matrix4x4s=this._matrix4x4s.slice();
			dec._textureSharderIndices=this._textureSharderIndices.slice();
			dec._colorSharderIndices=this._colorSharderIndices.slice();
			dec._numberSharderIndices=this._numberSharderIndices.slice();
			dec.shader=this.shader;
			dec._sharderNameID=this._sharderNameID;
			dec._disableShaderDefine=this._disableShaderDefine;
			dec._shaderDefine=this._shaderDefine;
			dec.name=this.name;
			this._shaderValues.copyTo(dec._shaderValues);
			return dec;
		}

		/**
		*获取唯一标识ID(通常用于优化或识别)。
		*@return 唯一标识ID
		*/
		__getset(0,__proto,'id',function(){
			return this._id;
		});

		/**
		*获取是否已加载完成。
		*@return 是否已加载完成
		*/
		__getset(0,__proto,'loaded',function(){
			return this._loaded;
		});

		/**
		*获取所属渲染队列。
		*@return 渲染队列。
		*/
		__getset(0,__proto,'renderQueue',function(){
			return this._renderQueue;
		});

		/**
		*设置渲染模式。
		*@return 渲染模式。
		*/
		/**
		*获取渲染状态。
		*@return 渲染状态。
		*/
		__getset(0,__proto,'renderMode',function(){
			return this._renderMode;
			},function(value){
			this._renderMode=value;
			switch (value){
				case 1:
					this._renderQueue=1;
					this.event("renderqueuechanged",this);
					break ;
				case 2:
					this._renderQueue=2;
					this.event("renderqueuechanged",this);
					break ;
				case 3:
					this._renderQueue=1;
					this.event("renderqueuechanged",this);
					break ;
				case 4:
					this._renderQueue=2;
					this.event("renderqueuechanged",this);
					break ;
				case 13:
					this._renderQueue=3;
					this.event("renderqueuechanged",this);
					break ;
				case 14:
					this._renderQueue=4;
					this.event("renderqueuechanged",this);
					break ;
				case 15:
					this._renderQueue=5;
					this.event("renderqueuechanged",this);
					break ;
				case 16:
					this._renderQueue=6;
					this.event("renderqueuechanged",this);
					break ;
				case 5:
					this._renderQueue=7;
					this.event("renderqueuechanged",this);
					break ;
				case 6:
					this._renderQueue=8;
					this.event("renderqueuechanged",this);
					break ;
				case 7:
					this._renderQueue=9;
					this.event("renderqueuechanged",this);
					break ;
				case 8:
					this._renderQueue=10;
					this.event("renderqueuechanged",this);
					break ;
				case 9:
					this._renderQueue=11;
					this.event("renderqueuechanged",this);
					break ;
				case 10:
					this._renderQueue=12;
					this.event("renderqueuechanged",this);
					break ;
				case 11:
					this._renderQueue=13;
					this.event("renderqueuechanged",this);
					break ;
				case 12:
					this._renderQueue=14;
					this.event("renderqueuechanged",this);
					break ;
				default :
					throw new Error("Material:renderMode value error.");
					break ;
				}
			if (this._renderMode===3 || this._renderMode===4)
				this._shaderDefine |=0x800;
			else
			this._shaderDefine=this._shaderDefine & (~0x800);
		});

		BaseMaterial.createFromFile=function(url,out){
			out._loaded=false;
			var loader=new Loader();
			var onComp=function (data){
				var preBasePath=URL.basePath;
				URL.basePath=URL.getPath(URL.formatURL(url));
				ClassUtils.createByJson(data,out,null,Handler.create(null,Utils3D._parseMaterial,null,false));
				URL.basePath=preBasePath;
				out._eventLoaded();
			}
			loader.once("complete",null,onComp);
			loader.load(url,"json");
		}

		BaseMaterial._uniqueIDCounter=0;
		BaseMaterial.RENDERMODE_OPAQUE=1;
		BaseMaterial.RENDERMODE_OPAQUEDOUBLEFACE=2;
		BaseMaterial.RENDERMODE_CUTOUT=3;
		BaseMaterial.RENDERMODE_CUTOUTDOUBLEFACE=4;
		BaseMaterial.RENDERMODE_TRANSPARENT=13;
		BaseMaterial.RENDERMODE_TRANSPARENTDOUBLEFACE=14;
		BaseMaterial.RENDERMODE_ADDTIVE=15;
		BaseMaterial.RENDERMODE_ADDTIVEDOUBLEFACE=16;
		BaseMaterial.RENDERMODE_DEPTHREAD_TRANSPARENT=5;
		BaseMaterial.RENDERMODE_DEPTHREAD_TRANSPARENTDOUBLEFACE=6;
		BaseMaterial.RENDERMODE_DEPTHREAD_ADDTIVE=7;
		BaseMaterial.RENDERMODE_DEPTHREAD_ADDTIVEDOUBLEFACE=8;
		BaseMaterial.RENDERMODE_NONDEPTH_TRANSPARENT=9;
		BaseMaterial.RENDERMODE_NONDEPTH_TRANSPARENTDOUBLEFACE=10;
		BaseMaterial.RENDERMODE_NONDEPTH_ADDTIVE=11;
		BaseMaterial.RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE=12;
		return BaseMaterial;
	})(EventDispatcher)


	/**
	*<code>Node</code> 类用于创建节点对象，节点是最基本的元素。
	*/
	//class laya.display.Node extends laya.events.EventDispatcher
	var Node=(function(_super){
		function Node(){
			this.name="";
			this.destroyed=false;
			this._displayedInStage=false;
			this._parent=null;
			this.model=null;
			Node.__super.call(this);
			this._childs=Node.ARRAY_EMPTY;
			this.timer=Laya.timer;
			this._$P=Node.PROP_EMPTY;
			this.model=Render.isConchNode ? new ConchNode():null;
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
			this._$P=null;
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
			if (this.destroyed || node===this)return node;
			if (node._parent===this){
				this._childs.splice(this.getChildIndex(node),1);
				this._childs.push(node);
				if (this.model){
					this.model.removeChild(node.model);
					this.model.addChildAt(node.model,this._childs.length-1);
				}
				this._childChanged();
				}else {
				node.parent && node.parent.removeChild(node);
				this._childs===Node.ARRAY_EMPTY && (this._childs=[]);
				this._childs.push(node);
				this.model && this.model.addChildAt(node.model,this._childs.length-1);
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
			if (this.destroyed || node===this)return node;
			if (index >=0 && index <=this._childs.length){
				if (node._parent===this){
					var oldIndex=this.getChildIndex(node);
					this._childs.splice(oldIndex,1);
					this._childs.splice(index,0,node);
					if (this.model){
						this.model.removeChild(node.model);
						this.model.addChildAt(node.model,index);
					}
					this._childChanged();
					}else {
					node.parent && node.parent.removeChild(node);
					this._childs===Node.ARRAY_EMPTY && (this._childs=[]);
					this._childs.splice(index,0,node);
					this.model && this.model.addChildAt(node.model,index);
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
		__proto._get$P=function(key){
			return this._$P[key];
		}

		/**@private */
		__proto._set$P=function(key,value){
			this._$P===Node.PROP_EMPTY && (this._$P={});
			this._$P[key]=value;
			return value;
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
			if (oldIndex < 0)throw new Error("setChildIndex:node is must child of this object.");
			childs.splice(oldIndex,1);
			childs.splice(index,0,node);
			if (this.model){
				this.model.removeChild(node.model);
				this.model.addChildAt(node.model,index);
			}
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
				this.model && this.model.removeChild(node.model);
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
			if (this._childs && this._childs.length > 0){
				var childs=this._childs;
				if (beginIndex===0 && endIndex >=n){
					var arr=childs;
					this._childs=Node.ARRAY_EMPTY;
					}else {
					arr=childs.splice(beginIndex,endIndex-beginIndex);
				}
				for (var i=0,n=arr.length;i < n;i++){
					arr[i].parent=null;
					this.model && this.model.removeChild(arr[i].model);
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
				if (this.model){
					this.model.removeChild(oldNode.model);
					this.model.addChildAt(newNode.model,index);
				}
				oldNode.parent=null;
				newNode.parent=this;
				return newNode;
			}
			return null;
		}

		/**@private */
		__proto._setDisplay=function(value){
			if (this._displayedInStage!==value){
				this._displayedInStage=value;
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
			var childs=node._childs;
			if (childs){
				for (var i=childs.length-1;i >-1;i--){
					var child=childs[i];
					child._setDisplay(display);
					child._childs.length && this._displayChild(child,display);
				}
			}
			node._setDisplay(display);
		}

		/**
		*当前容器是否包含 <code>node</code> 节点。
		*@param node 某一个节点 <code>Node</code>。
		*@return 一个布尔值表示是否包含<code>node</code>节点。
		*/
		__proto.contains=function(node){
			if (node===this)return true;
			while (node){
				if (node.parent===this)return true;
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
			(coverBefore===void 0)&& (coverBefore=true);
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
			(coverBefore===void 0)&& (coverBefore=true);
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
			(coverBefore===void 0)&& (coverBefore=true);
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
			(coverBefore===void 0)&& (coverBefore=true);
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

		/**表示是否在显示列表中显示。是否在显示渲染列表中。*/
		__getset(0,__proto,'displayedInStage',function(){
			return this._displayedInStage;
		});

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
					value.displayedInStage && this._displayChild(this,true);
					value._childChanged(this);
					}else {
					this.event("removed");
					this._parent._childChanged();
					this._displayChild(this,false);
					this._parent=value;
				}
			}
		});

		Node.ARRAY_EMPTY=[];
		Node.PROP_EMPTY={};
		return Node;
	})(EventDispatcher)


	/**
	*<code>Component3D</code> 类用于创建组件的父类。
	*/
	//class laya.d3.component.Component3D extends laya.events.EventDispatcher
	var Component3D=(function(_super){
		function Component3D(){
			this._id=0;
			this._cachedOwnerLayerMask=0;
			this._cachedOwnerEnable=false;
			this._enable=false;
			this._owner=null;
			this.started=false;
			Component3D.__super.call(this);
			this._id=Component3D._uniqueIDCounter;
			Component3D._uniqueIDCounter++;
		}

		__class(Component3D,'laya.d3.component.Component3D',_super);
		var __proto=Component3D.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IUpdate":true})
		/**
		*@private
		*owner蒙版变化事件处理。
		*@param mask 蒙版值。
		*/
		__proto._onLayerChanged=function(layer){
			this._cachedOwnerLayerMask=layer.mask;
		}

		/**
		*@private
		*owner启用变化事件处理。
		*@param enable 是否启用。
		*/
		__proto._onEnableChanged=function(enable){
			this._cachedOwnerEnable=enable;
		}

		/**
		*@private
		*初始化组件。
		*@param owner 所属Sprite3D节点。
		*/
		__proto._initialize=function(owner){
			this._owner=owner;
			this.enable=true;
			this.started=false;
			this._cachedOwnerLayerMask=owner.layer.mask;
			this._owner.on("layerchanged",this,this._onLayerChanged);
			this._cachedOwnerEnable=owner.enable;
			this._owner.on("enabledchanged",this,this._onEnableChanged);
			this._load(owner);
		}

		/**
		*@private
		*卸载组件。
		*/
		__proto._uninitialize=function(){
			this._unload(this.owner);
			this._owner.off("layerchanged",this,this._onLayerChanged);
			this._owner.off("enabledchanged",this,this._onEnableChanged);
			this._owner=null;
		}

		/**
		*@private
		*载入组件时执行,可重写此函数。
		*/
		__proto._load=function(owner){}
		/**
		*@private
		*在任意第一次更新时执行,可重写此函数。
		*/
		__proto._start=function(state){}
		/**
		*@private
		*更新组件,可重写此函数。
		*@param state 渲染状态参数。
		*/
		__proto._update=function(state){}
		/**
		*@private
		*更新的最后阶段执行,可重写此函数。
		*@param state 渲染状态参数。
		*/
		__proto._lateUpdate=function(state){}
		/**
		*@private
		*渲染前设置组件相关参数,可重写此函数。
		*@param state 渲染状态参数。
		*/
		__proto._preRenderUpdate=function(state){}
		/**
		*@private
		*渲染的最后阶段执行,可重写此函数。
		*@param state 渲染状态参数。
		*/
		__proto._postRenderUpdate=function(state){}
		/**
		*@private
		*卸载组件时执行,可重写此函数。
		*/
		__proto._unload=function(owner){}
		/**
		*获取唯一标识ID。
		*@return 唯一标识ID。
		*/
		__getset(0,__proto,'id',function(){
			return this._id;
		});

		/**
		*获取所属Sprite3D节点。
		*@return 所属Sprite3D节点。
		*/
		__getset(0,__proto,'owner',function(){
			return this._owner;
		});

		/**
		*设置是否启用。
		*@param value 是否启动
		*/
		/**
		*获取是否启用。
		*@return 是否启动。
		*/
		__getset(0,__proto,'enable',function(){
			return this._enable;
			},function(value){
			if (this._enable!==value){
				this._enable=value;
				this.event("enabledchanged",this._enable);
			}
		});

		/**
		*获取是否激活。
		*@return 是否激活。
		*/
		__getset(0,__proto,'isActive',function(){
			return Layer.isActive(this._cachedOwnerLayerMask)&& this._cachedOwnerEnable && this._enable;
		});

		/**
		*获取是否可见。
		*@return 是否可见。
		*/
		__getset(0,__proto,'isVisible',function(){
			return Layer.isVisible(this._cachedOwnerLayerMask)&& this._cachedOwnerEnable && this._enable;
		});

		Component3D._uniqueIDCounter=1;
		return Component3D;
	})(EventDispatcher)


	/**
	*<code>Render</code> 类用于渲染器的父类，抽象类不允许示例。
	*/
	//class laya.d3.core.render.BaseRender extends laya.events.EventDispatcher
	var BaseRender=(function(_super){
		function BaseRender(owner){
			this._owner=null;
			this._enable=false;
			this._renderObject=null;
			this._materials=null;
			this._boundingSphereNeedChange=false;
			this._boundingBoxNeedChange=false;
			this._boundingSphere=null;
			this._boundingBox=null;
			BaseRender.__super.call(this);
			this._owner=owner;
			this._enable=true;
			this._boundingBox=new BoundBox(new Vector3(),new Vector3());
			this._boundingSphere=new BoundSphere(new Vector3(),0);
			this._boundingSphereNeedChange=true;
			this._boundingBoxNeedChange=true;
			this._renderObject=new RenderObject();
			this._renderObject._render=this;
			this._renderObject._layerMask=this._owner.layer.mask;
			this._renderObject._ownerEnable=this._owner.enable;
			this._renderObject._enable=this._enable;
			this._materials=[];
			this._owner.transform.on("worldmatrixneedchanged",this,this._onWorldMatNeedChange);
			this._owner.on("layerchanged",this,this._onOwnerLayerChanged);
			this._owner.on("enabledchanged",this,this._onOwnerEnableChanged);
			this.on("enabledchanged",this,this._onEnableChanged);
		}

		__class(BaseRender,'laya.d3.core.render.BaseRender',_super);
		var __proto=BaseRender.prototype;
		Laya.imps(__proto,{"laya.resource.IDispose":true})
		/**
		*@private
		*/
		__proto._onWorldMatNeedChange=function(){
			this._boundingSphereNeedChange=true;
			this._boundingBoxNeedChange=true;
		}

		/**
		*@private
		*/
		__proto._onOwnerLayerChanged=function(layer){
			this._renderObject._layerMask=layer.mask;
		}

		/**
		*@private
		*/
		__proto._onOwnerEnableChanged=function(enable){
			this._renderObject._ownerEnable=enable;
		}

		/**
		*@private
		*/
		__proto._onEnableChanged=function(sender,enable){
			this._renderObject._enable=enable;
		}

		/**
		*@private
		*/
		__proto._calculateBoundingSphere=function(){
			throw("BaseRender: must override it.");
		}

		/**
		*@private
		*/
		__proto._calculateBoundingBox=function(){
			throw("BaseRender: must override it.");
		}

		/**
		*彻底清理资源。
		*/
		__proto.dispose=function(){
			this._owner.transform.off("worldmatrixneedchanged",this,this._onWorldMatNeedChange);
			this._owner.off("layerchanged",this,this._onOwnerLayerChanged);
			this._owner.off("enabledchanged",this,this._onOwnerEnableChanged);
			this.off("enabledchanged",this,this._onEnableChanged);
		}

		/**
		*设置是否可用。
		*@param value 是否可用。
		*/
		/**
		*获取是否可用。
		*@return 是否可用。
		*/
		__getset(0,__proto,'enable',function(){
			return this._enable;
			},function(value){
			this._enable=value;
			this.event("enabledchanged",[this,value]);
		});

		/**
		*设置第一个实例材质。
		*@param value 第一个实例材质。
		*/
		/**
		*返回第一个实例材质,第一次使用会拷贝实例对象。
		*@return 第一个实例材质。
		*/
		__getset(0,__proto,'material',function(){
			var material=this._materials[0];
			if (material && !material._isInstance){
				var instanceMaterial=new material.constructor();
				material.copy(instanceMaterial);
				instanceMaterial.name=instanceMaterial.name+"(Instance)";
				instanceMaterial._isInstance=true;
				this._materials[0]=instanceMaterial;
				this.event("materialchanged",[this,0,instanceMaterial]);
			}
			return this._materials[0];
			},function(value){
			this._materials[0]=value;
			this.event("materialchanged",[this,0,value]);
		});

		/**
		*获取渲染物体。
		*@return 渲染物体。
		*/
		__getset(0,__proto,'renderCullingObject',function(){
			return this._renderObject;
		});

		/**
		*获取包围盒。
		*@return 包围盒。
		*/
		__getset(0,__proto,'boundingBox',function(){
			if (this._boundingBoxNeedChange){
				this._calculateBoundingBox();
				this._boundingBoxNeedChange=false;
			}
			return this._boundingBox;
		});

		/**
		*设置实例材质列表。
		*@param value 实例材质列表。
		*/
		/**
		*获取潜拷贝实例材质列表,第一次使用会拷贝实例对象。
		*@return 浅拷贝实例材质列表。
		*/
		__getset(0,__proto,'materials',function(){
			for (var i=0,n=this._materials.length;i < n;i++){
				var material=this._materials[i];
				if (!material._isInstance){
					var instanceMaterial=new material.constructor();
					material.copy(instanceMaterial);
					instanceMaterial.name=instanceMaterial.name+"(Instance)";
					instanceMaterial._isInstance=true;
					this._materials[i]=instanceMaterial;
					this.event("materialchanged",[this,i,instanceMaterial]);
				}
			}
			return this._materials.slice();
			},function(value){
			if (!value)
				throw new Error("MeshRender: materials value can't be null.");
			this._materials=value;
			for (var i=0,n=value.length;i<n;i++)
			this.event("materialchanged",[this,i,value[i]]);
		});

		/**
		*设置第一个材质。
		*@param value 第一个材质。
		*/
		/**
		*返回第一个材质。
		*@return 第一个材质。
		*/
		__getset(0,__proto,'sharedMaterial',function(){
			return this._materials[0];
			},function(value){
			this._materials[0]=value;
			this.event("materialchanged",[this,0,value]);
		});

		/**
		*获取包围球。
		*@return 包围球。
		*/
		__getset(0,__proto,'boundingSphere',function(){
			if (this._boundingSphereNeedChange){
				this._calculateBoundingSphere();
				this._boundingSphereNeedChange=false;
			}
			return this._boundingSphere;
		});

		/**
		*设置材质列表。
		*@param value 材质列表。
		*/
		/**
		*获取浅拷贝材质列表。
		*@return 浅拷贝材质列表。
		*/
		__getset(0,__proto,'sharedMaterials',function(){
			var materials=this._materials.slice();
			return materials;
			},function(value){
			if (!value)
				throw new Error("MeshRender: shadredMaterials value can't be null.");
			this._materials=value;
			for (var i=0,n=value.length;i<n;i++)
			this.event("materialchanged",[this,i,value[i]]);
		});

		return BaseRender;
	})(EventDispatcher)


	/**
	*<code>MeshFilter</code> 类用于创建网格过滤器。
	*/
	//class laya.d3.core.MeshFilter extends laya.events.EventDispatcher
	var MeshFilter=(function(_super){
		function MeshFilter(owner){
			this._owner=null;
			this._sharedMesh=null;
			MeshFilter.__super.call(this);
			this._owner=owner;
		}

		__class(MeshFilter,'laya.d3.core.MeshFilter',_super);
		var __proto=MeshFilter.prototype;
		/**
		*设置共享网格。
		*@return value 共享网格。
		*/
		/**
		*获取共享网格。
		*@return 共享网格。
		*/
		__getset(0,__proto,'sharedMesh',function(){
			return this._sharedMesh;
			},function(value){
			var oldMesh=this._sharedMesh;
			this._sharedMesh=value;
			this.event("meshchanged",[this,oldMesh,value]);
		});

		return MeshFilter;
	})(EventDispatcher)


	/**
	*<code>Transform3D</code> 类用于实现3D变换。
	*/
	//class laya.d3.core.Transform3D extends laya.events.EventDispatcher
	var Transform3D=(function(_super){
		function Transform3D(owner){
			this._owner=null;
			this._preWorldTransformModifyID=-1;
			this._localUpdate=false;
			this._worldUpdate=true;
			this._parent=null;
			Transform3D.__super.call(this);
			this._tempMatrix0=new Matrix4x4();
			this._tempQuaternion0=new Quaternion();
			this._tempVector30=new Vector3();
			this._localPosition=new Vector3();
			this._localRotation=new Quaternion(0,0,0,1);
			this._localScale=new Vector3(1,1,1);
			this._localMatrix=new Matrix4x4();
			this._position=new Vector3();
			this._rotation=new Quaternion(0,0,0,1);
			this._scale=new Vector3(1,1,1);
			this._worldMatrix=new Matrix4x4();
			this._forward=new Vector3();
			this._up=new Vector3();
			this._right=new Vector3();
			this._owner=owner;
		}

		__class(Transform3D,'laya.d3.core.Transform3D',_super);
		var __proto=Transform3D.prototype;
		/**
		*@private
		*/
		__proto._updateLocalMatrix=function(){
			Matrix4x4.createAffineTransformation(this._localPosition,this._localRotation,this._localScale,this._localMatrix);
		}

		/**
		*@private
		*/
		__proto._onLocalTransform=function(){
			this._localUpdate=true;
		}

		/**
		*@private
		*/
		__proto._onWorldTransform=function(){
			if (!this._worldUpdate){
				this._worldUpdate=true;
				this.event("worldmatrixneedchanged");
				for (var i=0,n=this._owner._childs.length;i < n;i++)
				(this._owner._childs [i]).transform._onWorldTransform();
			}
		}

		/**
		*平移变换。
		*@param translation 移动距离。
		*@param isLocal 是否局部空间。
		*/
		__proto.translate=function(translation,isLocal){
			(isLocal===void 0)&& (isLocal=true);
			if (isLocal){
				Matrix4x4.createFromQuaternion(this.localRotation,this._tempMatrix0);
				Vector3.transformCoordinate(translation,this._tempMatrix0,this._tempVector30);
				Vector3.add(this.localPosition,this._tempVector30,this._localPosition);
				this.localPosition=this._localPosition;
				}else {
				Vector3.add(this.position,translation,this._position);
				this.position=this._position;
			}
		}

		/**
		*旋转变换。
		*@param rotations 旋转幅度。
		*@param isLocal 是否局部空间。
		*@param isRadian 是否弧度制。
		*/
		__proto.rotate=function(rotation,isLocal,isRadian){
			(isLocal===void 0)&& (isLocal=true);
			(isRadian===void 0)&& (isRadian=true);
			var rot;
			if (!isRadian){
				Vector3.scale(rotation,Math.PI / 180,this._tempVector30);
				rot=this._tempVector30;
				}else {
				rot=rotation;
			}
			Quaternion.createFromYawPitchRoll(rot.y,rot.x,rot.z,this._tempQuaternion0);
			if (isLocal){
				Quaternion.multiply(this._localRotation,this._tempQuaternion0,this._localRotation);
				this.localRotation=this._localRotation;
				}else {
				Quaternion.multiply(this._tempQuaternion0,this.rotation,this._rotation);
				this.rotation=this._rotation;
			}
		}

		/**
		*设置局部位置。
		*@param value 局部位置。
		*/
		/**
		*获取局部位置。
		*@return 局部位置。
		*/
		__getset(0,__proto,'localPosition',function(){
			return this._localPosition;
			},function(value){
			this._localPosition=value;
			this._onLocalTransform();
			this._onWorldTransform();
		});

		/**
		*获取世界矩阵是否需要更新。
		*@return 世界矩阵是否需要更新。
		*/
		__getset(0,__proto,'worldNeedUpdate',function(){
			return this._worldUpdate;
		});

		/**
		*设置世界位置。
		*@param value 世界位置。
		*/
		/**
		*获取世界位置。
		*@return 世界位置。
		*/
		__getset(0,__proto,'position',function(){
			if (this._parent!==null){
				var worldMatElem=this.worldMatrix.elements;
				this._position.elements[0]=worldMatElem[12];
				this._position.elements[1]=worldMatElem[13];
				this._position.elements[2]=worldMatElem[14];
				}else {
				this._localPosition.cloneTo(this._position);
			}
			return this._position;
			},function(value){
			if (this._parent!==null){
				this._parent.worldMatrix.invert(this._tempMatrix0);
				Vector3.transformCoordinate(value,this._tempMatrix0,this._localPosition);
				this.localPosition=this._localPosition;
				}else {
				value.cloneTo(this._localPosition);
				this.localPosition=this._localPosition;
			}
		});

		/**
		*设置世界矩阵。
		*@param value 世界矩阵。
		*/
		/**
		*获取世界矩阵。
		*@return 世界矩阵。
		*/
		__getset(0,__proto,'worldMatrix',function(){
			if (!this._worldUpdate)
				return this._worldMatrix;
			if (this._parent !=null)
				Matrix4x4.multiply(this._parent.worldMatrix,this.localMatrix,this._worldMatrix);
			else
			this.localMatrix.cloneTo(this._worldMatrix);
			this._worldUpdate=false;
			return this._worldMatrix;
			},function(value){
			if (this._parent===null)
				this.localMatrix=value;
			else {
				this._parent.worldMatrix.invert(this._localMatrix);
				Matrix4x4.multiply(this._localMatrix,value,this._localMatrix);
				this.localMatrix=this._localMatrix;
			}
		});

		/**
		*设置局部矩阵。
		*@param value 局部矩阵。
		*/
		/**
		*获取局部矩阵。
		*@return 局部矩阵。
		*/
		__getset(0,__proto,'localMatrix',function(){
			if (this._localUpdate){
				this._updateLocalMatrix();
				this._localUpdate=false;
			}
			return this._localMatrix;
			},function(value){
			this._localMatrix=value;
			this._localMatrix.decompose(this._localPosition,this._localRotation,this._localScale);
			this._onWorldTransform();
		});

		/**
		*设置局部旋转。
		*@param value 局部旋转。
		*/
		/**
		*获取局部旋转。
		*@return 局部旋转。
		*/
		__getset(0,__proto,'localRotation',function(){
			return this._localRotation;
			},function(value){
			this._localRotation=value;
			this._localRotation.normalize(this._localRotation);
			this._onLocalTransform();
			this._onWorldTransform();
		});

		/**
		*设置世界旋转。
		*@param value 世界旋转。
		*/
		/**
		*获取世界旋转。
		*@return 世界旋转。
		*/
		__getset(0,__proto,'rotation',function(){
			if (this._parent!==null){
				this.worldMatrix.decompose(this._position,this._rotation,this._scale);
				}else {
				this._localRotation.cloneTo(this._rotation);
			}
			return this._rotation;
			},function(value){
			if (this._parent!==null){
				this._parent.rotation.invert(this._tempQuaternion0);
				Quaternion.multiply(value,this._tempQuaternion0,this._localRotation);
				this.localRotation=this._localRotation;
				}else {
				value.cloneTo(this._localRotation);
				this.localRotation=this._localRotation;
			}
		});

		/**
		*设置局部缩放。
		*@param value 局部缩放。
		*/
		/**
		*获取局部缩放。
		*@return 局部缩放。
		*/
		__getset(0,__proto,'localScale',function(){
			return this._localScale;
			},function(value){
			this._localScale=value;
			this._onLocalTransform();
			this._onWorldTransform();
		});

		/**
		*设置局部空间的旋转角度。
		*@param value 欧拉角的旋转值，顺序为x、y、z。
		*/
		__getset(0,__proto,'localRotationEuler',null,function(value){
			Quaternion.createFromYawPitchRoll(value.y,value.x,value.z,this._localRotation);
			this._onLocalTransform();
			this._onWorldTransform();
		});

		/**
		*获取世界缩放。
		*@return 世界缩放。
		*/
		__getset(0,__proto,'scale',function(){
			if (this._parent!==null){
				Vector3.multiply(this._parent.scale,this._localScale,this._scale);
				}else {
				this._localScale.cloneTo(this._scale);
			}
			return this._scale;
		});

		/**
		*设置局部空间的旋转角度。
		*@param 欧拉角的旋转值，顺序为x、y、z。
		*/
		__getset(0,__proto,'rotationEuler',null,function(value){
			Quaternion.createFromYawPitchRoll(value.y,value.x,value.z,this._rotation);
			this.rotation=this._rotation;
		});

		/**
		*获取向前方向。
		*@return 向前方向。
		*/
		__getset(0,__proto,'forward',function(){
			var worldMatElem=this.worldMatrix.elements;
			this._forward.elements[0]=-worldMatElem[8];
			this._forward.elements[1]=-worldMatElem[9];
			this._forward.elements[2]=-worldMatElem[10];
			return this._forward;
		});

		/**
		*设置父3D变换。
		*@param value 父3D变换。
		*/
		__getset(0,__proto,'parent',null,function(value){
			this._parent=value;
			this._onWorldTransform();
		});

		/**
		*获取向上方向。
		*@return 向上方向。
		*/
		__getset(0,__proto,'up',function(){
			var worldMatElem=this.worldMatrix.elements;
			this._up.elements[0]=worldMatElem[4];
			this._up.elements[1]=worldMatElem[5];
			this._up.elements[2]=worldMatElem[6];
			return this._up;
		});

		/**
		*获取向右方向。
		*@return 向右方向。
		*/
		__getset(0,__proto,'right',function(){
			var worldMatElem=this.worldMatrix.elements;
			this._right.elements[0]=worldMatElem[0];
			this._right.elements[1]=worldMatElem[1];
			this._right.elements[2]=worldMatElem[2];
			return this._right;
		});

		return Transform3D;
	})(EventDispatcher)


	/**
	*<code>TransformUV</code> 类用于实现UV变换。
	*/
	//class laya.d3.core.TransformUV extends laya.events.EventDispatcher
	var TransformUV=(function(_super){
		function TransformUV(){
			this._rotation=0;
			this._matNeedUpdte=false;
			TransformUV.__super.call(this);
			this._tempTitlingV3=new Vector3();
			this._tempRotationMatrix=new Matrix4x4();
			this._tempTitlingMatrix=new Matrix4x4();
			this._matrix=new Matrix4x4();
			this._offset=new Vector2();
			this._tiling=new Vector2();
		}

		__class(TransformUV,'laya.d3.core.TransformUV',_super);
		var __proto=TransformUV.prototype;
		/**
		*@private
		*/
		__proto._updateMatrix=function(){
			this._tempTitlingV3.elements[0]=this._tiling.x;
			this._tempTitlingV3.elements[1]=this._tiling.y;
			this._tempTitlingV3.elements[2]=1;
			Matrix4x4.createScaling(this._tempTitlingV3,this._tempTitlingMatrix);
			Matrix4x4.createRotationZ(this._rotation,this._tempRotationMatrix);
			Matrix4x4.multiply(this._tempRotationMatrix,this._tempTitlingMatrix,this._matrix);
			var mate=this._matrix.elements;
			mate[12]=this._offset.x;
			mate[13]=this._offset.y;
			mate[14]=0;
		}

		/**
		*获取变换矩阵。
		*@return 变换矩阵。
		*/
		__getset(0,__proto,'matrix',function(){
			if (this._matNeedUpdte){
				this._updateMatrix();
				this._matNeedUpdte=false;
			}
			return this._matrix;
		});

		/**
		*设置偏移。
		*@param value 偏移。
		*/
		/**
		*获取偏移。
		*@return 偏移。
		*/
		__getset(0,__proto,'offset',function(){
			return this._offset;
			},function(value){
			this._offset=value;
			this._matNeedUpdte=true;
		});

		/**
		*设置旋转。
		*@param value 旋转。
		*/
		/**
		*获取旋转。
		*@return 旋转。
		*/
		__getset(0,__proto,'rotation',function(){
			return this._rotation;
			},function(value){
			this._rotation=value;
			this._matNeedUpdte=true;
		});

		/**
		*设置平铺次数。
		*@param value 平铺次数。
		*/
		/**
		*获取平铺次数。
		*@return 平铺次数。
		*/
		__getset(0,__proto,'tiling',function(){
			return this._tiling;
			},function(value){
			this._tiling=value;
			this._matNeedUpdte=true;
		});

		return TransformUV;
	})(EventDispatcher)


	/**
	*<code>Resource</code> 资源存取类。
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
			this.completeCreate();
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
		__proto.completeCreate=function(){
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
			this.resourceManager && this.resourceManager.addSize(offsetValue);
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
		Resource.materialCache={};
		Resource._uniqueIDCounter=0;
		Resource._loadedResources=[];
		Resource._isLoadedResourcesSorted=false;
		return Resource;
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
		*@param url 地址，或者资源对象数组(简单数组：["a.png","b.png"]，复杂数组[{url:"a.png",type:Loader.IMAGE,size:100,priority:1},{url:"b.json",type:Loader.JSON,size:50,priority:1}])。
		*@param complete 结束回调，如果加载失败，则返回 null 。
		*@param progress 进度回调，回调参数为当前文件加载的进度信息(0-1)。
		*@param type 资源类型。
		*@param priority 优先级，0-4，五个优先级，0优先级最高，默认为1。
		*@param cache 是否缓存加载结果。
		*@param group 分组。
		*@return 此 LoaderManager 对象。
		*/
		__proto.load=function(url,complete,progress,type,priority,cache,group){
			(priority===void 0)&& (priority=1);
			(cache===void 0)&& (cache=true);
			if ((url instanceof Array))return this._loadAssets(url,complete,progress,type,priority,cache,group);
			url=Loader._parseURL(url);
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
					info.group=group;
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
				_this._endLoad(resInfo,data);
				_this._loaderCount--;
				_this._next();
			}
			loader.load(resInfo.url,resInfo.type,resInfo.cache,resInfo.group);
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
			this._resMap={};
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
			url=URL.formatURL(url);
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
			if (this._resMap[url])delete this._resMap[url];
		}

		/**
		*@private
		*加载数组里面的资源。
		*@param arr 简单：["a.png","b.png"]，复杂[{url:"a.png",type:Loader.IMAGE,size:100,priority:1},{url:"b.json",type:Loader.JSON,size:50,priority:1}]*/
		__proto._loadAssets=function(arr,complete,progress,type,priority,cache,group){
			(priority===void 0)&& (priority=1);
			(cache===void 0)&& (cache=true);
			var itemCount=arr.length;
			var loadedSize=0;
			var totalSize=0;
			var items=[];
			var defaultType=type || "image";
			for (var i=0;i < itemCount;i++){
				var item=arr[i];
				if ((typeof item=='string'))item={url:item,type:defaultType,size:1,priority:priority};
				if (!item.size)item.size=1;
				item.progress=0;
				totalSize+=item.size;
				items.push(item);
				var progressHandler=progress ? Handler.create(this,loadProgress,[item],false):null;
				this.load(item.url,Handler.create(item,loadComplete,[item]),progressHandler,item.type,item.priority || 1,cache,item.group||group);
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
					var count=items.length;
					for (var j=0;j < count;j++){
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
					this.group=null;
					ResInfo.__super.call(this);
				}
				__class(ResInfo,'',_super);
				return ResInfo;
			})(EventDispatcher)
		}

		return LoaderManager;
	})(EventDispatcher)


	/**
	*@private
	*<code>ShaderDefines3D</code> 类用于创建3DshaderDefine相关。
	*/
	//class laya.d3.shader.ShaderDefines3D extends laya.webgl.shader.ShaderDefines
	var ShaderDefines3D=(function(_super){
		function ShaderDefines3D(){
			ShaderDefines3D.__super.call(this,ShaderDefines3D._name2int,ShaderDefines3D._int2name,ShaderDefines3D._int2nameMap);
		}

		__class(ShaderDefines3D,'laya.d3.shader.ShaderDefines3D',_super);
		ShaderDefines3D.__init__=function(){
			ShaderDefines3D.reg("FSHIGHPRECISION",0x100000);
			ShaderDefines3D.reg("DIFFUSEMAP",0x1);
			ShaderDefines3D.reg("NORMALMAP",0x2);
			ShaderDefines3D.reg("SPECULARMAP",0x4);
			ShaderDefines3D.reg("EMISSIVEMAP",0x8);
			ShaderDefines3D.reg("AMBIENTMAP",0x10);
			ShaderDefines3D.reg("REFLECTMAP",0x40000);
			ShaderDefines3D.reg("PARTICLE3D",0x8000);
			ShaderDefines3D.reg("COLOR",0x20);
			ShaderDefines3D.reg("UV",0x200000);
			ShaderDefines3D.reg("SKINNED",0x400);
			ShaderDefines3D.reg("DIRECTIONLIGHT",0x40);
			ShaderDefines3D.reg("POINTLIGHT",0x80);
			ShaderDefines3D.reg("SPOTLIGHT",0x100);
			ShaderDefines3D.reg("BONE",0x200);
			ShaderDefines3D.reg("ALPHATEST",0x800);
			ShaderDefines3D.reg("UVTRANSFORM",0x4000);
			ShaderDefines3D.reg("MIXUV",0x10000);
			ShaderDefines3D.reg("FOG",0x20000);
			ShaderDefines3D.reg("VR",0x80000);
		}

		ShaderDefines3D.reg=function(name,value){
			ShaderDefines._reg(name,value,ShaderDefines3D._name2int,ShaderDefines3D._int2name);
		}

		ShaderDefines3D.toText=function(value,_int2name,_int2nameMap){
			return ShaderDefines._toText(value,_int2name,_int2nameMap);
		}

		ShaderDefines3D.toInt=function(names){
			return ShaderDefines._toInt(names,ShaderDefines3D._name2int);
		}

		ShaderDefines3D.DIFFUSEMAP=0x1;
		ShaderDefines3D.NORMALMAP=0x2;
		ShaderDefines3D.SPECULARMAP=0x4;
		ShaderDefines3D.EMISSIVEMAP=0x8;
		ShaderDefines3D.AMBIENTMAP=0x10;
		ShaderDefines3D.REFLECTMAP=0x40000;
		ShaderDefines3D.VR=0x80000;
		ShaderDefines3D.FSHIGHPRECISION=0x100000;
		ShaderDefines3D.UVTRANSFORM=0x4000;
		ShaderDefines3D.MIXUV=0x10000;
		ShaderDefines3D.FOG=0x20000;
		ShaderDefines3D.UV=0x200000;
		ShaderDefines3D.COLOR=0x20;
		ShaderDefines3D.DIRECTIONLIGHT=0x40;
		ShaderDefines3D.POINTLIGHT=0x80;
		ShaderDefines3D.SPOTLIGHT=0x100;
		ShaderDefines3D.BONE=0x200;
		ShaderDefines3D.SKINNED=0x400;
		ShaderDefines3D.ALPHATEST=0x800;
		ShaderDefines3D.PARTICLE3D=0x8000;
		ShaderDefines3D._name2int={};
		ShaderDefines3D._int2name=[];
		ShaderDefines3D._int2nameMap=[];
		return ShaderDefines3D;
	})(ShaderDefines)


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
		*private
		*/
		__proto.__runComplete=function(handler){
			if (handler){
				handler.run();
			}
		}

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
			this.__toPlays=null;
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
				this._loaded(this.audioBuffer);
				return;
			}
			WebAudioSound.e.on("loaded:"+url,this,this._loaded);
			WebAudioSound.e.on("err:"+url,this,this._err);
			if (WebAudioSound.__loadingSound[url]){
				return;
			}
			WebAudioSound.__loadingSound[url]=true;
			var request=new Browser.window.XMLHttpRequest();
			request.open("GET",url,true);
			request.responseType="arraybuffer";
			request.onload=function (){
				me.data=request.response;
				WebAudioSound.buffs.push({"buffer":me.data,"url":me.url});
				WebAudioSound.decode();
			};
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
				if(tParams[2]&&!(tParams [2]).isStopped){
					this.play(tParams[0],tParams[1],tParams[2]);
				}
			}
			this.__toPlays.length=0;
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
			if (WebAudioSound.ctx==null){return;};
			var source=WebAudioSound.ctx.createBufferSource();
			source.buffer=WebAudioSound._miniBuffer;
			source.connect(WebAudioSound.ctx.destination);
			source.start(0,0,0);
		}

		WebAudioSound._unlock=function(){
			if (WebAudioSound._unlocked){return;}
				WebAudioSound._playEmptySound();
			if (WebAudioSound.ctx.state=="running"){
				Browser.document.removeEventListener("mousedown",WebAudioSound._unlock,true);
				Browser.document.removeEventListener("touchend",WebAudioSound._unlock,true);
				WebAudioSound._unlocked=true;
			}
		}

		WebAudioSound.initWebAudio=function(){
			if (WebAudioSound.ctx.state !="running"){
				WebAudioSound._unlock();
				Browser.document.addEventListener("mousedown",WebAudioSound._unlock,true);
				Browser.document.addEventListener("touchend",WebAudioSound._unlock,true);
			}
		}

		WebAudioSound._dataCache={};
		WebAudioSound.buffs=[];
		WebAudioSound.isDecoding=false;
		WebAudioSound._unlocked=false;
		WebAudioSound.tInfo=null
		WebAudioSound.__loadingSound={};
		__static(WebAudioSound,
		['window',function(){return this.window=Browser.window;},'webAudioEnabled',function(){return this.webAudioEnabled=WebAudioSound.window["AudioContext"] || WebAudioSound.window["webkitAudioContext"] || WebAudioSound.window["mozAudioContext"];},'ctx',function(){return this.ctx=WebAudioSound.webAudioEnabled ? new (WebAudioSound.window["AudioContext"] || WebAudioSound.window["webkitAudioContext"] || WebAudioSound.window["mozAudioContext"])():undefined;},'_miniBuffer',function(){return this._miniBuffer=WebAudioSound.ctx.createBuffer(1,1,22050);},'e',function(){return this.e=new EventDispatcher();}
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
			try {
				if (this._responseType==="json"){
					this._data=JSON.parse(this._http.responseText);
					}else if (this._responseType==="xml"){
					this._data=Utils.parseXMLFromString(this._http.responseText);
					}else {
					this._data=this._http.response || this._http.responseText;
				}
				this.event("complete",(this._data instanceof Array)? [this._data] :this._data);
				}catch (e){
				this.error(e.message);
			}
		}

		/**
		*@private
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
		*@param group 分组。
		*/
		__proto.load=function(url,type,cache,group){
			(cache===void 0)&& (cache=true);
			url=Loader._parseURL(url);
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
			if (group)Loader.setGroup(url,group);
			if (Loader.parserMap[type] !=null){
				if (((Loader.parserMap[type])instanceof laya.utils.Handler ))Loader.parserMap[type].runWith(this);
				else Loader.parserMap[type].call(null,this);
				return;
			}
			if (type==="image" || type==="htmlimage" || type==="nativeimage")return this._loadImage(url);
			if (type==="sound")return this._loadSound(url);
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
			var _this=this;
			var image;
			function clear (){
				image.onload=null;
				image.onerror=null;
			};
			var onload=function (){
				clear();
				_this.onLoaded(image);
			};
			var onerror=function (){
				clear();
				_this.event("error","Load image filed");
			}
			if (this._type==="nativeimage"){
				image=new Browser.window.Image();
				image.crossOrigin="";
				image.onload=onload;
				image.onerror=onerror;
				image.src=url;
				}else {
				new HTMLImage.create(url,{onload:onload,onerror:onerror,onCreate:function (img){
						image=img;
				}});
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
				_this.event("error","Load sound filed");
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
				if (!data.src){
					if (!this._data){
						this._data=data;
						if (data.meta && data.meta.image){
							var toloadPics=data.meta.image.split(",");
							var split=this._url.indexOf("/")>=0 ? "/" :"\\";
							var idx=this._url.lastIndexOf(split);
							var folderPath=idx >=0 ? this._url.substr(0,idx+1):"";
							idx=this._url.indexOf("?");
							var ver;
							ver=idx >=0 ? this._url.substr(idx):"";
							for (var i=0,len=toloadPics.length;i < len;i++){
								toloadPics[i]=folderPath+toloadPics[i]+ver;
							}
							}else {
							toloadPics=[this._url.replace(".json",".png")];
						}
						toloadPics.reverse();
						data.toLoads=toloadPics;
						data.pics=[];
					}
					this.event("progress",0.3+1 / toloadPics.length *0.6);
					return this._loadImage(URL.formatURL(toloadPics.pop()));
					}else {
					this._data.pics.push(data);
					if (this._data.toLoads.length > 0){
						this.event("progress",0.3+1 / this._data.toLoads.length *0.6);
						return this._loadImage(URL.formatURL(this._data.toLoads.pop()));
					};
					var frames=this._data.frames;
					var directory=(this._data.meta && this._data.meta.prefix)? URL.basePath+this._data.meta.prefix :this._url.substring(0,this._url.lastIndexOf("."))+"/";
					var pics=this._data.pics;
					var map=Loader.atlasMap[this._url] || (Loader.atlasMap[this._url]=[]);
					map.dir=directory;
					for (var name in frames){
						var obj=frames[name];
						var tPic=pics[obj.frame.idx ? obj.frame.idx :0];
						var url=directory+name;
						Loader.loadedMap[url]=Texture.create(tPic,obj.frame.x,obj.frame.y,obj.frame.w,obj.frame.h,obj.spriteSourceSize.x,obj.spriteSourceSize.y,obj.sourceSize.w,obj.sourceSize.h);
						Loader.loadedMap[url].url=url;
						map.push(url);
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
		*结束加载，处理是否缓存及派发完成事件 <code>Event.COMPLETE</code> 。
		*@param content 加载后的数据
		*/
		__proto.endLoad=function(content){
			content && (this._data=content);
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
				Loader._loaders[Loader._startIndex].endLoad();
				Loader._startIndex++;
				if (Browser.now()-startTimer > Loader.maxTimeOut){
					console.log("loader callback cost a long time:"+(Browser.now()-startTimer)+" url="+Loader._loaders[Loader._startIndex-1].url);
					Laya.timer.frameOnce(1,null,Loader.checkNext);
					return;
				}
			}
			Loader._loaders.length=0;
			Loader._startIndex=0;
			Loader._isWorking=false;
		}

		Loader._parseURL=function(url){
			if (!url)return url;
			if (url.indexOf("data:image")==0)return url;
			if (url.indexOf(",")< 0){
				url=URL.formatURL(url);
				}else {
				var arr=url.split(",");
				for (var i=arr.length-1;i >-1;i--)
				arr[i]=URL.formatURL(arr[i]);
				url=arr.join(",");
			}
			return url
		}

		Loader.clearRes=function(url,forceDispose){
			(forceDispose===void 0)&& (forceDispose=false);
			url=URL.formatURL(url);
			var arr=Loader.atlasMap[url];
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

		Loader.getRes=function(url){
			return Loader.loadedMap[Loader._parseURL(url)];
		}

		Loader.getAtlas=function(url){
			return Loader.atlasMap[URL.formatURL(url)];
		}

		Loader.cacheRes=function(url,data){
			Loader.loadedMap[URL.formatURL(url)]=data;
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
		Loader.TEXTURE2D="texture2d";
		Loader.TEXTURECUBE="texturecube";
		Loader.typeMap={"png":"image","jpg":"image","jpeg":"image","txt":"text","json":"json","xml":"xml","als":"atlas","mp3":"sound","ogg":"sound","wav":"sound","part":"json"};
		Loader.parserMap={};
		Loader.loadedMap={};
		Loader.groupMap={};
		Loader.maxTimeOut=100;
		Loader.atlasMap={};
		Loader._loaders=[];
		Loader._isWorking=false;
		Loader._startIndex=0;
		Loader._extReg=/\.(\w+)\??/g;
		return Loader;
	})(EventDispatcher)


	/**
	*<code>Texture</code> 是一个纹理处理类。
	*/
	//class laya.resource.Texture extends laya.events.EventDispatcher
	var Texture=(function(_super){
		function Texture(bitmap,uv){
			//this.bitmap=null;
			//this.uv=null;
			this.offsetX=0;
			this.offsetY=0;
			this.sourceWidth=0;
			this.sourceHeight=0;
			//this._loaded=false;
			this._w=0;
			this._h=0;
			//this.$_GID=NaN;
			//this.url=null;
			this._uvID=0;
			Texture.__super.call(this);
			if (bitmap){
				bitmap.useNum++;
			}
			this.setTo(bitmap,uv);
		}

		__class(Texture,'laya.resource.Texture',_super);
		var __proto=Texture.prototype;
		/**
		*设置此对象的位图资源、UV数据信息。
		*@param bitmap 位图资源
		*@param uv UV数据信息
		*/
		__proto.setTo=function(bitmap,uv){
			this.bitmap=bitmap;
			this.uv=uv || Texture.DEF_UV;
			if (bitmap){
				this._w=bitmap.width;
				this._h=bitmap.height;
				this.sourceWidth=this.sourceWidth || this._w;
				this.sourceHeight=this.sourceHeight || this._h
				this._loaded=this._w > 0;
				var _this=this;
				if (this._loaded){
					RunDriver.addToAtlas && RunDriver.addToAtlas(_this);
					}else {
					var bm=bitmap;
					if ((bm instanceof laya.resource.HTMLImage )&& bm.image)
						bm.image.addEventListener('load',function(e){
						RunDriver.addToAtlas && RunDriver.addToAtlas(_this);
					},false);
				}
			}
		}

		/**@private 激活资源。*/
		__proto.active=function(){
			this.bitmap.activeResource();
		}

		/**
		*销毁纹理（分直接销毁，跟计数销毁两种）
		*@param forceDispose true为强制销毁主纹理，false是通过计数销毁纹理
		*/
		__proto.destroy=function(forceDispose){
			(forceDispose===void 0)&& (forceDispose=false);
			if (this.bitmap && (this.bitmap).useNum > 0){
				if (forceDispose){
					this.bitmap.dispose();
					(this.bitmap).useNum=0;
					}else {
					(this.bitmap).useNum--;
					if ((this.bitmap).useNum==0){
						this.bitmap.dispose();
					}
				}
				this.bitmap=null;
				if (this.url && this===Laya.loader.getRes(this.url))Laya.loader.clearRes(this.url);
				this._loaded=false;
			}
		}

		/**
		*加载指定地址的图片。
		*@param url 图片地址。
		*/
		__proto.load=function(url){
			var _$this=this;
			this._loaded=false;
			var fileBitmap=(this.bitmap || (this.bitmap=HTMLImage.create(URL.formatURL(url))));
			if (fileBitmap){
				fileBitmap.useNum++;
			};
			var _this=this;
			fileBitmap.onload=function (){
				fileBitmap.onload=null;
				_this._loaded=true;
				_$this.sourceWidth=_$this._w=fileBitmap.width;
				_$this.sourceHeight=_$this._h=fileBitmap.height;
				_this.event("loaded",this);
				(RunDriver.addToAtlas)&& (RunDriver.addToAtlas(_this));
			};
		}

		/**@private */
		__proto.addTextureToAtlas=function(e){
			RunDriver.addTextureToAtlas(this);
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
				Browser.canvas.size(x+width,y+height);
				Browser.context.drawImage(this.bitmap.source,0,0);
				var info=Browser.context.getImageData(x,y,width,height);
			}
			return info.data;
		}

		/**实际高度。*/
		__getset(0,__proto,'height',function(){
			if (this._h)return this._h;
			return (this.uv && this.uv!==Texture.DEF_UV)? (this.uv[5]-this.uv[1])*this.bitmap.height :this.bitmap.height;
			},function(value){
			this._h=value;
			this.sourceHeight || (this.sourceHeight=value);
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
			this.sourceWidth || (this.sourceWidth=value);
		});

		/**
		*设置线性采样的状态（目前只能第一次绘制前设置false生效,来关闭线性采样）
		*/
		/**
		*获取当前纹理是否启用了线性采样
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
			var tex=new Texture(bitmap,null);
			tex.width=width;
			tex.height=height;
			tex.offsetX=offsetX;
			tex.offsetY=offsetY;
			tex.sourceWidth=sourceWidth || width;
			tex.sourceHeight=sourceHeight || height;
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
		Texture.INV_UV=[0,1,1.0,1,1.0,0.0,0,0.0];
		Texture._rect1=new Rectangle();
		Texture._rect2=new Rectangle();
		return Texture;
	})(EventDispatcher)


	//class laya.webgl.display.GraphicsGL extends laya.display.Graphics
	var GraphicsGL=(function(_super){
		function GraphicsGL(){
			GraphicsGL.__super.call(this);
		}

		__class(GraphicsGL,'laya.webgl.display.GraphicsGL',_super);
		var __proto=GraphicsGL.prototype;
		__proto.setShader=function(shader){
			this._saveToCmd(Render.context._setShader,[shader]);
		}

		__proto.setIBVB=function(x,y,ib,vb,numElement,shader){
			this._saveToCmd(Render.context._setIBVB,[x,y,ib,vb,numElement,shader]);
		}

		__proto.drawParticle=function(x,y,ps){
			var pt=RunDriver.createParticleTemplate2D(ps);
			pt.x=x;
			pt.y=y;
			this._saveToCmd(Render.context._drawParticle,[pt]);
		}

		return GraphicsGL;
	})(Graphics)


	/**
	*@private
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
				ower._layoutLater();
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
			x-=sprite.pivotX;
			y-=sprite.pivotY;
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

		/**@inheritDoc */
		__proto.setTransform=function(value){
			(value==='none')? (this._tf=Style._TF_EMPTY):this.attrs(CSSStyle.parseOneCSS(value,','));
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
				w=parseInt(w);
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
				h=parseInt(h);
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
				this._border.size=parseInt(values[0]);
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
			((typeof d=='string'))&& (d=parseInt(d+""));
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
				value=parseInt(value);
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
				value=parseInt(value);
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
			((typeof d=='string'))&& (d=parseInt(d+""));
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
			if (!value){
				this._border=null;
				return;
			}
			this._border || (this._border={size:1,type:'solid'});
			this._border.color=(value==null)? null :Color.create(value);
			this._ower.model && this._ower.model.border(this._border.color.strColor);
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
			return this._bgground ? this._bgground.color :null;
			},function(value){
			if (value==='none')this._bgground=null;
			else (this._bgground || (this._bgground={}),this._bgground.color=value);
			this._ower.model && this._ower.model.bgColor(value);
			this._ower._renderType |=0x80;
		});

		/**@inheritDoc */
		__getset(0,__proto,'absolute',function(){
			return (this._type & 0x4)!==0;
		});

		__getset(0,__proto,'background',null,function(value){
			if (!value){
				this._bgground=null;
				return;
			}
			this._bgground || (this._bgground={});
			this._bgground.color=value;
			this._ower.model && this._ower.model.bgColor(value);
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
					this._ower._layoutLater();
					break ;
				}
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
				if (name.length==0)
					continue ;
				var value=attr.substr(ofs+1).replace(/^\s+|\s+$/g,'');
				var one=[name,value];
				switch (name){
					case 'italic':
					case 'bold':
						one[1]=value=="true";
						break ;
					case 'line-height':
						one[0]='lineHeight';
						one[1]=parseInt(value);
						break ;
					case 'font-size':
						one[0]='fontSize';
						one[1]=parseInt(value);
						break ;
					case 'padding':
						valueArray=value.split(' ');
						valueArray.length > 1 || (valueArray[1]=valueArray[2]=valueArray[3]=valueArray[0]);
						one[1]=[parseInt(valueArray[0]),parseInt(valueArray[1]),parseInt(valueArray[2]),parseInt(valueArray[3])];
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
						one[1]=[parseInt(valueArray[0]),parseInt(valueArray[1])];
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
			//this._mat=null;
			//this._alpha=null;
			ColorFilter.__super.call(this);
			if (!mat){
				mat=[0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0];
			}
			this._mat=new Float32Array(16);
			this._alpha=new Float32Array(4);
			var j=0;
			var z=0;
			for (var i=0;i < 20;i++){
				if (i % 5 !=4){
					this._mat[j++]=mat[i];
					}else {
					this._alpha[z++]=mat[i];
				}
			}
			this._action=RunDriver.createFilterAction(0x20);
			this._action.data=this;
		}

		__class(ColorFilter,'laya.filters.ColorFilter',_super);
		var __proto=ColorFilter.prototype;
		Laya.imps(__proto,{"laya.filters.IFilter":true})
		/**
		*@private 通知微端
		*/
		__proto.callNative=function(sp){
			var t=sp._$P.cf=this;
			sp.model && sp.model.setFilterMatrix&&sp.model.setFilterMatrix(this._mat,this._alpha);
		}

		/**@private */
		__getset(0,__proto,'type',function(){
			return 0x20;
		});

		/**@private */
		__getset(0,__proto,'action',function(){
			return this._action;
		});

		__getset(1,ColorFilter,'DEFAULT',function(){
			if (!ColorFilter._DEFAULT){
				ColorFilter._DEFAULT=new ColorFilter([1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0]);
			}
			return ColorFilter._DEFAULT;
		},laya.filters.Filter._$SET_DEFAULT);

		__getset(1,ColorFilter,'GRAY',function(){
			if (!ColorFilter._GRAY){
				ColorFilter._GRAY=new ColorFilter([0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0]);
			}
			return ColorFilter._GRAY;
		},laya.filters.Filter._$SET_GRAY);

		ColorFilter._DEFAULT=null
		ColorFilter._GRAY=null
		return ColorFilter;
	})(Filter)


	//class laya.webgl.shader.d2.ShaderDefines2D extends laya.webgl.shader.ShaderDefines
	var ShaderDefines2D=(function(_super){
		function ShaderDefines2D(){
			ShaderDefines2D.__super.call(this,ShaderDefines2D.__name2int,ShaderDefines2D.__int2name,ShaderDefines2D.__int2nameMap);
		}

		__class(ShaderDefines2D,'laya.webgl.shader.d2.ShaderDefines2D',_super);
		ShaderDefines2D.__init__=function(){
			ShaderDefines2D.reg("TEXTURE2D",0x01);
			ShaderDefines2D.reg("COLOR2D",0x02);
			ShaderDefines2D.reg("PRIMITIVE",0x04);
			ShaderDefines2D.reg("GLOW_FILTER",0x08);
			ShaderDefines2D.reg("BLUR_FILTER",0x10);
			ShaderDefines2D.reg("COLOR_FILTER",0x20);
			ShaderDefines2D.reg("COLOR_ADD",0x40);
			ShaderDefines2D.reg("WORLDMAT",0x80);
		}

		ShaderDefines2D.reg=function(name,value){
			ShaderDefines._reg(name,value,ShaderDefines2D.__name2int,ShaderDefines2D.__int2name);
		}

		ShaderDefines2D.toText=function(value,int2name,int2nameMap){
			return ShaderDefines._toText(value,int2name,int2nameMap);
		}

		ShaderDefines2D.toInt=function(names){
			return ShaderDefines._toInt(names,ShaderDefines2D.__name2int);
		}

		ShaderDefines2D.TEXTURE2D=0x01;
		ShaderDefines2D.COLOR2D=0x02;
		ShaderDefines2D.PRIMITIVE=0x04;
		ShaderDefines2D.FILTERGLOW=0x08;
		ShaderDefines2D.FILTERBLUR=0x10;
		ShaderDefines2D.FILTERCOLOR=0x20;
		ShaderDefines2D.COLORADD=0x40;
		ShaderDefines2D.WORLDMAT=0x80;
		ShaderDefines2D.FILLTEXTURE=0x100;
		ShaderDefines2D.SKINMESH=0x200;
		ShaderDefines2D.__name2int={};
		ShaderDefines2D.__int2name=[];
		ShaderDefines2D.__int2nameMap=[];
		return ShaderDefines2D;
	})(ShaderDefines)


	//class laya.filters.webgl.ColorFilterActionGL extends laya.filters.webgl.FilterActionGL
	var ColorFilterActionGL=(function(_super){
		function ColorFilterActionGL(){
			this.data=null;
			ColorFilterActionGL.__super.call(this);
		}

		__class(ColorFilterActionGL,'laya.filters.webgl.ColorFilterActionGL',_super);
		var __proto=ColorFilterActionGL.prototype;
		Laya.imps(__proto,{"laya.filters.IFilterActionGL":true})
		__proto.setValue=function(shader){
			shader.colorMat=this.data._mat;
			shader.colorAlpha=this.data._alpha;
		}

		__proto.apply3d=function(scope,sprite,context,x,y){
			var b=scope.getValue("bounds");
			var shaderValue=Value2D.create(0x01,0);
			shaderValue.setFilters([this.data]);
			var tMatrix=Matrix.EMPTY;
			tMatrix.identity();
			context.ctx.drawTarget(scope,0,0,b.width,b.height,tMatrix,"src",shaderValue);
		}

		return ColorFilterActionGL;
	})(FilterActionGL)


	//class laya.webgl.shader.d2.value.Value2D extends laya.webgl.shader.ShaderValue
	var Value2D=(function(_super){
		function Value2D(mainID,subID){
			this.size=[0,0];
			this.alpha=1.0;
			//this.mmat=null;
			this.ALPHA=1.0;
			//this.shader=null;
			//this.mainID=0;
			this.subID=0;
			//this.filters=null;
			//this.textureHost=null;
			//this.texture=null;
			//this.fillStyle=null;
			//this.color=null;
			//this.strokeStyle=null;
			//this.colorAdd=null;
			//this.glTexture=null;
			//this.u_mmat2=null;
			//this._inClassCache=null;
			this._cacheID=0;
			Value2D.__super.call(this);
			this.defines=new ShaderDefines2D();
			this.position=Value2D._POSITION;
			this.mainID=mainID;
			this.subID=subID;
			this.textureHost=null;
			this.texture=null;
			this.fillStyle=null;
			this.color=null;
			this.strokeStyle=null;
			this.colorAdd=null;
			this.glTexture=null;
			this.u_mmat2=null;
			this._cacheID=mainID|subID;
			this._inClassCache=Value2D._cache[this._cacheID];
			if (mainID>0 && !this._inClassCache){
				this._inClassCache=Value2D._cache[this._cacheID]=[];
				this._inClassCache._length=0;
			}
			this.clear();
		}

		__class(Value2D,'laya.webgl.shader.d2.value.Value2D',_super);
		var __proto=Value2D.prototype;
		__proto.setValue=function(value){}
		//throw new Error("todo in subclass");
		__proto.refresh=function(){
			var size=this.size;
			size[0]=RenderState2D.width;
			size[1]=RenderState2D.height;
			this.alpha=this.ALPHA *RenderState2D.worldAlpha;
			this.mmat=RenderState2D.worldMatrix4;
			return this;
		}

		__proto._ShaderWithCompile=function(){
			return Shader.withCompile2D(0,this.mainID,this.defines.toNameDic(),this.mainID | this.defines._value,Shader2X.create);
		}

		__proto._withWorldShaderDefines=function(){
			var defs=RenderState2D.worldShaderDefines;
			var sd=Shader.sharders [this.mainID | this.defines._value | defs.getValue()];
			if (!sd){
				var def={};
				var dic;
				var name;
				dic=this.defines.toNameDic();for (name in dic)def[name]="";
				dic=defs.toNameDic();for (name in dic)def[name]="";
				sd=Shader.withCompile2D(0,this.mainID,def,this.mainID | this.defines._value| defs.getValue(),Shader2X.create);
			};
			var worldFilters=RenderState2D.worldFilters;
			if (!worldFilters)return sd;
			var n=worldFilters.length,f;
			for (var i=0;i < n;i++){
				((f=worldFilters[i]))&& f.action.setValue(this);
			}
			return sd;
		}

		__proto.upload=function(){
			var renderstate2d=RenderState2D;
			this.alpha=this.ALPHA *renderstate2d.worldAlpha;
			if (RenderState2D.worldMatrix4!==RenderState2D.TEMPMAT4_ARRAY)this.defines.add(0x80);
			var sd=renderstate2d.worldShaderDefines?this._withWorldShaderDefines():(Shader.sharders [this.mainID | this.defines._value] || this._ShaderWithCompile());
			var params;
			this.size[0]=renderstate2d.width,this.size[1]=renderstate2d.height;
			this.mmat=renderstate2d.worldMatrix4;
			if (Shader.activeShader!==sd){
				if (sd._shaderValueWidth!==renderstate2d.width || sd._shaderValueHeight!==renderstate2d.height){
					sd._shaderValueWidth=renderstate2d.width;
					sd._shaderValueHeight=renderstate2d.height;
				}
				else{
					params=sd._params2dQuick2 || sd._make2dQuick2();
				}
				sd.upload(this,params);
			}
			else{
				if (sd._shaderValueWidth!==renderstate2d.width || sd._shaderValueHeight!==renderstate2d.height){
					sd._shaderValueWidth=renderstate2d.width;
					sd._shaderValueHeight=renderstate2d.height;
				}
				else{
					params=(sd._params2dQuick1)|| sd._make2dQuick1();
				}
				sd.upload(this,params);
			}
		}

		__proto.setFilters=function(value){
			this.filters=value;
			if (!value)
				return;
			var n=value.length,f;
			for (var i=0;i < n;i++){
				f=value[i];
				if (f){
					this.defines.add(f.type);
					f.action.setValue(this);
				}
			}
		}

		__proto.clear=function(){
			this.defines.setValue(this.subID);
		}

		__proto.release=function(){
			this._inClassCache[this._inClassCache._length++]=this;
			this.fillStyle=null;
			this.strokeStyle=null;
			this.clear();
		}

		Value2D._initone=function(type,classT){
			Value2D._typeClass[type]=classT;
			Value2D._cache[type]=[];
			Value2D._cache[type]._length=0;
		}

		Value2D.__init__=function(){
			Value2D._POSITION=[2,0x1406,false,4 *CONST3D2D.BYTES_PE,0];
			Value2D._TEXCOORD=[2,0x1406,false,4 *CONST3D2D.BYTES_PE,2 *CONST3D2D.BYTES_PE];
			Value2D._initone(0x02,Color2dSV);
			Value2D._initone(0x04,PrimitiveSV);
			Value2D._initone(0x100,FillTextureSV);
			Value2D._initone(0x200,SkinSV);
			Value2D._initone(0x01,TextureSV);
			Value2D._initone(0x01 | 0x40,TextSV);
			Value2D._initone(0x01 | 0x08,TextureSV);
		}

		Value2D.create=function(mainType,subType){
			var types=Value2D._cache[mainType|subType];
			if (types._length)
				return types[--types._length];
			else
			return new Value2D._typeClass[mainType|subType](subType);
		}

		Value2D._POSITION=null
		Value2D._TEXCOORD=null
		Value2D._cache=[];
		Value2D._typeClass=[];
		Value2D.TEMPMAT4_ARRAY=[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];
		return Value2D;
	})(ShaderValue)


	//class laya.webgl.canvas.WebGLContext2D extends laya.resource.Context
	var WebGLContext2D=(function(_super){
		var ContextParams;
		function WebGLContext2D(c){
			this._x=0;
			this._y=0;
			this._id=++WebGLContext2D._COUNT;
			//this._other=null;
			this._path=null;
			//this._primitiveValue2D=null;
			this._drawCount=1;
			this._maxNumEle=0;
			this._clear=false;
			this._isMain=false;
			this._atlasResourceChange=0;
			this._submits=[];
			this._curSubmit=null;
			this._ib=null;
			this._vb=null;
			//this._curMat=null;
			this._nBlendType=0;
			//this._save=null;
			//this._targets=null;
			this._saveMark=null;
			//this.sprite=null;
			this.mId=-1;
			this.mHaveKey=false;
			this.mHaveLineKey=false;
			this.mX=0;
			this.mY=0;
			WebGLContext2D.__super.call(this);
			this._width=99999999;
			this._height=99999999;
			this._clipRect=WebGLContext2D.MAXCLIPRECT;
			this._shader2D=new Shader2D();
			this.mOutPoint
			this._canvas=c;
			this._curMat=Matrix.create();
			if (Render.isFlash){
				this._ib=IndexBuffer2D.create(0x88E4);
				GlUtils.fillIBQuadrangle(this._ib,16);
			}else this._ib=IndexBuffer2D.QuadrangleIB;
			this._vb=VertexBuffer2D.create(-1);
			this._other=ContextParams.DEFAULT;
			this._save=[SaveMark.Create(this)];
			this._save.length=10;
			this.clear();
		}

		__class(WebGLContext2D,'laya.webgl.canvas.WebGLContext2D',_super);
		var __proto=WebGLContext2D.prototype;
		__proto.setIsMainContext=function(){
			this._isMain=true;
		}

		__proto.clearBG=function(r,g,b,a){
			var gl=WebGL.mainContext;
			gl.clearColor(r,g,b,a);
			gl.clear(0x00004000 | 0x00000100);
		}

		__proto._getSubmits=function(){
			return this._submits;
		}

		__proto.destroy=function(){
			this._curMat && this._curMat.destroy();
			this._targets && this._targets.destroy();
			this._vb && this._vb.releaseResource();
			this._ib && (this._ib !=IndexBuffer2D.QuadrangleIB)&& this._ib.releaseResource();
		}

		__proto.clear=function(){
			this._vb.clear();
			this._targets && (this._targets.repaint=true);
			this._other=ContextParams.DEFAULT;
			this._clear=true;
			this._repaint=false;
			this._drawCount=1;
			this._other.lineWidth=this._shader2D.ALPHA=1.0;
			this._nBlendType=0;
			this._clipRect=WebGLContext2D.MAXCLIPRECT;
			this._curSubmit=Submit.RENDERBASE;
			this._shader2D.glTexture=null;
			this._shader2D.fillStyle=this._shader2D.strokeStyle=DrawStyle.DEFAULT;
			for (var i=0,n=this._submits._length;i < n;i++)
			this._submits[i].releaseRender();
			this._submits._length=0;
			this._curMat.identity();
			this._other.clear();
			this._saveMark=this._save[0];
			this._save._length=1;
		}

		__proto.size=function(w,h){
			this._width=w;
			this._height=h;
			this._targets && (this._targets.size(w,h));
		}

		__proto._getTransformMatrix=function(){
			return this._curMat;
		}

		__proto.translate=function(x,y){
			if (x!==0 || y!==0){
				SaveTranslate.save(this);
				if (this._curMat.bTransform){
					SaveTransform.save(this);
					this._curMat.transformPoint(Point.TEMP.setTo(x,y));
					x=Point.TEMP.x;
					y=Point.TEMP.y;
				}
				this._x+=x;
				this._y+=y;
			}
		}

		__proto.save=function(){
			this._save[this._save._length++]=SaveMark.Create(this);
		}

		__proto.restore=function(){
			var sz=this._save._length;
			if (sz < 1)
				return;
			for (var i=sz-1;i >=0;i--){
				var o=this._save[i];
				o.restore(this);
				if (o.isSaveMark()){
					this._save._length=i;
					return;
				}
			}
		}

		__proto.measureText=function(text){
			return RunDriver.measureText(text,this._other.font.toString());
		}

		__proto._fillText=function(txt,words,x,y,fontStr,color,textAlign){
			var shader=this._shader2D;
			var curShader=this._curSubmit.shaderValue;
			var font=fontStr ? FontInContext.create(fontStr):this._other.font;
			if (AtlasResourceManager.enabled){
				if (shader.ALPHA!==curShader.ALPHA)
					shader.glTexture=null;
				DrawText.drawText(this,txt,words,this._curMat,font,textAlign || this._other.textAlign,color,null,-1,x,y);
				}else {
				var preDef=this._shader2D.defines.getValue();
				var colorAdd=color ? Color.create(color)._color :shader.colorAdd;
				if (shader.ALPHA!==curShader.ALPHA || colorAdd!==shader.colorAdd || curShader.colorAdd!==shader.colorAdd){
					shader.glTexture=null;
					shader.colorAdd=colorAdd;
				}
				DrawText.drawText(this,txt,words,this._curMat,font,textAlign || this._other.textAlign,color,null,-1,x,y);
			}
		}

		//shader.defines.setValue(preDef);
		__proto.fillWords=function(words,x,y,fontStr,color){
			words.length > 0 && this._fillText(null,words,x,y,fontStr,color,null);
		}

		__proto.fillText=function(txt,x,y,fontStr,color,textAlign){
			txt.length > 0 && this._fillText(txt,null,x,y,fontStr,color,textAlign);
		}

		__proto.strokeText=function(txt,x,y,fontStr,color,lineWidth,textAlign){
			if (txt.length===0)
				return;
			var shader=this._shader2D;
			var curShader=this._curSubmit.shaderValue;
			var font=fontStr ? (WebGLContext2D._fontTemp.setFont(fontStr),WebGLContext2D._fontTemp):this._other.font;
			if (AtlasResourceManager.enabled){
				if (shader.ALPHA!==curShader.ALPHA){
					shader.glTexture=null;
				}
				DrawText.drawText(this,txt,null,this._curMat,font,textAlign || this._other.textAlign,null,color,lineWidth || 1,x,y);
				}else {
				var preDef=this._shader2D.defines.getValue();
				var colorAdd=color ? Color.create(color)._color :shader.colorAdd;
				if (shader.ALPHA!==curShader.ALPHA || colorAdd!==shader.colorAdd || curShader.colorAdd!==shader.colorAdd){
					shader.glTexture=null;
					shader.colorAdd=colorAdd;
				}
				DrawText.drawText(this,txt,null,this._curMat,font,textAlign || this._other.textAlign,null,color,lineWidth || 1,x,y);
			}
		}

		//shader.defines.setValue(preDef);
		__proto.fillBorderText=function(txt,x,y,fontStr,fillColor,borderColor,lineWidth,textAlign){
			if (txt.length===0)
				return;
			if (!AtlasResourceManager.enabled){
				this.strokeText(txt,x,y,fontStr,borderColor,lineWidth,textAlign);
				this.fillText(txt,x,y,fontStr,fillColor,textAlign);
				return;
			};
			var shader=this._shader2D;
			var curShader=this._curSubmit.shaderValue;
			if (shader.ALPHA!==curShader.ALPHA)
				shader.glTexture=null;
			var font=fontStr ? (WebGLContext2D._fontTemp.setFont(fontStr),WebGLContext2D._fontTemp):this._other.font;
			DrawText.drawText(this,txt,null,this._curMat,font,textAlign || this._other.textAlign,fillColor,borderColor,lineWidth || 1,x,y);
		}

		__proto.fillRect=function(x,y,width,height,fillStyle){
			var vb=this._vb;
			if (GlUtils.fillRectImgVb(vb,this._clipRect,x,y,width,height,Texture.DEF_UV,this._curMat,this._x,this._y,0,0)){
				var pre=this._shader2D.fillStyle;
				fillStyle && (this._shader2D.fillStyle=DrawStyle.create(fillStyle));
				var shader=this._shader2D;
				var curShader=this._curSubmit.shaderValue;
				if (shader.fillStyle!==curShader.fillStyle || shader.ALPHA!==curShader.ALPHA){
					shader.glTexture=null;
					var submit=this._curSubmit=Submit.create(this,this._ib,vb,((vb._byteLength-16 *4)/ 32)*3,Value2D.create(0x02,0));
					submit.shaderValue.color=shader.fillStyle._color._color;
					submit.shaderValue.ALPHA=shader.ALPHA;
					this._submits[this._submits._length++]=submit;
				}
				this._curSubmit._numEle+=6;
				this._shader2D.fillStyle=pre;
			}
		}

		__proto.setShader=function(shader){
			SaveBase.save(this,0x80000,this._shader2D,true);
			this._shader2D.shader=shader;
		}

		__proto.setFilters=function(value){
			SaveBase.save(this,0x100000,this._shader2D,true);
			this._shader2D.filters=value;
			this._curSubmit=Submit.RENDERBASE;
			this._drawCount++;
		}

		__proto.drawTexture=function(tex,x,y,width,height,tx,ty){
			this._drawTextureM(tex,x,y,width,height,tx,ty,null,1);
		}

		__proto.drawTextures=function(tex,pos,tx,ty){
			if (!(tex.loaded && tex.bitmap && tex.source)){
				if (this.sprite){
					Laya.timer.callLater(this,this._repaintSprite);
				}
				return;
			};
			var pre=this._clipRect;
			this._clipRect=WebGLContext2D.MAXCLIPRECT;
			if (!this._drawTextureM(tex,pos[0],pos[1],tex.width,tex.height,tx,ty,null,1)){
				alert("drawTextures err");
				return;
			}
			this._clipRect=pre;
			Stat.drawCall+=pos.length / 2;
			if (pos.length < 4)return;
			var finalVB=this._curSubmit._vb || this._vb;
			var sx=this._curMat.a,sy=this._curMat.d;
			for (var i=2,sz=pos.length;i < sz;i+=2){
				GlUtils.copyPreImgVb(finalVB,(pos[i]-pos[i-2])*sx,(pos[i+1]-pos[i-1])*sy);
				this._curSubmit._numEle+=6;
			}
			this._maxNumEle=Math.max(this._maxNumEle,this._curSubmit._numEle);
		}

		__proto._drawTextureM=function(tex,x,y,width,height,tx,ty,m,alpha){
			if (!(tex.loaded && tex.bitmap && tex.source)){
				if (this.sprite){
					Laya.timer.callLater(this,this._repaintSprite);
				}
				return false;
			};
			var webGLImg=tex.bitmap;
			var shader=this._shader2D;
			var preAlpha=shader.ALPHA;
			var curShader=this._curSubmit.shaderValue;
			var finalVB=this._curSubmit._vb || this._vb;
			this._drawCount++;
			x+=tx;
			y+=ty;
			shader.ALPHA *=alpha;
			if (this._curSubmit._renderType!==16 || shader.glTexture!==webGLImg || shader.ALPHA!==curShader.ALPHA){
				shader.glTexture=webGLImg;
				var vb=this._vb;
				var submit=null;
				var vbSize=(vb._byteLength / 32)*3;
				submit=SubmitTexture.create(this,this._ib,vb,vbSize,Value2D.create(0x01,0));
				this._submits[this._submits._length++]=submit;
				submit.shaderValue.textureHost=tex;
				submit._renderType=16;
				submit._preIsSameTextureShader=this._curSubmit._renderType===16 && shader.ALPHA===curShader.ALPHA;
				this._curSubmit=submit;
				finalVB=this._curSubmit._vb || this._vb;
			}
			shader.ALPHA=preAlpha;
			if (GlUtils.fillRectImgVb(finalVB,this._clipRect,x,y,width || tex.width,height || tex.height,tex.uv,m || this._curMat,this._x,this._y,0,0)){
				if (AtlasResourceManager.enabled && !this._isMain)
					(this._curSubmit).addTexture(tex,(finalVB._byteLength >> 2)-16);
				this._curSubmit._numEle+=6;
				this._maxNumEle=Math.max(this._maxNumEle,this._curSubmit._numEle);
				return true;
			}
			return false;
		}

		__proto._repaintSprite=function(){
			this.sprite.repaint();
		}

		//}
		__proto._drawText=function(tex,x,y,width,height,m,tx,ty,dx,dy){
			var webGLImg=tex.bitmap;
			var shader=this._shader2D;
			var curShader=this._curSubmit.shaderValue;
			this._drawCount++;
			if (this._curSubmit._renderType!==16 || shader.glTexture!==webGLImg || shader.ALPHA!==curShader.ALPHA){
				shader.glTexture=webGLImg;
				var vb=this._vb;
				var submit=null;
				var submitID=NaN;
				var vbSize=(vb._byteLength / 32)*3;
				if (AtlasResourceManager.enabled){
					submit=SubmitTexture.create(this,this._ib,vb,vbSize,Value2D.create(0x01,0));
					}else {
					submit=SubmitTexture.create(this,this._ib,vb,vbSize,TextSV.create());
				}
				submit._preIsSameTextureShader=this._curSubmit._renderType===16 && shader.ALPHA===curShader.ALPHA;
				this._submits[this._submits._length++]=submit;
				submit.shaderValue.textureHost=tex;
				submit._renderType=16;
				this._curSubmit=submit;
			}
			tex.active();
			var finalVB=this._curSubmit._vb || this._vb;
			if (GlUtils.fillRectImgVb(finalVB,this._clipRect,x+tx,y+ty,width || tex.width,height || tex.height,tex.uv,m || this._curMat,this._x,this._y,dx,dy,true)){
				if (AtlasResourceManager.enabled && !this._isMain){
					(this._curSubmit).addTexture(tex,(finalVB._byteLength >> 2)-16);
				}
				this._curSubmit._numEle+=6;
				this._maxNumEle=Math.max(this._maxNumEle,this._curSubmit._numEle);
			}
		}

		__proto.drawTextureWithTransform=function(tex,x,y,width,height,transform,tx,ty,alpha){
			var curMat=this._curMat;
			(tx!==0 || ty!==0)&& (this._x=tx *curMat.a+ty *curMat.c,this._y=ty *curMat.d+tx *curMat.b);
			if (transform && curMat.bTransform){
				Matrix.mul(transform,curMat,WebGLContext2D._tmpMatrix);
				transform=WebGLContext2D._tmpMatrix;
				transform._checkTransform();
				}else {
				this._x+=curMat.tx;
				this._y+=curMat.ty;
			}
			this._drawTextureM(tex,x,y,width,height,0,0,transform,alpha);
			this._x=this._y=0;
		}

		__proto.fillQuadrangle=function(tex,x,y,point4,m){
			var submit=this._curSubmit;
			var vb=this._vb;
			var shader=this._shader2D;
			var curShader=submit.shaderValue;
			if (tex.bitmap){
				var t_tex=tex.bitmap;
				if (shader.glTexture !=t_tex || shader.ALPHA!==curShader.ALPHA){
					shader.glTexture=t_tex;
					submit=this._curSubmit=Submit.create(this,this._ib,vb,((vb._byteLength)/ 32)*3,Value2D.create(0x01,0));
					submit.shaderValue.glTexture=t_tex;
					this._submits[this._submits._length++]=submit;
				}
				GlUtils.fillQuadrangleImgVb(vb,x,y,point4,tex.uv,m || this._curMat,this._x,this._y);
				}else {
				if (!submit.shaderValue.fillStyle || !submit.shaderValue.fillStyle.equal(tex)|| shader.ALPHA!==curShader.ALPHA){
					shader.glTexture=null;
					submit=this._curSubmit=Submit.create(this,this._ib,vb,((vb._byteLength)/ 32)*3,Value2D.create(0x02,0));
					submit.shaderValue.defines.add(0x02);
					submit.shaderValue.fillStyle=DrawStyle.create(tex);
					this._submits[this._submits._length++]=submit;
				}
				GlUtils.fillQuadrangleImgVb(vb,x,y,point4,Texture.DEF_UV,m || this._curMat,this._x,this._y);
			}
			submit._numEle+=6;
		}

		__proto.drawTexture2=function(x,y,pivotX,pivotY,transform,alpha,blendMode,args){
			var curMat=this._curMat;
			this._x=x *curMat.a+y *curMat.c;
			this._y=y *curMat.d+x *curMat.b;
			if (transform){
				if (curMat.bTransform || transform.bTransform){
					Matrix.mul(transform,curMat,WebGLContext2D._tmpMatrix);
					transform=WebGLContext2D._tmpMatrix;
					}else {
					this._x+=transform.tx+curMat.tx;
					this._y+=transform.ty+curMat.ty;
					transform=Matrix.EMPTY;
				}
			}
			if (alpha===1 && !blendMode)
				this._drawTextureM(args[0],args[1]-pivotX,args[2]-pivotY,args[3],args[4],0,0,transform,1);
			else {
				var preAlpha=this._shader2D.ALPHA;
				var preblendType=this._nBlendType;
				this._shader2D.ALPHA=alpha;
				blendMode && (this._nBlendType=BlendMode.TOINT(blendMode));
				this._drawTextureM(args[0],args[1]-pivotX,args[2]-pivotY,args[3],args[4],0,0,transform,1);
				this._shader2D.ALPHA=preAlpha;
				this._nBlendType=preblendType;
			}
			this._x=this._y=0;
		}

		__proto.drawCanvas=function(canvas,x,y,width,height){
			var src=canvas.context;
			if (src._targets){
				this._submits[this._submits._length++]=SubmitCanvas.create(src,0,null);
				this._curSubmit=Submit.RENDERBASE;
				src._targets.drawTo(this,x,y,width,height);
				}else {
				var submit=this._submits[this._submits._length++]=SubmitCanvas.create(src,this._shader2D.ALPHA,this._shader2D.filters);
				var sx=width / canvas.width;
				var sy=height / canvas.height;
				var mat=submit._matrix;
				this._curMat.copyTo(mat);
				sx !=1 && sy !=1 && mat.scale(sx,sy);
				var tx=mat.tx,ty=mat.ty;
				mat.tx=mat.ty=0;
				mat.transformPoint(Point.TEMP.setTo(x,y));
				mat.translate(Point.TEMP.x+tx,Point.TEMP.y+ty);
				this._curSubmit=Submit.RENDERBASE;
			}
			if (Config.showCanvasMark){
				this.save();
				this.lineWidth=4;
				this.strokeStyle=src._targets ? "yellow" :"green";
				this.strokeRect(x-1,y-1,width+2,height+2,1);
				this.strokeRect(x,y,width,height,1);
				this.restore();
			}
		}

		__proto.drawTarget=function(scope,x,y,width,height,m,proName,shaderValue,uv,blend){
			(blend===void 0)&& (blend=-1);
			var vb=this._vb;
			if (GlUtils.fillRectImgVb(vb,this._clipRect,x,y,width,height,uv || Texture.DEF_UV,m || this._curMat,this._x,this._y,0,0)){
				var shader=this._shader2D;
				shader.glTexture=null;
				var curShader=this._curSubmit.shaderValue;
				var submit=this._curSubmit=SubmitTarget.create(this,this._ib,vb,((vb._byteLength-16 *4)/ 32)*3,shaderValue,proName);
				if (blend==-1){
					submit.blendType=this._nBlendType;
					}else {
					submit.blendType=blend;
				}
				submit.scope=scope;
				this._submits[this._submits._length++]=submit;
				this._curSubmit._numEle+=6;
			}
		}

		__proto.transform=function(a,b,c,d,tx,ty){
			SaveTransform.save(this);
			Matrix.mul(Matrix.TEMP.setTo(a,b,c,d,tx,ty),this._curMat,this._curMat);
			this._curMat._checkTransform();
		}

		__proto.setTransformByMatrix=function(value){
			value.copyTo(this._curMat);
		}

		__proto.transformByMatrix=function(value){
			SaveTransform.save(this);
			Matrix.mul(value,this._curMat,this._curMat);
			this._curMat._checkTransform();
		}

		__proto.rotate=function(angle){
			SaveTransform.save(this);
			this._curMat.rotate(angle);
		}

		__proto.scale=function(scaleX,scaleY){
			SaveTransform.save(this);
			this._curMat.scale(scaleX,scaleY);
		}

		__proto.clipRect=function(x,y,width,height){
			width *=this._curMat.a;
			height *=this._curMat.d;
			var p=Point.TEMP;
			this._curMat.transformPoint(p.setTo(x,y));
			var submit=this._curSubmit=SubmitScissor.create(this);
			this._submits[this._submits._length++]=submit;
			submit.submitIndex=this._submits._length;
			submit.submitLength=9999999;
			SaveClipRect.save(this,submit);
			var clip=this._clipRect;
			var x1=clip.x,y1=clip.y;
			var r=p.x+width,b=p.y+height;
			x1 < p.x && (clip.x=p.x);
			y1 < p.y && (clip.y=p.y);
			clip.width=Math.min(r,x1+clip.width)-clip.x;
			clip.height=Math.min(b,y1+clip.height)-clip.y;
			this._shader2D.glTexture=null;
			submit.clipRect.copyFrom(clip);
			this._curSubmit=Submit.RENDERBASE;
		}

		__proto.setIBVB=function(x,y,ib,vb,numElement,mat,shader,shaderValues,startIndex,offset,type){
			(startIndex===void 0)&& (startIndex=0);
			(offset===void 0)&& (offset=0);
			(type===void 0)&& (type=0);
			if (ib===null){
				if (!Render.isFlash){
					ib=this._ib;
					}else {
					var falshVB=vb;
					(falshVB._selfIB)|| (falshVB._selfIB=IndexBuffer2D.create(0x88E4));
					falshVB._selfIB.clear();
					ib=falshVB._selfIB;
				}
				GlUtils.expandIBQuadrangle(ib,(vb.byteLength / (4 *vb.vertexStride *4)));
			}
			if (!shaderValues || !shader)
				throw Error("setIBVB must input:shader shaderValues");
			var submit=SubmitOtherIBVB.create(this,vb,ib,numElement,shader,shaderValues,startIndex,offset,type);
			mat || (mat=Matrix.EMPTY);
			mat.translate(x,y);
			Matrix.mul(mat,this._curMat,submit._mat);
			mat.translate(-x,-y);
			this._submits[this._submits._length++]=submit;
			this._curSubmit=Submit.RENDERBASE;
		}

		__proto.addRenderObject=function(o){
			this._submits[this._submits._length++]=o;
		}

		__proto.fillTrangles=function(tex,x,y,points,m){
			var submit=this._curSubmit;
			var vb=this._vb;
			var shader=this._shader2D;
			var curShader=submit.shaderValue;
			var length=points.length >> 4;
			var t_tex=tex.bitmap;
			if (shader.glTexture !=t_tex || shader.ALPHA!==curShader.ALPHA){
				submit=this._curSubmit=Submit.create(this,this._ib,vb,((vb._byteLength)/ 32)*3,Value2D.create(0x01,0));
				submit.shaderValue.textureHost=tex;
				this._submits[this._submits._length++]=submit;
			}
			GlUtils.fillTranglesVB(vb,x,y,points,m || this._curMat,this._x,this._y);
			submit._numEle+=length *6;
		}

		__proto.submitElement=function(start,end){
			var renderList=this._submits;
			end < 0 && (end=renderList._length);
			while (start < end){
				start+=renderList[start].renderSubmit();
			}
		}

		__proto.finish=function(){
			WebGL.mainContext.finish();
		}

		__proto.flush=function(){
			var maxNum=Math.max(this._vb.byteLength / (4 *16),this._maxNumEle / 6)+8;
			if (maxNum > (this._ib.bufferLength / (6 *2))){
				GlUtils.expandIBQuadrangle(this._ib,maxNum);
			}
			if (!this._isMain && AtlasResourceManager.enabled && AtlasResourceManager._atlasRestore > this._atlasResourceChange){
				this._atlasResourceChange=AtlasResourceManager._atlasRestore;
				var renderList=this._submits;
				for (var i=0,s=renderList._length;i < s;i++){
					var submit=renderList [i];
					if (submit.getRenderType()===16)
						(submit).checkTexture();
				}
			}
			this.submitElement(0,this._submits._length);
			this._path && this._path.reset();
			SkinMeshBuffer.instance && SkinMeshBuffer.getInstance().reset();
			this._curSubmit=Submit.RENDERBASE;
			return this._submits._length;
		}

		__proto.setPathId=function(id){
			this.mId=id;
			if (this.mId !=-1){
				this.mHaveKey=false;
				var tVGM=VectorGraphManager.getInstance();
				if (tVGM.shapeDic[this.mId]){
					this.mHaveKey=true;
				}
				this.mHaveLineKey=false;
				if (tVGM.shapeLineDic[this.mId]){
					this.mHaveLineKey=true;
				}
			}
		}

		__proto.movePath=function(x,y){
			this.mX+=x;
			this.mY+=y;
		}

		__proto.beginPath=function(){
			var tPath=this._getPath();
			tPath.tempArray.length=0;
			tPath.closePath=false;
			this.mX=0;
			this.mY=0;
		}

		__proto.closePath=function(){
			this._path.closePath=true;
		}

		__proto.fill=function(isConvexPolygon){
			(isConvexPolygon===void 0)&& (isConvexPolygon=false);
			var tPath=this._getPath();
			this.drawPoly(0,0,tPath.tempArray,this.fillStyle._color.numColor,0,0,isConvexPolygon);
		}

		__proto.stroke=function(){
			var tPath=this._getPath();
			if (this.lineWidth > 0){
				if (this.mId==-1){
					tPath.drawLine(0,0,tPath.tempArray,this.lineWidth,this.strokeStyle._color.numColor);
					}else {
					if (this.mHaveLineKey){
						var tShapeLine=VectorGraphManager.getInstance().shapeLineDic[this.mId];
						tPath.setGeomtry(tShapeLine);
						}else {
						VectorGraphManager.getInstance().addLine(this.mId,tPath.drawLine(0,0,tPath.tempArray,this.lineWidth,this.strokeStyle._color.numColor));
					}
				}
				tPath.update();
				var tArray=RenderState2D.getMatrArray();
				RenderState2D.mat2MatArray(this._curMat,tArray);
				var tPosArray=[this.mX,this.mY];
				var tempSubmit=Submit.createShape(this,tPath.ib,tPath.vb,tPath.count,tPath.offset,Value2D.create(0x04,0));
				tempSubmit.shaderValue.ALPHA=this._shader2D.ALPHA;
				(tempSubmit.shaderValue).u_pos=tPosArray;
				tempSubmit.shaderValue.u_mmat2=tArray;
				this._submits[this._submits._length++]=tempSubmit;
			}
		}

		__proto.line=function(fromX,fromY,toX,toY,lineWidth,mat){
			var submit=this._curSubmit;
			var vb=this._vb;
			if (GlUtils.fillLineVb(vb,this._clipRect,fromX,fromY,toX,toY,lineWidth,mat)){
				var shader=this._shader2D;
				var curShader=submit.shaderValue;
				if (shader.strokeStyle!==curShader.strokeStyle || shader.ALPHA!==curShader.ALPHA){
					shader.glTexture=null;
					submit=this._curSubmit=Submit.create(this,this._ib,vb,((vb._byteLength-16 *4)/ 32)*3,Value2D.create(0x02,0));
					submit.shaderValue.strokeStyle=shader.strokeStyle;
					submit.shaderValue.mainID=0x02;
					submit.shaderValue.ALPHA=shader.ALPHA;
					this._submits[this._submits._length++]=submit;
				}
				submit._numEle+=6;
			}
		}

		__proto.moveTo=function(x,y){
			var tPath=this._getPath();
			tPath.addPoint(x,y);
		}

		__proto.lineTo=function(x,y){
			var tPath=this._getPath();
			tPath.addPoint(x,y);
		}

		__proto.arcTo=function(x1,y1,x2,y2,r){
			if (this.mId !=-1){
				if (this.mHaveKey){
					return;
				}
			};
			var tPath=this._getPath();
			var x0=tPath.getEndPointX();
			var y0=tPath.getEndPointY();
			var dx0=NaN,dy0=NaN,dx1=NaN,dy1=NaN,a=NaN,d=NaN,cx=NaN,cy=NaN,a0=NaN,a1=NaN;
			var dir=false;
			dx0=x0-x1;
			dy0=y0-y1;
			dx1=x2-x1;
			dy1=y2-y1;
			Point.TEMP.setTo(dx0,dy0);
			Point.TEMP.normalize();
			dx0=Point.TEMP.x;
			dy0=Point.TEMP.y;
			Point.TEMP.setTo(dx1,dy1);
			Point.TEMP.normalize();
			dx1=Point.TEMP.x;
			dy1=Point.TEMP.y;
			a=Math.acos(dx0 *dx1+dy0 *dy1);
			var tTemp=Math.tan(a / 2.0);
			d=r / tTemp;
			if (d > 10000){
				this.lineTo(x1,y1);
				return;
			}
			if (dx0 *dy1-dx1 *dy0 <=0.0){
				cx=x1+dx0 *d+dy0 *r;
				cy=y1+dy0 *d-dx0 *r;
				a0=Math.atan2(dx0,-dy0);
				a1=Math.atan2(-dx1,dy1);
				dir=false;
				}else {
				cx=x1+dx0 *d-dy0 *r;
				cy=y1+dy0 *d+dx0 *r;
				a0=Math.atan2(-dx0,dy0);
				a1=Math.atan2(dx1,-dy1);
				dir=true;
			}
			this.arc(cx,cy,r,a0,a1,dir);
		}

		__proto.arc=function(cx,cy,r,startAngle,endAngle,counterclockwise){
			(counterclockwise===void 0)&& (counterclockwise=false);
			if (this.mId !=-1){
				if (this.mHaveKey){
					return;
				}
				cx=0;
				cy=0;
			};
			var a=0,da=0,hda=0,kappa=0;
			var dx=0,dy=0,x=0,y=0,tanx=0,tany=0;
			var px=0,py=0,ptanx=0,ptany=0;
			var i=0,ndivs=0,nvals=0;
			da=endAngle-startAngle;
			if (!counterclockwise){
				if (Math.abs(da)>=Math.PI *2){
					da=Math.PI *2;
					}else {
					while (da < 0.0){
						da+=Math.PI *2;
					}
				}
				}else {
				if (Math.abs(da)>=Math.PI *2){
					da=-Math.PI *2;
					}else {
					while (da > 0.0){
						da-=Math.PI *2;
					}
				}
			}
			if (r < 101){
				ndivs=Math.max(10,da *r / 5);
				}else if (r < 201){
				ndivs=Math.max(10,da *r / 20);
				}else {
				ndivs=Math.max(10,da *r / 40);
			}
			hda=(da / ndivs)/ 2.0;
			kappa=Math.abs(4 / 3 *(1-Math.cos(hda))/ Math.sin(hda));
			if (counterclockwise)
				kappa=-kappa;
			nvals=0;
			var tPath=this._getPath();
			for (i=0;i <=ndivs;i++){
				a=startAngle+da *(i / ndivs);
				dx=Math.cos(a);
				dy=Math.sin(a);
				x=cx+dx *r;
				y=cy+dy *r;
				if (x !=this._path.getEndPointX()|| y !=this._path.getEndPointY()){
					tPath.addPoint(x,y);
				}
			}
			dx=Math.cos(endAngle);
			dy=Math.sin(endAngle);
			x=cx+dx *r;
			y=cy+dy *r;
			if (x !=this._path.getEndPointX()|| y !=this._path.getEndPointY()){
				tPath.addPoint(x,y);
			}
		}

		__proto.quadraticCurveTo=function(cpx,cpy,x,y){
			var tBezier=Bezier.I;
			var tResultArray=[];
			var tArray=tBezier.getBezierPoints([this._path.getEndPointX(),this._path.getEndPointY(),cpx,cpy,x,y],30,2);
			for (var i=0,n=tArray.length / 2;i < n;i++){
				this.lineTo(tArray[i *2],tArray[i *2+1]);
			}
			this.lineTo(x,y);
		}

		__proto.rect=function(x,y,width,height){
			this._other=this._other.make();
			this._other.path || (this._other.path=new Path());
			this._other.path.rect(x,y,width,height);
		}

		__proto.strokeRect=function(x,y,width,height,parameterLineWidth){
			var tW=parameterLineWidth *0.5;
			this.line(x-tW,y,x+width+tW,y,parameterLineWidth,this._curMat);
			this.line(x+width,y,x+width,y+height,parameterLineWidth,this._curMat);
			this.line(x,y,x,y+height,parameterLineWidth,this._curMat);
			this.line(x-tW,y+height,x+width+tW,y+height,parameterLineWidth,this._curMat);
		}

		__proto.clip=function(){}
		/**
		*画多边形(用)
		*@param x
		*@param y
		*@param points
		*/
		__proto.drawPoly=function(x,y,points,color,lineWidth,boderColor,isConvexPolygon){
			(isConvexPolygon===void 0)&& (isConvexPolygon=false);
			this._shader2D.glTexture=null;
			var tPath=this._getPath();
			if (this.mId==-1){
				tPath.polygon(x,y,points,color,lineWidth ? lineWidth :1,boderColor)
				}else {
				if (this.mHaveKey){
					var tShape=VectorGraphManager.getInstance().shapeDic[this.mId];
					tPath.setGeomtry(tShape);
					}else {
					VectorGraphManager.getInstance().addShape(this.mId,tPath.polygon(x,y,points,color,lineWidth ? lineWidth :1,boderColor));
				}
			}
			tPath.update();
			var tPosArray=[this.mX,this.mY];
			var tArray=RenderState2D.getMatrArray();
			RenderState2D.mat2MatArray(this._curMat,tArray);
			var tempSubmit;
			if (!isConvexPolygon){
				var submit=SubmitStencil.create(4);
				this.addRenderObject(submit);
				tempSubmit=Submit.createShape(this,tPath.ib,tPath.vb,tPath.count,tPath.offset,Value2D.create(0x04,0));
				tempSubmit.shaderValue.ALPHA=this._shader2D.ALPHA;
				(tempSubmit.shaderValue).u_pos=tPosArray;
				tempSubmit.shaderValue.u_mmat2=tArray;
				this._submits[this._submits._length++]=tempSubmit;
				submit=SubmitStencil.create(5);
				this.addRenderObject(submit);
			}
			tempSubmit=Submit.createShape(this,tPath.ib,tPath.vb,tPath.count,tPath.offset,Value2D.create(0x04,0));
			tempSubmit.shaderValue.ALPHA=this._shader2D.ALPHA;
			(tempSubmit.shaderValue).u_pos=tPosArray;
			tempSubmit.shaderValue.u_mmat2=tArray;
			this._submits[this._submits._length++]=tempSubmit;
			if (!isConvexPolygon){
				submit=SubmitStencil.create(3);
				this.addRenderObject(submit);
			}
			if (lineWidth > 0){
				if (this.mHaveLineKey){
					var tShapeLine=VectorGraphManager.getInstance().shapeLineDic[this.mId];
					tPath.setGeomtry(tShapeLine);
					}else {
					VectorGraphManager.getInstance().addShape(this.mId,tPath.drawLine(x,y,points,lineWidth,boderColor));
				}
				tPath.update();
				tempSubmit=Submit.createShape(this,tPath.ib,tPath.vb,tPath.count,tPath.offset,Value2D.create(0x04,0));
				tempSubmit.shaderValue.ALPHA=this._shader2D.ALPHA;
				tempSubmit.shaderValue.u_mmat2=tArray;
				this._submits[this._submits._length++]=tempSubmit;
			}
		}

		/*******************************************end矢量绘制***************************************************/
		__proto.drawParticle=function(x,y,pt){
			pt.x=x;
			pt.y=y;
			this._submits[this._submits._length++]=pt;
		}

		__proto._getPath=function(){
			return this._path || (this._path=new Path());
		}

		__getset(0,__proto,'asBitmap',null,function(value){
			if (value){
				this._targets || (this._targets=new RenderTargetMAX());
				this._targets.repaint=true;
				if (!this._width || !this._height)throw Error("asBitmap no size!");
				this._targets.size(this._width,this._height);
			}else this._targets=null;
		});

		__getset(0,__proto,'fillStyle',function(){
			return this._shader2D.fillStyle;
			},function(value){
			this._shader2D.fillStyle.equal(value)|| (SaveBase.save(this,0x2,this._shader2D,false),this._shader2D.fillStyle=DrawStyle.create(value));
		});

		/*,_shader2D.ALPHA=1*/
		__getset(0,__proto,'globalCompositeOperation',function(){
			return BlendMode.NAMES[this._nBlendType];
			},function(value){
			var n=BlendMode.TOINT[value];
			n==null || (this._nBlendType===n)|| (SaveBase.save(this,0x10000,this,true),this._curSubmit=Submit.RENDERBASE,this._nBlendType=n);
		});

		__getset(0,__proto,'textAlign',function(){
			return this._other.textAlign;
			},function(value){
			(this._other.textAlign===value)|| (this._other=this._other.make(),SaveBase.save(this,0x8000,this._other,false),this._other.textAlign=value);
		});

		__getset(0,__proto,'globalAlpha',function(){
			return this._shader2D.ALPHA;
			},function(value){
			value=Math.floor(value *1000)/ 1000;
			if (value !=this._shader2D.ALPHA){
				SaveBase.save(this,0x1,this._shader2D,true);
				this._shader2D.ALPHA=value;
			}
		});

		__getset(0,__proto,'textBaseline',function(){
			return this._other.textBaseline;
			},function(value){
			(this._other.textBaseline===value)|| (this._other=this._other.make(),SaveBase.save(this,0x4000,this._other,false),this._other.textBaseline=value);
		});

		__getset(0,__proto,'font',null,function(str){
			if (str==this._other.font.toString())
				return;
			this._other=this._other.make();
			SaveBase.save(this,0x8,this._other,false);
			this._other.font===FontInContext.EMPTY ? (this._other.font=new FontInContext(str)):(this._other.font.setFont(str));
		});

		__getset(0,__proto,'strokeStyle',function(){
			return this._shader2D.strokeStyle;
			},function(value){
			this._shader2D.strokeStyle.equal(value)|| (SaveBase.save(this,0x200,this._shader2D,false),this._shader2D.strokeStyle=DrawStyle.create(value));
		});

		__getset(0,__proto,'lineWidth',function(){
			return this._other.lineWidth;
			},function(value){
			(this._other.lineWidth===value)|| (this._other=this._other.make(),SaveBase.save(this,0x100,this._other,false),this._other.lineWidth=value);
		});

		WebGLContext2D.__init__=function(){
			ContextParams.DEFAULT=new ContextParams();
		}

		WebGLContext2D._SUBMITVBSIZE=32000;
		WebGLContext2D._MAXSIZE=99999999;
		WebGLContext2D._RECTVBSIZE=16;
		WebGLContext2D.MAXCLIPRECT=new Rectangle(0,0,99999999,99999999);
		WebGLContext2D._COUNT=0;
		WebGLContext2D._tmpMatrix=new Matrix();
		__static(WebGLContext2D,
		['_fontTemp',function(){return this._fontTemp=new FontInContext();},'_drawStyleTemp',function(){return this._drawStyleTemp=new DrawStyle(null);}
		]);
		WebGLContext2D.__init$=function(){
			//class ContextParams
			ContextParams=(function(){
				function ContextParams(){
					this.lineWidth=1;
					this.path=null;
					this.textAlign=null;
					this.textBaseline=null;
					this.font=FontInContext.EMPTY;
				}
				__class(ContextParams,'');
				var __proto=ContextParams.prototype;
				__proto.clear=function(){
					this.lineWidth=1;
					this.path && this.path.clear();
					this.textAlign=this.textBaseline=null;
					this.font=FontInContext.EMPTY;
				}
				__proto.make=function(){
					return this===ContextParams.DEFAULT ? new ContextParams():this;
				}
				ContextParams.DEFAULT=null
				return ContextParams;
			})()
		}

		return WebGLContext2D;
	})(Context)


	//class laya.webgl.utils.RenderSprite3D extends laya.renders.RenderSprite
	var RenderSprite3D=(function(_super){
		function RenderSprite3D(type,next){
			RenderSprite3D.__super.call(this,type,next);
		}

		__class(RenderSprite3D,'laya.webgl.utils.RenderSprite3D',_super);
		var __proto=RenderSprite3D.prototype;
		__proto.onCreate=function(type){
			switch (type){
				case 0x20:
					this._fun=this._blend;
					return;
				case 0x04:
					this._fun=this._transform;
					return;
				}
		}

		__proto._blend=function(sprite,context,x,y){
			var style=sprite._style;
			var next=this._next;
			var mask=sprite.mask;
			var submitCMD;
			var submitStencil;
			context.ctx.save();
			if (mask){
				var preBlendMode=(context.ctx).globalCompositeOperation;
				var tRect=new Rectangle();
				tRect.copyFrom(mask.getBounds());
				if (tRect.width > 0 && tRect.height > 0){
					var scope=SubmitCMDScope.create();
					scope.addValue("bounds",tRect);
					submitCMD=SubmitCMD.create([scope,context],laya.webgl.utils.RenderSprite3D.tmpTarget);
					context.addRenderObject(submitCMD);
					mask.render(context,-tRect.x,-tRect.y);
					submitCMD=SubmitCMD.create([scope],laya.webgl.utils.RenderSprite3D.endTmpTarget);
					context.addRenderObject(submitCMD);
					context.ctx.save();
					context.clipRect(x+tRect.x,y+tRect.y,tRect.width,tRect.height);
					next._fun.call(next,sprite,context,x,y);
					context.ctx.restore();
					submitStencil=SubmitStencil.create(6);
					preBlendMode=(context.ctx).globalCompositeOperation;
					submitStencil.blendMode="mask";
					context.addRenderObject(submitStencil);
					Matrix.TEMP.identity();
					var shaderValue=Value2D.create(0x01,0);
					(context.ctx).drawTarget(scope,x+tRect.x,y+tRect.y,tRect.width,tRect.height,Matrix.TEMP,"tmpTarget",shaderValue,Texture.INV_UV,6);
					submitCMD=SubmitCMD.create([scope],laya.webgl.utils.RenderSprite3D.recycleTarget);
					context.addRenderObject(submitCMD);
					submitStencil=SubmitStencil.create(6);
					submitStencil.blendMode=preBlendMode;
					context.addRenderObject(submitStencil);
				}
				}else {
				context.ctx.globalCompositeOperation=style.blendMode;
				next=this._next;
				next._fun.call(next,sprite,context,x,y);
			}
			context.ctx.restore();
		}

		__proto._transform=function(sprite,context,x,y){
			'use strict';
			var transform=sprite.transform,_next=this._next;
			if (transform && _next !=RenderSprite.NORENDER){
				var ctx=context.ctx;
				var style=sprite._style;
				transform.tx=x;
				transform.ty=y;
				var m2=ctx._getTransformMatrix();
				var m1=m2.clone();
				Matrix.mul(transform,m2,m2);
				m2._checkTransform();
				_next._fun.call(_next,sprite,context,0,0);
				m1.copyTo(m2);
				m1.destroy();
				transform.tx=transform.ty=0;
				}else {
				_next._fun.call(_next,sprite,context,x,y);
			}
		}

		RenderSprite3D.tmpTarget=function(scope,context){
			var b=scope.getValue("bounds");
			var tmpTarget=RenderTarget2D.create(b.width,b.height);
			tmpTarget.start();
			tmpTarget.clear(0,0,0,0);
			scope.addValue("tmpTarget",tmpTarget);
		}

		RenderSprite3D.endTmpTarget=function(scope){
			var tmpTarget=scope.getValue("tmpTarget");
			tmpTarget.end();
		}

		RenderSprite3D.recycleTarget=function(scope){
			var tmpTarget=scope.getValue("tmpTarget");
			tmpTarget.recycle();
			scope.recycle();
		}

		return RenderSprite3D;
	})(RenderSprite)


	//class laya.webgl.atlas.Atlaser extends laya.webgl.atlas.AtlasGrid
	var Atlaser=(function(_super){
		function Atlaser(gridNumX,gridNumY,width,height,atlasID){
			this._atlasCanvas=null;
			this._inAtlasTextureKey=null;
			this._inAtlasTextureBitmapValue=null;
			this._inAtlasTextureOriUVValue=null;
			this._InAtlasWebGLImagesKey=null;
			this._InAtlasWebGLImagesOffsetValue=null;
			Atlaser.__super.call(this,gridNumX,gridNumY,atlasID);
			this._inAtlasTextureKey=[];
			this._inAtlasTextureBitmapValue=[];
			this._inAtlasTextureOriUVValue=[];
			this._InAtlasWebGLImagesKey=[];
			this._InAtlasWebGLImagesOffsetValue=[];
			this._atlasCanvas=new AtlasWebGLCanvas();
			this._atlasCanvas.width=width;
			this._atlasCanvas.height=height;
			this._atlasCanvas.activeResource();
			this._atlasCanvas.lock=true;
		}

		__class(Atlaser,'laya.webgl.atlas.Atlaser',_super);
		var __proto=Atlaser.prototype;
		__proto.computeUVinAtlasTexture=function(texture,oriUV,offsetX,offsetY){
			var tex=texture;
			var _width=AtlasResourceManager.atlasTextureWidth;
			var _height=AtlasResourceManager.atlasTextureHeight;
			var u1=offsetX / _width,v1=offsetY / _height,u2=(offsetX+texture.bitmap.width)/ _width,v2=(offsetY+texture.bitmap.height)/ _height;
			var inAltasUVWidth=texture.bitmap.width / _width,inAltasUVHeight=texture.bitmap.height / _height;
			texture.uv=[u1+oriUV[0] *inAltasUVWidth,v1+oriUV[1] *inAltasUVHeight,u2-(1-oriUV[2])*inAltasUVWidth,v1+oriUV[3] *inAltasUVHeight,u2-(1-oriUV[4])*inAltasUVWidth,v2-(1-oriUV[5])*inAltasUVHeight,u1+oriUV[6] *inAltasUVWidth,v2-(1-oriUV[7])*inAltasUVHeight];
		}

		/**
		*
		*@param inAtlasRes
		*@return 是否已经存在队列中
		*/
		__proto.addToAtlasTexture=function(mergeAtlasBitmap,offsetX,offsetY){
			((mergeAtlasBitmap instanceof laya.webgl.resource.WebGLImage ))&& (this._InAtlasWebGLImagesKey.push(mergeAtlasBitmap),this._InAtlasWebGLImagesOffsetValue.push([offsetX,offsetY]));
			this._atlasCanvas.texSubImage2D(offsetX,offsetY,mergeAtlasBitmap.atlasSource);
			mergeAtlasBitmap.clearAtlasSource();
		}

		__proto.addToAtlas=function(texture,offsetX,offsetY){
			var oriUV=texture.uv.slice();
			var oriBitmap=texture.bitmap;
			this._inAtlasTextureKey.push(texture);
			this._inAtlasTextureOriUVValue.push(oriUV);
			this._inAtlasTextureBitmapValue.push(oriBitmap);
			this.computeUVinAtlasTexture(texture,oriUV,offsetX,offsetY);
			texture.bitmap=this._atlasCanvas;
		}

		__proto.clear=function(){
			for (var i=0,n=this._inAtlasTextureKey.length;i < n;i++){
				this._inAtlasTextureKey[i].bitmap=this._inAtlasTextureBitmapValue[i];
				this._inAtlasTextureKey[i].uv=this._inAtlasTextureOriUVValue[i];
				this._inAtlasTextureKey[i].bitmap.lock=false;
				this._inAtlasTextureKey[i].bitmap.releaseResource();
			}
			this._inAtlasTextureKey.length=0;
			this._inAtlasTextureBitmapValue.length=0;
			this._inAtlasTextureOriUVValue.length=0;
			this._InAtlasWebGLImagesKey.length=0;
			this._InAtlasWebGLImagesOffsetValue.length=0;
		}

		__proto.dispose=function(){
			this.clear();
			this._atlasCanvas.dispose();
		}

		__getset(0,__proto,'texture',function(){
			return this._atlasCanvas;
		});

		__getset(0,__proto,'inAtlasWebGLImagesKey',function(){
			return this._InAtlasWebGLImagesKey;
		});

		__getset(0,__proto,'InAtlasWebGLImagesOffsetValue',function(){
			return this._InAtlasWebGLImagesOffsetValue;
		});

		return Atlaser;
	})(AtlasGrid)


	//class laya.webgl.shapes.Line extends laya.webgl.shapes.BasePoly
	var Line=(function(_super){
		function Line(x,y,points,borderWidth,color){
			this._points=[];
			var tCurrX=NaN;
			var tCurrY=NaN;
			var tLastX=-1;
			var tLastY=-1;
			var tLen=points.length / 2-1;
			for (var i=0;i < tLen;i++){
				tCurrX=points[i *2];
				tCurrY=points[i *2+1];
				if (Math.abs(tLastX-tCurrX)> 0.01 || Math.abs(tLastY-tCurrY)>0.01){
					this._points.push(tCurrX,tCurrY);
				}
				tLastX=tCurrX;
				tLastY=tCurrY;
			}
			tCurrX=points[tLen *2];
			tCurrY=points[tLen *2+1];
			tLastX=this._points[0];
			tLastY=this._points[1];
			if (Math.abs(tLastX-tCurrX)> 0.01 || Math.abs(tLastY-tCurrY)>0.01){
				this._points.push(tCurrX,tCurrY);
			}
			Line.__super.call(this,x,y,0,0,0,color,borderWidth,color,0);
		}

		__class(Line,'laya.webgl.shapes.Line',_super);
		var __proto=Line.prototype;
		__proto.getData=function(ib,vb,start){
			var indices=[];
			var verts=[];
			(this.borderWidth > 0)&& this.createLine2(this._points,indices,this.borderWidth,start,verts,this._points.length / 2);
			ib.append(new Uint16Array(indices));
			vb.append(new Float32Array(verts));
		}

		return Line;
	})(BasePoly)


	//class laya.webgl.shapes.LoopLine extends laya.webgl.shapes.BasePoly
	var LoopLine=(function(_super){
		function LoopLine(x,y,points,width,color){
			this._points=[];
			var tCurrX=NaN;
			var tCurrY=NaN;
			var tLastX=-1;
			var tLastY=-1;
			var tLen=points.length / 2-1;
			for (var i=0;i < tLen;i++){
				tCurrX=points[i *2];
				tCurrY=points[i *2+1];
				if (Math.abs(tLastX-tCurrX)> 0.01 || Math.abs(tLastY-tCurrY)> 0.01){
					this._points.push(tCurrX,tCurrY);
				}
				tLastX=tCurrX;
				tLastY=tCurrY;
			}
			tCurrX=points[tLen *2];
			tCurrY=points[tLen *2+1];
			tLastX=this._points[0];
			tLastY=this._points[1];
			if (Math.abs(tLastX-tCurrX)> 0.01 || Math.abs(tLastY-tCurrY)> 0.01){
				this._points.push(tCurrX,tCurrY);
			}
			LoopLine.__super.call(this,x,y,0,0,this._points.length / 2,0,width,color);
		}

		__class(LoopLine,'laya.webgl.shapes.LoopLine',_super);
		var __proto=LoopLine.prototype;
		__proto.getData=function(ib,vb,start){
			if (this.borderWidth > 0){
				var color=this.color;
				var r=((color >> 16)& 0x0000ff)/ 255,g=((color >> 8)& 0xff)/ 255,b=(color & 0x0000ff)/ 255;
				var verts=[];
				var tLastX=-1,tLastY=-1;
				var tCurrX=0,tCurrY=0;
				var indices=[];
				var tLen=Math.floor(this._points.length / 2);
				for (var i=0;i < tLen;i++){
					tCurrX=this._points[i *2];
					tCurrY=this._points[i *2+1];
					verts.push(this.x+tCurrX,this.y+tCurrY,r,g,b);
				}
				this.createLoopLine(verts,indices,this.borderWidth,start+verts.length / 5);
				ib.append(new Uint16Array(indices));
				vb.append(new Float32Array(verts));
			}
		}

		__proto.createLoopLine=function(p,indices,lineWidth,len,outVertex,outIndex){
			var tLen=p.length / 5;
			var points=p.concat();
			var result=outVertex ? outVertex :p;
			var color=this.borderColor;
			var r=((color >> 16)& 0x0000ff)/ 255,g=((color >> 8)& 0xff)/ 255,b=(color & 0x0000ff)/ 255;
			var firstPoint=[points[0],points[1]];
			var lastPoint=[points[points.length-5],points[points.length-4]];
			var midPointX=lastPoint[0]+(firstPoint[0]-lastPoint[0])*0.5;
			var midPointY=lastPoint[1]+(firstPoint[1]-lastPoint[1])*0.5;
			points.unshift(midPointX,midPointY,0,0,0);
			points.push(midPointX,midPointY,0,0,0);
			var length=points.length / 5;
			var iStart=len,w=lineWidth / 2;
			var px,py,p1x,p1y,p2x,p2y,p3x,p3y;
			var perpx,perpy,perp2x,perp2y,perp3x,perp3y;
			var a1,b1,c1,a2,b2,c2;
			var denom,pdist,dist;
			p1x=points[0];
			p1y=points[1];
			p2x=points[5];
			p2y=points[6];
			perpx=-(p1y-p2y);
			perpy=p1x-p2x;
			dist=Math.sqrt(perpx *perpx+perpy *perpy);
			perpx=perpx / dist *w;
			perpy=perpy / dist *w;
			result.push(p1x-perpx,p1y-perpy,r,g,b,p1x+perpx,p1y+perpy,r,g,b);
			for (var i=1;i < length-1;i++){
				p1x=points[(i-1)*5];
				p1y=points[(i-1)*5+1];
				p2x=points[(i)*5];
				p2y=points[(i)*5+1];
				p3x=points[(i+1)*5];
				p3y=points[(i+1)*5+1];
				perpx=-(p1y-p2y);
				perpy=p1x-p2x;
				dist=Math.sqrt(perpx *perpx+perpy *perpy);
				perpx=perpx / dist *w;
				perpy=perpy / dist *w;
				perp2x=-(p2y-p3y);
				perp2y=p2x-p3x;
				dist=Math.sqrt(perp2x *perp2x+perp2y *perp2y);
				perp2x=perp2x / dist *w;
				perp2y=perp2y / dist *w;
				a1=(-perpy+p1y)-(-perpy+p2y);
				b1=(-perpx+p2x)-(-perpx+p1x);
				c1=(-perpx+p1x)*(-perpy+p2y)-(-perpx+p2x)*(-perpy+p1y);
				a2=(-perp2y+p3y)-(-perp2y+p2y);
				b2=(-perp2x+p2x)-(-perp2x+p3x);
				c2=(-perp2x+p3x)*(-perp2y+p2y)-(-perp2x+p2x)*(-perp2y+p3y);
				denom=a1 *b2-a2 *b1;
				if (Math.abs(denom)< 0.1){
					denom+=10.1;
					result.push(p2x-perpx,p2y-perpy,r,g,b,p2x+perpx,p2y+perpy,r,g,b);
					continue ;
				}
				px=(b1 *c2-b2 *c1)/ denom;
				py=(a2 *c1-a1 *c2)/ denom;
				pdist=(px-p2x)*(px-p2x)+(py-p2y)+(py-p2y);
				result.push(px,py,r,g,b,p2x-(px-p2x),p2y-(py-p2y),r,g,b);
			}
			if (outIndex){
				indices=outIndex;
			};
			var groupLen=this.edges+1;
			for (i=1;i < groupLen;i++){
				indices.push(iStart+(i-1)*2,iStart+(i-1)*2+1,iStart+i *2+1,iStart+i *2+1,iStart+i *2,iStart+(i-1)*2);
			}
			indices.push(iStart+(i-1)*2,iStart+(i-1)*2+1,iStart+1,iStart+1,iStart,iStart+(i-1)*2);
			return result;
		}

		return LoopLine;
	})(BasePoly)


	//class laya.webgl.shapes.Polygon extends laya.webgl.shapes.BasePoly
	var Polygon=(function(_super){
		function Polygon(x,y,points,color,borderWidth,borderColor){
			this._points=null;
			this._start=-1;
			this.mUint16Array=null;
			this.mFloat32Array=null;
			this._points=points.slice(0,points.length);
			Polygon.__super.call(this,x,y,0,0,this._points.length / 2,color,borderWidth,borderColor);
		}

		__class(Polygon,'laya.webgl.shapes.Polygon',_super);
		var __proto=Polygon.prototype;
		__proto.getData=function(ib,vb,start){
			var indices,i=0;
			var tArray=this._points;
			var tLen=0;
			if (this.mUint16Array && this.mFloat32Array){
				if (this._start !=start){
					this._start=start;
					indices=[];
					tLen=Math.floor(tArray.length / 2);
					for (i=2;i < tLen;i++){
						indices.push(start,start+i-1,start+i);
					}
					this.mUint16Array=new Uint16Array(indices);
				}
				}else {
				this._start=start;
				indices=[];
				var verts=[];
				var color=this.color;
				var r=((color >> 16)& 0x0000ff)/ 255,g=((color >> 8)& 0xff)/ 255,b=(color & 0x0000ff)/ 255;
				tLen=Math.floor(tArray.length / 2);
				for (i=0;i < tLen;i++){
					verts.push(this.x+tArray[i *2],this.y+tArray[i *2+1],r,g,b);
				}
				for (i=2;i < tLen;i++){
					indices.push(start,start+i-1,start+i);
				}
				this.mUint16Array=new Uint16Array(indices);
				this.mFloat32Array=new Float32Array(verts);
			}
			ib.append(this.mUint16Array);
			vb.append(this.mFloat32Array);
		}

		return Polygon;
	})(BasePoly)


	//class laya.webgl.submit.SubmitCanvas extends laya.webgl.submit.Submit
	var SubmitCanvas=(function(_super){
		function SubmitCanvas(){
			//this._ctx_src=null;
			this._matrix=new Matrix();
			this._matrix4=CONST3D2D.defaultMatrix4.concat();
			SubmitCanvas.__super.call(this,1);
			this.shaderValue=new Value2D(0,0);
		}

		__class(SubmitCanvas,'laya.webgl.submit.SubmitCanvas',_super);
		var __proto=SubmitCanvas.prototype;
		__proto.renderSubmit=function(){
			if (this._ctx_src._targets){
				this._ctx_src._targets.flush(this._ctx_src);
				return 1;
			};
			var preAlpha=RenderState2D.worldAlpha;
			var preMatrix4=RenderState2D.worldMatrix4;
			var preMatrix=RenderState2D.worldMatrix;
			var preFilters=RenderState2D.worldFilters;
			var preWorldShaderDefines=RenderState2D.worldShaderDefines;
			var v=this.shaderValue;
			var m=this._matrix;
			var m4=this._matrix4;
			var mout=Matrix.TEMP;
			Matrix.mul(m,preMatrix,mout);
			m4[0]=mout.a;
			m4[1]=mout.b;
			m4[4]=mout.c;
			m4[5]=mout.d;
			m4[12]=mout.tx;
			m4[13]=mout.ty;
			RenderState2D.worldMatrix=mout.clone();
			RenderState2D.worldMatrix4=m4;
			RenderState2D.worldAlpha=RenderState2D.worldAlpha *v.alpha;
			if (v.filters && v.filters.length){
				RenderState2D.worldFilters=v.filters;
				RenderState2D.worldShaderDefines=v.defines;
			}
			this._ctx_src.flush();
			RenderState2D.worldAlpha=preAlpha;
			RenderState2D.worldMatrix4=preMatrix4;
			RenderState2D.worldMatrix.destroy();
			RenderState2D.worldMatrix=preMatrix;
			RenderState2D.worldFilters=preFilters;
			RenderState2D.worldShaderDefines=preWorldShaderDefines;
			return 1;
		}

		__proto.releaseRender=function(){
			var cache=SubmitCanvas._cache;
			cache[cache._length++]=this;
		}

		__proto.getRenderType=function(){
			return 3;
		}

		SubmitCanvas.create=function(ctx_src,alpha,filters){
			var o=(!SubmitCanvas._cache._length)? (new SubmitCanvas()):SubmitCanvas._cache[--SubmitCanvas._cache._length];
			o._ctx_src=ctx_src;
			var v=o.shaderValue;
			v.alpha=alpha;
			v.defines.setValue(0);
			filters && filters.length && v.setFilters(filters);
			return o;
		}

		SubmitCanvas._cache=(SubmitCanvas._cache=[],SubmitCanvas._cache._length=0,SubmitCanvas._cache);
		return SubmitCanvas;
	})(Submit)


	//class laya.webgl.submit.SubmitTexture extends laya.webgl.submit.Submit
	var SubmitTexture=(function(_super){
		function SubmitTexture(renderType){
			this._preIsSameTextureShader=false;
			this._isSameTexture=true;
			this._texs=new Array;
			this._texsID=new Array;
			this._vbPos=new Array;
			(renderType===void 0)&& (renderType=1);
			SubmitTexture.__super.call(this,renderType);
		}

		__class(SubmitTexture,'laya.webgl.submit.SubmitTexture',_super);
		var __proto=SubmitTexture.prototype;
		__proto.releaseRender=function(){
			var cache=SubmitTexture._cache;
			cache[cache._length++]=this;
			this.shaderValue.release();
			this._preIsSameTextureShader=false;
			this._vb=null;
			this._texs.length=0;
			this._isSameTexture=true;
		}

		__proto.addTexture=function(tex,vbpos){
			this._texsID[this._texs.length]=tex._uvID;
			this._texs.push(tex);
			this._vbPos.push(vbpos);
		}

		//检查材质是否修改，修改UV，设置是否是同一材质
		__proto.checkTexture=function(){
			if (this._texs.length < 1){
				this._isSameTexture=true;
				return;
			};
			var _tex=this.shaderValue.textureHost;
			var webGLImg=_tex.bitmap;
			if (webGLImg===null)return;
			var vbdata=this._vb.getFloat32Array();
			for (var i=0,s=this._texs.length;i < s;i++){
				var tex=this._texs[i];
				tex.active();
				var newUV=tex.uv;
				if (this._texsID[i]!==tex._uvID){
					this._texsID[i]=tex._uvID;
					var vbPos=this._vbPos[i];
					vbdata[vbPos+2]=newUV[0];
					vbdata[vbPos+3]=newUV[1];
					vbdata[vbPos+6]=newUV[2];
					vbdata[vbPos+7]=newUV[3];
					vbdata[vbPos+10]=newUV[4];
					vbdata[vbPos+11]=newUV[5];
					vbdata[vbPos+14]=newUV[6];
					vbdata[vbPos+15]=newUV[7];
					this._vb.setNeedUpload();
				}
				if (tex.bitmap!==webGLImg){
					this._isSameTexture=false;
				}
			}
		}

		__proto.renderSubmit=function(){
			if (this._numEle===0)return 1;
			var _tex=this.shaderValue.textureHost;
			if (_tex){
				var source=_tex.source;
				if (!_tex.bitmap || !source){
					SubmitTexture._shaderSet=false;
					return 1;
				}
				this.shaderValue.texture=source;
			}
			this._vb.bind_upload(this._ib);
			var gl=WebGL.mainContext;
			if (BlendMode.activeBlendFunction!==this._blendFn){
				gl.enable(0x0BE2);
				this._blendFn(gl);
				BlendMode.activeBlendFunction=this._blendFn;
			}
			Stat.drawCall++;
			Stat.trianglesFaces+=this._numEle / 3;
			if (this._preIsSameTextureShader && Shader.activeShader && SubmitTexture._shaderSet)
				Shader.activeShader.uploadTexture2D(this.shaderValue.texture);
			else this.shaderValue.upload();
			SubmitTexture._shaderSet=true;
			if (this._texs.length > 1 && !this._isSameTexture){
				var webGLImg=_tex.bitmap;
				var index=0;
				var shader=Shader.activeShader;
				for (var i=0,s=this._texs.length;i < s;i++){
					var tex2=this._texs[i];
					if (tex2.bitmap!==webGLImg || (i+1)===s){
						shader.uploadTexture2D(tex2.source);
						gl.drawElements(0x0004,(i-index+1)*6,0x1403,this._startIdx+index *6 *CONST3D2D.BYTES_PIDX);
						webGLImg=tex2.bitmap;
						index=i;
					}
				}
				}else {
				gl.drawElements(0x0004,this._numEle,0x1403,this._startIdx);
			}
			return 1;
		}

		SubmitTexture.create=function(context,ib,vb,pos,sv){
			var o=SubmitTexture._cache._length ? SubmitTexture._cache[--SubmitTexture._cache._length] :new SubmitTexture();
			if (vb==null){
				vb=o._selfVb || (o._selfVb=VertexBuffer2D.create(-1));
				vb.clear();
				pos=0;
			}
			o._ib=ib;
			o._vb=vb;
			o._startIdx=pos *CONST3D2D.BYTES_PIDX;
			o._numEle=0;
			var blendType=context._nBlendType;
			o._blendFn=context._targets ? BlendMode.targetFns[blendType] :BlendMode.fns[blendType];
			o.shaderValue=sv;
			o.shaderValue.setValue(context._shader2D);
			var filters=context._shader2D.filters;
			filters && o.shaderValue.setFilters(filters);
			return o;
		}

		SubmitTexture._cache=(SubmitTexture._cache=[],SubmitTexture._cache._length=0,SubmitTexture._cache);
		SubmitTexture._shaderSet=true;
		return SubmitTexture;
	})(Submit)


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
			this._zOrder=0;
			this._graphics=null;
			this._renderType=0;
			this.autoSize=false;
			this.hitTestPrior=false;
			this._optimizeScrollRect=false;
			this.viewport=null;
			Sprite.__super.call(this);
			this._style=Style.EMPTY;
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
		}

		/**根据zOrder进行重新排序。*/
		__proto.updateZOrder=function(){
			Utils.updateOrder(this._childs)&& this.repaint();
		}

		/**在设置cacheAs或staticCache=true的情况下，调用此方法会重新刷新缓存。*/
		__proto.reCache=function(){
			if (this._$P.cacheCanvas)this._$P.cacheCanvas.reCache=true;
		}

		/**
		*设置bounds大小，如果有设置，则不再通过getBounds计算
		*@param bound bounds矩形区域
		*/
		__proto.setBounds=function(bound){
			this._set$P("uBounds",bound);
		}

		/**
		*获取本对象在父容器坐标系的矩形显示区域。
		*<p><b>注意：</b>计算量较大，尽量少用。</p>
		*@return 矩形区域。
		*/
		__proto.getBounds=function(){
			if (!this._$P.mBounds)this._set$P("mBounds",new Rectangle());
			return Rectangle._getWrapRec(this._boundPointsToParent(),this._$P.mBounds);
		}

		/**
		*获取本对象在自己坐标系的矩形显示区域。
		*<p><b>注意：</b>计算量较大，尽量少用。</p>
		*@return 矩形区域。
		*/
		__proto.getSelfBounds=function(){
			if (!this._$P.mBounds)this._set$P("mBounds",new Rectangle());
			return Rectangle._getWrapRec(this._getBoundPointsM(false),this._$P.mBounds);
		}

		/**
		*@private
		*获取本对象在父容器坐标系的显示区域多边形顶点列表。
		*当显示对象链中有旋转时，返回多边形顶点列表，无旋转时返回矩形的四个顶点。
		*@param ifRotate 之前的对象链中是否有旋转。
		*@return 顶点列表。结构：[x1,y1,x2,y2,x3,y3,...]。
		*/
		__proto._boundPointsToParent=function(ifRotate){
			(ifRotate===void 0)&& (ifRotate=false);
			var pX=0,pY=0;
			if (this._style){
				pX=this._style._tf.translateX;
				pY=this._style._tf.translateY;
				ifRotate=ifRotate || (this._style._tf.rotate!==0);
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
		*返回此实例中的绘图对象（ <code>Graphics</code> ）的显示区域。
		*@return 一个 Rectangle 对象，表示获取到的显示区域。
		*/
		__proto.getGraphicBounds=function(){
			if (!this._graphics)return Rectangle.TEMP.setTo(0,0,0,0);
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
			if (!this._$P.temBM)this._set$P("temBM",[]);
			if (this.scrollRect){
				var rst=Utils.clearArray(this._$P.temBM);
				var rec=Rectangle.TEMP;
				rec.copyFrom(this.scrollRect);
				Utils.concatArray(rst,rec._getBoundPoints());
				return rst;
			};
			var pList=this._graphics ? this._graphics.getBoundPoints():Utils.clearArray(this._$P.temBM);
			var child;
			var cList;
			var __childs;
			__childs=this._childs;
			for (var i=0,n=__childs.length;i < n;i++){
				child=__childs [i];
				if ((child instanceof laya.display.Sprite )&& child.visible==true){
					cList=child._boundPointsToParent(ifRotate);
					if (cList)
						pList=pList ? Utils.concatArray(pList,cList):cList;
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

		/**
		*@private
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
			var tf=style._tf;
			var sx=tf.scaleX,sy=tf.scaleY;
			var m;
			if (tf.rotate || sx!==1 || sy!==1 || tf.skewX || tf.skewY){
				m=this._transform || (this._transform=Matrix.create());
				m.bTransform=true;
				if (tf.rotate){
					var angle=tf.rotate *0.0174532922222222;
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
					if (tf.skewX || tf.skewY){
						return m.skew(tf.skewX *0.0174532922222222,tf.skewY *0.0174532922222222);
					}
					return m;
				}
				}else {
				this._transform && this._transform.destroy();
				this._transform=null;
				this._renderType &=~0x04;
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
			Stat.spriteCount++;
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
			return RunDriver.drawToCanvas(this,this._renderType,canvasWidth,canvasHeight,offsetX,offsetY);
		}

		/**
		*自定义更新、呈现显示对象。
		*<p><b>注意</b>不要在此函数内增加或删除树节点，否则会树节点遍历照成影响。</p>
		*@param context 渲染的上下文引用。
		*@param x X轴坐标。
		*@param y Y轴坐标。
		*/
		__proto.customRender=function(context,x,y){
			this._renderType |=0x200;
		}

		/**
		*@private
		*应用滤镜。
		*/
		__proto._applyFilters=function(){
			if (Render.isWebGL)return;
			var _filters;
			_filters=this._$P.filters;
			if (!_filters || _filters.length < 1)return;
			for (var i=0,n=_filters.length;i < n;i++){
				_filters[i].action.apply(this._$P.cacheCanvas);
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
			for (i=0,len=this._childs.length;i < len;i++){
				if (this._childs[i]._isHaveGlowFilter()){
					return true;
				}
			}
			return false;
		}

		/**
		*本地坐标转全局坐标。
		*@param point 本地坐标点。
		*@param createNewPoint 用于存储转换后的坐标的点。
		*@return 转换后的坐标的点。
		*/
		__proto.localToGlobal=function(point,createNewPoint){
			(createNewPoint===void 0)&& (createNewPoint=false);
			if (!this._displayedInStage || !point)return point;
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
			if (!this._displayedInStage || !point)return point;
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
				if (this._displayedInStage)this._$2__onDisplay();
				else laya.events.EventDispatcher.prototype.once.call(this,"display",this,this._$2__onDisplay);
			}
			return laya.events.EventDispatcher.prototype.on.call(this,type,caller,listener,args);
		}

		/**
		*使用 EventDispatcher 对象注册指定类型的事件侦听器对象，以使侦听器能够接收事件通知，此侦听事件响应一次后自动移除。
		*如果侦听鼠标事件，则会自动设置自己和父亲节点的属性 mouseEnabled 的值为 true(如果父节点mouseEnabled=false，则停止设置父节点mouseEnabled属性)。
		*@param type 事件的类型。
		*@param caller 事件侦听函数的执行域。
		*@param listener 事件侦听函数。
		*@param args 事件侦听函数的回调参数。
		*@return 此 EventDispatcher 对象。
		*/
		__proto.once=function(type,caller,listener,args){
			if (this._mouseEnableState!==1 && this.isMouseEvent(type)){
				if (this._displayedInStage)this._$2__onDisplay();
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
		*加载并显示一个图片。功能等同于Graphics.loadImage
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
				if (!_$this.destroyed){
					_$this.size(x+(width || tex.width),y+(height || tex.height));
					_$this.repaint();
					complete && complete.runWith(tex);
				}
			}
			this.graphics.loadImage(url,x,y,width,height,loaded);
			return this;
		}

		/**cacheAs后，设置自己和父对象缓存失效。*/
		__proto.repaint=function(){
			this.model&&this.model.repaint&&this.model.repaint();
			(this._repaint===0)&& (this._repaint=1,this.parentRepaint());
			if (this._$P && this._$P.maskParent){
				this._$P.maskParent.repaint();
			}
		}

		/**
		*@private
		*获取是否重新缓存。
		*@return 如果重新缓存值为 true，否则值为 false。
		*/
		__proto._needRepaint=function(){
			return (this._repaint!==0)&& this._$P.cacheCanvas && this._$P.cacheCanvas.reCache;
		}

		/**@inheritDoc */
		__proto._childChanged=function(child){
			if (this._childs.length)this._renderType |=0x800;
			else this._renderType &=~0x800;
			if (child && (child).zOrder)Laya.timer.callLater(this,this.updateZOrder);
			this.repaint();
		}

		/**cacheAs时，设置所有父对象缓存失效。 */
		__proto.parentRepaint=function(){
			var p=this._parent;
			p && p._repaint===0 && (p._repaint=1,p.parentRepaint());
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
			this._$P.dragging || (this._set$P("dragging",new Dragging()));
			this._$P.dragging.start(this,area,hasInertia,elasticDistance,elasticBackTime,data,disableMouseEvent);
		}

		/**停止拖动此对象。*/
		__proto.stopDrag=function(){
			this._$P.dragging && this._$P.dragging.stop();
		}

		/**@private */
		__proto._setDisplay=function(value){
			if (!value && this._$P.cacheCanvas && this._$P.cacheCanvas.ctx){
				Pool.recover("RenderContext",this._$P.cacheCanvas.ctx);
				this._$P.cacheCanvas.ctx=null;
			}
			if (!value){
				var fc=this._$P._filterCache;
				if (fc){
					fc.destroy();
					fc.recycle();
					this._set$P('_filterCache',null);
				}
				this._$P._isHaveGlowFilter && this._set$P('_isHaveGlowFilter',false);
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
			if (words){
				for (var i=0,n=words.length;i < n;i++){
					out.push(words[i]);
				}
			}
			this._childs.forEach(function(o,index,array){
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
		*@private
		*设置指定属性名的属性值。
		*@param name 属性名。
		*@param value 属性值。
		*/
		__proto._setAttributes=function(name,value){
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
		__proto._layoutLater=function(){
			this.parent && (this.parent)._layoutLater();
		}

		/**
		*<p>指定是否对使用了 scrollRect 的显示对象进行优化处理。</p>
		*<p>默认为false(不优化)。</p>
		*<p>当值为ture时：将对此对象使用了scrollRect 设定的显示区域以外的显示内容不进行渲染，以提高性能。</p>
		*/
		__getset(0,__proto,'optimizeScrollRect',function(){
			return this._optimizeScrollRect;
			},function(b){
			if (this._optimizeScrollRect !=b){
				this._optimizeScrollRect=b;
				this.model && this.model.optimizeScrollRect(b);
			}
		});

		/**X轴缩放值，默认值为1。*/
		__getset(0,__proto,'scaleX',function(){
			return this._style._tf.scaleX;
			},function(value){
			var style=this.getStyle();
			if (style._tf.scaleX!==value){
				style.setScaleX(value);
				this._tfChanged=true;
				this.model && this.model.scale(value,style._tf.scaleY);
				this._renderType |=0x04;
				var p=this._parent;
				p && p._repaint===0 && (p._repaint=1,p.parentRepaint());
			}
		});

		/**
		*指定显示对象是否缓存为静态图像。功能同cacheAs的normal模式。
		*/
		__getset(0,__proto,'cacheAsBitmap',function(){
			return this.cacheAs!=="none";
			},function(value){
			this.cacheAs=value ? (this._$P["hasFilter"] ? "none" :"normal"):"none";
		});

		/**
		*开启自定义渲染，只有开启自定义渲染，才能使用customRender函数渲染
		*/
		__getset(0,__proto,'customRenderEnable',null,function(b){
			if (b){
				this._renderType |=0x200;
				if (Render.isConchNode){
					laya.display.Sprite.CustomList.push(this);
					var canvas=new HTMLCanvas("2d");
					canvas._setContext(new CanvasRenderingContext2D());
					this.customContext=new RenderContext(0,0,canvas);
					canvas.context.setCanvasType && canvas.context.setCanvasType(2);
					this.model.custom(canvas.context);
				}
			}
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
			var cacheCanvas=this._$P.cacheCanvas;
			if (value===(cacheCanvas ? cacheCanvas.type :"none"))return;
			if (value!=="none"){
				cacheCanvas || (cacheCanvas=this._set$P("cacheCanvas",Pool.getItemByClass("cacheCanvas",Object)));
				cacheCanvas.type=value;
				cacheCanvas.reCache=true;
				this._renderType |=0x08;
				if (value=="bitmap")this.model && this.model.cacheAs(1);
				this._set$P("cacheForFilters",false);
				}else {
				if (this._$P["hasFilter"]){
					this._set$P("cacheForFilters",true);
					}else {
					if (cacheCanvas)Pool.recover("cacheCanvas",cacheCanvas);
					this._$P.cacheCanvas=null;
					this._renderType &=~0x08;
					this.model && this.model.cacheAs(0);
				}
			}
			this.repaint();
		});

		/**设置cacheAs为非空时此值才有效，staticCache=true时，子对象变化时不会自动更新缓存，只能通过调用reCache方法手动刷新。*/
		__getset(0,__proto,'staticCache',function(){
			return this._$P.staticCache;
			},function(value){
			this._set$P("staticCache",value);
			if (!value && this._$P.cacheCanvas){
				this._$P.cacheCanvas.reCache=true;
			}
		});

		/**表示显示对象相对于父容器的水平方向坐标值。*/
		__getset(0,__proto,'x',function(){
			return this._x;
			},function(value){
			if (this.destroyed)return;
			var p=this._parent;
			this._x!==value && (this._x=value,this.model && this.model.pos(value,this._y),p && p._repaint===0 && (p._repaint=1,p.parentRepaint()),this._$P.maskParent && this._$P.maskParent._repaint===0 && (this._$P.maskParent._repaint=1,this._$P.maskParent.parentRepaint()));
		});

		/**表示显示对象相对于父容器的垂直方向坐标值。*/
		__getset(0,__proto,'y',function(){
			return this._y;
			},function(value){
			if (this.destroyed)return;
			var p=this._parent;
			this._y!==value && (this._y=value,this.model && this.model.pos(this._x,value),p && p._repaint===0 && (p._repaint=1,p.parentRepaint()),this._$P.maskParent && this._$P.maskParent._repaint===0 && (this._$P.maskParent._repaint=1,this._$P.maskParent.parentRepaint()));
		});

		/**水平倾斜角度，默认值为0。*/
		__getset(0,__proto,'skewX',function(){
			return this._style._tf.skewX;
			},function(value){
			var style=this.getStyle();
			if (style._tf.skewX!==value){
				style.setSkewX(value);
				this._tfChanged=true;
				this._renderType |=0x04;
				var p=this._parent;
				p && p._repaint===0 && (p._repaint=1,p.parentRepaint());
			}
		});

		/**
		*表示显示对象的宽度，以像素为单位。
		*/
		__getset(0,__proto,'width',function(){
			if (!this.autoSize)return this._width;
			return this.getSelfBounds().width;
			},function(value){
			this._width!==value && (this._width=value,this.model && this.model.size(value,this._height),this.repaint());
		});

		/**
		*表示显示对象的高度，以像素为单位。
		*/
		__getset(0,__proto,'height',function(){
			if (!this.autoSize)return this._height;
			return this.getSelfBounds().height;
			},function(value){
			this._height!==value && (this._height=value,this.model && this.model.size(this._width,value),this.repaint());
		});

		/**手动设置的可点击区域，或者一个HitArea区域。*/
		__getset(0,__proto,'hitArea',function(){
			return this._$P.hitArea;
			},function(value){
			this._set$P("hitArea",value);
		});

		/**旋转角度，默认值为0。*/
		__getset(0,__proto,'rotation',function(){
			return this._style._tf.rotate;
			},function(value){
			var style=this.getStyle();
			if (style._tf.rotate!==value){
				style.setRotate(value);
				this._tfChanged=true;
				this.model && this.model.rotate(value);
				this._renderType |=0x04;
				var p=this._parent;
				p && p._repaint===0 && (p._repaint=1,p.parentRepaint());
			}
		});

		/**Y轴缩放值，默认值为1。*/
		__getset(0,__proto,'scaleY',function(){
			return this._style._tf.scaleY;
			},function(value){
			var style=this.getStyle();
			if (style._tf.scaleY!==value){
				style.setScaleY(value);
				this._tfChanged=true;
				this.model && this.model.scale(style._tf.scaleX,value);
				this._renderType |=0x04;
				var p=this._parent;
				p && p._repaint===0 && (p._repaint=1,p.parentRepaint());
			}
		});

		/**指定要使用的混合模式。*/
		__getset(0,__proto,'blendMode',function(){
			return this._style.blendMode;
			},function(value){
			this.getStyle().blendMode=value;
			this.model && this.model.blendMode(value);
			if (value && value !="source-over")this._renderType |=0x20;
			else this._renderType &=~0x20;
			this.parentRepaint();
		});

		/**垂直倾斜角度，默认值为0。*/
		__getset(0,__proto,'skewY',function(){
			return this._style._tf.skewY;
			},function(value){
			var style=this.getStyle();
			if (style._tf.skewY!==value){
				style.setSkewY(value);
				this._tfChanged=true;
				this.model && this.model.skew(style._tf.skewX,value);
				this._renderType |=0x04;
				var p=this._parent;
				p && p._repaint===0 && (p._repaint=1,p.parentRepaint());
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
				this.model && this.model.transform(value.a,value.b,value.c,value.d,this._x,this._y);
			}
			if (value)this._renderType |=0x04;
			else {
				this._renderType &=~0x04;
				this.model && this.model.removeType(0x04);
			}
			this.parentRepaint();
		});

		/**X轴 轴心点的位置，单位为像素，默认为0，轴心点会影响对象位置，缩放，旋转。*/
		__getset(0,__proto,'pivotX',function(){
			return this._style._tf.translateX;
			},function(value){
			this.getStyle().setTranslateX(value);
			this.model && this.model.pivot(value,this._style._tf.translateY);
			this.repaint();
		});

		/**Y轴 轴心点的位置，单位为像素，默认为0，轴心点会影响对象位置，缩放，旋转。*/
		__getset(0,__proto,'pivotY',function(){
			return this._style._tf.translateY;
			},function(value){
			this.getStyle().setTranslateY(value);
			this.model && this.model.pivot(this._style._tf.translateX,value);
			this.repaint();
		});

		/**透明度，值为0-1，默认值为1，表示不透明。*/
		__getset(0,__proto,'alpha',function(){
			return this._style.alpha;
			},function(value){
			if (this._style && this._style.alpha!==value){
				value=value < 0 ? 0 :(value > 1 ? 1 :value);
				this.getStyle().alpha=value;
				this.model && this.model.alpha(value);
				if (value!==1)this._renderType |=0x02;
				else this._renderType &=~0x02;
				this.parentRepaint();
			}
		});

		/**表示是否可见，默认为true。*/
		__getset(0,__proto,'visible',function(){
			return this._style.visible;
			},function(value){
			if (this._style && this._style.visible!==value){
				this.getStyle().visible=value;
				this.model && this.model.visible(value);
				this.parentRepaint();
			}
		});

		/**
		*获得全局Y轴缩放值
		*/
		__getset(0,__proto,'globalScaleY',function(){
			var scale=1;
			var ele=this;
			while (ele){
				if (ele===Laya.stage)break ;
				scale *=ele.scaleX;
				ele=ele.parent;
			}
			return scale;
		});

		/**绘图对象。*/
		__getset(0,__proto,'graphics',function(){
			return this._graphics || (this.graphics=RunDriver.createGraphics());
			},function(value){
			if (this._graphics)this._graphics._sp=null;
			this._graphics=value;
			if (value){
				this._renderType &=~0x01;
				this._renderType |=0x100;
				value._sp=this;
				this.model && this.model.graphics(this._graphics);
				}else {
				this._renderType &=~0x100;
				this._renderType &=~0x01;
				this.model && this.model.removeType(0x100);
			}
			this.repaint();
		});

		/**显示对象的滚动矩形范围。*/
		__getset(0,__proto,'scrollRect',function(){
			return this._style.scrollRect;
			},function(value){
			this.getStyle().scrollRect=value;
			this.repaint();
			if (value){
				this._renderType |=0x40;
				this.model && this.model.scrollRect(value.x,value.y,value.width,value.height);
				}else {
				this._renderType &=~0x40;
				this.model && this.model.removeType(0x40);
			}
		});

		/**滤镜集合。*/
		__getset(0,__proto,'filters',function(){
			return this._$P.filters;
			},function(value){
			value && value.length===0 && (value=null);
			if (this._$P.filters==value)return;
			this._set$P("filters",value ? value.slice():null);
			if (Render.isConchApp){
				this.model && this.model.removeType(0x10);
				if (this._$P.filters && this._$P.filters.length==1){
					this._$P.filters[0].callNative(this);
				}
			}
			if (Render.isWebGL){
				if (value && value.length){
					this._renderType |=0x10;
					}else {
					this._renderType &=~0x10;
				}
			}
			if (value && value.length > 0){
				if (!(Render.isWebGL && value.length==1 && (((value[0])instanceof laya.filters.ColorFilter )))){
					if (this.cacheAs !="bitmap"){
						if (!Render.isConchNode)this.cacheAs="bitmap";
						this._set$P("cacheForFilters",true);
					}
					this._set$P("hasFilter",true);
				}
				}else {
				this._set$P("hasFilter",false);
				if (this._$P["cacheForFilters"] && this.cacheAs=="bitmap"){
					this.cacheAs="none";
				}
			}
			this.repaint();
		});

		/**遮罩，可以设置一个对象或者图片，根据对象形状进行遮罩显示。
		*【注意】遮罩对象坐标系是相对遮罩对象本身的，这个和flash机制不同*/
		__getset(0,__proto,'mask',function(){
			return this._$P._mask;
			},function(value){
			if (value && this.mask && this.mask._$P.maskParent)return;
			if (value){
				this.cacheAs="bitmap";
				this._set$P("_mask",value);
				value._set$P("maskParent",this);
				}else {
				this.cacheAs="none";
				this.mask && this.mask._set$P("maskParent",null);
				this._set$P("_mask",value);
			}
			this.model && this.model.mask(value ? value.model :null);
			this._renderType |=0x20;
			this.parentRepaint();
		});

		/**对舞台 <code>stage</code> 的引用。*/
		__getset(0,__proto,'stage',function(){
			return Laya.stage;
		});

		/**
		*是否接受鼠标事件。
		*默认为false，如果监听鼠标事件，则会自动设置本对象及父节点的属性 mouseEnable 的值都为 true（如果父节点手动设置为false，则不会更改）。
		**/
		__getset(0,__proto,'mouseEnabled',function(){
			return this._mouseEnableState > 1;
			},function(value){
			this._mouseEnableState=value ? 2 :1;
		});

		/**
		*获得全局X轴缩放值
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
		*表示鼠标在此对象上的 X 轴坐标信息。
		*/
		__getset(0,__proto,'mouseX',function(){
			return this.getMousePoint().x;
		});

		/**
		*表示鼠标在此对象上的 Y 轴坐标信息。
		*/
		__getset(0,__proto,'mouseY',function(){
			return this.getMousePoint().y;
		});

		/**z排序，更改此值，按照值的大小进行显示层级排序。*/
		__getset(0,__proto,'zOrder',function(){
			return this._zOrder;
			},function(value){
			if (this._zOrder !=value){
				this._zOrder=value;
				this._parent && Laya.timer.callLater(this._parent,this.updateZOrder);
			}
		});

		Sprite.fromImage=function(url){
			return new Sprite().loadImage(url);
		}

		Sprite.CustomList=[];
		return Sprite;
	})(Node)


	/**
	*<code>Sprite3D</code> 类用于实现3D精灵。
	*/
	//class laya.d3.core.Sprite3D extends laya.display.Node
	var Sprite3D=(function(_super){
		function Sprite3D(name){
			this._isInStage=false;
			this._id=0;
			this._enable=false;
			this._layerMask=0;
			this._componentsMap=[];
			this.transform=null;
			this.isStatic=false;
			Sprite3D.__super.call(this);
			this._components=[];
			(name)? (this.name=name):(this.name="Sprite3D-"+Sprite3D._nameNumberCounter++);
			this._enable=true;
			this._id=Sprite3D._uniqueIDCounter;
			Sprite3D._uniqueIDCounter++;
			this.layer=Layer.currentCreationLayer;
			this.transform=new Transform3D(this);
			this.on("added",this,this._onAdded);
			this.on("removed",this,this._onRemoved);
		}

		__class(Sprite3D,'laya.d3.core.Sprite3D',_super);
		var __proto=Sprite3D.prototype;
		Laya.imps(__proto,{"laya.d3.core.render.IUpdate":true,"laya.resource.IDispose":true})
		/**
		*@private
		*/
		__proto._onAdded=function(){
			this.transform.parent=(this._parent).transform;
			var isInStage=Laya.stage.contains(this);
			(isInStage)&& (this._addSelfAndChildrenRenderObjects());
			(isInStage)&& (this._changeSelfAndChildrenInStage(true));
		}

		/**
		*@private
		*/
		__proto._onRemoved=function(){
			this.transform.parent=null;
			var isInStage=Laya.stage.contains(this);
			(isInStage)&& (this._clearSelfAndChildrenRenderObjects());
			(isInStage)&& (this._changeSelfAndChildrenInStage(false));
		}

		/**
		*@private
		*/
		__proto._changeSelfAndChildrenInStage=function(isInStage){
			this._isInStage=isInStage;
			this.event("instagechanged",isInStage);
			var children=this._childs;
			for (var i=0,n=children.length;i < n;i++)
			(this._childs [i])._changeSelfAndChildrenInStage(isInStage);
		}

		/**
		*清理自身渲染物体，请重载此函数。
		*/
		__proto._clearSelfRenderObjects=function(){}
		/**
		*添加自身渲染物体，请重载此函数。
		*/
		__proto._addSelfRenderObjects=function(){}
		/**
		*清理自身和子节点渲染物体,重写此函数。
		*/
		__proto._clearSelfAndChildrenRenderObjects=function(){
			this._clearSelfRenderObjects();
			for (var i=0,n=this._childs.length;i < n;i++)
			(this._childs [i])._clearSelfAndChildrenRenderObjects();
		}

		/**
		*添加自身和子节点渲染物体,重写此函数。
		*/
		__proto._addSelfAndChildrenRenderObjects=function(){
			this._addSelfRenderObjects();
			for (var i=0,n=this._childs.length;i < n;i++)
			(this._childs [i])._addSelfAndChildrenRenderObjects();
		}

		/**
		*更新组件update函数。
		*@param state 渲染相关状态。
		*/
		__proto._updateComponents=function(state){
			for (var i=0,n=this._components.length;i < n;i++){
				var component=this._components[i];
				(!component.started)&& (component._start(state),component.started=true);
				(component.isActive)&& (component._update(state));
			}
		}

		/**
		*更新组件lateUpdate函数。
		*@param state 渲染相关状态。
		*/
		__proto._lateUpdateComponents=function(state){
			for (var i=0;i < this._components.length;i++){
				var component=this._components[i];
				(!component.started)&& (component._start(state),component.started=true);
				(component.isActive)&& (component._lateUpdate(state));
			}
		}

		/**
		*更新子节点。
		*@param state 渲染相关状态。
		*/
		__proto._updateChilds=function(state){
			var n=this._childs.length;
			if (n===0)return;
			for (var i=0;i < n;++i){
				var child=this._childs[i];
				child._update((state));
			}
		}

		/**
		*排序函数。
		*@param state 渲染相关状态。
		*/
		__proto._getSortID=function(renderElement,material){
			return+renderElement._getVertexBuffer().vertexDeclaration.id+material.id *1000;
		}

		/**
		*更新
		*@param state 渲染相关状态
		*/
		__proto._update=function(state){
			state.owner=this;
			if (this._enable){
				this._updateComponents(state);
				this._lateUpdateComponents(state);
			}
			Stat.spriteCount++;
			this._childs.length && this._updateChilds(state);
		}

		__proto.addChildAt=function(node,index){
			if (!((node instanceof laya.d3.core.Sprite3D )))
				throw new Error("Sprite3D:Node type must Sprite3D.");
			return _super.prototype.addChildAt.call(this,node,index);
		}

		__proto.addChild=function(node){
			if (!((node instanceof laya.d3.core.Sprite3D )))
				throw new Error("Sprite3D:Node type must Sprite3D.");
			return _super.prototype.addChild.call(this,node);
		}

		/**
		*添加指定类型组件。
		*@param type 组件类型。
		*@return 组件。
		*/
		__proto.addComponent=function(type){
			if (!(this._componentsMap[type]===undefined))
				throw new Error("无法创建"+type+"组件"+"，"+type+"组件已存在！");
			var component=ClassUtils.getInstance(type);
			component._initialize(this);
			this._componentsMap[type]=this._components.length;
			this._components.push(component);
			this.event("componentadded",component);
			return component;
		}

		/**
		*获得指定类型组件。
		*@param type 组件类型。
		*@return 组件。
		*/
		__proto.getComponentByType=function(type){
			if (this._componentsMap[type]===undefined)
				return null;
			return this._components[this._componentsMap[type]];
		}

		/**
		*获得指定类型组件。
		*@param type 组件类型。
		*@return 组件。
		*/
		__proto.getComponentByIndex=function(index){
			return this._components[index];
		}

		/**
		*移除指定类型组件。
		*@param type 组件类型。
		*/
		__proto.removeComponent=function(type){
			if (this._componentsMap[type]===undefined)
				return;
			var component=this._components[this._componentsMap[type]];
			this._components.splice(this._componentsMap[type],1);
			delete this._componentsMap[type];
			this.event("componentremoved",component);
		}

		/**
		*移除全部组件。
		*/
		__proto.removeAllComponent=function(){
			for (var component in this._componentsMap)
			this.removeComponent(component);
		}

		/**
		*加载场景文件。
		*@param url 地址。
		*/
		__proto.loadHierarchy=function(url){
			var _$this=this;
			if (url===null)return;
			var loader=new Loader();
			url=URL.formatURL(url);
			var _this=this;
			var onComp=function (data){
				var preBasePath=URL.basePath;
				URL.basePath=URL.getPath(URL.formatURL(url));
				var sprite=ClassUtils.createByJson(data,null,_this,Handler.create(null,Utils3D._parseHierarchyProp,null,false),Handler.create(null,Utils3D._parseHierarchyNode,null,false));
				_$this.addChild(sprite);
				URL.basePath=preBasePath;
				_$this.event("hierarchyloaded",[_this,sprite]);
			}
			loader.once("complete",null,onComp);
			loader.load(url,"text");
		}

		__proto.dispose=function(){
			this.off("added",this,this._onAdded);
			this.off("removed",this,this._onRemoved);
			for (var i=0,n=this._components.length;i < n;i++)
			this._components[i]._uninitialize();
		}

		/**
		*获取唯一标识ID。
		*@return 唯一标识ID。
		*/
		__getset(0,__proto,'id',function(){
			return this._id;
		});

		/**
		*获取是否在场景树。
		*@return 是否在场景树。
		*/
		__getset(0,__proto,'isInStage',function(){
			return this._isInStage;
		});

		/**
		*设置是否启用。
		*@param value 是否启动。
		*/
		/**
		*获取是否启用。
		*@return 是否激活。
		*/
		__getset(0,__proto,'enable',function(){
			return this._enable;
			},function(value){
			if (this._enable!==value){
				this._enable=value;
				this.event("enabledchanged",this._enable);
			}
		});

		/**
		*获取是否激活。
		*@return 是否激活。
		*/
		__getset(0,__proto,'active',function(){
			return Layer.isActive(this._layerMask)&& this._enable;
		});

		/**
		*获取是否显示。
		*@return 是否显示。
		*/
		__getset(0,__proto,'visible',function(){
			return Layer.isVisible(this._layerMask)&& this._enable;
		});

		/**
		*设置蒙版。
		*@param value 蒙版。
		*/
		/**
		*获取蒙版。
		*@return 蒙版。
		*/
		__getset(0,__proto,'layer',function(){
			return Layer.getLayerByMask(this._layerMask);
			},function(value){
			this._layerMask=value.mask;
			this.event("layerchanged",value);
		});

		/**
		*获得组件的数量。
		*@return 组件数量。
		*/
		__getset(0,__proto,'componentsCount',function(){
			return this._components.length;
		});

		/**
		*获得所属场景。
		*@return 场景。
		*/
		__getset(0,__proto,'scene',function(){
			return this.parent ? (this.parent).scene :null;
		});

		Sprite3D._uniqueIDCounter=1;
		Sprite3D._nameNumberCounter=0;
		return Sprite3D;
	})(Node)


	/**
	*...
	*@author ...
	*/
	//class laya.d3.core.material.StandardMaterial extends laya.d3.core.material.BaseMaterial
	var StandardMaterial=(function(_super){
		function StandardMaterial(){
			this._transformUV=null;
			StandardMaterial.__super.call(this);
			this._setColor(0,"MATERIALAMBIENT",StandardMaterial.AMBIENTCOLORVALUE);
			this._setColor(1,"MATERIALDIFFUSE",StandardMaterial.DIFFUSECOLORVALUE);
			this._setColor(2,"MATERIALSPECULAR",StandardMaterial.SPECULARCOLORVALUE);
			this._setColor(3,"MATERIALREFLECT",StandardMaterial.REFLECTCOLORVALUE);
			this._setColor(4,"ALBEDO",StandardMaterial.ALBEDO);
			this._setNumber(0,"ALPHATESTVALUE",0.5);
		}

		__class(StandardMaterial,'laya.d3.core.material.StandardMaterial',_super);
		var __proto=StandardMaterial.prototype;
		/**
		*禁用灯光。
		*/
		__proto.disableLight=function(){
			this._addDisableShaderDefine(0x80 | 0x100 | 0x40);
		}

		/**
		*禁用雾化。
		*/
		__proto.disableFog=function(){
			this._addDisableShaderDefine(0x20000);
		}

		__proto._setLoopShaderParams=function(state,projectionView,worldMatrix,mesh,material){
			(this._transformUV)&& (this._transformUV.matrix);
			var pvw;
			if (worldMatrix===Matrix4x4.DEFAULT){
				pvw=projectionView;
				}else {
				pvw=StandardMaterial._tempMatrix4x40;
				Matrix4x4.multiply(projectionView,worldMatrix,pvw);
			}
			state.shaderValue.pushValue("MATRIX1",worldMatrix.elements);
			state.shaderValue.pushValue("MVPMATRIX",pvw.elements);
		}

		/*state.camera.transform._worldTransformModifyID+worldTransformModifyID+state.camera._projectionMatrixModifyID,从结构上应该在Mesh中更新*/
		__proto.copy=function(dec){
			var standMat=dec;
			standMat._transformUV=this._transformUV;
			return _super.prototype.copy.call(this,standMat);
		}

		/**
		*设置环境光颜色。
		*@param value 环境光颜色。
		*/
		__getset(0,__proto,'ambientColor',function(){
			this._getColor(0);
			},function(value){
			this._setColor(0,"MATERIALAMBIENT",value);
		});

		/**
		*设置漫反射光颜色。
		*@param value 漫反射光颜色。
		*/
		__getset(0,__proto,'diffuseColor',function(){
			this._getColor(1);
			},function(value){
			this._setColor(1,"MATERIALDIFFUSE",value);
		});

		/**
		*设置法线贴图。
		*@param value 法线贴图。
		*/
		/**
		*获取法线贴图。
		*@return 法线贴图。
		*/
		__getset(0,__proto,'normalTexture',function(){
			return this._getTexture(1);
			},function(value){
			if (value){
				this._addShaderDefine(0x2);
				}else {
				this._removeShaderDefine(0x2);
			}
			this._setTexture(value,1,"NORMALTEXTURE");
		});

		/**
		*设置高光颜色。
		*@param value 高光颜色。
		*/
		__getset(0,__proto,'specularColor',function(){
			this._getColor(2);
			},function(value){
			this._setColor(2,"MATERIALSPECULAR",value);
		});

		/**
		*设置反射颜色。
		*@param value 反射颜色。
		*/
		__getset(0,__proto,'reflectColor',function(){
			this._getColor(3);
			},function(value){
			this._setColor(3,"MATERIALREFLECT",value);
		});

		/**
		*设置反射贴图。
		*@param value 反射贴图。
		*/
		/**
		*获取反射贴图。
		*@return 反射贴图。
		*/
		__getset(0,__proto,'reflectTexture',function(){
			return this._getTexture(5);
			},function(value){
			if (value){
				this._addShaderDefine(0x40000);
				}else {
				this._removeShaderDefine(0x40000);
			}
			this._setTexture(value,5,"REFLECTTEXTURE");
		});

		/**
		*设置高光贴图。
		*@param value 高光贴图。
		*/
		/**
		*获取高光贴图。
		*@return 高光贴图。
		*/
		__getset(0,__proto,'specularTexture',function(){
			return this._getTexture(2);
			},function(value){
			if (value){
				this._addShaderDefine(0x4);
				}else {
				this._removeShaderDefine(0x4);
			}
			this._setTexture(value,2,"SPECULARTEXTURE");
		});

		/**
		*设置反射率。
		*@param value 反射率。
		*/
		__getset(0,__proto,'albedo',function(){
			this._getColor(4);
			},function(value){
			this._setColor(4,"ALBEDO",value);
		});

		/**
		*设置漫反射贴图。
		*@param value 漫反射贴图。
		*/
		/**
		*获取漫反射贴图。
		*@return 漫反射贴图。
		*/
		__getset(0,__proto,'diffuseTexture',function(){
			return this._getTexture(0);
			},function(value){
			if (value){
				this._addShaderDefine(0x1);
				}else {
				this._removeShaderDefine(0x1);
			}
			this._setTexture(value,0,"DIFFUSETEXTURE");
		});

		/**
		*设置透明测试模式裁剪值。
		*@param value 透明测试模式裁剪值。
		*/
		/**
		*获取透明测试模式裁剪值。
		*@return 透明测试模式裁剪值。
		*/
		__getset(0,__proto,'alphaTestValue',function(){
			return this._getNumber(0);
			},function(value){
			this._setNumber(0,"ALPHATESTVALUE",value);
		});

		/**
		*设置放射贴图。
		*@param value 放射贴图。
		*/
		/**
		*获取放射贴图。
		*@return 放射贴图。
		*/
		__getset(0,__proto,'emissiveTexture',function(){
			return this._getTexture(3);
			},function(value){
			if (value){
				this._addShaderDefine(0x8);
				}else {
				this._removeShaderDefine(0x8);
			}
			this._setTexture(value,3,"EMISSIVETEXTURE");
		});

		/**
		*设置环境贴图。
		*@param value 环境贴图。
		*/
		/**
		*获取环境贴图。
		*@return 环境贴图。
		*/
		__getset(0,__proto,'ambientTexture',function(){
			return this._getTexture(4);
			},function(value){
			if (value){
				this._addShaderDefine(0x10);
				}else {
				this._removeShaderDefine(0x10);
			}
			this._setTexture(value,4,"AMBIENTTEXTURE");
		});

		/**
		*设置UV变换。
		*@param value UV变换。
		*/
		/**
		*获取UV变换。
		*@return UV变换。
		*/
		__getset(0,__proto,'transformUV',function(){
			return this._transformUV;
			},function(value){
			this._transformUV=value;
			this._setMatrix4x4(0,"MATRIX2",value.matrix);
			if (value)
				this._addShaderDefine(0x4000);
			else
			this._removeShaderDefine(0x4000);
		});

		StandardMaterial._ambientColorIndex=0;
		StandardMaterial._diffuseColorIndex=1;
		StandardMaterial._speclarColorIndex=2;
		StandardMaterial._reflectColorIndex=3;
		StandardMaterial._albedoColorIndex=4;
		StandardMaterial._alphaTestValueIndex=0;
		StandardMaterial._diffuseTextureIndex=0;
		StandardMaterial._normalTextureIndex=1;
		StandardMaterial._specularTextureIndex=2;
		StandardMaterial._emissiveTextureIndex=3;
		StandardMaterial._ambientTextureIndex=4;
		StandardMaterial._reflectTextureIndex=5;
		StandardMaterial.TRANSFORMUV=0;
		__static(StandardMaterial,
		['_tempMatrix4x40',function(){return this._tempMatrix4x40=new Matrix4x4();},'defaultMaterial',function(){return this.defaultMaterial=new StandardMaterial();},'AMBIENTCOLORVALUE',function(){return this.AMBIENTCOLORVALUE=new Vector3(0.6,0.6,0.6);},'DIFFUSECOLORVALUE',function(){return this.DIFFUSECOLORVALUE=new Vector3(1.0,1.0,1.0);},'SPECULARCOLORVALUE',function(){return this.SPECULARCOLORVALUE=new Vector4(1.0,1.0,1.0,8.0);},'REFLECTCOLORVALUE',function(){return this.REFLECTCOLORVALUE=new Vector3(1.0,1.0,1.0);},'ALBEDO',function(){return this.ALBEDO=new Vector4(1.0,1.0,1.0,1.0);}
		]);
		return StandardMaterial;
	})(BaseMaterial)


	/**
	*<code>MeshRender</code> 类用于网格渲染器。
	*/
	//class laya.d3.core.MeshRender extends laya.d3.core.render.BaseRender
	var MeshRender=(function(_super){
		function MeshRender(owner){
			this._meshSprite3DOwner=null;
			this.castShadow=false;
			this.receiveShadow=false;
			MeshRender.__super.call(this,owner);
			this._meshSprite3DOwner=owner;
			this.castShadow=true;
			this.receiveShadow=true;
			this._meshSprite3DOwner.meshFilter.on("meshchanged",this,this._onMeshChanged);
		}

		__class(MeshRender,'laya.d3.core.MeshRender',_super);
		var __proto=MeshRender.prototype;
		/**
		*@private
		*/
		__proto._onMeshChanged=function(sender,oldMesh,mesh){
			if (mesh.loaded){
				this._boundingSphereNeedChange=true;
				this._boundingBoxNeedChange=true;
				}else {
				mesh.once("loaded",this,this._onMeshLoaed);
			}
		}

		/**
		*@private
		*/
		__proto._onMeshLoaed=function(sender,enable){
			this._boundingSphereNeedChange=true;
			this._boundingBoxNeedChange=true;
		}

		__proto._calculateBoundingSphere=function(){
			if (this._meshSprite3DOwner.meshFilter.sharedMesh===null || this._meshSprite3DOwner.meshFilter.sharedMesh.boundingSphere===null){
				this._boundingSphere.toDefault();
				}else {
				var meshBoundingSphere=this._meshSprite3DOwner.meshFilter.sharedMesh.boundingSphere;
				var maxScale=NaN;
				var transform=this._meshSprite3DOwner.transform;
				var scale=transform.scale;
				if (scale.x >=scale.y && scale.x >=scale.z)
					maxScale=scale.x;
				else
				maxScale=scale.y >=scale.z ? scale.y :scale.z;
				Vector3.transformCoordinate(meshBoundingSphere.center,transform.worldMatrix,this._boundingSphere.center);
				this._boundingSphere.radius=meshBoundingSphere.radius *maxScale;
			}
		}

		__proto._calculateBoundingBox=function(){
			if (this._meshSprite3DOwner.meshFilter.sharedMesh===null || this._meshSprite3DOwner.meshFilter.sharedMesh.boundingBox===null){
				this._boundingBox.toDefault();
				}else {
				var meshBoudingBox=this._meshSprite3DOwner.meshFilter.sharedMesh.boundingBox;
				var worldMat=this._meshSprite3DOwner.transform.worldMatrix;
				Vector3.transformCoordinate(meshBoudingBox.min,worldMat,this._boundingBox.min);
				Vector3.transformCoordinate(meshBoudingBox.max,worldMat,this._boundingBox.max);
			}
		}

		/**
		*@private
		*<p>彻底清理资源。</p>
		*<p><b>注意：</b>会强制解锁清理。</p>
		*/
		__proto.dispose=function(){
			this._meshSprite3DOwner.meshFilter.off("meshchanged",this,this._onMeshChanged);
		}

		return MeshRender;
	})(BaseRender)


	//class laya.webgl.utils.Buffer extends laya.resource.Resource
	var Buffer=(function(_super){
		function Buffer(){
			this._glBuffer=null;
			this._buffer=null;
			this._bufferType=0;
			this._bufferUsage=0;
			this._byteLength=0;
			Buffer.__super.call(this);
			Buffer._gl=WebGL.mainContext;
		}

		__class(Buffer,'laya.webgl.utils.Buffer',_super);
		var __proto=Buffer.prototype;
		__proto._bind=function(){
			this.activeResource();
			(Buffer._bindActive[this._bufferType]===this._glBuffer)|| (Buffer._gl.bindBuffer(this._bufferType,Buffer._bindActive[this._bufferType]=this._glBuffer),Shader.activeShader=null);
		}

		__proto.recreateResource=function(){
			this.startCreate();
			this._glBuffer || (this._glBuffer=Buffer._gl.createBuffer());
			this.completeCreate();
		}

		__proto.detoryResource=function(){
			if (this._glBuffer){
				WebGL.mainContext.deleteBuffer(this._glBuffer);
				this._glBuffer=null;
			}
			this.memorySize=0;
		}

		__proto.dispose=function(){
			this.resourceManager.removeResource(this);
			_super.prototype.dispose.call(this);
		}

		//TODO:私有
		__getset(0,__proto,'byteLength',function(){
			return this._byteLength;
		});

		__getset(0,__proto,'bufferType',function(){
			return this._bufferType;
		});

		__getset(0,__proto,'bufferUsage',function(){
			return this._bufferUsage;
		});

		Buffer._gl=null
		Buffer._bindActive={};
		return Buffer;
	})(Resource)


	/**
	*<code>BaseTexture</code> 纹理的父类，抽象类，不允许实例。
	*/
	//class laya.d3.resource.BaseTexture extends laya.resource.Resource
	var BaseTexture=(function(_super){
		function BaseTexture(){
			this._width=0;
			this._height=0;
			this._size=null;
			this._repeat=false;
			this._mipmap=false;
			this._minFifter=0;
			this._magFifter=0;
			this._source=null;
			this._loaded=false;
			BaseTexture.__super.call(this);
			this._repeat=true;
			this._mipmap=true;
			this._minFifter=-1;
			this._magFifter=-1;
		}

		__class(BaseTexture,'laya.d3.resource.BaseTexture',_super);
		var __proto=BaseTexture.prototype;
		/**
		*放大过滤器
		*/
		__getset(0,__proto,'magFifter',function(){
			return this._magFifter;
		});

		/**
		*获取宽度。
		*/
		__getset(0,__proto,'width',function(){
			return this._width;
		});

		/**
		*是否使用重复模式纹理寻址
		*/
		__getset(0,__proto,'repeat',function(){
			return this._repeat;
		});

		/**
		*获取纹理资源。
		*/
		__getset(0,__proto,'source',function(){
			this.activeResource();
			return this._source;
		});

		/**
		*获取高度。
		*/
		__getset(0,__proto,'height',function(){
			return this._height;
		});

		/**
		*表示是否加载成功，只能表示初次载入成功（通常包含下载和载入）,并不能完全表示资源是否可立即使用（资源管理机制释放影响等）。
		*/
		__getset(0,__proto,'loaded',function(){
			return this._loaded;
		});

		/**
		*获取尺寸。
		*/
		__getset(0,__proto,'size',function(){
			return this._size;
		});

		/**
		*是否使用mipLevel
		*/
		__getset(0,__proto,'mipmap',function(){
			return this._mipmap;
		});

		/**\
		*缩小过滤器
		*/
		__getset(0,__proto,'minFifter',function(){
			return this._minFifter;
		});

		return BaseTexture;
	})(Resource)


	/**
	*<code>BaseMesh</code> 类用于创建网格,抽象类,不允许实例。
	*/
	//class laya.d3.resource.models.BaseMesh extends laya.resource.Resource
	var BaseMesh=(function(_super){
		function BaseMesh(){
			this._loaded=false;
			this._subMeshCount=0;
			this._boundingBox=null;
			this._boundingSphere=null;
			BaseMesh.__super.call(this);
			this._loaded=false;
		}

		__class(BaseMesh,'laya.d3.resource.models.BaseMesh',_super);
		var __proto=BaseMesh.prototype;
		/**
		*获取渲染单元数量,请重载此方法。
		*@return 渲染单元数量。
		*/
		__proto.getRenderElementsCount=function(){
			throw new Error("未Override,请重载该属性！");
		}

		/**
		*获取渲染单元,请重载此方法。
		*@param index 索引。
		*@return 渲染单元。
		*/
		__proto.getRenderElement=function(index){
			throw new Error("未Override,请重载该属性！");
		}

		/**
		*获取是否已载入。
		*@return 是否已载入。
		*/
		__getset(0,__proto,'loaded',function(){
			return this._loaded;
		});

		/**
		*获取SubMesh的个数。
		*@return SubMesh的个数。
		*/
		__getset(0,__proto,'subMeshCount',function(){
			return this._subMeshCount;
		});

		/**
		*获取AABB包围盒。
		*@return AABB包围盒。
		*/
		__getset(0,__proto,'boundingBox',function(){
			return this._boundingBox;
		});

		/**
		*获取包围球。
		*@return 包围球。
		*/
		__getset(0,__proto,'boundingSphere',function(){
			return this._boundingSphere;
		});

		/**
		*获取网格顶点,请重载此方法。
		*@return 网格顶点。
		*/
		__getset(0,__proto,'positions',function(){
			throw new Error("未Override,请重载该属性！");
		});

		return BaseMesh;
	})(Resource)


	/**
	*<code>Sky</code> 类用于创建天空的父类，抽象类不允许实例。
	*/
	//class laya.d3.resource.models.Sky extends laya.resource.Resource
	var Sky=(function(_super){
		function Sky(){
			Sky.__super.call(this);
		}

		__class(Sky,'laya.d3.resource.models.Sky',_super);
		var __proto=Sky.prototype;
		__proto._render=function(state){}
		return Sky;
	})(Resource)


	/**
	*@private
	*<code>Bitmap</code> 是图片资源类。
	*/
	//class laya.resource.Bitmap extends laya.resource.Resource
	var Bitmap=(function(_super){
		function Bitmap(){
			//this._source=null;
			//this._w=NaN;
			//this._h=NaN;
			this.useNum=0;
			Bitmap.__super.call(this);
			this._w=0;
			this._h=0;
		}

		__class(Bitmap,'laya.resource.Bitmap',_super);
		var __proto=Bitmap.prototype;
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


	//class laya.webgl.shader.Shader extends laya.resource.Resource
	var Shader=(function(_super){
		function Shader(vs,ps,saveName,nameMap){
			this.customCompile=false;
			//this._nameMap=null;
			//this._vs=null;
			//this._ps=null;
			this._curActTexIndex=0;
			//this._reCompile=false;
			this.tag={};
			//this._vshader=null;
			//this._pshader=null;
			this._program=null;
			this._params=null;
			this._paramsMap={};
			this._offset=0;
			//this._id=0;
			Shader.__super.call(this);
			if ((!vs)|| (!ps))throw "Shader Error";
			if (Render.isConchApp || Render.isFlash){
				this.customCompile=true;
			}
			this._id=++Shader._count;
			this._vs=vs;
			this._ps=ps;
			this._nameMap=nameMap ? nameMap :{};
			saveName !=null && (Shader.sharders[saveName]=this);
		}

		__class(Shader,'laya.webgl.shader.Shader',_super);
		var __proto=Shader.prototype;
		__proto.recreateResource=function(){
			this.startCreate();
			this._compile();
			this.completeCreate();
			this.memorySize=0;
		}

		//忽略尺寸尺寸
		__proto.detoryResource=function(){
			WebGL.mainContext.deleteShader(this._vshader);
			WebGL.mainContext.deleteShader(this._pshader);
			WebGL.mainContext.deleteProgram(this._program);
			this._vshader=this._pshader=this._program=null;
			this._params=null;
			this._paramsMap={};
			this.memorySize=0;
			this._curActTexIndex=0;
		}

		__proto._compile=function(){
			if (!this._vs || !this._ps || this._params)
				return;
			this._reCompile=true;
			this._params=[];
			var text=[this._vs,this._ps];
			var result;
			if (this.customCompile)
				result=this._preGetParams(this._vs,this._ps);
			var gl=WebGL.mainContext;
			this._program=gl.createProgram();
			this._vshader=Shader._createShader(gl,text[0],0x8B31);
			this._pshader=Shader._createShader(gl,text[1],0x8B30);
			gl.attachShader(this._program,this._vshader);
			gl.attachShader(this._program,this._pshader);
			gl.linkProgram(this._program);
			if (!this.customCompile && !gl.getProgramParameter(this._program,0x8B82)){
				throw gl.getProgramInfoLog(this._program);
			};
			var one,i=0,j=0,n=0,location;
			var attribNum=this.customCompile ? result.attributes.length :gl.getProgramParameter(this._program,0x8B89);
			for (i=0;i < attribNum;i++){
				var attrib=this.customCompile ? result.attributes[i] :gl.getActiveAttrib(this._program,i);
				location=gl.getAttribLocation(this._program,attrib.name);
				one={vartype:"attribute",ivartype:0,attrib:attrib,location:location,name:attrib.name,type:attrib.type,isArray:false,isSame:false,preValue:null,indexOfParams:0};
				this._params.push(one);
			};
			var nUniformNum=this.customCompile ? result.uniforms.length :gl.getProgramParameter(this._program,0x8B86);
			for (i=0;i < nUniformNum;i++){
				var uniform=this.customCompile ? result.uniforms[i] :gl.getActiveUniform(this._program,i);
				location=gl.getUniformLocation(this._program,uniform.name);
				one={vartype:"uniform",ivartype:1,attrib:attrib,location:location,name:uniform.name,type:uniform.type,isArray:false,isSame:false,preValue:null,indexOfParams:0};
				if (one.name.indexOf('[0]')> 0){
					one.name=one.name.substr(0,one.name.length-3);
					one.isArray=true;
					one.location=gl.getUniformLocation(this._program,one.name);
				}
				this._params.push(one);
			}
			for (i=0,n=this._params.length;i < n;i++){
				one=this._params[i];
				one.indexOfParams=i;
				one.index=1;
				one.value=[one.location,null];
				one.codename=one.name;
				one.name=this._nameMap[one.codename] ? this._nameMap[one.codename] :one.codename;
				this._paramsMap[one.name]=one;
				one._this=this;
				one.uploadedValue=[];
				if (one.vartype==="attribute"){
					one.fun=this._attribute;
					continue ;
				}
				switch (one.type){
					case 0x1406:
						one.fun=one.isArray ? this._uniform1fv :this._uniform1f;
						break ;
					case 0x8B50:
						one.fun=this._uniform_vec2;
						break ;
					case 0x8B51:
						one.fun=this._uniform_vec3;
						break ;
					case 0x8B52:
						one.fun=this._uniform_vec4;
						break ;
					case 0x8B5E:
						one.fun=this._uniform_sampler2D;
						break ;
					case 0x8B60:
						one.fun=this._uniform_samplerCube;
						break ;
					case 0x8B5C:
						one.fun=this._uniformMatrix4fv;
						break ;
					case 0x8B56:
						one.fun=this._uniform1i;
						break ;
					case 0x8B5A:
					case 0x8B5B:
						throw new Error("compile shader err!");
						break ;
					default :
						throw new Error("compile shader err!");
						break ;
					}
			}
		}

		/**
		*根据变量名字获得
		*@param name
		*@return
		*/
		__proto.getUniform=function(name){
			return this._paramsMap[name];
		}

		__proto._attribute=function(one,value){
			var gl=WebGL.mainContext;
			gl.enableVertexAttribArray(one.location);
			gl.vertexAttribPointer(one.location,value[0],value[1],value[2],value[3],value[4]+this._offset);
			return 2;
		}

		__proto._uniform1f=function(one,value){
			var uploadedValue=one.uploadedValue;
			if (uploadedValue[0]!==value){
				WebGL.mainContext.uniform1f(one.location,uploadedValue[0]=value);
				return 1;
			}
			return 0;
		}

		__proto._uniform1fv=function(one,value){
			if (value.length < 4){
				var uploadedValue=one.uploadedValue;
				if (uploadedValue[0]!==value[0] || uploadedValue[1]!==value[1] || uploadedValue[2]!==value[2] || uploadedValue[3]!==value[3]){
					WebGL.mainContext.uniform1fv(one.location,value);
					uploadedValue[0]=value[0];
					uploadedValue[1]=value[1];
					uploadedValue[2]=value[2];
					uploadedValue[3]=value[3];
					return 1;
				}
				return 0;
				}else {
				WebGL.mainContext.uniform1fv(one.location,value);
				return 1;
			}
		}

		__proto._uniform_vec2=function(one,value){
			var uploadedValue=one.uploadedValue;
			if (uploadedValue[0]!==value[0] || uploadedValue[1]!==value[1]){
				WebGL.mainContext.uniform2f(one.location,uploadedValue[0]=value[0],uploadedValue[1]=value[1]);
				return 1;
			}
			return 0;
		}

		__proto._uniform_vec2v=function(one,value){
			if (value.length < 2){
				var uploadedValue=one.uploadedValue;
				if (uploadedValue[0]!==value[0] || uploadedValue[1]!==value[1] || uploadedValue[2]!==value[2] || uploadedValue[3]!==value[3]){
					WebGL.mainContext.uniform2fv(one.location,value);
					uploadedValue[0]=value[0];
					uploadedValue[1]=value[1];
					uploadedValue[2]=value[2];
					uploadedValue[3]=value[3];
					return 1;
				}
				return 0;
				}else {
				WebGL.mainContext.uniform2fv(one.location,value);
				return 1;
			}
		}

		__proto._uniform_vec3=function(one,value){
			var uploadedValue=one.uploadedValue;
			if (uploadedValue[0]!==value[0] || uploadedValue[1]!==value[1] || uploadedValue[2]!==value[2]){
				WebGL.mainContext.uniform3f(one.location,uploadedValue[0]=value[0],uploadedValue[1]=value[1],uploadedValue[2]=value[2]);
				return 1;
			}
			return 0;
		}

		__proto._uniform_vec3v=function(one,value){
			WebGL.mainContext.uniform3fv(one.location,value);
			return 1;
		}

		__proto._uniform_vec4=function(one,value){
			var uploadedValue=one.uploadedValue;
			if (uploadedValue[0]!==value[0] || uploadedValue[1]!==value[1] || uploadedValue[2]!==value[2] || uploadedValue[3]!==value[3]){
				WebGL.mainContext.uniform4f(one.location,uploadedValue[0]=value[0],uploadedValue[1]=value[1],uploadedValue[2]=value[2],uploadedValue[3]=value[3]);
				return 1;
			}
			return 0;
		}

		__proto._uniform_vec4v=function(one,value){
			WebGL.mainContext.uniform4fv(one.location,value);
			return 1;
		}

		__proto._uniformMatrix2fv=function(one,value){
			WebGL.mainContext.uniformMatrix2fv(one.location,false,value);
			return 1;
		}

		__proto._uniformMatrix3fv=function(one,value){
			WebGL.mainContext.uniformMatrix3fv(one.location,false,value);
			return 1;
		}

		__proto._uniformMatrix4fv=function(one,value){
			WebGL.mainContext.uniformMatrix4fv(one.location,false,value);
			return 1;
		}

		__proto._uniform1i=function(one,value){
			var uploadedValue=one.uploadedValue;
			if (uploadedValue[0]!==value){
				WebGL.mainContext.uniform1i(one.location,uploadedValue[0]=value);
				return 1;
			}
			return 0;
		}

		__proto._uniform1iv=function(one,value){
			WebGL.mainContext.uniform1iv(one.location,value);
			return 1;
		}

		__proto._uniform_ivec2=function(one,value){
			var uploadedValue=one.uploadedValue;
			if (uploadedValue[0]!==value[0] || uploadedValue[1]!==value[1]){
				WebGL.mainContext.uniform2i(one.location,uploadedValue[0]=value[0],uploadedValue[1]=value[1]);
				return 1;
			}
			return 0;
		}

		__proto._uniform_ivec2v=function(one,value){
			WebGL.mainContext.uniform2iv(one.location,value);
			return 1;
		}

		__proto._uniform_vec3i=function(one,value){
			var uploadedValue=one.uploadedValue;
			if (uploadedValue[0]!==value[0] || uploadedValue[1]!==value[1] || uploadedValue[2]!==value[2]){
				WebGL.mainContext.uniform3i(one.location,uploadedValue[0]=value[0],uploadedValue[1]=value[1],uploadedValue[2]=value[2]);
				return 1;
			}
			return 0;
		}

		__proto._uniform_vec3vi=function(one,value){
			WebGL.mainContext.uniform3iv(one.location,value);
			return 1;
		}

		__proto._uniform_vec4i=function(one,value){
			var uploadedValue=one.uploadedValue;
			if (uploadedValue[0]!==value[0] || uploadedValue[1]!==value[1] || uploadedValue[2]!==value[2] || uploadedValue[3]!==value[3]){
				WebGL.mainContext.uniform4i(one.location,uploadedValue[0]=value[0],uploadedValue[1]=value[1],uploadedValue[2]=value[2],uploadedValue[3]=value[3]);
				return 1;
			}
			return 0;
		}

		__proto._uniform_vec4vi=function(one,value){
			WebGL.mainContext.uniform4iv(one.location,value);
			return 1;
		}

		__proto._uniform_sampler2D=function(one,value){
			var gl=WebGL.mainContext;
			var uploadedValue=one.uploadedValue;
			if (uploadedValue[0]==null){
				uploadedValue[0]=this._curActTexIndex;
				gl.uniform1i(one.location,this._curActTexIndex);
				gl.activeTexture(Shader._TEXTURES[this._curActTexIndex]);
				WebGLContext.bindTexture(gl,0x0DE1,value);
				this._curActTexIndex++;
				return 1;
				}else {
				gl.activeTexture(Shader._TEXTURES[uploadedValue[0]]);
				WebGLContext.bindTexture(gl,0x0DE1,value);
				return 0;
			}
		}

		__proto._uniform_samplerCube=function(one,value){
			var gl=WebGL.mainContext;
			var uploadedValue=one.uploadedValue;
			if (uploadedValue[0]==null){
				uploadedValue[0]=this._curActTexIndex;
				gl.uniform1i(one.location,this._curActTexIndex);
				gl.activeTexture(Shader._TEXTURES[this._curActTexIndex]);
				WebGLContext.bindTexture(gl,0x8513,value);
				this._curActTexIndex++;
				return 1;
				}else {
				gl.activeTexture(Shader._TEXTURES[uploadedValue[0]]);
				WebGLContext.bindTexture(gl,0x8513,value);
				return 0;
			}
		}

		__proto._noSetValue=function(one){
			console.log("no....:"+one.name);
		}

		//throw new Error("upload shader err,must set value:"+one.name);
		__proto.uploadOne=function(name,value){
			this.activeResource();
			WebGLContext.UseProgram(this._program);
			var one=this._paramsMap[name];
			one.fun.call(this,one,value);
		}

		__proto.uploadTexture2D=function(value){
			Stat.shaderCall++;
			var gl=WebGL.mainContext;
			gl.activeTexture(0x84C0);
			WebGLContext.bindTexture(gl,0x0DE1,value);
		}

		/**
		*提交shader到GPU
		*@param shaderValue
		*/
		__proto.upload=function(shaderValue,params){
			Shader.activeShader=this;
			this.activeResource();
			WebGLContext.UseProgram(this._program);
			if (this._reCompile){
				params=this._params;
				this._reCompile=false;
				}else {
				params=params || this._params;
			};
			var one,value,n=params.length,shaderCall=0;
			for (var i=0;i < n;i++){
				one=params[i];
				((value=shaderValue[one.name])!==null)&& (shaderCall+=one.fun.call(this,one,value));
			}
			Stat.shaderCall+=shaderCall;
		}

		/**
		*按数组的定义提交
		*@param shaderValue 数组格式[name,value,...]
		*/
		__proto.uploadArray=function(shaderValue,length,_bufferUsage){
			Shader.activeShader=this;
			this.activeResource();
			WebGLContext.UseProgram(this._program);
			var params=this._params,value;
			var one,shaderCall=0;
			for (var i=length-2;i >=0;i-=2){
				one=this._paramsMap[shaderValue[i]];
				if (!one)
					continue ;
				value=shaderValue[i+1];
				if (value !=null){
					_bufferUsage && _bufferUsage[one.name] && _bufferUsage[one.name].bind();
					shaderCall+=one.fun.call(this,one,value);
				}
			}
			Stat.shaderCall+=shaderCall;
		}

		/**
		*得到编译后的变量及相关预定义
		*@return
		*/
		__proto.getParams=function(){
			return this._params;
		}

		__proto._preGetParams=function(vs,ps){
			var text=[vs,ps];
			var result={};
			var attributes=[];
			var uniforms=[];
			var definesInfo={};
			var definesName=[];
			result.attributes=attributes;
			result.uniforms=uniforms;
			result.defines=definesInfo;
			var removeAnnotation=new RegExp("(/\\*([^*]|[\\r\\\n]|(\\*+([^*/]|[\\r\\n])))*\\*+/)|(//.*)","g");
			var reg=new RegExp("(\".*\")|('.*')|([#\\w\\*-\\.+/()=<>{}\\\\]+)|([,;:\\\\])","g");
			var i=0,n=0,one;
			for (var s=0;s < 2;s++){
				text[s]=text[s].replace(removeAnnotation,"");
				var words=text[s].match(reg);
				var tempelse;
				for (i=0,n=words.length;i < n;i++){
					var word=words[i];
					if (word !="attribute" && word !="uniform"){
						if (word=="#define"){
							word=words[++i];
							definesName[word]=1;
							continue ;
							}else if (word=="#ifdef"){
							tempelse=words[++i];
							var def=definesInfo[tempelse]=definesInfo[tempelse] || [];
							for (i++;i < n;i++){
								word=words[i];
								if (word !="attribute" && word !="uniform"){
									if (word=="#else"){
										for (i++;i < n;i++){
											word=words[i];
											if (word !="attribute" && word !="uniform"){
												if (word=="#endif"){
													break ;
												}
												continue ;
											}
											i=this.parseOne(attributes,uniforms,words,i,word,!definesName[tempelse]);
										}
									}
									continue ;
								}
								i=this.parseOne(attributes,uniforms,words,i,word,definesName[tempelse]);
							}
						}
						continue ;
					}
					i=this.parseOne(attributes,uniforms,words,i,word,true);
				}
			}
			return result;
		}

		__proto.parseOne=function(attributes,uniforms,words,i,word,b){
			var one={type:Shader.shaderParamsMap[words[i+1]],name:words[i+2],size:isNaN(parseInt(words[i+3]))? 1 :parseInt(words[i+3])};
			if (b){
				if (word=="attribute"){
					attributes.push(one);
					}else {
					uniforms.push(one);
				}
			}
			if (words[i+3]==':'){
				one.type=words[i+4];
				i+=2;
			}
			i+=2;
			return i;
		}

		__proto.dispose=function(){
			this.resourceManager.removeResource(this);
			_super.prototype.dispose.call(this);
		}

		Shader.getShader=function(name){
			return Shader.sharders[name];
		}

		Shader.create=function(vs,ps,saveName,nameMap){
			return new Shader(vs,ps,saveName,nameMap);
		}

		Shader.withCompile=function(nameID,define,shaderName,createShader){
			if (shaderName && Shader.sharders[shaderName])
				return Shader.sharders[shaderName];
			var pre=Shader._preCompileShader[0.0002 *nameID];
			if (!pre)
				throw new Error("withCompile shader err!"+nameID);
			return pre.createShader(define,shaderName,createShader);
		}

		Shader.withCompile2D=function(nameID,mainID,define,shaderName,createShader){
			if (shaderName && Shader.sharders[shaderName])
				return Shader.sharders[shaderName];
			var pre=Shader._preCompileShader[0.0002 *nameID+mainID];
			if (!pre)
				throw new Error("withCompile shader err!"+nameID+" "+mainID);
			return pre.createShader(define,shaderName,createShader);
		}

		Shader.addInclude=function(fileName,txt){
			if (!txt || txt.length===0)
				throw new Error("add shader include file err:"+fileName);
			if (Shader._includeFiles[fileName])
				throw new Error("add shader include file err, has add:"+fileName);
			Shader._includeFiles[fileName]=txt;
		}

		Shader.preCompile=function(nameID,vs,ps,nameMap){
			var id=0.0002 *nameID;
			Shader._preCompileShader[id]=new ShaderCompile(id,vs,ps,nameMap,Shader._includeFiles);
		}

		Shader.preCompile2D=function(nameID,mainID,vs,ps,nameMap){
			var id=0.0002 *nameID+mainID;
			Shader._preCompileShader[id]=new ShaderCompile(id,vs,ps,nameMap,Shader._includeFiles);
		}

		Shader._createShader=function(gl,str,type){
			var shader=gl.createShader(type);
			gl.shaderSource(shader,str);
			gl.compileShader(shader);
			if (!gl.getShaderParameter(shader,0x8B81)){
				throw gl.getShaderInfoLog(shader);
			}
			return shader;
		}

		Shader._TEXTURES=[0x84C0,0x84C1,0x84C2,0x84C3,0x84C4,0x84C5,0x84C6,,0x84C7,0x84C8];
		Shader._includeFiles={};
		Shader._count=0;
		Shader._preCompileShader={};
		Shader.SHADERNAME2ID=0.0002;
		Shader.activeShader=null
		Shader.sharders=(Shader.sharders=[],Shader.sharders.length=0x20,Shader.sharders);
		__static(Shader,
		['shaderParamsMap',function(){return this.shaderParamsMap={"float":0x1406,"int":0x1404,"bool":0x8B56,"vec2":0x8B50,"vec3":0x8B51,"vec4":0x8B52,"ivec2":0x8B53,"ivec3":0x8B54,"ivec4":0x8B55,"bvec2":0x8B57,"bvec3":0x8B58,"bvec4":0x8B59,"mat2":0x8B5A,"mat3":0x8B5B,"mat4":0x8B5C,"sampler2D":0x8B5E,"samplerCube":0x8B60};},'nameKey',function(){return this.nameKey=new StringKey();}
		]);
		return Shader;
	})(Resource)


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
			try {
				this._audio.removeEventListener("canplay",this._resumePlay);
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
			try {
				this._audio.currentTime=this.startTime;
				}catch (e){
				this._audio.addEventListener("canplay",this._resumePlay);
				return;
			}
			Browser.container.appendChild(this._audio);
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
		*/
		__proto.play=function(){
			this._clearBufferSource();
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
			try {sourceNode.buffer=WebAudioSound._miniBuffer;}catch (e){WebAudioSoundChannel._tryCleanFailed=true;}
		}

		/**
		*停止播放
		*/
		__proto.stop=function(){
			this._clearBufferSource();
			this.audioBuffer=null;
			if (this.gain)
				this.gain.disconnect();
			this.isStopped=true;
			SoundManager.removeChannel(this);
			this.completeHandler=null;
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

		/**
		*设置音量
		*/
		/**
		*获取音量
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

		WebAudioSoundChannel._tryCleanFailed=false;
		return WebAudioSoundChannel;
	})(SoundChannel)


	//class laya.webgl.resource.RenderTarget2D extends laya.resource.Texture
	var RenderTarget2D=(function(_super){
		function RenderTarget2D(width,height,surfaceFormat,surfaceType,depthStencilFormat,mipMap,repeat,minFifter,magFifter){
			this._type=0;
			this._svWidth=NaN;
			this._svHeight=NaN;
			this._preRenderTarget=null;
			this._alreadyResolved=false;
			this._looked=false;
			this._surfaceFormat=0;
			this._surfaceType=0;
			this._depthStencilFormat=0;
			this._mipMap=false;
			this._repeat=false;
			this._minFifter=0;
			this._magFifter=0;
			this._destroy=false;
			(surfaceFormat===void 0)&& (surfaceFormat=0x1908);
			(surfaceType===void 0)&& (surfaceType=0x1401);
			(depthStencilFormat===void 0)&& (depthStencilFormat=0x81A5);
			(mipMap===void 0)&& (mipMap=false);
			(repeat===void 0)&& (repeat=false);
			(minFifter===void 0)&& (minFifter=-1);
			(magFifter===void 0)&& (magFifter=-1);
			this._type=1;
			this._w=width;
			this._h=height;
			this._surfaceFormat=surfaceFormat;
			this._surfaceType=surfaceType;
			this._depthStencilFormat=depthStencilFormat;
			this._mipMap=mipMap;
			this._repeat=repeat;
			this._minFifter=minFifter;
			this._magFifter=magFifter;
			this._createWebGLRenderTarget();
			this.bitmap.lock=true;
			RenderTarget2D.__super.call(this,this.bitmap,Texture.INV_UV);
		}

		__class(RenderTarget2D,'laya.webgl.resource.RenderTarget2D',_super);
		var __proto=RenderTarget2D.prototype;
		Laya.imps(__proto,{"laya.resource.IDispose":true})
		//TODO:临时......................................................
		__proto.getType=function(){
			return this._type;
		}

		//*/
		__proto.getTexture=function(){
			return this;
		}

		__proto.size=function(w,h){
			if (this.bitmap && this._w==w && this._h==h)
				return;
			this._w=w;
			this._h=h;
			this.release();
			this._createWebGLRenderTarget();
		}

		__proto.release=function(){
			this.destroy();
		}

		__proto.recycle=function(){
			RenderTarget2D.POOL.push(this);
		}

		__proto.start=function(){
			var gl=WebGL.mainContext;
			this._preRenderTarget=RenderState2D.curRenderTarget;
			RenderState2D.curRenderTarget=this;
			gl.bindFramebuffer(0x8D40,this.bitmap.frameBuffer);
			this._alreadyResolved=false;
			if (this._type==1){
				gl.viewport(0,0,this._w,this._h);
				this._svWidth=RenderState2D.width;
				this._svHeight=RenderState2D.height;
				RenderState2D.width=this._w;
				RenderState2D.height=this._h;
				Shader.activeShader=null;
			}
			return this;
		}

		__proto.clear=function(r,g,b,a){
			(r===void 0)&& (r=0.0);
			(g===void 0)&& (g=0.0);
			(b===void 0)&& (b=0.0);
			(a===void 0)&& (a=1.0);
			var gl=WebGL.mainContext;
			gl.clearColor(r,g,b,a);
			var clearFlag=0x00004000;
			switch (this._depthStencilFormat){
				case 0x81A5:
					clearFlag |=0x00000100;
					break ;
				case 0x8D48:
					clearFlag |=0x00000400;
					break ;
				case 0x84F9:
					clearFlag |=0x00000100;
					clearFlag |=0x00000400
					break ;
				}
			gl.clear(clearFlag);
		}

		__proto.end=function(){
			var gl=WebGL.mainContext;
			gl.bindFramebuffer(0x8D40,this._preRenderTarget ? this._preRenderTarget.bitmap.frameBuffer :null);
			this._alreadyResolved=true;
			RenderState2D.curRenderTarget=this._preRenderTarget;
			if (this._type==1){
				gl.viewport(0,0,this._svWidth,this._svHeight);
				RenderState2D.width=this._svWidth;
				RenderState2D.height=this._svHeight;
				Shader.activeShader=null;
			}else gl.viewport(0,0,Laya.stage.width,Laya.stage.height);
		}

		__proto.getData=function(x,y,width,height){
			var gl=WebGL.mainContext;
			gl.bindFramebuffer(0x8D40,(this.bitmap).frameBuffer);
			var canRead=(gl.checkFramebufferStatus(0x8D40)===0x8CD5);
			if (!canRead){
				gl.bindFramebuffer(0x8D40,null);
				return null;
			};
			var pixels=new Uint8Array(this._w *this._h *4);
			gl.readPixels(x,y,width,height,this._surfaceFormat,this._surfaceType,pixels);
			gl.bindFramebuffer(0x8D40,null);
			return pixels;
		}

		/**彻底清理资源,注意会强制解锁清理*/
		__proto.destroy=function(foreDiposeTexture){
			(foreDiposeTexture===void 0)&& (foreDiposeTexture=false);
			if (!this._destroy){
				this._loaded=false;
				this.bitmap.dispose();
				this.bitmap=null;
				this._destroy=true;
				_super.prototype.destroy.call(this);
			}
		}

		//待测试
		__proto.dispose=function(){}
		__proto._createWebGLRenderTarget=function(){
			this.bitmap=new WebGLRenderTarget(this.width,this.height,this._surfaceFormat,this._surfaceType,this._depthStencilFormat,this._mipMap,this._repeat,this._minFifter,this._magFifter);
			this.bitmap.activeResource();
			this._alreadyResolved=true;
			this._destroy=false;
			this._loaded=true;
		}

		__getset(0,__proto,'surfaceFormat',function(){
			return this._surfaceFormat;
		});

		//}
		__getset(0,__proto,'minFifter',function(){
			return this._minFifter;
		});

		__getset(0,__proto,'surfaceType',function(){
			return this._surfaceType;
		});

		__getset(0,__proto,'depthStencilFormat',function(){
			return this._depthStencilFormat;
		});

		__getset(0,__proto,'mipMap',function(){
			return this._mipMap;
		});

		__getset(0,__proto,'magFifter',function(){
			return this._magFifter;
		});

		/**返回RenderTarget的Texture*/
		__getset(0,__proto,'source',function(){
			if (this._alreadyResolved)
				return _super.prototype._$get_source.call(this);
			throw new Error("RenderTarget  还未准备好！");
		});

		RenderTarget2D.create=function(w,h,surfaceFormat,surfaceType,depthStencilFormat,mipMap,repeat,minFifter,magFifter){
			(surfaceFormat===void 0)&& (surfaceFormat=0x1908);
			(surfaceType===void 0)&& (surfaceType=0x1401);
			(depthStencilFormat===void 0)&& (depthStencilFormat=0x81A5);
			(mipMap===void 0)&& (mipMap=false);
			(repeat===void 0)&& (repeat=false);
			(minFifter===void 0)&& (minFifter=-1);
			(magFifter===void 0)&& (magFifter=-1);
			var t=RenderTarget2D.POOL.pop();
			t || (t=new RenderTarget2D(w,h));
			if (!t.bitmap || t._w !=w || t._h !=h || t._surfaceFormat !=surfaceFormat || t._surfaceType !=surfaceType || t._depthStencilFormat !=depthStencilFormat || t._mipMap !=mipMap || t._repeat !=repeat || t._minFifter !=minFifter || t._magFifter !=magFifter){
				t._w=w;
				t._h=h;
				t._surfaceFormat=surfaceFormat;
				t._surfaceType=surfaceType;
				t._depthStencilFormat=depthStencilFormat;
				t._mipMap=mipMap;
				t._repeat=repeat;
				t._minFifter=minFifter;
				t._magFifter=magFifter;
				t.release();
				t._createWebGLRenderTarget();
			}
			return t;
		}

		RenderTarget2D.TYPE2D=1;
		RenderTarget2D.TYPE3D=2;
		RenderTarget2D.POOL=[];
		return RenderTarget2D;
	})(Texture)


	//class laya.webgl.shader.d2.fillTexture.FillTextureSV extends laya.webgl.shader.d2.value.Value2D
	var FillTextureSV=(function(_super){
		function FillTextureSV(type){
			this.texcoord=null;
			this.u_texRange=[0,1,0,1];
			this.u_offset=[0.5,0.5];
			FillTextureSV.__super.call(this,0x100,0);
			var _vlen=8 *CONST3D2D.BYTES_PE;
			this.position=[2,0x1406,false,_vlen,0];
			this.texcoord=[2,0x1406,false,_vlen,2 *CONST3D2D.BYTES_PE];
			this.color=[4,0x1406,false,_vlen,4 *CONST3D2D.BYTES_PE];
		}

		__class(FillTextureSV,'laya.webgl.shader.d2.fillTexture.FillTextureSV',_super);
		return FillTextureSV;
	})(Value2D)


	//class laya.webgl.shader.d2.skinAnishader.SkinSV extends laya.webgl.shader.d2.value.Value2D
	var SkinSV=(function(_super){
		function SkinSV(type){
			this.texcoord=null;
			this.offsetX=300;
			this.offsetY=0;
			SkinSV.__super.call(this,0x200,0);
			var _vlen=8 *CONST3D2D.BYTES_PE;
			this.position=[2,0x1406,false,_vlen,0];
			this.texcoord=[2,0x1406,false,_vlen,2 *CONST3D2D.BYTES_PE];
			this.color=[4,0x1406,false,_vlen,4 *CONST3D2D.BYTES_PE];
		}

		__class(SkinSV,'laya.webgl.shader.d2.skinAnishader.SkinSV',_super);
		return SkinSV;
	})(Value2D)


	//class laya.webgl.shader.d2.value.Color2dSV extends laya.webgl.shader.d2.value.Value2D
	var Color2dSV=(function(_super){
		function Color2dSV(args){
			Color2dSV.__super.call(this,0x02,0);
			this.color=[];
		}

		__class(Color2dSV,'laya.webgl.shader.d2.value.Color2dSV',_super);
		var __proto=Color2dSV.prototype;
		__proto.setValue=function(value){
			value.fillStyle&&(this.color=value.fillStyle._color._color);
			value.strokeStyle&&(this.color=value.strokeStyle._color._color);
		}

		return Color2dSV;
	})(Value2D)


	//class laya.webgl.shader.d2.value.TextureSV extends laya.webgl.shader.d2.value.Value2D
	var TextureSV=(function(_super){
		function TextureSV(subID){
			this.u_colorMatrix=null;
			this.strength=0;
			this.colorMat=null;
			this.colorAlpha=null;
			this.texcoord=Value2D._TEXCOORD;
			(subID===void 0)&& (subID=0);
			TextureSV.__super.call(this,0x01,subID);
		}

		__class(TextureSV,'laya.webgl.shader.d2.value.TextureSV',_super);
		var __proto=TextureSV.prototype;
		__proto.setValue=function(vo){
			this.ALPHA=vo.ALPHA;
			vo.filters && this.setFilters(vo.filters);
		}

		__proto.clear=function(){
			this.texture=null;
			this.shader=null;
			this.defines.setValue(0);
		}

		return TextureSV;
	})(Value2D)


	//class laya.webgl.shader.d2.value.PrimitiveSV extends laya.webgl.shader.d2.value.Value2D
	var PrimitiveSV=(function(_super){
		function PrimitiveSV(args){
			this.a_color=null;
			this.u_pos=[0,0];
			PrimitiveSV.__super.call(this,0x04,0);
			this.position=[2,0x1406,false,5 *CONST3D2D.BYTES_PE,0];
			this.a_color=[3,0x1406,false,5 *CONST3D2D.BYTES_PE,2 *CONST3D2D.BYTES_PE];
		}

		__class(PrimitiveSV,'laya.webgl.shader.d2.value.PrimitiveSV',_super);
		return PrimitiveSV;
	})(Value2D)


	/**
	*<code>BaseScene</code> 类用于实现场景的父类。
	*/
	//class laya.d3.core.scene.BaseScene extends laya.display.Sprite
	var BaseScene=(function(_super){
		function BaseScene(){
			this._invertYProjectionMatrix=null;
			this._invertYProjectionViewMatrix=null;
			this._invertYScaleMatrix=null;
			this._isInStage=false;
			this._boundFrustum=null;
			this._enableLightCount=3;
			this._renderTargetTexture=null;
			this._customRenderQueneIndex=11;
			this._lastCurrentTime=NaN;
			this._staticBatchManager=null;
			this._dynamicBatchManager=null;
			this.enableFog=false;
			this.fogStart=NaN;
			this.fogRange=NaN;
			this.fogColor=null;
			this.enableLight=true;
			BaseScene.__super.call(this);
			this._renderState=new RenderState();
			this._lights=new Array;
			this._renderConfigs=[];
			this._frustumCullingObjects=[];
			this._quenes=[];
			this._cameraPool=[];
			this._invertYProjectionMatrix=new Matrix4x4();
			this._invertYProjectionViewMatrix=new Matrix4x4();
			this._invertYScaleMatrix=new Matrix4x4();
			Matrix4x4.createScaling(new Vector3(1,-1,1),this._invertYScaleMatrix);
			this._staticBatchManager=new StaticBatchManager();
			this._dynamicBatchManager=new DynamicBatchManager();
			this._boundFrustum=new BoundFrustum(Matrix4x4.DEFAULT);
			this.enableFog=false;
			this.fogStart=300;
			this.fogRange=1000;
			this.fogColor=new Vector3(0.7,0.7,0.7);
			var renderConfig;
			renderConfig=this._renderConfigs[1]=new RenderConfig();
			renderConfig=this._renderConfigs[2]=new RenderConfig();
			renderConfig.cullFace=false;
			renderConfig=this._renderConfigs[3]=new RenderConfig();
			renderConfig.blend=true;
			renderConfig.sFactor=0x0302;
			renderConfig.dFactor=0x0303;
			renderConfig=this._renderConfigs[4]=new RenderConfig();
			renderConfig.cullFace=false;
			renderConfig.blend=true;
			renderConfig.sFactor=0x0302;
			renderConfig.dFactor=0x0303;
			renderConfig=this._renderConfigs[5]=new RenderConfig();
			renderConfig.blend=true;
			renderConfig.sFactor=0x0302;
			renderConfig.dFactor=1;
			renderConfig=this._renderConfigs[6]=new RenderConfig();
			renderConfig.cullFace=false;
			renderConfig.blend=true;
			renderConfig.sFactor=0x0302;
			renderConfig.dFactor=1;
			renderConfig=this._renderConfigs[7]=new RenderConfig();
			renderConfig.blend=true;
			renderConfig.depthMask=0;
			renderConfig.sFactor=0x0302;
			renderConfig.dFactor=0x0303;
			renderConfig=this._renderConfigs[9]=new RenderConfig();
			renderConfig.blend=true;
			renderConfig.depthMask=0;
			renderConfig.sFactor=0x0302;
			renderConfig.dFactor=1;
			renderConfig=this._renderConfigs[8]=new RenderConfig();
			renderConfig.cullFace=false;
			renderConfig.blend=true;
			renderConfig.depthMask=0;
			renderConfig.sFactor=0x0302;
			renderConfig.dFactor=0x0303;
			renderConfig=this._renderConfigs[10]=new RenderConfig();
			renderConfig.cullFace=false;
			renderConfig.blend=true;
			renderConfig.depthMask=0;
			renderConfig.sFactor=0x0302;
			renderConfig.dFactor=1;
			renderConfig=this._renderConfigs[11]=new RenderConfig();
			renderConfig.blend=true;
			renderConfig.depthTest=false;
			renderConfig.sFactor=0x0302;
			renderConfig.dFactor=0x0303;
			renderConfig=this._renderConfigs[13]=new RenderConfig();
			renderConfig.blend=true;
			renderConfig.depthTest=false;
			renderConfig.sFactor=0x0302;
			renderConfig.dFactor=1;
			renderConfig=this._renderConfigs[12]=new RenderConfig();
			renderConfig.cullFace=false;
			renderConfig.blend=true;
			renderConfig.depthTest=false;
			renderConfig.sFactor=0x0302;
			renderConfig.dFactor=0x0303;
			renderConfig=this._renderConfigs[14]=new RenderConfig();
			renderConfig.cullFace=false;
			renderConfig.blend=true;
			renderConfig.depthTest=false;
			renderConfig.sFactor=0x0302;
			renderConfig.dFactor=1;
			this.on("added",this,this._onAdded);
			this.on("removed",this,this._onRemoved);
		}

		__class(BaseScene,'laya.d3.core.scene.BaseScene',_super);
		var __proto=BaseScene.prototype;
		Laya.imps(__proto,{"laya.webgl.submit.ISubmit":true})
		/**
		*@private
		*/
		__proto._onAdded=function(){
			var isInStage=Laya.stage.contains(this);
			(isInStage)&& (this._addSelfAndChildrenRenderObjects());
			(isInStage)&& (this._changeSelfAndChildrenInStage(true));
		}

		/**
		*@private
		*/
		__proto._onRemoved=function(){
			var isInStage=Laya.stage.contains(this);
			(isInStage)&& (this._clearSelfAndChildrenRenderObjects());
			(isInStage)&& (this._changeSelfAndChildrenInStage(false));
		}

		/**
		*@private
		*/
		__proto._changeSelfAndChildrenInStage=function(isInStage){
			this._isInStage=isInStage;
			this.event("instagechanged",isInStage);
			var children=this._childs;
			for (var i=0,n=children.length;i < n;i++)
			(this._childs [i])._changeSelfAndChildrenInStage(isInStage);
		}

		/**
		*清理自身和子节点渲染物体,重写此函数。
		*/
		__proto._clearSelfAndChildrenRenderObjects=function(){
			for (var i=0,n=this._childs.length;i < n;i++)
			(this._childs [i])._clearSelfAndChildrenRenderObjects();
		}

		/**
		*添加自身和子节点渲染物体,重写此函数。
		*/
		__proto._addSelfAndChildrenRenderObjects=function(){
			for (var i=0,n=this._childs.length;i < n;i++)
			(this._childs [i])._addSelfAndChildrenRenderObjects();
		}

		/**
		*@private
		*场景相关渲染准备设置。
		*@param gl WebGL上下文。
		*@return state 渲染状态。
		*/
		__proto._prepareScene=function(gl,camera,state){
			Layer._currentCameraCullingMask=camera.cullingMask;
			state.context=WebGL.mainContext;
			state.elapsedTime=this._lastCurrentTime ? this.timer.currTimer-this._lastCurrentTime :0;
			this._lastCurrentTime=this.timer.currTimer;
			state.reset();
			state.loopCount=Stat.loopCount;
			state.scene=this;
			state.camera=camera;
			var worldShaderValue=state.worldShaderValue;
			var loopCount=Stat.loopCount;
			camera && worldShaderValue.pushValue("CAMERAPOS",camera.transform.position.elements);
			if (this._lights.length > 0){
				var lightCount=0;
				for (var i=0;i < this._lights.length;i++){
					var light=this._lights[i];
					if (!light.active)continue ;
					lightCount++;
					if (lightCount > this._enableLightCount)
						break ;
					light.updateToWorldState(state);
				}
			}
			if (this.enableFog){
				worldShaderValue.pushValue("FOGSTART",this.fogStart);
				worldShaderValue.pushValue("FOGRANGE",this.fogRange);
				worldShaderValue.pushValue("FOGCOLOR",this.fogColor.elements);
			}
			state.shaderValue.pushArray(worldShaderValue);
			var shaderDefs=state.shaderDefs;
			(this.enableFog)&& (shaderDefs._value=shaderDefs._value |=0x20000);
		}

		/**
		*@private
		*/
		__proto._updateScene=function(state){
			this._updateChilds(state);
		}

		/**
		*@private
		*/
		__proto._updateChilds=function(state){
			for (var i=0,n=this._childs.length;i < n;++i){
				var child=this._childs[i];
				child._update(state);
			}
		}

		/**
		*@private
		*/
		__proto._preRenderScene=function(gl,state){
			this._boundFrustum.matrix=state.projectionViewMatrix;
			FrustumCulling.RenderObjectCulling(this._boundFrustum,this);
			for (var i=0,iNum=this._quenes.length;i < iNum;i++)
			(this._quenes[i])&& (this._quenes[i]._preRender(state));
		}

		__proto._clear=function(gl,state){
			var viewport=state.viewport;
			var camera=state.camera;
			var renderTargetHeight=camera.renderTargetSize.height;
			gl.viewport(viewport.x,renderTargetHeight-viewport.y-viewport.height,viewport.width,viewport.height);
			var clearFlag=0;
			switch (camera.clearFlag){
				case 0:
					if (camera.clearColor){
						gl.enable(0x0C11);
						gl.scissor(viewport.x,renderTargetHeight-viewport.y-viewport.height,viewport.width,viewport.height);
						var clearColorE=camera.clearColor.elements;
						gl.clearColor(clearColorE[0],clearColorE[1],clearColorE[2],clearColorE[3]);
						clearFlag=0x00004000;
						if (camera.renderTarget){
						switch (camera.renderTarget.depthStencilFormat){
							case 0x81A5:
								clearFlag |=0x00000100;
								break ;
							case 0x8D48:
								clearFlag |=0x00000400;
								break ;
							case 0x84F9:
								clearFlag |=0x00000100;
								clearFlag |=0x00000400
								break ;
							}
						}else {
						clearFlag |=0x00000100;
					}
					gl.clear(clearFlag);
					gl.disable(0x0C11);
					}else {
					gl.clear(0x00000100);
				}
				break ;
				case 1:
				case 2:
				if (camera.renderTarget){
					switch (camera.renderTarget.depthStencilFormat){
						case 0x81A5:
							clearFlag |=0x00000100;
							break ;
						case 0x8D48:
							clearFlag |=0x00000400;
							break ;
						case 0x84F9:
							clearFlag |=0x00000100;
							clearFlag |=0x00000400
							break ;
						}
					}else {
					clearFlag |=0x00000100;
				}
				break ;
				case 3:
				break ;
				default :
				throw new Error("BaseScene:camera clearFlag invalid.");
			}
		}

		/**
		*@private
		*/
		__proto._renderScene=function(gl,state){
			var camera=state.camera;
			var i=0,n=0;
			var queue;
			for (i=0;i < 3;i++){
				queue=this._quenes[i];
				if (queue){
					queue._setState(gl,state);
					queue._render(state);
				}
			}
			if (camera.clearFlag===1){
				var sky=camera.sky;
				if (sky){
					WebGLContext.setCullFace(gl,false);
					WebGLContext.setDepthFunc(gl,0x0203);
					WebGLContext.setDepthMask(gl,0);
					sky._render(state);
					WebGLContext.setDepthFunc(gl,0x0201);
					WebGLContext.setDepthMask(gl,1);
				}
			}
			for (i=3,n=this._quenes.length;i < n;i++){
				queue=this._quenes[i];
				if (queue){
					queue._sortAlpha(state.camera.transform.position);
					queue._setState(gl,state);
					queue._render(state);
				}
			}
		}

		/**
		*@private
		*/
		__proto._set3DRenderConfig=function(gl){
			gl.disable(0x0BE2);
			WebGLContext._blend=false;
			gl.blendFunc(0x0302,0x0303);
			WebGLContext._sFactor=0x0302;
			WebGLContext._dFactor=0x0303;
			gl.disable(0x0B71);
			WebGLContext._depthTest=false;
			gl.enable(0x0B44);
			WebGLContext._cullFace=true;
			gl.depthMask(1);
			WebGLContext._depthMask=1;
			gl.frontFace(0x0900);
			WebGLContext._frontFace=0x0900;
		}

		/**
		*@private
		*/
		__proto._set2DRenderConfig=function(gl){
			WebGLContext.setBlend(gl,true);
			WebGLContext.setBlendFunc(gl,0x0302,0x0303);
			WebGLContext.setDepthTest(gl,false);
			WebGLContext.setCullFace(gl,false);
			WebGLContext.setDepthMask(gl,1);
			WebGLContext.setFrontFaceCCW(gl,0x0901);
			gl.viewport(0,0,RenderState2D.width,RenderState2D.height);
		}

		/**
		*@private
		*/
		__proto._addLight=function(light){
			if (this._lights.indexOf(light)< 0)this._lights.push(light);
		}

		/**
		*@private
		*/
		__proto._removeLight=function(light){
			var index=this._lights.indexOf(light);
			index >=0 && (this._lights.splice(index,1));
		}

		__proto.addChildAt=function(node,index){
			if (!((node instanceof laya.d3.core.Sprite3D )))
				throw new Error("Sprite3D:Node type must Sprite3D.");
			return laya.display.Node.prototype.addChildAt.call(this,node,index);
		}

		__proto.addChild=function(node){
			if (!((node instanceof laya.d3.core.Sprite3D )))
				throw new Error("Sprite3D:Node type must Sprite3D.");
			return laya.display.Node.prototype.addChild.call(this,node);
		}

		__proto.addFrustumCullingObject=function(frustumCullingObject){
			this._frustumCullingObjects.push(frustumCullingObject);
		}

		__proto.removeFrustumCullingObject=function(frustumCullingObject){
			var index=this._frustumCullingObjects.indexOf(frustumCullingObject);
			(index!==-1)&& (this._frustumCullingObjects.splice(index,1));
		}

		/**
		*获得某个渲染队列。
		*@param index 渲染队列索引。
		*@return 渲染队列。
		*/
		__proto.getRenderQueue=function(index){
			return (this._quenes[index] || (this._quenes[index]=new RenderQueue(this._renderConfigs[index],this)));
		}

		/**
		*添加渲染队列。
		*@param renderConfig 渲染队列配置文件。
		*/
		__proto.addRenderQuene=function(renderConfig){
			this._quenes[this._customRenderQueneIndex++]=new RenderQueue(renderConfig,this);
		}

		/**
		*更新前处理,可重写此函数。
		*@param state 渲染相关状态。
		*/
		__proto.beforeUpate=function(state){}
		/**
		*更新后处理,可重写此函数。
		*@param state 渲染相关状态。
		*/
		__proto.lateUpate=function(state){}
		/**
		*渲染前处理,可重写此函数。
		*@param state 渲染相关状态。
		*/
		__proto.beforeRender=function(state){}
		/**
		*渲染后处理,可重写此函数。
		*@param state 渲染相关状态。
		*/
		__proto.lateRender=function(state){}
		/**
		*@private
		*/
		__proto.render=function(context,x,y){
			(Render._context.ctx)._shader2D.glTexture=null;
			this._childs.length > 0 && context.addRenderObject(this);
			this._renderType &=~0x800;
			_super.prototype.render.call(this,context,x,y);
		}

		/**
		*@private
		*/
		__proto.renderSubmit=function(){
			return 1;
		}

		/**
		*@private
		*/
		__proto.getRenderType=function(){
			return 0;
		}

		/**
		*@private
		*/
		__proto.releaseRender=function(){}
		/**
		*获取当前场景。
		*@return 当前场景。
		*/
		__getset(0,__proto,'scene',function(){
			return this;
		});

		/**
		*获取是否在场景树。
		*@return 是否在场景树。
		*/
		__getset(0,__proto,'isInStage',function(){
			return this._isInStage;
		});

		return BaseScene;
	})(Sprite)


	/**
	*<code>BaseCamera</code> 类用于创建摄像机的父类。
	*/
	//class laya.d3.core.BaseCamera extends laya.d3.core.Sprite3D
	var BaseCamera=(function(_super){
		function BaseCamera(nearPlane,farPlane){
			//this._tempVector3=null;
			//this._position=null;
			//this._up=null;
			//this._forward=null;
			//this._right=null;
			//this._renderTarget=null;
			//this._renderingOrder=0;
			//this._renderTargetSize=null;
			//this._nearPlane=NaN;
			//this._farPlane=NaN;
			//this._fieldOfView=NaN;
			//this._orthographic=false;
			//this._orthographicVerticalSize=NaN;
			//this._useUserProjectionMatrix=false;
			//this._viewportExpressedInClipSpace=false;
			this._projectionMatrixModifyID=0;
			//this.clearFlag=0;
			//this.clearColor=null;
			//this.cullingMask=0;
			//this.sky=null;
			BaseCamera.__super.call(this);
			(nearPlane===void 0)&& (nearPlane=0.1);
			(farPlane===void 0)&& (farPlane=1000);
			this._tempVector3=new Vector3();
			this._up=new Vector3();
			this._forward=new Vector3();
			this._right=new Vector3();
			this._fieldOfView=60;
			this._useUserProjectionMatrix=false;
			this._orthographic=false;
			this._viewportExpressedInClipSpace=true;
			this._renderTargetSize=Size.fullScreen;
			this._orthographicVerticalSize=10;
			this.renderingOrder=0;
			this._nearPlane=nearPlane;
			this._farPlane=farPlane;
			this.cullingMask=2147483647;
			this.clearColor=new Vector4(0.26,0.26,0.26,1.0);
			this.clearFlag=0;
			this._calculateProjectionMatrix();
			Laya.stage.on("resize",this,this._onScreenSizeChanged);
		}

		__class(BaseCamera,'laya.d3.core.BaseCamera',_super);
		var __proto=BaseCamera.prototype;
		/**
		*通过RenderingOrder属性对摄像机机型排序。
		*/
		__proto._sortCamerasByRenderingOrder=function(){
			if (this.isInStage){
				var cameraPool=this.scene._cameraPool;
				var n=cameraPool.length-1;
				for (var i=0;i < n;i++){
					if (cameraPool[i].renderingOrder > cameraPool[n].renderingOrder){
						var tempCamera=cameraPool[i];
						cameraPool[i]=cameraPool[n];
						cameraPool[n]=tempCamera;
					}
				}
			}
		}

		__proto._calculateProjectionMatrix=function(){}
		__proto._onScreenSizeChanged=function(){
			this._calculateProjectionMatrix();
		}

		/**
		*增加可视图层。
		*@param layer 图层。
		*/
		__proto.addLayer=function(layer){
			if (layer.number===29 || layer.number==30)
				return;
			this.cullingMask=this.cullingMask | layer.mask;
		}

		/**
		*移除可视图层。
		*@param layer 图层。
		*/
		__proto.removeLayer=function(layer){
			if (layer.number===29 || layer.number==30)
				return;
			this.cullingMask=this.cullingMask & ~layer.mask;
		}

		/**
		*增加所有图层。
		*/
		__proto.addAllLayers=function(){
			this.cullingMask=2147483647;
		}

		/**
		*移除所有图层。
		*/
		__proto.removeAllLayers=function(){
			this.cullingMask=0 | Layer.getLayerByNumber(29).mask | Layer.getLayerByNumber(30).mask;
		}

		__proto.ResetProjectionMatrix=function(){
			this._useUserProjectionMatrix=false;
			this._calculateProjectionMatrix();
		}

		__proto.destroy=function(destroyChild){
			(destroyChild===void 0)&& (destroyChild=true);
			this.sky=null;
			this.renderTarget=null;
			Laya.stage.off("resize",this,this._onScreenSizeChanged);
			laya.display.Node.prototype.destroy.call(this,destroyChild);
		}

		/**
		*向前移动。
		*@param distance 移动距离。
		*/
		__proto.moveForward=function(distance){
			this._tempVector3.elements[0]=this._tempVector3.elements[1]=0;
			this._tempVector3.elements[2]=distance;
			this.transform.translate(this._tempVector3);
		}

		/**
		*向右移动。
		*@param distance 移动距离。
		*/
		__proto.moveRight=function(distance){
			this._tempVector3.elements[1]=this._tempVector3.elements[2]=0;
			this._tempVector3.elements[0]=distance;
			this.transform.translate(this._tempVector3);
		}

		/**
		*向上移动。
		*@param distance 移动距离。
		*/
		__proto.moveVertical=function(distance){
			this._tempVector3.elements[0]=this._tempVector3.elements[2]=0;
			this._tempVector3.elements[1]=distance;
			this.transform.translate(this._tempVector3,false);
		}

		//}// BoundingFrustumWorldSpace
		__proto._addSelfRenderObjects=function(){
			var cameraPool=this.scene._cameraPool;
			var cmaeraCount=cameraPool.length;
			if (cmaeraCount > 0){
				for (var i=cmaeraCount-1;i >=0;i--){
					if (this.renderingOrder <=cameraPool[i].renderingOrder){
						cameraPool.splice(i+1,0,this);
						break ;
					}
				}
				}else {
				cameraPool.push(this);
			}
		}

		__proto._clearSelfRenderObjects=function(){
			var cameraPool=this.scene._cameraPool;
			cameraPool.splice(cameraPool.indexOf(this),1);
		}

		/**获取位置。*/
		__getset(0,__proto,'position',function(){
			var worldMatrixe=this.transform.worldMatrix.elements;
			var positione=this._position.elements;
			positione[0]=worldMatrixe[12];
			positione[1]=worldMatrixe[13];
			positione[2]=worldMatrixe[14];
			return this._position;
		});

		/**
		*设置渲染目标的尺寸
		*@param value 渲染目标的尺寸。
		*/
		/**
		*获取渲染目标的尺寸
		*@return 渲染目标的尺寸。
		*/
		__getset(0,__proto,'renderTargetSize',function(){
			return this._renderTargetSize;
			},function(value){
			if (this.renderTarget !=null && this._renderTargetSize !=value){}
				this._renderTargetSize=value;
			this._calculateProjectionMatrix();
		});

		/**
		*获取上向量。
		*@return 上向量。
		*/
		__getset(0,__proto,'up',function(){
			var worldMatrixe=this.transform.worldMatrix.elements;
			var upe=this._up.elements;
			upe[0]=worldMatrixe[4];
			upe[1]=worldMatrixe[5];
			upe[2]=worldMatrixe[6];
			return this._up;
		});

		/**
		*设置视野。
		*@param value 视野。
		*/
		/**
		*获取视野。
		*@return 视野。
		*/
		__getset(0,__proto,'fieldOfView',function(){
			return this._fieldOfView;
			},function(value){
			this._fieldOfView=value;
			this._calculateProjectionMatrix();
		});

		/**
		*获取前向量。
		*@return 前向量。
		*/
		__getset(0,__proto,'forward',function(){
			var worldMatrixe=this.transform.worldMatrix.elements;
			var forwarde=this._forward.elements;
			forwarde[0]=-worldMatrixe[8];
			forwarde[1]=-worldMatrixe[9];
			forwarde[2]=-worldMatrixe[10];
			return this._forward;
		});

		/**
		*获取右向量。
		*@return 右向量。
		*/
		__getset(0,__proto,'right',function(){
			var worldMatrixe=this.transform.worldMatrix.elements;
			var righte=this._right.elements;
			righte[0]=worldMatrixe[0];
			righte[1]=worldMatrixe[1];
			righte[2]=worldMatrixe[2];
			return this._right;
		});

		/**
		*设置远裁面。
		*@param value 远裁面。
		*/
		/**
		*获取远裁面。
		*@return 远裁面。
		*/
		__getset(0,__proto,'farPlane',function(){
			return this._farPlane;
			},function(vaule){
			this._farPlane=vaule;
			this._calculateProjectionMatrix();
		});

		__getset(0,__proto,'renderingOrder',function(){
			return this._renderingOrder;
			},function(value){
			this._renderingOrder=value;
			this._sortCamerasByRenderingOrder();
		});

		/**
		*设置渲染场景的渲染目标。
		*@param value 渲染场景的渲染目标。
		*/
		/**
		*获取渲染场景的渲染目标。
		*@return 渲染场景的渲染目标。
		*/
		__getset(0,__proto,'renderTarget',function(){
			return this._renderTarget;
			},function(value){
			this._renderTarget=value;
			if (value !=null)
				this._renderTargetSize=value.size;
		});

		/**
		*设置近裁面。
		*@param value 近裁面。
		*/
		/**
		*获取近裁面。
		*@return 近裁面。
		*/
		__getset(0,__proto,'nearPlane',function(){
			return this._nearPlane;
			},function(value){
			this._nearPlane=value;
			this._calculateProjectionMatrix();
		});

		/**
		*设置是否正交投影矩阵。
		*@param 是否正交投影矩阵。
		*/
		/**
		*获取是否正交投影矩阵。
		*@return 是否正交投影矩阵。
		*/
		__getset(0,__proto,'orthographicProjection',function(){
			return this._orthographic;
			},function(vaule){
			this._orthographic=vaule;
			this._calculateProjectionMatrix();
		});

		/**
		*设置正交投影垂直矩阵尺寸。
		*@param 正交投影垂直矩阵尺寸。
		*/
		/**
		*获取正交投影垂直矩阵尺寸。
		*@return 正交投影垂直矩阵尺寸。
		*/
		__getset(0,__proto,'orthographicVerticalSize',function(){
			return this._orthographicVerticalSize;
			},function(vaule){
			this._orthographicVerticalSize=vaule;
			this._calculateProjectionMatrix();
		});

		BaseCamera.RENDERINGTYPE_DEFERREDLIGHTING="DEFERREDLIGHTING";
		BaseCamera.RENDERINGTYPE_FORWARDRENDERING="FORWARDRENDERING";
		BaseCamera.CLEARFLAG_SOLIDCOLOR=0;
		BaseCamera.CLEARFLAG_SKY=1;
		BaseCamera.CLEARFLAG_DEPTHONLY=2;
		BaseCamera.CLEARFLAG_NONE=3;
		return BaseCamera;
	})(Sprite3D)


	/**
	*<code>LightSprite</code> 类用于创建灯光的父类。
	*/
	//class laya.d3.core.light.LightSprite extends laya.d3.core.Sprite3D
	var LightSprite=(function(_super){
		function LightSprite(){
			this._diffuseColor=null;
			this._ambientColor=null;
			this._specularColor=null;
			this._reflectColor=null;
			LightSprite.__super.call(this);
			this.on("added",this,this._$3__onAdded);
			this.on("removed",this,this._$3__onRemoved);
			this._diffuseColor=new Vector3(0.8,0.8,0.8);
			this._ambientColor=new Vector3(0.6,0.6,0.6);
			this._specularColor=new Vector3(1.0,1.0,1.0);
			this._reflectColor=new Vector3(1.0,1.0,1.0);
		}

		__class(LightSprite,'laya.d3.core.light.LightSprite',_super);
		var __proto=LightSprite.prototype;
		/**
		*@private
		*灯光节点移除事件处理函数。
		*/
		__proto._$3__onRemoved=function(){
			this.scene._removeLight(this);
		}

		/**
		*@private
		*灯光节点添加事件处理函数。
		*/
		__proto._$3__onAdded=function(){
			this.scene._addLight(this);
		}

		/**
		*更新灯光相关渲染状态参数。
		*@param state 渲染状态参数。
		*/
		__proto.updateToWorldState=function(state){}
		/**
		*设置灯光的漫反射颜色。
		*@param value 灯光的漫反射颜色。
		*/
		/**
		*获取灯光的漫反射颜色。
		*@return 灯光的漫反射颜色。
		*/
		__getset(0,__proto,'diffuseColor',function(){
			return this._diffuseColor;
			},function(value){
			this._diffuseColor=value;
		});

		/**
		*获取灯光的类型。
		*@return 灯光的类型。
		*/
		__getset(0,__proto,'lightType',function(){
			return-1;
		});

		/**
		*设置灯光的环境光颜色。
		*@param value 灯光的环境光颜色。
		*/
		/**
		*获取灯光的环境光颜色。
		*@return 灯光的环境光颜色。
		*/
		__getset(0,__proto,'ambientColor',function(){
			return this._ambientColor;
			},function(value){
			this._ambientColor=value;
		});

		/**
		*设置灯光的高光颜色。
		*@param value 灯光的高光颜色。
		*/
		/**
		*获取灯光的高光颜色。
		*@return 灯光的高光颜色。
		*/
		__getset(0,__proto,'specularColor',function(){
			return this._specularColor;
			},function(value){
			this._specularColor=value;
		});

		/**
		*设置灯光的反射颜色。
		*@param value 灯光的反射颜色。
		*/
		/**
		*获取灯光的反射颜色。
		*@return 灯光的反射颜色。
		*/
		__getset(0,__proto,'reflectColor',function(){
			return this._reflectColor;
			},function(value){
			this._reflectColor=value;
		});

		LightSprite.TYPE_DIRECTIONLIGHT=1;
		LightSprite.TYPE_POINTLIGHT=2;
		LightSprite.TYPE_SPOTLIGHT=3;
		return LightSprite;
	})(Sprite3D)


	/**
	*<code>MeshSprite3D</code> 类用于创建网格。
	*/
	//class laya.d3.core.MeshSprite3D extends laya.d3.core.Sprite3D
	var MeshSprite3D=(function(_super){
		function MeshSprite3D(mesh,name){
			this._meshFilter=null;
			this._meshRender=null;
			MeshSprite3D.__super.call(this,name);
			this._meshFilter=new MeshFilter(this);
			this._meshRender=new MeshRender(this);
			this._meshFilter.on("meshchanged",this,this._onMeshChanged);
			this._meshRender.on("materialchanged",this,this._onMaterialChanged);
			this._meshFilter.sharedMesh=mesh;
			if ((mesh instanceof laya.d3.resource.models.Mesh ))
				if (mesh.loaded)
			this._meshRender.sharedMaterials=(mesh).materials;
			else
			mesh.once("loaded",this,this._applyMeshMaterials);
		}

		__class(MeshSprite3D,'laya.d3.core.MeshSprite3D',_super);
		var __proto=MeshSprite3D.prototype;
		/**@private */
		__proto._applyMeshMaterials=function(mesh){
			var shaderMaterials=this._meshRender.sharedMaterials;
			var meshMaterials=mesh.materials;
			for (var i=0,n=meshMaterials.length;i < n;i++)
			(shaderMaterials[i])|| (shaderMaterials[i]=meshMaterials[i]);
			this._meshRender.sharedMaterials=shaderMaterials;
		}

		/**@private */
		__proto._changeRenderObjectByMesh=function(index){
			var renderObjects=this._meshRender.renderCullingObject._renderElements;
			var renderElement=renderObjects[index];
			(renderElement)|| (renderElement=renderObjects[index]=new RenderElement());
			renderElement._renderObject=this._meshRender.renderCullingObject;
			var material=this._meshRender.sharedMaterials[index];
			(material)|| (material=StandardMaterial.defaultMaterial);
			var element=this._meshFilter.sharedMesh.getRenderElement(index);
			renderElement._mainSortID=this._getSortID(element,material);
			renderElement._sprite3D=this;
			renderElement.renderObj=element;
			renderElement._material=material;
			return renderElement;
		}

		/**@private */
		__proto._changeRenderObjectByMaterial=function(index,material){
			var renderElement=this._meshRender.renderCullingObject._renderElements[index];
			var element=this._meshFilter.sharedMesh.getRenderElement(index);
			renderElement._mainSortID=this._getSortID(element,material);
			renderElement._sprite3D=this;
			renderElement.renderObj=element;
			renderElement._material=material;
			return renderElement;
		}

		/**@private */
		__proto._changeRenderObjectsByMesh=function(){
			var renderElementsCount=this._meshFilter.sharedMesh.getRenderElementsCount();
			this._meshRender.renderCullingObject._renderElements.length=renderElementsCount;
			for (var i=0;i < renderElementsCount;i++)
			this._changeRenderObjectByMesh(i);
		}

		/**@private */
		__proto._onMeshChanged=function(meshFilter){
			var mesh=meshFilter.sharedMesh;
			if (mesh.loaded)
				this._changeRenderObjectsByMesh();
			else
			mesh.once("loaded",this,this._onMeshLoaded);
		}

		/**@private */
		__proto._onMeshLoaded=function(sender){
			(sender===this.meshFilter.sharedMesh)&& (this._changeRenderObjectsByMesh());
		}

		/**@private */
		__proto._onMaterialChanged=function(meshRender,index,material){
			var renderElementCount=this._meshRender.renderCullingObject._renderElements.length;
			(index<renderElementCount)&&this._changeRenderObjectByMaterial(index,material);
		}

		/**@private */
		__proto._clearSelfRenderObjects=function(){
			this.scene.removeFrustumCullingObject(this._meshRender.renderCullingObject);
		}

		/**@private */
		__proto._addSelfRenderObjects=function(){
			this.scene.addFrustumCullingObject(this._meshRender.renderCullingObject);
		}

		/**
		*@private
		*/
		__proto._update=function(state){
			state.owner=this;
			if (this._enable){
				this._updateComponents(state);
				this._lateUpdateComponents(state);
			}
			Stat.spriteCount++;
			this._childs.length && this._updateChilds(state);
		}

		__proto.dispose=function(){
			_super.prototype.dispose.call(this);
			this._meshFilter.off("meshchanged",this,this._onMeshChanged);
			this._meshRender.off("materialchanged",this,this._onMaterialChanged);
		}

		/**
		*获取网格过滤器。
		*@return 网格过滤器。
		*/
		__getset(0,__proto,'meshFilter',function(){
			return this._meshFilter;
		});

		/**
		*获取网格渲染器。
		*@return 网格渲染器。
		*/
		__getset(0,__proto,'meshRender',function(){
			return this._meshRender;
		});

		return MeshSprite3D;
	})(Sprite3D)


	/**
	*<p> <code>Text</code> 类用于创建显示对象以显示文本。</p>
	*@example 以下示例代码，创建了一个 <code>Text</code> 实例。
	*<listing version="3.0">
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
			this._clipPoint=null;
			this._currBitmapFont=null;
			this._text=null;
			this._isChanged=false;
			this._textWidth=0;
			this._textHeight=0;
			this._lines=[];
			this._lineWidths=[];
			this._startX=NaN;
			this._startY=NaN;
			this._lastVisibleLineIndex=-1;
			this._words=null;
			this._charSize={};
			this.underline=false;
			this._underlineColor=null;
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
			if (this._words){
				this._words.length=0;
				this._words=null;
			}
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
		*渲染文字。
		*@param begin 开始渲染的行索引。
		*@param visibleLineCount 渲染的行数。
		*/
		__proto.renderText=function(begin,visibleLineCount){
			var graphics=this.graphics;
			graphics.clear();
			var ctxFont=(this.italic ? "italic " :"")+(this.bold ? "bold " :"")+this.fontSize+"px "+this.font;
			Browser.context.font=ctxFont;
			var padding=this.padding;
			var startX=padding[3];
			var textAlgin="left";
			var lines=this._lines;
			var lineHeight=this.leading+this._charSize.height;
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
			var password=style.password;
			if (("prompt" in this)&& this['prompt']==this._text)
				password=false;
			var x=0,y=0;
			var end=Math.min(this._lines.length,visibleLineCount+begin)|| 1;
			for (var i=begin;i < end;i++){
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
				this.underline && this.drawUnderline(textAlgin,x,y,i);
				if (tCurrBitmapFont){
					var tWidth=this.width;
					if (tCurrBitmapFont.autoScaleSize){
						tWidth=this.width *bitmapScale;
					}
					tCurrBitmapFont.drawText(word,this,x,y,this.align,tWidth);
					}else {
					if (Render.isWebGL){
						this._words || (this._words=[]);
						_word=this._words.length > (i-begin)? this._words[i-begin] :new WordText();
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
			if (this._clipPoint)
				graphics.restore();
			this._startX=startX;
			this._startY=startY;
		}

		/**
		*绘制下划线
		*@param x 本行坐标
		*@param y 本行坐标
		*@param lineIndex 本行索引
		*/
		__proto.drawUnderline=function(align,x,y,lineIndex){
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
				this.graphics.clear();
				return;
			}
			Browser.context.font=this._getCSSStyle().font;
			this._lines.length=0;
			this._lineWidths.length=0;
			this.parseLines(this._text);
			this.evalTextSize();
			if (this.checkEnabledViewportOrNot())
				this._clipPoint || (this._clipPoint=new Point(0,0));
			else
			this._clipPoint=null;
			var lineCount=this._lines.length;
			if (this.overflow !=Text.VISIBLE){
				var func=this.overflow==Text.HIDDEN ? Math.floor :Math.ceil;
				lineCount=Math.min(lineCount,func((this.height-this.padding[0]-this.padding[2])/ (this.leading+this._charSize.height)));
			};
			var startLine=this.scrollY / (this._charSize.height+this.leading)| 0;
			this.renderText(startLine,lineCount);
			this.repaint();
		}

		__proto.evalTextSize=function(){
			var nw=NaN,nh=NaN;
			nw=Math.max.apply(this,this._lineWidths);
			if (this._currBitmapFont)
				nh=this._lines.length *(this._currBitmapFont.getMaxHeight()+this.leading)+this.padding[0]+this.padding[2];
			else
			nh=this._lines.length *(this._charSize.height+this.leading)+this.padding[0]+this.padding[2];
			if (nw !=this._textWidth || nh !=this._textHeight){
				this._textWidth=nw;
				this._textHeight=nh;
				if(!this._width||!this._height)
					this.model&&this.model.size(this._width||this._textWidth,this._height||this._textHeight);
			}
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
		__proto.parseLines=function(text){
			var needWordWrapOrTruncate=this.wordWrap || this.overflow==Text.HIDDEN;
			if (needWordWrapOrTruncate){
				var wordWrapWidth=this.getWordWrapWidth();
			};
			var measureResult=Browser.context.measureText("阳");
			this._charSize.width=measureResult.width;
			this._charSize.height=(measureResult.height || this.fontSize);
			var lines=text.replace(/\r\n/g,"\n").split("\n");
			for (var i=0,n=lines.length;i < n;i++){
				if (i < n-1)
					lines[i]+="\n";
				var line=lines[i];
				if (needWordWrapOrTruncate)
					this.parseLine(line,wordWrapWidth);
				else {
					this._lineWidths.push(this.getTextWidth(line));
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
		__proto.parseLine=function(line,wordWrapWidth){
			var ctx=Browser.context;
			var lines=this._lines;
			var maybeIndex=0;
			var execResult;
			var charsWidth=NaN;
			var wordWidth=NaN;
			var startIndex=0;
			charsWidth=this.getTextWidth(line);
			if (charsWidth <=wordWrapWidth){
				lines.push(line);
				this._lineWidths.push(charsWidth);
				return;
			}
			charsWidth=this._currBitmapFont ? this._currBitmapFont.getMaxWidth():this._charSize.width;
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
						if (newLine.charCodeAt(newLine.length-1)< 255){
							execResult=/[^\x20-]+$/.exec(newLine);
							if (execResult){
								j=execResult.index+startIndex;
								if (execResult.index==0)
									j+=newLine.length;
								else
								newLine=line.substring(startIndex,j);
							}
						}
						lines.push(newLine);
						this._lineWidths.push(wordWidth-charsWidth);
						startIndex=j;
						if (j+maybeIndex < m){
							j+=maybeIndex;
							charsWidth=this.getTextWidth(line.substring(startIndex,j));
							wordWidth=charsWidth;
							j--;
							}else {
							lines.push(line.substring(startIndex,m));
							this._lineWidths.push(this.getTextWidth(lines[lines.length-1]));
							startIndex=-1;
							break ;
						}
						}else if (this.overflow==Text.HIDDEN){
						lines.push(line.substring(0,j));
						this._lineWidths.push(this.getTextWidth(lines[lines.length-1]));
						return;
					}
				}
			}
			if (this.wordWrap && startIndex !=-1){
				lines.push(line.substring(startIndex,m));
				this._lineWidths.push(this.getTextWidth(lines[lines.length-1]));
			}
		}

		__proto.getTextWidth=function(text){
			if (this._currBitmapFont)
				return this._currBitmapFont.getTextWidth(text);
			else
			return Browser.context.measureText(text).width;
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
			Browser.context.font=ctxFont;
			var width=this.getTextWidth(this._text.substring(startIndex,charIndex));
			var point=out || new Point();
			return point.setTo(this._startX+width-(this._clipPoint ? this._clipPoint.x :0),this._startY+line *(this._charSize.height+this.leading)-(this._clipPoint ? this._clipPoint.y :0));
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
			return this.textWidth+this.padding[1]+this.padding[3];
			},function(value){
			if (value !=this._width){
				_super.prototype._$set_width.call(this,value);
				this.isChanged=true;
			}
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
			if (Text._bitmapFonts && Text._bitmapFonts[value]){
				this._currBitmapFont=Text._bitmapFonts[value];
			}
			this._getCSSStyle().fontFamily=value;
			this.isChanged=true;
		});

		/**
		*@inheritDoc
		*/
		__getset(0,__proto,'height',function(){
			if (this._height)return this._height;
			return this.textHeight+this.padding[0]+this.padding[2];
			},function(value){
			if (value !=this._height){
				_super.prototype._$set_height.call(this,value);
				this.isChanged=true;
			}
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
			return this._text || "";
			},function(value){
			if (this._text!==value){
				this.lang(value+"");
				this.isChanged=true;
				this.event("change");
			}
		});

		__getset(0,__proto,'lines',function(){
			return this._lines;
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
			if (this._getCSSStyle().color !=value){
				this._getCSSStyle().color=value;
				if (!this._isChanged && this._graphics){
					this._graphics.replaceTextColor(this.color)
					}else {
					this.isChanged=true;
				}
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
			var visibleLineCount=this._height / (this._charSize.height+this.leading)| 0+1;
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
			var startLine=value / (this._charSize.height+this.leading)| 0;
			this._lastVisibleLineIndex=startLine;
			var visibleLineCount=(this._height / (this._charSize.height+this.leading)| 0)+1;
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

		__getset(0,__proto,'underlineColor',function(){
			return this._underlineColor;
			},function(value){
			this._underlineColor=value;
			this._isChanged=true;
			this.typeset();
		});

		Text.registerBitmapFont=function(name,bitmapFont){
			Text._bitmapFonts || (Text._bitmapFonts={});
			Text._bitmapFonts[name]=bitmapFont;
		}

		Text.unregisterBitmapFont=function(name,destroy){
			(destroy===void 0)&& (destroy=true);
			if (Text._bitmapFonts && Text._bitmapFonts[name]){
				var tBitmapFont=Text._bitmapFonts[name];
				if (destroy){
					tBitmapFont.destroy();
				}
				delete Text._bitmapFonts[name];
			}
		}

		Text.langPacks=null
		Text.VISIBLE="visible";
		Text.SCROLL="scroll";
		Text.HIDDEN="hidden";
		Text._bitmapFonts=null
		return Text;
	})(Sprite)


	/**
	*<code>IndexBuffer3D</code> 类用于创建索引缓冲。
	*/
	//class laya.d3.graphics.IndexBuffer3D extends laya.webgl.utils.Buffer
	var IndexBuffer3D=(function(_super){
		function IndexBuffer3D(indexType,indexCount,bufferUsage,canRead){
			this._indexType=null;
			this._indexTypeByteCount=0;
			this._indexCount=0;
			this._canRead=false;
			(bufferUsage===void 0)&& (bufferUsage=0x88E4);
			(canRead===void 0)&& (canRead=false);
			IndexBuffer3D.__super.call(this);
			this._indexType=indexType;
			this._indexCount=indexCount;
			this._bufferUsage=bufferUsage;
			this._bufferType=0x8893;
			this._canRead=canRead;
			this._bind();
			var byteLength=0;
			if (indexType=="ushort")
				this._indexTypeByteCount=2;
			else if (indexType=="ubyte")
			this._indexTypeByteCount=1;
			else
			throw new Error("unidentification index type.");
			byteLength=this._indexTypeByteCount *indexCount;
			this._byteLength=byteLength;
			Buffer._gl.bufferData(this._bufferType,byteLength,this._bufferUsage);
			if (canRead){
				if (indexType=="ushort")
					this._buffer=new Uint16Array(indexCount);
				else if (indexType=="ubyte")
				this._buffer=new Uint8Array(indexCount);
				this.memorySize=byteLength *2;
				}else {
				this.memorySize=byteLength;
			}
		}

		__class(IndexBuffer3D,'laya.d3.graphics.IndexBuffer3D',_super);
		var __proto=IndexBuffer3D.prototype;
		/**
		*设置数据。
		*@param data 索引数据。
		*@param bufferOffset 索引缓冲中的偏移。
		*@param dataStartIndex 索引数据的偏移。
		*@param dataCount 索引数据的数量。
		*/
		__proto.setData=function(data,bufferOffset,dataStartIndex,dataCount){
			(bufferOffset===void 0)&& (bufferOffset=0);
			(dataStartIndex===void 0)&& (dataStartIndex=0);
			(dataCount===void 0)&& (dataCount=4294967295);
			var byteCount=0;
			if (this._indexType=="ushort"){
				byteCount=2;
				if (dataStartIndex!==0 || dataCount!==4294967295)
					data=new Uint16Array(data.buffer,dataStartIndex *byteCount,dataCount);
				}else if (this._indexType=="ubyte"){
				byteCount=1;
				if (dataStartIndex!==0 || dataCount!==4294967295)
					data=new Uint8Array(data.buffer,dataStartIndex *byteCount,dataCount);
			}
			this._bind();
			Buffer._gl.bufferSubData(this._bufferType,bufferOffset *byteCount,data);
			if (this._canRead){
				if (bufferOffset!==0 || dataStartIndex!==0 || dataCount!==4294967295){
					var maxLength=this._buffer.length-bufferOffset;
					if (dataCount > maxLength)
						dataCount=maxLength;
					for (var i=0;i < dataCount;i++)
					this._buffer[bufferOffset+i]=data[i];
					}else {
					this._buffer=data;
				}
			}
		}

		/**
		*获取索引数据。
		*@return 索引数据。
		*/
		__proto.getData=function(){
			if (this._canRead)
				return this._buffer;
			else
			throw new Error("Can't read data from VertexBuffer with only write flag!");
		}

		/**彻底销毁索引缓冲。*/
		__proto.dispose=function(){
			this._buffer=null;
			_super.prototype.dispose.call(this);
			this.memorySize=0;
		}

		/**
		*获取索引类型。
		*@return 索引类型。
		*/
		__getset(0,__proto,'indexType',function(){
			return this._indexType;
		});

		/**
		*获取索引类型字节数量。
		*@return 索引类型字节数量。
		*/
		__getset(0,__proto,'indexTypeByteCount',function(){
			return this._indexTypeByteCount;
		});

		/**
		*获取索引个数。
		*@return 索引个数。
		*/
		__getset(0,__proto,'indexCount',function(){
			return this._indexCount;
		});

		/**
		*获取是否可读。
		*@return 是否可读。
		*/
		__getset(0,__proto,'canRead',function(){
			return this._canRead;
		});

		IndexBuffer3D.INDEXTYPE_UBYTE="ubyte";
		IndexBuffer3D.INDEXTYPE_USHORT="ushort";
		IndexBuffer3D.create=function(indexType,indexCount,bufferUsage,canRead){
			(bufferUsage===void 0)&& (bufferUsage=0x88E4);
			(canRead===void 0)&& (canRead=false);
			return new IndexBuffer3D(indexType,indexCount,bufferUsage,canRead);
		}

		return IndexBuffer3D;
	})(Buffer)


	/**
	*<code>VertexBuffer3D</code> 类用于创建顶点缓冲。
	*/
	//class laya.d3.graphics.VertexBuffer3D extends laya.webgl.utils.Buffer
	var VertexBuffer3D=(function(_super){
		function VertexBuffer3D(vertexDeclaration,vertexCount,bufferUsage,canRead){
			this._vertexDeclaration=null;
			this._vertexCount=0;
			this._canRead=false;
			(canRead===void 0)&& (canRead=false);
			VertexBuffer3D.__super.call(this);
			this._vertexDeclaration=vertexDeclaration;
			this._vertexCount=vertexCount;
			this._bufferUsage=bufferUsage;
			this._bufferType=0x8892;
			this._canRead=canRead;
			this._bind();
			var byteLength=this._vertexDeclaration.vertexStride *vertexCount;
			this.memorySize=byteLength;
			this._byteLength=byteLength;
			Buffer._gl.bufferData(this._bufferType,byteLength,this._bufferUsage);
			canRead && (this._buffer=new Float32Array(byteLength / 4));
		}

		__class(VertexBuffer3D,'laya.d3.graphics.VertexBuffer3D',_super);
		var __proto=VertexBuffer3D.prototype;
		/**
		*和索引缓冲一起绑定。
		*@param ib 索引缓冲。
		*/
		__proto.bindWithIndexBuffer=function(ib){
			(ib)&& (ib._bind());
			this._bind();
		}

		/**
		*设置数据。
		*@param data 顶点数据。
		*@param bufferOffset 顶点缓冲中的偏移。
		*@param dataStartIndex 顶点数据的偏移。
		*@param dataCount 顶点数据的数量。
		*/
		__proto.setData=function(data,bufferOffset,dataStartIndex,dataCount){
			(bufferOffset===void 0)&& (bufferOffset=0);
			(dataStartIndex===void 0)&& (dataStartIndex=0);
			(dataCount===void 0)&& (dataCount=4294967295);
			if (dataStartIndex!==0 || dataCount!==4294967295)
				data=new Float32Array(data.buffer,dataStartIndex *4,dataCount);
			this._bind();
			Buffer._gl.bufferSubData(this._bufferType,bufferOffset *4,data);
			if (this._canRead){
				if (bufferOffset!==0 || dataStartIndex!==0 || dataCount!==4294967295){
					var maxLength=this._buffer.length-bufferOffset;
					if (dataCount > maxLength)
						dataCount=maxLength;
					for (var i=0;i < dataCount;i++)
					this._buffer[bufferOffset+i]=data[i];
					}else {
					this._buffer=data;
				}
			}
		}

		/**
		*获取顶点数据。
		*@return 顶点数据。
		*/
		__proto.getData=function(){
			if (this._canRead)
				return this._buffer;
			else
			throw new Error("Can't read data from VertexBuffer with only write flag!");
		}

		/**销毁顶点缓冲。*/
		__proto.detoryResource=function(){
			var elements=this._vertexDeclaration.getVertexElements();
			for (var i=0;i < elements.length;i++)
			WebGL.mainContext.disableVertexAttribArray(i);
			_super.prototype.detoryResource.call(this);
		}

		/**彻底销毁顶点缓冲。*/
		__proto.dispose=function(){
			_super.prototype.dispose.call(this);
			this._buffer=null;
			this._vertexDeclaration=null;
			this.memorySize=0;
		}

		/**
		*获取顶点结构声明。
		*@return 顶点结构声明。
		*/
		__getset(0,__proto,'vertexDeclaration',function(){
			return this._vertexDeclaration;
		});

		/**
		*获取顶点个数。
		*@return 顶点个数。
		*/
		__getset(0,__proto,'vertexCount',function(){
			return this._vertexCount;
		});

		/**
		*获取是否可读。
		*@return 是否可读。
		*/
		__getset(0,__proto,'canRead',function(){
			return this._canRead;
		});

		VertexBuffer3D.create=function(vertexDeclaration,vertexCount,bufferUsage,canRead){
			(bufferUsage===void 0)&& (bufferUsage=0x88E4);
			(canRead===void 0)&& (canRead=false);
			return new VertexBuffer3D(vertexDeclaration,vertexCount,bufferUsage,canRead);
		}

		return VertexBuffer3D;
	})(Buffer)


	/**
	*<p> <code>Stage</code> 类是显示对象的根节点。</p>
	*可以通过 Laya.stage 访问。
	*/
	//class laya.display.Stage extends laya.display.Sprite
	var Stage=(function(_super){
		function Stage(){
			this.focus=null;
			this._offset=null;
			this.frameRate="fast";
			this.desginWidth=0;
			this.desginHeight=0;
			this.canvasRotation=false;
			this.canvasDegree=0;
			this.renderingEnabled=true;
			this._screenMode="none";
			this._scaleMode="noscale";
			this._alignV="top";
			this._alignH="left";
			this._bgColor="black";
			this._mouseMoveTime=0;
			this._renderCount=0;
			this._safariOffsetY=0;
			this._frameStartTime=NaN;
			this._previousOrientation=0;
			Stage.__super.call(this);
			this.offset=new Point();
			this._canvasTransform=new Matrix();
			var _$this=this;
			this.mouseEnabled=true;
			this.hitTestPrior=true;
			this._displayedInStage=true;
			var _this=this;
			var window=Browser.window;
			window.addEventListener("focus",function(){
				_this.event("focus");
			});
			window.addEventListener("blur",function(){
				_this.event("blur");
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
					_this.event("blur");
					if (_this._isInputting())Input["inputElement"].target.focus=false;
					}else {
					_this.event("focus");
				}
			}
			window.addEventListener("resize",function(){
				var orientation=Browser.window.orientation;
				if (orientation !=null && orientation !=_$this._previousOrientation && _this._isInputting()){
					Input["inputElement"].target.focus=false;
				}
				_$this._previousOrientation=orientation;
				if (_this._isInputting())return;
				if (Browser.onSafari)
					_this._safariOffsetY=(Browser.document.body.clientHeight || Browser.document.documentElement.clientHeight)-Browser.window.innerHeight;
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
			var canvas=Render._mainCanvas;
			var canvasStyle=canvas.source.style;
			canvas.size(1,1);
			canvasStyle.transform=canvasStyle.webkitTransform=canvasStyle.msTransform=canvasStyle.mozTransform=canvasStyle.oTransform="";
			this._style.visible=false;
			Laya.timer.once(100,this,this._changeCanvasSize);
		}

		/**
		*设置屏幕大小，场景会根据屏幕大小进行适配。
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
					canvasWidth=realWidth=Math.round(this.desginWidth *scaleX);
					canvasHeight=realHeight=Math.round(this.desginHeight *scaleY);
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
			scaleX *=this.scaleX;
			scaleY *=this.scaleY;
			if (scaleX===1 && scaleY===1){
				this.transform && this.transform.identity();
				}else {
				this.transform || (this.transform=new Matrix());
				this.transform.a=scaleX / (realWidth / canvasWidth);
				this.transform.d=scaleY / (realHeight / canvasHeight);
				this.model && this.model.scale(this.transform.a,this.transform.d);
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
			if (!this._offset){
				this._offset=new Point(parseInt(canvasStyle.left)|| 0,parseInt(canvasStyle.top)|| 0);
				canvasStyle.left=canvasStyle.top="0px";
			}
			this.offset.x+=this._offset.x;
			this.offset.y+=this._offset.y;
			this.offset.x=Math.round(this.offset.x);
			this.offset.y=Math.round(this.offset.y);
			canvasStyle.top=this._safariOffsetY+"px";
			mat.translate(this.offset.x,this.offset.y);
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
			if (mat.a < 0.00000000000001)mat.a=mat.d=0;
			if (mat.tx < 0.00000000000001)mat.tx=0;
			if (mat.ty < 0.00000000000001)mat.ty=0;
			canvasStyle.transformOrigin=canvasStyle.webkitTransformOrigin=canvasStyle.msTransformOrigin=canvasStyle.mozTransformOrigin=canvasStyle.oTransformOrigin="0px 0px 0px";
			canvasStyle.transform=canvasStyle.webkitTransform=canvasStyle.msTransform=canvasStyle.mozTransform=canvasStyle.oTransform="matrix("+mat.toString()+")";
			this._style.visible=true;
			this._repaint=1;
			this.event("resize");
		}

		/**@inheritDoc */
		__proto.getMousePoint=function(){
			return Point.TEMP.setTo(this.mouseX,this.mouseY);
		}

		/**@inheritDoc */
		__proto.repaint=function(){
			this._repaint=1;
		}

		/**@inheritDoc */
		__proto.parentRepaint=function(){}
		/**@private */
		__proto._loop=function(){
			this.render(Render.context,0,0);
			return true;
		}

		/**@private */
		__proto._onmouseMove=function(e){
			this._mouseMoveTime=Browser.now();
		}

		/**获得距当前帧开始后，过了多少时间，单位为毫秒
		*可以用来判断函数内时间消耗，控制每帧函数处理消耗的时间过长，导致帧率下降*/
		__proto.getTimeFromFrameStart=function(){
			return Browser.now()-this._frameStartTime;
		}

		/**@inheritDoc */
		__proto.render=function(context,x,y){
			this._frameStartTime=Browser.now();
			Render.isFlash && this.repaint();
			this._renderCount++;
			var frameMode=this.frameRate==="mouse" ? (((this._frameStartTime-this._mouseMoveTime)< 2000)? "fast" :"slow"):this.frameRate;
			var isFastMode=(frameMode!=="slow");
			var isDoubleLoop=(this._renderCount % 2===0);
			var ctx=context;
			Stat.renderSlow=!isFastMode;
			if (isFastMode || isDoubleLoop){
				Stat.loopCount++;
				MouseManager.instance.runEvent();
				Laya.timer._update();
				if (Render.isConchNode){
					var customList=Sprite.CustomList;
					for (var i=0,n=customList.length;i < n;i++){
						customList[i].customRender(customList[i].customContext,0,0);
					}
					return;
				}
				if (this.renderingEnabled && this._style.visible){
					Render.isWebGL ? ctx.clear():RunDriver.clear(this._bgColor);
					_super.prototype.render.call(this,context,x,y);
				}
			}
			if (Render.isConchNode)return;
			if (this.renderingEnabled && this._style.visible && (isFastMode || !isDoubleLoop)){
				Render.isWebGL && RunDriver.clear(this._bgColor);
				RunDriver.beginFlush();
				context.flush();
				RunDriver.endFinish();
			}
			VectorGraphManager.instance && VectorGraphManager.getInstance().endDispose();
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

		/**退出全屏*/
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

		__getset(0,__proto,'width',_super.prototype._$get_width,function(value){
			this.desginWidth=value;
			_super.prototype._$set_width.call(this,value);
			Laya.timer.callLater(this,this._changeCanvasSize);
		});

		__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
			this.desginHeight=value;
			_super.prototype._$set_height.call(this,value);
			Laya.timer.callLater(this,this._changeCanvasSize);
		});

		/**鼠标在 Stage 上的 X 轴坐标。*/
		__getset(0,__proto,'mouseX',function(){
			return Math.round(MouseManager.instance.mouseX / this.clientScaleX);
		});

		/**鼠标在 Stage 上的 Y 轴坐标。*/
		__getset(0,__proto,'mouseY',function(){
			return Math.round(MouseManager.instance.mouseY / this.clientScaleY);
		});

		/**
		*<p>缩放模式。</p>
		*<p><ul>取值范围：
		*<li>"noscale" ：不缩放；</li>
		*<li>"exactfit" ：全屏不等比缩放；</li>
		*<li>"showall" ：最小比例缩放；</li>
		*<li>"noborder" ：最大比例缩放；</li>
		*<li>"full" ：不缩放，stage的宽高等于屏幕宽高；</li>
		*<li>"fixedwidth" ：宽度不变，高度根据屏幕比缩放；</li>
		*<li>"fixedheight" ：高度不变，宽度根据屏幕比缩放；</li>
		*</ul></p>
		*默认值为 "noscale"。
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

		/**舞台的背景颜色，默认为黑色，null为透明。*/
		__getset(0,__proto,'bgColor',function(){
			return this._bgColor;
			},function(value){
			this._bgColor=value;
			this.model && this.model.bgColor(value);
			if (value){
				Render.canvas.style.background=value;
				}else {
				Render.canvas.style.background="none";
			}
		});

		/**当前视窗由缩放模式导致的 X 轴缩放系数。*/
		__getset(0,__proto,'clientScaleX',function(){
			return this._transform ? this._transform.getScaleX():1;
		});

		/**当前视窗由缩放模式导致的 Y 轴缩放系数。*/
		__getset(0,__proto,'clientScaleY',function(){
			return this._transform ? this._transform.getScaleY():1;
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

		/**是否开启全屏，用户点击后进入全屏*/
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
	*<code>Mesh</code> 类用于创建文件网格数据模板。
	*/
	//class laya.d3.resource.models.Mesh extends laya.d3.resource.models.BaseMesh
	var Mesh=(function(_super){
		function Mesh(){
			this._materials=null;
			this._subMeshes=null;
			this._bindPoses=null;
			this._inverseBindPoses=null;
			Mesh.__super.call(this);
			this._subMeshes=[];
			this._materials=[];
			if (this._loaded)
				this._generateBoundingObject();
			else
			this.once("loaded",this,this._generateBoundingObject);
		}

		__class(Mesh,'laya.d3.resource.models.Mesh',_super);
		var __proto=Mesh.prototype;
		__proto._generateBoundingObject=function(){
			var pos=this.positions;
			this._boundingBox=new BoundBox(new Vector3(),new Vector3());
			BoundBox.createfromPoints(pos,this._boundingBox);
			this._boundingSphere=new BoundSphere(new Vector3(),0);
			BoundSphere.createfromPoints(pos,this._boundingSphere);
		}

		/**
		*添加子网格（开发者禁止修改）。
		*@param subMesh 子网格。
		*/
		__proto._add=function(subMesh){
			subMesh._indexInMesh=this._subMeshes.length;
			this._subMeshes.push(subMesh);
			this._subMeshCount++;
		}

		/**
		*移除子网格（开发者禁止修改）。
		*@param subMesh 子网格。
		*@return 是否成功。
		*/
		__proto._remove=function(subMesh){
			var index=this._subMeshes.indexOf(subMesh);
			if (index < 0)return false;
			this._subMeshes.splice(index,1);
			this._subMeshCount--;
			return true;
		}

		/**
		*获得子网格。
		*@param index 子网格索引。
		*@return 子网格。
		*/
		__proto.getSubMesh=function(index){
			return this._subMeshes[index];
		}

		/**
		*获得子网格数量。
		*@return 子网格数量。
		*/
		__proto.getSubMeshCount=function(){
			return this._subMeshes.length;
		}

		__proto.getRenderElementsCount=function(){
			return this._subMeshes.length;
		}

		__proto.getRenderElement=function(index){
			return this._subMeshes[index];
		}

		/**
		*<p>彻底清理资源。</p>
		*<p><b>注意：</b>会强制解锁清理。</p>
		*/
		__proto.dispose=function(){
			this._resourceManager.removeResource(this);
			laya.resource.Resource.prototype.dispose.call(this);
			for (var i=0;i < this._subMeshes.length;i++)
			this._subMeshes[i].dispose();
			this._subMeshes=null;
			this._subMeshCount=0;
		}

		/**
		*获取网格顶点
		*@return 网格顶点。
		*/
		__getset(0,__proto,'positions',function(){
			var vertices=[];
			var submesheCount=this._subMeshes.length;
			for (var i=0;i < submesheCount;i++){
				var subMesh=this._subMeshes[i];
				var vertexBuffer=subMesh._getVertexBuffer();
				var positionElement;
				var vertexElements=vertexBuffer.vertexDeclaration.getVertexElements();
				var j=0;
				for (j=0;j < vertexElements.length;j++){
					var vertexElement=vertexElements[j];
					if (vertexElement.elementFormat==="vector3" && vertexElement.elementUsage==="POSITION"){
						positionElement=vertexElement;
						break ;
					}
				};
				var verticesData=vertexBuffer.getData();
				for (j=0;j < verticesData.length;j+=vertexBuffer.vertexDeclaration.vertexStride / 4){
					var ofset=j+positionElement.offset / 4;
					var position=new Vector3(verticesData[ofset+0],verticesData[ofset+1],verticesData[ofset+2]);
					vertices.push(position);
				}
			}
			return vertices;
		});

		/**
		*获取网格的全局默认绑定动作逆矩阵。
		*@return 网格的全局默认绑定动作逆矩阵。
		*/
		__getset(0,__proto,'InverseAbsoluteBindPoses',function(){
			return this._inverseBindPoses;
		});

		/**
		*获取材质队列的浅拷贝。
		*@return 材质队列的浅拷贝。
		*/
		__getset(0,__proto,'materials',function(){
			return this._materials.slice();
		});

		/**
		*获取网格的默认绑定动作矩阵。
		*@return 网格的默认绑定动作矩阵。
		*/
		__getset(0,__proto,'bindPoses',function(){
			return this._bindPoses;
		});

		Mesh.load=function(url){
			url=URL.formatURL(url);
			var mesh=Resource.meshCache[url];
			if (!mesh){
				mesh=Resource.meshCache[url]=new Mesh();
				var loader=new Loader();
				loader.once("complete",null,function(data){
					new LoadModel(data,mesh,mesh._materials,url);
					mesh._loaded=true;
					mesh.event("loaded",mesh);
				});
				loader.load(url,"arraybuffer");
			}
			return mesh;
		}

		return Mesh;
	})(BaseMesh)


	/**
	*<code>RenderTarget</code> 类用于创建渲染目标。
	*/
	//class laya.d3.resource.RenderTexture extends laya.d3.resource.BaseTexture
	var RenderTexture=(function(_super){
		function RenderTexture(width,height,surfaceFormat,surfaceType,depthStencilFormat,mipMap,repeat,minFifter,magFifter){
			this._alreadyResolved=false;
			this._surfaceFormat=0;
			this._surfaceType=0;
			this._depthStencilFormat=0;
			this._frameBuffer=null;
			this._depthStencilBuffer=null;
			(surfaceFormat===void 0)&& (surfaceFormat=0x1908);
			(surfaceType===void 0)&& (surfaceType=0x1401);
			(depthStencilFormat===void 0)&& (depthStencilFormat=0x81A5);
			(mipMap===void 0)&& (mipMap=false);
			(repeat===void 0)&& (repeat=false);
			(minFifter===void 0)&& (minFifter=-1);
			(magFifter===void 0)&& (magFifter=-1);
			RenderTexture.__super.call(this);
			this._width=width;
			this._height=height;
			this._size=new Size(width,height);
			this._surfaceFormat=surfaceFormat;
			this._surfaceType=surfaceType;
			this._depthStencilFormat=depthStencilFormat;
			this._mipmap=mipMap;
			this._repeat=repeat;
			this._minFifter=minFifter;
			this._magFifter=magFifter;
			this.activeResource();
			this._loaded=true;
			this._alreadyResolved=true;
		}

		__class(RenderTexture,'laya.d3.resource.RenderTexture',_super);
		var __proto=RenderTexture.prototype;
		__proto.recreateResource=function(){
			this.startCreate();
			var gl=WebGL.mainContext;
			this._frameBuffer=gl.createFramebuffer();
			this._source=gl.createTexture();
			var preTarget=WebGLContext.curBindTexTarget;
			var preTexture=WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl,0x0DE1,this._source);
			gl.texImage2D(0x0DE1,0,0x1908,this._width,this._height,0,this._surfaceFormat,this._surfaceType,null);
			var minFifter=this._minFifter;
			var magFifter=this._magFifter;
			var repeat=this._repeat ? 0x2901 :0x812F;
			var isPot=Arith.isPOT(this._width,this._height);
			if (isPot){
				if (this._mipmap)
					(minFifter!==-1)|| (minFifter=0x2703);
				else
				(minFifter!==-1)|| (minFifter=0x2601);
				(magFifter!==-1)|| (magFifter=0x2601);
				gl.texParameteri(0x0DE1,0x2801,minFifter);
				gl.texParameteri(0x0DE1,0x2800,magFifter);
				gl.texParameteri(0x0DE1,0x2802,repeat);
				gl.texParameteri(0x0DE1,0x2803,repeat);
				this._mipmap && gl.generateMipmap(0x0DE1);
				}else {
				(minFifter!==-1)|| (minFifter=0x2601);
				(magFifter!==-1)|| (magFifter=0x2601);
				gl.texParameteri(0x0DE1,0x2801,minFifter);
				gl.texParameteri(0x0DE1,0x2800,magFifter);
				gl.texParameteri(0x0DE1,0x2802,0x812F);
				gl.texParameteri(0x0DE1,0x2803,0x812F);
			}
			gl.bindFramebuffer(0x8D40,this._frameBuffer);
			gl.framebufferTexture2D(0x8D40,0x8CE0,0x0DE1,this._source,0);
			if (this._depthStencilFormat){
				this._depthStencilBuffer=gl.createRenderbuffer();
				gl.bindRenderbuffer(0x8D41,this._depthStencilBuffer);
				gl.renderbufferStorage(0x8D41,this._depthStencilFormat,this._width,this._height);
				switch (this._depthStencilFormat){
					case 0x81A5:
						gl.framebufferRenderbuffer(0x8D40,0x8D00,0x8D41,this._depthStencilBuffer);
						break ;
					case 0x8D48:
						gl.framebufferRenderbuffer(0x8D40,0x8D20,0x8D41,this._depthStencilBuffer);
						break ;
					case 0x84F9:
						gl.framebufferRenderbuffer(0x8D40,0x821A,0x8D41,this._depthStencilBuffer);
						break ;
					}
			}
			gl.bindFramebuffer(0x8D40,null);
			(preTarget && preTexture)&& (WebGLContext.bindTexture(gl,preTarget,preTexture));
			gl.bindRenderbuffer(0x8D41,null);
			this.memorySize=this._width *this._height *4;
			this.completeCreate();
		}

		/**
		*开始绑定。
		*/
		__proto.start=function(){
			WebGL.mainContext.bindFramebuffer(0x8D40,this.frameBuffer);
			RenderTexture._currentRenderTarget=this;
			this._alreadyResolved=false;
		}

		/**
		*结束绑定。
		*/
		__proto.end=function(){
			WebGL.mainContext.bindFramebuffer(0x8D40,null);
			RenderTexture._currentRenderTarget=null;
			this._alreadyResolved=true;
		}

		/**
		*获得像素数据。
		*@param x X像素坐标。
		*@param y Y像素坐标。
		*@param width 宽度。
		*@param height 高度。
		*@return 像素数据。
		*/
		__proto.getData=function(x,y,width,height){
			var gl=WebGL.mainContext;
			gl.bindFramebuffer(0x8D40,this._frameBuffer);
			var canRead=(gl.checkFramebufferStatus(0x8D40)===0x8CD5);
			if (!canRead){
				gl.bindFramebuffer(0x8D40,null);
				return null;
			};
			var pixels=new Uint8Array(this._width *this._height *4);
			gl.readPixels(x,y,width,height,this._surfaceFormat,this._surfaceType,pixels);
			gl.bindFramebuffer(0x8D40,null);
			return pixels;
		}

		/**
		*销毁资源。
		*/
		__proto.detoryResource=function(){
			if (this._frameBuffer){
				var gl=WebGL.mainContext;
				gl.deleteTexture(this._source);
				gl.deleteFramebuffer(this._frameBuffer);
				gl.deleteRenderbuffer(this._depthStencilBuffer);
				this._source=null;
				this._frameBuffer=null;
				this._depthStencilBuffer=null;
				this.memorySize=0;
			}
		}

		__getset(0,__proto,'depthStencilBuffer',function(){
			return this._depthStencilBuffer;
		});

		/**
		*获取表面格式。
		*@return 表面格式。
		*/
		__getset(0,__proto,'surfaceFormat',function(){
			return this._surfaceFormat;
		});

		/**
		*获取表面类型。
		*@return 表面类型。
		*/
		__getset(0,__proto,'surfaceType',function(){
			return this._surfaceType;
		});

		/**
		*获取深度格式。
		*@return 深度格式。
		*/
		__getset(0,__proto,'depthStencilFormat',function(){
			return this._depthStencilFormat;
		});

		__getset(0,__proto,'frameBuffer',function(){
			return this._frameBuffer;
		});

		/**
		*获取RenderTarget数据源,如果alreadyResolved等于false，则返回null。
		*@return RenderTarget数据源。
		*/
		__getset(0,__proto,'source',function(){
			if (this._alreadyResolved)
				return _super.prototype._$get_source.call(this);
			else
			return null;
		});

		RenderTexture._currentRenderTarget=null
		return RenderTexture;
	})(BaseTexture)


	/**
	*<code>SolidColorTexture2D</code> 二维纯色纹理。
	*/
	//class laya.d3.resource.SolidColorTexture2D extends laya.d3.resource.BaseTexture
	var SolidColorTexture2D=(function(_super){
		function SolidColorTexture2D(color){
			this._color=null;
			this._pixels=null;
			SolidColorTexture2D.__super.call(this);
			this._width=1;
			this._height=1;
			this._size=new Size(this.width,this.height);
			this._color=color;
			this._pixels=new Uint8Array([color.x *255,color.y *255,color.z *255,color.w *255]);
		}

		__class(SolidColorTexture2D,'laya.d3.resource.SolidColorTexture2D',_super);
		var __proto=SolidColorTexture2D.prototype;
		/**
		*@private
		*/
		__proto._createWebGlTexture=function(){
			var gl=WebGL.mainContext;
			var glTex=this._source=gl.createTexture();
			var w=this._width;
			var h=this._height;
			var preTarget=WebGLContext.curBindTexTarget;
			var preTexture=WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl,0x0DE1,glTex);
			gl.texImage2D(0x0DE1,0,0x1908,w,h,0,0x1908,0x1401,this._pixels);
			var minFifter=this._minFifter;
			var magFifter=this._magFifter;
			var repeat=this._repeat ? 0x2901 :0x812F;
			var isPot=Arith.isPOT(w,h);
			if (isPot){
				if (this._mipmap)
					(minFifter!==-1)|| (minFifter=0x2703);
				else
				(minFifter!==-1)|| (minFifter=0x2601);
				(magFifter!==-1)|| (magFifter=0x2601);
				gl.texParameteri(0x0DE1,0x2801,minFifter);
				gl.texParameteri(0x0DE1,0x2800,magFifter);
				gl.texParameteri(0x0DE1,0x2802,repeat);
				gl.texParameteri(0x0DE1,0x2803,repeat);
				this._mipmap && gl.generateMipmap(0x0DE1);
				}else {
				(minFifter!==-1)|| (minFifter=0x2601);
				(magFifter!==-1)|| (magFifter=0x2601);
				gl.texParameteri(0x0DE1,0x2801,minFifter);
				gl.texParameteri(0x0DE1,0x2800,magFifter);
				gl.texParameteri(0x0DE1,0x2802,0x812F);
				gl.texParameteri(0x0DE1,0x2803,0x812F);
			}
			(preTarget && preTexture)&& (WebGLContext.bindTexture(gl,preTarget,preTexture));
			if (isPot)
				this.memorySize=w *h *4 *(1+1 / 3);
			else
			this.memorySize=w *h *4;
		}

		/**
		*重新创建资源，如果异步创建中被强制释放再创建，则需等待释放完成后再重新加载创建。
		*/
		__proto.recreateResource=function(){
			this.startCreate();
			this._createWebGlTexture();
			this.completeCreate();
		}

		/**
		*销毁资源。
		*/
		__proto.detoryResource=function(){
			if (this._source){
				WebGL.mainContext.deleteTexture(this._source);
				this._source=null;
				this.memorySize=0;
			}
		}

		__getset(0,__proto,'source',function(){
			return _super.prototype._$get_source.call(this);
		});

		__static(SolidColorTexture2D,
		['pickTexture',function(){return this.pickTexture=new SolidColorTexture2D(new Vector4(1.0,0.0,1.0,1.0));}
		]);
		return SolidColorTexture2D;
	})(BaseTexture)


	/**
	*<code>Texture2D</code> 二维纹理。
	*/
	//class laya.d3.resource.Texture2D extends laya.d3.resource.BaseTexture
	var Texture2D=(function(_super){
		function Texture2D(src){
			this._src=null;
			this._image=null;
			this._recreateLock=false;
			this._needReleaseAgain=false;
			Texture2D.__super.call(this);
			this._src=src;
			this._image=new Browser.window.Image();
			this._image.crossOrigin="";
			var loader=new Loader();
			loader.once("complete",this,this._onTextureLoaded);
			loader.load(src,"nativeimage",false);
		}

		__class(Texture2D,'laya.d3.resource.Texture2D',_super);
		var __proto=Texture2D.prototype;
		/**
		*@private
		*/
		__proto._onTextureLoaded=function(img){
			this._image=img;
			var w=img.width;
			var h=img.height;
			this._width=w;
			this._height=h;
			this._size=new Size(w,h);
			this._loaded=true;
			this.event("loaded",this);
		}

		/**
		*@private
		*/
		__proto._createWebGlTexture=function(){
			if (!this._image){
				throw "create GLTextur err:no data:"+this._image;
			};
			var gl=WebGL.mainContext;
			var glTex=this._source=gl.createTexture();
			var w=this._width;
			var h=this._height;
			var preTarget=WebGLContext.curBindTexTarget;
			var preTexture=WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl,0x0DE1,glTex);
			gl.texImage2D(0x0DE1,0,0x1908,0x1908,0x1401,this._image);
			var minFifter=this._minFifter;
			var magFifter=this._magFifter;
			var repeat=this._repeat ? 0x2901 :0x812F;
			var isPot=Arith.isPOT(w,h);
			if (isPot){
				if (this._mipmap)
					(minFifter!==-1)|| (minFifter=0x2703);
				else
				(minFifter!==-1)|| (minFifter=0x2601);
				(magFifter!==-1)|| (magFifter=0x2601);
				gl.texParameteri(0x0DE1,0x2801,minFifter);
				gl.texParameteri(0x0DE1,0x2800,magFifter);
				gl.texParameteri(0x0DE1,0x2802,repeat);
				gl.texParameteri(0x0DE1,0x2803,repeat);
				this._mipmap && gl.generateMipmap(0x0DE1);
				}else {
				(minFifter!==-1)|| (minFifter=0x2601);
				(magFifter!==-1)|| (magFifter=0x2601);
				gl.texParameteri(0x0DE1,0x2801,minFifter);
				gl.texParameteri(0x0DE1,0x2800,magFifter);
				gl.texParameteri(0x0DE1,0x2802,0x812F);
				gl.texParameteri(0x0DE1,0x2803,0x812F);
			}
			(preTarget && preTexture)&& (WebGLContext.bindTexture(gl,preTarget,preTexture));
			this._image.onload=null;
			this._image=null;
			if (isPot)
				this.memorySize=w *h *4 *(1+1 / 3);
			else
			this.memorySize=w *h *4;
			this._recreateLock=false;
		}

		/**
		*重新创建资源，如果异步创建中被强制释放再创建，则需等待释放完成后再重新加载创建。
		*/
		__proto.recreateResource=function(){
			if (this._src==null || this._src==="")
				return;
			this._needReleaseAgain=false;
			if (!this._image){
				this._recreateLock=true;
				this.startCreate();
				var _this=this;
				this._image=new Browser.window.Image();
				this._image.crossOrigin="";
				this._image.onload=function (){
					if (_this._needReleaseAgain){
						_this._needReleaseAgain=false;
						_this._image.onload=null;
						_this._image=null;
						return;
					}
					_this._createWebGlTexture();
					_this.completeCreate();
				};
				this._image.src=this._src;
				}else {
				if (this._recreateLock){
					return;
				}
				this.startCreate();
				this._createWebGlTexture();
				this.completeCreate();
			}
		}

		/**
		*销毁资源。
		*/
		__proto.detoryResource=function(){
			if (this._recreateLock){
				this._needReleaseAgain=true;
			}
			if (this._source){
				WebGL.mainContext.deleteTexture(this._source);
				this._source=null;
				this._image=null;
				this.memorySize=0;
			}
		}

		/**
		*获取文件路径全名。
		*/
		__getset(0,__proto,'src',function(){
			return this._src;
		});

		return Texture2D;
	})(BaseTexture)


	//class laya.d3.resource.TextureCube extends laya.d3.resource.BaseTexture
	var TextureCube=(function(_super){
		function TextureCube(srcs,size){
			this._texCount=6;
			//this._loadedImgCount=0;
			//this._images=null;
			//this._srcs=null;
			this._recreateLock=false;
			this._needReleaseAgain=false;
			(size===void 0)&& (size=512);
			TextureCube.__super.call(this);
			if (srcs.length < this._texCount)
				throw new Error("srcs路径数组长度小于6！");
			this._loadedImgCount=0;
			this._srcs=srcs;
			this._width=size;
			this._height=size;
			this._images=[];
			for (var i=0;i < this._texCount;i++){
				Laya.loader.load(this._srcs[i],Handler.create(this,this._onSubCubeTextureLoaded,[i],true),null,"nativeimage",1,false);
			}
		}

		__class(TextureCube,'laya.d3.resource.TextureCube',_super);
		var __proto=TextureCube.prototype;
		__proto._onSubCubeTextureLoaded=function(index,img){
			this._images[index]=img;
			this._loadedImgCount++;
			if (this._loadedImgCount==this._texCount){
				this._loaded=true;
				this.event("loaded",this);
			}
		}

		__proto._createWebGlTexture=function(){
			var i=0;
			for (i=0;i < this._texCount;i++){
				if (!this._images[i]){
					throw "create GLTextur err:no data:"+this._images[i];
				}
			};
			var gl=WebGL.mainContext;
			var glTex=this._source=gl.createTexture();
			var w=this._width;
			var h=this._height;
			var preTarget=WebGLContext.curBindTexTarget;
			var preTexture=WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl,0x8513,glTex);
			gl.texImage2D(0x8515,0,0x1908,0x1908,0x1401,this._images[0]);
			gl.texImage2D(0x8516,0,0x1908,0x1908,0x1401,this._images[1]);
			gl.texImage2D(0x8517,0,0x1908,0x1908,0x1401,this._images[2]);
			gl.texImage2D(0x8518,0,0x1908,0x1908,0x1401,this._images[3]);
			gl.texImage2D(0x8519,0,0x1908,0x1908,0x1401,this._images[4]);
			gl.texImage2D(0x851A,0,0x1908,0x1908,0x1401,this._images[5]);
			var minFifter=this.minFifter;
			var magFifter=this.magFifter;
			var repeat=this.repeat ? 0x2901 :0x812F;
			var isPOT=Arith.isPOT(w,h);
			if (isPOT){
				if (this.mipmap)
					(minFifter!==-1)|| (minFifter=0x2703);
				else
				(minFifter!==-1)|| (minFifter=0x2601);
				(magFifter!==-1)|| (magFifter=0x2601);
				gl.texParameteri(0x8513,0x2801,minFifter);
				gl.texParameteri(0x8513,0x2800,magFifter);
				gl.texParameteri(0x8513,0x2802,repeat);
				gl.texParameteri(0x8513,0x2803,repeat);
				this.mipmap && gl.generateMipmap(0x8513);
				}else {
				(minFifter!==-1)|| (minFifter=0x2601);
				(magFifter!==-1)|| (magFifter=0x2601);
				gl.texParameteri(0x8513,0x2801,minFifter);
				gl.texParameteri(0x8513,0x2800,magFifter);
				gl.texParameteri(0x8513,0x2802,0x812F);
				gl.texParameteri(0x8513,0x2803,0x812F);
			}
			(preTarget && preTexture)&& (WebGLContext.bindTexture(gl,preTarget,preTexture));
			for (i=0;i < 6;i++){
				this._images[i].onload=null;
				this._images[i]=null;
			}
			if (isPOT)
				this.memorySize=w *h *4 *(1+1 / 3)*this._texCount;
			else
			this.memorySize=w *h *4 *this._texCount;
			this._recreateLock=false;
		}

		__proto.recreateResource=function(){
			var _$this=this;
			if (this._srcs==null)
				return;
			this._needReleaseAgain=false;
			if (!this._images[0]){
				this._recreateLock=true;
				this.startCreate();
				var _this=this;
				for (var i=0;i < this._texCount;i++){
					this._images[i]=new Browser.window.Image();
					this._images[i].crossOrigin="";
					var index=i;
					this._images[index].onload=function (){
						var j=0;
						if (_this._needReleaseAgain){
							for (j=0;j < _$this._texCount;j++)
							if (!_this._images[j].complete)
								return;
							_this._needReleaseAgain=false;
							for (j=0;j < _$this._texCount;j++){
								_this._images[j].onload=null;
								_this._images[j]=null;
							}
							return;
						}
						for (j=0;j < _$this._texCount;j++)
						if (!_this._images[j].complete)
							return;
						_this._createWebGlTexture();
						_this.completeCreate();
					};
					this._images[i].src=this._srcs[i];
				}
				}else {
				if (this._recreateLock){
					return;
				}
				this.startCreate();
				this._createWebGlTexture();
				this.completeCreate();
			}
		}

		//处理创建完成后相关操作
		__proto.detoryResource=function(){
			if (this._recreateLock){
				this._needReleaseAgain=true;
			}
			if (this._source){
				WebGL.mainContext.deleteTexture(this._source);
				this._source=null;
				this.memorySize=0;
			}
		}

		/**
		*文件路径全名。
		*/
		__getset(0,__proto,'srcs',function(){
			return this._srcs;
		});

		return TextureCube;
	})(BaseTexture)


	//class laya.webgl.utils.Buffer2D extends laya.webgl.utils.Buffer
	var Buffer2D=(function(_super){
		function Buffer2D(){
			this._maxsize=0;
			this._upload=true;
			this._uploadSize=0;
			Buffer2D.__super.call(this);
			this.lock=true;
		}

		__class(Buffer2D,'laya.webgl.utils.Buffer2D',_super);
		var __proto=Buffer2D.prototype;
		__proto._bufferData=function(){
			this._maxsize=Math.max(this._maxsize,this._byteLength);
			if (Stat.loopCount % 30==0){
				if (this._buffer.byteLength > (this._maxsize+64)){
					this.memorySize=this._buffer.byteLength;
					this._buffer=this._buffer.slice(0,this._maxsize+64);
					this._checkArrayUse();
				}
				this._maxsize=this._byteLength;
			}
			if (this._uploadSize < this._buffer.byteLength){
				this._uploadSize=this._buffer.byteLength;
				Buffer._gl.bufferData(this._bufferType,this._uploadSize,this._bufferUsage);
				this.memorySize=this._uploadSize;
			}
			Buffer._gl.bufferSubData(this._bufferType,0,this._buffer);
		}

		__proto._bufferSubData=function(offset,dataStart,dataLength){
			(offset===void 0)&& (offset=0);
			(dataStart===void 0)&& (dataStart=0);
			(dataLength===void 0)&& (dataLength=0);
			this._maxsize=Math.max(this._maxsize,this._byteLength);
			if (Stat.loopCount % 30==0){
				if (this._buffer.byteLength > (this._maxsize+64)){
					this.memorySize=this._buffer.byteLength;
					this._buffer=this._buffer.slice(0,this._maxsize+64);
					this._checkArrayUse();
				}
				this._maxsize=this._byteLength;
			}
			if (this._uploadSize < this._buffer.byteLength){
				this._uploadSize=this._buffer.byteLength;
				Buffer._gl.bufferData(this._bufferType,this._uploadSize,this._bufferUsage);
				this.memorySize=this._uploadSize;
			}
			if (dataStart || dataLength){
				var subBuffer=this._buffer.slice(dataStart,dataLength);
				Buffer._gl.bufferSubData(this._bufferType,offset,subBuffer);
				}else {
				Buffer._gl.bufferSubData(this._bufferType,offset,this._buffer);
			}
		}

		__proto._checkArrayUse=function(){}
		__proto._bind_upload=function(){
			if (!this._upload)
				return false;
			this._upload=false;
			this._bind();
			this._bufferData();
			return true;
		}

		__proto._bind_subUpload=function(offset,dataStart,dataLength){
			(offset===void 0)&& (offset=0);
			(dataStart===void 0)&& (dataStart=0);
			(dataLength===void 0)&& (dataLength=0);
			if (!this._upload)
				return false;
			this._upload=false;
			this._bind();
			this._bufferSubData(offset,dataStart,dataLength);
			return true;
		}

		__proto._resizeBuffer=function(nsz,copy){
			if (nsz < this._buffer.byteLength)
				return this;
			this.memorySize=nsz;
			if (copy && this._buffer && this._buffer.byteLength > 0){
				var newbuffer=new ArrayBuffer(nsz);
				var n=new Uint8Array(newbuffer);
				n.set(new Uint8Array(this._buffer),0);
				this._buffer=newbuffer;
			}else
			this._buffer=new ArrayBuffer(nsz);
			this._checkArrayUse();
			this._upload=true;
			return this;
		}

		__proto.append=function(data){
			this._upload=true;
			var byteLen=0,n;
			byteLen=data.byteLength;
			if ((data instanceof Uint8Array)){
				this._resizeBuffer(this._byteLength+byteLen,true);
				n=new Uint8Array(this._buffer,this._byteLength);
				}else if ((data instanceof Uint16Array)){
				this._resizeBuffer(this._byteLength+byteLen,true);
				n=new Uint16Array(this._buffer,this._byteLength);
				}else if ((data instanceof Float32Array)){
				this._resizeBuffer(this._byteLength+byteLen,true);
				n=new Float32Array(this._buffer,this._byteLength);
			}
			n.set(data,0);
			this._byteLength+=byteLen;
			this._checkArrayUse();
		}

		__proto.getBuffer=function(){
			return this._buffer;
		}

		__proto.setNeedUpload=function(){
			this._upload=true;
		}

		__proto.getNeedUpload=function(){
			return this._upload;
		}

		__proto.upload=function(){
			var scuess=this._bind_upload();
			Buffer._gl.bindBuffer(this._bufferType,null);
			Buffer._bindActive[this._bufferType]=null;
			Shader.activeShader=null
			return scuess;
		}

		__proto.subUpload=function(offset,dataStart,dataLength){
			(offset===void 0)&& (offset=0);
			(dataStart===void 0)&& (dataStart=0);
			(dataLength===void 0)&& (dataLength=0);
			var scuess=this._bind_subUpload();
			Buffer._gl.bindBuffer(this._bufferType,null);
			Buffer._bindActive[this._bufferType]=null;
			Shader.activeShader=null
			return scuess;
		}

		__proto.detoryResource=function(){
			_super.prototype.detoryResource.call(this);
			this._upload=true;
			this._uploadSize=0;
		}

		__proto.clear=function(){
			this._byteLength=0;
			this._upload=true;
		}

		__getset(0,__proto,'bufferLength',function(){
			return this._buffer.byteLength;
		});

		__getset(0,__proto,'byteLength',_super.prototype._$get_byteLength,function(value){
			if (this._byteLength===value)
				return;
			value <=this._buffer.byteLength || (this._resizeBuffer(value *2+256,true));
			this._byteLength=value;
		});

		Buffer2D.__int__=function(gl){
			IndexBuffer2D.QuadrangleIB=IndexBuffer2D.create(0x88E4);
			GlUtils.fillIBQuadrangle(IndexBuffer2D.QuadrangleIB,16);
		}

		Buffer2D.UNICOLOR="UNICOLOR";
		Buffer2D.MVPMATRIX="MVPMATRIX";
		Buffer2D.MATRIX1="MATRIX1";
		Buffer2D.MATRIX2="MATRIX2";
		Buffer2D.DIFFUSETEXTURE="DIFFUSETEXTURE";
		Buffer2D.NORMALTEXTURE="NORMALTEXTURE";
		Buffer2D.SPECULARTEXTURE="SPECULARTEXTURE";
		Buffer2D.EMISSIVETEXTURE="EMISSIVETEXTURE";
		Buffer2D.AMBIENTTEXTURE="AMBIENTTEXTURE";
		Buffer2D.REFLECTTEXTURE="REFLECTTEXTURE";
		Buffer2D.MATRIXARRAY0="MATRIXARRAY0";
		Buffer2D.FLOAT0="FLOAT0";
		Buffer2D.UVAGEX="UVAGEX";
		Buffer2D.CAMERAPOS="CAMERAPOS";
		Buffer2D.ALBEDO="ALBEDO";
		Buffer2D.ALPHATESTVALUE="ALPHATESTVALUE";
		Buffer2D.FOGCOLOR="FOGCOLOR";
		Buffer2D.FOGSTART="FOGSTART";
		Buffer2D.FOGRANGE="FOGRANGE";
		Buffer2D.MATERIALAMBIENT="MATERIALAMBIENT";
		Buffer2D.MATERIALDIFFUSE="MATERIALDIFFUSE";
		Buffer2D.MATERIALSPECULAR="MATERIALSPECULAR";
		Buffer2D.MATERIALREFLECT="MATERIALREFLECT";
		Buffer2D.LIGHTDIRECTION="LIGHTDIRECTION";
		Buffer2D.LIGHTDIRDIFFUSE="LIGHTDIRDIFFUSE";
		Buffer2D.LIGHTDIRAMBIENT="LIGHTDIRAMBIENT";
		Buffer2D.LIGHTDIRSPECULAR="LIGHTDIRSPECULAR";
		Buffer2D.POINTLIGHTPOS="POINTLIGHTPOS";
		Buffer2D.POINTLIGHTRANGE="POINTLIGHTRANGE";
		Buffer2D.POINTLIGHTATTENUATION="POINTLIGHTATTENUATION";
		Buffer2D.POINTLIGHTDIFFUSE="POINTLIGHTDIFFUSE";
		Buffer2D.POINTLIGHTAMBIENT="POINTLIGHTAMBIENT";
		Buffer2D.POINTLIGHTSPECULAR="POINTLIGHTSPECULAR";
		Buffer2D.SPOTLIGHTPOS="SPOTLIGHTPOS";
		Buffer2D.SPOTLIGHTDIRECTION="SPOTLIGHTDIRECTION";
		Buffer2D.SPOTLIGHTSPOT="SPOTLIGHTSPOT";
		Buffer2D.SPOTLIGHTRANGE="SPOTLIGHTRANGE";
		Buffer2D.SPOTLIGHTATTENUATION="SPOTLIGHTATTENUATION";
		Buffer2D.SPOTLIGHTDIFFUSE="SPOTLIGHTDIFFUSE";
		Buffer2D.SPOTLIGHTAMBIENT="SPOTLIGHTAMBIENT";
		Buffer2D.SPOTLIGHTSPECULAR="SPOTLIGHTSPECULAR";
		Buffer2D.TIME="TIME";
		Buffer2D.VIEWPORTSCALE="VIEWPORTSCALE";
		Buffer2D.CURRENTTIME="CURRENTTIME";
		Buffer2D.DURATION="DURATION";
		Buffer2D.GRAVITY="GRAVITY";
		Buffer2D.ENDVELOCITY="ENDVELOCITY";
		Buffer2D.INTENSITY="INTENSITY";
		Buffer2D.ALPHABLENDING="ALPHABLENDING";
		Buffer2D.FLOAT32=4;
		Buffer2D.SHORT=2;
		return Buffer2D;
	})(Buffer)


	/**
	*@private
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
	*<code>HTMLCanvas</code> 是 Html Canvas 的代理类，封装了 Canvas 的属性和方法。。请不要直接使用 new HTMLCanvas！
	*/
	//class laya.resource.HTMLCanvas extends laya.resource.Bitmap
	var HTMLCanvas=(function(_super){
		function HTMLCanvas(type,canvas){
			//this._ctx=null;
			this._is2D=false;
			HTMLCanvas.__super.call(this);
			var _$this=this;
			this._source=this;
			if (type==="2D" || (type==="AUTO" && !Render.isWebGL)){
				this._is2D=true;
				this._source=canvas || Browser.createElement("canvas");
				var o=this;
				o.getContext=function (contextID,other){
					if (_$this._ctx)return _$this._ctx;
					var ctx=_$this._ctx=_$this._source.getContext(contextID,other);
					if (ctx){
						ctx._canvas=o;
						if(!Render.isFlash)ctx.size=function (w,h){
						};
					}
					return ctx;
				}
			}
			else this._source={};
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

		HTMLCanvas.create=function(type,canvas){
			return new HTMLCanvas(type,canvas);
		}

		HTMLCanvas.TYPE2D="2D";
		HTMLCanvas.TYPE3D="3D";
		HTMLCanvas.TYPEAUTO="AUTO";
		HTMLCanvas._createContext=null
		return HTMLCanvas;
	})(Bitmap)


	/**
	*@private
	*/
	//class laya.particle.shader.ParticleShader extends laya.webgl.shader.Shader
	var ParticleShader=(function(_super){
		function ParticleShader(){
			ParticleShader.__super.call(this,ParticleShader.vs,ParticleShader.ps,"ParticleShader");
		}

		__class(ParticleShader,'laya.particle.shader.ParticleShader',_super);
		__static(ParticleShader,
		['vs',function(){return this.vs="attribute vec4 a_CornerTextureCoordinate;\nattribute vec3 a_Position;\nattribute vec3 a_Velocity;\nattribute vec4 a_StartColor;\nattribute vec4 a_EndColor;\nattribute vec3 a_SizeRotation;\nattribute vec2 a_Radius;\nattribute vec4 a_Radian;\nattribute float a_AgeAddScale;\nattribute float a_Time;\n\nvarying vec4 v_Color;\nvarying vec2 v_TextureCoordinate;\n\nuniform  float u_CurrentTime;\nuniform float u_Duration;\nuniform float u_EndVelocity;\nuniform vec3 u_Gravity;\n\n#ifdef PARTICLE3D\n uniform mat4 u_WorldMat;\n uniform mat4 u_View;\n uniform mat4 u_Projection;\n uniform vec2 u_ViewportScale;\n#else\n uniform vec2 size;\n uniform mat4 mmat;\n uniform mat4 u_mmat;\n#endif\n\nvec4 ComputeParticlePosition(in vec3 position, in vec3 velocity,in float age,in float normalizedAge)\n{\n\n   float startVelocity = length(velocity);//起始标量速度\n   float endVelocity = startVelocity * u_EndVelocity;//结束标量速度\n\n   float velocityIntegral = startVelocity * normalizedAge +(endVelocity - startVelocity) * normalizedAge *normalizedAge/2.0;//计算当前速度的标量（单位空间），vt=v0*t+(1/2)*a*(t^2)\n   \n   vec3 addPosition = normalize(velocity) * velocityIntegral * u_Duration;//计算受自身速度影响的位置，转换标量到矢量    \n   addPosition += u_Gravity * age * normalizedAge;//计算受重力影响的位置\n   \n   float radius=mix(a_Radius.x, a_Radius.y, normalizedAge); //计算粒子受半径和角度影响（无需计算角度和半径时，可用宏定义优化屏蔽此计算）\n   float radianHorizontal =mix(a_Radian.x,a_Radian.z,normalizedAge);\n   float radianVertical =mix(a_Radian.y,a_Radian.w,normalizedAge);\n   \n   float r =cos(radianVertical)* radius;\n   addPosition.y += sin(radianVertical) * radius;\n	\n   addPosition.x += cos(radianHorizontal) *r;\n   addPosition.z += sin(radianHorizontal) *r;\n  \n   #ifdef PARTICLE3D\n   position+=addPosition;\n    return  u_Projection*u_View*u_WorldMat*(vec4(position, 1.0));\n   #else\n   addPosition.y=-addPosition.y;//2D粒子位置更新需要取负，2D粒子坐标系Y轴正向朝上\n   position+=addPosition;\n    return  vec4(position,1.0);\n   #endif\n}\n\nfloat ComputeParticleSize(in float startSize,in float endSize, in float normalizedAge)\n{    \n    float size = mix(startSize, endSize, normalizedAge);\n    \n	#ifdef PARTICLE3D\n    //Project the size into screen coordinates.\n     return size * u_Projection[1][1];\n	#else\n	 return size;\n	#endif\n}\n\nmat2 ComputeParticleRotation(in float rot,in float age)\n{    \n    float rotation =rot * age;\n    //计算2x2旋转矩阵.\n    float c = cos(rotation);\n    float s = sin(rotation);\n    return mat2(c, -s, s, c);\n}\n\nvec4 ComputeParticleColor(in vec4 startColor,in vec4 endColor,in float normalizedAge)\n{\n	vec4 color=mix(startColor,endColor,normalizedAge);\n    //硬编码设置，使粒子淡入很快，淡出很慢,6.7的缩放因子把置归一在0到1之间，可以谷歌x*(1-x)*(1-x)*6.7的制图表\n    color.a *= normalizedAge * (1.0-normalizedAge) * (1.0-normalizedAge) * 6.7;\n   \n    return color;\n}\n\nvoid main()\n{\n   float age = u_CurrentTime - a_Time;\n   age *= 1.0 + a_AgeAddScale;\n   float normalizedAge = clamp(age / u_Duration,0.0,1.0);\n   gl_Position = ComputeParticlePosition(a_Position, a_Velocity, age, normalizedAge);//计算粒子位置\n   float pSize = ComputeParticleSize(a_SizeRotation.x,a_SizeRotation.y, normalizedAge);\n   mat2 rotation = ComputeParticleRotation(a_SizeRotation.z, age);\n	\n   #ifdef PARTICLE3D\n	gl_Position.xy += (rotation*a_CornerTextureCoordinate.xy) * pSize * u_ViewportScale;\n   #else\n    mat4 mat=u_mmat*mmat;\n    gl_Position=vec4((mat*gl_Position).xy,0.0,1.0);\n	gl_Position.xy += (rotation*a_CornerTextureCoordinate.xy) * pSize*vec2(mat[0][0],mat[1][1]);\n    gl_Position=vec4((gl_Position.x/size.x-0.5)*2.0,(0.5-gl_Position.y/size.y)*2.0,0.0,1.0);\n   #endif\n   \n   v_Color = ComputeParticleColor(a_StartColor,a_EndColor, normalizedAge);\n   v_TextureCoordinate =a_CornerTextureCoordinate.zw;\n}\n\n";},'ps',function(){return this.ps="#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nvarying vec4 v_Color;\nvarying vec2 v_TextureCoordinate;\nuniform sampler2D u_texture;\n\nvoid main()\n{	\n	gl_FragColor=texture2D(u_texture,v_TextureCoordinate)*v_Color;\n}";}
		]);
		return ParticleShader;
	})(Shader)


	//class laya.webgl.atlas.AtlasWebGLCanvas extends laya.resource.Bitmap
	var AtlasWebGLCanvas=(function(_super){
		function AtlasWebGLCanvas(){
			this._flashCacheImage=null;
			this._flashCacheImageNeedFlush=false;
			AtlasWebGLCanvas.__super.call(this);
		}

		__class(AtlasWebGLCanvas,'laya.webgl.atlas.AtlasWebGLCanvas',_super);
		var __proto=AtlasWebGLCanvas.prototype;
		/***重新创建资源*/
		__proto.recreateResource=function(){
			this.startCreate();
			var gl=WebGL.mainContext;
			var glTex=this._source=gl.createTexture();
			var preTarget=WebGLContext.curBindTexTarget;
			var preTexture=WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl,0x0DE1,glTex);
			gl.texImage2D(0x0DE1,0,0x1908,this._w,this._h,0,0x1908,0x1401,null);
			gl.texParameteri(0x0DE1,0x2801,0x2601);
			gl.texParameteri(0x0DE1,0x2800,0x2601);
			gl.texParameteri(0x0DE1,0x2802,0x812F);
			gl.texParameteri(0x0DE1,0x2803,0x812F);
			(preTarget && preTexture)&& (WebGLContext.bindTexture(gl,preTarget,preTexture));
			this.memorySize=this._w *this._h *4;
			this.completeCreate();
		}

		/***销毁资源*/
		__proto.detoryResource=function(){
			if (this._source){
				WebGL.mainContext.deleteTexture(this._source);
				this._source=null;
				this.memorySize=0;
			}
		}

		/**采样image到WebGLTexture的一部分*/
		__proto.texSubImage2D=function(xoffset,yoffset,bitmap){
			if (!Render.isFlash){
				var gl=WebGL.mainContext;
				var preTarget=WebGLContext.curBindTexTarget;
				var preTexture=WebGLContext.curBindTexValue;
				WebGLContext.bindTexture(gl,0x0DE1,this._source);
				(xoffset-1 >=0)&& (gl.texSubImage2D(0x0DE1,0,xoffset-1,yoffset,0x1908,0x1401,bitmap));
				(xoffset+1 <=this._w)&& (gl.texSubImage2D(0x0DE1,0,xoffset+1,yoffset,0x1908,0x1401,bitmap));
				(yoffset-1 >=0)&& (gl.texSubImage2D(0x0DE1,0,xoffset,yoffset-1,0x1908,0x1401,bitmap));
				(yoffset+1 <=this._h)&& (gl.texSubImage2D(0x0DE1,0,xoffset,yoffset+1,0x1908,0x1401,bitmap));
				gl.texSubImage2D(0x0DE1,0,xoffset,yoffset,0x1908,0x1401,bitmap);
				(preTarget && preTexture)&& (WebGLContext.bindTexture(gl,preTarget,preTexture));
				}else {
				if (!this._flashCacheImage){
					this._flashCacheImage=HTMLImage.create(null);
					this._flashCacheImage.image.createCanvas(this._w,this._h);
				};
				var bmData=bitmap.bitmapdata;
				(xoffset-1 >=0)&& (this._flashCacheImage.image.copyPixels(bmData,0,0,bmData.width-1,bmData.height,xoffset,yoffset));
				(xoffset+1 <=this._w)&& (this._flashCacheImage.image.copyPixels(bmData,0,0,bmData.width+1,bmData.height,xoffset,yoffset));
				(yoffset-1 >=0)&& (this._flashCacheImage.image.copyPixels(bmData,0,0,bmData.width,bmData.height-1,xoffset,yoffset));
				(yoffset+1 <=this._h)&& (this._flashCacheImage.image.copyPixels(bmData,0,0,bmData.width+1,bmData.height,xoffset,yoffset));
				this._flashCacheImage.image.copyPixels(bmData,0,0,bmData.width,bmData.height,xoffset,yoffset);
				(this._flashCacheImageNeedFlush)|| (this._flashCacheImageNeedFlush=true);
			}
		}

		/**采样image到WebGLTexture的一部分*/
		__proto.texSubImage2DPixel=function(xoffset,yoffset,width,height,pixel){
			var gl=WebGL.mainContext;
			var preTarget=WebGLContext.curBindTexTarget;
			var preTexture=WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl,0x0DE1,this._source);
			var pixels=new Uint8Array(pixel.data);
			gl.texSubImage2D(0x0DE1,0,xoffset,yoffset,width,height,0x1908,0x1401,pixels);
			(preTarget && preTexture)&& (WebGLContext.bindTexture(gl,preTarget,preTexture));
		}

		/***
		*设置图片宽度
		*@param value 图片宽度
		*/
		__getset(0,__proto,'width',_super.prototype._$get_width,function(value){
			this._w=value;
		});

		/***
		*设置图片高度
		*@param value 图片高度
		*/
		__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
			this._h=value;
		});

		return AtlasWebGLCanvas;
	})(Bitmap)


	//class laya.webgl.resource.WebGLCharImage extends laya.resource.Bitmap
	var WebGLCharImage=(function(_super){
		function WebGLCharImage(canvas,char){
			this.borderSize=12;
			//this._ctx=null;
			//this._allowMerageInAtlas=false;
			//this._enableMerageInAtlas=false;
			//this.canvas=null;
			//this.char=null;
			WebGLCharImage.__super.call(this);
			this.canvas=canvas;
			this.char=char;
			this._enableMerageInAtlas=true;
			var bIsConchApp=Render.isConchApp;
			if (bIsConchApp){
				this._ctx=canvas;
				}else {
				this._ctx=canvas.getContext('2d',undefined);
			};
			var xs=char.xs,ys=char.ys;
			var t=null;
			if (bIsConchApp){
				this._ctx.font=char.font;
				t=this._ctx.measureText(char.char);
				char.width=t.width *xs;
				char.height=t.height *ys;
				}else {
				t=Utils.measureText(char.char,char.font);
				char.width=t.width *xs;
				char.height=t.height *ys;
			}
			this.onresize(char.width+this.borderSize *2,char.height+this.borderSize *2);
		}

		__class(WebGLCharImage,'laya.webgl.resource.WebGLCharImage',_super);
		var __proto=WebGLCharImage.prototype;
		Laya.imps(__proto,{"laya.webgl.resource.IMergeAtlasBitmap":true})
		__proto.recreateResource=function(){
			this.startCreate();
			var char=this.char;
			var bIsConchApp=Render.isConchApp;
			var xs=char.xs,ys=char.ys;
			this.onresize(char.width+this.borderSize *2,char.height+this.borderSize *2);
			this.canvas && (this.canvas.height=this._h,this.canvas.width=this._w);
			if (bIsConchApp){
				var nFontSize=char.fontSize;
				if (xs !=1 || ys !=1){
					nFontSize=parseInt(nFontSize *((xs > ys)? xs :ys)+"");
				};
				var sFont="normal 100 "+nFontSize+"px Arial";
				if (char.borderColor){
					sFont+=" 1 "+char.borderColor;
				}
				this._ctx.font=sFont;
				this._ctx.textBaseline="top";
				this._ctx.fillStyle=char.fillColor;
				this._ctx.fillText(char.char,this.borderSize,this.borderSize,null,null,null);
				}else {
				this._ctx.save();
				(this._ctx).clearRect(0,0,char.width+this.borderSize *2,char.height+this.borderSize *2);
				this._ctx.font=char.font;
				this._ctx.textBaseline="top";
				this._ctx.translate(this.borderSize,this.borderSize);
				if (xs !=1 || ys !=1){
					this._ctx.scale(xs,ys);
				}
				if (char.fillColor && char.borderColor){
					this._ctx.strokeStyle=char.borderColor;
					this._ctx.lineWidth=char.lineWidth;
					this._ctx.strokeText(char.char,0,0,null,null,0,null);
					this._ctx.fillStyle=char.fillColor;
					this._ctx.fillText(char.char,0,0,null,null,null);
					}else {
					if (char.lineWidth===-1){
						this._ctx.fillStyle=char.fillColor ? char.fillColor :"white";
						this._ctx.fillText(char.char,0,0,null,null,null);
						}else {
						this._ctx.strokeStyle=char.borderColor?char.borderColor:'white';
						this._ctx.lineWidth=char.lineWidth;
						this._ctx.strokeText(char.char,0,0,null,null,0,null);
					}
				}
				this._ctx.restore();
			}
			char.borderSize=this.borderSize;
			this.completeCreate();
		}

		__proto.onresize=function(w,h){
			this._w=w;
			this._h=h;
			if ((this._w < AtlasResourceManager.atlasLimitWidth && this._h < AtlasResourceManager.atlasLimitHeight)){
				this._allowMerageInAtlas=true
				}else {
				this._allowMerageInAtlas=false;
				throw new Error("文字尺寸超出大图合集限制！");
			}
		}

		__proto.clearAtlasSource=function(){}
		/**
		*是否创建私有Source
		*@return 是否创建
		*/
		__getset(0,__proto,'allowMerageInAtlas',function(){
			return this._allowMerageInAtlas;
		});

		__getset(0,__proto,'atlasSource',function(){
			return this.canvas;
		});

		/**
		*是否创建私有Source,通常禁止修改
		*@param value 是否创建
		*/
		/**
		*是否创建私有Source
		*@return 是否创建
		*/
		__getset(0,__proto,'enableMerageInAtlas',function(){
			return this._enableMerageInAtlas;
			},function(value){
			this._enableMerageInAtlas=value;
		});

		return WebGLCharImage;
	})(Bitmap)


	//class laya.webgl.resource.WebGLRenderTarget extends laya.resource.Bitmap
	var WebGLRenderTarget=(function(_super){
		function WebGLRenderTarget(width,height,surfaceFormat,surfaceType,depthStencilFormat,mipMap,repeat,minFifter,magFifter){
			//this._frameBuffer=null;
			//this._depthStencilBuffer=null;
			//this._surfaceFormat=0;
			//this._surfaceType=0;
			//this._depthStencilFormat=0;
			//this._mipMap=false;
			//this._repeat=false;
			//this._minFifter=0;
			//this._magFifter=0;
			(surfaceFormat===void 0)&& (surfaceFormat=0x1908);
			(surfaceType===void 0)&& (surfaceType=0x1401);
			(depthStencilFormat===void 0)&& (depthStencilFormat=0x81A5);
			(mipMap===void 0)&& (mipMap=false);
			(repeat===void 0)&& (repeat=false);
			(minFifter===void 0)&& (minFifter=-1);
			(magFifter===void 0)&& (magFifter=1);
			WebGLRenderTarget.__super.call(this);
			this._w=width;
			this._h=height;
			this._surfaceFormat=surfaceFormat;
			this._surfaceType=surfaceType;
			this._depthStencilFormat=depthStencilFormat;
			this._mipMap=mipMap;
			this._repeat=repeat;
			this._minFifter=minFifter;
			this._magFifter=magFifter;
		}

		__class(WebGLRenderTarget,'laya.webgl.resource.WebGLRenderTarget',_super);
		var __proto=WebGLRenderTarget.prototype;
		__proto.recreateResource=function(){
			this.startCreate();
			var gl=WebGL.mainContext;
			this._frameBuffer || (this._frameBuffer=gl.createFramebuffer());
			this._source || (this._source=gl.createTexture());
			var preTarget=WebGLContext.curBindTexTarget;
			var preTexture=WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl,0x0DE1,this._source);
			gl.texImage2D(0x0DE1,0,0x1908,this._w,this._h,0,this._surfaceFormat,this._surfaceType,null);
			var minFifter=this._minFifter;
			var magFifter=this._magFifter;
			var repeat=this._repeat ? 0x2901 :0x812F;
			var isPot=Arith.isPOT(this._w,this._h);
			if (isPot){
				if (this._mipMap)
					(minFifter!==-1)|| (minFifter=0x2703);
				else
				(minFifter!==-1)|| (minFifter=0x2601);
				(magFifter!==-1)|| (magFifter=0x2601);
				gl.texParameteri(0x0DE1,0x2801,minFifter);
				gl.texParameteri(0x0DE1,0x2800,magFifter);
				gl.texParameteri(0x0DE1,0x2802,repeat);
				gl.texParameteri(0x0DE1,0x2803,repeat);
				this._mipMap && gl.generateMipmap(0x0DE1);
				}else {
				(minFifter!==-1)|| (minFifter=0x2601);
				(magFifter!==-1)|| (magFifter=0x2601);
				gl.texParameteri(0x0DE1,0x2801,minFifter);
				gl.texParameteri(0x0DE1,0x2800,magFifter);
				gl.texParameteri(0x0DE1,0x2802,0x812F);
				gl.texParameteri(0x0DE1,0x2803,0x812F);
			}
			gl.bindFramebuffer(0x8D40,this._frameBuffer);
			gl.framebufferTexture2D(0x8D40,0x8CE0,0x0DE1,this._source,0);
			if (this._depthStencilFormat){
				this._depthStencilBuffer || (this._depthStencilBuffer=gl.createRenderbuffer());
				gl.bindRenderbuffer(0x8D41,this._depthStencilBuffer);
				gl.renderbufferStorage(0x8D41,this._depthStencilFormat,this._w,this._h);
				switch (this._depthStencilFormat){
					case 0x81A5:
						gl.framebufferRenderbuffer(0x8D40,0x8D00,0x8D41,this._depthStencilBuffer);
						break ;
					case 0x8D48:
						gl.framebufferRenderbuffer(0x8D40,0x8D20,0x8D41,this._depthStencilBuffer);
						break ;
					case 0x84F9:
						gl.framebufferRenderbuffer(0x8D40,0x821A,0x8D41,this._depthStencilBuffer);
						break ;
					}
			}
			gl.bindFramebuffer(0x8D40,null);
			(preTarget && preTexture)&& (WebGLContext.bindTexture(gl,preTarget,preTexture));
			gl.bindRenderbuffer(0x8D41,null);
			this.memorySize=this._w *this._h *4;
			this.completeCreate();
		}

		__proto.detoryResource=function(){
			if (this._frameBuffer){
				WebGL.mainContext.deleteTexture(this._source);
				WebGL.mainContext.deleteFramebuffer(this._frameBuffer);
				WebGL.mainContext.deleteRenderbuffer(this._depthStencilBuffer);
				this._source=null;
				this._frameBuffer=null;
				this._depthStencilBuffer=null;
				this.memorySize=0;
			}
		}

		__getset(0,__proto,'frameBuffer',function(){
			return this._frameBuffer;
		});

		__getset(0,__proto,'depthStencilBuffer',function(){
			return this._depthStencilBuffer;
		});

		return WebGLRenderTarget;
	})(Bitmap)


	//class laya.webgl.shader.d2.Shader2X extends laya.webgl.shader.Shader
	var Shader2X=(function(_super){
		function Shader2X(vs,ps,saveName,nameMap){
			this._params2dQuick1=null;
			this._params2dQuick2=null;
			this._shaderValueWidth=NaN;
			this._shaderValueHeight=NaN;
			Shader2X.__super.call(this,vs,ps,saveName,nameMap);
		}

		__class(Shader2X,'laya.webgl.shader.d2.Shader2X',_super);
		var __proto=Shader2X.prototype;
		__proto.upload2dQuick1=function(shaderValue){
			this.upload(shaderValue,this._params2dQuick1 || this._make2dQuick1());
		}

		__proto._make2dQuick1=function(){
			if (!this._params2dQuick1){
				this.activeResource();
				this._params2dQuick1=[];
				var params=this._params,one;
				for (var i=0,n=params.length;i < n;i++){
					one=params[i];
					if (!Render.isFlash && (one.name==="size" || one.name==="mmat" || one.name==="position" || one.name==="texcoord"))continue ;
					this._params2dQuick1.push(one);
				}
			}
			return this._params2dQuick1;
		}

		__proto.detoryResource=function(){
			_super.prototype.detoryResource.call(this);
			this._params2dQuick1=null;
			this._params2dQuick2=null;
		}

		__proto.upload2dQuick2=function(shaderValue){
			this.upload(shaderValue,this._params2dQuick2 || this._make2dQuick2());
		}

		__proto._make2dQuick2=function(){
			if (!this._params2dQuick2){
				this.activeResource();
				this._params2dQuick2=[];
				var params=this._params,one;
				for (var i=0,n=params.length;i < n;i++){
					one=params[i];
					if (!Render.isFlash && (one.name==="size"))continue ;
					this._params2dQuick2.push(one);
				}
			}
			return this._params2dQuick2;
		}

		Shader2X.create=function(vs,ps,saveName,nameMap){
			return new Shader2X(vs,ps,saveName,nameMap);
		}

		return Shader2X;
	})(Shader)


	//class laya.webgl.shader.d2.value.TextSV extends laya.webgl.shader.d2.value.TextureSV
	var TextSV=(function(_super){
		function TextSV(args){
			TextSV.__super.call(this,0x40);
			this.defines.add(0x40);
		}

		__class(TextSV,'laya.webgl.shader.d2.value.TextSV',_super);
		var __proto=TextSV.prototype;
		__proto.release=function(){
			TextSV.pool[TextSV._length++]=this;
			this.clear();
		}

		__proto.clear=function(){
			_super.prototype.clear.call(this);
		}

		TextSV.create=function(){
			if (TextSV._length)return TextSV.pool[--TextSV._length];
			else return new TextSV(null);
		}

		TextSV.pool=[];
		TextSV._length=0;
		return TextSV;
	})(TextureSV)


	/**
	*<code>Scene</code> 类用于实现普通场景。
	*/
	//class laya.d3.core.scene.Scene extends laya.d3.core.scene.BaseScene
	var Scene=(function(_super){
		/**
		*创建一个 <code>Scene</code> 实例。
		*/
		function Scene(){
			Scene.__super.call(this);
		}

		__class(Scene,'laya.d3.core.scene.Scene',_super);
		var __proto=Scene.prototype;
		__proto.renderCamera=function(gl,state,camera){
			this._prepareScene(gl,camera,state);
			this.beforeUpate(state);
			this._updateScene(state);
			this.lateUpate(state);
			this.beforeRender(state);
			var renderTarget=camera.renderTarget;
			if (renderTarget){
				renderTarget.start();
				Matrix4x4.multiply(this._invertYScaleMatrix,camera.projectionMatrix,this._invertYProjectionMatrix);
				Matrix4x4.multiply(this._invertYScaleMatrix,camera.projectionViewMatrix,this._invertYProjectionViewMatrix);
				state.projectionMatrix=this._invertYProjectionMatrix;
				state.projectionViewMatrix=this._invertYProjectionViewMatrix;
				}else {
				state.projectionMatrix=camera.projectionMatrix;
				state.projectionViewMatrix=camera.projectionViewMatrix;
			}
			state.viewMatrix=camera.viewMatrix;
			state.viewport=camera.viewport;
			this._preRenderScene(gl,state);
			this._clear(gl,state);
			this._renderScene(gl,state);
			this.lateRender(state);
			(renderTarget)&& (renderTarget.end());
		}

		/**
		*@private
		*/
		__proto.renderSubmit=function(){
			var gl=WebGL.mainContext;
			var state=this._renderState;
			this._set3DRenderConfig(gl);
			for (var i=0,n=this._cameraPool.length;i < n;i++){
				var camera=this._cameraPool [i];
				if (camera.enable)
					this.renderCamera(gl,state,camera);
			}
			this._set2DRenderConfig(gl);
			return 1;
		}

		return Scene;
	})(BaseScene)


	/**
	*<code>Camera</code> 类用于创建摄像机。
	*/
	//class laya.d3.core.Camera extends laya.d3.core.BaseCamera
	var Camera=(function(_super){
		function Camera(aspectRatio,nearPlane,farPlane){
			//this._aspectRatio=NaN;
			//this._viewport=null;
			//this._normalizedViewport=null;
			//this._viewMatrix=null;
			//this._projectionMatrix=null;
			//this._projectionViewMatrix=null;
			(aspectRatio===void 0)&& (aspectRatio=0);
			(nearPlane===void 0)&& (nearPlane=0.1);
			(farPlane===void 0)&& (farPlane=1000);
			this._viewMatrix=new Matrix4x4();
			this._projectionMatrix=new Matrix4x4();
			this._projectionViewMatrix=new Matrix4x4();
			this._viewport=new Viewport(0,0,0,0);
			this._normalizedViewport=new Viewport(0,0,1,1);
			this._aspectRatio=aspectRatio;
			Camera.__super.call(this,nearPlane,farPlane);
		}

		__class(Camera,'laya.d3.core.Camera',_super);
		var __proto=Camera.prototype;
		/**
		*@private
		*计算投影矩阵。
		*/
		__proto._calculateProjectionMatrix=function(){
			if (!this._useUserProjectionMatrix){
				if (this.orthographicProjection){
					var halfWidth=this.orthographicVerticalSize *this.aspectRatio *0.5;
					var halfHeight=this.orthographicVerticalSize *0.5;
					Matrix4x4.createOrthogonal(-halfWidth,halfWidth,-halfHeight,halfHeight,this.nearPlane,this.farPlane,this._projectionMatrix);
					}else {
					Matrix4x4.createPerspective(3.1416 *this.fieldOfView / 180.0,this.aspectRatio,this.nearPlane,this.farPlane,this._projectionMatrix);
				}
			}
			this._projectionMatrixModifyID+=0.01 / this.id;
		}

		/**
		*计算从屏幕空间生成的射线。
		*@param point 屏幕空间的位置位置。
		*@return out 输出射线。
		*/
		__proto.viewportPointToRay=function(point,out){
			Picker.calculateCursorRay(point,this.viewport,this._projectionMatrix,this.viewMatrix,null,out);
		}

		/**
		*计算从裁切空间生成的射线。
		*@param point 裁切空间的位置。。
		*@return out 输出射线。
		*/
		__proto.normalizedViewportPointToRay=function(point,out){
			var finalPoint=Camera._tempVector2;
			var vp=this.viewport;
			var nVpPosE=point.elements;
			var vpPosE=finalPoint.elements;
			vpPosE[0]=nVpPosE[0] *vp.width;
			vpPosE[1]=nVpPosE[1] *vp.height;
			Picker.calculateCursorRay(finalPoint,this.viewport,this._projectionMatrix,this.viewMatrix,null,out);
		}

		/**
		*计算从世界空间准换三维坐标到屏幕空间。
		*@param position 世界空间的位置。
		*@return out 输出位置。
		*/
		__proto.worldToViewportPoint=function(position,out){
			Matrix4x4.multiply(this._projectionMatrix,this._viewMatrix,this._projectionViewMatrix);
			this.viewport.project(position,this._projectionViewMatrix,out);
			if (out.z < 0.0 || out.z > 1.0){
				var outE=out.elements;
				outE[0]=outE[1]=outE[2]=NaN;
			}
		}

		/**
		*计算从世界空间准换三维坐标到裁切空间。
		*@param position 世界空间的位置。
		*@return out 输出位置。
		*/
		__proto.worldToNormalizedViewportPoint=function(position,out){
			Matrix4x4.multiply(this._projectionMatrix,this._viewMatrix,this._projectionViewMatrix);
			this.normalizedViewport.project(position,this._projectionViewMatrix,out);
			if (out.z < 0.0 || out.z > 1.0){
				var outE=out.elements;
				outE[0]=outE[1]=outE[2]=NaN;
			}
		}

		/**
		*设置横纵比。
		*@param value 横纵比。
		*/
		/**
		*获取横纵比。
		*@return 横纵比。
		*/
		__getset(0,__proto,'aspectRatio',function(){
			if (this._aspectRatio===0){
				var vp=this.viewport;
				return vp.width / vp.height;
			}
			return this._aspectRatio;
			},function(value){
			if (value < 0)
				throw new Error("Camera: the aspect ratio has to be a positive real number.");
			this._aspectRatio=value;
			this._calculateProjectionMatrix();
		});

		/**
		*设置裁剪空间的视口。
		*@return 裁剪空间的视口。
		*/
		/**
		*获取裁剪空间的视口。
		*@return 裁剪空间的视口。
		*/
		__getset(0,__proto,'normalizedViewport',function(){
			if (!this._viewportExpressedInClipSpace){
				var vp=this._viewport;
				var size=this.renderTargetSize;
				var sizeW=size.width;
				var sizeH=size.height;
				this._normalizedViewport.x=vp.x / sizeW;
				this._normalizedViewport.y=vp.y / sizeH;
				this._normalizedViewport.width=vp.width / sizeW;
				this._normalizedViewport.height=vp.height / sizeH;
			}
			return this._normalizedViewport;
			},function(value){
			if (value.x < 0 || value.y < 0 || (value.x+value.width)> 1 || (value.x+value.height)> 1)
				throw new Error("Camera: viewport size invalid.","value");
			this._viewportExpressedInClipSpace=true;
			this._normalizedViewport=value;
			this._calculateProjectionMatrix();
		});

		/**
		*设置屏幕空间的视口。
		*@param 屏幕空间的视口。
		*/
		/**
		*获取屏幕空间的视口。
		*@return 屏幕空间的视口。
		*/
		__getset(0,__proto,'viewport',function(){
			if (this._viewportExpressedInClipSpace){
				var nVp=this._normalizedViewport;
				var size=this.renderTargetSize;
				var sizeW=size.width;
				var sizeH=size.height;
				this._viewport.x=nVp.x *sizeW;
				this._viewport.y=nVp.y *sizeH;
				this._viewport.width=nVp.width *sizeW;
				this._viewport.height=nVp.height *sizeH;
			}
			return this._viewport;
			},function(value){
			if (this.renderTarget !=null && (value.x < 0 || value.y < 0 || value.width==0 || value.height==0))
				throw new Error("Camera: viewport size invalid.","value");
			this._viewportExpressedInClipSpace=false;
			this._viewport=value;
			this._calculateProjectionMatrix();
		});

		__getset(0,__proto,'needViewport',function(){
			var nVp=this.normalizedViewport;
			return nVp.x===0 && nVp.y===0 && nVp.width===1 && nVp.height===1;
		});

		/**
		*获取视图矩阵。
		*@return 视图矩阵。
		*/
		__getset(0,__proto,'viewMatrix',function(){
			this.transform.worldMatrix.invert(this._viewMatrix);
			return this._viewMatrix;
		});

		/**设置投影矩阵。*/
		/**获取投影矩阵。*/
		__getset(0,__proto,'projectionMatrix',function(){
			return this._projectionMatrix;
			},function(value){
			this._projectionMatrix=value;
			this._useUserProjectionMatrix=true;
		});

		/**
		*获取视图投影矩阵。
		*@return 视图投影矩阵。
		*/
		__getset(0,__proto,'projectionViewMatrix',function(){
			Matrix4x4.multiply(this.projectionMatrix,this.viewMatrix,this._projectionViewMatrix);
			return this._projectionViewMatrix;
		});

		__static(Camera,
		['_tempVector2',function(){return this._tempVector2=new Vector2();}
		]);
		return Camera;
	})(BaseCamera)


	/**
	*<p><code>Input</code> 类用于创建显示对象以显示和输入文本。</p>
	*/
	//class laya.display.Input extends laya.display.Text
	var Input=(function(_super){
		function Input(){
			this._focus=false;
			this._multiline=false;
			this._editable=true;
			this._restrictPattern=null;
			this._type="text";
			this._prompt='';
			this._promptColor="#A9A9A9";
			this._originColor="#000000";
			this._content='';
			Input.__super.call(this);
			this._maxChars=1E5;
			this._width=100;
			this._height=20;
			this.multiline=false;
			this.overflow=Text.SCROLL;
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

		/**@private */
		__proto._onUnDisplay=function(e){
			this.focus=false;
		}

		/**@private */
		__proto._onMouseDown=function(e){
			this.focus=true;
			Laya.stage.on("mousedown",this,this._checkBlur);
		}

		/**@private */
		__proto._checkBlur=function(e){
			if (e.nativeEvent.target !=laya.display.Input.input && e.nativeEvent.target !=laya.display.Input.area && e.target !=this)
				this.focus=false;
		}

		/**@inheritDoc*/
		__proto.render=function(context,x,y){
			laya.display.Sprite.prototype.render.call(this,context,x,y);
		}

		/**
		*在输入期间，如果 Input 实例的位置改变，调用该方法同步输入框的位置。
		*/
		__proto._syncInputTransform=function(){
			var style=this.nativeInput.style;
			var stage=Laya.stage;
			var rec;
			rec=Utils.getGlobalPosAndScale(this);
			var m=stage._canvasTransform.clone();
			var tm=m.clone();
			tm.rotate(-Math.PI / 180 *Laya.stage.canvasDegree);
			tm.scale(Laya.stage.clientScaleX,Laya.stage.clientScaleY);
			var perpendicular=(Laya.stage.canvasDegree % 180 !=0);
			var sx=perpendicular ? tm.d :tm.a;
			var sy=perpendicular ? tm.a :tm.d;
			tm.destroy();
			var tx=this.padding[3];
			var ty=this.padding[0];
			if (Laya.stage.canvasDegree==0){
				tx+=rec.x;
				ty+=rec.y;
				tx *=sx;
				ty *=sy;
				tx+=m.tx;
				ty+=m.ty;
				}else if (Laya.stage.canvasDegree==90){
				tx+=rec.y;
				ty+=rec.x;
				tx *=sx;
				ty *=sy;
				tx=m.tx-tx;
				ty+=m.ty;
				}else{
				tx+=rec.y;
				ty+=rec.x;
				tx *=sx;
				ty *=sy;
				tx+=m.tx;
				ty=m.ty-ty;
			};
			var quarter=0.785;
			var r=Math.atan2(rec.height,rec.width)-quarter;
			var sin=Math.sin(r),cos=Math.cos(r);
			var tsx=cos *rec.width+sin *rec.height;
			var tsy=cos *rec.height-sin *rec.width;
			sx *=(perpendicular ? tsy :tsx);
			sy *=(perpendicular ? tsx :tsy);
			m.tx=0;
			m.ty=0;
			r *=180 / 3.1415;
			Input.inputContainer.style.transform="scale("+sx+","+sy+") rotate("+(Laya.stage.canvasDegree+r)+"deg)";
			Input.inputContainer.style.webkitTransform="scale("+sx+","+sy+") rotate("+(Laya.stage.canvasDegree+r)+"deg)";
			Input.inputContainer.setPos(tx,ty);
			m.destroy();
			var inputWid=this._width-this.padding[1]-this.padding[3];
			var inputHei=this._height-this.padding[0]-this.padding[2];
			this.nativeInput.setSize(inputWid,inputHei);
			if (!this._getVisible())this.focus=false;
			if (Render.isConchApp){
				this.nativeInput.setPos(tx,ty);
				this.nativeInput.setScale(sx,sy);
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

		/**@private 设置输入法（textarea或input）*/
		__proto._setInputMethod=function(){
			Input.input.parentElement && (Input.inputContainer.removeChild(Input.input));
			Input.area.parentElement && (Input.inputContainer.removeChild(Input.area));
			Input.inputElement=(this._multiline ? Input.area :Input.input);
			Input.inputContainer.appendChild(Input.inputElement);
		}

		/**@private */
		__proto._focusIn=function(){
			laya.display.Input.isInputting=true;
			var input=this.nativeInput;
			this._focus=true;
			var cssStyle=input.style;
			cssStyle.whiteSpace=(this.wordWrap ? "pre-wrap" :"nowrap");
			this._setPromptColor();
			input.readOnly=!this._editable;
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
			input.setFontFace(this.font);
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
				_super.prototype._$set_text.call(this,this._prompt);
				_super.prototype._$set_color.call(this,this._promptColor);
				}else {
				_super.prototype._$set_text.call(this,this._content);
				_super.prototype._$set_color.call(this,this._originColor);
			}
			Laya.stage.off("keydown",this,this._onKeyDown);
			Laya.stage.focus=null;
			this.event("blur");
			if (Render.isConchApp)this.nativeInput.blur();
			Browser.onPC && Laya.timer.clear(this,this._syncInputTransform);
			Laya.stage.off("mousedown",this,this._checkBlur);
		}

		/**@private */
		__proto._onKeyDown=function(e){
			if (e.keyCode===13){
				if (Browser.onMobile && !this._multiline)
					this.focus=false;
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

		/**表示是否是多行输入框。*/
		__getset(0,__proto,'multiline',function(){
			return this._multiline;
			},function(value){
			this._multiline=value;
			this.valign=value ? "top" :"middle";
		});

		/**@inheritDoc */
		__getset(0,__proto,'color',_super.prototype._$get_color,function(value){
			if (this._focus)
				this.nativeInput.setColor(value);
			_super.prototype._$set_color.call(this,this._content?value:this._promptColor);
			this._originColor=value;
		});

		/**
		*设置输入提示符颜色。
		*/
		__getset(0,__proto,'promptColor',function(){
			return this._promptColor;
			},function(value){
			this._promptColor=value;
			if (!this._content)_super.prototype._$set_color.call(this,value);
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
			var input=this.nativeInput;
			if (this._focus!==value){
				if (value){
					input.target && (input.target.focus=false);
					input.target=this;
					this._setInputMethod();
					this._focusIn();
					}else {
					input.target=null;
					this._focusOut();
					if (Render.isConchApp){
						input.setPos(-10000,-10000);
					}else if (Input.inputContainer.contains(input))
					Input.inputContainer.removeChild(input);
				}
			}
		});

		/**@inheritDoc */
		__getset(0,__proto,'text',function(){
			if (this._focus)
				return this.nativeInput.value;
			else
			return this._content || "";
			},function(value){
			_super.prototype._$set_color.call(this,this._originColor);
			value+='';
			if (this._focus){
				this.nativeInput.value=value || '';
				this.event("change");
				}else {
				if (!this._multiline)
					value=value.replace(/\r?\n/g,'');
				this._content=value;
				if (value)
					_super.prototype._$set_text.call(this,value);
				else {
					_super.prototype._$set_text.call(this,this._prompt);
					_super.prototype._$set_color.call(this,this.promptColor);
				}
			}
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

		/**
		*设置输入提示符。
		*/
		__getset(0,__proto,'prompt',function(){
			return this._prompt;
			},function(value){
			if (!this._text && value)
				_super.prototype._$set_color.call(this,this._promptColor);
			this.promptColor=this._promptColor;
			if (this._text)
				_super.prototype._$set_text.call(this,(this._text==this._prompt)?value:this._text);
			else
			_super.prototype._$set_text.call(this,value);
			this._prompt=value;
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

		//[Deprecated]
		__getset(0,__proto,'inputElementYAdjuster',function(){
			console.warn("deprecated: 由于即使设置了该值，在各平台和浏览器之间也不一定一致，inputElementYAdjuster已弃用。");
			return 0;
			},function(value){
			console.warn("deprecated: 由于即使设置了该值，在各平台和浏览器之间也不一定一致，inputElementYAdjuster已弃用。");
		});

		/**
		*输入框类型为Input静态常量之一。
		*平台兼容性参见http://www.w3school.com.cn/html5/html_5_form_input_types.asp。
		*/
		__getset(0,__proto,'type',function(){
			return this._type;
			},function(value){
			if (value=="password")
				this._getCSSStyle().password=true;
			else
			this._getCSSStyle().password=false;
			this._type=value;
		});

		//[Deprecated]
		__getset(0,__proto,'inputElementXAdjuster',function(){
			console.warn("deprecated: 由于即使设置了该值，在各平台和浏览器之间也不一定一致，inputElementXAdjuster已弃用。");
			return 0;
			},function(value){
			console.warn("deprecated: 由于即使设置了该值，在各平台和浏览器之间也不一定一致，inputElementXAdjuster已弃用。");
		});

		//[Deprecated(replacement="Input.type")]
		__getset(0,__proto,'asPassword',function(){
			return this._getCSSStyle().password;
			},function(value){
			this._getCSSStyle().password=value;
			this._type="password";
			console.warn("deprecated: 使用type=\"password\"替代设置asPassword, asPassword将在下次重大更新时删去");
			this.isChanged=true;
		});

		Input.__init__=function(){
			Input._createInputElement();
			if (Browser.onMobile)
				Render.canvas.addEventListener(Input.IOS_IFRAME ? "click" :"touchend",Input._popupInputMethod);
		}

		Input._popupInputMethod=function(e){
			if (!laya.display.Input.isInputting)return;
			var input=laya.display.Input.inputElement;
			input.focus();
		}

		Input._createInputElement=function(){
			Input._initInput(Input.area=Browser.createElement("textarea"));
			Input._initInput(Input.input=Browser.createElement("input"));
			Input.inputContainer=Browser.createElement("div");
			Input.inputContainer.style.position="absolute";
			Input.inputContainer.style.zIndex=1E5;
			Browser.container.appendChild(Input.inputContainer);
			Input.inputContainer.setPos=function (x,y){Input.inputContainer.style.left=x+'px';Input.inputContainer.style.top=y+'px';};
		}

		Input._initInput=function(input){
			var style=input.style;
			style.cssText="position:absolute;overflow:hidden;resize:none;transform-origin:0 0;-webkit-transform-origin:0 0;-moz-transform-origin:0 0;-o-transform-origin:0 0;";
			style.resize='none';
			style.backgroundColor='transparent';
			style.border='none';
			style.outline='none';
			input.addEventListener('input',Input._processInputting);
			input.addEventListener('mousemove',Input._stopEvent);
			input.addEventListener('mousedown',Input._stopEvent);
			input.addEventListener('touchmove',Input._stopEvent);
			if(!Render.isConchApp){
				input.setColor=function (color){input.style.color=color;};
				input.setFontSize=function (fontSize){input.style.fontSize=fontSize+'px';};
				input.setSize=function (w,h){input.style.width=w+'px';input.style.height=h+'px';};
			}
			input.setFontFace=function (fontFace){input.style.fontFamily=fontFace;};
		}

		Input._processInputting=function(e){
			var input=laya.display.Input.inputElement.target;
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
			if (e.type=='touchmove')
				e.preventDefault();
			e.stopPropagation && e.stopPropagation();
		}

		Input.TYPE_TEXT="text";
		Input.TYPE_PASSWORD="password";
		Input.TYPE_EMAIL="email";
		Input.TYPE_URL="url";
		Input.TYPE_NUMBER="number";
		Input.TYPE_RANGE="range";
		Input.TYPE_DATE="date";
		Input.TYPE_MONTH="month";
		Input.TYPE_WEEK="week";
		Input.TYPE_TIME="time";
		Input.TYPE_DATE_TIME="datetime";
		Input.TYPE_DATE_TIME_LOCAL="datetime-local";
		Input.TYPE_SEARCH="search";
		Input.input=null
		Input.area=null
		Input.inputElement=null
		Input.inputContainer=null
		Input.confirmButton=null
		Input.promptStyleDOM=null
		Input.inputHeight=45;
		Input.isInputting=false;
		__static(Input,
		['IOS_IFRAME',function(){return this.IOS_IFRAME=(Browser.onIOS && Browser.window.top !=Browser.window.self);}
		]);
		return Input;
	})(Text)


	/**
	*<code>HTMLImage</code> 用于创建 HTML Image 元素。
	*@private
	*/
	//class laya.resource.HTMLImage extends laya.resource.FileBitmap
	var HTMLImage=(function(_super){
		function HTMLImage(src,def){
			this._recreateLock=false;
			this._needReleaseAgain=false;
			HTMLImage.__super.call(this);
			this._init_(src,def);
		}

		__class(HTMLImage,'laya.resource.HTMLImage',_super);
		var __proto=HTMLImage.prototype;
		__proto._init_=function(src,def){
			this._src=src;
			this._source=new Browser.window.Image();
			if (def){
				def.onload && (this.onload=def.onload);
				def.onerror && (this.onerror=def.onerror);
				def.onCreate && def.onCreate(this);
			}
			if (src.indexOf("data:image")!=0)this._source.crossOrigin="";
			(src)&& (this._source.src=src);
		}

		/**
		*@inheritDoc
		*/
		__proto.recreateResource=function(){
			var _$this=this;
			if (this._src==="")
				throw new Error("src no null！");
			this._needReleaseAgain=false;
			if (!this._source){
				this._recreateLock=true;
				this.startCreate();
				var _this=this;
				this._source=new Browser.window.Image();
				this._source.crossOrigin="";
				this._source.onload=function (){
					if (_this._needReleaseAgain){
						_this._needReleaseAgain=false;
						_this._source.onload=null;
						_this._source=null;
						return;
					}
					_this._source.onload=null;
					_this.memorySize=_$this._w *_$this._h *4;
					_this._recreateLock=false;
					_this.completeCreate();
				};
				this._source.src=this._src;
				}else {
				if (this._recreateLock)
					return;
				this.startCreate();
				this.memorySize=this._w *this._h *4;
				this._recreateLock=false;
				this.completeCreate();
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
		__getset(0,__proto,'onerror',null,function(value){
			var _$this=this;
			this._onerror=value;
			this._source && (this._source.onerror=this._onerror !=null ? (function(){
				_$this._onerror()
			}):null);
		});

		HTMLImage.create=function(src,def){
			return new HTMLImage(src,def);
		}

		return HTMLImage;
	})(FileBitmap)


	//class laya.webgl.utils.IndexBuffer2D extends laya.webgl.utils.Buffer2D
	var IndexBuffer2D=(function(_super){
		function IndexBuffer2D(bufferUsage){
			this._uint8Array=null;
			this._uint16Array=null;
			(bufferUsage===void 0)&& (bufferUsage=0x88E4);
			IndexBuffer2D.__super.call(this);
			this._bufferUsage=bufferUsage;
			this._bufferType=0x8893;
			Render.isFlash || (this._buffer=new ArrayBuffer(8));
		}

		__class(IndexBuffer2D,'laya.webgl.utils.IndexBuffer2D',_super);
		var __proto=IndexBuffer2D.prototype;
		__proto._checkArrayUse=function(){
			this._uint8Array && (this._uint8Array=new Uint8Array(this._buffer));
			this._uint16Array && (this._uint16Array=new Uint16Array(this._buffer));
		}

		__proto.getUint8Array=function(){
			return this._uint8Array || (this._uint8Array=new Uint8Array(this._buffer));
		}

		__proto.getUint16Array=function(){
			return this._uint16Array || (this._uint16Array=new Uint16Array(this._buffer));
		}

		IndexBuffer2D.QuadrangleIB=null
		IndexBuffer2D.create=function(bufferUsage){
			(bufferUsage===void 0)&& (bufferUsage=0x88E4);
			return new IndexBuffer2D(bufferUsage);
		}

		return IndexBuffer2D;
	})(Buffer2D)


	//class laya.webgl.utils.VertexBuffer2D extends laya.webgl.utils.Buffer2D
	var VertexBuffer2D=(function(_super){
		function VertexBuffer2D(vertexStride,bufferUsage){
			this._floatArray32=null;
			this._vertexStride=0;
			VertexBuffer2D.__super.call(this);
			this._vertexStride=vertexStride;
			this._bufferUsage=bufferUsage;
			this._bufferType=0x8892;
			Render.isFlash || (this._buffer=new ArrayBuffer(8));
			this.getFloat32Array();
		}

		__class(VertexBuffer2D,'laya.webgl.utils.VertexBuffer2D',_super);
		var __proto=VertexBuffer2D.prototype;
		__proto.getFloat32Array=function(){
			return this._floatArray32 || (this._floatArray32=new Float32Array(this._buffer));
		}

		__proto.bind=function(ibBuffer){
			(ibBuffer)&& (ibBuffer._bind());
			this._bind();
		}

		__proto.insertData=function(data,pos){
			var vbdata=this.getFloat32Array();
			vbdata.set(data,pos);
			this._upload=true;
		}

		__proto.bind_upload=function(ibBuffer){
			(ibBuffer._bind_upload())|| (ibBuffer._bind());
			(this._bind_upload())|| (this._bind());
		}

		__proto._checkArrayUse=function(){
			this._floatArray32 && (this._floatArray32=new Float32Array(this._buffer));
		}

		__proto.detoryResource=function(){
			_super.prototype.detoryResource.call(this);
			for (var i=0;i < 10;i++)
			WebGL.mainContext.disableVertexAttribArray(i);
		}

		__getset(0,__proto,'vertexStride',function(){
			return this._vertexStride;
		});

		VertexBuffer2D.create=function(vertexStride,bufferUsage){
			(bufferUsage===void 0)&& (bufferUsage=0x88E8);
			return new VertexBuffer2D(vertexStride,bufferUsage);
		}

		return VertexBuffer2D;
	})(Buffer2D)


	/**
	*...
	*@author ...
	*/
	//class threeDimen.advancedStage.custom.MousePickingScene extends laya.d3.core.scene.Scene
	var MousePickingScene=(function(_super){
		function MousePickingScene(){
			this.meshCount=0;
			this.phasorSpriter3D=null;
			this.sprite3d=null;
			this.ray=null;
			this.camera=null;
			MousePickingScene.__super.call(this);
			this.vertices=[];
			this.indexs=[];
			this.point=new Vector2();
			this.raycastHit=new RaycastHit();
			var _$this=this;
			this.ray=new Ray(new Vector3(),new Vector3());
			this.phasorSpriter3D=new PhasorSpriter3D();
			this.camera=(this.addChild(new Camera(0,0.1,100)));
			this.camera.transform.translate(new Vector3(0,0.8,1.5));
			this.camera.transform.rotate(new Vector3(-30,0,0),true,false);
			this.sprite3d=this.addChild(new Sprite3D());
			this.sprite3d.once("hierarchyloaded",null,function(spirit3D){
				_$this.setMaterial(spirit3D);
			});
			this.sprite3d.loadHierarchy("../../../../res/threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh");
			this.sprite3d.transform.localScale=new Vector3(10,10,10);
		}

		__class(MousePickingScene,'threeDimen.advancedStage.custom.MousePickingScene',_super);
		var __proto=MousePickingScene.prototype;
		__proto.setMaterial=function(spirit3D){
			if ((spirit3D instanceof laya.d3.core.MeshSprite3D )){
				var meshSprite3D=spirit3D;
				var mesh=meshSprite3D.meshFilter.sharedMesh;
				if (mesh !=null){
					mesh.once("loaded",null,function(){
						for (var i=0;i < mesh.materials.length;i++)
						(mesh.materials [i]).albedo=new Vector4(3.0,3.0,3.0,1.0);
					});
				}
			}
			for (var i=0;i < spirit3D.numChildren;i++)
			this.setMaterial(spirit3D.getChildAt(i));
		}

		__proto.lateRender=function(state){
			laya.d3.core.scene.BaseScene.prototype.lateRender.call(this,state);
			var projViewMat=this.camera.projectionViewMatrix;
			this.point.elements[0]=Laya.stage.mouseX;
			this.point.elements[1]=Laya.stage.mouseY;
			this.camera.viewportPointToRay(this.point,this.ray);
			Physics.rayCast(this.ray,this.sprite3d,this.raycastHit);
			if (this.raycastHit.distance!==Number.MAX_VALUE){
				var trianglePositions=this.raycastHit.trianglePositions;
				var vertex1=trianglePositions[0];
				var vertex2=trianglePositions[1];
				var vertex3=trianglePositions[2];
				var v1X=vertex1.x,v1Y=vertex1.y,v1Z=vertex1.z;
				var v2X=vertex2.x,v2Y=vertex2.y,v2Z=vertex2.z;
				var v3X=vertex3.x,v3Y=vertex3.y,v3Z=vertex3.z;
				var position=this.raycastHit.position;
				var pX=position.x,pY=position.y,pZ=position.z;
				this.phasorSpriter3D.begin(0x0001,projViewMat,state);
				var original=this.ray.origin;
				this.phasorSpriter3D.line(original.x,original.y,original.z,1.0,0.0,0.0,1.0,0,0,0,1.0,0.0,0.0,1.0);
				this.phasorSpriter3D.line(v1X,v1Y,v1Z,1.0,0.0,0.0,1.0,v2X,v2Y,v2Z,1.0,0.0,0.0,1.0);
				this.phasorSpriter3D.line(v2X,v2Y,v2Z,1.0,0.0,0.0,1.0,v3X,v3Y,v3Z,1.0,0.0,0.0,1.0);
				this.phasorSpriter3D.line(v3X,v3Y,v3Z,1.0,0.0,0.0,1.0,v1X,v1Y,v1Z,1.0,0.0,0.0,1.0);
				this.phasorSpriter3D.line(pX,pY,pZ,1.0,0.0,0.0,1.0,v2X,v2Y,v2Z,1.0,0.0,0.0,1.0);
				this.phasorSpriter3D.line(pX,pY,pZ,1.0,0.0,0.0,1.0,v3X,v3Y,v3Z,1.0,0.0,0.0,1.0);
				this.phasorSpriter3D.line(pX,pY,pZ,1.0,0.0,0.0,1.0,v1X,v1Y,v1Z,1.0,0.0,0.0,1.0);
				this.phasorSpriter3D.end();
			}
		}

		return MousePickingScene;
	})(Scene)


	//class laya.webgl.resource.WebGLImage extends laya.resource.HTMLImage
	var WebGLImage=(function(_super){
		function WebGLImage(src,def){
			this._image=null;
			this._allowMerageInAtlas=false;
			this._enableMerageInAtlas=false;
			this.repeat=false;
			this.mipmap=false;
			this.minFifter=0;
			this.magFifter=0;
			WebGLImage.__super.call(this,src,def);
			this.repeat=false;
			this.mipmap=false;
			this.minFifter=-1;
			this.magFifter=-1;
			this._src=src;
			this._image=new Browser.window.Image();
			if (def){
				def.onload && (this.onload=def.onload);
				def.onerror && (this.onerror=def.onerror);
				def.onCreate && def.onCreate(this);
			}
			this._image.crossOrigin=(src && (src.indexOf("data:")==0))? null :"";
			(src)&& (this._image.src=src);
			this._enableMerageInAtlas=true;
		}

		__class(WebGLImage,'laya.webgl.resource.WebGLImage',_super);
		var __proto=WebGLImage.prototype;
		Laya.imps(__proto,{"laya.webgl.resource.IMergeAtlasBitmap":true})
		__proto._init_=function(src,def){}
		__proto._createWebGlTexture=function(){
			if (!this._image){
				throw "create GLTextur err:no data:"+this._image;
			};
			var gl=WebGL.mainContext;
			var glTex=this._source=gl.createTexture();
			var preTarget=WebGLContext.curBindTexTarget;
			var preTexture=WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl,0x0DE1,glTex);
			gl.texImage2D(0x0DE1,0,0x1908,0x1908,0x1401,this._image);
			var minFifter=this.minFifter;
			var magFifter=this.magFifter;
			var repeat=this.repeat ? 0x2901 :0x812F;
			var isPot=Arith.isPOT(this._w,this._h);
			if (isPot){
				if (this.mipmap)
					(minFifter!==-1)|| (minFifter=0x2703);
				else
				(minFifter!==-1)|| (minFifter=0x2601);
				(magFifter!==-1)|| (magFifter=0x2601);
				gl.texParameteri(0x0DE1,0x2801,minFifter);
				gl.texParameteri(0x0DE1,0x2800,magFifter);
				gl.texParameteri(0x0DE1,0x2802,repeat);
				gl.texParameteri(0x0DE1,0x2803,repeat);
				this.mipmap && gl.generateMipmap(0x0DE1);
				}else {
				(minFifter!==-1)|| (minFifter=0x2601);
				(magFifter!==-1)|| (magFifter=0x2601);
				gl.texParameteri(0x0DE1,0x2801,minFifter);
				gl.texParameteri(0x0DE1,0x2800,magFifter);
				gl.texParameteri(0x0DE1,0x2802,0x812F);
				gl.texParameteri(0x0DE1,0x2803,0x812F);
			}
			(preTarget && preTexture)&& (WebGLContext.bindTexture(gl,preTarget,preTexture));
			this._image.onload=null;
			this._image=null;
			if (isPot)
				this.memorySize=this._w *this._h *4 *(1+1 / 3);
			else
			this.memorySize=this._w *this._h *4;
			this._recreateLock=false;
		}

		/***重新创建资源，如果异步创建中被强制释放再创建，则需等待释放完成后再重新加载创建。*/
		__proto.recreateResource=function(){
			var _$this=this;
			if (this._src==null || this._src==="")
				return;
			this._needReleaseAgain=false;
			if (!this._image){
				this._recreateLock=true;
				this.startCreate();
				var _this=this;
				this._image=new Browser.window.Image();
				this._image.crossOrigin=this._src.indexOf("data:")==0 ? null :"";
				this._image.onload=function (){
					if (_this._needReleaseAgain){
						_this._needReleaseAgain=false;
						_this._image.onload=null;
						_this._image=null;
						return;
					}
					(!(_this._allowMerageInAtlas && _this._enableMerageInAtlas))? (_this._createWebGlTexture()):(_$this.memorySize=0,_$this._recreateLock=false);
					_this.completeCreate();
				};
				this._image.src=this._src;
				}else {
				if (this._recreateLock){
					return;
				}
				this.startCreate();
				(!(this._allowMerageInAtlas && this._enableMerageInAtlas))? (this._createWebGlTexture()):(this.memorySize=0,this._recreateLock=false);
				this.completeCreate();
			}
		}

		/***销毁资源*/
		__proto.detoryResource=function(){
			if (this._recreateLock){
				this._needReleaseAgain=true;
			}
			if (this._source){
				WebGL.mainContext.deleteTexture(this._source);
				this._source=null;
				this._image=null;
				this.memorySize=0;
			}
		}

		/***调整尺寸*/
		__proto.onresize=function(){
			this._w=this._image.width;
			this._h=this._image.height;
			(AtlasResourceManager.enabled)&& (this._w < AtlasResourceManager.atlasLimitWidth && this._h < AtlasResourceManager.atlasLimitHeight)? this._allowMerageInAtlas=true :this._allowMerageInAtlas=false;
		}

		__proto.clearAtlasSource=function(){
			this._image=null;
		}

		/**
		*返回HTML Image,as3无internal货friend，通常禁止开发者修改image内的任何属性
		*@param HTML Image
		*/
		__getset(0,__proto,'image',function(){
			return this._image;
		});

		/***
		*设置onload函数
		*@param value onload函数
		*/
		__getset(0,__proto,'onload',null,function(value){
			var _$this=this;
			this._onload=value;
			this._image && (this._image.onload=this._onload !=null ? (function(){
				_$this.onresize();
				_$this._onload();
			}):null);
		});

		/**
		*是否创建私有Source
		*@return 是否创建
		*/
		__getset(0,__proto,'allowMerageInAtlas',function(){
			return this._allowMerageInAtlas;
		});

		__getset(0,__proto,'atlasSource',function(){
			return this._image;
		});

		/**
		*是否创建私有Source,通常禁止修改
		*@param value 是否创建
		*/
		/**
		*是否创建私有Source
		*@return 是否创建
		*/
		__getset(0,__proto,'enableMerageInAtlas',function(){
			return this._enableMerageInAtlas;
			},function(value){
			this._enableMerageInAtlas=value;
		});

		/***
		*设置onerror函数
		*@param value onerror函数
		*/
		__getset(0,__proto,'onerror',null,function(value){
			var _$this=this;
			this._onerror=value;
			this._image && (this._image.onerror=this._onerror !=null ? (function(){
				_$this._onerror()
			}):null);
		});

		return WebGLImage;
	})(HTMLImage)


	Laya.__init([EventDispatcher,WebGLContext,Browser,WebGLContext2D,Render,LoaderManager,LocalStorage,ShaderCompile,Timer,AtlasGrid,RenderTargetMAX,DrawText]);
	new threeDimen.advancedStage.D3Advance_MousePickingSample();

})(window,document,Laya);
