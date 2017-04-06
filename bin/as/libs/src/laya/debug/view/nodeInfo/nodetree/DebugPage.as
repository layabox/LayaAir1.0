package laya.debug.view.nodeInfo.nodetree 
{
	import laya.debug.data.Base64AtlasManager;
	
	import laya.events.Event;
	import laya.maths.Rectangle;
	
	import laya.debug.tools.DisControlTool;
	
	import laya.debug.ui.debugui.DebugPanelUI;
	/**
	 * ...
	 * @author ww
	 */
	public class DebugPage extends DebugPanelUI 
	{
		private var views:Array;
		public function DebugPage() 
		{
			Base64AtlasManager.replaceRes(DebugPanelUI.uiView);
			createView(DebugPanelUI.uiView);
			DisControlTool.setResizeAbleEx(this);
			views = [treePanel,selectPanel, profilePanel];
			tab.selectedIndex = 0;
			tabChange();
			tab.on(Event.CHANGE, this, tabChange);
			changeSize();
		}
		override protected function createChildren():void 
		{
			super.viewMapRegists();
		}
		private function tabChange():void
		{
			//trace("tabChange:",tab.selectedIndex);
			DisControlTool.addOnlyByIndex(views, tab.selectedIndex, this);
			DisControlTool.setTop(resizeBtn);
		}
		private var msRec:Rectangle=new Rectangle();
		override protected function changeSize():void
		{
			// TODO Auto Generated method stub
			if (this.width < 245)
			{
               this.width = 245;
			   //return;
			}
			if (this.height < 100)
			{
               this.height = 200;
			   //return;
			}
			super.changeSize();
			msRec.setTo(0,0,this.width,this.height);
			this.scrollRect=msRec;
		}
	}

}