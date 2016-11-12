
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Box=laya.ui.Box,Browser=laya.utils.Browser,Event=laya.events.Event,Handler=laya.utils.Handler;
	var Image=laya.ui.Image,List=laya.ui.List,SoundManager=laya.media.SoundManager,Sprite=laya.display.Sprite;
	var Stage=laya.display.Stage,Text=laya.display.Text,WebGL=laya.webgl.WebGL;
	//class Sound_SimpleDemo
	var Sound_SimpleDemo=(function(){
		function Sound_SimpleDemo(){
			this.txtInfo=null;
			Laya.init(Browser.clientWidth,Browser.clientHeight,WebGL);
			Laya.stage.alignV="middle";
			Laya.stage.alignH="center";
			Laya.stage.scaleMode="showall";
			Laya.stage.bgColor="#232628";
			this.setup();
		}

		__class(Sound_SimpleDemo,'Sound_SimpleDemo');
		var __proto=Sound_SimpleDemo.prototype;
		__proto.setup=function(){
			var gap=10;
			var soundButton=this.createButton("播放音效");
			soundButton.x=(Laya.stage.width-soundButton.width *2+gap)/ 2;
			soundButton.y=(Laya.stage.height-soundButton.height)/ 2;
			Laya.stage.addChild(soundButton);
			var musicButton=this.createButton("播放音乐");
			musicButton.x=soundButton.x+gap+soundButton.width;
			musicButton.y=soundButton.y;
			Laya.stage.addChild(musicButton);
			soundButton.on("click",this,this.onPlaySound);
			musicButton.on("click",this,this.onPlayMusic);
		}

		__proto.createButton=function(label){
			var w=110;
			var h=40;
			var button=new Sprite();
			button.size(w,h);
			button.graphics.drawRect(0,0,w,h,"#FF7F50");
			button.graphics.fillText(label,w / 2 ,8,"25px SimHei","#FFFFFF","center");
			Laya.stage.addChild(button);
			return button;
		}

		__proto.onPlayMusic=function(e){
			console.log("播放音乐");
			SoundManager.playMusic("../../../../res/sounds/bgm.mp3",1,new Handler(this,this.onComplete));
		}

		__proto.onPlaySound=function(e){
			console.log("播放音效");
			SoundManager.playSound("../../../../res/sounds/btn.mp3",1,new Handler(this,this.onComplete));
		}

		__proto.onComplete=function(){
			console.log("播放完成");
		}

		return Sound_SimpleDemo;
	})()


	//class UI_List
	var UI_List=(function(){
		var Item;
		function UI_List(){
			Laya.init(800,600,WebGL);
			Laya.stage.alignV="middle";
			Laya.stage.alignH="center";
			Laya.stage.scaleMode="showall";
			Laya.stage.bgColor="#232628";
			this.setup();
		}

		__class(UI_List,'UI_List');
		var __proto=UI_List.prototype;
		__proto.setup=function(){
			var list=new List();
			list.itemRender=Item;
			list.repeatX=1;
			list.repeatY=4;
			list.x=(Laya.stage.width-Item.WID)/ 2;
			list.y=(Laya.stage.height-Item.HEI *list.repeatY)/ 2;
			list.vScrollBarSkin="";
			list.selectEnable=true;
			list.selectHandler=new Handler(this,this.onSelect);
			list.renderHandler=new Handler(this,this.updateItem);
			Laya.stage.addChild(list);
			var data=[];
			for (var i=0;i < 10;++i){
				data.push("../../../../res/ui/listskins/1.jpg");
				data.push("../../../../res/ui/listskins/2.jpg");
				data.push("../../../../res/ui/listskins/3.jpg");
				data.push("../../../../res/ui/listskins/4.jpg");
				data.push("../../../../res/ui/listskins/5.jpg");
			}
			list.array=data;
		}

		__proto.updateItem=function(cell,index){
			cell.setImg(cell.dataSource);
		}

		__proto.onSelect=function(index){
			console.log("当前选择的索引："+index);
		}

		UI_List.__init$=function(){
			//class Item extends laya.ui.Box
			Item=(function(_super){
				function Item(){
					this.img=null;
					Item.__super.call(this);
					this.size(Item.WID,Item.HEI);
					this.img=new Image();
					this.addChild(this.img);
				}
				__class(Item,'',_super);
				var __proto=Item.prototype;
				__proto.setImg=function(src){
					this.img.skin=src;
				}
				Item.WID=373;
				Item.HEI=85;
				return Item;
			})(Box)
		}

		return UI_List;
	})()


	Laya.__init([UI_List]);
	new Sound_SimpleDemo();

})(window,document,Laya);
