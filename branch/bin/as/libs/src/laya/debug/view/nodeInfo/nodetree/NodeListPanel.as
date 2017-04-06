package laya.debug.view.nodeInfo.nodetree 
{
	import laya.debug.data.Base64AtlasManager;
	import laya.debug.ui.debugui.NodeListPanelUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class NodeListPanel extends NodeListPanelUI 
	{
		
		public function NodeListPanel() 
		{
			Base64AtlasManager.replaceRes(NodeListPanelUI.uiView);
			createView(NodeListPanelUI.uiView);
		}
		override protected function createChildren():void 
		{
			super.viewMapRegists();
		}
		
	}

}