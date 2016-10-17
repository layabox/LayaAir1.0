
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Browser=laya.utils.Browser,Input=laya.display.Input,Stage=laya.display.Stage,WebGL=laya.webgl.WebGL;
	//class Text_InputSingleline
	var Text_InputSingleline=(function(){
		function Text_InputSingleline(){
			Laya.init(Browser.clientWidth,Browser.clientHeight,WebGL);
			Laya.stage.alignV="middle";
			Laya.stage.alignH="center";
			Laya.stage.scaleMode="showall";
			Laya.stage.bgColor="#232628";
			this.createInput();
		}

		__class(Text_InputSingleline,'Text_InputSingleline');
		var __proto=Text_InputSingleline.prototype;
		__proto.createInput=function(){
			var inputText=new Input();
			inputText.size(350,100);
			inputText.x=Laya.stage.width-inputText.width >> 1;
			inputText.y=Laya.stage.height-inputText.height >> 1;
			inputText.prompt="Type some word...";
			inputText.bold=true;
			inputText.bgColor="#666666";
			inputText.color="#ffffff";
			inputText.fontSize=20;
			inputText.maxChars=5;
			inputText.type="number";
			Laya.stage.addChild(inputText);
		}

		return Text_InputSingleline;
	})()



	new Text_InputSingleline();

})(window,document,Laya);
