package laya.debug.view.nodeInfo.views 
{
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.ui.List;
	import laya.debug.tools.ClassTool;
	import laya.debug.DebugTool;
	import laya.debug.tools.DisControlTool;
	import laya.debug.view.nodeInfo.menus.NodeMenu;
	import laya.debug.view.nodeInfo.nodetree.SelectInfos;
	/**
	 * ...
	 * @author ww
	 */
	public class SelectInfosView extends UIViewBase 
	{
		
		public function SelectInfosView() 
		{
			super();
			_I = this;
			setSelectList(null);
		}
		private static var _I:SelectInfosView;
		public static function get I():SelectInfosView
		{
			if (!_I) _I = new SelectInfosView();
			return _I;
		}
		public var view:SelectInfos;
		override public function createPanel():void
		{
			view = new SelectInfos();
			addChild(view);
			view.top = view.bottom = view.left = view.right = 0;
			//DisControlTool.setDragingItem(view.bg, view);
			//view.selectList.on(DebugTool.getMenuShowEvent(), this, onRightClick);
			NodeMenu.I.setNodeListAction(view.selectList);
			view.closeBtn.on(Event.CLICK, this, close);
			view.selectList.scrollBar.hide = true;
			dis = null;
			view.findBtn.on(Event.CLICK, this, onFindBtn);
		}
		private function onFindBtn():void
		{
			FindSmallView.I.show();
		}
		private function onRightClick():void
		{
			var list:List;
			list = view.selectList;
			if (list.selectedItem) 
			{
				var tarNode:Sprite;
				tarNode = list.selectedItem.path;
				NodeMenu.I.objRightClick(tarNode);
				//if (tarNode is Sprite)
				//{
					//NodeMenu.I.showNodeMenu(tarNode);
				//}else if (tarNode is Object)
				//{
					//NodeMenu.I.showObjectMenu(tarNode);
				//}
				
			}
		}
		public function setSelectTarget(node:Sprite):void
		{
			if (!node) return;
			setSelectList([node]);
		}
		public function setSelectList(list:Array):void
		{
			if (!list || list.length < 1)
			{
				view.selectList.array = [];
				return;
			}
			var i:int, len:int;
			var tDis:Sprite;
			var tData:Object;
			len = list.length;
			var disList:Array;
			disList = [];
			for (i = 0; i < len; i++)
			{
				tDis = list[i];
				tData = { };
				tData.label = ClassTool.getNodeClassAndName(tDis);
				tData.path = tDis;
				disList.push(tData);
			}
			view.selectList.array = disList;
			//show();
		}
	}

}