package laya.debug.view.nodeInfo.nodetree
{
	import laya.debug.data.Base64AtlasManager;
	
	import laya.debug.ui.debugui.SelectInfosUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class SelectInfos extends SelectInfosUI
	{
		
		public function SelectInfos()
		{
			super();
			
			Base64AtlasManager.replaceRes(SelectInfosUI.uiView);
			createView(SelectInfosUI.uiView);
		}
		
		override protected function createChildren():void
		{
		
			super.viewMapRegists();
		}
	}

}