
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var AccelerationInfo=laya.device.motion.AccelerationInfo,Accelerator=laya.device.motion.Accelerator;
	var Browser=laya.utils.Browser,Event=laya.events.Event,Point=laya.maths.Point,Sprite=laya.display.Sprite;
	var Stage=laya.display.Stage,WebGL=laya.webgl.WebGL;
	/**
	*...
	*@author Survivor
	*/
	//class InputDevice_GluttonousSnake
	var InputDevice_GluttonousSnake=(function(){
		var Segment;
		function InputDevice_GluttonousSnake(){
			this.seg=null;
			this.segments=[];
			this.foods=[];
			this.initialSegmentsAmount=5;
			this.vx=0
			this.vy=0;
			this.targetPosition=null;
			Laya.init(Browser.width,Browser.height,WebGL);
			Laya.stage.screenMode="horizontal";
			this.initSnake();
			Accelerator.instance.on("change",this,this.monitorAccelerator);
			Laya.timer.frameLoop(1,this,this.animate);
			Laya.timer.loop(3000,this,this.produceFood);
			this.produceFood();
		}

		__class(InputDevice_GluttonousSnake,'InputDevice_GluttonousSnake');
		var __proto=InputDevice_GluttonousSnake.prototype;
		__proto.initSnake=function(){
			for (var i=0;i < this.initialSegmentsAmount;i++){
				this.addSegment();
				if (i==0){
					var header=this.segments[0];
					header.rotation=180;
					this.targetPosition=new Point();
					this.targetPosition.x=Laya.stage.width / 2;
					this.targetPosition.y=Laya.stage.height / 2;
					header.pos(this.targetPosition.x+header.width,this.targetPosition.y);
					header.graphics.drawCircle(header.width,5,3,"#000000");
					header.graphics.drawCircle(header.width,-5,3,"#000000");
				}
			}
		}

		__proto.monitorAccelerator=function(acceleration,accelerationIncludingGravity,rotationRate,interval){
			accelerationIncludingGravity=Accelerator.getTransformedAcceleration(accelerationIncludingGravity);
			this.vx=accelerationIncludingGravity.x;
			this.vy=accelerationIncludingGravity.y;
		}

		__proto.addSegment=function(){
			var seg=new Segment(40,30);
			Laya.stage.addChildAt(seg,0);
			if (this.segments.length > 0){
				var prevSeg=this.segments[this.segments.length-1];
				seg.rotation=prevSeg.rotation;
				var point=seg.getPinPosition();
				seg.x=prevSeg.x-point.x;
				seg.y=prevSeg.y-point.y;
			}
			this.segments.push(seg);
		}

		__proto.animate=function(){
			var seg=this.segments[0];
			this.targetPosition.x+=this.vx;
			this.targetPosition.y+=this.vy;
			this.limitMoveRange();
			this.checkEatFood();
			var targetX=this.targetPosition.x;
			var targetY=this.targetPosition.y;
			for (var i=0,len=this.segments.length;i < len;i++){
				seg=this.segments[i];
				var dx=targetX-seg.x;
				var dy=targetY-seg.y;
				var radian=Math.atan2(dy,dx);
				seg.rotation=radian *180 / Math.PI;
				var pinPosition=seg.getPinPosition();
				var w=pinPosition.x-seg.x;
				var h=pinPosition.y-seg.y;
				seg.x=targetX-w;
				seg.y=targetY-h;
				targetX=seg.x;
				targetY=seg.y;
			}
		}

		__proto.limitMoveRange=function(){
			if (this.targetPosition.x < 0)
				this.targetPosition.x=0;
			else if (this.targetPosition.x > Laya.stage.width)
			this.targetPosition.x=Laya.stage.width;
			if (this.targetPosition.y < 0)
				this.targetPosition.y=0;
			else if (this.targetPosition.y > Laya.stage.height)
			this.targetPosition.y=Laya.stage.height;
		}

		__proto.checkEatFood=function(){
			var food;
			for (var i=this.foods.length-1;i >=0;i--){
				food=this.foods[i];
				if (food.hitTestPoint(this.targetPosition.x,this.targetPosition.y)){
					this.addSegment();
					Laya.stage.removeChild(food);
					this.foods.splice(i,1);
				}
			}
		}

		__proto.produceFood=function(){
			if (this.foods.length==5)
				return;
			var food=new Sprite();
			Laya.stage.addChild(food);
			this.foods.push(food);
			var foodSize=40;
			food.size(foodSize,foodSize);
			food.graphics.drawRect(0,0,foodSize,foodSize,"#00BFFF");
			food.x=Math.random()*Laya.stage.width;
			food.y=Math.random()*Laya.stage.height;
		}

		InputDevice_GluttonousSnake.__init$=function(){
			//class Segment extends laya.display.Sprite
			Segment=(function(_super){
				function Segment(width,height){
					Segment.__super.call(this);
					this.size(width,height);
					this.init();
				}
				__class(Segment,'',_super);
				var __proto=Segment.prototype;
				__proto.init=function(){
					this.graphics.drawRect(-this.height / 2,-this.height / 2,this.width+this.height,this.height,"#FF7F50");
				}
				// 获取关节另一头位置
				__proto.getPinPosition=function(){
					var radian=this.rotation *Math.PI / 180;
					var tx=this.x+Math.cos(radian)*this.width;
					var ty=this.y+Math.sin(radian)*this.width;
					return new Point(tx,ty);
				}
				return Segment;
			})(Sprite)
		}

		return InputDevice_GluttonousSnake;
	})()


	Laya.__init([InputDevice_GluttonousSnake]);
	new InputDevice_GluttonousSnake();

})(window,document,Laya);
