
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var BlurFilter=laya.filters.BlurFilter,ColorFilter=laya.filters.ColorFilter,ColorUtils=laya.utils.ColorUtils;
	var Component=laya.components.Component,Ease=laya.utils.Ease,Event=laya.events.Event,GlowFilter=laya.filters.GlowFilter;
	var Handler=laya.utils.Handler,Node=laya.display.Node,Sprite=laya.display.Sprite,Tween=laya.utils.Tween,Utils=laya.utils.Utils;
/**
*...
*@author ww
*/
//class laya.effect.FilterSetterBase
var FilterSetterBase=(function(){
	function FilterSetterBase(){
		this._filter=null;
		this._target=null;
	}

	__class(FilterSetterBase,'laya.effect.FilterSetterBase');
	var __proto=FilterSetterBase.prototype;
	__proto.paramChanged=function(){
		Laya.systemTimer.callLater(this,this.buildFilter);
	}

	__proto.buildFilter=function(){
		if (this._target){
			this.addFilter(this._target);
		}
	}

	__proto.addFilter=function(sprite){
		if (!sprite)return;
		if (!sprite.filters){
			sprite.filters=[this._filter];
			}else{
			var preFilters;
			preFilters=sprite.filters;
			if (preFilters.indexOf(this._filter)< 0){
				preFilters.push(this._filter);
				sprite.filters=Utils.copyArray([],preFilters);
			}
		}
	}

	__proto.removeFilter=function(sprite){
		if (!sprite)return;
		sprite.filters=null;
	}

	__getset(0,__proto,'target',null,function(value){
		if (this._target !=value){
			this._target=value;
			this.paramChanged();
		}
	});

	return FilterSetterBase;
})()


/**
*@Script {name:ButtonEffect}
*@author ww
*/
//class laya.effect.ButtonEffect
var ButtonEffect=(function(){
	function ButtonEffect(){
		this._tar=null;
		this._curState=0;
		this._curTween=null;
		/**
		*effectScale
		*@prop {name:effectScale,type:number,tips:"缩放值",default:"1.5"}
		*/
		this.effectScale=1.5;
		/**
		*tweenTime
		*@prop {name:tweenTime,type:number,tips:"缓动时长",default:"300"}
		*/
		this.tweenTime=300;
		/**
		*effectEase
		*@prop {name:effectEase,type:ease,tips:"效果缓动类型"}
		*/
		this.effectEase=null;
		/**
		*backEase
		*@prop {name:backEase,type:ease,tips:"恢复缓动类型"}
		*/
		this.backEase=null;
	}

	__class(ButtonEffect,'laya.effect.ButtonEffect');
	var __proto=ButtonEffect.prototype;
	__proto.toChangedState=function(){
		this._curState=1;
		if (this._curTween)Tween.clear(this._curTween);
		this._curTween=Tween.to(this._tar,{scaleX:this.effectScale,scaleY:this.effectScale },this.tweenTime,Ease[this.effectEase],Handler.create(this,this.tweenComplete));
	}

	__proto.toInitState=function(){
		if (this._curState==2)return;
		if (this._curTween)Tween.clear(this._curTween);
		this._curState=2;
		this._curTween=Tween.to(this._tar,{scaleX:1,scaleY:1 },this.tweenTime,Ease[this.backEase],Handler.create(this,this.tweenComplete));
	}

	__proto.tweenComplete=function(){
		this._curState=0;
		this._curTween=null;
	}

	/**
	*设置控制对象
	*@param tar
	*/
	__getset(0,__proto,'target',null,function(tar){
		this._tar=tar;
		tar.on(/*laya.events.Event.MOUSE_DOWN*/"mousedown",this,this.toChangedState);
		tar.on(/*laya.events.Event.MOUSE_UP*/"mouseup",this,this.toInitState);
		tar.on(/*laya.events.Event.MOUSE_OUT*/"mouseout",this,this.toInitState);
	});

	return ButtonEffect;
})()


