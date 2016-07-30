package laya.debug.view.nodeInfo.menus
{
	import laya.debug.tools.VisibleAnalyser;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.ui.List;
	import laya.utils.Browser;
	
	import laya.debug.DebugTool;
	
	import laya.debug.uicomps.ContextMenu;
	import laya.debug.uicomps.ContextMenuItem;
	
	import laya.debug.view.nodeInfo.ToolPanel;
	import laya.debug.view.nodeInfo.views.NodeToolView;
	import laya.debug.view.nodeInfo.views.ObjectInfoView;
	import laya.debug.view.nodeInfo.views.OutPutView;
	import laya.debug.view.nodeInfo.views.SelectInfosView;
	
	/**
	 * ...
	 * @author ww
	 */
	public class NodeMenu
	{
		
		public function NodeMenu()
		{
		
		}
		
		private static var _I:NodeMenu;
		
		public static function get I():NodeMenu
		{
			if (!_I)
				_I = new NodeMenu();
			return _I;
		}
		private var _tar:Object;
		private var _menu:ContextMenu;
		private var _shareBtns:Array = [
		"信息面板", 
		"边框", 
		"进入节点",
		"树定位",
		"Enable链", 
		"Size链", 
		"节点工具", 
		"可见分析",
		"输出到控制台"];
		private var _menuItems:Array = ["隐藏节点"];
		private var _menuHide:ContextMenu;
		private var _menuItemsHide:Array = ["显示节点"];
		
		public function showNodeMenu(node:Sprite):void
		{
			if (!node._style)
			{
				DebugTool.log("该节点已不存在，请刷新列表");
				//alert("该节点已不存在，请刷新列表")
				return;
			}
			_tar = node;
			if (!_menu)
			{
				_menuItems = _menuItems.concat(_shareBtns);
				_menu = ContextMenu.createMenuByArray(_menuItems);
				_menu.on(Event.SELECT, this, onEmunSelect);
				_menuItemsHide = _menuItemsHide.concat(_shareBtns);
				_menuHide = ContextMenu.createMenuByArray(_menuItemsHide);
				_menuHide.on(Event.SELECT, this, onEmunSelect);
			}
			if (node.visible)
			{
				_menu.show();
			}
			else
			{
				_menuHide.show();
			}
		
		}
		
		public function nodeDoubleClick(node:Sprite):void
		{
		    NodeToolView.I.showByNode(node);
		}
		public function setNodeListDoubleClickAction(list:List):void
		{
			if (Browser.onMobile) return;
			list.on(Event.DOUBLE_CLICK, this, onListDoubleClick,[list]);
		}
		private function onListDoubleClick(list:List):void
		{
			if (list.selectedItem) 
			{
				var tarNode:Sprite;
				tarNode = list.selectedItem.path;
				NodeMenu.I.nodeDoubleClick(tarNode);			
			}
		}
		public function setNodeListAction(list:List):void
		{
			list.on(DebugTool.getMenuShowEvent(), this, onListRightClick, [list]);
			//setNodeListDoubleClickAction(list);
		}
		private function onListRightClick(list:List):void
		{
			if (list.selectedItem) 
			{
				var tarNode:Sprite;
				tarNode = list.selectedItem.path;
				NodeMenu.I.objRightClick(tarNode);			
			}
		}
		public function objRightClick(obj:Object):void
		{
			if (obj is Sprite)
			{
				NodeMenu.I.showNodeMenu(obj as Sprite);
			}
			else if (obj is Object)
			{
				NodeMenu.I.showObjectMenu(obj);
			}
		}
		private var _menu1:ContextMenu;
		private var _menuItems1:Array = ["输出到控制台"];
		
		public function showObjectMenu(obj:Object):void
		{
			_tar = obj;
			if (!_menu1)
			{
				_menu1 = ContextMenu.createMenuByArray(_menuItems1);
				_menu1.on(Event.SELECT, this, onEmunSelect);
			}
			_menu1.show();
		}
		
		private function onEmunSelect(e:Event):void
		{
			var data:Object = ContextMenuItem(e.target).data;
			if (data is String)
			{
				var key:String;
				key = data as String;
				//trace("menuDown:",key);
				switch (key)
				{
					case "信息面板": 
						ObjectInfoView.showObject(_tar);
						break;
					case "边框": 
						DebugTool.showDisBound(_tar as Sprite);
						break;
					case "输出到控制台": 
						trace(_tar);
						break;
					case "树节点": 
						ToolPanel.I.showNodeTree(_tar as Sprite);
						break;
					case "进入节点":
						ToolPanel.I.showNodeTree(_tar as Sprite);
						break;
					case "树定位": 
						ToolPanel.I.showSelectInStage(_tar as Sprite);
						break;
					case "Enable链": 
						OutPutView.I.dTrace(DebugTool.traceDisMouseEnable(_tar as Sprite));
					    SelectInfosView.I.setSelectList(DebugTool.selectedNodes);
						break;
					case "Size链": 
						OutPutView.I.dTrace(DebugTool.traceDisSizeChain(_tar as Sprite));
					    SelectInfosView.I.setSelectList(DebugTool.selectedNodes);
						break;
					case "节点工具": 
						NodeToolView.I.showByNode(_tar as Sprite);
						break;
					case "显示节点": 
						_tar.visible = true;
						break;
					case "隐藏节点": 
						_tar.visible = false;
						break;
					case "可见分析": 
						if (_tar)
						{
							VisibleAnalyser.analyseTarget(_tar as Sprite);
						}
						break;
						
				
				}
			}
		}
	}

}