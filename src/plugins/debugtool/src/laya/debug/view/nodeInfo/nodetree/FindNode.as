package laya.debug.view.nodeInfo.nodetree 
{
	import laya.debug.data.Base64AtlasManager;
	
	import laya.debug.ui.debugui.FindNodeUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class FindNode extends FindNodeUI 
	{
		
		public function FindNode() 
		{
			Base64AtlasManager.replaceRes(FindNodeUI.uiView);
			createView(FindNodeUI.uiView);
		}
		override protected function createChildren():void 
		{
			super.viewMapRegists();
		}
	}

}