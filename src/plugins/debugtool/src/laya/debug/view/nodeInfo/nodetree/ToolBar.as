package laya.debug.view.nodeInfo.nodetree 
{
	import laya.debug.data.Base64AtlasManager;
	import laya.debug.ui.debugui.ToolBarUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class ToolBar extends ToolBarUI 
	{
		
		public function ToolBar() 
		{
			super();
			Base64AtlasManager.replaceRes(ToolBarUI.uiView);
			createView(ToolBarUI.uiView);
		}
		override protected function createChildren():void 
		{
			
		}
	}

}