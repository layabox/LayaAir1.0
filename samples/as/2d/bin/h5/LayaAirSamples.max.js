
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Input=laya.display.Input,Stage=laya.display.Stage,WebGL=laya.webgl.WebGL;
	//class Text_InputSingleline
	var Text_InputSingleline=(function(){
		function Text_InputSingleline(){
			Laya.init(1280,720,WebGL);
			Laya.stage.scaleMode="fixedheight";
			Laya.stage.screenMode="horizontal";
			Laya.stage.alignH="center";
			Laya.stage.alignV="middle";
			this.createInput();
		}

		__class(Text_InputSingleline,'Text_InputSingleline');
		var __proto=Text_InputSingleline.prototype;
		__proto.createInput=function(){
			var inputText=new Input();
			inputText.size(350,100);
			inputText.x=200;
			inputText.y=200;
			inputText.prompt="Type some word...";
			inputText.rotation=45;
			inputText.bold=true;
			inputText.bgColor="#666666";
			inputText.color="#ffffff";
			inputText.fontSize=20;
			Laya.stage.addChild(inputText);
		}

		return Text_InputSingleline;
	})()



	new Text_InputSingleline();

})(window,document,Laya);
