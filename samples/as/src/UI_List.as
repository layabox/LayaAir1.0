package
{
	import laya.display.Stage;
	import laya.ui.List;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class UI_List
	{
		public function UI_List()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(800, 600, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";

			setup();			
		}

		private function setup():void
		{
			var list:List = new List();
			
			list.itemRender = Item;
			
			list.repeatX = 1;
			list.repeatY = 4;

			list.x = (Laya.stage.width - Item.WID) / 2;
			list.y = (Laya.stage.height - Item.HEI * list.repeatY) / 2;
			
			// 使用但隐藏滚动条
			list.vScrollBarSkin = "";
			
			list.selectEnable = true;
			list.selectHandler = new Handler(this, onSelect);
			
			list.renderHandler = new Handler(this, updateItem);
			Laya.stage.addChild(list);
			
			// 设置数据项为对应图片的路径
			var data:Array = [];
			for (var i:int = 0; i < 10; ++i)
			{
				data.push("res/ui/listskins/1.jpg");
				data.push("res/ui/listskins/2.jpg");
				data.push("res/ui/listskins/3.jpg");
				data.push("res/ui/listskins/4.jpg");
				data.push("res/ui/listskins/5.jpg");
			}
			list.array = data;
		}
		
		private function updateItem(cell:Item, index:int):void 
		{
			cell.setImg(cell.dataSource);
		}
		
		private function onSelect(index:int):void
		{
			trace("当前选择的索引：" + index);
		}
	}
}
import laya.ui.Box;
import laya.ui.Image;
class Item extends Box
{
	public static var WID:int = 373;
	public static var HEI:int = 85;

	private var img:Image;
	
	public function Item()
	{
		size(WID, HEI);
		img = new Image();
		addChild(img);
	}
	
	public function setImg(src:String):void
	{
		img.skin = src;
	}
}