/**
*效果插件基类，基于对象池管理
*/
//class laya.effect.EffectBase extends laya.components.Component
var EffectBase=(function(_super){
	function EffectBase(){
		/**动画持续时间，单位为毫秒*/
		this.duration=1000;
		/**动画延迟时间，单位为毫秒*/
		this.delay=0;
		/**重复次数，默认为播放一次*/
		this.repeat=0;
		/**缓动类型，如果为空，则默认为匀速播放*/
		this.ease=null;
		/**触发事件，如果为空，则创建时触发*/
		this.eventName=null;
		/**效用作用的目标对象，如果为空，则是脚本所在的节点本身*/
		this.target=null;
		/**效果结束后，是否自动移除节点*/
		this.autoDestroyAtComplete=true;
		this._comlete=null;
		this._tween=null;
		EffectBase.__super.call(this);
	}

	__class(EffectBase,'laya.effect.EffectBase',_super);
	var __proto=EffectBase.prototype;
	__proto._onAwake=function(){this.target=this.target|| this.owner;
		if (this.autoDestroyAtComplete)this._comlete=Handler.create(this.target,this.target.destroy,null,false);
		if (this.eventName)this.owner.on(this.eventName,this,this._exeTween);
		else this._exeTween();
	}

	__proto._exeTween=function(){
		this._tween=this._doTween();
		this._tween.repeat=this.repeat;
	}

	__proto._doTween=function(){
		return null;
	}

	__proto.onReset=function(){
		this.duration=1000;
		this.delay=0;
		this.repeat=0;
		this.ease=null;
		this.target=null;
		if (this.eventName){
			this.owner.off(this.eventName,this,this._exeTween);
			this.eventName=null;
		}
		if (this._comlete){
			this._comlete.recover();
			this._comlete=null;
		}
		if (this._tween){
			this._tween.clear();
			this._tween=null;
		}
	}

	return EffectBase;
})(Component)


/**
*...
*@author ww
*/
//class laya.effect.ColorFilterSetter extends laya.effect.FilterSetterBase
var ColorFilterSetter=(function(_super){
	function ColorFilterSetter(){
		/**
		*brightness 亮度,范围:-100~100
		*/
		this._brightness=0;
		/**
		*contrast 对比度,范围:-100~100
		*/
		this._contrast=0;
		/**
		*saturation 饱和度,范围:-100~100
		*/
		this._saturation=0;
		/**
		*hue 色调,范围:-180~180
		*/
		this._hue=0;
		/**
		*red red增量,范围:0~255
		*/
		this._red=0;
		/**
		*green green增量,范围:0~255
		*/
		this._green=0;
		/**
		*blue blue增量,范围:0~255
		*/
		this._blue=0;
		/**
		*alpha alpha增量,范围:0~255
		*/
		this._alpha=0;
		this._color=null;
		ColorFilterSetter.__super.call(this);
		this._filter=new ColorFilter();
	}

	__class(ColorFilterSetter,'laya.effect.ColorFilterSetter',_super);
	var __proto=ColorFilterSetter.prototype;
	__proto.buildFilter=function(){
		this._filter.reset();
		this._filter.color(this.red,this.green,this.blue,this.alpha);
		this._filter.adjustHue(this.hue);
		this._filter.adjustContrast(this.contrast);
		this._filter.adjustBrightness(this.brightness);
		this._filter.adjustSaturation(this.saturation);
		_super.prototype.buildFilter.call(this);
	}

	__getset(0,__proto,'brightness',function(){
		return this._brightness;
		},function(value){
		this._brightness=value;
		this.paramChanged();
	});

	__getset(0,__proto,'alpha',function(){
		return this._alpha;
		},function(value){
		this._alpha=value;
		this.paramChanged();
	});

	__getset(0,__proto,'contrast',function(){
		return this._contrast;
		},function(value){
		this._contrast=value;
		this.paramChanged();
	});

	__getset(0,__proto,'hue',function(){
		return this._hue;
		},function(value){
		this._hue=value;
		this.paramChanged();
	});

	__getset(0,__proto,'saturation',function(){
		return this._saturation;
		},function(value){
		this._saturation=value;
		this.paramChanged();
	});

	__getset(0,__proto,'green',function(){
		return this._green;
		},function(value){
		this._green=value;
		this.paramChanged();
	});

	__getset(0,__proto,'red',function(){
		return this._red;
		},function(value){
		this._red=value;
		this.paramChanged();
	});

	__getset(0,__proto,'blue',function(){
		return this._blue;
		},function(value){
		this._blue=value;
		this.paramChanged();
	});

	__getset(0,__proto,'color',function(){
		return this._color;
		},function(value){
		this._color=value;
		var colorO;
		colorO=ColorUtils.create(value);
		this._red=colorO.arrColor[0] *255;
		this._green=colorO.arrColor[1] *255;
		this._blue=colorO.arrColor[2] *255;
		this.paramChanged();
	});

	return ColorFilterSetter;
})(FilterSetterBase)


