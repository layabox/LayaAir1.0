
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Input=laya.display.Input,Stage=laya.display.Stage,Text=laya.display.Text,WebGL=laya.webgl.WebGL;
	//class Text_Restrict
	var Text_Restrict=(function(){
		function Text_Restrict(){
			Laya.init(550,300,WebGL);
			Laya.stage.alignV="middle";
			Laya.stage.alignH="center";
			Laya.stage.scaleMode="showall";
			Laya.stage.bgColor="#232628";
			this.createTexts();
		}

		__class(Text_Restrict,'Text_Restrict');
		var __proto=Text_Restrict.prototype;
		__proto.createTexts=function(){
			this.createLabel("只允许输入数字：").pos(50,20);
			var input=this.createInput();
			input.pos(50,50);
			input.restrict="0-9";
			this.createLabel("只允许输入字母：").pos(50,100);
			input=this.createInput();
			input.pos(50,130);
			input.restrict="a-zA-Z";
			this.createLabel("只允许输入中文字符：").pos(50,180);
			input=this.createInput();
			input.pos(50,210);
			input.restrict="\u4e00-\u9fa5";
		}

		__proto.createLabel=function(text){
			var label=new Text();
			label.text=text;
			label.color="white";
			label.fontSize=20;
			Laya.stage.addChild(label);
			return label;
		}

		__proto.createInput=function(){
			var input=new Input();
			input.size(200,30);
			input.borderColor="#FFFF00";
			input.bold=true;
			input.fontSize=20;
			input.color="#FFFFFF";
			input.padding=[0,4,0,4];
			input.inputElementYAdjuster=1;
			Laya.stage.addChild(input);
			return input;
		}

		return Text_Restrict;
	})()



	new Text_Restrict();

})(window,document,Laya);
