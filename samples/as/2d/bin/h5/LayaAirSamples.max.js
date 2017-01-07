
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Event=laya.events.Event,Rectangle=laya.maths.Rectangle,Sprite=laya.display.Sprite;
	/**
	*...
	*@author suvivor
	*/
	//class HitTest_Rectangular
	var HitTest_Rectangular=(function(){
		function HitTest_Rectangular(){
			this.rect1=null;
			this.rect2=null;
			Laya.init(800,600);
			Laya.stage.scaleMode="showall";
			Laya.stage.bgColor="#232628";
			this.rect1=this.createRect(100,"orange");
			this.rect2=this.createRect(200,"purple");
			Laya.timer.frameLoop(1,this,this.loop);
		}

		__class(HitTest_Rectangular,'HitTest_Rectangular');
		var __proto=HitTest_Rectangular.prototype;
		__proto.createRect=function(size,color){
			var rect=new Sprite();
			rect.graphics.drawRect(0,0,size,size,color);
			rect.size(size,size);
			Laya.stage.addChild(rect);
			rect.on("mousedown",this,this.startDrag,[rect]);
			rect.on("mouseup",this,this.stopDrag,[rect]);
			return rect;
		}

		__proto.startDrag=function(target){
			target.startDrag();
		}

		__proto.stopDrag=function(target){
			target.stopDrag();
		}

		__proto.loop=function(){
			var bounds1=this.rect1.getBounds();
			var bounds2=this.rect2.getBounds();
			var hit=bounds1.intersects(bounds2);
			this.rect1.alpha=this.rect2.alpha=hit ? 0.5 :1;
		}

		return HitTest_Rectangular;
	})()



	new HitTest_Rectangular();

})(window,document,Laya);
