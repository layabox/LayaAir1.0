
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Event=laya.events.Event,Keyboard=laya.events.Keyboard,Sprite=laya.display.Sprite,Stage=laya.display.Stage;
	var TimeLine=laya.utils.TimeLine,WebGL=laya.webgl.WebGL;
	//class Tween_TimeLine
	var Tween_TimeLine=(function(){
		function Tween_TimeLine(){
			this.target=null;
			this.timeLine=new TimeLine();
			Laya.init(550,400,WebGL);
			Laya.stage.alignV="middle";
			Laya.stage.alignH="center";
			Laya.stage.scaleMode="showall";
			Laya.stage.bgColor="#232628";
			this.setup();
		}

		__class(Tween_TimeLine,'Tween_TimeLine');
		var __proto=Tween_TimeLine.prototype;
		__proto.setup=function(){
			this.createApe();
			this.createTimerLine();
			Laya.stage.on("keydown",this,this.keyDown);
		}

		__proto.createApe=function(){
			this.target=new Sprite();
			this.target.loadImage("../../../../res/apes/monkey2.png");
			Laya.stage.addChild(this.target);
			this.target.pivot(55,72);
			this.target.pos(100,100);
		}

		__proto.createTimerLine=function(){
			this.timeLine.addLabel("turnRight",0).to(this.target,{x:450,y:100,scaleX:0.5,scaleY:0.5},2000,null,0)
			.addLabel("turnDown",0).to(this.target,{x:450,y:300,scaleX:0.2,scaleY:1,alpha:1},2000,null,0)
			.addLabel("turnLeft",0).to(this.target,{x:100,y:300,scaleX:1,scaleY:0.2,alpha:0.1},2000,null,0)
			.addLabel("turnUp",0).to(this.target,{x:100,y:100,scaleX:1,scaleY:1,alpha:1},2000,null,0);
			this.timeLine.play(0,true);
			this.timeLine.on("complete",this,this.onComplete);
			this.timeLine.on("label",this,this.onLabel);
		}

		__proto.onComplete=function(){
			console.log("timeLine complete!!!!");
		}

		__proto.onLabel=function(label){
			console.log("LabelName:"+label);
		}

		__proto.keyDown=function(e){
			switch(e.keyCode){
				case 37:
					this.timeLine.play("turnLeft");
					break ;
				case 39:
					this.timeLine.play("turnRight");
					break ;
				case 38:
					this.timeLine.play("turnUp");
					break ;
				case 40:
					this.timeLine.play("turnDown");
					break ;
				case 80:
					this.timeLine.pause();
					break ;
				case 82:
					this.timeLine.resume();
					break ;
				}
		}

		return Tween_TimeLine;
	})()



	new Tween_TimeLine();

})(window,document,Laya);
