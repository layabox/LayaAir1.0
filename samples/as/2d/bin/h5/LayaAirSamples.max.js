
(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;

	var Animation=laya.display.Animation,Box=laya.ui.Box,Browser=laya.utils.Browser,Byte=laya.utils.Byte;
	var Handler=laya.utils.Handler,Image=laya.ui.Image,List=laya.ui.List,Loader=laya.net.Loader,Rectangle=laya.maths.Rectangle;
	var Stage=laya.display.Stage,WebGL=laya.webgl.WebGL;
	//class Animation_Altas
	var Animation_Altas=(function(){
		function Animation_Altas(){
			this.AniConfPath="C:\\Users\\Survivor\\Desktop\\out\\22003_stand.json";
			Laya.init(Browser.clientWidth,Browser.clientHeight,WebGL);
			Laya.stage.alignV="middle";
			Laya.stage.alignH="center";
			Laya.stage.scaleMode="showall";
			Laya.stage.bgColor="#232628";
			Laya.loader.load(this.AniConfPath,Handler.create(this,this.createAnimation),null,"atlas");
		}

		__class(Animation_Altas,'Animation_Altas');
		var __proto=Animation_Altas.prototype;
		__proto.createAnimation=function(_e){
			var ani=new Animation();
			ani.loadAtlas(this.AniConfPath);
			ani.interval=30;
			ani.index=1;
			ani.play();
			var bounds=ani.getGraphicBounds();
			ani.pivot(bounds.width / 2,bounds.height / 2);
			ani.pos(Laya.stage.width / 2,Laya.stage.height / 2);
			Laya.stage.addChild(ani);
			var b=new Byte();
			b.writeByte(-1);
			b.writeByte(-12);
			b.writeByte(255);
			b.pos=0;
			console.log(b.readByte());
			console.log(b.readByte());
			console.log(b.readByte());
		}

		return Animation_Altas;
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
	new Animation_Altas();

})(window,document,Laya);
