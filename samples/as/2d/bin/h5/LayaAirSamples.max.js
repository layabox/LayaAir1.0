
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Browser=laya.utils.Browser,Event=laya.events.Event,Skeleton=laya.ani.bone.Skeleton,Stat=laya.utils.Stat;
	var Templet=laya.ani.bone.Templet,WebGL=laya.webgl.WebGL;
	//class Skeleton_MultiTexture
	var Skeleton_MultiTexture=(function(){
		function Skeleton_MultiTexture(){
			this.mAniPath=null;
			this.mStartX=400;
			this.mStartY=500;
			this.mFactory=null;
			this.mActionIndex=0;
			this.mCurrIndex=0;
			this.mArmature=null;
			this.mCurrSkinIndex=0;
			WebGL.enable();
			Laya.init(Browser.width,Browser.height);
			Laya.stage.bgColor="#ffffff";
			Stat.show();
			this.startFun();
		}

		__class(Skeleton_MultiTexture,'Skeleton_MultiTexture');
		var __proto=Skeleton_MultiTexture.prototype;
		__proto.startFun=function(){
			this.mAniPath="../../../../res/spine/spineRes1/dragon.sk";
			this.mFactory=new Templet();
			this.mFactory.on("complete",this,this.parseComplete);
			this.mFactory.on("error",this,this.onError);
			this.mFactory.loadAni(this.mAniPath);
		}

		__proto.onError=function(){
			console.log("error");
		}

		__proto.parseComplete=function(){
			this.mArmature=this.mFactory.buildArmature(0);
			this.mArmature.x=this.mStartX;
			this.mArmature.y=this.mStartY;
			this.mArmature.scale(0.5,0.5);
			Laya.stage.addChild(this.mArmature);
			this.mArmature.on("stopped",this,this.completeHandler);
			this.play();
		}

		__proto.completeHandler=function(){
			this.play();
		}

		__proto.play=function(){
			this.mCurrIndex++;
			if (this.mCurrIndex >=this.mArmature.getAnimNum()){
				this.mCurrIndex=0;
			}
			this.mArmature.play(this.mCurrIndex,false);
		}

		return Skeleton_MultiTexture;
	})()



	new Skeleton_MultiTexture();

})(window,document,Laya);
