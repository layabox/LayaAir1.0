package laya.debug.view.nodeInfo.views 
{
	import laya.debug.tools.DisControlTool;
	import laya.debug.view.nodeInfo.menus.NodeMenu;
	import laya.debug.view.nodeInfo.nodetree.NodeListPanel;
	import laya.events.Event;
	/**
	 * ...
	 * @author ww
	 */
	public class NodeListPanelView extends UIViewBase 
	{
		
		public function NodeListPanelView() 
		{
			super();
			
		}
		private static var _I:NodeListPanelView;
		
		public static function get I():NodeListPanelView
		{
			if (!_I)
				_I = new NodeListPanelView();
			return _I;
		}
		public var view:NodeListPanel;
		public static var filterDebugNodes:Boolean = true;
		override public function createPanel():void
		{
			view = new NodeListPanel();
			//view.top = view.bottom = view.left = view.right = 0;
			addChild(view);
			DisControlTool.setDragingItem(view.bg, view);
			//view.itemList.on(DebugTool.getMenuShowEvent(), this, onRightClick);
			NodeMenu.I.setNodeListAction(view.itemList);
			view.closeBtn.on(Event.CLICK, this, close);
			//view.freshBtn.on(Event.CLICK, this, fresh);
			view.itemList.scrollBar.hide = true;
			//view.autoUpdate.on(Event.CHANGE, this, onAutoUpdateChange);
			//dis = view;
			dis = this;
			view.itemList.array = [];
			//onAutoUpdateChange();
			//fresh();
		}
		public function showList(list:Array):void
		{
			view.itemList.array = list;
			show();
		}
	}

}