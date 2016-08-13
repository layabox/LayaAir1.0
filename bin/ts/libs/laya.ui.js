
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var ColorFilter=laya.filters.ColorFilter,Ease=laya.utils.Ease,Event=laya.events.Event,Font=laya.display.css.Font;
	var FrameAnimation=laya.display.FrameAnimation,Graphics=laya.display.Graphics,Handler=laya.utils.Handler;
	var Input=laya.display.Input,Loader=laya.net.Loader,Node=laya.display.Node,Point=laya.maths.Point,Rectangle=laya.maths.Rectangle;
	var Render=laya.renders.Render,Sprite=laya.display.Sprite,Stage=laya.display.Stage,Text=laya.display.Text;
	var Texture=laya.resource.Texture,Tween=laya.utils.Tween,Utils=laya.utils.Utils;
	Laya.interface('laya.ui.IRender');
	Laya.interface('laya.ui.IComponent');
	Laya.interface('laya.ui.IItem');
	Laya.interface('laya.ui.ISelect');
	Laya.interface('laya.ui.IBox','IComponent');
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
			this.anchorX=NaN;
			this.anchorY=NaN;
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


	/**全局配置*/
	//class UIConfig
	var UIConfig=(function(){
		function UIConfig(){};
		__class(UIConfig,'UIConfig');
		UIConfig.touchScrollEnable=true;
		UIConfig.mouseWheelEnable=true;
		UIConfig.showButtons=true;
		UIConfig.popupBgColor="#000000";
		UIConfig.popupBgAlpha=0.5;
		return UIConfig;
	})()


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
			this._isChanged=false;
			this._offset=null;
			AutoBitmap.__super.call(this);
		}

		__class(AutoBitmap,'laya.ui.AutoBitmap',_super);
		var __proto=AutoBitmap.prototype;
		/**@inheritDoc */
		__proto.destroy=function(){
			_super.prototype.destroy.call(this);
			this._source=null;
			this._sizeGrid=null;
			this._offset=null;
		}

		/**@private */
		__proto._setChanged=function(){
			if (!this._isChanged){
				this._isChanged=true;
				Laya.timer.callLater(this,this.changeSource);
			}
		}

		/**
		*@private
		*修改纹理资源。
		*/
		__proto.changeSource=function(){
			if (AutoBitmap.cacheCount++> 50)AutoBitmap.clearCache();
			this._isChanged=false;
			var source=this._source;
			if (!source || !source.bitmap)return;
			var width=this.width;
			var height=this.height;
			var sizeGrid=this._sizeGrid;
			var sw=source.sourceWidth;
			var sh=source.sourceHeight;
			if (!sizeGrid || (sw===width && sh===height)){
				this.clear();
				this.drawTexture(source,this._offset ? this._offset[0] :0,this._offset ? this._offset[1] :0,width,height);
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
				if (this.autoCacheCmd && !Render.isConchApp)AutoBitmap.cmdCaches[key]=this.cmds;
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
			this._setChanged();
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
				this._setChanged();
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
			if (this._source)return this._source.sourceWidth;
			return 0;
			},function(value){
			if (this._width !=value){
				this._width=value;
				this._setChanged();
			}
		});

		/**
		*表示显示对象的高度，以像素为单位。
		*/
		__getset(0,__proto,'height',function(){
			if (this._height)return this._height;
			if (this._source)return this._source.sourceHeight;
			return 0;
			},function(value){
			if (this._height !=value){
				this._height=value;
				this._setChanged();
			}
		});

		AutoBitmap.getTexture=function(tex,x,y,width,height){
			if (width <=0)width=1;
			if (height <=0)height=1;
			tex.$_GID || (tex.$_GID=Utils.getGID())
			var key=tex.$_GID+"."+x+"."+y+"."+width+"."+height;
			var texture=AutoBitmap.textureCache[key];
			if (!texture){
				texture=AutoBitmap.textureCache[key]=Texture.createFromTexture(tex,x,y,width,height);
			}
			return texture;
		}

		AutoBitmap.clearCache=function(){
			AutoBitmap.cacheCount=0;
			AutoBitmap.cmdCaches={};
			AutoBitmap.textureCache={};
		}

		AutoBitmap.setCache=function(key,value){
			AutoBitmap.cacheCount++;
			AutoBitmap.textureCache[key]=value;
		}

		AutoBitmap.getCache=function(key){
			return AutoBitmap.textureCache[key];
		}

		AutoBitmap.cmdCaches={};
		AutoBitmap.cacheCount=0;
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
			this._gray=false;
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
			this.event(/*laya.events.Event.RESIZE*/"resize");
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
			this.parent.off(/*laya.events.Event.RESIZE*/"resize",this,this.onCompResize);
		}

		/**
		*对象被添加到显示列表的事件侦听处理函数。
		*/
		__proto.onAdded=function(){
			this.parent.on(/*laya.events.Event.RESIZE*/"resize",this,this.onCompResize);
			this.resetLayoutX();
			this.resetLayoutY();
		}

		/**
		*父容器的 <code>Event.RESIZE</code> 事件侦听处理函数。
		*/
		__proto.onCompResize=function(){
			if (this._layout && this._layout.enable){
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
				if (!isNaN(layout.anchorX))this.pivotX=layout.anchorX *this.width;
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
				if (!isNaN(layout.anchorY))this.pivotY=layout.anchorY *this.height;
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
			Laya.stage.event(/*laya.ui.UIEvent.SHOW_TIP*/"showtip",this._toolTip);
		}

		/**
		*对象的 <code>Event.MOUSE_OUT</code> 事件侦听处理函数。
		*/
		__proto.onMouseOut=function(e){
			Laya.stage.event(/*laya.ui.UIEvent.HIDE_TIP*/"hidetip",this._toolTip);
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
				this.model && this.model.size(this._width,this._height);
				this.callLater(this.changeSize);
				if (this._layout.enable && (!isNaN(this._layout.centerX)|| !isNaN(this._layout.right)|| !isNaN(this._layout.anchorX)))this.resetLayoutX();
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
				this.model && this.model.size(this._width,this._height);
				this.callLater(this.changeSize);
				if (this._layout.enable && (!isNaN(this._layout.centerY)|| !isNaN(this._layout.bottom)|| !isNaN(this._layout.anchorY)))this.resetLayoutY();
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
		*<p>可以赋值为文本 <code>String</code> 或函数 <code>Handler</code> ，用来实现自定义样式的鼠标提示和参数携带等。</p>
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
			tip.addChild(_testTips);
		}

		private function showTips2(name:String):void {
			_testTips.label.text="这里是"+name;
			tip.addChild(_testTips);
		}

		</listing>
		*/
		__getset(0,__proto,'toolTip',function(){
			return this._toolTip;
			},function(value){
			if (this._toolTip !=value){
				this._toolTip=value;
				if (value !=null){
					this.on(/*laya.events.Event.MOUSE_OVER*/"mouseover",this,this.onMouseOver);
					this.on(/*laya.events.Event.MOUSE_OUT*/"mouseout",this,this.onMouseOut);
					}else {
					this.off(/*laya.events.Event.MOUSE_OVER*/"mouseover",this,this.onMouseOver);
					this.off(/*laya.events.Event.MOUSE_OUT*/"mouseout",this,this.onMouseOut);
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

		/**X轴锚点，值为0-1*/
		__getset(0,__proto,'anchorX',function(){
			return this._layout.anchorX;
			},function(value){
			this.getLayout().anchorX=value;
			this.layOutEabled=true;
			this.resetLayoutX();
		});

		/**Y轴锚点，值为0-1*/
		__getset(0,__proto,'anchorY',function(){
			return this._layout.anchorY;
			},function(value){
			this.getLayout().anchorY=value;
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
		*@private
		*<p>指定对象是否可使用布局。</p>
		*<p>如果值为true,则此对象可以使用布局样式，否则不使用布局样式。</p>
		*@param value 一个 Boolean 值，指定对象是否可使用布局。
		*/
		__getset(0,__proto,'layOutEabled',null,function(value){
			if (this._layout && this._layout.enable !=value){
				this._layout.enable=value;
				if (this.parent){
					this.onAdded();
					}else if (!this.hasListener(/*laya.events.Event.ADDED*/"added")){
					this.on(/*laya.events.Event.ADDED*/"added",this,this.onAdded);
					this.on(/*laya.events.Event.REMOVED*/"removed",this,this.onRemoved);
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

		/**是否变灰。*/
		__getset(0,__proto,'gray',function(){
			return this._disabled;
			},function(value){
			if (value!==this._gray){
				this._gray=value;
				UIUtils.gray(this,value);
			}
		});

		/**是否禁用页面，设置为true后，会变灰并且禁用鼠标。*/
		__getset(0,__proto,'disabled',function(){
			return this._disabled;
			},function(value){
			if (value!==this._disabled){
				this.gray=this._disabled=value;
				this.mouseEnabled=!value;
			}
		});

		return Component;
	})(Sprite)


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
	*<code>Button</code> 组件用来表示常用的多态按钮。 <code>Button</code> 组件可显示文本标签、图标或同时显示两者。 *
	*<p>可以是单态，两态和三态，默认三态(up,over,down)。</p>
	*
	*@example 以下示例代码，创建了一个 <code>Button</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.Button;
		*import laya.utils.Handler;
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
			this._stateChanged=false;
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
			this._bitmap=null;
			this._text=null;
			this._clickHandler=null;
			this._labelColors=this._sources=this._strokeColors=null;
		}

		/**@inheritDoc */
		__proto.createChildren=function(){
			this.graphics=this._bitmap=new AutoBitmap();
		}

		/**@private */
		__proto.createText=function(){
			if (!this._text){
				this._text=new Text();
				this._text.overflow=Text.HIDDEN;
				this._text.align="center";
				this._text.valign="middle";
			}
		}

		/**@inheritDoc */
		__proto.initialize=function(){
			this.on(/*laya.events.Event.MOUSE_OVER*/"mouseover",this,this.onMouse);
			this.on(/*laya.events.Event.MOUSE_OUT*/"mouseout",this,this.onMouse);
			this.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onMouse);
			this.on(/*laya.events.Event.MOUSE_UP*/"mouseup",this,this.onMouse);
			this.on(/*laya.events.Event.CLICK*/"click",this,this.onMouse);
		}

		/**
		*对象的 <code>Event.MOUSE_OVER、Event.MOUSE_OUT、Event.MOUSE_DOWN、Event.MOUSE_UP、Event.CLICK</code> 事件侦听处理函数。
		*@param e Event 对象。
		*/
		__proto.onMouse=function(e){
			if (this.toggle===false && this._selected)return;
			if (e.type===/*laya.events.Event.CLICK*/"click"){
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
			};
			var width=img.sourceWidth;
			var height=img.sourceHeight / this._stateNum;
			var key=this._skin+this._stateNum;
			var clips=AutoBitmap.getCache(key);
			if (clips)this._sources=clips;
			else {
				this._sources=[];
				if (this._stateNum===1){
					this._sources.push(img);
					}else {
					for (var i=0;i < this._stateNum;i++){
						this._sources.push(Texture.createFromTexture(img,0,height *i,width,height));
					}
				}
				AutoBitmap.setCache(key,this._sources);
			}
			if (this._autoSize){
				this._bitmap.width=this._width || width;
				this._bitmap.height=this._height || height;
				if (this._text){
					this._text.width=this._bitmap.width;
					this._text.height=this._bitmap.height;
				}
				}else {
				this._text && (this._text.x=width);
			}
		}

		/**
		*@private
		*改变对象的状态。
		*/
		__proto.changeState=function(){
			this._stateChanged=false;
			this.runCallLater(this.changeClips);
			var index=this._state < this._stateNum ? this._state :this._stateNum-1;
			this._sources && (this._bitmap.source=this._sources[index]);
			if (this.label){
				this._text.color=this._labelColors[index];
				if (this._strokeColors)this._text.strokeColor=this._strokeColors[index];
			}
		}

		/**@private */
		__proto._setStateChanged=function(){
			if (!this._stateChanged){
				this._stateChanged=true;
				this.callLater(this.changeState);
			}
		}

		/**
		*<p>描边颜色，以字符串表示。</p>
		*默认值为 "#000000"（黑色）;
		*@see laya.display.Text.strokeColor()
		*/
		__getset(0,__proto,'labelStrokeColor',function(){
			this.createText();
			return this._text.strokeColor;
			},function(value){
			this.createText();
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
				this._setStateChanged();
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
				this._setStateChanged();
			}
		});

		/**
		*按钮的文本内容。
		*/
		__getset(0,__proto,'label',function(){
			return this._text ? this._text.text :null;
			},function(value){
			if (!this._text && !value)return;
			this.createText();
			if (this._text.text !=value){
				value && !this._text.displayedInStage && this.addChild(this._text);
				this._text.text=value;
				this._setStateChanged();
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
			this._setStateChanged();
		});

		/**
		*<p>描边宽度（以像素为单位）。</p>
		*默认值0，表示不描边。
		*@see laya.display.Text.stroke()
		*/
		__getset(0,__proto,'labelStroke',function(){
			this.createText();
			return this._text.stroke;
			},function(value){
			this.createText();
			this._text.stroke=value
		});

		/**
		*@inheritDoc
		*/
		__getset(0,__proto,'measureHeight',function(){
			this.runCallLater(this.changeClips);
			return this._text ? Math.max(this._bitmap.height,this._text.height):this._bitmap.height;
		});

		/**
		*@inheritDoc
		*/
		__getset(0,__proto,'measureWidth',function(){
			this.runCallLater(this.changeClips);
			if (this._autoSize)return this._bitmap.width;
			this.runCallLater(this.changeState);
			return this._bitmap.width+(this._text ? this._text.width :0);
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
				this.event(/*laya.events.Event.CHANGE*/"change");
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
			this._setStateChanged();
		});

		/**
		*表示按钮文本标签的边距。
		*<p><b>格式：</b>"上边距,右边距,下边距,左边距"。</p>
		*/
		__getset(0,__proto,'labelPadding',function(){
			this.createText();
			return this._text.padding.join(",");
			},function(value){
			this.createText();
			this._text.padding=UIUtils.fillArray(Styles.labelPadding,value,Number);
		});

		/**
		*表示按钮文本标签的字体大小。
		*@see laya.display.Text.fontSize()
		*/
		__getset(0,__proto,'labelSize',function(){
			this.createText();
			return this._text.fontSize;
			},function(value){
			this.createText();
			this._text.fontSize=value
		});

		/**
		*表示按钮文本标签是否为粗体字。
		*@see laya.display.Text.bold()
		*/
		__getset(0,__proto,'labelBold',function(){
			this.createText();
			return this._text.bold;
			},function(value){
			this.createText();
			this._text.bold=value;
		});

		/**标签对齐模式，默认为居中对齐。*/
		__getset(0,__proto,'labelAlign',function(){
			this.createText()
			return this._text.align;
			},function(value){
			this.createText()
			this._text.align=value;
		});

		/**
		*表示按钮文本标签的字体名称，以字符串形式表示。
		*@see laya.display.Text.font()
		*/
		__getset(0,__proto,'labelFont',function(){
			this.createText();
			return this._text.font;
			},function(value){
			this.createText();
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
			this.createText();
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
				this._text && (this._text.width=value);
			}
		});

		/**@inheritDoc */
		__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
			_super.prototype._$set_height.call(this,value);
			if (this._autoSize){
				this._bitmap.height=value;
				this._text && (this._text.height=value);
			}
		});

		/**@inheritDoc */
		__getset(0,__proto,'dataSource',_super.prototype._$get_dataSource,function(value){
			this._dataSource=value;
			if ((typeof value=='number')|| (typeof value=='string'))this.label=value+"";
			else _super.prototype._$set_dataSource.call(this,value);
		});

		/**图标x,y偏移，格式：100,100*/
		__getset(0,__proto,'iconOffset',function(){
			return this._bitmap._offset ? null :this._bitmap._offset.join(",");
			},function(value){
			if (value)this._bitmap._offset=UIUtils.fillArray([1,1],value,Number);
			else this._bitmap._offset=[];
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
		*public class Clip_Example
		*{
			*private var clip:Clip;
			*public function Clip_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*onInit();
				*}
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
			this._clipChanged=false;
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
			this.on(/*laya.events.Event.DISPLAY*/"display",this,this._onDisplay);
			this.on(/*laya.events.Event.UNDISPLAY*/"undisplay",this,this._onDisplay);
		}

		/**@private */
		__proto._onDisplay=function(e){
			if (this._isPlaying){
				if (this._displayedInStage)this.play();
				else this.stop();
				}else if (this._autoPlay && this._displayedInStage){
				this.play();
			}
		}

		/**
		*@private
		*改变切片的资源、切片的大小。
		*/
		__proto.changeClip=function(){
			this._clipChanged=false;
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
				this._clipWidth || (this._clipWidth=Math.ceil(img.sourceWidth / this._clipX));
				this._clipHeight || (this._clipHeight=Math.ceil(img.sourceHeight / this._clipY));
				var key=this._skin+this._clipWidth+this._clipHeight;
				var clips=AutoBitmap.getCache(key);
				if (clips)this._sources=clips;
				else {
					this._sources=[];
					for (var i=0;i < this._clipY;i++){
						for (var j=0;j < this._clipX;j++){
							this._sources.push(Texture.createFromTexture(img,this._clipWidth *j,this._clipHeight *i,this._clipWidth,this._clipHeight));
						}
					}
					AutoBitmap.setCache(key,this._sources);
				}
				this.index=this._index;
				this.event(/*laya.events.Event.LOADED*/"loaded");
				this.onCompResize();
			}
		}

		/**
		*播放动画。
		*/
		__proto.play=function(){
			this._isPlaying=true;
			this.index=0;
			this._index++;
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

		/**@private */
		__proto._setClipChanged=function(){
			if (!this._clipChanged){
				this._clipChanged=true;
				this.callLater(this.changeClip);
			}
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
			this._setClipChanged()
		});

		/**
		*@copy laya.ui.Image#skin
		*/
		__getset(0,__proto,'skin',function(){
			return this._skin;
			},function(value){
			this._skin=value;
			this._setClipChanged()
		});

		/**
		*源数据。
		*/
		__getset(0,__proto,'sources',function(){
			return this._sources;
			},function(value){
			this._sources=value;
			this.index=this._index;
			this.event(/*laya.events.Event.LOADED*/"loaded");
		});

		/**Y轴(竖向)切片数量。*/
		__getset(0,__proto,'clipY',function(){
			return this._clipY;
			},function(value){
			this._clipY=value;
			this._setClipChanged()
		});

		/**
		*横向分割时每个切片的宽度，与 <code>clipX</code> 同时设置时优先级高于 <code>clipX</code> 。
		*/
		__getset(0,__proto,'clipWidth',function(){
			return this._clipWidth;
			},function(value){
			this._clipWidth=value;
			this._setClipChanged()
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
			this._setClipChanged()
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
			this.event(/*laya.events.Event.CHANGE*/"change");
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
			if (((typeof value=='number')&& Math.floor(value)==value)|| (typeof value=='string'))this.index=parseInt(value);
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
		*public class ColorPicker_Example
		*{
			*public function ColorPicker_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load("resource/ui/color.png",Handler.create(this,onLoadComplete));//加载资源。
				*}
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
			*}
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
	*class ColorPicker_Example {
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load("resource/ui/color.png",Handler.create(this,this.onLoadComplete));//加载资源。
			*}
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
			this._panelChanged=false;
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
			this._colorButton.on(/*laya.events.Event.CLICK*/"click",this,this.onColorButtonClick);
			this._colorBlock.pos(5,5);
			this._colorInput.pos(60,5);
			this._colorInput.size(60,20);
			this._colorInput.on(/*laya.events.Event.CHANGE*/"change",this,this.onColorInputChange);
			this._colorInput.on(/*laya.events.Event.KEY_DOWN*/"keydown",this,this.onColorFieldKeyDown);
			this._colorTiles.pos(5,30);
			this._colorTiles.on(/*laya.events.Event.MOUSE_MOVE*/"mousemove",this,this.onColorTilesMouseMove);
			this._colorTiles.on(/*laya.events.Event.CLICK*/"click",this,this.onColorTilesClick);
			this._colorTiles.size(20 *this._gridSize,12 *this._gridSize);
			this._colorPanel.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onPanelMouseDown);
			this.bgColor=this._bgColor;
		}

		__proto.onPanelMouseDown=function(e){
			e.stopPropagation();
		}

		/**
		*改变颜色样本列表面板。
		*/
		__proto.changePanel=function(){
			this._panelChanged=false;
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
			Laya.stageBox.addChild(this._colorPanel);
			Laya.stage.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.removeColorBox);
		}

		/**
		*关闭颜色样本列表面板。
		*/
		__proto.close=function(){
			Laya.stage.off(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.removeColorBox);
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

		/**@private */
		__proto._setPanelChanged=function(){
			if (!this._panelChanged){
				this._panelChanged=true;
				this.callLater(this.changePanel);
			}
		}

		/**
		*表示颜色样本列表面板的边框颜色值。
		*/
		__getset(0,__proto,'borderColor',function(){
			return this._borderColor;
			},function(value){
			this._borderColor=value;
			this._setPanelChanged();
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
				this.event(/*laya.events.Event.CHANGE*/"change",Event.EMPTY.setTo(/*laya.events.Event.CHANGE*/"change",this,this));
			}
		});

		/**
		*表示颜色输入框的背景颜色值。
		*/
		__getset(0,__proto,'inputBgColor',function(){
			return this._inputBgColor;
			},function(value){
			this._inputBgColor=value;
			this._setPanelChanged();
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
			this._setPanelChanged();
		});

		/**
		*表示颜色样本列表面板选择或输入的颜色值。
		*/
		__getset(0,__proto,'inputColor',function(){
			return this._inputColor;
			},function(value){
			this._inputColor=value;
			this._setPanelChanged();
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
		*public class ComboBox_Example
		*{
			*public function ComboBox_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load("resource/ui/button.png",Handler.create(this,onLoadComplete));//加载资源。
				*}
			*private function onLoadComplete():void
			*{
				*trace("资源加载完成！");
				*var comboBox:ComboBox=new ComboBox("resource/ui/button.png","item0,item1,item2,item3,item4,item5");//创建一个 ComboBox 类的实例对象 comboBox ,传入它的皮肤和标签集。
				*comboBox.x=100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
				*comboBox.y=100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
				*comboBox.selectHandler=new Handler(this,onSelect);//设置 comboBox 选择项改变时执行的处理器。
				*Laya.stage.addChild(comboBox);//将此 comboBox 对象添加到显示列表。
				*}
			*private function onSelect(index:int):void
			*{
				*trace("当前选中的项对象索引： ",index);
				*}
			*}
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
		*private onLoadComplete():void {
			*console.log("资源加载完成！");
			*var comboBox:ComboBox=new ComboBox("resource/ui/button.png","item0,item1,item2,item3,item4,item5");//创建一个 ComboBox 类的实例对象 comboBox ,传入它的皮肤和标签集。
			*comboBox.x=100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
			*comboBox.y=100;//设置 comboBox 对象的属性 x 的值，用于控制 comboBox 对象的显示位置。
			*comboBox.selectHandler=new Handler(this,this.onSelect);//设置 comboBox 选择项改变时执行的处理器。
			*Laya.stage.addChild(comboBox);//将此 comboBox 对象添加到显示列表。
			*}
		*private onSelect(index:number):void {
			*console.log("当前选中的项对象索引： ",index);
			*}
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
			this._button.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onButtonMouseDown);
		}

		__proto._createList=function(){
			this._list=new List();
			this._list.selectEnable=true;
			this._list.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onListDown);
			this._list.mouseHandler=Handler.create(this,this.onlistItemMouse,null,false);
			if (this._scrollBarSkin){
				this._list.addChild(this._scrollBar=new VScrollBar());
				this._scrollBar.skin=this._scrollBarSkin;
				this._scrollBar.name="scrollBar";
				this._scrollBar.y=1;
				this._scrollBar.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onScrollBarDown);
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
			if (type===/*laya.events.Event.MOUSE_OVER*/"mouseover" || type===/*laya.events.Event.MOUSE_OUT*/"mouseout"){
				var box=this._list.getCell(index);
				if (!box)return;
				var label=box.getChildByName("label");
				if (type===/*laya.events.Event.ROLL_OVER*/"mouseover"){
					label.bgColor=this._itemColors[0];
					label.color=this._itemColors[1];
					}else {
					label.bgColor=null;
					label.color=this._itemColors[2];
				}
				}else if (type===/*laya.events.Event.CLICK*/"click"){
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
				this.event(/*laya.events.Event.CHANGE*/"change",[Event.EMPTY.setTo(/*laya.events.Event.CHANGE*/"change",this,this)]);
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
					py=py+this._listHeight <=Laya.stage.height ? py :p.y-this._listHeight;
					this._list.pos(p.x,py);
					Laya.stageBox.addChild(this._list);
					Laya.stage.once(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.removeList);
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
			if (((typeof value=='number')&& Math.floor(value)==value)|| (typeof value=='string'))this.selectedIndex=parseInt(value);
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
			if (this._button.labelColors !=value){
				this._button.labelColors=value;
			}
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
			this.upButton=null;
			this.downButton=null;
			this.slider=null;
			this._scrollSize=1;
			this._skin=null;
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
			this.upButton && this.upButton.destroy(destroyChild);
			this.downButton && this.downButton.destroy(destroyChild);
			this.slider && this.slider.destroy(destroyChild);
			this.upButton=this.downButton=null;
			this.slider=null;
			this.changeHandler=null;
			this._offsets=null;
		}

		/**@inheritDoc */
		__proto.createChildren=function(){
			this.addChild(this.slider=new Slider());
			this.addChild(this.upButton=new Button());
			this.addChild(this.downButton=new Button());
		}

		/**@inheritDoc */
		__proto.initialize=function(){
			this.slider.showLabel=false;
			this.slider.on(/*laya.events.Event.CHANGE*/"change",this,this.onSliderChange);
			this.slider.setSlider(0,0,0);
			this.upButton.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onButtonMouseDown);
			this.downButton.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onButtonMouseDown);
		}

		/**
		*@private
		*滑块位置发生改变的处理函数。
		*/
		__proto.onSliderChange=function(){
			this.value=this.slider.value;
		}

		/**
		*@private
		*向上和向下按钮的 <code>Event.MOUSE_DOWN</code> 事件侦听处理函数。
		*/
		__proto.onButtonMouseDown=function(e){
			var isUp=e.currentTarget===this.upButton;
			this.slide(isUp);
			Laya.timer.once(Styles.scrollBarDelayTime,this,this.startLoop,[isUp]);
			Laya.stage.once(/*laya.events.Event.MOUSE_UP*/"mouseup",this,this.onStageMouseUp);
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
			this.upButton.visible=this._showButtons;
			this.downButton.visible=this._showButtons;
			if (this._showButtons){
				this.upButton.skin=this._skin.replace(".png","$up.png");
				this.downButton.skin=this._skin.replace(".png","$down.png");
			}
			if (this.slider.isVertical)this.slider.y=this._showButtons ? this.upButton.height :0;
			else this.slider.x=this._showButtons ? this.upButton.width :0;
			this.resetPositions();
		}

		/**@inheritDoc */
		__proto.changeSize=function(){
			_super.prototype.changeSize.call(this);
			this.resetPositions();
			this.event(/*laya.events.Event.CHANGE*/"change");
			this.changeHandler && this.changeHandler.runWith(this.value);
		}

		/**@private */
		__proto.resetPositions=function(){
			if (this.slider.isVertical)this.slider.height=this.height-(this._showButtons ? (this.upButton.height+this.downButton.height):0);
			else this.slider.width=this.width-(this._showButtons ? (this.upButton.width+this.downButton.width):0);
			this.resetButtonPosition();
		}

		/**@private */
		__proto.resetButtonPosition=function(){
			if (this.slider.isVertical)this.downButton.y=this.slider.y+this.slider.height;
			else this.downButton.x=this.slider.x+this.slider.width;
		}

		/**
		*设置滚动条信息。
		*@param min 滚动条最小位置值。
		*@param max 滚动条最大位置值。
		*@param value 滚动条当前位置值。
		*/
		__proto.setScroll=function(min,max,value){
			this.runCallLater(this.changeSize);
			this.slider.setSlider(min,max,value);
			this.slider.bar.visible=max > 0;
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
			Laya.stage.once(/*laya.events.Event.MOUSE_UP*/"mouseup",this,this.onStageMouseUp2);
			Laya.stage.once(/*laya.events.Event.MOUSE_OUT*/"mouseout",this,this.onStageMouseUp2);
			Laya.timer.frameLoop(1,this,this.loop);
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
					this.event(/*laya.events.Event.START*/"start");
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
			Laya.stage.off(/*laya.events.Event.MOUSE_UP*/"mouseup",this,this.onStageMouseUp2);
			Laya.stage.off(/*laya.events.Event.MOUSE_OUT*/"mouseout",this,this.onStageMouseUp2);
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
				if (offset < 2){
					this.event(/*laya.events.Event.END*/"end");
					return;
				}
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
				this.event(/*laya.events.Event.END*/"end");
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
			return this.slider.isVertical;
			},function(value){
			this.slider.isVertical=value;
		});

		/**
		*@copy laya.ui.Image#skin
		*/
		__getset(0,__proto,'skin',function(){
			return this._skin;
			},function(value){
			if (this._skin !=value){
				this._skin=value;
				this.slider.skin=this._skin;
				this.callLater(this.changeScrollBar);
			}
		});

		/**
		*获取或设置表示最高滚动位置的数字。
		*/
		__getset(0,__proto,'max',function(){
			return this.slider.max;
			},function(value){
			this.slider.max=value;
		});

		/**获取或设置一个值，该值表示按下滚动条轨道时页面滚动的增量。 */
		__getset(0,__proto,'scrollSize',function(){
			return this._scrollSize;
			},function(value){
			this._scrollSize=value;
		});

		/**@inheritDoc */
		__getset(0,__proto,'measureHeight',function(){
			if (this.slider.isVertical)return 100;
			return this.slider.height;
		});

		/**@inheritDoc */
		__getset(0,__proto,'measureWidth',function(){
			if (this.slider.isVertical)return this.slider.width;
			return 100;
		});

		/**
		*<p>当前实例的 <code>Slider</code> 实例的有效缩放网格数据。</p>
		*<p>数据格式："上边距,右边距,下边距,左边距,是否重复填充(值为0：不重复填充，1：重复填充)"，以逗号分隔。
		*<ul><li>例如："4,4,4,4,1"</li></ul></p>
		*@see laya.ui.AutoBitmap.sizeGrid
		*/
		__getset(0,__proto,'sizeGrid',function(){
			return this.slider.sizeGrid;
			},function(value){
			this.slider.sizeGrid=value;
		});

		/**
		*获取或设置表示最低滚动位置的数字。
		*/
		__getset(0,__proto,'min',function(){
			return this.slider.min;
			},function(value){
			this.slider.min=value;
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
					this.slider.value=v;
					this._value=this.slider.value;
				}
				this.event(/*laya.events.Event.CHANGE*/"change");
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
				if (this.slider.isVertical)this.slider.bar.height=Math.max(this.slider.height *value,Styles.scrollBarMinNum);
				else this.slider.bar.width=Math.max(this.slider.width *value,Styles.scrollBarMinNum);
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
				this._target.off(/*laya.events.Event.MOUSE_WHEEL*/"mousewheel",this,this.onTargetMouseWheel);
				this._target.off(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onTargetMouseDown);
			}
			this._target=value;
			if (value){
				this._mouseWheelEnable && this._target.on(/*laya.events.Event.MOUSE_WHEEL*/"mousewheel",this,this.onTargetMouseWheel);
				this._touchScrollEnable && this._target.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onTargetMouseDown);
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
			this._bar.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onBarMouseDown);
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
			Laya.stage.on(/*laya.events.Event.MOUSE_MOVE*/"mousemove",this,this.mouseMove);
			Laya.stage.once(/*laya.events.Event.MOUSE_UP*/"mouseup",this,this.mouseUp);
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
			Laya.stage.off(/*laya.events.Event.MOUSE_MOVE*/"mousemove",this,this.mouseMove);
			this.sendChangeEvent(/*laya.events.Event.CHANGED*/"changed");
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
			(type===void 0)&& (type=/*laya.events.Event.CHANGE*/"change");
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
			if (this._tick !=value){
				this._tick=value;
				this.callLater(this.changeValue);
			}
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
				if (value)this._bg.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onBgMouseDown);
				else this._bg.off(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onBgMouseDown);
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
					if (source){
						this.source=source;
						this.onCompResize();
					}else Laya.loader.load(this._skin,Handler.create(this,this.setSource,[this._skin]),null,/*laya.net.Loader.IMAGE*/"image");
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
			this.event(/*laya.events.Event.LOADED*/"loaded");
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
		*public class Label_Example
		*{
			*public function Label_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*onInit();
				*}
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

		/**@copy laya.display.Text#changeText()
		**/
		__proto.changeText=function(text){
			this._tf.changeText(text);
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
				if(value)
					value=(value+"").replace(Label._textReg,"\n");
				this._tf.text=value;
				this.event(/*laya.events.Event.CHANGE*/"change");
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

		/**
		*@copy laya.display.Text#overflow
		*/
		/**
		*@copy laya.display.Text#overflow
		*/
		__getset(0,__proto,'overflow',function(){
			return this._tf.overflow;
			},function(value){
			this._tf.overflow=value;
		});

		/**
		*@copy laya.display.Text#underline
		*/
		/**
		*@copy laya.display.Text#underline
		*/
		__getset(0,__proto,'underline',function(){
			return this._tf.underline;
			},function(value){
			this._tf.underline=value;
		});

		/**
		*@copy laya.display.Text#underlineColor
		*/
		/**
		*@copy laya.display.Text#underlineColor
		*/
		__getset(0,__proto,'underlineColor',function(){
			return this._tf.underlineColor;
			},function(value){
			this._tf.underlineColor=value;
		});

		__static(Label,
		['_textReg',function(){return this._textReg=new RegExp("\\\\n","g");}
		]);
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
			*private function changeValue():void
			*{
				*trace("改变进度条的进度值。");
				*progressBar.value=0.6;
				*}
			*private function onChange(value:Number):void
			*{
				*trace("进度发生改变： value=" ,value);
				*}
			*}
		*}
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
			this._bar._bitmap.autoCacheCmd=false;
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
				this.event(/*laya.events.Event.CHANGE*/"change");
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


	/**鼠标提示管理类*/
	//class laya.ui.TipManager extends laya.ui.Component
	var TipManager=(function(_super){
		function TipManager(){
			this._tipBox=null;
			this._tipText=null;
			this._defaultTipHandler=null;
			TipManager.__super.call(this);
			this._tipBox=new Component();
			this._tipBox.addChild(this._tipText=new Text());
			this._tipText.x=this._tipText.y=5;
			this._tipText.color=TipManager.tipTextColor;
			this._defaultTipHandler=this._showDefaultTip;
			Laya.stage.on(/*laya.ui.UIEvent.SHOW_TIP*/"showtip",this,this._onStageShowTip);
			Laya.stage.on(/*laya.ui.UIEvent.HIDE_TIP*/"hidetip",this,this._onStageHideTip);
		}

		__class(TipManager,'laya.ui.TipManager',_super);
		var __proto=TipManager.prototype;
		/**
		*@private
		*/
		__proto._onStageHideTip=function(e){
			Laya.timer.clear(this,this._showTip);
			this.closeAll();
			this.removeSelf();
		}

		/**
		*@private
		*/
		__proto._onStageShowTip=function(data){
			Laya.timer.once(TipManager.tipDelay,this,this._showTip,[data],true);
		}

		/**
		*@private
		*/
		__proto._showTip=function(tip){
			if ((typeof tip=='string')){
				var text=String(tip);
				if (Boolean(text)){
					this._defaultTipHandler(text);
				}
				}else if ((tip instanceof laya.utils.Handler )){
				(tip).run();
				}else if ((typeof tip=='function')){
				(tip).apply();
			}
			if (true){
				Laya.stage.on(/*laya.events.Event.MOUSE_MOVE*/"mousemove",this,this._onStageMouseMove);
				Laya.stage.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this._onStageMouseDown);
			}
			this._onStageMouseMove(null);
		}

		/**
		*@private
		*/
		__proto._onStageMouseDown=function(e){
			this.closeAll();
		}

		/**
		*@private
		*/
		__proto._onStageMouseMove=function(e){
			this._showToStage(this,TipManager.offsetX,TipManager.offsetY);
		}

		/**
		*@private
		*/
		__proto._showToStage=function(dis,offX,offY){
			(offX===void 0)&& (offX=0);
			(offY===void 0)&& (offY=0);
			var rec=dis.getBounds();
			dis.x=Laya.stage.mouseX+offX;
			dis.y=Laya.stage.mouseY+offY;
			if (dis.x+rec.width > Laya.stage.width){
				dis.x-=rec.width+offX;
			}
			if (dis.y+rec.height > Laya.stage.height){
				dis.y-=rec.height+offY;
			}
		}

		/**关闭所有鼠标提示*/
		__proto.closeAll=function(){
			Laya.timer.clear(this,this._showTip);
			Laya.stage.off(/*laya.events.Event.MOUSE_MOVE*/"mousemove",this,this._onStageMouseMove);
			Laya.stage.off(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this._onStageMouseDown);
			this.removeChildren();
		}

		/**
		*显示显示对象类型的tip
		*/
		__proto.showDislayTip=function(tip){
			this.addChild(tip);
			this._showToStage(this);
			Laya.stageBox.addChild(this);
		}

		/**
		*@private
		*/
		__proto._showDefaultTip=function(text){
			this._tipText.text=text;
			var g=this._tipBox.graphics;
			g.clear();
			g.drawRect(0,0,this._tipText.width+10,this._tipText.height+10,TipManager.tipBackColor);
			this.addChild(this._tipBox);
			this._showToStage(this);
			Laya.stageBox.addChild(this);
		}

		/**默认鼠标提示函数*/
		__getset(0,__proto,'defaultTipHandler',function(){
			return this._defaultTipHandler;
			},function(value){
			this._defaultTipHandler=value;
		});

		TipManager.offsetX=10;
		TipManager.offsetY=15;
		TipManager.tipTextColor="#ffffff";
		TipManager.tipBackColor="#111111";
		TipManager.tipDelay=200;
		return TipManager;
	})(Component)


	/**
	*关键帧动画播放类
	*
	*/
	//class laya.ui.FrameClip extends laya.display.FrameAnimation
	var FrameClip=(function(_super){
		/**
		*创建一个 <code>FrameClip</code> 实例。
		*/
		function FrameClip(){
			FrameClip.__super.call(this);
		}

		__class(FrameClip,'laya.ui.FrameClip',_super);
		return FrameClip;
	})(FrameAnimation)


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
		*public class CheckBox_Example
		*{
			*public function CheckBox_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load("resource/ui/check.png",Handler.create(this,onLoadComplete));//加载资源。
				*}
			*private function onLoadComplete():void
			*{
				*trace("资源加载完成！");
				*var checkBox:CheckBox=new CheckBox("resource/ui/check.png","这个是一个CheckBox组件。");//创建一个 CheckBox 类的实例对象 checkBox ,传入它的皮肤skin和标签label。
				*checkBox.x=100;//设置 checkBox 对象的属性 x 的值，用于控制 checkBox 对象的显示位置。
				*checkBox.y=100;//设置 checkBox 对象的属性 y 的值，用于控制 checkBox 对象的显示位置。
				*checkBox.clickHandler=new Handler(this,onClick,[checkBox]);//设置 checkBox 的点击事件处理器。
				*Laya.stage.addChild(checkBox);//将此 checkBox 对象添加到显示列表。
				*}
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
			this.createText();
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
	*<code>View</code> 是一个视图类。
	*@internal <p><code>View</code></p>
	*/
	//class laya.ui.View extends laya.ui.Box
	var View=(function(_super){
		function View(){
			this._idMap=null;
			this._aniList=null;
			View.__super.call(this);
			if (this._width > 0 && !this.mouseThrough)this.hitTestPrior=true;
		}

		__class(View,'laya.ui.View',_super);
		var __proto=View.prototype;
		/**
		*@private
		*通过视图数据创建视图。
		*@param uiView 视图数据信息。
		*/
		__proto.createView=function(uiView){
			if (uiView.animations && !this._idMap)this._idMap={};
			View.createComp(uiView,this,this);
			if (uiView.animations){
				var anilist=[];
				var animations=uiView.animations;
				var i=0,len=animations.length;
				var tAni;
				var tAniO;
				for (i=0;i < len;i++){
					tAni=new FrameClip();
					tAniO=animations[i];
					tAni._setUp(this._idMap,tAniO);
					this[tAniO.name]=tAni;
					tAni._setControlNode(this);
					switch(tAniO.action){
						case 1:
							tAni.play(0,false);
							break ;
						case 2:
							tAni.play(0,true);
							break ;
						}
					anilist.push(tAni);
				}
				this._aniList=anilist;
			}
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
			if (Laya.__typeof(comp,'laya.ui.IItem'))(comp).initItems();
			if (uiView.compId&&view&&view._idMap){
				view._idMap[uiView.compId]=comp;
			}
			return comp;
		}

		View.setCompValue=function(comp,prop,value,view){
			if (prop==="var" && view){
				view[value]=comp;
			}
			else if (prop==="x" || prop==="y" || prop==="width" || prop==="height" || (typeof (comp[prop])=='number')){
				comp[prop]=parseFloat(value);
			}
			else {
				comp[prop]=(value==="true" ? true :(value==="false" ? false :value));
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
			this._labelChanged=false;
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
			this._labelChanged=false;
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

		/**@private */
		__proto._setLabelChanged=function(){
			if (!this._labelChanged){
				this._labelChanged=true;
				this.callLater(this.changeLabels);
			}
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
				this.event(/*laya.events.Event.CHANGE*/"change");
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
				this._setLabelChanged();
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
				this._setLabelChanged();
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
				this._setLabelChanged();
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
				this._setLabelChanged();
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
				this._setLabelChanged();
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
				this._setLabelChanged();
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
				this._setLabelChanged();
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
				this._setLabelChanged();
			}
		});

		/**
		*项对象们之间的间隔（以像素为单位）。
		*/
		__getset(0,__proto,'space',function(){
			return this._space;
			},function(value){
			this._space=value;
			this._setLabelChanged();
		});

		/**
		*表示按钮文本标签是否为粗体字。
		*/
		__getset(0,__proto,'labelBold',function(){
			return this._labelBold;
			},function(value){
			if (this._labelBold !=value){
				this._labelBold=value;
				this._setLabelChanged();
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
				this._setLabelChanged();
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
			this._setLabelChanged();
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
			if (((typeof value=='number')&& Math.floor(value)==value)|| (typeof value=='string'))this.selectedIndex=parseInt(value);
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
			this._itemChanged=false;
			LayoutBox.__super.call(this);
		}

		__class(LayoutBox,'laya.ui.LayoutBox',_super);
		var __proto=LayoutBox.prototype;
		/**@inheritDoc */
		__proto.addChild=function(child){
			child.on(/*laya.events.Event.RESIZE*/"resize",this,this.onResize);
			this._setItemChanged();
			return laya.display.Node.prototype.addChild.call(this,child);
		}

		__proto.onResize=function(e){
			this._setItemChanged();
		}

		/**@inheritDoc */
		__proto.addChildAt=function(child,index){
			child.on(/*laya.events.Event.RESIZE*/"resize",this,this.onResize);
			this._setItemChanged();
			return laya.display.Node.prototype.addChildAt.call(this,child,index);
		}

		/**@inheritDoc */
		__proto.removeChild=function(child){
			child.off(/*laya.events.Event.RESIZE*/"resize",this,this.onResize);
			this._setItemChanged();
			return laya.display.Node.prototype.removeChild.call(this,child);
		}

		/**@inheritDoc */
		__proto.removeChildAt=function(index){
			this.getChildAt(index).off(/*laya.events.Event.RESIZE*/"resize",this,this.onResize);
			this._setItemChanged();
			return laya.display.Node.prototype.removeChildAt.call(this,index);
		}

		/**刷新。*/
		__proto.refresh=function(){
			this._setItemChanged();
		}

		/**
		*改变子对象的布局。
		*/
		__proto.changeItems=function(){
			this._itemChanged=false;
		}

		/**
		*排序项目列表。可通过重写改变默认排序规则。
		*@param items 项目列表。
		*/
		__proto.sortItem=function(items){
			if (items)items.sort(function(a,b){return a.y > b.y ? 1 :-1
			});
		}

		__proto._setItemChanged=function(){
			if (!this._itemChanged){
				this._itemChanged=true;
				this.callLater(this.changeItems);
			}
		}

		/**子对象的间隔。*/
		__getset(0,__proto,'space',function(){
			return this._space;
			},function(value){
			this._space=value;
			this._setItemChanged();
		});

		/**子对象对齐方式。*/
		__getset(0,__proto,'align',function(){
			return this._align;
			},function(value){
			this._align=value;
			this._setItemChanged();
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
		*public class List_Example
		*{
			*public function List_Example()
			*{
				*Laya.init(640,800,"false");//设置游戏画布宽高、渲染模式。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/vscroll.png","resource/ui/vscroll$bar.png","resource/ui/vscroll$down.png","resource/ui/vscroll$up.png"],Handler.create(this,onLoadComplete));
				*}
			*private function onLoadComplete():void
			*{
				*var arr:Array=[];//创建一个数组，用于存贮列表的数据信息。
				*for (var i:int=0;i &lt;20;i++)
				*{
					*arr.push({label:"item"+i});
					*}
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
	*(function (_super){
		*function Item(){
			*Item.__super.call(this);//初始化父类
			*this.graphics.drawRect(0,0,100,20,"#ff0000");
			*var label=new laya.ui.Label();//创建一个 Label 类的实例对象 label 。
			*label.text="100000";//设置 label 的文本内容。
			*label.name="label";//设置 label 的name属性值。
			*label.size(100,20);//设置 label 的宽度、高度。
			*this.addChild(label);//将 label 添加到显示列表。
			*};
		*Laya.class(Item,"mypackage.listExample.Item",_super);//注册类 Item 。
		*})(laya.ui.Box);
	*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
	*var res=["resource/ui/vscroll.png","resource/ui/vscroll$bar.png","resource/ui/vscroll$down.png","resource/ui/vscroll$up.png"];
	*Laya.loader.load(res,new laya.utils.Handler(this,onLoadComplete));//加载资源。
	*function onLoadComplete(){
		*var arr=[];//创建一个数组，用于存贮列表的数据信息。
		*for (var i=0;i &lt;20;i++){
			*arr.push({label:"item"+i});
			*}
		*var list=new laya.ui.List();//创建一个 List 类的实例对象 list 。
		*list.itemRender=mypackage.listExample.Item;//设置 list 的单元格渲染器。
		*list.repeatX=1;//设置 list 的水平方向单元格数量。
		*list.repeatY=10;//设置 list 的垂直方向单元格数量。
		*list.vScrollBarSkin="resource/ui/vscroll.png";//设置 list 的垂直方向滚动条皮肤。
		*list.array=arr;//设置 list 的列表数据源。
		*list.pos(100,100);//设置 list 的位置。
		*list.selectEnable=true;//设置 list 可选。
		*list.selectHandler=new laya.utils.Handler(this,onSelect);//设置 list 改变选择项执行的处理器。
		*Laya.stage.addChild(list);//将 list 添加到显示列表。
		*}
	*function onSelect(index)
	*{
		*console.log("当前选择的项目索引： index= ",index);
		*}
	*
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
			this.cacheContent=false;
			this._createdLine=0;
			this._cellChanged=false;
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

		__proto.onScrollStart=function(){
			this._$P.cacheAs || (this._$P.cacheAs=_super.prototype._$get_cacheAs.call(this));
			_super.prototype._$set_cacheAs.call(this,"none");
			this._scrollBar.once(/*laya.events.Event.END*/"end",this,this.onScrollEnd);
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
			this._cellChanged=false;
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
				this._createdLine=numY;
				if (this._array){
					this.array=this._array;
					this.runCallLater(this.renderItems);
				}
			}
		}

		__proto._createItems=function(startY,numX,numY){
			var box=this._content;
			var cell=this.createItem();
			var cellWidth=cell.width+this._spaceX;
			var cellHeight=cell.height+this._spaceY;
			if (this.cacheContent){
				var cacheBox=new Box();
				cacheBox.cacheAsBitmap=true;
				cacheBox.pos((this._isVertical ? 0 :startY)*cellWidth,(this._isVertical ? startY :0)*cellHeight);
				this._content.addChild(cacheBox);
				this._content.optimizeScrollRect=true;
				box=cacheBox;
			}
			for (var k=startY;k < numY;k++){
				for (var l=0;l < numX;l++){
					cell=this.createItem();
					cell.x=(this._isVertical ? l :k)*cellWidth-box.x;
					cell.y=(this._isVertical ? k :l)*cellHeight-box.y;
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
			cell.on(/*laya.events.Event.CLICK*/"click",this,this.onCellMouse);
			cell.on(/*laya.events.Event.RIGHT_CLICK*/"rightclick",this,this.onCellMouse);
			cell.on(/*laya.events.Event.MOUSE_OVER*/"mouseover",this,this.onCellMouse);
			cell.on(/*laya.events.Event.MOUSE_OUT*/"mouseout",this,this.onCellMouse);
			cell.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onCellMouse);
			cell.on(/*laya.events.Event.MOUSE_UP*/"mouseup",this,this.onCellMouse);
			this._cells.push(cell);
		}

		/**
		*初始化单元格信息。
		*/
		__proto.initItems=function(){
			if (!this._itemRender){
				this.repeatX=1;
				var count=0;
				count=0;
				for (var i=0;i < 10000;i++){
					var cell=this.getChildByName("item"+i);
					if (cell){
						this.addCell(cell);
						count++;
						continue ;
					}
					break ;
				}
				this.repeatY=count;
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
				this._content.model&&this._content.model.scrollRect(0,0,width,height);
				this.event(/*laya.events.Event.RESIZE*/"resize");
			}
		}

		/**
		*@private
		*单元格的鼠标事件侦听处理函数。
		*/
		__proto.onCellMouse=function(e){
			if (e.type===/*laya.events.Event.MOUSE_DOWN*/"mousedown")this._isMoved=false;
			var cell=e.currentTarget;
			var index=this._startIndex+this._cells.indexOf(cell);
			if (index < 0)return;
			if (e.type===/*laya.events.Event.CLICK*/"click" || e.type===/*laya.events.Event.RIGHT_CLICK*/"rightclick"){
				if (this.selectEnable && !this._isMoved)this.selectedIndex=index;
				else this.changeCellState(cell,true,0);
				}else if ((e.type===/*laya.events.Event.MOUSE_OVER*/"mouseover" || e.type===/*laya.events.Event.MOUSE_OUT*/"mouseout")&& this._selectedIndex!==index){
				this.changeCellState(cell,e.type===/*laya.events.Event.MOUSE_OVER*/"mouseover",0);
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
			this.setContentSize(this.width,this.height);
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
			var lineX=(this._isVertical ? this.repeatX :this.repeatY);
			var lineY=(this._isVertical ? this.repeatY :this.repeatX);
			var scrollLine=Math.floor(scrollValue / this._cellSize);
			if (!this.cacheContent){
				var index=scrollLine *lineX;
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
				this.changeSelectStatus();
				}else {
				num=(lineY+1);
				if (this._createdLine-scrollLine < num){
					this._createItems(this._createdLine,lineX,this._createdLine+num);
					this._createdLine+=num;
					this.renderItems(this._createdLine *lineX,0);
				}
			};
			var r=this._content.scrollRect;
			if (this._isVertical){
				r.y=scrollValue;
			}
			else{
				r.x=scrollValue;
			}
			this._content.model&&this._content.model.scrollRect(r.x,r.y,r.width,r.height);
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
		__proto.renderItems=function(from,to){
			(from===void 0)&& (from=0);
			(to===void 0)&& (to=0);
			for (var i=0,n=to || this._cells.length;i < n;i++){
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
				if (!this.cacheContent){
					this.posCell(cell,index);
				}
				}else {
				cell.visible=false;
				cell.dataSource=null;
			}
			if (this.hasListener(/*laya.events.Event.RENDER*/"render"))this.event(/*laya.events.Event.RENDER*/"render",[cell,index]);
			if (this.renderHandler)this.renderHandler.runWith([cell,index]);
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
		*设置单元格数据源。
		*@param index 单元格索引。
		*@param source 单元格数据源。
		*/
		__proto.setItem=function(index,source){
			this.changeItem(index,source);
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
		*@param complete 缓动结束回掉
		*/
		__proto.tweenTo=function(index,time,complete){
			(time===void 0)&& (time=200);
			if (this._scrollBar){
				var numX=this._isVertical ? this.repeatX :this.repeatY;
				Tween.to(this._scrollBar,{value:Math.floor(index / numX)*this._cellSize},time,null,complete,0,true);
				}else {
				this.startIndex=index;
				if (complete)complete.run();
			}
		}

		/**@private */
		__proto._setCellChanged=function(){
			if (!this._cellChanged){
				this._cellChanged=true;
				this.callLater(this.changeCells);
			}
		}

		/**@inheritDoc */
		__getset(0,__proto,'cacheAs',_super.prototype._$get_cacheAs,function(value){
			_super.prototype._$set_cacheAs.call(this,value);
			if (this._scrollBar){
				this._$P.cacheAs=null;
				if (value!=="none")this._scrollBar.on(/*laya.events.Event.START*/"start",this,this.onScrollStart);
				else this._scrollBar.off(/*laya.events.Event.START*/"start",this,this.onScrollStart);
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
			this._setCellChanged();
		});

		/**@inheritDoc */
		__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
			_super.prototype._$set_height.call(this,value);
			this._setCellChanged();
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
			this._setCellChanged();
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
			this._setCellChanged();
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
					this._scrollBar.on(/*laya.events.Event.CHANGE*/"change",this,this.onScrollBarChange);
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
				this.event(/*laya.events.Event.CHANGE*/"change");
				this.selectHandler && this.selectHandler.runWith(value);
			}
		});

		/**@inheritDoc */
		__getset(0,__proto,'width',_super.prototype._$get_width,function(value){
			_super.prototype._$set_width.call(this,value);
			this._setCellChanged();
		});

		/**
		*水平方向显示的单元格数量。
		*/
		__getset(0,__proto,'repeatX',function(){
			return this._repeatX > 0 ? this._repeatX :this._repeatX2 > 0 ? this._repeatX2 :1;
			},function(value){
			this._repeatX=value;
			this._setCellChanged();
		});

		/**
		*垂直方向显示的单元格数量。
		*/
		__getset(0,__proto,'repeatY',function(){
			return this._repeatY > 0 ? this._repeatY :this._repeatY2 > 0 ? this._repeatY2 :1;
			},function(value){
			this._repeatY=value;
			this._setCellChanged();
		});

		/**
		*水平方向显示的单元格之间的间距（以像素为单位）。
		*/
		__getset(0,__proto,'spaceX',function(){
			return this._spaceX;
			},function(value){
			this._spaceX=value;
			this._setCellChanged();
		});

		/**
		*列表数据源。
		*/
		__getset(0,__proto,'array',function(){
			return this._array;
			},function(value){
			this.runCallLater(this.changeCells);
			this._array=value || [];
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
			this._setCellChanged();
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
			if (((typeof value=='number')&& Math.floor(value)==value)|| (typeof value=='string'))this.selectedIndex=parseInt(value);
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
			this._scrollChanged=false;
			Panel.__super.call(this);
			this.width=this.height=100;
			this._content.optimizeScrollRect=true;
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
			child.on(/*laya.events.Event.RESIZE*/"resize",this,this.onResize);
			this._setScrollChanged();
			return this._content.addChild(child);
		}

		/**
		*@private
		*子对象的 <code>Event.RESIZE</code> 事件侦听处理函数。
		*/
		__proto.onResize=function(){
			this._setScrollChanged();
		}

		/**@inheritDoc */
		__proto.addChildAt=function(child,index){
			child.on(/*laya.events.Event.RESIZE*/"resize",this,this.onResize);
			this._setScrollChanged();
			return this._content.addChildAt(child,index);
		}

		/**@inheritDoc */
		__proto.removeChild=function(child){
			child.off(/*laya.events.Event.RESIZE*/"resize",this,this.onResize);
			this._setScrollChanged();
			return this._content.removeChild(child);
		}

		/**@inheritDoc */
		__proto.removeChildAt=function(index){
			this.getChildAt(index).off(/*laya.events.Event.RESIZE*/"resize",this,this.onResize);
			this._setScrollChanged();
			return this._content.removeChildAt(index);
		}

		/**@inheritDoc */
		__proto.removeChildren=function(beginIndex,endIndex){
			(beginIndex===void 0)&& (beginIndex=0);
			(endIndex===void 0)&& (endIndex=0x7fffffff);
			for (var i=this._content.numChildren-1;i >-1;i--){
				this._content.removeChildAt(i);
			}
			this._setScrollChanged();
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
			this._scrollChanged=false;
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
			content.model&&content.model.scrollRect(0,0,width,height);
		}

		/**
		*@private
		*滚动条的<code><code>Event.MOUSE_DOWN</code>事件侦听处理函数。</code>事件侦听处理函数。
		*@param scrollBar 滚动条对象。
		*@param e Event 对象。
		*/
		__proto.onScrollBarChange=function(scrollBar){
			var rect=this._content.scrollRect;
			if (rect){
				var start=Math.round(scrollBar.value);
				scrollBar.isVertical ? rect.y=start :rect.x=start;
				this._content.model&&this._content.model.scrollRect(rect.x,rect.y,rect.width,rect.height);
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

		__proto.onScrollStart=function(){
			this._$P.cacheAs || (this._$P.cacheAs=_super.prototype._$get_cacheAs.call(this));
			_super.prototype._$set_cacheAs.call(this,"none");
			this._hScrollBar && this._hScrollBar.once(/*laya.events.Event.END*/"end",this,this.onScrollEnd);
			this._vScrollBar && this._vScrollBar.once(/*laya.events.Event.END*/"end",this,this.onScrollEnd);
		}

		__proto.onScrollEnd=function(){
			_super.prototype._$set_cacheAs.call(this,this._$P.cacheAs);
		}

		/**@private */
		__proto._setScrollChanged=function(){
			if (!this._scrollChanged){
				this._scrollChanged=true;
				this.callLater(this.changeScroll);
			}
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
			this._setScrollChanged();
		});

		/**
		*水平方向滚动条皮肤。
		*/
		__getset(0,__proto,'hScrollBarSkin',function(){
			return this._hScrollBar ? this._hScrollBar.skin :null;
			},function(value){
			if (this._hScrollBar==null){
				laya.display.Node.prototype.addChild.call(this,this._hScrollBar=new HScrollBar());
				this._hScrollBar.on(/*laya.events.Event.CHANGE*/"change",this,this.onScrollBarChange,[this._hScrollBar]);
				this._hScrollBar.target=this._content;
				this._setScrollChanged();
			}
			this._hScrollBar.skin=value;
		});

		/**@inheritDoc */
		__getset(0,__proto,'height',_super.prototype._$get_height,function(value){
			_super.prototype._$set_height.call(this,value);
			this._setScrollChanged();
		});

		/**
		*垂直方向滚动条皮肤。
		*/
		__getset(0,__proto,'vScrollBarSkin',function(){
			return this._vScrollBar ? this._vScrollBar.skin :null;
			},function(value){
			if (this._vScrollBar==null){
				laya.display.Node.prototype.addChild.call(this,this._vScrollBar=new VScrollBar());
				this._vScrollBar.on(/*laya.events.Event.CHANGE*/"change",this,this.onScrollBarChange,[this._vScrollBar]);
				this._vScrollBar.target=this._content;
				this._setScrollChanged();
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
			this._$P.cacheAs=null;
			if (value!=="none"){
				this._hScrollBar && this._hScrollBar.on(/*laya.events.Event.START*/"start",this,this.onScrollStart);
				this._vScrollBar && this._vScrollBar.on(/*laya.events.Event.START*/"start",this,this.onScrollStart);
				}else {
				this._hScrollBar && this._hScrollBar.off(/*laya.events.Event.START*/"start",this,this.onScrollStart);
				this._vScrollBar && this._vScrollBar.off(/*laya.events.Event.START*/"start",this,this.onScrollStart);
			}
		});

		return Panel;
	})(Box)


	/**
	*使用 <code>HScrollBar</code> （水平 <code>ScrollBar</code> ）控件，可以在因数据太多而不能在显示区域完全显示时控制显示的数据部分。
	*@example 以下示例代码，创建了一个 <code>HScrollBar</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.HScrollBar;
		*import laya.utils.Handler;
		*public class HScrollBar_Example
		*{
			*private var hScrollBar:HScrollBar;
			*public function HScrollBar_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/hscroll.png","resource/ui/hscroll$bar.png","resource/ui/hscroll$down.png","resource/ui/hscroll$up.png"],Handler.create(this,onLoadComplete));//加载资源。
				*}
			*private function onLoadComplete():void
			*{
				*hScrollBar=new HScrollBar();//创建一个 HScrollBar 类的实例对象 hScrollBar 。
				*hScrollBar.skin="resource/ui/hscroll.png";//设置 hScrollBar 的皮肤。
				*hScrollBar.x=100;//设置 hScrollBar 对象的属性 x 的值，用于控制 hScrollBar 对象的显示位置。
				*hScrollBar.y=100;//设置 hScrollBar 对象的属性 y 的值，用于控制 hScrollBar 对象的显示位置。
				*hScrollBar.changeHandler=new Handler(this,onChange);//设置 hScrollBar 的滚动变化处理器。
				*Laya.stage.addChild(hScrollBar);//将此 hScrollBar 对象添加到显示列表。
				*}
			*private function onChange(value:Number):void
			*{
				*trace("滚动条的位置： value="+value);
				*}
			*}
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*var hScrollBar;
	*var res=["resource/ui/hscroll.png","resource/ui/hscroll$bar.png","resource/ui/hscroll$down.png","resource/ui/hscroll$up.png"];
	*Laya.loader.load(res,laya.utils.Handler.create(this,onLoadComplete));//加载资源。
	*function onLoadComplete(){
		*console.log("资源加载完成！");
		*hScrollBar=new laya.ui.HScrollBar();//创建一个 HScrollBar 类的实例对象 hScrollBar 。
		*hScrollBar.skin="resource/ui/hscroll.png";//设置 hScrollBar 的皮肤。
		*hScrollBar.x=100;//设置 hScrollBar 对象的属性 x 的值，用于控制 hScrollBar 对象的显示位置。
		*hScrollBar.y=100;//设置 hScrollBar 对象的属性 y 的值，用于控制 hScrollBar 对象的显示位置。
		*hScrollBar.changeHandler=new laya.utils.Handler(this,onChange);//设置 hScrollBar 的滚动变化处理器。
		*Laya.stage.addChild(hScrollBar);//将此 hScrollBar 对象添加到显示列表。
		*}
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
			this.slider.isVertical=false;
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
			this.createText();
			this._text.align="left";
			this._text.valign="top";
			this._text.width=0;
			this.on(/*laya.events.Event.CLICK*/"click",this,this.onClick);
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
		*public class HSlider_Example
		*{
			*private var hSlider:HSlider;
			*public function HSlider_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/hslider.png","resource/ui/hslider$bar.png"],Handler.create(this,onLoadComplete));//加载资源。
				*}
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
			*private function onChange(value:Number):void
			*{
				*trace("滑块的位置： value="+value);
				*}
			*}
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
		*private onChange(value:number):void {
			*console.log("滑块的位置： value="+value);
			*}
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
	*<code>Tree</code> 控件使用户可以查看排列为可扩展树的层次结构数据。
	*
	*@example 以下示例代码，创建了一个 <code>Tree</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.Tree;
		*import laya.utils.Browser;
		*import laya.utils.Handler;
		*public class Tree_Example
		*{
			*public function Tree_Example()
			*{
				*Laya.init(640,800);
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/vscroll.png","resource/ui/vscroll$bar.png","resource/ui/vscroll$down.png","resource/ui/vscroll$up.png","resource/ui/clip_selectBox.png","resource/ui/clip_tree_folder.png","resource/ui/clip_tree_arrow.png"],Handler.create(this,onLoadComplete));
				*}
			*private function onLoadComplete():void
			*{
				*var xmlString:String;//创建一个xml字符串，用于存储树结构数据。
				*xmlString="&lt;root&gt;&lt;item label='box1'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;abc label='child5'/&gt;&lt;/item&gt;&lt;item label='box2'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;/item&gt;&lt;/root&gt;";
				*var domParser:*=new Browser.window.DOMParser();//创建一个DOMParser实例domParser。
				*var xml:*=domParser.parseFromString(xmlString,"text/xml");//解析xml字符。
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
			*var selectBox:Clip=new Clip("resource/ui/clip_selectBox.png",1,2);
			*selectBox.name="selectBox";
			*selectBox.height=24;
			*selectBox.x=13;
			*selectBox.y=0;
			*selectBox.left=12;
			*addChild(selectBox);
			*var folder:Clip=new Clip("resource/ui/clip_tree_folder.png",1,3);
			*folder.name="folder";
			*folder.x=14;
			*folder.y=4;
			*addChild(folder);
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
			*var arrow:Clip=new Clip("resource/ui/clip_tree_arrow.png",1,2);
			*arrow.name="arrow";
			*arrow.x=0;
			*arrow.y=5;
			*addChild(arrow);
			*}
		*}
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
		*constructor(){
			*Laya.init(640,800);
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load(["resource/ui/vscroll.png","resource/ui/vscroll$bar.png","resource/ui/vscroll$down.png","resource/ui/vscroll$up.png","resource/ui/vscroll$up.png","resource/ui/clip_selectBox.png","resource/ui/clip_tree_folder * . * png","resource/ui/clip_tree_arrow.png"],Handler.create(this,this.onLoadComplete));
			*}
		*private onLoadComplete():void {
			*var xmlString:String;//创建一个xml字符串，用于存储树结构数据。
			*xmlString="&lt;root&gt;&lt;item label='box1'&gt;&lt;abc label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;abc label='child5'/&gt;&lt;/item&gt;&lt;item label='box2'&gt;&lt;abc  * label='child1'/&gt;&lt;abc label='child2'/&gt;&lt;abc label='child3'/&gt;&lt;abc label='child4'/&gt;&lt;/item&gt;&lt;/root&gt;";
			*var domParser:any=new Browser.window.DOMParser();//创建一个DOMParser实例domParser。
			*var xml:any=domParser.parseFromString(xmlString,"text/xml");//解析xml字符。
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
			*var folder:Clip=new Clip("resource/ui/clip_tree_folder.png",1,3);
			*folder.name="folder";
			*folder.x=14;
			*folder.y=4;
			*this.addChild(folder);
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
			this._list.on(/*laya.events.Event.CHANGE*/"change",this,this.onListChange);
		}

		/**
		*@private
		*此对象包含的<code>List</code>实例的<code>Event.CHANGE</code>事件侦听处理函数。
		*/
		__proto.onListChange=function(e){
			this.event(/*laya.events.Event.CHANGE*/"change");
		}

		/**
		*@private
		*获取数据源集合。
		*/
		__proto.getArray=function(){
			var arr=[];
			var item;
			/*for each*/for(var $each_item in this._source){
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
						arrow.off(/*laya.events.Event.CLICK*/"click",this,this.onArrowClick);
						arrow.on(/*laya.events.Event.CLICK*/"click",this,this.onArrowClick);
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
				/*for each*/for(var $each_attrs in list2){
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
			/*for each*/for(var $each_item in array){
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
			_super.prototype._$set_dataSource.call(this,value);
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
				this.selectedIndex=parseInt(value);
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
		*public class VScrollBar_Example
		*{
			*private var vScrollBar:VScrollBar;
			*public function VScrollBar_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/vscroll.png","resource/ui/vscroll$bar.png","resource/ui/vscroll$down.png","resource/ui/vscroll$up.png"],Handler.create(this,onLoadComplete));
				*}
			*private function onLoadComplete():void
			*{
				*vScrollBar=new VScrollBar();//创建一个 vScrollBar 类的实例对象 hScrollBar 。
				*vScrollBar.skin="resource/ui/vscroll.png";//设置 vScrollBar 的皮肤。
				*vScrollBar.x=100;//设置 vScrollBar 对象的属性 x 的值，用于控制 vScrollBar 对象的显示位置。
				*vScrollBar.y=100;//设置 vScrollBar 对象的属性 y 的值，用于控制 vScrollBar 对象的显示位置。
				*vScrollBar.changeHandler=new Handler(this,onChange);//设置 vScrollBar 的滚动变化处理器。
				*Laya.stage.addChild(vScrollBar);//将此 vScrollBar 对象添加到显示列表。
				*}
			*private function onChange(value:Number):void
			*{
				*trace("滚动条的位置： value="+value);
				*}
			*}
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
		*private onLoadComplete():void {
			*this.vScrollBar=new VScrollBar();//创建一个 vScrollBar 类的实例对象 hScrollBar 。
			*this.vScrollBar.skin="resource/ui/vscroll.png";//设置 vScrollBar 的皮肤。
			*this.vScrollBar.x=100;//设置 vScrollBar 对象的属性 x 的值，用于控制 vScrollBar 对象的显示位置。
			*this.vScrollBar.y=100;//设置 vScrollBar 对象的属性 y 的值，用于控制 vScrollBar 对象的显示位置。
			*this.vScrollBar.changeHandler=new Handler(this,this.onChange);//设置 vScrollBar 的滚动变化处理器。
			*Laya.stage.addChild(this.vScrollBar);//将此 vScrollBar 对象添加到显示列表。
			*}
		*private onChange(value:number):void {
			*console.log("滚动条的位置： value="+value);
			*}
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
	*<code>TextInput</code> 类用于创建显示对象以显示和输入文本。
	*
	*@example 以下示例代码，创建了一个 <code>TextInput</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.display.Stage;
		*import laya.ui.TextInput;
		*import laya.utils.Handler;
		*public class TextInput_Example
		*{
			*public function TextInput_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/input.png"],Handler.create(this,onLoadComplete));//加载资源。
				*}
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
			*}
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
			this._tf.on(/*laya.events.Event.INPUT*/"input",this,this.onInput);
			this._tf.on(/*laya.events.Event.ENTER*/"enter",this,this.onEnter);
			this._tf.on(/*laya.events.Event.BLUR*/"blur",this,this.onBlur);
			this._tf.on(/*laya.events.Event.FOCUS*/"focus",this,this.onFocus);
		}

		/**
		*@private
		*/
		__proto.onFocus=function(e){
			this.event(/*laya.events.Event.FOCUS*/"focus",this);
		}

		/**
		*@private
		*/
		__proto.onBlur=function(e){
			this.event(/*laya.events.Event.BLUR*/"blur",this);
		}

		/**
		*@private
		*/
		__proto.onInput=function(e){
			this.event(/*laya.events.Event.INPUT*/"input",this);
		}

		/**
		*@private
		*/
		__proto.onEnter=function(e){
			this.event(/*laya.events.Event.ENTER*/"enter",this);
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

		/**
		*@copy laya.display.Input#prompt
		*/
		__getset(0,__proto,'prompt',function(){
			return (this._tf).prompt;
			},function(value){
			(this._tf).prompt=value;
		});

		/**限制输入的字符。*/
		__getset(0,__proto,'restrict',function(){
			return (this._tf).restrict;
			},function(pattern){
			(this._tf).restrict=pattern;
		});

		/**
		*@copy laya.display.Input#maxChars
		*/
		__getset(0,__proto,'maxChars',function(){
			return (this._tf).maxChars;
			},function(value){
			(this._tf).maxChars=value;
		});

		/**
		*@copy laya.display.Input#focus
		*/
		__getset(0,__proto,'focus',function(){
			return (this._tf).focus;
			},function(value){
			(this._tf).focus=value;
		});

		return TextInput;
	})(Label)


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
		*public class VSlider_Example
		*{
			*private var vSlider:VSlider;
			*public function VSlider_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/vslider.png","resource/ui/vslider$bar.png"],Handler.create(this,onLoadComplete));//加载资源。
				*}
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
			*private function onChange(value:Number):void
			*{
				*trace("滑块的位置： value="+value);
				*}
			*}
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
		*private onChange(value:number):void {
			*console.log("滑块的位置： value="+value);
			*}
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
	*<code>Dialog</code> 组件是一个弹出对话框。
	*
	*@example 以下示例代码，创建了一个 <code>Dialog</code> 实例。
	*<listing version="3.0">
	*package
	*{
		*import laya.ui.Dialog;
		*import laya.utils.Handler;
		*public class Dialog_Example
		*{
			*private var dialog:Dialog_Instance;
			*public function Dialog_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高、渲染模式。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load("resource/ui/btn_close.png",Handler.create(this,onLoadComplete));//加载资源。
				*}
			*private function onLoadComplete():void
			*{
				*dialog=new Dialog_Instance();//创建一个 Dialog_Instance 类的实例对象 dialog。
				*dialog.dragArea="0,0,150,50";//设置 dialog 的拖拽区域。
				*dialog.show();//显示 dialog。
				*dialog.closeHandler=new Handler(this,onClose);//设置 dialog 的关闭函数处理器。
				*}
			*private function onClose(name:String):void
			*{
				*if (name==Dialog.CLOSE)
				*{
					*trace("通过点击 name 为"+name+"的组件，关闭了dialog。");
					*}
				*}
			*}
		*}
	*import laya.ui.Button;
	*import laya.ui.Dialog;
	*import laya.ui.Image;
	*class Dialog_Instance extends Dialog
	*{
		*function Dialog_Instance():void
		*{
			*var bg:Image=new Image("resource/ui/bg.png");
			*bg.sizeGrid="40,10,5,10";
			*bg.width=150;
			*bg.height=250;
			*addChild(bg);
			*var image:Image=new Image("resource/ui/image.png");
			*addChild(image);
			*var button:Button=new Button("resource/ui/btn_close.png");
			*button.name=Dialog.CLOSE;//设置button的name属性值。
			*button.x=0;
			*button.y=0;
			*addChild(button);
			*}
		*}
	*</listing>
	*<listing version="3.0">
	*Laya.init(640,800);//设置游戏画布宽高、渲染模式
	*Laya.stage.bgColor="#efefef";//设置画布的背景颜色
	*var dialog;
	*Laya.loader.load("resource/ui/btn_close.png",laya.utils.Handler.create(this,loadComplete));//加载资源
	*(function (_super){//新建一个类Dialog_Instance继承自laya.ui.Dialog。
		*function Dialog_Instance(){
			*Dialog_Instance.__super.call(this);//初始化父类
			*var bg=new laya.ui.Image("resource/ui/bg.png");//新建一个 Image 类的实例 bg 。
			*bg.sizeGrid="10,40,10,5";//设置 bg 的网格信息。
			*bg.width=150;//设置 bg 的宽度。
			*bg.height=250;//设置 bg 的高度。
			*this.addChild(bg);//将 bg 添加到显示列表。
			*var image=new laya.ui.Image("resource/ui/image.png");//新建一个 Image 类的实例 image 。
			*this.addChild(image);//将 image 添加到显示列表。
			*var button=new laya.ui.Button("resource/ui/btn_close.png");//新建一个 Button 类的实例 bg 。
			*button.name=laya.ui.Dialog.CLOSE;//设置 button 的 name 属性值。
			*button.x=0;//设置 button 对象的属性 x 的值，用于控制 button 对象的显示位置。
			*button.y=0;//设置 button 对象的属性 y 的值，用于控制 button 对象的显示位置。
			*this.addChild(button);//将 button 添加到显示列表。
			*};
		*Laya.class(Dialog_Instance,"mypackage.dialogExample.Dialog_Instance",_super);//注册类Dialog_Instance。
		*})(laya.ui.Dialog);
	*function loadComplete(){
		*console.log("资源加载完成！");
		*dialog=new mypackage.dialogExample.Dialog_Instance();//创建一个 Dialog_Instance 类的实例对象 dialog。
		*dialog.dragArea="0,0,150,50";//设置 dialog 的拖拽区域。
		*dialog.show();//显示 dialog。
		*dialog.closeHandler=new laya.utils.Handler(this,onClose);//设置 dialog 的关闭函数处理器。
		*}
	*function onClose(name){
		*if (name==laya.ui.Dialog.CLOSE){
			*console.log("通过点击 name 为"+name+"的组件，关闭了dialog。");
			*}
		*}
	*</listing>
	*<listing version="3.0">
	*import Dialog=laya.ui.Dialog;
	*import Handler=laya.utils.Handler;
	*class Dialog_Example {
		*private dialog:Dialog_Instance;
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load("resource/ui/btn_close.png",Handler.create(this,this.onLoadComplete));//加载资源。
			*}
		*private onLoadComplete():void {
			*this.dialog=new Dialog_Instance();//创建一个 Dialog_Instance 类的实例对象 dialog。
			*this.dialog.dragArea="0,0,150,50";//设置 dialog 的拖拽区域。
			*this.dialog.show();//显示 dialog。
			*this.dialog.closeHandler=new Handler(this,this.onClose);//设置 dialog 的关闭函数处理器。
			*}
		*private onClose(name:string):void {
			*if (name==Dialog.CLOSE){
				*console.log("通过点击 name 为"+name+"的组件，关闭了dialog。");
				*}
			*}
		*}
	*import Button=laya.ui.Button;
	*class Dialog_Instance extends Dialog {
		*Dialog_Instance():void {
			*var bg:laya.ui.Image=new laya.ui.Image("resource/ui/bg.png");
			*bg.sizeGrid="40,10,5,10";
			*bg.width=150;
			*bg.height=250;
			*this.addChild(bg);
			*var image:laya.ui.Image=new laya.ui.Image("resource/ui/image.png");
			*this.addChild(image);
			*var button:Button=new Button("resource/ui/btn_close.png");
			*button.name=Dialog.CLOSE;//设置button的name属性值。
			*button.x=0;
			*button.y=0;
			*this.addChild(button);
			*}
		*}
	*</listing>
	*/
	//class laya.ui.Dialog extends laya.ui.View
	var Dialog=(function(_super){
		var DialogManager;
		function Dialog(){
			this.popupCenter=true;
			this.closeHandler=null;
			this._dragArea=null;
			Dialog.__super.call(this);
		}

		__class(Dialog,'laya.ui.Dialog',_super);
		var __proto=Dialog.prototype;
		/**@inheritDoc */
		__proto.initialize=function(){
			var dragTarget=this.getChildByName("drag");
			if (dragTarget){
				this.dragArea=dragTarget.x+","+dragTarget.y+","+dragTarget.width+","+dragTarget.height;
				dragTarget.removeSelf();
			}
			this.on(/*laya.events.Event.CLICK*/"click",this,this.onClick);
		}

		/**
		*@private (protected)
		*对象的 <code>Event.CLICK</code> 点击事件侦听处理函数。
		*/
		__proto.onClick=function(e){
			var btn=e.target;
			if (btn){
				switch (btn.name){
					case "close":
					case "cancel":
					case "sure":
					case "no":
					case "ok":
					case "yes":
						this.close(btn.name);
						break ;
					}
			}
		}

		/**
		*显示对话框（以非模式窗口方式显示）。
		*@param closeOther 是否关闭其它的对话框。若值为true则关闭其它对话框。
		*/
		__proto.show=function(closeOther){
			(closeOther===void 0)&& (closeOther=false);
			Dialog.manager.show(this,closeOther);
		}

		/**
		*显示对话框（以模式窗口方式显示）。
		*@param closeOther 是否关闭其它的对话框。若值为true则关闭其它对话框。
		*/
		__proto.popup=function(closeOther){
			(closeOther===void 0)&& (closeOther=false);
			Dialog.manager.popup(this,closeOther);
		}

		/**
		*关闭对话框。
		*@param type 如果是点击默认关闭按钮触发，则传入关闭按钮的名字(name)，否则为null。
		*/
		__proto.close=function(type){
			Dialog.manager.close(this);
			this.closeHandler && this.closeHandler.runWith(type);
		}

		/**
		*@private
		*/
		__proto.onMouseDown=function(e){
			var point=this.getMousePoint();
			if (this._dragArea.contains(point.x,point.y))this.startDrag();
			else this.stopDrag();
		}

		/**
		*用来指定对话框的拖拽区域。默认值为"0,0,0,0"。
		*<p><b>格式：</b>构成一个矩形所需的 x,y,width,heith 值，用逗号连接为字符串。
		*例如："0,0,100,200"。
		*</p>
		*
		*@see #includeExamplesSummary 请参考示例
		*@return
		*/
		__getset(0,__proto,'dragArea',function(){
			if (this._dragArea)return this._dragArea.toString();
			return null;
			},function(value){
			if (value){
				var a=UIUtils.fillArray([0,0,0,0],value,Number);
				this._dragArea=new Rectangle(a[0],a[1],a[2],a[3]);
				this.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onMouseDown);
				}else {
				this._dragArea=null;
				this.off(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.onMouseDown);
			}
		});

		/**
		*弹出框的显示状态；如果弹框处于显示中，则为true，否则为false;
		*@return
		*/
		__getset(0,__proto,'isPopup',function(){
			return this.parent !=null;
		});

		/**@private 获取对话框管理器。*/
		__getset(1,Dialog,'manager',function(){
			return Dialog._manager || (Dialog._manager=new DialogManager());
		},laya.ui.View._$SET_manager);

		Dialog.closeAll=function(){
			Dialog.manager.closeAll();
		}

		Dialog.CLOSE="close";
		Dialog.CANCEL="cancel";
		Dialog.SURE="sure";
		Dialog.NO="no";
		Dialog.OK="ok";
		Dialog.YES="yes";
		Dialog._manager=null
		Dialog.__init$=function(){
			/**
			*<code>DialogManager</code> 类用来管理对话框。
			*/
			//class DialogManager extends laya.display.Sprite
			DialogManager=(function(_super){
				function DialogManager(){
					this._stage=null;
					DialogManager.__super.call(this);
					this.dialogLayer=new Sprite();
					this.modalLayer=new Sprite();
					this.mouseEnabled=this.dialogLayer.mouseEnabled=this.modalLayer.mouseEnabled=true;
					this.addChild(this.dialogLayer);
					this._stage=Laya.stage;
					this._stage.addChild(this);
					this._stage.on(/*laya.events.Event.RESIZE*/"resize",this,this.onResize);
					this.onResize(null);
				}
				__class(DialogManager,'',_super);
				var __proto=DialogManager.prototype;
				/**
				*@private
				*舞台的 <code>Event.RESIZE</code> 事件侦听处理函数。
				*@param e
				*/
				__proto.onResize=function(e){
					var width=this.modalLayer.width=this._stage.width;
					var height=this.modalLayer.height=this._stage.height;
					this.modalLayer.graphics.clear();
					this.modalLayer.graphics.alpha(UIConfig.popupBgAlpha);
					this.modalLayer.graphics.drawRect(0,0,width,height,UIConfig.popupBgColor);
					this.modalLayer.graphics.alpha(1 / UIConfig.popupBgAlpha);
					for (var i=this.dialogLayer.numChildren-1;i >-1;i--){
						var item=this.dialogLayer.getChildAt(i);
						if (item.popupCenter)this._centerDialog(item);
					}
					for (i=this.modalLayer.numChildren-1;i >-1;i--){
						item=this.modalLayer.getChildAt(i);
						if (item.isPopup){
							if (item.popupCenter)this._centerDialog(item);
						}
					}
				}
				__proto._centerDialog=function(dialog){
					dialog.x=Math.round(((this._stage.width-dialog.width)>> 1)+dialog.pivotX);
					dialog.y=Math.round(((this._stage.height-dialog.height)>> 1)+dialog.pivotY);
				}
				/**
				*显示对话框(非模式窗口类型)。
				*@param dialog 需要显示的对象框 <code>Dialog</code> 实例。
				*@param closeOther 是否关闭其它对话框，若值为ture，则关闭其它的对话框。
				*/
				__proto.show=function(dialog,closeOther){
					(closeOther===void 0)&& (closeOther=false);
					if (closeOther)this.dialogLayer.removeChildren();
					if (dialog.popupCenter)this._centerDialog(dialog);
					this.dialogLayer.addChild(dialog);
					this.event(/*laya.events.Event.OPEN*/"open");
				}
				/**
				*显示对话框(模式窗口类型)。
				*@param dialog 需要显示的对象框 <code>Dialog</code> 实例。
				*@param closeOther 是否关闭其它对话框，若值为ture，则关闭其它的对话框。
				*/
				__proto.popup=function(dialog,closeOther){
					(closeOther===void 0)&& (closeOther=false);
					if (closeOther)this.modalLayer.removeChildren();
					if (dialog.popupCenter)this._centerDialog(dialog);
					this.modalLayer.addChild(dialog);
					this.addChild(this.modalLayer);
					this.event(/*laya.events.Event.OPEN*/"open");
				}
				/**
				*关闭对话框。
				*@param dialog 需要关闭的对象框 <code>Dialog</code> 实例。
				*/
				__proto.close=function(dialog){
					dialog.removeSelf();
					if (this.modalLayer.numChildren===0){
						this.modalLayer.removeSelf();
						}else {
						this.showFirst();
					}
					this.event(/*laya.events.Event.CLOSE*/"close");
				}
				/**
				*@private
				*/
				__proto.showFirst=function(){
					for (var i=0,n=this.modalLayer.numChildren-1;i <=n;i++){
						(this.modalLayer.getChildAt(i)).visible=i===n;
					}
				}
				/**
				*关闭所有的对话框。
				*/
				__proto.closeAll=function(){
					this.dialogLayer.removeChildren();
					this.modalLayer.removeChildren();
					this.modalLayer.removeSelf();
					this.event(/*laya.events.Event.CLOSE*/"close");
				}
				return DialogManager;
			})(Sprite)
		}

		return Dialog;
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
			this._itemChanged=false;
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
			/*for each*/for($each_item in items){
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
		*public class RadioGroup_Example
		*{
			*public function RadioGroup_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/radio.png"],Handler.create(this,onLoadComplete));//加载资源。
				*}
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
			*private function onSelect(index:int):void
			*{
				*trace("当前选择的单选按钮索引: index= ",index);
				*}
			*}
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
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load(["resource/ui/radio.png"],Handler.create(this,this.onLoadComplete));//加载资源。
			*}
		*private onLoadComplete():void {
			*var radioGroup:RadioGroup=new RadioGroup();//创建一个 RadioGroup 类的实例对象 radioGroup 。
			*radioGroup.pos(100,100);//设置 radioGroup 的位置信息。
			*radioGroup.labels="item0,item1,item2";//设置 radioGroup 的标签集。
			*radioGroup.skin="resource/ui/radio.png";//设置 radioGroup 的皮肤。
			*radioGroup.space=10;//设置 radioGroup 的项间隔距离。
			*radioGroup.selectHandler=new Handler(this,this.onSelect);//设置 radioGroup 的选择项发生改变时执行的处理器。
			*Laya.stage.addChild(radioGroup);//将 radioGroup 添加到显示列表。
			*}
		*private onSelect(index:number):void {
			*console.log("当前选择的单选按钮索引: index= ",index);
			*}
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
		*public class Tab_Example
		*{
			*public function Tab_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/tab.png"],Handler.create(this,onLoadComplete));//加载资源。
				*}
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
		*constructor(){
			*Laya.init(640,800);//设置游戏画布宽高。
			*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
			*Laya.loader.load(["resource/ui/tab.png"],Handler.create(this,this.onLoadComplete));//加载资源。
			*}
		*private onLoadComplete():void {
			*var tab:Tab=new Tab();//创建一个 Tab 类的实例对象 tab 。
			*tab.skin="resource/ui/tab.png";//设置 tab 的皮肤。
			*tab.labels="item0,item1,item2";//设置 tab 的标签集。
			*tab.x=100;//设置 tab 对象的属性 x 的值，用于控制 tab 对象的显示位置。
			*tab.y=100;//设置 tab 对象的属性 y 的值，用于控制 tab 对象的显示位置。
			*tab.selectHandler=new Handler(this,this.onSelect);//设置 tab 的选择项发生改变时执行的处理器。
			*Laya.stage.addChild(tab);//将 tab 添到显示列表。
			*}
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
			this._itemChanged=false;
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
			/*for each*/for($each_item in items){
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
		*public class TextArea_Example
		*{
			*public function TextArea_Example()
			*{
				*Laya.init(640,800);//设置游戏画布宽高。
				*Laya.stage.bgColor="#efefef";//设置画布的背景颜色。
				*Laya.loader.load(["resource/ui/input.png"],Handler.create(this,onLoadComplete));//加载资源。
				*}
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
			*}
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


	Laya.__init([Dialog]);
})(window,document,Laya);
