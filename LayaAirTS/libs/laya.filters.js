
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Browser=laya.utils.Browser,ColorFilterAction=laya.filters.ColorFilterAction,Sprite=laya.display.Sprite;
	var Filter=laya.filters.Filter,Matrix=laya.maths.Matrix,Rectangle=laya.maths.Rectangle,Point=laya.maths.Point;
	var Render=laya.renders.Render,RenderContext=laya.renders.RenderContext,RenderSprite=laya.renders.RenderSprite;
	var System=laya.system.System,ColorFilterActionGL=laya.filters.webgl.ColorFilterActionGL,RenderTarget2D=laya.webgl.resource.RenderTarget2D;
	var Color=laya.utils.Color,Texture=laya.resource.Texture,FilterActionGL=laya.filters.webgl.FilterActionGL;
	//class laya.filters.GlowFilterAction
	var GlowFilterAction=(function(){
		function GlowFilterAction(){
			this.data=null;
		}

		__class(GlowFilterAction,'laya.filters.GlowFilterAction');
		var __proto=GlowFilterAction.prototype;
		Laya.imps(__proto,{"laya.filters.IFilterAction":true})
		__proto.apply=function(srcCanvas){
			var sCtx=srcCanvas.ctx.ctx;
			var sCanvas=srcCanvas.ctx.ctx.canvas;
			var canvas=GlowFilterAction.Canvas;
			var ctx=GlowFilterAction.Ctx;
			canvas.width=sCanvas.width;
			canvas.height=sCanvas.height;
			ctx.shadowBlur=this.data.blur;
			ctx.shadowColor=this.data.color;
			ctx.shadowOffsetX=this.data.offX;
			ctx.shadowOffsetY=this.data.offY;
			ctx.drawImage(sCanvas,0,0);
			sCtx.width=sCtx.width;
			sCtx.drawImage(canvas,0,0);
			return sCanvas;
		}

		__static(GlowFilterAction,
		['Canvas',function(){return this.Canvas=Browser.createElement("canvas");},'Ctx',function(){return this.Ctx=GlowFilterAction.Canvas.getContext('2d');}
		]);
		return GlowFilterAction;
	})()


	//class laya.filters.WebGLFilter
	var WebGLFilter=(function(){
		function WebGLFilter(){};
		__class(WebGLFilter,'laya.filters.WebGLFilter');
		WebGLFilter.enable=function(){
			if (WebGLFilter.isInit)return;
			WebGLFilter.isInit=true;
			if (!Render.isWebGl)return;
			System.createFilterAction=function (type){
				var action;
				switch(type){
					case /*laya.filters.Filter.COLOR*/0x20:
						action=new ColorFilterActionGL();
						break ;
					case /*laya.filters.Filter.BLUR*/0x10:
						action=new BlurFilterActionGL();
						break ;
					case /*laya.filters.Filter.GLOW*/0x08:
						action=new GlowFilterActionGL();
						break ;
					}
				return action;
			}
			Filter._filterStart=function (scope,sprite,context,x,y){
				var b=scope.getValue("bounds");
				var source=RenderTarget2D.create(b.width+20,b.height+20);
				source.start();
				scope.addValue("src",source);
			}
			Filter._filterEnd=function (scope,sprite,context,x,y){
				var b=scope.getValue("bounds");
				var source=scope.getValue("src");
				source.end();
				var out=RenderTarget2D.create(b.width+20,b.height+20);
				out.start();
				scope.addValue("out",out);
				sprite._filterCache=out;
			}
			Filter._EndTarget=function (scope){
				var out=scope.getValue("out");
				out.end();
			}
			Filter._recycleScope=function (scope){
				scope.recycle();
			}
		}

		WebGLFilter.isInit=false;
		WebGLFilter.__init$=function(){{
				System.createFilterAction=
				function (type){
					var action;
					switch(type){
						case /*laya.filters.Filter.BLUR*/0x10:
							action=new BlurFilter();
							break ;
						case /*laya.filters.Filter.GLOW*/0x08:
							action=new GlowFilterAction();
							break ;
						case /*laya.filters.Filter.COLOR*/0x20:
							action=new ColorFilterAction();
							break ;
						}
					return action;
				}
			}
		}

		return WebGLFilter;
	})()


	/**
	*webgl ok ,canvas unok
	*
	*/
	//class laya.filters.BlurFilter extends laya.filters.Filter
	var BlurFilter=(function(_super){
		function BlurFilter(strength){
			//this._blurX=0;
			//this._blurY=0;
			//this.strength=NaN;
			(strength===void 0)&& (strength=4);
			BlurFilter.__super.call(this);
			this.strength=strength;
			this._action=System.createFilterAction(0x10);
			this._action.data=this;
		}

		__class(BlurFilter,'laya.filters.BlurFilter',_super);
		var __proto=BlurFilter.prototype;
		__getset(0,__proto,'action',function(){
			return this._action;
		});

		__getset(0,__proto,'type',function(){
			return 0x10;
		});

		return BlurFilter;
	})(Filter)


	/**
	*发光滤镜
	*@author ww
	*@version 1.0
	*@created 2015-9-18 下午7:10:26
	*/
	//class laya.filters.GlowFilter extends laya.filters.Filter
	var GlowFilter=(function(_super){
		function GlowFilter(color,blur,offX,offY){
			//this._color=null;
			this._blurX=true;
			GlowFilter.__super.call(this);
			this.elements=new Float32Array(9);
			(blur===void 0)&& (blur=4);
			(offX===void 0)&& (offX=6);
			(offY===void 0)&& (offY=6);
			WebGLFilter.enable();
			this.color=color;
			this.blur=blur;
			this.offX=offX;
			this.offY=offY;
			this._action=System.createFilterAction(0x08);
			this._action.data=this;
		}

		__class(GlowFilter,'laya.filters.GlowFilter',_super);
		var __proto=GlowFilter.prototype;
		__getset(0,__proto,'type',function(){return 0});
		__getset(0,__proto,'offX',function(){
			return this.elements[5];
			},function(value){
			this.elements[5]=value;
		});

		__getset(0,__proto,'offY',function(){
			return this.elements[6];
			},function(value){
			this.elements[6]=value;
		});

		__getset(0,__proto,'blur',function(){
			return this.elements[4];
			},function(value){
			this.elements[4]=value;
		});

		__getset(0,__proto,'color',function(){
			return this._color.strColor;
			},function(value){
			this._color=Color.create(value);
		});

		return GlowFilter;
	})(Filter)


	//class laya.filters.webgl.BlurFilterActionGL extends laya.filters.webgl.FilterActionGL
	var BlurFilterActionGL=(function(_super){
		function BlurFilterActionGL(){
			this.data
			BlurFilterActionGL.__super.call(this);
		}

		__class(BlurFilterActionGL,'laya.filters.webgl.BlurFilterActionGL',_super);
		var __proto=BlurFilterActionGL.prototype;
		__proto.setValueMix=function(shader){
			shader.defines.add(this.data.type);
			var o=shader;
		}

		// shader.u_texH=data.elements[8];
		__proto.apply3d=function(scope,sprite,context,x,y){}
		__getset(0,__proto,'typeMix',function(){return /*laya.filters.Filter.BLUR*/0x10;});
		return BlurFilterActionGL;
	})(FilterActionGL)


	//class laya.filters.webgl.GlowFilterActionGL extends laya.filters.webgl.FilterActionGL
	var GlowFilterActionGL=(function(_super){
		function GlowFilterActionGL(){
			GlowFilterActionGL.__super.call(this);
			this.data
		}

		__class(GlowFilterActionGL,'laya.filters.webgl.GlowFilterActionGL',_super);
		var __proto=GlowFilterActionGL.prototype;
		Laya.imps(__proto,{"laya.filters.IFilterActionGL":true})
		__proto.setValueMix=function(shader){}
		__proto.apply3d=function(scope,sprite,context,x,y){
			return null;
		}

		__getset(0,__proto,'typeMix',function(){return /*laya.filters.Filter.GLOW*/0x08;});
		GlowFilterActionGL.tmpTarget=function(scope,sprite,context,x,y){
			var b=scope.getValue("bounds");
			var out=scope.getValue("out");
			out.end();
			var tmpTarget=RenderTarget2D.create(b.width+20,b.height+20);
			tmpTarget.start();
			scope.addValue("tmpTarget",tmpTarget);
		}

		GlowFilterActionGL.startOut=function(scope,sprite,context,x,y){
			var tmpTarget=scope.getValue("tmpTarget");
			tmpTarget.end();
			var out=scope.getValue("out");
			out.start();
		}

		GlowFilterActionGL.recycleTarget=function(scope,sprite,context,x,y){
			var src=scope.getValue("src");
			src.recycle();
			src.destroy();
			var tmpTarget=scope.getValue("tmpTarget");
			tmpTarget.recycle();
			tmpTarget.destroy();
		}

		return GlowFilterActionGL;
	})(FilterActionGL)


	Laya.__init([WebGLFilter]);
})(window,document,Laya);
