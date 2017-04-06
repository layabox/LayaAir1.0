package laya.debug.view.nodeInfo.views 
{
	import laya.debug.tools.ClassTool;
	import laya.debug.tools.DisControlTool;
	import laya.debug.tools.MathTools;
	import laya.debug.tools.RenderAnalyser;
	import laya.debug.view.nodeInfo.DebugInfoLayer;
	import laya.debug.view.nodeInfo.NodeConsts;
	import laya.debug.view.nodeInfo.menus.NodeMenu;
	import laya.debug.view.nodeInfo.nodetree.Rank;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.ui.List;

	/**
	 * ...
	 * @author ww
	 */
	public class RenderCostRankView extends UIViewBase 
	{
		
		public function RenderCostRankView() 
		{
			super();
			
		}
		private static var _I:RenderCostRankView;
		
		public static function get I():RenderCostRankView
		{
			if (!_I)
				_I = new RenderCostRankView();
			return _I;
		}
		public var view:Rank;
		public static var filterDebugNodes:Boolean = true;
		override public function createPanel():void
		{
			view = new Rank();
			view.top = view.bottom = view.left = view.right = 0;
			addChild(view);
			//DisControlTool.setDragingItem(view.bg, view);
			//view.itemList.on(DebugTool.getMenuShowEvent(), this, onRightClick);
			NodeMenu.I.setNodeListAction(view.itemList);
			view.closeBtn.on(Event.CLICK, this, close);
			view.freshBtn.on(Event.CLICK, this, fresh);
			view.itemList.scrollBar.hide = true;
			view.autoUpdate.on(Event.CHANGE, this, onAutoUpdateChange);
			//dis = view;
			dis = this;
			view.itemList.array = [];
			onAutoUpdateChange();
			fresh();
			Laya.timer.once(5000, this, fresh);
		}
		private function onRightClick():void
		{
			var list:List;
			list = view.itemList;
			if (list.selectedItem) 
			{
				var tarNode:Sprite;
				tarNode = list.selectedItem.path;
				NodeMenu.I.objRightClick(tarNode);			
			}
		}
		private function onAutoUpdateChange():void
		{
			autoUpdate = view.autoUpdate.selected;
		}
		private function set autoUpdate(v:Boolean):void
		{
			Laya.timer.clear(this, fresh);
			if (v)
			{
				fresh();
				Laya.timer.loop(NodeConsts.RenderCostMaxTime, this, fresh);
			}
		}
		public function fresh():void
		{
			view.title.text = "渲染用时排行("+NodeConsts.RenderCostMaxTime+"ms)";
			var nodeDic:Object;
			nodeDic = RenderAnalyser.I.nodeDic;
			var key:String;
			var tNode:Sprite;
			var tData:Object;
			var dataList:Array;
			dataList = [];
			for (key in nodeDic)
			{
				tNode = nodeDic[key];
				if (filterDebugNodes && DisControlTool.isInTree(DebugInfoLayer.I, tNode)) continue;
				if (RenderAnalyser.I.getTime(tNode) <= 0) continue;
				tData = { };
				tData.time = RenderAnalyser.I.getTime(tNode);
				if (filterDebugNodes && tNode == Laya.stage)
				{
					tData.time-= RenderAnalyser.I.getTime(DebugInfoLayer.I);
				}
				tData.path = tNode;
				tData.label = ClassTool.getNodeClassAndName(tNode) + ":" + tData.time;
				dataList.push(tData);
			}
			dataList.sort(MathTools.sortByKey("time", true, true));
			view.itemList.array = dataList;
		}
	}

}