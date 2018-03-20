package laya.debug.view.nodeInfo.nodetree  
{
	import laya.debug.data.Base64AtlasManager;
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.ui.Box;
	import laya.ui.Label;
	import laya.ui.List;
	import laya.ui.Tree;
	import laya.ui.View;
	import laya.utils.Handler;
	
	import laya.debug.tools.ClassTool;
	import laya.debug.DebugTool;
	
	import laya.debug.ui.debugui.NodeTreeUI;
	
	import laya.debug.uicomps.TreeBase;
	
	import laya.debug.view.nodeInfo.NodeUtils;
	import laya.debug.view.nodeInfo.menus.NodeMenu;
	import laya.debug.view.nodeInfo.views.FindSmallView;
	import laya.debug.view.nodeInfo.views.NodeTreeSettingView;
	
	/**
	 * ...
	 * @author ww
	 */
	public class NodeTree extends NodeTreeUI 
	{
		
		public function NodeTree() 
		{
			Base64AtlasManager.replaceRes(NodeTreeUI.uiView);
			View.regComponent("Tree", TreeBase);
			createView(NodeTreeUI.uiView);
			View.regComponent("Tree", Tree);
			inits();
			I = this;
		}
		public static var I:NodeTree;
		override protected function createChildren():void 
		{
			super.viewMapRegists();
		}
		
		private function inits():void
		{
			//nodeTree.list.scrollBar.autoHide = true;
			nodeTree.list.scrollBar.hide = true;
			nodeTree.list.selectEnable = true;
			settingBtn.on(Event.CLICK, this, onSettingBtn);
			freshBtn.on(Event.CLICK, this, fresh);
			closeBtn.on(Event.CLICK, this, onCloseBtn);
			//findBtn.on(Event.CLICK, this, onFindBtn);
			//controlBar.on(Event.MOUSE_DOWN, this, onControlDown);
			fliterTxt.on(Event.ENTER, this, onFliterTxtChange);
			fliterTxt.on(Event.BLUR, this, onFliterTxtChange);
			//nodeTree.on(DebugTool.getMenuShowEvent(), this, onTreeRightMouseDown);
			NodeMenu.I.setNodeListAction(nodeTree.list);
			nodeTree.list.on(Event.CLICK, this, onListClick, [nodeTree.list]);
			//setNodeListDoubleClickAction(list);
		
		
			nodeTree.renderHandler = new Handler(this,treeRender);
			
			_closeSettingHandler = new Handler(this, closeSetting);
			
			//DisControlTool.setResizeAbleEx(this);
			//this.on(Event.CLICK, this, myOnclick);
			onIfShowPropsChange();
			ifShowProps.on(Event.CHANGE, this, onIfShowPropsChange);
		}
		private var showProps:Boolean = false;
		private function onIfShowPropsChange():void
		{
			showProps = ifShowProps.selected;
			fresh();
		}
		private function onListClick(list:List):void
		{
			if (list.selectedItem) 
			{
				if (list.selectedItem.isDirectory)
				{
					list.selectedItem.isOpen = !list.selectedItem.isOpen;
					nodeTree.fresh();
				}
				//_list.array[index].isOpen = !_list.array[index].isOpen;
			   //_list.array = getArray();			
			}
		}
		//private function myOnclick():void
		//{
			//DisResizer.setUp(this);
		//}
		private function onFindBtn():void
		{
			FindSmallView.I.show();
		}
		private function onCloseBtn():void
		{
			removeSelf();
			
		}
		private function onTreeDoubleClick(e:Event):void
		{
			if (nodeTree.selectedItem) 
			{
				var tarNode:Sprite;
				tarNode = nodeTree.selectedItem.path;
				NodeMenu.I.objRightClick(tarNode);
				//if (tarNode is Sprite)
				//{
					//NodeMenu.I.showNodeMenu(nodeTree.selectedItem.path);
				//}else if (tarNode is Object)
				//{
					//NodeMenu.I.showObjectMenu(tarNode);
				//}
				
			}
		}
		private function onTreeRightMouseDown(e:Event):void
		{
			if (nodeTree.selectedItem) 
			{
				var tarNode:Sprite;
				tarNode = nodeTree.selectedItem.path;
				
				NodeMenu.I.objRightClick(tarNode);
				//if (tarNode is Sprite)
				//{
					//NodeMenu.I.showNodeMenu(nodeTree.selectedItem.path);
				//}else if (tarNode is Object)
				//{
					//NodeMenu.I.showObjectMenu(tarNode);
				//}
				
			}
		}
		private function onSettingBtn():void
		{
			NodeTreeSettingView.I.showSetting(showKeys, _closeSettingHandler,_tar);
		}
		private var _closeSettingHandler:Handler;
		public function closeSetting(newKeys:Array):void
		{
			showKeys = newKeys;
			this.fresh();
		}
		private function onFliterTxtChange(e:Event):void {
	
			var key:String;
			key = fliterTxt.text;
			if (key == "") return;
			if (key != showKeys.join(","))
			{
				showKeys = key.split(",");
				fresh();
			}
			return;
			selecteByFile(key);
		}
		public function selecteByFile(key:String):void
		{
			var arr:Array;
			arr=nodeTree.source;
//			debugger;
            var rsts:Array;
			rsts = DebugTool.findNameHas(key,false);
			if (rsts && rsts.length > 0)
			{
				var tar:Sprite;
				tar = rsts[0];
				parseOpen(arr, tar);
			}
			
			
			
		}
		public function showSelectInStage(node:Sprite):void
		{
			setDis(Laya.stage);
			selectByNode(node);
			
		}
		public function selectByNode(node:Sprite):void
		{
			if (!node) return;
			var arr:Array;
			arr = nodeTree.source;
			parseOpen(arr,node);
		}
		public function showNodeList(nodeList:Array):void
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
			nodeTree.array = showList;
		}
		private function parseOpen(tree:Array,node:Sprite):void
		{
			if (tree.length < 1) return;
			if (!node) return;
			var i:int,len:int;
			len=tree.length;
			var tItem:Object;
			
			for(i=0;i<len;i++)
			{
				tItem = tree[i];
				
				if(tItem.path==node)
				{
					var sItem:Object;
				    sItem = tItem;
					while (tItem)
					{
						tItem.isOpen = true;
						nodeTree.fresh();
					    tItem = tItem.nodeParent;
					}
					nodeTree.selectedItem = sItem;
				    return;
				}
			}
		}
		/**
		 * @private
		 * 获取数据源中指定键名的值。
		 */
		private function getFilterSource(array:Array, result:Array, key:String):void {
			key = key.toLocaleLowerCase();
			for each (var item:Object in array) {
				if (item.isDirectory && String(item.label).toLowerCase().indexOf(key) > -1) {
					item.x = 0;
					result.push(item);
				}
				if (item.child && item.child.length > 0) {
					getFilterSource(item.child, result, key);
				}
			}
		}
		private function onControlDown():void
		{
			
			this.startDrag();
		}
		private var _tar:Sprite;
		public static var showKeys:Array = ["x", "y", "width", "height", "renderCost"];
		public static var emptyShowKey:Array = [];
		public function setDis(sprite:Sprite):void
		{
			_tar = sprite;
			fresh();
		}
		public function fresh():void
		{
			//trace("fresh");
			var preTar:Sprite;
			if (nodeTree.selectedItem)
			{
				var tItem:Object;
				tItem = nodeTree.selectedItem;
				while (tItem && (!tItem.path is Sprite))
				{
					tItem = tItem.nodeParent;
				}
				if (tItem && tItem.path)
				{
					preTar = tItem.path;
				}
				
			
			}
			if (!_tar)
			{
				nodeTree.array = [];
				
			}else
			{
				nodeTree.array = NodeUtils.getNodeTreeData(_tar,showProps?showKeys:emptyShowKey);
			}
			if (preTar)
			{
				selectByNode(preTar);
			}
		}
		
		private function treeRender(cell:Box, index:int):void {
			var item:Object = cell.dataSource;
			if (item) {
				var isDirectory:Boolean = item.child || item.isDirectory;
				var label:Label = cell.getChildByName("label") as Label;
				if (item.path is Node)
				{
					label.color = "#09a4f6";
				}else
				{
					if (item.isChilds)
					{
						label.color = "#00ff11";
					}else
					{
						label.color = "#838bc5";
					}
					
				}
			}
		}
	}

}