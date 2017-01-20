
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Browser=laya.utils.Browser,ColorFilter=laya.filters.ColorFilter,Handler=laya.utils.Handler,Sprite=laya.display.Sprite;
	var Stage=laya.display.Stage,Texture=laya.resource.Texture,WebGL=laya.webgl.WebGL;
	//class Filters_Color
	var Filters_Color=(function(){
		function Filters_Color(){
			this.ApePath="../../../../res/apes/monkey2.png";
			this.apeTexture=null;
			Laya.init(Browser.clientWidth,Browser.clientHeight,WebGL);
			Laya.stage.alignV="middle";
			Laya.stage.alignH="center";
			Laya.stage.scaleMode="showall";
			Laya.loader.load(this.ApePath,Handler.create(this,this.setup));
		}

		__class(Filters_Color,'Filters_Color');
		var __proto=Filters_Color.prototype;
		__proto.setup=function(e){
			this.normalizeApe();
			this.makeRedApe();
			this.grayingApe();
		}

		__proto.normalizeApe=function(){
			var originalApe=this.createApe();
			this.apeTexture=Laya.loader.getRes(this.ApePath);
			originalApe.x=(Laya.stage.width-this.apeTexture.width *3)/ 2;
			originalApe.y=(Laya.stage.height-this.apeTexture.height)/ 2;
		}

		__proto.makeRedApe=function(){
			var redMat=
			[
			0.5,0,0,0,0,
			0,0.5,0,0,0,
			0,0,0.5,0,0,
			0,0,0,1,0,];
			var redFilter=new ColorFilter(redMat);
			var redApe=this.createApe();
			redApe.filters=[redFilter];
			var firstChild=Laya.stage.getChildAt(0);
			redApe.x=firstChild.x+this.apeTexture.width;
			redApe.y=firstChild.y;
		}

		__proto.grayingApe=function(){
			var grayscaleMat=[
			0.3086,0.6094,0.0820,0,0,
			0.3086,0.6094,0.0820,0,0,
			0.3086,0.6094,0.0820,0,0,
			0,0,0,1,0];
			var grayscaleFilter=new ColorFilter(grayscaleMat);
			var grayApe=this.createApe();
			grayApe.filters=[grayscaleFilter];
			var secondChild=Laya.stage.getChildAt(1);
			grayApe.x=secondChild.x+this.apeTexture.width;
			grayApe.y=secondChild.y;
		}

		__proto.createApe=function(){
			var ape=new Sprite();
			ape.loadImage("../../../../res/apes/monkey2.png");
			Laya.stage.addChild(ape);
			return ape;
		}

		return Filters_Color;
	})()



	new Filters_Color();

})(window,document,Laya);
