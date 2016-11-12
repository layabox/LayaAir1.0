package laya.debug.view.nodeInfo.views 
{
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.ui.List;
	import laya.debug.tools.ClassTool;
	import laya.debug.DebugTool;
	import laya.debug.tools.debugUI.DButton;
	import laya.debug.tools.debugUI.DInput;
	import laya.debug.tools.DisControlTool;
	import laya.debug.tools.StringTool;
	import laya.debug.view.nodeInfo.menus.NodeMenu;
	import laya.debug.view.nodeInfo.nodetree.FindNode;
	/**
	 * ...
	 * @author ww
	 */
	public class FindView extends UIViewBase
	{
		
		public function FindView() 
		{
			super();
		}
		private static var _I:FindView;
		public static function get I():FindView
		{
			if (!_I) _I = new FindView();
			return _I;
		}
		public var view:FindNode;
		override public function createPanel():void
		{

			view = new FindNode();		
			DisControlTool.setDragingItem(view.bg, view);
			view.result.scrollBar.hide = true;
			view.result.array = [];
			view.typeSelect.selectedIndex = 1;
			view.closeBtn.on(Event.CLICK, this, close);
			view.findBtn.on(Event.CLICK, this, onFind);
			//view.result.on(DebugTool.getMenuShowEvent(), this, onRightClick);
			NodeMenu.I.setNodeListAction(view.result);
			dis = view;
		}

		private function onRightClick():void
		{
			var list:List;
			list = view.result;
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
		private function onFind():void
		{
			var key:String;
			key = view.findTxt.text;
			key = StringTool.trimSide(key);
			var nodeList:Array;
			if (view.typeSelect.selectedIndex == 0)
			{
				nodeList = DebugTool.findNameHas(key, false);
			}else
			{
				nodeList = DebugTool.findClassHas(Laya.stage, key);
			}
			showFindResult(nodeList);
		}
		private function showFindResult(nodeList:Array):void
		{
			if (!nodeList) return;
			var i:int, len:int;
			len = nodeList.length;
			var showList:Array;
			showList = [];
			var tData:Object;
			var tSprite:Sprite;
			for (i = 0; i < len; i++)
			{
				tSprite = nodeList[i];
				tData = { };
				tData.label = ClassTool.getNodeClassAndName(tSprite);
				tData.path = tSprite;
				showList.push(tData);
			}
			view.result.array = showList;
		}

	}

}