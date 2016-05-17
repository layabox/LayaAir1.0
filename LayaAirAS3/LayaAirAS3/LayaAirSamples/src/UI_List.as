package
{
	import laya.display.Stage;
	import laya.ui.List;
	import laya.utils.Handler;
	
	public class UI_List
	{
		public function UI_List()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			var list:List = new List();
			
			list.itemRender = Item;
			list.pos(90, 30);
			
			list.repeatX = 1;
			list.repeatY = 4;
			
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
import laya.ui.Label;
class Item extends Box
{
	private var img:Image;
	
	public function Item()
	{
		size(373, 85);
		img = new Image();
		addChild(img);
	}
	
	public function setImg(src:String):void
	{
		img.skin = src;
	}
}
