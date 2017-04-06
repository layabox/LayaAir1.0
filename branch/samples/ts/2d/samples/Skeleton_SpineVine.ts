module laya {
	import Skeleton = Laya.Skeleton;
	import Templet = Laya.Templet;
	import Event = Laya.Event;
	import Browser = Laya.Browser;
	import Stat = Laya.Stat;
	import WebGL = Laya.WebGL;

	export class Skeleton_SpineVine {
		private mAniPath:string;
		private mStartX:number = 200;
		private mStartY:number = 500;
		private mFactory:Templet;
		private mActionIndex:number = 0;
		private mCurrIndex:number = 0;
		private mArmature:Skeleton;
		private mCurrSkinIndex:number = 0;
		private mFactory2:Templet;
		constructor() {
			Laya.init(Browser.width, Browser.height,WebGL);
			Laya.stage.bgColor = "#ffffff";
			Stat.show();
			this.startFun();
		}
		
		public startFun():void
		{
			this.mAniPath = "../../res/spine/spineRes5/vine.sk";
			this.mFactory = new Templet();
			this.mFactory.on(Event.COMPLETE, this, this.parseComplete);
			this.mFactory.on(Event.ERROR, this, this.onError);
			this.mFactory.loadAni(this.mAniPath);
		}
		
		private onError():void
		{
			console.log("error");
		}
		
		private parseComplete():void {
			//创建模式为1，可以启用换装
			this.mArmature = this.mFactory.buildArmature(1);
			this.mArmature.x = this.mStartX;
			this.mArmature.y = this.mStartY;
			this.mArmature.scale(0.5, 0.5);
			Laya.stage.addChild(this.mArmature);
			this.mArmature.on(Event.STOPPED, this, this.completeHandler);
			this.play();
		}
		
		private completeHandler():void
		{
			this.play();
		}
		
		private play():void
		{
			this.mCurrIndex++;
			if (this.mCurrIndex >= this.mArmature.getAnimNum())
			{
				this.mCurrIndex = 0;
			}
			this.mArmature.play(this.mCurrIndex,false);
			
		}
	}
}
new laya.Skeleton_SpineVine();