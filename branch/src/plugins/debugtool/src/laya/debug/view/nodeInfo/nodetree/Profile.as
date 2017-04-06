package laya.debug.view.nodeInfo.nodetree 
{
	import laya.debug.data.Base64AtlasManager;
	import laya.events.Event;
	
	import laya.debug.tools.DisControlTool;
	
	import laya.debug.ui.debugui.ProfileUI;
	/**
	 * ...
	 * @author ww
	 */
	public class Profile extends ProfileUI 
	{
		private var views:Array;
		public function Profile() 
		{
			super();
			Base64AtlasManager.replaceRes(ProfileUI.uiView);
			createView(ProfileUI.uiView);
			views = [createPanel, renderPanel,cachePanel,resPanel];
			tab.selectedIndex = 0;
			tabChange();
			tab.on(Event.CHANGE, this, tabChange);
		}
		override protected function createChildren():void 
		{
			super.viewMapRegists();
		}
		
		private function tabChange():void
		{
			//trace("tabChange:",tab.selectedIndex);
			DisControlTool.addOnlyByIndex(views,tab.selectedIndex,this);
		}
		
	}

}