
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var CSSStyle=laya.display.css.CSSStyle,ClassUtils=laya.utils.ClassUtils,Node=laya.display.Node,WebGL=laya.webgl.WebGL;
	var Rectangle=laya.maths.Rectangle,URL=laya.net.URL,Sprite=laya.display.Sprite,Event=laya.events.Event,Loader=laya.net.Loader;
	var Browser=laya.utils.Browser,HTMLChar=laya.utils.HTMLChar,RenderSprite=laya.renders.RenderSprite,Utils=laya.utils.Utils;
	var Stat=laya.utils.Stat,RenderContext=laya.renders.RenderContext,Texture=laya.resource.Texture,load=Laya.load;
	/**
	*@private
	*/
	//class laya.html.utils.HTMLParse
	var HTMLParse=(function(){
		function HTMLParse(){};
		__class(HTMLParse,'laya.html.utils.HTMLParse');
		HTMLParse.parse=function(ower,xmlString,url){
			xmlString="<root>"+xmlString+"</root>";
			xmlString=xmlString.replace(HTMLParse.spacePattern,HTMLParse.char255);
			var xml=new Browser.window.DOMParser().parseFromString(xmlString,"text/xml");
			HTMLParse._parseXML(ower,xml.childNodes[0].childNodes,url);
		}

		HTMLParse._parseXML=function(parent,xml,url,href){
			var i=0,n=0;
			if (xml.item){
				for (i=0,n=xml.length;i < n;++i){
					HTMLParse._parseXML(parent,xml[i],url,href);
				}
				}else {
				var node;
				var nodeName;
				if (xml.nodeType==3){
					var txt;
					if ((parent instanceof laya.html.dom.HTMLDivElement )){
						nodeName=xml.nodeName.toLowerCase();
						txt=xml.textContent.replace(/^\s+|\s+$/g,'');
						if (txt.length > 0){
							node=parent.addChild(ClassUtils.getInstance(nodeName));
							((node).innerTEXT=txt.replace(HTMLParse.char255AndOneSpacePattern," "));
						}
						}else {
						txt=xml.textContent.replace(/^\s+|\s+$/g,'');
						if (txt.length > 0){
							((parent).innerTEXT=txt.replace(HTMLParse.char255AndOneSpacePattern," "));
						}
					}
					return;
					}else {
					nodeName=xml.nodeName.toLowerCase();
					if (nodeName=="#comment")return;
					node=parent.addChild(ClassUtils.getInstance(nodeName));
					(node).URI=url;
					(node).href=href;
					var attributes=xml.attributes;
					if (attributes && attributes.length > 0){
						for (i=0,n=attributes.length;i < n;++i){
							var attribute=attributes[i];
							var attrName=attribute.nodeName;
							var value=attribute.value;
							node.setValue(attrName,value);
						}
					}
					HTMLParse._parseXML(node,xml.childNodes,url,(node).href);
				}
			}
		}

		HTMLParse.char255=String.fromCharCode(255);
		HTMLParse.spacePattern=/&nbsp;|&#160;/g;
		HTMLParse.char255AndOneSpacePattern=new RegExp(String.fromCharCode(255)+"|(\\s+)","g");
		return HTMLParse;
	})()


	/**
	*@private
	*HTML的布局类
	*对HTML的显示对象进行排版
	*/
	//class laya.html.utils.Layout
	var Layout=(function(){
		function Layout(){};
		__class(Layout,'laya.html.utils.Layout');
		Layout.later=function(element){
			if (Layout._will==null){
				Layout._will=[];
				Laya.stage.frameLoop(1,null,function(){
					if (Layout._will.length < 1)
						return;
					for (var i=0;i < Layout._will.length;i++){
						laya.html.utils.Layout.layout(Layout._will[i]);
					}
					Layout._will.length=0;
				});
			}
			Layout._will.push(element);
		}

		Layout.layout=function(element){
			if ((element._style._type & /*laya.display.css.CSSStyle.ADDLAYOUTED*/0x200)===0)
				return null;
			element._style._type &=~ /*laya.display.css.CSSStyle.ADDLAYOUTED*/0x200;
			return Layout._multiLineLayout(element);
		}

		Layout._multiLineLayout=function(element){
			var elements=new Array;
			element._addChildsToLayout(elements);
			var i=0,n=elements.length,j=0;
			var style=element._getCSSStyle();
			var letterSpacing=style.letterSpacing;
			var leading=style.leading;
			var lineHeight=style.lineHeight;
			var widthAuto=style._widthAuto()|| !style.wordWrap;
			var width=widthAuto ? 999999 :element.width;
			var height=element.height;
			var maxWidth=0;
			var exWidth=style.italic ? style.fontSize / 3 :0;
			var align=style._getAlign();
			var valign=style._getValign();
			var endAdjust=valign!==0 || align!==0 || lineHeight !=0;
			var oneLayout;
			var x=0;
			var y=0;
			var w=0;
			var h=0;
			var tBottom=0;
			var lines=new Array;
			var curStyle;
			var curPadding;
			var curLine=lines[0]=new LayoutLine();
			var newLine=false,nextNewline=false;
			var htmlWord;
			var sprite;
			curLine.h=0;
			if (style.italic)
				width-=style.fontSize / 3;
			var tWordWidth=0;
			var tLineFirstKey=true;
			function addLine (){
				curLine.y=y;
				y+=curLine.h+leading;
				curLine.mWidth=tWordWidth;
				tWordWidth=0;
				curLine=new LayoutLine();
				lines.push(curLine);
				curLine.h=0;
				x=0;
				tLineFirstKey=true;
				newLine=false;
			}
			for (i=0;i < n;i++){
				oneLayout=elements[i];
				if (oneLayout==null){
					if (!tLineFirstKey){
						x+=Layout.DIV_ELEMENT_PADDING;
					}
					curLine.wordStartIndex=curLine.elements.length;
					continue ;
				}
				tLineFirstKey=false;
				if ((oneLayout instanceof laya.html.dom.HTMLBrElement )){
					addLine();
					continue ;
					}else if (oneLayout._isChar()){
					htmlWord=oneLayout;
					if (!htmlWord.isWord){
						if (lines.length > 0 && (x+w)> width && curLine.wordStartIndex > 0){
							var tLineWord=0;
							tLineWord=curLine.elements.length-curLine.wordStartIndex+1;
							curLine.elements.length=curLine.wordStartIndex;
							i-=tLineWord;
							addLine();
							continue ;
						}
						newLine=false;
						tWordWidth+=htmlWord.width;
						}else {
						newLine=nextNewline || (htmlWord.char==='\n');
						curLine.wordStartIndex=curLine.elements.length;
					}
					w=htmlWord.width+letterSpacing;
					h=htmlWord.height;
					nextNewline=false;
					newLine=newLine || ((x+w)> width);
					newLine && addLine();
					curLine.minTextHeight=Math.min(curLine.minTextHeight,oneLayout.height);
					}else {
					curStyle=oneLayout._getCSSStyle();
					sprite=oneLayout;
					curPadding=curStyle.padding;
					curStyle._getCssFloat()===0 || (endAdjust=true);
					newLine=nextNewline || curStyle.lineElement;
					w=sprite.viewWidth+curPadding[1]+curPadding[3]+letterSpacing;
					h=sprite.viewHeight+curPadding[0]+curPadding[2];
					nextNewline=curStyle.lineElement;
					newLine=newLine || ((x+w)> width && curStyle.wordWrap);
					if (newLine){
						i-=1;
						newLine && addLine();
						continue ;
					}
				}
				curLine.elements.push(oneLayout);
				curLine.h=Math.max(curLine.h,h);
				oneLayout.x=x;
				oneLayout.y=y;
				x+=w;
				curLine.w=x-letterSpacing;
				curLine.y=y;
				maxWidth=Math.max(x+exWidth,maxWidth);
			}
			y=curLine.y+curLine.h;
			if (endAdjust){
				var tY=0;
				for (i=0,n=lines.length;i < n;i++){
					lines[i].updatePos(0,width,i,tY,align,valign,lineHeight);
					tY+=Math.max(lineHeight,lines[i].h);
				}
			}
			widthAuto && (element.width=maxWidth);
			(y > element.height)&& (element.height=y);
			return [maxWidth,y];
		}

		Layout._will=null
		Layout.DIV_ELEMENT_PADDING=10;
		return Layout;
	})()


	/**
	*@private
	*/
	//class laya.html.utils.LayoutLine
	var LayoutLine=(function(){
		function LayoutLine(){
			this.x=0;
			this.y=0;
			this.w=0;
			this.h=0;
			this.wordStartIndex=0;
			this.minTextHeight=99999;
			this.mWidth=0;
			this.elements=new Array;
		}

		__class(LayoutLine,'laya.html.utils.LayoutLine');
		var __proto=LayoutLine.prototype;
		/**
		*底对齐（默认）
		*@param left
		*@param width
		*@param dy
		*@param align 水平
		*@param valign 垂直
		*@param lineHeight 行高
		*/
		__proto.updatePos=function(left,width,lineNum,dy,align,valign,lineHeight){
			var w=0;
			var one
			if (this.elements.length > 0){
				one=this.elements[this.elements.length-1];
				w=one.x+one.width-this.elements[0].x;
			};
			var dx=0,ddy=NaN;
			align===/*laya.display.css.CSSStyle.ALIGN_CENTER*/1 && (dx=(width-w)/ 2);
			align===/*laya.display.css.CSSStyle.ALIGN_RIGHT*/2 && (dx=(width-w));
			lineHeight===0 || valign !=0 || (valign=1);
			for (var i=0,n=this.elements.length;i < n;i++){
				one=this.elements[i];
				var tCSSStyle=one._getCSSStyle();
				dx!==0 && (one.x+=dx);
				switch (tCSSStyle._getValign()){
					case 0:
						one.y=dy;
						break ;
					case /*laya.display.css.CSSStyle.VALIGN_MIDDLE*/1:;
						var tMinTextHeight=0;
						if (this.minTextHeight !=99999){
							tMinTextHeight=this.minTextHeight;
						};
						var tBottomLineY=(tMinTextHeight+lineHeight)/ 2;
						tBottomLineY=Math.max(tBottomLineY,this.h);
						if ((one instanceof laya.html.dom.HTMLImageElement )){
							ddy=dy+tBottomLineY-one.height;
							}else {
							ddy=dy+tBottomLineY-one.height;
						}
						one.y=ddy;
						break ;
					case /*laya.display.css.CSSStyle.VALIGN_BOTTOM*/2:
						one.y=dy+(lineHeight-one.height);
						break ;
					}
			}
		}

		return LayoutLine;
	})()


	/**
	*...
	*@author laya
	*/
	//class TestHTML
	var TestHTML=(function(){
		function TestHTML(){
			var _$this=this;
			var div;
			var _$this=this,__$=function (__line){
				if(__line<25){
					WebGL.enable();
					Laya.init(Browser.width,800);
					Laya.stage.bgColor="#FFFFFF";
					Laya.stage.hasOwnProperty("width");
					Laya.await(_$this,__$,31);return load('html/Minions.html');
				}
				if(__line<32){
					Laya.await(_$this,__$,32);return load('html/test.css');
				}
				if(__line<33){
					div=Laya.stage.addChild(new HTMLIframeElement());
					div.pos(0,0);
					div.style.cssText("width:800;height:600");
					div.href='html/Minions.html';
					Laya.stage.on(/*laya.events.Event.LINK*/"link",this,_$this.onTest);
			}}
			__$.call(this,0);
		}

		__class(TestHTML,'TestHTML');
		var __proto=TestHTML.prototype;
		__proto.onTest=function(_str){
			Browser.window.open(_str);
		}

		TestHTML.__init$=function(){
			"/***********************************/\n/*http://www.layabox.com 2015/12/20*/\n/***********************************/\nwindow.Laya=(function(window,document){\n	var Laya={\n		__internals:[],\n		__packages:{},\n		__classmap:{'Object':Object,'Function':Function,'Array':Array,'String':String},\n		__sysClass:{'object':'Object','array':'Array','string':'String','dictionary':'Dictionary'},\n		__propun:{writable: true,enumerable: false,configurable: true},\n		__presubstr:String.prototype.substr,\n		__substr:function(ofs,sz){return arguments.length==1?Laya.__presubstr.call(this,ofs):Laya.__presubstr.call(this,ofs,sz>0?sz:(this.length+sz));},\n		__init:function(_classs){_classs.forEach(function(o){o.__init$ && o.__init$();});},\n		__parseInt:function(value){return !value?0:parseInt(value);},\n		__isClass:function(o){return o && (o.__isclass || o==Object || o==String || o==Array);},\n		__newvec:function(sz,value){\n			var d=[];\n			d.length=sz;\n			for(var i=0;i<sz;i++) d[i]=value;\n			return d;\n		},\n		__extend:function(d,b){\n			for (var p in b){\n				if (!b.hasOwnProperty(p)) continue;\n				var g = b.__lookupGetter__(p), s = b.__lookupSetter__(p); \n				if ( g || s ) {\n					g && d.__defineGetter__(p, g);\n					s && d.__defineSetter__(p, s);\n				} \n				else d[p] = b[p];\n			}\n			function __() { Laya.un(this,'constructor',d); }__.prototype=b.prototype;d.prototype=new __();Laya.un(d.prototype,'__imps',Laya.__copy({},b.prototype.__imps));\n		},\n		__copy:function(dec,src){\n			if(!src) return null;\n			dec=dec||{};\n			for(var i in src) dec[i]=src[i];\n			return dec;\n		},\n		__package:function(name,o){\n			if(Laya.__packages[name]) return;\n			Laya.__packages[name]=true;\n			var p=window,strs=name.split('.');\n			if(strs.length>1){\n				for(var i=0,sz=strs.length-1;i<sz;i++){\n					var c=p[strs[i]];\n					p=c?c:(p[strs[i]]={});\n				}\n			}\n			p[strs[strs.length-1]] || (p[strs[strs.length-1]]=o||{});\n		},\n		__hasOwnProperty:function(name,o){\n			o=o ||this;\n		    function classHas(name,o){\n				if(Object.hasOwnProperty.call(o.prototype,name)) return true;\n				var s=o.prototype.__super;\n				return s==null?null:classHas(name,s);\n			}\n			return (Object.hasOwnProperty.call(o,name)) || classHas(name,o.__class);\n		},\n		__typeof:function(o,value){\n			if(!o || !value) return false;\n			if(value==String) return (typeof o=='string');\n			if(value==Number) return (typeof o=='number');\n			if(value.__interface__) value=value.__interface__;\n			else if(typeof value!='string')  return (o instanceof value);\n			return (o.__imps && o.__imps[value]) || (o.__class==value);\n		},\n		__as:function(value,type){\n			return (this.__typeof(value,type))?value:null;\n		},		\n		interface:function(name,_super){\n			Laya.__package(name,{});\n			var ins=Laya.__internals;\n			var a=ins[name]=ins[name] || {};\n			a.self=name;\n			if(_super)a.extend=ins[_super]=ins[_super] || {};\n			var o=window,words=name.split('.');\n			for(var i=0;i<words.length-1;i++) o=o[words[i]];o[words[words.length-1]]={__interface__:name};\n		},\n		class:function(o,fullName,_super,miniName){\n			_super && Laya.__extend(o,_super);\n			if(fullName){\n				Laya.__package(fullName,o);\n				Laya.__classmap[fullName]=o;\n				if(fullName.indexOf('.')>0){\n					if(fullName.indexOf('laya.')==0){\n						var paths=fullName.split('.');\n						miniName=miniName || paths[paths.length-1];\n						if(Laya[miniName]) debugger;\n						Laya[miniName]=o;\n					}					\n				}\n				else {\n					if(fullName==\"Main\")\n						window.Main=o;\n					else{\n						if(Laya[fullName]){\n							console.log(\"Err!,Same class:\"+fullName,Laya[fullName]);\n							debugger;\n						}\n						Laya[fullName]=o;\n					}\n				}\n			}\n			var un=Laya.un,p=o.prototype;\n			un(p,'hasOwnProperty',Laya.__hasOwnProperty);\n			un(p,'__class',o);\n			un(p,'__super',_super);\n			un(p,'__className',fullName);\n			un(o,'__super',_super);\n			un(o,'__className',fullName);\n			un(o,'__isclass',true);\n			un(o,'super',function(o){this.__super.call(o);});\n		},\n		imps:function(dec,src){\n			if(!src) return null;\n			var d=dec.__imps|| Laya.un(dec,'__imps',{});\n			for(var i in src){\n				d[i]=src[i];\n				var c=i;\n				while((c=this.__internals[c]) && (c=c.extend) ){\n					c=c.self;d[c]=true;\n				}\n			}\n		},		\n		getset:function(isStatic,o,name,getfn,setfn){\n			if(!isStatic){\n				getfn && Laya.un(o,'_$get_'+name,getfn);\n				setfn && Laya.un(o,'_$set_'+name,setfn);\n			}\n			else{\n				getfn && (o['_$GET_'+name]=getfn);\n				setfn && (o['_$SET_'+name]=setfn);\n			}\n			if(getfn && setfn) \n				Object.defineProperty(o,name,{get:getfn,set:setfn,enumerable:false});\n			else{\n				getfn && Object.defineProperty(o,name,{get:getfn,enumerable:false});\n				setfn && Object.defineProperty(o,name,{set:setfn,enumerable:false});\n			}\n		},\n		static:function(_class,def){\n				for(var i=0,sz=def.length;i<sz;i+=2){\n					if(def[i]=='length') \n						_class.length=def[i+1].call(_class);\n					else{\n						function tmp(){\n							var name=def[i];\n							var getfn=def[i+1];\n							Object.defineProperty(_class,name,{\n								get:function(){delete this[name];return this[name]=getfn.call(this);},\n								set:function(v){delete this[name];this[name]=v;},enumerable: true,configurable: true});\n						}\n						tmp();\n					}\n				}\n		},		\n		un:function(obj,name,value){\n			arguments.length<3 &&(value=obj[name]);\n			Laya.__propun.value=value;\n			Object.defineProperty(obj, name, Laya.__propun);\n			return value;\n		},\n		uns:function(obj,names){\n			names.forEach(function(o){Laya.un(obj,o)});\n		}\n	};\n\n	window.console=window.console || ({log:function(){}});\n	window.trace=window.console.log;\n	Error.prototype.throwError=function(){throw arguments;};\n	String.prototype.substr=Laya.__substr;\n	Object.defineProperty(Array.prototype,'fixed',{enumerable: false});\n"/*__INCLUDESTR__e:/trank/libs/layaair/html/src/tojs.head.js*/;
			"	var iflash=window.iflash={utils:{}};\n	var LAYABOX=window.LAYABOX=window.LAYABOX || {\n		classmap:Laya.__classmap,\n		systemClass:Laya.__sysClass,\n	};\n	Function.prototype.BIND$ = function(o) {\n			this.__$BiD___ || (this.__$BiD___ = LAYABOX.__bindid++);\n			o.BIND$__ || (o.BIND$__={});\n			var fn=o.BIND$__[this.__$BiD___];\n			if(fn) return fn;\n			return o.BIND$__[this.__$BiD___]=this.bind(o);\n	};\n	Array.CASEINSENSITIVE = 1;\n	Array.DESCENDING = 2;\n	Array.NUMERIC = 16;\n	Array.RETURNINDEXEDARRAY = 8;\n	Array.UNIQUESORT = 4;\n	Object.defineProperty(Array.prototype,'fixed',{enumerable: false});\n	(function(defs){\n		var p=Date.prototype;\n		Object.defineProperty(p,'millisecondsUTC',{get:p.getUTCMilliseconds,enumerable: false});\n		Object.defineProperty(p,'minutesUTC',{get:p.getUTCMinutes,enumerable: false});\n		Object.defineProperty(p,'mouthUTC',{get:p.getUTCMonth,enumerable: false});\n		for(var i=0;i<defs.length;i++)\n			Object.defineProperty(p,defs[i],{get:p['get'+defs[i].charAt(0).toUpperCase()+defs[i].substr(1)]})\n	})(['date','day','fullYear','hours','millseconds','minutes','month','seconds','time','timezoneOffset','dateUTC','dayUTC','fullYearUTC','hoursUTC']);\n	LAYABOX.__bindid=1;	\n	LAYABOX.sortonNameArray2=function(array,name,options){\n		(options===void 0)&& (options=0);\n		var name0=name[0],name1=name[1],type=1;\n		if (options==(16 | 2))type=-1;\n		return array.sort(function(a,b){\n			if (b[name0]==a[name0]){\n				 return type *(a[name1]-b[name1]);\n			}else return type *(a[name0]-b[name0]);\n		});\n	};\n	LAYABOX.sortonNameArray=function(array,name,options){\n		(options===void 0)&& (options=0);\n		var name0=name[0],type=1;\n		(options==(16 | 2)) && (type=-1);\n		return array.sort(function(a,b){\n			if (b[name0]==a[name0]){\n				for (var i=1,sz=name.length;i < sz;i++){\n					var tmp=name[i];\n					if (b[tmp]!=a[tmp])return type *(a[tmp]-b[tmp]);\n				}\n				return 0;\n			}\n			else return type *(a[name0]-b[name0]);\n		});\n	};\n	LAYABOX.arraypresort=Array.prototype.sort;\n	Laya.un(Array.prototype,'sortOn',function(name,options){\n		if(name instanceof Function) return this.sort(name);\n		if((name instanceof Array)){\n			if(name.length==0)return this;\n			if(name.length==2)return LAYABOX.sortonNameArray2(this,name,options);\n			if(name.length>2)return LAYABOX.sortonNameArray(this,name,options);name=name[0];\n		}\n		if (options==16)return this.sort(function(a,b){return a[name]-b[name];});\n		if (options==2)return this.sort(function(a,b){return b[name]-a[name];});\n		if (options==(16 | 2))return this.sort(function(a,b){return b[name]-a[name];});\n		if (options==1) return this.sort();\n		return this.sort(function(a,b){return a[name]-b[name];});\n	});\n	Laya.un(Array.prototype,'sort',function(value){\n		if(value==16) return LAYABOX.arraypresort.call(this,function (a, b) {return a - b;});\n		if(value==(16|2)) return LAYABOX.arraypresort.call(this,function (a, b) {return b - a;});\n		if(value==1) return LAYABOX.arraypresort.call(this);\n		return LAYABOX.arraypresort.call(this,value);\n	});\n	LAYABOX.bind=function(obj,fn){\n		return obj==null || fn==null?null:fn.BIND$(obj);\n	};\n"/*__INCLUDESTR__e:/trank/libs/layaair/html/src/tojs.flash.js*/;
		}

		return TestHTML;
	})()


	/**
	*@private
	*/
	//class laya.html.dom.HTMLElement extends laya.display.Sprite
	var HTMLElement=(function(_super){
		function HTMLElement(){
			this.URI=null;
			this._href=null;
			HTMLElement.__super.call(this);
			this._text=HTMLElement._EMPTYTEXT;
			this.setStyle(new CSSStyle(this));
			this._getCSSStyle().valign="middle";
			this.mouseEnabled=true;
		}

		__class(HTMLElement,'laya.html.dom.HTMLElement',_super);
		var __proto=HTMLElement.prototype;
		__proto.appendChild=function(c){
			return this.addChild(c);
		}

		__proto._getWords=function(){
			var txt=this._text.text;
			if (!txt || txt.length===0)
				return null;
			var words=this._text.words;
			if (words && words.length===txt.length)
				return words;
			words===null && (this._text.words=words=[]);
			words.length=txt.length;
			var size;
			var style=this.style;
			var fontStr=style.font;
			var startX=0;
			for (var i=0,n=txt.length;i < n;i++){
				size=Utils.measureText(txt[i],fontStr);
				var tHTMLChar=words[i]=new HTMLChar(txt[i],size.width,size.height,style);
				if (this.href){
					var tSprite=new Sprite();
					this.addChild(tSprite);
					tHTMLChar.setSprite(tSprite);
				}
			}
			return words;
		}

		__proto.showLinkSprite=function(){
			var words=this._text.words;
			if (words){
				var tLinkSpriteList=[];
				var tSprite;
				var tHtmlChar;
				for (var i=0;i < words.length;i++){
					tHtmlChar=words[i];
					tSprite=new Sprite();
					tSprite.graphics.drawRect(0,0,tHtmlChar.width,tHtmlChar.height,"#ff0000");
					tSprite.width=tHtmlChar.width;
					tSprite.height=tHtmlChar.height;
					this.addChild(tSprite);
					tLinkSpriteList.push(tSprite);
				}
			}
		}

		__proto.layoutLater=function(){
			var style=this.style;
			if ((style._type & /*laya.display.css.CSSStyle.ADDLAYOUTED*/0x200))return;
			if (style.widthed(this)&& (this._childs.length>0 || this._getWords()!=null)&& style.block){
				Layout.later(this);
				style._type |=/*laya.display.css.CSSStyle.ADDLAYOUTED*/0x200;
			}
			else{
				this.parent && (this.parent).layoutLater();
			}
		}

		__proto.setValue=function(name,value){
			switch (name){
				case 'style':
					this.style.cssText(value);
					return;
				case 'class':
					this.className=value;
					return;
				}
			_super.prototype.setValue.call(this,name,value);
		}

		__proto.updateHref=function(){
			if (this._href !=null){
				var words=this._getWords();
				if (words){
					var tHTMLChar;
					var tSprite;
					for (var i=0;i < words.length;i++){
						tHTMLChar=words[i];
						tSprite=tHTMLChar.getSprite();
						if (tSprite){
							var tHeight=tHTMLChar.height-1;
							tSprite.graphics.drawLine(0,tHeight,tHTMLChar.width,tHeight,tHTMLChar._getCSSStyle().color);
							tSprite.size(tHTMLChar.width,tHTMLChar.height);
							tSprite.on(/*laya.events.Event.CLICK*/"click",this,this.onLinkHandler);
						}
					}
				}
			}
		}

		__proto.onLinkHandler=function(e){
			switch(e.type){
				case /*laya.events.Event.CLICK*/"click":
					Laya.stage.event(/*laya.events.Event.LINK*/"link",[this.href]);
					break ;
				}
		}

		__proto.formatURL=function(url){
			return URL.formatURL(url,this.URI ? this.URI.path :null);
		}

		__getset(0,__proto,'color',null,function(value){
			this.style.color=value;
		});

		__getset(0,__proto,'id',null,function(value){
			HTMLDocument.document.setElementById(value,this);
		});

		__getset(0,__proto,'href',function(){
			return this._href;
			},function(url){
			this._href=url;
			if (url !=null){
				this.on(/*laya.events.Event.CLICK*/"click",this,this.onLinkHandler);
				this.updateHref();
			}
		});

		__getset(0,__proto,'parent',_super.prototype._$get_parent,function(value){
			if ((value instanceof laya.html.dom.HTMLElement )){
				var p=value;
				this.URI || (this.URI=p.URI);
				this.style.inherit(p.style);
			}
			_super.prototype._$set_parent.call(this,value);
		});

		__getset(0,__proto,'className',null,function(value){
			this.style.attrs(HTMLDocument.document.styleSheets['.'+value]);
		});

		__getset(0,__proto,'text',function(){
			return this._text.text;
			},function(value){
			if (this._text==HTMLElement._EMPTYTEXT){
				this._text={text:value,words:null};
			}
			else{
				this._text.text=value;
				this._text.words && (this._text.words.length=0);
			}
			this._renderType |=/*laya.renders.RenderSprite.CHILDS*/0x800;
			this.repaint();
			this.updateHref();
		});

		__getset(0,__proto,'innerTEXT',function(){
			return this._text.text;
			},function(value){
			this.text=value;
		});

		__getset(0,__proto,'style',function(){
			return this._style;
		});

		__getset(0,__proto,'onClick',null,function(value){
			var fn;
			/*__JS__ */eval("fn=function(event){"+value+";}");
			this.on(/*laya.events.Event.CLICK*/"click",this,fn);
		});

		HTMLElement._EMPTYTEXT={text:null,words:null};
		return HTMLElement;
	})(Sprite)


	/**
	*@private
	*/
	//class laya.html.dom.HTMLBrElement extends laya.html.dom.HTMLElement
	var HTMLBrElement=(function(_super){
		function HTMLBrElement(){
			HTMLBrElement.__super.call(this);
			this.style.lineElement=true;
			this.style.block=true;
		}

		__class(HTMLBrElement,'laya.html.dom.HTMLBrElement',_super);
		return HTMLBrElement;
	})(HTMLElement)


	/**
	*DIV标签
	*/
	//class laya.html.dom.HTMLDivElement extends laya.html.dom.HTMLElement
	var HTMLDivElement=(function(_super){
		function HTMLDivElement(){
			this.contextHeight=NaN;
			this.contextWidth=NaN;
			HTMLDivElement.__super.call(this);
			this.style.block=true;
			this.style.lineElement=true;
			this.style.width=200;
			this.style.height=200;
			HTMLStyleElement;
		}

		__class(HTMLDivElement,'laya.html.dom.HTMLDivElement',_super);
		var __proto=HTMLDivElement.prototype;
		/**
		*追加内容，解析并对显示对象排版
		*@param text
		*/
		__proto.appendHTML=function(text){
			HTMLParse.parse(this,text,this.URI);
			this.layout();
		}

		/**
		*@private
		*@param out
		*@return
		*/
		__proto._addChildsToLayout=function(out){
			var words=this._getWords();
			if (words==null && this._childs.length==0)return false;
			words && words.forEach(function(o){
				out.push(o);
			});
			var tFirstKey=true;
			this._childs.forEach(function(o){
				if (tFirstKey){
					tFirstKey=false;
					}else {
					out.push(null);
				}
				o._addToLayout(out)
			});
			return true;
		}

		/**
		*@private
		*@param out
		*/
		__proto._addToLayout=function(out){
			this.layout();
		}

		/**
		*@private
		*对显示内容进行排版
		*/
		__proto.layout=function(){
			this.style._type |=/*laya.display.css.CSSStyle.ADDLAYOUTED*/0x200;
			var tArray=Layout.layout(this);
			if (tArray){
				if (!this._$P.mHtmlBounds)this._set$P("mHtmlBounds",new Rectangle());
				var tRectangle=this._$P.mHtmlBounds;
				tRectangle.x=tRectangle.y=0;
				tRectangle.width=this.contextWidth=tArray[0];
				tRectangle.height=this.contextHeight=tArray[1];
				this.setBounds(tRectangle);
			}
		}

		/**
		*设置标签内容
		*/
		__getset(0,__proto,'innerHTML',null,function(text){
			this.removeChildren();
			this.appendHTML(text);
		});

		/**
		*如果对象的高度被设置过，返回设置的高度，如果没被设置过，则返回实际内容的高度
		*/
		__getset(0,__proto,'height',function(){
			if (this._height)return this._height;
			return this.contextHeight;
		},_super.prototype._$set_height);

		/**
		*如果对象的宽度被设置过，返回设置的宽度，如果没被设置过，则返回实际内容的宽度
		*/
		__getset(0,__proto,'width',function(){
			if (this._width)return this._width;
			return this.contextWidth;
		},_super.prototype._$set_width);

		return HTMLDivElement;
	})(HTMLElement)


	/**
	*@private
	*/
	//class laya.html.dom.HTMLDocument extends laya.html.dom.HTMLElement
	var HTMLDocument=(function(_super){
		function HTMLDocument(){
			this.all=new Array;
			this.styleSheets=CSSStyle.styleSheets;
			HTMLDocument.__super.call(this);
		}

		__class(HTMLDocument,'laya.html.dom.HTMLDocument',_super);
		var __proto=HTMLDocument.prototype;
		__proto.getElementById=function(id){
			return this.all[id];
		}

		__proto.setElementById=function(id,e){
			this.all[id]=e;
		}

		__static(HTMLDocument,
		['document',function(){return this.document=new HTMLDocument();}
		]);
		return HTMLDocument;
	})(HTMLElement)


	/**
	*@private
	*/
	//class laya.html.dom.HTMLImageElement extends laya.html.dom.HTMLElement
	var HTMLImageElement=(function(_super){
		function HTMLImageElement(){
			this._tex=null;
			this._url=null;
			this._renderArgs=[];
			HTMLImageElement.__super.call(this);
			this.style.block=true;
		}

		__class(HTMLImageElement,'laya.html.dom.HTMLImageElement',_super);
		var __proto=HTMLImageElement.prototype;
		__proto._addToLayout=function(out){
			!this._style.absolute && out.push(this);
		}

		__proto.render=function(context,x,y){
			if (!this._tex || !this._tex.loaded || !this._tex.loaded || this._width < 1 || this._height < 1)return;
			Stat.spriteDraw++;
			this._renderArgs[0]=this._tex;
			this._renderArgs[1]=this.x;
			this._renderArgs[2]=this.y;
			this._renderArgs[3]=this.width || this._tex.width;
			this._renderArgs[4]=this.height || this._tex.height;
			context.ctx.drawTexture2(x,y,this.style.translateX,this.style.translateY,this.transform,this.style.alpha,this.style.blendMode,this._renderArgs);
		}

		__getset(0,__proto,'src',null,function(url){
			var _$this=this;
			url=this.formatURL(url);
			if (this._url==url)return;
			this._url=url;
			this._tex=Loader.getRes(url)
			if (!this._tex){
				this._tex=new Texture();
				this._tex.load(url);
				Loader.cacheRes(url,this._tex);
			};
			var tex=this._tex=Loader.getRes(url);
			if (!tex){
				this._tex=tex=new Texture();
				tex.load(url);
				Loader.cacheRes(url,tex);
			}
			function onloaded (){
				var style=_$this._style;
				var w=style.widthed(_$this)?-1:_$this._tex.width;
				var h=style.heighted(_$this)?-1:_$this._tex.height;
				if (!style.widthed(_$this)&& _$this._width !=_$this._tex.width){
					_$this.width=_$this._tex.width;
					_$this.parent && (_$this.parent).layoutLater();
				}
				if (!style.heighted(_$this)&& _$this._height !=_$this._tex.height){
					_$this.height=_$this._tex.height;
					_$this.parent && (_$this.parent).layoutLater();
				}
			}
			tex.loaded?onloaded():tex.on(/*laya.events.Event.LOADED*/"loaded",null,onloaded);
		});

		return HTMLImageElement;
	})(HTMLElement)


	/**
	*@private
	*/
	//class laya.html.dom.HTMLLinkElement extends laya.html.dom.HTMLElement
	var HTMLLinkElement=(function(_super){
		function HTMLLinkElement(){
			this.type=null;
			HTMLLinkElement.__super.call(this);
			this.visible=false;
		}

		__class(HTMLLinkElement,'laya.html.dom.HTMLLinkElement',_super);
		var __proto=HTMLLinkElement.prototype;
		__proto._onload=function(data){
			switch(this.type){
				case 'text/css':
					CSSStyle.parseCSS(data,this.URI);
					break ;
				}
		}

		__getset(0,__proto,'href',_super.prototype._$get_href,function(url){
			var _$this=this;
			url=this.formatURL(url);
			this.URI=new URL(url);
			var l=new Loader();
			l.once(/*laya.events.Event.COMPLETE*/"complete",null,function(data){
				_$this._onload(data);
			});
			l.load(url,/*laya.net.Loader.TEXT*/"text");
		});

		HTMLLinkElement._cuttingStyle=new RegExp("((@keyframes[\\s\\t]+|)(.+))[\\t\\n\\r\\\s]*{","g");
		return HTMLLinkElement;
	})(HTMLElement)


	/**
	*@private
	*/
	//class laya.html.dom.HTMLStyleElement extends laya.html.dom.HTMLElement
	var HTMLStyleElement=(function(_super){
		function HTMLStyleElement(){
			HTMLStyleElement.__super.call(this);
			this.visible=false;
		}

		__class(HTMLStyleElement,'laya.html.dom.HTMLStyleElement',_super);
		var __proto=HTMLStyleElement.prototype;
		/**
		*解析样式
		*/
		__getset(0,__proto,'text',_super.prototype._$get_text,function(value){
			CSSStyle.parseCSS(value,null);
		});

		return HTMLStyleElement;
	})(HTMLElement)


	/**
	*iframe标签类，目前用于加载外并解析数据
	*/
	//class laya.html.dom.HTMLIframeElement extends laya.html.dom.HTMLDivElement
	var HTMLIframeElement=(function(_super){
		function HTMLIframeElement(){
			HTMLIframeElement.__super.call(this);
			this._getCSSStyle().valign="middle";
		}

		__class(HTMLIframeElement,'laya.html.dom.HTMLIframeElement',_super);
		var __proto=HTMLIframeElement.prototype;
		/**
		*加载html文件，并解析数据
		*@param url
		*/
		__getset(0,__proto,'href',_super.prototype._$get_href,function(url){
			var _$this=this;
			url=this.formatURL(url);
			var l=new Loader();
			l.once(/*laya.events.Event.COMPLETE*/"complete",null,function(data){
				var pre=_$this.URI;
				_$this.URI=new URL(url);
				_$this.innerHTML=data;
				!pre || (_$this.URI=pre);
			});
			l.load(url,/*laya.net.Loader.TEXT*/"text");
		});

		return HTMLIframeElement;
	})(HTMLDivElement)


	Laya.__init([TestHTML]);
})(window,document,Laya);
