
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var ColorUtils=laya.utils.ColorUtils,Filter=laya.filters.Filter,Matrix=laya.maths.Matrix,Render=laya.renders.Render;
	var RunDriver=laya.utils.RunDriver,ShaderDefines2D=laya.webgl.shader.d2.ShaderDefines2D,Sprite=laya.display.Sprite;
	var Value2D=laya.webgl.shader.d2.value.Value2D;
/**
*@private
*/
//class laya.filters.GlowFilterGLRender
var GlowFilterGLRender=(function(){
	function GlowFilterGLRender(){}
	__class(GlowFilterGLRender,'laya.filters.GlowFilterGLRender');
	var __proto=GlowFilterGLRender.prototype;
	__proto.setShaderInfo=function(shader,w,h,data){
		shader.defines.add(data.type);
		var sv=shader;
		sv.u_blurInfo1=data._sv_blurInfo1;
		var info2=data._sv_blurInfo2;
		info2[0]=w;info2[1]=h;
		sv.u_blurInfo2=info2;
		sv.u_color=data.getColor();
	}

	__proto.render=function(rt,ctx,width,height,filter){
		var w=width,h=height;
		var svBlur=Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0);
		this.setShaderInfo(svBlur,w,h,filter);
		var svCP=Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0);
		var matI=Matrix.TEMP.identity();
		ctx.drawTarget(rt,0,0,w,h,matI,svBlur);
		ctx.drawTarget(rt,0,0,w,h,matI,svCP);
	}

	return GlowFilterGLRender;
})()


/**
*@private
*/
//class laya.filters.BlurFilterGLRender
var BlurFilterGLRender=(function(){
	function BlurFilterGLRender(){}
	__class(BlurFilterGLRender,'laya.filters.BlurFilterGLRender');
	var __proto=BlurFilterGLRender.prototype;
	__proto.render=function(rt,ctx,width,height,filter){
		var shaderValue=Value2D.create(/*laya.webgl.shader.d2.ShaderDefines2D.TEXTURE2D*/0x01,0);
		this.setShaderInfo(shaderValue,filter,rt.width,rt.height);
		ctx.drawTarget(rt,0,0,width,height,Matrix.EMPTY.identity(),shaderValue);
	}

	__proto.setShaderInfo=function(shader,filter,w,h){
		shader.defines.add(/*laya.filters.Filter.BLUR*/0x10);
		var sv=shader;
		BlurFilterGLRender.blurinfo[0]=w;BlurFilterGLRender.blurinfo[1]=h;
		sv.blurInfo=BlurFilterGLRender.blurinfo;
		var sigma=filter.strength/3.0;
		var sigma2=sigma*sigma;
		filter.strength_sig2_2sig2_gauss1[0]=filter.strength;
		filter.strength_sig2_2sig2_gauss1[1]=sigma2;
		filter.strength_sig2_2sig2_gauss1[2]=2.0*sigma2;
		filter.strength_sig2_2sig2_gauss1[3]=1.0/(2.0*Math.PI*sigma2);
		sv.strength_sig2_2sig2_gauss1=filter.strength_sig2_2sig2_gauss1;
	}

	__static(BlurFilterGLRender,
	['blurinfo',function(){return this.blurinfo=new Array(2);}
	]);
	return BlurFilterGLRender;
})()


