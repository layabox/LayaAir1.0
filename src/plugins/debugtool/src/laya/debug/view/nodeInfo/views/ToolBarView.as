package laya.debug.view.nodeInfo.views 
{
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.debug.DebugTool;
	import laya.debug.tools.DisControlTool;
	import laya.debug.tools.DisplayHook;
	import laya.debug.tools.Notice;
	import laya.debug.view.nodeInfo.DebugInfoLayer;
	import laya.debug.view.nodeInfo.nodetree.ToolBar;
	import laya.debug.view.nodeInfo.NodeUtils;
	import laya.debug.view.nodeInfo.ToolPanel;
	/**
	 * ...
	 * @author ww
	 */
	public class ToolBarView extends UIViewBase
	{
		
		public function ToolBarView() 
		{
			
		}
		private static var _I:ToolBarView;
		public static function get I():ToolBarView
		{
			if (!_I) _I = new ToolBarView();
			return _I;
		}
		public var view:ToolBar;
		override public function createPanel():void
		{
			view = new ToolBar();
			addChild(view);
			DisControlTool.setDragingItem(view.bg, view);
			view.on(Event.CLICK, this, onBtnClick);
			view.minBtn.minHandler = minHandler;
			view.minBtn.maxHandler = maxHandler;
			view.minBtn.tar = view;
			clickSelectChange();
			view.selectWhenClick.on(Event.CHANGE, this, clickSelectChange);
			Notice.listen(DisplayHook.ITEM_CLICKED, this, itemClicked);
			dis = view;
		}
		public static var ignoreDebugTool:Boolean=true;
		private function itemClicked(tar:Sprite):void
		{
			if (!isClickSelectState) return;
			if (DisControlTool.isInTree(view.selectWhenClick, tar)) return;
			if (ignoreDebugTool)
			{
				if (DebugInfoLayer.I.isDebugItem(tar)) return;
			}
			//ToolPanel.I.showNodeTree(tar);
			//NodeToolView.I.showByNode(tar);
		}
		public static var isClickSelectState:Boolean = false;
		private function clickSelectChange():void
		{
			isClickSelectState = view.selectWhenClick.selected;
		}
		
		override public function firstShowFun():void 
		{
			dis.x = Laya.stage.width - dis.width - 20;
			dis.y = 5;
		}
		private function onBtnClick(e:Event):void
		{
			switch(e.target)
			{
				case view.treeBtn:
					ToolPanel.I.switchShow(ToolPanel.Tree);
					break;
				case view.findBtn:
					ToolPanel.I.switchShow(ToolPanel.Find);
					break;
				case view.clearBtn:
					DebugTool.clearDebugLayer();
					break;
				case view.rankBtn:
					RenderCostRankView.I.show();
					break;
				case view.nodeRankBtn:
					ObjectCreateView.I.show();
					break;
				case view.cacheBtn:
					NodeUtils.showCachedSpriteRecs();
					break;
			}
		}
	}

}