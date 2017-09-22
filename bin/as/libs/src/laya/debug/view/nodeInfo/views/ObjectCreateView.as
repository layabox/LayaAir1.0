package laya.debug.view.nodeInfo.views
{
	import laya.debug.DebugTool;
	import laya.debug.tools.CountTool;
	import laya.debug.tools.MathTools;
	import laya.debug.tools.RunProfile;
	import laya.debug.tools.enginehook.ClassCreateHook;
	import laya.debug.uicomps.ContextMenu;
	import laya.debug.uicomps.ContextMenuItem;
	import laya.debug.view.nodeInfo.nodetree.ObjectCreate;
	import laya.events.Event;
	import laya.ui.List;
	
	/**
	 * ...
	 * @author ww
	 */
	public class ObjectCreateView extends UIViewBase
	{
		
		public function ObjectCreateView()
		{
			super();
			_I = this;
		
		}
		private static var _I:ObjectCreateView;
		
		public static function get I():ObjectCreateView
		{
			if (!_I)
				_I = new ObjectCreateView();
			return _I;
		}
		public var view:ObjectCreate;
		
		override public function createPanel():void
		{
			view = new ObjectCreate();
			
			view.top = view.bottom = view.left = view.right = 0;
			addChild(view);
			//DisControlTool.setDragingItem(view.bg, view);
			view.itemList.on(DebugTool.getMenuShowEvent(), this, onRightClick);
			//NodeMenu.I.setNodeListAction(view.itemList);
			view.closeBtn.on(Event.CLICK, this, close);
			view.freshBtn.on(Event.CLICK, this, fresh);
			view.itemList.scrollBar.hide = true;
			//dis = this;
			_menu = ContextMenu.createMenuByArray(_menuItems);
			_menu.on(Event.SELECT, this, onEmunSelect);
			fresh();
		}

		private var _menu:ContextMenu;
		private var _menuItems:Array = ["统计详情", "增量详情"];
		private var _tSelectKey:String;
		
		private function onEmunSelect(e:Event):void
		{
			if (!_tSelectKey) return;
			var data:Object = ContextMenuItem(e.target).data;
			if (data is String)
			{
				var key:String;
				key = data as String;
				//trace("menuDown:", key);
				var count:CountTool;
				switch (key)
				{
					case "统计详情": 
						
						count = RunProfile.getRunInfo(_tSelectKey);
						if (count)
						{
							OutPutView.I.showTxt(_tSelectKey + " createInfo:\n" + count.traceSelfR());
						}
						break;
					case "增量详情":
						
						count = RunProfile.getRunInfo(_tSelectKey);
						if (count)
						{
							OutPutView.I.showTxt(_tSelectKey + " createInfo:\n" + count.traceSelfR(count.changeO));
						}
						break;
				
				}
			}
		}
		
		private function onRightClick():void
		{
			
			var list:List;
			list = view.itemList;
			if (list.selectedItem)
			{
				var tarNode:String;
				tarNode = list.selectedItem.path;
				_tSelectKey = tarNode;
				if (_tSelectKey)
				{
					_menu.show();
				}
				
			}
		}
		
		override public function show():void
		{
			//super.show();
			fresh();
		}
		public var preInfo:Object = {};
		
		public function fresh():void
		{
			var dataO:Object;
			dataO = ClassCreateHook.I.createInfo;
			var key:String;
			var dataList:Array;
			dataList = [];
			var tData:Object;
			var count:CountTool;
			
			for (key in dataO)
			{
				if (!preInfo[key])
					preInfo[key] = 0;
				tData = {};
				tData.path = key;
				tData.count = dataO[key];
				tData.add = dataO[key] - preInfo[key];
				if (tData.add > 0)
				{
					tData.label = key + ":" + dataO[key] + " +" + tData.add;
				}
				else
				{
					tData.label = key + ":" + dataO[key];
				}
				count = RunProfile.getRunInfo(key);
				if (count)
				{
					count.record();
				}
				tData.rank = tData.add * 1000 + tData.count;
				preInfo[key] = dataO[key];
				dataList.push(tData);
			}
			dataList.sort(MathTools.sortByKey("rank", true, true));
			view.itemList.array = dataList;
		}
	}

}