/**
*模糊滤镜
*/
//class laya.filters.BlurFilter extends laya.filters.Filter
var BlurFilter=(function(_super){
	function BlurFilter(strength){
		/**模糊滤镜的强度(值越大，越不清晰 */
		this.strength=NaN;
		this.strength_sig2_2sig2_gauss1=[];
		//给shader用的。避免创建对象
		this.strength_sig2_native=null;
		//给native用的
		this.renderFunc=null;
		BlurFilter.__super.call(this);
		(strength===void 0)&& (strength=4);
		this.strength=strength;
		this._action=null;
		this._glRender=new BlurFilterGLRender();
	}

	__class(BlurFilter,'laya.filters.BlurFilter',_super);
	var __proto=BlurFilter.prototype;
	__proto.getStrenth_sig2_2sig2_native=function(){
		if (!this.strength_sig2_native){
			this.strength_sig2_native=new Float32Array(4);
		};
		var sigma=this.strength/3.0;
		var sigma2=sigma *sigma;
		this.strength_sig2_native[0]=this.strength;
		this.strength_sig2_native[1]=sigma2;
		this.strength_sig2_native[2]=2.0*sigma2;
		this.strength_sig2_native[3]=1.0 / (2.0 *Math.PI *sigma2);
		return this.strength_sig2_native;
	}

	/**
	*@private
	*当前滤镜的类型
	*/
	__getset(0,__proto,'type',function(){
		return 0x10;
	});

	return BlurFilter;
})(Filter)


/**
*发光滤镜(也可以当成阴影滤使用）
*/
//class laya.filters.GlowFilter extends laya.filters.Filter
var GlowFilter=(function(_super){
	function GlowFilter(color,blur,offX,offY){
		//给shader用
		this._sv_blurInfo2=[0,0,1,0];
		/**滤镜的颜色*/
		this._color=null;
		this._color_native=null;
		this._blurInof1_native=null;
		this._blurInof2_native=null;
		GlowFilter.__super.call(this);
		this._elements=new Float32Array(9);
		this._sv_blurInfo1=new Array(4);
		(blur===void 0)&& (blur=4);
		(offX===void 0)&& (offX=6);
		(offY===void 0)&& (offY=6);
		this._color=new ColorUtils(color);
		this.blur=Math.min(blur,20);
		this.offX=offX;
		this.offY=offY;
		this._sv_blurInfo1[0]=this._sv_blurInfo1[1]=this.blur;this._sv_blurInfo1[2]=offX;this._sv_blurInfo1[3]=-offY;
		this._glRender=new GlowFilterGLRender();
	}

	__class(GlowFilter,'laya.filters.GlowFilter',_super);
	var __proto=GlowFilter.prototype;
	/**@private */
	__proto.getColor=function(){
		return this._color.arrColor;
	}

	__proto.getColorNative=function(){
		if (!this._color_native){
			this._color_native=new Float32Array(4);
		};
		var color=this.getColor();
		this._color_native[0]=color[0];
		this._color_native[1]=color[1];
		this._color_native[2]=color[2];
		this._color_native[3]=color[3];
		return this._color_native;
	}

	__proto.getBlurInfo1Native=function(){
		if (!this._blurInof1_native){
			this._blurInof1_native=new Float32Array(4);
		}
		this._blurInof1_native[0]=this._blurInof1_native[1]=this.blur;
		this._blurInof1_native[2]=this.offX;
		this._blurInof1_native[3]=this.offY;
		return this._blurInof1_native;
	}

	__proto.getBlurInfo2Native=function(){
		if (!this._blurInof2_native){
			this._blurInof2_native=new Float32Array(4);
		}
		this._blurInof2_native[2]=1;
		return this._blurInof2_native;
	}

	/**
	*@private
	*滤镜类型
	*/
	__getset(0,__proto,'type',function(){
		return 0x08;
	});

	/**@private */
	/**@private */
	__getset(0,__proto,'offY',function(){
		return this._elements[6];
		},function(value){
		this._elements[6]=value;
		this._sv_blurInfo1[3]=-value;
	});

	/**@private */
	/**@private */
	__getset(0,__proto,'offX',function(){
		return this._elements[5];
		},function(value){
		this._elements[5]=value;
		this._sv_blurInfo1[2]=value;
	});

	/**@private */
	/**@private */
	__getset(0,__proto,'blur',function(){
		return this._elements[4];
		},function(value){
		this._elements[4]=value;
		this._sv_blurInfo1[0]=this._sv_blurInfo1[1]=value;
	});

	return GlowFilter;
})(Filter)



})(window,document,Laya);