/**
*...
*@author ww
*/
//class laya.effect.GlowFilterSetter extends laya.effect.FilterSetterBase
var GlowFilterSetter=(function(_super){
	function GlowFilterSetter(){
		/**
		*滤镜的颜色
		*/
		this._color="#ff0000";
		/**
		*边缘模糊的大小 0~20
		*/
		this._blur=4;
		/**
		*X轴方向的偏移
		*/
		this._offX=6;
		/**
		*Y轴方向的偏移
		*/
		this._offY=6;
		GlowFilterSetter.__super.call(this);
		this._filter=new GlowFilter(this._color);
	}

	__class(GlowFilterSetter,'laya.effect.GlowFilterSetter',_super);
	var __proto=GlowFilterSetter.prototype;
	__proto.buildFilter=function(){
		this._filter=new GlowFilter(this.color,this.blur,this.offX,this.offY);
		_super.prototype.buildFilter.call(this);
	}

	__getset(0,__proto,'blur',function(){
		return this._blur;
		},function(value){
		this._blur=value;
		this.paramChanged();
	});

	__getset(0,__proto,'color',function(){
		return this._color;
		},function(value){
		this._color=value;
		this.paramChanged();
	});

	__getset(0,__proto,'offX',function(){
		return this._offX;
		},function(value){
		this._offX=value;
		this.paramChanged();
	});

	__getset(0,__proto,'offY',function(){
		return this._offY;
		},function(value){
		this._offY=value;
		this.paramChanged();
	});

	return GlowFilterSetter;
})(FilterSetterBase)


/**
*...
*@author ww
*/
//class laya.effect.BlurFilterSetter extends laya.effect.FilterSetterBase
var BlurFilterSetter=(function(_super){
	function BlurFilterSetter(){
		this._strength=4;
		BlurFilterSetter.__super.call(this);
		this._filter=new BlurFilter(this.strength);
	}

	__class(BlurFilterSetter,'laya.effect.BlurFilterSetter',_super);
	var __proto=BlurFilterSetter.prototype;
	__proto.buildFilter=function(){
		this._filter=new BlurFilter(this.strength);
		_super.prototype.buildFilter.call(this);
	}

	__getset(0,__proto,'strength',function(){
		return this._strength;
		},function(value){
		this._strength=value;
	});

	return BlurFilterSetter;
})(FilterSetterBase)


/**
*淡出效果
*/
//class laya.effect.FadeOut extends laya.effect.EffectBase
var FadeOut=(function(_super){
	function FadeOut(){
		FadeOut.__super.call(this);;
	}

	__class(FadeOut,'laya.effect.FadeOut',_super);
	var __proto=FadeOut.prototype;
	__proto._doTween=function(){
		this.target.alpha=1;
		return Tween.to(this.target,{alpha:0},this.duration,Ease[this.ease],this._comlete,this.delay);
	}

	return FadeOut;
})(EffectBase)


/**
*淡入效果
*/
//class laya.effect.FadeIn extends laya.effect.EffectBase
var FadeIn=(function(_super){
	function FadeIn(){
		FadeIn.__super.call(this);;
	}

	__class(FadeIn,'laya.effect.FadeIn',_super);
	var __proto=FadeIn.prototype;
	__proto._doTween=function(){
		this.target.alpha=0;
		return Tween.to(this.target,{alpha:1},this.duration,Ease[this.ease],this._comlete,this.delay);
	}

	return FadeIn;
})(EffectBase)



})(window,document,Laya);
