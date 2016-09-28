
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Browser=laya.utils.Browser,Graphics=laya.display.Graphics,Sprite=laya.display.Sprite,WebGL=laya.webgl.WebGL;
	/**
	*...
	*@author Survivor
	*
	*
	*/
	//class PIXI_Example_21
	var PIXI_Example_21=(function(){
		function PIXI_Example_21(){
			this.colors=["#5D0776","#EC8A49","#AF3666","#F6C84C","#4C779A"];
			this.colorCount=0;
			this.isDown=false;
			this.path=[];
			this.liveGraphics=null;
			this.canvasGraphics=null;
			this.color=this.colors[0];
			Laya.init(Browser.width,Browser.height,WebGL);
			Laya.stage.bgColor="#3da8bb";
			this.createCanvases();
			Laya.timer.frameLoop(1,this,this.animate);
			Laya.stage.on('mousedown',this,this.onMouseDown);
			Laya.stage.on('mousemove',this,this.onMouseMove);
			Laya.stage.on('mouseup',this,this.onMouseUp);
		}

		__class(PIXI_Example_21,'PIXI_Example_21');
		var __proto=PIXI_Example_21.prototype;
		__proto.createCanvases=function(){
			var graphicsCanvas=new Sprite();
			Laya.stage.addChild(graphicsCanvas);
			var liveGraphicsCanvas=new Sprite();
			Laya.stage.addChild(liveGraphicsCanvas);
			this.liveGraphics=liveGraphicsCanvas.graphics;
			this.canvasGraphics=graphicsCanvas.graphics;
		}

		__proto.onMouseDown=function(e){
			this.isDown=true;
			this.color=this.colors[this.colorCount++% this.colors.length];
			this.path.length=0;
		}

		__proto.onMouseMove=function(e){
			if (!this.isDown)return;
			this.path.push(Laya.stage.mouseX);
			this.path.push(Laya.stage.mouseY);
		}

		__proto.onMouseUp=function(e){
			this.isDown=false;
			this.canvasGraphics.drawPoly(0,0,this.path.concat(),this.color);
		}

		__proto.animate=function(){
			this.liveGraphics.clear();
			this.liveGraphics.drawPoly(0,0,this.path,this.color);
		}

		return PIXI_Example_21;
	})()



	new PIXI_Example_21();

})(window,document,Laya);
