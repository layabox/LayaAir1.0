package laya.debug.view.nodeInfo.views 
{
	import laya.debug.DebugTool;
	import laya.debug.tools.CacheAnalyser;
	import laya.debug.tools.ClassTool;
	import laya.debug.tools.DisControlTool;
	import laya.debug.tools.MathTools;
	import laya.debug.tools.ResTools;
	import laya.debug.view.nodeInfo.DebugInfoLayer;
	import laya.debug.view.nodeInfo.NodeConsts;
	import laya.debug.view.nodeInfo.menus.NodeMenu;
	import laya.debug.view.nodeInfo.nodetree.Rank;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.net.URL;
	import laya.ui.List;
	/**
	 * ...
	 * @author ww
	 */
	public class ResRankView extends UIViewBase 
	{
		
		public function ResRankView() 
		{
			
		}
		private static var _I:ResRankView;
		
		public static function get I():ResRankView
		{
			if (!_I)
				_I = new ResRankView();
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
			//NodeMenu.I.setNodeListAction(view.itemList);
			view.closeBtn.on(Event.CLICK, this, close);
			view.freshBtn.on(Event.CLICK, this, fresh);
			view.itemList.scrollBar.hide = true;
			view.autoUpdate.on(Event.CHANGE, this, onAutoUpdateChange);
			//dis = view;
			dis = this;
			view.itemList.array = [];
			view.itemList.on(Event.RIGHT_CLICK, this, onRightClick);
			onAutoUpdateChange();
			fresh();
		}
		private function onRightClick():void
		{

			var list:List;
			list = view.itemList;
			if (list.selectedItem)
			{
				trace(list.selectedItem["url"]);
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
			
			view.title.text = "图片缓存列表";

			var resList:Array;
			resList = ResTools.getCachedResList();
			var key:String;
			var tNode:Sprite;
			var tData:Object;
			var dataList:Array;
			dataList = [];
			var i:int, len:int;
			len = resList.length;
			for (i = 0; i < len; i++)
			{

				tData = { };
				var tUrl:String;
				tUrl = resList[i];
				tUrl=tUrl.replace(URL.rootPath,"")
				tData.label = tUrl;
				tData.url = tUrl;
				dataList.push(tData);
			}

			//dataList.sort(MathTools.sortByKey("time", true, true));
			view.itemList.array = dataList;
			
		}
	}

}