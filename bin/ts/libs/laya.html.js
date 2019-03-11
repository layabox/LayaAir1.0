
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Browser=laya.utils.Browser,ClassUtils=laya.utils.ClassUtils,Context=laya.resource.Context,Event=laya.events.Event;
	var Graphics=laya.display.Graphics,HTMLChar=laya.utils.HTMLChar,Handler=laya.utils.Handler,Loader=laya.net.Loader;
	var Pool=laya.utils.Pool,Rectangle=laya.maths.Rectangle,Sprite=laya.display.Sprite,Text=laya.display.Text;
	var Texture=laya.resource.Texture,URL=laya.net.URL,Utils=laya.utils.Utils;
Laya.interface('laya.html.utils.ILayout');
/**
*@private
*/
//class laya.html.utils.HTMLStyle
var HTMLStyle=(function(){
	function HTMLStyle(){
		/**@private */
		//this._type=0;
		//this.fontSize=0;
		//this.family=null;
		//this.color=null;
		//this.ower=null;
		//this._extendStyle=null;
		//this.textDecoration=null;
		/**
		*文本背景颜色，以字符串表示。
		*/
		//this.bgColor=null;
		/**
		*文本边框背景颜色，以字符串表示。
		*/
		//this.borderColor=null;
		this.padding=HTMLStyle._PADDING;
		this.reset();
	}

	__class(HTMLStyle,'laya.html.utils.HTMLStyle');
	var __proto=HTMLStyle.prototype;
	//TODO:coverage
	__proto._getExtendStyle=function(){
		if (this._extendStyle===HTMLExtendStyle.EMPTY)this._extendStyle=HTMLExtendStyle.create();
		return this._extendStyle;
	}

	/**
	*重置，方便下次复用
	*/
	__proto.reset=function(){
		this.ower=null;
		this._type=0;
		this.wordWrap=true;
		this.fontSize=Text.defaultFontSize;
		this.family=Text.defaultFont;
		this.color="#000000";
		this.valign="top";
		this.padding=HTMLStyle._PADDING;
		this.bold=false;
		this.italic=false;
		this.align="left";
		this.textDecoration=null;
		this.bgColor=null;
		this.borderColor=null;
		if (this._extendStyle)this._extendStyle.recover();
		this._extendStyle=HTMLExtendStyle.EMPTY;
		return this;
	}

	//TODO:coverage
	__proto.recover=function(){
		Pool.recover("HTMLStyle",this.reset());
	}

	/**
	*复制传入的 CSSStyle 属性值。
	*@param src 待复制的 CSSStyle 对象。
	*/
	__proto.inherit=function(src){
		var i=0,len=0;
		var props;
		props=HTMLStyle._inheritProps;
		len=props.length;
		var key;
		for (i=0;i < len;i++){
			key=props[i];
			this[key]=src[key];
		}
	}

	/**@private */
	__proto._widthAuto=function(){
		return (this._type & 0x40000)!==0;
	}

	/**@inheritDoc */
	__proto.widthed=function(sprite){
		return (this._type & 0x8)!=0;
	}

	//TODO:coverage
	__proto._calculation=function(type,value){
		return false;
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
		var ower=this.ower;
		var resize=false;
		if (w!==-1 && w !=ower.width){
			this._type |=0x8;
			ower.width=w;
			resize=true;
		}
		if (h!==-1 && h !=ower.height){
			this._type |=0x2000;
			ower.height=h;
			resize=true;
		}
		if (resize){
			ower._layoutLater();
		}
	}

	/**
	*是否是行元素。
	*/
	__proto.getLineElement=function(){
		return (this._type & 0x10000)!=0;
	}

	__proto.setLineElement=function(value){
		value ? (this._type |=0x10000):(this._type &=(~0x10000));
	}

	//TODO:coverage
	__proto._enableLayout=function(){
		return (this._type & 0x2)===0 && (this._type & 0x4)===0;
	}

	/**
	*设置 CSS 样式字符串。
	*@param text CSS样式字符串。
	*/
	__proto.cssText=function(text){
		this.attrs(HTMLStyle.parseOneCSS(text,';'));
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
	*字体样式字符串。
	*/
	__getset(0,__proto,'font',function(){
		return (this.italic ? "italic " :"")+(this.bold ? "bold " :"")+this.fontSize+"px "+(Browser.onIPhone ? (Text.fontFamilyMap[this.family] || this.family):this.family);
		},function(value){
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
				this.fontSize=parseInt(str);
				this.family=strs[i+1];
				i++;
				continue ;
			}
		}
	});

	__getset(0,__proto,'href',function(){
		return this._extendStyle.href;
		},function(value){
		if (value===this._extendStyle.href)return;
		this._getExtendStyle().href=value;
	});

	/**行高。 */
	__getset(0,__proto,'lineHeight',function(){
		return this._extendStyle.lineHeight;
		},function(value){
		if (this._extendStyle.lineHeight===value)return;
		this._getExtendStyle().lineHeight=value;
	});

	/**
	*<p>描边颜色，以字符串表示。</p>
	*@default "#000000";
	*/
	__getset(0,__proto,'strokeColor',function(){
		return this._extendStyle.strokeColor;
		},function(value){
		if (this._extendStyle.strokeColor===value)return;
		this._getExtendStyle().strokeColor=value;
	});

	/**
	*<p>描边宽度（以像素为单位）。</p>
	*默认值0，表示不描边。
	*@default 0
	*/
	__getset(0,__proto,'stroke',function(){
		return this._extendStyle.stroke;
		},function(value){
		if (this._extendStyle.stroke===value)return;
		this._getExtendStyle().stroke=value;
	});

	/**
	*<p>垂直行间距（以像素为单位）</p>
	*/
	__getset(0,__proto,'leading',function(){
		return this._extendStyle.leading;
		},function(value){
		if (this._extendStyle.leading===value)return;
		this._getExtendStyle().leading=value;
	});

	/**
	*<p>表示使用此文本格式的文本段落的水平对齐方式。</p>
	*@default "left"
	*/
	__getset(0,__proto,'align',function(){
		var v=this._type & 0x30;
		return HTMLStyle.align_Value[v];
		},function(v){
		if (!(v in HTMLStyle.alignVDic))return;
		this._type &=(~0x30);
		this._type |=HTMLStyle.alignVDic[v];
	});

	/**
	*<p>表示使用此文本格式的文本段落的水平对齐方式。</p>
	*@default "left"
	*/
	__getset(0,__proto,'valign',function(){
		var v=this._type & 0xc0;
		return HTMLStyle.vAlign_Value[v];
		},function(v){
		if (!(v in HTMLStyle.alignVDic))return;
		this._type &=(~0xc0);
		this._type |=HTMLStyle.alignVDic[v];
	});

	/**
	*是否显示为块级元素。
	*/
	/**表示元素是否显示为块级元素。*/
	__getset(0,__proto,'block',function(){
		return (this._type & 0x1)!=0;
		},function(value){
		value ? (this._type |=0x1):(this._type &=(~0x1));
	});

	/**
	*表示是否换行。
	*/
	__getset(0,__proto,'wordWrap',function(){
		return (this._type & 0x20000)===0;
		},function(value){
		value ? (this._type &=~0x20000):(this._type |=0x20000);
	});

	/**是否为粗体*/
	__getset(0,__proto,'bold',function(){
		return (this._type & 0x400)!=0;
		},function(value){
		value ? (this._type |=0x400):(this._type &=~0x400);
	});

	/**
	*表示使用此文本格式的文本是否为斜体。
	*@default false
	*/
	__getset(0,__proto,'italic',function(){
		return (this._type & 0x800)!=0;
		},function(value){
		value ? (this._type |=0x800):(this._type &=~0x800);
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

	/**
	*间距。
	*/
	__getset(0,__proto,'letterSpacing',function(){
		return this._extendStyle.letterSpacing;
		},function(d){
		((typeof d=='string'))&& (d=parseInt(d+""));
		if (d==this._extendStyle.letterSpacing)return;
		this._getExtendStyle().letterSpacing=d;
	});

	/**
	*元素的定位类型。
	*/
	__getset(0,__proto,'position',function(){
		return (this._type & 0x4)? "absolute" :"";
		},function(value){
		value==="absolute" ? (this._type |=0x4):(this._type &=~0x4);
	});

	/**@inheritDoc */
	__getset(0,__proto,'absolute',function(){
		return (this._type & 0x4)!==0;
	});

	/**@inheritDoc */
	__getset(0,__proto,'paddingLeft',function(){
		return this.padding[3];
	});

	/**@inheritDoc */
	__getset(0,__proto,'paddingTop',function(){
		return this.padding[0];
	});

	HTMLStyle.create=function(){
		return Pool.getItemByClass("HTMLStyle",HTMLStyle);
	}

	HTMLStyle.parseOneCSS=function(text,clipWord){
		var out=[];
		var attrs=text.split(clipWord);
		var valueArray;
		for (var i=0,n=attrs.length;i < n;i++){
			var attr=attrs[i];
			var ofs=attr.indexOf(':');
			var name=attr.substr(0,ofs).replace(/^\s+|\s+$/g,'');
			if (name.length===0)continue ;
			var value=attr.substr(ofs+1).replace(/^\s+|\s+$/g,'');
			var one=[name,value];
			switch (name){
				case 'italic':
				case 'bold':
					one[1]=value=="true";
					break ;
				case "font-weight":
					if (value=="bold"){
						one[1]=true;
						one[0]="bold";
					}
					break ;
				case 'line-height':
					one[0]='lineHeight';
					one[1]=parseInt(value);
					break ;
				case 'font-size':
					one[0]='fontSize';
					one[1]=parseInt(value);
					break ;
				case 'stroke':
					one[0]='stroke';
					one[1]=parseInt(value);
					break ;
				case 'padding':
					valueArray=value.split(' ');
					valueArray.length > 1 || (valueArray[1]=valueArray[2]=valueArray[3]=valueArray[0]);
					one[1]=[parseInt(valueArray[0]),parseInt(valueArray[1]),parseInt(valueArray[2]),parseInt(valueArray[3])];
					break ;
				default :
					(one[0]=HTMLStyle._CSSTOVALUE[name])|| (one[0]=name);
				}
			out.push(one);
		}
		return out;
	}

	HTMLStyle.parseCSS=function(text,uri){
		var one;
		while ((one=HTMLStyle._parseCSSRegExp.exec(text))!=null){
			HTMLStyle.styleSheets[one[1]]=HTMLStyle.parseOneCSS(one[2],';');
		}
	}

	HTMLStyle._CSSTOVALUE={'letter-spacing':'letterSpacing','white-space':'whiteSpace','line-height':'lineHeight','font-family':'family','vertical-align':'valign','text-decoration':'textDecoration','background-color':'bgColor','border-color':'borderColor'};
	HTMLStyle._parseCSSRegExp=new RegExp("([\.\#]\\w+)\\s*{([\\s\\S]*?)}","g");
	HTMLStyle.ALIGN_LEFT="left";
	HTMLStyle.ALIGN_CENTER="center";
	HTMLStyle.ALIGN_RIGHT="right";
	HTMLStyle.VALIGN_TOP="top";
	HTMLStyle.VALIGN_MIDDLE="middle";
	HTMLStyle.VALIGN_BOTTOM="bottom";
	HTMLStyle.styleSheets={};
	HTMLStyle.ADDLAYOUTED=0x200;
	HTMLStyle._PADDING=[0,0,0,0];
	HTMLStyle._HEIGHT_SET=0x2000;
	HTMLStyle._LINE_ELEMENT=0x10000;
	HTMLStyle._NOWARP=0x20000;
	HTMLStyle._WIDTHAUTO=0x40000;
	HTMLStyle._BOLD=0x400;
	HTMLStyle._ITALIC=0x800;
	HTMLStyle._CSS_BLOCK=0x1;
	HTMLStyle._DISPLAY_NONE=0x2;
	HTMLStyle._ABSOLUTE=0x4;
	HTMLStyle._WIDTH_SET=0x8;
	HTMLStyle._ALIGN=0x30;
	HTMLStyle._VALIGN=0xc0;
	__static(HTMLStyle,
	['_inheritProps',function(){return this._inheritProps=["italic","align","valign","leading","stroke","strokeColor","bold","fontSize","lineHeight","wordWrap","color"];},'alignVDic',function(){return this.alignVDic={"left":0,"center":0x10,"right":0x20,"top":0,"middle":0x40,"bottom":0x80};},'align_Value',function(){return this.align_Value={0:"left",0x10:"center",0x20:"right"};},'vAlign_Value',function(){return this.vAlign_Value={0:"top",0x40:"middle",0x80:"bottom"};}
	]);
	return HTMLStyle;
})()


/**
*@private
*HTML的布局类
*对HTML的显示对象进行排版
*/
//class laya.html.utils.Layout
var Layout=(function(){
	function Layout(){}
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
		if (!element || !element._style)return null;
		var style=element._style;
		if ((style._type & /*laya.html.utils.HTMLStyle.ADDLAYOUTED*/0x200)===0)
			return null;
		element.style._type &=~ /*laya.html.utils.HTMLStyle.ADDLAYOUTED*/0x200;
		var arr=Layout._multiLineLayout(element);
		return arr;
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
		var align=style.align;
		var valign=style.valign;
		var endAdjust=valign!==/*laya.html.utils.HTMLStyle.VALIGN_TOP*/"top" || align!==/*laya.html.utils.HTMLStyle.ALIGN_LEFT*/"left" || lineHeight !=0;
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
				curLine.y=y;
				curLine.h=lineHeight;
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
				w=htmlWord.width+htmlWord.style.letterSpacing;
				h=htmlWord.height;
				nextNewline=false;
				newLine=newLine || ((x+w)> width);
				newLine && addLine();
				curLine.minTextHeight=Math.min(curLine.minTextHeight,oneLayout.height);
				}else {
				curStyle=oneLayout._getCSSStyle();
				sprite=oneLayout;
				curPadding=curStyle.padding;
				newLine=nextNewline || curStyle.getLineElement();
				w=sprite.width+curPadding[1]+curPadding[3]+curStyle.letterSpacing;
				h=sprite.height+curPadding[0]+curPadding[2];
				nextNewline=curStyle.getLineElement();
				newLine=newLine || ((x+w)> width && curStyle.wordWrap);
				newLine && addLine();
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
			var tWidth=width;
			if (widthAuto && element.width > 0){
				tWidth=element.width;
			}
			for (i=0,n=lines.length;i < n;i++){
				lines[i].updatePos(0,tWidth,i,tY,align,valign,lineHeight);
				tY+=Math.max(lineHeight,lines[i].h+leading);
			}
			y=tY;
		}
		widthAuto && (element.width=maxWidth);
		(y > element.height)&& (element.height=y);
		return [maxWidth,y];
	}

	Layout.DIV_ELEMENT_PADDING=0;
	Layout._will=null;
	return Layout;
})()


