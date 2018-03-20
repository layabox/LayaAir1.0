package laya.debug.view.nodeInfo.nodetree 
{
	import laya.debug.data.Base64AtlasManager;
	import laya.debug.ui.debugui.FindNodeSmallUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class FindNodeSmall extends FindNodeSmallUI 
	{
		
		public function FindNodeSmall() 
		{
			Base64AtlasManager.replaceRes(FindNodeSmallUI.uiView);
			createView(FindNodeSmallUI.uiView);
		}
		override protected function createChildren():void 
		{
			
		}
		
	}

}