/**
*@private
*/
//class laya.html.dom.HTMLElement
var HTMLElement=(function(){
	function HTMLElement(){
		//this.URI=null;
		//this.parent=null;
		//this._style=null;
		//this._text=null;
		//this._children=null;
		//this._x=NaN;
		//this._y=NaN;
		//this._width=NaN;
		//this._height=NaN;
		this._creates();
		this.reset();
	}

	__class(HTMLElement,'laya.html.dom.HTMLElement');
	var __proto=HTMLElement.prototype;
	__proto._creates=function(){
		this._style=HTMLStyle.create();
	}

	/**
	*重置
	*/
	__proto.reset=function(){
		this.URI=null;
		this.parent=null;
		this._style.reset();
		this._style.ower=this;
		this._style.valign="middle";
		if (this._text && this._text.words){
			var words=this._text.words;
			var i=0,len=0;
			len=words.length;
			var tChar;
			for (i=0;i < len;i++){
				tChar=words[i];
				if (tChar)tChar.recover();
			}
		}
		this._text=HTMLElement._EMPTYTEXT;
		if (this._children)this._children.length=0;
		this._x=this._y=this._width=this._height=0;
		return this;
	}

	/**@private */
	__proto._getCSSStyle=function(){
		return this._style;
	}

	/**@private */
	__proto._addChildsToLayout=function(out){
		var words=this._getWords();
		if (words==null && (!this._children || this._children.length==0))
			return false;
		if (words){
			for (var i=0,n=words.length;i < n;i++){
				out.push(words[i]);
			}
		}
		if (this._children)
			this._children.forEach(function(o,index,array){
			var _style=o._style;
			_style._enableLayout && _style._enableLayout()&& o._addToLayout(out);
		});
		return true;
	}

	/**@private */
	__proto._addToLayout=function(out){
		if (!this._style)return;
		var style=this._style;
		if (style.absolute)return;
		style.block ? out.push(this):(this._addChildsToLayout(out)&& (this.x=this.y=0));
	}

	__proto.repaint=function(recreate){
		(recreate===void 0)&& (recreate=false);
		this.parentRepaint(recreate);
	}

	__proto.parentRepaint=function(recreate){
		(recreate===void 0)&& (recreate=false);
		if (this.parent)this.parent.repaint(recreate);
	}

	__proto._setParent=function(value){
		if ((value instanceof laya.html.dom.HTMLElement )){
			var p=value;
			this.URI || (this.URI=p.URI);
			if (this.style)
				this.style.inherit(p.style);
		}
	}

	__proto.appendChild=function(c){
		return this.addChild(c);
	}

	__proto.addChild=function(c){
		if (c.parent)c.parent.removeChild(c);
		if (!this._children)this._children=[];
		this._children.push(c);
		c.parent=this;
		c._setParent(this);
		this.repaint();
		return c;
	}

	__proto.removeChild=function(c){
		if (!this._children)return null;
		var i=0,len=0;
		len=this._children.length;
		for (i=0;i < len;i++){
			if (this._children[i]==c){
				this._children.splice(i,1);
				return c;
			}
		}
		return null;
	}

	/**
	*<p>销毁此对象。destroy对象默认会把自己从父节点移除，并且清理自身引用关系，等待js自动垃圾回收机制回收。destroy后不能再使用。</p>
	*<p>destroy时会移除自身的事情监听，自身的timer监听，移除子对象及从父节点移除自己。</p>
	*@param destroyChild （可选）是否同时销毁子节点，若值为true,则销毁子节点，否则不销毁子节点。
	*/
	__proto.destroy=function(){
		if (this._children){
			this.destroyChildren();
			this._children.length=0;
		}
		Pool.recover(HTMLElement.getClassName(this),this.reset());
	}

	/**
	*销毁所有子对象，不销毁自己本身。
	*/
	__proto.destroyChildren=function(){
		if (this._children){
			for (var i=this._children.length-1;i >-1;i--){
				this._children[i].destroy();
			}
			this._children.length=0;
		}
	}

	__proto._getWords=function(){
		if (!this._text)return null;
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
		for (var i=0,n=txt.length;i < n;i++){
			size=Utils.measureText(txt.charAt(i),fontStr);
			words[i]=HTMLChar.create().setData(txt.charAt(i),size.width,size.height || style.fontSize,style);
		}
		return words;
	}

	//TODO:coverage
	__proto._isChar=function(){
		return false;
	}

	__proto._layoutLater=function(){
		var style=this.style;
		if ((style._type & /*laya.html.utils.HTMLStyle.ADDLAYOUTED*/0x200))
			return;
		if (style.widthed(this)&& ((this._children && this._children.length > 0)|| this._getWords()!=null)&& style.block){
			Layout.later(this);
			style._type |=/*laya.html.utils.HTMLStyle.ADDLAYOUTED*/0x200;
			}else {
			this.parent && this.parent._layoutLater();
		}
	}

	__proto._setAttributes=function(name,value){
		switch (name){
			case 'style':
				this.style.cssText(value);
				break ;
			case 'class':
				this.className=value;
				break ;
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

	__proto.formatURL=function(url){
		if (!this.URI)return url;
		return HTMLElement.formatURL1(url,this.URI ? this.URI.path :null);
	}

	__proto.drawToGraphic=function(graphic,gX,gY,recList){
		gX+=this.x;
		gY+=this.y;
		var cssStyle=this.style;
		if (cssStyle.paddingLeft){
			gX+=cssStyle.paddingLeft;
		}
		if (cssStyle.paddingTop){
			gY+=cssStyle.paddingTop;
		}
		if (cssStyle.bgColor !=null || cssStyle.borderColor){
			graphic.drawRect(gX,gY,this.width,this.height,cssStyle.bgColor,cssStyle.borderColor,1);
		}
		this.renderSelfToGraphic(graphic,gX,gY,recList);
		var i=0,len=0;
		var tChild;
		if (this._children && this._children.length > 0){
			len=this._children.length;
			for (i=0;i < len;i++){
				tChild=this._children[i];
				if (tChild.drawToGraphic !=null)
					tChild.drawToGraphic(graphic,gX,gY,recList);
			}
		}
	}

	__proto.renderSelfToGraphic=function(graphic,gX,gY,recList){
		var cssStyle=this.style;
		var words=this._getWords();
		var i=0,len=0;
		if (words){
			len=words.length;
			var a;
			if (cssStyle){
				var font=cssStyle.font;
				var color=cssStyle.color;
				if (cssStyle.stroke){
					var stroke=cssStyle.stroke;
					stroke=parseInt(stroke);
					var strokeColor=cssStyle.strokeColor;
					graphic.fillBorderWords(words,gX,gY,font,color,strokeColor,stroke);
					}else {
					graphic.fillWords(words,gX,gY,font,color);
				}
				if (this.href){
					var lastIndex=words.length-1;
					var lastWords=words[lastIndex];
					var lineY=lastWords.y+lastWords.height;
					if(cssStyle.textDecoration!="none")
						graphic.drawLine(words[0].x,lineY,lastWords.x+lastWords.width,lineY,color,1);
					var hitRec=HTMLHitRect.create();
					hitRec.rec.setTo(words[0].x,lastWords.y,lastWords.x+lastWords.width-words[0].x,lastWords.height);
					hitRec.href=this.href;
					recList.push(hitRec);
				}
			}
		}
	}

	__getset(0,__proto,'href',function(){
		if (!this._style)return null;
		return this._style.href;
		},function(url){
		if (!this._style)return;
		if (url !=this._style.href){
			this._style.href=url;
			this.repaint();
		}
	});

	__getset(0,__proto,'color',null,function(value){
		this.style.color=value;
	});

	__getset(0,__proto,'id',null,function(value){
		HTMLDocument.document.setElementById(value,this);
	});

	__getset(0,__proto,'innerTEXT',function(){
		return this._text.text;
		},function(value){
		if (this._text===HTMLElement._EMPTYTEXT){
			this._text={text:value,words:null};
			}else {
			this._text.text=value;
			this._text.words && (this._text.words.length=0);
		}
		this.repaint();
	});

	__getset(0,__proto,'style',function(){
		return this._style;
	});

	__getset(0,__proto,'width',function(){
		return this._width;
		},function(value){
		if (this._width!==value){
			this._width=value;
			this.repaint();
		}
	});

	__getset(0,__proto,'x',function(){
		return this._x;
		},function(v){
		if (this._x !=v){
			this._x=v;
			this.parentRepaint();
		}
	});

	__getset(0,__proto,'y',function(){
		return this._y;
		},function(v){
		if (this._y !=v){
			this._y=v;
			this.parentRepaint();
		}
	});

	__getset(0,__proto,'height',function(){
		return this._height;
		},function(value){
		if (this._height!==value){
			this._height=value;
			this.repaint();
		}
	});

	__getset(0,__proto,'className',null,function(value){
		this.style.attrs(HTMLDocument.document.styleSheets['.'+value]);
	});

	HTMLElement.formatURL1=function(url,basePath){
		if (!url)return "null path";
		if (!basePath)basePath=URL.basePath;
		if (url.indexOf(":")> 0)return url;
		if (URL.customFormat !=null)url=URL.customFormat(url);
		if (url.indexOf(":")> 0)return url;
		var char1=url.charAt(0);
		if (char1==="."){
			return URL._formatRelativePath (basePath+url);
			}else if (char1==='~'){
			return URL.rootPath+url.substring(1);
			}else if (char1==="d"){
			if (url.indexOf("data:image")===0)return url;
			}else if (char1==="/"){
			return url;
		}
		return basePath+url;
	}

	HTMLElement.getClassName=function(tar){
		if ((typeof tar=='function'))return tar.name;
		return tar["constructor"].name;
	}

	HTMLElement._EMPTYTEXT={text:null,words:null};
	return HTMLElement;
})()


/**
*@private
*/
//class laya.html.utils.HTMLExtendStyle
var HTMLExtendStyle=(function(){
	function HTMLExtendStyle(){
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
		/**
		*<p>垂直行间距（以像素为单位）</p>
		*/
		//this.leading=NaN;
		/**行高。 */
		//this.lineHeight=NaN;
		//this.letterSpacing=0;
		//this.href=null;
		this.reset();
	}

	__class(HTMLExtendStyle,'laya.html.utils.HTMLExtendStyle');
	var __proto=HTMLExtendStyle.prototype;
	__proto.reset=function(){
		this.stroke=0;
		this.strokeColor="#000000";
		this.leading=0;
		this.lineHeight=0;
		this.letterSpacing=0;
		this.href=null;
		return this;
	}

	__proto.recover=function(){
		if (this==HTMLExtendStyle.EMPTY)return;
		Pool.recover("HTMLExtendStyle",this.reset());
	}

	HTMLExtendStyle.create=function(){
		return Pool.getItemByClass("HTMLExtendStyle",HTMLExtendStyle);
	}

	HTMLExtendStyle.EMPTY=new HTMLExtendStyle();
	return HTMLExtendStyle;
})()


/**
*@private
*/
//class laya.html.utils.HTMLParse
var HTMLParse=(function(){
	function HTMLParse(){}
	__class(HTMLParse,'laya.html.utils.HTMLParse');
	HTMLParse.getInstance=function(type){
		var rst=Pool.getItem(HTMLParse._htmlClassMapShort[type]);
		if (!rst){
			rst=ClassUtils.getInstance(type);
		}
		return rst;
	}

	HTMLParse.parse=function(ower,xmlString,url){
		xmlString=xmlString.replace(/<br>/g,"<br/>");
		xmlString="<root>"+xmlString+"</root>";
		xmlString=xmlString.replace(HTMLParse.spacePattern,HTMLParse.char255);
		var xml=Utils.parseXMLFromString(xmlString);
		HTMLParse._parseXML(ower,xml.childNodes[0].childNodes,url);
	}

	HTMLParse._parseXML=function(parent,xml,url,href){
		var i=0,n=0;
		if (xml.join || xml.item){
			for (i=0,n=xml.length;i < n;++i){
				HTMLParse._parseXML(parent,xml[i],url,href);
			}
			}else {
			var node;
			var nodeName;
			if (xml.nodeType==3){
				var txt;
				if ((parent instanceof laya.html.dom.HTMLDivParser )){
					if (xml.nodeName==null){
						xml.nodeName="#text";
					}
					nodeName=xml.nodeName.toLowerCase();
					txt=xml.textContent.replace(/^\s+|\s+$/g,'');
					if (txt.length > 0){
						node=HTMLParse.getInstance(nodeName);
						if (node){
							parent.addChild(node);
							((node).innerTEXT=txt.replace(HTMLParse.char255AndOneSpacePattern," "));
						}
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
				node=HTMLParse.getInstance(nodeName);
				if (node){
					if (nodeName=="p"){
						parent.addChild(HTMLParse.getInstance("br"));
						node=parent.addChild(node);
						parent.addChild(HTMLParse.getInstance("br"));
						}else{
						node=parent.addChild(node);
					}
					(node).URI=url;
					(node).href=href;
					var attributes=xml.attributes;
					if (attributes && attributes.length > 0){
						for (i=0,n=attributes.length;i < n;++i){
							var attribute=attributes[i];
							var attrName=attribute.nodeName;
							var value=attribute.value;
							node._setAttributes(attrName,value);
						}
					}
					HTMLParse._parseXML(node,xml.childNodes,url,(node).href);
					}else {
					HTMLParse._parseXML(parent,xml.childNodes,url,href);
				}
			}
		}
	}

	HTMLParse.char255=String.fromCharCode(255);
	HTMLParse.spacePattern=/&nbsp;|&#160;/g;
	HTMLParse.char255AndOneSpacePattern=new RegExp(String.fromCharCode(255)+"|(\\s+)","g");
	HTMLParse._htmlClassMapShort={'div':'HTMLDivParser','p':'HTMLElement','img':'HTMLImageElement','span':'HTMLElement','br':'HTMLBrElement','style':'HTMLStyleElement','font':'HTMLElement','a':'HTMLElement','#text':'HTMLElement','link':'HTMLLinkElement'};
	return HTMLParse;
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
		}
		lineHeight=lineHeight || this.h;
		var dx=0,ddy=NaN;
		if (align===/*laya.html.utils.HTMLStyle.ALIGN_CENTER*/"center")dx=(width-w)/ 2;
		if (align===/*laya.html.utils.HTMLStyle.ALIGN_RIGHT*/"right")dx=(width-w);
		for (var i=0,n=this.elements.length;i < n;i++){
			one=this.elements[i];
			var tCSSStyle=one._getCSSStyle();
			dx!==0 && (one.x+=dx);
			switch (tCSSStyle.valign){
				case "top":
					one.y=dy;
					break ;
				case "middle":;
					var tMinTextHeight=0;
					if (this.minTextHeight !=99999)tMinTextHeight=this.minTextHeight;
					var tBottomLineY=(tMinTextHeight+lineHeight)/ 2;
					tBottomLineY=Math.max(tBottomLineY,this.h);
					if ((one instanceof laya.html.dom.HTMLImageElement ))ddy=dy+tBottomLineY-one.height;
					else ddy=dy+tBottomLineY-one.height;
					one.y=ddy;
					break ;
				case "bottom":
					one.y=dy+(lineHeight-one.height);
					break ;
				}
		}
	}

	return LayoutLine;
})()


/**
*@private
*/
//class laya.html.dom.HTMLDocument
var HTMLDocument=(function(){
	function HTMLDocument(){
		this.all=new Array;
		this.styleSheets=HTMLStyle.styleSheets;
	}

	__class(HTMLDocument,'laya.html.dom.HTMLDocument');
	var __proto=HTMLDocument.prototype;
	//TODO:coverage
	__proto.getElementById=function(id){
		return this.all[id];
	}

	//TODO:coverage
	__proto.setElementById=function(id,e){
		this.all[id]=e;
	}

	__static(HTMLDocument,
	['document',function(){return this.document=new HTMLDocument();}
	]);
	return HTMLDocument;
})()


/**
*@private
*/
//class laya.html.dom.HTMLHitRect
var HTMLHitRect=(function(){
	function HTMLHitRect(){
		//this.rec=null;
		//this.href=null;
		this.rec=new Rectangle();
		this.reset();
	}

	__class(HTMLHitRect,'laya.html.dom.HTMLHitRect');
	var __proto=HTMLHitRect.prototype;
	__proto.reset=function(){
		this.rec.reset();
		this.href=null;
		return this;
	}

	__proto.recover=function(){
		Pool.recover("HTMLHitRect",this.reset());
	}

	HTMLHitRect.create=function(){
		return Pool.getItemByClass("HTMLHitRect",HTMLHitRect);
	}

	return HTMLHitRect;
})()


/**
*@private
*/
//class laya.html.dom.HTMLBrElement
var HTMLBrElement=(function(){
	function HTMLBrElement(){}
	__class(HTMLBrElement,'laya.html.dom.HTMLBrElement');
	var __proto=HTMLBrElement.prototype;
	/**@private */
	__proto._addToLayout=function(out){
		out.push(this);
	}

	//TODO:coverage
	__proto.reset=function(){
		return this;
	}

	__proto.destroy=function(){
		Pool.recover(HTMLElement.getClassName(this),this.reset());
	}

	__proto._setParent=function(value){}
	//TODO:coverage
	__proto._getCSSStyle=function(){
		if (!HTMLBrElement.brStyle){
			HTMLBrElement.brStyle=new HTMLStyle();
			HTMLBrElement.brStyle.setLineElement(true);
			HTMLBrElement.brStyle.block=true;
		}
		return HTMLBrElement.brStyle;
	}

	__proto.renderSelfToGraphic=function(graphic,gX,gY,recList){}
	__getset(0,__proto,'URI',null,function(value){
	});

	__getset(0,__proto,'parent',null,function(value){
	});

	__getset(0,__proto,'href',null,function(value){
	});

	HTMLBrElement.brStyle=null;
	return HTMLBrElement;
})()


/**
*@private
*/
//class laya.html.dom.HTMLLinkElement extends laya.html.dom.HTMLElement
var HTMLLinkElement=(function(_super){
	function HTMLLinkElement(){
		//this.type=null;
		//this._loader=null;
		HTMLLinkElement.__super.call(this);
	}

	__class(HTMLLinkElement,'laya.html.dom.HTMLLinkElement',_super);
	var __proto=HTMLLinkElement.prototype;
	__proto._creates=function(){}
	__proto.drawToGraphic=function(graphic,gX,gY,recList){}
	__proto.reset=function(){
		if (this._loader)this._loader.off(/*laya.events.Event.COMPLETE*/"complete",this,this._onload);
		this._loader=null;
		return this;
	}

	__proto._onload=function(data){
		if (this._loader)this._loader=null;
		switch (this.type){
			case 'text/css':
				HTMLStyle.parseCSS(data,this.URI);
				break ;
			}
		this.repaint(true);
	}

	__getset(0,__proto,'href',_super.prototype._$get_href,function(url){
		if (!url)return;
		url=this.formatURL(url);
		this.URI=new URL(url);
		if (this._loader)this._loader.off(/*laya.events.Event.COMPLETE*/"complete",this,this._onload);
		if (Loader.getRes(url)){
			if (this.type=="text/css"){
				HTMLStyle.parseCSS(Loader.getRes(url),this.URI);
			}
			return;
		}
		this._loader=new Loader();
		this._loader.once(/*laya.events.Event.COMPLETE*/"complete",this,this._onload);
		this._loader.load(url,/*laya.net.Loader.TEXT*/"text");
	});

	HTMLLinkElement._cuttingStyle=new RegExp("((@keyframes[\\s\\t]+|)(.+))[\\t\\n\\r\\\s]*{","g");
	return HTMLLinkElement;
})(HTMLElement)


/**
*@private
*/
//class laya.html.dom.HTMLImageElement extends laya.html.dom.HTMLElement
var HTMLImageElement=(function(_super){
	function HTMLImageElement(){
		//this._tex=null;
		//this._url=null;
		HTMLImageElement.__super.call(this);
	}

	__class(HTMLImageElement,'laya.html.dom.HTMLImageElement',_super);
	var __proto=HTMLImageElement.prototype;
	__proto.reset=function(){
		_super.prototype.reset.call(this);
		if (this._tex){
			this._tex.off(/*laya.events.Event.LOADED*/"loaded",this,this.onloaded);
		}
		this._tex=null;
		this._url=null;
		return this;
	}

	//TODO:coverage
	__proto.onloaded=function(){
		if (!this._style)return;
		var style=this._style;
		var w=style.widthed(this)?-1 :this._tex.width;
		var h=style.heighted(this)?-1 :this._tex.height;
		if (!style.widthed(this)&& this._width !=this._tex.width){
			this.width=this._tex.width;
			this.parent && this.parent._layoutLater();
		}
		if (!style.heighted(this)&& this._height !=this._tex.height){
			this.height=this._tex.height;
			this.parent && this.parent._layoutLater();
		}
		this.repaint();
	}

	//TODO:coverage
	__proto._addToLayout=function(out){
		var style=this._style;
		!style.absolute && out.push(this);
	}

	//TODO:coverage
	__proto.renderSelfToGraphic=function(graphic,gX,gY,recList){
		if (!this._tex)return;
		graphic.drawImage(this._tex,gX,gY,this.width || this._tex.width,this.height || this._tex.height);
	}

	__getset(0,__proto,'src',null,function(url){
		url=this.formatURL(url);
		if (this._url===url)return;
		this._url=url;
		var tex=this._tex=Loader.getRes(url);
		if (!tex){
			this._tex=tex=new Texture();
			tex.load(url);
			Loader.cacheRes(url,tex);
		}
		tex.getIsReady()? this.onloaded():tex.once(/*laya.events.Event.READY*/"ready",this,this.onloaded);
	});

	return HTMLImageElement;
})(HTMLElement)


/**
*@private
*/
//class laya.html.dom.HTMLDivParser extends laya.html.dom.HTMLElement
var HTMLDivParser=(function(_super){
	function HTMLDivParser(){
		/**实际内容的高 */
		this.contextHeight=NaN;
		/**实际内容的宽 */
		this.contextWidth=NaN;
		/**@private */
		this._htmlBounds=null;
		/**@private */
		this._boundsRec=null;
		/**重绘回调 */
		this.repaintHandler=null;
		HTMLDivParser.__super.call(this);
	}

	__class(HTMLDivParser,'laya.html.dom.HTMLDivParser',_super);
	var __proto=HTMLDivParser.prototype;
	__proto.reset=function(){
		HTMLStyleElement;
		HTMLLinkElement;
		_super.prototype.reset.call(this);
		this._style.block=true;
		this._style.setLineElement(true);
		this._style.width=200;
		this._style.height=200;
		this.repaintHandler=null;
		this.contextHeight=0;
		this.contextWidth=0;
		return this;
	}

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
		if (words==null && (!this._children||this._children.length==0))return false;
		words && words.forEach(function(o){
			out.push(o);
		});
		var tFirstKey=true;
		for (var i=0,len=this._children.length;i < len;i++){
			var o=this._children[i];
			if (tFirstKey){
				tFirstKey=false;
				}else {
				out.push(null);
			}
			o._addToLayout(out)
		}
		return true;
	}

	//TODO:coverage
	__proto._addToLayout=function(out){
		this.layout();
		!this.style.absolute && out.push(this);
	}

	/**
	*获取bounds
	*@return
	*/
	__proto.getBounds=function(){
		if (!this._htmlBounds)return null;
		if (!this._boundsRec)this._boundsRec=Rectangle.create();
		return this._boundsRec.copyFrom(this._htmlBounds);
	}

	__proto.parentRepaint=function(recreate){
		(recreate===void 0)&& (recreate=false);
		_super.prototype.parentRepaint.call(this);
		if (this.repaintHandler)this.repaintHandler.runWith(recreate);
	}

	/**
	*@private
	*对显示内容进行排版
	*/
	__proto.layout=function(){
		this.style._type |=/*laya.html.utils.HTMLStyle.ADDLAYOUTED*/0x200;
		var tArray=Layout.layout(this);
		if (tArray){
			if (!this._htmlBounds)this._htmlBounds=Rectangle.create();
			var tRectangle=this._htmlBounds;
			tRectangle.x=tRectangle.y=0;
			tRectangle.width=this.contextWidth=tArray[0];
			tRectangle.height=this.contextHeight=tArray[1];
		}
	}

	/**
	*获取对象的高
	*/
	__getset(0,__proto,'height',function(){
		if (this._height)return this._height;
		return this.contextHeight;
	},_super.prototype._$set_height);

	/**
	*设置标签内容
	*/
	__getset(0,__proto,'innerHTML',null,function(text){
		this.destroyChildren();
		this.appendHTML(text);
	});

	/**
	*获取对象的宽
	*/
	__getset(0,__proto,'width',function(){
		if (this._width)return this._width;
		return this.contextWidth;
		},function(value){
		var changed=false;
		if (value===0){
			changed=value !=this._width;
			}else {
			changed=value !=this.width;
		}
		Laya.superSet(HTMLElement,this,'width',value);
		if (changed)this.layout();
	});

	return HTMLDivParser;
})(HTMLElement)


/**
*@private
*/
//class laya.html.dom.HTMLStyleElement extends laya.html.dom.HTMLElement
var HTMLStyleElement=(function(_super){
	function HTMLStyleElement(){
		HTMLStyleElement.__super.call(this);;
	}

	__class(HTMLStyleElement,'laya.html.dom.HTMLStyleElement',_super);
	var __proto=HTMLStyleElement.prototype;
	__proto._creates=function(){}
	__proto.drawToGraphic=function(graphic,gX,gY,recList){}
	//TODO:coverage
	__proto.reset=function(){
		return this;
	}

	/**
	*解析样式
	*/
	__getset(0,__proto,'innerTEXT',_super.prototype._$get_innerTEXT,function(value){
		HTMLStyle.parseCSS(value,null);
	});

	return HTMLStyleElement;
})(HTMLElement)


/**
*HTML图文类，用于显示html内容
*
*支持的标签如下:
*a:链接标签，点击后会派发"link"事件 比如:<a href='alink'>a</a>
*div:div容器标签，比如:<div>abc</div>
*span:行内元素标签，比如:<span style='color:#ff0000'>abc</span>
*p:行元素标签，p标签会自动换行，div不会，比如:<p>abc</p>
*img:图片标签，比如:<img src='res/boy.png'></img>
*br:换行标签，比如:<div>abc<br/>def</div>
*style:样式标签，比如:<div style='width:130px;height:50px;color:#ff0000'>abc</div>
*link:外链样式标签，可以加载一个css文件来当style使用，比如:<link type='text/css' href='html/test.css'/>
*
*style支持的属性如下:
*italic:true|false;是否是斜体
*bold:true|false;是否是粗体
*letter-spacing:10px;字间距
*font-family:宋体;字体
*font-size:20px;字体大小
*font-weight:bold:none;字体是否是粗体，功能同bold
*color:#ff0000;字体颜色
*stroke:2px;字体描边宽度
*strokeColor:#ff0000;字体描边颜色
*padding:10px 10px 20px 20px;边缘的距离
*vertical-align:top|bottom|middle;垂直对齐方式
*align:left|right|center;水平对齐方式
*line-height:20px;行高
*background-color:#ff0000;背景颜色
*border-color:#ff0000;边框颜色
*width:100px;对象宽度
*height:100px;对象高度
*
*示例用法：
*var div:HTMLDivElement=new HTMLDivElement();
*div.innerHTML="<link type='text/css' href='html/test.css'/><a href='alink'>a</a><div style='width:130px;height:50px;color:#ff0000'>div</div><br/><span style='font-weight:bold;color:#ffffff;font-size:30px;stroke:2px;italic:true;'>span</span><span style='letter-spacing:5px'>span2</span><p>p</p><img src='res/boy.png'></img>";
*/
//class laya.html.dom.HTMLDivElement extends laya.display.Sprite
var HTMLDivElement=(function(_super){
	function HTMLDivElement(){
		/**@private */
		this._element=null;
		/**@private */
		this._recList=[];
		/**@private */
		this._innerHTML=null;
		/**@private */
		this._repaintState=0;
		HTMLDivElement.__super.call(this);
		this._element=new HTMLDivParser();
		this._element.repaintHandler=new Handler(this,this._htmlDivRepaint);
		this.mouseEnabled=true;
		this.on(/*laya.events.Event.CLICK*/"click",this,this._onMouseClick);
	}

	__class(HTMLDivElement,'laya.html.dom.HTMLDivElement',_super);
	var __proto=HTMLDivElement.prototype;
	/**@private */
	__proto.destroy=function(destroyChild){
		(destroyChild===void 0)&& (destroyChild=true);
		if (this._element)this._element.reset();
		this._element=null;
		this._doClears();
		_super.prototype.destroy.call(this,destroyChild);
	}

	/**@private */
	__proto._htmlDivRepaint=function(recreate){
		(recreate===void 0)&& (recreate=false);
		if (recreate){
			if (this._repaintState < 2)this._repaintState=2;
			}else {
			if (this._repaintState < 1)this._repaintState=1;
		}
		if (this._repaintState > 0)this._setGraphicDirty();
	}

	__proto._updateGraphicWork=function(){
		switch(this._repaintState){
			case 1:
				this._updateGraphic();
				break ;
			case 2:
				this._refresh();
				break ;
			}
	}

	__proto._setGraphicDirty=function(){
		this.callLater(this._updateGraphicWork);
	}

	/**@private */
	__proto._doClears=function(){
		if (!this._recList)return;
		var i=0,len=this._recList.length;
		var tRec;
		for (i=0;i < len;i++){
			tRec=this._recList[i];
			tRec.recover();
		}
		this._recList.length=0;
	}

	/**@private */
	__proto._updateGraphic=function(){
		this._doClears();
		this.graphics.clear(true);
		this._repaintState=0;
		this._element.drawToGraphic(this.graphics,-this._element.x,-this._element.y,this._recList);
		var bounds=this._element.getBounds();
		if (bounds)this.setSelfBounds(bounds);
		this.size(bounds.width,bounds.height);
	}

	__proto._refresh=function(){
		this._repaintState=1;
		if (this._innerHTML)this._element.innerHTML=this._innerHTML;
		this._setGraphicDirty();
	}

	/**@private */
	__proto._onMouseClick=function(){
		var tX=this.mouseX;
		var tY=this.mouseY;
		var i=0,len=0;
		var tHit;
		len=this._recList.length;
		for (i=0;i < len;i++){
			tHit=this._recList[i];
			if (tHit.rec.contains(tX,tY)){
				this._eventLink(tHit.href);
			}
		}
	}

	/**@private */
	__proto._eventLink=function(href){
		this.event(/*laya.events.Event.LINK*/"link",[href]);
	}

	/**
	*获取HTML样式
	*/
	__getset(0,__proto,'style',function(){
		return this._element.style;
	});

	/**
	*设置标签内容
	*/
	__getset(0,__proto,'innerHTML',null,function(text){
		if (this._innerHTML==text)return;
		this._repaintState=1;
		this._innerHTML=text;
		this._element.innerHTML=text;
		this._setGraphicDirty();
	});

	/**
	*获取內容宽度
	*/
	__getset(0,__proto,'contextWidth',function(){
		return this._element.contextWidth;
	});

	/**
	*获取內容高度
	*/
	__getset(0,__proto,'contextHeight',function(){
		return this._element.contextHeight;
	});

	return HTMLDivElement;
})(Sprite)


/**
*iframe标签类，目前用于加载外并解析数据
*/
//class laya.html.dom.HTMLIframeElement extends laya.html.dom.HTMLDivElement
var HTMLIframeElement=(function(_super){
	function HTMLIframeElement(){
		HTMLIframeElement.__super.call(this);
		this._element._getCSSStyle().valign="middle";
	}

	__class(HTMLIframeElement,'laya.html.dom.HTMLIframeElement',_super);
	var __proto=HTMLIframeElement.prototype;
	/**
	*加载html文件，并解析数据
	*@param url
	*/
	__getset(0,__proto,'href',null,function(url){
		var _$this=this;
		url=this._element.formatURL(url);
		var l=new Loader();
		l.once(/*laya.events.Event.COMPLETE*/"complete",null,function(data){
			var pre=_$this._element.URI;
			_$this._element.URI=new URL(url);
			_$this.innerHTML=data;
			!pre || (_$this._element.URI=pre);
		});
		l.load(url,/*laya.net.Loader.TEXT*/"text");
	});

	return HTMLIframeElement;
})(HTMLDivElement)



})(window,document,Laya);
